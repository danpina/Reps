-- Messaging, track 1: Stop apologising.
--
-- The shop window, and the most directly useful track in the topic. Writing is
-- the one place a quiet person's habits are visible before they land — you can
-- see the apology sitting there and delete it, which is not available in a
-- room.
--
-- All free, and mostly line drills, because a message is exactly what a line
-- drill is.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'stop-apologising'),
  1,
  'Everything before the ask',
  $md$*Sorry to bother you! I know you are really busy at the moment. This is probably a stupid question and feel free to ignore it, but I was just wondering whether the report needs the March figures.*

The message is one line long. Everything else was written to be polite.

**The move:** delete everything in front of the ask.

*Does the report need the March figures?* is the whole thing. It is not blunt, it is not rude, and it is not missing anything the other person needed.

Three costs, in ascending order.

**Length.** A four-line message about a one-line question gets left for later, and later is where messages are forgotten.

**Framing.** *Sorry to bother you* asserts that this is a bother. *Probably a stupid question* asserts that it is stupid. Both are almost certainly untrue, you have supplied them unprompted, and the reader has no reason not to take them at face value.

**The reassurance tax.** This is the real one. An apology asks for a response before the request can be answered — now they have to say *no, not at all, happy to help*, which is work, and it is work about you. A message that must be reassured before it can be dealt with is a harder message to deal with, which is the opposite of what the politeness was for.

The test is mechanical and takes two seconds: find the sentence containing the actual ask, and check whether anything above it is doing a job. Almost always the answer is no, and almost always deleting it produces a message that reads as calm rather than curt.

