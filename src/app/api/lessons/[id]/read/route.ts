import { authenticateBearer } from "@/lib/api/bearer";
import { recordLessonRead } from "@/lib/progress/lesson-read";

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/**
 * The iOS app's version of `markLessonRead`: the same function, behind a
 * bearer token instead of a cookie. Idempotent, like the original — reading a
 * lesson twice never pays twice.
 */
export async function POST(
  request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const auth = await authenticateBearer(request);
  if (!auth) return Response.json({ error: "unauthorized" }, { status: 401 });

  const { id } = await params;
  if (!UUID.test(id)) return Response.json({ error: "bad_request" }, { status: 400 });

  await recordLessonRead(auth.supabase, auth.user.id, id);
  return Response.json({ ok: true });
}
