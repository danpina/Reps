import "server-only";

import { cache } from "react";

import { createClient } from "@/lib/supabase/server";
import type { Lesson, LessonSummary, Skill } from "./types";

export type SkillWithLessons = Skill & { lessons: LessonSummary[] };

export const getSkills = cache(async (): Promise<SkillWithLessons[]> => {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("skills")
    .select(
      "id, slug, name, description, core_idea, sort_order, lessons(id, sort_order, title)",
    )
    .order("sort_order")
    .order("sort_order", { referencedTable: "lessons" });

  if (error) throw new Error(`Could not load skills: ${error.message}`);

  return data ?? [];
});

export const getSkillBySlug = cache(
  async (slug: string): Promise<SkillWithLessons | null> => {
    const supabase = await createClient();

    const { data, error } = await supabase
      .from("skills")
      .select(
        "id, slug, name, description, core_idea, sort_order, lessons(id, sort_order, title)",
      )
      .eq("slug", slug)
      .order("sort_order", { referencedTable: "lessons" })
      .maybeSingle();

    if (error) throw new Error(`Could not load skill: ${error.message}`);

    return data;
  },
);

export const getLesson = cache(
  async (
    skillSlug: string,
    sortOrder: number,
  ): Promise<{ skill: Skill; lesson: Lesson } | null> => {
    const supabase = await createClient();

    const { data, error } = await supabase
      .from("lessons")
      .select("*, skills!inner(id, slug, name, description, core_idea, sort_order)")
      .eq("skills.slug", skillSlug)
      .eq("sort_order", sortOrder)
      .maybeSingle();

    if (error) throw new Error(`Could not load lesson: ${error.message}`);
    if (!data) return null;

    const { skills, ...lesson } = data as Lesson & { skills: Skill };
    return { skill: skills, lesson };
  },
);
