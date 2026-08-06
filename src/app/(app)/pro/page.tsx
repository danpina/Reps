import Link from "next/link";

import { requireUser } from "@/lib/auth/dal";
import {
  FREE_PREVIEW_LESSONS,
  FREE_REHEARSALS,
  getSubscription,
  isPro,
} from "@/lib/billing/entitlement";
import { getTopics } from "@/lib/curriculum/queries";

export const metadata = { title: "Subscription — Reps" };

export default async function ProPage() {
  await requireUser();
  const [topics, pro, subscription] = await Promise.all([
    getTopics(),
    isPro(),
    getSubscription(),
  ]);

  const written = topics.filter((t) => t.skills.length > 0);
  const lessons = topics.reduce(
    (sum, t) => sum + t.skills.reduce((n, s) => n + s.lessons.length, 0),
    0,
  );

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <h1 className="text-xl font-semibold tracking-tight text-ink">
          {pro ? "Your subscription" : "What a subscription unlocks"}
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          {pro
            ? "Everything is open. Thank you — this is what pays for the writing."
            : `${lessons} lessons across ${written.length} ${written.length === 1 ? "topic" : "topics"}, and an AI partner to rehearse each one against.`}
        </p>
      </header>

      {pro ? (
        <section className="mt-8 rounded border border-[var(--accent)] bg-[var(--accent-soft)] p-5">
          <p className="text-sm text-ink">
            Active
            {subscription?.source === "manual" ? ", granted by hand" : ""}
            {subscription?.current_period_end
              ? ` until ${new Date(subscription.current_period_end).toLocaleDateString()}`
              : "."}
          </p>
          <Link
            href="/topics"
            className="mt-4 inline-flex rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
          >
            Go and read something
          </Link>
        </section>
      ) : (
        <>
          <section className="mt-8">
            <h2 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
              Free, and staying free
            </h2>
            <ul className="mt-4 flex flex-col gap-3">
              <Item>
                The first {FREE_PREVIEW_LESSONS} lessons of every topic, so you
                can read the actual writing before deciding anything.
              </Item>
              <Item>
                {FREE_REHEARSALS === 1
                  ? "One rehearsal against the AI partner."
                  : `${FREE_REHEARSALS} rehearsals against the AI partner.`}{" "}
                It stays in character and it does not go easy on you.
              </Item>
              <Item>
                The field log, streaks, XP and the weekly review — for as many
                real conversations as you ever have. The reps are the part that
                makes you better, and putting a meter on those would be
                charging for the wrong half.
              </Item>
            </ul>
          </section>

          <section className="mt-9">
            <h2 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
              What you are paying for
            </h2>
            <ul className="mt-4 flex flex-col gap-3">
              <Item>Every lesson in every topic, including the ones below.</Item>
              <Item>
                Unlimited rehearsals, and the scored feedback at the end of each
                scene.
              </Item>
              <Item>
                The end-of-track recaps, and every topic added after you join.
              </Item>
            </ul>

            <ol className="mt-6">
              {topics.map((topic) => (
                <li
                  key={topic.id}
                  className="flex items-baseline gap-3 border-b border-rule py-3"
                >
                  <span className="tabular text-xs text-ink-faint">
                    {String(topic.sort_order).padStart(2, "0")}
                  </span>
                  <span className="text-sm text-ink">{topic.name}</span>
                  <span className="tabular ml-auto shrink-0 text-xs text-ink-faint">
                    {topic.skills.length === 0
                      ? "being written"
                      : `${topic.skills.reduce((n, s) => n + s.lessons.length, 0)} lessons`}
                  </span>
                </li>
              ))}
            </ol>
          </section>

          <section className="mt-9 rounded border border-rule bg-[var(--paper-raised)] p-5">
            <h2 className="text-sm font-semibold text-ink">
              Checkout is not open yet
            </h2>
            <p className="mt-2 text-sm leading-relaxed text-ink-muted">
              Accounts are being opened by hand while the remaining topics are
              written. Ask, and you will be let in. Nothing here will start
              charging you without you typing a card number into a page that
              says so.
            </p>
          </section>
        </>
      )}
    </main>
  );
}

function Item({ children }: { children: React.ReactNode }) {
  return (
    <li className="flex gap-3 text-sm leading-relaxed text-ink-muted">
      <span aria-hidden className="mt-1.5 h-1 w-1 shrink-0 rounded-full bg-[var(--accent)]" />
      <span>{children}</span>
    </li>
  );
}
