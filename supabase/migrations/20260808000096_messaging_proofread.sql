-- Proofreading pass, topic 10 of 11: Messaging.
--
-- Twenty-five lessons read. One defect, in two places, and it is the same
-- family again: a cross-reference counted rather than named.
--
-- The turn-taking trap is described as stalling "friendships two topics ago".
-- Making friends is topic seven and Messaging is topic ten, so it is three
-- back, not two. Named instead of counted — the fourth time in this pass that
-- a counted reference has been wrong and the first time one has been wrong
-- across topics rather than within one.
--
-- Everything else checks out, including the reference in 2.2 to "the
-- point-first rule in Presenting", which is Work's presenting track and says
-- exactly that.

update public.lessons l
  set theory_md = replace(
        l.theory_md,
        'that stalls friendships two topics ago',
        'that stalls friendships in Making friends'
      ),
      rehearsal_spec = replace(
        l.rehearsal_spec::text,
        'that stalls friendships two topics ago',
        'that stalls friendships in Making friends'
      )::jsonb
  from public.skills s
  where l.skill_id = s.id
    and s.slug = 'not-everything-is-a-message'
    and l.sort_order = 4;
