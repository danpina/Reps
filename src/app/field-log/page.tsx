import Link from "next/link";

import { requireUser } from "@/lib/auth/dal";
import { getSkills } from "@/lib/curriculum/queries";
import { getFieldLog, getTotals } from "@/lib/progress/queries";
import { WENT_LABELS } from "@/lib/progress/rules";

export const metadata = { title: "Field log — Reps" };

const WENT_TONE: Record<number, string> = {
  1: "border-[var(--rule-strong)] text-ink-muted",
  2: "border-[var(--rule-strong)] text-ink",
  3: "border-[var(--accent)] text-[var(--accent)]",
};

function dayLabel(iso: string): string {
  const date = new Date(iso);
  const today = new Date();
  const yesterday = new Date();
  yesterday.setDate(today.getDate() - 1);

  const same = (a: Date, b: Date) => a.toDateString() === b.toDateString();
  if (same(date, today)) return "Today";
  if (same(date, yesterday)) return "Yesterday";

  return date.toLocaleDateString(undefined, {
    weekday: "long",
    day: "numeric",
    month: "long",
  });
}

export default async function FieldLogPage({
  searchParams,
}: {
  searchParams: Promise<{ skill?: string; went?: string; logged?: string }>;
}) {
  await requireUser();
  const params = await searchParams;

  const wentFilter = Number(params.went);
  const entries = await getFieldLog({
    skillSlug: params.skill,
    went: [1, 2, 3].includes(wentFilter) ? wentFilter : undefined,
  });

  const [totals, skills] = await Promise.all([getTotals(), getSkills()]);
  const isFiltered = Boolean(params.skill || params.went);

  // Group by calendar day so the log reads as a diary rather than a list.
  const days = new Map<string, typeof entries>();
  for (const entry of entries) {
    const key = new Date(entry.logged_at).toDateString();
    days.set(key, [...(days.get(key) ?? []), entry]);
  }

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <Link
          href="/today"
          className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint underline-offset-4 hover:underline"
        >
          Reps
        </Link>
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          Field log
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          Every real conversation you have logged. This is the part that counts.
        </p>

        <dl className="mt-5 flex gap-8">
          <div>
            <dt className="tabular text-xs uppercase tracking-[0.14em] text-ink-faint">
              Reps
            </dt>
            <dd className="tabular mt-1 text-2xl text-ink">{totals.repsLogged}</dd>
          </div>
          <div>
            <dt className="tabular text-xs uppercase tracking-[0.14em] text-ink-faint">
              Streak
            </dt>
            <dd className="tabular mt-1 text-2xl text-ink">
              {totals.currentStreak}
            </dd>
          </div>
          <div>
            <dt className="tabular text-xs uppercase tracking-[0.14em] text-ink-faint">
              Longest
            </dt>
            <dd className="tabular mt-1 text-2xl text-ink">
              {totals.longestStreak}
            </dd>
          </div>
        </dl>
      </header>

      {params.logged ? (
        <p
          role="status"
          className="mt-5 rounded border border-[var(--accent)] bg-[var(--accent-soft)] px-4 py-3 text-sm text-ink"
        >
          Logged. That one counts whether it went well or not.
        </p>
      ) : null}

      {entries.length > 0 || isFiltered ? (
        <nav
          aria-label="Filter the log"
          className="mt-6 flex flex-wrap items-center gap-2 border-b border-rule pb-5"
        >
          <FilterChip href="/field-log" active={!isFiltered} label="Everything" />
          {[3, 2, 1].map((value) => (
            <FilterChip
              key={value}
              href={`/field-log?went=${value}`}
              active={wentFilter === value}
              label={WENT_LABELS[value]}
            />
          ))}
          {skills
            .filter((s) => entries.some((e) => e.skills?.slug === s.slug))
            .map((skill) => (
              <FilterChip
                key={skill.id}
                href={`/field-log?skill=${skill.slug}`}
                active={params.skill === skill.slug}
                label={skill.name}
              />
            ))}
        </nav>
      ) : null}

      {entries.length === 0 ? (
        <EmptyState filtered={isFiltered} />
      ) : (
        <div className="mt-2">
          {[...days.entries()].map(([day, dayEntries]) => (
            <section key={day} className="border-b border-rule py-6">
              <h2 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
                {dayLabel(dayEntries[0].logged_at)}
              </h2>

              <ol className="mt-4 flex flex-col gap-5">
                {dayEntries.map((entry) => (
                  <li
                    key={entry.id}
                    className="border-l-2 border-rule-strong pl-4"
                  >
                    <div className="flex flex-wrap items-baseline gap-x-3 gap-y-1">
                      <span className="text-sm font-medium text-ink">
                        {entry.skills?.name ?? "A rep"}
                      </span>
                      <span
                        className={`tabular rounded border px-1.5 py-0.5 text-[11px] ${WENT_TONE[entry.went]}`}
                      >
                        {WENT_LABELS[entry.went]}
                      </span>
                      <span className="tabular ml-auto text-xs text-ink-faint">
                        {new Date(entry.logged_at).toLocaleTimeString(undefined, {
                          hour: "2-digit",
                          minute: "2-digit",
                        })}
                      </span>
                    </div>

                    {entry.context_note ? (
                      <p className="mt-1.5 text-[13px] text-ink-muted">
                        {entry.context_note}
                      </p>
                    ) : null}

                    {entry.reflection ? (
                      <p className="mt-2 text-[15px] leading-[1.6] text-ink">
                        {entry.reflection}
                      </p>
                    ) : null}

                    {entry.mission_text ? (
                      <p className="mt-2 text-[12px] leading-relaxed text-ink-faint">
                        {entry.mission_text}
                      </p>
                    ) : null}
                  </li>
                ))}
              </ol>
            </section>
          ))}
        </div>
      )}
    </main>
  );
}

function FilterChip({
  href,
  active,
  label,
}: {
  href: string;
  active: boolean;
  label: string;
}) {
  return (
    <Link
      href={href}
      aria-current={active ? "true" : undefined}
      className={[
        "rounded-full border px-3 py-1 text-xs transition-colors",
        active
          ? "border-[var(--accent)] bg-[var(--accent-soft)] text-ink"
          : "border-[var(--rule-strong)] text-ink-muted hover:bg-[var(--paper-raised)]",
      ].join(" ")}
    >
      {label}
    </Link>
  );
}

function EmptyState({ filtered }: { filtered: boolean }) {
  if (filtered) {
    return (
      <div className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6">
        <p className="text-sm leading-relaxed text-ink">
          No reps match that filter yet.
        </p>
        <Link
          href="/field-log"
          className="mt-3 inline-block text-sm font-medium text-ink underline underline-offset-4"
        >
          Show everything
        </Link>
      </div>
    );
  }

  return (
    <div className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6">
      <h2 className="text-sm font-semibold text-ink">
        Your first rep goes here
      </h2>
      <p className="mt-2 text-sm leading-relaxed text-ink-muted">
        Read a card, go and have one real conversation, then log it. In two
        months this screen is the proof you changed.
      </p>
      <div className="mt-4 flex flex-wrap gap-2">
        <Link
          href="/skills/openers/1"
          className="rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
        >
          Start with Openers
        </Link>
        <Link
          href="/log"
          className="rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper)]"
        >
          Log one now
        </Link>
      </div>
    </div>
  );
}
