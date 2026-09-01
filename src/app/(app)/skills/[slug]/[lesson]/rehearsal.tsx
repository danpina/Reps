import Link from "next/link";
import { getTranslations } from "next-intl/server";

import { RehearsalRow, rehearsalCount } from "@/components/rehearsal-list";
import { rehearsalsLeft } from "@/lib/billing/entitlement";
import { createClient } from "@/lib/supabase/server";
import {
  isRehearsalUnlocked,
  requiredLevelForLesson,
} from "@/lib/roleplay/limits";
import { costsMoney, isRehearsalMode } from "@/lib/roleplay/modes";
import { getRehearsalsForLesson } from "@/lib/roleplay/queries";
import { startRehearsal } from "@/app/(app)/rehearse/start/actions";
import { XP_AWARD } from "@/lib/progress/rules";

/**
 * The box says what kind of exercise this is before you open it.
 *
 * "Rehearse it first" was accurate when every lesson got the same fourteen-turn
 * conversation. It is misleading in front of a drill that wants one sentence,
 * and the mismatch matters most for the person this is written for: somebody
 * who opens a chat window expecting to have to hold up a conversation, and
 * closes it again.
 *
 * The message keys are the mode names themselves, under the "rehearsalBox"
 * namespace's headings/start/carryOn objects — see the translations there.
 */

/**
 * The rehearsal entry point on a lesson.
 *
 * Locked scenarios say plainly what unlocks them, and the answer is always
 * logged reps rather than more reading. That is the brief's ordering made
 * visible at the moment someone might otherwise settle for rehearsing.
 */
export async function Rehearsal({
  lessonId,
  sortOrder,
  skillId,
  mode: authoredMode,
  partnerName,
  openness,
}: {
  lessonId: string;
  sortOrder: number;
  skillId: string;
  mode: string;
  partnerName: string;
  openness: number;
}) {
  const supabase = await createClient();
  const mode = isRehearsalMode(authoredMode) ? authoredMode : "scene";
  const paid = costsMoney(mode);
  const t = await getTranslations("rehearsalBox");
  const tRehearsal = await getTranslations("rehearsalList");

  const left = paid ? await rehearsalsLeft() : null;
  const [{ data: state }, past] = await Promise.all([
    supabase
      .from("user_skill_state")
      .select("level")
      .eq("skill_id", skillId)
      .maybeSingle(),
    getRehearsalsForLesson(lessonId),
  ]);

  const level = state?.level ?? 1;
  const unlocked = isRehearsalUnlocked(sortOrder, level, mode);
  const required = requiredLevelForLesson(sortOrder);
  const open = past.find((r) => r.status === "open");

  // A free account gets a fixed number of paid scenes rather than a daily
  // allowance, because those are the ones that cost real money every time they
  // run. Carrying on a scene already open is always allowed: it has been paid
  // for and abandoning someone mid-conversation teaches nothing.
  const spent = left !== null && left <= 0 && !open;

  return (
    <section
      aria-labelledby="rehearse"
      className="rounded border border-rule bg-[var(--paper-raised)] p-5"
    >
      <h2
        id="rehearse"
        className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint"
      >
        {t(`headings.${mode}`)}
      </h2>

      {spent ? (
        <>
          <p className="mt-3 text-sm leading-relaxed text-ink-muted">
            {t("usedFreeRehearsal", { partnerName })}
          </p>
          <Link
            href="/pro"
            className="mt-4 inline-flex rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper)]"
          >
            {t("whatSubscriptionUnlocks")}
          </Link>
        </>
      ) : unlocked ? (
        <>
          <p className="mt-3 text-sm leading-relaxed text-ink">
            {mode === "line"
              ? t("modeIntro.line")
              : mode === "choice"
                ? // Deliberately says nothing about which way the answers go.
                  // This used to promise that the right answer was often to do
                  // nothing, which is true of the lessons about reading
                  // availability and false of the ones about going anyway.
                  t("modeIntro.choice")
                : mode === "beat"
                  ? t("modeIntro.beat", { partnerName })
                  : t("modeIntro.scene", {
                      partnerName,
                      hardWork: openness <= 2 ? t("modeIntro.hardWork") : "",
                    })}
          </p>

          {/* Only the paid modes have a number to report. Saying "unlimited"
              next to a drill would draw attention to a limit that is not
              there. */}
          {left !== null ? (
            <p className="tabular mt-2 text-xs text-ink-faint">
              {t("freeRehearsalsLeft", { count: left })}
            </p>
          ) : null}

          <form action={startRehearsal} className="mt-4 flex items-center gap-3">
            <input type="hidden" name="lesson_id" value={lessonId} />
            <button
              type="submit"
              className="rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper)]"
            >
              {open ? t(`carryOn.${mode}`) : t(`start.${mode}`)}
            </button>
            {/* A drill pays once, the first time it is landed. Repetition is
                the point of it, and paying per repetition would turn that into
                a way of farming the number. */}
            <span className="tabular text-xs text-ink-faint">
              {paid ? t("xpAward", { xp: XP_AWARD.roleplay }) : t("xpAwardFirstTime", { xp: XP_AWARD.roleplay })}
            </span>
          </form>
        </>
      ) : (
        <>
          <p className="mt-3 text-sm leading-relaxed text-ink-muted">
            {t("lockedUntilLevel", { required, level })}
          </p>
          <p className="mt-2 text-[13px] leading-relaxed text-ink-muted">
            {t("levelsComeFromReps")}
          </p>
        </>
      )}

      {/* Outside the branches above, because what you already rehearsed here
          stays worth reading whether or not you may start another one — a
          lapsed subscription should not take your own transcripts away. Folded,
          so the scene you came to start is still the first thing in reach. */}
      {past.length > 0 ? (
        <details className="mt-5 border-t border-rule pt-4">
          <summary className="cursor-pointer text-xs text-ink-faint underline-offset-4 hover:text-ink hover:underline">
            {t("countOnThisLesson", { count: rehearsalCount(tRehearsal, past.length) })}
          </summary>
          <ol className="mt-2">
            {past.map((rehearsal) => (
              <RehearsalRow key={rehearsal.id} rehearsal={rehearsal} />
            ))}
          </ol>
        </details>
      ) : null}
    </section>
  );
}
