// The printable page per topic, and the sheets the migrations author.
//
// A cheat sheet is the one thing in the curriculum that is curated rather than
// assembled, which means nothing else can catch it drifting. So the shape is
// asserted here: that every group names a real skill, that the sheet is short
// enough to be a sheet, and that nothing on it is a heading with no body.

import { describe, test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

import {
  asCheatSheet,
  countConcepts,
  layOut,
  type CheatSheet,
} from "../src/lib/curriculum/cheat-sheet.ts";

const MIGRATIONS = join(import.meta.dirname, "..", "supabase", "migrations");

describe("laying a cheat sheet out", () => {
  const sheet: CheatSheet = {
    idea: "An idea.",
    groups: [
      { skill: "third", concepts: [{ name: "C", body: "c" }] },
      { skill: "first", concepts: [{ name: "A", body: "a" }] },
      { skill: "gone", concepts: [{ name: "X", body: "x" }] },
      { skill: "empty", concepts: [] },
    ],
  };

  const skills = [
    { slug: "first", name: "First skill", sort_order: 1 },
    { slug: "empty", name: "Empty skill", sort_order: 2 },
    { slug: "third", name: "Third skill", sort_order: 3 },
  ];

  test("groups come out in curriculum order, not authoring order", () => {
    assert.deepEqual(
      layOut(sheet, skills).map((g) => g.heading),
      ["First skill", "Third skill"],
    );
  });

  test("headings come from the skill, so renaming a track updates the sheet", () => {
    const renamed = [{ slug: "first", name: "Renamed", sort_order: 1 }];
    assert.equal(layOut(sheet, renamed)[0].heading, "Renamed");
  });

  test("a group naming a skill that no longer exists is dropped", () => {
    assert.ok(!layOut(sheet, skills).some((g) => g.heading.includes("gone")));
  });

  test("a group with nothing in it does not print a bare heading", () => {
    assert.ok(!layOut(sheet, skills).some((g) => g.concepts.length === 0));
  });

  test("a sheet that is not a sheet parses as nothing", () => {
    assert.equal(asCheatSheet(null), null);
    assert.equal(asCheatSheet({}), null);
    assert.equal(asCheatSheet({ idea: "x" }), null);
    assert.equal(asCheatSheet({ idea: "x", groups: [] }), null);
    assert.ok(asCheatSheet({ idea: "x", groups: [{ skill: "a", concepts: [] }] }));
  });
});

/** Every cheat sheet the migrations write, by the topic it belongs to. */
function authoredSheets(): { topic: string; sheet: CheatSheet }[] {
  const found: { topic: string; sheet: CheatSheet }[] = [];

  for (const file of readdirSync(MIGRATIONS).filter((f) => f.endsWith(".sql"))) {
    const sql = readFileSync(join(MIGRATIONS, file), "utf8");

    for (const match of sql.matchAll(
      /cheatsheet_json = \$j\$([\s\S]*?)\$j\$::jsonb\s*\nwhere slug = '([a-z0-9-]+)'/g,
    )) {
      const sheet = asCheatSheet(JSON.parse(match[1]));
      assert.ok(sheet, `${match[2]} has a cheat sheet that does not parse`);
      found.push({ topic: match[2], sheet: sheet! });
    }
  }

  return found;
}

describe("the cheat sheets the curriculum ships", () => {
  const sheets = authoredSheets();

  test("there is at least one, and it was actually parsed", () => {
    assert.ok(sheets.length > 0, "no cheat sheet found in any migration");
    assert.ok(sheets.some((s) => s.topic === "small-talk"));
  });

  test("a sheet is between ten and twenty concepts", () => {
    // Below ten it is not worth printing. Above twenty it stops being
    // something you can hold and becomes the syllabus again.
    for (const { topic, sheet } of sheets) {
      const n = countConcepts(sheet);
      assert.ok(n >= 10 && n <= 20, `${topic} has ${n} concepts`);
    }
  });

  test("every concept has a name short enough to scan and a body worth reading", () => {
    for (const { topic, sheet } of sheets) {
      for (const group of sheet.groups) {
        for (const concept of group.concepts) {
          assert.ok(
            concept.name?.trim() && concept.name.length <= 45,
            `${topic}: "${concept.name}" is not a scannable heading`,
          );
          assert.ok(
            concept.body?.trim() && concept.body.length > 30,
            `${topic}: "${concept.name}" has no real body`,
          );
        }
      }
    }
  });

  test("the idea is a paragraph rather than a slogan", () => {
    for (const { topic, sheet } of sheets) {
      assert.ok(sheet.idea.length > 80, `${topic}'s idea is too thin to open with`);
    }
  });

  test("every group names a skill the topic migrations actually create", () => {
    // The one way this can silently rot: a sheet outliving a renamed track,
    // which would print a shorter sheet than the author wrote.
    const seeded = new Set<string>();
    for (const file of readdirSync(MIGRATIONS).filter((f) => f.endsWith(".sql"))) {
      const sql = readFileSync(join(MIGRATIONS, file), "utf8");
      for (const [, slug] of sql.matchAll(/'([a-z0-9-]+)',\s*\n\s*'[^']+',\n/g)) {
        seeded.add(slug);
      }
      for (const [, slug] of sql.matchAll(
        /from public\.skills where slug = '([a-z0-9-]+)'/g,
      )) {
        seeded.add(slug);
      }
    }

    for (const { topic, sheet } of sheets) {
      for (const group of sheet.groups) {
        assert.ok(
          seeded.has(group.skill),
          `${topic} has a group for "${group.skill}", which no migration seeds`,
        );
      }
    }
  });
});
