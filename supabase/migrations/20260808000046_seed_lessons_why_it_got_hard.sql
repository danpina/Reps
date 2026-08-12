-- Making friends, track 1: Why it got hard.
--
-- The topic's shop window, and it leads on the reframe rather than on a
-- technique, because the reader arriving here has usually decided the problem
-- is a defect in them. Nothing in this track is a conversation — it is all
-- infrastructure — so every lesson is a line or choice drill and there is not
-- a scene in it.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'why-it-got-hard'),
  1,
  'It was the building, not you',
  $md$It used to be easy. It is not now. Nothing about you has obviously changed, and the conclusion almost everybody draws from that is the wrong one.

Here is what actually changed. At school and at university you were placed, involuntarily, in a building full of the same people, every day, for years, with long stretches of unstructured time and nothing at stake. Nobody in that building was good at making friends. The building was doing it.

**The move:** stop reading the difficulty as a fact about you, and start reading it as a fact about your week.

Adult life removes the input and removes it quickly. You see colleagues constantly, always with a purpose and usually with a task between you. You see existing friends occasionally, always by arrangement, and increasingly rarely. What has gone is the middle: unplanned time, with the same faces, repeatedly, for no reason.

That is a supply problem, and it explains something that otherwise makes no sense — that people who are objectively good company, funny, kind and well liked at work, still end up with nobody to call on a Sunday. Being good at people was never what produced friendships. Proximity was.

It is worth sitting with the version of this that is unflattering to the story you may be telling: you have probably not got worse. You are running the same social ability in an environment that stopped supplying the one input it depended on, and the output dropped accordingly.

And the reason this matters practically rather than just as comfort: if the problem were you, the fix would be becoming a different person, which is slow and mostly does not work. If the problem is the week, the fix is changing the week, which is a much smaller and more available act.

