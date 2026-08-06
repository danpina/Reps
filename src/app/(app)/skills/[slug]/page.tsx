import Link from "next/link";
import { notFound } from "next/navigation";

import { BackLink } from "@/components/back-link";
import { DoneMark, stateLabel, type LessonState } from "@/components/done-mark";
import { requireUser } from "@/lib/auth/dal";
import { isPro } from "@/lib/billing/entitlement";
import { getCurriculumProgress } from "@/lib/curriculum/progress";
import { getSkillBySlug, getTopicForSkill } from "@/lib/curriculum/queries";

export default async function SkillPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  await requireUser();
  const { slug } = await params;
  const [skill, topic, progress, pro] = await Promise.all([
    getSkillBySlug(slug),
    getTopicForSkill(slug),
    getCurriculumProgress(),
    isPro(),
  ]);

  if (!skill) notFound();

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink
          href={topic ? `/topics/${topic.slug}` : "/topics"}
          label={topic?.name ?? "All topics"}
        />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          {skill.name}
        </h1>
        <p className="mt-3 border-l-2 border-[var(--accent)] pl-4 text-sm leading-relaxed text-ink">
          {skill.core_idea}
        </p>
        {skill.lessons.length > 0 && pro ? (
          <Link
            href={`/skills/${skill.slug}/recap`}
            className="mt-4 inline-block text-xs text-ink-faint underline-offset-4 hover:text-ink hover:underline"
          >
            What this track covers, in one page
          </Link>
        ) : null}
      </header>

      {skill.lessons.length === 0 ? (
        <p className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6 text-sm leading-relaxed text-ink-muted">
          This track has not been written yet. Pick another skill for now.
        </p>
      ) : (
        <ol className="mt-2">
          {skill.lessons.map((lesson) => {
            const locked = !pro && !lesson.is_preview;
            const state: LessonState = progress.usedLessonIds.has(lesson.id)
              ? "used"
              : progress.readLessonIds.has(lesson.id)
                ? "read"
                : "unread";

            return (
              <li key={lesson.id} className="border-b border-rule">
                <Link
                  href={`/skills/${skill.slug}/${lesson.sort_order}`}
                  className="flex items-start gap-3 py-5 transition-colors hover:bg-[var(--paper-raised)]"
                >
                  <DoneMark state={state} />
                  <span className="tabular mt-px text-xs text-ink-faint">
                    {String(lesson.sort_order).padStart(2, "0")}
                  </span>
                  <span
                    className={[
                      "text-base",
                      locked || state === "unread" ? "text-ink-muted" : "text-ink",
                    ].join(" ")}
                  >
                    {lesson.title}
                  </span>
                  <span
                    className={[
                      "tabular ml-auto shrink-0 pl-3 text-[11px]",
                      state === "used" ? "text-[var(--accent)]" : "text-ink-faint",
                    ].join(" ")}
                  >
                    {locked ? "Locked" : stateLabel(state)}
                  </span>
                </Link>
              </li>
            );
          })}
        </ol>
      )}
    </main>
  );
}
