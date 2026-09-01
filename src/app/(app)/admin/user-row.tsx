"use client";

import { useActionState } from "react";
import { useFormStatus } from "react-dom";
import { useTranslations } from "next-intl";

import type { ManagedUser } from "./page";
import type { UserProgress } from "@/lib/progress/admin-summary";
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
  progress,
}: {
  user: ManagedUser;
  isSelf: boolean;
  progress: UserProgress;
}) {
  const t = useTranslations("adminPage.userRow");
  const blocked = Boolean(user.blockedAt);
  // Matches what the server will refuse, so the UI never offers an action
  // that is going to come back as an error. The server is still the check.
  const managed = !isSelf && !user.isAdmin;

  return (
    <li className="border-b border-rule">
      <details>
        <summary className="flex cursor-pointer flex-wrap items-baseline gap-x-3 gap-y-1 py-4 hover:bg-[var(--paper-raised)]">
          <span className="text-sm text-ink">{user.email ?? t("noEmail")}</span>

          {user.isAdmin ? <Tag tone="accent">{t("admin")}</Tag> : null}

          {/* Every non-admin row says which side of the paywall it is on.
              Tagging only the subscribers made a free account and an account
              nobody had looked at yet render identically. */}
          {user.isAdmin ? null : user.isPro ? (
            <Tag tone="accent">{accessLabel(user, t)}</Tag>
          ) : (
            <Tag tone="muted">{accessLabel(user, t)}</Tag>
          )}

          {isSelf ? <Tag tone="muted">{t("you")}</Tag> : null}
          {blocked ? <Tag tone="flag">{t("blocked")}</Tag> : null}

          {/* The one number worth seeing without opening the row. Reps rather
              than XP, because XP counts reading and this is the column you
              scan to find out who is actually using the thing. */}
          <span className="tabular ml-auto text-xs text-ink-faint">
            {progress.repsLogged === 0
              ? t("noReps")
              : t("repsCount", { count: progress.repsLogged })}
            {progress.lastActive ? ` · ${sinceLabel(progress.lastActive, t)}` : ""}
          </span>
        </summary>

        <div className="flex flex-col gap-6 pb-6 pl-1">
          {user.blockedReason ? (
            <p className="text-[13px] leading-relaxed text-ink-muted">
              {t("reasonGiven", { reason: user.blockedReason })}
            </p>
          ) : null}

          <Standing progress={progress} joined={user.createdAt} />

          <SettingsForm user={user} />

          {user.isAdmin ? (
            <p className="text-[13px] leading-relaxed text-ink-muted">
              {t("adminsHaveWholeProduct")}
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
              {isSelf ? t("cannotBlockSelf") : t("accountIsAdmin")}
            </p>
          )}
        </div>
      </details>
    </li>
  );
}

/**
 * Where somebody has got to.
 *
 * Reps first and XP second, in that order deliberately. XP counts reading, and
 * two accounts on the same XP can be one person who has read forty cards and
 * one who has had twelve conversations — which are not the same account at all,
 * and the second one is the whole point of the product.
 *
 * Started, worked and finished are three different things and are kept apart
 * for the same reason. Started means opened. Worked means a rep was logged
 * against it. Finished means every card in the track has been read, which is
 * the cheap kind of done and is labelled as reading rather than as completion.
 */
