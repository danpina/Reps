import Link from "next/link";

import { RehearsalRow, rehearsalCount } from "@/components/rehearsal-list";
import { rehearsalsLeft } from "@/lib/billing/entitlement";
import { createClient } from "@/lib/supabase/server";
import {
  isRehearsalUnlocked,
  requiredLevelForLesson,
} from "@/lib/roleplay/limits";
import { getRehearsalsForLesson } from "@/lib/roleplay/queries";
import { startRehearsal } from "@/app/(app)/rehearse/start/actions";
import { XP_AWARD } from "@/lib/progress/rules";

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
  partnerName,
  openness,
}: {
  lessonId: string;
  sortOrder: number;
  skillId: string;
  partnerName: string;
  openness: number;
}) {
  const supabase = await createClient();

  const left = await rehearsalsLeft();
  const [{ data: state }, past] = await Promise.all([
    supabase
      .from("user_skill_state")
      .select("level")
      .eq("skill_id", skillId)
      .maybeSingle(),
    getRehearsalsForLesson(lessonId),
  ]);

  const level = state?.level ?? 1;
  const unlocked = isRehearsalUnlocked(sortOrder, level);
  const required = requiredLevelForLesson(sortOrder);
  const open = past.find((r) => r.status === "open");

  // A free account gets a fixed number of scenes rather than a daily
  // allowance, because this is the one feature that costs real money every
  // time it runs. Carrying on a scene already open is always allowed: it has
  // been paid for and abandoning someone mid-conversation teaches nothing.
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
        Rehearse it first
      </h2>

      {spent ? (
        <>
          <p className="mt-3 text-sm leading-relaxed text-ink-muted">
            You have used your free rehearsal. {partnerName} is waiting on this
            one, and every other scene in the app, with a subscription.
          </p>
          <Link
            href="/pro"
            className="mt-4 inline-flex rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper)]"
          >
            What a subscription unlocks
          </Link>
        </>
      ) : unlocked ? (
        <>
          <p className="mt-3 text-sm leading-relaxed text-ink">
            Practise this on {partnerName} before you try it on anyone real.
            {openness <= 2
              ? " They are hard work on purpose."
              : ""}
          </p>
          {left !== null ? (
            <p className="tabular mt-2 text-xs text-ink-faint">
              {left} free {left === 1 ? "rehearsal" : "rehearsals"} left
            </p>
          ) : null}
          <form action={startRehearsal} className="mt-4 flex items-center gap-3">
            <input type="hidden" name="lesson_id" value={lessonId} />
            <button
              type="submit"
              className="rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper)]"
            >
              {open ? "Carry on the rehearsal" : "Start a rehearsal"}
            </button>
            <span className="tabular text-xs text-ink-faint">
              +{XP_AWARD.roleplay} XP
            </span>
          </form>
        </>
      ) : (
        <>
          <p className="mt-3 text-sm leading-relaxed text-ink-muted">
            Locked until level {required} in this skill. You are level {level}.
          </p>
          <p className="mt-2 text-[13px] leading-relaxed text-ink-muted">
            Levels come from logging real conversations, so the way to open this
            is to go and have some. That is deliberate — rehearsal is the warm
            up, not the work.
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
            {rehearsalCount(past.length)} on this lesson
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
