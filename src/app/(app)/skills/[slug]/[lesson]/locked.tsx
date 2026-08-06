import Link from "next/link";

import { FREE_PREVIEW_LESSONS } from "@/lib/billing/entitlement";

/**
 * What a lesson looks like when the account has not paid for it.
 *
 * It says the title, the position and what the topic is for, and then it
 * stops. No blurred paragraph, no first line of the theory card teasing the
 * rest — a paywall that shows you the goods through frosted glass is annoying
 * in a way that costs more goodwill than the extra pressure buys.
 *
 * The row level security policy on `lessons` is what actually refuses. This
 * screen only explains a refusal that has already happened.
 */
export function LockedLesson({
  skillName,
  skillSlug,
  topicName,
  lessonTitle,
  sortOrder,
  total,
}: {
  skillName: string;
  skillSlug: string;
  topicName: string;
  lessonTitle: string;
  sortOrder: number;
  total: number;
}) {
  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <Link
          href={`/skills/${skillSlug}`}
          className="text-xs text-ink-faint underline-offset-4 hover:text-ink hover:underline"
        >
          ← {skillName}
        </Link>
        <p className="tabular mt-3 text-xs text-ink-faint">
          Lesson {sortOrder} of {total}
        </p>
        <h1 className="mt-1.5 text-xl font-semibold tracking-tight text-ink">
          {lessonTitle}
        </h1>
      </header>

      <section className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6">
        <h2 className="text-sm font-semibold text-ink">
          This one is part of the subscription
        </h2>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          The first {FREE_PREVIEW_LESSONS} lessons of every topic are open, so
          you can read enough of {topicName} to judge whether the writing is
          worth paying for. This is not one of them.
        </p>

        <div className="mt-5 flex flex-wrap gap-2">
          <Link
            href="/pro"
            className="rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
          >
            See what it unlocks
          </Link>
          <Link
            href={`/skills/${skillSlug}`}
            className="rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper)]"
          >
            Back to the track
          </Link>
        </div>
      </section>

      <p className="mt-6 text-[13px] leading-relaxed text-ink-muted">
        Logging reps stays free either way. The conversations are the part that
        makes you better, and charging for the diary you keep about them would
        be charging for the wrong half.
      </p>
    </main>
  );
}
