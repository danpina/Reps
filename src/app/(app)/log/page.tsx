import { requireUser } from "@/lib/auth/dal";
import { getTopics } from "@/lib/curriculum/queries";
import { createClient } from "@/lib/supabase/server";
import { LogForm } from "./log-form";

export const metadata = { title: "Log a rep — Reps" };

export default async function LogPage({
  searchParams,
}: {
  searchParams: Promise<{ lesson?: string; skill?: string }>;
}) {
  await requireUser();
  const { lesson: lessonId, skill: skillParam } = await searchParams;
  const topics = await getTopics();

  let missionText: string | undefined;
  // A lesson names its skill, and a page that only knows the skill — a recap,
  // say — can say so directly. Either way the form should stop asking.
  let knownSkillId: string | undefined = skillParam;

  if (lessonId) {
    const supabase = await createClient();
    const { data } = await supabase
      .from("lessons")
      .select("id, skill_id, mission_text")
      .eq("id", lessonId)
      .maybeSingle();

    if (data) {
      missionText = data.mission_text;
      knownSkillId = data.skill_id;
    }
  }

  // Resolved against the list the form is built from, so a skill that no
  // longer exists falls back to the picker rather than settling on a name
  // nothing can submit.
  const knownSkill = knownSkillId
    ? topics
        .flatMap((t) => t.skills.map((s) => ({ ...s, topic: t.name })))
        .find((s) => s.id === knownSkillId)
    : undefined;

  return (
    <main className="mx-auto w-full max-w-xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <h1 className="text-xl font-semibold tracking-tight text-ink">
          Log a rep
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          A real conversation you just had. Thirty seconds is plenty.
        </p>
      </header>

      <LogForm
        groups={topics
          .filter((t) => t.skills.length > 0)
          .map((t) => ({
            topic: t.name,
            skills: t.skills.map((s) => ({ id: s.id, name: s.name })),
          }))}
        knownSkill={
          knownSkill
            ? { id: knownSkill.id, name: knownSkill.name, topic: knownSkill.topic }
            : undefined
        }
        lessonId={lessonId}
        missionText={missionText}
      />
    </main>
  );
}
