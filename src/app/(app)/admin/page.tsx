import { BackLink } from "@/components/back-link";
import { requireAdmin, type Theme } from "@/lib/auth/dal";
import { createAdminClient } from "@/lib/supabase/admin";
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
  createdAt: string;
};

export default async function AdminPage() {
  const actor = await requireAdmin();
  const admin = createAdminClient();

  // Email lives on the auth user and everything else lives on the profile, so
  // the list is a merge. Paged high rather than paginated: this is a personal
  // app, and a page of controls nobody can find is worse than a long list.
  const [{ data: authUsers }, { data: profiles }, { data: roster }] =
    await Promise.all([
      admin.auth.admin.listUsers({ page: 1, perPage: 200 }),
      admin
        .from("profiles")
        .select("id, display_name, theme, blocked_at, blocked_reason"),
      admin.from("admins").select("user_id"),
    ]);

  const byId = new Map(
    (profiles ?? []).map((p) => [p.id as string, p] as const),
  );
  const adminIds = new Set((roster ?? []).map((r) => r.user_id as string));

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
