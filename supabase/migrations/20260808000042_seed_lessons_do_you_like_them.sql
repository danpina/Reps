-- The first date, track 3: Working out if you like them.
--
-- The track that would be cut from a shorter version of this topic and should
-- not be. Every other piece of dating advice a quiet person has ever read is
-- about being chosen, and two hours spent auditioning produces the strangest
-- outcome in dating: second dates arranged with people you did not like.
--
-- No scenes. Nothing here is a thing you say — it is a thing you notice — and
-- a drill that asks you to name what you noticed is closer to the real act
-- than a conversation with a partner would be.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'do-you-like-them'),
  1,
  'You arrived as a candidate',
  $md$Notice the posture you turn up in, because it is doing more damage than anything you say.

The default is assessment: am I doing well, was that funny, did that land, do they like me. It runs continuously for two hours, underneath the conversation, and it is what almost every quiet person means when they say a date was exhausting. The talking was not tiring. The monitoring was.

**The move:** notice that you are auditioning, and stop.

It costs you three things, and they compound. It is exhausting, which means you are worse company by minute ninety than you were at minute ten. It is visible — checking how each thing landed is precisely what people detect when they say somebody was trying too hard, and they detect it without being able to name it. And it crowds out the only question that was actually yours to answer, which is whether you want to do this again.

That last one produces the outcome worth sitting with: people agree to second dates with people they did not enjoy, because nobody ever asked them whether they had. The evening was scored entirely on how it went, and *how it went* was a guess about somebody else's inner state.

The reason it is so hard to drop is that it feels like effort in the right direction. Trying to be liked looks like caring, and stopping feels like giving up on the outcome. It is not — it is redirecting attention from a thing you cannot control to a thing you can, and the redirect is the whole technique.

One tell: if you can remember what you said better than what they said, you were auditioning.

