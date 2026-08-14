-- Hard conversations, track 1: Whether to have it at all.
--
-- The shop window, and it leads on the diagnosis rather than a technique. The
-- reader arriving at this topic is not mid-conversation — they are four weeks
-- into rehearsing one, and no amount of phrasing advice reaches somebody who
-- is still getting ready.
--
-- All free. Nothing here happens in a room with anybody; it is five decisions
-- made on your own.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'worth-having'),
  1,
  'Rehearsal is not preparation',
  $md$Four weeks of running it in the shower, in the car, at three in the morning. Each version slightly sharper. Each one ending with them realising you were right.

That is not preparation and it is worth being direct about it: it is avoidance with a productive feeling attached.

**The move:** notice that the rehearsing is the avoidance, and stop counting it as work.

Three things it is doing, none of them good. It is making you more invested in a script the other person has never read — so when they say something outside it, which they will, you will be improvising in a conversation you have somehow already had forty times. It is making you more certain of their answer, and that certainty is entirely manufactured, because you have been playing both parts. And it is discharging just enough of the feeling to keep you from acting, which is why a month can pass without the pressure ever getting high enough to force it.

There is a specific tell that separates preparation from rehearsal. Preparation asks *what do I want to say and what do I want to happen.* Rehearsal asks *and then what do they say, and then what do I say.* The first takes about four minutes and is genuinely useful. The second has no end, and its real function is to postpone.

There is also a cost that only shows up on the day. A month-old script does not survive contact, and somebody who has over-rehearsed frequently performs it — delivering lines with a slightly odd, prepared quality that reads as coldness, because it is not being said to the person in front of them. It is being recited at a person who has been in their head for weeks.

