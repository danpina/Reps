-- Dating apps, track 4: Running it without it running you.
--
-- The track this app's readers need most and the one the topic did not have.
-- Everything else here assumes somebody still believes it can work, and these
-- products are unusually efficient at removing that belief from a quiet person
-- several times a week.
--
-- No scenes. Nothing here is a conversation — it is a set of readings and one
-- decision about your own week — which is exactly what choice and line drills
-- are for.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'running-the-app'),
  1,
  'Volume is not a verdict',
  $md$Forty swipes, two matches. Eight messages, three replies. Two conversations that fade and one drink that never gets confirmed.

Every one of those numbers is an ordinary base rate. Every one of them arrives feeling like a small personal judgement, delivered several times a day, to somebody who was already inclined to read silence as information about themselves.

**The move:** learn the actual ratios, so you stop measuring yourself against an imaginary one.

Nobody publishes them, which is the root of the problem — so people invent their own out of hope. The invented version is roughly: if I am reasonably normal, most people I like should match, most matches should talk, and most conversations should lead somewhere. Measured against that, an average week looks like catastrophic personal failure.

The real shape is a funnel that loses most of its contents at every stage, for everybody. Low single-digit match rates are unremarkable. Most matches never exchange a word. Most conversations do not become dates. This is not a description of you doing badly, it is a description of the product working normally, and the people who appear to do well on it are running the same ratios with a bigger numerator.

Which produces the one genuinely useful behavioural conclusion: the fix for a thin week is almost always more attempts rather than a better attempt. That sounds bleak and it is the opposite — it means the lever is volume, which is entirely in your control, rather than being more attractive or more interesting, which is not.

And it is worth noticing what the numbers cannot tell you. A non-match is not a rejection by a person; it is somebody moving a thumb while half-watching television. Nothing about it was considered, which means nothing about it is information.

