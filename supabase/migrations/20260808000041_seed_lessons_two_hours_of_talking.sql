-- The first date, track 2: Two hours of talking.
--
-- Four free drills and one scene. The scene is callbacks, because it is the
-- only move here that cannot be rehearsed against a single beat — you cannot
-- bring back something they said earlier unless somebody has said several
-- things and some time has passed.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'the-conversation'),
  1,
  'The first ten minutes are supposed to be awkward',
  $md$The opening of a first date is uncomfortable, and the single most useful thing to know about it is that this is structural rather than personal.

Two people who have never met, who both know exactly what this is, with no shared context and nothing to do together, are going to be awkward for a few minutes. That is a description of the situation. The other person is feeling precisely the same thing, at the same time, and is equally convinced it is their fault.

The damage comes from misreading it as a verdict. People conclude at minute six that there is nothing here and then spend ninety minutes politely confirming a judgement they made before anything had a chance to start. Chemistry at minute one is rare. Chemistry at minute twenty is completely normal, and it is what most good relationships actually began as.

**The move:** say it out loud, and give it twenty minutes before you decide anything.

Naming it is the safest joke available, because it is a joke about a situation you are both in rather than about either of you. *This bit is always slightly strange* gets a laugh close to every time — not because it is funny, but because it is true and because somebody was brave enough to say it first, which is itself a small relief.

Two mechanical things help. Decide the greeting in advance — hug, handshake, or neither — so you are not negotiating it in real time; everybody has had a bad greeting and nobody has ever thought about it again. And get the logistics out of the way fast: drinks, coats, where to sit. It is not conversation and is not meant to be, and once it is done you are two people at a table rather than two people arriving.

