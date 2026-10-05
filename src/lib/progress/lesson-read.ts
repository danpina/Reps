import type { SupabaseClient } from "@supabase/supabase-js";

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
 * Takes the client rather than making one, so the website (a cookie session)
 * and the iOS app (a bearer token) run exactly the same rules. Either way the
 * client is the reader's own, so row level security decides what it may touch.
 */
export async function recordLessonRead(
  supabase: SupabaseClient,
  userId: string,
  lessonId: string,
): Promise<void> {
  const { data: lesson } = await supabase
    .from("lessons")
    .select("id, skill_id")
    .eq("id", lessonId)
    .maybeSingle();

  if (!lesson) return;

  // A duplicate here means the card has been read before, which is not an
  // error — it just means no XP this time.
  const { error: sessionError } = await supabase.from("sessions").insert({
    user_id: userId,
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
      user_id: userId,
      skill_id: lesson.skill_id,
      xp,
      level: levelForXp(xp),
      current_lesson_id: lesson.id,
      updated_at: new Date().toISOString(),
    },
    { onConflict: "user_id,skill_id" },
  );
}
