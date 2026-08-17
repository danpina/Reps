-- Proofreading pass, topic 3 of 11: Work.
--
-- Forty lessons read. One defect, which is the cleanest result of the three
-- topics so far — this topic was written after the shape settled, and it
-- shows: every lesson carries its closer, the theory cards run to length, and
-- the voice does not drift.
--
-- "adds nothing away" is a collision between "gives nothing away" and "adds
-- nothing". The sentence is about a neutral reply that concedes no ground, so
-- it wants the first one.

update public.lessons l
  set theory_md = replace(
    l.theory_md,
    'is neutral and adds nothing away.',
    'is neutral and gives nothing away.'
  )
  from public.skills s
  where l.skill_id = s.id and s.slug = 'asking-for-money' and l.sort_order = 2;
