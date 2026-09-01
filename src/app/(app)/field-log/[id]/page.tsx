import { notFound } from "next/navigation";
import { getTranslations } from "next-intl/server";

import { BackLink } from "@/components/back-link";
import { getLocale, requireUser } from "@/lib/auth/dal";
import { getTopics } from "@/lib/curriculum/queries";
import { createClient } from "@/lib/supabase/server";
import { EditRepForm } from "./edit-rep-form";

export async function generateMetadata() {
  const t = await getTranslations("editRepPage");
  return { title: t("pageTitle") };
}

export default async function EditRepPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  await requireUser();
  const { id } = await params;
  const t = await getTranslations("editRepPage");
  const tNav = await getTranslations("nav");
  const locale = await getLocale();

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
        <BackLink href="/field-log" label={tNav("fieldLog")} />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          {t("heading")}
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          {t("loggedOn", {
            date: new Date(`${entry.logged_date}T00:00:00`).toLocaleDateString(
              locale,
              { weekday: "long", day: "numeric", month: "long" },
            ),
          })}
        </p>
      </header>

      {entry.mission_text ? (
        <div className="mt-6 rounded border border-rule bg-[var(--paper-raised)] p-4">
          <p className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
            {t("theMissionThisWasFor")}
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
