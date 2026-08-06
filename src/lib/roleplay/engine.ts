import "server-only";

import type { SupabaseClient } from "@supabase/supabase-js";

import { AnthropicPartner } from "./anthropic";
import {
  checkLimit,
  checkSceneLimit,
  type AiKind,
  type LimitVerdict,
} from "./limits";
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

/**
 * Writes a call into the ledger, and says whether the write landed.
 *
 * The result is not decoration. Every limit in this app is counted from these
 * rows, so a write that fails silently switches the limits off without
 * anything saying so — the calls keep being made and nothing counts them.
 * That failure is invisible by construction, which makes it exactly the kind
 * worth being loud about.
 *
 * The asymmetry matches the read path for the same reason: with the scripted
 * engine an uncounted call costs nothing, so it is not worth blocking a
 * rehearsal over. With the real engine the ledger is the only thing standing
 * between a loop and a bill, and a call that cannot be counted must not be
 * made.
 */
export async function recordAiRequest(
  client: SupabaseClient,
  userId: string,
  kind: AiKind,
): Promise<{ ok: boolean }> {
  const { error } = await client
    .from("ai_requests")
    .insert({ user_id: userId, kind });

  if (!error) return { ok: true };

  // The only channel out of a server action. Worth the noise: this means the
  // rate limits are not counting, which nothing else will reveal.
  console.error(
    `[roleplay] ledger write failed for ${kind}: ${error.message}. Rate limits are not counting.`,
  );

  return { ok: !isUsingRealModel() };
}

/**
 * Whether this user may open another scene today.
 *
 * Counted from the scenes themselves rather than from a second ledger: a
 * roleplay row is created exactly once per scene, so it is already the record
 * this needs, and a count that cannot drift from the thing it counts is worth
 * more than a tidier table.
 *
 * Fails closed for the same reason the AI limits do — the whole point is to
 * bound what a broken or hostile client can start.
 */
export async function checkSceneStartLimit(
  client: SupabaseClient,
): Promise<LimitVerdict> {
  const since = new Date(Date.now() - 24 * 60 * 60_000).toISOString();

  const { data, error } = await client
    .from("roleplays")
    .select("started_at")
    .gte("started_at", since);

  if (error) return { allowed: false, retryAfterMinutes: 1 };

  return checkSceneLimit((data ?? []).map((r) => new Date(r.started_at)));
}
