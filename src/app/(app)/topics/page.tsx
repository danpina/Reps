import Link from "next/link";
import { getTranslations } from "next-intl/server";

import { requireUser } from "@/lib/auth/dal";
import { FREE_PREVIEW_LESSONS, isPro } from "@/lib/billing/entitlement";
import { getCurriculumProgress } from "@/lib/curriculum/progress";
import { getTopics } from "@/lib/curriculum/queries";

export async function generateMetadata() {
  const t = await getTranslations("topicsPage");
  return { title: t("pageTitle") };
}

export default async function TopicsPage() {
  await requireUser();
  const [topics, progress, pro] = await Promise.all([
    getTopics(),
    getCurriculumProgress(),
    isPro(),
  ]);
  const t = await getTranslations("topicsPage");

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <h1 className="text-xl font-semibold tracking-tight text-ink">
          {t("heading")}
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          {t("subheading")}
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
                    {t("freeCount", { count: FREE_PREVIEW_LESSONS })}
                  </span>
                ) : null}
              </div>

              <p className="mt-1.5 pl-8 text-sm leading-relaxed text-ink-muted">
                {topic.description}
              </p>

              {written ? (
                <p className="tabular mt-2.5 pl-8 text-xs text-ink-faint">
                  {t("skillsAndLessons", {
                    skills: topic.skills.length,
                    lessons: lessons.length,
                  })}
                  {read > 0 ? ` · ${t("readCount", { count: read })}` : ""}
                  {reps > 0 ? ` · ${t("repsCount", { count: reps })}` : ""}
                </p>
              ) : (
                <p className="tabular mt-2.5 pl-8 text-xs text-ink-faint">
                  {t("beingWritten")}
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
          {t("everyTopicOpensWith", { count: FREE_PREVIEW_LESSONS })}{" "}
          <Link
            href="/pro"
            className="text-ink underline underline-offset-4"
          >
            {t("whatASubscriptionAdds")}
          </Link>
          .
        </p>
      )}
    </main>
  );
}
