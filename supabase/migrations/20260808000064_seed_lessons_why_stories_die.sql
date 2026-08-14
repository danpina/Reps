-- Storytelling & speaking, track 1: Why your stories die.
--
-- The shop window, and it leads on the diagnosis because the reader arriving
-- here has usually concluded that they are not interesting — which is both
-- untrue and unfixable, and is why so many people simply stopped telling
-- stories at some point in their twenties.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'why-stories-die'),
  1,
  'The material was fine',
  $md$You finish. There is a small pause. Somebody says *oh, right*, and the conversation moves on.

The conclusion almost everybody draws from that is the wrong one, and it is the reason people stop: *I do not have interesting things happen to me.* It is untrue, it is unfixable, and it is contradicted by an easy test — the same events, told by somebody else, would have worked.

**The move:** treat a flat story as a structural failure rather than as evidence about your life.

This matters because the two diagnoses lead to completely different places. If the problem is your material, the only fix is a more interesting life, which is not available this week. If the problem is the telling, there are about six things to change and all of them are decisions.

It is worth being specific about what *oh, right* actually means, because it is not rudeness and it is not people being unimpressed. It is the honest response to being told a series of events with no stated reason for hearing them. The listener has been waiting for the thing that makes this worth their attention, has not received it, and is now filling a silence politely.

Two pieces of evidence you already have. Everybody knows somebody who can make a queue at a Post Office genuinely funny — the events were nothing and the telling was everything. And everybody has heard a genuinely dramatic story told so badly that nobody reacted, which is the same finding from the other direction.

So the good news is real: the ceiling on this is much higher than people think, and the ceiling is not set by what happens to you.

