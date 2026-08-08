"use client";

import { useActionState, useState } from "react";
import { useFormStatus } from "react-dom";

import type { WorkedExample } from "@/lib/curriculum/types";
import type { CheckResult } from "@/lib/roleplay/checks";
import { MAX_LINE_CHARS } from "@/lib/roleplay/limits";
import { MAX_DRILL_ATTEMPTS } from "@/lib/roleplay/modes";
import { attemptLine, finishDrill, type DrillState } from "./drill-actions";

export type Attempt = {
  line: string;
  landed: boolean;
  results: CheckResult[];
};

/**
 * One line, as many times as you like.
 *
 * The requirements are on screen before anything is typed, which is the whole
 * point of the mode. Somebody who does not know how to begin is not helped by
 * a blank box and a partner; they are helped by being told the shape — use one
 * of their words, say it flat, keep it under six — and then left to find the
 * words themselves.
 */
export function LineDrill({
  roleplayId,
  says,
  requirements,
  attempts,
  examples,
  model,
}: {
  roleplayId: string;
  /** The partner's line, when they speak first. */
  says?: string;
  requirements: string[];
  attempts: Attempt[];
  examples: WorkedExample[];
  /** One line that answers this exact beat. */
  model?: { line: string; why: string };
}) {
  const [state, formAction] = useActionState<DrillState, FormData>(
    attemptLine,
    {},
  );

  const last = attempts[attempts.length - 1];
  const landed = last?.landed ?? false;
  const spent = attempts.length >= MAX_DRILL_ATTEMPTS;

  return (
    <div className="mt-7 flex flex-col gap-7">
      {says ? (
        <div>
          <p className="tabular text-[11px] uppercase tracking-[0.14em] text-ink-faint">
            They say
          </p>
          <p className="mt-1.5 border-l-2 border-rule-strong pl-4 text-[17px] leading-[1.5] text-ink">
            {says}
          </p>
        </div>
      ) : null}

      {requirements.length > 0 ? (
        <section
          aria-labelledby="must"
          className="rounded border border-rule bg-[var(--paper-raised)] p-4"
        >
          <h2
            id="must"
            className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint"
          >
            This one must
          </h2>
          <ul className="mt-2.5 flex flex-col gap-1.5">
            {requirements.map((requirement) => (
              <li key={requirement} className="text-[13px] leading-snug text-ink">
                {requirement}
              </li>
            ))}
          </ul>
        </section>
      ) : (
        // Two lessons in the app cannot be marked by a rule — saying something
        // mildly exposing, and describing a thing at the wrong scale. Better to
        // say so than to invent a rule and pretend it measured something.
        <p className="text-[13px] leading-relaxed text-ink-muted">
          Nothing to tick off on this one. Write your line, then read the three
          below and see how yours compares.
        </p>
      )}

      {attempts.length > 0 ? (
        <ol aria-label="Your attempts" className="flex flex-col gap-5">
          {attempts.map((attempt, i) => (
            <li key={i}>
              <div className="flex items-baseline gap-3">
                <span className="tabular text-[11px] uppercase tracking-[0.14em] text-ink-faint">
                  {i === attempts.length - 1 ? "You said" : `Try ${i + 1}`}
                </span>
                {attempt.landed ? (
                  <span className="tabular rounded border border-[var(--accent)] px-1.5 py-0.5 text-[11px] text-[var(--accent)]">
                    Landed
                  </span>
                ) : null}
              </div>
              <p className="mt-1 text-[17px] leading-[1.5] text-ink">
                {attempt.line}
              </p>

              {/* Only the latest attempt is marked up. Keeping every past
                  verdict on screen turns a drill into a report card. */}
              {i === attempts.length - 1 && attempt.results.length > 0 ? (
                <ul className="mt-2.5 flex flex-col gap-1.5">
                  {attempt.results.map((result) => (
                    <li
                      key={result.requirement}
                      className="flex gap-2 text-[13px] leading-snug"
                    >
                      <span
                        aria-hidden
                        className={
                          result.ok
                            ? "text-[var(--accent)]"
                            : "text-[var(--flag)]"
                        }
                      >
                        {result.ok ? "✓" : "✗"}
                      </span>
                      <span className={result.ok ? "text-ink-muted" : "text-ink"}>
                        {result.requirement}
                        {result.why ? (
                          <span className="text-ink-muted"> — {result.why}</span>
                        ) : null}
                        <span className="sr-only">
                          {result.ok ? " — met" : " — not met"}
                        </span>
                      </span>
                    </li>
                  ))}
                </ul>
              ) : null}
            </li>
          ))}
        </ol>
      ) : null}

      {landed || spent ? null : (
        <form action={formAction}>
          <input type="hidden" name="roleplay_id" value={roleplayId} />
          <label htmlFor="line" className="sr-only">
            Your line
          </label>
          <LineBox defaultValue={last?.line ?? ""} />

          {state.error ? (
            <p
              role="alert"
              className="mt-3 rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm text-ink"
            >
              {state.error}
            </p>
          ) : null}

          <Submit again={attempts.length > 0} />
        </form>
      )}

      {landed ? (
        <p
          role="status"
          className="rounded border border-[var(--accent)] bg-[var(--accent-soft)] px-4 py-3 text-sm leading-relaxed text-ink"
        >
          That is the shape. Read the three below, then go and use it on
          somebody real — that is the part that counts.
        </p>
      ) : null}

      {spent && !landed ? (
        <p className="rounded border border-rule bg-[var(--paper-raised)] px-4 py-3 text-sm leading-relaxed text-ink-muted">
          That is enough goes at it for now. Read the three below — seeing it
          done is worth more than a ninth attempt.
        </p>
      ) : null}

      {/* Available from the first moment rather than as a reward. Somebody
          genuinely stuck is not learning anything from a fourth failed
          attempt, and giving up on one attempt is not giving up on the skill.

          Two different things, and the order matters. The model answers this
          beat, to this person, just now. The worked examples show the same
          move in three other situations, which is what makes it a move rather
          than a line to memorise. */}
      {model ? (
        <details
          open={landed || spent}
          className="rounded border border-rule bg-[var(--paper-raised)] px-5 py-4"
        >
          <summary className="cursor-pointer text-sm text-ink-muted underline-offset-4 hover:text-ink hover:underline">
            One that works here
          </summary>
          <p className="mt-3 border-l-2 border-[var(--accent)] pl-4 text-[17px] leading-[1.5] text-ink">
            {model.line}
          </p>
          <p className="mt-2 text-[13px] leading-relaxed text-ink-muted">
            {model.why}
          </p>
        </details>
      ) : null}

      <Examples examples={examples} open={landed || spent} />

      <FinishForm roleplayId={roleplayId} enabled={attempts.length > 0} />
    </div>
  );
}

