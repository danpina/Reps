/**
 * The shape of a read of the log, and the parsing that keeps it honest.
 *
 * Same posture as the rehearsal feedback parser: the model is asked for strict
 * JSON and will occasionally not comply, and none of that may take down a
 * screen the user has waited thirty seconds for. Every failure resolves to a
 * typed reason the page can show.
 */

export type Pattern = {
  title: string;
  detail: string;
  /** What in the log supports this. Kept so a claim can be checked. */
  evidence: string;
};

export type RepReview = {
  /** One sentence. The single most useful thing the log says. */
  headline: string;
  /** Two to four things that keep happening. */
  patterns: Pattern[];
  /** What is clearly working, so the read is not only a list of faults. */
  working: string;
  /** The one change to make. Exactly one, on purpose. */
  oneThing: string;
  /** Something to do in the next conversation, concrete enough to act on. */
  nextRep: string;
};

export type ParsedReview =
  | { ok: true; review: RepReview }
  | { ok: false; reason: string };

/** The envelope the model is asked to produce. */
export const reviewSchema = {
  type: "object",
  additionalProperties: false,
  required: ["headline", "patterns", "working", "one_thing", "next_rep"],
  properties: {
    headline: { type: "string" },
    patterns: {
      type: "array",
      minItems: 2,
      maxItems: 4,
      items: {
        type: "object",
        additionalProperties: false,
        required: ["title", "detail", "evidence"],
        properties: {
          title: { type: "string" },
          detail: { type: "string" },
          evidence: { type: "string" },
        },
      },
    },
    working: { type: "string" },
    one_thing: { type: "string" },
    next_rep: { type: "string" },
  },
} as const;

function extractJson(raw: string): string | null {
  if (!raw?.trim()) return null;

  const fenced = /```(?:json)?\s*([\s\S]*?)```/i.exec(raw);
  const candidate = (fenced ? fenced[1] : raw).trim();

  const start = candidate.indexOf("{");
  const end = candidate.lastIndexOf("}");
  if (start === -1 || end === -1 || end <= start) return null;

  return candidate.slice(start, end + 1);
}

function text(value: unknown): string {
  return typeof value === "string" ? value.trim() : "";
}

export function parseReview(raw: string): ParsedReview {
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

  const headline = text(body.headline);
  if (!headline) return { ok: false, reason: "The review had no headline." };

  if (!Array.isArray(body.patterns)) {
    return { ok: false, reason: "The review had no patterns." };
  }

  const patterns: Pattern[] = [];
  for (const item of body.patterns) {
    if (typeof item !== "object" || item === null) continue;
    const row = item as Record<string, unknown>;
    const title = text(row.title);
    const detail = text(row.detail);
    const evidence = text(row.evidence);
    if (title && detail) patterns.push({ title, detail, evidence });
  }

  // Two is the point at which "a pattern" stops being "a thing that happened
  // once". Fewer than that and the review has not earned its name.
  if (patterns.length < 2) {
    return { ok: false, reason: "The review found fewer than two patterns." };
  }
  // More than four is a list, and a list is what someone does instead of
  // deciding what matters. Trimmed rather than rejected.
  if (patterns.length > 4) patterns.length = 4;

  const working = text(body.working);
  const oneThing = text(body.one_thing);
  const nextRep = text(body.next_rep);

  if (!working) return { ok: false, reason: "The review said nothing about what is working." };
  if (!oneThing) return { ok: false, reason: "The review named no single change." };
  if (!nextRep) return { ok: false, reason: "The review gave nothing to do next." };

  return {
    ok: true,
    review: { headline, patterns, working, oneThing, nextRep },
  };
}
