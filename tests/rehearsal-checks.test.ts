// The checks a drill is marked by, and the rules the authored drills have to
// obey. The second half matters more than the first: a check that no line can
// satisfy would fail silently in production, since the only symptom is a
// learner who cannot get a tick and assumes the fault is theirs.

import { describe, test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

import { checkLine, type LineCheck } from "../src/lib/roleplay/checks.ts";
import {
  REHEARSAL_MODES,
  asBeatSpec,
  asChoiceSpec,
  asLineSpec,
} from "../src/lib/roleplay/modes.ts";

describe("checking one rehearsed line", () => {
  test("an empty check list always lands", () => {
    assert.equal(checkLine("anything at all", []).landed, true);
  });

  test("a question mark is caught wherever it sits", () => {
    const checks: LineCheck[] = [{ kind: "no_question", requirement: "No question mark" }];
    assert.equal(checkLine("That is a serious apron.", checks).landed, true);
    assert.equal(checkLine("Is that an apron?", checks).landed, false);
    assert.equal(checkLine("Nice apron? I think.", checks).landed, false);
  });

  test("words are counted, not characters", () => {
    const checks: LineCheck[] = [{ kind: "max_words", requirement: "Under six", n: 6 }];
    assert.equal(checkLine("Brutal.", checks).landed, true);
    assert.equal(checkLine("one two three four five six", checks).landed, true);
    assert.equal(checkLine("one two three four five six seven", checks).landed, false);
  });

  test("sentences are counted the way a person would", () => {
    const checks: LineCheck[] = [{ kind: "max_sentences", requirement: "One line", n: 1 }];
    // No terminator at all is still one sentence, not none.
    assert.equal(checkLine("That machine is working hard", checks).landed, true);
    assert.equal(checkLine("That machine is working hard.", checks).landed, true);
    // A run of terminators is one ending, not three.
    assert.equal(checkLine("Really?!", checks).landed, true);
    assert.equal(checkLine("That machine. It is working hard.", checks).landed, false);
  });

  test("their word is found through case, punctuation and inflection", () => {
    const checks: LineCheck[] = [
      { kind: "contains_any", requirement: "Use their word", words: ["brutal", "quarter"] },
    ];
    assert.equal(checkLine("Brutal.", checks).landed, true);
    assert.equal(checkLine("brutally so", checks).landed, true);
    assert.equal(checkLine("Those quarters, then.", checks).landed, true);
    assert.equal(checkLine("That sounds hard.", checks).landed, false);
  });

  test("a short target has to match a whole word", () => {
    // Prefix matching below four characters would have "or" inside "ordinary".
    const checks: LineCheck[] = [
      { kind: "contains_any", requirement: "Use their word", words: ["or"] },
    ];
    assert.equal(checkLine("An ordinary Tuesday", checks).landed, false);
    assert.equal(checkLine("Terrifying or freeing", checks).landed, true);
  });

  test("a target with a space is matched as a phrase", () => {
    const checks: LineCheck[] = [
      { kind: "contains_any", requirement: "Offer it as a guess", words: ["sounds like"] },
    ];
    assert.equal(checkLine("That sounds like it stung.", checks).landed, true);
    assert.equal(checkLine("Sounds a lot like that.", checks).landed, false);
  });

  test("apostrophes do not hide a contraction", () => {
    const checks: LineCheck[] = [
      { kind: "no_first_person", requirement: "Do not turn it back to you" },
    ];
    assert.equal(checkLine("I've been there.", checks).landed, false);
    assert.equal(checkLine("I’ve been there.", checks).landed, false);
    assert.equal(checkLine("Sounds rough.", checks).landed, true);
  });

  test("first person is required and forbidden by two different checks", () => {
    const needs: LineCheck[] = [{ kind: "first_person", requirement: "Make it yours" }];
    const forbids: LineCheck[] = [{ kind: "no_first_person", requirement: "Keep out of it" }];

    assert.equal(checkLine("My week has been the same.", needs).landed, true);
    assert.equal(checkLine("That sounds hard.", needs).landed, false);
    assert.equal(checkLine("That sounds hard.", forbids).landed, true);
    assert.equal(checkLine("My week was the same.", forbids).landed, false);
  });

  test("a forbidden phrase names itself in the reason", () => {
    const checks: LineCheck[] = [
      { kind: "forbids_any", requirement: "Not the facts", words: ["how long"] },
    ];
    const verdict = checkLine("How long did that take?", checks);
    assert.equal(verdict.landed, false);
    assert.match(verdict.results[0].why ?? "", /how long/);
  });

  test("every requirement that missed is listed, and passed ones are not", () => {
    const checks: LineCheck[] = [
      { kind: "no_question", requirement: "No question mark" },
      { kind: "max_words", requirement: "Under six", n: 6 },
      { kind: "contains_any", requirement: "Use their word", words: ["brutal"] },
    ];
    const verdict = checkLine("Brutal?", checks);

    assert.deepEqual(verdict.missed, ["No question mark"]);
    assert.equal(verdict.results.length, 3);
    assert.equal(verdict.results.filter((r) => r.ok).length, 2);
    // Nobody needs telling why they were right.
    assert.equal(verdict.results[1].why, null);
  });
});

// ---------------------------------------------------------------------------
// The shipped curriculum, read out of the migration that authors it.
// ---------------------------------------------------------------------------

const MIGRATIONS = join(import.meta.dirname, "..", "supabase", "migrations");

type Authored = {
  skill: string;
  order: number;
  mode: string;
  spec: unknown;
};

function authoredModes(): Authored[] {
  const found: Authored[] = [];

  for (const file of readdirSync(MIGRATIONS).filter((f) => f.endsWith(".sql"))) {
    const sql = readFileSync(join(MIGRATIONS, file), "utf8");
    const pattern =
      /set_mode\('([^']+)',\s*(\d+),\s*'(\w+)',\s*(?:\$j\$([\s\S]*?)\$j\$::jsonb|null)\)/g;

    for (const match of sql.matchAll(pattern)) {
      found.push({
        skill: match[1],
        order: Number(match[2]),
        mode: match[3],
        spec: match[4] ? JSON.parse(match[4]) : null,
      });
    }
  }

  return found;
}

