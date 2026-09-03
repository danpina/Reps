/**
 * The languages the curriculum can be read in, and the rule for falling back.
 *
 * Pure, so the fallback can be tested without a database. It is one function
 * and it is worth having on its own, because "fall back to English" has two
 * plausible meanings and only one of them is right: per row, where a topic
 * with any translation is shown entirely in that language, and per field,
 * where each column falls back on its own.
 *
 * Per field is the one implemented here. It is what lets a language ship
 * before it is finished — a topic can have a translated name and an
 * untranslated promise, and a reader sees the Spanish name rather than
 * waiting for the promise to be written.
 */

export const LOCALES = ["en", "es", "de"] as const;
export type Locale = (typeof LOCALES)[number];

export const DEFAULT_LOCALE: Locale = "en";

/**
 * The cookie a returning-but-signed-out visitor is read from.
 *
 * The profile column is the source of truth once somebody is signed in, but
 * sign-in, sign-up and check-email all render before a session exists to read
 * it from — this is what keeps a person who has already chosen Spanish from
 * landing back on an English sign-in screen after being signed out.
 */
export const LOCALE_COOKIE = "locale";

/** The name of a language in that language, which is how pickers should read. */
export const LOCALE_NAMES: Record<Locale, string> = {
  en: "English",
  es: "Español",
  de: "Deutsch",
};

/**
 * The name of a language in English, for AI prompts.
 *
 * The roleplay partner and the coach are both told to answer in this
 * language rather than left to infer it — a system prompt written in English
 * pulls a model toward English regardless of what language the scenario data
 * around it happens to be in, and "respond in Spanish" written in English is
 * followed more reliably than the same instruction written in Spanish.
 */
export const LOCALE_ENGLISH_NAMES: Record<Locale, string> = {
  en: "English",
  es: "Spanish",
  de: "German",
};

export function isLocale(value: unknown): value is Locale {
  return typeof value === "string" && (LOCALES as readonly string[]).includes(value);
}

/** Anything unrecognised reads as English rather than throwing. */
export function asLocale(value: unknown): Locale {
  return isLocale(value) ? value : DEFAULT_LOCALE;
}

/**
 * Lay a translation over a base row, field by field.
 *
 * A translated field counts as present only if it is not null and not an empty
 * string. That second condition matters: an empty string is what a
 * half-finished translation looks like, and treating it as a translation would
 * blank a heading rather than fall back to the English one.
 */
export function localise<T extends object>(
  base: T,
  translation: Partial<Record<keyof T, unknown>> | null | undefined,
): T {
  if (!translation) return base;

  const merged = { ...base };
  for (const key of Object.keys(translation) as (keyof T)[]) {
    const value = translation[key];
    if (value === null || value === undefined) continue;
    if (typeof value === "string" && value.trim() === "") continue;
    merged[key] = value as T[keyof T];
  }
  return merged;
}

/**
 * Index translation rows by the id they belong to, for one locale.
 *
 * The caller fetches every translation for the reader's language in one query
 * and then merges in memory, which is one round trip regardless of how much of
 * the curriculum has been translated.
 */
export function byId<T extends Record<string, unknown>>(
  rows: T[] | null | undefined,
  idColumn: keyof T,
): Map<string, T> {
  const index = new Map<string, T>();
  for (const row of rows ?? []) {
    const id = row[idColumn];
    if (typeof id === "string") index.set(id, row);
  }
  return index;
}
