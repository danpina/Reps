-- Talking to AI, track 4: Rehearse it first.
--
-- The highest-value single use in the topic, and the one closest to what the
-- app itself does — the difference being that this is for a specific real
-- conversation on a specific day, against a described person, outside the
-- curriculum.
--
-- Hard conversations and Work own what to say. This only covers the
-- preparation, and lesson four deliberately restates Storytelling's argument
-- about knowing the opening rather than inventing a new one.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'rehearse-it-first'),
  1,
  'Describe the actual person',
  $md$Rehearsing in your head does not work, and the reason is specific: you rehearse the version where they respond well. You say your line, they take it reasonably, and you have practised a conversation that is not the one you are worried about.

Handing it over does not fix that by itself. *How do I ask my manager for more responsibility* gets you advice about managers, which is a category, and you are not having a conversation with a category on Tuesday.

**The move:** describe the person, not the role.

What they care about. What they are under pressure from at the moment. How they push back — do they go quiet, ask for numbers, agree and then not act, get slightly cold. What they said the last time this came up. What they have already turned down. Whether they like you, as far as you can tell.

Four or five sentences of that changes the output completely, because the useful thing is not general advice — it is the sentence they are actually going to say, so you can hear it before Tuesday rather than during.

Include the awkward parts, and this is the bit people leave out. If you have raised it twice already, say so. If you handled it badly last time, say how. If part of their objection is fair, put that in. A version of the situation edited to make you look reasonable produces a rehearsal against somebody who does not exist, and you will meet the real one anyway.

Say what you want, too, and be specific about it. *I want to come out of this with a yes to leading the migration project, or a clear reason why not.* A rehearsal with no target is a conversation about the topic, and those go round in circles here exactly as they do in life.

One caution that the next-but-one track expands: the description you give is the description it works from, and it will not challenge your account. If you describe them as unreasonable, you are rehearsing against somebody unreasonable. Worth checking by writing the same brief from their side.

