"use server";

import { revalidatePath } from "next/cache";

import { SITE_URL } from "@/lib/env";
import { requireAdmin, type Theme } from "@/lib/auth/dal";
import { adminIsConfigured, createAdminClient } from "@/lib/supabase/admin";

export type AdminState = { error?: string; done?: string };

// Not exported: a "use server" file may only export async functions, since
// every export becomes a callable endpoint.
const NOT_CONFIGURED =
  "Admin is not configured on this deployment: SUPABASE_SECRET_KEY is missing. Set it and redeploy.";

/**
 * Proves admin, then proves the deployment can actually act.
 *
 * Both checks belong together because every action needs both, and an action
 * that forgets either is an action with no access control or a stack trace
 * where an explanation should be.
 */
async function begin(): Promise<
  | { ok: true; admin: ReturnType<typeof createAdminClient>; actorId: string }
  | { ok: false; error: string }
> {
  const actor = await requireAdmin();
  if (!adminIsConfigured()) return { ok: false, error: NOT_CONFIGURED };
  return { ok: true, admin: createAdminClient(), actorId: actor.id };
}

/** Supabase takes a Go duration. A century is "indefinite" in practice. */
const FOREVER = "876000h";

const THEMES: Theme[] = ["system", "light", "dark"];

/**
 * Refuses the two targets an admin must not act on.
 *
 * Yourself, because blocking or deleting the account you are using is a
 * mistake with no way back through the UI. And any other admin, because the
 * roster is deliberately SQL-only — letting one admin remove another would put
 * a route to that privilege back into the app, through the side door.
 */
async function assertActionable(
  admin: ReturnType<typeof createAdminClient>,
  actorId: string,
  targetId: string,
): Promise<string | null> {
  if (!targetId) return "No user was given.";
  if (targetId === actorId) return "You cannot do that to your own account.";

  const { data } = await admin
    .from("admins")
    .select("user_id")
    .eq("user_id", targetId)
    .maybeSingle();

  if (data) {
    return "That user is an admin. Remove them from the roster in SQL first.";
  }
  return null;
}

export async function inviteUser(
  _prev: AdminState,
  formData: FormData,
): Promise<AdminState> {
  const session = await begin();
  if (!session.ok) return { error: session.error };

  const email = String(formData.get("email") ?? "").trim();
  if (!email) return { error: "Enter an email address." };

  const { error } = await session.admin.auth.admin.inviteUserByEmail(email, {
    redirectTo: `${SITE_URL}/auth/callback`,
  });

  if (error) return { error: error.message };

  revalidatePath("/admin");
  return { done: `Invited ${email}.` };
}

/**
 * The fallback for when email is not working.
 *
 * Whoever creates the account knows its password until the owner changes it,
 * which is why this is the second-choice path and not the first.
 */
export async function createUser(
  _prev: AdminState,
  formData: FormData,
): Promise<AdminState> {
  const session = await begin();
  if (!session.ok) return { error: session.error };

  const email = String(formData.get("email") ?? "").trim();
  const password = String(formData.get("password") ?? "");

  if (!email) return { error: "Enter an email address." };
  if (password.length < 8) {
    return { error: "Use a password of at least 8 characters." };
  }

  const { error } = await session.admin.auth.admin.createUser({
    email,
    password,
    // No confirmation email is coming, so the address has to start confirmed
    // or the account cannot be signed into at all.
    email_confirm: true,
  });

  if (error) return { error: error.message };

  revalidatePath("/admin");
  return { done: `Created ${email}. Tell them to change the password.` };
}

export async function blockUser(
  _prev: AdminState,
  formData: FormData,
): Promise<AdminState> {
  const session = await begin();
  if (!session.ok) return { error: session.error };
  const { admin } = session;

  const userId = String(formData.get("user_id") ?? "");
  const reason = String(formData.get("reason") ?? "").trim();

  const refusal = await assertActionable(admin, session.actorId, userId);
  if (refusal) return { error: refusal };

  // Both halves matter. The ban stops a new session being issued; the column
  // is what the data layer checks, which is what stops the session already in
  // flight. Ban first: if the second write fails, the stricter half is the one
  // that survives.
  const { error: banError } = await admin.auth.admin.updateUserById(userId, {
    ban_duration: FOREVER,
  });
  if (banError) return { error: banError.message };

  const { error } = await admin
    .from("profiles")
    .update({
      blocked_at: new Date().toISOString(),
      blocked_reason: reason || null,
    })
    .eq("id", userId);

  if (error) return { error: "Banned, but the reason did not save." };

  revalidatePath("/admin");
  return { done: "User blocked." };
}

