import { redirect } from "next/navigation";

import { getProfile, requireUser } from "@/lib/auth/dal";
import { getTopics } from "@/lib/curriculum/queries";
import { WelcomeForm } from "./welcome-form";

export const metadata = { title: "Welcome — Reps" };

export default async function WelcomePage() {
  const user = await requireUser();
  const profile = await getProfile();

  // Already set up. Nobody should be able to land back here by accident.
  if (profile?.onboarded_at) redirect("/today");

  // Only topics with lessons in them. A choice that leads to an empty shelf is
  // a bad first thirty seconds, and the list grows on its own as topics are
  // written.
  const topics = (await getTopics()).filter((t) => t.skills.length > 0);

  return (
    <main id="main" className="mx-auto w-full max-w-xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <p className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
          Reps
        </p>
        {/* The sign-in page promises you will be able to walk into any room.
            This screen used to answer that by describing the mechanism —
            read, do, log — which is true, and reads like being handed a
            manual thirty seconds after being sold a car. Keep the promise
            alive through the form. */}
        <h1 className="mt-3 text-2xl font-semibold leading-[1.15] tracking-tight text-ink">
          Pick the room you want
          <br />
          to walk into
        </h1>
        <p className="mt-4 text-[15px] leading-[1.6] text-ink">
          Every topic here is written for one situation and nothing else,
          because the line that opens a party will lose you an interview.
          Start where it is costing you most.
        </p>
        <p className="mt-3 text-[15px] leading-[1.6] text-ink-muted">
          You will be reading your first idea in about thirty seconds, and
          using it on a real person today.
        </p>
      </header>

      <WelcomeForm
        suggestedName={user.email?.split("@")[0]}
        topics={topics.map((t) => ({
          slug: t.slug,
          name: t.name,
          description: t.description,
        }))}
      />
    </main>
  );
}
