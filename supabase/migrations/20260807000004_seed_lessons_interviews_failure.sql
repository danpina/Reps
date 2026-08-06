-- Interviews, track 3: Failure, weakness and gaps.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'interview-failure'),
  1,
  'Name it, cost it, change it, stop',
  $md$"Tell me about a time you failed" is not asking whether you have failed. Everyone has. It is asking whether you can look at it without either flinching or performing.

There is a shape that works, and it is four moves long.

**Name it.** One sentence, plainly, in the active voice, with you in it. "I shipped a pricing change that undercharged about six hundred customers for a month."

**Cost it.** What it actually cost — money, time, someone's trust, your own credibility. This is the move people skip, and skipping it is what makes a failure answer sound like a humblebrag. A failure with no consequence was not a failure.

**Change it.** What you did differently afterwards, specific enough to be checkable. Not "I learned to be more careful". "I now write the rollback before the release, not after."

**Stop.** The hardest one. The silence after a failure story feels enormous from the inside and normal from the outside, and the instinct to fill it is what produces the second, unnecessary confession.

**The move:** name it, say what it cost, say what changed, then stop talking.

Two failure modes to avoid. The disguised success — "I was too ambitious with the timeline" — which everyone recognises and nobody rewards. And the catastrophe, the story so bad that the interviewer starts wondering about liability. The sweet spot is a real failure with a bounded cost, told without drama.

