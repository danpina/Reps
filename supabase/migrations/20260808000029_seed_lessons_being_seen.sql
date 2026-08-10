-- Work, track 4: Being seen. The first of the three that make up the spine.
--
-- Every lesson here is a line or choice drill and none of them opens a scene,
-- which is not thrift — nothing in this track depends on what comes back. The
-- moves are all a single sentence said correctly, and a sentence is exactly
-- what the deterministic checker is for.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'being-seen'),
  1,
  'Work does not speak',
  $md$*Good work speaks for itself* is believed almost exclusively by people whose work is not being heard.

Work does not speak. People speak, and what reaches the person deciding is whatever somebody happened to say in a room you were not in. If nobody says anything, the outcome is not neutral — the outcome is that a project went well and no name is attached to it.

That is the part worth sitting with, because most quiet people are quietly relying on the opposite. The unspoken theory is that there is a ledger somewhere, that it is being kept accurately, and that at some point it will be read out. There is no ledger. There is a manager with an imperfect memory, a skip-level who has met you twice, and a promotion conversation that will be had mostly by people who are not you.

**The move:** treat visibility as part of the work, not as a reward for it.

This is not an injustice being done to you and there is nobody to be angry at, which is initially disappointing and eventually freeing. Nobody is withholding credit. There is simply an absence, and an absence is not anybody's job to fill except yours.

One more thing that goes wrong here, and it is subtle: quiet people often are visible to the wrong person. Your immediate teammates know exactly what you do — they watch you do it. The person deciding does not, and the two are frequently confused, because being appreciated locally feels like being known.

