import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

import { SUPABASE_PUBLISHABLE_KEY, SUPABASE_URL } from "@/lib/env";

export async function createClient() {
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
