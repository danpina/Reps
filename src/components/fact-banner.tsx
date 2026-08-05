import type { Fact } from "@/lib/facts";

/**
 * One reason this is worth the effort.
 *
 * No label. "Why bother" read as nagging, and any fixed heading gets repetitive
 * the second time you see it — the line speaks for itself, so it is left to.
 */
export function FactBanner({ fact }: { fact: Fact }) {
  return (
    <aside className="border-l-2 border-[var(--accent)] pl-4">
      <p className="text-[15px] leading-[1.6] text-ink">{fact.text}</p>
    </aside>
  );
}
