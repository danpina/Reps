import Link from "next/link";

import { requireUser } from "@/lib/auth/dal";
import { FREE_PREVIEW_LESSONS, isPro } from "@/lib/billing/entitlement";
import { getCurriculumProgress } from "@/lib/curriculum/progress";
import { getTopics } from "@/lib/curriculum/queries";

export const metadata = { title: "Topics — Reps" };

export default async function TopicsPage() {
  await requireUser();
  const [topics, progress, pro] = await Promise.all([
    getTopics(),
    getCurriculumProgress(),
    isPro(),
  ]);

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <h1 className="text-xl font-semibold tracking-tight text-ink">
          What are you practising for?
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          A topic is a situation. The skills inside it are written for that
          situation and nowhere else, because an opener at a bar and an opener
          in an interview are not the same craft.
        </p>
      </header>

      <ol className="mt-2">
        {topics.map((topic) => {
          const lessons = topic.skills.flatMap((s) => s.lessons);
          const read = lessons.filter((l) =>
            progress.readLessonIds.has(l.id),
          ).length;
          const reps = topic.skills.reduce(
            (sum, s) => sum + (progress.repsBySkillId.get(s.id) ?? 0),
            0,
          );
          const written = lessons.length > 0;

          const inner = (
            <>
              <div className="flex items-baseline gap-3">
                <span className="tabular text-xs text-ink-faint">
                  {String(topic.sort_order).padStart(2, "0")}
                </span>
                <h2 className="text-base font-medium text-ink">{topic.name}</h2>
                {written && !pro ? (
                  <span className="tabular ml-auto shrink-0 text-[11px] text-ink-faint">
                    {FREE_PREVIEW_LESSONS} free
                  </span>
                ) : null}
              </div>

              <p className="mt-1.5 pl-8 text-sm leading-relaxed text-ink-muted">
                {topic.description}
              </p>

              {written ? (
                <p className="tabular mt-2.5 pl-8 text-xs text-ink-faint">
                  {topic.skills.length}{" "}
                  {topic.skills.length === 1 ? "skill" : "skills"} ·{" "}
                  {lessons.length} lessons
                  {read > 0 ? ` · ${read} read` : ""}
                  {reps > 0 ? ` · ${reps} ${reps === 1 ? "rep" : "reps"}` : ""}
                </p>
              ) : (
                <p className="tabular mt-2.5 pl-8 text-xs text-ink-faint">
                  Being written
                </p>
              )}
            </>
          );

          return (
            <li key={topic.id} className="border-b border-rule">
              {written ? (
                <Link
                  href={`/topics/${topic.slug}`}
                  className="block py-5 transition-colors hover:bg-[var(--paper-raised)]"
                >
                  {inner}
                </Link>
              ) : (
                <div className="py-5 opacity-55">{inner}</div>
              )}
            </li>
          );
        })}
      </ol>

      {pro ? null : (
        <p className="mt-8 text-[13px] leading-relaxed text-ink-muted">
          Every topic opens with {FREE_PREVIEW_LESSONS} free lessons.{" "}
          <Link
            href="/pro"
            className="text-ink underline underline-offset-4"
          >
            What a subscription adds
          </Link>
          .
        </p>
      )}
    </main>
  );
}
