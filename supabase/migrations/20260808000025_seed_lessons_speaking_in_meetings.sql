-- Work, track 1: Speaking in meetings.
--
-- The topic's shop window — the free sample is the first two lessons of a
-- topic's first skill — so the two that lead are the two that reframe the
-- problem rather than the two that are most impressive. Somebody who reads
-- lesson one and thinks "that is exactly what I do" has been given more than
-- somebody shown a clever technique.
--
-- Four of the five are line or choice drills. The exception is being talked
-- over, which only exists across an exchange: you cannot rehearse reclaiming
-- the floor against a beat that does not interrupt you back.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'speaking-in-meetings'),
  1,
  'Say it unfinished',
  $md$You are not quiet in meetings because you have nothing to say. You are quiet because what you have is not ready yet, and by the time it is, the subject has moved.

That is worth sitting with, because it changes what the problem is. You are applying a standard — *do not speak until it is finished* — that nobody else in the room is applying and nobody in it is even aware of. Listen to what the confident people actually say and it is rarely a finished thought. It is *I think the risk is probably on the timeline side, but I have not thought it through* — half an idea, handed over, and the room finishes it with them.

**The move:** say it before it is finished, and say that it is unfinished.

The second half is what makes the first half safe. *Half-formed thought:* or *I might be wrong about this, but* costs you nothing and buys you the right to be provisional out loud. Nobody holds a flagged half-thought against you, and everybody holds silence against nothing at all — which sounds like a reason to stay quiet until you notice that silence also gets you nothing.

There is an accounting error underneath the whole thing. The cost of saying something imperfect feels concrete and immediate; the cost of saying nothing feels like zero because it happens invisibly and later. It is not zero. It is the decision made without the thing you knew.

