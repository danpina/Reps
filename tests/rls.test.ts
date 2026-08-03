import { after, before, describe, test } from "node:test";
import assert from "node:assert/strict";

import { createClient, type SupabaseClient } from "@supabase/supabase-js";

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

const configured = Boolean(url && anonKey && serviceKey);
const password = "test-password-8chars!";

type TestUser = {
  id: string;
  client: SupabaseClient;
};

describe(
  "profiles row level security",
  {
    skip: configured
      ? false
      : "Set NEXT_PUBLIC_SUPABASE_URL, NEXT_PUBLIC_SUPABASE_ANON_KEY and SUPABASE_SERVICE_ROLE_KEY to run",
  },
  () => {
    const admin = createClient(url!, serviceKey!, {
      auth: { persistSession: false, autoRefreshToken: false },
    });

    let alice: TestUser;
    let bob: TestUser;

    async function createUser(label: string): Promise<TestUser> {
      const email = `rls-${label}-${Date.now()}-${Math.random()
        .toString(36)
        .slice(2, 8)}@example.test`;

      const { data, error } = await admin.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
        user_metadata: { display_name: label },
      });
      if (error) throw error;

      const client = createClient(url!, anonKey!, {
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
      alice = await createUser("alice");
      bob = await createUser("bob");
    });

    after(async () => {
      for (const user of [alice, bob]) {
        if (user) await admin.auth.admin.deleteUser(user.id);
      }
    });

    test("creates a profile row automatically on signup", async () => {
      const { data, error } = await admin
        .from("profiles")
        .select("id, display_name")
        .eq("id", alice.id)
        .single();

      assert.equal(error, null);
      assert.equal(data?.display_name, "alice");
    });

    test("lets a user read their own profile", async () => {
      const { data, error } = await alice.client
        .from("profiles")
        .select("id")
        .eq("id", alice.id);

      assert.equal(error, null);
      assert.equal(data?.length, 1);
    });

    test("does not let user A read user B's profile", async () => {
      const { data, error } = await alice.client
        .from("profiles")
        .select("id")
        .eq("id", bob.id);

      assert.equal(error, null);
      assert.deepEqual(data, []);
    });

    test("does not leak other rows through an unfiltered select", async () => {
      const { data, error } = await alice.client.from("profiles").select("id");

      assert.equal(error, null);
      assert.deepEqual(data, [{ id: alice.id }]);
    });

    test("does not let user A update user B's profile", async () => {
      const { data } = await alice.client
        .from("profiles")
        .update({ display_name: "owned" })
        .eq("id", bob.id)
        .select();

      assert.deepEqual(data, []);

      const { data: bobRow } = await admin
        .from("profiles")
        .select("display_name")
        .eq("id", bob.id)
        .single();

      assert.equal(bobRow?.display_name, "bob");
    });

    test("does not let a user reassign their profile to another user", async () => {
      const { error } = await alice.client
        .from("profiles")
        .update({ id: bob.id })
        .eq("id", alice.id)
        .select();

      assert.notEqual(error, null);
    });

    test("rejects anonymous reads entirely", async () => {
      const anon = createClient(url!, anonKey!, {
        auth: { persistSession: false, autoRefreshToken: false },
      });

      const { data, error } = await anon.from("profiles").select("id");

      assert.equal(error, null);
      assert.deepEqual(data, []);
    });
  },
);
