-- The first date, track 4, reframed: "Ending it" becomes "What happens next".
--
-- The old name described the smaller half. A first date has two possible
-- outcomes and only one of them is worth the reader's attention — the second
-- date — and calling the track "Ending it" made the good outcome a subcase of
-- the disappointing one. It also put the emphasis exactly where a nervous
-- reader's already is: on getting out rather than on getting somewhere.
--
-- The content moves with it. Saying the plain thing and turning it into an
-- actual plan are now the middle of the track rather than a coda, and the
-- honest no keeps its place at the end, where it belongs: one of two answers
-- rather than the subject.
--
-- Renamed rather than replaced, so the row keeps its identity — safe only
-- because the track still has no lessons.

update public.skills set slug = 'what-happens-next'
where slug = 'ending-the-date'
  and topic_id = (select id from public.topics where slug = 'first-date');

update public.skills set
  name = 'What happens next',
  description = $$The last twenty minutes, whether you say the thing, and how a second date actually gets arranged.$$,
  core_idea = $$End it while it is still good, say plainly that you would like another one, and make it specific enough to say yes to.$$,
  takeaway_md = $md$A first date is not really over when you stand up. What decides whether there is a second one happens in the last twenty minutes and in the twelve hours after, and almost all of it is in your hands.

Start by ending it while it is still going well, and slightly earlier than you want to. Two good hours leaves both of you wanting the next one; five flattens the same evening into something neither of you can quite face repeating. The instinct to keep going *because* it is going well is exactly the instinct to distrust — and the finish time you named on arrival is already there to be used.

Then say the plain thing. *I would like to do this again* is the whole sentence. Every earlier track in this app taught deniability — a notch, offered and released, nothing declared — and that was right for strangers whose interest was unknown. By the end of a first date it has been earned, and staying deniable now reads as indifference rather than as tact.

Then make it real, because *we should do this again* is a sentiment and it dies where it stands. This is the same move as asking for a number and the same move as proposing a drink on an app: something specific, something small, and a time in it. *There is a place near me that does the thing you were describing — Thursday or Saturday?* is answerable in one word, and one word is what you want.

Read the answer honestly, using the test you already know. A time coming back is a yes. A warm reason with no alternative attached is a no, however kindly it is put — and the right response to that is a warm goodnight, not a clarifying question.

Then message the same day: short, specific, referring to something that actually happened. The waiting rules are the same folklore they were on the apps, and what you are preserving is the same thing — a mood that starts cooling the moment you walk away.

And if your answer is no, say so. One short honest message takes ninety seconds and is enormously kinder than a silence, which leaves somebody checking their phone for four days.

If you keep one thing: leave slightly early, and turn *again sometime* into a day. Both feel counterintuitive and both are what actually produces a second date.$md$
where slug = 'what-happens-next';
