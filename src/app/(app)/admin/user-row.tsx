"use client";

import { useActionState } from "react";
import { useFormStatus } from "react-dom";

import type { ManagedUser } from "./page";
import { Feedback } from "./add-user";
import {
  blockUser,
  deleteUser,
  grantPro,
  revokePro,
  unblockUser,
  updateUserSettings,
  type AdminState,
} from "./actions";

/**
 * One account, with its controls folded away.
 *
 * Collapsed by default because the destructive ones live in here, and a list
 * of twenty accounts each showing a delete button is a list where the wrong
 * one gets clicked eventually.
 */
export function UserRow({
  user,
  isSelf,
}: {
  user: ManagedUser;
  isSelf: boolean;
}) {
  const blocked = Boolean(user.blockedAt);
  // Matches what the server will refuse, so the UI never offers an action
  // that is going to come back as an error. The server is still the check.
  const managed = !isSelf && !user.isAdmin;

  return (
    <li className="border-b border-rule">
      <details>
        <summary className="flex cursor-pointer flex-wrap items-baseline gap-x-3 gap-y-1 py-4 hover:bg-[var(--paper-raised)]">
          <span className="text-sm text-ink">{user.email ?? "no email"}</span>

          {user.isAdmin ? <Tag tone="accent">Admin</Tag> : null}
          {user.isPro && !user.isAdmin ? <Tag tone="accent">Pro</Tag> : null}
          {isSelf ? <Tag tone="muted">You</Tag> : null}
          {blocked ? <Tag tone="flag">Blocked</Tag> : null}

          <span className="tabular ml-auto text-xs text-ink-faint">
            {new Date(user.createdAt).toLocaleDateString(undefined, {
              day: "numeric",
              month: "short",
              year: "numeric",
            })}
          </span>
        </summary>

        <div className="flex flex-col gap-6 pb-6 pl-1">
          {user.blockedReason ? (
            <p className="text-[13px] leading-relaxed text-ink-muted">
              Reason given: {user.blockedReason}
            </p>
          ) : null}

          <SettingsForm user={user} />

          {user.isAdmin ? (
            <p className="text-[13px] leading-relaxed text-ink-muted">
              Admins have the whole product already, so there is nothing to
              grant here.
            </p>
          ) : (
            <SubscriptionForm user={user} />
          )}

          {managed ? (
            <>
              {blocked ? <UnblockForm user={user} /> : <BlockForm user={user} />}
              <DeleteForm user={user} />
            </>
          ) : (
            <p className="text-[13px] leading-relaxed text-ink-muted">
              {isSelf
                ? "You cannot block or delete your own account."
                : "This account is an admin. Remove it from the roster in SQL before blocking or deleting it."}
            </p>
          )}
        </div>
      </details>
    </li>
  );
}

function SettingsForm({ user }: { user: ManagedUser }) {
  const [state, formAction] = useActionState<AdminState, FormData>(
    updateUserSettings,
    {},
  );

  return (
    <form action={formAction}>
      <input type="hidden" name="user_id" value={user.id} />
      <h3 className="text-xs uppercase tracking-[0.14em] text-ink-faint">
        Their settings
      </h3>

      <div className="mt-3 flex flex-wrap gap-3">
        <label className="flex-1">
          <span className="block text-[13px] text-ink-muted">Display name</span>
          <input
            name="display_name"
            defaultValue={user.displayName ?? ""}
            maxLength={60}
            className="mt-1 w-full rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
          />
        </label>
        <label>
          <span className="block text-[13px] text-ink-muted">Theme</span>
          <select
            name="theme"
            defaultValue={user.theme}
            className="mt-1 rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
          >
            <option value="system">Match device</option>
            <option value="light">Light</option>
            <option value="dark">Dark</option>
          </select>
        </label>
      </div>

      <Feedback state={state} />
      <Button idle="Save" busy="Saving…" />
    </form>
  );
}

/**
 * Grant or revoke the paid product.
 *
 * Two separate forms rather than one toggle, because a toggle whose current
 * state came from a list rendered seconds ago will eventually flip the wrong
 * way. Each button states what it does.
 */
