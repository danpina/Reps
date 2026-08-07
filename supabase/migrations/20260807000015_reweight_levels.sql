-- Slower levels, and the stored column brought into line with them.
--
-- The level thresholds widened, which matters here because user_skill_state
-- keeps a level column written at the moment XP is awarded. Nothing recomputes
-- it on read: two screens ask the database what level someone is, and one of
-- them decides whether a rehearsal is unlocked.
--
-- So without this, everybody keeps the level the old ladder gave them until
-- the next time they happen to earn XP in that skill — and a stale level that
-- is too high is not cosmetic, it opens a scenario the new pacing says has not
-- been reached.
--
-- Kept in step with LEVEL_THRESHOLDS in src/lib/progress/rules.ts. Two copies
-- of a ladder is one more than anybody wants, and the alternative is a
-- database function that has to be migrated every time the numbers move.

update public.user_skill_state
set level = case
  when xp >= 8000 then 10
  when xp >= 6000 then 9
  when xp >= 4500 then 8
  when xp >= 3200 then 7
  when xp >= 2200 then 6
  when xp >= 1400 then 5
  when xp >= 800 then 4
  when xp >= 400 then 3
  when xp >= 150 then 2
  else 1
end;
