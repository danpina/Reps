-- Dating apps, track 3: From match to a date. The middle nobody teaches, and
-- the only outcome the topic exists for.
--
-- Every drill here is a line drill or a choice, which is unusually honest for
-- this app: everywhere else typing stands in for speaking and something is
-- lost. Here the medium is already text, so a drill that asks you to write a
-- message is asking for exactly the thing you will actually do.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'match-to-date'),
  1,
  'Answer, then ask',
  $md$Conversations on apps die early or they do not die at all. If it is still going after three exchanges each, it will usually keep going — which means the first three carry the entire thing, and they are the ones people improvise.

There is a mechanic underneath, and it is small enough to hold.

**The move:** answer what they asked, then hand something back.

Both halves. Answering with no question at the end is a dead end wearing good manners — they now have to invent the next subject on their own, and after two of those they stop bothering. Asking with no answer is an interview, and it reads as somebody processing you rather than talking to you.

The handing-back does not have to be a question, and this is the bit worth knowing. A statement with an obvious gap in it works just as well and is far less formal. *I have opinions about that which are probably not defensible* is not a question and there is only one possible reply to it.

Match their length. Whatever they wrote is the register they have chosen; a three-line answer to a one-line message reads as effort, and effort this early is a signal about you rather than about them. Short, warm, answered, handed back.

