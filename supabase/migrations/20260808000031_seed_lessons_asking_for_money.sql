-- Work, track 6: Asking for money. The end of the spine.
--
-- It comes last of the three because it depends on both the others: a pay
-- conversation is where invisible work is discovered too late, and a raise
-- asked for by somebody whose direction has never been stated is a surprise
-- rather than a next step.
--
-- The negotiation itself is the scene. Everything else here is a sentence, but
-- what happens after the number is said depends entirely on what comes back,
-- and the whole skill is not filling the silence.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'asking-for-money'),
  1,
  'Ask for a number, not a conversation',
  $md$Most people do not fail to get a raise. They fail to ask for one, and then read the outcome as an answer.

The commonest shape is a request for a discussion rather than for money. *I wanted to talk about my progression.* *I was hoping we could look at my compensation at some point.* Both feel like the responsible, professional way in, and both hand your manager a topic instead of a decision — and topics get scheduled, deferred and eventually absorbed.

**The move:** name the figure.

*I would like to move to sixty-two.* That is a thing somebody can say yes to, no to, or counter. It converts an open-ended subject into a decision with a shape, and a decision with a shape gets made.

Naming it also does something to the conversation you cannot achieve any other way: it sets the anchor. If you say nothing, the anchor is whatever they were already planning to offer, and everything that follows is an argument about the gap between their number and their number. Yours has to exist before it can be met.

The obvious fear is being wrong — asking too high and looking foolish, or too low and getting it. Too high is almost never a problem: managers do not think less of people for wanting money, they counter. Too low is the real risk, and it is the one quiet people run straight into, because the number that feels safe is chosen by the part of you that is trying to avoid the conversation.

So do the boring work first: find out what the role pays elsewhere, ask people who will tell you, and pick a number you can say out loud without your voice changing. Then say that one, not the one you retreat to while saying it.