export async function unblockUser(
  _prev: AdminState,
  formData: FormData,
): Promise<AdminState> {
  const session = await begin();
  if (!session.ok) return { error: session.error };
  const { admin } = session;

  const userId = String(formData.get("user_id") ?? "");
  if (!userId) return { error: "No user was given." };

  // Clear the column first here, for the same reason the ban went first when
  // blocking: whichever write lands alone, the account stays blocked.
  const { error } = await admin
    .from("profiles")
    .update({ blocked_at: null, blocked_reason: null })
    .eq("id", userId);
  if (error) return { error: "That did not save. Try again." };

  const { error: banError } = await admin.auth.admin.updateUserById(userId, {
    ban_duration: "none",
  });
  if (banError) return { error: banError.message };

  revalidatePath("/admin");
  return { done: "User unblocked." };
}

/**
 * Permanent. The auth user goes, and every row that references it goes with
 * it by cascade: profile, field logs, roleplays, badges, streaks, XP.
 */
export async function deleteUser(
  _prev: AdminState,
  formData: FormData,
): Promise<AdminState> {
  const session = await begin();
  if (!session.ok) return { error: session.error };
  const { admin } = session;

  const userId = String(formData.get("user_id") ?? "");
  const confirmation = String(formData.get("confirm") ?? "").trim();

  const refusal = await assertActionable(admin, session.actorId, userId);
  if (refusal) return { error: refusal };

  // Typed, not clicked. This is the one action in the app that cannot be
  // undone, and a button alone is too easy to hit by accident.
  if (confirmation !== "DELETE") {
    return { error: "Type DELETE to confirm. Nothing was deleted." };
  }

  const { error } = await admin.auth.admin.deleteUser(userId);
  if (error) return { error: error.message };

  revalidatePath("/admin");
  return { done: "User deleted." };
}

/**
 * Opens the paid product for an account, by hand.
 *
 * This is the only writer of `subscriptions` until Stripe exists, and it works
 * because the secret key bypasses row level security — the table has no insert
 * policy at all, so nothing reachable with a user's own session can grant
 * entitlement, including a user granting it to themselves.
 *
 * A grant made here has no end date. That is right for the people this is for:
 * friends, testers, and anyone owed a comp. Stripe's rows will carry a period
 * end and expire on their own.
 */
export async function grantPro(
  _prev: AdminState,
  formData: FormData,
): Promise<AdminState> {
  const session = await begin();
  if (!session.ok) return { error: session.error };

  const userId = String(formData.get("user_id") ?? "");
  const note = String(formData.get("note") ?? "").trim();
  if (!userId) return { error: "No user was given." };

  const { error } = await session.admin.from("subscriptions").upsert(
    {
      user_id: userId,
      status: "active",
      source: "manual",
      current_period_end: null,
      granted_by: session.actorId,
      note: note || null,
    },
    { onConflict: "user_id" },
  );

  if (error) return { error: `That did not save: ${error.message}` };

  revalidatePath("/admin");
  return { done: "Subscription granted." };
}

/**
 * Closes it again.
 *
 * The row is marked cancelled rather than deleted, so that why-and-by-whom
 * survives the decision. `is_pro` reads the status, so a cancelled row is the
 * same as no row for every purpose except the record.
 */
export async function revokePro(
  _prev: AdminState,
  formData: FormData,
): Promise<AdminState> {
  const session = await begin();
  if (!session.ok) return { error: session.error };

  const userId = String(formData.get("user_id") ?? "");
  if (!userId) return { error: "No user was given." };

  const { error } = await session.admin
    .from("subscriptions")
    .update({ status: "canceled" })
    .eq("user_id", userId);

  if (error) return { error: `That did not save: ${error.message}` };

  revalidatePath("/admin");
  return { done: "Subscription revoked." };
}

/** Lets an admin fix someone's settings for them. */
export async function updateUserSettings(
  _prev: AdminState,
  formData: FormData,
): Promise<AdminState> {
  const session = await begin();
  if (!session.ok) return { error: session.error };

  const userId = String(formData.get("user_id") ?? "");
  const displayName = String(formData.get("display_name") ?? "").trim();
  const theme = String(formData.get("theme") ?? "");

  if (!userId) return { error: "No user was given." };
  if (!(THEMES as string[]).includes(theme)) {
    return { error: "That is not one of the themes." };
  }
  if (displayName.length > 60) {
    return { error: "That display name is too long." };
  }

  const { error } = await session.admin
    .from("profiles")
    .update({ display_name: displayName || null, theme })
    .eq("id", userId);

  if (error) return { error: "That did not save. Try again." };

  revalidatePath("/admin");
  return { done: "Settings updated." };
}
