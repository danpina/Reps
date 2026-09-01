"use server";

import { revalidatePath } from "next/cache";
import { getTranslations } from "next-intl/server";

import { SITE_URL } from "@/lib/env";
import { requireAdmin, type Theme } from "@/lib/auth/dal";
import { adminIsConfigured, createAdminClient } from "@/lib/supabase/admin";

export type AdminState = { error?: string; done?: string };

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
  if (!adminIsConfigured()) {
    const t = await getTranslations("adminPage.actions");
    return { ok: false, error: t("notConfigured") };
  }
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
  const t = await getTranslations("adminPage.actions");

  if (!targetId) return t("noUserGiven");
  if (targetId === actorId) return t("cannotActOnSelf");

  const { data } = await admin
    .from("admins")
    .select("user_id")
    .eq("user_id", targetId)
    .maybeSingle();

  if (data) {
    return t("targetIsAdmin");
  }
  return null;
}

export async function inviteUser(
  _prev: AdminState,
  formData: FormData,
): Promise<AdminState> {
  const session = await begin();
  if (!session.ok) return { error: session.error };
  const t = await getTranslations("adminPage.actions");

  const email = String(formData.get("email") ?? "").trim();
  if (!email) return { error: t("enterEmail") };

  const { error } = await session.admin.auth.admin.inviteUserByEmail(email, {
    redirectTo: `${SITE_URL}/auth/callback`,
  });

  if (error) return { error: error.message };

  revalidatePath("/admin");
  return { done: t("invited", { email }) };
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
  const t = await getTranslations("adminPage.actions");

  const email = String(formData.get("email") ?? "").trim();
  const password = String(formData.get("password") ?? "");

  if (!email) return { error: t("enterEmail") };
  if (password.length < 8) {
    return { error: t("passwordTooShort") };
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
  return { done: t("createdTellThemToChangePassword", { email }) };
}

export async function blockUser(
  _prev: AdminState,
  formData: FormData,
): Promise<AdminState> {
  const session = await begin();
  if (!session.ok) return { error: session.error };
  const { admin } = session;
  const t = await getTranslations("adminPage.actions");

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

  if (error) return { error: t("bannedReasonDidNotSave") };

  revalidatePath("/admin");
  return { done: t("userBlocked") };
}

export async function unblockUser(
  _prev: AdminState,
  formData: FormData,
): Promise<AdminState> {
  const session = await begin();
  if (!session.ok) return { error: session.error };
  const { admin } = session;
  const t = await getTranslations("adminPage.actions");

  const userId = String(formData.get("user_id") ?? "");
  if (!userId) return { error: t("noUserGiven") };

  // Clear the column first here, for the same reason the ban went first when
  // blocking: whichever write lands alone, the account stays blocked.
  const { error } = await admin
    .from("profiles")
    .update({ blocked_at: null, blocked_reason: null })
    .eq("id", userId);
  if (error) return { error: t("didNotSave") };

  const { error: banError } = await admin.auth.admin.updateUserById(userId, {
    ban_duration: "none",
  });
  if (banError) return { error: banError.message };

  revalidatePath("/admin");
  return { done: t("userUnblocked") };
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
  const t = await getTranslations("adminPage.actions");

  const userId = String(formData.get("user_id") ?? "");
  const confirmation = String(formData.get("confirm") ?? "").trim();

  const refusal = await assertActionable(admin, session.actorId, userId);
  if (refusal) return { error: refusal };

  // Typed, not clicked. This is the one action in the app that cannot be
  // undone, and a button alone is too easy to hit by accident.
  if (confirmation !== "DELETE") {
    return { error: t("typeDeleteToConfirmError") };
  }

  const { error } = await admin.auth.admin.deleteUser(userId);
  if (error) return { error: error.message };

  revalidatePath("/admin");
  return { done: t("userDeleted") };
}

/**
 * How long a hand-granted subscription lasts.
 *
 * Not a pricing model — there is no billing yet, and paid plans will arrive
 * with their own table when there is something to charge for. These exist so
 * that a subscription with an end date can be created at all, which is the
 * only way to see what the app does when one runs out.
 *
 * Calendar arithmetic rather than a count of days, so "one month" granted on
 * the 3rd ends on the 3rd. Granting on the 31st lands wherever Date decides,
 * which is close enough for a comp.
 */
const DURATIONS = ["none", "week", "month", "year"] as const;
type Duration = (typeof DURATIONS)[number];

function periodEndFor(duration: Duration): string | null {
  if (duration === "none") return null;

  const end = new Date();
  if (duration === "week") end.setDate(end.getDate() + 7);
  if (duration === "month") end.setMonth(end.getMonth() + 1);
  if (duration === "year") end.setFullYear(end.getFullYear() + 1);

  return end.toISOString();
}

/**
 * Opens the paid product for an account, by hand.
 *
 * This is the only writer of `subscriptions` until Stripe exists, and it works
 * because the secret key bypasses row level security — the table has no insert
 * policy at all, so nothing reachable with a user's own session can grant
 * entitlement, including a user granting it to themselves.
 */
export async function grantPro(
  _prev: AdminState,
  formData: FormData,
): Promise<AdminState> {
  const session = await begin();
  if (!session.ok) return { error: session.error };
  const t = await getTranslations("adminPage.actions");

  const userId = String(formData.get("user_id") ?? "");
  const note = String(formData.get("note") ?? "").trim();
  const duration = String(formData.get("duration") ?? "none");

  if (!userId) return { error: t("noUserGiven") };
  if (!(DURATIONS as readonly string[]).includes(duration)) {
    return { error: t("notAValidDuration") };
  }

  const endsAt = periodEndFor(duration as Duration);

  const { error } = await session.admin.from("subscriptions").upsert(
    {
      user_id: userId,
      status: "active",
      source: "manual",
      current_period_end: endsAt,
      granted_by: session.actorId,
      note: note || null,
    },
    { onConflict: "user_id" },
  );

  if (error) return { error: t("didNotSave") };

  revalidatePath("/admin");
  return {
    done: endsAt
      ? t("grantedUntil", { date: new Date(endsAt).toLocaleDateString("en-GB") })
      : t("grantedNoEndDate"),
  };
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
  const t = await getTranslations("adminPage.actions");

  const userId = String(formData.get("user_id") ?? "");
  if (!userId) return { error: t("noUserGiven") };

  const { error } = await session.admin
    .from("subscriptions")
    .update({ status: "canceled" })
    .eq("user_id", userId);

  if (error) return { error: t("didNotSave") };

  revalidatePath("/admin");
  return { done: t("subscriptionRevoked") };
}

/** Lets an admin fix someone's settings for them. */
export async function updateUserSettings(
  _prev: AdminState,
  formData: FormData,
): Promise<AdminState> {
  const session = await begin();
  if (!session.ok) return { error: session.error };
  const t = await getTranslations("adminPage.actions");

  const userId = String(formData.get("user_id") ?? "");
  const displayName = String(formData.get("display_name") ?? "").trim();
  const theme = String(formData.get("theme") ?? "");

  if (!userId) return { error: t("noUserGiven") };
  if (!(THEMES as string[]).includes(theme)) {
    return { error: t("notAValidTheme") };
  }
  if (displayName.length > 60) {
    return { error: t("displayNameTooLong") };
  }

  const { error } = await session.admin
    .from("profiles")
    .update({ display_name: displayName || null, theme })
    .eq("id", userId);

  if (error) return { error: t("didNotSave") };

  revalidatePath("/admin");
  return { done: t("settingsUpdated") };
}
