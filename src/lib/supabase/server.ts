import { createServerClient } from "@supabase/ssr";
import { createClient as createTokenClient, type SupabaseClient } from "@supabase/supabase-js";
import { cookies } from "next/headers";

import { bearerToken } from "@/lib/api/context";
import { SUPABASE_PUBLISHABLE_KEY, SUPABASE_URL } from "@/lib/env";

export async function createClient(): Promise<SupabaseClient> {
  // A request from the iOS app acts as the token's owner. The client is still the
  // reader's own — it carries their token — so row level security decides what it
  // may touch exactly as it does for a cookie session. See lib/api/context.
  const token = bearerToken();
  if (token) {
    return createTokenClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY, {
      auth: { persistSession: false, autoRefreshToken: false },
      global: { headers: { Authorization: `Bearer ${token}` } },
    });
  }

  const cookieStore = await cookies();

  return createServerClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY, {
    cookies: {
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet) {
        try {
          for (const { name, value, options } of cookiesToSet) {
            cookieStore.set(name, value, options);
          }
        } catch {
          // Server Components cannot write cookies. The proxy refreshes the
          // session on every request, so a dropped write here is recoverable.
        }
      },
    },
  });
}