describe("the rehearsal modes the curriculum authors", () => {
  const authored = authoredModes();

  test("every lesson in the shipped topics has been given a mode", () => {
    // Nine skills of five lessons. A lesson with no mode falls back to an open
    // conversation, which is the wrong container for about half of them and is
    // exactly the state this work exists to end.
    assert.equal(authored.length, 45);
    assert.equal(new Set(authored.map((a) => `${a.skill}/${a.order}`)).size, 45);
  });

  test("every mode is one the app knows how to render", () => {
    for (const lesson of authored) {
      assert.ok(
        (REHEARSAL_MODES as readonly string[]).includes(lesson.mode),
        `${lesson.skill}/${lesson.order} has mode ${lesson.mode}`,
      );
    }
  });

  test("every drill parses as the shape its mode expects", () => {
    for (const lesson of authored) {
      const where = `${lesson.skill}/${lesson.order}`;

      if (lesson.mode === "line") {
        assert.ok(asLineSpec(lesson.spec), `${where} is not a usable line spec`);
      }
      if (lesson.mode === "beat") {
        assert.ok(asBeatSpec(lesson.spec), `${where} is not a usable beat spec`);
      }
      if (lesson.mode === "choice") {
        assert.ok(asChoiceSpec(lesson.spec), `${where} is not a usable choice spec`);
      }
    }
  });

  test("every line drill's model answer passes its own checks", () => {
    // The one assertion that stops a rule being written that nothing can
    // satisfy. If the answer the lesson itself proposes cannot get a tick,
    // no learner will either.
    for (const lesson of authored.filter((a) => a.mode === "line")) {
      const spec = asLineSpec(lesson.spec)!;
      const where = `${lesson.skill}/${lesson.order}`;

      assert.ok(spec.model, `${where} has no model answer`);

      const verdict = checkLine(spec.model!.line, spec.checks);
      assert.ok(
        verdict.landed,
        `${where} model answer "${spec.model!.line}" misses: ${verdict.missed.join("; ")}`,
      );
    }
  });

  test("a line drill states its requirements in words a person can act on", () => {
    for (const lesson of authored.filter((a) => a.mode === "line")) {
      const spec = asLineSpec(lesson.spec)!;
      for (const check of spec.checks) {
        assert.ok(
          check.requirement && check.requirement.length > 8,
          `${lesson.skill}/${lesson.order} has a requirement too short to mean anything`,
        );
      }
    }
  });

  test("every word a drill asks to be echoed is one the partner actually said", () => {
    // The claim `echoes_any` makes is that these words were put on the table.
    // A drill that asked a learner to pick up a word nobody said would be
    // unpassable, and the only symptom would be somebody assuming the fault
    // was theirs. Checked word by word rather than loosely: one available
    // target and four impossible ones is still a broken drill.
    for (const lesson of authored.filter((a) => a.mode === "line")) {
      const spec = asLineSpec(lesson.spec)!;
      const said = (spec.says ?? "").toLowerCase();

      for (const check of spec.checks) {
        if (check.kind !== "echoes_any") continue;

        assert.ok(
          spec.says,
          `${lesson.skill}/${lesson.order} asks for an echo of a beat it does not have`,
        );

        for (const word of check.words) {
          assert.ok(
            said.includes(word.toLowerCase()),
            `${lesson.skill}/${lesson.order} asks for "${word}", which is not in "${spec.says}"`,
          );
        }
      }
    }
  });

  test("every read-and-decide beat has exactly one right answer", () => {
    for (const lesson of authored.filter((a) => a.mode === "choice")) {
      const spec = asChoiceSpec(lesson.spec)!;
      const where = `${lesson.skill}/${lesson.order}`;

      for (const [i, beat] of spec.beats.entries()) {
        const correct = beat.options.filter((o) => o.correct);
        assert.equal(
          correct.length,
          1,
          `${where} beat ${i + 1} has ${correct.length} correct options`,
        );
        assert.ok(beat.options.length >= 3, `${where} beat ${i + 1} needs a real choice`);
      }
    }
  });

  test("every option explains itself, including the wrong ones", () => {
    // A wrong option with no note is an answer key. The reason is the lesson.
    for (const lesson of authored.filter((a) => a.mode === "choice")) {
      const spec = asChoiceSpec(lesson.spec)!;
      for (const beat of spec.beats) {
        for (const option of beat.options) {
          assert.ok(
            option.note && option.note.length > 30,
            `${lesson.skill}/${lesson.order}: "${option.text}" has no real explanation`,
          );
        }
      }
    }
  });

  test("a sequence drill is short enough to hold in your head", () => {
    for (const lesson of authored.filter((a) => a.mode === "beat")) {
      const spec = asBeatSpec(lesson.spec)!;
      const where = `${lesson.skill}/${lesson.order}`;

      assert.ok(spec.turns.length >= 2, `${where} is a sequence of one`);
      assert.ok(spec.turns.length <= 4, `${where} has stopped being a sequence`);

      for (const turn of spec.turns) {
        assert.ok(
          turn.instruction && turn.instruction.length > 15,
          `${where} has a turn with nothing useful to say`,
        );
      }
    }
  });

  test("the drills are where the beginner is, and the scenes are later", () => {
    // The argument for all of this: the foundational skills are drills and the
    // open conversations belong to the later tracks and to Dating. If a change
    // ever inverts that, the curriculum has stopped being a road.
    const early = ["openers", "going-deeper", "listening-and-labeling"];
    const drills = authored.filter(
      (a) => early.includes(a.skill) && (a.mode === "line" || a.mode === "beat"),
    );

    assert.ok(
      drills.length >= 12,
      `only ${drills.length} of the first three skills are drills`,
    );

    const dating = authored.filter((a) =>
      ["reading-disinterest", "flirting-calibration"].includes(a.skill),
    );
    assert.ok(
      dating.every((a) => a.mode === "scene" || a.mode === "choice"),
      "a Dating lesson has been reduced to a one-line drill",
    );
  });
});