If you are quiet, this is the good news: the whole thing is a two-part shape you can apply without being quick. There is no timing to get right and no room to read. Just do not leave the ball on their side of the net twice in a row.$md$,
  $j$[
    {
      "situation": "They asked what made you pick that photo, and you answered.",
      "line": "(now hand something back)",
      "why": "An answer with nothing on the end is a dead end wearing good manners. They have to invent the next subject alone, and after two of those they stop."
    },
    {
      "situation": "You are about to ask a second question without answering theirs.",
      "line": "(answer first — otherwise it is an interview)",
      "why": "Questions with no answers read as somebody processing you. Two people can trade questions for a whole day and learn nothing about each other."
    },
    {
      "situation": "You want to hand something back without asking anything.",
      "line": "I have opinions about that which are probably not defensible.",
      "why": "Not a question, and there is exactly one possible reply. A statement with a gap in it does the same job far less formally."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does a perfectly good answer with no question on the end kill it?",
      "options": [
        { "text": "It looks like you are not interested.", "correct": false, "note": "Sometimes read that way, and the real problem is mechanical rather than emotional." },
        { "text": "It is too short.", "correct": false, "note": "Short is good here. Length is not what makes a message a dead end." },
        { "text": "They have to invent the next subject on their own.", "correct": true, "note": "You have handed them the whole job. After two of those, most people quietly stop — not out of disinterest but because it became work." },
        { "text": "It breaks the rhythm.", "correct": false, "note": "Vague. Name the actual cost: somebody now has to think of something from nothing." }
      ],
      "explain": "Answer, then hand something back. Never leave the ball on their side twice running."
    },
    {
      "prompt": "What can you hand back other than a question?",
      "options": [
        { "text": "A statement with an obvious gap in it.", "correct": true, "note": "I have opinions about that which are probably not defensible has exactly one reply, and it is far less formal than an interrogative." },
        { "text": "A compliment.", "correct": false, "note": "Pleasant and closed. The only reply available is thank you, which is the same dead end in nicer clothes." },
        { "text": "A joke.", "correct": false, "note": "Fine if you have one, and it depends entirely on their wit to continue. A gap does not." },
        { "text": "Nothing — a question is the only way.", "correct": false, "note": "This is what turns app conversations into questionnaires. There are other shapes." }
      ],
      "explain": "A gap works as well as a question mark and costs less formality."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "answered", "label": "Answered what was asked", "description": "Dealt with their message before adding anything." },
      { "key": "handed_back", "label": "Handed something back", "description": "Left a question or an obvious gap rather than a dead end." },
      { "key": "length", "label": "Matched their length", "description": "Wrote at the register they had chosen." },
      { "key": "warm", "label": "Sounded like a person", "description": "Kept it warm rather than efficient." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Two messages in. Their profile had a bike loaded with panniers and a very flat sourdough loaf, and you asked about the bread.",
    "partner": {
      "name": "Sena",
      "role": "a match, two messages in",
      "personality": "Dry and quick. Keeps going as long as there is something to reply to, and gets briefer each time a message arrives with nothing on the end of it.",
      "mood": "On the app in the evenings, not desperately.",
      "openness": 4,
      "sex": "female",
      "alt": {
        "name": "Senan",
        "role": "a match, two messages in",
        "personality": "Dry and quick. Keeps going as long as there is something to reply to, and gets briefer each time a message arrives with nothing on the end of it.",
        "mood": "On the app in the evenings, not desperately.",
        "openness": 4,
        "sex": "male"
      }
    },
    "opening_beat": "\"ha, it was genuinely inedible. what made you ask about the bread and not the bike?\"",
    "success_looks_like": "The user answers the question and leaves something to reply to.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Write the way people write on apps: short, lowercase-ish, no paragraphs.",
      "Reply fully to anything with a question or a gap in it, and get noticeably shorter after a dead end.",
      "Never rescue a dead end by inventing a new subject."
    ]
  }$j$::jsonb,
  $md$Today, reply to one message by answering it and leaving something on the end. Log what you handed back.$md$
),
(
  (select id from public.skills where slug = 'match-to-date'),
  2,
  'Get out of the interview',
  $md$Two people trade facts. What do you do, where are you from, how long have you lived here, do you like your job. Everybody is polite, nobody is rude, and after twenty messages you have a complete profile of somebody you feel absolutely nothing about.

This is the commonest way a match dies, and it does not look like failure while it is happening. That is what makes it dangerous — an interview feels like a conversation going fine.

The reason it dies is that facts are not information about a person. *I work in logistics* tells you nothing; *I work in logistics and I have strong views about how badly this city does roundabouts* tells you what somebody is like. The first is a data point and the second is a person, and only one of them can be liked.

**The move:** stop supplying data and start supplying reactions.

An opinion, a small story, something you found funny, something that annoys you. Answer the question and then say what you actually think about the thing you just answered. That single addition converts every dull exchange in the list above.

Do not mirror the interview back. *What about you?* is the reflex, and it keeps the format running — you both stay in the questionnaire, being agreeable, learning nothing. Break the format instead: react, and let them react to your reaction.

For a quiet person there is a specific trap here. Interviews feel safe because facts cannot be judged, and safety is what is doing the killing. Nobody has ever disliked you for saying you have opinions about roundabouts.$md$,
  $j$[
    {
      "situation": "\"So what do you do?\"",
      "line": "Spreadsheets, technically. Mostly I argue with people who want the spreadsheet to say something else.",
      "why": "The fact, then the reaction. The second half is the only part that tells them what you are like, and it is the only part they can reply to."
    },
    {
      "situation": "You have answered and are about to write what about you.",
      "line": "(that keeps the questionnaire running)",
      "why": "Mirroring the interview back is the reflex that makes both of you stay polite and learn nothing. React instead, and let them react to that."
    },
    {
      "situation": "The exchange has been pleasant and completely flat for eight messages.",
      "line": "(say something you actually think)",
      "why": "Nothing is wrong and nothing is happening. Facts are safe, which is precisely what is killing it — a person cannot be liked until they have shown up."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is the interview so dangerous?",
      "options": [
        { "text": "It is rude.", "correct": false, "note": "It is impeccably polite. That is the problem." },
        { "text": "It takes too long.", "correct": false, "note": "Speed is not the issue. A fast interview dies exactly the same way." },
        { "text": "People run out of questions.", "correct": false, "note": "They rarely do. There are infinite facts, which is why this can go on for twenty messages." },
        { "text": "It feels like a conversation going fine.", "correct": true, "note": "Nothing signals failure while it is happening, so nobody changes course. You end up with a complete profile of somebody you feel nothing about." }
      ],
      "explain": "Polite, endless and inert. An interview is what a dying match looks like from inside."
    },
    {
      "prompt": "They asked what you do. What turns the answer into a person?",
      "options": [
        { "text": "Making the job sound more interesting.", "correct": false, "note": "Still a fact, now with better packaging. Nothing in it can be liked or argued with." },
        { "text": "Adding what you actually think about it.", "correct": true, "note": "The fact is a data point; the reaction is a person. Strong views about roundabouts tell them more than the job title ever will." },
        { "text": "Asking what they do.", "correct": false, "note": "The reflex, and it keeps the questionnaire running. You both stay agreeable and learn nothing." },
        { "text": "Being self-deprecating about it.", "correct": false, "note": "One available reaction among many, and it becomes a tic fast. Any real reaction beats a modest one." }
      ],
      "explain": "Answer, then say what you think about your own answer."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "reaction", "label": "Supplied a reaction", "description": "Added an opinion, a story or a feeling to the fact." },
      { "key": "no_mirror", "label": "Did not mirror the question", "description": "Avoided handing the same interview question straight back." },
      { "key": "specific", "label": "Was specific", "description": "Named the actual thing rather than gesturing at having views." },
      { "key": "light", "label": "Kept it light", "description": "Reacted in a sentence rather than a paragraph." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Six messages in. It has been friendly, correct and completely flat — jobs, areas, how long you have each lived here.",
    "partner": {
      "name": "Marta",
      "role": "a match, several polite messages in",
      "personality": "Perfectly nice and stuck in interview mode. Keeps asking factual questions until somebody says something with an opinion in it, then comes alive.",
      "mood": "Pleasant, slightly bored, would not be able to say why.",
      "openness": 4,
      "sex": "female",
      "alt": {
        "name": "Marek",
        "role": "a match, several polite messages in",
        "personality": "Perfectly nice and stuck in interview mode. Keeps asking factual questions until somebody says something with an opinion in it, then comes alive.",
        "mood": "Pleasant, slightly bored, would not be able to say why.",
        "openness": 4,
        "sex": "male"
      }
    },
    "opening_beat": "\"so what do you do?\"",
    "success_looks_like": "The user answers and adds a real reaction rather than mirroring the question back.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Write the way people write on apps: short, lowercase-ish, no paragraphs.",
      "Answer a mirrored question with another factual question, keeping the interview running.",
      "Come alive and react properly the moment the user says something with an opinion in it."
    ]
  }$j$::jsonb,
  $md$Today, answer one question and then say what you actually think about your own answer. Log the fact and the reaction.$md$
),
(
  (select id from public.skills where slug = 'match-to-date'),
  3,
  'Move before it fades',
  $md$Nothing happens on the app. That is not a slogan, it is the arithmetic: every message spends a little of the interest that brought you together, and none of them replace it.

A match arrives with a fixed amount of curiosity in it. Good exchanges convert some of that into wanting to meet. Bad exchanges burn it. But even good ones burn it slowly, because familiarity without presence flattens — by message sixty you are not two people about to meet, you are pen pals, and pen pals do not become dates. They fade, politely, usually without either person deciding to.

**The move:** propose after a few days of it going well, not a fortnight.

The signal to look for is not a feeling of certainty. It is simply that the conversation is working — you have both written more than one line, something has been funny, and neither of you is the only one asking. That is the moment. It will not improve by waiting, and waiting is not doing anything to earn the right.

The wait is almost always about you rather than about readiness: another few days feels safer because nothing has been risked yet. But the risk does not shrink, it just gets more expensive — the message you are dreading is easier to send today than it will be on Friday, because on Friday you will also have to explain the gap.

Two exceptions worth naming. Somebody who never moves off the app after several days of good conversation may not intend to, and that is worth knowing early rather than in three weeks. And if they propose first, say yes and stop negotiating.$md$,
  $j$[
    {
      "situation": "Three days of good exchanges. You are waiting for a better moment.",
      "line": "(this is it — the conversation working is the signal)",
      "why": "There is no feeling of certainty coming. Waiting does not earn the right and it does not improve the odds; it only spends what the match arrived with."
    },
    {
      "situation": "It has been two weeks and you talk every day.",
      "line": "(you are pen pals — propose today)",
      "why": "Familiarity without presence flattens. Nobody decides to stop; it just quietly becomes something that was never going to happen."
    },
    {
      "situation": "They have suggested meeting.",
      "line": "(say yes, and stop negotiating)",
      "why": "The hard part has been done for you. Improving their plan is how a yes turns back into a conversation about scheduling."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What tells you it is time to propose something?",
      "options": [
        { "text": "The conversation is simply working.", "correct": true, "note": "Both writing more than one line, something has been funny, neither of you doing all the asking. There is no stronger signal coming, and waiting for one spends the match." },
        { "text": "You feel certain about them.", "correct": false, "note": "Certainty about a stranger is not available from text, and waiting for it is how a fortnight passes." },
        { "text": "They have hinted at it.", "correct": false, "note": "Lovely when it happens. Building the plan around it means you only ever meet the people who move first." },
        { "text": "You have run out of things to say.", "correct": false, "note": "By then the interest has already been spent. That is the late version of this, not the signal." }
      ],
      "explain": "Working is the signal. It does not get better by being left."
    },
    {
      "prompt": "Why does a two-week chat rarely become a date?",
      "options": [
        { "text": "Somebody else got there first.", "correct": false, "note": "Occasionally true and mostly a story that spares you the actual mechanism." },
        { "text": "They were never interested.", "correct": false, "note": "They usually were, two weeks ago. Interest is not a fixed quantity that reveals itself; it is spent." },
        { "text": "Familiarity with no presence flattens into pen pals.", "correct": true, "note": "Every message spends a little of what the match arrived with, and none of them replace it. Nobody decides to stop — it just stops being a thing that was going to happen." },
        { "text": "The app buries old conversations.", "correct": false, "note": "A mechanic rather than the reason. The same fade happens in a thread sitting at the top of the list." }
      ],
      "explain": "The match arrives with a fixed amount of curiosity. Messages spend it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "timing", "label": "Moved while it was working", "description": "Proposed in days rather than weeks." },
      { "key": "no_waiting", "label": "Did not wait for certainty", "description": "Treated the conversation working as the signal." },
      { "key": "took_yes", "label": "Accepted a proposal cleanly", "description": "Said yes without renegotiating when they moved first." },
      { "key": "read_a_stall", "label": "Noticed a non-mover", "description": "Registered somebody who never moves off the app rather than waiting it out." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Day four. The conversation has been genuinely good — long replies, two running jokes, both of you asking things.",
    "partner": {
      "name": "Sena",
      "role": "a match you have been talking to for four days",
      "personality": "Warm and engaged, and will happily keep chatting indefinitely without ever suggesting meeting. Says yes readily to anything concrete.",
      "mood": "Enjoying this, not in a hurry.",
      "openness": 4,
      "sex": "female",
      "alt": {
        "name": "Senan",
        "role": "a match you have been talking to for four days",
        "personality": "Warm and engaged, and will happily keep chatting indefinitely without ever suggesting meeting. Says yes readily to anything concrete.",
        "mood": "Enjoying this, not in a hurry.",
        "openness": 4,
        "sex": "male"
      }
    },
    "opening_beat": "\"okay but you have now mentioned that bakery three separate times\"",
    "success_looks_like": "The user moves the conversation towards meeting rather than continuing it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Write the way people write on apps: short, lowercase-ish, no paragraphs.",
      "Never suggest meeting yourself, however long the conversation runs.",
      "Say yes warmly to anything specific with a time in it."
    ]
  }$j$::jsonb,
  $md$Today, look at one conversation that has been going a while and decide whether it is working or fading. Log which, and what you did about it.$md$
),
(
  (select id from public.skills where slug = 'match-to-date'),
  4,
  'Ask so yes is easy',
  $md$*We should get a drink sometime* is not a plan. It is a wish with no time in it, and the only available reply is *yeah, definitely* — which is why so many of those conversations end there, warmly, forever.

**The move:** something specific, something small, and a time in it.

**Specific** means a place or an activity, ideally one already in the conversation. You have both been talking about the bakery for three days; the plan writes itself, and using it proves the plan came from the two of you rather than from a template.

**Small** matters more than clever. A drink is an hour and dinner is an evening — an hour is what a stranger can comfortably agree to, and it is also what a stranger can comfortably *leave*. Proposing something short is a kindness to both of you, and it removes the objection nobody says out loud.

**A time** is the part that turns a wish into a question. Two options rather than one — *Thursday or Saturday* — because two is a choice and one is a summons, and *when are you free* hands them the admin.

Then send it. The whole thing is one message and it should not be preceded by three messages of throat-clearing, which is what dread produces.

For a shy reader, the reframe worth taking: you are not asking somebody to decide about you. You are asking whether an hour on Thursday works. Those feel like the same question and they are not, and the second one is the one you are actually sending.$md$,
  $j$[
    {
      "situation": "You are about to send: we should get a drink sometime.",
      "line": "(no time in it — the only reply is yeah, definitely)",
      "why": "A wish rather than a question. Warm, agreeable, and the conversation ends there, which is why it is the commonest last message on any app."
    },
    {
      "situation": "You have both been talking about a bakery for three days.",
      "line": "Thursday or Saturday, and you can tell me whether everyone is right about it.",
      "why": "Specific, small, two options, and drawn from the conversation — which proves the plan came from the two of you rather than from a script."
    },
    {
      "situation": "You want to propose dinner to make it a proper date.",
      "line": "(make it an hour)",
      "why": "An hour is what a stranger can comfortably agree to and comfortably leave. Small removes the objection nobody says out loud."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is wrong with we should get a drink sometime?",
      "options": [
        { "text": "It is too casual.", "correct": false, "note": "Casual is right for a first meeting. The register is not the problem." },
        { "text": "There is no time in it, so there is nothing to answer.", "correct": true, "note": "It is a wish rather than a question. The only available reply is yeah, definitely — which is why so many conversations end there, warmly, forever." },
        { "text": "Drinks are a bad first date.", "correct": false, "note": "Drinks are close to ideal: short, cheap, easy to leave. The word doing the damage is sometime." },
        { "text": "It puts them on the spot.", "correct": false, "note": "The opposite. It puts nobody on any spot, which is exactly why nothing happens." }
      ],
      "explain": "A plan has a time in it. Without one you have sent a sentiment."
    },
    {
      "prompt": "Why two options rather than one?",
      "options": [
        { "text": "It doubles your chances.", "correct": false, "note": "Arithmetic that misses the mechanism. This is about what the message asks them to do." },
        { "text": "It shows you are flexible.", "correct": false, "note": "Flexibility taken all the way is when are you free, which hands them the admin and usually stalls." },
        { "text": "It looks less keen.", "correct": false, "note": "Impression management, and beside the point. Keen is fine." },
        { "text": "Two is a choice; one is a summons.", "correct": true, "note": "Choosing between Thursday and Saturday is easy and pleasant. Accepting or rejecting a single fixed date is a much bigger act." }
      ],
      "explain": "Specific, small, two times. Then send it without three messages of throat-clearing."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "specific", "label": "Named something specific", "description": "Proposed an actual place or activity, ideally from the conversation." },
      { "key": "small", "label": "Kept it small", "description": "An hour rather than an evening." },
      { "key": "a_time", "label": "Put a time in it", "description": "Offered days rather than sometime or when are you free." },
      { "key": "sent_it", "label": "Sent it clean", "description": "One message, no throat-clearing in front of it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Day four, and the bakery near the station has come up in the conversation three times.",
    "partner": {
      "name": "Sena",
      "role": "a match you have been talking to for four days",
      "personality": "Warm and decisive. Says yes immediately to anything with a time in it, and answers a vague suggestion with an equally vague yes.",
      "mood": "Enjoying this.",
      "openness": 4,
      "sex": "female",
      "alt": {
        "name": "Senan",
        "role": "a match you have been talking to for four days",
        "personality": "Warm and decisive. Says yes immediately to anything with a time in it, and answers a vague suggestion with an equally vague yes.",
        "mood": "Enjoying this.",
        "openness": 4,
        "sex": "male"
      }
    },
    "opening_beat": "\"honestly i have never actually been. everyone says it is good though\"",
    "success_looks_like": "The user proposes something specific and small with a time in it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Write the way people write on apps: short, lowercase-ish, no paragraphs.",
      "Answer anything with a day in it enthusiastically and concretely.",
      "Answer sometime or when are you free with a warm, vague yeah definitely and nothing more."
    ]
  }$j$::jsonb,
  $md$Today, turn one vague plan with anybody into a specific one with two times in it. Log what you sent.$md$
),
(
  (select id from public.skills where slug = 'match-to-date'),
  5,
  'One nudge, and the soft no',
  $md$You proposed something and nothing came back. Or something came back that was not a yes and not a no.

Both of those are ordinary, both feel much worse than they are, and both have a correct move that is smaller than the one dread will suggest.

**The move:** one nudge, never two — and read the counter-offer.

**The silence.** Wait a couple of days, then send one light message that assumes nothing. Not an apology, not a re-explanation, and above all not *did you get my message*. Something ordinary about the thing you were already talking about, which lets them reappear without having to account for the gap. If that gets nothing, it is done, and the second nudge is the one that turns a normal non-answer into something you would rather they did not tell their friends about.

**The counter-offer.** This is the one people misread in both directions. *I cannot do Thursday, what about next week* is a yes with a diary attached. *I am really busy at the moment* with no alternative offered is a no, however warm the wrapper. The test is entirely mechanical: did they hand back a time, or did they hand back a reason? A time is a yes. A reason is a no.

And the reframe worth keeping, because it is true and people do not believe it: a match not turning into a date is the standard outcome, not evidence about you. The people who do well on these apps are not getting more yeses. They are getting more nos, sooner, and minding them less.$md$,
  $j$[
    {
      "situation": "Two days of silence after you proposed Thursday or Saturday.",
      "line": "(one light message about what you were already talking about)",
      "why": "It lets them reappear without accounting for the gap. Not an apology, not did you get my message, and never a second one after this."
    },
    {
      "situation": "\"I cannot do Thursday — what about the week after?\"",
      "line": "(a time came back — that is a yes)",
      "why": "The test is mechanical. They handed you a diary rather than a reason, which is what a yes looks like when the calendar is inconvenient."
    },
    {
      "situation": "\"Things are really hectic at the moment, sorry!\"",
      "line": "(a reason came back — that is a no, warmly)",
      "why": "No alternative offered. Take it at face value, be nice about it, and do not supply the more convenient week they did not ask for."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Silence for two days after you proposed. What do you send?",
      "options": [
        { "text": "Did you get my message?", "correct": false, "note": "It makes the silence the subject and asks them to explain it. Now they have to manage your feelings before they can answer." },
        { "text": "Nothing ever — they saw it.", "correct": false, "note": "They did, and people miss things, get busy and mean to reply. One nudge is free; it is the second one that costs." },
        { "text": "One light message about what you were already talking about.", "correct": true, "note": "It assumes nothing and lets them reappear without accounting for the gap. If that gets nothing back, it is done." },
        { "text": "A second, easier proposal to make it simpler.", "correct": false, "note": "Two asks stacked on a silence. It reads as pressure however lightly it is written." }
      ],
      "explain": "One nudge, and it should never mention the silence."
    },
    {
      "prompt": "How do you tell a real reschedule from a soft no?",
      "options": [
        { "text": "Did they hand back a time or a reason?", "correct": true, "note": "Entirely mechanical, which is what makes it usable when you are anxious. A time is a yes with a diary attached; a reason with no alternative is a no." },
        { "text": "How warm the message was.", "correct": false, "note": "Soft nos are the warmest messages people send. Warmth is what they use to make it easy on you." },
        { "text": "Whether they apologised.", "correct": false, "note": "Apology usually points the other way, if anything. It is a wrapper, not a signal." },
        { "text": "How quickly they replied.", "correct": false, "note": "Fast and vague is very common. Speed says something about their phone habits and nothing about their diary." }
      ],
      "explain": "A time back is a yes. A reason back is a no. Take it warmly and move on."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_nudge", "label": "Nudged once", "description": "Sent a single light message and no second one." },
      { "key": "no_audit", "label": "Did not mention the silence", "description": "Assumed nothing rather than asking them to account for the gap." },
      { "key": "read_it", "label": "Read the counter-offer correctly", "description": "Took a time as a yes and a reason as a no." },
      { "key": "warm_exit", "label": "Took the no warmly", "description": "Accepted it without pressing or performing disappointment." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You proposed Thursday or Saturday two days ago. Nothing has come back, and the thread is sitting at the top of the app.",
    "partner": {
      "name": "Sena",
      "role": "a match who has not replied to your proposal",
      "personality": "Was genuinely enjoying the conversation and got swamped at work. Reappears cheerfully at a light message that assumes nothing, and goes quiet again at anything that asks about the silence.",
      "mood": "Busy, slightly guilty about the gap.",
      "openness": 3,
      "sex": "female",
      "alt": {
        "name": "Senan",
        "role": "a match who has not replied to your proposal",
        "personality": "Was genuinely enjoying the conversation and got swamped at work. Reappears cheerfully at a light message that assumes nothing, and goes quiet again at anything that asks about the silence.",
        "mood": "Busy, slightly guilty about the gap.",
        "openness": 3,
        "sex": "male"
      }
    },
    "opening_beat": "The thread is open on your last message. Two days, no reply.",
    "success_looks_like": "The user sends one light message that does not mention the silence.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Write the way people write on apps: short, lowercase-ish, no paragraphs.",
      "Reappear warmly, with a real day offered, at a light message that assumes nothing.",
      "Go quiet at anything that asks about the gap or stacks a second proposal on it."
    ]
  }$j$::jsonb,
  $md$Today, when something goes unanswered, send one nudge and then leave it. Log what you sent and what came back.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('match-to-date', 1, 'line', $j${
  "says": "ha, it was genuinely inedible. what made you ask about the bread and not the bike?",
  "model": {
    "line": "The bike says you are impressive. The loaf says you are a person. Did you ever get one to rise?",
    "why": "Answers what was asked, says something with a bit of you in it, and hands back a question that is easy and specific. Nobody has to invent a subject."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Hand something back, do not leave a dead end" },
    { "kind": "max_questions", "requirement": "One question. Three gets one answered.", "n": 1 },
    { "kind": "min_words", "requirement": "Answer them before you ask anything", "n": 12 },
    { "kind": "max_words", "requirement": "Match their length — a message, not a paragraph", "n": 45 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('match-to-date', 2, 'line', $j${
  "says": "so what do you do?",
  "model": {
    "line": "Spreadsheets, technically. Mostly I argue with people who want the spreadsheet to say something else. What is the worst job you have ever had?",
    "why": "The fact, then the reaction, then a question that is not the same question back. The middle sentence is the only part that tells them what you are like."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Put something of yourself in it" },
    { "kind": "forbids_any", "requirement": "Do not mirror the interview back",
      "words": ["what about you", "how about you", "and you", "what do you do", "where are you from", "yourself"] },
    { "kind": "max_questions", "requirement": "At most one question", "n": 1 },
    { "kind": "min_words", "requirement": "More than a job title", "n": 12 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('match-to-date', 3, 'choice', $j${
  "beats": [
    {
      "situation": "Four days of good exchanges. Long replies, two running jokes, both of you asking things. You have not suggested meeting.",
      "prompt": "What now?",
      "options": [
        { "text": "Propose something. This is what working looks like.", "correct": true, "note": "There is no stronger signal coming. Waiting does not earn the right and does not improve the odds — it only spends what the match arrived with." },
        { "text": "Give it a few more days to be sure.", "correct": false, "note": "Sure of what? Certainty about a stranger is not available from text, and this is how a fortnight passes." },
        { "text": "Wait for them to suggest it.", "correct": false, "note": "Then you only ever meet the people who move first, and plenty of warm matches never move at all." },
        { "text": "Drop a hint and see if they pick it up.", "correct": false, "note": "A hint is a proposal with the answerable part removed. If it is worth hinting, it is worth asking." }
      ]
    },
    {
      "situation": "A different match. Sixteen days, messages every day, no meeting.",
      "prompt": "What happened here?",
      "options": [
        { "text": "They were never really interested.", "correct": false, "note": "They usually were, two weeks ago. Interest is not a fixed quantity waiting to be revealed — it gets spent." },
        { "text": "Nothing yet. Sixteen days of good chat is a good sign.", "correct": false, "note": "It is the most comfortable reading and the wrong one. Nothing about it is pointing at a date." },
        { "text": "It became pen pals, and pen pals do not become dates.", "correct": true, "note": "Familiarity with no presence flattens. Nobody decides to stop; it quietly stops being a thing that was going to happen." },
        { "text": "One of you is playing it cool.", "correct": false, "note": "Possibly, and it does not change the move. Somebody has to propose and there is no advantage in it not being you." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('match-to-date', 4, 'line', $j${
  "says": "honestly i have never actually been. everyone says it is good though",
  "model": {
    "line": "Then let us fix that — Thursday or Saturday, one drink, and you can tell me whether everyone is right?",
    "why": "Specific, small, two times, and built out of the thing you were already talking about. Choosing between two days is easy; there is nothing here to negotiate."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Put a time in it",
      "words": ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday", "tomorrow", "this week", "next week", "tonight", "weekend"] },
    { "kind": "contains_any", "requirement": "Keep it small — an hour, not an evening",
      "words": ["drink", "coffee", "hour", "walk", "quick", "one"] },
    { "kind": "forbids_any", "requirement": "A plan, not a wish",
      "words": ["sometime", "some time", "at some point", "one of these days", "when are you free", "we should"] },
    { "kind": "max_words", "requirement": "One message, no throat-clearing", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('match-to-date', 5, 'choice', $j${
  "beats": [
    {
      "situation": "You proposed Thursday or Saturday. Two days, nothing back.",
      "prompt": "What do you send?",
      "options": [
        { "text": "Did you get my message?", "correct": false, "note": "It makes the silence the subject and asks them to account for it before they can answer anything." },
        { "text": "A second, easier proposal, to make it simpler for them.", "correct": false, "note": "Two asks stacked on a silence reads as pressure however lightly it is written." },
        { "text": "One light message about what you were already talking about.", "correct": true, "note": "It assumes nothing and lets them reappear without explaining the gap. If it gets nothing back, it is done." },
        { "text": "Nothing — they clearly saw it.", "correct": false, "note": "They did, and people get swamped and mean to reply. One nudge is free; it is the second that costs." }
      ]
    },
    {
      "situation": "\"Ah I cannot do Thursday, things are hectic at the moment — sorry!\"",
      "prompt": "Yes or no?",
      "options": [
        { "text": "A no. A reason came back, not a time.", "correct": true, "note": "Mechanical, which is what makes it usable when you are anxious. Warmth and an apology are the wrapper; the absence of an alternative is the message." },
        { "text": "A yes with a scheduling problem.", "correct": false, "note": "That version hands you a day. This one hands you an explanation, and the difference is the whole test." },
        { "text": "Ambiguous — offer the following week.", "correct": false, "note": "Supplying the alternative they chose not to supply is asking them to decline twice." },
        { "text": "Impossible to tell from a text message.", "correct": false, "note": "It is one of the more legible messages you will get. Time back, or reason back." }
      ]
    }
  ]
}$j$::jsonb);
