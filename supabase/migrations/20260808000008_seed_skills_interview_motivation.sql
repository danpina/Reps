-- Interviews, the missing track: the questions that are not about competence.
--
-- Seven of the eight existing tracks answer "can you do it". Nothing answered
-- the other half of an interview — do you want *this*, and will you still be
-- here in two years. Grepping the forty lessons for the questions everybody is
-- actually asked finds none of them: five years, why are you leaving, why
-- should we hire you, what motivates you, where else are you interviewing.
--
-- They are one cluster rather than a scattering of leftovers, and they are the
-- questions a candidate is least prepared for, because they sound like small
-- talk and are scored like everything else.
--
-- It goes second, straight after Your story, because that is where it happens:
-- "tell me about yourself" is followed by "so why are you looking?" in almost
-- every real interview, and those two answers are the only ones you are
-- guaranteed to be asked. Everything below it shifts down one. The free sample
-- stays with Your story, so nothing about the paywall moves.

insert into public.skills (
  topic_id, slug, name, description, core_idea, takeaway_md, sort_order
)
values (
  (select id from public.topics where slug = 'interviews'),
  'interview-motivation',
  'Why you, and why now',
  $$Leaving, five years, why we should hire you — the questions that are not about whether you can do the job.$$,
  $$They are checking two things: that this job is on a road you were already walking, and that you will not be gone in eight months. Point every answer forwards.$$,
  $md$Half of an interview is not about competence at all, and it is the half nobody rehearses.

Why you are leaving is asked every single time, and it is answered forwards. Whatever you say about your current employer is heard as a preview of what you will say about this one in two years, so the useful version names what you have run out of rather than what you are escaping. Run out of is the phrase: honest, unbitter, and impossible to argue with.

Five years is not a request for a plan and they do not believe you have one. They are checking that the road you are on runs through this job. A title is the wrong answer — it is either flattery or a threat — and a direction is the right one, because a direction can be checked against your CV.

Why should we hire you is the only question in the whole process that invites you to argue your own case, and most people decline the invitation out of politeness. They asked. Name what the job turns on, claim it, and attach the one piece of evidence that makes the claim checkable.

What motivates you fails generically for a specific reason: the usual answers are unfalsifiable. A real motivation explains something on your CV that would otherwise look odd — why you stayed too long, why you moved sideways, why you keep landing on the same kind of mess. If your answer explains nothing on the page, it is a value statement rather than a motivation.

If you keep one thing: never invent a competing offer. It is checkable, it sets a deadline you made up, and if anybody calls it you have nothing left to say.$md$,
  99
);

-- Everything from Answering with evidence down moves one place. sort_order is
-- unique per topic, so the existing seven clear out before anything lands.
update public.skills s set sort_order = s.sort_order + 100
from public.topics t
where s.topic_id = t.id and t.slug = 'interviews' and s.slug <> 'interview-motivation';

update public.skills s set sort_order = m.pos
from public.topics t,
  (values
    ('interview-your-story', 1),
    ('interview-motivation', 2),
    ('interview-evidence', 3),
    ('interview-failure', 4),
    ('interview-craft', 5),
    ('interview-rapport', 6),
    ('interview-your-questions', 7),
    ('interview-money', 8),
    ('interview-closing', 9)
  ) as m (skill_slug, pos)
where s.topic_id = t.id and t.slug = 'interviews' and s.slug = m.skill_slug;
