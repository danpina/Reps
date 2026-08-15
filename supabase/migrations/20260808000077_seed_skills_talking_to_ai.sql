-- Talking to AI: the six tracks, and a restated promise.
--
-- The description this topic shipped with pointed it at prompting technique.
-- That version dates in months, has no shy-person angle, and competes with
-- content that is better elsewhere. The version worth writing is the one only
-- this app can write: how to use the tool to get better at the other ten
-- topics, without it quietly making you worse at them. An app that is itself
-- an AI product being honest about the tool is more credible than one selling
-- it, and that honesty is what tracks five and six are for.
--
-- Track two is the most mission-relevant thing here. The quiet person's
-- injury is not wanting to look stupid asking, and this is the one place a
-- question costs nothing. Almost nobody uses it that way on purpose.
--
-- Deliberately absent: coding, agents, the API, model comparison, and feature
-- tours. All useful, none of it belongs in a conversation curriculum.
--
-- Boundaries. Messaging owns the draft itself — track three only says who
-- should be holding the pen. Hard conversations and Work own what to say on
-- Tuesday; track four only covers preparing for it.
--
-- No lessons yet. Do not apply this before the first track is written.

update public.topics
  set description = $$Using it to prepare, cut and rehearse — and knowing the places it will confidently mislead you about people.$$
  where slug = 'ai-prompting';

