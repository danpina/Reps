import Link from "next/link";

import { BackLink } from "@/components/back-link";
import { RehearsalLessons, rehearsalCount } from "@/components/rehearsal-list";
import { requireUser } from "@/lib/auth/dal";
import { MAX_SCENES_PER_DAY } from "@/lib/roleplay/limits";
import { getRehearsalTree } from "@/lib/roleplay/queries";

export const metadata = { title: "Rehearsals — Reps" };

export default async function RehearsalsPage({
  searchParams,
}: {
  searchParams: Promise<{ limit?: string }>;
}) {
  await requireUser();
  const atLimit = (await searchParams).limit === "1";
  const topics = await getRehearsalTree();

  const total = topics.reduce((n, topic) => n + topic.total, 0);

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink href="/today" label="Today" />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          Rehearsals
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          Practice scenes and what they were scored on. Useful, and worth less
          than one real conversation.
        </p>
        {total > 0 ? (
          <p className="tabular mt-3 text-xs text-ink-faint">
            {rehearsalCount(total)}, in the order the curriculum runs
          </p>
        ) : null}
      </header>

      {/* Reached by redirect from the start action, so the message has to
          explain a thing that just happened rather than warn about one. */}
      {atLimit ? (
        <p
          role="status"
          className="mt-6 rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm leading-relaxed text-ink"
        >
          That is {MAX_SCENES_PER_DAY} scenes today, which is the daily cap.
          Unfinished ones below are still open. The real reps do not have a
          limit — go and have one.
        </p>
      ) : null}

      {topics.length === 0 ? (
        <div className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6">
          <h2 className="text-sm font-semibold text-ink">Nothing rehearsed yet</h2>
          <p className="mt-2 text-sm leading-relaxed text-ink-muted">
            Open a lesson and start a scene. The first one in each track is
            available straight away.
          </p>
          <Link
            href="/topics"
            className="mt-4 inline-block rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
          >
            Browse skills
          </Link>
        </div>
      ) : (
        <div className="mt-8 flex flex-col gap-10">
          {topics.map((topic) => (
            <section key={topic.slug}>
              <div className="flex items-baseline justify-between gap-3 border-b border-rule pb-1.5">
                <h2 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
                  <Link
                    href={`/topics/${topic.slug}`}
                    className="underline-offset-4 hover:text-ink hover:underline"
                  >
                    {topic.name}
                  </Link>
                </h2>
                <span className="tabular shrink-0 text-xs text-ink-faint">
                  {topic.total}
                </span>
              </div>

              <div className="mt-5 flex flex-col gap-7">
                {topic.skills.map((skill) => (
                  <section key={skill.slug}>
                    <div className="flex items-baseline justify-between gap-3">
                      <h3 className="text-sm font-medium text-ink">
                        <Link
                          href={`/skills/${skill.slug}`}
                          className="underline-offset-4 hover:underline"
                        >
                          {skill.name}
                        </Link>
                      </h3>
                      <span className="tabular shrink-0 text-xs text-ink-faint">
                        {rehearsalCount(skill.total)}
                      </span>
                    </div>

                    <div className="mt-3 border-l-2 border-rule-strong pl-4">
                      <RehearsalLessons
                        lessons={skill.lessons}
                        skillSlug={skill.slug}
                      />
                    </div>
                  </section>
                ))}
              </div>
            </section>
          ))}
        </div>
      )}
    </main>
  );
}
