-- Proofreading pass, topic 9 of 11: Storytelling & speaking.
--
-- Twenty-five lessons read. One defect, and it is the same family as the ones
-- in The first date: a cross-reference that points at the wrong place.
--
-- "the last lesson of the previous track's neighbour" is garbled as English
-- and wrong as a pointer. The instruction it means is "Know your last line",
-- which is lesson four of Telling it — the track after this one, not the one
-- before, and not the last lesson of anything.
--
-- Named rather than counted, for the same reason as migration 93: a name
-- survives a reorder and a position does not.
--
-- Everything else in the topic checks out, including the references that could
-- easily have been wrong. 3.4 sends the reader back to "the previous track's
-- problem" for a missing turn, which is The shape, and correct. 4.1 points at
-- "the fourth lesson in this track" for reading the room, which is When not to
-- tell one, and correct. 4.5 borrows "keep going at the same volume" from
-- Work's meetings track, and that is what Work says.

update public.lessons l
  set theory_md = replace(
    l.theory_md,
    'this is the same instruction as the last lesson of the previous track''s neighbour: know the last line before you start.',
    'this is the same instruction as *Know your last line* in the next track: know the last line before you start.'
  )
  from public.skills s
  where l.skill_id = s.id and s.slug = 'the-shape' and l.sort_order = 2;
