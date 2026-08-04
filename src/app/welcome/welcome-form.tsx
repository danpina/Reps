"use client";

import { useActionState, useState } from "react";
import { useFormStatus } from "react-dom";

import { completeOnboarding, type WelcomeState } from "./actions";

const CONTEXTS = [
  {
    value: "work",
    label: "At work",
    hint: "Colleagues, clients, the people you see every day and still cannot talk to.",
  },
  {
    value: "casual",
    label: "Out and about",
    hint: "Strangers, queues, parties, the gym. Conversations from nothing.",
  },
  {
    value: "flirting",
    label: "Dating",
    hint: "Reading interest accurately, and backing off warmly when it is not there.",
  },
  {
    value: "all",
    label: "All of it",
    hint: "No particular weak spot. Start at the beginning and work through.",
  },
];

export function WelcomeForm({ suggestedName }: { suggestedName?: string }) {
  const [state, formAction] = useActionState<WelcomeState, FormData>(
    completeOnboarding,
    {},
  );
  const [context, setContext] = useState<string | null>(null);

  return (
    <form action={formAction} className="mt-8 flex flex-col gap-8">
      <input
        type="hidden"
        name="timezone"
        value={Intl.DateTimeFormat().resolvedOptions().timeZone ?? ""}
      />

      <div className="flex flex-col gap-2">
        <label htmlFor="display_name" className="text-sm font-medium text-ink">
          What should we call you?
        </label>
        <input
          id="display_name"
          name="display_name"
          type="text"
          required
          maxLength={60}
          autoComplete="given-name"
          defaultValue={suggestedName ?? ""}
          placeholder="Your first name is plenty"
          className="rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2.5 text-sm text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        />
      </div>

      <fieldset className="flex flex-col gap-2">
        <legend className="text-sm font-medium text-ink">
          Where do you most want to get better?
        </legend>
        <p className="text-[13px] leading-relaxed text-ink-muted">
          This only picks where you start. Every track stays available.
        </p>

        <div className="mt-2 flex flex-col gap-2">
          {CONTEXTS.map((option) => {
            const selected = context === option.value;
            return (
              <label
                key={option.value}
                className={[
                  "cursor-pointer rounded border px-4 py-3 transition-colors",
                  // The input is sr-only, so the label carries the focus ring.
                  "has-[:focus-visible]:outline has-[:focus-visible]:outline-2 has-[:focus-visible]:outline-offset-2 has-[:focus-visible]:outline-[var(--focus)]",
                  selected
                    ? "border-[var(--accent)] bg-[var(--accent-soft)]"
                    : "border-[var(--rule-strong)] hover:bg-[var(--paper-raised)]",
                ].join(" ")}
              >
                <input
                  type="radio"
                  name="onboarding_context"
                  value={option.value}
                  checked={selected}
                  onChange={() => setContext(option.value)}
                  required
                  className="sr-only"
                />
                <span className="block text-sm font-medium text-ink">
                  {option.label}
                </span>
                <span className="mt-1 block text-[13px] leading-relaxed text-ink-muted">
                  {option.hint}
                </span>
              </label>
            );
          })}
        </div>
      </fieldset>

      {state.error ? (
        <p
          role="alert"
          className="rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm text-ink"
        >
          {state.error}
        </p>
      ) : null}

      <Submit />
    </form>
  );
}

function Submit() {
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={pending}
      className="rounded bg-[var(--accent)] px-4 py-3 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90 disabled:opacity-60"
    >
      {pending ? "Setting up…" : "Start"}
    </button>
  );
}
