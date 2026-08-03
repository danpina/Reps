import Link from "next/link";

import { SignUpForm } from "./sign-up-form";

export default function SignUpPage() {
  return (
    <div className="flex flex-col gap-6">
      <h1 className="text-xl font-semibold tracking-tight text-ink">
        Create your log
      </h1>

      <SignUpForm />

      <p className="border-t border-rule pt-5 text-sm text-ink-muted">
        Already have an account?{" "}
        <Link
          href="/sign-in"
          className="font-medium text-ink underline underline-offset-4"
        >
          Sign in
        </Link>
      </p>
    </div>
  );
}
