import type { Fact } from "@/lib/facts";

/**
 * One reason this is worth the effort.
 *
 * Deliberately quiet — a hairline rule and small type, not a hero banner. The
 * job is a reminder on the way past, not a sales pitch.
 */
export function FactBanner({ fact }: { fact: Fact }) {
  return (
    <aside className="border-l-2 border-[var(--accent)] pl-4">
      <p className="tabular text-[11px] uppercase tracking-[0.18em] text-ink-faint">
        Why bother
      </p>
      <p className="mt-1.5 text-[14px] leading-[1.55] text-ink">{fact.text}</p>
    </aside>
  );
}