insert into public.skills (
  topic_id, slug, name, description, core_idea, takeaway_md, sort_order
)
values
(
  (select id from public.topics where slug = 'ai-prompting'),
  'an-answer-worth-having',
  'An answer worth having',
  $$Most of what comes back is generic because most of what goes in is a description of the problem rather than the problem.$$,
  $$Give it the actual material, say what the answer is for, and argue with what comes back rather than starting again.$$,
  $md$Two people with the same subscription get wildly different value out of it, and the difference is almost entirely in what they put in.

**The move:** give it the real material, say what the answer is for, and argue with what comes back.

**Give it the actual thing.** The commonest mistake by a distance is describing the problem instead of supplying it. *I need to reply to an email from my manager about a deadline* gets you a reply to an imaginary email. Pasting the email gets you a reply to that email, which is a different order of useful. The same is true of the document, the thread, the job advert, the message you are stuck on. A description is a summary you wrote, and everything you left out is exactly what the answer needed.

**Say what it is for.** Who reads it, what you want them to do, how long it should be. The same content wants a different shape as a note to a colleague, a message to a landlord, or something you will say out loud, and it cannot infer which from the content alone.

**Push back instead of starting over.** Most people read a not-quite-right answer, delete everything, and rewrite the request from scratch. *Shorter, drop the second point, keep the last line* gets there in one turn.

This one is worth more than it looks, because it is the same reflex the rest of this app is about. Treating the first answer as final — not wanting to be difficult, not wanting to ask again — is the conversational habit that keeps quiet people quiet. Here, contradicting it costs absolutely nothing and nobody sees. It is the cheapest possible place to practise saying *no, not that*.

**Never ask whether it is good.** It will say yes. It is built agreeable, and *does this work?* is answered before it is considered. *What is the weakest sentence here, and why* is a different question and gets a different answer. So does *what would make somebody not reply to this*. And when a reply opens with a paragraph about what a thoughtful question you have asked, that paragraph is furniture — start reading at the second one.

If you keep one thing: paste the actual thing, then argue with what comes back.$md$,
  1
),
(
  (select id from public.topics where slug = 'ai-prompting'),
  'the-free-question',
  'The free question',
  $$The thing everybody assumes you already know, which you have now been nodding along to for six months.$$,
  $$It is the one place where a question costs nothing. Ask the embarrassing one, ask it until it lands, then take what you learned into the room.$$,
  $md$There is a particular kind of not-knowing that quiet people accumulate. A word gets used in every meeting. You did not ask in the first week because it seemed like something you should know, and now it is the ninetieth week and asking has become genuinely impossible.

The cost is not the gap itself. It is that you cannot ask any question at all about something you have not admitted to not understanding — so you stay quiet in exactly the meetings where you would otherwise have something to say, and it looks like having nothing to say.

**The move:** ask the embarrassing question where it costs nothing, then bring what you learn into the room.

**Ask it plainly.** *Explain X as if I have never heard of it.* No preamble, no admitting anything, no explaining why you do not already know.

**Ask again.** This is the part that does not exist anywhere else. What you cannot do to a colleague is say *I still do not get it* three times in a row — the first time is fine, the second is awkward, the third is not available. Here it is free, and the third explanation is usually the one that lands, because you can say precisely which bit lost you.

**Ask what is assumed.** *What would everyone on a team like this take for granted that a new person would not?* This finds the things you did not know you did not know, which are most of them.

**Then use it.** Understanding privately is half the value. *I read up on X — is it right that it only applies when…* is a question that shows work, and it is by some distance the easiest contribution to make in a meeting: it needs no confidence, only preparation. Small talk and Work both turn on having something to say, and this is where it comes from.

There is no record and nobody can see. If you are worried that looking things up is a kind of cheating, notice that nobody has ever thought worse of a colleague for having read up on something before a meeting. That is just called being prepared.

If you keep one thing: the question you are too embarrassed to ask has a free answer, and you are the only person who will ever know you asked it.$md$,
  2
),
(
  (select id from public.topics where slug = 'ai-prompting'),
  'edit-do-not-write',
  'Edit, do not write',
  $$It will write you something fluent, warm and slightly too long, and anybody who knows you will feel that it was not you.$$,
  $$Write it badly yourself first, then ask for cuts rather than improvements. The bad draft is what makes the result yours.$$,
  $md$Ask it to write your message and you get something competent: warm, well organised, a little long, three compliments in it, every sentence about the same length as the last.

The problem is not quality. It is that the message is not yours, and people who know you can feel it without being able to say why. That matters most in exactly the messages you would most like help with — the apology, the thank you, the difficult one — because a message meant to show effort, written by something else, becomes evidence that you could not be bothered.

**The move:** write it badly yourself first, then ask it to cut.

**The bad draft is the point.** It carries your ordering, your priorities, the things you thought were worth saying and the blunt way you said them. Everything after that is subtraction, and subtraction cannot make it sound like somebody else.

**Ask for cuts, not improvements.** *Improve this* adds — a warmer opening, a softer close, a sentence acknowledging their busy week. *Cut this by half without losing the ask* removes, and removal is what almost every message needs.

**Keep your own awkward sentence.** If a line is yours and slightly clumsy, keep it. Awkward and yours beats smooth and nobody's, and a slightly clumsy sentence from a real person reads as sincere in a way that a well-turned one does not.

**Where it is genuinely excellent** is the mechanical work, and Messaging is a list of it: move the ask to the first line, delete every *just*, cut the apology in front, say what this sentence could be misread as. Those are facts about text rather than judgements about people, it does them instantly, and it does them better than you do at eleven at night.

So the division is clean. You decide what to say and roughly how. It removes what should not have been there.

If you keep one thing: it is an excellent editor and a mediocre impersonator of you.$md$,
  3
),
(
  (select id from public.topics where slug = 'ai-prompting'),
  'rehearse-it-first',
  'Rehearse it first',
  $$The conversation on Tuesday that you have already had forty times in your head, none of them out loud.$$,
  $$Describe the actual person, ask it to play them badly disposed, and find the sentence you are avoiding. Then say the opening out loud.$$,
  $md$Rehearsing in your head does not work, for a reason worth naming: you rehearse the version where they respond well. You say your line, they take it reasonably, and you have practised a conversation that is not the one you are worried about.

**The move:** rehearse out loud, against the difficult version, with the real person described.

**Describe the actual person.** Not *my manager* — what they care about, how they push back, what they said the last time this came up, what they are under pressure from. A role gets you advice about a role. A person gets you the sentence they are actually going to say.

**Ask for the difficult version.** Left to itself it plays somebody reasonable, and reasonable people were never the problem. *Play them sceptical and short of time. Do not make it easy.* The rehearsal only has value if it is harder than the day.

**Ask what you are avoiding.** *What am I not saying here?* is the most useful single question in this topic. There is usually one sentence you have been routing around — the number, the deadline, the thing they did — and the conversation is largely about whether it gets said. Finding it the night before is much better than finding it halfway through.

**Rehearse the opening only.** The first fifteen seconds are what fail and the only part you can hold under adrenaline. The rest cannot be scripted and should not be — Storytelling makes the same argument about the first line and the last.

**Say it out loud.** Typing it is not rehearsing it. Spoken, you find out that your opening is four clauses long, that the word you chose is not a word you say, and that you run out of breath before the point. None of that is visible on a screen. Reading it aloud to an empty room does most of the work; a voice conversation does the rest.

If you keep one thing: out loud, the difficult version, and only the first fifteen seconds.$md$,
  4
),
(
  (select id from public.topics where slug = 'ai-prompting'),
  'it-does-not-know-the-room',
  'It does not know the room',
  $$It has never met these people, has no idea how your office actually talks, and will answer with total confidence anyway.$$,
  $$It is reliable about text and unreliable about people. Never ask it what a message means, and check whether it is only agreeing with your framing.$$,
  $md$It is confident in a uniform way, whether it is telling you that a sentence is ambiguous — which it can see — or what a colleague meant by a short reply, which it cannot possibly know. Quiet people are the readers most likely to defer to that, so the line is worth drawing precisely.

**The move:** trust it about text, not about people.

**Never ask what a message means.** This is the expensive one. Paste a curt reply, ask what they meant by it, and you will get a theory — detailed, plausible, and built out of exactly the nothing you gave it. That is the decoding trap from Messaging, except now the story has a confident co-author and reads like analysis. The boring explanation is still right almost every time, and no amount of eloquence about the tone of *ok, fine* changes that it usually means ok, fine.

**Notice that it agrees with your framing.** Describe somebody as unreasonable and you get thoughtful advice about handling an unreasonable person. It has no way of knowing they are not, and no inclination to argue. The test is quick: write the same situation from their side and ask again. If the advice flips, what you received was your framing handed back with structure added.

**It does not know your register.** The default is warm American corporate — the enthusiastic opening, the sign-off, the exclamation mark. That is right in some rooms and faintly absurd in most, and it will not know which one you are in unless you say.

**It will not tell you not to send it.** Ask whether you should send something and you will get help sending it. Whether to have the conversation at all is your question, and it is the one the tool is worst placed to answer.

**Where it is reliably right:** length, order, ambiguity, what a sentence could be read as, whether the ask is findable. Facts about text. Not what they think, not whether they like you, and not what the silence means.

If you keep one thing: it can see your message. It cannot see them.$md$,
  5
),
(
  (select id from public.topics where slug = 'ai-prompting'),
  'do-not-outsource-the-reps',
  'Do not outsource the reps',
  $$The tool that takes the discomfort out also takes the practice out, and the practice was the entire point.$$,
  $$Before and after, never during. When the effort is the message your worse sentence is the better one, and the reps are with people.$$,
  $md$Everything in this topic makes a conversation easier. That is the use and it is also the risk, because the discomfort you are removing was where the improvement lived.

**The move:** before and after, never during — and wean deliberately.

**Never in the moment.** No help mid-conversation, whatever the phone makes possible. Partly because it does not work: you are managing a screen instead of listening, and people can see it. Mostly because a conversation you got through with assistance teaches you nothing about the next one, which will not have any.

**When the effort is the message.** Condolence, apology, thanks, congratulations. The content of those is almost never the point — the point is that somebody sat down and did it. Outsourced, a better sentence is worth less than nothing, and if it is ever noticed it does damage that the original clumsy version could not have done.

**Wean on purpose.** Run the first five past it, then send the sixth without. The habit is meant to end up in you rather than in the tool, and the only way to find out whether it has transferred is to send something cold. If the sixth one is fine, you have the skill. If it is not, you have learned something more useful than a polished message.

**Notice when polishing is avoidance.** Forty minutes on a two-line message is not care, it is the same avoidance as not sending it, wearing the costume of work. The tell is that it feels productive. Send the third version.

And the ceiling, which is worth being straight about in an app built on this technology. Nobody has ever become less shy by sending better messages. It can help you prepare, cut and rehearse, and every one of those is real. It cannot do the thing itself — the turning up, the saying it, the awkward opening thirty seconds — and that is the part that changes you.

If you keep one thing: before and after, never during. The reps are with people.$md$,
  6
);
