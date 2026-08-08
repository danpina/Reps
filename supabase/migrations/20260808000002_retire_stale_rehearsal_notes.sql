-- Notes that apologised for a limit that no longer exists.
--
-- `rehearsal_note` was written when every lesson got the same chat window, and
-- eight lessons carried one because that window genuinely could not test them.
-- The four below have since been given a mode that can, and the note now sits
-- directly above a drill that does the thing it says is impossible:
--
--   "which a chat window cannot show you"     over a read-and-decide drill
--                                             whose whole subject is what you
--                                             can see before you speak
--
--   "posture and eye contact, which the       over situations that describe
--    transcript cannot carry"                 posture and eye contact
--
--   "there is nothing physical here"          over a beat about what somebody
--                                             does with their coat
--
--   "there is nobody quiet to bring in"       over a drill whose beat exists
--                                             to have somebody quiet in it
--
-- A caveat that is no longer true is worse than no caveat: it tells a learner
-- the exercise in front of them is not worth taking seriously.
--
-- The four left alone are still honest. Joining a group is a physical problem,
-- timing an entry needs a group with momentum, holding the floor is measured
-- against people who want it, and leaving six people sideways cannot happen
-- with one partner. Those modes narrowed what is being asked; they did not
-- conjure a group.

create or replace function pg_temp.clear_note(
  p_skill text, p_order integer
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_note = null
    from public.skills s
    where l.skill_id = s.id
      and s.slug = p_skill
      and l.sort_order = p_order;
$fn$;

select pg_temp.clear_note('openers', 2);
select pg_temp.clear_note('reading-disinterest', 1);
select pg_temp.clear_note('flirting-calibration', 3);
select pg_temp.clear_note('groups', 5);
