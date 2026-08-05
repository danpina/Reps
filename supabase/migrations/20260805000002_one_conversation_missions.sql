-- One conversation per mission, not three.
--
-- Forty-five lessons at three conversations each is a hundred and thirty-five
-- reps to work through the curriculum, which makes every mission read as a
-- chore. One real conversation is the unit that matters, and forty-five of
-- those is already a serious amount of practice.
--
-- The seed files carry the same wording, so a fresh install and an existing
-- database agree.

update public.lessons
  set mission_text = $md$Start one conversation today with an Environment opener, something you and the other person are both already in. Say it, then stop talking. Log it even if it went nowhere.$md$
  where mission_text like 'Start three conversations today with an Environment opener%';

update public.lessons
  set mission_text = $md$Before you open a conversation today, take two seconds to check whether the person is actually available. Log what signal you read and whether your read turned out to be right.$md$
  where mission_text like 'Today, before you open a single conversation, take two seconds%';

update public.lessons
  set mission_text = $md$Today, open one conversation with a statement rather than a question. No question mark in your first line. Log what you said and what came back.$md$
  where mission_text like 'Today, open three conversations with a statement%';

update public.lessons
  set mission_text = $md$In one conversation today, make your second line come out of their answer instead of your head. Go for the word with feeling in it. Log the word you picked and where it led.$md$
  where mission_text like 'Today, in three conversations, make your second line%';

update public.lessons
  set mission_text = $md$Today, end one conversation with a reason, one specific warm thing, and an actual departure. Log the specific thing you said.$md$
  where mission_text like 'Today, end three conversations with a reason%';
