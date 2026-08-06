import Link from "next/link";
import { notFound } from "next/navigation";

import { BackLink } from "@/components/back-link";
import { requireUser } from "@/lib/auth/dal";
import { FREE_PREVIEW_LESSONS, isPro } from "@/lib/billing/entitlement";
import { getCurriculumProgress } from "@/lib/curriculum/progress";
import { getTopicBySlug } from "@/lib/curriculum/queries";

export default async function TopicPage({
  params,
}: {
  params: Promise<{ topic: string }>;
}) {
  await requireUser();
  const { topic: slug } = await params;

  const [topic, progress, pro] = await Promise.all([
    getTopicBySlug(slug),
    getCurriculumProgress(),
    isPro(),
  ]);

  if (!topic) notFound();

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink href="/topics" label="All topics" />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          {topic.name}
        </h1>
        <p className="mt-3 border-l-2 border-[var(--accent)] pl-4 text-sm leading-relaxed text-ink">
          {topic.promise}
        </p>
      </header>

      {topic.skills.length === 0 ? (
        <p className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6 text-sm leading-relaxed text-ink-muted">
          This topic is still being written. Pick another one for now.
        </p>
      ) : (
        <ol className="mt-2">
          {topic.skills.map((skill) => {
            const total = skill.lessons.length;
            const read = skill.lessons.filter((l) =>
              progress.readLessonIds.has(l.id),
            ).length;
            const reps = progress.repsBySkillId.get(skill.id) ?? 0;
            const open = skill.lessons.filter(
              (l) => pro || l.is_preview,
            ).length;

            return (
              <li key={skill.id} className="border-b border-rule">
                <Link
                  href={`/skills/${skill.slug}`}
                  className="block py-5 transition-colors hover:bg-[var(--paper-raised)]"
                >
                  <div className="flex items-baseline gap-3">
                    <span className="tabular text-xs text-ink-faint">
                      {String(skill.sort_order).padStart(2, "0")}
                    </span>
                    <h2 className="text-base font-medium text-ink">
                      {skill.name}
                    </h2>
                    {read === total && total > 0 ? (
                      <span className="tabular ml-auto rounded border border-[var(--accent)] px-1.5 py-0.5 text-[11px] text-[var(--accent)]">
                        All read
                      </span>
                    ) : open === 0 ? (
                      <span className="ml-auto shrink-0 text-ink-faint">
                        <LockIcon />
                      </span>
                    ) : null}
                  </div>

                  <p className="mt-1.5 pl-8 text-sm leading-relaxed text-ink-muted">
                    {skill.description}
                  </p>

                  {total > 0 ? (
                    <div className="mt-2.5 pl-8">
                      {/* A bar per lesson rather than a percentage: at five
                          lessons you can see the shape at a glance. Locked
                          lessons are drawn hollow, so what you have not bought
                          is visible without being shouted about. */}
                      <div
                        className="flex gap-1"
                        role="img"
                        aria-label={`${read} of ${total} lessons read${
                          open < total ? `, ${total - open} locked` : ""
                        }${reps > 0 ? `, ${reps} reps logged` : ""}`}
                      >
                        {skill.lessons.map((lesson) => {
                          const locked = !pro && !lesson.is_preview;
                          return (
                            <span
                              key={lesson.id}
                              className={[
                                "h-1 flex-1 rounded-full",
                                progress.readLessonIds.has(lesson.id)
                                  ? "bg-[var(--accent)]"
                                  : locked
                                    ? "border border-dashed border-[var(--rule-strong)]"
                                    : "bg-[var(--rule)]",
                              ].join(" ")}
                            />
                          );
                        })}
                      </div>
                      <p className="tabular mt-2 text-xs text-ink-faint">
                        {read === 0
                          ? `${total} ${total === 1 ? "lesson" : "lessons"}`
                          : `${read} of ${total} read`}
                        {reps > 0
                          ? ` · ${reps} ${reps === 1 ? "rep" : "reps"} logged`
                          : ""}
                        {!pro && open > 0 && open < total
                          ? ` · ${open} free`
                          : ""}
                      </p>
                    </div>
                  ) : (
                    <p className="tabular mt-2 pl-8 text-xs text-ink-faint">
                      Not written yet
                    </p>
                  )}
                </Link>
              </li>
            );
          })}
        </ol>
      )}

      {pro || topic.skills.length === 0 ? null : (
        <p className="mt-8 text-[13px] leading-relaxed text-ink-muted">
          You can read the first {FREE_PREVIEW_LESSONS} lessons of{" "}
          {topic.skills[0].name.toLowerCase()} without paying for anything.{" "}
          <Link href="/pro" className="text-ink underline underline-offset-4">
            The rest is a subscription
          </Link>
          .
        </p>
      )}
    </main>
  );
}

function LockIcon() {
  return (
    <svg viewBox="0 0 20 20" aria-hidden className="h-3.5 w-3.5">
      <rect
        x="4.5"
        y="8.5"
        width="11"
        height="8"
        rx="1.5"
        fill="none"
        stroke="currentColor"
        strokeWidth="1.5"
      />
      <path
        d="M7 8.5V6.5a3 3 0 0 1 6 0v2"
        fill="none"
        stroke="currentColor"
        strokeWidth="1.5"
        strokeLinecap="round"
      />
    </svg>
  );
}
