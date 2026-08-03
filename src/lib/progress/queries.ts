import "server-only";

import { createClient } from "@/lib/supabase/server";
import { levelProgress, type LevelProgress } from "./rules";

export type FieldLogEntry = {
  id: string;
  skill_id: string;
  lesson_id: string | null;
  mission_text: string | null;
  context_note: string | null;
  went: number;
  reflection: string | null;
  xp_awarded: number;
  logged_at: string;
  skills: { slug: string; name: string } | null;
};

export type FieldLogFilters = {
  skillSlug?: string;
  went?: number;
};

export async function getFieldLog(
  filters: FieldLogFilters = {},
): Promise<FieldLogEntry[]> {
  const supabase = await createClient();

  let query = supabase
    .from("field_logs")
    .select(
      "id, skill_id, lesson_id, mission_text, context_note, went, reflection, xp_awarded, logged_at, skills(slug, name)",
    )
    .order("logged_at", { ascending: false });

  if (filters.went) query = query.eq("went", filters.went);

  const { data, error } = await query;
  if (error) throw new Error(`Could not load the field log: ${error.message}`);

  const entries = (data ?? []) as unknown as FieldLogEntry[];

  // Filtering by slug after the fact keeps the query simple, and a personal
  // log is never large enough for this to matter.
  return filters.skillSlug
    ? entries.filter((e) => e.skills?.slug === filters.skillSlug)
    : entries;
}

export type Totals = {
  repsLogged: number;
  totalXp: number;
  global: LevelProgress;
  currentStreak: number;
  longestStreak: number;
};

export async function getTotals(): Promise<Totals> {
  const supabase = await createClient();

  const [{ data: states }, { data: streak }, { count }] = await Promise.all([
    supabase.from("user_skill_state").select("xp"),
    supabase
      .from("streaks")
      .select("current, longest")
      .maybeSingle(),
    supabase.from("field_logs").select("id", { count: "exact", head: true }),
  ]);

  const totalXp = (states ?? []).reduce((sum, s) => sum + (s.xp ?? 0), 0);

  return {
    repsLogged: count ?? 0,
    totalXp,
    global: levelProgress(totalXp),
    currentStreak: streak?.current ?? 0,
    longestStreak: streak?.longest ?? 0,
  };
}

export type SkillStanding = {
  skill_id: string;
  slug: string;
  name: string;
  sort_order: number;
  reps: number;
  progress: LevelProgress;
};

export async function getSkillStandings(): Promise<SkillStanding[]> {
  const supabase = await createClient();

  const [{ data: skills }, { data: states }, { data: logs }] = await Promise.all([
    supabase.from("skills").select("id, slug, name, sort_order").order("sort_order"),
    supabase.from("user_skill_state").select("skill_id, xp"),
    supabase.from("field_logs").select("skill_id"),
  ]);

  const xpBySkill = new Map((states ?? []).map((s) => [s.skill_id, s.xp ?? 0]));
  const repsBySkill = new Map<string, number>();
  for (const log of logs ?? []) {
    repsBySkill.set(log.skill_id, (repsBySkill.get(log.skill_id) ?? 0) + 1);
  }

  return (skills ?? []).map((skill) => ({
    skill_id: skill.id,
    slug: skill.slug,
    name: skill.name,
    sort_order: skill.sort_order,
    reps: repsBySkill.get(skill.id) ?? 0,
    progress: levelProgress(xpBySkill.get(skill.id) ?? 0),
  }));
}
