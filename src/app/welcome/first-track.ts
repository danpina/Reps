/**
 * Where each onboarding context sends you first.
 *
 * Kept out of actions.ts because a "use server" module may only export async
 * functions — exporting this constant from there is a runtime error, and one
 * the production build does not catch.
 *
 * Dating starts on reading disinterest rather than on flirting itself. Someone
 * who can tell when interest is not mutual is both more effective and far less
 * likely to make anyone uncomfortable, so it is the right first lesson rather
 * than a disclaimer bolted on afterwards.
 */
export const CONTEXTS = ["work", "casual", "flirting", "all"] as const;

export type Context = (typeof CONTEXTS)[number];

export const FIRST_TRACK: Record<Context, string> = {
  work: "openers",
  casual: "openers",
  flirting: "reading-disinterest",
  all: "openers",
};
