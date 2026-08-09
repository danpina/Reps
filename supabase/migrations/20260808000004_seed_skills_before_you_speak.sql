-- The missing half of Small talk.
--
-- Thirty-five lessons teach what to say. None of them teach what to do about
-- being frightened, which is the thing that actually stops the people this app
-- is for. Across the whole topic the words nervous, anxious, afraid, scared,
-- dread and embarrassed appear seven times, and every one of them is
-- incidental — twice describing the other person, once as an example of a bad
-- self-disclosure.
--
-- That is a curriculum written for somebody willing but unskilled. The reader
-- is somebody skilled enough and frightened. Their problem at the coffee
-- machine is not that they lack an Environment opener; it is the twenty
-- seconds before, and the walking past.
--
-- It is deliberately not called Confidence, and none of its lessons are about
-- feelings. It is the stage of a conversation that comes before the first
-- word, and it is a real stage for everyone — for the shy reader it is fear,
-- and for the reader who is simply bad at this it is a blank mind and a
-- hesitation. Same five lessons, two different reasons to need them.
--
-- It goes first, which makes it the free sample. The shop window for the whole
-- app stops being technique and becomes: this costs less than you think, and
-- here is what it actually costs.

insert into public.skills (topic_id, slug, name, description, core_idea, sort_order, takeaway_md)
values (
  (select id from public.topics where slug = 'small-talk'),
  'before-you-speak',
  'Before you say anything',
  $$The twenty seconds before the first word, and the walk-past that undoes a good week.$$,
  $$A flat opener costs about four seconds. Decide the line before you need it, go within twenty seconds, and never let a walk-past be the last thing you did.$$,
  99,
  $md$You were never short of things to say. You were short of time to say them in, because you spent it deciding.

The number that matters is four seconds. That is what a flat opener actually costs: a short reply, someone turning back to their phone, and an event they have forgotten before they reach the front of the queue. You will think about it for an hour. They will not think about it at all. Every other lesson here follows from getting that number right.

The two mechanical fixes do most of the work. Decide two or three portable lines before you are in the room, so that the moment you are in is not also the moment you are composing. Then go within twenty seconds of noticing, because the fear does not fall while you wait — it rises, and the opening closes.

The bar is not interesting. The bar is true and easy to reply to. A clever opener asks to be admired; an ordinary one asks to be answered, and only one of those is an invitation.

If you keep one thing: walking past is not neutral. A flat conversation teaches you almost nothing, but a walk-past teaches your nervous system that the situation was genuinely dangerous, and it teaches it well. You will walk past plenty — that is fine and it is not the thing to fix. The thing to fix is letting a walk-past be the last one of the day.$md$
);

-- Everything shifts down one. sort_order is unique per topic, so the existing
-- seven move clear before anything takes their place.
update public.skills s set sort_order = s.sort_order + 100
from public.topics t
where s.topic_id = t.id and t.slug = 'small-talk' and s.slug <> 'before-you-speak';

update public.skills s set sort_order = m.pos
from public.topics t,
  (values
    ('before-you-speak', 1),
    ('openers', 2),
    ('going-deeper', 3),
    ('listening-and-labeling', 4),
    ('reciprocity', 5),
    -- Exits moves above Groups and Banter. Its own first lesson calls leaving
    -- too late "the most fixable mistake in this entire curriculum", which is a
    -- strange thing for lesson thirty-one to say. More to the point, the fear
    -- of joining a group is largely the fear of being trapped in one, so the
    -- exit has to be learned before the room it makes safe.
    ('exits', 6),
    ('banter', 7),
    ('groups', 8)
  ) as m (skill_slug, pos)
where s.topic_id = t.id and t.slug = 'small-talk' and s.slug = m.skill_slug;