If you keep one thing: the exhaustion is the monitoring, not the conversation. Two hours of talking is not tiring. Two hours of being marked is.$md$,
  $j$[
    {
      "situation": "You are replaying something you said four minutes ago.",
      "line": "(that is the monitoring, and it is costing you the next ten minutes)",
      "why": "Checking how each thing landed is what people detect as trying too hard, and it crowds out the only question that was yours to answer."
    },
    {
      "situation": "You get home shattered after two hours of pleasant conversation.",
      "line": "(the talking was not what tired you)",
      "why": "Two hours of conversation is not exhausting. Two hours of being marked is, and it is why you were worse company by the end than the start."
    },
    {
      "situation": "You can remember everything you said and very little of what they said.",
      "line": "(that is the tell)",
      "why": "Attention was pointed inward all evening. Whatever else happened, you did not find out much about them."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What actually makes a first date exhausting?",
      "options": [
        { "text": "Talking to somebody new for two hours.", "correct": false, "note": "You do that at work without needing to lie down afterwards." },
        { "text": "The monitoring running underneath it.", "correct": true, "note": "Am I doing well, did that land, do they like me — continuously, for two hours. The conversation was never the tiring part." },
        { "text": "The stakes.", "correct": false, "note": "Stakes explain why you monitor. The monitoring is what costs the energy." },
        { "text": "Having to be interesting.", "correct": false, "note": "A symptom of the same posture, and a smaller part of the bill than the checking." }
      ],
      "explain": "Two hours of talking is not tiring. Two hours of being marked is."
    },
    {
      "prompt": "What is the strangest cost of auditioning?",
      "options": [
        { "text": "You seem less confident.", "correct": false, "note": "You do, and that is the cost people expect and the least interesting one." },
        { "text": "You forget what they told you.", "correct": false, "note": "Real, and it is a symptom rather than the outcome that matters." },
        { "text": "You are worse company by the end.", "correct": false, "note": "True, and it is the second-order effect. There is a stranger one." },
        { "text": "Second dates with people you did not enjoy.", "correct": true, "note": "The evening got scored on how it went rather than on whether you liked it, and nobody ever asked the second question." }
      ],
      "explain": "The question you did not ask is the one that decides what happens next."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "noticed", "label": "Noticed the posture", "description": "Caught themselves monitoring rather than participating." },
      { "key": "redirected", "label": "Redirected the attention", "description": "Moved it from how they were doing to what was happening." },
      { "key": "less_tired", "label": "Stopped marking", "description": "Let things land without scoring them." },
      { "key": "remembered_them", "label": "Remembered them", "description": "Came away knowing what the other person said." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The next morning. A friend asks how it went, and you realise you can recite everything you said and almost nothing they said.",
    "partner": {
      "name": "Sam",
      "role": "a friend asking about the date",
      "personality": "Asks about the other person, repeatedly, and notices when every answer comes back to how the user did.",
      "mood": "Curious, affectionate.",
      "openness": 5
    },
    "opening_beat": "\"So what are they actually like?\"",
    "success_looks_like": "The user notices the attention was pointed inward all evening.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Keep asking about the other person whenever an answer is about the user's performance.",
      "Be warm and pleased when the user describes them properly.",
      "Never name the pattern yourself."
    ]
  }$j$::jsonb,
  $md$Today, catch yourself checking how you are doing in one conversation. Log what you were checking and what you missed while doing it.$md$
),
(
  (select id from public.skills where slug = 'do-you-like-them'),
  2,
  'Am I enjoying this?',
  $md$Two questions are available on a first date and only one of them can be answered.

*Is this going well?* requires you to guess at another person's inner state from across a table, using signals you cannot verify, while nervous. Nobody is good at it, and being wrong in either direction is common — people leave dates certain it went badly and get a message that evening, and vice versa.

*Am I enjoying this?* you can answer instantly and accurately at any second of the evening.

**The move:** ask the second one, on purpose, about twenty minutes in.

It is a deliberate act rather than a mood, and it takes about three seconds. Somewhere in the first half hour, stop and check: *right now, am I enjoying myself?* The answer arrives immediately and it is almost never ambiguous.

What it does is bigger than the answer. Asking it moves your attention from a guess to an observation, and attention that has stopped guessing is available for the conversation — which, in one of the more useful ironies in this app, is exactly what makes the first question go well too. Somebody genuinely absorbed in a conversation is much better company than somebody monitoring one.

The answer is also useful in itself. If it is yes, you know what to do at the end and you can stop wondering. If it is no, you have ninety minutes to find out whether it is the situation or the person — and those are genuinely different, because the first ten minutes of anything can be flat.

And it is worth having a specific answer rather than a general feeling. *Yes, particularly when they were being rude about their own job* is information. *It's fine* is the monitoring in disguise, because *fine* is a score.

If you keep one thing: ask a question you can answer. The other one is a guess you will be making for two hours and cannot check.$md$,
  $j$[
    {
      "situation": "Twenty minutes in and you are trying to work out how it is going.",
      "line": "(ask whether you are enjoying it instead)",
      "why": "One is a guess about somebody else's inner state made while nervous. The other you can answer instantly and accurately."
    },
    {
      "situation": "You check, and the answer is yes — particularly when they were being rude about their own job.",
      "line": "(that is a real answer)",
      "why": "Specific beats general. It's fine is the monitoring in disguise, because fine is a score rather than an observation."
    },
    {
      "situation": "You check and the answer is no, ten minutes in.",
      "line": "(ninety minutes to find out whether it is them or the situation)",
      "why": "The first ten minutes of anything can be flat. A no at minute ten is information about the opening, not yet about the person."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is is this going well the wrong question?",
      "options": [
        { "text": "It is pessimistic.", "correct": false, "note": "It is neutral in tone. The problem is that it cannot be answered rather than how it feels." },
        { "text": "It makes you self-conscious.", "correct": false, "note": "It does, and that is a consequence of the deeper issue." },
        { "text": "You cannot answer it.", "correct": true, "note": "It requires guessing at somebody's inner state from across a table, while nervous. People leave certain it went badly and get a message that evening." },
        { "text": "It puts pressure on the evening.", "correct": false, "note": "Vague. Name the mechanism: there is no way to check your answer." }
      ],
      "explain": "Ask a question you can answer. The other one is a guess you cannot verify."
    },
    {
      "prompt": "What does asking the better question actually change?",
      "options": [
        { "text": "It lowers the stakes.", "correct": false, "note": "The stakes are what they are. What changes is where your attention is." },
        { "text": "It gives you a reason to leave early.", "correct": false, "note": "It might, and that is an outcome rather than the mechanism." },
        { "text": "It stops you caring what they think.", "correct": false, "note": "You are allowed to care. This is about which question you are working on." },
        { "text": "Attention that has stopped guessing is available for the conversation.", "correct": true, "note": "Which is why it makes the first question go well too — somebody absorbed in a conversation is much better company than somebody monitoring one." }
      ],
      "explain": "It is a deliberate check, about twenty minutes in, and it takes three seconds."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked", "label": "Actually checked", "description": "Stopped and asked the question on purpose." },
      { "key": "answerable", "label": "Asked the answerable one", "description": "About their own enjoyment rather than about how it was landing." },
      { "key": "specific", "label": "Got a specific answer", "description": "Named what they were enjoying rather than settling for fine." },
      { "key": "acted", "label": "Used the answer", "description": "Let it inform the rest of the evening." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Twenty-five minutes in. You have stepped away for a moment and your phone has a message on it.",
    "partner": {
      "name": "Sam",
      "role": "a friend messaging you mid-date",
      "personality": "Asks the direct question and is unimpressed by answers about how it is landing.",
      "mood": "Nosy, affectionate.",
      "openness": 5
    },
    "opening_beat": "\"Well? How's it going?\"",
    "success_looks_like": "The user answers about their own enjoyment rather than about how it seems to be going.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask again, more directly, if the answer is about what the other person seems to think.",
      "Accept and be pleased by any specific answer about the user's own experience.",
      "Never state the reframe yourself."
    ]
  }$j$::jsonb,
  $md$Today, stop once in a conversation and ask whether you are enjoying it. Log the answer and how specific you could be.$md$
),
(
  (select id from public.skills where slug = 'do-you-like-them'),
  3,
  'What to actually notice',
  $md$*Am I enjoying this* is easy to ask and surprisingly easy to fudge, because two hours of politeness produces a general glow that is not the same as liking somebody. So it helps to have specific things to look at.

**The move:** check four things, all of them about you.

**Are you talking, or performing?** Performing has a particular feel: you are selecting, editing, choosing the better version. Talking does not. If you notice you have not edited anything for ten minutes, that is a strong signal, and it is the most reliable one on the list.

**Do you want to tell them things?** Not answer things — tell them. The urge to say *oh, this is like the thing I was saying earlier* is genuine interest making itself known, and its absence is worth registering. Two hours of good answers and no urge to volunteer anything is a quiet no.

**Did you laugh, or produce a laugh?** Everybody produces laughs on a first date and they are worth nothing as evidence. One real one is worth the whole evening as information.

**Would you be relieved or disappointed if they had to leave in ten minutes?** This is the most brutally accurate question in the topic. The answer arrives before you can arrange it and it is very rarely wrong.

Two things worth ruling out while you are at it. Nervousness is not dislike, and they feel similar from inside — do not read your own adrenaline as a verdict on them. And attraction on a first date is frequently not there yet even when everything else is; its absence at hour two is not the answer people treat it as.

If you keep one thing: the ten-minutes question. Ask it once, take the first answer, and do not negotiate with it.$md$,
  $j$[
    {
      "situation": "You realise you have not edited anything you said for ten minutes.",
      "line": "(that is the strongest signal there is)",
      "why": "Performing has a particular feel — selecting, choosing the better version. Its absence is the most reliable thing on the list."
    },
    {
      "situation": "You have answered everything well and volunteered nothing.",
      "line": "(that is a quiet no)",
      "why": "The urge to tell somebody something is genuine interest making itself known. Two hours without it is worth registering."
    },
    {
      "situation": "They say they might have to go in ten minutes.",
      "line": "(relieved or disappointed?)",
      "why": "The most accurate question in the topic. The answer arrives before you can arrange it and it is very rarely wrong."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which signal is the most reliable?",
      "options": [
        { "text": "Whether the conversation flowed.", "correct": false, "note": "Flow is mostly about the two of you being polite and reasonably good at talking. Plenty of flowing conversations lead nowhere." },
        { "text": "Whether you laughed a lot.", "correct": false, "note": "Everybody produces laughs on a first date. One real one is information; a lot of them is manners." },
        { "text": "Whether you stopped editing what you said.", "correct": true, "note": "Performing has a distinct feel — selecting, choosing the better version. Ten minutes without it is the strongest signal available." },
        { "text": "Whether you found them attractive.", "correct": false, "note": "Frequently not there yet on a first date even when everything else is, and its absence at hour two is not the verdict people treat it as." }
      ],
      "explain": "All four checks are about you, because you are the only person whose inner state you can actually read."
    },
    {
      "prompt": "They say they may have to leave in ten minutes. What is that useful for?",
      "options": [
        { "text": "Finding out whether they are interested.", "correct": false, "note": "It tells you something about their evening and nothing reliable about their interest." },
        { "text": "Deciding whether to say the plain thing.", "correct": false, "note": "That comes later and follows from the answer rather than being it." },
        { "text": "Nothing — it is just logistics.", "correct": false, "note": "The logistics are irrelevant. What matters is the half-second before you decide how to feel about it." },
        { "text": "Your first reaction, which arrives before you can arrange it.", "correct": true, "note": "Relieved or disappointed. It is the most brutally accurate question in the topic, and it is very rarely wrong." }
      ],
      "explain": "Take the first answer and do not negotiate with it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "editing", "label": "Noticed whether they were editing", "description": "Checked for performing rather than talking." },
      { "key": "volunteering", "label": "Noticed the urge to tell them things", "description": "Registered whether anything wanted to be volunteered." },
      { "key": "first_reaction", "label": "Took the first reaction", "description": "Used the relieved-or-disappointed answer without negotiating it." },
      { "key": "ruled_out", "label": "Did not confuse nerves with dislike", "description": "Read their own adrenaline as adrenaline." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "An hour and a half in. It has been pleasant throughout and you genuinely cannot tell what you think.",
    "partner": {
      "name": "Sam",
      "role": "a friend you are messaging afterwards",
      "personality": "Asks the four questions one at a time and will not accept it was nice as an answer to any of them.",
      "mood": "Patient, direct.",
      "openness": 5
    },
    "opening_beat": "\"Okay, forget whether it went well. Did you stop editing yourself at any point?\"",
    "success_looks_like": "The user answers with specific observations rather than a general impression.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask one specific check at a time and reject general impressions.",
      "Accept a specific observation warmly, whether it points to yes or no.",
      "Never tell the user what their answer means."
    ]
  }$j$::jsonb,
  $md$Today, run the four checks on one conversation. Log the one that gave you the clearest answer.$md$
),
(
  (select id from public.skills where slug = 'do-you-like-them'),
  4,
  'It is allowed to be a no',
  $md$This whole track collapses unless the no is genuinely available, and for a lot of people it is not — not in principle, but in practice, which is a different and more stubborn thing.

The reasons are usually unspoken. It felt like it went well, and turning down something that went well seems ungrateful. They were nice, and *nice* has quietly become a reason. Nobody else has come along. It has been a while. You are not sure you can afford to be fussy.

**The move:** notice that not fancying somebody is a complete reason, and does not need a fault attached.

That is the specific trap. People go looking for something wrong with the person, because a flaw would justify the decision — and if they cannot find one, they conclude they should give it another go. But *I did not enjoy myself* requires no supporting evidence. It is not an accusation about them, it does not need to be defensible, and it is not something you have to be able to explain to a friend.

Second dates arranged out of politeness are the most common waste of time in dating, and they are not kind to anybody. The other person is spending an evening with somebody who has already decided. Nobody is served by that, including the version of you who would rather not have gone.

There is a version of this specific to people who do not get many dates, and it is worth naming: scarcity makes the no feel expensive. It is not. Saying yes to something you did not enjoy does not increase your chances of anything, it just fills a Thursday and reinforces the idea that dating is an ordeal to be endured.

And the reframe that makes it bearable: an evening that produced a clear no was a successful evening. That was the question. You answered it in two hours, which is fast.

If you keep one thing: you do not need a reason beyond not wanting to. Looking for a fault to justify it is how people talk themselves into a second date.$md$,
  $j$[
    {
      "situation": "It went well and you did not enjoy it, and those are both true.",
      "line": "(that is allowed, and it is complete)",
      "why": "Turning down something that went well feels ungrateful. It is not — going well was never the question you were there to answer."
    },
    {
      "situation": "You are looking for something wrong with them to justify the decision.",
      "line": "(you do not need a fault)",
      "why": "A flaw would make it defensible, and if you cannot find one you talk yourself into another go. I did not enjoy myself needs no supporting evidence."
    },
    {
      "situation": "It has been a long time since the last date.",
      "line": "(scarcity does not make the no expensive)",
      "why": "Saying yes to something you did not enjoy does not increase your chances of anything. It fills a Thursday and confirms that dating is an ordeal."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why do people go looking for a fault?",
      "options": [
        { "text": "Because they are being fair.", "correct": false, "note": "It looks like fairness and it functions as a requirement for permission." },
        { "text": "Because a flaw would justify the decision.", "correct": true, "note": "And if none can be found, they conclude they should give it another go. Not wanting to is already a complete reason." },
        { "text": "Because otherwise they will regret it.", "correct": false, "note": "That is a different fear, and it is not what the fault-hunting is for." },
        { "text": "Because friends will ask why.", "correct": false, "note": "Sometimes, and the honest answer to a friend is the same as the honest answer to yourself." }
      ],
      "explain": "I did not enjoy myself is not an accusation and does not have to be defensible."
    },
    {
      "prompt": "Who does a politeness second date serve?",
      "options": [
        { "text": "Them — it is kinder than a no.", "correct": false, "note": "They are spending an evening with somebody who has already decided. That is not the kind version." },
        { "text": "Nobody.", "correct": true, "note": "Including the version of you who would rather not have gone, and who now has one fewer free evening and slightly more evidence that dating is an ordeal." },
        { "text": "You — you might change your mind.", "correct": false, "note": "It happens occasionally. It is not a plan, and going in order to check is a different thing from going because you want to." },
        { "text": "Both of you, a bit.", "correct": false, "note": "The comfortable answer, and it is how a fortnight of politeness gets arranged." }
      ],
      "explain": "An evening that produced a clear no was a successful evening. That was the question."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "allowed", "label": "Allowed the no", "description": "Treated not wanting to as a complete reason." },
      { "key": "no_fault", "label": "Did not hunt for a fault", "description": "Avoided needing something wrong with them to justify it." },
      { "key": "no_scarcity", "label": "Ignored scarcity", "description": "Did not treat a thin run as a reason to say yes." },
      { "key": "clean", "label": "Called it a success", "description": "Treated a clear answer as the point of the evening." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The morning after. It was perfectly pleasant, they were perfectly nice, and you do not want to see them again — and you are struggling to say that out loud.",
    "partner": {
      "name": "Sam",
      "role": "a friend asking how it went",
      "personality": "Asks whether the user wants to see them again, and keeps returning to it when the answer becomes an assessment of the other person.",
      "mood": "Warm and unhurried.",
      "openness": 5
    },
    "opening_beat": "\"Right, but do you want to see them again?\"",
    "success_looks_like": "The user says no without needing a fault to justify it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Return to the question whenever the answer becomes about what the other person was like.",
      "Accept a plain no immediately and without asking why.",
      "Never suggest a reason for the user."
    ]
  }$j$::jsonb,
  $md$Today, decline one small thing without giving a reason. Log what you declined and whether you added a justification anyway.$md$
),
(
  (select id from public.skills where slug = 'do-you-like-them'),
  5,
  'You do not have to know',
  $md$Between yes and no there is a third answer, and it is the most common one after a real first date: you do not know yet.

That is not indecision and it is not a soft no. Most people cannot tell from two hours whether they like somebody, because two hours is not very long and both of you were slightly performing for the first thirty minutes of it. Expecting certainty is the mistake, and it produces two bad outcomes: people talk themselves into a yes they do not feel, or they treat the absence of a clear yes as a no and quietly delete something that was going to be good.

**The move:** treat *I would like to find out* as a complete position.

It is a real answer and it is enough to act on. A second date is not a commitment, it is the rest of the question — and it is a far better instrument for answering it than another hour of thinking about the first one.

There is a specific test that helps here, and it is different from the ones in the earlier lessons because it looks forward rather than back. Not *do I like them*, but *would I be pleased to see their name on my phone on Thursday?* Uncertainty about the person often resolves instantly into a clear answer about the prospect.

The one thing not to do is stay in the middle for a fortnight. Uncertainty is fine as a position and expensive as a habit: the message goes unanswered, the moment cools, and a genuine maybe becomes a no by default — which is the same outcome as deciding, without the benefit of having decided.

And it applies to the slow ones. Plenty of good things started with two people who thought the first date was fine. Fine is not a failure state, it is an ordinary starting point, and the people who insist on certainty from a first meeting mostly end up with a shorter list.

If you keep one thing: *I do not know yet, and I would like to find out* is an answer. Say it to yourself, then act on it.$md$,
  $j$[
    {
      "situation": "You get home genuinely unsure.",
      "line": "I do not know yet, and I would like to find out.",
      "why": "A complete position and enough to act on. A second date is not a commitment, it is the rest of the question."
    },
    {
      "situation": "You cannot tell whether you like them.",
      "line": "(would you be pleased to see their name on Thursday?)",
      "why": "It looks forward rather than back, and uncertainty about a person often resolves instantly into a clear answer about the prospect."
    },
    {
      "situation": "It has been five days and you are still deciding.",
      "line": "(that is a no arriving by default)",
      "why": "Uncertainty is fine as a position and expensive as a habit. The moment cools and you get the same outcome without having decided anything."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is expecting certainty a mistake?",
      "options": [
        { "text": "Because attraction takes time.", "correct": false, "note": "Often true and it is one instance rather than the general point." },
        { "text": "Because two hours is not very long, and both of you were performing for part of it.", "correct": true, "note": "Most people cannot tell from a first date, which is ordinary. Demanding certainty produces either a manufactured yes or a no by default." },
        { "text": "Because you will always find doubts.", "correct": false, "note": "A different problem, and one that applies to people who are certain too." },
        { "text": "Because it puts pressure on the second date.", "correct": false, "note": "It does not, particularly. The cost falls on whether there is one at all." }
      ],
      "explain": "I would like to find out is a real answer, not a failure to have one."
    },
    {
      "prompt": "What is the useful question when you cannot tell?",
      "options": [
        { "text": "What would I regret more?", "correct": false, "note": "Regret-minimising asks you to model two futures, which is harder than the thing you were already struggling with." },
        { "text": "Do I fancy them?", "correct": false, "note": "Frequently not resolved on a first date even when everything else is, so it does not break the tie." },
        { "text": "Would I be pleased to see their name on my phone on Thursday?", "correct": true, "note": "It looks forward rather than back, and uncertainty about a person often resolves instantly into a clear answer about the prospect." },
        { "text": "What did my friends think of them?", "correct": false, "note": "They have not met them. And it hands a question that is yours to somebody else." }
      ],
      "explain": "Ask about Thursday, not about them."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "allowed_maybe", "label": "Allowed not knowing", "description": "Treated uncertainty as a position rather than a failure." },
      { "key": "acted", "label": "Acted on it", "description": "Did not wait for certainty before doing anything." },
      { "key": "forward_test", "label": "Asked the forward question", "description": "Checked how they felt about the prospect rather than about the evening." },
      { "key": "no_drift", "label": "Did not drift", "description": "Avoided letting a maybe become a no by default." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The next day. It was good in parts, flat in others, and you genuinely do not know what you think.",
    "partner": {
      "name": "Sam",
      "role": "a friend asking about it",
      "personality": "Comfortable with not knowing and impatient with drift. Asks what the user is going to do about it.",
      "mood": "Practical.",
      "openness": 5
    },
    "opening_beat": "\"So it is a maybe. What are you going to do about it?\"",
    "success_looks_like": "The user treats not knowing as a position and acts on it anyway.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Accept I do not know as a real answer without pushing for a verdict.",
      "Push firmly on any plan that involves waiting to see how they feel.",
      "Never tell the user what to decide."
    ]
  }$j$::jsonb,
  $md$Today, act on one thing you are only half sure about instead of waiting to be certain. Log what you did.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('do-you-like-them', 1, 'choice', $j${
  "beats": [
    {
      "situation": "You get home from two hours of perfectly pleasant conversation and you are completely drained.",
      "prompt": "What tired you?",
      "options": [
        { "text": "Talking to somebody new for two hours.", "correct": false, "note": "You do that at work regularly without needing to lie down afterwards." },
        { "text": "The monitoring running underneath it.", "correct": true, "note": "Am I doing well, did that land, do they like me — continuously, for two hours. The conversation was never the expensive part." },
        { "text": "The nerves beforehand.", "correct": false, "note": "Those dropped ten minutes in. This is a different bill and it ran all evening." },
        { "text": "Having to be interesting for that long.", "correct": false, "note": "A symptom of the same posture, and a smaller part of the total." }
      ]
    },
    {
      "situation": "A friend asks what they are actually like. You realise you can recite everything you said and very little of what they said.",
      "prompt": "What does that tell you?",
      "options": [
        { "text": "They did not say very much.", "correct": false, "note": "They probably said plenty. Attention was pointed elsewhere for most of it." },
        { "text": "It was a bad date.", "correct": false, "note": "It might have been a fine date. What you know is where your attention went, not what happened." },
        { "text": "You were nervous.", "correct": false, "note": "True and not specific enough to act on. Nerves do not by themselves stop you hearing people." },
        { "text": "You spent the evening auditioning.", "correct": true, "note": "The tell. Whatever else happened, you did not come away having found out much about them — which was the only thing that was yours to find out." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('do-you-like-them', 2, 'line', $j${
  "says": "Well? How's it going?",
  "model": {
    "line": "I am enjoying it, actually — mostly when they are being rude about their own job.",
    "why": "An answer about your own experience, which you can give instantly and accurately, rather than a guess about theirs. And specific, because fine is a score in disguise."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Answer about you, not about how it is landing" },
    { "kind": "forbids_any", "requirement": "Not a guess at their inner state",
      "words": ["they seem", "i think they", "hard to tell", "hope they", "they might", "going well", "going badly", "no idea if"] },
    { "kind": "min_words", "requirement": "Say what specifically", "n": 8 },
    { "kind": "max_words", "requirement": "One line — you are in a toilet", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('do-you-like-them', 3, 'choice', $j${
  "beats": [
    {
      "situation": "Ninety minutes in. It has flowed, you have both laughed a lot, and you genuinely cannot tell what you think.",
      "prompt": "Which of these is worth anything as evidence?",
      "options": [
        { "text": "The conversation flowed the whole way.", "correct": false, "note": "Flow mostly means two polite people who are reasonably good at talking. Plenty of flowing conversations lead nowhere at all." },
        { "text": "You have both laughed a lot.", "correct": false, "note": "Everybody produces laughs on a first date. One real one is information; a lot of them is manners." },
        { "text": "You have not edited anything you said for ten minutes.", "correct": true, "note": "Performing has a distinct feel — selecting, choosing the better version. Its absence is the strongest signal available." },
        { "text": "They have asked you a lot of questions.", "correct": false, "note": "Information about them, possibly, and this whole track is about reading you." }
      ]
    },
    {
      "situation": "They mention they may have to leave in ten minutes.",
      "prompt": "What do you do with that?",
      "options": [
        { "text": "Work out whether it means they want to go.", "correct": false, "note": "Back to guessing at somebody else's inner state, which is the thing this track exists to stop." },
        { "text": "Notice whether your first reaction was relief or disappointment.", "correct": true, "note": "The most brutally accurate question in the topic. The answer arrives before you can arrange it, and it is very rarely wrong." },
        { "text": "Suggest one more drink to see what they say.", "correct": false, "note": "A test of them rather than a reading of you, and it makes the evening a negotiation." },
        { "text": "Nothing — it is just logistics.", "correct": false, "note": "The logistics are irrelevant. The useful thing is the half-second before you decide how to feel about it." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('do-you-like-them', 4, 'line', $j${
  "says": "Right, but do you want to see them again?",
  "model": {
    "line": "No. They were perfectly nice and I did not enjoy myself, and I think that is enough.",
    "why": "No fault attached and none needed. Looking for something wrong with them is how people talk themselves into a second date they did not want."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "You do not need a fault to justify it",
      "words": ["a bit boring", "too keen", "annoying", "something off", "not attractive", "the way they", "kept talking about", "rude"] },
    { "kind": "min_words", "requirement": "Say it, do not trail off", "n": 6 },
    { "kind": "max_words", "requirement": "It does not need a case", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('do-you-like-them', 5, 'line', $j${
  "says": "So it is a maybe. What are you going to do about it?",
  "model": {
    "line": "Ask them out again. I do not know yet and I would be pleased to see their name on Thursday, which is enough to go on.",
    "why": "Not knowing is a position rather than a failure to have one, and a second date is the rest of the question rather than a commitment. The forward test broke the tie."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not wait to be certain",
      "words": ["see how i feel", "wait and see", "leave it a few", "if they message", "sleep on it", "give it a week", "see if they"] },
    { "kind": "min_words", "requirement": "Say what you are actually going to do", "n": 10 },
    { "kind": "max_words", "requirement": "A decision, not a deliberation", "n": 40 }
  ]
}$j$::jsonb);
