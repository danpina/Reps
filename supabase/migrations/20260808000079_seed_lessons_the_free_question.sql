-- Talking to AI, track 2: The free question.
--
-- The most mission-relevant track in the topic. Everything else here is about
-- getting more out of a tool; this is about the specific injury the app exists
-- for — not wanting to look stupid asking — and the fact that there is now one
-- place where that question is free.
--
-- Lesson four is what stops it being a lesson about hiding. Understanding
-- something privately is half the value; saying it in the room is the half
-- that Work and Small talk are waiting for.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'the-free-question'),
  1,
  'The thing you have been nodding at',
  $md$There is a particular kind of not-knowing that quiet people accumulate.

A word gets used in every meeting. You did not ask in the first week, because it seemed like something you were supposed to already know. By the fourth week asking would have meant admitting three weeks of nodding, and by now it is the ninetieth week and the question has become genuinely unaskable.

The gap itself is rarely the problem. The problem is that you cannot ask *any* question about a thing you have not admitted to not understanding — so the follow-up questions never happen either, and you stay quiet in exactly the meetings where you would otherwise have had something to say. From the outside that looks like having nothing to say.

**The move:** ask it plainly, today, in the place where it costs nothing.

*Explain X as if I have never heard of it.* No preamble. No explaining why you do not already know. No apologising to software.

Three things are being removed here, and it is worth being clear which. The embarrassment, obviously. But also the record — there is no colleague who now knows, no moment that gets remembered, nothing that comes up later. And the impatience: the person you would have asked was busy, and that fact has been doing more work in your decision than you probably realise.

Start with the oldest one. Everybody has a list, and the items on it are usually not obscure — an acronym used daily, a process everyone refers to, a bit of the product, the thing your own team's name is about. They feel enormous because of how long they have been carried, not because of how hard they are.

The whole list is usually an evening. That is the actual size of a thing you have been managing around for two years.

