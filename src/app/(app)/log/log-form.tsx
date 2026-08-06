"use client";

import { useActionState } from "react";
import { useFormStatus } from "react-dom";

import { XP_AWARD } from "@/lib/progress/rules";
import { logRep, type LogRepState } from "./actions";
import { RepFields, type SkillGroup } from "./rep-fields";

export function LogForm({
  groups,
  defaultSkillId,
  lessonId,
  missionText,
}: {
  groups: SkillGroup[];
  defaultSkillId?: string;
  lessonId?: string;
  missionText?: string;
}) {
  const [state, formAction] = useActionState<LogRepState, FormData>(logRep, {});

  return (
    <form action={formAction} className="mt-7 flex flex-col gap-7">
      <input
        type="hidden"
        name="local_date"
        value={new Date().toLocaleDateString("en-CA")}
      />
      <input
        type="hidden"
        name="timezone"
        value={Intl.DateTimeFormat().resolvedOptions().timeZone ?? ""}
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

      <RepFields groups={groups} values={{ skillId: defaultSkillId }} />

      {state.error ? (
        <p
          role="alert"
          className="rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm text-ink"
        >
          {state.error}
        </p>
      ) : null}

      <div className="flex items-center gap-3">
        <Submit />
        {/* Stated before the action, not just after it, so the ratio between a
            real conversation and everything else is visible where it matters. */}
        <span className="tabular text-xs text-ink-faint">
          +{XP_AWARD.mission} XP, the most anything is worth here
        </span>
      </div>
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
