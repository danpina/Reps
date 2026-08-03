import Link from "next/link";

import { requireUser } from "@/lib/auth/dal";
import { getSkills } from "@/lib/curriculum/queries";
import { createClient } from "@/lib/supabase/server";
import { LogForm } from "./log-form";

export const metadata = { title: "Log a rep — Reps" };

export default async function LogPage({
  searchParams,
}: {
  searchParams: Promise<{ lesson?: string }>;
}) {
  await requireUser();
  const { lesson: lessonId } = await searchParams;
  const skills = await getSkills();

  let missionText: string | undefined;
  let defaultSkillId: string | undefined;

  if (lessonId) {
    const supabase = await createClient();
    const { data } = await supabase
      .from("lessons")
      .select("id, skill_id, mission_text")
      .eq("id", lessonId)
      .maybeSingle();

    if (data) {
      missionText = data.mission_text;
      defaultSkillId = data.skill_id;
    }
  }

  return (
    <main className="mx-auto w-full max-w-xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <Link
          href="/today"
          className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint underline-offset-4 hover:underline"
        >
          Reps
        </Link>
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          Log a rep
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          A real conversation you just had. Thirty seconds is plenty.
        </p>
      </header>

      <LogForm
        skills={skills.map((s) => ({ id: s.id, name: s.name }))}
        defaultSkillId={defaultSkillId}
        lessonId={lessonId}
        missionText={missionText}
      />
    </main>
  );
}
