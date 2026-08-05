-- Two comprehension beats per lesson instead of one.
--
-- The seed migrations still write a single check_json, because rewriting 45
-- blocks across nine historical files would be a lot of churn for no gain.
-- This migration lifts that into an array, and the next one appends the second
-- question to every lesson. A fresh install runs them in order and ends up in
-- the same place as an existing database.

alter table public.lessons
  add column checks_json jsonb not null default '[]'::jsonb;

update public.lessons
  set checks_json = jsonb_build_array(check_json)
  where check_json is not null;

alter table public.lessons
  add constraint checks_is_array check (jsonb_typeof(checks_json) = 'array');
