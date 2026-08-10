-- Work, track 3: Raising a problem.
--
-- The only track in this topic whose failure mode is an exit rather than a
-- missed opportunity. Nobody is taught how to complain at work, so a quiet
-- person absorbs it, and absorbing is a decision that gets made every day
-- until the day they resign over something that was two minutes of
-- conversation in week three.
--
-- Telling the person directly is the scene, because it is the one move here
-- that depends entirely on what comes back — the whole difficulty is holding
-- a small, factual point while somebody explains why it was not their fault.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'raising-a-problem'),
  1,
  'Behaviour, cost, change',
  $md$People are not marked as difficult for raising problems. They are marked as difficult for raising them in a particular shape, and the shape is avoidable.

**The move:** say the behaviour, say what it cost, and ask for one specific change.

*Twice this week the file came at six, and I stayed late to turn it round. Could we agree it lands by three?* Every clause in that is doing a job, and none of them is an opinion.

**The behaviour** is a fact about what happened. *The file came at six* can be checked, agreed with, and fixed. *He is completely disorganised* is a claim about a person, and a claim about a person invites a defence of that person — usually from that person, at length, and nothing gets decided. The rule is simple: if it could not be written in a calendar entry, it is probably a character judgement wearing a description.

**The cost** is what makes it a problem rather than a preference. Without it you are describing something you did not like, and the honest answer is *and?* With it, there is a consequence somebody has to weigh.

**The change** is the part people leave out, and leaving it out is what gets a complaint filed as attitude. A grievance with nothing attached is a mood. One specific, small, answerable ask turns it into a piece of work — and it is also the thing that actually makes it stop.

One ask, not a redesign. *Could we agree it lands by three* is answerable in a second. *Could we rethink how this whole process works* is a project, and projects get scheduled and then absorbed.

