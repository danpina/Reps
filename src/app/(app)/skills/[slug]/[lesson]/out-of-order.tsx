import Link from "next/link";

/**
 * What a lesson looks like when the one before it has not been read.
 *
 * Not a refusal, and it should not read as one — nothing is being withheld
 * that has to be earned. The track is an argument in order, and this is a
 * signpost back to the place the argument is currently at.
 *
 * So the only real content is the way forward, and it is a button rather than
 * an instruction: someone who arrived here by editing a URL or following an
 * old link should be one click from where they meant to be.
 */
export function OutOfOrder({
  skillName,
  skillSlug,
  lessonTitle,
  sortOrder,
  total,
  nextTitle,
  nextSortOrder,
}: {
  skillName: string;
  skillSlug: string;
  lessonTitle: string;
  sortOrder: number;
  total: number;
  nextTitle: string;
  nextSortOrder: number;
}) {
  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <Link
          href={`/skills/${skillSlug}`}
          className="text-xs text-ink-faint underline-offset-4 hover:text-ink hover:underline"
        >
          ← {skillName}
        </Link>
        <p className="tabular mt-3 text-xs text-ink-faint">
          Lesson {sortOrder} of {total}
        </p>
        <h1 className="mt-1.5 text-xl font-semibold tracking-tight text-ink">
          {lessonTitle}
        </h1>
      </header>

      <section className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6">
        <h2 className="text-sm font-semibold text-ink">
          There is one before this
        </h2>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          This track builds, and lesson {sortOrder} assumes the ones under it.
          You are up to lesson {nextSortOrder}.
        </p>

        <Link
          href={`/skills/${skillSlug}/${nextSortOrder}`}
          className="mt-5 inline-flex rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
        >
          Lesson {nextSortOrder} · {nextTitle}
        </Link>
      </section>
    </main>
  );
}