If you keep one thing: describe the person, including the parts that do not flatter you. A role gets you advice about a role.$md$,
  $j$[
    {
      "situation": "You are about to ask about your manager.",
      "line": "She goes quiet when she disagrees and asks for numbers a day later.",
      "why": "How somebody pushes back is the useful part. A role gets you advice about a role."
    },
    {
      "situation": "You have raised it twice before and it went badly.",
      "line": "I have asked twice. The second time I got defensive about it.",
      "why": "An edited version produces a rehearsal against somebody who does not exist, and you meet the real one anyway."
    },
    {
      "situation": "You have not said what you want out of it.",
      "line": "A yes to leading the migration, or a clear reason why not.",
      "why": "A rehearsal with no target goes round in circles, here exactly as in life."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does rehearsing in your head fail?",
      "options": [
        { "text": "You forget your lines under pressure.", "correct": false, "note": "Happens, and it would be equally true of a good rehearsal." },
        { "text": "You rehearse the version where they respond well.", "correct": true, "note": "You say your line, they take it reasonably, and you have practised the conversation you were not worried about." },
        { "text": "It is not detailed enough.", "correct": false, "note": "Head rehearsals are often extremely detailed — about the wrong conversation." },
        { "text": "You do it too many times.", "correct": false, "note": "Repetition is not the fault. What is being repeated is." }
      ],
      "explain": "Describe the person, not the role."
    },
    {
      "prompt": "Which detail is most often left out?",
      "options": [
        { "text": "What they care about.", "correct": false, "note": "People usually supply this — it is the part that feels like the brief." },
        { "text": "How long you have worked together.", "correct": false, "note": "Easy to say and it changes the advice least." },
        { "text": "The part where you handled it badly.", "correct": true, "note": "A situation edited to make you look reasonable produces a rehearsal against somebody who does not exist." },
        { "text": "What you want out of it.", "correct": false, "note": "Commonly missing and worth naming — and it is omitted from carelessness rather than from discomfort." }
      ],
      "explain": "And check by writing the same brief from their side."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "person", "label": "Described a person", "description": "Not a role or a job title." },
      { "key": "pushback", "label": "Said how they push back", "description": "Quiet, numbers, cold, agrees and stalls." },
      { "key": "unflattering", "label": "Included the awkward parts", "description": "Previous attempts, own mistakes." },
      { "key": "target", "label": "Named what you want", "description": "A specific outcome, not a topic." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A conversation you have been avoiding is happening on Tuesday, and you have started preparing for it tonight.",
    "partner": {
      "name": "Elena",
      "role": "a friend who knows your workplace slightly",
      "personality": "Asks what the person is actually like and notices when the account is flattering to you.",
      "mood": "Direct.",
      "openness": 5
    },
    "opening_beat": "\"What is she actually like when she disagrees with you?\"",
    "success_looks_like": "The user describes the person concretely, including what did not go well before.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask how the person pushes back.",
      "Ask what happened the previous times.",
      "Never offer advice about the conversation."
    ]
  }$j$::jsonb,
  $md$Today, write four sentences describing the person before the conversation. Log the ones that do not flatter you.$md$
),
(
  (select id from public.skills where slug = 'rehearse-it-first'),
  2,
  'Ask for the difficult version',
  $md$Left to itself it plays somebody reasonable. They hear you out, they concede your good points, and they arrive at a workable compromise around the fourth exchange.

Reasonable people were never the problem. You did not lose sleep over the version where they say *that is a fair point, let me think about it*.

**The move:** ask it to make the rehearsal harder than the day.

*Play them sceptical and short of time. Do not make it easy. Do not concede anything unless I have actually answered the objection.*

That last clause is the one that matters most, because the failure mode is subtle: it will accept a weak answer politely, and a rehearsal where your weak answers pass is worse than none — you come away having confirmed something untrue.

Three difficulties worth asking for separately, since they fail differently.

**The interrupter.** Cuts across your third sentence. This tests whether the point survives being compressed, which is what actually happens in rooms.

**The one who agrees and does nothing.** *Yes, definitely, let us look at that.* Much harder than open disagreement, because there is nothing to push against, and it is how most workplace asks die.

**The one who makes it personal.** *I am surprised you think you are ready for that.* Rare, and the thing people fear most, and the one where having heard it once before is worth the most.

Afterwards, ask what your weakest answer was and where they would have pushed if they had wanted to. That is the same question as track one's weakest-sentence, applied to a conversation, and it works for the same reason.

One thing to keep hold of: the rehearsal partner is not evidence about the person. It is a way of finding the holes in what you are going to say. What they will actually do on Tuesday is unknowable, and the next track is about not confusing the two.

If you keep one thing: ask it not to concede unless you have actually answered. A rehearsal you sail through has taught you nothing.$md$,
  $j$[
    {
      "situation": "The rehearsal is going well.",
      "line": "Do not concede unless I have actually answered the objection.",
      "why": "A rehearsal where weak answers pass is worse than none — you leave having confirmed something untrue."
    },
    {
      "situation": "You want to test whether the point survives pressure.",
      "line": "Interrupt me on my third sentence.",
      "why": "Compression is what actually happens in rooms, and it is where prepared points fall apart."
    },
    {
      "situation": "You finished and it went fine.",
      "line": "What was my weakest answer, and where would you have pushed?",
      "why": "The weakest-sentence question from track one, applied to a conversation."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which difficulty is hardest to handle?",
      "options": [
        { "text": "Open disagreement.", "correct": false, "note": "Uncomfortable and workable — there is something concrete to answer." },
        { "text": "Agreeing and then doing nothing.", "correct": true, "note": "Nothing to push against, and it is how most workplace asks quietly die." },
        { "text": "Being interrupted.", "correct": false, "note": "Tests whether the point survives compression, which is a different and more fixable problem." },
        { "text": "Being asked for numbers.", "correct": false, "note": "The most preparable of all of them." }
      ],
      "explain": "Ask for each difficulty separately — they fail differently."
    },
    {
      "prompt": "What is the rehearsal partner not?",
      "options": [
        { "text": "A way to find holes in your case.", "correct": false, "note": "That is exactly what it is for." },
        { "text": "A test of whether your answers hold.", "correct": false, "note": "Also what it is for, provided it is told not to concede too easily." },
        { "text": "Somewhere to hear the sentence out loud.", "correct": false, "note": "One of the main reasons to do it at all, as lesson five argues." },
        { "text": "Evidence about what they will do.", "correct": true, "note": "Unknowable, and confusing the rehearsal with a prediction is the next track's whole subject." }
      ],
      "explain": "A rehearsal you sail through has taught you nothing."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "harder", "label": "Asked for the difficult version", "description": "Sceptical, pressed for time." },
      { "key": "no_concede", "label": "Blocked easy concessions", "description": "No agreement without a real answer." },
      { "key": "varied", "label": "Tried more than one difficulty", "description": "Interrupter, staller, or personal." },
      { "key": "debrief", "label": "Asked what was weakest", "description": "Found the hole afterwards." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have rehearsed the conversation twice and both times it went well, which has made you more nervous rather than less.",
    "partner": {
      "name": "Elena",
      "role": "a friend who knows your workplace slightly",
      "personality": "Asks whether the practice version ever said no, and what happens if it does.",
      "mood": "Sceptical.",
      "openness": 5
    },
    "opening_beat": "\"Did it ever actually say no to you?\"",
    "success_looks_like": "The user asks for a harder rehearsal instead of taking the easy one as evidence.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what happened when the practice version pushed back.",
      "Be unimpressed by a rehearsal that went smoothly.",
      "Never play the other person yourself."
    ]
  }$j$::jsonb,
  $md$Today, rehearse one conversation against a version told not to concede. Log where it caught you.$md$
),
(
  (select id from public.skills where slug = 'rehearse-it-first'),
  3,
  'What am I not saying?',
  $md$Most conversations people dread have one sentence in them that is the actual conversation, and a great deal of preparation goes into approaching it without ever arriving.

You prepare the context. You prepare the reasonable framing. You prepare the bit where you say you understand their position. And the sentence — the number, the date, the thing they did, the word *no* — is still not in the plan when you walk in.

**The move:** ask what you are avoiding, before you rehearse anything else.

*Here is what I am planning to say. What am I not saying?* It is the single most useful question in this topic, and it works because avoidance leaves a shape in a draft that is visible from outside. A plan that circles something has a hole in it, and the hole has edges.

The answers tend to be one of four things.

**The number.** You have prepared everything about the request except how much.

**The consequence.** What you will do if the answer is no. Frequently the whole reason the conversation has any weight, and it goes unsaid because saying it feels like a threat. Usually it is simply information.

**The thing they did.** The specific behaviour, on a specific day. Hard conversations is built on getting that said plainly, and preparation is where it most often gets sanded into a general concern about communication.

**The refusal.** Sometimes the missing sentence is just *no*, and everything around it is scaffolding for not having to say it.

Then ask for the sentence itself. *Give me one sentence that says it plainly.* Take it as a starting point rather than a script — the wording should be yours, per the last track — but seeing it written removes the sense that it is unsayable.

And a caution from experience: sometimes you will read the answer and think, no, I am not going to say that. That is a legitimate outcome. Deciding not to say something is completely different from never having noticed it was missing.

If you keep one thing: ask what you are not saying. The plan that circles it has a hole with edges.$md$,
  $j$[
    {
      "situation": "You have a plan and it feels complete.",
      "line": "Here is what I plan to say. What am I not saying?",
      "why": "Avoidance leaves a shape in a draft. A plan that circles something has a hole with edges."
    },
    {
      "situation": "The missing piece is what happens if they say no.",
      "line": "(say it — it is information, not a threat)",
      "why": "It usually goes unsaid because it feels like a threat, and it is often the entire weight of the conversation."
    },
    {
      "situation": "You read the missing sentence and do not want to say it.",
      "line": "(deciding not to is a legitimate outcome)",
      "why": "Choosing not to say something is completely different from never noticing it was missing."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does the question work?",
      "options": [
        { "text": "Avoidance leaves a visible shape in the plan.", "correct": true, "note": "A plan that circles something has a hole, and the hole has edges that are obvious from outside." },
        { "text": "It knows what these conversations usually contain.", "correct": false, "note": "Some of it is pattern, and the useful answers are specific to your plan rather than to the genre." },
        { "text": "It is better at confrontation than you are.", "correct": false, "note": "It has never had a conversation. This is about reading a draft." },
        { "text": "It removes your emotion from the situation.", "correct": false, "note": "Your emotion is largely why the sentence is missing, and it is not removed by noticing." }
      ],
      "explain": "Ask it before you rehearse anything else."
    },
    {
      "prompt": "Which missing piece is most often left out because it feels like a threat?",
      "options": [
        { "text": "The number.", "correct": false, "note": "Left out from awkwardness rather than fear of how it sounds." },
        { "text": "The thing they did.", "correct": false, "note": "Left out because it is uncomfortable, and Hard conversations covers getting it said." },
        { "text": "What you will do if they say no.", "correct": true, "note": "It goes unsaid because stating it feels like a threat, and it is usually just information — often the whole weight of the conversation." },
        { "text": "The word no itself.", "correct": false, "note": "A real one, and it is avoided for being blunt rather than for sounding like a threat." }
      ],
      "explain": "Then ask for it in one plain sentence, and make the wording yours."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked", "label": "Asked what was missing", "description": "Before rehearsing anything." },
      { "key": "found", "label": "Found the sentence", "description": "Named the thing being circled." },
      { "key": "plain", "label": "Got it in one plain sentence", "description": "Not a paragraph of framing." },
      { "key": "own_words", "label": "Made the wording yours", "description": "Used it as a start, not a script." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have a full plan for Tuesday and you feel prepared, and something about it is still bothering you.",
    "partner": {
      "name": "Elena",
      "role": "a friend who knows your workplace slightly",
      "personality": "Listens to the plan and asks what happens if the answer is no.",
      "mood": "Calm.",
      "openness": 5
    },
    "opening_beat": "\"And what do you do if she says no?\"",
    "success_looks_like": "The user names the sentence they had been leaving out.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what happens if the answer is no.",
      "Notice out loud when the plan goes around something.",
      "Never supply the missing sentence."
    ]
  }$j$::jsonb,
  $md$Today, ask what you are not saying about one upcoming conversation. Log the sentence it found.$md$
),
(
  (select id from public.skills where slug = 'rehearse-it-first'),
  4,
  'The first fifteen seconds',
  $md$There is a temptation, once you have a rehearsal partner that never gets tired, to script the whole thing. It does not work, and it is worth knowing why before you spend an evening on it.

A scripted conversation survives until the other person says something you did not plan for, which is usually their first sentence. After that you are either reciting into a conversation that has moved, or you have abandoned the script and lost the preparation too.

**The move:** rehearse the opening and nothing else.

The first fifteen seconds are where it actually fails. That is where the adrenaline is highest, where a quiet person is most likely to bury the point in preamble, and — because it is the only part whose context you can predict — the only part that can be prepared with any confidence.

Storytelling makes the same argument about a story's first line and last, and for the same reason: a known opening buys you the stretch where nerves are worst, and by the time it is over you are in a conversation rather than at the start of one.

What goes in the opening:

**The subject, named.** *I want to talk about the migration project.* Not a warm-up, not the weather, and not a question about whether now is a good time — that hands over the decision you came to make.

**The ask or the concern, in one sentence.** Whatever the third lesson found. It goes at the front, for exactly the reason Messaging puts the ask in the first line.

**Then stop.** The instinct is to keep talking through the silence, and the silence is theirs.

That is fifteen seconds. Rehearse it until it comes out without assembly, and prepare nothing else except the answers to the two objections you already know are coming — which the second lesson found, and which are answers rather than scripts.

If you keep one thing: know the first fifteen seconds by heart and improvise the rest. The middle cannot be scripted and does not need to be.$md$,
  $j$[
    {
      "situation": "You are tempted to script the whole conversation.",
      "line": "(the script dies at their first sentence)",
      "why": "After that you are reciting into a conversation that has moved, and the preparation goes with it."
    },
    {
      "situation": "You are writing the opening.",
      "line": "I want to talk about the migration project.",
      "why": "The subject named, not a warm-up and not asking whether now is a good time."
    },
    {
      "situation": "You have said the ask and there is silence.",
      "line": "(stop — it is theirs)",
      "why": "Talking through it is the instinct, and it is how a clear opening gets buried straight after being delivered."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why not script the whole thing?",
      "options": [
        { "text": "It sounds rehearsed.", "correct": false, "note": "Less of a problem than people fear — nobody can hear that you prepared." },
        { "text": "It takes too long to prepare.", "correct": false, "note": "Time is not the objection, and an evening would be worth spending if it worked." },
        { "text": "It dies at their first unplanned sentence.", "correct": true, "note": "Then you are either reciting into a conversation that has moved, or you have dropped the script and the preparation with it." },
        { "text": "You will forget it under pressure.", "correct": false, "note": "Some of it, and the opening is short enough to survive, which is why it is the part to keep." }
      ],
      "explain": "Know the first fifteen seconds and improvise the rest."
    },
    {
      "prompt": "What does not belong in the opening?",
      "options": [
        { "text": "The subject, named plainly.", "correct": false, "note": "The first thing in it." },
        { "text": "Asking whether now is a good time.", "correct": true, "note": "It hands over the decision you came in to make, and the answer is often no." },
        { "text": "The ask, in one sentence.", "correct": false, "note": "Belongs at the front, for the same reason Messaging puts it in the first line." },
        { "text": "A silence after you finish.", "correct": false, "note": "Part of the opening, and the hardest part to leave alone." }
      ],
      "explain": "Then prepare answers to the two objections you already know are coming."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "opening_only", "label": "Rehearsed the opening", "description": "Did not script the whole thing." },
      { "key": "named", "label": "Named the subject", "description": "No warm-up, no asking permission." },
      { "key": "ask_first", "label": "Put the ask in one sentence", "description": "At the front, not after context." },
      { "key": "stopped", "label": "Stopped talking", "description": "Left the silence alone." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have written two pages of what you plan to say on Tuesday.",
    "partner": {
      "name": "Elena",
      "role": "a friend who knows your workplace slightly",
      "personality": "Asks what happens to page two when the other person opens with something unexpected.",
      "mood": "Practical.",
      "openness": 5
    },
    "opening_beat": "\"What happens to all this if she opens with something else?\"",
    "success_looks_like": "The user cuts it down to a prepared opening.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what the first fifteen seconds are.",
      "Be satisfied by a short, named opening.",
      "Never write the opening for them."
    ]
  }$j$::jsonb,
  $md$Today, prepare only the first fifteen seconds of one conversation. Log the opening.$md$
),
(
  (select id from public.skills where slug = 'rehearse-it-first'),
  5,
  'Say it out loud',
  $md$Everything so far can be done by typing, and typing is not rehearsing.

A sentence you have only ever read is a sentence you have never said. On the day it will be the first time it has come out of your mouth, and the first time is always worse — slower, higher, more hedged, and about a third longer than it looked.

**The move:** say the opening out loud before the day.

To an empty room is enough. To the screen in a voice conversation is better, because something answers and you have to keep going. Either way what you are testing is not the wording, which you already have. It is whether you can produce it.

What you find out, reliably, in the first attempt:

**It is longer than it looked.** Written openings run to four clauses and you run out of breath in the middle of the third.

**A word in it is not one you say.** It looked fine and it comes out wrong, and Storytelling's advice applies — swap it for the one you would actually use.

**The end trails off.** Written, it stops. Spoken, it turns into *so, yeah, I just wanted to raise it, really* — the same fade Storytelling spends a lesson on, and it appears here for the same reason: you have arrived at the end without having decided to stop.

**You apologise on the way in.** The written opening does not contain *sorry to spring this on you*, and the spoken one very often does. That is Messaging's crouch, arriving through your mouth instead of your thumbs, and hearing it once is usually enough to remove it.

None of that is visible on a screen, and all of it is fixable in about four minutes.

Three times through is enough. You are not memorising it — you are making it a sentence you have said before, so that on Tuesday it is the second time rather than the first.

If you keep one thing: say it out loud three times. Everything wrong with it is audible and invisible.$md$,
  $j$[
    {
      "situation": "You have the opening written and you feel prepared.",
      "line": "(say it out loud — that is the first test)",
      "why": "A sentence you have only read is a sentence you have never said, and the first time is always worse."
    },
    {
      "situation": "You run out of breath halfway through.",
      "line": "(it is too long — cut a clause)",
      "why": "Written openings run to four clauses. Spoken ones cannot."
    },
    {
      "situation": "It came out with a sorry at the front.",
      "line": "(that only appears out loud)",
      "why": "The crouch arrives through your mouth rather than your thumbs, and hearing it once is usually enough to remove it."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the out-loud test actually testing?",
      "options": [
        { "text": "Whether the wording is right.", "correct": false, "note": "You settled the wording already. This is a later stage." },
        { "text": "Whether you have memorised it.", "correct": false, "note": "Three times is not memorising, and memorising is the previous lesson's warning." },
        { "text": "Whether you can produce it.", "correct": true, "note": "Length, breath, the word you do not actually say, the apology that appears from nowhere. None of it is visible on a screen." },
        { "text": "Whether it sounds confident.", "correct": false, "note": "Sounding confident is not the aim, and nobody can hear your nerves anyway." }
      ],
      "explain": "Everything wrong with it is audible and invisible."
    },
    {
      "prompt": "Which fault appears only when spoken?",
      "options": [
        { "text": "The ask is buried.", "correct": false, "note": "Visible on the page, and the previous lessons deal with it." },
        { "text": "It is ambiguous.", "correct": false, "note": "A property of the text, findable by reading — track three's list." },
        { "text": "It is too formal.", "correct": false, "note": "Detectable in writing if you look, though speaking it does make it obvious." },
        { "text": "An apology at the front.", "correct": true, "note": "The written opening does not contain sorry to spring this on you. The spoken one very often does." }
      ],
      "explain": "Three times through, so Tuesday is the second time and not the first."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "aloud", "label": "Said it out loud", "description": "Not read, spoken." },
      { "key": "repeated", "label": "Three times through", "description": "Enough to make it a repeat." },
      { "key": "shortened", "label": "Cut what you could not say", "description": "Fixed length and breath." },
      { "key": "no_apology", "label": "Removed the spoken apology", "description": "Caught the crouch that appeared." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The conversation is tomorrow. Your opening is written down and you have never said it.",
    "partner": {
      "name": "Elena",
      "role": "a friend who knows your workplace slightly",
      "personality": "Asks to hear it, then asks to hear it again.",
      "mood": "Encouraging but unmoved by excuses.",
      "openness": 5
    },
    "opening_beat": "\"Say it to me. Out loud, as you would say it.\"",
    "success_looks_like": "The user says the opening aloud and notices what changed.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask to hear it a second time.",
      "Notice if an apology appeared that was not written down.",
      "Never suggest different wording."
    ]
  }$j$::jsonb,
  $md$Today, say one prepared opening out loud three times. Log what changed between the first and the third.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('rehearse-it-first', 1, 'line', $j${
  "says": "What is she actually like when she disagrees with you?",
  "model": {
    "line": "She goes quiet, then asks for numbers the next day. I have raised this twice and got defensive the second time.",
    "why": "How somebody pushes back is the useful part, and the account that does not flatter you is the one that produces a rehearsal against the real person."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not describe a role",
      "words": ["typical manager", "managers usually", "she is a manager", "in general", "most bosses", "people like her"] },
    { "kind": "min_words", "requirement": "Describe how they push back", "n": 12 },
    { "kind": "max_words", "requirement": "Four sentences at most", "n": 45 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('rehearse-it-first', 2, 'line', $j${
  "says": "Did it ever actually say no to you?",
  "model": {
    "line": "No, it agreed every time. I am going to run it again and tell it not to concede unless I have answered.",
    "why": "A rehearsal where weak answers pass is worse than none, because you come away having confirmed something untrue."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Ask for a harder version", "words": ["concede", "harder", "sceptical", "push back", "say no", "difficult"] },
    { "kind": "forbids_any", "requirement": "Do not treat the easy run as evidence",
      "words": ["so it should be fine", "it went well", "i think it will be ok", "that is a good sign", "seems ready"] },
    { "kind": "max_words", "requirement": "A decision, not a summary", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('rehearse-it-first', 3, 'choice', $j${
  "beats": [
    {
      "situation": "You have a complete plan: the context, the framing, the bit where you acknowledge her position.",
      "prompt": "What do you ask before rehearsing any of it?",
      "options": [
        { "text": "Is this a reasonable request?", "correct": false, "note": "A verdict question, and it will tell you it is very reasonable." },
        { "text": "How should I open?", "correct": false, "note": "The next lesson, and it is premature while the plan still has a hole in it." },
        { "text": "What am I not saying?", "correct": true, "note": "Avoidance leaves a shape. A plan that circles something has a hole with edges, visible from outside." },
        { "text": "What will she say?", "correct": false, "note": "Unknowable, and confidently answered. That is two tracks from now." }
      ]
    },
    {
      "situation": "It tells you the missing piece is what you will do if the answer is no. You do not want to say it.",
      "prompt": "What is the position?",
      "options": [
        { "text": "Deciding not to say it is legitimate.", "correct": true, "note": "Choosing not to say something is completely different from never having noticed it was missing." },
        { "text": "You have to say it or the conversation is pointless.", "correct": false, "note": "Too strong. Plenty of these conversations work without it." },
        { "text": "Say it, but soften it heavily.", "correct": false, "note": "Softening a consequence into vagueness is how it stops being information and starts sounding like something worse." },
        { "text": "Leave it and hope it does not come up.", "correct": false, "note": "Different from deciding. This is the version where you have not chosen at all." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('rehearse-it-first', 4, 'line', $j${
  "says": "What happens to all this if she opens with something else?",
  "model": {
    "line": "Fair. I will keep the first fifteen seconds — I want to talk about the migration project, and I would like to lead it — and improvise the rest.",
    "why": "A script dies at their first unplanned sentence. The opening is the only part whose context you can predict."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not ask permission to start",
      "words": ["is now a good time", "if you have a minute", "sorry to", "do you have time", "hope this is ok", "not sure if"] },
    { "kind": "min_words", "requirement": "Give an actual opening", "n": 12 },
    { "kind": "max_words", "requirement": "Fifteen seconds of speech", "n": 45 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('rehearse-it-first', 5, 'choice', $j${
  "beats": [
    {
      "situation": "You say your written opening out loud for the first time and run out of breath in the third clause.",
      "prompt": "What does that tell you?",
      "options": [
        { "text": "You are more nervous than you thought.", "correct": false, "note": "Possibly, and the sentence would be too long said calmly as well." },
        { "text": "You need to practise it more.", "correct": false, "note": "Practising a four-clause opening more makes you better at a sentence that should be shorter." },
        { "text": "Cut a clause — it is a written sentence.", "correct": true, "note": "Written openings run to four clauses and spoken ones cannot. This is the fault the page cannot show you." },
        { "text": "Speak more slowly on the day.", "correct": false, "note": "Slower makes the breath problem worse, not better." }
      ]
    },
    {
      "situation": "Said aloud, a sorry to spring this on you appears at the front, which was never in the written version.",
      "prompt": "What is that?",
      "options": [
        { "text": "A reasonable courtesy out loud.", "correct": false, "note": "It reads as courtesy and works as an apology for the request, which is the thing Stop apologising removes." },
        { "text": "Nerves, and it will pass on the day.", "correct": false, "note": "On the day it will be worse, not better — that is why the rehearsal exists." },
        { "text": "A sign you should not have the conversation.", "correct": false, "note": "It is a sign about the sentence, not about the decision." },
        { "text": "The crouch, arriving through your mouth.", "correct": true, "note": "Messaging's apology, in speech instead of thumbs. Hearing it once is usually enough to remove it." }
      ]
    }
  ]
}$j$::jsonb);
