import Link from "next/link";
import { getTranslations } from "next-intl/server";

import { BackLink } from "@/components/back-link";
import { getLocale, requireUser } from "@/lib/auth/dal";
import { isPro } from "@/lib/billing/entitlement";
import { getCoachState } from "@/lib/coach/queries";
import { RunReview } from "./run-review";

export async function generateMetadata() {
  const t = await getTranslations("coachPage");
  return { title: t("pageTitle") };
}

export default async function CoachPage() {
  await requireUser();
  const [state, pro] = await Promise.all([getCoachState(), isPro()]);
  const { latest, eligibility } = state;
  const t = await getTranslations("coachPage");
  const tNav = await getTranslations("nav");
  const locale = await getLocale();

  const canRun = pro && eligibility.state === "ready";

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink href="/field-log" label={tNav("fieldLog")} />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          {t("heading")}
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          {t("subheading")}
        </p>
      </header>

      <section className="mt-7 rounded border border-rule bg-[var(--paper-raised)] p-5">
        <h2 className="text-sm font-semibold text-ink">
          {latest ? t("readItAgain") : t("readMyLog")}
        </h2>

        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          {!pro
            ? t("partOfSubscription")
            : eligibility.state === "locked"
              ? t("locked", { count: eligibility.repsNeeded })
              : eligibility.state === "waiting"
                ? t("waiting", {
                    newReps: eligibility.newReps,
                    newRepsNeeded: eligibility.newRepsNeeded,
                  })
                : latest
                  ? t("readySinceLast", {
                      count: eligibility.newReps,
                      cappedClause: eligibility.capped ? t("cappedClause") : "",
                    })
                  : t("conversationsToRead", { count: eligibility.newReps })}
        </p>

        {pro ? (
          <RunReview
            disabled={!canRun}
            label={latest ? t("readWhatIsNew") : t("readMyLog")}
            since={latest?.coversThrough ?? ""}
          />
        ) : (
          <Link
            href="/pro"
            className="mt-5 inline-flex rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
          >
            {t("whatSubscriptionUnlocks")}
          </Link>
        )}
      </section>

      {latest ? (
        <article className="mt-9">
          <p className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
            {new Date(latest.createdAt).toLocaleDateString(locale, {
              day: "numeric",
              month: "long",
              year: "numeric",
            })}{" "}
            · {t("readOfTotal", { read: latest.repsRead, total: latest.repsTotal })}
          </p>

          <h2 className="mt-3 text-lg font-semibold leading-snug tracking-tight text-ink">
            {latest.review.headline}
          </h2>

          <section className="mt-7">
            <h3 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
              {t("whatKeepsHappening")}
            </h3>
            <ol className="mt-4 flex flex-col gap-5">
              {latest.review.patterns.map((pattern, i) => (
                <li key={i} className="border-l-2 border-rule-strong pl-4">
                  <p className="text-sm font-medium text-ink">{pattern.title}</p>
                  <p className="mt-1.5 text-[15px] leading-[1.6] text-ink">
                    {pattern.detail}
                  </p>
                  {pattern.evidence ? (
                    <p className="mt-2 text-[13px] leading-relaxed text-ink-muted">
                      {pattern.evidence}
                    </p>
                  ) : null}
                </li>
              ))}
            </ol>
          </section>

          <section className="mt-8">
            <h3 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
              {t("whatIsWorking")}
            </h3>
            <p className="mt-3 text-[15px] leading-[1.6] text-ink">
              {latest.review.working}
            </p>
          </section>

          <section className="mt-8 rounded border border-[var(--accent)] bg-[var(--accent-soft)] p-5">
            <h3 className="tabular text-xs uppercase tracking-[0.18em] text-[var(--accent)]">
              {t("theOneThingToChange")}
            </h3>
            <p className="mt-3 text-[15px] leading-[1.6] text-ink">
              {latest.review.oneThing}
            </p>
            <p className="mt-4 border-t border-[var(--accent)]/30 pt-4 text-[15px] leading-[1.6] text-ink">
              <span className="font-medium">{t("nextConversation")} </span>
              {latest.review.nextRep}
            </p>
            <Link
              href="/log"
              className="mt-4 inline-flex rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
            >
              {t("logTheNextOne")}
            </Link>
          </section>
        </article>
      ) : (
        <p className="mt-8 text-[13px] leading-relaxed text-ink-muted">
          {t("nothingReadYet")}
        </p>
      )}
    </main>
  );
}
