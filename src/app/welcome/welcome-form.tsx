"use client";

import { useActionState, useState } from "react";
import { useFormStatus } from "react-dom";

import { AboutYouFields } from "@/components/about-you-fields";
import { completeOnboarding, type WelcomeState } from "./actions";

export type TopicChoice = {
  slug: string;
  name: string;
  description: string;
};

export function WelcomeForm({
  suggestedName,
  topics,
}: {
  suggestedName?: string;
  topics: TopicChoice[];
}) {
  const [state, formAction] = useActionState<WelcomeState, FormData>(
    completeOnboarding,
    {},
  );
  const [choice, setChoice] = useState<string | null>(null);

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

      {/* Asked here rather than buried in settings, because they change the
          advice from the first lesson onwards — and both may be skipped. */}
      <div className="flex flex-col gap-2">
        <AboutYouFields sex={null} ageGroup={null} datingInterest={null} />
        <p className="text-[13px] leading-relaxed text-ink-muted">
          Optional, and only used to make the coaching fit. Advice about
          flirting or about talking to your boss is different at twenty-two and
          at fifty-five, and an app that does not know cannot tell.
        </p>
      </div>

      <fieldset className="flex flex-col gap-2">
        <legend className="text-sm font-medium text-ink">
          Where do you most want to get better?
        </legend>
        <p className="text-[13px] leading-relaxed text-ink-muted">
          This only picks where you start. Every topic stays available, and more
          are being written.
        </p>

        <div className="mt-2 flex flex-col gap-2">
          {topics.map((option) => {
            const selected = choice === option.slug;
            return (
              <label
                key={option.slug}
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
                  name="topic"
                  value={option.slug}
                  checked={selected}
                  onChange={() => setChoice(option.slug)}
                  required
                  className="sr-only"
                />
                <span className="block text-sm font-medium text-ink">
                  {option.name}
                </span>
                <span className="mt-1 block text-[13px] leading-relaxed text-ink-muted">
                  {option.description}
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
