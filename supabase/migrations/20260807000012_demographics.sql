-- Who you are, and who you have been practising on.
--
-- Both exist for the same reason: advice about talking to people is bad advice
-- when it ignores who is talking to whom. "Tease the situation before you tease
-- the person" is sound at thirty and reads as instruction from a stranger at
-- sixty. A read of a log that can see who each conversation was with can say
-- something no generic coach could — that every rep rated badly was with
-- someone older, say — and that is a sentence worth having.
--
-- Everything here is nullable, and stays nullable. Nobody is made to answer a
-- question about themselves to use a training diary, and a required field
-- would only produce a population of people who picked whatever was first in
-- the list.

create type public.sex as enum ('male', 'female');

-- Bands rather than a number: nobody needs a birthday to give better advice,
-- a band cannot be wrong by a year, and it is far less to lose if this
-- database is ever somewhere it should not be. Starting at 18 because the
-- Dating topic exists.
create type public.age_group as enum (
  '18-24', '25-34', '35-44', '45-54', '55-64', '65+'
);

alter table public.profiles
  add column sex public.sex,
  add column age_group public.age_group;

-- Both are the user's own to change, so they join the short list of columns
-- their own session may write. Everything not granted stays read-only to the
-- row's owner, which is what keeps a blocked user from clearing their block.
grant update (sex, age_group) on public.profiles to authenticated;

-- The other half of the conversation. A guess, always — you do not ask someone
-- their age band at a bus stop — so it is optional twice over: optional to
-- record, and never treated as fact by anything that reads it.
alter table public.field_logs
  add column other_sex public.sex,
  add column other_age_group public.age_group;

-- Reading the log by who it was with is the whole point of collecting this, so
-- the index matches the question rather than the column.
create index field_logs_user_other_idx
  on public.field_logs (user_id, other_sex, other_age_group);
