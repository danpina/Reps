"use client";

import { useActionState, useEffect, useRef } from "react";
import { useFormStatus } from "react-dom";

import type { Turn } from "@/lib/roleplay/partner";
import { say, type SayState } from "./actions";

export function Chat({
  roleplayId,
  partnerName,
  transcript,
}: {
  roleplayId: string;
  partnerName: string;
  transcript: Turn[];
}) {
  const [state, formAction] = useActionState<SayState, FormData>(say, {});
  const formRef = useRef<HTMLFormElement>(null);
  const endRef = useRef<HTMLDivElement>(null);

  // Clear the box once a line has been sent, and keep the latest turn in view.
  useEffect(() => {
    if (!state.error) formRef.current?.reset();
    endRef.current?.scrollIntoView({ block: "end" });
  }, [transcript.length, state.error]);

  return (
    <>
      <ol
        aria-label="Conversation so far"
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
                {turn.role === "user" ? "You" : partnerName}
              </p>
              <p className="mt-1 text-[15px] leading-[1.55] whitespace-pre-wrap">
                {turn.content}
              </p>
            </div>
          </li>
        ))}
        <div ref={endRef} />
      </ol>

      <form ref={formRef} action={formAction} className="mt-6">
        <input type="hidden" name="roleplay_id" value={roleplayId} />
        <label htmlFor="message" className="sr-only">
          What you say next
        </label>
        <textarea
          id="message"
          name="message"
          rows={2}
          maxLength={600}
          required
          placeholder="What do you say?"
          className="w-full resize-none rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2.5 text-[15px] leading-relaxed text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        />

        {state.error ? (
          <p
            role="alert"
            className="mt-3 rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm text-ink"
          >
            {state.error}
          </p>
        ) : null}

        <Send />
      </form>
    </>
  );
}

function Send() {
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={pending}
      className="mt-3 rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90 disabled:opacity-60"
    >
      {pending ? "Saying it…" : "Say it"}
    </button>
  );
}
