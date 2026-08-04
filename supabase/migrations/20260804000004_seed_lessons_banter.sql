-- Track 5: Banter & humour. Tease the situation before you tease the person.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, check_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'banter'),
  1,
  'Tease the situation first',
  $md$Banter is a claim about closeness. Teasing someone says *we are the kind of people who can do this*, and if that is not yet true, the joke lands as a small trespass.

The safe version is to aim at the situation you are both in rather than at the person. The queue, the venue, the weather, the compulsory team-building exercise. Nobody has to defend the situation, so nobody can be wounded by the joke, and you both get the pleasure of being on the same side of something.

**The move:** joke about the thing you are both stuck in before you joke about them.

Once someone has laughed with you about a shared circumstance, you have established that jokes between you are safe. That is the licence. Teasing the person comes after it, never instead of it.

The people who get this wrong are not unkind. They are just early.$md$,
  $j$[
    {
      "situation": "You are both at an all-day training session with an aggressive agenda.",
      "line": "There is a slot on here called Energisers. At four fifty.",
      "why": "Aimed at the agenda, not at anyone in the room. It invites agreement and costs nothing to laugh at."
    },
    {
      "situation": "The venue for a party is far too small for the number of people invited.",
      "line": "I think we have accidentally invented a new form of dancing where nobody moves.",
      "why": "The joke is about the room. Everyone present is a fellow victim, which is the fastest way to feel like allies with a stranger."
    },
    {
      "situation": "You are both waiting for a notoriously unreliable bus.",
      "line": "I have started thinking of the timetable as more of a mood board.",
      "why": "Mild, specific, and about a thing rather than a person. Small jokes about shared inconvenience are the safest opening humour there is."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You have been talking to someone for two minutes at a work event. Which joke is safest and most likely to land?",
    "options": [
      {
        "text": "A joke about how bad the venue's wine is.",
        "correct": true,
        "note": "Aimed at the situation you are both in. Nobody has to defend the wine, and agreeing with you costs them nothing."
      },
      {
        "text": "A gentle joke about their job title.",
        "correct": false,
        "note": "Teasing the person at two minutes claims a closeness you have not built. It usually gets a polite laugh and a small step back."
      },
      {
        "text": "A joke about something they just said.",
        "correct": false,
        "note": "This is good banter later. At two minutes it can read as being watched rather than being enjoyed."
      },
      {
        "text": "A joke about your own appearance.",
        "correct": false,
        "note": "Safe for them but it puts you slightly below the conversation. Self-deprecation works in small doses, not as an opener."
      }
    ],
    "explain": "Aim at the circumstance you are both in. It is the only target where nobody can be the loser."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "aimed_at_situation", "label": "Aimed at the situation", "description": "Joked about a shared circumstance rather than about the person." },
      { "key": "read_the_licence", "label": "Judged the closeness available", "description": "Did not tease the person before any rapport had been built." },
      { "key": "invited_agreement", "label": "Put you on the same side", "description": "The joke made agreement easy rather than requiring a defence." },
      { "key": "kept_it_small", "label": "Kept it proportionate", "description": "Made a small observation rather than performing." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A compulsory two-day work conference, the coffee break after a session that ran long. A poster board of motivational slogans is on the wall behind you.",
    "partner": {
      "name": "Danno",
      "role": "someone from another company at the same conference",
      "personality": "Dry and quick to join in with a shared joke, but visibly cools if teased personally by a stranger.",
      "mood": "Slightly weary, ready to be amused.",
      "openness": 3
    },
    "opening_beat": "Danno reads one of the slogans out loud in a deliberately flat voice and raises an eyebrow at you.",
    "success_looks_like": "The user joins in on the situation rather than turning the joke on Danno, and the two of them establish a shared register.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Respond warmly and build on any joke aimed at the conference, the venue or the slogans.",
      "If the user teases you personally this early, laugh politely but briefly and change the subject.",
      "Never explain why one landed better than the other."
    ]
  }$j$::jsonb,
  $md$Today, make one joke about a situation you and someone else are both stuck in. Not about them. Log what you said and whether it landed.$md$
),
(
  (select id from public.skills where slug = 'banter'),
  2,
  'Playful mislabeling',
  $md$The most reliable piece of banter is deliberately calling something the opposite of what it is, or one size too big.

Someone mentions they organise a five-a-side game and you call it their empire. Someone admits they alphabetise their spices and you tell them you had no idea you were in the presence of a dangerous radical. The joke is the gap between the size of the thing and the size of the word.

**The move:** take the thing they just told you and describe it at the wrong scale.

It works because it is obviously affectionate. You cannot mistake it for a real accusation, since nobody genuinely thinks a five-a-side game is an empire, so it reads as attention rather than criticism. And it hands them an easy next line: they can play along and escalate, which is where the fun is.

Scale up for something small, scale down for something they are proud of — but only scale down once you know each other.$md$,
  $j$[
    {
      "situation": "They mention they keep a spreadsheet of everything they have read this year.",
      "line": "So what you are describing is a surveillance operation on yourself.",
      "why": "Takes a mild habit and names it at absurd scale. Affectionate, obviously untrue, and easy to play along with."
    },
    {
      "situation": "They say they made the cake themselves but it is nothing special.",
      "line": "I will be the judge of that. I have a very sophisticated palate and no manners.",
      "why": "Mislabels yourself rather than them, which is a safe way to do this early, and sets up a running bit."
    },
    {
      "situation": "They mention they once won a pub quiz.",
      "line": "I did not realise I was drinking with a professional.",
      "why": "One size too big, delivered flat. Short mislabels land better than elaborate ones because they leave room for the reply."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Someone tells you they are quite particular about how their coffee is made. What is the best playful mislabel?",
    "options": [
      {
        "text": "So you are a coffee snob.",
        "correct": false,
        "note": "Snob is a real accusation at ordinary scale, so it can be taken straight. Mislabeling works when the word is obviously too big."
      },
      {
        "text": "Ah, so you are impossible to have round for breakfast.",
        "correct": false,
        "note": "Funny, but it labels them as a burden rather than exaggerating their expertise. Aim the exaggeration upwards."
      },
      {
        "text": "Right, so I am talking to a scientist.",
        "correct": true,
        "note": "Absurdly too big, obviously affectionate, impossible to take as criticism, and it hands them an easy line back."
      },
      {
        "text": "Everyone says that about themselves.",
        "correct": false,
        "note": "Not a mislabel at all. It dismisses what they said, which is the opposite of the effect you want."
      }
    ],
    "explain": "The joke is the gap between the thing and the word. If the word could be meant literally, it is not a mislabel, it is a judgement."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "wrong_scale", "label": "Used the wrong scale", "description": "Described something at a size obviously different from reality." },
      { "key": "obviously_affectionate", "label": "Could not be taken straight", "description": "The exaggeration was large enough that it could not be mistaken for a real judgement." },
      { "key": "used_their_material", "label": "Built on what they said", "description": "Mislabelled something the partner had just offered rather than importing a joke." },
      { "key": "left_a_reply", "label": "Left them a line", "description": "Kept it short enough that the partner could play along and escalate." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A friend's garden in summer. You are talking to someone who has just described their vegetable patch in considerable detail.",
    "partner": {
      "name": "Pav",
      "role": "a friend of a friend, in a good mood",
      "personality": "Enjoys being gently sent up and plays along enthusiastically, escalating any bit that gets started.",
      "mood": "Cheerful and a couple of drinks in.",
      "openness": 5
    },
    "opening_beat": "Pav finishes explaining his composting system and admits, without embarrassment, that he checks the temperature of it.",
    "success_looks_like": "The user mislabels the hobby at an absurd scale, Pav plays along, and a running bit develops between them.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "If the user mislabels your hobby at an obviously exaggerated scale, play along and escalate the bit further.",
      "If the user makes a joke that could be taken as a genuine criticism, respond a little defensively before recovering.",
      "Keep giving the user new material to exaggerate."
    ]
  }$j$::jsonb,
  $md$Today, take something someone tells you and describe it at obviously the wrong scale. Log the thing and the word you used for it.$md$
),
(
  (select id from public.skills where slug = 'banter'),
  3,
  'Mock stakes',
  $md$The second reliable form is treating something trivial as though it were enormously important, and committing to it.

*This is the most important decision you will make today. I need you to know I take this very seriously. We are going to have a problem if you say pineapple.* The humour is entirely in the mismatch between the gravity of the delivery and the triviality of the subject.

**The move:** pick something that does not matter and pretend it is a crisis.

Mock stakes are useful because they create a tiny, safe conflict. Real disagreement is risky with someone you barely know; fake disagreement about the correct biscuit is intimacy with the risk removed. You get the feeling of having taken sides with no possibility of anyone being hurt.

The rule is that it must be obviously trivial. Applying mock stakes to something they actually care about is not banter, it is mockery.$md$,
  $j$[
    {
      "situation": "They ask whether you want tea or coffee.",
      "line": "This feels like a test. I am going to answer carefully.",
      "why": "Instant mock stakes on a nothing question. It signals playfulness within the first thirty seconds of a conversation."
    },
    {
      "situation": "They admit they put the milk in first.",
      "line": "Right. I am going to need a minute to decide how I feel about this friendship.",
      "why": "A fake crisis over something that could not matter less. The word friendship is the giveaway that it is a game."
    },
    {
      "situation": "You are both choosing where to sit in a nearly empty room.",
      "line": "Be careful. Everything that happens next depends on this.",
      "why": "Turns a non-decision into a moment. Mock stakes work best applied to things with no content at all."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Which subject is the best candidate for mock stakes with someone you have just met?",
    "options": [
      {
        "text": "Their choice of sandwich filling.",
        "correct": true,
        "note": "Perfectly trivial, universally understood, and impossible to actually offend anyone about. The ideal fake battleground."
      },
      {
        "text": "Their taste in music.",
        "correct": false,
        "note": "Riskier than it looks. Plenty of people are genuinely invested in their taste, so a mock verdict can land as a real one."
      },
      {
        "text": "Their choice of career.",
        "correct": false,
        "note": "Not trivial. Applying fake gravity to something that carries real weight for them reads as mockery."
      },
      {
        "text": "Their football team.",
        "correct": false,
        "note": "The classic mistake. It looks like a safe fake rivalry and is, for some people, an entirely real one."
      }
    ],
    "explain": "Mock stakes need a subject with no real stakes at all. If they might genuinely care, pick something else."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "chose_trivial", "label": "Picked something genuinely trivial", "description": "Applied fake gravity to a subject with no real weight for the partner." },
      { "key": "committed", "label": "Committed to the bit", "description": "Delivered it with enough conviction that the mismatch was the joke." },
      { "key": "safe_conflict", "label": "Created a safe disagreement", "description": "Produced the pleasure of taking sides without any actual risk." },
      { "key": "let_them_play", "label": "Let them join in", "description": "Left space for the partner to take the opposite side and escalate." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The snack table at a low-key house party. There is an unreasonable variety of crisps.",
    "partner": {
      "name": "Immy",
      "role": "someone you have just been introduced to",
      "personality": "Quick and competitive, delighted by a fake argument and completely unbothered by losing one.",
      "mood": "Relaxed and up for it.",
      "openness": 5
    },
    "opening_beat": "Immy is surveying the crisp selection and says, mostly to herself, that this is a genuinely difficult decision.",
    "success_looks_like": "The user takes the trivial decision and inflates it into a fake crisis, and Immy joins in and escalates.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "If the user applies mock stakes to something trivial, take the opposite side with total conviction and escalate.",
      "If the user applies mock gravity to something that might actually matter to a person, respond flatly and change the subject.",
      "Keep the fake argument going as long as the user does."
    ]
  }$j$::jsonb,
  $md$Today, turn one completely trivial thing into a fake crisis and commit to it. Log what the crisis was and whether they joined in.$md$
),
(
  (select id from public.skills where slug = 'banter'),
  4,
  'Callbacks',
  $md$A callback is the single highest-value thing you can do in a conversation, and it costs nothing but attention.

Fifteen minutes after someone makes a passing joke about their terrible sense of direction, you refer back to it while talking about something else entirely. That is it. The laugh is out of proportion to the effort, because a callback proves two things at once: you were listening, and the two of you now have a shared reference that nobody else in the room has.

**The move:** keep one funny thing they said in your pocket, and bring it back later.

That is genuinely all it is. The hard part is not the wit, it is remembering. Most people are composing their next line instead of storing the material.

A callback in the last minute of a conversation is worth the most, because it is the thing they will remember about talking to you.$md$,
  $j$[
    {
      "situation": "Earlier they joked that they are incapable of following a recipe.",
      "line": "You can bring the wine. I am not letting you near the food.",
      "why": "Uses their own joke twenty minutes later in a new context. It signals that everything they said was worth keeping."
    },
    {
      "situation": "They made a joke about their flatmate's houseplant obsession.",
      "line": "Say hello to the plants for me.",
      "why": "A callback used as an exit line. This is the highest-value placement, because it is the last thing they hear."
    },
    {
      "situation": "They mentioned they always get talked into things.",
      "line": "You are going to say yes to this and then be annoyed about it later, aren't you.",
      "why": "Uses a pattern they told you about themselves rather than a specific joke. Slightly more advanced, and lands harder."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "When is a callback worth the most?",
    "options": [
      {
        "text": "Immediately, while it is still fresh.",
        "correct": false,
        "note": "Too soon is just repetition. The callback works because time has passed and you kept it anyway."
      },
      {
        "text": "As the conversation is ending.",
        "correct": true,
        "note": "It is the last thing they hear, it proves you held on to something across the whole conversation, and it makes the exit warm."
      },
      {
        "text": "Whenever there is an awkward silence.",
        "correct": false,
        "note": "Better than nothing, but using it as a rescue makes it feel deployed rather than remembered."
      },
      {
        "text": "The next time you see them.",
        "correct": false,
        "note": "This is excellent when it works, but it is a different move. Within the same conversation the effect is more reliable."
      }
    ],
    "explain": "Callbacks work because of the gap. Save one for the exit, where it doubles as the thing they remember about you."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "stored_it", "label": "Kept something in their pocket", "description": "Held on to a specific line or detail from earlier in the conversation." },
      { "key": "brought_it_back", "label": "Landed a callback", "description": "Referred back to earlier material in a new context." },
      { "key": "let_time_pass", "label": "Waited long enough", "description": "Left enough of a gap that the callback read as memory rather than repetition." },
      { "key": "placement", "label": "Placed it well", "description": "Used it at a moment where it added warmth, ideally near the end." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A long wait for a delayed flight. You have been talking to the person next to you at the gate for a while.",
    "partner": {
      "name": "Ren",
      "role": "another stranded passenger",
      "personality": "Funny in an offhand way and drops small self-deprecating jokes without dwelling on them. Visibly delighted when one is remembered.",
      "mood": "Resigned to the delay and enjoying the company.",
      "openness": 4
    },
    "opening_beat": "Ren mentions, entirely in passing, that he has already been to the wrong gate twice and it is not even lunchtime.",
    "success_looks_like": "The user stores an early joke and brings it back later in a new context, and Ren reacts with real pleasure at being remembered.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Drop a small, memorable self-deprecating joke in your first two replies, then move on and do not mention it again.",
      "If the user calls back to it later, react with genuine delight and build on it.",
      "Keep offering new small details, but never repeat your own earlier jokes yourself."
    ]
  }$j$::jsonb,
  $md$Land one callback today. Keep something funny from early in a conversation and bring it back near the end. Log what you saved and where you used it.$md$
),
(
  (select id from public.skills where slug = 'banter'),
  5,
  'When a joke does not land',
  $md$Every so often a joke will die. The recovery is a skill, and it is worth more than the jokes themselves.

The instinct is to explain it, repeat it slightly louder, or apologise. All three extend the moment. Explaining a joke is the only thing more uncomfortable than the joke failing, and apologising asks them to reassure you, which is now a chore you have handed them.

**The move:** acknowledge it in three words or fewer and carry straight on.

*Nothing. Anyway.* *That was worse out loud.* Then continue as though nothing happened, because almost nothing did. A joke that does not land is only awkward for as long as you keep it alive, and you control that entirely.

The deeper point: people are far more relaxed around someone who is visibly fine with a joke failing. It tells them your ease does not depend on their approval, which makes them easier in return.$md$,
  $j$[
    {
      "situation": "You made a joke and got a polite half-smile.",
      "line": "That was better in my head. Anyway, you were saying?",
      "why": "Six words of acknowledgement and an immediate return to their topic. The moment is closed before it can set."
    },
    {
      "situation": "A joke lands completely flat with someone you have just met.",
      "line": "(a small shrug, then carry on as normal)",
      "why": "Not everything needs words. Visible unbotheredness does the whole job and does not spend any more of the conversation on it."
    },
    {
      "situation": "You realise mid-sentence the joke is not going to work.",
      "line": "I have lost confidence in this sentence.",
      "why": "Abandoning a joke cheerfully is often funnier than the joke was. Narrating your own failure is safe because you are the target."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Your joke gets a blank look. What is the best recovery?",
    "options": [
      {
        "text": "Explain what you meant.",
        "correct": false,
        "note": "The single worst option. Explaining extends the failure and turns a two-second moment into a thirty-second one."
      },
      {
        "text": "Apologise for the joke.",
        "correct": false,
        "note": "Hands them the job of reassuring you, which is more work than the joke ever cost them."
      },
      {
        "text": "Say nothing and change the subject abruptly.",
        "correct": false,
        "note": "Workable, but the abruptness signals you were rattled. A brief acknowledgement is smoother than pretending it did not happen."
      },
      {
        "text": "Note it in a few words and carry straight on.",
        "correct": true,
        "note": "Closes the moment, shows it costs you nothing, and returns to the conversation. Being visibly unbothered is the whole recovery."
      }
    ],
    "explain": "A failed joke lasts exactly as long as you keep it alive. Three words and move on."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "did_not_explain", "label": "Did not explain the joke", "description": "Resisted the urge to clarify what was meant." },
      { "key": "did_not_apologise", "label": "Did not apologise", "description": "Avoided handing the partner the job of reassurance." },
      { "key": "moved_on", "label": "Carried straight on", "description": "Returned to the conversation quickly rather than dwelling." },
      { "key": "stayed_easy", "label": "Stayed visibly unbothered", "description": "Kept their ease, which let the partner stay easy too." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A quiet weekday pub. You are talking to someone with a much drier sense of humour than yours.",
    "partner": {
      "name": "Halvard",
      "role": "a friend of a friend you have met once",
      "personality": "Very dry and hard to read. Does not laugh easily at anything, which makes jokes feel like they have failed even when they have not.",
      "mood": "Content, understated, genuinely enjoying the conversation without showing much.",
      "openness": 3
    },
    "opening_beat": "Halvard responds to your first attempt at a joke with a small nod and absolutely no laugh, then waits.",
    "success_looks_like": "The user's joke appears to fail, and they recover in a few words without explaining or apologising, after which Halvard warms considerably.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Never laugh out loud. Respond to jokes with dry, understated acknowledgement at most.",
      "If the user explains or apologises for a joke, become more reserved.",
      "If the user shrugs it off in a few words and carries on, warm up noticeably and offer a dry joke of your own."
    ]
  }$j$::jsonb,
  $md$Today, let one joke fail on purpose or by accident, and recover in three words. Notice that nothing bad happens. Log the joke and the recovery.$md$
);
