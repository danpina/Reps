// The paywall, tested where it is actually enforced.
//
// Every assertion here is made with a real signed-in session against real
// policies, because a paywall that only exists in a React component is not a
// paywall — the lesson body is one API call away from anyone with an account.
// If these tests pass, the product cannot be read for free by talking to the
// database directly.

import { after, before, describe, test } from "node:test";
import assert from "node:assert/strict";

import { createClient, type SupabaseClient } from "@supabase/supabase-js";

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const publishableKey = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
const secretKey = process.env.SUPABASE_SECRET_KEY;

const configured = Boolean(url && publishableKey && secretKey);
const password = "test-password-8chars!";

type TestUser = { id: string; client: SupabaseClient };

describe(
  "entitlements",
  {
    skip: configured
      ? false
      : "Set NEXT_PUBLIC_SUPABASE_URL, NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY and SUPABASE_SECRET_KEY to run",
  },
  () => {
    const admin = createClient(url!, secretKey!, {
      auth: { persistSession: false, autoRefreshToken: false },
    });

    let free: TestUser;
    let paid: TestUser;

    async function createUser(label: string): Promise<TestUser> {
      const email = `ent-${label}-${Date.now()}-${Math.random()
        .toString(36)
        .slice(2, 8)}@example.test`;

      const { data, error } = await admin.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
        user_metadata: { display_name: label },
      });
      if (error) throw error;

      const client = createClient(url!, publishableKey!, {
        auth: { persistSession: false, autoRefreshToken: false },
      });
      const { error: signInError } = await client.auth.signInWithPassword({
        email,
        password,
      });
      if (signInError) throw signInError;

      return { id: data.user.id, client };
    }

    before(async () => {
      free = await createUser("free");
      paid = await createUser("paid");

      const { error } = await admin.from("subscriptions").insert({
        user_id: paid.id,
        status: "active",
        source: "manual",
      });
      if (error) throw error;
    });

    after(async () => {
      for (const user of [free, paid]) {
        if (user) await admin.auth.admin.deleteUser(user.id);
      }
    });

    test("the sample is the first two lessons of the first skill of each topic", async () => {
      const { data, error } = await free.client
        .from("lessons")
        .select("sort_order, skills(slug, sort_order, topics(slug))");

      assert.equal(error, null);
      assert.ok((data?.length ?? 0) > 0, "a free account can read nothing at all");

      for (const lesson of data ?? []) {
        const skill = lesson.skills as unknown as {
          slug: string;
          sort_order: number;
        };
        assert.equal(
          skill.sort_order,
          1,
          `${skill.slug} is not the first skill in its topic but is readable free`,
        );
        assert.ok(
          lesson.sort_order <= 2,
          `${skill.slug} lesson ${lesson.sort_order} is readable free`,
        );
      }
    });

    test("every topic that has content offers a sample", async () => {
      const { data: topics } = await admin
        .from("topics")
        .select("slug, skills(sort_order, lessons(id))");

      for (const topic of topics ?? []) {
        const skills = topic.skills as unknown as {
          sort_order: number;
          lessons: unknown[];
        }[];
        if (skills.length === 0) continue;

        const first = skills.find((s) => s.sort_order === 1);
        assert.ok(first, `${topic.slug} has skills but none in position 1`);
        assert.ok(
          first.lessons.length >= 2,
          `${topic.slug} opens with fewer than 2 lessons, so its free sample is short`,
        );
      }
    });

    test("a subscriber reads every lesson", async () => {
      const [{ count: all }, { count: mine }] = await Promise.all([
        admin.from("lessons").select("id", { count: "exact", head: true }),
        paid.client.from("lessons").select("id", { count: "exact", head: true }),
      ]);

      assert.ok((all ?? 0) > 0);
      assert.equal(mine, all);
    });

    test("locked titles stay visible so a lock can be shown", async () => {
      const [{ count: all }, { count: visible }] = await Promise.all([
        admin.from("lessons").select("id", { count: "exact", head: true }),
        free.client
          .from("lesson_index")
          .select("id", { count: "exact", head: true }),
      ]);

      assert.equal(visible, all);
    });

    test("the index carries no teaching, only titles", async () => {
      const { data, error } = await free.client
        .from("lesson_index")
        .select("*")
        .limit(1)
        .maybeSingle();

      assert.equal(error, null);
      for (const column of [
        "theory_md",
        "examples_json",
        "checks_json",
        "check_json",
        "rubric_json",
        "scenario_json",
        "mission_text",
      ]) {
        assert.ok(
          !(column in (data ?? {})),
          `lesson_index exposes ${column}, which is the thing being sold`,
        );
      }
    });

    test("a free account may start one rehearsal and no more", async () => {
      const { data: lesson } = await free.client
        .from("lessons")
        .select("id")
        .limit(1)
        .single();

      const first = await free.client
        .from("roleplays")
        .insert({ user_id: free.id, lesson_id: lesson!.id })
        .select("id");

      assert.equal(first.error, null, "the first rehearsal should be free");

      const second = await free.client
        .from("roleplays")
        .insert({ user_id: free.id, lesson_id: lesson!.id })
        .select("id");

      assert.notEqual(second.error, null, "the second rehearsal should be refused");

      // Cleaned up so the roleplay RLS suite is not looking at a stray scene.
      await admin.from("roleplays").delete().eq("user_id", free.id);
    });

    test("nobody can grant themselves a subscription", async () => {
      const insert = await free.client
        .from("subscriptions")
        .insert({ user_id: free.id, status: "active", source: "manual" })
        .select();

      assert.notEqual(insert.error, null, "a user inserted their own entitlement");

      const { data } = await admin
        .from("subscriptions")
        .select("user_id")
        .eq("user_id", free.id);

      assert.deepEqual(data, []);
    });

    test("a user cannot extend their own subscription", async () => {
      const far = new Date(Date.now() + 5 * 365 * 24 * 3600_000).toISOString();

      const { data } = await paid.client
        .from("subscriptions")
        .update({ current_period_end: far })
        .eq("user_id", paid.id)
        .select();

      // There is no update policy, so the row is invisible to an update and
      // nothing is written. Postgres reports that as zero rows rather than as
      // an error, which is why the row itself is checked afterwards.
      assert.deepEqual(data, []);

      const { data: row } = await admin
        .from("subscriptions")
        .select("current_period_end")
        .eq("user_id", paid.id)
        .single();

      assert.equal(row?.current_period_end, null);
    });

    test("a free account cannot read anyone else's subscription", async () => {
      const { data, error } = await free.client
        .from("subscriptions")
        .select("user_id");

      assert.equal(error, null);
      assert.deepEqual(data, []);
    });
  },
);
