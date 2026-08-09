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
  scenarioFor,
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

describe("putting the right person in the scene", () => {
  const scene = {
    setting: "A party.",
    opening_beat: "She looks up.",
    success_looks_like: "It goes somewhere.",
    constraints: [],
    partner: {
      name: "Wren",
      role: "a friend of the birthday person",
      personality: "Warm and engaged. Mirrors the register she is given.",
      mood: "Enjoying herself.",
      openness: 4,
      sex: "female" as const,
      alt: {
        name: "Wren",
        role: "a friend of the birthday person",
        personality: "Warm and engaged. Mirrors the register he is given.",
        mood: "Enjoying himself.",
        openness: 4,
        sex: "male" as const,
      },
    },
  };

  test("a reader who dates men gets the man", () => {
    const out = scenarioFor(scene, womanIntoMen);
    assert.equal(out.partner.sex, "male");
    assert.match(out.partner.mood, /himself/);
  });

  test("a reader who dates women keeps the scene as written", () => {
    const out = scenarioFor(scene, manIntoWomen);
    assert.equal(out.partner.sex, "female");
    assert.match(out.partner.mood, /herself/);
  });

  // Inferring it from somebody's own sex would be assuming they are straight.
  test("a reader who has said nothing gets the scene as written", () => {
    assert.equal(scenarioFor(scene, nobody).partner.sex, "female");
  });

  test("a reader who dates both keeps the scene as written", () => {
    const both: Audience = { sex: "male", ageGroup: null, datingInterest: "both" };
    assert.equal(scenarioFor(scene, both).partner.sex, "female");
  });

  // Nothing downstream should be able to see a second character, least of all
  // the prompt — a partner who knows about their own alternate is one who can
  // mention it.
  test("the alternate never survives selection", () => {
    for (const audience of [nobody, manIntoWomen, womanIntoMen]) {
      assert.equal("alt" in scenarioFor(scene, audience).partner, false);
    }
  });

  test("a scene with no alternate is returned untouched", () => {
    const plain = { ...scene, partner: { ...scene.partner, alt: undefined } };
    assert.equal(scenarioFor(plain, womanIntoMen).partner.name, "Wren");
    assert.equal(scenarioFor(plain, womanIntoMen).partner.sex, "female");
  });

  test("a variant's partner_sex outranks the authored one", () => {
    const variant: LessonVariant = {
      when: { sex: "female", dating_interest: "men" },
      label: "Women approaching men",
      partner_sex: "male",
    };
    assert.equal(scenarioFor(scene, nobody, variant).partner.sex, "male");
  });
});
