import type { RepReview } from "./review";

/** One logged conversation, flattened to what a reviewer actually needs. */
export type ReviewableRep = {
  date: string;
  topic: string;
  skill: string;
  /** 1 poorly, 2 mixed, 3 well. */
  went: number;
  context: string | null;
  reflection: string | null;
  mission: string | null;
};

const WENT_WORD: Record<number, string> = {
  1: "went badly",
  2: "was mixed",
  3: "went well",
};

export function buildCoachSystemPrompt(): string {
  return [
    "You are reading someone's practice log. They have been going out and having real conversations on purpose, and writing a line about each one afterwards.",
    "",
    "Your job is to find what keeps happening. Not to encourage, not to summarise, and not to coach a single conversation — they get that elsewhere. A pattern across ten conversations is something the person cannot see themselves, and it is the only thing you can offer that they could not.",
    "",
    "# What a good read does",
    "",
    "- Names two to four things that recur, and points at the entries that show it.",
    "- Says what is working, in the same specific terms as the criticism. A read that is only faults is both unpleasant and inaccurate.",
    "- Names exactly one change. Not five. Someone given five changes makes none.",
    "- Ends with something to do in the next conversation, concrete enough that they know whether they did it.",
    "",
    "# What a good read never does",
    "",
    "- Invents detail. You have only what they wrote. If the log is thin, say the pattern is tentative rather than dressing a guess as a finding.",
    "- Diagnoses the person. 'You avoid conflict' is a claim about a character; 'four of these ended as soon as they disagreed with you' is a claim about a log. Make the second kind.",
    "- Comments on the rating alone. Someone rating conversations badly may be honest rather than bad at this, and a run of ones next to thoughtful reflections usually means high standards.",
    "- Congratulates them for logging. They know.",
    "",
    "# Tone",
    "",
    "Plain, specific and unsentimental, like a coach who has watched a lot of people do this and is not impressed or disappointed by any of it. Short sentences. British spelling. Never use the word journey.",
  ].join("\n");
}

/**
 * The reps to read, and — where there is one — the previous read to build on.
 *
 * The previous review is included as its conclusions rather than as the reps it
 * was drawn from. That is the whole economy of this feature: the older
 * conversations are represented by what was already concluded about them,
 * which costs a paragraph instead of forty entries, and stops the model
 * arriving at the same three observations every time it runs.
 */
export function buildCoachUserPrompt({
  reps,
  previous,
  repsTotal,
  capped,
}: {
  reps: ReviewableRep[];
  previous: RepReview | null;
  repsTotal: number;
  capped: boolean;
}): string {
  const parts: string[] = [];

  if (previous) {
    parts.push(
      "# Your previous read of this log",
      "",
      `Headline: ${previous.headline}`,
      "",
      "Patterns you named:",
      ...previous.patterns.map((p) => `- ${p.title}: ${p.detail}`),
      "",
      `Working: ${previous.working}`,
      `The one change you asked for: ${previous.oneThing}`,
      "",
      "# What is new",
      "",
      "Below are only the conversations logged since that read. You are not seeing the earlier ones again.",
      "",
      "Do not restate your previous read. Say what has changed since it, whether the change you asked for actually happened, and what is new. If a pattern you named has gone, say so — that is the most useful sentence you can write.",
      "",
    );
  } else {
    parts.push(
      "# Their log",
      "",
      `This is the first read of this log. There are ${repsTotal} conversations in it.`,
      "",
    );
  }

  if (capped) {
    parts.push(
      `Only the most recent ${reps.length} are shown. Older ones exist and are not included.`,
      "",
    );
  }

  parts.push("# The conversations", "");

  for (const rep of reps) {
    const line = [
      `## ${rep.date} — ${rep.topic}, ${rep.skill} (${WENT_WORD[rep.went] ?? "unrated"})`,
    ];
    if (rep.mission) line.push(`Mission: ${rep.mission}`);
    if (rep.context) line.push(`Where: ${rep.context}`);
    line.push(rep.reflection ? `Note: ${rep.reflection}` : "Note: none written.");
    parts.push(line.join("\n"), "");
  }

  parts.push(
    "Now write the read. Two to four patterns, what is working, one change, and one thing to do in the next conversation.",
  );

  return parts.join("\n");
}
