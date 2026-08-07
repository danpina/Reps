import Link from "next/link";
import { notFound } from "next/navigation";

import { BackLink } from "@/components/back-link";
import { Prose } from "@/components/prose";
import { getProfile, requireUser } from "@/lib/auth/dal";
import { isPro } from "@/lib/billing/entitlement";
import { pickVariant } from "@/lib/curriculum/variants";
import {
  getLesson,
  getSkillBySlug,
  getTopicForSkill,
} from "@/lib/curriculum/queries";
import { shuffle } from "@/lib/curriculum/shuffle";
import { XP_AWARD } from "@/lib/progress/rules";
import { ComprehensionBeat } from "./comprehension-beat";
import { LockedLesson } from "./locked";
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

  // The index first, because it is the only thing that can tell a lesson that
  // does not exist from one this account may not read. `lessons` answers both
  // with nothing, by design.
  const [track, topic, pro] = await Promise.all([
    getSkillBySlug(slug),
    getTopicForSkill(slug),
    isPro(),
  ]);

  const entry = track?.lessons.find((l) => l.sort_order === sortOrder);
  if (!track || !entry) notFound();

  const total = track.lessons.length;

  if (!pro && !entry.is_preview) {
    return (
      <LockedLesson
        skillName={track.name}
        skillSlug={track.slug}
        topicName={topic?.name ?? "this topic"}
        lessonTitle={entry.title}
        sortOrder={sortOrder}
        total={total}
      />
    );
  }

  const result = await getLesson(slug, sortOrder);
  if (!result) notFound();

  const { skill, lesson } = result;
  const hasNext = sortOrder < total;

  // Almost always null: an opener at a bus stop is an opener, and only the
  // lessons where the advice genuinely differs by reader carry variants at
  // all. Where one matches, it adds a passage and may replace the examples.
  const profile = await getProfile();
  const variant = pickVariant(lesson.variants_json, {
    sex: profile?.sex ?? null,
    ageGroup: profile?.age_group ?? null,
    datingInterest: profile?.dating_interest ?? null,
  });

  const examples = variant?.examples_json ?? lesson.examples_json;

  // Shuffled here rather than in the client component, so the browser hydrates
  // with the same order the server rendered. Falls back to the single legacy
  // check for any lesson the two-check migrations have not reached.
  const source =
    lesson.checks_json?.length > 0
      ? lesson.checks_json
      : lesson.check_json
        ? [lesson.check_json]
        : [];

  const checks = source.map((check) => ({
    ...check,
    options: shuffle(check.options),
  }));

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

        {/* Marked as being for this reader specifically, rather than slipped in
            as though the lesson always said it. Someone should be able to tell
            which part of what they read was written for them. */}
        {variant?.note_md ? (
          <section
            aria-labelledby="for-you"
            className="rounded border border-[var(--flag)] bg-[var(--flag-soft)] p-5"
          >
            <h2
              id="for-you"
              className="tabular text-xs uppercase tracking-[0.18em] text-[var(--flag)]"
            >
              {variant.label}
            </h2>
            <div className="mt-3">
              <Prose markdown={variant.note_md} />
            </div>
          </section>
        ) : null}

        <section aria-labelledby="examples">
          <h2
            id="examples"
            className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint"
          >
            In practice
          </h2>
          <ol className="mt-4 flex flex-col gap-5">
            {examples.map((example, i) => (
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

        {checks.map((check, i) => (
          <ComprehensionBeat
            key={i}
            check={check}
            label={checks.length > 1 ? `Check ${i + 1} of ${checks.length}` : "One check"}
          />
        ))}

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
          // The end of a track is exactly where a summary is worth most.
          <Link
            href={`/skills/${skill.slug}/recap`}
            className="font-medium text-ink underline-offset-4 hover:underline"
          >
            What you learned →
          </Link>
        )}
      </nav>
    </main>
  );
}
