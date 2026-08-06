import { describe, test } from "node:test";
import assert from "node:assert/strict";

import {
  RANKS,
  rankProgress,
  repsToNextRank,
} from "../src/lib/progress/ranks.ts";
import { XP_AWARD } from "../src/lib/progress/rules.ts";

describe("ranks", () => {
  test("the ladder only ever goes up", () => {
    for (let i = 1; i < RANKS.length; i++) {
      assert.ok(
        RANKS[i].at > RANKS[i - 1].at,
        `${RANKS[i].name} starts at or below the rank before it`,
      );
    }
  });

  test("the first rank starts at nothing", () => {
    assert.equal(RANKS[0].at, 0, "a new account must have a rank");
  });

  // The note is rendered as "…to Rarely stuck — where silences stop being
  // emergencies." If one ever arrives capitalised or with a full stop already
  // on it, that sentence breaks in a way nobody would think to test by hand.
  test("notes join onto a sentence rather than being one", () => {
    for (const rank of RANKS) {
      assert.ok(rank.note.trim(), `${rank.name} has no note`);
      assert.ok(
        !/[.!?]$/.test(rank.note),
        `${rank.name}'s note ends with punctuation`,
      );
      assert.equal(
        rank.note[0],
        rank.note[0].toLowerCase(),
        `${rank.name}'s note starts with a capital`,
      );
    }
  });

  test("zero XP is the first rank, not an error", () => {
    const progress = rankProgress(0);
    assert.equal(progress.rank.name, RANKS[0].name);
    assert.equal(progress.position, 1);
    assert.equal(progress.isMax, false);
    assert.equal(progress.fraction, 0);
  });

  test("negative XP cannot happen, and does not break anything if it does", () => {
    const progress = rankProgress(-500);
    assert.equal(progress.position, 1);
    assert.equal(progress.xp, 0);
    assert.ok(progress.fraction >= 0);
  });

  test("landing exactly on a threshold promotes you", () => {
    const second = RANKS[1];
    const progress = rankProgress(second.at);

    assert.equal(progress.rank.name, second.name);
    assert.equal(progress.position, 2);
    assert.equal(progress.fraction, 0, "you are at the start of the new rank");
  });

  test("one XP short of a threshold does not", () => {
    const second = RANKS[1];
    const progress = rankProgress(second.at - 1);

    assert.equal(progress.position, 1);
    assert.equal(progress.toNext, 1);
    assert.ok(progress.fraction > 0.9);
  });

  test("the top rank is the end of the road", () => {
    const top = RANKS[RANKS.length - 1];
    const progress = rankProgress(top.at + 10_000);

    assert.equal(progress.isMax, true);
    assert.equal(progress.next, null);
    assert.equal(progress.toNext, 0);
    assert.equal(progress.fraction, 1, "a maxed bar should read as full");
  });

  test("the fraction stays inside the bar at every rank", () => {
    for (const rank of RANKS) {
      for (const offset of [0, 1, 50]) {
        const { fraction } = rankProgress(rank.at + offset);
        assert.ok(
          fraction >= 0 && fraction <= 1,
          `${rank.name} + ${offset} produced a fraction of ${fraction}`,
        );
      }
    }
  });

  test("remaining XP is reported as whole conversations, rounded up", () => {
    assert.equal(repsToNextRank(0, XP_AWARD.mission), 0);
    assert.equal(repsToNextRank(XP_AWARD.mission, XP_AWARD.mission), 1);
    assert.equal(
      repsToNextRank(XP_AWARD.mission + 1, XP_AWARD.mission),
      2,
      "a part-finished rep still needs another whole conversation",
    );
  });

  // Two logged conversations is the first promotion. That is the whole reason
  // the early gaps are small: the reward for starting has to arrive while
  // someone is still deciding whether this app is worth their time.
  test("the first promotion arrives quickly", () => {
    const afterTwoReps = rankProgress(XP_AWARD.mission * 2);
    assert.ok(
      afterTwoReps.position >= 2,
      "two real conversations should be worth a promotion",
    );
  });
});
