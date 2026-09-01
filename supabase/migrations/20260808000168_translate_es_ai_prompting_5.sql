-- Spanish: Escribir prompts a la IA, track 5 — No conoce la sala.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Sam" (lessons 1, 2, 4) — unisex/no-sex-field, masculine
-- default. "Nadia" (lessons 3, 5) — established feminine exception.

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

select pg_temp.es_lesson('it-does-not-know-the-room', 1,
  'No preguntes qué significa un mensaje',
  $md$Pega una respuesta corta y pregunta qué quisieron decir con ella, y vas a conseguir una respuesta. Va a ser detallada, va a ser plausible, y va a estar construida exactamente sobre la nada que le diste.

**La jugada:** no preguntes qué significa un mensaje. Nunca.

El tercer bloque de Mensajería tiene el problema subyacente: en un hueco, se construye una historia sin evidencia, y como nada de ella es comprobable, nada de ella tiene límite. Esto es eso, con un cambio — la historia ahora tiene un coautor confiado y llega pareciendo un análisis.

Eso es peor de tres formas concretas.

Es más detallada que la que habrías construido solo, y el detalle se siente como evidencia.

Es externa, así que se lee como una segunda opinión. No lo es. Es tu propio material devuelto con estructura añadida.

Y no se va a negar. Pregúntale a un amigo qué quiso decir tu compañera con *ok, bien* y te dice *ni idea, pregúntale*. Pregúntale a esto y consigues cuatro posibilidades ordenadas por probabilidad, ninguna de las cuales es *estaba en un tren*.

El mecanismo es sencillo una vez que lo ves. No hay información sobre una persona en tres palabras de texto. Lo que sea que vuelva se generó a partir de la forma general de esos mensajes, y la forma general de *ok, bien* es que significa ok, bien — pero tú no preguntaste qué significa normalmente, preguntaste qué quiso decir *ella*, y esa pregunta no tiene respuesta disponible para nada que nunca la haya conocido.

Dos preguntas para usar en su lugar, ambas sobre el texto en vez de sobre la persona. *¿Cómo se podría leer esta frase?* — un hecho sobre el lenguaje, y fiable. *¿Cuál es la explicación más aburrida para esto?* — que es útil precisamente porque es la explicación que te saltaste.

Y cuando genuinamente no puedas saberlo, Mensajería ya te dio la respuesta: pregúntales.

Si te quedas con una cosa: puede leer tu mensaje. Nunca ha conocido a la persona que lo envió.$md$,
  $j$[
    {
      "situation": "Una respuesta seca y quieres saber qué significaba.",
      "line": "(no preguntes — no hay nada en tres palabras)",
      "why": "Lo que sea que vuelva se generó a partir de la forma de esos mensajes, y tú preguntaste qué quiso decir ella."
    },
    {
      "situation": "Quieres una segunda opinión al respecto.",
      "line": "(no lo es)",
      "why": "Es tu propio material devuelto con estructura añadida, y la estructura se siente como evidencia."
    },
    {
      "situation": "Sigues sin poder saberlo.",
      "line": "¿Cuál es la explicación más aburrida para esto?",
      "why": "La aburrida es la explicación que te saltaste, y acierta la inmensa mayoría de las veces."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué es esto peor que construir la teoría tú mismo?",
      "options": [
        { "text": "Es más probable que se equivoque.", "correct": false, "note": "No necesariamente — ambas son suposiciones. Lo que difiere es cuánta autoridad lleva la suposición." },
        { "text": "Se lee como una segunda opinión cuando no lo es.", "correct": true, "note": "Detallada, externa, estructurada. Las tres hacen que tu propio material se sienta como evidencia." },
        { "text": "Tarda más.", "correct": false, "note": "Tarda segundos, que es parte de por qué se pregunta." },
        { "text": "Recuerda lo que dijiste.", "correct": false, "note": "Un efecto real en un hilo largo, y no lo que hace dañina esta pregunta concreta." }
      ],
      "explain": "Puede leer tu mensaje. Nunca ha conocido a la persona que lo envió."
    },
    {
      "prompt": "¿Qué diría un amigo que esto no dirá?",
      "options": [
        { "text": "Que le estás dando demasiadas vueltas.", "correct": false, "note": "Un amigo podría, y esto también si lo preguntas directamente. No es la diferencia estructural." },
        { "text": "Que el mensaje está bien.", "correct": false, "note": "Eso lo dice con facilidad. El consuelo es lo que suministra más fácilmente." },
        { "text": "Que deberías preguntarle a ella.", "correct": false, "note": "A menudo sí que sugiere esto, normalmente después de cuatro párrafos de análisis." },
        { "text": "Ni idea.", "correct": true, "note": "No se va a negar. Consigues posibilidades ordenadas por probabilidad, y ninguna de ellas es que estaba en un tren." }
      ],
      "explain": "Pregunta cómo se podría leer una frase. Esa va sobre el lenguaje."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "did_not_ask", "label": "No preguntó qué significaba", "description": "Mantuvo la pregunta alejada de la persona." },
      { "key": "text_question", "label": "Preguntó sobre el texto en su lugar", "description": "Cómo se podría leer esto." },
      { "key": "boring", "label": "Se quedó con la explicación aburrida", "description": "Trenes, reuniones, una mano ocupada." },
      { "key": "asked_them", "label": "Preguntó a la persona si hacía falta", "description": "Fue a la fuente, no al análisis." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo con el que estás hablando de esto",
      "mood": "Sereno.",
      "openness": 5,
      "personality": "Pregunta cómo podría saber eso cualquier cosa, y cuál sería la explicación aburrida."
    },
    "setting": "Tienes una respuesta de dos palabras de una compañera y acabas de pasar diez minutos leyendo un análisis de ella.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta con qué evidencia se construyó la teoría.",
      "Acepta no lo sé como respuesta completa.",
      "Nunca ofrezcas una interpretación del mensaje."
    ],
    "opening_beat": "«¿Cómo iba a saber eso qué quiso decir ella?»",
    "success_looks_like": "La persona abandona el análisis y se queda con la explicación aburrida."
  }$j$::jsonb,
  'Hoy, date cuenta de un mensaje que estabas a punto de hacer interpretar. Apunta la teoría y la versión aburrida.',
  $j${
    "says": "¿Cómo iba a saber eso qué quiso decir ella?",
    "model": {
      "line": "No lo sabría. Ella envió dos palabras desde un tren y yo he construido el resto.",
      "why": "No hay información sobre una persona en tres palabras de texto, así que lo que sea que vuelva es tu propio material con estructura añadida."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["pero dijo", "tiene sentido aun así", "explicó que", "probablemente tenga razón", "cuatro posibilidades", "ordenó"], "requirement": "No defiendas la teoría" },
      { "kind": "min_words", "n": 10, "requirement": "Di de dónde vino la teoría" },
      { "kind": "max_words", "n": 32, "requirement": "Abandónala, no la defiendas" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('it-does-not-know-the-room', 2,
  'Está de acuerdo con tu enfoque',
  $md$Describe a una compañera como irrazonable y vas a conseguir consejos reflexivos y prácticos sobre cómo manejar a una compañera irrazonable. Nada en la respuesta va a cuestionar si lo es.

**La jugada:** escribe la situación desde su lado y pregunta otra vez.

Esta es la comprobación individual más útil del tema, porque es barata y el resultado es inequívoco. Los mismos hechos, contados desde donde están ellos parados, con sus razones dadas como ellos las darían. Si el consejo se invierte, lo que recibiste la primera vez fue tu enfoque devuelto con estructura añadida.

Importa más de lo que suena, porque el enfoque es normalmente donde está el error. No en el plan, que generalmente está bien dadas las premisas — en las premisas. *Ha estado ignorando mis mensajes* y *todavía no ha respondido* describen los mismos tres días, producen consejos completamente distintos, y solo uno de ellos es un hecho.

Algunos enfoques que sobreviven a ser cuestionados y merece la pena detectar:

*Lo hizo a propósito.* Casi siempre una inferencia. Reescríbelo como qué hizo.

*Sabe cómo me siento al respecto.* Con frecuencia no lo sabe, porque nadie lo dijo.

*Esta es la tercera vez.* A veces exactamente correcto y estructural, y merece la pena comprobar que las dos primeras eran lo mismo en vez de tres cosas que has ido coleccionando.

*Todos los demás también lo piensan.* Ocasionalmente cierto. Normalmente una conversación con una persona que estaba siendo complaciente.

El motivo por el que esta es una lección sobre la IA en vez de una lección sobre pensar es que un amigo interrumpe. Un amigo dice *espera, ¿de verdad los ha ignorado?* — y esa interrupción, que es levemente molesta y extremadamente útil, no existe aquí. Nada va a cuestionar tu versión sin que se lo pidas. Tienes que hacer tú la comprobación, deliberadamente, cada vez que importe.

Si te quedas con una cosa: nunca va a cuestionar tu versión. Escríbela desde su lado y mira si el consejo sobrevive.$md$,
  $j$[
    {
      "situation": "Has descrito a alguien como irrazonable.",
      "line": "(ahora escríbelo desde su lado y pregunta otra vez)",
      "why": "Si el consejo se invierte, lo que tenías era tu enfoque devuelto con estructura añadida."
    },
    {
      "situation": "Ha estado ignorando mis mensajes.",
      "line": "Todavía no ha respondido.",
      "why": "Los mismos tres días. Consejo completamente distinto, y solo uno de ellos es un hecho."
    },
    {
      "situation": "Esperas que te cuestione.",
      "line": "(un amigo interrumpe — esto no)",
      "why": "Nada va a cuestionar tu versión sin que se lo pidas, así que la comprobación hay que hacerla deliberadamente."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué te dice la prueba de inversión?",
      "options": [
        { "text": "Qué versión de los hechos es verdadera.", "correct": false, "note": "Eso no lo puede resolver. Muestra cuánto dependía el consejo de tu relato." },
        { "text": "Si estás siendo injusto.", "correct": false, "note": "Cerca, y la injusticia es un juicio — la prueba solo muestra una dependencia." },
        { "text": "Que el consejo se construyó sobre tu enfoque.", "correct": true, "note": "Los mismos hechos desde donde están ellos parados. Si el consejo se invierte, la primera respuesta eran tus premisas con estructura añadida." },
        { "text": "Cómo va a reaccionar la otra persona.", "correct": false, "note": "Incognoscible, y es el error de la lección anterior con otro disfraz." }
      ],
      "explain": "El error normalmente está en las premisas, no en el plan."
    },
    {
      "prompt": "¿Qué enfoque es con más frecuencia una inferencia disfrazada de hecho?",
      "options": [
        { "text": "Esta es la tercera vez.", "correct": false, "note": "A menudo contable, y merece la pena comprobar que las tres eran lo mismo." },
        { "text": "Lo hizo a propósito.", "correct": true, "note": "Casi siempre inferido. Reescríbelo como qué hizo realmente y el consejo cambia." },
        { "text": "Pregunté dos veces.", "correct": false, "note": "Normalmente comprobable en tus propios mensajes enviados." },
        { "text": "Llegó tarde.", "correct": false, "note": "Un hecho, y uno de los pocos en la mayoría de los relatos." }
      ],
      "explain": "También merece la pena dudar de: sabe cómo me siento, y todos los demás también lo piensan."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "flipped", "label": "Hizo la prueba de inversión", "description": "Lo escribió desde su lado." },
      { "key": "facts", "label": "Separó el hecho de la inferencia", "description": "Ignoró frente a todavía no ha respondido." },
      { "key": "noticed", "label": "Notó el cambio en el consejo", "description": "Vio qué dependía del enfoque." },
      { "key": "no_confirmation", "label": "No fue en busca de confirmación", "description": "No lo volvió a contar hasta que estuvo de acuerdo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo con el que estás hablando de esto",
      "mood": "Ecuánime.",
      "openness": 5,
      "personality": "Pregunta cómo contaría la otra persona la misma historia."
    },
    "setting": "Has descrito una situación con detalle y has recibido un consejo con el que estás totalmente de acuerdo.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pide la versión de los mismos hechos de la otra persona.",
      "No te pongas de ningún lado.",
      "Nunca digas quién tiene razón."
    ],
    "opening_beat": "«¿Cómo lo contaría él?»",
    "success_looks_like": "La persona cuenta el otro lado y nota qué cambia."
  }$j$::jsonb,
  'Hoy, vuelve a contar una situación desde el otro lado y pregunta otra vez. Apunta si el consejo cambió.',
  $j${
    "says": "¿Cómo lo contaría él?",
    "model": {
      "line": "Él diría que todavía no ha respondido porque ha estado en talleres toda la semana, y que yo nunca dije que fuera urgente.",
      "why": "Los mismos tres días. Ignorando mis mensajes y todavía no ha respondido producen consejos completamente distintos, y solo uno de ellos es un hecho."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["diría que tenía razón pero", "está equivocado", "obviamente eso no es verdad", "alegaría que", "fingiría que", "excusa"], "requirement": "Cuéntalo desde su lado, no desde el tuyo" },
      { "kind": "min_words", "n": 12, "requirement": "Da su versión real" },
      { "kind": "max_words", "n": 40, "requirement": "Su versión, brevemente" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('it-does-not-know-the-room', 3,
  'No conoce tu registro',
  $md$La voz por defecto es corporativa estadounidense cálida. La apertura entusiasta, el reconocimiento de lo ocupados que están todos, el cierre con ganas de seguir en contacto. Es un registro real, usado con sinceridad por mucha gente, y en la mayoría de las salas resulta levemente absurdo.

**La jugada:** di adónde va esto, o tradúcelo después.

No tiene forma de saber que nadie en tu oficina dice *contactar*, que tu equipo se comunica en fragmentos sin saludo, que tu industria considera poco serios los signos de exclamación, o que en tu idioma el tratamiento formal sigue siendo estándar con alguien a quien conoces desde hace dos años. Todo eso es conocimiento local, y va a producir un valor por defecto confiado en su ausencia.

Qué decir de entrada: dónde estás, cómo es la cultura, cómo se escribe la gente de verdad entre sí, y un ejemplo si tienes uno. Un solo mensaje pegado del mismo contexto hace más que tres frases de descripción — es el mismo principio del primer bloque, aplicado al tono.

Qué eliminar después, ya que vuelve de todos modos:

**Saludos y despedidas que nadie usa.** En muchos trabajos el mensaje simplemente empieza.

**Entusiasmo sin causa.** Encantado, emocionado, entusiasmado. Si no pasó nada emocionante, se lee como automático.

**Suavizado apilado sobre suavizado.** *Solo quería comprobar rápidamente si podría ser posible.* Cuatro muletillas seguidas, que Mensajería elimina.

**Desajuste de formalidad en cualquier dirección.** Demasiado rígido para un amigo, demasiado casual para un casero — y se equivoca hacia lo cálido, así que la rigidez normalmente aparece en tu propio idioma en vez de en inglés.

La escritura en un idioma que no sea el inglés merece su propia nota. Generalmente es competente y generalmente más formal de lo que sería un hablante nativo de tu edad, y el desajuste es lo bastante sutil como para sobrevivir a una lectura rápida. Di explícitamente el registro que quieres, y comprueba tú mismo los pronombres y el saludo.

Si te quedas con una cosa: el registro por defecto pertenece a una sala en la que probablemente no estás. Di dónde estás, o arréglalo después.$md$,
  $j$[
    {
      "situation": "Ha producido una apertura cálida y una despedida.",
      "line": "(aquí nadie usa ninguna de las dos)",
      "why": "En muchos trabajos el mensaje simplemente empieza, y el saludo lo marca como escrito por otra persona."
    },
    {
      "situation": "Quieres el tono correcto a la primera.",
      "line": "Aquí hay un mensaje del mismo contexto — iguala esto.",
      "why": "Un ejemplo pegado hace más que tres frases de descripción, exactamente como en el bloque uno."
    },
    {
      "situation": "Estás escribiendo en tu propio idioma.",
      "line": "(comprueba tú mismo la formalidad y los pronombres)",
      "why": "Se equivoca hacia lo formal, y el desajuste es lo bastante sutil como para sobrevivir a una lectura rápida."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la forma más rápida de acertar con el registro?",
      "options": [
        { "text": "Describe la cultura de tu oficina.", "correct": false, "note": "Mejor que nada, y las descripciones de tono son difíciles de escribir y fáciles de malinterpretar." },
        { "text": "Pide que sea menos formal.", "correct": false, "note": "Un dial tosco. Inglés menos formal no es lo mismo que cómo escribe tu equipo." },
        { "text": "Arréglalo tú mismo después.", "correct": false, "note": "Necesario de todos modos, y hacerlo primero cuesta menos." },
        { "text": "Pega un mensaje real del mismo contexto.", "correct": true, "note": "Un ejemplo hace más que tres frases de descripción — el principio del primer bloque, aplicado al tono." }
      ],
      "explain": "El registro por defecto pertenece a una sala en la que probablemente no estás."
    },
    {
      "prompt": "¿Hacia dónde se equivoca en tu propio idioma?",
      "options": [
        { "text": "Hacia la formalidad.", "correct": true, "note": "Más formal de lo que sería un hablante nativo de tu edad, y lo bastante sutil como para sobrevivir a una lectura rápida. Comprueba tú mismo el saludo y los pronombres." },
        { "text": "Hacia la jerga.", "correct": false, "note": "Raramente, y tiende a ser conservador más que casual." },
        { "text": "Iguala lo que sea que escribieras.", "correct": false, "note": "Toma prestado algo de tu registro y deriva de vuelta al suyo." },
        { "text": "Varía de forma impredecible.", "correct": false, "note": "El sesgo es lo bastante constante como para corregirlo, que es por lo que merece la pena nombrarlo." }
      ],
      "explain": "Di explícitamente el registro que quieres."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "example", "label": "Dio un ejemplo real", "description": "Pegó un mensaje del mismo contexto." },
      { "key": "stripped", "label": "Eliminó lo que nadie usa", "description": "Saludos, despedidas, entusiasmo sin causa." },
      { "key": "hedges", "label": "Eliminó el suavizado apilado", "description": "Sin cuatro muletillas seguidas." },
      { "key": "language", "label": "Comprobó la formalidad en su idioma", "description": "Saludo y pronombres verificados." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nadia",
      "role": "una compañera en el escritorio de al lado",
      "mood": "Divertida.",
      "openness": 5,
      "personality": "Lo lee en voz alta sin inflexión y pregunta si alguien en el edificio escribe así."
    },
    "setting": "Estás a punto de enviar un mensaje que abre esperando que esto le encuentre bien, a alguien que se sienta a tu lado.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Lee la línea de apertura en voz alta sin inflexión.",
      "Di cómo lo habrías escrito en tres palabras, si te lo preguntan directamente.",
      "Nunca reescribas el mensaje entero."
    ],
    "opening_beat": "«¿Alguien aquí escribe de verdad así?»",
    "success_looks_like": "La persona reduce el registro a lo que usa su sala."
  }$j$::jsonb,
  'Hoy, reduce un mensaje al registro que tu sala usa de verdad. Apunta qué salió.',
  $j${
    "beats": [
      {
        "situation": "El mensaje abre esperando que esto te encuentre bien, a alguien sentado a metro y medio.",
        "prompt": "¿Cuál es el arreglo?",
        "options": [
          { "text": "Pide que sea menos formal.", "correct": false, "note": "Un dial tosco. Inglés menos formal sigue sin ser cómo escribe tu equipo." },
          { "text": "Pega un mensaje real del mismo contexto y di iguala esto.", "correct": true, "note": "Un ejemplo hace más que tres frases de descripción — el principio del primer bloque, aplicado al tono." },
          { "text": "Describe la cultura de tu oficina en detalle.", "correct": false, "note": "Mejor que nada, y las descripciones de tono son difíciles de escribir y fáciles de malinterpretar." },
          { "text": "Escríbelo tú mismo y sáltate la ayuda.", "correct": false, "note": "Sobrecorrección. Las ediciones mecánicas siguen mereciendo la pena." }
        ]
      },
      {
        "situation": "Estás escribiendo en tu propio idioma en vez de en inglés.",
        "prompt": "¿Qué compruebas a mano?",
        "options": [
          { "text": "Que el vocabulario no sea demasiado avanzado.", "correct": false, "note": "Rara vez es el fallo, y el vocabulario avanzado es fácil de detectar cuando pasa." },
          { "text": "Que no haya traducido palabra por palabra.", "correct": false, "note": "Generalmente no lo hace. La fluidez no es el punto débil." },
          { "text": "Nada — es competente en la mayoría de los idiomas.", "correct": false, "note": "Competente y sistemáticamente más formal de lo que serías tú, que es la trampa." },
          { "text": "La formalidad y los pronombres.", "correct": true, "note": "Se equivoca hacia lo formal, y el desajuste es lo bastante sutil como para sobrevivir a una lectura rápida." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('it-does-not-know-the-room', 4,
  'No te va a decir que no lo envíes',
  $md$Pregunta si deberías enviar algo, y vas a conseguir ayuda para enviarlo. Posiblemente una sugerencia de suavizar el tercer párrafo. Casi nunca *no envíes esto*, y esencialmente nunca *esta conversación no merece la pena tenerla*.

**La jugada:** quédate tú con la pregunta de si hacerlo.

Hay dos preguntas en cada mensaje difícil, y se colapsan en una. *¿Cómo digo esto bien?* es una pregunta sobre texto y tiene respuesta. *¿Debería decir esto siquiera?* es una pregunta sobre tu vida — sobre si la amistad sobrevive a ello, si esta es la colina en la que morir, si te va a importar dentro de un mes. Nada que nunca haya conocido a nadie implicado puede responder la segunda, y no se va a negar a intentarlo.

Peor aún, tiene un sesgo estructural hacia la acción. Llegaste con un borrador. El borrador implica una intención. Ayudarte es lo que hace. Así que todo el aparato se inclina hacia *sí, y así es cómo* — que es exactamente la inclinación equivocada a las once de la noche, cuando la última lección de Mensajería dice que lo que más quieres es enviarlo.

Tres preguntas que te pertenecen a ti, y merece la pena conocerlas por su nombre.

**¿Debería decirse esto siquiera?**

**¿Debería decirse ahora?** A menudo la pregunta real, y casi siempre se responde mejor mañana.

**¿Debería decirlo yo?** A veces genuinamente le toca decirlo a otra persona.

Lo único que puedes preguntar de forma útil, y con cuidado en la formulación: *hazme el argumento más fuerte en contra de enviar esto.* Va a obedecer, porque es una tarea en vez de un juicio. Lee el argumento, y luego decide tú. Eso no es lo mismo que pedir permiso, y la diferencia es toda la lección.

Y cuando de verdad te entregue una reescritura de algo que no deberías enviar, date cuenta de qué ha pasado: ahora tienes una versión mejor de una mala idea, que es más peligrosa que el primer borrador, porque el primer borrador se veía como lo que era.

Si te quedas con una cosa: responde al cómo, nunca al si. El si es tuyo.$md$,
  $j$[
    {
      "situation": "Preguntas si deberías enviarlo.",
      "line": "(vas a conseguir ayuda para enviarlo)",
      "why": "Llegaste con un borrador y el borrador implica una intención. El aparato se inclina hacia sí, y así es cómo."
    },
    {
      "situation": "Quieres el argumento en contra.",
      "line": "Hazme el argumento más fuerte en contra de enviar esto.",
      "why": "Obedece, porque eso es una tarea en vez de un juicio. Luego decides tú."
    },
    {
      "situation": "Te ha entregado una versión pulida de algo que no deberías enviar.",
      "line": "(eso es más peligroso que el borrador)",
      "why": "El primer borrador se veía como lo que era. Este no."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué se inclina hacia enviar?",
      "options": [
        { "text": "No puede saber que un mensaje es mala idea.", "correct": false, "note": "A menudo sí puede, y aun así ayudará — el sesgo no trata de la percepción." },
        { "text": "Está entrenado para ser alentador.", "correct": false, "note": "Parte de ello, y demasiado vago para ser el mecanismo." },
        { "text": "Llegaste con un borrador, y ayudar es lo que hace.", "correct": true, "note": "El borrador implica la intención, y todo el aparato se inclina hacia sí, y así es cómo." },
        { "text": "Asume que ya has decidido.", "correct": false, "note": "Cerca, y ayudaría igual de dispuesto con un borrador que describieras como mala idea." }
      ],
      "explain": "Responde al cómo. El si es tuyo."
    },
    {
      "prompt": "¿Qué es seguro preguntar?",
      "options": [
        { "text": "¿Tú enviarías esto?", "correct": false, "note": "Un juicio disfrazado de pregunta, y va a encontrar la forma de ser alentador." },
        { "text": "¿Es esto buena idea?", "correct": false, "note": "La pregunta del si con otro verbo." },
        { "text": "¿Estoy reaccionando de forma exagerada?", "correct": false, "note": "Tiene un lado de la historia y ninguna forma de sopesarlo. Te va a tranquilizar." },
        { "text": "Hazme el argumento más fuerte en contra de enviarlo.", "correct": true, "note": "Una tarea en vez de un juicio, así que obedece correctamente. Lee el argumento y decide tú." }
      ],
      "explain": "Y la pregunta real a menudo es si debería decirse ahora, que se responde mejor mañana."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "kept_whether", "label": "Se quedó con la decisión", "description": "No pidió permiso." },
      { "key": "case_against", "label": "Pidió el argumento en contra", "description": "Una tarea, no un veredicto." },
      { "key": "timing", "label": "Consideró ahora frente a mañana", "description": "Separó las dos preguntas." },
      { "key": "noticed_polish", "label": "Notó una mala idea pulida", "description": "No confundió la fluidez con una decisión." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo al que le escribes en su lugar",
      "mood": "También despierto hasta muy tarde.",
      "openness": 5,
      "personality": "Pregunta cuál sería el argumento en contra de enviarlo, y quién está decidiendo."
    },
    "setting": "Las once de la noche. Tienes un mensaje bien escrito que no estás seguro de si deberías enviar siquiera.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta cuál sería el argumento en contra.",
      "Niégate a decir si deberían enviarlo.",
      "Nunca comentes lo bien escrito que está."
    ],
    "opening_beat": "«¿Quién decidió que ibas a enviar esto?»",
    "success_looks_like": "La persona reconoce que la decisión es suya y la toma."
  }$j$::jsonb,
  'Hoy, pide el argumento en contra de enviar un mensaje, y luego decide tú. Apunta el argumento y tu decisión.',
  $j${
    "says": "¿Quién decidió que ibas a enviar esto?",
    "model": {
      "line": "Yo, a las once de la noche. Voy a pedirle el argumento en contra y luego voy a decidir por la mañana.",
      "why": "Llegaste con un borrador, el borrador implica la intención, y ayudar es lo que hace. La pregunta del si es tuya."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["dijo que estaba bien", "pensó que debería", "no puso objeción", "lo aprobó", "dice que se lee bien", "me dijo que"], "requirement": "No entregues la decisión" },
      { "kind": "min_words", "n": 10, "requirement": "Di quién decide y cuándo" },
      { "kind": "max_words", "n": 35, "requirement": "Una decisión, brevemente" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('it-does-not-know-the-room', 5,
  'En qué acierta de forma fiable',
  $md$Cuatro lecciones de advertencias te dejarían con una herramienta a la que le tienes miedo de usar, que es el resultado equivocado. Hay una línea clara, y el lado útil de ella es grande.

**La jugada:** confía en ello sobre el texto, y para en el punto donde empieza una persona.

Fiable, porque estas son propiedades de las palabras que tiene delante:

**Cómo se podría leer una frase.** La ambigüedad está en la frase. No requiere conocer al lector.

**Si la petición es localizable.** Lee la primera línea y di qué se quiere — un hecho sobre el texto, y la prueba que decide si un mensaje se responde hoy.

**Si es demasiado largo para lo que hace.** Es un buen juez de la proporción.

**Qué se te está pidiendo** en un documento que alguien te ha enviado. Comprensión de texto, que es distinto de qué quisieron decir al enviarlo.

**Si dos frases se contradicen entre sí**, y si lo que prometiste en el primer párrafo sobrevive hasta el cuarto.

**Qué falta estructuralmente** — sin fecha, sin nombre, sin próximo paso, sin forma de decir que no.

No fiable, porque estos son hechos sobre personas que nunca ha conocido:

Qué piensan de ti. Si están molestos. Qué significa el silencio. Cómo va a caer el tono en esa sala en concreto. Si van a decir que sí. Si lo decían en serio. Si la amistad sobrevive a esto.

La línea es memorable en una frase: *puede leer tu mensaje, y nunca los ha conocido.* Todo en la primera lista es leer. Todo en la segunda es conocer.

Hay un caso intermedio que merece la pena nombrar, porque es donde la gente resbala. *¿Cómo se tomaría esto un lector que no me conociera?* tiene respuesta — es una pregunta sobre texto, formulada como una pregunta sobre personas. *¿Cómo se tomaría esto Ana?* no la tiene, y las dos están a una palabra de distancia. Si aparece un nombre real en tu pregunta, has cruzado la línea.

Si te quedas con una cosa: si la pregunta tiene un nombre dentro, te toca responderla a ti.$md$,
  $j$[
    {
      "situation": "No estás seguro de cómo cala una frase.",
      "line": "¿Cómo se podría leer esto?",
      "why": "La ambigüedad está en la frase. No necesita ningún conocimiento del lector."
    },
    {
      "situation": "Alguien te ha enviado cuatro páginas.",
      "line": "¿Qué se me está pidiendo aquí?",
      "why": "Comprensión de texto, que es distinto de qué quisieron decir al enviarlo."
    },
    {
      "situation": "Tu pregunta tiene un nombre real dentro.",
      "line": "(entonces te toca responderla a ti)",
      "why": "Cómo se tomaría esto un lector va sobre texto. Cómo se lo tomaría Ana va sobre una persona que nunca ha conocido."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué separa la lista fiable de la no fiable?",
      "options": [
        { "text": "Leer frente a conocer.", "correct": true, "note": "Puede leer tu mensaje y nunca los ha conocido. Todo lo fiable es una propiedad de las palabras que tiene delante." },
        { "text": "Hechos frente a opiniones.", "correct": false, "note": "Qué se podría malinterpretar es un juicio sobre el lenguaje, y está en el lado fiable." },
        { "text": "Preguntas simples frente a complejas.", "correct": false, "note": "Comprender cuatro páginas es complejo y fiable. Leer tres palabras es simple y no lo es." },
        { "text": "Material escrito frente a hablado.", "correct": false, "note": "Todo aquí está escrito. El mensaje pegado es texto de cualquier forma." }
      ],
      "explain": "Confía en ello sobre el texto, y para donde empieza una persona."
    },
    {
      "prompt": "¿Cuál de estas todavía tiene respuesta?",
      "options": [
        { "text": "Si Ana se va a molestar.", "correct": false, "note": "Un nombre en la pregunta. Nunca la ha conocido." },
        { "text": "Cómo se lo tomaría un lector que no te conociera.", "correct": true, "note": "Una pregunta sobre texto disfrazada de pregunta sobre personas. Tiene respuesta, y está a una palabra de distancia de la versión que no la tiene." },
        { "text": "Qué significa el silencio.", "correct": false, "note": "La primera lección de este bloque. No hay nada en un hueco." },
        { "text": "Si van a decir que sí.", "correct": false, "note": "Una predicción sobre una persona, entregada con confianza y sin ningún valor." }
      ],
      "explain": "Si la pregunta tiene un nombre dentro, te toca responderla a ti."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "used_it", "label": "Usó el lado fiable", "description": "Ambigüedad, petición localizable, proporción." },
      { "key": "stopped", "label": "Se detuvo en la persona", "description": "Sin preguntas sobre qué piensan." },
      { "key": "name_test", "label": "Aplicó la prueba del nombre", "description": "Un nombre en la pregunta significa que es tuya." },
      { "key": "not_afraid", "label": "No lo evitó por completo", "description": "El lado útil es grande." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nadia",
      "role": "una compañera en el escritorio de al lado",
      "mood": "Directa.",
      "openness": 5,
      "personality": "Responde cualquier cosa sobre la redacción y se niega a responder cualquier cosa sobre qué va a pensar alguien."
    },
    "setting": "Tienes un mensaje que enviar y dos preguntas al respecto, una de las cuales tiene un nombre dentro.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a las preguntas sobre el texto con llaneza.",
      "Rechaza las preguntas sobre qué va a pensar una persona nombrada.",
      "Nunca especules sobre el estado de ánimo de nadie."
    ],
    "opening_beat": "«Puedo decirte qué dice. No puedo decirte qué va a pensar ella de ello.»",
    "success_looks_like": "La persona clasifica sus preguntas en las dos pilas y solo hace la que tiene respuesta."
  }$j$::jsonb,
  'Hoy, clasifica tus preguntas sobre un mensaje en texto y personas. Apunta cuáles tuviste que responder tú mismo.',
  $j${
    "beats": [
      {
        "situation": "Tienes dos preguntas sobre un mensaje: cómo se podría leer la segunda frase, y si Ana se va a molestar por él.",
        "prompt": "¿Cuál preguntas?",
        "options": [
          { "text": "Las dos — una podría ser útil.", "correct": false, "note": "La segunda consigue una respuesta confiada construida de la nada, y una respuesta confiada es exactamente lo que vas a recordar." },
          { "text": "Ninguna, por seguridad.", "correct": false, "note": "Sobrecorrección. La primera es una de las cosas en las que es mejor." },
          { "text": "La de la frase.", "correct": true, "note": "La ambigüedad está en el texto. Si la pregunta tiene un nombre dentro, te toca responderla a ti." },
          { "text": "La de Ana, ya que ella es el punto.", "correct": false, "note": "Ella es el punto y nunca la ha conocido, que es precisamente por lo que esa pregunta no tiene respuesta aquí." }
        ]
      },
      {
        "situation": "Alguien te ha enviado cuatro páginas y no estás seguro de qué quiere.",
        "prompt": "¿Está eso en el lado fiable?",
        "options": [
          { "text": "No — no puede saber qué quisieron decir.", "correct": false, "note": "Qué quisieron decir al enviarlo es una pregunta distinta de qué te piden las páginas." },
          { "text": "Solo si también pegas el correo de presentación.", "correct": false, "note": "Contexto útil, y el documento solo ya es comprensible." },
          { "text": "No, cuatro páginas es demasiado contexto.", "correct": false, "note": "La longitud no es la limitación. Los documentos largos son un buen uso." },
          { "text": "Sí — comprensión de texto.", "correct": true, "note": "Qué se te está pidiendo está en las palabras. Qué quisieron decir al enviarlo no lo está." }
        ]
      }
    ]
  }$j$::jsonb
);
