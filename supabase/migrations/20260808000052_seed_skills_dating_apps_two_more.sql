-- Dating apps: the two tracks that make it a topic rather than a road.
--
-- The three that exist are the sequence — profile, first message, getting to a
-- date — and they are correct. What they leave out is everything that is not
-- the sequence: what to do when it is not working, and what the app does to
-- the person using it.
--
-- Where it is breaking comes last because it routes. Nobody using these apps
-- knows which join in the funnel is failing, so they optimise the one thing
-- they can edit from the sofa — the profile — for months. It ends by sending
-- a reader whose dates never become second dates to a different topic
-- entirely, which is the only place in this curriculum where a topic
-- diagnoses somebody out of itself.
--
-- Running it without it running you sits fourth, and it is the one this app's
-- readers need most. These products are unusually good at making a quiet
-- person feel personally rejected several times a week, and the topic
-- currently does not say a word about it.
--
-- Both are appended, so nothing already seeded moves and no sort_order has to
-- be shifted. Safe to apply before their lessons exist only in the sense that
-- nothing breaks — but the tracks will read as "Not written yet" until they
-- do, so hold it.

insert into public.skills (
  topic_id, slug, name, description, core_idea, takeaway_md, sort_order
)
values
(
  (select id from public.topics where slug = 'dating-apps'),
  'running-the-app',
  'Running it without it running you',
  $$Forty swipes, two matches, one reply, no reply. What that does to somebody over six months, and how to stop it.$$,
  $$Volume is arithmetic, not a rating. Give the app a shape — when you open it, how long, and when you stop — and take the silence as noise.$$,
  $md$Nothing else in this topic matters if you have stopped believing it can work, and these apps are unusually good at producing exactly that.

The mechanism is arithmetic that feels like judgement. You swipe forty times and match twice. You send eight messages and get three replies. Two conversations fade, one arranges a drink and then does not confirm. Every one of those is an ordinary base rate and every one of them arrives feeling like a small personal verdict — and a quiet person, who was already inclined to read silence as information about themselves, gets several of these a day.

**The move:** treat the numbers as arithmetic, and give the app a shape.

The arithmetic half first. Nobody publishes the base rates, so people invent their own out of hope, and then measure themselves against something imaginary. Match rates in the low single digits are normal. Most matches never speak. Most conversations do not become dates. This is not a description of you doing badly — it is a description of how the product works, and the people who seem to do well on it are experiencing the same ratios with a larger numerator.

The shape half is what actually protects you. An app with no rules attached is designed to be opened at eleven at night, scrolled at, and closed feeling slightly worse. Decide when you open it, how long for, and what you do while it is open — and then, crucially, decide when you stop. Twenty minutes twice a week with intent beats two hours of grazing, and it produces more, not less.

And the app is not the only route. It is one channel, it suits some people badly, and a month away from it is not a failure — it is a reasonable thing to do with a tool that is currently costing more than it returns.

If you keep one thing: silence is noise, not a message. You are reading a base rate, and it was never about you.$md$,
  4
),
(
  (select id from public.topics where slug = 'dating-apps'),
  'where-it-is-breaking',
  'Where it is breaking',
  $$It is not working, and you have been fixing the wrong part of it for four months.$$,
  $$Four joins: matches, replies, dates, second dates. Each failure points somewhere different, and only one of them is fixed by editing your profile.$$,
  $md$Almost nobody using these apps knows which part of their own process is failing, so almost everybody optimises the same thing — the profile — because it is the only part you can edit while sitting on the sofa.

Frequently the profile is fine.

**The move:** find the join that is breaking before changing anything.

It is a funnel with four of them, and each failure means something different.

**No matches.** This one genuinely is the profile — and specifically the first photo and the first line, not the clever prompt at the bottom that nobody reaches. It is also the most fixable thing on this list, usually in an afternoon.

**Matches, but no conversation.** The profile is working; the opener is not. Either you are not sending one, or you are sending something that could have been sent to anybody. Track two of this topic is the whole answer.

**Conversations that fade.** You are not asking, or you are asking without a day in it. This is by far the most common place for the whole thing to break, and it is invisible because a fading conversation feels like something that happened to you rather than something you did not do.

**Dates, but no second dates.** This is not an app problem, and no amount of work on this topic will touch it. That is what The first date is for, and going back to your photos when this is the join that is failing is how people spend a year on the wrong thing.

Count before you conclude. Four weeks of actual numbers — matches, replies, dates — will tell you in five minutes what four months of guessing has not, and it will usually be somewhere you were not looking.

If you keep one thing: diagnose, then fix. The part you can edit from the sofa is rarely the part that is broken.$md$,
  5
);