If you keep one thing: you do not have a friendship problem, you have an infrastructure problem.$md$,
  $j$[
    {
      "situation": "You have concluded you have got worse at this since university.",
      "line": "(the building was doing it)",
      "why": "Nobody in that building was good at making friends. It supplied the same people, daily, for years, with nothing at stake — and it stopped."
    },
    {
      "situation": "You are well liked at work and have nobody to call on a Sunday.",
      "line": "(that is a supply problem, not a likeability problem)",
      "why": "Being good company was never what produced friendships. Proximity was, and colleagues are proximity with a task in the middle."
    },
    {
      "situation": "You are trying to become more outgoing.",
      "line": "(change the week instead)",
      "why": "If the problem were you, the fix would be becoming a different person, which is slow and mostly does not work. Changing your week is available this month."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What actually changed after university?",
      "options": [
        { "text": "You got busier and had less time.", "correct": false, "note": "Time is part of it and not the mechanism. Plenty of very busy people at university made friends constantly." },
        { "text": "People became less open to new friends.", "correct": false, "note": "Mostly untrue, and it is the story that makes the problem feel closed. Most adults would like another good friend." },
        { "text": "The unplanned repeated contact stopped.", "correct": true, "note": "The same people, every day, for years, with nothing at stake. Nobody in that building was good at making friends — the building was doing it." },
        { "text": "You stopped making the effort.", "correct": false, "note": "Usually the opposite: people try much harder now and get much less, which is exactly what makes them conclude the fault is theirs." }
      ],
      "explain": "It was infrastructure, and it was removed without anybody announcing it."
    },
    {
      "prompt": "Why does the reframe matter practically?",
      "options": [
        { "text": "Because it is kinder to yourself.", "correct": false, "note": "It is, and comfort is not why it is in the topic." },
        { "text": "Because it changes what the fix is.", "correct": true, "note": "If the problem is you, the fix is becoming a different person — slow and mostly ineffective. If it is your week, the fix is changing your week, which is available this month." },
        { "text": "Because it means nothing is wrong.", "correct": false, "note": "Something is wrong: you have no infrastructure. It is just not a defect." },
        { "text": "Because confidence follows understanding.", "correct": false, "note": "Sometimes, and this is not a confidence intervention. It is a diagnosis that points at a different action." }
      ],
      "explain": "A different diagnosis produces a different and much smaller job."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "reframed", "label": "Read it as infrastructure", "description": "Stopped treating the difficulty as a personal defect." },
      { "key": "specific", "label": "Named what is missing", "description": "Identified the absent input rather than a vague lack." },
      { "key": "no_self_improvement", "label": "Did not reach for becoming different", "description": "Aimed at the week rather than at the personality." },
      { "key": "honest", "label": "Was honest about the gap", "description": "Acknowledged the actual state of things without softening it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A friend you see a couple of times a year has asked how things are, and you have admitted you do not really see anybody.",
    "partner": {
      "name": "Sam",
      "role": "an old friend you are talking to",
      "personality": "Kind and interested in the actual mechanism. Pushes back gently on self-blame and asks what your week is made of.",
      "mood": "Warm, unhurried.",
      "openness": 5
    },
    "opening_beat": "\"I think I have just got worse at people, honestly.\"",
    "success_looks_like": "The user names the missing input rather than a defect in themselves.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what their week actually contains whenever the answer is about their personality.",
      "Agree readily and warmly with anything about circumstances or infrastructure.",
      "Never state the reframe yourself."
    ]
  }$j$::jsonb,
  $md$Today, describe your week to yourself and find the hours with the same people in them and nothing at stake. Log how many there are.$md$
),
(
  (select id from public.skills where slug = 'why-it-got-hard'),
  2,
  'What friendship is actually made of',
  $md$If the building was doing the work, it is worth knowing exactly what it was doing, because it can be rebuilt deliberately.

Three inputs, and none of them is charm.

**Repetition.** The same people, more than once, on some sort of schedule. This is the big one and it is doing most of the work. Familiarity is produced by exposure rather than by effort, and it accumulates whether or not anything interesting happens.

**Low stakes.** Nothing riding on it, no outcome, no task between you. This is why colleagues so often do not become friends despite enormous amounts of contact — there is always a thing being done, and the thing occupies the space where the other conversation would have gone.

**Unstructured time.** The bit before, the bit after, the walk to the station. Almost every friendship you have was formed in the margins of something else rather than in the something else.

**The move:** engineer repetition, and let the rest happen.

The consequence is worth stating plainly because it sounds too easy: the sixth or seventh time you see somebody, a conversation happens that neither of you engineered, and it is different in kind from the five before it. That is not a metaphor for friendship — it is the actual mechanism, and it is available to somebody with no social skill at all, provided they keep turning up.

It also explains the thing that frustrates people most: one brilliant conversation with a stranger produces nothing, and six unremarkable ones with the same person produce a friend. Intensity is not the input. Frequency is.

If you keep one thing: frequency beats quality, by a distance. You are not looking for a good conversation, you are looking for a sixth one.$md$,
  $j$[
    {
      "situation": "You had a brilliant two-hour conversation with somebody at a wedding.",
      "line": "(that produces nothing on its own)",
      "why": "Intensity is not the input. Six unremarkable conversations with the same person will produce more than one excellent one with a stranger."
    },
    {
      "situation": "You see six colleagues every day and none of them are friends.",
      "line": "(there is always a task between you)",
      "why": "Low stakes is one of the three inputs, and work removes it. The task occupies the space the other conversation would have gone into."
    },
    {
      "situation": "You are wondering when it starts to feel different.",
      "line": "(around the sixth or seventh time)",
      "why": "A conversation happens that neither of you engineered. That is the actual mechanism rather than a metaphor for one."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which input is doing most of the work?",
      "options": [
        { "text": "Repetition.", "correct": true, "note": "Familiarity is produced by exposure rather than effort, and it accumulates whether or not anything interesting happens." },
        { "text": "Having things in common.", "correct": false, "note": "Helpful and wildly overrated. People become friends with whoever they see repeatedly, then discover the things in common afterwards." },
        { "text": "Being good company.", "correct": false, "note": "It makes each meeting nicer and does not by itself produce a second one." },
        { "text": "Shared experiences.", "correct": false, "note": "A description of what accumulates rather than the input that produces it." }
      ],
      "explain": "Frequency beats quality by a distance. You are not looking for a good conversation, you are looking for a sixth one."
    },
    {
      "prompt": "Why do colleagues so often not become friends?",
      "options": [
        { "text": "People keep work and life separate on purpose.", "correct": false, "note": "Some do. Plenty do not and still end up with no friends from work." },
        { "text": "You do not choose them.", "correct": false, "note": "You did not choose anybody at school either, and that is where most people made their closest friends." },
        { "text": "There is always a task between you.", "correct": true, "note": "Low stakes is one of the three inputs and work removes it. The thing being done occupies the space the other conversation would have gone into." },
        { "text": "There is not enough time.", "correct": false, "note": "There is more contact than any other setting in adult life, which is what makes the outcome so striking." }
      ],
      "explain": "Repetition without low stakes produces colleagues. You need the margins, not the meeting."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named_repetition", "label": "Named repetition", "description": "Identified frequency rather than charm or common interests." },
      { "key": "low_stakes", "label": "Understood low stakes", "description": "Saw why contact with a task in it does not count." },
      { "key": "margins", "label": "Valued the margins", "description": "Noticed that friendship forms around the activity rather than in it." },
      { "key": "no_intensity", "label": "Did not chase intensity", "description": "Stopped looking for one excellent conversation." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The same friend, still talking it through, now asking the practical question.",
    "partner": {
      "name": "Sam",
      "role": "an old friend you are talking to",
      "personality": "Genuinely curious and slightly sceptical of anything that sounds like advice from a magazine. Wants the mechanism.",
      "mood": "Engaged.",
      "openness": 5
    },
    "opening_beat": "\"So how do you actually make friends as an adult, then?\"",
    "success_looks_like": "The user names repetition and low stakes rather than personal qualities.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Push back on anything about being more outgoing or more interesting.",
      "Engage seriously with anything about frequency, proximity or unstructured time.",
      "Never supply the answer yourself."
    ]
  }$j$::jsonb,
  $md$Today, name one person you have had a good conversation with exactly once. Log what it would take to make it six.$md$
),
(
  (select id from public.skills where slug = 'why-it-got-hard'),
  3,
  'Pick a room that repeats',
  $md$This is the single most useful act in the whole topic, and it is a scheduling decision rather than a social one.

**The move:** commit to one thing with the same people, on a schedule, for at least three months.

What makes a room work is not the activity. It is four properties, and they are worth checking before you commit anything to a calendar.

**The same people each time.** A weekly class with a fixed cohort works. A drop-in session where the faces rotate does not, however friendly it is, because you never reach the sixth time with anybody.

**A schedule.** Something that happens whether or not you feel like it that week, because you will not feel like it and going anyway is the entire mechanism.

**Small enough to be recognised.** Eight to twenty people is ideal. Two hundred is a crowd and you are anonymous in it.

**Time around the edges.** A thing with a pub afterwards, a coffee before, a walk to the station. This matters far more than it sounds — the activity is not where friendships form, the margins are.

That last one is worth checking specifically, because plenty of otherwise good rooms fail on it. A gym class where everybody leaves immediately supplies repetition and no margins, and it can run for two years without producing a single conversation.

What does not work, despite being what people reach for first: one-off events, big networking things, anything where the whole point is meeting people. Those maximise novelty, which is the opposite of the input you need, and they are exhausting for exactly the person reading this.

If you keep one thing: choose for the shape, not for the subject. You are not picking a hobby, you are buying a sixth conversation with the same person.$md$,
  $j$[
    {
      "situation": "You are choosing between a weekly class and a monthly meetup.",
      "line": "(weekly, every time)",
      "why": "Repetition is the input. Monthly means the sixth time is six months away, by which point nobody remembers anybody."
    },
    {
      "situation": "The class is good and everybody leaves the second it ends.",
      "line": "(no margins — it will not produce anything)",
      "why": "Friendships form in the bit before and the bit after. A room with no edges can run for two years and produce nothing."
    },
    {
      "situation": "You are considering a big networking event.",
      "line": "(that maximises novelty, which is the opposite of what you need)",
      "why": "Meeting a lot of people once is the input you already have too much of. And it is exhausting for exactly the person reading this."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which property matters most when choosing?",
      "options": [
        { "text": "That you enjoy the activity.", "correct": false, "note": "It has to be tolerable so you keep going. Beyond that the subject is nearly irrelevant." },
        { "text": "That the people seem like your kind of people.", "correct": false, "note": "Almost impossible to judge in advance, and repetition tends to produce that feeling rather than requiring it." },
        { "text": "That it has the same people each time.", "correct": true, "note": "A drop-in with rotating faces supplies contact and never reaches a sixth time with anybody, however friendly it is." },
        { "text": "That it is easy to get to.", "correct": false, "note": "Genuinely important for keeping going, and a constraint rather than the property that makes a room work." }
      ],
      "explain": "Choose for the shape, not the subject. You are buying a sixth conversation with the same person."
    },
    {
      "prompt": "What is the most commonly missed property?",
      "options": [
        { "text": "A schedule.", "correct": false, "note": "People usually get this right — a class or a team has one built in." },
        { "text": "Being small enough to be recognised.", "correct": false, "note": "Often right by accident, since most classes and teams are the right size anyway." },
        { "text": "Time around the edges.", "correct": true, "note": "A gym class where everybody leaves the moment it ends supplies repetition and no margins, and can run two years without producing one conversation." },
        { "text": "Something you are good at.", "correct": false, "note": "Not a property that matters at all, and being visibly bad at something is a perfectly good social lubricant." }
      ],
      "explain": "The activity is not where friendships form. The bit before and the bit after is."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "same_people", "label": "Same people each time", "description": "Chose a fixed cohort rather than a rotating one." },
      { "key": "schedule", "label": "On a schedule", "description": "Picked something that happens whether or not they feel like it." },
      { "key": "margins", "label": "Has margins", "description": "Checked for time around the edges." },
      { "key": "committed", "label": "Committed to a run", "description": "Signed up for months rather than trying it once." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have decided to do something about it and are looking at options: a monthly book club, a weekly five-a-side, a drop-in gym class, and a big industry meetup next month.",
    "partner": {
      "name": "Sam",
      "role": "an old friend helping you choose",
      "personality": "Asks about the shape of each option rather than the activity — who, how often, and whether anybody stays afterwards.",
      "mood": "Practical.",
      "openness": 5
    },
    "opening_beat": "\"Right, which one are you actually going to do?\"",
    "success_looks_like": "The user chooses for repetition and margins rather than for the activity.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask who is there, how often, and whether people stay afterwards.",
      "Approve a choice made on the shape and question one made on the subject.",
      "Never recommend one yourself."
    ]
  }$j$::jsonb,
  $md$Today, find one thing with the same people, on a schedule, with time around the edges. Log what it is and when it happens.$md$
),
(
  (select id from public.skills where slug = 'why-it-got-hard'),
  4,
  'The fourth time is the hard one',
  $md$You picked the room, you went three times, and nothing has happened. This is the point at which almost everybody stops, and it is the exact point at which stopping guarantees the outcome they were afraid of.

Three visits produces roughly nothing, and it is supposed to. You are still a new face. People have been polite. Nobody has learned your name properly. If you left now, nothing about the experience would have been unusual and nothing about it would have been a verdict.

**The move:** keep going while it is still producing nothing.

That is the whole skill, and it is a scheduling one rather than a social one. The fourth, fifth and sixth times are the ones that do the work, and they feel identical to the first three from the inside — which is why the dip catches people. It does not feel like being three quarters of the way through something. It feels like evidence.

Two things it is worth deciding in advance, because deciding them in the moment goes badly. Commit to a number rather than to a feeling: eight sessions, say, before you allow yourself an opinion about whether it is working. And go on the weeks you do not want to, because those are the ones that carry the whole thing — everybody goes when they feel like it, and that is not enough repetition to reach anybody.

The specific thought to watch for is *these people already all know each other*. Usually true, usually irrelevant, and it is the standard interpretation of week three. Groups take newcomers constantly. What they do not do is announce it.

And lower what counts as progress. Being recognised is progress. Somebody remembering your name is significant progress. A conversation about something other than the activity is most of the way there. If you are measuring by whether you have made a friend yet, you will conclude it has failed every week until the week it has obviously worked.

If you keep one thing: go the fourth time. It is the whole difference, and it costs nothing but an evening you had already set aside.$md$,
  $j$[
    {
      "situation": "Three sessions in and nobody has spoken to you properly.",
      "line": "(that is what three looks like)",
      "why": "You are still a new face and nobody has learned your name. Nothing about that is unusual and nothing about it is a verdict."
    },
    {
      "situation": "It is Tuesday and you do not want to go.",
      "line": "(those are the ones that count)",
      "why": "Everybody goes when they feel like it, and that is not enough repetition to reach anybody. The weeks you do not want to are the ones carrying it."
    },
    {
      "situation": "\"They all already know each other.\"",
      "line": "(true, and irrelevant)",
      "why": "Groups take newcomers constantly. What they do not do is announce it, which is why week three always looks closed."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is the fourth time the hard one?",
      "options": [
        { "text": "The novelty has worn off.", "correct": false, "note": "Some of that, and it is not what makes people stop." },
        { "text": "It feels identical to the first three, so the dip reads as evidence.", "correct": true, "note": "It does not feel like being three quarters through something. It feels like a result, which is exactly when people quit." },
        { "text": "You have run out of things to say.", "correct": false, "note": "Conversation is not the constraint here. Turning up is." },
        { "text": "People have decided about you by then.", "correct": false, "note": "They have barely registered you by then, which is the actual state of affairs at week three." }
      ],
      "explain": "The fourth, fifth and sixth are the ones that do the work, and they feel like the first three."
    },
    {
      "prompt": "What should you measure?",
      "options": [
        { "text": "Whether you have made a friend yet.", "correct": false, "note": "By that measure it has failed every week until the week it has obviously worked, which is a guarantee of quitting." },
        { "text": "Whether you enjoyed it.", "correct": false, "note": "Worth knowing and not the point. Plenty of enjoyable rooms produce nobody, and vice versa." },
        { "text": "Whether you spoke to anybody.", "correct": false, "note": "Closer, and it makes each week a pass or fail on your performance rather than on attendance." },
        { "text": "Being recognised, then named, then talked to about something else.", "correct": true, "note": "Three real milestones, all of which arrive before a friendship does, and all of which are visible from week four onwards." }
      ],
      "explain": "Commit to a number of sessions, not to a feeling, and lower what counts as progress."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "went_back", "label": "Went again", "description": "Returned while it was still producing nothing." },
      { "key": "number_not_feeling", "label": "Committed to a number", "description": "Set a session count rather than judging week by week." },
      { "key": "hard_weeks", "label": "Went on the flat weeks", "description": "Turned up when they did not feel like it." },
      { "key": "measured_right", "label": "Measured the right thing", "description": "Counted recognition and names rather than friendships." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Three weeks into the thing you committed to. Nothing has happened, nobody knows your name, and it is on again tomorrow.",
    "partner": {
      "name": "Sam",
      "role": "an old friend you are messaging",
      "personality": "Asks what you expected week three to look like, and does not accept it is not working as an answer this early.",
      "mood": "Direct and warm.",
      "openness": 5
    },
    "opening_beat": "\"Three times now. Any good?\"",
    "success_looks_like": "The user treats week three as too early to judge and commits to going again.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what they expected three weeks to produce, if the answer is that it is not working.",
      "Be pleased and matter-of-fact about a decision to keep going.",
      "Never tell the user it takes longer — let them get there."
    ]
  }$j$::jsonb,
  $md$Today, go back to something for the fourth time, or commit to a number of sessions in writing. Log the number.$md$
),
(
  (select id from public.skills where slug = 'why-it-got-hard'),
  5,
  'You already have candidates',
  $md$Before building anything new, it is worth noticing that most people already have three or four people who are most of the way there and have simply never been moved.

**The move:** list the people you already see repeatedly, and pick two.

The criteria are mechanical rather than emotional, which is the point — you are not asking who you like most, you are asking where the infrastructure already exists. Somebody you see regularly without arranging it. Somebody you always end up talking to. Somebody you have been pleased to run into more than once. Somebody you have said *we should do something* to.

That last one is the strongest signal on the list and almost nobody acts on it. Two people who have both said it are two people who have both, independently, wanted this — and both are waiting for the other to do something about it, which is the exact stalemate the next track exists to break.

Look in the places contact already happens: the school gate, the same train, the gym, the people at the edges of an existing friendship group, the colleague from a different team, the neighbour. The dog walk. Somebody you were close to five years ago and have not spoken to since, which is a different and much easier case than it feels.

And the counterintuitive one: friends of friends are the highest-yield source there is. You have a shared context, an easy setting, and somebody who has effectively vouched for both of you. It is also socially free — going to a thing your friend is going to requires no explanation at all.

What this exercise usually produces is mild surprise. People arrive at this topic believing they know nobody and leave the list with four names, and the problem changes shape entirely: it is not that there is nobody, it is that nothing has ever been proposed.

If you keep one thing: write the list. It is almost always longer than the feeling that sent you looking for it.$md$,
  $j$[
    {
      "situation": "You feel like you do not know anybody.",
      "line": "(write the list anyway)",
      "why": "People arrive here certain there is nobody and leave with four names. The problem is usually that nothing has been proposed, not that nobody exists."
    },
    {
      "situation": "You and somebody have both said we should do something.",
      "line": "(that is the strongest signal on the list)",
      "why": "Two people have independently wanted this and both are waiting for the other. It is a stalemate rather than an absence."
    },
    {
      "situation": "Your friend has a friend you always get on with at parties.",
      "line": "(highest yield there is)",
      "why": "Shared context, easy setting, and somebody who has effectively vouched for both of you. Going to a thing your friend is going to needs no explanation."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What are you looking for on the list?",
      "options": [
        { "text": "Where contact already happens without arranging it.", "correct": true, "note": "Mechanical rather than emotional. You are not asking who you like most — you are asking where the infrastructure already exists." },
        { "text": "The people you like most.", "correct": false, "note": "Frequently people you never see, which means starting from nothing. Liking is not the scarce input." },
        { "text": "People who seem to need friends.", "correct": false, "note": "Unknowable from outside, and it makes the whole thing a charitable act rather than something you want." },
        { "text": "People with things in common with you.", "correct": false, "note": "Overrated. Repetition tends to produce the sense of things in common rather than requiring it." }
      ],
      "explain": "Ask where the contact already is. That is what makes somebody a candidate."
    },
    {
      "prompt": "Why are friends of friends the highest-yield source?",
      "options": [
        { "text": "They are pre-screened for compatibility.", "correct": false, "note": "Loosely, and taste in friends varies enormously. That is not what makes it easy." },
        { "text": "You will see them anyway.", "correct": false, "note": "Occasionally, and not reliably enough to be the mechanism." },
        { "text": "Shared context, an easy setting, and no explanation needed.", "correct": true, "note": "Going to a thing your friend is going to is socially free, which removes the awkward part before it arrives." },
        { "text": "Your friend can introduce you properly.", "correct": false, "note": "Helpful when it happens and not required. The setting does the work rather than the introduction." }
      ],
      "explain": "The lowest-friction route is almost always through somebody you already know."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "listed", "label": "Actually wrote the list", "description": "Named specific people rather than thinking about it generally." },
      { "key": "mechanical", "label": "Used the mechanical test", "description": "Looked for existing contact rather than for who they like most." },
      { "key": "we_should", "label": "Included the we-should-do-something people", "description": "Noticed the stalemates already in play." },
      { "key": "picked", "label": "Picked two", "description": "Narrowed it rather than leaving a list." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The same conversation. Your friend has asked the obvious question and you have said you do not really know anybody.",
    "partner": {
      "name": "Sam",
      "role": "an old friend you are talking to",
      "personality": "Refuses to accept nobody as an answer and asks about specific settings — work, the gym, the school gate, their own friends.",
      "mood": "Affectionately persistent.",
      "openness": 5
    },
    "opening_beat": "\"Okay, but who do you actually already see? Anybody.\"",
    "success_looks_like": "The user names specific people who are already in repeated contact.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask about one setting at a time whenever the user says there is nobody.",
      "Be pleased and specific when a real name or group comes out.",
      "Never suggest a person yourself."
    ]
  }$j$::jsonb,
  $md$Today, write down every person you already see repeatedly without arranging it. Pick two. Log the names.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('why-it-got-hard', 1, 'choice', $j${
  "beats": [
    {
      "situation": "You are well liked at work, funny with the people you know, and you have nobody to call on a Sunday.",
      "prompt": "What does that combination tell you?",
      "options": [
        { "text": "You are not putting yourself out there enough.", "correct": false, "note": "The standard diagnosis, and it points at effort. People in this position are usually trying harder than they ever have." },
        { "text": "You must be doing something wrong socially.", "correct": false, "note": "Contradicted by the first half of the sentence. Somebody well liked at work is not failing at people." },
        { "text": "Being good company was never what produced friendships.", "correct": true, "note": "Proximity was, and colleagues are proximity with a task in the middle. That is a supply problem rather than a likeability one." },
        { "text": "Adults are just harder to befriend.", "correct": false, "note": "Comfortable and mostly false. Most adults would happily take another good friend and are in exactly your position." }
      ]
    },
    {
      "situation": "You decide to fix it. Two plans present themselves.",
      "prompt": "Which one is smaller?",
      "options": [
        { "text": "Become someone who finds this easier — more outgoing, better at rooms.", "correct": false, "note": "Becoming a different person is slow and mostly does not work, and it is the plan the wrong diagnosis produces." },
        { "text": "Change what your week contains.", "correct": true, "note": "If the problem is infrastructure, the fix is infrastructure. It is available this month and requires no change of personality." },
        { "text": "Say yes to everything for six months.", "correct": false, "note": "Exhausting and unfocused, and it maximises novelty — a lot of first meetings, which is the input you already have too much of." },
        { "text": "Reconnect with everybody you have lost touch with.", "correct": false, "note": "Worth doing and it is track five. It does not build the repeated contact that is missing now." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('why-it-got-hard', 2, 'line', $j${
  "says": "So how do you actually make friends as an adult, then?",
  "model": {
    "line": "Mostly by seeing the same people over and over with nothing much at stake. It turns out to be a scheduling problem more than a personality one.",
    "why": "Names the actual input rather than a personal quality. Familiarity comes from exposure and accumulates whether or not anything interesting happens."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Name repetition, not personality",
      "words": ["same people", "again", "regular", "repeat", "over and over", "every week", "turn up", "turning up", "often", "keep"] },
    { "kind": "forbids_any", "requirement": "Not a quality you have to acquire",
      "words": ["outgoing", "confident", "interesting", "charisma", "charming", "put yourself out there", "be more", "open up more", "say yes to everything"] },
    { "kind": "min_words", "requirement": "Say what the input actually is", "n": 12 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('why-it-got-hard', 3, 'choice', $j${
  "beats": [
    {
      "situation": "Four options: a monthly book club, a weekly five-a-side with a fixed team, a drop-in gym class with different faces each time, and a large industry meetup next month.",
      "prompt": "Which one?",
      "options": [
        { "text": "The monthly book club — same people, and you would enjoy it.", "correct": false, "note": "Right on people and wrong on frequency. Monthly puts the sixth meeting six months away, by which point nobody remembers anybody." },
        { "text": "The weekly five-a-side.", "correct": true, "note": "Same people, on a schedule, small enough to be recognised, and there is almost always a pub afterwards. The activity is nearly irrelevant." },
        { "text": "The drop-in class — most contact per week.", "correct": false, "note": "Rotating faces. It supplies contact and never reaches a sixth time with anybody, however friendly it is." },
        { "text": "The meetup — the whole point is meeting people.", "correct": false, "note": "Maximises novelty, which is the opposite of the input you need, and it is exhausting for exactly the person reading this." }
      ]
    },
    {
      "situation": "You found a weekly class with a fixed group. Everybody leaves the instant it finishes.",
      "prompt": "Does it work?",
      "options": [
        { "text": "Yes — repetition is the main input and it has that.", "correct": false, "note": "It has two of the four properties and is missing the one that produces conversations. This room can run two years and produce nothing." },
        { "text": "Yes, if you make an effort to talk during it.", "correct": false, "note": "During is the activity. Friendships form in the margins, which is precisely what this room does not have." },
        { "text": "No — and it is worth finding one with edges, or making one.", "correct": true, "note": "Time before or after is the property people miss most. Suggesting a drink afterwards can create it, and if nobody ever stays, the room is the wrong shape." },
        { "text": "No — leave and find something else immediately.", "correct": false, "note": "Too fast. Margins can sometimes be created, and it is worth one attempt before writing off a room that has the other three properties." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('why-it-got-hard', 4, 'line', $j${
  "says": "Three times now. Any good?",
  "model": {
    "line": "Nothing yet, but three is nothing. I have said eight before I decide anything, so I am going again tomorrow.",
    "why": "A number rather than a feeling, and the honest report that week three produced nothing — which is what week three is supposed to produce."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Three weeks is not a verdict",
      "words": ["not working", "not for me", "waste of time", "give up", "pointless", "they all know each other", "no point", "packing it in"] },
    { "kind": "contains_any", "requirement": "Commit to going again",
      "words": ["again", "going back", "next week", "tomorrow", "keep going", "carry on", "eight", "few more", "stick"] },
    { "kind": "min_words", "requirement": "Say the number or the next date", "n": 10 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('why-it-got-hard', 5, 'line', $j${
  "says": "Okay, but who do you actually already see? Anybody.",
  "model": {
    "line": "The two I always end up talking to at the climbing wall, and Priya from the other team who I have said we should get lunch to about four times.",
    "why": "Specific people found by a mechanical test — where contact already happens — rather than by who you like most. The we-should-do-something one is the strongest signal on the list."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "There is somebody — the list is longer than the feeling",
      "words": ["nobody", "no one", "not really anyone", "literally no", "there is no", "i do not see anyone", "nobody really"] },
    { "kind": "min_words", "requirement": "Name actual people or actual places", "n": 10 },
    { "kind": "max_words", "requirement": "Two or three, not everybody you know", "n": 45 }
  ]
}$j$::jsonb);
