import Link from "next/link";
import { getTranslations } from "next-intl/server";

import { getLocale, getProfile, requireUser } from "@/lib/auth/dal";
import { MIN_REPS_FOR_REVIEW } from "@/lib/coach/eligibility";
import { describeOtherLocalized } from "@/lib/profile/demographics";
import {
  getBadges,
  getFieldLog,
  getTotals,
  type FieldLogEntry,
} from "@/lib/progress/queries";
import { wentLabel, XP_AWARD } from "@/lib/progress/rules";
import type { Translate } from "@/lib/i18n";

export async function generateMetadata() {
  const t = await getTranslations("fieldLog");
  return { title: t("pageTitle") };
}

const WENT_TONE: Record<number, string> = {
  1: "border-[var(--rule-strong)] text-ink-muted",
  2: "border-[var(--rule-strong)] text-ink",
  3: "border-[var(--accent)] text-[var(--accent)]",
};

/**
 * `loggedDate` is a plain yyyy-mm-dd in the user's own timezone. It is parsed
 * as local rather than passed to `new Date(iso)`, which would read it as UTC
 * and shift the label by a day for anyone west of Greenwich.
 */
function dayLabel(
  loggedDate: string,
  todayIso: string,
  locale: string,
  t: Translate,
): string {
  if (loggedDate === todayIso) return t("today");

  const [y, m, d] = loggedDate.split("-").map(Number);
  const date = new Date(y, m - 1, d);

  const [ty, tm, td] = todayIso.split("-").map(Number);
  const yesterday = new Date(ty, tm - 1, td - 1);

  if (date.toDateString() === yesterday.toDateString()) return t("yesterday");

  return date.toLocaleDateString(locale, {
    weekday: "long",
    day: "numeric",
    month: "long",
  });
}

