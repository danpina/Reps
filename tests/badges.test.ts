import { describe, test } from "node:test";
import assert from "node:assert/strict";

import {
  isEarned,
  newlyEarned,
  type Badge,
  type ProgressSnapshot,
} from "../src/lib/progress/badges.ts";

const empty: ProgressSnapshot = {
  repsTotal: 0,
  failuresLogged: 0,
  repsBySkillSlug: {},
  distinctSkills: 0,
  longestStreak: 0,
  rewrites: 0,
};

const snapshot = (over: Partial<ProgressSnapshot>): ProgressSnapshot => ({
  ...empty,
  ...over,
});

describe("badge criteria", () => {
  test("reps_total needs the threshold met", () => {
    const c = { type: "reps_total", n: 10 } as const;
    assert.equal(isEarned(c, snapshot({ repsTotal: 9 })), false);
    assert.equal(isEarned(c, snapshot({ repsTotal: 10 })), true);
    assert.equal(isEarned(c, snapshot({ repsTotal: 200 })), true);
  });

  // Honest logging is the thing the whole log depends on, so it gets a badge.
  test("logged_a_failure rewards recording a bad rep", () => {
    const c = { type: "logged_a_failure" } as const;
    assert.equal(isEarned(c, snapshot({ repsTotal: 40 })), false);
    assert.equal(isEarned(c, snapshot({ failuresLogged: 1 })), true);
  });

  test("skill_reps counts only the named skill", () => {
    const c = { type: "skill_reps", slug: "listening-and-labeling", n: 10 } as const;
    assert.equal(isEarned(c, snapshot({ repsBySkillSlug: { openers: 40 } })), false);
    assert.equal(
      isEarned(c, snapshot({ repsBySkillSlug: { "listening-and-labeling": 9 } })),
      false,
    );
    assert.equal(
      isEarned(c, snapshot({ repsBySkillSlug: { "listening-and-labeling": 10 } })),
      true,
    );
  });

  test("distinct_skills needs breadth", () => {
    const c = { type: "distinct_skills", n: 9 } as const;
    assert.equal(isEarned(c, snapshot({ distinctSkills: 8 })), false);
    assert.equal(isEarned(c, snapshot({ distinctSkills: 9 })), true);
  });

  // Longest, not current, so a badge already earned cannot be taken away.
  test("streak uses the longest streak so badges are never revoked", () => {
    const c = { type: "streak", n: 7 } as const;
    assert.equal(isEarned(c, snapshot({ longestStreak: 6 })), false);
    assert.equal(isEarned(c, snapshot({ longestStreak: 7 })), true);
  });

  test("rewrites counts weekly review answers", () => {
    const c = { type: "rewrites", n: 1 } as const;
    assert.equal(isEarned(c, empty), false);
    assert.equal(isEarned(c, snapshot({ rewrites: 1 })), true);
  });

  test("an unknown criterion is never earned rather than throwing", () => {
    const weird = { type: "invented_later", n: 1 } as unknown as never;
    assert.equal(isEarned(weird, snapshot({ repsTotal: 999 })), false);
  });
});

describe("newlyEarned", () => {
  const badge = (slug: string, criteria: Badge["criteria_json"]): Badge => ({
    id: `id-${slug}`,
    slug,
    name: slug,
    description: "",
    criteria_json: criteria,
    sort_order: 1,
  });

  const badges = [
    badge("first-rep", { type: "reps_total", n: 1 }),
    badge("ten-reps", { type: "reps_total", n: 10 }),
    badge("honest", { type: "logged_a_failure" }),
  ];

  test("returns only badges that are earned and not already held", () => {
    const earned = newlyEarned(
      badges,
      snapshot({ repsTotal: 12, failuresLogged: 1 }),
      new Set(["id-first-rep"]),
    );

    assert.deepEqual(
      earned.map((b) => b.slug).sort(),
      ["honest", "ten-reps"],
    );
  });

  test("returns nothing when everything earned is already held", () => {
    const held = new Set(["id-first-rep", "id-ten-reps", "id-honest"]);
    assert.deepEqual(
      newlyEarned(badges, snapshot({ repsTotal: 50, failuresLogged: 3 }), held),
      [],
    );
  });

  test("returns nothing for a user with no progress", () => {
    assert.deepEqual(newlyEarned(badges, empty, new Set()), []);
  });
});
