-- Work, track 5: Saying what you want. The middle of the spine.
--
-- Being seen makes the work visible; this makes the direction visible. It is
-- the one a quiet person skips hardest, because every move in it requires
-- saying out loud that you want something — which feels like presumption and
-- is in fact information nobody can get any other way.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'saying-what-you-want'),
  1,
  'Being good is not a bid',
  $md$There is a quiet assumption underneath a great many stalled careers: that doing the work well is a way of asking for more of it.

It is not. It is a way of being reliable at exactly what you currently do, and the most common reward for being reliable at a thing is more of that thing. This is not unfair and nobody is withholding anything. Your manager has a list of work that needs doing and a set of people whose ambitions they can only know about if those people said them out loud.

**The move:** treat wanting something as information you have to supply.

It is worth being precise about how invisible this is from the outside. Somebody who wants to lead a project and somebody who is perfectly happy where they are look identical. They both turn up, do good work, and say nothing about it. There is no tell. A manager staffing something interesting is not choosing to overlook you — they are working from a list of people who have said things, and you are not on it.

Which means being good is not even a hint. The hint theory is the expensive one: the belief that consistent excellence is a legible signal of ambition. It is a legible signal of competence, and competence is what gets you asked to do more of the same.

The reframe that makes this bearable, if asking feels like presumption: you are not making a claim about your worth. You are supplying a fact about your preferences, and the person you are supplying it to has no other way of getting it.

