-- Hard conversations, track 2: Opening it.
--
-- Everything here happens before the substance does, and it decides how the
-- substance lands. Two of the five lessons are about things done by people
-- trying to be kind — the ambush and the dread-summons — which is why they
-- survive: nobody has ever been told they are the unkind option.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'opening-it'),
  1,
  'Name the subject when you ask for the time',
  $md$*Can we talk later?* is a kind-sounding sentence that hands somebody four hours of dread, and it is one of the two standard ways a hard conversation is ruined before it begins.

What happens in those four hours is not neutral. A person with an unspecified serious conversation coming will invent one, and what they invent is reliably worse than what you have — a relationship ending, a job going, an illness. By the time you speak they are braced for a catastrophe, and anything less than one still lands badly, because adrenaline does not know it was a false alarm.

**The move:** ask for the time and name the subject in the same sentence.

*Can we talk this evening? It is about the money thing.* Two facts, both of which they need: there is a conversation, and roughly what it concerns. The subject line does not have to contain the content — you are not delivering it in advance, you are removing the guessing.

Calibrate the reassurance honestly. If it genuinely is small, say so, because *it is not a big drama* is true and useful. If it genuinely is not, do not say it — false reassurance buys you a calmer hour and costs you their trust the moment the conversation starts, and they will remember that you did it.

Give enough notice to be humane and not enough to be cruel. Later today or tomorrow is about right. Naming something serious a week out means seven days of somebody carrying it, which is its own version of the same mistake.

And ask rather than announce. *Can we* leaves them a say in when, and somebody who chose the time arrives more able to have the conversation than somebody who was summoned to it.

