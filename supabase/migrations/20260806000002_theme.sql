-- A chosen theme, stored per user rather than per device.
--
-- 'system' is the default and means "whatever the device is doing", which is
-- what the stylesheet already falls back to when no data-theme attribute is
-- present. Storing the choice server-side is what lets the attribute be
-- rendered in the initial HTML: a theme read on the client always paints the
-- wrong palette first, and on this app that flash lands on every page load.

create type public.theme_choice as enum ('system', 'light', 'dark');

alter table public.profiles
  add column theme public.theme_choice not null default 'system';
