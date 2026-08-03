import { signOut } from "@/app/(auth)/actions";
import { Button } from "@/components/ui";
import { getProfile, requireUser } from "@/lib/auth/dal";

export default async function TodayPage() {
  const user = await requireUser();
  const profile = await getProfile();
  const name = profile?.display_name?.trim();

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="flex items-baseline justify-between border-b border-rule pb-5">
        <div>
          <p className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
            Reps
          </p>
          <h1 className="mt-2 text-xl font-semibold tracking-tight text-ink">
            {name ? `Good to see you, ${name}` : "Good to see you"}
          </h1>
        </div>
        <form action={signOut}>
          <Button variant="quiet" type="submit" className="px-3 py-1.5 text-xs">
            Sign out
          </Button>
        </form>
      </header>

      <section className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6">
        <h2 className="text-sm font-semibold text-ink">Nothing to practise yet</h2>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          The curriculum lands in the next phase. Once it does, this is where
          you&rsquo;ll pick a skill and get today&rsquo;s field mission.
        </p>
        <dl className="mt-6 grid grid-cols-3 gap-4 border-t border-rule pt-5">
          <Stat label="Reps logged" value="0" />
          <Stat label="Current streak" value="0" />
          <Stat label="Level" value="1" />
        </dl>
      </section>

      <p className="mt-6 text-xs text-ink-faint">
        Signed in as {user.email ?? "your account"}.
      </p>
    </main>
  );
}

function Stat({ label, value }: { label: string; value: string }) {
  return (
    <div>
      <dt className="text-xs text-ink-faint">{label}</dt>
      <dd className="tabular mt-1 text-2xl text-ink">{value}</dd>
    </div>
  );
}
