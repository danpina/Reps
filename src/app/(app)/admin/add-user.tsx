"use client";

import { useActionState } from "react";
import { useFormStatus } from "react-dom";
import { useTranslations } from "next-intl";

import { createUser, inviteUser, type AdminState } from "./actions";

/**
 * Two ways in, in the order they should be preferred.
 *
 * Inviting is the default because nobody but the account holder ever learns
 * the password. Creating one directly is folded away behind a disclosure: it
 * exists for when email delivery is broken, which is the only good reason to
 * hand someone credentials you also know.
 */
export function AddUser() {
  const t = useTranslations("adminPage.addUser");
  return (
    <section className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-5">
      <h2 className="text-sm font-semibold text-ink">{t("addSomeone")}</h2>
      <InviteForm />

      <details className="mt-5 border-t border-rule pt-4">
        <summary className="cursor-pointer text-xs text-ink-faint underline-offset-4 hover:underline">
          {t("orCreateDirectly")}
        </summary>
        <CreateForm />
      </details>
    </section>
  );
}

function InviteForm() {
  const t = useTranslations("adminPage.addUser");
  const [state, formAction] = useActionState<AdminState, FormData>(
    inviteUser,
    {},
  );

  return (
    <form key={state.done ?? "inviting"} action={formAction} className="mt-3">
      <label htmlFor="invite_email" className="sr-only">
        {t("emailToInvite")}
      </label>
      <div className="flex flex-wrap gap-2">
        <input
          id="invite_email"
          name="email"
          type="email"
          required
          placeholder="them@example.com"
          className="min-w-0 flex-1 rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2 text-sm text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        />
        <Submit idle={t("sendInvite")} busy={t("sendingPending")} />
      </div>
      <p className="mt-2 text-xs text-ink-faint">
        {t("theySetOwnPassword")}
      </p>
      <Feedback state={state} />
    </form>
  );
}

function CreateForm() {
  const t = useTranslations("adminPage.addUser");
  const [state, formAction] = useActionState<AdminState, FormData>(
    createUser,
    {},
  );

  return (
    <form key={state.done ?? "creating"} action={formAction} className="mt-3">
      <div className="flex flex-col gap-2">
        <label htmlFor="create_email" className="sr-only">
          {t("email")}
        </label>
        <input
          id="create_email"
          name="email"
          type="email"
          required
          placeholder="them@example.com"
          className="w-full rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2 text-sm text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        />
        <label htmlFor="create_password" className="sr-only">
          {t("initialPassword")}
        </label>
        <input
          id="create_password"
          name="password"
          type="password"
          required
          autoComplete="new-password"
          placeholder={t("initialPasswordPlaceholder")}
          className="w-full rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2 text-sm text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        />
      </div>
      <p className="mt-2 text-xs text-ink-faint">
        {t("youWillKnowThisPassword")}
      </p>
      <Feedback state={state} />
      <div className="mt-3">
        <Submit idle={t("createAccount")} busy={t("creatingPending")} />
      </div>
    </form>
  );
}

function Submit({ idle, busy }: { idle: string; busy: string }) {
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={pending}
      className="rounded bg-[var(--accent)] px-4 py-2 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90 disabled:opacity-60"
    >
      {pending ? busy : idle}
    </button>
  );
}

export function Feedback({ state }: { state: AdminState }) {
  if (state.error) {
    return (
      <p
        role="alert"
        className="mt-3 rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-3 py-2 text-sm text-ink"
      >
        {state.error}
      </p>
    );
  }
  if (state.done) {
    return (
      <p role="status" className="mt-3 text-sm text-ink-muted">
        {state.done}
      </p>
    );
  }
  return null;
}
