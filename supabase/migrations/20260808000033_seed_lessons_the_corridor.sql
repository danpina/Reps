-- Work, track 8: The corridor. The last one.
--
-- Work small talk looks like small talk and is playing for something else,
-- which is why people who are fine at parties can be poor at conferences. It
-- closes the topic because it is the only track here aimed outward — at rooms
-- full of people you do not work with and will not see again unless something
-- is done about it.
--
-- The conference corridor is the scene: no clock, no shared task, and a
-- conversation that has to be ended by one of you.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'the-corridor'),
  1,
  'The target is recognisable',
  $md$Work small talk looks exactly like ordinary small talk and is playing for something different, which is why people who are perfectly good at parties can be miserable at conferences.

Ordinary small talk has succeeded if the two minutes were pleasant. That is the whole of it, and it is why it can be enjoyed for its own sake.

This one has succeeded if you are recognised next time.

**The move:** aim to be a person with a name and one memorable fact. Nothing more.

That target is far lower than the one people set themselves, and setting it correctly changes everything about how the conversation feels. You are not trying to impress anybody. You are not trying to find an opportunity, extract a contact, or be interesting. You are trying to make the *second* conversation start warm — and a second conversation that starts warm is where everything useful actually happens.

Almost all networking advice fails quiet people because it optimises for the first conversation: be memorable, have a pitch, work the room. All of that is exhausting, transparently effortful, and aimed at the wrong thing. Two ordinary minutes with somebody who will recognise you in June beats twenty impressive ones with somebody who will not.

It also means most of these conversations are allowed to be forgettable, which is a relief. You do not need a good one with everybody. You need three or four people across a day who will nod at you next time, and nodding is a very low bar that compounds enormously over a few years.

