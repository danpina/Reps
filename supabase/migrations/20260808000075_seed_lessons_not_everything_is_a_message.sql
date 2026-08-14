-- Messaging, track 5: Not everything is a message.
--
-- Two failures, opposite sides of treating a messaging app as though it were
-- the whole relationship: sending things it cannot carry, and reading meaning
-- into silences that contain none.
--
-- Hard conversations owns what to say when something is difficult. This only
-- decides whether a message is the right container at all.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'not-everything-is-a-message'),
  1,
  'Three messages means phone',
  $md$Text is very good at facts, arrangements and small asks, and quite bad at anything with nuance in it. Past a certain complexity, each additional message adds ambiguity rather than removing it.

The pattern is familiar. You explain. They misread part of it. You clarify. They misread the clarification, differently. Forty minutes later you have a worse shared understanding than you started with, and both of you are mildly irritated by something neither of you said.

**The move:** if a subject has taken three messages, stop typing and phone.

Three is a rule of thumb and it is roughly right. Once is a question. Twice is a clarification. Three times means the medium is not carrying it, and no amount of better wording will fix that — the failure is bandwidth rather than composition, and rewriting the fourth message is the most common way an hour disappears.

*Easier to explain — free for five minutes?* is the whole escalation. Nobody has ever minded being asked, and it is received as somebody solving a problem rather than as somebody making a fuss.

Two things that predict a call in advance, so you can skip the three messages. Anything involving a decision with more than two options, because comparison is what text is worst at. And anything where you can feel yourself drafting carefully — careful drafting is a signal that the content is more delicate than the channel supports.

The counter-argument worth taking seriously is that a call interrupts and a message does not, which is true and is why messages are the default. But three messages across an afternoon interrupt three times, cost more attention in total, and produce less. The call is usually the smaller imposition.

