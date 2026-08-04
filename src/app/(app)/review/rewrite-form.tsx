"use client";

import { useActionState } from "react";
import { useFormStatus } from "react-dom";

import { XP_AWARD } from "@/lib/progress/rules";
import { saveRewrite, type RewriteState } from "./actions";

export function RewriteForm({
  logId,
  existing,
}: {
  logId: string;
  existing?: string | null;
}) {
  const [state, formAction] = useActionState<RewriteState, FormData>(
    saveRewrite,
    {},
  );

  if (state.saved) {
    return (
      <p
        role="status"
        className="mt-4 rounded border border-[var(--accent)] bg-[var(--accent-soft)] px-4 py-3 text-sm leading-relaxed text-ink"
      >
        Saved. That is the useful part of a rep that went badly.
      </p>
    );
  }

  return (
    <form action={formAction} className="mt-4">
      <input type="hidden" name="log_id" value={logId} />
      <label htmlFor="rewrite" className="text-sm font-medium text-ink">
        What would you say instead?
      </label>
      <textarea
        id="rewrite"
        name="rewrite"
        rows={3}
        defaultValue={existing ?? ""}
        maxLength={500}
        required
        placeholder="The actual words, not the lesson. Write the line."
        className="mt-2 w-full resize-none rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2.5 text-sm leading-relaxed text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
      />

      {state.error ? (
        <p
          role="alert"
          className="mt-3 rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm text-ink"
        >
          {state.error}
        </p>
      ) : null}

      <div className="mt-3 flex items-center gap-3">
        <Submit />
        <span className="tabular text-xs text-ink-faint">
          +{XP_AWARD.rewrite} XP
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
      className="rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90 disabled:opacity-60"
    >
      {pending ? "Saving…" : "Save this"}
    </button>
  );
}
