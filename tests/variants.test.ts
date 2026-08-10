// Which version of a lesson someone is shown.
//
// The failure here is silent and expensive: a matcher that is slightly too
// eager shows a man a passage written for women, and nobody reports that —
// they conclude the app does not know what it is talking about and stop
// trusting the rest of it.

import { describe, test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

import type { AgeGroup } from "../src/lib/profile/demographics.ts";
import {
  partnerSexFor,
  pickVariant,
  scenarioFor,
  scoreVariant,
  type Audience,
  type LessonVariant,
} from "../src/lib/curriculum/variants.ts";

const MIGRATIONS = join(import.meta.dirname, "..", "supabase", "migrations");

const nobody: Audience = { sex: null, ageGroup: null, datingInterest: null };

const manIntoWomen: Audience = {
  sex: "male",
  ageGroup: "25-34",
  datingInterest: "women",
};

const womanIntoMen: Audience = {
  sex: "female",
  ageGroup: "35-44",
  datingInterest: "men",
};

const forMen: LessonVariant = {
  when: { sex: "male", dating_interest: "women" },
  label: "If you are a man",
  note_md: "…",
};

const forWomen: LessonVariant = {
  when: { sex: "female", dating_interest: "men" },
  label: "If you are a woman",
  note_md: "…",
};

const forAnyoneDatingWomen: LessonVariant = {
  when: { dating_interest: "women" },
  label: "If you date women",
  note_md: "…",
};

/**
 * Every variant the migrations author.
 *
 * These are parsed by nothing else in the suite, and the way they fail is
 * silent in the worst direction: a `when` with a key the matcher does not know
 * scores zero, never wins, and the passage simply never appears. Nobody
 * reports a paragraph they were never shown.
 */
function authoredVariants(): { where: string; variant: LessonVariant }[] {
  const out: { where: string; variant: LessonVariant }[] = [];

  for (const file of readdirSync(MIGRATIONS).filter((f) => f.endsWith(".sql"))) {
    const sql = readFileSync(join(MIGRATIONS, file), "utf8");

    for (const [, raw] of sql.matchAll(
      /variants_json = \$j\$([\s\S]*?)\$j\$::jsonb/g,
    )) {
      let parsed;
      try {
        parsed = JSON.parse(raw);
      } catch (err) {
        assert.fail(`${file}: variants_json is not valid JSON — ${(err as Error).message}`);
      }
      assert.ok(Array.isArray(parsed), `${file}: variants_json is not an array`);
      for (const variant of parsed as LessonVariant[]) {
        out.push({ where: `${file} — ${variant.label}`, variant });
      }
    }
  }

  return out;
}

const KNOWN_CONDITIONS = new Set([
  "sex",
  "dating_interest",
  "age_group",
  "age_groups",
]);

const BANDS = new Set<AgeGroup>([
  "18-24",
  "25-34",
  "35-44",
  "45-54",
  "55-64",
  "65+",
]);

describe("the variants the curriculum ships", () => {
  const authored = authoredVariants();

  test("there are variants to check", () => {
    assert.ok(authored.length >= 10, `only found ${authored.length}`);
  });

  test("every condition is one the matcher knows", () => {
    for (const { where, variant } of authored) {
      for (const key of Object.keys(variant.when ?? {})) {
        assert.ok(
          KNOWN_CONDITIONS.has(key),
          `${where}: "${key}" is not a condition scoreVariant reads, so this variant can never be shown`,
        );
      }
    }
  });

  test("every age band is one the enum allows", () => {
    for (const { where, variant } of authored) {
      const bands = [
        ...(variant.when.age_group ? [variant.when.age_group] : []),
        ...(variant.when.age_groups ?? []),
      ];
      for (const band of bands) {
        assert.ok(BANDS.has(band), `${where}: "${band}" is not an age_group value`);
      }
      assert.ok(
        variant.when.age_groups?.length !== 0,
        `${where}: an empty age_groups matches nobody`,
      );
    }
  });

  test("every variant can actually be reached by somebody", () => {
    // The proof that the conditions are satisfiable at all. A variant nobody
    // matches is a paragraph that was written and will never be read.
    for (const { where, variant } of authored) {
      const bands = variant.when.age_groups ?? [variant.when.age_group ?? null];
      const reader: Audience = {
        sex: variant.when.sex ?? null,
        ageGroup: bands[0],
        datingInterest: variant.when.dating_interest ?? null,
      };
      const score = scoreVariant(variant.when, reader);
      assert.ok(
        score !== null && score > 0,
        `${where}: no reader can match this — pickVariant requires a score above zero`,
      );
    }
  });

  test("every variant says who it is for and adds something", () => {
    for (const { where, variant } of authored) {
      assert.ok(variant.label?.trim(), `${where}: no label for whoever edits the seed`);
      assert.ok(
        variant.note_md?.trim() || variant.examples_json || variant.partner_sex,
        `${where}: matches a reader and then changes nothing`,
      );
    }
  });
});

const forEarlyCareer: LessonVariant = {
  when: { age_groups: ["18-24", "25-34"] },
  label: "If you are early on",
  note_md: "…",
};

const forLateCareer: LessonVariant = {
  when: { age_groups: ["45-54", "55-64", "65+"] },
  label: "If you are further along",
  note_md: "…",
};

// Work does not vary by age, it varies by standing in the room, and that
// spans two or three bands at a time. These check the span behaves like every
// other condition: a miss when unanswered, and weaker than naming one band.
describe("matching a reader to a span of age bands", () => {
  const young: Audience = { sex: null, ageGroup: "25-34", datingInterest: null };
  const older: Audience = { sex: null, ageGroup: "55-64", datingInterest: null };
  const middle: Audience = { sex: null, ageGroup: "35-44", datingInterest: null };

  test("a reader inside the span matches it", () => {
    assert.equal(pickVariant([forEarlyCareer, forLateCareer], young), forEarlyCareer);
    assert.equal(pickVariant([forEarlyCareer, forLateCareer], older), forLateCareer);
  });

  // The band deliberately left out of both spans. Whoever wrote the general
  // lesson wrote it for these readers, and they must still get it.
  test("a reader between the spans gets the lesson as written", () => {
    assert.equal(pickVariant([forEarlyCareer, forLateCareer], middle), null);
  });

  test("a reader who gave no band matches nothing", () => {
    assert.equal(pickVariant([forEarlyCareer, forLateCareer], nobody), null);
    assert.equal(scoreVariant({ age_groups: ["25-34"] }, nobody), null);
  });

  test("an exact band beats a span containing it", () => {
    const forOneBand: LessonVariant = {
      when: { age_group: "25-34" },
      label: "If you are 25 to 34",
    };
    assert.equal(
      pickVariant([forEarlyCareer, forOneBand], young),
      forOneBand,
      "naming the band is more specific than naming a range around it",
    );
  });

  test("an empty span matches nobody rather than everybody", () => {
    assert.equal(scoreVariant({ age_groups: [] }, young), null);
  });

  test("a span combines with the other conditions", () => {
    const both: LessonVariant = {
      when: { sex: "male", age_groups: ["18-24", "25-34"] },
      label: "Both",
    };
    assert.equal(pickVariant([both], manIntoWomen), both);
    assert.equal(
      pickVariant([both], { ...manIntoWomen, ageGroup: "55-64" }),
      null,
      "the span still has to hold",
    );
  });
});

describe("matching a reader to a variant", () => {
  // The single most important case. The general lesson is correct for
  // everybody, which is why it is the general lesson — so an unanswered
  // question must never be treated as a match.
  test("someone who answered nothing gets the lesson as written", () => {
    assert.equal(pickVariant([forMen, forWomen], nobody), null);
    assert.equal(scoreVariant({ sex: "male" }, nobody), null);
  });

  test("a reader gets their own variant and not the other one", () => {
    assert.equal(pickVariant([forMen, forWomen], manIntoWomen), forMen);
    assert.equal(pickVariant([forMen, forWomen], womanIntoMen), forWomen);
  });

  test("a lesson with no variants renders as written", () => {
    assert.equal(pickVariant([], manIntoWomen), null);
    assert.equal(pickVariant(null, manIntoWomen), null);
    assert.equal(pickVariant(undefined, manIntoWomen), null);
  });

  test("the more specific variant wins", () => {
    const picked = pickVariant(
      [forAnyoneDatingWomen, forMen],
      manIntoWomen,
    );
    assert.equal(picked, forMen, "sex plus interest beats interest alone");
  });

  test("order decides between equally specific variants", () => {
    const a: LessonVariant = { when: { sex: "male" }, label: "A" };
    const b: LessonVariant = { when: { sex: "male" }, label: "B" };
    assert.equal(pickVariant([a, b], manIntoWomen), a);
  });

  // "Both" is genuinely part of the audience for either passage, so it should
  // match one — but an explicitly written "both" variant has to beat it.
  test("someone who dates both matches a single-sex variant weakly", () => {
    const both: Audience = { sex: "male", ageGroup: null, datingInterest: "both" };

    assert.equal(pickVariant([forAnyoneDatingWomen], both), forAnyoneDatingWomen);

    const forBoth: LessonVariant = {
      when: { dating_interest: "both" },
      label: "If you date more than one sex",
    };
    assert.equal(
      pickVariant([forAnyoneDatingWomen, forBoth], both),
      forBoth,
      "an explicit both variant should win over a weak match",
    );
  });

  test("a wrong-sex variant is excluded, not merely outscored", () => {
    assert.equal(scoreVariant({ sex: "female" }, manIntoWomen), null);
    assert.equal(pickVariant([forWomen], manIntoWomen), null);
  });

  test("an empty condition set matches everybody, weakly", () => {
    assert.equal(scoreVariant({}, nobody), 0);
    // Zero is not greater than the starting score, so a variant with no
    // conditions never displaces the lesson as written.
    assert.equal(pickVariant([{ when: {}, label: "Everyone" }], nobody), null);
  });
});

describe("who the rehearsal partner should be", () => {
  test("comes from what the reader said, not from their own sex", () => {
    assert.equal(partnerSexFor(manIntoWomen, undefined), "female");
    assert.equal(partnerSexFor(womanIntoMen, undefined), "male");
  });

  // Inferring it from someone's own sex would be assuming they are straight,
  // and being wrong about that in a dating rehearsal is worse than the scene
  // being generic.
  test("falls back to the authored partner when they have not said", () => {
    const undeclared: Audience = {
      sex: "male",
      ageGroup: null,
      datingInterest: null,
    };
    assert.equal(partnerSexFor(undeclared, "female"), "female");
    assert.equal(partnerSexFor(undeclared, undefined), undefined);
  });

  test("someone who dates both keeps the authored partner", () => {
    const both: Audience = { sex: "female", ageGroup: null, datingInterest: "both" };
    assert.equal(partnerSexFor(both, "male"), "male");
  });
});

describe("putting the right person in the scene", () => {
  const scene = {
    setting: "A party.",
    opening_beat: "She looks up.",
    success_looks_like: "It goes somewhere.",
    constraints: [],
    partner: {
      name: "Wren",
      role: "a friend of the birthday person",
      personality: "Warm and engaged. Mirrors the register she is given.",
      mood: "Enjoying herself.",
      openness: 4,
      sex: "female" as const,
      alt: {
        name: "Wren",
        role: "a friend of the birthday person",
        personality: "Warm and engaged. Mirrors the register he is given.",
        mood: "Enjoying himself.",
        openness: 4,
        sex: "male" as const,
      },
    },
  };

  test("a reader who dates men gets the man", () => {
    const out = scenarioFor(scene, womanIntoMen);
    assert.equal(out.partner.sex, "male");
    assert.match(out.partner.mood, /himself/);
  });

  test("a reader who dates women keeps the scene as written", () => {
    const out = scenarioFor(scene, manIntoWomen);
    assert.equal(out.partner.sex, "female");
    assert.match(out.partner.mood, /herself/);
  });

  // Inferring it from somebody's own sex would be assuming they are straight.
  test("a reader who has said nothing gets the scene as written", () => {
    assert.equal(scenarioFor(scene, nobody).partner.sex, "female");
  });

  test("a reader who dates both keeps the scene as written", () => {
    const both: Audience = { sex: "male", ageGroup: null, datingInterest: "both" };
    assert.equal(scenarioFor(scene, both).partner.sex, "female");
  });

  // Nothing downstream should be able to see a second character, least of all
  // the prompt — a partner who knows about their own alternate is one who can
  // mention it.
  test("the alternate never survives selection", () => {
    for (const audience of [nobody, manIntoWomen, womanIntoMen]) {
      assert.equal("alt" in scenarioFor(scene, audience).partner, false);
    }
  });

  test("a scene with no alternate is returned untouched", () => {
    const plain = { ...scene, partner: { ...scene.partner, alt: undefined } };
    assert.equal(scenarioFor(plain, womanIntoMen).partner.name, "Wren");
    assert.equal(scenarioFor(plain, womanIntoMen).partner.sex, "female");
  });

  test("a variant's partner_sex outranks the authored one", () => {
    const variant: LessonVariant = {
      when: { sex: "female", dating_interest: "men" },
      label: "Women approaching men",
      partner_sex: "male",
    };
    assert.equal(scenarioFor(scene, nobody, variant).partner.sex, "male");
  });
});
