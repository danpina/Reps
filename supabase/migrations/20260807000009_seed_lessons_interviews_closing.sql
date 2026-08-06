-- Interviews, track 8: Closing and following up.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'interview-closing'),
  1,
  'Say that you want it',
  $md$Interviewers are not mind readers, and enthusiasm is not the same as intent. A candidate can be warm, engaged and interesting for fifty minutes and still leave the room without anyone knowing whether they would take the job.

Say it. Out loud, as a sentence, near the end.

"I should say plainly — I want this job."

That is it. It is not a technique, it is a piece of information, and it is startling how few people supply it. Interviewers debrief afterwards and one of the first things said in that room is some version of "were they into it?" A candidate about whom nobody can answer that is a candidate who is easy to leave behind in favour of someone who was obviously keen.

**The move:** state, in one plain sentence, that you want the job.

Three things make it land.

**Plainness.** Not "I would be excited by the opportunity", which is a construction people use when they are being polite. Short declarative sentences read as true.

**A reason attached.** "I want this job, and the reason is the thing you said about the reporting mess — that is exactly the work I like." The reason is what stops it sounding like something you say at the end of every interview.

**Timing.** Near the end, after you have heard enough to mean it. Said in the first ten minutes it is a pitch; said at the end it is a conclusion.

The fear is that declaring interest weakens your position on money later. It does not. Salary is decided by the band and by whether they want you, and being obviously willing makes them want you more, not less. Playing hard to get in a hiring process mostly results in not getting.

