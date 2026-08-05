import "server-only";

import type { SupabaseClient } from "@supabase/supabase-js";

import { checkLimit, type AiKind, type LimitVerdict } from "./limits";
import { ScriptedPartner, type PartnerEngine } from "./partner";

/**
 * Chooses which partner produces the words.
 *
 * Until an Anthropic key is configured this is always the scripted partner,
 * which costs nothing and behaves correctly with respect to openness. Adding
 * the real engine means returning a different implementation here; nothing
 * that calls this needs to change.
 */
export function getPartnerEngine(): PartnerEngine {
  return new ScriptedPartner();
}

export function isUsingRealModel(): boolean {
  return false;
}

/**
 * Rate limit check against the ledger. Reads the window from the database
 * rather than memory, since a serverless host gives no memory worth trusting.
 */
export async function checkRateLimit(
  client: SupabaseClient,
  kind: AiKind,
): Promise<LimitVerdict> {
  const since = new Date(Date.now() - 60 * 60_000).toISOString();

  const { data, error } = await client
    .from("ai_requests")
    .select("created_at")
    .eq("kind", kind)
    .gte("created_at", since);

  // Failing open on a read error is the right trade here: the scripted engine
  // costs nothing, and the alternative is blocking a user over a hiccup. This
  // must be revisited when real calls start costing money.
  if (error) return { allowed: true, remaining: 0 };

  return checkLimit(kind, (data ?? []).map((r) => new Date(r.created_at)));
}

export async function recordAiRequest(
  client: SupabaseClient,
  userId: string,
  kind: AiKind,
): Promise<void> {
  await client.from("ai_requests").insert({ user_id: userId, kind });
}
