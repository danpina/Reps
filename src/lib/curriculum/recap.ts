import "server-only";

import { cache } from "react";

import { getLocale } from "@/lib/auth/dal";
import { createClient } from "@/lib/supabase/server";
import { DEFAULT_LOCALE, localise } from "./locale";
import { extractTheMove } from "./the-move";

/**
 * The one hand-written page of a track: what to take away from it.
 *
 * Fetched on its own rather than through `getTopics`, which every list in the
 * app calls. Adding a paragraph per skill to that query would carry fifty of
 * them into pages that show a name and a level.
 *
 * Null for a track written before this column existed, or one still being
 * written. The caller shows nothing rather than an empty box.
 */
export const getSkillTakeaway = cache(
  async (slug: string): Promise<string | null> => {
    const supabase = await createClient();
    const locale = await getLocale();

    const { data } = await supabase
      .from("skills")
      .select("id, takeaway_md")
      .eq("slug", slug)
      .maybeSingle();

    if (!data) return null;
    if (locale === DEFAULT_LOCALE) return data.takeaway_md?.trim() || null;

    const { data: translated } = await supabase
      .from("skill_translations")
      .select("takeaway_md")
      .eq("skill_id", data.id)
      .eq("locale", locale)
      .maybeSingle();

    return (translated?.takeaway_md || data.takeaway_md)?.trim() || null;
  },
);

export type RecapLesson = {
  sortOrder: number;
  title: string;
  move: string;
  read: boolean;
};

export type Recap = {
  id: string;
  slug: string;
  name: string;
  coreIdea: string;
  takeaway: string;
  lessons: RecapLesson[];
  readCount: number;
  total: number;
  /** Every lesson in the track has been read. */
  complete: boolean;
  level: number;
  reps: number;
};

/**
 * What a track covered, assembled from the lessons rather than written twice.
 *
 * The recap of each lesson is its own stated move, so it cannot drift out of
 * step with the content. Only the closing distillation is hand-written, and
 * that lives on the skill.
 */
export async function getRecap(slug: string): Promise<Recap | null> {
  const supabase = await createClient();
  const locale = await getLocale();
  const translated = locale !== DEFAULT_LOCALE;

  const { data: skill } = await supabase
    .from("skills")
    .select(
      "id, slug, name, core_idea, takeaway_md, lessons(id, sort_order, title, theory_md)",
    )
    .eq("slug", slug)
    .order("sort_order", { referencedTable: "lessons" })
    .maybeSingle();

  if (!skill) return null;

  const rawLessons = (skill as unknown as {
    lessons: { id: string; sort_order: number; title: string; theory_md: string }[];
  }).lessons;

  const [
    { data: sessions },
    { data: state },
    { count: reps },
    skillText,
    lessonRows,
  ] = await Promise.all([
    supabase.from("sessions").select("lesson_id").eq("kind", "theory"),
    supabase
      .from("user_skill_state")
      .select("level")
      .eq("skill_id", skill.id)
      .maybeSingle(),
    supabase
      .from("field_logs")
      .select("id", { count: "exact", head: true })
      .eq("skill_id", skill.id),
    translated
      ? supabase
          .from("skill_translations")
          .select("name, core_idea, takeaway_md")
          .eq("skill_id", skill.id)
          .eq("locale", locale)
          .maybeSingle()
          .then((r) => r.data)
      : Promise.resolve(null),
    translated
      ? supabase
          .from("lesson_translations")
          .select("lesson_id, title, theory_md")
          .eq("locale", locale)
          .in(
            "lesson_id",
            rawLessons.map((l) => l.id),
          )
          .then((r) => r.data)
      : Promise.resolve(null),
  ]);

  const localisedSkill = localise(
    { name: skill.name, core_idea: skill.core_idea, takeaway_md: skill.takeaway_md },
    skillText,
  );

  const lessonText = new Map(
    (lessonRows ?? []).map((row) => [row.lesson_id as string, row]),
  );

  const readIds = new Set((sessions ?? []).map((s) => s.lesson_id));

  const recapLessons: RecapLesson[] = rawLessons.map((lesson) => {
    const { title, theory_md } = localise(lesson, lessonText.get(lesson.id));
    return {
      sortOrder: lesson.sort_order,
      title,
      move: extractTheMove(theory_md, title),
      read: readIds.has(lesson.id),
    };
  });

  const readCount = recapLessons.filter((l) => l.read).length;

  return {
    id: skill.id,
    slug: skill.slug,
    name: localisedSkill.name,
    coreIdea: localisedSkill.core_idea,
    takeaway: localisedSkill.takeaway_md,
    lessons: recapLessons,
    readCount,
    total: recapLessons.length,
    complete: readCount === recapLessons.length && recapLessons.length > 0,
    level: state?.level ?? 1,
    reps: reps ?? 0,
  };
}
