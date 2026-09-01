-- Spanish: lesson titles — Hacer amigos, Conversaciones difíciles, Contar
-- historias, Mensajes, Hablar con la IA.
--
-- The second half of the titles pass. See migration 119 for why titles come
-- before theory.

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
-- Hacer amigos
-- ---------------------------------------------------------------------------

select pg_temp.es_title('why-it-got-hard', 1, 'Era el edificio, no tú');
select pg_temp.es_title('why-it-got-hard', 2, 'De qué está hecha la amistad');
select pg_temp.es_title('why-it-got-hard', 3, 'Elige una sala que se repita');
select pg_temp.es_title('why-it-got-hard', 4, 'La cuarta vez es la difícil');
select pg_temp.es_title('why-it-got-hard', 5, 'Ya tienes candidatos');

select pg_temp.es_title('first-invitation', 1, '«Tenemos que quedar» no ha producido nunca nada');
select pg_temp.es_title('first-invitation', 2, 'Nombra lo raro');
select pg_temp.es_title('first-invitation', 3, 'Pequeño, concreto, con un día dentro');
select pg_temp.es_title('first-invitation', 4, 'Ve a través del grupo');
select pg_temp.es_title('first-invitation', 5, 'Cuando no vuelve nada');

select pg_temp.es_title('the-second-time', 1, 'Alguien tiene que ir dos veces');
select pg_temp.es_title('the-second-time', 2, 'El pesado no existe');
select pg_temp.es_title('the-second-time', 3, 'Conviértelo en algo fijo');
select pg_temp.es_title('the-second-time', 4, 'Tres o cuatro veces es el umbral');
select pg_temp.es_title('the-second-time', 5, 'Cuando nunca toman la iniciativa');

select pg_temp.es_title('getting-past-pleasant', 1, 'Cuatro años y ninguna parte');
select pg_temp.es_title('getting-past-pleasant', 2, 'Ofrece, no preguntes');
select pg_temp.es_title('getting-past-pleasant', 3, 'Un escalón cada vez');
select pg_temp.es_title('getting-past-pleasant', 4, 'Di lo cálido en voz alta');
select pg_temp.es_title('getting-past-pleasant', 5, 'Cuando no vuelve');

select pg_temp.es_title('keeping-it-alive', 1, 'Manda cosas que no pidan nada');
select pg_temp.es_title('keeping-it-alive', 2, 'La línea que arregla un parón');
select pg_temp.es_title('keeping-it-alive', 3, 'Ritmos distintos no es fracasar');
select pg_temp.es_title('keeping-it-alive', 4, 'Sé quien se acuerda');
select pg_temp.es_title('keeping-it-alive', 5, 'Qué dejar ir');

-- ---------------------------------------------------------------------------
-- Conversaciones difíciles
-- ---------------------------------------------------------------------------

select pg_temp.es_title('worth-having', 1, 'Ensayar no es prepararse');
select pg_temp.es_title('worth-having', 2, '¿Qué cambio quieres?');
select pg_temp.es_title('worth-having', 3, 'Lo que cuesta el silencio');
select pg_temp.es_title('worth-having', 4, 'Soltarlo, de verdad');
select pg_temp.es_title('worth-having', 5, 'Ponle fecha');

select pg_temp.es_title('opening-it', 1, 'Nombra el tema al pedir el rato');
select pg_temp.es_title('opening-it', 2, 'No de pasada');
select pg_temp.es_title('opening-it', 3, 'Dilo en los treinta primeros segundos');
select pg_temp.es_title('opening-it', 4, 'Di qué quieres de ella');
select pg_temp.es_title('opening-it', 5, 'Por escrito, o en persona');

select pg_temp.es_title('saying-the-thing', 1, 'Qué pasó, qué provocó, qué quieres');
select pg_temp.es_title('saying-the-thing', 2, 'Siempre y nunca');
select pg_temp.es_title('saying-the-thing', 3, 'El efecto, no la intención');
select pg_temp.es_title('saying-the-thing', 4, 'Nada de sándwich de disculpa');
select pg_temp.es_title('saying-the-thing', 5, 'Dilo una vez');

