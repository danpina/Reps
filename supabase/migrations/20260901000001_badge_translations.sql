-- Reading badge names and descriptions in Spanish or German.
--
-- Same shape as topic/skill/lesson translations: the base table stays
-- English, a sibling table carries one row per badge per locale with every
-- column nullable, and the app merges per field. Badges are milestone copy,
-- not curriculum, but they are still content served straight to the reader
-- rather than app chrome, so they belong here rather than in next-intl's
-- message catalogs.

create table public.badge_translations (
  badge_id uuid not null references public.badges (id) on delete cascade,
  locale text not null constraint badge_locale_is_supported
    check (locale in ('en', 'es', 'de')),

  name text,
  description text,

  updated_at timestamptz not null default now(),
  primary key (badge_id, locale)
);

alter table public.badge_translations enable row level security;

create policy "Signed-in users read badge translations"
  on public.badge_translations for select
  to authenticated
  using (true);

insert into public.badge_translations (badge_id, locale, name, description)
select id, 'es', v.name, v.description
from public.badges
join (
  values
    ('first-rep', 'Primera repetición', 'Registraste una conversación real. Esta es la parte que cuenta.'),
    ('logged-a-bad-one', 'Registraste una mala', 'Registraste una repetición que no salió bien. El registro solo vale algo si es honesto.'),
    ('ten-reps', 'Diez en la calle', 'Diez conversaciones reales registradas.'),
    ('seven-day-streak', 'Siete días', 'Una semana presentándote. Los días de descanso cuentan.'),
    ('ten-labels', 'Diez etiquetas en la calle', 'Diez repeticiones registradas sobre escuchar y etiquetar.'),
    ('first-flirting-mission', 'Primera misión de flirteo', 'Practicaste la más difícil, a propósito.'),
    ('read-the-room', 'Leer la sala', 'Una repetición registrada sobre notar que el interés no era mutuo, y despedirte con calidez.'),
    ('second-draft', 'Segundo borrador', 'Volviste a una repetición que salió mal y averiguaste qué dirías en su lugar.'),
    ('all-nine', 'Las nueve habilidades', 'Al menos una repetición registrada en las nueve categorías.'),
    ('fifty-reps', 'Cincuenta repeticiones', 'Cincuenta conversaciones reales. Vuelve atrás en el registro y lee la primera.')
) as v(slug, name, description)
  on v.slug = badges.slug;