If you keep one thing: say a number. Everything else in this track is what happens after there is one on the table.$md$,
  $j$[
    {
      "situation": "You want more money and have booked the meeting.",
      "line": "I would like to move to sixty-two.",
      "why": "Something that can be answered yes, no, or countered. A topic gets scheduled and absorbed; a number gets decided."
    },
    {
      "situation": "You are about to say you wanted to talk about your compensation.",
      "line": "(that is a topic, not a decision)",
      "why": "It hands them a subject and takes the anchor off the table. Everything after it is an argument about the gap between their number and their number."
    },
    {
      "situation": "You are choosing between the number you want and a safer one.",
      "line": "(the safe one was picked by the part of you avoiding this)",
      "why": "Too high is almost never the problem — managers counter. Too low is the risk quiet people actually run into."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is a number better than a conversation?",
      "options": [
        { "text": "It is more confident.", "correct": false, "note": "It reads that way, and confidence is not the mechanism." },
        { "text": "It is a decision somebody can make.", "correct": true, "note": "Yes, no, or a counter. A topic gets scheduled and then absorbed, which is why so many progression conversations lead nowhere." },
        { "text": "It gets it over with faster.", "correct": false, "note": "Speed is not the point, and this conversation often takes several rounds anyway." },
        { "text": "It shows you have done your research.", "correct": false, "note": "The research is what makes the number defensible. Naming it is what makes it exist." }
      ],
      "explain": "A topic is absorbed. A number is answered."
    },
    {
      "prompt": "Which error actually costs people?",
      "options": [
        { "text": "Asking too high.", "correct": false, "note": "Managers do not think less of people for wanting money. They counter, and you are still ahead of where silence would have left you." },
        { "text": "Asking at the wrong moment.", "correct": false, "note": "Timing matters and it is the next lesson. It is not what makes the number wrong." },
        { "text": "Asking too low.", "correct": true, "note": "The safe number is chosen by the part of you trying to avoid the conversation, and if they say yes immediately you will never find out what was available." },
        { "text": "Asking without evidence.", "correct": false, "note": "Evidence matters and comes later. A number with no evidence still beats no number at all." }
      ],
      "explain": "Pick the number you can say out loud without your voice changing, then say that one."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "a_number", "label": "Named a figure", "description": "Asked for an amount rather than for a discussion." },
      { "key": "not_low", "label": "Did not undershoot", "description": "Said the real number rather than the safe one." },
      { "key": "plain", "label": "Said it plainly", "description": "No preamble, no apology, no hedging around the figure." },
      { "key": "prepared", "label": "Knew where it came from", "description": "Had a reason for that number if asked." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A meeting you asked for, about pay. You are on fifty-four and you want sixty-two.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Businesslike and not at all offended by being asked. Acts on a number and files a topic for later.",
      "mood": "Ready to have the conversation.",
      "openness": 4
    },
    "opening_beat": "\"You said you wanted twenty minutes. Go on.\"",
    "success_looks_like": "The user names a specific figure early.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Engage seriously and concretely once a number is named.",
      "Respond to a vague request by agreeing to look at it at some point, and move on.",
      "Never name a number yourself first."
    ]
  }$j$::jsonb,
  $md$Today, write down the number you would ask for and say it out loud once, to yourself or to somebody safe. Log the number.$md$
),
(
  (select id from public.skills where slug = 'asking-for-money'),
  2,
  'Say it, then be quiet',
  $md$This is the entire technique, it takes two seconds, and almost nobody manages it.

**The move:** say the number, and then stop talking.

The silence after a figure feels enormous. It is about two seconds long. What fills it, if you fill it, is always some version of a discount: *…but obviously I know things are tight.* *…or whatever you think is reasonable.* *…I mean, around that.* Every one of those is you negotiating against yourself before anybody else has said a word, and the other person has not even had a chance to agree.

That is worth stating plainly, because it is the most common way this goes wrong: people do not lose the negotiation, they concede it unprompted, in the pause, out of discomfort. The retreat is offered before the objection arrives.

The pause is not hostility and it is not a bad sign. Somebody who has just been asked for money is doing arithmetic — what the budget is, what the band allows, what it would take. That takes a moment, and the moment is theirs. Let it be.

Practically: say the sentence, close your mouth, and count. It is much easier if you have decided in advance that you are going to do it, because in the moment the urge to speak is genuine physical discomfort rather than a thought you can argue with.

And if they say nothing for longer than feels bearable, the correct next line is not a concession. *I am happy to talk through where the number came from* is neutral and adds nothing away. What you must not do is move your own figure before anybody has questioned it.

If you keep one thing: two seconds. The first person to speak after a number is negotiating against themselves, and it does not have to be you.$md$,
  $j$[
    {
      "situation": "You have said sixty-two and there is a pause.",
      "line": "(nothing — count)",
      "why": "The pause is arithmetic, not hostility. It is about two seconds long and it belongs to them."
    },
    {
      "situation": "You are about to add but I know things are tight.",
      "line": "(that is a discount nobody asked for)",
      "why": "Conceding in the pause is the commonest way this is lost. The retreat arrives before the objection."
    },
    {
      "situation": "The silence has gone on and you have to say something.",
      "line": "I am happy to talk through where the number came from.",
      "why": "Neutral, adds information, and moves nothing. What you must not do is move your own figure before it has been questioned."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the silence after a number?",
      "options": [
        { "text": "A negotiating tactic.", "correct": false, "note": "Occasionally, and assuming so makes you respond to a hostility that is usually not there." },
        { "text": "Somebody doing arithmetic.", "correct": true, "note": "Budget, band, what it would take. It takes a moment, the moment is theirs, and it is about two seconds long." },
        { "text": "Disapproval.", "correct": false, "note": "This is what it feels like from inside, and acting on that feeling is what produces the unprompted discount." },
        { "text": "An invitation to justify it.", "correct": false, "note": "If they want the reasoning they will ask. Volunteering it into the pause usually arrives as defensiveness." }
      ],
      "explain": "Say the number, close your mouth, count. The pause belongs to them."
    },
    {
      "prompt": "How do people usually lose this?",
      "options": [
        { "text": "They ask for too much.", "correct": false, "note": "That gets countered, not lost. Wanting money is not held against people." },
        { "text": "They cannot justify the figure.", "correct": false, "note": "Recoverable, and it comes up after the number rather than instead of it." },
        { "text": "They are outnegotiated.", "correct": false, "note": "There is rarely a negotiation. Most of this is decided before anybody argues." },
        { "text": "They concede in the pause, before anybody objects.", "correct": true, "note": "Or whatever you think is reasonable, said into two seconds of discomfort. The retreat is offered unprompted." }
      ],
      "explain": "The first person to speak after a number is negotiating against themselves."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "stopped", "label": "Stopped after the number", "description": "Said nothing into the pause." },
      { "key": "no_discount", "label": "Offered no discount", "description": "Did not soften the figure unprompted." },
      { "key": "held", "label": "Held the figure", "description": "Did not move before it was questioned." },
      { "key": "neutral_fill", "label": "Filled a long silence neutrally", "description": "If they spoke at all, added information rather than concession." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have just said sixty-two. Your manager has not answered yet.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Thinks before speaking and takes a genuine few seconds. Immediately and gratefully accepts any figure the user lowers themselves.",
      "mood": "Working out what is possible.",
      "openness": 4
    },
    "opening_beat": "(a pause — they are doing the arithmetic)",
    "success_looks_like": "The user says nothing until the manager responds.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Pause before your first substantive reply, and describe the pause plainly.",
      "Seize on any softening or lowered figure immediately and settle there gratefully.",
      "Respond seriously and concretely if the user holds the number."
    ]
  }$j$::jsonb,
  $md$Today, ask for one thing and then say nothing until you get an answer. Anything counts. Log how long the pause felt.$md$
),
(
  (select id from public.skills where slug = 'asking-for-money'),
  3,
  'Ask before the budget is set',
  $md$Timing decides more of this than phrasing does, and almost everybody picks the worst available moment: the review.

By the review, the numbers are allocated. Your manager is not deciding anything in that room — they are delivering a decision made weeks earlier, in a meeting you were not in, where somebody went through a list and split a fixed amount. Asking then puts them in the position of defending an outcome they may not even have chosen, and the only honest answer available is *it is done for this year*.

**The move:** ask two or three months before the cycle, while the number is still being formed.

That is the window where a manager can actually do something — argue for you in the room, ask for an exception before exceptions are used up, or tell you plainly what is possible so you can decide what to do about it. Two months early is not pushy. It is the only point at which asking changes anything.

You have to know when the cycle is, and most people do not. It is an entirely ordinary question and it can be asked at any time: *when do pay decisions actually get made?* Nobody has ever been thought less of for asking that, and knowing it converts this from a hopeful conversation into a scheduled one.

The other timing that works is a moment of proven value — right after something landed, when what you did is still concrete in everybody's mind. Not as leverage, and not with an implied threat, but because the evidence is fresh and your manager will be repeating it to somebody else.

And if you have missed the window entirely, do not spend the ask on a dead cycle. Ask instead what would need to be true for the next one and when to come back — which is the next lesson, and it is worth far more than a no you already knew you would get.

If you keep one thing: find out when the decision is made, and be three months early.$md$,
  $j$[
    {
      "situation": "Your review is next week and you plan to raise pay there.",
      "line": "(the numbers were allocated weeks ago)",
      "why": "Your manager is delivering a decision made in a room you were not in. The only honest answer available is that it is done for this year."
    },
    {
      "situation": "You do not know when pay decisions get made.",
      "line": "When do pay decisions actually get made here?",
      "why": "An entirely ordinary question that can be asked at any time, and it turns a hopeful conversation into a scheduled one."
    },
    {
      "situation": "Something you built has just landed well.",
      "line": "(good moment — the evidence is fresh)",
      "why": "Not leverage. Your manager will be repeating what happened to somebody else this week, and it helps if your number is in the same conversation."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is the review the wrong moment?",
      "options": [
        { "text": "It is about performance, not money.", "correct": false, "note": "They are usually the same meeting. The problem is not the subject." },
        { "text": "Your manager is delivering a decision, not making one.", "correct": true, "note": "The numbers were split weeks earlier in a room you were not in. Asking then makes them defend an outcome they may not have chosen." },
        { "text": "There are too many other things to cover.", "correct": false, "note": "A scheduling nuisance rather than the reason it fails." },
        { "text": "It looks transactional.", "correct": false, "note": "It does not, particularly, and how it looks is not what closes the door." }
      ],
      "explain": "Be early enough that your manager can still do something."
    },
    {
      "prompt": "You have no idea when the cycle is. What do you do?",
      "options": [
        { "text": "Work it out from when raises happened before.", "correct": false, "note": "A reasonable guess and it is guessing. You can simply be told." },
        { "text": "Wait until it is announced.", "correct": false, "note": "By announcement the numbers are set. This is how people end up asking in the wrong month every year." },
        { "text": "Ask when pay decisions get made.", "correct": true, "note": "An ordinary question, askable at any time, and nobody has ever been thought less of for it. It converts a hopeful conversation into a scheduled one." },
        { "text": "Ask a colleague rather than your manager.", "correct": false, "note": "Fine as a second source, and your manager knows the real answer and is allowed to say it." }
      ],
      "explain": "Find out when the decision is made, then be three months early."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "early", "label": "Asked before the cycle", "description": "Raised it while the number was still being formed." },
      { "key": "knew_when", "label": "Knew when decisions are made", "description": "Found out rather than guessing." },
      { "key": "evidence_fresh", "label": "Used a moment of proven value", "description": "Asked while the work was still concrete." },
      { "key": "no_threat", "label": "Made no threat", "description": "Used timing rather than leverage." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "An ordinary one-to-one in a month with nothing special about it. You have no idea when pay is decided here.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Answers process questions straightforwardly and is mildly relieved when somebody asks early rather than in April.",
      "mood": "Ordinary week.",
      "openness": 4
    },
    "opening_beat": "\"Anything else? We have got ten minutes.\"",
    "success_looks_like": "The user finds out when pay decisions are made and positions the ask before it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer questions about the cycle honestly — decisions are made in February for April.",
      "Say plainly that nothing can be changed if the user asks in April.",
      "Never raise pay yourself."
    ]
  }$j$::jsonb,
  $md$Today, find out when pay decisions are actually made where you work. Ask somebody. Log the answer.$md$
),
(
  (select id from public.skills where slug = 'asking-for-money'),
  4,
  'Three things you did',
  $md$Asked why you should be paid more, most people reach for the wrong material, and it is the material that feels most deserving: how hard they work, how long they have been there, how reliable they are, how much they care.

None of it is usable. Not because it is untrue — it is usually the truest thing about somebody — but because none of it can be carried into another room. Your manager has to repeat your case to somebody who has never met you, and *she works incredibly hard* is a sentence that dies in transit. Everybody works incredibly hard.

**The move:** three things that happened, with what changed because of them.

*I took the reporting over in March and it has not broken since. I ran the Harding account from June, which was new. And the migration went out in October with no downtime.* That is a case. It is checkable, it is repeatable by somebody else, and it describes a person operating above the level they are being paid at — which is the only argument that ever moves a number.

Three is the right number. One is an anecdote, and five stops being a case and starts being a plea.

Do not argue market rates as an accusation. Knowing what the role pays elsewhere is essential and it belongs in your head when choosing the figure, not deployed as evidence of unfairness — the moment it becomes *I am underpaid relative to market*, you are asking somebody to admit a wrong rather than to make a decision.

And leave out the things you cannot control. Cost of living, your rent, what a friend earns. All real, and none of it is about the value of the work, which is the only currency this conversation runs on.

If you keep one thing: give your manager three sentences they can repeat when you are not there. That is what a case is.$md$,
  $j$[
    {
      "situation": "Asked why the number should move.",
      "line": "I took reporting over in March and it has not broken since; I ran Harding from June; the migration went out in October with no downtime.",
      "why": "Three checkable things with outcomes attached. It describes somebody already operating above their level, which is the only argument that moves a number."
    },
    {
      "situation": "You are about to say how hard you have worked.",
      "line": "(it dies in transit)",
      "why": "Your manager has to repeat this to somebody who has never met you, and everybody works incredibly hard."
    },
    {
      "situation": "You know the role pays more elsewhere.",
      "line": "(that chooses your number, it does not argue your case)",
      "why": "Deployed as evidence of unfairness it asks somebody to admit a wrong instead of making a decision."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is how hard you work unusable?",
      "options": [
        { "text": "It sounds like complaining.", "correct": false, "note": "It can, and even said cheerfully it does nothing." },
        { "text": "It is not true of you specifically.", "correct": false, "note": "It usually is the truest thing about the person saying it, which is what makes this so unfair-feeling." },
        { "text": "It cannot be repeated in a room you are not in.", "correct": true, "note": "Your manager has to make the case to somebody who has never met you, and she works incredibly hard dies in transit. Everybody works incredibly hard." },
        { "text": "Managers do not care about effort.", "correct": false, "note": "Many do, personally. They just cannot spend it on your behalf." }
      ],
      "explain": "Give them three sentences they can repeat when you are not there."
    },
    {
      "prompt": "Where does knowing the market rate belong?",
      "options": [
        { "text": "In choosing your number.", "correct": true, "note": "Essential, and it belongs in your head. Said out loud as evidence of unfairness, it asks somebody to admit a wrong rather than make a decision." },
        { "text": "As the main argument.", "correct": false, "note": "It turns the conversation into a dispute about fairness, which is a much harder thing to win than a decision about value." },
        { "text": "Nowhere — it is not relevant.", "correct": false, "note": "It is extremely relevant to what you ask for. The question is whether it gets said out loud." },
        { "text": "As a closing point, if they say no.", "correct": false, "note": "Introducing it at the end reads as a threat with the word threat removed." }
      ],
      "explain": "Market rate sets your number. What you did makes your case."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "three", "label": "Gave three things", "description": "Not one, and not a list of five." },
      { "key": "outcomes", "label": "Attached what changed", "description": "Said what each one produced rather than naming the task." },
      { "key": "repeatable", "label": "Made it repeatable", "description": "Facts somebody could carry into another room." },
      { "key": "no_grievance", "label": "No unfairness argument", "description": "Kept market rate, tenure and personal costs out of it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have named sixty-two. Your manager has asked you to make the case.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Will have to argue this upward and is listening for things they can repeat. Visibly writes down specifics and does not write down effort.",
      "mood": "On your side, needing material.",
      "openness": 4
    },
    "opening_beat": "\"Okay. Help me make the argument — what have you got?\"",
    "success_looks_like": "The user gives three checkable things with outcomes attached.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Write down and repeat back anything specific and checkable.",
      "Respond to effort, loyalty or tenure with a sympathetic nod and nothing written down.",
      "Never supply an example for the user."
    ]
  }$j$::jsonb,
  $md$Today, write the three things you would say, each with what changed because of it. Log all three.$md$
),
(
  (select id from public.skills where slug = 'asking-for-money'),
  5,
  'What to do with a no',
  $md$A no is rarely a verdict on you. It is usually a budget cycle, a band ceiling, or a decision already signed off — and the thing that determines what it was worth is entirely what you do in the next sixty seconds.

The reflex is to accept it warmly and leave, which feels gracious and gets you nothing. You have spent the difficult part of the conversation and are walking away before collecting anything for it.

**The move:** ask what would have to be true, and when to come back. Then come back on that date.

*What would have to be true for this to be a yes?* is the question, and it is not a challenge — it is a request for the criteria, and most managers answer it honestly because it is easier than saying no twice. The answers are all useful. Something concrete, in which case you have a plan and it is written in somebody else's words. Nothing, in which case the ceiling is real and you now know something important about staying. Or *I do not know*, which tells you the decision is above them and the conversation you need is a different one.

Then pin the date. *Shall I come back to you in March?* turns an outcome into a scheduled item, and a scheduled item is much harder to absorb than a hopeful one. Get it in writing afterwards, in one friendly line summarising what you agreed — not as a trap, but because six months from now neither of you will remember it the same way.

And then actually come back, on the date, whether or not anything has changed. Almost nobody does this, which is precisely why it works: the second conversation opens with *you said March*, and everything you were told is now a commitment rather than a kindness.

If you keep one thing: never leave a no without a criterion and a date. That is what converts a rejection into the first half of a yes.$md$,
  $j$[
    {
      "situation": "\"It is not going to be possible this year.\"",
      "line": "What would have to be true for it to be a yes?",
      "why": "A request for criteria rather than a challenge, and most managers answer honestly because it is easier than saying no twice. Every possible answer is useful."
    },
    {
      "situation": "They have given you an answer and the meeting is ending.",
      "line": "Shall I come back to you in March?",
      "why": "Turns an outcome into a scheduled item. Scheduled items are much harder to absorb than hopeful ones."
    },
    {
      "situation": "March arrives and nothing has visibly changed.",
      "line": "(go back anyway — you said March)",
      "why": "Almost nobody does, which is why it works. The second conversation opens with their own words as a commitment rather than a kindness."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What makes what would have to be true a good question?",
      "options": [
        { "text": "It puts them on the spot.", "correct": false, "note": "It does not, and treating it as pressure is what makes it come out wrong." },
        { "text": "It shows you are not giving up.", "correct": false, "note": "A signal about you rather than something you obtain. The value is the answer." },
        { "text": "Every possible answer is useful to you.", "correct": true, "note": "Criteria give you a plan in their words. Nothing means the ceiling is real and you know something about staying. I do not know means the decision is above them." },
        { "text": "It is harder to refuse than a direct ask.", "correct": false, "note": "It is not a second ask at all, and treating it as one is how it turns into pressing." }
      ],
      "explain": "You have already spent the hard part of the conversation. Collect something for it."
    },
    {
      "prompt": "Why does the date matter as much as the criteria?",
      "options": [
        { "text": "It shows commitment.", "correct": false, "note": "How it reads rather than what it does. The mechanism is about what happens in six months." },
        { "text": "It stops you having to raise it again.", "correct": false, "note": "The opposite — it is precisely the arrangement to raise it again, with permission already given." },
        { "text": "It gives you a deadline to improve by.", "correct": false, "note": "A side benefit. The date works even when nothing about you has changed." },
        { "text": "It turns a kindness into a commitment.", "correct": true, "note": "A hopeful outcome is absorbed; a scheduled one is not. And the second conversation opens with their own words rather than your request." }
      ],
      "explain": "A criterion and a date. Then actually come back on the date."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked_criteria", "label": "Asked what would have to be true", "description": "Collected the criteria rather than leaving graciously." },
      { "key": "date", "label": "Pinned a date", "description": "Turned the outcome into something scheduled." },
      { "key": "in_writing", "label": "Confirmed it afterwards", "description": "Summarised what was agreed in one friendly line." },
      { "key": "no_pressing", "label": "Did not press", "description": "Took the no without asking again." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You asked for sixty-two, made the case, and have just been told it is not possible this year.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Genuinely constrained and slightly uncomfortable about it. Answers a criteria question honestly and at length; becomes closed if asked again for the money.",
      "mood": "Sorry about it, not moving on the number.",
      "openness": 3
    },
    "opening_beat": "\"I am going to be straight with you — it is not going to be possible this year.\"",
    "success_looks_like": "The user collects criteria and a date rather than accepting and leaving.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Never move on the number, however the user asks.",
      "Answer a criteria question honestly and concretely, and agree readily to a date.",
      "Become closed and brief if the user presses on the money again."
    ]
  }$j$::jsonb,
  $md$Today, take one no and ask what would have to be true, plus when to come back. Log the criteria and the date.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('asking-for-money', 1, 'line', $j${
  "says": "You said you wanted twenty minutes. Go on.",
  "model": {
    "line": "I would like to move to sixty-two.",
    "why": "A figure somebody can say yes to, no to, or counter. It also sets the anchor — without a number of yours, everything that follows is an argument about the gap between their number and their number."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "A number, not a topic",
      "words": ["talk about", "discuss", "have a chat", "at some point", "progression", "compensation review", "wondering if", "hoping we could"] },
    { "kind": "max_sentences", "requirement": "Say it and stop", "n": 2 },
    { "kind": "max_words", "requirement": "No preamble in front of the figure", "n": 25 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('asking-for-money', 2, 'scene', $j${}$j$::jsonb);

select pg_temp.set_mode('asking-for-money', 3, 'choice', $j${
  "beats": [
    {
      "situation": "It is January. Reviews are in April and you want more money.",
      "prompt": "When do you raise it?",
      "options": [
        { "text": "At the review, which is what it is for.", "correct": false, "note": "By April the numbers are allocated and your manager is delivering a decision made weeks earlier in a room you were not in." },
        { "text": "Now — ask when decisions get made, and be ahead of it.", "correct": true, "note": "The window where a manager can still argue for you, ask for an exception before exceptions run out, or tell you plainly what is possible." },
        { "text": "Straight after the review, for next year.", "correct": false, "note": "Eleven months early is not early, it is forgotten. Two or three months before the cycle is the window." },
        { "text": "The next time something goes well.", "correct": false, "note": "A good moment for the evidence and it still has to land before the numbers are set." }
      ]
    },
    {
      "situation": "You have missed it. It is April and the decisions are made.",
      "prompt": "What do you do with the meeting?",
      "options": [
        { "text": "Ask anyway — it costs nothing.", "correct": false, "note": "It costs the ask. You spend the difficult conversation on a cycle that cannot answer it, and get a no you already knew was coming." },
        { "text": "Say nothing and wait for next year.", "correct": false, "note": "Then you arrive next April in exactly this position, having done nothing in between." },
        { "text": "Ask what would need to be true for the next one, and when to come back.", "correct": true, "note": "Worth far more than a predictable no. You leave with criteria in their words and a date in the diary." },
        { "text": "Raise it with somebody more senior.", "correct": false, "note": "Going round your manager on money spends something large to change nothing about this cycle." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('asking-for-money', 4, 'line', $j${
  "says": "Okay. Help me make the argument — what have you got?",
  "model": {
    "line": "I took reporting over in March and it has not broken since, I ran the Harding account from June, and the migration went out in October with no downtime.",
    "why": "Three checkable things with outcomes attached, in a form your manager can repeat to somebody who has never met you. That is what a case is."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Things that happened, not qualities you have",
      "words": ["hard work", "work hard", "loyal", "loyalty", "always here", "dedicated", "reliable", "years", "deserve", "cost of living", "market rate", "underpaid"] },
    { "kind": "min_words", "requirement": "Three things, each with what changed", "n": 20 },
    { "kind": "max_words", "requirement": "Three, not five — a case, not a plea", "n": 60 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('asking-for-money', 5, 'line', $j${
  "says": "I am going to be straight with you — it is not going to be possible this year.",
  "model": {
    "line": "Understood. What would have to be true for it to be a yes, and shall I come back to you in March?",
    "why": "Criteria and a date, collected in the sixty seconds most people spend leaving graciously. Every possible answer to the first question is useful, and the second turns a kindness into a commitment."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Collect something before you leave" },
    { "kind": "contains_any", "requirement": "Ask what would have to change",
      "words": ["would have to", "would need", "what would", "criteria", "in order", "get there", "change"] },
    { "kind": "contains_any", "requirement": "Pin a date",
      "words": ["march", "come back", "revisit", "again in", "three months", "six months", "next quarter", "when"] },
    { "kind": "forbids_any", "requirement": "Take the no — do not press",
      "words": ["are you sure", "even a little", "what about", "is there any way", "disappointed", "not fair"] }
  ]
}$j$::jsonb);
