-- Spanish: lesson titles — El trabajo, Conocer a alguien, Apps de citas,
-- La primera cita.
--
-- Titles only. `lesson_title_translations` is the view built for exactly this:
-- it reads past the paywall so that a locked lesson still shows a Spanish
-- title, because a lock has to be legible to work as a lock. Everything that
-- carries actual teaching stays null and falls back to English, field by
-- field, until the depth pass reaches it.

create or replace function pg_temp.es_title(
  p_skill text, p_order integer, p_title text
) returns void language sql as $fn$
  insert into public.lesson_translations (lesson_id, locale, title)
  select l.id, 'es', p_title
  from public.lessons l
  join public.skills s on s.id = l.skill_id
  where s.slug = p_skill and l.sort_order = p_order
  on conflict (lesson_id, locale) do update set
    title = excluded.title,
    updated_at = now();
$fn$;

-- ---------------------------------------------------------------------------
-- El trabajo
-- ---------------------------------------------------------------------------

select pg_temp.es_title('speaking-in-meetings', 1, 'Dilo sin terminar');
select pg_temp.es_title('speaking-in-meetings', 2, 'Meter baza');
select pg_temp.es_title('speaking-in-meetings', 3, 'Apoyar a alguien');
select pg_temp.es_title('speaking-in-meetings', 4, 'Cuando te pisan');
select pg_temp.es_title('speaking-in-meetings', 5, 'Te preguntan de golpe y no tienes nada');

select pg_temp.es_title('your-manager', 1, 'Pide la media hora');
select pg_temp.es_title('your-manager', 2, 'Lleva una cosa que quieras');
select pg_temp.es_title('your-manager', 3, 'Discrepa una vez, en privado');
select pg_temp.es_title('your-manager', 4, 'Di que no con un intercambio');
select pg_temp.es_title('your-manager', 5, 'Malas noticias, pronto y claras');

select pg_temp.es_title('raising-a-problem', 1, 'Conducta, coste, cambio');
select pg_temp.es_title('raising-a-problem', 2, 'Díselo a esa persona primero');
select pg_temp.es_title('raising-a-problem', 3, 'Llevarlo hacia arriba');
select pg_temp.es_title('raising-a-problem', 4, 'No lo acumules');
select pg_temp.es_title('raising-a-problem', 5, 'Cuando no cambia nada');

select pg_temp.es_title('being-seen', 1, 'El trabajo no habla solo');
select pg_temp.es_title('being-seen', 2, 'Nombra el trabajo, no a ti');
select pg_temp.es_title('being-seen', 3, 'El mensaje que lo hace por ti');
select pg_temp.es_title('being-seen', 4, 'Cuando preguntan qué tal fue');
select pg_temp.es_title('being-seen', 5, 'El mérito no es una tarta');

select pg_temp.es_title('saying-what-you-want', 1, 'Ser bueno no es pedirlo');
select pg_temp.es_title('saying-what-you-want', 2, 'Di la dirección');
select pg_temp.es_title('saying-what-you-want', 3, 'Pide alcance, no un cargo');
select pg_temp.es_title('saying-what-you-want', 4, 'Antes de que haya vacante');
select pg_temp.es_title('saying-what-you-want', 5, 'Nadie se siente preparado');

select pg_temp.es_title('asking-for-money', 1, 'Pide un número, no una conversación');
select pg_temp.es_title('asking-for-money', 2, 'Dilo, y luego cállate');
select pg_temp.es_title('asking-for-money', 3, 'Pídelo antes de que se cierre el presupuesto');
select pg_temp.es_title('asking-for-money', 4, 'Tres cosas que hiciste');
select pg_temp.es_title('asking-for-money', 5, 'Qué hacer con un no');

