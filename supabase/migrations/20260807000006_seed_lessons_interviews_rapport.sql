-- Interviews, track 5: Screening calls and rapport.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'interview-rapport'),
  1,
  'The screen is a real interview',
  $md$More good candidates are lost on the twenty-minute screening call than at any other stage, and almost all of them are lost for the same reason: they treated it as an administrative step.

Understand what the person on the phone is actually doing. They are usually not able to judge your craft, they know it, and they are not trying to. They are deciding three things.

**Can this person hold a conversation.** They will be putting you in front of a hiring manager whose time is expensive, and the recruiter's own credibility is spent on that introduction.

**Do they want this specific job.** Not a job. This one. A candidate who cannot say why is a candidate who will drop out at offer stage, which is the recruiter's worst outcome.

**Is there anything alarming.** Bitterness about a previous employer, evasiveness about dates, a salary expectation twice the band, availability that does not work.

Nothing on that list is about how good you are. So an answer built to demonstrate expertise is aimed at a target that is not there — and worse, it usually arrives as evasive, because the listener cannot tell whether you answered.

**The move:** answer the three questions they are actually asking — can you talk, do you want this, is anything wrong.

Two practical consequences. Have a one-line answer to "why us" that could not be said about anyone else. And treat the recruiter as a person who will be an ally for the rest of the process, because they usually become one: they brief the panel, they tell you what the manager cares about, and they argue for you in the debrief. Candidates who are brisk with recruiters lose an advocate they never knew they had.$md$,
  $j$[
    {
      "situation": "Answering a recruiter's opening question at the right altitude.",
      "line": "Broadly, I have spent six years in operations for e-commerce businesses, the last three managing a team of five. Your advert is almost exactly that, one size up, which is the bit I want.",
      "why": "Matches the brief in the brief's own terms and answers 'do they want this job' in the same breath. A recruiter can write this down and use it verbatim, which is exactly what you want them to do."
    },
    {
      "situation": "Treating the recruiter as an ally rather than a gate.",
      "line": "Before we finish — is there anything about the way the manager thinks about this role that would not be obvious from the advert?",
      "why": "Recruiters know things nobody writes down, and are usually delighted to be asked. It also signals that you are preparing seriously, which is what they report back."
    },
    {
      "situation": "Handling an alarming-sounding fact before it becomes alarming.",
      "line": "One thing worth flagging now so it is not a surprise later: I am on three months' notice. It is negotiable down to about two, and I would rather tell you that at the start than at the offer.",
      "why": "Recruiters hate late surprises more than they hate bad news. Volunteering the awkward logistics early is read as professionalism and removes the biggest thing that derails offers."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is a recruiter's screening call mainly filtering for?",
      "options": [
        {
          "text": "Technical depth, which they will summarise for the hiring manager.",
          "correct": false,
          "note": "They usually cannot assess it and know they cannot. Depth aimed here mostly goes unrecorded."
        },
        {
          "text": "Whether you interview well, whether you want this job, and whether anything will blow up later.",
          "correct": true,
          "note": "Those three, in that order. Everything about how to handle a screen follows from them."
        },
        {
          "text": "Salary expectations, which is why the question always comes up.",
          "correct": false,
          "note": "It is on the list of things that could blow up later, but it is one item rather than the purpose of the call."
        },
        {
          "text": "How many other processes you are in, to gauge urgency.",
          "correct": false,
          "note": "They will often ask, and it informs their timeline. It rarely decides whether you go forward."
        }
      ],
      "explain": "None of the three is about how good you are at the job. Answers built to prove expertise are aimed at a target that is not in the room."
    },
    {
      "prompt": "Why is it worth being generous with a recruiter's time?",
      "options": [
        {
          "text": "Because they decide whether you progress.",
          "correct": false,
          "note": "True and the shallow reason. It is also the reason people are transactionally pleasant, which reads exactly as it is."
        },
        {
          "text": "Because they will brief the panel, tell you what the manager cares about, and speak for you in the debrief.",
          "correct": true,
          "note": "They are the only person in the process who is on your side by default. Candidates who treat them as an obstacle lose an advocate."
        },
        {
          "text": "Because they may have other roles if this one does not work.",
          "correct": false,
          "note": "Real, but slow and uncertain. The value in this process is far more immediate than the value in the next one."
        }
      ],
      "explain": "The recruiter is the only person in the room who wants you to succeed before you have proved anything."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "right_altitude", "label": "Pitched at the caller", "description": "Answered at a level the recruiter could assess and repeat." },
      { "key": "wanted_this_job", "label": "Showed they wanted this one", "description": "Gave a reason for this specific role rather than general enthusiasm." },
      { "key": "no_red_flags", "label": "Nothing alarming", "description": "No bitterness, evasiveness or late-breaking logistics." },
      { "key": "treated_as_ally", "label": "Treated them as a person", "description": "Engaged with the recruiter as an ally rather than as a gate to be got past." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A twenty-minute screening call, scheduled at short notice, on a mobile.",
    "partner": {
      "name": "Jess Whitcombe",
      "role": "an agency recruiter running a first screen",
      "personality": "Chatty, efficient, and shrewd about people rather than about the work. Asks about motivation twice, in different words. Warms noticeably to candidates who ask her something.",
      "mood": "Upbeat and slightly rushed. She has five of these today and remembers about two of them.",
      "openness": 4
    },
    "opening_beat": "\"Hi — thanks for picking up. So I have got your CV in front of me and the role at the client. Before I go through the details, tell me a bit about what you are looking for.\"",
    "success_looks_like": "The user gives a brief, matched answer, gives a specific reason for wanting this job, raises any awkward logistics early, and asks Jess at least one question.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask about motivation twice, phrased differently, at different points in the call.",
      "Ask about notice period and availability at some point.",
      "If an answer goes technical, say something like 'that is a bit over my head, but I will pass it on' and move to the next thing.",
      "Warm up noticeably if the user asks you a question about the role or the manager.",
      "Never evaluate the user or explain what you are looking for."
    ]
  }$j$::jsonb,
  $md$Ring or message someone who does hiring — a recruiter, a manager, a friend who interviews people — and ask what makes them cut someone at the screening stage. Log the answer.$md$
),
(
  (select id from public.skills where slug = 'interview-rapport'),
  2,
  'Match the register',
  $md$Rapport on a call is not warmth. It is fit — the sense that talking to you costs the other person nothing. And on a phone call, with no face to read, fit is carried almost entirely by two things: how long your sentences are, and how formal they are.

People are extremely sensitive to mismatch here and almost never conscious of it. A brisk caller who gets ninety-second answers experiences you as heavy going. A chatty caller who gets clipped answers experiences you as cold, and will describe you that way afterwards without being able to say why.

So read the first thirty seconds and match.

**Length.** If their questions are one sentence, answer in three or four, not fifteen. If they are telling you about their weekend, you have room.

**Formality.** Borrow their vocabulary. If they say "the guys on the team", you can too. If they say "the delivery function", stay in that register.

**Pace.** Fast talkers experience pauses as hesitation; slow talkers experience speed as pressure.

**The move:** match the length and formality of their sentences, in the first two exchanges.

This is not chameleon behaviour and it is not insincerity. It is the same adjustment you make between talking to a colleague and talking to your grandmother, done deliberately for twenty minutes.

One asymmetry worth knowing: it is easier to loosen than to tighten. Start slightly more formal than you expect to end, and follow them down. Starting too casual with someone who turns out to be formal is a hole that takes the whole call to climb out of.

And when they laugh, laugh. Candidates so braced for assessment that they miss a joke are read as tense, and tense is the adjective that ends a screening call.$md$,
  $j$[
    {
      "situation": "A brisk recruiter, matched.",
      "line": "Recruiter: \"Notice period?\" — \"Two months, negotiable to six weeks.\"",
      "why": "Four words to a two-word question. The temptation is to explain the negotiation, the manager, the handover. None of it was asked for and all of it would slow the call down."
    },
    {
      "situation": "A chatty recruiter, matched.",
      "line": "Recruiter: \"Sorry, my dog has decided this is the moment.\" — \"Honestly, mine did the same thing on a client call last week. Mid-sentence, straight past the camera.\"",
      "why": "Taking the offered social beat rather than politely ignoring it. Thirty seconds spent here buys more warmth than any answer in the call, and refusing it registers as stiffness."
    },
    {
      "situation": "Starting formal and following them down.",
      "line": "\"Good morning, thanks for making the time.\" … four minutes later … \"Yeah, that is exactly the bit that would drive me mad too.\"",
      "why": "The correct direction of travel. Loosening as the call warms is natural; the reverse journey, from over-casual to appropriately professional, always looks like a correction."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "The caller asks short, clipped questions. You give thorough two-minute answers. How will you be described afterwards?",
      "options": [
        {
          "text": "Thorough and detail-oriented.",
          "correct": false,
          "note": "Occasionally, if the detail was needed. Far more often the note says something less flattering about length."
        },
        {
          "text": "Hard work.",
          "correct": true,
          "note": "That is the phrase, or a version of it. Mismatch is experienced as effort, and effort in a twenty-minute call is remembered."
        },
        {
          "text": "Confident.",
          "correct": false,
          "note": "Length is not read as confidence. If anything, over-answering a short question reads as anxiety."
        },
        {
          "text": "Technically strong.",
          "correct": false,
          "note": "A recruiter is not equipped to conclude that, and a long answer does not help them conclude anything."
        }
      ],
      "explain": "Fit is felt as effort. Whatever the content, an answer at the wrong length costs the listener something."
    },
    {
      "prompt": "You are unsure how formal a caller is. Where should you start?",
      "options": [
        {
          "text": "Slightly more formal than you expect, and follow them down.",
          "correct": true,
          "note": "Loosening is easy and natural; tightening after being too casual always looks like a correction, and they will remember the first impression."
        },
        {
          "text": "Casual — it builds rapport faster and warmth is the goal.",
          "correct": false,
          "note": "It builds rapport fast with the half of callers who are casual, and creates a problem with the other half that lasts the whole call."
        },
        {
          "text": "In your own natural register, and let them adjust.",
          "correct": false,
          "note": "They will not adjust. You are the one being assessed, and the burden of fit sits with the person being interviewed."
        }
      ],
      "explain": "Formality is easy to shed and hard to add. Start half a step up."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "length_match", "label": "Matched the length", "description": "Answers were proportionate to the questions asked." },
      { "key": "register_match", "label": "Matched the register", "description": "Formality and vocabulary tracked the other person's." },
      { "key": "took_the_social_beat", "label": "Took the social beats", "description": "Engaged with the human moments rather than treating everything as assessment." },
      { "key": "direction", "label": "Loosened rather than tightened", "description": "Started professional and warmed, rather than starting casual and correcting." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A screening call with someone who is markedly more informal than the average interviewer.",
    "partner": {
      "name": "Baz Nolan",
      "role": "an in-house recruiter who runs calls like a chat",
      "personality": "Very casual. Swears mildly, interrupts himself, tells you things about the company he probably should not. Reads formality as coldness and will say so to colleagues without meaning to be unfair.",
      "mood": "Relaxed and friendly. Last call of the day.",
      "openness": 5
    },
    "opening_beat": "\"Right — sorry, I have got about four tabs open and none of them are yours. Give me two seconds. Right. So what is the story, why are you looking?\"",
    "success_looks_like": "The user loosens to meet Baz's register without becoming unprofessional, keeps answers proportionate, and takes the social beats he offers.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Be consistently informal. Interrupt yourself at least once, and offer one small piece of gossip about the team.",
      "Ask short questions. If you get a long, formal answer, respond with something short and slightly deflating.",
      "Offer at least one joke or aside and see whether the user takes it.",
      "Never comment on the user's tone or advise them to relax."
    ]
  }$j$::jsonb,
  $md$On your next phone call with anyone, deliberately match the length of their sentences for the first two minutes. Log what you noticed about how the call went.$md$
),
(
  (select id from public.skills where slug = 'interview-rapport'),
  3,
  'Why this company, in one line',
  $md$This is the question most candidates fail, and the bar is embarrassingly low. Most answers are a compliment, a description of the company back to itself, or a statement about the candidate's own career. None of those answer it.

A real answer has one property: it could not be said about the company across the road.

Getting there takes about fifteen minutes of preparation, and the fifteen minutes are not spent on the About page.

**Look at what they have shipped or changed recently.** A product decision, a blog post, a restructure, a pricing change.

**Look at the job description as evidence.** How a role is written tells you what has been going wrong. A description that mentions stakeholder management four times is a description of a job where nobody could get anything agreed.

**Find one person.** Someone who works there, has written or spoken about it, and said something that told you what it is like inside.

Then build the line: one specific thing, plus what it tells you, plus why that matters to you.

**The move:** name one specific thing about them, say what it tells you, say why that is what you want.

Length is a trap here. Over about thirty seconds it stops sounding like a reason and starts sounding like a pitch. Say it, then stop.

Two warnings. Do not use the product-love answer unless it is true and specific — "I use it every day" invites "what would you change?" and there is no recovering from having nothing. And avoid praise entirely: telling a company it is a market leader is information they already have, delivered by someone with no standing to grade them.$md$,
  $j$[
    {
      "situation": "A specific thing, what it tells you, why you want it.",
      "line": "You published the postmortem for the March outage with actual timings in it. Most companies would not, and it tells me the engineering culture here does not punish people for being visible. That is the thing I do not have where I am.",
      "why": "Impossible to say about anyone else, grounded in a public artefact, and it ends on a personal reason rather than on flattery. The final sentence quietly explains why they are leaving without a word of complaint."
    },
    {
      "situation": "Reading the job description as evidence.",
      "line": "The advert says 'comfortable with ambiguity' twice and mentions three teams by name. My read is that the role exists because those three teams do not agree yet, and that is honestly the work I like best.",
      "why": "Shows the candidate reads carefully and thinks about what a document reveals. It also gives the interviewer a chance to confirm the diagnosis, which almost always produces a genuinely useful conversation."
    },
    {
      "situation": "Using one person as the specific.",
      "line": "I listened to your head of design on a podcast in the spring, and she said the thing about shipping the ugly version first. I have argued for that for years and lost. Somewhere that already believes it is worth a lot to me.",
      "why": "Concrete, checkable, and it says something about the candidate's own values at the same time. 'I have argued for that and lost' is the kind of small admission that makes the whole answer sound true."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which answer to 'why us' is doing real work?",
      "options": [
        {
          "text": "You are the clear leader in the space and I want to learn from the best.",
          "correct": false,
          "note": "Praise, and information they already have. It also implies you would take the same role at whoever was leading next year."
        },
        {
          "text": "The role is a great fit for my skills and the next logical step for me.",
          "correct": false,
          "note": "This answers 'why this job for you', which is a different question. It could be true of forty employers."
        },
        {
          "text": "You moved to a two-week release cycle last year and wrote about why. I have spent two years trying to get that agreed where I am.",
          "correct": true,
          "note": "One specific, checkable fact, and a personal reason attached. Nobody else could receive this answer."
        },
        {
          "text": "I have followed the company for years and always admired the culture.",
          "correct": false,
          "note": "Unverifiable and vague. 'Culture' with no example attached is the least informative word in interviewing."
        }
      ],
      "explain": "The test is whether the answer would still make sense addressed to their nearest competitor. If it would, it is not an answer."
    },
    {
      "prompt": "Where is the best place to find the specific detail you need?",
      "options": [
        {
          "text": "The About page and the company values.",
          "correct": false,
          "note": "Written for everyone, which means it distinguishes nothing. Quoting values back is the most common weak answer there is."
        },
        {
          "text": "Recent press coverage.",
          "correct": false,
          "note": "Better, but usually about funding or growth, and it is what every other candidate will have read."
        },
        {
          "text": "Something they have shipped, written or changed, or what the job description reveals.",
          "correct": true,
          "note": "Artefacts of what they actually did, and a document written by the person hiring you. Both are specific and both are underused."
        }
      ],
      "explain": "Look for evidence of decisions rather than statements of intent. Decisions distinguish; intentions do not."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "specific", "label": "Named something specific", "description": "Pointed at a real artefact, decision or detail rather than a general impression." },
      { "key": "not_transferable", "label": "Could not be said elsewhere", "description": "The answer would not make sense addressed to a competitor." },
      { "key": "personal_reason", "label": "Connected it to themselves", "description": "Explained why that detail matters to them, rather than only praising it." },
      { "key": "brevity", "label": "Kept it under thirty seconds", "description": "Said it and stopped, rather than building it into a pitch." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A first-round interview, ten minutes in. The question arrives earlier than expected.",
    "partner": {
      "name": "Elliot Ward",
      "role": "a hiring manager who is tired of generic answers",
      "personality": "Polite and slightly weary. When given a generic answer he asks 'what makes you say that?' and waits, which is where most candidates discover they had nothing.",
      "mood": "Fair but unimpressed by default. He has heard the word 'innovative' six times this week.",
      "openness": 3
    },
    "opening_beat": "\"Let me jump ahead to something I care about more than the CV. Why us? And I would rather have a short honest answer than a good one.\"",
    "success_looks_like": "The user names one specific, checkable thing about the company, says what it tells them, and connects it to something they personally want.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "If the answer is generic or complimentary, ask 'what makes you say that?' and wait.",
      "If the user names a real specific, engage with it — confirm it, complicate it, or tell them the inside version.",
      "Do not accept enthusiasm as an answer, and do not signal that you are unimpressed.",
      "Keep your turns short."
    ]
  }$j$::jsonb,
  $md$Pick a real company and spend fifteen minutes finding one thing about them that could not be said about a competitor. Say your one-line answer out loud to someone and ask whether it sounded researched or polite. Log it.$md$
),
(
  (select id from public.skills where slug = 'interview-rapport'),
  4,
  'The first five minutes',
  $md$The interview starts before the first question, and a surprising amount of the verdict is set in the part everyone treats as preamble.

This is not because interviewers are shallow. It is because the opening exchange is the only unstructured data they get — everything after it is rehearsed, and they know it. So the two minutes about your journey, the weather, the building, is the sample of you they trust most.

Three things to get right.

**Have something to say to "how are you".** Not "fine". A specific, light, true sentence. "Good — mildly astonished to find your building on the first attempt." It costs nothing and it is the first evidence they have that talking to you is easy.

**Bring one question of your own into the opening.** Not a prepared one. Something about the room, the office, the day. It turns two people performing roles into two people talking.

**Land the transition deliberately.** When they say "so, shall we get started" — sit up slightly, close the small talk cleanly. Candidates who keep chatting past the transition are read as not picking up signals.

**The move:** answer the greeting with something specific and true, then follow their transition into the interview cleanly.

On video, three additional things, all mechanical and all worth more than they should be. Be there two minutes early and already unmuted. Look at the camera for the first sentence and the last one, whatever you do in between. And have a plan for the technology failing, said out loud without embarrassment — "shall I dial in instead?" — because it will happen to someone today and being the person who handles it calmly is free credit.

Do not over-invest. The opening is not where the job is won. It is where it is quietly made easier or quietly made harder.$md$,
  $j$[
    {
      "situation": "Answering the greeting with something real.",
      "line": "\"How are you?\" — \"Good, thanks. Slightly wired, I have had two coffees while waiting downstairs and I regret one of them.\"",
      "why": "Light, specific, faintly self-deprecating, and it admits nerves without being weighed down by them. The interviewer now has something to respond to, which is the whole point of the exchange."
    },
    {
      "situation": "Bringing a question into the opening.",
      "line": "\"Is the whole team on this floor, or is that just a meeting room thing?\"",
      "why": "Unprepared, easy to answer, and about the place rather than about the process. Questions like this convert an interview into a conversation about two minutes earlier than usual."
    },
    {
      "situation": "Handling a video failure without embarrassment.",
      "line": "\"You have gone choppy for me — do you want to try turning video off, or shall I dial in on the phone? Either is fine.\"",
      "why": "Takes charge of a problem that is nobody's fault and offers two options. It is a tiny demonstration of exactly the composure they are hiring for, delivered before the interview has begun."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does the small talk at the start carry more weight than it deserves?",
      "options": [
        {
          "text": "Because first impressions are hard to shift later.",
          "correct": false,
          "note": "True but generic. It explains the persistence of the impression, not why interviewers weight this particular exchange."
        },
        {
          "text": "Because it is the only unrehearsed sample of you they will get.",
          "correct": true,
          "note": "Everything after it is prepared, and they know it. The opening is the only part they read as unmediated."
        },
        {
          "text": "Because it tests social skills, which are part of the job.",
          "correct": false,
          "note": "Sometimes explicitly assessed, but the weighting comes from being unrehearsed rather than from being social."
        }
      ],
      "explain": "It is trusted precisely because it was not prepared. Which is a reason to have thought about it, lightly, in advance."
    },
    {
      "prompt": "The interviewer says 'right, shall we make a start'. What is the correct response?",
      "options": [
        {
          "text": "Finish the point you were making so it does not hang unresolved.",
          "correct": false,
          "note": "Small talk does not need resolving. Carrying on past a transition is the most common way candidates signal that they do not read a room."
        },
        {
          "text": "Close the small talk cleanly and follow them in.",
          "correct": true,
          "note": "Picking up the transition is itself a social signal, and it is being noticed. Half a sentence to land it, then you are ready."
        },
        {
          "text": "Ask one more question about the office to build rapport.",
          "correct": false,
          "note": "The rapport window has just been closed by the person who opened it. Reopening it costs you the credit the first two minutes earned."
        },
        {
          "text": "Say you are ready and ask what the structure of the session will be.",
          "correct": false,
          "note": "Reasonable and mildly bureaucratic. Most interviewers tell you anyway, and asking makes the start feel procedural."
        }
      ],
      "explain": "Follow their signals. The person who opened the small talk is the person who gets to close it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "real_greeting", "label": "Answered the greeting properly", "description": "Said something specific and true rather than 'fine, thanks'." },
      { "key": "asked_something", "label": "Brought something of their own", "description": "Contributed a question or observation rather than only responding." },
      { "key": "transition", "label": "Followed the transition", "description": "Closed the small talk cleanly when the interviewer moved on." },
      { "key": "composure", "label": "Composed about the mechanics", "description": "Handled any technical or logistical hitch without embarrassment." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The first two minutes of a video interview. The candidate has joined early and the interviewer arrives slightly late, with a connection that is not quite stable.",
    "partner": {
      "name": "Anne-Marie Osei",
      "role": "a hiring manager joining a video call between two other meetings",
      "personality": "Warm and slightly harried. Apologises for being late, makes small talk while opening documents, and transitions abruptly when she is ready.",
      "mood": "Rushed but friendly. She will settle within two minutes if the opening goes well.",
      "openness": 4
    },
    "opening_beat": "Her video freezes, then unfreezes mid-sentence. \"—sorry, hello! Can you hear me? I have been in back-to-backs since eight. How are you doing?\"",
    "success_looks_like": "The user answers the greeting with something specific, handles the unstable connection without fuss, contributes something of their own, and follows the transition cleanly when it comes.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Spend two exchanges on small talk, then transition abruptly with 'right, shall we make a start'.",
      "Have one further connection problem during the small talk and see how the user handles it.",
      "If the user keeps chatting after your transition, respond briefly and then ask your first interview question over the top of it.",
      "Never comment on how the user is coming across."
    ]
  }$j$::jsonb,
  $md$The next time someone asks how you are, answer with something specific and true instead of 'fine'. Log what happened to the conversation afterwards.$md$
),
(
  (select id from public.skills where slug = 'interview-rapport'),
  5,
  'No face to read',
  $md$A phone interview removes about half the information both people are using, and almost every problem specific to phone screens comes from one of two things: silence that is misread, or turn-taking that goes wrong.

**Silence gets longer.** In person, a two-second pause is filled by a face — a nod, a thinking expression. On a call it is two seconds of nothing, and nothing is uncomfortable, so both people start talking to end it. The candidate over-explains; the interviewer interrupts. Neither meant to.

The fix is to be slightly more explicit than feels natural. Signal the end of an answer out loud: "…and that is where it landed." Signal thinking out loud: "Let me think about that for a second." Both are unnecessary in person and load-bearing on a call.

**Turn-taking has no visual cue.** The tiny lean forward that says "I want to speak" is invisible. So when you collide with them, stop immediately and hand it over — "no, go on" — and do it fast. Two people apologising simultaneously for ten seconds is the most common phone-interview embarrassment there is.

**The move:** say out loud when you have finished an answer, and when you are thinking.

Two more, both cheap. Backchannel — the small "mm", "right", "got it" while they are talking. In person you nod; on the phone, nodding is silence, and silence reads as absence. And stand up. It changes the voice more than anyone expects, and voice is the entire channel.

Finally: nothing about your setting is invisible. A call taken while walking, in a car, or in a room with an echo is read as a call you did not prioritise, and that judgement is made in the first ten seconds.$md$,
  $j$[
    {
      "situation": "Signalling the end of an answer.",
      "line": "…so we shipped it in the March, and it has been quiet since. That is the whole story really.",
      "why": "The last sentence is a full stop the other person can hear. Without it, an interviewer on a phone cannot tell whether you are finished or drawing breath, and will either interrupt or wait awkwardly."
    },
    {
      "situation": "Buying thinking time explicitly.",
      "line": "That is a good question and I want to give you a real answer rather than the first one. Give me a second.",
      "why": "Converts silence from a problem into a stated intention. Interviewers almost universally respond well to this, and it prevents the half-formed answer that silence usually produces."
    },
    {
      "situation": "Recovering from talking over each other.",
      "line": "\"—sorry, go on.\" [then actually stop]",
      "why": "Three words and then silence. The failure mode is both people saying 'no, you go' twice; whoever yields cleanly and immediately ends it, and it costs nothing to be that person."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why do phone interviews produce so much over-explaining?",
      "options": [
        {
          "text": "Candidates are more nervous without visual contact.",
          "correct": false,
          "note": "Often true, and not the mechanism. Plenty of relaxed candidates over-explain on the phone for the same structural reason."
        },
        {
          "text": "Silence is uncomfortable and there is no face to fill it.",
          "correct": true,
          "note": "The pause that a nod would cover in person becomes empty air, and the candidate fills it. Naming the end of your answer removes the vacuum."
        },
        {
          "text": "Interviewers ask broader questions on the phone.",
          "correct": false,
          "note": "Screening questions are usually narrower, not broader. The length comes from the medium, not the question."
        },
        {
          "text": "There is more time available on a call.",
          "correct": false,
          "note": "There is usually less — screens are short, which makes over-explaining more expensive rather than more affordable."
        }
      ],
      "explain": "The medium removes the visual full stop. Put one in with words."
    },
    {
      "prompt": "Which habit matters most on an audio-only call?",
      "options": [
        {
          "text": "Making small verbal noises while they are talking.",
          "correct": true,
          "note": "Backchannelling is what nodding does in person. Without it a listener sounds absent, and the speaker starts wondering if the line has dropped."
        },
        {
          "text": "Speaking more slowly throughout.",
          "correct": false,
          "note": "Useful on a poor line, and mostly a comfort measure. It does not solve turn-taking or silence."
        },
        {
          "text": "Taking notes so you can refer back to their questions.",
          "correct": false,
          "note": "Genuinely helpful, and it also creates pauses. Worth doing, but it is not the thing that makes a call feel easy."
        }
      ],
      "explain": "On a call, listening has to be audible. Silence from a listener is indistinguishable from absence."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "signalled_endings", "label": "Signalled the end of answers", "description": "Made it audible when an answer was finished." },
      { "key": "named_thinking", "label": "Said when they were thinking", "description": "Filled deliberate pauses with a stated intention rather than with words." },
      { "key": "turn_taking", "label": "Handled collisions cleanly", "description": "Yielded immediately when both spoke at once, without a long exchange of apologies." },
      { "key": "audible_listening", "label": "Listened audibly", "description": "Backchannelled while the other person spoke, so the line did not go dead." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "An audio-only interview on a line that is fractionally delayed, which makes collisions more likely.",
    "partner": {
      "name": "Frank Ostrowski",
      "role": "a hiring manager conducting a phone interview",
      "personality": "Considered and slow to speak. Leaves long pauses. Occasionally starts talking at the same moment as the candidate because of the delay on the line.",
      "mood": "Patient. He is genuinely fine with silence and does not experience it as awkward.",
      "openness": 3
    },
    "opening_beat": "\"Right, I can hear you clearly. There is a bit of a lag on my end so forgive me if I talk over you. Start me off — what are you doing at the moment?\"",
    "success_looks_like": "The user signals the ends of their answers, names their thinking pauses, and handles at least one collision by yielding cleanly and immediately.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Leave long pauses after the user finishes speaking. Do not rush to fill them.",
      "At least twice, begin speaking at the same moment the user does — write it as an interrupted overlap.",
      "If the user does not signal the end of an answer, wait rather than assuming they have finished.",
      "Never mention the mechanics of phone conversation or comment on how they are handling it."
    ]
  }$j$::jsonb,
  $md$Take one phone call today standing up, and say out loud when you have finished a point. Log whether the call went differently.$md$
);
