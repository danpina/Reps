-- Messaging, track 2: Easy to reply to.
--
-- The second half of the topic's promise. Track one removes what should not be
-- in a message; this decides the shape of what is left, and every lesson in it
-- is about the cost of answering rather than the cost of sending.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'easy-to-reply-to'),
  1,
  'One ask',
  $md$A message carrying three questions gets the easiest one answered, and the other two are gone.

That is not carelessness on the reader's part. Faced with three things, somebody scanning on a phone answers the one that can be dealt with immediately, intends to come back to the rest, and does not — and you are now in the position of chasing two things while appearing to have been answered.

**The move:** one ask per message. If there are three, that is three messages or a numbered list.

Numbering genuinely works, and it is worth knowing why: it converts an unbounded blob into a checklist, and people finish checklists. Three unnumbered questions in a paragraph produce one answer; the same three as *1, 2, 3* produce three, because the shape tells somebody what completion looks like.

The version to avoid is the buried second ask — a message that is mostly about one thing with another request tucked into the fourth sentence. That one is not answered late, it is not answered at all, and when you follow up the honest reply is *sorry, I did not see that*, which is true.

There is a related failure worth naming: the message with no ask in it that was hoping to produce one. *Just wanted to flag that the printer is broken* is information, and the reader is entitled to receive it as information — if you want somebody to do something about it, that is a different sentence, and hoping they will infer it is how things do not get fixed.

If you need several things from one person regularly, batch them. One message on Thursday with four numbered items is far easier to deal with than four messages across a week, and it is also much easier to say yes to.

