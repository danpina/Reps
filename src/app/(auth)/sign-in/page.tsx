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

      <p className="border-t border-rule pt-5 text-sm text-ink-muted">
        No account yet?{" "}
        <Link
          href="/sign-up"
          className="font-medium text-ink underline underline-offset-4"
        >
          Create one
        </Link>
      </p>
    </div>
  );
}