function Standing({
  progress,
  joined,
}: {
  progress: UserProgress;
  joined: string;
}) {
  const t = useTranslations("adminPage.userRow");

  if (progress.isUntouched) {
    return (
      <div>
        <h3 className="text-xs uppercase tracking-[0.14em] text-ink-faint">
          {t("standing")}
        </h3>
        <p className="mt-2 text-[13px] leading-relaxed text-ink-muted">
          {t("joinedNotOpened", { date: formatDate(joined) })}
        </p>
      </div>
    );
  }

  const { rank } = progress;

  return (
    <div>
      <h3 className="text-xs uppercase tracking-[0.14em] text-ink-faint">
        {t("standing")}
      </h3>

      <dl className="mt-2 flex flex-col gap-1 text-[13px] leading-relaxed">
        <Row label={t("rank")}>
          {rank.rank.name}{" "}
          <span className="text-ink-faint">
            {t("rankPosition", {
              position: rank.position,
              total: rank.total,
              xp: progress.totalXp.toLocaleString(),
            })}
          </span>
        </Row>
        <Row label={t("reps")}>
          {progress.repsLogged}
          {progress.skillsWorked > 0
            ? t("acrossSkills", { count: progress.skillsWorked })
            : ""}
        </Row>
        <Row label={t("streak")}>
          {t("dayCount", { count: progress.currentStreak })}
          <span className="text-ink-faint">
            {" "}
            · {t("longest", { count: progress.longestStreak })}
          </span>
        </Row>
        <Row label={t("topics")}>
          {t("startedOfTotal", { started: progress.topicsStarted, total: progress.topicsTotal })}
        </Row>
        <Row label={t("skills")}>
          {t("startedOfTotal", { started: progress.skillsStarted, total: progress.skillsTotal })}
          <span className="text-ink-faint">
            {" "}
            · {t("readThrough", { count: progress.skillsFinished })}
          </span>
        </Row>
        <Row label={t("lessons")}>
          {t("readOfTotal", { read: progress.lessonsRead, total: progress.lessonsTotal })}
        </Row>
        {progress.badges > 0 ? (
          <Row label={t("badges")}>{progress.badges}</Row>
        ) : null}
        {progress.furthest ? (
          <Row label={t("lastIn")}>
            {progress.furthest.topic} · {progress.furthest.skill} ·{" "}
            {progress.furthest.lesson}
          </Row>
        ) : null}
        <Row label={t("active")}>
          {progress.lastActive ? formatDate(progress.lastActive) : t("never")}
          <span className="text-ink-faint"> · {t("joined", { date: formatDate(joined) })}</span>
        </Row>
      </dl>
    </div>
  );
}

/**
 * How long ago, in the fewest words that still distinguish this week from last
 * quarter. Anything older than a year is not worth counting precisely.
 */
function sinceLabel(iso: string, t: ReturnType<typeof useTranslations>): string {
  const then = new Date(`${iso}T00:00:00`);
  const now = new Date();
  const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  const days = Math.round((today.getTime() - then.getTime()) / 86_400_000);

  if (days <= 0) return t("today");
  if (days === 1) return t("yesterday");
  if (days < 7) return t("daysAgo", { count: days });
  if (days < 60) return t("weeksAgo", { count: Math.floor(days / 7) });
  if (days < 365) return t("monthsAgo", { count: Math.floor(days / 30) });
  return t("overAYear");
}

