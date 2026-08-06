import { redirect } from "next/navigation";

import { getProfile, requireUser } from "@/lib/auth/dal";
import { WelcomeForm } from "./welcome-form";

export const metadata = { title: "Welcome — Reps" };

export default async function WelcomePage() {
  const user = await requireUser();
  const profile = await getProfile();

  // Already set up. Nobody should be able to land back here by accident.
  if (profile?.onboarding_context) redirect("/today");

  return (
    <main id="main" className="mx-auto w-full max-w-xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <p className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
          Reps
        </p>
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          Two questions, then you are in
        </h1>
        <p className="mt-3 text-sm leading-relaxed text-ink-muted">
          This is a training tool, not a course. You read one short idea, go
          and have a real conversation, and record what happened. The
          conversations are the part that counts.
        </p>
      </header>

      <WelcomeForm suggestedName={user.email?.split("@")[0]} />
    </main>
  );
}