If you keep one thing: be boring about it. Facts, a cost, and one small change is very hard to argue with and very hard to hold against you.$md$,
  $j$[
    {
      "situation": "The file keeps arriving at the end of the day and you keep staying late.",
      "line": "Twice this week the file came at six and I stayed late to turn it round. Could we agree it lands by three?",
      "why": "A fact, a consequence, and one small ask. There is nothing in it to defend against and nothing in it to file as attitude."
    },
    {
      "situation": "You are about to say he is completely disorganised.",
      "line": "(that invites a defence of him, not a fix)",
      "why": "A claim about a person is an opinion somebody has to agree with, and they will not. A claim about what happened can simply be checked."
    },
    {
      "situation": "You have described the problem and stopped there.",
      "line": "(add the ask, or it is a mood)",
      "why": "A complaint with nothing attached is what gets filed as attitude. The ask is also the only part that makes it stop."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does he is disorganised go wrong?",
      "options": [
        { "text": "It is unkind.", "correct": false, "note": "It might be entirely fair. Fairness is not what determines whether it works." },
        { "text": "It is unprofessional.", "correct": false, "note": "A label rather than a mechanism, and it does not tell you what to say instead." },
        { "text": "It is a claim about a person, so it gets defended rather than fixed.", "correct": true, "note": "An opinion has to be agreed with, and nobody agrees to that one. A fact about what happened can be checked and acted on." },
        { "text": "It is too vague.", "correct": false, "note": "Close, and the problem is not precision. Even a very precise character judgement gets defended rather than fixed." }
      ],
      "explain": "If it could not go in a calendar entry, it is a judgement wearing a description."
    },
    {
      "prompt": "What does the ask actually do?",
      "options": [
        { "text": "It turns a grievance into a piece of work.", "correct": true, "note": "And it is the part that makes it stop. Without it you have described something you did not like, and the honest reply is: and?" },
        { "text": "It makes you sound constructive.", "correct": false, "note": "It does, and that is how it looks rather than what it does." },
        { "text": "It shows you have thought about it.", "correct": false, "note": "True and secondary. The value is that somebody can act on it today." },
        { "text": "It stops you sounding emotional.", "correct": false, "note": "Being upset is fine and is not the problem. The problem is having nothing for anybody to do." }
      ],
      "explain": "One small answerable ask. Not a redesign — a redesign is a project, and projects get absorbed."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "behaviour", "label": "Described the behaviour", "description": "Said what happened rather than what somebody is like." },
      { "key": "cost", "label": "Named the cost", "description": "Made clear why it is a problem rather than a preference." },
      { "key": "ask", "label": "Asked for one change", "description": "Attached something small and answerable." },
      { "key": "boring", "label": "Kept it boring", "description": "Facts rather than feeling, with no character judgement in it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A quiet moment with a colleague whose handover file has arrived at six o'clock twice this week, both times leaving you working late.",
    "partner": {
      "name": "Sam",
      "role": "a colleague you work alongside",
      "personality": "Defensive about character claims and entirely reasonable about facts. Agrees quickly to a small specific change.",
      "mood": "Busy, not expecting this.",
      "openness": 4
    },
    "opening_beat": "\"Oh — hi. Did you get everything you needed yesterday?\"",
    "success_looks_like": "The user states the behaviour and the cost and asks for one specific change.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Defend yourself at length against anything that sounds like a judgement about you.",
      "Agree readily and concretely to a factual point with a small ask attached.",
      "Never raise the problem yourself."
    ]
  }$j$::jsonb,
  $md$Today, raise one small thing as behaviour, cost and one change. Log the three parts and what came back.$md$
),
(
  (select id from public.skills where slug = 'raising-a-problem'),
  2,
  'Say it to them first',
  $md$Almost every complaint that becomes a problem became one by skipping this step.

Going to the person first is not a moral requirement. It is the thing that makes everything after it possible: your manager's first question will be whether you have raised it directly, and *no* is an answer that changes what the conversation is about. It stops being the file arriving at six and starts being why you went round somebody.

**The move:** one sentence, the week it happens, said as logistics rather than as a confrontation.

The size is the whole technique. A small thing said small is an ordinary working exchange — *hey, could the file come earlier? I ended up staying late with it* — and it costs about eight seconds. The same thing said in month four, with four instances attached, is a confrontation, because by then it has to justify the four months.

Early also means you are not yet annoyed, and that is worth more than any phrasing. Almost nobody can say a thing lightly once they have been carrying it, and the carrying is audible.

Say it in person or on a call where you can. Written complaints read colder than they were meant, they last for ever, and they can be forwarded — which turns a two-line request into a document.

And expect a defence. Most people explain themselves before they agree, and the explanation is not a refusal — it is what people do while they decide. Let it run, do not argue with it, and come back to the ask. *That makes sense — could we still try for three?*

If you keep one thing: raise it while it is small enough to sound like nothing. That is not avoiding the conversation. It is having it early enough to be cheap.$md$,
  $j$[
    {
      "situation": "It has happened twice this week and it is Thursday.",
      "line": "Hey — could the file come earlier? I ended up staying late with it.",
      "why": "One sentence, said as logistics, costing about eight seconds. The same point in month four has four months to justify and becomes a confrontation."
    },
    {
      "situation": "They start explaining why it was not possible.",
      "line": "That makes sense — could we still try for three?",
      "why": "Most people explain before they agree. The explanation is not a refusal, so let it run and return to the ask rather than arguing with it."
    },
    {
      "situation": "You are drafting it as an email so it is clearer.",
      "line": "(say it out loud instead)",
      "why": "Written complaints read colder than they were meant, they last for ever, and they can be forwarded — which turns two lines into a document."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why go to the person first?",
      "options": [
        { "text": "It is the fair thing to do.", "correct": false, "note": "It is, and fairness is not the argument that will get you to do it on a Thursday afternoon." },
        { "text": "Because otherwise the conversation stops being about the problem.", "correct": true, "note": "Your manager's first question is whether you raised it directly, and no changes the subject to why you went round somebody." },
        { "text": "They might not know they are doing it.", "correct": false, "note": "Often true, and it is a reason it works rather than the reason to do it first." },
        { "text": "It keeps it private.", "correct": false, "note": "A benefit. The structural point is what happens to every conversation after this one." }
      ],
      "explain": "Direct first is what keeps the next conversation about the file rather than about you."
    },
    {
      "prompt": "Why does raising it early matter more than phrasing it well?",
      "options": [
        { "text": "Because you are not annoyed yet.", "correct": true, "note": "Almost nobody says a thing lightly once they have been carrying it, and the carrying is audible whatever words are chosen." },
        { "text": "Because they will have forgotten later.", "correct": false, "note": "A practical nuisance rather than the mechanism, and it is fixable with a date." },
        { "text": "Because it might stop on its own.", "correct": false, "note": "That is the hope that produces month four." },
        { "text": "Because small problems are easier to fix.", "correct": false, "note": "True of the problem and not of the conversation, which is what this lesson is about." }
      ],
      "explain": "Say it while it is small enough to sound like nothing."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "direct", "label": "Went to them first", "description": "Raised it with the person rather than around them." },
      { "key": "small", "label": "Kept it small", "description": "One sentence, said as logistics." },
      { "key": "early", "label": "Said it early", "description": "Raised it while it was still one or two instances." },
      { "key": "held_the_ask", "label": "Came back to the ask", "description": "Let the explanation run without arguing, then repeated the request." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Thursday afternoon. The handover file has come at six twice this week. Your colleague is at the next desk and nothing has been said.",
    "partner": {
      "name": "Sam",
      "role": "a colleague you work alongside",
      "personality": "Explains at length before agreeing to anything, and is entirely reasonable underneath it. Gets defensive if argued with and agrees if the ask simply comes back.",
      "mood": "Stretched, well meaning.",
      "openness": 4
    },
    "opening_beat": "\"Sorry, mad week. Did that all work out in the end?\"",
    "success_looks_like": "The user raises it in one light sentence and returns to the ask after the explanation.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Explain at length why it happened before agreeing to anything.",
      "Agree readily if the user lets the explanation run and repeats the ask.",
      "Become defensive and stop agreeing if the user argues with the explanation."
    ]
  }$j$::jsonb,
  $md$Today, say one small thing directly to the person, the week it happened. Log what you said and how long it took.$md$
),
(
  (select id from public.skills where slug = 'raising-a-problem'),
  3,
  'Taking it upward',
  $md$You raised it directly, it did not change, and now it has to go to your manager. This is the point where a reasonable person most often becomes, in the record, a difficult one — and it is almost entirely about framing.

**The move:** bring it as a problem to be solved, not as a grievance to be judged.

Those two produce different opening sentences. A grievance opens with the person: *I need to talk to you about Sam.* A problem opens with the work: *The handover is landing too late for me to turn it round, and I have not been able to fix it with Sam directly.* The second contains all the same information, including the name, and asks your manager to do something rather than to take a side.

Say what you have already tried, unprompted. It answers the first question before it is asked, it shows this is not a first resort, and it quietly makes the point that you are not asking them to do something you were unwilling to do yourself.

Say what you want from them. *Could you set the expectation on timing?* or *Can you tell me whether I am reading this wrong?* Managers are much better at doing a specific thing than at receiving a situation, and a complaint without an ask leaves them to invent a response — which is frequently a meeting nobody wanted.

Two things to leave out. Everybody else's opinion — *a few of us have noticed* is a coalition, and a coalition raises the temperature by an order of magnitude. And motive: *I think he does it deliberately* is unprovable, unanswerable, and the one line that makes you look like the problem.

If you are wrong, this framing costs you nothing. *Am I reading this wrong?* asked honestly is a completely safe question, and it is the difference between somebody with a complaint and somebody with judgement.

If you keep one thing: lead with the work, not with the person. The name can come second and still be entirely clear.$md$,
  $j$[
    {
      "situation": "You need to raise it with your manager after trying directly.",
      "line": "The handover is landing too late for me to turn it round, and I have not managed to fix it with Sam directly.",
      "why": "Opens with the work, includes the name, and answers the first question before it is asked. It asks for help rather than for a verdict."
    },
    {
      "situation": "You are about to say a few of us have noticed.",
      "line": "(that is a coalition, and it changes the temperature)",
      "why": "Speaking for other people turns a solvable problem into a factional one, and your manager now has an incident rather than a request."
    },
    {
      "situation": "You are not completely sure you are being reasonable.",
      "line": "Am I reading this wrong?",
      "why": "Asked honestly it is completely safe, and it is the line that separates somebody with a complaint from somebody with judgement."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "How should it open?",
      "options": [
        { "text": "I need to talk to you about Sam.", "correct": false, "note": "That is a grievance, and it asks your manager to take a side before they know what about." },
        { "text": "With the work, and the name second.", "correct": true, "note": "The handover is landing too late contains all the same information and asks them to solve something rather than judge somebody." },
        { "text": "With how long it has been going on.", "correct": false, "note": "It leads with the accumulation, which sounds like something that should have been raised earlier — and invites that question first." },
        { "text": "With how it is making you feel.", "correct": false, "note": "Honest, and it makes the subject you rather than the thing you want changed." }
      ],
      "explain": "Lead with the work. The name comes second and is no less clear for it."
    },
    {
      "prompt": "Which line does the most damage to you?",
      "options": [
        { "text": "I have already raised it with him.", "correct": false, "note": "The opposite — say this unprompted. It answers the first question and shows it is not a first resort." },
        { "text": "I think he does it deliberately.", "correct": true, "note": "Unprovable, unanswerable, and it moves the subject from a late file to your reading of somebody's motives. This is the line that makes you the problem." },
        { "text": "Could you set the expectation on timing?", "correct": false, "note": "An ask, which is exactly what a manager can act on." },
        { "text": "Am I reading this wrong?", "correct": false, "note": "Safe and useful. It is what separates somebody with a complaint from somebody with judgement." }
      ],
      "explain": "Never assign motive. You cannot know it and nothing can be done with it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "work_first", "label": "Led with the work", "description": "Opened on the problem rather than on the person." },
      { "key": "already_tried", "label": "Said what they had tried", "description": "Answered the direct-first question unprompted." },
      { "key": "an_ask", "label": "Asked for something specific", "description": "Gave their manager an action rather than a situation." },
      { "key": "no_motive", "label": "Assigned no motive", "description": "Kept out speculation about why, and spoke only for themselves." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Your one-to-one. You raised the handover timing with Sam three weeks ago, it improved for a week, and it is back to six o'clock.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Helpful when handed a problem and visibly wary when handed a grievance. Asks immediately whether it has been raised directly.",
      "mood": "Attentive.",
      "openness": 4
    },
    "opening_beat": "\"You said there was something you wanted to raise?\"",
    "success_looks_like": "The user frames it as a problem to solve, says what they have tried, and asks for something specific.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask whether it has been raised directly if the user does not say so first.",
      "Become noticeably cautious at speculation about motive or at anything spoken on behalf of other people.",
      "Act readily on a specific ask."
    ]
  }$j$::jsonb,
  $md$Today, describe one problem out loud starting with the work rather than the person. Log the sentence you opened with.$md$
),
(
  (select id from public.skills where slug = 'raising-a-problem'),
  4,
  'Do not stockpile',
  $md$Absorbing is not free, and the reason people do it anyway is that each individual instance genuinely is too small to mention.

That is true, and it is how the stockpile is built. Nothing is worth raising on its own, so nothing is raised, and eleven months later there is a list. Then the list gets delivered — usually at a review, occasionally in a resignation — and the effect is the opposite of everything on it.

**The move:** raise one thing at the time it happens, and let the small ones go.

A list puts somebody on trial. However true each item is, twelve at once is not twelve problems, it is a case, and a case invites a defence rather than a change. It also cannot be acted on: nobody can fix twelve things, so they fix none and manage you instead.

It is worse than that, because the list undermines the items. *Why is this the first I am hearing of it* is a fair question with no good answer, and the honest one — *each one felt too small* — makes the whole thing sound like a grudge rather than a set of facts.

So the discipline is upstream. Raise it small, at the time, or decide it is genuinely fine and let it go — and mean that. What you cannot do is bank it. A thing you decided not to raise is not saved up, it is spent.

If you notice you have a list already, do not deliver it. Pick the one that still matters most, raise that one on its own, at normal size, as though it happened this week. The others will either recur, in which case they get raised properly, or they will turn out to have been the mood of a bad quarter.

If you keep one thing: never save it up. One thing at the time is a working conversation; five at once is a campaign, whoever is right.$md$,
  $j$[
    {
      "situation": "Something small happened and it is not worth mentioning.",
      "line": "(then let it go properly, or say it now)",
      "why": "A thing you decided not to raise is not banked, it is spent. Half-deciding is what builds the stockpile."
    },
    {
      "situation": "You have a list of eleven things and a review coming up.",
      "line": "(pick the one that still matters)",
      "why": "Twelve at once is a case rather than twelve problems, and a case invites a defence. One, at normal size, can actually be fixed."
    },
    {
      "situation": "\"Why is this the first I am hearing of it?\"",
      "line": "(a fair question with no good answer)",
      "why": "Each one felt too small is honest and makes the whole list sound like a grudge. The only defence is not to have built one."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is a list worse than one item?",
      "options": [
        { "text": "It takes too long to get through.", "correct": false, "note": "Length is not the failure. A short list does the same thing." },
        { "text": "Some of the items are weak.", "correct": false, "note": "Often true, and even a list of strong items produces the same reaction." },
        { "text": "Nobody can fix twelve things, so they manage you instead.", "correct": true, "note": "Twelve at once is a case, not twelve problems. A case invites a defence, and the response becomes about the person raising it." },
        { "text": "It sounds bitter.", "correct": false, "note": "How it sounds is downstream of what it does. The mechanism is that it cannot be acted on." }
      ],
      "explain": "One thing at the time is a working conversation. Five at once is a campaign, whoever is right."
    },
    {
      "prompt": "Something small happens and it is genuinely not worth raising. What do you do?",
      "options": [
        { "text": "Note it, in case there is a pattern.", "correct": false, "note": "This is exactly how a stockpile gets built, and it always feels like diligence at the time." },
        { "text": "Let it go, and mean it.", "correct": true, "note": "The decision has to be real. A thing you decided not to raise is not saved up — it is spent." },
        { "text": "Raise it anyway, to be safe.", "correct": false, "note": "Overcorrecting. Not everything is worth a conversation, and raising everything is its own problem." },
        { "text": "Mention it in passing so it is on the record.", "correct": false, "note": "A record with no ask attached is a mood, and it will be remembered as one." }
      ],
      "explain": "Raise it small at the time, or let it go properly. Banking it is the one option that does not work."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one", "label": "Raised one thing", "description": "Did not deliver a list." },
      { "key": "at_the_time", "label": "Raised it near the time", "description": "Did not wait for a review or a breaking point." },
      { "key": "let_go", "label": "Let the small ones go", "description": "Made a real decision rather than banking them." },
      { "key": "normal_size", "label": "Kept it normal size", "description": "Raised it as though it happened this week." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Your review, and you have been quietly keeping score for eleven months. There are about nine things on the mental list.",
    "partner": {
      "name": "Rae",
      "role": "your manager, running your review",
      "personality": "Open and constructive with one clear thing, and defensive when handed an accumulation. Asks why they are only hearing it now.",
      "mood": "Positive about the review so far.",
      "openness": 4
    },
    "opening_beat": "\"Anything on your side? Anything that has not been working?\"",
    "success_looks_like": "The user raises one thing at normal size rather than the accumulated list.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Engage properly and constructively with a single clear item.",
      "Ask why you are only hearing it now if more than two things arrive together, and become defensive.",
      "Never invite a list."
    ]
  }$j$::jsonb,
  $md$Today, take one thing off your mental list and raise it on its own, at normal size. Log which one and what you let go.$md$
),
(
  (select id from public.skills where slug = 'raising-a-problem'),
  5,
  'When nothing changes',
  $md$You raised it properly, it improved for a fortnight, and now it is exactly as it was. This is the ordinary outcome and almost nobody is told what to do with it.

The two instincts are both bad. One is to go quiet and add it to the stockpile you were told not to build. The other is to raise it again the same way, which is the definition of nagging and is where the reasonable person finally does start to look difficult.

**The move:** raise it once more, differently — name the pattern rather than the instance, and ask what would need to be true.

The instance has already been raised. Raising it again is a repeat, and repeats get heard as a personality. The pattern is new information: *we agreed three, and it has been three twice since. I do not think the three is achievable — what would have to change for it to be?* That is not the same conversation. It puts the arrangement itself on the table rather than the file, and it is much harder to answer with an apology and a resolution to do better.

Asking what would have to be true is the useful question, and it has three honest answers. Something can change, in which case you have a fix. Nothing can, in which case this is the job — and knowing that is worth having, because you can then decide about the job rather than keep grinding at the file. Or nobody knows, which usually means it needs somebody senior in the room.

Then stop. Two properly made attempts is what a reasonable person does; a third is a campaign. After the second, the decision in front of you is not how to raise it again, it is whether this is a thing you can live with — and that is a real decision with real options, including leaving, which is a legitimate one made deliberately rather than by accumulation.

If you keep one thing: the second attempt names the pattern and asks what would have to change. There is no third.$md$,
  $j$[
    {
      "situation": "You agreed three o'clock, and it has been six twice since.",
      "line": "We agreed three, and it has been six twice since. What would have to change for three to be achievable?",
      "why": "Names the pattern rather than the instance, and puts the arrangement on the table instead of the file. Much harder to answer with a resolution to do better."
    },
    {
      "situation": "You are about to raise the same thing the same way.",
      "line": "(that is a repeat, and repeats are heard as a personality)",
      "why": "The instance has been raised. Only new information — the pattern — makes the second conversation a different one."
    },
    {
      "situation": "Two proper attempts and nothing has moved.",
      "line": "(now it is a decision about the job, not about the file)",
      "why": "A third attempt is a campaign. The real question becomes whether this is liveable, which is a decision with options rather than a conversation to keep having."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What makes the second conversation different from the first?",
      "options": [
        { "text": "It is firmer.", "correct": false, "note": "Firmness is not new information, and turning up the volume is how the reasonable person starts to look difficult." },
        { "text": "It goes to somebody more senior.", "correct": false, "note": "Sometimes where it ends and not what makes the second attempt work." },
        { "text": "You name the pattern rather than the instance.", "correct": true, "note": "The instance has been raised — repeating it is a repeat. The pattern is genuinely new, and it puts the arrangement on the table rather than the file." },
        { "text": "You put it in writing.", "correct": false, "note": "That escalates the formality without adding anything, and written complaints last for ever." }
      ],
      "explain": "New information, not more volume. We agreed three, and it has been six twice since."
    },
    {
      "prompt": "Why ask what would have to change?",
      "options": [
        { "text": "All three possible answers are useful.", "correct": true, "note": "Something can change and you have a fix. Nothing can, and this is the job — worth knowing. Or nobody knows, which means it needs somebody senior." },
        { "text": "It sounds collaborative.", "correct": false, "note": "It does, and tone is not what makes it worth asking." },
        { "text": "It puts the work back on them.", "correct": false, "note": "That framing makes it a manoeuvre. The question is genuinely open, which is why it gets a real answer." },
        { "text": "It avoids repeating yourself.", "correct": false, "note": "A side effect. You could avoid repeating yourself by saying nothing." }
      ],
      "explain": "Two attempts, properly made. After that the question is about the job, not the file."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "pattern", "label": "Named the pattern", "description": "Raised the recurrence rather than the latest instance." },
      { "key": "open_question", "label": "Asked what would have to change", "description": "Put the arrangement itself on the table." },
      { "key": "no_heat", "label": "Did not turn up the volume", "description": "Made it new information rather than a firmer repeat." },
      { "key": "stopped", "label": "Knew this was the second and last", "description": "Treated it as the final attempt rather than one of many." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Six weeks after you agreed a three o'clock handover. It held for a fortnight and has been six twice since.",
    "partner": {
      "name": "Sam",
      "role": "a colleague you work alongside",
      "personality": "Apologetic and sincere about individual instances, and unable to keep the arrangement. Engages seriously when the pattern itself is questioned.",
      "mood": "Genuinely sorry, genuinely overloaded.",
      "openness": 4
    },
    "opening_beat": "\"I know, I know — it was late again. I am sorry, it has been a nightmare.\"",
    "success_looks_like": "The user names the pattern and asks what would have to change.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Apologise and promise to do better if the user raises the latest instance.",
      "Engage honestly with the arrangement itself if the user names the pattern, and admit three may not be achievable.",
      "Never propose a change yourself."
    ]
  }$j$::jsonb,
  $md$Today, take one thing you have already raised once and name the pattern instead of the instance. Log the question you asked.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('raising-a-problem', 1, 'line', $j${
  "says": "Oh — hi. Did you get everything you needed yesterday?",
  "model": {
    "line": "Mostly. The file came at six twice this week and I stayed late with it — could we agree it lands by three?",
    "why": "A fact, a consequence, and one small answerable ask. Nothing in it is a claim about them, so there is nothing to defend against."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Ask for one specific change" },
    { "kind": "forbids_any", "requirement": "Behaviour, not character",
      "words": ["disorganised", "lazy", "careless", "unreliable", "always", "never", "you people", "typical", "sloppy", "chaotic"] },
    { "kind": "min_words", "requirement": "Say what it cost, not just what happened", "n": 14 },
    { "kind": "max_words", "requirement": "Boring and short", "n": 40 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('raising-a-problem', 2, 'scene', $j${}$j$::jsonb);

select pg_temp.set_mode('raising-a-problem', 3, 'choice', $j${
  "beats": [
    {
      "situation": "Your one-to-one. You raised the handover with Sam three weeks ago and it is back to six o'clock.",
      "prompt": "How do you open?",
      "options": [
        { "text": "I need to talk to you about Sam.", "correct": false, "note": "A grievance. It asks your manager to take a side before they know what about, and the subject is now a person." },
        { "text": "A few of us have been struggling with the handover.", "correct": false, "note": "A coalition, and it raises the temperature by an order of magnitude. Speak for yourself and it stays solvable." },
        { "text": "The handover is landing too late for me to turn round, and I have not managed to fix it with Sam directly.", "correct": true, "note": "Opens with the work, names the person second, and answers the direct-first question before it is asked." },
        { "text": "This has been going on for months now.", "correct": false, "note": "Leads with the accumulation, which invites why am I only hearing this now as the first question." }
      ]
    },
    {
      "situation": "You have described it. They are waiting.",
      "prompt": "What do you finish with?",
      "options": [
        { "text": "Anyway — I just wanted you to know.", "correct": false, "note": "No ask, so they have to invent a response, which is frequently a meeting nobody wanted." },
        { "text": "Could you set the expectation on timing? And tell me if I am reading this wrong.", "correct": true, "note": "A specific action plus a genuinely open question. Managers are far better at doing a thing than at receiving a situation." },
        { "text": "I think he does it deliberately.", "correct": false, "note": "Unprovable and unanswerable, and it moves the subject from a late file to your reading of somebody's motives." },
        { "text": "I do not know what you want me to do about it.", "correct": false, "note": "Hands them the problem and the frustration together, and neither is actionable." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('raising-a-problem', 4, 'choice', $j${
  "beats": [
    {
      "situation": "Your review. You have been keeping score for eleven months and there are about nine things.",
      "prompt": "\"Anything on your side?\"",
      "options": [
        { "text": "Go through the list — it is all true.", "correct": false, "note": "Nine at once is a case rather than nine problems. Nobody can fix nine things, so they fix none and manage you instead." },
        { "text": "Nothing, really.", "correct": false, "note": "The other failure, and it is how the list got to nine. Absorbing is a decision that gets made again every day." },
        { "text": "The three biggest ones.", "correct": false, "note": "Better and still an accumulation. Three at once invites why am I only hearing this now, which has no good answer." },
        { "text": "The one that still matters most, at normal size.", "correct": true, "note": "One thing, raised as though it happened this week, can actually be fixed. The rest either recur and get raised properly or turn out to have been a bad quarter." }
      ]
    },
    {
      "situation": "Something small and annoying happens on a Tuesday. It is genuinely not worth a conversation.",
      "prompt": "What do you do with it?",
      "options": [
        { "text": "Let it go, properly.", "correct": true, "note": "The decision has to be real. A thing you decided not to raise is not banked for later — it is spent." },
        { "text": "Make a note, in case it becomes a pattern.", "correct": false, "note": "This is precisely how a stockpile is built, and it feels like diligence every single time." },
        { "text": "Raise it anyway.", "correct": false, "note": "Not everything is worth a conversation, and raising everything is a different problem with the same ending." },
        { "text": "Mention it lightly so it is on the record.", "correct": false, "note": "A record with no ask attached is a mood, and it will be remembered as one." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('raising-a-problem', 5, 'line', $j${
  "says": "I know, I know — it was late again. I am sorry, it has been a nightmare.",
  "model": {
    "line": "We agreed three, and it has been six twice since. What would have to change for three to be achievable?",
    "why": "Names the pattern rather than the instance, which is the only thing that makes a second conversation different from a repeat. It puts the arrangement on the table instead of the file."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Ask what would have to change" },
    { "kind": "contains_any", "requirement": "Name the pattern, not the latest instance",
      "words": ["agreed", "again", "twice", "keeps", "every", "each time", "pattern", "since", "three"] },
    { "kind": "forbids_any", "requirement": "New information, not more volume",
      "words": ["unacceptable", "fed up", "had enough", "ridiculous", "seriously", "how many times", "yet again"] },
    { "kind": "max_words", "requirement": "Two sentences at most", "n": 35 }
  ]
}$j$::jsonb);
