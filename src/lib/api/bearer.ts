import "server-only";

import { createClient, type SupabaseClient, type User } from "@supabase/supabase-js";

import { SUPABASE_PUBLISHABLE_KEY, SUPABASE_URL } from "@/lib/env";

/**
 * Authenticating a request from the iOS app.
 *
 * The website identifies people by a cookie. The app has none: it holds a
 * Supabase access token and sends it as `Authorization: Bearer …`. This turns
 * that header into the same thing a cookie request has — the person, and a
 * Supabase client acting as them.
 *
 * The client is the reader's own, not a privileged one. It carries their token,
 * so row level security decides what it may read and write exactly as it does
 * on the website, and a route that forgets a check cannot reach anyone else's
 * rows. The service-role key has no business in this path.
 *
 * Returns null for anything missing or invalid, and the route answers 401.
 * `getUser` asks Supabase to validate the token rather than trusting it, so a
 * revoked session stops working immediately.
 */
export async function authenticateBearer(
  request: Request,
): Promise<{ supabase: SupabaseClient; user: User } | null> {
  const token = /^Bearer\s+(\S+)$/i.exec(request.headers.get("authorization") ?? "")?.[1];
  if (!token) return null;

  const supabase = createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
    global: { headers: { Authorization: `Bearer ${token}` } },
  });

  const { data, error } = await supabase.auth.getUser(token);
  if (error || !data.user) return null;

  return { supabase, user: data.user };
}