select pg_temp.es_title('presenting', 1, 'Las diapositivas no son notas');
select pg_temp.es_title('presenting', 2, 'Di la conclusión primero');
select pg_temp.es_title('presenting', 3, 'Una persona cada vez');
select pg_temp.es_title('presenting', 4, 'La pausa dura menos de lo que parece');
select pg_temp.es_title('presenting', 5, 'La pregunta que no sabes responder');

select pg_temp.es_title('the-corridor', 1, 'El objetivo es que te reconozcan');
select pg_temp.es_title('the-corridor', 2, 'La versión de treinta segundos');
select pg_temp.es_title('the-corridor', 3, 'Ascensores, colas y cocinas');
select pg_temp.es_title('the-corridor', 4, 'La sala sin reloj');
select pg_temp.es_title('the-corridor', 5, 'Las dos líneas de después');

-- ---------------------------------------------------------------------------
-- Conocer a alguien
-- ---------------------------------------------------------------------------

select pg_temp.es_title('walking-up', 1, 'Lo que te da una sala');
select pg_temp.es_title('walking-up', 2, 'Colas, ascensores y andenes');
select pg_temp.es_title('walking-up', 3, 'Bares y fiestas');
select pg_temp.es_title('walking-up', 4, 'El gimnasio, la clase, el mismo café');
select pg_temp.es_title('walking-up', 5, 'A solas, o en grupo');

select pg_temp.es_title('first-two-minutes', 1, 'No te disculpes por estar ahí');
select pg_temp.es_title('first-two-minutes', 2, 'Los nombres, pronto');
select pg_temp.es_title('first-two-minutes', 3, 'Dos minutos, no diez');
select pg_temp.es_title('first-two-minutes', 4, 'Cuando se para a los noventa segundos');
select pg_temp.es_title('first-two-minutes', 5, 'Llegar al segundo tema');

select pg_temp.es_title('flirting-moves', 1, 'Qué hace que sea flirteo');
select pg_temp.es_title('flirting-moves', 2, 'Picar, con filo');
select pg_temp.es_title('flirting-moves', 3, 'Halaga la elección, no la cara');
select pg_temp.es_title('flirting-moves', 4, 'Un segundo más');
select pg_temp.es_title('flirting-moves', 5, 'El contacto, y sus escalones');
select pg_temp.es_title('flirting-moves', 6, 'Darte cuenta de vuelta');

select pg_temp.es_title('flirting-calibration', 1, 'La calidez es un dial, no un interruptor');
select pg_temp.es_title('flirting-calibration', 2, 'Señala, y luego lee');
select pg_temp.es_title('flirting-calibration', 3, 'La atención es la señal que cuenta');
select pg_temp.es_title('flirting-calibration', 4, 'Deja que hagan parte del trabajo');
select pg_temp.es_title('flirting-calibration', 5, 'Di la cosa llana');

select pg_temp.es_title('reading-disinterest', 1, 'Las tres señales');
select pg_temp.es_title('reading-disinterest', 2, 'Baja un registro');
select pg_temp.es_title('reading-disinterest', 3, 'La salida elegante');
select pg_temp.es_title('reading-disinterest', 4, 'Nada de enfurruñarse');
select pg_temp.es_title('reading-disinterest', 5, 'Cuando de verdad no lo sabes');

select pg_temp.es_title('asking-for-the-number', 1, 'Pídelo antes del pico');
select pg_temp.es_title('asking-for-the-number', 2, 'Di qué te apetece hacer');
select pg_temp.es_title('asking-for-the-number', 3, 'Que decir que no salga gratis');
select pg_temp.es_title('asking-for-the-number', 4, 'El no suave');
select pg_temp.es_title('asking-for-the-number', 5, 'El primer mensaje');

-- ---------------------------------------------------------------------------
-- Apps de citas
-- ---------------------------------------------------------------------------

select pg_temp.es_title('your-profile', 1, 'Que se te pueda escribir gana a impresionar');
select pg_temp.es_title('your-profile', 2, 'Las fotos tienen tareas');
select pg_temp.es_title('your-profile', 3, 'Filtra a propósito');
select pg_temp.es_title('your-profile', 4, 'Promete a la persona que va a aparecer');

