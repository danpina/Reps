import Link from "next/link";

import { signOut } from "@/app/(auth)/actions";
import { Button } from "@/components/ui";
import { getProfile, requireUser } from "@/lib/auth/dal";
import { getSkillStandings, getTotals } from "@/lib/progress/queries";

export default async function TodayPage() {
  const user = await requireUser();
  const [profile, totals, standings] = await Promise.all([
    getProfile(),
    getTotals(),
    getSkillStandings(),
  ]);

  const name = profile?.display_name?.trim();
  const started = standings.filter((s) => s.progress.xp > 0);

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="flex items-baseline justify-between border-b border-rule pb-5">
        <div>
          <p className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
            Reps
          </p>
          <h1 className="mt-2 text-xl font-semibold tracking-tight text-ink">
            {name ? `Good to see you, ${name}` : "Good to see you"}
          </h1>
        </div>
        <form action={signOut}>
          <Button variant="quiet" type="submit" className="px-3 py-1.5 text-xs">
            Sign out
          </Button>
        </form>
      </header>

      <section className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6">
        <h2 className="text-sm font-semibold text-ink">
          {totals.repsLogged === 0
            ? "Start a track"
            : "Had a conversation today?"}
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
            href="/skills"
            className="rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper)]"
          >
            Browse skills
          </Link>
          <Link
            href="/field-log"
            className="rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper)]"
          >
            Field log
          </Link>
        </div>

        <dl className="mt-6 grid grid-cols-3 gap-4 border-t border-rule pt-5">
          <Stat label="Reps logged" value={totals.repsLogged} />
          <Stat label="Current streak" value={totals.currentStreak} />
          <Stat label="Level" value={totals.global.level} />
        </dl>
      </section>

      {started.length > 0 ? (
        <section className="mt-8">
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
                <div
                  className="mt-2 h-1 w-full overflow-hidden rounded-full bg-[var(--rule)]"
                  role="progressbar"
                  aria-valuenow={Math.round(skill.progress.fraction * 100)}
                  aria-valuemin={0}
                  aria-valuemax={100}
                  aria-label={`${skill.name} progress to the next level`}
                >
                  <div
                    className="h-full bg-[var(--accent)]"
                    style={{ width: `${skill.progress.fraction * 100}%` }}
                  />
                </div>
              </li>
            ))}
          </ol>
        </section>
      ) : null}

      <p className="mt-8 text-xs text-ink-faint">
        Signed in as {user.email ?? "your account"}.
      </p>
    </main>
  );
}

function Stat({ label, value }: { label: string; value: number }) {
  return (
    <div>
      <dt className="text-xs text-ink-faint">{label}</dt>
      <dd className="tabular mt-1 text-2xl text-ink">{value}</dd>
    </div>
  );
}
