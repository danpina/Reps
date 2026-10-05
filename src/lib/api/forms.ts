import "server-only";

import { ApiError } from "@/lib/api/route";

/**
 * The website's server actions take a `FormData`, because that is what a form
 * posts. The app posts JSON, so a route that wraps an action builds the same
 * form the browser would have: every field a string, absent ones left out.
 */
export function formOf(fields: Record<string, unknown>): FormData {
  const form = new FormData();
  for (const [key, value] of Object.entries(fields)) {
    if (value === undefined || value === null) continue;
    form.set(key, String(value));
  }
  return form;
}

/** The request body as an object, or a 400 — a route never has to cope with `null`. */
export async function readBody(request: Request): Promise<Record<string, unknown>> {
  try {
    const body = await request.json();
    if (body && typeof body === "object" && !Array.isArray(body)) {
      return body as Record<string, unknown>;
    }
  } catch {
    // Falls through to the 400 below.
  }
  throw new ApiError(400, "bad_request");
}
