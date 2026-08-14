-- Messaging, track 3: Tone with no tone.
--
-- Two directions, and the second is the one that costs a quiet person most.
-- Writing has to add warmth deliberately; reading has to subtract coldness
-- that was never sent. Both are the same fact about the channel seen from
-- opposite ends.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'tone-with-no-tone'),
  1,
  'Everything reads colder',
  $md$In a room, most of what you mean is carried by your face and your voice. In a message none of it is, and the words you would have said out loud arrive stripped of everything that made them warm.

The result is a consistent bias. Text reads slightly colder than it was written — not dramatically, but reliably, in every message, in both directions.

**The move:** treat that as a known property of the channel and correct for it.

It is worth being specific about what is missing, because it explains why perfectly ordinary sentences land oddly. Your face supplies the *I am pleased to hear from you* that runs underneath everything you say to somebody you like. Your voice supplies the difference between a question asked out of interest and one asked to check up. None of that survives, so a neutral sentence does not arrive neutral — it arrives at about minus ten.

This produces two errors and everybody makes both. Sending something you meant warmly that lands flat. And reading something that was written warmly and finding an edge in it that nobody put there.

The correction is not to write in a completely different way. It is one deliberate addition when sending and one deliberate subtraction when reading, both of which take about a second.

There is a second-order effect worth knowing. Because everybody is reading everything slightly cold, a small amount of added warmth goes a very long way — you are not competing with warm messages, you are competing with neutral ones that arrived cool. A single sentence of acknowledgement makes a message noticeably pleasant in a way it would not in speech.

