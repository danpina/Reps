// The feedback parser is the part most likely to meet a badly behaved
// response, and the brief is explicit that a malformed one must not crash the
// session. Every failure below should resolve to a typed reason.

import { describe, test } from "node:test";
import assert from "node:assert/strict";

import {
  averageScore,
  extractJson,
  parseFeedback,
  quotedLineWasSaid,
} from "../src/lib/roleplay/feedback.ts";

const rubric = {
  scale: { min: 1, max: 5 },
  criteria: [
    { key: "opened_well", label: "Opened well", description: "" },
    { key: "left_a_gap", label: "Left a gap", description: "" },
  ],
};

const userTurns = [
  "That machine is really working for its money this morning.",
  "Half six is brutal. What got you out that early?",
];

const good = {
  scores: { opened_well: 4, left_a_gap: 2 },
  worked: ["You opened on the machine.", "You picked up on half six."],
  fix: "Leave a beat after the opener.",
  rewrite: {
    original: "Half six is brutal. What got you out that early?",
    better: "Half six is brutal.",
    why: "The statement invites more than the question demands.",
  },
};

const parse = (raw: string) => parseFeedback(raw, rubric, userTurns);

describe("extractJson", () => {
  test("takes a bare object", () => {
    assert.equal(extractJson('{"a":1}'), '{"a":1}');
  });

  test("unwraps a markdown fence", () => {
    assert.equal(extractJson('```json\n{"a":1}\n```'), '{"a":1}');
    assert.equal(extractJson('```\n{"a":1}\n```'), '{"a":1}');
  });

  test("ignores prose either side", () => {
    assert.equal(
      extractJson('Here is the feedback:\n{"a":1}\nHope that helps.'),
      '{"a":1}',
    );
  });

  test("returns null when there is no object", () => {
    assert.equal(extractJson("no json here"), null);
    assert.equal(extractJson(""), null);
    assert.equal(extractJson("}{"), null);
  });
});

describe("quotedLineWasSaid", () => {
  test("matches an exact line", () => {
    assert.equal(quotedLineWasSaid(userTurns[0], userTurns), true);
  });

  test("tolerates case, punctuation and smart quotes", () => {
    assert.equal(
      quotedLineWasSaid("HALF SIX IS BRUTAL — what got you out that early?", userTurns),
      true,
    );
  });

  test("matches a fragment of something said", () => {
    assert.equal(quotedLineWasSaid("working for its money", userTurns), true);
  });

  test("rejects an invented line", () => {
    assert.equal(
      quotedLineWasSaid("So what do you do for work?", userTurns),
      false,
    );
  });

  test("rejects an empty quote", () => {
    assert.equal(quotedLineWasSaid("   ", userTurns), false);
  });
});

describe("parseFeedback", () => {
  test("accepts a well-formed response", () => {
    const result = parse(JSON.stringify(good));
    assert.equal(result.ok, true);
    if (!result.ok) return;
    assert.deepEqual(result.feedback.scores, { opened_well: 4, left_a_gap: 2 });
    assert.equal(result.feedback.worked.length, 2);
    assert.equal(result.warnings.length, 0);
  });

  test("accepts one wrapped in fences and prose", () => {
    const result = parse("Sure!\n```json\n" + JSON.stringify(good) + "\n```");
    assert.equal(result.ok, true);
  });

  // Truncation loses the closing brace, so it fails at extraction rather than
  // at JSON.parse. Both are rejections; they just fail at different points.
  test("rejects a response cut off mid-object", () => {
    const result = parse(JSON.stringify(good).slice(0, 40));
    assert.equal(result.ok, false);
    if (result.ok) return;
    assert.match(result.reason, /No JSON object/);
  });

  test("rejects a complete-looking object that is not valid JSON", () => {
    const result = parse('{"scores": {opened_well: 4}, "fix": "x"}');
    assert.equal(result.ok, false);
    if (result.ok) return;
    assert.match(result.reason, /not valid JSON/);
  });

  test("rejects an empty or prose-only response", () => {
    assert.equal(parse("").ok, false);
    assert.equal(parse("I could not review that conversation.").ok, false);
  });

  test("rejects an array", () => {
    const result = parse("[1,2,3]");
    assert.equal(result.ok, false);
  });

  test("rejects a missing criterion score", () => {
    const result = parse(
      JSON.stringify({ ...good, scores: { opened_well: 4 } }),
    );
    assert.equal(result.ok, false);
    if (result.ok) return;
    assert.match(result.reason, /left_a_gap/);
  });

  test("rejects a non-numeric score", () => {
    const result = parse(
      JSON.stringify({ ...good, scores: { opened_well: "good", left_a_gap: 2 } }),
    );
    assert.equal(result.ok, false);
  });

  // Clamping beats discarding: the rest of the review is still useful.
  test("clamps an out-of-range score and warns", () => {
    const result = parse(
      JSON.stringify({ ...good, scores: { opened_well: 11, left_a_gap: 0 } }),
    );
    assert.equal(result.ok, true);
    if (!result.ok) return;
    assert.equal(result.feedback.scores.opened_well, 5);
    assert.equal(result.feedback.scores.left_a_gap, 1);
    assert.equal(result.warnings.length, 2);
  });

  test("rejects fewer than two positives", () => {
    const result = parse(JSON.stringify({ ...good, worked: ["Only one."] }));
    assert.equal(result.ok, false);
    if (result.ok) return;
    assert.match(result.reason, /two things/);
  });

  test("trims more than two positives and warns", () => {
    const result = parse(
      JSON.stringify({ ...good, worked: ["One.", "Two.", "Three."] }),
    );
    assert.equal(result.ok, true);
    if (!result.ok) return;
    assert.deepEqual(result.feedback.worked, ["One.", "Two."]);
    assert.equal(result.warnings.length, 1);
  });

  test("rejects a missing fix", () => {
    assert.equal(parse(JSON.stringify({ ...good, fix: "  " })).ok, false);
  });

  test("rejects an incomplete rewrite", () => {
    const result = parse(
      JSON.stringify({ ...good, rewrite: { original: userTurns[0] } }),
    );
    assert.equal(result.ok, false);
  });

  // The brief asks for a rewrite of a line the user actually wrote. A
  // hallucinated quote makes the feedback about a conversation that never
  // happened, which is worse than no feedback.
  // "You said X, try X" is not advice.
  test("rejects a rewrite identical to the original", () => {
    const line = userTurns[0];
    const result = parse(
      JSON.stringify({
        ...good,
        rewrite: { original: line, better: line, why: "no change" },
      }),
    );
    assert.equal(result.ok, false);
    if (result.ok) return;
    assert.match(result.reason, /same as the original/);
  });

  test("rejects a rewrite that only changes punctuation", () => {
    const result = parse(
      JSON.stringify({
        ...good,
        rewrite: {
          original: userTurns[0],
          better: userTurns[0].replace(".", "!"),
          why: "louder",
        },
      }),
    );
    assert.equal(result.ok, false);
  });

  test("rejects a rewrite quoting a line the user never said", () => {
    const result = parse(
      JSON.stringify({
        ...good,
        rewrite: { ...good.rewrite, original: "Nice weather we're having." },
      }),
    );
    assert.equal(result.ok, false);
    if (result.ok) return;
    assert.match(result.reason, /never said/);
  });
});

describe("averageScore", () => {
  test("averages the criteria", () => {
    assert.equal(averageScore({ a: 4, b: 2 }), 3);
  });

  test("handles no scores", () => {
    assert.equal(averageScore({}), 0);
  });
});
