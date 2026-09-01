import Link from "next/link";
import { getTranslations } from "next-intl/server";

import { BackLink } from "@/components/back-link";
import { RehearsalLessons, rehearsalCount } from "@/components/rehearsal-list";
import { requireUser } from "@/lib/auth/dal";
import { MAX_SCENES_PER_DAY } from "@/lib/roleplay/limits";
import { getRehearsalTree } from "@/lib/roleplay/queries";

export async function generateMetadata() {
  const t = await getTranslations("rehearse");
  return { title: t("pageTitle") };
}

export default async function RehearsalsPage({
  searchParams,
}: {
  searchParams: Promise<{ limit?: string }>;
}) {
  await requireUser();
  const atLimit = (await searchParams).limit === "1";
  const topics = await getRehearsalTree();
  const t = await getTranslations("rehearse");
  const tNav = await getTranslations("nav");
  const tRehearsal = await getTranslations("rehearsalList");

  const total = topics.reduce((n, topic) => n + topic.total, 0);

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink href="/today" label={tNav("today")} />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          {t("heading")}
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          {t("subheading")}
        </p>
        {total > 0 ? (
          <p className="tabular mt-3 text-xs text-ink-faint">
            {t("countInOrder", { count: rehearsalCount(tRehearsal, total) })}
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
          {t("dailyCapReached", { max: MAX_SCENES_PER_DAY })}
        </p>
      ) : null}

      {topics.length === 0 ? (
        <div className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6">
          <h2 className="text-sm font-semibold text-ink">
            {t("nothingRehearsedYet")}
          </h2>
          <p className="mt-2 text-sm leading-relaxed text-ink-muted">
            {t("nothingRehearsedYetBody")}
          </p>
          <Link
            href="/topics"
            className="mt-4 inline-block rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
          >
            {t("browseSkills")}
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
                        {rehearsalCount(tRehearsal, skill.total)}
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
