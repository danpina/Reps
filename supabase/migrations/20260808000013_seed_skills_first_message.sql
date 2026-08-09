-- Dating apps, track 1: The first message.
--
-- The topic a lot of people arrive for, and the one where the rehearsal format
-- is unusually honest. Everywhere else in this app typing stands in for
-- speaking, and something is lost. Here the medium is already text — a drill
-- that asks you to write a message is asking for exactly the thing you will
-- actually do, in the same box, with the same amount of time to think.
--
-- The first message is its own skill because it fails for structural reasons
-- rather than for want of wit. A message that asks nothing is a message that
-- asks the other person to do all the work; a message asking three things gets
-- one answered; and a message that could have been sent to anybody tells them
-- it probably was.

insert into public.skills (
  topic_id, slug, name, description, core_idea, takeaway_md, sort_order
)
values (
  (select id from public.topics where slug = 'dating-apps'),
  'first-message',
  'The first message',
  $$A match, a blank box, and about a day before it stops being a match.$$,
  $$One specific thing off their profile, one question, under thirty words. Hey is not a message, and three questions is one question.$$,
  $md$Almost every first message that fails, fails for a reason you can see before you send it.

Hey asks them to do all the work. It contains nothing to answer, nothing about them, and no evidence you looked — which means the only way to reply is to invent a conversation from nothing, and they have eleven other people asking them to do that.

The fix is not to be clever. It is to be specific. One concrete thing off their profile, asked as one question, is enough on its own, and it works because it proves you read it and because it is answerable in a sentence. Specificity is also the only kind of humour that survives text: irony needs tone and there is none, so a wry observation about the actual thing in their photo lands where a joke does not.

One question, not three. A message carrying three questions gets the easiest one answered and the other two are gone, and it reads as an interview from somebody who has not decided what they are interested in.

Short, too. Their first message will tell you the length they write at, and matching it is worth more than anything you could add.

If you keep one thing: a message that could have been sent to anybody tells them it probably was.$md$,
  1
);
