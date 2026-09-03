-- "Read the room" translated literally as "Leer la sala" reads as reading a
-- physical room, not the English idiom for sensing a social situation's mood.
-- "Leer el ambiente" is the natural Peninsular Spanish equivalent.

update public.badge_translations
set name = 'Leer el ambiente', updated_at = now()
from public.badges
where badges.id = badge_translations.badge_id
  and badges.slug = 'read-the-room'
  and badge_translations.locale = 'es';
