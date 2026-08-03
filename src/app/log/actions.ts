"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";

import { requireUser } from "@/lib/auth/dal";
import { createClient } from "@/lib/supabase/server";
import {
  XP_AWARD,
  applyActivity,
  levelForXp,
  toIsoDate,
  type StreakState,
} from "@/lib/progress/rules";

export type LogRepState = { error?: string };

/**
 * The client sends its own local date so a rep logged late at night counts for
 * the day the user actually had it. Clamped to within a day of the server's
 * date, so a wrong clock cannot invent streak days.
 */
function resolveLoggedDate(submitted: FormDataEntryValue | null): string {
  const serverToday = toIsoDate(new Date());
  if (typeof submitted !== "string" || !/^\d{4}-\d{2}-\d{2}$/.test(submitted)) {
    return serverToday;
  }

  const diff = Math.abs(
    (new Date(submitted).getTime() - new Date(serverToday).getTime()) /
      86_400_000,
  );
  return diff <= 1 ? submitted : serverToday;
}

export async function logRep(
  _prev: LogRepState,
  formData: FormData,
): Promise<LogRepState> {
  const user = await requireUser();
  const supabase = await createClient();

  const skillId = String(formData.get("skill_id") ?? "").trim();
  const went = Number(formData.get("went"));
  const lessonId = String(formData.get("lesson_id") ?? "").trim() || null;
  const missionText = String(formData.get("mission_text") ?? "").trim() || null;
  const contextNote = String(formData.get("context_note") ?? "").trim() || null;
  const reflection = String(formData.get("reflection") ?? "").trim() || null;

  if (!skillId) return { error: "Pick which skill this rep was for." };
  if (![1, 2, 3].includes(went)) return { error: "Say how it went." };

  const today = resolveLoggedDate(formData.get("local_date"));

  // A logged failure earns the same as a logged success. If a bad rep cost
  // points, people would stop logging honestly and the log would be worthless.
  const xp = XP_AWARD.mission;

  const { error: insertError } = await supabase.from("field_logs").insert({
    user_id: user.id,
    skill_id: skillId,
    lesson_id: lessonId,
    mission_text: missionText,
    context_note: contextNote,
    went,
    reflection,
    xp_awarded: xp,
    logged_at: new Date().toISOString(),
  });

  if (insertError) {
    return { error: `That did not save: ${insertError.message}` };
  }

  await Promise.all([
    awardSkillXp(supabase, user.id, skillId, xp, lessonId),
    advanceStreak(supabase, user.id, today),
  ]);

  revalidatePath("/field-log");
  revalidatePath("/today");
  redirect("/field-log?logged=1");
}

type Client = Awaited<ReturnType<typeof createClient>>;

async function awardSkillXp(
  supabase: Client,
  userId: string,
  skillId: string,
  xp: number,
  lessonId: string | null,
) {
  const { data: existing } = await supabase
    .from("user_skill_state")
    .select("xp, current_lesson_id")
    .eq("skill_id", skillId)
    .maybeSingle();

  const nextXp = (existing?.xp ?? 0) + xp;

  await supabase.from("user_skill_state").upsert(
    {
      user_id: userId,
      skill_id: skillId,
      xp: nextXp,
      level: levelForXp(nextXp),
      current_lesson_id: lessonId ?? existing?.current_lesson_id ?? null,
      updated_at: new Date().toISOString(),
    },
    { onConflict: "user_id,skill_id" },
  );
}

async function advanceStreak(
  supabase: Client,
  userId: string,
  todayIso: string,
) {
  const { data } = await supabase
    .from("streaks")
    .select("current, longest, last_active_date, rest_days_used_this_week, week_start_date")
    .maybeSingle();

  const state: StreakState = {
    current: data?.current ?? 0,
    longest: data?.longest ?? 0,
    lastActiveDate: data?.last_active_date ?? null,
    restDaysUsedThisWeek: data?.rest_days_used_this_week ?? 0,
    weekStartDate: data?.week_start_date ?? null,
  };

  const next = applyActivity(state, todayIso);

  await supabase.from("streaks").upsert(
    {
      user_id: userId,
      current: next.current,
      longest: next.longest,
      last_active_date: next.lastActiveDate,
      rest_days_used_this_week: next.restDaysUsedThisWeek,
      week_start_date: next.weekStartDate,
      updated_at: new Date().toISOString(),
    },
    { onConflict: "user_id" },
  );
}
