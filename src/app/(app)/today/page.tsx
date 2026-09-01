import Link from "next/link";
import { getTranslations } from "next-intl/server";

import { signOut } from "@/app/(auth)/actions";
import { FactBanner } from "@/components/fact-banner";
import { Heatmap } from "@/components/heatmap";
import { Button } from "@/components/ui";
import { getLocale, getProfile, requireUser } from "@/lib/auth/dal";
import { factForLocale } from "@/lib/facts";
import {
  getBadges,
  getHeatmap,
  getSkillStandings,
  getTotals,
  getResumePoint,
  getWeeklyReview,
  groupByTopic,
} from "@/lib/progress/queries";
import {
  REPS_TO_THEORY_RATIO,
  describeNextLevelLocalized,
  xpTable,
} from "@/lib/progress/explain";
import { rankName, rankNote, rankProgress, repsToNextRank } from "@/lib/progress/ranks";
import { XP_AWARD } from "@/lib/progress/rules";
import { rehearsalCount } from "@/components/rehearsal-list";
import { countRehearsals } from "@/lib/roleplay/queries";

export default async function TodayPage() {
  const user = await requireUser();
  const [profile, totals, standings, heatmap, badges, review, resume, rehearsals] =
    await Promise.all([
      getProfile(),
      getTotals(),
      getSkillStandings(),
      getHeatmap(),
      getBadges(),
      getWeeklyReview(),
      getResumePoint(),
      countRehearsals(),
    ]);

  const t = await getTranslations("today");
  const tRehearsal = await getTranslations("rehearsalList");
  const locale = await getLocale();
  const fact = factForLocale(locale);
  const name = profile?.display_name?.trim();
  // Only skills with something in them, then grouped, so a topic heading only
  // appears once there is something under it.
  const started = groupByTopic(standings.filter((s) => s.progress.xp > 0));

  // Which fold is left open below. The topic they were last reading, or the
  // first one when that is not among the topics they have XP in — which also
  // covers having only one, and stops every fold being shut at once.
  const openTopic =
    started.find((t) => t.slug === resume?.topicSlug)?.slug ?? started[0]?.slug;
  const hasReview = review.reps > 0;
  const rank = rankProgress(totals.totalXp);

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="flex items-baseline justify-between gap-4 border-b border-rule pb-5">
        <h1 className="text-xl font-semibold tracking-tight text-ink">
          {name ? t("greetingWithName", { name }) : t("greeting")}
        </h1>
        <form action={signOut}>
          <Button variant="quiet" type="submit" className="px-3 py-1.5 text-xs">
            {t("signOut")}
          </Button>
        </form>
      </header>

      <div className="mt-7">
        <FactBanner fact={fact} />
      </div>

      <section className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6">
        <h2 className="text-sm font-semibold text-ink">
          {totals.repsLogged === 0 ? t("startATrack") : t("hadAConversation")}
        </h2>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          {totals.repsLogged === 0 ? t("startATrackBody") : t("logItBody")}
        </p>

        <div className="mt-4 flex flex-wrap gap-2">
          <Link
            href="/log"
            className="rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
          >
            {t("logARep")}
          </Link>
          <Link
            href={totals.repsLogged === 0 ? "/topics" : "/field-log"}
            className="rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper)]"
          >
            {totals.repsLogged === 0 ? t("browseTopics") : t("seeYourReps")}
          </Link>
        </div>

        {/* Quiet, and below the two things that matter, because a rehearsal is
            the warm up. It is here at all because the transcripts were
            otherwise only reachable from the lesson they were started on. */}
        {rehearsals > 0 ? (
          <Link
            href="/rehearse"
            className="mt-3 inline-block text-xs text-ink-faint underline-offset-4 hover:text-ink hover:underline"
          >
            {rehearsalCount(tRehearsal, rehearsals)} →
          </Link>
        ) : null}

        {/* No global level. Levels are per-skill, further down, where they say
            something specific rather than averaging nine skills into one
            number. */}
        <dl className="mt-6 grid grid-cols-2 gap-4 border-t border-rule pt-5">
          <Stat label={t("repsLogged")} value={totals.repsLogged} />
          <Stat
            label={t("currentStreak")}
            value={totals.currentStreak}
            note={
              totals.longestStreak > totals.currentStreak
                ? t("bestStreak", { count: totals.longestStreak })
                : undefined
            }
          />
        </dl>

        {/* Sits with the reps rather than above them, because it is what the
            reps add up to. Named rather than numbered: skills have levels, you
            have a rank, and two numbers on one screen invited an arithmetic
            that does not exist. */}
        <section
          aria-labelledby="rank"
          className="mt-6 border-t border-rule pt-5"
        >
          <div className="flex items-baseline justify-between gap-3">
            <h3
              id="rank"
              className="text-base font-medium tracking-tight text-ink"
            >
              {rankName(t, rank.rank)}
            </h3>
            <span className="tabular shrink-0 text-xs text-ink-faint">
              {t("rankXp", { xp: rank.xp, position: rank.position, total: rank.total })}
            </span>
          </div>

          <div
            className="mt-2.5 h-1.5 w-full overflow-hidden rounded-full bg-[var(--rule)]"
            role="progressbar"
            aria-valuenow={Math.round(rank.fraction * 100)}
            aria-valuemin={0}
            aria-valuemax={100}
            aria-label={
              rank.next
                ? t("progressToRank", { name: rankName(t, rank.next) })
                : t("everyRankEarnedAria")
            }
          >
            <div
              className="h-full bg-[var(--accent)]"
              style={{ width: `${Math.round(rank.fraction * 100)}%` }}
            />
          </div>

          {rank.next ? (
            <p className="mt-2.5 text-[13px] leading-relaxed text-ink-muted">
              {/* Said in conversations, not points. Nobody has a feel for 450
                  XP, and reps are the only currency the app wants spent. */}
              <span className="text-ink">
                {t("moreConversations", {
                  count: repsToNextRank(rank.toNext, XP_AWARD.mission),
                })}
              </span>{" "}
              {t("toRank", { name: rankName(t, rank.next), note: rankNote(t, rank.next) })}
            </p>
          ) : (
            <p className="mt-2.5 text-[13px] leading-relaxed text-ink-muted">
              {t("everyRankEarned", { note: rankNote(t, rank.rank) })}
            </p>
          )}
        </section>

        <details className="mt-5 border-t border-rule pt-4">
          <summary className="cursor-pointer text-xs text-ink-faint underline-offset-4 hover:underline">
            {t("howProgressWorks")}
          </summary>

          <dl className="mt-3 flex flex-col gap-2.5">
            {xpTable(t).map((row) => (
              <div key={row.label} className="flex items-baseline gap-3">
                <dt className="flex-1 text-[13px] leading-snug text-ink">
                  {row.label}
                  <span className="block text-[12px] text-ink-muted">
                    {row.note}
                  </span>
                </dt>
                <dd className="tabular shrink-0 text-sm text-ink">+{row.xp}</dd>
              </div>
            ))}
          </dl>

          <p className="mt-3 border-t border-rule pt-3 text-[12px] leading-relaxed text-ink-muted">
            {t("theoryRatio", { ratio: REPS_TO_THEORY_RATIO })}
          </p>
        </details>
      </section>

      {resume ? (
        <section className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-5">
          <h2 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
            {t("pickUpWhereYouLeftOff")}
          </h2>
          {/* Topic, then skill, then lesson. With one topic the skill name was
              enough to place you; with seven, "Openers" could be three
              different tracks. */}
          <p className="mt-3 text-xs text-ink-faint">
            {resume.topicName} · {resume.skillName}
          </p>
          <p className="mt-1 text-base font-medium text-ink">
            {t("lessonNumber", { number: resume.lessonSortOrder, title: resume.lessonTitle })}
          </p>
          <div className="mt-4 flex flex-wrap gap-2">
            <Link
              href={`/skills/${resume.skillSlug}/${resume.lessonSortOrder}`}
              className="rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
            >
              {t("backToThisLesson")}
            </Link>
            {resume.nextSortOrder ? (
              <Link
                href={`/skills/${resume.skillSlug}/${resume.nextSortOrder}`}
                className="rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper)]"
              >
                {t("nextLesson")}
              </Link>
            ) : null}
          </div>
        </section>
      ) : null}

      {hasReview ? (
        <section className="mt-8 rounded border border-[var(--flag)] bg-[var(--flag-soft)] p-5">
          <h2 className="tabular text-xs uppercase tracking-[0.18em] text-[var(--flag)]">
            {t("thisWeek")}
          </h2>
          <p className="mt-2 text-sm leading-relaxed text-ink">
            {t("repsAcrossSkills", {
              reps: review.reps,
              skills: review.skillsTouched.length,
            })}
          </p>
          <Link
            href="/review"
            className="mt-3 inline-block text-sm font-medium text-ink underline underline-offset-4"
          >
            {t("openWeeklyReview")}
          </Link>
        </section>
      ) : null}

      {totals.repsLogged > 0 ? (
        <section className="mt-9">
          <Heatmap days={heatmap} />
        </section>
      ) : null}

      {started.length > 0 ? (
        <section className="mt-9">
          <h2 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
            {t("whereYouAre")}
          </h2>
          {/* One fold per topic. With a single topic on the go this was a
              short list; someone working through four is looking at twenty
              progress bars on the screen they open every day, and the one they
              are actually mid-way through is somewhere in the middle of it.

              The topic they were last reading is the one left open, and nothing
              on screen says so — a label explaining why a thing is open is
              worse than the thing just being open. */}
          <div className="mt-4 flex flex-col gap-4">
            {started.map((topic) => (
              <details key={topic.slug} open={topic.slug === openTopic}>
                {/* The marker is drawn rather than inherited — see .chevron in
                    globals.css for why a flex summary has none of its own. */}
                <summary className="flex cursor-pointer list-none items-baseline gap-2 border-b border-rule pb-1.5 [&::-webkit-details-marker]:hidden">
                  <svg
                    viewBox="0 0 12 12"
                    aria-hidden
                    className="chevron mt-px h-3 w-3 shrink-0 text-ink-faint"
                  >
                    <path
                      d="M4.5 2.5 8 6l-3.5 3.5"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="1.5"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                    />
                  </svg>
                  <span className="text-sm font-medium text-ink">
                    {topic.name}
                  </span>
                  <span className="tabular ml-auto text-xs text-ink-faint">
                    {t("repsAcrossSkills", {
                      reps: topic.reps,
                      skills: topic.skills.length,
                    })}
                  </span>
                </summary>

                <ol className="mt-3 flex flex-col gap-4">
                  {topic.skills.map((skill) => (
                    <li key={skill.skill_id}>
                      <div className="flex items-baseline justify-between gap-3">
                        <Link
                          href={`/skills/${skill.slug}`}
                          className="text-sm text-ink-muted underline-offset-4 hover:text-ink hover:underline"
                        >
                          {skill.name}
                        </Link>
                        <span className="tabular text-xs text-ink-faint">
                          {t("levelNumber", { level: skill.progress.level })}
                          {skill.progress.isMax
                            ? ""
                            : ` · ${describeNextLevelLocalized(t, skill.progress)}`}
                        </span>
                      </div>
                      <Bar
                        fraction={skill.progress.fraction}
                        label={t("progressToNextLevel", { name: skill.name })}
                      />
                    </li>
                  ))}
                </ol>

                {/* The topic name used to be this link. It cannot be, now that
                    it is the thing you click to open the fold. */}
                <Link
                  href={`/topics/${topic.slug}`}
                  className="mt-3 inline-block text-xs text-ink-faint underline-offset-4 hover:text-ink hover:underline"
                >
                  {t("allOfTopic", { name: topic.name })} →
                </Link>
              </details>
            ))}
          </div>
        </section>
      ) : null}

      {badges.earned.length > 0 || totals.repsLogged > 0 ? (
        <section className="mt-9">
          <h2 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
            {t("badges")}
          </h2>

          {badges.earned.length === 0 ? (
            <p className="mt-3 text-sm leading-relaxed text-ink-muted">
              {t("noBadgesYet")}
            </p>
          ) : (
            <ul className="mt-4 flex flex-col gap-3">
              {badges.earned.map((badge) => (
                <li
                  key={badge.id}
                  className="rounded border border-[var(--accent)] bg-[var(--accent-soft)] px-4 py-3"
                >
                  <p className="text-sm font-medium text-ink">{badge.name}</p>
                  <p className="mt-1 text-[13px] leading-relaxed text-ink-muted">
                    {badge.description}
                  </p>
                </li>
              ))}
            </ul>
          )}

          {badges.locked.length > 0 ? (
            <details className="mt-4">
              <summary className="cursor-pointer text-xs text-ink-faint underline-offset-4 hover:underline">
                {t("stillToEarn", { count: badges.locked.length })}
              </summary>
              <ul className="mt-3 flex flex-col gap-2">
                {badges.locked.map((badge) => (
                  <li key={badge.id} className="text-[13px] leading-relaxed text-ink-faint">
                    <span className="text-ink-muted">{badge.name}</span>
                    {" — "}
                    {badge.description}
                  </li>
                ))}
              </ul>
            </details>
          ) : null}
        </section>
      ) : null}

      {/* Wraps rather than truncating: a long email on a narrow phone would
          otherwise push the credit off the edge of the screen. */}
      <footer className="mt-10 flex flex-wrap items-baseline justify-between gap-x-4 gap-y-1 text-xs text-ink-faint">
        <p>{t("signedInAs", { email: user.email ?? t("yourAccount") })}</p>
        <p>{t("designedBy")}</p>
      </footer>
    </main>
  );
}

function Stat({
  label,
  value,
  note,
}: {
  label: string;
  value: number;
  note?: string;
}) {
  return (
    <div>
      <dt className="text-xs text-ink-faint">{label}</dt>
      <dd className="tabular mt-1 text-2xl text-ink">
        {value}
        {note ? (
          <span className="ml-1.5 text-xs text-ink-faint">{note}</span>
        ) : null}
      </dd>
    </div>
  );
}

function Bar({ fraction, label }: { fraction: number; label: string }) {
  return (
    <div
      className="mt-2 h-1 w-full overflow-hidden rounded-full bg-[var(--rule)]"
      role="progressbar"
      aria-valuenow={Math.round(fraction * 100)}
      aria-valuemin={0}
      aria-valuemax={100}
      aria-label={label}
    >
      <div
        className="h-full bg-[var(--accent)]"
        style={{ width: `${fraction * 100}%` }}
      />
    </div>
  );
}
