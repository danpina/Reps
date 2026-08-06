-- Better words for the topics.
--
-- The first descriptions were definitions: "starting, holding and ending a
-- conversation with someone you barely know". Accurate, and it reads like the
-- contents page of a textbook. Somebody choosing a topic is not looking for a
-- definition of small talk — they already know what it is, which is precisely
-- why they are here.
--
-- So each description now names a moment the reader has actually lived. The
-- recognition is what creates the wanting; the promise underneath it is what
-- the content then has to earn.
--
-- Written as updates rather than by editing the seed, because the seed has
-- already run everywhere it matters.

update public.topics set
  description = $$You both know one of you should say something. Neither of you does. This is the topic about saying it.$$,
  promise = $$Walk into a room where you know nobody, and leave having had three conversations you would happily have again.$$
where slug = 'small-talk';

update public.topics set
  description = $$You have done the work. Now you have forty minutes to prove it to a stranger with a notepad, and most of it comes down to six questions.$$,
  promise = $$Answer the handful of questions that decide most interviews without freezing, waffling, or quietly underselling work you actually did — and know what to say in the last five minutes, when almost everyone says nothing.$$
where slug = 'interviews';

update public.topics set
  description = $$The meeting where you had the right answer and said nothing. The raise you still have not asked for. The presentation you read off your own slides.$$,
  promise = $$Say the thing in the meeting while it still counts, ask for the money without apologising for asking, and hold a room you did not expect to be standing in front of.$$
where slug = 'work';

update public.topics set
  description = $$Telling the difference between polite and interested while it is still happening — rather than at two in the morning, three days later.$$,
  promise = $$Read interest accurately, show your own a notch at a time, and leave warmly when the answer is no — which is the skill that makes every other one here safe to practise.$$
where slug = 'dating';

update public.topics set
  description = $$You get on. You have both said "we should do something". Neither of you has. This is the topic about the next move.$$,
  promise = $$Turn someone you get on with into someone you actually see, on purpose, in a few weeks rather than a few years.$$
where slug = 'making-friends';

update public.topics set
  description = $$The one you have been rehearsing in the shower for a month and still have not had.$$,
  promise = $$Say the thing you have been swallowing, in a way that keeps the person — and stay in the room while it is uncomfortable.$$
where slug = 'hard-conversations';

update public.topics set
  description = $$You finish the story. There is a small pause. Someone says "oh, right". It was a good story.$$,
  promise = $$Tell the story you always tell badly, well — and be able to stand up with no warning and be worth listening to.$$
where slug = 'storytelling';
