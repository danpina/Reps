-- Track 7: Reading disinterest & backing off. Taught as a skill in its own
-- right. Someone who can read a no accurately is both more effective and far
-- less likely to make anyone uncomfortable.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, check_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'reading-disinterest'),
  1,
  'The three signals',
  $md$This is a skill, not a warning label. Being able to tell when someone is not interested is what makes the rest of it safe to practise, and it is also what makes you better company.

Three signals, and it is the combination that matters rather than any one alone.

**Short answers that do not open.** Not brevity itself — some people are brief and engaged. The tell is answers with no handle on them, nothing offered for you to pick up.

**No reciprocal questions.** Over several minutes, an interested person almost always becomes curious. Sustained absence of any question back is the single most reliable signal there is.

**Closed or oriented away.** Body angled towards the exit, phone in hand, scanning the room over your shoulder.

**The move:** count the signals rather than interpreting any one of them.

One signal means nothing; people are tired and distracted. Two is worth noticing. Three at once is a clear answer, and reading it correctly is a kindness to both of you.$md$,
  $j$[
    {
      "situation": "You ask about their weekend and they say it was fine, thanks.",
      "line": "(one signal — not yet conclusive)",
      "why": "A closed answer on its own means very little. They might be tired, distracted, or simply not a talker. Keep reading."
    },
    {
      "situation": "Ten minutes in, they have asked you nothing at all and their answers stay short.",
      "line": "(two signals — start winding down)",
      "why": "Absence of curiosity plus closed answers is a real pattern. This is the point to begin easing out rather than trying harder."
    },
    {
      "situation": "Short answers, no questions, and they are angled towards their friends across the room.",
      "line": "(three signals — exit warmly now)",
      "why": "This is an answer. Noticing it now means you leave gracefully instead of being endured."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Which single signal is the most reliable indicator of disinterest?",
    "options": [
      {
        "text": "Short answers.",
        "correct": false,
        "note": "Too easily explained by personality or tiredness. Plenty of engaged people are brief."
      },
      {
        "text": "Checking their phone.",
        "correct": false,
        "note": "Very common and very weakly informative on its own. People check phones out of habit mid-conversation."
      },
      {
        "text": "No reciprocal questions over several minutes.",
        "correct": true,
        "note": "Interest reliably produces curiosity. Sustained absence of any question back is the hardest signal to explain away."
      },
      {
        "text": "Not laughing at your jokes.",
        "correct": false,
        "note": "Says more about the match of humour than about interest. Some of the driest people are the most engaged."
      }
    ],
    "explain": "Curiosity is the tell. Someone interested in you will eventually ask you something; someone who never does has told you."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "counted_signals", "label": "Counted rather than guessed", "description": "Looked for a combination of signals rather than reading everything into one." },
      { "key": "noticed_no_questions", "label": "Noticed the absence of curiosity", "description": "Registered whether the partner asked anything back over several minutes." },
      { "key": "did_not_catastrophise", "label": "Did not over-read a single signal", "description": "Avoided treating one short answer as a verdict." },
      { "key": "acted_in_time", "label": "Acted while it was still graceful", "description": "Began easing out at two signals rather than waiting to be endured." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A networking event in a hotel function room. You have approached someone standing near the edge of the room.",
    "partner": {
      "name": "Bram",
      "role": "another attendee",
      "personality": "Polite but genuinely not interested in talking. Never rude, never explicit, and shows it entirely through short answers and absence of curiosity.",
      "mood": "Waiting for a colleague, keeping an eye on the door.",
      "openness": 1
    },
    "opening_beat": "Bram answers your opening remark with a polite, complete, closed sentence, and looks back towards the door.",
    "success_looks_like": "The user counts the signals over a few turns, recognises the pattern, and starts winding the conversation down warmly rather than working harder.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Hold openness 1 absolutely. Never ask the user a question. Keep every answer short, polite and closed.",
      "Do not become warmer no matter how interesting or charming the user is. This is not a puzzle to be solved.",
      "If the user begins to exit warmly, be genuinely pleasant and let the conversation end well."
    ]
  }$j$::jsonb,
  $md$Today, notice one conversation where the signals were not there. Count them honestly. Log which signals you saw and what you did about it.$md$
),
(
  (select id from public.skills where slug = 'reading-disinterest'),
  2,
  'Drop a register',
  $md$When you read disinterest, the response is not to leave immediately and it is not to try harder. It is to drop a register.

Dropping a register means returning the conversation to the level of warmth that is clearly welcome. From personal back to friendly. From friendly back to civil. You are not withdrawing or punishing, you are simply matching what is on offer.

**The move:** step down one level and stay pleasant there.

Two reasons this is better than leaving on the spot. It removes the pressure immediately, which is the thing they actually wanted, and quite often the conversation improves once it does, because the discomfort was the problem rather than you.

And it costs you nothing. A friendly two minutes with someone who does not want to flirt with you is a perfectly good outcome. Treating it as a defeat is what turns a neutral moment into a bad one.$md$,
  $j$[
    {
      "situation": "You made a warm remark and they answered the factual part only.",
      "line": "(return to ordinary friendly conversation, same energy, no visible change)",
      "why": "The step down should be invisible. If they can see you adjusting, they have to manage your feelings about it."
    },
    {
      "situation": "You have dropped a register and the conversation has relaxed noticeably.",
      "line": "(stay here — this is a good place)",
      "why": "Very common. The pressure was the issue, and with it gone you get a genuinely pleasant conversation."
    },
    {
      "situation": "You dropped a register and they are still giving closed answers.",
      "line": "(drop one more, and start thinking about a warm exit)",
      "why": "If civil-and-friendly is still not landing, the answer is about the conversation itself rather than its temperature."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "You have read disinterest correctly. What is the best immediate response?",
    "options": [
      {
        "text": "Return to ordinary friendly conversation without commenting on it.",
        "correct": true,
        "note": "Removes the pressure instantly, requires nothing from them, and often produces a genuinely good conversation once the tension is gone."
      },
      {
        "text": "Leave straight away.",
        "correct": false,
        "note": "An abrupt exit makes the reason obvious and asks them to feel responsible. Wind down rather than cut off."
      },
      {
        "text": "Ask whether you have misread the situation.",
        "correct": false,
        "note": "Forces them to say no out loud, which is exactly the discomfort the whole approach exists to avoid."
      },
      {
        "text": "Stay at the same level but be funnier.",
        "correct": false,
        "note": "Trying harder after a signal to stop is how a polite no becomes an uncomfortable one."
      }
    ],
    "explain": "Step down quietly. The point is to remove the pressure without either of you having to acknowledge that it existed."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "stepped_down", "label": "Dropped a register", "description": "Returned to the level of warmth that was clearly welcome." },
      { "key": "was_invisible", "label": "Made the adjustment invisible", "description": "Stepped down without the partner having to notice or manage it." },
      { "key": "stayed_warm", "label": "Stayed genuinely friendly", "description": "Did not become cold, clipped or visibly withdrawn." },
      { "key": "no_explanation", "label": "Did not name it", "description": "Avoided asking about or commenting on the change." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A wedding reception, the long gap between the meal and the dancing. You are at a table with someone you were seated next to.",
    "partner": {
      "name": "Odile",
      "role": "another guest, seated beside you",
      "personality": "Perfectly happy to talk, entirely uninterested in being flirted with. Becomes noticeably warmer and funnier once the register drops to friendly.",
      "mood": "Enjoying the wedding, glad of the company at the table.",
      "openness": 3
    },
    "opening_beat": "Odile responds to your last warm comment with a brief, polite answer and turns her attention to the table.",
    "success_looks_like": "The user drops a register without announcing it, and the conversation becomes genuinely enjoyable at the friendly level.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Respond to any personal warmth with brief, polite, closed answers.",
      "Respond to ordinary friendly conversation with real warmth, humour and curiosity.",
      "Never explain the difference or comment on the change."
    ]
  }$j$::jsonb,
  $md$Today, drop a register in one conversation where the warmth was not matched. Stay friendly. Log what changed after you did.$md$
),
(
  (select id from public.skills where slug = 'reading-disinterest'),
  3,
  'The graceful exit',
  $md$Leaving a conversation that is not working is a specific skill, and doing it well matters more than most people realise.

The bad exits are all recognisable. Trailing off and standing there. Waiting for them to end it. Leaving abruptly the moment you get the message, which makes the reason unmistakable. Each puts the other person in the position of having to manage the ending.

**The move:** end it yourself, warmly, before it becomes uncomfortable, and give a reason that has nothing to do with them.

*I am going to go and find a drink. Good to meet you.* The reason is neutral, the warmth is real, and you are the one leaving. That last part is what makes it graceful: they never had to end it, so nobody has to feel they were escaped from.

Leaving first when it is not working is not a defeat. It is the most considerate available move, and it is also the one that leaves you looking most at ease.$md$,
  $j$[
    {
      "situation": "Two signals read, conversation clearly not going anywhere.",
      "line": "I am going to go and say hello to a few people. Good to meet you.",
      "why": "Neutral reason, warm close, and you are the one ending it. Nothing here implies anything went wrong."
    },
    {
      "situation": "A group conversation you joined has not really included you.",
      "line": "I will leave you to it. Enjoy the rest of your evening.",
      "why": "Acknowledges the group has its own thing going on without a trace of resentment. Leave you to it is warm rather than pointed."
    },
    {
      "situation": "Someone has been polite but disengaged for several minutes.",
      "line": "Right, I am going to get another one of these. Nice talking to you.",
      "why": "The most useful exit line there is. Practical, cheerful, and entirely unrelated to them."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "What makes an exit graceful rather than awkward?",
    "options": [
      {
        "text": "Explaining that you can tell they are busy.",
        "correct": false,
        "note": "Names the thing you were both politely not naming, and asks them to reassure you on the way out."
      },
      {
        "text": "Waiting for them to end it so you are not the one leaving.",
        "correct": false,
        "note": "Puts the work on them and usually means the conversation runs past the point of comfort."
      },
      {
        "text": "You end it, warmly, with a reason unrelated to them.",
        "correct": true,
        "note": "They never have to end it and nothing implies fault. A neutral reason keeps the exit clean for both of you."
      },
      {
        "text": "Leaving quickly as soon as you realise.",
        "correct": false,
        "note": "The abruptness announces the reason. Wind down over a few seconds instead of cutting."
      }
    ],
    "explain": "Be the one who leaves, be warm about it, and give a reason that has nothing to do with them."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "left_first", "label": "Ended it themselves", "description": "Took responsibility for closing rather than waiting to be released." },
      { "key": "neutral_reason", "label": "Gave a neutral reason", "description": "Offered a reason unconnected to the other person or the conversation." },
      { "key": "stayed_warm", "label": "Left warmly", "description": "The exit was friendly rather than clipped, cold or apologetic." },
      { "key": "good_timing", "label": "Left before it got uncomfortable", "description": "Exited at the right moment rather than well past it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A crowded launch party. You have been talking to someone for about five minutes and it has not taken off.",
    "partner": {
      "name": "Petra",
      "role": "someone you started talking to near the bar",
      "personality": "Civil and unforthcoming. Not hostile, just clearly elsewhere. Responds well and warmly to a clean exit.",
      "mood": "Distracted, waiting for someone.",
      "openness": 2
    },
    "opening_beat": "Petra gives another short answer and glances past you towards the entrance.",
    "success_looks_like": "The user exits warmly and on their own initiative, with a neutral reason, and Petra responds pleasantly.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Keep answers short and polite. Never ask a question. Do not warm up during the conversation.",
      "If the user offers a warm exit with a neutral reason, respond with genuine friendliness and wish them well.",
      "If the user keeps trying to revive the conversation, become slightly more distracted."
    ]
  }$j$::jsonb,
  $md$Today, be the one who ends a conversation that is not working. Warm close, neutral reason. Log how it felt to leave first.$md$
),
(
  (select id from public.skills where slug = 'reading-disinterest'),
  4,
  'No sulking',
  $md$What happens in the ten seconds after a no is the part people actually remember.

A visible drop in warmth, a slightly clipped goodbye, a joke with an edge on it — all of these communicate that your friendliness was conditional. That is the thing that makes someone uncomfortable, and it is what they will recall about the encounter. The no itself was nothing.

**The move:** keep your warmth exactly where it was, including after you have decided to leave.

This is genuinely hard, because being turned down produces a small sting and the sting wants expression. The discipline is to notice it and let the last thirty seconds be as friendly as the first thirty.

There is a selfish argument as well as a decent one. People talk, rooms are small, and the person who is warm on the way out is remembered as easy company. But the decent argument is enough on its own: they did nothing wrong by not being interested, and they should not have to pay for it.$md$,
  $j$[
    {
      "situation": "You have just read a clear no and are winding down.",
      "line": "(same smile, same tone, same warmth as five minutes ago)",
      "why": "Consistency is the whole thing. If your warmth does not change, nothing awkward has happened."
    },
    {
      "situation": "You feel the sting and notice yourself about to go flat.",
      "line": "(notice it, and do not act on it)",
      "why": "The feeling is normal. Expressing it is the error, and the gap between those two is entirely within your control."
    },
    {
      "situation": "They say something friendly as you are leaving.",
      "line": "(respond as warmly as you would have at the start)",
      "why": "The last exchange is what gets remembered. Answering warmly here is what makes the whole encounter a good one for them."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "Why does keeping your warmth constant after a no matter so much?",
    "options": [
      {
        "text": "It might make them reconsider.",
        "correct": false,
        "note": "This treats graciousness as a further tactic, which is the opposite of the point. Warmth offered to change a no is not warmth."
      },
      {
        "text": "It shows your friendliness was not conditional on getting something.",
        "correct": true,
        "note": "This is what people actually register. A drop in warmth retroactively reveals the earlier warmth as a transaction."
      },
      {
        "text": "It stops the conversation from ending.",
        "correct": false,
        "note": "The conversation should end. Warmth is about how it ends, not about extending it."
      },
      {
        "text": "It makes you look confident.",
        "correct": false,
        "note": "It does, and that is a side effect. Doing it for the appearance tends to produce a visibly performed version."
      }
    ],
    "explain": "A drop in warmth after a no tells them the warmth was payment for something. That is the part people remember."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "warmth_held", "label": "Kept warmth constant", "description": "The last thirty seconds were as friendly as the first thirty." },
      { "key": "no_edge", "label": "No edge in the exit", "description": "No clipped tone, pointed joke or visible withdrawal." },
      { "key": "felt_it_without_showing", "label": "Noticed the sting without acting on it", "description": "Registered the disappointment privately rather than expressing it." },
      { "key": "left_them_comfortable", "label": "Left them comfortable", "description": "The partner was not made to feel responsible for the outcome." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A climbing gym. You have been chatting to someone between routes and have just suggested getting a coffee sometime.",
    "partner": {
      "name": "Mira",
      "role": "someone you have spoken to a few times at this gym",
      "personality": "Kind and direct. Says no clearly and without unnecessary softening, then genuinely wants the friendliness to continue.",
      "mood": "Warm, mid-session, entirely comfortable.",
      "openness": 3
    },
    "opening_beat": "Mira says thanks, but she is not really looking for that at the moment, and then asks how your last route went.",
    "success_looks_like": "The user takes the no without any drop in warmth and answers her follow-up question as warmly as they would have before.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Decline clearly and kindly, then immediately continue the conversation as normal.",
      "If the user stays warm, be relaxed and friendly and keep chatting happily.",
      "If the user becomes clipped, flat or pointed, become noticeably more guarded and wind the conversation down."
    ]
  }$j$::jsonb,
  $md$Today, notice a moment where something did not go your way socially, and keep your warmth exactly where it was. Log what you felt and what you did.$md$
),
(
  (select id from public.skills where slug = 'reading-disinterest'),
  5,
  'When you genuinely cannot tell',
  $md$Sometimes the signals are mixed. Warm answers but no questions. Staying, but oriented away. You have counted and the count comes out ambiguous.

The instinct is to keep going until it resolves, which means continuing to apply warmth until the picture gets clearer. That is the wrong response, because the person doing the resolving is them, and you are asking them to do it under pressure.

**The move:** when you cannot tell, treat it as a no and stay friendly.

This is not pessimism. It is that the cost of the two errors is not symmetric. Treating a maybe as a no costs you a possibility. Treating a maybe as a yes costs them an uncomfortable few minutes and puts them in the position of having to be explicit. One of those is much worse than the other, and it is not the one you feel most.

There is also a practical point. Genuine interest usually becomes unambiguous if you give it room. If it stays ambiguous after you have stopped pushing, that ambiguity was the answer.$md$,
  $j$[
    {
      "situation": "Warm answers but not a single question back after ten minutes.",
      "line": "(treat it as a no, stay friendly, enjoy the conversation)",
      "why": "The mixed picture resolves in favour of caution, and the conversation is still perfectly good at friendly."
    },
    {
      "situation": "You dropped a register and they got noticeably warmer.",
      "line": "(that is your answer — this is a good conversation, not a mutual attraction)",
      "why": "Warming up once the pressure lifts is one of the clearest signals available, and it is frequently misread as encouragement."
    },
    {
      "situation": "They are giving genuinely mixed signals and you catch yourself building a case for the optimistic reading.",
      "line": "(notice that you are arguing with the evidence)",
      "why": "Constructing an argument for interest is itself a reliable sign it is not there. Real interest does not usually require a case."
    }
  ]$j$::jsonb,
  $j${
    "prompt": "The signals are genuinely ambiguous. What is the right default and why?",
    "options": [
      {
        "text": "Treat it as a yes, since you will regret not trying.",
        "correct": false,
        "note": "Weighs your possible regret above their possible discomfort. The person carrying the cost of that choice is not you."
      },
      {
        "text": "Ask them directly to clear it up.",
        "correct": false,
        "note": "Resolves your uncertainty by making them state it out loud, which is the discomfort you were trying to spare them."
      },
      {
        "text": "Treat it as a no and stay friendly, because the two errors do not cost the same.",
        "correct": true,
        "note": "A wrong no costs you a possibility. A wrong yes costs them an uncomfortable exchange and forces them to be explicit."
      },
      {
        "text": "Keep escalating slowly until it becomes clear.",
        "correct": false,
        "note": "This is applying pressure until someone resolves it, and the someone is them."
      }
    ],
    "explain": "The two mistakes are not equally costly, and the more expensive one is not the one you feel. Ambiguity resolves to no."
  }$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "defaulted_to_no", "label": "Defaulted to no", "description": "Treated genuine ambiguity as a no rather than as an invitation to continue." },
      { "key": "stayed_friendly", "label": "Stayed friendly anyway", "description": "Kept the conversation warm and enjoyable at the friendly level." },
      { "key": "noticed_the_argument", "label": "Noticed wishful reading", "description": "Caught themselves building a case for the optimistic interpretation." },
      { "key": "no_pressure_to_resolve", "label": "Did not push for clarity", "description": "Avoided making the partner state their position explicitly." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A pub quiz. You have been on the same impromptu team all evening with someone you have just met.",
    "partner": {
      "name": "Alex",
      "role": "someone who joined the same team tonight",
      "personality": "Naturally warm and physically friendly with everyone, which makes the signals genuinely hard to read. Interested in the evening, not in the user.",
      "mood": "Having a great time, on good form.",
      "openness": 4
    },
    "opening_beat": "Alex is laughing, leaning in to hear over the noise, and has just called you the best thing about this team.",
    "success_looks_like": "The user reads the ambiguity honestly, notices the absence of reciprocal curiosity, defaults to no, and keeps the evening enjoyable.",
    "constraints": [
      "Stay in character. Never coach, evaluate or break the scene.",
      "Be warm, physically close and complimentary throughout. This is simply how you are with everyone.",
      "Never ask the user a personal question, and never respond to personal warmth with anything more than general friendliness.",
      "If the user keeps it friendly, have a great evening with them. If they escalate, become briefly awkward and turn to the rest of the team."
    ]
  }$j$::jsonb,
  $md$Today, find one situation you genuinely could not read, and default to no while staying warm. Log the signals that were mixed and what you decided.$md$
);
