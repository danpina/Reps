-- Proofreading pass over the whole corpus: the defects it actually found.
--
-- 364,000 authored words checked for doubled words, doubled spaces, spacing
-- before punctuation, unbalanced emphasis, mixed straight and curly quotes,
-- American spellings against the house's British style, and rare words one
-- edit away from a common one. Two real defects, both below.
--
-- Everything else the checks flagged was a false positive worth recording so
-- the next pass does not re-investigate them: "right_size" and "normal_size"
-- are rubric keys rather than prose; "Seize" tripped the -ize rule; "wasnt"
-- and "wont" are correct inside rehearsal word lists, because the checker
-- strips apostrophes from the line and the target alike before comparing;
-- "one one-word reply" is correct English; and the most repeated sentences in
-- the corpus are the scenario constraints, which are boilerplate on purpose
-- and one of which is enforced by a test.

-- "Why is is this going well the wrong question?" was grammatical — the inner
-- "is this going well" is a quoted question — but it can only be read that way
-- with quotation marks the prompt does not carry. Rephrased rather than
-- punctuated, so it survives being read plainly.
update public.lessons l
  set checks_json = jsonb_set(
    l.checks_json,
    '{0,prompt}',
    to_jsonb('Why is asking whether it is going well the wrong question?'::text)
  )
  from public.skills s
  where l.skill_id = s.id
    and s.slug = 'do-you-like-them'
    and l.sort_order = 2;

-- A stray double space after the em dash, where the line breaks off mid-word.
update public.lessons l
  set examples_json = jsonb_set(
    l.examples_json,
    '{1,line}',
    to_jsonb(
      'I moved to the second place for a bigger team, and then— [stop]. I moved to the second place, and that is where the interesting bit starts.'::text
    )
  )
  from public.skills s
  where l.skill_id = s.id
    and s.slug = 'interview-your-story'
    and l.sort_order = 3;
