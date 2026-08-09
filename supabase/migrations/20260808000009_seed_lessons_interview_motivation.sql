-- Interviews, track 2: Why you, and why now. Five lessons on the questions
-- that decide whether they believe you want this one in particular.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'interview-motivation'),
  1,
  'Why you are leaving',
  $md$This one is asked every time, and it is the answer most likely to be repeated back to somebody else afterwards.

The instinct is to explain, and explaining means listing what is wrong where you are. That is the trap. Whatever you say about your current employer is heard as a preview of what you will say about this one in two years, and the interviewer does not have to think it consciously for it to cost you.

**The move:** say what you have run out of, then what you are going towards. Nothing else.

*Run out of* is the phrase that does the work. It is honest, it cannot be argued with, and it contains no accusation. You have run out of scope, or out of new problems, or out of people to learn from — all true, all forward-facing, and none of them anybody's fault.

The rule is not to be positive about a bad job. It is to be brief about it. One clause on the past, one sentence on the future, and move.$md$,
  $j$[
    {
      "situation": "You are leaving because the work stopped being interesting.",
      "line": "I have done the same shape of problem three times there now, and I have run out of new ones.",
      "why": "Names the limit without naming a villain. It is also checkable against the CV, which makes it land as a reason rather than a line."
    },
    {
      "situation": "You are leaving because your manager is difficult.",
      "line": "I want to be somewhere with more people ahead of me than behind me. That is not true where I am.",
      "why": "The true reason, said at the level of the situation rather than the person. Every word of it survives being repeated to your current boss."
    },
    {
      "situation": "You were restructured and the job you took is not the job you have.",
      "line": "The team was reorganised in March and the role that came out of it is not the one I wanted to be doing.",
      "why": "A fact with a date, and no complaint attached. Restructures are ordinary and interviewers hear them all week."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which answer costs you the most, even though all four are true?",
      "options": [
        { "text": "The management is chaotic and nothing gets decided.", "correct": true, "note": "The most expensive true sentence available. It tells them what you will say about them, and it makes every later answer about your judgement rather than your work." },
        { "text": "I have run out of things to learn there.", "correct": false, "note": "Forward-facing and unarguable. It says something about the ceiling rather than about the people under it." },
        { "text": "The team was restructured and my role changed.", "correct": false, "note": "A dated fact. Interviewers hear this several times a week and it carries no charge at all." },
        { "text": "I want a bigger version of the problem I have been working on.", "correct": false, "note": "The strongest of the four, because it is entirely about where you are going and it can be checked against your CV." }
      ],
      "explain": "Any sentence about your current employer is heard as a preview. Say what you have run out of instead."
    },
    {
      "prompt": "The interviewer follows up: \"That is fair — but was there nothing keeping you?\" What is the follow-up for?",
      "options": [
        { "text": "To see whether the first answer was the whole answer.", "correct": false, "note": "Partly, and it is not what the probe is testing. They are more interested in whether you will start complaining now that a door has been opened." },
        { "text": "To find out whether you were pushed.", "correct": false, "note": "Occasionally, and being let go is a separate conversation with its own shape. Most follow-ups here are not that." },
        { "text": "To see whether you will take the invitation to complain.", "correct": true, "note": "It is an open door, and walking through it is the mistake. Answer warmly, name one genuine thing you will miss, and stop." },
        { "text": "To fill time before the next question.", "correct": false, "note": "Nothing at this stage of an interview is filler, and a second question on the same subject is never idle." }
      ],
      "explain": "A follow-up on why you are leaving is usually an invitation to say more than you should. Name something you will miss, and stop."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "pointed_forwards", "label": "Pointed forwards", "description": "Said what they are going towards rather than what they are escaping." },
      { "key": "no_blame", "label": "Named no villain", "description": "Kept the answer at the level of the situation rather than a person." },
      { "key": "brief", "label": "Kept it short", "description": "One clause on the past, one sentence on the future, then stopped." },
      { "key": "honest", "label": "Was actually true", "description": "Gave the real reason at a level of detail they chose, rather than a manufactured one." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A first interview, about eight minutes in. Your story is done and the hiring manager has moved on to the obvious next question.",
    "partner": {
      "name": "Ceri Hughes",
      "role": "the hiring manager, who has done this a lot",
      "personality": "Warm and unhurried, and follows up on anything that sounds rehearsed.",
      "mood": "Genuinely curious, in no rush.",
      "openness": 4
    },
    "opening_beat": "\"That is a good summary, thank you. So — why are you looking?\"",
    "success_looks_like": "The user answers forwards, briefly, and without a sentence anybody would mind being repeated.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "If the user criticises their current employer, follow up gently with an open door rather than an objection.",
      "Do not accept a rehearsed-sounding answer without one follow-up.",
      "Keep replies to a sentence or two, at the pace of a real first interview."
    ]
  }$j$::jsonb,
  $md$Write the sentence you would use for why you are leaving, and then read it out loud imagining your current manager is in the room. If any part of it makes you wince, that is the part to cut. Log the version you settled on.$md$
),
(
  (select id from public.skills where slug = 'interview-motivation'),
  2,
  'Five years',
  $md$Nobody asking this believes you have a plan, and nobody wants to hear one.

They are checking two things. That the road you are already on runs through this job, and that you are not going to leave in eight months. Both are answerable, and neither of them needs a title.

**The move:** describe the direction you are already travelling, not the destination.

Titles are the trap. Naming their job is a threat, naming a job above it is a strange thing to say to somebody who would be your manager, and naming a job below it makes them wonder why you applied. A direction has none of those problems, and it has one large advantage: it can be checked against your CV, which is what makes it believable.

"More of this, less of that" is a complete answer. So is "the same work, on problems where nobody knows the answer yet". Both say something real about you and neither commits you to anything you would have to remember.

If you genuinely do not know, say that and give the direction anyway. Not knowing the destination is normal. Not knowing the direction reads as drifting.$md$,
  $j$[
    {
      "situation": "You want more responsibility but have no interest in managing people.",
      "line": "Further into the work rather than further above it. I would like to be the person the hard version of this gets given to.",
      "why": "A direction with a clear shape, and it quietly answers a question they might not have asked about whether you want their job."
    },
    {
      "situation": "You genuinely have not thought about it.",
      "line": "I have never had a five-year plan and the two times I made one I ignored it. What I can tell you is the direction.",
      "why": "Honest, faintly self-deprecating, and it does not leave them with nothing. Refusing the premise is fine as long as you answer the real question underneath."
    },
    {
      "situation": "You would like to be doing the interviewer's job eventually.",
      "line": "Running something of this size, probably. Which I am aware is your job, so let me say it is the shape rather than the seat.",
      "why": "Names the ambition and defuses it in the same breath. Pretending not to be ambitious in front of an ambitious person rarely works."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is naming a job title usually the weakest answer?",
      "options": [
        { "text": "It is either flattery, a threat, or a question about why you applied.", "correct": true, "note": "All three failure modes come from the same move. A title is a position in their hierarchy, and every position has an awkward reading." },
        { "text": "It sounds arrogant.", "correct": false, "note": "Only one of the three readings, and the least common. Ambition is not the problem; specificity about their org chart is." },
        { "text": "Five years is too far away to predict.", "correct": false, "note": "True and not the point. They know it is unpredictable, which is why they are not really asking about the destination." },
        { "text": "It commits you to something you may not want.", "correct": false, "note": "A minor risk. Nobody is holding you to an interview answer three years later." }
      ],
      "explain": "A direction can be checked against your CV. A title can only be checked against their hierarchy."
    },
    {
      "prompt": "What makes a direction believable rather than a nice sentence?",
      "options": [
        { "text": "Saying it with conviction.", "correct": false, "note": "Conviction is what an unbelievable answer also has. It is not evidence." },
        { "text": "Naming a specific skill you want to build.", "correct": false, "note": "Better, and still forward-only. It is the part of the answer they cannot check." },
        { "text": "That your last three moves already point that way.", "correct": true, "note": "The CV is the evidence, and it is sitting in front of them. A direction your history already supports is the only version that cannot be doubted." },
        { "text": "Tying it to the company's own plans.", "correct": false, "note": "Flattering, and it answers a question about them rather than about you. It also expires the moment their plans change." }
      ],
      "explain": "The believable version of this answer is the one your CV was already making before you said it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "gave_direction", "label": "Gave a direction", "description": "Described where they are heading rather than a job title." },
      { "key": "checkable", "label": "Matched their history", "description": "Named a direction their last few moves already support." },
      { "key": "no_title", "label": "Avoided the org chart", "description": "Did not name the interviewer's job, or one above or below it." },
      { "key": "stayed_short", "label": "Did not over-plan", "description": "Answered without producing a five-year strategy nobody asked for." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A second-round interview with a talent partner who runs the same set of questions with every candidate.",
    "partner": {
      "name": "Lorna Bassey",
      "role": "a talent partner who has asked this question several thousand times",
      "personality": "Brisk and pleasant. Has heard every version of this answer and is listening for whether it matches the CV in front of her.",
      "mood": "Efficient, third interview of the day.",
      "openness": 3
    },
    "opening_beat": "\"Standard one, and then I will let you off. Where do you see yourself in five years?\"",
    "success_looks_like": "The user gives a direction rather than a title, and it is one their history already supports.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "If the user names a job title, ask neutrally what draws them to that specifically.",
      "Do not react warmly to a plan. React warmly to a direction that fits the CV.",
      "Keep replies short. She has another interview at the hour."
    ]
  }$j$::jsonb,
  $md$Write your five-year answer as a direction with no job title in it. Then check it against your last three moves — if they do not already point that way, it is aspiration rather than direction. Log the version that survives.$md$
),
(
  (select id from public.skills where slug = 'interview-motivation'),
  3,
  'Why should we hire you',
  $md$This is the only question in the entire process that invites you to argue your own case, and most people decline the invitation out of politeness.

*I think I would be a good fit* is the standard answer and it is barely an answer. It hedges, it uses a phrase that means nothing, and it hands back an opportunity that will not come again. They asked. Answering plainly is not arrogance, it is doing as you were asked.

**The move:** name what the job turns on, claim it, and attach the evidence that makes the claim checkable.

The first part is the one people skip. Most candidates answer with their best quality rather than with the job's biggest problem, and a strength that is not aimed at anything is just a nice thing about you. Work out what this role is actually for — usually somebody said it earlier in the interview — and answer about that.

Then one piece of evidence, and stop. The temptation is to list three, and the list is weaker than the single specific thing, because a list sounds like a search for something that will stick.$md$,
  $j$[
    {
      "situation": "The role exists because a process nobody owns keeps breaking.",
      "line": "This turns on untangling something three teams own and none of them control. That is the exact thing I did at my last place, and it is the part I would take even if the rest were dull.",
      "why": "Aims at the problem rather than at a quality, and the evidence is one thing rather than a list."
    },
    {
      "situation": "You are less experienced than the job description asks for.",
      "line": "On paper I am two years short. What I have done is the harder half of it — I ran the migration nobody wanted, and it is why I would back myself here.",
      "why": "Names the gap first, which buys the claim credibility. Arguing your case around an obvious weakness rather than through it is what makes it sound thin."
    },
    {
      "situation": "You have no idea what the role turns on because nobody has said.",
      "line": "I would answer that better if I knew what the first six months has to fix. Can I ask that, and then answer properly?",
      "why": "A legitimate move and a strong one. Asking what the job is for, at the end, is more impressive than guessing at it."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Most candidates answer this with their best quality. What is wrong with that?",
      "options": [
        { "text": "It is not aimed at anything, so it is just a nice thing about you.", "correct": true, "note": "A strength only becomes an argument when it is pointed at the problem the role exists to solve. Unaimed, it is a compliment you have paid yourself." },
        { "text": "Qualities are hard to prove.", "correct": false, "note": "They are, and the fix for that is evidence rather than a different subject. This answer fails before the evidence question comes up." },
        { "text": "It sounds boastful.", "correct": false, "note": "The opposite problem, usually. These answers are almost always too modest rather than too bold." },
        { "text": "Everyone gives the same qualities.", "correct": false, "note": "True and secondary. A common quality aimed precisely at the role still works." }
      ],
      "explain": "Answer about the job's biggest problem, not about your best feature."
    },
    {
      "prompt": "You have made your claim. How much evidence?",
      "options": [
        { "text": "Three examples, so it does not rest on one thing.", "correct": false, "note": "A list reads as searching for something that will stick. Three weak-sounding examples are worse than one that lands." },
        { "text": "One specific thing, then stop.", "correct": true, "note": "One piece of evidence, specific enough to be checked, is the strongest available shape. The stopping is part of it." },
        { "text": "None — the claim should stand on its own.", "correct": false, "note": "Then it is the hedge again in a more confident voice. A claim without evidence is what everybody else in the process is also offering." },
        { "text": "As much as they seem interested in.", "correct": false, "note": "Reading the room is good instinct, and this is the wrong moment for it. Land one thing and let them ask." }
      ],
      "explain": "One claim, one piece of evidence, then stop. The list is what weakens it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named_the_problem", "label": "Aimed at the real problem", "description": "Answered about what the role turns on rather than about a general strength." },
      { "key": "claimed_it", "label": "Made the claim plainly", "description": "Said it without hedging or filler phrases." },
      { "key": "evidence", "label": "Attached one piece of evidence", "description": "Gave a specific, checkable thing rather than a list." },
      { "key": "stopped", "label": "Stopped", "description": "Resisted adding a second and third example after the first had landed." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The last few minutes of a final-round interview. Everything else has been covered.",
    "partner": {
      "name": "Marcus Delaney",
      "role": "the hiring manager, who is seeing three people this week",
      "personality": "Direct and slightly impatient with modesty. Will not fill a silence for you.",
      "mood": "Decided about most of it, using this question to break a tie.",
      "openness": 3
    },
    "opening_beat": "\"Last one from me. Why should I hire you rather than the other two people I am seeing this week?\"",
    "success_looks_like": "The user makes a plain claim aimed at the role's actual problem, with one specific piece of evidence.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Do not rescue a hedged answer. Let the silence sit and see what they do with it.",
      "If asked what the first six months has to fix, answer it honestly — it is a good question.",
      "Keep replies brief. This is the end of a long interview."
    ]
  }$j$::jsonb,
  $md$Work out what the role you want actually turns on, in one sentence. Then write the claim and the single piece of evidence. Log both, and notice whether your first instinct was to list three things.$md$
),
(
  (select id from public.skills where slug = 'interview-motivation'),
  4,
  'What actually motivates you',
  $md$The generic answers fail for a specific reason: they cannot be wrong.

*I like solving problems. I am motivated by impact. I enjoy a challenge.* Nobody in the history of interviews has said the opposite, which means these sentences carry no information, and an interviewer who has asked this four times today can hear that immediately.

**The move:** name the thing that already explains your CV.

A real motivation is checkable, and the place it is checked is the page in front of them. It should account for something that would otherwise look odd — why you stayed somewhere two years longer than made sense, why you took a sideways move, why you keep ending up on the same kind of mess. If your answer explains nothing on your CV, it is a value statement rather than a motivation.

This is also the most useful question in the interview for you, because working out the true answer tells you whether you want the job. A motivation you can name is one you can check the role against.

Specific and slightly odd beats admirable. "I like finding out why something is actually happening" is a better answer than "impact", and it is a better answer partly because nobody else will give it.$md$,
  $j$[
    {
      "situation": "You keep taking jobs where something is broken.",
      "line": "I like being the person who works out why something is actually happening. It is why I have ended up on the messy end of three jobs and keep turning down the tidy ones.",
      "why": "Specific, faintly unusual, and it explains a pattern visible on the CV. That last part is what turns it from a value into a motivation."
    },
    {
      "situation": "You stayed at one company far longer than your peers.",
      "line": "I am slow to leave things I am still learning from, which is why I was there six years while everyone I started with left at two.",
      "why": "Takes the oddest thing on the page and turns it into evidence. Answering the unasked question is worth more than the asked one."
    },
    {
      "situation": "Your honest answer is that you like being good at something.",
      "line": "Being properly good at one thing rather than adequate at four. I have moved sideways twice to stay on the same problem.",
      "why": "Unfashionable, true, and immediately checkable. Interviewers remember the answers that were not designed to be liked."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does \"I am motivated by impact\" fail?",
      "options": [
        { "text": "Nobody says the opposite, so it carries no information.", "correct": true, "note": "An answer that cannot be contradicted has not told them anything. It is the defining property of every generic answer to this question." },
        { "text": "It is too vague to be memorable.", "correct": false, "note": "A symptom rather than the cause. Vagueness is what unfalsifiable answers sound like." },
        { "text": "Interviewers dislike buzzwords.", "correct": false, "note": "They are indifferent to the words. It is the absence of anything checkable behind them." },
        { "text": "It does not mention the company.", "correct": false, "note": "This question is not asking about them. Bending it towards the company is a different mistake." }
      ],
      "explain": "If the opposite of your answer is something nobody would ever say, your answer is not information."
    },
    {
      "prompt": "How do you know your answer is the real one?",
      "options": [
        { "text": "It is the one you would give a friend.", "correct": false, "note": "A decent test and not sufficient. Plenty of true things about you explain nothing about your career." },
        { "text": "It is something you could do without being paid.", "correct": false, "note": "A nice idea that quietly excludes most honest motivations, including money and mastery." },
        { "text": "It explains something on your CV that otherwise looks odd.", "correct": true, "note": "The only test with evidence attached. If it accounts for a decision on the page, it survives every follow-up they can ask." },
        { "text": "You can say it without hesitating.", "correct": false, "note": "Fluency is what a rehearsed generic answer also has." }
      ],
      "explain": "The real one accounts for a choice you already made. Anything else is a value statement."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "not_generic", "label": "Avoided the standard answers", "description": "Did not reach for impact, challenge or solving problems." },
      { "key": "explains_cv", "label": "Explained the CV", "description": "Named something that accounts for a real decision on the page." },
      { "key": "specific", "label": "Was specific enough to be odd", "description": "Gave an answer nobody else in the process would give." },
      { "key": "honest", "label": "Was actually true", "description": "Named the real motivation rather than the admirable one." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A conversation with a director who joined the process late and is not working from a script.",
    "partner": {
      "name": "Yohannes Girma",
      "role": "a director who has interviewed four people today",
      "personality": "Dry, attentive, and openly bored of the standard answers. Warms up immediately to anything specific.",
      "mood": "Tired of hearing the same sentence.",
      "openness": 3
    },
    "opening_beat": "\"What actually motivates you? And I should say I have heard 'solving problems' three times today.\"",
    "success_looks_like": "The user names something specific that accounts for a real decision on their CV.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "If the user gives a generic answer, say so plainly but without unkindness, and ask again.",
      "Warm up noticeably when an answer is specific or slightly unusual.",
      "Keep replies to a sentence or two."
    ]
  }$j$::jsonb,
  $md$Look at your own CV and find the decision that looks strangest from outside. Write the motivation that explains it. Log both — the odd decision, and the sentence that accounts for it.$md$
),
(
  (select id from public.skills where slug = 'interview-motivation'),
  5,
  'Where else are you interviewing',
  $md$This question is doing two jobs and both of them are reasonable.

The first is timing: how long have they got before you are gone. The second is calibration: what else do you consider comparable, which tells them how you see the role and sometimes tells them their salary band is wrong.

**The move:** answer honestly at a level of detail you choose, and never invent an offer.

Naming companies is optional and rarely necessary. Naming the shape is what is useful to both of you — two others at a similar stage, or one further along, or nothing yet because you only started looking. Any of those is a complete answer, and "nothing yet" is not a weakness however it feels.

The invented competing offer is the one genuinely dangerous move in this whole topic. It is checkable in a small industry, it sets a deadline you made up and then have to live inside, and if anybody calls it — "great, when do you need to decide?" — you have nothing. The upside is a few thousand pounds. The downside is the offer.

Telling them about a real deadline is different, and worth doing early rather than as leverage.$md$,
  $j$[
    {
      "situation": "You have two other processes at roughly the same stage.",
      "line": "Two others, both at about this point. Nothing decided anywhere, including here.",
      "why": "Honest, useful, and it names no companies. The last clause is warm and quietly makes the point that they have not decided either."
    },
    {
      "situation": "This is the only process you are in.",
      "line": "Just this one at the moment. I am being fairly picky about what I apply for.",
      "why": "Turns the weak-sounding answer into a statement about standards, which is both true and better than an invented second process."
    },
    {
      "situation": "You have a real offer with a real deadline next Friday.",
      "line": "I have one offer with a decision needed by Friday. I wanted to say that now rather than spring it on you later.",
      "why": "A real deadline said early is information. The same sentence produced at the negotiation reads as a lever, even when it is entirely true."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "You are not interviewing anywhere else. What is the best answer?",
      "options": [
        { "text": "Say so, and say why you are being selective.", "correct": true, "note": "The honest version with a reason attached. Being in one process is only weak if you present it as an accident." },
        { "text": "Say you are in early conversations with a couple of places.", "correct": false, "note": "A small invention that buys nothing and that a follow-up question turns into an awkward retreat." },
        { "text": "Say you would rather not discuss other processes.", "correct": false, "note": "Refusing a reasonable question makes it interesting. It also implies an answer worse than the true one." },
        { "text": "Deflect and ask about their timeline instead.", "correct": false, "note": "A visible dodge, and their timeline is worth asking about anyway once you have answered." }
      ],
      "explain": "Nothing yet is a complete answer. Say it with a reason and it stops sounding like a gap."
    },
    {
      "prompt": "Why is inventing a competing offer the worst available move?",
      "options": [
        { "text": "It sets a deadline you then have to live inside.", "correct": false, "note": "One of three reasons, and the least severe. You can survive a deadline; the others are harder." },
        { "text": "It is dishonest.", "correct": false, "note": "True, and on its own it is not what makes it dangerous. Plenty of candidates would take that trade if it worked." },
        { "text": "It is checkable, it creates a deadline, and it collapses if tested.", "correct": true, "note": "All three at once, and the third is fatal. \"When do you need to decide?\" is the ordinary next question, and there is no good answer to it." },
        { "text": "It makes you look mercenary.", "correct": false, "note": "Interviewers are entirely relaxed about candidates having options. It is the invention rather than the ambition." }
      ],
      "explain": "The upside is a few thousand pounds and the downside is the offer. Real deadlines only, said early."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "honest", "label": "Told the truth", "description": "Answered accurately at a level of detail they chose." },
      { "key": "no_invention", "label": "Invented nothing", "description": "Did not manufacture a competing process or offer." },
      { "key": "right_detail", "label": "Gave the shape, not the names", "description": "Described where things stand without naming companies unnecessarily." },
      { "key": "timing", "label": "Raised a real deadline early", "description": "Where one existed, mentioned it as information rather than as leverage." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The end of a second interview. The recruiter has come back on the call to talk about next steps.",
    "partner": {
      "name": "Nula Brennan",
      "role": "the internal recruiter managing the process",
      "personality": "Friendly and practical. Asks the question because she has to plan around the answer.",
      "mood": "Organised, thinking about diary slots.",
      "openness": 4
    },
    "opening_beat": "\"Before I let you go — are you talking to anyone else at the moment? It helps me know how quickly I need to push things along.\"",
    "success_looks_like": "The user answers honestly at a level of detail they chose, and invents nothing.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "If the user mentions an offer or a deadline, ask when they need to decide by.",
      "Be entirely relaxed about the candidate having other options.",
      "Keep replies short and practical. She is arranging a diary, not testing them."
    ]
  }$j$::jsonb,
  $md$Write your honest answer to this one, including the version where the answer is nothing yet. Then check it contains no company you have not actually spoken to. Log it before you need it.$md$
);

-- ---------------------------------------------------------------------------
-- Modes. Four line drills and one read-and-decide, so the whole track is free
-- to run — which is what you want on the questions people rehearse in the car.
-- ---------------------------------------------------------------------------

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id
      and s.slug = p_skill
      and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('interview-motivation', 1, 'line', $j${
  "says": "That is a good summary, thank you. So — why are you looking?",
  "maxChars": 500,
  "model": {
    "line": "I have done the same shape of problem three times there now and I have run out of new ones. I want the version that is too big for one person to hold.",
    "why": "One clause on the past, one sentence on the future, and not a word anybody would mind being repeated to your current manager."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Nothing about a person, and nothing you would not say to their face",
      "words": ["toxic", "micromanage", "nightmare", "incompetent", "politics", "my boss", "terrible", "awful", "hated", "useless", "clueless"] },
    { "kind": "contains_any", "requirement": "Point it at what you are going towards",
      "words": ["want", "looking for", "towards", "next", "ready", "run out", "learn", "grow", "bigger"] },
    { "kind": "max_sentences", "requirement": "Two sentences. Brief is the whole technique.", "n": 2 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-motivation', 2, 'line', $j${
  "says": "Standard one, and then I will let you off. Where do you see yourself in five years?",
  "maxChars": 500,
  "model": {
    "line": "Further into the work rather than further above it. I have moved sideways twice already to stay on the same kind of problem, and the direction is more of that.",
    "why": "A direction rather than a destination, and the second sentence is the evidence — it is a direction her CV was already making before she said it."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No job title, and definitely not theirs",
      "words": ["your job", "your role", "head of", "director of", "ceo", "cto", "vp", "running the department", "in charge of"] },
    { "kind": "contains_any", "requirement": "Say the direction, not the destination",
      "words": ["towards", "direction", "deeper", "further", "more of", "the kind of", "still", "keep", "better at"] },
    { "kind": "max_sentences", "requirement": "Three sentences at most", "n": 3 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-motivation', 3, 'line', $j${
  "says": "Last one from me. Why should I hire you rather than the other two people I am seeing this week?",
  "maxChars": 600,
  "model": {
    "line": "This role turns on untangling a process that three teams own and none of them control. I did exactly that at my last place, the exceptions rebuild, and it is the part of the job I would take even if the rest of it were dull.",
    "why": "Aimed at the problem rather than at a quality, one piece of evidence rather than three, and then it stops."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No hedging and no filler",
      "words": ["i think i would", "i feel like", "hopefully", "i believe i", "good fit", "hard worker", "team player", "fast learner", "people person"] },
    { "kind": "contains_any", "requirement": "Attach the evidence, not just the claim",
      "words": ["i did", "i built", "i ran", "i rewrote", "i have", "when i", "at my last", "last place"] },
    { "kind": "max_words", "requirement": "Under seventy words. One claim, one proof, stop.", "n": 70 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-motivation', 4, 'line', $j${
  "says": "What actually motivates you? And I should say I have heard solving problems three times today.",
  "maxChars": 500,
  "model": {
    "line": "I like being the person who works out why something is actually happening. It is why I have ended up on the messy end of three different jobs and why I keep turning down the tidy ones.",
    "why": "Specific enough to be slightly odd, and the second sentence points at a pattern on the CV — which is the only thing that turns a value into a motivation."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "None of the ones everybody says",
      "words": ["solving problems", "making an impact", "challenge myself", "passionate", "new challenge", "fast paced", "making a difference", "helping people"] },
    { "kind": "contains_any", "requirement": "Tie it to something already on your CV",
      "words": ["which is why", "that is why", "it is why", "i have", "i keep", "every time", "twice", "three times"] },
    { "kind": "max_words", "requirement": "Under seventy words", "n": 70 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-motivation', 5, 'choice', $j${
  "beats": [
    {
      "situation": "The recruiter asks whether you are talking to anyone else. You are not — this is the only process you are in.",
      "prompt": "What do you say?",
      "options": [
        { "text": "Say you are in early conversations with a couple of others.", "correct": false, "note": "A small invention that buys nothing. One follow-up about where, and you are retreating from a sentence you did not need to say." },
        { "text": "Say so, and say you are being selective about what you apply for.", "correct": true, "note": "The honest answer with a reason attached. Being in one process only looks weak if you present it as an accident." },
        { "text": "Say you would rather not go into other processes.", "correct": false, "note": "Refusing a reasonable question makes it interesting, and implies an answer worse than the true one." },
        { "text": "Ask about their timeline instead.", "correct": false, "note": "A visible dodge. Their timeline is worth asking about, and after you have answered." }
      ]
    },
    {
      "situation": "You do have a real offer, with a decision needed by Friday.",
      "prompt": "When do you mention it?",
      "options": [
        { "text": "Now, as information, before anybody is negotiating.", "correct": true, "note": "A real deadline said early is something they can plan around. The identical sentence produced during a salary conversation reads as a lever, even when it is entirely true." },
        { "text": "At the offer stage, where it has the most leverage.", "correct": false, "note": "Where it also does the most damage to how you are read, and where it is most likely to be tested." },
        { "text": "Not at all — it is your business.", "correct": false, "note": "It is, and withholding it costs you the thing it is actually good for, which is making them move faster." },
        { "text": "Only if they ask directly.", "correct": false, "note": "They just did. This is the question, and answering it partially is a decision you will have to explain later." }
      ]
    }
  ]
}$j$::jsonb);

-- The cheat sheet gains the new track. Twenty concepts across nine groups,
-- which is the ceiling — anything more stops being something you can hold.
update public.topics set cheatsheet_json = jsonb_set(
  cheatsheet_json,
  '{groups}',
  (cheatsheet_json -> 'groups') || $j$[
    {
      "skill": "interview-motivation",
      "concepts": [
        { "name": "Point leaving forwards", "body": "Say what you have run out of, then what you are going towards. Anything you say about your current employer is heard as a preview of what you will say about this one." },
        { "name": "A motivation that explains your CV", "body": "The real one accounts for a decision on the page that would otherwise look odd. If it explains nothing, it is a value statement rather than a motivation." }
      ]
    }
  ]$j$::jsonb
)
where slug = 'interviews';
