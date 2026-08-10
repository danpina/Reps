-- The first date, track 4: What happens next.
--
-- Three of the five are about getting to a second date, which is the point of
-- the reframe: the old name put the emphasis on getting out, and a nervous
-- reader's attention is there already.
--
-- The bad date and the safety case live in lesson one, because ending an
-- evening deliberately is one move whether it went well or not.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'what-happens-next'),
  1,
  'End it before it flattens',
  $md$Two good hours leaves both of you wanting the next one. Five hours flattens the same evening into something neither of you can quite face repeating — and the instinct to keep going *because* it is going well is precisely the instinct to distrust.

**The move:** use the finish time you named on arrival.

It is already there, said lightly in the first two minutes, and this is what it was for. *I should probably go* at the good moment costs nothing and it is what turns an evening into something with a shape. If you want to stay, staying then becomes a choice somebody made out loud — *actually, do you want another one?* — which is a much better moment than two hours that merely continued.

The same move ends a bad one, which is why they are one lesson. Endurance is the quiet person's failure here: three hours of politeness and then home, angry at yourself, when both of you knew at minute twenty. Politeness that costs you an evening is not kindness, because the other person is having the same evening. *I should get going — it was good to meet you* needs no reason attached to it and nobody has ever asked for one.

Do not perform enthusiasm you do not have on the way out. False warmth at the door is what produces four days of texting to undo, and it is unkinder than the plain version by a wide margin.

One case is not like the others. Being uninterested and being uncomfortable are different, and if somebody makes you feel unsafe then none of the etiquette above applies — leave, immediately, and badly if that is what it takes. Tell somebody where you are going before you go, which costs one message and is worth having done.

