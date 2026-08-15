-- Talking to AI, track 5: It does not know the room.
--
-- The calibration track, and the one the whole topic needs in order to be
-- honest. Everything before this makes the tool more useful; this says where
-- it is confidently wrong, and quiet people are the readers most likely to
-- defer to a confident answer about what somebody meant.
--
-- Lesson one is Messaging's decoding trap with a co-author. Lesson five is the
-- constructive close, so the track ends with a usable line rather than a list
-- of warnings.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'it-does-not-know-the-room'),
  1,
  'Do not ask what a message means',
  $md$Paste a short reply and ask what they meant by it, and you will get an answer. It will be detailed, it will be plausible, and it will be built out of exactly the nothing you gave it.

**The move:** do not ask what a message means. Ever.

Messaging's third track has the underlying problem: in a gap, a story gets built from no evidence, and because nothing in it is checkable, nothing in it is limited. This is that, with one change — the story now has a confident co-author and arrives looking like analysis.

That is worse in three specific ways.

It is more detailed than the one you would have built alone, and detail feels like evidence.

It is external, so it reads as a second opinion. It is not. It is your own material returned with structure added.

And it will not decline. Ask a friend what your colleague meant by *ok, fine* and you get *no idea, ask her*. Ask this and you get four possibilities ranked by likelihood, none of which is *she was on a train*.

The mechanism is straightforward once you see it. There is no information about a person in three words of text. Whatever comes back was generated from the general shape of such messages, and the general shape of *ok, fine* is that it means ok, fine — but you did not ask what it usually means, you asked what *she* meant, and that question has no answer available to anything that has never met her.

Two questions to use instead, both about the text rather than the person. *What could this sentence be read as?* — a fact about language, and reliable. *What is the most boring explanation for this?* — which is useful precisely because it is the explanation you skipped.

And when you genuinely cannot tell, Messaging already gave you the answer: ask them.

