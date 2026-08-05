-- Roleplay transcripts and the rate limit ledger.

create table public.roleplays (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  session_id uuid references public.sessions (id) on delete set null,
  lesson_id uuid not null references public.lessons (id),

  -- [{ role: 'user' | 'partner', content, at }]
  transcript_json jsonb not null default '[]'::jsonb,

  -- Written once the scene is ended and scored. Null while in progress.
  feedback_json jsonb,
  -- { criterion_key: 1..5 }
  scores_json jsonb,

  status text not null default 'open' check (status in ('open', 'complete')),
  started_at timestamptz not null default now(),
  completed_at timestamptz,

  constraint transcript_is_array check (jsonb_typeof(transcript_json) = 'array')
);

create index roleplays_user_started_idx
  on public.roleplays (user_id, started_at desc);

create index roleplays_user_lesson_idx
  on public.roleplays (user_id, lesson_id);

-- Every call that will eventually cost money gets a row. Rate limits are
-- counted from here rather than held in memory, because a serverless host
-- gives no memory worth relying on.
create table public.ai_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  kind text not null check (kind in ('partner_turn', 'feedback')),
  created_at timestamptz not null default now()
);

create index ai_requests_user_kind_created_idx
  on public.ai_requests (user_id, kind, created_at desc);

alter table public.roleplays enable row level security;
alter table public.ai_requests enable row level security;

create policy "Users read their own roleplays"
  on public.roleplays for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "Users start their own roleplays"
  on public.roleplays for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "Users update their own roleplays"
  on public.roleplays for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "Users delete their own roleplays"
  on public.roleplays for delete to authenticated
  using ((select auth.uid()) = user_id);

create policy "Users read their own ai requests"
  on public.ai_requests for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "Users record their own ai requests"
  on public.ai_requests for insert to authenticated
  with check ((select auth.uid()) = user_id);
