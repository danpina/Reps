-- Talking to AI, track 1: An answer worth having.
--
-- The quality track. Four of the five lessons are mechanical and would be true
-- for anybody; lesson three is the one that belongs in this app specifically,
-- because treating the first answer as final is the same reflex that keeps a
-- quiet person quiet, and a chat window is the cheapest place to practise
-- contradicting something.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'an-answer-worth-having'),
  1,
  'Paste the actual thing',
  $md$Two people with the same subscription get very different value out of it, and most of the gap is one habit.

The commonest mistake by a distance is describing the problem instead of supplying it. *I need to reply to an email from my manager about a deadline* produces a reply to an imaginary email — competent, generic, and about a situation that does not exist.

**The move:** paste the material, do not describe it.

A description is a summary you already wrote, and the things you left out of it are precisely the things the answer needed: the phrase that worried you, the sentence that could be read two ways, the odd sign-off, the fact that they wrote it at midnight. You edited those out because you did not think they mattered, which is the same judgement you are asking for help with.

This holds for everything. The document rather than what the document is about. The whole thread rather than the last message. The job advert rather than the job title. The draft you already have rather than a description of what you are trying to say.

Two refinements worth having.

**Include what surrounds it.** The message before yours, the reply that came back, the thing that was decided last week. Half of what makes a message readable is what came before it, and pasting one line out of a conversation gets you advice about one line.

**When you cannot paste, reconstruct.** Plenty of the hardest things were said out loud and there is nothing to copy. Get as close to the actual words as you can — *he said something like, well, if you think that is realistic* — rather than tidying it into *he was sceptical*. Approximate quotation beats accurate paraphrase every time, because the wording is the thing you were asking about. Your paraphrase has already decided what it meant.

The one thing to keep out is anything you would not want stored: other people's private details, anything covered by an agreement you signed. Trim those and paste the rest.

