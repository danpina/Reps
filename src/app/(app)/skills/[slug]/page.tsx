import Link from "next/link";
import { notFound } from "next/navigation";
import { getTranslations } from "next-intl/server";

import { BackLink } from "@/components/back-link";
import { DoneMark, stateLabel, type LessonState } from "@/components/done-mark";
import { Prose } from "@/components/prose";
import { RehearsalLessons, rehearsalCount } from "@/components/rehearsal-list";
import { requireUser } from "@/lib/auth/dal";
import { isPro } from "@/lib/billing/entitlement";
import { getCurriculumProgress } from "@/lib/curriculum/progress";
import { isLessonUnlocked } from "@/lib/curriculum/progression";
import { getSkillBySlug, getTopicForSkill } from "@/lib/curriculum/queries";
import { getSkillTakeaway } from "@/lib/curriculum/recap";
import { getRehearsalsForSkill } from "@/lib/roleplay/queries";

export default async function SkillPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  await requireUser();
  const { slug } = await params;
  const [skill, topic, progress, pro, rehearsed, takeaway] = await Promise.all([
    getSkillBySlug(slug),
    getTopicForSkill(slug),
    getCurriculumProgress(),
    isPro(),
    getRehearsalsForSkill(slug),
    getSkillTakeaway(slug),
  ]);
  const t = await getTranslations("skillPage");
  const tRehearsal = await getTranslations("rehearsalList");
  const tLessonState = await getTranslations("lessonState");

  if (!skill) notFound();

  // Every lesson read. Not every lesson *used* — a rep against each one would
  // be a far higher bar and would keep the summary from the person most likely
  // to want it before going out.
  const finished =
    skill.lessons.length > 0 &&
    skill.lessons.every((lesson) => progress.readLessonIds.has(lesson.id));

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink
          href={topic ? `/topics/${topic.slug}` : "/topics"}
          label={topic?.name ?? t("allTopics")}
        />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          {skill.name}
        </h1>
        <p className="mt-3 border-l-2 border-[var(--accent)] pl-4 text-sm leading-relaxed text-ink">
          {skill.core_idea}
        </p>
        {/* Once the track is finished the recap is the reason to come back to
            this page, so it stops being a quiet line at the top and becomes
            the card below. Until then it is a pointer to a page that would
            mostly say "still to read". */}
        {skill.lessons.length > 0 && pro && !finished ? (
          <Link
            href={`/skills/${skill.slug}/recap`}
            className="mt-4 inline-block text-xs text-ink-faint underline-offset-4 hover:text-ink hover:underline"
          >
            {t("whatThisTrackCovers")}
          </Link>
        ) : null}
      </header>

      {/* The cheat sheet, in reach.
          It lived only behind a link on a separate page, which is the wrong
          place for the one thing somebody wants to reread on the way to a
          party. Above the lesson list rather than below it, because once the
          track is read the list is a reference and this is the point of it.

          Gated on having read the track and not on a subscription: a lapse
          should not confiscate the summary of something already learned. In
          practice finishing a five-lesson track requires a subscription
          anyway, since a free account can only open two. */}
      {finished && takeaway ? (
        <section
          aria-labelledby="takeaway"
          className="mt-8 rounded border border-[var(--accent)] bg-[var(--accent-soft)] p-5"
        >
          <div className="flex flex-wrap items-baseline justify-between gap-3">
            <h2
              id="takeaway"
              className="tabular text-xs uppercase tracking-[0.18em] text-[var(--accent)]"
            >
              {t("whatToTakeWithYou")}
            </h2>
            <Link
              href={`/skills/${skill.slug}/recap`}
              className="text-xs text-ink-muted underline-offset-4 hover:text-ink hover:underline"
            >
              {t("everyMoveInOnePage")} →
            </Link>
          </div>
          <div className="mt-3">
            <Prose markdown={takeaway} />
          </div>
        </section>
      ) : null}

      {skill.lessons.length === 0 ? (
        <p className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6 text-sm leading-relaxed text-ink-muted">
          {t("trackNotWrittenYet")}
        </p>
      ) : (
        <ol className="mt-2">
          {skill.lessons.map((lesson, index) => {
            // Two different locks, and the order matters. Being told to
            // finish the previous lesson is actionable; being told to
            // subscribe when you could not have opened it anyway is not.
            const inOrder = isLessonUnlocked(
              skill.lessons,
              index,
              progress.readLessonIds,
            );
            const locked = !inOrder || (!pro && !lesson.is_preview);
            const state: LessonState = progress.usedLessonIds.has(lesson.id)
              ? "used"
              : progress.readLessonIds.has(lesson.id)
                ? "read"
                : "unread";

            const row = (
              <>
                <DoneMark state={state} />
                <span className="tabular mt-px text-xs text-ink-faint">
                  {String(lesson.sort_order).padStart(2, "0")}
                </span>
                <span
                  className={[
                    "text-base",
                    locked || state === "unread" ? "text-ink-muted" : "text-ink",
                  ].join(" ")}
                >
                  {lesson.title}
                </span>
                <span
                  className={[
                    "tabular ml-auto shrink-0 pl-3 text-[11px]",
                    state === "used" ? "text-[var(--accent)]" : "text-ink-faint",
                  ].join(" ")}
                >
                  {!inOrder
                    ? t("nextUp")
                    : locked
                      ? t("locked")
                      : stateLabel(tLessonState, state)}
                </span>
              </>
            );

            return (
              <li key={lesson.id} className="border-b border-rule">
                {/* A locked row is not a link. It used to be one, and clicking
                    it produced a screen explaining why you should not have
                    clicked it — which is a slower way of saying no and reads
                    as the app changing its mind. */}
                {locked ? (
                  <div className="flex cursor-default items-start gap-3 py-5 opacity-60">
                    {row}
                  </div>
                ) : (
                  <Link
                    href={`/skills/${skill.slug}/${lesson.sort_order}`}
                    className="flex items-start gap-3 py-5 transition-colors hover:bg-[var(--paper-raised)]"
                  >
                    {row}
                  </Link>
                )}
              </li>
            );
          })}
        </ol>
      )}

      {/* Folded, and only present once there is something inside it. What you
          rehearsed on this track is worth being able to find from the track,
          but it is a record of practice rather than part of the road, so it
          does not get to sit open above the lessons. */}
      {rehearsed.total > 0 ? (
        <details className="mt-8 rounded border border-rule bg-[var(--paper-raised)] px-5 py-4">
          <summary className="cursor-pointer text-sm text-ink-muted underline-offset-4 hover:text-ink hover:underline">
            {t("countOnThisTrack", { count: rehearsalCount(tRehearsal, rehearsed.total) })}
          </summary>
          <div className="mt-4">
            <RehearsalLessons lessons={rehearsed.lessons} skillSlug={slug} />
          </div>
        </details>
      ) : null}

      {/* The one route out, once the rows themselves have stopped offering
          one. Without this a free account can see the locks and has nowhere
          to go from them. */}
      {!pro && skill.lessons.some((l) => !l.is_preview) ? (
        <p className="mt-6 text-[13px] leading-relaxed text-ink-muted">
          {t("restOfTrackIsSubscription")}{" "}
          <Link href="/pro" className="text-ink underline underline-offset-4">
            {t("seeWhatItUnlocks")}
          </Link>
          .
        </p>
      ) : null}
    </main>
  );
}
