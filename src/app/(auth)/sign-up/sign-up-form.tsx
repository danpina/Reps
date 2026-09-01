"use client";

import { useActionState } from "react";
import { useTranslations } from "next-intl";

import { signUp, type AuthState } from "../actions";
import { Button, Field, Notice } from "@/components/ui";
import { DEFAULT_LOCALE, LOCALES, LOCALE_NAMES } from "@/lib/curriculum/locale";

export function SignUpForm() {
  const t = useTranslations("auth.signUp");
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
        label={t("displayNameLabel")}
        autoComplete="nickname"
        hint={t("displayNameHint")}
      />
      <Field
        id="email"
        name="email"
        type="email"
        label={t("emailLabel")}
        autoComplete="email"
        required
      />
      <Field
        id="password"
        name="password"
        type="password"
        label={t("passwordLabel")}
        autoComplete="new-password"
        minLength={8}
        required
        hint={t("passwordHint")}
      />

      {/* Each language named in itself, so somebody looking for their own can
          find it without reading English first. */}
      <label className="flex flex-col gap-1.5">
        <span className="text-sm text-ink">{t("languageLabel")}</span>
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
        <span className="text-xs text-ink-faint">{t("languageHint")}</span>
      </label>

      <Button type="submit" disabled={pending}>
        {pending ? t("submitPending") : t("submit")}
      </Button>
    </form>
  );
}
