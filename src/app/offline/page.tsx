export const metadata = { title: "Offline — Reps" };

export default function OfflinePage() {
  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-5 px-5 py-16">
      <p className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
        Reps
      </p>
      <h1 className="text-xl font-semibold tracking-tight text-ink">
        No connection
      </h1>
      <p className="text-sm leading-relaxed text-ink-muted">
        Your reps are stored on the server, so the log needs a connection to
        load. Nothing has been lost.
      </p>
      <p className="text-sm leading-relaxed text-ink-muted">
        If you have just had a conversation you want to record, write the note
        somewhere for now and log it when you are back online.
      </p>
    </main>
  );
}
