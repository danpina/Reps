import Link from "next/link";

import { requireUser } from "@/lib/auth/dal";
import { getCurriculumProgress } from "@/lib/curriculum/progress";
import { getSkills } from "@/lib/curriculum/queries";

export const metadata = { title: "Skills — Reps" };

export default async function SkillsPage() {
  await requireUser();
  const [skills, progress] = await Promise.all([
    getSkills(),
    getCurriculumProgress(),
  ]);

  const started = skills.filter((s) =>
    s.lessons.some((l) => progress.readLessonIds.has(l.id)),
  ).length;

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <h1 className="text-xl font-semibold tracking-tight text-ink">
          Pick something to work on
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          Nine skills. Each one is a short theory card, a rehearsal, and a real
          conversation to go and have.
        </p>
        {started > 0 ? (
          <p className="tabular mt-3 text-xs text-ink-faint">
            {started} of {skills.length} started
          </p>
        ) : null}
      </header>

      {skills.length === 0 ? (
        <p className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6 text-sm leading-relaxed text-ink-muted">
          No skills are loaded yet. Run the curriculum migrations against your
          Supabase project, then reload this page.
        </p>
      ) : (
        <ol className="mt-2">
          {skills.map((skill) => {
            const total = skill.lessons.length;
            const ready = total > 0;

            const read = skill.lessons.filter((l) =>
              progress.readLessonIds.has(l.id),
            ).length;
            const reps = progress.repsBySkillId.get(skill.id) ?? 0;
            const finished = ready && read === total;

            const inner = (
              <>
                <div className="flex items-baseline gap-3">
                  <span className="tabular text-xs text-ink-faint">
                    {String(skill.sort_order).padStart(2, "0")}
                  </span>
                  <h2 className="text-base font-medium text-ink">{skill.name}</h2>
                  {finished ? (
                    <span className="tabular ml-auto rounded border border-[var(--accent)] px-1.5 py-0.5 text-[11px] text-[var(--accent)]">
                      All read
                    </span>
                  ) : null}
                </div>
                <p className="mt-1.5 pl-8 text-sm leading-relaxed text-ink-muted">
                  {skill.description}
                </p>

                {ready ? (
                  <div className="mt-2.5 pl-8">
                    {/* A bar per lesson rather than a percentage: at five
                        lessons you can see the shape at a glance. */}
                    <div
                      className="flex gap-1"
                      role="img"
                      aria-label={`${read} of ${total} lessons read${reps > 0 ? `, ${reps} reps logged` : ""}`}
                    >
                      {skill.lessons.map((lesson) => (
                        <span
                          key={lesson.id}
                          className={[
                            "h-1 flex-1 rounded-full",
                            progress.readLessonIds.has(lesson.id)
                              ? "bg-[var(--accent)]"
                              : "bg-[var(--rule)]",
                          ].join(" ")}
                        />
                      ))}
                    </div>
                    <p className="tabular mt-2 text-xs text-ink-faint">
                      {read === 0
                        ? `${total} ${total === 1 ? "lesson" : "lessons"}`
                        : `${read} of ${total} read`}
                      {reps > 0
                        ? ` · ${reps} ${reps === 1 ? "rep" : "reps"} logged`
                        : ""}
                    </p>
                  </div>
                ) : (
                  <p className="tabular mt-2 pl-8 text-xs text-ink-faint">
                    Not written yet
                  </p>
                )}
              </>
            );

            return (
              <li key={skill.id} className="border-b border-rule">
                {ready ? (
                  <Link
                    href={`/skills/${skill.slug}`}
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
      )}
    </main>
  );
}
