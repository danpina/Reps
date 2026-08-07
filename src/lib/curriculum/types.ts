import type { LessonVariant } from "./variants";

export type Topic = {
  id: string;
  slug: string;
  name: string;
  description: string;
  /** What you can do once you have worked through it. */
  promise: string;
  sort_order: number;
};

export type Skill = {
  id: string;
  slug: string;
  name: string;
  description: string;
  core_idea: string;
  topic_id: string;
  /** Position within its topic, not within the app. */
  sort_order: number;
};

export type WorkedExample = {
  situation: string;
  line: string;
  why: string;
};

export type CheckOption = {
  text: string;
  correct: boolean;
  note: string;
};

export type ComprehensionCheck = {
  prompt: string;
  options: CheckOption[];
  explain: string;
};

export type RubricCriterion = {
  key: string;
  label: string;
  description: string;
};

export type Rubric = {
  scale: { min: number; max: number };
  criteria: RubricCriterion[];
};

export type Scenario = {
  setting: string;
  opening_beat: string;
  success_looks_like: string;
  constraints: string[];
  partner: {
    name: string;
    role: string;
    personality: string;
    mood: string;
    /** 1 (closed, makes the user work) to 5 (warm and forthcoming). */
    openness: number;
  };
};

export type Lesson = {
  id: string;
  skill_id: string;
  sort_order: number;
  title: string;
  theory_md: string;
  examples_json: WorkedExample[];
  /** Superseded by checks_json. Kept because the seed migrations still write it. */
  check_json: ComprehensionCheck | null;
  checks_json: ComprehensionCheck[];
  rubric_json: Rubric;
  scenario_json: Scenario;
  mission_text: string;
  /**
   * Optional per-audience versions. Empty for almost every lesson: an opener
   * at a bus stop is an opener. Populated where the advice genuinely differs
   * by who is reading, which in practice means Dating.
   */
  variants_json: LessonVariant[];
};

/**
 * A row of the table of contents.
 *
 * Read from the `lesson_index` view rather than from `lessons`, because a
 * gated lesson has to appear in a list in order to be shown as locked, and the
 * policy on `lessons` correctly makes it invisible.
 */
export type LessonSummary = Pick<Lesson, "id" | "sort_order" | "title"> & {
  skill_id: string;
  /** Inside the free sample, so readable without a subscription. */
  is_preview: boolean;
};
