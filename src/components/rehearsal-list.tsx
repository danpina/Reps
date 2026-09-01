import Link from "next/link";
import { getTranslations } from "next-intl/server";

import { getLocale } from "@/lib/auth/dal";
import type { Translate } from "@/lib/i18n";
import type { LessonRehearsals, Rehearsal } from "@/lib/roleplay/queries";

/**
 * How a rehearsed scene is written down, wherever it appears.
 *
 * One component rather than three, because the same scene now shows up in
 * three places — the rehearsals section, the track it belongs to, and the
 * lesson it was rehearsed on — and a row that meant something slightly
 * different on each screen would be worse than no row at all.
 */

export async function RehearsalRow({ rehearsal }: { rehearsal: Rehearsal }) {
  const t = await getTranslations("rehearsalList");
  const locale = await getLocale();

  return (
    <li className="border-b border-rule last:border-b-0">
      <Link
        href={`/rehearse/${rehearsal.id}`}
        className="block py-3 transition-colors hover:bg-[var(--paper)]"
      >
        <div className="flex flex-wrap items-baseline gap-x-3 gap-y-1">
          <Verdict rehearsal={rehearsal} t={t} />

          <span className="tabular text-xs text-ink-faint">
            {countLabel(rehearsal, t)}
          </span>

          <span className="tabular ml-auto text-xs text-ink-faint">
            {new Date(rehearsal.startedAt).toLocaleDateString(locale, {
              day: "numeric",
              month: "short",
              year: "numeric",
            })}
          </span>
        </div>

        {rehearsal.fix ? (
          <p className="mt-1.5 text-[13px] leading-relaxed text-ink-muted">
            {rehearsal.fix}
          </p>
        ) : null}
      </Link>
    </li>
  );
}

/**
 * How a finished rehearsal reports itself, which depends on what kind it was.
 *
 * A drill either met its requirements or it did not — there is no average to
 * take, and inventing one out of four boolean checks would be a number that
 * looked like the AI scores without meaning anything like them.
 */
function Verdict({ rehearsal, t }: { rehearsal: Rehearsal; t: Translate }) {
  if (rehearsal.status === "open") {
    return (
      <span className="tabular rounded border border-[var(--flag)] px-1.5 py-0.5 text-[11px] text-[var(--flag)]">
        {t("unfinished")}
      </span>
    );
  }

  if (rehearsal.landed !== null) {
    return rehearsal.landed ? (
      <span className="tabular rounded border border-[var(--accent)] px-1.5 py-0.5 text-[11px] text-[var(--accent)]">
        {t("landed")}
      </span>
    ) : (
      <span className="tabular rounded border border-[var(--rule-strong)] px-1.5 py-0.5 text-[11px] text-ink-muted">
        {t("notQuite")}
      </span>
    );
  }

  if (rehearsal.average !== null) {
    return (
      <span className="tabular rounded border border-[var(--accent)] px-1.5 py-0.5 text-[11px] text-[var(--accent)]">
        {t("avg", { score: rehearsal.average.toFixed(1) })}
      </span>
    );
  }

  return (
    <span className="tabular rounded border border-[var(--rule-strong)] px-1.5 py-0.5 text-[11px] text-ink-muted">
      {t("unscored")}
    </span>
  );
}

/** Lines said in a conversation; attempts or situations read in a drill. */
function countLabel(rehearsal: Rehearsal, t: Translate): string {
  const n = rehearsal.lines;

  if (rehearsal.mode === "line") {
    return t("attempts", { count: n });
  }
  if (rehearsal.mode === "choice") {
    return t("read", { count: n });
  }
  return t("linesSaid", { count: n });
}

/**
 * Scenes under the lessons they were rehearsed on.
 *
 * `skillSlug` turns each lesson heading back into a link to the lesson. It is
 * optional because the lesson page itself already knows which lesson you are
 * on, and repeating the title there would be furniture.
 */
export function RehearsalLessons({
  lessons,
  skillSlug,
}: {
  lessons: LessonRehearsals[];
  skillSlug?: string;
}) {
  return (
    <div className="flex flex-col gap-5">
      {lessons.map((lesson) => (
        <section key={lesson.lessonId}>
          {/* Sentence case, not the uppercase eyebrow used for topics. A
              lesson title is a whole sentence, and a whole sentence in capitals
              is shouting rather than labelling. */}
          <h4 className="text-[13px] text-ink-muted">
            <span className="tabular mr-2 text-[11px] text-ink-faint">
              {String(lesson.sortOrder).padStart(2, "0")}
            </span>
            {skillSlug ? (
              <Link
                href={`/skills/${skillSlug}/${lesson.sortOrder}`}
                className="underline-offset-4 hover:text-ink hover:underline"
              >
                {lesson.title}
              </Link>
            ) : (
              lesson.title
            )}
          </h4>

          <ol className="mt-1">
            {lesson.rehearsals.map((rehearsal) => (
              <RehearsalRow key={rehearsal.id} rehearsal={rehearsal} />
            ))}
          </ol>
        </section>
      ))}
    </div>
  );
}

/**
 * "3 rehearsals", said the same way everywhere it is said.
 *
 * `t` must come from `getTranslations("rehearsalList")` /
 * `useTranslations("rehearsalList")`.
 */
export function rehearsalCount(t: Translate, n: number): string {
  return t("rehearsalsCount", { count: n });
}