select pg_temp.es_title('staying-in-the-room', 1, 'Su reacción no es un veredicto');
select pg_temp.es_title('staying-in-the-room', 2, 'No rellenes el silencio');
select pg_temp.es_title('staying-in-the-room', 3, 'Cuando se disgustan');
select pg_temp.es_title('staying-in-the-room', 4, 'Cuando te lo dan la vuelta');
select pg_temp.es_title('staying-in-the-room', 5, 'Terminar sin acuerdo');

select pg_temp.es_title('hearing-it', 1, 'Tres segundos');
select pg_temp.es_title('hearing-it', 2, 'Pide el ejemplo');
select pg_temp.es_title('hearing-it', 3, 'Tómate el tiempo');
select pg_temp.es_title('hearing-it', 4, 'El diez por ciento que es verdad');
select pg_temp.es_title('hearing-it', 5, 'Pedir perdón sin «pero»');

-- ---------------------------------------------------------------------------
-- Contar historias y hablar en público
-- ---------------------------------------------------------------------------

select pg_temp.es_title('why-stories-die', 1, 'El material estaba bien');
select pg_temp.es_title('why-stories-die', 2, 'Ningún motivo para contarla');
select pg_temp.es_title('why-stories-die', 3, 'Demasiado principio');
select pg_temp.es_title('why-stories-die', 4, 'Nada en juego');
select pg_temp.es_title('why-stories-die', 5, 'No la rebajes antes de empezar');

select pg_temp.es_title('the-shape', 1, 'Algo tiene que girar');
select pg_temp.es_title('the-shape', 2, 'Termina en la frase');
select pg_temp.es_title('the-shape', 3, 'Corta la exactitud');
select pg_temp.es_title('the-shape', 4, 'Una historia, no tres');
select pg_temp.es_title('the-shape', 5, 'Cuatro decisiones antes de hablar');

select pg_temp.es_title('telling-it', 1, 'En presente');
select pg_temp.es_title('telling-it', 2, 'Las palabras textuales');
select pg_temp.es_title('telling-it', 3, 'Un detalle que trabaje');
select pg_temp.es_title('telling-it', 4, 'Ten clara tu última frase');
select pg_temp.es_title('telling-it', 5, 'Baja el ritmo y deja de moverte');

select pg_temp.es_title('holding-the-floor', 1, 'Nadie odia una buena historia');
select pg_temp.es_title('holding-the-floor', 2, 'Cuánto tiempo tienes');
select pg_temp.es_title('holding-the-floor', 3, 'Aterrizar una que se muere');
select pg_temp.es_title('holding-the-floor', 4, 'Cuándo no contar ninguna');
select pg_temp.es_title('holding-the-floor', 5, 'Que te interrumpan');

select pg_temp.es_title('no-warning', 1, 'Una cosa, un ejemplo, un cierre');
select pg_temp.es_title('no-warning', 2, 'El brindis');
select pg_temp.es_title('no-warning', 3, 'Más corto siempre es mejor');
select pg_temp.es_title('no-warning', 4, 'Primera y última frase de memoria');
select pg_temp.es_title('no-warning', 5, 'Nadie lo nota');

-- ---------------------------------------------------------------------------
-- Mensajes
-- ---------------------------------------------------------------------------

select pg_temp.es_title('stop-apologising', 1, 'Todo lo que va antes de la petición');
select pg_temp.es_title('stop-apologising', 2, 'La palabra «solo»');
select pg_temp.es_title('stop-apologising', 3, 'Pedir no es abusar');
select pg_temp.es_title('stop-apologising', 4, 'Ser educado no es disculparse');
select pg_temp.es_title('stop-apologising', 5, 'Insistir');

select pg_temp.es_title('easy-to-reply-to', 1, 'Una sola petición');
select pg_temp.es_title('easy-to-reply-to', 2, 'La petición primero, el contexto después');
select pg_temp.es_title('easy-to-reply-to', 3, 'Que contestar salga barato');
select pg_temp.es_title('easy-to-reply-to', 4, '«Sin prisa» significa nunca');
select pg_temp.es_title('easy-to-reply-to', 5, 'Escrito para un pasillo');

