-- Interviews, track 4: Talking about the work.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'interview-craft'),
  1,
  'Aim at the least technical person in the room',
  $md$There is a belief, common among people who are good at their jobs, that an interview is where you prove depth by displaying it. It is not. Depth is proved by control — by being able to put the explanation at whatever altitude the room needs.

The room is almost always mixed. Someone who does your job. Someone who will manage you. Frequently someone from a different function entirely, there for the read on whether you can be worked with. If you pitch at the first of those, the other two spend ninety seconds waiting, and they are usually the ones who write "unclear communicator" in the notes.

Aim at the least technical person present. The specialist will not think less of you for it — they will think you can be put in front of a customer, which is the thing their team is usually short of.

The mechanics are simple and take practice.

**Say what it was for before you say what it was.** Purpose before mechanism. "We needed to stop double-charging people" lands before any description of the system that did it.

**One layer of jargon, defined in passing.** Not zero: zero sounds evasive. "It was a reconciliation job — basically a nightly check that the two sets of numbers agree."

**Analogies only where they are honest.** A bad analogy costs more than the term it replaced, because now they have to unlearn it.

**The move:** say what it was for, then what it was, in language the least technical person in the room can follow.

The tell that you have got this right is that the non-specialist asks a question. That never happens when the answer was pitched over their head — they stay quiet, and quiet is not agreement.$md$,
  $j$[
    {
      "situation": "An engineer describing infrastructure work to a mixed panel.",
      "line": "The problem was that every time we deployed, the site went down for about ninety seconds. Nobody outside the team knew, because it happened at two in the morning, and it meant we could only ship at night. So the work was about being able to release during the day without anyone noticing.",
      "why": "Not one technical term, and a specialist can still tell exactly what was done. It leads with the human consequence — the team only shipping at night — which is the part everyone in the room can evaluate."
    },
    {
      "situation": "Defining a term in passing rather than avoiding it.",
      "line": "It was a cohort analysis — so, splitting customers by the month they joined and following each group forwards, rather than looking at everyone as one lump.",
      "why": "Uses the real term and disarms it in nine words. This is better than avoiding the word entirely, which can read as talking down, and much better than using it unexplained."
    },
    {
      "situation": "Checking the altitude mid-answer without being patronising.",
      "line": "I can go either way on the detail here — is it more useful if I stay at the shape of it, or do you want the mechanics?",
      "why": "Hands the choice to the room instead of guessing. It works because it is asked once and early; asked repeatedly it becomes an irritation and starts to sound like a lack of confidence."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "A panel of three: an engineer, a manager, and someone from commercial. Who should you aim the explanation at?",
      "options": [
        {
          "text": "The engineer — they are the one who can actually assess whether you are any good.",
          "correct": false,
          "note": "They can, and they will assess it fine from a clear explanation. Pitching at them costs you the other two votes."
        },
        {
          "text": "The manager, since they are most likely to be the decision-maker.",
          "correct": false,
          "note": "Reasonable instinct, wrong target. Aiming at the middle still leaves someone stranded."
        },
        {
          "text": "The person from commercial.",
          "correct": true,
          "note": "Aim at the least technical person and everybody follows. The specialist reads it as an ability to explain, which is a skill their team probably lacks."
        }
      ],
      "explain": "Clarity costs the specialist nothing and buys the room. Depth pitched over someone's head buys nothing from anyone."
    },
    {
      "prompt": "What is the best sign your explanation was pitched correctly?",
      "options": [
        {
          "text": "The least technical person asked a follow-up question.",
          "correct": true,
          "note": "People only ask questions about things they partly understood. A question from the non-specialist is the clearest evidence available that the answer landed."
        },
        {
          "text": "The specialist nodded along.",
          "correct": false,
          "note": "The specialist would have followed almost anything. Their nod tells you nothing about the other two."
        },
        {
          "text": "Nobody interrupted you.",
          "correct": false,
          "note": "Silence is ambiguous, and in a panel it usually means people are being polite rather than that they are with you."
        },
        {
          "text": "You got through the whole explanation in the time you planned.",
          "correct": false,
          "note": "Measures your delivery, not their comprehension. A fluent answer that nobody followed is still an answer nobody followed."
        }
      ],
      "explain": "Questions are the signal. If the non-specialists in a room never ask you anything, the explanation was probably too high."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "purpose_first", "label": "Purpose before mechanism", "description": "Said what the work was for before describing what it was." },
      { "key": "altitude", "label": "Pitched at the room", "description": "Understandable to the least technical person present, without being condescending." },
      { "key": "jargon_handled", "label": "Handled the jargon", "description": "Used real terms and defined them in passing rather than avoiding or dumping them." },
      { "key": "invited_questions", "label": "Left room to ask", "description": "Explained in a way that made a follow-up question possible." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A panel interview with three people, one of whom does not work in your discipline at all and has said so.",
    "partner": {
      "name": "Bea Coleman",
      "role": "a commercial lead on the panel, from outside your discipline",
      "personality": "Confident, friendly, and entirely unembarrassed about not knowing the technical vocabulary. Will say 'you have lost me' without any awkwardness, and does.",
      "mood": "Interested. She is assessing whether this person could be put in front of a customer.",
      "openness": 4
    },
    "opening_beat": "\"I should say up front that I am not from your world at all, so you will have to be patient with me. Tell me about the most complicated thing you have worked on.\"",
    "success_looks_like": "The user leads with purpose, keeps the explanation followable, and Bea asks a real question about the substance rather than about a word.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Say 'you have lost me' or ask what a word means whenever an undefined technical term appears. Do it cheerfully.",
      "When an explanation is clear, ask a substantive follow-up question about the work itself.",
      "Never tell the user to simplify. Just keep failing to follow until they do.",
      "Do not comment on their communication skills at any point."
    ]
  }$j$::jsonb,
  $md$Explain the most complicated part of your job to someone who does not do it — a friend, a relative, someone at the pub. Ask them afterwards to explain it back. Log the first place they got stuck.$md$
),
(
  (select id from public.skills where slug = 'interview-craft'),
  2,
  'Say what you chose against',
  $md$Two candidates describe the same project. The first says what they built. The second says what they built and what they gave up to build it. The second is read as more senior, and neither of them mentioned a job title.

The reason is that every decision worth talking about had an alternative, and the alternative had merit. Speed against correctness. Coverage against time. The elegant version against the version that shipped. A candidate who describes only the choice they made is describing a task. A candidate who names the road not taken is describing a judgement, and judgement is the thing being bought.

**The move:** for any decision you describe, name the alternative and why you did not take it.

There is a sentence pattern that does this in one breath: "We could have X, and the reason we did not was Y." Three of those in an interview will change how you are heard.

The strongest version admits the cost was real. "We shipped without the audit log, which meant support spent about a month answering questions they should not have had to. I would do it again, because the alternative was missing the season." That is a person weighing, not a person justifying.

Two cautions. Do not manufacture trade-offs where there were none — a decision presented as agonising when it was obvious sounds like padding. And do not describe a trade-off you now think you got wrong without saying so; the interviewer will spot it, and the credit for noticing goes to whoever says it first.

The same move works when the decision was not yours. "The call was made to go with the vendor. I argued for building it, and the reason I lost is that we had no one to maintain it, which was a fair point." That shows you can disagree and then commit, which is rarer and more valuable than being right.$md$,
  $j$[
    {
      "situation": "Naming the alternative in a single sentence.",
      "line": "We could have rebuilt it properly and it would have taken about five months. We patched it in three weeks instead, because the contract renewal was in April and a beautiful system nobody had renewed was worth nothing.",
      "why": "The alternative is real, the reason is commercial, and the last clause shows the candidate understands what the business was actually optimising for. That is the difference between an engineer and a senior one."
    },
    {
      "situation": "Admitting the cost was real, and standing by the call.",
      "line": "The cost was that we carried a manual step for about eight months, which two people hated and told me so regularly. It was still the right call, and I would tell them the same thing today.",
      "why": "Names a human cost, does not minimise it, does not apologise for the decision. Interviewers are listening for whether you can hold both — the cost being real and the call being right."
    },
    {
      "situation": "Describing a decision that went against you.",
      "line": "I wanted to build it and I lost that argument. The reason I lost was that we had one person who could have maintained it and she was already on two other things, which I had not weighted properly. We bought the thing and it was fine.",
      "why": "Loses an argument, explains the winning reasoning better than the winner might have, and reports the outcome without grievance. This is one of the strongest things a candidate can demonstrate."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "You describe a technical decision and the interviewer says 'why not the other way?'. What is that question doing?",
      "options": [
        {
          "text": "Testing whether you know the alternative exists.",
          "correct": false,
          "note": "Partly, and it is the shallow reading. Most candidates know the alternatives; fewer can say why theirs won."
        },
        {
          "text": "Disagreeing with your decision.",
          "correct": false,
          "note": "Usually not. Interviewers ask this of good decisions and bad ones alike, because the reasoning is what they are scoring."
        },
        {
          "text": "Checking whether you can argue the other side.",
          "correct": false,
          "note": "Close, but incomplete — being able to argue it is less important than having weighed it at the time."
        },
        {
          "text": "Asking whether the decision was made or merely arrived at.",
          "correct": true,
          "note": "That is the real question underneath. A decision with a named alternative was made; one without is something that happened to you."
        }
      ],
      "explain": "Volunteer the alternative before you are asked, and this question never has to be put to you."
    },
    {
      "prompt": "Which is the strongest way to describe a trade-off?",
      "options": [
        {
          "text": "We chose the pragmatic option given the constraints we were under.",
          "correct": false,
          "note": "Says nothing. 'Pragmatic' and 'constraints' are placeholders where the actual alternative and the actual cost should be."
        },
        {
          "text": "We could have automated it, and we did not, because it would have taken two of us for six weeks and we only had the one release window.",
          "correct": true,
          "note": "Names the alternative, the cost of taking it, and the reason. Everything is specific enough to be argued with, which is what makes it credible."
        },
        {
          "text": "It was a difficult decision with good arguments on both sides.",
          "correct": false,
          "note": "Describes the existence of a decision without revealing any thinking. This is what people say when they were not in the room."
        }
      ],
      "explain": "A trade-off is only visible when both sides have numbers or consequences attached. Without those it is just the word 'trade-off'."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named_alternative", "label": "Named the road not taken", "description": "Said what else could have been done, specifically." },
      { "key": "real_cost", "label": "Admitted the cost", "description": "Acknowledged what the chosen path actually cost, rather than presenting it as free." },
      { "key": "reasoning", "label": "Gave the reason", "description": "Explained why the alternative lost, in terms someone could disagree with." },
      { "key": "commitment", "label": "Owned the outcome", "description": "Stood by the decision, or said plainly that they now think it was wrong." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A deep-dive technical conversation, forty minutes long, with someone who will be a peer if this works out.",
    "partner": {
      "name": "Jonas Reiter",
      "role": "a senior peer running the deep dive",
      "personality": "Curious and slightly contrarian. Whenever a decision is described, he asks about the other option — not to argue, but because it is the only question he finds interesting.",
      "mood": "Enjoying himself. This is his favourite part of the week.",
      "openness": 4
    },
    "opening_beat": "\"Pick something you built where there was a real fork in the road. I am much more interested in the fork than in the thing.\"",
    "success_looks_like": "The user describes decisions with their alternatives attached, names at least one real cost, and can say why the losing option lost.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Whenever the user describes a decision without an alternative, ask 'what else could you have done?'",
      "When given an alternative, ask what it would have cost, once.",
      "If the user presents a decision as obvious, push back mildly with the case for the other side and see whether they can engage with it.",
      "Never say whether you agree with their decision."
    ]
  }$j$::jsonb,
  $md$Describe one decision from your work to someone, and make yourself say the sentence 'we could have done X, and the reason we did not was Y'. Log whether the conversation went somewhere different because of it.$md$
),
(
  (select id from public.skills where slug = 'interview-craft'),
  3,
  'Offer the depth, do not pour it',
  $md$The four-minute answer is almost never the result of having too much to say. It is the result of not knowing where to stop, which is a different problem and has a mechanical fix.

Answer at one level. Then offer the next one and stop.

"So that is the shape of it. I can go into how we actually did the cutover, if that is useful." Then silence, and let them choose. Three things happen. They get an answer at the length they wanted. You demonstrate that there is more without spending it. And you hand them a conversational turn, which turns an interrogation into a conversation — that shift alone is worth more than the extra detail you were about to give.

**The move:** answer one layer deep, offer the next layer, then stop and let them ask.

The offer must be genuine, which means being ready for a yes. If you offer the mechanics of the cutover, have the mechanics. An offer you cannot honour is worse than no offer.

Watch for the two tells that you have poured rather than offered. If you have said "and then", "and also" or "sorry, one more thing" you are pouring. And if the interviewer has started nodding rhythmically, you passed the exit some time ago.

There is a recovery move for when you notice you are three minutes in: stop mid-thought and land it. "I am going long — the short version is that we got it down to one release a week. Happy to go back into any part of that." No apology beyond four words. Candidates who can land a runaway answer are rated better than those who never took off, because the recovery is itself a demonstration of self-awareness.$md$,
  $j$[
    {
      "situation": "Ending an answer with a genuine offer.",
      "line": "…and that got us from about forty minutes to under five. There is a whole other story about how we handled the ones that were already in flight, if you want it.",
      "why": "Complete answer, then a named door rather than a vague 'happy to go deeper'. Naming the specific next topic makes it easy for the interviewer to say yes, and shows you know which part was interesting."
    },
    {
      "situation": "Landing a runaway answer.",
      "line": "I am going long on this. Short version: we halved the error rate and it stayed halved. Ask me about any part of it.",
      "why": "Three seconds to recover, no grovelling, and it ends on the outcome rather than trailing off. The willingness to interrupt yourself reads as control, not as a mistake."
    },
    {
      "situation": "Declining to go deeper when the depth would not help.",
      "line": "I could take you through the schema, but honestly the interesting part was not technical — it was that nobody could agree what a customer was. Do you want that instead?",
      "why": "Judgement about which depth is worth spending time on. Redirecting towards the genuinely interesting problem is a much stronger signal than obediently producing detail."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which is the best way to end a technical answer?",
      "options": [
        {
          "text": "Name a specific next layer and offer it.",
          "correct": true,
          "note": "Specific offers get taken. It proves there is more, hands over the turn, and lets them pick the part they care about."
        },
        {
          "text": "Ask whether that answered the question.",
          "correct": false,
          "note": "Puts the burden on them to grade you, and invites a 'not quite' that you could have avoided by simply offering the next layer."
        },
        {
          "text": "Summarise the answer you just gave.",
          "correct": false,
          "note": "Doubles the length for no new information. Summaries are for long answers, and the fix for a long answer is to make it shorter."
        },
        {
          "text": "Say that you are happy to go into more detail on any of it.",
          "correct": false,
          "note": "Close, and much weaker than it sounds. A vague offer is rarely taken up, because the interviewer has to invent the question themselves."
        }
      ],
      "explain": "Offer a door with a name on it. 'More detail' is not a door."
    },
    {
      "prompt": "You are three minutes into an answer you meant to keep to ninety seconds. What is the best recovery?",
      "options": [
        {
          "text": "Finish the thought properly — stopping halfway is worse than being long.",
          "correct": false,
          "note": "By this point the length is the problem being observed, and completing the structure does not fix it."
        },
        {
          "text": "Apologise for rambling and start again more concisely.",
          "correct": false,
          "note": "Restarting spends more time and turns a length problem into a composure problem. The apology draws attention to both."
        },
        {
          "text": "Cut yourself off, state the outcome in one sentence, and invite questions.",
          "correct": true,
          "note": "Fast, controlled, and it leaves the answer ending on the result rather than in the weeds. Interviewers read this as self-awareness."
        }
      ],
      "explain": "The recovery is scored, not just the mistake. Landing a long answer cleanly is better than never noticing."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_layer", "label": "Answered one layer deep", "description": "Gave a complete answer at a single level rather than descending unprompted." },
      { "key": "named_offer", "label": "Offered a named next layer", "description": "The offer of more detail pointed at something specific." },
      { "key": "stopped", "label": "Stopped and waited", "description": "Handed the turn over instead of filling the pause." },
      { "key": "recovery", "label": "Landed anything that ran long", "description": "Where an answer over-ran, cut it off cleanly and ended on the outcome." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A technical interview where the interviewer is deliberately quiet, leaving space that the candidate can either use or fill.",
    "partner": {
      "name": "Ines Vargas",
      "role": "a staff engineer who says very little",
      "personality": "Economical. Asks a question, listens without expression, waits several seconds after the answer before responding. Not cold — she is thinking, and it looks like nothing.",
      "mood": "Neutral and attentive. She has decided to let the candidate set the pace.",
      "openness": 2
    },
    "opening_beat": "\"Walk me through the hardest technical problem you have solved in the last year.\" She sits back and does not write anything down.",
    "success_looks_like": "The user gives one layer, offers a specific next layer, and stops — surviving the silence without pouring more detail into it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Leave silence after every answer. Reply with a beat of nothing before speaking.",
      "If the user offers a specific next layer, take it up. If they offer a vague one, say nothing and wait.",
      "Ask at most one question per exchange, in as few words as possible.",
      "Never indicate whether an answer was the right length."
    ]
  }$j$::jsonb,
  $md$Answer a work question for someone in ninety seconds, offer a specific next layer, and then stop talking until they respond. Log what they chose to ask about.$md$
),
(
  (select id from public.skills where slug = 'interview-craft'),
  4,
  'Thinking out loud while being watched',
  $md$The live problem — a whiteboard, a case, a scenario invented on the spot — is not testing whether you get the answer. It is testing what you are like to think alongside, because that is what working with you will feel like every day.

Which means silence is the only genuine failure. A wrong direction, narrated, is assessable. Ninety seconds of quiet staring is not, and the interviewer's notes will say "hard to follow" regardless of what you were doing in there.

Four moves, in order.

**Say the problem back.** In your own words, briefly. It catches misunderstandings while they are free, and it buys you fifteen seconds of thinking time that looks like work.

**Ask the constraints.** How many users, how much time, what already exists, what does not matter. Every question you ask is a mark in your favour — a candidate who starts building without asking what they are building has told you something.

**Narrate the branch.** "There are two ways I could go here. The obvious one is X. The reason I am hesitating is Y." Then pick one and say why.

**Say when you are stuck.** "I am stuck on this bit" is a completely respectable sentence, and it usually produces a hint, and taking a hint well is itself part of what is being tested.

**The move:** narrate the branch you are choosing between, and say out loud when you are stuck.

The one thing to avoid: pretending to think while actually panicking. It is visible. The fix is to go back to the second move and ask a constraint question — it is legitimate, it is useful, and it will settle you.

If you finish and the answer is wrong, saying so is worth more than the answer would have been. "I think I have got this the wrong way round, actually. Give me a second."$md$,
  $j$[
    {
      "situation": "Opening a live problem by restating it.",
      "line": "So, to make sure I have it: we need people to be able to find a booking without logging in, and the constraint is that we cannot ask them for anything a stranger could guess. Is that the shape of it?",
      "why": "Confirms understanding, exposes the real constraint, and buys thinking time. If the restatement is wrong, finding out now costs nothing and finding out in ten minutes costs everything."
    },
    {
      "situation": "Narrating a branch instead of going quiet.",
      "line": "Two options and I do not love either. I can do it in the database, which is fast and means a migration. Or I can do it in the application, which is slower and I could ship on Thursday. I am going to start with the second one and tell you why I might regret it.",
      "why": "The interviewer now knows what is being weighed, and 'tell you why I might regret it' promises exactly the trade-off reasoning they are hoping to hear."
    },
    {
      "situation": "Admitting a wrong turn halfway through.",
      "line": "Hang on. I have been assuming these arrive in order and I do not think they do. That changes most of what I have just said — can I take it from there?",
      "why": "Catching your own error out loud is a strong signal, and 'can I take it from there' keeps momentum. Candidates who quietly hope the flaw was not noticed are always wrong about that."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "You are thirty seconds into a live problem and you have no idea where to start. What is the best move?",
      "options": [
        {
          "text": "Start writing something to show you are making progress.",
          "correct": false,
          "note": "Producing work you do not believe in is worse than producing none. The interviewer has to follow it, and you will have to unwind it."
        },
        {
          "text": "Ask a constraint question.",
          "correct": true,
          "note": "Legitimate, useful, and it restarts your thinking. Constraint questions are scored positively in almost every rubric, so this costs nothing at all."
        },
        {
          "text": "Say that you would normally look this up.",
          "correct": false,
          "note": "True in real life and unhelpful here. It answers a question about your working habits, not the one on the table."
        },
        {
          "text": "Take a moment in silence to think it through properly.",
          "correct": false,
          "note": "A few seconds is fine and normal. Thirty more is where an assessable interview becomes an unassessable one."
        }
      ],
      "explain": "When stuck, ask. Questions buy time, produce information, and score better than silence."
    },
    {
      "prompt": "Halfway through, you realise your approach is wrong. What now?",
      "options": [
        {
          "text": "Carry on — finishing something is better than abandoning it.",
          "correct": false,
          "note": "You will spend the remaining time defending a position you no longer hold, and everyone in the room can see it."
        },
        {
          "text": "Quietly adjust course and hope it goes unremarked.",
          "correct": false,
          "note": "It will be remarked. Silent correction reads as either confusion or concealment, and both are worse than the error."
        },
        {
          "text": "Say what you got wrong, and what it changes.",
          "correct": true,
          "note": "Catching your own mistake out loud is one of the strongest signals available in a live exercise, and it is frequently worth more than a clean run."
        }
      ],
      "explain": "They are watching how you think, and self-correction is the most valuable thinking there is."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "restated", "label": "Said the problem back", "description": "Confirmed the problem in their own words before starting." },
      { "key": "asked_constraints", "label": "Asked about constraints", "description": "Established what mattered before building anything." },
      { "key": "narrated", "label": "Thought out loud", "description": "Kept the reasoning audible, including the branches they rejected." },
      { "key": "handled_being_stuck", "label": "Handled being stuck", "description": "Said so plainly and used a question to move, rather than going quiet." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A live problem-solving session. The interviewer has described a scenario and is now watching, with a notebook.",
    "partner": {
      "name": "Ravi Chandrasekaran",
      "role": "an interviewer running a scenario exercise",
      "personality": "Encouraging in manner but deliberately unhelpful in substance. Answers constraint questions fully and honestly. Volunteers nothing.",
      "mood": "Attentive. He genuinely wants to see how this person thinks and will not rescue them from a silence.",
      "openness": 3
    },
    "opening_beat": "\"Here is the situation. Our support team is drowning: about four hundred tickets a week and roughly half are the same six questions. You have got a small team and one quarter. Where do you start?\"",
    "success_looks_like": "The user restates the problem, asks constraint questions, narrates their reasoning including alternatives, and says out loud when they are stuck.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer any constraint question fully and truthfully — invent consistent details as needed.",
      "Never volunteer information that has not been asked for.",
      "If the user goes quiet, wait. Only after a long silence, ask 'what are you thinking?'",
      "If the user says they are stuck, offer one small hint and nothing more.",
      "Do not evaluate their approach at any point."
    ]
  }$j$::jsonb,
  $md$Ask someone to give you a problem from their own work that you know nothing about, and think it through out loud in front of them for five minutes. Log the moment you wanted to go quiet.$md$
),
(
  (select id from public.skills where slug = 'interview-craft'),
  5,
  'Work you are not allowed to describe',
  $md$Confidentiality, security clearance, an unreleased product, a client who would recognise themselves in one sentence. Sooner or later your best example is one you cannot tell.

Most people handle this badly in one of two directions. They either say "I cannot discuss that" and stop, which reads as unhelpful and wastes the strongest material they have. Or they tell it anyway, which tells the interviewer exactly what you will do with their secrets in two years.

The way through is to describe the shape and remove the identity.

**Abstract the domain.** "A regulated industry where a mistake gets reported to a regulator." "A consumer product with a few million users."

**Keep the structure, change the specifics.** The size of the team, the nature of the constraint, the decision you faced — all of that is yours to tell. The client's name, the numbers, the mechanism, may not be.

**Say the boundary once, without ceremony.** "I will keep this vague on the client and specific on what I did." One sentence, said lightly, and then get on with it.

**The move:** name the boundary once, then describe the shape of the work in full.

Done well, this is a net positive. The interviewer learns what you did and simultaneously watches you handle confidential information with care in real time. That is a live demonstration of trustworthiness, which no answer about your integrity could ever provide.

Two failure modes. Over-signalling — repeating "I cannot say much about this" five times, which is tedious and makes you sound like you have nothing. And the false boundary: claiming confidentiality to avoid a question you simply do not want to answer. Interviewers can usually tell, because a real boundary is specific and a fake one is convenient.$md$,
  $j$[
    {
      "situation": "Naming the boundary once, lightly, then continuing.",
      "line": "I will be vague about who and specific about what. It was a public sector client, the sort where the thing going wrong ends up in a newspaper, and my job was to say whether we could deliver in nine months. I said no.",
      "why": "The boundary takes seven words and never comes up again. What follows is completely usable — the stakes, the role, the call made — with nothing identifying in it."
    },
    {
      "situation": "Abstracting a product that has not launched.",
      "line": "It is not out yet, so — imagine a scheduling tool for people who do not think of themselves as having a calendar. The interesting problem was that our users found the concept of an appointment stressful.",
      "why": "Preserves the genuinely interesting part, which is a human insight rather than a product detail. The interviewer gets the thinking, the employer keeps the secret."
    },
    {
      "situation": "Declining to give a number, and giving something better.",
      "line": "I cannot give you the actual figure. I can tell you it was the sort of number where a one per cent error would have been somebody's job, which is why we ran it twice with two different methods.",
      "why": "Substitutes consequence for magnitude. The interviewer learns the seriousness and the process, which is what they wanted, and no confidential figure was spoken."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Your best example is under NDA. What is the strongest approach?",
      "options": [
        {
          "text": "Pick a different example — it is not worth the risk.",
          "correct": false,
          "note": "Sometimes necessary, usually an over-correction. You are allowed to describe the shape of work you cannot name."
        },
        {
          "text": "Tell it, since interviews are private and it will not go anywhere.",
          "correct": false,
          "note": "The interviewer is a stranger who is at that moment deciding whether you are careful. This answer settles it, in the wrong direction."
        },
        {
          "text": "Say the boundary once, then describe the structure and your decisions in full.",
          "correct": true,
          "note": "They get the substance, and they watch you handle a confidence properly. Both at once, from the same answer."
        },
        {
          "text": "Ask the interviewer whether they mind you speaking about it in confidence.",
          "correct": false,
          "note": "Puts them in an awkward position and gets you nothing. It also implies your discretion is negotiable, which is precisely the wrong signal."
        }
      ],
      "explain": "Confidentiality is not a reason to have nothing to say. Handled well, it is free evidence of exactly the trait it appears to obstruct."
    },
    {
      "prompt": "Which part of a confidential project is almost always safe to describe?",
      "options": [
        {
          "text": "The decision you faced and the reasoning you used.",
          "correct": true,
          "note": "Your own judgement belongs to you. It is also the part the interviewer actually wants, which is why this handles so well."
        },
        {
          "text": "The technical architecture, since it is generic.",
          "correct": false,
          "note": "Often the most sensitive part, and rarely as generic as it feels from the inside."
        },
        {
          "text": "The results, as long as you do not name the client.",
          "correct": false,
          "note": "Figures are frequently identifying on their own, and results are usually what an NDA exists to protect."
        }
      ],
      "explain": "Abstract the identity, keep the judgement. The reasoning is yours and it is the part being assessed."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "boundary_once", "label": "Named the boundary once", "description": "Stated what they could not discuss, briefly, and did not keep returning to it." },
      { "key": "kept_substance", "label": "Kept the substance", "description": "Described the structure, stakes and decisions despite the constraint." },
      { "key": "protected_identity", "label": "Protected what mattered", "description": "Nothing identifying — client, figures, mechanism — was given away." },
      { "key": "no_false_boundary", "label": "The boundary was real", "description": "Confidentiality was not used to avoid a question they simply did not want." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "An interview where the candidate's most relevant recent work was for a client under a strict non-disclosure agreement.",
    "partner": {
      "name": "Karin Adeyemi",
      "role": "a hiring manager who is curious and does not push where she should not",
      "personality": "Interested and professional. She will ask a follow-up that edges towards specifics without meaning to, and will accept a refusal gracefully the first time.",
      "mood": "Warm and genuinely curious about the work.",
      "openness": 4
    },
    "opening_beat": "\"Your CV mentions eighteen months on something you have described only as a public sector programme. That is the bit I most want to hear about.\"",
    "success_looks_like": "The user names the boundary once, then gives a full account of the shape of the work and their own decisions without disclosing anything identifying.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask one question that edges towards a specific the user has said they cannot give — the client, a figure, the mechanism.",
      "Accept any refusal immediately and warmly, and redirect to what they can talk about.",
      "If the user volunteers something that sounds identifying, do not warn them. Ask a natural follow-up about it.",
      "Never comment on how they are handling the confidentiality."
    ]
  }$j$::jsonb,
  $md$Describe a piece of work you cannot fully talk about to someone outside it — the shape, the stakes, your decisions, none of the identifying detail. Log whether they came away understanding what you actually did.$md$
);
