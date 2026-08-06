import "server-only";

import { cache } from "react";

import { createClient } from "@/lib/supabase/server";
import { eligibility, MAX_REPS_PER_REVIEW, type Eligibility } from "./eligibility";
import type { ReviewableRep } from "./prompt";
import type { RepReview } from "./review";

export type StoredReview = {
  id: string;
  review: RepReview;
  coversThrough: string;
  repsRead: number;
  repsTotal: number;
  createdAt: string;
};

export const getLatestReview = cache(async (): Promise<StoredReview | null> => {
  const supabase = await createClient();

  const { data } = await supabase
    .from("rep_reviews")
    .select("id, review_json, covers_through, reps_read, reps_total, created_at")
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (!data) return null;

  return {
    id: data.id,
    review: data.review_json as RepReview,
    coversThrough: data.covers_through,
    repsRead: data.reps_read,
    repsTotal: data.reps_total,
    createdAt: data.created_at,
  };
});

export type CoachState = {
  latest: StoredReview | null;
  repsTotal: number;
  eligibility: Eligibility;
};

export async function getCoachState(): Promise<CoachState> {
  const supabase = await createClient();
  const latest = await getLatestReview();

  const [{ count: total }, { count: since }] = await Promise.all([
    supabase.from("field_logs").select("id", { count: "exact", head: true }),
    latest
      ? supabase
          .from("field_logs")
          .select("id", { count: "exact", head: true })
          .gt("logged_at", latest.coversThrough)
      : Promise.resolve({ count: null }),
  ]);

  const repsTotal = total ?? 0;
  const repsSinceLastReview = latest ? (since ?? 0) : repsTotal;

  return {
    latest,
    repsTotal,
    eligibility: eligibility({
      repsTotal,
      repsSinceLastReview,
      hasReview: Boolean(latest),
    }),
  };
}

/**
 * The reps a new review should read: everything logged since the last one.
 *
 * Capped and taken from the most recent end. Someone returning after three
 * months should not fire off a request several times the size of a normal one,
 * and a pattern from last spring is history rather than feedback.
 */
export async function getUnreadReps(
  coversThrough: string | null,
): Promise<{ reps: ReviewableRep[]; capped: boolean; newest: string | null }> {
  const supabase = await createClient();

  let query = supabase
    .from("field_logs")
    .select(
      "logged_at, logged_date, went, context_note, reflection, mission_text, skills(name, topics(name))",
    )
    .order("logged_at", { ascending: false })
    .limit(MAX_REPS_PER_REVIEW + 1);

  if (coversThrough) query = query.gt("logged_at", coversThrough);

  const { data, error } = await query;
  if (error) throw new Error(`Could not read the log: ${error.message}`);

  const rows = (data ?? []) as unknown as {
    logged_at: string;
    logged_date: string;
    went: number;
    context_note: string | null;
    reflection: string | null;
    mission_text: string | null;
    skills: { name: string; topics: { name: string } | null } | null;
  }[];

  const capped = rows.length > MAX_REPS_PER_REVIEW;
  const kept = capped ? rows.slice(0, MAX_REPS_PER_REVIEW) : rows;

  return {
    // The watermark is the newest rep read, whether or not older ones were
    // dropped by the cap. Anything trimmed is treated as read: it is not
    // coming back, and carrying it forever would make every future review
    // more expensive than the last.
    newest: rows[0]?.logged_at ?? null,
    capped,
    // Oldest first, so the read follows the order things happened in.
    reps: kept
      .slice()
      .reverse()
      .map((row) => ({
        date: row.logged_date,
        topic: row.skills?.topics?.name ?? "Unfiled",
        skill: row.skills?.name ?? "a skill",
        went: row.went,
        context: row.context_note,
        reflection: row.reflection,
        mission: row.mission_text,
      })),
  };
}