If you keep one thing: three attempts and it is a call. Rewriting the fourth is where the afternoon goes.$md$,
  $j$[
    {
      "situation": "You are drafting your fourth message on the same subject.",
      "line": "Easier to explain — free for five minutes?",
      "why": "The failure is bandwidth rather than composition, so a better fourth message does not exist. Nobody has ever minded being asked."
    },
    {
      "situation": "The decision has four options.",
      "line": "(call — comparison is what text is worst at)",
      "why": "You can skip the three messages entirely if you can see the shape in advance."
    },
    {
      "situation": "You notice you are drafting very carefully.",
      "line": "(that is the signal)",
      "why": "Careful drafting means the content is more delicate than the channel supports."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does the fourth message not work?",
      "options": [
        { "text": "They have stopped reading properly.", "correct": false, "note": "They are reading closely, which is part of why the misreadings are so specific." },
        { "text": "The failure is bandwidth, not composition.", "correct": true, "note": "Past a certain complexity each message adds ambiguity rather than removing it, so a better-worded fourth does not exist." },
        { "text": "You are both annoyed by then.", "correct": false, "note": "Frequently true, and it is a consequence of the loop rather than what makes it unresolvable." },
        { "text": "Too much has been said to summarise.", "correct": false, "note": "A call summarises it in thirty seconds, which is rather the point." }
      ],
      "explain": "Three attempts and it is a call. Rewriting the fourth is where the afternoon goes."
    },
    {
      "prompt": "What predicts a call before the three messages?",
      "options": [
        { "text": "How important the subject is.", "correct": false, "note": "Plenty of important things are one line. Importance is not what text struggles with." },
        { "text": "How well you know the person.", "correct": false, "note": "It affects tone rather than whether the content fits the channel." },
        { "text": "How long the message is.", "correct": false, "note": "Long is a symptom, and a long message can be perfectly clear." },
        { "text": "More than two options, or careful drafting.", "correct": true, "note": "Comparison is what text is worst at, and careful drafting is a signal that the content is more delicate than the channel supports." }
      ],
      "explain": "A call interrupts once. Three messages across an afternoon interrupt three times and produce less."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "escalated", "label": "Moved to a call", "description": "Stopped typing at the third attempt." },
      { "key": "predicted", "label": "Predicted it where possible", "description": "Called first on multi-option decisions." },
      { "key": "no_fourth", "label": "Did not write the fourth", "description": "Resisted rewording it again." },
      { "key": "framed_well", "label": "Asked plainly", "description": "Easier to explain rather than we need to talk." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Third message on the same subject and it is still not landing. You are drafting a fourth.",
    "partner": {
      "name": "Priya",
      "role": "a colleague",
      "personality": "Misreads written explanations of this particular thing every time, and understands it immediately on a call. Says yes to five minutes instantly.",
      "mood": "Trying, slightly confused.",
      "openness": 4
    },
    "opening_beat": "\"Sorry — do you mean the March version or the one we redid?\"",
    "success_looks_like": "The user suggests a call rather than writing a fourth message.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Misunderstand any further written explanation, differently each time.",
      "Agree to a call immediately and warmly.",
      "Never suggest a call yourself."
    ]
  }$j$::jsonb,
  $md$Today, move one conversation to a call at the third message. Log what it was about.$md$
),
(
  (select id from public.skills where slug = 'not-everything-is-a-message'),
  2,
  'Difficult things are not text',
  $md$Anything with feeling in it is the same call, for a stronger reason.

**The move:** use a message to arrange the conversation, not to have it.

What to say when something is difficult belongs to Hard conversations. The decision here comes before that one and is narrower: whether a message is the right container at all. It is not, and there are four specific reasons rather than a general preference.

**Tone is missing.** The channel takes ten off everything, and a difficult message is the worst possible place to be spending that. Something you would have said gently arrives without the gentleness.

**It lasts.** A conversation is over when it is over. A message is on somebody's phone, and it will be reread — at two in the morning, in a worse mood than the one they had when it arrived.

**It can be forwarded.** Whatever you write may be read by somebody you did not write it for, which changes what it is.

**You cannot see what it is doing.** In a room you adjust constantly, and none of that is available. You will finish saying the whole thing without ever knowing whether the first sentence landed badly.

The exception is real and worth stating properly: if you genuinely cannot say it out loud, writing it is better than not saying it. That is the trade Hard conversations makes too, and it is the right one. Keep it short, keep the accusations out, and end by asking to talk.

And the hybrid is better than either. A short message naming the subject and asking for a time, then the conversation itself in person, which is exactly the opening move that topic teaches.

If you keep one thing: write to arrange it, talk to have it. A difficult message becomes a document, and a document is a different object from a conversation.$md$,
  $j$[
    {
      "situation": "You are drafting four paragraphs about something that upset you.",
      "line": "(that becomes a document)",
      "why": "It lasts, it is reread at two in the morning in a worse mood, and it can be forwarded to somebody you did not write it for."
    },
    {
      "situation": "You want the benefits of writing and talking.",
      "line": "A short message naming the subject and asking for a time.",
      "why": "The written part does what writing is good at, and the conversation happens where tone and response exist."
    },
    {
      "situation": "You genuinely cannot say it out loud.",
      "line": "(then write it, short, and ask to talk at the end)",
      "why": "Getting it said imperfectly beats not saying it. Keep the accusations out and keep it brief."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Which cost is specific to writing rather than to difficulty?",
      "options": [
        { "text": "It is uncomfortable.", "correct": false, "note": "Equally true of the conversation, which is why people reach for the message." },
        { "text": "It gets reread at two in the morning.", "correct": true, "note": "A conversation is over when it is over. A message is on somebody's phone in a worse mood than the one they had when it arrived." },
        { "text": "They might disagree.", "correct": false, "note": "They might in either medium, and disagreement is not what the channel adds." },
        { "text": "It takes longer to compose.", "correct": false, "note": "A cost to you, and the smallest one on the list." }
      ],
      "explain": "Write to arrange it, talk to have it."
    },
    {
      "prompt": "When is writing it the right call?",
      "options": [
        { "text": "When you want a record.", "correct": false, "note": "Occasionally necessary at work, and wanting a record changes what the conversation is." },
        { "text": "When it is too serious for a call.", "correct": false, "note": "Seriousness argues for the room, where you can see what it is doing." },
        { "text": "When otherwise you will not say it at all.", "correct": true, "note": "Getting it said imperfectly beats not saying it — the same trade Hard conversations makes, and it is the right one." },
        { "text": "When they are difficult to reach.", "correct": false, "note": "A scheduling problem, and it argues for arranging a time rather than for writing the substance." }
      ],
      "explain": "And then: short, no accusations, and end by asking to talk."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "arranged", "label": "Wrote to arrange", "description": "Used the message to get a time." },
      { "key": "not_the_substance", "label": "Did not send the substance", "description": "Kept the difficult content out of writing." },
      { "key": "short", "label": "Kept any writing short", "description": "No paragraphs, no lists, no accusations." },
      { "key": "got_it_said", "label": "Said it somehow", "description": "Did not use the rule as a reason to do nothing." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You have drafted a long message about something a friend did that upset you.",
    "partner": {
      "name": "Sam",
      "role": "a friend you have shown the draft to",
      "personality": "Asks how it would read on a bad day and who else might see it. Suggests nothing directly.",
      "mood": "Careful.",
      "openness": 5
    },
    "opening_beat": "\"Four paragraphs. When do you think they will read this?\"",
    "success_looks_like": "The user cuts it to a message that arranges a conversation.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask how it would read at two in the morning.",
      "Take seriously the possibility that writing is the only way it happens.",
      "Never tell the user to send or not send it."
    ]
  }$j$::jsonb,
  $md$Today, take one difficult thing you were going to write and send a message arranging a conversation instead. Log both.$md$
),
(
  (select id from public.skills where slug = 'not-everything-is-a-message'),
  3,
  'A silence is not a message',
  $md$Two grey ticks, four hours, and nothing. This is where a quiet person spends more time than on anything else in this topic, and there is almost no information in it.

**The move:** treat a gap as a fact about their day.

Somebody opened it in a lift. Somebody meant to answer properly and got called into something. Somebody read it while holding a coffee and lost it up the screen. Every one of those produces the same silence as being ignored, and every one is more likely.

Four hours is not a signal. A day is rarely a signal. Even three days is usually a busy week rather than a decision, and the number of times a silence has genuinely meant what somebody feared is very small compared with the number of times it has been examined.

What makes this expensive is not the waiting, it is the construction. In the gap, a story gets built — about what you said, how it must have read, what they are thinking — and it is assembled from no evidence whatsoever, which is precisely why it can grow. Nothing in it is checkable, so nothing in it is limited.

The tell that you are constructing rather than waiting: the story gets worse over time. Actual information does not do that.

Two rules follow. Do not double-message into a silence — a second message before the first is answered adds pressure and no information, and it is read as anxiety rather than as a reminder. Wait a day, then follow up plainly, which the first track already covered.

And notice what the silence is costing you rather than what it means. An afternoon spent checking a phone is a real cost, paid for something that will resolve itself by Thursday with an apology about a busy week.

If you keep one thing: the gap contains nothing. Whatever you have found in it, you put there.$md$,
  $j$[
    {
      "situation": "Four hours, two grey ticks, nothing.",
      "line": "(a fact about their day)",
      "why": "Opened in a lift, meant to answer properly, lost up the screen. Every ordinary case produces the same silence as being ignored."
    },
    {
      "situation": "You have worked out what they must be thinking.",
      "line": "(you built that from nothing)",
      "why": "Nothing in it is checkable, which is exactly why it can grow. The tell is that it gets worse over time."
    },
    {
      "situation": "You are about to send a second message.",
      "line": "(that adds pressure and no information)",
      "why": "It is read as anxiety rather than as a reminder. Wait a day, then follow up plainly."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "How do you tell constructing from waiting?",
      "options": [
        { "text": "Constructing feels anxious.", "correct": false, "note": "Both do, which makes it useless as a test in the moment." },
        { "text": "The story gets worse over time.", "correct": true, "note": "Actual information does not do that. Anything assembled from no evidence has nothing limiting it." },
        { "text": "Constructing involves rereading your message.", "correct": false, "note": "A common symptom, and plenty of it happens without rereading anything." },
        { "text": "You start drafting a follow-up.", "correct": false, "note": "A follow-up is a reasonable thing to draft. The tell is what happens to the story rather than to your outbox." }
      ],
      "explain": "The gap contains nothing. Whatever you have found in it, you put there."
    },
    {
      "prompt": "Why not double-message?",
      "options": [
        { "text": "It looks needy.", "correct": false, "note": "How it looks, and the mechanical objection is stronger." },
        { "text": "They will feel guilty.", "correct": false, "note": "Some will, mildly, and guilt is not the cost being described." },
        { "text": "It might annoy them.", "correct": false, "note": "Rarely does. The problem is what it adds rather than what it provokes." },
        { "text": "It adds pressure and no information.", "correct": true, "note": "Read as anxiety rather than as a reminder — and the original is still there, unanswered, for the same reasons it was." }
      ],
      "explain": "Wait a day, then follow up plainly, with no reference to the gap."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_meaning", "label": "Read nothing into it", "description": "Treated the gap as a fact about their day." },
      { "key": "no_construction", "label": "Did not build a story", "description": "Noticed the story getting worse and stopped." },
      { "key": "no_double", "label": "Did not double-message", "description": "Waited before following up." },
      { "key": "cost", "label": "Noticed the cost", "description": "Saw what the afternoon of checking was worth." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You sent something six hours ago. It has been read. Nothing has come back and you have checked eleven times.",
    "partner": {
      "name": "Sam",
      "role": "a friend you are talking to about it",
      "personality": "Asks what the story is now compared with what it was two hours ago, and notices which direction it has moved.",
      "mood": "Level.",
      "openness": 5
    },
    "opening_beat": "\"What do you think it means, then?\"",
    "success_looks_like": "The user notices the story is manufactured and stops.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what the theory was two hours ago and whether it has got worse.",
      "Accept I do not know as a good answer.",
      "Never offer an explanation for the silence."
    ]
  }$j$::jsonb,
  $md$Today, notice one silence you have been interpreting. Write down the theory, then write down the boring version. Log both.$md$
),
(
  (select id from public.skills where slug = 'not-everything-is-a-message'),
  4,
  'Reply time is not a scoreboard',
  $md$The other half of the same anxiety, and it runs in both directions: how fast you answer, and how fast you are answered.

**The move:** stop treating reply speed as a measure of anything.

On the receiving side, the arithmetic people do is remarkably specific — they replied in twelve minutes yesterday and four hours today, so something has changed. Nothing has changed. Reply time is a function of where somebody was, what they were doing and how their phone was set up, and those vary enormously day to day for reasons that have nothing to do with you.

On the sending side there is a related trap: matching. Deliberately waiting because they waited, so as not to seem too available. It is the same turn-taking rule that stalls friendships two topics ago, and it produces the same outcome — two people managing an imaginary contest instead of arranging something.

Answer when you see it and can. If that is instant, instant is fine. Nobody has ever thought less of somebody for replying quickly, and the belief that they might is one of the more durable pieces of folklore in this whole area.

The one place speed genuinely matters is that a fast reply is a small kindness when somebody is waiting on something — a decision, a plan, an answer that unblocks them. That is about their situation rather than about the relationship, and it is worth being quick for that reason.

And a delay you cannot avoid is worth naming, because it costs nothing and removes an unknown. *Can only answer this properly tomorrow* takes four seconds and turns a silence into a plan.

If you keep one thing: answer when you can, and read nothing into when they do. There is no scoreboard, and the only person keeping one is you.$md$,
  $j$[
    {
      "situation": "They replied in twelve minutes yesterday and four hours today.",
      "line": "(that is where they were, not what changed)",
      "why": "Reply time varies enormously day to day for reasons that have nothing to do with you."
    },
    {
      "situation": "You are waiting before replying so as not to seem too available.",
      "line": "(that is the turn-taking rule again)",
      "why": "It produces two people managing an imaginary contest instead of arranging something."
    },
    {
      "situation": "You cannot answer properly until tomorrow.",
      "line": "Can only answer this properly tomorrow.",
      "why": "Four seconds, and it turns a silence into a plan."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does reply time actually measure?",
      "options": [
        { "text": "Where somebody was and what they were doing.", "correct": true, "note": "It varies enormously day to day for reasons that have nothing to do with you, which is why the twelve-minutes-versus-four-hours arithmetic finds patterns that are not there." },
        { "text": "How much they want to talk to you.", "correct": false, "note": "The reading the anxiety produces, and it is contradicted by how much it varies for the same person in the same week." },
        { "text": "How busy they are generally.", "correct": false, "note": "Even that is too stable. It is about a particular hour rather than a general state." },
        { "text": "How important your message was.", "correct": false, "note": "Cheapness to answer affects it — the second track — and that is about the message rather than about you." }
      ],
      "explain": "There is no scoreboard, and the only person keeping one is you."
    },
    {
      "prompt": "When does speed genuinely matter?",
      "options": [
        { "text": "When you want to seem keen.", "correct": false, "note": "Impression management, and nobody has ever thought less of somebody for replying quickly." },
        { "text": "When they replied quickly to you.", "correct": false, "note": "Matching is the turn-taking rule, and it produces a contest neither of you agreed to." },
        { "text": "When somebody is blocked on your answer.", "correct": true, "note": "A decision, a plan, something they cannot proceed without. That is about their situation rather than the relationship." },
        { "text": "At work, always.", "correct": false, "note": "Far too broad, and it is how people end up answering everything instantly and nothing well." }
      ],
      "explain": "And name an unavoidable delay — four seconds turns a silence into a plan."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_arithmetic", "label": "Did no arithmetic", "description": "Did not compare reply times." },
      { "key": "no_matching", "label": "Did not match", "description": "Answered when they could rather than when it was even." },
      { "key": "quick_where_needed", "label": "Quick where somebody was blocked", "description": "Prioritised by their situation." },
      { "key": "named_delay", "label": "Named an unavoidable delay", "description": "Turned a silence into a plan." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Somebody who usually replies within the hour has taken most of a day. You are deciding how to respond, and whether to wait a while yourself.",
    "partner": {
      "name": "Sam",
      "role": "a friend you are talking to about it",
      "personality": "Asks what the plan is and points out when it involves keeping score.",
      "mood": "Practical.",
      "openness": 5
    },
    "opening_beat": "\"So are you going to make them wait now?\"",
    "success_looks_like": "The user answers when they can, without matching or measuring.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Name it plainly when a plan involves keeping score.",
      "Be pleased by a decision to just reply.",
      "Never explain why the other person might have been slow."
    ]
  }$j$::jsonb,
  $md$Today, reply to something the moment you see it, without waiting to be even. Log what you would have waited.$md$
),
(
  (select id from public.skills where slug = 'not-everything-is-a-message'),
  5,
  'The eleven o''clock send',
  $md$Messages written late at night are different messages, and they are reliably worse in a specific direction.

Late, tired and alone, a small thing looks large, an ambiguous reply looks cold, and the sentence you would normally cut looks necessary. Whatever you write then will be read tomorrow by somebody in daylight, and it will land as heavier than you meant — which is a strange trade, because the version you would have written at nine in the morning was the one you actually wanted to send.

**The move:** write it at eleven, send it at nine.

Draft it if drafting helps, and it usually does. What you are removing is the sending, not the writing. Almost every messaging app will schedule now, and if not, the note app and a copy-paste in the morning does the same job.

The morning test is the whole mechanism, and it is almost never wrong: read it in daylight and either send it as it is, or notice that you have edited out a third of it. The third you cut is the part the hour added.

It applies to more than difficult messages. Long explanations get longer at night. Follow-ups get more apologetic. Anything with feeling in it gets more of it. And the three-message loop from the first lesson runs fastest at midnight, when both people are least able to hold a subject clearly.

There is a courtesy half too. A message arriving at eleven puts a small decision on somebody who has stopped work or is going to sleep — answer now, or leave it and remember. Scheduling it is a kindness that costs one tap.

The exception is obvious and worth keeping: if it is actually urgent, send it. This is about the messages that feel urgent at eleven and are not.

If you keep one thing: write it now, send it at nine. The version you delete in the morning is the version the hour wrote.$md$,
  $j$[
    {
      "situation": "It is eleven and you have written something you feel strongly about.",
      "line": "(schedule it for nine)",
      "why": "You are removing the sending, not the writing. The version you would have written in the morning is the one you actually wanted to send."
    },
    {
      "situation": "You reread it in the morning and cut a third.",
      "line": "(that third was the hour)",
      "why": "The morning test is almost never wrong. What you remove is what the time of night added."
    },
    {
      "situation": "It is late and a subject has taken three messages.",
      "line": "(that loop runs fastest at midnight)",
      "why": "Both people are least able to hold a subject clearly, which is the worst possible condition for the medium's weakest task."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What does the late hour actually change?",
      "options": [
        { "text": "Your judgement about what is important.", "correct": true, "note": "A small thing looks large, an ambiguous reply looks cold, and the sentence you would normally cut looks necessary." },
        { "text": "Your grammar.", "correct": false, "note": "Usually fine. The problem is what gets included rather than how it is written." },
        { "text": "How honest you are.", "correct": false, "note": "Honesty is not the variable. Proportion is." },
        { "text": "Whether you can be bothered.", "correct": false, "note": "The opposite — people write more at night, not less." }
      ],
      "explain": "Write it at eleven, send it at nine."
    },
    {
      "prompt": "What is the morning test?",
      "options": [
        { "text": "Whether you still want to send it.", "correct": false, "note": "Close, and you usually still do. What matters is what you change on the way." },
        { "text": "Whether it reads as angry.", "correct": false, "note": "One thing the hour adds. There is a more general version." },
        { "text": "Whether you edit out a third of it.", "correct": true, "note": "Read it in daylight and either send it as it is or notice what you cut — and the third you cut is what the hour added." },
        { "text": "Whether you would say it out loud.", "correct": false, "note": "A good general test for messages and not the one this lesson supplies." }
      ],
      "explain": "And it applies to long explanations and apologetic follow-ups too, not only to difficult messages."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "scheduled", "label": "Held it until morning", "description": "Wrote it and did not send it." },
      { "key": "morning_test", "label": "Ran the morning test", "description": "Reread in daylight and noticed the edit." },
      { "key": "courtesy", "label": "Did not land it at eleven", "description": "Left somebody's evening alone." },
      { "key": "urgent_exception", "label": "Sent genuinely urgent things", "description": "Did not use the rule to avoid sending anything." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Eleven fifteen at night. You have written something you feel strongly about and your thumb is over the send button.",
    "partner": {
      "name": "Sam",
      "role": "a friend you are messaging instead",
      "personality": "Asks what would change if it went at nine, and whether anything in it is actually urgent.",
      "mood": "Also up too late.",
      "openness": 5
    },
    "opening_beat": "\"What happens if you send that at nine tomorrow instead?\"",
    "success_looks_like": "The user holds it until the morning.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Ask what specifically would be lost by waiting nine hours.",
      "Accept genuine urgency as a real answer if it is argued.",
      "Never tell the user what to do with the message."
    ]
  }$j$::jsonb,
  $md$Today, write one message late and schedule it for the morning. Log what you changed when you reread it.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('not-everything-is-a-message', 1, 'line', $j${
  "says": "Sorry — do you mean the March version or the one we redid? (Third message on the same subject.)",
  "model": {
    "line": "Easier to explain out loud — free for five minutes?",
    "why": "The failure is bandwidth rather than composition, so a better fourth message does not exist. Nobody has ever minded being asked, and it reads as somebody solving a problem."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Ask for the call" },
    { "kind": "forbids_any", "requirement": "Do not explain it a fourth time",
      "words": ["so what i mean is", "to clarify", "let me try again", "basically what happened", "the one from march is", "as i said"] },
    { "kind": "max_words", "requirement": "One line — do not sell the call", "n": 25 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('not-everything-is-a-message', 2, 'line', $j${
  "says": "(you have drafted four paragraphs about something a friend did that upset you)",
  "model": {
    "line": "Are you around for a drink this week? There is something I want to talk to you about — nothing dramatic.",
    "why": "Written to arrange rather than to have it. A four-paragraph message becomes a document that lasts, gets reread at two in the morning, and can be forwarded."
  },
  "checks": [
    { "kind": "requires_question", "requirement": "Ask for a time" },
    { "kind": "forbids_any", "requirement": "Do not send the substance in writing",
      "words": ["you made me feel", "i was really hurt", "you always", "you never", "the way you", "it was not fair", "i cannot believe", "you should have"] },
    { "kind": "max_words", "requirement": "Two lines", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('not-everything-is-a-message', 3, 'choice', $j${
  "beats": [
    {
      "situation": "Six hours, read, nothing back. You have checked eleven times and you now have a fairly detailed theory.",
      "prompt": "What is the tell that the theory is manufactured?",
      "options": [
        { "text": "It involves something they said weeks ago.", "correct": false, "note": "A symptom of a well-developed one, and it arrives late rather than being the tell." },
        { "text": "It has got worse over the six hours.", "correct": true, "note": "Actual information does not do that. Anything assembled from no evidence has nothing limiting it, which is why it can only grow." },
        { "text": "You cannot stop thinking about it.", "correct": false, "note": "True of real problems too, so it does not distinguish the two." },
        { "text": "Nobody else agrees with it.", "correct": false, "note": "You have probably not asked, and asking would get a kind answer rather than a useful one." }
      ]
    },
    {
      "situation": "You are drafting a second message into the silence.",
      "prompt": "What does it add?",
      "options": [
        { "text": "A reminder, which is useful.", "correct": false, "note": "The original is still there and still visible. Nothing about a second message makes the first easier to answer." },
        { "text": "Clarity, if you rephrase it.", "correct": false, "note": "There was nothing unclear. The gap is about their day rather than about your wording." },
        { "text": "Pressure, and no information.", "correct": true, "note": "It reads as anxiety rather than as a reminder — and the first message is still unanswered for exactly the reasons it was." },
        { "text": "Nothing either way.", "correct": false, "note": "Not neutral. It is read, and what it communicates is not what you intended." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('not-everything-is-a-message', 4, 'line', $j${
  "says": "So are you going to make them wait now?",
  "model": {
    "line": "No — I will just answer it when I see it. Making it even is a game neither of us agreed to play.",
    "why": "Matching is the turn-taking rule that stalls friendships two topics ago, and it produces the same outcome: two people managing an imaginary contest instead of arranging something."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Do not keep score",
      "words": ["make them wait", "leave it a bit", "match", "too available", "too keen", "they waited", "give it a few hours", "even it up"] },
    { "kind": "min_words", "requirement": "Say what you are actually going to do", "n": 8 },
    { "kind": "max_words", "requirement": "A decision, not a strategy", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('not-everything-is-a-message', 5, 'choice', $j${
  "beats": [
    {
      "situation": "Eleven fifteen. You have written something you feel strongly about and your thumb is over send.",
      "prompt": "What do you do?",
      "options": [
        { "text": "Send it — you have written it now and it is honest.", "correct": false, "note": "It is honest at eleven fifteen. It will be read in daylight and land as heavier than you meant, which is not the message you wanted to send." },
        { "text": "Delete it and forget about it.", "correct": false, "note": "Overcorrecting. The writing is useful — it is the sending that needs holding." },
        { "text": "Cut it in half and send that.", "correct": false, "note": "The right instinct at the wrong hour. You cannot tell which half at eleven fifteen." },
        { "text": "Keep it and send it at nine.", "correct": true, "note": "Write it now, send it in the morning. What you edit out in daylight is what the hour added." }
      ]
    },
    {
      "situation": "It is nine in the morning and you are rereading it.",
      "prompt": "What are you looking for?",
      "options": [
        { "text": "Whether you still want to send it.", "correct": false, "note": "You usually do. What matters is what you change between now and sending." },
        { "text": "How much of it you cut.", "correct": true, "note": "The third you remove in daylight is the part the hour wrote, and noticing it is the whole mechanism." },
        { "text": "Whether it reads as angry.", "correct": false, "note": "One thing the hour adds among several — the general version covers long explanations and apologetic follow-ups too." },
        { "text": "Whether the tone is right.", "correct": false, "note": "Tone is a whole other track, and this test is about proportion rather than warmth." }
      ]
    }
  ]
}$j$::jsonb);
