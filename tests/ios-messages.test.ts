// The iOS app reads the website's translations, so a key the app asks for that the catalog
// does not have shows the reader a bare "lineDrill.sayIt" — and one missing from Spanish
// quietly shows English. Neither throws, and neither is caught until someone sees it.
//
// There is no Mac in this workflow to run the app, so the check is done here, on the source:
// every literal key the Swift code passes to the catalog must exist in both languages.

import { describe, test } from "node:test";
import assert from "node:assert/strict";
import { readdirSync, readFileSync, statSync } from "node:fs";
import { join } from "node:path";

import en from "../src/messages/en.json" with { type: "json" };
import es from "../src/messages/es.json" with { type: "json" };

const IOS_SOURCES = join(import.meta.dirname, "..", "ios", "Reps");

function swiftFiles(dir: string): string[] {
  return readdirSync(dir).flatMap((name) => {
    const path = join(dir, name);
    return statSync(path).isDirectory() ? swiftFiles(path) : path.endsWith(".swift") ? [path] : [];
  });
}

function flatten(object: Record<string, unknown>, prefix = ""): Set<string> {
  const keys = new Set<string>();
  for (const [key, value] of Object.entries(object)) {
    const path = prefix ? `${prefix}.${key}` : key;
    if (typeof value === "string") keys.add(path);
    else if (value && typeof value === "object") {
      for (const nested of flatten(value as Record<string, unknown>, path)) keys.add(nested);
    }
  }
  return keys;
}

const enKeys = flatten(en);
const esKeys = flatten(es);

// `.t("a.b")`, `Messages.text("a.b"` and `Messages.rich("a.b"`. A key built with string
// interpolation cannot be checked statically, so the app does not build them — see below.
const KEY_CALL = /(?:\.t|Messages\.text|Messages\.rich)\(\s*"([^"]+)"/g;

describe("the keys the iOS app asks the catalog for", () => {
  const used: { file: string; key: string }[] = [];
  for (const file of swiftFiles(IOS_SOURCES)) {
    const source = readFileSync(file, "utf8");
    for (const [, key] of source.matchAll(KEY_CALL)) {
      used.push({ file: file.replace(IOS_SOURCES, "ios/Reps"), key });
    }
  }

  test("there are keys to check", () => {
    assert.ok(used.length > 0, "found no catalog keys in the Swift sources");
  });

  test("none is built by interpolation, which cannot be checked", () => {
    for (const { file, key } of used) {
      assert.ok(!key.includes("\\("), `${file}: "${key}" is built at runtime — spell out each key`);
    }
  });

  test("every key exists in English", () => {
    for (const { file, key } of used) {
      assert.ok(enKeys.has(key), `${file}: "${key}" is not in src/messages/en.json`);
    }
  });

  test("every key exists in Spanish", () => {
    for (const { file, key } of used) {
      assert.ok(esKeys.has(key), `${file}: "${key}" is not in src/messages/es.json`);
    }
  });
});
