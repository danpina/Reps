"use server";

import { revalidatePath } from "next/cache";

import { SITE_URL } from "@/lib/env";
import { requireAdmin, type Theme } from "@/lib/auth/dal";
import { createAdminClient } from "@/lib/supabase/admin";

export type AdminState = { error?: string; done?: string };

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
  await requireAdmin();

  const email = String(formData.get("email") ?? "").trim();
  if (!email) return { error: "Enter an email address." };

  const admin = createAdminClient();
  const { error } = await admin.auth.admin.inviteUserByEmail(email, {
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
  await requireAdmin();

  const email = String(formData.get("email") ?? "").trim();
  const password = String(formData.get("password") ?? "");

  if (!email) return { error: "Enter an email address." };
  if (password.length < 8) {
    return { error: "Use a password of at least 8 characters." };
  }

  const admin = createAdminClient();
  const { error } = await admin.auth.admin.createUser({
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
  const actor = await requireAdmin();

  const userId = String(formData.get("user_id") ?? "");
  const reason = String(formData.get("reason") ?? "").trim();

  const admin = createAdminClient();
  const refusal = await assertActionable(admin, actor.id, userId);
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
  await requireAdmin();

  const userId = String(formData.get("user_id") ?? "");
  if (!userId) return { error: "No user was given." };

  const admin = createAdminClient();

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
  const actor = await requireAdmin();

  const userId = String(formData.get("user_id") ?? "");
  const confirmation = String(formData.get("confirm") ?? "").trim();

  const admin = createAdminClient();
  const refusal = await assertActionable(admin, actor.id, userId);
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

/** Lets an admin fix someone's settings for them. */
export async function updateUserSettings(
  _prev: AdminState,
  formData: FormData,
): Promise<AdminState> {
  await requireAdmin();

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

  const admin = createAdminClient();
  const { error } = await admin
    .from("profiles")
    .update({ display_name: displayName || null, theme })
    .eq("id", userId);

  if (error) return { error: "That did not save. Try again." };

  revalidatePath("/admin");
  return { done: "Settings updated." };
}
