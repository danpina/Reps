-- The first date, track 1: Before you go.
--
-- The topic's shop window, so it leads on the two things that make the whole
-- evening easier and are both decided in advance — where, and how long. A
-- reader who does nothing else in this topic but book a drink instead of
-- dinner and say a finish time on arrival has already had a better date.
--
-- Every lesson here is a line or choice drill. Nothing before a date depends
-- on what somebody else says back, which is exactly why it is the part you can
-- get right without being brave.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'before-you-go'),
  1,
  'Somewhere you can leave',
  $md$The venue decides more about a first date than anything either of you says, and most people pick it for the wrong reason — how nice it is, rather than how easy it is.

**The move:** a drink, somewhere with a bit of noise, for an hour or two.

Every part of that is doing work. A drink has no natural length, so it can be forty minutes or three hours without either being a statement. Noise gives you something to react to and takes the pressure off silence. And a bar or a café has other things to look at, which sounds trivial and is not — two people with nothing in the room to point at have to generate every single thing between them.

Dinner is the common mistake and it is worth being specific about why. You are committed for the length of three courses, seated directly opposite somebody with nothing to look at except them, on the kitchen's schedule rather than yours. It is also expensive enough to feel like an occasion, which raises what the evening is supposed to be. Nothing about it is fatal — people have good dinners on first dates constantly — it is simply the hardest version of the room, chosen by people who thought they were being generous.

Anything with a screen is worse, because you have arranged an evening in which you cannot talk to each other and then have twenty minutes afterwards to find out whether you can.

Walk-and-talk works surprisingly well if the weather is with you: no seating position to negotiate, no eye contact obligation, a constant supply of things to remark on, and it ends naturally at a corner. It is the best-kept secret in this topic for anybody who finds sitting opposite somebody difficult.

