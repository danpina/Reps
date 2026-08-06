-- Who may open which lesson.
--
-- The rule the product wants is small: anyone signed in can read the first two
-- lessons of the first skill in every topic, and a subscriber can read all of
-- them. The interesting part is where that rule lives.
--
-- It lives here, in row level security, and not in the pages. A gate written
-- only in the UI is a gate on a hyperlink: the lesson body is still one API
-- call away from anyone with a session, and the whole product being sold is
-- the lesson body. So the database refuses, and the pages merely explain the
-- refusal politely.
--
-- The cost of that choice is that a listing cannot use `lessons` any more — a
-- gated row is invisible, so a free user would see a two-lesson track rather
-- than a five-lesson track with three locks on it. The `lesson_index` view
-- below is the answer: titles are public, bodies are not.

create table public.subscriptions (
  user_id uuid primary key references auth.users (id) on delete cascade,

  status text not null check (
    status in ('active', 'trialing', 'past_due', 'canceled')
  ),

  -- 'manual' is an admin granting access by hand, which is how everyone is
  -- served until billing exists. Stripe writes 'stripe' rows later and nothing
  -- else in the app has to change: entitlement is read from this table either
  -- way.
  source text not null default 'manual' check (source in ('manual', 'stripe')),

  -- Null means it does not expire, which is what a manual grant usually is.
  current_period_end timestamptz,

  -- The Stripe subscription id, once there is one.
  external_id text unique,

  granted_by uuid references auth.users (id) on delete set null,
  note text,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger subscriptions_touch_updated_at
  before update on public.subscriptions
  for each row execute function public.touch_updated_at();

alter table public.subscriptions enable row level security;

create policy "Users read their own subscription"
  on public.subscriptions for select
  to authenticated
  using ((select auth.uid()) = user_id);

create policy "Admins read every subscription"
  on public.subscriptions for select
  to authenticated
  using (public.is_admin());

-- No insert, update or delete policy for anyone. Entitlement is only ever
-- written by code holding the secret key: the admin screens today, the Stripe
-- webhook later. A user who could write this table could grant themselves the
-- product, which is the one write that must never have a route through the
-- API.

/**
 * Whether this user is entitled to the paid product.
 *
 * SECURITY DEFINER because it is asked by a policy on `lessons`, and the
 * asking user has no reason to be able to read `subscriptions` for that policy
 * to work — the same reason `is_admin` is written this way.
 *
 * Admins are entitled implicitly. It saves granting yourself a subscription to
 * look at the thing you are shipping, and an admin can grant themselves one in
 * a second anyway, so refusing would be theatre.
 */
create or replace function public.is_pro(uid uuid default auth.uid())
returns boolean
language sql
security definer
stable
set search_path = ''
as $$
  select
    public.is_admin(uid)
    or exists (
      select 1
      from public.subscriptions s
      where s.user_id = uid
        and s.status in ('active', 'trialing')
        and (s.current_period_end is null or s.current_period_end > now())
    );
$$;

revoke execute on function public.is_pro(uuid) from public;
grant execute on function public.is_pro(uuid) to authenticated;

/**
 * Whether a lesson is inside the free sample.
 *
 * Two lessons of the first skill of every topic. Per topic rather than once
 * across the app, because the topics are sold as different products to
 * different people — someone who arrived for Interviews should be able to
 * taste Interviews, not be handed two lessons of small talk.
 *
 * Two is also a deliberate number: one lesson shows the format, and the second
 * is where the topic stops being obvious. Both together are about fifteen
 * minutes, which is enough to know whether the writing is any good.
 */
create or replace function public.is_preview_lesson(
  p_skill_id uuid,
  p_sort_order integer
)
returns boolean
language sql
security definer
stable
set search_path = ''
as $$
  select
    p_sort_order <= 2
    and exists (
      select 1
      from public.skills s
      where s.id = p_skill_id
        and s.sort_order = 1
    );
$$;

revoke execute on function public.is_preview_lesson(uuid, integer) from public;
grant execute on function public.is_preview_lesson(uuid, integer) to authenticated;

drop policy "Signed-in users read lessons" on public.lessons;

create policy "Users read lessons they are entitled to"
  on public.lessons for select
  to authenticated
  using (
    public.is_pro()
    or public.is_preview_lesson(skill_id, sort_order)
  );

/**
 * The table of contents: which lessons exist, and which ones are open.
 *
 * Deliberately NOT security_invoker, so it reads past the policy above. That
 * is the whole point — a lock has to be visible to work as a lock, and a title
 * is an advertisement rather than the goods. Every column that carries actual
 * teaching (theory, examples, checks, rubric, scenario, mission) is left out,
 * so this cannot leak the thing being sold.
 */
create view public.lesson_index
with (security_invoker = false) as
  select
    l.id,
    l.skill_id,
    l.sort_order,
    l.title,
    public.is_preview_lesson(l.skill_id, l.sort_order) as is_preview
  from public.lessons l;

revoke all on public.lesson_index from public, anon;
grant select on public.lesson_index to authenticated;

/**
 * Whether this user may start another rehearsal.
 *
 * The rehearsal is the only feature in the app that costs money per use, so it
 * is also the only one a free account gets a fixed number of rather than a
 * daily allowance. One is enough to feel what it is: an AI partner who stays
 * in character and does not go easy on you. It is not enough to practise with,
 * which is the point.
 *
 * SECURITY DEFINER for a second reason here. The count is of `roleplays`, and
 * a policy on `roleplays` that queried `roleplays` directly would recurse
 * through its own policies forever. Reading it inside a definer function is
 * what breaks that loop.
 */
create or replace function public.rehearsal_allowed(uid uuid default auth.uid())
returns boolean
language sql
security definer
stable
set search_path = ''
as $$
  select
    public.is_pro(uid)
    or (select count(*) from public.roleplays r where r.user_id = uid) < 1;
$$;

revoke execute on function public.rehearsal_allowed(uuid) from public;
grant execute on function public.rehearsal_allowed(uuid) to authenticated;

drop policy "Users start their own roleplays" on public.roleplays;

create policy "Users start rehearsals they are entitled to"
  on public.roleplays for insert
  to authenticated
  with check (
    (select auth.uid()) = user_id
    and public.rehearsal_allowed()
  );
