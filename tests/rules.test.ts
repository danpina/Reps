import { describe, test } from "node:test";
import assert from "node:assert/strict";

import {
  LEVEL_THRESHOLDS,
  MAX_LEVEL,
  REST_DAYS_PER_WEEK,
  XP_AWARD,
  applyActivity,
  daysBetween,
  levelForXp,
  levelProgress,
  toIsoDate,
  weekStart,
  type StreakState,
} from "../src/lib/progress/rules.ts";

describe("XP economy", () => {
  // The brief's central product decision: real conversations must dominate.
  test("a field mission outweighs in-app activity by a wide margin", () => {
    assert.ok(
      XP_AWARD.mission > XP_AWARD.roleplay * 3,
      "a mission should be worth more than three roleplays",
    );
    assert.ok(
      XP_AWARD.mission >= XP_AWARD.theory * 10,
      "a mission should be worth at least ten theory cards",
    );
  });

  test("you cannot max a skill without leaving the house", () => {
    const capstone = LEVEL_THRESHOLDS[MAX_LEVEL - 1];
    const everyLessonRead = 6 * XP_AWARD.theory;
    const everyRoleplayDone = 6 * XP_AWARD.roleplay;

    assert.ok(
      everyLessonRead + everyRoleplayDone < capstone,
      "reading and rehearsing everything must not be enough to reach level 10",
    );
  });

  // Reflecting on a conversation must never be worth as much as having one.
  test("a rewrite is worth far less than the rep it reflects on", () => {
    assert.ok(
      XP_AWARD.rewrite < XP_AWARD.mission / 4,
      "a weekly review answer should not approach the value of a logged rep",
    );
    assert.ok(
      XP_AWARD.rewrite > XP_AWARD.theory,
      "writing a better line is worth more than reading a card",
    );
  });
});

describe("levels", () => {
  test("starts at level 1 with no XP", () => {
    assert.equal(levelForXp(0), 1);
  });

  test("levels up exactly on each threshold", () => {
    LEVEL_THRESHOLDS.forEach((threshold, i) => {
      assert.equal(levelForXp(threshold), i + 1, `at ${threshold} XP`);
      if (threshold > 0) {
        assert.equal(levelForXp(threshold - 1), i, `just below ${threshold} XP`);
      }
    });
  });

  test("two logged missions reach level 2", () => {
    assert.equal(levelForXp(XP_AWARD.mission * 2), 2);
  });

  test("caps at level 10 and does not overflow", () => {
    assert.equal(levelForXp(2700), MAX_LEVEL);
    assert.equal(levelForXp(999_999), MAX_LEVEL);
  });

  test("progress within a level is proportional", () => {
    const p = levelProgress(175); // level 2 spans 100..250
    assert.equal(p.level, 2);
    assert.equal(p.earnedThisLevel, 75);
    assert.equal(p.levelSpan, 150);
    assert.equal(p.toNextLevel, 75);
    assert.equal(p.fraction, 0.5);
    assert.equal(p.isMax, false);
  });

  test("max level reads as complete rather than stuck", () => {
    const p = levelProgress(5000);
    assert.equal(p.isMax, true);
    assert.equal(p.fraction, 1);
    assert.equal(p.toNextLevel, 0);
  });

  test("fraction always stays within 0 and 1", () => {
    for (let xp = 0; xp <= 3000; xp += 7) {
      const { fraction } = levelProgress(xp);
      assert.ok(fraction >= 0 && fraction <= 1, `fraction ${fraction} at ${xp} XP`);
    }
  });
});

describe("date helpers", () => {
  // The bug this guards against: a rep logged at 00:00 local is 22:00 UTC the
  // previous day. Deriving the calendar day from a UTC timestamp put it in the
  // wrong bucket on a UTC host, so the heatmap and the field log's day
  // headings disagreed between a laptop and production.
  test("toIsoDate uses local calendar fields, not UTC", () => {
    const justAfterMidnight = new Date(2026, 7, 4, 0, 0, 1);
    assert.equal(toIsoDate(justAfterMidnight), "2026-08-04");

    const justBeforeMidnight = new Date(2026, 7, 4, 23, 59, 59);
    assert.equal(toIsoDate(justBeforeMidnight), "2026-08-04");
  });

  test("a day is one day regardless of the time within it", () => {
    const early = toIsoDate(new Date(2026, 7, 4, 0, 30));
    const late = toIsoDate(new Date(2026, 7, 4, 23, 30));
    assert.equal(daysBetween(early, late), 0, "same day, whatever the hour");
  });

  test("counts days across a month boundary", () => {
    assert.equal(daysBetween("2026-01-31", "2026-02-01"), 1);
    assert.equal(daysBetween("2026-02-28", "2026-03-01"), 1); // 2026 is not a leap year
    assert.equal(daysBetween("2026-08-03", "2026-08-03"), 0);
  });

  test("weeks start on Monday", () => {
    assert.equal(weekStart("2026-08-03"), "2026-08-03"); // a Monday
    assert.equal(weekStart("2026-08-09"), "2026-08-03"); // the Sunday after
    assert.equal(weekStart("2026-08-10"), "2026-08-10"); // next Monday
  });
});