function SettingsForm({ user }: { user: ManagedUser }) {
  const t = useTranslations("adminPage.userRow");
  const [state, formAction] = useActionState<AdminState, FormData>(
    updateUserSettings,
    {},
  );

  return (
    <form action={formAction}>
      <input type="hidden" name="user_id" value={user.id} />
      <h3 className="text-xs uppercase tracking-[0.14em] text-ink-faint">
        {t("theirSettings")}
      </h3>

      <div className="mt-3 flex flex-wrap gap-3">
        <label className="flex-1">
          <span className="block text-[13px] text-ink-muted">{t("displayName")}</span>
          <input
            name="display_name"
            defaultValue={user.displayName ?? ""}
            maxLength={60}
            className="mt-1 w-full rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
          />
        </label>
        <label>
          <span className="block text-[13px] text-ink-muted">{t("theme")}</span>
          <select
            name="theme"
            defaultValue={user.theme}
            className="mt-1 rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
          >
            <option value="system">{t("matchDevice")}</option>
            <option value="light">{t("light")}</option>
            <option value="dark">{t("dark")}</option>
          </select>
        </label>
      </div>

      <Feedback state={state} />
      <Button idle={t("save")} busy={t("savingPending")} />
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
function accessLabel(user: ManagedUser, t: ReturnType<typeof useTranslations>): string {
  if (user.isPro) return t("pro");
  if (!user.subscription) return t("free");
  if (user.subscription.status === "canceled") return t("cancelled");
  if (
    user.subscription.currentPeriodEnd &&
    new Date(user.subscription.currentPeriodEnd) <= new Date()
  ) {
    return t("expired");
  }
  return user.subscription.status === "past_due" ? t("pastDue") : t("free");
}

/**
 * Takes both a timestamp and a bare calendar day.
 *
 * The date-only case needs the time appended, because `new Date("2026-08-10")`
 * is parsed as UTC midnight while `new Date("2026-08-10T00:00:00")` is local —
 * so without this a logged day renders as the day before for anybody west of
 * Greenwich, which is the kind of off-by-one nobody thinks to check.
 */
function formatDate(iso: string): string {
  const value = /^\d{4}-\d{2}-\d{2}$/.test(iso) ? `${iso}T00:00:00` : iso;
  // Deliberately locale-independent (admin-only screen, never localized).
  return new Date(value).toLocaleDateString("en-GB", {
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
  const t = useTranslations("adminPage.userRow");
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
        {t("subscription")}
      </h3>

      <dl className="mt-2 flex flex-col gap-1 text-[13px] leading-relaxed">
        <Row label={t("access")}>
          {user.isPro ? t("everyLessonUnlimited") : t("twoLessonsOneRehearsal")}
        </Row>
        <Row label={t("status")}>
          {user.subscription
            ? t("statusLine", {
                status: user.subscription.status,
                source:
                  user.subscription.source === "manual" ? t("grantedByHand") : "Stripe",
              })
            : t("noSubscriptionRecord")}
        </Row>
        <Row label={user.isPro ? t("runsUntil") : t("ended")}>
          {user.subscription?.currentPeriodEnd
            ? formatDate(user.subscription.currentPeriodEnd)
            : user.subscription
              ? t("noEndDate")
              : "—"}
        </Row>
      </dl>

      {user.isPro ? (
        <form action={revokeAction} className="mt-3">
          <input type="hidden" name="user_id" value={user.id} />
          <Feedback state={revokeState} />
          <Button idle={t("revokeAccess")} busy={t("revokingPending")} />
        </form>
      ) : (
        <form action={grantAction} className="mt-3">
          <input type="hidden" name="user_id" value={user.id} />

          {/* Until Stripe exists this is the only way a subscription with an
              end date gets created, which makes it the only way to test what
              happens when one runs out. */}
          <label className="block">
            <span className="block text-[13px] text-ink-muted">{t("forHowLong")}</span>
            <select
              name="duration"
              defaultValue="none"
              className="mt-1 rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
            >
              <option value="none">{t("noEndDateOption")}</option>
              <option value="week">{t("oneWeek")}</option>
              <option value="month">{t("oneMonth")}</option>
              <option value="year">{t("oneYear")}</option>
            </select>
          </label>

          <input
            name="note"
            placeholder={t("whyForRecordsPlaceholder")}
            className="mt-3 w-full rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2 text-sm text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
          />
          <Feedback state={grantState} />
          <Button idle={t("grantFullAccess")} busy={t("grantingPending")} />
        </form>
      )}
    </div>
  );
}

function BlockForm({ user }: { user: ManagedUser }) {
  const t = useTranslations("adminPage.userRow");
  const [state, formAction] = useActionState<AdminState, FormData>(
    blockUser,
    {},
  );

  return (
    <form action={formAction}>
      <input type="hidden" name="user_id" value={user.id} />
      <h3 className="text-xs uppercase tracking-[0.14em] text-ink-faint">
        {t("block")}
      </h3>
      <p className="mt-1 text-[13px] leading-relaxed text-ink-muted">
        {t("blockExplanation")}
      </p>
      <input
        name="reason"
        placeholder={t("reasonPlaceholder")}
        className="mt-3 w-full rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2 text-sm text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
      />
      <Feedback state={state} />
      <Button idle={t("blockThisAccount")} busy={t("blockingPending")} />
    </form>
  );
}

function UnblockForm({ user }: { user: ManagedUser }) {
  const t = useTranslations("adminPage.userRow");
  const [state, formAction] = useActionState<AdminState, FormData>(
    unblockUser,
    {},
  );

  return (
    <form action={formAction}>
      <input type="hidden" name="user_id" value={user.id} />
      <h3 className="text-xs uppercase tracking-[0.14em] text-ink-faint">
        {t("blocked")}
      </h3>
      <Feedback state={state} />
      <Button idle={t("unblock")} busy={t("unblockingPending")} />
    </form>
  );
}

function DeleteForm({ user }: { user: ManagedUser }) {
  const t = useTranslations("adminPage.userRow");
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
        {t("deletePermanently")}
      </h3>
      <p className="mt-1 text-[13px] leading-relaxed text-ink">
        {t("deleteExplanation")}
      </p>
      <label htmlFor={`confirm-${user.id}`} className="sr-only">
        {t("typeDeleteToConfirm")}
      </label>
      <input
        id={`confirm-${user.id}`}
        name="confirm"
        autoComplete="off"
        placeholder={t("typeDeleteToConfirm")}
        className="mt-3 w-full rounded border border-[var(--flag)] bg-[var(--paper)] px-3 py-2 text-sm text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--flag)]"
      />
      <Feedback state={state} />
      <Button idle={t("deleteThisAccount")} busy={t("deletingPending")} tone="flag" />
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
