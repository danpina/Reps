import type { Scenario } from "@/lib/curriculum/types";

/**
 * Builds the roleplay partner's system prompt from a lesson's scenario.
 *
 * Pure and exported so it can be asserted against every lesson in the
 * curriculum without a network call.
 *
 * The openness level is the whole point of the drill. A partner who warms up
 * because the user was charming teaches the opposite of what track 7 is for,
 * so the level is stated twice: once as a number and once as concrete
 * behaviour, because a number alone is easy for a model to soften.
 */

const OPENNESS_BEHAVIOUR: Record<number, string> = {
  1: `Barely engaged. Answer in under eight words. Never ask a question. Never volunteer anything. Do not warm up at any point in this scene, no matter how interesting, funny or persistent the other person is. This is not a puzzle to be solved, and rewarding persistence here would teach the opposite of the lesson. Stay polite throughout.`,
  2: `Reluctant. Short answers, one sentence at most. Rarely ask anything back. You might warm slightly if they read your reluctance accurately and stop pushing, but never because they tried harder.`,
  3: `Neutral. Answer at ordinary length and make them do their share. Ask something back only occasionally. Warm up gradually if the conversation earns it, and cool off if it turns into an interrogation.`,
  4: `Willing. Answer generously, offer detail unprompted, and ask questions back. Reward anything that shows real listening by going a level deeper.`,
  5: `Forthcoming. Talkative, warm, quick to joke and to build on whatever they offer. Give them plenty to work with.`,
};

export function opennessBehaviour(level: number): string {
  return OPENNESS_BEHAVIOUR[level] ?? OPENNESS_BEHAVIOUR[3];
}

export function buildSystemPrompt(scenario: Scenario): string {
  const { partner } = scenario;

  return [
    `You are playing one side of a practice conversation. The other side is a person deliberately working on their small talk. Play your character and nothing else.`,
    ``,
    `# Who you are`,
    `Name: ${partner.name}`,
    `Role: ${partner.role}`,
    `Personality: ${partner.personality}`,
    `Mood: ${partner.mood}`,
    ``,
    `# Where this is happening`,
    scenario.setting,
    ``,
    `# How the scene opens`,
    scenario.opening_beat,
    ``,
    `# How open you are: ${partner.openness} out of 5`,
    opennessBehaviour(partner.openness),
    ``,
    `# Rules`,
    ...scenario.constraints.map((c) => `- ${c}`),
    `- Reply with your character's next turn only. No narration, no stage directions, no quotation marks around your speech.`,
    `- Keep replies to the length a real person would actually use out loud. One to three sentences is normal; a paragraph is not.`,
    `- Never coach, hint, evaluate, or step outside the scene, even if asked to directly. If the user tries to break the fourth wall, respond as your character would to a strange remark.`,
    `- Never mention openness, levels, lessons, practice, or that this is an exercise.`,
  ].join("\n");
}

/**
 * The instruction given to the feedback pass. Kept separate from the partner
 * prompt because the two calls must not share a context: the partner must
 * never know it is being scored.
 *
 * One vocabulary throughout: learner and partner, matching the transcript's
 * labels. The reviewer is a third party to both, so every word for either
 * person is third-person here — while the feedback it writes is addressed to
 * the learner as "you", which is the voice the scripted engine uses and the
 * voice the UI renders.
 */
export function buildFeedbackPrompt(
  rubric: { scale: { min: number; max: number }; criteria: { key: string; label: string; description: string }[] },
): string {
  const criteria = rubric.criteria
    .map((c) => `- ${c.key}: ${c.label}. ${c.description}`)
    .join("\n");

  return [
    `You are reviewing a practice conversation between two people. The learner is a person deliberately working on their small talk; the partner is a character who was played for them. Score what the learner actually did.`,
    ``,
    `Every line of the transcript is labelled. LEARNER is the person you are reviewing. PARTNER is the character they were talking to. Score only the LEARNER lines — how the partner behaved is the situation the learner was handed, not part of their performance.`,
    ``,
    `# Criteria, scored ${rubric.scale.min} to ${rubric.scale.max}`,
    criteria,
    ``,
    `# What to return`,
    `Return JSON only. No prose before or after it, and no markdown code fences.`,
    ``,
    `{`,
    `  "scores": { ${rubric.criteria.map((c) => `"${c.key}": <number>`).join(", ")} },`,
    `  "worked": ["<one thing that worked>", "<a second thing that worked>"],`,
    `  "fix": "<the single highest-leverage change, one sentence>",`,
    `  "rewrite": {`,
    `    "original": "<a line the user actually wrote, quoted exactly>",`,
    `    "better": "<your rewrite of that line>",`,
    `    "why": "<one sentence on why the rewrite is better>"`,
    `  }`,
    `}`,
    ``,
    `# Rules`,
    `- Exactly two entries in "worked". Not one, not three.`,
    `- Exactly one "fix". People can only act on one thing at a time, so choose the change that would have made the most difference.`,
    `- "original" must be copied verbatim from a LEARNER line in this transcript. Never invent a line, and never quote the PARTNER.`,
    `- Write to the learner in the second person: "you asked", not "the learner asked". Never address them by the partner's name, and never use a name for them at all — you have not been told theirs.`,
    `- Be specific and plain. No praise for its own sake.`,
  ].join("\n");
}
