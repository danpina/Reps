// Drives the real model through the two things the test suite cannot check:
// whether a closed partner stays closed under charm, and whether the review
// comes back in a shape the parser accepts.
//
//   node --env-file=.env.local scripts/probe-partner.mjs
//
// Costs a handful of real calls. Run it after changing a prompt, not on every
// commit — this is a judgement check, not a unit test, and the thing it is
// checking is exactly the thing that cannot be asserted for free.

import Anthropic from "@anthropic-ai/sdk";

const MODEL = process.env.ANTHROPIC_MODEL?.trim() || "claude-opus-5";

if (!process.env.ANTHROPIC_API_KEY?.trim()) {
  console.error("No ANTHROPIC_API_KEY. Add it to .env.local first.");
  process.exit(1);
}

const client = new Anthropic({ timeout: 90_000 });

// A deliberately hard case: someone likeable, funny and persistent, working on
// a person who is not in the mood. If the partner warms up here, the drill is
// teaching that persistence is rewarded, which is the opposite of the lesson.
const SCENARIO = {
  setting: "A hotel lift, mid-morning, on the second day of a conference.",
  opening_beat: "They glance up from their phone as you get in, then look back down.",
  success_looks_like: "You read the room and let it go, rather than working harder.",
  constraints: ["Stay in the lift; the scene is over in under a minute."],
  partner: {
    name: "Dana",
    role: "another delegate",
    personality: "Private, dry, not unkind",
    mood: "Tired and unavailable",
    openness: 1,
  },
};

const ESCALATION = [
  "Morning! Big turnout today, isn't it?",
  "First time at this one? I've been coming for years.",
  "I have to say, that's a great jacket.",
  "Sorry — I promise I'm not usually this chatty in lifts.",
  "You look like you'd rather be anywhere else. Honestly, same.",
  "Okay, one question and then I'll leave you alone: coffee here, any good?",
  "You're a tough crowd. I like that in a stranger.",
  "Last one, I swear. What brought you along this year?",
];

const { buildSystemPrompt, buildFeedbackPrompt } = await import(
  "../src/lib/roleplay/prompt.ts"
);
const { toMessages, renderTranscript, feedbackSchema } = await import(
  "../src/lib/roleplay/transcript.ts"
);
const { parseFeedback } = await import("../src/lib/roleplay/feedback.ts");

const text = (message) =>
  message.content
    .filter((block) => block.type === "text")
    .map((block) => block.text)
    .join("")
    .trim();

const transcript = [];
let usage = { input: 0, output: 0, cached: 0 };

const track = (message) => {
  usage.input += message.usage.input_tokens;
  usage.output += message.usage.output_tokens;
  usage.cached += message.usage.cache_read_input_tokens ?? 0;
};

console.log(`Model: ${MODEL}\nOpenness: 1 — the partner must not budge.\n`);

for (const line of ESCALATION) {
  transcript.push({ role: "user", content: line, at: new Date().toISOString() });

  const started = Date.now();
  const message = await client.messages.create({
    model: MODEL,
    max_tokens: 1500,
    system: [
      {
        type: "text",
        text: buildSystemPrompt(SCENARIO),
        cache_control: { type: "ephemeral" },
      },
    ],
    output_config: { effort: "low" },
    messages: toMessages(transcript),
  });
  track(message);

  if (message.stop_reason === "refusal") {
    console.log("  REFUSED —", message.stop_details?.category);
    break;
  }

  const reply = text(message);
  transcript.push({ role: "partner", content: reply, at: new Date().toISOString() });

  const words = reply.split(/\s+/).filter(Boolean).length;
  // The two tells that the character has broken: length, and asking anything
  // back. An openness-1 partner does neither, however charming the other
  // person is being.
  const flags = [
    words > 8 ? `LONG (${words}w)` : null,
    reply.includes("?") ? "ASKED BACK" : null,
  ].filter(Boolean);

  console.log(
    `  you   ${line}\n  them  ${reply}` +
      `\n        ${Date.now() - started}ms${flags.length ? `  ⚠ ${flags.join(", ")}` : ""}\n`,
  );
}

console.log("Reviewing the scene…\n");

const RUBRIC = {
  scale: { min: 1, max: 5 },
  criteria: [
    { key: "reading_the_room", label: "Reading the room", description: "Did they notice the other person was unavailable." },
    { key: "restraint", label: "Restraint", description: "Did they stop pushing, or work harder." },
    { key: "warmth", label: "Warmth", description: "Were they pleasant without being needy." },
  ],
};

const review = await client.messages.create({
  model: MODEL,
  max_tokens: 8000,
  system: buildFeedbackPrompt(RUBRIC),
  output_config: {
    effort: "high",
    format: { type: "json_schema", schema: feedbackSchema(RUBRIC) },
  },
  messages: [
    {
      role: "user",
      content: [
        `# The scene`,
        `${SCENARIO.setting} The partner is ${SCENARIO.partner.name}, ${SCENARIO.partner.role}.`,
        ``,
        `# What good looks like here`,
        SCENARIO.success_looks_like,
        ``,
        `# The transcript`,
        renderTranscript(transcript),
      ].join("\n"),
    },
  ],
});
track(review);

const parsed = parseFeedback(
  text(review),
  RUBRIC,
  transcript.filter((t) => t.role === "user").map((t) => t.content),
);

if (!parsed.ok) {
  console.log(`  PARSER REJECTED IT: ${parsed.reason}`);
  console.log(`  Raw response:\n${text(review)}`);
} else {
  console.log(`  scores  ${JSON.stringify(parsed.feedback.scores)}`);
  for (const item of parsed.feedback.worked) console.log(`  worked  ${item}`);
  console.log(`  fix     ${parsed.feedback.fix}`);
  console.log(`  rewrite "${parsed.feedback.rewrite?.original}"`);
  console.log(`       →  "${parsed.feedback.rewrite?.better}"`);
  if (parsed.warnings.length) console.log(`  warnings ${parsed.warnings.join("; ")}`);
}

console.log(
  `\nTokens: ${usage.input} in (${usage.cached} from cache), ${usage.output} out.`,
);
