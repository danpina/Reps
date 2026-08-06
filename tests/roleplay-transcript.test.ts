// The shaping rules between a stored transcript and the API. These are the
// rules that produce a 400 at runtime if they are wrong, and a 400 lands
// mid-rehearsal, so they are asserted rather than assumed.

import { describe, test } from "node:test";
import assert from "node:assert/strict";

import {
  feedbackSchema,
  renderTranscript,
  toMessages,
} from "../src/lib/roleplay/transcript.ts";
import type { Turn } from "../src/lib/roleplay/partner.ts";

const at = "2026-08-06T10:00:00.000Z";
const user = (content: string): Turn => ({ role: "user", content, at });
const partner = (content: string): Turn => ({ role: "partner", content, at });

describe("toMessages", () => {
  test("maps roles to the API's names", () => {
    const messages = toMessages([user("Hi there"), partner("Hello")]);
    // The trailing partner turn is dropped, so only the user survives here.
    assert.deepEqual(messages, [{ role: "user", content: "Hi there" }]);
  });

  test("keeps a full alternating scene", () => {
    const messages = toMessages([
      user("Nice weather"),
      partner("Suppose so."),
      user("Been here long?"),
    ]);
    assert.deepEqual(messages, [
      { role: "user", content: "Nice weather" },
      { role: "assistant", content: "Suppose so." },
      { role: "user", content: "Been here long?" },
    ]);
  });

  test("drops a leading partner turn", () => {
    // The opening beat lives in the system prompt. A transcript that begins
    // with it would open the conversation on the assistant, which is a 400.
    const messages = toMessages([partner("Cold one today."), user("It is.")]);
    assert.equal(messages[0].role, "user");
    assert.equal(messages.length, 1);
  });

  test("never ends on the assistant", () => {
    // A trailing assistant turn is read as a prefill, which current models
    // reject outright.
    const messages = toMessages([
      user("Hi"),
      partner("Mm."),
      partner("Right."),
    ]);
    assert.equal(messages.at(-1)?.role, "user");
  });

  test("drops blank turns and trims", () => {
    const messages = toMessages([user("   "), user("  Real line  ")]);
    assert.deepEqual(messages, [{ role: "user", content: "Real line" }]);
  });

  test("returns nothing for an empty transcript", () => {
    assert.deepEqual(toMessages([]), []);
    assert.deepEqual(toMessages([partner("Cold one today.")]), []);
  });
});

describe("renderTranscript", () => {
  test("labels the person being reviewed as THEM", () => {
    // The reviewer reads the scene from the character's side, so the person
    // under review is the other party. Getting this backwards would score the
    // partner's lines as if the user had written them.
    const text = renderTranscript([user("Nice weather"), partner("Suppose so.")]);
    assert.equal(text, "THEM: Nice weather\nYOU: Suppose so.");
  });

  test("skips blank turns", () => {
    assert.equal(renderTranscript([user("A"), partner("  ")]), "THEM: A");
  });
});

describe("feedbackSchema", () => {
  const rubric = {
    scale: { min: 1, max: 5 },
    criteria: [
      { key: "warmth", label: "Warmth", description: "Did they seem human." },
      { key: "curiosity", label: "Curiosity", description: "Did they ask." },
    ],
  };

  test("requires a score for every criterion and nothing else", () => {
    const schema = feedbackSchema(rubric) as {
      properties: { scores: { properties: object; required: string[]; additionalProperties: boolean } };
      required: string[];
    };
    assert.deepEqual(schema.properties.scores.required, ["warmth", "curiosity"]);
    assert.deepEqual(Object.keys(schema.properties.scores.properties), [
      "warmth",
      "curiosity",
    ]);
    // additionalProperties: false is what makes the guarantee a guarantee.
    assert.equal(schema.properties.scores.additionalProperties, false);
    assert.deepEqual(schema.required, ["scores", "worked", "fix", "rewrite"]);
  });

  test("uses only the schema subset the API supports", () => {
    // minimum/maximum, minItems/maxItems and friends are silently unsupported,
    // and a schema carrying them is rejected. The parser clamps scores and
    // takes exactly two positives instead.
    const json = JSON.stringify(feedbackSchema(rubric));
    for (const unsupported of [
      "minimum",
      "maximum",
      "multipleOf",
      "minItems",
      "maxItems",
      "minLength",
      "maxLength",
      "$ref",
    ]) {
      assert.ok(
        !json.includes(`"${unsupported}"`),
        `schema must not use ${unsupported}`,
      );
    }
  });

  test("carries the criterion wording through to the model", () => {
    const json = JSON.stringify(feedbackSchema(rubric));
    assert.ok(json.includes("Did they seem human."));
  });
});
