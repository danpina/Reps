"use server";

import { revalidatePath } from "next/cache";
import { getTranslations } from "next-intl/server";

import { requireUser } from "@/lib/auth/dal";
import { createClient } from "@/lib/supabase/server";
import { XP_AWARD, levelForXp } from "@/lib/progress/rules";
import { awardBadges } from "@/lib/progress/snapshot";
import { checkLine } from "@/lib/roleplay/checks";
import { MAX_LINE_CHARS } from "@/lib/roleplay/limits";
import {
  MAX_DRILL_ATTEMPTS,
  asChoiceSpec,
  asLineSpec,
  type DrillResult,
} from "@/lib/roleplay/modes";
import type { Turn } from "@/lib/roleplay/partner";

/**
 * The drill half of a rehearsal, which never calls the model.
 *
 * Kept in its own file rather than beside `say` and `endScene`, because the
 * one property that matters about everything here is that it cannot cost
 * money, and a rule like that is easier to keep when it is visible in the
 * imports: nothing below reaches for an engine, a rate limit or a ledger.
 */

export type DrillState = { error?: string };

type Loaded = {
  id: string;
  mode: string;
  status: string;
  transcript_json: Turn[];
  lesson_id: string;
  lessons: { rehearsal_spec: unknown; skill_id: string };
};

async function load(id: string): Promise<Loaded | null> {
  const supabase = await createClient();
  const { data } = await supabase
    .from("roleplays")
    .select(
      "id, mode, status, transcript_json, lesson_id, lessons(rehearsal_spec, skill_id)",
    )
    .eq("id", id)
    .maybeSingle();

  return (data as unknown as Loaded) ?? null;
}

/**
 * One attempt at the line.
 *
 * The verdict is not returned to the caller — it is recomputed on render from
 * the attempt that was just stored. That keeps a reload showing the same
 * answer as the submission did, which matters more here than saving a
 * function call: a drill is a thing people repeat, and a page that forgets
 * what it just told them is a page they stop trusting.
 */
export async function attemptLine(
  _prev: DrillState,
  formData: FormData,
): Promise<DrillState> {
  await requireUser();
  const supabase = await createClient();
  const t = await getTranslations("drillActions.errors");

  const id = String(formData.get("roleplay_id") ?? "");
  const line = String(formData.get("line") ?? "").trim();

  if (!line) return { error: t("writeTheLineFirst") };

  const drill = await load(id);
  if (!drill) return { error: t("notFound") };
  if (drill.status === "complete") return { error: t("drillFinished") };

  const spec = asLineSpec(drill.lessons.rehearsal_spec);
  if (!spec) return { error: t("notSetUpCorrectly") };

  // Checked once the spec is loaded, because how much room a drill gives is
  // the lesson's decision rather than the app's. Still checked here and not
  // only by the textarea: a maxLength attribute is a courtesy, not a limit.
  if (line.length > (spec.maxChars ?? MAX_LINE_CHARS)) {
    return { error: t("tooLongTightenIt") };
  }

  if (drill.transcript_json.length >= MAX_DRILL_ATTEMPTS) {
    return {
      error: t("enoughAttempts"),
    };
  }

  const transcript: Turn[] = [
    ...drill.transcript_json,
    {
      role: "user",
      content: line,
      at: new Date().toISOString(),
      correct: checkLine(line, spec.checks).landed,
    },
  ];

  const { error } = await supabase
    .from("roleplays")
    .update({ transcript_json: transcript })
    .eq("id", id);

  if (error) return { error: t("attemptDidNotSave") };

  revalidatePath(`/rehearse/${id}`);
  return {};
}