If you do not want the job, do not say it. Say something true instead, or say nothing.$md$,
  $j$[
    {
      "situation": "The plain statement with a reason.",
      "line": "Before we finish, I want to say plainly that I want this job. The reason is the thing you described about the two teams disagreeing — that is the work I am best at and I have not had it for two years.",
      "why": "Declarative, specific, and the reason makes it unrepeatable elsewhere. This is the sentence that gets quoted in the debrief."
    },
    {
      "situation": "Saying it when the interview has been difficult.",
      "line": "I think I answered your second question badly, and I have been thinking about it ever since. I still want the job — more than when I came in, actually, because that question told me what the standard is here.",
      "why": "Turns a wobble into a demonstration of self-awareness and appetite at once. Interviewers forgive weak answers far more readily than they forgive indifference."
    },
    {
      "situation": "Declining to say it, honestly, when it is not true.",
      "line": "I want to think about it properly rather than say something enthusiastic in the room. What I can tell you is that the team problem you described is genuinely interesting to me.",
      "why": "Honest without being cold, and it keeps the door open. A false declaration of interest is worse than none, because you will have to withdraw it later and be remembered for that."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does saying you want the job matter?",
      "options": [
        {
          "text": "Because enthusiasm is a scored competency in most frameworks.",
          "correct": false,
          "note": "It rarely is, formally. The effect happens in the debrief conversation rather than on the scoresheet."
        },
        {
          "text": "Because the debrief always includes some version of 'were they keen?', and somebody has to be able to answer it.",
          "correct": true,
          "note": "Two candidates close together get separated by exactly that question, and only one of them supplied an answer."
        },
        {
          "text": "Because it makes you memorable.",
          "correct": false,
          "note": "Mildly true and not the mechanism. Plenty of memorable candidates are rejected."
        },
        {
          "text": "Because it obliges them to give you feedback if they say no.",
          "correct": false,
          "note": "It obliges nobody to anything. This is a claim about how your interest is recorded, not a lever."
        }
      ],
      "explain": "It is information they need and rarely receive. Supplying it is close to free."
    },
    {
      "prompt": "Does declaring you want the job weaken your salary position?",
      "options": [
        {
          "text": "Yes — it signals you will accept anything.",
          "correct": false,
          "note": "The common fear. Wanting a job and having a number are unrelated, and the second is what you say when the number comes up."
        },
        {
          "text": "Yes, slightly, so it is better said after the offer.",
          "correct": false,
          "note": "After the offer it is too late to influence whether there is one, which is the decision it actually affects."
        },
        {
          "text": "No — pay is set by the band and by how much they want you, and visible willingness increases the second.",
          "correct": true,
          "note": "Reluctance rarely raises an offer and frequently prevents one. The negotiation happens later and on different terms."
        }
      ],
      "explain": "Playing hard to get in hiring mostly results in not getting. Say it, and negotiate when there is something to negotiate."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_it", "label": "Said it plainly", "description": "Stated in one clear sentence that they wanted the job." },
      { "key": "gave_a_reason", "label": "Attached a reason", "description": "Gave a specific reason so the statement could not have been said anywhere else." },
      { "key": "timing", "label": "Timed it well", "description": "Said it near the end, after hearing enough to mean it." },
      { "key": "truthfulness", "label": "Meant it", "description": "Declared interest only where it was genuine." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The final two minutes of a strong interview. The interviewer is closing her notebook.",
    "partner": {
      "name": "Grace Sutherland",
      "role": "a hiring manager wrapping up a good conversation",
      "personality": "Warm and efficient. Closes interviews briskly and does not fish for enthusiasm. Notices and remembers when a candidate states their interest directly.",
      "mood": "Positive. She has enjoyed this and has another meeting in four minutes.",
      "openness": 4
    },
    "opening_beat": "\"That is everything from my side, and I think we are about out of time. Thanks for coming in — you will hear from us by the end of next week.\"",
    "success_looks_like": "The user states plainly that they want the job, with a specific reason, before the conversation closes.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Move to close the interview promptly. Do not invite a final statement.",
      "If the user states their interest, respond warmly and briefly, and note the reason they gave.",
      "If the user does not, close the interview politely and end the scene.",
      "Never prompt them to say how they feel about the role."
    ]
  }$j$::jsonb,
  $md$Tell someone plainly today that you want something — a job, a project, an invitation — in one short sentence with a reason attached. Log how it felt to say it without hedging.$md$
),
(
  (select id from public.skills where slug = 'interview-closing'),
  2,
  'Ask what would stop them',
  $md$There is one question that can change the outcome of an interview after it is over, and almost nobody asks it.

"Is there anything about my background that gives you pause?"

Here is why it matters. The moment you leave, a conversation happens in which someone raises a doubt about you — too junior, no experience of that sector, a gap on the CV, an answer that was thin. You are not in that room. Nobody argues the other side. The doubt goes unanswered, and unanswered doubts decide close calls.

Asking this question is the only chance you get to answer an objection before it is discussed without you.

**The move:** ask what would give them pause, then answer it briefly and without defending.

It is uncomfortable to ask, and the discomfort is the price. Three things make it work.

**Ask it as a genuine question.** Curious, not anxious. "Is there anything you are unsure about that I could address?"

**Then be quiet.** The answer often takes a few seconds to arrive, because you have asked for candour and most interviewers have to decide how honest to be.

**Answer briefly.** One or two sentences. A long rebuttal turns a small doubt into a big subject, and the interviewer will remember the length rather than the content.

If the answer is "no, nothing", you have lost nothing and gained a small demonstration of confidence. If the answer is real, you have just been handed the single most useful piece of information in the entire process — and even if you cannot fix it, you know what to put in the follow-up note.

Do not do this in a first screening call with a recruiter who cannot answer it. Save it for the person who will be in the debrief.$md$,
  $j$[
    {
      "situation": "Asking the question cleanly.",
      "line": "One last thing, and please be honest — is there anything about my background that gives you pause?",
      "why": "'Please be honest' gives explicit permission, which is what most interviewers need in order to say the real thing. Then stop talking and let the pause do its work."
    },
    {
      "situation": "Answering a real objection briefly.",
      "line": "Interviewer: \"You have not worked in a regulated environment.\" — \"That is fair, I have not. The closest is that everything I shipped for two years went through a legal review that could veto it, so I am used to building with someone else's rules in the room. But no, not regulated.\"",
      "why": "Two sentences. Offers the nearest true evidence, then concedes the point rather than arguing it. Conceding is what stops a small doubt becoming a discussion."
    },
    {
      "situation": "Using the answer in the follow-up note.",
      "line": "You mentioned you had not seen me work at that scale. I have attached a two-page write-up of the migration I described — it is the closest thing I have, and it will tell you more than I could in the room.",
      "why": "The question's second payoff. Even an objection you cannot answer live can be answered in writing that night, and a note aimed at a stated doubt is far more useful than a thank-you."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does asking about hesitations change outcomes?",
      "options": [
        {
          "text": "Because it demonstrates confidence.",
          "correct": false,
          "note": "It does, and that is a small side benefit. The mechanism is about information, not impression."
        },
        {
          "text": "Because it forces the interviewer to commit to a view.",
          "correct": false,
          "note": "It does not, and pressing them to commit would be a bad idea. You are asking for a doubt, not a verdict."
        },
        {
          "text": "Because the debrief happens without you, and this is the only chance to answer an objection before it is discussed.",
          "correct": true,
          "note": "Unanswered doubts decide close calls, and there is nobody in that room to argue your side."
        }
      ],
      "explain": "You are not present when the decision is made. This question is the nearest thing to being there."
    },
    {
      "prompt": "They name a real gap. How long should your answer be?",
      "options": [
        {
          "text": "One or two sentences, ending with a concession if the point is fair.",
          "correct": true,
          "note": "Short answers keep a small doubt small. Conceding what is true is what makes the rest of the answer credible."
        },
        {
          "text": "Long enough to fully address it — this is your one chance.",
          "correct": false,
          "note": "Length converts a passing hesitation into the main thing they remember about the interview."
        },
        {
          "text": "Do not answer at all — thank them and address it in the follow-up note.",
          "correct": false,
          "note": "The note is a good second move, and saying nothing in the room reads as having no answer."
        },
        {
          "text": "Ask what would resolve it, so you can answer the right thing.",
          "correct": false,
          "note": "Occasionally useful, usually it stalls. They have told you the doubt; answer it rather than negotiating its terms."
        }
      ],
      "explain": "Brief, honest, and conceding what is true. The goal is to shrink the doubt, not to win an argument."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked_it", "label": "Asked the question", "description": "Invited them to name a hesitation, plainly." },
      { "key": "held_the_pause", "label": "Waited for the answer", "description": "Left the silence long enough for a candid response to arrive." },
      { "key": "brief_answer", "label": "Answered briefly", "description": "One or two sentences, without a long defence." },
      { "key": "conceded", "label": "Conceded what was fair", "description": "Acknowledged the true part of the objection rather than arguing all of it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The final minutes of a second-round interview with the person who will make the decision.",
    "partner": {
      "name": "Hugh Trevelyan",
      "role": "the decision-maker for the role",
      "personality": "Candid when invited, reserved otherwise. If asked directly about hesitations he will name a real one, after a pause, and will watch closely how it is handled.",
      "mood": "Undecided. This is genuinely a close call for him.",
      "openness": 3
    },
    "opening_beat": "\"I think that covers everything I wanted to ask. Anything else from you before we wrap up?\"",
    "success_looks_like": "The user asks what gives him pause, waits through the pause, and answers the objection in a couple of sentences without arguing it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "If asked about hesitations, pause first — write the hesitation into the reply — then name one real, specific concern based on what the user has said.",
      "If the user answers at length or argues, respond neutrally and do not concede the point.",
      "If the user concedes what is fair and offers brief evidence, acknowledge it and move on warmly.",
      "Never tell the user whether their answer helped."
    ]
  }$j$::jsonb,
  $md$Ask someone whose opinion matters what would give them pause about you — for a role, a project, a responsibility. Say nothing for five seconds after asking. Log what they said.$md$
),
(
  (select id from public.skills where slug = 'interview-closing'),
  3,
  'A note that adds something',
  $md$The thank-you note is nearly universal advice and nearly universally wasted, because almost every one of them says the same thing: thank you for your time, I enjoyed our conversation, I remain very interested.

That note is fine. It is also identical to the one from every other candidate, which means it carries no information and changes nothing.

A note that works does one job: it adds something that was not in the room.

**A better version of an answer you fumbled.** "You asked how I would approach the reporting problem and I gave you a vague answer. Having thought about it on the train, the first thing I would actually do is…" Two sentences. This is the strongest kind, because it demonstrates that you keep thinking about problems after you leave.

**Something useful about the thing they described.** A link, a tool, a name of someone who solved it elsewhere. It costs you ten minutes and it makes you the candidate who was already helping.

**An answer to the objection they named.** If you asked what gave them pause and they told you, this is where you address it properly.

**The move:** send one short note that adds something the interview did not contain.

Rules of length and timing. Short — under a hundred and fifty words. Same day or the next morning, not four days later. To the person you spoke to, and to the recruiter separately if there was one.

And once. A second unprompted note undoes the first entirely: the first says you are thoughtful, and the second says you are anxious. If you have not heard by the date they gave you, that is a different thing, and it is the subject of the next lesson.$md$,
  $j$[
    {
      "situation": "Repairing a fumbled answer.",
      "line": "Thanks for this morning. You asked how I would sequence the migration and I gave you a woolly answer — I have been thinking about it since. I would do the read path first, because it is reversible, and that also gives you a month of real traffic before anything is at stake. Happy to talk it through if it is useful.",
      "why": "Under seventy words, adds a real answer, and demonstrates that the problem stayed with them. Fumbled answers are opportunities that most candidates leave on the table."
    },
    {
      "situation": "Adding something useful with no self-interest attached.",
      "line": "One thing from our conversation — you mentioned the support ticket problem. This write-up is the best thing I have read on it, and the section on triage tiers is what changed how I thought about it. No need to reply.",
      "why": "'No need to reply' removes any sense of obligation, which makes it a gift rather than a prompt. The candidate is now the person who sent something useful."
    },
    {
      "situation": "Answering a stated objection in writing.",
      "line": "You said you were unsure about my experience at that scale, which is fair. For context: the platform I described was around four hundred thousand daily users at peak, which I did not say clearly in the room. It is smaller than yours, and it is not nothing.",
      "why": "Directly addresses the doubt raised, adds a fact the interview missed, and concedes the remaining gap. The last four words do more good than any amount of insistence."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which follow-up note is worth sending?",
      "options": [
        {
          "text": "A warm thank-you reiterating your interest in the role.",
          "correct": false,
          "note": "Harmless, universal, and it changes nothing. Every candidate sends this one."
        },
        {
          "text": "A short note with a better answer to a question you fumbled.",
          "correct": true,
          "note": "Adds something the interview did not contain, and shows you carried the problem out of the building with you."
        },
        {
          "text": "A detailed summary of why you are a strong fit for the role.",
          "correct": false,
          "note": "That was the interview. Restating your case in writing reads as not trusting them to have understood it."
        },
        {
          "text": "A note to everyone you met, each personalised.",
          "correct": false,
          "note": "Effortful and easily overdone. On a panel day, the decision-maker and the recruiter are enough."
        }
      ],
      "explain": "One note, adding one thing that was not in the room. Everything else is decoration."
    },
    {
      "prompt": "How many unprompted follow-ups should you send?",
      "options": [
        {
          "text": "Two — one immediately, one a few days later to stay visible.",
          "correct": false,
          "note": "The second one undoes the first. Thoughtful becomes anxious with a single extra message."
        },
        {
          "text": "One, unless their stated timeline has passed.",
          "correct": true,
          "note": "A note adds something; a chase is a different act with a different trigger, and the trigger is a date they gave you."
        },
        {
          "text": "As many as it takes to get a response.",
          "correct": false,
          "note": "Persistence in sales is not persistence in hiring. Here it reads as poor judgement about other people's attention."
        }
      ],
      "explain": "Once. After that you are waiting, and waiting well is its own skill."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "added_something", "label": "Added something new", "description": "Contained something the interview did not — a better answer, a useful link, a missing fact." },
      { "key": "short", "label": "Kept it short", "description": "Well under two hundred words." },
      { "key": "prompt", "label": "Sent it promptly", "description": "Same day or the following morning." },
      { "key": "once", "label": "Sent one", "description": "Did not follow up the follow-up." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The evening after an interview. The candidate is talking through what to send with a friend who hires people for a living.",
    "partner": {
      "name": "Tasha Benning",
      "role": "a friend who runs a hiring team and has strong views",
      "personality": "Blunt and generous. Will say plainly that a draft is the same as everyone else's, and will ask what the interview left unfinished until something usable appears.",
      "mood": "Happy to help, mildly impatient with generic drafts.",
      "openness": 5
    },
    "opening_beat": "\"So what are you going to send them? And do not read me the one that starts 'thank you for your time'.\"",
    "success_looks_like": "The user arrives at a short note that adds something concrete — a repaired answer, a useful link, or a fact the interview missed.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "If the draft is generic, say so plainly and ask what was left unfinished in the interview.",
      "Ask what question they answered worst, and push them to write a better answer to it.",
      "Object if the note is longer than about a hundred and fifty words.",
      "You are a friend, not a coach: react and argue, do not give structured advice."
    ]
  }$j$::jsonb,
  $md$Send one short message today that adds something to a conversation you have already had — a better answer, a link, a fact you left out. Log whether they replied.$md$
),
(
  (select id from public.skills where slug = 'interview-closing'),
  4,
  'Chasing without nagging',
  $md$Waiting is the part of a process you control least and behave worst in. Almost every candidate error here comes from filling a silence that means nothing.

Hiring is slow for reasons that have nothing to do with you. Someone is on holiday. The panel cannot get a slot. There is another candidate at a different stage and they want to see both before deciding. A budget approval has stalled two levels up. None of that is a signal, and reading it as one produces the message you should not send.

Two rules make this simple.

**Get a date before you leave.** "When would you expect to be in touch?" Ask it in every interview. It converts an open-ended wait into a deadline, and a deadline gives you permission to chase without inventing a reason.

**Chase after the date, not before.** One message, short, warm, no reproach: "You mentioned you would know by the end of last week — no rush at all, just wanted to check where things stand." Then wait the same interval again before a second, and after that stop.

**The move:** ask when they expect to decide, then chase once, after that date has passed.

Chase through the recruiter if there is one. It is their job, they do not mind, and it saves the hiring manager an interaction that costs you a small amount of goodwill.

The tone that works is unbothered. Not casual — unbothered. You have other things going on and this is a reasonable enquiry rather than a plea. If you are struggling to write it that way, the fix is usually to make it shorter; anxiety lives in the second and third sentences.

And keep interviewing elsewhere while you wait. It is practical advice and it is also the fastest route to the tone described above.$md$,
  $j$[
    {
      "situation": "Asking for the date before leaving.",
      "line": "When would you expect to be back in touch? Only so I know whether to sit tight or chase you.",
      "why": "The second sentence makes it easy to answer honestly, and it announces that you will follow up, which makes the follow-up expected rather than pushy."
    },
    {
      "situation": "The chase, after the date has passed.",
      "line": "Hi — you mentioned Friday for a decision, so I thought I would check in. No rush, and I am still keen. Happy to wait if things have moved.",
      "why": "Under thirty words, references their own timeline rather than your impatience, and 'happy to wait' removes any pressure. There is no reproach anywhere in it."
    },
    {
      "situation": "Withdrawing gracefully when another offer forces it.",
      "line": "I have accepted something else, so I should take myself out of your process. Thank you for the time, and genuinely — the conversation with your team was the most interesting one I had.",
      "why": "Prompt, warm, and it frees them to move on. Candidates who go quiet after accepting elsewhere are remembered badly, which is a bad trade for the two minutes it saves."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "You were told you would hear back on Wednesday. It is now Friday. What should you do?",
      "options": [
        {
          "text": "Wait another week — chasing looks desperate.",
          "correct": false,
          "note": "A date has passed. Following up on a commitment they made is not desperation, it is normal professional behaviour."
        },
        {
          "text": "Send a short, unbothered message referencing their timeline.",
          "correct": true,
          "note": "Their date, not your anxiety, is the reason for the message. That framing is what makes it land as reasonable."
        },
        {
          "text": "Message the hiring manager directly to show initiative.",
          "correct": false,
          "note": "If there is a recruiter, go through them. Routing around the process to display keenness reads as not respecting it."
        },
        {
          "text": "Assume it is a no and move on.",
          "correct": false,
          "note": "Delay is almost never a signal. Processes slip constantly for reasons that have nothing to do with any candidate."
        }
      ],
      "explain": "Their stated date is the permission slip. Before it, you are waiting; after it, you are following up."
    },
    {
      "prompt": "What most reliably makes a chasing message read as anxious?",
      "options": [
        {
          "text": "Sending it in the evening.",
          "correct": false,
          "note": "Nobody notices, and plenty of professional messages are sent at odd hours."
        },
        {
          "text": "Mentioning that you are still interested.",
          "correct": false,
          "note": "Perfectly fine in one clause. It becomes a problem only when it is the whole message."
        },
        {
          "text": "Length — the second and third sentences of explanation.",
          "correct": true,
          "note": "Anxiety lives in elaboration. A two-line message reads as unbothered; the same message with reasons attached reads as needing something."
        }
      ],
      "explain": "If the tone feels wrong, cut it in half. It is almost always length rather than content."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "got_a_date", "label": "Asked for a date", "description": "Established when they expected to be in touch before leaving." },
      { "key": "timing", "label": "Chased after the date", "description": "Waited until their own timeline had passed." },
      { "key": "tone", "label": "Unbothered in tone", "description": "Short, warm, and free of reproach or over-explanation." },
      { "key": "right_channel", "label": "Used the right channel", "description": "Went through the recruiter where there was one." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Ten days after a final-round interview. The candidate was told they would hear within a week. They are calling the recruiter.",
    "partner": {
      "name": "Danny Oyelowo",
      "role": "the recruiter who has been managing the process",
      "personality": "Apologetic and honest. The delay is genuine and mundane — the decision-maker has been away. Responds well to a light touch and badly to pressure.",
      "mood": "Slightly embarrassed about the silence.",
      "openness": 4
    },
    "opening_beat": "\"Oh — hi. I have been meaning to call you actually, and then I did not. What can I do for you?\"",
    "success_looks_like": "The user chases briefly and warmly, references the timeline rather than their own anxiety, and does not press for a verdict Danny cannot give.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Explain the delay honestly and mundanely if asked. There is no hidden meaning in it.",
      "If the user pushes for a verdict or implies impatience, become more formal and less forthcoming.",
      "If the user is light about it, volunteer something useful about where the process actually stands.",
      "Never comment on how they are handling the wait."
    ]
  }$j$::jsonb,
  $md$Follow up on something you are waiting for — a message, a decision, a reply — in two sentences, without reproach or explanation. Log how short you managed to make it.$md$
),
(
  (select id from public.skills where slug = 'interview-closing'),
  5,
  'Taking a no well',
  $md$A rejection is the end of one process and the start of a much longer relationship that most candidates burn down in a single reply.

Hiring managers move companies. Recruiters remember two kinds of candidate: the ones who were rude when rejected, and the ones who were not. Second-choice candidates get called back with surprising frequency, when the first choice declines or leaves inside a year. None of that is a reason to be gracious — being gracious is its own reward — but it is a reason not to treat a no as the end of anything.

One reply, three sentences.

**Thank them properly.** Briefly and without sarcasm, which is harder than it sounds on the day.

**Ask for one specific thing.** Not "any feedback would be appreciated", which is easy to ignore. "Was there a particular gap that decided it?" is answerable in one line, so it often gets answered.

**Leave the door open, plainly.** "If something similar comes up, I would be glad to hear from you."

**The move:** thank them, ask one specific question, and say you would come back.

On the feedback itself: take it, do not argue with it, and understand that a lot of it will be soft or partly untrue. Companies are cautious about rejection reasons for legal and human reasons alike. If you get one useful sentence out of three attempts, that is a good rate. Ask, thank, and move.

And give yourself the day. The reply does not have to be sent in the first hour, and the version written in the first hour is rarely the one you want on record. Write it, leave it, send it in the morning.

If you got to the final stage and lost, ask what the successful candidate had that you did not. It is a harder question to ask and it produces the most useful answer available.$md$,
  $j$[
    {
      "situation": "The three-sentence reply.",
      "line": "Thanks for letting me know, and for being quick about it. Was there a particular gap that decided it? Either way, if something similar comes up I would be glad to hear from you.",
      "why": "Under forty words, one answerable question, and an explicit open door. Thanking them for being quick is a small specific touch that costs nothing and is remembered."
    },
    {
      "situation": "Asking the harder question after a final round.",
      "line": "Could I ask what the person you appointed had that I did not? I am asking because I would like to fix it, not because I am arguing with the decision.",
      "why": "The second sentence is what makes it answerable — it removes the fear of a dispute, which is the main reason companies give soft feedback. This produces the most useful answers there are."
    },
    {
      "situation": "Receiving soft feedback without pushing.",
      "line": "\"It was very close and the other candidate had more direct sector experience.\" — \"That is useful, thank you. Good luck with the hire.\"",
      "why": "The feedback is partly a formula and it is what is on offer. Accepting it cleanly, without probing for the real reason, is what keeps the relationship worth having."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which request is most likely to get you real feedback?",
      "options": [
        {
          "text": "Any feedback you can share would be much appreciated.",
          "correct": false,
          "note": "Open, effortful to answer, and easy to leave in the inbox. Most of these go unanswered."
        },
        {
          "text": "Could you tell me why I was not successful?",
          "correct": false,
          "note": "Direct, and it invites a formal answer because it sounds like it might be the start of a dispute."
        },
        {
          "text": "Was there a particular gap that decided it?",
          "correct": true,
          "note": "Answerable in one line, narrow enough not to feel risky, and specific enough to be useful when it comes back."
        },
        {
          "text": "What would make me a stronger candidate next time?",
          "correct": false,
          "note": "Good in a conversation, vaguer in an email. It tends to produce generic development advice rather than the actual reason."
        }
      ],
      "explain": "Make it cheap to answer. A question that takes one line to reply to gets a reply."
    },
    {
      "prompt": "Why wait a day before replying to a rejection?",
      "options": [
        {
          "text": "It signals you are not too invested.",
          "correct": false,
          "note": "Nobody reads timing that way, and playing it cool after a no achieves nothing."
        },
        {
          "text": "Because the version written in the first hour is rarely the one you want on record.",
          "correct": true,
          "note": "Whatever you send exists permanently in a thread that a future colleague may read. The morning version is almost always better."
        },
        {
          "text": "Because a same-day reply looks automated.",
          "correct": false,
          "note": "A prompt, warm reply is fine. The risk is in what the first hour does to the wording, not in the speed."
        }
      ],
      "explain": "Write it now, send it tomorrow. The delay costs nothing and edits out everything you would regret."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "gracious", "label": "Replied graciously", "description": "Thanked them without sarcasm or reproach." },
      { "key": "specific_question", "label": "Asked one specific question", "description": "Made the feedback request narrow and cheap to answer." },
      { "key": "door_open", "label": "Left the door open", "description": "Said plainly they would welcome being contacted again." },
      { "key": "accepted_it", "label": "Took the answer", "description": "Did not argue with the feedback given, however soft it was." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A call from the recruiter with a rejection after a final-round interview the candidate thought had gone well.",
    "partner": {
      "name": "Priti Shah",
      "role": "the recruiter delivering the decision",
      "personality": "Kind and slightly guarded. Gives a formulaic reason first. If asked a narrow, non-confrontational question she will give one genuinely useful sentence.",
      "mood": "Uncomfortable. She liked this candidate and argued for them.",
      "openness": 3
    },
    "opening_beat": "\"I am sorry, it is not the news I wanted to give you. They have decided to go with another candidate — it was very close, and the feedback was positive overall.\"",
    "success_looks_like": "The user thanks her, asks one narrow question that gets a real answer, accepts it without arguing, and leaves the door open.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Give the formulaic reason first: it was close, the other candidate had more direct experience.",
      "If asked a narrow, non-confrontational question, give one genuinely specific and useful answer.",
      "If the user argues with the decision or presses hard, retreat into policy language and give nothing further.",
      "Never reassure the user about how they handled the call."
    ]
  }$j$::jsonb,
  $md$Ask for feedback on something you did not get — a job, a pitch, an invitation — with one narrow question rather than an open request. Log whether the narrow version got an answer.$md$
);
