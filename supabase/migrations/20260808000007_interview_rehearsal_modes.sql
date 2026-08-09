-- Rehearsal modes for all forty Interviews lessons.
--
-- The track was written before modes existed, so every lesson in it would have
-- opened a fourteen-turn chat window — which is the wrong container for almost
-- all of them. An interview is not a conversation you steer. It is a series of
-- questions you answer, which makes most of these lessons a drill: one answer,
-- against one question, checked against rules stated before you type.
--
-- Twenty-one line drills, eleven read-and-decide, six sequences and two open
-- scenes. Thirty-two of forty run without a model call, which matters more here
-- than it did in Small talk: somebody with an interview on Thursday wants to
-- say the same answer eleven times, and a drill that costs money on each go is
-- a drill they will use twice.
--
-- The line drills carry their own character budget. The default is a hundred
-- and sixty characters because Small talk is about saying less; "tell me about
-- yourself" is a ninety-second answer, and a box that cannot hold one cannot
-- drill it.

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id
      and s.slug = p_skill
      and l.sort_order = p_order;
$fn$;

-- ---------------------------------------------------------------------------
-- Your story
-- ---------------------------------------------------------------------------

select pg_temp.set_mode('interview-your-story', 1, 'line', $j${
  "says": "Right — so before we get into any of the detail, tell me about yourself.",
  "maxChars": 1100,
  "model": {
    "line": "I started in operations at a logistics firm, mostly because it was the first job that would have me, and I found out I was good at untangling things nobody else wanted to look at. The middle of it is five years of doing exactly that on bigger and bigger problems, the last two running a team of six and rebuilding how we handled exceptions. I have got about as far as I can there, and this role is the first one I have seen that is the same problem at ten times the size, which is why I am sitting here.",
    "why": "Three beats and nothing else: one sentence of where it started, the middle where the work is, and a landing that names the job. Under a hundred and ten words, which is about ninety seconds out loud."
  },
  "checks": [
    { "kind": "min_words", "requirement": "Long enough to be an answer rather than a shrug", "n": 60 },
    { "kind": "max_words", "requirement": "Ninety seconds — a hundred and seventy words at the outside", "n": 170 },
    { "kind": "contains_any", "requirement": "Land it on why you are in this room",
      "words": ["this role", "this job", "which is why", "that is why", "brought me", "sitting here"] }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-your-story', 2, 'line', $j${
  "says": "I do not need the whole history. What I want to know is why you are sitting here rather than somewhere else.",
  "model": {
    "line": "The thing that got me was that you rebuilt the exceptions process rather than hiring around it. That is the argument I have spent two years making and losing. I would like to work somewhere that has already had it.",
    "why": "One detail that could only be about them, what it told you, and what you want out of it. No adjectives about the company at all."
  },
  "checks": [
    { "kind": "max_sentences", "requirement": "Three sentences. This is the landing, not the story.", "n": 3 },
    { "kind": "first_person", "requirement": "Say what you want, not what is impressive" },
    { "kind": "forbids_any", "requirement": "No brochure words",
      "words": ["exciting opportunity", "passionate", "market leader", "industry leader", "dynamic", "cutting edge", "great culture"] }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-your-story', 3, 'choice', $j${
  "beats": [
    {
      "situation": "Your answer runs to three minutes. It contains: the degree you did, your first job, a two-year contract role, your current job, a side project you love, and the landing.",
      "prompt": "The recruiter has given you ninety seconds. What goes?",
      "options": [
        { "text": "The degree and the first job, compressed into one clause.", "correct": true, "note": "Cut whole items, oldest first. Nobody is hiring you for the degree, and the first job earns its place only as the thing that started the direction." },
        { "text": "Trim every sentence by a few words throughout.", "correct": false, "note": "This is how a three-minute answer becomes a two-minute-fifty answer that is now also hard to follow. Words are not where the time is." },
        { "text": "The side project — it is not what they asked about.", "correct": false, "note": "Possibly the most memorable thing in the answer. Cut for age, not for relevance you have not tested." },
        { "text": "The landing, since you can come back to it later.", "correct": false, "note": "The landing is the only part doing work. Cutting it leaves a summary of your CV, which they already have." }
      ]
    },
    {
      "situation": "You have cut it to ninety seconds and it now feels thin to you.",
      "prompt": "What does that feeling usually mean?",
      "options": [
        { "text": "Nothing. It is your third telling and their first.", "correct": true, "note": "Thinness is what a well-cut answer feels like from the inside, because you can hear everything you left out. They cannot." },
        { "text": "You cut too much and should put one item back.", "correct": false, "note": "The instinct that walks it back to three minutes over a week of practice. If it is complete and it lands, it is finished." },
        { "text": "You need more detail in the middle to prove it.", "correct": false, "note": "Detail in the middle is what the next twenty questions are for. This answer only has to earn them." },
        { "text": "The order is wrong, which is why it feels flat.", "correct": false, "note": "Reordering a complete answer is a way of continuing to work on it. The order is fixed: start, middle, landing." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-your-story', 4, 'choice', $j${
  "beats": [
    {
      "situation": "Same job, same three beats. The person asking is a department head who has not read your CV and was added to the panel yesterday.",
      "prompt": "What does the middle become?",
      "options": [
        { "text": "What you were responsible for, in scope and outcomes.", "correct": true, "note": "She cannot place you, so the middle has to say what size of thing you have run and what happened to it. Detail she has no frame for is noise." },
        { "text": "The technical decisions you are proudest of.", "correct": false, "note": "The right middle for a peer and the wrong one here. She has no way to tell a hard decision from an easy one in your field." },
        { "text": "The same middle you would give anyone. Consistency matters.", "correct": false, "note": "Consistency of the three beats matters. A middle that ignores who is asking is not consistent, it is unadapted." },
        { "text": "A shorter version, since she has less context.", "correct": false, "note": "Less context needs more orientation, not less. Shortening is the wrong axis." }
      ]
    },
    {
      "situation": "The next interview is with someone who will do the same job as you, one rung up.",
      "prompt": "What does the middle become now?",
      "options": [
        { "text": "The specific work, including the parts that were hard.", "correct": true, "note": "He can tell the difference, which is the whole opportunity. Scope and outcomes to a peer read as somebody avoiding the detail." },
        { "text": "Scope and outcomes, so he can see the level you operate at.", "correct": false, "note": "He will read this as a manager's answer from somebody who may not have done the work. With a peer, go down a layer." },
        { "text": "Whatever he has just been talking about.", "correct": false, "note": "Following his interest is good instinct and it is not the middle of your story. Change the middle, keep the beats." },
        { "text": "The same one you gave the department head.", "correct": false, "note": "The one audience it is guaranteed to underperform with." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-your-story', 5, 'beat', $j${
  "turns": [
    { "instruction": "Before you walk through anything, say what the whole arc adds up to. One sentence." },
    { "instruction": "Now walk it, and give each move a reason — why you left, not just where you went." },
    { "instruction": "Land it on the present. What the last move was for, and why this room." }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------
-- Answering with evidence
-- ---------------------------------------------------------------------------

select pg_temp.set_mode('interview-evidence', 1, 'beat', $j${
  "turns": [
    { "instruction": "Two sentences of scene, and one of them must say why it was hard. No more than two." },
    { "instruction": "Now what you did. This is where the answer lives, so give it the room the scene did not get." },
    { "instruction": "Finish on what was different afterwards." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-evidence', 2, 'line', $j${
  "says": "So the thing I want to get at is what you specifically brought. What did you actually do?",
  "maxChars": 500,
  "model": {
    "line": "I rewrote the triage rules over about three weeks, sat with two of the support leads to check each rule against real tickets, and then trained the rota on the new version before it went live.",
    "why": "Four verbs, all of them yours, and not a single we. The team can go in the scene; this part of the answer is the part they are hiring."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Say I, and keep saying it" },
    { "kind": "forbids_any", "requirement": "Not one we, our or us in it",
      "words": ["we", "our", "us", "ours"] },
    { "kind": "min_words", "requirement": "Enough detail that it could only be you", "n": 25 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-evidence', 3, 'line', $j${
  "says": "And I will warn you now — I am going to ask how you measured it.",
  "model": {
    "line": "Tickets on those six questions went from about two hundred a week to under forty. The team stopped working Saturdays.",
    "why": "A number where an honest one exists, and then the change that number meant. An answer that ends on the action sounds like effort; this ends on impact."
  },
  "checks": [
    { "kind": "max_sentences", "requirement": "Two sentences. This is the ending, not the story.", "n": 2 },
    { "kind": "contains_any", "requirement": "Say what was true afterwards that was not true before",
      "words": ["from", "to", "per cent", "percent", "halved", "doubled", "reduced", "fewer", "faster", "dropped", "rose", "stopped", "went"] }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-evidence', 4, 'choice', $j${
  "beats": [
    {
      "situation": "You hold six stories. One is the triage rebuild: you disagreed with your manager about the approach, argued it for a month, won, and it worked.",
      "prompt": "The question is: tell me about a time you disagreed with someone more senior.",
      "options": [
        { "text": "Tell the triage story, facing the disagreement.", "correct": true, "note": "Same story, different facet. You spend the words on the month of arguing and the outcome is a sentence, because the outcome is not what was asked." },
        { "text": "Find a story that is only about a disagreement.", "correct": false, "note": "This is how people end up with twenty stories and none of them ready. Six well-known stories have more facets than you will ever be asked about." },
        { "text": "Tell the triage story as you normally tell it.", "correct": false, "note": "Then it is an answer about a project with a disagreement mentioned in it, and the interviewer has to do the work of finding what they asked for." },
        { "text": "Say you tend to agree with senior people.", "correct": false, "note": "Which answers a different and much worse question about you." }
      ]
    },
    {
      "situation": "Next question: tell me about a time you had to persuade somebody.",
      "prompt": "What now?",
      "options": [
        { "text": "The triage story again, facing the persuasion.", "correct": true, "note": "Reusing a story across two questions is fine and interviewers rarely notice, because you are telling them different things. Six stories are meant to be reused." },
        { "text": "Anything but the triage story — you just used it.", "correct": false, "note": "The rule people invent, at the cost of telling a worse story badly. They are listening for the facet, not auditing your catalogue." },
        { "text": "The triage story, told the same way as before.", "correct": false, "note": "Now it is repetition rather than reuse, and this is the version they do notice." },
        { "text": "A new story, to show range.", "correct": false, "note": "Range is shown by the six, not by refusing to reuse one. A thin new story costs more than a repeated strong one." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-evidence', 5, 'beat', $j${
  "turns": [
    { "instruction": "Say plainly what you have not done. One sentence, no hedging, no almost." },
    { "instruction": "Now answer the question underneath it — the nearest thing you have actually done, and what transfers." }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------
-- Failure, weakness and gaps
-- ---------------------------------------------------------------------------

select pg_temp.set_mode('interview-failure', 1, 'line', $j${
  "says": "I would like to talk about something that went badly. Not a difficult situation you handled well — something you got wrong.",
  "maxChars": 800,
  "model": {
    "line": "I kept a project running four months after it was clear it was not going to work, because I had argued for it and did not want to be the one to say so. It cost the two people on it half a year they could have spent on something real. Now I write down at the start what would make me stop, and I show it to somebody else.",
    "why": "Named, costed, changed, stopped. The last beat is a mechanism rather than a lesson learned, which is the difference between a thing you did and a thing you say."
  },
  "checks": [
    { "kind": "min_words", "requirement": "A real one, with enough in it to be believed", "n": 30 },
    { "kind": "max_words", "requirement": "Under ninety words. The stopping is the lesson.", "n": 90 },
    { "kind": "contains_any", "requirement": "Say what it cost",
      "words": ["cost", "meant", "missed", "late", "lost", "had to", "ended up", "spent"] }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-failure', 2, 'line', $j${
  "says": "Right — the boring one, but I do want a real answer. What would the people who have worked with you say you are worst at?",
  "maxChars": 600,
  "model": {
    "line": "I am slow to give people bad news. I sat on a slipping date for two weeks once and my counterpart planned around a date I already knew was wrong, which cost her a fortnight. I say the date out loud now on the day I stop believing it.",
    "why": "A weakness with a named victim and a specific guard. A weakness that cost nobody anything is a boast wearing a hat, and everybody in the room can hear it."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Not one of the fake ones",
      "words": ["perfectionist", "perfectionism", "work too hard", "too honest", "care too much", "too passionate", "overachiever", "too much of a"] },
    { "kind": "contains_any", "requirement": "Name what it has cost somebody else",
      "words": ["cost", "meant", "missed", "slower", "had to", "wrong", "waited"] },
    { "kind": "max_words", "requirement": "Under seventy words", "n": 70 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-failure', 3, 'line', $j${
  "says": "Before we go on — there is a stretch here with nothing in it. Talk me through that.",
  "maxChars": 500,
  "model": {
    "line": "That is fourteen months from March 2023. My father was ill and I was the one who could go. I started looking again in May, and this is the first role I have wanted enough to apply for.",
    "why": "The dates, one unbitter sentence of reason, and then it moves on at the same speed as everything else. The apologising is what makes it sound like something to apologise for."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No apologising. It is a fact, not a charge.",
      "words": ["sorry", "unfortunately", "embarrassed", "ashamed", "afraid", "regret", "apologise", "apologize", "i know it looks"] },
    { "kind": "max_sentences", "requirement": "State it, one sentence of reason, move on", "n": 3 },
    { "kind": "max_words", "requirement": "Under sixty words", "n": 60 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-failure', 4, 'beat', $j${
  "turns": [
    { "instruction": "Quote the feedback in their words, not your softened version of it." },
    { "instruction": "Admit your first reaction honestly. Nobody takes hard feedback well in the first hour." },
    { "instruction": "Now say what an observer would have seen change afterwards. Behaviour, not attitude." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-failure', 5, 'choice', $j${
  "beats": [
    {
      "situation": "You have described a launch that failed because nobody had checked whether the data was clean. The interviewer asks what you would do differently.",
      "prompt": "Which answer shows judgement?",
      "options": [
        { "text": "Name the condition: no one owned data quality, so nobody checked.", "correct": true, "note": "Answering about the conditions rather than the mistake. It says you can see the system that produced the error, which is what they are actually assessing." },
        { "text": "Say you would have checked the data.", "correct": false, "note": "True and worth nothing. It is the mistake said backwards, and it implies the only thing standing between you and a repeat is remembering harder." },
        { "text": "Say you would have pushed back on the timeline.", "correct": false, "note": "Closer, and still about one decision on one day rather than about why that decision was easy to get wrong." },
        { "text": "Say the team should have flagged it.", "correct": false, "note": "The answer that ends the interview. Even where it is true, it answers a question about you with a sentence about them." }
      ]
    },
    {
      "situation": "Same question, and honestly you would do it exactly the same way. It was a reasonable call that went badly.",
      "prompt": "What do you say?",
      "options": [
        { "text": "Say so, and name what you would watch for earlier.", "correct": true, "note": "Standing behind a reasonable decision is a seniority signal, provided you can say what would now make you notice sooner." },
        { "text": "Invent something you would change, since they want one.", "correct": false, "note": "They can hear it. A manufactured regret is worse than a defended decision, because it tells them what you do under mild pressure." },
        { "text": "Say there was nothing you could have done.", "correct": false, "note": "Standing behind the decision without offering the earlier signal reads as being unable to learn from an outcome." },
        { "text": "Change the example to one where you did get it wrong.", "correct": false, "note": "Dodging the question. They asked about this one." }
      ]
    }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------
-- Talking about the work
-- ---------------------------------------------------------------------------

select pg_temp.set_mode('interview-craft', 1, 'line', $j${
  "says": "I should say up front that I am not from your world at all. Tell me about the most complicated thing you have worked on.",
  "maxChars": 700,
  "model": {
    "line": "The company was losing orders because three systems each held a different version of the same customer and nobody could tell which was right. I built the thing that decides which one wins. It runs every night, and orders lost to bad addresses went to almost nothing.",
    "why": "What it was for, then what it was. Every word in it survives a commercial lead, and the person who does your job will read it as somebody who can talk to stakeholders."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No word the least technical person would have to look up",
      "words": ["kubernetes", "microservice", "api", "latency", "schema", "kafka", "orchestration", "middleware", "backend", "frontend", "kubernetes", "idempotent"] },
    { "kind": "contains_any", "requirement": "Say what it was for before you say what it was",
      "words": ["because", "so that", "which meant", "the problem", "was losing", "could not"] },
    { "kind": "max_words", "requirement": "Under eighty words", "n": 80 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-craft', 2, 'line', $j${
  "says": "Pick something you built where there was a real fork in the road. I am much more interested in the fork than in the thing.",
  "maxChars": 600,
  "model": {
    "line": "We could have bought a product that did most of it, and I chose to build instead, because the part it did not do was the part that was actually costing us money. It meant six weeks longer and a thing we understand.",
    "why": "Names the road not taken and what the choice cost. Describing a decision without its alternative reads as describing something that only had one option."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Name the road you did not take",
      "words": ["instead", "rather than", "the alternative", "we could have", "i could have", "against", "the other option"] },
    { "kind": "min_words", "requirement": "Say why you did not take it", "n": 25 },
    { "kind": "max_words", "requirement": "Under ninety words", "n": 90 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-craft', 3, 'beat', $j${
  "turns": [
    { "instruction": "Answer one layer deep. The shape of the problem and what you did about it — no more." },
    { "instruction": "Now offer the next layer in a short sentence, and stop. Let her decide whether she wants it." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-craft', 4, 'scene', null);

select pg_temp.set_mode('interview-craft', 5, 'line', $j${
  "says": "Your CV mentions eighteen months on something you have described only as a public sector programme. That is the bit I most want to hear about.",
  "maxChars": 700,
  "model": {
    "line": "I cannot go into what the system was actually for. What I can tell you is that it was eleven agencies who had never shared data, a deadline set by legislation rather than by us, and my job was the part where we had to agree what a person even was across eleven different definitions.",
    "why": "The boundary named once, plainly, and then the shape of the work in full. Repeating the caveat is what makes an interviewer feel they are dragging it out of you."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Name the boundary once",
      "words": ["cannot go into", "cannot say", "cannot name", "not able to", "under", "will not be able"] },
    { "kind": "min_words", "requirement": "Then describe the shape of it anyway", "n": 40 }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------
-- Screening calls and rapport
-- ---------------------------------------------------------------------------

select pg_temp.set_mode('interview-rapport', 1, 'choice', $j${
  "beats": [
    {
      "situation": "A recruiter rings for a twenty-minute screen. You are between meetings and it is not the real interview.",
      "prompt": "How do you treat it?",
      "options": [
        { "text": "As the real interview, because the shortlist is decided here.", "correct": true, "note": "The screen is the only round that is purely elimination. Nobody is hired on it and most people are removed by it." },
        { "text": "As an administrative call to confirm the basics.", "correct": false, "note": "It is presented that way and it is not. The recruiter is deciding which three CVs go to the manager with a sentence attached." },
        { "text": "Politely, but save your material for the manager.", "correct": false, "note": "There is no manager round to save it for if this goes flat." },
        { "text": "As a chance to find out whether the job is worth pursuing.", "correct": false, "note": "Worth doing and not instead of the above. Both of you are screening; only one of you gets removed today." }
      ]
    },
    {
      "situation": "The recruiter is not technical and cannot assess whether you are any good.",
      "prompt": "What are they actually deciding?",
      "options": [
        { "text": "Whether you can talk, whether you want it, and whether the money works.", "correct": true, "note": "The three things a screen exists to answer. All three are answerable by somebody who cannot judge your work, which is exactly why they are the three." },
        { "text": "Whether your CV is accurate.", "correct": false, "note": "A small part of it, and not what gets you through. Accuracy is assumed until it is not." },
        { "text": "How your experience maps to the requirements.", "correct": false, "note": "The manager's job. The recruiter is checking you can describe it, not whether it is enough." },
        { "text": "Whether they like you.", "correct": false, "note": "Closer than it sounds and too vague to act on. Answer the three above and the liking follows." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-rapport', 2, 'choice', $j${
  "beats": [
    {
      "situation": "The recruiter opens with: \"Right — sorry, I have got about four tabs open and none of them are yours. Give me two seconds. Right. So what is the story, why are you looking?\"",
      "prompt": "How do you answer?",
      "options": [
        { "text": "Loosely and briefly, in the register he set.", "correct": true, "note": "He has told you how this call runs. A formal three-part answer to \"what is the story\" lands as somebody who was not listening." },
        { "text": "With your full prepared ninety-second arc.", "correct": false, "note": "The right answer to a different question. Matching length is most of matching register, and his question was eleven words." },
        { "text": "Formally, to set a professional tone.", "correct": false, "note": "Correcting somebody's register is a strange thing to do in the first minute of a call where they decide your week." },
        { "text": "Match his informality and add a joke.", "correct": false, "note": "Matching is not raising. Going a notch past somebody in the first two exchanges is the version that misfires." }
      ]
    },
    {
      "situation": "A different call. The hiring manager speaks in careful, complete sentences and pauses before each one.",
      "prompt": "What do you do?",
      "options": [
        { "text": "Slow down and let your sentences finish.", "correct": true, "note": "Register is length and formality, and it runs in both directions. Speed against somebody deliberate reads as nerves whether or not you are nervous." },
        { "text": "Keep your natural pace so you sound authentic.", "correct": false, "note": "Authenticity is not a pace. Matching somebody is the cheapest way to be easy to listen to." },
        { "text": "Fill his pauses so the call keeps moving.", "correct": false, "note": "Those pauses are him thinking. Filling them removes the thing he is doing." },
        { "text": "Mirror the pauses exactly.", "correct": false, "note": "Matching, not mimicry. Copying somebody's rhythm beat for beat is noticeable and strange." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-rapport', 3, 'line', $j${
  "says": "Why us? And I would rather have a short honest answer than a good one.",
  "maxChars": 500,
  "model": {
    "line": "You are the only people I found who publish the postmortems. I read three of them and they were honest in a way that told me what it is actually like to work here. That is the thing I am short of where I am.",
    "why": "One specific thing about them, what it told you, and why that is what you want. None of it could be said about another company, which is the entire test."
  },
  "checks": [
    { "kind": "max_sentences", "requirement": "Three sentences at most", "n": 3 },
    { "kind": "min_words", "requirement": "Say what the detail told you, not just that you liked it", "n": 15 },
    { "kind": "forbids_any", "requirement": "No brochure words",
      "words": ["exciting opportunity", "passionate", "market leader", "industry leader", "great culture", "dynamic", "cutting edge", "synergy", "fast paced"] }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-rapport', 4, 'beat', $j${
  "turns": [
    { "instruction": "She has asked how you are, mid-apology, between meetings. Answer with something specific and true rather than fine thanks." },
    { "instruction": "Now follow her transition into the interview proper. Do not extend the small talk past where she took it." }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-rapport', 5, 'scene', null);

-- ---------------------------------------------------------------------------
-- The questions you ask
-- ---------------------------------------------------------------------------

select pg_temp.set_mode('interview-your-questions', 1, 'line', $j${
  "says": "That is everything from me, and we have got about ten minutes. What have you got for me?",
  "model": {
    "line": "What is the thing about working here that you would not have believed before you joined?",
    "why": "No document contains the answer and no other candidate has asked it. It also gives her permission to say something true, which is what makes the answer worth hearing."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Ask it, do not state it" },
    { "kind": "forbids_any", "requirement": "Nothing a website could have answered",
      "words": ["what does the company", "how many people work", "what is the salary", "benefits", "holiday", "how big is the company", "what do you do here"] },
    { "kind": "max_words", "requirement": "Under thirty-five words — one question, not three", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-your-questions', 2, 'line', $j${
  "says": "We have got a bit of time left. I would rather use it on your questions than on more of mine — what do you want to know?",
  "model": {
    "line": "What would you want me to have got done by the end of the first three months?",
    "why": "Asked in the present tense about the job as though it were already yours. It is very hard to answer without picturing you doing it, which is the point."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Ask it, do not state it" },
    { "kind": "contains_any", "requirement": "Ask about the work as though you already had it",
      "words": ["first", "week", "month", "day to day", "start", "arrive", "i would", "me to"] },
    { "kind": "max_words", "requirement": "Under thirty-five words", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-your-questions', 3, 'line', $j${
  "says": "Right. I think that is my lot. Anything you want to ask me before we finish?",
  "model": {
    "line": "What has kept you here seven years, when I imagine the last two cannot have been easy?",
    "why": "Asks for her opinion rather than for information, and it is about her rather than about the company. One of these per interview; two makes it an interview of them."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Ask it, do not state it" },
    { "kind": "contains_any", "requirement": "Ask what they think, not what is true",
      "words": ["what do you think", "in your view", "what has", "do you find", "what surprised", "what keeps you", "why did you", "would you"] },
    { "kind": "max_words", "requirement": "Under thirty-five words", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-your-questions', 4, 'choice', $j${
  "beats": [
    {
      "situation": "You ask what problem the role exists to solve. He says: \"Honestly, we are just growing and we need more hands.\"",
      "prompt": "What did that tell you?",
      "options": [
        { "text": "Nobody has decided what this role is for yet.", "correct": true, "note": "The most useful answer you will get all day, and it is in what he left out. A role with a defined problem gets a specific answer without prompting." },
        { "text": "The company is doing well, which is a good sign.", "correct": false, "note": "Reading the surface. Growth is why the headcount exists; it is not what the job is." },
        { "text": "He is being evasive.", "correct": false, "note": "Usually not. Vagueness here is far more often absence of an answer than concealment of one." },
        { "text": "Nothing much — it is a normal answer.", "correct": false, "note": "It is a normal answer, and normal answers to this question are the finding. Most roles are underspecified and most candidates never check." }
      ]
    },
    {
      "situation": "You ask the same question of the hiring manager. She says: \"Support is drowning and we have tried twice to fix it with process. It needs somebody who can build.\"",
      "prompt": "What did that tell you?",
      "options": [
        { "text": "The problem is real, and two people have already failed at it.", "correct": true, "note": "Everything you need. You know the problem, you know it is hard, and you know what the last two attempts were, which is the question to ask next." },
        { "text": "The role is well defined, so this is a good job.", "correct": false, "note": "Half of it. A well-defined problem that has defeated two previous attempts is information about difficulty as much as about clarity." },
        { "text": "They are desperate, so you have leverage.", "correct": false, "note": "A conclusion about negotiation drawn from a sentence about the work, and usually wrong." },
        { "text": "You should ask about the process attempts.", "correct": false, "note": "You should, and that is the next move rather than the read. What she told you is that the problem is real." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-your-questions', 5, 'choice', $j${
  "beats": [
    {
      "situation": "You have fifteen minutes with the person who would be your direct report.",
      "prompt": "What do you ask them?",
      "options": [
        { "text": "What they would want to be different about how the team is run.", "correct": true, "note": "The only person in the building who can answer it, and the answer tells you what you would be walking into on day one." },
        { "text": "What the company strategy is for the next two years.", "correct": false, "note": "Asking somebody a question about a room they are not in. It also reads as not knowing what they do." },
        { "text": "Whether they enjoy working there.", "correct": false, "note": "They will say yes. Questions with one socially available answer buy nothing." },
        { "text": "What the hiring manager is like to work for.", "correct": false, "note": "The right question to somebody who is not about to report to you. Here it asks them to be indiscreet with a stranger who may become their boss." }
      ]
    },
    {
      "situation": "Twenty minutes with a director two levels up, who will not manage you.",
      "prompt": "What do you ask them?",
      "options": [
        { "text": "What would have to be true in two years for this hire to have been worth it.", "correct": true, "note": "Pitched at what they can see and nobody below them can. It also tells you what the role is measured against, which rarely matches the job description." },
        { "text": "What a normal week in the role looks like.", "correct": false, "note": "He does not know, and asking makes that obvious to both of you." },
        { "text": "The same question you asked the hiring manager.", "correct": false, "note": "Comparing answers is genuinely useful and this is not the place to spend one of three questions with somebody who sees something nobody else does." },
        { "text": "How the team is structured.", "correct": false, "note": "A document question, and he is the most expensive person in the process to spend one on." }
      ]
    }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------
-- Salary and offers
-- ---------------------------------------------------------------------------

select pg_temp.set_mode('interview-money', 1, 'choice', $j${
  "beats": [
    {
      "situation": "You have a screening call in an hour and money will come up.",
      "prompt": "What do you need decided before you pick up?",
      "options": [
        { "text": "The market number and the number below which you would say no.", "correct": true, "note": "Two numbers, both decided while you are calm. Everything that goes wrong in this conversation goes wrong because somebody is doing arithmetic live." },
        { "text": "What you are on now, plus a reasonable increase.", "correct": false, "note": "Anchors the whole negotiation to a number that has nothing to do with this job, and if you are underpaid it carries that forward." },
        { "text": "The highest number you could say without laughing.", "correct": false, "note": "A number you cannot justify is one you will abandon under the first question, which is worse than not naming one." },
        { "text": "Nothing — see what they offer first.", "correct": false, "note": "Fine as a tactic and useless as preparation. They may ask first, and then you are deciding in real time." }
      ]
    },
    {
      "situation": "The market number is eighty. Your walk-away is sixty-eight. They offer seventy-two.",
      "prompt": "What is the walk-away number for?",
      "options": [
        { "text": "Knowing that seventy-two is a decision rather than a rescue.", "correct": true, "note": "It exists so you can tell an acceptable offer from a survivable one while somebody is waiting on the phone. Seventy-two is above the floor, so you can negotiate from calm." },
        { "text": "Telling them the minimum you will accept.", "correct": false, "note": "It is never said out loud. The moment they hear it, it is the offer." },
        { "text": "Deciding automatically — above it, accept.", "correct": false, "note": "It is a floor, not a rule. Seventy-two clears the floor and is still eight below the market number." },
        { "text": "Working out how much to ask for.", "correct": false, "note": "That is the market number's job. The walk-away exists for the other end." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-money', 2, 'line', $j${
  "says": "One thing I have to ask before I can put you forward — what sort of package are you after?",
  "maxChars": 500,
  "model": {
    "line": "I am looking at somewhere between seventy-five and eighty-five, based on what comparable roles have been advertised at this year. If the rest of the package is unusual I am happy to look at the whole thing.",
    "why": "A range with the reason attached, which makes it a position rather than a hope. The second sentence keeps the door open without moving the number."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Give the reason along with the number",
      "words": ["based on", "because", "market", "comparable", "advertised", "research", "similar roles"] },
    { "kind": "max_sentences", "requirement": "Three sentences at most", "n": 3 },
    { "kind": "min_words", "requirement": "Enough that it reads as a position", "n": 15 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-money', 3, 'line', $j${
  "says": "The base would be at the figure we discussed.",
  "model": {
    "line": "Thank you, I am really pleased. Is there any flexibility on the base?",
    "why": "Warm, then the ask, then nothing. The whole technique is the silence afterwards, and the reason to keep it short is that a long question gives you somewhere to keep talking."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Ask, then stop" },
    { "kind": "max_words", "requirement": "Under twenty-five words. The silence after it is the tool.", "n": 25 },
    { "kind": "forbids_any", "requirement": "Do not apologise for asking",
      "words": ["i understand if", "of course", "no worries", "just wondering", "sorry", "i know it is", "hope that is ok"] }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-money', 4, 'choice', $j${
  "beats": [
    {
      "situation": "\"The bands are set centrally and there is nothing I can do about the base.\"",
      "prompt": "What do you ask for?",
      "options": [
        { "text": "What else can move — start date, days, budget, title, review point.", "correct": true, "note": "A fixed base is usually true and almost never the whole compensation. The question that follows it is what else, and it is very rarely refused outright." },
        { "text": "Nothing. A no on the base is a no.", "correct": false, "note": "Treating one fixed component as a fixed offer. The base is the least flexible thing in almost every package." },
        { "text": "Push once more on the base to test it.", "correct": false, "note": "You have had a clear answer with a reason. Pushing again spends goodwill on the one component you have been told is locked." },
        { "text": "Ask for a signing bonus specifically.", "correct": false, "note": "One good idea instead of an open question. Asking what can move lets them offer the thing they actually have." }
      ]
    },
    {
      "situation": "They offer an extra week of leave and an early review at six months.",
      "prompt": "What is worth pinning down?",
      "options": [
        { "text": "The review, in writing, with what it is reviewing against.", "correct": true, "note": "Leave is real the day you start. A review is a promise about a conversation, and it is worth what its criteria are worth." },
        { "text": "Nothing — you have what you asked for.", "correct": false, "note": "You have one thing that is real and one that depends entirely on who is still there in six months." },
        { "text": "Ask for both plus the original base increase.", "correct": false, "note": "Reopening a component after they moved on two others is how a good negotiation becomes a memorable one, in the wrong way." },
        { "text": "The extra week, since leave policies change.", "correct": false, "note": "Reasonable and low value. Leave granted at offer is contractual; it is the review that is vapour until it is specified." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-money', 5, 'line', $j${
  "says": "Hi — thanks for calling. I have to say I am hoping this is good news, the team have been asking me all week.",
  "maxChars": 500,
  "model": {
    "line": "Thank you, genuinely, and I am sorry to be the one saying this. I have accepted another role. It came down to the commute more than anything, and I would happily have worked for you.",
    "why": "Prompt, warm, and true. Saying the real reason costs you nothing now and is the only version that leaves the door open, which is worth more than the job you turned down."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Thank them, and mean it",
      "words": ["thank", "grateful", "appreciate"] },
    { "kind": "max_sentences", "requirement": "Four sentences. Prompt is the kindness.", "n": 4 },
    { "kind": "forbids_any", "requirement": "Do not leave them hanging",
      "words": ["think about it", "get back to you", "need more time", "let you know next week", "sleep on it"] }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------
-- Closing and following up
-- ---------------------------------------------------------------------------

select pg_temp.set_mode('interview-closing', 1, 'line', $j${
  "says": "That is everything from my side, and I think we are about out of time. Thanks for coming in — you will hear from us by the end of next week.",
  "model": {
    "line": "Before I go — I want this job. Everything I have heard today has made me want it more rather than less.",
    "why": "Plain, unhedged, and it takes four seconds. Interviewers routinely rank two close candidates by which of them said this, because only one of them ever does."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Say that you want it, in those words",
      "words": ["want", "would like", "keen", "hope you"] },
    { "kind": "first_person", "requirement": "Say it about yourself" },
    { "kind": "max_sentences", "requirement": "Two sentences. Do not build up to it.", "n": 2 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-closing', 2, 'line', $j${
  "says": "I think that covers everything I wanted to ask. Anything else from you before we wrap up?",
  "model": {
    "line": "Is there anything in my background that would give you pause?",
    "why": "It surfaces the objection while you are still in the room, which is the only time you can answer it. Most candidates find out what it was in a rejection email, or never."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Ask it plainly" },
    { "kind": "contains_any", "requirement": "Ask what would give them pause",
      "words": ["pause", "hesitat", "concern", "reservation", "stop you", "doubt", "worry", "against"] },
    { "kind": "max_words", "requirement": "Under thirty words — one question, then listen", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-closing', 3, 'line', $j${
  "says": "So what are you going to send them? And do not read me the one that starts thank you for your time.",
  "maxChars": 1000,
  "model": {
    "line": "You mentioned the support backlog was the thing keeping you up at night. I went and looked at how two other companies handled the same shape of problem after we spoke, and the thing they both did first was stop routing by product and start routing by whether the answer already existed somewhere. I have put both write-ups below in case they are useful either way.",
    "why": "It adds something the interview did not contain, which is the only reason to send one. It is also useful to him whether or not he hires you, and that is what makes it land rather than lobby."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "None of the sentences everybody sends",
      "words": ["thank you for your time", "great to meet you", "looking forward to hearing", "please do not hesitate", "as discussed"] },
    { "kind": "min_words", "requirement": "Add something the interview did not contain", "n": 40 },
    { "kind": "max_words", "requirement": "Under a hundred and forty words. It is a note.", "n": 140 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-closing', 4, 'choice', $j${
  "beats": [
    {
      "situation": "They said you would hear by the end of last week. It is now Tuesday and there has been nothing.",
      "prompt": "What do you do?",
      "options": [
        { "text": "Chase once, briefly, referring to the date they gave.", "correct": true, "note": "The date is theirs, which makes the chase a reminder rather than a demand. One message, and then it is their move." },
        { "text": "Wait another week so as not to seem desperate.", "correct": false, "note": "The date has passed. Chasing after a missed deadline is not pressure, it is the ordinary behaviour of somebody who is organised." },
        { "text": "Chase, then follow up again on Thursday if nothing comes.", "correct": false, "note": "The second chase is the one that changes how you are described internally. One is a reminder; two is a problem." },
        { "text": "Ring rather than email, to get a real answer.", "correct": false, "note": "Escalating the channel makes a small chase into an event, and usually reaches somebody who cannot tell you anything." }
      ]
    },
    {
      "situation": "At the end of the interview they did not say when they would decide.",
      "prompt": "What is the fix?",
      "options": [
        { "text": "Ask, before you leave the room.", "correct": true, "note": "Everything about chasing well depends on having a date that came from them. Two seconds at the end buys the whole thing." },
        { "text": "Assume a week and chase after that.", "correct": false, "note": "Chasing against a deadline you invented is where the anxiety lives, and it usually produces a message a week too early." },
        { "text": "Ask the recruiter afterwards.", "correct": false, "note": "Workable and second best. The person deciding knows; the recruiter is repeating." },
        { "text": "Wait for them to come to you.", "correct": false, "note": "Which is the position the whole lesson exists to avoid." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('interview-closing', 5, 'line', $j${
  "says": "I am sorry, it is not the news I wanted to give you. They have decided to go with another candidate — it was very close, and the feedback was positive overall.",
  "maxChars": 500,
  "model": {
    "line": "Thank you for telling me directly, and for the feedback. Can I ask what the person who got it had that I did not? And if something like this comes up again, I would like you to think of me.",
    "why": "Thanks, one specific question, and the door left open. A remarkable number of people are hired into the next role by the person who turned them down for this one."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Thank them, and mean it",
      "words": ["thank", "grateful", "appreciate"] },
    { "kind": "requires_question", "requirement": "Ask one specific question" },
    { "kind": "max_sentences", "requirement": "Four sentences at most", "n": 4 }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------
-- The printable page.
--
-- Sixteen concepts across the eight tracks, and the idea at the top is the one
-- that reframes the whole topic: an interview is not an exam. Somebody who
-- believes it is an exam optimises for not being wrong, and not being wrong is
-- what a forgettable candidate looks like.
-- ---------------------------------------------------------------------------

update public.topics set cheatsheet_json = $j${
  "idea": "An interview is not an exam, and treating it as one is what produces a candidate nobody remembers. They are not checking whether you are wrong. They are deciding whether they can picture you doing the job, and almost everything below is a way of making that picture easier to form.",
  "groups": [
    {
      "skill": "interview-your-story",
      "concepts": [
        { "name": "Three beats", "body": "Where you came from, what you did with it, why you are in this room. Ninety seconds, and the landing is the load-bearing one." },
        { "name": "Cut items, never words", "body": "To shorten an answer, drop the second-best example whole. Trimming every sentence gets you the same length and a worse answer." }
      ]
    },
    {
      "skill": "interview-evidence",
      "concepts": [
        { "name": "Two sentences of scenery", "body": "The scene is the comfortable part and it is where the time goes. Two sentences, one of which says why it was hard, then the verb." },
        { "name": "We is the word that costs you", "body": "The team gets one sentence in the scene. Everything after it is I, because the interviewer cannot hire the team." },
        { "name": "End on what changed", "body": "A number if you honestly have one, otherwise what was true afterwards that was not true before. Ending on the action sounds like effort." },
        { "name": "Six stories, many facets", "body": "You do not need a story per question. You need six you know well, and the habit of facing the one they asked about." }
      ]
    },
    {
      "skill": "interview-failure",
      "concepts": [
        { "name": "Name it, cost it, change it, stop", "body": "The stopping is the hard part. The silence afterwards feels like it needs filling, and filling it turns an answer into a confession." },
        { "name": "A weakness with no cost is a boast", "body": "Name what it has cost somebody else, and the specific guard you now use. Perfectionism tells them you will hide a late project." }
      ]
    },
    {
      "skill": "interview-craft",
      "concepts": [
        { "name": "Aim at the least technical person", "body": "Say what it was for, then what it was. The specialist will read it as somebody who can talk to stakeholders, not as somebody shallow." },
        { "name": "Say what you chose against", "body": "For any decision you describe, name the alternative you rejected and why. That is the seniority signal, and it is almost never volunteered." }
      ]
    },
    {
      "skill": "interview-rapport",
      "concepts": [
        { "name": "The screen is a real interview", "body": "Nobody is hired on it and most people are removed by it. They are deciding three things: can you talk, do you want it, does the money work." },
        { "name": "Match the register", "body": "Match the length and formality of their sentences in the first two exchanges. A prepared arc in answer to what is the story lands as not listening." }
      ]
    },
    {
      "skill": "interview-your-questions",
      "concepts": [
        { "name": "Ask what only they can answer", "body": "Nothing a website contains. The best ones ask for an opinion, because an opinion is the thing they cannot give a rehearsed answer to." },
        { "name": "Ask what problem the role solves", "body": "Then listen for what they leave out. Vagueness here almost always means nobody has decided what the job is yet." }
      ]
    },
    {
      "skill": "interview-money",
      "concepts": [
        { "name": "Two numbers, decided in advance", "body": "The market number and the one below which you say no. Everything that goes wrong here goes wrong because somebody is doing arithmetic live." },
        { "name": "If the base will not move, ask what will", "body": "The base is the least flexible thing in most packages. Start date, leave, budget, title and an early review are all usually real." }
      ]
    },
    {
      "skill": "interview-closing",
      "concepts": [
        { "name": "Say that you want it", "body": "One plain sentence, four seconds. Interviewers routinely separate two close candidates by which of them said it, because only one ever does." },
        { "name": "Ask what would give them pause", "body": "It surfaces the objection while you are still in the room, which is the only time you can answer it." }
      ]
    }
  ]
}$j$::jsonb
where slug = 'interviews';