If you keep one thing: the subject goes in the same sentence as the request. It costs you nothing and it is the difference between four hours of dread and none.$md$,
  $j$[
    {
      "situation": "You need to raise something serious this evening.",
      "line": "Can we talk tonight? It is about the money thing — not a crisis, but I want to sort it out.",
      "why": "A request, a subject, and an honest calibration. It removes the four hours of inventing something worse."
    },
    {
      "situation": "You are about to send can we talk later.",
      "line": "(that is four hours of dread)",
      "why": "What somebody invents in that gap is reliably worse than what you have, and they arrive braced for a catastrophe."
    },
    {
      "situation": "It is serious and you want to soften the wait.",
      "line": "(do not say it is nothing)",
      "why": "False reassurance buys a calmer hour and costs their trust the moment the conversation starts. They will remember you did it."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is wrong with can we talk later?",
      "options": [
        { "text": "It sounds ominous.", "correct": false, "note": "It does, and tone is not the mechanism. The damage happens in the hours afterwards." },
        { "text": "They will invent something worse than what you have.", "correct": true, "note": "A relationship ending, a job going, an illness. By the time you speak they are braced for a catastrophe, and adrenaline does not know it was a false alarm." },
        { "text": "It gives them time to prepare a defence.", "correct": false, "note": "Preparation on their side is fine and often helps. Dread is the cost, not readiness." },
        { "text": "It is passive aggressive.", "correct": false, "note": "It is almost always meant kindly, which is exactly why the habit survives." }
      ],
      "explain": "The subject goes in the same sentence as the request. It costs nothing."
    },
    {
      "prompt": "How much notice?",
      "options": [
        { "text": "As much as possible, so they can prepare.", "correct": false, "note": "A week out is seven days of somebody carrying it, which is the same mistake stretched." },
        { "text": "None — raise it there and then.", "correct": false, "note": "That is the ambush, and it is the other standard way this gets wrecked." },
        { "text": "Later today or tomorrow.", "correct": true, "note": "Long enough to be humane, short enough not to be cruel. Enough time to arrange a room and not enough to invent a catastrophe." },
        { "text": "Whenever suits you.", "correct": false, "note": "Their state on arrival is most of what you are managing here, so it is not only about your convenience." }
      ],
      "explain": "And ask rather than announce — somebody who chose the time arrives better able to have it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named_subject", "label": "Named the subject", "description": "Said roughly what it was about." },
      { "key": "asked", "label": "Asked rather than summoned", "description": "Left them a say in when." },
      { "key": "honest", "label": "Calibrated honestly", "description": "Did not falsely reassure." },
      { "key": "short_notice", "label": "Gave humane notice", "description": "Today or tomorrow rather than next week." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have decided to raise the money thing with your flatmate this evening. You are about to message them.",
    "partner": {
      "name": "Jo",
      "role": "your flatmate",
      "personality": "Anxious by default. Spirals visibly at an unspecified request to talk, and relaxes completely when told the subject.",
      "mood": "Ordinary afternoon.",
      "openness": 4
    },
    "opening_beat": "The message box is open.",
    "success_looks_like": "The user asks for time and names the subject in the same message.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Reply with visible anxiety and a guess at something worse if the subject is not named.",
      "Reply calmly and agree readily when told what it is about.",
      "Never ask what it is about — that is the point being tested."
    ]
  }$j$::jsonb,
  $md$Today, ask for one conversation and name the subject in the same sentence. Log what you sent.$md$
),
(
  (select id from public.skills where slug = 'opening-it'),
  2,
  'Not in passing',
  $md$The other standard failure is the ambush, and like the dread-summons it is usually committed by somebody trying to make it easier — on themselves, which is the part that is hard to see at the time.

Raising something serious at the door, in the last two minutes of a call, in a corridor, or in the car on the way somewhere is enormously tempting, because it is over before the fear gets a chance to build. What it produces is a reaction to the ambush rather than to the content. Somebody with no warning, no room and no exit will defend themselves, and the conversation you get is about the fact that you did it that way.

**The move:** pick a setting with time and privacy, and do not raise it anywhere else.

The things that make a setting work are unglamorous. Enough time that neither of you is watching a clock. Privacy, or at least nobody who knows either of you within earshot. And no third thing happening — not while cooking, not while driving, not five minutes before somebody's mother arrives.

Side by side beats face to face for the difficult ones, which is worth knowing. A walk, a drive, washing up together: less eye contact, a natural rhythm, and something to look at other than each other. It takes a surprising amount of pressure out and it is much easier for a person who finds directness hard.

Two settings to rule out specifically. Not last thing at night, when everybody is worse at this and nobody sleeps afterwards. And not in front of anybody, ever — a difficult thing said with an audience is a public event, and the other person will be managing how they look while trying to hear it.

And do not raise it drunk, or at the end of an evening that was going well. Both are the same error: reaching for a moment where it feels briefly easy to say, at the cost of every condition that makes it land.

If you keep one thing: time, privacy, and no third thing. The setting does more work than the wording.$md$,
  $j$[
    {
      "situation": "You are at the door, coat on, and it would be easy to say it now.",
      "line": "(that is over before the fear builds, and it is an ambush)",
      "why": "No warning, no room and no exit produces a reaction to how you did it rather than to what you said."
    },
    {
      "situation": "You find sitting opposite somebody difficult.",
      "line": "(a walk, or the washing up)",
      "why": "Less eye contact, a natural rhythm, something to look at. It takes real pressure out and is much easier for anybody who finds directness hard."
    },
    {
      "situation": "The evening has gone well and you are both a bit drunk.",
      "line": "(both wrong, for the same reason)",
      "why": "Reaching for a moment where it feels briefly easy to say, at the cost of every condition that makes it land."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is the ambush so tempting?",
      "options": [
        { "text": "It is over before the fear has time to build.", "correct": true, "note": "It solves your problem — the anticipation — by removing every condition that makes the conversation work for them." },
        { "text": "It seems less confrontational.", "correct": false, "note": "It is more confrontational in effect, because the other person has no room to respond in." },
        { "text": "There is never a good moment anyway.", "correct": false, "note": "The belief that produces it, and there are plainly better and worse ones." },
        { "text": "It keeps it small.", "correct": false, "note": "It makes it bigger. A serious thing raised in a doorway is about the doorway within thirty seconds." }
      ],
      "explain": "Time, privacy, and no third thing happening."
    },
    {
      "prompt": "Why does side by side help?",
      "options": [
        { "text": "It feels more like a team.", "correct": false, "note": "A nice framing and not what does the work." },
        { "text": "It is harder to walk away from.", "correct": false, "note": "Easier, if anything, and making it hard to leave is not the goal." },
        { "text": "Less eye contact and something else to look at.", "correct": true, "note": "It takes a surprising amount of pressure out, and it is considerably easier for anybody who finds directness hard." },
        { "text": "You can control the pace better.", "correct": false, "note": "Both people control the pace. The benefit is about where the eyes go." }
      ],
      "explain": "A walk, a drive, the washing up. The setting does more work than the wording."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "time", "label": "Left enough time", "description": "Neither of you watching a clock." },
      { "key": "private", "label": "Kept it private", "description": "No audience, and nobody within earshot." },
      { "key": "no_third_thing", "label": "No third thing happening", "description": "Not while driving, cooking, or five minutes before somebody arrives." },
      { "key": "not_at_the_door", "label": "Did not ambush", "description": "Resisted the easy moment in passing." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are both in the kitchen. Their friend arrives in ten minutes and you have been meaning to raise something for a fortnight.",
    "partner": {
      "name": "Jo",
      "role": "your flatmate",
      "personality": "Reacts to the timing rather than the content when something serious arrives with no room. Engages properly when given a real setting.",
      "mood": "Cheerful, one eye on the clock.",
      "openness": 4
    },
    "opening_beat": "\"Right, they will be here in ten. Do you want anything from the shop?\"",
    "success_looks_like": "The user waits and arranges a proper time rather than raising it now.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Respond to anything serious raised now with visible stress about the time and a defensive reply.",
      "Agree readily and warmly to a proper conversation later.",
      "Never invite the user to raise something now."
    ]
  }$j$::jsonb,
  $md$Today, notice one moment where you could raise something in passing, and do not. Arrange a real time instead. Log both.$md$
),
(
  (select id from public.skills where slug = 'opening-it'),
  3,
  'Say it in the first thirty seconds',
  $md$You are in the room, you have the time, and you have decided to warm up a bit first. This is the last place the conversation gets ruined before it starts.

Ten minutes of pleasantries in front of a difficult subject feels gentler and is a trapdoor. Everybody has been on the receiving end of a conversation that started well and turned, and everybody remembers the moment they realised what the first ten minutes had been for. It retrospectively converts the warmth into technique, which is worse than having had no warmth at all.

**The move:** say it in the first thirty seconds, then let it be as long as it needs.

*Thanks for making time. The thing I wanted to talk about is the cancelling.* That is a whole opening, and everything after it is the conversation rather than a runway to it.

It is worth being clear about who the warm-up is for. It is not making it easier for them — they know something is coming, because you asked for the time and named the subject. It is you, delaying the moment, and the cost of that delay lands entirely on them: ten minutes of waiting for the turn is worse than thirty seconds of getting there.

A second failure lives in the same place: burying it. Starting somewhere adjacent and hoping to arrive at the real subject sideways produces a conversation where they answer the adjacent thing, you feel unheard, and you leave having discussed a different problem. If the subject is the cancelling, the first sentence contains the word cancelling.

Practically, the opening has three parts and takes about fifteen seconds. Thank them for the time. Name the thing. Say what you want from the conversation — *I want to sort it out rather than have a row* is not a platitude, it tells somebody how to hear the next twenty minutes.

If you keep one thing: no runway. Say it early, then take as long as you like over it.$md$,
  $j$[
    {
      "situation": "You have sat down and you are about to ask about their week.",
      "line": "(that is a runway, and they know something is coming)",
      "why": "Ten minutes of waiting for the turn is worse for them than thirty seconds of getting there, and it converts the warmth into technique afterwards."
    },
    {
      "situation": "You want to approach the subject sideways.",
      "line": "(they will answer the sideways thing)",
      "why": "You leave having discussed a different problem and feeling unheard. If the subject is the cancelling, the first sentence contains the word cancelling."
    },
    {
      "situation": "You have named it and want them to know what this is.",
      "line": "I want to sort it out, not have a row.",
      "why": "Not a platitude. It tells somebody how to hear the next twenty minutes, which changes how they hear them."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Who is the warm-up actually for?",
      "options": [
        { "text": "Them — it softens the blow.", "correct": false, "note": "They know something is coming; you asked for time and named the subject. Nothing is being softened." },
        { "text": "Both of you, a bit.", "correct": false, "note": "The comfortable answer, and it is why the habit survives being obviously counterproductive." },
        { "text": "The relationship — it reminds you that you like each other.", "correct": false, "note": "A real thing, and it belongs after rather than before. Said before, it gets retrospectively reread." },
        { "text": "You, and the delay costs them.", "correct": true, "note": "Ten minutes of waiting for the turn is worse than thirty seconds of getting there, and afterwards it makes the warmth look like technique." }
      ],
      "explain": "No runway. Thirty seconds, then take as long as you like."
    },
    {
      "prompt": "What does burying it produce?",
      "options": [
        { "text": "A gentler version of the same conversation.", "correct": false, "note": "A different conversation, which is the problem rather than a softer form of the right one." },
        { "text": "They answer the adjacent thing and you leave unheard.", "correct": true, "note": "You have discussed a different problem, and the actual one is still there — usually with the added feeling that you tried and it did not work." },
        { "text": "Nothing much — you get there in the end.", "correct": false, "note": "Sometimes, and by then the temperature is set by whatever the adjacent subject did." },
        { "text": "They work out what you mean.", "correct": false, "note": "Occasionally, and being made to guess at an accusation is its own unpleasant experience." }
      ],
      "explain": "If the subject is the cancelling, the first sentence contains the word cancelling."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "early", "label": "Said it in the first thirty seconds", "description": "No runway of pleasantries." },
      { "key": "named", "label": "Named the actual subject", "description": "Did not approach it sideways." },
      { "key": "purpose", "label": "Said what they wanted from it", "description": "Told them how to hear the next twenty minutes." },
      { "key": "then_slow", "label": "Then took time", "description": "Was quick to the point and unhurried afterwards." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have both sat down. They made the time, they know it is about the cancelling, and they are waiting.",
    "partner": {
      "name": "Jo",
      "role": "somebody you have asked for a conversation",
      "personality": "Becomes noticeably more tense the longer the small talk goes on, and relaxes into the conversation once the subject is actually named.",
      "mood": "Braced, willing.",
      "openness": 4
    },
    "opening_beat": "\"So. You said it was about the plans thing.\"",
    "success_looks_like": "The user names the subject immediately rather than warming up.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Get visibly more tense and give shorter answers the longer small talk continues.",
      "Engage properly and openly once the subject is named plainly.",
      "Never raise the subject yourself beyond the opening line."
    ]
  }$j$::jsonb,
  $md$Today, open one difficult thing in the first thirty seconds. No warm-up. Log your opening sentence.$md$
),
(
  (select id from public.skills where slug = 'opening-it'),
  4,
  'Say what you want from it',
  $md$One sentence at the start does more to change how a hard conversation goes than any amount of careful phrasing later, and almost nobody includes it.

**The move:** say what you want the conversation to produce.

*I want to sort this out, not have a row.* *I am not looking for an apology, I want us to do it differently.* *I mostly just want you to know, and then I am happy to leave it.* Each of those is short, honest, and does something structural: it tells the other person what shape they are in.

Without it, they have to guess, and the guess is almost always defensive — because the safest assumption when somebody sits you down is that you are about to be blamed for something. A person who thinks they are being prosecuted behaves like a defendant, and you will spend the conversation arguing with a defence rather than talking to a person.

It also tells them what would count as this going well, which is genuinely useful information they do not otherwise have. Plenty of hard conversations fail because one person wanted to be heard and the other spent forty minutes proposing solutions, or because one wanted a plan and the other kept apologising.

Be honest about it rather than diplomatic. If you do want an apology, saying so is much better than pretending otherwise and then feeling short-changed by a solution. If you want the behaviour to change and you are not really interested in why it happened, that is worth saying too, kindly.

And keep it to one sentence. This is a frame rather than an argument, and a long preamble about your intentions starts to sound like a case being built — which produces the defensiveness you were trying to avoid.

If you keep one thing: tell them what you want out of it. It is one sentence, it is at the start, and it decides whether you are talking to a person or a defendant.$md$,
  $j$[
    {
      "situation": "You have named the subject and they are visibly braced.",
      "line": "I want to sort this out, not have a row.",
      "why": "It tells them what shape they are in. Without it the safest assumption is that they are about to be blamed, and a defendant behaves like a defendant."
    },
    {
      "situation": "You want them to hear it rather than fix it.",
      "line": "I mostly want you to know, and then I am happy to leave it.",
      "why": "Plenty of hard conversations fail because one person wanted to be heard and the other spent forty minutes proposing solutions."
    },
    {
      "situation": "You do actually want an apology.",
      "line": "(then say so)",
      "why": "Better than pretending otherwise and feeling short-changed by a solution you said you wanted."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What happens if you do not say it?",
      "options": [
        { "text": "They assume they are being blamed.", "correct": true, "note": "The safest assumption when somebody sits you down, and a person who thinks they are being prosecuted behaves like a defendant." },
        { "text": "They ask what you want.", "correct": false, "note": "Almost nobody does. They act on a guess instead." },
        { "text": "The conversation takes longer.", "correct": false, "note": "It usually does, and that is downstream of the misreading rather than the main cost." },
        { "text": "Nothing — it becomes clear as you go.", "correct": false, "note": "By then the temperature has been set by twenty minutes of them defending themselves." }
      ],
      "explain": "One sentence at the start decides whether you are talking to a person or a defendant."
    },
    {
      "prompt": "How long should it be?",
      "options": [
        { "text": "Long enough to be clear about your intentions.", "correct": false, "note": "A preamble about your intentions starts to sound like a case being built, which produces the defensiveness you were avoiding." },
        { "text": "As long as it takes to sound sincere.", "correct": false, "note": "Sincerity is not produced by length, and the effort of demonstrating it reads as management." },
        { "text": "Two or three, so nothing is ambiguous.", "correct": false, "note": "Ambiguity is not the risk here. One clear sentence removes it." },
        { "text": "One sentence.", "correct": true, "note": "It is a frame rather than an argument. Anything longer changes what it is doing." }
      ],
      "explain": "And be honest rather than diplomatic — say the thing you actually want."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_it", "label": "Said what they wanted", "description": "Named the outcome at the start." },
      { "key": "honest", "label": "Was honest about it", "description": "Said the real want rather than a diplomatic one." },
      { "key": "one_sentence", "label": "Kept it to a sentence", "description": "A frame rather than a case." },
      { "key": "early", "label": "Put it early", "description": "Before the substance rather than after it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have named the subject. They have gone quiet and slightly stiff, and are clearly waiting to find out how bad this is.",
    "partner": {
      "name": "Jo",
      "role": "somebody you have asked for a conversation",
      "personality": "Defaults to defending themselves when they do not know what is being asked. Relaxes markedly when told what the conversation is for.",
      "mood": "Braced.",
      "openness": 4
    },
    "opening_beat": "\"Okay. Go on, then.\"",
    "success_looks_like": "The user says what they want the conversation to produce.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Begin defending yourself if the substance arrives with no frame around it.",
      "Relax and engage properly once told what the conversation is for.",
      "Never ask what they want from it."
    ]
  }$j$::jsonb,
  $md$Today, tell somebody at the start of a difficult conversation what you want out of it. One sentence. Log it.$md$
),
(
  (select id from public.skills where slug = 'opening-it'),
  5,
  'Written, or in person',
  $md$Everybody who finds this hard has considered writing it instead, and the advice they usually get — *never do it over text* — is too blunt to be useful.

**The move:** in person by default, written only when it buys something real.

In person is the default for a reason that is not etiquette. You get tone, you get to see what is landing, and you can respond to what actually happens rather than to what you imagined. Written removes all three, and it removes them in a specific direction: text reads colder than it was meant, every time, because the warmth that would have been in your face and voice is not in the words.

A written message also lasts, can be reread when somebody is at their lowest, and can be forwarded. A sentence you would have said once and softened with your face becomes a document.

But it does buy two things, and they are worth being honest about.

**It gets it said.** A person who will not manage it in the room and will manage it in writing should write it. A difficult thing said imperfectly is worth more than a perfect one that never happens, and that trade is real for a lot of people.

**It survives being interrupted.** If the other person talks over you, or reliably turns things round, writing gets your whole point out intact — which occasionally matters more than tone does.

The hybrid is better than either and almost nobody uses it: a short message that names the subject and asks to talk, then the conversation itself in person. That is exactly the first lesson in this track, and it means the written part is doing the part writing is good at.

If you must do it all in writing: short, no accusations, no lists, and end by asking to talk. Long written grievances are the worst artefact this topic can produce.

If you keep one thing: write to open it, talk to have it.$md$,
  $j$[
    {
      "situation": "You know you will not manage it in the room.",
      "line": "(then write it)",
      "why": "A difficult thing said imperfectly beats a perfect one that never happens, and that trade is real for a lot of people."
    },
    {
      "situation": "You are drafting three paragraphs about what they did.",
      "line": "(that becomes a document)",
      "why": "It lasts, it can be reread at somebody's lowest, and it can be forwarded. A long written grievance is the worst artefact this topic produces."
    },
    {
      "situation": "You want the benefits of both.",
      "line": "A short message naming the subject, then talk in person.",
      "why": "The written part does the part writing is good at, and almost nobody uses this."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does writing it actually cost?",
      "options": [
        { "text": "It seems cowardly.", "correct": false, "note": "How it looks, and it is not the mechanism — plenty of brave people write things down." },
        { "text": "Text reads colder than it was meant, every time.", "correct": true, "note": "The warmth that would have been in your face and voice is not in the words, and it lasts, can be reread at somebody's lowest, and can be forwarded." },
        { "text": "They will not take it seriously.", "correct": false, "note": "They often take it more seriously, which is part of the problem rather than a reassurance." },
        { "text": "You cannot tell if they are upset.", "correct": false, "note": "True and one of three costs. The colder reading is the one that does the damage on its own." }
      ],
      "explain": "In person by default. Writing removes tone, response, and the ability to see what is landing."
    },
    {
      "prompt": "When is writing genuinely the better call?",
      "options": [
        { "text": "When it is very serious.", "correct": false, "note": "Seriousness argues for in person, where you can see what it is doing to somebody." },
        { "text": "When you want a record.", "correct": false, "note": "Sometimes necessary at work, and wanting a record changes what the conversation is." },
        { "text": "When otherwise it will not happen at all.", "correct": true, "note": "A difficult thing said imperfectly is worth more than a perfect one that never happens. That trade is real." },
        { "text": "When you are too angry to speak.", "correct": false, "note": "Then wait. Angry writing is the version most likely to become a document you regret." }
      ],
      "explain": "Write to open it, talk to have it. The hybrid beats either alone."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "default", "label": "Defaulted to in person", "description": "Chose the room unless writing bought something real." },
      { "key": "hybrid", "label": "Used the hybrid", "description": "Wrote to open it and talked to have it." },
      { "key": "short", "label": "Kept any writing short", "description": "No lists, no accusations, no paragraphs." },
      { "key": "got_it_said", "label": "Chose getting it said", "description": "Wrote it rather than not doing it at all." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have drafted a long message about the whole thing and are deciding whether to send it.",
    "partner": {
      "name": "Sam",
      "role": "a friend you have shown the draft to",
      "personality": "Asks what the message is for and whether it would be read the way it is meant. Suggests nothing directly.",
      "mood": "Careful.",
      "openness": 5
    },
    "opening_beat": "\"Four paragraphs. What do you want them to do when they have read it?\"",
    "success_looks_like": "The user chooses the hybrid or shortens the message drastically.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask how it would read on a bad day, and who else might see it.",
      "Take seriously the possibility that writing is the only way it happens.",
      "Never tell the user to send or not send it."
    ]
  }$j$::jsonb,
  $md$Today, take one thing you were going to write out in full and cut it to a message that names the subject and asks to talk. Log both lengths.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('opening-it', 1, 'line', $j${
  "says": "(the message box is open — you have decided to raise the money thing with your flatmate this evening)",
  "model": {
    "line": "Can we talk this evening? It is about the money thing — not a crisis, I just want to sort it out.",
    "why": "A request rather than a summons, the subject named, and an honest calibration. It removes the four hours in which somebody invents something much worse."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Ask, do not summon" },
    { "kind": "contains_any", "requirement": "Name what it is about",
      "words": ["money", "rent", "bills", "about the", "regarding"] },
    { "kind": "forbids_any", "requirement": "No unspecified dread",
      "words": ["we need to talk", "can we talk later", "need to speak to you", "something i need to say", "when you get in"] },
    { "kind": "max_words", "requirement": "Two lines", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('opening-it', 2, 'choice', $j${
  "beats": [
    {
      "situation": "You are both in the kitchen. Their friend arrives in ten minutes, and you have been meaning to raise something for a fortnight.",
      "prompt": "Now?",
      "options": [
        { "text": "Yes — it is a good opening and it will be over quickly.", "correct": false, "note": "Over quickly is what it does for you. For them it is no warning, no room and no exit, and the reply you get is to the ambush." },
        { "text": "Yes, but keep it light so it does not derail the evening.", "correct": false, "note": "A serious thing raised lightly with ten minutes on the clock gets the worst of both — it is heard, and it cannot be answered." },
        { "text": "No. Ask for a proper time later.", "correct": true, "note": "Time, privacy and no third thing happening. The setting does more work than the wording." },
        { "text": "No — and drop it, since the moment has gone.", "correct": false, "note": "The moment was never there. Not raising it now is not the same as not raising it." }
      ]
    },
    {
      "situation": "You are arranging a real time, and you find sitting opposite people difficult.",
      "prompt": "What setting?",
      "options": [
        { "text": "Sitting down properly, facing each other, so it is taken seriously.", "correct": false, "note": "Seriousness is not produced by seating, and face to face is the hardest configuration for anybody who finds directness difficult." },
        { "text": "A walk, or something side by side.", "correct": true, "note": "Less eye contact, a natural rhythm, and something else to look at. It takes real pressure out of the conversation." },
        { "text": "A café, so neither of you can make a scene.", "correct": false, "note": "An audience means they will be managing how they look while trying to hear you." },
        { "text": "Last thing at night, when there is no rush.", "correct": false, "note": "Everybody is worse at this then, and nobody sleeps afterwards." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('opening-it', 3, 'line', $j${
  "says": "So. You said it was about the plans thing.",
  "model": {
    "line": "Yes — thanks for making the time. It is about the cancelling, and I want to sort it out rather than have a row about it.",
    "why": "The subject in the first sentence and the purpose in the second. No runway, and nothing for them to guess at."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Name the subject immediately",
      "words": ["cancel", "cancelling", "cancelled", "plans", "the thing about"] },
    { "kind": "forbids_any", "requirement": "No runway and no sideways approach",
      "words": ["how was your", "how have you been", "before we get into", "anyway", "not sure how to say", "this is difficult", "bear with me"] },
    { "kind": "max_words", "requirement": "Thirty seconds, not three minutes", "n": 45 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('opening-it', 4, 'line', $j${
  "says": "Okay. Go on, then.",
  "model": {
    "line": "Before I do — I want to sort this out, not have a row. I am not after an apology.",
    "why": "One sentence that tells them what shape they are in. Without it the safest assumption is that they are about to be blamed, and a defendant behaves like a defendant."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Say what you want out of it" },
    { "kind": "forbids_any", "requirement": "A frame, not a case",
      "words": ["i have been thinking", "for a long time", "you probably know", "i do not want to upset", "please do not take", "hear me out"] },
    { "kind": "max_sentences", "requirement": "One sentence — it is a frame", "n": 2 },
    { "kind": "max_words", "requirement": "Short enough to be a frame", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('opening-it', 5, 'choice', $j${
  "beats": [
    {
      "situation": "You have drafted four paragraphs about the whole thing and you are deciding whether to send it.",
      "prompt": "What do you do with it?",
      "options": [
        { "text": "Send it — it is clearer than you would manage out loud.", "correct": false, "note": "It lasts, it can be reread on a bad day, and it can be forwarded. A sentence you would have softened with your face becomes a document." },
        { "text": "Cut it to a message naming the subject and asking to talk.", "correct": true, "note": "The written part does what writing is good at, and the conversation happens where tone and response exist. Almost nobody uses the hybrid." },
        { "text": "Do not send anything and say it in person instead.", "correct": false, "note": "Better than the four paragraphs, and it throws away the part writing is genuinely good for — opening it." },
        { "text": "Send it and then follow up in person.", "correct": false, "note": "The document still exists, and the conversation now starts from whatever the four paragraphs did." }
      ]
    },
    {
      "situation": "You know, honestly, that you will not manage to say it in the room.",
      "prompt": "What then?",
      "options": [
        { "text": "Do it in person anyway — it is the right way.", "correct": false, "note": "Etiquette that produces nothing. A thing not said is not a better version of a thing said imperfectly." },
        { "text": "Write it, and keep it short.", "correct": true, "note": "Getting it said is worth more than getting it said well, and that trade is real for a lot of people. Short, no lists, no accusations, and end by asking to talk." },
        { "text": "Wait until you feel able to.", "correct": false, "note": "That is soon, which the previous track established is not an answer." },
        { "text": "Get somebody else to raise it.", "correct": false, "note": "It changes the conversation entirely and makes it about who is involved rather than what happened." }
      ]
    }
  ]
}$j$::jsonb);
