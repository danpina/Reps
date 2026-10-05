import { finishDrill } from "@/app/(app)/rehearse/[id]/drill-actions";
import { formOf } from "@/lib/api/forms";
import { apiRoute, rejectIfError } from "@/lib/api/route";

/** Closes a drill and records how it went. */
export async function POST(request: Request, { params }: { params: Promise<{ id: string }> }) {
  return apiRoute(request, async () => {
    const { id } = await params;
    rejectIfError(await finishDrill({}, formOf({ roleplay_id: id })));
  });
}
