import Link from "next/link";

export default function NotFound() {
  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-5 px-5 py-16">
      <h1 className="text-xl font-semibold tracking-tight text-ink">
        Nothing here
      </h1>
      <p className="text-sm leading-relaxed text-ink-muted">
        That lesson or skill doesn&rsquo;t exist.
      </p>
      <Link
        href="/skills"
        className="text-sm font-medium text-ink underline underline-offset-4"
      >
        Back to the skills
      </Link>
    </main>
  );
}
