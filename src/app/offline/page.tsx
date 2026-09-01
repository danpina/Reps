import { getTranslations } from "next-intl/server";

export const metadata = { title: "Offline — Reps" };

/**
 * Precached once by the service worker at install time (see public/sw.js), so
 * this renders in whatever locale was active then and stays that way until the
 * next deploy re-installs the worker — a rare, brief staleness that still
 * beats being permanently in English for a Spanish reader between deploys.
 */
export default async function OfflinePage() {
  const t = await getTranslations("offlinePage");

  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-5 px-5 py-16">
      <p className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
        Reps
      </p>
      <h1 className="text-xl font-semibold tracking-tight text-ink">
        {t("heading")}
      </h1>
      <p className="text-sm leading-relaxed text-ink-muted">
        {t("body1")}
      </p>
      <p className="text-sm leading-relaxed text-ink-muted">
        {t("body2")}
      </p>
    </main>
  );
}
