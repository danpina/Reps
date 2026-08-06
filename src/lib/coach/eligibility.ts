/**
 * When a read of the log is worth asking for.
 *
 * Two separate gates, for two different reasons.
 *
 * The first is about evidence. Three reps do not contain a pattern, they
 * contain three anecdotes, and a review written over them would be a
 * confident-sounding invention. Ten is the point where something recurring can
 * honestly be claimed.
 *
 * The second is about repetition and cost. Once a review exists, running
 * another one over two new conversations produces the previous review with
 * different adjectives, and pays for the privilege. So a follow-up waits until
 * there is enough new material to have something new to say.
 */

export const MIN_REPS_FOR_REVIEW = 10;
export const MIN_NEW_REPS_FOR_REVIEW = 5;

/**
 * The most reps sent in a single call.
 *
 * Bounds the prompt. Someone returning after three months should not trigger a
 * request several times the size of a normal one, and the most recent forty
 * conversations are where the useful signal is anyway — a pattern from last
 * spring is history rather than feedback.
 */
export const MAX_REPS_PER_REVIEW = 40;

export type Eligibility =
  /** Not enough reps have ever been logged. */
  | { state: "locked"; repsNeeded: number }
  /** A review exists and not enough has happened since. */
  | { state: "waiting"; newReps: number; newRepsNeeded: number }
  /** Ready to run, over this many unread reps. */
  | { state: "ready"; newReps: number; capped: boolean };

export function eligibility({
  repsTotal,
  repsSinceLastReview,
  hasReview,
}: {
  repsTotal: number;
  /** Reps logged after the last review's watermark. Equals repsTotal if none. */
  repsSinceLastReview: number;
  hasReview: boolean;
}): Eligibility {
  if (repsTotal < MIN_REPS_FOR_REVIEW) {
    return { state: "locked", repsNeeded: MIN_REPS_FOR_REVIEW - repsTotal };
  }

  // The first review reads everything it can. Only follow-ups have to clear
  // the new-material bar, because the first one has nothing to repeat.
  if (hasReview && repsSinceLastReview < MIN_NEW_REPS_FOR_REVIEW) {
    return {
      state: "waiting",
      newReps: repsSinceLastReview,
      newRepsNeeded: MIN_NEW_REPS_FOR_REVIEW - repsSinceLastReview,
    };
  }

  return {
    state: "ready",
    newReps: repsSinceLastReview,
    capped: repsSinceLastReview > MAX_REPS_PER_REVIEW,
  };
}