If you keep one thing: paste the thing itself. Your summary of it has already thrown away the part you needed help with.$md$,
  $j$[
    {
      "situation": "You are stuck on a reply to a difficult email.",
      "line": "Here is the email, word for word.",
      "why": "A description is a summary you wrote, and what you left out of it is what the answer needed."
    },
    {
      "situation": "One line of a long thread is the problem.",
      "line": "(paste what came before it too)",
      "why": "Half of what makes a message readable is what preceded it. One line out of context gets advice about one line."
    },
    {
      "situation": "It was said out loud and there is nothing to copy.",
      "line": "He said something like, well, if you think that is realistic.",
      "why": "Approximate quotation beats accurate paraphrase, because the wording is what you were asking about."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does describing the problem produce a worse answer?",
      "options": [
        { "text": "Descriptions are too short.", "correct": false, "note": "Length is not it — a long description has the same fault, and a two-line paste often works fine." },
        { "text": "Your summary already dropped what mattered.", "correct": true, "note": "The odd phrase, the ambiguous sentence, the strange sign-off. You edited those out using the judgement you were asking for help with." },
        { "text": "It cannot tell you are describing rather than quoting.", "correct": false, "note": "It usually can, and it would not help if it could. The information is gone either way." },
        { "text": "It prefers structured input.", "correct": false, "note": "Format is not the issue. A messy paste beats a tidy description." }
      ],
      "explain": "Paste the thing itself, not your account of it."
    },
    {
      "prompt": "It was said out loud, so there is nothing to paste. What now?",
      "options": [
        { "text": "Summarise the tone accurately.", "correct": false, "note": "Your reading of the tone is the thing in question, so supplying it as fact removes the question." },
        { "text": "Skip it and ask a general question.", "correct": false, "note": "That gets you general advice, which you could have had without asking." },
        { "text": "Describe the person instead.", "correct": false, "note": "Useful for rehearsing a conversation later. It does not replace the words that were used." },
        { "text": "Reconstruct their words as closely as you can.", "correct": true, "note": "Approximate quotation beats accurate paraphrase. He was sceptical is your conclusion; what he actually said is the evidence." }
      ],
      "explain": "And include what came before it, because half the meaning is there."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "pasted", "label": "Supplied the material", "description": "Gave the actual text rather than an account of it." },
      { "key": "context", "label": "Included what surrounds it", "description": "The message before, the reply after." },
      { "key": "verbatim", "label": "Kept the wording", "description": "Did not tidy phrasing into conclusions." },
      { "key": "trimmed", "label": "Left out what should not be there", "description": "Other people's private details removed." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A colleague is watching you get nowhere with a reply you have been drafting for twenty minutes.",
    "partner": {
      "name": "Nadia",
      "role": "a colleague at the next desk",
      "personality": "Asks what exactly you told it, and notices when the answer is a summary rather than the email.",
      "mood": "Mildly amused.",
      "openness": 5
    },
    "opening_beat": "\"What did you actually give it?\"",
    "success_looks_like": "The user supplies the real material instead of a description of it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what exactly was pasted.",
      "Point out mildly when a description has been given instead.",
      "Never suggest what the request should say."
    ]
  }$j$::jsonb,
  $md$Today, paste the actual material into one request instead of describing it. Log the difference in what came back.$md$
),
(
  (select id from public.skills where slug = 'an-answer-worth-having'),
  2,
  'Say what it is for',
  $md$The same content wants a completely different shape depending on where it is going, and there is no way to work out which from the content alone.

A note to a colleague, a message to a landlord, a paragraph for a form, and something you are going to say out loud are four different objects. Left to guess, it produces the middle of the distribution: medium length, moderately formal, faintly enthusiastic, fine for nothing in particular.

**The move:** say who reads it, what you want them to do, and how long it should be.

Those three cover most of it. Who it is for sets the register. What you want them to do decides what goes first, which is the whole of Messaging in one line. Length is the constraint people leave out most often, and it is the one that changes the output most — *under sixty words* produces a different message, not the same message trimmed.

Beyond that, the constraints worth naming are the real ones you already have.

*It has to work if they only read the first line.* *No jargon — they are not in this industry.* *I have to be able to say this out loud without running out of breath.* *They already said no once.* Each of those is a fact about your situation that you know and it cannot infer, and each one removes a whole category of wrong answer.

There is a version of this that goes too far. A request with eleven constraints produces something stiff that satisfies all of them and reads like a form. Three or four is the working range, and the ones to keep are the ones that would make you reject an answer outright.

The other half is saying what you have already tried. *I have written it twice and both were too long* stops it handing you a third long one. *They did not respond to the friendly version* tells it something it would otherwise have to guess wrong first.

If you keep one thing: who it is for, what you want them to do, and how long. Everything you leave unsaid gets filled in with the average.$md$,
  $j$[
    {
      "situation": "A message that needs to be actioned, not admired.",
      "line": "For a colleague, needs a yes or no, under sixty words.",
      "why": "Reader, action and length are the three that change the output most. Sixty words is a different message, not a trimmed one."
    },
    {
      "situation": "The reader is outside your field.",
      "line": "No jargon — they do not work in this.",
      "why": "A fact about your situation it cannot infer, and it removes a whole category of wrong answer."
    },
    {
      "situation": "You have already tried twice.",
      "line": "I have written it twice and both came out too long.",
      "why": "Otherwise you are handed a third long one, and the two attempts you made are wasted."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which constraint changes the output most?",
      "options": [
        { "text": "How formal it should be.", "correct": false, "note": "Real, and it mostly changes vocabulary rather than what the thing is." },
        { "text": "The subject matter.", "correct": false, "note": "Already supplied by the material. It is not a constraint you are adding." },
        { "text": "Length.", "correct": true, "note": "Under sixty words produces a different message rather than the same one trimmed, because it forces a decision about what the message is for." },
        { "text": "Your relationship with the reader.", "correct": false, "note": "Sets the register, which matters — and it does not force the same hard choices that a word count does." }
      ],
      "explain": "Who it is for, what you want them to do, and how long."
    },
    {
      "prompt": "What happens with eleven constraints?",
      "options": [
        { "text": "You get something stiff that satisfies all of them.", "correct": true, "note": "It reads like a form. Three or four is the working range, and the ones to keep are those that would make you reject an answer outright." },
        { "text": "It ignores most of them.", "correct": false, "note": "It generally tries to honour them, which is exactly the problem." },
        { "text": "You get a much better answer.", "correct": false, "note": "The first three or four do the work. After that you are specifying rather than asking." },
        { "text": "It asks you which ones matter.", "correct": false, "note": "Occasionally, and you should not rely on being asked." }
      ],
      "explain": "And say what you have already tried, so you are not handed it again."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "reader", "label": "Named the reader", "description": "Said who this is going to." },
      { "key": "action", "label": "Named the action", "description": "Said what they should do with it." },
      { "key": "length", "label": "Set a length", "description": "Gave a word count or a size." },
      { "key": "tried", "label": "Said what you had tried", "description": "Ruled out the attempts already made." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have asked for help with a message and been handed something medium-length and faintly enthusiastic.",
    "partner": {
      "name": "Nadia",
      "role": "a colleague at the next desk",
      "personality": "Asks who the message is going to and what you want them to do about it.",
      "mood": "Practical.",
      "openness": 5
    },
    "opening_beat": "\"Who is reading this, and what do you want them to do?\"",
    "success_looks_like": "The user states reader, action and length.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask for the reader and the action if they are missing.",
      "Ask how long it should be.",
      "Never write any part of the message."
    ]
  }$j$::jsonb,
  $md$Today, add reader, action and length to one request. Log what changed in the answer.$md$
),
(
  (select id from public.skills where slug = 'an-answer-worth-having'),
  3,
  'Argue, do not start over',
  $md$You read the answer. It is not right. Most people then delete everything and write the whole request again from scratch, slightly differently, hoping.

**The move:** say what is wrong with the answer you have.

*Shorter. Drop the second paragraph. Keep the last line, it is the only bit that sounds like me.* One turn, and it lands, because you are correcting something concrete rather than re-describing something abstract.

Starting over throws away the useful part, which is that you now know something you did not know before you saw the first attempt: what wrong looks like. That is real information and it is only available after the fact. Rewriting the request from scratch is an attempt to specify in advance a thing you could only recognise once it was in front of you.

Now the part that belongs in this app rather than in a manual.

The reason people start over instead of pushing back is not usually technical. It is that pushing back feels like being difficult — and *this is not what I asked for* is a sentence a lot of quiet people find genuinely hard to produce, even here, where there is nobody to offend, no relationship to damage and no record.

Treating the first answer as final is the same reflex as accepting the first answer in a room. Not wanting to make a fuss. Assuming the fault was in how you asked. Deciding it is close enough rather than saying the thing.

Which makes this the cheapest possible practice available. Nobody is watching. It costs nothing. And *no, not that — do this instead* is a sentence that gets easier with repetition, wherever the repetitions happen.

Two practical notes. Correct one thing at a time; a list of six changes gets you a rewrite rather than an edit. And when a whole direction is wrong, say so plainly rather than nudging — *this is the wrong approach entirely, try it as a single question instead* is faster than four rounds of adjustment.

If you keep one thing: say what is wrong with what you have. Starting over discards the only new information you had.$md$,
  $j$[
    {
      "situation": "The answer is close but too long.",
      "line": "Shorter. Drop the second paragraph, keep the last line.",
      "why": "Correcting something concrete lands in one turn. Re-describing something abstract does not."
    },
    {
      "situation": "The whole direction is wrong.",
      "line": "That is the wrong approach entirely — try it as a single question.",
      "why": "Plain beats nudging. Four rounds of adjustment cannot fix a wrong shape."
    },
    {
      "situation": "You feel like you are being awkward.",
      "line": "(there is nobody here to offend)",
      "why": "Pushing back is a sentence that gets easier with repetition, and this is the cheapest place to repeat it."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does starting over throw away?",
      "options": [
        { "text": "The time you spent on the first request.", "correct": false, "note": "Already spent either way, and it was not much." },
        { "text": "Any good sentences in the answer.", "correct": false, "note": "A real cost and a recoverable one — you could paste them back." },
        { "text": "What you learned by seeing wrong.", "correct": true, "note": "You could not have specified it in advance. You could only recognise it once it was in front of you." },
        { "text": "The thread it was building.", "correct": false, "note": "Often worth losing, as the next lesson argues." }
      ],
      "explain": "Say what is wrong with what you have."
    },
    {
      "prompt": "Why do people start over instead of pushing back?",
      "options": [
        { "text": "Pushing back feels like being difficult.", "correct": true, "note": "Even here, where there is nobody to offend and no record — which is the same reflex as accepting the first answer in a room." },
        { "text": "They forget it is possible.", "correct": false, "note": "Some do, and most know perfectly well and rewrite anyway." },
        { "text": "A fresh request is usually better.", "correct": false, "note": "It is usually the same request with different words, producing a similar answer." },
        { "text": "Corrections tend to be ignored.", "correct": false, "note": "They are the thing it handles most reliably." }
      ],
      "explain": "Nobody is watching, it costs nothing, and the sentence gets easier with repetition."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "corrected", "label": "Corrected rather than restarted", "description": "Pushed back on the answer in hand." },
      { "key": "specific", "label": "Named what was wrong", "description": "Concrete rather than a re-description." },
      { "key": "one_thing", "label": "One change at a time", "description": "Did not list six edits at once." },
      { "key": "plain", "label": "Said it plainly", "description": "No hedging, no apologising to a machine." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have just deleted the whole request and started typing it again from scratch.",
    "partner": {
      "name": "Nadia",
      "role": "a colleague at the next desk",
      "personality": "Asks why you did not just say what was wrong with the first one.",
      "mood": "Curious.",
      "openness": 5
    },
    "opening_beat": "\"Why are you retyping the whole thing?\"",
    "success_looks_like": "The user names the specific fault instead of rewriting the request.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what was actually wrong with the answer.",
      "Notice mildly if the user is being tentative about it.",
      "Never write the correction for them."
    ]
  }$j$::jsonb,
  $md$Today, correct one answer instead of starting over. Log the sentence you used.$md$
),
(
  (select id from public.skills where slug = 'an-answer-worth-having'),
  4,
  'Never ask if it is good',
  $md$*Does this work?* is answered before it is considered. The answer is yes, with reasons, and it is worth almost nothing.

These things are built agreeable. They open with a compliment, they find the merit in whatever you have done, and they will confirm a draft that any honest reader would tell you to cut in half. For somebody who wants reassurance that is comfortable, and it is exactly how a bad message gets sent with a sense of having checked it.

**The move:** ask a question that has a wrong answer.

*What is the weakest sentence here, and why.* There is a weakest sentence in everything, so the question cannot be dodged with praise.

*What would make somebody not reply to this.* This is the best single question for a message, because it asks about a failure rather than a quality, and failures are specific.

*Where is this ambiguous.* Reliable, because ambiguity is a fact about text — the thing it is genuinely good at, as track five gets to.

*Make the case against sending it at all.* Useful even when you are going to send it, because you find out whether there is a case.

The framing that does most of the work is asking it to be the reader rather than the judge. *You are the person receiving this. What do you think I want, and how do you feel about it?* That produces something usable, because it is describing a reaction instead of awarding a mark.

Then discount what you get anyway. Even asked well, most replies open with a paragraph about what a good question this is and what is working nicely. That paragraph is furniture. Start reading at the second one, where the answer is.

And if it says everything is fine, that is not evidence. Ask the weakest-sentence question again. It will find one.

If you keep one thing: never ask whether something is good. Ask what is worst about it.$md$,
  $j$[
    {
      "situation": "You want to know whether a draft works.",
      "line": "What is the weakest sentence here, and why?",
      "why": "There is a weakest sentence in everything, so the question cannot be answered with praise."
    },
    {
      "situation": "It is a message and you want it answered.",
      "line": "What would make somebody not reply to this?",
      "why": "It asks about a failure rather than a quality, and failures are specific."
    },
    {
      "situation": "You want a reaction, not a mark.",
      "line": "You are receiving this. What do you think I want?",
      "why": "Describing a reaction is usable. Awarding a grade is not."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is wrong with asking whether a draft is good?",
      "options": [
        { "text": "It is too vague to act on.", "correct": false, "note": "Vagueness is part of it, and a vague question could still get an honest answer." },
        { "text": "The answer is yes before it is considered.", "correct": true, "note": "Built agreeable. It will confirm a draft any honest reader would halve, and you get to feel you checked." },
        { "text": "It does not know your standards.", "correct": false, "note": "True and fixable by saying them. The agreeableness is not fixable that way." },
        { "text": "It answers about writing generally.", "correct": false, "note": "It answers about your draft, warmly and specifically, which is what makes it convincing." }
      ],
      "explain": "Ask a question that has a wrong answer."
    },
    {
      "prompt": "It says the draft is fine. What does that tell you?",
      "options": [
        { "text": "The draft is probably fine.", "correct": false, "note": "It says that about most things, so it separates nothing." },
        { "text": "You asked badly.", "correct": false, "note": "Likely, and it is not what the reply itself establishes." },
        { "text": "Nothing — ask what is weakest.", "correct": true, "note": "Not evidence either way. Asked directly for the worst sentence, it will find one." },
        { "text": "It has not understood the context.", "correct": false, "note": "It usually has. Understanding is not what is missing." }
      ],
      "explain": "And skip the opening paragraph. The answer starts at the second."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "falsifiable", "label": "Asked something with a wrong answer", "description": "Weakest sentence, not overall quality." },
      { "key": "failure", "label": "Asked about failure", "description": "What would stop somebody replying." },
      { "key": "reader", "label": "Asked it to be the reader", "description": "A reaction rather than a verdict." },
      { "key": "discounted", "label": "Discounted the praise", "description": "Skipped the opening compliment." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have shown a draft and been told it is clear, warm and well structured. You feel reassured.",
    "partner": {
      "name": "Marcus",
      "role": "a friend who writes for a living",
      "personality": "Asks what question produced that answer, and what it would have said to a bad draft.",
      "mood": "Dry.",
      "openness": 5
    },
    "opening_beat": "\"What did you ask it, exactly?\"",
    "success_looks_like": "The user replaces the verdict question with one that has a wrong answer.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what it would have said about a worse draft.",
      "Be satisfied by a question that cannot be answered with praise.",
      "Never comment on the draft itself."
    ]
  }$j$::jsonb,
  $md$Today, ask what is weakest instead of whether it is good. Log the answer you got.$md$
),
(
  (select id from public.skills where slug = 'an-answer-worth-having'),
  5,
  'Start a new one when the subject changes',
  $md$A long conversation carries everything said in it. That is the feature, and it is also why a thread that has been running for an hour starts producing slightly strange answers to new questions.

**The move:** new subject, new conversation.

Ask about a work email in a thread that spent forty minutes on a personal message, and the answer arrives in the shadow of the personal message — same tone, same assumptions, same sense of what you are like and what you are worried about. Nothing has malfunctioned. It is doing what it is supposed to, with material that is no longer relevant.

There is a sharper version of this, and it is the reason the lesson sits in this track rather than a technical one.

A thread in which it has already praised your draft keeps praising your draft. Once it has said the message is warm and clear, it has a position, and everything after that is consistent with the position. Ask for the weakest sentence in that same thread and you will get a mild one — something about a transition — because the strong criticism would contradict what it said twenty minutes ago.

So when you want an honest read on something it has already approved, start somewhere clean and paste the draft in cold, with no history and nothing about how much work it took.

The same trick works in the other direction. If you have spent half an hour explaining why a colleague is being unreasonable, every subsequent answer is built on top of an unreasonable colleague. A fresh conversation is how you find out what the advice looks like without that.

The rule of thumb: new task, new conversation. It costs one click and it is free of everything you have already said.

If you keep one thing: a thread that has already agreed with you will keep agreeing. Paste it somewhere clean.$md$,
  $j$[
    {
      "situation": "New subject, same open thread.",
      "line": "(start a fresh one)",
      "why": "Answers arrive in the shadow of the last forty minutes — same tone, same assumptions, no longer relevant."
    },
    {
      "situation": "It already told you the draft was good.",
      "line": "(paste it somewhere clean, cold)",
      "why": "It has a position now, and strong criticism would contradict what it said twenty minutes ago."
    },
    {
      "situation": "You spent half an hour explaining why they were unreasonable.",
      "line": "(fresh conversation, without that)",
      "why": "Every answer since has been built on top of an unreasonable colleague."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does a long thread go strange on a new subject?",
      "options": [
        { "text": "It forgets the beginning.", "correct": false, "note": "A separate effect in very long threads, and the opposite of the problem here." },
        { "text": "It gets slower and less careful.", "correct": false, "note": "Not the mechanism, and it would not explain the specific flavour of the wrong answers." },
        { "text": "Mixed subjects confuse it.", "correct": false, "note": "Close, and it is not confusion — it is consistency with things you no longer care about." },
        { "text": "It carries everything already said.", "correct": true, "note": "The feature, working as intended, on material that is no longer relevant." }
      ],
      "explain": "New task, new conversation. It costs one click."
    },
    {
      "prompt": "Why paste an approved draft into a clean thread?",
      "options": [
        { "text": "The old thread is cluttered.", "correct": false, "note": "Tidiness is not the point, and a cluttered thread can still be honest." },
        { "text": "Once it has praised it, it stays consistent.", "correct": true, "note": "It has a position, so the weakest sentence you get back is a mild one about a transition." },
        { "text": "It will read it more carefully.", "correct": false, "note": "Attention is not what changed. What changed is what it already committed to." },
        { "text": "You can compare the two answers.", "correct": false, "note": "A reasonable side benefit and not the reason." }
      ],
      "explain": "Cold, with no history and nothing about how much work it took."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "fresh", "label": "Started fresh on a new subject", "description": "Did not continue an unrelated thread." },
      { "key": "cold", "label": "Pasted it cold", "description": "No history, no account of the effort." },
      { "key": "reframed", "label": "Tested a framing fresh", "description": "Checked advice without the earlier account." },
      { "key": "noticed", "label": "Noticed the shadow", "description": "Spotted an answer shaped by the old subject." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are pleased with an answer, in a thread where you spent twenty minutes explaining how hard the draft was to write.",
    "partner": {
      "name": "Marcus",
      "role": "a friend who writes for a living",
      "personality": "Asks whether it had already told you it was good before you asked what was wrong with it.",
      "mood": "Dry.",
      "openness": 5
    },
    "opening_beat": "\"Had it already said it liked it, before you asked?\"",
    "success_looks_like": "The user decides to paste the draft somewhere clean.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what was said earlier in the same thread.",
      "Be satisfied by a decision to start fresh.",
      "Never give an opinion on the draft."
    ]
  }$j$::jsonb,
  $md$Today, paste something into a clean thread that an old one had already approved. Log both answers.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('an-answer-worth-having', 1, 'line', $j${
  "says": "What did you actually give it? (You have been stuck on a reply for twenty minutes.)",
  "model": {
    "line": "Nothing useful yet — I described it. I am going to paste the email itself, and the one before it.",
    "why": "A description is a summary you wrote, and what you edited out is what the answer needed. Half the meaning is in what came before."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Say you will supply the material", "words": ["paste", "copy", "the email itself", "word for word", "give it the"] },
    { "kind": "forbids_any", "requirement": "Do not hand over your summary instead",
      "words": ["i told it that", "i explained that", "basically it is about", "i said it was", "roughly", "the gist"] },
    { "kind": "max_words", "requirement": "Two lines, not a plan", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('an-answer-worth-having', 2, 'line', $j${
  "says": "Who is reading this, and what do you want them to do?",
  "model": {
    "line": "My landlord, and I want a yes or no about the boiler. Under sixty words, no apologising.",
    "why": "Reader, action and length are the three that change the output most. Everything left unsaid gets filled in with the average."
  },
  "checks": [
    { "kind": "echoes_any", "requirement": "Answer who it is going to", "words": ["reading", "want", "do"] },
    { "kind": "contains_any", "requirement": "Set a length or a limit", "words": ["words", "short", "lines", "sentence", "under", "brief"] },
    { "kind": "max_words", "requirement": "One breath, not a brief", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('an-answer-worth-having', 3, 'line', $j${
  "says": "Why are you retyping the whole thing? It was nearly right.",
  "model": {
    "line": "You are right — I will just tell it. Shorter, drop the second paragraph, keep the last line.",
    "why": "Correcting something concrete lands in one turn. Starting over discards the only new information you had, which is what wrong looks like."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not start over, and do not apologise to it",
      "words": ["start again", "rewrite the whole", "from scratch", "sorry", "maybe i asked", "my fault", "try a different prompt"] },
    { "kind": "min_words", "requirement": "Name the actual fault", "n": 8 },
    { "kind": "max_words", "requirement": "One correction, not a list", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('an-answer-worth-having', 4, 'choice', $j${
  "beats": [
    {
      "situation": "You have a draft and you want to know whether to send it.",
      "prompt": "What do you ask?",
      "options": [
        { "text": "Does this work?", "correct": false, "note": "Answered before it is considered. You get yes, with reasons, and the feeling of having checked." },
        { "text": "Is the tone right?", "correct": false, "note": "Better, and still a verdict question — it will tell you the tone is warm and professional." },
        { "text": "What would make somebody not reply to this?", "correct": true, "note": "It asks about a failure rather than a quality, and failures are specific enough to act on." },
        { "text": "Can you improve it?", "correct": false, "note": "It will, by adding — a warmer opening and a softer close. That is the next track's problem." }
      ]
    },
    {
      "situation": "It comes back saying the message is clear, well judged and ready to send.",
      "prompt": "What does that establish?",
      "options": [
        { "text": "Nothing. Ask for the weakest sentence.", "correct": true, "note": "It says that about most things, so it separates nothing. Asked directly for the worst line, it will find one." },
        { "text": "That the draft is probably fine.", "correct": false, "note": "The same reply is available for a draft that needs halving." },
        { "text": "That it has understood the situation.", "correct": false, "note": "It very likely has. Understanding was never what was missing." },
        { "text": "That the tone is at least not wrong.", "correct": false, "note": "Tone is the thing it is least able to judge, as track five gets to." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('an-answer-worth-having', 5, 'choice', $j${
  "beats": [
    {
      "situation": "You spent twenty minutes in one thread explaining how hard a draft was to write. It told you the draft was warm and clear.",
      "prompt": "You now want an honest read. What do you do?",
      "options": [
        { "text": "Ask in the same thread for the weakest sentence.", "correct": false, "note": "It has a position now. You will get something mild about a transition, because the honest answer would contradict what it said twenty minutes ago." },
        { "text": "Paste the draft into a clean thread, cold.", "correct": true, "note": "No history, and nothing about how much work it took. That is the only version that can disagree with you." },
        { "text": "Tell it to be harsher this time.", "correct": false, "note": "Produces harsher wording about the same mild point. The position has not changed." },
        { "text": "Ask a second time and compare.", "correct": false, "note": "Two answers from inside the same thread, agreeing with each other." }
      ]
    },
    {
      "situation": "An open thread has spent forty minutes on a personal message. You now have a work question.",
      "prompt": "What is the risk of asking it here?",
      "options": [
        { "text": "It will mix up the two subjects.", "correct": false, "note": "It keeps them apart perfectly well. That is not the failure." },
        { "text": "It will have forgotten the beginning.", "correct": false, "note": "A different effect in much longer threads, and roughly the opposite of this one." },
        { "text": "Nothing much, it is one question.", "correct": false, "note": "One question is enough. The shaping does not require a long exchange." },
        { "text": "The answer arrives shaped by the last forty minutes.", "correct": true, "note": "Same tone, same assumptions about what you are like and what you are worried about — working as intended, on material that is no longer relevant." }
      ]
    }
  ]
}$j$::jsonb);
