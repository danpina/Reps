-- Work, track 7: Presenting.
--
-- Bounded deliberately against Storytelling & speaking, which takes narrative
-- craft and the audience you do not work with. This is the room you are
-- already in: your own deck, your own colleagues, your boss in the third row,
-- and the question you cannot answer.
--
-- The question you cannot answer is the scene, because it is the only thing
-- here that depends on somebody else. Everything else is decided before you
-- stand up or is one sentence long.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'presenting'),
  1,
  'Slides are not notes',
  $md$People do not read their slides out loud because they are lazy. They do it because a slide full of words is the only thing in the room that cannot forget what comes next, and standing up in front of colleagues makes you want something to hold.

Which means the problem is solved the day before, not in the moment. This is the rare presenting difficulty that has nothing to do with nerve: a slide carrying your notes forces you to read, and a slide carrying one point lets you talk. You cannot read out a slide that has nothing on it to read.

**The move:** one point per slide, and the sentences in your mouth.

A slide is a headline and, at most, the evidence for it. Six words and a number is a good slide. If a sentence on it is a sentence you plan to say, delete it — because you will end up saying it worse while everybody reads it faster than you can speak.

The thing you actually want to hold is not the slide. It is notes: a printed page, a card, the presenter view, with your points in the order you want them. Nobody minds notes. Everybody minds being read to.

There is a second reason this matters more than it seems. Reading aloud makes you sound like a different person — flatter, faster, and oddly formal — and the audience hears it immediately without knowing why. Talking from a point in your head sounds like you, and sounding like you is most of what people mean when they say somebody presents well.

And the empty-ish slide has an unexpected effect on nerves: with nothing to read, you look up, and looking up gets you the reactions that tell you how it is going.