select pg_temp.es_title('first-message', 1, '«Hola» no es un mensaje');
select pg_temp.es_title('first-message', 2, 'Lee buscando la rareza, no el resumen');
select pg_temp.es_title('first-message', 3, 'Una pregunta, no tres');
select pg_temp.es_title('first-message', 4, 'Cuando el perfil no dice nada');
select pg_temp.es_title('first-message', 5, 'Gracioso sin tono');

select pg_temp.es_title('match-to-date', 1, 'Responde, y luego pregunta');
select pg_temp.es_title('match-to-date', 2, 'Sal del interrogatorio');
select pg_temp.es_title('match-to-date', 3, 'Muévete antes de que se apague');
select pg_temp.es_title('match-to-date', 4, 'Propón para que el sí sea fácil');
select pg_temp.es_title('match-to-date', 5, 'Un toque, y el no suave');

select pg_temp.es_title('running-the-app', 1, 'El volumen no es un veredicto');
select pg_temp.es_title('running-the-app', 2, 'El ghosting es una costumbre, no un mensaje');
select pg_temp.es_title('running-the-app', 3, 'No te enamores de la versión por escrito');
select pg_temp.es_title('running-the-app', 4, 'Dale una forma');
select pg_temp.es_title('running-the-app', 5, 'Bórrala un mes');

select pg_temp.es_title('where-it-is-breaking', 1, 'Cuenta antes de concluir');
select pg_temp.es_title('where-it-is-breaking', 2, 'Ningún match');
select pg_temp.es_title('where-it-is-breaking', 3, 'Matches, pero nadie habla');
select pg_temp.es_title('where-it-is-breaking', 4, 'Conversaciones que se apagan');
select pg_temp.es_title('where-it-is-breaking', 5, 'Citas, pero ninguna segunda');

-- ---------------------------------------------------------------------------
-- La primera cita
-- ---------------------------------------------------------------------------

select pg_temp.es_title('before-you-go', 1, 'Un sitio del que puedas irte');
select pg_temp.es_title('before-you-go', 2, 'Di la hora de acabar');
select pg_temp.es_title('before-you-go', 3, 'Las cuatro horas de antes');
select pg_temp.es_title('before-you-go', 4, 'Dos o tres cosas que te den curiosidad');
select pg_temp.es_title('before-you-go', 5, 'Ve a averiguar, no a gustar');

select pg_temp.es_title('the-conversation', 1, 'Los diez primeros minutos tienen que ser incómodos');
select pg_temp.es_title('the-conversation', 2, 'Reacciona, no informes');
select pg_temp.es_title('the-conversation', 3, 'Cuánto de ti mismo');
select pg_temp.es_title('the-conversation', 4, 'Deja que divague, y deja que pare');
select pg_temp.es_title('the-conversation', 5, 'Trae algo de vuelta');

select pg_temp.es_title('do-you-like-them', 1, 'Llegaste a que te examinen');
select pg_temp.es_title('do-you-like-them', 2, '¿Lo estoy disfrutando?');
select pg_temp.es_title('do-you-like-them', 3, 'En qué fijarte de verdad');
select pg_temp.es_title('do-you-like-them', 4, 'Está permitido que sea un no');
select pg_temp.es_title('do-you-like-them', 5, 'No tienes por qué saberlo');

select pg_temp.es_title('what-happens-next', 1, 'Termina antes de que se aplane');
select pg_temp.es_title('what-happens-next', 2, 'Di la cosa llana');
select pg_temp.es_title('what-happens-next', 3, 'Haz que la siguiente sea real');
select pg_temp.es_title('what-happens-next', 4, 'Lee la respuesta');
select pg_temp.es_title('what-happens-next', 5, 'El mensaje del mismo día');
