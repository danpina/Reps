-- Proofreading pass, topic 5 of 11: Dating apps — and a functional gap it
-- turned up elsewhere.
--
-- Dating apps itself is clean. Twenty-four lessons read, no defects, which is
-- the first topic to come through with nothing at all.
--
-- What the pass did find is in the rehearsal word lists. The line checker
-- lowercases and strips punctuation but does not normalise spelling, so a
-- forbidden word listed in one spelling is not caught in the other. The
-- interview-failure drill already handles this correctly by listing both
-- "apologise" and "apologize"; across all 169 word lists in the curriculum,
-- exactly two miss their counterpart.
--
-- Both matter, because in both drills the forbidden word is the entire point
-- of the exercise. A reader who writes "disorganized" is doing the thing the
-- lesson exists to stop, and was being told they had passed.

update public.lessons l
  set rehearsal_spec = replace(
    l.rehearsal_spec::text, '"disorganised"', '"disorganised","disorganized"'
  )::jsonb
  from public.skills s
  where l.skill_id = s.id and s.slug = 'raising-a-problem' and l.sort_order = 1;

update public.lessons l
  set rehearsal_spec = replace(
    l.rehearsal_spec::text, '"realise"', '"realise","realize"'
  )::jsonb
  from public.skills s
  where l.skill_id = s.id and s.slug = 'worth-having' and l.sort_order = 2;
