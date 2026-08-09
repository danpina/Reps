"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

/**
 * Persistent navigation for signed-in screens.
 *
 * A bottom bar on phones and a top bar on wider screens. Logging happens on
 * the move, minutes after a real conversation, so on a phone the primary
 * action sits under the thumb rather than at the top of the page.
 */

type Item = {
  href: string;
  label: string;
  /** Only ever drawn in the bottom bar, so a desktop-only item has none. */
  icon?: React.ReactNode;
  /**
   * Kept off the phone.
   *
   * The bottom bar is five tabs wide and every one of them is a place you go
   * daily. A sixth would shrink the other five to make room for the one you
   * open least, so this stays a top-bar link and reaches the phone through
   * Today instead.
   */
  wideOnly?: boolean;
  /** Also treat these prefixes as this section. */
  match: (pathname: string) => boolean;
};

const stroke = {
  fill: "none",
  stroke: "currentColor",
  strokeWidth: 1.5,
  strokeLinecap: "round" as const,
  strokeLinejoin: "round" as const,
};

const ITEMS: Item[] = [
  {
    href: "/today",
    label: "Today",
    match: (p) => p === "/today",
    icon: (
      <svg viewBox="0 0 20 20" aria-hidden className="h-5 w-5">
        <rect x="3" y="4.5" width="14" height="12" rx="1.5" {...stroke} />
        <path d="M3 8.5h14M7 3v3M13 3v3" {...stroke} />
      </svg>
    ),
  },
  {
    href: "/topics",
    label: "Learn",
    // A skill is reached through its topic, and /pro is reached from the locks
    // inside one, so all three light the same tab.
    match: (p) =>
      p.startsWith("/topics") || p.startsWith("/skills") || p.startsWith("/pro"),
    icon: (
      <svg viewBox="0 0 20 20" aria-hidden className="h-5 w-5">
        <path d="M4 5h12M4 10h12M4 15h8" {...stroke} />
      </svg>
    ),
  },
  {
    href: "/log",
    label: "Log",
    match: (p) => p === "/log",
    icon: (
      <svg viewBox="0 0 20 20" aria-hidden className="h-5 w-5">
        <circle cx="10" cy="10" r="7" {...stroke} />
        <path d="M10 6.5v7M6.5 10h7" {...stroke} />
      </svg>
    ),
  },
  {
    href: "/field-log",
    label: "Field log",
    match: (p) => p.startsWith("/field-log"),
    icon: (
      <svg viewBox="0 0 20 20" aria-hidden className="h-5 w-5">
        <path d="M5 3.5h9a1.5 1.5 0 0 1 1.5 1.5v11L10 13.5 4.5 16V5A1.5 1.5 0 0 1 6 3.5Z" {...stroke} />
      </svg>
    ),
  },
  {
    href: "/rehearse",
    label: "Rehearsals",
    wideOnly: true,
    // A scene is reached from the lesson it belongs to, so /rehearse/:id lights
    // this rather than Learn.
    match: (p) => p.startsWith("/rehearse"),
  },
  {
    href: "/settings",
    label: "Settings",
    // Admin lives behind settings rather than in the nav: it is not a place
    // most accounts can go, and a tab that only some people have is a tab that
    // has to explain itself.
    match: (p) => p.startsWith("/settings") || p.startsWith("/admin"),
    icon: (
      <svg viewBox="0 0 20 20" aria-hidden className="h-5 w-5">
        <circle cx="10" cy="10" r="2.5" {...stroke} />
        <path
          d="M10 2.5v2M10 15.5v2M17.5 10h-2M4.5 10h-2M15.3 4.7l-1.4 1.4M6.1 13.9l-1.4 1.4M15.3 15.3l-1.4-1.4M6.1 6.1 4.7 4.7"
          {...stroke}
        />
      </svg>
    ),
  },
];

export function AppNav() {
  const pathname = usePathname();

  // Pulled out by name rather than by index, so reordering ITEMS cannot
  // silently promote something else into the corner.
  const settings = ITEMS.find((i) => i.href === "/settings")!;

  return (
    <>
      {/* Wide screens: a quiet bar across the top. */}
      <header
        data-print="hide"
        className="sticky top-0 z-20 hidden border-b border-rule bg-[var(--paper)]/90 backdrop-blur sm:block"
      >
        <nav
          aria-label="Main"
          className="mx-auto flex w-full max-w-2xl items-center gap-1 px-5 py-3"
        >
          <Link
            href="/today"
            className="tabular mr-4 text-xs uppercase tracking-[0.18em] text-ink-faint transition-colors hover:text-ink"
          >
            Reps
          </Link>

          {ITEMS.filter(
            (i) => i.href !== "/log" && i.href !== "/settings",
          ).map((item) => {
            const active = item.match(pathname);
            return (
              <Link
                key={item.href}
                href={item.href}
                aria-current={active ? "page" : undefined}
                className={[
                  "rounded px-3 py-1.5 text-sm transition-colors",
                  active
                    ? "bg-[var(--accent-soft)] text-ink"
                    : "text-ink-muted hover:bg-[var(--paper-raised)] hover:text-ink",
                ].join(" ")}
              >
                {item.label}
              </Link>
            );
          })}

          <Link
            href="/log"
            aria-current={pathname === "/log" ? "page" : undefined}
            className="ml-auto rounded bg-[var(--accent)] px-3.5 py-1.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
          >
            Log a rep
          </Link>

          {/* Off to the side rather than in the run of tabs, because it is
              somewhere you go twice a year. Icon only was a step too far — a
              faint glyph in a corner is not findable, it is merely small. It
              keeps its word, in a bordered pill that reads as a control rather
              than as another tab. */}
          <Link
            href="/settings"
            aria-current={settings.match(pathname) ? "page" : undefined}
            className={[
              "ml-2 flex items-center gap-1.5 rounded border px-2.5 py-1.5 text-sm transition-colors",
              settings.match(pathname)
                ? "border-[var(--accent)] bg-[var(--accent-soft)] text-ink"
                : "border-[var(--rule-strong)] text-ink-muted hover:bg-[var(--paper-raised)] hover:text-ink",
            ].join(" ")}
          >
            {settings.icon}
            <span>Settings</span>
          </Link>
        </nav>
      </header>

      {/* Phones: tabs under the thumb. */}
      <nav
        aria-label="Main"
        data-print="hide"
        className="fixed inset-x-0 bottom-0 z-20 border-t border-rule bg-[var(--paper)]/95 backdrop-blur sm:hidden"
        style={{ paddingBottom: "env(safe-area-inset-bottom)" }}
      >
        <ul className="mx-auto flex max-w-lg">
          {ITEMS.filter((item) => !item.wideOnly).map((item) => {
            const active = item.match(pathname);
            return (
              <li key={item.href} className="flex-1">
                <Link
                  href={item.href}
                  aria-current={active ? "page" : undefined}
                  className={[
                    "flex flex-col items-center gap-1 py-2.5 text-[11px] transition-colors",
                    active ? "text-[var(--accent)]" : "text-ink-faint",
                  ].join(" ")}
                >
                  {item.icon}
                  <span>{item.label}</span>
                </Link>
              </li>
            );
          })}
        </ul>
      </nav>
    </>
  );
}
