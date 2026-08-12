-- Making friends: the five tracks.
--
-- The gap the curriculum keeps implying and never fills. Small talk teaches
-- somebody to start a conversation with a stranger, Meeting someone teaches
-- the approach, The first date fills two hours. A reader who does all of it
-- still has nobody to call on a Sunday — every road in the app so far ends at
-- a job, a date, or a pleasant exchange, and none of them produce a friend.
--
-- It is also the least-served problem in here. There is an enormous amount
-- written about dating and almost nothing about adult friendship, and the
-- people who need it most have generally concluded that the failure is a
-- defect in them. Track one exists mostly to say that it is not.
--
-- The order is the sequence, and track three is the load-bearing one. The
-- biggest reason adult friendships do not form is not rejection — it is that
-- one coffee happens, both people enjoy it, and neither initiates again,
-- because each is waiting for evidence that they are wanted. Somebody has to
-- go twice.
--
-- Two things folded in rather than given their own track: choosing a room that
-- repeats is the practical end of track one, and joining an existing group is
-- a lesson inside track two.
--
-- No lessons yet. Do not apply this before the first track is written, or five
-- skills render as "Not written yet" and the topic has no free sample.

insert into public.skills (
  topic_id, slug, name, description, core_idea, takeaway_md, sort_order
)
values
(
  (select id from public.topics where slug = 'making-friends'),
  'why-it-got-hard',
  'Why it got hard',
  $$Why making friends was effortless at nineteen and is not now, and what that actually tells you.$$,
  $$Friendship is made by repeated, unplanned, low-stakes contact. School and university supplied it and adult life does not. Choose a room that repeats.$$,
  $md$Almost everybody who struggles with this has quietly concluded it is a defect in them, and the evidence looks strong: it used to be easy, it is not now, and nothing about them has obviously changed.

Something did change, and it is not you. Friendship is made by a specific and rather boring input — repeated, unplanned, low-stakes contact with the same people over time. School supplied it. University supplied it in industrial quantities. A first job with a big team supplied it. None of those required anybody to be good at making friends, which is why nobody noticed the supply was doing the work.

Adult life stops supplying it, and it stops suddenly. You see colleagues constantly and always with a purpose. You see old friends occasionally and always by arrangement. What disappears is the thing in the middle: unplanned time with the same faces, repeatedly, with nothing at stake and no reason to be there.

**The move:** stop trying to make friends, and start choosing rooms that repeat.

That is the whole practical content of this lesson. A weekly class, a five-a-side team, a running club, the same café at the same time, a choir, a volunteer shift. What all of them have in common is not the activity, which is nearly irrelevant, but the shape: the same people, on a schedule, for months.

Repetition does the work that charm is supposed to do. People become familiar, familiarity becomes warmth, and somewhere around the sixth or seventh time, a conversation happens that neither of you engineered. That is not a metaphor for friendship, that is what friendship is made of, and it is available to somebody with no social skill whatsoever provided they keep turning up.

If you keep one thing: you do not have a friendship problem, you have an infrastructure problem — and infrastructure can be built on purpose.$md$,
  1
),
(
  (select id from public.topics where slug = 'making-friends'),
  'first-invitation',
  'From acquaintance to something',
  $$The person you get on with, who you have never once seen outside the room you met them in.$$,
  $$Invite them somewhere with a day in it. Small, specific and low-stakes — and say the thing everybody is too embarrassed to say.$$,
  $md$There is a category of person almost everybody has several of: somebody you genuinely get on with, who you have known for a year or two, and who you have never seen outside the one room you met them in.

Nothing is wrong. You both like each other. You have both said *we should do something* and meant it. And it has not happened, because *we should do something* is a sentiment and sentiments do not put anything in a diary.

**The move:** propose something specific, with a day in it, out of the context you know them from.

You have met this shape three times in this app already, and it is the same one every time: small, specific, a day. *There is a place near the office that does proper coffee — Thursday?* Not because coffee is important but because the size is: an hour is a thing anybody says yes to, and a day out is a commitment neither of you has yet.

The difference from every other version of this move is the awkwardness, and it is worth naming plainly rather than pretending it is not there. Asking somebody to be your friend feels far more exposing than asking somebody on a date, because there is no script for it — a date has a name and a shape, and this has neither.

Which is why the most effective thing you can do is say it. *This is a slightly odd thing to say, but we always talk and I would happily do it somewhere that is not this corridor.* People are almost universally pleased to hear that, because almost everybody is in the same position and nobody says it first. Naming the awkwardness is what removes it.

And go via the group where one exists. Joining a thing several people are already doing is the lowest-stakes invitation there is, because nobody has to decide anything about you — you are simply there.

If you keep one thing: name it and put a day on it. *We should do something* has never once produced anything.$md$,
  2
),
(
  (select id from public.topics where slug = 'making-friends'),
  'the-second-time',
  'The second time, and the third',
  $$One coffee happened, you both enjoyed it, and that was eight months ago.$$,
  $$Friendships are made by whoever initiates twice. Almost everybody manages once, and then waits for evidence they are wanted.$$,
  $md$This is where adult friendships actually die, and it is not rejection that kills them.

Here is the standard shape. One coffee happens. Both people enjoy it. Both go home thinking that was nice, we should do it again. And then nothing, for eight months, until you run into each other and say *we must do that again* and mean it exactly as much as the first time.

What happened is that both of you were waiting for evidence you were wanted. You initiated once, they said yes and had a good time, and you are now waiting for them to go next — because going twice in a row feels like being the keen one, and being the keen one feels like a risk.

**The move:** initiate the second time, and the third, without keeping score.

Somebody has to. In almost every friendship you have, somebody did — and it is worth checking, because you will find that in several of them it was not you, and that you have never once thought less of the person who did it. Nobody has ever privately catalogued a friend as too keen for arranging things. That fear is entirely one-directional and it exists only from the inside.

Three or four is roughly the threshold. Somewhere around the fourth time you see somebody outside the context you met them in, it stops being a series of arrangements and becomes a friendship, at which point the initiating evens out on its own without either of you deciding.

So the honest version is: expect to do most of the work for the first few months, and stop reading that as a signal. It is a phase, not a verdict, and treating it as a verdict is precisely what ends things at one coffee.

If you keep one thing: go again. The second invitation does more than anything you could say in the first one.$md$,
  3
),
(
  (select id from public.topics where slug = 'making-friends'),
  'getting-past-pleasant',
  'Getting past pleasant',
  $$You can know somebody four years, like them enormously, and be nowhere at all.$$,
  $$Friendship starts when you stop talking about things and start talking about yourselves. Somebody has to go first, in small steps.$$,
  $md$There is a kind of relationship that can run for years without becoming anything: warm, easy, entirely pleasant, and completely uninformative. You talk about work, the football, the weather, the thing in the news. You would both describe the other as somebody you like. Neither of you knows anything.

The barrier is not time and it is not liking each other. It is that nobody has moved from talking about *things* to talking about *themselves*, and both of you are waiting for a natural moment that does not arrive on its own.

**The move:** say one true thing about yourself that you would normally keep out, and see what comes back.

Small, deliberately. Not a confession — this is a ladder in exactly the way disclosure is on a date. *I have been finding this year quite hard, actually.* *I am dreading Christmas.* *I have basically no idea what I am doing.* One rung, then read what comes back, then the next.

What usually comes back is relief. Most people are running the same pleasant surface and would happily stop, and the person who goes first is remembered for it — the whole thing shifts within a single conversation, and it frequently shifts permanently.

Two things worth knowing. Asking does not work as well as offering: *how are you really* puts somebody on the spot and gets a deflection, where saying something true about yourself simply lowers the level and lets them join you. And doing it once is not enough — the surface reasserts itself, so it needs doing again, a few times, before the register changes for good.

If it does not come back, that is information rather than a rejection. Some people are not looking for another close friend, which is entirely reasonable, and it is much better to know at one rung than at four years.

If you keep one thing: offer, do not ask. Say the true thing first and the level moves for both of you.$md$,
  4
),
(
  (select id from public.topics where slug = 'making-friends'),
  'keeping-it-alive',
  'Keeping it alive',
  $$The friend you have not messaged in two years, and the ninety seconds that fixes it.$$,
  $$Send things with no ask in them. And when it has lapsed, pick it up in one line with no apology and no explanation.$$,
  $md$Friendships do not usually end. They lapse, which is different, and the difference matters because a lapse is reversible and almost nobody reverses it.

The mechanism is ordinary. Nobody has done anything wrong. Somebody was busy, then the gap got long enough to feel like it needed acknowledging, and acknowledging it felt like more effort than either person had — so the gap kept growing, protected by the very awkwardness it created.

**The move:** send things with nothing attached, and pick up lapses in one line.

The maintenance half is the cheapest thing in this topic. A link, a photo, a thing that reminded you of them, a sentence about something they mentioned four months ago. It takes fifteen seconds, it asks for nothing, and it is what keeps a friendship warm between the times you actually see each other. Contact with a request in it is admin; contact with nothing in it is friendship, and most people only ever send the first kind.

The lapse half is where people get stuck, and the fix is smaller than the problem feels. Do not apologise, do not account for the time, do not open with *I am so sorry, I am terrible at this.* All of that makes the gap the subject and asks them to reassure you about it before anything else can happen. Send the ordinary thing you would have sent anyway, as though you had spoken last week: *This is the most you thing I have seen all year.* Almost nobody minds, and almost everybody is relieved, because they were sitting on the other side of the same silence.

And accept different rhythms. Some friendships run on weekly contact and some on twice a year, and the twice-a-year ones are not weaker — they are differently shaped, and treating them as failing is how people end up feeling lonely inside a perfectly good set of friendships.

If you keep one thing: send one thing with no ask in it. That is what the whole thing is made of, and it costs fifteen seconds.$md$,
  5
);
