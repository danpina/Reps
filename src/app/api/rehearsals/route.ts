import { apiRoute } from "@/lib/api/route";
import { requireUser } from "@/lib/auth/dal";
import { getRehearsalTree } from "@/lib/roleplay/queries";

/** Every rehearsal the reader has done, grouped topic → skill → lesson. */
export async function GET(request: Request) {
  return apiRoute(request, async () => {
    await requireUser();
    return { topics: await getRehearsalTree() };
  });
}
