-- Proofreading pass, topic 8 of 11: Hard conversations — and one thing it
-- turned up in a topic already signed off.
--
-- Hard conversations itself is clean. Twenty-five lessons read, no defects.
-- Its counting claims were checked by hand and all hold: the five reactions in
-- 4.1, the three parts in 3.1, the three-part answer in 4.4.
--
-- Checking those by hand suggested automating it, since the Small talk "Two
-- rules" defect found earlier was exactly this class. Across the curriculum
-- there are 43 places where a count is announced and then followed by a bolded
-- list. Forty-two agree. One does not, and it is in Interviews — a topic this
-- pass had already finished, which is a fair reminder that reading carefully
-- and checking mechanically catch different things.
--
-- The lesson says fit on a phone call is carried "almost entirely by two
-- things: how long your sentences are, and how formal they are", and then
-- lists three: Length, Formality, Pace. The list is what the reader actually
-- works from, so the sentence is corrected to match it rather than deleting a
-- bullet that is doing real work. The move deliberately still names only the
-- two that matter most, which is emphasis rather than contradiction.

update public.lessons l
  set theory_md = replace(
    l.theory_md,
    'fit is carried almost entirely by two things: how long your sentences are, and how formal they are.',
    'fit is carried almost entirely by three things: how long your sentences are, how formal they are, and how fast you go.'
  )
  from public.skills s
  where l.skill_id = s.id and s.slug = 'interview-rapport' and l.sort_order = 2;
