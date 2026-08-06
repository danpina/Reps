/**
 * Rate limits and scenario gating.
 *
 * The AI endpoints are the only part of this app that costs real money per
 * call, so they are limited per user. The numbers below are set for one
 * person practising, not for a crowd: they exist to contain a bug in a loop,
 * not to ration honest use.
 */

export type AiKind =
  | "partner_turn"
  | "feedback"
  | "refused_turn"
  | "rep_review";

export const LIMITS: Record<AiKind, { max: number; windowMinutes: number }> = {
  // A long rehearsal is perhaps thirty turns. Two of those an hour is plenty.
  partner_turn: { max: 60, windowMinutes: 60 },
  // Feedback is one call per completed scene, and each is more expensive.
  feedback: { max: 15, windowMinutes: 60 },
  // Refusals are counted separately and much more tightly. One is an accident
  // — a clumsy line, a subject the character will not touch. A run of them is
  // someone working the model rather than practising, and the cheapest answer
  // is to stop answering. The call has already been paid for either way.
  refused_turn: { max: 5, windowMinutes: 60 },
  // A read of the whole log is the most expensive call the app makes, and it
  // is also the one there is least reason to repeat: the answer cannot change
  // until more conversations have happened. The eligibility rules already
  // require new material, so this is the backstop for a button pressed twice
  // rather than a ration.
  rep_review: { max: 3, windowMinutes: 24 * 60 },
};

/**
 * How many lines one person may say in a single scene.
 *
 * This is a product decision before it is a cost one. Small talk that needs
 * more than fourteen turns has stopped being small talk, and the review is
 * where the learning actually happens — a scene that never ends is a lesson
 * that never lands.
 *
 * It also closes the one gap the hourly limits cannot. The whole transcript is
 * re-sent on every turn, so cost per turn climbs as a scene grows: sixty turns
 * inside one conversation costs several times sixty turns spread across five.
 * Capping the length caps the shape of the bill, not just its rate.
 */
export const MAX_TURNS_PER_SCENE = 14;

/**
 * How long one spoken line may be.
 *
 * A single SMS, which is a good deal more than anyone says in one breath.
 * Small talk is short by definition, and a box that invites a paragraph
 * teaches the wrong thing before a single word is scored — the skill being
 * drilled is saying less, not writing more.
 *
 * It bounds the input side of the bill too: this is the only text a user
 * controls, and it is re-sent with every subsequent turn of the scene.
 */
export const MAX_LINE_CHARS = 160;

/** How many scenes may be started in a rolling day. */
export const MAX_SCENES_PER_DAY = 5;

const SCENE_WINDOW_MINUTES = 24 * 60;

export type LimitVerdict =
  | { allowed: true; remaining: number }
  | { allowed: false; retryAfterMinutes: number };

/**
 * How many more lines this scene will accept. Zero means it is finished
 * whether or not the user has ended it.
 */
export function turnsLeftInScene(userTurnsSoFar: number): number {
  return Math.max(0, MAX_TURNS_PER_SCENE - userTurnsSoFar);
}

export function sceneIsFull(userTurnsSoFar: number): boolean {
  return turnsLeftInScene(userTurnsSoFar) === 0;
}

/**
 * The sliding-window count shared by every limit here.
 *
 * Sliding rather than calendar-aligned on purpose: a midnight reset is a cliff
 * that rewards waiting it out, and it makes the limit behave differently
 * depending on which timezone the server thinks it is in.
 */
function verdictFor(
  timestamps: Date[],
  max: number,
  windowMinutes: number,
  now: Date,
): LimitVerdict {
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
 * @param timestamps When previous calls of this kind were made.
 * @param now        Injected so this stays a pure function under test.
 */
export function checkLimit(
  kind: AiKind,
  timestamps: Date[],
  now: Date = new Date(),
): LimitVerdict {
  const { max, windowMinutes } = LIMITS[kind];
  return verdictFor(timestamps, max, windowMinutes, now);
}

/**
 * Whether another scene may be started, given when the recent ones began.
 */
export function checkSceneLimit(
  startedAt: Date[],
  now: Date = new Date(),
): LimitVerdict {
  return verdictFor(startedAt, MAX_SCENES_PER_DAY, SCENE_WINDOW_MINUTES, now);
}

/**
 * A wait a person can read. The scene limit runs to hours, and "try again in
 * about 847 minutes" is a number, not an answer.
 */
export function describeWait(minutes: number): string {
  if (minutes < 60) {
    return minutes === 1 ? "about a minute" : `about ${minutes} minutes`;
  }
  const hours = Math.ceil(minutes / 60);
  return hours === 1 ? "about an hour" : `about ${hours} hours`;
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
