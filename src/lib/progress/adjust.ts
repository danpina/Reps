import "server-only";

import type { SupabaseClient } from "@supabase/supabase-js";

import { levelForXp, replayStreak } from "./rules";

type Client = SupabaseClient;

/**
 * Corrections to progress that has already been awarded.
 *
 * Logging a rep is not a single write. It grants XP against a skill, moves a
 * streak, and can earn a badge. So changing or deleting a rep afterwards means
 * putting those back, and doing it wrong is worse than not offering the button
 * at all: a level that does not match the reps behind it makes the whole
 * record untrustworthy, which is the one thing a training diary cannot be.
 */

/**
 * Moves a skill's XP by a delta and recomputes its level.
 *
 * Floored at zero. XP should never go negative even if the arithmetic drifts —
 * the column has a check constraint that would reject it, and failing a
 * deletion because of a rounding error nobody can see is a bad trade.
 */
export async function adjustSkillXp(
  client: Client,
  userId: string,
  skillId: string,
  delta: number,
): Promise<void> {
  const { data: existing } = await client
    .from("user_skill_state")
    .select("xp, current_lesson_id")
    .eq("skill_id", skillId)
    .maybeSingle();

  // Nothing to take away from, and creating a row at zero to record that
  // absence would be noise.
  if (!existing && delta <= 0) return;

  const nextXp = Math.max(0, (existing?.xp ?? 0) + delta);

  await client.from("user_skill_state").upsert(
    {
      user_id: userId,
      skill_id: skillId,
      xp: nextXp,
      level: levelForXp(nextXp),
      current_lesson_id: existing?.current_lesson_id ?? null,
      updated_at: new Date().toISOString(),
    },
    { onConflict: "user_id,skill_id" },
  );
}

/**
 * Rebuilds the streak from the reps that now exist.
 *
 * Replayed from nothing rather than patched, because a streak is not a counter
 * — it depends on the gaps between days and on how many rest days a given week
 * had left. There is no correct way to subtract one day from the middle of
 * that. Replaying every distinct logged day through the same pure function
 * that built it in the first place produces exactly the streak the user would
 * have had if the deleted rep had never been logged.
 *
 * `longest` is rebuilt too, so a deleted rep can shorten a personal best. That
 * is the honest answer: the record should describe the reps that exist.
 */
export async function recomputeStreak(
  client: Client,
  userId: string,
): Promise<void> {
  const { data } = await client
    .from("field_logs")
    .select("logged_date")
    .order("logged_date");

  const state = replayStreak((data ?? []).map((row) => row.logged_date as string));

  await client.from("streaks").upsert(
    {
      user_id: userId,
      current: state.current,
      longest: state.longest,
      last_active_date: state.lastActiveDate,
      rest_days_used_this_week: state.restDaysUsedThisWeek,
      week_start_date: state.weekStartDate,
      updated_at: new Date().toISOString(),
    },
    { onConflict: "user_id" },
  );
}