If you keep one thing: four minutes of preparation beats four weeks of rehearsal, and everything past the four minutes is the thing you are doing instead of having the conversation.$md$,
  $j$[
    {
      "situation": "You have run it in the shower every morning for three weeks.",
      "line": "(that is the avoidance, not the preparation)",
      "why": "It discharges just enough of the feeling to keep the pressure from ever getting high enough to force the conversation."
    },
    {
      "situation": "You know exactly what they will say back.",
      "line": "(you have been playing both parts)",
      "why": "The certainty is manufactured. You have rehearsed against a version of them you invented, and the real one will say something outside the script."
    },
    {
      "situation": "You want to prepare properly.",
      "line": "(what do I want to say, and what do I want to happen)",
      "why": "Four minutes, and genuinely useful. And then what do they say has no end, which is what makes it the postponing version."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What separates preparation from rehearsal?",
      "options": [
        { "text": "How long you spend on it.", "correct": false, "note": "Length is the symptom. Rehearsal takes longer because it has no natural end, which is a consequence of its shape." },
        { "text": "Whether you write it down.", "correct": false, "note": "Writing helps and either can be written. Plenty of people script a rehearsal in a notes app." },
        { "text": "Whether you are simulating their replies.", "correct": true, "note": "What do I want to say and what do I want to happen takes four minutes. And then what do they say has no end, and its function is to postpone." },
        { "text": "Whether you feel calmer afterwards.", "correct": false, "note": "Rehearsal reliably makes people feel calmer, which is exactly the problem — it discharges the pressure that would otherwise force the conversation." }
      ],
      "explain": "Four minutes on your half. The other half is not knowable and is not yours to write."
    },
    {
      "prompt": "What does a month of it cost on the day?",
      "options": [
        { "text": "You will have forgotten the details.", "correct": false, "note": "The opposite — the details are extremely sharp, and that is part of the problem." },
        { "text": "You will be too angry.", "correct": false, "note": "Sometimes, and rehearsal more often flattens the feeling than raises it." },
        { "text": "Nothing — you will be well prepared.", "correct": false, "note": "This is what it feels like from inside the fourth week, and it is why the month happens." },
        { "text": "You perform it, and being recited at reads as coldness.", "correct": true, "note": "A month-old script does not survive contact, and it is not being said to the person in front of you — it is being said to the one who has been in your head." }
      ],
      "explain": "The version in your head has had forty conversations. The person has had none."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "noticed", "label": "Noticed the rehearsing", "description": "Recognised it as avoidance rather than work." },
      { "key": "four_minutes", "label": "Prepared their half only", "description": "Decided what to say and what they want, and stopped." },
      { "key": "no_simulation", "label": "Stopped simulating their replies", "description": "Did not script the other person." },
      { "key": "moved", "label": "Moved towards having it", "description": "Turned the time into a decision rather than another round." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A friend has asked about the thing you have been going on about for a month, and noticed you still have not said anything to the person involved.",
    "partner": {
      "name": "Sam",
      "role": "a friend you have been talking to about this for weeks",
      "personality": "Kind and slightly exasperated. Asks how many times you have run it through, and what you are waiting to feel.",
      "mood": "Fond, direct.",
      "openness": 5
    },
    "opening_beat": "\"How long have you been working out how to say this now?\"",
    "success_looks_like": "The user recognises the rehearsal as avoidance rather than preparation.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what they are waiting to feel before they will be ready.",
      "Take seriously any decision to have it this week.",
      "Never tell the user what to say in the conversation itself."
    ]
  }$j$::jsonb,
  $md$Today, count how many times you have rehearsed one conversation. Then spend four minutes on your half only. Log both numbers.$md$
),
(
  (select id from public.skills where slug = 'worth-having'),
  2,
  'What change do you want?',
  $md$Before anything else, one question, and it is more useful than any amount of phrasing: what would you like to be different afterwards?

**The move:** name the specific change, or admit there is not one.

If you can name it — *I would like to know before you cancel, rather than an hour after we were supposed to meet* — you have a conversation with a shape, and everything else in this topic will work on it.

If you cannot, that is not a failure and it is important information. It usually means one of three things, and they need completely different handling.

**You want them to feel something.** To understand what it was like, to be sorry, to sit with it. That is human and it is not an ask, because nobody can be made to feel a thing on request. A conversation aimed at it produces an argument about whether they are sorry enough.

**You want to say it, and that is all.** Also legitimate, and it goes much better when you know that is what it is. *I am not asking you to do anything, I just did not want to be carrying this quietly* is an honest opening and it removes the pressure on them to produce a solution to a thing that is not a problem.

**You want the relationship to be different.** Vaguer and heavier, and it usually decomposes into two or three specific changes once you sit with it for ten minutes. Doing that decomposing before the conversation is most of the work.

The reason this matters more than it seems: a conversation with no ask has no way to end. It runs until somebody is tired, and both people leave without knowing whether anything happened — which is how one hard conversation becomes four.

If you keep one thing: name the thing they could do differently on Thursday. If there is nothing, say what it is instead.$md$,
  $j$[
    {
      "situation": "You are angry and you know what about, but not what you want.",
      "line": "(then work that out first)",
      "why": "A conversation with no ask has no way to end. It runs until somebody is tired and both leave not knowing whether anything happened."
    },
    {
      "situation": "What you want is for them to feel bad about it.",
      "line": "(that is not an ask, and it cannot be delivered)",
      "why": "Nobody can be made to feel a thing on request. Aimed at it, the conversation becomes an argument about whether they are sorry enough."
    },
    {
      "situation": "You just want it said.",
      "line": "I am not asking you to do anything, I just did not want to carry it quietly.",
      "why": "Honest, and it removes the pressure on them to produce a solution to something that is not a problem to be solved."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does a conversation with no ask go badly?",
      "options": [
        { "text": "It has no way to end.", "correct": true, "note": "It runs until somebody is tired, and both people leave without knowing whether anything happened — which is how one hard conversation becomes four." },
        { "text": "It sounds like complaining.", "correct": false, "note": "It can, and plenty of well-received conversations are complaints with a request attached." },
        { "text": "They will not take it seriously.", "correct": false, "note": "They often take it very seriously and have nothing to do with it, which is a different and more frustrating problem." },
        { "text": "You will not feel better.", "correct": false, "note": "Sometimes you will. The structural problem is what happens in the room rather than afterwards." }
      ],
      "explain": "Name the thing they could do differently on Thursday."
    },
    {
      "prompt": "You want them to understand how it felt. What is that?",
      "options": [
        { "text": "A perfectly good aim for the conversation.", "correct": false, "note": "Human and unachievable as an ask, because nobody can be made to feel something on request." },
        { "text": "A sign you should not have it.", "correct": false, "note": "Not at all — it is a sign you should know what you are doing, which is a different conversation with a different opening." },
        { "text": "Something to say out loud as what it is.", "correct": true, "note": "I am not asking you to do anything, I just did not want to be carrying this. That is honest and it removes the pressure to solve something unsolvable." },
        { "text": "A change you want, phrased vaguely.", "correct": false, "note": "It sounds like one and it is not — there is no action on the other end of it." }
      ],
      "explain": "Wanting to say it is legitimate. It just goes much better when you know that is what it is."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named", "label": "Named the change", "description": "Said what could be different afterwards." },
      { "key": "specific", "label": "Made it actionable", "description": "Something they could do differently rather than feel differently." },
      { "key": "honest", "label": "Was honest when there was none", "description": "Said it was about being heard rather than inventing an ask." },
      { "key": "decomposed", "label": "Broke down the vague version", "description": "Turned a relationship-level want into specific changes." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A friend is helping you work out what you actually want from a conversation you keep not having about somebody cancelling plans.",
    "partner": {
      "name": "Sam",
      "role": "a friend helping you think it through",
      "personality": "Keeps asking what would be different afterwards, and does not accept feelings about the other person as an answer to it.",
      "mood": "Patient.",
      "openness": 5
    },
    "opening_beat": "\"Right. Say it goes perfectly. What is actually different on Monday?\"",
    "success_looks_like": "The user names a specific change or admits honestly that there is not one.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what would be different afterwards whenever the answer is about how they feel.",
      "Accept I just want to say it as a good answer if it is arrived at honestly.",
      "Never suggest an ask for the user."
    ]
  }$j$::jsonb,
  $md$Today, write one sentence naming what you want to be different after a conversation you have been avoiding. Log the sentence.$md$
),
(
  (select id from public.skills where slug = 'worth-having'),
  3,
  'What the silence costs',
  $md$The decision not to have it feels free, and that is why it keeps getting made.

It is not free. It is simply paid on a schedule long enough that nobody attributes the cost to the decision. Six months later there is a friendship that has thinned, a colleague you have quietly stopped going to, or a partner who has no idea why you have been slightly further away since spring — and none of those get filed as consequences of a conversation nobody had.

**The move:** price the silence before comparing it to the conversation.

The comparison people actually run is between an uncomfortable half hour and nothing. Under that comparison, nothing wins every time, and it will keep winning every time it is offered — which is why the conversation gets postponed indefinitely rather than declined once.

The real comparison is between an uncomfortable half hour and what the swallowing does over a year. And it does three things reliably.

**It converts.** Unspoken irritation does not stay at its original size or in its original shape. It becomes a general feeling about the person, then a slight reluctance to make plans, then an explanation you have constructed about what they are like.

**It leaks.** People are not good at carrying something without showing it. It comes out as shortness, as a joke with an edge, as a withdrawal the other person can feel and cannot name — and being on the receiving end of that is worse than being told the actual thing.

**It removes their chance.** This is the part worth being fair about. Somebody who has not been told cannot fix it, cannot apologise, and cannot decide it matters to them. Silence looks like protecting them and it is closer to sentencing them.

If you keep one thing: silence is not neutral. It is a slower payment on the same debt, made in a currency you like less.$md$,
  $j$[
    {
      "situation": "It feels easier to say nothing.",
      "line": "(compared to what?)",
      "why": "The comparison people run is a bad half hour against nothing, and nothing wins every time it is offered — which is why it gets postponed rather than declined."
    },
    {
      "situation": "You have started making fewer plans with them.",
      "line": "(that is the conversion, six months in)",
      "why": "Unspoken irritation does not stay its original size. It becomes a general feeling, then a reluctance, then a theory about what they are like."
    },
    {
      "situation": "You are protecting them by not saying it.",
      "line": "(they cannot fix a thing they have not been told)",
      "why": "Silence looks like protection and is closer to sentencing. They cannot apologise, cannot change it, and cannot decide whether it matters to them."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does staying quiet keep winning?",
      "options": [
        { "text": "Because people are conflict-avoidant.", "correct": false, "note": "A description of who does it rather than why the decision comes out that way each time." },
        { "text": "Because the comparison being run is a bad half hour against nothing.", "correct": true, "note": "Under that comparison nothing wins every time it is offered, which is why it is postponed indefinitely rather than declined once." },
        { "text": "Because the problem usually resolves itself.", "correct": false, "note": "It usually converts rather than resolves — into distance, which is not the same as being fixed." },
        { "text": "Because saying it might make things worse.", "correct": false, "note": "The stated fear, and it is not what makes the decision automatic." }
      ],
      "explain": "Price the silence, then compare. It is a slower payment on the same debt."
    },
    {
      "prompt": "What is the part people miss about staying quiet?",
      "options": [
        { "text": "It will come out eventually anyway.", "correct": false, "note": "Often true, and it frames the cost as a delayed explosion rather than what is happening in the meantime." },
        { "text": "It makes you resentful.", "correct": false, "note": "True, and it is the cost to you. There is one to them that is easier to overlook." },
        { "text": "It leaks as shortness they can feel and cannot name.", "correct": false, "note": "Real, and it is the second of three. The one people miss entirely is about their options." },
        { "text": "It removes their chance to fix it.", "correct": true, "note": "Somebody who has not been told cannot apologise, cannot change it, and cannot decide whether it matters to them. That looks like protection and is closer to a sentence." }
      ],
      "explain": "Not telling somebody is a decision made on their behalf about a thing that is theirs."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "priced", "label": "Priced the silence", "description": "Compared the conversation to a year of not having it." },
      { "key": "noticed_conversion", "label": "Noticed the conversion", "description": "Saw how the feeling had already changed shape." },
      { "key": "noticed_leak", "label": "Noticed the leak", "description": "Recognised what was showing without being said." },
      { "key": "their_chance", "label": "Considered their side", "description": "Saw that silence removes their ability to fix it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Six months of not saying something, and a friend has just observed that you seem to see that person a lot less than you used to.",
    "partner": {
      "name": "Sam",
      "role": "a friend who has noticed the drift",
      "personality": "Observant and unsentimental. Points at what has actually changed in your behaviour rather than at your feelings.",
      "mood": "Straightforward.",
      "openness": 5
    },
    "opening_beat": "\"You used to see them every couple of weeks. When did that stop?\"",
    "success_looks_like": "The user connects the drift to the conversation they have not had.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Name changes in behaviour rather than interpreting feelings.",
      "Ask what the other person knows about any of this.",
      "Never tell the user to have the conversation."
    ]
  }$j$::jsonb,
  $md$Today, name one thing you have swallowed and what it has already changed about how you behave towards that person. Log both.$md$
),
(
  (select id from public.skills where slug = 'worth-having'),
  4,
  'Letting it go, properly',
  $md$Not everything is worth a conversation, and deciding that is a legitimate outcome of this track rather than a failure of it.

But there are two versions of letting go and only one of them works.

**The move:** decide it is dropped, and then behave as though it is.

The real version is a decision. You have looked at it, concluded the change you would want is not worth the conversation, and you are now going to treat the matter as closed — which means not bringing it up, not alluding to it, and not keeping it in reserve.

The other version is what most people do: deciding not to raise it while continuing to hold it. That is not letting go, it is storage, and stored things behave badly. They accumulate, they attach themselves to new instances, and they eventually arrive in a conversation that was about something else — usually in the form *and another thing*, which is the sound of eleven months of storage being unloaded onto somebody who thought they were discussing the washing up.

The test for which one you have done is simple and slightly uncomfortable. If it happened again next week, would you be at zero or would you be at three? Genuine letting go resets you. Storage means the next instance arrives on top of a stack, and you will react to the stack while appearing to react to the instance.

There is a second test worth applying a month later: are you still thinking about it? Some things cannot be let go of by deciding, and finding that out is useful — it means the answer to the first question in this track was actually yes, and you would rather know that at one month than at one year.

And be honest about scale. Small recurring things are frequently better raised than dropped, precisely because they are small: a two-minute conversation about a two-minute problem is easy, and the same conversation after a year is about the year rather than the problem.

If you keep one thing: dropped means you would be at zero next time. If you would be at three, you did not drop it — you filed it.$md$,
  $j$[
    {
      "situation": "You have decided not to raise something.",
      "line": "(would you be at zero if it happened next week?)",
      "why": "Genuine letting go resets you. If the answer is three, you did not drop it — you filed it, and it will arrive later attached to something else."
    },
    {
      "situation": "It has been a month and you are still thinking about it.",
      "line": "(then it was not droppable)",
      "why": "Useful information rather than a failure. It means the honest answer to whether it matters was yes, and one month is a much better time to learn that than one year."
    },
    {
      "situation": "It is a small thing that keeps happening.",
      "line": "(small is the argument for raising it, not against)",
      "why": "A two-minute conversation about a two-minute problem is easy. The same conversation a year later is about the year."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the test for whether you actually let it go?",
      "options": [
        { "text": "Whether you still feel annoyed.", "correct": false, "note": "Feelings fade on their own schedule and can fade while the thing is still stored." },
        { "text": "Whether you would be at zero if it happened again next week.", "correct": true, "note": "Genuine letting go resets you. Storage means the next instance lands on a stack, and you react to the stack while appearing to react to the instance." },
        { "text": "Whether you have stopped talking about it to other people.", "correct": false, "note": "A decent sign and easy to achieve while still holding it." },
        { "text": "Whether you could raise it calmly now.", "correct": false, "note": "Being able to raise it calmly is a good state and is not the same as having dropped it." }
      ],
      "explain": "Dropped means the counter is at zero. Filed means it is waiting."
    },
    {
      "prompt": "Something small keeps happening. What does small argue for?",
      "options": [
        { "text": "Letting it go — it is not worth a conversation.", "correct": false, "note": "It is not worth a big one, which is the argument for having a small one now rather than a big one later." },
        { "text": "Waiting to see if there is a pattern.", "correct": false, "note": "Watching for a pattern is storage with a research budget, and the conversation you eventually have is about the pattern rather than the thing." },
        { "text": "Raising it, because it is small.", "correct": true, "note": "A two-minute conversation about a two-minute problem is easy. The same conversation after a year is about the year rather than the problem." },
        { "text": "Mentioning it in passing, lightly.", "correct": false, "note": "Close, and in passing tends to mean without an ask, which is the version that gets heard as a mood." }
      ],
      "explain": "Size is the argument for speed. Small things get expensive by being stored."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "decided", "label": "Actually decided", "description": "Made a real decision rather than a postponement." },
      { "key": "at_zero", "label": "Reset to zero", "description": "Would start from nothing if it recurred." },
      { "key": "no_storage", "label": "Did not file it", "description": "Kept nothing in reserve for a future conversation." },
      { "key": "checked_later", "label": "Checked a month later", "description": "Noticed whether it was still there." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have decided to let something go, and a friend is asking what that means in practice.",
    "partner": {
      "name": "Sam",
      "role": "a friend testing whether you have really dropped it",
      "personality": "Asks what happens if it occurs again next week, and notices the difference between dropped and stored.",
      "mood": "Curious.",
      "openness": 5
    },
    "opening_beat": "\"Fine — you are letting it go. What happens if they do it again on Friday?\"",
    "success_looks_like": "The user establishes whether they have dropped it or filed it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what the reaction would be to a recurrence.",
      "Point out gently when an answer describes storage rather than release.",
      "Never tell the user which one to do."
    ]
  }$j$::jsonb,
  $md$Today, take one thing you decided to let go and check whether you would be at zero next time. Log the honest answer.$md$
),
(
  (select id from public.skills where slug = 'worth-having'),
  5,
  'Put a date on it',
  $md$Everything in this track resolves to one of two answers, and both of them are decisions. What is not a decision is the state almost everybody is actually in, which is *soon*.

**The move:** name the day you are having it, or say out loud that you are not having it.

*Soon* is where hard conversations go to live indefinitely. It is not a plan and it never becomes one, because there is no moment at which soon arrives — every individual day is a bad day for it, and each of those judgements is correct on its own terms.

A date solves that in a way no amount of resolve does. *Thursday evening* is a thing you either did or did not do, and it converts a feeling into an appointment. It also puts a floor under the rehearsing: the loop only runs until Thursday, and knowing that makes the week before considerably easier than an open-ended one.

Sooner is better and it is not only about courage. Recency is doing real work — a conversation about something that happened last week is about that thing, while the same conversation four months later is about four months, and the other person will quite reasonably ask why they are only hearing it now. That question has no good answer and it changes the subject to your silence.

If the honest answer is that you are not having it, say that out loud too, to yourself or to somebody else, and then apply the previous lesson properly. What you cannot do is leave it in *soon*, because that is the option that costs the most: you get all the discomfort of carrying it and none of whatever the conversation might have produced.

And put it in the calendar rather than in your head. That sounds excessive for something you could arrange in one message, and the excess is the point — a thing with a date attached gets done, and a thing with an intention attached is what you have already had for four weeks.

If you keep one thing: a day, or a decision not to. Soon is the one answer that is not an answer.$md$,
  $j$[
    {
      "situation": "You have decided to have it, soon.",
      "line": "(soon is not a plan)",
      "why": "There is no moment at which soon arrives. Every individual day is a bad day for it, and each of those judgements is correct on its own terms."
    },
    {
      "situation": "You are waiting for a good moment.",
      "line": "(name Thursday)",
      "why": "A date converts a feeling into an appointment, and it puts a floor under the rehearsing — the loop only has to run until Thursday."
    },
    {
      "situation": "It happened four months ago.",
      "line": "(now it is about the four months)",
      "why": "They will ask why they are only hearing it now, and that question has no good answer. It changes the subject to your silence."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does soon never arrive?",
      "options": [
        { "text": "Because you keep losing your nerve.", "correct": false, "note": "Nerve is the story. The mechanism is that no particular day is ever the right one." },
        { "text": "Because every individual day is a bad day for it.", "correct": true, "note": "And each of those judgements is correct on its own terms, which is why the sequence of correct decisions produces four months of nothing." },
        { "text": "Because you are not angry enough.", "correct": false, "note": "Waiting to be angry enough is a plan to have the conversation at your worst." },
        { "text": "Because the moment has to feel right.", "correct": false, "note": "That belief is part of the trap rather than an explanation of it." }
      ],
      "explain": "A date is a thing you either did or did not do. Soon cannot be checked."
    },
    {
      "prompt": "Why does delay change what the conversation is about?",
      "options": [
        { "text": "Memories get less reliable.", "correct": false, "note": "True and secondary. Both of you will remember the substance well enough." },
        { "text": "The feeling gets bigger.", "correct": false, "note": "It converts rather than grows, and that is the previous lesson's business." },
        { "text": "They will ask why they are only hearing it now.", "correct": true, "note": "A question with no good answer, and answering it moves the subject from the thing to your silence about the thing." },
        { "text": "They will have forgotten.", "correct": false, "note": "Occasionally, and being reminded is a small obstacle rather than a change of subject." }
      ],
      "explain": "Last week's conversation is about the thing. Four months later it is about four months."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "a_date", "label": "Named a day", "description": "Committed to when rather than to soon." },
      { "key": "in_calendar", "label": "Wrote it down", "description": "Put it somewhere other than their head." },
      { "key": "soon", "label": "Refused soon", "description": "Did not leave it in the indefinite state." },
      { "key": "or_dropped", "label": "Or said no out loud", "description": "Made the other decision explicitly rather than by default." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have worked out what you want to say and what you want to change. It is Sunday.",
    "partner": {
      "name": "Sam",
      "role": "a friend you have been talking it through with",
      "personality": "Asks for a day and will not accept soon, this week, or when the moment is right.",
      "mood": "Warm and immovable on this one point.",
      "openness": 5
    },
    "opening_beat": "\"Good. When?\"",
    "success_looks_like": "The user names an actual day or says clearly they are not doing it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask again for a specific day if given soon, this week, or when it comes up.",
      "Accept a clear decision not to have it as a real answer.",
      "Never suggest a day yourself."
    ]
  }$j$::jsonb,
  $md$Today, put a date in your calendar for one conversation you have been putting off — or write down that you are not having it. Log which.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('worth-having', 1, 'choice', $j${
  "beats": [
    {
      "situation": "Three weeks of running the conversation in the shower. Each version slightly sharper, and each one ending with them realising you were right.",
      "prompt": "What have those three weeks been?",
      "options": [
        { "text": "Preparation — you will be much clearer when it happens.", "correct": false, "note": "Clear about a script the other person has not read. When they say something outside it you will be improvising in a conversation you have already had forty times." },
        { "text": "Avoidance with a productive feeling attached.", "correct": true, "note": "It discharges just enough of the feeling to stop the pressure ever getting high enough to force it, which is how a month passes." },
        { "text": "Processing — you needed to work out how you felt.", "correct": false, "note": "That takes an evening. Three weeks of sharpening is a different activity with a different function." },
        { "text": "Waiting for the right moment.", "correct": false, "note": "Also true and also not an explanation. No moment is coming, which is the last lesson in this track." }
      ]
    },
    {
      "situation": "You want to actually prepare rather than rehearse.",
      "prompt": "What does preparation consist of?",
      "options": [
        { "text": "Working out what they are likely to say, and your answers.", "correct": false, "note": "That is the rehearsal, and it has no end. You are playing both parts, so the certainty it produces is manufactured." },
        { "text": "Writing it down word for word so you do not lose it.", "correct": false, "note": "A script gets performed, and being recited at reads as coldness — it is not being said to the person in front of you." },
        { "text": "What I want to say, and what I want to happen.", "correct": true, "note": "Four minutes, and genuinely useful. Your half is the only half you can prepare." },
        { "text": "Deciding how you will react if they get upset.", "correct": false, "note": "Worth knowing in principle — it is track four — and simulating it in advance is the loop again." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('worth-having', 2, 'line', $j${
  "says": "Right. Say it goes perfectly. What is actually different on Monday?",
  "model": {
    "line": "They tell me when they are going to cancel, rather than an hour after we were supposed to meet.",
    "why": "A thing somebody could do differently on Thursday. Without one the conversation has no way to end — it runs until somebody is tired and neither of you knows whether anything happened."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Something they could do, not something they could feel",
      "words": ["realise", "understand how", "feel bad", "be sorry", "appreciate", "know how much", "take me seriously", "respect me"] },
    { "kind": "min_words", "requirement": "Name the actual change", "n": 8 },
    { "kind": "max_words", "requirement": "One sentence", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('worth-having', 3, 'choice', $j${
  "beats": [
    {
      "situation": "Six months of saying nothing. You now see them about a third as often and have stopped suggesting things.",
      "prompt": "What is that?",
      "options": [
        { "text": "You have just got busier.", "correct": false, "note": "The explanation available to you, and it is worth noticing that it arrived at the same time as the thing you did not say." },
        { "text": "The friendship running its natural course.", "correct": false, "note": "Nothing natural about it. A specific unsaid thing converted into a general reluctance, on a schedule slow enough to hide the cause." },
        { "text": "The silence being paid for, in instalments.", "correct": true, "note": "Unspoken irritation does not stay its original size. It becomes a feeling about the person, then a reluctance, then a theory about what they are like." },
        { "text": "Evidence you were right about them.", "correct": false, "note": "The theory arriving on schedule. You built it out of six months of a thing they were never told about." }
      ]
    },
    {
      "situation": "You have been staying quiet partly to protect them from an awkward conversation.",
      "prompt": "What does that actually do to them?",
      "options": [
        { "text": "Spares them something unpleasant.", "correct": false, "note": "It spares them thirty minutes and costs them the relationship changing shape without their knowledge." },
        { "text": "Nothing — they are unaffected.", "correct": false, "note": "They are on the receiving end of somebody who has quietly withdrawn, which is felt and cannot be named." },
        { "text": "Removes their chance to do anything about it.", "correct": true, "note": "They cannot apologise, cannot change it, and cannot decide whether it matters to them. That looks like protection and is closer to a sentence." },
        { "text": "Keeps the peace for both of you.", "correct": false, "note": "It keeps a surface. Underneath it one person is drifting and the other does not know why." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('worth-having', 4, 'line', $j${
  "says": "Fine — you are letting it go. What happens if they do it again on Friday?",
  "model": {
    "line": "Honestly, I would be furious. So I have not let it go, I have just decided not to mention it.",
    "why": "The test, answered honestly. Genuine letting go resets you to zero; storage means the next instance lands on a stack and you react to the stack while appearing to react to the instance."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Say what you would actually feel" },
    { "kind": "forbids_any", "requirement": "Do not claim a peace you have not got",
      "words": ["would be fine", "no problem", "would not bother me", "over it", "water under", "moved on", "does not matter"] },
    { "kind": "min_words", "requirement": "Answer the test rather than the question", "n": 10 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('worth-having', 5, 'line', $j${
  "says": "Good. When?",
  "model": {
    "line": "Thursday evening, after work. I will message them tomorrow to ask.",
    "why": "A day rather than an intention, which converts a feeling into an appointment — and puts a floor under the rehearsing, because the loop only has to run until Thursday."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Name an actual day",
      "words": ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday", "tomorrow", "tonight", "weekend"] },
    { "kind": "forbids_any", "requirement": "Soon is the one answer that is not an answer",
      "words": ["soon", "this week sometime", "at some point", "when i see", "next time", "when the moment", "when it comes up", "when i feel ready"] },
    { "kind": "max_words", "requirement": "A date, not a plan for a plan", "n": 25 }
  ]
}$j$::jsonb);
