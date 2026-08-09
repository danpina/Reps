-- Work: the eight tracks.
--
-- The topic has been an empty promise since the topics table existed — "say
-- the thing in the meeting while it still counts, ask for the money without
-- apologising for asking, and hold a room you did not expect to be standing in
-- front of" — and this is that promise turned into a road.
--
-- It goes in four pairs: the room, the relationship, the ambition, the outside.
--
-- The middle three are the spine. A quiet person's career stalls in three
-- places and always in this sequence — the work is invisible, the wanting is
-- unsaid, and the money is never asked for. So Being seen, then Saying what
-- you want, then Asking for money, each one the precondition for the next, in
-- order of how hard the ask feels rather than how much it is worth.
--
-- Speaking in meetings leads because it is daily, low-stakes, and the sentence
-- most likely to make a quiet person recognise themselves — which matters more
-- than usual here, since the free sample is the first two lessons of the first
-- skill.
--
-- Your manager is named for the thing rather than for the technique. "Managing
-- up" is consultant vocabulary, and somebody two years into their first job
-- does not know it describes them; the one-to-one they have never asked for is
-- a thing they can see. It sits second because every ask in the spine is
-- delivered into that relationship.
--
-- Raising a problem sits third, next to the relationship it mostly runs
-- through. It is the one track here where the failure mode is not a missed
-- opportunity but an exit: a quiet person absorbs something for months and
-- then leaves over a thing that was a two-minute conversation in week three.
--
-- Two boundaries, both with a seeded and empty topic on the other side of them.
-- Hard conversations takes conflict, hard feedback and bad news, so Your
-- manager stops at routine disagreement and declining work, and Raising a
-- problem stops at the first escalation rather than following it to HR.
-- Storytelling & speaking takes narrative craft and the audience you do not
-- work with, so Presenting stays in the room you are already in.
--
-- This must not be applied before the first track is written, or eight skills
-- render as "Not written yet".
--
-- A note for anybody reading the history: an earlier version of this file
-- seeded six tracks and was applied before the other two were written. It has
-- been rewritten to the eight, which is correct for a database built from
-- scratch — and 26 carries the delta for the one that had already run it.

