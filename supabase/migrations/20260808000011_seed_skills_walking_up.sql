-- Meeting someone, the track it was promising and did not have.
--
-- The topic sells "Walk up and start it, and know while it is still happening
-- whether it is landing." The second half was delivered by Flirting and Reading
-- disinterest. The first half had no content at all: skill one opened with "the
-- conversation has been going well for ten minutes", which assumes the walking
-- up already happened.
--
-- Organised by the variable rather than by the venue. Five lessons named after
-- rooms would be five openers with different scenery, and Small talk already
-- owns the opener. What actually changes between a queue and a gym is licence,
-- time and exit cost — and those three explain why the easiest room in the
-- world is the one people walk out of having said nothing, and why the hardest
-- is the one they try first.

insert into public.skills (
  topic_id, slug, name, description, core_idea, takeaway_md, sort_order
)
values (
  (select id from public.topics where slug = 'meeting-someone'),
  'walking-up',
  'Walking up',
  $$The bar, the queue, the gym, the bookshop — and the twenty seconds before you decide whether this is a room where you can.$$,
  $$Every room gives you three things: licence to speak, time before it ends itself, and what it costs if it goes flat. Read those and the opener takes care of itself.$$,
  $md$You do not need a different opener for every room. You need to know what the room is doing to you.

Three things change and nothing else does. Licence is how normal it is to speak to a stranger here — high in a queue or a delay, near zero in a gym or a quiet carriage. Time is how long the situation lasts on its own: a lift is forty seconds, a queue is four minutes, a party is unbounded. Exit cost is what it costs you if it goes flat, and it is the one nobody counts.

The combinations are what matter. High licence with a hard clock is the easiest room there is, and it is the one people most often leave having said nothing, because the same clock that makes it safe is the clock that runs out. Unbounded rooms feel harder and are not — the difficulty is that nothing ends it for you, so you have to supply the ending yourself, and knowing you can end it is what makes starting bearable.

The repeating rooms are the exception to everything. A gym, a class, the same café on the same morning: licence there is earned over weeks rather than minutes, the exit cost is the highest available, and the payoff is that familiarity does the work an opener would have to do anywhere else. The correct speed is far slower than feels natural, and almost everybody gets it wrong in the same direction.

If you keep one thing: an opener that would have worked in another room has not failed. You used it in the wrong one.$md$,
  99
);

-- Flirting and Reading disinterest move down one. sort_order is unique per
-- topic, so they clear out before anything lands.
update public.skills s set sort_order = s.sort_order + 100
from public.topics t
where s.topic_id = t.id and t.slug = 'meeting-someone' and s.slug <> 'walking-up';

update public.skills s set sort_order = m.pos
from public.topics t,
  (values
    ('walking-up', 1),
    ('flirting-calibration', 2),
    ('reading-disinterest', 3)
  ) as m (skill_slug, pos)
where s.topic_id = t.id and t.slug = 'meeting-someone' and s.slug = m.skill_slug;
