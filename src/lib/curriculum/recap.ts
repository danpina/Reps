import "server-only";

import { createClient } from "@/lib/supabase/server";
import { extractTheMove } from "./the-move";

export type RecapLesson = {
  sortOrder: number;
  title: string;
  move: string;
  read: boolean;
};

export type Recap = {
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

  const { data: skill } = await supabase
    .from("skills")
    .select(
      "id, slug, name, core_idea, takeaway_md, lessons(id, sort_order, title, theory_md)",
    )
    .eq("slug", slug)
    .order("sort_order", { referencedTable: "lessons" })
    .maybeSingle();

  if (!skill) return null;

  const lessons = (skill as unknown as {
    lessons: { id: string; sort_order: number; title: string; theory_md: string }[];
  }).lessons;

  const [{ data: sessions }, { data: state }, { count: reps }] = await Promise.all([
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
  ]);

  const readIds = new Set((sessions ?? []).map((s) => s.lesson_id));

  const recapLessons: RecapLesson[] = lessons.map((lesson) => ({
    sortOrder: lesson.sort_order,
    title: lesson.title,
    move: extractTheMove(lesson.theory_md, lesson.title),
    read: readIds.has(lesson.id),
  }));

  const readCount = recapLessons.filter((l) => l.read).length;

  return {
    slug: skill.slug,
    name: skill.name,
    coreIdea: skill.core_idea,
    takeaway: skill.takeaway_md,
    lessons: recapLessons,
    readCount,
    total: recapLessons.length,
    complete: readCount === recapLessons.length && recapLessons.length > 0,
    level: state?.level ?? 1,
    reps: reps ?? 0,
  };
}
