-- Hard conversations, track 3: Saying the thing.
--
-- The content, which turns out to be three parts and four habits to leave out.
-- The habits are the interesting half: every one of them is something people
-- were taught, or picked up because it sounds fair, and each converts a
-- solvable problem into a trial of somebody's character.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'saying-the-thing'),
  1,
  'What happened, what it did, what you want',
  $md$The content of a hard conversation is smaller than anybody expects. Three parts, about two sentences each, and everything beyond them is decoration or damage.

**What happened.** A fact, not a summary. *The last three times we made plans you cancelled the day before.* Checkable, agreeable, and impossible to argue with as a matter of record — which matters enormously, because the first thing an uncomfortable person reaches for is a factual dispute, and you want there to be nothing available.

**What it did.** The consequence, including the one inside you. *I have stopped suggesting things I actually want to do, because I assume they will not happen.* This is the part that gets left out, and without it you have described something you did not enjoy — to which the honest reply is *and?* The effect is what makes it a problem rather than a preference.

**What you want.** One specific change, small enough to happen on Thursday. *If you know in the morning, tell me then rather than at six.*

**The move:** say those three, in that order, and stop.

Order matters more than it sounds. Fact first is unarguable, so the conversation starts on solid ground. Effect second gives it weight without accusing anybody of anything — you are reporting on yourself. Ask last means the conversation has somewhere to go, and gives them something to do other than defend.

Two sentences each is plenty. The instinct to elaborate comes from the silence and from wanting to be understood completely, and every additional sentence dilutes the three that were doing the work.

And notice what is not in it: why they did it, what it says about them, how it compares to what you would have done, and how long you have been feeling this way. All of that is available and none of it helps.

