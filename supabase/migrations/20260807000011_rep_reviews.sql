-- A read of the whole log, rather than of one conversation.
--
-- The rehearsal feedback engine reviews a single scene. This reviews the field
-- log: ten or more real conversations, looking for the thing that keeps
-- happening. That is a different question and it can only be asked once there
-- is enough evidence to answer it — three reps do not have a pattern in them,
-- they have three anecdotes.
--
-- The important column here is covers_through. Every review records the point
-- in the log it read up to, so the next one starts from there rather than from
-- the beginning. Re-reading forty reps to comment on the four that are new
-- would cost more every single time it ran, and would mostly produce the same
-- observations worded differently.

create table public.rep_reviews (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,

  -- { headline, patterns: [{ title, detail, evidence }], working, one_thing,
  --   next_rep }
  review_json jsonb not null,

  -- The watermark. Every rep logged at or before this instant has been read,
  -- and the next review will only look at what came after it.
  covers_through timestamptz not null,

  -- How many reps this review itself read, and how many the log held in total
  -- at the time. The second is what lets the page say "across 34 reps" without
  -- implying all 34 were re-read.
  reps_read integer not null check (reps_read > 0),
  reps_total integer not null check (reps_total > 0),

  -- What this review was building on. Kept as a link rather than by copying
  -- the text, so a chain of reviews can be walked backwards.
  previous_review_id uuid references public.rep_reviews (id) on delete set null,

  created_at timestamptz not null default now()
);

create index rep_reviews_user_created_idx
  on public.rep_reviews (user_id, created_at desc);

alter table public.rep_reviews enable row level security;

create policy "Users read their own reviews"
  on public.rep_reviews for select
  to authenticated
  using ((select auth.uid()) = user_id);

-- Subscribers only, checked here rather than only in the action. This is the
-- most expensive single call the app makes — it reads a stack of reps and
-- thinks hard about them — so the gate belongs where a hand-written request
-- cannot get around it.
create policy "Subscribers write their own reviews"
  on public.rep_reviews for insert
  to authenticated
  with check ((select auth.uid()) = user_id and public.is_pro());

create policy "Users delete their own reviews"
  on public.rep_reviews for delete
  to authenticated
  using ((select auth.uid()) = user_id);

-- No update policy. A review is a record of what was said about the log at a
-- moment in time, and the next one supersedes it rather than editing it.

-- The ledger the rate limits are counted from needs to know about this kind of
-- call, since it is billed like every other one.
alter table public.ai_requests
  drop constraint ai_requests_kind_check;

alter table public.ai_requests
  add constraint ai_requests_kind_check
  check (
    kind in ('partner_turn', 'feedback', 'refused_turn', 'rep_review')
  );
