import "server-only";

import { cache } from "react";

import { getTopics } from "@/lib/curriculum/queries";
import { createClient } from "@/lib/supabase/server";
import { averageScore, type Feedback } from "./feedback";
import {
  isDrillResult,
  isRehearsalMode,
  type DrillResult,
  type RehearsalMode,
} from "./modes";

/**
 * Rehearsals, read once and placed in the curriculum.
 *
 * Three screens want the same rows sliced three ways — the whole history, one
 * track's worth, and one lesson's worth — so the read is cached and the
 * slicing happens in memory. A personal history of practice scenes is never
 * large enough for that to cost anything.
 *
 * The lesson, skill and topic each row belongs to are taken from `getTopics`
 * rather than embedded in the query. Embedding would join through `lessons`,
 * which is gated by entitlement: a scene rehearsed while subscribed would lose
 * its title the day the subscription lapsed, and the row would render as a
 * conversation with nobody about nothing.
 */

export type Rehearsal = {
  id: string;
  status: "open" | "complete";
  mode: RehearsalMode;
  startedAt: string;
  /** How many lines the user said. The only measure an unfinished scene has. */
  lines: number;
  /** Mean of the rubric scores, once an AI scene has been ended and scored. */
  average: number | null;
  /** Whether a drill met every requirement. Null for the AI modes. */
  landed: boolean | null;
  /** The single thing to fix, or the first requirement a drill missed. */
  fix: string | null;
};

export type LessonRehearsals = {
  lessonId: string;
  sortOrder: number;
  title: string;
  /** Newest first. */
  rehearsals: Rehearsal[];
};

export type SkillRehearsals = {
  slug: string;
  name: string;
  total: number;
  lessons: LessonRehearsals[];
};

export type TopicRehearsals = {
  slug: string;
  name: string;
  total: number;
  skills: SkillRehearsals[];
};

type Row = {
  id: string;
  lesson_id: string;
  status: "open" | "complete";
  mode: string;
  started_at: string;
  transcript_json: { role: string }[];
  feedback_json: Feedback | DrillResult | null;
  scores_json: Record<string, number> | null;
};

const getRows = cache(async (): Promise<Row[]> => {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("roleplays")
    .select(
      "id, lesson_id, status, mode, started_at, transcript_json, feedback_json, scores_json",
    )
    .order("started_at", { ascending: false });

  if (error) throw new Error(`Could not load rehearsals: ${error.message}`);

  return (data ?? []) as unknown as Row[];
});

function toRehearsal(row: Row): Rehearsal {
  const drill = isDrillResult(row.feedback_json) ? row.feedback_json : null;

  return {
    id: row.id,
    status: row.status,
    mode: isRehearsalMode(row.mode) ? row.mode : "scene",
    startedAt: row.started_at,
    lines: row.transcript_json.filter((turn) => turn.role === "user").length,
    average: row.scores_json ? averageScore(row.scores_json) : null,
    landed: drill ? drill.landed : null,
    // A drill has no single fix to offer, so the first requirement it missed
    // stands in for one — which is the same job that sentence does for a scene.
    fix: drill ? (drill.missed[0] ?? null) : ((row.feedback_json as Feedback | null)?.fix ?? null),
  };
}

/** Every scene rehearsed on one lesson, newest first. */
export async function getRehearsalsForLesson(
  lessonId: string,
): Promise<Rehearsal[]> {
  const rows = await getRows();
  return rows.filter((row) => row.lesson_id === lessonId).map(toRehearsal);
}

/**
 * One track's rehearsals, in lesson order.
 *
 * Lessons with nothing rehearsed against them are left out entirely — this is
 * a record of what happened, not a second copy of the syllabus.
 */
export async function getRehearsalsForSkill(
  skillSlug: string,
): Promise<{ total: number; lessons: LessonRehearsals[] }> {
  const [rows, topics] = await Promise.all([getRows(), getTopics()]);

  const skill = topics
    .flatMap((topic) => topic.skills)
    .find((s) => s.slug === skillSlug);

  if (!skill) return { total: 0, lessons: [] };

  const byLesson = groupByLesson(rows, skill.lessons);
  return {
    total: byLesson.reduce((n, lesson) => n + lesson.rehearsals.length, 0),
    lessons: byLesson,
  };
}

/**
 * Everything, in the order the curriculum runs: topic, then skill, then
 * lesson, then newest scene first.
 *
 * Sorted by position rather than by date at every level above the scene
 * itself. A flat list newest-first answered "what did I do last", which is the
 * one question the date on each row already answers; what it could not answer
 * was "how much have I practised this track", because the rows were scattered
 * through it.
 */
export async function getRehearsalTree(): Promise<TopicRehearsals[]> {
  const [rows, topics] = await Promise.all([getRows(), getTopics()]);

  return topics
    .map((topic) => {
      const skills = topic.skills
        .map((skill) => {
          const lessons = groupByLesson(rows, skill.lessons);
          return {
            slug: skill.slug,
            name: skill.name,
            total: lessons.reduce((n, l) => n + l.rehearsals.length, 0),
            lessons,
          };
        })
        .filter((skill) => skill.total > 0);

      return {
        slug: topic.slug,
        name: topic.name,
        total: skills.reduce((n, skill) => n + skill.total, 0),
        skills,
      };
    })
    .filter((topic) => topic.total > 0);
}

/** How many scenes have been rehearsed in total. */
export async function countRehearsals(): Promise<number> {
  return (await getRows()).length;
}

function groupByLesson(
  rows: Row[],
  lessons: { id: string; sort_order: number; title: string }[],
): LessonRehearsals[] {
  return lessons
    .map((lesson) => ({
      lessonId: lesson.id,
      sortOrder: lesson.sort_order,
      title: lesson.title,
      // `rows` arrives newest first, and filtering preserves that.
      rehearsals: rows
        .filter((row) => row.lesson_id === lesson.id)
        .map(toRehearsal),
    }))
    .filter((lesson) => lesson.rehearsals.length > 0);
}
