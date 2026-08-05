import type { Rubric } from "@/lib/curriculum/types";

/**
 * Parsing for the feedback pass.
 *
 * The model is asked for strict JSON, and sometimes it will not comply: a
 * markdown fence, a sentence of preamble, a truncated response, a criterion
 * key that does not exist. None of that may take down a session the user has
 * just spent ten minutes on, so every failure resolves to a typed error the
 * UI can show rather than to an exception.
 */

export type Rewrite = { original: string; better: string; why: string };

export type Feedback = {
  scores: Record<string, number>;
  worked: [string, string];
  fix: string;
  rewrite: Rewrite;
};

export type ParseResult =
  | { ok: true; feedback: Feedback; warnings: string[] }
  | { ok: false; reason: string };

/**
 * Pulls the JSON object out of a response that may be wrapped in prose or
 * fences. Deliberately tolerant: getting usable feedback out of a slightly
 * misbehaving response is worth more than being strict about the envelope.
 */
export function extractJson(raw: string): string | null {
  if (!raw?.trim()) return null;

  const fenced = /```(?:json)?\s*([\s\S]*?)```/i.exec(raw);
  const candidate = (fenced ? fenced[1] : raw).trim();

  const start = candidate.indexOf("{");
  const end = candidate.lastIndexOf("}");
  if (start === -1 || end === -1 || end <= start) return null;

  return candidate.slice(start, end + 1);
}

/** Normalises a line for comparison: case, punctuation and spacing. */
function normalise(text: string): string {
  return text
    .toLowerCase()
    .replace(/[‘’]/g, "'")
    .replace(/[“”]/g, '"')
    .replace(/[^a-z0-9' ]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

/**
 * The brief asks for a rewrite of a line the user actually wrote. A model will
 * occasionally paraphrase or invent one, which quietly makes the feedback
 * about a conversation that did not happen.
 */
export function quotedLineWasSaid(
  original: string,
  userTurns: string[],
): boolean {
  const needle = normalise(original);
  if (!needle) return false;
  return userTurns.some((turn) => {
    const hay = normalise(turn);
    return hay.includes(needle) || needle.includes(hay);
  });
}

export function parseFeedback(
  raw: string,
  rubric: Rubric,
  userTurns: string[],
): ParseResult {
  const json = extractJson(raw);
  if (!json) return { ok: false, reason: "No JSON object in the response." };

  let parsed: unknown;
  try {
    parsed = JSON.parse(json);
  } catch {
    return { ok: false, reason: "The response was not valid JSON." };
  }

  if (typeof parsed !== "object" || parsed === null || Array.isArray(parsed)) {
    return { ok: false, reason: "The response was not a JSON object." };
  }

  const body = parsed as Record<string, unknown>;
  const warnings: string[] = [];

  // Scores: every criterion present, clamped into the rubric's scale. A score
  // slightly out of range is worth clamping rather than discarding.
  const rawScores = body.scores;
  if (typeof rawScores !== "object" || rawScores === null) {
    return { ok: false, reason: "The response had no scores." };
  }

  const scores: Record<string, number> = {};
  for (const criterion of rubric.criteria) {
    const value = (rawScores as Record<string, unknown>)[criterion.key];
    if (typeof value !== "number" || Number.isNaN(value)) {
      return { ok: false, reason: `Missing a score for ${criterion.key}.` };
    }
    const clamped = Math.min(rubric.scale.max, Math.max(rubric.scale.min, value));
    if (clamped !== value) warnings.push(`Score for ${criterion.key} was out of range.`);
    scores[criterion.key] = Math.round(clamped);
  }

  // Exactly two things that worked. The brief is specific, but trimming a
  // third is better than throwing away the whole response.
  const rawWorked = body.worked;
  if (!Array.isArray(rawWorked)) {
    return { ok: false, reason: "The response had no list of what worked." };
  }
  const workedItems = rawWorked.filter(
    (item): item is string => typeof item === "string" && item.trim().length > 0,
  );
  if (workedItems.length < 2) {
    return { ok: false, reason: "Fewer than two things that worked." };
  }
  if (workedItems.length > 2) warnings.push("More than two positives were returned.");
  const worked: [string, string] = [workedItems[0].trim(), workedItems[1].trim()];

  const fix = typeof body.fix === "string" ? body.fix.trim() : "";
  if (!fix) return { ok: false, reason: "No single fix was given." };

  const rawRewrite = body.rewrite;
  if (typeof rawRewrite !== "object" || rawRewrite === null) {
    return { ok: false, reason: "No rewrite was given." };
  }
  const r = rawRewrite as Record<string, unknown>;
  const original = typeof r.original === "string" ? r.original.trim() : "";
  const better = typeof r.better === "string" ? r.better.trim() : "";
  const why = typeof r.why === "string" ? r.why.trim() : "";

  if (!original || !better) {
    return { ok: false, reason: "The rewrite was incomplete." };
  }

  if (!quotedLineWasSaid(original, userTurns)) {
    return {
      ok: false,
      reason: "The rewrite quoted a line the user never said.",
    };
  }

  return {
    ok: true,
    warnings,
    feedback: { scores, worked, fix, rewrite: { original, better, why } },
  };
}

/** Mean score across criteria, for the history list. */
export function averageScore(scores: Record<string, number>): number {
  const values = Object.values(scores);
  if (values.length === 0) return 0;
  return values.reduce((a, b) => a + b, 0) / values.length;
}