describe("streaks", () => {
  const fresh: StreakState = {
    current: 0,
    longest: 0,
    lastActiveDate: null,
    restDaysUsedThisWeek: 0,
    weekStartDate: null,
  };

  test("the first rep starts a streak of one", () => {
    const out = applyActivity(fresh, "2026-08-03");
    assert.equal(out.current, 1);
    assert.equal(out.longest, 1);
    assert.equal(out.broke, false);
  });

  test("consecutive days extend the streak", () => {
    let state: StreakState = fresh;
    for (const day of ["2026-08-03", "2026-08-04", "2026-08-05"]) {
      state = applyActivity(state, day);
    }
    assert.equal(state.current, 3);
    assert.equal(state.longest, 3);
  });

  test("logging twice in a day does not double count", () => {
    const first = applyActivity(fresh, "2026-08-03");
    const second = applyActivity(first, "2026-08-03");
    assert.equal(second.current, 1);
    assert.equal(second.advanced, false);
  });

  // The safety valve. One missed day must never end a streak.
  test("a single missed day is covered by a rest day", () => {
    const monday = applyActivity(fresh, "2026-08-03");
    const wednesday = applyActivity(monday, "2026-08-05");

    assert.equal(wednesday.broke, false, "one missed day must not break a streak");
    assert.equal(wednesday.current, 2);
    assert.equal(wednesday.restDaysSpent, 1);
    assert.equal(wednesday.restDaysUsedThisWeek, 1);
  });

  test("two missed days in one week are still covered", () => {
    const monday = applyActivity(fresh, "2026-08-03");
    const thursday = applyActivity(monday, "2026-08-06");

    assert.equal(thursday.broke, false);
    assert.equal(thursday.current, 2);
    assert.equal(thursday.restDaysUsedThisWeek, REST_DAYS_PER_WEEK);
  });

  test("a third missed day in the same week breaks the streak", () => {
    const monday = applyActivity(fresh, "2026-08-03");
    const friday = applyActivity(monday, "2026-08-07");

    assert.equal(friday.broke, true);
    assert.equal(friday.current, 1);
  });

  test("rest days replenish in a new week", () => {
    // Mon 3rd, then Thu 6th spending both rest days, then Fri 7th.
    let state = applyActivity(fresh, "2026-08-03");
    state = applyActivity(state, "2026-08-06");
    state = applyActivity(state, "2026-08-07");
    assert.equal(state.restDaysUsedThisWeek, 2, "allowance spent for that week");
    assert.equal(state.current, 3);

    // Mon 10th starts a new week. The two-day gap from Friday would break the
    // streak if the allowance had not reset, so this is the replenishment.
    const nextWeek = applyActivity(state, "2026-08-10");
    assert.equal(nextWeek.broke, false, "rest days should reset weekly");
    assert.equal(nextWeek.current, 4);
    assert.equal(nextWeek.restDaysSpent, 2);
    assert.equal(nextWeek.restDaysUsedThisWeek, 2);
  });

  test("a gap larger than the weekly allowance still breaks", () => {
    const state = applyActivity(fresh, "2026-08-03");
    // Four missed days cannot be covered by two rest days, even in a new week.
    const later = applyActivity(state, "2026-08-11");
    assert.equal(later.broke, true);
    assert.equal(later.current, 1);
  });

  test("longest is remembered after a break", () => {
    let state = applyActivity(fresh, "2026-08-03");
    state = applyActivity(state, "2026-08-04");
    state = applyActivity(state, "2026-08-05");
    assert.equal(state.longest, 3);

    const afterGap = applyActivity(state, "2026-08-20");
    assert.equal(afterGap.broke, true);
    assert.equal(afterGap.current, 1);
    assert.equal(afterGap.longest, 3, "longest should survive a broken streak");
  });

  test("a long absence restarts at one rather than zero", () => {
    const state = applyActivity(fresh, "2026-01-01");
    const muchLater = applyActivity(state, "2026-08-03");
    assert.equal(muchLater.current, 1, "today's rep still counts");
  });
});