If you keep one thing: choose for exit-ability, not for impressiveness. A drink somewhere ordinary is the room in which most good first dates have actually happened.$md$,
  $j$[
    {
      "situation": "You are choosing between a nice restaurant and a bar down the road.",
      "line": "(the bar)",
      "why": "A drink has no natural length, so forty minutes and three hours are both fine. Dinner commits you to three courses on the kitchen's schedule."
    },
    {
      "situation": "You want somewhere quiet so you can actually hear each other.",
      "line": "(a bit of noise is your friend)",
      "why": "Silence in a silent room is loud. Background noise takes the pressure off pauses and gives you both something to react to."
    },
    {
      "situation": "You find sitting directly opposite somebody hard.",
      "line": "(suggest a walk)",
      "why": "No seating to negotiate, no eye contact obligation, a constant supply of things to remark on, and it ends naturally at a corner."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is a drink better than dinner?",
      "options": [
        { "text": "It is cheaper, so there is less pressure.", "correct": false, "note": "Cost contributes and is the smaller part. Plenty of expensive drinks go perfectly well." },
        { "text": "It has no natural length.", "correct": true, "note": "Forty minutes and three hours are both fine and neither is a statement. Dinner commits you to three courses on somebody else's schedule." },
        { "text": "Drinking makes it easier.", "correct": false, "note": "A bad reason and a worse plan. The venue is doing the work, not the alcohol." },
        { "text": "It is more casual.", "correct": false, "note": "True and vague. Name the actual property: you can leave whenever it is right to." }
      ],
      "explain": "Choose for exit-ability. That is the property that makes the evening easier."
    },
    {
      "prompt": "What is the point of a bit of background noise?",
      "options": [
        { "text": "It makes it feel livelier.", "correct": false, "note": "Atmosphere is pleasant and it is not what the noise is for." },
        { "text": "It hides nervousness in your voice.", "correct": false, "note": "It does not, particularly, and nobody is listening for that." },
        { "text": "It means you can lean in to hear each other.", "correct": false, "note": "That is a chat-up line theory of acoustics, and a room too loud to hear in is genuinely bad." },
        { "text": "Silence in a silent room is loud.", "correct": true, "note": "Two hours has pauses in it. Noise takes the pressure off them and gives you both something to react to." }
      ],
      "explain": "Somewhere with a bit going on. Two people with nothing to point at have to generate everything themselves."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "leavable", "label": "Chose somewhere leavable", "description": "Picked a venue with no fixed length." },
      { "key": "not_dinner", "label": "Avoided the hardest room", "description": "Did not default to dinner or a screen." },
      { "key": "easy", "label": "Chose easy over impressive", "description": "Optimised for the conversation rather than the occasion." },
      { "key": "decided", "label": "Actually proposed something", "description": "Named a place rather than asking where they would like to go." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Messages, two days before. You have agreed to meet on Thursday and neither of you has said where.",
    "partner": {
      "name": "Robin",
      "role": "somebody you are meeting on Thursday",
      "personality": "Easy-going and happy to go along with a concrete suggestion. Answers a vague question with an equally vague one.",
      "mood": "Looking forward to it, no strong opinions.",
      "openness": 4
    },
    "opening_beat": "\"So — where are we going then?\"",
    "success_looks_like": "The user proposes a specific, leavable place rather than asking what they would like.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Agree readily and warmly to any specific suggestion.",
      "Answer where would you like to go with I do not mind, you choose.",
      "Never suggest a venue yourself."
    ]
  }$j$::jsonb,
  $md$Today, pick the venue for one plan instead of asking the other person to. Log where you chose and why.$md$
),
(
  (select id from public.skills where slug = 'before-you-go'),
  2,
  'Say the finish time',
  $md$You already know this move. It is the exit you plant in a conference corridor, and it does more work on a first date than anywhere else in this app.

**The move:** decide how long you are staying before you go, and say it when you arrive.

*I have got to be somewhere at eight, but* — said lightly, in the first two minutes, as ordinary logistics — changes the whole shape of the evening. Both of you now know this has an end, which means neither of you is quietly working out how it will finish. That calculation runs in the background of almost every first date and it costs more attention than people realise.

It is also a gift to them, and that is the part worth understanding, because it feels like the opposite. Somebody who does not know how long this is supposed to last is stuck: they cannot leave early without it being a verdict, and they cannot relax into it either. A stated finish removes both problems at once.

You will frequently stay longer, and that is the good version. *I should probably go — actually, do you want another one?* is a much better moment than the same two hours with no landmark in them, because staying became a choice somebody made rather than a thing that continued.

Two hours is the right default. Long enough to get past the first ten minutes and have a real conversation; short enough that nobody is tired of it. If it is going brilliantly you extend, and if it is not you have already been given the way out.

And be honest rather than elaborate. A real thing you are doing afterwards is best, an early start tomorrow is fine, and a fabricated emergency is unnecessary — nobody has ever questioned a finish time.

If you keep one thing: say it in the first two minutes, not the last twenty. Said early it is logistics. Said late it is an escape.$md$,
  $j$[
    {
      "situation": "You have just sat down with your drinks.",
      "line": "I have got to be somewhere at eight, but this is good for a couple of hours.",
      "why": "Ordinary logistics, said in the first two minutes. Both of you now know this has an end, so neither is quietly working out how it will finish."
    },
    {
      "situation": "It is going well and eight o'clock is coming.",
      "line": "I should probably go — do you want another one first?",
      "why": "Staying becomes a choice somebody made rather than a thing that continued, which is a better moment than two hours with no landmark in them."
    },
    {
      "situation": "You are inventing a reason to have somewhere to be.",
      "line": "(an early start is enough)",
      "why": "Nobody has ever questioned a finish time. A fabricated emergency is more effort and more to remember."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why say it at the start rather than when you want to leave?",
      "options": [
        { "text": "Said late it is an escape; said early it is logistics.", "correct": true, "note": "The same sentence means completely different things depending on when it arrives. At the start it is information; at the end it is a verdict with a coat on." },
        { "text": "You might forget.", "correct": false, "note": "You will not forget, and it is not what the timing buys you." },
        { "text": "It sets expectations low.", "correct": false, "note": "It does not lower anything. It removes an unknown, which is different." },
        { "text": "It shows you have a life.", "correct": false, "note": "Impression management, and slightly the wrong instinct — this is not aimed at how you look." }
      ],
      "explain": "First two minutes. It is a piece of information, and it stops being one later on."
    },
    {
      "prompt": "How does it help the other person?",
      "options": [
        { "text": "It tells them how much effort to make.", "correct": false, "note": "Nobody calibrates effort that way, and it is a slightly bleak reading of a kind move." },
        { "text": "It means they can plan their evening.", "correct": false, "note": "Practically true and trivial next to what it actually does." },
        { "text": "Without it they cannot leave early without it being a verdict.", "correct": true, "note": "They are stuck: no way out that does not say something, and no way to relax into it either. A stated finish removes both at once." },
        { "text": "It stops them worrying that you are not interested.", "correct": false, "note": "If anything a finish time could suggest the opposite, and it does not, because it arrived as logistics." }
      ],
      "explain": "It is a gift disguised as a limit. Both of you get to stop calculating."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_it", "label": "Said a finish time", "description": "Named when they would need to go." },
      { "key": "early", "label": "Said it early", "description": "In the first couple of minutes rather than at the end." },
      { "key": "light", "label": "Kept it light", "description": "Delivered it as logistics, not as a warning." },
      { "key": "honest", "label": "Kept it honest", "description": "Used a real reason rather than an elaborate invention." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have just arrived, got drinks, and sat down. It is six o'clock.",
    "partner": {
      "name": "Robin",
      "role": "the person you are on a date with",
      "personality": "Visibly relaxes when the evening is given a shape, and stays uncertain about the timing if nobody sets one.",
      "mood": "A bit nervous, pleased to be here.",
      "openness": 4
    },
    "opening_beat": "\"Right. Well — hello. This is the bit where neither of us knows what to say.\"",
    "success_looks_like": "The user gives the evening a finish time, lightly, in the opening minutes.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Relax noticeably when a finish time is mentioned, and say something easy in return.",
      "Stay slightly uncertain and over-polite if no shape is given to the evening.",
      "Never state a finish time yourself."
    ]
  }$j$::jsonb,
  $md$Today, tell somebody how long you have got at the start of something rather than at the end. Log what you said.$md$
),
(
  (select id from public.skills where slug = 'before-you-go'),
  3,
  'The four hours before',
  $md$The worst part of a first date is usually the afternoon of it, and almost nobody is told that in advance.

Dread lives in anticipation. It builds through the day, peaks somewhere around getting ready, and then drops sharply about ten minutes after you arrive — which is a pattern so reliable that it is worth treating as a fact about how this works rather than as a fact about you.

**The move:** treat the pre-date hours as weather, and do not make decisions in them.

The decisions people make in that window are all bad and they are all the same decision: cancelling. It arrives dressed as something reasonable — you are tired, you have too much on, you would be poor company tonight, they would probably prefer it. None of that is analysis. It is the feeling looking for a justification, and it is at its most persuasive about ninety minutes before.

Two things help and neither is a mindset. Have the afternoon occupied — genuinely occupied, by something that takes attention — because unstructured time before a date is four hours of rehearsal for a conversation that will not go the way you rehearsed. And get there slightly early rather than arriving flustered, because being late converts nerves into a much more physical thing that then takes twenty minutes to come down from.

What does not help is preparation. There is nothing to prepare. Planning what you will say produces material you then have to steer towards, and steering is the single most visible form of effort there is.

The one thing worth knowing about the nerves themselves: they are not a signal about the person or the evening. They are a signal that this matters to you, which is the correct response to something that matters, and it is the same feeling you had before every good thing you have ever done.

If you keep one thing: do not cancel in the four hours before. Whatever you are feeling then is not information.$md$,
  $j$[
    {
      "situation": "It is four o'clock and you are looking for a reason to cancel.",
      "line": "(that is the feeling, not a reason)",
      "why": "It arrives dressed as something sensible — tired, too much on, poor company tonight — and it is at its most persuasive about ninety minutes before."
    },
    {
      "situation": "You have a free afternoon before the date.",
      "line": "(fill it with something that takes attention)",
      "why": "Unstructured time is four hours of rehearsal for a conversation that will not go the way you rehearsed."
    },
    {
      "situation": "You are planning what you will say.",
      "line": "(there is nothing to prepare)",
      "why": "Planned material has to be steered towards, and steering is the most visible form of effort there is."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the reliable shape of the nerves?",
      "options": [
        { "text": "They build all evening and peak at the end.", "correct": false, "note": "The opposite of what actually happens, and it is why so many people cancel before finding out." },
        { "text": "They peak while getting ready and drop about ten minutes in.", "correct": true, "note": "Reliable enough to plan around. It is a fact about anticipation rather than a fact about you." },
        { "text": "They depend on how much you like the person.", "correct": false, "note": "Only loosely, and it does not change what to do in the four hours before." },
        { "text": "They go once the conversation starts flowing.", "correct": false, "note": "Close, and it puts the relief later than it comes. The drop is at arrival, not at the first good exchange." }
      ],
      "explain": "The afternoon is the worst part. Knowing that in advance takes some of the weight out of it."
    },
    {
      "prompt": "What makes the pre-date hours dangerous?",
      "options": [
        { "text": "You will overthink what to wear.", "correct": false, "note": "Mildly annoying and consequence-free." },
        { "text": "You will drink too much beforehand.", "correct": false, "note": "A real hazard for some people, and not the decision most first dates are lost to." },
        { "text": "You will build the person up in your head.", "correct": false, "note": "Common, and it mostly resolves itself within ten minutes of meeting them." },
        { "text": "Cancelling feels like a reasonable decision.", "correct": true, "note": "It arrives with justifications attached — tired, busy, they would prefer it. That is the feeling looking for a reason, not analysis." }
      ],
      "explain": "Do not decide anything in that window. Whatever you feel there is not information."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "went", "label": "Went", "description": "Did not cancel in the window." },
      { "key": "occupied", "label": "Filled the time", "description": "Kept the afternoon occupied rather than open." },
      { "key": "no_rehearsal", "label": "Did not rehearse", "description": "Prepared nothing to steer towards." },
      { "key": "early", "label": "Arrived unflustered", "description": "Got there in time to come down from the journey." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Four o'clock on the afternoon of the date. Two hours to go, nothing to do, and a very reasonable-sounding case for cancelling assembling itself.",
    "partner": {
      "name": "Sam",
      "role": "a friend you are messaging",
      "personality": "Kind and entirely unfooled. Takes every justification seriously for about one second and then names it.",
      "mood": "Amused, on your side.",
      "openness": 5
    },
    "opening_beat": "\"You are going to say you are thinking of cancelling, aren't you.\"",
    "success_looks_like": "The user recognises the cancelling urge as the feeling rather than a reason.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Treat every practical justification as the feeling wearing a disguise, warmly.",
      "Never tell the user what to do — ask what they would think tomorrow.",
      "Be pleased and matter-of-fact if they decide to go."
    ]
  }$j$::jsonb,
  $md$Today, notice one thing you are dreading and name the hour the dread peaks. Do the thing anyway. Log both.$md$
),
(
  (select id from public.skills where slug = 'before-you-go'),
  4,
  'Two or three things you are curious about',
  $md$There is a difference between having questions ready and being curious, and it is audible within about four minutes.

Questions ready produces an interview. You ask, they answer, you retrieve the next one, and the whole thing has the rhythm of a form being completed — which is exactly what a nervous person reaches for, because a list is something to hold when you are afraid of the gaps.

**The move:** arrive with two or three things you genuinely want to know, and let them be specific.

Not *what do they do* — you can find that out in thirty seconds and it leads nowhere. Something you are actually wondering about. They mentioned they moved here from somewhere much smaller; you want to know what that was like. Their profile said they have opinions about something you have never thought about; you want to hear them. They said one thing in a message that you did not quite understand.

That is a completely different object from a question list, and it behaves differently in the conversation. Curiosity produces follow-ups by itself, because you actually want the answer — and follow-ups are what makes somebody feel listened to rather than surveyed. A prepared question produces one answer and then a silence while you fetch the next.

Two or three is the number. More is a list again. And they are a reserve rather than a plan: if the conversation goes somewhere else entirely, that is the better outcome and you should let it, which is much easier to do when you know you have something in your pocket if it stalls.

It is also worth having one thing you would like to tell them, for the same reason. Not an anecdote you have polished — a thing that happened this week that you found funny or annoying. It gives you something to volunteer at the point where somebody quiet would otherwise just answer and stop.

If you keep one thing: curiosity, not questions. One is a thing you have; the other is a thing you deploy, and people can tell the difference immediately.$md$,
  $j$[
    {
      "situation": "You are working out what to ask them.",
      "line": "(work out what you actually want to know instead)",
      "why": "Curiosity produces follow-ups by itself, because you want the answer. A prepared question produces one answer and then a silence while you fetch the next."
    },
    {
      "situation": "They mentioned moving here from a much smaller place.",
      "line": "(that — what was that actually like)",
      "why": "Specific and genuinely open. It is the difference between wanting to know something and having something to say next."
    },
    {
      "situation": "The conversation has gone somewhere you did not expect.",
      "line": "(let it — the reserve is for stalls)",
      "why": "Two or three things in your pocket is what makes it easy to abandon them. A plan is a thing you have to get back to."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is wrong with having questions ready?",
      "options": [
        { "text": "It is a bit calculating.", "correct": false, "note": "Preparing is fine and being prepared is not the problem. What you prepared is." },
        { "text": "You will forget them.", "correct": false, "note": "Usually you remember them all too well, which is what produces the retrieval rhythm." },
        { "text": "It produces one answer and then a silence.", "correct": true, "note": "A prepared question has no follow-up attached, so you fetch the next one — and the whole thing has the rhythm of a form being completed." },
        { "text": "They will have heard them before.", "correct": false, "note": "They will, and an unoriginal question you actually care about the answer to still works." }
      ],
      "explain": "Curiosity produces follow-ups by itself. That is what makes somebody feel listened to rather than surveyed."
    },
    {
      "prompt": "Why also have one thing you want to tell them?",
      "options": [
        { "text": "So you seem interesting.", "correct": false, "note": "Aiming at interesting is what produces the polished anecdote, which is the version that does not work." },
        { "text": "To balance the conversation.", "correct": false, "note": "True in outcome and vague as a reason. What matters is the specific moment it rescues." },
        { "text": "To fill a silence.", "correct": false, "note": "Silences are allowed and do not need filling. This is for a different gap." },
        { "text": "Because otherwise a quiet person answers and stops.", "correct": true, "note": "It gives you something to volunteer rather than only ever responding, which is the shape that leaves somebody feeling they never got to know you." }
      ],
      "explain": "One thing that happened this week that you found funny or annoying. Not polished."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "curious", "label": "Brought curiosity", "description": "Wanted to know things rather than having things to ask." },
      { "key": "specific", "label": "Was specific", "description": "Picked actual wonderings rather than standard questions." },
      { "key": "few", "label": "Kept it to two or three", "description": "A reserve rather than a list." },
      { "key": "something_to_tell", "label": "Had something to volunteer", "description": "Brought one thing of their own, unpolished." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The night before. You know three things about them: they moved here from a village, they are unreasonably committed to a sport nobody watches, and they said something in a message you did not quite follow.",
    "partner": {
      "name": "Sam",
      "role": "a friend you are messaging",
      "personality": "Pushes back on anything that sounds like a question list and asks what you actually want to know.",
      "mood": "Helping, mildly entertained.",
      "openness": 5
    },
    "opening_beat": "\"Go on then. What are you going to ask them?\"",
    "success_looks_like": "The user names something they genuinely want to know rather than a question to deploy.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Reject generic questions by asking whether they actually care about the answer.",
      "Warm up at anything specific and genuinely curious.",
      "Never suggest a question yourself."
    ]
  }$j$::jsonb,
  $md$Today, before one conversation, decide one thing you actually want to know about the other person. Log it and whether you asked.$md$
),
(
  (select id from public.skills where slug = 'before-you-go'),
  5,
  'Go to find out, not to be liked',
  $md$What you think you are going for decides how the whole evening feels, and almost everybody arrives with the wrong objective.

The default is *I hope they like me*. It is understandable and it is a terrible target, for two reasons. It is not in your control — you cannot make somebody like you, and trying is visible. And it puts you in a posture for two hours: monitoring, adjusting, checking how each thing landed. That posture is exhausting, it makes you noticeably effortful, and effort is the thing people actually detect when they say somebody was trying too hard.

**The move:** go to find out whether you would like a second one.

That is a question you can answer. It is answerable at any point in the evening, it does not require you to guess at anybody's inner state, and it is genuinely useful either way. If the answer is yes you know what to do at the end. If it is no you have spent two hours and learned something real.

It also changes what you do while you are there. Somebody trying to be liked performs. Somebody finding out asks things, listens properly, and says what they actually think — which, in one of the more useful ironies available, is substantially more likeable than the performance.

The hardest part is that this only works if the no is genuinely allowed. If some part of you needs it to go well, you are back to hoping, and hoping produces the same posture. It is worth deciding beforehand, in words: *this might not be for me, and that would be a fine outcome.*

And there is a version of this for anybody who has been on a run of dates that went nowhere, because that is when the target quietly slips back to being liked. A date that ends in a clear no is not a failure of the date. It is the system working — the whole point of meeting somebody is to find out, and finding out quickly is the good version.

If you keep one thing: you are there to answer a question, not to pass. The question is yours and you are allowed to answer it either way.$md$,
  $j$[
    {
      "situation": "You are on the way there hoping they like you.",
      "line": "(swap it — are you going to like them?)",
      "why": "One is unanswerable and puts you in a monitoring posture for two hours. The other you can answer at any point in the evening."
    },
    {
      "situation": "Something you said did not land and you are replaying it.",
      "line": "(that is the monitoring, and it costs the next ten minutes)",
      "why": "Checking how each thing landed is what people detect as trying too hard. It is also the thing that stops you noticing whether you are enjoying yourself."
    },
    {
      "situation": "You realise halfway through that it is not for you.",
      "line": "(then it worked)",
      "why": "The whole point of meeting somebody is to find out, and finding out quickly is the good version rather than a wasted evening."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is wrong with hoping they like you?",
      "options": [
        { "text": "It is needy.", "correct": false, "note": "A judgement rather than a mechanism, and it is not a useful thing to tell a nervous person." },
        { "text": "It is not in your control, and trying is visible.", "correct": true, "note": "It puts you in a monitoring posture for two hours — adjusting, checking how each thing landed — and effort is precisely what people detect as trying too hard." },
        { "text": "They probably will anyway.", "correct": false, "note": "Reassurance rather than a fix, and it leaves the same target in place." },
        { "text": "It makes you agreeable rather than honest.", "correct": false, "note": "A real symptom, and downstream of the target being unanswerable in the first place." }
      ],
      "explain": "Go to answer a question you can actually answer."
    },
    {
      "prompt": "What makes the swap actually work?",
      "options": [
        { "text": "Deciding beforehand that a no would be fine.", "correct": true, "note": "If some part of you needs it to go well you are back to hoping, and hoping produces the same posture. It is worth saying in words." },
        { "text": "Keeping your expectations low.", "correct": false, "note": "Low expectations are a way of pre-managing disappointment, which is still the old target wearing a hat." },
        { "text": "Reminding yourself you have other options.", "correct": false, "note": "A strategy for feeling secure that has nothing to do with finding out whether you like them." },
        { "text": "Not caring about the outcome.", "correct": false, "note": "You are allowed to care. The point is which question you are trying to answer, not how much it matters." }
      ],
      "explain": "This might not be for me, and that would be a fine outcome. Say it before you go."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "right_question", "label": "Went to find out", "description": "Aimed at whether they would want a second one." },
      { "key": "no_monitoring", "label": "Did not monitor", "description": "Stopped checking how each thing landed." },
      { "key": "no_allowed", "label": "Allowed the no", "description": "Decided in advance that not liking them was a fine outcome." },
      { "key": "honest", "label": "Said what they thought", "description": "Was a participant rather than a candidate." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "On the way there. Your friend messages to ask how you are feeling about it.",
    "partner": {
      "name": "Sam",
      "role": "a friend you are messaging",
      "personality": "Asks what you are hoping for and keeps asking until the answer is about you rather than about them.",
      "mood": "Interested, unhurried.",
      "openness": 5
    },
    "opening_beat": "\"Nervous? What are you hoping happens tonight?\"",
    "success_looks_like": "The user frames the evening as finding out rather than as being liked.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Keep asking what they want, if the answer is about what the other person will think.",
      "Accept and be pleased by an answer about finding out.",
      "Never state the reframe yourself."
    ]
  }$j$::jsonb,
  $md$Today, go into one thing asking whether you like it rather than whether you are doing well. Log which question you caught yourself asking.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('before-you-go', 1, 'choice', $j${
  "beats": [
    {
      "situation": "\"So — where are we going then?\" You have Thursday evening and no plan.",
      "prompt": "What do you propose?",
      "options": [
        { "text": "The Italian place everyone says is good.", "correct": false, "note": "Three courses, directly opposite each other, on the kitchen's schedule, and expensive enough to make it an occasion. The hardest version of the room." },
        { "text": "A quiet wine bar where you can actually hear each other.", "correct": false, "note": "Close, and quiet is the part to reconsider. Silence in a silent room is loud, and two hours has pauses in it." },
        { "text": "Whatever you fancy — I do not mind.", "correct": false, "note": "It hands them the admin, and it usually comes back as I do not mind either, which is how people end up at dinner by default." },
        { "text": "A bar near the station, from six.", "correct": true, "note": "No fixed length, some background noise, things to look at, and easy to leave or extend. Ordinary, and where most good first dates have actually happened." }
      ]
    },
    {
      "situation": "You find sitting directly opposite somebody for two hours genuinely difficult.",
      "prompt": "Is there a better option?",
      "options": [
        { "text": "A walk somewhere, if the weather holds.", "correct": true, "note": "No seating to negotiate, no eye contact obligation, a constant supply of things to remark on, and it ends naturally at a corner." },
        { "text": "Sit at the bar rather than a table.", "correct": false, "note": "Genuinely better — side by side beats opposite — and it is a smaller version of the same idea." },
        { "text": "Something with an activity, so there is less talking.", "correct": false, "note": "Less talking is not the goal. An activity you cannot talk through leaves you twenty minutes afterwards to find out whether you can." },
        { "text": "Push through it — the seating is not the problem.", "correct": false, "note": "For you it is part of the problem, and choosing around it is free." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('before-you-go', 2, 'line', $j${
  "says": "Right. Well — hello. This is the bit where neither of us knows what to say.",
  "model": {
    "line": "It is, yes. I have got to be somewhere at eight, but this is good until then.",
    "why": "Ordinary logistics in the first two minutes. Both of you now know the evening has a shape, so neither is quietly working out how it will finish."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Give the evening a finish time",
      "words": ["eight", "seven", "nine", "half", "couple of hours", "an hour", "two hours", "until", "later", "eightish"] },
    { "kind": "forbids_any", "requirement": "Logistics, not a warning or an excuse",
      "words": ["sorry", "just so you know", "i should say", "unfortunately", "have to warn", "emergency", "might have to"] },
    { "kind": "max_words", "requirement": "Light, and in passing", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('before-you-go', 3, 'choice', $j${
  "beats": [
    {
      "situation": "Four o'clock. Two hours to go. You are tired, you have a lot on this week, and you are fairly sure you would be poor company tonight.",
      "prompt": "What is that?",
      "options": [
        { "text": "A fair assessment — going when you are flat helps nobody.", "correct": false, "note": "It sounds like judgement and it arrived on schedule. The same case assembles itself before every date and dissolves ten minutes after arriving." },
        { "text": "The feeling, looking for a justification.", "correct": true, "note": "Dread peaks about ninety minutes before and it does not present as dread — it presents as three sensible reasons." },
        { "text": "A sign you are not that interested.", "correct": false, "note": "Nerves scale with how much something matters. If anything this points the other way, and either way it is not decidable from an armchair at four o'clock." },
        { "text": "Ordinary tiredness, unrelated to the date.", "correct": false, "note": "Possible, and notice that it only became decisive today." }
      ]
    },
    {
      "situation": "You have decided to go. There are two hours of empty afternoon in front of you.",
      "prompt": "How do you spend them?",
      "options": [
        { "text": "Think through some things to talk about.", "correct": false, "note": "Prepared material has to be steered towards, and steering is the most visible form of effort there is." },
        { "text": "Rest, so you arrive fresh.", "correct": false, "note": "Two unstructured hours is not rest before a date. It is rehearsal for a conversation that will not go the way you rehearse it." },
        { "text": "Something that takes actual attention.", "correct": true, "note": "Occupied time is the practical intervention. It is not a mindset and it works because the alternative is four hours of your own company." },
        { "text": "Get ready slowly and leave in good time.", "correct": false, "note": "Arriving unflustered is genuinely worth it, and it takes twenty minutes rather than two hours." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('before-you-go', 4, 'line', $j${
  "says": "Go on then. What are you going to ask them? All you know is they moved here from a village, they are unreasonably into a sport nobody watches, and they said something in a message you did not follow.",
  "model": {
    "line": "I want to know what it was actually like moving here from somewhere that small — whether it was a relief or a shock.",
    "why": "Something genuinely wondered about rather than a question to deploy. Curiosity produces its own follow-ups, because you want the answer."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Say what you want to know, not what you will ask" },
    { "kind": "forbids_any", "requirement": "Not the standard set",
      "words": ["what do you do", "where are you from", "any siblings", "hobbies", "what do you like", "tell me about yourself", "what are you looking for"] },
    { "kind": "min_words", "requirement": "Specific enough to be a real wondering", "n": 10 },
    { "kind": "max_words", "requirement": "One thing, not a list", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('before-you-go', 5, 'line', $j${
  "says": "Nervous? What are you hoping happens tonight?",
  "model": {
    "line": "I want to come out knowing whether I would like to see them again. It might not be, and that is fine.",
    "why": "A question you can actually answer, and the second sentence is what makes the first one true. If some part of you needs it to go well, you are back to hoping."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Make it about what you want to find out" },
    { "kind": "forbids_any", "requirement": "Not whether they like you",
      "words": ["they like me", "goes well", "do not mess", "not to ruin", "impress", "hope they", "go badly", "make a good impression"] },
    { "kind": "min_words", "requirement": "Allow the no out loud", "n": 12 },
    { "kind": "max_words", "requirement": "Two sentences", "n": 40 }
  ]
}$j$::jsonb);
