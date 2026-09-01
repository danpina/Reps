/**
 * Who someone is, in the two facts that change the advice.
 *
 * Pure and shared, so the onboarding form, the settings form, the log form and
 * every prompt that describes a person all use one list. A second copy of
 * these values living in a select somewhere is how a form ends up offering an
 * option the database will reject.
 */

import type { Translate } from "@/lib/i18n";

export const SEXES = ["male", "female"] as const;
export type Sex = (typeof SEXES)[number];

export const AGE_GROUPS = [
  "18-24",
  "25-34",
  "35-44",
  "45-54",
  "55-64",
  "65+",
] as const;
export type AgeGroup = (typeof AGE_GROUPS)[number];

export function isSex(value: string): value is Sex {
  return (SEXES as readonly string[]).includes(value);
}

export function isAgeGroup(value: string): value is AgeGroup {
  return (AGE_GROUPS as readonly string[]).includes(value);
}

/** Reads a form field that is allowed to be left blank. */
export function parseSex(value: FormDataEntryValue | null): Sex | null {
  const text = String(value ?? "").trim();
  return isSex(text) ? text : null;
}

export function parseAgeGroup(
  value: FormDataEntryValue | null,
): AgeGroup | null {
  const text = String(value ?? "").trim();
  return isAgeGroup(text) ? text : null;
}

export const SEX_LABELS: Record<Sex, string> = {
  male: "Male",
  female: "Female",
};

export const DATING_INTERESTS = ["men", "women", "both"] as const;

export function isDatingInterest(
  value: string,
): value is (typeof DATING_INTERESTS)[number] {
  return (DATING_INTERESTS as readonly string[]).includes(value);
}

export function parseDatingInterest(
  value: FormDataEntryValue | null,
): (typeof DATING_INTERESTS)[number] | null {
  const text = String(value ?? "").trim();
  return isDatingInterest(text) ? text : null;
}

/**
 * Phrased as practice rather than as identity.
 *
 * It is what the app consumes — a rehearsal partner has to be someone — and a
 * question about who you are practising with is both more directly useful and
 * less to be holding about a person than one about who they are.
 */
export const DATING_INTEREST_LABELS: Record<
  (typeof DATING_INTERESTS)[number],
  string
> = {
  men: "Men",
  women: "Women",
  both: "Both",
};

export const AGE_LABELS: Record<AgeGroup, string> = {
  "18-24": "18 to 24",
  "25-34": "25 to 34",
  "35-44": "35 to 44",
  "45-54": "45 to 54",
  "55-64": "55 to 64",
  "65+": "65 or over",
};

/**
 * How the other half of a conversation is described in a log entry.
 *
 * Deliberately loose — "a woman, 25 to 34" rather than a pair of fields —
 * because that is how it would be said out loud, and because a guess about a
 * stranger deserves to be written down as a guess.
 */
export function describeOther(
  sex: Sex | null,
  age: AgeGroup | null,
): string | null {
  const who = sex === "male" ? "a man" : sex === "female" ? "a woman" : null;

  if (who && age) return `${who}, ${AGE_LABELS[age].toLowerCase()}`;
  if (who) return who;
  if (age) return `someone ${AGE_LABELS[age].toLowerCase()}`;
  return null;
}

/**
 * Where the other person sits relative to you.
 *
 * The interesting fact in a log is rarely the band itself, it is the gap. A
 * run of flat conversations with people a generation older says something a
 * list of bands does not.
 */
export type AgeRelation = "younger" | "same" | "older";

export function compareAges(
  mine: AgeGroup | null,
  theirs: AgeGroup | null,
): AgeRelation | null {
  if (!mine || !theirs) return null;

  const a = AGE_GROUPS.indexOf(mine);
  const b = AGE_GROUPS.indexOf(theirs);

  if (b === a) return "same";
  return b > a ? "older" : "younger";
}

/** One line describing the user, for a prompt. Null when nothing is known. */
export function describeSelf(
  sex: Sex | null,
  age: AgeGroup | null,
): string | null {
  if (sex && age) return `${SEX_LABELS[sex].toLowerCase()}, ${AGE_LABELS[age]}`;
  if (sex) return SEX_LABELS[sex].toLowerCase();
  if (age) return AGE_LABELS[age];
  return null;
}

/**
 * The reader-facing versions of the labels and sentences above.
 *
 * Kept apart from SEX_LABELS, AGE_LABELS, DATING_INTEREST_LABELS,
 * describeSelf and describeOther on purpose: those feed the coach and
 * rehearsal-partner prompts sent to Claude, and stay in English regardless of
 * the reader's language — that is a prompt-engineering decision, not a UI one.
 * These are for dropdown options and the field log, which do follow the
 * reader.
 */
export function sexOptionLabel(t: Translate, value: Sex): string {
  return t(`demographics.sex.${value}`);
}

export function ageOptionLabel(t: Translate, value: AgeGroup): string {
  return t(`demographics.age.${value}`);
}

export function datingInterestOptionLabel(
  t: Translate,
  value: (typeof DATING_INTERESTS)[number],
): string {
  return t(`demographics.datingInterest.${value}`);
}

/** The reader-facing version of describeOther, for the field log. */
export function describeOtherLocalized(
  t: Translate,
  sex: Sex | null,
  age: AgeGroup | null,
): string | null {
  const who =
    sex === "male"
      ? t("demographics.aMan")
      : sex === "female"
        ? t("demographics.aWoman")
        : null;
  const ageText = age ? ageOptionLabel(t, age) : null;

  if (who && ageText) return `${who}, ${ageText}`;
  if (who) return who;
  if (ageText) return t("demographics.someoneAged", { age: ageText });
  return null;
}
