import "server-only";

import { cache } from "react";

import { createClient } from "@/lib/supabase/server";

/**
 * Which lessons the user has read, and which they have logged a rep against.
 *
 * Two different kinds of done, and the app should not conflate them. Reading a
 * card is the cheap half; going and using it is the half that counts, so the
 * lists mark them separately.
 *
 * Cached per request, so a page can annotate a list without a query per row.
 */
export type CurriculumProgress = {
  readLessonIds: Set<string>;
  usedLessonIds: Set<string>;
  repsBySkillId: Map<string, number>;
};

export const getCurriculumProgress = cache(
  async (): Promise<CurriculumProgress> => {
    const supabase = await createClient();

    const [{ data: sessions }, { data: logs }] = await Promise.all([
      supabase.from("sessions").select("lesson_id").eq("kind", "theory"),
      supabase.from("field_logs").select("lesson_id, skill_id"),
    ]);

    const repsBySkillId = new Map<string, number>();
    const usedLessonIds = new Set<string>();

    for (const log of logs ?? []) {
      if (log.lesson_id) usedLessonIds.add(log.lesson_id);
      if (log.skill_id) {
        repsBySkillId.set(log.skill_id, (repsBySkillId.get(log.skill_id) ?? 0) + 1);
      }
    }

    return {
      readLessonIds: new Set(
        (sessions ?? []).map((s) => s.lesson_id).filter(Boolean) as string[],
      ),
      usedLessonIds,
      repsBySkillId,
    };
  },
);
