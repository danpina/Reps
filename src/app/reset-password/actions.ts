"use server";

import { cookies } from "next/headers";
import { redirect } from "next/navigation";
import { getTranslations } from "next-intl/server";

import { requireUser } from "@/lib/auth/dal";
import { PASSWORD_RECOVERY_COOKIE } from "@/lib/auth/recovery";
import { createClient } from "@/lib/supabase/server";

export type ResetPasswordState = { error?: string };

export async function resetPassword(
  _prev: ResetPasswordState,
  formData: FormData,
): Promise<ResetPasswordState> {
  await requireUser();
  const t = await getTranslations("resetPasswordPage.errors");

  const jar = await cookies();
  // Re-checked here, not just on the page: the cookie is the actual proof of
  // a clicked recovery link, and a page-level check alone would not stop this
  // action being invoked on its own.
  if (jar.get(PASSWORD_RECOVERY_COOKIE)?.value !== "1") {
    return { error: t("expired") };
  }

  const next = String(formData.get("new_password") ?? "");
  const confirm = String(formData.get("confirm_password") ?? "");

  if (next.length < 8) return { error: t("passwordTooShort") };
  if (next !== confirm) return { error: t("passwordsDoNotMatch") };

  const supabase = await createClient();
  const { error } = await supabase.auth.updateUser({ password: next });
  if (error) return { error: t("didNotSave") };

  // Single-use: the recovery link cannot be replayed to change the password
  // again once this has succeeded.
  jar.delete(PASSWORD_RECOVERY_COOKIE);

  redirect("/today");
}
