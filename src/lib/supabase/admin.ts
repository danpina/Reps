import "server-only";

import { createClient as createSupabaseClient } from "@supabase/supabase-js";

import { SUPABASE_URL } from "@/lib/env";

/**
 * A client holding the secret key, which bypasses row level security entirely
 * and can reach the auth admin API.
 *
 * Everything else in this app talks to the database as the signed-in user, so
 * the database decides what they may see. This client does not: it is the one
 * place where the only thing standing between a request and every user's data
 * is the code that called it. Two rules follow, and both are load-bearing:
 *
 *   - "server-only" above. If this module is ever pulled into a client bundle
 *     the build fails rather than shipping the key to a browser.
 *   - Every caller proves admin first. There is no path here that checks for
 *     itself, so a new action that forgets requireAdmin is a new action with
 *     no access control at all.
 *
 * Not cached in a module variable. Serverless instances are shared between
 * requests, and a client that outlives the request that made it is a way for
 * one request's state to become another's.
 */
export function createAdminClient() {
  const key = process.env.SUPABASE_SECRET_KEY?.trim();

  if (!key) {
    throw new Error(
      "SUPABASE_SECRET_KEY is not set. Admin actions cannot run without it.",
    );
  }

  return createSupabaseClient(SUPABASE_URL, key, {
    auth: {
      // There is no user here to persist, and nothing to refresh. Leaving
      // these on makes the client try to manage a session it does not have.
      persistSession: false,
      autoRefreshToken: false,
    },
  });
}
