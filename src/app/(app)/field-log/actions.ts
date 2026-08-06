"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";

import { requireUser } from "@/lib/auth/dal";
import { adjustSkillXp, recomputeStreak } from "@/lib/progress/adjust";
import { createClient } from "@/lib/supabase/server";

export type EditRepState = { error?: string };

/**
 * What a correction may touch, and what it may not.
 *
 * The skill, the rating and the notes are all things a person can get wrong in
 * the thirty seconds after a conversation, so all of them are editable. The
 * date is not. Letting someone move a rep to a different day would let them
 * manufacture streak days, which would turn the one number the app asks people
 * to care about into a number they can type in.
 *
 * The XP awarded is not editable either. It is a record of what was granted,
 * and it is what a deletion has to give back.
 */
export async function updateRep(
  _prev: EditRepState,
  formData: FormData,
): Promise<EditRepState> {
  const user = await requireUser();
  const supabase = await createClient();

  const id = String(formData.get("id") ?? "").trim();
  const skillId = String(formData.get("skill_id") ?? "").trim();
  const went = Number(formData.get("went"));
  const contextNote = String(formData.get("context_note") ?? "").trim() || null;
  const reflection = String(formData.get("reflection") ?? "").trim() || null;

  if (!id) return { error: "That rep could not be found." };
  if (!skillId) return { error: "Pick which skill this rep was for." };
  if (![1, 2, 3].includes(went)) return { error: "Say how it went." };

  // Row level security scopes this to the signed-in user, so a missing row
  // means either no such rep or somebody else's — and both deserve the same
  // answer.
  const { data: existing } = await supabase
    .from("field_logs")
    .select("id, skill_id, xp_awarded")
    .eq("id", id)
    .maybeSingle();

  if (!existing) return { error: "That rep could not be found." };

  const { error } = await supabase
    .from("field_logs")
    .update({
      skill_id: skillId,
      went,
      context_note: contextNote,
      reflection,
    })
    .eq("id", id);

  if (error) return { error: `That did not save: ${error.message}` };

  // Moving a rep to a different skill has to move its XP too, or the levels
  // stop describing the reps underneath them.
  if (existing.skill_id !== skillId) {
    await adjustSkillXp(supabase, user.id, existing.skill_id, -existing.xp_awarded);
    await adjustSkillXp(supabase, user.id, skillId, existing.xp_awarded);
  }

  revalidatePath("/field-log");
  revalidatePath("/today");
  redirect("/field-log?edited=1");
}

/**
 * Removes a rep and gives back everything it was worth.
 *
 * Badges are deliberately not revoked. They are a record of having reached
 * something, correcting a typo should not take one away, and an app that can
 * silently remove an achievement is an app people stop trusting with honest
 * data — which is the entire product.
 */
export async function deleteRep(formData: FormData): Promise<void> {
  const user = await requireUser();
  const supabase = await createClient();

  const id = String(formData.get("id") ?? "").trim();
  if (!id) redirect("/field-log");

  const { data: existing } = await supabase
    .from("field_logs")
    .select("id, skill_id, xp_awarded")
    .eq("id", id)
    .maybeSingle();

  if (!existing) redirect("/field-log");

  const { error } = await supabase.from("field_logs").delete().eq("id", id);
  if (error) redirect("/field-log?error=1");

  // Order matters. The streak is rebuilt from the rows that remain, so it has
  // to run after the delete rather than alongside it.
  await adjustSkillXp(supabase, user.id, existing.skill_id, -existing.xp_awarded);
  await recomputeStreak(supabase, user.id);

  revalidatePath("/field-log");
  revalidatePath("/today");
  redirect("/field-log?deleted=1");
}
