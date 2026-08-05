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
          <h1 className="mt-2 text-lg font-semibold leading-snug tracking-tight text-ink">
            Talking to people is a skill, not a personality
          </h1>
          <p className="mt-2 text-sm leading-relaxed text-ink-muted">
            It decides who you meet, who hires you, and who you end up close to
            — and almost nobody is ever taught it. Reps gives you one idea at a
            time, somewhere to practise it, and a record of every real
            conversation you use it on.
          </p>
        </div>
        {children}
      </div>
    </main>
  );
}
