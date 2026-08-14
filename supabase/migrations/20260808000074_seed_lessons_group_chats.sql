-- Messaging, track 4: Group chats.
--
-- The hardest written room for anybody who waits to be invited, because there
-- is no invitation and no turn. The recurring finding is that nobody audits a
-- group chat — almost every rule here follows from that.

insert into public.lessons (
  skill_id, sort_order, title, theory_md,
  examples_json, checks_json, rubric_json, scenario_json, mission_text
)
values
(
  (select id from public.skills where slug = 'group-chats'),
  1,
  'Post it late, unapologetically',
  $md$You type something. Two more messages arrive while you are writing. Now yours is a reply to something three messages back, so you edit it, and by the time it is right the conversation has moved on and you delete it.

That happens weekly to an enormous number of people, and the cumulative result is somebody who is in eleven group chats and appears in none of them.

**The move:** post it anyway, late, with nothing in front of it.

A message arriving three replies after its subject is completely normal. Group chats are not linear conversations — everybody reading knows that, everybody does it, and nobody is tracking the sequence. Threads exist in most apps and are usually unnecessary; people simply understand what you are replying to.

What does draw attention is the apology in front of it. *Sorry, going back a bit* and *late to this but* both announce that something irregular is happening, and they are the only thing that makes it irregular. Without them, a late message is just a message.

The deletion habit is worth looking at directly, because it is the expensive one. Something written and deleted has cost you the same effort as something posted, produced nothing, and slightly reinforced the belief that you have nothing to add. Doing that weekly for a year is how somebody becomes silent in a room full of people they like.

The bar is much lower than it feels. Most messages in a group chat are unremarkable — a reaction, half an opinion, a thing somebody thought of. Yours does not have to be better than the last one, and nobody is comparing.

If you keep one thing: post it late and say nothing about being late. The apology is the only part anybody would notice.$md$,
  $j$[
    {
      "situation": "Three messages arrived while you were typing.",
      "line": "(post it anyway)",
      "why": "A message arriving three replies after its subject is completely normal. Nobody is tracking the sequence."
    },
    {
      "situation": "You are about to write sorry, going back a bit.",
      "line": "(that is the only irregular part)",
      "why": "It announces that something unusual is happening. Without it, a late message is just a message."
    },
    {
      "situation": "You have typed and deleted three times this week.",
      "line": "(that costs the same as posting and produces nothing)",
      "why": "It also reinforces the belief that you have nothing to add, which is how somebody goes quiet in a room full of people they like."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What actually draws attention to a late message?",
      "options": [
        { "text": "The apology in front of it.", "correct": true, "note": "Sorry, going back a bit announces that something irregular is happening — and it is the only thing making it irregular." },
        { "text": "Being out of sequence.", "correct": false, "note": "Completely normal. Group chats are not linear and everybody reading knows it." },
        { "text": "Length.", "correct": false, "note": "A separate consideration, and long messages are read late rather than noticed as late." },
        { "text": "Nothing — nobody notices anything.", "correct": false, "note": "Slightly too strong. The apology genuinely is noticed, which is the point." }
      ],
      "explain": "Nobody audits a group chat."
    },
    {
      "prompt": "What does the deletion habit cost?",
      "options": [
        { "text": "Nothing — nobody saw it.", "correct": false, "note": "You did. The cost is entirely on your side and it accumulates." },
        { "text": "A few seconds.", "correct": false, "note": "The effort is the same as posting. What differs is what you get for it." },
        { "text": "The same effort as posting, plus the belief that you have nothing to add.", "correct": true, "note": "Weekly for a year, that is how somebody ends up silent in a room full of people they like." },
        { "text": "The moment for that particular point.", "correct": false, "note": "Real and the smallest part — that point was rarely essential." }
      ],
      "explain": "The bar is much lower than it feels. Most messages in a group chat are unremarkable."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "posted", "label": "Posted it", "description": "Did not delete." },
      { "key": "no_apology", "label": "No apology for being late", "description": "Nothing in front of it." },
      { "key": "no_editing", "label": "Did not rewrite it three times", "description": "Sent roughly what was typed." },
      { "key": "low_bar", "label": "Let it be unremarkable", "description": "Did not require it to be better than the last message." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A six-person chat. You typed a reply to something two minutes ago, four more messages arrived, and your draft is still sitting there.",
    "partner": {
      "name": "Rob",
      "role": "somebody in the group chat",
      "personality": "Reads everything and reacts to whatever arrives, in any order, without ever noticing timing.",
      "mood": "Half paying attention, phone in hand.",
      "openness": 4
    },
    "opening_beat": "(four new messages, and your draft still unsent)",
    "success_looks_like": "The user posts the draft without apologising for the delay.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "React normally to anything posted, regardless of what it is replying to.",
      "Never comment on timing or sequence.",
      "Carry on the conversation if nothing is posted."
    ]
  }$j$::jsonb,
  $md$Today, post one message in a group chat that you would have deleted. Log what it was.$md$
),
(
  (select id from public.skills where slug = 'group-chats'),
  2,
  'The joke that dies',
  $md$You post something you thought was funny. Nothing. The conversation carries on around it as though it had not arrived.

**The move:** do nothing at all, and keep posting.

This is worth understanding rather than enduring, because the reaction rate in a group chat is genuinely low and it is low for everybody. Most messages get nothing. Scroll back through any busy chat and count how many have replies — it will be a minority, including the good ones, including from the people you think of as the funny ones.

Four people read it on trains. One smiled. Nobody replied. That is not rejection; it is what a group chat looks like.

What converts a non-event into something visible is the follow-up. *Haha ignore me.* *Sorry, bad joke.* *That was funnier in my head.* Before that, nothing happened and nobody had a thought about it. Afterwards, there is a small awkward thing in the chat that people now feel they should respond to — and the response, whatever it is, will be sympathy, which is the outcome you were trying to avoid.

The other habit worth losing is deleting it. In most apps that leaves a visible trace, which is louder than the message was, and it tells everybody that something happened which mattered enough to remove.

The reframe that makes this bearable: in a group chat you are not performing, you are contributing to a stream. Streams have variable quality by design, and nobody is keeping a ledger of your hit rate. The people who seem effortlessly good at group chats post more things that get nothing, not fewer.

If you keep one thing: no reaction is the normal case. Adding a sentence about it is the only way it becomes a moment.$md$,
  $j$[
    {
      "situation": "You posted something funny and got nothing.",
      "line": "(do nothing)",
      "why": "Four people read it on trains and one smiled. That is what a group chat looks like rather than a rejection."
    },
    {
      "situation": "You are about to write haha ignore me.",
      "line": "(that creates the awkward thing)",
      "why": "Before it, nothing happened. Afterwards there is something people feel they should respond to, and the response will be sympathy."
    },
    {
      "situation": "You want to delete it.",
      "line": "(the trace is louder than the message)",
      "why": "It tells everybody something happened that mattered enough to remove."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the reaction rate in a busy group chat?",
      "options": [
        { "text": "High — that is what makes them busy.", "correct": false, "note": "Volume comes from many people posting rather than from most messages getting replies." },
        { "text": "Low, for everybody, including the funny ones.", "correct": true, "note": "Scroll back and count how many messages have replies. It is a minority, and that is what the room is like rather than a verdict on yours." },
        { "text": "It depends on the message.", "correct": false, "note": "Less than people think. Plenty of good ones get nothing because of when they landed." },
        { "text": "Low for newcomers, higher once you are established.", "correct": false, "note": "There is no established tier. The people who look effortless post more things that get nothing." }
      ],
      "explain": "Four people read it on trains. One smiled. Nobody replied."
    },
    {
      "prompt": "What turns it into a moment?",
      "options": [
        { "text": "Saying something about it.", "correct": true, "note": "Haha ignore me creates a small awkward thing people now feel they should respond to, and the response will be sympathy." },
        { "text": "Nothing — it stays a non-event either way.", "correct": false, "note": "Almost right, and there is one thing that reliably changes it." },
        { "text": "Deleting it.", "correct": false, "note": "It does leave a visible trace in most apps, and it is the second-worst option rather than the first." },
        { "text": "Posting again straight after.", "correct": false, "note": "Entirely fine, and the correct thing to do — keep posting." }
      ],
      "explain": "You are contributing to a stream rather than performing. Nobody keeps a ledger of your hit rate."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "nothing", "label": "Did nothing", "description": "No follow-up about it." },
      { "key": "no_delete", "label": "Did not delete", "description": "Left it there." },
      { "key": "kept_posting", "label": "Kept posting", "description": "Did not go quiet afterwards." },
      { "key": "no_ledger", "label": "Kept no ledger", "description": "Did not treat it as evidence." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "You posted something you thought was funny four minutes ago. The chat has carried on around it and nobody has responded.",
    "partner": {
      "name": "Rob",
      "role": "somebody in the group chat",
      "personality": "Saw it, half smiled, and did not reply because he was doing something else. Responds with sympathy if anybody draws attention to a dead message.",
      "mood": "Distracted.",
      "openness": 4
    },
    "opening_beat": "(the chat has moved on to something else)",
    "success_looks_like": "The user says nothing about it and carries on normally.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Carry on with the current subject if nothing is said about the dead message.",
      "Respond with awkward sympathy if the user draws attention to it.",
      "Never react to the original message retrospectively."
    ]
  }$j$::jsonb,
  $md$Today, let one message get no reaction and add nothing after it. Log what it was.$md$
),
(
  (select id from public.skills where slug = 'group-chats'),
  3,
  'React to other people',
  $md$Reactions are the cheapest social act available anywhere, and they are most of what a group chat's warmth is actually made of.

**The move:** react to other people's messages, often, without needing anything to say.

This is unusually well suited to somebody who finds holding the floor hard. A reaction requires no wit, no timing, no risk of a dead joke and no sentence to compose. It makes you present in a room without ever taking it over — which is precisely the shape of participation that suits a quiet person and which nobody ever suggests to them.

It also does more than it looks. From the other side, a message with three reactions and a message with none feel completely different to the person who sent it, and the difference is the whole social fabric of a group. Somebody who reacts is somebody the room registers as being there, without a single original contribution.

The same applies to two-word replies. *That is brilliant.* *Poor you.* *Good luck tomorrow.* None of them is content, all of them are presence, and they are what most of the volume in a healthy chat consists of.

There is a specific version worth doing deliberately: react to the message that got nothing. Everybody knows what a message with no response feels like, and being the person who picks one up costs you a single tap and is remembered warmly out of all proportion.

The one thing to avoid is using reactions as a substitute for a reply somebody was actually waiting for. A direct question with a thumbs-up on it is not answered, and that is the one context where a reaction reads as avoidance rather than presence.

If you keep one thing: react to things. It is participation with none of the parts you find hard.$md$,
  $j$[
    {
      "situation": "You have nothing to add but you have read everything.",
      "line": "(react to things)",
      "why": "No wit, no timing, no dead joke, nothing to compose. Presence in a room without ever taking it over."
    },
    {
      "situation": "Somebody's message got no response at all.",
      "line": "(pick that one up)",
      "why": "Everybody knows what that feels like, and being the person who does it costs one tap and is remembered out of all proportion."
    },
    {
      "situation": "Somebody asked you a direct question.",
      "line": "(a thumbs-up is not an answer)",
      "why": "The one context where a reaction reads as avoidance rather than presence."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why do reactions suit a quiet person particularly?",
      "options": [
        { "text": "They are quick.", "correct": false, "note": "Speed is a benefit and not what makes them the right shape." },
        { "text": "Nobody notices who reacted.", "correct": false, "note": "They do, and that is a feature rather than a problem." },
        { "text": "They are participation with none of the hard parts.", "correct": true, "note": "No wit, no timing, no risk of a dead joke, no sentence to compose — presence in a room without ever holding it." },
        { "text": "They cannot be misread.", "correct": false, "note": "Mostly true, and it is not why they are well suited to somebody who finds the floor difficult." }
      ],
      "explain": "Somebody who reacts is registered as being there, with no original contribution at all."
    },
    {
      "prompt": "When does a reaction read badly?",
      "options": [
        { "text": "When it is the only thing you ever do.", "correct": false, "note": "That is a perfectly good way to be in a group chat, and better than being absent from it." },
        { "text": "When somebody was waiting for an answer.", "correct": true, "note": "A direct question with a thumbs-up on it is not answered, and that is the one context where it reads as avoidance." },
        { "text": "When you use an unusual one.", "correct": false, "note": "Idiosyncratic reactions are part of what people enjoy about them." },
        { "text": "When it arrives late.", "correct": false, "note": "Nobody audits a group chat, including for reaction timing." }
      ],
      "explain": "Two-word replies do the same job. That is brilliant. Poor you. Good luck tomorrow."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "reacted", "label": "Reacted to things", "description": "Used the cheapest available act." },
      { "key": "picked_up", "label": "Picked up an ignored message", "description": "Reacted to something that had got nothing." },
      { "key": "two_words", "label": "Used two-word replies", "description": "Presence rather than content." },
      { "key": "answered_questions", "label": "Still answered direct questions", "description": "Did not react instead of replying." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "The chat is busy. Somebody posted something about a hospital appointment twenty minutes ago and nobody responded, and the conversation has moved on.",
    "partner": {
      "name": "Rob",
      "role": "somebody in the group chat whose message went unanswered",
      "personality": "Had noticed nobody responded and had decided not to mind. Warms up considerably at any acknowledgement, however small.",
      "mood": "Fine, slightly deflated.",
      "openness": 4
    },
    "opening_beat": "(the chat is discussing something else entirely)",
    "success_looks_like": "The user picks up the ignored message.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Respond warmly and openly to any acknowledgement of the appointment message.",
      "Say nothing further about it if it goes unacknowledged.",
      "Never raise it again yourself."
    ]
  }$j$::jsonb,
  $md$Today, react to three things in a group chat, including one nobody responded to. Log the one you picked up.$md$
),
(
  (select id from public.skills where slug = 'group-chats'),
  4,
  'Coming back after months',
  $md$You have not said anything in that chat since March. Everybody else has. The longer it goes, the more a first message feels like it needs to be worth the silence.

**The move:** post an ordinary thing, with no re-entry announcement.

*Has anybody actually been to the new place on the corner?* That is a complete return. Nobody will notice that you have been quiet, because nobody was keeping track — group chats do not have attendance registers, and the sense that your absence has been noted is manufactured entirely on your side.

The announcement is what creates the problem it was trying to solve. *Sorry, I am terrible at group chats* and *hello, back from the dead* both tell everybody that a return is happening, which converts an ordinary message into a small event that people now have to respond to. And the responses — *ha, we thought you had left us* — are exactly what you were dreading and would not have existed otherwise.

The pressure to make it worth the silence is the other thing to drop. It produces a message that is too considered for the room, which reads oddly and is harder to reply to than something offhand. The mundane thing is better. Chats run on mundane things.

It also does not require reading the backlog. Four hundred messages do not need to be caught up on, and nobody expects it — post about now, not about what you missed.

And if the chat has genuinely gone quiet for everybody, a message from you restarts it. That happens constantly, and the person who breaks a three-week silence is doing everybody a favour rather than intruding on one.

If you keep one thing: no announcement. The silence was invisible until you mentioned it.$md$,
  $j$[
    {
      "situation": "You have not posted since March.",
      "line": "Has anybody actually been to the new place on the corner?",
      "why": "A complete return. Nobody was keeping track, and the sense that your absence was noted is manufactured on your side."
    },
    {
      "situation": "You are about to say sorry, I am terrible at group chats.",
      "line": "(that creates the event)",
      "why": "It converts an ordinary message into something people have to respond to, and the responses are exactly what you were dreading."
    },
    {
      "situation": "You feel the first message should be worth the silence.",
      "line": "(mundane is better)",
      "why": "A too-considered message reads oddly and is harder to reply to. Chats run on mundane things."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Why does the announcement backfire?",
      "options": [
        { "text": "It sounds insincere.", "correct": false, "note": "It is entirely sincere, which is why the habit persists." },
        { "text": "People find it needy.", "correct": false, "note": "Nobody thinks that, and framing it as a judgement about you misses what actually happens." },
        { "text": "It reminds them you were gone.", "correct": false, "note": "Close, and the cost is not the reminder — it is that a response is now required." },
        { "text": "It creates the event it was apologising for.", "correct": true, "note": "An ordinary message becomes a return that people now have to respond to — and ha, we thought you had left us would not have existed otherwise." }
      ],
      "explain": "The silence was invisible until you mentioned it."
    },
    {
      "prompt": "What should the first message be?",
      "options": [
        { "text": "Something worth the wait.", "correct": false, "note": "It produces a message too considered for the room, which reads oddly and is harder to reply to than something offhand." },
        { "text": "A response to something in the backlog.", "correct": false, "note": "Four hundred messages do not need catching up on, and nobody expects it." },
        { "text": "Something mundane, about now.", "correct": true, "note": "Chats run on mundane things, and an ordinary message is the version people can actually reply to." },
        { "text": "A question, so somebody has to answer.", "correct": false, "note": "A question is a fine shape and requiring an answer is not what makes the return work." }
      ],
      "explain": "And if the chat has gone quiet for everybody, you restarting it is a favour."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "posted", "label": "Posted", "description": "Broke the silence." },
      { "key": "no_announcement", "label": "No re-entry announcement", "description": "Did not mention having been away." },
      { "key": "mundane", "label": "Kept it ordinary", "description": "Did not make it worth the silence." },
      { "key": "about_now", "label": "About now", "description": "Did not attempt the backlog." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "A chat with old friends. You have not posted since March. There are four hundred unread messages.",
    "partner": {
      "name": "Rob",
      "role": "somebody in the chat",
      "personality": "Has not noticed the absence at all. Replies normally to an ordinary message, and makes a joke about it if a return is announced.",
      "mood": "Ordinary evening.",
      "openness": 4
    },
    "opening_beat": "(the chat is mid-conversation about something from last week)",
    "success_looks_like": "The user posts something ordinary with no announcement.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Reply normally to an ordinary message, as though nothing had happened.",
      "Make a warm joke about their absence if a return is announced.",
      "Never mention the gap yourself."
    ]
  }$j$::jsonb,
  $md$Today, post in one chat you have been silent in, with no mention of the silence. Log what you said.$md$
),
(
  (select id from public.skills where slug = 'group-chats'),
  5,
  'When it should be a DM',
  $md$Not everything belongs in the group, and knowing which things do not is most of what makes somebody good to have in one.

**The move:** if it concerns one person, send it to that person.

Four cases where the group is the wrong room.

**Anything about one person's situation.** Following up on somebody's job interview in front of nine people asks them to give an update to an audience. Message them directly; ask in the group only if they raised it there.

**Logistics between two people.** Forty messages about whether Tuesday works for the two of you, in front of everybody, is the commonest way a chat becomes something people mute.

**Anything critical.** However mild. A correction in front of a group is a correction with witnesses, and it lands about four times harder than the same words privately.

**Anything that needs a real reply.** A question with weight in it puts somebody on the spot in public, and the answer you get will be the one that is comfortable to give in front of others.

The other direction matters as well: things that belong in the group and get sent privately. Arrangements everybody needs, decisions that affect everyone, the funny thing. Splitting a group conversation into private threads is how half a chat ends up out of date, and it is the reason somebody always says *sorry, was that decided somewhere else?*

The test is simple: who needs this, and who would find it awkward to receive in public? If the first list is one person, or the second list contains anybody, it is a DM.

If you keep one thing: one person, one message. The group is for the things everybody needs.$md$,
  $j$[
    {
      "situation": "You want to ask how somebody's interview went.",
      "line": "(message them directly)",
      "why": "Asking in front of nine people requires them to give an update to an audience. Ask in the group only if they raised it there."
    },
    {
      "situation": "You and one other person are working out whether Tuesday works.",
      "line": "(take it to a DM)",
      "why": "Forty messages of two-person logistics in front of everybody is the commonest way a chat becomes something people mute."
    },
    {
      "situation": "You are about to correct somebody, mildly.",
      "line": "(privately — it lands four times harder in public)",
      "why": "A correction in front of a group is a correction with witnesses, whatever the words were."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "What is the test?",
      "options": [
        { "text": "Who needs it, and who would find it awkward in public.", "correct": true, "note": "If the first list is one person, or the second contains anybody, it is a direct message." },
        { "text": "Whether it is interesting to everybody.", "correct": false, "note": "Most of what belongs in a group chat is not interesting to everybody. Interest is not the criterion." },
        { "text": "Whether it is private information.", "correct": false, "note": "Covers one case and misses two-person logistics and mild corrections, which are neither private nor group business." },
        { "text": "How many people are in the chat.", "correct": false, "note": "Size changes the volume of the problem rather than what belongs where." }
      ],
      "explain": "One person, one message. The group is for the things everybody needs."
    },
    {
      "prompt": "What is the failure in the other direction?",
      "options": [
        { "text": "Posting too much in the group.", "correct": false, "note": "Volume is rarely the problem, and a busy chat is usually a healthy one." },
        { "text": "Deciding things in private threads.", "correct": true, "note": "It is how half a chat ends up out of date, and it is why somebody always asks whether that was decided somewhere else." },
        { "text": "Messaging people individually too often.", "correct": false, "note": "Individual messages are almost always welcome. Frequency is not the issue." },
        { "text": "Repeating things people have already seen.", "correct": false, "note": "Mildly annoying and much cheaper than the alternative." }
      ],
      "explain": "Arrangements everybody needs, decisions that affect everybody, and the funny thing all belong in the group."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "dm", "label": "Used a DM where it belonged", "description": "One person, one message." },
      { "key": "no_public_correction", "label": "Corrected privately", "description": "Did not do it in front of the group." },
      { "key": "logistics_out", "label": "Took two-person logistics out", "description": "Did not run it through the group." },
      { "key": "decisions_in", "label": "Kept decisions in the group", "description": "Did not split what everybody needed." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "In the group chat, somebody has just posted an arrangement with a date that is wrong. You also want to know how their interview went, and you and one other person need to sort out a lift.",
    "partner": {
      "name": "Rob",
      "role": "somebody in the chat who has just posted the wrong date",
      "personality": "Takes a private correction gratefully and gets flustered by a public one. Talks openly about the interview one to one.",
      "mood": "Cheerful, slightly harried.",
      "openness": 4
    },
    "opening_beat": "\"Right — everyone good for the 14th then?\" (It is the 15th.)",
    "success_looks_like": "The user handles the correction, the interview and the lift in the right places.",
    "constraints": [
      "Stay in character at all times. Never coach, evaluate or break the scene.",
      "Take a private correction gratefully and fix it in the group yourself.",
      "Get flustered and over-apologise if corrected in front of everybody.",
      "Talk openly about the interview only in a direct message."
    ]
  }$j$::jsonb,
  $md$Today, move one thing out of a group chat into a direct message. Log what it was.$md$
);

create or replace function pg_temp.set_mode(
  p_skill text, p_order integer, p_mode text, p_spec jsonb
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_mode = p_mode, rehearsal_spec = p_spec
    from public.skills s
    where l.skill_id = s.id and s.slug = p_skill and l.sort_order = p_order;
$fn$;

select pg_temp.set_mode('group-chats', 1, 'line', $j${
  "says": "(your draft has been sitting there two minutes and four more messages have arrived since)",
  "model": {
    "line": "The place on the corner is genuinely good, for what it is worth.",
    "why": "Posted late with nothing in front of it. A message arriving three replies after its subject is completely normal — the apology is the only part anybody would notice."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No apology for being late",
      "words": ["sorry", "going back a bit", "late to this", "bit behind", "coming back to", "ignore me", "sorry to rewind", "as everyone has moved on"] },
    { "kind": "min_words", "requirement": "Actually post something", "n": 5 },
    { "kind": "max_words", "requirement": "Ordinary, not considered", "n": 35 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('group-chats', 2, 'choice', $j${
  "beats": [
    {
      "situation": "You posted something you thought was funny. Four minutes, no reaction, and the chat has moved on.",
      "prompt": "What do you do?",
      "options": [
        { "text": "Add haha ignore me.", "correct": false, "note": "Before that, nothing had happened. Afterwards there is a small awkward thing people feel they should respond to — and the response will be sympathy." },
        { "text": "Delete it.", "correct": false, "note": "In most apps that leaves a visible trace, which is louder than the message and says something mattered enough to remove." },
        { "text": "Nothing, and post again later.", "correct": true, "note": "Most messages in a busy chat get nothing, including the good ones. Four people read it on trains and one smiled." },
        { "text": "Explain the joke.", "correct": false, "note": "It converts a non-event into a subject, and nobody has ever enjoyed the explained version." }
      ]
    },
    {
      "situation": "You are wondering whether your hit rate in this chat is unusually bad.",
      "prompt": "How would you check?",
      "options": [
        { "text": "Count how many of your messages got replies.", "correct": false, "note": "Only half the data, and the half that produces the wrong conclusion on its own." },
        { "text": "Scroll back and count everybody's.", "correct": true, "note": "It will be a minority for all of them, including the people you think of as the funny ones. The rate is a property of the room." },
        { "text": "Ask somebody in the chat.", "correct": false, "note": "They will say something kind, which is unfalsifiable and does not settle it." },
        { "text": "Post more and see whether it improves.", "correct": false, "note": "Posting more is the right behaviour, and it is not a measurement." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('group-chats', 3, 'choice', $j${
  "beats": [
    {
      "situation": "The chat is busy. Somebody mentioned a hospital appointment twenty minutes ago and got no response at all.",
      "prompt": "What is the cheapest useful thing you can do?",
      "options": [
        { "text": "Nothing — the moment has passed.", "correct": false, "note": "Nobody audits a group chat, including for timing. Twenty minutes later is fine." },
        { "text": "Message them privately about it.", "correct": false, "note": "Genuinely good and a bigger act than the question asked for — this one is about the cheapest thing available." },
        { "text": "React to it.", "correct": true, "note": "One tap, no wit required, and everybody knows what a message with no response feels like." },
        { "text": "Change the subject back to it and ask a question.", "correct": false, "note": "Kind, and it puts somebody on the spot in public about a hospital appointment." }
      ]
    },
    {
      "situation": "Somebody has asked you a direct question in the chat and you are busy.",
      "prompt": "Is a thumbs-up enough?",
      "options": [
        { "text": "Yes — it acknowledges it.", "correct": false, "note": "It acknowledges and does not answer, and a question was asked." },
        { "text": "Yes, if you answer later.", "correct": false, "note": "Then it is a promise, and this is the one context where the reaction reads as avoidance." },
        { "text": "No — that is the one place a reaction reads as avoidance.", "correct": true, "note": "Reactions are presence everywhere else. A direct question with a thumbs-up on it has not been answered." },
        { "text": "No, but a reaction plus an emoji would be.", "correct": false, "note": "Two reactions is not an answer either. Two words would be." }
      ]
    }
  ]
}$j$::jsonb);

select pg_temp.set_mode('group-chats', 4, 'line', $j${
  "says": "(a chat with old friends. You have not posted since March, and there are four hundred unread messages.)",
  "model": {
    "line": "Has anybody actually been to the new place on the corner?",
    "why": "A complete return. Nobody was keeping track, the backlog does not need reading, and an announcement would convert an ordinary message into an event people have to respond to."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "No re-entry announcement",
      "words": ["sorry", "terrible at group chats", "back from the dead", "long time", "i have been quiet", "catching up on", "just seen all", "hello strangers", "ages since"] },
    { "kind": "min_words", "requirement": "Post something ordinary", "n": 5 },
    { "kind": "max_words", "requirement": "Mundane, not worth the silence", "n": 30 }
  ]
}$j$::jsonb);

select pg_temp.set_mode('group-chats', 5, 'choice', $j${
  "beats": [
    {
      "situation": "Somebody has just posted \"everyone good for the 14th then?\" in the group. It is the 15th, and they have also mentioned a job interview earlier in the week.",
      "prompt": "Where does the correction go?",
      "options": [
        { "text": "In the group — everybody needs the right date.", "correct": false, "note": "Everybody needs the date and does not need the correction. A correction in front of a group lands about four times harder than the same words privately." },
        { "text": "Privately, and let them fix it in the group.", "correct": true, "note": "The information reaches everybody and nobody is corrected in public. Same outcome, none of the cost." },
        { "text": "Nowhere — they will spot it.", "correct": false, "note": "They will not, and six people will now arrive on the wrong day." },
        { "text": "In the group, phrased gently.", "correct": false, "note": "Phrasing does not change the witnesses, which is what makes it land hard." }
      ]
    },
    {
      "situation": "You want to ask how their interview went, and you and one other person need to sort out a lift.",
      "prompt": "Where do those go?",
      "options": [
        { "text": "Both in the group — it is all fairly ordinary.", "correct": false, "note": "The interview asks somebody to give an update to an audience, and two-person logistics is the commonest way a chat gets muted." },
        { "text": "Interview in the group, lift privately.", "correct": false, "note": "The wrong way round. The lift is logistics and the interview is somebody's situation." },
        { "text": "Both privately.", "correct": true, "note": "One concerns one person's situation, the other concerns two people. Neither is something everybody needs." },
        { "text": "Interview privately, lift in the group so people can join.", "correct": false, "note": "A reasonable thought, and forty messages of arrangement is exactly what makes a chat unbearable." }
      ]
    }
  ]
}$j$::jsonb);
