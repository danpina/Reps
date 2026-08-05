// Cross-user isolation for the roleplay tables. Transcripts are the most
// personal thing in the app after the field log.

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
  "roleplay row level security",
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
    let lessonId: string;
    let bobRoleplayId: string;

    async function createUser(label: string): Promise<TestUser> {
      const email = `rp-${label}-${Date.now()}-${Math.random()
        .toString(36)
        .slice(2, 8)}@example.test`;

      const { data, error } = await admin.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
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
      const { data: lesson, error } = await admin
        .from("lessons")
        .select("id")
        .limit(1)
        .single();
      if (error) throw new Error(`Could not read lessons: ${error.message}`);
      lessonId = lesson.id;

      [alice, bob] = await Promise.all([createUser("alice"), createUser("bob")]);

      const { data: rp, error: insertError } = await bob.client
        .from("roleplays")
        .insert({
          user_id: bob.id,
          lesson_id: lessonId,
          transcript_json: [
            { role: "user", content: "bob's private line", at: "2026-08-05T12:00:00Z" },
          ],
        })
        .select("id")
        .single();

      if (insertError) {
        throw new Error(
          `Could not insert a roleplay — has the roleplay migration been applied? ${insertError.message}`,
        );
      }
      bobRoleplayId = rp.id;

      await bob.client
        .from("ai_requests")
        .insert({ user_id: bob.id, kind: "partner_turn" });
    });

    after(async () => {
      for (const user of [alice, bob]) {
        if (user?.id) await admin.auth.admin.deleteUser(user.id);
      }
    });

    test("a user can read back their own transcript", async () => {
      const { data, error } = await bob.client
        .from("roleplays")
        .select("id, transcript_json");

      assert.equal(error, null);
      assert.equal(data?.length, 1);
    });

    test("does not let user A read user B's transcript", async () => {
      const { data } = await alice.client
        .from("roleplays")
        .select("id, transcript_json")
        .eq("id", bobRoleplayId);

      assert.deepEqual(data, [], "transcripts are private");
    });

    test("an unfiltered select leaks nothing", async () => {
      const { data } = await alice.client.from("roleplays").select("id");
      assert.deepEqual(data, []);
    });

    test("does not let user A start a roleplay owned by user B", async () => {
      const { error } = await alice.client.from("roleplays").insert({
        user_id: bob.id,
        lesson_id: lessonId,
      });

      assert.notEqual(error, null);
      assert.match(
        `${error?.code} ${error?.message}`,
        /42501|row-level security/i,
        "must be refused by RLS rather than a column constraint",
      );
    });

    test("does not let user A edit user B's transcript", async () => {
      const { data } = await alice.client
        .from("roleplays")
        .update({ transcript_json: [] })
        .eq("id", bobRoleplayId)
        .select();

      assert.deepEqual(data, []);

      const { data: after } = await bob.client
        .from("roleplays")
        .select("transcript_json")
        .eq("id", bobRoleplayId)
        .single();

      assert.equal(
        (after?.transcript_json as { content: string }[])[0].content,
        "bob's private line",
      );
    });

    test("does not let user A delete user B's roleplay", async () => {
      await alice.client.from("roleplays").delete().eq("id", bobRoleplayId);

      const { count } = await bob.client
        .from("roleplays")
        .select("id", { count: "exact", head: true });

      assert.equal(count, 1);
    });

    // The rate limit is counted from this table, so being able to read another
    // user's rows would leak their usage, and writing them would let one user
    // exhaust another's allowance.
    test("does not let user A see user B's ai request ledger", async () => {
      const { data } = await alice.client.from("ai_requests").select("id");
      assert.deepEqual(data, []);
    });

    test("does not let user A spend user B's allowance", async () => {
      const { error } = await alice.client
        .from("ai_requests")
        .insert({ user_id: bob.id, kind: "partner_turn" });

      assert.notEqual(error, null);
    });

    test("rejects anonymous reads of transcripts", async () => {
      const anon = createClient(url!, publishableKey!, {
        auth: { persistSession: false, autoRefreshToken: false },
      });
      const { data } = await anon.from("roleplays").select("id");
      assert.deepEqual(data, []);
    });
  },
);
