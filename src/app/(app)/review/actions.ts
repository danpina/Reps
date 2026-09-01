"use server";

import { revalidatePath } from "next/cache";
import { getTranslations } from "next-intl/server";

import { requireUser } from "@/lib/auth/dal";
import { createClient } from "@/lib/supabase/server";
import { XP_AWARD, levelForXp } from "@/lib/progress/rules";
import { awardBadges } from "@/lib/progress/snapshot";

export type RewriteState = { error?: string; saved?: boolean };

/**
 * Saves the answer to "what would you say instead?" for one rep.
 *
 * Worth less than a logged rep by a wide margin: thinking about a conversation
 * is not the same as having one, and the XP ratios are the clearest way the
 * app says so.
 */
export async function saveRewrite(
  _prev: RewriteState,
  formData: FormData,
): Promise<RewriteState> {
  const user = await requireUser();
  const supabase = await createClient();
  const t = await getTranslations("review.rewrite.errors");

  const logId = String(formData.get("log_id") ?? "").trim();
  const rewrite = String(formData.get("rewrite") ?? "").trim();

  if (!logId) return { error: t("somethingWentWrong") };
  if (rewrite.length < 3) return { error: t("writeSomething") };

  // Only award once per rep, however many times it is edited.
  const { data: existing, error: readError } = await supabase
    .from("field_logs")
    .select("id, skill_id, rewrite")
    .eq("id", logId)
    .maybeSingle();

  if (readError || !existing) {
    return { error: t("notFound") };
  }

  const alreadyRewritten = Boolean(existing.rewrite?.trim());

  const { error } = await supabase
    .from("field_logs")
    .update({ rewrite, rewrite_at: new Date().toISOString() })
    .eq("id", logId);

  // Never the SDK's own message — see the note in settings/actions.ts.
  if (error) return { error: t("didNotSave") };

  if (!alreadyRewritten) {
    await awardRewriteXp(supabase, user.id, existing.skill_id);
    await awardBadges(supabase, user.id);
  }

  revalidatePath("/review");
  revalidatePath("/today");
  revalidatePath("/field-log");

  return { saved: true };
}

type Client = Awaited<ReturnType<typeof createClient>>;

async function awardRewriteXp(
  supabase: Client,
  userId: string,
  skillId: string,
) {
  const { data: existing } = await supabase
    .from("user_skill_state")
    .select("xp, current_lesson_id")
    .eq("skill_id", skillId)
    .maybeSingle();

  const nextXp = (existing?.xp ?? 0) + XP_AWARD.rewrite;

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
