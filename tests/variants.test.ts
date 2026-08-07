// Which version of a lesson someone is shown.
//
// The failure here is silent and expensive: a matcher that is slightly too
// eager shows a man a passage written for women, and nobody reports that —
// they conclude the app does not know what it is talking about and stop
// trusting the rest of it.

import { describe, test } from "node:test";
import assert from "node:assert/strict";

import {
  partnerSexFor,
  pickVariant,
  scoreVariant,
  type Audience,
  type LessonVariant,
} from "../src/lib/curriculum/variants.ts";

const nobody: Audience = { sex: null, ageGroup: null, datingInterest: null };

const manIntoWomen: Audience = {
  sex: "male",
  ageGroup: "25-34",
  datingInterest: "women",
};

const womanIntoMen: Audience = {
  sex: "female",
  ageGroup: "35-44",
  datingInterest: "men",
};

const forMen: LessonVariant = {
  when: { sex: "male", dating_interest: "women" },
  label: "If you are a man",
  note_md: "…",
};

const forWomen: LessonVariant = {
  when: { sex: "female", dating_interest: "men" },
  label: "If you are a woman",
  note_md: "…",
};

const forAnyoneDatingWomen: LessonVariant = {
  when: { dating_interest: "women" },
  label: "If you date women",
  note_md: "…",
};

describe("matching a reader to a variant", () => {
  // The single most important case. The general lesson is correct for
  // everybody, which is why it is the general lesson — so an unanswered
  // question must never be treated as a match.
  test("someone who answered nothing gets the lesson as written", () => {
    assert.equal(pickVariant([forMen, forWomen], nobody), null);
    assert.equal(scoreVariant({ sex: "male" }, nobody), null);
  });

  test("a reader gets their own variant and not the other one", () => {
    assert.equal(pickVariant([forMen, forWomen], manIntoWomen), forMen);
    assert.equal(pickVariant([forMen, forWomen], womanIntoMen), forWomen);
  });

  test("a lesson with no variants renders as written", () => {
    assert.equal(pickVariant([], manIntoWomen), null);
    assert.equal(pickVariant(null, manIntoWomen), null);
    assert.equal(pickVariant(undefined, manIntoWomen), null);
  });

  test("the more specific variant wins", () => {
    const picked = pickVariant(
      [forAnyoneDatingWomen, forMen],
      manIntoWomen,
    );
    assert.equal(picked, forMen, "sex plus interest beats interest alone");
  });

  test("order decides between equally specific variants", () => {
    const a: LessonVariant = { when: { sex: "male" }, label: "A" };
    const b: LessonVariant = { when: { sex: "male" }, label: "B" };
    assert.equal(pickVariant([a, b], manIntoWomen), a);
  });

  // "Both" is genuinely part of the audience for either passage, so it should
  // match one — but an explicitly written "both" variant has to beat it.
  test("someone who dates both matches a single-sex variant weakly", () => {
    const both: Audience = { sex: "male", ageGroup: null, datingInterest: "both" };

    assert.equal(pickVariant([forAnyoneDatingWomen], both), forAnyoneDatingWomen);

    const forBoth: LessonVariant = {
      when: { dating_interest: "both" },
      label: "If you date more than one sex",
    };
    assert.equal(
      pickVariant([forAnyoneDatingWomen, forBoth], both),
      forBoth,
      "an explicit both variant should win over a weak match",
    );
  });

  test("a wrong-sex variant is excluded, not merely outscored", () => {
    assert.equal(scoreVariant({ sex: "female" }, manIntoWomen), null);
    assert.equal(pickVariant([forWomen], manIntoWomen), null);
  });

  test("an empty condition set matches everybody, weakly", () => {
    assert.equal(scoreVariant({}, nobody), 0);
    // Zero is not greater than the starting score, so a variant with no
    // conditions never displaces the lesson as written.
    assert.equal(pickVariant([{ when: {}, label: "Everyone" }], nobody), null);
  });
});

describe("who the rehearsal partner should be", () => {
  test("comes from what the reader said, not from their own sex", () => {
    assert.equal(partnerSexFor(manIntoWomen, undefined), "female");
    assert.equal(partnerSexFor(womanIntoMen, undefined), "male");
  });

  // Inferring it from someone's own sex would be assuming they are straight,
  // and being wrong about that in a dating rehearsal is worse than the scene
  // being generic.
  test("falls back to the authored partner when they have not said", () => {
    const undeclared: Audience = {
      sex: "male",
      ageGroup: null,
      datingInterest: null,
    };
    assert.equal(partnerSexFor(undeclared, "female"), "female");
    assert.equal(partnerSexFor(undeclared, undefined), undefined);
  });

  test("someone who dates both keeps the authored partner", () => {
    const both: Audience = { sex: "female", ageGroup: null, datingInterest: "both" };
    assert.equal(partnerSexFor(both, "male"), "male");
  });
});
