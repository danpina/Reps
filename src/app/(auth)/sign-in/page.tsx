import Link from "next/link";

import { SignInForm } from "./sign-in-form";

export default async function SignInPage({
  searchParams,
}: {
  searchParams: Promise<{ next?: string; error?: string }>;
}) {
  const params = await searchParams;

  return (
    <div className="flex flex-col gap-6">
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
