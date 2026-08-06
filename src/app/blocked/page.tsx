import { redirect } from "next/navigation";

import { signOut } from "@/app/(auth)/actions";
import { getProfile, getSessionUser } from "@/lib/auth/dal";

export const metadata = { title: "Account blocked — Reps" };

/**
 * Deliberately outside the (app) group.
 *
 * requireUser sends blocked users here, and that layout calls requireUser, so
 * a page inside it would redirect to itself forever.
 */
export default async function BlockedPage() {
  const user = await getSessionUser();
  if (!user) redirect("/sign-in");

  const profile = await getProfile();
  // Nothing to see here once the block is lifted.
  if (!profile?.blocked_at) redirect("/today");

  return (
    <main className="mx-auto flex w-full max-w-md flex-col justify-center px-5 py-16">
      <h1 className="text-xl font-semibold tracking-tight text-ink">
        This account is blocked
      </h1>
      <p className="mt-3 text-sm leading-relaxed text-ink-muted">
        You cannot practise or log reps while the block is in place. Your
        history has not been deleted.
      </p>

      {/* Shown when there is one. An unexplained block is worse than a blunt
          one — the person cannot tell whether it was a mistake. */}
      {profile.blocked_reason ? (
        <p className="mt-4 rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm leading-relaxed text-ink">
          {profile.blocked_reason}
        </p>
      ) : null}

      <form action={signOut} className="mt-8">
        <button
          type="submit"
          className="rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper-raised)]"
        >
          Sign out
        </button>
      </form>
    </main>
  );
}
