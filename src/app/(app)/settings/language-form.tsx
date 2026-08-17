"use client";

import { useActionState } from "react";
import { useFormStatus } from "react-dom";

import { LOCALES, LOCALE_NAMES, type Locale } from "@/lib/curriculum/locale";
import { updateLanguage, type SettingsState } from "./actions";

/**
 * Each language named in itself, which is how somebody looking for their own
 * finds it. A Spanish reader scans for "Español", not for "Spanish".
 */
export function LanguageForm({ current }: { current: Locale }) {
  const [state, formAction] = useActionState<SettingsState, FormData>(
    updateLanguage,
    {},
  );

  return (
    <form action={formAction}>
      <fieldset>
        <legend className="sr-only">Language</legend>
        <div className="flex flex-col gap-2">
          {LOCALES.map((locale) => (
            <label
              key={locale}
              className="flex cursor-pointer items-baseline gap-3 rounded border border-rule px-4 py-3 transition-colors hover:bg-[var(--paper-raised)] has-[:checked]:border-[var(--accent)] has-[:checked]:bg-[var(--accent-soft)]"
            >
              <input
                type="radio"
                name="locale"
                value={locale}
                defaultChecked={locale === current}
                className="accent-[var(--accent)]"
              />
              <span className="text-sm text-ink">{LOCALE_NAMES[locale]}</span>
            </label>
          ))}
        </div>
      </fieldset>

      <Feedback state={state} />
      <Save label="Save language" />
    </form>
  );
}

function Save({ label }: { label: string }) {
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={pending}
      className="mt-4 rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90 disabled:opacity-60"
    >
      {pending ? "Saving…" : label}
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
