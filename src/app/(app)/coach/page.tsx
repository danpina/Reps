import Link from "next/link";

import { BackLink } from "@/components/back-link";
import { requireUser } from "@/lib/auth/dal";
import { isPro } from "@/lib/billing/entitlement";
import { getCoachState } from "@/lib/coach/queries";
import { RunReview } from "./run-review";

export const metadata = { title: "A read of your log — Reps" };

export default async function CoachPage() {
  await requireUser();
  const [state, pro] = await Promise.all([getCoachState(), isPro()]);
  const { latest, eligibility } = state;

  const canRun = pro && eligibility.state === "ready";

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink href="/field-log" label="Field log" />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          A read of your log
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          Your rehearsals get reviewed one scene at a time. This reads the whole
          field log at once and looks for the thing that keeps happening —
          which is the part you cannot see from inside it.
        </p>
      </header>

      <section className="mt-7 rounded border border-rule bg-[var(--paper-raised)] p-5">
        <h2 className="text-sm font-semibold text-ink">
          {latest ? "Read it again" : "Read my log"}
        </h2>

        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          {!pro
            ? "A read of your log is part of the subscription."
            : eligibility.state === "locked"
              ? `${eligibility.repsNeeded} more ${
                  eligibility.repsNeeded === 1 ? "conversation" : "conversations"
                } to go. Ten is where a pattern stops being a coincidence, and a read written over fewer would just be a confident guess.`
              : eligibility.state === "waiting"
                ? `${eligibility.newReps} new since the last read. ${eligibility.newRepsNeeded} more and there will be something new to say — before that, you would get the same read with different adjectives.`
                : latest
                  ? `${eligibility.newReps} new ${
                      eligibility.newReps === 1 ? "conversation" : "conversations"
                    } since the last read.${
                      eligibility.capped
                        ? " Only the most recent will be read; the rest are already old news."
                        : ""
                    } The earlier ones are not read again — what was concluded about them carries forward instead.`
                  : `${eligibility.newReps} conversations to read.`}
        </p>

        {pro ? (
          <RunReview
            disabled={!canRun}
            label={latest ? "Read what is new" : "Read my log"}
            since={latest?.coversThrough ?? ""}
          />
        ) : (
          <Link
            href="/pro"
            className="mt-5 inline-flex rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
          >
            What a subscription unlocks
          </Link>
        )}
      </section>

      {latest ? (
        <article className="mt-9">
          <p className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
            {new Date(latest.createdAt).toLocaleDateString(undefined, {
              day: "numeric",
              month: "long",
              year: "numeric",
            })}{" "}
            · read {latest.repsRead} of {latest.repsTotal}{" "}
            {latest.repsTotal === 1 ? "rep" : "reps"}
          </p>

          <h2 className="mt-3 text-lg font-semibold leading-snug tracking-tight text-ink">
            {latest.review.headline}
          </h2>

          <section className="mt-7">
            <h3 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
              What keeps happening
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
              What is working
            </h3>
            <p className="mt-3 text-[15px] leading-[1.6] text-ink">
              {latest.review.working}
            </p>
          </section>

          <section className="mt-8 rounded border border-[var(--accent)] bg-[var(--accent-soft)] p-5">
            <h3 className="tabular text-xs uppercase tracking-[0.18em] text-[var(--accent)]">
              The one thing to change
            </h3>
            <p className="mt-3 text-[15px] leading-[1.6] text-ink">
              {latest.review.oneThing}
            </p>
            <p className="mt-4 border-t border-[var(--accent)]/30 pt-4 text-[15px] leading-[1.6] text-ink">
              <span className="font-medium">Next conversation: </span>
              {latest.review.nextRep}
            </p>
            <Link
              href="/log"
              className="mt-4 inline-flex rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
            >
              Log the next one
            </Link>
          </section>
        </article>
      ) : (
        <p className="mt-8 text-[13px] leading-relaxed text-ink-muted">
          Nothing read yet. Keep logging — this gets more useful the more there
          is to look at, and it only ever reads what it has not seen before.
        </p>
      )}
    </main>
  );
}
