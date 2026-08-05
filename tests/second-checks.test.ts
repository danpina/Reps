// The second comprehension beat on each lesson. These live in their own
// migrations rather than in the seed files, so they need their own validation.

import { describe, test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const MIGRATIONS = join(import.meta.dirname, "..", "supabase", "migrations");

type Option = { text: string; correct: boolean; note: string };
type Check = { prompt: string; options: Option[]; explain: string };

const files = readdirSync(MIGRATIONS).filter((f) => f.includes("second_checks_"));

function checksIn(file: string): { skill: string; order: number; check: Check }[] {
  const sql = readFileSync(join(MIGRATIONS, file), "utf8");
  const out: { skill: string; order: number; check: Check }[] = [];

  const pattern =
    /add_check\('([a-z-]+)',\s*(\d+),\s*\$j\$([\s\S]*?)\$j\$::jsonb\)/g;

  for (const [, skill, order, raw] of sql.matchAll(pattern)) {
    let check: Check;
    try {
      check = JSON.parse(raw);
    } catch (err) {
      assert.fail(`${file} ${skill} ${order}: invalid JSON — ${(err as Error).message}`);
    }
    out.push({ skill, order: Number(order), check });
  }

  return out;
}

const all = files.flatMap(checksIn);

describe("second comprehension beats", () => {
  test("there is one for every lesson", () => {
    assert.equal(all.length, 45, `found ${all.length}`);
  });

  test("every skill and lesson is covered exactly once", () => {
    const seen = new Map<string, number>();
    for (const { skill, order } of all) {
      const key = `${skill}:${order}`;
      seen.set(key, (seen.get(key) ?? 0) + 1);
    }

    for (const [key, count] of seen) {
      assert.equal(count, 1, `${key} has ${count} second checks`);
    }
    assert.equal(seen.size, 45);

    for (const skill of [
      "openers",
      "going-deeper",
      "listening-and-labeling",
      "reciprocity",
      "banter",
      "flirting-calibration",
      "reading-disinterest",
      "groups",
      "exits",
    ]) {
      for (let order = 1; order <= 5; order++) {
        assert.ok(seen.has(`${skill}:${order}`), `missing ${skill} ${order}`);
      }
    }
  });

  test("each has exactly one correct answer", () => {
    for (const { skill, order, check } of all) {
      const correct = check.options.filter((o) => o.correct);
      assert.equal(
        correct.length,
        1,
        `${skill} ${order}: ${correct.length} correct answers`,
      );
    }
  });

  test("every option carries a note, and every check an explain", () => {
    for (const { skill, order, check } of all) {
      assert.ok(check.prompt?.trim(), `${skill} ${order}: no prompt`);
      assert.ok(check.explain?.trim(), `${skill} ${order}: no explain`);
      assert.ok(check.options.length >= 3, `${skill} ${order}: too few options`);
      for (const option of check.options) {
        assert.ok(option.text?.trim(), `${skill} ${order}: option with no text`);
        assert.ok(
          option.note?.trim(),
          `${skill} ${order}: "${option.text}" has no note`,
        );
      }
    }
  });

  // The same guard the first checks have: an answer parked in the same slot
  // every time is learnable without learning anything.
  test("correct answers are spread across the positions", () => {
    const positions = all.map(({ check }) =>
      check.options.findIndex((o) => o.correct),
    );

    const counts = new Map<number, number>();
    for (const p of positions) counts.set(p, (counts.get(p) ?? 0) + 1);

    assert.ok(counts.size >= 3, "answers sit in fewer than three positions");

    const commonest = Math.max(...counts.values());
    assert.ok(
      commonest <= Math.ceil(positions.length * 0.45),
      `${commonest} of ${positions.length} answers share one position`,
    );
  });

  test("the second check is not a copy of a first one", () => {
    const seedPrompts = new Set<string>();
    for (const file of readdirSync(MIGRATIONS).filter((f) =>
      f.includes("seed_lessons_"),
    )) {
      const sql = readFileSync(join(MIGRATIONS, file), "utf8");
      for (const [, raw] of sql.matchAll(/\$j\$([\s\S]*?)\$j\$/g)) {
        try {
          const parsed = JSON.parse(raw);
          if (parsed?.prompt) seedPrompts.add(parsed.prompt.trim());
        } catch {
          /* other blocks are validated elsewhere */
        }
      }
    }

    for (const { skill, order, check } of all) {
      assert.ok(
        !seedPrompts.has(check.prompt.trim()),
        `${skill} ${order} repeats a first-check prompt`,
      );
    }
  });
});
