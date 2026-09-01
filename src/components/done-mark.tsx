import type { Translate } from "@/lib/i18n";

/**
 * How far through a lesson someone is.
 *
 * Three states rather than a tick box, because reading a card and going out and
 * using it are not the same achievement, and the whole app argues that the
 * second one is what counts.
 */
export type LessonState = "unread" | "read" | "used";

export function DoneMark({ state }: { state: LessonState }) {
  if (state === "unread") {
    return (
      <span
        aria-hidden
        className="mt-1.5 block h-2 w-2 shrink-0 rounded-full border border-rule-strong"
      />
    );
  }

  if (state === "read") {
    return (
      <span
        aria-hidden
        className="mt-1.5 block h-2 w-2 shrink-0 rounded-full border border-[var(--accent)]"
      />
    );
  }

  return (
    <span
      aria-hidden
      className="mt-1.5 block h-2 w-2 shrink-0 rounded-full bg-[var(--accent)]"
    />
  );
}

/** The same information in words, for screen readers and for the label line. */
export function stateLabel(t: Translate, state: LessonState): string {
  return t(`lessonState.${state}`);
}
