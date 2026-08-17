-- Spanish: Small talk, track 2 — Cómo empezar.
--
-- One thing here is not a translation but a repair, and it is worth stating
-- because it will recur in German.
--
-- FORD is a mnemonic: Family, Occupation, Recreation, Dreams. Migration 99
-- glossed it as Familia, Ocupación, Ocio, Sueños — which is accurate word by
-- word and destroys the only thing the acronym is for, because those initials
-- spell FOOS. A mnemonic that does not spell anything is just a list.
--
-- So the four rooms are renamed to keep the letters: Familia, Oficio, Recreo,
-- Deseos. Oficio is a shade more old-fashioned than Ocupación and Recreo a
-- shade more playful than Ocio, and both are worth it — a reader can carry
-- FORD out of the lesson, which is the entire point of teaching it as four
-- letters rather than four ideas.
--
-- The skill's core idea from 99 is corrected here rather than in a separate
-- migration, which is what the on-conflict clauses were written for.

update public.skill_translations set
  core_idea = $$FORD+ — Familia, Oficio, Recreo, Deseos, más el Entorno. Empezar por el entorno no arriesga nada y siempre está disponible.$$,
  updated_at = now()
where locale = 'es'
  and skill_id = (select id from public.skills where slug = 'openers');

create or replace function pg_temp.es_lesson(
  p_skill text, p_order integer,
  p_title text, p_theory text,
  p_examples jsonb, p_checks jsonb, p_rubric jsonb,
  p_scenario jsonb, p_mission text, p_spec jsonb
) returns void language sql as $fn$
  insert into public.lesson_translations (
    lesson_id, locale, title, theory_md, examples_json, checks_json,
    rubric_json, scenario_json, mission_text, rehearsal_spec
  )
  select l.id, 'es', p_title, p_theory, p_examples, p_checks,
         p_rubric, p_scenario, p_mission, p_spec
  from public.lessons l
  join public.skills s on s.id = l.skill_id
  where s.slug = p_skill and l.sort_order = p_order
  on conflict (lesson_id, locale) do update set
    title = excluded.title,
    theory_md = excluded.theory_md,
    examples_json = excluded.examples_json,
    checks_json = excluded.checks_json,
    rubric_json = excluded.rubric_json,
    scenario_json = excluded.scenario_json,
    mission_text = excluded.mission_text,
    rehearsal_spec = excluded.rehearsal_spec,
    updated_at = now();
