-- Proofreading pass, topic 6 of 11: The first date.
--
-- Twenty lessons read. Four defects, and three of them are the same one: this
-- is the topic that got renumbered. Migration 37 deleted a track, folded
-- another into its neighbour and renumbered what was left, and the positional
-- cross-references were not updated with it.
--
-- Positional references are an established convention here — about fifty-five
-- across the app, nearly all correct and pointing within their own topic — so
-- the fix is not to abolish them. It is to correct these, and to name the
-- track rather than count to it wherever the reference reaches back further
-- than one step, since a name survives a reorder and a position does not.
--
-- The tell that this had already gone wrong: lesson 2.5 says "the next track"
-- in its theory and "the last track" in its worked example, about the same
-- track. One of them was right.

-- 1. The plan is track four, not track three. The example already said so.
update public.lessons l
  set theory_md = replace(
    l.theory_md,
    'That is the whole of the next track, and it starts here, with having heard it.',
    'That is the whole of the final track, and it starts here, with having heard it.'
  )
  from public.skills s
  where l.skill_id = s.id and s.slug = 'the-conversation' and l.sort_order = 5;

-- 2. The callback lesson is the last one of Two hours of talking, which is two
--    tracks back from here rather than one. Named rather than counted.
update public.lessons l
  set theory_md = replace(
    l.theory_md,
    'The last lesson of the previous track was for exactly this:',
    'The last lesson of Two hours of talking was for exactly this:'
  ),
      checks_json = replace(
    l.checks_json::text,
    'which is the last lesson of the previous track doing its job',
    'which is the last lesson of Two hours of talking doing its job'
  )::jsonb
  from public.skills s
  where l.skill_id = s.id and s.slug = 'what-happens-next' and l.sort_order = 3;

-- 3. "Every earlier track in this app taught deniability" is not true of the
--    app. Interviews, Work and Storytelling teach the opposite — name the
--    figure, say the point first, say the plain thing. Deniability is taught
--    in the two flirting tracks, which is what this sentence is reaching for.
update public.lessons l
  set theory_md = replace(
    l.theory_md,
    'Every earlier track in this app taught deniability.',
    'The flirting tracks taught deniability.'
  )
  from public.skills s
  where l.skill_id = s.id and s.slug = 'what-happens-next' and l.sort_order = 2;
