-- Field logs and progress. Every table here is user-owned and gated by
-- auth.uid() on all four verbs.

-- The real reps. This is the table the app exists for.
create table public.field_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  skill_id uuid not null references public.skills (id),

  -- Null when the rep was logged freely rather than against an assigned
  -- lesson mission.
  lesson_id uuid references public.lessons (id),
  mission_text text,

  -- The user's own words for who and where. Never required, and never
  -- structured, so nobody has to record personal data to log a rep.
  context_note text,

  -- 1 poorly, 2 mixed, 3 well. A logged failure is worth the same XP as a
  -- success, which is why this does not feed the XP calculation.
  went smallint not null check (went between 1 and 3),
  reflection text,

  xp_awarded integer not null default 0 check (xp_awarded >= 0),
  logged_at timestamptz not null default now()
);

-- The field log reads newest first, and the weekly review filters by date.
create index field_logs_user_logged_at_idx
  on public.field_logs (user_id, logged_at desc);

create index field_logs_user_skill_idx
  on public.field_logs (user_id, skill_id);

-- Per-skill level and XP.
create table public.user_skill_state (
  user_id uuid not null references auth.users (id) on delete cascade,
  skill_id uuid not null references public.skills (id),
  level smallint not null default 1 check (level between 1 and 10),
  xp integer not null default 0 check (xp >= 0),
  current_lesson_id uuid references public.lessons (id),
  updated_at timestamptz not null default now(),
  primary key (user_id, skill_id)
);

-- One row per user. Rest days are the safety valve the brief asks for: two a
-- week, taken automatically, so a single missed day cannot end a streak.
create table public.streaks (
  user_id uuid primary key references auth.users (id) on delete cascade,
  current integer not null default 0 check (current >= 0),
  longest integer not null default 0 check (longest >= 0),
  last_active_date date,
  rest_days_used_this_week smallint not null default 0
    check (rest_days_used_this_week between 0 and 2),
  -- Monday of the week the rest-day count applies to.
  week_start_date date,
  updated_at timestamptz not null default now()
);

-- Completed activities. Theory reads award XP once; the unique index below is
-- what stops re-reading a card from paying out again.
create table public.sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  lesson_id uuid references public.lessons (id),
  kind text not null check (kind in ('theory', 'roleplay', 'mission')),
  started_at timestamptz not null default now(),
  completed_at timestamptz,
  xp_awarded integer not null default 0 check (xp_awarded >= 0)
);

create unique index sessions_one_theory_award_per_lesson
  on public.sessions (user_id, lesson_id)
  where kind = 'theory';

create index sessions_user_kind_idx on public.sessions (user_id, kind);

alter table public.field_logs enable row level security;
alter table public.user_skill_state enable row level security;
alter table public.streaks enable row level security;
alter table public.sessions enable row level security;

-- auth.uid() is wrapped in a subselect so Postgres evaluates it once per
-- query rather than once per row.

create policy "Users read their own field logs"
  on public.field_logs for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "Users write their own field logs"
  on public.field_logs for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "Users edit their own field logs"
  on public.field_logs for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "Users delete their own field logs"
  on public.field_logs for delete to authenticated
  using ((select auth.uid()) = user_id);

create policy "Users read their own skill state"
  on public.user_skill_state for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "Users write their own skill state"
  on public.user_skill_state for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "Users edit their own skill state"
  on public.user_skill_state for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "Users read their own streak"
  on public.streaks for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "Users write their own streak"
  on public.streaks for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "Users edit their own streak"
  on public.streaks for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "Users read their own sessions"
  on public.sessions for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "Users write their own sessions"
  on public.sessions for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "Users edit their own sessions"
  on public.sessions for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
