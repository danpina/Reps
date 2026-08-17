-- Reading the curriculum in Spanish or German.
--
-- The base tables stay English and stay the source of truth. Translations live
-- alongside them, one row per row per locale, with every translated column
-- nullable — so a missing translation falls back per field rather than per
-- row. A topic with a translated name and an untranslated promise shows the
-- Spanish name and the English promise, which is the only behaviour that lets
-- a language be shipped before it is finished.
--
-- The alternative, a single wide key/value table, was rejected because the
-- JSON columns carry structure the app parses — examples, checks, rubrics,
-- scenarios, rehearsal specs — and flattening those into text loses the one
-- guarantee worth having, which is that a translated lesson has the same shape
-- as the English one.
--
-- Nothing here is writable through the API. Translations arrive by migration,
-- exactly like the content they translate.

-- ---------------------------------------------------------------------------
-- Which language somebody reads in
-- ---------------------------------------------------------------------------

-- Not an enum: adding a language should be a one-line change to a constraint
-- rather than a type alteration, and the set is small enough to read.
alter table public.profiles
  add column locale text not null default 'en'
  constraint locale_is_supported check (locale in ('en', 'es', 'de'));

comment on column public.profiles.locale is
  'The language the curriculum is read in. Falls back to English per field.';

-- ---------------------------------------------------------------------------
-- Topics
-- ---------------------------------------------------------------------------

create table public.topic_translations (
  topic_id uuid not null references public.topics (id) on delete cascade,
  locale text not null constraint topic_locale_is_supported
    check (locale in ('en', 'es', 'de')),

  name text,
  description text,
  promise text,
  cheatsheet_json jsonb,

  updated_at timestamptz not null default now(),
  primary key (topic_id, locale)
);

alter table public.topic_translations enable row level security;

create policy "Signed-in users read topic translations"
  on public.topic_translations for select
  to authenticated
  using (true);

-- ---------------------------------------------------------------------------
-- Skills
-- ---------------------------------------------------------------------------

create table public.skill_translations (
  skill_id uuid not null references public.skills (id) on delete cascade,
  locale text not null constraint skill_locale_is_supported
    check (locale in ('en', 'es', 'de')),

  name text,
  description text,
  core_idea text,
  takeaway_md text,

  updated_at timestamptz not null default now(),
  primary key (skill_id, locale)
);

alter table public.skill_translations enable row level security;

create policy "Signed-in users read skill translations"
  on public.skill_translations for select
  to authenticated
  using (true);

-- ---------------------------------------------------------------------------
-- Lessons
-- ---------------------------------------------------------------------------

create table public.lesson_translations (
  lesson_id uuid not null references public.lessons (id) on delete cascade,
  locale text not null constraint lesson_locale_is_supported
    check (locale in ('en', 'es', 'de')),

  title text,
  theory_md text,
  examples_json jsonb,
  checks_json jsonb,
  rubric_json jsonb,
  scenario_json jsonb,
  mission_text text,
  rehearsal_spec jsonb,

  updated_at timestamptz not null default now(),
  primary key (lesson_id, locale)
);

alter table public.lesson_translations enable row level security;

/**
 * The paywall, inherited rather than restated.
 *
 * A translated lesson is the same goods as the English one, so it has to be
 * behind the same gate — otherwise a free account reads every locked lesson by
 * switching to Spanish, which would be an expensive way to find out that this
 * table existed.
 *
 * The policy asks whether the row's lesson is visible rather than repeating
 * `is_pro() or is_preview_lesson(...)`. Row level security applies inside this
 * subquery too, so the answer is exactly whatever the lessons policy says —
 * and it stays exactly that if the entitlement rules ever change, which a
 * copied condition would not.
 */
create policy "Users read translations of lessons they are entitled to"
  on public.lesson_translations for select
  to authenticated
  using (
    exists (select 1 from public.lessons l where l.id = lesson_id)
  );

/**
 * Translated titles, past the gate.
 *
 * The same argument as `lesson_index`, which this exists to complete: a lock
 * has to be visible to work as a lock, and a title is an advertisement rather
 * than the goods. Without this, a Spanish reader on a free account would see
 * their two open lessons in Spanish and the locked ones in English, which
 * reads as broken rather than as locked.
 *
 * Titles only. Every column that carries actual teaching is left out, so this
 * cannot leak the thing being sold.
 */
create view public.lesson_title_translations
with (security_invoker = false) as
  select t.lesson_id, t.locale, t.title
  from public.lesson_translations t
  where t.title is not null;

revoke all on public.lesson_title_translations from public, anon;
grant select on public.lesson_title_translations to authenticated;

-- ---------------------------------------------------------------------------
-- Choosing a language at signup
-- ---------------------------------------------------------------------------

/**
 * Carries the language chosen on the signup form onto the new profile.
 *
 * Validated here rather than trusted, because raw_user_meta_data is written by
 * the client and an unrecognised value would otherwise fail the check
 * constraint and take the whole signup with it. Anything unexpected reads as
 * English, which is the same rule the application applies.
 */
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name, locale)
  values (
    new.id,
    nullif(trim(new.raw_user_meta_data ->> 'display_name'), ''),
    coalesce(
      nullif(
        case
          when new.raw_user_meta_data ->> 'locale' in ('en', 'es', 'de')
            then new.raw_user_meta_data ->> 'locale'
          else null
        end,
        ''
      ),
      'en'
    )
  );
  return new;
end;
$$;
