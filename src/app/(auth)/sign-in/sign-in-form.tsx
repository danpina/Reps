"use client";

import Link from "next/link";
import { useActionState, useState } from "react";
import { useTranslations } from "next-intl";

import { sendMagicLink, signIn, type AuthState } from "../actions";
import { Button, Field, Notice } from "@/components/ui";

export function SignInForm({
  next,
  linkError,
}: {
  next: string;
  linkError: boolean;
}) {
  const t = useTranslations("auth.signIn");
  const [email, setEmail] = useState("");

  const [passwordState, passwordAction, passwordPending] = useActionState<
    AuthState,
    FormData
  >(signIn, undefined);

  const [linkState, linkAction, linkPending] = useActionState<
    AuthState,
    FormData
  >(sendMagicLink, undefined);

  const error = passwordState?.error ?? linkState?.error;

  return (
    <div className="flex flex-col gap-5">
      {linkError ? <Notice>{t("linkExpired")}</Notice> : null}
      {error ? <Notice>{error}</Notice> : null}

      <form action={passwordAction} className="flex flex-col gap-4">
        <input type="hidden" name="next" value={next} />
        <Field
          id="email"
          name="email"
          type="email"
          label={t("emailLabel")}
          autoComplete="email"
          required
          value={email}
          onChange={(event) => setEmail(event.target.value)}
        />
        <Field
          id="password"
          name="password"
          type="password"
          label={t("passwordLabel")}
          autoComplete="current-password"
          required
        />
        <Link
          href="/forgot-password"
          className="-mt-2 self-end text-sm text-ink-muted underline underline-offset-4"
        >
          {t("forgotPassword")}
        </Link>
        <Button type="submit" disabled={passwordPending}>
          {passwordPending ? t("submitPending") : t("submit")}
        </Button>
      </form>

      <form action={linkAction} className="border-t border-rule pt-5">
        <input type="hidden" name="email" value={email} />
        <p className="mb-3 text-sm text-ink-muted">{t("magicLinkHint")}</p>
        <Button
          type="submit"
          variant="quiet"
          className="w-full"
          disabled={linkPending || email.trim() === ""}
        >
          {linkPending ? t("magicLinkPending") : t("magicLinkSubmit")}
        </Button>
      </form>
    </div>
  );
}
