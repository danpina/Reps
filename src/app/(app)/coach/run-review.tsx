"use client";

import { useActionState } from "react";
import { useFormStatus } from "react-dom";
import { useTranslations } from "next-intl";

import { runReview, type CoachActionState } from "./actions";

/**
 * The button, and the reason it is not available when it is not.
 *
 * A disabled control with no explanation is a dead end, so the reason is
 * always on the page rather than in a tooltip — and the count is exact, so it
 * reads as a target rather than as a refusal.
 */
export function RunReview({
  disabled,
  label,
  since,
}: {
  disabled: boolean;
  label: string;
  /** The watermark this page was rendered against. */
  since: string;
}) {
  const [state, formAction] = useActionState<CoachActionState, FormData>(
    runReview,
    {},
  );

  return (
    <form action={formAction} className="mt-5">
      <input type="hidden" name="since" value={since} />
      {state.error ? (
        <p
          role="alert"
          className="mb-4 rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm text-ink"
        >
          {state.error}
        </p>
      ) : null}
      <Submit disabled={disabled} label={label} />
    </form>
  );
}

function Submit({ disabled, label }: { disabled: boolean; label: string }) {
  const t = useTranslations("coachPage");
  const { pending } = useFormStatus();

  return (
    <>
      <button
        type="submit"
        disabled={disabled || pending}
        className="rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90 disabled:cursor-not-allowed disabled:opacity-45"
      >
        {pending ? t("readingYourLogPending") : label}
      </button>
      {pending ? (
        <p className="mt-3 text-[13px] leading-relaxed text-ink-muted">
          {t("thisTakesAMoment")}
        </p>
      ) : null}
    </>
  );
}