If you keep one thing: if it is written on the slide, do not say it. Put the point up there and keep the sentences.$md$,
  $j$[
    {
      "situation": "Your slide has four full sentences on it.",
      "line": "(cut it to the headline and a number)",
      "why": "A sentence you plan to say should not be on the slide — everybody reads it faster than you can speak, and you end up saying it worse."
    },
    {
      "situation": "You want something to hold on to.",
      "line": "(hold notes, not the slide)",
      "why": "Nobody minds notes. Everybody minds being read to, and the slide is the worst possible teleprompter."
    },
    {
      "situation": "You are reading and it sounds flat even to you.",
      "line": "(that is the reading, not the nerves)",
      "why": "Reading aloud makes anybody sound flatter, faster and oddly formal, and a room hears it instantly without knowing why."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why do people read their slides?",
      "options": [
        { "text": "Laziness — they did not prepare.", "correct": false, "note": "Frequently they over-prepared, which is how all the words got onto the slide in the first place." },
        { "text": "The slide is the only thing that cannot forget what comes next.", "correct": true, "note": "Standing up in front of colleagues makes you want something to hold, and the slide is right there. That is why the fix is the day before." },
        { "text": "They think the audience wants the detail.", "correct": false, "note": "Sometimes the reason the detail is there, and not the reason it gets read out." },
        { "text": "Nerves.", "correct": false, "note": "Nerves are why you want something to hold. The slide being usable as notes is what makes it possible." }
      ],
      "explain": "You cannot read out a slide with nothing on it to read. Fix it the day before."
    },
    {
      "prompt": "What should be on the slide?",
      "options": [
        { "text": "Enough that it makes sense on its own afterwards.", "correct": false, "note": "A real need, and it wants a separate document. Building one artefact for two jobs is what produces the wall of text." },
        { "text": "Whatever you would struggle to remember.", "correct": false, "note": "That is exactly the notes, and putting the notes on the wall is the whole problem." },
        { "text": "The headline, and at most the evidence for it.", "correct": true, "note": "Six words and a number is a good slide. If a sentence on it is one you plan to say, delete it." },
        { "text": "As little as possible — ideally an image.", "correct": false, "note": "Overcorrecting into a keynote. A point people can read in two seconds is doing useful work." }
      ],
      "explain": "The point on the slide, the sentences in your mouth, the detail in a document."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_point", "label": "One point per slide", "description": "Put the headline up rather than the script." },
      { "key": "notes", "label": "Held notes, not the deck", "description": "Kept something to look at that was not on the wall." },
      { "key": "not_reading", "label": "Did not read it out", "description": "Said the sentences rather than the slide." },
      { "key": "looked_up", "label": "Looked up", "description": "Spent the time on the room rather than the screen." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The afternoon before a ten-minute update to the wider team. Your deck has eleven slides and most of them are paragraphs.",
    "partner": {
      "name": "Priya",
      "role": "a colleague you have asked to look at the deck",
      "personality": "Direct and useful. Reads each slide out loud back to you to make the point, and asks what you were planning to say over it.",
      "mood": "Happy to help, ten minutes to spare.",
      "openness": 5
    },
    "opening_beat": "\"Right, slide one. Shall I read it, or are you going to say it? Because it cannot be both.\"",
    "success_looks_like": "The user cuts the slide to a point and keeps the sentences for themselves.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Read any full sentence on a slide out loud, deadpan, to demonstrate the problem.",
      "Approve a slide reduced to a headline and evidence.",
      "Never rewrite a slide for the user."
    ]
  }$j$::jsonb,
  $md$Today, take one slide and cut it to a headline. Log what was on it before and after.$md$
),
(
  (select id from public.skills where slug = 'presenting'),
  2,
  'Say the point first',
  $md$Everything you have absorbed about building to a conclusion is right for a story and wrong for a work meeting.

A business audience is deciding whether to keep listening inside about fifteen seconds, and they are not deciding based on interest — they are deciding whether this is relevant to them. If they cannot tell where it is going, the middle is spent guessing rather than following, and the people you most needed have quietly opened something else.

**The move:** answer first, then show why.

*We should move the launch to March. Three reasons.* Everything after that sentence is easier to follow, because everybody now knows what they are listening for. It also survives the thing that actually happens to presentations: being cut short. If you get eight minutes instead of ten, an answer-first talk has already landed and a build-up has not.

It feels wrong the first time. Giving away the conclusion seems to remove the reason to listen — and it does the opposite, because people are not staying for a reveal, they are staying to find out whether they agree.

It also protects you from the commonest failure: running out of time before the point. Every one of us has watched somebody deliver nine minutes of careful context and then say *and so, quickly, the recommendation is* while being wound up.

Say it in one sentence with a number attached where you can. *We should move to March. Three reasons* gives people a shape to hold, and a shape is what makes the middle feel short.

If the news is bad, this holds harder. Bad news buried at the end reads as an attempt to hide it, and everybody in the room has seen that structure before.

If you keep one thing: the first sentence is the conclusion. Everything else is the argument for it.$md$,
  $j$[
    {
      "situation": "You are ten minutes from presenting a recommendation.",
      "line": "We should move the launch to March. Three reasons.",
      "why": "Everybody now knows what they are listening for, and if you get cut to eight minutes the point has already landed."
    },
    {
      "situation": "You want to build to it so the logic lands.",
      "line": "(they are not staying for a reveal)",
      "why": "People stay to find out whether they agree. Without the conclusion the middle is spent guessing at where this is going."
    },
    {
      "situation": "The news is bad.",
      "line": "(then say it first, harder)",
      "why": "Bad news at the end reads as an attempt to hide it, and everybody in the room has seen that structure before."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does building to a conclusion fail at work?",
      "options": [
        { "text": "Business audiences are impatient.", "correct": false, "note": "They are attentive to relevance rather than impatient, and that is a more useful description." },
        { "text": "It is a storytelling technique, not a work one.", "correct": false, "note": "True as a label, and it does not say what actually goes wrong." },
        { "text": "Without the conclusion, the middle is spent guessing.", "correct": true, "note": "People are deciding within fifteen seconds whether this is relevant to them. If they cannot tell where it is going, the ones you needed have opened something else." },
        { "text": "People stop listening after a minute.", "correct": false, "note": "They listen for a long time to something they can follow. It is the following that is at issue." }
      ],
      "explain": "Answer first, then show why. Everybody then knows what they are listening for."
    },
    {
      "prompt": "What does answering first protect you from?",
      "options": [
        { "text": "Being interrupted.", "correct": false, "note": "You may be interrupted more, and now the interruptions are about the point rather than about where this is going." },
        { "text": "Getting the argument wrong.", "correct": false, "note": "It does not fix a weak argument. It makes a good one easier to follow." },
        { "text": "Sounding nervous.", "correct": false, "note": "A side effect. Structure helps and it is not what this buys you." },
        { "text": "Running out of time before the point.", "correct": true, "note": "Nine minutes of careful context and then and so, quickly, the recommendation is, while being wound up. Everybody has watched it happen." }
      ],
      "explain": "Presentations get cut short. An answer-first one has already landed."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "point_first", "label": "Led with the conclusion", "description": "Said the answer in the first sentence." },
      { "key": "shape", "label": "Gave it a shape", "description": "Signalled how many reasons or what comes next." },
      { "key": "short", "label": "Kept the opener short", "description": "One sentence, not a paragraph of framing." },
      { "key": "no_burying", "label": "Did not bury bad news", "description": "Put the difficult part at the front." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A stakeholder meeting. You have ten minutes to recommend moving the launch to March, and the room is expecting January.",
    "partner": {
      "name": "Nadine",
      "role": "the senior person in the room",
      "personality": "Decides within about fifteen seconds whether to keep listening, and says so. Engages properly once she knows the recommendation.",
      "mood": "Three meetings behind.",
      "openness": 4
    },
    "opening_beat": "\"You have got ten minutes — although realistically eight. Go.\"",
    "success_looks_like": "The user opens with the recommendation rather than the context.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask where this is going if the first thirty seconds are context.",
      "Engage seriously with the reasoning once the recommendation has been stated.",
      "Cut the meeting short at eight minutes regardless of where the user has got to."
    ]
  }$j$::jsonb,
  $md$Today, open one update or message with the conclusion instead of the context. Log your first sentence.$md$
),
(
  (select id from public.skills where slug = 'presenting'),
  3,
  'One person at a time',
  $md$The advice to *scan the room* produces the vacant sweep that everybody recognises as nerves. It looks like somebody searching for an exit, because that is close to what it is.

**The move:** rest on one person for a whole sentence, then move to somebody else.

From the audience side this is the difference between being presented at and being spoken to. Somebody who takes a sentence with you has had a moment of conversation, and a room where six people have had that moment feels completely different to everybody in it, including the ones who did not get one.

From your side it is far easier, which is the part nobody mentions. Saying one sentence to one person is a thing you have done ten thousand times. Addressing forty people is not a thing anybody has done, and trying to do it is what makes your voice go strange.

Pick people who are already giving you something. In any room a few people nod, and going back to them is not cheating — it is using the feedback that is being offered. Do avoid parking on one friendly face for the whole talk, which turns into a private conversation with an audience.

The senior person in the third row deserves a specific note, because most nerves are aimed there. Give them a sentence, the same as everybody else. What you must not do is deliver the whole talk to them: the rest of the room notices immediately, and it tells them who you think matters here.

And if looking at faces is genuinely too much, look at foreheads, or at the space just beside somebody. From four feet away it is indistinguishable, and it is a great deal better than the floor or the screen.

If you keep one thing: one sentence, one person. It is smaller than presenting and it is what presenting is made of.$md$,
  $j$[
    {
      "situation": "You are about to scan the room as you talk.",
      "line": "(that is the vacant sweep everybody reads as nerves)",
      "why": "It looks like somebody searching for an exit. Resting on one person for a sentence is what being spoken to feels like."
    },
    {
      "situation": "Three people are nodding.",
      "line": "(go back to them — that is feedback being offered)",
      "why": "Using the people who are giving you something is not cheating. Just do not park on one face for the whole talk."
    },
    {
      "situation": "Faces are too much today.",
      "line": "(foreheads, or just beside somebody)",
      "why": "From four feet it is indistinguishable, and it is much better than the floor or the screen."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is one sentence to one person easier?",
      "options": [
        { "text": "Because it is a thing you have done ten thousand times.", "correct": true, "note": "Addressing forty people is not something anybody has ever done, and attempting it is what makes your voice go strange." },
        { "text": "Because you can ignore the rest of the room.", "correct": false, "note": "You are not ignoring them — you are reaching them one at a time, and they can all feel it." },
        { "text": "Because it slows you down.", "correct": false, "note": "It does, usefully, and that is a by-product rather than the reason it is easier." },
        { "text": "Because eye contact is expected.", "correct": false, "note": "Expectation is not what makes it manageable. The familiarity of the act is." }
      ],
      "explain": "Presenting is not a separate skill. It is a sentence to one person, repeated."
    },
    {
      "prompt": "The senior person is in the third row. What do they get?",
      "options": [
        { "text": "Most of your attention — they are the decision.", "correct": false, "note": "The room notices immediately, and it tells everybody else who you think matters here." },
        { "text": "None, so you do not get thrown.", "correct": false, "note": "Conspicuous, and it reads as avoidance rather than composure." },
        { "text": "A sentence, the same as everybody else.", "correct": true, "note": "They are one of the people in the room. Treating them as the room is what changes how you sound." },
        { "text": "The opening and the close.", "correct": false, "note": "A rule that keeps them as the audience and everybody else as furniture." }
      ],
      "explain": "One sentence each. Nobody is the room."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_at_a_time", "label": "One person per sentence", "description": "Rested rather than swept." },
      { "key": "spread", "label": "Moved around", "description": "Did not park on a single friendly face." },
      { "key": "senior_normal", "label": "Treated the senior person normally", "description": "Gave them a sentence rather than the whole talk." },
      { "key": "up", "label": "Stayed off the screen", "description": "Looked at people rather than at slides or the floor." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Ten minutes in front of about twenty colleagues. Your manager's manager is in the third row and you are aware of it.",
    "partner": {
      "name": "Priya",
      "role": "a colleague in the second row",
      "personality": "Gives visible feedback — nods, frowns, looks up — and describes the room's reactions plainly when asked nothing.",
      "mood": "Engaged and on your side.",
      "openness": 5
    },
    "opening_beat": "The room settles. About twenty faces, and you have not started yet.",
    "success_looks_like": "The user takes it one person at a time rather than sweeping or fixating.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Describe the room's visible reactions as part of your replies.",
      "Respond warmly when spoken to directly for a full sentence.",
      "Report the room going flat if the user talks only to the senior person or only to the screen."
    ]
  }$j$::jsonb,
  $md$Today, in one meeting, give a whole sentence to one person before moving to the next. Log what you noticed.$md$
),
(
  (select id from public.skills where slug = 'presenting'),
  4,
  'The pause is shorter than it feels',
  $md$Two silences will happen and both feel from inside like the thing has collapsed. Neither is visible as anything except composure.

The first is losing your place. You stop, you look at your notes, and time appears to stop with you. From the room it is about two seconds and it reads as a person checking something — which is exactly what it is. What turns it into a problem is the commentary: *sorry, where was I, hang on.* Nobody had noticed a problem, and you have now announced one.

**The move:** find your place, and start again from a word rather than an apology.

The second silence is the deliberate one, after you finish a section or land the important sentence. This one you have to create on purpose, because every instinct says fill it. Leave it and the point sits there for a second, which is how emphasis actually works. Fill it and you have covered your own best line with *so, yeah, that is the main thing really*.

Rushing is the general version of the same problem, and it is worth knowing that you will always be going faster than you think. Nerves compress speech, and the correction is not to speak slowly — that produces something odd and deliberate — but to stop at full stops. Full stops are where the room catches up.

Then there is the collapse that is not a collapse at all: you say something wrong, or in the wrong order, and correct yourself. *Sorry — the other way round* is completely normal and everybody does it in ordinary conversation without noticing. What is not normal is treating it as a wound and apologising twice.

If you keep one thing: a pause is somebody thinking. Nobody in the room is timing it, and it is always shorter than the version in your head.$md$,
  $j$[
    {
      "situation": "You have lost your place and are looking at your notes.",
      "line": "(find it, then start from a word)",
      "why": "It is about two seconds from the room and reads as somebody checking something. The commentary is what turns it into a problem."
    },
    {
      "situation": "You have just landed the important sentence.",
      "line": "(leave the gap on purpose)",
      "why": "The point sits there for a second, which is how emphasis works. Filling it covers your own best line."
    },
    {
      "situation": "You said two things in the wrong order.",
      "line": "Sorry — the other way round.",
      "why": "Completely normal, and everybody does it in ordinary conversation without noticing. What is not normal is apologising for it twice."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "You lose your place. What is the mistake?",
      "options": [
        { "text": "Looking at your notes.", "correct": false, "note": "That is the fix. Notes exist precisely for this and nobody minds." },
        { "text": "Announcing it.", "correct": true, "note": "Sorry, where was I, hang on. Nobody had noticed a problem until you named one — the pause itself reads as somebody checking something." },
        { "text": "Pausing at all.", "correct": false, "note": "The pause is about two seconds and reads as composure. It is not what costs you anything." },
        { "text": "Carrying on without the point you lost.", "correct": false, "note": "Often the right call, and the room will never know it was missing." }
      ],
      "explain": "Find it, start from a word, and say nothing about it."
    },
    {
      "prompt": "Why leave a silence after your best sentence?",
      "options": [
        { "text": "It gives people time to write it down.", "correct": false, "note": "A minor benefit, and it happens whether or not you pause." },
        { "text": "It makes you look confident.", "correct": false, "note": "How it looks rather than what it does. The mechanism is about the sentence, not about you." },
        { "text": "It is how emphasis works.", "correct": true, "note": "The point sits there for a second. Fill it and you have covered your own best line with so, yeah, that is the main thing really." },
        { "text": "It invites questions.", "correct": false, "note": "A short pause does not, and if it did that would be a reason some people would avoid it." }
      ],
      "explain": "Stop at full stops. That is where the room catches up."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_commentary", "label": "Did not narrate the stumble", "description": "Found the place and carried on without announcing it." },
      { "key": "deliberate_pause", "label": "Left a pause on purpose", "description": "Let the important sentence sit." },
      { "key": "full_stops", "label": "Stopped at full stops", "description": "Let the room catch up rather than running on." },
      { "key": "one_correction", "label": "Corrected once", "description": "Fixed a slip plainly without apologising twice." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Four minutes into your ten. You have just lost your thread completely and are looking down at your notes.",
    "partner": {
      "name": "Priya",
      "role": "a colleague in the second row",
      "personality": "Reports what the room is actually doing, which is mostly waiting patiently and looking at their own notes.",
      "mood": "Entirely untroubled by the pause.",
      "openness": 5
    },
    "opening_beat": "Silence. Nobody has moved. It has been about two seconds.",
    "success_looks_like": "The user restarts without apologising or narrating the stumble.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Describe the room as calm and unbothered by pauses.",
      "Report a small ripple of attention only when the user announces or apologises for the stumble.",
      "Never reassure the user directly."
    ]
  }$j$::jsonb,
  $md$Today, leave one deliberate silence after something you said, and do not fill it. Log where you left it.$md$
),
(
  (select id from public.skills where slug = 'presenting'),
  5,
  'The question you cannot answer',
  $md$It will happen and it is not a failure, and knowing what to say makes the whole rest of the talk less frightening — because most presenting nerves are really nerves about this moment.

**The move:** say you do not know, say when you will come back, and come back.

*I do not know — I will find out and come back to you today.* That is a complete, professional answer. It is what senior people say, routinely, without any drama, and the reason it works is that it is checkable: you either come back or you do not, and coming back is easy.

Improvising is the only version of this moment that actually damages you. A plausible-sounding invention gets written down, acted on, and discovered later — and what everybody remembers is not that you did not know, it is that you said something that was not true. Nobody in the room minds a gap. Everybody minds being misled, even accidentally.

Three other complete answers. *I do not have that number in front of me, but it is in the range of X* is honest and useful, provided the range is real. *That is a good question and it is really one for Priya* is fine when it is true and not when it is a lateral pass. And *say more about what you are after* is a genuine clarification, not a stall, when you honestly cannot tell what is being asked.

Then there is the question that is not a question. Sometimes somebody is making a point at you, and the answer is not information: *that is fair — shall we take it after?* moves it out of the room without conceding anything and without a public argument you were not prepared for.

If you keep one thing: I do not know, I will find out, I will come back today. Then do it, because the coming back is what makes the sentence worth anything.$md$,
  $j$[
    {
      "situation": "Asked for a number you do not have.",
      "line": "I do not know — I will find out and come back to you today.",
      "why": "Complete, professional and checkable. It is what senior people say routinely and without any drama."
    },
    {
      "situation": "You could probably guess close enough.",
      "line": "(a guess gets written down and acted on)",
      "why": "What gets remembered is not that you did not know, it is that you said something untrue. Nobody minds a gap; everybody minds being misled."
    },
    {
      "situation": "Somebody is making a point at you rather than asking.",
      "line": "That is fair — shall we take it after?",
      "why": "Moves it out of the room without conceding anything, and avoids a public argument you had no time to prepare for."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is improvising the damaging option?",
      "options": [
        { "text": "People can tell you are guessing.", "correct": false, "note": "Often they cannot, which is exactly what makes it dangerous." },
        { "text": "It makes you look unprepared.", "correct": false, "note": "Saying you do not know looks more unprepared in the moment and costs less by Friday." },
        { "text": "A plausible invention gets written down and acted on.", "correct": true, "note": "Then discovered later, and what is remembered is not the gap but the untrue thing. Nobody minds a gap." },
        { "text": "You will be asked a follow-up.", "correct": false, "note": "A practical hazard rather than the reason it costs you." }
      ],
      "explain": "I do not know, I will find out, I will come back today. Then come back."
    },
    {
      "prompt": "Somebody is making a point at you rather than asking a question.",
      "options": [
        { "text": "Answer it as though it were a question.", "correct": false, "note": "It has no answer, so this becomes a debate in front of an audience with no preparation on your side." },
        { "text": "Acknowledge it and move it out of the room.", "correct": true, "note": "That is fair — shall we take it after? concedes nothing and declines a public argument you did not choose." },
        { "text": "Disagree clearly, so the room knows where you stand.", "correct": false, "note": "Occasionally necessary and usually expensive. The room did not come for this." },
        { "text": "Say nothing and carry on.", "correct": false, "note": "Reads as being unable to handle it, and leaves the point standing unanswered." }
      ],
      "explain": "Not every question is a question. Some are a position, and positions belong outside the room."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_dont_know", "label": "Said they did not know", "description": "Did not improvise an answer." },
      { "key": "committed", "label": "Named when they would come back", "description": "Attached a time to it." },
      { "key": "no_bluffing", "label": "Gave no invented detail", "description": "Kept numbers and specifics honest." },
      { "key": "handled_the_point", "label": "Handled a point as a point", "description": "Moved a position out of the room rather than debating it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The end of your ten minutes. Questions. Somebody senior asks for a figure you genuinely do not have.",
    "partner": {
      "name": "Nadine",
      "role": "the senior person in the room",
      "personality": "Entirely satisfied by I will come back to you today, and follows up hard on anything that sounds improvised. Also has one point she wants to make rather than ask.",
      "mood": "Interested, direct.",
      "openness": 4
    },
    "opening_beat": "\"What is the actual cost of the delay? Roughly.\"",
    "success_looks_like": "The user declines to guess and commits to coming back.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Accept I do not know, I will come back today without comment and move on.",
      "Probe hard on any figure that sounds improvised, asking where it came from.",
      "After the first question, make a point rather than ask one, about the timeline being optimistic."
    ]
  }$j$::jsonb,
  $md$Today, say I do not know and name when you will come back — then come back. Log the question and whether you did.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('presenting', 1, 'choice', $j${
  "beats": [
    {
      "situation": "Slide four reads: \"Following the Q2 review we identified three areas of underperformance in the reporting pipeline, which we have addressed through a combination of automation and process change.\"",
      "prompt": "What do you do with it?",
      "options": [
        { "text": "Leave it — it is accurate and it makes sense on its own later.", "correct": false, "note": "Two jobs, one artefact. Something that reads well afterwards wants to be a document; this one guarantees you read it aloud." },
        { "text": "Cut it to \"Reporting: three fixes\" and say the rest.", "correct": true, "note": "Six words and the point. You cannot read out a slide with nothing on it to read, and now the sentences are yours." },
        { "text": "Split it across three slides.", "correct": false, "note": "Three slides of paragraph rather than one. The length was the symptom; the sentences are the problem." },
        { "text": "Shrink the text so it fits better.", "correct": false, "note": "Now it is unreadable and still there, which is the worst of both." }
      ]
    },
    {
      "situation": "You want something to hold on to while you talk.",
      "prompt": "What do you hold?",
      "options": [
        { "text": "The slides — that is what they are for.", "correct": false, "note": "It is what makes people read them out. The slide is the worst available teleprompter because everybody else can see it." },
        { "text": "Nothing — notes look unprepared.", "correct": false, "note": "Nobody minds notes. Everybody minds being read to, and going without produces the flat, fast delivery you were trying to avoid." },
        { "text": "A full script, so nothing can go wrong.", "correct": false, "note": "A script gets read, and reading aloud makes anybody sound flatter and oddly formal." },
        { "text": "A card or printed page with your points in order.", "correct": true, "note": "The thing you actually want to hold is not on the wall. Points, in order, in your hand." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('presenting', 2, 'line', $j${
  "says": "You have got ten minutes — although realistically eight. Go.",
  "model": {
    "line": "We should move the launch to March. Three reasons, and the third one is the expensive one.",
    "why": "The conclusion in the first sentence with a shape attached, so everybody knows what they are listening for. If you get cut to eight minutes the point has already landed."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No warm-up — the first sentence is the conclusion",
      "words": ["thanks for", "before i start", "a bit of background", "to set the scene", "as you know", "quick recap", "let me start by", "firstly i want"] },
    { "kind": "max_sentences", "requirement": "Two sentences at most", "n": 2 },
    { "kind": "max_words", "requirement": "Short enough to be the headline", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('presenting', 3, 'choice', $j${
  "beats": [
    {
      "situation": "You are two minutes in, in front of twenty people. Your manager's manager is in the third row.",
      "prompt": "Where are your eyes?",
      "options": [
        { "text": "Sweeping the room so everybody feels included.", "correct": false, "note": "The vacant sweep, and it reads as somebody looking for an exit. Nobody feels included by being scanned." },
        { "text": "On one person for a whole sentence, then somebody else.", "correct": true, "note": "That is what being spoken to feels like — and saying one sentence to one person is something you have done ten thousand times." },
        { "text": "Mostly on the senior person, since they decide.", "correct": false, "note": "The room notices immediately, and it tells everybody else who you think matters here." },
        { "text": "On the screen, checking you are on track.", "correct": false, "note": "Now you are reading, and the room has lost the person who was talking to them." }
      ]
    },
    {
      "situation": "Looking at faces is genuinely too much today.",
      "prompt": "What do you do instead?",
      "options": [
        { "text": "The floor, between glances up.", "correct": false, "note": "The one direction that reads unmistakably as distress, and it takes your voice down with it." },
        { "text": "The back wall, above everybody's heads.", "correct": false, "note": "Visible from the front two rows as talking to nobody, and it flattens the whole thing." },
        { "text": "Foreheads, or the space just beside somebody.", "correct": true, "note": "Indistinguishable from four feet away, and vastly better than the floor or the screen. Use it and carry on." },
        { "text": "The slides, since that is what they are looking at.", "correct": false, "note": "They are looking at the slides because you stopped giving them anything better to look at." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('presenting', 4, 'line', $j${
  "says": "(you have lost your thread completely. Four minutes in, twenty people, about two seconds of silence so far)",
  "model": {
    "line": "The second thing is the cost of the delay.",
    "why": "Starts from a word rather than from an apology. Nobody had noticed a problem — the pause read as somebody checking something, which is exactly what it was."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not announce the stumble",
      "words": ["sorry", "where was i", "lost my", "hang on", "bear with", "one second", "my apologies", "got ahead of myself", "nervous"] },
    { "kind": "min_words", "requirement": "Start from a word, not a noise", "n": 5 },
    { "kind": "max_words", "requirement": "Just pick it back up", "n": 25 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('presenting', 5, 'scene', $j${}$j$::jsonb);
