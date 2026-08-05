import { describe, test } from "node:test";
import assert from "node:assert/strict";

import {
  REPS_TO_THEORY_RATIO,
  XP_TABLE,
  describeNextLevel,
  repsToNextLevel,
} from "../src/lib/progress/explain.ts";
import { XP_AWARD, levelProgress } from "../src/lib/progress/rules.ts";

describe("progress in reps rather than points", () => {
  test("a fresh user is two reps from level 2", () => {
    // Level 2 sits at 100 XP, and a logged rep is 50.
    assert.equal(repsToNextLevel(levelProgress(0)), 2);
    assert.equal(describeNextLevel(levelProgress(0)), "2 more reps to level 2");
  });

  test("one rep in, one to go", () => {
    assert.equal(describeNextLevel(levelProgress(50)), "1 more rep to level 2");
  });

  // Rounding down would say "0 more reps" while the bar is not full, which
  // reads as broken.
  test("a part-finished rep still counts as one more", () => {
    const almost = levelProgress(99);
    assert.equal(repsToNextLevel(almost), 1);
    assert.match(describeNextLevel(almost), /1 more rep\b/);
  });

  test("singular and plural are both handled", () => {
    assert.match(describeNextLevel(levelProgress(50)), /^1 more rep to/);
    assert.match(describeNextLevel(levelProgress(0)), /^2 more reps to/);
  });

  test("the top of a skill says so rather than showing a gap", () => {
    const maxed = levelProgress(3000);
    assert.equal(repsToNextLevel(maxed), 0);
    assert.match(describeNextLevel(maxed), /top of this skill/);
  });

  test("never promises a level above the cap", () => {
    for (let xp = 0; xp <= 3000; xp += 25) {
      const progress = levelProgress(xp);
      const phrase = describeNextLevel(progress);
      assert.ok(!phrase.includes("level 11"), `at ${xp} XP: ${phrase}`);
    }
  });
});

describe("the XP table", () => {
  test("lists every way of earning, highest first", () => {
    const values = XP_TABLE.map((row) => row.xp);
    assert.deepEqual(values, [...values].sort((a, b) => b - a));
  });

  test("stays in step with the economy itself", () => {
    const listed = new Set(XP_TABLE.map((row) => row.xp));
    for (const award of Object.values(XP_AWARD)) {
      assert.ok(listed.has(award), `${award} XP is earnable but not explained`);
    }
  });

  // The point of showing the table at all.
  test("a real conversation is plainly the most valuable row", () => {
    const top = XP_TABLE[0];
    assert.equal(top.xp, XP_AWARD.mission);
    assert.match(top.label, /real conversation/i);
    assert.ok(top.xp >= XP_TABLE[1].xp * 3);
  });

  test("says a logged rep is worth ten theory cards", () => {
    assert.equal(REPS_TO_THEORY_RATIO, 10);
  });
});
