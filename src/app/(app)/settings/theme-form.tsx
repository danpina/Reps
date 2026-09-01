"use client";

import { useActionState } from "react";
import { useFormStatus } from "react-dom";
import { useTranslations } from "next-intl";

import type { Theme } from "@/lib/auth/dal";
import { updateTheme, type SettingsState } from "./actions";

const CHOICES: Theme[] = ["system", "light", "dark"];

export function ThemeForm({ current }: { current: Theme }) {
  const t = useTranslations("settings.appearance");
  const [state, formAction] = useActionState<SettingsState, FormData>(
    updateTheme,
    {},
  );

  return (
    <form action={formAction}>
      <fieldset>
        <legend className="sr-only">{t("legend")}</legend>
        <div className="flex flex-col gap-2">
          {CHOICES.map((choice) => (
            <label
              key={choice}
              className="flex cursor-pointer items-baseline gap-3 rounded border border-rule px-4 py-3 transition-colors hover:bg-[var(--paper-raised)] has-[:checked]:border-[var(--accent)] has-[:checked]:bg-[var(--accent-soft)]"
            >
              <input
                type="radio"
                name="theme"
                value={choice}
                defaultChecked={choice === current}
                className="accent-[var(--accent)]"
              />
              <span>
                <span className="block text-sm text-ink">
                  {t(`${choice}.label`)}
                </span>
                <span className="block text-xs text-ink-faint">
                  {t(`${choice}.hint`)}
                </span>
              </span>
            </label>
          ))}
        </div>
      </fieldset>

      <Feedback state={state} />
      <Save label={t("save")} />
    </form>
  );
}

function Save({ label }: { label: string }) {
  const t = useTranslations("common");
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={pending}
      className="mt-4 rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90 disabled:opacity-60"
    >
      {pending ? t("saving") : label}
    </button>
  );
}

function Feedback({ state }: { state: SettingsState }) {
  if (state.error) {
    return (
      <p
        role="alert"
        className="mt-4 rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm text-ink"
      >
        {state.error}
      </p>
    );
  }
  if (state.done) {
    return (
      <p role="status" className="mt-4 text-sm text-ink-muted">
        {state.done}
      </p>
    );
  }
  return null;
}
