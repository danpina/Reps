-- Proofreading pass, topic 11 of 11: Talking to AI.
--
-- Thirty lessons. Seven defects, all of them the same one, and all in the
-- cross-references rather than in the prose — which is where this pass has
-- found nearly everything.
--
-- This topic's tracks refer to each other more than any other topic's do, and
-- it was written fastest. The order is:
--
--   1 An answer worth having   2 The free question   3 Edit, do not write
--   4 Rehearse it first        5 It does not know the room
--   6 Do not outsource the reps
--
-- Four references in Edit, do not write point at "the next track" for material
-- about what the reader will think and whether to send — which is It does not
-- know the room, two tracks on, not Rehearse it first. One in An answer worth
-- having sends improvement-by-addition to "the next track" when it belongs to
-- Edit, do not write. One in Do not outsource the reps attributes the list of
-- tells to "the previous track" when the tells are in Edit, do not write. And
-- one in Rehearse it first says "the last track" meaning the previous one,
-- while everywhere else in the topic "the last track" means track six.
--
-- All named rather than counted. Eleven references in the topic were checked;
-- the other four are correct, including two that reach into Messaging.

-- 1. Improvement-by-addition belongs to Edit, do not write.
update public.lessons l
  set rehearsal_spec = replace(
    l.rehearsal_spec::text,
    'That is the next track''s problem.',
    'That is what Edit, do not write is for.'
  )::jsonb
  from public.skills s
  where l.skill_id = s.id and s.slug = 'an-answer-worth-having' and l.sort_order = 4;

-- 2. The tells are the fourth lesson of Edit, do not write, not of track five.
update public.lessons l
  set theory_md = replace(
    l.theory_md,
    'the fourth lesson of the previous track is a list of how it is noticed',
    'the fourth lesson of Edit, do not write is a list of how it is noticed'
  )
  from public.skills s
  where l.skill_id = s.id and s.slug = 'do-not-outsource-the-reps' and l.sort_order = 2;

-- 3. Four pointers in one lesson, all aimed two tracks on rather than one.
update public.lessons l
  set theory_md = replace(
        l.theory_md,
        'Those are the next track.',
        'Those are It does not know the room.'
      ),
      checks_json = replace(
        replace(
          l.checks_json::text,
          'That is the line, and the next track holds the other side of it.',
          'That is the line, and It does not know the room holds the other side of it.'
        ),
        'it is the whole of the next track.',
        'it is the whole of It does not know the room.'
      )::jsonb,
      rehearsal_spec = replace(
        l.rehearsal_spec::text,
        'which is the next track''s opening lesson.',
        'which is the opening lesson of It does not know the room.'
      )::jsonb
  from public.skills s
  where l.skill_id = s.id and s.slug = 'edit-do-not-write' and l.sort_order = 5;

-- 4. "The last track" means track six everywhere else in this topic. Here it
--    meant the one before, which is Edit, do not write.
update public.lessons l
  set theory_md = replace(
    l.theory_md,
    'the wording should be yours, per the last track',
    'the wording should be yours, per Edit, do not write'
  )
  from public.skills s
  where l.skill_id = s.id and s.slug = 'rehearse-it-first' and l.sort_order = 3;
