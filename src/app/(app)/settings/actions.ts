"use server";

import { revalidatePath } from "next/cache";

import { requireUser, type Theme } from "@/lib/auth/dal";
import { isLocale } from "@/lib/curriculum/locale";
import {
  parseAgeGroup,
  parseDatingInterest,
  parseSex,
} from "@/lib/profile/demographics";
import { createClient } from "@/lib/supabase/server";

export type SettingsState = { error?: string; done?: string };

const THEMES: Theme[] = ["system", "light", "dark"];

function isTheme(value: string): value is Theme {
  return (THEMES as string[]).includes(value);
}

export async function updateTheme(
  _prev: SettingsState,
  formData: FormData,
): Promise<SettingsState> {
  const user = await requireUser();
  const choice = String(formData.get("theme") ?? "");

  if (!isTheme(choice)) return { error: "That is not one of the themes." };

  const supabase = await createClient();
  const { error } = await supabase
    .from("profiles")
    .update({ theme: choice })
    .eq("id", user.id);

  if (error) return { error: "That did not save. Try again." };

  // The theme is rendered by the root layout, so the whole tree is stale.
  revalidatePath("/", "layout");
  return { done: "Theme saved." };
}

/**
 * The language the curriculum is read in.
 *
 * Revalidates the whole tree for the same reason the theme does, and more
 * urgently: every topic name, lesson title and cheat sheet in the app is
 * cached per request, so anything already rendered is in the old language
 * until it is thrown away.
 */
export async function updateLanguage(
  _prev: SettingsState,
  formData: FormData,
): Promise<SettingsState> {
  const user = await requireUser();
  const choice = String(formData.get("locale") ?? "");

  if (!isLocale(choice)) return { error: "That is not one of the languages." };

  const supabase = await createClient();
  const { error } = await supabase
    .from("profiles")
    .update({ locale: choice })
    .eq("id", user.id);

  if (error) {
    // The screen says "that did not save", which is all a reader needs and is
    // useless to whoever has to fix it — and Next.js strips error messages in
    // production, so nothing reaches the logs either unless it is put there.
    // This one failed in production for a week as a missing column grant,
    // which reports as "permission denied for table profiles" and reads like
    // an RLS problem. That sentence would have saved the week.
    console.error("[settings] locale update failed", {
      code: error.code,
      message: error.message,
      details: error.details,
      hint: error.hint,
    });
    return { error: "That did not save. Try again." };
  }

  revalidatePath("/", "layout");
  return { done: "Language saved." };
}

/**
 * The two facts that change the advice.
 *
 * Clearing them is a legitimate outcome, not a validation failure — someone
 * who filled these in at signup and would rather not have is entitled to take
 * them back, so a blank answer writes null rather than being rejected.
 */
export async function updateAboutYou(
  _prev: SettingsState,
  formData: FormData,
): Promise<SettingsState> {
  const user = await requireUser();

  const supabase = await createClient();
  const { error } = await supabase
    .from("profiles")
    .update({
      sex: parseSex(formData.get("sex")),
      age_group: parseAgeGroup(formData.get("age_group")),
      dating_interest: parseDatingInterest(formData.get("dating_interest")),
    })
    .eq("id", user.id);

  if (error) return { error: "That did not save. Try again." };

  revalidatePath("/settings");
  return { done: "Saved." };
}

export async function changePassword(
  _prev: SettingsState,
  formData: FormData,
): Promise<SettingsState> {
  const user = await requireUser();

  const current = String(formData.get("current_password") ?? "");
  const next = String(formData.get("new_password") ?? "");
  const confirm = String(formData.get("confirm_password") ?? "");

  if (!current) return { error: "Enter your current password." };
  if (next.length < 8) {
    return { error: "Use a new password of at least 8 characters." };
  }
  if (next !== confirm) return { error: "The two new passwords do not match." };
  if (next === current) {
    return { error: "That is the password you already have." };
  }

  const supabase = await createClient();

  // Supabase will change a password on the strength of the session alone. That
  // makes a borrowed session — a shared laptop, a stolen cookie — enough to
  // take the account permanently. Proving the current password first is what
  // stops that, and it is the reason this asks for it at all.
  if (!user.email) {
    return { error: "This account has no email, so it cannot be verified." };
  }

  const { error: wrongPassword } = await supabase.auth.signInWithPassword({
    email: user.email,
    password: current,
  });
  if (wrongPassword) return { error: "That is not your current password." };

  const { error } = await supabase.auth.updateUser({ password: next });
  if (error) return { error: error.message };

  return { done: "Password changed." };
}
