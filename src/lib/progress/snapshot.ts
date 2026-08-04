import "server-only";

import type { SupabaseClient } from "@supabase/supabase-js";

import { newlyEarned, type Badge, type ProgressSnapshot } from "./badges";

type Client = SupabaseClient;

/** Gathers everything the badge criteria need, in one pass. */
export async function buildSnapshot(client: Client): Promise<ProgressSnapshot> {
  const [{ data: logs }, { data: streak }] = await Promise.all([
    client.from("field_logs").select("went, rewrite, skills(slug)"),
    client.from("streaks").select("longest").maybeSingle(),
  ]);

  const rows = (logs ?? []) as unknown as {
    went: number;
    rewrite: string | null;
    skills: { slug: string } | null;
  }[];

  const repsBySkillSlug: Record<string, number> = {};
  let failuresLogged = 0;
  let rewrites = 0;

  for (const row of rows) {
    const slug = row.skills?.slug;
    if (slug) repsBySkillSlug[slug] = (repsBySkillSlug[slug] ?? 0) + 1;
    if (row.went === 1) failuresLogged++;
    if (row.rewrite?.trim()) rewrites++;
  }

  return {
    repsTotal: rows.length,
    failuresLogged,
    repsBySkillSlug,
    distinctSkills: Object.keys(repsBySkillSlug).length,
    longestStreak: streak?.longest ?? 0,
    rewrites,
  };
}

/**
 * Awards any badges the user has just qualified for. Safe to call after every
 * logged rep: the primary key on user_badges makes a repeat insert a no-op,
 * and a failure here must never take down the thing that earned it.
 */
export async function awardBadges(
  client: Client,
  userId: string,
): Promise<Badge[]> {
  try {
    const [{ data: badges }, { data: held }] = await Promise.all([
      client.from("badges").select("*").order("sort_order"),
      client.from("user_badges").select("badge_id"),
    ]);

    if (!badges?.length) return [];

    const snapshot = await buildSnapshot(client);
    const alreadyHeld = new Set((held ?? []).map((r) => r.badge_id));
    const earned = newlyEarned(badges as Badge[], snapshot, alreadyHeld);

    if (earned.length === 0) return [];

    await client
      .from("user_badges")
      .upsert(
        earned.map((badge) => ({ user_id: userId, badge_id: badge.id })),
        { onConflict: "user_id,badge_id", ignoreDuplicates: true },
      );

    return earned;
  } catch {
    // Logging the rep is what matters. A badge can be picked up next time.
    return [];
  }
}
