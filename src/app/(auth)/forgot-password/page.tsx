import Link from "next/link";
import { getTranslations } from "next-intl/server";

import { ForgotPasswordForm } from "./forgot-password-form";

export async function generateMetadata() {
  const t = await getTranslations("auth.forgotPassword");
  return { title: t("pageTitle") };
}

export default async function ForgotPasswordPage() {
  const t = await getTranslations("auth.forgotPassword");

  return (
    <div className="flex flex-col gap-6">
      <h1 className="text-xl font-semibold tracking-tight text-ink">
        {t("heading")}
      </h1>
      <p className="text-sm leading-relaxed text-ink-muted">{t("body")}</p>

      <ForgotPasswordForm />

      <Link
        href="/sign-in"
        className="text-sm font-medium text-ink underline underline-offset-4"
      >
        {t("backToSignIn")}
      </Link>
    </div>
  );
}