/** One answer to one read-and-decide beat. */
export async function answerChoice(
  _prev: DrillState,
  formData: FormData,
): Promise<DrillState> {
  await requireUser();
  const supabase = await createClient();
  const t = await getTranslations("drillActions.errors");

  const id = String(formData.get("roleplay_id") ?? "");
  const picked = Number(formData.get("option"));

  const drill = await load(id);
  if (!drill) return { error: t("notFound") };
  if (drill.status === "complete") return { error: t("drillFinished") };

  const spec = asChoiceSpec(drill.lessons.rehearsal_spec);
  if (!spec) return { error: t("notSetUpCorrectly") };

  // Which beat is being answered is the count of answers so far, never a
  // number from the form. A client that could name its own beat could answer
  // the same easy one repeatedly, or skip the one it did not like.
  const beat = spec.beats[drill.transcript_json.length];
  if (!beat) return { error: t("everySituationAnswered") };

  const option = beat.options[picked];
  if (!option) return { error: t("pickOneOfTheOptions") };

  const transcript: Turn[] = [
    ...drill.transcript_json,
    {
      role: "user",
      content: option.text,
      at: new Date().toISOString(),
      correct: option.correct,
    },
  ];

  const { error } = await supabase
    .from("roleplays")
    .update({ transcript_json: transcript })
    .eq("id", id);

  if (error) return { error: t("answerDidNotSave") };

  revalidatePath(`/rehearse/${id}`);
  return {};
}

/**
 * Closes a drill and records how it went.
 *
 * The result is read off the attempts rather than recomputed from anything the
 * form sent, so what gets stored is what actually happened.
 */
export async function finishDrill(
  _prev: DrillState,
  formData: FormData,
): Promise<DrillState> {
  const user = await requireUser();
  const supabase = await createClient();
  const t = await getTranslations("drillActions.errors");

  const id = String(formData.get("roleplay_id") ?? "");

  const drill = await load(id);
  if (!drill) return { error: t("notFound") };
  if (drill.status === "complete") return {};

  const attempts = drill.transcript_json;
  if (attempts.length === 0) {
    return { error: t("haveAGoFirst") };
  }

  const spec = asLineSpec(drill.lessons.rehearsal_spec);
  const last = attempts[attempts.length - 1];

  // For a line drill the verdict is the attempt they settled on; for a
  // read-and-decide it is whether every situation was read correctly. Both
  // reduce to "did the last state of this drill meet the bar", which is the
  // honest thing to record either way.
  const landed =
    drill.mode === "choice"
      ? attempts.every((turn) => turn.correct === true)
      : last.correct === true;

  const result: DrillResult = {
    kind: "drill",
    landed,
    attempts: attempts.length,
    missed:
      drill.mode === "line" && spec && !landed
        ? checkLine(last.content, spec.checks).missed
        : [],
  };

  const { error } = await supabase
    .from("roleplays")
    .update({
      status: "complete",
      completed_at: new Date().toISOString(),
      feedback_json: result,
    })
    .eq("id", id);

  if (error) return { error: t("didNotSave") };

  await awardDrillXp(supabase, user.id, drill.lessons.skill_id, drill.lesson_id);
  await awardBadges(supabase, user.id);

  revalidatePath(`/rehearse/${id}`);
  revalidatePath("/today");
  return {};
}

type Client = Awaited<ReturnType<typeof createClient>>;

/**
 * XP for a drill, once per lesson and never again.
 *
 * A drill is free and unlimited by design, which makes paying XP per
 * completion an invitation to sit on one lesson typing the same good line
 * forty times. The first time you land it is worth something; the fortieth is
 * worth practice, which is its own reward and does not need a number attached.
 */
async function awardDrillXp(
  supabase: Client,
  userId: string,
  skillId: string,
  lessonId: string,
) {
  const { count } = await supabase
    .from("roleplays")
    .select("id", { count: "exact", head: true })
    .eq("lesson_id", lessonId)
    .eq("status", "complete");

  // This drill has just been marked complete, so it is included in the count.
  // Anything above one means the user has been here before.
  if ((count ?? 0) > 1) return;

  const { data: existing } = await supabase
    .from("user_skill_state")
    .select("xp, current_lesson_id")
    .eq("skill_id", skillId)
    .maybeSingle();

  const nextXp = (existing?.xp ?? 0) + XP_AWARD.roleplay;

  await supabase.from("user_skill_state").upsert(
    {
      user_id: userId,
      skill_id: skillId,
      xp: nextXp,
      level: levelForXp(nextXp),
      current_lesson_id: existing?.current_lesson_id ?? null,
      updated_at: new Date().toISOString(),
    },
    { onConflict: "user_id,skill_id" },
  );
}
