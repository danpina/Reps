import "server-only";

import Anthropic from "@anthropic-ai/sdk";

import type { Rubric, Scenario } from "@/lib/curriculum/types";
import { parseFeedback } from "./feedback";
import { PartnerError, type PartnerEngine, type Turn } from "./partner";
import { buildFeedbackPrompt, buildSystemPrompt } from "./prompt";
import { feedbackSchema, renderTranscript, toMessages } from "./transcript";

/**
 * The real partner.
 *
 * Two calls, deliberately kept apart. The partner is a character who must not
 * know it is being observed; the reviewer is a coach who never speaks in the
 * scene. Sharing a context between them would let the partner play to the
 * rubric, which is exactly the tell that makes practice feel fake.
 */

const MODEL = process.env.ANTHROPIC_MODEL?.trim() || "claude-opus-5";

/**
 * A rehearsal turn is one or two spoken sentences, but thinking counts against
 * this ceiling too, so it is set well above the visible answer. The prompt does
 * the work of keeping replies short; this only stops a runaway.
 */
const PARTNER_MAX_TOKENS = 1500;

/** The review is a page of JSON and the reasoning that earns it. */
const FEEDBACK_MAX_TOKENS = 8000;

/**
 * Long enough for a considered review, short enough that a hung request does
 * not hold a server action open until the platform kills it.
 */
const TIMEOUT_MS = 90_000;

let client: Anthropic | null = null;

function getClient(): Anthropic {
  if (!client) {
    client = new Anthropic({
      apiKey: process.env.ANTHROPIC_API_KEY,
      // The SDK already retries 429s and 5xxs with backoff. Two is enough:
      // a person is waiting for this reply.
      maxRetries: 2,
      timeout: TIMEOUT_MS,
    });
  }
  return client;
}

/**
 * Every failure a user can hit, phrased for someone mid-conversation rather
 * than for a log. None of these mention the model, because from inside the
 * scene the model is not a thing that exists.
 */
function asPartnerError(error: unknown, what: "reply" | "review"): PartnerError {
  const subject = what === "reply" ? "Your partner" : "The review";

  if (error instanceof Anthropic.AuthenticationError) {
    return new PartnerError(
      `${subject} is not configured. The API key is missing or rejected.`,
      { cause: error },
    );
  }
  if (error instanceof Anthropic.PermissionDeniedError) {
    return new PartnerError(
      `${subject} is not available on this API key.`,
      { cause: error },
    );
  }
  if (error instanceof Anthropic.RateLimitError) {
    return new PartnerError(
      `${subject} is busy right now. Wait a moment and try that again.`,
      { cause: error },
    );
  }
  if (error instanceof Anthropic.APIConnectionTimeoutError) {
    return new PartnerError(`${subject} took too long. Try that again.`, {
      cause: error,
    });
  }
  if (error instanceof Anthropic.APIConnectionError) {
    return new PartnerError(`${subject} could not be reached. Check your connection.`, {
      cause: error,
    });
  }
  if (error instanceof Anthropic.APIError) {
    // 529 and 5xx are transient; a 400 is our bug and the user can do nothing
    // about it either way, so both get an honest, actionable sentence.
    const transient = typeof error.status === "number" && error.status >= 500;
    return new PartnerError(
      transient
        ? `${subject} is temporarily overloaded. Try that again in a minute.`
        : `${subject} could not be produced. That line may have been too long or unusual.`,
      { cause: error },
    );
  }
  if (error instanceof PartnerError) return error;

  return new PartnerError(`${subject} failed unexpectedly. Try that again.`, {
    cause: error,
  });
}

/**
 * The visible answer, with any stray reasoning markup removed.
 *
 * Thinking is left on for these calls, so the text blocks should be clean.
 * The strip is cheap insurance: a leaked tag rendered into a chat bubble is
 * the single most immersion-breaking thing this screen could show.
 */
function textOf(message: Anthropic.Message): string {
  return message.content
    .filter((block): block is Anthropic.TextBlock => block.type === "text")
    .map((block) => block.text)
    .join("")
    .replace(/<\/?thinking>/gi, "")
    .trim();
}

/**
 * Refusals arrive as a successful response with an empty or partial body, so
 * this has to be checked before reading content rather than caught.
 */
function assertNotRefused(message: Anthropic.Message, what: "reply" | "review") {
  if (message.stop_reason === "refusal") {
    throw new PartnerError(
      what === "reply"
        ? "Your partner would not answer that. Try a different line."
        : "The review could not be produced for this conversation.",
      { refused: true },
    );
  }
}

export class AnthropicPartner implements PartnerEngine {
  readonly name = "anthropic";

  async nextTurn(scenario: Scenario, history: Turn[]): Promise<string> {
    const messages = toMessages(history);
    if (messages.length === 0) return scenario.opening_beat;

    let message: Anthropic.Message;
    try {
      message = await getClient().messages.create({
        model: MODEL,
        max_tokens: PARTNER_MAX_TOKENS,
        // Cached because the character sheet is identical on every turn of a
        // rehearsal, and a rehearsal is a dozen turns of the same prefix.
        system: [
          {
            type: "text",
            text: buildSystemPrompt(scenario),
            cache_control: { type: "ephemeral" },
          },
        ],
        // Low effort keeps the reply quick, which matters when someone is
        // waiting to speak. Thinking stays on rather than disabled: holding a
        // closed character's position against someone being charming at them
        // is a judgment call, and it is the one this drill exists to test.
        output_config: { effort: "low" },
        messages,
      });
    } catch (error) {
      throw asPartnerError(error, "reply");
    }

    assertNotRefused(message, "reply");

    const reply = textOf(message);
    if (!reply) {
      throw new PartnerError("Your partner said nothing. Try that line again.");
    }
    return reply;
  }

  async feedback(scenario: Scenario, rubric: Rubric, history: Turn[]) {
    const userTurns = history
      .filter((turn) => turn.role === "user")
      .map((turn) => turn.content);

    if (userTurns.length === 0) {
      return { ok: false as const, reason: "You did not say anything yet." };
    }

    let message: Anthropic.Message;
    try {
      message = await getClient().messages.create({
        model: MODEL,
        max_tokens: FEEDBACK_MAX_TOKENS,
        system: buildFeedbackPrompt(rubric),
        output_config: {
          // The review is the part users judge the app by, and a shallow one
          // reads as filler. Worth the tokens.
          effort: "high",
          // Guarantees the envelope: valid JSON, every criterion scored, no
          // markdown fence. What it cannot guarantee is that the quoted line
          // was really said, which is why parseFeedback still runs.
          format: { type: "json_schema", schema: feedbackSchema(rubric) },
        },
        messages: [
          {
            role: "user",
            content: [
              `# The scene`,
              `${scenario.setting} The partner is ${scenario.partner.name}, ${scenario.partner.role}.`,
              ``,
              `# What good looks like here`,
              scenario.success_looks_like,
              ``,
              `# The transcript`,
              renderTranscript(history),
            ].join("\n"),
          },
        ],
      });
    } catch (error) {
      throw asPartnerError(error, "review");
    }

    assertNotRefused(message, "review");

    const raw = textOf(message);
    if (!raw) {
      return { ok: false as const, reason: "The review came back empty." };
    }

    const parsed = parseFeedback(raw, rubric, userTurns);
    if (!parsed.ok) return { ok: false as const, reason: parsed.reason };

    return { ok: true as const, feedback: parsed.feedback };
  }
}
