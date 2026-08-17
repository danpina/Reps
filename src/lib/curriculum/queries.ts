import "server-only";

import { cache } from "react";

import { getLocale } from "@/lib/auth/dal";
import { createClient } from "@/lib/supabase/server";
import { asCheatSheet, type CheatSheet } from "./cheat-sheet";
import { byId, DEFAULT_LOCALE, localise } from "./locale";
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
  const locale = await getLocale();

  // Titles come from a view that reads past the paywall, and so do their
  // translations — otherwise a Spanish reader on a free account would get two
  // lessons in Spanish and the locked ones in English, which reads as broken
  // rather than as locked.
  const [{ data, error }, { data: translated }] = await Promise.all([
    supabase
      .from("lesson_index")
      .select("id, skill_id, sort_order, title, is_preview")
      .order("sort_order"),
    locale === DEFAULT_LOCALE
      ? Promise.resolve({ data: null })
      : supabase
          .from("lesson_title_translations")
          .select("lesson_id, title")
          .eq("locale", locale),
  ]);

  if (error) throw new Error(`Could not load the lesson index: ${error.message}`);

  const titles = byId(translated as { lesson_id: string; title: string }[] | null, "lesson_id");

  const bySkill = new Map<string, LessonSummary[]>();
  for (const row of (data ?? []) as LessonSummary[]) {
    const lesson = localise(row, { title: titles.get(row.id)?.title });
    const list = bySkill.get(lesson.skill_id);
    if (list) list.push(lesson);
    else bySkill.set(lesson.skill_id, [lesson]);
  }

  return bySkill;
});

export const getTopics = cache(async (): Promise<TopicWithSkills[]> => {
  const supabase = await createClient();
  const locale = await getLocale();
  const translated = locale !== DEFAULT_LOCALE;

  // Two extra queries for a non-English reader, whatever proportion of the
  // curriculum has been translated — the whole language is fetched at once and
  // merged in memory rather than joined per row.
  const [{ data, error }, index, topicRows, skillRows] = await Promise.all([
    supabase
      .from("topics")
      .select(`id, slug, name, description, promise, sort_order, skills(${SKILL_COLUMNS})`)
      .order("sort_order")
      .order("sort_order", { referencedTable: "skills" }),
    getLessonIndex(),
    translated
      ? supabase
          .from("topic_translations")
          .select("topic_id, name, description, promise")
          .eq("locale", locale)
          .then((r) => r.data)
      : Promise.resolve(null),
    translated
      ? supabase
          .from("skill_translations")
          .select("skill_id, name, description, core_idea")
          .eq("locale", locale)
          .then((r) => r.data)
      : Promise.resolve(null),
  ]);

  if (error) throw new Error(`Could not load topics: ${error.message}`);

  const topicText = byId(topicRows as Record<string, unknown>[] | null, "topic_id");
  const skillText = byId(skillRows as Record<string, unknown>[] | null, "skill_id");

  return (data ?? []).map((row) => {
    const topic = localise(row as Topic, topicText.get(row.id));
    return {
      ...topic,
      skills: ((row as { skills: Skill[] }).skills ?? []).map((s) => ({
        ...localise(s, skillText.get(s.id)),
        lessons: index.get(s.id) ?? [],
      })),
    };
  });
});

export const getTopicBySlug = cache(
  async (slug: string): Promise<TopicWithSkills | null> => {
    const topics = await getTopics();
    return topics.find((topic) => topic.slug === slug) ?? null;
  },
);

/**
 * A topic's printable page, or null where none has been written.
 *
 * Read on its own rather than through `getTopics`, which backs every list in
 * the app. A sheet is a couple of thousand characters per topic and only two
 * pages ever want one.
 */
export const getCheatSheet = cache(
  async (topicSlug: string): Promise<CheatSheet | null> => {
    const supabase = await createClient();

    const locale = await getLocale();

    const { data } = await supabase
      .from("topics")
      .select("id, cheatsheet_json")
      .eq("slug", topicSlug)
      .maybeSingle();

    if (!data) return null;
    if (locale === DEFAULT_LOCALE) return asCheatSheet(data.cheatsheet_json);

    // A sheet is one JSON document, so it falls back whole rather than per
    // concept. Half a sheet in each language would be worse than either.
    const { data: translated } = await supabase
      .from("topic_translations")
      .select("cheatsheet_json")
      .eq("topic_id", data.id as string)
      .eq("locale", locale)
      .maybeSingle();

    return asCheatSheet(translated?.cheatsheet_json ?? data.cheatsheet_json);
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
    const locale = await getLocale();
    if (locale === DEFAULT_LOCALE) return { skill: skills, lesson };

    // Read after the lesson rather than joined to it, so that the entitlement
    // check happens once, on the lesson. If the row above was refused this
    // never runs, and the translations policy would refuse it too.
    const [{ data: lessonText }, { data: skillText }] = await Promise.all([
      supabase
        .from("lesson_translations")
        .select(
          "title, theory_md, examples_json, checks_json, rubric_json, scenario_json, mission_text, rehearsal_spec",
        )
        .eq("lesson_id", lesson.id)
        .eq("locale", locale)
        .maybeSingle(),
      supabase
        .from("skill_translations")
        .select("name, description, core_idea, takeaway_md")
        .eq("skill_id", skills.id)
        .eq("locale", locale)
        .maybeSingle(),
    ]);

    return {
      skill: localise(skills, skillText),
      lesson: localise(lesson, lessonText),
    };
  },
);
