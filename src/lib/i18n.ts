/**
 * The shape shared by every plain lib function that needs a translator.
 *
 * next-intl's own `t` (from useTranslations or getTranslations) satisfies this
 * structurally — this file exists so lib code that has nothing else to do with
 * next-intl does not need to import from it just to describe its argument.
 */
export type Translate = (
  key: string,
  values?: Record<string, string | number | Date>,
) => string;
