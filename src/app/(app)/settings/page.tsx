import Link from "next/link";

import { signOut } from "@/app/(auth)/actions";
import { BackLink } from "@/components/back-link";
import { getProfile, isAdmin, requireUser } from "@/lib/auth/dal";
import { AboutYouForm } from "./about-you-form";
import { PasswordForm } from "./password-form";
import { LanguageForm } from "./language-form";
import { ThemeForm } from "./theme-form";

export const metadata = { title: "Settings — Reps" };

export default async function SettingsPage() {
  await requireUser();
  const [profile, admin] = await Promise.all([getProfile(), isAdmin()]);

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink href="/today" label="Today" />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          Settings
        </h1>
      </header>

      <div className="flex flex-col">
        <Section
          title="About you"
          description="Three optional answers. They decide which version of a lesson you are shown, how a rehearsal is reviewed, and what a read of your log is able to notice. Leave any of them blank and you get the general version, which is written to be right for everybody."
        >
          <AboutYouForm
            sex={profile?.sex ?? null}
            ageGroup={profile?.age_group ?? null}
            datingInterest={profile?.dating_interest ?? null}
          />
        </Section>

        <Section
          title="Language"
          description="Anything not yet translated stays in English until it is."
        >
          <LanguageForm current={profile?.locale ?? "en"} />
        </Section>

        <Section
          title="Appearance"
          description="Stored on your account, so it follows you to any device you sign in on."
        >
          <ThemeForm current={profile?.theme ?? "system"} />
        </Section>

        <Section
          title="Password"
          description="You will need your current one to set a new one."
        >
          <PasswordForm />
        </Section>

        {admin ? (
          <Section
            title="Administration"
            description="You have admin access on this account."
          >
            <Link
              href="/admin"
              className="inline-flex rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper-raised)]"
            >
              Manage users
            </Link>
          </Section>
        ) : null}

        <Section title="Account">
          <form action={signOut}>
            <button
              type="submit"
              className="rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper-raised)]"
            >
              Sign out
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
