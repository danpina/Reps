import "server-only";

import { authenticateBearer } from "@/lib/api/bearer";
import { runWithBearer } from "@/lib/api/context";

/**
 * A deliberate, expected failure: the request was understood and refused. The
 * `code` is a stable word the app can branch on; it is never a sentence for a
 * person, because the app words its own errors in the reader's language.
 */
export class ApiError extends Error {
  constructor(
    public readonly status: number,
    public readonly code: string,
    /**
     * A sentence already worded for the reader, when the website's own code
     * produced one (its actions return localised error text). Passed through so
     * the app can show exactly what the website would have.
     */
    public readonly detail?: string,
  ) {
    super(code);
  }
}

/** Throws a 422 carrying the website's own error sentence, if the action returned one. */
export function rejectIfError(result: { error?: string } | undefined): void {
  if (result?.error) throw new ApiError(422, "rejected", result.error);
}

/**
 * Where a thrown `redirect()` was heading, if that is what was thrown.
 *
 * The website's actions finish by redirecting, and where they redirect to is how
 * they report what happened — `/field-log?logged=1` is success, `/pro?...` is
 * a paywall. A route that wraps one catches it, reads the target, and answers in
 * JSON instead.
 */
export function redirectTarget(error: unknown): string | null {
  const digest = (error as { digest?: unknown } | null)?.digest;
  if (typeof digest !== "string" || !digest.startsWith("NEXT_REDIRECT")) return null;
  return digest.split(";")[2] ?? null;
}

function isNotFound(error: unknown): boolean {
  const digest = (error as { digest?: unknown } | null)?.digest;
  return typeof digest === "string" && digest.startsWith("NEXT_HTTP_ERROR_FALLBACK;404");
}

/**
 * Runs a handler for a request from the iOS app, as the person its bearer token
 * belongs to.
 *
 * Inside the handler the website's own functions work unchanged — `requireUser`,
 * `getLocale`, every query in `lib/`, even the server actions — because they
 * reach the database and the user through lib/api/context rather than a cookie.
 * That is the point of this wrapper: the app calls the same code the website
 * does, so a rule changed once changes for both.
 *
 * Maps what those functions throw to a status the app can act on. They were
 * written for pages, so they signal with `redirect()` and `notFound()`; here a
 * redirect to sign-in is a 401 and one to /blocked is a 403, rather than an HTML
 * redirect nobody is there to follow.
 */
export async function apiRoute(
  request: Request,
  handler: (ctx: { userId: string; email: string | null }) => Promise<unknown>,
): Promise<Response> {
  const auth = await authenticateBearer(request);
  if (!auth) return Response.json({ error: "unauthorized" }, { status: 401 });

  return runWithBearer(auth.token, async () => {
    try {
      const body = await handler({ userId: auth.user.id, email: auth.user.email ?? null });
      return Response.json(body ?? { ok: true });
    } catch (error) {
      if (error instanceof ApiError) {
        return Response.json({ error: error.code, message: error.detail ?? null }, { status: error.status });
      }

      const target = redirectTarget(error);
      if (target === "/blocked") return Response.json({ error: "blocked" }, { status: 403 });
      if (target) return Response.json({ error: "unauthorized" }, { status: 401 });
      if (isNotFound(error)) return Response.json({ error: "not_found" }, { status: 404 });

      const { pathname } = new URL(request.url);
      console.error(`[api] ${request.method} ${pathname} failed:`, error);
      return Response.json({ error: "server_error" }, { status: 500 });
    }
  });
}
