-- Interviews, track 2: Answering with evidence.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'interview-evidence'),
  1,
  'Two sentences of scenery',
  $md$"Tell me about a time when…" is an invitation to prove something, and most people spend the invitation on set dressing.

Watch what happens to an untrained answer. Thirty seconds establishing the company, the team structure, the quarter it happened in, who reported to whom. Then the interviewer's follow-up question arrives before the good part, or the candidate notices the time and rushes the ending. The material was there. It never got out.

The scene exists only so the rest makes sense. Two sentences: what the situation was, and why it was hard. That second half is the one people skip, and it is the one that makes everything after it count — an interviewer cannot be impressed by a solution to a problem they do not know was difficult.

**The move:** two sentences of scene, one of which says why it was hard, then go straight to what you did.

The proportions to aim for, out of roughly two minutes: fifteen seconds of scene, sixty of action, fifteen of result, and the rest is breathing.

If you find yourself explaining the org chart, you have gone wrong. Nobody is being hired on the strength of their old company's reporting lines.$md$,
  $j$[
    {
      "situation": "Answering a question about handling a difficult stakeholder.",
      "line": "We were three weeks from launch and the head of sales wanted a feature that would have taken six. The hard part was that he was not wrong about needing it — he was wrong about when.",
      "why": "Two sentences, and the second one states the difficulty precisely. It also makes the stakeholder reasonable, which quietly signals that the candidate does not think of colleagues as obstacles."
    },
    {
      "situation": "A question about a project that failed.",
      "line": "We spent about five months building a self-service portal that got used by roughly nobody. What made it hard to spot was that every individual signal was fine — the usability tests went well, the pilot customers liked it. We just never asked whether anyone wanted to do the task at all.",
      "why": "Slightly longer than two sentences, and earning it: the extra clause is the diagnosis rather than the decor. Notice there is no org chart, no dates, no names."
    },
    {
      "situation": "A question about working under pressure, answered by someone in a non-office job.",
      "line": "One of our two vans went off the road on the Friday of a bank holiday weekend. Everything for the next four days was already loaded into it.",
      "why": "The stakes are instantly legible with no jargon at all. Good scene-setting is not about the industry, it is about making a stranger feel the size of the problem in one breath."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which opening does the most work in the fewest words?",
      "options": [
        {
          "text": "So this was at my previous company, a mid-sized firm, about two hundred people, and I was in the operations team which sat under the COO at the time.",
          "correct": false,
          "note": "Thirty words, none of which are the problem. Everything here is context the interviewer will never use."
        },
        {
          "text": "We had a supplier go under with no notice, in the week we were meant to be shipping our biggest order of the year.",
          "correct": true,
          "note": "Situation and difficulty in a single sentence. The listener now knows exactly how bad it is and can judge everything that follows."
        },
        {
          "text": "This is a good example actually — it was probably the hardest thing I have done, and it taught me a lot about resilience.",
          "correct": false,
          "note": "Announces that a story will be impressive instead of being impressive. The interviewer will decide whether it was hard; telling them in advance spends credibility rather than building it."
        }
      ],
      "explain": "The scene has one job: make the difficulty legible. Anything that does not do that is decoration."
    },
    {
      "prompt": "Roughly how should a two-minute behavioural answer be divided?",
      "options": [
        {
          "text": "Half scene, half action — the context is what makes the action understandable.",
          "correct": false,
          "note": "This is the default and it is the reason most answers underperform. Context is cheap to supply on demand; action is not."
        },
        {
          "text": "A short scene, the bulk on what you did, a clear ending on what changed.",
          "correct": true,
          "note": "Fifteen seconds, a minute, fifteen seconds. The interviewer is assessing your actions, so that is where the time goes."
        },
        {
          "text": "Mostly the result, since outcomes are what get people hired.",
          "correct": false,
          "note": "An outcome with no visible action behind it sounds like something that happened near you rather than something you did."
        }
      ],
      "explain": "They are scoring the verb. Budget the answer accordingly."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "short_scene", "label": "Kept the scene short", "description": "Set up the story in about two sentences rather than a paragraph." },
      { "key": "named_difficulty", "label": "Said why it was hard", "description": "Made the difficulty explicit, so the rest of the answer had something to be measured against." },
      { "key": "no_org_chart", "label": "Left out the furniture", "description": "No unnecessary structure, dates, team sizes or reporting lines." },
      { "key": "reached_the_action", "label": "Got to the action", "description": "Spent the bulk of the answer on what they personally did." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A structured behavioural interview. The interviewer has a printed list of questions and is scoring against a rubric, which is visible on the table.",
    "partner": {
      "name": "Helen Marsh",
      "role": "an interviewer running a structured competency round",
      "personality": "Procedural and pleasant. Asks the question, waits, writes. Will not help you find the answer, and will not rescue a silence.",
      "mood": "Neutral. This is her fourth interview today and she is being scrupulously fair to all of them.",
      "openness": 2
    },
    "opening_beat": "Helen reads from the sheet without looking up. \"Tell me about a time you had to deliver something with less time than the work needed.\" She then looks up and waits.",
    "success_looks_like": "The user sets the scene in about two sentences including why it was hard, then spends the answer on their own actions.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "If the scene-setting runs long, wait through it in silence and then ask 'and what did you do?' — do not signal impatience.",
      "Never say whether an answer was good. Write a note, acknowledge briefly, ask the next thing.",
      "If the user gives an answer with no visible action, ask 'what was your part in that?' once.",
      "Keep your own turns to one or two sentences."
    ]
  }$j$::jsonb,
  $md$Ask someone today to hit you with one 'tell me about a time' question, cold, with no warning about which. Answer it out loud. Log how long you spent before you said what you actually did.$md$
),
(
  (select id from public.skills where slug = 'interview-evidence'),
  2,
  'The word that makes you invisible',
  $md$"We" is the most expensive word in an interview.

It is not a lie and it is not modesty. It is how people talk about work, because work is done by teams and taking sole credit feels grubby. But the interviewer cannot hire the team. Every time an achievement is attributed to "we", it goes into a bucket the interviewer cannot use, and a candidate who says "we" throughout comes out of the room having described a good company rather than a good candidate.

The fix is not to claim more. It is to be precise about the boundary.

Say what the team did, once, in the scene: "the team was rebuilding the checkout." Then switch to "I" for everything you personally did, and stay there. "I took the payments half. I found that the retry logic was double-charging about one in four hundred. I wrote the fix and I sat with support for a week to catch the ones we had already sent out."

That is honest. Nothing has been stolen from anyone. The interviewer now has something to assess.

**The move:** the team gets one sentence in the scene; everything after it is "I".

There is a second-order version of this worth knowing. If you led the work, "I" is not enough — leadership shows up in verbs about other people. "I got the two teams to agree on one owner." "I talked the head of support out of the manual process." Those are I-sentences that are visibly about a group, and they are the strongest evidence of seniority there is.

Watch for the passive voice too, which is "we" in disguise. "The decision was taken to postpone" is a sentence with nobody in it.$md$,
  $j$[
    {
      "situation": "Describing a team achievement without disappearing into it.",
      "line": "The team took the incident rate from about nine a month to two. My part was the alerting — I rewrote the thresholds so we stopped paging for things nobody acted on, which was around two-thirds of them.",
      "why": "Credit given to the team in the first sentence, then a precise claim about a specific contribution. This is more convincing than either 'we reduced incidents' or 'I reduced incidents', because it is obviously true."
    },
    {
      "situation": "Someone who led the work, showing it without saying 'I led'.",
      "line": "I got the three team leads into a room and made them pick one definition of an active user. It took two hours and it was not a fun two hours, but every report we built afterwards agreed with every other one.",
      "why": "Never uses the word leadership and demonstrates it entirely. The verbs are about moving other people, and the cost is admitted, which makes it real."
    },
    {
      "situation": "Rescuing an answer mid-flow after noticing the drift into 'we'.",
      "line": "…and so we decided to — sorry, that is not quite right. Two of us wanted to roll back and I was one of the two. I made the case in the incident channel and it went the other way, and I think that was the wrong call.",
      "why": "Correcting yourself out loud costs nothing and buys a lot. It reads as precision rather than as fumbling, and here it produces a much more interesting answer than the tidy version would have been."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "An interviewer asks what your role was in a project you have just described using 'we' throughout. What is that question?",
      "options": [
        {
          "text": "Ordinary curiosity about the team structure.",
          "correct": false,
          "note": "It is rarely about structure. Interviewers ask this when they cannot find the candidate inside the story."
        },
        {
          "text": "A rescue attempt — they are giving you a second chance to be visible.",
          "correct": true,
          "note": "It is the most common salvage question in interviewing, and it means the first answer did not land. Take it and be specific."
        },
        {
          "text": "A trap, checking whether you will overclaim.",
          "correct": false,
          "note": "Some interviewers do probe for overclaiming, but it usually sounds different — 'who else was involved in that?' Being vague here to seem humble reads as having no part at all."
        }
      ],
      "explain": "If you are asked what your role was, the answer so far has been a story about a company. Answer it precisely, and do not go back to 'we' afterwards."
    },
    {
      "prompt": "Which sentence shows the most seniority?",
      "options": [
        {
          "text": "I was responsible for the delivery of the whole programme.",
          "correct": false,
          "note": "A title-shaped claim. It states scope without evidence, and the interviewer has no way to check it, so it lands as an assertion."
        },
        {
          "text": "We delivered it two weeks early despite losing a developer.",
          "correct": false,
          "note": "Good outcome, invisible candidate. Nothing here can be attributed to the person in the room."
        },
        {
          "text": "The decision was made to cut the reporting module and ship without it.",
          "correct": false,
          "note": "Passive voice with nobody in it. This is the most common way people hide from their own good decisions."
        },
        {
          "text": "I persuaded the sponsor to let us cut the reporting module, which is why we shipped at all.",
          "correct": true,
          "note": "An I-sentence whose verb acts on another person, with the consequence attached. Leadership is visible in what you moved, not in what you were called."
        }
      ],
      "explain": "Seniority shows up in verbs about people and in consequences you can name. Titles and passive constructions both hide it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "visible_i", "label": "Was visible in their own story", "description": "Used 'I' for their own actions rather than defaulting to 'we'." },
      { "key": "fair_credit", "label": "Gave the team its sentence", "description": "Credited the team once, in the scene, rather than either erasing them or hiding behind them." },
      { "key": "no_passive", "label": "Avoided the passive dodge", "description": "No sentences where a decision happened with nobody making it." },
      { "key": "boundary", "label": "Marked the boundary precisely", "description": "It was clear where the team's work ended and theirs began." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A second-round interview where the previous interviewer has flagged that they could not tell what the candidate actually did.",
    "partner": {
      "name": "Tom Bridger",
      "role": "an engineering manager who probes for specifics",
      "personality": "Genial and relentless. Every time an answer is collective, he asks a narrowing question. Not aggressive about it — he just keeps going until he finds the person.",
      "mood": "Positive. He wants this to work out and needs something concrete to argue with in the debrief.",
      "openness": 4
    },
    "opening_beat": "\"So the thing I want to get at today is what you specifically bring. Pick any piece of work you are proud of, and walk me through it.\"",
    "success_looks_like": "The user credits the team once and then talks in first person about their own decisions and actions, including at least one verb that acts on other people.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Every time the user says 'we' for something that sounds like an achievement, ask a narrowing question: 'who did that bit?' or 'what was yours?'",
      "Do not explain why you keep asking. Stay friendly.",
      "If the user overclaims something implausible, ask who else was involved, neutrally.",
      "Never praise or correct their phrasing."
    ]
  }$j$::jsonb,
  $md$Describe a piece of work you are proud of to someone, out loud, for two minutes. Ask them afterwards to tell you what you personally did. Log the gap between what you meant and what they heard.$md$
),
(
  (select id from public.skills where slug = 'interview-evidence'),
  3,
  'End on what changed',
  $md$An answer that stops at the action sounds like effort. An answer that ends on the change sounds like impact. The words in between can be identical.

Most people end their stories where the work ended, because that is where their memory of it ends. But the interviewer is not scoring the work. They are scoring what happened because of it, and if you do not tell them, they will assume it was fine and forget the story.

The strongest ending is a number, and the number does not have to be impressive. "It went from about a day to about ten minutes" is a good number. So is "we stopped losing roughly one order a week." Precision beats magnitude — an honest small number is more persuasive than a large vague one, because a large vague one sounds like the number a person reaches for when they have none.

If there is no honest number, end on a change of state. What was true afterwards that was not true before. "Nobody has had to do that by hand since." "The two teams still use the same definition, three years later." That last kind — the thing that outlived you — is the best ending available, because it proves the fix was real rather than heroic.

**The move:** finish on what was different afterwards, with a number if you honestly have one.

Never invent the number. Interviewers ask how it was measured surprisingly often, and there is no recovering from not knowing where your own figure came from. "I never got a clean measure of it, but…" is a completely acceptable sentence and it costs you almost nothing.$md$,
  $j$[
    {
      "situation": "Ending an answer with a modest, precise number.",
      "line": "By the end of it we were closing the month in about three days instead of nine. Not a transformation, but the finance team stopped working weekends in January, which is what they actually cared about.",
      "why": "The number is small and exact, and it is immediately translated into what it meant for a human being. Interviewers remember the weekend detail long after they have forgotten the figure."
    },
    {
      "situation": "Ending when no measurement exists.",
      "line": "I never had a clean before-and-after on it. What I can tell you is that the escalation channel used to have four or five threads a day in it and it is now quiet enough that people ask whether it is still monitored.",
      "why": "Admits the absence of data and then substitutes an observable change. This is far stronger than a manufactured percentage, and the admission itself is evidence of someone who is careful with numbers."
    },
    {
      "situation": "Ending on the thing that outlived you.",
      "line": "The template is still what they use. I left two years ago and someone sent me a screenshot of it last month with about forty rows added to it, which was oddly moving.",
      "why": "Durability is the hardest outcome to fake and the most convincing to hear. It also shows the candidate built something for other people rather than for their own performance review."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which ending is strongest?",
      "options": [
        {
          "text": "It was a huge success and the leadership team were really pleased with it.",
          "correct": false,
          "note": "Someone else's opinion, unquantified. It tells the interviewer how it was received internally, which they have no way to weigh."
        },
        {
          "text": "So that is how I approached it, and I think it went pretty well.",
          "correct": false,
          "note": "Stops at the action and then hedges. 'Pretty well' is the sound of an answer with no ending prepared."
        },
        {
          "text": "Support tickets about that screen went from around thirty a week to two or three, and stayed there.",
          "correct": true,
          "note": "Specific, modest, checkable, and 'stayed there' quietly proves it was a real fix rather than a temporary push."
        },
        {
          "text": "It improved efficiency by over two hundred per cent.",
          "correct": false,
          "note": "A large number with no unit and no baseline. Efficiency by what measure? A figure like this invites a question you probably cannot answer."
        }
      ],
      "explain": "Small and exact beats large and vague every time, and 'and it stayed that way' is worth more than the number itself."
    },
    {
      "prompt": "You genuinely do not know the numbers for your best story. What do you do?",
      "options": [
        {
          "text": "Estimate one, clearly labelled as an estimate.",
          "correct": false,
          "note": "Better than inventing, but an estimate invites 'how did you arrive at that?' and you are now defending arithmetic instead of describing your work."
        },
        {
          "text": "Pick a different story where you do have numbers.",
          "correct": false,
          "note": "Sometimes right, often a mistake — the best story is usually best for other reasons. Do not let a missing figure disqualify strong material."
        },
        {
          "text": "End on an observable change instead, and say plainly that it was never measured.",
          "correct": true,
          "note": "Honest, and it keeps the answer's shape. Naming the absence of measurement makes every number you do quote elsewhere more credible."
        }
      ],
      "explain": "The requirement is an ending, not a statistic. What was true afterwards that was not true before will do."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "had_an_ending", "label": "Ended on the change", "description": "Finished on what was different afterwards rather than on what they did." },
      { "key": "honest_numbers", "label": "Numbers were honest", "description": "Any figure quoted was specific and defensible, or its absence was stated plainly." },
      { "key": "human_translation", "label": "Said what it meant", "description": "Translated the outcome into something a person outside the work would care about." },
      { "key": "durability", "label": "Showed it lasted", "description": "Gave some sign that the change held rather than being a one-off push." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A panel-style interview where one of the two interviewers is a data-minded finance partner who asks where numbers come from.",
    "partner": {
      "name": "Sofia Lindqvist",
      "role": "a finance business partner sitting in on the hiring panel",
      "personality": "Precise and quietly amused. Asks 'how did you measure that?' whenever a figure appears, without any edge to it. Respects 'we did not measure it' enormously and never says so.",
      "mood": "Engaged. She likes candidates who are careful with numbers and is testing for exactly that.",
      "openness": 3
    },
    "opening_beat": "\"Take me through something you changed that made a measurable difference. And I will warn you now, I am going to ask how you measured it.\"",
    "success_looks_like": "The user ends on a concrete change, quotes only numbers they can stand behind, and handles the measurement question without flinching or inventing.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask 'how did you measure that?' about any figure the user quotes, exactly once per figure.",
      "If the user admits something was never measured, accept it warmly and move on without comment.",
      "If a number sounds inflated, ask what the baseline was.",
      "Do not tell the user whether their answer was strong."
    ]
  }$j$::jsonb,
  $md$Take one story you tell about your work and find its ending — the number, or the thing that was different afterwards. Tell the story to someone with that ending attached. Log whether they reacted differently to the version with an ending on it.$md$
),
(
  (select id from public.skills where slug = 'interview-evidence'),
  4,
  'Six stories cover almost everything',
  $md$There are perhaps forty behavioural questions in common use and they are asking about six things. Prepare stories, not answers.

Six pieces of work, chosen so that between them they cover: something you delivered under constraint, something you fixed that was broken, a conflict with another person, a failure, something you led or influenced without authority, and something you learned or changed your mind about.

Most good stories serve three or four of those. The conflict story is often also the influence story. The failure is usually also the learning. That is not cheating — the interviewer is asking about a facet of you, and the same piece of work can show several.

**The move:** hold six stories in your head, and pick the facet the question asked about.

The skill in the room is not recall, it is aiming. The same story about a delayed launch is a delivery story if you tell the part about re-scoping, a conflict story if you tell the part about the argument with sales, and a failure story if you tell the part where you shipped anyway and it broke. Same events, three answers, and the aiming happens in the first sentence: "The part of this that is about disagreement is…".

Two rules that keep this honest. Do not use the same story twice in one interview — it makes a career look thin even when it is not. And do not force a story onto a question it does not fit; a candidate answering the question they prepared instead of the one they were asked is the most visible failure mode there is, and interviewers score it harshly.

Keep them recent. A brilliant story from nine years ago raises the question of what you have done since.$md$,
  $j$[
    {
      "situation": "Aiming one story at a question about conflict.",
      "line": "I will use the launch delay for this, but the part that is about disagreement is what happened with our head of sales. He had promised the date to two customers before we had agreed it internally.",
      "why": "Names the story and then immediately aims it. The interviewer knows which facet is coming, so the scene-setting doubles as a promise about what the answer will actually be about."
    },
    {
      "situation": "Refusing to force a prepared story onto the wrong question.",
      "line": "Honestly, the strongest example I have of that is not from work — it is from running a five-a-side league for six years. Is that all right, or would you rather I found something from a job?",
      "why": "Asking is better than shoehorning. Interviewers almost always say yes, and the willingness to say 'my best example is elsewhere' reads as confidence rather than as a gap."
    },
    {
      "situation": "Noticing mid-interview that a story has already been used.",
      "line": "I have already used the migration, so let me take a different one — there was a smaller thing last year that is actually a better fit for this anyway.",
      "why": "Said out loud, this demonstrates range and self-awareness in nine words. Said silently, the same realisation usually produces a worse, hurried answer."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "You have prepared a strong story about influencing without authority. The question asked is about a time you failed. What is the risk?",
      "options": [
        {
          "text": "You will run out of material later in the interview.",
          "correct": false,
          "note": "A real cost, but a secondary one. Six stories are usually enough to survive some reallocation."
        },
        {
          "text": "The interviewer will notice you answered a different question, and score you on that.",
          "correct": true,
          "note": "This is the most commonly penalised behaviour in structured interviewing. A rubric has a line for 'answered the question asked', and an unrelated strong story scores zero on it."
        },
        {
          "text": "The story will be less impressive out of its intended context.",
          "correct": false,
          "note": "Possibly, but impressiveness is not the issue. The issue is that a question was asked and not answered."
        }
      ],
      "explain": "Aiming a story at a question is fine. Substituting a story for a question is not, and it is far more visible from the other side of the table than it feels from this one."
    },
    {
      "prompt": "Which set of six stories is best prepared?",
      "options": [
        {
          "text": "Six stories from the current role, all recent, all covering different competencies.",
          "correct": false,
          "note": "Recent is right and the coverage is right, but drawing everything from one job makes the rest of the CV look inert, and it constrains what you can show."
        },
        {
          "text": "Six from across the last five or six years, chosen so that between them they cover delivery, conflict, failure, influence, fixing and learning.",
          "correct": true,
          "note": "Range across time and across facet. This is the set that lets you answer almost anything without reaching."
        },
        {
          "text": "Your three best achievements, told extremely well.",
          "correct": false,
          "note": "Three runs out inside forty minutes, and 'best achievements' skews entirely towards delivery. Half of behavioural interviewing is about things that went wrong."
        },
        {
          "text": "One story per likely question, scripted in advance.",
          "correct": false,
          "note": "Scripts break the moment the question is phrased unexpectedly, which it will be. Stories are flexible; scripts are brittle."
        }
      ],
      "explain": "Prepare material, not answers. The question decides which face of the material you show."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "answered_the_question", "label": "Answered what was asked", "description": "The story served the question rather than the question serving the story." },
      { "key": "aimed_it", "label": "Aimed it explicitly", "description": "Signalled early which part of the story was relevant to this question." },
      { "key": "range", "label": "Showed range", "description": "Did not lean on one piece of work for every answer." },
      { "key": "recency", "label": "Recent enough to count", "description": "Examples were current enough to say something about who they are now." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A forty-minute competency interview covering four different areas in quick succession.",
    "partner": {
      "name": "Adaeze Nwosu",
      "role": "a senior interviewer working through a competency framework",
      "personality": "Efficient and fair. Moves briskly between areas and notices immediately when a story is being reused or bent to fit.",
      "mood": "Businesslike. Four areas to cover and forty minutes to do it in.",
      "openness": 3
    },
    "opening_beat": "\"We have four areas to get through, so I will keep us moving. First one: tell me about a time you disagreed with someone more senior than you.\"",
    "success_looks_like": "The user answers each question with a different piece of work, aims each story at the facet asked about, and does not force a prepared answer onto the wrong question.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask about four different competencies in sequence: disagreement, failure, delivering under constraint, and influencing someone you had no authority over.",
      "If the user reuses a story, say 'you have mentioned that one — is there another?' neutrally, once.",
      "If an answer does not address the competency asked about, ask the question again in different words rather than accepting it.",
      "Move on promptly after each answer. Do not evaluate."
    ]
  }$j$::jsonb,
  $md$Write down six pieces of work from the last five years, one line each. Then ask someone to pick one at random and ask you a question about it that you did not choose. Answer it out loud and log which of the six you had nothing to say about.$md$
),
(
  (select id from public.skills where slug = 'interview-evidence'),
  5,
  'When you have never done it',
  $md$Sooner or later they ask for an example of something you have not done. The instinct is to stretch something adjacent until it covers, and the stretch is always audible.

There are three honest routes out, and picking the right one is most of the skill.

**The adjacent example, labelled.** "I have not managed people directly. The closest is that I ran a team of four contractors for eight months, which had most of the same problems and none of the authority." The label is what makes this work. An adjacent example offered as if it were the real thing gets caught; the same example offered with its limits stated is often better received than a genuine one, because it demonstrates that you know the difference.

**The honest no, plus the shape of how you would approach it.** "No, I have never run a migration that size. If I were, the first thing I would want to know is whether we could do it in slices." A clean no followed by a real answer to the underlying question. What they are testing is usually the thinking, not the credential.

**The transferable, from outside work.** Volunteering, sport, a side project, family. Weaker for technical claims, often strong for questions about conflict, organisation or persuasion.

**The move:** say what you have not done, then answer the question underneath it.

What sinks candidates here is not the gap. It is the flannel — the answer that is neither yes nor no, that circles for ninety seconds hoping to be mistaken for a yes. Interviewers are extremely well calibrated to this. It reads as evasive, and it converts a small gap into a question about your honesty, which is a much larger problem.

One line worth having ready: "Not yet." It is a complete answer, it is confident, and it invites the follow-up you want.$md$,
  $j$[
    {
      "situation": "Asked about experience with a tool the candidate has never used.",
      "line": "Never used it. I have done the same job in two others, so I would expect the concepts to carry and the first fortnight to be annoying.",
      "why": "Two sentences, no defensiveness, and a realistic estimate of the ramp. 'The first fortnight will be annoying' is credible in a way that 'I pick things up quickly' is not."
    },
    {
      "situation": "Asked for an example of managing a poor performer, having never managed anyone.",
      "line": "I have not had to do that as a manager. I have had to do it as the person a project depended on — there was a contractor last year who was not delivering, and I was the one who had to raise it. What I could not do was fix it, which was frustrating in a way I suspect managing it would not be.",
      "why": "Labels the gap, offers the closest true thing, then names the difference precisely. That final observation shows they have thought about what the real job would involve rather than pretending to have done it."
    },
    {
      "situation": "Asked about a scale of work far beyond anything they have done.",
      "line": "No, the biggest I have run is about a tenth of that. The bit I would be most worried about is coordination rather than the work itself — at that size I would assume the hard part is that nobody can hold it all in their head.",
      "why": "The honest no followed by a genuinely thoughtful answer to the real question. Naming what you would be worried about is more convincing than claiming you would not be worried."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "You have never done the thing they are asking about. Which answer is most dangerous?",
      "options": [
        {
          "text": "Describing a related experience and letting them assume it counts.",
          "correct": true,
          "note": "This is the flannel. It is the most common response and the one interviewers are best at spotting, and being caught turns a gap into a doubt about your honesty."
        },
        {
          "text": "Saying no and then explaining how you would approach it.",
          "correct": false,
          "note": "Usually the strongest available answer. The question is nearly always testing thinking rather than credentials."
        },
        {
          "text": "Offering an example from outside work.",
          "correct": false,
          "note": "Sometimes weaker, sometimes the best thing in the interview. Either way it is honest, which keeps the risk small."
        },
        {
          "text": "Describing a related experience and explicitly naming what it lacks.",
          "correct": false,
          "note": "Strong. Labelling the limits of your evidence is itself evidence of judgement."
        }
      ],
      "explain": "The gap is survivable. Pretending the gap is not there is what does the damage."
    },
    {
      "prompt": "What is usually being tested by a question about something outside your experience?",
      "options": [
        {
          "text": "Whether you meet the requirement, which is why it is on the job description.",
          "correct": false,
          "note": "If it were a hard requirement you would rarely be in the room. The question is normally exploring the edges of what you can do."
        },
        {
          "text": "How you think about the problem, and whether you are straight about what you know.",
          "correct": true,
          "note": "Both at once. A clear no with good reasoning scores better than a padded yes, because it answers the question and passes the honesty check in the same breath."
        },
        {
          "text": "Whether you will admit weakness under pressure.",
          "correct": false,
          "note": "Closer, but it frames a gap in experience as a weakness. It is usually just a fact about what you have been given to do so far."
        }
      ],
      "explain": "Answer the question underneath. It is almost always about thinking, and almost never about the badge."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named_the_gap", "label": "Said what they had not done", "description": "Stated the gap plainly rather than circling it." },
      { "key": "answered_underneath", "label": "Answered the real question", "description": "Followed the no with how they would approach it, or with the closest honest evidence." },
      { "key": "labelled_adjacency", "label": "Labelled any adjacent example", "description": "Where a related experience was offered, its limits were stated rather than left to be assumed." },
      { "key": "no_flannel", "label": "No padding", "description": "Did not use length or vagueness to obscure the answer." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "An interview for a role that is a genuine step up, where at least one requirement is beyond what the candidate has done.",
    "partner": {
      "name": "Greg Mulvaney",
      "role": "a hiring manager who has interviewed a lot of people",
      "personality": "Dry and experienced. Silent when an answer starts padding, and will simply ask the same question again. Visibly relaxes when someone says a clean 'no'.",
      "mood": "Fair-minded. He is happy to hire someone who has not done it all, and unhappy to hire someone who says they have.",
      "openness": 3
    },
    "opening_beat": "\"The role runs a team of about fifteen across two sites. Talk to me about the largest thing you have been responsible for.\"",
    "success_looks_like": "The user names the gap between their experience and the role plainly, and then gives a real answer about how they would approach the difference.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask at least two questions that reach beyond the user's stated experience.",
      "If an answer pads or implies experience without claiming it, ask the question again more precisely. Do not explain why.",
      "React neutrally and warmly to an honest 'I have not done that'. Follow it with 'so how would you go about it?'",
      "Never reassure the user that a gap is fine."
    ]
  }$j$::jsonb,
  $md$Find the requirement in a real job advert that you cannot honestly claim. Say out loud to someone: what you have not done, and how you would approach it. Log whether you managed to get through it without padding.$md$
);
