-- Lessons that know who is reading them.
--
-- Two things, and they only make sense together.
--
-- The first is who someone is practising dating with. It is asked as that
-- rather than as an orientation, because that is the fact the app actually
-- uses: a rehearsal partner has to be someone, and a lesson about approaching
-- strangers is different advice depending on who is being approached. Storing
-- a preference the product consumes is more honest than storing an identity
-- label and then interpreting it, and it is less to hold about somebody.
--
-- The second is the mechanism for content that varies. Most lessons do not
-- vary at all — an opener at a bus stop is an opener — and duplicating 250
-- lessons across every audience would produce four copies of the same writing
-- and one place for them to drift apart. So a lesson keeps one body, and
-- carries optional variants beside it: an extra passage, or a different set of
-- worked examples, for a reader the general version serves badly.
--
-- Where this earns its keep is Dating, where the asymmetries are real. The
-- dominant risk for a man approaching women is being read as a threat. For a
-- woman approaching men it is being read as far more interested than she is.
-- Between two people of the same sex it is frequently not knowing whether the
-- other person is available at all. Those are three different lessons wearing
-- one title, and pretending otherwise is what makes generic dating advice
-- useless.

create type public.dating_interest as enum ('men', 'women', 'both');

alter table public.profiles
  add column dating_interest public.dating_interest;

grant update (dating_interest) on public.profiles to authenticated;

-- [{ when: { sex?, dating_interest? }, label, note_md?, examples_json?,
--    partner_sex? }]
--
-- `when` is a set of conditions, all of which must hold. The most specific
-- matching variant wins, and a lesson with no matching variant simply renders
-- as written — which is the case for almost all of them.
alter table public.lessons
  add column variants_json jsonb not null default '[]'::jsonb;

alter table public.lessons
  add constraint variants_is_array check (jsonb_typeof(variants_json) = 'array');
