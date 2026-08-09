// Validates seeded curriculum content without needing a database. Catches
// malformed JSON and content that would violate the table's CHECK constraints
// before a migration is ever applied.

import { describe, test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const MIGRATIONS = join(import.meta.dirname, "..", "supabase", "migrations");

type Example = { situation: string; line: string; why: string };
type CheckOption = { text: string; correct: boolean; note: string };
type Check = { prompt: string; options: CheckOption[]; explain: string };
type Rubric = {
  scale: { min: number; max: number };
  criteria: { key: string; label: string; description: string }[];
};
type Scenario = {
  setting: string;
  opening_beat: string;
  success_looks_like: string;
  constraints: string[];
  partner: {
    name: string;
    role: string;
    personality: string;
    mood: string;
    openness: number;
  };
};

function lessonSeedFiles() {
  return readdirSync(MIGRATIONS).filter((f) => f.includes("seed_lessons_"));
}

function skillSeedFiles() {
  return readdirSync(MIGRATIONS).filter((f) => f.includes("seed_skills"));
}

function readMigration(file: string) {
  return readFileSync(join(MIGRATIONS, file), "utf8");
}

/** Every topic slug the migrations create. */
function topicSlugs(): Set<string> {
  const sql = readdirSync(MIGRATIONS)
    .filter((f) => f.includes("topics"))
    .map(readMigration)
    .join("\n");

  const block = /insert into public\.topics[\s\S]*?\n\s*\);/.exec(sql)?.[0] ?? "";
  const slugs = new Set(
    [...block.matchAll(/^\s{4}'([a-z0-9-]+)',$/gm)].map(([, s]) => s),
  );

  // A topic can also arrive by being renamed, which is how Dating became
  // Meeting someone. Reading only the insert missed those, so a skill filed
  // under a renamed topic looked like a skill filed under nothing.
  for (const [, slug] of sql.matchAll(/set\s+slug = '([a-z0-9-]+)'/g)) {
    slugs.add(slug);
  }

  return slugs;
}

/**
 * Every skill the migrations create, and the topic it was filed under.
 *
 * A skill seeded after topics existed names its topic inline. The original
 * nine predate the table and were assigned by the topics migration, so both
 * shapes are read here.
 */
function seededSkills(): Map<string, string | null> {
  const skills = new Map<string, string | null>();

  for (const file of skillSeedFiles()) {
    const sql = readMigration(file);

    for (const [, topic, skill] of sql.matchAll(
      /select id from public\.topics where slug = '([a-z0-9-]+)'\s*\),\s*'([a-z0-9-]+)'/g,
    )) {
      skills.set(skill, topic);
    }

    // The pre-topics shape: slug first, no topic on the row.
    for (const [, skill] of sql.matchAll(/^\s{4}'([a-z0-9-]+)',$/gm)) {
      if (!skills.has(skill)) skills.set(skill, null);
    }
  }

  return skills;
}

/** Which skill each lesson seed file writes lessons for. */
function skillsTargetedBy(file: string): string[] {
  const sql = readMigration(file);
  return [
    ...new Set(
      [
        ...sql.matchAll(/from public\.skills where slug = '([a-z0-9-]+)'/g),
      ].map(([, slug]) => slug),
    ),
  ];
}

function jsonBlocks(sql: string): unknown[] {
  return [...sql.matchAll(/\$j\$([\s\S]*?)\$j\$/g)].map(([, raw], i) => {
    try {
      return JSON.parse(raw);
    } catch (err) {
      assert.fail(
        `block ${i} is not valid JSON (${(err as Error).message}) — starts: ${raw
          .slice(0, 80)
          .replace(/\s+/g, " ")}`,
      );
    }
  });
}

const files = lessonSeedFiles();

describe("curriculum shape", () => {
  const topics = topicSlugs();
  const skills = seededSkills();

  // A parser reading SQL with a regular expression fails silently when the
  // SQL is written a little differently, and a silent parser makes every
  // assertion below vacuously true. So it has to find real slugs first.
  test("the topics migration seeds topics", () => {
    assert.ok(topics.size >= 4, `only found ${topics.size} topics: ${[...topics]}`);
    assert.ok(topics.has("small-talk"), "small-talk is missing from the topics");
  });

  test("every skill seeded belongs to something", () => {
    assert.ok(skills.size >= 9, `only found ${skills.size} skills`);
  });

  test("every skill is filed under a topic that exists", () => {
    for (const [skill, topic] of skills) {
      if (topic === null) continue; // assigned by the topics migration itself
      assert.ok(
        topics.has(topic),
        `${skill} is filed under "${topic}", which no migration creates`,
      );
    }
  });

  // The paywall samples the first two lessons of the first skill in a topic.
  // A topic whose opening skill is thin has no sample worth reading, and the
  // failure is silent: the page renders, it is just a worse advertisement.
  test("every lesson seed writes a track deep enough to be a track", () => {
    for (const file of files) {
      const targets = skillsTargetedBy(file);
      assert.equal(
        targets.length,
        1,
        `${file} writes lessons for ${targets.length} skills; keep one skill per migration`,
      );
      assert.ok(
        skills.has(targets[0]),
        `${file} writes lessons for "${targets[0]}", which no skill seed creates`,
      );

      const count = [
        ...readMigration(file).matchAll(/from public\.skills where slug =/g),
      ].length;
      assert.ok(
        count >= 4 && count <= 6,
        `${file} has ${count} lessons; a track is five, give or take one`,
      );
    }
  });
});