If you keep one thing: nobody can route anything towards you until you have said where you want to go.$md$,
  $j$[
    {
      "situation": "You have been excellent for two years and nothing has changed.",
      "line": "(excellence is not a signal of ambition)",
      "why": "It is a signal of competence, and the reward for being reliable at a thing is more of that thing. The two are frequently confused."
    },
    {
      "situation": "You assume your manager knows you want more.",
      "line": "(you look exactly like somebody who is happy)",
      "why": "Both people turn up and do good work and say nothing. There is no tell, so there is nothing to notice."
    },
    {
      "situation": "Saying it feels presumptuous.",
      "line": "(it is a preference, not a claim about your worth)",
      "why": "You are supplying a fact the other person has no other way of getting. That is a much smaller act than it feels like."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does being excellent not lead anywhere by itself?",
      "options": [
        { "text": "Because managers do not notice.", "correct": false, "note": "They generally do notice. What they cannot see is what you want, which is a different fact entirely." },
        { "text": "Because other people are pushier.", "correct": false, "note": "That is a story about a contest. The problem exists in a team where nobody is pushy." },
        { "text": "Because there is not enough to go round.", "correct": false, "note": "Sometimes true and not the mechanism. Plenty of work goes to whoever mentioned wanting it." },
        { "text": "Because the reward for reliability is more of the same.", "correct": true, "note": "Excellence signals competence, not ambition. Somebody who wants more and somebody who is happy look identical from outside." }
      ],
      "explain": "Being good is not a bid. It is not even a hint."
    },
    {
      "prompt": "What makes saying it bearable if it feels presumptuous?",
      "options": [
        { "text": "Everybody else is doing it.", "correct": false, "note": "Probably true and it is a reason to feel bad rather than a reason to act." },
        { "text": "It is a preference, not a claim about your worth.", "correct": true, "note": "You are supplying a fact the other person cannot get any other way. That is a far smaller act than making a case for yourself." },
        { "text": "You have earned it.", "correct": false, "note": "That framing makes it a claim that can be judged, which is exactly what makes it hard to say." },
        { "text": "The worst they can say is no.", "correct": false, "note": "True and it addresses the fear rather than the reframe. The point is that no claim is being made at all." }
      ],
      "explain": "You are not arguing you deserve something. You are saying where you would like to go."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_it", "label": "Said what they wanted", "description": "Supplied the fact rather than assuming it was visible." },
      { "key": "no_case", "label": "Did not build a case", "description": "Stated a preference rather than arguing for a verdict." },
      { "key": "specific", "label": "Was specific about it", "description": "Named the kind of work rather than gesturing at more." },
      { "key": "no_apology", "label": "Did not apologise for wanting it", "description": "Treated it as ordinary information." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Your one-to-one. You have been doing the same work well for two years and would like something bigger, and you have never mentioned it.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Genuinely well disposed and entirely unaware you want anything to change. Responds concretely to a stated direction and hears hints as small talk.",
      "mood": "Relaxed, has the full half hour.",
      "openness": 4
    },
    "opening_beat": "\"You have been really solid this year. Anything you want to talk about?\"",
    "success_looks_like": "The user says plainly that they want something bigger.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Take a stated direction seriously and start thinking about what could go that way.",
      "Treat hints and general enthusiasm as pleasant small talk and move on.",
      "Never ask whether the user wants more responsibility."
    ]
  }$j$::jsonb,
  $md$Today, say out loud to one person what you would like to be doing more of. Log what you said.$md$
),
(
  (select id from public.skills where slug = 'saying-what-you-want'),
  2,
  'Say the direction',
  $md$There is a way of saying this that sounds presumptuous and a way that does not, and the difference is not confidence. It is whether you are asking for permission or describing a direction.

**The move:** name where you want to be heading, as a direction rather than a request.

*I would like to be running something like this by next year.* That is not a demand and it does not ask anybody to say yes today. It is a statement of trajectory, and it does something specific to the person hearing it: it makes them partly responsible for it. Managers who know where somebody wants to go start routing things that way, often without ever mentioning it — a name goes on a list, an introduction happens, a piece of work gets offered instead of assigned.

A request, by contrast, needs an answer, and the answer is frequently *not right now* — which closes the subject for six months and makes raising it again feel like pushing.

Say it once, plainly, and let it sit. This is not a negotiation and there is nothing to defend. If you get *what makes you say that*, answer with what you have enjoyed and what you are good at rather than with a case for promotion. It is a conversation about you, not a hearing.

Two things to leave out. A timeline that reads as a threat — *by next year* is a direction, *within six months or I will look elsewhere* is a negotiation with a much shorter fuse than you want. And comparison: *I have been here longer than Tom* moves the subject to Tom, and nothing good is on the other side of that.

Then repeat it. Not weekly, but this is a thing your manager forgets, because it is one of forty things they are holding. Once a quarter, in a sentence, is not nagging — it is keeping a fact current.

If you keep one thing: say where you are going, not what you are asking for. A direction cannot be turned down.$md$,
  $j$[
    {
      "situation": "You want to be leading work like this.",
      "line": "I would like to be running something like this by next year.",
      "why": "A direction rather than a request. Nothing has to be answered today, and it makes them partly responsible for where you end up."
    },
    {
      "situation": "You are about to ask whether you could be promoted.",
      "line": "(a request needs an answer, and the answer is not right now)",
      "why": "That closes the subject for six months and makes raising it again feel like pushing. A direction stays open."
    },
    {
      "situation": "You said it four months ago and nothing has happened.",
      "line": "(say it again, once, in a sentence)",
      "why": "It is one of forty things they are holding. Once a quarter is not nagging, it is keeping a fact current."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why a direction rather than a request?",
      "options": [
        { "text": "It is less confrontational.", "correct": false, "note": "It is, and softness is not what makes it work." },
        { "text": "A request needs an answer, and the answer closes the subject.", "correct": true, "note": "Not right now shuts it for six months. A direction cannot be turned down, and it makes them partly responsible for where you end up." },
        { "text": "It gives you deniability.", "correct": false, "note": "You do not want deniability here. The whole point is that the fact is now known." },
        { "text": "It sounds more senior.", "correct": false, "note": "How it sounds is beside the point. What matters is what it does to the conversation afterwards." }
      ],
      "explain": "Say where you are going. There is nothing in that to say no to."
    },
    {
      "prompt": "Which line does the damage?",
      "options": [
        { "text": "I would like to be running something like this by next year.", "correct": false, "note": "The model. A direction with a horizon and no demand attached." },
        { "text": "I have really enjoyed the parts where I was leading it.", "correct": false, "note": "Useful and true, and a good answer to what makes you say that." },
        { "text": "I have been here longer than Tom.", "correct": true, "note": "It moves the subject to Tom, and there is nothing good on the other side of that. Comparison turns a preference into a grievance." },
        { "text": "I want to say this once and then leave it with you.", "correct": false, "note": "Perfectly fine, and it makes clear this is not a negotiation." }
      ],
      "explain": "Never compare yourself to a colleague. It changes the subject to them and the tone to grievance."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "direction", "label": "Said it as a direction", "description": "Described where they are heading rather than asking for something." },
      { "key": "plain", "label": "Said it plainly", "description": "One sentence, no case attached." },
      { "key": "no_comparison", "label": "Compared themselves to nobody", "description": "Kept colleagues out of it." },
      { "key": "left_it", "label": "Left it with them", "description": "Did not negotiate or press for an answer." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Your one-to-one, a week after you finished the biggest piece of work you have done here.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Receptive to a clear direction and immediately practical about it. Asks what makes you say that, once, out of interest rather than challenge.",
      "mood": "Pleased with how the work went.",
      "openness": 4
    },
    "opening_beat": "\"That landed really well, by the way. How are you feeling about it all?\"",
    "success_looks_like": "The user states a direction plainly and leaves it there.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what makes you say that once, with genuine curiosity.",
      "Respond concretely and helpfully to a clear direction.",
      "Become cooler if the user compares themselves to a colleague or attaches an ultimatum."
    ]
  }$j$::jsonb,
  $md$Today, say one sentence about where you would like to be heading, and then stop. Log the sentence and the reply.$md$
),
(
  (select id from public.skills where slug = 'saying-what-you-want'),
  3,
  'Ask for scope, not a title',
  $md$A title is a decision somebody else makes, usually once a year, usually with other people in the room and a budget attached. Scope is a thing your manager can hand you on a Tuesday.

**The move:** ask for the work, not the label.

*Could I own the reporting piece?* is answerable immediately. It costs nothing to say yes to, it is reversible, and it does not need anybody's approval but the person you are asking. Compare that with *could I be promoted to senior*, which needs a cycle, a case, a calibration meeting and a budget line.

The thing nobody explains is that this is also how the title arrives. A promotion case is not built from ambition or from years served — it is built from evidence that somebody has already been operating at the next level. Which means the sequence is: get the scope, do it visibly for a couple of quarters, and then the title conversation is a formality about something already true. Asking for the title first is asking somebody to bet on you; asking for the scope first is offering to show them.

Look for the thing nobody owns. Every team has two or three of them — a process that keeps half breaking, a relationship nobody manages, a piece of reporting everybody complains about. Unowned work is the cheapest possible ask, because you are not taking it from anybody and you are solving a problem your manager already has.

Say what you would stop doing. *I would want to hand the weekly reconciliation to somebody* turns an ask into a plan and answers the objection before it arrives.

If you keep one thing: ask for the work. The title follows the work far more reliably than the work follows the title.$md$,
  $j$[
    {
      "situation": "You want to be more senior.",
      "line": "Could I own the reporting piece?",
      "why": "Answerable on a Tuesday by one person, reversible, and free. A title needs a cycle, a case, a calibration meeting and a budget line."
    },
    {
      "situation": "You are looking for something to ask for.",
      "line": "(find the thing nobody owns)",
      "why": "Unowned work is the cheapest possible ask — you take it from nobody, and you solve a problem your manager already has."
    },
    {
      "situation": "They are worried about your workload.",
      "line": "I would want to hand the weekly reconciliation to somebody.",
      "why": "Turns an ask into a plan and answers the objection before it is made."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is scope easier to get than a title?",
      "options": [
        { "text": "It is worth less.", "correct": false, "note": "It is frequently worth more, and it is what the title is eventually built from." },
        { "text": "Managers like delegating.", "correct": false, "note": "Some do. The reason is structural rather than about their preferences." },
        { "text": "One person can say yes to it, today.", "correct": true, "note": "No cycle, no case, no calibration meeting, no budget line. It is also reversible, which makes yes cheap." },
        { "text": "Nobody notices scope changes.", "correct": false, "note": "The opposite is the point — visible scope is exactly what the title case is made of." }
      ],
      "explain": "Scope is a Tuesday decision. A title is an annual one with a committee attached."
    },
    {
      "prompt": "How does a promotion case actually get built?",
      "options": [
        { "text": "From years served and reliability.", "correct": false, "note": "That is the ledger theory again, and it produces people who are surprised at review time." },
        { "text": "From a well-argued case at the right moment.", "correct": false, "note": "The case is the paperwork. It has to be describing something that already happened." },
        { "text": "From evidence you have already been operating at the next level.", "correct": true, "note": "Which is why scope comes first: get it, do it visibly for a couple of quarters, and the title conversation is a formality about something already true." },
        { "text": "From your manager advocating for you.", "correct": false, "note": "They do advocate, and they advocate with evidence. Without it there is nothing to say in the room." }
      ],
      "explain": "Asking for the title is asking somebody to bet on you. Asking for the scope is offering to show them."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "scope", "label": "Asked for work, not a label", "description": "Named a piece of work rather than a title or a level." },
      { "key": "specific", "label": "Named something specific", "description": "Picked an actual area rather than asking for more generally." },
      { "key": "unowned", "label": "Chose something unowned", "description": "Took it from nobody and solved a problem that already existed." },
      { "key": "trade", "label": "Said what would move", "description": "Answered the workload objection before it arrived." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Your one-to-one. The reporting process breaks most months, everybody complains about it, and nobody owns it.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Says yes readily to somebody taking an unowned problem off their plate. Deflects title conversations to the cycle in April.",
      "mood": "Slightly harassed about the reporting, as it happens.",
      "openness": 4
    },
    "opening_beat": "\"Reporting broke again on Friday. Anyway — what did you want to talk about?\"",
    "success_looks_like": "The user asks to own a specific unowned piece of work.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Say yes readily and concretely to somebody taking on an unowned problem.",
      "Deflect any title or level question to the April cycle, politely.",
      "Never offer the reporting to the user yourself."
    ]
  }$j$::jsonb,
  $md$Today, name one thing nobody owns and ask to own it. Log what you asked for and what came back.$md$
),
(
  (select id from public.skills where slug = 'saying-what-you-want'),
  4,
  'Before the vacancy',
  $md$By the time a role is posted, there is usually somebody in mind. That is not corruption, it is how the decision gets made: somebody looks at the shape of the job and thinks of the people who have been visibly heading that way.

Which means the moment of decision is months before the moment of application, and applying is frequently the last available step rather than the first.

**The move:** say it before there is anything to apply for.

Six months early is not too early — it is the only version that works. *If something like that comes up, I would want to be considered* is a sentence that costs nothing, needs no answer, and puts you in the set of people who come to mind when the shape of a job is being discussed. That set is small, and it is composed almost entirely of people who said something.

This is where a shy person loses most reliably, and the mechanism is cruel: waiting for the posting feels like the correct, modest, procedurally proper thing to do. It is also the exact point at which saying it first is no longer available to you. You did everything right by the rules of a process that had already happened.

There is a version for jobs that do not exist yet, and it is better still. *I think there is a role in this that nobody is doing* is how a surprising number of jobs get created — by somebody describing a gap out loud to a person who then cannot stop seeing it.

And say it more than once, to more than one person. The people in the room when the shape of a job is discussed are not only your manager. A skip-level who has heard you say it once will say it for you, and they will do it without being asked.

If you keep one thing: say it while there is nothing to say it about. That is what being considered is made of.$md$,
  $j$[
    {
      "situation": "There is no vacancy and nothing to apply for.",
      "line": "If something like that comes up, I would want to be considered.",
      "why": "Costs nothing, needs no answer, and puts you in the small set of people who come to mind when the shape of a job is being discussed."
    },
    {
      "situation": "The role has just been posted.",
      "line": "(the decision that mattered happened months ago)",
      "why": "Applying is often the last available step. Waiting for the posting feels procedurally correct and is the point at which saying it first is gone."
    },
    {
      "situation": "The job you want does not exist.",
      "line": "I think there is a role in this that nobody is doing.",
      "why": "A surprising number of jobs get created exactly this way — by somebody naming a gap to a person who then cannot stop seeing it."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does waiting for the posting lose?",
      "options": [
        { "text": "Because there is competition.", "correct": false, "note": "There is, and that is not what decides it. The shortlist forms before the competition starts." },
        { "text": "Because the decision was made months earlier.", "correct": true, "note": "Somebody looks at the shape of a job and thinks of people who have been visibly heading that way. Applying is often the last step, not the first." },
        { "text": "Because internal candidates are rarely picked.", "correct": false, "note": "They frequently are — usually the one who said something six months ago." },
        { "text": "Because you will not be ready.", "correct": false, "note": "Nobody is ready, which is the next lesson and a separate problem." }
      ],
      "explain": "Say it while there is nothing to say it about."
    },
    {
      "prompt": "Who should hear it?",
      "options": [
        { "text": "HR, so it is on record.", "correct": false, "note": "A record is not what does the work. The work is done by somebody thinking of you in a conversation." },
        { "text": "Nobody until you are sure.", "correct": false, "note": "Certainty is not a prerequisite for being considered, and waiting for it is how the six months pass." },
        { "text": "Your manager, and at least one person above them.", "correct": true, "note": "The room where a job's shape is discussed is not only your manager. A skip-level who has heard it once will say it for you, unprompted." },
        { "text": "Your manager only — anything else goes round them.", "correct": false, "note": "Saying what you want to a skip-level is not going round anybody. It is the same sentence in a second room." }
      ],
      "explain": "More than once, to more than one person. Other people will repeat it for you."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "early", "label": "Said it early", "description": "Raised it before there was anything to apply for." },
      { "key": "no_answer_needed", "label": "Asked for nothing", "description": "Made it a statement that needs no decision today." },
      { "key": "more_than_one", "label": "Told more than one person", "description": "Did not rely on a single memory." },
      { "key": "specific", "label": "Named the shape of it", "description": "Described the kind of role rather than a vague more." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A skip-level coffee. There is no open role, and the team lead job is the one you would want if it ever existed.",
    "partner": {
      "name": "Nadine",
      "role": "your manager's manager",
      "personality": "Remembers who says what and repeats it in staffing conversations. Receives a stated interest warmly and files it.",
      "mood": "Unhurried, genuinely curious.",
      "openness": 4
    },
    "opening_beat": "\"So where do you see this going, for you?\"",
    "success_looks_like": "The user names the kind of role they would want before one exists.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Take a stated interest seriously and say you will remember it.",
      "Respond vaguely and pleasantly to a vague answer.",
      "Never mention a specific upcoming role."
    ]
  }$j$::jsonb,
  $md$Today, tell one person the kind of work you would want if it came up. There does not have to be an opening. Log who and what.$md$
),
(
  (select id from public.skills where slug = 'saying-what-you-want'),
  5,
  'Nobody feels ready',
  $md$Two habits do most of the damage here, and both of them feel like modesty from inside. Waiting to be ready, and hoping to be noticed.

Waiting to be ready assumes readiness is a state that arrives. It is not. The people who get the bigger work are not more ready than you — they are people who took it slightly too early and closed the gap while doing it, which is the only way anybody has ever become ready for anything. The feeling of not being ready is not a signal about your competence; it is a signal that the work is bigger than the last work, which is what you were asking for.

**The move:** put your hand up before you feel qualified, and say what you would need.

That second clause is what makes it honest rather than reckless. *I would want to do it — I have not run a client relationship before, so I would want somebody to sit in for the first two.* That is not a hedge and it is not underselling. It is a competent person scoping a piece of work, which is exactly what the job you want consists of.

The visible gap is almost never the reason people are turned down, incidentally. Managers assume gaps. What they are actually assessing is whether you can see your own gaps and say them out loud — because the version of you who cannot is the one that costs them a quarter.

And notice the asymmetry, because it is what makes this decidable. Putting your hand up and not getting it costs you an afternoon of mild disappointment and puts you on the list for next time. Not putting it up costs you the thing, silently, with no feedback, and you will never find out you would have got it.

If you keep one thing: say yes to the thing you are not ready for, out loud, with the gap named. That is what everybody who looks ready actually did.$md$,
  $j$[
    {
      "situation": "The work is a step up and you have not done it before.",
      "line": "I would want to do it — I have not run a client relationship before, so I would want somebody in for the first two.",
      "why": "A competent person scoping a piece of work, which is what the job you want consists of. Naming the gap is not underselling."
    },
    {
      "situation": "You are waiting until you are ready.",
      "line": "(nobody arrives ready)",
      "why": "The people who get the bigger work took it slightly too early and closed the gap while doing it. That is the only route there has ever been."
    },
    {
      "situation": "You did not put your hand up and somebody else did.",
      "line": "(that cost you the thing, silently)",
      "why": "Not asking has no feedback attached. You never find out you would have got it, which is why the habit survives."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does not feeling ready actually tell you?",
      "options": [
        { "text": "That you need more experience first.", "correct": false, "note": "The experience is on the other side of the work. Waiting for it is waiting for something that arrives by doing this." },
        { "text": "That the work is bigger than the last work.", "correct": true, "note": "Which is what you were asking for. It is a signal about the size of the job, not about your competence." },
        { "text": "That you should say yes but manage expectations.", "correct": false, "note": "Managing expectations downward before you start is a way of pre-apologising. Name the gap, do not shrink the job." },
        { "text": "That somebody else would do it better.", "correct": false, "note": "They would also not feel ready. You are comparing your inside to their outside." }
      ],
      "explain": "Everybody who looks ready took something slightly too early and closed the gap while doing it."
    },
    {
      "prompt": "Why name the gap out loud?",
      "options": [
        { "text": "So they cannot blame you later.", "correct": false, "note": "Defensive, and it turns a scoping conversation into insurance." },
        { "text": "Because honesty is the right thing.", "correct": false, "note": "It is, and there is a more practical reason that will actually get you to do it." },
        { "text": "So they can decide whether to risk it.", "correct": false, "note": "That framing hands them a reason to say no. You are scoping the work, not auditioning." },
        { "text": "Because seeing your own gaps is what is being assessed.", "correct": true, "note": "Managers assume gaps. The version of you who cannot see them is the one that costs a quarter, and that is the real thing being judged." }
      ],
      "explain": "Hand up, gap named, support requested. That is a competent person scoping work."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "hand_up", "label": "Put their hand up", "description": "Said yes before feeling qualified." },
      { "key": "named_gap", "label": "Named the gap", "description": "Said what they had not done before, plainly." },
      { "key": "asked_support", "label": "Said what they would need", "description": "Scoped the work rather than promising to cope." },
      { "key": "no_undersell", "label": "Did not undersell", "description": "Named the gap without shrinking the ask." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A team meeting. A piece of work has come up that is a clear step up — running a client relationship directly — and nobody has volunteered.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Assumes gaps and is reassured by somebody naming their own. Puts the work with whoever asks, and takes silence as disinterest.",
      "mood": "Looking round the room.",
      "openness": 4
    },
    "opening_beat": "\"So — does anyone want to take the Harding account? It would mean running it directly.\"",
    "success_looks_like": "The user volunteers and names what they would need.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Respond warmly to somebody who volunteers and names a gap, and offer the support they ask for.",
      "Take silence as disinterest and move on to giving it to somebody else.",
      "Never ask the user directly whether they want it."
    ]
  }$j$::jsonb,
  $md$Today, put your hand up for one thing you do not feel ready for, and say what you would need. Log both halves.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('saying-what-you-want', 1, 'choice', $j${
  "beats": [
    {
      "situation": "Two years of consistently good work. Nothing has changed and nobody has offered you anything bigger.",
      "prompt": "What is most likely going on?",
      "options": [
        { "text": "Your manager is holding you where you are useful.", "correct": false, "note": "It happens and it is rarer than it feels. Assuming it turns an absence into a grievance and stops you doing the one thing that works." },
        { "text": "There is nothing bigger available.", "correct": false, "note": "There usually is, and it went to somebody whose name came up when the shape of it was being discussed." },
        { "text": "You need to be better before anything changes.", "correct": false, "note": "The trap. More excellence produces more of the same work, because excellence signals competence rather than ambition." },
        { "text": "You look exactly like somebody who is happy where they are.", "correct": true, "note": "Somebody who wants more and somebody who is content both turn up, do good work, and say nothing. There is no tell." }
      ]
    },
    {
      "situation": "You are about to say it and it feels presumptuous.",
      "prompt": "What are you actually doing?",
      "options": [
        { "text": "Making a case that you deserve more.", "correct": false, "note": "That is what makes it feel enormous, and it is not what is being asked of you. No verdict is required from anybody." },
        { "text": "Supplying a fact nobody can get any other way.", "correct": true, "note": "Your preferences are invisible from outside. Saying them is information, not a claim about your worth." },
        { "text": "Putting your manager on the spot.", "correct": false, "note": "Only if you ask for a decision. A direction needs no answer today." },
        { "text": "Starting a negotiation.", "correct": false, "note": "A negotiation has two positions and a thing to settle. This has neither." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('saying-what-you-want', 2, 'line', $j${
  "says": "That landed really well, by the way. How are you feeling about it all?",
  "model": {
    "line": "Good — and honestly, I would like to be running something like this by next year.",
    "why": "A direction rather than a request. Nothing needs answering today, nobody is compared to anybody, and it makes them partly responsible for where you end up."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Say what you want, in your own name" },
    { "kind": "forbids_any", "requirement": "No comparison and no ultimatum",
      "words": ["than tom", "longer than", "deserve", "or i will", "look elsewhere", "other offers", "unfair", "overdue", "everyone else"] },
    { "kind": "max_questions", "requirement": "A direction, not a request for permission", "n": 0 },
    { "kind": "max_words", "requirement": "One sentence — leave it with them", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('saying-what-you-want', 3, 'line', $j${
  "says": "Reporting broke again on Friday. Anyway — what did you want to talk about?",
  "model": {
    "line": "That, actually. Could I own the reporting piece? I would want to hand the weekly reconciliation to somebody.",
    "why": "A specific unowned problem, asked for as work rather than as a label, with the workload objection answered before it arrives. One person can say yes to this today."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Ask for it" },
    { "kind": "forbids_any", "requirement": "Ask for the work, not the label",
      "words": ["promotion", "promoted", "senior", "title", "level", "band", "pay rise", "raise"] },
    { "kind": "contains_any", "requirement": "Name the piece of work",
      "words": ["own", "reporting", "take on", "run", "lead", "pick up", "responsible"] },
    { "kind": "max_words", "requirement": "Under thirty-five words", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('saying-what-you-want', 4, 'choice', $j${
  "beats": [
    {
      "situation": "A skip-level coffee. There is no open role. The team lead job is the one you would want if it existed.",
      "prompt": "\"So where do you see this going, for you?\"",
      "options": [
        { "text": "I am happy where I am for now, really.", "correct": false, "note": "The reflex, and it is filed exactly as stated. You have just told the person who staffs things that you want nothing." },
        { "text": "I would like to keep growing and taking on more.", "correct": false, "note": "True of everybody and therefore about nobody. Nothing here can be routed towards you." },
        { "text": "Depends what comes up, really.", "correct": false, "note": "Polite and empty. It leaves the shape of the thing entirely to them." },
        { "text": "If a team lead role ever came up, I would want to be considered.", "correct": true, "note": "Names the shape, needs no answer, and puts you in the small set of people who come to mind when a job is being discussed." }
      ]
    },
    {
      "situation": "The role gets posted four months later.",
      "prompt": "What decided the shortlist?",
      "options": [
        { "text": "The applications.", "correct": false, "note": "The applications confirm a shortlist that mostly formed earlier, when somebody looked at the shape of the job and thought of people." },
        { "text": "Who had said, months earlier, that they wanted it.", "correct": true, "note": "Which is why applying is frequently the last available step. Waiting for the posting feels procedurally correct and is the point at which speaking first is gone." },
        { "text": "Performance ratings.", "correct": false, "note": "They matter, and they are held by lots of people. The differentiator is who came to mind." },
        { "text": "Who has been there longest.", "correct": false, "note": "The ledger theory again, and it is how people end up surprised." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('saying-what-you-want', 5, 'line', $j${
  "says": "So — does anyone want to take the Harding account? It would mean running it directly.",
  "model": {
    "line": "I would. I have not run a client relationship on my own before, so I would want you in for the first couple.",
    "why": "Hand up, gap named, support requested. That is a competent person scoping a piece of work — which is exactly what the job you want consists of."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Volunteer, in your own name" },
    { "kind": "forbids_any", "requirement": "Name the gap without shrinking the ask",
      "words": ["probably not the best", "someone else", "only if nobody", "not sure i", "might not be", "do not want to overstep", "just a thought"] },
    { "kind": "min_words", "requirement": "Say what you would need", "n": 12 },
    { "kind": "max_words", "requirement": "Two sentences", "n": 40 }
  ]
}$j$::jsonb);
