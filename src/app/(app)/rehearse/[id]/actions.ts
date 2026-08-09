"use server";

import { revalidatePath } from "next/cache";

import { getProfile, requireUser } from "@/lib/auth/dal";
import { describeSelf } from "@/lib/profile/demographics";
import { createClient } from "@/lib/supabase/server";
import type { Rubric, Scenario } from "@/lib/curriculum/types";
import { pickVariant, scenarioFor, type LessonVariant } from "@/lib/curriculum/variants";
import {
  checkRateLimit,
  getPartnerEngine,
  recordAiRequest,
} from "@/lib/roleplay/engine";
import {
  MAX_LINE_CHARS,
  describeWait,
  sceneIsFull,
  turnCap,
} from "@/lib/roleplay/limits";
import { asBeatSpec, isRehearsalMode } from "@/lib/roleplay/modes";
import { PartnerError, type Turn } from "@/lib/roleplay/partner";
import { XP_AWARD, levelForXp } from "@/lib/progress/rules";
import { awardBadges } from "@/lib/progress/snapshot";

export type SayState = { error?: string };

async function loadRoleplay(id: string) {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("roleplays")
    .select(
      "id, lesson_id, transcript_json, status, mode, lessons(scenario_json, rubric_json, rehearsal_spec, variants_json, skill_id)",
    )
    .eq("id", id)
    .maybeSingle();

  if (error || !data) return null;
  return data as unknown as {
    id: string;
    lesson_id: string;
    transcript_json: Turn[];
    status: string;
    mode: string;
    lessons: {
      scenario_json: Scenario;
      rubric_json: Rubric;
      rehearsal_spec: unknown;
      variants_json: LessonVariant[];
      skill_id: string;
    };
  };
}

/**
 * The scene as this reader should get it.
 *
 * Resolved here as well as on the page, and for the more important reason: the
 * page decides what somebody reads, this decides who the model is told to be.
 * A partner swapped in the card and not in the prompt would be worse than not
 * swapping at all.
 */
async function sceneFor(roleplay: {
  lessons: { scenario_json: Scenario; variants_json: LessonVariant[] };
}): Promise<Scenario> {
  const profile = await getProfile();
  const audience = {
    sex: profile?.sex ?? null,
    ageGroup: profile?.age_group ?? null,
    datingInterest: profile?.dating_interest ?? null,
  };

  return scenarioFor(
    roleplay.lessons.scenario_json,
    audience,
    pickVariant(roleplay.lessons.variants_json, audience),
  );
}

/**
 * How many lines this rehearsal accepts, from what the lesson authored.
 *
 * Read on the server for the same reason the count itself is: the cap shown in
 * the UI is a courtesy, and this is the only place it cannot be got around.
 */
function capFor(roleplay: { mode: string; lessons: { rehearsal_spec: unknown } }) {
  const mode = isRehearsalMode(roleplay.mode) ? roleplay.mode : "scene";
  const beats = asBeatSpec(roleplay.lessons.rehearsal_spec);
  return turnCap(mode, beats?.turns.length);
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
  if (message.length > MAX_LINE_CHARS) {
    return { error: "That is longer than anyone speaks. Say it in fewer words." };
  }

  const roleplay = await loadRoleplay(id);
  if (!roleplay) return { error: "That rehearsal could not be found." };
  if (roleplay.status === "complete") {
    return { error: "This scene has already ended." };
  }

  // Checked here and not only in the UI: a disabled textarea is a courtesy,
  // not a limit. This is the only place the count cannot be got around.
  const said = roleplay.transcript_json.filter((t) => t.role === "user").length;
  if (sceneIsFull(said, capFor(roleplay))) {
    return {
      error:
        roleplay.mode === "beat"
          ? "That is the whole sequence. End it and read the review."
          : "This scene has run its course. End it and read the review.",
    };
  }

  const limit = await checkRateLimit(supabase, "partner_turn");
  if (!limit.allowed) {
    return {
      error: `You have hit the limit for now. Try again in ${describeWait(limit.retryAfterMinutes)}.`,
    };
  }

  // Someone who has had five lines refused in an hour is not rehearsing. The
  // refusals themselves are harmless — the model declined — but each one was a
  // paid call, and the pattern is worth stopping rather than serving.
  const refusals = await checkRateLimit(supabase, "refused_turn");
  if (!refusals.allowed) {
    return {
      error: `Your partner has declined too many of these. Rehearsal is paused for ${describeWait(refusals.retryAfterMinutes)}.`,
    };
  }

  const history: Turn[] = [
    ...roleplay.transcript_json,
    { role: "user", content: message, at: new Date().toISOString() },
  ];

  // Recorded before the call, not after. A call that fails may still have cost
  // money, and a failure that does not count against the budget is exactly the
  // shape of bug that runs up a bill in a retry loop. If it cannot be recorded
  // at all, the call does not happen — an uncounted turn is an unlimited one.
  const recorded = await recordAiRequest(supabase, user.id, "partner_turn");
  if (!recorded.ok) {
    return { error: "Rehearsal is unavailable right now. Try again shortly." };
  }

  let reply: string;
  try {
    const engine = getPartnerEngine();
    reply = await engine.nextTurn(await sceneFor(roleplay), history);
  } catch (error) {
    // A refusal is recorded as well as reported. Without the row the limit
    // above can never trip, since nothing else remembers that it happened.
    // The result is not checked here on purpose: the turn has already failed
    // and the user is about to be told so, and recordAiRequest has already
    // logged anything that went wrong with the write itself.
    if (error instanceof PartnerError && error.refused) {
      await recordAiRequest(supabase, user.id, "refused_turn");
    }
    return {
      error:
        error instanceof PartnerError
          ? error.userMessage
          : "Your partner did not respond. Try that line again.",
    };
  }

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
      error: `You have hit the review limit. Try again in ${describeWait(limit.retryAfterMinutes)}.`,
    };
  }

  const recorded = await recordAiRequest(supabase, user.id, "feedback");
  if (!recorded.ok) {
    return { error: "The review is unavailable right now. Try again shortly." };
  }

  // A thrown error and a review the parser rejected are the same thing from
  // here: the scene ends, and the user is told why. Letting a network failure
  // escape would lose the transcript to an error page.
  const engine = getPartnerEngine();
  const profile = await getProfile();
  let result: Awaited<ReturnType<typeof engine.feedback>>;
  try {
    result = await engine.feedback(
      await sceneFor(roleplay),
      roleplay.lessons.rubric_json,
      roleplay.transcript_json,
      describeSelf(profile?.sex ?? null, profile?.age_group ?? null),
    );
  } catch (error) {
    result = {
      ok: false,
      reason:
        error instanceof PartnerError
          ? error.userMessage
          : "The reviewer could not be reached.",
    };
  }

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
