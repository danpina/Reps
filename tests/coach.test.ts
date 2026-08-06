// The two rules that keep a read of the log honest and affordable: enough
// evidence before the first one, and enough new material before a repeat.

import { describe, test } from "node:test";
import assert from "node:assert/strict";

import {
  MAX_REPS_PER_REVIEW,
  MIN_NEW_REPS_FOR_REVIEW,
  MIN_REPS_FOR_REVIEW,
  eligibility,
} from "../src/lib/coach/eligibility.ts";
import { parseReview } from "../src/lib/coach/review.ts";

describe("when a read of the log is offered", () => {
  test("a new account cannot ask for one", () => {
    const result = eligibility({
      repsTotal: 0,
      repsSinceLastReview: 0,
      hasReview: false,
    });

    assert.equal(result.state, "locked");
    assert.equal(
      result.state === "locked" ? result.repsNeeded : null,
      MIN_REPS_FOR_REVIEW,
    );
  });

  test("one short is still locked, and says how many", () => {
    const result = eligibility({
      repsTotal: MIN_REPS_FOR_REVIEW - 1,
      repsSinceLastReview: MIN_REPS_FOR_REVIEW - 1,
      hasReview: false,
    });

    assert.equal(result.state, "locked");
    assert.equal(result.state === "locked" ? result.repsNeeded : null, 1);
  });

  test("the threshold itself unlocks it", () => {
    const result = eligibility({
      repsTotal: MIN_REPS_FOR_REVIEW,
      repsSinceLastReview: MIN_REPS_FOR_REVIEW,
      hasReview: false,
    });

    assert.equal(result.state, "ready");
  });

  // The point of the whole feature: a second read must not re-read the first
  // read's reps, and must not run at all until there is something new to say.
  test("a second read waits for new material", () => {
    const result = eligibility({
      repsTotal: 30,
      repsSinceLastReview: 2,
      hasReview: true,
    });

    assert.equal(result.state, "waiting");
    assert.equal(
      result.state === "waiting" ? result.newRepsNeeded : null,
      MIN_NEW_REPS_FOR_REVIEW - 2,
    );
  });

  test("enough new reps opens it again", () => {
    const result = eligibility({
      repsTotal: 30,
      repsSinceLastReview: MIN_NEW_REPS_FOR_REVIEW,
      hasReview: true,
    });

    assert.equal(result.state, "ready");
    assert.equal(
      result.state === "ready" ? result.newReps : null,
      MIN_NEW_REPS_FOR_REVIEW,
      "a re-read should only ever cover the new reps",
    );
  });

  test("the first read is not held to the new-material bar", () => {
    // Ten total, none of them new relative to a review that does not exist.
    const result = eligibility({
      repsTotal: MIN_REPS_FOR_REVIEW,
      repsSinceLastReview: MIN_REPS_FOR_REVIEW,
      hasReview: false,
    });

    assert.equal(result.state, "ready");
  });

  test("a long absence is flagged as capped rather than sent whole", () => {
    const result = eligibility({
      repsTotal: 500,
      repsSinceLastReview: MAX_REPS_PER_REVIEW + 1,
      hasReview: true,
    });

    assert.equal(result.state, "ready");
    assert.equal(result.state === "ready" ? result.capped : null, true);
  });

  test("an ordinary re-read is not capped", () => {
    const result = eligibility({
      repsTotal: 40,
      repsSinceLastReview: 8,
      hasReview: true,
    });

    assert.equal(result.state === "ready" ? result.capped : null, false);
  });
});

const good = {
  headline: "You open well and leave badly.",
  patterns: [
    { title: "Strong starts", detail: "Nine of these opened cleanly.", evidence: "12 Aug, 14 Aug" },
    { title: "No exits", detail: "Most end when the other person leaves.", evidence: "17 Aug" },
  ],
  working: "Environment openers, consistently.",
  one_thing: "Close one conversation on purpose.",
  next_rep: "End the next one yourself, with a reason to go.",
};

describe("parsing a read", () => {
  test("accepts a well-formed review", () => {
    const result = parseReview(JSON.stringify(good));
    assert.equal(result.ok, true);
    assert.equal(result.ok && result.review.patterns.length, 2);
    assert.equal(result.ok && result.review.oneThing, good.one_thing);
  });

  test("digs the object out of a markdown fence", () => {
    const result = parseReview("```json\n" + JSON.stringify(good) + "\n```");
    assert.equal(result.ok, true);
  });

  test("rejects a single pattern, which is an anecdote", () => {
    const result = parseReview(
      JSON.stringify({ ...good, patterns: [good.patterns[0]] }),
    );
    assert.equal(result.ok, false);
  });

  test("trims more than four patterns rather than failing", () => {
    const result = parseReview(
      JSON.stringify({
        ...good,
        patterns: [...good.patterns, ...good.patterns, ...good.patterns],
      }),
    );

    assert.equal(result.ok, true);
    assert.equal(result.ok && result.review.patterns.length, 4);
  });

  test("rejects a review with no single change in it", () => {
    const result = parseReview(JSON.stringify({ ...good, one_thing: "  " }));
    assert.equal(result.ok, false);
  });

  test("rejects prose that is not JSON at all", () => {
    const result = parseReview("Here is what I noticed about your log.");
    assert.equal(result.ok, false);
  });

  test("rejects an empty response", () => {
    assert.equal(parseReview("").ok, false);
  });
});
