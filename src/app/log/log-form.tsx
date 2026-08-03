"use client";

import { useActionState, useState } from "react";
import { useFormStatus } from "react-dom";

import { WENT_LABELS } from "@/lib/progress/rules";
import { logRep, type LogRepState } from "./actions";

type SkillOption = { id: string; name: string };

const WENT_HINTS: Record<number, string> = {
  1: "Fell flat, or you bailed",
  2: "Some of it worked",
  3: "That went somewhere",
};

export function LogForm({
  skills,
  defaultSkillId,
  lessonId,
  missionText,
}: {
  skills: SkillOption[];
  defaultSkillId?: string;
  lessonId?: string;
  missionText?: string;
}) {
  const [state, formAction] = useActionState<LogRepState, FormData>(logRep, {});
  const [went, setWent] = useState<number | null>(null);

  return (
    <form action={formAction} className="mt-7 flex flex-col gap-7">
      <input
        type="hidden"
        name="local_date"
        value={new Date().toLocaleDateString("en-CA")}
      />
      {lessonId ? <input type="hidden" name="lesson_id" value={lessonId} /> : null}
      {missionText ? (
        <input type="hidden" name="mission_text" value={missionText} />
      ) : null}

      {missionText ? (
        <div className="rounded border border-[var(--accent)] bg-[var(--accent-soft)] p-4">
          <p className="tabular text-xs uppercase tracking-[0.18em] text-[var(--accent)]">
            The mission
          </p>
          <p className="mt-2 text-sm leading-relaxed text-ink">{missionText}</p>
        </div>
      ) : null}

      <div className="flex flex-col gap-2">
        <label
          htmlFor="skill_id"
          className="text-sm font-medium text-ink"
        >
          Which skill
        </label>
        <select
          id="skill_id"
          name="skill_id"
          defaultValue={defaultSkillId ?? ""}
          required
          className="rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2.5 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        >
          <option value="" disabled>
            Pick one
          </option>
          {skills.map((skill) => (
            <option key={skill.id} value={skill.id}>
              {skill.name}
            </option>
          ))}
        </select>
      </div>

      <fieldset className="flex flex-col gap-2">
        <legend className="text-sm font-medium text-ink">How did it go?</legend>
        <p className="text-[13px] leading-relaxed text-ink-muted">
          You get credit for doing it, not for it going well. A bad rep is worth
          the same as a good one.
        </p>
        <div className="mt-1 grid grid-cols-3 gap-2">
          {[1, 2, 3].map((value) => {
            const selected = went === value;
            return (
              <label
                key={value}
                className={[
                  "cursor-pointer rounded border px-3 py-3 text-center transition-colors",
                  selected
                    ? "border-[var(--accent)] bg-[var(--accent-soft)]"
                    : "border-[var(--rule-strong)] hover:bg-[var(--paper-raised)]",
                ].join(" ")}
              >
                <input
                  type="radio"
                  name="went"
                  value={value}
                  checked={selected}
                  onChange={() => setWent(value)}
                  required
                  className="sr-only"
                />
                <span className="block text-sm font-medium text-ink">
                  {WENT_LABELS[value]}
                </span>
                <span className="mt-1 block text-[12px] leading-snug text-ink-muted">
                  {WENT_HINTS[value]}
                </span>
              </label>
            );
          })}
        </div>
      </fieldset>

      <div className="flex flex-col gap-2">
        <label htmlFor="context_note" className="text-sm font-medium text-ink">
          Who or where{" "}
          <span className="font-normal text-ink-faint">— optional</span>
        </label>
        <input
          id="context_note"
          name="context_note"
          type="text"
          maxLength={140}
          placeholder="Barista, the 8:40 train, someone at the gym"
          className="rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2.5 text-sm text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        />
        <p className="text-[12px] text-ink-faint">
          Your words. No names needed.
        </p>
      </div>

      <div className="flex flex-col gap-2">
        <label htmlFor="reflection" className="text-sm font-medium text-ink">
          One note{" "}
          <span className="font-normal text-ink-faint">— optional</span>
        </label>
        <textarea
          id="reflection"
          name="reflection"
          rows={3}
          maxLength={500}
          placeholder="What you tried, what happened, what you noticed."
          className="resize-none rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2.5 text-sm leading-relaxed text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        />
      </div>

      {state.error ? (
        <p
          role="alert"
          className="rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm text-ink"
        >
          {state.error}
        </p>
      ) : null}

      <Submit />
    </form>
  );
}

function Submit() {
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={pending}
      className="rounded bg-[var(--accent)] px-4 py-3 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90 disabled:opacity-60"
    >
      {pending ? "Logging…" : "Log this rep"}
    </button>
  );
}
