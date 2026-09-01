import Link from "next/link";
import { getTranslations } from "next-intl/server";

import { BackLink } from "@/components/back-link";
import { getLocale, requireUser } from "@/lib/auth/dal";
import { getWeeklyReview } from "@/lib/progress/queries";
import { wentLabel } from "@/lib/progress/rules";
import { RewriteForm } from "./rewrite-form";

export async function generateMetadata() {
  const t = await getTranslations("review");
  return { title: t("pageTitle") };
}

export default async function ReviewPage() {
  await requireUser();
  const review = await getWeeklyReview();
  const t = await getTranslations("review");
  const tNav = await getTranslations("nav");
  const tWent = await getTranslations("went");
  const locale = await getLocale();

  const weekLabel = new Date(review.weekStart).toLocaleDateString(locale, {
    day: "numeric",
    month: "long",
  });

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink href="/today" label={tNav("today")} />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          {t("heading")}
        </h1>
        <p className="tabular mt-2 text-xs text-ink-faint">
          {t("weekBeginning", { date: weekLabel })}
        </p>
      </header>

      {review.reps === 0 ? (
        <div className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6">
          <h2 className="text-sm font-semibold text-ink">
            {t("nothingLoggedYet")}
          </h2>
          <p className="mt-2 text-sm leading-relaxed text-ink-muted">
            {t("nothingLoggedYetBody")}
          </p>
          <Link
            href="/log"
            className="mt-4 inline-block rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
          >
            {t("logARep")}
          </Link>
        </div>
      ) : (
        <>
          <dl className="mt-7 flex gap-8">
            <div>
              <dt className="tabular text-xs uppercase tracking-[0.14em] text-ink-faint">
                {t("reps")}
              </dt>
              <dd className="tabular mt-1 text-2xl text-ink">{review.reps}</dd>
            </div>
            <div>
              <dt className="tabular text-xs uppercase tracking-[0.14em] text-ink-faint">
                {t("skillsTouched")}
              </dt>
              <dd className="tabular mt-1 text-2xl text-ink">
                {review.skillsTouched.length}
              </dd>
            </div>
          </dl>

          {review.skillsTouched.length > 0 ? (
            <p className="mt-3 text-sm leading-relaxed text-ink-muted">
              {review.skillsTouched.join(", ")}.
            </p>
          ) : null}

          {review.worstRep ? (
            <section className="mt-9 rounded border border-rule bg-[var(--paper-raised)] p-5">
              <h2 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
                {t("worthASecondLook")}
              </h2>

              <div className="mt-4 border-l-2 border-rule-strong pl-4">
                <div className="flex flex-wrap items-baseline gap-x-3 gap-y-1">
                  <span className="text-sm font-medium text-ink">
                    {review.worstRep.skills?.name ?? t("aRep")}
                  </span>
                  <span className="tabular rounded border border-[var(--rule-strong)] px-1.5 py-0.5 text-[11px] text-ink-muted">
                    {wentLabel(tWent, review.worstRep.went)}
                  </span>
                </div>

                {review.worstRep.context_note ? (
                  <p className="mt-1.5 text-[13px] text-ink-muted">
                    {review.worstRep.context_note}
                  </p>
                ) : null}

                {review.worstRep.reflection ? (
                  <p className="mt-2 text-[15px] leading-[1.6] text-ink">
                    {review.worstRep.reflection}
                  </p>
                ) : null}
              </div>

              <RewriteForm logId={review.worstRep.id} />
            </section>
          ) : (
            <section className="mt-9 rounded border border-rule bg-[var(--paper-raised)] p-5">
              <h2 className="text-sm font-semibold text-ink">
                {t("nothingLeftToRewrite")}
              </h2>
              <p className="mt-2 text-sm leading-relaxed text-ink-muted">
                {t("nothingLeftToRewriteBody")}
              </p>
            </section>
          )}
        </>
      )}
    </main>
  );
}
