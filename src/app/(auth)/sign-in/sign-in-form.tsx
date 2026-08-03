"use client";

import { useActionState, useState } from "react";

import { sendMagicLink, signIn, type AuthState } from "../actions";
import { Button, Field, Notice } from "@/components/ui";

export function SignInForm({
  next,
  linkError,
}: {
  next: string;
  linkError: boolean;
}) {
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
      {linkError ? (
        <Notice>That link has expired or was already used. Try again.</Notice>
      ) : null}
      {error ? <Notice>{error}</Notice> : null}

      <form action={passwordAction} className="flex flex-col gap-4">
        <input type="hidden" name="next" value={next} />
        <Field
          id="email"
          name="email"
          type="email"
          label="Email"
          autoComplete="email"
          required
          value={email}
          onChange={(event) => setEmail(event.target.value)}
        />
        <Field
          id="password"
          name="password"
          type="password"
          label="Password"
          autoComplete="current-password"
          required
        />
        <Button type="submit" disabled={passwordPending}>
          {passwordPending ? "Signing in…" : "Sign in"}
        </Button>
      </form>

      <form action={linkAction} className="border-t border-rule pt-5">
        <input type="hidden" name="email" value={email} />
        <p className="mb-3 text-sm text-ink-muted">
          Or sign in without a password. We&rsquo;ll email a one-time link to the
          address above.
        </p>
        <Button
          type="submit"
          variant="quiet"
          className="w-full"
          disabled={linkPending || email.trim() === ""}
        >
          {linkPending ? "Sending…" : "Email me a link"}
        </Button>
      </form>
    </div>
  );
}
