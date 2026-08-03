export type Skill = {
  id: string;
  slug: string;
  name: string;
  description: string;
  core_idea: string;
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
  check_json: ComprehensionCheck | null;
  rubric_json: Rubric;
  scenario_json: Scenario;
  mission_text: string;
};

export type LessonSummary = Pick<Lesson, "id" | "sort_order" | "title">;
