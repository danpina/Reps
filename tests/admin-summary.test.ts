// The admin screen reports on somebody who is not the one asking, so none of
// it comes through RLS and none of it can be spot-checked by looking at your
// own dashboard. That makes the counting rules worth pinning down here.

import { describe, test } from "node:test";
import assert from "node:assert/strict";

import {
  summariseUser,
  type CurriculumShape,
  type UserRows,
} from "../src/lib/progress/admin-summary.ts";

/** Two topics, two skills each, three lessons each. */
function curriculum(): CurriculumShape {
  const topicOfSkill = new Map<string, string>();
  const skillOfLesson = new Map<string, string>();
  const lessonsPerSkill = new Map<string, number>();

  for (const [topic, skills] of [
    ["t1", ["s1", "s2"]],
    ["t2", ["s3", "s4"]],
  ] as const) {
    for (const skill of skills) {
      topicOfSkill.set(skill, topic);
      lessonsPerSkill.set(skill, 3);
      for (let i = 1; i <= 3; i++) skillOfLesson.set(`${skill}l${i}`, skill);
    }
  }

  return {
    topicOfSkill,
    skillOfLesson,
    topicCount: 2,
    skillCount: 4,
    lessonCount: 12,
    lessonsPerSkill,
  };
}

function rows(over: Partial<UserRows> = {}): UserRows {
  return {
    states: [],
    logs: [],
    readLessonIds: [],
    lastReadDate: null,
    streak: null,
    badgeCount: 0,
    furthest: null,
    ...over,
  };
}

