import { cookies } from "next/headers";
import { redirect } from "next/navigation";
import { getTranslations } from "next-intl/server";

import { requireUser } from "@/lib/auth/dal";
import { PASSWORD_RECOVERY_COOKIE } from "@/lib/auth/recovery";
import { ResetPasswordForm } from "./reset-password-form";

export async function generateMetadata() {
  const t = await getTranslations("resetPasswordPage");
  return { title: t("pageTitle") };
}

/**
 * Deliberately outside both (auth) and (app).
 *
 * Reached only from the recovery email link, by way of /auth/callback, which
 * is the one place that sets the cookie this checks for. Being signed in is
 * not enough on its own — that would let a borrowed session (shared laptop,
 * stolen cookie) set a new password without ever proving the old one, the
 * exact thing settings/actions.ts's changePassword exists to stop. Someone
 * signed in normally who lands here without the cookie is sent to Settings,
 * where changing a password still means knowing the current one.
 */
export default async function ResetPasswordPage() {
  await requireUser();

  const jar = await cookies();
  const hasRecoveryCookie = jar.get(PASSWORD_RECOVERY_COOKIE)?.value === "1";
  if (!hasRecoveryCookie) redirect("/settings");

  const t = await getTranslations("resetPasswordPage");

  return (
    <main className="mx-auto flex w-full max-w-sm flex-col justify-center px-5 py-16">
      <h1 className="text-xl font-semibold tracking-tight text-ink">
        {t("heading")}
      </h1>
      <p className="mt-2 text-sm leading-relaxed text-ink-muted">
        {t("body")}
      </p>

      <ResetPasswordForm />
    </main>
  );
}
