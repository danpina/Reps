import "server-only";

import type { SupabaseClient } from "@supabase/supabase-js";

import {
  summariseUser,
  type CurriculumShape,
  type UserProgress,
  type UserRows,
} from "./admin-summary.ts";

/**
 * Everybody's standing, in one pass.
 *
 * Loaded in bulk and grouped in memory rather than queried per user. The list
 * is a page of accounts and a query per user per statistic is how a five-row
 * admin screen becomes forty round trips — and this one runs with the secret
 * key, so the caller has already proved they are an admin. There is no check
 * in here.
 *
 * The cost is that it reads every rep and every theory session in the
 * database. At this size that is a few thousand narrow rows and cheaper than
 * the round trips it replaces. If the app ever has enough users for that to
 * stop being true, the fix is a view with the counts already grouped, not a
 * loop of queries.
 */
export type EveryoneProgress = {
  summaries: Map<string, UserProgress>;
  /** The zero state, for accounts that have not started anything. */
  empty: UserProgress;
};

export async function getEveryoneProgress(
  admin: SupabaseClient,
): Promise<EveryoneProgress> {
  const [
    { data: topics },
    { data: skills },
    { data: lessons },
    { data: states },
    { data: logs },
    { data: sessions },
    { data: streaks },
    { data: badges },
  ] = await Promise.all([
    admin.from("topics").select("id, name"),
    admin.from("skills").select("id, name, topic_id"),
    admin.from("lessons").select("id, title, skill_id"),
    admin
      .from("user_skill_state")
      .select("user_id, skill_id, xp, current_lesson_id, updated_at")
      .order("updated_at", { ascending: false }),
    admin.from("field_logs").select("user_id, skill_id, logged_date"),
    admin
      .from("sessions")
      .select("user_id, lesson_id, started_at")
      .eq("kind", "theory"),
    admin
      .from("streaks")
      .select("user_id, current, longest, last_active_date"),
    admin.from("user_badges").select("user_id"),
  ]);

  const topicName = new Map(
    (topics ?? []).map((t) => [t.id as string, t.name as string]),
  );
  const skillRows = (skills ?? []) as {
    id: string;
    name: string;
    topic_id: string;
  }[];
  const lessonRows = (lessons ?? []) as {
    id: string;
    title: string;
    skill_id: string;
  }[];

  const skillById = new Map(skillRows.map((s) => [s.id, s]));
  const lessonById = new Map(lessonRows.map((l) => [l.id, l]));

  const lessonsPerSkill = new Map<string, number>();
  for (const lesson of lessonRows) {
    lessonsPerSkill.set(
      lesson.skill_id,
      (lessonsPerSkill.get(lesson.skill_id) ?? 0) + 1,
    );
  }

  const curriculum: CurriculumShape = {
    topicOfSkill: new Map(skillRows.map((s) => [s.id, s.topic_id])),
    skillOfLesson: new Map(lessonRows.map((l) => [l.id, l.skill_id])),
    topicCount: topicName.size,
    skillCount: skillRows.length,
    lessonCount: lessonRows.length,
    lessonsPerSkill,
  };

  const byUser = new Map<string, UserRows>();
  const rowsFor = (userId: string): UserRows => {
    let rows = byUser.get(userId);
    if (!rows) {
      rows = {
        states: [],
        logs: [],
        readLessonIds: [],
        lastReadDate: null,
        streak: null,
        badgeCount: 0,
        furthest: null,
      };
      byUser.set(userId, rows);
    }
    return rows;
  };

  // States arrive newest first, so the first one carrying a lesson is the one
  // they were last in. Same rule the dashboard's resume point uses.
  for (const state of states ?? []) {
    const rows = rowsFor(state.user_id as string);
    rows.states.push({
      skill_id: state.skill_id as string,
      xp: (state.xp as number) ?? 0,
    });

    if (!rows.furthest && state.current_lesson_id) {
      const lesson = lessonById.get(state.current_lesson_id as string);
      const skill = lesson ? skillById.get(lesson.skill_id) : undefined;
      if (lesson && skill) {
        rows.furthest = {
          topic: topicName.get(skill.topic_id) ?? "—",
          skill: skill.name,
          lesson: lesson.title,
        };
      }
    }
  }

  for (const log of logs ?? []) {
    rowsFor(log.user_id as string).logs.push({
      skill_id: log.skill_id as string,
      logged_date: log.logged_date as string,
    });
  }

  for (const session of sessions ?? []) {
    const rows = rowsFor(session.user_id as string);
    if (session.lesson_id) rows.readLessonIds.push(session.lesson_id as string);

    // started_at is a timestamp in UTC and logged_date is the user's own
    // calendar day, so these can disagree by one either side of midnight. That
    // is accepted: this line answers "has anybody been here lately", and a day
    // of slop does not change that answer.
    const day = (session.started_at as string | null)?.slice(0, 10) ?? null;
    if (day && (!rows.lastReadDate || day > rows.lastReadDate)) {
      rows.lastReadDate = day;
    }
  }

  for (const streak of streaks ?? []) {
    rowsFor(streak.user_id as string).streak = {
      current: (streak.current as number) ?? 0,
      longest: (streak.longest as number) ?? 0,
      last_active_date: (streak.last_active_date as string | null) ?? null,
    };
  }

  for (const badge of badges ?? []) {
    rowsFor(badge.user_id as string).badgeCount++;
  }

  const summaries = new Map<string, UserProgress>();
  for (const [userId, rows] of byUser) {
    summaries.set(userId, summariseUser(curriculum, rows));
  }

  return {
    summaries,
    // An account with no rows at all has no entry above, and rendering it as
    // blank would lose the denominators — "0 of 11 topics" says more about
    // where somebody is than an empty space does.
    empty: summariseUser(curriculum, {
      states: [],
      logs: [],
      readLessonIds: [],
      lastReadDate: null,
      streak: null,
      badgeCount: 0,
      furthest: null,
    }),
  };
}
