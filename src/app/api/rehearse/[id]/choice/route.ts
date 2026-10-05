import { answerChoice } from "@/app/(app)/rehearse/[id]/drill-actions";
import { formOf, readBody } from "@/lib/api/forms";
import { apiRoute, rejectIfError } from "@/lib/api/route";

/** One answer to one read-and-decide situation. `option` is the index the option was authored at. */
export async function POST(request: Request, { params }: { params: Promise<{ id: string }> }) {
  return apiRoute(request, async () => {
    const { id } = await params;
    const body = await readBody(request);
    rejectIfError(await answerChoice({}, formOf({ roleplay_id: id, option: body.option })));
  });
}
