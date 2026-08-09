-- Who is actually in the room.
--
-- Every Dating lesson has been rehearsed against the same person regardless of
-- who the reader dates. Four of the ten already declared a partner_sex on their
-- variants and nothing read it; the other six never asked the question at all.
-- So a man who dates men has been practising flirting on Wren.
--
-- That is not a slightly imperfect version of the exercise. It is a different
-- one, and it is the difference between a rehearsal and a demonstration.
--
-- Each scene gains a partner of the other sex — a whole character rather than a
-- name swap, because the pronouns live in the personality and the mood as well,
-- and a half-swapped person reads worse than an unswapped one. Selection is in
-- lib/curriculum/variants: a reader who has not said who they date gets the
-- scene exactly as written, because inferring it from their own sex would be
-- assuming they are straight, and being wrong about that here is worse than the
-- scene staying generic.
--
-- Names are kept where they already work for either — Wren, Sasha, Alex, Juno —
-- so the alternate is the same person rather than a substitute.

create or replace function pg_temp.set_partner(
  p_skill text, p_order integer, p_sex text, p_alt jsonb
) returns void language sql as $fn$
  update public.lessons l
    set scenario_json = jsonb_set(
      jsonb_set(scenario_json, '{partner,sex}', to_jsonb(p_sex)),
      '{partner,alt}',
      p_alt
    )
    from public.skills s
    where l.skill_id = s.id
      and s.slug = p_skill
      and l.sort_order = p_order;
$fn$;

-- Flirting: calibration -----------------------------------------------------

select pg_temp.set_partner('flirting-calibration', 1, 'female', $j${
  "name": "Wren",
  "role": "a friend of the birthday person, who you have just met",
  "personality": "Warm and engaged, and mirrors the register he is given rather than setting it. Responds well to small steps and stiffens at large ones.",
  "mood": "Enjoying the evening, genuinely interested in the conversation.",
  "openness": 4,
  "sex": "male"
}$j$::jsonb);

select pg_temp.set_partner('flirting-calibration', 2, 'female', $j${
  "name": "Tam",
  "role": "someone who came to the same event alone",
  "personality": "Friendly and fairly hard to read. Gives warm answers to almost anything, which is the problem the lesson is about.",
  "mood": "Enjoying the discussion, entirely unromantic about it.",
  "openness": 4,
  "sex": "male"
}$j$::jsonb);

select pg_temp.set_partner('flirting-calibration', 3, 'female', $j${
  "name": "Juno",
  "role": "someone who knows a lot of people at this opening",
  "personality": "Sociable and generous with his attention, which makes his attention weak evidence. What he does with a chance to leave is the signal.",
  "mood": "Sociable and being pulled in several directions.",
  "openness": 4,
  "sex": "male"
}$j$::jsonb);

select pg_temp.set_partner('flirting-calibration', 4, 'female', $j${
  "name": "Sasha",
  "role": "a regular at this game night",
  "personality": "Comfortable and unhurried. Will happily let a silence sit, which is exactly what makes him a useful partner for this one.",
  "mood": "Comfortable and in no rush.",
  "openness": 4,
  "sex": "male"
}$j$::jsonb);

select pg_temp.set_partner('flirting-calibration', 5, 'female', $j${
  "name": "Kit",
  "role": "a friend of your host, who you met this evening",
  "personality": "Warm and direct, and has been steadily warmer all evening. Would receive a plain thing plainly.",
  "mood": "Genuinely enjoying himself, aware the evening is ending.",
  "openness": 5,
  "sex": "male"
}$j$::jsonb);

-- Reading disinterest & backing off -----------------------------------------

select pg_temp.set_partner('reading-disinterest', 1, 'male', $j${
  "name": "Bree",
  "role": "another attendee",
  "personality": "Polite throughout and never once asks anything back. Does not warm up at any point, however well the other person does.",
  "mood": "Waiting for a colleague, keeping an eye on the door.",
  "openness": 1,
  "sex": "female"
}$j$::jsonb);

select pg_temp.set_partner('reading-disinterest', 2, 'female', $j${
  "name": "Odhran",
  "role": "another guest, seated beside you",
  "personality": "Perfectly pleasant and matching nothing. Warmth offered to him comes back at the same level it started.",
  "mood": "Enjoying the wedding, glad of the company at the table.",
  "openness": 3,
  "sex": "male"
}$j$::jsonb);

select pg_temp.set_partner('reading-disinterest', 3, 'female', $j${
  "name": "Piotr",
  "role": "someone you started talking to near the bar",
  "personality": "Distracted and courteous. Answers, but is watching the room over your shoulder the whole time.",
  "mood": "Distracted, waiting for someone.",
  "openness": 2,
  "sex": "male"
}$j$::jsonb);

select pg_temp.set_partner('reading-disinterest', 4, 'female', $j${
  "name": "Milo",
  "role": "someone you have spoken to a few times at this gym",
  "personality": "Friendly and entirely unromantic about it. Will keep being friendly whatever happens, which is what makes this one hard to read.",
  "mood": "Warm, mid-session, entirely comfortable.",
  "openness": 3,
  "sex": "male"
}$j$::jsonb);

select pg_temp.set_partner('reading-disinterest', 5, 'female', $j${
  "name": "Alex",
  "role": "someone who joined the same team tonight",
  "personality": "On good form and hard to read, because he is like this with everybody in the room and always has been.",
  "mood": "Having a great time, on good form.",
  "openness": 4,
  "sex": "male"
}$j$::jsonb);
