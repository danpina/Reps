import "server-only";

import { cache } from "react";

import { getSessionUser } from "@/lib/auth/dal";
import { createClient } from "@/lib/supabase/server";

/**
 * What a free account gets.
 *
 * These two numbers are stated in SQL as well — in `is_preview_lesson` and in
 * `rehearsal_allowed` — and the database is the copy that decides. These exist
 * so the pages can say the number out loud without guessing at it, and so
 * changing the offer means changing a migration and a constant rather than
 * hunting through prose.
 */
export const FREE_PREVIEW_LESSONS = 2;
export const FREE_REHEARSALS = 1;

export type Subscription = {
  status: "active" | "trialing" | "past_due" | "canceled";
  source: "manual" | "stripe";
  current_period_end: string | null;
};

/**
 * Whether the signed-in user is entitled to the paid product.
 *
 * Asks the same function the row level security policies ask, rather than
 * reimplementing the rule in TypeScript. Two copies of an access rule are two
 * chances to disagree, and the one the pages use would be the wrong one to
 * trust.
 */
export const isPro = cache(async (): Promise<boolean> => {
  const user = await getSessionUser();
  if (!user) return false;

  const supabase = await createClient();
  const { data, error } = await supabase.rpc("is_pro");

  if (error) return false;
  return data === true;
});

export const getSubscription = cache(async (): Promise<Subscription | null> => {
  const user = await getSessionUser();
  if (!user) return null;

  const supabase = await createClient();
  const { data } = await supabase
    .from("subscriptions")
    .select("status, source, current_period_end")
    .eq("user_id", user.id)
    .maybeSingle();

  return data;
});

/**
 * How many paid rehearsals a free account has left.
 *
 * Only the AI modes are counted. The drills — one-line and read-and-decide —
 * are decided entirely from what the lesson author wrote down, so they cost
 * nothing to run and are not rationed. That is not generosity: a drill works
 * by being repeated, and one attempt at a drill teaches nobody anything.
 *
 * Pro accounts get null rather than a number: they are bounded by the rate
 * limits in `lib/roleplay/limits`, which is a different question with a
 * different answer, and reporting "unlimited" as a count would be a lie the
 * moment an hourly limit bites.
 */
export const rehearsalsLeft = cache(async (): Promise<number | null> => {
  if (await isPro()) return null;

  const supabase = await createClient();
  const { count } = await supabase
    .from("roleplays")
    .select("id", { count: "exact", head: true })
    .in("mode", ["beat", "scene"]);

  return Math.max(0, FREE_REHEARSALS - (count ?? 0));
});
