// "Fall back to English" has two plausible meanings and only one of them lets
// a language ship before it is finished. These pin down which one is built.

import { describe, test } from "node:test";
import assert from "node:assert/strict";

import {
  asLocale,
  byId,
  DEFAULT_LOCALE,
  isLocale,
  localise,
  LOCALES,
  LOCALE_NAMES,
} from "../src/lib/curriculum/locale.ts";

describe("which languages exist", () => {
  test("English is the default and is one of them", () => {
    assert.ok(LOCALES.includes(DEFAULT_LOCALE));
    assert.equal(DEFAULT_LOCALE, "en");
  });

  test("every language is named in itself", () => {
    for (const locale of LOCALES) {
      assert.ok(LOCALE_NAMES[locale]?.trim(), `${locale} has no name`);
    }
    // The point of naming them this way: a Spanish reader scans for Español.
    assert.equal(LOCALE_NAMES.es, "Español");
    assert.equal(LOCALE_NAMES.de, "Deutsch");
  });

  test("only the supported ones are locales", () => {
    assert.ok(isLocale("es"));
    assert.ok(!isLocale("fr"));
    assert.ok(!isLocale(""));
    assert.ok(!isLocale(null));
  });

  // Anything unrecognised has to read as English rather than throw: this value
  // arrives from a form and from client-written signup metadata.
  test("anything unrecognised reads as English", () => {
    assert.equal(asLocale("de"), "de");
    assert.equal(asLocale("fr"), "en");
    assert.equal(asLocale(undefined), "en");
    assert.equal(asLocale(42), "en");
  });
});

describe("laying a translation over the English", () => {
  const base = { name: "Small talk", promise: "Walk into a room", sort_order: 1 };

  test("a translated field wins", () => {
    const out = localise(base, { name: "Charla" });
    assert.equal(out.name, "Charla");
  });

  // The whole reason for per-field rather than per-row: a topic with a
  // translated name and an untranslated promise shows the Spanish name.
  test("an untranslated field falls back on its own", () => {
    const out = localise(base, { name: "Charla", promise: null });
    assert.equal(out.name, "Charla");
    assert.equal(out.promise, "Walk into a room");
  });

  test("a missing translation leaves everything English", () => {
    assert.deepEqual(localise(base, null), base);
    assert.deepEqual(localise(base, undefined), base);
    assert.deepEqual(localise(base, {}), base);
  });

  // An empty string is what a half-finished translation looks like. Treating it
  // as a translation would blank a heading rather than fall back to English.
  test("an empty translation is not a translation", () => {
    const out = localise(base, { name: "", promise: "   " });
    assert.equal(out.name, "Small talk");
    assert.equal(out.promise, "Walk into a room");
  });

  test("fields the translation does not mention are untouched", () => {
    const out = localise(base, { name: "Charla" });
    assert.equal(out.sort_order, 1);
  });

  test("the original is not mutated", () => {
    localise(base, { name: "Charla" });
    assert.equal(base.name, "Small talk");
  });

  // JSON columns carry structure the app parses, so they are replaced whole
  // rather than merged key by key.
  test("a json field is replaced whole", () => {
    const withJson = { checks_json: [{ prompt: "why?" }] };
    const out = localise(withJson, { checks_json: [{ prompt: "por que?" }] });
    assert.deepEqual(out.checks_json, [{ prompt: "por que?" }]);
  });

  test("a false or zero translation still counts", () => {
    const out = localise({ flag: true, n: 5 }, { flag: false, n: 0 });
    assert.equal(out.flag, false);
    assert.equal(out.n, 0);
  });
});

describe("indexing translation rows", () => {
  test("rows come back keyed by their id column", () => {
    const index = byId(
      [
        { topic_id: "a", name: "Charla" },
        { topic_id: "b", name: "Entrevistas" },
      ],
      "topic_id",
    );
    assert.equal(index.get("a")?.name, "Charla");
    assert.equal(index.size, 2);
  });

  test("nothing to index is an empty map, not a crash", () => {
    assert.equal(byId(null, "topic_id").size, 0);
    assert.equal(byId(undefined, "topic_id").size, 0);
  });
});
