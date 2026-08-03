-- Curriculum: skills and lessons. Seed content, readable by any signed-in
-- user and writable by nobody through the API.

create table public.skills (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name text not null,
  description text not null,
  core_idea text not null,
  sort_order integer not null unique,
  created_at timestamptz not null default now()
);

create table public.lessons (
  id uuid primary key default gen_random_uuid(),
  skill_id uuid not null references public.skills (id) on delete cascade,
  sort_order integer not null,
  title text not null,

  -- The one idea and its framework. Kept short on purpose.
  theory_md text not null,

  -- [{ situation, line, why }] — the three worked examples.
  examples_json jsonb not null default '[]'::jsonb,

  -- { prompt, options: [{ text, correct, note }], explain } — the
  -- comprehension beat that closes the card.
  check_json jsonb,

  -- { scale: { min, max }, criteria: [{ key, label, description }] }
  -- Handed to the feedback engine alongside the transcript.
  rubric_json jsonb not null,

  -- { setting, partner: { name, role, personality, mood, openness },
  --   opening_beat, success_looks_like, constraints: [] }
  -- Assembled into the roleplay system prompt. openness is 1..5.
  scenario_json jsonb not null,

  mission_text text not null,
  created_at timestamptz not null default now(),

  unique (skill_id, sort_order),

  constraint examples_is_array check (jsonb_typeof(examples_json) = 'array'),
  constraint rubric_has_criteria check (
    jsonb_typeof(rubric_json -> 'criteria') = 'array'
  ),
  constraint openness_in_range check (
    (scenario_json -> 'partner' ->> 'openness')::integer between 1 and 5
  )
);

create index lessons_skill_id_sort_order_idx
  on public.lessons (skill_id, sort_order);

alter table public.skills enable row level security;
alter table public.lessons enable row level security;

-- Read-only to signed-in users. No insert, update or delete policy exists,
-- so the curriculum can only change through a migration.
create policy "Signed-in users read skills"
  on public.skills for select
  to authenticated
  using (true);

create policy "Signed-in users read lessons"
  on public.lessons for select
  to authenticated
  using (true);
