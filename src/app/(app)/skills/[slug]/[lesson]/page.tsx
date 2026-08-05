import Link from "next/link";
import { notFound } from "next/navigation";

import { BackLink } from "@/components/back-link";
import { Prose } from "@/components/prose";
import { requireUser } from "@/lib/auth/dal";
import { getLesson, getSkillBySlug } from "@/lib/curriculum/queries";
import { shuffle } from "@/lib/curriculum/shuffle";
import { XP_AWARD } from "@/lib/progress/rules";
import { ComprehensionBeat } from "./comprehension-beat";
import { MarkRead } from "./mark-read";
import { Rehearsal } from "./rehearsal";

export default async function LessonPage({
  params,
}: {
  params: Promise<{ slug: string; lesson: string }>;
}) {
  await requireUser();
  const { slug, lesson: lessonParam } = await params;

  const sortOrder = Number(lessonParam);
  if (!Number.isInteger(sortOrder) || sortOrder < 1) notFound();

  const result = await getLesson(slug, sortOrder);
  if (!result) notFound();

  const { skill, lesson } = result;
  const track = await getSkillBySlug(slug);
  const total = track?.lessons.length ?? 0;
  const hasNext = sortOrder < total;

  // Shuffled here rather than in the client component, so the browser hydrates
  // with the same order the server rendered.
  const check = lesson.check_json
    ? { ...lesson.check_json, options: shuffle(lesson.check_json.options) }
    : null;

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <MarkRead lessonId={lesson.id} />
      <header className="border-b border-rule pb-5">
        <BackLink href={`/skills/${skill.slug}`} label={skill.name} />
        <p className="tabular mt-3 text-xs text-ink-faint">
          Lesson {sortOrder} of {total}
        </p>
        <h1 className="mt-1.5 text-xl font-semibold tracking-tight text-ink">
          {lesson.title}
        </h1>
      </header>

      <article className="mt-7 flex flex-col gap-9">
        <Prose markdown={lesson.theory_md} />

        <section aria-labelledby="examples">
          <h2
            id="examples"
            className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint"
          >
            In practice
          </h2>
          <ol className="mt-4 flex flex-col gap-5">
            {lesson.examples_json.map((example, i) => (
              <li key={i} className="border-l-2 border-rule-strong pl-4">
                <p className="text-[13px] leading-relaxed text-ink-muted">
                  {example.situation}
                </p>
                <p className="mt-2 text-[15px] leading-[1.55] text-ink">
                  &ldquo;{example.line}&rdquo;
                </p>
                <p className="mt-2 text-[13px] leading-relaxed text-ink-muted">
                  {example.why}
                </p>
              </li>
            ))}
          </ol>
        </section>

        {check ? <ComprehensionBeat check={check} /> : null}

        <Rehearsal
          lessonId={lesson.id}
          sortOrder={sortOrder}
          skillId={skill.id}
          partnerName={lesson.scenario_json.partner.name}
          openness={lesson.scenario_json.partner.openness}
        />

        <section
          aria-labelledby="mission"
          className="rounded border border-[var(--accent)] bg-[var(--accent-soft)] p-5"
        >
          <h2
            id="mission"
            className="tabular text-xs uppercase tracking-[0.18em] text-[var(--accent)]"
          >
            Today&rsquo;s field mission
          </h2>
          <p className="mt-3 text-[15px] leading-[1.6] text-ink">
            {lesson.mission_text}
          </p>
          <p className="mt-3 text-[13px] leading-relaxed text-ink-muted">
            Go and do it, then log what happened. It counts either way.
          </p>
          <Link
            href={`/log?lesson=${lesson.id}`}
            className="mt-4 inline-flex rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
          >
            Log this rep
          </Link>
          <span className="tabular ml-3 text-xs text-ink-faint">
            +{XP_AWARD.mission} XP
          </span>
        </section>
      </article>

      <nav className="mt-9 flex items-center justify-between border-t border-rule pt-5 text-sm">
        {sortOrder > 1 ? (
          <Link
            href={`/skills/${skill.slug}/${sortOrder - 1}`}
            className="text-ink-muted underline-offset-4 hover:underline"
          >
            ← Previous
          </Link>
        ) : (
          <span />
        )}
        {hasNext ? (
          <Link
            href={`/skills/${skill.slug}/${sortOrder + 1}`}
            className="font-medium text-ink underline-offset-4 hover:underline"
          >
            Next lesson →
          </Link>
        ) : (
          <span className="text-ink-faint">End of this track</span>
        )}
      </nav>
    </main>
  );
}
