import { describe, test } from "node:test";
import assert from "node:assert/strict";

import { FACTS, randomFact } from "../src/lib/facts.ts";

describe("facts", () => {
  test("there are more than thirty", () => {
    assert.ok(FACTS.length > 30, `only ${FACTS.length}`);
  });

  test("none are duplicated", () => {
    const texts = FACTS.map((f) => f.text);
    assert.equal(new Set(texts).size, texts.length);
  });

  test("every area of life is represented", () => {
    const areas = new Set(FACTS.map((f) => f.area));
    for (const area of ["work", "friendship", "dating", "health", "luck", "confidence"]) {
      assert.ok(areas.has(area as never), `nothing about ${area}`);
    }
  });

  test("each area has at least three", () => {
    const counts = new Map<string, number>();
    for (const fact of FACTS) {
      counts.set(fact.area, (counts.get(fact.area) ?? 0) + 1);
    }
    for (const [area, count] of counts) {
      assert.ok(count >= 3, `${area} only has ${count}`);
    }
  });

  test("each is short enough to read on the way past", () => {
    for (const fact of FACTS) {
      assert.ok(fact.text.length <= 190, `too long: ${fact.text.slice(0, 50)}…`);
      assert.ok(fact.text.length > 30, `too thin: ${fact.text}`);
    }
  });

  // An invented statistic is worse than an honest sentence, and impossible for
  // a reader to check. Claims that lean on research are stated qualitatively.
  test("none invent a statistic", () => {
    for (const fact of FACTS) {
      assert.ok(
        !/\d+\s*(%|per cent|percent)/i.test(fact.text),
        `contains a percentage: ${fact.text}`,
      );
      assert.ok(
        !/\b(studies show|research proves|scientists say)\b/i.test(fact.text),
        `appeals to vague authority: ${fact.text}`,
      );
    }
  });

  test("each ends as a proper sentence", () => {
    for (const fact of FACTS) {
      assert.match(fact.text.trim(), /[.!?]$/, fact.text);
    }
  });
});

describe("randomFact", () => {
  test("returns the first fact at the bottom of the range", () => {
    assert.equal(randomFact(() => 0), FACTS[0]);
  });

  test("never runs off the end of the array", () => {
    assert.equal(randomFact(() => 0.999999), FACTS[FACTS.length - 1]);
  });

  // Sampled at the middle of each bucket rather than the edge: i/N multiplied
  // back by N can land a hair under the integer and fall into the bucket below.
  test("reaches every fact eventually", () => {
    const seen = new Set<string>();
    for (let i = 0; i < FACTS.length; i++) {
      seen.add(randomFact(() => (i + 0.5) / FACTS.length).text);
    }
    assert.equal(seen.size, FACTS.length, "some fact is unreachable");
  });
});
