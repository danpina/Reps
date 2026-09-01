-- Spanish: El trabajo, track 4 — Que se te vea.
--
-- Conventions as migration 121. Notes:
--
-- **The deflection ban had to get longer to get safer.** English forbids bare
-- "fine" and "ok"; the Spanish deflection is "bien", and "bien" is inside
-- "también", "bienvenido" and "bienestar". Somebody answering "how did it go"
-- could easily write "También cogí el traspaso" and fail a check they had
-- passed. So the list bans "todo bien" and "bastante bien" — the actual
-- deflections — and leaves the bare adverb alone.
--
-- **"No downtime" is "sin caída de servicio".** The phrase carries the whole
-- outcome in lesson 2 and appears in four places; a vaguer rendering like "sin
-- incidencias" would have made the model answer stop being checkable, which is
-- the property the lesson is teaching.
--
-- **"Skip-level" is "la jefa de tu jefe".** Spanish has no noun for it, and
-- describing the relationship is what makes the scenario legible anyway.

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

select pg_temp.es_lesson('being-seen', 1,
  'El trabajo no habla solo',
  $md$*El buen trabajo habla por sí solo* se lo cree casi en exclusiva la gente cuyo trabajo no se está oyendo.

El trabajo no habla. Habla la gente, y lo que llega a quien decide es lo que alguien dijera en una sala en la que tú no estabas. Si no dice nada nadie, el resultado no es neutro: el resultado es que un proyecto salió bien y no hay ningún nombre pegado a él.

Esa es la parte en la que merece la pena quedarse, porque casi toda la gente callada está apoyándose en silencio en lo contrario. La teoría no dicha es que hay un libro de cuentas en alguna parte, que se está llevando con exactitud, y que en algún momento se leerá en voz alta. No hay libro de cuentas. Hay un jefe con una memoria imperfecta, un jefe de tu jefe que te ha visto dos veces, y una conversación sobre ascensos que van a tener sobre todo personas que no eres tú.

**La jugada:** trata que se te vea como parte del trabajo, no como su recompensa.

Esto no es una injusticia que te estén haciendo y no hay nadie con quien enfadarse, lo cual al principio decepciona y a la larga libera. Nadie te está reteniendo el mérito. Sencillamente hay una ausencia, y llenar una ausencia no es el trabajo de nadie salvo el tuyo.

Hay otra cosa que sale mal aquí, y es sutil: la gente callada a menudo sí es visible, para la persona equivocada. Tus compañeros directos saben exactamente qué haces, te ven hacerlo. Quien decide no, y las dos cosas se confunden con frecuencia, porque que te aprecien de cerca se parece a que te conozcan.

Si te quedas con una cosa: nadie está llevando la cuenta por ti. Lo que pasa por defecto no es neutro, y ninguna cantidad de buen trabajo cambia eso por sí sola.$md$,
  $j$[
    {
      "situation": "Un proyecto ha salido bien y nadie ha mencionado quién hizo qué.",
      "line": "(lo que pasa por defecto no es neutro)",
      "why": "El resultado es un éxito sin ningún nombre pegado. Eso no es una injusticia, es una ausencia, y llenar ausencias no es el trabajo de nadie salvo el tuyo."
    },
    {
      "situation": "Tu equipo sabe exactamente cuánto haces.",
      "line": "(y quien decide no)",
      "why": "Que te aprecien de cerca se parece a que te conozcan y no es lo mismo. La decisión la toma alguien que te ha visto dos veces."
    },
    {
      "situation": "Estás esperando a que se note en la evaluación.",
      "line": "(no hay libro de cuentas)",
      "why": "Hay un jefe con una memoria imperfecta y una conversación que van a tener sobre todo personas que no eres tú."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué está mal «el buen trabajo habla por sí solo»?",
      "options": [
        { "text": "Porque otra gente se vende mejor.", "correct": false, "note": "Puede que sí, y ese encuadre lo convierte en una competición en la que no querías entrar. El problema existe aunque no haya nadie más en la sala." },
        { "text": "Porque el trabajo no habla: habla la gente.", "correct": true, "note": "Lo que llega a quien decide es lo que alguien dijera en una sala en la que tú no estabas. Si no lo dice nadie, un proyecto salió bien y no hay ningún nombre pegado." },
        { "text": "Porque quien dirige no está prestando atención.", "correct": false, "note": "Casi siempre la está prestando, a unas seis cosas, de las cuales tu trabajo es una. La atención no es lo mismo que un registro." },
        { "text": "Porque «bueno» es subjetivo.", "correct": false, "note": "Un argumento distinto, y esto se sostiene incluso cuando todo el mundo está de acuerdo en que el trabajo fue bueno." }
      ],
      "explain": "No hay libro de cuentas. Hay una persona con una memoria imperfecta y una conversación en la que tú no estás."
    },
    {
      "prompt": "¿Cuál es la versión sutil de este fallo?",
      "options": [
        { "text": "Ser modesto en el momento equivocado.", "correct": false, "note": "Eso es la lección siguiente, y es un síntoma más que el error estructural." },
        { "text": "Hacer un trabajo difícil de describir.", "correct": false, "note": "Lo hace más difícil de describir. Un montón de trabajo fácil de describir se queda sin atribuir del todo." },
        { "text": "Esperar a una evaluación para plantearlo.", "correct": false, "note": "Mal momento, y el error de fondo es creer que había algo contra lo que plantearlo." },
        { "text": "Ser visible para la gente equivocada.", "correct": true, "note": "Tus compañeros te ven trabajar y saben exactamente qué haces. Quien decide te ha visto dos veces, y que te aprecien de cerca se parece a que te conozcan." }
      ],
      "explain": "La gente que puede verte no suele ser la gente que decide."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_ledger", "label": "Dejó de fiarse del libro de cuentas", "description": "Trató la visibilidad como algo que hacer y no como algo debido." },
      { "key": "right_audience", "label": "Apuntó a quien decide", "description": "Notó la diferencia entre que te aprecien de cerca y que te conozcan." },
      { "key": "no_grievance", "label": "No guardó agravio", "description": "Lo trató como una ausencia y no como una injusticia." },
      { "key": "part_of_work", "label": "Lo hizo parte del trabajo", "description": "Lo planificó en vez de esperar." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nadine",
      "role": "la jefa de tu jefe",
      "mood": "Interesada, con veinte minutos.",
      "openness": 4,
      "personality": "Cercana, con curiosidad de verdad, y trabajando con una imagen muy fina de quién hizo qué. Recuerda lo concreto y olvida el entusiasmo general."
    },
    "setting": "Una charla con la jefa de tu jefe a la que te han invitado y que no has tenido nunca. Conoce el trabajo de tu equipo y no, en concreto, el tuyo.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Repregunta con interés real ante cualquier cosa concreta y atribuida.",
      "Pasa con educación de las descripciones generales o a nivel de equipo.",
      "Nunca preguntes qué hizo la persona personalmente."
    ],
    "opening_beat": "«Creo que no hemos hablado nunca en condiciones. ¿En qué has estado trabajando?»",
    "success_looks_like": "La persona pega su propio nombre a un trabajo concreto en vez de describir el del equipo."
  }$j$::jsonb,
  'Hoy, fíjate en un trabajo tuyo del que quien decide no sabe nada. Apunta cuál es y quién tendría que oírlo.',
  $j${
    "beats": [
      {
        "situation": "Un proyecto en el que hiciste casi todo el trabajo ha salido bien. Nadie ha dicho quién hizo qué.",
        "prompt": "¿Qué pasa ahora, si no dices nada?",
        "options": [
          { "text": "Se acaba notando: estas cosas salen.", "correct": false, "note": "No hay ningún mecanismo por el que salgan. Este es el libro de cuentas que no existe." },
          { "text": "Un proyecto salió bien y no hay ningún nombre pegado.", "correct": true, "note": "Lo que pasa por defecto no es neutro. Lo que llega a quien decide es lo que alguien dijera en una sala en la que tú no estabas." },
          { "text": "Tu jefe lo sabe, así que está cubierto.", "correct": false, "note": "Lo sabe a medias, y necesita concreciones para conversaciones a las que no vas a ir. Saberlo a medias pierde contra lo concreto siempre." },
          { "text": "Otra persona se lleva el mérito.", "correct": false, "note": "Normalmente no lo hace nadie. El resultado habitual no es un robo, es una ausencia, y llenar una ausencia no es el trabajo de nadie salvo el tuyo." }
        ]
      },
      {
        "situation": "Tu equipo directo sabe exactamente cuánto haces y lo dice a menudo.",
        "prompt": "¿Qué te dice eso?",
        "options": [
          { "text": "Que tu trabajo es genuinamente bueno.", "correct": false, "note": "Probablemente, y eso no estaba en duda. La pregunta es quién lo sabe." },
          { "text": "Que la voz va a viajar hacia arriba.", "correct": false, "note": "Viaja si alguien la lleva, y casi nunca se le ocurre a nadie." },
          { "text": "Muy poco sobre si lo sabe quien decide.", "correct": true, "note": "Tus compañeros te ven trabajar. La decisión la toma alguien que te ha visto dos veces, y que te aprecien de cerca se parece a que te conozcan." },
          { "text": "Que no te hace falta hacer nada más.", "correct": false, "note": "Esta es la lectura cómoda y es como el buen trabajo se queda invisible durante años." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('being-seen', 2,
  'Nombra el trabajo, no a ti',
  $md$Toda persona callada tiene la misma objeción a todo esto, y es correcta: la gente que se vende es insoportable, y tú no quieres ser una de ellas. Bien. Agárrate a eso: no es remilgo, es buen gusto, y señala exactamente la distinción correcta.

Lo que les hace insoportables es que hablan de *sí mismos*. Su instinto, su brillantez, lo difícil que era, cómo lo salvaron. Todo eso es una afirmación sobre una persona, no se puede verificar, y todo el mundo en la sala lo está descontando en silencio.

**La jugada:** enuncia el trabajo como un hecho, con tu nombre pegado y sin ningún adjetivo sobre ti.

*La migración salió el jueves, sin caída de servicio* es visibilidad completa. No contiene ninguna fanfarronada ni nada que se pueda rebatir, y todo el que lo oye sabe exactamente quién lo hizo y que salió bien. Además es sencillamente verdad, y por eso resulta cómodo decirlo: la incomodidad que siente la gente con venderse es sobre todo la incomodidad de decir algo que no se puede verificar.

La prueba es si se podría discutir. *Hice un trabajo muy a fondo con la migración* invita a *¿ah, sí?*: es una opinión sobre ti. *La migración salió el jueves sin caída de servicio* no invita a nada, porque es un hecho.

Los números y las fechas hacen el trabajo si los tienes, y los resultados llanos si no. *Lleva tres semanas funcionando y no se ha roto nada.* *Dejamos de recibir esos avisos.* Nada de eso es maquillaje y todo eso es visible.

Quita los adjetivos y no queda nada de lo que avergonzarse. Lo que queda es una descripción de lo que pasó, dicha por la persona a la que le pasó, que es lo más corriente del mundo.

Si te quedas con una cosa: di qué pasó, no lo bueno que eras haciéndolo. Los hechos son visibilidad, y no son fanfarronear.$md$,
  $j$[
    {
      "situation": "Te preguntan en qué has estado trabajando.",
      "line": "La migración salió el jueves, sin caída de servicio.",
      "why": "Visibilidad completa sin ningún adjetivo sobre ti dentro. Todo el que lo oye sabe quién lo hizo y que salió bien, y no hay nada que discutir."
    },
    {
      "situation": "Estás a punto de decir que hiciste un trabajo muy a fondo.",
      "line": "(eso invita a un «¿ah, sí?»)",
      "why": "Una opinión sobre ti se puede rebatir, y es lo que hace que venderse resulte incómodo de decir y fácil de descontar."
    },
    {
      "situation": "No tienes números para ello.",
      "line": "Lleva tres semanas funcionando y no se ha roto nada.",
      "why": "Un resultado llano hace el mismo trabajo. Los hechos no tienen que ser cuantitativos, solo comprobables."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hace insoportable a quien se vende?",
      "options": [
        { "text": "Hablar de su trabajo, sin más.", "correct": false, "note": "Esta es la creencia que mantiene invisible el buen trabajo, y es una mala lectura de qué era lo que irritaba." },
        { "text": "Hacerlo demasiado a menudo.", "correct": false, "note": "La frecuencia lo empeora y no es lo que lo hace chirriar de entrada." },
        { "text": "Hacer afirmaciones sobre uno mismo que no se pueden verificar.", "correct": true, "note": "Su instinto, su brillantez, lo difícil que era. Nada de eso se puede comprobar, así que todo el mundo lo descuenta, y eso es de lo que te estás apartando." },
        { "text": "Llevarse el mérito del trabajo de otros.", "correct": false, "note": "Una falta aparte y peor. Un montón de gente que se vende hace su propio trabajo y sigue cansando." }
      ],
      "explain": "La objeción es correcta y señala el arreglo: quita los adjetivos sobre ti."
    },
    {
      "prompt": "¿Cuál es la prueba de una frase que lleva tu trabajo?",
      "options": [
        { "text": "Si suena humilde.", "correct": false, "note": "La humildad no es el objetivo, y apuntar a ella produce el escaqueo del que va la lección siguiente." },
        { "text": "Si se podría discutir.", "correct": true, "note": "«La migración salió el jueves sin caída de servicio» no invita a nada, porque es un hecho. «Hice un trabajo a fondo» invita a un «¿ah, sí?»." },
        { "text": "Si incluye un número.", "correct": false, "note": "Los números ayudan y no hacen falta. «Lleva tres semanas funcionando y no se ha roto nada» hace el mismo trabajo." },
        { "text": "Si tu jefe ya lo sabe.", "correct": false, "note": "Normalmente lo sabe a medias, que es el motivo para decirlo y no un motivo para callarlo." }
      ],
      "explain": "Si se pudiera rebatir, es una opinión sobre ti. Si no, es visibilidad."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "factual", "label": "Enunció un hecho", "description": "Dijo qué pasó en vez de lo bien que se hizo." },
      { "key": "attached", "label": "Pegó su nombre", "description": "Dejó claro de quién era el trabajo." },
      { "key": "no_adjectives", "label": "Sin adjetivos sobre sí mismo", "description": "Dejó fuera las afirmaciones que solo se pueden aceptar por fe." },
      { "key": "short", "label": "Lo dejó en una frase", "description": "No construyó un caso." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nadine",
      "role": "la jefa de tu jefe",
      "mood": "Con curiosidad, veinte minutos.",
      "openness": 4,
      "personality": "Recuerda lo concreto y olvida el entusiasmo. Repregunta como es debido ante cualquier cosa concreta y pasa de cualquier cosa general."
    },
    "setting": "Una charla con la jefa de tu jefe. Pasaste seis semanas en una migración de base de datos que salió el jueves pasado sin incidentes, y casi nadie se dio cuenta precisamente porque salió bien.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Repregunta con interés ante cualquier cosa concreta y comprobable.",
      "Responde brevemente y pasa de largo ante los adjetivos y las afirmaciones generales.",
      "Nunca hagas una pregunta aclaratoria sobre quién hizo qué."
    ],
    "opening_beat": "«¿Y en qué has estado trabajando?»",
    "success_looks_like": "La persona enuncia el trabajo como un hecho comprobable con su nombre pegado."
  }$j$::jsonb,
  'Hoy, describe una cosa que hiciste como un hecho, sin ningún adjetivo sobre ti dentro. Apunta la frase.',
  $j${
    "says": "¿Y en qué has estado trabajando?",
    "model": {
      "line": "Pasé la base de datos a la nueva; salió el jueves sin caída de servicio.",
      "why": "Un hecho con un nombre pegado y sin ningún adjetivo sobre quien lo dice. No hay nada dentro que discutir, que es exactamente por lo que resulta cómodo decirlo."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Pégale tu nombre" },
      { "kind": "forbids_any", "words": ["a fondo", "mucho trabajo", "muy orgulloso", "orgullosa", "brillante", "gran trabajo", "difícil", "estresante", "a tope", "currazo"], "requirement": "Sin adjetivos sobre ti" },
      { "kind": "min_words", "n": 8, "requirement": "Di qué pasó de verdad" },
      { "kind": "max_words", "n": 30, "requirement": "Una frase, no un caso" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('being-seen', 3,
  'El mensaje que lo hace por ti',
  $md$Si hablar de tu trabajo es la versión difícil, esta es la fácil, y es la costumbre con más apalancamiento de todo este tema para alguien callado.

**La jugada:** un mensaje corto por escrito, con un ritmo, enumerando lo que ha pasado de verdad.

Tres o cuatro líneas, una vez por semana o cada dos, a tu jefe. No un informe y no una reunión de estado en texto: una lista de cosas que ahora son verdad. *La migración salió el jueves, sin caída de servicio. He cogido el traspaso de Henderson. Los informes van bien para el día 20.*

Por qué gana a hablar, si hablar no es tu fuerte: lo puedes redactar, lo puedes editar, no te está mirando nadie mientras lo haces, y cuesta cuatro minutos. Además llega a una hora que le conviene, lo que significa que se lee en vez de aguantarse.

Pero el motivo por el que es de verdad la mejor herramienta aquí es lo que hace cuando tú no estás en la sala. Tu jefe necesita material para conversaciones a las que no vas a ir nunca: una ronda de ascensos, una discusión de plantilla, alguien de arriba preguntando quién es bueno. Quien tiene una carpeta con tus mensajes tiene concreciones. Quien no la tiene tiene una impresión, y las impresiones pierden contra lo concreto siempre.

Se acumula de una forma en que no lo hace nada más. Seis meses de mensajes son un caso que no has tenido que construir, escrito cuando cada cosa estaba fresca y era fácil de describir, en el momento exacto en el que más vas a desear tener uno.

Dos reglas. Que sea aburrido: hechos, no encuadre, y ningún adjetivo sobre ti. Y que sea lo bastante corto como para que lo hagas de verdad, porque un mensaje que te saltas tres semanas no vale nada y un mensaje que te da pereza es un mensaje que te saltas.

Si te quedas con una cosa: escribe las cuatro líneas. Es el acto menos social de toda esta app y hace más que casi todos los valientes.$md$,
  $j$[
    {
      "situation": "Es viernes y la semana está hecha.",
      "line": "La migración salió el jueves, sin caída de servicio. He cogido el traspaso de Henderson. Los informes van bien para el día 20.",
      "why": "Tres hechos, cuatro minutos, ningún adjetivo. Llega cuando le conviene y se convierte en material para salas en las que no vas a estar nunca."
    },
    {
      "situation": "Estás redactando algo más largo y mejor.",
      "line": "(déjalo en cuatro líneas o vas a dejar de hacerlo)",
      "why": "Un mensaje que te da pereza es un mensaje que te saltas, y una costumbre saltada tres semanas no vale absolutamente nada."
    },
    {
      "situation": "Viene una ronda de ascensos y no tienes ningún caso.",
      "line": "(seis meses de mensajes eran el caso)",
      "why": "Escrito cuando cada cosa estaba fresca y era fácil de describir, por alguien que no sabía que lo iba a necesitar. No hay nada más que se acumule así."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué es mejor un mensaje escrito que decirlo?",
      "options": [
        { "text": "Porque es un registro.", "correct": false, "note": "Cerca, y ser un registro solo sirve por quién lo lee y cuándo." },
        { "text": "Porque tu jefe prefiere lo escrito.", "correct": false, "note": "Unos sí y otros no, y funciona en cualquier caso." },
        { "text": "Porque funciona en salas en las que tú no estás.", "correct": true, "note": "Tu jefe necesita material para una ronda de ascensos o para alguien de arriba preguntando quién es bueno. Quien tiene tus mensajes tiene concreciones; sin ellos tiene una impresión." },
        { "text": "Porque evita la conversación.", "correct": false, "note": "La evita, y eso es un extra en vez del motivo. Esta gana a hablar por sus propios méritos." }
      ],
      "explain": "Es un suministro de concreciones para conversaciones a las que no vas a ir nunca."
    },
    {
      "prompt": "¿Cuál es la forma más común de que falle esta costumbre?",
      "options": [
        { "text": "No lo lee nadie.", "correct": false, "note": "Normalmente sí lo leen, e incluso sin leer es un registro con fecha que puedes buscar más adelante." },
        { "text": "Parece que estás presumiendo.", "correct": false, "note": "No si es aburrido, que es la instrucción. Los hechos se leen como hechos." },
        { "text": "Se te olvida lo que pasó.", "correct": false, "note": "El ritmo existe para resolver justo eso, y por eso semanal gana a mensual." },
        { "text": "Se hace largo, y entonces te lo saltas.", "correct": true, "note": "Un mensaje que te da pereza es un mensaje que te saltas, y tres semanas saltadas terminan la costumbre. Lo bastante corto como para hacerlo gana a bueno." }
      ],
      "explain": "Cuatro líneas, aburridas, con un ritmo. Lo que lo mata es la longitud."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "sent", "label": "Lo mandó de verdad", "description": "Escribió y mandó en vez de redactar algo mejor más tarde." },
      { "key": "facts", "label": "Solo hechos", "description": "Enumeró lo que ahora es verdad, sin ningún encuadre." },
      { "key": "short", "label": "Lo mantuvo corto", "description": "Lo bastante corto como para repetirlo la semana que viene." },
      { "key": "rhythm", "label": "Le puso un ritmo", "description": "Lo convirtió en costumbre y no en algo suelto." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa",
      "mood": "Final de semana, vaciando la bandeja de entrada.",
      "openness": 4,
      "personality": "Lee los mensajes cortos al momento y hojea los largos. Recuerda cualquier cosa concreta y con fecha."
    },
    "setting": "Viernes por la tarde. Has hecho tres cosas esta semana que merecen anotarse y no le has mandado nunca a tu jefa un mensaje así.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con brevedad y calidez a un mensaje corto y factual.",
      "Responde con un vistazo por encima y una pregunta a cualquier cosa larga o con encuadre.",
      "Nunca pidas tú un informe de estado."
    ],
    "opening_beat": "La caja de mensaje está abierta y la semana está hecha.",
    "success_looks_like": "La persona escribe tres o cuatro líneas factuales y las manda."
  }$j$::jsonb,
  'Hoy, manda un mensaje corto enumerando lo que ahora es verdad. Tres o cuatro líneas, sin adjetivos. Apunta qué mandaste.',
  $j${
    "says": "Viernes por la tarde. La caja de mensaje está abierta, y esta semana has terminado la migración, has cogido el traspaso de Henderson, y has mantenido los informes en fecha para el día 20.",
    "model": {
      "line": "Nota rápida de la semana: la migración salió el jueves, sin caída de servicio. He cogido el traspaso de Henderson. Los informes van en fecha para el día 20.",
      "why": "Hechos, con fecha, cuatro líneas, sin encuadre. Cuesta cuatro minutos y se convierte en el material que usa tu jefa en salas en las que no vas a estar nunca."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["semana ocupada", "a tope", "mucho trabajo", "orgulloso", "solo quería", "espero que no", "perdona", "de locos", "una locura"], "requirement": "Aburrido: hechos, no encuadre" },
      { "kind": "min_words", "n": 12, "requirement": "Más de una cosa" },
      { "kind": "max_words", "n": 55, "requirement": "Lo bastante corto como para volver a hacerlo la semana que viene" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('being-seen', 4,
  'Cuando preguntan qué tal fue',
  $md$*¿Qué tal fue?* es la pregunta que más se desperdicia en el trabajo, y la desperdicia la persona a la que se la hacen.

Los reflejos son todos escaqueos y todos parecen buena educación. *Ah, bien.* *Fue trabajo de equipo.* *La verdad es que se hizo casi solo.* Cada uno de esos devuelve una oportunidad que se estaba ofreciendo: alguien pidió que le contaran, y no le contaron nada.

**La jugada:** responde con el resultado, en una frase, y luego para.

*Salió el jueves, sin caída de servicio.* Eso no es inmodestia. Es la respuesta a la pregunta, y es lo que dice sin pensárselo dos veces todo el que no eres tú.

El escaqueo del trabajo en equipo merece atención aparte, porque es el más común y el que parece más virtuoso. Además suele ser una forma de evitar la incomodidad de que te den el mérito, y el coste no lo pagas solo tú. Alguien preguntó quién hizo esto; la respuesta que recibe es nadie en particular. Eso no es generoso con tu equipo, es vago sobre todos vosotros.

Si quieres darle mérito a la gente, nómbrala. *Priya hizo la parte difícil del plan de vuelta atrás, yo hice la migración* es concreto, generoso y completo, y hace todo lo que intentaba hacer el escaqueo sin borrar a nadie.

Y luego para. El instinto después de decir lo bueno es rebajarlo de inmediato — *tampoco era tan complicado, la verdad* — lo que borra la frase que acabas de decir y se oye como exacto y no como modesto. Di el resultado, deja que se quede ahí, y deja que hagan la siguiente pregunta.

Si te quedas con una cosa: responde a la pregunta. Alguien pidió que le contaran, y *bien* no es una respuesta, es una negativa.$md$,
  $j$[
    {
      "situation": "«¿Qué tal fue la migración?»",
      "line": "Salió el jueves, sin caída de servicio.",
      "why": "La respuesta de verdad a la pregunta de verdad, en una frase. Es lo que dice sin dudar todo el que no eres tú."
    },
    {
      "situation": "Estás a punto de decir que fue trabajo de equipo.",
      "line": "Priya hizo la parte difícil del plan de vuelta atrás, yo hice la migración.",
      "why": "Concreto y generoso, y hace todo lo que intentaba hacer el escaqueo sin dejar la respuesta en nadie en particular."
    },
    {
      "situation": "Has dicho lo bueno y hay un silencio pequeño.",
      "line": "(no lo rebajes)",
      "why": "«Tampoco era tan complicado» borra la frase que acabas de decir, y se oye como exacto y no como modesto."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué es un problema «fue trabajo de equipo»?",
      "options": [
        { "text": "No es verdad.", "correct": false, "note": "Normalmente sí lo es, que es lo que lo convierte en un sitio tan cómodo donde esconderse." },
        { "text": "Suena poco sincero.", "correct": false, "note": "Suena elegante, que es precisamente por lo que no se le cuestiona." },
        { "text": "Te infravalora.", "correct": false, "note": "Cierto, y es solo la mitad de lo que está mal: la otra mitad es lo que le hace a todos los demás." },
        { "text": "Alguien preguntó quién hizo esto y la respuesta es nadie en particular.", "correct": true, "note": "No es generoso con tu equipo, es vago sobre todos vosotros. Nombrar a la gente es la versión que sí le da mérito." }
      ],
      "explain": "Si quieres repartir el mérito, di nombres. La vaguedad no le da mérito a nadie."
    },
    {
      "prompt": "Ya has dicho el resultado. ¿Y ahora?",
      "options": [
        { "text": "Parar.", "correct": true, "note": "El instinto es rebajarlo de inmediato, y «tampoco era tan complicado» borra la frase que acabas de decir. Deja que se quede y deja que pregunten." },
        { "text": "Añadir el contexto para no exagerarlo.", "correct": false, "note": "Eso es rebajarlo con mejores modales. Si hiciera falta contexto, lo preguntarían." },
        { "text": "Mencionar lo que salió mal, para equilibrar.", "correct": false, "note": "Nadie pidió equilibrio. Ofrecer el fracaso junto al éxito es una forma de disculparse por el éxito." },
        { "text": "Preguntar por su trabajo.", "correct": false, "note": "Una escapatoria educada, y cierra el tema antes de que haya aterrizado nada." }
      ],
      "explain": "Di el resultado y deja que el silencio sea suyo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "answered", "label": "Respondió a la pregunta", "description": "Dio el resultado en vez de un escaqueo." },
      { "key": "named", "label": "Nombró a la gente si les daba mérito", "description": "Evitó el vago «trabajo de equipo»." },
      { "key": "stopped", "label": "Paró", "description": "No lo rebajó después." },
      { "key": "one_sentence", "label": "Una frase", "description": "No lo convirtió en un relato." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nadine",
      "role": "la jefa de tu jefe",
      "mood": "De paso, veinte segundos.",
      "openness": 4,
      "personality": "Pregunta con brevedad y de verdad, y se toma al pie de la letra la respuesta que reciba. Recuerda un resultado concreto y olvida un escaqueo al instante."
    },
    "setting": "La cocina. La jefa de tu jefe pasa por delante la mañana después de que la migración saliera limpia.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Acepta cualquier respuesta al pie de la letra y no hurgues.",
      "Responde con calidez y de forma concreta ante un resultado de verdad.",
      "Pasa de largo de inmediato después de un escaqueo, como si no se hubiera dicho nada."
    ],
    "opening_beat": "«Ah, la migración. ¿Qué tal fue?»",
    "success_looks_like": "La persona da el resultado en una frase sin escaquearse y sin rebajarlo."
  }$j$::jsonb,
  'Hoy, responde a un «¿qué tal fue?» con el resultado y luego deja de hablar. Apunta qué dijiste.',
  $j${
    "says": "Ah, la migración. ¿Qué tal fue?",
    "model": {
      "line": "Salió el jueves, sin caída de servicio.",
      "why": "La respuesta a la pregunta, en una frase, sin nada detrás. Alguien pidió que le contaran, y «bien» habría sido una negativa."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["trabajo de equipo", "todo bien", "bastante bien", "no fue para tanto", "se hizo solo", "nada especial", "suerte", "tampoco era"], "requirement": "Sin escaqueo, y sin rebajarlo después" },
      { "kind": "min_words", "n": 5, "requirement": "Da el resultado de verdad" },
      { "kind": "max_sentences", "n": 1, "requirement": "Una frase, y para" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('being-seen', 5,
  'El mérito no es una tarta',
  $md$Debajo de la reticencia suele haber una creencia económica: que el mérito es una cantidad fija, y que llevarse una parte significa quitársela a otra persona.

No funciona así. Nombrar tu parte no elimina la de nadie más, y nombrar la de otra persona no elimina la tuya: sencillamente son hechos distintos, y los dos pueden ser verdad en una misma frase. *Priya hizo el plan de vuelta atrás, yo hice la migración* no os cuesta nada a ninguno de los dos.

**La jugada:** nombra el trabajo de los demás en voz alta, con concreción, y sigue nombrando el tuyo.

Hacerlo por otra gente es lo más barato de todo este tema. Cuesta cuatro palabras en una reunión, es imposible hacerlo mal, y te convierte en alguien de quien los demás hablan bien, lo cual importa, porque las conversaciones que deciden cosas ocurren sin ti, y lo que se dice ahí lo dice gente que o se acuerda de ti o no.

Hay una versión de esto que es una maniobra y merece la pena evitarla: dar mérito para que te vean dando mérito. La diferencia se ve y va de exactitud: di qué hizo esa persona de verdad, en concreto. *Priya estuvo genial* es un cumplido. *Priya cazó lo que habría tirado la web* es un hecho, y solo uno de los dos le sirve a Priya en una sala en la que ella no está.

La reciprocidad es real y no es el motivo. Hazlo porque una descripción concreta del trabajo de alguien es lo más útil que puedes decir de esa persona y no te cuesta absolutamente nada. Que además haga que la gente se incline a hacer lo mismo por ti es una consecuencia, no una estrategia, y tratarlo como estrategia es exactamente lo que hace que deje de funcionar.

Si te quedas con una cosa: tu nombre y el de otra persona caben en la misma frase. No se está dividiendo nada.$md$,
  $j$[
    {
      "situation": "Quieres darle mérito a Priya sin desaparecer tú.",
      "line": "Priya hizo el plan de vuelta atrás, yo hice la migración.",
      "why": "Dos hechos en una frase, los dos verdad, ninguno quitándole nada al otro. El mérito no es una cantidad que se reparta."
    },
    {
      "situation": "Estás a punto de decir que Priya estuvo genial.",
      "line": "Priya cazó lo que habría tirado la web.",
      "why": "Un cumplido es agradable y una concreción es útil: es lo que alguien puede repetir en una sala en la que Priya no está."
    },
    {
      "situation": "Estás dando mérito en parte para que te vuelva a ti.",
      "line": "(eso se nota, y es lo que hace que deje de funcionar)",
      "why": "La reciprocidad es real y no es el motivo. Hazlo porque una descripción concreta del trabajo de alguien no cuesta nada y es lo más útil que puedes decir."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la creencia que hay debajo de la reticencia?",
      "options": [
        { "text": "Que nadie quiere oírlo.", "correct": false, "note": "Relacionada y menos concreta. Normalmente alguien lo ha preguntado, que es como surgen estos momentos." },
        { "text": "Que el mérito es fijo, así que llevarse una parte se la quita a los demás.", "correct": true, "note": "No es una cantidad. Tu parte y la de otra persona son hechos distintos y los dos caben en una frase sin que ninguno encoja." },
        { "text": "Que se va a ver como arrogancia.", "correct": false, "note": "El miedo de superficie, y se responde quitando los adjetivos. Este es la creencia que hay debajo." },
        { "text": "Que el trabajo no era tan bueno.", "correct": false, "note": "A veces está presente, y es un problema distinto con un arreglo distinto." }
      ],
      "explain": "No se está dividiendo nada. Dos hechos, una frase."
    },
    {
      "prompt": "¿Qué separa el mérito de verdad de la maniobra?",
      "options": [
        { "text": "Hacerlo en privado.", "correct": false, "note": "El mérito en privado es amable y no hace casi nada. La cuestión es que se diga donde se pueda repetir." },
        { "text": "No mencionarte a ti en absoluto.", "correct": false, "note": "Eso es el escaqueo otra vez, y deja la respuesta en nadie en particular." },
        { "text": "La concreción.", "correct": true, "note": "«Priya estuvo genial» es un cumplido. «Priya cazó lo que habría tirado la web» es un hecho que alguien puede repetir en una sala en la que ella no está." },
        { "text": "Hacerlo a menudo.", "correct": false, "note": "La frecuencia sin exactitud es justo lo que hace que se lea como una maniobra." }
      ],
      "explain": "Di qué hizo esa persona de verdad. El elogio vago no ayuda a nadie y se lee como técnica."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "both", "label": "Nombró las dos partes", "description": "Le dio mérito a otra persona sin borrar el suyo." },
      { "key": "specific", "label": "Fue concreto", "description": "Dijo qué hizo esa persona de verdad en vez de elogiarla en general." },
      { "key": "genuine", "label": "Lo decía en serio", "description": "Dio mérito por exactitud y no por efecto." },
      { "key": "public", "label": "Lo dijo donde cuenta", "description": "Lo dijo en un sitio donde se podía repetir." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa",
      "mood": "Contenta, tomando notas.",
      "openness": 4,
      "personality": "Repite hacia arriba lo concreto y olvida el elogio general. Se fija en quién nombra a quién."
    },
    "setting": "Una revisión de equipo de la migración. Tu jefa acaba de decir que salió bien y ha preguntado qué marcó la diferencia.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Apunta y repite en voz alta cualquier cosa concreta sobre quién hizo qué.",
      "Responde con un asentimiento y nada más al elogio general o a una respuesta de «trabajo de equipo».",
      "Nunca preguntes qué aportó personalmente la persona."
    ],
    "opening_beat": "«Salió mejor de lo que esperaba, la verdad. ¿Qué marcó la diferencia?»",
    "success_looks_like": "La persona nombra con concreción lo que aportó otra persona y lo suyo propio al lado."
  }$j$::jsonb,
  'Hoy, di en voz alta qué hizo exactamente otra persona, en un sitio donde se pueda repetir. Apunta qué dijiste.',
  $j${
    "beats": [
      {
        "situation": "«Salió mejor de lo que esperaba. ¿Qué marcó la diferencia?» Priya cazó un problema en la vuelta atrás que habría tirado la web; tú hiciste la migración.",
        "prompt": "¿Qué dices?",
        "options": [
          { "text": "La verdad es que fue trabajo de equipo.", "correct": false, "note": "Alguien preguntó quién hizo esto y la respuesta es nadie en particular. Eso es vago sobre todos vosotros en vez de generoso con ninguno." },
          { "text": "Priya estuvo genial con eso.", "correct": false, "note": "Un cumplido en vez de un hecho, y no es algo que nadie pueda repetir de forma útil en una sala en la que Priya no está." },
          { "text": "Yo hice la migración. Priya ayudó.", "correct": false, "note": "Lo tuyo es concreto y lo de ella se ha reducido a «ayudó», que es la versión del mérito que sí le quita algo a alguien." },
          { "text": "Priya cazó el problema de la vuelta atrás, eso fue lo que lo salvó. Yo hice la migración en sí.", "correct": true, "note": "Dos hechos, los dos concretos, ninguno encogiendo al otro. No se está dividiendo nada." }
        ]
      },
      {
        "situation": "Te das cuenta de que estás a punto de darle mérito a alguien en parte porque va a quedar bien.",
        "prompt": "¿Importa eso?",
        "options": [
          { "text": "Sí, y el arreglo es ser exacto en vez de callarse.", "correct": true, "note": "La maniobra se nota, y se nota como vaguedad. Decir exactamente qué hizo alguien es la versión que le sirve a esa persona y que no puede leerse como técnica." },
          { "text": "No: el efecto en esa persona es el mismo de todas formas.", "correct": false, "note": "No lo es. El mérito dado por efecto tiende a ser general, y el mérito general no hace nada por quien lo recibe." },
          { "text": "Sí, así que mejor no decir nada que hacerlo por el motivo equivocado.", "correct": false, "note": "Una pureza que le cuesta a otra persona su mérito. El motivo se puede arreglar; el silencio no le sirve a nadie." },
          { "text": "No: todo el mundo lo hace por ese motivo.", "correct": false, "note": "Alguna gente sí, y es exactamente por lo que el elogio vago ha dejado de tener ningún peso." }
        ]
      }
    ]
  }$j$::jsonb
);
