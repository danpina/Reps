-- Interviews, track 1: Your story.
--
-- The first skill of the topic, which makes lessons 1 and 2 the free sample.
-- They are written to be the two lessons someone reads before deciding whether
-- this app is worth paying for.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'interview-your-story'),
  1,
  'Three beats, not a biography',
  $md$"Tell me about yourself" is not a question. It is a slot, and you decide what goes in it.

Most people answer it chronologically, because a life arrives in that order. Chronology is a trap: it spends the first thirty seconds on a degree you finished eleven years ago, and the interviewer's attention is highest in exactly those thirty seconds.

Use three beats instead.

**Beat one — where you came from.** One sentence. The shortest possible account of how you ended up doing this kind of work at all. Not where you were born. Not your A-levels.

**Beat two — what you did with it.** The middle, and the only part that should be more than a sentence or two. One or two concrete things you have actually done, chosen because they resemble the job on the table.

**Beat three — why you are here.** The landing. Why this role, at this place, now.

**The move:** answer in three beats — where you came from, what you did with it, why you are in this room.

The reason this works is not that it is tidy. It is that the interviewer is trying to build a model of you while you talk, and three beats is a model they can hold. A chronology gives them a list, and a list has no shape, so they remember the last thing you said and nothing else.

One warning. Beat two is where the good material lives, so it wants to grow, and it will keep growing until the answer is four minutes long and beat three never arrives. Beat three is the one that does the work. Protect it.$md$,
  $j$[
    {
      "situation": "A software engineer, six years in, interviewing at a payments company.",
      "line": "I got into engineering through a physics degree and a lot of scripting that got out of hand. Since then I have spent most of my time on systems where being wrong is expensive — the last four years on billing at a marketplace, which meant a lot of reconciliation and a lot of learning how money actually moves. That is why this job stood out: it is the same problem, but it is the whole company rather than one team's corner of it.",
      "why": "Three beats, and each is doing one job. The middle names the domain rather than listing employers, and the landing says why this company specifically — which is the part most candidates leave to be inferred."
    },
    {
      "situation": "Someone changing career, moving from teaching into instructional design.",
      "line": "I spent nine years teaching secondary maths, which is really nine years of finding out that explaining something once is never the job. The last two of those I was building the department's schemes of work, and I liked that part more than the classroom. So I have been doing that deliberately since — a course design qualification, and two freelance projects for training teams. This role is the version of that with a real budget and a team.",
      "why": "The career change is not apologised for; it is told as a line that arrives here. Notice that the awkward fact — nine years in a different profession — is the first thing said rather than something the interviewer has to dig up."
    },
    {
      "situation": "A recent graduate with no full-time experience, interviewing for a junior analyst role.",
      "line": "I came to this through a stats module I took almost by accident and then would not shut up about. Most of what I have actually done is small — a dissertation on transport data, a summer at a market research firm cleaning survey sets nobody wanted to touch, and a football statistics thing I run for fun that about four hundred people read. This job is the first one I have seen where all three of those are the same skill.",
      "why": "Thin experience handled by being specific rather than by inflating it. Three concrete things, all small, all true, all pointing the same way — which reads far stronger than one vague claim to be passionate about data."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which of these is the weakest opening beat?",
      "options": [
        {
          "text": "I studied economics at Leeds, then did a masters in Manchester, and graduated in 2016.",
          "correct": true,
          "note": "This is a chronology, and it spends the most valuable seconds of the answer on facts already printed on the CV in front of them."
        },
        {
          "text": "I got into this through a summer job I only took for the money, which turned out to be the first place I was any good at anything.",
          "correct": false,
          "note": "One sentence, slightly human, and it explains a beginning rather than listing one. It buys attention for the middle."
        },
        {
          "text": "I have spent about seven years now on the operations side of logistics, which was not the plan.",
          "correct": false,
          "note": "Compresses the whole beginning into a clause and signals there is a story without telling it yet. Efficient."
        }
      ],
      "explain": "The opening beat is the cheapest place to lose them. It is one sentence, and its only job is to get you to the middle with their attention intact."
    },
    {
      "prompt": "You are ninety seconds in and you have not reached the third beat. What is the fix?",
      "options": [
        {
          "text": "Speed up so you can still fit everything in.",
          "correct": false,
          "note": "Rushing does not compress an answer, it just makes it harder to follow. The interviewer stops listening and starts waiting."
        },
        {
          "text": "Drop the rest of the middle and go straight to why you are here.",
          "correct": true,
          "note": "The landing is the beat that changes anything. An answer that arrives there via two examples instead of four has lost nothing that matters."
        },
        {
          "text": "Finish the middle properly — the detail is what makes it credible.",
          "correct": false,
          "note": "It is credible already. The second-best example never turned an interview, and it is usually what eats the landing."
        },
        {
          "text": "Ask whether they would like you to keep going.",
          "correct": false,
          "note": "Polite, and it hands them an answer that never landed. They will say yes and remember that you rambled."
        }
      ],
      "explain": "Every long answer to this question dies the same way: the middle eats the ending. When you are over time, cut from the middle, never from the landing."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "three_beats", "label": "Had a shape", "description": "The answer had a beginning, a middle and a landing rather than being a chronology." },
      { "key": "landed_on_them", "label": "Landed on this job", "description": "Finished by connecting the story to the specific role, rather than stopping at the last employer." },
      { "key": "chosen_middle", "label": "Chose the middle", "description": "The examples given resembled the job on the table rather than being whatever came to mind first." },
      { "key": "length", "label": "Kept it short", "description": "Around ninety seconds. Long enough to be substantial, short enough that they wanted to ask a follow-up." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A video call, twelve minutes into a first-round interview for a mid-level role. The small talk is over and the interviewer has just opened a document.",
    "partner": {
      "name": "Dan Whitfield",
      "role": "the hiring manager, who will be your boss if this goes well",
      "personality": "Friendly but efficient. Asks short questions and lets silence do the work. Takes notes while you talk, which is unnerving if you are watching for it.",
      "mood": "Interested. He has read the CV once, this morning, and remembers roughly half of it.",
      "openness": 3
    },
    "opening_beat": "Dan glances at his notes, then back at the camera. \"Right — so before we get into any of the detail, tell me about yourself.\"",
    "success_looks_like": "The user gives a shaped answer with a beginning, a middle and a landing that names this job, in roughly ninety seconds. Dan follows up on something from the middle, which means it was concrete enough to grab.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Reply the way an interviewer does: short acknowledgements, then a follow-up question about something specific the user said.",
      "If the answer runs long or turns into a chronology, do not say so. Ask a narrowing question instead, the way a real interviewer would.",
      "If the answer never explains why this job, ask about something else entirely and leave that gap unfilled.",
      "Do not offer encouragement or feedback on delivery. You are assessing, not teaching."
    ]
  }$j$::jsonb,
  $md$Say your three beats out loud to one real person today — a friend, a partner, a colleague you trust. Do not warn them it is practice first. Then ask them one question: what job did it sound like I was going for? Log what they said, even if the answer was wrong. Especially if it was wrong.$md$
),
(
  (select id from public.skills where slug = 'interview-your-story'),
  2,
  'The landing is the whole answer',
  $md$Two candidates give the same middle. One ends on the last thing they did. The other ends on the job in the room. The second one is remembered as a better candidate, and neither of them ever finds out why.

The landing does something no other part of the answer can. Everything before it is evidence, and evidence does not interpret itself. The interviewer is sitting there quietly asking "so what", and the landing is where you answer that out loud instead of hoping.

A landing has two halves, and skipping either is what makes it feel weak.

**Why this work.** What you are actually reaching for, in plain language. Not a compliment about the company — a direction. "I want to be doing this on a bigger surface" is a direction. "You are the market leader" is flattery, and flattery is free, so it counts for nothing.

**Why here.** One specific thing about this place that could not be said about their nearest competitor. It does not have to be profound. A product decision you noticed, the way the role is written, something the person interviewing you built.

**The move:** finish on why this work and why here, with one detail that could only be about them.

The specific detail is the part people skip, and it is the part that is remembered. Interviewers spend all day being told they are an exciting company. Being told that someone noticed the thing they actually did is rare enough to be worth a note in the margin.

One caution: the landing must be true. A fabricated reason for wanting the job is the single easiest thing to catch, because the follow-up question is always "say more about that", and there is no more.$md$,
  $j$[
    {
      "situation": "Closing a story when applying to a smaller company after years at a large one.",
      "line": "What I want next is to be closer to the decisions. At the last place I was three layers from anyone who could change the roadmap, and I got tired of writing the memo instead of being in the room. You are forty people and the role reports to the person who owns the product, which is the whole reason I applied rather than renewing.",
      "why": "A direction rather than a compliment, and the specific detail is structural — who the role reports to. That is something you can only know if you read the job description properly, and it says so without saying so."
    },
    {
      "situation": "Landing an answer in an interview for a job that is a sideways move rather than a promotion.",
      "line": "So the honest version is that I am not looking to go up a level, I am looking to go across. The bit I am good at is getting a thing from messy to working, and my current role has run out of messy. Your engineering blog post about rebuilding the scheduling system said the quiet part out loud — that it is still half-migrated. That is the job I want.",
      "why": "Names the awkward thing before they can wonder about it, then makes the specific detail do double duty: it proves they researched, and it proves the motivation is real by pointing at the exact mess they want."
    },
    {
      "situation": "A candidate whose real reason for leaving is a bad manager, closing the answer without saying so.",
      "line": "I have learned a lot in the current role and I have stopped learning in it, which is the useful summary. What I am after is somewhere the standard is set by someone I would learn from — and the reason I am sitting here is that two people I trust have both told me, separately, that this is the team where that is true.",
      "why": "True, complete, and gives nothing away. Bitterness about a manager is the most common way this answer goes wrong; the fix is not to lie but to answer at a level where the ugly detail is simply not relevant."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which landing is doing the most work?",
      "options": [
        {
          "text": "And that is why I am really excited about this opportunity — you are doing incredible things in this space.",
          "correct": false,
          "note": "Could be said to any company on earth, which means it says nothing. The word 'excited' is doing all the lifting and it cannot lift."
        },
        {
          "text": "So that brings us up to now, really. That is me.",
          "correct": false,
          "note": "Not a landing at all. It stops the answer without interpreting it, leaving the 'so what' for the interviewer to do."
        },
        {
          "text": "What I want is to own a product rather than a feature, and this is one of about three places hiring for that where the product is something I would use myself.",
          "correct": true,
          "note": "A direction, then a reason that is specific and checkable. 'About three places' quietly signals a considered search rather than a mass application."
        },
        {
          "text": "And I have been following your company for a long time, so this feels like the natural next step for me.",
          "correct": false,
          "note": "Unverifiable and generic. 'Natural next step' is the phrase people reach for when they have not worked out what the step is."
        }
      ],
      "explain": "A landing needs a direction and a detail. Enthusiasm without either is the most common ending there is, and it is why so many good answers are forgettable."
    },
    {
      "prompt": "You want the job mostly because it pays considerably more. What goes in the landing?",
      "options": [
        {
          "text": "Say so. Honesty is disarming and they know money is a factor.",
          "correct": false,
          "note": "It is honest, and it also answers a question nobody asked at the moment least useful to you. Money has its own conversation later, on better terms."
        },
        {
          "text": "Find the true reason underneath it and land on that instead.",
          "correct": true,
          "note": "There is almost always one — more scope, harder problems, a level you have outgrown. The pay is usually a symptom of the thing you actually want, and the thing you actually want is what makes a landing land."
        },
        {
          "text": "Invent a reason about their mission and commit to it.",
          "correct": false,
          "note": "The follow-up is always 'tell me more about that', and there is no more. A landing that cannot survive one question is worse than a plain one."
        }
      ],
      "explain": "You are not required to give every reason. You are required for the one you give to be true, because the next question will test it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "direction", "label": "Named a direction", "description": "Said what they are reaching for, rather than complimenting the company." },
      { "key": "specific_detail", "label": "One detail only about them", "description": "Included something that could not have been said to a competitor." },
      { "key": "truthfulness", "label": "Would survive a follow-up", "description": "The reason given was real enough to expand on if asked." },
      { "key": "clean_finish", "label": "Finished cleanly", "description": "Ended on the landing and stopped, instead of trailing off or restarting." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "An in-person second-round interview, in a meeting room with a whiteboard someone has not wiped. The first fifteen minutes went well.",
    "partner": {
      "name": "Priya Raghunathan",
      "role": "a director two levels above the role, sitting in on the second round",
      "personality": "Warm, and much sharper than the warmth suggests. Follows up on anything vague with 'say more about that', and waits.",
      "mood": "Genuinely curious. She has three of these today and this is the one she has time for.",
      "openness": 4
    },
    "opening_beat": "Priya caps her pen. \"I have read your CV and Dan has given me the summary, so I do not need the whole history. What I want to know is why you are sitting here rather than somewhere else.\"",
    "success_looks_like": "The user gives a direction and one detail that is specifically about this company, and it holds up when Priya asks them to say more.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Whenever the user says something generic or flattering, reply only with a version of 'say more about that' and then wait.",
      "If the user names a specific and true-sounding detail about the company, engage with it as a person would — agree, complicate it, or add context.",
      "Do not accept enthusiasm as an answer. Warmth in your tone, no softening of the question.",
      "Keep your turns to two or three sentences. You are here to listen."
    ]
  }$j$::jsonb,
  $md$Pick a real job advert today — one you would actually apply for. Find one detail in it, or in the company, that could not be said about their competitors. Then say your landing out loud to someone and ask whether it sounded like you had done your homework or like you were being polite. Log it.$md$
),
(
  (select id from public.skills where slug = 'interview-your-story'),
  3,
  'Cut it to ninety seconds',
  $md$Nobody has ever been rejected for a story that was too short.

The reason ninety seconds is the target is not that attention spans are short. It is that an interview is a conversation with a budget, and every second you spend is a second not spent on a question where you could have been more impressive. A four-minute answer to the opener does not just bore them — it eats the part of the hour where you would have shone.

The instinct when cutting is to trim evenly: shave a bit off each part, speak a little faster, drop some adjectives. This produces a compressed version of the same answer, which is worse, because it is now dense as well as long.

Cut whole things instead.

**Drop the second-best example.** Two examples that both prove the same point are one example and a hostage. Keep the one that most resembles the job.

**Drop every job that is not load-bearing.** You are not obliged to mention all of them. "A couple of agency roles before that" covers four years and nobody will stop you.

**Drop the reasons.** Why you left each place, why you took the next one — that is a separate answer, for a question they may not even ask. Explaining transitions unprompted is the single biggest hidden cost in most stories.

**The move:** cut whole items, never words — the second-best example goes first.

The test for whether it worked is not the clock. It is whether the interviewer asks a follow-up. A story that ends with them wanting one specific thing expanded is a story that did its job; you get to talk about your best material as an answer to their question, which lands twice as hard as volunteering it.$md$,
  $j$[
    {
      "situation": "A candidate with eleven years and six employers, compressing the middle.",
      "line": "The first half of my career was agencies — four of them, all much the same, all useful. The part worth talking about started when I went in-house at a retailer in 2019 and inherited a team that had lost three people in a month.",
      "why": "Four jobs disposed of in a clause, with a judgement attached so it does not sound evasive. The interviewer now knows where to ask, and the answer arrives at its best material in fifteen seconds."
    },
    {
      "situation": "Someone who keeps explaining why they left each role.",
      "line": "I moved to the second place for a bigger team, and then—  [stop]. I moved to the second place, and that is where the interesting bit starts.",
      "why": "Transitions are a question, not a duty. Volunteering the reason for each move invites suspicion where none existed, and it is usually where a ninety-second answer becomes a three-minute one."
    },
    {
      "situation": "A candidate deciding between two strong examples for the middle.",
      "line": "I could talk about the migration or the reporting rebuild. The job description mentions data quality twice, so: the reporting rebuild.",
      "why": "The choice is made against the advert, not against pride. The migration might be the better story and the reporting rebuild is the better answer, and those are different things."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Your story runs to two and a half minutes. Which cut buys you the most?",
      "options": [
        {
          "text": "Remove the adjectives and tighten the phrasing throughout.",
          "correct": false,
          "note": "Saves perhaps ten seconds and makes the answer harder to listen to. Density is not brevity."
        },
        {
          "text": "Summarise your first three jobs in one clause.",
          "correct": true,
          "note": "Buys thirty to forty seconds in a single move, and costs nothing — early roles rarely carry the argument for hiring you now."
        },
        {
          "text": "Cut the landing and let the CV explain why you applied.",
          "correct": false,
          "note": "The CV cannot explain that. This is the one part of the answer that nothing else in the process replaces."
        },
        {
          "text": "Talk faster.",
          "correct": false,
          "note": "The answer is the same length. It just sounds nervous now."
        }
      ],
      "explain": "Cuts should remove items, not syllables. One whole job or one whole example is worth more than a page of tightening."
    },
    {
      "prompt": "What is the best sign your story was the right length?",
      "options": [
        {
          "text": "You finished inside ninety seconds.",
          "correct": false,
          "note": "A useful target, but the clock is a proxy. A tight eighty seconds that landed on nothing is still a bad answer."
        },
        {
          "text": "They nodded along throughout.",
          "correct": false,
          "note": "People nod. It is the cheapest signal in an interview and it means only that you are not being unpleasant."
        },
        {
          "text": "They asked you to expand on one specific thing you mentioned.",
          "correct": true,
          "note": "That is the answer working exactly as intended: it left a hook, they took it, and now your best material is a reply rather than a monologue."
        }
      ],
      "explain": "The goal is not to say everything. It is to make them ask."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "length", "label": "Under two minutes", "description": "Finished the answer without being cut off or running out of road." },
      { "key": "whole_cuts", "label": "Cut items, not words", "description": "Compressed by leaving things out entirely rather than by rushing through them." },
      { "key": "no_unprompted_reasons", "label": "Left transitions alone", "description": "Did not explain why they left each role unless asked." },
      { "key": "left_a_hook", "label": "Left something to ask about", "description": "Mentioned something concrete enough that the interviewer wanted it expanded." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A phone screen that started four minutes late. The recruiter has another call at half past and has said so.",
    "partner": {
      "name": "Marcus Aiyegbeni",
      "role": "an internal recruiter running a first screen",
      "personality": "Brisk and likeable. Talks in short sentences and expects the same back. Will interrupt politely if an answer runs long, because his day is stacked.",
      "mood": "Slightly behind schedule and trying not to show it.",
      "openness": 3
    },
    "opening_beat": "\"Thanks for making the time. I have got us until half past, so I will be quick — give me the potted version of your background and what you are looking for.\"",
    "success_looks_like": "The user delivers a story that fits comfortably inside two minutes, skips the early roles, and still lands on why this job. Marcus asks a follow-up rather than moving on.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "If an answer passes roughly two minutes' worth of text, interrupt politely with a narrowing question. Do not explain why.",
      "Speak in short sentences. This is a phone call and you are watching the clock.",
      "Reference the time remaining once, naturally, part-way through.",
      "Do not give feedback on length or delivery at any point."
    ]
  }$j$::jsonb,
  $md$Record yourself telling your story once, on your phone, in one take. Play it back and write down the one thing you would cut. Then tell the cut version to a real person and log whether they asked you a follow-up question.$md$
),
(
  (select id from public.skills where slug = 'interview-your-story'),
  4,
  'A different room, a different version',
  $md$The same story told to a recruiter, a hiring manager and a panel should not be the same story. Not because you are being slippery — because they are asking different questions with the same words.

**A recruiter** is asking: does this person match the brief, and are they normal. They are not equipped to assess your craft and they are usually screening a lot of people. Pitch high, use the words from the advert, keep it short. Detail is a cost here, not a virtue.

**A hiring manager** is asking: what will this person be like to work with on the thing I am currently struggling with. They want the middle beat, they want it concrete, and they want to hear the messy version — what was actually hard.

**A panel or a skip-level** is asking: does this person see the bigger picture, and could they grow. Pitch to scope. The middle beat becomes about the size of what you owned rather than the detail of how you did it.

**The move:** keep the three beats, and change only the middle to fit who is asking.

What must not change is the landing. Your reason for wanting this job should be identical in every room, and if it drifts between conversations you will be caught, because they compare notes — that is what the debrief is.

A last one, cheap and effective: use their vocabulary. If the advert says "partners" rather than "clients", say partners. It is not sycophancy, it is evidence that you can be understood inside their building.$md$,
  $j$[
    {
      "situation": "The same middle beat, told to a recruiter.",
      "line": "The last four years have been platform work — mostly reliability and cost, on a team of about eight. That is the bulk of what your advert describes, which is why I got in touch.",
      "why": "Pitched at the brief, in the brief's own words, in two sentences. A recruiter's job is matching, so make the match easy to see and give them nothing to have to interpret."
    },
    {
      "situation": "The same middle beat, told to the hiring manager.",
      "line": "The messy version is that we were paying about forty per cent more than we needed to and nobody could tell me why, because the tagging had been optional for two years. So the first three months were not engineering at all, it was going service by service and arguing with people about ownership.",
      "why": "Concrete, honest about what was actually hard, and it describes the human part of the work. A hiring manager is imagining you inside their own mess; this is the answer that lets them."
    },
    {
      "situation": "The same middle beat, told to a director in a final round.",
      "line": "I owned the cost line for the platform, which was about a fifth of infrastructure spend, and the part I would do differently is that I fixed it before I fixed the reason it happened. We got the number down and then it drifted back up, because I had not changed how teams shipped.",
      "why": "Scope first, then a genuine reflection about systems rather than tasks. Senior people are listening for whether you see the second-order problem, and volunteering it is far stronger than being asked."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "A recruiter asks for your background. You give them the detailed, technical middle. What has gone wrong?",
      "options": [
        {
          "text": "Nothing — detail proves competence and they will pass it on.",
          "correct": false,
          "note": "They will pass on their notes, and their notes are a summary they were not equipped to make. Detail given to the wrong audience arrives distorted or not at all."
        },
        {
          "text": "You have made them work to see the match, and matching is their entire job.",
          "correct": true,
          "note": "A recruiter is comparing you to a brief. Every sentence they have to translate is a chance the translation loses you."
        },
        {
          "text": "You have spent too long, and length is the main risk on a screen.",
          "correct": false,
          "note": "Length is a real cost, but the deeper problem is the pitch. A short answer aimed at the wrong question still misses."
        }
      ],
      "explain": "Match the altitude of the answer to what the asker can actually assess. Depth to someone who cannot evaluate it is not impressive, it is noise."
    },
    {
      "prompt": "Which part of the story must stay identical in every room?",
      "options": [
        {
          "text": "The opening beat, so the story always starts the same way.",
          "correct": false,
          "note": "It can and often should compress or expand. Nobody compares openings."
        },
        {
          "text": "The examples in the middle, so your account of your work is consistent.",
          "correct": false,
          "note": "Choosing different examples for different audiences is not inconsistency — the facts do not change, only which ones are relevant."
        },
        {
          "text": "The landing — why this work and why here.",
          "correct": true,
          "note": "This is the one they compare in the debrief, and a motivation that shifts between rooms reads as someone telling each person what they want to hear."
        },
        {
          "text": "The length, so nobody feels short-changed.",
          "correct": false,
          "note": "A phone screen and a final round have completely different budgets. Holding the length constant would waste one and blow the other."
        }
      ],
      "explain": "Adapt the evidence, never the motive. The debrief is where those two are checked against each other."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "pitched_right", "label": "Pitched at the asker", "description": "The level of detail matched what this particular person could assess." },
      { "key": "consistent_landing", "label": "Same reason, every room", "description": "The stated motivation would match what they said to anyone else in the process." },
      { "key": "their_words", "label": "Used their vocabulary", "description": "Borrowed the language of the advert or the company rather than translating everything into their own." },
      { "key": "concrete", "label": "Concrete where it counted", "description": "Gave the hiring manager something real and specific rather than a summary." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A final-round conversation with someone senior who was added to the schedule at short notice, and who has not read anything.",
    "partner": {
      "name": "Ruth Okonjo",
      "role": "a department head sitting in on the final round",
      "personality": "Direct, unhurried, and interested in scope rather than technique. Asks 'and how big was that?' a lot. Not impressed by detail for its own sake.",
      "mood": "Neutral and attentive. She was pulled into this twenty minutes ago and is deciding whether it was worth it.",
      "openness": 3
    },
    "opening_beat": "\"I will be honest, I have not read your CV — I was added to this yesterday. So start from the beginning, and tell me what you have actually been responsible for.\"",
    "success_looks_like": "The user gives a version pitched at scope and ownership rather than technique, keeps the same landing they would give anyone else, and does not drown her in detail.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "When an answer goes into technical detail, ask about size, ownership or consequence instead of following the detail.",
      "Do not pretend to have read anything. If the user references something from earlier rounds, ask them to explain it.",
      "Ask 'and what happened after that?' at least once.",
      "Never tell the user which register to use. Let the mismatch stand if there is one."
    ]
  }$j$::jsonb,
  $md$Tell your story twice today to two different people — one who knows your field and one who does not. Change only the middle. Log which version was harder to give, because that is the room you are least ready for.$md$
),
(
  (select id from public.skills where slug = 'interview-your-story'),
  5,
  'Walk me through your CV',
  $md$This is a different question wearing the same coat, and answering it with your prepared story is one of the most common ways a good candidate stumbles.

"Tell me about yourself" wants a shape. "Walk me through your CV" wants a chronology — they are holding the document and following along, and if you jump around they lose their place. Give them the chronology. But give it with a spine.

The spine is one sentence, said before you start: what the whole arc adds up to. "The short version is that I keep ending up as the person who fixes reporting." Then walk the roles, briefly, and every role gets one line about why the move happened. Now the chronology is evidence for a claim rather than a list.

**The move:** state what the arc adds up to, then walk it, giving each move a reason.

Two specific things to prepare, because this is the question where they surface.

**The jumps.** Short stays, sideways moves, a redundancy, a gap. Say them plainly and in the same tone as everything else. The tone is what gets read, not the fact — a nine-month role explained calmly is a nine-month role, and one explained apologetically is a problem.

**The oldest stuff.** Anything more than about eight years back gets a clause, not a paragraph. If they want it, they will stop you, and being stopped is fine.

The interviewer's actual question underneath all this is: does this person's career make sense, and are they telling me the truth about it. Both are answered by tone as much as content.$md$,
  $j$[
    {
      "situation": "Opening the walkthrough with a spine.",
      "line": "Before I start — the through-line is that I have always been the bridge between the technical team and whoever is paying for it. That is true of all four jobs, even though the titles do not look like it. So, starting in 2017…",
      "why": "One sentence that turns a list into an argument. Everything after it is heard as evidence for the claim, including the roles that look unrelated on paper."
    },
    {
      "situation": "Explaining a nine-month role that ended badly.",
      "line": "Then there was nine months at a startup that did not work out — the funding round did not close and the team went from twenty to six. I was in the six for a while, and then I decided I did not want to be. That was the year I learned to ask about runway before signing anything.",
      "why": "Plain, unhurried, and it ends on a judgement rather than a wound. The last sentence quietly turns the shortest role on the CV into the one where they learned something."
    },
    {
      "situation": "Handling a two-year gap for caring responsibilities.",
      "line": "There is a gap from 2021 to 2023 — my father was ill and I was the one nearby, so I stopped working. I kept my hand in with a bit of freelance towards the end. Then back full time from the March.",
      "why": "Three sentences, no apology, no over-explanation. A gap becomes a problem when it is presented as one; stated as a fact with a date on either side, it almost always passes without comment."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "They ask you to walk through the CV. What should the first sentence be?",
      "options": [
        {
          "text": "The claim your whole CV adds up to.",
          "correct": true,
          "note": "It turns the walk into evidence. Without it you are reading out a list they can already see, and they are the ones holding the list."
        },
        {
          "text": "Your current role, since it is the most relevant.",
          "correct": false,
          "note": "That answers a different question. They asked for the walk because they want the sequence, and starting at the end makes them work backwards."
        },
        {
          "text": "Your first job, since that is where the chronology starts.",
          "correct": false,
          "note": "It is where the chronology starts and it is the least useful thing on the page. Get there, but not first and not for long."
        }
      ],
      "explain": "A chronology without a spine is a list. The spine costs one sentence and changes how everything after it is heard."
    },
    {
      "prompt": "There is an eighteen-month gap on your CV. When should you mention it?",
      "options": [
        {
          "text": "Only if they ask. Volunteering it draws attention to it.",
          "correct": false,
          "note": "They have the document in front of them. Walking past a visible gap in silence is the thing that draws attention, and it reads as hoping they missed it."
        },
        {
          "text": "When you reach it, in the same tone as everything else.",
          "correct": true,
          "note": "It is a date on a page. Said in the same voice as the rest, it is a fact; saved for later or hurried past, it becomes a subject."
        },
        {
          "text": "At the start, so it is out of the way.",
          "correct": false,
          "note": "Front-loading it gives it a weight it does not have. It is not the headline of your career unless you make it one."
        },
        {
          "text": "At the end, once you have built enough credibility to absorb it.",
          "correct": false,
          "note": "This treats it as a debt to be covered. By then they have been waiting for it for ten minutes, which is worse than the gap."
        }
      ],
      "explain": "Tone carries this question, not content. The same eighteen months is either a fact or a problem depending entirely on how it is said."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "spine", "label": "Gave it a spine", "description": "Opened with what the whole arc adds up to, before walking the roles." },
      { "key": "reasons_for_moves", "label": "Explained the moves", "description": "Each transition had a short reason, so the sequence read as decisions rather than drift." },
      { "key": "awkward_facts", "label": "Handled the awkward parts plainly", "description": "Gaps, short stays and sideways moves stated in the same tone as everything else." },
      { "key": "proportion", "label": "Weighted it correctly", "description": "Recent and relevant roles got the time; the oldest ones got a clause." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "An interview room with a printed CV on the table between you, visibly annotated in two colours.",
    "partner": {
      "name": "Ian Beattie",
      "role": "a hiring manager who reads CVs carefully and marks them up",
      "personality": "Methodical and quietly friendly. Follows the page with a pen, and stops you at anything he has circled. Not hostile — genuinely curious about the joins.",
      "mood": "Focused. He has already spotted the two things he intends to ask about.",
      "openness": 3
    },
    "opening_beat": "Ian turns the CV around so you can both see it and taps the top of the page with his pen. \"Take me through it. Start wherever you like, but I would like to understand the joins.\"",
    "success_looks_like": "The user opens with a through-line, walks the roles in order with a reason for each move, and handles any short stay or gap in the same tone as the rest.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Invent one plausible awkward detail from the user's account — a short stay, a sideways move, a gap — and ask about it once, neutrally.",
      "If the user rushes or apologises for something, do not reassure them. Ask one plain follow-up question and move on.",
      "Interrupt gently if they spend too long on the earliest roles: 'let us get to the recent stuff'.",
      "Never comment on how they are presenting themselves."
    ]
  }$j$::jsonb,
  $md$Print or open your CV and walk someone through it out loud, top to bottom, giving a reason for every move. Ask them afterwards which join sounded weakest. Log what they said — that is the one you will be asked about.$md$
);
