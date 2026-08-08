"use server";

import { redirect } from "next/navigation";

import { requireUser } from "@/lib/auth/dal";
import { rehearsalsLeft } from "@/lib/billing/entitlement";
import { createClient } from "@/lib/supabase/server";
import { checkSceneStartLimit } from "@/lib/roleplay/engine";
import { isRehearsalUnlocked } from "@/lib/roleplay/limits";
import { costsMoney, isRehearsalMode } from "@/lib/roleplay/modes";

/**
 * Opens a rehearsal for a lesson, refusing if the scenario is still locked.
 *
 * The gate is checked here as well as in the UI, because a link is not a
 * permission.
 */
export async function startRehearsal(formData: FormData): Promise<void> {
  const user = await requireUser();
  const supabase = await createClient();

  const lessonId = String(formData.get("lesson_id") ?? "");
  if (!lessonId) redirect("/topics");

  const { data: lesson } = await supabase
    .from("lessons")
    .select("id, sort_order, skill_id, rehearsal_mode, skills(slug)")
    .eq("id", lessonId)
    .maybeSingle();

  if (!lesson) redirect("/topics");

  const mode = isRehearsalMode(lesson.rehearsal_mode)
    ? lesson.rehearsal_mode
    : "scene";

  const { data: state } = await supabase
    .from("user_skill_state")
    .select("level")
    .eq("skill_id", lesson.skill_id)
    .maybeSingle();

  const level = state?.level ?? 1;
  if (!isRehearsalUnlocked(lesson.sort_order, level, mode)) {
    const slug = (lesson as unknown as { skills: { slug: string } }).skills.slug;
    redirect(`/skills/${slug}/${lesson.sort_order}?locked=1`);
  }

  // Reuse an unfinished scene rather than stacking up abandoned ones.
  const { data: open } = await supabase
    .from("roleplays")
    .select("id")
    .eq("lesson_id", lessonId)
    .eq("status", "open")
    .order("started_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (open) redirect(`/rehearse/${open.id}`);

  // Both gates are about money, so both are skipped for a drill. Deliberately
  // below the reuse check as well: resuming a scene you already started costs
  // nothing new, and locking someone out of a conversation they are in the
  // middle of would punish the wrong thing.
  if (costsMoney(mode)) {
    const scenes = await checkSceneStartLimit(supabase);
    if (!scenes.allowed) redirect("/rehearse?limit=1");

    // The insert policy refuses this too. Checking here as well is what turns
    // a failed write into an explanation of what a subscription is.
    const left = await rehearsalsLeft();
    if (left !== null && left <= 0) redirect("/pro?rehearsals=spent");
  }

  const { data: created, error } = await supabase
    .from("roleplays")
    .insert({ user_id: user.id, lesson_id: lessonId, mode })
    .select("id")
    .single();

  if (error || !created) redirect("/topics");
  redirect(`/rehearse/${created.id}`);
}
