import type { LineCheck } from "./checks.ts";

/**
 * What kind of thing a rehearsal is.
 *
 * One container for every lesson was the original mistake. "Name something you
 * are both in, say it plainly, then stop" was handed a fourteen-turn chat
 * window, so the one instruction in the lesson — stop — was the one thing the
 * interface made impossible to demonstrate. Eight lessons ended up carrying a
 * `rehearsal_note` apologising that the scene could not test them, which is a
 * missing mode written out as prose.
 *
 * The four below are not four sizes of the same thing. They are four different
 * exercises:
 *
 * - `line`   One utterance is the whole move. Checked mechanically, retried
 *            freely, and finished by showing the worked examples.
 * - `beat`   A short fixed sequence where the structure is the lesson — two
 *            questions then something of your own is three turns, not "a
 *            conversation".
 * - `choice` Read the situation and decide, in the lessons where the right
 *            answer is often "do not". A free text box cannot tell good
 *            judgement from having ignored the question.
 * - `scene`  An open conversation, for the moves that only exist across an
 *            arc. You cannot rehearse a callback without something to call
 *            back into.
 *
 * `line` and `choice` never call the model. That is not only a cost decision,
 * though it is also that: it means a drill can be repeated as many times as
 * someone wants, which is what a drill is for.
 */
export const REHEARSAL_MODES = ["line", "beat", "choice", "scene"] as const;

export type RehearsalMode = (typeof REHEARSAL_MODES)[number];

export function isRehearsalMode(value: string): value is RehearsalMode {
  return (REHEARSAL_MODES as readonly string[]).includes(value);
}

/** Whether running this mode costs a model call. */
export function costsMoney(mode: RehearsalMode): boolean {
  return mode === "beat" || mode === "scene";
}

/**
 * One line, against a beat you wrote.
 *
 * `says` is the partner's literal words, present whenever they speak first.
 * Where it is absent the learner opens cold, and the scenario's own opening
 * beat is the whole setup — which is correct for the two Openers lessons that
 * are about walking up to somebody.
 */
export type LineSpec = {
  says?: string;
  /**
   * How much room the box gives, where the default is wrong for the lesson.
   *
   * The default exists because a box that invites a paragraph teaches the
   * wrong thing before a word is scored — in Small talk the skill is saying
   * less. In Interviews it is sometimes the opposite: "tell me about
   * yourself" is a ninety-second answer, and a drill that cannot hold one
   * cannot drill it. The cap on what a drill may ask for is a property of the
   * lesson, not of the app.
   */
  maxChars?: number;
  /**
   * May be empty. Two lessons — saying something exposing, and mislabelling
   * something at the wrong scale — are creative acts that no rule can mark.
   * They still belong in this mode, taught by example rather than by check.
   */
  checks: LineCheck[];
  /**
   * One line that answers this beat, with the reason it works.
   *
   * The lesson's own worked examples each carry their own situation, so they
   * illustrate the move in general rather than answering the beat in front of
   * you. Both are worth showing and they are not the same thing: this is the
   * one that says "here is what you could have written, to them, just now".
   *
   * It is also the test. Every model answer is asserted to pass its own
   * lesson's checks, which is what stops a rule being authored that nothing
   * could satisfy.
   */
  model?: { line: string; why: string };
};

/** A fixed sequence. The instruction for each turn is shown as it comes up. */
export type BeatSpec = {
  turns: { instruction: string }[];
};

export type ChoiceOption = { text: string; correct: boolean; note: string };

export type ChoiceBeat = {
  situation: string;
  prompt: string;
  options: ChoiceOption[];
};

export type ChoiceSpec = { beats: ChoiceBeat[] };

export type RehearsalSpec = LineSpec | BeatSpec | ChoiceSpec | null;

/**
 * Readers for the spec column, which is one jsonb holding four shapes.
 *
 * Each returns null rather than throwing on a spec that does not match its
 * mode. A lesson authored wrongly should degrade to something the page can
 * explain, not take the rehearsal down — the transcript of a scene somebody
 * already had is behind that page.
 */
export function asLineSpec(spec: unknown): LineSpec | null {
  if (!isObject(spec) || !Array.isArray(spec.checks)) return null;
  return {
    says: typeof spec.says === "string" ? spec.says : undefined,
    maxChars:
      typeof spec.maxChars === "number" && spec.maxChars > 0
        ? spec.maxChars
        : undefined,
    checks: spec.checks as LineCheck[],
    model: isObject(spec.model)
      ? (spec.model as { line: string; why: string })
      : undefined,
  };
}

export function asBeatSpec(spec: unknown): BeatSpec | null {
  if (!isObject(spec) || !Array.isArray(spec.turns) || spec.turns.length === 0) {
    return null;
  }
  return { turns: spec.turns as { instruction: string }[] };
}

export function asChoiceSpec(spec: unknown): ChoiceSpec | null {
  if (!isObject(spec) || !Array.isArray(spec.beats) || spec.beats.length === 0) {
    return null;
  }
  return { beats: spec.beats as ChoiceBeat[] };
}

function isObject(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

/**
 * How a drill turned out.
 *
 * Stored in the same `feedback_json` column the AI review uses, discriminated
 * by `kind`, because it answers the same question — how did that go — and a
 * second column would mean every reader of a rehearsal had to check two places
 * to find out whether one had been completed.
 */
export type DrillResult = {
  kind: "drill";
  /** Every requirement met on the attempt they settled on. */
  landed: boolean;
  attempts: number;
  missed: string[];
};

export function isDrillResult(value: unknown): value is DrillResult {
  return isObject(value) && value.kind === "drill";
}

/**
 * How many attempts a drill records before it stops offering another.
 *
 * Generous, because attempts are free and repetition is the entire mechanism.
 * It exists so the record of a drill stays a record rather than a log of
 * forty tries.
 */
export const MAX_DRILL_ATTEMPTS = 8;
