"use client";

import { useActionState } from "react";
import { useFormStatus } from "react-dom";
import { useTranslations } from "next-intl";

import { changePassword, type SettingsState } from "./actions";

export function PasswordForm() {
  const t = useTranslations("settings.password");
  const [state, formAction] = useActionState<SettingsState, FormData>(
    changePassword,
    {},
  );

  return (
    // Remounted on success so the three boxes empty themselves. Leaving a
    // password sitting in a form after it has been changed is untidy at best.
    <form key={state.done ?? "editing"} action={formAction}>
      <div className="flex flex-col gap-4">
        <Field
          name="current_password"
          label={t("currentPassword")}
          autoComplete="current-password"
        />
        <Field
          name="new_password"
          label={t("newPassword")}
          autoComplete="new-password"
          hint={t("newPasswordHint")}
        />
        <Field
          name="confirm_password"
          label={t("newPasswordAgain")}
          autoComplete="new-password"
        />
      </div>

      {state.error ? (
        <p
          role="alert"
          className="mt-4 rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm text-ink"
        >
          {state.error}
        </p>
      ) : null}
      {state.done ? (
        <p role="status" className="mt-4 text-sm text-ink-muted">
          {state.done}
        </p>
      ) : null}

      <Save />
    </form>
  );
}

function Field({
  name,
  label,
  autoComplete,
  hint,
}: {
  name: string;
  label: string;
  autoComplete: string;
  hint?: string;
}) {
  return (
    <div>
      <label htmlFor={name} className="block text-sm text-ink">
        {label}
      </label>
      <input
        id={name}
        name={name}
        type="password"
        required
        autoComplete={autoComplete}
        className="mt-1.5 w-full rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2.5 text-[15px] text-ink focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
      />
      {hint ? <p className="mt-1 text-xs text-ink-faint">{hint}</p> : null}
    </div>
  );
}

function Save() {
  const t = useTranslations("settings.password");
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={pending}
      className="mt-4 rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90 disabled:opacity-60"
    >
      {pending ? t("changing") : t("changePassword")}
    </button>
  );
}
