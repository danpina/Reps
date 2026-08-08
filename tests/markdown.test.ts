// Paragraph splitting, and the shipped content it has to survive.
//
// The failure this guards against is silent by construction: a split that does
// not match returns one enormous paragraph, nothing throws, and the result
// reads as bad writing rather than as a bug. Every theory card in the app was
// rendering that way, because the seed migrations carry Windows line endings
// and the old regex only recognised "\n\n".

import { describe, test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

import { toParagraphs } from "../src/lib/markdown.ts";

describe("splitting authored prose into paragraphs", () => {
  test("blank lines separate paragraphs", () => {
    assert.deepEqual(toParagraphs("One.\n\nTwo.\n\nThree."), [
      "One.",
      "Two.",
      "Three.",
    ]);
  });

  test("Windows line endings split exactly the same way", () => {
    assert.deepEqual(toParagraphs("One.\r\n\r\nTwo."), ["One.", "Two."]);
  });

  test("old Mac line endings too", () => {
    assert.deepEqual(toParagraphs("One.\r\rTwo."), ["One.", "Two."]);
  });

  test("a single newline inside a paragraph is a wrap, not a break", () => {
    assert.deepEqual(toParagraphs("A sentence\nthat wrapped."), [
      "A sentence that wrapped.",
    ]);
    assert.deepEqual(toParagraphs("A sentence\r\nthat wrapped."), [
      "A sentence that wrapped.",
    ]);
  });

  test("more than one blank line is still one break", () => {
    assert.deepEqual(toParagraphs("One.\n\n\n\nTwo."), ["One.", "Two."]);
  });

  test("surrounding whitespace never becomes an empty paragraph", () => {
    assert.deepEqual(toParagraphs("\n\n  One.  \n\n"), ["One."]);
    assert.deepEqual(toParagraphs(""), []);
    assert.deepEqual(toParagraphs("   \n  \n "), []);
  });
});

const MIGRATIONS = join(import.meta.dirname, "..", "supabase", "migrations");

/** Every dollar-quoted markdown block the seed migrations write. */
function authoredProse(): { file: string; body: string }[] {
  const blocks: { file: string; body: string }[] = [];

  for (const file of readdirSync(MIGRATIONS).filter((f) => f.endsWith(".sql"))) {
    const sql = readFileSync(join(MIGRATIONS, file), "utf8");
    for (const match of sql.matchAll(/\$md\$([\s\S]*?)\$md\$/g)) {
      blocks.push({ file, body: match[1] });
    }
  }

  return blocks;
}

describe("the prose the curriculum ships", () => {
  const blocks = authoredProse();

  test("there is some to check", () => {
    assert.ok(blocks.length > 40, `only found ${blocks.length} authored blocks`);
  });

  test("anything written as multiple paragraphs renders as multiple", () => {
    // The real assertion: whatever line endings a migration was saved with,
    // a block whose author left a blank line in it must come out as more than
    // one paragraph.
    for (const { file, body } of blocks) {
      const looksMultiParagraph = /(\r\n|\r|\n)\s*(\r\n|\r|\n)/.test(body.trim());
      if (!looksMultiParagraph) continue;

      assert.ok(
        toParagraphs(body).length > 1,
        `${file}: a multi-paragraph block collapsed into one`,
      );
    }
  });

  test("no paragraph is long enough to be a collapsed card", () => {
    // A backstop for the same failure arriving another way. The longest real
    // paragraph in the curriculum is a few hundred characters; a theory card
    // that lost its breaks is several thousand.
    for (const { file, body } of blocks) {
      for (const paragraph of toParagraphs(body)) {
        assert.ok(
          paragraph.length < 1200,
          `${file}: a ${paragraph.length}-character paragraph, which is almost certainly a collapsed card`,
        );
      }
    }
  });
});
