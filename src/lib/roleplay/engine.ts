import "server-only";

import type { SupabaseClient } from "@supabase/supabase-js";

import { AnthropicPartner } from "./anthropic";
import { checkLimit, type AiKind, type LimitVerdict } from "./limits";
import { ScriptedPartner, type PartnerEngine } from "./partner";

/**
 * Whether real, paid calls are being made.
 *
 * The key's presence is the switch. There is deliberately no separate feature
 * flag: a flag can disagree with reality, and the failure mode of that
 * disagreement is either a dead screen or a surprise bill.
 */
export function isUsingRealModel(): boolean {
  return Boolean(process.env.ANTHROPIC_API_KEY?.trim());
}

/**
 * Chooses which partner produces the words.
 *
 * Without a key this falls back to the scripted partner rather than failing.
 * That keeps the app usable for anyone running it locally without an Anthropic
 * account, and it keeps the test suite free — the scripted stand-in is
 * behaviourally correct about openness even though its prose is thin.
 */
export function getPartnerEngine(): PartnerEngine {
  return isUsingRealModel() ? new AnthropicPartner() : new ScriptedPartner();
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

  // Which way to fail depends on what a call costs. With the scripted engine a
  // read error should not block anybody, since the worst case is free. With
  // the real engine the ledger is the only thing standing between a bug in a
  // loop and a bill, so an unreadable ledger has to mean no.
  if (error) {
    return isUsingRealModel()
      ? { allowed: false, retryAfterMinutes: 1 }
      : { allowed: true, remaining: 0 };
  }

  return checkLimit(kind, (data ?? []).map((r) => new Date(r.created_at)));
}

export async function recordAiRequest(
  client: SupabaseClient,
  userId: string,
  kind: AiKind,
): Promise<void> {
  await client.from("ai_requests").insert({ user_id: userId, kind });
}
