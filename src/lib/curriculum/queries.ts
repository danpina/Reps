import "server-only";

import { cache } from "react";

import { createClient } from "@/lib/supabase/server";
import type { Lesson, LessonSummary, Skill, Topic } from "./types";

export type SkillWithLessons = Skill & { lessons: LessonSummary[] };
export type TopicWithSkills = Topic & { skills: SkillWithLessons[] };

const SKILL_COLUMNS =
  "id, slug, name, description, core_idea, topic_id, sort_order";

/**
 * Every lesson title in the app, gated or not.
 *
 * Read from `lesson_index` rather than from `lessons`, because the policy on
 * `lessons` hides what a free account has not paid for — correct for the body
 * of a lesson, useless for a list that has to show the locks.
 *
 * Fetched as one flat query and grouped in memory rather than embedded into
 * the skills query. Embedding a view through a foreign key relies on PostgREST
 * inferring a relationship the view does not literally declare; a second
 * request costs one round trip and cannot silently stop working.
 */
const getLessonIndex = cache(async (): Promise<Map<string, LessonSummary[]>> => {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("lesson_index")
    .select("id, skill_id, sort_order, title, is_preview")
    .order("sort_order");

  if (error) throw new Error(`Could not load the lesson index: ${error.message}`);

  const bySkill = new Map<string, LessonSummary[]>();
  for (const lesson of (data ?? []) as LessonSummary[]) {
    const list = bySkill.get(lesson.skill_id);
    if (list) list.push(lesson);
    else bySkill.set(lesson.skill_id, [lesson]);
  }

  return bySkill;
});

export const getTopics = cache(async (): Promise<TopicWithSkills[]> => {
  const supabase = await createClient();

  const [{ data, error }, index] = await Promise.all([
    supabase
      .from("topics")
      .select(`id, slug, name, description, promise, sort_order, skills(${SKILL_COLUMNS})`)
      .order("sort_order")
      .order("sort_order", { referencedTable: "skills" }),
    getLessonIndex(),
  ]);

  if (error) throw new Error(`Could not load topics: ${error.message}`);

  return (data ?? []).map((topic) => ({
    ...topic,
    skills: (topic.skills as Skill[]).map((skill) => ({
      ...skill,
      lessons: index.get(skill.id) ?? [],
    })),
  }));
});

export const getTopicBySlug = cache(
  async (slug: string): Promise<TopicWithSkills | null> => {
    const topics = await getTopics();
    return topics.find((topic) => topic.slug === slug) ?? null;
  },
);

/** Every skill in the app, in topic order then position order. */
export const getSkills = cache(async (): Promise<SkillWithLessons[]> => {
  const topics = await getTopics();
  return topics.flatMap((topic) => topic.skills);
});

export const getSkillBySlug = cache(
  async (slug: string): Promise<SkillWithLessons | null> => {
    const skills = await getSkills();
    return skills.find((skill) => skill.slug === slug) ?? null;
  },
);

/** The topic a skill belongs to, for back links and breadcrumbs. */
export const getTopicForSkill = cache(
  async (skillSlug: string): Promise<TopicWithSkills | null> => {
    const topics = await getTopics();
    return (
      topics.find((topic) => topic.skills.some((s) => s.slug === skillSlug)) ??
      null
    );
  },
);

/**
 * A whole lesson, or null.
 *
 * Null means one of two different things — no such lesson, or a lesson this
 * account may not read — and this function deliberately cannot tell them
 * apart, because the database refuses before the difference reaches here. Ask
 * the lesson index for the difference: a title that exists there and not here
 * is a locked lesson rather than a missing one.
 */
export const getLesson = cache(
  async (
    skillSlug: string,
    sortOrder: number,
  ): Promise<{ skill: Skill; lesson: Lesson } | null> => {
    const supabase = await createClient();

    const { data, error } = await supabase
      .from("lessons")
      .select(`*, skills!inner(${SKILL_COLUMNS})`)
      .eq("skills.slug", skillSlug)
      .eq("sort_order", sortOrder)
      .maybeSingle();

    if (error) throw new Error(`Could not load lesson: ${error.message}`);
    if (!data) return null;

    const { skills, ...lesson } = data as Lesson & { skills: Skill };
    return { skill: skills, lesson };
  },
);
