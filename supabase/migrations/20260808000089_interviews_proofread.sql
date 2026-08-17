-- Proofreading pass, topic 2 of 11: Interviews, part two.
--
-- Skills 4 to 9 read. Two defects, one of them mine.

-- 1. A sentence that does not parse. "claiming to did not happen" was meant to
--    say that the version where you took it well is not the version anybody
--    believes. It is the only broken sentence found in 364,000 words.
update public.lessons l
  set theory_md = replace(
    l.theory_md,
    'and claiming to did not happen.',
    'and claiming you did is the part nobody believes.'
  )
  from public.skills s
  where l.skill_id = s.id and s.slug = 'interview-failure' and l.sort_order = 4;

-- 2. Introduced by migration 88, which converted quotation marks to italics.
--    One converted span landed inside a bold run, and the renderer's bold
--    pattern is `\*\*[^*]+\*\*` — it cannot contain a star. So the bold stopped
--    matching and the card would have printed literal asterisks on the page.
--
--    Migration 88 has been corrected in place as well, so a replay from an
--    empty database produces the right text and this statement becomes a no-op.
--    It is still needed here because 88 was already applied.
--
--    The guard that should have caught it only read dollar-quoted $md$ blocks,
--    so it never saw the fifty-one cards 88 rewrote as plain SQL literals. It
--    now reads both shapes, and fails on this exact string when reverted.
update public.lessons l
  set theory_md = replace(
    l.theory_md,
    '**Have something to say to *how are you*.**',
    '**Have something to say when they ask how you are.**'
  )
  from public.skills s
  where l.skill_id = s.id and s.slug = 'interview-rapport' and l.sort_order = 4;