If you keep one thing: the first ten minutes are not the date. Almost nobody knows that, and it is the reason a lot of good evenings were abandoned at minute six.$md$,
  $j$[
    {
      "situation": "Four minutes in and it feels stilted.",
      "line": "This bit is always slightly strange, isn't it.",
      "why": "A joke about the situation you are both in rather than about either of you. It lands nearly every time, because it is true and because somebody said it first."
    },
    {
      "situation": "Minute six, and you have privately concluded there is nothing here.",
      "line": "(give it twenty)",
      "why": "Chemistry at minute one is rare and chemistry at minute twenty is normal. Deciding early means spending ninety minutes confirming a verdict rather than finding out."
    },
    {
      "situation": "You are standing there deciding whether to hug them.",
      "line": "(pick one and commit)",
      "why": "Everybody has had a bad greeting and nobody has ever thought about it again. Negotiating it in real time is the only version that is genuinely awkward."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is the opening awkward?",
      "options": [
        { "text": "Because you are nervous.", "correct": false, "note": "You are, and so are they, and it would still be awkward if neither of you were." },
        { "text": "Because you have not found a subject yet.", "correct": false, "note": "A symptom. Subjects are not scarce; the situation is what has not settled." },
        { "text": "Because two strangers with no shared context and high stakes have nothing to do together.", "correct": true, "note": "It is a description of the situation rather than a verdict on either person, and the other one is equally convinced it is their fault." },
        { "text": "Because first impressions matter so much.", "correct": false, "note": "They matter less than people think, and believing this is what turns ten awkward minutes into a performance." }
      ],
      "explain": "Structural, not personal. Both of you are having the same experience."
    },
    {
      "prompt": "What does concluding early actually cost you?",
      "options": [
        { "text": "Ninety minutes spent confirming a verdict.", "correct": true, "note": "You stop trying, they feel it, and the evening obligingly becomes the thing you decided at minute six." },
        { "text": "Nothing — you saved yourself an evening.", "correct": false, "note": "You were always staying the two hours. The only question was whether they were any good." },
        { "text": "A second date you did not want anyway.", "correct": false, "note": "You do not yet know whether you wanted it, which is the entire point of the twenty minutes." },
        { "text": "Your confidence for the next one.", "correct": false, "note": "Real and downstream. The immediate cost is the rest of this evening." }
      ],
      "explain": "Chemistry at minute twenty is the normal case, not the exception."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "waited", "label": "Gave it twenty minutes", "description": "Did not decide during the opening." },
      { "key": "named_it", "label": "Named the awkwardness", "description": "Said the shared thing out loud rather than pushing through it." },
      { "key": "logistics", "label": "Got the mechanics done", "description": "Dealt with drinks and seats quickly rather than treating it as conversation." },
      { "key": "no_performance", "label": "Did not perform through it", "description": "Let it be briefly uncomfortable instead of filling it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Four minutes in. Drinks are on the table, the coats are dealt with, and there has just been a pause slightly longer than either of you wanted.",
    "partner": {
      "name": "Robin",
      "role": "the person you are on a date with",
      "personality": "Equally uncomfortable and hiding it slightly worse. Relaxes enormously the moment somebody admits the situation is strange.",
      "mood": "Nervous, pleased to be here.",
      "openness": 4
    },
    "opening_beat": "\"...so. Yes. Here we are.\" A pause.",
    "success_looks_like": "The user names the awkwardness rather than performing through it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Relax visibly and warm up if the user acknowledges the situation.",
      "Stay stiff and over-polite if the user tries to power through with enthusiasm.",
      "Never name the awkwardness yourself."
    ]
  }$j$::jsonb,
  $md$Today, name one awkward moment out loud instead of pushing through it. Log what you said and what happened next.$md$
),
(
  (select id from public.skills where slug = 'the-conversation'),
  2,
  'React, do not report',
  $md$You have met this failure twice already in this app, and here it has no rescue. On a date no colleague joins in, no queue moves you on, and nothing ends it — so an interview does not fade politely, it sits there for two hours.

The shape is always the same. What do you do, where did you grow up, any brothers or sisters, how long have you lived here. Both of you are being perfectly pleasant. Nothing is going wrong. And at the end you know a great deal about somebody you have no feeling about whatsoever.

**The move:** answer, then say what you actually think about your own answer.

The fact is the raw material and the reaction is the content. *I grew up in Leeds* is a data point. *I grew up in Leeds and I have complicated feelings about how much I miss it* is a person — and only one of those is something anybody can respond to, agree with, or like.

It is worth being honest about why the fact-only version is so tempting: a fact cannot be judged. Nobody dislikes you for where you were born. An opinion, a feeling, a thing you find annoying — those can all be met with a blank look, and avoiding that possibility is precisely what makes somebody impossible to feel anything about.

Small stories do the same work with less exposure. *There was a period where I tried to like running* invites something back, takes thirty seconds, and requires nothing clever. You already have hundreds of them and none of them need to be interesting on paper.

And do not mirror the question straight back. *What about you?* keeps the questionnaire running, and two people can trade it all evening while learning nothing at all.

If you keep one thing: facts are what you offer when you are afraid of being disliked, and they are the reason nobody feels anything either way.$md$,
  $j$[
    {
      "situation": "\"So what do you do?\"",
      "line": "I do the accounts for a building firm — which is much more gossip than you would expect.",
      "why": "The fact, then the reaction. The second half is the only part that is answerable, and the only part that says anything about what you are like."
    },
    {
      "situation": "You have answered and are about to say what about you.",
      "line": "(that keeps the questionnaire running)",
      "why": "Two people can trade the same six questions all evening and learn nothing. React instead, and let them react to that."
    },
    {
      "situation": "You want to say something but nothing feels interesting enough.",
      "line": "There was a whole period where I tried to like running.",
      "why": "A small story needs nothing clever, takes thirty seconds, and invites something back. It does not have to be interesting on paper."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is the fact-only answer so tempting?",
      "options": [
        { "text": "It is quicker.", "correct": false, "note": "Speed is not what makes it attractive, and the interview version is often slower overall." },
        { "text": "A fact cannot be judged.", "correct": true, "note": "Nobody dislikes you for where you were born. An opinion can be met with a blank look, and avoiding that is exactly what makes somebody impossible to feel anything about." },
        { "text": "It is what you have been asked.", "correct": false, "note": "It is, and the question is an opening rather than a form to complete." },
        { "text": "It keeps things light.", "correct": false, "note": "It keeps things empty, which feels like light for about twenty minutes." }
      ],
      "explain": "The safety is the problem. Nothing that cannot be disliked can be liked either."
    },
    {
      "prompt": "What is the smallest thing that fixes it?",
      "options": [
        { "text": "Asking better questions.", "correct": false, "note": "Better questions produce a better interview. The format is what needs changing." },
        { "text": "Talking about something more unusual.", "correct": false, "note": "Aiming at unusual produces the polished anecdote, which is effortful and lands worse than an ordinary opinion." },
        { "text": "Being funnier.", "correct": false, "note": "Not available on demand, and not what is missing. What is missing is you having a view." },
        { "text": "Saying what you think about your own answer.", "correct": true, "note": "One addition converts every dull exchange. The fact is raw material; the reaction is the content." }
      ],
      "explain": "Answer, then react to your own answer. That is the whole move."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "reacted", "label": "Added a reaction", "description": "Said what they thought about their own answer." },
      { "key": "no_mirror", "label": "Did not mirror the question", "description": "Avoided handing the same question straight back." },
      { "key": "specific", "label": "Was specific", "description": "Named an actual feeling or opinion rather than gesturing at having one." },
      { "key": "light", "label": "Kept it short", "description": "A sentence, not an account." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Twenty minutes in. It has been friendly, correct and entirely flat — jobs, areas, how long you have each lived here.",
    "partner": {
      "name": "Robin",
      "role": "the person you are on a date with",
      "personality": "Perfectly nice and stuck in interview mode. Keeps asking factual questions until somebody says something with a view in it, then comes alive.",
      "mood": "Pleasant, quietly bored, could not say why.",
      "openness": 4
    },
    "opening_beat": "\"So what do you do?\"",
    "success_looks_like": "The user answers and adds a real reaction rather than mirroring the question.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer a mirrored question with another factual question, keeping the interview going.",
      "Come alive and react properly the moment the user offers an opinion or a feeling.",
      "Never volunteer an opinion of your own first."
    ]
  }$j$::jsonb,
  $md$Today, answer one question and then say what you actually think about your own answer. Log the fact and the reaction.$md$
),
(
  (select id from public.skills where slug = 'the-conversation'),
  3,
  'How much of yourself',
  $md$There are two ways to get this wrong and a quiet person can manage both in one evening.

The undershare is by far the more common, and it is dangerous because it is disguised as a virtue. You ask good questions, you listen well, you are genuinely interested — and you go home having said almost nothing about yourself. It reads as modesty from inside. From the other side of the table it reads as somebody who is not there, and a person who cannot be found cannot be liked. Asking all the questions is not generosity; it is the most socially acceptable way to hide.

The overshare is the same person two drinks later, when the dam goes and twenty minutes of something heavy arrives at a stranger who has no idea what to do with it. It is usually not recklessness. It is the pressure of having said nothing for an hour finding the first available exit.

**The move:** volunteer one real thing early, unprompted.

Not a confession. A preference, an embarrassment, something you care about more than is reasonable. *I have strong opinions about how this place lays out its menu.* *I am genuinely bad at this and it takes me about an hour to be normal.* Small, true, and offered rather than extracted — which is what sets the depth for the rest of the evening and quietly gives them permission to do the same.

Then match their depth rather than leading it. Disclosure is a ladder in exactly the way touch is: one rung, see what comes back, then the next. The overshare is skipping four rungs at once, and it feels to the other person like being handed something they did not agree to hold.

The heavy things are not forbidden, they are early. If an ex or a bad year comes up honestly, one sentence and move on — the mistake is never the mention, it is the twenty minutes.

If you keep one thing: say one true thing about yourself before anybody asks. It is the cheapest way to stop being a very pleasant stranger.$md$,
  $j$[
    {
      "situation": "You have asked six good questions and said nothing about yourself.",
      "line": "(that is not listening, it is hiding)",
      "why": "It reads as modesty from inside and as absence from the other side of the table. A person who cannot be found cannot be liked."
    },
    {
      "situation": "Ten minutes in, nobody has asked you anything personal.",
      "line": "I am genuinely bad at this, by the way — it takes me about an hour to be normal.",
      "why": "Small, true, and offered rather than extracted. It sets the depth and gives them permission to do the same."
    },
    {
      "situation": "The subject has landed on your worst year and you are three minutes in.",
      "line": "(one sentence, then move)",
      "why": "The mistake is never the mention, it is the twenty minutes. Heavy things are not forbidden, they are early."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is the undershare the more dangerous one?",
      "options": [
        { "text": "It is disguised as being a good listener.", "correct": true, "note": "It reads as modesty from inside and as absence from the other side, so nothing ever prompts you to correct it. Asking all the questions is the most socially acceptable way to hide." },
        { "text": "It happens more often.", "correct": false, "note": "It does, and frequency is not what makes it hard to catch." },
        { "text": "It makes the other person do all the work.", "correct": false, "note": "True and secondary — plenty of people enjoy talking. The cost is that you were never there to be liked." },
        { "text": "It looks like you are not interested.", "correct": false, "note": "It usually looks like the opposite, which is exactly why nobody flags it." }
      ],
      "explain": "A very pleasant stranger is still a stranger."
    },
    {
      "prompt": "What causes the overshare?",
      "options": [
        { "text": "Alcohol.", "correct": false, "note": "The timing, not the cause. Two drinks lowers the wall that an hour of silence had already put pressure on." },
        { "text": "Wanting to seem interesting.", "correct": false, "note": "That produces the polished anecdote, which is a different failure and a quieter one." },
        { "text": "Trusting somebody too quickly.", "correct": false, "note": "How it looks afterwards. In the moment it is rarely a decision about them at all." },
        { "text": "An hour of having said nothing, finding the first exit.", "correct": true, "note": "It is the same person as the undershare, later. Volunteering something small early is what stops the pressure building." }
      ],
      "explain": "Both failures have one fix: one real thing, early, unprompted."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "volunteered", "label": "Volunteered something", "description": "Offered a real thing without being asked." },
      { "key": "small", "label": "Kept it small", "description": "A preference or an embarrassment rather than a confession." },
      { "key": "matched", "label": "Matched their depth", "description": "Went one rung rather than four." },
      { "key": "moved_on", "label": "Moved on from the heavy thing", "description": "One sentence, not twenty minutes." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Twenty-five minutes in. You have asked a lot of questions, they have answered them all, and they know essentially nothing about you.",
    "partner": {
      "name": "Robin",
      "role": "the person you are on a date with",
      "personality": "Happy to answer questions indefinitely and increasingly aware that this is one-sided. Warms up immediately when the user offers something unprompted.",
      "mood": "Enjoying it and slightly puzzled.",
      "openness": 4
    },
    "opening_beat": "\"...anyway, that is probably more than you wanted about my flat. You are very good at asking questions, you know.\"",
    "success_looks_like": "The user volunteers something real about themselves without being asked.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer any question fully and then return the attention to the user.",
      "Respond warmly and reciprocate when the user offers something about themselves.",
      "Never ask the user a direct question about their life."
    ]
  }$j$::jsonb,
  $md$Today, volunteer one true thing about yourself before anybody asks for it. Log what you said.$md$
),
(
  (select id from public.skills where slug = 'the-conversation'),
  4,
  'Let it wander, and let it stop',
  $md$Two hours is longer than any conversation you have planned, which is fortunate, because the parts worth having are the ones neither of you planned.

**The move:** let the subject change without permission, and let the pauses happen.

Wandering first. Good conversation moves by association, and the best twenty minutes of a good first date are almost always somewhere neither of you could have predicted at the start — a tangent off a tangent, arrived at by accident. What kills it is steering: noticing you have drifted and dragging things back to a proper topic, which is what somebody does when they think a date has an agenda. It does not. Nothing has to be covered.

The related mistake is the interesting-topic hunt, where you audition subjects looking for one that lands. It is exhausting to do and visible from outside, and it treats the other person as a room to be worked rather than somebody to talk to.

Then the pauses. Two hours cannot be continuous speech and was never going to be. A gap where you both drink something is not a failure state, it is what a conversation between two relaxed people actually sounds like — and the instinct to fill every one of them is the single most tiring thing you can do to yourself across an evening.

Filling them is also counterproductive in a specific way: somebody who never lets a silence sit is somebody the other person cannot get a word into. Some of the best things people say arrive in the second where nobody was talking.

If a pause genuinely goes on too long, the room is right there. Something about the place, the drink, the people at the next table. That is not small talk failure, it is what the venue was chosen for.

If you keep one thing: nothing has to be covered, and nobody is timing the gaps. Both of those take more weight off two hours than any technique in this track.$md$,
  $j$[
    {
      "situation": "You have drifted a long way from where you started.",
      "line": "(let it go — that is the good part)",
      "why": "The best twenty minutes of a good first date are almost always somewhere neither of you planned. Steering back is what somebody does who thinks a date has an agenda."
    },
    {
      "situation": "There has been a four-second silence.",
      "line": "(that is what two relaxed people sound like)",
      "why": "Filling every pause is the most tiring thing you can do across two hours, and it leaves the other person no way in."
    },
    {
      "situation": "The pause has genuinely gone on too long.",
      "line": "(use the room)",
      "why": "Something about the place, the drink, the people at the next table. That is exactly what somewhere with a bit going on was chosen for."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why not steer back to a proper subject?",
      "options": [
        { "text": "It makes you look disorganised.", "correct": false, "note": "Nobody is assessing the structure of the evening, and worrying that they are is the problem." },
        { "text": "You might not get back to it.", "correct": false, "note": "You will not, and nothing is lost. Nothing had to be covered." },
        { "text": "There is no agenda, and the tangents are the good part.", "correct": true, "note": "Good conversation moves by association. Steering is what somebody does who believes the date has topics to get through." },
        { "text": "It interrupts them.", "correct": false, "note": "A side effect rather than the reason, and steering is usually done politely at a natural gap." }
      ],
      "explain": "Nothing has to be covered. The tangent off the tangent is where it gets good."
    },
    {
      "prompt": "What does filling every silence cost?",
      "options": [
        { "text": "It makes you seem nervous.", "correct": false, "note": "It can, and how it looks is the smaller half of it." },
        { "text": "Nothing — it keeps things moving.", "correct": false, "note": "It keeps you talking, which is not the same as it going well." },
        { "text": "You run out of things to say.", "correct": false, "note": "You rarely do. What runs out is your energy, at about the ninety-minute mark." },
        { "text": "It exhausts you, and it leaves them no way in.", "correct": true, "note": "Some of the best things people say arrive in the second where nobody was talking, and somebody who never lets a gap sit never hears them." }
      ],
      "explain": "A pause is what two relaxed people sound like. Nobody is timing it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "wandered", "label": "Let it wander", "description": "Followed the tangent rather than steering back." },
      { "key": "allowed_pauses", "label": "Let pauses happen", "description": "Did not fill every silence." },
      { "key": "no_auditioning", "label": "Did not audition topics", "description": "Talked rather than hunting for something that lands." },
      { "key": "used_the_room", "label": "Used the room when needed", "description": "Reached for what was actually around rather than forcing a subject." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "An hour in. It has been going well and you have just come to the end of a long tangent about something neither of you expected to discuss.",
    "partner": {
      "name": "Robin",
      "role": "the person you are on a date with",
      "personality": "Comfortable with silence and follows tangents happily. Becomes noticeably more formal when steered back to an earlier subject.",
      "mood": "Relaxed, enjoying it.",
      "openness": 4
    },
    "opening_beat": "\"...I have genuinely never said any of that out loud before.\" A pause, and neither of you fills it.",
    "success_looks_like": "The user lets the pause sit and follows where the conversation actually went.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Let silences run for a beat before speaking, and describe them plainly.",
      "Become more formal and brief if the user drags the subject back to something earlier.",
      "Never rescue a silence yourself in the first few seconds."
    ]
  }$j$::jsonb,
  $md$Today, let one silence sit instead of filling it. Log how long it lasted and what came next.$md$
),
(
  (select id from public.skills where slug = 'the-conversation'),
  5,
  'Bring something back',
  $md$This is the cheapest warmth available anywhere in this app, and it costs nothing except having been paying attention.

**The move:** bring back something they said earlier, later.

*You were right about the thing with your sister, by the way.* *Is this the coffee you were complaining about?* *So did the flat ever get fixed?* None of it is clever. What it does is tell somebody that what they said an hour ago was worth keeping — which is a thing almost nobody does for anybody, and which lands far harder than any compliment you could construct.

It works because it cannot be faked. A compliment is available to anybody at any moment, so it carries very little information. A callback proves you were listening an hour ago, and there is no way to produce one without having done that. It is evidence rather than a claim, which is the same reason a specific compliment beats a general one everywhere else in this curriculum.

It is also, usefully, the single best tool for a quiet person, because it requires none of the things quiet people find hard. It does not need you to be quick, funny, or to have a story. It needs you to have listened, which you were doing anyway — often better than the person doing most of the talking.

Practically: the good ones are small. An unfinished thread, something they were annoyed about, a thing they said they might do. Whole subjects reopened wholesale feel like an agenda; a detail feels like affection.

And it is the natural bridge to what comes next. The plan you propose at the end of the evening should almost always be a callback — the place they mentioned, the thing they said they had never tried. That is the whole of the next track, and it starts here, with having heard it.

If you keep one thing: the thing they said forty minutes ago is worth more than anything you could think of now.$md$,
  $j$[
    {
      "situation": "They mentioned a running argument with their sister an hour ago.",
      "line": "So who won, in the end? With your sister.",
      "why": "It proves you were listening an hour ago, which is evidence rather than a claim — and there is no way to fake it."
    },
    {
      "situation": "You want to say something warm and nothing is coming.",
      "line": "(use something they said earlier)",
      "why": "It needs none of the things quiet people find hard. Not quick, not funny, no story — just having listened, which you were doing anyway."
    },
    {
      "situation": "You are looking for something to propose at the end.",
      "line": "(the place they mentioned an hour ago)",
      "why": "The best next plan is almost always a callback, which is why this lesson is the bridge to the last track."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does a callback beat a compliment?",
      "options": [
        { "text": "It is more original.", "correct": false, "note": "Usually true and not the mechanism. An unoriginal callback still works." },
        { "text": "Compliments make people uncomfortable.", "correct": false, "note": "Most people take a compliment perfectly happily. The problem is what it proves, which is nothing." },
        { "text": "It cannot be faked.", "correct": true, "note": "A compliment is available to anybody at any moment. A callback is evidence that you were listening an hour ago, and there is no way to produce one without having done it." },
        { "text": "It keeps the conversation going.", "correct": false, "note": "It does, and so does almost anything. The value is what it tells them." }
      ],
      "explain": "Evidence rather than a claim — the same reason specific beats general everywhere else in this app."
    },
    {
      "prompt": "What makes a good one?",
      "options": [
        { "text": "Reopening a subject they clearly enjoyed.", "correct": false, "note": "A whole subject reopened wholesale feels like an agenda. The small version lands better." },
        { "text": "Something they said they were looking forward to.", "correct": false, "note": "Perfectly good, and it is one example of the general rule rather than the rule." },
        { "text": "The most interesting thing they said.", "correct": false, "note": "Interesting is not the test — retrievable and small is. The best ones are frequently trivial." },
        { "text": "A small unfinished detail.", "correct": true, "note": "A thread left hanging, something they were annoyed about, a thing they said they might do. A detail feels like affection; a subject feels like a plan." }
      ],
      "explain": "Small and unfinished. And the one you save for the end becomes the next date."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "brought_back", "label": "Brought something back", "description": "Referred to something said earlier in the evening." },
      { "key": "small", "label": "Kept it small", "description": "A detail rather than a whole subject reopened." },
      { "key": "accurate", "label": "Got it right", "description": "Remembered it accurately enough to prove they were listening." },
      { "key": "saved_one", "label": "Kept one for the end", "description": "Noticed something that could become a plan." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Ninety minutes in. It has gone well, and they have mentioned several things in passing — a sister they argue with, a place near their flat they have never tried, a work thing they were dreading on Monday.",
    "partner": {
      "name": "Robin",
      "role": "the person you are on a date with",
      "personality": "Mentions small things in passing without dwelling on them, and is visibly delighted whenever one is brought back. Never repeats them unprompted.",
      "mood": "Warm, an hour and a half in.",
      "openness": 4
    },
    "opening_beat": "\"Sorry — I have completely lost what we were talking about. What were we on?\"",
    "success_looks_like": "The user brings back something the partner said earlier rather than starting something new.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Mention small things in passing — a sister, a place you have never tried, a thing you are dreading — without dwelling on any of them.",
      "Be visibly pleased and expand happily whenever something you said earlier is brought back.",
      "Never bring your own earlier subjects back yourself."
    ]
  }$j$::jsonb,
  $md$Today, bring back one thing somebody said earlier in a conversation. Log what it was and how they reacted.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('the-conversation', 1, 'choice', $j${
  "beats": [
    {
      "situation": "Four minutes in. Drinks are on the table and there has just been a pause slightly longer than either of you wanted.",
      "prompt": "What do you do?",
      "options": [
        { "text": "Ask another question to get it moving.", "correct": false, "note": "It moves and it does not settle. Questions into an unsettled opening are how the interview starts." },
        { "text": "Raise the energy — be a bit funnier for a minute.", "correct": false, "note": "Effortful and visible, and it leaves them performing back at you for the next twenty minutes." },
        { "text": "Say that this bit is always slightly strange.", "correct": true, "note": "A joke about the situation you are both in rather than about either of you. It lands nearly every time, and it is a relief that somebody said it first." },
        { "text": "Nothing — let it pass on its own.", "correct": false, "note": "It will pass, and naming it is faster and takes the weight off both of you rather than only one." }
      ]
    },
    {
      "situation": "Minute six. It is stilted, they seem nervous, and you are fairly sure there is nothing here.",
      "prompt": "What is that judgement worth?",
      "options": [
        { "text": "Quite a lot — first impressions are usually right.", "correct": false, "note": "About things you can see in a second. Not about whether you would like somebody's company, which takes longer than six minutes." },
        { "text": "Nothing yet — chemistry at minute twenty is the normal case.", "correct": true, "note": "Chemistry at minute one is rare. Deciding now means spending ninety minutes politely confirming a verdict you reached before anything started." },
        { "text": "Something — it is worth staying alert to.", "correct": false, "note": "Staying alert for confirmation is how the ninety minutes gets spent. There is nothing to monitor yet." },
        { "text": "Enough to start planning an early exit.", "correct": false, "note": "You already set a finish time before you came. Using it at minute six is deciding, not leaving." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-conversation', 2, 'line', $j${
  "says": "So what do you do?",
  "model": {
    "line": "I do the accounts for a building firm. It is much more gossip than you would expect, which is the only reason I have stayed.",
    "why": "The fact, then what you actually think about it. The second half is the only part that can be responded to, and the only part that says what you are like."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Put something of yourself in it" },
    { "kind": "forbids_any", "requirement": "Do not hand the same question back",
      "words": ["what about you", "how about you", "and you", "what do you do", "yourself", "your turn"] },
    { "kind": "min_words", "requirement": "More than the job title", "n": 12 },
    { "kind": "max_words", "requirement": "A sentence, not an account", "n": 40 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-conversation', 3, 'line', $j${
  "says": "...anyway, that is probably more than you wanted about my flat. You are very good at asking questions, you know.",
  "model": {
    "line": "I am also genuinely bad at this — it usually takes me about an hour to be a normal person.",
    "why": "Small, true, and offered rather than extracted. It sets the depth for the rest of the evening and quietly gives them permission to do the same."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Say something about you" },
    { "kind": "no_question", "requirement": "Offer, do not ask — you have asked enough" },
    { "kind": "forbids_any", "requirement": "Small and true, not a confession",
      "words": ["my ex", "my therapist", "my divorce", "depression", "died", "my illness", "worst year", "breakdown"] },
    { "kind": "min_words", "requirement": "A real thing, not a deflection", "n": 8 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-conversation', 4, 'choice', $j${
  "beats": [
    {
      "situation": "You are forty minutes in and three tangents away from anything you meant to talk about.",
      "prompt": "What now?",
      "options": [
        { "text": "Bring it back to what they were saying about work.", "correct": false, "note": "Steering. It is what somebody does who believes a date has topics to get through, and it is the thing that kills the good part." },
        { "text": "Carry on down the tangent.", "correct": true, "note": "The best twenty minutes of a good first date are almost always somewhere neither of you planned. Nothing has to be covered." },
        { "text": "Note where you were, so you can return later.", "correct": false, "note": "Holding a thread you intend to resume is a low-level agenda, and it takes attention off what is being said now." },
        { "text": "Check they are still interested in this subject.", "correct": false, "note": "Asking makes it a decision. They are in it with you, which is why you got three tangents deep." }
      ]
    },
    {
      "situation": "A pause. Four seconds, and neither of you has said anything.",
      "prompt": "What is that?",
      "options": [
        { "text": "A warning sign — fill it before it grows.", "correct": false, "note": "Filling every one is the most tiring thing you can do across two hours, and it leaves them no way in." },
        { "text": "An invitation for them to speak.", "correct": false, "note": "Close, and framing it as a tactic keeps you managing the conversation rather than in it." },
        { "text": "Time to change the subject.", "correct": false, "note": "A pause is not the end of a subject. Changing on every gap is the topic hunt, which is visible and exhausting." },
        { "text": "What two relaxed people sound like.", "correct": true, "note": "Two hours cannot be continuous speech. Some of the best things people say arrive in the second where nobody was talking." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('the-conversation', 5, 'scene', $j${}$j$::jsonb);
