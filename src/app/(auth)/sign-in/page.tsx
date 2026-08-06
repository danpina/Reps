import Link from "next/link";

import { FactBanner } from "@/components/fact-banner";
import { randomFact } from "@/lib/facts";
import { SignInForm } from "./sign-in-form";

// Never cached, so the fact is not frozen for everyone who lands here.
export const dynamic = "force-dynamic";

export default async function SignInPage({
  searchParams,
}: {
  searchParams: Promise<{ next?: string; error?: string }>;
}) {
  const params = await searchParams;
  // Chosen on the server and passed down, so the browser hydrates with the
  // same one it was sent.
  const fact = randomFact();

  return (
    <div className="flex flex-col gap-6">
      <FactBanner fact={fact} />

      <h1 className="text-xl font-semibold tracking-tight text-ink">Sign in</h1>

      <SignInForm
        next={params.next ?? "/today"}
        linkError={params.error === "link_invalid"}
      />

      {/* Its own block rather than a sentence under the fold. Anyone signing
          up is by definition someone who cannot get in with the form above, so
          the way out has to be visible without reading past two other forms.
          Quiet rather than primary: signing in is still the common case. */}
      <section
        aria-labelledby="new-here"
        className="rounded border border-[var(--rule-strong)] bg-[var(--paper-raised)] p-5"
      >
        <h2 id="new-here" className="text-sm font-semibold text-ink">
          New here?
        </h2>
        <p className="mt-1 text-sm leading-relaxed text-ink-muted">
          Anyone can create a REPS account. It takes an email and a password.
        </p>
        <Link
          href="/sign-up"
          className="mt-4 inline-flex w-full items-center justify-center rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper-raised)]"
        >
          Create an account
        </Link>
      </section>
    </div>
  );
}