insert into public.skills (
  topic_id, slug, name, description, core_idea, takeaway_md, sort_order
)
values
(
  (select id from public.topics where slug = 'work'),
  'speaking-in-meetings',
  'Speaking in meetings',
  $$The meeting where you had the right answer and said nothing — and the ninety seconds in which it was still worth saying.$$,
  $$Say it while the window is open and before it is finished. A half-formed point made in time beats a perfect one made after the decision.$$,
  $md$Almost nobody stays quiet in meetings because they have nothing to say. They stay quiet because the thing they have is not ready yet, and by the time it is, the subject has moved.

That is the whole mechanism, and it is worth seeing plainly because it reframes the problem. You are not short of ideas or of nerve. You are applying a standard — *do not speak until it is finished* — that the room is not applying, and that nobody else in it is even aware of. The people talking are not saying finished things. They are thinking out loud and letting the room finish it with them.

Windows close. A point has a natural home about thirty seconds wide, and after that saying it requires dragging everybody backwards, which costs far more social effort than saying it early would have. Most of the difficulty people attribute to confidence is really this: they are trying to make a re-entry rather than an entry.

Getting in is mechanical rather than brave. A short runway — *can I just* — is enough, and using somebody's name gets you the floor almost every time. If you have to interrupt, interrupt at a comma rather than waiting for a full stop that is not coming.

The cheapest entry of all is agreeing with somebody else out loud and adding one sentence. It costs nothing, it is impossible to get wrong, and it makes you a person who talks in this meeting — which is most of what you need, because the second time is never as hard as the first.

If you keep one thing: say it unfinished. Nobody is grading the sentence, and the room will finish it with you.$md$,
  1
),
(
  (select id from public.topics where slug = 'work'),
  'your-manager',
  'Your manager',
  $$The half hour you have never asked for, the one-to-one you spend on status, and the decision you disagreed with silently.$$,
  $$Ask for the time, bring one thing you actually want, disagree once and in private, and say no with a trade rather than an apology.$$,
  $md$Your manager is the single highest-leverage relationship you have at work, and most people run it entirely on their manager's terms.

It starts with not having the meeting at all. A great many people have no standing one-to-one and have never asked for one, because asking looks like it needs a reason and nothing has gone wrong. It does not need a reason — *could we do a regular half hour?* is a request managers say yes to almost without exception, and it is the single highest-return sentence in this topic. If a chat is a one-off rather than a rhythm, ask for it the same way: name the subject, keep it to half an hour, and do not build a case for being allowed to talk.

The next symptom is the one-to-one spent on status. Status is what writing is for — it can be read in ninety seconds at a time that suits them — and spending a scheduled half hour reciting it burns the only slot in the week where you have somebody's whole attention. Arrive with one thing you actually want from them: a decision, an introduction, a view, cover for something. One, not four.

Disagreement is where quiet people lose the most, because the choice feels like objecting in the meeting or saying nothing. There is a third option and it is the one senior people actually use: disagree once, in private, plainly — and then commit in public whichever way it goes. That is not timidity. Somebody who argues privately and supports publicly gets asked their opinion more, not less.

Saying no is a trade rather than a refusal. *If this comes in, what comes out?* is not a difficult sentence and it changes the conversation from your willingness to their priorities, which is where it belonged. Almost every unreasonable workload survives because nobody made the trade visible.

And bad news travels upward badly. It arrives late, softened, and usually after the point where anybody could have helped — which is the version that damages you. Early and plain is uncomfortable for a day. Late is what gets remembered.

If you keep one thing: bring one thing you want. A one-to-one you did not shape is a one-to-one you sat through.$md$,
  2
),
(
  (select id from public.topics where slug = 'work'),
  'raising-a-problem',
  'Raising a problem',
  $$Complaining about a situation, or about a person — to them, or to your manager, without becoming the difficult one.$$,
  $$Say the behaviour and what it cost, not the character. Ask for one specific change. And say it the week it happens, not in a list six months later.$$,
  $md$Almost nobody is taught how to complain at work, so most people do one of two things: absorb it, or eventually detonate. Quiet people overwhelmingly do the first, for months, and then leave a job over something that could have been a two-minute conversation in week three.

What sits underneath is a fear of being *the difficult one*. It is a real risk and it is much narrower than it feels. People are not marked as difficult for raising problems — they are marked as difficult for raising them about a person's character, without an ask, repeatedly, and long after the fact. Avoid those four and you can raise almost anything.

**The move:** the behaviour, the cost, and one specific change.

*Twice this week the file came at six, and I stayed late to turn it round* is unanswerable, because every word of it is a fact. *He is completely disorganised* is a character claim, which invites a defence of the character and settles nothing. The first is a problem somebody can fix; the second is an opinion somebody has to agree with, and they will not.

Then the ask. A complaint with nothing attached is a mood, and moods are what get filed as attitude. *Could we agree it lands by three?* is what converts a grievance into a piece of work — and it is also the thing that makes it stop.

Go to the person first, and go small and early. One sentence, the week it happens, said as an ordinary logistics point rather than as a confrontation. This is the step people skip, and skipping it is what makes the next one look like an escalation instead of a next step. Your manager's first question will be whether you have raised it directly, and the honest answer had better be yes — or, if there is a reason it could not be, say what the reason was.

Do not stockpile. Twelve things delivered at once is a campaign, however true each one is, and it puts the other person on trial. One thing, at the time, is a normal working conversation.

If you keep one thing: be boring about it. Facts, a cost, and one specific change — that combination is very hard to argue with and very hard to file as attitude.$md$,
  3
),
(
  (select id from public.topics where slug = 'work'),
  'being-seen',
  'Being seen',
  $$Good work that nobody can name — and how to fix that without becoming the person who talks about themselves.$$,
  $$Name the work, not yourself. One sentence, to the person who decides, before they hear it from nobody.$$,
  $md$There is a belief that good work speaks for itself, and it is held almost exclusively by people whose work is not being heard.

Work does not speak. People speak, and what reaches the person deciding is whatever somebody happened to say in a room you were not in. If nobody says it, the default is not neutral — the default is that a project went well and no name is attached to it. That is not an injustice being done to you; it is an absence, and absences are nobody's job to fix except yours.

The objection every quiet person raises here is real, so it is worth answering rather than dismissing: self-promoters are insufferable, and you do not want to be one. Good. The thing that makes them insufferable is that they talk about *themselves* — their brilliance, their instinct, how hard it was. You can name the work instead, which is a factual act. *The migration went out on Thursday, no downtime* contains no adjective about you and it is complete visibility.

Two mechanics carry most of it. A short written note on a regular rhythm, which does the work while you are asleep and is far easier than speaking. And answering *how did it go* with one plain sentence instead of a deflection — because *oh, it was a team effort* is the most common way good work gets thrown away by the person who did it.

Credit is not a fixed pot. Naming your part does not take anything from the people you name alongside you, and doing it for them is the cheapest way there is to become somebody others speak well of.

If you keep one thing: say what happened, not how you felt about it. Facts are visibility, and they are not bragging.$md$,
  4
),
(
  (select id from public.topics where slug = 'work'),
  'saying-what-you-want',
  'Saying what you want',
  $$More responsibility, the project you keep watching other people get, and the job you would like next.$$,
  $$Being good at your job is not a bid for anything. Say the thing you want, to the person who decides, before there is a vacancy.$$,
  $md$There is a quiet assumption underneath a great many stalled careers: that doing the work well is a way of asking for more of it.

It is not. It is a way of being reliable at exactly what you currently do, and the most common reward for that is more of exactly what you currently do. Nobody is withholding anything — your manager has a list of things that need doing and a set of people whose ambitions they can only know if those people said them out loud. Being good is not a bid. It is not even a hint.

So say it, and say it as a direction rather than as a request for permission. *I would like to be running something like this by next year* is not presumptuous, it is information your manager cannot get any other way, and it converts you from somebody who is doing fine into somebody with a trajectory they are now partly responsible for. That last part is the mechanism: managers who know what you want start routing things towards it, often without mentioning it.

Ask before the vacancy. By the time a role is open there is usually somebody in mind, and the way people end up in that position is by having said, six months earlier, that it was where they were heading. A shy person tends to wait for the posting, which is the one moment when saying it first is no longer available.

Scope is the version of this you can ask for at any time. A project, an area, the thing nobody owns. It is easier to say yes to than a title, it is reversible, and it is what promotion cases are actually built out of — a title usually follows work you were already visibly doing.

Two things to give up, both of which feel like modesty and function as self-elimination: waiting to be ready, and hoping to be noticed. Nobody feels ready, the people who get the work are not more ready than you, and being noticed is not a plan.

If you keep one thing: say where you want to go, to the person who decides, before there is anything to apply for.$md$,
  5
),
(
  (select id from public.topics where slug = 'work'),
  'asking-for-money',
  'Asking for money',
  $$The raise you still have not asked for, the number you have not said out loud, and what to do with a no.$$,
  $$Ask for a number rather than for a conversation. Say it, stop talking, and treat a no as a question about when.$$,
  $md$Most people do not fail to get a raise. They fail to ask for one, and then read the outcome as an answer.

The commonest shape is a request for a conversation rather than for money — *I wanted to talk about my progression* — which hands your manager a topic instead of a decision. Topics get scheduled and then absorbed. A number gets answered.

So name it. Say the figure out loud, and then stop talking, which is the hard part and the whole technique. The silence after a number feels enormous and is about two seconds long, and filling it is how people negotiate against themselves — the sentence that follows an unanswered number is almost always a discount.

Ask early rather than at review time. By the review the budget is allocated and your manager is arguing for a decision that was made weeks earlier without you in the room. Two months before is not too keen; it is the only point at which the answer is still being formed.

Bring what you did, not who you are. Reliability, effort and loyalty are the arguments everybody makes, and they are unanswerable in the wrong way — nobody can act on them. Three things that happened, with what changed because of them, is a case somebody can carry upstairs.

And a no is rarely a verdict. It is usually a budget cycle, a band, or a decision that has already been signed. The question that turns it into something useful is not *why* but *what would have to be true, and when should I come back* — and then coming back on that date, which almost nobody does.

If you keep one thing: say the number, then be quiet. It is two seconds, and the person who speaks first is negotiating against themselves.$md$,
  6
),
(
  (select id from public.topics where slug = 'work'),
  'presenting',
  'Presenting',
  $$Ten minutes standing up, a deck you wrote, and the strong urge to read it out loud.$$,
  $$Slides are not notes. Say the point first, talk to one person at a time, and answer the question you were actually asked.$$,
  $md$The reason people read their slides out loud is not laziness. It is that a slide full of words is the only thing in the room that cannot forget what comes next, and standing up in front of colleagues makes you want something to hold.

Which means the fix is upstream of the delivery. A slide carrying your notes forces you to read; a slide carrying one point lets you talk. This is the rare presentation problem that is solved the day before rather than in the moment, and it is the one that does most of the work.

Say the point first. Business rooms are not story rooms — the audience is deciding whether to keep listening within about fifteen seconds, and holding your conclusion until the end means they spend the middle guessing at where this is going instead of following it. Answer first, then show why.

Talk to one person at a time. "Scanning the room" produces the vacant sweep everybody recognises as nerves; resting on one person for a sentence, then moving to another, is what being spoken to feels like from the audience side. It is also much easier, because a sentence to one person is a thing you have done ten thousand times.

Two things that are shorter than they feel: the pause while you find your place, and the silence after you finish a section. Both feel like collapse from inside and read as composure from outside.

And you will be asked something you cannot answer. *I do not know — I will find out and come back to you today* is a complete, professional answer, and improvising instead is the only version of that moment that damages you.

If you keep one thing: put the point on the slide and the sentences in your mouth. You cannot read a slide that has nothing to read.$md$,
  7
),
(
  (select id from public.topics where slug = 'work'),
  'the-corridor',
  'The corridor',
  $$Conferences, lifts, kitchens, and the senior person you have thirty seconds with.$$,
  $$Work small talk has one job ordinary small talk does not: be recognisable next time. That is the whole target.$$,
  $md$Work small talk looks like small talk and is playing for something different, which is why people who are fine at parties can be terrible at conferences.

Ordinary small talk succeeds if the two minutes were pleasant. This succeeds if you are recognised next time — that is the entire objective, and it is a much lower bar than the one people set themselves. You are not trying to impress anybody, land an opportunity, or be interesting. You are trying to be a person with a name and one memorable fact, so that the second conversation starts warm.

That target makes the thirty-second version of what you do worth writing down in advance. Not a job title, which produces a nod and a silence, but the thing you actually work on said in a sentence a stranger could ask a question about. Everybody in this app has now met that principle in the Dating apps profile track; it is the same principle standing in a corridor.

Lifts, queues and coffee machines are the free attempts — the situation ends them for you, so there is no exit to negotiate. A conference corridor is the harder room, because there is no clock, and the answer there is to plant your exit early: say you are heading into the next session, and then be free.

Senior people are easier than you expect and for an unflattering reason: almost nobody talks to them, and most of what they hear is a request. Two minutes of ordinary conversation with no ask in it is unusual enough to be remembered.

Then follow up the same day, in two lines, referring to the actual thing you talked about. Almost nobody does this, which is precisely why it works.

If you keep one thing: the target is recognisable, not impressive. Impressive is a much harder goal that nobody was asking you for.$md$,
  8
);