If you keep one thing: find the ask and delete upwards. What is left is the message you meant to send.$md$,
  $j$[
    {
      "situation": "You have written four lines and the question is in the last one.",
      "line": "(delete upwards from the ask)",
      "why": "Find the sentence with the actual question in it and check whether anything above it is doing a job. Almost always nothing is."
    },
    {
      "situation": "You are about to write sorry to bother you.",
      "line": "(that asserts it is a bother)",
      "why": "You have supplied a framing unprompted, about something they had no complaint with, and there is no reason for them not to take it at face value."
    },
    {
      "situation": "The short version feels rude.",
      "line": "(it reads as calm)",
      "why": "Curt is a different thing, and it comes from coldness rather than from brevity. A direct question with a thank you at the end is warm."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the real cost of the apology?",
      "options": [
        { "text": "It makes the message longer.", "correct": false, "note": "The smallest of the three, and it is the one people notice." },
        { "text": "It asks to be reassured before the question can be answered.", "correct": true, "note": "Now they have to say no, not at all, happy to help — which is work, about you, created by you. A message that needs reassuring is harder to deal with." },
        { "text": "It makes you look unconfident.", "correct": false, "note": "How it reflects on you, which is the least practical framing and not what makes the message worse to receive." },
        { "text": "It buries the question.", "correct": false, "note": "Real, and it is the framing and reassurance costs that do the lasting damage." }
      ],
      "explain": "Find the ask and delete upwards. Politeness was never the thing being removed."
    },
    {
      "prompt": "What is the two-second test?",
      "options": [
        { "text": "Read it back as though you received it.", "correct": false, "note": "Useful generally, and it takes longer and gives a vaguer answer than the mechanical version." },
        { "text": "Cut it to half the length.", "correct": false, "note": "Compression rather than diagnosis. It might cut the wrong half." },
        { "text": "Check whether anything above the ask is doing a job.", "correct": true, "note": "Find the sentence containing the actual question. Almost always nothing above it is doing anything, and deleting it produces the message you meant." },
        { "text": "Remove every apology word.", "correct": false, "note": "Close, and word-hunting misses the preamble that contains no apology words and is still pure throat-clearing." }
      ],
      "explain": "Almost always the answer is no, and what is left reads as calm."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "ask_first", "label": "Led with the ask", "description": "Nothing in front of the actual question." },
      { "key": "no_apology", "label": "No apology", "description": "Did not assert that it was a bother." },
      { "key": "short", "label": "Kept it short", "description": "A one-line question sent as a one-line message." },
      { "key": "still_warm", "label": "Stayed warm", "description": "Direct without being curt." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You need to know whether a report includes the March figures. You are messaging a colleague you get on with.",
    "partner": {
      "name": "Priya",
      "role": "a colleague",
      "personality": "Answers direct questions in seconds. Responds to an apologetic message by reassuring the sender first and answering second.",
      "mood": "Busy, friendly.",
      "openness": 4
    },
    "opening_beat": "The message box is open.",
    "success_looks_like": "The user asks the question with nothing in front of it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer a direct question immediately and warmly.",
      "Reassure first and answer second if the message opens with an apology.",
      "Never comment on how the message was written."
    ]
  }$j$::jsonb,
  $md$Today, write one message, then delete everything above the ask before sending. Log both versions.$md$
),
(
  (select id from public.skills where slug = 'stop-apologising'),
  2,
  'The word just',
  $md$*Just wondering.* *Just checking.* *Just a quick one.* *Just following up.* *I just wanted to ask.*

It is the most common word in the messages of people worried about taking up space, and its only function is to make what follows smaller.

**The move:** delete every *just* and read it back.

Almost nothing changes except the size of the request. *I was just wondering whether you had a minute* and *do you have a minute* ask for exactly the same thing, and one of them apologises for asking while the other does not.

It is worth being clear about what the word is doing, because it feels harmless. *Just* pre-emptively minimises — it says *this is a small thing, I am not asking for much, please do not be annoyed.* Nobody was going to be annoyed. You have introduced the possibility and then defended against it, in one syllable, before the request arrives.

The same family is worth catching while you are looking. *Quick* — a quick question, a quick favour, a quick call — which promises a duration you cannot control and is doing the same shrinking work. *Sorry* used as punctuation rather than as an apology for anything. *If you have time*, *no worries if not*, *whenever suits* — each of which is an exit handed over before anybody has objected.

The exception, and it is a real one: *just* is fine when it is doing literal work. *I just sent it* means a moment ago. *Just the one* means only. Delete the ones that could be removed without changing the meaning, which is nearly all of them.

A useful exercise, once, rather than as a permanent habit: search your sent messages for *just*. Most people find something between twenty and a hundred, and the count is more persuasive than any argument here.

If you keep one thing: if it can be deleted without changing the meaning, it was shrinking the request rather than softening it.$md$,
  $j$[
    {
      "situation": "You have written I was just wondering whether you had a minute.",
      "line": "Do you have a minute?",
      "why": "Exactly the same request, and one version apologises for making it while the other does not."
    },
    {
      "situation": "You are about to offer a quick question.",
      "line": "(quick is doing the same job)",
      "why": "It promises a duration you cannot control and shrinks the request before it arrives."
    },
    {
      "situation": "You wrote I just sent it.",
      "line": "(that one is fine)",
      "why": "It is doing literal work. Delete the ones that could go without changing the meaning."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is just actually doing?",
      "options": [
        { "text": "Softening the tone.", "correct": false, "note": "It feels like softening, and what it softens is the size of your request rather than the manner of it." },
        { "text": "Making the sentence flow.", "correct": false, "note": "Removing it almost never damages the sentence, which is the test." },
        { "text": "Pre-emptively minimising the request.", "correct": true, "note": "It says this is a small thing, please do not be annoyed — introducing a possibility nobody had raised and defending against it in one syllable." },
        { "text": "Signalling informality.", "correct": false, "note": "Informality comes from elsewhere, and plenty of very informal messages contain no justs at all." }
      ],
      "explain": "If it can be deleted without changing the meaning, it was shrinking rather than softening."
    },
    {
      "prompt": "Which is in the same family?",
      "options": [
        { "text": "Thanks, at the end.", "correct": false, "note": "Warmth that costs nothing and asserts nothing about the request. Keep it." },
        { "text": "By Thursday if possible.", "correct": false, "note": "Information rather than apology, and it is the thing that gets a message prioritised." },
        { "text": "A quick question.", "correct": true, "note": "It promises a duration you cannot control and does the same shrinking work — along with no worries if not, whenever suits, and sorry as punctuation." },
        { "text": "Naming what you need.", "correct": false, "note": "The opposite of this family, and the thing the family is usually hiding." }
      ],
      "explain": "Search your sent messages for just, once. The count is more persuasive than any argument."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_just", "label": "No shrinking just", "description": "Removed the ones doing no literal work." },
      { "key": "no_family", "label": "Caught the family", "description": "No quick, no no-worries-if-not, no sorry as punctuation." },
      { "key": "same_ask", "label": "The ask survived", "description": "Removing them did not change what was being asked." },
      { "key": "kept_warmth", "label": "Kept genuine warmth", "description": "Left the thanks in." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You need fifteen minutes of a colleague's time this week. You have drafted a message and it contains three justs.",
    "partner": {
      "name": "Priya",
      "role": "a colleague",
      "personality": "Treats a shrunken request as low priority and gets to it eventually; treats a plain one as a normal ask and answers with a time.",
      "mood": "Busy.",
      "openness": 4
    },
    "opening_beat": "The draft is sitting in the box.",
    "success_looks_like": "The user sends it with the shrinking words removed.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Reply with a specific time to a plain, direct request.",
      "Reply vaguely and later to a request wrapped in minimisers.",
      "Never mention the wording."
    ]
  }$j$::jsonb,
  $md$Today, search your sent messages for the word just. Log how many you find, and delete it from the next one you send.$md$
),
(
  (select id from public.skills where slug = 'stop-apologising'),
  3,
  'Asking is not an imposition',
  $md$Underneath the apology and the *just* is a belief, and unless it is dealt with the words come back within a fortnight.

The belief is that asking somebody for something is taking from them — that their time is real and yours is not, that the question is an interruption, and that the correct posture for making one is a small crouch.

**The move:** notice that ordinary requests are what work and friendship are made of.

Consider the same message arriving from somebody else. A colleague asks you a direct question about the March figures. You do not experience it as an imposition — you answer it, because answering it is the job and it took eleven seconds. Nobody has ever privately resented a clear question, and you know this from the receiving end, where the evidence is unambiguous.

The asymmetry is the whole thing: incoming requests feel ordinary and outgoing ones feel enormous. That is not a fact about the requests.

It is also worth noticing what over-apologising asks *of* them, because it is usually framed as consideration. It says: reassure me, tell me it is fine, take care of my anxiety about having contacted you. That is a larger request than the question was, and it is the one that actually arrives first.

The reframe that holds up in practice: being easy to ask things of is a quality people value, and it is reciprocal. Somebody who asks you directly is somebody you can ask directly, and a relationship where both people crouch before every request is exhausting to be in without anybody being able to say why.

Two small proofs, if the belief is stubborn. Notice how you feel about the last person who asked you something plainly — almost certainly nothing at all. And notice that the people you find easiest to work with are not the ones who apologise most.

If you keep one thing: you already know this from the other side. Incoming questions are fine, and yours are the same size as everybody else's.$md$,
  $j$[
    {
      "situation": "You feel like you are imposing by asking.",
      "line": "(how did you feel about the last person who asked you something?)",
      "why": "Almost certainly nothing at all. Incoming requests feel ordinary and outgoing ones feel enormous, and that is not a fact about the requests."
    },
    {
      "situation": "You are apologising to be considerate.",
      "line": "(it asks them to take care of your anxiety)",
      "why": "Reassure me, tell me it is fine — a larger request than the question, and the one that arrives first."
    },
    {
      "situation": "You are wondering whether being direct costs you anything.",
      "line": "(the people you find easiest are not the ones who apologise most)",
      "why": "Being easy to ask things of is a quality people value, and it is reciprocal."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the evidence against the belief?",
      "options": [
        { "text": "People say they do not mind.", "correct": false, "note": "They do say it, and it is exactly what somebody would say either way." },
        { "text": "You have the receiving end, where the evidence is unambiguous.", "correct": true, "note": "A direct question arrives and you answer it in eleven seconds without experiencing it as an imposition. You already know this from the other side." },
        { "text": "Most requests are small.", "correct": false, "note": "True, and size was never what made the outgoing ones feel enormous." },
        { "text": "Everybody asks each other things constantly.", "correct": false, "note": "Volume is not the argument — it would be equally true in a world where everybody resented it." }
      ],
      "explain": "Incoming feels ordinary, outgoing feels enormous, and that asymmetry is not about the requests."
    },
    {
      "prompt": "What does over-apologising actually ask for?",
      "options": [
        { "text": "Permission.", "correct": false, "note": "Close, and permission was already granted by the relationship existing." },
        { "text": "Nothing — it is just wrapping.", "correct": false, "note": "It is not free. Something specific is being requested and it arrives before your question does." },
        { "text": "Forgiveness for the interruption.", "correct": false, "note": "That is the intention behind it. What arrives is a request for something more effortful." },
        { "text": "Reassurance — that they take care of your anxiety first.", "correct": true, "note": "A larger request than the question was, framed as consideration, and it has to be dealt with before anybody can answer." }
      ],
      "explain": "A relationship where both people crouch before every request is exhausting without anybody being able to say why."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked_plainly", "label": "Asked plainly", "description": "Made the request without the crouch." },
      { "key": "checked_belief", "label": "Tested the belief", "description": "Compared it to receiving the same request." },
      { "key": "no_reassurance", "label": "Asked for no reassurance", "description": "Did not require managing before answering." },
      { "key": "reciprocal", "label": "Stayed easy to ask", "description": "Direct in both directions." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You need something from somebody senior you do not know well, and you have rewritten the message four times.",
    "partner": {
      "name": "Nadine",
      "role": "somebody senior you have not worked with before",
      "personality": "Answers plain requests quickly and without ceremony. Responds to elaborate apology by reassuring at length, which takes longer for both of you.",
      "mood": "Efficient, not unkind.",
      "openness": 4
    },
    "opening_beat": "The fourth draft is sitting there.",
    "success_looks_like": "The user sends the plain version.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer a plain request immediately and get straight to the substance.",
      "Spend your reply reassuring if the message is heavily apologetic, and answer only at the end.",
      "Never comment on the tone of the message."
    ]
  }$j$::jsonb,
  $md$Today, ask somebody for something without a crouch in front of it. Log what you asked and how it was received.$md$
),
(
  (select id from public.skills where slug = 'stop-apologising'),
  4,
  'Politeness is not apology',
  $md$Stripping the apology out sometimes overcorrects, and the result reads as brusque — which is a real cost and worth solving properly rather than by putting the *sorry* back.

**The move:** keep the warmth and lose the crouch. They are different words.

Warmth is anything that acknowledges the other person and costs nothing to say: *thanks*, *this is a big help*, *hope the week is going all right*, *no problem at all* — and, more than any of them, evidence that you read what they wrote rather than only answered it.

The crouch is anything asserting that your request is a burden: *sorry to bother you*, *I know you are busy*, *feel free to ignore*, *this is probably stupid*, *no rush at all*.

Both look like politeness from the inside and they behave completely differently. One makes a message pleasant to receive. The other makes it work to receive.

Placement matters as much as content, which is the part people miss. Warmth at the end reads as warmth. The same words at the front read as throat-clearing, because anything before the ask is experienced as delay. *Thanks — this saves me an hour* after the question is a gift. The same sentence before it is a runway.

And one thing that is worth more than any pleasantry: answering what they actually said. A reply that engages with somebody's specific point is read as warm regardless of how short it is, and a long friendly message that ignores it is not.

If your directness genuinely lands cold with a particular person, the fix is a word of warmth at the end rather than an apology at the start. It costs the same number of characters and does the opposite thing.

If you keep one thing: warmth after, nothing before. The apology and the thank you are not the same act.$md$,
  $j$[
    {
      "situation": "Your direct version reads a bit cold.",
      "line": "(add thanks at the end, not sorry at the start)",
      "why": "The same number of characters doing the opposite thing. Warmth at the end reads as warmth; anything before the ask is experienced as delay."
    },
    {
      "situation": "You want to be warm and you are not sure which words count.",
      "line": "(thanks, this is a big help — not I know you are busy)",
      "why": "One acknowledges them and costs nothing. The other asserts that your request is a burden."
    },
    {
      "situation": "You want the message to feel personal.",
      "line": "(answer what they actually said)",
      "why": "A reply engaging with somebody's specific point reads as warm however short it is, and a long friendly one that ignores it does not."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What separates warmth from the crouch?",
      "options": [
        { "text": "Length.", "correct": false, "note": "Both can be four words. Length is not what distinguishes them." },
        { "text": "Whether it acknowledges them or asserts you are a burden.", "correct": true, "note": "Thanks, this is a big help acknowledges. I know you are busy asserts something about your own request that nobody had claimed." },
        { "text": "Tone of voice.", "correct": false, "note": "There is no tone of voice in a message, which is a whole other track." },
        { "text": "Whether you mean it.", "correct": false, "note": "Both are usually meant sincerely, which is why the distinction has to be structural." }
      ],
      "explain": "Warmth after, nothing before. They are different acts wearing the same coat."
    },
    {
      "prompt": "What reads as warmer than any pleasantry?",
      "options": [
        { "text": "An exclamation mark.", "correct": false, "note": "It does soften things, and it is decoration next to the thing that actually signals attention." },
        { "text": "Asking how they are.", "correct": false, "note": "Pleasant, and it can sit in front of a message that ignored everything they said." },
        { "text": "A longer message.", "correct": false, "note": "Length is read as effort at best, and frequently as work to get through." },
        { "text": "Answering what they actually said.", "correct": true, "note": "A reply engaging with somebody's specific point reads as warm however short it is. A long friendly one that ignores it does not." }
      ],
      "explain": "If your directness lands cold with somebody, add a word at the end rather than an apology at the start."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "warmth_after", "label": "Warmth at the end", "description": "Kept the thanks and moved it after the ask." },
      { "key": "no_crouch", "label": "No crouch in front", "description": "Nothing asserting the request was a burden." },
      { "key": "engaged", "label": "Answered what they said", "description": "Responded to their actual point." },
      { "key": "not_curt", "label": "Did not read as curt", "description": "Direct without being cold." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A colleague has sent you a detailed message about a deadline problem, and you need one thing from them in reply.",
    "partner": {
      "name": "Priya",
      "role": "a colleague who has just explained a problem at length",
      "personality": "Notices immediately whether a reply engages with what she actually said, and is unbothered by short messages that do.",
      "mood": "Slightly stressed about the deadline.",
      "openness": 4
    },
    "opening_beat": "\"...so the printers cannot do it before the 14th, which puts the whole thing back. Sorry, long message.\"",
    "success_looks_like": "The user answers her point, asks their thing, and puts any warmth at the end.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Respond well to any reply that engages with the printer problem specifically.",
      "Respond flatly to a friendly reply that ignores what you said.",
      "Never ask whether your message was too long."
    ]
  }$j$::jsonb,
  $md$Today, send one message with the warmth at the end and nothing in front of the ask. Log the sentence you moved.$md$
),
(
  (select id from public.skills where slug = 'stop-apologising'),
  5,
  'Following up',
  $md$Nobody replied. Four days have gone by, you still need the thing, and the follow-up you are drafting has four apologies in it.

**The move:** send the same request again, with no reference to the gap.

*Bumping this — do you still need the March figures included?* That is the whole message. No *sorry to chase*, no *I know you are busy*, no *apologies for the second message*, none of which makes the follow-up more welcome and all of which makes it longer.

The thing worth internalising is what a non-reply almost always is. Somebody read it on a phone, meant to deal with it properly, and it moved up the screen. That is the overwhelming majority of unanswered messages — not a decision, not a signal, and certainly not annoyance at having been asked. Following up is doing them a small favour, because the thing they meant to do is now back where they can see it.

Two mechanical things. Reply in the same thread rather than starting a new one, so they do not have to find the original. And restate the ask rather than only bumping — *any thoughts on the below?* requires scrolling, which is exactly the cost that got it left the first time.

The chasing anxiety is worth naming, because it is what produces the apologies: the fear that a second message is nagging. Once is not nagging. Once, on something they agreed to or that you genuinely need, is completely ordinary — and the people who are best to work with all do it.

If two follow-ups produce nothing, the medium has done what it can. Move it — a call, a corridor, or asking somebody else — and do that without any private conclusion about what the silence meant, because you have no information about that either.

If you keep one thing: bump it plainly. The gap does not need explaining, and mentioning it is the only thing that makes it awkward.$md$,
  $j$[
    {
      "situation": "Four days, no reply, and you still need it.",
      "line": "Bumping this — do you still need the March figures included?",
      "why": "The same request, restated, with no reference to the gap. Nothing about apologising for it makes it more welcome."
    },
    {
      "situation": "You are worried a second message is nagging.",
      "line": "(once is not nagging)",
      "why": "On something they agreed to or that you genuinely need, it is completely ordinary — and the people who are best to work with all do it."
    },
    {
      "situation": "You are about to write any thoughts on the below?",
      "line": "(that makes them scroll)",
      "why": "Scrolling is the cost that got it left the first time. Restate the ask rather than only bumping."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is a non-reply almost always?",
      "options": [
        { "text": "A soft no.", "correct": false, "note": "Occasionally, and reading it that way stops you sending the follow-up that would have got you an answer." },
        { "text": "Somebody who meant to deal with it and lost it.", "correct": true, "note": "Read on a phone, intended properly, moved up the screen. Following up is doing them a small favour rather than applying pressure." },
        { "text": "A sign you asked the wrong person.", "correct": false, "note": "Sometimes true after two attempts. After one it is an unfounded conclusion." },
        { "text": "Annoyance at being asked.", "correct": false, "note": "Extremely rare, and it is the fear that produces the four apologies in the follow-up." }
      ],
      "explain": "Bump it plainly. The gap does not need explaining."
    },
    {
      "prompt": "What makes a follow-up more likely to work?",
      "options": [
        { "text": "Apologising for chasing.", "correct": false, "note": "It makes it longer and asks for reassurance, which is the reassurance tax arriving a second time." },
        { "text": "Restating the ask in the same thread.", "correct": true, "note": "Any thoughts on the below requires scrolling, and scrolling is exactly the cost that got it left the first time." },
        { "text": "Sending it at a better time of day.", "correct": false, "note": "Marginal, and it is not what determines whether it gets dealt with." },
        { "text": "Explaining why you need it.", "correct": false, "note": "Sometimes useful, and it is more material in front of an ask that was already understood." }
      ],
      "explain": "Two follow-ups and nothing means move the medium, without concluding anything about the silence."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "followed_up", "label": "Actually followed up", "description": "Sent the second message." },
      { "key": "no_apology", "label": "Did not apologise for chasing", "description": "No reference to the gap." },
      { "key": "restated", "label": "Restated the ask", "description": "Did not make them scroll." },
      { "key": "moved_on", "label": "Changed medium after two", "description": "Did not keep sending, and drew no conclusions." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Four days ago you asked a colleague whether the report needs the March figures. No reply, and you need to finish it today.",
    "partner": {
      "name": "Priya",
      "role": "a colleague who meant to reply and forgot",
      "personality": "Genuinely forgot and is glad to be reminded. Slightly embarrassed by an apologetic chase, because it makes her feel she has been a problem.",
      "mood": "Overloaded, well meaning.",
      "openness": 4
    },
    "opening_beat": "The original message is still sitting there, unanswered.",
    "success_looks_like": "The user bumps it plainly with the ask restated.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer a plain bump immediately and gratefully.",
      "Spend a reply apologising back if the follow-up apologises for chasing.",
      "Never reply to the original message unprompted."
    ]
  }$j$::jsonb,
  $md$Today, follow up on one unanswered message with no apology for the gap. Log what you sent.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('stop-apologising', 1, 'line', $j${
  "says": "(the message box is open — you need to know whether the report includes the March figures)",
  "model": {
    "line": "Does the report need the March figures? Thanks.",
    "why": "The ask with nothing in front of it. It is not blunt and it is not missing anything they needed — and it does not have to be reassured before it can be answered."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Nothing in front of the ask",
      "words": ["sorry to bother", "sorry to", "i know you are busy", "probably a stupid", "feel free to ignore", "hope you do not mind", "quick one", "no rush", "if you get a chance", "when you have a sec"] },
    { "kind": "requires_question", "requirement": "Ask the actual question" },
    { "kind": "max_words", "requirement": "A one-line question in one line", "n": 25 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('stop-apologising', 2, 'line', $j${
  "says": "(your draft: \"Hi! I was just wondering if you might have just a quick fifteen minutes this week? Just to go over the reporting thing. No worries if not!\")",
  "model": {
    "line": "Do you have fifteen minutes this week to go over the reporting? Any day except Thursday works for me.",
    "why": "The same request with every shrinking word removed, plus something that makes it easier to answer. Nothing about the ask changed except its apparent size."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No shrinking words",
      "words": ["just", "quick", "no worries if not", "if you have time", "whenever suits", "sorry", "might be able", "if possible", "a tiny"] },
    { "kind": "requires_question", "requirement": "Make the ask" },
    { "kind": "max_words", "requirement": "Shorter than the draft", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('stop-apologising', 3, 'choice', $j${
  "beats": [
    {
      "situation": "You need something from somebody senior you have not worked with. You have rewritten the message four times and it keeps getting longer.",
      "prompt": "What is the belief underneath the rewriting?",
      "options": [
        { "text": "That you need to make a good first impression.", "correct": false, "note": "Present, and it would produce a careful message rather than an apologetic one." },
        { "text": "That their time is real and yours is not.", "correct": true, "note": "That the question is an interruption, and the correct posture for making one is a small crouch. It is the belief that regrows the words within a fortnight if only the words are removed." },
        { "text": "That they will say no.", "correct": false, "note": "A different fear, and it produces hedging about the answer rather than apology for the asking." },
        { "text": "That you should be able to work it out yourself.", "correct": false, "note": "Real for some people and it is a competence worry rather than an imposition one." }
      ]
    },
    {
      "situation": "You are testing whether the belief holds up.",
      "prompt": "Where is the evidence?",
      "options": [
        { "text": "Ask a colleague whether they mind being asked things.", "correct": false, "note": "They will say no, which is what somebody would say either way." },
        { "text": "Send it and see what happens.", "correct": false, "note": "Useful, and one data point that anxiety will explain away whichever way it goes." },
        { "text": "Notice how you feel when somebody asks you something plainly.", "correct": true, "note": "Almost certainly nothing at all. You already have the receiving end, where the evidence is unambiguous — incoming feels ordinary, outgoing feels enormous." },
        { "text": "Count how often people apologise to you.", "correct": false, "note": "Interesting, and it measures how widespread the habit is rather than whether it is warranted." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('stop-apologising', 4, 'line', $j${
  "says": "...so the printers cannot do it before the 14th, which puts the whole thing back. Sorry, long message.",
  "model": {
    "line": "The 14th is going to be tight but workable. Can you send me the final artwork by Friday? And thanks for chasing them — that was not going to be a fun call.",
    "why": "Answers what she actually said, asks the one thing, and puts the warmth at the end. Anything before the ask is experienced as delay; the same words after it read as warmth."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Ask your one thing" },
    { "kind": "forbids_any", "requirement": "No crouch in front of it",
      "words": ["sorry to add", "i know you have a lot on", "no rush", "feel free to", "if you get a minute", "hate to ask", "one more thing but"] },
    { "kind": "echoes_any", "requirement": "Answer what she actually said",
      "words": ["14th", "printers", "back"] },
    { "kind": "max_words", "requirement": "Short, and warm at the end", "n": 50 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('stop-apologising', 5, 'line', $j${
  "says": "(four days ago you asked whether the report needs the March figures. No reply, and you need to finish it today.)",
  "model": {
    "line": "Bumping this — does the report need the March figures?",
    "why": "The same request restated, in the same thread, with no reference to the gap. They almost certainly meant to answer and lost it, so this is a small favour rather than pressure."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not apologise for the gap",
      "words": ["sorry to chase", "sorry to bother", "apologies for", "i know you are busy", "hate to nag", "sorry to keep", "not sure if you saw", "did you see my"] },
    { "kind": "contains_any", "requirement": "Restate the ask, do not make them scroll",
      "words": ["march", "figures", "report"] },
    { "kind": "max_words", "requirement": "One line, in the same thread", "n": 25 }
  ]
}$j$::jsonb);
