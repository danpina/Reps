import Link from "next/link";
import { getTranslations } from "next-intl/server";

import { getLocale, requireUser } from "@/lib/auth/dal";
import {
  FREE_PREVIEW_LESSONS,
  FREE_REHEARSALS,
  getSubscription,
  isPro,
} from "@/lib/billing/entitlement";
import { getTopics } from "@/lib/curriculum/queries";

export async function generateMetadata() {
  const t = await getTranslations("proPage");
  return { title: t("pageTitle") };
}

export default async function ProPage() {
  await requireUser();
  const [topics, pro, subscription] = await Promise.all([
    getTopics(),
    isPro(),
    getSubscription(),
  ]);
  const t = await getTranslations("proPage");
  const locale = await getLocale();

  const written = topics.filter((topic) => topic.skills.length > 0);
  const lessons = topics.reduce(
    (sum, topic) =>
      sum + topic.skills.reduce((n, s) => n + s.lessons.length, 0),
    0,
  );

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <h1 className="text-xl font-semibold tracking-tight text-ink">
          {pro ? t("yourSubscription") : t("whatUnlocks")}
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          {pro
            ? t("proBody")
            : t("freeBody", { lessons, topicCount: written.length })}
        </p>
      </header>

      {pro ? (
        <section className="mt-8 rounded border border-[var(--accent)] bg-[var(--accent-soft)] p-5">
          <p className="text-sm text-ink">
            {t("active")}
            {subscription?.source === "manual" ? t("grantedByHand") : ""}
            {subscription?.current_period_end
              ? t("until", {
                  date: new Date(
                    subscription.current_period_end,
                  ).toLocaleDateString(locale),
                })
              : "."}
          </p>
          <Link
            href="/topics"
            className="mt-4 inline-flex rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
          >
            {t("goRead")}
          </Link>
        </section>
      ) : (
        <>
          <section className="mt-8">
            <h2 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
              {t("freeHeading")}
            </h2>
            <ul className="mt-4 flex flex-col gap-3">
              <Item>{t("freePreview", { count: FREE_PREVIEW_LESSONS })}</Item>
              <Item>{t("rehearsalsItem", { count: FREE_REHEARSALS })}</Item>
              <Item>{t("fieldLogItem")}</Item>
            </ul>
          </section>

          <section className="mt-9">
            <h2 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
              {t("payingHeading")}
            </h2>
            <ul className="mt-4 flex flex-col gap-3">
              <Item>{t("everyLesson")}</Item>
              <Item>{t("unlimitedRehearsals")}</Item>
              <Item>{t("recaps")}</Item>
            </ul>

            <ol className="mt-6">
              {topics.map((topic) => (
                <li
                  key={topic.id}
                  className="flex items-baseline gap-3 border-b border-rule py-3"
                >
                  <span className="tabular text-xs text-ink-faint">
                    {String(topic.sort_order).padStart(2, "0")}
                  </span>
                  <span className="text-sm text-ink">{topic.name}</span>
                  <span className="tabular ml-auto shrink-0 text-xs text-ink-faint">
                    {topic.skills.length === 0
                      ? t("beingWritten")
                      : t("lessonsCount", {
                          count: topic.skills.reduce(
                            (n, s) => n + s.lessons.length,
                            0,
                          ),
                        })}
                  </span>
                </li>
              ))}
            </ol>
          </section>

          <section className="mt-9 rounded border border-rule bg-[var(--paper-raised)] p-5">
            <h2 className="text-sm font-semibold text-ink">
              {t("checkoutNotOpen")}
            </h2>
            <p className="mt-2 text-sm leading-relaxed text-ink-muted">
              {t("checkoutBody")}
            </p>
          </section>
        </>
      )}
    </main>
  );
}

function Item({ children }: { children: React.ReactNode }) {
  return (
    <li className="flex gap-3 text-sm leading-relaxed text-ink-muted">
      <span aria-hidden className="mt-1.5 h-1 w-1 shrink-0 rounded-full bg-[var(--accent)]" />
      <span>{children}</span>
    </li>
  );
}
