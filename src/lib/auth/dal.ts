import "server-only";

import { redirect } from "next/navigation";
import { cache } from "react";

import { createClient } from "@/lib/supabase/server";

export type SessionUser = {
  id: string;
  email: string | null;
};

export const getSessionUser = cache(async (): Promise<SessionUser | null> => {
  const supabase = await createClient();
  const { data, error } = await supabase.auth.getClaims();

  if (error || !data?.claims?.sub) return null;

  return {
    id: data.claims.sub,
    email: typeof data.claims.email === "string" ? data.claims.email : null,
  };
});

export async function requireUser(): Promise<SessionUser> {
  const user = await getSessionUser();
  if (!user) redirect("/sign-in");

  // A blocked account stops working on the next request rather than whenever
  // its token happens to expire. The auth user is banned as well, which is
  // what stops a new session being issued; this is what stops the one already
  // in flight. Both matter — neither alone is immediate and durable.
  const profile = await getProfile();
  if (profile?.blocked_at) redirect("/blocked");

  return user;
}

export type Theme = "system" | "light" | "dark";

export type Profile = {
  id: string;
  display_name: string | null;
  timezone: string;
  onboarding_context: "work" | "casual" | "flirting" | "all" | null;
  theme: Theme;
  blocked_at: string | null;
  blocked_reason: string | null;
  created_at: string;
};

export const getProfile = cache(async (): Promise<Profile | null> => {
  const user = await getSessionUser();
  if (!user) return null;

  const supabase = await createClient();
  const { data } = await supabase
    .from("profiles")
    .select(
      "id, display_name, timezone, onboarding_context, theme, blocked_at, blocked_reason, created_at",
    )
    .eq("id", user.id)
    .maybeSingle();

  return data;
});

/**
 * Whether the signed-in user is an admin.
 *
 * Reads the roster rather than trusting anything in the token, and leans on
 * the table's own policy to do the work: a non-admin's select matches no rows
 * because the policy says so, so this cannot report true for someone the
 * database would refuse.
 */
export const isAdmin = cache(async (): Promise<boolean> => {
  const user = await getSessionUser();
  if (!user) return false;

  const supabase = await createClient();
  const { data } = await supabase
    .from("admins")
    .select("user_id")
    .eq("user_id", user.id)
    .maybeSingle();

  return Boolean(data);
});

/** Guards the admin screens. Sends everyone else back rather than explaining. */
export async function requireAdmin(): Promise<SessionUser> {
  const user = await requireUser();
  if (!(await isAdmin())) redirect("/today");
  return user;
}
