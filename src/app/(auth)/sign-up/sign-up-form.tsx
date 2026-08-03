"use client";

import { useActionState } from "react";

import { signUp, type AuthState } from "../actions";
import { Button, Field, Notice } from "@/components/ui";

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
      <Button type="submit" disabled={pending}>
        {pending ? "Creating…" : "Create account"}
      </Button>
    </form>
  );
}
