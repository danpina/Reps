-- Let a user write their own language.
--
-- Migration 98 added profiles.locale and a settings form to change it, and
-- forgot the grant. Row level security was never the problem: the owner policy
-- says yes to your own row. Column privileges are a separate question, and
-- this table revokes update wholesale and then grants it column by column, so
-- that a blocked user cannot clear their own blocked_at.
--
-- A column added without a grant is therefore read-only to its owner, and the
-- failure says so in the least helpful way available: PostgREST returns 42501
-- permission denied for the whole table, which reads like an RLS problem and
-- is not one. The settings screen turned that into "That did not save. Try
-- again." and the real cause never reached anybody.
--
-- Every earlier migration that added a user-writable column remembered this —
-- onboarded_at, starting_topic_id, sex, age_group, dating_interest all have
-- their grant. This one restores the pattern, and the test added alongside it
-- fails if a future column forgets again.

grant update (locale) on public.profiles to authenticated;
