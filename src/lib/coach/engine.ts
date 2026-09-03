import "server-only";

import Anthropic from "@anthropic-ai/sdk";

import type { Locale } from "@/lib/curriculum/locale";
import {
  buildCoachSystemPrompt,
  buildCoachUserPrompt,
  type Coachee,
  type ReviewableRep,
} from "./prompt";
import { parseReview, reviewSchema, type ParsedReview, type RepReview } from "./review";

const MODEL = process.env.ANTHROPIC_MODEL?.trim() || "claude-opus-5";

/** A read is several paragraphs, and the reasoning that earns them. */
const MAX_TOKENS = 8000;

/**
 * Longer than the rehearsal calls allow. Nobody is mid-conversation waiting
 * for this one — they have pressed a button and expect it to take a moment —
 * and reading thirty conversations properly is not a quick job.
 */
const TIMEOUT_MS = 120_000;

let client: Anthropic | null = null;

function getClient(): Anthropic {
  if (!client) {
    client = new Anthropic({
      apiKey: process.env.ANTHROPIC_API_KEY,
      maxRetries: 2,
      timeout: TIMEOUT_MS,
    });
  }
  return client;
}

/** Every failure phrased for the person who pressed the button. */
function readableError(error: unknown): string {
  if (error instanceof Anthropic.AuthenticationError) {
    return "The reviewer is not configured on this deployment.";
  }
  if (error instanceof Anthropic.RateLimitError) {
    return "The reviewer is busy right now. Try again in a minute.";
  }
  if (error instanceof Anthropic.APIConnectionTimeoutError) {
    return "The review took too long. Try again.";
  }
  if (error instanceof Anthropic.APIConnectionError) {
    return "The reviewer could not be reached. Check your connection.";
  }
  if (error instanceof Anthropic.APIError) {
    const transient = typeof error.status === "number" && error.status >= 500;
    return transient
      ? "The reviewer is temporarily overloaded. Try again in a minute."
      : "The review could not be produced.";
  }
  return "The review failed unexpectedly. Try again.";
}

export type ReviewResult =
  | { ok: true; review: RepReview }
  | { ok: false; reason: string };

/**
 * Reads a stack of logged conversations and reports what keeps happening.
 *
 * Only the reps it is given, which by the time it gets here are only the ones
 * no previous review has seen. The older ones arrive as the previous review's
 * own conclusions, which is a paragraph rather than forty entries — cheaper on
 * every run after the first, and it stops the model rediscovering the same
 * three observations and phrasing them differently.
 */
export async function readTheLog(input: {
  reps: ReviewableRep[];
  previous: RepReview | null;
  repsTotal: number;
  capped: boolean;
  coachee: Coachee;
  locale: Locale;
}): Promise<ReviewResult> {
  if (input.reps.length === 0) {
    return { ok: false, reason: "There is nothing new to read." };
  }

  let message: Anthropic.Message;
  try {
    message = await getClient().messages.create({
      model: MODEL,
      max_tokens: MAX_TOKENS,
      // Cached: the brief is identical on every review anyone ever runs, and
      // it is the largest fixed part of the request.
      system: [
        {
          type: "text",
          text: buildCoachSystemPrompt(input.locale),
          cache_control: { type: "ephemeral" },
        },
      ],
      output_config: {
        // This is the output the whole feature is judged by, and a shallow
        // read of thirty real conversations would be worse than none.
        effort: "high",
        format: { type: "json_schema", schema: reviewSchema },
      },
      messages: [{ role: "user", content: buildCoachUserPrompt(input) }],
    });
  } catch (error) {
    return { ok: false, reason: readableError(error) };
  }

  if (message.stop_reason === "refusal") {
    return { ok: false, reason: "The review could not be produced for this log." };
  }

  const raw = message.content
    .filter((block): block is Anthropic.TextBlock => block.type === "text")
    .map((block) => block.text)
    .join("")
    .trim();

  if (!raw) return { ok: false, reason: "The review came back empty." };

  const parsed: ParsedReview = parseReview(raw);
  if (!parsed.ok) return { ok: false, reason: parsed.reason };

  return { ok: true, review: parsed.review };
}
