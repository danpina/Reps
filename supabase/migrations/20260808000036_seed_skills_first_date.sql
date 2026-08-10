-- The first date: the five tracks.
--
-- Two topics now end at the same place. Meeting someone finishes with a number
-- in your phone; Dating apps finishes with a drink arranged for Thursday. Both
-- were finished this week precisely because they taught the beginning and the
-- middle and stopped before the outcome — and leaving this topic empty repeats
-- that failure one level up, on the conversation all of it was for.
--
-- It is also the hardest room in the curriculum, and the only one with no exit
-- built in. A queue moves, a meeting ends, a lift arrives. Two hours opposite
-- one person has nothing in it that stops.
--
-- The order is the evening. Track four is the one that would be cut from a
-- shorter version and should not be: a shy person arrives at a first date as a
-- candidate rather than as a participant, spends two hours auditioning, and
-- ends up with second dates arranged with people they did not actually like.
-- Nobody teaches the assessing half, and it is the half that makes the evening
-- survivable.
--
-- Note the deliberate echo in track two. Meeting someone has "The first two
-- minutes", about holding an approach that has just landed. This is a
-- different problem with a similar name: two people who already agreed to be
-- here, getting over the fact that they have never met.
--
-- No lessons yet. Do not apply this before the first track is written, or five
-- skills render as "Not written yet" and the topic's free sample is empty.

