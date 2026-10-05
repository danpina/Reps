import { logRep } from "@/app/(app)/log/actions";
import { formOf, readBody } from "@/lib/api/forms";
import { apiRoute, ApiError, redirectTarget } from "@/lib/api/route";
import { getBadges } from "@/lib/progress/queries";
import { XP_AWARD } from "@/lib/progress/rules";

/**
 * Logs a rep.
 *
 * Runs the website's own `logRep`, so the XP, the streak and the badges are worked out
 * once, in one place. It reports success by redirecting to the field log, and the badges
 * it earned ride along in that address — read back here and returned by name, in the
 * reader's language, so the app can say what a rep just earned.
 */
export async function POST(request: Request) {
  return apiRoute(request, async () => {
    const body = await readBody(request);

    const form = formOf({
      skill_id: body.skillId,
      went: body.went,
      lesson_id: body.lessonId,
      mission_text: body.missionText,
      context_note: body.contextNote,
      reflection: body.reflection,
      other_sex: body.otherSex,
      other_age_group: body.otherAgeGroup,
      local_date: body.localDate,
      timezone: body.timezone,
    });

    try {
      const result = await logRep({}, form);
      // Only a refusal comes back as a value; success redirects.
      if (result?.error) throw new ApiError(422, "rejected", result.error);
    } catch (error) {
      const target = redirectTarget(error);
      if (!target) throw error;

      const slugs = new URL(target, "https://x.invalid").searchParams.get("badges")?.split(",") ?? [];
      if (slugs.length === 0) return { xp: XP_AWARD.mission, badges: [] };

      const earned = (await getBadges()).earned.filter((b) => slugs.includes(b.slug));
      return { xp: XP_AWARD.mission, badges: earned.map((b) => ({ id: b.id, name: b.name, description: b.description })) };
    }

    return { xp: XP_AWARD.mission, badges: [] };
  });
}
