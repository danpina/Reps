import { attemptLine } from "@/app/(app)/rehearse/[id]/drill-actions";
import { formOf, readBody } from "@/lib/api/forms";
import { apiRoute, rejectIfError } from "@/lib/api/route";

/** One attempt at a line drill. The verdict comes back with the next read of the rehearsal. */
export async function POST(request: Request, { params }: { params: Promise<{ id: string }> }) {
  return apiRoute(request, async () => {
    const { id } = await params;
    const body = await readBody(request);
    rejectIfError(await attemptLine({}, formOf({ roleplay_id: id, line: body.line })));
  });
}
