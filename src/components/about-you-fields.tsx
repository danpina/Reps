"use client";

import type { DatingInterest } from "@/lib/curriculum/variants";
import {
  AGE_GROUPS,
  AGE_LABELS,
  DATING_INTERESTS,
  DATING_INTEREST_LABELS,
  SEXES,
  SEX_LABELS,
  type AgeGroup,
  type Sex,
} from "@/lib/profile/demographics";

/**
 * Two optional questions, used in three places.
 *
 * Both always carry a blank option, and it is always the default for someone
 * who has not answered. A required demographic question does not produce
 * better data, it produces a population who picked whichever option was at the
 * top of the list.
 */
export function AboutYouFields({
  sex,
  ageGroup,
  datingInterest,
  idPrefix = "",
  sexLabel = "You are",
  ageLabel = "Your age",
}: {
  sex: Sex | null;
  ageGroup: AgeGroup | null;
  datingInterest: DatingInterest | null;
  /** Keeps ids unique when the fields appear twice on one page. */
  idPrefix?: string;
  sexLabel?: string;
  ageLabel?: string;
}) {
  const sexId = `${idPrefix}sex`;
  const ageId = `${idPrefix}age_group`;
  const datingId = `${idPrefix}dating_interest`;

  return (
    <div className="flex flex-wrap gap-4">
      <div className="flex min-w-40 flex-1 flex-col gap-1.5">
        <label htmlFor={sexId} className="text-sm font-medium text-ink">
          {sexLabel}
        </label>
        <select
          id={sexId}
          name="sex"
          defaultValue={sex ?? ""}
          className="rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2.5 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        >
          <option value="">Rather not say</option>
          {SEXES.map((value) => (
            <option key={value} value={value}>
              {SEX_LABELS[value]}
            </option>
          ))}
        </select>
      </div>

      <div className="flex min-w-40 flex-1 flex-col gap-1.5">
        <label htmlFor={ageId} className="text-sm font-medium text-ink">
          {ageLabel}
        </label>
        <select
          id={ageId}
          name="age_group"
          defaultValue={ageGroup ?? ""}
          className="rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2.5 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        >
          <option value="">Rather not say</option>
          {AGE_GROUPS.map((value) => (
            <option key={value} value={value}>
              {AGE_LABELS[value]}
            </option>
          ))}
        </select>
      </div>

      {/* Asked as practice rather than as identity, and labelled so it is
          obvious the answer is only ever used by one topic. */}
      <div className="flex min-w-40 flex-1 flex-col gap-1.5">
        <label htmlFor={datingId} className="text-sm font-medium text-ink">
          Dating practice with
        </label>
        <select
          id={datingId}
          name="dating_interest"
          defaultValue={datingInterest ?? ""}
          className="rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2.5 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        >
          <option value="">Rather not say</option>
          {DATING_INTERESTS.map((value) => (
            <option key={value} value={value}>
              {DATING_INTEREST_LABELS[value]}
            </option>
          ))}
        </select>
      </div>
    </div>
  );
}

/**
 * The same two questions about the other half of a conversation.
 *
 * Different field names, and a much lighter frame: this is a guess about a
 * stranger, offered because it makes the log searchable later, and it must
 * never feel like paperwork owed before a rep can be recorded.
 */
export function AboutThemFields({
  sex,
  ageGroup,
}: {
  sex: Sex | null;
  ageGroup: AgeGroup | null;
}) {
  return (
    <div className="flex flex-wrap gap-4">
      <div className="flex min-w-40 flex-1 flex-col gap-1.5">
        <label htmlFor="other_sex" className="text-sm text-ink-muted">
          They were
        </label>
        <select
          id="other_sex"
          name="other_sex"
          defaultValue={sex ?? ""}
          className="rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        >
          <option value="">Not saying</option>
          {SEXES.map((value) => (
            <option key={value} value={value}>
              {SEX_LABELS[value]}
            </option>
          ))}
        </select>
      </div>

      <div className="flex min-w-40 flex-1 flex-col gap-1.5">
        <label htmlFor="other_age_group" className="text-sm text-ink-muted">
          Roughly
        </label>
        <select
          id="other_age_group"
          name="other_age_group"
          defaultValue={ageGroup ?? ""}
          className="rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        >
          <option value="">Not saying</option>
          {AGE_GROUPS.map((value) => (
            <option key={value} value={value}>
              {AGE_LABELS[value]}
            </option>
          ))}
        </select>
      </div>
    </div>
  );
}
