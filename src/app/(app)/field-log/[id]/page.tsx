import { notFound } from "next/navigation";

import { BackLink } from "@/components/back-link";
import { requireUser } from "@/lib/auth/dal";
import { getTopics } from "@/lib/curriculum/queries";
import { createClient } from "@/lib/supabase/server";
import { EditRepForm } from "./edit-rep-form";

export const metadata = { title: "Edit a rep — Reps" };

export default async function EditRepPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  await requireUser();
  const { id } = await params;

  const supabase = await createClient();

  // Row level security scopes this to the signed-in user, so somebody else's
  // rep is indistinguishable from one that does not exist — which is the
  // correct thing for it to look like.
  const [{ data: entry }, topics] = await Promise.all([
    supabase
      .from("field_logs")
      .select(
        "id, skill_id, went, context_note, reflection, logged_date, mission_text, other_sex, other_age_group",
      )
      .eq("id", id)
      .maybeSingle(),
    getTopics(),
  ]);

  if (!entry) notFound();

  return (
    <main className="mx-auto w-full max-w-xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink href="/field-log" label="Field log" />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          Edit this rep
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          Logged on{" "}
          {new Date(`${entry.logged_date}T00:00:00`).toLocaleDateString(
            undefined,
            { weekday: "long", day: "numeric", month: "long" },
          )}
          . The date stays put — it is what your streak is counted from.
        </p>
      </header>

      {entry.mission_text ? (
        <div className="mt-6 rounded border border-rule bg-[var(--paper-raised)] p-4">
          <p className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
            The mission this was for
          </p>
          <p className="mt-2 text-sm leading-relaxed text-ink-muted">
            {entry.mission_text}
          </p>
        </div>
      ) : null}

      <EditRepForm
        id={entry.id}
        groups={topics
          .filter((t) => t.skills.length > 0)
          .map((t) => ({
            topic: t.name,
            skills: t.skills.map((s) => ({ id: s.id, name: s.name })),
          }))}
        values={{
          skillId: entry.skill_id,
          went: entry.went,
          contextNote: entry.context_note ?? undefined,
          reflection: entry.reflection ?? undefined,
          otherSex: entry.other_sex,
          otherAgeGroup: entry.other_age_group,
        }}
      />
    </main>
  );
}
