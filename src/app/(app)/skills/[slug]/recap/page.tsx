import Link from "next/link";
import { notFound, redirect } from "next/navigation";

import { BackLink } from "@/components/back-link";
import { Prose } from "@/components/prose";
import { requireUser } from "@/lib/auth/dal";
import { isPro } from "@/lib/billing/entitlement";
import { getRecap } from "@/lib/curriculum/recap";

export const metadata = { title: "Recap — Reps" };

export default async function RecapPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  await requireUser();
  const { slug } = await params;

  // A recap is assembled from the lessons themselves, so on a free account it
  // would quietly become a two-line summary of the sample rather than a
  // summary of the track. Redirecting is more honest than rendering a page
  // that looks complete and is not.
  if (!(await isPro())) redirect("/pro");

  const recap = await getRecap(slug);

  if (!recap) notFound();

  const nextUnread = recap.lessons.find((l) => !l.read);

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink href={`/skills/${recap.slug}`} label={recap.name} />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          {recap.complete ? "What you learned" : "What you have covered"}
        </h1>
        <p className="tabular mt-2 text-xs text-ink-faint">
          {recap.name} · {recap.readCount} of {recap.total} lessons read ·
          level {recap.level} · {recap.reps}{" "}
          {recap.reps === 1 ? "rep" : "reps"} logged
        </p>
      </header>

      <section aria-labelledby="idea" className="mt-7">
        <h2
          id="idea"
          className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint"
        >
          The idea
        </h2>
        <p className="mt-3 border-l-2 border-[var(--accent)] pl-4 text-[15px] leading-[1.6] text-ink">
          {recap.coreIdea}
        </p>
      </section>

      {/* Assembled from each lesson's own stated move, so it cannot drift out
          of step with the content. */}
      <section aria-labelledby="moves" className="mt-9">
        <h2
          id="moves"
          className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint"
        >
          The moves
        </h2>
        <ol className="mt-4 flex flex-col gap-4">
          {recap.lessons.map((lesson) => (
            <li
              key={lesson.sortOrder}
              className={[
                "border-l-2 pl-4",
                lesson.read ? "border-[var(--accent)]" : "border-rule",
              ].join(" ")}
            >
              <div className="flex items-baseline gap-3">
                <span className="tabular text-xs text-ink-faint">
                  {String(lesson.sortOrder).padStart(2, "0")}
                </span>
                <Link
                  href={`/skills/${recap.slug}/${lesson.sortOrder}`}
                  className={[
                    "text-sm underline-offset-4 hover:underline",
                    lesson.read ? "text-ink" : "text-ink-muted",
                  ].join(" ")}
                >
                  {lesson.title}
                </Link>
                {!lesson.read ? (
                  <span className="tabular ml-auto text-[11px] text-ink-faint">
                    not read yet
                  </span>
                ) : null}
              </div>
              <p
                className={[
                  "mt-1.5 pl-8 text-[15px] leading-[1.55]",
                  lesson.read ? "text-ink" : "text-ink-faint",
                ].join(" ")}
              >
                {lesson.move}
              </p>
            </li>
          ))}
        </ol>
      </section>

      {recap.complete ? (
        <section
          aria-labelledby="takeaway"
          className="mt-9 rounded border border-[var(--accent)] bg-[var(--accent-soft)] p-5"
        >
          <h2
            id="takeaway"
            className="tabular text-xs uppercase tracking-[0.18em] text-[var(--accent)]"
          >
            What to take with you
          </h2>
          <div className="mt-3">
            <Prose markdown={recap.takeaway} />
          </div>
        </section>
      ) : (
        <section className="mt-9 rounded border border-rule bg-[var(--paper-raised)] p-5">
          <h2 className="text-sm font-semibold text-ink">
            {recap.total - recap.readCount} still to read
          </h2>
          <p className="mt-2 text-sm leading-relaxed text-ink-muted">
            Finish the track and this becomes the summary worth keeping.
          </p>
          {nextUnread ? (
            <Link
              href={`/skills/${recap.slug}/${nextUnread.sortOrder}`}
              className="mt-4 inline-flex rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
            >
              Read lesson {nextUnread.sortOrder}
            </Link>
          ) : null}
        </section>
      )}

      {/* However good the recap, it is still reading. */}
      <section className="mt-9 border-t border-rule pt-5">
        <p className="text-sm leading-relaxed text-ink-muted">
          None of this counts until you have used it on someone.
        </p>
        <Link
          href={`/log?skill=${recap.id}`}
          className="mt-3 inline-flex rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper-raised)]"
        >
          Log a real rep
        </Link>
      </section>
    </main>
  );
}
