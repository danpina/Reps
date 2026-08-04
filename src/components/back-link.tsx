import Link from "next/link";

/**
 * The one way back up a level. Nested screens used to each invent their own
 * breadcrumb, which read differently on every page.
 */
export function BackLink({ href, label }: { href: string; label: string }) {
  return (
    <Link
      href={href}
      className="group inline-flex items-center gap-1.5 text-xs text-ink-faint transition-colors hover:text-ink"
    >
      <svg viewBox="0 0 16 16" aria-hidden className="h-3.5 w-3.5">
        <path
          d="M9.5 3.5 5 8l4.5 4.5"
          fill="none"
          stroke="currentColor"
          strokeWidth={1.5}
          strokeLinecap="round"
          strokeLinejoin="round"
        />
      </svg>
      <span className="underline-offset-4 group-hover:underline">{label}</span>
    </Link>
  );
}