If you keep one thing: unfinished and in time beats finished and after.$md$,
  $j$[
    {
      "situation": "You have half an objection and the discussion is about to move on.",
      "line": "Half-formed thought — I think the risk is on the timeline rather than the budget.",
      "why": "Flagged as provisional, which makes it free to be wrong, and said while it can still affect anything. The room will finish it with you."
    },
    {
      "situation": "You are waiting until you can express it properly.",
      "line": "(the window is about thirty seconds wide)",
      "why": "Properly arrives after the subject has moved, and then saying it means dragging everybody backwards — which costs far more than being provisional would have."
    },
    {
      "situation": "You said nothing and the decision went the way you thought it would.",
      "line": "(that is the cost, and it is not zero)",
      "why": "Staying quiet feels free because the cost is invisible and arrives later. It is a decision made without the thing you knew."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why do the confident people in the room speak sooner?",
      "options": [
        { "text": "They are more sure of themselves.", "correct": false, "note": "Listen to what they actually say. It is frequently hedged, provisional and visibly half-built." },
        { "text": "They are not waiting for it to be finished.", "correct": true, "note": "They hand over half an idea and let the room complete it. You are applying a standard nobody else in the meeting is applying." },
        { "text": "They have thought about it beforehand.", "correct": false, "note": "Sometimes, and it is not the difference. Preparation helps everybody and does not explain speaking mid-discussion." },
        { "text": "They care less about being wrong.", "correct": false, "note": "Closer, and it describes a personality rather than a move. Flagging a thought as half-formed gets you the same permission." }
      ],
      "explain": "Unfinished is the normal register of a meeting. You have been holding yourself to a written standard in a spoken room."
    },
    {
      "prompt": "What does saying half-formed thought actually buy you?",
      "options": [
        { "text": "Time to think while you talk.", "correct": false, "note": "A small side benefit. The value is in what it does to how the room hears it." },
        { "text": "It makes you sound humble.", "correct": false, "note": "Humility is not the goal and can read as apology. This is a licence, not a curtsey." },
        { "text": "The right to be provisional out loud.", "correct": true, "note": "Nobody holds a flagged half-thought against you. It converts being wrong from a mistake into a contribution." },
        { "text": "It lowers expectations before you speak.", "correct": false, "note": "That framing turns it into a hedge about you. It is a label on the thought, not on yourself." }
      ],
      "explain": "Flag it as unfinished and being wrong stops costing anything."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "in_time", "label": "Said it in the window", "description": "Spoke while it could still affect the discussion." },
      { "key": "unfinished", "label": "Did not wait for it to be finished", "description": "Handed over a half-formed thought rather than a polished one." },
      { "key": "flagged", "label": "Flagged it as provisional", "description": "Made it free to be wrong rather than apologising for it." },
      { "key": "short", "label": "Kept it short", "description": "One point, not a paragraph." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A project meeting, seven people. The team is converging on a launch date and you think the timeline is the weak part, though you have not worked out why yet.",
    "partner": {
      "name": "Dana",
      "role": "the person running the meeting",
      "personality": "Brisk and genuinely receptive. Picks up a half-formed point and builds on it, and moves on quickly when nobody says anything.",
      "mood": "Trying to get to a decision before the hour is up.",
      "openness": 4
    },
    "opening_beat": "\"So unless anyone has concerns, I think we are saying the fourteenth. Going once.\"",
    "success_looks_like": "The user says the unfinished thought while the window is still open.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Take a half-formed point seriously and build on it out loud.",
      "Move the meeting on briskly if the user says nothing or hedges without a point.",
      "Never invite the user to speak — they have to take the window."
    ]
  }$j$::jsonb,
  $md$Today, say one unfinished thought out loud in a meeting, flagged as unfinished. Log what you said and what the room did with it.$md$
),
(
  (select id from public.skills where slug = 'speaking-in-meetings'),
  2,
  'Getting in',
  $md$Knowing what to say and not knowing how to start saying it are different problems, and the second one is mechanical.

Most people wait for a gap. Gaps do not arrive in good meetings — the pause you are waiting for is the pause after the decision. What actually happens is that people enter on top of the last half-second of somebody else's sentence, and the room treats that as completely normal, because it is.

**The move:** a two-word runway, then the point.

*Can I just* — *One thing* — *Quick one* — any of them. They are not filler. A short runway gives the room half a second to turn towards you, which is exactly what you were waiting for a gap to provide, and it works at a volume you already have.

Better still, use a name. *Dana, can I —* gets you the floor almost every time, because a named person stops, and when one person stops the rest follow. It is the single most reliable entry there is and it feels far ruder than it is.

Where to enter: at a comma, not a full stop. Sentences in meetings do not end, they trail into the next one, and somebody waiting for a clean finish is waiting for something that is not coming. A breath is an entry point.

One thing to drop. *Sorry, can I just —* is the same runway with a small apology welded to the front, and the apology is doing nothing except telling the room you think you should not be talking. Take the sorry off and the sentence is identical.

If you keep one thing: say a name and start. Permission was never going to be offered.$md$,
  $j$[
    {
      "situation": "Two people are going back and forth and there is no gap.",
      "line": "Dana, can I — one thing on the timeline.",
      "why": "A name stops one person, and when one stops the rest follow. It feels far ruder than it is and it works almost every time."
    },
    {
      "situation": "You are waiting for somebody to finish their sentence.",
      "line": "(go at the comma)",
      "why": "Sentences in meetings trail into the next one rather than ending. Waiting for a clean finish is waiting for something that is not coming."
    },
    {
      "situation": "You are about to open with sorry, can I just.",
      "line": "(take the sorry off — the rest is fine)",
      "why": "The apology does nothing except tell the room you think you should not be talking. The identical sentence without it is a normal entry."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "You are waiting for a gap. What is wrong with that plan?",
      "options": [
        { "text": "Gaps in a good meeting arrive after the decision.", "correct": true, "note": "The pause you are waiting for is the one where it is too late. People enter on top of the last half-second of somebody's sentence, and the room finds that completely normal." },
        { "text": "Somebody else will always take it.", "correct": false, "note": "Often true and it is the symptom. The plan fails because the gap is not coming, not because it is contested." },
        { "text": "It makes you look passive.", "correct": false, "note": "How it looks is not the problem. What it costs you is the point at which speaking was still useful." },
        { "text": "Nothing — waiting is polite.", "correct": false, "note": "It is polite, and politeness that reliably prevents you from contributing is a cost, not a virtue." }
      ],
      "explain": "Enter at a comma. A breath is an entry point; a full stop is a fantasy."
    },
    {
      "prompt": "What is the most reliable way in?",
      "options": [
        { "text": "Raising a hand or an eyebrow.", "correct": false, "note": "Works in some rooms and depends entirely on somebody looking at you at the right moment." },
        { "text": "Speaking louder than the last person.", "correct": false, "note": "Effective and expensive. Volume is a contest, and it is the thing quiet people are worst placed to win." },
        { "text": "Waiting for the chair to invite you.", "correct": false, "note": "Some chairs do this and most do not. A plan that depends on somebody else remembering you is not a plan." },
        { "text": "Saying somebody's name.", "correct": true, "note": "A named person stops, and when one person stops the others follow. It feels much ruder than it is and almost always works." }
      ],
      "explain": "A name, then a two-word runway, then the point. No apology in front of it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "entered", "label": "Actually got in", "description": "Started speaking rather than waiting for a gap." },
      { "key": "runway", "label": "Used a runway or a name", "description": "Gave the room half a second to turn." },
      { "key": "no_apology", "label": "Did not apologise for speaking", "description": "Left the sorry off the front." },
      { "key": "straight_in", "label": "Got to the point", "description": "Followed the runway with the actual thing." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A weekly review. Two colleagues have been going back and forth about resourcing for four minutes and neither is stopping.",
    "partner": {
      "name": "Dana",
      "role": "the person running the meeting",
      "personality": "Talks quickly and does not leave gaps, but stops immediately and gives the floor when her name is used.",
      "mood": "Deep in a resourcing argument.",
      "openness": 4
    },
    "opening_beat": "\"— no, but that is the same problem, because if we move Priya onto it then the other thing slips and we are back where —\"",
    "success_looks_like": "The user gets in without waiting for a gap and without apologising.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Keep talking without pausing unless the user actually interrupts.",
      "Stop and hand over the floor warmly the moment the user uses your name.",
      "Never invite the user to speak."
    ]
  }$j$::jsonb,
  $md$Today, get into one conversation by using somebody's name instead of waiting for a gap. Log what happened in the second after you said it.$md$
),
(
  (select id from public.skills where slug = 'speaking-in-meetings'),
  3,
  'Back somebody up',
  $md$The cheapest thing you will ever say in a meeting is that you agree with somebody, out loud, with one sentence attached.

It is impossible to get wrong. It cannot be objected to. It requires no original idea and no courage, and it makes you a person who talks in this meeting — which is most of what you need, because the second time you speak is never as hard as the first.

**The move:** name who you are agreeing with, then add one thing.

Both halves matter. *I agree* on its own is noise and everybody knows it. *I think Priya is right about the timeline, and the bit I would add is that the client sign-off is in the same week* is a contribution: it credits somebody, it takes a position, and it puts one new fact on the table.

It is also worth far more than it costs to the person you back. Ideas in meetings do not win on merit, they win on whether a second voice picks them up — an unsupported point is usually treated as one person's opinion, and the same point supported by somebody else becomes the direction of the conversation. Quiet people are often the ones who noticed the good idea and let it die silently.

That makes this the most underrated political act available to somebody who does not like politics. Back people and they back you, and none of it requires you to be the person with the clever thing.

One caution: do not use it as a way of never having your own position. Agreeing plus a fact is a contribution; agreeing plus nothing, repeatedly, is a way of speaking while saying nothing, and the room learns to hear it as weather.

If you keep one thing: say whose point it is, then add one fact. That is a whole contribution and it costs you no risk at all.$md$,
  $j$[
    {
      "situation": "Priya made a good point about the timeline and nobody picked it up.",
      "line": "I think Priya is right about the timeline — the client sign-off lands in the same week.",
      "why": "Credits her, takes a position, and adds one fact. An unsupported point stays one person's opinion; a supported one becomes the direction of the conversation."
    },
    {
      "situation": "You want to speak but have no original point.",
      "line": "(you do not need one)",
      "why": "Backing somebody cannot be got wrong or objected to, and it makes you a person who talks in this meeting. The second time is never as hard as the first."
    },
    {
      "situation": "You have said I agree three times this meeting and nothing else.",
      "line": "(add the fact, or it is weather)",
      "why": "Agreeing plus a fact is a contribution. Agreeing plus nothing, repeatedly, teaches the room to stop hearing you."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is backing somebody worth more than it costs you?",
      "options": [
        { "text": "It makes people like you.", "correct": false, "note": "It does, and that is the by-product rather than the mechanism." },
        { "text": "A second voice is what makes an idea the direction.", "correct": true, "note": "An unsupported point stays one person's opinion. The same point picked up by somebody else becomes what the meeting is now doing." },
        { "text": "It is a safe way to be seen talking.", "correct": false, "note": "True, and it undersells it. This is not a way of appearing to contribute — it changes the outcome." },
        { "text": "It builds allies for later.", "correct": false, "note": "It does, and framing it that way turns a real contribution into a manoeuvre. The value is immediate and honest." }
      ],
      "explain": "Ideas do not win on merit. They win on being picked up."
    },
    {
      "prompt": "What has to be attached to the agreement?",
      "options": [
        { "text": "A reason you agree.", "correct": false, "note": "Better than nothing and still about their point. One new thing moves it forward." },
        { "text": "Nothing — agreeing is the whole move.", "correct": false, "note": "Bare agreement is noise, and repeated it teaches the room to stop hearing you." },
        { "text": "One thing they did not say.", "correct": true, "note": "Name whose point it is, then add a fact. That credits somebody, takes a position and puts something new on the table, all in one sentence." },
        { "text": "A qualification, so it is not pure agreement.", "correct": false, "note": "That is a different move and a more expensive one. You do not have to disagree slightly to be worth listening to." }
      ],
      "explain": "Their name, their point, one new fact. A whole contribution at no risk."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named", "label": "Named the person", "description": "Credited whose point it was." },
      { "key": "added", "label": "Added one thing", "description": "Put something new on the table rather than agreeing bare." },
      { "key": "short", "label": "Kept it to a sentence", "description": "Did not turn a cheap move into a speech." },
      { "key": "took_a_position", "label": "Took a position", "description": "Agreed plainly rather than hedging the support." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A planning meeting. Priya has just made a good point about the timeline and it has gone straight past — the next person has already started on something else.",
    "partner": {
      "name": "Dana",
      "role": "the person running the meeting",
      "personality": "Moves fast and follows whatever the room picks up. Treats a point nobody supports as one person's opinion and treats a supported one as the direction.",
      "mood": "Getting through an agenda.",
      "openness": 4
    },
    "opening_beat": "\"Okay, noted. So on the second item, we were going to look at the reporting —\"",
    "success_looks_like": "The user names Priya's point and adds one thing to it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Move on quickly from any point nobody supports.",
      "Turn back and take it seriously when the user backs somebody with something added.",
      "Never invite the user to speak."
    ]
  }$j$::jsonb,
  $md$Today, back one person out loud and add one thing to their point. Log whose point it was and what you added.$md$
),
(
  (select id from public.skills where slug = 'speaking-in-meetings'),
  4,
  'When you are talked over',
  $md$You start, somebody else starts, and you stop. Then it happens again, and by the third time you have quietly reclassified yourself as somebody who does not get to finish sentences in this room.

Almost none of it is hostile. Most talking-over is two people misreading the same half-second, and the person who stops is simply the one more worried about the collision. That is the part worth knowing: stopping is not politeness being punished, it is a reflex, and it can be swapped for a different one.

**The move:** finish the sentence you started, at the same volume.

Not louder. Louder is a contest, and it is the contest you are least equipped to win. The same volume, continuing, is remarkably effective — the other person almost always stops, because *they* are also trying not to collide.

If you have already stopped, take it back explicitly. *I had not finished* — four words, no edge, no apology — or *let me finish that thought and then I want to hear yours*. Both sound far more confrontational in your head than they do in the room, where they land as ordinary.

If it keeps happening with the same person, do it outside the meeting rather than escalating inside it. One sentence, privately, with no accusation in it. Inside the meeting you are asking a room to arbitrate; outside it, you are telling somebody a thing they very likely have not noticed.

And there is a version where you are talked over and the point is then made by somebody else and credited to them. Say so, flatly and without heat: *that was the thing I was saying a minute ago, and I agree with it.* No sulking, no scorekeeping. Said plainly it is unanswerable.

If you keep one thing: keep going at the same volume. The person interrupting is also trying not to collide, and one of you has to not stop.$md$,
  $j$[
    {
      "situation": "You are three words in and somebody starts talking.",
      "line": "(keep going, same volume)",
      "why": "The other person is also trying not to collide, and they almost always stop. Louder is a contest; continuing is not."
    },
    {
      "situation": "You already stopped, and they are still going.",
      "line": "I had not finished.",
      "why": "Four words, no edge and no apology. It sounds far more confrontational in your head than it does in the room, where it lands as ordinary."
    },
    {
      "situation": "Somebody has just made your point and been thanked for it.",
      "line": "That was the thing I was saying a minute ago, and I agree with it.",
      "why": "Flat, unanswerable, and free of sulking. Scorekeeping is what makes this look small; saying it plainly does not."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Somebody starts talking three words into your sentence. What works?",
      "options": [
        { "text": "Carry on at the same volume.", "correct": true, "note": "They are also trying not to collide, so they almost always stop. One of you has to not stop, and it is a reflex rather than a personality." },
        { "text": "Get louder than them.", "correct": false, "note": "A contest, and the one a quiet person is least equipped to win. It also changes the temperature of the meeting." },
        { "text": "Stop, and come back to it later.", "correct": false, "note": "Later is after the subject moved. Do that three times and the room has learned something about you that is not true." },
        { "text": "Let them finish and then repeat yourself.", "correct": false, "note": "Sometimes the only option, and it costs you the point's window and makes the second attempt harder." }
      ],
      "explain": "Same volume, keep going. Stopping is a reflex, not manners."
    },
    {
      "prompt": "It keeps happening with one particular person. What now?",
      "options": [
        { "text": "Say something in the next meeting, so the room sees it.", "correct": false, "note": "That asks a room to arbitrate, which raises the stakes for everybody and makes it about the two of you." },
        { "text": "Nothing — it is not worth the trouble.", "correct": false, "note": "It is worth about one sentence of trouble, and left alone it compounds." },
        { "text": "One sentence privately, with no accusation in it.", "correct": true, "note": "Almost nobody knows they do this. Outside the meeting you are telling somebody a fact; inside it you are making a case." },
        { "text": "Raise it with your manager.", "correct": false, "note": "A large instrument for something that usually resolves in one private sentence." }
      ],
      "explain": "Inside the meeting, keep going. Outside it, one sentence and no accusation."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "kept_going", "label": "Kept going", "description": "Finished the sentence rather than yielding." },
      { "key": "same_volume", "label": "Stayed at the same volume", "description": "Did not turn it into a contest." },
      { "key": "reclaimed", "label": "Took it back when they had stopped", "description": "Said they had not finished, without apology or edge." },
      { "key": "no_heat", "label": "Kept the temperature down", "description": "No sulking, no scorekeeping, no accusation." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A status meeting. You have a point about the reporting deadline, and one colleague is having a fast, enthusiastic morning.",
    "partner": {
      "name": "Rob",
      "role": "a colleague who talks over people without noticing",
      "personality": "Enthusiastic and entirely well meaning. Starts talking over the user twice, and stops immediately and apologises if they simply keep going or say they had not finished.",
      "mood": "Energetic, slightly caffeinated, not hostile at all.",
      "openness": 4
    },
    "opening_beat": "\"Right, reporting — I think we just push it a week and nobody will even notice, honestly it is fine —\"",
    "success_looks_like": "The user finishes their point rather than yielding, without raising the temperature.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Start talking over the user at least twice, mid-sentence and without malice.",
      "Stop immediately and warmly if the user keeps going or says they had not finished.",
      "Take the floor back for good if the user yields, and carry on cheerfully."
    ]
  }$j$::jsonb,
  $md$Today, when somebody starts talking while you are, keep going at the same volume. Log what happened.$md$
),
(
  (select id from public.skills where slug = 'speaking-in-meetings'),
  5,
  'Asked directly, with nothing ready',
  $md$*What do you think?* — and everybody turns round, and there is nothing in your head at all.

This is the moment people most dread, and the dread is out of proportion to it for a specific reason: it feels like a test of whether you belong here, and it is a request for one sentence.

**The move:** say the true thing about where you are, then the honest half of what you have.

*I do not have a view on the whole thing yet, but the part I keep catching on is the timeline.* That is a complete answer. It is not a failure to answer, it is not a dodge, and it is more useful to the room than a confident invention would be.

What people do instead is manufacture. They produce something plausible, at length, to fill the silence — and it is worse in every direction: it takes longer, it does not represent what they actually think, and if it lands they now have to defend a position they invented under pressure.

Two other complete answers. *I would need to know X before I could say* is not a non-answer; it names the thing the room may not have noticed is missing. And *I want to think about it — can I come back to you this afternoon?* is entirely normal, provided you come back, which is what makes it a promise rather than an escape.

There is one thing to stop doing, and it is the reflex: *sorry, I was not really following.* Usually untrue, and it trades a two-second pause for a lasting impression. The pause you are trying to escape is about a second and a half long, and it reads as somebody thinking rather than as somebody caught.

If you keep one thing: say where you actually are. It takes one sentence, and it is the answer.$md$,
  $j$[
    {
      "situation": "\"What do you think?\" — and you have nothing formed.",
      "line": "I do not have a view on the whole thing yet, but the part I keep catching on is the timeline.",
      "why": "A complete answer. It says where you actually are and hands the room the one real thing you have, which beats a confident invention."
    },
    {
      "situation": "You are about to produce something plausible to fill the silence.",
      "line": "(and then you have to defend it)",
      "why": "Manufacturing takes longer, misrepresents what you think, and leaves you holding a position you invented under pressure."
    },
    {
      "situation": "You genuinely need to think about it.",
      "line": "I want to think about it — can I come back to you this afternoon?",
      "why": "Entirely normal, and it is a promise rather than an escape only if you come back. Naming the time is what makes it one."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Asked directly, nothing ready. What do you say?",
      "options": [
        { "text": "Something plausible, to fill the silence.", "correct": false, "note": "Longer, less true, and if it lands you now have to defend a position you invented under pressure." },
        { "text": "Where you actually are, plus the one real thing you have.", "correct": true, "note": "No view on the whole yet, and here is the part I keep catching on. That is a complete answer and more useful than an invention." },
        { "text": "Sorry, I was not really following.", "correct": false, "note": "Usually untrue, and it trades a second and a half of silence for a lasting impression." },
        { "text": "Defer to somebody else in the room.", "correct": false, "note": "It reads as having nothing, which is the thing you were trying to avoid, and it gives away a turn you were handed." }
      ],
      "explain": "The honest half of what you have is an answer. The pause before it is shorter than it feels."
    },
    {
      "prompt": "Why is I would need to know X a real answer?",
      "options": [
        { "text": "It buys you time.", "correct": false, "note": "It does, and that is not why it works. Time-buying is what a dodge is for." },
        { "text": "It sounds rigorous.", "correct": false, "note": "How it sounds is not the point, and treating it as a move to seem rigorous is how it becomes one." },
        { "text": "It shifts the question back to them.", "correct": false, "note": "That describes a deflection. This is not aimed at getting the attention off you." },
        { "text": "It names something missing that the room may not have noticed.", "correct": true, "note": "A real contribution. Half the time the thing you would need to know is the thing nobody has established, and saying so is the useful act." }
      ],
      "explain": "Naming what is missing is a contribution, not an excuse for having none."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "honest", "label": "Said where they actually were", "description": "Reported the real state of their thinking." },
      { "key": "gave_something", "label": "Handed over the real half", "description": "Offered the one thing they did have." },
      { "key": "no_invention", "label": "Did not manufacture", "description": "Resisted producing a plausible position to fill the silence." },
      { "key": "no_apology", "label": "Did not apologise", "description": "Skipped the sorry, I was not following reflex." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A meeting about a proposal you have only half read. The discussion has been going for ten minutes and you have not spoken.",
    "partner": {
      "name": "Dana",
      "role": "the person running the meeting",
      "personality": "Direct and genuinely interested in the answer. Accepts an honest partial answer without comment and follows up on whatever real thing is offered.",
      "mood": "Wants a view, not a performance.",
      "openness": 4
    },
    "opening_beat": "\"You have been quiet. What do you think?\"",
    "success_looks_like": "The user answers honestly and offers the one real thing they have.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Accept an honest partial answer as completely normal and build on it.",
      "Probe gently at anything that sounds manufactured, asking what makes them say that.",
      "Never reassure the user or tell them their answer was fine."
    ]
  }$j$::jsonb,
  $md$Today, when you are asked something you have no answer ready for, say where you actually are instead of manufacturing. Log what you said.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('speaking-in-meetings', 1, 'choice', $j${
  "beats": [
    {
      "situation": "\"So unless anyone has concerns, I think we are saying the fourteenth. Going once.\" You think the timeline is wrong but you have not worked out why.",
      "prompt": "What do you do?",
      "options": [
        { "text": "Wait until you can say it properly, then raise it after.", "correct": false, "note": "After means dragging everybody backwards, which costs far more social effort than being provisional would have. The window is about thirty seconds wide." },
        { "text": "Say the half-thought now, flagged as a half-thought.", "correct": true, "note": "Handed over while it can still change anything, and labelled so being wrong costs nothing. The room will finish it with you." },
        { "text": "Say nothing — you might be wrong.", "correct": false, "note": "The cost of that feels like zero because it arrives invisibly and later. It is a decision made without the thing you knew." },
        { "text": "Message someone afterwards to check before raising it.", "correct": false, "note": "Careful, and by then the date is agreed and reopening it is a much bigger act than a sentence would have been." }
      ]
    },
    {
      "situation": "You have decided to say it. You are about to open.",
      "prompt": "Which opener?",
      "options": [
        { "text": "Sorry, this might be stupid, but —", "correct": false, "note": "An apology rather than a flag. It labels you rather than the thought, and it asks the room to reassure you first." },
        { "text": "I am not sure this is right, I have not thought it through, it might be nothing, but —", "correct": false, "note": "The right instinct three times over. By the fourth hedge the room has stopped waiting for the point." },
        { "text": "Half-formed thought — the risk might be the timeline rather than the budget.", "correct": true, "note": "One flag, then straight to it. That is the whole technique: provisional about the thought, not about yourself." },
        { "text": "The timeline is wrong.", "correct": false, "note": "Nothing wrong with being definite, and it commits you to a position you have not worked out yet, which is what made you hesitate in the first place." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('speaking-in-meetings', 2, 'line', $j${
  "says": "— no, but that is the same problem, because if we move Priya onto it then the other thing slips and we are back where —",
  "model": {
    "line": "Dana, can I — one thing on the timeline.",
    "why": "A name stops one person and the rest follow, then a two-word runway gives the room half a second to turn. No apology in front of it and the point named immediately."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No apology in front of it",
      "words": ["sorry", "excuse me", "if i could just", "do you mind", "is it okay", "apologies"] },
    { "kind": "max_words", "requirement": "A runway, not a preamble", "n": 15 },
    { "kind": "max_questions", "requirement": "Do not ask permission to speak", "n": 0 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('speaking-in-meetings', 3, 'line', $j${
  "says": "Priya: \"I do think the timeline is the bit that worries me, more than the money.\" Dana: \"Okay, noted. So on the second item, we were going to look at the reporting —\"",
  "model": {
    "line": "Before we move on — Priya is right about the timeline, and the client sign-off lands in the same week.",
    "why": "Names whose point it is, agrees plainly, and adds one fact nobody had said. A supported point becomes the direction; an unsupported one stays somebody's opinion."
  },
  "checks": [
    { "kind": "echoes_any", "requirement": "Name whose point it is",
      "words": ["priya"] },
    { "kind": "contains_any", "requirement": "Take a position rather than hinting",
      "words": ["right", "agree", "agreed", "with priya", "good point", "think so too"] },
    { "kind": "min_words", "requirement": "Add one thing they did not say", "n": 12 },
    { "kind": "max_words", "requirement": "One sentence — it is a cheap move, keep it cheap", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('speaking-in-meetings', 4, 'scene', $j${}$j$::jsonb);

select pg_temp.set_mode('speaking-in-meetings', 5, 'line', $j${
  "says": "You have been quiet. What do you think?",
  "model": {
    "line": "I do not have a view on the whole thing yet, but the part I keep catching on is the timeline.",
    "why": "Says where you actually are, then hands over the one real thing you have. A complete answer, and more useful to the room than a confident invention."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Say where you actually are" },
    { "kind": "forbids_any", "requirement": "Do not apologise or claim you were not following",
      "words": ["sorry", "was not following", "wasnt following", "not paying attention", "missed that", "no idea"] },
    { "kind": "min_words", "requirement": "Hand over the real half, not just the caveat", "n": 10 },
    { "kind": "max_words", "requirement": "One sentence, not a manufactured paragraph", "n": 35 }
  ]
}$j$::jsonb);
