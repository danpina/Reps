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

          {/* Every non-admin row says which side of the paywall it is on.
              Tagging only the subscribers made a free account and an account
              nobody had looked at yet render identically. */}
          {user.isAdmin ? null : user.isPro ? (
            <Tag tone="accent">{accessLabel(user)}</Tag>
          ) : (
            <Tag tone="muted">{accessLabel(user)}</Tag>
          )}

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
 * The word on the tag.
 *
 * Four states rather than two, because "Free" covers three different
 * situations and only one of them means nobody ever paid. A subscription that
 * ran out and one that was revoked need telling apart when someone asks why
 * they lost access.
 */
function accessLabel(user: ManagedUser): string {
  if (user.isPro) return "Pro";
  if (!user.subscription) return "Free";
  if (user.subscription.status === "canceled") return "Cancelled";
  if (
    user.subscription.currentPeriodEnd &&
    new Date(user.subscription.currentPeriodEnd) <= new Date()
  ) {
    return "Expired";
  }
  return user.subscription.status === "past_due" ? "Past due" : "Free";
}

function formatDate(iso: string): string {
  return new Date(iso).toLocaleDateString(undefined, {
    day: "numeric",
    month: "short",
    year: "numeric",
  });
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

      <dl className="mt-2 flex flex-col gap-1 text-[13px] leading-relaxed">
        <Row label="Access">
          {user.isPro
            ? "Every lesson, unlimited rehearsals"
            : "Two lessons per topic, one rehearsal"}
        </Row>
        <Row label="Status">
          {user.subscription
            ? `${user.subscription.status} · ${user.subscription.source === "manual" ? "granted by hand" : "Stripe"}`
            : "no subscription record"}
        </Row>
        <Row label={user.isPro ? "Runs until" : "Ended"}>
          {user.subscription?.currentPeriodEnd
            ? formatDate(user.subscription.currentPeriodEnd)
            : user.subscription
              ? "no end date"
              : "—"}
        </Row>
      </dl>

      {user.isPro ? (
        <form action={revokeAction} className="mt-3">
          <input type="hidden" name="user_id" value={user.id} />
          <Feedback state={revokeState} />
          <Button idle="Revoke access" busy="Revoking…" />
        </form>
      ) : (
        <form action={grantAction} className="mt-3">
          <input type="hidden" name="user_id" value={user.id} />

          {/* Until Stripe exists this is the only way a subscription with an
              end date gets created, which makes it the only way to test what
              happens when one runs out. */}
          <label className="block">
            <span className="block text-[13px] text-ink-muted">For how long</span>
            <select
              name="duration"
              defaultValue="none"
              className="mt-1 rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
            >
              <option value="none">No end date</option>
              <option value="week">One week</option>
              <option value="month">One month</option>
              <option value="year">One year</option>
            </select>
          </label>

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

function Row({
  label,
  children,
}: {
  label: string;
  children: React.ReactNode;
}) {
  return (
    <div className="flex gap-3">
      <dt className="w-24 shrink-0 text-ink-faint">{label}</dt>
      <dd className="text-ink-muted">{children}</dd>
    </div>
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
