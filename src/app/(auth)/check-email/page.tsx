import Link from "next/link";

export default async function CheckEmailPage({
  searchParams,
}: {
  searchParams: Promise<{ reason?: string }>;
}) {
  const { reason } = await searchParams;

  return (
    <div className="flex flex-col gap-5">
      <h1 className="text-xl font-semibold tracking-tight text-ink">
        Check your email
      </h1>
      <p className="text-sm leading-relaxed text-ink-muted">
        {reason === "confirm"
          ? "We sent you a link to confirm your address. Open it and you're in."
          : "We sent you a one-time sign-in link. It expires shortly, so open it soon."}
      </p>
      <Link
        href="/sign-in"
        className="text-sm font-medium text-ink underline underline-offset-4"
      >
        Back to sign in
      </Link>
    </div>
  );
}
