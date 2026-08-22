// profiles revokes update and then grants it column by column, so that a
// blocked user cannot clear their own blocked_at. The cost of that design is
// that a new user-writable column needs a grant as well as a form, and
// forgetting one fails in the least helpful way available: PostgREST reports
// 42501 permission denied for the whole table, which reads like a row level
// security problem and is not one.
//
// That is exactly what happened when profiles.locale shipped with a settings
// form and no grant. This walks the migrations and the application code and
// fails if any column the app writes has not been granted.

import { describe, test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const ROOT = join(import.meta.dirname, "..");
const MIGRATIONS = join(ROOT, "supabase", "migrations");

/** Columns of profiles that authenticated may update, per the migrations. */
function grantedColumns(): Set<string> {
  const granted = new Set<string>();

  for (const file of readdirSync(MIGRATIONS).filter((f) => f.endsWith(".sql")).sort()) {
    const sql = readFileSync(join(MIGRATIONS, file), "utf8");

    // A wholesale revoke resets the set — that is how the pattern starts.
    if (/revoke\s+update\s+on\s+public\.profiles\s+from\s+authenticated/i.test(sql)) {
      granted.clear();
    }
    for (const [, cols] of sql.matchAll(
      /grant\s+update\s*\(([^)]*)\)\s*\n?\s*on\s+public\.profiles\s+to\s+authenticated/gi,
    )) {
      for (const c of cols.split(",")) granted.add(c.trim());
    }
  }

  return granted;
}

/** Columns the application writes to profiles through a user-scoped client. */
function writtenColumns(): { file: string; column: string }[] {
  const out: { file: string; column: string }[] = [];

  const walk = (dir: string) => {
    for (const entry of readdirSync(dir, { withFileTypes: true })) {
      const path = join(dir, entry.name);
      if (entry.isDirectory()) {
        walk(path);
        continue;
      }
      if (!/\.tsx?$/.test(entry.name)) continue;

      const src = readFileSync(path, "utf8");
      // Admin writes go through the secret key, which bypasses grants entirely.
      if (src.includes("createAdminClient")) continue;

      for (const [, body] of src.matchAll(
        /from\("profiles"\)\s*\n?\s*\.update\(\{([^}]*)\}/g,
      )) {
        for (const [, key] of body.matchAll(/([a-z_]+)\s*:/g)) {
          out.push({ file: path.slice(ROOT.length + 1), column: key });
        }
      }
    }
  };

  walk(join(ROOT, "src"));
  return out;
}

describe("what a user may write to their own profile", () => {
  const granted = grantedColumns();

  test("the column-by-column pattern is actually in force", () => {
    // If the revoke ever disappears, every column becomes writable again and
    // the rest of these assertions would pass while proving nothing.
    const revoked = readdirSync(MIGRATIONS).some((f) =>
      /revoke\s+update\s+on\s+public\.profiles\s+from\s+authenticated/i.test(
        readFileSync(join(MIGRATIONS, f), "utf8"),
      ),
    );
    assert.ok(revoked, "profiles no longer revokes update from authenticated");
    assert.ok(granted.size > 0, "no columns are granted at all");
  });

  test("blocked_at is never granted, which is the point of the pattern", () => {
    for (const column of ["blocked_at", "blocked_reason", "id"]) {
      assert.ok(
        !granted.has(column),
        `${column} is writable by its owner, which defeats blocking`,
      );
    }
  });

  test("every column the app writes has been granted", () => {
    const written = writtenColumns();
    assert.ok(written.length > 0, "found no profile writes to check");

    for (const { file, column } of written) {
      assert.ok(
        granted.has(column),
        `${file} writes profiles.${column}, which has no grant — the update ` +
          `will fail with 42501 permission denied. Add: grant update (${column}) ` +
          `on public.profiles to authenticated;`,
      );
    }
  });
});
