-- Messaging: the five tracks.
--
-- The topic's promise names both halves — ask for what you need without three
-- paragraphs of apology in front of it, and be the person who is easy to reply
-- to — and tracks one and two are those two things.
--
-- Three boundaries, all with topics that already own the neighbouring ground.
-- Dating apps owns the first message to a match and everything from match to
-- date. Making friends owns the message with no ask in it, which is
-- maintenance rather than mechanics. Hard conversations owns what to say when
-- something is difficult; track five here only decides whether a message is
-- the right container for it at all.
--
-- Track one is the most mission-relevant thing in the topic and possibly in
-- the app. A quiet person's habits are more visible in writing than anywhere
-- else — the apology, the hedge, the word "just" — and writing is also where
-- they are most fixable, because you can see them before you press send.
--
-- No lessons yet. Do not apply this before the first track is written.

insert into public.skills (
  topic_id, slug, name, description, core_idea, takeaway_md, sort_order
)
values
(
  (select id from public.topics where slug = 'online-chatting'),
  'stop-apologising',
  'Stop apologising',
  $$Sorry to bother you, I know you are busy, this is probably a stupid question, but — and then, eventually, the actual thing.$$,
  $$Put the ask in the first line and delete everything in front of it. The apology is what makes an ordinary request look like an imposition.$$,
  $md$*Sorry to bother you! I know you are really busy at the moment. This is probably a stupid question and feel free to ignore it, but I was just wondering whether...*

Everything before the word *whether* is doing damage, and it was all written to be polite.

**The move:** put the ask in the first line, and delete what was in front of it.

Three costs, and the first is the smallest. It makes the message longer, which makes it likelier to be left for later.

The second is that it tells the reader how to receive the request. *Sorry to bother you* asserts that this is a bother; *probably a stupid question* asserts that it is stupid. Both are almost always untrue, and you have supplied them unprompted about something the other person had no complaint with. People take these framings at face value, because there is no reason not to.

The third is the one that matters. An apology asks for a response before the actual request can be dealt with — now they have to say *no, not at all, happy to help*, which is work, and it is work created by you and about you. A message that needs reassuring before it can be answered is a harder message to answer.

The word doing most of the damage is *just*. Just wondering, just checking, just a quick one, just following up. It is a shrinking word — its entire function is to make what follows smaller — and it appears in enormous quantities in the messages of people who are worried about taking up space.

None of this is an argument for being blunt. Politeness is not apology, and *thanks, this is a big help* at the end costs nothing and reads as warmth. What you are removing is the material at the front that makes an ordinary request look like a favour.

If you keep one thing: asking somebody an ordinary question is not an imposition. The apology in front of it is the thing that makes it look like one.$md$,
  1
),
(
  (select id from public.topics where slug = 'online-chatting'),
  'easy-to-reply-to',
  'Easy to reply to',
  $$Why some people get answered in four minutes and some get answered on Thursday, which is mostly not about how important they are.$$,
  $$One ask, the ask first, and make the reply cheap. Everything you leave for the reader to work out is a reason to answer later.$$,
  $md$Some people get replied to quickly and some do not, and the difference is much less about status than people assume. It is about cost.

Every message asks the reader to do something before they can answer: read it, work out what is wanted, decide, compose. The higher that total, the further down the list it goes — and *later* is where messages go to be forgotten.

**The move:** one ask, put first, with the reply made as cheap as you can.

**One ask.** A message carrying three questions gets the easiest one answered and the other two are gone. If you need three things, that is three messages or a numbered list, and a numbered list is the version people actually work through.

**The ask first.** People read the first line and decide whether this is now or later. Context is genuinely useful and it belongs underneath — *Can you approve the invoice? Background: it is the one from March that got held up* is answerable in four seconds. The same content in the other order gets read halfway.

**Make the reply cheap.** Ask a closed question when a closed answer will do. Offer two options rather than asking somebody to generate one. Say what you will do if they do not reply, which lets silence be an answer.

**Say when you need it.** *No rush* is heard as *never* — it is well meant and it removes the only thing that would have got it prioritised. *By Thursday if possible* is not pushy, it is information.

And keep it short enough to be read on a phone in a corridor, because that is where it will be read. Anything past a screenful gets *I will read this properly later*, and later does not arrive.

If you keep one thing: everything you leave for the reader to work out is a reason to answer you on Thursday instead of now.$md$,
  2
),
(
  (select id from public.topics where slug = 'online-chatting'),
  'tone-with-no-tone',
  'Tone with no tone',
  $$Everything you write reads slightly colder than you meant it, and everything you receive is being read the same way.$$,
  $$Warmth is not in the words you would have used out loud — it has to be added on purpose. And a curt reply is almost never what it looks like.$$,
  $md$In a room, most of what you mean is carried by your face and your voice. In a message, none of it is, and the words you would have said out loud arrive without any of the things that made them warm.

The result is a consistent bias: text reads colder than it was written. Not much — but reliably, in every message, in both directions.

**The move:** add warmth deliberately when writing, and discount coldness when reading.

Writing first. A neutral sentence is not neutral on arrival, it is slightly cool, so the warmth has to be put in on purpose: a word of acknowledgement, a thank you, something that shows you have read what they said rather than only answered it. This is not decoration, it is compensation for a channel that removes the tone you would have supplied for free.

The small stuff genuinely matters here, however silly it looks written down. *Ok* and *Ok!* land differently. A full stop on a single-word reply reads as clipped to a large proportion of people. Emoji function as tone markers rather than decoration, and one is usually enough.

Then reading, which is the half that costs quiet people most. A short reply is almost never anger — it is somebody on a train, between meetings, or typing with one hand. The gap before a reply is almost never a message either. And *ok, fine* usually means ok, fine.

The habit worth breaking is decoding: rereading a message for its real meaning, finding one, and then responding to a thing that was never said. If you genuinely cannot tell, the two available moves are to ask plainly or to assume the boring explanation — and the boring explanation is right the overwhelming majority of the time.

If you keep one thing: put the warmth in on purpose, and take the coldness out of what you receive. The channel is doing it to both of you.$md$,
  3
),
(
  (select id from public.topics where slug = 'online-chatting'),
  'group-chats',
  'Group chats',
  $$Six people, no turn-taking, and a message you have typed and deleted three times while the conversation moved on.$$,
  $$Post it anyway. Nobody audits a group chat, the reaction rate is low for everybody, and being quiet is louder than anything you would have said.$$,
  $md$A group chat has no turn-taking, no eye contact and no moment when the floor is yours, which makes it the hardest written room for anybody who waits to be invited.

The pattern is recognisable. You type something. Two more messages arrive while you are writing. Now yours is a reply to something three messages back, so you edit it, and by the time it is right the conversation has moved on and you delete it. That happens weekly to a very large number of people, and the cumulative effect is somebody who is in eleven group chats and appears in none of them.

**The move:** post it anyway, and post it slightly late without apology.

Nobody audits a group chat. A message arriving three replies after its subject is completely normal — chats are not linear conversations and everybody reading knows that. What is not normal, and what draws attention, is the *sorry, going back a bit* that people put in front of it.

The reaction rate is worth knowing, because it is the thing most often misread. In a busy chat most messages get nothing, including good ones, including everybody else's. A joke that dies in a group chat has not been rejected — it has been read by four people on trains. The move afterwards is nothing at all: adding *haha ignore me* converts an unremarkable non-event into a small visible wound.

Reactions are the cheapest social act available anywhere and they are most of what a group chat's warmth is made of. Reacting to other people costs nothing, requires no wit, and makes you present in a room without ever holding the floor — which is unusually well suited to somebody who finds holding it hard.

And if you have been silent for four months: just post. There is no re-entry announcement, nobody has been keeping track, and *sorry, I am terrible at group chats* is the only thing that would make it a thing.

If you keep one thing: being quiet is louder than anything you would have said. Post it late, unapologetically, and react to other people.$md$,
  4
),
(
  (select id from public.topics where slug = 'online-chatting'),
  'not-everything-is-a-message',
  'Not everything is a message',
  $$The thing you have now explained three times in writing, and the four hours you have spent looking at a grey tick.$$,
  $$Some things are a call. And a silence is almost never a message — the meaning you are reading into a gap is not in it.$$,
  $md$Two failures live here, and they are opposite sides of treating a messaging app as though it were the whole relationship.

**The move, on sending:** if it has taken three messages to explain, stop typing and phone.

Text is very good at facts, arrangements and small asks, and quite bad at anything with nuance, disagreement or feeling in it. Past a certain complexity every additional message adds ambiguity rather than removing it — you clarify, they misread the clarification, you clarify the clarification, and forty minutes go by producing a worse understanding than a two-minute call would have.

The three-message rule is the practical version. If the same subject has needed three attempts, the medium is wrong and no amount of better wording will fix it. *Easier to explain — free for five minutes?* is not an escalation and nobody has ever minded being asked.

Anything difficult is the same call, for a stronger reason. What to say when something is hard belongs to Hard conversations; the decision here is narrower and comes first — writing removes tone, lasts for ever, is reread at somebody's lowest, and can be forwarded. Use it to arrange the conversation, not to have it.

**The move, on receiving:** a silence is not a message.

Being left on read is the thing quiet people spend the most time on and it carries almost no information. Somebody opened it in a lift, meant to answer properly, and lost it. Four hours is not a signal. A day is rarely a signal. And the meaning you construct in the gap is manufactured entirely by you, from nothing, and is reliably worse than the truth.

Two rules that follow. Do not double-message into silence — a second message before the first is answered adds pressure and no information. And do not send anything at eleven at night that you would not send at nine in the morning; write it, schedule it, and see what it looks like tomorrow.

If you keep one thing: three messages means phone. And the gap means they are busy.$md$,
  5
);
