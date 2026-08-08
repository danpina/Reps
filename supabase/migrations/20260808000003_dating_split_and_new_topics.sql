-- Dating becomes three situations, and two more topics get their placeholders.
--
-- Dating was one topic covering approaching somebody, flirting, apps, and the
-- date itself. That cannot work here, because a topic is a single ordered road:
-- a skill only opens once the one before it has been read. Somebody who came
-- for the apps would have had to read fifteen lessons about bars to reach their
-- first message, and the gate that makes a track coherent is exactly what would
-- have made a broad one unusable.
--
-- Three, rather than two, because the date is where both paths meet. Sitting it
-- at the end of the in-person topic would put it behind fifteen lessons nobody
-- who met online needs.
--
-- Named as situations rather than as "Dating: X". A topic here is written for
-- one situation and nothing else, and three entries beginning with the same
-- word read as one topic wearing three hats.

-- ---------------------------------------------------------------------------
-- The topic that already has content becomes the in-person one, in place.
--
-- Renamed rather than replaced so that the two skills already written for it
-- keep their lessons, their rehearsal modes and everyone's progress through
-- them — and so profiles.starting_topic_id still points at something.
--
-- The promise is the part that most needed rewriting. It read "leave warmly
-- when the answer is no — which is the skill that makes every other one here
-- safe to practise", which sells the whole topic as risk management. Handling a
-- no well is genuinely in here and it is genuinely valuable, but it is what you
-- learn on the way to being able to walk up to somebody, not the reason to.
-- ---------------------------------------------------------------------------

update public.topics set
  slug = 'meeting-someone',
  name = 'Meeting someone',
  description = $$The two seconds before you say anything to someone you are drawn to — in a bar, a gym, a bookshop, a queue.$$,
  promise = $$Walk up and start it, and know while it is still happening whether it is landing.$$
where slug = 'dating';

-- Which skill sits first decides which two lessons are free, since the sample
-- is the first two lessons of a topic's first skill. Dating's shop window was
-- "The three signals" — spotting that somebody is not interested, rehearsed
-- against a partner instructed never to warm up no matter what you say. That is
-- not a taster, it is a discouragement, and it was the first thing a nervous
-- person saw. Flirting leads until the venue track is written, and that becomes
-- the first skill when it exists.
update public.skills s set sort_order = 99
from public.topics t
where s.topic_id = t.id and t.slug = 'meeting-someone' and s.slug = 'reading-disinterest';

update public.skills s set sort_order = 1
from public.topics t
where s.topic_id = t.id and t.slug = 'meeting-someone' and s.slug = 'flirting-calibration';

update public.skills s set sort_order = 2
from public.topics t
where s.topic_id = t.id and t.slug = 'meeting-someone' and s.slug = 'reading-disinterest';

-- ---------------------------------------------------------------------------
-- Room for the new ones. sort_order is unique, so everything moves out of the
-- way before anything moves into place.
-- ---------------------------------------------------------------------------

update public.topics set sort_order = sort_order + 100;

update public.topics set sort_order = 1 where slug = 'small-talk';
update public.topics set sort_order = 2 where slug = 'interviews';
update public.topics set sort_order = 3 where slug = 'work';
update public.topics set sort_order = 4 where slug = 'meeting-someone';
-- 5 and 6 are the other two halves of dating, inserted below.
update public.topics set sort_order = 7 where slug = 'making-friends';
update public.topics set sort_order = 8 where slug = 'hard-conversations';
update public.topics set sort_order = 9 where slug = 'storytelling';
-- 10 and 11 are the two new ones, inserted below.

insert into public.topics (slug, name, description, promise, sort_order)
values
  (
    'dating-apps',
    'Dating apps',
    $$A match, a blank message box, and a conversation that has to survive with no tone, no timing and no face.$$,
    $$Send the first message, keep it alive past the third reply, and get off the app and into a room.$$,
    5
  ),
  (
    'first-date',
    'The first date',
    $$Two hours, one person, and no queue to leave. The part no app can do for you.$$,
    $$Fill two hours without dread, work out whether you actually like them, and end it so you both know where you stand.$$,
    6
  ),
  (
    -- Deliberately not about dating. This is the everyday written register:
    -- the group chat, the colleague you have never spoken to, the question you
    -- rewrote four times before sending.
    'online-chatting',
    'Messaging',
    $$Slack, WhatsApp, the group chat, and the message to a colleague you have never actually spoken to.$$,
    $$Ask for what you need without three paragraphs of apology in front of it, and be the person who is easy to reply to.$$,
    10
  ),
  (
    -- It belongs here for the reason it looks like it does not: getting what
    -- you want out of a model is a briefing problem, and briefing is a
    -- conversation skill. Say what you want, say what good looks like, say what
    -- to do when it is unsure.
    'ai-prompting',
    'Talking to AI',
    $$Asking a machine for what you want, which turns out to be the same problem as briefing a colleague who cannot read your mind.$$,
    $$Ask once and get something usable, instead of five rounds of working out what you meant.$$,
    11
  );