insert into public.skills (
  topic_id, slug, name, description, core_idea, takeaway_md, sort_order
)
values
(
  (select id from public.topics where slug = 'first-date'),
  'before-you-go',
  'Before you go',
  $$Where to go, how long to stay, and the four hours of dread beforehand.$$,
  $$Pick somewhere short and easy to leave, decide the length in advance, and go to find out whether you want a second one — not to be liked.$$,
  $md$Most of what makes a first date hard is decided before either of you arrives, and almost all of it is decided badly.

Start with the venue, because it sets everything else. A drink is right: an hour or two, background noise, something to look at, and no obligation. Dinner is the common mistake — you are trapped for the length of three courses, sitting directly opposite somebody with nothing to look at but them, and the evening runs on the kitchen's schedule rather than yours. Anything with a screen is worse, because you have paid to not talk to each other.

Decide the length before you go, and say it when you arrive. *I have got to be somewhere at eight* is the same planted exit as a conference corridor, and it does the same thing: it tells both of you this has a shape, so neither is bracing. You will often stay longer, and having the option is what lets you relax.

The four hours before are the worst part of the entire evening and they are not information. Dread lives in anticipation — the date itself is almost always easier than the waiting, and knowing that in advance takes some of the weight out of the afternoon.

Bring two or three things you are actually curious about. Not questions to ask, which produces an interview. Curiosity, which is the difference between wanting to know something and having something to say next.

And set the target low enough to hit. You are not there to be liked. You are there to find out whether you would like a second one, which is a question you can answer even if it goes badly.

If you keep one thing: somewhere you can leave, and a time you said out loud. The rest is much easier from there.$md$,
  1
),
(
  (select id from public.topics where slug = 'first-date'),
  'first-ten-minutes',
  'The first ten minutes',
  $$The greeting, the drinks, and the awkwardness that is supposed to be there.$$,
  $$The first ten minutes are awkward for everybody. Name it, get the logistics done, and give it until minute twenty before concluding anything.$$,
  $md$The opening of a first date is awkward, and the single most useful thing to know is that this is structural rather than personal.

Two people who have never met, who both know exactly what this is, with no shared context and nothing to do together, are going to be uncomfortable for a few minutes. That is not a failure of chemistry, it is a description of the situation, and the other person is feeling precisely the same thing.

The damage comes from misreading it. People conclude at minute six that there is nothing here, and then spend the next ninety minutes politely confirming a verdict they reached before anything had a chance to start. Chemistry at minute one is rare. Chemistry at minute twenty is completely normal, and it is what most good relationships actually began as.

**The move:** say it out loud, do the logistics, and wait.

Naming it is a small joke about a situation you are both in, which is the safest kind there is — *this bit is always slightly strange* gets a laugh close to every time, because it is true and because somebody said it first.

The greeting is worth deciding in advance so you are not negotiating it in real time. Hug, handshake, or neither: pick one, commit, and let it be briefly awkward if it is. Everybody has had a bad greeting and nobody has ever thought about it again.

Then get the mechanics out of the way quickly — drinks, coats, where to sit. It is not conversation and it is not meant to be, and once it is done you are two people at a table instead of two people arriving.

If you keep one thing: give it twenty minutes before you decide anything. The first ten are not the date.$md$,
  2
),
(
  (select id from public.topics where slug = 'first-date'),
  'two-hours',
  'Two hours of conversation',
  $$The interview trap again — this time with nobody to rescue you and nothing to end it.$$,
  $$Trade reactions rather than facts, tell small stories, and let the subject wander. Two hours has silences in it and that is not failure.$$,
  $md$You have met this failure twice already in this app and here it has no rescue. On a date there are no colleagues to join the conversation, no queue to move you on, and nothing that ends it — so an interview does not fade politely, it sits there for two hours.

The shape is the same: what do you do, where did you grow up, do you have brothers and sisters, how long have you lived here. Both of you are being pleasant. Nothing is going wrong. And at the end you know a great deal about somebody you have no feeling about at all.

**The move:** answer, then say what you actually think about your own answer.

Facts are the raw material and the reaction is the content. *I grew up in Leeds* is a data point. *I grew up in Leeds and I have complicated feelings about how much I miss it* is a person, and only one of those can be liked.

Tell small stories instead of giving specifications. Stories are how people become vivid, they invite one back, and they are much easier to produce than clever answers — you already have hundreds of them and none of them need to be interesting to a stranger on paper.

Let the subject wander, and let it change without permission. The best twenty minutes of a good first date are almost always somewhere neither of you planned to go, and steering back to a proper topic is how that gets killed.

The silences are supposed to be there. Two hours cannot be continuous talking, and a pause where you both drink something is not a failure state — filling every one of them is what makes the evening exhausting and makes you seem effortful.

And use callbacks. Bringing back something they said an hour ago is the cheapest warmth available and it does more than any story you could tell.

If you keep one thing: react rather than report. Facts are what you say when you are afraid of being disliked, and they are why nobody feels anything.$md$,
  3
),
(
  (select id from public.topics where slug = 'first-date'),
  'do-you-like-them',
  'Working out if you like them',
  $$The question you forget to ask, because you are so busy being the one under assessment.$$,
  $$You are choosing too. Ask whether you are enjoying this, not whether it is going well — they are different questions and only one is useful.$$,
  $md$Almost nobody teaches this half, and for a quiet person it is the half that decides everything.

You arrive as a candidate. The whole evening is spent in one posture — am I doing well, was that funny, did that land, do they like me — and the cost is enormous. It is exhausting, it makes you visibly effortful and therefore worse company, and it produces the strangest outcome in dating: second dates arranged with people you did not actually like, because nobody ever asked.

**The move:** swap the question. Not *is this going well* but *am I enjoying this.*

Those feel similar and they are not remotely the same. The first is unanswerable, because you are guessing at somebody else's inner state from across a table. The second you can answer instantly and accurately at any moment, and it is the only one that matters for what happens next.

The signals are all internal and easy to read once you are looking. Are you talking or performing? Do you want to tell them things, or are you supplying things? Did you laugh at something, or produce a laugh? Would you be pleased or relieved if they had to leave in ten minutes?

Being liked and liking somebody are separate questions, and the first one is much less useful than it feels. Somebody liking you is pleasant and tells you nothing about whether you want a Tuesday evening with them for the next year.

It is allowed to be a no. A first date that ends with you deciding you would rather not was a successful use of two hours — that was the question, and you answered it.

And you are not required to know. Most people cannot tell from one date, and *I would like to find out* is a complete and honest position that does not need converting into certainty before you are allowed to act on it.

If you keep one thing: you are choosing too. Half the evening's weight comes off the moment that is genuinely true rather than something you have been told.$md$,
  4
),
(
  (select id from public.topics where slug = 'first-date'),
  'ending-the-date',
  'Ending it',
  $$Leaving while it is still good, saying the plain thing, and the walk to the station.$$,
  $$End it slightly early, say you would like to do it again, and send one message the same day. A no said kindly beats a silence.$$,
  $md$How a first date ends decides more about whether there is a second one than anything in the middle of it.

End it while it is still going well, and slightly earlier than you want to. Two good hours leaves both of you wanting the next one; five hours flattens the same evening into something neither of you can quite face repeating. The instinct to keep going when it is going well is exactly the instinct to distrust here.

**The move:** say the plain thing.

*I would like to do this again* is the whole sentence. Every earlier track in this app taught deniability — a notch, offered and released, nothing declared — and that was correct for strangers and for people whose interest was still unknown. By the end of a first date it has been earned, and continuing to be deniable now reads as indifference rather than as tact.

Then read the answer with the same test the apps use. A time coming back is a yes. A warm reason with no alternative attached is a no, however kindly it is phrased, and the correct response is a warm goodnight rather than a clarifying question.

The goodbye itself is a moment people build into something enormous. Decide in advance that any version of it is fine. A hug and *I will message you* is a complete ending that nobody has ever gone home upset about, and anything more should be obviously mutual rather than attempted to find out.

Then send one message the same day — short, specific, and referring to something that actually happened. The waiting rules are the same folklore they were on the apps, and the thing you are preserving is the same: a mood that starts cooling the moment you walk away.

And if it is a no, say so. One short honest message takes ninety seconds and is enormously kinder than a silence, which leaves somebody checking their phone for four days. You will not enjoy sending it. Send it anyway — it is the same skill as everything else in this topic, which is being clear when being vague would be easier.

If you keep one thing: leave slightly early and say the plain thing. Both feel counterintuitive and both are what makes a second date happen.$md$,
  5
);
