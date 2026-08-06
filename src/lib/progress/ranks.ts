/**
 * What all your XP adds up to, across every skill.
 *
 * There was deliberately no global level here for a long time, and the reason
 * was sound: two level numbers on one screen, with nothing explaining how they
 * relate, was more confusing than either alone. "Level 4" on the dashboard and
 * "Level 2" on a skill invite an arithmetic that does not exist.
 *
 * A rank has a name instead of a number, which removes the collision entirely.
 * Skills have levels. You have a rank. Nobody tries to add those together.
 *
 * The names describe the practice rather than the person — where you are with
 * this, not what you are. "Hard to faze" is a description of a Tuesday, and
 * that is deliberate: an app that hands out titles like Master Conversationalist
 * would be lying to people who still get nervous, which is everyone.
 */

export type Rank = {
  /** Total XP at which this rank begins. */
  at: number;
  name: string;
  /**
   * A clause, not a sentence. It is read as "…to Rarely stuck — where
   * silences stop being emergencies", so it has to join on without a capital
   * and without a full stop.
   */
  note: string;
};

/**
 * Eight ranks. The gaps widen deliberately: the first arrives after two logged
 * conversations, so there is a visible reward for starting, and the last is
 * roughly seventy of them, which is a real amount of practice and should feel
 * like one.
 */
export const RANKS: readonly Rank[] = [
  {
    at: 0,
    name: "Cold start",
    note: "the first one is the only one that is genuinely hard",
  },
  {
    at: 100,
    name: "Showing up",
    note: "further than most people ever get",
  },
  {
    at: 300,
    name: "In the habit",
    note: "where this stops being an experiment",
  },
  {
    at: 650,
    name: "Warm in a room",
    note: "where starting one stops being the hard part",
  },
  {
    at: 1100,
    name: "Rarely stuck",
    note: "where silences stop being emergencies",
  },
  {
    at: 1700,
    name: "Hard to faze",
    note: "where a bad reaction is information, not a verdict",
  },
  {
    at: 2500,
    name: "At ease anywhere",
    note: "where a room full of strangers stops being a category of problem",
  },
  {
    at: 3500,
    name: "Second nature",
    note: "not practising any more, just talking to people",
  },
] as const;

export type RankProgress = {
  rank: Rank;
  /** 1-based, for "3 of 8". */
  position: number;
  total: number;
  xp: number;
  /** The rank being worked towards, or null at the top. */
  next: Rank | null;
  /** XP still to earn before the next rank. Zero at the top. */
  toNext: number;
  /** 0 to 1 through the current rank. Reads as full at the top. */
  fraction: number;
  isMax: boolean;
};

export function rankProgress(xp: number): RankProgress {
  const safeXp = Math.max(0, xp);

  let index = 0;
  for (let i = 0; i < RANKS.length; i++) {
    if (safeXp >= RANKS[i].at) index = i;
  }

  const rank = RANKS[index];
  const next = RANKS[index + 1] ?? null;

  if (!next) {
    return {
      rank,
      position: index + 1,
      total: RANKS.length,
      xp: safeXp,
      next: null,
      toNext: 0,
      fraction: 1,
      isMax: true,
    };
  }

  const span = next.at - rank.at;
  const earned = safeXp - rank.at;

  return {
    rank,
    position: index + 1,
    total: RANKS.length,
    xp: safeXp,
    next,
    toNext: next.at - safeXp,
    fraction: span === 0 ? 1 : earned / span,
    isMax: false,
  };
}

/**
 * How far off the next rank is, said in reps rather than in points.
 *
 * "450 XP" is a number nobody has a feel for. "Nine more conversations" is a
 * plan, and it names the only currency the app actually wants people spending.
 */
export function repsToNextRank(toNext: number, xpPerRep: number): number {
  if (toNext <= 0) return 0;
  return Math.ceil(toNext / xpPerRep);
}
