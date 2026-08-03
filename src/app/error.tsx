"use client";

export default function Error({ reset }: { reset: () => void }) {
  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-5 px-5 py-16">
      <h1 className="text-xl font-semibold tracking-tight text-ink">
        That didn&rsquo;t load
      </h1>
      <p className="text-sm leading-relaxed text-ink-muted">
        Something went wrong reaching the database. If you have just set this
        project up, check that your Supabase keys are in{" "}
        <code className="tabular text-[13px] text-ink">.env.local</code> and that
        the migrations have been applied.
      </p>
      <div>
        <button
          type="button"
          onClick={reset}
          className="rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
        >
          Try again
        </button>
      </div>
    </main>
  );
}
