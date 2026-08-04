"use server";

import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";

import { requireUser } from "@/lib/auth/dal";
import { createClient } from "@/lib/supabase/server";
import { CONTEXTS, FIRST_TRACK, type Context } from "./first-track";

export type WelcomeState = { error?: string };

export async function completeOnboarding(
  _prev: WelcomeState,
  formData: FormData,
): Promise<WelcomeState> {
  const user = await requireUser();
  const supabase = await createClient();

  const displayName = String(formData.get("display_name") ?? "").trim();
  const context = String(formData.get("onboarding_context") ?? "");
  const timezone = String(formData.get("timezone") ?? "").trim();

  if (!displayName) return { error: "What should the app call you?" };
  if (displayName.length > 60) return { error: "That name is a bit long." };
  if (!CONTEXTS.includes(context as Context)) {
    return { error: "Pick where you want to get better." };
  }

  const patch: Record<string, string> = {
    display_name: displayName,
    onboarding_context: context,
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
  redirect(`/skills/${FIRST_TRACK[context as Context]}/1`);
}
