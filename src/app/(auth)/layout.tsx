export default function AuthLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <main className="flex min-h-dvh flex-col justify-center px-5 py-12">
      <div className="mx-auto w-full max-w-sm">
        <div className="mb-9">
          <p className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
            Reps
          </p>
          <p className="mt-2 text-sm leading-relaxed text-ink-muted">
            A practice log for small talk. Learn the idea, rehearse it, then go
            and do it for real.
          </p>
        </div>
        {children}
      </div>
    </main>
  );
}
