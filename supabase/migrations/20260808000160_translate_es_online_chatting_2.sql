-- Spanish: Chatear online, track 2 — Fácil de responder.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Priya" (lessons 1, 4) — established feminine exception name.
-- "Rae" (lessons 2, 3, 5) carries no `sex` field; masculine agreement
-- used by default.

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

select pg_temp.es_lesson('easy-to-reply-to', 1,
  'Una petición',
  $md$Un mensaje que lleva tres preguntas consigue que se responda la más fácil, y las otras dos desaparecen.

Eso no es descuido por parte del lector. Ante tres cosas, alguien que está echando un vistazo en el móvil responde a la que se puede resolver de inmediato, tiene intención de volver al resto, y no lo hace — y ahora tú estás en la posición de perseguir dos cosas mientras parece que ya te han respondido.

**La jugada:** una petición por mensaje. Si hay tres, eso son tres mensajes o una lista numerada.

Numerar funciona de verdad, y merece la pena saber por qué: convierte una masa sin límites en una lista de tareas, y la gente termina las listas de tareas. Tres preguntas sin numerar en un párrafo producen una respuesta; las mismas tres como *1, 2, 3* producen tres, porque la forma le dice a alguien cómo se ve terminarlo.

La versión que hay que evitar es la segunda petición enterrada — un mensaje que es sobre todo de una cosa con otra petición metida en la cuarta frase. Esa no se responde tarde, no se responde en absoluto, y cuando haces seguimiento la respuesta honesta es *perdona, no vi eso*, que es cierta.

Hay un fallo relacionado que merece la pena nombrar: el mensaje sin ninguna petición dentro que esperaba producir una. *Solo quería avisar de que la impresora está rota* es información, y el lector tiene derecho a recibirla como información — si quieres que alguien haga algo al respecto, esa es una frase distinta, y esperar que lo infieran es cómo las cosas no se arreglan.

Si necesitas varias cosas de la misma persona regularmente, agrúpalas. Un mensaje el jueves con cuatro puntos numerados es mucho más fácil de gestionar que cuatro mensajes a lo largo de una semana, y también es mucho más fácil de decir que sí.

Si te quedas con una cosa: una petición, o una lista numerada. Tres preguntas en un párrafo son una pregunta con dos señuelos.$md$,
  $j$[
    {
      "situation": "Tienes tres preguntas para la misma persona.",
      "line": "(numéralas)",
      "why": "Convierte una masa en una lista de tareas, y la gente termina las listas de tareas. Tres preguntas sin numerar producen una respuesta."
    },
    {
      "situation": "Has metido una segunda petición en la cuarta frase.",
      "line": "(esa no se va a responder en absoluto)",
      "why": "Y cuando haces seguimiento, perdona, no vi eso es una respuesta cierta."
    },
    {
      "situation": "Has avisado de que la impresora está rota y esperabas que alguien actuara.",
      "line": "(eso era información, no una petición)",
      "why": "El lector tiene derecho a recibirla como información. Si quieres que se haga algo, esa es una frase distinta."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué funciona numerar?",
      "options": [
        { "text": "Parece organizado.", "correct": false, "note": "Cómo se ve, no qué le hace al comportamiento del lector." },
        { "text": "Muestra que lo has pensado.", "correct": false, "note": "Puede ser, y el efecto está en completarlo, no en la impresión." },
        { "text": "Convierte una masa en una lista de tareas, y la gente termina las listas de tareas.", "correct": true, "note": "La forma le dice a alguien cómo se ve terminarlo — tres preguntas sin numerar consiguen una respuesta, las mismas tres numeradas consiguen tres." },
        { "text": "Hace que cada pregunta sea más corta.", "correct": false, "note": "No necesariamente, y la duración no es lo que hace que se abandonen dos de ellas." }
      ],
      "explain": "Una petición por mensaje, o una lista numerada."
    },
    {
      "prompt": "¿Cuál es el peor sitio para una segunda petición?",
      "options": [
        { "text": "La cuarta frase de un mensaje sobre otra cosa.", "correct": true, "note": "No se responde tarde, no se responde en absoluto — y cuando la persigues, perdona, no vi eso es una respuesta honesta." },
        { "text": "Al final del todo.", "correct": false, "note": "Visible, y al menos tiene posición. La enterrada no tiene ninguna de las dos cosas." },
        { "text": "En un mensaje de seguimiento.", "correct": false, "note": "Eso es un mensaje aparte, que es una de las dos formas recomendadas." },
        { "text": "En el asunto.", "correct": false, "note": "Colocación inusual y al menos se vería." }
      ],
      "explain": "Y un aviso no es una petición. Si quieres que se haga algo, dilo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_ask", "label": "Una petición", "description": "O una lista numerada en vez de un párrafo." },
      { "key": "nothing_buried", "label": "Nada enterrado", "description": "Ninguna petición metida a mitad del mensaje." },
      { "key": "asked_explicitly", "label": "Pidió en vez de avisar", "description": "Dijo qué quería que se hiciera." },
      { "key": "batched", "label": "Agrupó cuando tenía sentido", "description": "Un mensaje con varios puntos en vez de varios mensajes." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una compañera de trabajo",
      "mood": "Desbordada.",
      "openness": 4,
      "personality": "Responde a lo que sea más fácil y más visible, con intención sincera de volver al resto. Completa una lista numerada por entero."
    },
    "setting": "Necesitas tres cosas de la misma compañera: el visto bueno del presupuesto, el nombre del contacto de la impresora, y si el jueves va bien para una llamada.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde solo a la pregunta más fácil si llegan varias en un párrafo, y di que vas a volver a las demás.",
      "Completa una lista numerada por entero y rápido.",
      "Nunca pidas aclaración sobre los otros puntos."
    ],
    "opening_beat": "La ventana de mensajes está abierta.",
    "success_looks_like": "La persona numera las tres o las envía por separado."
  }$j$::jsonb,
  'Hoy, coge un mensaje con varias peticiones dentro y numéralas. Apunta cuántas tenías.',
  $j${
    "says": "(necesitas tres cosas de la misma compañera: el visto bueno del presupuesto, el nombre del contacto de la impresora, y si el jueves va bien para una llamada)",
    "model": {
      "line": "Tres cosas cuando tengas un minuto: 1. ¿Puedes dar el visto bueno al presupuesto? 2. ¿Quién es nuestro contacto en la imprenta? 3. ¿Va bien el jueves a las 3 para una llamada?",
      "why": "Una lista numerada convierte una masa en una lista de tareas, y la gente termina las listas de tareas. Las mismas tres en un párrafo conseguirían que se respondiera la más fácil y se perdieran las otras dos."
    },
    "checks": [
      { "kind": "contains_any", "words": ["1.", "2.", "3.", "uno", "dos", "tres", "primero", "segundo"], "requirement": "Numéralas" },
      { "kind": "forbids_any", "words": ["perdona", "solo", "rápida", "sé que estás liada", "sin prisa", "si tienes ocasión", "odio"], "requirement": "Nada de encogimiento delante" },
      { "kind": "min_words", "n": 18, "requirement": "Las tres peticiones" },
      { "kind": "max_words", "n": 60, "requirement": "Una lista, no un ensayo" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('easy-to-reply-to', 2,
  'La petición primero, el contexto después',
  $md$La gente lee la primera línea y decide si esto es un ahora o un después. Todo lo demás de tu mensaje se juzga después de que esa decisión ya se haya tomado.

**La jugada:** pregunta, y luego explica.

*¿Puedes aprobar la factura? Es la de marzo que se atascó con la imprenta.* Cuatro segundos para responder, y el contexto está ahí para quien lo necesite.

El mismo contenido en el otro orden — tres frases de historia y luego la petición — se lee hasta la mitad, se archiva como complicado, y se gestiona mañana. Nada de ello era más difícil; sencillamente tardó más en averiguarse qué se quería.

Esta es la misma instrucción que la regla de punto-primero en Presentar y está aquí por el mismo motivo: el lector está decidiendo si sigue leyendo, y una petición que llega tarde tiene que sobrevivir a una decisión tomada antes de que apareciera.

El motivo por el que la gente lo hace al revés es comprensible. El contexto se siente necesario — sabes que la factura necesita explicación, y parece injusto preguntar sin darle a alguien el panorama primero. Pero el panorama solo lo necesita alguien que vaya a decir que no o a hacer una pregunta, que es una minoría, y pueden leer la segunda mitad.

Dos formas prácticas. En un chat, la petición es la primera línea y el contexto es la segunda. En un correo, la petición es la primera línea *y* el asunto, porque un asunto que diga *Factura* no le dice nada a nadie mientras que *Aprobación de factura necesaria para el viernes* es un mensaje completo por sí solo.

Y donde el contexto sea genuinamente largo, dilo y ponlo debajo: *¿Puedes aprobar la factura? Contexto abajo si te sirve.* Ese es un mensaje que alguien puede responder sin leer la mitad, que es todo el objetivo.

Si te quedas con una cosa: la primera línea es la petición. El contexto es para la gente que lo necesita, y va a desplazarse.$md$,
  $j$[
    {
      "situation": "Tienes tres frases de contexto y una petición al final.",
      "line": "(dale la vuelta)",
      "why": "La gente lee la primera línea y decide si esto es un ahora o un después, y una petición que llega tarde tiene que sobrevivir a una decisión tomada antes de que apareciera."
    },
    {
      "situation": "El contexto de verdad es largo.",
      "line": "¿Puedes aprobar la factura? Contexto abajo si te sirve.",
      "why": "Se puede responder sin leer la mitad, que es el objetivo. El contexto solo lo necesita alguien a punto de decir que no."
    },
    {
      "situation": "Estás escribiendo el asunto de un correo.",
      "line": "Aprobación de factura necesaria para el viernes.",
      "why": "Un asunto que dice Factura no le dice nada a nadie. Este es un mensaje completo por sí solo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué falla el contexto primero?",
      "options": [
        { "text": "Es aburrido.", "correct": false, "note": "El interés no es la variable — muchos mensajes aburridos se responden en segundos." },
        { "text": "El lector ya ha decidido antes de que aparezca la petición.", "correct": true, "note": "Leen la primera línea y lo archivan como ahora o después, y una petición que llega en la cuarta frase tiene que sobrevivir a una decisión que se tomó sin ella." },
        { "text": "La gente no lee hasta el final.", "correct": false, "note": "Cerca, y lo exagera — a menudo sí leen hasta el final, mañana." },
        { "text": "Parece desorganizado.", "correct": false, "note": "Normalmente parece cuidadoso, que es por lo que la gente reflexiva lo hace." }
      ],
      "explain": "Pregunta, y luego explica. Misma regla que punto-primero en una presentación, por el mismo motivo."
    },
    {
      "prompt": "¿Quién necesita de verdad el contexto?",
      "options": [
        { "text": "Todo el mundo — es lo justo.", "correct": false, "note": "Se siente injusto preguntar sin él, y la mayoría de la gente solo quiere saber qué se quiere." },
        { "text": "Cualquiera que no haya estado siguiendo el tema.", "correct": false, "note": "Algunos de esos van a responder de todas formas sin él, y el resto puede desplazarse." },
        { "text": "Nadie, en su mayoría.", "correct": false, "note": "Algo demasiado fuerte. Hay una minoría real que lo necesita y la respuesta la nombra." },
        { "text": "La minoría a punto de decir que no o de hacer una pregunta.", "correct": true, "note": "Y pueden leer la segunda mitad. Todos los demás han respondido y han seguido adelante." }
      ],
      "explain": "En un correo, la petición va también en el asunto."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "ask_first", "label": "Petición en la primera línea", "description": "Antes de cualquier contexto." },
      { "key": "context_after", "label": "Contexto debajo", "description": "Disponible en vez de obligatorio." },
      { "key": "subject", "label": "Un asunto que dice algo", "description": "En correo, la petición en el asunto." },
      { "key": "answerable", "label": "Respondible sin desplazarse", "description": "Se podía gestionar desde la primera línea." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefe",
      "mood": "Entre reuniones.",
      "openness": 4,
      "personality": "Aprueba cosas en segundos cuando la petición es visible, y deja para la tarde cualquier cosa que necesite lectura."
    },
    "setting": "Necesitas que se apruebe una factura. Hay tres frases de contexto sobre por qué se atascó.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Aprueba de inmediato si la petición está en la primera línea.",
      "Di que lo vas a mirar más tarde si el mensaje abre con contexto.",
      "Nunca preguntes qué se quiere."
    ],
    "opening_beat": "La ventana de mensajes está abierta.",
    "success_looks_like": "La persona empieza con la petición y pone el contexto debajo."
  }$j$::jsonb,
  'Hoy, reescribe un mensaje para que la petición sea la primera línea. Apunta la frase que era la primera antes.',
  $j${
    "says": "(necesitas que se apruebe una factura — es la de marzo que se atascó con la imprenta, y hay bastante contexto)",
    "model": {
      "line": "¿Puedes aprobar la factura de marzo? Es la que se atascó con la imprenta — contexto abajo si lo necesitas.",
      "why": "La petición en la primera línea, para que la pueda responder en cuatro segundos la gente que lo vaya a hacer, y el contexto debajo para la minoría a punto de decir que no."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Pregunta en la primera línea" },
      { "kind": "forbids_any", "words": ["bueno básicamente", "allá en marzo", "recordarás", "como sabes", "hace un tiempo", "la situación es", "déjame explicar"], "requirement": "Nada de contexto antes de la petición" },
      { "kind": "max_words", "n": 45, "requirement": "Respondible desde la primera línea" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('easy-to-reply-to', 3,
  'Haz que responder salga barato',
  $md$Que alguien te responda rápido depende en gran medida de cuánto trabajo es la respuesta, y tú controlas casi todo eso.

**La jugada:** haz la pregunta más barata que te consiga lo que necesitas.

Una pregunta abierta es cara. *¿Qué piensas de los horarios?* le pide a alguien que forme una opinión, la estructure y la escriba, que son diez minutos de trabajo — así que va a la pila de la tarde. *¿Va bien el jueves, o lo muevo a la semana que viene?* son cuatro segundos y produce la misma decisión.

Tres formas de bajar el coste.

**Cierra la pregunta donde valga una respuesta cerrada.** Sí o no, o esto o aquello. Reserva las preguntas abiertas para cuando de verdad quieras el razonamiento de alguien, y espera que esas tarden más.

**Ofrece opciones en vez de pedir una.** *¿Jueves o viernes?* gana a *¿cuándo te viene bien?*, que le entrega a alguien un problema de agenda. Es la misma jugada que proponer un plan concreto en todos los demás temas de esta app, porque es el mismo principio: generar es más difícil que elegir.

**Di qué pasa si no responden.** *Si no sé nada para el jueves voy a asumir que está bien y lo voy a enviar* es enormemente útil — hace que el silencio sea una respuesta válida, lo que significa que el mensaje deja de ser una tarea y pasa a ser una notificación. Úsalo donde el resultado por defecto de verdad te parezca aceptable.

El hábito relacionado es no hacer que alguien haga tu búsqueda. Adjunta el archivo en vez de referirte a él, cita la línea en vez de apuntar al hilo, y di la fecha en vez de *la reunión que comentamos*. Cada búsqueda que dejas en el mensaje es un motivo para responder más tarde.

Si te quedas con una cosa: haz la pregunta más barata que funcione. Estás compitiendo por un hueco en el día de alguien, y el coste es lo que lo decide.$md$,
  $j$[
    {
      "situation": "Quieres saber si el horario está bien.",
      "line": "¿Va bien el jueves, o lo muevo a la semana que viene?",
      "why": "Cuatro segundos y produce la misma decisión. Qué piensas de los horarios son diez minutos de trabajo y va a la pila de la tarde."
    },
    {
      "situation": "Estás a punto de preguntar cuándo les viene bien.",
      "line": "¿Jueves o viernes?",
      "why": "Generar es más difícil que elegir, que es el mismo principio que proponer un plan concreto en todos los demás sitios de esta app."
    },
    {
      "situation": "El resultado por defecto te parecería bien.",
      "line": "Si no sé nada para el jueves voy a asumir que está bien y lo voy a enviar.",
      "why": "Hace que el silencio sea una respuesta válida, que convierte el mensaje de una tarea en una notificación."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué decide lo rápido que te responden?",
      "options": [
        { "text": "Lo importante que es quien lo envía.", "correct": false, "note": "Menos de lo que la gente supone. Los mensajes baratos de gente júnior se responden antes que los caros de gente sénior." },
        { "text": "Lo urgente que es la petición.", "correct": false, "note": "La urgencia ayuda cuando se declara, y una pregunta urgente y cara se sigue aplazando." },
        { "text": "Cuánto trabajo es la respuesta.", "correct": true, "note": "Estás compitiendo por un hueco en el día de alguien, y el coste es lo que lo decide — casi todo lo cual controlas tú." },
        { "text": "Lo bien que los conoces.", "correct": false, "note": "Compra buena voluntad y no un hueco en una tarde ocupada." }
      ],
      "explain": "Haz la pregunta más barata que te consiga lo que necesitas."
    },
    {
      "prompt": "¿Qué hace nombrar el resultado por defecto?",
      "options": [
        { "text": "Les presiona para que respondan.", "correct": false, "note": "Lo contrario — quita la presión, que es por lo que funciona." },
        { "text": "Convierte el mensaje de una tarea en una notificación.", "correct": true, "note": "El silencio se convierte en una respuesta válida, así que ya no necesita un hueco en el día de nadie. Úsalo donde el resultado por defecto de verdad te parezca aceptable." },
        { "text": "Muestra que has pensado con antelación.", "correct": false, "note": "Sí lo muestra, y la impresión no es lo que cambia la tasa de respuesta." },
        { "text": "Te da cobertura si sale mal.", "correct": false, "note": "Un planteamiento defensivo, y usarlo así es cómo la gente anuncia resultados por defecto que no ha aceptado de verdad." }
      ],
      "explain": "Y no hagas que alguien haga tu búsqueda — adjúntalo, cítalo, di la fecha."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "cheap", "label": "Hizo la versión más barata", "description": "Cerró donde valía cerrado." },
      { "key": "options", "label": "Ofreció opciones", "description": "No les pidió que generaran una." },
      { "key": "default", "label": "Nombró un resultado por defecto cuando pudo", "description": "Hizo que el silencio fuera una respuesta válida." },
      { "key": "no_retrieval", "label": "Hizo la búsqueda por ellos", "description": "Adjuntó, citó, y dio fechas." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefe",
      "mood": "Entre reuniones.",
      "openness": 4,
      "personality": "Responde a una pregunta cerrada al instante y aplaza una abierta a la tarde, con intención sincera de pensarla como es debido."
    },
    "setting": "Necesitas saber si se puede mover una reunión. El mensaje obvio es qué piensas de los horarios.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a una pregunta cerrada de inmediato con una decisión.",
      "Di que lo vas a pensar como es debido más tarde si te hacen una pregunta abierta.",
      "Nunca ofrezcas tú una preferencia sin que te la pidan."
    ],
    "opening_beat": "La ventana de mensajes está abierta.",
    "success_looks_like": "La persona hace una pregunta cerrada con opciones dentro."
  }$j$::jsonb,
  'Hoy, convierte una pregunta abierta en una cerrada con dos opciones. Apunta las dos versiones.',
  $j${
    "beats": [
      {
        "situation": "Necesitas saber si se puede mover una reunión a la semana que viene.",
        "prompt": "¿Qué mensaje?",
        "options": [
          { "text": "¿Qué piensas de los horarios?", "correct": false, "note": "Le pide a alguien que forme una opinión, la estructure y la escriba — diez minutos de trabajo, que va a la pila de la tarde." },
          { "text": "¿Cuándo te vendría bien?", "correct": false, "note": "Entrega un problema de agenda. Generar una opción es más difícil que elegir entre dos." },
          { "text": "¿Va bien el jueves, o lo muevo a la semana que viene?", "correct": true, "note": "Cuatro segundos, y produce exactamente la misma decisión. Haz la pregunta más barata que te consiga lo que necesitas." },
          { "text": "¿Te parece bien que mueva la reunión?", "correct": false, "note": "Cerrada, que es bueno, y no dice adónde, así que necesita un segundo intercambio." }
        ]
      },
      {
        "situation": "Estás enviando algo para revisión, y honestamente, si nadie objeta estás contento de seguir adelante.",
        "prompt": "¿Qué añades?",
        "options": [
          { "text": "Dime qué piensas.", "correct": false, "note": "Una petición abierta de respuesta sobre algo que no necesitaba una." },
          { "text": "¿Alguna objeción?", "correct": false, "note": "Mejor — cerrada, y todavía requiere una acción de alguien que no tiene ninguna." },
          { "text": "Sin prisa con esto.", "correct": false, "note": "Se lee como gestiona esto cuando sea, que en una semana llena significa nunca." },
          { "text": "Si no sé nada para el jueves voy a asumir que está bien y lo voy a enviar.", "correct": true, "note": "Hace que el silencio sea una respuesta válida, que convierte el mensaje de una tarea en una notificación. Úsalo donde el resultado por defecto de verdad te parezca aceptable." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('easy-to-reply-to', 4,
  'Sin prisa significa nunca',
  $md$*¡Sin prisa!* se escribe para ser considerado y se lee como una instrucción, y la instrucción es: gestiona esto cuando sea, que en una semana llena significa nunca.

**La jugada:** di cuándo lo necesitas.

*Para el jueves si es posible* no es agresivo. Es el dato que alguien necesita para colocar tu petición en una semana que ya tiene cuarenta cosas dentro — y sin él, la tuya es la única sin posición, que la pone la última.

El motivo por el que la gente lo deja fuera merece la pena nombrarlo, porque es la misma creencia que produce la disculpa. Decir cuándo necesitas algo se siente como hacer una exigencia, como si adjuntar una fecha presumiera sobre el tiempo de alguien. No es así. Un plazo no es una afirmación sobre tu importancia; es un hecho sobre el trabajo, y ocultarlo no te hace más fácil de gestionar, te hace más difícil — ahora tienen que adivinar, y adivinar mal es peor para los dos.

Sé honesto al respecto en las dos direcciones. Si de verdad no es urgente, *sin prisa — en algún momento de la semana que viene está bien* es un plazo real y funciona como es debido, porque igualmente da una posición. Lo que no funciona es *cuando sea* sin nada pegado.

Y si hay un plazo real, di por qué cuando ayude: *el jueves, porque va a imprenta el viernes* convierte una exigencia en una restricción que no le pertenece a ninguno de los dos. Esa es la versión a la que la gente responde más rápido, y también es la versión que consigue una respuesta como es debido cuando la fecha es imposible.

La que hay que evitar por completo es la falsa urgencia — marcar como urgente lo que no lo es, que funciona dos veces y luego devalúa permanentemente todo lo que envías.

Si te quedas con una cosa: dale una posición en su semana. Una petición sin fecha es la que se hace la última, por pequeña que fuera.$md$,
  $j$[
    {
      "situation": "Estás a punto de escribir sin prisa.",
      "line": "(eso se lee como: gestiona esto cuando sea)",
      "why": "En una semana llena, cuando sea significa nunca. La tuya se convierte en la única petición sin posición, que la pone la última."
    },
    {
      "situation": "De verdad no es urgente.",
      "line": "Sin prisa — en algún momento de la semana que viene está bien.",
      "why": "Un plazo real que igualmente da una posición. Lo que no funciona es cuando sea sin nada pegado."
    },
    {
      "situation": "Hay un plazo real.",
      "line": "El jueves, porque va a imprenta el viernes.",
      "why": "Convierte una exigencia en una restricción que no le pertenece a ninguno de los dos, y consigue una respuesta como es debido cuando la fecha es imposible."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué sale mal sin prisa?",
      "options": [
        { "text": "Suena insincero.", "correct": false, "note": "Casi siempre es sincero, y la sinceridad no es lo que determina cuándo se hace." },
        { "text": "Deja tu petición sin posición en su semana.", "correct": true, "note": "Todo lo demás tiene una fecha. La tuya es la única que se puede mover indefinidamente sin consecuencia, que es adonde va." },
        { "text": "La gente se aprovecha de ello.", "correct": false, "note": "Nadie se está aprovechando. Están priorizando, y tú quitaste el dato." },
        { "text": "Señala que la tarea no es importante.", "correct": false, "note": "Cerca, y la importancia no es lo que programa las cosas — la posición sí." }
      ],
      "explain": "Un plazo es un hecho sobre el trabajo, no una afirmación sobre tu importancia."
    },
    {
      "prompt": "¿Qué consigue la respuesta como es debido más rápida?",
      "options": [
        { "text": "Marcarlo como urgente.", "correct": false, "note": "Funciona dos veces, y luego devalúa permanentemente todo lo que envías." },
        { "text": "Una fecha con el motivo pegado.", "correct": true, "note": "El jueves, porque va a imprenta el viernes no le pertenece a ninguno de los dos — y es la versión que consigue una respuesta real cuando la fecha es imposible." },
        { "text": "Preguntarles cuándo podrían hacerlo.", "correct": false, "note": "Entrega un problema de programación, y la respuesta suele ser vaga." },
        { "text": "Disculparte por el plazo.", "correct": false, "note": "El encogimiento del primer bloque, llegando encima de un dato ordinario." }
      ],
      "explain": "Y sin prisa — en algún momento de la semana que viene es un plazo real. Cuando sea no lo es."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "a_date", "label": "Dio una fecha", "description": "Cualquier posición en la semana." },
      { "key": "no_whenever", "label": "Sin cuando sea", "description": "No lo dejó sin colocar." },
      { "key": "reason", "label": "Motivo donde ayudaba", "description": "Hizo la restricción externa." },
      { "key": "honest", "label": "Urgencia honesta", "description": "No la infló." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una compañera de trabajo",
      "mood": "Muy ocupada.",
      "openness": 4,
      "personality": "Programa por fecha. Cualquier cosa sin una va al final de una lista larga, con intención sincera de llegar a ella."
    },
    "setting": "Necesitas que te devuelvan algo para el jueves porque va a imprenta el viernes. Estás a punto de escribir sin prisa.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Comprométete a una hora concreta si se te da una fecha.",
      "Di que vas a intentar llegar a ello si no se te da fecha, y dilo en serio sin hacerlo.",
      "Nunca preguntes para cuándo se necesita."
    ],
    "opening_beat": "La ventana de mensajes está abierta.",
    "success_looks_like": "La persona da una fecha y el motivo."
  }$j$::jsonb,
  'Hoy, ponle una fecha a una petición que normalmente habrías marcado sin prisa. Apunta la fecha que diste.',
  $j${
    "says": "(lo necesitas de vuelta para el jueves porque va a imprenta el viernes — y estabas a punto de escribir sin prisa)",
    "model": {
      "line": "¿Me lo podrías devolver para el jueves? Va a imprenta el viernes.",
      "why": "Una fecha le da a la petición una posición en una semana que ya tiene cuarenta cosas dentro, y el motivo convierte una exigencia en una restricción que no le pertenece a ninguno de los dos."
    },
    "checks": [
      { "kind": "contains_any", "words": ["jueves", "viernes", "lunes", "martes", "miércoles", "mañana", "para el", "esta semana", "la semana que viene"], "requirement": "Dale una fecha" },
      { "kind": "forbids_any", "words": ["sin prisa", "cuando sea", "cuando puedas", "si tienes tiempo", "en algún momento", "sin presión", "perdona"], "requirement": "Sin prisa significa nunca" },
      { "kind": "max_words", "n": 35, "requirement": "Una fecha y un motivo" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('easy-to-reply-to', 5,
  'Escrito para un pasillo',
  $md$Tu mensaje se va a leer en un móvil, con una mano, andando hacia algún sitio. Ese no es el peor caso, es el caso normal, y escribir para ello cambia cómo se ve un buen mensaje.

**La jugada:** escribe de forma que se pueda gestionar desde una pantalla llena, de pie.

Cualquier cosa más larga consigue un *voy a leer esto bien más tarde*, y más tarde tiene una tasa de finalización pobre. Eso no es pereza — un mensaje largo de verdad no se puede responder en un pasillo, así que se aplaza correctamente a un momento que puede que no llegue.

En la práctica, eso significa varias cosas.

**Párrafos cortos, y espacio en blanco.** Un muro de texto se rechaza antes de leerse, y el mismo contenido en tres párrafos cortos no. Nada ha cambiado excepto lo posible que parece.

**Ponlo todo delante, y di si es largo.** Si de verdad necesita quinientas palabras, dilo arriba — *esto es largo, la petición está en la primera línea* — para que alguien pueda responder ahora y leer el resto cuando se siente.

**Un tema por mensaje.** Un mensaje que cubre dos temas no se puede gestionar de una vez, así que espera a un momento en el que se puedan gestionar los dos — que es un momento mucho más raro que cualquiera de los dos por separado.

**Asume que no hay contexto.** No han leído el hilo, no recuerdan la conversación del martes, y tienen otras cuatro cosas pasando. Dos palabras de orientación — *sobre el tema de la imprenta* — no te cuestan nada y les ahorran una búsqueda.

El principio general debajo de todo esto: no estás escribiendo un documento, estás escribiendo algo que tiene que sobrevivir a que lo lea en veinte segundos alguien que está haciendo otra cosa. Casi todos los mensajes que fallan, fallan ahí en vez de en su contenido.

Si te quedas con una cosa: ¿se podría responder esto de pie? Si no, o lo acortas o dices dónde está la petición.$md$,
  $j$[
    {
      "situation": "Has escrito seis párrafos.",
      "line": "(eso se lee bien más tarde)",
      "why": "De verdad no se puede responder en un pasillo, así que se aplaza correctamente a un momento que puede que no llegue."
    },
    {
      "situation": "De verdad necesita quinientas palabras.",
      "line": "Esto es largo — la petición está en la primera línea.",
      "why": "Alguien puede responder ahora y leer el resto cuando se siente, que son dos momentos distintos en vez de uno raro."
    },
    {
      "situation": "Te estás refiriendo a algo del martes.",
      "line": "Sobre el tema de la imprenta —",
      "why": "No han leído el hilo y tienen otras cuatro cosas pasando. Dos palabras de orientación les ahorran una búsqueda."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué se aplaza un mensaje largo?",
      "options": [
        { "text": "La gente es perezosa.", "correct": false, "note": "Están de pie en un pasillo. De verdad no se puede responder desde ahí, así que aplazar es la decisión correcta." },
        { "text": "Parece trabajo.", "correct": false, "note": "La apariencia importa, que es por lo que ayuda el espacio en blanco — y el motivo más profundo es lo que permite la situación." },
        { "text": "No se puede gestionar desde donde están.", "correct": true, "note": "Un móvil, con una mano, andando hacia algún sitio es el caso normal, no el peor, y más tarde tiene una tasa de finalización pobre." },
        { "text": "Se les va a olvidar.", "correct": false, "note": "El resultado, no el mecanismo, y se sigue del aplazamiento." }
      ],
      "explain": "¿Se podría responder esto de pie?"
    },
    {
      "prompt": "¿Por qué un tema por mensaje?",
      "options": [
        { "text": "Es más ordenado.", "correct": false, "note": "El orden no es lo que cambia el tiempo de respuesta." },
        { "text": "Dos temas es el doble de longitud.", "correct": false, "note": "No necesariamente, y la duración es una restricción aparte." },
        { "text": "Espera a un momento en el que se puedan gestionar los dos.", "correct": true, "note": "Que es un momento mucho más raro que cualquiera de los dos por separado — así que un mensaje de dos temas se aplaza por la mitad más difícil de las dos." },
        { "text": "La gente solo recuerda una cosa.", "correct": false, "note": "La memoria no es el problema cuando el mensaje está justo ahí." }
      ],
      "explain": "Y asume que no hay contexto. Dos palabras de orientación no te cuestan nada."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "screenful", "label": "Cabe en una pantalla", "description": "Respondible de pie." },
      { "key": "white_space", "label": "Dividido", "description": "Párrafos cortos en vez de un muro." },
      { "key": "one_subject", "label": "Un tema", "description": "No combinó dos temas." },
      { "key": "orientation", "label": "Dio orientación", "description": "Dos palabras de contexto, sin búsqueda necesaria." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefe, andando ahora mismo entre edificios",
      "mood": "En tránsito.",
      "openness": 4,
      "personality": "Responde a cualquier cosa que se pueda gestionar con una mano y aplaza cualquier cosa que no, con toda la intención de volver a ello."
    },
    "setting": "Has escrito un mensaje de seis párrafos que cubre el tema de la imprenta y el presupuesto del mes que viene, refiriéndote a una conversación del martes.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde de inmediato a cualquier cosa corta, orientada y de un solo tema.",
      "Di que lo vas a leer bien más tarde si es largo o cubre dos cosas.",
      "Nunca vuelvas de verdad a un mensaje aplazado."
    ],
    "opening_beat": "El borrador está en la ventana.",
    "success_looks_like": "La persona lo divide y hace que el primero sea respondible desde un pasillo."
  }$j$::jsonb,
  'Hoy, corta un mensaje para que quepa en una pantalla de móvil. Apunta la longitud de antes y después.',
  $j${
    "beats": [
      {
        "situation": "Seis párrafos que cubren el tema de la imprenta y el presupuesto del mes que viene, refiriéndose a la conversación del martes.",
        "prompt": "¿Cuál es el primer arreglo?",
        "options": [
          { "text": "Redúcelo a tres párrafos.", "correct": false, "note": "Mejor y sigue teniendo dos temas, así que espera a un momento en el que se puedan gestionar los dos — un momento mucho más raro que cualquiera de los dos por separado." },
          { "text": "Divídelo en dos mensajes.", "correct": true, "note": "Un tema cada uno, así que cada uno se puede responder desde un pasillo. Combinados, la mitad más difícil aplaza a la más fácil." },
          { "text": "Añade un resumen arriba.", "correct": false, "note": "Ayuda, y un resumen de dos temas sigue necesitando dos decisiones antes de que se pueda responder nada." },
          { "text": "Envíalo y haz seguimiento en persona.", "correct": false, "note": "Planea alrededor del fallo en vez de arreglarlo, y duplica el trabajo para los dos." }
        ]
      },
      {
        "situation": "Uno de los dos de verdad necesita quinientas palabras.",
        "prompt": "¿Cómo envías ese?",
        "options": [
          { "text": "Rómpelo en párrafos cortos y envíalo tal cual.", "correct": false, "note": "El espacio en blanco ayuda mucho y siguen siendo quinientas palabras que leer antes de que se pueda responder nada." },
          { "text": "Di que es largo y pon la petición en la primera línea.", "correct": true, "note": "Entonces se puede responder ahora y leer bien más tarde — dos momentos disponibles en vez de uno raro." },
          { "text": "Envíalo como documento en su lugar.", "correct": false, "note": "Mueve el mismo problema a un archivo adjunto, que es un paso más antes de que nadie pueda empezar." },
          { "text": "Pide una llamada en su lugar.", "correct": false, "note": "A veces correcto, y si son quinientas palabras de detalle normalmente lo que se quiere es un registro escrito." }
        ]
      }
    ]
  }$j$::jsonb
);
