-- What a text rehearsal can and cannot drill.
--
-- Some lessons are about timing, physical reading, or the behaviour of a group.
-- A one-to-one chat window cannot test any of those, and presenting a scene as
-- though it could is worse than admitting the limit: the user practises the
-- wrong thing and the score means nothing.
--
-- Only the lessons that genuinely do not fit get a note. Where this is null,
-- the rehearsal exercises the skill directly and needs no caveat.

alter table public.lessons add column rehearsal_note text;

create or replace function pg_temp.set_note(
  skill_slug text, lesson_order integer, note text
) returns void language sql as $fn$
  update public.lessons l
    set rehearsal_note = note
    from public.skills s
    where l.skill_id = s.id
      and s.slug = skill_slug
      and l.sort_order = lesson_order;
$fn$;

select pg_temp.set_note('openers', 2, $md$This one is about reading whether someone is available before you speak, which a chat window cannot show you. The scene starts with the partner already busy, so what it can test is whether you open lightly and accept a flat answer without pushing. The real drill is the mission.$md$);

select pg_temp.set_note('flirting-calibration', 3, $md$Attention at the moment someone could leave is a physical signal, and there is nothing physical here. What the scene can test is whether you read warm words as weaker evidence than what the partner actually does with the conversation.$md$);

select pg_temp.set_note('reading-disinterest', 1, $md$Two of the three signals are posture and eye contact, which the transcript cannot carry. What is left is the strongest one anyway: whether they ever ask you anything back. Count that here, and practise the rest outside.$md$);

select pg_temp.set_note('groups', 1, $md$Joining a group is a physical problem and this is a conversation with one person, so the entry itself cannot be rehearsed. Treat this scene as the moment after you have joined, and practise being comfortable saying nothing first.$md$);

select pg_temp.set_note('groups', 2, $md$Timing an entry needs a group with its own momentum, which a single partner cannot provide. What you can practise here is contributing something ordinary rather than waiting for something clever.$md$);

select pg_temp.set_note('groups', 4, $md$Holding the floor is measured against other people wanting it, and there are none here. Use the scene to practise ending your turn deliberately: land the point, then hand it on rather than trailing off.$md$);

select pg_temp.set_note('groups', 5, $md$There is nobody quiet to bring in. What transfers is the shape of the question — specific enough that it can definitely be answered, rather than an open one that puts someone on the spot.$md$);

select pg_temp.set_note('exits', 4, $md$Leaving a group of six sideways cannot happen in a two-person conversation. Practise the small-group version instead: one clear line, warmly, and then actually go.$md$);
