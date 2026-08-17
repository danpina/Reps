"use server";

import { redirect } from "next/navigation";

import { asLocale } from "@/lib/curriculum/locale";
import { SITE_URL } from "@/lib/env";
import { createClient } from "@/lib/supabase/server";

export type AuthState = { error: string } | undefined;

function readCredentials(formData: FormData) {
  const email = String(formData.get("email") ?? "").trim();
  const password = String(formData.get("password") ?? "");
  return { email, password };
}

function safeNext(value: FormDataEntryValue | null): string {
  const next = String(value ?? "");
  // Only same-origin relative paths — never an attacker-supplied absolute URL.
  return next.startsWith("/") && !next.startsWith("//") ? next : "/today";
}

export async function signIn(
  _state: AuthState,
  formData: FormData,
): Promise<AuthState> {
  const { email, password } = readCredentials(formData);
  if (!email || !password) return { error: "Enter your email and password." };

  const supabase = await createClient();
  const { error } = await supabase.auth.signInWithPassword({ email, password });

  if (error) return { error: "That email and password don't match." };

  redirect(safeNext(formData.get("next")));
}

export async function signUp(
  _state: AuthState,
  formData: FormData,
): Promise<AuthState> {
  const { email, password } = readCredentials(formData);
  const displayName = String(formData.get("display_name") ?? "").trim();
  // Anything unrecognised reads as English rather than failing the signup. The
  // trigger validates it again on the way in, because this value reaches the
  // database through client-written metadata.
  const locale = asLocale(formData.get("locale"));

  if (!email) return { error: "Enter your email." };
  if (password.length < 8)
    return { error: "Use a password of at least 8 characters." };

  const supabase = await createClient();
  const { error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      emailRedirectTo: `${SITE_URL}/auth/callback`,
      data: {
        ...(displayName ? { display_name: displayName } : {}),
        locale,
      },
    },
  });

  if (error) return { error: error.message };

  redirect("/check-email?reason=confirm");
}

export async function sendMagicLink(
  _state: AuthState,
  formData: FormData,
): Promise<AuthState> {
  const email = String(formData.get("email") ?? "").trim();
  if (!email) return { error: "Enter your email first." };

  const supabase = await createClient();
  const { error } = await supabase.auth.signInWithOtp({
    email,
    options: { emailRedirectTo: `${SITE_URL}/auth/callback` },
  });

  if (error) return { error: error.message };

  redirect("/check-email?reason=link");
}

export async function signOut() {
  const supabase = await createClient();
  await supabase.auth.signOut();
  redirect("/sign-in");
}
