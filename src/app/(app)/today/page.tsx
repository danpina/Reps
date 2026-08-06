import Link from "next/link";

import { signOut } from "@/app/(auth)/actions";
import { FactBanner } from "@/components/fact-banner";
import { Heatmap } from "@/components/heatmap";
import { Button } from "@/components/ui";
import { getProfile, requireUser } from "@/lib/auth/dal";
import { randomFact } from "@/lib/facts";
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
  XP_TABLE,
  describeNextLevel,
} from "@/lib/progress/explain";
import { rankProgress, repsToNextRank } from "@/lib/progress/ranks";
import { XP_AWARD } from "@/lib/progress/rules";

export default async function TodayPage() {
  const user = await requireUser();
  const [profile, totals, standings, heatmap, badges, review, resume] = await Promise.all([
    getProfile(),
    getTotals(),
    getSkillStandings(),
    getHeatmap(),
    getBadges(),
    getWeeklyReview(),
    getResumePoint(),
  ]);

  const fact = randomFact();
  const name = profile?.display_name?.trim();
  // Only skills with something in them, then grouped, so a topic heading only
  // appears once there is something under it.
  const started = groupByTopic(standings.filter((s) => s.progress.xp > 0));
  const hasReview = review.reps > 0;
  const rank = rankProgress(totals.totalXp);

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="flex items-baseline justify-between gap-4 border-b border-rule pb-5">
        <h1 className="text-xl font-semibold tracking-tight text-ink">
          {name ? `Good to see you, ${name}` : "Good to see you"}
        </h1>
        <form action={signOut}>
          <Button variant="quiet" type="submit" className="px-3 py-1.5 text-xs">
            Sign out
          </Button>
        </form>
      </header>

      {/* Named rather than numbered, and placed above everything else. Skills
          have levels; you have a rank. Two numbers on one screen invited an
          arithmetic that does not exist, and a name does not. */}
      <section aria-labelledby="rank" className="mt-7">
        <div className="flex items-baseline justify-between gap-3">
          <h2 id="rank" className="text-lg font-semibold tracking-tight text-ink">
            {rank.rank.name}
          </h2>
          <span className="tabular shrink-0 text-xs text-ink-faint">
            {rank.xp} XP · rank {rank.position} of {rank.total}
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
              ? `Progress to ${rank.next.name}`
              : "Every rank earned"
          }
        >
          <div
            className="h-full bg-[var(--accent)]"
            style={{ width: `${Math.round(rank.fraction * 100)}%` }}
          />
        </div>

        {rank.next ? (
          <p className="mt-2.5 text-[13px] leading-relaxed text-ink-muted">
            {/* Said in conversations, not points. Nobody has a feel for 450 XP,
                and reps are the only currency the app wants spent. */}
            <span className="text-ink">
              {repsToNextRank(rank.toNext, XP_AWARD.mission)} more{" "}
              {repsToNextRank(rank.toNext, XP_AWARD.mission) === 1
                ? "conversation"
                : "conversations"}
            </span>{" "}
            to {rank.next.name} — {rank.next.note}.
          </p>
        ) : (
          <p className="mt-2.5 text-[13px] leading-relaxed text-ink-muted">
            Every rank earned — {rank.rank.note}.
          </p>
        )}
      </section>

      <div className="mt-7">
        <FactBanner fact={fact} />
      </div>

      <section className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6">
        <h2 className="text-sm font-semibold text-ink">
          {totals.repsLogged === 0 ? "Start a track" : "Had a conversation today?"}
        </h2>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          {totals.repsLogged === 0
            ? "Pick a skill, read the card, then go and have the conversation."
            : "Log it while it is fresh. Thirty seconds is plenty, and a bad rep counts the same as a good one."}
        </p>

        <div className="mt-4 flex flex-wrap gap-2">
          <Link
            href="/log"
            className="rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
          >
            Log a rep
          </Link>
          <Link
            href={totals.repsLogged === 0 ? "/topics" : "/field-log"}
            className="rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper)]"
          >
            {totals.repsLogged === 0 ? "Browse topics" : "See your reps"}
          </Link>
        </div>

        {/* No global level. Levels are per-skill, further down, where they say
            something specific rather than averaging nine skills into one
            number. */}
        <dl className="mt-6 grid grid-cols-2 gap-4 border-t border-rule pt-5">
          <Stat label="Reps logged" value={totals.repsLogged} />
          <Stat
            label="Current streak"
            value={totals.currentStreak}
            note={
              totals.longestStreak > totals.currentStreak
                ? `best ${totals.longestStreak}`
                : undefined
            }
          />
        </dl>

        <details className="mt-5 border-t border-rule pt-4">
          <summary className="cursor-pointer text-xs text-ink-faint underline-offset-4 hover:underline">
            How progress works
          </summary>

          <dl className="mt-3 flex flex-col gap-2.5">
            {XP_TABLE.map((row) => (
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
            One real conversation is worth {REPS_TO_THEORY_RATIO} theory cards.
            That ratio is deliberate: you cannot get good at this from the sofa,
            so the app will not let you level up from there either.
          </p>
        </details>
      </section>

      {resume ? (
        <section className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-5">
          <h2 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
            Pick up where you left off
          </h2>
          {/* Topic, then skill, then lesson. With one topic the skill name was
              enough to place you; with seven, "Openers" could be three
              different tracks. */}
          <p className="mt-3 text-xs text-ink-faint">
            {resume.topicName} · {resume.skillName}
          </p>
          <p className="mt-1 text-base font-medium text-ink">
            Lesson {resume.lessonSortOrder} · {resume.lessonTitle}
          </p>
          <div className="mt-4 flex flex-wrap gap-2">
            <Link
              href={`/skills/${resume.skillSlug}/${resume.lessonSortOrder}`}
              className="rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
            >
              Back to this lesson
            </Link>
            {resume.nextSortOrder ? (
              <Link
                href={`/skills/${resume.skillSlug}/${resume.nextSortOrder}`}
                className="rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper)]"
              >
                Next lesson
              </Link>
            ) : null}
          </div>
        </section>
      ) : null}

      {hasReview ? (
        <section className="mt-8 rounded border border-[var(--flag)] bg-[var(--flag-soft)] p-5">
          <h2 className="tabular text-xs uppercase tracking-[0.18em] text-[var(--flag)]">
            This week
          </h2>
          <p className="mt-2 text-sm leading-relaxed text-ink">
            {review.reps} {review.reps === 1 ? "rep" : "reps"} across{" "}
            {review.skillsTouched.length}{" "}
            {review.skillsTouched.length === 1 ? "skill" : "skills"}.
          </p>
          <Link
            href="/review"
            className="mt-3 inline-block text-sm font-medium text-ink underline underline-offset-4"
          >
            Open the weekly review
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
            Where you are
          </h2>
          <div className="mt-4 flex flex-col gap-7">
            {started.map((topic) => (
              <section key={topic.slug}>
                <div className="flex items-baseline justify-between gap-3 border-b border-rule pb-1.5">
                  <Link
                    href={`/topics/${topic.slug}`}
                    className="text-sm font-medium text-ink underline-offset-4 hover:underline"
                  >
                    {topic.name}
                  </Link>
                  <span className="tabular text-xs text-ink-faint">
                    {topic.reps} {topic.reps === 1 ? "rep" : "reps"} ·{" "}
                    {topic.skills.length}{" "}
                    {topic.skills.length === 1 ? "skill" : "skills"}
                  </span>
                </div>

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
                          Level {skill.progress.level}
                          {skill.progress.isMax
                            ? ""
                            : ` · ${describeNextLevel(skill.progress)}`}
                        </span>
                      </div>
                      <Bar
                        fraction={skill.progress.fraction}
                        label={`${skill.name} progress to the next level`}
                      />
                    </li>
                  ))}
                </ol>
              </section>
            ))}
          </div>
        </section>
      ) : null}

      {badges.earned.length > 0 || totals.repsLogged > 0 ? (
        <section className="mt-9">
          <h2 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
            Badges
          </h2>

          {badges.earned.length === 0 ? (
            <p className="mt-3 text-sm leading-relaxed text-ink-muted">
              None yet. The first one arrives with your first logged rep.
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
                {badges.locked.length} still to earn
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
        <p>Signed in as {user.email ?? "your account"}.</p>
        <p>Designed by DR-P</p>
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
