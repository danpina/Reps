// The rehearsal shows the lesson's own instruction so the drill has a stated
// target. That only works if every lesson actually carries one.

import { describe, test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

import { extractTheMove } from "../src/lib/curriculum/the-move.ts";

const MIGRATIONS = join(import.meta.dirname, "..", "supabase", "migrations");

function allTheoryCards(): { file: string; theory: string }[] {
  const out: { file: string; theory: string }[] = [];
  for (const file of readdirSync(MIGRATIONS).filter((f) =>
    f.includes("seed_lessons_"),
  )) {
    const sql = readFileSync(join(MIGRATIONS, file), "utf8");
    for (const [, block] of sql.matchAll(/\$md\$([\s\S]*?)\$md\$/g)) {
      // Theory cards are the long blocks; missions are short single lines.
      if (block.includes("**The move:**") || block.length > 400) {
        out.push({ file, theory: block });
      }
    }
  }
  return out;
}

describe("extractTheMove", () => {
  test("pulls the instruction out of a card", () => {
    const theory = `Some framing.\n\n**The move:** name something you are both in, say it plainly, then stop.\n\nMore text.`;
    assert.equal(
      extractTheMove(theory, "Fallback"),
      "Name something you are both in, say it plainly, then stop.",
    );
  });

  test("strips stray emphasis markers", () => {
    const theory = `**The move:** notice which **room** you are in.`;
    assert.equal(extractTheMove(theory, "Fallback"), "Notice which room you are in.");
  });

  // A lesson written later without the marker should degrade, not break the
  // rehearsal.
  test("falls back to the title when there is no move", () => {
    assert.equal(extractTheMove("No marker here at all.", "Exits"), "Exits");
    assert.equal(extractTheMove("", "Exits"), "Exits");
    assert.equal(extractTheMove("**The move:**   ", "Exits"), "Exits");
  });

  test("takes only the first line", () => {
    const theory = `**The move:** do the thing.\nThis paragraph is not part of it.`;
    assert.equal(extractTheMove(theory, "x"), "Do the thing.");
  });
});

describe("the curriculum states its moves", () => {
  const cards = allTheoryCards();

  test("there are theory cards to check", () => {
    assert.ok(cards.length >= 45, `only found ${cards.length}`);
  });

  test("every theory card states a move", () => {
    for (const { file, theory } of cards) {
      assert.ok(
        theory.includes("**The move:**"),
        `${file}: a card has no stated move: ${theory.slice(0, 60)}…`,
      );
    }
  });

  test("every extracted move reads as a usable instruction", () => {
    for (const { file, theory } of cards) {
      const move = extractTheMove(theory, "FALLBACK");
      assert.notEqual(move, "FALLBACK", `${file}: fell back`);
      assert.ok(move.length > 15, `${file}: move too thin: "${move}"`);
      assert.match(move, /^[A-Z]/, `${file}: not capitalised: "${move}"`);
    }
  });
});
