"use server";

import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";

import { requireUser } from "@/lib/auth/dal";
import { getTopics } from "@/lib/curriculum/queries";
import {
  parseAgeGroup,
  parseDatingInterest,
  parseSex,
} from "@/lib/profile/demographics";
import { createClient } from "@/lib/supabase/server";

export type WelcomeState = { error?: string };

export async function completeOnboarding(
  _prev: WelcomeState,
  formData: FormData,
): Promise<WelcomeState> {
  const user = await requireUser();
  const supabase = await createClient();

  const displayName = String(formData.get("display_name") ?? "").trim();
  const topicSlug = String(formData.get("topic") ?? "");
  const timezone = String(formData.get("timezone") ?? "").trim();

  if (!displayName) return { error: "What should the app call you?" };
  if (displayName.length > 60) return { error: "That name is a bit long." };

  // Checked against the topics that actually exist rather than a list kept in
  // the code, so adding a topic is one migration and nothing else.
  const topic = (await getTopics()).find((t) => t.slug === topicSlug);
  if (!topic) return { error: "Pick where you want to start." };

  const patch: Record<string, string | null> = {
    display_name: displayName,
    starting_topic_id: topic.id,
    onboarded_at: new Date().toISOString(),
    // Both are allowed to be skipped, and a skipped answer is stored as
    // nothing rather than as a default. Anything that reads these has to cope
    // with not knowing anyway.
    sex: parseSex(formData.get("sex")),
    age_group: parseAgeGroup(formData.get("age_group")),
    dating_interest: parseDatingInterest(formData.get("dating_interest")),
  };

  // Same loose IANA check as the log action.
  if (timezone && timezone.length <= 64 && /^[A-Za-z0-9+_\-/]+$/.test(timezone)) {
    patch.timezone = timezone;
  }

  const { error } = await supabase
    .from("profiles")
    .update(patch)
    .eq("id", user.id);

  if (error) return { error: `That did not save: ${error.message}` };

  revalidatePath("/today");

  // Straight into the first lesson when there is one. Landing on a list after
  // choosing from a list is a click that teaches nothing.
  const first = topic.skills[0];
  redirect(first ? `/skills/${first.slug}/1` : `/topics/${topic.slug}`);
}
