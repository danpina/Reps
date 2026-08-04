import Link from "next/link";

import { signOut } from "@/app/(auth)/actions";
import { Heatmap } from "@/components/heatmap";
import { Button } from "@/components/ui";
import { getProfile, requireUser } from "@/lib/auth/dal";
import {
  getBadges,
  getHeatmap,
  getSkillStandings,
  getTotals,
  getWeeklyReview,
} from "@/lib/progress/queries";

export default async function TodayPage() {
  const user = await requireUser();
  const [profile, totals, standings, heatmap, badges, review] = await Promise.all([
    getProfile(),
    getTotals(),
    getSkillStandings(),
    getHeatmap(),
    getBadges(),
    getWeeklyReview(),
  ]);

  const name = profile?.display_name?.trim();
  const started = standings.filter((s) => s.progress.xp > 0);
  const hasReview = review.reps > 0;

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
            href={totals.repsLogged === 0 ? "/skills" : "/field-log"}
            className="rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper)]"
          >
            {totals.repsLogged === 0 ? "Browse skills" : "See the log"}
          </Link>
        </div>

        <dl className="mt-6 grid grid-cols-3 gap-4 border-t border-rule pt-5">
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
          <Stat label="Level" value={totals.global.level} />
        </dl>

        {!totals.global.isMax ? (
          <div className="mt-5">
            <div className="flex items-baseline justify-between">
              <p className="tabular text-xs text-ink-faint">
                Level {totals.global.level}
              </p>
              <p className="tabular text-xs text-ink-faint">
                {totals.global.toNextLevel} XP to {totals.global.level + 1}
              </p>
            </div>
            <Bar fraction={totals.global.fraction} label="Progress to the next level" />
          </div>
        ) : null}
      </section>

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
          <ol className="mt-4 flex flex-col gap-4">
            {started.map((skill) => (
              <li key={skill.skill_id}>
                <div className="flex items-baseline justify-between gap-3">
                  <Link
                    href={`/skills/${skill.slug}`}
                    className="text-sm text-ink underline-offset-4 hover:underline"
                  >
                    {skill.name}
                  </Link>
                  <span className="tabular text-xs text-ink-faint">
                    Level {skill.progress.level}
                    {skill.progress.isMax
                      ? ""
                      : ` · ${skill.progress.toNextLevel} XP to go`}
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

      <p className="mt-10 text-xs text-ink-faint">
        Signed in as {user.email ?? "your account"}.
      </p>
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