Choose something you have genuinely finished thinking about. A failure you are still defensive about will show, and the defensiveness is what gets scored, not the failure.$md$,
  $j$[
    {
      "situation": "A four-move failure answer, told straight.",
      "line": "I signed off a supplier without checking their insurance, and when a delivery went missing we had no cover. It cost about four thousand and it cost me the buyer's trust for a good six months, which was worse. I built the checklist we still used when I left, and I have never signed anything on a handshake since.",
      "why": "All four moves in three sentences. The trust costing more than the money is the line that makes it land — it shows the candidate understands the real currency of the mistake."
    },
    {
      "situation": "Someone stopping cleanly after the fourth move.",
      "line": "…so that is the change I made. [silence]",
      "why": "The answer is finished. Most candidates keep going here and add a second example, an apology, or a philosophical observation about learning, all of which weaken what came before. Stopping is a technique."
    },
    {
      "situation": "Declining the disguised-success version.",
      "line": "I could tell you about a time I took on too much, but honestly that is not a failure, that is a boast with a limp. The real one is that I ignored two people telling me the design was wrong because I had already told the client it would work.",
      "why": "Naming the dodge and refusing it buys enormous credibility, and it makes the real answer land harder. Only do this if the real answer is genuinely ready."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which of these is not a failure answer?",
      "options": [
        {
          "text": "I care too much about getting things right, which sometimes slows me down.",
          "correct": true,
          "note": "A virtue in a costume. Every interviewer has heard it, and what gets scored is the attempt to dodge rather than the content."
        },
        {
          "text": "I underestimated a project by about six weeks and we missed a customer commitment because of it.",
          "correct": false,
          "note": "A real failure with a real consequence, stated plainly. This is the shape."
        },
        {
          "text": "I kept a member of my team on a project for three months after I knew it was the wrong fit for them.",
          "correct": false,
          "note": "Uncomfortable, honest, and about the cost to someone else. Very strong material."
        }
      ],
      "explain": "If the failure would look good on a performance review, it is not a failure and everyone in the room knows it."
    },
    {
      "prompt": "You have named the failure and what changed. The interviewer says nothing for four seconds. What now?",
      "options": [
        {
          "text": "Add a second, smaller example to show the pattern is not repeating.",
          "correct": false,
          "note": "Two failures where one was asked for. The silence was not a request for more evidence."
        },
        {
          "text": "Nothing. Wait.",
          "correct": true,
          "note": "The pause is them writing, or thinking, or checking whether you will keep talking. Every word added here is subtracted from the answer's strength."
        },
        {
          "text": "Summarise what you learned, to end on a positive note.",
          "correct": false,
          "note": "The change you named was the positive note. Restating it as a lesson turns a specific answer into a platitude."
        },
        {
          "text": "Ask whether that answered the question.",
          "correct": false,
          "note": "Invites them to say no. If it did not answer the question they will ask again, and that is their job rather than yours."
        }
      ],
      "explain": "Stopping is part of the answer. The discomfort of the silence is yours alone — from the other side of the table it is two seconds of note-taking."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "real_failure", "label": "Chose a real one", "description": "The story was an actual failure rather than a success in disguise." },
      { "key": "named_the_cost", "label": "Said what it cost", "description": "Named a genuine consequence — money, time, trust or credibility." },
      { "key": "specific_change", "label": "The change was concrete", "description": "What they do differently now was specific enough to be checked, not a general lesson." },
      { "key": "stopped", "label": "Stopped talking", "description": "Ended the answer cleanly instead of filling the silence afterwards." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A values-based interview round. The interviewer is warm, the questions are not.",
    "partner": {
      "name": "Nadia Farouk",
      "role": "an interviewer assessing self-awareness and honesty",
      "personality": "Kind, quiet, and entirely comfortable with silence. Leaves four or five seconds after every answer before responding, which is where most candidates undo themselves.",
      "mood": "Genuinely warm. She is not trying to catch anyone out and does not need to.",
      "openness": 4
    },
    "opening_beat": "\"I would like to talk about something that went badly. Not a difficult situation you handled well — something you got wrong.\"",
    "success_looks_like": "The user names a genuine failure, states its cost, says what changed, and then stops and lets the silence sit.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "After the user finishes an answer, pause visibly — reply with a short beat such as '…' or a brief note of acknowledgement before your next question.",
      "If the user offers a disguised success, ask 'and what did that cost?' without commenting on the dodge.",
      "If the user keeps talking to fill silence, do not stop them and do not encourage them.",
      "Never reassure them that the failure was not their fault."
    ]
  }$j$::jsonb,
  $md$Tell one real failure to someone today using the four moves, and stop when you reach the end. Count the silence before they speak. Log how long you managed to stay quiet.$md$
),
(
  (select id from public.skills where slug = 'interview-failure'),
  2,
  'A weakness that costs you something',
  $md$The weakness question survives, despite everyone agreeing it is a bad question, because the answers are so revealing. Not about the weakness — about whether the candidate is willing to be a real person for thirty seconds.

A usable answer needs three properties.

**It is true.** You will be asked a follow-up. Invented weaknesses have no second layer.

**It costs something visible.** "I am impatient" is a start; "I am impatient, and it means I have twice pushed a decision through before a quieter colleague had said their piece" is an answer. The cost is what proves you have looked at it.

**It is not the job.** Do not offer a weakness that is the central requirement of the role. Saying you struggle to prioritise, in an interview for a job that is entirely prioritisation, is honesty aimed at your own foot.

**The move:** name a true weakness, name what it has cost someone else, then name the specific guard you use against it.

That last part matters and it is not the same as fixing it. Most real weaknesses are not fixed, they are managed, and saying so is more credible than claiming a cure. "I have not stopped being impatient. I have started asking the quietest person in the meeting what they think, before I say what I think."

A note on the too-honest end. Interviewers have a rough threshold: a weakness that makes you harder to work with is fine, and one that makes you unsafe to employ is not. "I find it hard to ask for help" is inside the line. "I lose my temper with people" is not, no matter how well you manage it.

And keep it to one. A candidate who offers three weaknesses has stopped answering a question and started unburdening.$md$,
  $j$[
    {
      "situation": "A weakness with a stated cost and a guard.",
      "line": "I am slow to escalate. I would rather solve it myself, and twice now that has meant a problem reached my manager later than it should have — once about a fortnight later. What I do now is a standing item in my one-to-one called 'things I have not told you yet', which is a stupid name and it works.",
      "why": "True, costly, and managed rather than cured. The self-deprecating detail about the name makes it obviously real — nobody invents that."
    },
    {
      "situation": "Answering a follow-up on the weakness without unravelling.",
      "line": "The most recent time was in March. I spent three days trying to fix a data issue myself and the client found out before my director did. He was more annoyed about the order than about the issue, which was fair.",
      "why": "The follow-up is the actual test, and this answer has a date, a specific consequence and no defensiveness. Candidates with invented weaknesses cannot produce this second layer."
    },
    {
      "situation": "Declining to give a weakness that is the core of the job.",
      "line": "The one I would normally give you is that I am not naturally organised, but that is most of this role, so let me give you the one underneath it instead: I take on too much before checking what it displaces.",
      "why": "Shows judgement about relevance without appearing to dodge, and the second answer is more interesting than the first would have been. Naming the reasoning out loud is what keeps it from looking evasive."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which weakness answer is most likely to be believed?",
      "options": [
        {
          "text": "I am a perfectionist and I sometimes spend longer on things than I should.",
          "correct": false,
          "note": "The single most common answer given. It is heard as an unwillingness to engage with the question rather than as information."
        },
        {
          "text": "I would say public speaking, although I have been working on it.",
          "correct": false,
          "note": "True for many people and safe, but the cost is unstated and it is usually chosen because it is inoffensive. It rarely does harm and it never helps."
        },
        {
          "text": "I can be too direct, which some people find difficult.",
          "correct": false,
          "note": "A boast in the shape of a confession. 'Some people find it difficult' puts the cost on them rather than on you."
        },
        {
          "text": "I find delegation hard, and last year it meant a junior on my team spent six months doing work that was too easy for them.",
          "correct": true,
          "note": "Specific, dated, and the cost lands on someone else. That third property is what makes an answer sound examined rather than composed."
        }
      ],
      "explain": "The cost is the whole answer. Without it, a weakness is just a word."
    },
    {
      "prompt": "What is the safest way to handle a weakness you have genuinely improved?",
      "options": [
        {
          "text": "Say you used to have it and no longer do.",
          "correct": false,
          "note": "A cure invites disbelief, and it makes the follow-up awkward — the interviewer will ask when it last happened."
        },
        {
          "text": "Pick a different weakness that is still live, to be safe.",
          "correct": false,
          "note": "Unnecessary. An improved weakness told honestly is one of the best answers available; you do not need a fresh wound."
        },
        {
          "text": "Say what it is, and describe the guard you still use.",
          "correct": true,
          "note": "Managed beats cured for credibility. It also gives the follow-up somewhere useful to go, which keeps you in control of the answer."
        }
      ],
      "explain": "Interviewers trust management over cure, because management is what they see in real colleagues."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "true_weakness", "label": "Gave a real one", "description": "The weakness was genuine rather than a virtue in disguise." },
      { "key": "cost_to_others", "label": "Named the cost", "description": "Said what it has actually cost, ideally to someone other than themselves." },
      { "key": "guard", "label": "Described the guard", "description": "Explained how they manage it now, specifically, rather than claiming to have fixed it." },
      { "key": "survived_follow_up", "label": "Held up under a follow-up", "description": "Could give a concrete recent instance when asked." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A first-round interview that has been going well. The tone shifts slightly as this question arrives.",
    "partner": {
      "name": "Peter Lund",
      "role": "a hiring manager who always asks a follow-up",
      "personality": "Even-tempered and mildly sceptical. Whatever weakness he is given, he asks for the most recent example of it. Nothing hostile in the delivery; he just always asks.",
      "mood": "Pleasant and unhurried. He has decided to hire someone this week and is looking for a reason to say yes.",
      "openness": 3
    },
    "opening_beat": "\"Right — the boring one, but I do want a real answer. What would the people who have worked with you say you are worst at?\"",
    "success_looks_like": "The user gives a genuine weakness with a cost attached, and can produce a specific recent example when Peter asks for one.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Always ask for the most recent time the weakness showed up. Ask it plainly, once.",
      "If the answer is a disguised strength, ask what it has cost, and then ask for an example anyway.",
      "If the user offers more than one weakness, engage only with the first.",
      "Do not tell the user whether their answer was good or reassure them about the weakness."
    ]
  }$j$::jsonb,
  $md$Ask someone who has worked with you what you are worst at, and do not defend yourself while they answer. Log what they said, in their words rather than yours.$md$
),
(
  (select id from public.skills where slug = 'interview-failure'),
  3,
  'Gaps, short stays and being let go',
  $md$A gap on a CV is a fact with dates either side of it. It becomes a problem in exactly one circumstance: when the tone of the explanation says it is one.

Interviewers are not scoring the event. They are scoring three things underneath it — is the account consistent, is there bitterness, and would this happen here. Answer those and the fact itself almost never matters.

**Consistent.** The reason you give should be the same reason you gave the recruiter and the same reason on the form. Variation is what turns a question into a line of questioning.

**Unbitter.** This is the one that sinks people. A redundancy or a firing has a villain in it, and the villain is real, and naming them costs you the job. Not because interviewers side with the old employer, but because a candidate who is still angry is a candidate who will be angry about them one day.

**Unlikely to recur.** Say what was specific about the situation. Not a promise, a fact: "The office closed." "It was a nine-month contract and it ended after nine months."

**The move:** state the fact with its dates, give one unbitter sentence of reason, and move on at the same pace as the rest of the conversation.

Being let go for performance is the hardest version, and it has one honest structure: it was not working, here is my share of why, here is what I would do differently. Your share has to be real. "It was a bad fit" with no ownership in it is heard as a refusal to look.

Length is the tell. Two sentences reads as a fact. Ninety seconds reads as a wound, whatever the words are.$md$,
  $j$[
    {
      "situation": "A redundancy, explained without a villain.",
      "line": "The company lost its biggest client in the March and cut about a third of the staff, me included. It was a bad year for them and I was in a team that was tied to that account.",
      "why": "Two sentences, no blame, and it gives the structural reason so plainly that the interviewer has nowhere to dig. There is no editorial about how it was handled, which is the trap."
    },
    {
      "situation": "A nine-month role, explained without drama.",
      "line": "That one was nine months and it was a mistake. I took a job that turned out to be much narrower than the description, and rather than sit in it for two years to make the CV look tidy, I left. I asked much better questions the next time.",
      "why": "Owns the misjudgement, gives the reason, and pre-empts the real question — which is whether the candidate is a job-hopper. The last sentence answers 'would this happen here'."
    },
    {
      "situation": "Being let go for performance.",
      "line": "I was managed out, and it was fair. I was hired to do something more commercial than I had done before, and I did not get good enough at it quickly enough. What I should have done was say so at three months instead of hoping at nine.",
      "why": "The hardest possible fact, handled in three sentences with no bitterness and a real share of ownership. The last line converts it into evidence of self-knowledge, which is worth more than the incident costs."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is an interviewer mainly listening for when you explain a redundancy?",
      "options": [
        {
          "text": "Whether it was your fault.",
          "correct": false,
          "note": "Redundancy is usually structural and interviewers know it. This is rarely the concern."
        },
        {
          "text": "Whether you have been unemployed for long.",
          "correct": false,
          "note": "It is on the CV and they can see it. The duration matters far less than how you talk about it."
        },
        {
          "text": "Whether you are still angry about it.",
          "correct": true,
          "note": "Bitterness is the thing that transfers. A candidate carrying a grievance about a previous employer is heard as a future grievance about this one."
        },
        {
          "text": "Whether you will accept a lower salary because of it.",
          "correct": false,
          "note": "Some will think it. Almost none are listening for it in this answer, and assuming they are makes people defensive in a way that costs more."
        }
      ],
      "explain": "The fact is neutral. The tone is the message, and the tone is what they will still remember tomorrow."
    },
    {
      "prompt": "How long should the explanation of a two-year career gap be?",
      "options": [
        {
          "text": "Long enough to be complete — they will wonder otherwise.",
          "correct": false,
          "note": "Completeness is not the goal. A thorough explanation of a normal life event is what makes it sound like it needs explaining."
        },
        {
          "text": "As short as possible — one clause, then straight past it.",
          "correct": false,
          "note": "Too fast is its own tell. Hurrying past something reads as wanting it unexamined, which invites exactly the examination you were avoiding."
        },
        {
          "text": "About as long as any other fact in your walkthrough.",
          "correct": true,
          "note": "Two or three sentences at the same pace as everything else. Proportion is the signal, and a gap given the same weight as a job change reads as a job change."
        }
      ],
      "explain": "Match the pace of the rest of the conversation. Both dwelling and rushing say the same thing: this one is different."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "plain_fact", "label": "Stated it as a fact", "description": "Gave the dates and the reason without apology or embellishment." },
      { "key": "no_bitterness", "label": "No villain", "description": "Explained it without blaming a person, even where blame would be fair." },
      { "key": "ownership", "label": "Took a real share", "description": "Where relevant, named their own part in it without over-confessing." },
      { "key": "proportion", "label": "Kept it in proportion", "description": "Spent about as long on it as on any other part of the story." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A first interview after a period out of work. The interviewer has the CV and has noticed the dates.",
    "partner": {
      "name": "Claire Doherty",
      "role": "a hiring manager who asks the awkward question directly and then lets it go",
      "personality": "Straightforward and not unkind. Asks about the gap plainly, listens to the whole answer, and moves on without lingering — unless the answer invites lingering.",
      "mood": "Neutral and businesslike. She has no view about the gap yet.",
      "openness": 3
    },
    "opening_beat": "Claire turns the page. \"Before we go on — there is a stretch here with nothing in it. Talk me through that.\"",
    "success_looks_like": "The user states the fact and the reason in a couple of sentences, without bitterness or over-explaining, and the conversation moves on naturally.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask about the gap once, plainly, and then let it go unless the user's own answer opens a thread.",
      "If the user blames a person or a company, ask one neutral follow-up about it and note the answer without comment.",
      "If the user over-explains, wait until they finish and then change the subject entirely.",
      "Never reassure the user that the gap does not matter."
    ]
  }$j$::jsonb,
  $md$Say the hardest fact on your CV out loud, in two sentences, to someone you trust. Ask them whether you sounded annoyed. Log the answer.$md$
),
(
  (select id from public.skills where slug = 'interview-failure'),
  4,
  'Being told you were wrong',
  $md$"Tell me about a time you received difficult feedback" is a question about what happens to you when someone challenges you, and there is no way to answer it in the abstract. The story has to have a moment in it where you were wrong and somebody said so.

The three-part shape.

**What they said, in their words.** Quoting the feedback is what makes this real. "My manager told me I was the reason two people had stopped raising problems in stand-up." Paraphrasing it upwards — "I got some feedback about my communication style" — is the sound of an answer that has been sanded down.

**What you did with it first.** Including the bit where you did not like it. Nobody receives hard feedback gracefully in the first hour, and claiming to did not happen. "I thought it was unfair for about a day" is a sentence that makes the rest believable.

**What actually changed.** Behaviour, not attitude. Something an observer could have noticed.

**The move:** quote the feedback in their words, admit the first reaction, then say what an observer would have seen change.

The version of this question that catches people is when the feedback was wrong. It happens. The answer is not to pretend you accepted it — it is to show you took it seriously enough to check. "I asked two other people whether they saw the same thing. One did, one did not, and the one who did was more specific, so I went with that."

Avoid the story where the feedback was trivially easy to accept. If the feedback did not sting, it is not an answer to this question, and choosing a painless one is itself a signal.$md$,
  $j$[
    {
      "situation": "Quoting the feedback rather than summarising it.",
      "line": "She said, and I remember it exactly: 'You answer questions that were addressed to other people.' Which I did not think was true until I counted, in the next two meetings.",
      "why": "The quote is specific enough to be uncomfortable, which is what makes it credible. 'Until I counted' is the detail that shows the feedback was actually tested rather than merely absorbed."
    },
    {
      "situation": "Admitting the first reaction honestly.",
      "line": "My first reaction was that he had only seen one bad week. I sat with it over the weekend and by the Monday I had gone from that to realising it had been about four months.",
      "why": "A day of defensiveness followed by a change of mind is what actually happens to people. The candidate who claims immediate grateful acceptance is either unusual or editing."
    },
    {
      "situation": "Handling feedback that was partly wrong.",
      "line": "About half of it I thought was fair and half I did not. I took the half I agreed with and I went back to him three weeks later about the rest, with two examples. He moved a bit, I moved a bit, and the working relationship was better afterwards than before it.",
      "why": "Shows someone who neither swallows feedback whole nor rejects it, and who is willing to reopen a difficult conversation. That last part is a strong signal about how they will behave as a colleague."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which detail makes a feedback story most credible?",
      "options": [
        {
          "text": "Quoting what was actually said to you.",
          "correct": true,
          "note": "The exact words carry the sting, and the sting is what proves the story is real rather than reconstructed for the occasion."
        },
        {
          "text": "Explaining how you thanked the person for the feedback.",
          "correct": false,
          "note": "Everyone says this and it is the least informative part. Gratitude is easy to report and impossible to verify."
        },
        {
          "text": "Describing the improvement in your next performance review.",
          "correct": false,
          "note": "Useful as an ending, but it is the outcome rather than the evidence. The interviewer is listening for what happened inside you."
        },
        {
          "text": "Saying you have always valued honest feedback.",
          "correct": false,
          "note": "A claim about yourself in a question that asked for evidence. It usually precedes a story with nothing difficult in it."
        }
      ],
      "explain": "Quote it. The specificity of the words is what separates a real story from a polished one."
    },
    {
      "prompt": "The hardest feedback you ever received was, on reflection, mostly unfair. Should you use it?",
      "options": [
        {
          "text": "No — an answer where you disagreed reads as defensive.",
          "correct": false,
          "note": "Only if you tell it defensively. Disagreement handled well is more interesting than agreement, because it shows judgement as well as openness."
        },
        {
          "text": "Yes, if you can show you checked it before deciding it was unfair.",
          "correct": true,
          "note": "The checking is the whole answer. Seeking a second opinion, counting, asking for examples — that is what an interviewer wants to know you do."
        },
        {
          "text": "Yes, and lead with why it was unfair so the context is clear.",
          "correct": false,
          "note": "Leading with the defence puts the interviewer in the position of judging the old dispute. The order matters: what was said, what you did, what you concluded."
        }
      ],
      "explain": "The question is about your process, not about who was right. A story where you tested the feedback answers it better than one where you simply accepted it."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "quoted_it", "label": "Quoted the feedback", "description": "Gave the words that were actually used rather than a sanded-down summary." },
      { "key": "honest_reaction", "label": "Admitted the first reaction", "description": "Did not claim to have accepted hard feedback instantly and gracefully." },
      { "key": "observable_change", "label": "Named a visible change", "description": "Described something an observer could have noticed, not a change of attitude." },
      { "key": "chose_something_real", "label": "Chose something that stung", "description": "The feedback was genuinely difficult rather than comfortable to report." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A round focused on how the candidate works with other people. Two interviewers, one asking, one taking notes.",
    "partner": {
      "name": "Owen Ferris",
      "role": "a peer interviewer assessing collaboration",
      "personality": "Direct and curious. Asks for the exact words whenever a candidate paraphrases. Interested in what happened in the first twenty-four hours, and says so.",
      "mood": "Engaged. He has had two vague answers to this question already today.",
      "openness": 3
    },
    "opening_beat": "\"Tell me about the hardest piece of feedback you have been given. And I mean hardest, not most useful.\"",
    "success_looks_like": "The user tells a story with real sting in it, quotes the feedback, admits their first reaction honestly, and names a change an observer would have seen.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "If the user paraphrases the feedback, ask what was actually said, word for word.",
      "Ask what their first reaction was, if they have not volunteered it.",
      "If the story has no sting in it, ask for a different one, once, without explaining why.",
      "Do not praise honesty or reassure the user at any point."
    ]
  }$j$::jsonb,
  $md$Ask a colleague or friend for one piece of feedback they have never given you, and say nothing for ten seconds after they answer. Log what they said and what your first reaction was.$md$
),
(
  (select id from public.skills where slug = 'interview-failure'),
  5,
  'What you would do differently',
  $md$This question sounds like a softer version of the failure question. It is not — it is the seniority test hiding in the friendliest possible wording.

The reason is that there are two levels of answer, and the difference between them is exactly the difference between doing a job and being trusted to run one.

**First-order:** what you would have done differently in the task. "I would have tested it on more devices." True, fine, forgettable. It says you can spot a mistake after it has been pointed out.

**Second-order:** what you would have done differently about the conditions that produced the mistake. "I would not have agreed to a date before we had seen the data. The testing gap was a symptom — the actual error was accepting a deadline in a meeting where I was the only one who knew it was tight."

The second answer is not cleverer, it is further back. It looks at the process, the decision, the moment of agreement, rather than at the execution.

**The move:** answer about the conditions that made the mistake likely, not about the mistake.

Two things that strengthen it further. Naming the cost of the alternative — the second-order fix usually has one, and admitting it ("we would have shipped three weeks later, and I think that was the right trade") shows you are weighing rather than wishing. And saying what you have actually done since, because a reflection with no consequence is an opinion.

The failure mode here is the answer that would do everything differently. A candidate who rewrites the whole project sounds like someone with no judgement about which decision mattered. Pick one.$md$,
  $j$[
    {
      "situation": "Moving from a first-order to a second-order answer.",
      "line": "The easy answer is that I would have run a pilot. The truer one is that I would not have let the deadline be set in a meeting I was not in. The pilot was obvious afterwards; the reason we did not have time for one was decided six weeks earlier.",
      "why": "Names the shallow answer, then goes past it. The final sentence is the point of the whole technique — the visible mistake was downstream of the real one."
    },
    {
      "situation": "Admitting the cost of the better decision.",
      "line": "It would have meant telling the client we were four weeks out rather than two, which would have been a genuinely bad conversation and might have cost us the extension. I still think it was the right call and I did not have the nerve for it at the time.",
      "why": "Weighs the alternative honestly instead of presenting it as free, and admits a failure of nerve rather than a failure of knowledge. Interviewers find that distinction very persuasive."
    },
    {
      "situation": "Picking exactly one thing.",
      "line": "There are about six things I would change and five of them do not matter. The one that does is that I should have asked who the decision-maker was in the first week. Everything else followed from spending two months persuading the wrong person.",
      "why": "Discrimination between what mattered and what did not is the actual signal being tested. A candidate who lists all six sounds like someone who cannot tell them apart."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which answer shows the most seniority?",
      "options": [
        {
          "text": "I would have communicated more clearly with the stakeholders throughout.",
          "correct": false,
          "note": "Vague and universal — it could be said about any project ever run. It contains no evidence of having examined this one."
        },
        {
          "text": "I would have written the tests first, which would have caught it.",
          "correct": false,
          "note": "First-order and true. It shows you know what went wrong at the level of the task, which is the minimum."
        },
        {
          "text": "I would have pushed back on taking the work at all with the staffing we had, and I would have had that argument in week one rather than week six.",
          "correct": true,
          "note": "Goes back to the decision that made the failure likely, and names when it should have happened. That is judgement rather than hindsight."
        }
      ],
      "explain": "The question is a test of how far back you can see. Execution-level answers are correct and cheap; the decision-level answer is what gets remembered."
    },
    {
      "prompt": "What makes a reflection answer sound hollow?",
      "options": [
        {
          "text": "Naming too many things you would change.",
          "correct": false,
          "note": "It does weaken the answer, but it reads as poor prioritisation rather than as hollowness."
        },
        {
          "text": "Admitting you have not had a chance to apply the lesson yet.",
          "correct": false,
          "note": "Honest, and fine. Not every lesson gets a second outing, and pretending otherwise is worse."
        },
        {
          "text": "Choosing an old project.",
          "correct": false,
          "note": "Older material is weaker generally, but a well-examined old project beats a shallow recent one."
        },
        {
          "text": "Describing the better path as though it had no cost.",
          "correct": true,
          "note": "Every real alternative costs something. A frictionless counterfactual is the sound of someone who has not actually thought it through, only regretted it."
        }
      ],
      "explain": "If the alternative was obviously better and free, the only question left is why you did not do it. Name the cost, and the reflection becomes a judgement."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "second_order", "label": "Went back to the decision", "description": "Answered about the conditions that made the mistake likely, not just the mistake." },
      { "key": "one_thing", "label": "Picked one", "description": "Chose the change that mattered instead of listing everything." },
      { "key": "named_the_cost", "label": "Costed the alternative", "description": "Acknowledged what the better path would itself have cost." },
      { "key": "applied_since", "label": "Said what has changed since", "description": "Connected the reflection to something they have actually done differently." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A final-round conversation with someone senior, twenty minutes in, after the candidate has described a project in detail.",
    "partner": {
      "name": "Miriam Balint",
      "role": "a director assessing judgement rather than skill",
      "personality": "Quiet, unhurried, and interested in decisions rather than tasks. When given an execution-level answer she asks 'and why was that possible?' — repeatedly, gently, until the conversation reaches a decision.",
      "mood": "Calm and attentive. She has all the time in the world for this one.",
      "openness": 4
    },
    "opening_beat": "\"Thank you, that is a good description of what happened. Now — with everything you know now, what would you do differently?\"",
    "success_looks_like": "The user goes past the first-order fix to the decision or condition underneath it, picks one thing, and acknowledges what that alternative would have cost.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "When given an execution-level answer, ask why that was possible, or what allowed it to happen. Repeat up to twice.",
      "If the user lists several changes, ask which one mattered most and wait.",
      "If the user describes a costless alternative, ask what it would have cost.",
      "Never tell the user they are close, and never summarise their answer back to them approvingly."
    ]
  }$j$::jsonb,
  $md$Take a project that did not go well and tell someone the second-order version: not what you would have done differently in the work, but which earlier decision made the problem likely. Log whether you could get to it without being asked twice.$md$
);
