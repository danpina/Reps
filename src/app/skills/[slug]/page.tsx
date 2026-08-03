import Link from "next/link";
import { notFound } from "next/navigation";

import { requireUser } from "@/lib/auth/dal";
import { getSkillBySlug } from "@/lib/curriculum/queries";

export default async function SkillPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  await requireUser();
  const { slug } = await params;
  const skill = await getSkillBySlug(slug);

  if (!skill) notFound();

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <Link
          href="/skills"
          className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint underline-offset-4 hover:underline"
        >
          All skills
        </Link>
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          {skill.name}
        </h1>
        <p className="mt-3 border-l-2 border-[var(--accent)] pl-4 text-sm leading-relaxed text-ink">
          {skill.core_idea}
        </p>
      </header>

      {skill.lessons.length === 0 ? (
        <p className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6 text-sm leading-relaxed text-ink-muted">
          This track has not been written yet. Pick another skill for now.
        </p>
      ) : (
        <ol className="mt-2">
          {skill.lessons.map((lesson) => (
            <li key={lesson.id} className="border-b border-rule">
              <Link
                href={`/skills/${skill.slug}/${lesson.sort_order}`}
                className="flex items-baseline gap-3 py-5 transition-colors hover:bg-[var(--paper-raised)]"
              >
                <span className="tabular text-xs text-ink-faint">
                  {String(lesson.sort_order).padStart(2, "0")}
                </span>
                <span className="text-base text-ink">{lesson.title}</span>
              </Link>
            </li>
          ))}
        </ol>
      )}
    </main>
  );
}
