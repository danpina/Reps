import Link from "next/link";
import { getTranslations } from "next-intl/server";

export default async function NotFound() {
  const t = await getTranslations("notFoundPage");

  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-5 px-5 py-16">
      <h1 className="text-xl font-semibold tracking-tight text-ink">
        {t("heading")}
      </h1>
      <p className="text-sm leading-relaxed text-ink-muted">
        {t("body")}
      </p>
      <Link
        href="/topics"
        className="text-sm font-medium text-ink underline underline-offset-4"
      >
        {t("backToSkills")}
      </Link>
    </main>
  );
}
