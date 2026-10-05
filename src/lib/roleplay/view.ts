import "server-only";

import { getProfile } from "@/lib/auth/dal";
import { extractTheMove } from "@/lib/curriculum/the-move";
import { getLesson } from "@/lib/curriculum/queries";
import { shuffle } from "@/lib/curriculum/shuffle";
import { pickVariant, scenarioFor, type LessonVariant } from "@/lib/curriculum/variants";
import { createClient } from "@/lib/supabase/server";
import { checkLine } from "@/lib/roleplay/checks";
import { isUsingRealModel } from "@/lib/roleplay/engine";
import type { Feedback } from "@/lib/roleplay/feedback";
import { MAX_LINE_CHARS, turnCap, turnsLeftInScene } from "@/lib/roleplay/limits";
import {
  MAX_DRILL_ATTEMPTS,
  asBeatSpec,
  asChoiceSpec,
  asLineSpec,
  costsMoney,
  isDrillResult,
  isRehearsalMode,
  type DrillResult,
  type RehearsalMode,
} from "@/lib/roleplay/modes";
import type { Turn } from "@/lib/roleplay/partner";

/**
 * A rehearsal as the iOS app renders it.
 *
 * The same decisions the website's rehearsal page makes, in the same places, as
 * data rather than JSX — which verdict an attempt gets, which beat is current,
 * how many lines are left, how a finished scene was scored. Nothing here is a
 * second opinion on any of it: the page's helpers are called, not copied, so a
 * rule changed once changes for both.
 */
export type RehearsalView = {
  id: string;
  mode: RehearsalMode;
  status: "open" | "complete";
  lessonId: string;
  skillSlug: string;
  lessonOrder: number;
  lessonTitle: string;
  setting: string;
  partner: { name: string; role: string; openness: number };
  /** A read-and-decide drill is a set of situations, not a scene with somebody in it. */
  showPartner: boolean;
  /** Costs a model call. Only these have a rubric and an openness worth showing. */
  paid: boolean;
  usingRealModel: boolean;
  theMove: string;
  rehearsalNote: string | null;
  criteria: { key: string; label: string; description: string }[];
  mission: string;
  examples: { situation: string; line: string; why: string }[];
  transcript: { role: string; content: string; correct: boolean | null }[];
  /** The lesson's drill spec is missing or does not match its mode. */
  unavailable: boolean;
  line: LineView | null;
  choice: ChoiceView | null;
  chat: ChatView | null;
  result: ResultView | null;
};

export type LineView = {
  says: string | null;
  maxChars: number;
  maxAttempts: number;
  requirements: string[];
  /** Verdicts are recomputed from the stored attempts, as on the website. */
  attempts: {
    line: string;
    landed: boolean;
    results: { requirement: string; ok: boolean; why: string | null }[];
  }[];
  model: { line: string; why: string } | null;
};

export type ChoiceView = {
  total: number;
  answered: {
    situation: string;
    chosen: string;
    correct: boolean;
    options: { text: string; correct: boolean; note: string }[];
  }[];
  /** Options carry no verdict until they have been answered. */
  current: { situation: string; prompt: string; options: { index: number; text: string }[] } | null;
};

export type ChatView = {
  turnsLeft: number;
  maxChars: number;
  instruction: string | null;
};

export type ResultView =
  | { kind: "drill"; landed: boolean; attempts: number; missed: string[] }
  | {
      kind: "scene";
      scale: { min: number; max: number };
      scores: { key: string; label: string; score: number }[];
      worked: string[];
      fix: string;
      rewrite: { original: string; better: string; why: string } | null;
    }
  | { kind: "ended" };

type Raw = {
  id: string;
  status: "open" | "complete";
  mode: string;
  transcript_json: Turn[];
  feedback_json: Feedback | DrillResult | null;
  lesson_id: string;
  lessons: {
    sort_order: number;
    rehearsal_note: string | null;
    variants_json: LessonVariant[];
    skills: { slug: string; name: string };
  };
};

