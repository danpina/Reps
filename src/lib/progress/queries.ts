import "server-only";

import { createClient } from "@/lib/supabase/server";
import type { Badge } from "./badges";
import { levelProgress, toIsoDate, weekStart, type LevelProgress } from "./rules";

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
  /** The user's own calendar day, independent of the server's timezone. */
  logged_date: string;
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
      "id, skill_id, lesson_id, mission_text, context_note, went, reflection, xp_awarded, logged_at, logged_date, skills(slug, name)",
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

export type ResumePoint = {
  skillSlug: string;
  skillName: string;
  lessonTitle: string;
  lessonSortOrder: number;
  /** The next lesson in the track, when there is one. */
  nextSortOrder: number | null;
};

/**
 * The lesson to offer getting back into.
 *
 * Without this the dashboard gave no way back to whatever you were part-way
 * through, and the only route was remembering the URL.
 */
export async function getResumePoint(): Promise<ResumePoint | null> {
  const supabase = await createClient();

  const { data } = await supabase
    .from("user_skill_state")
    .select(
      "updated_at, current_lesson_id, lessons!user_skill_state_current_lesson_id_fkey(title, sort_order, skill_id, skills(slug, name))",
    )
    .not("current_lesson_id", "is", null)
    .order("updated_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (!data?.current_lesson_id) return null;

  const lesson = (data as unknown as {
    lessons: {
      title: string;
      sort_order: number;
      skill_id: string;
      skills: { slug: string; name: string };
    } | null;
  }).lessons;

  if (!lesson) return null;

  const { count } = await supabase
    .from("lessons")
    .select("id", { count: "exact", head: true })
    .eq("skill_id", lesson.skill_id);

  const total = count ?? 0;

  return {
    skillSlug: lesson.skills.slug,
    skillName: lesson.skills.name,
    lessonTitle: lesson.title,
    lessonSortOrder: lesson.sort_order,
    nextSortOrder: lesson.sort_order < total ? lesson.sort_order + 1 : null,
  };
}

export type HeatmapDay = { date: string; count: number };

/**
 * One entry per day for the last `weeks` weeks, oldest first, starting on a
 * Monday so the grid has clean columns.
 */
export async function getHeatmap(weeks = 12): Promise<HeatmapDay[]> {
  const supabase = await createClient();

  const { data } = await supabase
    .from("field_logs")
    .select("logged_date")
    .order("logged_date");

  // logged_date is already the user's own calendar day, so no conversion here.
  const counts = new Map<string, number>();
  for (const row of data ?? []) {
    counts.set(row.logged_date, (counts.get(row.logged_date) ?? 0) + 1);
  }

  const today = new Date();
  const start = new Date(weekStart(toIsoDate(today)));
  start.setDate(start.getDate() - (weeks - 1) * 7);

  const days: HeatmapDay[] = [];
  for (const cursor = new Date(start); cursor <= today; cursor.setDate(cursor.getDate() + 1)) {
    const date = toIsoDate(cursor);
    days.push({ date, count: counts.get(date) ?? 0 });
  }

  return days;
}

export type EarnedBadge = Badge & { earned_at: string };

export async function getBadges(): Promise<{
  earned: EarnedBadge[];
  locked: Badge[];
}> {
  const supabase = await createClient();

  const [{ data: all }, { data: mine }] = await Promise.all([
    supabase.from("badges").select("*").order("sort_order"),
    supabase.from("user_badges").select("badge_id, earned_at"),
  ]);

  const earnedAt = new Map(
    (mine ?? []).map((r) => [r.badge_id, r.earned_at as string]),
  );

  const badges = (all ?? []) as Badge[];
  return {
    earned: badges
      .filter((b) => earnedAt.has(b.id))
      .map((b) => ({ ...b, earned_at: earnedAt.get(b.id)! })),
    locked: badges.filter((b) => !earnedAt.has(b.id)),
  };
}

export type WeeklyReview = {
  weekStart: string;
  reps: number;
  skillsTouched: string[];
  /** The worst-rated rep of the week that has not been rewritten yet. */
  worstRep: FieldLogEntry | null;
};

export async function getWeeklyReview(): Promise<WeeklyReview> {
  const supabase = await createClient();

  const start = weekStart(toIsoDate(new Date()));

  const { data } = await supabase
    .from("field_logs")
    .select(
      "id, skill_id, lesson_id, mission_text, context_note, went, reflection, rewrite, xp_awarded, logged_at, logged_date, skills(slug, name)",
    )
    // Compared against the user's own calendar day, so a rep logged late on a
    // Sunday evening cannot fall into next week on a UTC host.
    .gte("logged_date", start)
    .order("went")
    .order("logged_at", { ascending: false });

  const entries = (data ?? []) as unknown as (FieldLogEntry & {
    rewrite: string | null;
  })[];

  return {
    weekStart: start,
    reps: entries.length,
    skillsTouched: [
      ...new Set(entries.map((e) => e.skills?.name).filter(Boolean) as string[]),
    ],
    // Ordered by `went` ascending, so the first unrewritten entry is the worst.
    worstRep: entries.find((e) => !e.rewrite?.trim()) ?? null,
  };
}