If you keep one thing: one ask, or a numbered list. Three questions in a paragraph is one question with two decoys.$md$,
  $j$[
    {
      "situation": "You have three questions for the same person.",
      "line": "(number them)",
      "why": "It converts a blob into a checklist, and people finish checklists. Three unnumbered questions produce one answer."
    },
    {
      "situation": "You have tucked a second request into the fourth sentence.",
      "line": "(that one will not be answered at all)",
      "why": "And when you follow up, sorry, I did not see that is a true reply."
    },
    {
      "situation": "You have flagged that the printer is broken and hoped somebody would act.",
      "line": "(that was information, not a request)",
      "why": "The reader is entitled to receive it as information. If you want something done, that is a different sentence."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does numbering work?",
      "options": [
        { "text": "It looks organised.", "correct": false, "note": "How it appears rather than what it does to the reader's behaviour." },
        { "text": "It shows you have thought about it.", "correct": false, "note": "Possibly, and the effect is on completion rather than on impression." },
        { "text": "It converts a blob into a checklist, and people finish checklists.", "correct": true, "note": "The shape tells somebody what completion looks like — three unnumbered questions get one answer, the same three numbered get three." },
        { "text": "It makes each question shorter.", "correct": false, "note": "Not necessarily, and length is not what causes two of them to be dropped." }
      ],
      "explain": "One ask per message, or a numbered list."
    },
    {
      "prompt": "What is the worst place for a second request?",
      "options": [
        { "text": "The fourth sentence of a message about something else.", "correct": true, "note": "It is not answered late, it is not answered at all — and when you chase it, sorry, I did not see that is an honest reply." },
        { "text": "At the very end.", "correct": false, "note": "Visible, and it at least has position. The buried one has neither." },
        { "text": "In a follow-up message.", "correct": false, "note": "That is a separate message, which is one of the two recommended shapes." },
        { "text": "In the subject line.", "correct": false, "note": "Unusual placement and it would at least be seen." }
      ],
      "explain": "And a flag is not a request. If you want something done, say so."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_ask", "label": "One ask", "description": "Or a numbered list rather than a paragraph." },
      { "key": "nothing_buried", "label": "Nothing buried", "description": "No request tucked mid-message." },
      { "key": "asked_explicitly", "label": "Asked rather than flagged", "description": "Said what they wanted done." },
      { "key": "batched", "label": "Batched where sensible", "description": "One message with several items rather than several messages." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You need three things from the same colleague: sign-off on the budget, the name of the printer contact, and whether Thursday works for a call.",
    "partner": {
      "name": "Priya",
      "role": "a colleague",
      "personality": "Answers whatever is easiest and most visible, sincerely intending to come back to the rest. Works through a numbered list completely.",
      "mood": "Overloaded.",
      "openness": 4
    },
    "opening_beat": "The message box is open.",
    "success_looks_like": "The user numbers the three or sends them separately.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer only the easiest question if several arrive in a paragraph, and say you will come back to the others.",
      "Work through a numbered list completely and quickly.",
      "Never ask for clarification about the other items."
    ]
  }$j$::jsonb,
  $md$Today, take one message with several asks in it and number them. Log how many you had.$md$
),
(
  (select id from public.skills where slug = 'easy-to-reply-to'),
  2,
  'The ask first, context after',
  $md$People read the first line and decide whether this is a now or a later. Everything else about your message is being judged after that decision has already been made.

**The move:** ask, then explain.

*Can you approve the invoice? It is the one from March that got held up with the printers.* Four seconds to answer, and the background is there for anybody who needs it.

The same content in the other order — three sentences of history and then the request — gets read halfway, filed as complicated, and dealt with tomorrow. Nothing about it was harder; it simply took longer to find out what was wanted.

This is the same instruction as the point-first rule in Presenting and it is here for the same reason: the reader is deciding whether to keep going, and a request that arrives late has to survive a decision made before it appeared.

The reason people do it backwards is understandable. The context feels necessary — you know the invoice needs explaining, and it seems unfair to ask without giving somebody the picture first. But the picture is only needed by somebody who is going to say no or ask a question, which is a minority, and they can read the second half.

Two practical shapes. In a chat, the ask is the first line and the context is the second. In an email, the ask is the first line *and* the subject, because a subject saying *Invoice* tells nobody anything while *Invoice approval needed by Friday* is a complete message on its own.

And where the context is genuinely long, say so and put it underneath: *Can you approve the invoice? Background below if useful.* That is a message somebody can answer without reading half of it, which is the whole objective.

If you keep one thing: the first line is the ask. Context is for the people who need it, and they will scroll.$md$,
  $j$[
    {
      "situation": "You have three sentences of background and a request at the end.",
      "line": "(turn it round)",
      "why": "People read the first line and decide whether this is a now or a later, and a request arriving late has to survive a decision made before it appeared."
    },
    {
      "situation": "The background genuinely is long.",
      "line": "Can you approve the invoice? Background below if useful.",
      "why": "Answerable without reading half of it, which is the objective. The context is only needed by somebody about to say no."
    },
    {
      "situation": "You are writing an email subject line.",
      "line": "Invoice approval needed by Friday.",
      "why": "A subject saying Invoice tells nobody anything. This one is a complete message on its own."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does context-first fail?",
      "options": [
        { "text": "It is boring.", "correct": false, "note": "Interest is not the variable — plenty of dull messages get answered in seconds." },
        { "text": "The reader has already decided before the ask appears.", "correct": true, "note": "They read the first line and file it as now or later, and a request arriving in sentence four has to survive a decision that was made without it." },
        { "text": "People do not read to the end.", "correct": false, "note": "Close, and it overstates it — they often do read to the end, tomorrow." },
        { "text": "It looks disorganised.", "correct": false, "note": "It usually looks careful, which is why thoughtful people do it." }
      ],
      "explain": "Ask, then explain. Same rule as point-first in a presentation, for the same reason."
    },
    {
      "prompt": "Who actually needs the context?",
      "options": [
        { "text": "Everybody — it is only fair.", "correct": false, "note": "It feels unfair to ask without it, and most people just want to know what is wanted." },
        { "text": "Anybody who has not been following.", "correct": false, "note": "Some of those will still answer without it, and the rest can scroll." },
        { "text": "Nobody, mostly.", "correct": false, "note": "Slightly too strong. There is a real minority who need it and the answer names them." },
        { "text": "The minority about to say no or ask a question.", "correct": true, "note": "And they can read the second half. Everybody else has answered and moved on." }
      ],
      "explain": "In an email, the ask goes in the subject line too."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "ask_first", "label": "Ask in the first line", "description": "Before any background." },
      { "key": "context_after", "label": "Context underneath", "description": "Available rather than compulsory." },
      { "key": "subject", "label": "A subject that says something", "description": "In email, the ask in the subject line." },
      { "key": "answerable", "label": "Answerable without scrolling", "description": "Could be dealt with from the first line." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You need an invoice approved. There is three sentences of background about why it was held up.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Approves things in seconds when the ask is visible, and leaves anything that needs reading for the evening.",
      "mood": "Between meetings.",
      "openness": 4
    },
    "opening_beat": "The message box is open.",
    "success_looks_like": "The user leads with the ask and puts the background underneath.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Approve immediately if the ask is in the first line.",
      "Say you will look at it later if the message opens with background.",
      "Never ask what is wanted."
    ]
  }$j$::jsonb,
  $md$Today, rewrite one message so the ask is the first line. Log the sentence that used to be first.$md$
),
(
  (select id from public.skills where slug = 'easy-to-reply-to'),
  3,
  'Make the reply cheap',
  $md$Whether somebody answers you quickly is largely a function of how much work the reply is, and you control almost all of that.

**The move:** ask the cheapest question that gets you what you need.

An open question is expensive. *What do you think about the timings?* asks somebody to form a view, structure it and write it, which is ten minutes of work — so it goes into the evening pile. *Does Thursday work, or shall I move it to next week?* is four seconds and produces the same decision.

Three ways to lower the cost.

**Close the question where a closed answer will do.** Yes or no, or this or that. Reserve open questions for the times you genuinely want somebody's thinking, and expect those to take longer.

**Offer options rather than asking for one.** *Thursday or Friday?* beats *when suits you?*, which hands somebody a diary problem. This is the same move as proposing a specific plan in every other topic in this app, because it is the same principle: generating is harder than choosing.

**Say what happens if they do not reply.** *If I do not hear by Thursday I will assume it is fine and send it* is enormously useful — it makes silence a valid answer, which means the message stops being a task and starts being a notification. Use it where the default really is acceptable to you.

The related habit is not making somebody do your retrieval. Attach the file rather than referring to it, quote the line rather than pointing at the thread, and say the date rather than *the meeting we discussed*. Every lookup you leave in the message is a reason to answer later.

If you keep one thing: ask the cheapest question that works. You are competing for a slot in somebody's day, and cost is what decides it.$md$,
  $j$[
    {
      "situation": "You want to know if the timing is all right.",
      "line": "Does Thursday work, or shall I move it to next week?",
      "why": "Four seconds and it produces the same decision. What do you think about the timings is ten minutes of work and goes into the evening pile."
    },
    {
      "situation": "You are about to ask when suits them.",
      "line": "Thursday or Friday?",
      "why": "Generating is harder than choosing, which is the same principle as proposing a specific plan everywhere else in this app."
    },
    {
      "situation": "The default outcome would be fine with you.",
      "line": "If I do not hear by Thursday I will assume it is fine and send it.",
      "why": "It makes silence a valid answer, which turns the message from a task into a notification."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What decides how fast you get answered?",
      "options": [
        { "text": "How important the sender is.", "correct": false, "note": "Less than people assume. Cheap messages from junior people get answered before expensive ones from senior people." },
        { "text": "How urgent the request is.", "correct": false, "note": "Urgency helps when it is stated, and an urgent expensive question still gets deferred." },
        { "text": "How much work the reply is.", "correct": true, "note": "You are competing for a slot in somebody's day, and cost is what decides it — almost all of which you control." },
        { "text": "How well you know them.", "correct": false, "note": "It buys goodwill and not a slot in a busy afternoon." }
      ],
      "explain": "Ask the cheapest question that gets you what you need."
    },
    {
      "prompt": "What does naming the default do?",
      "options": [
        { "text": "Puts pressure on them to reply.", "correct": false, "note": "The opposite — it removes the pressure, which is why it works." },
        { "text": "Turns the message from a task into a notification.", "correct": true, "note": "Silence becomes a valid answer, so it no longer needs a slot in anybody's day. Use it where the default really is acceptable to you." },
        { "text": "Shows you have thought ahead.", "correct": false, "note": "It does, and impression is not what changes the reply rate." },
        { "text": "Gives you cover if it goes wrong.", "correct": false, "note": "A defensive framing, and using it that way is how people announce defaults they have not really accepted." }
      ],
      "explain": "And do not make somebody do your retrieval — attach it, quote it, say the date."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "cheap", "label": "Asked the cheapest version", "description": "Closed where closed would do." },
      { "key": "options", "label": "Offered options", "description": "Did not ask them to generate one." },
      { "key": "default", "label": "Named a default where possible", "description": "Made silence a valid answer." },
      { "key": "no_retrieval", "label": "Did their retrieval for them", "description": "Attached, quoted, and gave dates." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You need to know whether a meeting can move. The obvious message is what do you think about the timings.",
    "partner": {
      "name": "Rae",
      "role": "your manager",
      "personality": "Answers a closed question instantly and defers an open one to the evening, sincerely meaning to think about it properly.",
      "mood": "Between meetings.",
      "openness": 4
    },
    "opening_beat": "The message box is open.",
    "success_looks_like": "The user asks a closed question with options in it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer a closed question immediately with a decision.",
      "Say you will think about it properly later if asked an open question.",
      "Never volunteer a preference unprompted."
    ]
  }$j$::jsonb,
  $md$Today, turn one open question into a closed one with two options. Log both versions.$md$
),
(
  (select id from public.skills where slug = 'easy-to-reply-to'),
  4,
  'No rush means never',
  $md$*No rush!* is written to be considerate and it is read as an instruction, and the instruction is: deal with this whenever, which in a full week means never.

**The move:** say when you need it.

*By Thursday if possible* is not pushy. It is the piece of information somebody needs in order to place your request in a week that already has forty things in it — and without it, yours is the only one with no position, which puts it last.

The reason people leave it off is worth naming, because it is the same belief that produces the apology. Saying when you need something feels like making a demand, as though attaching a date presumes on somebody's time. It does not. A deadline is not a claim about your importance; it is a fact about the work, and withholding it does not make you easier to deal with, it makes you harder — now they have to guess, and guessing wrong is worse for both of you.

Be honest about it in both directions. If it genuinely is not urgent, *no hurry — sometime next week is fine* is a real deadline and works properly, because it still gives a position. What does not work is *whenever* with nothing attached.

And if there is a real deadline, say why where it helps: *Thursday, because it goes to print Friday* converts a demand into a constraint that belongs to neither of you. That is the version people respond to fastest, and it is also the version that gets a proper answer when the date is impossible.

The one to avoid entirely is the false urgency — marking things urgent that are not, which works twice and then permanently devalues everything you send.

If you keep one thing: give it a position in their week. A request with no date is the one that gets done last, however small it was.$md$,
  $j$[
    {
      "situation": "You are about to write no rush.",
      "line": "(that reads as: deal with this whenever)",
      "why": "In a full week, whenever means never. Yours becomes the only request with no position, which puts it last."
    },
    {
      "situation": "It genuinely is not urgent.",
      "line": "No hurry — sometime next week is fine.",
      "why": "A real deadline that still gives a position. What does not work is whenever with nothing attached."
    },
    {
      "situation": "There is a real deadline.",
      "line": "Thursday, because it goes to print on Friday.",
      "why": "It converts a demand into a constraint belonging to neither of you, and it gets a proper answer when the date is impossible."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does no rush backfire?",
      "options": [
        { "text": "It sounds insincere.", "correct": false, "note": "It is almost always sincere, and sincerity is not what determines when it gets done." },
        { "text": "It leaves your request with no position in their week.", "correct": true, "note": "Everything else has a date. Yours is the only one that can be moved indefinitely without consequence, which is where it goes." },
        { "text": "People take advantage of it.", "correct": false, "note": "Nobody is taking advantage. They are prioritising, and you removed the input." },
        { "text": "It signals the task is unimportant.", "correct": false, "note": "Close, and importance is not what schedules things — position is." }
      ],
      "explain": "A deadline is a fact about the work rather than a claim about your importance."
    },
    {
      "prompt": "What gets the fastest proper answer?",
      "options": [
        { "text": "Marking it urgent.", "correct": false, "note": "Works twice, then permanently devalues everything you send." },
        { "text": "A date with the reason attached.", "correct": true, "note": "Thursday, because it goes to print Friday belongs to neither of you — and it is the version that gets a real answer when the date is impossible." },
        { "text": "Asking them when they could do it.", "correct": false, "note": "It hands over a scheduling problem, and the answer is usually vague." },
        { "text": "Apologising for the deadline.", "correct": false, "note": "The crouch from the first track, arriving on top of a piece of ordinary information." }
      ],
      "explain": "And no hurry — sometime next week is a real deadline. Whenever is not."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "a_date", "label": "Gave a date", "description": "Any position in the week." },
      { "key": "no_whenever", "label": "No whenever", "description": "Did not leave it unplaced." },
      { "key": "reason", "label": "Reason where it helped", "description": "Made the constraint external." },
      { "key": "honest", "label": "Honest urgency", "description": "Did not inflate it." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You need something back by Thursday because it goes to print on Friday. You are about to write no rush.",
    "partner": {
      "name": "Priya",
      "role": "a colleague",
      "personality": "Schedules by date. Anything without one goes to the bottom of a long list, sincerely intending to get to it.",
      "mood": "Very busy.",
      "openness": 4
    },
    "opening_beat": "The message box is open.",
    "success_looks_like": "The user gives a date and the reason for it.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Commit to a specific time if given a date.",
      "Say you will try to get to it if given no date, and mean it without doing it.",
      "Never ask when it is needed by."
    ]
  }$j$::jsonb,
  $md$Today, put a date on one request you would normally have marked no rush. Log the date you gave.$md$
),
(
  (select id from public.skills where slug = 'easy-to-reply-to'),
  5,
  'Written for a corridor',
  $md$Your message will be read on a phone, one-handed, walking somewhere. That is not a worst case, it is the normal case, and writing for it changes what a good message looks like.

**The move:** write so it can be dealt with from a screenful, standing up.

Anything longer gets *I will read this properly later*, and later has a poor completion rate. That is not laziness — a long message genuinely cannot be answered in a corridor, so it correctly gets deferred to a moment that may not come.

Practically, that means a few things.

**Short paragraphs, and white space.** A wall of text is refused before it is read, and the same content in three short paragraphs is not. Nothing has changed except how possible it looks.

**Front-load, and say if it is long.** If it genuinely needs five hundred words, say so at the top — *this is long, the ask is in the first line* — so somebody can answer now and read the rest when they sit down.

**One subject per message.** A message covering two topics cannot be dealt with in one go, so it waits for a moment when both can be — which is a much rarer moment than either alone.

**Assume no context.** They have not read the thread, they do not remember Tuesday's conversation, and they have four other things happening. Two words of orientation — *on the print job* — costs you nothing and saves them a lookup.

The general principle underneath all of it: you are not writing a document, you are writing something that has to survive being read in twenty seconds by somebody who is doing something else. Almost every message that fails, fails there rather than on its content.

If you keep one thing: could this be answered while standing up? If not, either shorten it or say where the ask is.$md$,
  $j$[
    {
      "situation": "You have written six paragraphs.",
      "line": "(that gets read properly later)",
      "why": "It genuinely cannot be answered in a corridor, so it correctly gets deferred to a moment that may not come."
    },
    {
      "situation": "It really does need five hundred words.",
      "line": "This is long — the ask is in the first line.",
      "why": "Somebody can answer now and read the rest when they sit down, which is two different moments rather than one rare one."
    },
    {
      "situation": "You are referring to something from Tuesday.",
      "line": "On the print job —",
      "why": "They have not read the thread and have four other things happening. Two words of orientation saves them a lookup."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does a long message get deferred?",
      "options": [
        { "text": "People are lazy.", "correct": false, "note": "They are standing in a corridor. It genuinely cannot be answered from there, so deferring is the correct decision." },
        { "text": "It looks like work.", "correct": false, "note": "Appearance matters, which is why white space helps — and the deeper reason is what the situation allows." },
        { "text": "It cannot be dealt with from where they are.", "correct": true, "note": "A phone, one-handed, walking somewhere is the normal case rather than the worst one, and later has a poor completion rate." },
        { "text": "They will forget it.", "correct": false, "note": "The outcome rather than the mechanism, and it follows from the deferral." }
      ],
      "explain": "Could this be answered while standing up?"
    },
    {
      "prompt": "Why one subject per message?",
      "options": [
        { "text": "It is tidier.", "correct": false, "note": "Tidiness is not what changes the reply time." },
        { "text": "Two subjects is twice the length.", "correct": false, "note": "Not necessarily, and length is a separate constraint." },
        { "text": "It waits for a moment when both can be dealt with.", "correct": true, "note": "Which is a much rarer moment than either alone — so a two-topic message is deferred by the harder of its halves." },
        { "text": "People only remember one thing.", "correct": false, "note": "Memory is not the issue when the message is right there." }
      ],
      "explain": "And assume no context. Two words of orientation costs you nothing."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "screenful", "label": "Fits a screen", "description": "Answerable standing up." },
      { "key": "white_space", "label": "Broken up", "description": "Short paragraphs rather than a wall." },
      { "key": "one_subject", "label": "One subject", "description": "Did not combine two topics." },
      { "key": "orientation", "label": "Gave orientation", "description": "Two words of context, no lookup required." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have written a six-paragraph message covering the print job and next month's budget, referring to a conversation from Tuesday.",
    "partner": {
      "name": "Rae",
      "role": "your manager, currently walking between buildings",
      "personality": "Answers anything that can be dealt with one-handed and defers anything that cannot, with every intention of returning to it.",
      "mood": "In transit.",
      "openness": 4
    },
    "opening_beat": "The draft is sitting in the box.",
    "success_looks_like": "The user splits it and makes the first one answerable from a corridor.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Answer immediately anything short, oriented and single-subject.",
      "Say you will read it properly later if it is long or covers two things.",
      "Never actually come back to a deferred message."
    ]
  }$j$::jsonb,
  $md$Today, cut one message so it fits a phone screen. Log the before and after length.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('easy-to-reply-to', 1, 'line', $j${
  "says": "(you need three things from the same colleague: sign-off on the budget, the printer contact's name, and whether Thursday works for a call)",
  "model": {
    "line": "Three things when you have a minute: 1. Can you sign off the budget? 2. Who is our contact at the printers? 3. Does Thursday at 3 work for a call?",
    "why": "A numbered list converts a blob into a checklist, and people finish checklists. The same three in a paragraph would get the easiest one answered and the other two lost."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Number them",
      "words": ["1.", "2.", "3.", "one", "two", "three", "first", "second"] },
    { "kind": "forbids_any", "requirement": "No crouch in front of it",
      "words": ["sorry", "just", "quick", "i know you are busy", "no rush", "if you get a chance", "hate to"] },
    { "kind": "min_words", "requirement": "All three asks", "n": 18 },
    { "kind": "max_words", "requirement": "A list, not an essay", "n": 60 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('easy-to-reply-to', 2, 'line', $j${
  "says": "(you need an invoice approved — it is the one from March that got held up with the printers, and there is a fair amount of background)",
  "model": {
    "line": "Can you approve the March invoice? It is the one that got held up with the printers — background below if you need it.",
    "why": "The ask in the first line, so it can be answered in four seconds by the people who will, and the context underneath for the minority about to say no."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Ask in the first line" },
    { "kind": "forbids_any", "requirement": "No background before the ask",
      "words": ["so basically", "back in march", "you may remember", "as you know", "a while ago", "the situation is", "let me explain"] },
    { "kind": "max_words", "requirement": "Answerable from the first line", "n": 45 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('easy-to-reply-to', 3, 'choice', $j${
  "beats": [
    {
      "situation": "You need to know whether a meeting can move to next week.",
      "prompt": "Which message?",
      "options": [
        { "text": "What do you think about the timings?", "correct": false, "note": "It asks somebody to form a view, structure it and write it — ten minutes of work, which goes into the evening pile." },
        { "text": "When would suit you?", "correct": false, "note": "It hands over a diary problem. Generating an option is harder than choosing between two." },
        { "text": "Does Thursday work, or shall I move it to next week?", "correct": true, "note": "Four seconds, and it produces exactly the same decision. Ask the cheapest question that gets you what you need." },
        { "text": "Are you happy for me to move the meeting?", "correct": false, "note": "Closed, which is good, and it does not say where to, so it needs a second exchange." }
      ]
    },
    {
      "situation": "You are sending something for review, and honestly, if nobody objects you are happy to proceed.",
      "prompt": "What do you add?",
      "options": [
        { "text": "Let me know what you think.", "correct": false, "note": "An open request for a response on something that did not need one." },
        { "text": "Any objections?", "correct": false, "note": "Better — closed, and it still requires an action from somebody who has none." },
        { "text": "No rush on this one.", "correct": false, "note": "Read as deal with this whenever, which in a full week means never." },
        { "text": "If I do not hear by Thursday I will assume it is fine and send it.", "correct": true, "note": "It makes silence a valid answer, which turns the message from a task into a notification. Use it where the default really is acceptable to you." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('easy-to-reply-to', 4, 'line', $j${
  "says": "(you need it back by Thursday because it goes to print on Friday — and you were about to write no rush)",
  "model": {
    "line": "Could you get this back to me by Thursday? It goes to print on Friday.",
    "why": "A date gives the request a position in a week that already has forty things in it, and the reason turns a demand into a constraint belonging to neither of you."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Give it a date",
      "words": ["thursday", "friday", "monday", "tuesday", "wednesday", "tomorrow", "by the", "this week", "next week"] },
    { "kind": "forbids_any", "requirement": "No rush means never",
      "words": ["no rush", "no hurry", "whenever", "when you can", "if you get time", "at some point", "no pressure", "sorry"] },
    { "kind": "max_words", "requirement": "A date and a reason", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('easy-to-reply-to', 5, 'choice', $j${
  "beats": [
    {
      "situation": "Six paragraphs covering the print job and next month's budget, referring back to Tuesday's conversation.",
      "prompt": "What is the first fix?",
      "options": [
        { "text": "Cut it down to three paragraphs.", "correct": false, "note": "Better and still two subjects, so it waits for a moment when both can be dealt with — a much rarer moment than either alone." },
        { "text": "Split it into two messages.", "correct": true, "note": "One subject each, so each can be answered from a corridor. Combined, the harder half defers the easier one." },
        { "text": "Add a summary at the top.", "correct": false, "note": "Helps, and a summary of two subjects still needs two decisions before anything can be answered." },
        { "text": "Send it and follow up in person.", "correct": false, "note": "It plans around the failure rather than fixing it, and doubles the work for both of you." }
      ]
    },
    {
      "situation": "One of the two genuinely does need five hundred words.",
      "prompt": "How do you send that one?",
      "options": [
        { "text": "Break it into short paragraphs and send it as is.", "correct": false, "note": "White space helps a great deal and it is still five hundred words to read before anything can be answered." },
        { "text": "Say it is long and put the ask in the first line.", "correct": true, "note": "Then it can be answered now and read properly later — two available moments rather than one rare one." },
        { "text": "Send it as a document instead.", "correct": false, "note": "It moves the same problem into an attachment, which is one more step before anybody can start." },
        { "text": "Ask for a call instead.", "correct": false, "note": "Sometimes right, and if it is five hundred words of detail a written record is usually what is wanted." }
      ]
    }
  ]
}$j$::jsonb);
