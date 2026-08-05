import { describe, test } from "node:test";
import assert from "node:assert/strict";

import {
  LIMITS,
  checkLimit,
  isRehearsalUnlocked,
  requiredLevelForLesson,
} from "../src/lib/roleplay/limits.ts";
import { ScriptedPartner, type Turn } from "../src/lib/roleplay/partner.ts";

const NOW = new Date("2026-08-05T12:00:00Z");
const minutesAgo = (n: number) => new Date(NOW.getTime() - n * 60_000);

describe("rate limits", () => {
  test("allows a first call", () => {
    const verdict = checkLimit("partner_turn", [], NOW);
    assert.equal(verdict.allowed, true);
    if (!verdict.allowed) return;
    assert.equal(verdict.remaining, LIMITS.partner_turn.max);
  });

  test("counts only calls inside the window", () => {
    const old = Array.from({ length: 100 }, () => minutesAgo(120));
    const verdict = checkLimit("partner_turn", old, NOW);
    assert.equal(verdict.allowed, true, "calls from two hours ago must not count");
  });

  test("refuses once the window is full", () => {
    const recent = Array.from({ length: LIMITS.partner_turn.max }, (_, i) =>
      minutesAgo(i % 50),
    );
    const verdict = checkLimit("partner_turn", recent, NOW);
    assert.equal(verdict.allowed, false);
  });

  test("says when to come back, based on the oldest call in the window", () => {
    // Window full, oldest call was 50 minutes ago, so 10 minutes remain.
    const recent = [
      minutesAgo(50),
      ...Array.from({ length: LIMITS.feedback.max - 1 }, () => minutesAgo(5)),
    ];
    const verdict = checkLimit("feedback", recent, NOW);
    assert.equal(verdict.allowed, false);
    if (verdict.allowed) return;
    assert.equal(verdict.retryAfterMinutes, 10);
  });

  test("never advises retrying in zero minutes", () => {
    const recent = Array.from({ length: LIMITS.feedback.max }, () =>
      minutesAgo(59.99),
    );
    const verdict = checkLimit("feedback", recent, NOW);
    if (verdict.allowed) return;
    assert.ok(verdict.retryAfterMinutes >= 1);
  });

  test("feedback is limited more tightly than turns, being the costlier call", () => {
    assert.ok(LIMITS.feedback.max < LIMITS.partner_turn.max);
  });
});

describe("scenario gating", () => {
  // The brief: level-ups unlock harder scenarios, not cosmetics. Levels come
  // overwhelmingly from logged field missions, so later rehearsals are opened
  // by going out and having real conversations.
  test("the first lesson is always available", () => {
    assert.equal(requiredLevelForLesson(1), 1);
    assert.equal(isRehearsalUnlocked(1, 1), true);
  });

  test("later lessons need a higher level", () => {
    assert.equal(requiredLevelForLesson(5), 3);
    assert.equal(isRehearsalUnlocked(5, 2), false);
    assert.equal(isRehearsalUnlocked(5, 3), true);
  });

  test("requirements never decrease as lessons progress", () => {
    let previous = 0;
    for (let n = 1; n <= 6; n++) {
      const required = requiredLevelForLesson(n);
      assert.ok(required >= previous, `lesson ${n} eased the requirement`);
      previous = required;
    }
  });

  test("a whole track is reachable well within the level cap", () => {
    assert.ok(requiredLevelForLesson(6) <= 10);
  });
});

describe("scripted partner", () => {
  const partner = new ScriptedPartner();

  const scenario = (openness: number) => ({
    setting: "A queue.",
    opening_beat: "They glance at the machine.",
    success_looks_like: "",
    constraints: ["Stay in character. Never coach."],
    partner: {
      name: "Sam",
      role: "a stranger",
      personality: "dry",
      mood: "tired",
      openness,
    },
  });

  const turn = (content: string) =>
    ({ role: "user" as const, content, at: "2026-08-05T12:00:00Z" });

  test("opens with the scenario's own beat", async () => {
    const reply = await partner.nextTurn(scenario(3), []);
    assert.equal(reply, "They glance at the machine.");
  });

  // The behaviour that matters most: a closed partner must not be won over.
  test("an openness 1 partner stays closed however hard the user tries", async () => {
    const history = [];
    for (let i = 0; i < 8; i++) {
      history.push(turn("Some genuinely charming and interesting remark number " + i));
      const reply = await partner.nextTurn(scenario(1), history);
      assert.ok(
        reply.split(" ").length <= 8,
        `turn ${i} was too generous: "${reply}"`,
      );
      assert.ok(!reply.includes("?"), `turn ${i} asked a question back`);
      history.push({ role: "partner" as const, content: reply, at: "" });
    }
  });

  test("an openness 5 partner gives plenty to work with", async () => {
    const reply = await partner.nextTurn(scenario(5), [turn("How was it?")]);
    assert.ok(reply.split(" ").length > 10);
  });

  test("is deterministic, so a transcript replays identically", async () => {
    const history = [turn("Morning.")];
    const a = await partner.nextTurn(scenario(3), history);
    const b = await partner.nextTurn(scenario(3), history);
    assert.equal(a, b);
  });

  // A real person never says the identical sentence twice in three turns, and
  // seeing it happen makes a stand-in impossible to read past.
  test("does not repeat itself while it still has fresh lines", async () => {
    for (const openness of [1, 2, 3, 4, 5]) {
      const history: Turn[] = [];
      const replies: string[] = [];

      for (let i = 0; i < 3; i++) {
        history.push(turn(`A reasonably long remark, number ${i}, with content.`));
        const reply = await partner.nextTurn(scenario(openness), history);
        replies.push(reply);
        history.push({ role: "partner", content: reply, at: "" });
      }

      assert.equal(
        new Set(replies).size,
        replies.length,
        `openness ${openness} repeated itself: ${JSON.stringify(replies)}`,
      );
    }
  });

  test("feedback quotes a line the user actually said", async () => {
    const rubric = {
      scale: { min: 1, max: 5 },
      criteria: [{ key: "opened_well", label: "Opened", description: "" }],
    };
    const history = [turn("That machine is working hard this morning.")];

    const result = await partner.feedback(scenario(3), rubric, history);
    assert.equal(result.ok, true);
    if (!result.ok) return;
    assert.equal(
      result.feedback.rewrite.original,
      "That machine is working hard this morning.",
    );
    assert.equal(result.feedback.worked.length, 2);
  });

  // Whatever the user said, the rewrite has to differ from it, or the parser
  // will reject the whole review as useless.
  test("always rewrites into something actually different", async () => {
    const rubric = {
      scale: { min: 1, max: 5 },
      criteria: [{ key: "opened_well", label: "Opened", description: "" }],
    };

    const lines = [
      "So what do you do for work?",
      "Morning.",
      "That machine is really working for its money this morning.",
      "I have been standing here a while. Longer than I meant to, honestly.",
      "Hi",
    ];

    for (const line of lines) {
      const result = await partner.feedback(scenario(3), rubric, [turn(line)]);
      assert.equal(result.ok, true, line);
      if (!result.ok) continue;
      const { original, better } = result.feedback.rewrite;
      assert.notEqual(better.trim(), original.trim(), `unchanged for: ${line}`);
      assert.ok(better.trim().length > 0);
    }
  });

  test("refuses to score a conversation with nothing in it", async () => {
    const rubric = { scale: { min: 1, max: 5 }, criteria: [] };
    const result = await partner.feedback(scenario(3), rubric, []);
    assert.equal(result.ok, false);
  });
});