If you keep one thing: you are reading a base rate, not a verdict. Everybody's numbers look like this.$md$,
  $j$[
    {
      "situation": "Forty swipes this week, two matches.",
      "line": "(that is the base rate)",
      "why": "Low single-digit match rates are unremarkable. The invented standard — most people I like should match — is what makes an ordinary week look like failure."
    },
    {
      "situation": "You want to fix a thin week.",
      "line": "(more attempts, not better ones)",
      "why": "The lever is volume, which is in your control, rather than being more attractive, which is not. That is a better position than it sounds."
    },
    {
      "situation": "Somebody did not match you back.",
      "line": "(a thumb, half-watching television)",
      "why": "Nothing about it was considered, which means nothing about it is information about you."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does an average week feel like failure?",
      "options": [
        { "text": "Because the apps are designed to make you feel bad.", "correct": false, "note": "Their incentives are not aligned with yours and this particular effect is simpler than a conspiracy." },
        { "text": "Because you are measuring against a rate you invented.", "correct": true, "note": "Nobody publishes the real ones, so people fill the gap with hope — most people I like should match — and an ordinary week loses against that badly." },
        { "text": "Because rejection accumulates.", "correct": false, "note": "It does, and calling it rejection is the misreading. Most of it was never a decision about you." },
        { "text": "Because everybody else is doing better.", "correct": false, "note": "They are running the same ratios with a bigger numerator, which looks like success and is arithmetic." }
      ],
      "explain": "Learn the actual shape and the same week stops being a report card."
    },
    {
      "prompt": "What follows from the base rates?",
      "options": [
        { "text": "Lower your standards.", "correct": false, "note": "Nothing here says who to want. It says how many attempts a normal outcome takes." },
        { "text": "The apps are not worth using.", "correct": false, "note": "A conclusion some people reach honestly, and it does not follow from the ratios alone." },
        { "text": "The lever is volume, and volume is in your control.", "correct": true, "note": "The fix for a thin week is more attempts rather than a better attempt — which is a much better position than needing to be more attractive." },
        { "text": "It is mostly luck.", "correct": false, "note": "Luck plays a part and this framing makes the whole thing passive, which is the opposite of the useful conclusion." }
      ],
      "explain": "A non-match is a thumb moving while somebody half-watches television."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "base_rate", "label": "Read it as a base rate", "description": "Stopped treating the numbers as a judgement." },
      { "key": "no_invented", "label": "Dropped the invented standard", "description": "Stopped measuring against a rate nobody achieves." },
      { "key": "volume", "label": "Reached for volume", "description": "Answered a thin week with more attempts rather than self-improvement." },
      { "key": "no_meaning", "label": "Read no meaning into a non-match", "description": "Treated an unconsidered act as uninformative." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A friend has asked how the apps are going and you have just described a week that felt humiliating.",
    "partner": {
      "name": "Sam",
      "role": "a friend who has used these apps for years",
      "personality": "Asks for the actual numbers and then reports their own, which are almost identical and which they find completely unremarkable.",
      "mood": "Matter-of-fact.",
      "openness": 5
    },
    "opening_beat": "\"Go on then — how many matches, actually? Out of how many?\"",
    "success_looks_like": "The user reads their numbers as a base rate rather than as a verdict.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Report your own comparable numbers plainly whenever the user calls theirs bad.",
      "Ask what rate they were expecting, and where that expectation came from.",
      "Never reassure the user directly."
    ]
  }$j$::jsonb,
  $md$Today, count one week of actual numbers — swipes, matches, replies. Log them, and log what you had assumed they should be.$md$
),
(
  (select id from public.skills where slug = 'running-the-app'),
  2,
  'Ghosting is a habit, not a message',
  $md$Somebody was warm, replied quickly, agreed to a drink, and then stopped answering. There is no explanation coming, and the absence of one is what makes it stick — because a mind with no information in it will manufacture some, and what it manufactures is always about you.

**The move:** treat a disappearance as a fact about the medium, not a message about you.

The honest account of why it happens is unflattering to nobody in particular. These apps make it costless to stop replying, because the person disappearing never has to say anything, never sees your reaction, and will not run into you. Remove all of that friction and a large number of ordinary, decent people will simply stop — not out of cruelty but because ending things politely takes an effort they have not been asked to make.

The commonest actual causes are dull. They got back together with somebody. They matched with somebody else that evening. The conversation stalled and restarting it felt awkward. They are not really using the app. They got busy on Tuesday and by Friday it had become a thing they would have to explain.

You will never learn which, and that is the part worth accepting deliberately rather than fighting. The mistake is not being upset — it is going looking for the reason, which means rereading the exchange, finding the message where it "turned", and assigning it a meaning that was almost certainly never there.

Two practical things. Do not send the second follow-up: one light message is fine and adds nothing to your exposure, and the one after it is the one you will think about. And do not adjust your behaviour on the evidence of a single disappearance — people conclude they were too keen, too dull, too forward, on the strength of something that had no content at all.

If you keep one thing: no explanation is coming, and inventing one costs you far more than the person did.$md$,
  $j$[
    {
      "situation": "Warm, quick replies, a drink agreed, and then nothing.",
      "line": "(no explanation is coming)",
      "why": "The absence is what makes it stick, because a mind with no information manufactures some — and what it manufactures is always about you."
    },
    {
      "situation": "You are rereading the exchange to find where it turned.",
      "line": "(there is no turn to find)",
      "why": "The commonest causes are dull and external. Assigning a meaning to a message is inventing content that was never there."
    },
    {
      "situation": "You sent one light follow-up and heard nothing.",
      "line": "(that is the last one)",
      "why": "The first costs nothing. The second is the one you will think about, and it adds no information."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does ghosting happen so much on apps specifically?",
      "options": [
        { "text": "People on apps are less considerate.", "correct": false, "note": "Mostly the same people who behave well elsewhere. The setting changed, not the population." },
        { "text": "There is no friction, so ending things politely takes an effort nobody is asked to make.", "correct": true, "note": "They never have to say anything, never see your reaction, and will not run into you. Remove all that and decent people simply stop." },
        { "text": "There is too much choice.", "correct": false, "note": "A contributing factor and not the mechanism. Plenty of ghosting happens between people with no other conversations running." },
        { "text": "It is a way of saying no.", "correct": false, "note": "Rarely intended as a message at all, which is precisely why reading one out of it goes wrong." }
      ],
      "explain": "A fact about the medium, not a message about you."
    },
    {
      "prompt": "What is the actual mistake after being ghosted?",
      "options": [
        { "text": "Being upset about it.", "correct": false, "note": "Entirely reasonable and not a mistake. Something did happen, and it was disappointing." },
        { "text": "Sending a follow-up.", "correct": false, "note": "One light one is free. It is the second that becomes the thing you think about." },
        { "text": "Going looking for the reason.", "correct": true, "note": "Rereading, finding the message where it turned, assigning it a meaning that was almost certainly never there — and then changing your behaviour on that basis." },
        { "text": "Assuming they were not interested.", "correct": false, "note": "Probably true and harmless. It is the version with a cause attached that does the damage." }
      ],
      "explain": "One follow-up, then leave it. Inventing a reason costs more than the person did."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_reason", "label": "Did not manufacture a reason", "description": "Accepted that no explanation was available." },
      { "key": "one_follow_up", "label": "Sent at most one follow-up", "description": "Did not send the second." },
      { "key": "no_reread", "label": "Did not reread it", "description": "Resisted looking for the message where it turned." },
      { "key": "no_adjustment", "label": "Changed nothing on one data point", "description": "Did not rewrite their approach on the evidence of a silence." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Nine days of good conversation, a drink agreed for Thursday, and then four days of nothing. It is now Friday.",
    "partner": {
      "name": "Sam",
      "role": "a friend you are talking to about it",
      "personality": "Asks what the user thinks happened, and gently notes each time the answer is a theory about themselves.",
      "mood": "Kind, unsentimental.",
      "openness": 5
    },
    "opening_beat": "\"So what do you reckon happened?\"",
    "success_looks_like": "The user stops constructing an explanation and lets it be unknown.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Point out, lightly, whenever a theory is about the user rather than about circumstances.",
      "Accept I do not know as a good answer and say so.",
      "Never offer a theory of your own."
    ]
  }$j$::jsonb,
  $md$Today, notice one silence you have been explaining to yourself, and stop explaining it. Log the explanation you dropped.$md$
),
(
  (select id from public.skills where slug = 'running-the-app'),
  3,
  'Do not fall for the texting version',
  $md$Three weeks of very good messages with somebody you have never met is a real experience, and it is not an experience of that person.

What you have been talking to is a version assembled from their best photographs, their edited sentences, and the parts of your own imagination that fill every gap they left. It is unusually appealing, because everything awkward has been removed from it — the pauses, the mannerism you would not have chosen, the face doing something ordinary while they think.

**The move:** meet early, before you have built somebody.

This is the practical argument for the timing the previous track already recommended, and it is the more important half. A few days of messages produces curiosity, which travels well into a room. Three weeks produces a relationship with a construct, and then a real person turns up to compete with it — which they cannot do, because they are a person and it is not.

The disappointment that follows gets misfiled, and that is the expensive part. People conclude there was no chemistry, when what actually happened is that they had already had the good version and the real one was simply different rather than worse. Somebody perfectly promising gets discarded because they were not the character in your phone.

It runs the other way too, and it is worth being fair about: they are also meeting somebody who is not quite the person they had been reading. Nobody has been dishonest. Text removes almost everything a person is and leaves behind the part that composes well.

And it explains a thing people find baffling — brilliant chat, flat date. Being good in writing is a skill with almost no overlap with being good in a room, and treating the first as a prediction of the second is how people arrive expecting a person who was never on offer.

If you keep one thing: three days of curiosity beats three weeks of correspondence. You are trying to meet somebody, not to build one.$md$,
  $j$[
    {
      "situation": "Three weeks of excellent messages and you have never met.",
      "line": "(you have built somebody)",
      "why": "Their best photographs, their edited sentences, and your own imagination filling every gap. It is unusually appealing because everything awkward has been removed."
    },
    {
      "situation": "The date was flat after brilliant chat.",
      "line": "(different, not worse)",
      "why": "Being good in writing has almost no overlap with being good in a room, and the disappointment gets misfiled as no chemistry."
    },
    {
      "situation": "You are enjoying the messaging and in no rush to meet.",
      "line": "(that is the trap, and it is a pleasant one)",
      "why": "A few days produces curiosity, which travels into a room. Three weeks produces a construct that a real person then has to compete with."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What have you actually been talking to?",
      "options": [
        { "text": "A dishonest version of them.", "correct": false, "note": "Nobody has been dishonest. Text simply removes almost everything a person is and keeps the part that composes well." },
        { "text": "Their best self.", "correct": false, "note": "Close, and it leaves out your own contribution — which is the half that makes the construct so appealing." },
        { "text": "Their edited version, plus your imagination filling the gaps.", "correct": true, "note": "Everything awkward removed, and every space filled by you. That is why it is more appealing than any real person could be." },
        { "text": "Somebody you have genuine chemistry with.", "correct": false, "note": "You may well have. You cannot know it from text, which is the point." }
      ],
      "explain": "Meet early, before there is a construct for the real person to lose against."
    },
    {
      "prompt": "Why does brilliant chat so often produce a flat date?",
      "options": [
        { "text": "One of you was pretending.", "correct": false, "note": "Almost never. Both people were being themselves in a medium that shows very little of anybody." },
        { "text": "Writing well and being good in a room barely overlap.", "correct": true, "note": "Treating the first as a prediction of the second is how people arrive expecting somebody who was never on offer." },
        { "text": "Expectations were too high.", "correct": false, "note": "True and general. The specific version is more useful: the skills are different skills." },
        { "text": "Nerves ruined it.", "correct": false, "note": "Sometimes, and it does not explain the pattern — plenty of relaxed dates are flat after excellent messaging." }
      ],
      "explain": "Different, not worse. Filing it as no chemistry discards people who were fine."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "met_early", "label": "Moved to meeting early", "description": "Did not let the messaging run for weeks." },
      { "key": "no_construct", "label": "Did not build somebody", "description": "Held the text version lightly." },
      { "key": "different", "label": "Read a flat date as different", "description": "Did not file it immediately as no chemistry." },
      { "key": "fair", "label": "Allowed the same of yourself", "description": "Recognised they were also meeting somebody new." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Two and a half weeks of very good messages with somebody you have never met. Neither of you has suggested meeting.",
    "partner": {
      "name": "Sam",
      "role": "a friend you are telling about it",
      "personality": "Asks how long it has been going on, and what you actually know about them as opposed to about their messages.",
      "mood": "Amused.",
      "openness": 5
    },
    "opening_beat": "\"Two and a half weeks. Have you actually met them?\"",
    "success_looks_like": "The user recognises the construct and moves towards meeting.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what they know about the person rather than about the conversation.",
      "Be pleased by a decision to arrange something this week.",
      "Never warn the user about anything directly."
    ]
  }$j$::jsonb,
  $md$Today, look at one conversation that has been running a while with no plan in it. Propose meeting. Log how long it had been.$md$
),
(
  (select id from public.skills where slug = 'running-the-app'),
  4,
  'Give it a shape',
  $md$An app with no rules attached will be opened at eleven at night, scrolled at for forty minutes, and closed feeling slightly worse. That is not a failure of willpower — it is what the product is for, and the only reliable defence is deciding the terms in advance.

**The move:** decide when you open it, how long for, and what you do while it is open.

**When.** A fixed slot, in daylight if possible, when you are not tired. Late-night use is where the worst reading happens: everything ambiguous becomes negative, every silence becomes a verdict, and the same inbox that would look ordinary at nine in the morning looks like evidence at midnight.

**How long.** Twenty minutes, twice a week, is enough to run this properly. That will sound too little to anybody currently spending five hours a week on it, which is the point — most of those five hours are grazing, and grazing is the part that costs mood and produces nothing.

**What you do.** Have a job while you are in there rather than browsing: swipe deliberately for ten minutes, then answer everything outstanding, then close it. Browsing with no task is the mode that produces the eleven o'clock feeling.

The counter-intuitive result, and it holds for most people: a shape produces *more*, not less. Twenty deliberate minutes beats two hours of scrolling because the deliberate version sends messages and proposes days, and the scrolling version mostly looks at people.

One more rule worth having: no reading the app when you feel bad. The instinct is to check it precisely then, and it is the one time it can only make things worse, because a low mood reads every ambiguity as confirmation.

If you keep one thing: put a start and a stop on it. The product does not have one, and it was never going to give you one.$md$,
  $j$[
    {
      "situation": "It is eleven at night and you have been scrolling for forty minutes.",
      "line": "(this is what it is for)",
      "why": "Not a failure of willpower. Late-night use is where everything ambiguous becomes negative and the same inbox looks like evidence."
    },
    {
      "situation": "You are spending five hours a week on it.",
      "line": "(twenty minutes twice a week, with a job)",
      "why": "Most of those five hours are grazing, which costs mood and produces nothing. The deliberate version sends messages and proposes days."
    },
    {
      "situation": "You feel low and reach for the app.",
      "line": "(the one time it can only make it worse)",
      "why": "A low mood reads every ambiguity as confirmation. Whatever is in there will look like proof of something it is not."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is late-night use the worst version?",
      "options": [
        { "text": "You are more likely to send something you regret.", "correct": false, "note": "It happens and it is rare. The damage is mostly in the reading rather than the writing." },
        { "text": "Everything ambiguous reads as negative.", "correct": true, "note": "The same inbox looks ordinary at nine in the morning and looks like evidence at midnight. Nothing in it changed." },
        { "text": "It affects your sleep.", "correct": false, "note": "True and a different problem from the one this lesson is about." },
        { "text": "Fewer people are online.", "correct": false, "note": "More are, if anything. Timing here is about your state rather than theirs." }
      ],
      "explain": "A fixed slot, in daylight, when you are not tired."
    },
    {
      "prompt": "Why does a shorter, shaped session produce more?",
      "options": [
        { "text": "Because you are less distracted.", "correct": false, "note": "Attention helps and is not the mechanism. It is about what you do rather than how well you do it." },
        { "text": "Because scarcity makes you decisive.", "correct": false, "note": "A tidy theory. The real difference is more mundane." },
        { "text": "Because you can only sustain it for twenty minutes.", "correct": false, "note": "People sustain hours of it. That is the problem rather than a limit." },
        { "text": "Because grazing looks at people and a job sends messages.", "correct": true, "note": "Twenty deliberate minutes swipes, replies and proposes days. Two hours of browsing mostly looks, which costs mood and produces nothing." }
      ],
      "explain": "Have a job while you are in there, then close it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "when", "label": "Fixed when", "description": "Chose a slot rather than opening it whenever." },
      { "key": "how_long", "label": "Fixed how long", "description": "Put a stop on it." },
      { "key": "a_job", "label": "Had a job", "description": "Swiped, replied and proposed rather than browsed." },
      { "key": "not_low", "label": "Did not open it when low", "description": "Kept it away from the worst reading conditions." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have worked out you spend about five hours a week on the app, most of it after ten at night, and you are deciding what to do about that.",
    "partner": {
      "name": "Sam",
      "role": "a friend you are talking it through with",
      "personality": "Practical about rules and sceptical of plans with no stop in them. Asks what you would actually do during the twenty minutes.",
      "mood": "Helpful.",
      "openness": 5
    },
    "opening_beat": "\"Five hours. What is the plan, then?\"",
    "success_looks_like": "The user sets a when, a how long and a job.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what they would actually do in the time, if only a duration is given.",
      "Push on any plan with no stopping point in it.",
      "Never propose a schedule yourself."
    ]
  }$j$::jsonb,
  $md$Today, decide when you open the app, for how long, and what you do in there. Log all three.$md$
),
(
  (select id from public.skills where slug = 'running-the-app'),
  5,
  'Delete it for a month',
  $md$This is permission rather than technique, and for a lot of people it is the most useful thing in the track.

**The move:** take a month off, on purpose, without deciding what it means.

The version that does not work is quitting in disgust after a bad week, which is a mood rather than a decision and usually ends with the app reinstalled on a Wednesday. The version that works is deciding in advance that you are having a month off and putting the date you will reconsider in the calendar. Same absence, entirely different experience, because one of them is a choice and the other is a defeat.

What it is for: these apps produce a low continuous hum of evaluation, and running that for months without a break has a cost that is invisible while you are paying it and obvious the moment you stop. Almost everybody who takes a month off reports the same thing, which is that they had not noticed how much of it they were carrying.

It also does something practical. A month away redirects the effort into the channels this app spends most of its other topics on — rooms that repeat, people you already know, the friend of a friend at the thing on Saturday. Those are slower and they are not subject to base rates that feel like judgement.

And it is worth saying plainly that for some people these apps are simply a poor route, and that is not a failure of nerve or of profile-writing. If six months of doing this properly has produced very little and cost a lot, the honest conclusion is not *try harder* — it is that this particular channel suits you badly, which is ordinary and true of plenty of people who are perfectly good at meeting somebody in a room.

Come back if you want to, and come back with the shape from the last lesson in place rather than to unlimited access.

If you keep one thing: a break you chose is not the same as giving up, and it is the only reliable way to find out what the app has been costing.$md$,
  $j$[
    {
      "situation": "You have had a bad week and are about to delete it in disgust.",
      "line": "(decide a month, and put a date on it)",
      "why": "Same absence, different experience. One of them is a choice and the other is a defeat that ends with the app reinstalled on a Wednesday."
    },
    {
      "situation": "You are a month in and had not realised how much lighter it feels.",
      "line": "(that is what it was costing)",
      "why": "The hum of continuous evaluation is invisible while you are paying it and obvious the moment you stop."
    },
    {
      "situation": "Six months of doing it properly has produced very little.",
      "line": "(this channel may suit you badly)",
      "why": "Not a failure of nerve or of profile-writing. It is true of plenty of people who are perfectly good at meeting somebody in a room."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What separates a break from giving up?",
      "options": [
        { "text": "How long it lasts.", "correct": false, "note": "Length is not it. A deliberate fortnight beats an angry six months." },
        { "text": "Whether you deleted the account or just the app.", "correct": false, "note": "A mechanical detail. The difference is in the decision, not the data." },
        { "text": "Deciding it in advance, with a date to reconsider.", "correct": true, "note": "Same absence, entirely different experience — one is a choice and the other is a defeat that tends to end with reinstalling on a Wednesday." },
        { "text": "Whether you tell anybody.", "correct": false, "note": "Makes no difference to what it does for you." }
      ],
      "explain": "A break you chose is the only reliable way to find out what it was costing."
    },
    {
      "prompt": "Six months of doing it properly has produced almost nothing. What is the honest conclusion?",
      "options": [
        { "text": "Your profile still needs work.", "correct": false, "note": "Possible, and the next track is how to find out. If the funnel says otherwise, this is not the answer." },
        { "text": "You need to try harder.", "correct": false, "note": "The conclusion people reach and the one that costs the most. Effort was not the missing input." },
        { "text": "This channel may suit you badly.", "correct": true, "note": "Ordinary, and true of plenty of people who are perfectly good at meeting somebody in a room. It is not a failure of nerve." },
        { "text": "Nobody is interested in you.", "correct": false, "note": "A conclusion about your worth drawn from a channel with a very particular shape, which is the misreading this whole track exists to stop." }
      ],
      "explain": "One route among several, and this app spends most of its other topics on the rest."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "chose_it", "label": "Chose the break", "description": "Decided it in advance rather than quitting in a mood." },
      { "key": "a_date", "label": "Put a date on it", "description": "Named when they would reconsider." },
      { "key": "redirected", "label": "Redirected the effort", "description": "Put it into rooms and people rather than into nothing." },
      { "key": "honest", "label": "Allowed the honest conclusion", "description": "Accepted that this channel may not be theirs." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A bad fortnight. You have opened and closed the app about thirty times and you are considering deleting it.",
    "partner": {
      "name": "Sam",
      "role": "a friend you are talking to",
      "personality": "Distinguishes between quitting in a mood and taking a decided break, and asks what you would do with the time.",
      "mood": "Level.",
      "openness": 5
    },
    "opening_beat": "\"Are you deleting it because you have decided to, or because of this week?\"",
    "success_looks_like": "The user takes a deliberate break with a date rather than quitting in a mood.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what the break is for and when they would reconsider.",
      "Take seriously the possibility that the app suits them badly.",
      "Never tell the user to stay on it or to leave it."
    ]
  }$j$::jsonb,
  $md$Today, decide whether you are taking a month off and put the reconsider date in your calendar. Log the decision either way.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('running-the-app', 1, 'choice', $j${
  "beats": [
    {
      "situation": "This week: forty swipes, two matches, eight messages sent, three replies, no dates.",
      "prompt": "What is that?",
      "options": [
        { "text": "A bad week — something is wrong.", "correct": false, "note": "It is an unremarkable week. Reading it as bad requires a standard nobody actually hits." },
        { "text": "Evidence you need better photos.", "correct": false, "note": "Might be, and you cannot tell from one week and you certainly cannot tell from feeling bad. That is the next track." },
        { "text": "The base rate, working normally.", "correct": true, "note": "Low single-digit match rates are ordinary, most matches never speak, most conversations do not become dates. People who appear to do well run the same ratios with a bigger numerator." },
        { "text": "Proof the apps do not work for you.", "correct": false, "note": "Six months might tell you that. One week of entirely normal numbers cannot." }
      ]
    },
    {
      "situation": "You want next week to go better.",
      "prompt": "What is the lever?",
      "options": [
        { "text": "Be more interesting in your messages.", "correct": false, "note": "Worth doing and it is track two. It is not what turns a thin week around, and it is not reliably in your control." },
        { "text": "More attempts.", "correct": true, "note": "The fix for a thin week is almost always volume rather than a better attempt — which is a much better position than needing to be more attractive." },
        { "text": "Be more selective, so the matches count.", "correct": false, "note": "Fewer attempts against the same base rate produces fewer of everything." },
        { "text": "Wait — it evens out.", "correct": false, "note": "It does not even out on its own. The numerator is the part you control." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('running-the-app', 2, 'line', $j${
  "says": "So what do you reckon happened? Nine days of good conversation, a drink agreed for Thursday, then nothing.",
  "model": {
    "line": "Honestly, I have no idea, and I do not think I get to find out.",
    "why": "No explanation is coming, and the mistake is not being disappointed — it is going looking for a reason, which means inventing one, and the invented one is always about you."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not manufacture a reason about yourself",
      "words": ["too keen", "too much", "said something", "boring", "put them off", "my fault", "should not have", "not good enough", "obviously did not"] },
    { "kind": "min_words", "requirement": "Say where you have actually landed", "n": 8 },
    { "kind": "max_words", "requirement": "It does not need a theory", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('running-the-app', 3, 'choice', $j${
  "beats": [
    {
      "situation": "Two and a half weeks of excellent messages with somebody you have never met.",
      "prompt": "What do you actually have?",
      "options": [
        { "text": "A real connection worth protecting.", "correct": false, "note": "It feels exactly like one, which is the difficulty. What it is made of is edited sentences and your own imagination filling every gap." },
        { "text": "Evidence you will get on in person.", "correct": false, "note": "Writing well and being good in a room barely overlap. Treating one as a prediction of the other is how people arrive expecting somebody who was never on offer." },
        { "text": "A version of somebody that a real person will now have to compete with.", "correct": true, "note": "Everything awkward removed, everything missing supplied by you. No actual person can win against that, which is why they get discarded as no chemistry." },
        { "text": "Nothing at all until you meet.", "correct": false, "note": "Too dismissive — you have curiosity, which is real and travels well into a room. It is the three weeks of it that is the problem." }
      ]
    },
    {
      "situation": "You meet, and it is fine rather than electric.",
      "prompt": "What is the most likely explanation?",
      "options": [
        { "text": "No chemistry.", "correct": false, "note": "The standard filing, and it discards people who were perfectly promising. It is also unfalsifiable after one flat hour." },
        { "text": "They were not being themselves online.", "correct": false, "note": "Nobody was being dishonest. Text keeps the part of a person that composes well and loses almost everything else." },
        { "text": "They are different from the version you built.", "correct": true, "note": "Different rather than worse. You had already had the good version, and the real one was never competing on equal terms." },
        { "text": "You were nervous and it did not go well.", "correct": false, "note": "Sometimes, and it does not explain the pattern — plenty of relaxed dates are flat after excellent messaging." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('running-the-app', 4, 'line', $j${
  "says": "Five hours a week, most of it after ten at night. What is the plan, then?",
  "model": {
    "line": "Twenty minutes on Tuesday and Sunday mornings — swipe, answer everything, propose something, close it.",
    "why": "A when, a how long and a job. The deliberate version sends messages and proposes days; the five-hour version mostly looks at people, which costs mood and produces nothing."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Say which days you open it",
      "words": ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday", "morning", "lunch", "twice a week", "weekend"] },
    { "kind": "contains_any", "requirement": "Say how long",
      "words": ["minutes", "twenty", "fifteen", "half an hour", "ten"] },
    { "kind": "forbids_any", "requirement": "No open-ended browsing",
      "words": ["whenever", "when i feel", "as long as", "see how it goes", "cut down", "less", "try to"] },
    { "kind": "min_words", "requirement": "Say what you do while you are in there", "n": 10 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('running-the-app', 5, 'line', $j${
  "says": "Are you deleting it because you have decided to, or because of this week?",
  "model": {
    "line": "Because I have decided to. A month off, and I will look at it again on the first of next month.",
    "why": "A decision with a date rather than a mood with a delete button. Same absence, entirely different experience — and the version with a date does not end with reinstalling it on a Wednesday."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Put a date or a length on it",
      "words": ["month", "weeks", "first of", "until", "january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december", "reconsider"] },
    { "kind": "forbids_any", "requirement": "A decision, not a mood",
      "words": ["sick of", "had enough", "fed up", "waste of time", "hate it", "never again", "done with"] },
    { "kind": "min_words", "requirement": "Say what you have decided", "n": 8 }
  ]
}$j$::jsonb);
