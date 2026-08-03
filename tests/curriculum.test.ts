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
      const checks = blocks.filter(
        (b): b is Check => typeof b === "object" && b !== null && "prompt" in b,
      );
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
        assert.equal(checks.length, examples.length, "missing a check");
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