select pg_temp.es_title('tone-with-no-tone', 1, 'Todo se lee más frío');
select pg_temp.es_title('tone-with-no-tone', 2, 'Añade la calidez a propósito');
select pg_temp.es_title('tone-with-no-tone', 3, 'Los puntos, el «vale» y los emojis');
select pg_temp.es_title('tone-with-no-tone', 4, 'Una respuesta corta no es enfado');
select pg_temp.es_title('tone-with-no-tone', 5, 'Deja de descifrar');

select pg_temp.es_title('group-chats', 1, 'Mándalo tarde, sin disculparte');
select pg_temp.es_title('group-chats', 2, 'El chiste que muere');
select pg_temp.es_title('group-chats', 3, 'Reacciona a los demás');
select pg_temp.es_title('group-chats', 4, 'Volver después de meses');
select pg_temp.es_title('group-chats', 5, 'Cuando debería ser un privado');

select pg_temp.es_title('not-everything-is-a-message', 1, 'Tres mensajes significa llamar');
select pg_temp.es_title('not-everything-is-a-message', 2, 'Lo difícil no es para escribirlo');
select pg_temp.es_title('not-everything-is-a-message', 3, 'Un silencio no es un mensaje');
select pg_temp.es_title('not-everything-is-a-message', 4, 'El tiempo de respuesta no es un marcador');
select pg_temp.es_title('not-everything-is-a-message', 5, 'El envío de las once de la noche');

-- ---------------------------------------------------------------------------
-- Hablar con la IA
-- ---------------------------------------------------------------------------

select pg_temp.es_title('an-answer-worth-having', 1, 'Pega la cosa de verdad');
select pg_temp.es_title('an-answer-worth-having', 2, 'Di para qué es');
select pg_temp.es_title('an-answer-worth-having', 3, 'Discute, no empieces de cero');
select pg_temp.es_title('an-answer-worth-having', 4, 'No preguntes nunca si está bien');
select pg_temp.es_title('an-answer-worth-having', 5, 'Empieza otra cuando cambie el tema');

select pg_temp.es_title('the-free-question', 1, 'Eso a lo que llevas asintiendo');
select pg_temp.es_title('the-free-question', 2, 'Pregúntalo por tercera vez');
select pg_temp.es_title('the-free-question', 3, 'Pregunta lo que todos dan por hecho');
select pg_temp.es_title('the-free-question', 4, 'Dilo en la sala');
select pg_temp.es_title('the-free-question', 5, 'Buscarlo no es hacer trampa');

select pg_temp.es_title('edit-do-not-write', 1, 'Escríbelo mal primero');
select pg_temp.es_title('edit-do-not-write', 2, 'Recorta, no mejores');
select pg_temp.es_title('edit-do-not-write', 3, 'Quédate con tu frase torpe');
select pg_temp.es_title('edit-do-not-write', 4, 'Las señales');
select pg_temp.es_title('edit-do-not-write', 5, 'Para qué sirve de verdad');

select pg_temp.es_title('rehearse-it-first', 1, 'Describe a la persona real');
select pg_temp.es_title('rehearse-it-first', 2, 'Pide la versión difícil');
select pg_temp.es_title('rehearse-it-first', 3, '¿Qué no estoy diciendo?');
select pg_temp.es_title('rehearse-it-first', 4, 'Los quince primeros segundos');
select pg_temp.es_title('rehearse-it-first', 5, 'Dilo en voz alta');

select pg_temp.es_title('it-does-not-know-the-room', 1, 'No le preguntes qué significa un mensaje');
select pg_temp.es_title('it-does-not-know-the-room', 2, 'Te da la razón en tu encuadre');
select pg_temp.es_title('it-does-not-know-the-room', 3, 'No conoce tu registro');
select pg_temp.es_title('it-does-not-know-the-room', 4, 'No te va a decir que no lo mandes');
select pg_temp.es_title('it-does-not-know-the-room', 5, 'En qué acierta de forma fiable');

select pg_temp.es_title('do-not-outsource-the-reps', 1, 'Nunca en el momento');
select pg_temp.es_title('do-not-outsource-the-reps', 2, 'Cuando el esfuerzo es el mensaje');
select pg_temp.es_title('do-not-outsource-the-reps', 3, 'Manda el sexto en frío');
select pg_temp.es_title('do-not-outsource-the-reps', 4, 'Pulir es evitar');
select pg_temp.es_title('do-not-outsource-the-reps', 5, 'Las repeticiones son con personas');
