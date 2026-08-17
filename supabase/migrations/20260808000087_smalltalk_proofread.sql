-- Proofreading pass, topic 1 of 11: Small talk.
--
-- Forty lessons read. The prose is in good shape — no typos, no clumsy
-- sentences — so everything below is consistency rather than error.
--
-- Nothing structural is changed here. The topic averages 152 words a lesson
-- against 313–346 for everything written later, and none of its forty lessons
-- carries the "If you keep one thing" closer. Both are known and deliberately
-- left alone.

-- 1. British spelling. The corpus writes "labelled" (6) and "mislabelled" (1)
--    but "labeling" (3) and "mislabeling" (3), so the -ed forms are British
--    and the -ing forms American, in the same topic. The skill slug is left
--    alone on purpose: it is a URL and the cheat sheet keys its groups on it.
--    The sheet's heading comes from the skill name, so renaming updates it.
update public.skills
  set name = 'Listening & labelling'
  where slug = 'listening-and-labeling';

update public.skills
  set core_idea = replace(core_idea, 'mislabeling', 'mislabelling')
  where slug = 'banter';

update public.lessons l
  set title = 'Playful mislabelling',
      checks_json = replace(l.checks_json::text, 'Mislabeling', 'Mislabelling')::jsonb
  from public.skills s
  where l.skill_id = s.id and s.slug = 'banter' and l.sort_order = 2;

update public.lessons l
  set theory_md = replace(l.theory_md, 'people labeling feelings', 'people labelling feelings')
  from public.skills s
  where l.skill_id = s.id and s.slug = 'listening-and-labeling' and l.sort_order = 4;

-- 2. Three questions punctuated as statements. The app does write questions
--    with full stops on purpose elsewhere — that is the openers lesson, where
--    the point is to replace the question mark so the silence does the asking.
--    These are not that: they are questions being asked, in a lesson about
--    asking them.
update public.lessons l
  set theory_md = replace(
    l.theory_md,
    '*Is this the plan or a stepping stone. Would you do it again. What would you do if the money were the same either way.*',
    '*Is this the plan or a stepping stone? Would you do it again? What would you do if the money were the same either way?*'
  )
  from public.skills s
  where l.skill_id = s.id and s.slug = 'going-deeper' and l.sort_order = 4;

-- 3. The hook lesson announces "Two rules", gives two, then introduces a third
--    as "The other rule". Demoted to a plain instruction so the count holds.
update public.lessons l
  set theory_md = replace(
    l.theory_md,
    'The other rule is not to use it every time.',
    'And do not use it every time.'
  )
  from public.skills s
  where l.skill_id = s.id and s.slug = 'exits' and l.sort_order = 3;

-- 4. A metaphor that fights the one this topic already established. Skill 3
--    builds the Curiosity Ladder, where climbing *up* is what gets you deeper
--    — "take one step up", "the top rung". Two skills later, depth increases
--    by going *down*. Rewritten to drop the direction rather than to pick one,
--    since the sentence does not need it.
update public.lessons l
  set theory_md = replace(
    l.theory_md,
    'Opinions are a step down.',
    'Opinions are a step deeper.'
  )
  from public.skills s
  where l.skill_id = s.id and s.slug = 'reciprocity' and l.sort_order = 2;
