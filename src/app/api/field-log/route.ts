import { apiRoute } from "@/lib/api/route";
import { requireUser } from "@/lib/auth/dal";
import { getFieldLog, getTotals } from "@/lib/progress/queries";

/** Every rep the reader has logged, newest first, with the totals that sit above the list. */
export async function GET(request: Request) {
  return apiRoute(request, async () => {
    await requireUser();
    const [entries, totals] = await Promise.all([getFieldLog({}), getTotals()]);
    return { entries, totals };
  });
}
