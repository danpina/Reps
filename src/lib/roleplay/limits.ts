/**
 * Rate limits and scenario gating.
 *
 * The AI endpoints are the only part of this app that costs real money per
 * call, so they are limited per user. The numbers below are set for one
 * person practising, not for a crowd: they exist to contain a bug in a loop,
 * not to ration honest use.
 */

export type AiKind = "partner_turn" | "feedback";

export const LIMITS: Record<AiKind, { max: number; windowMinutes: number }> = {
  // A long rehearsal is perhaps thirty turns. Two of those an hour is plenty.
  partner_turn: { max: 60, windowMinutes: 60 },
  // Feedback is one call per completed scene, and each is more expensive.
  feedback: { max: 15, windowMinutes: 60 },
};

export type LimitVerdict =
  | { allowed: true; remaining: number }
  | { allowed: false; retryAfterMinutes: number };

/**
 * @param timestamps When previous calls of this kind were made.
 * @param now        Injected so this stays a pure function under test.
 */
export function checkLimit(
  kind: AiKind,
  timestamps: Date[],
  now: Date = new Date(),
): LimitVerdict {
  const { max, windowMinutes } = LIMITS[kind];
  const windowMs = windowMinutes * 60_000;
  const cutoff = now.getTime() - windowMs;

  const inWindow = timestamps
    .map((t) => t.getTime())
    .filter((t) => t > cutoff)
    .sort((a, b) => a - b);

  if (inWindow.length < max) {
    return { allowed: true, remaining: max - inWindow.length };
  }

  // The window frees up when the oldest call inside it falls out.
  const oldest = inWindow[0];
  const freesAt = oldest + windowMs;
  return {
    allowed: false,
    retryAfterMinutes: Math.max(1, Math.ceil((freesAt - now.getTime()) / 60_000)),
  };
}

/**
 * Which per-skill level a lesson's rehearsal requires.
 *
 * The brief asks that level-ups unlock harder scenarios rather than cosmetics.
 * Since levels come overwhelmingly from logged field missions, this means the
 * later rehearsals are opened by going out and having real conversations,
 * which is the ordering the whole product argues for.
 */
export function requiredLevelForLesson(sortOrder: number): number {
  return Math.max(1, Math.ceil(sortOrder / 2));
}

export function isRehearsalUnlocked(
  sortOrder: number,
  skillLevel: number,
): boolean {
  return skillLevel >= requiredLevelForLesson(sortOrder);
}
