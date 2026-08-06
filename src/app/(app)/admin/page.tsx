import { BackLink } from "@/components/back-link";
import { requireAdmin, type Theme } from "@/lib/auth/dal";
import { adminIsConfigured, createAdminClient } from "@/lib/supabase/admin";
import { AddUser } from "./add-user";
import { UserRow } from "./user-row";

export const metadata = { title: "Users — Reps" };

export type ManagedUser = {
  id: string;
  email: string | null;
  displayName: string | null;
  theme: Theme;
  blockedAt: string | null;
  blockedReason: string | null;
  isAdmin: boolean;
  /** A live subscription row, however it got there. */
  isPro: boolean;
  createdAt: string;
};

export default async function AdminPage() {
  const actor = await requireAdmin();

  // Asked before the client is built. Without this the page throws during
  // render, and an error page at that moment names no environment variable
  // and offers no way forward — which is the whole failure mode this screen
  // has, because the key is set per environment and production is the one
  // most likely to be missing it.
  if (!adminIsConfigured()) return <NotConfigured />;

  const admin = createAdminClient();

  // Email lives on the auth user and everything else lives on the profile, so
  // the list is a merge. Paged high rather than paginated: this is a personal
  // app, and a page of controls nobody can find is worse than a long list.
  const [{ data: authUsers }, { data: profiles }, { data: roster }, { data: subs }] =
    await Promise.all([
      admin.auth.admin.listUsers({ page: 1, perPage: 200 }),
      admin
        .from("profiles")
        .select("id, display_name, theme, blocked_at, blocked_reason"),
      admin.from("admins").select("user_id"),
      admin
        .from("subscriptions")
        .select("user_id, status, current_period_end"),
    ]);

  const byId = new Map(
    (profiles ?? []).map((p) => [p.id as string, p] as const),
  );
  const adminIds = new Set((roster ?? []).map((r) => r.user_id as string));

  // The same three conditions the is_pro() function applies, because this list
  // should show what the database would answer rather than merely that a row
  // exists — a cancelled or lapsed subscription is a row too.
  const proIds = new Set(
    (subs ?? [])
      .filter(
        (s) =>
          ["active", "trialing"].includes(s.status as string) &&
          (!s.current_period_end ||
            new Date(s.current_period_end as string) > new Date()),
      )
      .map((s) => s.user_id as string),
  );

  const users: ManagedUser[] = (authUsers?.users ?? []).map((u) => {
    const profile = byId.get(u.id);
    return {
      id: u.id,
      email: u.email ?? null,
      displayName: (profile?.display_name as string | null) ?? null,
      theme: (profile?.theme as Theme) ?? "system",
      blockedAt: (profile?.blocked_at as string | null) ?? null,
      blockedReason: (profile?.blocked_reason as string | null) ?? null,
      isAdmin: adminIds.has(u.id),
      isPro: proIds.has(u.id),
      createdAt: u.created_at,
    };
  });

  users.sort((a, b) => (a.email ?? "").localeCompare(b.email ?? ""));

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink href="/settings" label="Settings" />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          Users
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          {users.length} {users.length === 1 ? "account" : "accounts"}. Admin
          access is granted in SQL, not here.
        </p>
      </header>

      <AddUser />

      <ol className="mt-2">
        {users.map((user) => (
          <UserRow key={user.id} user={user} isSelf={user.id === actor.id} />
        ))}
      </ol>
    </main>
  );
}

/**
 * Shown when the deployment has no secret key.
 *
 * Names the variable, because the person reading this is the person who can
 * set it, and "something went wrong" would send them to the logs to find out
 * what this sentence could have told them.
 */
function NotConfigured() {
  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink href="/settings" label="Settings" />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          Users
        </h1>
      </header>

      <div className="mt-8 rounded border border-[var(--flag)] bg-[var(--flag-soft)] p-5">
        <h2 className="text-sm font-semibold text-ink">
          Admin is not configured on this deployment
        </h2>
        <p className="mt-2 text-sm leading-relaxed text-ink">
          Managing users needs the Supabase secret key, and this environment
          does not have one. Set <code>SUPABASE_SECRET_KEY</code> and redeploy —
          environment variables are read at deploy time, so adding it without
          redeploying changes nothing.
        </p>
        <p className="mt-3 text-[13px] leading-relaxed text-ink-muted">
          Nothing else in the app depends on it. Your account and everyone
          else&rsquo;s are unaffected.
        </p>
      </div>
    </main>
  );
}
