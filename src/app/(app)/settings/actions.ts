"use server";

import { revalidatePath } from "next/cache";
import { cookies } from "next/headers";
import { getTranslations } from "next-intl/server";

import { requireUser, type Theme } from "@/lib/auth/dal";
import { isLocale, LOCALE_COOKIE } from "@/lib/curriculum/locale";
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
  const t = await getTranslations("settings.messages");
  const choice = String(formData.get("theme") ?? "");

  if (!isTheme(choice)) return { error: t("notAValidTheme") };

  const supabase = await createClient();
  const { error } = await supabase
    .from("profiles")
    .update({ theme: choice })
    .eq("id", user.id);

  if (error) return { error: t("didNotSave") };

  // The theme is rendered by the root layout, so the whole tree is stale.
  revalidatePath("/", "layout");
  return { done: t("themeSaved") };
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
  const t = await getTranslations("settings.messages");
  const choice = String(formData.get("locale") ?? "");

  if (!isLocale(choice)) return { error: t("notAValidLanguage") };

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
    return { error: t("didNotSave") };
  }

  // Mirrors the profile so the choice survives a later sign-out, when there is
  // no profile row left to read it from — see getLocale in dal.ts.
  const jar = await cookies();
  jar.set(LOCALE_COOKIE, choice, { maxAge: 60 * 60 * 24 * 400, path: "/" });

  revalidatePath("/", "layout");
  return { done: t("languageSaved") };
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
  const t = await getTranslations("settings.messages");

  const supabase = await createClient();
  const { error } = await supabase
    .from("profiles")
    .update({
      sex: parseSex(formData.get("sex")),
      age_group: parseAgeGroup(formData.get("age_group")),
      dating_interest: parseDatingInterest(formData.get("dating_interest")),
    })
    .eq("id", user.id);

  if (error) return { error: t("didNotSave") };

  revalidatePath("/settings");
  return { done: t("saved") };
}

export async function changePassword(
  _prev: SettingsState,
  formData: FormData,
): Promise<SettingsState> {
  const user = await requireUser();
  const t = await getTranslations("settings.messages");

  const current = String(formData.get("current_password") ?? "");
  const next = String(formData.get("new_password") ?? "");
  const confirm = String(formData.get("confirm_password") ?? "");

  if (!current) return { error: t("enterCurrentPassword") };
  if (next.length < 8) {
    return { error: t("newPasswordTooShort") };
  }
  if (next !== confirm) return { error: t("passwordsDoNotMatch") };
  if (next === current) {
    return { error: t("samePassword") };
  }

  const supabase = await createClient();

  // Supabase will change a password on the strength of the session alone. That
  // makes a borrowed session — a shared laptop, a stolen cookie — enough to
  // take the account permanently. Proving the current password first is what
  // stops that, and it is the reason this asks for it at all.
  if (!user.email) {
    return { error: t("noEmailOnAccount") };
  }

  const { error: wrongPassword } = await supabase.auth.signInWithPassword({
    email: user.email,
    password: current,
  });
  if (wrongPassword) return { error: t("wrongCurrentPassword") };

  const { error } = await supabase.auth.updateUser({ password: next });
  // Never the SDK's own message — see the note in (auth)/actions.ts.
  if (error) return { error: t("passwordChangeFailed") };

  return { done: t("passwordChanged") };
}
