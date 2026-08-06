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
          <h1 className="mt-3 text-2xl font-semibold leading-[1.15] tracking-tight text-ink">
            Talking to people is a skill,
            <br />
            not a personality
          </h1>
          <p className="mt-4 text-[15px] leading-[1.6] text-ink">
            Good conversation skills decide who you meet, who hires you, and
            who you end up close to. Almost nobody is ever taught them, and
            almost everybody assumes they are stuck with whatever they have.
          </p>
          <p className="mt-3 text-[15px] leading-[1.6] text-ink-muted">
            REPS trains you the right way: one idea at a time, one real
            conversation, one honest note on how it went. Do that for a month
            and you will walk into any room knowing you can talk to anyone in
            it — the client, the stranger, the person you actually wanted to
            meet.
          </p>
          <p className="mt-3 text-[15px] font-medium leading-[1.6] text-ink">
            That is not charisma. It is practice.
          </p>
        </div>
        {children}
      </div>
    </main>
  );
}
