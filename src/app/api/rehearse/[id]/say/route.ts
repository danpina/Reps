import { say } from "@/app/(app)/rehearse/[id]/actions";
import { formOf, readBody } from "@/lib/api/forms";
import { apiRoute, rejectIfError } from "@/lib/api/route";

/**
 * A line in a scene, and the partner's reply. The same function the website runs, so the
 * rate limits, the turn cap and the cost ledger apply exactly as they do there.
 */
export async function POST(request: Request, { params }: { params: Promise<{ id: string }> }) {
  return apiRoute(request, async () => {
    const { id } = await params;
    const body = await readBody(request);
    rejectIfError(await say({}, formOf({ roleplay_id: id, message: body.message })));
  });
}