If you keep one thing: nobody is keeping score for you. The default is not neutral, and no amount of good work changes that on its own.$md$,
  $j$[
    {
      "situation": "A project went well and nobody has mentioned who did what.",
      "line": "(the default is not neutral)",
      "why": "The outcome is a success with no name attached. That is not an injustice, it is an absence, and absences are nobody's job to fill except yours."
    },
    {
      "situation": "Your team knows exactly how much you do.",
      "line": "(and the person deciding does not)",
      "why": "Being appreciated locally feels like being known and is not the same thing. The decision is made by somebody who has met you twice."
    },
    {
      "situation": "You are waiting for it to be noticed at review time.",
      "line": "(there is no ledger)",
      "why": "There is a manager with an imperfect memory and a conversation held mostly by people who are not you."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is good work speaks for itself wrong?",
      "options": [
        { "text": "Because other people are better at self-promotion.", "correct": false, "note": "They may be, and that framing makes it about a contest you did not want to enter. The problem exists even with nobody else in the room." },
        { "text": "Because work does not speak — people do.", "correct": true, "note": "What reaches the person deciding is whatever somebody said in a room you were not in. If nobody says it, a project went well and no name is attached." },
        { "text": "Because managers are not paying attention.", "correct": false, "note": "Most are, to about six things, of which your work is one. Attention is not the same as a record." },
        { "text": "Because good is subjective.", "correct": false, "note": "A different argument, and this holds even when everybody agrees the work was good." }
      ],
      "explain": "There is no ledger. There is a person with an imperfect memory and a conversation you are not in."
    },
    {
      "prompt": "What is the subtle version of this failure?",
      "options": [
        { "text": "Being modest in the wrong moment.", "correct": false, "note": "That is the next lesson, and it is a symptom rather than the structural mistake." },
        { "text": "Doing work that is hard to describe.", "correct": false, "note": "It makes describing harder. Plenty of easily described work goes entirely unattributed." },
        { "text": "Waiting for a review to raise it.", "correct": false, "note": "Bad timing, and the deeper error is believing there was something to raise it against." },
        { "text": "Being visible to the wrong people.", "correct": true, "note": "Your teammates watch you work and know exactly what you do. The person deciding has met you twice, and being appreciated locally feels like being known." }
      ],
      "explain": "The people who can see you are usually not the people deciding."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_ledger", "label": "Stopped relying on the ledger", "description": "Treated visibility as something to do rather than something owed." },
      { "key": "right_audience", "label": "Aimed at the person deciding", "description": "Noticed the difference between local appreciation and being known." },
      { "key": "no_grievance", "label": "Held no grievance", "description": "Treated it as an absence rather than an injustice." },
      { "key": "part_of_work", "label": "Made it part of the work", "description": "Planned for it rather than hoping." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A skip-level catch-up you were invited to and have never had before. They know your team's work and not, specifically, yours.",
    "partner": {
      "name": "Nadine",
      "role": "your manager's manager",
      "personality": "Friendly, genuinely curious, and working from a very thin picture of who did what. Remembers concrete specifics and forgets general enthusiasm.",
      "mood": "Interested, with twenty minutes.",
      "openness": 4
    },
    "opening_beat": "\"I do not think we have really talked properly. What have you been working on?\"",
    "success_looks_like": "The user attaches their own name to specific work rather than describing the team's.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Follow up with real interest on anything specific and attributed.",
      "Move on politely from general or team-level descriptions.",
      "Never ask what the user personally did."
    ]
  }$j$::jsonb,
  $md$Today, notice one piece of your work that the person deciding does not know about. Log what it is and who would need to hear it.$md$
),
(
  (select id from public.skills where slug = 'being-seen'),
  2,
  'Name the work, not yourself',
  $md$Every quiet person has the same objection to all of this, and it is correct: self-promoters are insufferable, and you do not want to be one. Good. Hold on to that — it is not squeamishness, it is taste, and it points at exactly the right distinction.

What makes them insufferable is that they talk about *themselves*. Their instinct, their brilliance, how hard it was, how they saved it. All of that is a claim about a person, it cannot be verified, and everybody in the room is quietly discounting it.

**The move:** state the work as a fact, with your name attached and no adjective about you.

*The migration went out on Thursday, no downtime* is complete visibility. It contains no boast and nothing that could be argued with, and everybody who hears it knows exactly who did it and that it went well. It is also just true, which is why it is comfortable to say — the discomfort people feel about self-promotion is mostly the discomfort of saying something unverifiable.

The test is whether it could be disputed. *I did a really thorough job on the migration* invites *did you?* — it is an opinion about yourself. *The migration went out Thursday with no downtime* invites nothing, because it is a fact.

Numbers and dates do the work if you have them, and plain outcomes if you do not. *It has been running three weeks with nothing broken.* *We stopped getting those tickets.* None of it is spin and all of it is visible.

Take the adjectives out and there is nothing left to be embarrassed about. What remains is a description of what happened, said by the person it happened to, which is the most ordinary thing in the world.

If you keep one thing: say what happened, not how good you were at it. Facts are visibility, and they are not bragging.$md$,
  $j$[
    {
      "situation": "You are asked what you have been working on.",
      "line": "The migration went out on Thursday, no downtime.",
      "why": "Complete visibility with no adjective about you in it. Everybody hearing it knows who did it and that it went well, and there is nothing to dispute."
    },
    {
      "situation": "You are about to say you did a really thorough job.",
      "line": "(that invites did you?)",
      "why": "An opinion about yourself can be argued with, and it is what makes self-promotion uncomfortable to say and easy to discount."
    },
    {
      "situation": "You have no numbers for it.",
      "line": "It has been running three weeks and nothing has broken.",
      "why": "A plain outcome does the same job. Facts do not have to be quantitative, only checkable."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What actually makes self-promotion insufferable?",
      "options": [
        { "text": "Talking about your work at all.", "correct": false, "note": "This is the belief that keeps good work invisible, and it is a misreading of what the irritating thing was." },
        { "text": "Doing it too often.", "correct": false, "note": "Frequency makes it worse and is not what makes it grating in the first place." },
        { "text": "Making unverifiable claims about yourself.", "correct": true, "note": "Their instinct, their brilliance, how hard it was. None of it can be checked, so everybody discounts it — and that is what you are recoiling from." },
        { "text": "Taking credit for other people's work.", "correct": false, "note": "A separate and worse offence. Plenty of self-promoters do their own work and are still tiring." }
      ],
      "explain": "The objection is right and it points at the fix: take the adjectives about you out."
    },
    {
      "prompt": "What is the test for a sentence that carries your work?",
      "options": [
        { "text": "Whether it sounds humble.", "correct": false, "note": "Humility is not the target, and aiming at it produces the deflection the next lesson is about." },
        { "text": "Whether it could be disputed.", "correct": true, "note": "The migration went out Thursday with no downtime invites nothing, because it is a fact. I did a thorough job invites did you?" },
        { "text": "Whether it includes a number.", "correct": false, "note": "Numbers help and are not required. It has been running three weeks with nothing broken does the same job." },
        { "text": "Whether your manager already knows it.", "correct": false, "note": "They usually half know it, which is the reason to say it rather than a reason not to." }
      ],
      "explain": "If it could be argued with, it is an opinion about you. If it could not, it is visibility."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "factual", "label": "Stated a fact", "description": "Said what happened rather than how well it was done." },
      { "key": "attached", "label": "Attached their name", "description": "Made clear whose work it was." },
      { "key": "no_adjectives", "label": "No adjectives about themselves", "description": "Left out claims that could only be taken on trust." },
      { "key": "short", "label": "Kept it to a sentence", "description": "Did not build a case." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A skip-level catch-up. You spent six weeks on a database migration that went out last Thursday without incident, and almost nobody noticed precisely because it went well.",
    "partner": {
      "name": "Nadine",
      "role": "your manager's manager",
      "personality": "Remembers specifics and forgets enthusiasm. Follows up properly on anything concrete and moves on from anything general.",
      "mood": "Curious, twenty minutes.",
      "openness": 4
    },
    "opening_beat": "\"So what have you been working on?\"",
    "success_looks_like": "The user states the work as a checkable fact with their name attached.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Follow up with interest on anything specific and checkable.",
      "Respond briefly and move on from adjectives and general claims.",
      "Never ask a clarifying question about who did what."
    ]
  }$j$::jsonb,
  $md$Today, describe one thing you did as a fact with no adjective about yourself in it. Log the sentence.$md$
),
(
  (select id from public.skills where slug = 'being-seen'),
  3,
  'The note that does it for you',
  $md$If speaking about your work is the hard version, here is the easy one, and it is the single highest-leverage habit in this topic for somebody quiet.

**The move:** a short written note, on a rhythm, listing what actually happened.

Three or four lines, once a week or once a fortnight, to your manager. Not a report and not a status meeting in text — a list of things that are now true. *Migration went out Thursday, no downtime. Picked up the Henderson handover. Reporting is on track for the 20th.*

Why it beats talking, if talking is not your strength: you can draft it, you can edit it, nobody is watching you do it, and it takes four minutes. It also arrives at a time that suits them, which means it gets read rather than sat through.

But the reason it is genuinely the best tool here is what it does when you are not in the room. Your manager needs material for conversations you will never attend — a promotion round, a headcount discussion, a skip-level asking who is good. A person with a folder of your notes has specifics. A person without one has an impression, and impressions lose to specifics every time.

It compounds in a way nothing else does. Six months of notes is a case you did not have to build, written when each thing was fresh and easy to describe, at the exact moment you will most wish you had one.

Two rules. Keep it boring — facts, not framing, and no adjectives about yourself. And keep it short enough that you will actually do it, because a note you skip for three weeks is worth nothing and a note you resent is a note you skip.

If you keep one thing: write the four lines. It is the least social act in this entire app and it does more than most of the brave ones.$md$,
  $j$[
    {
      "situation": "It is Friday and the week is done.",
      "line": "Migration went out Thursday, no downtime. Picked up the Henderson handover. Reporting on track for the 20th.",
      "why": "Three facts, four minutes, no adjectives. It arrives when it suits them and it becomes material for rooms you will never be in."
    },
    {
      "situation": "You are drafting something longer and better.",
      "line": "(keep it to four lines or you will stop doing it)",
      "why": "A note you resent is a note you skip, and a habit skipped for three weeks is worth nothing at all."
    },
    {
      "situation": "A promotion round is coming and you have no case.",
      "line": "(six months of notes was the case)",
      "why": "Written when each thing was fresh and easy to describe, by somebody who did not know they would need it. Nothing else compounds like this."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is a written note better than saying it?",
      "options": [
        { "text": "Because it is a record.", "correct": false, "note": "Close, and being a record is only useful because of who reads it and when." },
        { "text": "Because your manager prefers writing.", "correct": false, "note": "Some do, some do not, and it works either way." },
        { "text": "Because it works in rooms you are not in.", "correct": true, "note": "Your manager needs material for a promotion round or a skip-level asking who is good. Somebody with your notes has specifics; without them they have an impression." },
        { "text": "Because it avoids the conversation.", "correct": false, "note": "It is easier, and easier is a bonus rather than the reason. This one beats talking on the merits." }
      ],
      "explain": "It is a supply of specifics for conversations you will never attend."
    },
    {
      "prompt": "What is the most common way this habit fails?",
      "options": [
        { "text": "Nobody reads it.", "correct": false, "note": "They mostly do, and even unread it is a dated record you can search later." },
        { "text": "It looks like you are showing off.", "correct": false, "note": "Not if it is boring, which is the instruction. Facts read as facts." },
        { "text": "You forget what happened.", "correct": false, "note": "The rhythm exists to solve exactly that, which is why weekly beats monthly." },
        { "text": "It gets too long, and then it gets skipped.", "correct": true, "note": "A note you resent is a note you skip, and three skipped weeks ends the habit. Short enough to actually do beats good." }
      ],
      "explain": "Four lines, boring, on a rhythm. Length is what kills it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "sent", "label": "Actually sent it", "description": "Wrote and sent rather than drafting something better later." },
      { "key": "facts", "label": "Facts only", "description": "Listed what is now true, with no framing." },
      { "key": "short", "label": "Kept it short", "description": "Short enough to repeat next week." },
      { "key": "rhythm", "label": "Put it on a rhythm", "description": "Made it a habit rather than a one-off." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Friday afternoon. You have done three things this week worth recording and have never sent your manager a note like this.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Reads short notes immediately and skims long ones. Remembers anything concrete and dated.",
      "mood": "End of the week, clearing the inbox.",
      "openness": 4
    },
    "opening_beat": "The message box is open and the week is done.",
    "success_looks_like": "The user writes three or four factual lines and sends them.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Reply briefly and warmly to a short factual note.",
      "Reply with a skim and a question to anything long or framed.",
      "Never ask for a status update yourself."
    ]
  }$j$::jsonb,
  $md$Today, send one short note listing what is now true. Three or four lines, no adjectives. Log what you sent.$md$
),
(
  (select id from public.skills where slug = 'being-seen'),
  4,
  'When they ask how it went',
  $md$*How did it go?* is the most frequently wasted question at work, and it is wasted by the person being asked.

The reflexes are all deflections and they all feel like manners. *Oh, fine.* *It was a team effort.* *Honestly it mostly ran itself.* Every one of those hands back an opportunity that was being offered — somebody asked to be told, and was told nothing.

**The move:** answer with the outcome, in one sentence, and then stop.

*It went out Thursday, no downtime.* That is not immodest. It is the answer to the question, and it is what everybody who is not you says without a second thought.

The team-effort deflection deserves special attention, because it is the most common and it feels the most virtuous. It is also, usually, a way of avoiding the discomfort of being credited — and the cost is not paid by you alone. Somebody asked who did this; the answer they get is nobody in particular. That is not generous to your team, it is vague about all of you.

If you want to credit people, name them. *Priya did the hard part on the rollback plan, I did the migration itself* is specific, generous and complete, and it does everything the deflection was trying to do without erasing anyone.

Then stop. The instinct after saying the good thing is to immediately undercut it — *it was not that complicated, honestly* — which deletes the sentence you just said and is heard as accurate rather than as modest. Say the outcome, let it sit, and let them ask the next question.

If you keep one thing: answer the question. Somebody asked to be told, and *fine* is not an answer, it is a decline.$md$,
  $j$[
    {
      "situation": "\"How did the migration go?\"",
      "line": "It went out Thursday, no downtime.",
      "why": "The actual answer to the actual question, in one sentence. It is what everybody who is not you says without hesitating."
    },
    {
      "situation": "You are about to say it was a team effort.",
      "line": "Priya did the hard part on the rollback plan, I did the migration itself.",
      "why": "Specific and generous, and it does everything the deflection was trying to do without leaving the answer as nobody in particular."
    },
    {
      "situation": "You said the good thing and there is a small silence.",
      "line": "(do not undercut it)",
      "why": "It was not that complicated, honestly deletes the sentence you just said — and it is heard as accurate rather than as modest."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is it was a team effort a problem?",
      "options": [
        { "text": "It is not true.", "correct": false, "note": "It usually is true, which is what makes it such a comfortable place to hide." },
        { "text": "It sounds insincere.", "correct": false, "note": "It sounds gracious, which is precisely why it goes unchallenged." },
        { "text": "It undersells you.", "correct": false, "note": "True, and it is only half of what is wrong — the other half is what it does to everybody else." },
        { "text": "Somebody asked who did this and the answer is nobody in particular.", "correct": true, "note": "It is not generous to your team, it is vague about all of you. Naming people is the version that actually credits them." }
      ],
      "explain": "If you want to share credit, name names. Vagueness credits nobody."
    },
    {
      "prompt": "You have said the outcome. What next?",
      "options": [
        { "text": "Stop.", "correct": true, "note": "The instinct is to undercut it immediately, and it was not that complicated deletes the sentence you just said. Let it sit and let them ask." },
        { "text": "Add the context so it is not overstated.", "correct": false, "note": "That is undercutting with better manners. If it needed context they will ask." },
        { "text": "Mention what went wrong, for balance.", "correct": false, "note": "Balance was not requested. Volunteering the failure alongside the success is a way of apologising for the success." },
        { "text": "Ask about their work.", "correct": false, "note": "A polite escape, and it closes the subject before anything landed." }
      ],
      "explain": "Say the outcome and let the silence be theirs to fill."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "answered", "label": "Answered the question", "description": "Gave the outcome rather than a deflection." },
      { "key": "named", "label": "Named people if crediting them", "description": "Avoided the vague team effort." },
      { "key": "stopped", "label": "Stopped", "description": "Did not undercut it afterwards." },
      { "key": "one_sentence", "label": "One sentence", "description": "Did not turn it into an account." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The kitchen. Your manager's manager passes you the morning after the migration went out cleanly.",
    "partner": {
      "name": "Nadine",
      "role": "your manager's manager",
      "personality": "Asks briefly and genuinely, and takes whatever answer she gets at face value. Remembers a specific outcome and forgets a deflection instantly.",
      "mood": "Passing through, twenty seconds.",
      "openness": 4
    },
    "opening_beat": "\"Oh — the migration. How did that go?\"",
    "success_looks_like": "The user gives the outcome in one sentence without deflecting or undercutting.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Accept any answer at face value and do not probe.",
      "Respond warmly and specifically to an actual outcome.",
      "Move on immediately after a deflection, as though nothing was said."
    ]
  }$j$::jsonb,
  $md$Today, answer one how did it go with the outcome and then stop talking. Log what you said.$md$
),
(
  (select id from public.skills where slug = 'being-seen'),
  5,
  'Credit is not a fixed pot',
  $md$Underneath the reluctance is usually an economic belief: that credit is a fixed quantity, and that claiming some means taking it from somebody else.

It does not work like that. Naming your part does not remove anybody else's, and naming somebody else's does not remove yours — the two are simply different facts, and both can be true in one sentence. *Priya did the rollback plan, I did the migration* costs neither of you anything.

**The move:** name other people's work out loud, specifically, and keep naming your own.

Doing it for other people is the cheapest thing in this entire topic. It takes four words in a meeting, it is impossible to get wrong, and it makes you somebody others speak well of — which matters, because the conversations that decide things happen without you, and what gets said there is said by people who either think of you or do not.

There is a version of this that is a manoeuvre and it is worth avoiding: crediting people in order to be seen crediting people. The difference is visible and it is about accuracy — say what somebody actually did, in specifics. *Priya was great* is a compliment. *Priya caught the thing that would have taken the site down* is a fact, and only one of them is useful to Priya in a room she is not in.

The reciprocity is real but it is not the reason. Do it because a specific description of somebody's work is the most useful thing you can say about them and it costs you nothing whatsoever. That it also makes people inclined to do the same for you is a consequence, not a strategy — and treating it as a strategy is exactly what makes it stop working.

If you keep one thing: your name and somebody else's fit in the same sentence. Nothing is being divided.$md$,
  $j$[
    {
      "situation": "You want to credit Priya without disappearing yourself.",
      "line": "Priya did the rollback plan, I did the migration.",
      "why": "Two facts in one sentence, both true, neither taking anything from the other. Credit is not a quantity being divided."
    },
    {
      "situation": "You are about to say Priya was great.",
      "line": "Priya caught the thing that would have taken the site down.",
      "why": "A compliment is pleasant and a specific is useful — it is what somebody can repeat in a room Priya is not in."
    },
    {
      "situation": "You are crediting somebody partly so it comes back to you.",
      "line": "(that shows, and it is what stops it working)",
      "why": "Reciprocity is real and it is not the reason. Do it because a specific description of somebody's work costs nothing and is the most useful thing you can say."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the belief underneath the reluctance?",
      "options": [
        { "text": "That nobody wants to hear it.", "correct": false, "note": "Related and less specific. Somebody usually asked, which is how these moments arise." },
        { "text": "That credit is fixed, so claiming some takes it from others.", "correct": true, "note": "It is not a quantity. Your part and somebody else's are different facts and both fit in one sentence without either shrinking." },
        { "text": "That it will be seen as arrogant.", "correct": false, "note": "The surface fear, and it is answered by taking the adjectives out. This one is the belief underneath it." },
        { "text": "That the work was not that good.", "correct": false, "note": "Sometimes present, and it is a different problem with a different fix." }
      ],
      "explain": "Nothing is being divided. Two facts, one sentence."
    },
    {
      "prompt": "What separates real credit from the manoeuvre?",
      "options": [
        { "text": "Doing it in private.", "correct": false, "note": "Private credit is kind and does almost nothing. The point is that it is said where it can be repeated." },
        { "text": "Not mentioning yourself at all.", "correct": false, "note": "That is the deflection again, and it leaves the answer as nobody in particular." },
        { "text": "Specifics.", "correct": true, "note": "Priya was great is a compliment. Priya caught the thing that would have taken the site down is a fact somebody can repeat in a room she is not in." },
        { "text": "Doing it often.", "correct": false, "note": "Frequency without accuracy is exactly what makes it read as a manoeuvre." }
      ],
      "explain": "Say what they actually did. Vague praise helps nobody and reads as technique."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "both", "label": "Named both parts", "description": "Credited somebody else without erasing their own." },
      { "key": "specific", "label": "Was specific", "description": "Said what the person actually did rather than praising them generally." },
      { "key": "genuine", "label": "Meant it", "description": "Credited for accuracy rather than for effect." },
      { "key": "public", "label": "Said it where it counts", "description": "Said it somewhere it could be repeated." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A team review of the migration. Your manager has just said it went well and asked what made the difference.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Repeats specifics upward and forgets general praise. Notices who names whom.",
      "mood": "Pleased, taking notes.",
      "openness": 4
    },
    "opening_beat": "\"That went better than I expected, honestly. What made the difference?\"",
    "success_looks_like": "The user names somebody else's contribution specifically and their own alongside it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Write down and repeat back anything specific about who did what.",
      "Respond with a nod and nothing more to general praise or to a team effort answer.",
      "Never ask the user what they personally contributed."
    ]
  }$j$::jsonb,
  $md$Today, say out loud what one other person specifically did, in a place where it can be repeated. Log what you said.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('being-seen', 1, 'choice', $j${
  "beats": [
    {
      "situation": "A project you did most of the work on has landed well. Nobody has said who did what.",
      "prompt": "What happens now, if you say nothing?",
      "options": [
        { "text": "It gets noticed eventually — these things come out.", "correct": false, "note": "There is no mechanism by which they come out. This is the ledger that does not exist." },
        { "text": "A project went well and no name is attached to it.", "correct": true, "note": "The default is not neutral. What reaches the person deciding is whatever somebody happened to say in a room you were not in." },
        { "text": "Your manager knows, so it is covered.", "correct": false, "note": "They half know, and they need specifics for conversations you will not attend. Half knowing loses to specifics every time." },
        { "text": "Somebody else takes the credit.", "correct": false, "note": "Usually nobody does. The common outcome is not theft, it is an absence, and an absence is nobody's job to fill but yours." }
      ]
    },
    {
      "situation": "Your immediate team knows exactly how much you do and says so often.",
      "prompt": "What does that tell you?",
      "options": [
        { "text": "That your work is genuinely good.", "correct": false, "note": "Probably, and that was not in question. The question is who knows." },
        { "text": "That word will travel upward.", "correct": false, "note": "It travels if somebody carries it, and mostly nobody thinks to." },
        { "text": "Very little about whether the person deciding knows.", "correct": true, "note": "Your teammates watch you work. The decision is made by somebody who has met you twice, and being appreciated locally feels like being known." },
        { "text": "That you do not need to do anything else.", "correct": false, "note": "This is the comfortable reading and it is how good work stays invisible for years." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('being-seen', 2, 'line', $j${
  "says": "So what have you been working on?",
  "model": {
    "line": "I moved us onto the new database — it went out Thursday with no downtime.",
    "why": "A fact with a name attached and no adjective about the person saying it. There is nothing in it to dispute, which is exactly why it is comfortable to say."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Attach your name to it" },
    { "kind": "forbids_any", "requirement": "No adjectives about yourself",
      "words": ["thorough", "hard work", "really proud", "smashed", "nailed", "brilliant", "great job", "difficult", "stressful", "flat out"] },
    { "kind": "min_words", "requirement": "Say what actually happened", "n": 8 },
    { "kind": "max_words", "requirement": "One sentence, not a case", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('being-seen', 3, 'line', $j${
  "says": "Friday afternoon. The message box is open, and this week you finished the migration, took on the Henderson handover, and kept the reporting on track for the 20th.",
  "model": {
    "line": "Quick week note: migration went out Thursday, no downtime. Picked up the Henderson handover. Reporting on track for the 20th.",
    "why": "Facts, dated, four lines, no framing. It takes four minutes and becomes the material your manager uses in rooms you will never be in."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Boring — facts, not framing",
      "words": ["busy week", "flat out", "hard work", "proud", "just wanted to", "hope that is ok", "sorry", "manic", "crazy"] },
    { "kind": "min_words", "requirement": "More than one thing", "n": 12 },
    { "kind": "max_words", "requirement": "Short enough that you will do it again next week", "n": 55 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('being-seen', 4, 'line', $j${
  "says": "Oh — the migration. How did that go?",
  "model": {
    "line": "It went out Thursday, no downtime.",
    "why": "The answer to the question, in one sentence, with nothing after it. Somebody asked to be told, and fine would have been a decline."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No deflection, and no undercutting it after",
      "words": ["team effort", "fine", "ok", "not that complicated", "ran itself", "nothing special", "no big deal", "lucky", "just"] },
    { "kind": "min_words", "requirement": "Give the actual outcome", "n": 5 },
    { "kind": "max_sentences", "requirement": "One sentence, then stop", "n": 1 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('being-seen', 5, 'choice', $j${
  "beats": [
    {
      "situation": "\"That went better than I expected. What made the difference?\" Priya caught a rollback problem that would have taken the site down; you did the migration.",
      "prompt": "What do you say?",
      "options": [
        { "text": "Honestly, it was a team effort.", "correct": false, "note": "Somebody asked who did this and the answer is nobody in particular. That is vague about all of you rather than generous to any of you." },
        { "text": "Priya was great on it.", "correct": false, "note": "A compliment rather than a fact, and it is not something anybody can repeat usefully in a room Priya is not in." },
        { "text": "I did the migration. Priya helped.", "correct": false, "note": "Yours is specific and hers has been reduced to helped, which is the version of credit that does take something from somebody." },
        { "text": "Priya caught the rollback problem — that was the save. I did the migration itself.", "correct": true, "note": "Two facts, both specific, neither shrinking the other. Nothing is being divided." }
      ]
    },
    {
      "situation": "You notice you are about to credit somebody partly because it will look good.",
      "prompt": "Does that matter?",
      "options": [
        { "text": "Yes — and the fix is to be accurate rather than to say nothing.", "correct": true, "note": "The manoeuvre shows, and it shows as vagueness. Saying exactly what somebody did is the version that is useful to them and cannot read as technique." },
        { "text": "No — the effect on them is the same either way.", "correct": false, "note": "It is not. Credit given for effect tends to be general, and general credit does nothing for the person receiving it." },
        { "text": "Yes — so say nothing rather than do it for the wrong reason.", "correct": false, "note": "Purity that costs somebody else their credit. The motive is fixable; the silence is not useful to anybody." },
        { "text": "No — everybody does it for that reason.", "correct": false, "note": "Some do, and it is exactly why vague praise has stopped carrying any weight at all." }
      ]
    }
  ]
}$j$::jsonb);
