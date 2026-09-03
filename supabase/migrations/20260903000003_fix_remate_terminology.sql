-- "Remate" ("the finishing blow" — football, auctions) for "the landing" read
-- as borrowed sports jargon inside a job interview. Replaced with
-- "aterrizaje"/"aterrizar", which keeps the English's own image (an answer
-- that sticks the landing) and takes it naturally as a verb. See the
-- rewritten design note at the top of 20260808000109_translate_es_interviews_1.sql.
--
-- Applied here as text substitution across every column of the five
-- interview-your-story lessons, since that migration already ran. Order does
-- not matter between these pairs — none of the inflected forms is a
-- substring of another (confirmed against this specific vocabulary), and the
-- plural "remates" is handled for free since "remate" is its own prefix.
-- The one place "remate" was used twice in the same sentence — once as a
-- noun, once as the subjunctive verb ("lo que hace que un remate remate") —
-- is corrected separately (as its own, longer substitution) since a blind
-- word-for-word pass would have turned the verb into a second noun.
--
-- The replace() chain is generated, not hand-nested — fifteen nested calls
-- is exactly the kind of thing that's easy to miscount by one paren, which a
-- first draft of this migration did.

create or replace function pg_temp.fix_remate(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(input, 'lo que hace que un remate remate', 'lo que hace que un aterrizaje aterrice'), 'Remátalo', 'Aterrízalo'), 'remátalo', 'aterrízalo'), 'Rematando', 'Aterrizando'), 'rematando', 'aterrizando'), 'Rematar', 'Aterrizar'), 'rematar', 'aterrizar'), 'Rematan', 'Aterrizan'), 'rematan', 'aterrizan'), 'Remató', 'Aterrizó'), 'remató', 'aterrizó'), 'Remata', 'Aterriza'), 'remata', 'aterriza'), 'Remate', 'Aterrizaje'), 'remate', 'aterrizaje');
$fn$;

update public.lesson_translations lt
set
  title = pg_temp.fix_remate(lt.title),
  theory_md = pg_temp.fix_remate(lt.theory_md),
  examples_json = pg_temp.fix_remate(lt.examples_json::text)::jsonb,
  checks_json = pg_temp.fix_remate(lt.checks_json::text)::jsonb,
  rubric_json = pg_temp.fix_remate(lt.rubric_json::text)::jsonb,
  scenario_json = pg_temp.fix_remate(lt.scenario_json::text)::jsonb,
  mission_text = pg_temp.fix_remate(lt.mission_text),
  rehearsal_spec = pg_temp.fix_remate(lt.rehearsal_spec::text)::jsonb,
  updated_at = now()
from public.lessons l
join public.skills s on s.id = l.skill_id
where lt.lesson_id = l.id
  and lt.locale = 'es'
  and s.slug = 'interview-your-story';
