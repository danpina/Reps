-- Proofreading pass, topic 4 of 11: Meeting someone.
--
-- Thirty-one lessons read. One defect, and it is a coherence one rather than a
-- language one: a lesson that misreports another topic's rule and then claims
-- to break a rule it actually follows.
--
-- Small talk's banter track says "Teasing the person comes after it, never
-- instead of it" — person-teasing is allowed, once a shared laugh has
-- established the licence. This lesson reported that as "tease the situation,
-- never the person" and announced it was going to break it on purpose. Then
-- its own move is "tease something they chose, once they have teased you",
-- which is the same rule being applied rather than broken.
--
-- So the opening is corrected to state the rule accurately and to say what
-- genuinely changes here, which is the weight the tease carries rather than
-- whether it is permitted.
--
-- Noted and deliberately not changed: three lessons refer to a sibling lesson
-- by number ("in lesson two"). It is fragile — The first date was renumbered
-- once already — but all three are within their own track and currently
-- correct, and rewriting them is not proofreading.

update public.lessons l
  set theory_md = replace(
    l.theory_md,
    'Small talk gave you a rule: tease the situation, never the person. That rule is correct for strangers, and here you are going to break it on purpose.',
    'Small talk gave you a rule: tease the situation first, and the person only once there is licence. That rule holds here too. What changes is that the tease stops being a bonus and becomes the move.'
  )
  from public.skills s
  where l.skill_id = s.id and s.slug = 'flirting-moves' and l.sort_order = 2;
