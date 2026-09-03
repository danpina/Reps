-- Two false-friend / non-word translations, caught on a second read of the
-- Spanish curriculum.
--
-- "Eventualmente" translated "eventually" literally, but Spanish
-- "eventualmente" means "possibly, if it happens" — the opposite of what
-- these two sentences intend ("in due course, given enough time"). The fix
-- is "con el tiempo", which keeps the same sentence shape and means what the
-- English actually said.
--
-- "Factualmente" is not a Spanish word at all — it was coined by analogy to
-- English "factually". "Objetivamente" says the same thing (the content was
-- right, even though it read cold) in an actual word.

update public.lesson_translations lt
set scenario_json = jsonb_set(
  scenario_json,
  '{partner,personality}',
  to_jsonb(replace(scenario_json #>> '{partner,personality}', 'eventualmente', 'con el tiempo')),
  false
),
updated_at = now()
from public.lessons l
join public.skills s on s.id = l.skill_id
where lt.lesson_id = l.id
  and lt.locale = 'es'
  and s.slug = 'stop-apologising'
  and l.sort_order = 1
  and scenario_json #>> '{partner,personality}' like '%eventualmente%';

update public.lesson_translations lt
set theory_md = replace(theory_md, 'eventualmente se aburre', 'con el tiempo se aburre'),
    updated_at = now()
from public.lessons l
join public.skills s on s.id = l.skill_id
where lt.lesson_id = l.id
  and lt.locale = 'es'
  and s.slug = 'do-not-outsource-the-reps'
  and l.sort_order = 4
  and theory_md like '%eventualmente se aburre%';

update public.lesson_translations lt
set scenario_json = jsonb_set(
  scenario_json,
  '{setting}',
  to_jsonb(replace(scenario_json ->> 'setting', 'factualmente perfecta', 'objetivamente perfecta')),
  false
),
updated_at = now()
from public.lessons l
join public.skills s on s.id = l.skill_id
where lt.lesson_id = l.id
  and lt.locale = 'es'
  and s.slug = 'tone-with-no-tone'
  and l.sort_order = 1
  and scenario_json ->> 'setting' like '%factualmente perfecta%';