export async function buildRehearsalView(id: string): Promise<RehearsalView | null> {
  const supabase = await createClient();
  const { data } = await supabase
    .from("roleplays")
    .select(
      "id, status, mode, transcript_json, feedback_json, lesson_id, lessons(sort_order, rehearsal_note, variants_json, skills(slug, name))",
    )
    .eq("id", id)
    .maybeSingle();

  if (!data) return null;
  const raw = data as unknown as Raw;

  // The lesson comes through the same translated path every other curriculum
  // read uses. `lessons` is English-only, and reading it here is exactly how a
  // rehearsal ends up in English while the rest of the app is in Spanish.
  const localized = await getLesson(raw.lessons.skills.slug, raw.lessons.sort_order);
  if (!localized) return null;
  const lesson = localized.lesson;

  const profile = await getProfile();
  const audience = {
    sex: profile?.sex ?? null,
    ageGroup: profile?.age_group ?? null,
    datingInterest: profile?.dating_interest ?? null,
  };
  const scenario = scenarioFor(
    lesson.scenario_json,
    audience,
    pickVariant(raw.lessons.variants_json, audience),
  );

  // Read off the rehearsal rather than off the lesson, so re-authoring a lesson
  // cannot change what an old transcript claims to be.
  const mode: RehearsalMode = isRehearsalMode(raw.mode) ? raw.mode : "scene";
  const paid = costsMoney(mode);
  const complete = raw.status === "complete";
  const transcript = raw.transcript_json ?? [];
  const said = transcript.filter((t) => t.role === "user").length;
  const beatSpec = mode === "beat" ? asBeatSpec(lesson.rehearsal_spec) : null;

  const view: RehearsalView = {
    id: raw.id,
    mode,
    status: raw.status,
    lessonId: raw.lesson_id,
    skillSlug: raw.lessons.skills.slug,
    lessonOrder: raw.lessons.sort_order,
    lessonTitle: lesson.title,
    setting: scenario.setting,
    partner: {
      name: scenario.partner.name,
      role: scenario.partner.role,
      openness: scenario.partner.openness,
    },
    showPartner: mode !== "choice",
    paid,
    usingRealModel: isUsingRealModel(),
    theMove: extractTheMove(lesson.theory_md, lesson.title),
    rehearsalNote: raw.lessons.rehearsal_note,
    criteria: paid ? (lesson.rubric_json?.criteria ?? []) : [],
    mission: lesson.mission_text,
    examples: lesson.examples_json ?? [],
    transcript: transcript.map((t) => ({
      role: t.role,
      content: t.content,
      correct: typeof t.correct === "boolean" ? t.correct : null,
    })),
    unavailable: false,
    line: null,
    choice: null,
    chat: null,
    result: null,
  };

  if (complete) {
    view.result = resultOf(raw.feedback_json, lesson.rubric_json);
    return view;
  }

  if (mode === "line") {
    const spec = asLineSpec(lesson.rehearsal_spec);
    if (!spec) return { ...view, unavailable: true };

    view.line = {
      says: spec.says ?? null,
      maxChars: spec.maxChars ?? MAX_LINE_CHARS,
      maxAttempts: MAX_DRILL_ATTEMPTS,
      requirements: spec.checks.map((c) => c.requirement),
      attempts: transcript
        .filter((t) => t.role === "user")
        .map((t) => {
          const verdict = checkLine(t.content, spec.checks);
          return {
            line: t.content,
            landed: verdict.landed,
            results: verdict.results.map((r) => ({
              requirement: r.requirement,
              ok: r.ok,
              why: r.why ?? null,
            })),
          };
        }),
      model: spec.model ?? null,
    };
  } else if (mode === "choice") {
    const spec = asChoiceSpec(lesson.rehearsal_spec);
    if (!spec) return { ...view, unavailable: true };

    const picks = transcript.filter((t) => t.role === "user");
    const current = spec.beats[picks.length] ?? null;

    view.choice = {
      total: spec.beats.length,
      answered: picks
        .map((turn, i) => ({ turn, beat: spec.beats[i] }))
        .filter((p) => p.beat)
        .map(({ turn, beat }) => ({
          situation: beat.situation,
          chosen: turn.content,
          correct: turn.correct === true,
          options: beat.options.map((o) => ({ text: o.text, correct: o.correct, note: o.note })),
        })),
      // Shuffled so the answer cannot be found by position. Each option carries
      // the index it was authored at, so what the server checks is the answer
      // that was chosen rather than the slot that was tapped.
      current: current
        ? {
            situation: current.situation,
            prompt: current.prompt,
            options: shuffle(current.options.map((o, index) => ({ index, text: o.text }))),
          }
        : null,
    };
  } else {
    const cap = turnCap(mode, beatSpec?.turns.length);
    view.chat = {
      turnsLeft: turnsLeftInScene(said, cap),
      maxChars: MAX_LINE_CHARS,
      instruction: beatSpec?.turns[said]?.instruction ?? null,
    };
  }

  return view;
}

function resultOf(
  feedback: Feedback | DrillResult | null,
  rubric: { scale: { min: number; max: number }; criteria: { key: string; label: string }[] } | undefined,
): ResultView {
  if (isDrillResult(feedback)) {
    return { kind: "drill", landed: feedback.landed, attempts: feedback.attempts, missed: feedback.missed };
  }
  if (feedback && rubric) {
    return {
      kind: "scene",
      scale: rubric.scale,
      scores: rubric.criteria.map((c) => ({ key: c.key, label: c.label, score: feedback.scores[c.key] ?? 0 })),
      worked: feedback.worked,
      fix: feedback.fix,
      rewrite: feedback.rewrite ?? null,
    };
  }
  return { kind: "ended" };
}
