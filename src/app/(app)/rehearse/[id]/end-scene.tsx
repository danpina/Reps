"use client";

import { useActionState } from "react";
import { useFormStatus } from "react-dom";
import { useTranslations } from "next-intl";

import { endScene, type SayState } from "./actions";

export function EndScene({
  roleplayId,
  hasSpoken,
}: {
  roleplayId: string;
  hasSpoken: boolean;
}) {
  const t = useTranslations("endScene");
  const [state, formAction] = useActionState<SayState, FormData>(endScene, {});

  return (
    <form action={formAction} className="mt-8 border-t border-rule pt-5">
      <input type="hidden" name="roleplay_id" value={roleplayId} />
      <p className="text-[13px] leading-relaxed text-ink-muted">
        {t("endWhenNaturalClose")}
      </p>

      {state.error ? (
        <p
          role="alert"
          className="mt-3 rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm text-ink"
        >
          {state.error}
        </p>
      ) : null}

      <Submit disabled={!hasSpoken} />
    </form>
  );
}

function Submit({ disabled }: { disabled: boolean }) {
  const t = useTranslations("endScene");
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={disabled || pending}
      className="mt-3 rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper-raised)] disabled:opacity-50"
    >
      {pending ? t("reviewingPending") : t("endTheSceneAndReviewIt")}
    </button>
  );
}
