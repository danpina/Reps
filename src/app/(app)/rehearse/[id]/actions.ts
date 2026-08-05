"use server";

import { revalidatePath } from "next/cache";

import { requireUser } from "@/lib/auth/dal";
import { createClient } from "@/lib/supabase/server";
import type { Rubric, Scenario } from "@/lib/curriculum/types";
import {
  checkRateLimit,
  getPartnerEngine,
  recordAiRequest,
} from "@/lib/roleplay/engine";
import type { Turn } from "@/lib/roleplay/partner";
import { XP_AWARD, levelForXp } from "@/lib/progress/rules";
import { awardBadges } from "@/lib/progress/snapshot";

export type SayState = { error?: string };

async function loadRoleplay(id: string) {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("roleplays")
    .select("id, lesson_id, transcript_json, status, lessons(scenario_json, rubric_json, skill_id)")
    .eq("id", id)
    .maybeSingle();

  if (error || !data) return null;
  return data as unknown as {
    id: string;
    lesson_id: string;
    transcript_json: Turn[];
    status: string;
    lessons: { scenario_json: Scenario; rubric_json: Rubric; skill_id: string };
  };
}

/** Adds the user's line, then the partner's reply. */
export async function say(
  _prev: SayState,
  formData: FormData,
): Promise<SayState> {
  const user = await requireUser();
  const supabase = await createClient();

  const id = String(formData.get("roleplay_id") ?? "");
  const message = String(formData.get("message") ?? "").trim();

  if (!message) return { error: "Say something first." };
  if (message.length > 600) return { error: "That is longer than anyone speaks." };

  const roleplay = await loadRoleplay(id);
  if (!roleplay) return { error: "That rehearsal could not be found." };
  if (roleplay.status === "complete") {
    return { error: "This scene has already ended." };
  }

  const limit = await checkRateLimit(supabase, "partner_turn");
  if (!limit.allowed) {
    return {
      error: `You have hit the limit for now. Try again in about ${limit.retryAfterMinutes} minutes.`,
    };
  }

  const history: Turn[] = [
    ...roleplay.transcript_json,
    { role: "user", content: message, at: new Date().toISOString() },
  ];

  let reply: string;
  try {
    const engine = getPartnerEngine();
    reply = await engine.nextTurn(roleplay.lessons.scenario_json, history);
  } catch {
    return { error: "Your partner did not respond. Try that line again." };
  }

  await recordAiRequest(supabase, user.id, "partner_turn");

  const transcript: Turn[] = [
    ...history,
    { role: "partner", content: reply, at: new Date().toISOString() },
  ];

  const { error } = await supabase
    .from("roleplays")
    .update({ transcript_json: transcript })
    .eq("id", id);

  if (error) return { error: "That line did not save. Try again." };

  revalidatePath(`/rehearse/${id}`);
  return {};
}

/** Ends the scene and scores it. */
export async function endScene(
  _prev: SayState,
  formData: FormData,
): Promise<SayState> {
  const user = await requireUser();
  const supabase = await createClient();

  const id = String(formData.get("roleplay_id") ?? "");
  const roleplay = await loadRoleplay(id);
  if (!roleplay) return { error: "That rehearsal could not be found." };
  if (roleplay.status === "complete") return {};

  const userTurns = roleplay.transcript_json.filter((t) => t.role === "user");
  if (userTurns.length === 0) {
    return { error: "Have the conversation first, then end the scene." };
  }

  const limit = await checkRateLimit(supabase, "feedback");
  if (!limit.allowed) {
    return {
      error: `You have hit the review limit. Try again in about ${limit.retryAfterMinutes} minutes.`,
    };
  }

  const engine = getPartnerEngine();
  const result = await engine.feedback(
    roleplay.lessons.scenario_json,
    roleplay.lessons.rubric_json,
    roleplay.transcript_json,
  );

  await recordAiRequest(supabase, user.id, "feedback");

  if (!result.ok) {
    // The scene still closes. Losing the transcript because the review failed
    // would be the worse outcome by far.
    await supabase
      .from("roleplays")
      .update({ status: "complete", completed_at: new Date().toISOString() })
      .eq("id", id);
    revalidatePath(`/rehearse/${id}`);
    return { error: `The review could not be produced: ${result.reason}` };
  }

  await supabase
    .from("roleplays")
    .update({
      status: "complete",
      completed_at: new Date().toISOString(),
      feedback_json: result.feedback,
      scores_json: result.feedback.scores,
    })
    .eq("id", id);

  await awardRoleplayXp(supabase, user.id, roleplay.lessons.skill_id);
  await awardBadges(supabase, user.id);

  revalidatePath(`/rehearse/${id}`);
  revalidatePath("/today");
  return {};
}

type Client = Awaited<ReturnType<typeof createClient>>;

async function awardRoleplayXp(
  supabase: Client,
  userId: string,
  skillId: string,
) {
  const { data: existing } = await supabase
    .from("user_skill_state")
    .select("xp, current_lesson_id")
    .eq("skill_id", skillId)
    .maybeSingle();

  const nextXp = (existing?.xp ?? 0) + XP_AWARD.roleplay;

  await supabase.from("user_skill_state").upsert(
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
