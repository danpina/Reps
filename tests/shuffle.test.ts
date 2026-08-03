import { describe, test } from "node:test";
import assert from "node:assert/strict";

import { shuffle } from "../src/lib/curriculum/shuffle.ts";

describe("shuffle", () => {
  test("keeps every element exactly once", () => {
    const input = ["a", "b", "c", "d", "e"];
    const out = shuffle(input);
    assert.equal(out.length, input.length);
    assert.deepEqual([...out].sort(), [...input].sort());
  });

  test("does not mutate the input", () => {
    const input = ["a", "b", "c", "d"];
    shuffle(input);
    assert.deepEqual(input, ["a", "b", "c", "d"]);
  });

  test("handles empty and single-item arrays", () => {
    assert.deepEqual(shuffle([]), []);
    assert.deepEqual(shuffle(["only"]), ["only"]);
  });

  // The whole point: the correct option must not stay put.
  test("moves the correct answer around across many renders", () => {
    const options = [
      { text: "w", correct: false },
      { text: "correct", correct: true },
      { text: "y", correct: false },
      { text: "z", correct: false },
    ];

    const seen = new Set<number>();
    for (let i = 0; i < 400; i++) {
      seen.add(shuffle(options).findIndex((o) => o.correct));
    }

    assert.deepEqual(
      [...seen].sort(),
      [0, 1, 2, 3],
      "the correct answer should land in every position over many renders",
    );
  });

  test("is uniform enough that no position is a good guess", () => {
    const items = [0, 1, 2, 3];
    const counts = [0, 0, 0, 0];
    const runs = 4000;

    for (let i = 0; i < runs; i++) {
      counts[shuffle(items).indexOf(0)]++;
    }

    // Each position should get roughly a quarter. Generous bounds, since this
    // is guarding against a badly biased shuffle, not testing Math.random.
    for (const [position, count] of counts.entries()) {
      const share = count / runs;
      assert.ok(
        share > 0.18 && share < 0.32,
        `position ${position} came up ${(share * 100).toFixed(1)}% of the time`,
      );
    }
  });
});
