-- "The conversation" becomes "Two hours of talking".
--
-- In a topic that is entirely one conversation, a track called "The
-- conversation" does not say which part of it belongs to it — the other three
-- all name something concrete. Duration is the actual difficulty and it is the
-- thing a quiet person is looking at when they open this topic, so the name
-- should say it.
--
-- The slug stays. It is stable, nothing is gained by moving it a second time,
-- and a lesson migration that references it is already written against it.

update public.skills set
  name = 'Two hours of talking',
  description = $$The awkward opening, the interview trap, and how much of yourself to put into it.$$
where slug = 'the-conversation'
  and topic_id = (select id from public.topics where slug = 'first-date');
