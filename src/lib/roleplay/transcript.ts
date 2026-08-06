import type { Rubric } from "@/lib/curriculum/types";
import type { Turn } from "./partner";

/**
 * Turning a stored transcript into something the API will accept.
 *
 * Kept pure and separate from the client so the shaping rules can be asserted
 * without a network call or a key — these are the rules that produce a 400 at
 * runtime if they are wrong, and a 400 mid-rehearsal costs the user their
 * place in a conversation.
 */

export type ApiMessage = { role: "user" | "assistant"; content: string };

/**
 * The scene so far, as an alternating conversation.
 *
 * Two constraints come from the API rather than from us: the first message must
 * be from the user, and the last must not be from the assistant. A trailing
 * assistant turn is read as a prefill, which current models reject outright.
 * Both are enforced here rather than trusted, because the transcript is stored
 * data and stored data drifts.
 */
export function toMessages(history: Turn[]): ApiMessage[] {
  const messages: ApiMessage[] = history
    .filter((turn) => turn.content.trim().length > 0)
    .map((turn) => ({
      role: turn.role === "user" ? ("user" as const) : ("assistant" as const),
      content: turn.content.trim(),
    }));

  // The partner's opening line lives in the system prompt, so a transcript
  // that begins with it would open the conversation on the wrong role.
  while (messages.length > 0 && messages[0].role === "assistant") {
    messages.shift();
  }

  // Nothing to reply to. Dropping the trailing partner turns would lose the
  // scene, so this is a real error rather than something to paper over.
  while (messages.length > 0 && messages.at(-1)!.role === "assistant") {
    messages.pop();
  }

  return messages;
}

/**
 * The transcript as text, for the review pass.
 *
 * The reviewer is handed the conversation as a document to analyse, not as a
 * conversation to continue. That keeps the two calls' contexts genuinely
 * separate — the partner must never learn it is being scored — and sidesteps
 * the trailing-turn rule above, since the transcript often ends on the partner.
 *
 * Both labels are third-person on purpose. The reviewer is neither party, so a
 * second-person label points at someone it is not, and the review then
 * attributes the learner's lines to the only name in its context — the
 * partner's. Naming both roles outright is what keeps the feedback about the
 * right person.
 */
export function renderTranscript(history: Turn[]): string {
  return history
    .filter((turn) => turn.content.trim().length > 0)
    .map(
      (turn) =>
        `${turn.role === "user" ? "LEARNER" : "PARTNER"}: ${turn.content.trim()}`,
    )
    .join("\n");
}

/**
 * The JSON schema the review pass is constrained to.
 *
 * Built from the lesson's own rubric so the score keys cannot drift from the
 * criteria being scored. Structured outputs guarantee the envelope — valid
 * JSON, every criterion present, no markdown fence — which leaves the parser
 * free to do the part a schema cannot: checking that the quoted line was
 * actually said, and that the rewrite is not the original again.
 *
 * Numeric bounds and array lengths are deliberately absent: the API's schema
 * subset does not support them, and the parser already clamps scores into the
 * rubric's scale and takes exactly two positives.
 */
export function feedbackSchema(rubric: Rubric): Record<string, unknown> {
  const scoreProperties: Record<string, unknown> = {};
  for (const criterion of rubric.criteria) {
    scoreProperties[criterion.key] = {
      type: "integer",
      description: `${criterion.label}. ${criterion.description}`,
    };
  }

  return {
    type: "object",
    properties: {
      scores: {
        type: "object",
        properties: scoreProperties,
        required: rubric.criteria.map((c) => c.key),
        additionalProperties: false,
      },
      worked: {
        type: "array",
        items: { type: "string" },
        description: "Exactly two things the learner actually did well.",
      },
      fix: {
        type: "string",
        description: "The single highest-leverage change, in one sentence.",
      },
      rewrite: {
        type: "object",
        properties: {
          original: {
            type: "string",
            description:
              "A LEARNER line, copied verbatim from the transcript.",
          },
          better: { type: "string" },
          why: { type: "string" },
        },
        required: ["original", "better", "why"],
        additionalProperties: false,
      },
    },
    required: ["scores", "worked", "fix", "rewrite"],
    additionalProperties: false,
  };
}
