import { after, before, describe, test } from "node:test";
import assert from "node:assert/strict";

import { createClient, type SupabaseClient } from "@supabase/supabase-js";

/**
 * The admin surface, checked from the database's side.
 *
 * These are the properties the UI cannot be trusted to hold. The admin screens
 * hide what they will not let you do, but hiding a button is not a control —
 * the only question that matters is what the database says when someone asks
 * it directly, which is what these ask.
 */

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const publishableKey = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
const secretKey = process.env.SUPABASE_SECRET_KEY;

const configured = Boolean(url && publishableKey && secretKey);
const password = "test-password-8chars!";

type TestUser = { id: string; client: SupabaseClient };

describe(
  "admin access and blocking",
  {
    skip: configured
      ? false
      : "Set NEXT_PUBLIC_SUPABASE_URL, NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY and SUPABASE_SECRET_KEY to run",
  },
  () => {
    const service = createClient(url!, secretKey!, {
      auth: { persistSession: false, autoRefreshToken: false },
    });

    let boss: TestUser;
    let member: TestUser;

    async function createUser(label: string): Promise<TestUser> {
      const email = `adm-${label}-${Date.now()}-${Math.random()
        .toString(36)
        .slice(2, 8)}@example.test`;

      const { data, error } = await service.auth.admin.createUser({
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
      boss = await createUser("boss");
      member = await createUser("member");

      // Granted here rather than through the app, which is the point: there is
      // no route to this table from the UI. The row dies with the user on
      // cleanup, by cascade, so a failed teardown cannot leave an admin behind.
      const { error } = await service
        .from("admins")
        .insert({ user_id: boss.id });
      if (error) throw error;
    });

    after(async () => {
      for (const user of [boss, member]) {
        if (user) await service.auth.admin.deleteUser(user.id);
      }
    });

    test("an ordinary user still cannot read anyone else's profile", async () => {
      // The admin read policy is an OR against the existing owner policy, so
      // this is the regression it could have caused.
      const { data } = await member.client
        .from("profiles")
        .select("id")
        .eq("id", boss.id);

      assert.deepEqual(data, []);
    });

    test("an admin can read every profile", async () => {
      const { data, error } = await boss.client
        .from("profiles")
        .select("id")
        .eq("id", member.id);

      assert.equal(error, null);
      assert.equal(data?.length, 1);
    });

    test("an ordinary user cannot read the roster", async () => {
      const { data } = await member.client.from("admins").select("user_id");
      assert.deepEqual(data, []);
    });

    test("an ordinary user cannot make themselves an admin", async () => {
      const { error } = await member.client
        .from("admins")
        .insert({ user_id: member.id });

      assert.notEqual(error, null, "there is no insert policy on admins");

      const { data } = await service
        .from("admins")
        .select("user_id")
        .eq("user_id", member.id);
      assert.deepEqual(data, [], "and nothing was written");
    });

    test("is_admin tells the two apart", async () => {
      const [asBoss, asMember] = await Promise.all([
        boss.client.rpc("is_admin"),
        member.client.rpc("is_admin"),
      ]);

      assert.equal(asBoss.data, true);
      assert.equal(asMember.data, false);
    });

    test("a blocked user cannot unblock themselves", async () => {
      // The hole this closes: the owner policy lets someone update their own
      // profile row, and blocked_at lives on that row. Without column-level
      // grants, being blocked is a state the blocked person can edit.
      await service
        .from("profiles")
        .update({ blocked_at: new Date().toISOString(), blocked_reason: "test" })
        .eq("id", member.id);

      await member.client
        .from("profiles")
        .update({ blocked_at: null, blocked_reason: null })
        .eq("id", member.id);

      const { data } = await service
        .from("profiles")
        .select("blocked_at")
        .eq("id", member.id)
        .single();

      assert.notEqual(
        data?.blocked_at,
        null,
        "a user must not be able to clear their own block",
      );
    });

    test("a user can still change their own theme", async () => {
      // The other half of the same fix: locking down the columns must not lock
      // down the ones the settings screen is for.
      const { error } = await member.client
        .from("profiles")
        .update({ theme: "dark" })
        .eq("id", member.id);

      assert.equal(error, null);

      const { data } = await service
        .from("profiles")
        .select("theme")
        .eq("id", member.id)
        .single();
      assert.equal(data?.theme, "dark");
    });
  },
);