describe("summarising somebody else's standing", () => {
  test("an account with nothing on it still carries the denominators", () => {
    const s = summariseUser(curriculum(), rows());

    assert.equal(s.isUntouched, true);
    assert.equal(s.topicsStarted, 0);
    assert.equal(s.topicsTotal, 2);
    assert.equal(s.skillsTotal, 4);
    assert.equal(s.lessonsTotal, 12);
    assert.equal(s.lastActive, null);
    assert.equal(s.rank.position, 1);
  });

  test("xp adds up across skills and decides the rank", () => {
    const s = summariseUser(
      curriculum(),
      rows({ states: [{ skill_id: "s1", xp: 120 }, { skill_id: "s2", xp: 80 }] }),
    );

    assert.equal(s.totalXp, 200);
    assert.equal(s.rank.xp, 200);
    // 150 is the second rank's floor, so 200 is past it.
    assert.ok(s.rank.position >= 2);
  });

  // The distinction the whole product rests on: reading is the cheap half.
  test("reading a lesson starts a skill but does not work it", () => {
    const s = summariseUser(curriculum(), rows({ readLessonIds: ["s1l1"] }));

    assert.equal(s.skillsStarted, 1);
    assert.equal(s.skillsWorked, 0);
    assert.equal(s.repsLogged, 0);
    assert.equal(s.isUntouched, false);
  });

  test("a rep works a skill even with nothing read", () => {
    const s = summariseUser(
      curriculum(),
      rows({ logs: [{ skill_id: "s1", logged_date: "2026-08-01" }] }),
    );

    assert.equal(s.skillsWorked, 1);
    assert.equal(s.skillsStarted, 1);
    assert.equal(s.lessonsRead, 0);
  });

  test("a skill is finished only when every lesson is read", () => {
    const partly = summariseUser(
      curriculum(),
      rows({ readLessonIds: ["s1l1", "s1l2"] }),
    );
    assert.equal(partly.skillsFinished, 0);

    const all = summariseUser(
      curriculum(),
      rows({ readLessonIds: ["s1l1", "s1l2", "s1l3"] }),
    );
    assert.equal(all.skillsFinished, 1);
  });

  test("topics count once however many of their skills are open", () => {
    const s = summariseUser(
      curriculum(),
      rows({
        logs: [
          { skill_id: "s1", logged_date: "2026-08-01" },
          { skill_id: "s2", logged_date: "2026-08-02" },
        ],
      }),
    );

    assert.equal(s.skillsStarted, 2);
    assert.equal(s.topicsStarted, 1);
  });

  test("both topics count when the skills are in different ones", () => {
    const s = summariseUser(
      curriculum(),
      rows({ readLessonIds: ["s1l1", "s3l1"] }),
    );

    assert.equal(s.topicsStarted, 2);
  });

  // A lesson deleted by a migration leaves its session row behind, and counting
  // it would report more lessons read than the curriculum contains.
  test("a read lesson that no longer exists is not counted", () => {
    const s = summariseUser(
      curriculum(),
      rows({ readLessonIds: ["s1l1", "deleted-lesson"] }),
    );

    assert.equal(s.lessonsRead, 1);
    assert.equal(s.skillsStarted, 1);
  });

  test("reads are counted once per lesson, not once per session", () => {
    // The caller passes session rows, and somebody can open the same card
    // twice. Two rows for one lesson must not read as two lessons.
    const s = summariseUser(
      curriculum(),
      rows({ readLessonIds: ["s1l1", "s1l1", "s1l2"] }),
    );

    assert.equal(s.lessonsRead, 2);
  });

  test("last active takes the later of the rep and the streak", () => {
    const streakAhead = summariseUser(
      curriculum(),
      rows({
        logs: [{ skill_id: "s1", logged_date: "2026-08-01" }],
        streak: { current: 3, longest: 9, last_active_date: "2026-08-05" },
      }),
    );
    assert.equal(streakAhead.lastActive, "2026-08-05");

    const repAhead = summariseUser(
      curriculum(),
      rows({
        logs: [
          { skill_id: "s1", logged_date: "2026-08-09" },
          { skill_id: "s1", logged_date: "2026-08-02" },
        ],
        streak: { current: 1, longest: 9, last_active_date: "2026-08-05" },
      }),
    );
    assert.equal(repAhead.lastActive, "2026-08-09");
  });

  // Somebody can read for a fortnight without logging a rep or building a
  // streak. Reporting that account as never active is wrong in the direction
  // that matters, because it is the account you look at to decide whether the
  // thing is being used at all.
  test("reading counts as being active", () => {
    const s = summariseUser(
      curriculum(),
      rows({ readLessonIds: ["s1l1"], lastReadDate: "2026-08-07" }),
    );

    assert.equal(s.lastActive, "2026-08-07");
    assert.equal(s.repsLogged, 0);
  });

  test("the latest of the three wins, whichever it is", () => {
    const readAhead = summariseUser(
      curriculum(),
      rows({
        logs: [{ skill_id: "s1", logged_date: "2026-08-01" }],
        lastReadDate: "2026-08-11",
        streak: { current: 1, longest: 3, last_active_date: "2026-08-04" },
      }),
    );
    assert.equal(readAhead.lastActive, "2026-08-11");

    const repStillAhead = summariseUser(
      curriculum(),
      rows({
        logs: [{ skill_id: "s1", logged_date: "2026-08-20" }],
        lastReadDate: "2026-08-11",
        streak: { current: 1, longest: 3, last_active_date: "2026-08-04" },
      }),
    );
    assert.equal(repStillAhead.lastActive, "2026-08-20");
  });

  test("streak numbers come through, and default to zero without a row", () => {
    const none = summariseUser(curriculum(), rows());
    assert.equal(none.currentStreak, 0);
    assert.equal(none.longestStreak, 0);

    const some = summariseUser(
      curriculum(),
      rows({ streak: { current: 4, longest: 11, last_active_date: null } }),
    );
    assert.equal(some.currentStreak, 4);
    assert.equal(some.longestStreak, 11);
  });

  test("xp alone counts as touched, so a rewrite does not read as nothing", () => {
    const s = summariseUser(
      curriculum(),
      rows({ states: [{ skill_id: "s1", xp: 10 }] }),
    );

    assert.equal(s.isUntouched, false);
  });
});
