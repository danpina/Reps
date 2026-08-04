-- Badges and the weekly review rewrite.

-- The weekly review surfaces the user's own worst-rated rep and asks what they
-- would say instead. The answer belongs to the rep, so it lives here.
alter table public.field_logs
  add column rewrite text,
  add column rewrite_at timestamptz;

create table public.badges (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name text not null,
  description text not null,
  -- { type, ... }. Evaluated in TypeScript, see src/lib/progress/badges.ts.
  criteria_json jsonb not null,
  sort_order integer not null unique
);

create table public.user_badges (
  user_id uuid not null references auth.users (id) on delete cascade,
  badge_id uuid not null references public.badges (id) on delete cascade,
  earned_at timestamptz not null default now(),
  primary key (user_id, badge_id)
);

alter table public.badges enable row level security;
alter table public.user_badges enable row level security;

-- Seed content: readable by any signed-in user, writable only by a migration.
create policy "Signed-in users read badges"
  on public.badges for select to authenticated using (true);

create policy "Users read their own badges"
  on public.user_badges for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "Users earn their own badges"
  on public.user_badges for insert to authenticated
  with check ((select auth.uid()) = user_id);

-- Milestones only. The brief rules out anything comparative: no leaderboards,
-- no ranking against other users, nothing that turns a private practice log
-- into a competition.
insert into public.badges (slug, name, description, criteria_json, sort_order)
values
  (
    'first-rep',
    'First rep',
    $$You logged a real conversation. This is the part that counts.$$,
    $j${"type": "reps_total", "n": 1}$j$::jsonb,
    1
  ),
  (
    'logged-a-bad-one',
    'Logged a bad one',
    $$You recorded a rep that did not go well. The log is only worth something if it is honest.$$,
    $j${"type": "logged_a_failure"}$j$::jsonb,
    2
  ),
  (
    'ten-reps',
    'Ten in the wild',
    $$Ten real conversations logged.$$,
    $j${"type": "reps_total", "n": 10}$j$::jsonb,
    3
  ),
  (
    'seven-day-streak',
    'Seven days',
    $$A week of turning up. Rest days count.$$,
    $j${"type": "streak", "n": 7}$j$::jsonb,
    4
  ),
  (
    'ten-labels',
    'Ten labels in the wild',
    $$Ten logged reps on listening and labeling.$$,
    $j${"type": "skill_reps", "slug": "listening-and-labeling", "n": 10}$j$::jsonb,
    5
  ),
  (
    'first-flirting-mission',
    'First flirting mission',
    $$You practised the hardest one on purpose.$$,
    $j${"type": "skill_reps", "slug": "flirting-calibration", "n": 1}$j$::jsonb,
    6
  ),
  (
    'read-the-room',
    'Read the room',
    $$A logged rep on noticing interest was not mutual, and leaving warmly.$$,
    $j${"type": "skill_reps", "slug": "reading-disinterest", "n": 1}$j$::jsonb,
    7
  ),
  (
    'second-draft',
    'Second draft',
    $$You went back to a rep that went badly and worked out what you would say instead.$$,
    $j${"type": "rewrites", "n": 1}$j$::jsonb,
    8
  ),
  (
    'all-nine',
    'Every skill touched',
    $$At least one logged rep in all nine tracks.$$,
    $j${"type": "distinct_skills", "n": 9}$j$::jsonb,
    9
  ),
  (
    'fifty-reps',
    'Fifty reps',
    $$Fifty real conversations. Scroll back through the log and read the first one.$$,
    $j${"type": "reps_total", "n": 50}$j$::jsonb,
    10
  );