If you keep one thing: fact, effect, ask. If you can say those three and stop, you have done the hard part.$md$,
  $j$[
    {
      "situation": "You want to raise the cancelling.",
      "line": "The last three times we made plans you cancelled the day before. I have stopped suggesting things I want to do, because I assume they will not happen. If you know in the morning, could you tell me then?",
      "why": "Fact, effect, ask. Nothing in it can be disputed, it has weight without accusing anybody, and it gives them something to do."
    },
    {
      "situation": "You have said what happened and stopped there.",
      "line": "(the honest reply to that is: and?)",
      "why": "Without the effect you have described something you did not enjoy. The consequence is what makes it a problem rather than a preference."
    },
    {
      "situation": "You want them to understand how long this has been going on.",
      "line": "(that is not in the three)",
      "why": "Why they did it, what it says about them, and how long you have felt this way are all available and none of them help."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does the fact go first?",
      "options": [
        { "text": "It is the least emotional part.", "correct": false, "note": "Emotional temperature is not what the ordering is managing." },
        { "text": "It gives them nothing to dispute.", "correct": true, "note": "The first thing an uncomfortable person reaches for is a factual argument, and starting on something checkable means there is none available." },
        { "text": "It is the most important part.", "correct": false, "note": "The ask is arguably the most important. The fact goes first for a structural reason rather than a hierarchy of importance." },
        { "text": "It eases them into it.", "correct": false, "note": "Nothing about this eases anybody into anything, and trying to is the runway problem from the previous track." }
      ],
      "explain": "Fact, effect, ask. Solid ground, then weight, then somewhere to go."
    },
    {
      "prompt": "What does leaving out the effect cost you?",
      "options": [
        { "text": "It sounds like you do not care much.", "correct": false, "note": "It can, and the structural problem is worse than the impression." },
        { "text": "They will not know how you feel.", "correct": false, "note": "Close, and phrased as if the goal were expression. The effect is doing a job in the argument." },
        { "text": "It becomes a preference rather than a problem.", "correct": true, "note": "You have described something you did not enjoy, and the honest reply is: and? The consequence is what makes it worth a conversation." },
        { "text": "The conversation gets shorter.", "correct": false, "note": "It usually gets longer, because nobody knows what is being asked." }
      ],
      "explain": "Two sentences each is plenty. Elaboration dilutes the three that were working."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "fact", "label": "Started with the fact", "description": "Something checkable rather than a summary." },
      { "key": "effect", "label": "Named the effect", "description": "Said what it actually did, including to them." },
      { "key": "ask", "label": "Ended with the ask", "description": "One specific change." },
      { "key": "stopped", "label": "Stopped", "description": "Did not elaborate past the three parts." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are sitting down with a friend who has cancelled the last three things you arranged, each time the day before.",
    "partner": {
      "name": "Jo",
      "role": "a friend who keeps cancelling",
      "personality": "Reaches immediately for a factual dispute if there is one available, and engages seriously with something checkable.",
      "mood": "Willing, a bit wary.",
      "openness": 4
    },
    "opening_beat": "\"Go on then — what is it about the plans?\"",
    "success_looks_like": "The user gives the fact, the effect and the ask, then stops.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Dispute anything vague or generalised, with a counter-example.",
      "Accept a checkable fact without argument and engage with what follows.",
      "Never supply the ask yourself."
    ]
  }$j$::jsonb,
  $md$Today, write out one thing you need to say as fact, effect and ask. Two sentences each. Log all three.$md$
),
(
  (select id from public.skills where slug = 'saying-the-thing'),
  2,
  'Always and never',
  $md$Two words undo more hard conversations than any others, and they get used precisely when somebody is trying to convey that this is not a one-off.

*You always cancel.* *You never ask about my week.*

**The move:** count instead of generalising.

*The last three times* is unarguable. *You always* is a claim about every instance, which means it is false — there is a time they did not, both of you know it, and it is now available as a rebuttal. And it will be used, because when somebody is uncomfortable a factual escape route is irresistible.

What follows is the conversation you did not want. They produce the counter-example, you say you did not mean literally always, they say then why say it, and eight minutes have gone on the accuracy of a word while the actual thing sits untouched. Worse, you now look as though you were exaggerating, which quietly discredits everything else you say.

There is a real thing underneath the word, and it is worth keeping. What you mean is that it is a pattern, and a pattern is best expressed by counting: *three of the last four times.* That has the same weight as *always* and none of the exposure — and counting sounds considered rather than heated, which is its own advantage.

Two relatives worth the same treatment. *You are constantly* is *always* wearing a different coat. And *every time we*, said in the middle of an argument, is the same overclaim arriving at speed.

If you genuinely do not know the number, say the vaguer honest version: *this has happened a few times now, and I have stopped counting* is fine and cannot be rebutted, because it does not claim to be precise.

If you keep one thing: count. Numbers are unarguable and always is the word that hands somebody the exit.$md$,
  $j$[
    {
      "situation": "You want to convey that this is a pattern.",
      "line": "Three of the last four times.",
      "why": "The same weight as always and none of the exposure. Numbers are unarguable and counting sounds considered rather than heated."
    },
    {
      "situation": "You said you always cancel and they named the time they did not.",
      "line": "(that was the exit you handed them)",
      "why": "Eight minutes now go on the accuracy of a word, and you look as though you were exaggerating — which discredits everything else."
    },
    {
      "situation": "You have not been counting.",
      "line": "This has happened a few times now and I stopped counting.",
      "why": "Honest, vague in a way that cannot be rebutted, and it does not claim a precision you do not have."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is always so costly?",
      "options": [
        { "text": "It is aggressive.", "correct": false, "note": "It is usually said in frustration rather than aggression, and tone is not what does the damage." },
        { "text": "It is a claim about every instance, so it is false.", "correct": true, "note": "There is a time they did not, both of you know it, and it is now available as a rebuttal — which an uncomfortable person will reach for." },
        { "text": "It sounds childish.", "correct": false, "note": "Style rather than mechanism, and it would still be costly said perfectly calmly." },
        { "text": "It generalises about their character.", "correct": false, "note": "That is the next lesson, and it is a different error. This one is about a factual overclaim." }
      ],
      "explain": "Count instead. Three of the last four is unarguable and carries the same weight."
    },
    {
      "prompt": "What is the second cost, after the argument about the word?",
      "options": [
        { "text": "You lose your temper.", "correct": false, "note": "Sometimes, and it is not what makes the overclaim structurally expensive." },
        { "text": "They stop listening.", "correct": false, "note": "They listen very closely — for the next thing they can dispute." },
        { "text": "The conversation goes on longer.", "correct": false, "note": "It does, and that is the visible cost rather than the lasting one." },
        { "text": "You look as though you were exaggerating.", "correct": true, "note": "Which quietly discredits everything else you say, including the parts that were exactly accurate." }
      ],
      "explain": "If you do not know the number, say so honestly rather than reaching for always."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "counted", "label": "Counted", "description": "Gave a number rather than a generalisation." },
      { "key": "no_always", "label": "Left always and never out", "description": "Including constantly and every time." },
      { "key": "honest_vague", "label": "Was honestly vague when unsure", "description": "Did not claim precision they did not have." },
      { "key": "kept_weight", "label": "Kept the weight", "description": "Conveyed the pattern without the overclaim." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Mid-conversation. You have just said that they always cancel, and they have gone very still.",
    "partner": {
      "name": "Jo",
      "role": "a friend who keeps cancelling",
      "personality": "Seizes on any overclaim with a precise counter-example, and settles immediately when given a number they cannot dispute.",
      "mood": "Defensive, alert.",
      "openness": 4
    },
    "opening_beat": "\"Always? I came to the thing in March. And your birthday.\"",
    "success_looks_like": "The user replaces the overclaim with a count rather than defending the word.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Argue about the accuracy of any generalisation for as long as the user defends it.",
      "Concede immediately and engage with the substance once given a specific count.",
      "Never move the conversation on yourself."
    ]
  }$j$::jsonb,
  $md$Today, replace one always or never with an actual number before you say it. Log the sentence you would have said and the one you did.$md$
),
(
  (select id from public.skills where slug = 'saying-the-thing'),
  3,
  'Effect, not intent',
  $md$There is a sentence people reach for when they want to say what something meant, and it is the one that guarantees an argument.

*You did that to make a point.* *You were trying to make me feel stupid.* *You clearly do not care.*

Each of those is a claim about somebody's inner life, which you cannot see and they will never concede. What follows is a debate about their intentions — a subject on which they have privileged access, infinite standing, and every reason to defend themselves — and the actual thing you were upset about disappears entirely.

**The move:** report the effect, which is yours and cannot be disputed.

*It landed as though you were making a point.* *I ended up feeling stupid.* *It felt like it did not matter much.*

Those say almost the same thing and behave completely differently, because they are reports rather than accusations. Nobody can tell you that you did not feel something. There is no counter-evidence, no defence available, and — crucially — no need for one, because you have not accused them of anything they have to deny.

It also gets you closer to what you actually know. You do not know why they did it. You know what happened and what it did to you, and those are the two things you came to say.

Two things it is not. It is not softer — *I felt humiliated* is a heavy sentence and it is meant to be. And it is not a formula: *I feel that you are being selfish* is an intent claim with three words bolted on the front, and everybody recognises it instantly.

The test is whether the sentence could be argued with. If they could reasonably say *no I was not*, you have described their intent. If the only available reply is *I did not mean it like that*, you have described the effect — and *I did not mean it like that* is not a rebuttal, it is the beginning of the conversation you wanted.

If you keep one thing: you know what it did to you. You do not know why they did it, and the second one is not worth the argument.$md$,
  $j$[
    {
      "situation": "You think they said it to make a point.",
      "line": "It landed as though you were making a point.",
      "why": "A report rather than an accusation. There is no counter-evidence available and no defence required, because nothing has been alleged."
    },
    {
      "situation": "You are about to say they clearly do not care.",
      "line": "(they will defend that for twenty minutes)",
      "why": "Their intentions are a subject on which they have privileged access and infinite standing, and the thing you came about disappears."
    },
    {
      "situation": "You want to check the sentence before you say it.",
      "line": "(could they reasonably say no I was not?)",
      "why": "If yes, it is an intent claim. If the only reply is I did not mean it like that, it is an effect — and that reply is the start of the conversation you wanted."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does naming their intent go wrong?",
      "options": [
        { "text": "It is presumptuous.", "correct": false, "note": "It is, and being presumptuous is not what makes the conversation unwinnable." },
        { "text": "You will probably be wrong.", "correct": false, "note": "You might well be right. The problem holds even when you are." },
        { "text": "They have privileged access to it and will defend it.", "correct": true, "note": "A debate about their intentions is one they cannot lose and you cannot win, and the thing you actually came about disappears into it." },
        { "text": "It escalates the argument.", "correct": false, "note": "Describes what happens rather than why. The mechanism is about what is disputable." }
      ],
      "explain": "You know what it did to you. You do not know why they did it."
    },
    {
      "prompt": "What is the test for a sentence?",
      "options": [
        { "text": "Whether it starts with I feel.", "correct": false, "note": "I feel that you are being selfish is an intent claim with three words on the front, and everybody recognises it instantly." },
        { "text": "Whether they could reasonably say no I was not.", "correct": true, "note": "If yes, you described their intent. If the only reply available is I did not mean it like that, you described the effect." },
        { "text": "Whether it sounds calm.", "correct": false, "note": "Calm intent claims start exactly the same argument." },
        { "text": "Whether it is kind.", "correct": false, "note": "Effect statements are frequently not kind — I felt humiliated is heavy and is meant to be." }
      ],
      "explain": "I did not mean it like that is not a rebuttal. It is the start of the conversation you wanted."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "effect", "label": "Reported the effect", "description": "Said what it did rather than what they meant." },
      { "key": "no_intent", "label": "Made no claim about intent", "description": "Left their motives out." },
      { "key": "not_formula", "label": "Did not use I feel as a wrapper", "description": "Avoided an intent claim with three words in front." },
      { "key": "kept_weight", "label": "Did not soften it", "description": "Said the heavy thing where it was true." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "They made a remark in front of other people last week and you have decided to say something about it.",
    "partner": {
      "name": "Jo",
      "role": "somebody who made a remark at your expense",
      "personality": "Defends their intentions at length whenever they are described, and engages honestly when told what the remark did.",
      "mood": "Open, mildly braced.",
      "openness": 4
    },
    "opening_beat": "\"Go on. What about it?\"",
    "success_looks_like": "The user describes the effect rather than the intent.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Defend yourself at length against any claim about what you meant or intended.",
      "Respond with I did not mean it like that, and then engage seriously, when told the effect.",
      "Never concede an intent you are accused of."
    ]
  }$j$::jsonb,
  $md$Today, catch one sentence about somebody's motives and convert it to what it did to you. Log both versions.$md$
),
(
  (select id from public.skills where slug = 'saying-the-thing'),
  4,
  'No apology sandwich',
  $md$Everybody has been taught this one: something nice, the criticism, something nice. It is the most widely recommended technique in this whole area and it is worse than saying nothing first.

**The move:** say the thing on its own, and put the warm part somewhere it is believed.

What the sandwich actually does depends on who is eating it, and both outcomes are bad.

Somebody optimistic hears the bread. They leave the conversation having been told they are doing well, with a vague sense that there was something in the middle, and nothing changes — which is worse than not having spoken, because you now believe it was said.

Somebody anxious hears the filling and discards the bread as padding. Worse, they learn that your compliments are packaging, and from then on every genuine nice thing you say produces a flinch while they wait for the middle.

That is the lasting cost and it is the one people miss. The sandwich does not only fail in the moment; it devalues your praise permanently, in a relationship where you presumably want to be able to say warm things and be believed.

There is a real version of the impulse worth keeping. You do want the person to know this is not a referendum on them, and you do want them to leave intact. Both are achieved by saying what you actually mean, plainly, rather than by structural padding: *this is one thing, and it is not a big picture problem* does the job in a sentence.

Warmth after works when it is not doing a job. Once the substance has been said, dealt with and agreed, ordinary friendliness is ordinary friendliness — the difference is that it is not being deployed.

If you keep one thing: say the thing on its own. Praise used as packaging stops being praise.$md$,
  $j$[
    {
      "situation": "You are planning to open with something positive.",
      "line": "(say the thing on its own)",
      "why": "An optimist hears the bread and nothing changes. An anxious person hears the filling and learns that your compliments are packaging."
    },
    {
      "situation": "You want them to know this is not a referendum on them.",
      "line": "This is one thing, and it is not a big picture problem.",
      "why": "Says what you actually mean in one sentence, rather than doing it with structure — which is what the sandwich was trying to achieve."
    },
    {
      "situation": "The substance has been said and dealt with.",
      "line": "(now warmth is just warmth)",
      "why": "Once it is not doing a job, ordinary friendliness reads as ordinary friendliness rather than as deployment."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What happens to an optimistic person?",
      "options": [
        { "text": "They hear the bread and nothing changes.", "correct": true, "note": "They leave having been told they are doing well, with a vague sense there was something in the middle — which is worse than silence, because you believe it was said." },
        { "text": "They get defensive about the middle.", "correct": false, "note": "That is closer to the anxious reading. The optimist barely registers it." },
        { "text": "They appreciate the balance.", "correct": false, "note": "They do appreciate it, and appreciating it is exactly how the substance gets lost." },
        { "text": "They ask what you really meant.", "correct": false, "note": "Almost nobody does. They take the overall impression and leave." }
      ],
      "explain": "Two audiences, two failures, and neither of them is the one you wanted."
    },
    {
      "prompt": "What is the lasting cost?",
      "options": [
        { "text": "The point does not land.", "correct": false, "note": "The immediate cost, and it is recoverable by saying it again." },
        { "text": "They think you are being manipulative.", "correct": false, "note": "Close to it, and stated as a one-off impression rather than the durable effect." },
        { "text": "It takes longer than it needs to.", "correct": false, "note": "Trivial next to what it does to everything you say afterwards." },
        { "text": "Your praise stops being believed.", "correct": true, "note": "From then on every genuine nice thing produces a flinch while they wait for the middle — in a relationship where you presumably want to say warm things and be taken at face value." }
      ],
      "explain": "Praise used as packaging stops being praise."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_sandwich", "label": "Did not sandwich it", "description": "Said the thing on its own." },
      { "key": "said_the_frame", "label": "Framed it in words", "description": "Said it was one thing rather than a verdict, plainly." },
      { "key": "warmth_after", "label": "Kept warmth for afterwards", "description": "Let friendliness be friendliness once the substance was done." },
      { "key": "clear", "label": "Was unmistakable", "description": "Left no doubt about what was being raised." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have to raise one specific thing with somebody you work well with and genuinely rate.",
    "partner": {
      "name": "Jo",
      "role": "a colleague you like and work well with",
      "personality": "Optimistic. Hears praise clearly and vague criticism not at all, and leaves an ambiguous conversation cheerfully with nothing changed.",
      "mood": "Cheerful.",
      "openness": 4
    },
    "opening_beat": "\"You wanted a quick word?\"",
    "success_looks_like": "The user raises the thing on its own, unmistakably.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Take any praise at face value and treat surrounding criticism as a minor aside.",
      "Engage seriously and specifically with anything said plainly and on its own.",
      "Never ask whether there is a problem."
    ]
  }$j$::jsonb,
  $md$Today, say one piece of difficult feedback without a compliment on either side of it. Log what you said.$md$
),
(
  (select id from public.skills where slug = 'saying-the-thing'),
  5,
  'Say it once',
  $md$You have said it. There is a silence. And the urge to say it again, differently, is enormous.

**The move:** say it once and let the silence be theirs.

What produces the repetition is not a belief that they misheard. It is the discomfort of the gap, and the fear that the version you gave was not quite right — so you offer a second one, and a third, each slightly softer than the last because each is being delivered into a silence that feels like disapproval.

The cost is specific. Three versions of a point are weaker than one, because the second implies the first was inadequate and the third suggests you are negotiating with yourself. And the softening is real: almost nobody restates a difficult thing more firmly, so by the third pass you have talked yourself down to something they can agree with easily and act on not at all.

The silence is also not what it feels like. Somebody who has just been told something difficult is doing work — deciding whether it is true, remembering the instances, working out what to say. That takes a few seconds and those seconds belong to them. Filling them takes the conversation back, and they now have two things to respond to.

Practically: say the three parts, then stop and count to five. It is a very long five seconds and it is the whole technique.

If they say nothing at all after that, one prompt is fine — *what do you think?* — and it is a question rather than a restatement, which is the difference that matters.

And if you genuinely were unclear, say the same thing again in the same words rather than a new formulation. Repetition is fine; escalation and dilution are not, and a fresh version is nearly always one or the other.

If you keep one thing: stop talking. The silence after a difficult sentence is somebody thinking, and it is doing more work than anything you could add.$md$,
  $j$[
    {
      "situation": "You said it and there is a silence.",
      "line": "(count to five)",
      "why": "Somebody who has just been told something difficult is deciding whether it is true. Those seconds are theirs and filling them takes the conversation back."
    },
    {
      "situation": "You are about to say it again, slightly differently.",
      "line": "(the second version implies the first was inadequate)",
      "why": "And almost nobody restates a difficult thing more firmly — by the third pass you have talked yourself down to something easy to agree with and impossible to act on."
    },
    {
      "situation": "The silence has genuinely gone on.",
      "line": "What do you think?",
      "why": "A question rather than a restatement, which is the difference that matters."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why do people say it three times?",
      "options": [
        { "text": "They think it was not heard.", "correct": false, "note": "The reason people give afterwards. In the moment it is about the gap rather than about their comprehension." },
        { "text": "The silence is uncomfortable.", "correct": true, "note": "And the fear that the version given was not quite right, so a second is offered into a silence that feels like disapproval." },
        { "text": "They want to be fair.", "correct": false, "note": "Fairness produces the softening rather than the repetition, and the softening is the second-order problem." },
        { "text": "They have more to say.", "correct": false, "note": "Rarely — it is the same point in new words, which is what makes it dilution rather than addition." }
      ],
      "explain": "Say the three parts, stop, and count to five. It is a very long five seconds."
    },
    {
      "prompt": "What does the third version cost?",
      "options": [
        { "text": "Time.", "correct": false, "note": "The least of it. A long conversation is fine if the point survives it." },
        { "text": "It makes you sound uncertain.", "correct": false, "note": "It does, and that is the impression rather than the mechanism." },
        { "text": "You have negotiated yourself down to something unactionable.", "correct": true, "note": "Almost nobody restates a difficult thing more firmly, so each pass is softer — and by the third they can agree easily and do nothing." },
        { "text": "They stop listening.", "correct": false, "note": "They listen to all three and act on the weakest one, which is worse." }
      ],
      "explain": "If you must repeat, use the same words. A fresh version is nearly always escalation or dilution."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "once", "label": "Said it once", "description": "Did not offer a second version." },
      { "key": "counted", "label": "Let the silence run", "description": "Waited rather than filling it." },
      { "key": "no_softening", "label": "Did not soften it", "description": "The point ended where it started." },
      { "key": "question", "label": "Prompted with a question", "description": "If anything, asked rather than restated." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have just said the fact, the effect and the ask. They have not said anything yet.",
    "partner": {
      "name": "Jo",
      "role": "somebody you have just raised something with",
      "personality": "Takes a genuine few seconds to think, and responds properly if given them. Latches onto the softest version if several are offered.",
      "mood": "Absorbing it.",
      "openness": 4
    },
    "opening_beat": "(silence — they are looking at the table)",
    "success_looks_like": "The user says nothing until the other person speaks.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Take several seconds before your first substantive reply, and describe the pause.",
      "Respond to the weakest version offered if the user restates the point.",
      "Engage seriously with the original version if the user waits."
    ]
  }$j$::jsonb,
  $md$Today, say one difficult thing once and then stop talking until they answer. Log how long the silence was.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('saying-the-thing', 1, 'line', $j${
  "says": "Go on then — what is it about the plans?",
  "model": {
    "line": "The last three times we made something you cancelled the day before. I have stopped suggesting things I actually want to do, because I assume they will not happen. Could you tell me in the morning if you know then?",
    "why": "Fact, effect, ask. Nothing in it can be disputed, it carries weight without accusing anybody of anything, and it ends somewhere they can act."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Say what it did to you" },
    { "kind": "forbids_any", "requirement": "No generalising and no motives",
      "words": ["always", "never", "constantly", "every time", "you clearly", "you obviously", "you do not care", "selfish", "on purpose"] },
    { "kind": "min_words", "requirement": "All three parts", "n": 25 },
    { "kind": "max_words", "requirement": "Two sentences each is plenty", "n": 70 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('saying-the-thing', 2, 'line', $j${
  "says": "Always? I came to the thing in March. And your birthday.",
  "model": {
    "line": "Fair — three of the last four, then. That is the bit I wanted to talk about.",
    "why": "Concedes the overclaim instantly rather than defending the word, and replaces it with a number they cannot dispute. Counting carries the same weight as always with none of the exposure."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not defend the word",
      "words": ["always", "never", "constantly", "every time", "you know what i meant", "not literally", "basically", "practically"] },
    { "kind": "contains_any", "requirement": "Give a number instead",
      "words": ["three", "four", "twice", "two", "five", "of the last", "few times", "third time"] },
    { "kind": "max_words", "requirement": "Concede and move", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('saying-the-thing', 3, 'line', $j${
  "says": "Go on. What about it?",
  "model": {
    "line": "When you said it in front of everyone, I ended up feeling about six inches tall for the rest of the evening.",
    "why": "A report on you rather than a claim about them. There is no counter-evidence available and no defence required, so the only reply is I did not mean it like that — which is the start of the conversation you wanted."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Report the effect, which is yours" },
    { "kind": "forbids_any", "requirement": "No claims about what they meant",
      "words": ["you meant", "you were trying", "you wanted to", "on purpose", "deliberately", "you clearly", "you obviously", "to make me", "you do not care"] },
    { "kind": "min_words", "requirement": "Say what it actually did", "n": 12 },
    { "kind": "max_words", "requirement": "One sentence", "n": 40 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('saying-the-thing', 4, 'choice', $j${
  "beats": [
    {
      "situation": "You have to raise one specific thing with a colleague you genuinely rate. You were taught to open with something positive.",
      "prompt": "What do you do?",
      "options": [
        { "text": "Compliment, then the thing, then a compliment.", "correct": false, "note": "An optimist hears the bread and nothing changes. An anxious person hears the filling and learns that your praise is packaging." },
        { "text": "Open warmly, then raise it, and leave it there.", "correct": false, "note": "Half a sandwich is still a runway, and the warmth still gets reread as technique once the turn arrives." },
        { "text": "Say the thing on its own, and say plainly it is one thing.", "correct": true, "note": "It achieves what the sandwich was reaching for — that this is not a referendum on them — by saying it rather than by structure." },
        { "text": "Raise it and then reassure them at length afterwards.", "correct": false, "note": "Reassurance that is doing a job is heard as reassurance that is doing a job. Warmth works once it has stopped being deployed." }
      ]
    },
    {
      "situation": "You have used the sandwich with this person a few times before.",
      "prompt": "What has that cost, beyond the individual conversations?",
      "options": [
        { "text": "Nothing lasting — each one stands alone.", "correct": false, "note": "People learn patterns quickly, especially ones that precede criticism." },
        { "text": "They think less of you.", "correct": false, "note": "Usually not. The cost is to a specific thing rather than to their overall opinion." },
        { "text": "Your praise now produces a flinch.", "correct": true, "note": "They wait for the middle. In a relationship where you want to say warm things and be believed, that is an expensive thing to have spent." },
        { "text": "They have stopped taking feedback seriously.", "correct": false, "note": "Close, and it is the criticism half. The durable damage is on the other side." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('saying-the-thing', 5, 'choice', $j${
  "beats": [
    {
      "situation": "You have said the fact, the effect and the ask. They are looking at the table and have not spoken. It has been about four seconds.",
      "prompt": "What do you do?",
      "options": [
        { "text": "Say it again, more clearly.", "correct": false, "note": "The second version implies the first was inadequate, and almost nobody restates a difficult thing more firmly." },
        { "text": "Soften it — make sure they know it is not a big deal.", "correct": false, "note": "This is the retraction. Four seconds of discomfort has just cost you the whole point." },
        { "text": "Nothing. Count to five.", "correct": true, "note": "They are deciding whether it is true and remembering the instances. Those seconds are theirs, and filling them hands the conversation back." },
        { "text": "Ask if they are all right.", "correct": false, "note": "Kind, and it converts your discomfort into their problem to manage — thirty seconds after you asked them to manage something else." }
      ]
    },
    {
      "situation": "You waited, and they still have not said anything.",
      "prompt": "Now?",
      "options": [
        { "text": "Put it another way, in case the wording was the problem.", "correct": false, "note": "A fresh formulation is nearly always dilution or escalation. If you must repeat, use the same words." },
        { "text": "Let the silence continue indefinitely.", "correct": false, "note": "At some point it becomes a standoff, which is a different and less useful thing than a pause." },
        { "text": "Apologise for the awkwardness.", "correct": false, "note": "It makes the difficulty of the conversation the subject, and it is one step from taking the point back." },
        { "text": "Ask what they think.", "correct": true, "note": "A question rather than a restatement, which is the difference that matters. It hands them the floor without weakening anything." }
      ]
    }
  ]
}$j$::jsonb);