If you keep one thing: nothing you write arrives the way it sounded in your head. Assume minus ten in both directions, and correct.$md$,
  $j$[
    {
      "situation": "You sent something you meant warmly and it landed flat.",
      "line": "(the channel took the warmth out)",
      "why": "Your face supplies the I am pleased to hear from you that runs under everything you say out loud, and none of it survives."
    },
    {
      "situation": "A reply you received has an edge to it.",
      "line": "(assume minus ten and add it back)",
      "why": "Everything arrives slightly cool. Finding an edge is what happens when you read a neutral sentence at face value."
    },
    {
      "situation": "You want a message to feel pleasant.",
      "line": "(one sentence goes a long way)",
      "why": "You are not competing with warm messages, you are competing with neutral ones that arrived cool."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is actually missing from a message?",
      "options": [
        { "text": "Nuance.", "correct": false, "note": "True and vague. Name what was carrying the nuance." },
        { "text": "The face and voice that were carrying most of the warmth.", "correct": true, "note": "Your face supplies the I am pleased to hear from you underneath everything, and your voice separates interest from checking up. Neither survives." },
        { "text": "Context.", "correct": false, "note": "Context can be written. What cannot be written is the thing that was never in the words." },
        { "text": "Body language.", "correct": false, "note": "Not present in a phone call either, and phone calls do not have this problem to the same degree." }
      ],
      "explain": "A neutral sentence does not arrive neutral. It arrives at about minus ten."
    },
    {
      "prompt": "Why does a little added warmth go so far?",
      "options": [
        { "text": "People are starved of kindness.", "correct": false, "note": "A grand claim, and the mechanism is more mundane than that." },
        { "text": "It is unexpected.", "correct": false, "note": "Partly, and novelty would wear off. This effect does not." },
        { "text": "You are competing with neutral messages that arrived cool.", "correct": true, "note": "One sentence of acknowledgement makes a message noticeably pleasant in a way the same sentence would not in speech." },
        { "text": "It signals effort.", "correct": false, "note": "Effort is read in length rather than warmth, and length is a cost." }
      ],
      "explain": "One deliberate addition when sending, one deliberate subtraction when reading."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "corrected_sending", "label": "Added warmth on purpose", "description": "Did not rely on the words alone." },
      { "key": "corrected_reading", "label": "Discounted the coldness", "description": "Assumed minus ten on the way in." },
      { "key": "no_edge", "label": "Did not find an edge", "description": "Read a neutral message as neutral." },
      { "key": "small", "label": "Kept the correction small", "description": "One sentence rather than a rewrite." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have written a factually perfect three-line reply to somebody you like working with, and something about it looks cold.",
    "partner": {
      "name": "Priya",
      "role": "a colleague you get on with",
      "personality": "Reads accurate but bare messages as slightly off, and responds noticeably better to one line of acknowledgement.",
      "mood": "Fine, mildly uncertain about where things stand.",
      "openness": 4
    },
    "opening_beat": "\"Did you get a chance to look at the deck?\"",
    "success_looks_like": "The user adds warmth deliberately rather than sending the bare version.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Respond briefly and slightly flatly to an accurate but bare reply.",
      "Warm up noticeably at any acknowledgement of you or your work.",
      "Never ask whether anything is wrong."
    ]
  }$j$::jsonb,
  $md$Today, reread one message you sent and one you received, assuming minus ten on both. Log what changed.$md$
),
(
  (select id from public.skills where slug = 'tone-with-no-tone'),
  2,
  'Add the warmth on purpose',
  $md$If the channel removes warmth, it has to be put back deliberately, and it is worth knowing which words actually do it.

**The move:** acknowledge them, then answer.

The single most effective thing is not a pleasantry at all: it is evidence that you read what they wrote rather than only extracted the question from it. *That sounds like a nightmare with the printers — yes, Thursday works* is warm because it engages, and it takes four extra words.

That is the whole principle. Warmth in writing is mostly attention, made visible. A long friendly message that ignores what somebody said reads worse than a short one that does not.

The reliable additions, roughly in order of how much they do:

**Referring to their specific thing.** As above.
**Thanks, where something was actually done.** *Thanks for chasing them* rather than a generic sign-off.
**A word about them.** *Hope the week has calmed down.* One line, at the end.
**An exclamation mark or an emoji.** Genuinely functional rather than decorative — they are tone markers, and one is usually enough.

Two things worth avoiding. Warmth at the front, which is throat-clearing however friendly, because anything before the ask is experienced as delay. And volume as a substitute for attention: three exclamation marks and no engagement with what they said reads as enthusiasm aimed at nobody in particular.

The register question people worry about — is this too much for work — is mostly answered by looking at what the other person does. Match their level and go one notch warmer, and you will be right almost every time without having to think about it again.

If you keep one thing: warmth is attention made visible. Four words about their thing beats a paragraph about nothing.$md$,
  $j$[
    {
      "situation": "They have explained a problem and asked a question.",
      "line": "That sounds like a nightmare with the printers — yes, Thursday works.",
      "why": "Four extra words, and it engages with what they said. Warmth in writing is mostly attention made visible."
    },
    {
      "situation": "You want to open warmly.",
      "line": "(warmth at the front is throat-clearing)",
      "why": "Anything before the ask is experienced as delay, however friendly it is. The same words at the end read as warmth."
    },
    {
      "situation": "You are unsure how warm is appropriate at work.",
      "line": "(match their level, then one notch)",
      "why": "It answers the register question almost every time without having to think about it again."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does the most work?",
      "options": [
        { "text": "An exclamation mark.", "correct": false, "note": "Functional as a tone marker and it is the smallest of the additions." },
        { "text": "A friendly opening line.", "correct": false, "note": "At the front it is throat-clearing, however warm the words are." },
        { "text": "Referring to their specific thing.", "correct": true, "note": "Warmth in writing is mostly attention made visible, and four words about their actual problem beats a paragraph about nothing." },
        { "text": "Saying thanks.", "correct": false, "note": "Good where something was actually done, and generic thanks does very little." }
      ],
      "explain": "A long friendly message that ignores what somebody said reads worse than a short one that does not."
    },
    {
      "prompt": "How do you settle the register question at work?",
      "options": [
        { "text": "Keep it formal until you know somebody.", "correct": false, "note": "Safe, and formal reads coldest of all through a channel that is already taking ten off." },
        { "text": "Match their level, then one notch warmer.", "correct": true, "note": "It answers the question almost every time and removes it as something you have to think about again." },
        { "text": "Follow the culture of the team.", "correct": false, "note": "Useful and slow to read, and it varies within a team more than across one." },
        { "text": "Err warm — nobody minds.", "correct": false, "note": "Mostly true, and it produces the occasional badly misjudged message with somebody very formal." }
      ],
      "explain": "And volume is not attention. Three exclamation marks with no engagement reads as enthusiasm aimed at nobody."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "engaged", "label": "Referred to their thing", "description": "Showed the message had been read." },
      { "key": "at_the_end", "label": "Warmth at the end", "description": "Nothing warm in front of the ask." },
      { "key": "matched", "label": "Matched their register", "description": "Their level, one notch up." },
      { "key": "not_volume", "label": "Attention, not volume", "description": "Did not substitute enthusiasm for engagement." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A colleague has sent a long message about a problem with a supplier, ending with a question about Thursday.",
    "partner": {
      "name": "Priya",
      "role": "a colleague",
      "personality": "Notices immediately whether a reply engages with the supplier problem, and is entirely unbothered by short replies that do.",
      "mood": "Frazzled.",
      "openness": 4
    },
    "opening_beat": "\"...anyway, they have now missed two deadlines. Does Thursday still work for you?\"",
    "success_looks_like": "The user acknowledges the supplier problem and answers.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Warm up markedly at any reply that mentions the supplier problem.",
      "Respond flatly to a friendly reply that answers only the Thursday question.",
      "Never mention that you wanted acknowledgement."
    ]
  }$j$::jsonb,
  $md$Today, add four words about their thing to one reply before answering it. Log the four words.$md$
),
(
  (select id from public.skills where slug = 'tone-with-no-tone'),
  3,
  'Full stops, ok, and emoji',
  $md$The small stuff looks absurd written down and it does real work, so it is worth being direct about it rather than pretending otherwise.

**The move:** treat punctuation and emoji as tone markers, because that is what they have become.

**The full stop on a one-word reply.** *Ok.* reads as clipped to a large proportion of people, and *Ok* or *Ok!* does not. This is not a rule anybody agreed to, it is a convention that emerged, and it is now strong enough that ignoring it produces an effect you did not intend. You do not have to like it to account for it.

**One-word replies generally.** *Fine*, *Sure*, *Noted* are efficient and read cool. If you like the person, two words fixes it: *Sure, no problem.*

**Emoji as markers rather than decoration.** A single one at the end of a sentence tells somebody how to read it, which is exactly the job the channel removed. One is a tone marker; four is a mood, and a different one.

**Capitals and exclamation marks.** One exclamation mark is warmth. Three is either delight or panic and the reader has to work out which.

Two calibrations. The conventions vary by age and by workplace, and the safe move is the one from the previous lesson: look at what the other person does. And formality is not the same as coolness — a very correct message can be warm, and *Dear Priya, Thank you for your email* is not warmer than *Hi Priya, thanks for this*, it is just further away.

None of this matters much on its own. It matters because it is free: these are one-character decisions that change how a message lands, and getting them slightly wrong is the commonest reason somebody perfectly friendly comes across as short.

If you keep one thing: your punctuation is doing tone whether you meant it to or not.$md$,
  $j$[
    {
      "situation": "You are replying with a single word.",
      "line": "Sure, no problem.",
      "why": "Two words fixes the coolness of a one-word reply. Fine, Sure and Noted are efficient and read cool."
    },
    {
      "situation": "You wrote Ok.",
      "line": "(the full stop is doing something)",
      "why": "It reads as clipped to a large proportion of people. Not a rule anybody agreed to, and strong enough that ignoring it produces an effect you did not intend."
    },
    {
      "situation": "You are unsure whether emoji are appropriate here.",
      "line": "(look at what they do)",
      "why": "The conventions vary by age and workplace. Matching, then one notch warmer, settles it without having to decide in the abstract."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is a single emoji actually doing?",
      "options": [
        { "text": "Making it informal.", "correct": false, "note": "Informality is a side effect, and a formal message can carry one perfectly well." },
        { "text": "Softening a request.", "correct": false, "note": "Sometimes, and softening the request is not the general function." },
        { "text": "Telling somebody how to read the sentence.", "correct": true, "note": "Which is exactly the job the channel removed. One is a tone marker; four is a mood, and a different one." },
        { "text": "Showing you are friendly.", "correct": false, "note": "Vague, and friendliness is carried by engaging with what they said." }
      ],
      "explain": "Your punctuation is doing tone whether or not you meant it to."
    },
    {
      "prompt": "Is a formal message a cold one?",
      "options": [
        { "text": "Yes — formality reads as distance.", "correct": false, "note": "Distance and coldness are not the same. A very correct message can be entirely warm." },
        { "text": "No — they are different axes.", "correct": true, "note": "Dear Priya, thank you for your email is not warmer or colder than Hi Priya, thanks for this. It is further away." },
        { "text": "Yes, in most workplaces now.", "correct": false, "note": "Conventions have shifted and that is about expectation rather than about warmth." },
        { "text": "Only if there is no greeting.", "correct": false, "note": "Greetings do very little either way compared with whether the message engages." }
      ],
      "explain": "These are one-character decisions that change how a message lands, which is why they are worth getting right."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "markers", "label": "Used tone markers", "description": "Punctuation and emoji doing deliberate work." },
      { "key": "not_one_word", "label": "Avoided the bare one-word reply", "description": "Two words where warmth mattered." },
      { "key": "matched", "label": "Matched their conventions", "description": "Looked at what the other person does." },
      { "key": "restrained", "label": "One, not four", "description": "Did not substitute volume for tone." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Somebody you like has sent you something to look at and you agree with all of it. Your instinct is to reply with one word.",
    "partner": {
      "name": "Priya",
      "role": "a colleague you get on with",
      "personality": "Reads a bare one-word reply as slightly off and spends a moment wondering; reads two words as entirely normal.",
      "mood": "Cheerful.",
      "openness": 4
    },
    "opening_beat": "\"Have a look when you get a sec — I think it is basically there.\"",
    "success_looks_like": "The user sends something warmer than a bare one-word reply.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Respond normally and warmly to two or more words.",
      "Go slightly quiet and uncertain after a bare one-word reply.",
      "Never say that the reply seemed short."
    ]
  }$j$::jsonb,
  $md$Today, turn one one-word reply into a two-word one. Log both.$md$
),
(
  (select id from public.skills where slug = 'tone-with-no-tone'),
  4,
  'A short reply is not anger',
  $md$This is the half that costs a quiet person most, and the whole lesson is one sentence: a curt reply is almost never what it looks like.

*Ok.* *Fine.* *Will do.* *Yep.*

Each of those arrives with an apparent temperature, and each was almost certainly typed with one thumb by somebody walking into a meeting. The coldness is a property of the channel and the circumstances, not of their feelings about you.

**The move:** attribute short replies to the situation before attributing them to the relationship.

The list of ordinary explanations is long and boring: on a train, between meetings, driving, holding a child, low battery, on a phone they hate typing on, answering while doing something else. Every one of those produces exactly the reply that reads as annoyance, and all of them are more likely than annoyance.

The same applies to gaps. A four-hour silence is not a message. A reply that skips one of your questions is not a snub — it is somebody who answered the first thing and got interrupted.

What makes this expensive is not the individual misreading, it is the response. Reading coldness produces coldness back, or an anxious follow-up asking whether everything is all right, and now the other person is dealing with something that did not exist. Do that a few times and a perfectly fine relationship acquires an atmosphere that was manufactured entirely from punctuation.

The check that works: what would this message look like if it had been sent by somebody in a hurry who likes me? Almost always identical. If the two readings produce the same text, the text is not evidence.

And if it genuinely matters — a relationship where the temperature has actually changed — ask plainly, later, rather than reading harder. Nobody has ever solved this by rereading.

If you keep one thing: they are on a train. That explanation is right almost every time and costs you nothing when it is not.$md$,
  $j$[
    {
      "situation": "You get back a message saying Fine.",
      "line": "(they are on a train)",
      "why": "One thumb, walking into a meeting. Every ordinary circumstance produces exactly the reply that reads as annoyance."
    },
    {
      "situation": "You are wondering whether they are annoyed.",
      "line": "(what would this look like from somebody in a hurry who likes you?)",
      "why": "Almost always identical. If the two readings produce the same text, the text is not evidence."
    },
    {
      "situation": "You are drafting a message asking whether everything is all right.",
      "line": "(that hands them something that did not exist)",
      "why": "Reading coldness produces coldness back, and a fine relationship acquires an atmosphere manufactured entirely from punctuation."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the check?",
      "options": [
        { "text": "Ask somebody else how it reads.", "correct": false, "note": "They will read it cold too, because the channel does that to everybody." },
        { "text": "Reread it carefully.", "correct": false, "note": "Rereading manufactures meaning. Nobody has ever solved this by looking harder." },
        { "text": "Would this look different from somebody in a hurry who likes you?", "correct": true, "note": "Almost always identical — and if the two readings produce the same text, the text is not evidence of anything." },
        { "text": "Wait and see what the next message is like.", "correct": false, "note": "Reasonable, and it leaves you carrying it in the meantime, which is the cost." }
      ],
      "explain": "Attribute it to the situation before attributing it to the relationship."
    },
    {
      "prompt": "What makes the misreading expensive?",
      "options": [
        { "text": "You feel bad for an afternoon.", "correct": false, "note": "Real and recoverable. Something worse happens next." },
        { "text": "The response manufactures the problem.", "correct": true, "note": "Coldness back, or an anxious follow-up — and now they are dealing with something that did not exist. Do it a few times and the atmosphere is real." },
        { "text": "You misjudge the relationship.", "correct": false, "note": "Momentarily, and a private misjudgement corrects itself. The response is what makes it durable." },
        { "text": "You stop messaging them.", "correct": false, "note": "One possible outcome among several, and it follows from the same mechanism." }
      ],
      "explain": "If it genuinely matters, ask plainly later rather than reading harder."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "situational", "label": "Blamed the situation", "description": "Attributed the shortness to circumstances." },
      { "key": "no_follow_up", "label": "Sent no anxious follow-up", "description": "Did not ask whether everything was all right." },
      { "key": "no_mirroring", "label": "Did not go cold back", "description": "Replied at their usual warmth." },
      { "key": "asked_if_needed", "label": "Asked plainly if it mattered", "description": "Raised it later rather than rereading." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You sent a long, thought-through message. The reply, four hours later, is: Ok, thanks.",
    "partner": {
      "name": "Priya",
      "role": "a colleague who has been in meetings all afternoon",
      "personality": "Entirely happy with you and entirely unaware the reply read as anything. Responds warmly and at length when there is time.",
      "mood": "Exhausted, between things.",
      "openness": 4
    },
    "opening_beat": "\"Ok, thanks.\"",
    "success_looks_like": "The user responds normally rather than reading anything into it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Reply warmly and at length to anything ordinary, once you have a moment.",
      "Become confused and slightly worried if asked whether everything is all right.",
      "Never explain that you were busy unless asked."
    ]
  }$j$::jsonb,
  $md$Today, take one message that read as cold and reread it as somebody in a hurry who likes you. Log the difference.$md$
),
(
  (select id from public.skills where slug = 'tone-with-no-tone'),
  5,
  'Stop decoding',
  $md$There is a specific activity that eats hours and produces nothing, and almost everybody who finds messaging hard does it: rereading a message to work out what it really means.

**The move:** take messages at face value, and when you cannot, ask rather than decode.

Decoding feels like diligence. You are being careful, reading closely, taking somebody seriously. What it actually does is manufacture content — read anything four times and you will find something, because language is ambiguous enough to support almost any reading, and the one you settle on will be the one that matches what you were already afraid of.

The tell is that the meaning gets worse with each pass. Genuine comprehension converges; decoding diverges, and by the fifth reading you have a theory involving something they said in March.

Three things worth knowing about the messages that get decoded most.

**Brevity is not code.** It is a phone, a thumb, and a meeting.
**Word choice is rarely deliberate.** People type quickly and do not select between synonyms for their implications, however much the chosen one seems to mean something.
**Nothing was hidden for you to find.** The overwhelming majority of messages are exactly what they say, sent by somebody who was thinking about something else.

When you genuinely cannot tell — and this happens, particularly where something real is at stake — there are two moves and they are both plain. Ask: *hard to tell over message, are you annoyed with me?* is a completely ordinary sentence that ends the whole thing in one exchange. Or assume the boring explanation and carry on, which is right most of the time.

What you cannot do is the middle option, which is to keep reading and respond to your reconstruction. That is where people answer a message that was never sent, and the other person, reasonably, has no idea what is happening.

If you keep one thing: if it needs decoding, ask. Rereading has never once produced information.$md$,
  $j$[
    {
      "situation": "You have read the message four times.",
      "line": "(the meaning is getting worse with each pass)",
      "why": "Genuine comprehension converges. Decoding diverges, and by the fifth reading there is a theory involving something they said in March."
    },
    {
      "situation": "They used a word that seems significant.",
      "line": "(people do not select synonyms for their implications)",
      "why": "They typed quickly while thinking about something else. Almost nothing about word choice in a message is deliberate."
    },
    {
      "situation": "You genuinely cannot tell.",
      "line": "Hard to tell over message — are you annoyed with me?",
      "why": "A completely ordinary sentence that ends the whole thing in one exchange, which rereading never will."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "How can you tell decoding from comprehension?",
      "options": [
        { "text": "Comprehension is quicker.", "correct": false, "note": "Sometimes, and a genuinely complicated message can take a while to understand properly." },
        { "text": "Decoding feels anxious.", "correct": false, "note": "True and hard to use as a test in the moment, when everything feels anxious." },
        { "text": "Comprehension converges; decoding gets worse with each pass.", "correct": true, "note": "By the fifth reading there is a theory involving something from March, which is the tell. Understanding does not do that." },
        { "text": "Decoding involves other people's opinions.", "correct": false, "note": "Frequently a symptom, and plenty of it happens entirely alone." }
      ],
      "explain": "Read anything four times and you will find something, because language supports almost any reading."
    },
    {
      "prompt": "What is the option that is not available?",
      "options": [
        { "text": "Asking plainly.", "correct": false, "note": "One of the two good moves, and it ends the whole thing in one exchange." },
        { "text": "Assuming the boring explanation.", "correct": false, "note": "The other good move, and it is right most of the time." },
        { "text": "Waiting for the next message.", "correct": false, "note": "A version of assuming the boring explanation, and it is fine." },
        { "text": "Responding to your reconstruction.", "correct": true, "note": "That is where people answer a message that was never sent, and the other person reasonably has no idea what is happening." }
      ],
      "explain": "If it needs decoding, ask. Rereading has never once produced information."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "face_value", "label": "Took it at face value", "description": "Read it once and believed it." },
      { "key": "no_rereading", "label": "Did not reread", "description": "Stopped before the theory formed." },
      { "key": "asked", "label": "Asked when genuinely unsure", "description": "One plain question rather than more reading." },
      { "key": "no_reconstruction", "label": "Did not answer a reconstruction", "description": "Replied to what was sent." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A message from somebody you work closely with: \"Fine, we can do it your way.\" You have now read it several times.",
    "partner": {
      "name": "Priya",
      "role": "a colleague",
      "personality": "Meant it entirely straightforwardly and was typing between meetings. Answers a plain question honestly and is baffled by a reply to something she did not say.",
      "mood": "Neutral, busy.",
      "openness": 4
    },
    "opening_beat": "\"Fine, we can do it your way.\"",
    "success_looks_like": "The user takes it at face value or asks plainly.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Confirm plainly and warmly that you meant it, if asked.",
      "Be genuinely baffled by a reply that responds to an implied slight.",
      "Never have been annoyed."
    ]
  }$j$::jsonb,
  $md$Today, notice one message you have reread more than twice. Stop, and either ask or assume the boring version. Log which.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('tone-with-no-tone', 1, 'choice', $j${
  "beats": [
    {
      "situation": "You sent a warm, helpful message. The reply is accurate, complete, and somehow reads as cool.",
      "prompt": "What happened?",
      "options": [
        { "text": "They are annoyed about something.", "correct": false, "note": "The reading that manufactures a problem. It is also the least likely explanation on the list." },
        { "text": "The channel takes about ten off everything.", "correct": true, "note": "Your face supplies the I am pleased to hear from you underneath everything said out loud, and none of it survives. A neutral sentence does not arrive neutral." },
        { "text": "You misjudged the register.", "correct": false, "note": "Possible, and it would not explain why perfectly ordinary accurate replies read cool from everybody." },
        { "text": "They are not a warm person.", "correct": false, "note": "A conclusion about somebody drawn from a medium that does this to every person in it." }
      ]
    },
    {
      "situation": "You want your own messages to read as warm as you mean them.",
      "prompt": "How much do you need to add?",
      "options": [
        { "text": "Quite a lot — you are starting from cold.", "correct": false, "note": "Overcorrecting produces the message with four exclamation marks and no engagement, which reads as aimed at nobody." },
        { "text": "Nothing, if the words are friendly.", "correct": false, "note": "Friendly words still arrive at minus ten. That is the whole property being described." },
        { "text": "Rewrite in a warmer style generally.", "correct": false, "note": "A large change to solve something a single sentence fixes." },
        { "text": "One sentence — you are competing with cool neutrals.", "correct": true, "note": "A small amount goes a long way, because everybody else's neutral messages are arriving cool too." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('tone-with-no-tone', 2, 'line', $j${
  "says": "...anyway, they have now missed two deadlines and I have had to redo the schedule twice. Does Thursday still work for you?",
  "model": {
    "line": "Two deadlines is grim, and redoing that schedule twice sounds like a nightmare. Yes, Thursday works.",
    "why": "Warmth in writing is mostly attention made visible. Four words about their actual problem does more than any pleasantry, and it costs almost nothing."
  },
  "checks": [
    { "kind": "echoes_any", "requirement": "Refer to their actual problem",
      "words": ["deadlines", "schedule", "twice", "redo"] },
    { "kind": "forbids_any", "requirement": "Warmth at the end, not the front",
      "words": ["hope you are well", "hope you are having", "sorry to hear but", "anyway", "just quickly"] },
    { "kind": "min_words", "requirement": "Acknowledge, then answer", "n": 10 },
    { "kind": "max_words", "requirement": "Short is fine if it engages", "n": 40 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('tone-with-no-tone', 3, 'choice', $j${
  "beats": [
    {
      "situation": "Somebody you like has sent something over and you agree with all of it. Your instinct is a one-word reply.",
      "prompt": "Which reply?",
      "options": [
        { "text": "Ok.", "correct": false, "note": "The full stop on a one-word reply reads as clipped to a large proportion of people. Not a rule anybody agreed to, and strong enough to matter." },
        { "text": "Noted.", "correct": false, "note": "Efficient, and it reads cool — the whole family of one-word replies does." },
        { "text": "Sure, no problem.", "correct": true, "note": "Two words fixes it entirely, and it costs nothing. One-word replies are efficient and arrive cooler than they were meant." },
        { "text": "Ok!!!", "correct": false, "note": "Volume substituting for warmth. One marker is tone; three is a mood, and the reader has to work out which." }
      ]
    },
    {
      "situation": "You are wondering whether a formal message reads as cold.",
      "prompt": "Does it?",
      "options": [
        { "text": "Yes — formality is distance and distance is coldness.", "correct": false, "note": "Distance and coldness are different axes, which is the useful distinction here." },
        { "text": "Only without a greeting.", "correct": false, "note": "Greetings do very little either way next to whether the message engages with anything." },
        { "text": "Not necessarily — a very correct message can be warm.", "correct": true, "note": "Dear Priya, thank you for your email is not colder than Hi Priya, thanks for this. It is further away." },
        { "text": "Yes, in most workplaces now.", "correct": false, "note": "About shifted expectations rather than about warmth, and it varies within a team more than across one." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('tone-with-no-tone', 4, 'line', $j${
  "says": "Ok, thanks. (Four hours after your long, thought-through message.)",
  "model": {
    "line": "No problem — shout if you want to go through any of it.",
    "why": "Replies at the usual warmth and reads nothing into it. Every ordinary circumstance — a train, a meeting, one thumb — produces exactly the message that looks like annoyance."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not read anything into it",
      "words": ["is everything ok", "are you annoyed", "have i done something", "sorry if", "you seem", "is something wrong", "did i say", "hope i have not"] },
    { "kind": "max_words", "requirement": "Reply normally", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('tone-with-no-tone', 5, 'line', $j${
  "says": "Fine, we can do it your way. (You have now read this several times.)",
  "model": {
    "line": "Great — I will get it set up this afternoon.",
    "why": "Taken at face value, which it almost certainly is. Rereading manufactures meaning, and the reading you settle on will be the one matching what you were already afraid of."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not answer a reconstruction",
      "words": ["if you would rather", "we do not have to", "i can tell you are not", "you clearly", "sorry, we can do it your", "no, forget it", "seems like you"] },
    { "kind": "min_words", "requirement": "Reply to what was actually sent", "n": 5 },
    { "kind": "max_words", "requirement": "Face value, and move on", "n": 30 }
  ]
}$j$::jsonb);
