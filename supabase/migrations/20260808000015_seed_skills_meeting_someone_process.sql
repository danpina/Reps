-- Meeting someone: the three tracks that make it a process rather than a start.
--
-- The topic could read a room, walk up, calibrate warmth and notice when it was
-- not mutual. What it could not do was hold the ninety seconds after the opener,
-- say what warmth is actually made of, or ask for a number — which is to say it
-- taught the beginning and the middle and stopped before the only outcome
-- anybody wants from it.
--
-- Flirting splits in two, and that is the important one. The existing track is
-- entirely about how much and when — dial, signal-then-read, attention, do less,
-- say the plain thing. Not one lesson says what a notch is made of. Give it to a
-- shy person and they will know to raise the warmth by one increment and have no
-- idea what the increment consists of. It teaches the control system and never
-- the actuators.
--
-- So the moves come first and the calibration second, because "signal, then
-- read" is meaningless if you do not know what a signal is. The moves track also
-- carries the one thing a shy reader needs most and nothing anywhere covered:
-- noticing when somebody is flirting with them.
--
-- The road, in the order it happens: read the room, hold the first two minutes,
-- know what warmth is made of, know how much of it to use, notice when it is not
-- mutual, and ask.

-- The road is renumbered, so the existing three move out of the way first.
-- (topic_id, sort_order) is unique and not deferrable, which means the new
-- skills cannot be parked on a placeholder and sorted out afterwards — they
-- have to be inserted at the positions they will keep.
update public.skills s set sort_order = s.sort_order + 100
from public.topics t
where s.topic_id = t.id and t.slug = 'meeting-someone';

insert into public.skills (
  topic_id, slug, name, description, core_idea, takeaway_md, sort_order
)
values
(
  (select id from public.topics where slug = 'meeting-someone'),
  'first-two-minutes',
  'The first two minutes',
  $$The gap between an opener that landed and an actual conversation, which is where most approaches quietly die.$$,
  $$Do not apologise for being there, swap names early, and aim to be pleasant for two minutes rather than interesting for ten.$$,
  $md$An approach does not usually fail at the opener. It fails ninety seconds later, and almost always for the same three reasons.

The first is apologising. Not in words, usually — in posture, in speed, in the half-step back and the rushed delivery that says this will not take long. All of it tells them the approach was an imposition, and if you treat it as one they will agree with you. Standing still and speaking at your normal pace is most of the work.

The second is not exchanging names. It is a tiny mechanical act and it changes the category of what is happening: before it, you are a stranger talking to somebody; after it, the two of you are having a conversation. Two minutes in is about right, and it costs nothing.

The third is aiming too high. People try to be interesting, which is effortful and legible, when the only thing the first two minutes has to establish is that this is pleasant. Pleasant is a much lower bar and it is the one that actually decides whether there is a third minute.

When it stalls — and it will, around the ninety-second mark — the fix is to go back out to the room rather than deeper into a subject that has run out. The room is the thing you still have in common.

If you keep one thing: two minutes of ordinary and warm beats forty seconds of impressive, every time.$md$,
  2
),
(
  (select id from public.topics where slug = 'meeting-someone'),
  'flirting-moves',
  'Flirting: the moves',
  $$What warmth is actually made of — teasing, the right compliment, eye contact, touch, and noticing when it is being aimed at you.$$,
  $$Flirting is warmth that could only be aimed at them, plus enough deniability that either of you could call it friendliness.$$,
  $md$Everything people call flirting is two ingredients, and once you can see them the whole thing stops being mysterious.

The first is specificity. Warmth available to anybody is friendliness; warmth that could only be aimed at this person is something else. That is the entire difference, and it is why a compliment about something they chose lands where a compliment about their face does not — one of them could only be about them, and the other has been said to them by strangers since they were fifteen.

The second is deniability. Every good move here can be read as ordinary friendliness if that is all they want it to be, which is what makes it safe to offer and easy to decline. Deniability is not cowardice, it is the mechanism: it is what lets two people find out about each other without either of them having to be the one who said it first.

Teasing works because it claims a small closeness. Small talk told you to tease the situation and never the person, and that rule was correct for strangers — here you invert it, once they have teased you, and you aim at something they chose rather than something they are.

Eye contact a beat longer than usual is the cheapest notch available, and looking away first is what keeps it warm rather than intense. Touch is a ladder, one rung at a time, and no response is a no — reading each rung is not caution bolted onto the skill, it is the skill.

If you keep one thing: you are more likely to be under-reading than over-reading. Most people who decide they were just being friendly never find out, and testing gently costs almost nothing.$md$,
  3
),
(
  (select id from public.topics where slug = 'meeting-someone'),
  'asking-for-the-number',
  'Asking for the number',
  $$The close: when to ask, how to ask so a no costs them nothing, and what to do with the answer either way.$$,
  $$Ask while it is still going well rather than as you leave, say what you want to do, and make declining free. Then text the same day.$$,
  $md$Almost everybody asks too late, and the reason is that they are waiting for a moment that does not arrive.

There is no perfect point. What there is, is a stretch where it is obviously going well, and then a decline, and the ask belongs in the first of those. Waiting until you are leaving is the worst available timing: the conversation has already cooled, you are both half-turned away, and the request arrives with nothing behind it.

Say what you want to do. A number asked for on its own is a request for permission to contact somebody; a number asked for because there is a specific thing — that place you both said you would try, the gig they mentioned — is a small, concrete proposal. The second is far easier to say yes to and far easier to say no to, which is the point.

Make declining free. Somebody who cannot decline comfortably has not really been asked, and the phrasing that gives them an exit is the same phrasing that makes a yes mean something.

Take the first no as final, warmly. A soft no is still a no, and the only thing pressing gets you is being the person they tell their friends about.

If you keep one thing: text the same day. The waiting rules are folklore, they make you look strategic rather than interested, and the thing you are trying to preserve is the mood of a conversation that is already cooling.$md$,
  6
);

-- And the three that were already here take the rest of the road: read the
-- room, hold the first two minutes, know what warmth is made of, know how much
-- of it to use, notice when it is not mutual, and ask.
update public.skills s set sort_order = m.pos
from public.topics t,
  (values
    ('walking-up', 1),
    ('flirting-calibration', 4),
    ('reading-disinterest', 5)
  ) as m (skill_slug, pos)
where s.topic_id = t.id and t.slug = 'meeting-someone' and s.slug = m.skill_slug;

-- Calibration now follows the moves, so its description should stop implying it
-- is where flirting starts.
update public.skills set
  description = $$How much warmth, and when — offered a notch at a time and checked each time.$$
where slug = 'flirting-calibration';
