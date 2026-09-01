"use client";

import { useActionState, useEffect, useRef, useState } from "react";
import { useFormStatus } from "react-dom";
import { useTranslations } from "next-intl";

import { MAX_LINE_CHARS } from "@/lib/roleplay/limits";
import type { Turn } from "@/lib/roleplay/partner";
import { say, type SayState } from "./actions";

export function Chat({
  roleplayId,
  partnerName,
  transcript,
  turnsLeft,
  instruction,
}: {
  roleplayId: string;
  partnerName: string;
  transcript: Turn[];
  turnsLeft: number;
  /**
   * What this particular turn is for, in a sequence drill.
   *
   * Named as it arrives rather than listed up front. "Two questions, then
   * something of your own" is three turns, and asking somebody to hold the
   * shape in their head while also thinking of something to say is how the
   * shape gets dropped — which is the exact failure the lesson is about.
   */
  instruction?: string;
}) {
  const t = useTranslations("chat");
  const [state, formAction] = useActionState<SayState, FormData>(say, {});
  const endRef = useRef<HTMLDivElement>(null);
  const full = turnsLeft === 0;

  // Keep the latest turn in view.
  useEffect(() => {
    endRef.current?.scrollIntoView({ block: "end" });
  }, [transcript.length, state.error]);

  return (
    <>
      <ol
        aria-label={t("conversationSoFar")}
        aria-live="polite"
        className="mt-6 flex flex-col gap-4"
      >
        {transcript.map((turn, i) => (
          <li
            key={i}
            className={turn.role === "user" ? "flex justify-end" : "flex"}
          >
            <div
              className={[
                "max-w-[85%] rounded px-4 py-2.5",
                turn.role === "user"
                  ? "bg-[var(--accent-soft)] text-ink"
                  : "border border-rule bg-[var(--paper-raised)] text-ink",
              ].join(" ")}
            >
              <p className="tabular text-[11px] uppercase tracking-[0.14em] text-ink-faint">
                {turn.role === "user" ? t("you") : partnerName}
              </p>
              <p className="mt-1 text-[15px] leading-[1.55] whitespace-pre-wrap">
                {turn.content}
              </p>
            </div>
          </li>
        ))}
        <div ref={endRef} />
      </ol>

      {instruction && !full ? (
        <p className="mt-6 rounded border border-[var(--accent)] bg-[var(--accent-soft)] px-4 py-3 text-sm leading-relaxed text-ink">
          {instruction}
        </p>
      ) : null}

      <form action={formAction} className="mt-6">
        <input type="hidden" name="roleplay_id" value={roleplayId} />
        <label htmlFor="message" className="sr-only">
          {t("whatYouSayNext")}
        </label>

        {/* Keyed on the transcript so a landed line remounts the box, clearing
            the text and its counter together. A rejected line leaves the
            transcript untouched, so what they wrote survives for another go. */}
        <LineBox key={transcript.length} full={full} turnsLeft={turnsLeft} />

        {state.error ? (
          <p
            role="alert"
            className="mt-3 rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm text-ink"
          >
            {state.error}
          </p>
        ) : null}

        {full ? null : <Send />}
      </form>
    </>
  );
}

/**
 * The input and the two things it has to tell you: how much of this line is
 * left, and how much of this scene is.
 */
function LineBox({ full, turnsLeft }: { full: boolean; turnsLeft: number }) {
  const t = useTranslations("chat");
  // A hard maxLength on its own just stops accepting keystrokes, which reads
  // as a broken keyboard rather than as a limit.
  const [used, setUsed] = useState(0);
  const charsLeft = MAX_LINE_CHARS - used;

  return (
    <>
      <textarea
        id="message"
        name="message"
        rows={2}
        maxLength={MAX_LINE_CHARS}
        required
        disabled={full}
        onChange={(e) => setUsed(e.target.value.length)}
        placeholder={full ? t("sceneIsDone") : t("whatDoYouSay")}
        className="w-full resize-none rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2.5 text-[15px] leading-relaxed text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--accent)] disabled:opacity-60"
      />

      {/* Both counters appear only once they are close. Showing either from the
          first keystroke would make this feel like a test with a word limit,
          which is the opposite of the thing being practised. */}
      {full ? (
        <p className="mt-2 text-[13px] leading-relaxed text-ink-muted">
          {t("thatIsAsFarAsThisSceneGoes")}
        </p>
      ) : (
        <div className="tabular mt-2 flex items-baseline justify-between gap-3 text-xs text-ink-faint">
          <span>{turnsLeft <= 4 ? t("linesLeft", { count: turnsLeft }) : ""}</span>
          {charsLeft <= 40 ? (
            <span aria-live="polite">
              {t("charactersLeft", { count: charsLeft })}
            </span>
          ) : null}
        </div>
      )}
    </>
  );
}

function Send() {
  const t = useTranslations("chat");
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={pending}
      className="mt-3 rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90 disabled:opacity-60"
    >
      {pending ? t("sayingItPending") : t("sayIt")}
    </button>
  );
}
