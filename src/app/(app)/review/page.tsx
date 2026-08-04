import Link from "next/link";

import { BackLink } from "@/components/back-link";
import { requireUser } from "@/lib/auth/dal";
import { getWeeklyReview } from "@/lib/progress/queries";
import { WENT_LABELS } from "@/lib/progress/rules";
import { RewriteForm } from "./rewrite-form";

export const metadata = { title: "Weekly review — Reps" };

export default async function ReviewPage() {
  await requireUser();
  const review = await getWeeklyReview();

  const weekLabel = new Date(review.weekStart).toLocaleDateString(undefined, {
    day: "numeric",
    month: "long",
  });

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink href="/today" label="Today" />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          Weekly review
        </h1>
        <p className="tabular mt-2 text-xs text-ink-faint">
          Week beginning {weekLabel}
        </p>
      </header>

      {review.reps === 0 ? (
        <div className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6">
          <h2 className="text-sm font-semibold text-ink">Nothing logged yet</h2>
          <p className="mt-2 text-sm leading-relaxed text-ink-muted">
            The review fills up as you log reps. One conversation is enough to
            start it.
          </p>
          <Link
            href="/log"
            className="mt-4 inline-block rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
          >
            Log a rep
          </Link>
        </div>
      ) : (
        <>
          <dl className="mt-7 flex gap-8">
            <div>
              <dt className="tabular text-xs uppercase tracking-[0.14em] text-ink-faint">
                Reps
              </dt>
              <dd className="tabular mt-1 text-2xl text-ink">{review.reps}</dd>
            </div>
            <div>
              <dt className="tabular text-xs uppercase tracking-[0.14em] text-ink-faint">
                Skills touched
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
                Worth a second look
              </h2>

              <div className="mt-4 border-l-2 border-rule-strong pl-4">
                <div className="flex flex-wrap items-baseline gap-x-3 gap-y-1">
                  <span className="text-sm font-medium text-ink">
                    {review.worstRep.skills?.name ?? "A rep"}
                  </span>
                  <span className="tabular rounded border border-[var(--rule-strong)] px-1.5 py-0.5 text-[11px] text-ink-muted">
                    {WENT_LABELS[review.worstRep.went]}
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
                Nothing left to rewrite
              </h2>
              <p className="mt-2 text-sm leading-relaxed text-ink-muted">
                You have been back through every rep this week. That is the
                whole review done.
              </p>
            </section>
          )}
        </>
      )}
    </main>
  );
}
