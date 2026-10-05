import { createClient as createTokenClient } from "@supabase/supabase-js";

import { apiRoute, ApiError } from "@/lib/api/route";
import { readBody } from "@/lib/api/forms";
import { SUPABASE_PUBLISHABLE_KEY, SUPABASE_URL } from "@/lib/env";
import { requireUser } from "@/lib/auth/dal";
import { adminIsConfigured, createAdminClient } from "@/lib/supabase/admin";

/**
 * Deletes the signed-in person's account and everything attached to it.
 *
 * Required by the App Store for an app that has accounts, and it is a one-way door, so it
 * is narrow on purpose:
 *
 * - The account deleted is the token's owner and nobody else. There is no id in the
 *   request to point it somewhere else; `requireUser` is the only source of whose it is.
 * - It asks for the current password, the same proof changing a password does, so a
 *   borrowed phone or a stolen token is not enough to erase someone's record.
 * - The privileged client is used for exactly one call, deleting that one user. Every
 *   table that refers to a user cascades from `auth.users`, so that single delete takes
 *   the profile, reps, rehearsals, progress and badges with it.
 */
export async function DELETE(request: Request) {
  return apiRoute(request, async () => {
    const user = await requireUser();
    const body = await readBody(request);

    const password = typeof body.password === "string" ? body.password : "";
    if (!password || !user.email) throw new ApiError(400, "password_required");

    // A fresh client with no session of its own, so the check cannot touch the caller's token.
    const check = createTokenClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY, {
      auth: { persistSession: false, autoRefreshToken: false },
    });
    const { error: wrong } = await check.auth.signInWithPassword({ email: user.email, password });
    if (wrong) throw new ApiError(403, "wrong_password");

    if (!adminIsConfigured()) {
      console.error("[api] account deletion needs SUPABASE_SECRET_KEY, which this deployment does not have");
      throw new ApiError(503, "unavailable");
    }

    const { error } = await createAdminClient().auth.admin.deleteUser(user.id);
    if (error) {
      console.error("[api] account deletion failed:", error.message);
      throw new ApiError(500, "delete_failed");
    }

    // The token's session is gone with the user; nothing else to clean up.
    return { ok: true };
  });
}
