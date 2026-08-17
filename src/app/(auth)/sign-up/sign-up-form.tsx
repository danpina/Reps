"use client";

import { useActionState } from "react";

import { signUp, type AuthState } from "../actions";
import { Button, Field, Notice } from "@/components/ui";
import { DEFAULT_LOCALE, LOCALES, LOCALE_NAMES } from "@/lib/curriculum/locale";

export function SignUpForm() {
  const [state, action, pending] = useActionState<AuthState, FormData>(
    signUp,
    undefined,
  );

  return (
    <form action={action} className="flex flex-col gap-4">
      {state?.error ? <Notice>{state.error}</Notice> : null}

      <Field
        id="display_name"
        name="display_name"
        label="What should we call you?"
        autoComplete="nickname"
        hint="Only you ever see this."
      />
      <Field
        id="email"
        name="email"
        type="email"
        label="Email"
        autoComplete="email"
        required
      />
      <Field
        id="password"
        name="password"
        type="password"
        label="Password"
        autoComplete="new-password"
        minLength={8}
        required
        hint="At least 8 characters."
      />

      {/* Each language named in itself, so somebody looking for their own can
          find it without reading English first. */}
      <label className="flex flex-col gap-1.5">
        <span className="text-sm text-ink">Language</span>
        <select
          name="locale"
          defaultValue={DEFAULT_LOCALE}
          className="rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2.5 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        >
          {LOCALES.map((locale) => (
            <option key={locale} value={locale}>
              {LOCALE_NAMES[locale]}
            </option>
          ))}
        </select>
        <span className="text-xs text-ink-faint">
          You can change this later. Anything not yet translated stays in
          English.
        </span>
      </label>

      <Button type="submit" disabled={pending}>
        {pending ? "Creating…" : "Create account"}
      </Button>
    </form>
  );
}
