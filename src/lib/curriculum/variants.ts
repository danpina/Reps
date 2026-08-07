import type { AgeGroup, Sex } from "@/lib/profile/demographics";
import type { WorkedExample } from "./types";

/**
 * Choosing which version of a lesson someone should read.
 *
 * Pure and deterministic, because the alternative — deciding this inside a
 * page — makes it impossible to answer "why did I get this one" without
 * running the app. It is also the sort of rule that goes subtly wrong: a
 * matcher that is slightly too eager shows a man advice written for women, and
 * nobody reports that, they just conclude the app is stupid.
 */

export type DatingInterest = "men" | "women" | "both";

/** Who is reading. Every field optional — most readers have answered nothing. */
export type Audience = {
  sex: Sex | null;
  ageGroup: AgeGroup | null;
  datingInterest: DatingInterest | null;
};

export type VariantConditions = {
  sex?: Sex;
  dating_interest?: DatingInterest;
  age_group?: AgeGroup;
};

export type LessonVariant = {
  when: VariantConditions;
  /** Shown as the heading of the passage, so the reader knows why it is here. */
  label: string;
  /** An extra passage, added to the lesson rather than replacing it. */
  note_md?: string;
  /** Replaces the worked examples entirely, when the general ones do not fit. */
  examples_json?: WorkedExample[];
  /** The rehearsal partner this reader should get. */
  partner_sex?: Sex;
};

/**
 * How well a variant fits a reader, or null if it does not fit at all.
 *
 * A condition the reader has not answered is a miss, not a pass. Someone who
 * declined to say their sex must not be shown a passage written for men on the
 * strength of the app guessing — the general lesson is correct for everybody,
 * which is why it is the general lesson.
 *
 * The one deliberate exception is dating interest: a reader who said "both"
 * genuinely is part of the audience for a passage about approaching men and
 * for one about approaching women. They match either, more weakly than someone
 * who named one, so an explicit "both" variant still wins when it exists.
 */
export function scoreVariant(
  conditions: VariantConditions,
  audience: Audience,
): number | null {
  let score = 0;

  if (conditions.sex !== undefined) {
    if (audience.sex !== conditions.sex) return null;
    score += 2;
  }

  if (conditions.age_group !== undefined) {
    if (audience.ageGroup !== conditions.age_group) return null;
    score += 2;
  }

  if (conditions.dating_interest !== undefined) {
    if (audience.datingInterest === conditions.dating_interest) score += 2;
    else if (audience.datingInterest === "both") score += 1;
    else return null;
  }

  return score;
}

/**
 * The best-fitting variant, or null when the lesson as written is the right
 * one — which is the common case, and the case every lesson must still work in.
 */
export function pickVariant(
  variants: LessonVariant[] | null | undefined,
  audience: Audience,
): LessonVariant | null {
  if (!variants?.length) return null;

  let best: LessonVariant | null = null;
  let bestScore = 0;

  for (const variant of variants) {
    const score = scoreVariant(variant.when ?? {}, audience);
    // Strictly greater, so the first of two equally specific variants wins and
    // the order they were written in decides. Ties should be rare; when they
    // happen, seed order is at least something an author can see.
    if (score !== null && score > bestScore) {
      best = variant;
      bestScore = score;
    }
  }

  return best;
}

/**
 * Which sex the rehearsal partner should be for this reader.
 *
 * Only ever answered from what someone actually said. A user who has not told
 * the app who they date gets the partner the lesson was written with, because
 * inferring it from their own sex would be assuming they are straight — and
 * being wrong about that in a dating rehearsal is worse than the scene being
 * generic.
 */
export function partnerSexFor(
  audience: Audience,
  authored: Sex | undefined,
): Sex | undefined {
  if (audience.datingInterest === "men") return "male";
  if (audience.datingInterest === "women") return "female";
  return authored;
}
