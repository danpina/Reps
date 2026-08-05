"use server";

import { requireUser } from "@/lib/auth/dal";
import { createClient } from "@/lib/supabase/server";
import { XP_AWARD, levelForXp } from "@/lib/progress/rules";

/**
 * Records that a lesson has been read.
 *
 * Two jobs, both of which were missing. It awards the theory XP the brief
 * specifies, exactly once per lesson — the unique index on sessions is what
 * enforces that, so re-reading a card never pays again. And it remembers the
 * lesson as the current one for its skill, which is what lets the dashboard
 * offer a way back in.
 *
 * Called from the client on mount rather than during render, because a page
 * render must not have side effects.
 */
export async function markLessonRead(lessonId: string): Promise<void> {
  const user = await requireUser();
  const supabase = await createClient();

  const { data: lesson } = await supabase
    .from("lessons")
    .select("id, skill_id")
    .eq("id", lessonId)
    .maybeSingle();

  if (!lesson) return;

  // A duplicate here means the card has been read before, which is not an
  // error — it just means no XP this time.
  const { error: sessionError } = await supabase.from("sessions").insert({
    user_id: user.id,
    lesson_id: lesson.id,
    kind: "theory",
    completed_at: new Date().toISOString(),
    xp_awarded: XP_AWARD.theory,
  });

  const firstRead = !sessionError;

  const { data: state } = await supabase
    .from("user_skill_state")
    .select("xp")
    .eq("skill_id", lesson.skill_id)
    .maybeSingle();

  const xp = (state?.xp ?? 0) + (firstRead ? XP_AWARD.theory : 0);

  await supabase.from("user_skill_state").upsert(
    {
      user_id: user.id,
      skill_id: lesson.skill_id,
      xp,
      level: levelForXp(xp),
      current_lesson_id: lesson.id,
      updated_at: new Date().toISOString(),
    },
    { onConflict: "user_id,skill_id" },
  );
}
