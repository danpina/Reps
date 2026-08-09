-- Meeting someone, track 3: Flirting: the moves. Six lessons on what warmth is
-- actually made of, ending on the one a shy reader needs most — noticing when
-- it is being aimed at them.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'flirting-moves'),
  1,
  'What makes it flirting',
  $md$People treat flirting as a talent, and it is two ingredients you can name.

The first is **specificity**. Warmth that is available to anybody is friendliness. Warmth that could only be aimed at this person is something else, and the shift between them is not intensity — it is precision. *This is fun* is friendly. *I am glad I ended up at this end of the table* is not, and the only difference is that the second one could not have been said to the room.

The second is **deniability**. Everything that works here can be received as ordinary friendliness if that is all they want it to be. That is not cowardice, it is the mechanism: it lets two people find out about each other without either of them having to be the one who said it out loud first.

**The move:** make the warmth specific to them, and leave it deniable.

Both at once. Specific without deniable is a declaration, and it puts somebody on the spot with an audience of one. Deniable without specific is just being nice, which is pleasant and goes nowhere.

Everything in this track is a way of doing those two things — with a joke, a compliment, a look, or a hand on an arm. The ingredients do not change.$md$,
  $j$[
    {
      "situation": "A conversation at a dinner that has been going well for ten minutes.",
      "line": "I am glad I ended up at this end of the table.",
      "why": "Specific — it could only be about this seat and this person — and entirely deniable. If they want it to mean the company generally, it can."
    },
    {
      "situation": "You want to say you are enjoying it and it comes out as this is fun.",
      "line": "(aim it — this is more fun than I expected tonight to be)",
      "why": "The same warmth, pointed. Unpointed warmth is friendliness, and friendliness is not information."
    },
    {
      "situation": "You are about to say something that has no deniability left in it.",
      "line": "(take one step back down)",
      "why": "A declaration removes their exit and asks them to produce a verdict. The notch below it asks the same question and lets them answer with a look."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What actually separates friendly from flirty?",
      "options": [
        { "text": "How much warmth there is.", "correct": false, "note": "Very warm and completely general is what a good host does all evening, and nobody mistakes it for flirting." },
        { "text": "Whether you touch them.", "correct": false, "note": "One move among several, and it is late in the ladder. Plenty of flirting happens with no contact at all." },
        { "text": "Whether the warmth could only have been aimed at them.", "correct": true, "note": "Specificity rather than intensity. The same sentence pointed at a person instead of a room changes category without changing volume." },
        { "text": "Whether you mean it.", "correct": false, "note": "Invisible from outside. They can only read what was actually said." }
      ],
      "explain": "Point the warmth. Unpointed warmth is friendliness, however much of it there is."
    },
    {
      "prompt": "Why does deniability matter as much as specificity?",
      "options": [
        { "text": "It lets them respond without having to declare anything.", "correct": true, "note": "It is the mechanism, not a hedge. Both people get to find out where this is going without either having to be the one who said it first." },
        { "text": "It protects you from embarrassment.", "correct": false, "note": "A side effect, and the smaller half. It mostly protects them from having to produce a verdict on the spot." },
        { "text": "It is more polite.", "correct": false, "note": "Politeness is not what is doing the work. A deniable move is easier to answer, which is a different property." },
        { "text": "It keeps your options open.", "correct": false, "note": "That is what it looks like from outside and it is not the point. The option that matters is theirs." }
      ],
      "explain": "Deniability is what makes a move answerable. Without it you have handed somebody a verdict to deliver."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "specific", "label": "Aimed at them", "description": "Said something that could not have been said to the room." },
      { "key": "deniable", "label": "Left it deniable", "description": "Kept it receivable as ordinary friendliness." },
      { "key": "not_a_declaration", "label": "Did not declare", "description": "Avoided putting them on the spot for a verdict." },
      { "key": "warm", "label": "Was actually warm", "description": "Offered something rather than simply being careful." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A long table at a friend's birthday dinner. You have been talking to the person beside you since the starters and it has gone easily.",
    "partner": {
      "name": "Wren",
      "role": "a friend of the birthday person, sitting next to you",
      "personality": "Warm and quick, and mirrors whatever register she is given. Receives a deniable move comfortably and stiffens at a declaration.",
      "mood": "Enjoying the evening.",
      "openness": 4,
      "sex": "female",
      "alt": {
        "name": "Wren",
        "role": "a friend of the birthday person, sitting next to you",
        "personality": "Warm and quick, and mirrors whatever register he is given. Receives a deniable move comfortably and stiffens at a declaration.",
        "mood": "Enjoying the evening.",
        "openness": 4,
        "sex": "male"
      }
    },
    "opening_beat": "The plates go and there is a gap before anybody moves. They turn slightly towards you rather than towards the rest of the table.",
    "success_looks_like": "The user says something warm that is aimed at this person and could still be read as friendly.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Receive a specific, deniable remark warmly and return a little.",
      "Go politely neutral if the user makes a declaration with no deniability in it.",
      "Treat general friendliness as pleasant and unremarkable."
    ]
  }$j$::jsonb,
  $md$Today, take one warm thing you would have said generally and point it at the person instead. Log the general version and the pointed one.$md$
),
(
  (select id from public.skills where slug = 'flirting-moves'),
  2,
  'Teasing, with an edge',
  $md$Small talk gave you a rule: tease the situation, never the person. That rule is correct for strangers, and here you are going to break it on purpose.

Teasing somebody is a claim about closeness — it says *we are the kind of people who can do this* — and that claim is exactly what makes it flirting rather than conversation. It is also why it goes wrong when it is early: an unearned claim of closeness lands as presumption.

**The move:** tease something they chose, once they have teased you.

Their tease is the licence and it is the clearest one available. Until then, aim at the situation as before.

Then aim carefully. Something they chose — their commitment to a bit, their taste in something, the fact that they have opinions about a sandwich — is fair game, because a choice can be defended and enjoyed. Something they are — their looks, their body, their job, anything they did not pick — is not, and the difference between those two is the whole of the risk.

Keep it small and let them win one. Teasing that has to be conceded is not play. If they come back at you harder, that is the game working.$md$,
  $j$[
    {
      "situation": "They have just described their extremely specific coffee order, having teased you about yours.",
      "line": "That is not an order, that is a set of instructions.",
      "why": "Aimed at a choice, obviously affectionate, and it invites them to defend it. It also came after their tease, which is the licence."
    },
    {
      "situation": "They tease you about how long you spent choosing.",
      "line": "You have been watching me the whole time, then.",
      "why": "Returns the tease and quietly points out that they were paying attention. Warm, deniable, and it raises the temperature by one notch."
    },
    {
      "situation": "You want to tease them and they have not teased you.",
      "line": "(tease the situation instead, for now)",
      "why": "The licence has not arrived. Teasing the room is the same game with none of the presumption, and it usually produces the licence within a minute."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "When have you earned the right to tease the person?",
      "options": [
        { "text": "After about twenty minutes.", "correct": false, "note": "Time helps and does not grant permission. Plenty of twenty-minute conversations stay entirely formal." },
        { "text": "Once they have teased you.", "correct": true, "note": "The clearest licence there is, and it costs nothing to wait for. Their tease says jokes between us are safe, which is the thing you needed to know." },
        { "text": "As soon as it is going well.", "correct": false, "note": "Going well is not the same as close. This is where the presumption usually comes from." },
        { "text": "Once you have complimented them.", "correct": false, "note": "A compliment is warmth rather than licence, and pairing it with a tease immediately reads as a technique." }
      ],
      "explain": "Being teased is the licence to tease. Until then the situation is the target."
    },
    {
      "prompt": "Which is the safe target?",
      "options": [
        { "text": "Something they are good at.", "correct": false, "note": "Closer to a compliment wearing a joke, and it usually just gets a thank you rather than a return." },
        { "text": "How they look.", "correct": false, "note": "They did not choose it, they cannot enjoy defending it, and it is the target that turns a tease into an assessment." },
        { "text": "Their job.", "correct": false, "note": "Half chosen at best, and frequently a sore subject you know nothing about." },
        { "text": "Something they chose.", "correct": true, "note": "A choice can be defended and enjoyed, which is what makes teasing it a game. Their taste, their commitment to a bit, their opinions about a sandwich." }
      ],
      "explain": "Tease a choice, never an attribute. A choice can be defended; an attribute can only be judged."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "had_licence", "label": "Had the licence", "description": "Teased the person only after being teased, and the situation before that." },
      { "key": "chose_a_choice", "label": "Aimed at a choice", "description": "Teased something they picked rather than something they are." },
      { "key": "kept_it_small", "label": "Kept it small", "description": "Made it obviously affectionate and easy to return." },
      { "key": "let_them_win", "label": "Let them win one", "description": "Allowed the tease to come back rather than needing to land the last one." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A coffee place with a queue. You have been talking for a few minutes and they have just teased you about how long you took to order.",
    "partner": {
      "name": "Juno",
      "role": "somebody you got talking to in the queue",
      "personality": "Playful and fast. Teases early, enjoys being teased back about anything she chose, and cools sharply at anything about how she looks.",
      "mood": "In a good mood and enjoying this.",
      "openness": 4,
      "sex": "female",
      "alt": {
        "name": "Juno",
        "role": "somebody you got talking to in the queue",
        "personality": "Playful and fast. Teases early, enjoys being teased back about anything he chose, and cools sharply at anything about how he looks.",
        "mood": "In a good mood and enjoying this.",
        "openness": 4,
        "sex": "male"
      }
    },
    "opening_beat": "\"You did stand there reading that board for a very long time.\"",
    "success_looks_like": "The user returns the tease, aimed at something the partner chose.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Enjoy and escalate any tease aimed at something you chose.",
      "Cool noticeably at anything about appearance or anything they did not choose.",
      "Keep replies short and playful."
    ]
  }$j$::jsonb,
  $md$Today, return one tease aimed at something the other person chose. Not how they look, not their job. Log what you teased and what came back.$md$
),
(
  (select id from public.skills where slug = 'flirting-moves'),
  3,
  'Compliment the choice, not the face',
  $md$This is the most usable move in the whole track and almost nobody uses it.

A compliment about somebody's appearance is the contents of their week. It has been said to them by strangers, by people who wanted something, and by people saying it as a formality, which means it arrives pre-devalued and the only available reply is thank you. It is also the one thing they did not decide.

**The move:** compliment something they chose.

Their taste. A decision they made. The way they just described something. The fact that they clearly care about a subject nobody else at this table cares about. All of those are theirs, none of them are in their inbox, and every one of them is answerable — because a choice has a story behind it and appearance does not.

It is also far more flattering, which surprises people. Being told you look nice is pleasant. Being told the thing you decided was a good decision is being *seen*, and the difference in how those land is not subtle.

The test is whether the reply can be anything other than thank you. If it cannot, you have complimented something they were given rather than something they did.$md$,
  $j$[
    {
      "situation": "They have just explained why they moved cities for a job nobody understood.",
      "line": "That is a much braver call than it sounds when you say it that quickly.",
      "why": "A compliment on a decision. It cannot be answered with thank you alone — there is a story attached and they will tell it."
    },
    {
      "situation": "They have terrible and completely committed taste in something.",
      "line": "I like that you are not embarrassed about that at all.",
      "why": "Compliments the commitment rather than the taste, which is both funnier and more accurate. It also rewards exactly the thing that makes somebody good company."
    },
    {
      "situation": "You are about to tell them they look nice.",
      "line": "(find something they decided instead)",
      "why": "Not because it is wrong, but because it is the message they already have. Anything they chose is rarer and lands harder."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the test for a good compliment?",
      "options": [
        { "text": "Whether the reply can be anything other than thank you.", "correct": true, "note": "A compliment with a story behind it opens the conversation. One about something they were given closes it, because there is nothing to say back." },
        { "text": "Whether it is specific.", "correct": false, "note": "Necessary and not sufficient. A very specific compliment about their face is still unanswerable." },
        { "text": "Whether it is true.", "correct": false, "note": "Assumed throughout. An untrue compliment has a different and larger problem." },
        { "text": "Whether it makes them smile.", "correct": false, "note": "Almost any compliment does. Smiling and having something to say are different outcomes." }
      ],
      "explain": "If thank you is the only available reply, you complimented something they did not choose."
    },
    {
      "prompt": "Why does complimenting a choice land harder than complimenting appearance?",
      "options": [
        { "text": "It is more original.", "correct": false, "note": "It is, and originality is the smaller half. Being recognised for a decision is a different category of pleasant." },
        { "text": "It is less forward.", "correct": false, "note": "Often it is more forward, because it says you were paying attention to what they said rather than to how they look." },
        { "text": "It is being seen rather than being looked at.", "correct": true, "note": "One says you noticed a thing about them; the other says you noticed a thing they had no part in. The difference in how those land is not subtle." },
        { "text": "People are insecure about their appearance.", "correct": false, "note": "Sometimes, and not the mechanism. This works on people entirely comfortable with how they look." }
      ],
      "explain": "Appearance is what they were given. A choice is what they did, and being recognised for it is rarer."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "a_choice", "label": "Complimented a choice", "description": "Picked something they decided rather than something they were given." },
      { "key": "answerable", "label": "Left more than thank you", "description": "Said something with a story behind it." },
      { "key": "specific", "label": "Was specific", "description": "Named the actual thing rather than a general quality." },
      { "key": "not_a_line", "label": "Did not sound like a line", "description": "Said it as an observation rather than as a move." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A house party kitchen. They have just finished explaining, with some energy, why they gave up a perfectly good job to retrain as something entirely different.",
    "partner": {
      "name": "Cleo",
      "role": "a friend of your host",
      "personality": "Modest and quick to deflect anything about her appearance with a flat thank you. Opens up completely when a decision of hers is taken seriously.",
      "mood": "Animated, mid-story.",
      "openness": 4,
      "sex": "female",
      "alt": {
        "name": "Kit",
        "role": "a friend of your host",
        "personality": "Modest and quick to deflect anything about his appearance with a flat thank you. Opens up completely when a decision of his is taken seriously.",
        "mood": "Animated, mid-story.",
        "openness": 4,
        "sex": "male"
      }
    },
    "opening_beat": "\"...anyway, everyone thought I had lost it, and honestly for about six months so did I.\"",
    "success_looks_like": "The user compliments the decision rather than the person, and gets a story rather than a thank you.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Reply to any compliment about appearance with a flat thank you and a change of subject.",
      "Reply to a compliment about the decision with genuine warmth and more of the story.",
      "Keep replies to a few sentences."
    ]
  }$j$::jsonb,
  $md$Today, compliment one person on something they chose rather than something they were given. Log what you said and whether the reply was more than thank you.$md$
),
(
  (select id from public.skills where slug = 'flirting-moves'),
  4,
  'A beat longer',
  $md$Eye contact is the cheapest notch available and the one people most reliably get wrong in both directions.

Too little reads as disinterest or discomfort, and it is what most nervous people produce — a glance away every time the other person looks up. Too much reads as intensity, and it is what people produce when they have decided to fix the first problem by force.

**The move:** hold it one beat past where you would normally drop it, then look away first.

The beat is about a second. It is short enough to be deniable and long enough to be noticed, which is the definition of a good move here.

Looking away first is the half people miss, and it is what keeps the whole thing warm rather than heavy. A look that ends when they end it is a small contest. A look you end yourself, with a smile, is an offer that has been made and then released — and released is what makes it comfortable to accept.

Do it while they are talking, not while you are. Sustained attention on somebody who is speaking is flattering; sustained attention on somebody who is listening to you is a lot.$md$,
  $j$[
    {
      "situation": "They are mid-sentence and glance up at you.",
      "line": "(hold it a second past normal, then look away with a smile)",
      "why": "A second is enough to be noticed and short enough to be nothing. Ending it yourself is what turns it from a contest into an offer."
    },
    {
      "situation": "You have been looking away every time they look up.",
      "line": "(stay one beat next time)",
      "why": "The habit reads as discomfort or disinterest, and it is the most common thing a nervous person does with their eyes. One beat is the whole correction."
    },
    {
      "situation": "You are talking and holding their gaze the entire time.",
      "line": "(let it go — it is a lot on the listener)",
      "why": "Sustained attention flatters the speaker and weighs on the listener. The same behaviour reads completely differently depending on who is talking."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why look away first?",
      "options": [
        { "text": "It stops it being intense.", "correct": false, "note": "Length controls intensity. Who ends it controls whether it felt like a question or a demand." },
        { "text": "It shows you are not desperate.", "correct": false, "note": "Impression management, and it is not the mechanism. This is about what it asks of them." },
        { "text": "It gives them a chance to look back.", "correct": false, "note": "A nice side effect. The primary thing is removing the pressure to respond." },
        { "text": "It turns a contest into an offer that has been released.", "correct": true, "note": "A look that ends when they end it puts a small pressure on them to decide. Ending it yourself, with a smile, makes it something offered and let go — which is comfortable to accept." }
      ],
      "explain": "Length is the signal. Who ends it decides whether the signal was an offer or a demand."
    },
    {
      "prompt": "When is sustained eye contact flattering rather than heavy?",
      "options": [
        { "text": "While you are talking.", "correct": false, "note": "This is the version that makes people uncomfortable, and it is what somebody trying hard usually produces." },
        { "text": "While they are talking.", "correct": true, "note": "Attention on a speaker is the clearest compliment available and costs nothing. The same amount aimed at somebody who is listening to you is a great deal to sit under." },
        { "text": "During a pause.", "correct": false, "note": "Fine in small amounts and it is where a held look becomes a moment, which is a bigger step than this lesson." },
        { "text": "It is the same either way.", "correct": false, "note": "It is not remotely the same, and the difference is the whole practical content of the lesson." }
      ],
      "explain": "Give it while they speak. Take less of it while you do."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "held_a_beat", "label": "Held a beat longer", "description": "Stayed about a second past the normal drop." },
      { "key": "released_it", "label": "Looked away first", "description": "Ended the look themselves rather than waiting for it to end." },
      { "key": "while_they_spoke", "label": "Gave it while they were talking", "description": "Aimed the attention at the speaker rather than at the listener." },
      { "key": "warm", "label": "Kept it warm", "description": "Paired it with a smile rather than delivering it flat." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A quiet corner of a bar, an hour into a conversation that has been going well.",
    "partner": {
      "name": "Sasha",
      "role": "somebody you met earlier this evening",
      "personality": "Comfortable and observant. Notices attention, returns it, and is easily made uncomfortable by too much of it while she is listening.",
      "mood": "Relaxed and enjoying it.",
      "openness": 4,
      "sex": "female",
      "alt": {
        "name": "Sasha",
        "role": "somebody you met earlier this evening",
        "personality": "Comfortable and observant. Notices attention, returns it, and is easily made uncomfortable by too much of it while he is listening.",
        "mood": "Relaxed and enjoying it.",
        "openness": 4,
        "sex": "male"
      }
    },
    "opening_beat": "They are part-way through a story and glance up at you between sentences.",
    "success_looks_like": "The user gives attention while the partner is speaking and releases it themselves.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Warm up noticeably when given attention while speaking.",
      "Become slightly self-conscious if held under sustained attention while listening.",
      "Describe your own glances and looks plainly as part of your replies."
    ]
  }$j$::jsonb,
  $md$Today, in one conversation, hold eye contact a beat longer than usual while the other person is speaking, and look away first. Log what you noticed.$md$
),
(
  (select id from public.skills where slug = 'flirting-moves'),
  5,
  'Touch, and the rungs',
  $md$Touch is a ladder, and the reading between rungs is not a caution bolted onto the skill. It is the skill.

The rungs are ordinary and they go in order. Incidental — a hand on a forearm to land a point, gone immediately. Social — a hand on a shoulder while you are both laughing, a second at most. Deliberate — the same contact, held a beat, which is no longer incidental and both of you know it.

**The move:** one rung at a time, and read the rung before you take the next one.

Reading it is simple and people skip it because they are nervous. Did they stay where they were, or did the distance quietly increase? Did they touch back at some point in the next few minutes? Did the conversation carry on at the same temperature? A yes is all three. **No response is a no** — not a maybe, and not an invitation to be clearer.

Two practical things. Public, brief, and above the elbow covers almost every good first rung. And going back down a rung is always available and costs nothing — if you get no response, carry on exactly as before, and there is nothing for either of you to manage.

If you never take the first rung, that is a real cost too. Warmth with no contact at all is legible as friendliness for a very long time.$md$,
  $j$[
    {
      "situation": "You are both laughing at something and they are standing close.",
      "line": "(hand on the upper arm for a second, landing the joke, then gone)",
      "why": "Incidental, brief, public and entirely deniable. It is the first rung, and the information it produces is worth more than another ten minutes of talking."
    },
    {
      "situation": "You took the first rung and nothing came back at all.",
      "line": "(carry on exactly as before)",
      "why": "No response is a no, and the correct next move is to be completely normal. Nothing has happened that either of you needs to manage."
    },
    {
      "situation": "They touched your arm twice in the last five minutes.",
      "line": "(that is the rung answered — you can take the next one)",
      "why": "Touching back is the clearest yes available. It is also the signal a nervous person is most likely to notice and then decide they imagined."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "You take the first rung and there is no reaction at all. What is that?",
      "options": [
        { "text": "Neutral — try again to be sure.", "correct": false, "note": "The reading that turns a small no into an uncomfortable evening. Ambiguity is not an invitation to be clearer." },
        { "text": "They did not notice.", "correct": false, "note": "They noticed. People always notice, whatever they do with it." },
        { "text": "A no. Carry on exactly as before.", "correct": true, "note": "No response is a no rather than a maybe. The right next move is to be completely ordinary, which leaves nothing for either of you to manage." },
        { "text": "They are shy — go slower.", "correct": false, "note": "Possibly true, and it changes nothing about the next move. Slower and not at all look identical from here, and only one of them is yours to choose." }
      ],
      "explain": "No response is a no. Going back down a rung costs nothing and leaves nothing to explain."
    },
    {
      "prompt": "What is the clearest yes?",
      "options": [
        { "text": "They touch you back within the next few minutes.", "correct": true, "note": "The most reliable signal there is, and the one a nervous person is most likely to notice and then talk themselves out of having seen." },
        { "text": "They did not move away.", "correct": false, "note": "Weak. Plenty of people stay exactly where they are out of politeness and would rather not be there." },
        { "text": "They laughed.", "correct": false, "note": "They were already laughing. That is what made the moment available, not what answered it." },
        { "text": "They kept talking.", "correct": false, "note": "The absence of a problem rather than the presence of a yes." }
      ],
      "explain": "Being touched back is the answer. Everything else is the absence of an objection."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "first_rung", "label": "Took a first rung", "description": "Made brief, public, incidental contact rather than avoiding it entirely." },
      { "key": "read_it", "label": "Read the response", "description": "Checked what came back before considering anything further." },
      { "key": "took_no_for_no", "label": "Treated no response as a no", "description": "Went back down a rung without making it a moment." },
      { "key": "one_at_a_time", "label": "One rung at a time", "description": "Did not skip a step after a single positive signal." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Standing at the edge of a party, an hour in. You have both been laughing at the same thing for a while and are standing fairly close.",
    "partner": {
      "name": "Mira",
      "role": "somebody you have been talking to most of the evening",
      "personality": "Warm and physically expressive when comfortable. Will touch back readily if the first contact is brief and well judged, and will quietly increase the distance if it is not.",
      "mood": "Having a good evening.",
      "openness": 4,
      "sex": "female",
      "alt": {
        "name": "Milo",
        "role": "somebody you have been talking to most of the evening",
        "personality": "Warm and physically expressive when comfortable. Will touch back readily if the first contact is brief and well judged, and will quietly increase the distance if it is not.",
        "mood": "Having a good evening.",
        "openness": 4,
        "sex": "male"
      }
    },
    "opening_beat": "You have both just stopped laughing at the same thing, and neither of you has said anything yet.",
    "success_looks_like": "The user takes a brief first rung and reads what comes back before doing anything else.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Describe your own physical responses plainly — staying put, moving back, touching their arm.",
      "Respond warmly to brief, incidental contact and increase the distance after anything held or repeated too soon.",
      "Never initiate contact before the user does."
    ]
  }$j$::jsonb,
  $md$Today, take one first rung — brief, public, above the elbow — and then read what comes back. Log what you did and what happened in the following few minutes.$md$
),
(
  (select id from public.skills where slug = 'flirting-moves'),
  6,
  'Noticing it back',
  $md$The most useful skill in this track is not initiating. It is realising that somebody is already doing it to you.

Shy people under-read this almost universally, and the phrase that does the damage is *they were probably just being friendly*. Sometimes true. But it is said with total confidence about situations containing three or four clear signals, and the person saying it never finds out, because deciding it was nothing means doing nothing.

**The move:** count the signals, and assume the third one is real.

The reliable ones are not subtle once you know them. They stay when leaving was easy and obvious. They re-start the conversation after it ends. They tease you. They touch you first. They ask about your life rather than your opinions. They remember something you said twenty minutes ago and bring it back.

One of those is nothing. Three is not nothing, and the appropriate response to three is not a declaration — it is one notch, offered and released, which is the whole of the previous five lessons.

The asymmetry is worth stating plainly. Over-reading and being wrong costs you an awkward minute and a warm exit. Under-reading and being wrong costs you the thing you wanted. Those are not the same size, and most people behave as though they are.$md$,
  $j$[
    {
      "situation": "Their friends left twenty minutes ago and they are still here.",
      "line": "(that is a signal — count it)",
      "why": "Staying when going was easy and expected is one of the strongest signals available, and it is the one most often explained away as politeness."
    },
    {
      "situation": "They have teased you twice and brought back something you said earlier.",
      "line": "(three signals — offer one notch)",
      "why": "Three is not a coincidence. The correct response is not a declaration; it is a small, specific, deniable step, which is all the previous lessons were for."
    },
    {
      "situation": "You have decided they were just being friendly.",
      "line": "(count them out loud — how many were there?)",
      "why": "The phrase is a conclusion rather than an observation. Counting turns it back into something you can be wrong about in a useful direction."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why do people under-read rather than over-read?",
      "options": [
        { "text": "The signals are genuinely ambiguous.", "correct": false, "note": "Some are. Three together are not, and that is the case the phrase is usually applied to." },
        { "text": "Deciding it was nothing means never finding out you were wrong.", "correct": true, "note": "Under-reading is self-confirming. You do nothing, nothing happens, and the conclusion looks correct in hindsight for ever." },
        { "text": "They are being modest.", "correct": false, "note": "It looks like modesty and it functions as avoidance. The result is the same either way." },
        { "text": "Over-reading is embarrassing.", "correct": false, "note": "It is, mildly, for about a minute — which is the asymmetry the lesson is about." }
      ],
      "explain": "Under-reading never gets corrected, which is exactly why it persists."
    },
    {
      "prompt": "Three signals. What is the right response?",
      "options": [
        { "text": "Say the plain thing.", "correct": false, "note": "Too big a jump from three signals, and it removes their exit. That belongs at the end of the next track, once it is plainly mutual." },
        { "text": "Wait for a fourth.", "correct": false, "note": "There may not be one, because they are also waiting. Somebody has to move and it may as well be the person who counted." },
        { "text": "Ask them directly whether they are interested.", "correct": false, "note": "Makes the conversation the subject of the conversation, which ends it whichever way the answer goes." },
        { "text": "One notch, offered and released.", "correct": true, "note": "Small, specific, deniable — everything the previous five lessons were for. Three signals justify a step, not a declaration." }
      ],
      "explain": "Three signals earn a notch. A notch is not a declaration."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "counted", "label": "Counted the signals", "description": "Noticed what was actually happening rather than concluding it was nothing." },
      { "key": "no_dismissal", "label": "Did not explain it away", "description": "Resisted deciding they were just being friendly with three signals present." },
      { "key": "responded", "label": "Offered a notch", "description": "Answered the signals with a small deniable step rather than nothing or everything." },
      { "key": "right_size", "label": "Sized it correctly", "description": "Did not jump to a declaration from three signals." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The end of an evening. Their friends left half an hour ago and they are still here, talking to you.",
    "partner": {
      "name": "Alex",
      "role": "somebody you met at the start of the evening",
      "personality": "Has been teasing you all night, has brought back two things you said earlier, and has stayed long past the point of needing to. Will not say any of this out loud.",
      "mood": "Enjoying herself, in no hurry to leave.",
      "openness": 4,
      "sex": "female",
      "alt": {
        "name": "Alex",
        "role": "somebody you met at the start of the evening",
        "personality": "Has been teasing you all night, has brought back two things you said earlier, and has stayed long past the point of needing to. Will not say any of this out loud.",
        "mood": "Enjoying himself, in no hurry to leave.",
        "openness": 4,
        "sex": "male"
      }
    },
    "opening_beat": "\"That is the third time you have mentioned that band, by the way. I am keeping count.\"",
    "success_looks_like": "The user reads the signals as real and answers with one small deniable step.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Keep producing signals — teasing, staying, referring back — and never state your interest plainly.",
      "Respond warmly to a small step and go slightly awkward at a full declaration.",
      "Never leave the conversation."
    ]
  }$j$::jsonb,
  $md$Today, count the signals in one conversation instead of concluding. Log how many there were, and what you did about it.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('flirting-moves', 1, 'choice', $j${
  "beats": [
    {
      "situation": "Ten minutes into a good conversation at a dinner. You want to say you are enjoying it.",
      "prompt": "Which one is flirting?",
      "options": [
        { "text": "This is fun.", "correct": false, "note": "Warm and unpointed. It could have been said to the room, which makes it friendliness rather than information." },
        { "text": "You are by far the most interesting person here.", "correct": false, "note": "Specific and with no deniability left in it. It removes their exit and asks for a verdict." },
        { "text": "I am glad I ended up at this end of the table.", "correct": true, "note": "Specific — it could only be about this seat and this person — and completely deniable. Both ingredients, at low volume." },
        { "text": "Everyone here is great, actually.", "correct": false, "note": "Maximum warmth, zero direction. This is what a good host does all evening." }
      ]
    },
    {
      "situation": "You have said the deniable version and they have smiled and said something warm back.",
      "prompt": "What did the deniability buy?",
      "options": [
        { "text": "You avoided embarrassment.", "correct": false, "note": "A side effect, and the smaller half. It mostly protected them from producing a verdict on the spot." },
        { "text": "They could answer without having to declare anything.", "correct": true, "note": "That is the mechanism rather than a hedge. Both of you get to find out where this is going without either having to be the one who said it first." },
        { "text": "Nothing — they would have answered either way.", "correct": false, "note": "A declaration gets a decision. This got a response, which is a different and much more useful thing." },
        { "text": "It kept your options open.", "correct": false, "note": "How it looks from outside. The option that matters here is theirs." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('flirting-moves', 2, 'line', $j${
  "says": "You did stand there reading that board for a very long time.",
  "model": {
    "line": "You were watching the whole time, then.",
    "why": "Returns the tease and quietly points out that they were paying attention. It aims at something they did rather than something they are, and it raises the temperature by exactly one notch."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Aim at something they chose, never at how they look",
      "words": ["look", "looks", "pretty", "hot", "cute", "gorgeous", "beautiful", "handsome", "fit"] },
    { "kind": "max_words", "requirement": "Keep it small enough to be returned", "n": 20 },
    { "kind": "max_sentences", "requirement": "One line. Let them come back at you.", "n": 1 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('flirting-moves', 3, 'line', $j${
  "says": "...anyway, everyone thought I had lost it, and honestly for about six months so did I.",
  "model": {
    "line": "That is a much braver call than it sounds when you say it that quickly.",
    "why": "A compliment on the decision rather than the person. It cannot be answered with thank you alone, which is the test — there is a story behind it and they will tell it."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Compliment the choice, not the face",
      "words": ["you look", "pretty", "beautiful", "handsome", "gorgeous", "cute", "attractive", "your eyes", "your smile"] },
    { "kind": "contains_any", "requirement": "Name the thing they actually decided",
      "words": ["call", "decision", "decided", "choice", "chose", "did that", "doing that", "brave", "quit", "gave up", "retrain"] },
    { "kind": "max_words", "requirement": "Under twenty-five words", "n": 25 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('flirting-moves', 4, 'choice', $j${
  "beats": [
    {
      "situation": "They are part-way through a story and glance up at you between sentences.",
      "prompt": "What do you do with your eyes?",
      "options": [
        { "text": "Look away immediately, as usual.", "correct": false, "note": "The habit most nervous people have, and it reads as discomfort or disinterest. One beat is the entire correction." },
        { "text": "Hold it until they look away.", "correct": false, "note": "Now it is a contest, and they have to decide how to end it. Length is fine; who ends it is the problem." },
        { "text": "Hold it and stop smiling, to be clear.", "correct": false, "note": "Intensity without warmth. This is the version people produce when they have decided to fix shyness by force." },
        { "text": "Hold it about a second past normal, then look away first, with a smile.", "correct": true, "note": "Long enough to be noticed, short enough to be nothing, and released by you — which turns it from a small contest into an offer." }
      ]
    },
    {
      "situation": "Now you are the one talking, at some length.",
      "prompt": "How much eye contact?",
      "options": [
        { "text": "Less. Sustained attention on a listener is a lot to sit under.", "correct": true, "note": "The same behaviour reads completely differently depending on who is speaking. Give it generously while they talk and take less of it while you do." },
        { "text": "The same — consistency reads as confidence.", "correct": false, "note": "Consistent is not the variable. What it asks of them changes entirely depending on which of you is speaking." },
        { "text": "More, to hold their attention.", "correct": false, "note": "This is the version that makes people uncomfortable, and it is exactly what somebody trying hard tends to produce." },
        { "text": "None — look away while you think.", "correct": false, "note": "Overcorrecting into the original problem. Less is not none." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('flirting-moves', 5, 'choice', $j${
  "beats": [
    {
      "situation": "You put a hand on their upper arm for a second while you were both laughing. They carried on talking and nothing else happened at all.",
      "prompt": "What now?",
      "options": [
        { "text": "Try again shortly, to be sure.", "correct": false, "note": "The read that turns a small no into an uncomfortable evening. Ambiguity is not an invitation to be clearer." },
        { "text": "Ask whether that was all right.", "correct": false, "note": "Well meant, and it makes a two-second thing into a conversation about itself. Being normal is kinder." },
        { "text": "Carry on exactly as before.", "correct": true, "note": "No response is a no, and being completely ordinary afterwards leaves nothing for either of you to manage. Going back down a rung costs nothing." },
        { "text": "Assume they are shy and go slower.", "correct": false, "note": "Perhaps true, and it changes nothing. Slower and not at all look identical from here." }
      ]
    },
    {
      "situation": "Different evening. They have touched your arm twice in the last five minutes, and stayed close.",
      "prompt": "What has that told you?",
      "options": [
        { "text": "Nothing — some people are just tactile.", "correct": false, "note": "Some are, and twice in five minutes towards one person is not that. This is the dismissal the last lesson in this track is about." },
        { "text": "The rung is answered, and the next one is available.", "correct": true, "note": "Being touched back is the clearest yes there is, and it is the signal most likely to be noticed and then talked away." },
        { "text": "You can skip ahead now.", "correct": false, "note": "One rung at a time, still. A yes on this rung is a yes on this rung." },
        { "text": "They want you to say something plain.", "correct": false, "note": "Reading two touches as a request for a declaration is a much bigger jump than the evidence supports." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('flirting-moves', 6, 'line', $j${
  "says": "That is the third time you have mentioned that band, by the way. I am keeping count.",
  "model": {
    "line": "You have been paying more attention than you are letting on.",
    "why": "Answers three signals with one notch rather than with a declaration. Specific to what they just did, warm, and entirely deniable if that is all they want it to be."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "A notch, not a declaration",
      "words": ["i like you", "i fancy you", "do you like me", "are you interested", "i am into you", "go out with me"] },
    { "kind": "max_words", "requirement": "Under twenty words — small and released", "n": 20 },
    { "kind": "max_sentences", "requirement": "One line, offered and then left alone", "n": 1 }
  ]
}$j$::jsonb);
