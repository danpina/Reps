-- Hard conversations, track 5: Hearing it about yourself.
--
-- The mirror, and the track a shorter version of this topic would cut. A
-- curriculum that teaches somebody to deliver difficult things and never to
-- receive them produces a person who is worse to be close to, which is the
-- opposite of what this app is for.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'hearing-it'),
  1,
  'Three seconds',
  $md$Somebody has just told you something unwelcome about yourself, and your face has already decided what to do about it.

The defensive reflex fires before you have finished processing the sentence. It is fast, physical, and it is not a character flaw — it is what happens when something arrives that threatens the account you have of yourself. What it produces is an explanation, a counter-example, or the context you feel is missing, and all three are attempts to make the criticism untrue rather than to understand it.

**The move:** three seconds of nothing, then speak.

That is the entire technique and it is more effective than any phrase. Three seconds is long enough for the reflex to pass, and it is visible from the outside as somebody taking it seriously — which is worth more than anything you could have said in that window anyway.

What the reflex costs is not the argument, and this is the part people underrate. It is that people learn. Somebody who has been defended at once, twice, three times does not raise the next thing — and the version of you that is hard to tell things to ends up being told nothing, which from inside feels exactly like having no problems. It is one of the few situations where the feedback going quiet is the bad outcome rather than the good one.

Two things that help mechanically. Physically stop — hands still, no leaning forward — because the body starts the defence before the mouth does. And notice the heat, name it privately, and let it be there; the aim is not to stop feeling defensive, which is not available, but to not act for three seconds while you do.

If something does come out first, it is recoverable. *Sorry — let me start again* is a real sentence and it works, and it is a great deal better than eleven minutes of explaining.

