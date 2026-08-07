"use server";

import { revalidatePath } from "next/cache";

import { getProfile, requireUser } from "@/lib/auth/dal";
import { isPro } from "@/lib/billing/entitlement";
import { readTheLog } from "@/lib/coach/engine";
import { getCoachState, getUnreadReps } from "@/lib/coach/queries";
import { checkRateLimit, recordAiRequest } from "@/lib/roleplay/engine";
import { describeWait } from "@/lib/roleplay/limits";
import { createClient } from "@/lib/supabase/server";

export type CoachActionState = { error?: string };

/**
 * Reads everything logged since the last review, and writes a new one.
 *
 * The order of the checks is the order of what they cost. Entitlement and
 * eligibility are free and are checked first; the ledger write comes before
 * the call, because a call that cannot be counted must not be made; and the
 * review row is written last, since it is what moves the watermark and a
 * watermark moved past reps nobody read would lose them permanently.
 */
export async function runReview(
  _prev: CoachActionState,
  formData: FormData,
): Promise<CoachActionState> {
  const user = await requireUser();

  if (!(await isPro())) {
    return { error: "A read of your log is part of the subscription." };
  }

  const state = await getCoachState();

  // The watermark the page was rendered against. Two tabs open, both showing
  // the button, and the second one would otherwise pay for a read of reps the
  // first has already covered.
  const seenWatermark = String(formData.get("since") ?? "");
  if (seenWatermark !== (state.latest?.coversThrough ?? "")) {
    return {
      error: "Your log has been read since this page loaded. Reload to see it.",
    };
  }

  if (state.eligibility.state === "locked") {
    return {
      error: `Log ${state.eligibility.repsNeeded} more ${
        state.eligibility.repsNeeded === 1 ? "conversation" : "conversations"
      } first. There is no pattern in fewer than ten.`,
    };
  }

  if (state.eligibility.state === "waiting") {
    return {
      error: `Only ${state.eligibility.newReps} new since the last read. Have ${state.eligibility.newRepsNeeded} more and there will be something new to say.`,
    };
  }

  const supabase = await createClient();

  const limit = await checkRateLimit(supabase, "rep_review");
  if (!limit.allowed) {
    return {
      error: `That is enough reads for now. Try again in ${describeWait(limit.retryAfterMinutes)}.`,
    };
  }

  const profile = await getProfile();

  const { reps, capped, newest } = await getUnreadReps(
    state.latest?.coversThrough ?? null,
    profile?.age_group ?? null,
  );

  if (reps.length === 0 || !newest) {
    return { error: "There is nothing new to read." };
  }

  // Counted before the call rather than after it. A call that cannot be
  // written to the ledger is a call the limits will never see.
  const counted = await recordAiRequest(supabase, user.id, "rep_review");
  if (!counted.ok) {
    return { error: "That could not be started right now. Try again shortly." };
  }

  const result = await readTheLog({
    reps,
    previous: state.latest?.review ?? null,
    repsTotal: state.repsTotal,
    capped,
    coachee: {
      sex: profile?.sex ?? null,
      ageGroup: profile?.age_group ?? null,
    },
  });

  if (!result.ok) return { error: result.reason };

  const { error } = await supabase.from("rep_reviews").insert({
    user_id: user.id,
    review_json: result.review,
    covers_through: newest,
    reps_read: reps.length,
    reps_total: state.repsTotal,
    previous_review_id: state.latest?.id ?? null,
  });

  if (error) {
    return { error: "The read was produced but could not be saved. Try again." };
  }

  revalidatePath("/coach");
  return {};
}
