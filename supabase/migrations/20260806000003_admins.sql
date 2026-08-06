-- Admins, and the flag that keeps someone out.

create table public.admins (
  user_id uuid primary key references auth.users (id) on delete cascade,
  granted_at timestamptz not null default now(),
  granted_by uuid references auth.users (id) on delete set null
);

alter table public.admins enable row level security;

-- Asked by policies on other tables, so it must not depend on the asking user
-- being able to read this one. SECURITY DEFINER does that.
--
-- It reads admins and nothing else on purpose: a policy on profiles can call
-- it without recursing back through the policies on profiles, which is the
-- trap a role column on that table would have set.
create or replace function public.is_admin(uid uuid default auth.uid())
returns boolean
language sql
security definer
stable
set search_path = ''
as $$
  select exists (select 1 from public.admins a where a.user_id = uid);
$$;

revoke execute on function public.is_admin(uuid) from public;
grant execute on function public.is_admin(uuid) to authenticated;

-- Admins can see who else is an admin. Nobody grants or revokes through the
-- API: membership is changed in SQL, deliberately, so that the one privilege
-- that could grant itself more privilege never has a route through the app.
create policy "Admins read the roster"
  on public.admins for select
  to authenticated
  using (public.is_admin());

-- Blocking. Recorded here rather than only in auth.users because the admin
-- list wants to show it, and because a reason is worth keeping.
--
-- This flag is not the enforcement. Enforcement is two other things: the auth
-- user is banned, so no new session can be issued, and the data layer checks
-- this column on every request, so a session already in flight stops working
-- immediately rather than at token expiry.
alter table public.profiles
  add column blocked_at timestamptz,
  add column blocked_reason text;

create policy "Admins read every profile"
  on public.profiles for select
  to authenticated
  using (public.is_admin());

create policy "Admins update any profile"
  on public.profiles for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());
