/**
 * Where somebody has got to, computed for a user who is not the one asking.
 *
 * Every other progress query in the app reads the current user through RLS,
 * which is right for the dashboard and useless here — the admin screen needs
 * the same numbers about somebody else. So the shape of the data is passed in
 * rather than fetched, and this file stays a pure function over rows.
 *
 * That also keeps the definitions honest. Read and used are two different kinds
 * of done, and lib/curriculum/progress draws that line already: reading a card
 * is the cheap half, logging a rep against it is the half that counts. The
 * counts below keep them apart for the same reason, because a user who has read
 * forty lessons and logged nothing is in a completely different place from one
 * who has read four and used all of them, and a single "progress" percentage
 * would render those identically.
 */

import { rankProgress, type RankProgress } from "./ranks.ts";

/** The curriculum, indexed once and reused for every user on the page. */
export type CurriculumShape = {
  /** skill id -> topic id */
  topicOfSkill: Map<string, string>;
  /** lesson id -> skill id */
  skillOfLesson: Map<string, string>;
  topicCount: number;
  skillCount: number;
  lessonCount: number;
  /** How many lessons each skill has, so "finished" means all of them. */
  lessonsPerSkill: Map<string, number>;
};

/** One user's rows, already filtered to them. */
export type UserRows = {
  states: { skill_id: string; xp: number }[];
  logs: { skill_id: string; logged_date: string }[];
  readLessonIds: string[];
  /**
   * The day of their most recent theory session, as YYYY-MM-DD.
   *
   * Needed because somebody can read for a fortnight without logging a rep or
   * building a streak, and reporting that account as never active is wrong in
   * the one direction that matters — it is the account you would look at to
   * decide whether anybody is using the thing.
   */
  lastReadDate: string | null;
  streak: {
    current: number;
    longest: number;
    last_active_date: string | null;
  } | null;
  badgeCount: number;
  /** Most recently opened lesson, resolved to names by the caller. */
  furthest: { topic: string; skill: string; lesson: string } | null;
};

export type UserProgress = {
  totalXp: number;
  rank: RankProgress;
  repsLogged: number;
  currentStreak: number;
  longestStreak: number;
  /** The latest of their last rep, last card read, and the streak's record. */
  lastActive: string | null;
  topicsStarted: number;
  topicsTotal: number;
  /** Any rep or any lesson read. */
  skillsStarted: number;
  /** At least one rep logged against it. */
  skillsWorked: number;
  /** Every lesson in the track read. */
  skillsFinished: number;
  skillsTotal: number;
  lessonsRead: number;
  lessonsTotal: number;
  badges: number;
  furthest: { topic: string; skill: string; lesson: string } | null;
  /** True when there is nothing to show but an account. */
  isUntouched: boolean;
};

export function summariseUser(
  curriculum: CurriculumShape,
  rows: UserRows,
): UserProgress {
  const totalXp = rows.states.reduce((sum, s) => sum + (s.xp ?? 0), 0);

  const repsBySkill = new Map<string, number>();
  let lastLogDate: string | null = null;
  for (const log of rows.logs) {
    repsBySkill.set(log.skill_id, (repsBySkill.get(log.skill_id) ?? 0) + 1);
    // ISO dates compare correctly as strings, which is the whole reason
    // logged_date is stored as the user's own calendar day rather than derived
    // from a timestamp at read time.
    if (!lastLogDate || log.logged_date > lastLogDate) lastLogDate = log.logged_date;
  }

  // Deduplicated first, because these are session rows and reading a card
  // twice writes a second one. Counting rows would report more lessons read
  // than exist, and worse, would call a track finished on the strength of one
  // card opened three times.
  const readBySkill = new Map<string, number>();
  for (const lessonId of new Set(rows.readLessonIds)) {
    const skillId = curriculum.skillOfLesson.get(lessonId);
    // A lesson that no longer exists — deleted in a migration, say — still has
    // its session row. Counting it would inflate the total past the curriculum.
    if (!skillId) continue;
    readBySkill.set(skillId, (readBySkill.get(skillId) ?? 0) + 1);
  }

  const startedSkills = new Set<string>([
    ...repsBySkill.keys(),
    ...readBySkill.keys(),
  ]);

  const startedTopics = new Set<string>();
  for (const skillId of startedSkills) {
    const topicId = curriculum.topicOfSkill.get(skillId);
    if (topicId) startedTopics.add(topicId);
  }

  let skillsFinished = 0;
  for (const [skillId, read] of readBySkill) {
    const total = curriculum.lessonsPerSkill.get(skillId) ?? 0;
    if (total > 0 && read >= total) skillsFinished++;
  }

  const lessonsRead = [...readBySkill.values()].reduce((a, b) => a + b, 0);
  const streakDate = rows.streak?.last_active_date ?? null;

  return {
    totalXp,
    rank: rankProgress(totalXp),
    repsLogged: rows.logs.length,
    currentStreak: rows.streak?.current ?? 0,
    longestStreak: rows.streak?.longest ?? 0,
    lastActive: latest(latest(lastLogDate, streakDate), rows.lastReadDate),
    topicsStarted: startedTopics.size,
    topicsTotal: curriculum.topicCount,
    skillsStarted: startedSkills.size,
    skillsWorked: repsBySkill.size,
    skillsFinished,
    skillsTotal: curriculum.skillCount,
    lessonsRead,
    lessonsTotal: curriculum.lessonCount,
    badges: rows.badgeCount,
    furthest: rows.furthest,
    isUntouched:
      startedSkills.size === 0 && rows.logs.length === 0 && totalXp === 0,
  };
}

function latest(a: string | null, b: string | null): string | null {
  if (!a) return b;
  if (!b) return a;
  return a > b ? a : b;
}
