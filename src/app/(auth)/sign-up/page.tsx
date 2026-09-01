import Link from "next/link";
import { getTranslations } from "next-intl/server";

import { SignUpForm } from "./sign-up-form";

export default async function SignUpPage() {
  const t = await getTranslations("auth.signUp");

  return (
    <div className="flex flex-col gap-6">
      <h1 className="text-xl font-semibold tracking-tight text-ink">
        {t("heading")}
      </h1>

      <SignUpForm />

      <p className="border-t border-rule pt-5 text-sm text-ink-muted">
        {t.rich("alreadyHaveAccount", {
          link: (chunks) => (
            <Link
              href="/sign-in"
              className="font-medium text-ink underline underline-offset-4"
            >
              {chunks}
            </Link>
          ),
        })}
      </p>
    </div>
  );
}
