import { startRehearsal } from "@/app/(app)/rehearse/start/actions";
import { formOf, readBody } from "@/lib/api/forms";
import { apiRoute, ApiError, redirectTarget } from "@/lib/api/route";

/**
 * Opens a rehearsal for a lesson, or resumes the one already open.
 *
 * `startRehearsal` reports by redirecting, and where it redirects is the answer:
 * `/rehearse/<id>` is success, and the others are the ways it can refuse. The
 * gates it applies — the skill level a scene needs, the daily scene limit, the
 * free allowance — are the website's own, so the app cannot disagree with them.
 */
export async function POST(request: Request) {
  return apiRoute(request, async () => {
    const body = await readBody(request);

    try {
      await startRehearsal(formOf({ lesson_id: body.lessonId }));
    } catch (error) {
      const target = redirectTarget(error);
      if (!target) throw error;

      const opened = /^\/rehearse\/([0-9a-f-]{36})$/i.exec(target);
      if (opened) return { id: opened[1] };

      if (target.startsWith("/pro")) throw new ApiError(402, "subscription_required");
      if (target.startsWith("/rehearse?limit")) throw new ApiError(429, "scene_limit");
      if (target.includes("locked=1")) throw new ApiError(403, "locked_until_level");
      throw new ApiError(404, "not_found");
    }

    throw new ApiError(500, "no_rehearsal");
  });
}
