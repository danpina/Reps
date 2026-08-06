-- Topics: the layer above skills.
--
-- The nine original skills were all written for one situation — talking to a
-- stranger in an ordinary room — and calling that "the curriculum" made them
-- read as universal advice when they are not. An opener at a bar and an opener
-- in a job interview are different crafts with different failure modes.
--
-- So skills now belong to a topic, and a topic is the situation. Nothing about
-- a lesson changes: the same theory card, worked examples, checks, rubric,
-- scenario and mission. What changes is that "Openers" is now openers *in
-- small talk*, and the interview version is allowed to disagree with it.

create table public.topics (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name text not null,
  description text not null,

  -- What you can do once you have worked through it. Written as a claim the
  -- content has to earn, because it is the line someone reads before deciding
  -- to pay.
  promise text not null,

  sort_order integer not null unique,
  created_at timestamptz not null default now()
);

alter table public.topics enable row level security;

-- Same rule as skills and lessons: seed content, readable by anyone signed in,
-- writable only through a migration.
create policy "Signed-in users read topics"
  on public.topics for select
  to authenticated
  using (true);

insert into public.topics (slug, name, description, promise, sort_order)
values
  (
    'small-talk',
    'Small talk',
    $$Starting, holding and ending a conversation with someone you barely know.$$,
    $$Walk into a room where you know nobody, and leave having had three conversations you did not dread.$$,
    1
  ),
  (
    'interviews',
    'Interviews',
    $$Being interviewed: your story, the evidence behind it, the questions you ask back, and the number at the end.$$,
    $$Answer the handful of questions that decide most interviews without freezing, waffling, or quietly underselling work you actually did.$$,
    2
  ),
  (
    'work',
    'Work',
    $$Your boss, your meetings, your presentations, and the corridor at a conference.$$,
    $$Say the thing in the meeting, ask for what you are owed, and present without reading your slides out loud.$$,
    3
  ),
  (
    'dating',
    'Dating',
    $$Reading interest accurately, showing your own a notch at a time, and handling every answer well.$$,
    $$Tell the difference between polite and interested, escalate only when it is matched, and leave warmly when the answer is no.$$,
    4
  ),
  (
    'making-friends',
    'Making friends',
    $$Turning people you have met into people you know. The part that comes after small talk.$$,
    $$Turn an acquaintance into a friend on purpose, instead of waiting years for it to happen by accident.$$,
    5
  ),
  (
    'hard-conversations',
    'Hard conversations',
    $$Saying no, raising a problem, apologising, and staying in the room while it is uncomfortable.$$,
    $$Have the conversation you have been putting off for months, without either swallowing it or blowing it up.$$,
    6
  ),
  (
    'storytelling',
    'Storytelling & speaking',
    $$Holding a room: a story that lands, a laugh you meant to get, a toast you were not expecting to give.$$,
    $$Tell the story you always tell badly, well — and be able to stand up with no warning and be worth listening to.$$,
    7
  );

alter table public.skills
  add column topic_id uuid references public.topics (id) on delete restrict;

-- sort_order was globally unique, which only worked while there was one list.
-- It is now a position within a topic, so every topic starts again at 1.
alter table public.skills drop constraint skills_sort_order_key;

-- Seven of the nine existing tracks are small talk, which is what they were
-- written for. The two that are not go to Dating, and reading disinterest goes
-- first: someone who can tell when interest is not mutual is both more
-- effective and much less likely to make anyone uncomfortable, so it is the
-- foundation of that topic rather than a disclaimer bolted on at the end.
--
-- The ids do not change, so every field log, XP row and roleplay that points
-- at these skills keeps pointing at them.
update public.skills s
set topic_id = t.id, sort_order = m.pos
from public.topics t
join (values
  ('openers',              'small-talk', 1),
  ('going-deeper',         'small-talk', 2),
  ('listening-and-labeling', 'small-talk', 3),
  ('reciprocity',          'small-talk', 4),
  ('banter',               'small-talk', 5),
  ('groups',               'small-talk', 6),
  ('exits',                'small-talk', 7),
  ('reading-disinterest',  'dating',     1),
  ('flirting-calibration', 'dating',     2)
) as m (skill_slug, topic_slug, pos) on m.topic_slug = t.slug
where s.slug = m.skill_slug;

alter table public.skills alter column topic_id set not null;

alter table public.skills
  add constraint skills_topic_position_unique unique (topic_id, sort_order);

-- Onboarding used to ask which of four situations you cared about, from an
-- enum, and that enum is now a table with seven rows in it that will grow. So
-- the answer becomes a foreign key, and "have you been through onboarding"
-- stops being inferred from having answered — a question can be skipped, and
-- an app that reads a skipped question as an unfinished signup loops forever.

alter table public.profiles
  add column onboarded_at timestamptz,
  add column starting_topic_id uuid references public.topics (id) on delete set null;

update public.profiles
  set onboarded_at = created_at
  where onboarding_context is not null;

-- The old four answers, mapped onto the topics they were asking about. 'work'
-- pointed at the small talk track because that was the only content there was;
-- now that Work exists, someone who said work meant work.
update public.profiles p
set starting_topic_id = t.id
from public.topics t
where p.onboarding_context is not null
  and t.slug = case p.onboarding_context
    when 'work' then 'work'
    when 'casual' then 'small-talk'
    when 'flirting' then 'dating'
    when 'all' then 'small-talk'
  end;

alter table public.profiles drop column onboarding_context;
drop type public.onboarding_context;

-- Dropping the column dropped it from the column-level update grant with it,
-- so the two that replaced it need naming. Everything not listed across this
-- and the earlier grant stays read-only to the row's owner, which is what
-- keeps a blocked user from clearing their own block.
grant update (onboarded_at, starting_topic_id) on public.profiles to authenticated;