If you keep one thing: end it on purpose. Both the good version and the bad one go wrong the same way, which is by nobody deciding anything.$md$,
  $j$[
    {
      "situation": "It is going well and the time you named is coming up.",
      "line": "I should probably go — do you want another one first?",
      "why": "Staying becomes a choice somebody made out loud, which is a much better moment than two hours that merely continued."
    },
    {
      "situation": "You knew at minute twenty and it is now hour two.",
      "line": "I should get going — it was good to meet you.",
      "why": "No reason attached, and nobody has ever asked for one. Politeness that costs you an evening is not kindness, because they are having the same evening."
    },
    {
      "situation": "Something about this feels wrong rather than just flat.",
      "line": "(then leave, and none of the etiquette applies)",
      "why": "Uninterested and uncomfortable are different. Leave immediately, badly if necessary, and tell somebody where you are before you go."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why leave while it is still going well?",
      "options": [
        { "text": "To seem less available.", "correct": false, "note": "A tactic, and a slightly grubby one. This is not about managing their impression." },
        { "text": "Two good hours leaves you both wanting the next one.", "correct": true, "note": "Five hours flattens the same evening into something neither of you can face repeating. The instinct to continue because it is good is the one to distrust." },
        { "text": "You will run out of things to say.", "correct": false, "note": "Usually you will not, and that is not what does the damage." },
        { "text": "Late nights make people regret things.", "correct": false, "note": "Occasionally, and it is a different concern from the one this lesson is about." }
      ],
      "explain": "Use the finish time you named on arrival. That is what it was for."
    },
    {
      "prompt": "Why are the good ending and the bad ending one lesson?",
      "options": [
        { "text": "Because they use the same words.", "correct": false, "note": "The words differ slightly. The thing underneath them does not." },
        { "text": "Because you often cannot tell which one you are in.", "correct": false, "note": "You usually can, by two hours in. This is not about ambiguity." },
        { "text": "Because both go wrong by nobody deciding anything.", "correct": true, "note": "A good evening drifts to five hours and flattens; a bad one drifts to three and is endured. The move is ending it on purpose either way." },
        { "text": "Because leaving is leaving.", "correct": false, "note": "True and empty. Name what the two failures actually share." }
      ],
      "explain": "End it on purpose. Drift is the failure in both directions."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "on_purpose", "label": "Ended it deliberately", "description": "Decided rather than drifted." },
      { "key": "early", "label": "Left before it flattened", "description": "Went while it was still good." },
      { "key": "no_reason", "label": "Needed no excuse", "description": "Left a poor one without inventing a justification." },
      { "key": "no_false_warmth", "label": "Did not perform enthusiasm", "description": "Stayed honest on the way out." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Two hours in. It has been good. You said on arrival that you had to be somewhere at eight, and it is ten to.",
    "partner": {
      "name": "Robin",
      "role": "the person you are on a date with",
      "personality": "Would happily stay another two hours and will not suggest ending it. Responds warmly to somebody who ends it cleanly.",
      "mood": "Enjoying it, in no hurry.",
      "openness": 4
    },
    "opening_beat": "\"...I have completely lost track of the time, actually. Have you?\"",
    "success_looks_like": "The user ends the evening deliberately rather than letting it run on.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Never suggest ending the evening yourself.",
      "Respond warmly and easily to a clean ending.",
      "Happily agree to one more drink if it is offered as a choice rather than a drift."
    ]
  }$j$::jsonb,
  $md$Today, end one conversation deliberately while it is still going well. Log when you left and how it felt.$md$
),
(
  (select id from public.skills where slug = 'what-happens-next'),
  2,
  'Say the plain thing',
  $md$Every earlier track in this app taught deniability. A notch, offered and released. Nothing declared, everything receivable as ordinary friendliness. That was right, and it was right for a specific reason: you were dealing with strangers whose interest was unknown, and deniability is what makes a move safe to offer and easy to decline.

By the end of a first date, that has been earned. Somebody agreed to meet you, showed up, and spent two hours with you. Continuing to be deniable now does not read as tact — it reads as indifference, and the most common way a good first date produces nothing is both people leaving it ambiguous out of politeness.

**The move:** say it plainly — *I would like to do this again.*

That is the whole sentence. It is not a declaration of feeling, it does not ask them to reciprocate on the spot, and it contains no adjective about them that would need answering.

What to leave out. *We should do this again sometime* is the deniable version and it dies where it stands — it is a sentiment rather than a statement, and the correct reply to it is *yeah, definitely*, which is also a sentiment, and then nothing happens. *If you fancy it* and *no pressure* belong on the ask, not on this: you are not asking for anything yet, you are telling them something.

And do not stack it with reasons. *I would like to do this again, I have really enjoyed it, you are very easy to talk to, I do not know if you feel the same* is one sentence and three retreats, and the retreats are what they will answer.

Then stop and let them respond. This is the same two seconds as the number in a pay conversation, and the same rule holds: whoever speaks first into that gap is negotiating against themselves.

If you keep one thing: say it as a statement about you. It is the least risky true thing available and almost nobody says it.$md$,
  $j$[
    {
      "situation": "The evening is ending and it went well.",
      "line": "I would like to do this again.",
      "why": "A statement about you rather than a question about them. Nothing to reciprocate on the spot and no adjective that needs answering."
    },
    {
      "situation": "You are about to say we should do this again sometime.",
      "line": "(that is a sentiment, and it dies there)",
      "why": "The correct reply is yeah definitely, which is also a sentiment, and then nothing happens. Deniability was for strangers."
    },
    {
      "situation": "You said it and there is a pause.",
      "line": "(say nothing)",
      "why": "The same two seconds as a number in a pay conversation. Whoever fills it is negotiating against themselves."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why drop the deniability now?",
      "options": [
        { "text": "Because you know them better.", "correct": false, "note": "Two hours is not knowing somebody. What has changed is what has been demonstrated rather than what you know." },
        { "text": "Because it has been earned — they agreed, showed up, and stayed two hours.", "correct": true, "note": "Deniability is what makes a move safe to offer to a stranger whose interest is unknown. Here it reads as indifference instead of tact." },
        { "text": "Because being direct is more attractive.", "correct": false, "note": "Sometimes, and it is a claim about style rather than the reason the rule changes." },
        { "text": "Because they will do it if you do not.", "correct": false, "note": "Frequently neither of you does, which is exactly the problem." }
      ],
      "explain": "The commonest way a good first date produces nothing is both people being polite about it."
    },
    {
      "prompt": "What is wrong with stacking reasons after it?",
      "options": [
        { "text": "It takes too long.", "correct": false, "note": "Length is not the issue. A long warm sentence would be fine if it were not retreating." },
        { "text": "It sounds insecure.", "correct": false, "note": "How it sounds is downstream. What matters is what they end up answering." },
        { "text": "The retreats are what they will answer.", "correct": true, "note": "I do not know if you feel the same is now the live question, and they will address that rather than the thing you actually said." },
        { "text": "It gives them too many exits.", "correct": false, "note": "Close, and exits are fine here — this is not an ask. The problem is that you moved the subject." }
      ],
      "explain": "One sentence, then stop. The pause belongs to them."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "plain", "label": "Said it plainly", "description": "A statement rather than a sentiment." },
      { "key": "no_hedge", "label": "Did not hedge", "description": "Left out sometime, no pressure and if you fancy it." },
      { "key": "no_stacking", "label": "Did not stack reasons", "description": "One sentence, no retreats after it." },
      { "key": "stopped", "label": "Stopped", "description": "Let the pause be theirs." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Outside, coats on. It has been a good two hours and you are about to walk in different directions.",
    "partner": {
      "name": "Robin",
      "role": "the person you have just been on a date with",
      "personality": "Warm and slightly hesitant, waiting to see whether the user says anything. Answers a plain statement plainly and a sentiment with a sentiment.",
      "mood": "Had a good time, unsure whether to say so first.",
      "openness": 4
    },
    "opening_beat": "\"Well — this was much better than I expected. In a good way.\"",
    "success_looks_like": "The user says plainly that they would like to do it again.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer a plain statement with a plain and warm one.",
      "Answer we should do this again sometime with yeah, definitely, and nothing more.",
      "Never say it first yourself."
    ]
  }$j$::jsonb,
  $md$Today, say one plain thing you would normally leave deniable. Log the sentence and what came back.$md$
),
(
  (select id from public.skills where slug = 'what-happens-next'),
  3,
  'Make the next one real',
  $md$This is the move the whole topic has been building towards, and it is the one you already know — it is the same move as asking for a number and the same move as proposing a drink on an app.

*I would like to do this again* is a statement. It does not, by itself, produce anything. What produces something is what comes immediately after it.

**The move:** something specific, something small, and a day in it.

*There is a place near me that does the thing you were describing — Thursday or Saturday?* is answerable in one word, and one word is what you want. Compare that with *we should sort something out*, which requires them to invent a plan, check a diary and reply properly, and which therefore gets *yes, definitely* and a silence.

Use a callback. The last lesson of the previous track was for exactly this: the place they mentioned, the thing they said they had never tried, the film they were embarrassed about not having seen. A plan built out of something they said an hour ago proves the whole evening was being listened to, and it is far better than anything you could invent on the pavement.

Two days rather than one, for the same reason as everywhere else: two is a choice and one is a summons. And keep it small — a drink or an hour, not a day out. A second date is still an audition for both of you, and the person who proposes something enormous is asking for a commitment neither of you has yet.

If you have not got a plan ready, the number is enough on its own, provided it comes with an intention. *Give me your number and I will find out when that place is open* is a plan waiting to be finished.

If you keep one thing: turn *again sometime* into a day. Everything else in this topic was in service of being able to say that sentence and mean it.$md$,
  $j$[
    {
      "situation": "You have said you would like to do it again.",
      "line": "There is a place near me that does that thing you were describing — Thursday or Saturday?",
      "why": "Specific, small, two days, and built from something they said. Answerable in one word, which is what you want."
    },
    {
      "situation": "You are about to say we should sort something out.",
      "line": "(that asks them to invent the plan)",
      "why": "It needs a diary, an idea and a proper reply, so it gets yes definitely and then nothing."
    },
    {
      "situation": "You have no plan and the moment is now.",
      "line": "Give me your number and I will find out when that place is open.",
      "why": "A plan waiting to be finished, which is enough. What is not enough is a number with no intention attached."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does we should sort something out fail?",
      "options": [
        { "text": "It is too casual.", "correct": false, "note": "Casual is right. The register is not the problem." },
        { "text": "It asks them to invent the plan, the date and the reply.", "correct": true, "note": "Three jobs handed over, so it gets yes definitely — which costs nothing to say and commits to nothing." },
        { "text": "It sounds unenthusiastic.", "correct": false, "note": "It usually sounds warm, which is why it goes unchallenged and produces nothing." },
        { "text": "It is what everybody says.", "correct": false, "note": "It is, and being unoriginal is not what stops it working." }
      ],
      "explain": "Specific, small, a day in it. Answerable in one word."
    },
    {
      "prompt": "Where should the plan come from?",
      "options": [
        { "text": "Something you already wanted to do.", "correct": false, "note": "Perfectly good, and it reads as generic because it existed before they did." },
        { "text": "Something impressive, since it is a second date.", "correct": false, "note": "Raises the stakes and the effort for both of you. A second date is still small." },
        { "text": "Something they said an hour ago.", "correct": true, "note": "It proves the evening was being listened to, which is the last lesson of the previous track doing its job — and it beats anything you could invent on the pavement." },
        { "text": "Wherever is convenient for both of you.", "correct": false, "note": "Logistics as a plan. Convenience is a constraint rather than an idea." }
      ],
      "explain": "The callback becomes the plan. That is what you were listening for."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "specific", "label": "Named something specific", "description": "Proposed an actual thing rather than a sentiment." },
      { "key": "callback", "label": "Used something they said", "description": "Built it out of the evening rather than from a template." },
      { "key": "a_day", "label": "Put days in it", "description": "Offered two rather than one or none." },
      { "key": "small", "label": "Kept it small", "description": "An hour or two, not a day out." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Outside. You have said you would like to do it again and they have said they would too. Earlier they mentioned a place near their flat they have never got round to trying.",
    "partner": {
      "name": "Robin",
      "role": "the person you have just been on a date with",
      "personality": "Says yes immediately to anything with a day in it, and answers a vague suggestion with an equally vague agreement.",
      "mood": "Pleased, about to get a bus.",
      "openness": 4
    },
    "opening_beat": "\"I would like that too, actually. Yes.\"",
    "success_looks_like": "The user proposes something specific with a day in it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Say yes concretely and warmly to anything with a day in it.",
      "Answer a vague suggestion with yeah, we definitely should, and start leaving.",
      "Never propose anything yourself."
    ]
  }$j$::jsonb,
  $md$Today, turn one vague plan with anybody into a specific one with two days in it. Log what you proposed.$md$
),
(
  (select id from public.skills where slug = 'what-happens-next'),
  4,
  'Read the answer',
  $md$You said the thing and proposed the plan. What comes back is one of three answers and only one of them is ambiguous — which is fewer than it feels standing on a pavement at ten o'clock.

**The move:** did they hand back a time, or a reason?

**A time is a yes.** *Thursday is bad but the week after works* is a yes with a diary attached, and it is worth noticing that this is the most common form a real yes takes. People are busy, and busy is not a rejection.

**A reason with no alternative is a no.** *Things are really hectic at the moment.* *Let me look at my week and get back to you.* Both are warm, both are kind, and neither contains a day. Take them at their meaning, say something warm, and go — and above all do not supply the alternative they chose not to supply.

**And genuine hesitation is genuine.** Occasionally somebody is simply caught off guard, or does not know, and says so. *Can I think about it?* is not the soft no — the soft no arrives smoothly, because it has been said before. Hesitation that sounds awkward is usually just awkward.

Then behave the same either way, which is the part that costs something. Do not perform enthusiasm you do not have and do not withdraw warmth you had five minutes ago. Somebody who is charming right up until the answer and then cools has told the other person exactly what the previous two hours were.

The reframe worth keeping, because people take this harder than it is: a no at this point costs you an awkward thirty seconds and a walk to the station. You have lost nothing you had at six o'clock, and you found out in one evening rather than three weeks, which is the good version of this.

If you keep one thing: a time back is a yes, a reason back is a no. It is almost always that legible, and treating it as ambiguous is how people spend a fortnight on a decision that was made on a pavement.$md$,
  $j$[
    {
      "situation": "\"Thursday is bad, but the week after could work?\"",
      "line": "(a time came back — that is a yes)",
      "why": "The most common form a real yes takes. People are busy and busy is not a rejection."
    },
    {
      "situation": "\"Let me look at my week and come back to you.\"",
      "line": "(a reason with no day in it)",
      "why": "Warm, kind, and containing nothing to act on. Take it at its meaning and do not supply the alternative they chose not to."
    },
    {
      "situation": "You have got the answer and it was no.",
      "line": "(stay exactly as warm as you were)",
      "why": "Somebody charming until the answer and cool afterwards has told the other person what the previous two hours were."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the test?",
      "options": [
        { "text": "How enthusiastic they sounded.", "correct": false, "note": "The soft no is the warmest message people send. Warmth is what they use to make it easy on you." },
        { "text": "Whether a day came back.", "correct": true, "note": "A time is a yes with a diary attached. A reason with no alternative is a no, however kindly it is put." },
        { "text": "Whether they said yes.", "correct": false, "note": "Almost everybody says yes to the sentiment. Yes to a day is the one that means something." },
        { "text": "How quickly they answered.", "correct": false, "note": "Fast and vague is extremely common and says more about their manners than their diary." }
      ],
      "explain": "It is almost always that legible. Treating it as ambiguous is how a fortnight gets spent."
    },
    {
      "prompt": "\"Can I think about it?\", said awkwardly.",
      "options": [
        { "text": "A soft no.", "correct": false, "note": "The soft no arrives smoothly, because it has been said before. Awkward hesitation is usually just awkward." },
        { "text": "Stalling — press for an answer.", "correct": false, "note": "Pressing converts a genuine maybe into a no, and quickly." },
        { "text": "Genuine, more often than not.", "correct": true, "note": "Some people are caught off guard and say so. That is the third answer and it is real." },
        { "text": "Impossible to tell.", "correct": false, "note": "The delivery tells you a lot. Smooth is practised; awkward is unrehearsed." }
      ],
      "explain": "Two answers are legible and the third is honestly uncertain. None of them require decoding for a fortnight."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "read_it", "label": "Read it correctly", "description": "Took a time as a yes and a reason as a no." },
      { "key": "no_supplying", "label": "Did not supply the alternative", "description": "Left a no as a no rather than offering another week." },
      { "key": "same_warmth", "label": "Stayed as warm as before", "description": "Did not withdraw or perform after the answer." },
      { "key": "no_dwelling", "label": "Did not dwell", "description": "Treated it as thirty seconds rather than a verdict." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The pavement. You proposed Thursday or Saturday and they are answering.",
    "partner": {
      "name": "Robin",
      "role": "the person you have just been on a date with",
      "personality": "Warm and conflict-avoidant. Declines with a reason rather than a refusal, and becomes uncomfortable if offered an alternative week.",
      "mood": "Kind, not interested in a second date.",
      "openness": 3
    },
    "opening_beat": "\"Ah — things are pretty hectic for me at the moment, to be honest.\"",
    "success_looks_like": "The user reads it as a no and stays warm without pressing.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Never offer a day, however the user rephrases it.",
      "Become visibly uncomfortable if offered an alternative week or asked again.",
      "Warm up and part on good terms if the user accepts it gracefully."
    ]
  }$j$::jsonb,
  $md$Today, take one soft no at face value the first time. Log what was said and what you did with it.$md$
),
(
  (select id from public.skills where slug = 'what-happens-next'),
  5,
  'The message the same day',
  $md$The last thing this topic asks of you takes ninety seconds and almost nobody does it.

**The move:** message the same day, short, referring to something that actually happened.

Same day for the reason it has been the same day everywhere in this app: you are preserving a mood, not proving a point. That evening you are still a person they were sitting opposite. Three days later you are a name, and everything you send has to reintroduce you before it can do anything else. The waiting rules are folklore and they optimise for looking unbothered, which is a strange target after two hours of obviously being bothered.

Refer to the actual thing. *Good to meet you* is a template and reads as one. *I have been thinking about your position on airports and I still disagree* proves it was that evening, with that person, and it hands them something easy to answer.

Short. Two lines. This is not the place to summarise how it went or to say anything you did not say to their face.

And if your answer is no, say so — this is the part people skip and it is the part that matters most to somebody else. One honest message takes ninety seconds. *I really enjoyed meeting you and I do not think it is a romantic thing for me — but genuinely good to meet you* is complete. You will not enjoy sending it, and the alternative is somebody checking their phone for four days and eventually concluding something worse about themselves than the truth.

Silence is not neutral and it is not kind. It is the option that costs you nothing and costs them a week, and everybody who has been on the receiving end knows exactly which one they would have preferred.

If you keep one thing: send something the same day, whichever answer it is. The whole topic ends here, and this is the ninety seconds that decides what any of it was worth.$md$,
  $j$[
    {
      "situation": "You are home and it went well.",
      "line": "Still thinking about your position on airports, and I still disagree. Thursday then?",
      "why": "Same day, one real detail that proves it was that evening, and one easy thing to answer."
    },
    {
      "situation": "You are wondering whether it is too soon.",
      "line": "(you are preserving a mood, not proving a point)",
      "why": "Tonight you are a person they were sitting opposite. Three days later you are a name that has to reintroduce itself."
    },
    {
      "situation": "It was a no and you would rather say nothing.",
      "line": "I really enjoyed meeting you and I do not think it is a romantic thing for me.",
      "why": "Ninety seconds. Silence costs you nothing and costs them a week of checking their phone and concluding something worse than the truth."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why the same day?",
      "options": [
        { "text": "It shows you are interested.", "correct": false, "note": "It does, and enthusiasm is not what the timing is protecting." },
        { "text": "Tonight you are a person; in three days you are a name.", "correct": true, "note": "Everything you send later has to reintroduce you before it can do anything. The waiting rules optimise for looking unbothered, which is an odd goal after two hours." },
        { "text": "They might make other plans.", "correct": false, "note": "A race framing, and mostly untrue over three days." },
        { "text": "You will forget the details.", "correct": false, "note": "You will not forget by Tuesday, and the detail is easy to note down." }
      ],
      "explain": "Short, same day, one thing that actually happened."
    },
    {
      "prompt": "It is a no. What do you send?",
      "options": [
        { "text": "Nothing — they will work it out.", "correct": false, "note": "They will, over about a week of checking their phone, and they will conclude something worse about themselves than the truth." },
        { "text": "A warm message that avoids saying it.", "correct": false, "note": "The worst of both: it restarts the hope and still has to be resolved later." },
        { "text": "One honest sentence, the same day.", "correct": true, "note": "Ninety seconds, and it is the difference between a clean evening and a week of somebody wondering what they did." },
        { "text": "An explanation of why not.", "correct": false, "note": "Not required and rarely wanted. The reason is yours; the answer is what they need." }
      ],
      "explain": "Silence is not neutral. It is the option that costs you nothing and costs them a week."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "same_day", "label": "Sent it the same day", "description": "Did not wait on folklore." },
      { "key": "specific", "label": "Referred to something real", "description": "Named an actual thing from the evening." },
      { "key": "short", "label": "Kept it to two lines", "description": "Did not summarise the evening." },
      { "key": "said_the_no", "label": "Sent the no as well", "description": "Did not use silence as an answer." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Ten in the evening, at home. You spent twenty minutes disagreeing cheerfully about airports, and they mentioned a place near their flat they have never tried.",
    "partner": {
      "name": "Robin",
      "role": "the person you were on a date with this evening",
      "personality": "Replies warmly and quickly to anything specific, and with a single word to anything generic.",
      "mood": "Home, phone in hand.",
      "openness": 4
    },
    "opening_beat": "The message box is empty and it is ten o'clock.",
    "success_looks_like": "The user sends two short lines referring to something that actually happened.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Reply warmly and concretely to anything specific from the evening.",
      "Reply with a single word to anything generic.",
      "Never message first."
    ]
  }$j$::jsonb,
  $md$Today, send one message the same day as the thing it is about, with one real detail in it. Log what you sent.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('what-happens-next', 1, 'choice', $j${
  "beats": [
    {
      "situation": "Two hours in and it has been good. You said on arrival you had to be somewhere at eight. It is ten to.",
      "prompt": "What do you do?",
      "options": [
        { "text": "Stay — it is going well and the eight o'clock thing was invented anyway.", "correct": false, "note": "Five hours flattens the same evening into something neither of you can face repeating. The instinct to continue because it is good is the one to distrust." },
        { "text": "Say you should go, and offer one more as a choice.", "correct": true, "note": "Staying then becomes a decision somebody made out loud rather than two hours that merely continued — and it is a much better moment either way." },
        { "text": "Wait and see whether they mention the time.", "correct": false, "note": "They will not. That is drift, and drift is the failure this lesson is about in both directions." },
        { "text": "Leave promptly at eight without comment.", "correct": false, "note": "Correct on timing and cold on delivery. The finish time was a shape, not a rule to enforce silently." }
      ]
    },
    {
      "situation": "A different evening. You knew at minute twenty, and it is now hour two of politeness.",
      "prompt": "What is the move?",
      "options": [
        { "text": "See it out — you agreed to the evening.", "correct": false, "note": "Endurance. Politeness that costs you an evening is not kindness, because they are having exactly the same evening." },
        { "text": "Invent something you have to get to.", "correct": false, "note": "Unnecessary. Nobody has ever asked for a reason, and inventing one is more to manage on the way out." },
        { "text": "Stay warm and let it wind down naturally.", "correct": false, "note": "Naturally means another hour. Nothing about a date winds down on its own, which is why it needs ending on purpose." },
        { "text": "I should get going — it was good to meet you.", "correct": true, "note": "No reason attached and none needed. The good version and the bad version of the evening end the same way: deliberately." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('what-happens-next', 2, 'line', $j${
  "says": "Well — this was much better than I expected. In a good way.",
  "model": {
    "line": "It was, yes. I would like to do this again.",
    "why": "A statement about you rather than a question about them, with nothing stacked after it. Deniability was for strangers whose interest was unknown, and it has been earned since then."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Say it about yourself" },
    { "kind": "forbids_any", "requirement": "No hedges — this is not the ask, it is the statement",
      "words": ["sometime", "some time", "no pressure", "if you fancy", "if you want", "we should", "maybe", "if you are up for", "i do not know if you"] },
    { "kind": "max_sentences", "requirement": "Say it and stop — the pause is theirs", "n": 2 },
    { "kind": "max_words", "requirement": "One sentence, no reasons stacked after it", "n": 20 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('what-happens-next', 3, 'line', $j${
  "says": "I would like that too, actually. Yes. (Earlier they mentioned a place near their flat they have never got round to trying.)",
  "model": {
    "line": "Then let us do that place near you that you have never tried — Thursday or Saturday?",
    "why": "Specific, small, two days, and built from something they said an hour ago. Answerable in one word, which is exactly what you want on a pavement."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Make it answerable" },
    { "kind": "contains_any", "requirement": "Put days in it",
      "words": ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday", "weekend", "next week", "this week"] },
    { "kind": "forbids_any", "requirement": "A plan, not a sentiment",
      "words": ["sometime", "some time", "sort something", "figure something", "at some point", "let us see", "in touch"] },
    { "kind": "max_words", "requirement": "One sentence on a pavement", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('what-happens-next', 4, 'choice', $j${
  "beats": [
    {
      "situation": "You proposed Thursday or Saturday. \"Ah — things are pretty hectic for me at the moment, to be honest.\"",
      "prompt": "What is that?",
      "options": [
        { "text": "A scheduling problem — offer the week after.", "correct": false, "note": "Supplying the alternative they chose not to supply, which asks them to decline a second time and more directly." },
        { "text": "A no, warmly put.", "correct": true, "note": "A reason came back rather than a day. Warmth is what people use to make it easy on you, and it is not the signal." },
        { "text": "Ambiguous — ask what they mean.", "correct": false, "note": "It is one of the more legible messages you will get. Asking makes them say it plainly, which helps nobody." },
        { "text": "Nerves — they may just be caught off guard.", "correct": false, "note": "That version sounds awkward. This one arrived smoothly, which is what a sentence that has been said before sounds like." }
      ]
    },
    {
      "situation": "You have taken the no. You are both still standing there and the bus is two minutes away.",
      "prompt": "How do you behave?",
      "options": [
        { "text": "Wrap it up quickly — no point drawing it out.", "correct": false, "note": "A fast cool exit tells them what the previous two hours were, which is the one thing you did not mean." },
        { "text": "Say it is completely fine, at some length.", "correct": false, "note": "Performing fine asks them to manage your feelings about their answer, which is what the soft phrasing was trying to spare you both." },
        { "text": "Exactly as warm as you were an hour ago.", "correct": true, "note": "You lost nothing you had at six o'clock and you found out in one evening rather than three weeks. Behaving the same either way is the whole of it." },
        { "text": "Ask whether you read something wrong earlier.", "correct": false, "note": "Turns thirty seconds into a post-mortem, and asks them to account for an evening they were also just living." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('what-happens-next', 5, 'line', $j${
  "says": "Ten in the evening, at home. You spent twenty minutes disagreeing cheerfully about airports, and they mentioned a place near their flat they have never tried.",
  "model": {
    "line": "Still thinking about your airport position and I still disagree. Thursday for that place, then?",
    "why": "Same day, one detail that proves it was that evening with that person, and one easy thing to answer. Ninety seconds, and almost nobody sends it."
  },
  "checks": [
    { "kind": "echoes_any", "requirement": "Refer to something that actually happened",
      "words": ["airport", "airports", "disagree", "place"] },
    { "kind": "forbids_any", "requirement": "Not a template",
      "words": ["good to meet you", "great to meet you", "lovely to meet", "had a nice time", "thanks for tonight", "we should do it again sometime"] },
    { "kind": "max_words", "requirement": "Two lines", "n": 35 }
  ]
}$j$::jsonb);
