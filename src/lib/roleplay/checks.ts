/**
 * Deterministic checks on a single rehearsed line.
 *
 * The whole reason this can exist is that a one-line drill has an authored
 * partner beat. In an open scene you cannot know what the partner will say, so
 * you cannot know in advance which words the learner ought to pick up. In a
 * drill you wrote both halves, so the target vocabulary is known before anyone
 * types — and "did they use one of their words" stops being a judgement call
 * and becomes a lookup.
 *
 * What these can and cannot do is worth being exact about, because the
 * temptation is to oversell them. They catch failure reliably and they certify
 * success only loosely. A beginner's mistakes are gross and mechanical — they
 * ask a question when the lesson said not to, they write a paragraph, they
 * ignore the word they were handed — and those are exactly what a rule can
 * see. Whether a line is *good* is not, which is why a drill ends by showing
 * the worked examples rather than by awarding a mark out of five.
 *
 * Pure, and deliberately free of any import that would tie it to a request, so
 * every check can be asserted against every authored lesson in the test suite.
 */

export type LineCheck =
  /** No question mark. Several lessons are literally about this. */
  | { kind: "no_question"; requirement: string }
  | { kind: "max_words"; requirement: string; n: number }
  | { kind: "min_words"; requirement: string; n: number }
  /** Stopping is the move in several lessons, and stopping is countable. */
  | { kind: "max_sentences"; requirement: string; n: number }
  /** Contains one of a kind of word — a hedge, a reason marker, a name. */
  | { kind: "contains_any"; requirement: string; words: string[] }
  /**
   * Picked up one of the words the partner actually said.
   *
   * Behaves identically to `contains_any`, and is a separate kind because the
   * two are checkable claims about different things. Every word listed here
   * has to appear in the beat, and the test suite asserts exactly that — a
   * drill cannot ask a learner to echo something nobody said.
   */
  | { kind: "echoes_any"; requirement: string; words: string[] }
  /** Avoided a listed trap — interrogatives, biography openers, and so on. */
  | { kind: "forbids_any"; requirement: string; words: string[] }
  /** Put something of their own in. */
  | { kind: "first_person"; requirement: string }
  /** Kept out of the way — no hijacking the conversation back. */
  | { kind: "no_first_person"; requirement: string }
  /** Offered two feelings rather than demanding one be produced from nothing. */
  | { kind: "offers_a_choice"; requirement: string };

export type CheckResult = {
  /** Authored, and shown before the learner types as well as after. */
  requirement: string;
  ok: boolean;
  /** Why it missed. Null when it passed — nobody needs telling why they were right. */
  why: string | null;
};

export type LineVerdict = {
  /** Every check passed. An empty check list always lands. */
  landed: boolean;
  results: CheckResult[];
  /** Just the requirements that missed, for the stored record. */
  missed: string[];
};

const FIRST_PERSON = new Set([
  "i", "im", "id", "ill", "ive", "me", "my", "mine", "myself",
]);

/**
 * Lowercase, straighten the quotes, drop the punctuation.
 *
 * Apostrophes go rather than being kept, so "I've" becomes "ive" and matches
 * the list above without needing every contraction spelled out twice.
 */
function normalise(text: string): string {
  return text
    .toLowerCase()
    .replace(/[‘’]/g, "'")
    .replace(/[“”]/g, '"')
    .replace(/['']/g, "")
    .replace(/[^a-z0-9 ]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function words(text: string): string[] {
  const cleaned = normalise(text);
  return cleaned ? cleaned.split(" ") : [];
}

/**
 * Whether a target word appears.
 *
 * Prefix matching above four characters, so "brutal" is found in "brutally"
 * and "quarter" in "quarters" without dragging in a stemmer. Below that the
 * prefix rule does more harm than good — "or" would match "ordinary" — so
 * short targets have to match a whole token.
 *
 * A target containing a space is matched against the whole normalised string,
 * which is what makes phrases like "sounds like" authorable.
 */
function mentions(haystack: string[], normalisedLine: string, target: string): boolean {
  const wanted = normalise(target);
  if (!wanted) return false;

  if (wanted.includes(" ")) return normalisedLine.includes(wanted);

  return haystack.some(
    (token) => token === wanted || (wanted.length >= 4 && token.startsWith(wanted)),
  );
}

/**
 * Sentences, counted the way a person would.
 *
 * Runs of terminal punctuation count once, so "Really?!" is one sentence, and
 * a trailing fragment with no full stop still counts — somebody who types one
 * line and no punctuation has said one sentence, not none.
 */
function countSentences(line: string): number {
  const trimmed = line.trim();
  if (!trimmed) return 0;

  const terminators = trimmed.match(/[.!?]+/g)?.length ?? 0;
  const endsClosed = /[.!?]+$/.test(trimmed);

  return endsClosed ? terminators : terminators + 1;
}

function evaluate(check: LineCheck, line: string): { ok: boolean; why: string | null } {
  const tokens = words(line);
  const flat = normalise(line);

  switch (check.kind) {
    case "no_question":
      return line.includes("?")
        ? { ok: false, why: "There is a question mark in it." }
        : { ok: true, why: null };

    case "max_words":
      return tokens.length <= check.n
        ? { ok: true, why: null }
        : { ok: false, why: `That is ${tokens.length} words.` };

    case "min_words":
      return tokens.length >= check.n
        ? { ok: true, why: null }
        : { ok: false, why: `That is only ${tokens.length} words.` };

    case "max_sentences": {
      const sentences = countSentences(line);
      return sentences <= check.n
        ? { ok: true, why: null }
        : { ok: false, why: `That is ${sentences} sentences.` };
    }

    case "contains_any":
      // No reason given, deliberately. The requirement already says what was
      // wanted — "Name something you are both already in" — and restating it
      // as a failure adds a sentence that means nothing new.
      return { ok: check.words.some((w) => mentions(tokens, flat, w)), why: null };

    case "echoes_any":
      return check.words.some((w) => mentions(tokens, flat, w))
        ? { ok: true, why: null }
        : { ok: false, why: "None of their own words are in it." };

    case "forbids_any": {
      const found = check.words.find((w) => mentions(tokens, flat, w));
      return found
        ? { ok: false, why: `"${found}" is the kind of word this one avoids.` }
        : { ok: true, why: null };
    }

    case "first_person":
      return tokens.some((t) => FIRST_PERSON.has(t))
        ? { ok: true, why: null }
        : { ok: false, why: "There is nothing of your own in it." };

    case "no_first_person": {
      const found = tokens.find((t) => FIRST_PERSON.has(t));
      return found
        ? { ok: false, why: "It turns back towards you." }
        : { ok: true, why: null };
    }

    case "offers_a_choice":
      return tokens.includes("or")
        ? { ok: true, why: null }
        : { ok: false, why: "It does not offer them anything to choose between." };
  }
}

export function checkLine(line: string, checks: LineCheck[]): LineVerdict {
  const results = checks.map((check) => ({
    requirement: check.requirement,
    ...evaluate(check, line),
  }));

  return {
    landed: results.every((r) => r.ok),
    results,
    missed: results.filter((r) => !r.ok).map((r) => r.requirement),
  };
}

/**
 * What the learner is told before they type.
 *
 * The same authored sentences the result is reported against, which is the
 * point: a drill that marks you on a rule it never stated is a test, and this
 * is meant to be practice. Someone who does not know how to begin gets the
 * shape of the answer without being given the answer.
 */
export function requirements(checks: LineCheck[]): string[] {
  return checks.map((check) => check.requirement);
}
