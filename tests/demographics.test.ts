import { describe, test } from "node:test";
import assert from "node:assert/strict";

import {
  AGE_GROUPS,
  compareAges,
  describeOther,
  describeSelf,
  parseAgeGroup,
  parseSex,
} from "../src/lib/profile/demographics.ts";

describe("reading the optional answers", () => {
  // Every one of these fields can be skipped, so "not answered" arrives at the
  // parser constantly. It has to become null rather than a string that the
  // database enum would then reject.
  test("a blank answer is nothing, not a value", () => {
    assert.equal(parseSex(""), null);
    assert.equal(parseSex(null), null);
    assert.equal(parseAgeGroup(""), null);
    assert.equal(parseAgeGroup(null), null);
  });

  test("a value outside the list is refused rather than passed on", () => {
    assert.equal(parseSex("other"), null);
    assert.equal(parseSex("MALE"), null, "the enum is lower case");
    assert.equal(parseAgeGroup("13-17"), null);
    assert.equal(parseAgeGroup("100+"), null);
  });

  test("the real values come through", () => {
    assert.equal(parseSex("male"), "male");
    assert.equal(parseSex("female"), "female");
    assert.equal(parseAgeGroup("35-44"), "35-44");
  });

  test("the bands start at 18, because the Dating topic exists", () => {
    assert.equal(AGE_GROUPS[0], "18-24");
  });
});

describe("describing a person", () => {
  test("both facts read as one phrase", () => {
    assert.equal(describeOther("female", "25-34"), "a woman, 25 to 34");
    assert.equal(describeOther("male", "65+"), "a man, 65 or over");
  });

  test("one fact alone still reads", () => {
    assert.equal(describeOther("male", null), "a man");
    assert.equal(describeOther(null, "45-54"), "someone 45 to 54");
  });

  test("nothing recorded describes nobody", () => {
    assert.equal(describeOther(null, null), null);
    assert.equal(describeSelf(null, null), null);
  });
});

describe("where they sat relative to you", () => {
  test("the same band is the same", () => {
    assert.equal(compareAges("25-34", "25-34"), "same");
  });

  test("one band up is older, one down is younger", () => {
    assert.equal(compareAges("25-34", "35-44"), "older");
    assert.equal(compareAges("35-44", "25-34"), "younger");
  });

  test("the ends of the range behave", () => {
    assert.equal(compareAges("18-24", "65+"), "older");
    assert.equal(compareAges("65+", "18-24"), "younger");
  });

  // The comparison is the whole reason the user's own age is worth storing, and
  // most logs will be missing one side of it. Guessing a direction from half
  // the information would put a false finding into a coaching prompt.
  test("a missing half is not a comparison", () => {
    assert.equal(compareAges(null, "25-34"), null);
    assert.equal(compareAges("25-34", null), null);
    assert.equal(compareAges(null, null), null);
  });
});
