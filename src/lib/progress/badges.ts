/**
 * Badge criteria evaluation.
 *
 * Pure functions over a snapshot of the user's progress, so the rules can be
 * read and tested without a database. Criteria come from badges.criteria_json.
 */

export type BadgeCriteria =
  | { type: "reps_total"; n: number }
  | { type: "logged_a_failure" }
  | { type: "skill_reps"; slug: string; n: number }
  | { type: "distinct_skills"; n: number }
  | { type: "streak"; n: number }
  | { type: "rewrites"; n: number };

export type Badge = {
  id: string;
  slug: string;
  name: string;
  description: string;
  criteria_json: BadgeCriteria;
  sort_order: number;
};

/** Everything any criterion needs to know, gathered once. */
export type ProgressSnapshot = {
  repsTotal: number;
  /** Reps that went badly, so honest logging can be rewarded. */
  failuresLogged: number;
  /** Reps per skill slug. */
  repsBySkillSlug: Record<string, number>;
  /** Skill slugs with at least one rep. */
  distinctSkills: number;
  longestStreak: number;
  rewrites: number;
};

export function isEarned(
  criteria: BadgeCriteria,
  snapshot: ProgressSnapshot,
): boolean {
  switch (criteria.type) {
    case "reps_total":
      return snapshot.repsTotal >= criteria.n;
    case "logged_a_failure":
      return snapshot.failuresLogged >= 1;
    case "skill_reps":
      return (snapshot.repsBySkillSlug[criteria.slug] ?? 0) >= criteria.n;
    case "distinct_skills":
      return snapshot.distinctSkills >= criteria.n;
    case "streak":
      return snapshot.longestStreak >= criteria.n;
    case "rewrites":
      return snapshot.rewrites >= criteria.n;
    default: {
      // An unknown criterion is never earned rather than throwing, so a badge
      // added by a future migration cannot break the logging flow.
      const _exhaustive: never = criteria;
      void _exhaustive;
      return false;
    }
  }
}

/** Badges now earned that were not already held. */
export function newlyEarned(
  badges: Badge[],
  snapshot: ProgressSnapshot,
  alreadyHeld: Set<string>,
): Badge[] {
  return badges.filter(
    (badge) =>
      !alreadyHeld.has(badge.id) && isEarned(badge.criteria_json, snapshot),
  );
}
