import { endScene } from "@/app/(app)/rehearse/[id]/actions";
import { formOf } from "@/lib/api/forms";
import { apiRoute, rejectIfError } from "@/lib/api/route";

/** Ends a scene and scores it. */
export async function POST(request: Request, { params }: { params: Promise<{ id: string }> }) {
  return apiRoute(request, async () => {
    const { id } = await params;
    rejectIfError(await endScene({}, formOf({ roleplay_id: id })));
  });
}
