// The prompt is asserted against every scenario in the shipped curriculum, so
// a lesson written later cannot quietly produce a partner that coaches or
// ignores its openness.

import { describe, test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

import {
  buildFeedbackPrompt,
  buildSystemPrompt,
  opennessBehaviour,
} from "../src/lib/roleplay/prompt.ts";

const MIGRATIONS = join(import.meta.dirname, "..", "supabase", "migrations");

type Scenario = Parameters<typeof buildSystemPrompt>[0];

function allScenarios(): Scenario[] {
  const out: Scenario[] = [];
  for (const file of readdirSync(MIGRATIONS).filter((f) =>
    f.includes("seed_lessons_"),
  )) {
    const sql = readFileSync(join(MIGRATIONS, file), "utf8");
    for (const [, raw] of sql.matchAll(/\$j\$([\s\S]*?)\$j\$/g)) {
      try {
        const parsed = JSON.parse(raw);
        if (parsed?.partner) out.push(parsed as Scenario);
      } catch {
        /* other blocks are checked by curriculum.test.ts */
      }
    }
  }
  return out;
}

const scenarios = allScenarios();

describe("system prompt", () => {
  test("there are scenarios to build prompts from", () => {
    assert.ok(scenarios.length >= 45, `only found ${scenarios.length}`);
  });

  test("carries the partner's identity and situation", () => {
    for (const scenario of scenarios) {
      const prompt = buildSystemPrompt(scenario);
      assert.ok(prompt.includes(scenario.partner.name), "missing name");
      assert.ok(prompt.includes(scenario.partner.role), "missing role");
      assert.ok(prompt.includes(scenario.partner.personality), "missing personality");
      assert.ok(prompt.includes(scenario.partner.mood), "missing mood");
      assert.ok(prompt.includes(scenario.setting), "missing setting");
      assert.ok(prompt.includes(scenario.opening_beat), "missing opening beat");
    }
  });

  test("states openness as both a number and a behaviour", () => {
    for (const scenario of scenarios) {
      const prompt = buildSystemPrompt(scenario);
      const { openness, name } = scenario.partner;
      assert.ok(
        prompt.includes(`${openness} out of 5`),
        `${name}: openness not stated numerically`,
      );
      assert.ok(
        prompt.includes(opennessBehaviour(openness)),
        `${name}: openness not stated behaviourally`,
      );
    }
  });

  test("every scenario's own constraints survive into the prompt", () => {
    for (const scenario of scenarios) {
      const prompt = buildSystemPrompt(scenario);
      for (const constraint of scenario.constraints) {
        assert.ok(
          prompt.includes(constraint),
          `${scenario.partner.name}: dropped a constraint`,
        );
      }
    }
  });

  // The single most important instruction in the whole feature.
  test("always forbids coaching, whatever the lesson said", () => {
    for (const scenario of scenarios) {
      const prompt = buildSystemPrompt(scenario).toLowerCase();
      assert.ok(prompt.includes("never coach"), `${scenario.partner.name}`);
    }
  });

  test("forbids narration and breaking the scene", () => {
    for (const scenario of scenarios) {
      const prompt = buildSystemPrompt(scenario).toLowerCase();
      assert.ok(prompt.includes("no narration"));
      assert.ok(prompt.includes("fourth wall"));
    }
  });

  // A closed partner that warms up under pressure would teach the opposite of
  // track 7, so the instruction is explicit rather than implied.
  test("the most closed partners are told not to warm up", () => {
    const closed = scenarios.filter((s) => s.partner.openness === 1);
    assert.ok(closed.length > 0, "expected at least one openness 1 partner");

    for (const scenario of closed) {
      const prompt = buildSystemPrompt(scenario).toLowerCase();
      assert.ok(prompt.includes("do not warm up"));
      assert.ok(prompt.includes("not a puzzle to be solved"));
    }
  });

  test("unknown openness falls back to neutral rather than throwing", () => {
    assert.equal(opennessBehaviour(99), opennessBehaviour(3));
    assert.equal(opennessBehaviour(0), opennessBehaviour(3));
  });
});

describe("feedback prompt", () => {
  const rubric = {
    scale: { min: 1, max: 5 },
    criteria: [
      { key: "opened_well", label: "Opened well", description: "Started cleanly." },
      { key: "listened", label: "Listened", description: "Built on their words." },
    ],
  };

  test("names every criterion by key", () => {
    const prompt = buildFeedbackPrompt(rubric);
    for (const c of rubric.criteria) {
      assert.ok(prompt.includes(c.key));
      assert.ok(prompt.includes(c.label));
    }
  });

  test("demands JSON only, with no fences", () => {
    const prompt = buildFeedbackPrompt(rubric).toLowerCase();
    assert.ok(prompt.includes("json only"));
    assert.ok(prompt.includes("no markdown code fences"));
  });

  test("states the brief's counting rules explicitly", () => {
    const prompt = buildFeedbackPrompt(rubric).toLowerCase();
    assert.ok(prompt.includes("exactly two"), "two positives");
    assert.ok(prompt.includes("exactly one"), "one fix");
    assert.ok(prompt.includes("verbatim"), "quote must be real");
    assert.ok(prompt.includes("never invent a line"));
  });
});

/**
 * The alternate partners, which never pass through the scenarios above.
 *
 * A Dating scene carries a second character for a reader who dates the other
 * sex, authored in its own migration rather than inside the seed. Nothing else
 * in the suite would notice a half-written one — a partner missing a mood
 * produces a prompt with a blank in it, and the only symptom is a model
 * improvising a personality nobody wrote.
 */
function allAlternates(): { where: string; base: string; partner: Scenario["partner"] }[] {
  const out: { where: string; base: string; partner: Scenario["partner"] }[] = [];

  for (const file of readdirSync(MIGRATIONS).filter((f) => f.endsWith(".sql"))) {
    const sql = readFileSync(join(MIGRATIONS, file), "utf8");

    // Retrofitted onto a scene that already shipped.
    for (const [, skill, order, base, raw] of sql.matchAll(
      /set_partner\('([a-z-]+)',\s*(\d+),\s*'(male|female)',\s*\$j\$([\s\S]*?)\$j\$/g,
    )) {
      out.push({
        where: `${skill}/${order}`,
        base,
        partner: JSON.parse(raw) as Scenario["partner"],
      });
    }

    // Written into the scene from the start, which is how new content should
    // do it. Both shapes have to be checked or the newer one is the untested
    // one, which is the wrong way round.
    for (const [, raw] of sql.matchAll(/\$j\$([\s\S]*?)\$j\$/g)) {
      let parsed;
      try {
        parsed = JSON.parse(raw);
      } catch {
        continue;
      }
      if (!parsed?.partner?.alt) continue;

      out.push({
        where: `${file} — ${parsed.partner.name}`,
        base: parsed.partner.sex,
        partner: parsed.partner.alt as Scenario["partner"],
      });
    }
  }

  return out;
}

describe("the partner a reader gets instead", () => {
  const alternates = allAlternates();
  const scene = scenarios[0];

  test("there are alternates to check", () => {
    assert.ok(alternates.length >= 10, `only found ${alternates.length}`);
  });

  test("each is a whole character rather than a renamed one", () => {
    for (const { where, partner } of alternates) {
      for (const key of ["name", "role", "personality", "mood"] as const) {
        assert.ok(partner[key]?.trim(), `${where} alternate has no ${key}`);
      }
      assert.ok(
        Number.isInteger(partner.openness) &&
          partner.openness >= 1 &&
          partner.openness <= 5,
        `${where} alternate has openness ${partner.openness}`,
      );
    }
  });

  test("each is the other sex to the one it replaces", () => {
    for (const { where, base, partner } of alternates) {
      assert.ok(partner.sex, `${where} alternate does not say which sex it is`);
      assert.notEqual(
        partner.sex,
        base,
        `${where} alternate is the same sex as the partner it stands in for`,
      );
    }
  });

  test("each builds a prompt that carries who they are", () => {
    for (const { where, partner } of alternates) {
      const prompt = buildSystemPrompt({ ...scene, partner });
      assert.ok(prompt.includes(partner.name), `${where}: missing name`);
      assert.ok(prompt.includes(partner.role), `${where}: missing role`);
      assert.ok(prompt.includes(partner.personality), `${where}: missing personality`);
      assert.ok(prompt.includes(partner.mood), `${where}: missing mood`);
    }
  });
});

/**
 * Topics where the person across the table is somebody the reader might be
 * drawn to, which is what makes their sex follow from what the reader said
 * rather than from whoever the author happened to be picturing.
 */
const ROMANTIC_TOPICS = new Set(["meeting-someone", "dating-apps"]);

/**
 * Tracks inside those topics whose partner is not a prospect.
 *
 * The allow-list exists because "every scene in a dating topic" is the wrong
 * rule, and was wrong from the first day it could have been written. Reasons
 * are required rather than decorative: an entry with no argument for it is how
 * an allow-list turns into a place to put failures.
 */
const NOT_A_PROSPECT = new Map([
  [
    "your-profile",
    "Robin is a friend reading your profile over your shoulder. Tying their " +
      "sex to who the reader dates would imply the friend is a prospect, and " +
      "would make a scene about photo slots depend on something irrelevant.",
  ],
  [
    "running-the-app",
    "Sam is the friend you talk to about the app, not somebody on it. The " +
      "whole track is about what using these products does to the person " +
      "using them, so every scene is a conversation with somebody who is " +
      "not a candidate and whose sex is nobody's business.",
  ],
  [
    "where-it-is-breaking",
    "The same Sam, going through the numbers with you. This track is a " +
      "diagnosis of your own funnel and the partner is the person holding " +
      "the spreadsheet — there is nobody in these scenes the reader could " +
      "be interested in.",
  ],
]);

/** Which topic each skill is filed under, in both shapes the migrations use. */
function topicOfSkill(): Map<string, string> {
  const out = new Map<string, string>();

  for (const file of readdirSync(MIGRATIONS).filter((f) => f.endsWith(".sql"))) {
    const sql = readFileSync(join(MIGRATIONS, file), "utf8");

    // Seeded with its topic named inline.
    for (const [, topic, skill] of sql.matchAll(
      /select id from public\.topics where slug = '([a-z0-9-]+)'\s*\),\s*'([a-z0-9-]+)'/g,
    )) {
      out.set(skill, topic);
    }

    // Assigned afterwards, which is how the nine that predate the topics table
    // ended up anywhere. Reading only the shape above would leave Flirting and
    // Reading disinterest looking like they belong to nothing, and a scene in
    // a topic this cannot see is a scene this cannot guard.
    for (const [, topic, skill] of sql.matchAll(
      /t\.slug = '([a-z0-9-]+)' and s\.slug = '([a-z0-9-]+)'/g,
    )) {
      out.set(skill, topic);
    }
  }

  return out;
}

/** Every authored scene, with the lesson it belongs to. */
function authoredScenes(): {
  skill: string;
  order: string;
  partner: Scenario["partner"];
}[] {
  const out: { skill: string; order: string; partner: Scenario["partner"] }[] = [];

  for (const file of readdirSync(MIGRATIONS).filter((f) => f.includes("seed_lessons_"))) {
    const sql = readFileSync(join(MIGRATIONS, file), "utf8");

    const heads = [
      ...sql.matchAll(
        /\(select id from public\.skills where slug = '([a-z0-9-]+)'\),\s*(\d+),/g,
      ),
    ];

    for (const [i, head] of heads.entries()) {
      const chunk = sql.slice(
        head.index + head[0].length,
        heads[i + 1]?.index ?? sql.length,
      );

      for (const [, raw] of chunk.matchAll(/\$j\$([\s\S]*?)\$j\$/g)) {
        let parsed;
        try {
          parsed = JSON.parse(raw);
        } catch {
          continue;
        }
        if (parsed?.partner) {
          out.push({ skill: head[1], order: head[2], partner: parsed.partner });
        }
      }
    }
  }

  return out;
}

/** Scenes given an alternate afterwards rather than in the seed. */
function retrofitted(): Set<string> {
  const out = new Set<string>();

  for (const file of readdirSync(MIGRATIONS).filter((f) => f.endsWith(".sql"))) {
    for (const [, skill, order] of readFileSync(join(MIGRATIONS, file), "utf8").matchAll(
      /set_partner\('([a-z0-9-]+)',\s*(\d+),/g,
    )) {
      out.add(`${skill}/${order}`);
    }
  }

  return out;
}

/**
 * The guard the audit had to do by hand.
 *
 * What the suite already checked was that an alternate, if one existed, was a
 * whole character of the other sex. Nothing checked that a scene which needs
 * one has one — so a whole track could ship with every partner fixed to
 * whichever sex the author was picturing, stay green, and be noticed only by
 * a reader who does not date that sex.
 */
describe("scenes that need a partner of the other sex have one", () => {
  const topics = topicOfSkill();
  const already = retrofitted();

  const scenes = authoredScenes().filter((s) =>
    ROMANTIC_TOPICS.has(topics.get(s.skill) ?? ""),
  );

  // A parser reading SQL with a regular expression fails silently when the SQL
  // is written a little differently, and a silent parser makes the assertions
  // below vacuously true.
  test("the scenes were actually found", () => {
    assert.ok(scenes.length >= 30, `only found ${scenes.length} scenes to check`);
    for (const skill of NOT_A_PROSPECT.keys()) {
      assert.ok(
        scenes.some((s) => s.skill === skill),
        `${skill} is on the allow-list but has no scenes in a romantic topic`,
      );
    }
  });

  test("every prospect has an alternate", () => {
    for (const { skill, order, partner } of scenes) {
      if (NOT_A_PROSPECT.has(skill)) continue;

      // A retrofitted scene is covered by its set_partner call, which writes
      // the sex onto the authored partner as well as adding the alternate.
      // Reading only the seed would report every one of those as missing a
      // sex it does in fact have.
      if (already.has(`${skill}/${order}`)) continue;

      assert.ok(
        partner.sex,
        `${skill}/${order} (${partner.name}) does not say which sex it is, so ` +
          `nothing can work out who to put in the scene instead`,
      );
      assert.ok(
        partner.alt,
        `${skill}/${order} (${partner.name}) has no alternate, so a reader who ` +
          `does not date ${partner.sex}s rehearses against the wrong person`,
      );
    }
  });

  test("nothing is exempt without an argument for it", () => {
    for (const [skill, why] of NOT_A_PROSPECT) {
      assert.ok(why.length > 40, `${skill} is exempt with no argument for it`);
    }
  });
});
