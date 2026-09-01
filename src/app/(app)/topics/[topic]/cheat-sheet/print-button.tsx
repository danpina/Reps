"use client";

import { useTranslations } from "next-intl";

/**
 * Opens the browser's own print dialog, which is also where Save as PDF lives.
 *
 * Deliberately not a generated file. Every browser and phone already turns this
 * page into a PDF from that dialog, and the page is laid out for paper, so
 * adding a PDF library would buy a slightly worse-looking document, a
 * dependency, and a server route that has to be kept in step with the design.
 *
 * The label says both things it does, because a button called Download that
 * opens a print dialog is a small lie.
 */
export function PrintButton() {
  const t = useTranslations("cheatSheet");
  return (
    <button
      type="button"
      data-print="hide"
      onClick={() => window.print()}
      className="rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
    >
      {t("printOrSaveAsPdf")}
    </button>
  );
}