If you keep one thing: recognisable, not impressive. Impressive is a much harder target that nobody was asking you to hit.$md$,
  $j$[
    {
      "situation": "You are at a conference and dreading the coffee break.",
      "line": "(the target is recognisable, not impressive)",
      "why": "You are trying to be a person with a name and one memorable fact, so the second conversation starts warm. That is the whole objective."
    },
    {
      "situation": "The conversation was pleasant and entirely unremarkable.",
      "line": "(that worked)",
      "why": "Most of these are allowed to be forgettable. Three or four people across a day who will nod at you next time is a good day."
    },
    {
      "situation": "You are planning what to say to sound impressive.",
      "line": "(nobody asked you to be impressive)",
      "why": "It is exhausting, visibly effortful, and aimed at the first conversation — which is not the one where anything useful happens."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "How is work small talk different from ordinary small talk?",
      "options": [
        { "text": "It is more formal.", "correct": false, "note": "Frequently less. Register is not the difference." },
        { "text": "It succeeds if you are recognised next time.", "correct": true, "note": "Ordinary small talk succeeds if two minutes were pleasant. This one is aimed at the second conversation, which is where anything useful happens." },
        { "text": "You need something to say about your work.", "correct": false, "note": "You do, and that is a consequence of the target rather than the target." },
        { "text": "The stakes are higher.", "correct": false, "note": "They are lower per conversation than people think, which is the point of naming the target properly." }
      ],
      "explain": "Recognisable, not impressive. That is a much lower bar and a much better one."
    },
    {
      "prompt": "Why does most networking advice fail a quiet person?",
      "options": [
        { "text": "It assumes you enjoy it.", "correct": false, "note": "Some of it does, and enjoyment is not what determines whether the method works." },
        { "text": "It is aimed at extroverts.", "correct": false, "note": "A label rather than a mechanism, and it does not tell you what to do instead." },
        { "text": "It optimises for the first conversation.", "correct": true, "note": "Be memorable, have a pitch, work the room. All exhausting, all visibly effortful, and all aimed at the conversation that matters least." },
        { "text": "It requires too many conversations.", "correct": false, "note": "Volume is a real cost and it is downstream. Three or four a day is plenty when the target is right." }
      ],
      "explain": "Two ordinary minutes with somebody who recognises you in June beats twenty impressive ones with somebody who does not."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "target", "label": "Aimed at recognisable", "description": "Went for a name and a fact rather than for impact." },
      { "key": "ordinary", "label": "Let it be ordinary", "description": "Allowed a forgettable conversation to be fine." },
      { "key": "no_pitch", "label": "Did not perform", "description": "Avoided visible effort to impress." },
      { "key": "enough", "label": "Knew when it had worked", "description": "Judged it by whether a second conversation would start warm." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The first coffee break at a two-day industry conference. You know nobody and there are about eighty people in the room.",
    "partner": {
      "name": "Theo",
      "role": "somebody else standing near the coffee",
      "personality": "Ordinary, a bit relieved to be talking to somebody. Responds warmly to ordinary conversation and stiffens at anything that sounds like a pitch.",
      "mood": "Also finding this slightly awkward.",
      "openness": 4
    },
    "opening_beat": "\"Is this the good coffee or the other one? I cannot tell any more.\"",
    "success_looks_like": "The user has an ordinary two-minute conversation and swaps names.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Respond warmly to ordinary conversation about the room, the day or the talks.",
      "Cool noticeably at anything that sounds like a pitch or a networking move.",
      "Never ask what the user does for a living first."
    ]
  }$j$::jsonb,
  $md$Today, have one deliberately ordinary conversation with somebody at work you do not normally speak to. Log who.$md$
),
(
  (select id from public.skills where slug = 'the-corridor'),
  2,
  'The thirty-second version',
  $md$*So what do you do?* is the most predictable question in professional life, and almost everybody answers it with a job title, which produces a nod and then a silence that both of you have to survive.

A title is a category, not a hook. *I am a data analyst* tells somebody where to file you and gives them nothing to ask about, so the conversation now depends on their inventiveness rather than on anything you supplied.

**The move:** say the thing you actually work on, in a sentence a stranger could ask a question about.

*I work out why people stop using things halfway through* is the same job described so that it has a handle on it. Anybody can pick that up. *I look after the systems that tell us if we are about to run out of stock* likewise.

You have met this principle already if you have done the Dating apps profile track — write things that can be replied to. It is exactly the same mechanism standing in a corridor, and it is worth noticing that it is a writing problem rather than a social one: you can decide this sentence in advance, at your desk, with nobody watching, and then use it for a year.

Two practical notes. Leave out the jargon, including the words that feel neutral to you — every industry has a hundred of them and they turn a hook back into a category. And do not lead with the company unless the company is the interesting part; *I work at Meridian* invites *oh, right* and nothing else.

Then stop. Thirty seconds is the whole thing. The commonest failure after finally saying something interesting is to keep going for two more minutes, which converts a hook into a monologue and teaches somebody not to ask.

If you keep one thing: write the sentence down before you need it. It is the least social piece of preparation available and it does more than anything else in this track.$md$,
  $j$[
    {
      "situation": "\"So what do you do?\"",
      "line": "I work out why people stop using things halfway through.",
      "why": "The same job as data analyst, described so that anybody can pick it up. A title is a category; this has a handle on it."
    },
    {
      "situation": "You are about to say your job title.",
      "line": "(that gets a nod and a silence)",
      "why": "It tells somebody where to file you and gives them nothing to ask about, so the conversation now depends on their inventiveness."
    },
    {
      "situation": "You said the good sentence and they looked interested.",
      "line": "(now stop)",
      "why": "Thirty seconds is the whole thing. Carrying on converts a hook into a monologue and teaches somebody not to ask."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is wrong with a job title?",
      "options": [
        { "text": "It is boring.", "correct": false, "note": "Plenty of boring answers work. The problem is structural rather than aesthetic." },
        { "text": "People do not understand it.", "correct": false, "note": "Sometimes, and a perfectly well-understood title produces the same nod and silence." },
        { "text": "It is a category, so there is nothing to ask about.", "correct": true, "note": "It tells somebody where to file you. The conversation now depends on their inventiveness rather than on anything you supplied." },
        { "text": "It sounds like you are bragging.", "correct": false, "note": "Rarely. Titles are the safest and least interesting thing anybody says." }
      ],
      "explain": "Say the thing you work on, in a sentence a stranger could ask a question about."
    },
    {
      "prompt": "Where does this sentence get made?",
      "options": [
        { "text": "In the moment — it should sound natural.", "correct": false, "note": "In the moment you will say your title, because that is what comes out under mild pressure." },
        { "text": "At your desk, in advance, once.", "correct": true, "note": "It is a writing problem rather than a social one. Decide it with nobody watching and use it for a year." },
        { "text": "It should change depending on who is asking.", "correct": false, "note": "Nice in theory and it is why most people never settle on one. Have one good sentence first." },
        { "text": "From how your company describes the role.", "correct": false, "note": "That is the category with extra jargon on it, and jargon turns a hook back into a filing label." }
      ],
      "explain": "The least social preparation available, and it does more than anything else in this track."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "not_a_title", "label": "Did not lead with a title", "description": "Described the work rather than the category." },
      { "key": "askable", "label": "Left something to ask about", "description": "Said it so a stranger could pick it up." },
      { "key": "plain", "label": "No jargon", "description": "Used words anybody would understand." },
      { "key": "stopped", "label": "Stopped at thirty seconds", "description": "Did not turn the hook into a monologue." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Two minutes into a corridor conversation at the conference. They have just asked what you do.",
    "partner": {
      "name": "Theo",
      "role": "somebody you have been talking to at the conference",
      "personality": "Curious and easily hooked by anything concrete. Responds to a job title with a nod and a change of subject.",
      "mood": "Interested, no agenda.",
      "openness": 4
    },
    "opening_beat": "\"So what is it you actually do?\"",
    "success_looks_like": "The user describes the work in a sentence that can be asked about.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Respond to a job title with a nod and a change of subject.",
      "Ask a real follow-up question about anything concrete and jargon-free.",
      "Never ask a second time what they do."
    ]
  }$j$::jsonb,
  $md$Today, write your thirty-second version and say it to one person instead of your job title. Log the sentence.$md$
),
(
  (select id from public.skills where slug = 'the-corridor'),
  3,
  'Lifts, queues and kitchens',
  $md$These are the free attempts and almost nobody uses them, which is a waste of the easiest rooms in professional life.

You met the mechanism in Meeting someone: a situation with a clock in it ends the conversation for you. A lift arrives. The queue moves. The kettle boils. There is no exit to negotiate, no risk of being trapped, and no afterwards to dread — which removes the single biggest reason people say nothing.

**The move:** say the obvious thing about the situation you are both in, and let the clock end it.

*This lift is having a day.* *Is that the machine that eats cups?* *I have never once got this door open first time.* None of these are clever and none of them are meant to be. They are an offer of thirty seconds, and thirty seconds is genuinely enough — recognisable is the target, and being the person who says something ordinary in the lift is exactly how recognisable is built.

The senior-person version deserves its own note, because it is where the most value sits for the least effort. Almost everything a senior person hears in a corridor is a request. Two minutes of ordinary conversation with no ask in it is unusual enough to be remembered, and it costs you nothing except the nerve to talk about the coffee.

Which means the one rule for the lift with the boss in it is: do not pitch. Not your project, not your case, not a quick thing while I have you. It converts a free interaction into a transaction and it is what everybody else does.

And let it end when the situation ends. Do not follow them out, do not extend it at the door. The clock ending it cleanly is what makes the whole thing cost nothing, and it is what makes the next one easy.

If you keep one thing: say the obvious thing. The clock will do the rest, and you will have been a person rather than a colleague they cannot place.$md$,
  $j$[
    {
      "situation": "You are in the lift with somebody two levels above you.",
      "line": "This lift is having a day.",
      "why": "Ordinary, unclever, and with no ask in it — which is unusual enough in a corridor to be remembered. The clock ends it for you."
    },
    {
      "situation": "You have thirty seconds with somebody senior and a project you want support on.",
      "line": "(do not pitch)",
      "why": "It converts a free interaction into a transaction, and it is what everybody else does. The value here is in not doing it."
    },
    {
      "situation": "The lift arrives and you are mid-sentence.",
      "line": "(let it end)",
      "why": "The clock ending it cleanly is what makes the whole thing cost nothing and what makes the next one easy."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why are lifts and queues the easiest rooms?",
      "options": [
        { "text": "People are bored and want to talk.", "correct": false, "note": "Some are, some are not, and the advantage holds either way." },
        { "text": "The situation ends it for you.", "correct": true, "note": "No exit to negotiate, no risk of being trapped, and no afterwards to dread — which removes the biggest single reason people say nothing." },
        { "text": "Nobody remembers what was said.", "correct": false, "note": "They remember you, which is the entire point of doing it." },
        { "text": "They are short enough not to matter.", "correct": false, "note": "They matter a lot, cumulatively. Short is what makes them cheap, not what makes them unimportant." }
      ],
      "explain": "Say the obvious thing. The clock does the rest."
    },
    {
      "prompt": "Thirty seconds in a lift with somebody senior. What is the rule?",
      "options": [
        { "text": "Have something interesting ready.", "correct": false, "note": "Prepared interestingness is audible, and it makes an ordinary moment into a performance." },
        { "text": "Introduce yourself properly.", "correct": false, "note": "Fine, and it is not the thing that determines whether this works." },
        { "text": "Use it — you may not get another chance.", "correct": false, "note": "This is the instinct that produces the pitch, and it spends the interaction on the least valuable use of it." },
        { "text": "Do not pitch.", "correct": true, "note": "Almost everything they hear in a corridor is a request. Two ordinary minutes with no ask is unusual enough to be remembered." }
      ],
      "explain": "The value is in being a person rather than an agenda."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_something", "label": "Said the obvious thing", "description": "Opened rather than waiting it out." },
      { "key": "no_pitch", "label": "Did not pitch", "description": "Kept any ask out of it entirely." },
      { "key": "ordinary", "label": "Kept it ordinary", "description": "Did not reach for something impressive." },
      { "key": "let_it_end", "label": "Let the clock end it", "description": "Did not extend it past the situation." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The lift, on the way up. Your manager's manager gets in after you. Six floors.",
    "partner": {
      "name": "Nadine",
      "role": "your manager's manager",
      "personality": "Warm about ordinary conversation and visibly braced whenever somebody starts a sentence with while I have you. Remembers people who did not want anything.",
      "mood": "Between meetings.",
      "openness": 4
    },
    "opening_beat": "The doors close. Six floors. They glance up and half smile.",
    "success_looks_like": "The user says something ordinary and asks for nothing.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Respond warmly and easily to ordinary conversation.",
      "Become polite and closed at anything that turns into a request or a project update.",
      "Leave at the sixth floor regardless of where the conversation has got to."
    ]
  }$j$::jsonb,
  $md$Today, say the obvious thing in one lift, queue or kitchen. Log what you said and who to.$md$
),
(
  (select id from public.skills where slug = 'the-corridor'),
  4,
  'The room with no clock',
  $md$A conference corridor is the hard version, and it is hard for exactly one reason: nothing ends it. No lift arrives, no queue moves, and no shared task runs out. Two people who have finished what they had to say to each other are now standing there, both waiting for the other one to solve it.

That is what people are actually dreading when they say they hate networking. Not the starting — the not being able to stop.

**The move:** plant the exit early, in passing, before you need it.

*I am going to catch the eleven-thirty, but* — said in the first minute, as ordinary context — changes everything that follows. You have both been told this has a shape, so neither of you is trapped, and you can relax into it rather than watching for a gap.

You will use it about a third of the time. Having it is what does the work, because it removes the thing you were bracing against, and people can tell when somebody is not bracing.

Then leave cleanly and warmly. *I am going to go and find that session — good to meet you, Theo.* Use their name, mean it, and go. No manufactured errand, no drifting off mid-topic, and above all no apology: leaving a conversation is not something that requires forgiveness, and treating it as though it does makes the last thirty seconds awkward for both of you.

Being left is fine too, and worth saying because quiet people take it personally. Somebody who leaves warmly after four minutes had a good four minutes with you. That is what these are.

And one door back in, for when you want it: *are you around tomorrow?* costs nothing, needs no answer, and turns a first conversation into a probable second — which was the entire target.

If you keep one thing: plant the exit in the first minute. You will rarely use it, and it is the thing that lets you enjoy the conversation.$md$,
  $j$[
    {
      "situation": "You have just started talking to somebody at a conference.",
      "line": "I am going to catch the eleven-thirty, but — how are you finding it?",
      "why": "Planted in the first minute as ordinary context. Both of you now know this has a shape, so neither is braced, and people can tell when somebody is not braced."
    },
    {
      "situation": "The conversation has run out and you are both standing there.",
      "line": "I am going to go and find that session — good to meet you, Theo.",
      "why": "Warm, named, clean. No manufactured errand and no apology, because leaving a conversation does not require forgiveness."
    },
    {
      "situation": "They left after four minutes and you are wondering what went wrong.",
      "line": "(they had a good four minutes with you)",
      "why": "That is what these are. Being left warmly is not a verdict on the conversation."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What actually makes a conference corridor hard?",
      "options": [
        { "text": "You do not know anybody.", "correct": false, "note": "Nobody does, and it is the same for everyone in the room, which makes starting easier rather than harder." },
        { "text": "Nothing ends the conversation.", "correct": true, "note": "No lift, no queue, no shared task running out. Two people who have finished are standing there waiting for the other to solve it — that is what people dread." },
        { "text": "Everybody is more senior than you.", "correct": false, "note": "Almost never true, and it is not what people are actually bracing against." },
        { "text": "You have to sound impressive.", "correct": false, "note": "You do not, and believing you do is a separate problem the first lesson handles." }
      ],
      "explain": "It is not the starting. It is the not being able to stop."
    },
    {
      "prompt": "How do you leave?",
      "options": [
        { "text": "Warmly, with their name, and no apology.", "correct": true, "note": "Leaving a conversation does not require forgiveness, and treating it as though it does makes the last thirty seconds awkward for both of you." },
        { "text": "With a reason, so it does not seem abrupt.", "correct": false, "note": "A planted exit already supplied one. A manufactured errand at the end is audible." },
        { "text": "By introducing them to somebody else first.", "correct": false, "note": "Generous when it happens naturally, and an elaborate manoeuvre to avoid a simple goodbye." },
        { "text": "By letting it trail off.", "correct": false, "note": "The drift is the version that feels worst to the person being drifted away from." }
      ],
      "explain": "Plant the exit early, use it warmly, and do not apologise for it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "planted", "label": "Planted an exit early", "description": "Mentioned a shape in the first minute." },
      { "key": "warm_exit", "label": "Left warmly", "description": "Used their name and meant it." },
      { "key": "no_apology", "label": "Did not apologise for leaving", "description": "Treated it as ordinary." },
      { "key": "door_back", "label": "Left a door open", "description": "Made a second conversation likely if it was worth one." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The long afternoon break at the conference. You have been talking to Theo for about six minutes and it has run out of places to go.",
    "partner": {
      "name": "Theo",
      "role": "somebody you met at the conference this morning",
      "personality": "Pleasant and equally unable to end a conversation. Will stand there indefinitely and is visibly relieved when somebody closes it warmly.",
      "mood": "Enjoyed it, out of subjects.",
      "openness": 4
    },
    "opening_beat": "\"...yeah. No, exactly.\" A pause. Neither of you has anything left.",
    "success_looks_like": "The user closes the conversation warmly and cleanly.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Never end the conversation yourself — stand there indefinitely.",
      "Respond warmly and with relief to a clean, friendly close.",
      "Become slightly awkward if the user apologises for leaving or invents an errand."
    ]
  }$j$::jsonb,
  $md$Today, plant an exit in the first minute of one conversation, then leave warmly when it is done. Log both.$md$
),
(
  (select id from public.skills where slug = 'the-corridor'),
  5,
  'The two lines afterwards',
  $md$Almost nobody does this, which is exactly why it works.

**The move:** send two lines the same day, referring to the actual thing you talked about.

*Good to meet you at the coffee thing — you were right about the pricing session, it was the best one. If you are ever in the London office, say hello.* That is the whole message. It takes ninety seconds and it converts a person who half remembers you into a person who knows who you are.

The same-day part matters for the same reason it does everywhere else: you are preserving something. On the day, you are a person they were talking to. Ten days later you are a name and a company, and the message now has to reintroduce you before it can do anything.

Refer to the specific thing. *Great to connect* is a template and reads as one — it could have been sent to forty people because it was. One detail from the actual conversation proves it was that conversation, and it is the whole difference between a message that gets a reply and one that gets a polite nothing.

Ask for nothing. This is the part people cannot resist and it is what ruins it: a follow-up carrying a request converts a pleasant two minutes into the opening move of a transaction, and everybody can feel it. The message has done its job by existing.

Leave one door open and make it costless. *If you are ever in the London office* needs no answer and can be taken up in a year.

And then do nothing. There is no sequence, no follow-up to the follow-up, no polite nudge in three weeks. You have made yourself recognisable, which was the target, and recognisable pays off on a timescale of years rather than weeks.

If you keep one thing: same day, one specific detail, no ask. Ninety seconds, and it is the whole of what people mean by networking.$md$,
  $j$[
    {
      "situation": "You met somebody at a conference this morning.",
      "line": "Good to meet you at the coffee thing — you were right about the pricing session. If you are ever in the London office, say hello.",
      "why": "Same day, one real detail, no ask, and one costless door. Ninety seconds, and it converts a half-memory into a person who knows who you are."
    },
    {
      "situation": "You are about to write great to connect.",
      "line": "(that is a template and it reads as one)",
      "why": "It could have been sent to forty people, because it was. One detail from the actual conversation is the whole difference."
    },
    {
      "situation": "You would quite like to ask them something.",
      "line": "(not in this message)",
      "why": "A follow-up carrying a request converts a pleasant two minutes into the opening move of a transaction, and everybody can feel it."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why the same day?",
      "options": [
        { "text": "It shows you are keen.", "correct": false, "note": "Keenness is not the currency here, and it is not what the timing is protecting." },
        { "text": "They will have forgotten by next week.", "correct": false, "note": "Blunt version of the real reason. They remember the conversation; what fades is you being a person rather than a name." },
        { "text": "Today you are a person they were talking to.", "correct": true, "note": "Ten days later you are a name and a company, and the message has to reintroduce you before it can do anything else." },
        { "text": "It is easier to write while it is fresh.", "correct": false, "note": "True and about you rather than about them." }
      ],
      "explain": "You are preserving the fact that you were a person, not a contact."
    },
    {
      "prompt": "What must the message not contain?",
      "options": [
        { "text": "A specific detail — that is too familiar.", "correct": false, "note": "The opposite: the detail is the entire point and the thing that proves it was that conversation." },
        { "text": "Anything about yourself.", "correct": false, "note": "A line about yourself is fine. It is the ask that does the damage." },
        { "text": "An open door — that is presumptuous.", "correct": false, "note": "A costless door needing no answer is exactly right, and it can be taken up in a year." },
        { "text": "An ask.", "correct": true, "note": "It converts a pleasant two minutes into the opening move of a transaction. The message has done its job by existing." }
      ],
      "explain": "Same day, one real detail, no ask, one costless door. Then nothing."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "same_day", "label": "Sent it the same day", "description": "Wrote while they were still a person rather than a name." },
      { "key": "specific", "label": "Named a real detail", "description": "Referred to something from the actual conversation." },
      { "key": "no_ask", "label": "Asked for nothing", "description": "Kept every request out of it." },
      { "key": "short", "label": "Two lines", "description": "Did not write a letter." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The evening after the conference. You met Theo at the morning coffee break and talked about the pricing session, which he recommended and was right about.",
    "partner": {
      "name": "Theo",
      "role": "somebody you met at the conference this morning",
      "personality": "Replies warmly to anything specific and briefly to anything generic. Goes cool at a message carrying a request.",
      "mood": "On the train home.",
      "openness": 4
    },
    "opening_beat": "The message box is empty and it is seven in the evening.",
    "success_looks_like": "The user sends two short lines with a real detail and no ask.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Reply warmly and specifically to anything that refers to the actual conversation.",
      "Reply with a one-word acknowledgement to anything generic.",
      "Go polite and brief if the message contains a request."
    ]
  }$j$::jsonb,
  $md$Today, send two lines to somebody you met recently, with one real detail and no ask. Log what you sent.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('the-corridor', 1, 'choice', $j${
  "beats": [
    {
      "situation": "First coffee break at a two-day conference. Eighty people, you know none of them.",
      "prompt": "What are you actually trying to achieve today?",
      "options": [
        { "text": "Meet as many people as possible.", "correct": false, "note": "Volume for its own sake, and it produces forty conversations nobody remembers including you." },
        { "text": "Be a person three or four people would recognise next time.", "correct": true, "note": "The second conversation is where anything useful happens, and it only exists if the first one made you recognisable." },
        { "text": "Find one genuinely useful contact.", "correct": false, "note": "Aiming at usefulness is what makes conversations feel transactional, and people can tell immediately." },
        { "text": "Have at least one really good conversation.", "correct": false, "note": "Nice if it happens. Setting it as the target makes every ordinary exchange feel like a failure." }
      ]
    },
    {
      "situation": "You have just had two minutes about the coffee and the venue with somebody. Nothing memorable was said.",
      "prompt": "How did that go?",
      "options": [
        { "text": "Badly — you had nothing interesting to say.", "correct": false, "note": "Interesting was not the target, and this reading is what makes people dread the next break." },
        { "text": "Neutral — nothing happened.", "correct": false, "note": "Something did: you swapped names and were pleasant, which is what recognisable is built from." },
        { "text": "Fine — most of these are allowed to be forgettable.", "correct": true, "note": "Three or four people across a day who will nod at you next time is a good day, and nodding compounds enormously over a few years." },
        { "text": "Wasted — you should have talked about work.", "correct": false, "note": "Work comes up on its own. Steering there to justify the conversation is what makes it feel like networking." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-corridor', 2, 'line', $j${
  "says": "So what is it you actually do?",
  "model": {
    "line": "I work out why people stop using things halfway through.",
    "why": "The same job as the title, described so a stranger can pick it up. A title tells somebody where to file you; this gives them something to ask."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Describe the work you actually do" },
    { "kind": "forbids_any", "requirement": "Not a title, and no jargon",
      "words": ["i am a", "im a", "senior", "manager at", "analyst", "consultant", "engineer at", "stakeholder", "leverage", "vertical", "end to end", "workstream"] },
    { "kind": "max_words", "requirement": "One sentence — thirty seconds, then stop", "n": 25 },
    { "kind": "max_sentences", "requirement": "Do not turn the hook into a monologue", "n": 2 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-corridor', 3, 'line', $j${
  "says": "The lift doors close. Six floors. Your manager's manager glances up and half smiles.",
  "model": {
    "line": "This lift is having a day.",
    "why": "Ordinary, unclever, and with no ask in it — which is unusual enough in a corridor to be remembered. The clock ends it for you, so it costs nothing."
  },
  "checks": [
    { "kind": "no_question", "requirement": "An offer, not an interview" },
    { "kind": "forbids_any", "requirement": "Do not pitch — no ask, no update",
      "words": ["while i have you", "quick one", "wanted to ask", "chance to mention", "project", "update you", "any thoughts on", "opportunity", "circle back"] },
    { "kind": "max_words", "requirement": "Thirty seconds of ordinary", "n": 20 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-corridor', 4, 'scene', $j${}$j$::jsonb);

select pg_temp.set_mode('the-corridor', 5, 'line', $j${
  "says": "Seven in the evening, the day of the conference. You met Theo at the morning coffee break and he was right about the pricing session being the best one.",
  "model": {
    "line": "Good to meet you this morning — you were right about the pricing session, it was the best one. If you are ever in the London office, say hello.",
    "why": "Same day, one real detail that proves it was that conversation, no ask, and one door that needs no answer. Ninety seconds, and almost nobody sends it."
  },
  "checks": [
    { "kind": "echoes_any", "requirement": "Refer to the actual conversation",
      "words": ["pricing", "session", "coffee", "morning"] },
    { "kind": "forbids_any", "requirement": "Ask for nothing",
      "words": ["would you be able", "could you", "wondering if you", "any chance", "put me in touch", "have a call", "pick your brain", "great to connect", "let us connect"] },
    { "kind": "max_words", "requirement": "Two lines", "n": 45 }
  ]
}$j$::jsonb);