If you keep one thing: three seconds. What you do in them decides whether anybody tells you anything next year.$md$,
  $j$[
    {
      "situation": "They have just said something unwelcome and true.",
      "line": "(three seconds of nothing)",
      "why": "Long enough for the reflex to pass, and visible from outside as somebody taking it seriously — which is worth more than anything you could say in that window."
    },
    {
      "situation": "You have already started explaining.",
      "line": "Sorry — let me start again.",
      "why": "Recoverable, and a great deal better than eleven minutes of context nobody asked for."
    },
    {
      "situation": "Nobody has raised anything with you in two years.",
      "line": "(that may not be good news)",
      "why": "People who have been defended at once stop raising things, and being told nothing feels from inside exactly like having no problems."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does the defensive reflex actually cost?",
      "options": [
        { "text": "You look bad in the moment.", "correct": false, "note": "Mildly, and it is recoverable within the same conversation." },
        { "text": "You lose the argument.", "correct": false, "note": "You frequently win it, which is part of the problem." },
        { "text": "People stop telling you things.", "correct": true, "note": "Somebody defended at once does not raise the next thing, and being told nothing feels from inside exactly like having no problems." },
        { "text": "You miss the useful part.", "correct": false, "note": "True in that conversation, and the durable cost is about all the conversations that then do not happen." }
      ],
      "explain": "It is one of the few cases where the feedback going quiet is the bad outcome."
    },
    {
      "prompt": "What are the three seconds for?",
      "options": [
        { "text": "Working out whether they are right.", "correct": false, "note": "Nowhere near enough time, and it is not required in the room — that is the lesson about taking the time." },
        { "text": "Composing a good response.", "correct": false, "note": "A composed response in three seconds is the reflex with better grammar." },
        { "text": "Showing them you are listening.", "correct": false, "note": "It does read that way, which is a benefit rather than the purpose." },
        { "text": "Letting the reflex pass without acting on it.", "correct": true, "note": "The aim is not to stop feeling defensive, which is not available. It is to not act for three seconds while you do." }
      ],
      "explain": "Stop physically too. The body starts the defence before the mouth does."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "paused", "label": "Paused", "description": "Three seconds before anything came out." },
      { "key": "no_explaining", "label": "Did not explain", "description": "No context, counter-example or correction first." },
      { "key": "still", "label": "Stopped physically", "description": "Did not start the defence with the body." },
      { "key": "recovered", "label": "Recovered if it slipped", "description": "Started again rather than continuing." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A friend has just told you that you talk over people, and that it happened twice last week.",
    "partner": {
      "name": "Sam",
      "role": "a friend who has raised something about you",
      "personality": "Has taken three weeks to work up to this. Retreats and closes down if defended against immediately; opens up and gets specific if given a pause.",
      "mood": "Nervous, sincere.",
      "openness": 4
    },
    "opening_beat": "\"I have wanted to say this for a while — you do talk over people. It happened twice on Thursday.\"",
    "success_looks_like": "The user pauses rather than explaining.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Close down and withdraw the point if you are met with an explanation or a counter-example.",
      "Get more specific and more honest if given a pause.",
      "Never repeat the point after backing away from it."
    ]
  }$j$::jsonb,
  $md$Today, take three seconds before responding to one piece of criticism. Log what you would have said in second one.$md$
),
(
  (select id from public.skills where slug = 'hearing-it'),
  2,
  'Ask for the example',
  $md$Most difficult feedback arrives generalised, and the generalisation is not laziness. It is what happens when somebody has been working up to saying anything for three weeks — the specific instance has softened into a summary by the time it comes out.

*You can be a bit dismissive.* *You do talk over people.* *You are quite hard to reach sometimes.*

**The move:** ask for one example, in order to understand it rather than to test it.

*Can you give me an example?* does three things at once. It converts something unactionable into something you could actually change. It signals that you are taking it seriously, which is the single most encouraging thing you can do for somebody who has just done something difficult. And it usually produces a much more precise version of the complaint, because people are far better at describing an incident than a pattern.

Everything depends on how it is asked, and the difference is audible. Asked to understand, it is an invitation. Asked to litigate — *when? give me one instance* — it is a challenge, and the honest response to a challenge is to produce evidence, at which point you are in a trial rather than a conversation.

The tells for the litigating version are worth knowing because they slip out easily: asking for a date, asking who else was there, and asking for a second example after the first one has been given. That last one is the giveaway. One example is for understanding; two is for building a case about whether it is representative.

And if they cannot produce one, take it seriously anyway. Being unable to name an instance is extremely common and it is not evidence that nothing happened — it means the feeling accumulated. *That is fair, I will keep an eye on it* costs nothing and is almost always the right answer.

If you keep one thing: one example, asked to understand. It is the most useful question available and the easiest one to ask badly.$md$,
  $j$[
    {
      "situation": "\"You can be a bit dismissive sometimes.\"",
      "line": "Can you give me an example? I want to know what it looks like.",
      "why": "Converts something unactionable into something you could change, and signals you are taking it seriously — which is the most encouraging thing available to somebody who just did a hard thing."
    },
    {
      "situation": "You are about to ask when, exactly.",
      "line": "(that is a challenge, and it produces a trial)",
      "why": "Asking for a date, asking who else was there, or asking for a second example are all litigation rather than understanding."
    },
    {
      "situation": "They cannot think of one.",
      "line": "That is fair — I will keep an eye on it.",
      "why": "Being unable to name an instance is extremely common and is not evidence that nothing happened. It means the feeling accumulated."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does feedback arrive generalised?",
      "options": [
        { "text": "People are vague to avoid confrontation.", "correct": false, "note": "Partly, and it makes it sound like a tactic. It is more often what three weeks of working up to it does." },
        { "text": "The specifics have softened into a summary by the time it comes out.", "correct": true, "note": "Which is why one example is worth asking for — people are far better at describing an incident than a pattern." },
        { "text": "They want you to work it out yourself.", "correct": false, "note": "Very rarely. Most people would much prefer to be understood quickly." },
        { "text": "It is easier to argue with a specific.", "correct": false, "note": "That is your incentive rather than theirs, and it is the one this lesson is warning about." }
      ],
      "explain": "One example, asked to understand. It converts a summary back into something actionable."
    },
    {
      "prompt": "What is the tell that you are litigating?",
      "options": [
        { "text": "Asking for a second example.", "correct": true, "note": "One example is for understanding. Two is for testing whether it is representative, and everybody can hear the difference." },
        { "text": "Asking at all.", "correct": false, "note": "Asking is the move. It is how you ask that decides which conversation you are in." },
        { "text": "Asking them to explain what they mean.", "correct": false, "note": "Entirely reasonable, and it is the same request in different words." },
        { "text": "Taking notes.", "correct": false, "note": "Unusual, and if anything it reads as taking it seriously." }
      ],
      "explain": "And if they cannot produce one, take it seriously anyway."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked", "label": "Asked for an example", "description": "Requested a specific instance." },
      { "key": "to_understand", "label": "Asked to understand", "description": "An invitation rather than a challenge." },
      { "key": "one", "label": "Asked for one", "description": "Did not go looking for a second." },
      { "key": "accepted_none", "label": "Took it seriously without one", "description": "Did not treat an absent example as a refutation." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Somebody has told you that you can be dismissive. They have not said when or with whom.",
    "partner": {
      "name": "Sam",
      "role": "a friend who has raised something about you",
      "personality": "Has one specific instance in mind and will describe it if asked warmly. Retreats into vagueness and apology if cross-examined.",
      "mood": "Careful.",
      "openness": 4
    },
    "opening_beat": "\"I do not know. You can just be a bit dismissive sometimes.\"",
    "success_looks_like": "The user asks for an example in a way that invites rather than challenges.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Give the specific instance if asked warmly and once.",
      "Retreat into it does not matter if cross-examined or asked for a second example.",
      "Never volunteer the instance unprompted."
    ]
  }$j$::jsonb,
  $md$Today, ask one person for an example of something they have said about you, in order to understand it. Log what they said.$md$
),
(
  (select id from public.skills where slug = 'hearing-it'),
  3,
  'Take the time',
  $md$There is a right almost nobody uses, and it removes most of the pressure from being criticised: you do not have to have a position in the room.

**The move:** take a day. *Thank you — I want to think about it properly.*

That is a complete and honest response. It is not a dodge, it is not stalling, and it does not concede anything you have not decided. It also happens to be true: you have just been told something about yourself and any assessment made in the following ninety seconds is being made by the part of you that is defending itself.

What it prevents is the two bad instant answers. The premature agreement — *you are completely right, I am sorry* — said to end the discomfort rather than because you have concluded anything, which feels generous and is worthless, because nothing follows from it. And the premature defence, which is the reflex from the first lesson with a full paragraph attached.

Then actually think about it, which is the part that makes the sentence honest. A day is usually enough. Ask whether you can find the instance they described, ask what somebody else would say about the same behaviour, and ask what you would think if you heard it about somebody you knew.

Then come back, and this is what turns the whole thing from a technique into something people trust. *I have thought about it, and you are right about the meetings* — three days later, unprompted — is one of the rarest and most disarming things a person can do. Almost nobody returns to a conversation like this voluntarily.

The version that does not work is *let me think about it* used as an exit, with no return. It is transparent within a fortnight and it is worse than an honest disagreement, because it teaches somebody that raising things with you produces nothing at all.

If you keep one thing: you are allowed a day. Take it, use it, and come back.$md$,
  $j$[
    {
      "situation": "You have just been told something and you do not know what you think.",
      "line": "Thank you — I want to think about it properly.",
      "why": "Complete and honest. Any assessment in the next ninety seconds is being made by the part of you that is defending itself."
    },
    {
      "situation": "You are about to agree with all of it to end the discomfort.",
      "line": "(that feels generous and is worthless)",
      "why": "Nothing follows from an agreement you have not reached. It ends the conversation without producing anything."
    },
    {
      "situation": "Three days later, and you have concluded they were right.",
      "line": "I have thought about it, and you are right about the meetings.",
      "why": "Unprompted, it is one of the rarest and most disarming things a person can do. Almost nobody comes back voluntarily."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is an instant agreement a problem?",
      "options": [
        { "text": "It is dishonest.", "correct": false, "note": "It is usually sincere in the moment, which is what makes it so easy to give." },
        { "text": "It ends the conversation too quickly.", "correct": false, "note": "Ending quickly is fine. What matters is that nothing survives the ending." },
        { "text": "Nothing follows from it.", "correct": true, "note": "It was said to end the discomfort rather than because anything was concluded, so no behaviour changes and the same conversation is needed again in three months." },
        { "text": "They will not believe it.", "correct": false, "note": "They usually do believe it, and are then puzzled when nothing changes." }
      ],
      "explain": "You are allowed a day. Any verdict in ninety seconds is the defence talking."
    },
    {
      "prompt": "What makes the sentence honest?",
      "options": [
        { "text": "Meaning it when you say it.", "correct": false, "note": "Necessary and not sufficient — plenty of sincere intentions produce no return." },
        { "text": "Saying how long you need.", "correct": false, "note": "Helpful, and it is a detail of the promise rather than what keeps it." },
        { "text": "Coming back.", "correct": true, "note": "Used as an exit with no return, it is transparent within a fortnight and worse than an honest disagreement — it teaches somebody that raising things with you produces nothing." },
        { "text": "Thanking them first.", "correct": false, "note": "Good manners, and thanks with no follow-up is exactly the version that fails." }
      ],
      "explain": "Three days later, unprompted, is the rarest version and the one people remember."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "took_time", "label": "Took the time", "description": "Did not produce a verdict in the room." },
      { "key": "no_premature", "label": "Neither agreed nor defended prematurely", "description": "Avoided both instant answers." },
      { "key": "thought", "label": "Actually thought about it", "description": "Checked the instance and the outside view." },
      { "key": "came_back", "label": "Came back", "description": "Returned to it unprompted." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have been told something about yourself that you are not sure about. They are waiting for a response.",
    "partner": {
      "name": "Sam",
      "role": "a friend who has just raised something",
      "personality": "Accepts a request for time gracefully and is visibly relieved by it. Notices, later, whether anybody ever came back.",
      "mood": "Braced for a defence.",
      "openness": 4
    },
    "opening_beat": "\"So — what do you think?\"",
    "success_looks_like": "The user takes the time rather than producing an instant verdict.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Accept a request for time warmly and without pressing.",
      "Respond to an instant agreement with mild scepticism about whether anything will change.",
      "Never let the user off by saying it does not matter."
    ]
  }$j$::jsonb,
  $md$Today, respond to one piece of criticism by taking the time, and then come back to it. Log both halves.$md$
),
(
  (select id from public.skills where slug = 'hearing-it'),
  4,
  'The true ten per cent',
  $md$Most criticism arrives badly framed. It is exaggerated, or it is attached to the wrong instance, or it comes with a motive assigned that is nothing like what you were doing.

And badly framed is not the same as wrong, which is the distinction this lesson is about.

**The move:** find the part that is true, and work on that rather than on the framing.

The framing is the easier target and it is almost always available, which is why it is so tempting. Somebody says *you never listen*, you find the counter-example, and the conversation is now about the word *never* — a conversation you will win, and which leaves the ten per cent that was accurate entirely untouched.

Winning that is worse than losing it. You get to keep the behaviour and you have taught somebody that raising it costs more than it produces.

The useful question, asked privately afterwards, is: *what is the smallest version of this that is true?* Almost always there is one. Not *I never listen* but *I do finish people's sentences when I am excited about something.* That version is small, specific, survivable, and actually changeable, which the exaggerated version was not.

Two things to be honest about, because this is not a rule that everything contains a truth. Some criticism is entirely wrong, and concluding that after genuinely looking is legitimate. And some of it is about the other person rather than about you, which is also real. The test is whether you looked before deciding — most people decide first and then look, and finding nothing takes about four seconds when you already know the answer.

A useful check: has anybody else ever said something similar? Two people independently is very strong evidence, whatever you make of either delivery.

If you keep one thing: separate the ten per cent from the ninety. Arguing with the ninety is easy, satisfying, and the reason nothing changes.$md$,
  $j$[
    {
      "situation": "\"You never listen to anyone.\"",
      "line": "(what is the smallest true version?)",
      "why": "Not I never listen, but I do finish people's sentences when I am excited. Small, specific, survivable, and actually changeable."
    },
    {
      "situation": "You have found the counter-example that disproves never.",
      "line": "(you will win that, and keep the behaviour)",
      "why": "Winning the framing leaves the accurate part untouched and teaches somebody that raising things costs more than it produces."
    },
    {
      "situation": "Somebody else said something similar last year.",
      "line": "(two people independently is strong evidence)",
      "why": "Whatever you make of either delivery. Independent agreement is the check that survives a badly framed version."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is winning the framing argument the worst outcome?",
      "options": [
        { "text": "It makes you look pedantic.", "correct": false, "note": "It does, and how it looks is not what costs you." },
        { "text": "You keep the behaviour and they stop raising things.", "correct": true, "note": "The ten per cent that was accurate is untouched, and you have demonstrated that raising something with you costs more than it produces." },
        { "text": "It escalates the conversation.", "correct": false, "note": "It usually ends it, cleanly, in your favour — which is exactly the problem." },
        { "text": "They will bring it up again.", "correct": false, "note": "They will not, and that is the cost rather than a consolation." }
      ],
      "explain": "Badly framed is not the same as wrong."
    },
    {
      "prompt": "What is the test for whether you actually looked?",
      "options": [
        { "text": "Whether you found something.", "correct": false, "note": "Some criticism is genuinely wrong, and finding nothing is a legitimate outcome of an honest look." },
        { "text": "Whether you agreed with them.", "correct": false, "note": "Agreement is not the goal. Honest examination is, and it can end in disagreement." },
        { "text": "Whether you looked before deciding.", "correct": true, "note": "Most people decide first and then look, and finding nothing takes about four seconds when you already know the answer." },
        { "text": "How long you thought about it.", "correct": false, "note": "Duration is a poor proxy — you can think about something for a week while defending it the whole time." }
      ],
      "explain": "And check whether anybody else has ever said something similar."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "found_it", "label": "Found the true part", "description": "Located the smallest accurate version." },
      { "key": "no_framing_fight", "label": "Did not argue the framing", "description": "Left the exaggeration alone." },
      { "key": "looked_first", "label": "Looked before deciding", "description": "Examined it honestly rather than confirming." },
      { "key": "checked", "label": "Checked for a pattern", "description": "Asked whether anybody else had said it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Somebody has just told you that you never listen to anybody. It is exaggerated and there is something in it.",
    "partner": {
      "name": "Sam",
      "role": "a friend who has said something exaggerated and partly true",
      "personality": "Will defend the exaggeration if it is attacked, and get much more precise and reasonable if the true part is engaged with.",
      "mood": "Frustrated.",
      "openness": 4
    },
    "opening_beat": "\"You never listen to anyone. You have not listened to me all year.\"",
    "success_looks_like": "The user engages with the accurate part rather than the overstatement.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Defend the exaggeration for as long as it is challenged.",
      "Become far more specific and reasonable if the true part is taken seriously.",
      "Never concede that the overstatement was unfair."
    ]
  }$j$::jsonb,
  $md$Today, take one criticism you dismissed and write down the smallest version of it that is true. Log that version.$md$
),
(
  (select id from public.skills where slug = 'hearing-it'),
  5,
  'Apologising without but',
  $md$You have thought about it and you were wrong. What you say now is worth getting right, because a bad apology is worse than none — it asks for the credit while leaving the other person with the original problem and a new irritation.

**The move:** name the thing, say what changes, and leave *but* out entirely.

*I have thought about it, and you are right about the meetings. I did talk over you and I am going to stop.* Twenty words, and there is nothing in it to argue with.

*But* is the word to watch, because everything after it deletes everything before it. *I am sorry, but I was under a lot of pressure* is not an apology with context, it is a defence with an apology on the front, and both of you know which half was the point. The same applies to its relatives: *although*, *to be fair*, and the especially common *I am sorry if you felt* — which apologises for their reaction rather than for anything you did.

Name the actual thing rather than the category. *Sorry for how I spoke to you* is vague enough to be about anything; *I talked over you twice in that meeting and it was rude* is unmistakable, and the specificity is most of what makes it land — it proves you understood rather than that you wanted the subject closed.

Say what changes, if anything does. An apology with a next step is a different object from one without, and it is the difference between something happening and something being said.

Two things to leave out. Do not ask for reassurance — *are we okay?* converts your apology into a request for them to look after you. And do not over-apologise: repeating it three times makes it their job to relieve you of it, which is the same manoeuvre in a kinder register.

Then let it be received however it is received. They are not required to be gracious about it, and an apology delivered on condition of a warm response was a negotiation.

If you keep one thing: no *but*. That single word is the difference between an apology and a defence.$md$,
  $j$[
    {
      "situation": "You have concluded you were wrong.",
      "line": "You are right about the meetings. I did talk over you, and I am going to stop.",
      "why": "The thing named, what changes, and nothing to argue with. Twenty words."
    },
    {
      "situation": "You are about to explain the pressure you were under.",
      "line": "(everything after but deletes everything before it)",
      "why": "It is a defence with an apology on the front, and both of you know which half was the point."
    },
    {
      "situation": "You have said it and the silence is uncomfortable.",
      "line": "(do not ask if you are okay)",
      "why": "It converts your apology into a request for them to look after you, which is the same manoeuvre as over-apologising in a kinder register."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does but do?",
      "options": [
        { "text": "Adds necessary context.", "correct": false, "note": "It is presented as context and it functions as a defence — which is why it is placed after the apology rather than before it." },
        { "text": "Deletes everything before it.", "correct": true, "note": "I am sorry, but I was under pressure is a defence with an apology on the front, and both people know which half was the point." },
        { "text": "Softens the admission.", "correct": false, "note": "It does not soften it, it cancels it. Softening would leave something behind." },
        { "text": "Makes it sound reluctant.", "correct": false, "note": "Tone rather than mechanism, and a cheerful but does exactly the same thing." }
      ],
      "explain": "And watch its relatives: although, to be fair, and I am sorry if you felt."
    },
    {
      "prompt": "Why name the specific thing?",
      "options": [
        { "text": "It sounds more sincere.", "correct": false, "note": "How it sounds, and sincerity can be perfectly present in a vague apology that still does not land." },
        { "text": "It proves you understood.", "correct": true, "note": "Sorry for how I spoke could be about anything. I talked over you twice in that meeting is unmistakable, and the specificity is most of what makes it work." },
        { "text": "It stops them bringing it up again.", "correct": false, "note": "A management goal, and treating an apology as a way to close a subject is what produces the vague version." },
        { "text": "It shows you were listening.", "correct": false, "note": "Close, and it undersells it — understanding is more than having heard." }
      ],
      "explain": "Then say what changes. An apology with a next step is a different object."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_but", "label": "No but", "description": "Nothing after the apology that undid it." },
      { "key": "specific", "label": "Named the actual thing", "description": "Not a category or a general regret." },
      { "key": "what_changes", "label": "Said what changes", "description": "Attached a next step." },
      { "key": "no_reassurance", "label": "Asked for nothing", "description": "No are we okay, no repetition." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Three days after they raised it. You have thought about it and they were right.",
    "partner": {
      "name": "Sam",
      "role": "a friend who raised something about you three days ago",
      "personality": "Receives a clean apology quietly and well, without making it easy. Becomes cool at any explanation attached to it.",
      "mood": "Neutral, waiting.",
      "openness": 4
    },
    "opening_beat": "\"You said you wanted to come back to it.\"",
    "success_looks_like": "The user apologises specifically, with no but and no request for reassurance.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Go cool and brief at any explanation, justification or context.",
      "Receive a clean apology quietly and seriously, without reassuring the user.",
      "Never say it does not matter or that it was fine."
    ]
  }$j$::jsonb,
  $md$Today, apologise for one thing with no but, no explanation, and no request for reassurance. Log what you said.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('hearing-it', 1, 'choice', $j${
  "beats": [
    {
      "situation": "\"You do talk over people. It happened twice on Thursday.\" You can feel the heat arriving and you have a counter-example ready.",
      "prompt": "What do you do with the next three seconds?",
      "options": [
        { "text": "Explain what was happening on Thursday.", "correct": false, "note": "The reflex with a paragraph attached. It is an attempt to make the criticism untrue rather than to understand it." },
        { "text": "Agree immediately so they know you have heard.", "correct": false, "note": "Also fast, also not a conclusion. Instant agreement ends the discomfort and nothing follows from it." },
        { "text": "Nothing. Sit with it and let the reflex pass.", "correct": true, "note": "Three seconds is enough for the heat to pass and reads from outside as somebody taking it seriously — which is worth more than anything you could say in that window." },
        { "text": "Ask why they waited until now to say it.", "correct": false, "note": "A counter-attack, and it answers a question about their behaviour rather than yours." }
      ]
    },
    {
      "situation": "Nobody has raised anything with you at work or at home for about two years.",
      "prompt": "What is that most likely to mean?",
      "options": [
        { "text": "Things are going well.", "correct": false, "note": "Possible, and it is the reading that makes the alternative invisible. Two years is a long time for nothing to be worth mentioning." },
        { "text": "People have learned it is not worth it.", "correct": true, "note": "Somebody defended at once does not raise the next thing, and being told nothing feels from inside exactly like having no problems." },
        { "text": "You have improved.", "correct": false, "note": "Improvement usually gets mentioned. Silence is a different signal from praise." },
        { "text": "Nothing — feedback is rare anyway.", "correct": false, "note": "It is rare partly because of how it tends to be received, which makes this circular rather than reassuring." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('hearing-it', 2, 'line', $j${
  "says": "I do not know. You can just be a bit dismissive sometimes.",
  "model": {
    "line": "Can you give me an example? I would like to know what it actually looks like.",
    "why": "Asked to understand rather than to test. It converts something unactionable into something changeable, and it tells somebody who has just done a hard thing that it was worth doing."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Ask for the example" },
    { "kind": "forbids_any", "requirement": "An invitation, not a cross-examination",
      "words": ["when exactly", "who else", "give me one", "prove", "any other", "another example", "are you sure", "i do not think i"] },
    { "kind": "max_questions", "requirement": "One question — not a list", "n": 1 },
    { "kind": "max_words", "requirement": "Short and open", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('hearing-it', 3, 'line', $j${
  "says": "So — what do you think?",
  "model": {
    "line": "Thank you for saying it. I want to think about it properly and come back to you — can I do that this week?",
    "why": "A complete and honest answer that concedes nothing undecided. Any verdict produced in the next ninety seconds is being made by the part of you that is defending itself."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No verdict in the room, in either direction",
      "words": ["you are completely right", "i am so sorry", "that is not fair", "i do not think that is", "i disagree", "you are wrong", "totally agree"] },
    { "kind": "contains_any", "requirement": "Say you will come back to it",
      "words": ["think about it", "come back", "sit with", "properly", "this week", "tomorrow", "few days"] },
    { "kind": "max_words", "requirement": "Two sentences", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('hearing-it', 4, 'choice', $j${
  "beats": [
    {
      "situation": "\"You never listen to anyone. You have not listened to me all year.\" It is exaggerated, and there is something in it.",
      "prompt": "Where do you put your attention?",
      "options": [
        { "text": "On never — it is demonstrably untrue.", "correct": false, "note": "You will win that, keep the behaviour, and teach them that raising something costs more than it produces." },
        { "text": "On all year — you can name three times you did listen.", "correct": false, "note": "The same argument in a different word. Both are the framing rather than the substance." },
        { "text": "On the smallest version that is true.", "correct": true, "note": "Not I never listen, but I do finish people's sentences when I am excited. Small, specific, survivable and actually changeable." },
        { "text": "On why they are so angry about it.", "correct": false, "note": "It moves the subject to their state, which is the counter-attack from the other side of the table." }
      ]
    },
    {
      "situation": "You have looked at it honestly and you genuinely do not think it is true.",
      "prompt": "Is that allowed?",
      "options": [
        { "text": "No — if somebody says it, there is something in it.", "correct": false, "note": "A rule that sounds humble and is not true. Some criticism is entirely wrong." },
        { "text": "Yes, if you looked before you decided.", "correct": true, "note": "Most people decide first and then look, and finding nothing takes about four seconds when you already know the answer. The order is the test." },
        { "text": "Yes — you know yourself best.", "correct": false, "note": "You have the worst view of this particular thing, which is why it had to be told to you." },
        { "text": "Only if you can prove it.", "correct": false, "note": "Nothing here needs proving to anybody. This is a private conclusion about what to work on." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('hearing-it', 5, 'line', $j${
  "says": "You said you wanted to come back to it.",
  "model": {
    "line": "Yes. You were right about the meetings — I talked over you twice and it was rude, and I am going to stop.",
    "why": "The specific thing named, what changes attached, and nothing after it. The specificity is most of what makes it land, because it proves you understood rather than that you wanted the subject closed."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No but, and nothing that undoes it",
      "words": ["but", "although", "to be fair", "in my defence", "if you felt", "if i came across", "at the time i", "you have to understand", "are we okay", "we good"] },
    { "kind": "min_words", "requirement": "Name the actual thing and what changes", "n": 12 },
    { "kind": "max_words", "requirement": "Twenty words is plenty", "n": 40 }
  ]
}$j$::jsonb);
