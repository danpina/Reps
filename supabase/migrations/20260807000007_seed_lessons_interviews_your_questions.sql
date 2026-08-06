-- Interviews, track 6: The questions you ask.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'interview-your-questions'),
  1,
  'Ask what only they can answer',
  $md$"Any questions for us?" is the only part of the hour where you choose the subject, and most candidates hand it straight back.

The test for a question worth asking is a single line: could this person answer it, and could the website not.

That rules out most of what gets asked. Culture — the website says collaborative. Growth plans — the press release said what the press release says. Training budget — a policy, and asking about it in a first interview signals you are thinking about leaving before you have arrived.

It rules in anything that requires this person's own experience. What they find hard. What they were wrong about. What changed after the last reorganisation. What the person before you did well.

**The move:** ask something this specific person knows and no document contains.

There is a second, quieter function to this. The questions you ask are the last thing said in the room, and they are read as evidence of what you pay attention to. A candidate who asks about the on-call rota, how decisions get unstuck, and what happened to the previous postholder has demonstrated three things about how they think about work — without making a single claim about themselves.

Prepare five and expect to use three. Two will get answered during the interview, and saying so is good — "I had one about how the roadmap gets set, but you covered it" shows you were listening and had prepared, in nine words.

One thing to avoid: the question designed to display your knowledge. Everyone can hear it, it is not a question, and the interviewer has to sit through it politely.$md$,
  $j$[
    {
      "situation": "A question only this person can answer.",
      "line": "What is the thing this team keeps having to redo?",
      "why": "No document contains the answer, everyone who works there knows it, and the response is almost always genuinely informative. It also signals that you think about systems rather than tasks."
    },
    {
      "situation": "Retiring a prepared question that got answered.",
      "line": "I had one about how priorities get set between the two teams, but you answered that when you talked about the Thursday session. So instead — what has changed here in the last year that you would not want to go back to?",
      "why": "Shows preparation and listening at once, then spends the slot on something better. Retiring a question out loud is far stronger than asking it anyway."
    },
    {
      "situation": "Refusing the knowledge-display question.",
      "line": "I was going to ask something clever about your architecture and honestly I would just be showing off. The real question is: what do you wish someone had told you before you joined?",
      "why": "Naming the temptation and declining it is disarming, and the replacement question is one people answer honestly. It also reframes the conversation as two colleagues talking."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which question is worth one of your three slots?",
      "options": [
        {
          "text": "What is the culture like here?",
          "correct": false,
          "note": "The answer is a word — collaborative, fast-paced, supportive — and it carries no information. It is the most-asked and least-useful question in interviewing."
        },
        {
          "text": "What does success look like in this role after six months?",
          "correct": false,
          "note": "Reasonable and common. It gets a real answer, though usually a rehearsed one, and it does not require this person specifically."
        },
        {
          "text": "What is the last thing this team got badly wrong, and what happened afterwards?",
          "correct": true,
          "note": "Only an insider can answer it, the answer is always revealing, and how they handle the question tells you as much as the content does."
        },
        {
          "text": "What are the opportunities for progression?",
          "correct": false,
          "note": "A policy question that reads as being about your next job rather than this one. Fine at offer stage, weak in an interview."
        }
      ],
      "explain": "Could they answer it, and could the website not. Two conditions, and most questions fail the second."
    },
    {
      "prompt": "Two of your three prepared questions were answered during the interview. What now?",
      "options": [
        {
          "text": "Say so, and ask the remaining one plus something that came up during the conversation.",
          "correct": true,
          "note": "Retiring them out loud proves both preparation and attention, and a question drawn from the conversation is nearly always better than a prepared one."
        },
        {
          "text": "Ask them anyway — it shows you prepared.",
          "correct": false,
          "note": "It shows you prepared and were not listening, which is a worse combination than not preparing."
        },
        {
          "text": "Say you have no questions, since they covered everything.",
          "correct": false,
          "note": "Having nothing to ask is read as indifference, however thorough they were. There is always something only they know."
        }
      ],
      "explain": "Prepare five, use three, and let the conversation replace the ones it answered."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "insider_only", "label": "Only they could answer it", "description": "Asked something no document or website would contain." },
      { "key": "not_a_display", "label": "A question, not a display", "description": "Did not use the slot to demonstrate knowledge." },
      { "key": "listened", "label": "Drew on the conversation", "description": "At least one question came from something said during the interview." },
      { "key": "prepared_enough", "label": "Had more than one", "description": "Did not run out, and did not ask a question that had already been answered." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The last ten minutes of a first-round interview. The interviewer has just checked the time and turned the conversation over.",
    "partner": {
      "name": "Steph Aldridge",
      "role": "a team lead who answers questions honestly, including the awkward ones",
      "personality": "Candid. Gives real answers to real questions, and gives visibly rehearsed answers to generic ones, without ever pointing out the difference.",
      "mood": "Relaxed. The formal part is over and she has ten minutes.",
      "openness": 4
    },
    "opening_beat": "\"That is everything from me, and we have got about ten minutes. What have you got for me?\"",
    "success_looks_like": "The user asks questions that require Steph's own experience, and follows up on at least one answer rather than moving straight to the next question.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer generic questions with the polished, uninformative version — a single positive word and a stock example.",
      "Answer specific insider questions honestly and at length, including things that are not flattering to the company.",
      "Never point out which kind of question you have just been asked.",
      "If the user says they have no more questions, close the interview politely and promptly."
    ]
  }$j$::jsonb,
  $md$Ask one person about their job today using a question no website could answer — what keeps getting redone, what they wish they had been told. Log what you learned that you could not have looked up.$md$
),
(
  (select id from public.skills where slug = 'interview-your-questions'),
  2,
  'Make them picture you in the seat',
  $md$There is a class of question that does something beyond gathering information: it puts you in the job in the interviewer's mind, for the length of the answer.

They are questions asked in the present tense, about the work, as though the decision had already been made.

"What would you want the person in this seat to have fixed by Christmas?"
"If I started on Monday, what is the first thing that would land on me?"
"Who would I be arguing with most in the first month?"

The interviewer has to imagine you there in order to answer. That imagining is worth more than anything you said about yourself in the previous forty minutes, because it is theirs rather than yours — people believe the pictures they construct.

**The move:** ask about the work in the present tense, as though you already had the job.

Two calibrations.

**Do not overdo it.** One or two of these. A candidate who asks five presumptuous questions is a candidate who has decided the outcome, and interviewers notice.

**Keep them answerable.** "What would my first ninety days look like" is often too vague to produce a real answer — most managers have not thought about it in that form. "What is the first thing that would land on me" is concrete and gets a specific answer.

The best version of this question type asks about difficulty rather than opportunity. "What is the part of this job that people underestimate?" invites honesty, gets an answer worth having, and quietly tells them you are the sort of person who asks what is hard before asking what is nice.

If the answer sounds alarming, that is information you were going to receive on day thirty anyway, at a much higher price.$md$,
  $j$[
    {
      "situation": "Present tense, concrete, answerable.",
      "line": "If I started in three weeks, what is the first thing that would land on my desk?",
      "why": "Forces a specific answer and forces the interviewer to picture the desk with you at it. Much better than 'what would my first ninety days look like', which most managers answer vaguely because they have not thought about it in those terms."
    },
    {
      "situation": "Asking about difficulty rather than opportunity.",
      "line": "What is the part of this job that people underestimate before they take it?",
      "why": "Gets honesty, because it gives permission for it. Candidates who ask what is hard are read as realistic, and the answer is usually the single most useful thing you learn all day."
    },
    {
      "situation": "Asking who the friction is with.",
      "line": "Who would I end up disagreeing with most in the first few months? Not in a bad way — I just want to know where the seams are.",
      "why": "Maps the political landscape in one question, and the clarification stops it sounding like a hunt for conflict. The answer tells you where the real work is."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does asking in the present tense work?",
      "options": [
        {
          "text": "It shows confidence, which is attractive in a candidate.",
          "correct": false,
          "note": "The confidence is a side effect. Presumption on its own is not persuasive and can easily go the other way."
        },
        {
          "text": "It forces the interviewer to imagine you doing the job in order to answer.",
          "correct": true,
          "note": "And people trust pictures they construct themselves far more than claims they were handed."
        },
        {
          "text": "It gets more detailed answers than hypothetical phrasing.",
          "correct": false,
          "note": "Often true and secondary. The detail helps you; the imagining helps your candidacy."
        },
        {
          "text": "It signals that you have other offers.",
          "correct": false,
          "note": "It signals nothing of the sort, and a question designed to imply leverage you may not have is a bad trade."
        }
      ],
      "explain": "You are borrowing their imagination for thirty seconds. That is the mechanism, and it is why one or two of these are worth more than five good questions about policy."
    },
    {
      "prompt": "Which is the strongest version of this question type?",
      "options": [
        {
          "text": "What would my first ninety days look like?",
          "correct": false,
          "note": "Common enough to be rehearsed, and vague enough that many managers answer it with a plan they invented on the spot."
        },
        {
          "text": "What does the ideal candidate for this role look like?",
          "correct": false,
          "note": "Invites a description you cannot match and puts you in the position of being compared to an invented person."
        },
        {
          "text": "What is the part of this job that people underestimate?",
          "correct": true,
          "note": "Concrete, invites honesty, and asking about difficulty rather than reward marks you out. The answer is often worth the whole interview."
        }
      ],
      "explain": "Concrete beats broad, and asking what is hard beats asking what is good."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "present_tense", "label": "Asked in the present tense", "description": "Framed at least one question as though already in the role." },
      { "key": "concrete", "label": "Answerable and specific", "description": "Questions produced real answers rather than improvised generalities." },
      { "key": "asked_about_hard", "label": "Asked what is difficult", "description": "Enquired about the hard parts, not only the opportunities." },
      { "key": "calibration", "label": "Did not overdo it", "description": "One or two presumptive questions, not a whole set." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The question slot in a second-round interview with the person who would be your manager.",
    "partner": {
      "name": "Callum Reid",
      "role": "the hiring manager for the role",
      "personality": "Thoughtful and honest, sometimes more honest than is strictly wise. Answers concrete questions with real detail and vague ones with pleasant generalities.",
      "mood": "Engaged and a little tired. This is his fourth interview this week for the same role.",
      "openness": 4
    },
    "opening_beat": "\"We have got a bit of time left. I would rather use it on your questions than on more of mine — what do you want to know?\"",
    "success_looks_like": "The user asks at least one present-tense question about the actual work and at least one about what is difficult, and follows up on the answers.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer concrete, present-tense questions with genuine specifics, including something mildly unflattering about the team.",
      "Answer vague or generic questions with pleasant, uninformative generalities.",
      "If asked about difficulty, be honest — name a real problem the team has.",
      "Do not evaluate the questions or tell the user they asked a good one."
    ]
  }$j$::jsonb,
  $md$Ask someone about their own job in the present tense — what would land on my desk, what do people underestimate. Log the answer, and log whether the conversation changed shape.$md$
),
(
  (select id from public.skills where slug = 'interview-your-questions'),
  3,
  'Ask about the person, once',
  $md$Interviews are asymmetric by design, and for fifty minutes the interviewer is a function rather than a person. One question that treats them as a person is worth more than three about the role.

"What made you stay?"

That is the whole technique. Variations: what made you join, what nearly made you leave, what you would tell a friend applying. All of them do the same thing — they ask for an opinion rather than information, and opinions are the only thing anyone actually enjoys being asked for.

Two effects follow, and both matter.

**The register changes.** They stop reporting and start talking. Almost everyone gives a more honest answer to this than to anything else in the hour, and you learn more about the place from thirty seconds of it than from the entire careers site.

**They enjoy the interview.** That sounds soft and it is not. Interviewers write notes shortly afterwards, and the notes are written by a person with a feeling about how the conversation went. Being the candidate a tired interviewer enjoyed talking to is a real advantage, and it is available to anyone.

**The move:** ask one question that asks for their opinion rather than for information.

Two rules keep it honest. Once, not twice — a second personal question starts to feel like a technique, which it is, and the whole value is that it did not feel like one. And listen to the answer properly, including the pause before it; the hesitation before someone says why they stayed is frequently more informative than the sentence that follows.

If the answer is thin or evasive, that is data. Someone who cannot say why they have stayed four years has told you something worth knowing.$md$,
  $j$[
    {
      "situation": "The core question, asked plainly.",
      "line": "You have been here five years, which is a long time in this industry. What made you stay?",
      "why": "Notices something specific about them, then asks for an opinion. The observation is what makes it land — it is clearly about this person rather than a question from a list."
    },
    {
      "situation": "A version for someone who has just joined.",
      "line": "You joined six months ago — what has surprised you most since you got here?",
      "why": "New joiners are the most useful people to ask, because they can still see the place from outside. The answers are usually specific and rarely rehearsed."
    },
    {
      "situation": "Listening to a hesitation.",
      "line": "Interviewer: \"…that is a good question, actually. I suppose — the people, mostly. And it took a while.\" — \"What made it take a while?\"",
      "why": "The pause and the qualifier were the real answer. Following the hesitation rather than the sentence is where the useful conversation starts, and it shows you were listening properly."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is 'what made you stay?' effective?",
      "options": [
        {
          "text": "It flatters the interviewer.",
          "correct": false,
          "note": "It is not flattery, and if it lands as flattery it has been asked badly. Flattery is the failure mode of this question."
        },
        {
          "text": "It asks for an opinion rather than information, which changes the register.",
          "correct": true,
          "note": "People switch out of report mode and into talking. The answers are more honest and both parties enjoy the exchange more."
        },
        {
          "text": "It reveals whether the company has retention problems.",
          "correct": false,
          "note": "A useful side effect. The primary effect is on the conversation you are having right now."
        }
      ],
      "explain": "Opinions are the only thing people are pleased to be asked for. Everything else is a request for labour."
    },
    {
      "prompt": "The interviewer gives a thin, evasive answer to why they have stayed. What have you learned?",
      "options": [
        {
          "text": "Nothing — some people are simply private about work.",
          "correct": false,
          "note": "Possible, and it is still information. A private answer to a friendly question is worth noting even if it is innocent."
        },
        {
          "text": "That they were caught off guard, which says nothing about the company.",
          "correct": false,
          "note": "Being caught off guard is exactly what makes the answer informative. The unprepared version is the honest one."
        },
        {
          "text": "Something worth weighing when you decide whether to accept.",
          "correct": true,
          "note": "Someone who cannot say why they have stayed four years has told you something. It is not decisive, and it belongs in the picture."
        },
        {
          "text": "That you should ask the same question of someone else.",
          "correct": false,
          "note": "Reasonable next step, and it does not change the fact that you already have an answer from this one."
        }
      ],
      "explain": "This question gathers information in both directions. Interviews are also where you decide about them."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked_for_opinion", "label": "Asked for an opinion", "description": "Asked something personal about their experience rather than about the role." },
      { "key": "specific_observation", "label": "Anchored it in something specific", "description": "Noticed something about this person before asking." },
      { "key": "listened_to_the_pause", "label": "Followed the hesitation", "description": "Picked up on what was awkward or qualified in the answer rather than only the words." },
      { "key": "once", "label": "Asked it once", "description": "Did not turn a genuine question into a repeated technique." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The end of a long interview day. This is the fourth conversation, and both people are slightly worn out.",
    "partner": {
      "name": "Marianne Fisk",
      "role": "a senior team member who has been at the company seven years",
      "personality": "Professional and a little guarded until asked something personal, at which point she becomes markedly more open and tells you things the other three interviewers did not.",
      "mood": "Tired and going through the motions until something interests her.",
      "openness": 3
    },
    "opening_beat": "\"Right. I think that is my lot. Anything you want to ask me before we finish?\"",
    "success_looks_like": "The user asks one question about Marianne's own experience, listens to the hesitation in the answer, and follows it rather than moving to the next question.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer role questions briefly and a little flatly.",
      "If asked something personal about your own experience, pause first — write the hesitation into the reply — then answer honestly and at more length.",
      "If the user follows up on the hesitation, open up further and share something genuinely candid.",
      "Never tell the user that they asked a good question."
    ]
  }$j$::jsonb,
  $md$Ask someone today why they have stayed in their job, and then say nothing for five seconds after they finish. Log what came out in the pause.$md$
),
(
  (select id from public.skills where slug = 'interview-your-questions'),
  4,
  'The question that finds the problem',
  $md$Every open role exists because something is not working. Someone left, something grew, something broke, or something was promised that nobody can currently deliver. The job you are interviewing for is a response to a problem, and nobody will tell you what it is unless you ask.

There is a family of questions that get at it.

"What made this role necessary?"
"What was the previous person best at, and what did they find hardest?"
"If nobody is hired for this, what does not happen?"
"How long has the role been open?"

That last one is the cheapest and most revealing. Two weeks means growth. Seven months means either the bar is high or something in the description is wrong, and the answer to which will tell you a great deal about what you would be walking into.

**The move:** ask what problem this role exists to solve, and listen for what they leave out.

Two payoffs. The obvious one is that you learn what you are being hired to fix, which lets you aim the rest of your answers at it — and if the answer comes early enough, you can reframe your best story around it.

The subtler one is that asking this question is itself a signal. Candidates who want to know what is broken are read as people who fix things. Candidates who ask only about the good parts are read as people who want a nice job.

Ask it neutrally. There is a version of this that sounds like an audit, and it puts the interviewer on the defensive. The tone you want is genuinely curious, and the phrasing that carries it best is usually the shortest: "what made the role necessary?"

Then listen for the pause. This is a question people answer carefully, and the care is the information.$md$,
  $j$[
    {
      "situation": "Asking neutrally and early.",
      "line": "Can I ask what made this role necessary? I always find that tells me more than the description does.",
      "why": "The second sentence disarms it — it explains the motive so the question cannot be heard as an audit. Asked early, the answer can be used for the rest of the interview."
    },
    {
      "situation": "Asking about the predecessor without asking why they left.",
      "line": "What was the person before me best at? And what did they find hardest?",
      "why": "Gets at the shape of the job without the awkwardness of asking why someone left. The second half is the useful half, and pairing it with the first makes it easy to answer."
    },
    {
      "situation": "Using the answer immediately.",
      "line": "That is useful — because the thing you have just described is almost exactly the situation I walked into in 2022, and the part that mattered was not the process, it was getting the two managers to agree who owned it.",
      "why": "Turns their answer into a bridge to your best material. This is the highest-value thing that can happen in the question slot, and it only becomes possible if you asked early enough."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does 'the role has been open for seven months' most likely tell you?",
      "options": [
        {
          "text": "The company is not serious about filling it.",
          "correct": false,
          "note": "Occasionally true and rarely the main story. Roles stay open for reasons that are usually more specific than indifference."
        },
        {
          "text": "Either the bar is unusually high or something in the description does not match reality.",
          "correct": true,
          "note": "Both are worth knowing, and both are askable follow-ups. This single fact reframes everything else you have been told."
        },
        {
          "text": "You have leverage in the negotiation.",
          "correct": false,
          "note": "Sometimes, and treating it as leverage rather than as information is how candidates misread a hiring process."
        },
        {
          "text": "The pay is below market.",
          "correct": false,
          "note": "One possible cause among several. Assuming it narrows what you learn from the follow-up."
        }
      ],
      "explain": "How long a role has been open is the cheapest question in the interview and one of the most informative."
    },
    {
      "prompt": "Why does asking what is broken help your candidacy, not just your information?",
      "options": [
        {
          "text": "It shows you are not naive about work.",
          "correct": false,
          "note": "Partly, and 'not naive' is a low bar. The effect is more specific than that."
        },
        {
          "text": "It flatters the interviewer's honesty.",
          "correct": false,
          "note": "It does invite honesty, and flattery is not the mechanism. Asked as flattery it stops working."
        },
        {
          "text": "People who ask what is broken are read as people who fix things.",
          "correct": true,
          "note": "The question is heard as a statement about how you approach work, which is why it lands as evidence rather than as curiosity."
        }
      ],
      "explain": "What you choose to ask about is read as what you pay attention to. Ask about the hard part."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked_the_problem", "label": "Asked what the role is for", "description": "Found out what problem the vacancy exists to solve." },
      { "key": "neutral_tone", "label": "Asked it neutrally", "description": "Curious rather than auditing, so the interviewer answered rather than defended." },
      { "key": "listened_for_omission", "label": "Noticed what was left out", "description": "Paid attention to the care and hesitation in the answer, not only its content." },
      { "key": "used_it", "label": "Used the answer", "description": "Connected what they learned to their own relevant experience." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A second interview where the candidate has a slot to ask questions in the middle rather than at the end.",
    "partner": {
      "name": "Derek Ashworth",
      "role": "a department manager who is honest if asked directly and evasive if asked vaguely",
      "personality": "Careful. Answers precisely what he is asked. If a question is neutral and direct he tells the truth, including that the role has been open a long time and why.",
      "mood": "Measured. He has been burned by a bad hire recently and is being careful in both directions.",
      "openness": 3
    },
    "opening_beat": "\"Before I go into the rest of my questions — is there anything you want to ask at this point? Some people prefer to front-load it.\"",
    "success_looks_like": "The user asks what problem the role exists to solve, gets a real answer, and connects it to their own experience later in the conversation.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "If asked directly and neutrally why the role exists, answer honestly — the previous postholder left, and there is an unresolved disagreement between two teams underneath it.",
      "If the question sounds like an audit, become brief and slightly defensive.",
      "Pause before answering anything about the previous postholder.",
      "Never tell the user how their question landed."
    ]
  }$j$::jsonb,
  $md$Ask someone who has hired recently what problem the role existed to solve. Log how different their answer was from what the job advert said.$md$
),
(
  (select id from public.skills where slug = 'interview-your-questions'),
  5,
  'Different rooms, different questions',
  $md$Asking the same three questions of everyone you meet in a process wastes most of them, and in a panel day it is noticed — people compare notes, and "he asked all of us the same thing" is a real note.

Match the question to what the person can actually tell you.

**The recruiter** knows the process, the competing candidates, the timeline, and what the manager says when the door is closed. Ask about the process and the manager. Do not ask them about the work.

**The hiring manager** knows the job, the problem, the team's weaknesses and what they need from this hire. Ask about the work, the difficulty, the first ninety days.

**The peer** knows what it is actually like — the meetings, the frustration, whether the tools are any good, whether people stay late. Ask what a bad week looks like. This is the most honest room you will be in and most candidates waste it on questions about strategy.

**The skip-level or executive** knows where the whole thing is going and what would make it fail. Ask about direction, about what would have to be true in two years, about the constraint they worry about.

**The move:** ask each person about the part of the job only they can see.

Two practicalities. Keep one question in reserve for the very end of the last conversation, because processes overrun and the question slot is what gets cut. And write down the answers between conversations — you will be told contradictory things, and the contradictions are the most valuable data in the whole day. A team that disagrees about what the role is for is telling you something no answer could.

If you are running short of questions by the fourth interview, ask the same question about a different thing: what is the hardest part of *your* week, rather than the hardest part of the role.$md$,
  $j$[
    {
      "situation": "Asking a peer the question you would not ask a manager.",
      "line": "What does a bad week look like here? Not a disaster — just an ordinary bad one.",
      "why": "Peers answer this honestly and managers rarely can. The 'not a disaster' clause is what makes it answerable, because it asks about the ordinary rather than the exceptional."
    },
    {
      "situation": "Asking an executive about direction rather than detail.",
      "line": "What would have to be true in two years for you to say this team worked?",
      "why": "Pitched at the altitude the person actually operates at. Asking a director about the tooling wastes the one conversation where you could learn where the whole thing is going."
    },
    {
      "situation": "Noticing a contradiction across the day.",
      "line": "Your colleague described the main challenge as speed, and you have described it as quality. Is that a live tension, or am I reading too much into it?",
      "why": "The most valuable question available on a panel day, and it can only be asked because notes were taken. It is not a trap; asked in this tone, it usually produces the most candid answer of the day."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "You get twenty minutes with a peer who would sit next to you. What is the best use of it?",
      "options": [
        {
          "text": "Ask about the company strategy, to show you think broadly.",
          "correct": false,
          "note": "They probably know less about it than the last three people you met, and you have wasted the only honest room in the building."
        },
        {
          "text": "Ask what an ordinary bad week looks like.",
          "correct": true,
          "note": "Peers answer this truthfully and nobody else can. It is the most useful twenty minutes of the day if you spend it here."
        },
        {
          "text": "Ask about progression and how promotions work.",
          "correct": false,
          "note": "You will get one person's anecdote, and you have spent the honest room on a policy question."
        },
        {
          "text": "Ask what they think the manager is looking for.",
          "correct": false,
          "note": "Tempting and mostly speculation. The recruiter knows this properly; the peer is guessing."
        }
      ],
      "explain": "Each room can tell you one thing better than any other room. Spend it on that."
    },
    {
      "prompt": "Two interviewers describe the role's main challenge differently. What should you do?",
      "options": [
        {
          "text": "Assume the more senior one is right.",
          "correct": false,
          "note": "Seniority does not settle it, and it discards the most interesting fact you have learned all day."
        },
        {
          "text": "Say nothing — pointing it out would seem confrontational.",
          "correct": false,
          "note": "It depends entirely on tone. Asked curiously it is one of the strongest questions available, and staying silent leaves you without an answer you need."
        },
        {
          "text": "Ask about it, curiously, and treat the answer as important information about the job.",
          "correct": true,
          "note": "A team that disagrees about what a role is for is describing your first six months. You want to know that before you accept, not after."
        }
      ],
      "explain": "Contradictions across a panel day are the most valuable thing you learn, and they only exist if you were taking notes."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "matched_the_room", "label": "Matched the question to the person", "description": "Asked each interviewer about what only they could see." },
      { "key": "no_repeats", "label": "Did not repeat", "description": "Avoided asking several people the same question." },
      { "key": "noticed_contradictions", "label": "Noticed the disagreements", "description": "Picked up on differences between what different people said." },
      { "key": "held_one_back", "label": "Kept something in reserve", "description": "Had a question left for the end, when the schedule had eaten the earlier slots." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The last conversation of a four-interview panel day. The candidate has already spoken to a recruiter, a manager and a peer, and heard slightly different accounts of the role.",
    "partner": {
      "name": "Yusuf Demir",
      "role": "a director, the final conversation of the day",
      "personality": "Strategic and direct. Uninterested in detail questions, and visibly more engaged by questions about direction, risk and what would make the team fail.",
      "mood": "Curious but time-pressured. Fifteen minutes, and he will use all of them if the questions are good.",
      "openness": 3
    },
    "opening_beat": "\"You have met most of the team today, so you probably know more about the job than I do. Fifteen minutes — what do you want to ask me?\"",
    "success_looks_like": "The user asks questions pitched at direction and risk rather than detail, and raises the contradiction between what different interviewers said.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer strategic questions with real substance and detail questions with a brief redirect to someone else.",
      "If the user raises a contradiction between interviewers, engage with it honestly and explain the tension.",
      "Mention the time remaining once.",
      "Never comment on the quality of the questions."
    ]
  }$j$::jsonb,
  $md$Ask two different people the same question about their shared workplace and write down both answers. Log where the two accounts disagreed.$md$
);
