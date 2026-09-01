import Link from "next/link";
import { getTranslations } from "next-intl/server";

import { signOut } from "@/app/(auth)/actions";
import { BackLink } from "@/components/back-link";
import { getProfile, isAdmin, requireUser } from "@/lib/auth/dal";
import { AboutYouForm } from "./about-you-form";
import { PasswordForm } from "./password-form";
import { LanguageForm } from "./language-form";
import { ThemeForm } from "./theme-form";

export async function generateMetadata() {
  const t = await getTranslations("settings");
  return { title: t("pageTitle") };
}

export default async function SettingsPage() {
  await requireUser();
  const [profile, admin] = await Promise.all([getProfile(), isAdmin()]);
  const t = await getTranslations("settings");
  const tNav = await getTranslations("nav");

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink href="/today" label={tNav("today")} />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          {t("heading")}
        </h1>
      </header>

      <div className="flex flex-col">
        <Section title={t("aboutYou.title")} description={t("aboutYou.description")}>
          <AboutYouForm
            sex={profile?.sex ?? null}
            ageGroup={profile?.age_group ?? null}
            datingInterest={profile?.dating_interest ?? null}
          />
        </Section>

        <Section title={t("language.title")} description={t("language.description")}>
          <LanguageForm current={profile?.locale ?? "en"} />
        </Section>

        <Section
          title={t("appearance.title")}
          description={t("appearance.description")}
        >
          <ThemeForm current={profile?.theme ?? "system"} />
        </Section>

        <Section title={t("password.title")} description={t("password.description")}>
          <PasswordForm />
        </Section>

        {admin ? (
          <Section
            title={t("admin.title")}
            description={t("admin.description")}
          >
            <Link
              href="/admin"
              className="inline-flex rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper-raised)]"
            >
              {t("admin.manageUsers")}
            </Link>
          </Section>
        ) : null}

        <Section title={t("account.title")}>
          <form action={signOut}>
            <button
              type="submit"
              className="rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper-raised)]"
            >
              {t("account.signOut")}
            </button>
          </form>
        </Section>
      </div>
    </main>
  );
}

/**
 * One setting per section, titled and separated.
 *
 * The shape is the point: adding a setting later means adding a Section, not
 * rearranging this page. Each carries its own form and its own submit, so a
 * new one cannot accidentally couple itself to an existing save.
 */
function Section({
  title,
  description,
  children,
}: {
  title: string;
  description?: string;
  children: React.ReactNode;
}) {
  return (
    <section className="border-b border-rule py-8">
      <h2 className="text-sm font-semibold text-ink">{title}</h2>
      {description ? (
        <p className="mt-1 text-[13px] leading-relaxed text-ink-muted">
          {description}
        </p>
      ) : null}
      <div className="mt-5">{children}</div>
    </section>
  );
}
