"use client";

import { useActionState } from "react";
import { useTranslations } from "next-intl";

import { requestPasswordReset, type AuthState } from "../actions";
import { Button, Field, Notice } from "@/components/ui";

export function ForgotPasswordForm() {
  const t = useTranslations("auth.forgotPassword");
  const [state, formAction, pending] = useActionState<AuthState, FormData>(
    requestPasswordReset,
    undefined,
  );

  return (
    <form action={formAction} className="flex flex-col gap-4">
      {state?.error ? <Notice>{state.error}</Notice> : null}
      <Field
        id="email"
        name="email"
        type="email"
        label={t("emailLabel")}
        autoComplete="email"
        required
      />
      <Button type="submit" disabled={pending}>
        {pending ? t("submitPending") : t("submit")}
      </Button>
    </form>
  );
}