export default async function FieldLogPage({
  searchParams,
}: {
  searchParams: Promise<{
    skill?: string;
    topic?: string;
    went?: string;
    logged?: string;
    badges?: string;
    edited?: string;
    deleted?: string;
    error?: string;
  }>;
}) {
  await requireUser();
  const profile = await getProfile();
  const params = await searchParams;
  const t = await getTranslations("fieldLog");
  const tWent = await getTranslations("went");
  const tDemographics = await getTranslations("demographics");
  const locale = await getLocale();

  const justEarned = params.badges
    ? (await getBadges()).earned.filter((b) =>
        params.badges!.split(",").includes(b.slug),
      )
    : [];

  const wentFilter = Number(params.went);

  // Everything, once. The chips are built from the whole log rather than from
  // the filtered view, so choosing a topic does not make every other topic's
  // chip disappear — which is what happens when a filter is built from its own
  // results.
  const [everything, totals] = await Promise.all([getFieldLog({}), getTotals()]);

  const entries = everything.filter(
    (e) =>
      (!params.topic || e.skills?.topics?.slug === params.topic) &&
      (!params.skill || e.skills?.slug === params.skill) &&
      (![1, 2, 3].includes(wentFilter) || e.went === wentFilter),
  );

  const isFiltered = Boolean(params.skill || params.went || params.topic);

  // Topics that actually appear in the log, in the order they first appear.
  const topics = [
    ...new Map(
      everything
        .map((e) => e.skills?.topics)
        .filter((t): t is { slug: string; name: string } => Boolean(t))
        .map((t) => [t.slug, t] as const),
    ).values(),
  ];

  // Skills are only offered once a topic is chosen. Across every topic this
  // row would run to fifty chips, and half of them would say Openers.
  const skillsInTopic = params.topic
    ? [
        ...new Map(
          everything
            .filter((e) => e.skills?.topics?.slug === params.topic)
            .map((e) => e.skills!)
            .map((s) => [s.slug, s] as const),
        ).values(),
      ]
    : [];

  // Group by the user's own calendar day so the log reads as a diary rather
  // than a list, and so the headings do not move with the server's timezone.
  const days = new Map<string, typeof entries>();
  for (const entry of entries) {
    const key = entry.logged_date;
    days.set(key, [...(days.get(key) ?? []), entry]);
  }

  // "Today" has to mean the user's today, not the host's. The timezone is
  // captured from the browser whenever a rep is logged.
  const zone = profile?.timezone ?? undefined;
  const todayIso = new Date().toLocaleDateString("en-CA", { timeZone: zone });

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <h1 className="text-xl font-semibold tracking-tight text-ink">
          {t("heading")}
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          {t("subheading")}
        </p>

        {/* The threshold is stated here rather than only on the page behind
            it, so the number is something to aim at while you are looking at
            how many you have. */}
        <Link
          href="/coach"
          className="mt-3 inline-block text-xs text-ink-faint underline-offset-4 hover:text-ink hover:underline"
        >
          {totals.repsLogged >= MIN_REPS_FOR_REVIEW
            ? t("readForPatterns")
            : t("readForPatternsWithCount", {
                count: MIN_REPS_FOR_REVIEW - totals.repsLogged,
              })}
        </Link>

        <dl className="mt-5 flex gap-8">
          <div>
            <dt className="tabular text-xs uppercase tracking-[0.14em] text-ink-faint">
              {t("reps")}
            </dt>
            <dd className="tabular mt-1 text-2xl text-ink">{totals.repsLogged}</dd>
          </div>
          <div>
            <dt className="tabular text-xs uppercase tracking-[0.14em] text-ink-faint">
              {t("streak")}
            </dt>
            <dd className="tabular mt-1 text-2xl text-ink">
              {totals.currentStreak}
            </dd>
          </div>
          <div>
            <dt className="tabular text-xs uppercase tracking-[0.14em] text-ink-faint">
              {t("longest")}
            </dt>
            <dd className="tabular mt-1 text-2xl text-ink">
              {totals.longestStreak}
            </dd>
          </div>
        </dl>
      </header>

      {params.logged ? (
        <div
          role="status"
          className="mt-5 rounded border border-[var(--accent)] bg-[var(--accent-soft)] px-4 py-3"
        >
          <p className="text-sm text-ink">
            {t("loggedNotice", { xp: XP_AWARD.mission })}
          </p>

          {justEarned.length > 0 ? (
            <div className="mt-3 border-t border-[var(--accent)]/30 pt-3">
              <p className="tabular text-xs uppercase tracking-[0.14em] text-[var(--accent)]">
                {t("badgesEarned", { count: justEarned.length })}
              </p>
              <ul className="mt-2 flex flex-col gap-1.5">
                {justEarned.map((badge) => (
                  <li key={badge.id} className="text-sm text-ink">
                    <span className="font-medium">{badge.name}</span>
                    <span className="text-ink-muted"> — {badge.description}</span>
                  </li>
                ))}
              </ul>
            </div>
          ) : null}
        </div>
      ) : null}

      {params.error ? (
        <p
          role="alert"
          className="mt-5 rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm text-ink"
        >
          {t("deleteFailed")}
        </p>
      ) : params.edited || params.deleted ? (
        <p
          role="status"
          className="mt-5 rounded border border-rule bg-[var(--paper-raised)] px-4 py-3 text-sm text-ink"
        >
          {params.deleted ? t("repDeleted") : t("repUpdated")}
        </p>
      ) : null}

      {entries.length > 0 || isFiltered ? (
        <nav
          aria-label={t("filterAriaLabel")}
          className="mt-6 flex flex-col gap-3 border-b border-rule pb-5"
        >
          <div className="flex flex-wrap items-center gap-2">
            <FilterChip
              href="/field-log"
              active={!isFiltered}
              label={t("everything")}
            />
            {[3, 2, 1].map((value) => (
              <FilterChip
                key={value}
                href={`/field-log?went=${value}`}
                active={wentFilter === value}
                label={wentLabel(tWent, value)}
              />
            ))}
          </div>

          {topics.length > 1 || params.topic ? (
            <div className="flex flex-wrap items-center gap-2">
              {topics.map((topic) => (
                <FilterChip
                  key={topic.slug}
                  href={`/field-log?topic=${topic.slug}`}
                  active={params.topic === topic.slug}
                  label={topic.name}
                />
              ))}
            </div>
          ) : null}

          {/* Only once a topic is chosen — a second row of chips is fine, a
              second row of fifty is not. */}
          {skillsInTopic.length > 1 ? (
            <div className="flex flex-wrap items-center gap-2 pl-1">
              {skillsInTopic.map((skill) => (
                <FilterChip
                  key={skill.slug}
                  href={`/field-log?topic=${params.topic}&skill=${skill.slug}`}
                  active={params.skill === skill.slug}
                  label={skill.name}
                />
              ))}
            </div>
          ) : null}
        </nav>
      ) : null}

      {entries.length === 0 ? (
        <EmptyState filtered={isFiltered} t={t} />
      ) : (
        <div className="mt-2">
          {[...days.entries()].map(([day, dayEntries]) => (
            <section key={day} className="border-b border-rule py-6">
              <h2 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
                {dayLabel(day, todayIso, locale, t)}
              </h2>

              <ol className="mt-4 flex flex-col gap-5">
                {dayEntries.map((entry) => (
                  <li
                    key={entry.id}
                    className="border-l-2 border-rule-strong pl-4"
                  >
                    {/* The topic sits above the skill rather than beside it.
                        A skill name alone stopped identifying a rep the moment
                        two topics could both have an "Openers". */}
                    {entry.skills?.topics ? (
                      <p className="tabular text-[11px] uppercase tracking-[0.14em] text-ink-faint">
                        {entry.skills.topics.name}
                      </p>
                    ) : null}

                    <div className="mt-0.5 flex flex-wrap items-baseline gap-x-3 gap-y-1">
                      <span className="text-sm font-medium text-ink">
                        {entry.skills?.name ?? t("aRep")}
                      </span>
                      <span
                        className={`tabular rounded border px-1.5 py-0.5 text-[11px] ${WENT_TONE[entry.went]}`}
                      >
                        {wentLabel(tWent, entry.went)}
                      </span>
                      <span className="tabular ml-auto text-xs text-ink-faint">
                        {new Date(entry.logged_at).toLocaleTimeString(locale, {
                          hour: "2-digit",
                          minute: "2-digit",
                          timeZone: zone,
                        })}
                      </span>
                    </div>

                    {entry.context_note || who(entry, tDemographics) ? (
                      <p className="mt-1.5 text-[13px] text-ink-muted">
                        {[entry.context_note, who(entry, tDemographics)]
                          .filter(Boolean)
                          .join(" · ")}
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

                    {/* Quiet, but a control rather than a caption. It used to
                        be a bare word in exactly the size and colour of the
                        mission line directly above it, which made it read as
                        the last line of the entry instead of the way to
                        correct one. A border and a tap target are the whole
                        difference between an affordance and a footnote. */}
                    <Link
                      href={`/field-log/${entry.id}`}
                      aria-label={t("editThis", {
                        name: entry.skills?.name ?? t("rep"),
                      })}
                      className="mt-3 inline-flex items-center rounded border border-[var(--rule-strong)] px-2.5 py-1 text-[12px] text-ink-muted transition-colors hover:bg-[var(--paper-raised)] hover:text-ink"
                    >
                      {t("edit")}
                    </Link>
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

/** Who the rep was with, when it was recorded. Sits beside the context note. */
function who(entry: FieldLogEntry, t: Translate): string | null {
  return describeOtherLocalized(t, entry.other_sex, entry.other_age_group);
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

function EmptyState({ filtered, t }: { filtered: boolean; t: Translate }) {
  if (filtered) {
    return (
      <div className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6">
        <p className="text-sm leading-relaxed text-ink">
          {t("noneMatchFilter")}
        </p>
        <Link
          href="/field-log"
          className="mt-3 inline-block text-sm font-medium text-ink underline underline-offset-4"
        >
          {t("showEverything")}
        </Link>
      </div>
    );
  }

  return (
    <div className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6">
      <h2 className="text-sm font-semibold text-ink">
        {t("firstRepHeading")}
      </h2>
      <p className="mt-2 text-sm leading-relaxed text-ink-muted">
        {t("firstRepBody")}
      </p>
      <div className="mt-4 flex flex-wrap gap-2">
        <Link
          href="/skills/openers/1"
          className="rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
        >
          {t("startWithOpeners")}
        </Link>
        <Link
          href="/log"
          className="rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper)]"
        >
          {t("logOneNow")}
        </Link>
      </div>
    </div>
  );
}
