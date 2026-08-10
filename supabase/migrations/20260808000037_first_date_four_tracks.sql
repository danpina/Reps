-- The first date, condensed from five tracks to four.
--
-- The previous migration was applied before this call was made, so editing it
-- would leave this database and a fresh one disagreeing for ever. It keeps the
-- five it seeded and this carries the change — which means everything below is
-- written to be a no-op the second time it runs.
--
-- Two of the five were divisions that did not survive being looked at.
--
-- "The first ten minutes" is the opening of the conversation rather than a
-- separate discipline: one lesson's worth of "this is supposed to be awkward,
-- give it twenty minutes" standing in front of the same track. It becomes a
-- lesson, and the track it fronted absorbs it.
--
-- "When it is not going well" is an ending. Enduring a bad date for three
-- hours out of politeness is one of the ways an evening finishes, and it
-- belongs beside the others rather than in a track of its own.
--
-- Nothing is lost by either merge; both move down a level. What is not merged
-- is working out whether you like them, and that is deliberate. It is the
-- track no other dating advice contains, and folding it into the conversation
-- would turn a reframe — you are choosing too — into a technique for having a
-- nicer chat.
--
-- Safe to run because the topic has no lessons and no reader has touched it:
-- field_logs and user_skill_state both reference skills without a cascade, so
-- a skill anybody had used would refuse to be deleted rather than take their
-- rows with it.

delete from public.skills
where slug = 'first-ten-minutes'
  and topic_id = (select id from public.topics where slug = 'first-date');

-- Renamed rather than replaced, so the row keeps its identity. Safe only
-- because the track is empty; a slug is a stable handle everywhere else.
update public.skills set slug = 'the-conversation'
where slug = 'two-hours'
  and topic_id = (select id from public.topics where slug = 'first-date');

-- Now carrying the awkward opening and the question of how much of yourself
-- goes into it, both of which had been separate.
update public.skills set
  name = 'The conversation',
  description = $$The awkward opening, the interview trap, and how much of yourself to put into it.$$,
  core_idea = $$Give it twenty minutes before deciding anything, react rather than report, and say more about yourself than feels comfortable.$$,
  takeaway_md = $md$Two hours is a long time to talk to somebody you have never met, and three things decide whether it works.

The first is patience with the opening. A first date is awkward for ten minutes and that is structural rather than personal — two strangers, high stakes, no shared context, and nothing to do together. The damage comes from reading it as a verdict: people conclude at minute six that there is nothing here, then spend ninety minutes politely confirming it. Chemistry at minute one is rare. Chemistry at minute twenty is what most good relationships actually began as. Naming it helps, because *this bit is always slightly strange* is true, it is a joke about a situation you are both in, and it lands nearly every time.

The second is reacting rather than reporting. You have met this failure twice already in this app and here it has no rescue — no colleague joins in, no queue moves you on, and nothing ends it, so an interview does not fade politely, it sits there for two hours. Both of you are pleasant, nothing goes wrong, and at the end you know a great deal about somebody you have no feeling about at all. The fix is one addition: answer, then say what you actually think about your own answer. *I grew up in Leeds* is a data point. *I grew up in Leeds and I have complicated feelings about how much I miss it* is a person, and only one of those can be liked.

The third is how much of yourself is in it, and a quiet person can get this wrong in both directions in one evening. The undershare is the common one and it is disguised as being a good listener — somebody who asks all the questions is not being generous, they are hidden, and hidden is not a thing anybody can like. The overshare is the dam going at drink two. What works is volunteering one real thing early, unprompted: not a confession, but a preference, an embarrassment, something you care about more than is reasonable. It sets the depth and gives permission.

Two smaller things that carry a surprising amount. Let the subject wander, and let it change without permission — the best twenty minutes of a good first date are almost always somewhere neither of you planned to go. And the silences are supposed to be there; two hours cannot be continuous talking, and filling every pause is what makes the evening exhausting and makes you look effortful.

If you keep one thing: react rather than report. Facts are what you offer when you are afraid of being disliked, and they are the reason nobody feels anything.$md$
where slug = 'the-conversation';

-- And Ending it takes the bad date, which is one of the ways an evening ends.
update public.skills set
  description = $$Leaving while it is still good, saying the plain thing, and the date you knew about at minute twenty.$$,
  core_idea = $$End slightly early, say you would like to do it again, and leave a bad one rather than enduring it. A no said kindly beats a silence.$$,
  takeaway_md = $md$How a first date ends decides more about whether there is a second one than anything in the middle of it.

End it while it is still going well, and slightly earlier than you want to. Two good hours leaves both of you wanting the next one; five flattens the same evening into something neither of you can quite face repeating. The instinct to keep going because it is going well is exactly the instinct to distrust.

Then say the plain thing. *I would like to do this again* is the whole sentence. Every earlier track in this app taught deniability — a notch, offered and released, nothing declared — and that was right for strangers whose interest was unknown. By the end of a first date it has been earned, and staying deniable now reads as indifference rather than as tact. Read the answer with the same test the apps use: a time coming back is a yes, and a warm reason with no alternative attached is a no, however kindly it is put.

If it is not going well, you are allowed to leave. Endurance is the quiet person's failure here — three hours of politeness and then going home angry at yourself, when both of you knew at minute twenty. Politeness that costs you an evening is not kindness, because the other person is having the same evening. Use the exit you planted before you came: *I should get going — it was good to meet you* needs no reason attached to it. And do not perform enthusiasm you do not have, because false warmth at the door is what produces four days of texting to undo.

One case is not like the others. Being uninterested and being uncomfortable are different, and if somebody makes you feel unsafe then none of the etiquette above applies — leave, immediately, and badly if that is what it takes. Tell somebody where you are going before you go.

The goodbye itself is a moment people build into something enormous. Decide in advance that any version is fine: a hug and *I will message you* is a complete ending nobody has ever gone home upset about, and anything more should be obviously mutual rather than attempted in order to find out.

Then send one message the same day, short and specific. And if it is a no, say so — one honest message takes ninety seconds and is enormously kinder than a silence, which leaves somebody checking their phone for four days.

If you keep one thing: leave slightly early and say the plain thing. Both feel counterintuitive and both are what makes a second date happen.$md$
where slug = 'ending-the-date';

-- Four tracks: prepare, converse, assess, close. Shifted first because
-- (topic_id, sort_order) is unique and not deferrable, and assigned rather
-- than adjusted so a second run lands on exactly the same road.
update public.skills s set sort_order = s.sort_order + 100
from public.topics t
where s.topic_id = t.id and t.slug = 'first-date';

update public.skills s set sort_order = m.pos
from public.topics t,
  (values
    ('before-you-go', 1),
    ('the-conversation', 2),
    ('do-you-like-them', 3),
    ('ending-the-date', 4)
  ) as m (skill_slug, pos)
where s.topic_id = t.id and t.slug = 'first-date' and s.slug = m.skill_slug;
