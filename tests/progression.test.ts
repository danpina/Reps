// Working through in order.
//
// The rule that matters most is the one that never takes anything away:
// anybody who read out of order before this gate existed keeps everything they
// had. A gate that confiscates access to something already seen is a bug
// wearing a feature's clothes, and it would look exactly like working code.

import { describe, test } from "node:test";
import assert from "node:assert/strict";

import {
  firstLockedLesson,
  isLessonUnlocked,
  isSkillComplete,
  isSkillUnlocked,
  nextOpenLesson,
} from "../src/lib/curriculum/progression.ts";

const lessons = [
  { id: "l1" },
  { id: "l2" },
  { id: "l3" },
  { id: "l4" },
  { id: "l5" },
];

const skills = [
  { id: "s1", lessons: [{ id: "a1" }, { id: "a2" }] },
  { id: "s2", lessons: [{ id: "b1" }, { id: "b2" }] },
  { id: "s3", lessons: [{ id: "c1" }, { id: "c2" }] },
];

describe("lessons unlock forwards", () => {
  test("the first is always open", () => {
    assert.equal(isLessonUnlocked(lessons, 0, new Set()), true);
  });

  test("the second is not, until the first is read", () => {
    assert.equal(isLessonUnlocked(lessons, 1, new Set()), false);
    assert.equal(isLessonUnlocked(lessons, 1, new Set(["l1"])), true);
  });

  test("reading one opens exactly one more", () => {
    const read = new Set(["l1", "l2"]);
    assert.equal(isLessonUnlocked(lessons, 2, read), true);
    assert.equal(isLessonUnlocked(lessons, 3, read), false);
  });

  // Nobody loses access to something they have already opened.
  test("a lesson already read stays open even with a gap behind it", () => {
    const read = new Set(["l4"]);
    assert.equal(isLessonUnlocked(lessons, 3, read), true, "l4 was read");
    assert.equal(isLessonUnlocked(lessons, 4, read), true, "and so l5 follows");
    assert.equal(isLessonUnlocked(lessons, 2, read), false, "l3 was skipped");
  });

  test("reading everything opens everything", () => {
    const read = new Set(lessons.map((l) => l.id));
    for (let i = 0; i < lessons.length; i++) {
      assert.equal(isLessonUnlocked(lessons, i, read), true);
    }
    assert.equal(firstLockedLesson(lessons, read), null);
  });

  // Two read means three are open: the two that were read, plus the one their
  // reading unlocked. So the first closed door is the fourth.
  test("the first locked lesson is one past the frontier", () => {
    assert.equal(firstLockedLesson(lessons, new Set()), 1);
    assert.equal(firstLockedLesson(lessons, new Set(["l1", "l2"])), 3);
  });
});

describe("skills unlock forwards", () => {
  test("the first skill in a topic is always open", () => {
    assert.equal(isSkillUnlocked(skills, 0, new Set()), true);
  });

  test("the next needs the previous finished, not merely started", () => {
    assert.equal(isSkillUnlocked(skills, 1, new Set(["a1"])), false);
    assert.equal(isSkillUnlocked(skills, 1, new Set(["a1", "a2"])), true);
  });

  test("finishing one skill does not open the one after next", () => {
    const read = new Set(["a1", "a2"]);
    assert.equal(isSkillUnlocked(skills, 1, read), true);
    assert.equal(isSkillUnlocked(skills, 2, read), false);
  });

  test("a skill already started stays open", () => {
    // Someone who got into skill three before the gate existed keeps it.
    assert.equal(isSkillUnlocked(skills, 2, new Set(["c1"])), true);
  });

  test("an empty skill is never complete, so it cannot gate by accident", () => {
    assert.equal(isSkillComplete({ id: "x", lessons: [] }, new Set()), false);
  });
});

describe("where to send someone who landed somewhere locked", () => {
  test("the first unread lesson that is actually open", () => {
    assert.equal(nextOpenLesson(lessons, new Set()), 0);
    assert.equal(nextOpenLesson(lessons, new Set(["l1", "l2"])), 2);
  });

  test("with everything read, it falls back to the start rather than nowhere", () => {
    const read = new Set(lessons.map((l) => l.id));
    assert.equal(nextOpenLesson(lessons, read), 0);
  });
});