function Examples({
  examples,
  open,
}: {
  examples: WorkedExample[];
  open: boolean;
}) {
  if (examples.length === 0) return null;

  return (
    <details
      open={open}
      className="rounded border border-rule bg-[var(--paper-raised)] px-5 py-4"
    >
      <summary className="cursor-pointer text-sm text-ink-muted underline-offset-4 hover:text-ink hover:underline">
        Three that work, and why
      </summary>
      <ol className="mt-4 flex flex-col gap-5">
        {examples.map((example, i) => (
          <li key={i}>
            <p className="text-[12px] leading-relaxed text-ink-faint">
              {example.situation}
            </p>
            <p className="mt-1.5 border-l-2 border-[var(--accent)] pl-4 text-[15px] leading-[1.55] text-ink">
              {example.line}
            </p>
            <p className="mt-1.5 text-[13px] leading-relaxed text-ink-muted">
              {example.why}
            </p>
          </li>
        ))}
      </ol>
    </details>
  );
}

function LineBox({ defaultValue }: { defaultValue: string }) {
  const [used, setUsed] = useState(defaultValue.length);
  const left = MAX_LINE_CHARS - used;

  return (
    <>
      <textarea
        id="line"
        name="line"
        rows={2}
        maxLength={MAX_LINE_CHARS}
        required
        defaultValue={defaultValue}
        onChange={(e) => setUsed(e.target.value.length)}
        placeholder="What do you say?"
        className="w-full resize-none rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2.5 text-[15px] leading-relaxed text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
      />
      {left <= 40 ? (
        <p className="tabular mt-2 text-right text-xs text-ink-faint" aria-live="polite">
          {left} {left === 1 ? "character" : "characters"} left
        </p>
      ) : null}
    </>
  );
}

function Submit({ again }: { again: boolean }) {
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={pending}
      className="mt-3 rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90 disabled:opacity-60"
    >
      {pending ? "Checking…" : again ? "Try that again" : "Say it"}
    </button>
  );
}

/**
 * Ending a drill is its own form, and always available once there is something
 * to record. Somebody who has decided their fourth attempt is good enough is
 * allowed to be the judge of that.
 */
export function FinishForm({
  roleplayId,
  enabled,
}: {
  roleplayId: string;
  enabled: boolean;
}) {
  const [state, formAction] = useActionState<DrillState, FormData>(
    finishDrill,
    {},
  );

  if (!enabled) return null;

  return (
    <form action={formAction} className="border-t border-rule pt-5">
      <input type="hidden" name="roleplay_id" value={roleplayId} />
      {state.error ? (
        <p
          role="alert"
          className="mb-3 rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm text-ink"
        >
          {state.error}
        </p>
      ) : null}
      <Finish />
    </form>
  );
}

function Finish() {
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={pending}
      className="rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper-raised)] disabled:opacity-60"
    >
      {pending ? "Finishing…" : "Finish this drill"}
    </button>
  );
}