$fn$;

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('openers', 1,
  'Usa lo que ya hay en la sala',
  $md$Casi todo el mundo se atasca antes de la primera frase porque anda buscando algo ingenioso. No necesitas ingenio. Necesitas algo compartido.

Un comienzo de entorno señala algo dentro de lo que ya estáis los dos: la cola, el ruido, el retraso, lo que hay encima de la mesa. Funciona porque es verdad, es obvio y no arriesga nada. No has afirmado nada sobre ti y no les has pedido nada.

**La jugada:** nombra algo en lo que estéis los dos, dilo llanamente, y calla.

Ese callar es la técnica entera. Un comentario sin pausa es un comentario. Un comentario seguido de un pequeño silencio es una invitación.$md$,
  $j$[
    {
      "situation": "La cafetera del trabajo lleva una eternidad moliendo.",
      "line": "Esa máquina se está ganando el sueldo esta mañana.",
      "why": "Señala algo que los dos podéis oír. No hay opinión con la que discrepar, así que la respuesta más fácil es estar de acuerdo, y estar de acuerdo ya es un turno."
    },
    {
      "situation": "Acaba de terminar una charla y la sala se va vaciando despacio.",
      "line": "Eso ha durado unos veinte minutos más de lo que yo tenía previsto.",
      "why": "Una experiencia compartida más una queja suave sobre la situación. Quejarse un poco de las circunstancias, nunca de una persona, es de las formas más rápidas de que dos desconocidos se sientan aliados."
    },
    {
      "situation": "Estás cerca de la comida en una fiesta donde no conoces casi a nadie.",
      "line": "Llevo un rato mirándolos intentando averiguar qué llevan dentro.",
      "why": "Admite algo pequeño y algo ridículo sobre ti, lo que baja el listón también para la otra persona. Además le da algo concreto a lo que responder."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Los dos esperáis un tren que ya se ha retrasado dos veces. ¿Qué comienzo trabaja más?",
      "options": [
        { "text": "¿Coges esta línea a menudo?", "correct": false, "note": "Va sobre esa persona y no sobre la situación, así que llega como un desconocido pidiendo información. Puede funcionar, pero cuesta más de lo necesario." },
        { "text": "Este es el segundo retraso de la noche, ¿no?", "correct": true, "note": "Verdadero, compartido y lo bastante concreto como para que puedan darte la razón o corregirte. Las dos cosas son un turno." },
        { "text": "Menudo tiempo llevamos.", "correct": false, "note": "Técnicamente es el entorno, pero es tan genérico que no hay nada a lo que contestar." },
        { "text": "¿Y tú a qué te dedicas?", "correct": false, "note": "Eso es un comienzo de Oficio. Es una sala perfectamente buena en la que acabar, pero entrar en ella desde el silencio es un salto." }
      ],
      "explain": "Los comienzos de entorno más fuertes son concretos. Los genéricos son seguros e inertes, porque no hay dónde agarrarse."
    },
    {
      "prompt": "Abres con un comentario sobre la lluvia. Dicen que sí, y nada más. ¿Qué ha fallado?",
      "options": [
        { "text": "Nada necesariamente. Algunos comienzos caen en alguien que no tenía nada que añadir.", "correct": true, "note": "La respuesta más probable, y la que la gente se salta. Un comienzo muerto suele ser el momento, no la frase. Prueba otro más tarde." },
        { "text": "El tiempo es demasiado aburrido para empezar por ahí.", "correct": false, "note": "El tiempo es flojo por genérico, pero un montón de comienzos sosos funcionan bien. Una respuesta plana no es prueba de nada." },
        { "text": "Tendrías que haber preguntado algo.", "correct": false, "note": "Una pregunta habría forzado una respuesta más larga, que no es lo mismo que una conversación mejor." },
        { "text": "Elegiste a alguien que no quería hablar.", "correct": false, "note": "Posible, y no puedes saberlo con una respuesta. Leer eso requiere más que una contestación plana." }
      ],
      "explain": "La mayoría de los comienzos que no van a ningún sitio no han fracasado. Simplemente han caído en alguien que no tenía nada que decir de esa cosa concreta."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "shared_anchor", "label": "Anclado en algo compartido", "description": "Abriste con algo que los dos estabais viviendo de verdad, no con un comentario genérico." },
      { "key": "left_a_gap", "label": "Dejaste sitio para responder", "description": "Callaste después del comienzo en vez de llenar el silencio." },
      { "key": "plainness", "label": "Lo dijiste llanamente", "description": "Elegiste una frase verdadera y corriente antes que una ingeniosa o ensayada." },
      { "key": "specificity", "label": "Concreto como para contestarlo", "description": "Le diste a la otra persona algo donde agarrarse en vez de una generalidad." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "El desayuno bufé de un hotel de cadena, segundo día de un congreso de tres. Hay una cola corta para la cafetera y sale muy lenta.",
    "partner": {
      "name": "Marta",
      "role": "otra asistente a la que no conoces",
      "personality": "Seca y observadora. No es antipática, pero no va a hacer el trabajo de la conversación por ti.",
      "mood": "Sin suficiente café y algo aburrida.",
      "openness": 3
    },
    "opening_beat": "Marta mira cómo la cafetera va goteando. Te echa un vistazo rápido y vuelve a la máquina.",
    "success_looks_like": "La persona abre con algo en lo que estáis los dos y luego deja espacio. Marta toma un turno de verdad sin que haya que arrastrarla.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Responde a la longitud que respondería alguien real con apertura 3: una o dos frases, más cálida solo cuando se lo hayan ganado.",
      "Si abre con una pregunta personal antes de que haya complicidad, contesta breve y algo plana.",
      "No propongas temas nuevos en los dos primeros turnos. Deja que lleve la otra persona."
    ]
  }$j$::jsonb,
  $md$Empieza hoy una conversación con un comienzo de entorno: algo dentro de lo que ya estáis los dos. Dilo y luego calla. Anótalo aunque no fuera a ningún sitio.$md$,
  $j${
  "says": "Marta mira cómo la cafetera va goteando. Te echa un vistazo rápido y vuelve a la máquina.",
  "model": {
    "line": "Esa máquina se está ganando el sueldo esta mañana.",
    "why": "Nombra la cosa en la que los dos estáis esperando, la dice llanamente, y luego para."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Nombra algo en lo que ya estéis los dos", "words": ["máquina", "café", "cola", "esperar", "esperando", "mañana", "taza", "cafetera", "filtro", "lenta"] },
    { "kind": "max_sentences", "requirement": "Una frase. Y luego para.", "n": 1 },
    { "kind": "max_words", "requirement": "Que sea llano — menos de veinte palabras", "n": 20 }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('openers', 2,
  'Comprueba antes si están disponibles',
  $md$Un buen comienzo en mal momento fracasa, y fracasa de una forma que parece personal aunque no lo fuera.

Antes de decir nada, dedica dos segundos a leer la disponibilidad. Buscas tres cosas: si tienen los ojos levantados, si tienen las manos libres, y si ya están dentro de algo — una llamada, una cola en la que están a punto de llegar, una conversación con otra persona.

**La jugada:** busca una señal de que están abiertos. Si no la encuentras, espera o sigue tu camino.

Esto no es prudencia por la prudencia. Los comienzos caen mucho mejor en alguien que tiene sitio para ellos, así que leer primero sube tu porcentaje. Y saber que comprobaste hace mucho más llevadera una respuesta plana.$md$,
  $j$[
    {
      "situation": "Alguien en la mesa de al lado lleva auriculares y escribe rápido.",
      "line": "No digas nada todavía.",
      "why": "Auriculares más impulso es un no claro. Esperar a que salga no te cuesta nada, e interrumpir gastaría buena voluntad que quizá quieras luego."
    },
    {
      "situation": "Alguien delante de ti en la cola levanta la vista del móvil y echa un vistazo al local.",
      "line": "¿Has probado eso que parece que pide todo el mundo aquí?",
      "why": "Levantar la vista y mirar alrededor es la señal de disponibilidad más clara que hay. Acaban de decirte que les sobra atención."
    },
    {
      "situation": "En una fiesta, alguien se separa un paso de un grupo y mira hacia la mesa de las bebidas.",
      "line": "Creo que esa es mi señal para ir a por otra también.",
      "why": "Salirse de un grupo es un momento de transición. La gente está más abierta en los huecos entre cosas, no en mitad de ellas."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál de estas es la señal más fuerte de que alguien tiene sitio para una conversación?",
      "options": [
        { "text": "Está solo.", "correct": false, "note": "Estar solo no es lo mismo que estar disponible. Mucha gente que está sola se está tomando un respiro a propósito." },
        { "text": "Levanta los ojos y mira alrededor.", "correct": true, "note": "Ojos arriba y mirando alrededor significa que su atención está libre y buscando dónde ir. Es la señal más fiable que existe." },
        { "text": "Está de pie cerca de ti.", "correct": false, "note": "La proximidad suele ser un accidente de la sala. No dice nada sobre la atención." },
        { "text": "Sonrió al entrar.", "correct": false, "note": "Una sonrisa al llegar va dirigida a la sala en general, no a ti, y normalmente ha caducado para cuando actúas sobre ella." }
      ],
      "explain": "La disponibilidad va de dónde está la atención de alguien, no de dónde está su cuerpo. Los ojos son la pista."
    },
    {
      "prompt": "Alguien lleva auriculares pero está mirando al vacío en vez de trabajando. ¿Disponible o no?",
      "options": [
        { "text": "No disponible. Los auriculares son la señal.", "correct": false, "note": "Auriculares más impulso es un no. Auriculares más mirada perdida se parece bastante más a un sí." },
        { "text": "Disponible. Su atención está libre, lleve lo que lleve en los oídos.", "correct": true, "note": "La disponibilidad va de dónde está la atención. A quien mira al vacío le sobra atención y muchas veces agradece la interrupción." },
        { "text": "Imposible saberlo sin más información.", "correct": false, "note": "Ya tienes la información que importa. Esperar a la certeza es no abrir nunca." },
        { "text": "Disponible, pero solo para algo muy breve.", "correct": false, "note": "Un instinto razonable que infravalora la señal. Alguien desocupado suele agradecer una conversación de verdad." }
      ],
      "explain": "Lee la atención, no los accesorios. Los auriculares en alguien ocupado significan no; en alguien parado significan muy poco."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "read_before_opening", "label": "Leíste el momento primero", "description": "Buscaste una señal de disponibilidad antes de hablar en vez de abrir a ciegas." },
      { "key": "chose_a_gap", "label": "Elegiste una transición", "description": "Te acercaste en un hueco entre cosas en lugar de interrumpir un impulso." },
      { "key": "accepted_the_read", "label": "Aceptaste el no con elegancia", "description": "Cuando faltaba la señal o la respuesta fue plana, te retiraste sin enfurruñarte visiblemente." },
      { "key": "opener_quality", "label": "El comienzo aun así cayó bien", "description": "Habiendo encontrado buen momento, abriste igualmente con algo compartido y concreto." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Un espacio de coworking concurrido a media tarde. Estás rellenando una botella de agua en la encimera de la cocina.",
    "partner": {
      "name": "Dev",
      "role": "alguien que trabaja para otra empresa en la misma planta",
      "personality": "Bastante simpático pero de verdad ocupado, y honesto al respecto.",
      "mood": "A mitad de tarea y algo apurado, con una entrega hoy.",
      "openness": 2
    },
    "opening_beat": "Dev espera a que hierva el agua, con el móvil en una mano, deslizando. No levanta la vista cuando llegas.",
    "success_looks_like": "La persona nota que Dev aún no está disponible, espera o abre suave sin pedir mucho, y o se gana un momento cuando Dev sale, o lo deja estar con calidez.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Sostén la apertura 2 con firmeza. Responde corto y haz que le cueste. No te ablandes solo porque se esté esforzando.",
      "Ponte notablemente más cálido solo si lee bien que estás ocupado y te da una salida fácil.",
      "Si insiste en una conversación larga, sigue siendo educado pero mantén las respuestas cortadas."
    ]
  }$j$::jsonb,
  $md$Antes de abrir una conversación hoy, dedica dos segundos a comprobar si esa persona está disponible de verdad. Anota qué señal leíste y si tu lectura resultó acertada.$md$,
  $j${
  "beats": [
    {
      "situation": "Un andén en una línea con retraso. La mujer que tienes al lado lleva auriculares, está girada hacia el otro lado y ya tiene el bolso al hombro.",
      "prompt": "¿Qué haces?",
      "options": [
        { "text": "Decir algo sobre el retraso igualmente.", "correct": false, "note": "Auriculares, girada, bolso arriba. Son tres señales y ninguna es una apertura. No está siendo antipática: está a mitad de trayecto." },
        { "text": "Esperar. Volver a leer en un minuto, y dejarlo si nada ha cambiado.", "correct": true, "note": "Esa es la jugada. La disponibilidad es una condición previa, no un obstáculo que superar hablando." },
        { "text": "Ponerte en su campo de visión para que se quite los auriculares.", "correct": false, "note": "Hacer que alguien se desconecte para que le hablen es exactamente lo contrario de comprobar si está disponible." }
      ]
    },
    {
      "situation": "El mismo andén, cinco minutos después. El hombre que tienes al lado se guarda el móvil, mira al panel y luego echa un vistazo a la gente que espera.",
      "prompt": "¿Qué haces?",
      "options": [
        { "text": "Decir algo sobre la espera.", "correct": true, "note": "Móvil guardado, ojos arriba, ya mirando el andén. Un desconocido no está mucho más disponible que eso." },
        { "text": "Esperar una señal más clara que esa.", "correct": false, "note": "No viene ninguna más clara. Aguantar a por la certeza es como toda esta habilidad se convierte en silencio para siempre." },
        { "text": "Nada: no te ha mirado a ti concretamente.", "correct": false, "note": "Que te miren no es la señal. Que estén desocupados sí." }
      ]
    }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('openers', 3,
  'Di algo en vez de preguntar algo',
  $md$Las preguntas parecen más seguras que las afirmaciones, y por eso la gente nerviosa hace tantas. Pero una ráfaga de preguntas te convierte en entrevistador, y los entrevistadores son difíciles de coger cariño. La otra persona acaba contándolo todo sin llegar a saber nada de ti.

Una afirmación hace dos cosas que una pregunta no puede. Enseña una esquirla de ti — cómo ves lo que tienes delante — y deja a la otra persona libre para coger el hilo que prefiera, en vez de contestar al que le has puesto en la mano.

**La jugada:** cambia el signo de interrogación por un punto, y confía en que el silencio pregunte por ti.

No estás prohibiendo las preguntas. Estás asegurándote de que lo primero que sale de tu boca sea una pequeña oferta y no una pequeña exigencia.$md$,
  $j$[
    {
      "situation": "Los dos estáis mirando un cuadro genuinamente raro en una galería.",
      "line": "Llevo un minuto entero intentando decidir si esto me gusta.",
      "why": "La versión pregunta sería: ¿a ti qué te parece? La versión afirmación dice algo de ti primero, lo que les facilita ser sinceros de vuelta."
    },
    {
      "situation": "Un compañero está sacando una comida enorme y complicadísima.",
      "line": "Eso es un nivel de planificación serio para ser martes.",
      "why": "Cálido, observador, y les halaga un poco sin que se note. No hay nada que contestar, que es justo por lo que contestarán."
    },
    {
      "situation": "Los dos estáis atascados al final de una cola lentísima de supermercado.",
      "line": "Elegí esta fila porque parecía más corta. Qué valiente por mi parte.",
      "why": "Burla suave de ti sobre una situación en la que estáis los dos. Les deja elegir entre compadecerse, competir con una historia peor, o simplemente reírse."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Te sientas al lado de alguien en un taller y quieres abrir. ¿Qué frase te sirve más?",
      "options": [
        { "text": "¿Habías venido antes a uno de estos?", "correct": false, "note": "Una pregunta perfectamente válida, pero les pone en el aprieto, no les dice nada de ti, y se contesta con una palabra." },
        { "text": "No tengo ni idea de en qué me acabo de apuntar.", "correct": true, "note": "Revela algo pequeño, es honesto, y les da al menos tres entradas: tranquilizarte, darte la razón, o contar lo suyo." },
        { "text": "¿Qué te ha traído aquí?", "correct": false, "note": "Mejor pregunta que la primera, pero sigue siendo pedir que se abran antes de haber ofrecido nada tú." },
        { "text": "¿Está ocupado este sitio?", "correct": false, "note": "Logística necesaria, no un comienzo. Dilo, y luego abre de verdad." }
      ],
      "explain": "Empieza con una pequeña oferta sobre ti. Las preguntas funcionan mucho mejor cuando ya se ha dado algo."
    },
    {
      "prompt": "¿Qué afirmación le da más material a la otra persona?",
      "options": [
        { "text": "Este sitio está bien.", "correct": false, "note": "Una afirmación, y vacía. No hay nada con lo que estar de acuerdo, discrepar ni continuar." },
        { "text": "Yo ya había estado aquí.", "correct": false, "note": "Un dato sobre ti sin ninguna opinión encima. Invita a un asentimiento educado y a nada más." },
        { "text": "Siempre me siento mal vestido en los sitios con tanto cristal.", "correct": true, "note": "Una opinión, algo autoirónica, concreta. Pueden estar de acuerdo, discrepar, o contarte un local peor." },
        { "text": "Hay más gente de la que esperaba.", "correct": false, "note": "Sirve y es cierto, pero señala la sala en vez de decir nada de ti." }
      ],
      "explain": "Una afirmación funciona cuando lleva un punto de vista. Sin él es solo un hecho dicho en voz alta."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "statement_first", "label": "Abriste con una afirmación", "description": "Empezaste con una observación o algo tuyo en lugar de una pregunta." },
      { "key": "self_revealed", "label": "Diste algo de ti", "description": "El comienzo decía algo pequeño pero real sobre tu propio punto de vista." },
      { "key": "multiple_handles", "label": "Dejaste más de un hilo", "description": "Le diste varias formas posibles de responder en vez de una respuesta estrecha." },
      { "key": "avoided_interview", "label": "No encadenaste preguntas", "description": "Te resististe a seguir con una ráfaga de preguntas más." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Los diez minutos antes de que empiece una clase de cerámica por la tarde. La gente va cogiendo sitio en un banco largo compartido.",
    "partner": {
      "name": "Priya",
      "role": "otra alumna, también aquí por primera vez",
      "personality": "Cálida pero algo tímida. Se abre rápido si la otra persona va primero, se queda callada si no.",
      "mood": "Algo nerviosa y disimulándolo.",
      "openness": 4
    },
    "opening_beat": "Priya se sienta dos sitios más allá, se coloca el delantal con mucho cuidado y mira el trozo de barro que tiene delante sin tocarlo.",
    "success_looks_like": "La persona abre con una afirmación en vez de una pregunta, da algo pequeño de sí misma, y Priya se relaja visiblemente y empieza a ofrecer cosas sin que se las pidan.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Con apertura 4, responde con calidez a cualquier confidencia genuina y ofrece un poco más cada vez que la otra persona lo haga.",
      "Si abre con una pregunta en vez de una afirmación, contesta breve y educada pero no te extiendas. Que se note la diferencia, no la expliques.",
      "Nunca señales lo que debería haber hecho."
    ]
  }$j$::jsonb,
  $md$Hoy, abre una conversación con una afirmación en vez de una pregunta. Ni un signo de interrogación en tu primera frase. Anota qué dijiste y qué te contestaron.$md$,
  $j${
  "says": "Priya se sienta dos sitios más allá, se coloca el delantal con mucho cuidado y mira el trozo de barro que tiene delante sin tocarlo.",
  "model": {
    "line": "He elegido este porque parecía la opción menos peligrosa.",
    "why": "Una afirmación con algo tuyo dentro, y sin signo de interrogación que les obligue a contestar."
  },
  "checks": [
    { "kind": "no_question", "requirement": "Ni un signo de interrogación. Ninguno." },
    { "kind": "max_sentences", "requirement": "Dos frases como mucho", "n": 2 },
    { "kind": "max_words", "requirement": "Menos de veinte palabras", "n": 20 }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('openers', 4,
  'FORD: las cuatro salas',
  $md$Los comienzos de entorno te meten por la puerta. FORD te dice adónde puedes ir después.

Familia, Oficio, Recreo, Deseos. Cuatro territorios sobre los que casi cualquier persona tiene algo que decir. Aquí están ordenados por lo convencionales que son, no por lo buenos que son, y el material bueno suele estar más abajo de la lista de lo que la gente espera.

**La jugada:** date cuenta de en qué sala estás, y recuerda que puedes cambiar de sala.

La mayoría de las conversaciones atascadas lo están en Oficio, porque es la sala por defecto y la más gris. En Recreo la gente se vuelve ella misma. En Deseos — lo que alguien está planeando, ahorrando o esperando — se vuelve interesante, y se llega mucho más fácil de lo que parece. Familia es la más variable: cálida para unos, campo de minas para otros, así que deja que abran ellos esa puerta.$md$,
  $j$[
    {
      "situation": "La conversación lleva varios minutos dando vueltas a su trabajo y se está apagando.",
      "line": "¿Esto es lo que pensabas que acabarías haciendo?",
      "why": "Sigue siendo nominalmente sobre el trabajo, pero se desplaza de Oficio a Deseos. La energía suele cambiar al instante."
    },
    {
      "situation": "Alguien menciona de pasada que está cansado porque se levantó pronto.",
      "line": "¿Pronto por gusto o pronto a la fuerza?",
      "why": "Una entrada suave a Recreo. Si se levantó por algo que le encanta, has encontrado el tema del que hablará encantado diez minutos."
    },
    {
      "situation": "Alguien menciona que se va de viaje el mes que viene.",
      "line": "¿Descanso de verdad o de esos de los que vuelves necesitando vacaciones?",
      "why": "Apunta a Deseos y Recreo sin preguntar nada pesado. Además les da permiso para quejarse, cosa que la gente disfruta más de lo que admite."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Una conversación sobre el trabajo de alguien se ha quedado plana. ¿Qué movimiento la revive con más fiabilidad?",
      "options": [
        { "text": "Preguntar algo más detallado sobre su trabajo.", "correct": false, "note": "Profundizar en una sala que ya está plana suele dejarla más plana todavía." },
        { "text": "Preguntar qué espera estar haciendo dentro de unos años.", "correct": true, "note": "Esto pasa de Oficio a Deseos sin salirse de un hilo que ya sacaron ellos. Cambiar de sala es lo que revive una conversación parada." },
        { "text": "Preguntar por su familia.", "correct": false, "note": "Familia puede ser excelente, pero saltar ahí sin invitación desde una conversación de trabajo plana es un salto grande y algo personal." },
        { "text": "Hablar de tu propio trabajo.", "correct": false, "note": "La reciprocidad vale mucho, pero cambiar quién habla no arregla una sala que se ha quedado sin aire." }
      ],
      "explain": "Cuando una conversación decae, cambia de sala en vez de cavar más hondo en la que estás."
    },
    {
      "prompt": "Alguien menciona que su trayecto al trabajo es de hora y media en cada sentido. ¿A qué sala da eso de forma más natural?",
      "options": [
        { "text": "Oficio, porque va de su trabajo.", "correct": false, "note": "Está pegado al trabajo, y esa es la sala en la que la conversación ya está atascada." },
        { "text": "Familia, porque un trayecto largo suele decir dónde vive.", "correct": false, "note": "Un salto, y hacia la sala que conviene dejar que abran ellos." },
        { "text": "Recreo, porque va de qué hace con su día.", "correct": false, "note": "Más cerca, pero hora y media de tren no es ocio para nadie." },
        { "text": "Deseos, porque nadie piensa hacer eso para siempre.", "correct": true, "note": "La pregunta interesante es qué espera que cambie. Los trayectos largos siempre son temporales en la cabeza de alguien." }
      ],
      "explain": "Cualquier queja sobre un arreglo actual es una puerta a Deseos. Nadie pretende que su peor arreglo sea permanente."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "room_awareness", "label": "Sabías en qué sala estabas", "description": "Seguiste si la conversación estaba en Familia, Oficio, Recreo o Deseos." },
      { "key": "changed_rooms", "label": "Cambiaste de sala al atascarse", "description": "Cambiaste de territorio en vez de apretar más en un tema que decaía." },
      { "key": "used_their_thread", "label": "Te moviste sobre algo que dijeron", "description": "Hiciste el cambio de sala desde un detalle que la otra persona ya había ofrecido." },
      { "key": "left_family_to_them", "label": "Dejaste que abrieran Familia", "description": "No entraste en terreno familiar sin invitación." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Un taxi compartido largo y algo incómodo desde la sede de un congreso hasta el hotel. Veinticinco minutos de proximidad inevitable.",
    "partner": {
      "name": "Tom",
      "role": "alguien sénior de una empresa a la que te presentaron una vez",
      "personality": "Educado y profesionalmente cordial. Por defecto habla de trabajo y se quedará ahí indefinidamente si no lo mueven.",
      "mood": "Cansado, algo receloso de la charla ligera, pero no reacio.",
      "openness": 3
    },
    "opening_beat": "Tom pregunta qué te ha parecido la sesión de la tarde y se contesta él mismo con una opinión suave. Se está acomodando en el tema del trabajo.",
    "success_looks_like": "La persona nota que la conversación está atascada en Oficio, la mueve a Recreo o Deseos usando algo que Tom dijo de verdad, y Tom se anima visiblemente.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Por defecto, Oficio. Contesta a las preguntas de trabajo con soltura y vuelve al trabajo si no te mueven.",
      "Si mueven la conversación a Recreo o Deseos por un hilo que sacaste tú, ponte notablemente más cálido y ofrece un detalle real.",
      "Si te preguntan directamente por la familia antes de que la hayas mencionado, contesta breve y neutro y cambia de tema."
    ]
  }$j$::jsonb,
  $md$Lleva hoy una conversación a una sala en la que no estaba: de Oficio a Recreo o a Deseos. Usa como puerta algo que la otra persona dijera de verdad. Anota el movimiento y qué cambió.$md$,
  $j${
  "turns": [
    { "instruction": "Abre en la sala en la que ya estés." },
    { "instruction": "Ahora usa algo que hayan dicho para pasar a otra sala — de Oficio a Recreo, por ejemplo." },
    { "instruction": "Quédate en la sala nueva un turno más en vez de rebotar de vuelta." }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('openers', 5,
  'La frase de después del comienzo',
  $md$Un comienzo es solo una puerta. La mayoría de las conversaciones que mueren no murieron en la primera frase. Murieron en la segunda, cuando quien había abierto no tenía nada preparado y echó mano de otra pregunta nueva.

La regla es sencilla: tu segunda frase tiene que salir de su respuesta, no de tu cabeza.

**La jugada:** coge la palabra más concreta de lo que acaban de decir y ve hacia ella.

Casi siempre hay una palabra que pesa más que las demás: un sitio, un número, un adjetivo un poco raro. Esa palabra es la invitación. Ignorarla y preguntar otra cosa les dice que estabas esperando para hablar en vez de escuchando.$md$,
  $j$[
    {
      "situation": "Abriste sobre el retraso. Te dijeron: ya, llevo aquí desde las seis y media.",
      "line": "Las seis y media es brutal. ¿Qué te sacó de casa tan pronto?",
      "why": "Las seis y media es lo concreto de esa frase. Ir hacia ello demuestra que escuchabas, y abre hacia su día de verdad."
    },
    {
      "situation": "Abriste sobre la comida. Te dijeron: los he hecho yo, pero me entró el pánico con las cantidades.",
      "line": "¿Pánico de cuánto? ¿Demasiado o ni de lejos suficiente?",
      "why": "Pánico es la palabra cargada, y viene ofrecida con algo de autoburla. Ir ahí es más cálido que alabar la comida."
    },
    {
      "situation": "Abriste sobre la clase. Te dijeron: me convenció mi hermana. Lo hace todos los eneros.",
      "line": "Todos los eneros es una costumbre sospechosamente concreta.",
      "why": "Coge el detalle raro en vez del evidente. El evidente sería la hermana; el interesante es el ritual."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Abres con un comentario sobre el local. Te contestan: solo he venido porque mi compañera de piso me dejó tirado a última hora. ¿Cuál es la mejor segunda frase?",
      "options": [
        { "text": "¿Y tú a qué te dedicas?", "correct": false, "note": "Un reinicio completo. Tira todo lo que acaban de ofrecer y empieza la conversación otra vez en frío." },
        { "text": "¿Te dejó tirado? Menudo movimiento a una hora antes.", "correct": true, "note": "Va directo a la palabra cargada, iguala su tono irónico, y les deja contar la historia que estaban claramente listos para contar." },
        { "text": "Qué pena.", "correct": false, "note": "Comprensivo pero terminal. Cierra el hilo en vez de abrirlo, y ahora necesitas una frase entera nueva." },
        { "text": "¿Vives con ella?", "correct": false, "note": "Sí usa un detalle de su respuesta, pero coge el más plano y se convierte en logística." }
      ],
      "explain": "Ve hacia la palabra que más pesa. Suele ser la que lleva emoción, no la que lleva información."
    },
    {
      "prompt": "Te dicen: vengo del dentista, lo que explica el humor que traigo. ¿Cuál es la invitación?",
      "options": [
        { "text": "Humor.", "correct": true, "note": "Han nombrado una emoción y han hecho una broma con ella. Ir ahí te da una persona en vez de una cita médica." },
        { "text": "Dentista.", "correct": false, "note": "El sustantivo evidente, y el menos interesante. Todo el mundo tiene una historia de dentista y nadie quiere oír ninguna." },
        { "text": "Vengo.", "correct": false, "note": "El momento, que es un detalle. Lleva a cuándo en vez de a qué tal fue." },
        { "text": "Explica.", "correct": false, "note": "Un conector, no contenido. No hay nada detrás que recoger." }
      ],
      "explain": "La palabra cargada es casi siempre la que lleva emoción, no la que lleva los datos."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "used_their_words", "label": "Construiste sobre su respuesta", "description": "La segunda frase salió de lo que la otra persona dijo de verdad y no de un tema nuevo." },
      { "key": "picked_the_loaded_word", "label": "Fuiste a por el peso", "description": "Elegiste el detalle que llevaba emoción en vez del más factual." },
      { "key": "matched_tone", "label": "Igualaste su registro", "description": "Respondiste irónico a lo irónico y cálido a lo cálido, en vez de aplanarlo." },
      { "key": "did_not_reset", "label": "No reiniciaste", "description": "Evitaste abandonar el hilo para abrir un tema nuevo en frío." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "El descanso entre dos pases en una noche de música en directo pequeña. Los dos estáis cerca de la barra esperando a que os atiendan.",
    "partner": {
      "name": "Nadia",
      "role": "alguien que ha venido al concierto sola",
      "personality": "Rápida y algo irónica. Generosa con los detalles si le demuestran que la escuchan, callada si no.",
      "mood": "Pasándoselo bien y con ganas de hablar.",
      "openness": 4
    },
    "opening_beat": "Ya habéis intercambiado una frase sobre lo larga que está la cola de la barra. Nadia dice que ha salido solo porque ha terminado esta tarde un trabajo horrible y no podía con la idea de quedarse en casa.",
    "success_looks_like": "La persona recoge la parte cargada de lo que dijo Nadia en vez de reiniciar, y Nadia se abre en una historia de verdad.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Deja exactamente una palabra o detalle claramente cargado en cada respuesta para que lo recojan.",
      "Si van hacia él, recompénsalo con una respuesta real y concreta.",
      "Si lo ignoran y abren un tema nuevo, contesta plano y breve, y deja que la conversación se enfríe un poco."
    ]
  }$j$::jsonb,
  $md$En una conversación de hoy, haz que tu segunda frase salga de su respuesta y no de tu cabeza. Ve a por la palabra que lleve emoción. Anota qué palabra elegiste y adónde llevó.$md$,
  $j${
  "turns": [
    { "instruction": "Abre con cualquier cosa razonable. Este turno no es el que se evalúa." },
    { "instruction": "Ahora coge la palabra más concreta de su respuesta y ve hacia ella. No abras un tema nuevo." }
  ]
}$j$::jsonb);
