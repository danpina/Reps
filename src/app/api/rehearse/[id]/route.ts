import { apiRoute, ApiError } from "@/lib/api/route";
import { requireUser } from "@/lib/auth/dal";
import { buildRehearsalView } from "@/lib/roleplay/view";

/** A rehearsal, in whatever state it is in, as data for the app to draw. */
export async function GET(request: Request, { params }: { params: Promise<{ id: string }> }) {
  return apiRoute(request, async () => {
    await requireUser();
    const { id } = await params;

    const view = await buildRehearsalView(id);
    if (!view) throw new ApiError(404, "not_found");
    return view;
  });
}
