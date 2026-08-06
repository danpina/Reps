// Deleting a rep has to put the streak back, and a streak cannot be
// un-applied — it depends on the gaps between days and on how many rest days
// each week had left. So it is rebuilt by replaying the days that remain.
//
// These tests exist because the failure mode is silent: a wrong replay does
// not throw, it just quietly awards or removes days, and nobody would notice
// until their streak was a number they could not account for.

import { describe, test } from "node:test";
import assert from "node:assert/strict";

import {
  applyActivity,
  replayStreak,
  type StreakState,
} from "../src/lib/progress/rules.ts";

const fresh: StreakState = {
  current: 0,
  longest: 0,
  lastActiveDate: null,
  restDaysUsedThisWeek: 0,
  weekStartDate: null,
};

describe("replayStreak", () => {
  test("no days at all is a streak of zero", () => {
    const state = replayStreak([]);
    assert.equal(state.current, 0);
    assert.equal(state.longest, 0);
    assert.equal(state.lastActiveDate, null);
  });

  test("matches applying the same days one at a time", () => {
    const days = ["2026-08-03", "2026-08-04", "2026-08-05", "2026-08-06"];

    let expected = fresh;
    for (const day of days) expected = applyActivity(expected, day);

    const replayed = replayStreak(days);

    assert.equal(replayed.current, expected.current);
    assert.equal(replayed.longest, expected.longest);
    assert.equal(replayed.lastActiveDate, expected.lastActiveDate);
    assert.equal(
      replayed.restDaysUsedThisWeek,
      expected.restDaysUsedThisWeek,
    );
  });

  test("two reps on one day are one day of streak", () => {
    const once = replayStreak(["2026-08-03", "2026-08-04"]);
    const twice = replayStreak([
      "2026-08-03",
      "2026-08-03",
      "2026-08-04",
      "2026-08-04",
    ]);

    assert.equal(twice.current, once.current);
    assert.equal(twice.current, 2);
  });

  test("order of the days does not matter", () => {
    const forwards = replayStreak(["2026-08-03", "2026-08-04", "2026-08-05"]);
    const shuffled = replayStreak(["2026-08-05", "2026-08-03", "2026-08-04"]);

    assert.deepEqual(shuffled, forwards);
  });

  // The point of the whole exercise: removing a day from the middle has to
  // produce the streak the user would have had without it, not the streak they
  // had minus one.
  test("deleting the day that bridged a gap shortens the streak", () => {
    const withBridge = replayStreak([
      "2026-08-03",
      "2026-08-04",
      "2026-08-05",
      "2026-08-06",
      "2026-08-07",
    ]);
    assert.equal(withBridge.current, 5);

    // Take out the 5th. Two rest days a week cover a single missed day, so the
    // streak survives — but it is now four days, not five.
    const withoutBridge = replayStreak([
      "2026-08-03",
      "2026-08-04",
      "2026-08-06",
      "2026-08-07",
    ]);
    assert.equal(withoutBridge.current, 4);
    assert.ok(
      withoutBridge.restDaysUsedThisWeek > 0,
      "the missing day should have been covered by a rest day",
    );
  });

  test("deleting enough days breaks a streak that rest days cannot cover", () => {
    const intact = replayStreak([
      "2026-08-03",
      "2026-08-04",
      "2026-08-05",
      "2026-08-06",
      "2026-08-07",
    ]);
    assert.equal(intact.current, 5);

    // Three consecutive days gone is more than two rest days can absorb.
    const broken = replayStreak(["2026-08-03", "2026-08-07"]);
    assert.equal(broken.current, 1, "the streak should have restarted");
  });

  test("longest reflects the reps that still exist", () => {
    const before = replayStreak([
      "2026-08-03",
      "2026-08-04",
      "2026-08-05",
      "2026-08-20",
    ]);
    assert.equal(before.longest, 3);

    // Remove one of the three that made the best run, and the best run is
    // smaller. A record should describe the reps that are actually there.
    const after = replayStreak(["2026-08-03", "2026-08-04", "2026-08-20"]);
    assert.equal(after.longest, 2);
  });
});