If you keep one thing: the question you cannot ask a person has a free answer, and you are the only one who will ever know you asked it.$md$,
  $j$[
    {
      "situation": "A word used in every meeting since your first week.",
      "line": "Explain X as if I have never heard of it.",
      "why": "No preamble and no explaining why you do not already know. There is nobody here to be embarrassed in front of."
    },
    {
      "situation": "You are about to justify the question.",
      "line": "(no preamble — just ask)",
      "why": "Apologising to software is the same crouch Messaging is about, with even less reason for it."
    },
    {
      "situation": "You have a whole list of these.",
      "line": "(start with the oldest one)",
      "why": "They feel enormous because of how long they have been carried, not because they are hard. The list is usually an evening."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does the gap actually cost you?",
      "options": [
        { "text": "Occasional confusion in meetings.", "correct": false, "note": "Survivable, and most people follow the substance fine without the term." },
        { "text": "You cannot ask anything else about it either.", "correct": true, "note": "No follow-up question is available on a thing you have not admitted to not understanding, so you stay quiet in exactly the meetings where you had something to say." },
        { "text": "People think you are not interested.", "correct": false, "note": "A consequence of the silence rather than of the gap." },
        { "text": "You make mistakes about it.", "correct": false, "note": "Sometimes, and people generally navigate around a term they have not defined." }
      ],
      "explain": "And from outside, that silence looks like having nothing to say."
    },
    {
      "prompt": "Which one should you ask first?",
      "options": [
        { "text": "The one most relevant to this week.", "correct": false, "note": "Sensible and it leaves the oldest one where it is, still doing damage." },
        { "text": "The most complicated one.", "correct": false, "note": "Difficulty is not what makes them stick. Age is." },
        { "text": "The one you would be least embarrassed by.", "correct": false, "note": "The opposite selection. Embarrassment is the sorting error, not the guide." },
        { "text": "The oldest one.", "correct": true, "note": "It feels enormous because of how long it has been carried. The whole list is usually an evening." }
      ],
      "explain": "There is no record, and nothing comes up later."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked", "label": "Asked it", "description": "Put the actual question in." },
      { "key": "no_preamble", "label": "No preamble", "description": "Did not explain why they did not know." },
      { "key": "oldest", "label": "Started with an old one", "description": "Took something long-carried." },
      { "key": "plain", "label": "Asked plainly", "description": "As if never having heard of it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A friend outside your industry has asked what you actually do, and you have hit a word you have never had defined.",
    "partner": {
      "name": "Priya",
      "role": "a friend from outside your field",
      "personality": "Asks straightforward questions and is entirely unbothered by not knowing things.",
      "mood": "Interested.",
      "openness": 5
    },
    "opening_beat": "\"What does that word mean, though? You keep using it.\"",
    "success_looks_like": "The user admits the gap plainly and decides to look it up rather than talking around it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what it means, without judgement.",
      "Treat not knowing as completely ordinary.",
      "Never define the term yourself."
    ]
  }$j$::jsonb,
  $md$Today, ask the oldest question on your list, with no preamble. Log what it was.$md$
),
(
  (select id from public.skills where slug = 'the-free-question'),
  2,
  'Ask it a third time',
  $md$The first explanation almost never lands. That is not a failure of the explanation — it is how understanding a genuinely new thing works, and it is the same for everybody.

What is different about a person is what happens next. You say *ah, right, got it*, because the alternative is saying *I still do not follow* to somebody who has already explained it once and is being kind about it. The second attempt is awkward. The third is not socially available at all, to almost anyone.

So most people take away the first explanation, which was the one that did not work.

**The move:** say *I still do not understand*, as many times as it takes.

Here that sentence costs nothing, and it is the single largest advantage this has over asking a colleague. Not speed and not availability — the ability to fail to understand repeatedly, in front of nothing.

Say precisely which bit lost you, because that is what makes the next attempt different rather than louder. *I followed it until the part about the two accounts.* *You used the word settlement and I do not know what that refers to.* Vague dissatisfaction gets you a rephrasing; a located failure gets you a different explanation.

Two requests worth knowing, because they change the shape rather than the wording. *Give me an analogy* moves it onto ground you already have. *Give me a concrete example with actual numbers* removes the abstraction, and abstraction is what most first explanations fail on.

And when it lands, say it back. *So it is basically X, and the reason it matters is Y — is that right?* That is the step people skip, and it is the one that finds out whether you have understood it or merely followed it. Those feel identical from the inside and are completely different in a meeting.

If you keep one thing: the third explanation is usually the one that works, and you can only ever get to it here.$md$,
  $j$[
    {
      "situation": "The explanation did not land.",
      "line": "I still do not understand. I followed it until the part about the two accounts.",
      "why": "A located failure gets a different explanation. Vague dissatisfaction gets the same one rephrased."
    },
    {
      "situation": "It stays abstract.",
      "line": "Give me a concrete example, with actual numbers.",
      "why": "Abstraction is what most first explanations fail on, and numbers remove it."
    },
    {
      "situation": "You think it has landed.",
      "line": "So it is basically X, and it matters because Y — is that right?",
      "why": "Saying it back is what separates having understood it from having followed it. Those feel identical from inside."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the real advantage over asking a colleague?",
      "options": [
        { "text": "It is available at midnight.", "correct": false, "note": "Convenient, and you could have asked the colleague on Monday." },
        { "text": "It explains things better.", "correct": false, "note": "Often it does not. A colleague knows your actual system." },
        { "text": "You can fail to understand repeatedly.", "correct": true, "note": "The third attempt is not socially available with a person, and the third attempt is usually the one that works." },
        { "text": "It is more patient.", "correct": false, "note": "Close, and the point is not its patience — it is that there is no audience to be patient at you." }
      ],
      "explain": "Say which bit lost you, so the next attempt is different rather than louder."
    },
    {
      "prompt": "Why say it back in your own words?",
      "options": [
        { "text": "It is polite to confirm.", "correct": false, "note": "There is nobody to be polite to. This is for you." },
        { "text": "It helps you remember it.", "correct": false, "note": "A genuine side effect, and not the reason." },
        { "text": "It makes the explanation shorter next time.", "correct": false, "note": "Not really the mechanism, and length was never the problem." },
        { "text": "Following it and understanding it feel the same.", "correct": true, "note": "Identical from the inside and completely different in a meeting. Saying it back is what tells them apart." }
      ],
      "explain": "And ask for an analogy or actual numbers when it stays abstract."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked_again", "label": "Asked again", "description": "Did not accept the first explanation." },
      { "key": "located", "label": "Said which bit lost you", "description": "Named the point of failure." },
      { "key": "concrete", "label": "Asked for a concrete version", "description": "Example, numbers or analogy." },
      { "key": "said_back", "label": "Said it back", "description": "Checked understanding against following." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Someone has explained something to you once. You did not follow the middle of it and you have just said you did.",
    "partner": {
      "name": "Priya",
      "role": "a friend from outside your field",
      "personality": "Notices the got it that arrives slightly too fast, and asks what part you would explain back.",
      "mood": "Warm.",
      "openness": 5
    },
    "opening_beat": "\"Go on then — say it back to me.\"",
    "success_looks_like": "The user admits which part did not land instead of covering it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask them to say it back in their own words.",
      "Treat a gap as entirely ordinary when admitted.",
      "Never re-explain the thing yourself."
    ]
  }$j$::jsonb,
  $md$Today, say I still do not understand at least twice on one thing. Log where it finally landed.$md$
),
(
  (select id from public.skills where slug = 'the-free-question'),
  3,
  'Ask what everyone assumes',
  $md$The questions on your list are the ones you know you cannot answer. The more expensive gaps are the ones you do not know you have — things everybody around you absorbed somewhere, which never get said out loud precisely because everybody has them.

You cannot look those up, because looking something up requires knowing it exists.

**The move:** ask what a person in your position is assumed to already know.

*What would somebody working in this take for granted that a newcomer would not?* *What do people in this industry never explain to each other?* *I have been in this job a year — what do people usually pick up in the first month that I might have missed?*

Those questions work because they invert the search. Instead of asking about a thing, you are asking for the list of things, and the list is what you were missing.

The answers arrive in three kinds, and all three are useful. Vocabulary you have been half-guessing. Structure — who actually decides what, what the stages of a process are, what the numbers people quote refer to. And convention: what counts as a lot, what is normal to push back on, what is unusual to ask for. That third kind is worth the most and is almost never written down anywhere.

This works outside work as well, and it is worth taking somewhere it does not feel like homework. What are the unwritten rules of the club you have just joined. What does everybody at this kind of dinner know. What do people assume about how a viewing works, or a first appointment, or a wedding you have never been to one of.

One caution, which is track five arriving early: it will answer these confidently even where it is guessing, especially about your particular office. Treat the answers as a list of candidates to check rather than as facts about your building. The value is in learning that a question exists, and then you can ask a person the small version.

If you keep one thing: ask for the list, not the item. You cannot look up something you do not know is there.$md$,
  $j$[
    {
      "situation": "You suspect there are gaps you cannot name.",
      "line": "What would somebody in this job take for granted that a newcomer would not?",
      "why": "It inverts the search. You are asking for the list of things rather than about a thing."
    },
    {
      "situation": "You want the part nobody writes down.",
      "line": "What counts as a lot here, and what is normal to push back on?",
      "why": "Convention is the most valuable kind of answer and is almost never recorded anywhere."
    },
    {
      "situation": "The answer is confident and about your specific office.",
      "line": "(candidates to check, not facts)",
      "why": "It cannot know your building. What you have gained is knowing the question exists."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why can you not simply look these up?",
      "options": [
        { "text": "Looking it up needs knowing it exists.", "correct": true, "note": "These are the gaps you do not know you have, so no search term is available." },
        { "text": "They are not written down anywhere.", "correct": false, "note": "Often true of convention, and plenty of them are documented and still never found." },
        { "text": "They are specific to your company.", "correct": false, "note": "Some are. Many are industry-wide and equally invisible." },
        { "text": "They are too basic to be published.", "correct": false, "note": "Basic things are published constantly. Finding them is the problem." }
      ],
      "explain": "Ask for the list, not the item."
    },
    {
      "prompt": "Which kind of answer is worth most?",
      "options": [
        { "text": "Vocabulary you have been half-guessing.", "correct": false, "note": "Useful, and the one you could have got by asking about a specific word." },
        { "text": "Structure — who decides what.", "correct": false, "note": "Valuable and usually discoverable by watching for a few months." },
        { "text": "Convention — what is normal to ask for.", "correct": true, "note": "What counts as a lot, what is normal to push back on. Almost never written down and hardest to acquire by observation." },
        { "text": "History — how things ended up this way.", "correct": false, "note": "Interesting, and it rarely changes what you do on Monday." }
      ],
      "explain": "And treat confident answers about your specific office as candidates to check."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "inverted", "label": "Asked for the list", "description": "Asked what is assumed, not about one item." },
      { "key": "convention", "label": "Reached for convention", "description": "What is normal, not only what things mean." },
      { "key": "checked", "label": "Treated answers as candidates", "description": "Did not take office-specific claims as fact." },
      { "key": "outside_work", "label": "Used it beyond work", "description": "Applied it to an unfamiliar situation." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have joined something new and can feel that everybody else shares a set of assumptions you do not have.",
    "partner": {
      "name": "Tom",
      "role": "someone who has been there for years",
      "personality": "Happy to explain anything asked about, and never volunteers what is obvious to him.",
      "mood": "Friendly, slightly rushed.",
      "openness": 4
    },
    "opening_beat": "\"You will pick it up. Everyone does.\"",
    "success_looks_like": "The user asks what is usually picked up early rather than nodding along.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer specific questions helpfully and briefly.",
      "Never volunteer background that has not been asked for.",
      "Never suggest what the user should be asking."
    ]
  }$j$::jsonb,
  $md$Today, ask what people in your position are assumed to know. Log one thing from the list you did not have.$md$
),
(
  (select id from public.skills where slug = 'the-free-question'),
  4,
  'Say it in the room',
  $md$Understanding something privately is half the value, and it is the half that changes nothing anybody can see.

This is the failure mode of everything in this track. You close the gaps, you follow the meeting properly for the first time in months, and you say exactly as much as you did before. From outside, nothing has happened.

**The move:** turn what you looked up into something you say out loud.

The form that works is a question containing what you found. *I read up on the settlement process — is it right that it only kicks in above a certain amount?* Three things are true of that sentence at once. It shows preparation, which is the cheapest kind of credibility there is. It is a question, so it needs no confidence and cannot be wrong. And it is genuinely useful, because half the time the answer is *not exactly*, and that is the part you could not have looked up.

Notice that this is the same move as everywhere else in the app. Work says come to a meeting with one prepared thing. Small talk says the material is what you already have. This is where the material comes from.

**Do not announce the source.** Not *I asked an AI about this* and not *I was reading about this last night*. Nobody says where they got it. The information is the contribution.

**Use it within a day or two.** A gap you closed on Tuesday and never said anything about by Friday has been reabsorbed. Saying it out loud is what makes it yours — the same reason the fourth track wants things rehearsed aloud rather than in your head.

**Start with the small version.** You are not required to make an argument. *Is that the same thing as X?* or *So does that mean Y is included?* is enough, and it is a full contribution.

If you keep one thing: an answer nobody hears you use has changed nothing. Say the small version within two days.$md$,
  $j$[
    {
      "situation": "You have just closed a gap you had for a year.",
      "line": "I read up on this — is it right that it only applies above a certain amount?",
      "why": "It shows preparation, it needs no confidence because it is a question, and half the time the answer is not exactly."
    },
    {
      "situation": "You are about to say where you got it.",
      "line": "(do not — nobody ever says)",
      "why": "The information is the contribution. The source is not part of it."
    },
    {
      "situation": "It feels too small to be worth saying.",
      "line": "So does that mean Y is included?",
      "why": "A small question is a full contribution, and it is where every larger one starts."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why put it in the form of a question?",
      "options": [
        { "text": "Questions are more polite.", "correct": false, "note": "Politeness is not the mechanism, and a statement would be perfectly polite." },
        { "text": "It cannot be wrong, and it shows preparation.", "correct": true, "note": "It needs no confidence, and half the time the answer is not exactly — which is the part you could not have looked up." },
        { "text": "People prefer being asked things.", "correct": false, "note": "Generally true and not why this works." },
        { "text": "It avoids sounding like you are showing off.", "correct": false, "note": "A side benefit. The load-bearing part is that a wrong question still lands." }
      ],
      "explain": "This is where Work's one prepared thing comes from."
    },
    {
      "prompt": "How long can you leave it?",
      "options": [
        { "text": "Until it comes up naturally.", "correct": false, "note": "It may not, and waiting for the natural moment is how most of these die." },
        { "text": "Until you are confident about it.", "correct": false, "note": "Confidence arrives from having said it, not before." },
        { "text": "A day or two.", "correct": true, "note": "A gap closed on Tuesday with nothing said by Friday has been reabsorbed. Saying it aloud is what makes it yours." },
        { "text": "It does not matter when.", "correct": false, "note": "It does — the same reason track four wants things rehearsed out loud rather than in your head." }
      ],
      "explain": "And never announce the source. Nobody says where they got it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_it", "label": "Said it out loud", "description": "Used it in a real room." },
      { "key": "as_question", "label": "Put it as a question", "description": "Needed no confidence to say." },
      { "key": "no_source", "label": "Did not name the source", "description": "The information was the contribution." },
      { "key": "quickly", "label": "Within a day or two", "description": "Did not wait for a natural moment." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A meeting where the thing you finally looked up last night has just come up.",
    "partner": {
      "name": "Tom",
      "role": "a colleague running the meeting",
      "personality": "Answers questions properly and moves on quickly if nobody says anything.",
      "mood": "Businesslike.",
      "openness": 4
    },
    "opening_beat": "\"Right — anything on the settlement side before we move on?\"",
    "success_looks_like": "The user asks the small version of what they looked up.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer a question straightforwardly, correcting it slightly if it is not quite right.",
      "Move the meeting on if nothing is said.",
      "Never invite the user to speak."
    ]
  }$j$::jsonb,
  $md$Today, say out loud one thing you looked up this week. Log the sentence and what came back.$md$
),
(
  (select id from public.skills where slug = 'the-free-question'),
  5,
  'Looking it up is not cheating',
  $md$There is a worry underneath this whole track that is worth taking out and looking at, because people rarely say it out loud: that using it this way is a kind of fraud. That you are turning up to the meeting able to discuss something you did not really know, and that this is a form of pretending.

It is worth answering properly rather than waving away.

**The move:** notice that the alternative to preparing was not honesty. It was silence.

Nobody has ever thought worse of a colleague for having read up on something beforehand. That is not a grudging exception — it is the definition of being prepared, and it is a quality people admire openly in everybody except themselves. The person who looked something up before a meeting is not passing off borrowed knowledge; they are somebody who did the reading.

Three specific versions of the worry, and what each is actually about.

*I did not work it out myself.* Almost nobody works anything out themselves. They were told by a colleague, or they read it, or they picked it up on a project. The route by which you came to know something is not a property of the knowledge.

*I would not be able to defend it.* Then say the small version, as the previous lesson has it. A question does not need defending, and *I think so, but I have only just read about it* is an entirely normal sentence.

*It feels like an unfair advantage.* It is an advantage, and everybody has the same one. Being unwilling to use a tool everyone else is using is not integrity, it is a handicap you have chosen and nobody has noticed.

There is a real line, and it is in the last track: when the effort is the message, outsourcing it is a genuine problem. Understanding something is not that. Nobody wanted you to be confused as a gesture of sincerity.

If you keep one thing: preparation is not pretending. The alternative was not being honestly ignorant, it was being quiet again.$md$,
  $j$[
    {
      "situation": "It feels like turning up with borrowed knowledge.",
      "line": "(that is called being prepared)",
      "why": "A quality people admire openly in everybody except themselves."
    },
    {
      "situation": "You are worried you could not defend it.",
      "line": "I think so, but I have only just read about it.",
      "why": "An entirely normal sentence, and a question never needed defending in the first place."
    },
    {
      "situation": "It feels like an unfair advantage.",
      "line": "(everybody has the same one)",
      "why": "Declining a tool everyone else uses is not integrity. It is a handicap nobody has noticed you taking."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What was the actual alternative to preparing?",
      "options": [
        { "text": "Asking a colleague instead.", "correct": false, "note": "Sometimes available, and it is the thing this track exists because you did not do." },
        { "text": "Being silent again.", "correct": true, "note": "Not honest ignorance — silence. Nobody wanted you confused as a gesture of sincerity." },
        { "text": "Working it out yourself over time.", "correct": false, "note": "The route to knowing something is not a property of the knowledge, and this route takes years." },
        { "text": "Admitting you did not know in the meeting.", "correct": false, "note": "A fine move and a much harder one, which is why it kept not happening." }
      ],
      "explain": "Preparation is not pretending."
    },
    {
      "prompt": "Where is the real line?",
      "options": [
        { "text": "When you could not explain it afterwards.", "correct": false, "note": "Then say the small version. That is a reason to scale the claim, not to stay quiet." },
        { "text": "When it is somebody else's field.", "correct": false, "note": "Reading about somebody else's field is how collaboration works." },
        { "text": "When you did not verify it.", "correct": false, "note": "A reason to check, and track five is about exactly that." },
        { "text": "When the effort was the message.", "correct": true, "note": "The apology, the condolence, the thank you. Understanding something is not that." }
      ],
      "explain": "The last track draws that line properly."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "used_it", "label": "Used what you prepared", "description": "Did not withhold it out of scruple." },
      { "key": "scaled", "label": "Scaled the claim honestly", "description": "Said how recently you learned it, if asked." },
      { "key": "no_apology", "label": "Did not apologise for preparing", "description": "Treated it as ordinary." },
      { "key": "line", "label": "Kept the real line", "description": "Knew where outsourcing would matter." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A friend has asked how you knew something you said in a meeting, and you feel oddly caught out.",
    "partner": {
      "name": "Priya",
      "role": "a friend from outside your field",
      "personality": "Genuinely curious, entirely unbothered by the answer, and puzzled by the guilt.",
      "mood": "Light.",
      "openness": 5
    },
    "opening_beat": "\"How did you know all that, anyway?\"",
    "success_looks_like": "The user says they read up on it, without apologising for it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Be entirely unimpressed by the idea that preparing is cheating.",
      "Ask what the alternative would have been.",
      "Never reassure the user in a coaching way."
    ]
  }$j$::jsonb,
  $md$Today, use something you prepared without hedging about where it came from. Log how it went.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('the-free-question', 1, 'line', $j${
  "says": "What does that word mean, though? You keep using it.",
  "model": {
    "line": "Honestly, I have never had it explained. I have been nodding at it for about two years.",
    "why": "The gap is ordinary and the admission costs nothing here. What has been expensive is the two years of not being able to ask anything else about it."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not talk around it",
      "words": ["sort of like", "it is basically when", "hard to explain", "you know how", "kind of a", "it depends"] },
    { "kind": "min_words", "requirement": "Admit the gap in a sentence", "n": 8 },
    { "kind": "max_words", "requirement": "One admission, not a confession", "n": 32 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-free-question', 2, 'line', $j${
  "says": "Go on then — say it back to me.",
  "model": {
    "line": "I cannot. I followed the first part and lost it around the two accounts, so I am going to ask again.",
    "why": "A located failure gets a different explanation rather than a louder one. The third attempt is the one that usually works, and it only exists where it costs nothing."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not claim to have got it",
      "words": ["got it", "makes sense", "i think i understand", "yeah, clear", "no, i follow", "all good"] },
    { "kind": "min_words", "requirement": "Say which part lost you", "n": 10 },
    { "kind": "max_words", "requirement": "Locate it, do not narrate it", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-free-question', 3, 'choice', $j${
  "beats": [
    {
      "situation": "You have joined something new and can feel there is a shared set of assumptions you do not have.",
      "prompt": "What do you ask?",
      "options": [
        { "text": "What does this particular acronym mean?", "correct": false, "note": "Worth asking and it only closes the gaps you already know about." },
        { "text": "Can you explain how the whole thing works?", "correct": false, "note": "Too big to answer. You get an overview you could have read anywhere." },
        { "text": "What do people here take for granted that a newcomer would not?", "correct": true, "note": "It inverts the search — you are asking for the list rather than about an item, and the list is the part you were missing." },
        { "text": "What should I read first?", "correct": false, "note": "Reasonable, and reading lists tend to cover the documented things rather than the assumed ones." }
      ]
    },
    {
      "situation": "It answers confidently about how decisions are made at your specific company.",
      "prompt": "What is that answer worth?",
      "options": [
        { "text": "Nothing — it cannot know your company.", "correct": false, "note": "Too strong. It has told you which questions exist, which is most of the value." },
        { "text": "A list of candidates to check with a person.", "correct": true, "note": "It cannot know your building. What you have gained is knowing the question is there, and the small version is now askable." },
        { "text": "As much as anything else it says.", "correct": false, "note": "No — it is at its least reliable exactly here, and its confidence does not change between the two." },
        { "text": "Enough to act on if it sounds plausible.", "correct": false, "note": "Plausibility is what it produces most reliably, which is the problem rather than the reassurance." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-free-question', 4, 'line', $j${
  "says": "Right — anything on the settlement side before we move on?",
  "model": {
    "line": "One thing — I read up on this. Is it right that it only kicks in above a certain amount?",
    "why": "Preparation is the cheapest credibility there is, a question cannot be wrong, and half the time the answer is not exactly, which is the part you could not have looked up."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Put it as a question" },
    { "kind": "forbids_any", "requirement": "Do not name the source or apologise",
      "words": ["chatgpt", "claude", "an ai", "asked a bot", "sorry", "this might be stupid", "probably wrong", "i might have this wrong"] },
    { "kind": "max_words", "requirement": "The small version", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-free-question', 5, 'choice', $j${
  "beats": [
    {
      "situation": "You used something in a meeting that you had read up on the night before, and you feel slightly fraudulent.",
      "prompt": "What is that feeling getting wrong?",
      "options": [
        { "text": "Nobody noticed, so it does not matter.", "correct": false, "note": "Whether anyone noticed is not the question. The worry would survive being noticed." },
        { "text": "Everybody does it, so it is fine.", "correct": false, "note": "True and it settles nothing on its own — plenty of common things are still wrong." },
        { "text": "You did understand it by the time you said it.", "correct": false, "note": "Good, and the worry is about the route rather than the understanding." },
        { "text": "The alternative was silence, not honesty.", "correct": true, "note": "Nobody wanted you confused as a gesture of sincerity. Reading up beforehand is the definition of being prepared." }
      ]
    },
    {
      "situation": "Somebody asks a follow-up you cannot answer.",
      "prompt": "What do you say?",
      "options": [
        { "text": "I have only just read about it, so I am not sure.", "correct": true, "note": "An entirely normal sentence. Scaling the claim honestly is the answer to could-not-defend-it, and it costs nothing." },
        { "text": "Guess, and hope it is roughly right.", "correct": false, "note": "This is the version that would actually deserve the guilty feeling." },
        { "text": "Say you will check and come back.", "correct": false, "note": "Fine as far as it goes and it dodges saying the true thing, which was available." },
        { "text": "Admit you looked it up last night.", "correct": false, "note": "Honest, and it makes the source the subject when the information was the contribution." }
      ]
    }
  ]
}$j$::jsonb);
