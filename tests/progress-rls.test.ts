// Cross-user isolation for the Phase 3 tables. Every user-owned table gets the
// same treatment as profiles: A must not see, change or delete B's rows.

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
  "field log and progress row level security",
  {
    skip: configured
      ? false
      : "Set NEXT_PUBLIC_SUPABASE_URL, NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY and SUPABASE_SECRET_KEY to run",
  },
  () => {
    const admin = createClient(url!, secretKey!, {
      auth: { persistSession: false, autoRefreshToken: false },
    });

    let alice: TestUser;
    let bob: TestUser;
    let skillId: string;
    let bobLogId: string;

    async function createUser(label: string): Promise<TestUser> {
      const email = `prog-${label}-${Date.now()}-${Math.random()
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
      const { data: skill, error } = await admin
        .from("skills")
        .select("id")
        .eq("slug", "openers")
        .single();
      if (error) {
        throw new Error(
          `Could not read skills — has the curriculum migration been applied? ${error.message}`,
        );
      }
      skillId = skill.id;

      [alice, bob] = await Promise.all([createUser("alice"), createUser("bob")]);

      const { data: log, error: insertError } = await bob.client
        .from("field_logs")
        .insert({
          user_id: bob.id,
          skill_id: skillId,
          went: 2,
          reflection: "bob's private reflection",
          xp_awarded: 50,
        })
        .select("id")
        .single();

      if (insertError) {
        throw new Error(
          `Could not insert a field log — has the progress migration been applied? ${insertError.message}`,
        );
      }
      bobLogId = log.id;

      await bob.client.from("streaks").insert({
        user_id: bob.id,
        current: 4,
        longest: 9,
        last_active_date: "2026-08-03",
      });
    });

    after(async () => {
      for (const user of [alice, bob]) {
        if (user?.id) await admin.auth.admin.deleteUser(user.id);
      }
    });

    test("a user can read back their own field log", async () => {
      const { data, error } = await bob.client
        .from("field_logs")
        .select("id, reflection");

      assert.equal(error, null);
      assert.equal(data?.length, 1);
      assert.equal(data?.[0].reflection, "bob's private reflection");
    });

    test("does not let user A read user B's field logs", async () => {
      const { data, error } = await alice.client
        .from("field_logs")
        .select("id, reflection")
        .eq("id", bobLogId);

      assert.equal(error, null);
      assert.deepEqual(data, [], "alice must not see bob's reps");
    });

    test("an unfiltered select leaks nothing", async () => {
      const { data } = await alice.client.from("field_logs").select("id");
      assert.deepEqual(data, []);
    });

    test("does not let user A insert a log owned by user B", async () => {
      const { error } = await alice.client.from("field_logs").insert({
        user_id: bob.id,
        skill_id: skillId,
        went: 1,
      });

      assert.notEqual(error, null, "writing a row as another user must fail");
    });

    test("does not let user A edit user B's log", async () => {
      const { data } = await alice.client
        .from("field_logs")
        .update({ reflection: "tampered" })
        .eq("id", bobLogId)
        .select();

      assert.deepEqual(data, [], "no rows should be updated");

      const { data: after } = await bob.client
        .from("field_logs")
        .select("reflection")
        .eq("id", bobLogId)
        .single();

      assert.equal(after?.reflection, "bob's private reflection");
    });

    test("does not let user A delete user B's log", async () => {
      await alice.client.from("field_logs").delete().eq("id", bobLogId);

      const { count } = await bob.client
        .from("field_logs")
        .select("id", { count: "exact", head: true });

      assert.equal(count, 1, "bob's rep should survive");
    });

    test("does not let user A read user B's streak", async () => {
      const { data } = await alice.client
        .from("streaks")
        .select("current, longest");

      assert.deepEqual(data, [], "streaks are private");
    });

    test("does not let user A write skill state for user B", async () => {
      const { error } = await alice.client.from("user_skill_state").insert({
        user_id: bob.id,
        skill_id: skillId,
        xp: 9999,
        level: 10,
      });

      assert.notEqual(error, null);
    });

    test("does not let user A read user B's badges", async () => {
      const { data: badge, error } = await admin
        .from("badges")
        .select("id")
        .limit(1)
        .single();

      assert.equal(error, null, "the gamification migration must be applied");
      assert.ok(badge);

      await bob.client
        .from("user_badges")
        .insert({ user_id: bob.id, badge_id: badge.id });

      const { data } = await alice.client
        .from("user_badges")
        .select("badge_id");

      assert.deepEqual(data, [], "badges earned are private");
    });

    test("does not let user A award a badge to user B", async () => {
      const { data: badge } = await admin
        .from("badges")
        .select("id")
        .limit(1)
        .single();

      assert.ok(badge, "the gamification migration must be applied");

      const { error } = await alice.client
        .from("user_badges")
        .insert({ user_id: bob.id, badge_id: badge.id });

      assert.notEqual(error, null);
    });

    test("does not let user A rewrite user B's rep", async () => {
      const { data } = await alice.client
        .from("field_logs")
        .update({ rewrite: "tampered rewrite" })
        .eq("id", bobLogId)
        .select();

      assert.deepEqual(data, []);

      const { data: after } = await bob.client
        .from("field_logs")
        .select("rewrite")
        .eq("id", bobLogId)
        .single();

      assert.equal(after?.rewrite, null);
    });

    test("rejects anonymous reads of the field log", async () => {
      const anon = createClient(url!, publishableKey!, {
        auth: { persistSession: false, autoRefreshToken: false },
      });

      const { data } = await anon.from("field_logs").select("id");
      assert.deepEqual(data, []);
    });
  },
);
