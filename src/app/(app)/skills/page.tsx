import Link from "next/link";

import { requireUser } from "@/lib/auth/dal";
import { getSkills } from "@/lib/curriculum/queries";

export const metadata = { title: "Skills — Reps" };

export default async function SkillsPage() {
  await requireUser();
  const skills = await getSkills();

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
      </header>

      {skills.length === 0 ? (
        <p className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6 text-sm leading-relaxed text-ink-muted">
          No skills are loaded yet. Run the curriculum migrations against your
          Supabase project, then reload this page.
        </p>
      ) : (
        <ol className="mt-2">
          {skills.map((skill) => {
            const count = skill.lessons.length;
            const ready = count > 0;

            const inner = (
              <>
                <div className="flex items-baseline gap-3">
                  <span className="tabular text-xs text-ink-faint">
                    {String(skill.sort_order).padStart(2, "0")}
                  </span>
                  <h2 className="text-base font-medium text-ink">{skill.name}</h2>
                </div>
                <p className="mt-1.5 pl-8 text-sm leading-relaxed text-ink-muted">
                  {skill.description}
                </p>
                <p className="tabular mt-2 pl-8 text-xs text-ink-faint">
                  {ready
                    ? `${count} ${count === 1 ? "lesson" : "lessons"}`
                    : "Not written yet"}
                </p>
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