describe("curriculum seed content", () => {
  test("there is at least one lesson seed migration", () => {
    assert.ok(files.length > 0, "no seed_lessons_* migration found");
  });

  for (const file of files) {
    describe(file, () => {
      const blocks = jsonBlocks(readFileSync(join(MIGRATIONS, file), "utf8"));

      const examples = blocks.filter(
        (b): b is Example[] => Array.isArray(b) && "situation" in (b[0] ?? {}),
      );
      // Two shapes, both valid. The original nine tracks wrote one check per
      // lesson into check_json and a later migration lifted them into an
      // array; everything written since seeds checks_json directly, with both
      // beats in it. Either way a lesson contributes exactly one block.
      const checkBlocks = blocks.filter(
        (b): b is Check | Check[] =>
          (Array.isArray(b) && "prompt" in (b[0] ?? {})) ||
          (typeof b === "object" && b !== null && "prompt" in b),
      );
      const checks = checkBlocks.flat();
      const rubrics = blocks.filter(
        (b): b is Rubric =>
          typeof b === "object" && b !== null && "criteria" in b,
      );
      const scenarios = blocks.filter(
        (b): b is Scenario =>
          typeof b === "object" && b !== null && "partner" in b,
      );

      test("every lesson has all four structured fields", () => {
        assert.ok(examples.length > 0, "no lessons found");
        assert.equal(checkBlocks.length, examples.length, "missing a check");
        assert.equal(rubrics.length, examples.length, "missing a rubric");
        assert.equal(scenarios.length, examples.length, "missing a scenario");
      });

      test("each card has exactly three worked examples", () => {
        for (const set of examples) {
          assert.equal(set.length, 3);
          for (const ex of set) {
            for (const key of ["situation", "line", "why"] as const) {
              assert.ok(ex[key]?.trim(), `example missing ${key}`);
            }
          }
        }
      });

      test("each comprehension beat has one correct answer and notes on all options", () => {
        for (const check of checks) {
          assert.ok(check.options.length >= 3, "too few options");
          assert.equal(
            check.options.filter((o) => o.correct).length,
            1,
            `"${check.prompt}" must have exactly one correct option`,
          );
          for (const option of check.options) {
            assert.ok(option.note?.trim(), `option "${option.text}" has no note`);
          }
          assert.ok(check.explain?.trim(), "check has no explain");
        }
      });

      // Options are shuffled at render, so seed position has no effect on the
      // reader. This is a writing check: parking the answer in the same slot
      // every time is a sign the options were written to a formula rather than
      // as four genuinely plausible choices.
      test("correct answers are not all written into the same slot", () => {
        if (checks.length < 3) return;

        const positions = checks.map((c) =>
          c.options.findIndex((o) => o.correct),
        );
        const spread = new Set(positions);

        assert.ok(
          spread.size > 1,
          `every correct answer sits at index ${positions[0]}. Vary where the right option is written.`,
        );

        const commonest = Math.max(
          ...[...spread].map((p) => positions.filter((q) => q === p).length),
        );
        assert.ok(
          commonest <= Math.ceil(checks.length * 0.6),
          `${commonest} of ${checks.length} correct answers share one position`,
        );
      });

      // A mission is one real conversation. Across 45 lessons, asking for
      // three each turns the curriculum into 135 reps and makes every mission
      // read as a chore.
      test("missions ask for one conversation, not several", () => {
        const sql = readFileSync(join(MIGRATIONS, file), "utf8");
        const missions = [...sql.matchAll(/\$md\$([^$]*?)\$md\$/g)]
          .map(([, text]) => text.trim())
          .filter((text) => /\blog\b/i.test(text) && text.length < 400);

        for (const mission of missions) {
          assert.ok(
            !/\b(three|four|five)\s+(conversations|people)\b/i.test(mission),
            `mission asks for several conversations: "${mission.slice(0, 80)}…"`,
          );
        }
      });

      test("rubric criteria keys are present and unique", () => {
        for (const rubric of rubrics) {
          assert.ok(rubric.criteria.length > 0);
          assert.ok(rubric.scale?.min != null && rubric.scale?.max != null);
          const keys = rubric.criteria.map((c) => c.key);
          assert.equal(new Set(keys).size, keys.length, "duplicate criterion key");
          for (const c of rubric.criteria) {
            for (const key of ["key", "label", "description"] as const) {
              assert.ok(c[key]?.trim(), `criterion missing ${key}`);
            }
          }
        }
      });

      // The brief is explicit that openness must be honoured, and that the
      // partner must never coach the user mid-scene.
      test("scenario partners have a valid openness and never coach", () => {
        for (const scenario of scenarios) {
          const { openness, name } = scenario.partner;
          assert.ok(
            Number.isInteger(openness) && openness >= 1 && openness <= 5,
            `${name}: openness ${openness} would violate the CHECK constraint`,
          );
          for (const key of ["name", "role", "personality", "mood"] as const) {
            assert.ok(scenario.partner[key]?.trim(), `partner missing ${key}`);
          }
          for (const key of [
            "setting",
            "opening_beat",
            "success_looks_like",
          ] as const) {
            assert.ok(scenario[key]?.trim(), `scenario missing ${key}`);
          }
          assert.ok(
            scenario.constraints.some((c) => /never coach/i.test(c)),
            `${name}: scenario must tell the partner never to coach mid-scene`,
          );
        }
      });
    });
  }
});