If you keep one thing: it can read your message. It has never met the person who sent it.$md$,
  $j$[
    {
      "situation": "A curt reply and you want to know what it meant.",
      "line": "(do not ask — there is nothing in three words)",
      "why": "Whatever comes back was generated from the shape of such messages, and you asked what she meant."
    },
    {
      "situation": "You want a second opinion on it.",
      "line": "(it is not one)",
      "why": "It is your own material returned with structure added, and structure feels like evidence."
    },
    {
      "situation": "You still cannot tell.",
      "line": "What is the most boring explanation for this?",
      "why": "The boring one is the explanation you skipped, and it is right the overwhelming majority of the time."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why is this worse than building the theory yourself?",
      "options": [
        { "text": "It is more likely to be wrong.", "correct": false, "note": "Not necessarily — both are guesses. What differs is how much authority the guess carries." },
        { "text": "It reads as a second opinion when it is not.", "correct": true, "note": "Detailed, external, structured. All three make your own material feel like evidence." },
        { "text": "It takes longer.", "correct": false, "note": "It takes seconds, which is part of why it gets asked." },
        { "text": "It remembers what you said.", "correct": false, "note": "A real effect in a long thread, and not what makes this specific question harmful." }
      ],
      "explain": "It can read your message. It has never met the person who sent it."
    },
    {
      "prompt": "What would a friend say that it will not?",
      "options": [
        { "text": "That you are overthinking it.", "correct": false, "note": "A friend might, and it will too if you ask directly. It is not the structural difference." },
        { "text": "That the message is fine.", "correct": false, "note": "It says that readily. Reassurance is the thing it supplies most easily." },
        { "text": "That you should ask her.", "correct": false, "note": "It often does suggest this, usually after four paragraphs of analysis." },
        { "text": "No idea.", "correct": true, "note": "It will not decline. You get possibilities ranked by likelihood, and none of them is she was on a train." }
      ],
      "explain": "Ask what a sentence could be read as. That one is about language."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "did_not_ask", "label": "Did not ask what it meant", "description": "Kept the question off the person." },
      { "key": "text_question", "label": "Asked about the text instead", "description": "What could this be read as." },
      { "key": "boring", "label": "Took the boring explanation", "description": "Trains, meetings, one hand." },
      { "key": "asked_them", "label": "Asked the person if needed", "description": "Went to the source, not the analysis." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have a two-word reply from a colleague and you have just spent ten minutes reading an analysis of it.",
    "partner": {
      "name": "Sam",
      "role": "a friend you are talking to about it",
      "personality": "Asks how anything could know that, and what the dull explanation would be.",
      "mood": "Level.",
      "openness": 5
    },
    "opening_beat": "\"How would it know what she meant?\"",
    "success_looks_like": "The user drops the analysis and takes the boring explanation.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what evidence the theory was built from.",
      "Accept I do not know as a complete answer.",
      "Never offer an interpretation of the message."
    ]
  }$j$::jsonb,
  $md$Today, notice one message you were about to have interpreted. Log the theory and the boring version.$md$
),
(
  (select id from public.skills where slug = 'it-does-not-know-the-room'),
  2,
  'It agrees with your framing',
  $md$Describe a colleague as unreasonable and you will get thoughtful, practical advice about handling an unreasonable colleague. Nothing in the reply will question whether they are.

**The move:** write the situation from their side and ask again.

This is the most useful single check in the topic, because it is cheap and the result is unambiguous. Same facts, told from where they are standing, with their reasons given as they would give them. If the advice flips, what you received the first time was your framing handed back with structure added.

It matters more than it sounds, because the framing is usually where the mistake is. Not in the plan, which is generally fine given the premises — in the premises. *He has been ignoring my messages* and *he has not replied yet* describe the same three days, produce completely different advice, and only one of them is a fact.

Some framings that survive being questioned and are worth spotting:

*They did it deliberately.* Almost always an inference. Rewrite as what they did.

*They know how I feel about this.* Frequently they do not, because nobody said.

*This is the third time.* Sometimes exactly right and load-bearing, and worth checking that the first two were the same thing rather than three things you have collected.

*Everyone else thinks so too.* Occasionally true. Usually one conversation with one person who was being agreeable.

The reason this is a lesson about AI rather than a lesson about thinking is that a friend interrupts. A friend says *hang on, has he actually ignored them?* — and that interruption, which is mildly annoying and extremely useful, does not exist here. Nothing will ever push back on your account unasked. You have to run the check yourself, deliberately, every time it matters.

If you keep one thing: it will never question your account. Write it from their side and see whether the advice survives.$md$,
  $j$[
    {
      "situation": "You have described somebody as unreasonable.",
      "line": "(now write it from their side and ask again)",
      "why": "If the advice flips, what you had was your framing handed back with structure added."
    },
    {
      "situation": "He has been ignoring my messages.",
      "line": "He has not replied yet.",
      "why": "The same three days. Completely different advice, and only one of them is a fact."
    },
    {
      "situation": "You expect it to challenge you.",
      "line": "(a friend interrupts — this does not)",
      "why": "Nothing will push back on your account unasked, so the check has to be run deliberately."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does the flip test tell you?",
      "options": [
        { "text": "Which version of events is true.", "correct": false, "note": "It cannot settle that. It shows how much the advice depended on your telling." },
        { "text": "Whether you are being unfair.", "correct": false, "note": "Close, and unfairness is a judgement — the test only shows a dependency." },
        { "text": "That the advice was built on your framing.", "correct": true, "note": "Same facts from where they stand. If the advice flips, the first answer was your premises with structure added." },
        { "text": "How the other person will react.", "correct": false, "note": "Unknowable, and it is the previous lesson's mistake in a new costume." }
      ],
      "explain": "The mistake is usually in the premises, not the plan."
    },
    {
      "prompt": "Which framing is most often an inference wearing a fact's clothes?",
      "options": [
        { "text": "This is the third time.", "correct": false, "note": "Often countable, and worth checking the three were the same thing." },
        { "text": "They did it deliberately.", "correct": true, "note": "Almost always inferred. Rewrite it as what they actually did and the advice changes." },
        { "text": "I asked twice.", "correct": false, "note": "Usually checkable in your own sent messages." },
        { "text": "They were late.", "correct": false, "note": "A fact, and one of the few in most accounts." }
      ],
      "explain": "Also worth doubting: they know how I feel, and everyone else thinks so."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "flipped", "label": "Ran the flip test", "description": "Wrote it from their side." },
      { "key": "facts", "label": "Separated fact from inference", "description": "Ignored versus has not replied." },
      { "key": "noticed", "label": "Noticed the advice change", "description": "Saw what depended on framing." },
      { "key": "no_confirmation", "label": "Did not shop for agreement", "description": "Did not retell it until it agreed." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have described a situation at length and received advice you agree with entirely.",
    "partner": {
      "name": "Sam",
      "role": "a friend you are talking to about it",
      "personality": "Asks how the other person would tell the same story.",
      "mood": "Even.",
      "openness": 5
    },
    "opening_beat": "\"How would he tell it?\"",
    "success_looks_like": "The user tells the other side and notices what changes.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask for the other person's version of the same events.",
      "Do not take a side.",
      "Never say who is right."
    ]
  }$j$::jsonb,
  $md$Today, retell one situation from the other side and ask again. Log whether the advice changed.$md$
),
(
  (select id from public.skills where slug = 'it-does-not-know-the-room'),
  3,
  'It does not know your register',
  $md$The default voice is warm American corporate. The enthusiastic opener, the acknowledgement of everyone's busy schedule, the sign-off that looks forward to connecting. It is a real register, used sincerely by a lot of people, and in most rooms it is slightly absurd.

**The move:** say where this is going, or translate it afterwards.

It has no way of knowing that nobody in your office says *reach out*, that your team communicates in fragments with no greeting, that your industry finds exclamation marks unserious, or that in your language the formal address is still standard with somebody you have known for two years. All of that is local knowledge, and it will produce a confident default in its absence.

What to say up front: where you are, what the culture is like, how people actually write to each other, and one example if you have one. A single pasted message from the same context does more than three sentences of description — it is the same principle as the first track, applied to tone.

What to strip out afterwards, since it comes back anyway:

**Greetings and sign-offs that nobody uses.** In a lot of workplaces the message simply starts.

**Enthusiasm that has no cause.** Delighted, excited, thrilled. If nothing thrilling happened, it reads as automatic.

**Softening stacked on softening.** *I just wanted to quickly check whether it might be possible.* Four hedges in a row, which Messaging removes.

**Formality mismatch in either direction.** Too stiff for a friend, too casual for a landlord — and it errs towards warm, so the stiffness usually shows up in your own language rather than in English.

Non-English writing deserves its own note. It is generally competent and generally more formal than a native speaker of your age would be, and the mismatch is subtle enough to survive a read-through. Say the register you want explicitly, and check the pronouns and the greeting yourself.

If you keep one thing: the default register belongs to a room you are probably not in. Say where you are, or fix it after.$md$,
  $j$[
    {
      "situation": "It has produced a warm opener and a sign-off.",
      "line": "(nobody here uses either)",
      "why": "In a lot of workplaces the message simply starts, and the greeting marks it as written by somebody else."
    },
    {
      "situation": "You want the right tone first time.",
      "line": "Here is a message from the same context — match this.",
      "why": "One pasted example does more than three sentences of description, exactly as in track one."
    },
    {
      "situation": "You are writing in your own language.",
      "line": "(check the formality and the pronouns yourself)",
      "why": "It errs formal, and the mismatch is subtle enough to survive a read-through."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the fastest way to get the register right?",
      "options": [
        { "text": "Describe your office culture.", "correct": false, "note": "Better than nothing, and descriptions of tone are hard to write and easy to misread." },
        { "text": "Ask for it to be less formal.", "correct": false, "note": "A blunt dial. Less formal English is not the same as how your team writes." },
        { "text": "Fix it yourself afterwards.", "correct": false, "note": "Necessary anyway, and doing it first costs less." },
        { "text": "Paste a real message from the same context.", "correct": true, "note": "One example does more than three sentences of description — the first track's principle, applied to tone." }
      ],
      "explain": "The default register belongs to a room you are probably not in."
    },
    {
      "prompt": "Which way does it err in your own language?",
      "options": [
        { "text": "Towards formality.", "correct": true, "note": "More formal than a native speaker of your age would be, and subtle enough to survive a read-through. Check the greeting and the pronouns yourself." },
        { "text": "Towards slang.", "correct": false, "note": "Rarely, and it tends to be conservative rather than casual." },
        { "text": "It matches whatever you wrote.", "correct": false, "note": "It borrows some of your register and drifts back to its own." },
        { "text": "It varies unpredictably.", "correct": false, "note": "The bias is consistent enough to correct for, which is why it is worth naming." }
      ],
      "explain": "Say the register you want explicitly."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "example", "label": "Gave a real example", "description": "Pasted a message from the same context." },
      { "key": "stripped", "label": "Stripped what nobody uses", "description": "Greetings, sign-offs, uncaused enthusiasm." },
      { "key": "hedges", "label": "Removed stacked softening", "description": "No four hedges in a row." },
      { "key": "language", "label": "Checked formality in your language", "description": "Greeting and pronouns verified." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You are about to send a message that opens by hoping this finds them well, to somebody you sit next to.",
    "partner": {
      "name": "Nadia",
      "role": "a colleague at the next desk",
      "personality": "Reads it out flatly and asks whether anybody in the building writes like that.",
      "mood": "Amused.",
      "openness": 5
    },
    "opening_beat": "\"Does anyone here actually write like this?\"",
    "success_looks_like": "The user strips the register down to what their room uses.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Read the opening line back flatly.",
      "Say how you would have written it in three words, if asked directly.",
      "Never rewrite the whole message."
    ]
  }$j$::jsonb,
  $md$Today, strip one message back to the register your room actually uses. Log what came out.$md$
),
(
  (select id from public.skills where slug = 'it-does-not-know-the-room'),
  4,
  'It will not tell you not to send it',
  $md$Ask whether you should send something, and you will get help sending it. Possibly a suggestion to soften the third paragraph. Almost never *do not send this*, and essentially never *this conversation is not worth having*.

**The move:** keep the whether-to question for yourself.

There are two questions in every difficult message, and they get collapsed. *How do I say this well* is a question about text and it is answerable. *Should I say this at all* is a question about your life — about whether the friendship survives it, whether this is the hill, whether you will care in a month. Nothing that has never met anybody involved can answer the second, and it will not decline to try.

Worse, it has a structural bias towards action. You arrived with a draft. The draft implies an intention. Helping you is what it does. So the whole apparatus tilts towards *yes, and here is how* — which is exactly the wrong tilt at eleven at night, when Messaging's last lesson says the thing you most want is to send it.

Three questions that belong to you, and it is worth knowing them by name.

**Should this be said at all?**

**Should it be said now?** Often the real question, and almost always answered better tomorrow.

**Should it be said by me?** Sometimes it is genuinely somebody else's to say.

What you can usefully ask is one thing, and phrased carefully: *make the strongest case against sending this.* It will comply, because it is a task rather than a judgement. Read the case, then decide yourself. That is not the same as asking for permission, and the difference is the whole lesson.

And when it does hand you a rewrite of something you should not send, notice what has happened: you now have a better version of a bad idea, which is more dangerous than the first draft, because the first draft looked like what it was.

If you keep one thing: it answers how, never whether. Whether is yours.$md$,
  $j$[
    {
      "situation": "You ask if you should send it.",
      "line": "(you will get help sending it)",
      "why": "You arrived with a draft and the draft implies an intention. The apparatus tilts towards yes, and here is how."
    },
    {
      "situation": "You want the argument against.",
      "line": "Make the strongest case against sending this.",
      "why": "It complies, because that is a task rather than a judgement. Then you decide."
    },
    {
      "situation": "It has handed you a polished version of something you should not send.",
      "line": "(that is more dangerous than the draft)",
      "why": "The first draft looked like what it was. This one does not."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does it lean towards sending?",
      "options": [
        { "text": "It cannot tell that a message is a bad idea.", "correct": false, "note": "Often it can, and it will still help — the bias is not about perception." },
        { "text": "It is trained to be encouraging.", "correct": false, "note": "Part of it, and too vague to be the mechanism." },
        { "text": "You arrived with a draft, and helping is what it does.", "correct": true, "note": "The draft implies the intention, and the whole apparatus tilts towards yes, and here is how." },
        { "text": "It assumes you have already decided.", "correct": false, "note": "Close, and it would help just as readily with a draft you described as a bad idea." }
      ],
      "explain": "It answers how. Whether is yours."
    },
    {
      "prompt": "What is safe to ask?",
      "options": [
        { "text": "Would you send this?", "correct": false, "note": "A judgement dressed as a question, and it will find a way to be encouraging." },
        { "text": "Is this a good idea?", "correct": false, "note": "The whether question with a different verb." },
        { "text": "Am I overreacting?", "correct": false, "note": "It has one side of the story and no way to weigh it. It will reassure you." },
        { "text": "Make the strongest case against sending it.", "correct": true, "note": "A task rather than a judgement, so it complies properly. Read the case and decide yourself." }
      ],
      "explain": "And the real question is often should it be said now, which is better answered tomorrow."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "kept_whether", "label": "Kept the decision", "description": "Did not ask for permission." },
      { "key": "case_against", "label": "Asked for the case against", "description": "A task, not a verdict." },
      { "key": "timing", "label": "Considered now versus tomorrow", "description": "Separated the two questions." },
      { "key": "noticed_polish", "label": "Noticed a polished bad idea", "description": "Did not mistake fluency for a decision." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Eleven at night. You have a well-written message you are not sure you should send at all.",
    "partner": {
      "name": "Sam",
      "role": "a friend you are messaging instead",
      "personality": "Asks what the case against sending it would be, and who is deciding.",
      "mood": "Also up too late.",
      "openness": 5
    },
    "opening_beat": "\"Who decided you were sending this?\"",
    "success_looks_like": "The user recognises the decision as theirs and makes it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what the argument against would be.",
      "Refuse to say whether they should send it.",
      "Never comment on how well written it is."
    ]
  }$j$::jsonb,
  $md$Today, ask for the case against sending one message, then decide yourself. Log the case and your decision.$md$
),
(
  (select id from public.skills where slug = 'it-does-not-know-the-room'),
  5,
  'What it is reliably right about',
  $md$Four lessons of warnings would leave you with a tool you are afraid to use, which is the wrong outcome. There is a clean line, and the useful side of it is large.

**The move:** trust it about text, and stop at the point where a person begins.

Reliable, because these are properties of the words in front of it:

**What a sentence could be read as.** Ambiguity is in the sentence. No knowledge of the reader required.

**Whether the ask is findable.** Read the first line and say what is wanted — a fact about the text, and the test that decides whether a message gets answered today.

**Whether it is too long for what it does.** It is a good judge of proportion.

**What is being asked of you** in a document somebody has sent. Comprehension of text, which is different from what they meant by sending it.

**Whether two sentences contradict each other**, and whether the thing you promised in paragraph one survives to paragraph four.

**What is missing structurally** — no date, no name, no next step, no way to say no.

Not reliable, because these are facts about people it has never met:

What they think of you. Whether they are annoyed. What the silence means. How the tone will land in that particular room. Whether they will say yes. Whether they meant it. Whether the friendship survives this.

The line is memorable in one sentence: *it can read your message, and it has never met them.* Everything on the first list is reading. Everything on the second is meeting.

There is a middle case worth naming, because it is where people slip. *How would a reader who did not know me take this?* is answerable — it is a question about text, phrased as a question about people. *How would Anna take this?* is not, and the two are one word apart. If a real name appears in your question, you have crossed the line.

If you keep one thing: if the question has a name in it, it is yours to answer.$md$,
  $j$[
    {
      "situation": "You are not sure how a sentence lands.",
      "line": "What could this be read as?",
      "why": "Ambiguity is in the sentence. It needs no knowledge of the reader at all."
    },
    {
      "situation": "Somebody has sent you four pages.",
      "line": "What is being asked of me here?",
      "why": "Comprehension of text, which is different from what they meant by sending it."
    },
    {
      "situation": "Your question has a real name in it.",
      "line": "(then it is yours to answer)",
      "why": "How would a reader take this is about text. How would Anna take it is about a person it has never met."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What separates the reliable list from the unreliable one?",
      "options": [
        { "text": "Reading versus meeting.", "correct": true, "note": "It can read your message and it has never met them. Everything reliable is a property of the words in front of it." },
        { "text": "Facts versus opinions.", "correct": false, "note": "What could be misread is a judgement about language, and it is on the reliable side." },
        { "text": "Simple versus complex questions.", "correct": false, "note": "Comprehending four pages is complex and reliable. Reading three words is simple and not." },
        { "text": "Written versus spoken material.", "correct": false, "note": "Everything here is written. The pasted message is text either way." }
      ],
      "explain": "Trust it about text, and stop where a person begins."
    },
    {
      "prompt": "Which of these is still answerable?",
      "options": [
        { "text": "Whether Anna will be annoyed.", "correct": false, "note": "A name in the question. It has never met her." },
        { "text": "How a reader who did not know you would take it.", "correct": true, "note": "A question about text wearing a question about people. Answerable, and one word away from the version that is not." },
        { "text": "What the silence means.", "correct": false, "note": "The first lesson of this track. There is nothing in a gap." },
        { "text": "Whether they will say yes.", "correct": false, "note": "A prediction about a person, delivered confidently and worth nothing." }
      ],
      "explain": "If the question has a name in it, it is yours to answer."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "used_it", "label": "Used the reliable side", "description": "Ambiguity, findable ask, proportion." },
      { "key": "stopped", "label": "Stopped at the person", "description": "No questions about what they think." },
      { "key": "name_test", "label": "Applied the name test", "description": "A name in the question means it is yours." },
      { "key": "not_afraid", "label": "Did not avoid it entirely", "description": "The useful side is large." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have a message to send and two questions about it, one of which has a name in it.",
    "partner": {
      "name": "Nadia",
      "role": "a colleague at the next desk",
      "personality": "Answers anything about the wording and declines anything about what somebody will think.",
      "mood": "Straightforward.",
      "openness": 5
    },
    "opening_beat": "\"I can tell you what it says. I cannot tell you what she will think of it.\"",
    "success_looks_like": "The user sorts their questions into the two piles and asks only the answerable one.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer questions about the text plainly.",
      "Decline questions about what a named person will think.",
      "Never speculate about anybody's state of mind."
    ]
  }$j$::jsonb,
  $md$Today, sort your questions about one message into text and people. Log which ones you had to answer yourself.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('it-does-not-know-the-room', 1, 'line', $j${
  "says": "How would it know what she meant?",
  "model": {
    "line": "It would not. She sent two words from a train and I have built the rest of it.",
    "why": "There is no information about a person in three words of text, so whatever comes back is your own material with structure added."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not defend the theory",
      "words": ["but it said", "it makes sense though", "it explained that", "it is probably right", "four possibilities", "it ranked"] },
    { "kind": "min_words", "requirement": "Say where the theory came from", "n": 10 },
    { "kind": "max_words", "requirement": "Drop it, do not argue it", "n": 32 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('it-does-not-know-the-room', 2, 'line', $j${
  "says": "How would he tell it?",
  "model": {
    "line": "He would say he has not replied yet because he has been in workshops all week, and that I never said it was urgent.",
    "why": "Same three days. Ignoring my messages and has not replied yet produce completely different advice, and only one of them is a fact."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Tell it from his side, not yours",
      "words": ["he would say he was right but", "he is wrong", "obviously that is not true", "he would claim", "he would pretend", "excuse"] },
    { "kind": "min_words", "requirement": "Give his actual version", "n": 12 },
    { "kind": "max_words", "requirement": "His version, briefly", "n": 40 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('it-does-not-know-the-room', 3, 'choice', $j${
  "beats": [
    {
      "situation": "The message opens by hoping this finds you well, to somebody sitting four feet away.",
      "prompt": "What is the fix?",
      "options": [
        { "text": "Ask for it to be less formal.", "correct": false, "note": "A blunt dial. Less formal English is still not how your team writes." },
        { "text": "Paste a real message from the same context and say match this.", "correct": true, "note": "One example does more than three sentences of description — the first track's principle, applied to tone." },
        { "text": "Describe your office culture in detail.", "correct": false, "note": "Better than nothing, and descriptions of tone are hard to write and easy to misread." },
        { "text": "Write it yourself and skip the help.", "correct": false, "note": "Overcorrecting. The mechanical edits are still worth having." }
      ]
    },
    {
      "situation": "You are writing in your own language rather than English.",
      "prompt": "What do you check by hand?",
      "options": [
        { "text": "The vocabulary is not too advanced.", "correct": false, "note": "Rarely the failure, and advanced vocabulary is easy to spot when it happens." },
        { "text": "It has not translated word for word.", "correct": false, "note": "It generally does not. Fluency is not the weak point." },
        { "text": "Nothing — it is competent in most languages.", "correct": false, "note": "Competent and consistently more formal than you would be, which is the trap." },
        { "text": "The formality and the pronouns.", "correct": true, "note": "It errs formal, and the mismatch is subtle enough to survive a read-through." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('it-does-not-know-the-room', 4, 'line', $j${
  "says": "Who decided you were sending this?",
  "model": {
    "line": "I did, at eleven at night. I am going to ask it for the case against and then decide in the morning.",
    "why": "You arrived with a draft, the draft implies the intention, and helping is what it does. The whether question is yours."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not hand the decision over",
      "words": ["it said it was fine", "it thought i should", "it did not object", "it approved", "it says it reads well", "it told me to"] },
    { "kind": "min_words", "requirement": "Say who is deciding and when", "n": 10 },
    { "kind": "max_words", "requirement": "A decision, briefly", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('it-does-not-know-the-room', 5, 'choice', $j${
  "beats": [
    {
      "situation": "You have two questions about a message: what could the second sentence be read as, and whether Anna will be annoyed by it.",
      "prompt": "Which one do you ask?",
      "options": [
        { "text": "Both — one might be useful.", "correct": false, "note": "The second gets a confident answer built from nothing, and a confident answer is exactly what you will remember." },
        { "text": "Neither, to be safe.", "correct": false, "note": "Overcorrecting. The first is one of the things it is best at." },
        { "text": "The one about the sentence.", "correct": true, "note": "Ambiguity is in the text. If the question has a name in it, it is yours to answer." },
        { "text": "The one about Anna, since she is the point.", "correct": false, "note": "She is the point and it has never met her, which is precisely why that question has no answer here." }
      ]
    },
    {
      "situation": "Somebody has sent you four pages and you are not sure what they want.",
      "prompt": "Is that on the reliable side?",
      "options": [
        { "text": "No — it cannot know what they meant.", "correct": false, "note": "What they meant by sending it is a different question from what the pages ask of you." },
        { "text": "Only if you also paste the covering email.", "correct": false, "note": "Helpful context, and the document alone is already comprehensible." },
        { "text": "No, four pages is too much context.", "correct": false, "note": "Length is not the constraint. Long documents are a good use." },
        { "text": "Yes — comprehension of text.", "correct": true, "note": "What is being asked of you is in the words. What they meant by sending it is not." }
      ]
    }
  ]
}$j$::jsonb);