If you keep one thing: your material is fine. Something in the telling is going wrong, and the next four lessons are what it is.$md$,
  $j$[
    {
      "situation": "You finish and get a small pause and an oh, right.",
      "line": "(that is a structural failure, not a verdict on your life)",
      "why": "The same events told by somebody else would have worked. Blaming the material leads to a fix that is not available this week."
    },
    {
      "situation": "You have concluded nothing interesting happens to you.",
      "line": "(somebody you know can make a Post Office queue funny)",
      "why": "The events were nothing and the telling was everything, which is the whole finding in one example."
    },
    {
      "situation": "You are trying to remember a better story to tell instead.",
      "line": "(that is the wrong search)",
      "why": "Better material does not fix a structural problem — a dramatic story told badly gets exactly the same pause."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does oh, right actually mean?",
      "options": [
        { "text": "They were not impressed.", "correct": false, "note": "Usually nothing to do with being impressed. Plenty of unimpressive events are told brilliantly and land." },
        { "text": "They were not listening.", "correct": false, "note": "They were listening — that is what makes the pause so noticeable to everybody in it." },
        { "text": "They were waiting for the thing that made it worth hearing, and it did not arrive.", "correct": true, "note": "Not rudeness. It is the honest response to a series of events with no stated reason attached, and the pause is somebody being polite about it." },
        { "text": "The story was too long.", "correct": false, "note": "Frequently true and it is a symptom of the same cause rather than the cause." }
      ],
      "explain": "The listener never got told why they were listening."
    },
    {
      "prompt": "Why does blaming the material matter?",
      "options": [
        { "text": "It is unfair to yourself.", "correct": false, "note": "It is, and being unfair to yourself is not the practical objection." },
        { "text": "It leads to a fix that does not exist.", "correct": true, "note": "If the problem is your life, the answer is a more interesting one, which is not available this week. If it is the telling, there are six decisions to change." },
        { "text": "Other people have the same material.", "correct": false, "note": "True and it is the evidence rather than the reason it matters." },
        { "text": "It makes you self-conscious.", "correct": false, "note": "It does, and the bigger cost is that it points at a problem you cannot work on." }
      ],
      "explain": "A dramatic story told badly gets the same pause. That is the finding from the other direction."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "structural", "label": "Read it as structural", "description": "Treated the flat ending as a telling problem." },
      { "key": "no_material_hunt", "label": "Did not hunt for better material", "description": "Stopped looking for a more impressive story." },
      { "key": "specific", "label": "Named what went wrong", "description": "Identified something in the telling rather than a general failing." },
      { "key": "kept_telling", "label": "Kept telling stories", "description": "Did not conclude they should stop." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have just told a story at a table and it got a small pause and a change of subject. A friend has stayed behind with you.",
    "partner": {
      "name": "Sam",
      "role": "a friend who was at the table",
      "personality": "Thought the events were genuinely good and can say exactly where the telling lost people. Does not let the material take the blame.",
      "mood": "Fond, honest.",
      "openness": 5
    },
    "opening_beat": "\"That story is actually great, you know. You just told it wrong.\"",
    "success_looks_like": "The user looks at the telling rather than concluding their life is dull.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Disagree firmly whenever the user blames the material.",
      "Point at where the table went, if asked, without prescribing a fix.",
      "Never name the three failures yourself."
    ]
  }$j$::jsonb,
  $md$Today, take one story that has never landed and decide it is a telling problem. Log the story and your best guess at what goes wrong.$md$
),
(
  (select id from public.skills where slug = 'why-stories-die'),
  2,
  'No reason for telling it',
  $md$You know why this is worth saying. The listener does not, and they will not work it out on the way.

That gap is the first of the three failures and probably the largest. You are telling a story because something about it struck you — it was absurd, or it went wrong in a particular way, or it says something about somebody you both know. All of that is in your head. What arrives at the table is a sequence of events with the reason missing.

**The move:** say why you are telling it, in the first sentence.

*The most ridiculous thing happened at the garage.* *I have found out something extraordinary about Michael.* *I nearly did not come tonight, and here is why.* Each of those is doing one job: telling somebody what kind of thing is coming and why it is worth thirty seconds of their attention.

It sounds like it would spoil the ending. It does the opposite — it is the difference between somebody following a story and somebody waiting for one to be over. What spoils an ending is telling the ending, and none of those sentences do.

There is a version of this failure that is worth catching separately, because it is common in a group: telling a story because there is a gap in the conversation rather than because you have a reason. If you cannot say in one line why this is worth hearing, that is useful information before you start rather than after — and it is completely fine to not tell it.

The reason also shapes everything else. A story told because it was absurd needs different detail from the same story told because somebody behaved badly, and knowing which one you are doing is what tells you what to cut.

If you keep one thing: the first sentence says why they are listening. Nobody can supply that for themselves.$md$,
  $j$[
    {
      "situation": "You are about to launch into what happened at the garage.",
      "line": "The most ridiculous thing happened at the garage.",
      "why": "One sentence that says what kind of thing is coming and why it is worth thirty seconds. It cannot be supplied by the listener."
    },
    {
      "situation": "You worry the frame will spoil the ending.",
      "line": "(the ending would spoil the ending)",
      "why": "A frame says what kind of story this is, not what happens. It is the difference between following one and waiting for it to be over."
    },
    {
      "situation": "There is a gap in the conversation and you reach for a story.",
      "line": "(can you say in one line why it is worth hearing?)",
      "why": "If not, that is worth knowing before you start rather than after, and not telling it is completely fine."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why can the listener not work out the reason themselves?",
      "options": [
        { "text": "They are not paying enough attention.", "correct": false, "note": "They are paying attention. What they lack is the thing that only exists in your head." },
        { "text": "The reason is in your head and nowhere else.", "correct": true, "note": "You are telling it because something struck you. What arrives at the table is a sequence of events with that part missing." },
        { "text": "Stories are ambiguous by nature.", "correct": false, "note": "Grand, and not true of a story with a frame on the front." },
        { "text": "They do not know the people involved.", "correct": false, "note": "Sometimes a factor, and the same failure happens with stories about people everybody knows." }
      ],
      "explain": "The first sentence says why they are listening."
    },
    {
      "prompt": "Does framing it spoil the ending?",
      "options": [
        { "text": "Yes, a little — it is a trade worth making.", "correct": false, "note": "There is no trade. A frame says what kind of story this is, not what happens in it." },
        { "text": "No — it is the difference between following and waiting.", "correct": true, "note": "What spoils an ending is telling the ending. The most ridiculous thing happened at the garage gives away nothing at all." },
        { "text": "Only if you say too much.", "correct": false, "note": "Nearly right, and it makes it sound delicate. One line is very hard to overdo." },
        { "text": "Yes, which is why you build to it instead.", "correct": false, "note": "Building to it is exactly what produces the setup problem in the next lesson." }
      ],
      "explain": "And if you cannot say the line, that is useful before you start."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "framed", "label": "Said why it was worth hearing", "description": "Gave the reason in the first sentence." },
      { "key": "no_spoiler", "label": "Did not give away the ending", "description": "Framed the kind of story rather than its content." },
      { "key": "knew_the_reason", "label": "Knew the reason themselves", "description": "Could say in one line what made it worth telling." },
      { "key": "declined", "label": "Did not tell one with no reason", "description": "Was willing not to tell it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A table of four. Somebody has just asked how your week has been, and you have a genuinely absurd story about a garage.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table",
      "personality": "Follows a framed story attentively and drifts visibly through an unframed one, filling the pause politely at the end.",
      "mood": "Relaxed, interested.",
      "openness": 4
    },
    "opening_beat": "\"How has your week been, anyway?\"",
    "success_looks_like": "The user opens with a line saying why the story is worth hearing.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Follow attentively and react when a story is framed at the start.",
      "Drift and respond with a polite oh, right if a story arrives with no frame.",
      "Never ask what the point is."
    ]
  }$j$::jsonb,
  $md$Today, start one story with a line saying why it is worth hearing. Log the line.$md$
),
(
  (select id from public.skills where slug = 'why-stories-die'),
  3,
  'Too much front',
  $md$This is the commonest way a good story dies, and it happens before anything has happened.

*So it was Tuesday — no, Wednesday, because I had the thing — and I was driving over to my sister's, she has just moved, and the traffic on the ring road was...*

Nothing has occurred yet. The table is thirty seconds in and still being oriented, and it is at this point rather than at the end that people quietly stop following.

**The move:** start at the moment things begin to go wrong, and put anything genuinely needed in four words on the way past.

You will feel that it cannot be understood without the setup. It nearly always can. Almost every fact people establish in advance can be dropped in mid-flight — *my sister's, where I was staying* — costing four words instead of forty, and arriving at the moment it is actually needed rather than a minute early.

The reason the front feels necessary is worth understanding, because it explains why intelligent people keep doing it. In your memory, the events came in order and the context came first, so you are retelling the sequence as you experienced it. But the listener does not need your experience of the day. They need the story, and a story starts later than a day does.

A useful test before you speak: what is the first moment that anybody would find interesting? Start one sentence before that.

The related habit is correcting yourself. *No, wait, it was Thursday* costs a pause, breaks the rhythm, and buys nothing — nobody is checking, and if the day mattered you would not be unsure about it. Say Tuesday, be wrong, and carry on.

If you keep one thing: start late. Cut the drive there, the day of the week, and who suggested it — and if it turns out you needed something, four words in the middle will do.$md$,
  $j$[
    {
      "situation": "You are about to explain where you were going and why.",
      "line": "(start at the moment it goes wrong)",
      "why": "The table is oriented for thirty seconds and nothing has happened yet. That is where people quietly stop following."
    },
    {
      "situation": "It genuinely will not make sense without knowing whose house it was.",
      "line": "My sister's, where I was staying.",
      "why": "Four words on the way past, arriving when it is needed rather than a minute early. Almost every piece of setup can be done this way."
    },
    {
      "situation": "You are not sure whether it was Tuesday or Wednesday.",
      "line": "(say Tuesday and carry on)",
      "why": "Nobody is checking, and if it mattered you would know. Correcting yourself costs a pause and buys nothing."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why do intelligent people keep doing the long setup?",
      "options": [
        { "text": "They want to be accurate.", "correct": false, "note": "Part of it, and accuracy is a symptom of the deeper habit rather than its cause." },
        { "text": "They are nervous and filling time.", "correct": false, "note": "Sometimes, and this happens just as much from people who are entirely relaxed." },
        { "text": "They are retelling the day in the order they experienced it.", "correct": true, "note": "The context came first in memory, so it comes first in the telling. But the listener does not need your experience of the day — a story starts later than a day does." },
        { "text": "They think the audience needs it.", "correct": false, "note": "They do think that, and it is the belief this lesson corrects rather than the reason it forms." }
      ],
      "explain": "What is the first moment anybody would find interesting? Start one sentence before that."
    },
    {
      "prompt": "You genuinely need one piece of context. What do you do with it?",
      "options": [
        { "text": "Establish it at the start, briefly.", "correct": false, "note": "Briefly at the start is still the start, and it is where the front creeps back in." },
        { "text": "Leave it out and let them ask.", "correct": false, "note": "They will not ask mid-story, and a listener quietly confused is a listener who has stopped." },
        { "text": "Drop it in mid-flight in four words.", "correct": true, "note": "My sister's, where I was staying. It costs four words instead of forty and arrives at the moment it is needed." },
        { "text": "Rework the story so it is not needed.", "correct": false, "note": "Elaborate, and unnecessary — the four-word version solves it." }
      ],
      "explain": "Start late. Cut the drive, the day, and who suggested it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "started_late", "label": "Started late", "description": "Opened near the moment things went wrong." },
      { "key": "no_setup", "label": "Cut the setup", "description": "No day, no drive, no who suggested it." },
      { "key": "mid_flight", "label": "Dropped context in mid-flight", "description": "Four words where it was needed." },
      { "key": "no_correcting", "label": "Did not correct themselves", "description": "Let a small inaccuracy stand." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are telling the garage story. It genuinely begins when the mechanic says something extraordinary, about four minutes into a visit that started with parking.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table",
      "personality": "Visibly present for a story that starts late and visibly drifting through orientation. Never interrupts.",
      "mood": "Interested at first.",
      "openness": 4
    },
    "opening_beat": "\"Go on then — what happened at the garage?\"",
    "success_looks_like": "The user starts at the moment things go wrong rather than at the beginning of the day.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "React and lean in when a story starts at something happening.",
      "Drift, look elsewhere and go quiet during any setup longer than a sentence.",
      "Never ask for context."
    ]
  }$j$::jsonb,
  $md$Today, tell one story starting at the moment it goes wrong. Log what you cut from the front.$md$
),
(
  (select id from public.skills where slug = 'why-stories-die'),
  4,
  'Nothing at stake',
  $md$Some stories are well framed, start late, and still produce nothing. Usually the third failure: nothing in them was ever at risk.

Stakes are what make somebody keep listening rather than wait politely. It does not mean drama — the stakes in most good conversational stories are tiny. Whether you will get the parcel. Whether the man realises. Whether you are going to have to say something. The size does not matter; the presence does.

**The move:** make it clear, early, what could go wrong.

Frequently the stakes are already in the events and simply have not been said out loud. You knew, at the time, that this could go badly — and because you knew it, you have not thought to mention it. Putting it in one clause is often the entire fix: *and I am now fairly sure I have got the wrong house.*

A story with no stakes at all is what people call *a thing that happened*, and it is worth being able to recognise one before you start telling it. If nothing could have gone differently, and nothing was uncertain to anybody in it, there is nothing to follow — and the polite pause at the end is not a failure of the telling, it is an accurate response.

Two ways to find the stakes in something that seems to have none. Ask what you were hoping would happen, which supplies a want and therefore something to be denied. Or ask what you were afraid of, which is usually more vivid and is the version most people underuse.

And the stakes need to be present, not summarised. *It was quite stressful* asserts stakes. *I had about four minutes and the door was locked* creates them, and the difference is the whole thing.

If you keep one thing: say what could go wrong, early. Without it you have a sequence, and no one has ever leaned in for a sequence.$md$,
  $j$[
    {
      "situation": "The story is well framed and still lands flat.",
      "line": "(nothing in it was ever at risk)",
      "why": "Stakes are what make somebody keep listening rather than wait politely. Size does not matter — presence does."
    },
    {
      "situation": "You knew at the time it could go badly.",
      "line": "And I am now fairly sure I have got the wrong house.",
      "why": "The stakes were already in the events and were never said out loud, which is often the whole fix in one clause."
    },
    {
      "situation": "You are about to say it was quite stressful.",
      "line": "I had about four minutes and the door was locked.",
      "why": "The first asserts stakes and the second creates them, and that difference is the entire mechanism."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "How big do the stakes need to be?",
      "options": [
        { "text": "Big enough that the outcome mattered.", "correct": false, "note": "Sounds right and rules out most good conversational stories, where nothing much was at stake at all." },
        { "text": "Tiny is fine — presence is what counts.", "correct": true, "note": "Whether you will get the parcel. Whether the man realises. The size does not matter; whether anything was uncertain does." },
        { "text": "Proportional to how long the story is.", "correct": false, "note": "A neat rule with nothing behind it. A thirty-second story needs stakes as much as a two-minute one." },
        { "text": "Big enough to be worth the table's time.", "correct": false, "note": "This is the belief that makes people think they have no stories. Attention is held by uncertainty rather than by importance." }
      ],
      "explain": "Say what could go wrong, early. Without it you have a sequence."
    },
    {
      "prompt": "How do you find stakes in something that seems to have none?",
      "options": [
        { "text": "Exaggerate slightly.", "correct": false, "note": "It works once and it is the habit that eventually makes people distrust your stories." },
        { "text": "Ask what you were afraid of.", "correct": true, "note": "Usually more vivid than what you were hoping for, and the version most people underuse. Both supply something that could be denied." },
        { "text": "Add a twist at the end.", "correct": false, "note": "Stakes are established early and a twist is late. It cannot retrofit attention onto the middle." },
        { "text": "Explain why it mattered to you.", "correct": false, "note": "That asserts significance rather than creating uncertainty, and it is the summarised version this lesson warns about." }
      ],
      "explain": "It was quite stressful asserts stakes. The door was locked creates them."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "stakes", "label": "Established stakes", "description": "Made clear what could go wrong." },
      { "key": "early", "label": "Did it early", "description": "Before the middle rather than at the end." },
      { "key": "created", "label": "Created rather than asserted", "description": "Showed the risk instead of describing it as stressful." },
      { "key": "small_ok", "label": "Let them be small", "description": "Did not inflate them to justify telling it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are telling a story about picking up a parcel. Nothing dramatic happens, and at the time you were genuinely worried you would miss it.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table",
      "personality": "Leans in the moment something is uncertain and drifts through anything with no risk in it, however well told.",
      "mood": "Willing.",
      "openness": 4
    },
    "opening_beat": "\"You said something happened with the parcel?\"",
    "success_looks_like": "The user establishes early what could have gone wrong.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Lean in and ask what happened next when something is uncertain.",
      "Drift politely through any account with nothing at risk in it.",
      "Never ask what the stakes were."
    ]
  }$j$::jsonb,
  $md$Today, take one story that lands flat and find what you were afraid of at the time. Log the sentence that puts it in.$md$
),
(
  (select id from public.skills where slug = 'why-stories-die'),
  5,
  'Do not discount it before you start',
  $md$*This is not that interesting, but.* *Sorry, this is going to take a while.* *You probably had to be there.*

Each of those is said to lower expectations, and each is close to fatal — for a reason more mechanical than it looks.

**The move:** cut the disclaimer entirely and start the story.

What a disclaimer does is tell people how to listen. Given *this is not that interesting*, the table adjusts: attention comes down, the story is heard as a minor one, and the ending is received exactly as advertised. You have supplied the verdict in advance, and people rarely overturn a verdict the teller has already delivered.

It also produces the specific outcome it was trying to avoid. The disclaimer exists to protect you from the flat ending — if nobody laughs, you said it was not that funny. But it is what causes the flat ending, so the insurance pays for itself by arranging the accident.

*You had to be there* is the worst of them, because it says the story does not work before you have tried to make it work, and it hands you an excuse that stops you learning what went wrong.

Underneath, all three are the same move: a bid for permission. Quiet people ask for it before taking any of a room's attention, and the request is invisible to them and audible to everybody else. Nobody needs to grant permission for ninety seconds of a story. Starting is the permission.

The replacement is not confidence and it is not a claim about how good this is going to be. It is simply the first line of the story instead of a line about the story — the frame from lesson two, said plainly, and then the events.

If you keep one thing: nobody has to be warned. Start it, tell it, and let the ending be whatever it is.$md$,
  $j$[
    {
      "situation": "You are about to say this is not that interesting, but.",
      "line": "(cut it — start the story)",
      "why": "You have supplied the verdict in advance, and people rarely overturn a verdict the teller has already delivered."
    },
    {
      "situation": "You want insurance in case nobody laughs.",
      "line": "(the insurance arranges the accident)",
      "why": "The disclaimer exists to protect you from the flat ending and it is what causes it."
    },
    {
      "situation": "You are tempted to say you had to be there.",
      "line": "(that stops you learning what went wrong)",
      "why": "It declares the story unworkable before you have tried to make it work, and it hands you a permanent excuse."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does a disclaimer actually do?",
      "options": [
        { "text": "Makes you seem modest.", "correct": false, "note": "It reads as modesty, and what it does is more mechanical than an impression." },
        { "text": "Tells people how to listen.", "correct": true, "note": "Attention comes down, the story is heard as a minor one, and the ending is received exactly as advertised. You supplied the verdict in advance." },
        { "text": "Buys you time to remember it.", "correct": false, "note": "Two seconds, at a cost that lasts the whole story." },
        { "text": "Lowers the stakes so it cannot fail.", "correct": false, "note": "It cannot succeed either, which is the trade nobody would make deliberately." }
      ],
      "explain": "People rarely overturn a verdict the teller has already delivered."
    },
    {
      "prompt": "What are all three disclaimers underneath?",
      "options": [
        { "text": "Low self-esteem.", "correct": false, "note": "A large label that does not tell you what to do differently in the next four seconds." },
        { "text": "A habit picked up from being interrupted.", "correct": false, "note": "Plausible as an origin story and not what the sentence is doing in the moment." },
        { "text": "A bid for permission.", "correct": true, "note": "Asking before taking any of a room's attention — invisible to the person doing it and audible to everybody else. Starting is the permission." },
        { "text": "Politeness.", "correct": false, "note": "It is meant as politeness, and it costs the table the story it was about to get." }
      ],
      "explain": "Nobody needs to be warned. Start it, tell it, and let the ending be what it is."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_disclaimer", "label": "No disclaimer", "description": "Started without warning anybody." },
      { "key": "no_permission", "label": "Did not ask permission", "description": "Took the ninety seconds rather than requesting them." },
      { "key": "no_excuse", "label": "No you had to be there", "description": "Did not pre-declare it unworkable." },
      { "key": "started", "label": "Started with the story", "description": "First line was the story rather than about it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A pause at the table, and you have a story you are not sure about.",
    "partner": {
      "name": "Priya",
      "role": "somebody at the table",
      "personality": "Calibrates entirely to how a story is introduced — attentive to one that starts, politely half-attentive to one that is apologised for.",
      "mood": "Easy.",
      "openness": 4
    },
    "opening_beat": "(a lull — nobody is talking)",
    "success_looks_like": "The user starts the story with no disclaimer.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Listen properly and react to a story that simply starts.",
      "Half-listen and respond mildly to anything preceded by a disclaimer.",
      "Never encourage the user to tell a story."
    ]
  }$j$::jsonb,
  $md$Today, tell one story with no disclaimer in front of it. Log the disclaimer you did not say.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('why-stories-die', 1, 'choice', $j${
  "beats": [
    {
      "situation": "You finish a story. Small pause. Somebody says \"oh, right\" and the conversation moves on.",
      "prompt": "What just happened?",
      "options": [
        { "text": "They were not that interested in the subject.", "correct": false, "note": "Somebody you know could make a Post Office queue funny. Subject matter is not what decides this." },
        { "text": "Something in the telling went wrong.", "correct": true, "note": "The same events in somebody else's mouth would have worked, which is the whole finding — and it points at six decisions rather than at your life." },
        { "text": "Nothing much happens to you, and it showed.", "correct": false, "note": "The conclusion most people draw, and it is both untrue and unfixable — which is why people stop telling stories at all." },
        { "text": "You told it too long.", "correct": false, "note": "Frequently true and it is one symptom of a cause rather than the diagnosis." }
      ]
    },
    {
      "situation": "You want next time to go better.",
      "prompt": "What do you work on?",
      "options": [
        { "text": "Finding better stories to tell.", "correct": false, "note": "A fix that requires a more interesting life, which is not available this week. Meanwhile the story you have is fine." },
        { "text": "Being funnier.", "correct": false, "note": "Not available on request, and it is not what separates a story that lands from one that does not." },
        { "text": "Confidence — telling it like you believe it.", "correct": false, "note": "Helps at the margins, and a confidently told story with no stakes still gets the pause." },
        { "text": "Structure — the reason, the front, and the stakes.", "correct": true, "note": "Three specific failures, all of them decisions you can make differently before you open your mouth." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('why-stories-die', 2, 'line', $j${
  "says": "How has your week been, anyway?",
  "model": {
    "line": "The most ridiculous thing happened at the garage on Thursday.",
    "why": "One line that says what kind of thing is coming and why it is worth thirty seconds. It gives away nothing — what spoils an ending is telling the ending."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No disclaimer and no permission request",
      "words": ["not that interesting", "you had to be there", "sorry", "this might take", "boring", "bear with", "do you mind if", "not sure if"] },
    { "kind": "max_sentences", "requirement": "One line, then the story", "n": 1 },
    { "kind": "max_words", "requirement": "A frame, not a summary", "n": 20 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('why-stories-die', 3, 'line', $j${
  "says": "Go on then — what happened at the garage? (It really begins when the mechanic says something extraordinary, about four minutes into a visit that started with parking.)",
  "model": {
    "line": "So the mechanic comes out, looks at the car for about four seconds, and says: whose is this?",
    "why": "Starts at the moment something happens. The parking, the drive and the day of the week are all cut, and anything genuinely needed can be dropped in later in four words."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Cut the front — no day, no drive, no orientation",
      "words": ["it was tuesday", "it was wednesday", "so basically", "i was driving", "i had to go", "background", "first of all", "no wait", "or was it"] },
    { "kind": "max_words", "requirement": "Start late — one sentence in and something has happened", "n": 40 },
    { "kind": "max_sentences", "requirement": "Two sentences at most before something happens", "n": 2 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('why-stories-die', 4, 'choice', $j${
  "beats": [
    {
      "situation": "A story about collecting a parcel. Well framed, starts late, and it still lands flat.",
      "prompt": "What is missing?",
      "options": [
        { "text": "A punchline.", "correct": false, "note": "An ending needs something to end. Without uncertainty in the middle there is nothing for a punchline to resolve." },
        { "text": "Anything at risk.", "correct": true, "note": "Stakes are what make somebody keep listening rather than wait politely — and they can be tiny. Whether you will get the parcel is enough." },
        { "text": "Better detail.", "correct": false, "note": "Detail makes a story vivid and cannot make it suspenseful. Vivid with nothing at stake is a well-described sequence." },
        { "text": "It is just not a story.", "correct": false, "note": "It may become one. Most flat stories have stakes in the events that were never said out loud." }
      ]
    },
    {
      "situation": "You knew at the time that you might miss the collection. You have not mentioned it.",
      "prompt": "How do you put it in?",
      "options": [
        { "text": "It was quite stressful, actually.", "correct": false, "note": "That asserts stakes rather than creating them, and asserting them is what people do when they cannot find the concrete version." },
        { "text": "Explain at the end why it mattered.", "correct": false, "note": "Stakes work by being established early. Explained at the end they are a footnote to a story nobody followed." },
        { "text": "They shut at twelve and it was twenty past eleven.", "correct": true, "note": "Concrete, early, and it creates the uncertainty rather than describing it. Usually one clause is the entire fix." },
        { "text": "Build to it, so the risk becomes clear as it goes.", "correct": false, "note": "By the time it is clear, the part that needed the attention has already been listened to without any." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('why-stories-die', 5, 'line', $j${
  "says": "(a lull at the table — nobody is talking, and you have a story you are not sure about)",
  "model": {
    "line": "I found out something extraordinary about my upstairs neighbour this week.",
    "why": "The first line is the story rather than a line about the story. No disclaimer, no permission asked, and the table has been told how to listen by the content instead of by a warning."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No disclaimer, no apology, no permission",
      "words": ["not that interesting", "you had to be there", "sorry", "this might take a while", "boring", "not sure if", "do you mind", "quick one", "random but", "probably not funny"] },
    { "kind": "min_words", "requirement": "Actually start it", "n": 6 },
    { "kind": "max_words", "requirement": "One line, then the events", "n": 25 }
  ]
}$j$::jsonb);
