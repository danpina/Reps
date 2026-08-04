// WCAG AA contrast, checked against the palette actually shipped in
// globals.css rather than a copy of it. This caught --ink-faint failing in
// both themes at 2.91:1 and 3.85:1, where it is used for timestamps, stat
// labels and "XP to go".

import { describe, test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { join } from "node:path";

const CSS = readFileSync(
  join(import.meta.dirname, "..", "src", "app", "globals.css"),
  "utf8",
);

/** Reads the custom properties from one `:root[data-theme="…"]` block. */
function palette(theme: "light" | "dark"): Record<string, string> {
  const block = new RegExp(
    `:root\\[data-theme="${theme}"\\]\\s*\\{([\\s\\S]*?)\\}`,
  ).exec(CSS);
  assert.ok(block, `no [data-theme="${theme}"] block found in globals.css`);

  const tokens: Record<string, string> = {};
  for (const [, name, value] of block[1].matchAll(
    /--([a-z-]+):\s*(#[0-9a-fA-F]{6})\s*;/g,
  )) {
    tokens[name] = value;
  }
  return tokens;
}

function luminance(hex: string): number {
  const channels = [1, 3, 5].map((i) => parseInt(hex.slice(i, i + 2), 16) / 255);
  const [r, g, b] = channels.map((c) =>
    c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4,
  );
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

function contrast(a: string, b: string): number {
  const [hi, lo] = [luminance(a), luminance(b)].sort((x, y) => y - x);
  return (hi + 0.05) / (lo + 0.05);
}

// 4.5:1 for body text, 3:1 for non-text indicators such as the focus ring.
const PAIRS: [string, string, number][] = [
  ["ink", "paper", 4.5],
  ["ink", "paper-raised", 4.5],
  ["ink-muted", "paper", 4.5],
  ["ink-muted", "paper-raised", 4.5],
  ["ink-faint", "paper", 4.5],
  ["ink-faint", "paper-raised", 4.5],
  ["accent", "paper", 4.5],
  ["accent", "accent-soft", 4.5],
  ["accent-ink", "accent", 4.5],
  ["ink", "accent-soft", 4.5],
  ["flag", "paper", 4.5],
  ["ink", "flag-soft", 4.5],
  ["focus", "paper", 3],
  ["focus", "paper-raised", 3],
];

for (const theme of ["light", "dark"] as const) {
  describe(`${theme} palette`, () => {
    const tokens = palette(theme);

    test("every token used for text is defined", () => {
      for (const [fg, bg] of PAIRS) {
        assert.ok(tokens[fg], `--${fg} missing`);
        assert.ok(tokens[bg], `--${bg} missing`);
      }
    });

    for (const [fg, bg, min] of PAIRS) {
      test(`--${fg} on --${bg} meets ${min}:1`, () => {
        const ratio = contrast(tokens[fg], tokens[bg]);
        assert.ok(
          ratio >= min,
          `${tokens[fg]} on ${tokens[bg]} is ${ratio.toFixed(2)}:1, needs ${min}:1`,
        );
      });
    }
  });
}

describe("theme blocks agree", () => {
  // The media-query block and the data-theme block must not drift apart, or
  // the manual theme toggle would show different colours from the automatic
  // one.
  test("dark media query matches the dark data-theme block", () => {
    const media = /@media \(prefers-color-scheme: dark\)\s*\{\s*:root\s*\{([\s\S]*?)\}\s*\}/.exec(
      CSS,
    );
    assert.ok(media, "no dark media query found");

    const fromMedia: Record<string, string> = {};
    for (const [, name, value] of media[1].matchAll(
      /--([a-z-]+):\s*(#[0-9a-fA-F]{6})\s*;/g,
    )) {
      fromMedia[name] = value;
    }

    const fromAttr = palette("dark");
    for (const [name, value] of Object.entries(fromMedia)) {
      assert.equal(
        fromAttr[name],
        value,
        `--${name} differs between the dark media query and [data-theme="dark"]`,
      );
    }
  });
});