function SubscriptionForm({ user }: { user: ManagedUser }) {
  const [grantState, grantAction] = useActionState<AdminState, FormData>(
    grantPro,
    {},
  );
  const [revokeState, revokeAction] = useActionState<AdminState, FormData>(
    revokePro,
    {},
  );

  return (
    <div>
      <h3 className="text-xs uppercase tracking-[0.14em] text-ink-faint">
        Subscription
      </h3>
      <p className="mt-1 text-[13px] leading-relaxed text-ink-muted">
        {user.isPro
          ? "Every lesson and unlimited rehearsals are open to this account."
          : "This account can read two lessons per topic and has one free rehearsal."}
      </p>

      {user.isPro ? (
        <form action={revokeAction}>
          <input type="hidden" name="user_id" value={user.id} />
          <Feedback state={revokeState} />
          <Button idle="Revoke access" busy="Revoking…" />
        </form>
      ) : (
        <form action={grantAction}>
          <input type="hidden" name="user_id" value={user.id} />
          <input
            name="note"
            placeholder="Why, for your own records (optional)"
            className="mt-3 w-full rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2 text-sm text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
          />
          <Feedback state={grantState} />
          <Button idle="Grant full access" busy="Granting…" />
        </form>
      )}
    </div>
  );
}

function BlockForm({ user }: { user: ManagedUser }) {
  const [state, formAction] = useActionState<AdminState, FormData>(
    blockUser,
    {},
  );

  return (
    <form action={formAction}>
      <input type="hidden" name="user_id" value={user.id} />
      <h3 className="text-xs uppercase tracking-[0.14em] text-ink-faint">
        Block
      </h3>
      <p className="mt-1 text-[13px] leading-relaxed text-ink-muted">
        They stop being able to use the app immediately. Nothing is deleted,
        and this can be undone.
      </p>
      <input
        name="reason"
        placeholder="Reason, shown to them (optional)"
        className="mt-3 w-full rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2 text-sm text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
      />
      <Feedback state={state} />
      <Button idle="Block this account" busy="Blocking…" />
    </form>
  );
}

function UnblockForm({ user }: { user: ManagedUser }) {
  const [state, formAction] = useActionState<AdminState, FormData>(
    unblockUser,
    {},
  );

  return (
    <form action={formAction}>
      <input type="hidden" name="user_id" value={user.id} />
      <h3 className="text-xs uppercase tracking-[0.14em] text-ink-faint">
        Blocked
      </h3>
      <Feedback state={state} />
      <Button idle="Unblock" busy="Unblocking…" />
    </form>
  );
}

function DeleteForm({ user }: { user: ManagedUser }) {
  const [state, formAction] = useActionState<AdminState, FormData>(
    deleteUser,
    {},
  );

  return (
    <form
      action={formAction}
      className="rounded border border-[var(--flag)] bg-[var(--flag-soft)] p-4"
    >
      <input type="hidden" name="user_id" value={user.id} />
      <h3 className="text-xs uppercase tracking-[0.14em] text-[var(--flag)]">
        Delete permanently
      </h3>
      <p className="mt-1 text-[13px] leading-relaxed text-ink">
        Removes the account and every rep, rehearsal and badge with it. This
        cannot be undone.
      </p>
      <label htmlFor={`confirm-${user.id}`} className="sr-only">
        Type DELETE to confirm
      </label>
      <input
        id={`confirm-${user.id}`}
        name="confirm"
        autoComplete="off"
        placeholder="Type DELETE to confirm"
        className="mt-3 w-full rounded border border-[var(--flag)] bg-[var(--paper)] px-3 py-2 text-sm text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--flag)]"
      />
      <Feedback state={state} />
      <Button idle="Delete this account" busy="Deleting…" tone="flag" />
    </form>
  );
}

function Button({
  idle,
  busy,
  tone = "accent",
}: {
  idle: string;
  busy: string;
  tone?: "accent" | "flag";
}) {
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={pending}
      className={[
        "mt-3 rounded px-4 py-2 text-sm font-medium transition-opacity hover:opacity-90 disabled:opacity-60",
        tone === "flag"
          ? "bg-[var(--flag)] text-[var(--paper)]"
          : "bg-[var(--accent)] text-[var(--accent-ink)]",
      ].join(" ")}
    >
      {pending ? busy : idle}
    </button>
  );
}

function Tag({
  tone,
  children,
}: {
  tone: "accent" | "flag" | "muted";
  children: React.ReactNode;
}) {
  const tones = {
    accent: "border-[var(--accent)] text-[var(--accent)]",
    flag: "border-[var(--flag)] text-[var(--flag)]",
    muted: "border-rule-strong text-ink-faint",
  };
  return (
    <span className={`tabular rounded border px-1.5 py-0.5 text-[11px] ${tones[tone]}`}>
      {children}
    </span>
  );
}
