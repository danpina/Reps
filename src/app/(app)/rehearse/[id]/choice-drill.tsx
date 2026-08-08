"use client";

import { useActionState } from "react";
import { useFormStatus } from "react-dom";

import type { ChoiceBeat } from "@/lib/roleplay/modes";
import { answerChoice, type DrillState } from "./drill-actions";
import { FinishForm } from "./line-drill";

export type AnsweredBeat = {
  beat: ChoiceBeat;
  /** What they picked, matched back to the authored option. */
  chosen: string;
  correct: boolean;
};

/**
 * Read the situation, decide, find out.
 *
 * These are the six lessons where the right answer is frequently to do
 * nothing, and where a free text box could never tell a good read from a
 * learner who never made one — you cannot type your way into having noticed
 * that somebody had their headphones in.
 *
 * Every wrong option is a mistake people actually make, and its note says why
 * rather than that it was wrong, because the reason is the lesson.
 */
export function ChoiceDrill({
  roleplayId,
  answered,
  current,
  total,
}: {
  roleplayId: string;
  answered: AnsweredBeat[];
  /** The situation still to be read, or null when they are all done. */
  current: ChoiceBeat | null;
  total: number;
}) {
  const [state, formAction] = useActionState<DrillState, FormData>(
    answerChoice,
    {},
  );

  return (
    <div className="mt-7 flex flex-col gap-8">
      {answered.map((item, i) => (
        <section key={i} className="border-l-2 border-rule-strong pl-4">
          <p className="tabular text-[11px] uppercase tracking-[0.14em] text-ink-faint">
            Situation {i + 1} of {total}
          </p>
          <p className="mt-1.5 text-[13px] leading-relaxed text-ink-muted">
            {item.beat.situation}
          </p>

          <ul className="mt-3 flex flex-col gap-2.5">
            {item.beat.options.map((option) => {
              const picked = option.text === item.chosen;
              const worth = picked || option.correct;

              // Only the chosen option and the right one are explained. Marking
              // up all four turns a decision into an answer key, and the two
              // that matter are the one you took and the one you should have.
              return (
                <li
                  key={option.text}
                  className={[
                    "rounded border px-3.5 py-2.5",
                    option.correct
                      ? "border-[var(--accent)] bg-[var(--accent-soft)]"
                      : picked
                        ? "border-[var(--flag)] bg-[var(--flag-soft)]"
                        : "border-rule opacity-60",
                  ].join(" ")}
                >
                  <p className="text-[14px] leading-snug text-ink">
                    {option.text}
                    {picked ? (
                      <span className="text-ink-faint"> — what you chose</span>
                    ) : null}
                  </p>
                  {worth ? (
                    <p className="mt-1.5 text-[13px] leading-relaxed text-ink-muted">
                      {option.note}
                    </p>
                  ) : null}
                </li>
              );
            })}
          </ul>
        </section>
      ))}

      {current ? (
        <section>
          <p className="tabular text-[11px] uppercase tracking-[0.14em] text-ink-faint">
            Situation {answered.length + 1} of {total}
          </p>
          <p className="mt-2 text-[15px] leading-[1.6] text-ink">
            {current.situation}
          </p>
          <p className="mt-3 text-sm font-medium text-ink">{current.prompt}</p>

          <form action={formAction} className="mt-3 flex flex-col gap-2">
            <input type="hidden" name="roleplay_id" value={roleplayId} />
            {current.options.map((option, i) => (
              <Option key={option.text} index={i} text={option.text} />
            ))}
          </form>

          {state.error ? (
            <p
              role="alert"
              className="mt-3 rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm text-ink"
            >
              {state.error}
            </p>
          ) : null}
        </section>
      ) : (
        <p
          role="status"
          className="rounded border border-rule bg-[var(--paper-raised)] px-4 py-3 text-sm leading-relaxed text-ink"
        >
          {answered.every((a) => a.correct)
            ? "Both read correctly. The counting is the skill — keep doing it out loud in your head until it stops being deliberate."
            : "Read the notes above rather than the score. The wrong option you took is a mistake almost everybody makes, which is why it is on the list."}
        </p>
      )}

      <FinishForm roleplayId={roleplayId} enabled={answered.length > 0} />
    </div>
  );
}

/**
 * Each option is its own submit button rather than a radio and a Send.
 *
 * A decision is one action, and asking somebody to choose and then confirm
 * invites them to shop between the options against the shape of the form
 * instead of reading the situation.
 */
function Option({ index, text }: { index: number; text: string }) {
  const { pending } = useFormStatus();

  return (
    <button
      type="submit"
      name="option"
      value={index}
      disabled={pending}
      className="rounded border border-[var(--rule-strong)] px-4 py-3 text-left text-[14px] leading-snug text-ink transition-colors hover:bg-[var(--paper-raised)] disabled:opacity-60"
    >
      {text}
    </button>
  );
}
