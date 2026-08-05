import type { Fact } from "@/lib/facts";

/**
 * One reason this is worth the effort.
 *
 * No label — "Why bother" read as nagging, and any fixed heading gets
 * repetitive on second sight. Quoted and italic instead, so it is obviously an
 * aside rather than something the app is asking you to do.
 */
export function FactBanner({ fact }: { fact: Fact }) {
  return (
    <figure className="border-l-2 border-[var(--accent)] pl-4">
      <blockquote>
        <p className="text-[15px] italic leading-[1.6] text-ink-muted">
          &ldquo;{fact.text}&rdquo;
        </p>
      </blockquote>
    </figure>
  );
}
