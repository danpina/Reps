-- Dating apps: the two tracks that turn one skill into a road.
--
-- The topic's own promise is "send the first message, keep it alive past the
-- third reply, and get off the app and into a room", and it shipped with only
-- the first of those. Which meant it taught the one moment a shy person is
-- least able to reach — you cannot write a good first message to somebody who
-- never matched you, and a good first message that goes nowhere is a worse
-- outcome than not sending it.
--
-- So a track before it and a track after it. The profile comes first because
-- it is upstream of everything: it decides who matches, what they have to say
-- to you, and whether the person who turns up is the one who was promised.
-- Getting to a date comes last because it is the only outcome the topic exists
-- for, and because "keep it alive past the third reply" was never taught
-- anywhere — the conversation dies in the first three exchanges or it does not
-- die at all.
--
-- Four lessons for the profile rather than five. It is a smaller skill than the
-- other two and padding it would have shown.

update public.skills s set sort_order = s.sort_order + 100
from public.topics t
where s.topic_id = t.id and t.slug = 'dating-apps';

insert into public.skills (
  topic_id, slug, name, description, core_idea, takeaway_md, sort_order
)
values
(
  (select id from public.topics where slug = 'dating-apps'),
  'your-profile',
  'Your profile',
  $$Six photos and forty words, doing the one job you probably were not asking them to do.$$,
  $$A profile is not an advertisement, it is a set of hooks. Every line should be something somebody could reply to.$$,
  $md$Almost everybody writes their profile as an advertisement, and an advertisement is the wrong document.

The question a profile has to answer is not *am I impressive* but *what would somebody say to me*. Those produce completely different pages. Impressive produces adjectives — adventurous, laid-back, love to laugh — and adjectives are unanswerable: there is no reply to *laid-back*. Messageable produces objects, places and opinions, and every one of those is something a stranger can pick up and open with.

This is the part of dating apps that suits a quiet person best, and almost nobody uses it that way. You do not have to be quick, or funny in the moment, or good at rooms. You get unlimited time, as many drafts as you like, and the ability to decide in advance what people will talk to you about. A well-hooked profile does the approaching for you.

Photos have jobs and most people submit six versions of one job. A face, a whole person, one doing the thing you actually do, one that shows you have people. That is not vanity, it is legibility: somebody is deciding whether they can picture an hour with you, and they cannot picture an hour with a distant figure in sunglasses.

Then filter on purpose. A profile everybody likes is a profile nobody messages, and the actual opinions — the ones a few people will bounce off — are what make the rest of it worth reading. You are not trying to be widely acceptable. You are trying to be recognisable to the few people you would like.

If you keep one thing: write things that can be replied to. Everything else is decoration.$md$,
  1
),
(
  (select id from public.topics where slug = 'dating-apps'),
  'match-to-date',
  'From match to a date',
  $$The middle nobody teaches: the first three exchanges, the interview trap, and asking so that yes is easy.$$,
  $$Answer and ask, get off the fact-swap early, and propose something specific within a few days. The app is not the point.$$,
  $md$A match is not a conversation and a conversation is not a date, and the two gaps between them are where almost everything is lost.

The first gap is the third reply. Conversations on apps die early or not at all — if it is still going after three exchanges each, it will usually keep going. So the first three carry the whole thing, and the mechanic that keeps them alive is small: answer, then ask. Answering without asking hands them a dead end. Asking without answering makes it an interview.

The interview is the second failure and it is the more common one. Two people trading facts — what do you do, where are you from, do you like your job — produces a complete profile of somebody you feel nothing about. The fix is to stop supplying data and start supplying reactions: an opinion, a small story, something you are actually like. Facts are safe and they are why so many matches fade politely.

Then move. The app is not where anything happens, and a conversation that stays there has a half-life measured in days — every message spends a little of the interest that brought you together. A few days of good exchanges is the moment, not a fortnight of them.

Ask so that yes is easy. Specific, small, and with a time in it. *We should get a drink sometime* is not a plan; *there is a place near the station, Thursday or Saturday* is one. Small matters more than clever: a drink is an hour and dinner is an evening, and an hour is what a stranger can comfortably agree to.

If you keep one thing: propose while it is still going well, not once it has started to fade. The message you are dreading is easier to send today than it will be on Friday.$md$,
  3
);

-- And the message that used to be the whole topic takes the middle.
update public.skills s set sort_order = 2
from public.topics t
where s.topic_id = t.id and t.slug = 'dating-apps' and s.slug = 'first-message';
