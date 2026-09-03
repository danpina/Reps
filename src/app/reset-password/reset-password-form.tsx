"use client";

import { useActionState } from "react";
import { useTranslations } from "next-intl";

import { resetPassword, type ResetPasswordState } from "./actions";
import { Button, Field, Notice } from "@/components/ui";

export function ResetPasswordForm() {
  const t = useTranslations("resetPasswordPage");
  const [state, formAction, pending] = useActionState<
    ResetPasswordState,
    FormData
  >(resetPassword, {});

  return (
    <form action={formAction} className="mt-6 flex flex-col gap-4">
      {state.error ? <Notice>{state.error}</Notice> : null}
      <Field
        id="new_password"
        name="new_password"
        type="password"
        label={t("newPasswordLabel")}
        autoComplete="new-password"
        hint={t("newPasswordHint")}
        required
      />
      <Field
        id="confirm_password"
        name="confirm_password"
        type="password"
        label={t("confirmLabel")}
        autoComplete="new-password"
        required
      />
      <Button type="submit" disabled={pending}>
        {pending ? t("submitPending") : t("submit")}
      </Button>
    </form>
  );
}
