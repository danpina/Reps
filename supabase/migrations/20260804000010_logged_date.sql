-- Day bucketing must not depend on where the server happens to run.
--
-- The heatmap, the field log's day headings and the weekly review all group by
-- calendar day. They were deriving that day from logged_at in the server's own
-- timezone, so the same rep fell on different days on a developer machine and
-- on a UTC host. A rep logged at midnight local time is a rep the user had
-- today, wherever the code is executing.
--
-- logged_date records the user's own local day, taken from the same clamped
-- client date the streak already uses.

alter table public.field_logs add column logged_date date;

-- Backfill from UTC. Existing rows may be off by a day near midnight; they are
-- development data, and every row written from now on carries the real value.
update public.field_logs
  set logged_date = (logged_at at time zone 'UTC')::date
  where logged_date is null;

alter table public.field_logs alter column logged_date set not null;

create index field_logs_user_logged_date_idx
  on public.field_logs (user_id, logged_date desc);

-- profiles.timezone has existed since the first migration and was never
-- populated. It is what lets the server work out what "today" means for this
-- user when rendering day labels and the current week.
comment on column public.profiles.timezone is
  'IANA timezone from the browser, captured when a rep is logged.';
