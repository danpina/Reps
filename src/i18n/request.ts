import { getRequestConfig } from "next-intl/server";

import { getLocale } from "@/lib/auth/dal";

/**
 * Feeds next-intl from the app's own locale resolution rather than next-intl's,
 * since the reader's language is already known server-side on every request —
 * a signed-in choice stored on the profile, not a URL segment or cookie next-
 * intl would otherwise have to detect on its own.
 */
export default getRequestConfig(async () => {
  const locale = await getLocale();

  return {
    locale,
    messages: (await import(`../messages/${locale}.json`)).default,
  };
});
