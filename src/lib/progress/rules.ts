/**
 * The XP economy and streak rules.
 *
 * Pure functions on purpose: these encode product decisions that are painful
 * to change once real logged data exists, so they should be readable and
 * directly testable without a database in the way.
 */

export const MAX_LEVEL = 10;

/**
 * XP per action. The ratio is the message: a real conversation is worth more
 * than three roleplays and ten theory cards put together. The brief is blunt
 * about why — an app that lets you max out your progress without leaving the
 * house is a treadmill.
 */
export const XP_AWARD = {
  mission: 50,
  roleplay: 15,
  /** Answering "what would you say instead?" in the weekly review. */
  rewrite: 10,
  theory: 5,
} as const;

export type XpAction = keyof typeof XP_AWARD;

/**
 * Cumulative XP needed to reach each level, indexed by level - 1. Gentle at
 * the start so the first sign of progress arrives after about two logged
 * missions, widening later.
 */
export const LEVEL_THRESHOLDS = [
  0, 100, 250, 450, 700, 1000, 1350, 1750, 2200, 2700,
] as const;

export function levelForXp(xp: number): number {
  let level = 1;
  for (let i = 1; i < LEVEL_THRESHOLDS.length; i++) {
    if (xp >= LEVEL_THRESHOLDS[i]) level = i + 1;
  }
  return level;
}

export type LevelProgress = {
  level: number;
  xp: number;
  /** XP into the current level. */
  earnedThisLevel: number;
  /** XP the current level spans. Zero once maxed. */
  levelSpan: number;
  /** Remaining XP to the next level. Zero once maxed. */
  toNextLevel: number;
  /** 0 to 1. Reads as full at max level. */
  fraction: number;
  isMax: boolean;
};

export function levelProgress(xp: number): LevelProgress {
  const level = levelForXp(xp);
  const isMax = level >= MAX_LEVEL;

  if (isMax) {
    return {
      level: MAX_LEVEL,
      xp,
      earnedThisLevel: 0,
      levelSpan: 0,
      toNextLevel: 0,
      fraction: 1,
      isMax: true,
    };
  }

  const floor = LEVEL_THRESHOLDS[level - 1];
  const ceiling = LEVEL_THRESHOLDS[level];
  const levelSpan = ceiling - floor;
  const earnedThisLevel = xp - floor;

  return {
    level,
    xp,
    earnedThisLevel,
    levelSpan,
    toNextLevel: ceiling - xp,
    fraction: levelSpan === 0 ? 1 : earnedThisLevel / levelSpan,
    isMax: false,
  };
}

// ---------------------------------------------------------------------------
// Streaks
// ---------------------------------------------------------------------------

export const REST_DAYS_PER_WEEK = 2;

export type StreakState = {
  current: number;
  longest: number;
  lastActiveDate: string | null;
  restDaysUsedThisWeek: number;
  weekStartDate: string | null;
};

export type StreakOutcome = StreakState & {
  /** True when this activity extended the streak rather than continuing a day. */
  advanced: boolean;
  /** Rest days silently spent to keep the streak alive. */
  restDaysSpent: number;
  /** True when the gap was too large to cover and the streak restarted. */
  broke: boolean;
};

/** Dates are ISO yyyy-mm-dd in the user's own timezone, not UTC. */
export function toIsoDate(date: Date): string {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, "0");
  const d = String(date.getDate()).padStart(2, "0");
  return `${y}-${m}-${d}`;
}

function parseIsoDate(iso: string): Date {
  const [y, m, d] = iso.split("-").map(Number);
  return new Date(y, m - 1, d);
}

export function daysBetween(fromIso: string, toIso: string): number {
  const from = parseIsoDate(fromIso);
  const to = parseIsoDate(toIso);
  return Math.round((to.getTime() - from.getTime()) / 86_400_000);
}

/** Monday of the week containing the given date. */
export function weekStart(iso: string): string {
  const date = parseIsoDate(iso);
  const day = date.getDay(); // 0 Sunday
  const offset = day === 0 ? 6 : day - 1;
  date.setDate(date.getDate() - offset);
  return toIsoDate(date);
}

/**
 * Applies a day of activity to a streak.
 *
 * The safety valve matters more than the streak. Two rest days a week are
 * spent automatically to cover missed days, because streak anxiety makes
 * people abandon an app entirely after one slip. The user is never asked to
 * spend one and never has to think about it.
 */
export function applyActivity(
  state: StreakState,
  todayIso: string,
): StreakOutcome {
  const thisWeek = weekStart(todayIso);

  // Rest days replenish at the start of each week.
  const freshWeek = state.weekStartDate !== thisWeek;
  const restUsed = freshWeek ? 0 : state.restDaysUsedThisWeek;
  const restAvailable = REST_DAYS_PER_WEEK - restUsed;

  const base = {
    longest: state.longest,
    lastActiveDate: todayIso,
    weekStartDate: thisWeek,
  };

  // First ever activity.
  if (!state.lastActiveDate) {
    return {
      ...base,
      current: 1,
      longest: Math.max(state.longest, 1),
      restDaysUsedThisWeek: restUsed,
      advanced: true,
      restDaysSpent: 0,
      broke: false,
    };
  }

  const gap = daysBetween(state.lastActiveDate, todayIso);

  // Already logged today, or a clock that went backwards. Nothing changes.
  if (gap <= 0) {
    return {
      ...state,
      weekStartDate: freshWeek ? thisWeek : state.weekStartDate,
      restDaysUsedThisWeek: restUsed,
      advanced: false,
      restDaysSpent: 0,
      broke: false,
    };
  }

  const missed = gap - 1;

  if (missed === 0 || missed <= restAvailable) {
    const current = state.current + 1;
    return {
      ...base,
      current,
      longest: Math.max(state.longest, current),
      restDaysUsedThisWeek: restUsed + missed,
      advanced: true,
      restDaysSpent: missed,
      broke: false,
    };
  }

  // Too long a gap to cover. Start again at one, which still counts as today.
  return {
    ...base,
    current: 1,
    longest: Math.max(state.longest, 1),
    restDaysUsedThisWeek: restUsed,
    advanced: true,
    restDaysSpent: 0,
    broke: true,
  };
}

/**
 * The streak that a given set of active days adds up to.
 *
 * Needed because a rep can be deleted, and a streak cannot be un-applied: it
 * depends on the gaps between days and on how many rest days each week had
 * left, so there is no correct way to subtract one day from the middle of it.
 * Replaying every remaining day through `applyActivity` gives exactly the
 * streak the user would have had if the deleted rep had never existed.
 *
 * Days may arrive in any order and may repeat — two reps on one day are one
 * active day.
 */
export function replayStreak(days: string[]): StreakState {
  const distinct = [...new Set(days)].sort();

  let state: StreakState = {
    current: 0,
    longest: 0,
    lastActiveDate: null,
    restDaysUsedThisWeek: 0,
    weekStartDate: null,
  };

  for (const day of distinct) {
    state = applyActivity(state, day);
  }

  return state;
}

export const WENT_LABELS: Record<number, string> = {
  1: "Not well",
  2: "Mixed",
  3: "Went well",
};
