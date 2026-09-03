import Link from "next/link";
import { getTranslations } from "next-intl/server";

export default async function CheckEmailPage({
  searchParams,
}: {
  searchParams: Promise<{ reason?: string }>;
}) {
  const { reason } = await searchParams;
  const t = await getTranslations("auth.checkEmail");

  return (
    <div className="flex flex-col gap-5">
      <h1 className="text-xl font-semibold tracking-tight text-ink">
        {t("heading")}
      </h1>
      <p className="text-sm leading-relaxed text-ink-muted">
        {reason === "confirm"
          ? t("confirmBody")
          : reason === "reset"
            ? t("resetBody")
            : t("linkBody")}
      </p>
      <Link
        href="/sign-in"
        className="text-sm font-medium text-ink underline underline-offset-4"
      >
        {t("backToSignIn")}
      </Link>
    </div>
  );
}
