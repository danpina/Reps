"use client";

import { useState } from "react";

import type { ComprehensionCheck } from "@/lib/curriculum/types";

export function ComprehensionBeat({ check }: { check: ComprehensionCheck }) {
  const [picked, setPicked] = useState<number | null>(null);
  const answered = picked !== null;

  return (
    <section
      aria-labelledby="beat-prompt"
      className="rounded border border-rule bg-[var(--paper-raised)] p-5"
    >
      <h2 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
        One check
      </h2>
      <p id="beat-prompt" className="mt-3 text-[15px] leading-[1.6] text-ink">
        {check.prompt}
      </p>

      <ul className="mt-4 flex flex-col gap-2">
        {check.options.map((option, i) => {
          const isPicked = picked === i;
          const reveal = answered && (isPicked || option.correct);

          return (
            <li key={i}>
              <button
                type="button"
                onClick={() => setPicked(i)}
                aria-pressed={isPicked}
                className={[
                  "w-full rounded border px-4 py-3 text-left text-sm transition-colors",
                  reveal && option.correct
                    ? "border-[var(--accent)] bg-[var(--accent-soft)]"
                    : reveal
                      ? "border-[var(--flag)] bg-[var(--flag-soft)]"
                      : "border-[var(--rule-strong)] hover:bg-[var(--paper)]",
                ].join(" ")}
              >
                <span className="flex items-baseline gap-2.5">
                  {answered ? (
                    <>
                      <span aria-hidden className="tabular text-xs text-ink-faint">
                        {option.correct ? "✓" : isPicked ? "×" : " "}
                      </span>
                      {/* The tick and cross are the only visual signal, so the
                          same information is given to screen readers here. */}
                      <span className="sr-only">
                        {option.correct
                          ? isPicked
                            ? "Correct, and this was your answer."
                            : "This was the correct answer."
                          : "Your answer, which was not correct."}
                      </span>
                    </>
                  ) : null}
                  <span className="text-ink">{option.text}</span>
                </span>

                {reveal ? (
                  <span className="mt-2 block pl-6 text-[13px] leading-relaxed text-ink-muted">
                    {option.note}
                  </span>
                ) : null}
              </button>
            </li>
          );
        })}
      </ul>

      {answered ? (
        <p
          role="status"
          className="mt-4 border-t border-rule pt-4 text-sm leading-relaxed text-ink"
        >
          {check.explain}
        </p>
      ) : null}
    </section>
  );
}
