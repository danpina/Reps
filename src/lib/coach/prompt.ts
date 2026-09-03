import { LOCALE_ENGLISH_NAMES, type Locale } from "@/lib/curriculum/locale";
import {
  describeSelf,
  type AgeGroup,
  type AgeRelation,
  type Sex,
} from "@/lib/profile/demographics";
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
  /** Who it was with, if the user said. A guess, and treated as one. */
  other: string | null;
  /** Where they sat relative to the user, when both ages are known. */
  otherAge: AgeRelation | null;
};

/** Who is being coached. Every field optional — most logs will know neither. */
export type Coachee = {
  sex: Sex | null;
  ageGroup: AgeGroup | null;
};

const WENT_WORD: Record<number, string> = {
  1: "went badly",
  2: "was mixed",
  3: "went well",
};

export function buildCoachSystemPrompt(locale: Locale): string {
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
    "# Who they are, and who they spoke to",
    "",
    "Some entries record the other person's sex and rough age. It is a guess made afterwards, so treat it as one — never quote it back as fact about a stranger, and never build a whole read on it.",
    "",
    "What it is genuinely good for is the gap. If the conversations that went flat were all with people a generation older, or all with men, or all with women, that is a real finding and it is one they cannot see themselves. Say it plainly and without embarrassment when the log shows it, and say nothing at all when it does not — three entries pointing the same way is a coincidence.",
    "",
    "Where you know their own age and sex, let it set the register rather than the content. The same advice is phrased differently for someone of twenty-two and someone of fifty-five, and a note about flirting written for the wrong one of those is worse than no note.",
    "",
    "Never generalise about a sex or an age group as a category of person. 'Women respond well to' is astrology. 'Four of your six flat conversations were with women' is a fact about a log.",
    "",
    "# Tone",
    "",
    `Plain, specific and unsentimental, like a coach who has watched a lot of people do this and is not impressed or disappointed by any of it. Short sentences.${locale === "en" ? " British spelling." : ""} Never use the word journey.`,
    "",
    `# Language`,
    "",
    `Write the whole read in ${LOCALE_ENGLISH_NAMES[locale]}, regardless of what language the log entries below are written in.`,
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
  coachee,
}: {
  reps: ReviewableRep[];
  previous: RepReview | null;
  repsTotal: number;
  capped: boolean;
  coachee: Coachee;
}): string {
  const parts: string[] = [];

  const self = describeSelf(coachee.sex, coachee.ageGroup);
  if (self) {
    parts.push("# Who you are writing for", "", self, "");
  }

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
    if (rep.other) {
      line.push(
        `With: ${rep.other}${
          rep.otherAge && rep.otherAge !== "same"
            ? ` (${rep.otherAge} than them)`
            : ""
        }`,
      );
    }
    line.push(rep.reflection ? `Note: ${rep.reflection}` : "Note: none written.");
    parts.push(line.join("\n"), "");
  }

  parts.push(
    "Now write the read. Two to four patterns, what is working, one change, and one thing to do in the next conversation.",
  );

  return parts.join("\n");
}
