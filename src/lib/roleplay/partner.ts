import type { Rubric, Scenario } from "@/lib/curriculum/types";
import type { Feedback, Rewrite } from "./feedback";

export type Turn = { role: "user" | "partner"; content: string; at: string };

/**
 * The seam between the rehearsal logic and whatever produces the words.
 *
 * Everything in the app is written against this, so adding the real model is a
 * change of transport rather than a rewrite. The scripted implementation below
 * costs nothing, which means the whole experience can be built, reviewed and
 * tested before a single paid call is made.
 */
export interface PartnerEngine {
  readonly name: string;
  nextTurn(scenario: Scenario, history: Turn[]): Promise<string>;
  feedback(
    scenario: Scenario,
    rubric: Rubric,
    history: Turn[],
  ): Promise<{ ok: true; feedback: Feedback } | { ok: false; reason: string }>;
}

const ends = (text: string) => text.trim().replace(/\s+/g, " ");

/**
 * Deterministic choice that avoids repeating something already said.
 *
 * Without the exclusion the same line comes up twice in a short scene, which
 * is the one thing that makes a stand-in impossible to read past — a real
 * person never says the identical sentence twice in three turns. Falls back to
 * the plain seeded pick once every option has been used.
 */
function pick(options: string[], seed: number, alreadySaid: string[] = []): string {
  const fresh = options.filter((o) => !alreadySaid.includes(o));
  const pool = fresh.length > 0 ? fresh : options;
  return pool[Math.abs(seed) % pool.length];
}

function countWords(text: string): number {
  return ends(text).split(" ").filter(Boolean).length;
}

function asksAQuestion(text: string): boolean {
  return text.includes("?");
}

/**
 * Rewrites a line, but only when it can do so without mangling it.
 *
 * An earlier version truncated any long line to its first eight words, which
 * produced fragments like "i know, looking forward to get to the." Chopping
 * arbitrary English at a word count cannot work, and a suggestion that is not
 * a sentence is worse than no suggestion at all — it makes the whole review
 * look careless.
 *
 * So this only performs transformations that are safe by construction, and
 * returns null when none apply. Rewriting a line properly means understanding
 * it, which is what the real engine is for.
 */
function rewriteOf(line: string): Rewrite | null {
  const original = ends(line);

  // A question becomes a statement. Always grammatical, and it is the single
  // most common fix in this curriculum.
  if (asksAQuestion(original)) {
    const statement = original.replace(/\s*\?/g, ".").replace(/\.+$/, ".");
    if (statement !== original && countWords(statement) >= 3) {
      return {
        original: line,
        better: statement,
        why: "The same thing as a statement, which invites a reply rather than demanding one.",
      };
    }
  }

  // More than one sentence: keep the first. A whole sentence is always
  // grammatical, unlike a slice of one.
  const sentences = original.split(/(?<=[.!?])\s+/).filter(Boolean);
  if (sentences.length > 1 && countWords(sentences[0]) >= 4) {
    return {
      original: line,
      better: sentences[0],
      why: "The first sentence was the good one. The rest explained something they had not asked about.",
    };
  }

  return null;
}

/**
 * A stand-in that honours openness.
 *
 * It is not trying to be convincing prose. It is trying to be behaviourally
 * correct: terse and unrewarding at low openness, generous at high openness,
 * and never coaching. That is enough to exercise the UI, the transcript, the
 * rate limit and the feedback path.
 */
export class ScriptedPartner implements PartnerEngine {
  readonly name = "scripted";

  async nextTurn(scenario: Scenario, history: Turn[]): Promise<string> {
    const { openness, name } = scenario.partner;
    const userTurns = history.filter((t) => t.role === "user");
    const last = userTurns.at(-1)?.content ?? "";
    const seed = userTurns.length * 7 + last.length;

    // Everything this character has already said, so it does not repeat itself.
    const said = history.filter((t) => t.role === "partner").map((t) => t.content);

    if (userTurns.length === 0) return scenario.opening_beat;

    if (openness <= 1) {
      // Never warms up, never asks anything back. Persistence earns nothing.
      return pick(
        ["Yeah.", "Suppose so.", "Mm.", "Not really.", "Right."],
        seed,
        said,
      );
    }

    if (openness === 2) {
      const stillPushing = userTurns.length > 3 && asksAQuestion(last);
      if (stillPushing) {
        return pick(
          ["Bit busy actually.", "Yeah, maybe.", "Sorry, miles away."],
          seed,
          said,
        );
      }
      return pick(
        ["It's fine, thanks.", "Not too bad.", "Yeah, same as ever."],
        seed,
        said,
      );
    }

    if (openness === 3) {
      const earned = countWords(last) > 8 && !asksAQuestion(last);
      return earned
        ? pick(
            [
              `Yeah, actually — that's more or less it. Took me a while to admit that.`,
              `That's a fair way of putting it. Most people assume the opposite.`,
              `Honestly, yes. I don't say that out loud very often.`,
              `Suppose so. Nobody's put it quite like that before.`,
            ],
            seed,
            said,
          )
        : pick(
            [
              "Yeah, it's alright.",
              "Something like that.",
              "Bit of both, really.",
              "Can't complain.",
            ],
            seed,
            said,
          );
    }

    // 4 and 5: forthcoming, and always leaves something to pick up on.
    return pick(
      [
        `Honestly? It was a relief. I'd been putting it off for about a year, which is the embarrassing part.`,
        `Yeah — and the odd thing is I didn't expect to miss it. ${name} the optimist, apparently.`,
        `It was chaos, but the good kind. I'd do it again tomorrow.`,
        `That's exactly it. Nobody ever asks that bit, they just ask what I do.`,
        `I keep telling people it was planned. It absolutely was not.`,
      ],
      seed,
      said,
    );
  }

  async feedback(scenario: Scenario, rubric: Rubric, history: Turn[]) {
    const userTurns = history.filter((t) => t.role === "user");
    if (userTurns.length === 0) {
      return { ok: false as const, reason: "You did not say anything yet." };
    }

    const longest = userTurns.reduce((a, b) =>
      countWords(b.content) > countWords(a.content) ? b : a,
    );

    // Scores respond to something real, so the UI shows a range rather than a
    // flat row of identical numbers.
    const askedCount = userTurns.filter((t) => asksAQuestion(t.content)).length;
    const questionRatio = askedCount / userTurns.length;

    const rewrite = rewriteOf(longest.content);

    const scores: Record<string, number> = {};
    rubric.criteria.forEach((criterion, i) => {
      const base = questionRatio > 0.8 ? 2 : questionRatio < 0.3 ? 4 : 3;
      scores[criterion.key] = Math.min(
        rubric.scale.max,
        Math.max(rubric.scale.min, base + ((i % 3) - 1)),
      );
    });

    return {
      ok: true as const,
      feedback: {
        scores,
        worked: [
          `You stayed in it for ${userTurns.length} turns rather than bailing after the first flat answer.`,
          `You opened on something you were both in, which is the cheapest thing that works.`,
        ] as [string, string],
        fix:
          questionRatio > 0.8
            ? "You asked a question nearly every turn. Put something of your own in before the third one."
            : "Leave a beat after your best line instead of filling the silence yourself.",
        // Omitted rather than mangled when no safe transformation applies.
        ...(rewrite ? { rewrite } : {}),
      },
    };
  }
}
