-- Which columns of their own profile a user may write.
--
-- Row level security answers "whose row is this", and the owner policy
-- correctly says yes to your own. It has nothing to say about *which columns*,
-- so blocked_at — a column about you, on a row that is yours — was editable by
-- the person it exists to restrain. A blocked user could clear their own block
-- with a single PATCH.
--
-- Column privileges are the tool for that question, so the fix is a grant and
-- not a policy. The four below are exactly what the settings screen and
-- onboarding write; everything else on the row becomes read-only to its owner.
--
-- Blocking still works because every admin write goes through the secret key,
-- which bypasses grants and policies alike. That asymmetry is the design: the
-- only writer of blocked_at is code that has already proved it is an admin.

revoke update on public.profiles from authenticated;

grant update (display_name, timezone, onboarding_context, theme)
  on public.profiles to authenticated;
