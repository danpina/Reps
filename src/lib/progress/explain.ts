// Explicit extension so Node's test runner can resolve this directly; the
// bundler is happy either way.
import { MAX_LEVEL, XP_AWARD, type LevelProgress } from "./rules.ts";
import type { Translate } from "@/lib/i18n";

/**
 * Making the XP economy legible.
 *
 * "90 XP to level 3" is a number nobody can act on. "Two more reps" is an
 * instruction. Everything here converts points into the unit the user actually
 * deals in, which is conversations.
 *
 * Deliberately quiet in tone. This is a training diary, so the aim is that
 * progress can be read at a glance, not that it feels like a game.
 */

/** How many logged reps would close the gap to the next level. */
export function repsToNextLevel(progress: LevelProgress): number {
  if (progress.isMax) return 0;
  return Math.max(1, Math.ceil(progress.toNextLevel / XP_AWARD.mission));
}

/** A short phrase for the gap, in reps rather than points. */
export function describeNextLevel(progress: LevelProgress): string {
  if (progress.isMax) return "Level 10, the top of this skill";

  const reps = repsToNextLevel(progress);
  return reps === 1
    ? `1 more rep to level ${progress.level + 1}`
    : `${reps} more reps to level ${progress.level + 1}`;
}

/** The reader-facing version of describeNextLevel, translated. */
export function describeNextLevelLocalized(
  t: Translate,
  progress: LevelProgress,
): string {
  if (progress.isMax) {
    return t("progress.maxLevel", { level: MAX_LEVEL });
  }

  return t("progress.moreRepsToLevel", {
    reps: repsToNextLevel(progress),
    level: progress.level + 1,
  });
}

export type XpRow = {
  label: string;
  xp: number;
  note: string;
};

/**
 * The whole economy in one table, ordered by what it is worth.
 *
 * The brief is blunt about why the ratio matters: an app that lets someone max
 * out their progress without leaving the house is a treadmill. Showing the
 * numbers side by side is the clearest way to say that without a lecture.
 */
export const XP_TABLE: XpRow[] = [
  {
    label: "A real conversation, logged",
    xp: XP_AWARD.mission,
    note: "Counts the same whether it went well or badly.",
  },
  {
    label: "A rehearsal finished",
    xp: XP_AWARD.roleplay,
    note: "Useful warm up. Worth a fraction of the real thing.",
  },
  {
    label: "A weekly review answered",
    xp: XP_AWARD.rewrite,
    note: "Working out what you would say instead.",
  },
  {
    label: "A theory card read",
    xp: XP_AWARD.theory,
    note: "Once per card. Reading is the cheapest part.",
  },
];

/** How many of the cheaper action one logged rep is worth. */
export const REPS_TO_THEORY_RATIO = Math.round(
  XP_AWARD.mission / XP_AWARD.theory,
);

/**
 * The reader-facing version of XP_TABLE, translated.
 *
 * XP_TABLE itself stays in English and untouched, since tests assert its
 * exact wording and its rows have to line up with XP_AWARD by value.
 */
export function xpTable(t: Translate): XpRow[] {
  return [
    {
      label: t("progress.xpTable.mission.label"),
      xp: XP_AWARD.mission,
      note: t("progress.xpTable.mission.note"),
    },
    {
      label: t("progress.xpTable.roleplay.label"),
      xp: XP_AWARD.roleplay,
      note: t("progress.xpTable.roleplay.note"),
    },
    {
      label: t("progress.xpTable.rewrite.label"),
      xp: XP_AWARD.rewrite,
      note: t("progress.xpTable.rewrite.note"),
    },
    {
      label: t("progress.xpTable.theory.label"),
      xp: XP_AWARD.theory,
      note: t("progress.xpTable.theory.note"),
    },
  ];
}
