-- Spanish: La primera cita, track 2 — Dos horas hablando.
--
-- Conventions as prior tracks: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Robin" carries no `sex` field; masculine agreement used by
-- default, as established elsewhere. Lesson 5 is [scene] mode, so its
-- rehearsal_spec stays an empty object, matching the English source
-- exactly (verified against the live row, not NULL).

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

select pg_temp.es_lesson('the-conversation', 1,
  'Se supone que los primeros diez minutos son incómodos',
  $md$El principio de una primera cita es incómodo, y lo más útil que se puede saber al respecto es que eso es estructural, no personal.

Dos personas que nunca se han conocido, que las dos saben exactamente qué es esto, sin ningún contexto compartido y sin nada que hacer juntas, van a estar incómodas unos minutos. Eso es una descripción de la situación. La otra persona está sintiendo exactamente lo mismo, al mismo tiempo, y está igual de convencida de que es culpa suya.

El daño viene de malinterpretarlo como un veredicto. La gente concluye en el minuto seis que aquí no hay nada y luego se pasa noventa minutos confirmando educadamente un juicio que hizo antes de que nada tuviera oportunidad de empezar. La química en el minuto uno es rara. La química en el minuto veinte es completamente normal, y es con lo que empezaron de verdad la mayoría de las buenas relaciones.

**La jugada:** dilo en voz alta, y dale veinte minutos antes de decidir nada.

Nombrarlo es el chiste más seguro que hay, porque es un chiste sobre una situación en la que estáis los dos en vez de sobre alguno de los dos. *Esta parte siempre es un poco rara* consigue una risa casi siempre — no porque tenga gracia, sino porque es verdad y porque alguien tuvo el valor de decirlo primero, que en sí mismo ya es un pequeño alivio.

Dos cosas mecánicas ayudan. Decide el saludo de antemano — abrazo, apretón de manos, o ninguno — para no estar negociándolo en tiempo real; todo el mundo ha tenido un saludo malo y nadie ha vuelto a pensar en ello. Y quita de en medio la logística rápido: bebidas, abrigos, dónde sentarse. No es conversación y no pretende serlo, y en cuanto está hecho sois dos personas en una mesa en vez de dos personas llegando.

Si te quedas con una cosa: los primeros diez minutos no son la cita. Casi nadie lo sabe, y es el motivo por el que se abandonaron un montón de buenas noches en el minuto seis.$md$,
  $j$[
    {
      "situation": "Cuatro minutos después y se siente forzado.",
      "line": "Esta parte siempre es un poco rara, ¿no?",
      "why": "Un chiste sobre la situación en la que estáis los dos en vez de sobre alguno de los dos. Funciona casi siempre, porque es verdad y porque alguien lo dijo primero."
    },
    {
      "situation": "Minuto seis, y en tu fuero interno has concluido que aquí no hay nada.",
      "line": "(dale veinte)",
      "why": "La química en el minuto uno es rara y la química en el minuto veinte es normal. Decidir pronto significa pasarse noventa minutos confirmando un veredicto en vez de averiguándolo."
    },
    {
      "situation": "Estás ahí de pie decidiendo si abrazarla.",
      "line": "(elige uno y comprométete)",
      "why": "Todo el mundo ha tenido un saludo malo y nadie ha vuelto a pensar en ello. Negociarlo en tiempo real es la única versión que de verdad es incómoda."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué es incómodo el principio?",
      "options": [
        { "text": "Porque estás nervioso.", "correct": false, "note": "Lo estás, y ella también, y seguiría siendo incómodo aunque ninguno de los dos lo estuviera." },
        { "text": "Porque todavía no habéis encontrado un tema.", "correct": false, "note": "Un síntoma. Los temas no escasean; lo que no se ha asentado es la situación." },
        { "text": "Porque dos desconocidos sin contexto compartido y con mucho en juego no tienen nada que hacer juntos.", "correct": true, "note": "Es una descripción de la situación en vez de un veredicto sobre ninguna de las dos personas, y la otra está igual de convencida de que es culpa suya." },
        { "text": "Porque las primeras impresiones importan tanto.", "correct": false, "note": "Importan menos de lo que la gente cree, y creer esto es lo que convierte diez minutos incómodos en una actuación." }
      ],
      "explain": "Estructural, no personal. Los dos estáis teniendo la misma experiencia."
    },
    {
      "prompt": "¿Qué te cuesta de verdad concluir pronto?",
      "options": [
        { "text": "Noventa minutos confirmando un veredicto.", "correct": true, "note": "Dejas de intentarlo, ella lo nota, y la noche se convierte obedientemente en lo que decidiste en el minuto seis." },
        { "text": "Nada — te has ahorrado una noche.", "correct": false, "note": "De todas formas te ibas a quedar las dos horas. La única pregunta era si iban a ser buenas." },
        { "text": "Una segunda cita que de todas formas no querías.", "correct": false, "note": "Todavía no sabes si la querías, que es todo el sentido de los veinte minutos." },
        { "text": "Tu confianza para la próxima.", "correct": false, "note": "Real y consecuencia de esto. El coste inmediato es el resto de esta noche." }
      ],
      "explain": "La química en el minuto veinte es el caso normal, no la excepción."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "waited", "label": "Le dio veinte minutos", "description": "No decidió durante el principio." },
      { "key": "named_it", "label": "Nombró lo incómodo", "description": "Dijo en voz alta lo compartido en vez de forzar para superarlo." },
      { "key": "logistics", "label": "Resolvió la logística", "description": "Se ocupó rápido de las bebidas y los asientos en vez de tratarlo como conversación." },
      { "key": "no_performance", "label": "No lo actuó", "description": "Dejó que fuera brevemente incómodo en vez de llenarlo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "la persona con la que estás en una cita",
      "mood": "Nervioso, contento de estar aquí.",
      "openness": 4,
      "personality": "Igual de incómodo, y disimulándolo un poco peor. Se relaja enormemente en cuanto alguien admite que la situación es rara."
    },
    "setting": "Cuatro minutos después. Las bebidas están en la mesa, los abrigos ya están resueltos, y acaba de haber una pausa un poco más larga de lo que quería ninguno de los dos.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Relájate de forma visible y anímate si la persona reconoce la situación.",
      "Mantente rígido y demasiado educado si la persona intenta forzar con entusiasmo.",
      "Nunca nombres tú lo incómodo."
    ],
    "opening_beat": "«...bueno. Sí. Aquí estamos.» Una pausa.",
    "success_looks_like": "La persona nombra lo incómodo en vez de actuarlo."
  }$j$::jsonb,
  'Hoy, nombra en voz alta un momento incómodo en vez de forzar para superarlo. Apunta qué dijiste y qué pasó después.',
  $j${
    "beats": [
      {
        "situation": "Cuatro minutos después. Las bebidas están en la mesa y acaba de haber una pausa un poco más larga de lo que quería ninguno de los dos.",
        "prompt": "¿Qué haces?",
        "options": [
          { "text": "Haz otra pregunta para que fluya.", "correct": false, "note": "Fluye y no se asienta. Preguntas metidas en un principio que no se ha asentado es cómo empieza el interrogatorio." },
          { "text": "Sube la energía — sé un poco más gracioso durante un minuto.", "correct": false, "note": "Esforzado y visible, y les deja actuando de vuelta durante los siguientes veinte minutos." },
          { "text": "Di que esta parte siempre es un poco rara.", "correct": true, "note": "Un chiste sobre la situación en la que estáis los dos en vez de sobre alguno de los dos. Funciona casi siempre, y es un alivio que alguien lo dijera primero." },
          { "text": "Nada — deja que pase solo.", "correct": false, "note": "Va a pasar, y nombrarlo es más rápido y os quita el peso a los dos en vez de a uno solo." }
        ]
      },
      {
        "situation": "Minuto seis. Está forzado, ella parece nerviosa, y estás bastante seguro de que aquí no hay nada.",
        "prompt": "¿Cuánto vale ese juicio?",
        "options": [
          { "text": "Bastante — las primeras impresiones suelen acertar.", "correct": false, "note": "Sobre cosas que se ven en un segundo. No sobre si te gustaría la compañía de alguien, que lleva más de seis minutos." },
          { "text": "Nada todavía — la química en el minuto veinte es el caso normal.", "correct": true, "note": "La química en el minuto uno es rara. Decidir ahora significa pasarse noventa minutos confirmando educadamente un veredicto al que llegaste antes de que nada empezara." },
          { "text": "Algo — merece la pena estar atento.", "correct": false, "note": "Estar atento buscando confirmación es cómo se gastan los noventa minutos. Todavía no hay nada que vigilar." },
          { "text": "Suficiente como para empezar a planear una salida temprana.", "correct": false, "note": "Ya fijaste una hora de fin antes de venir. Usarla en el minuto seis es decidir, no marcharte." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-conversation', 2,
  'Reacciona, no informes',
  $md$Ya te has encontrado este fallo dos veces en esta aplicación, y aquí no tiene rescate. En una cita no se une ningún compañero, ninguna cola te hace avanzar, y nada lo termina — así que un interrogatorio no se apaga educadamente, se queda ahí sentado durante dos horas.

La forma es siempre la misma. A qué te dedicas, dónde te criaste, si tienes hermanos, cuánto tiempo llevas aquí. Los dos estáis siendo perfectamente agradables. No pasa nada malo. Y al final sabes muchísimo sobre alguien por quien no sientes absolutamente nada.

**La jugada:** responde, y luego di lo que de verdad piensas sobre tu propia respuesta.

El dato es la materia prima y la reacción es el contenido. *Me crié en Leeds* es un dato. *Me crié en Leeds y tengo sentimientos complicados sobre cuánto lo echo de menos* es una persona — y solo una de las dos cosas es algo a lo que alguien pueda responder, con lo que estar de acuerdo, o que le pueda gustar.

Merece la pena ser honesto sobre por qué la versión de solo datos es tan tentadora: un dato no se puede juzgar. A nadie le caes mal por dónde naciste. Una opinión, un sentimiento, algo que te molesta — todo eso se puede encontrar con una mirada en blanco, y evitar esa posibilidad es precisamente lo que hace que sea imposible sentir nada por alguien.

Las pequeñas historias hacen el mismo trabajo con menos exposición. *Hubo una época en la que intenté que me gustara correr* invita a algo de vuelta, lleva treinta segundos, y no requiere nada ingenioso. Ya tienes cientos de ellas y ninguna necesita ser interesante sobre el papel.

Y no devuelvas la pregunta como un espejo. *¿Y tú?* mantiene el cuestionario en marcha, y dos personas pueden intercambiarlo toda la noche sin aprender absolutamente nada.

Si te quedas con una cosa: los datos son lo que ofreces cuando te da miedo caer mal, y son el motivo por el que nadie siente nada en ningún sentido.$md$,
  $j$[
    {
      "situation": "«Entonces, ¿a qué te dedicas?»",
      "line": "Llevo las cuentas de una empresa de construcción — que tiene mucho más cotilleo del que te imaginas.",
      "why": "El dato, y luego la reacción. La segunda mitad es la única parte que se puede responder, y la única que dice algo de cómo eres."
    },
    {
      "situation": "Has respondido y estás a punto de decir y tú qué.",
      "line": "(eso mantiene el cuestionario en marcha)",
      "why": "Dos personas pueden intercambiar las mismas seis preguntas toda la noche y no aprender nada. Reacciona en su lugar, y deja que reaccionen a eso."
    },
    {
      "situation": "Quieres decir algo pero nada te parece lo bastante interesante.",
      "line": "Hubo toda una época en la que intenté que me gustara correr.",
      "why": "Una pequeña historia no necesita nada ingenioso, lleva treinta segundos, e invita a algo de vuelta. No tiene que ser interesante sobre el papel."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué es tan tentadora la respuesta de solo datos?",
      "options": [
        { "text": "Es más rápido.", "correct": false, "note": "La velocidad no es lo que la hace atractiva, y la versión interrogatorio suele ser más lenta en general." },
        { "text": "Un dato no se puede juzgar.", "correct": true, "note": "A nadie le caes mal por dónde naciste. Una opinión se puede encontrar con una mirada en blanco, y evitar eso es exactamente lo que hace que sea imposible sentir nada por alguien." },
        { "text": "Es lo que te han preguntado.", "correct": false, "note": "Lo es, y la pregunta es una apertura, no un formulario que rellenar." },
        { "text": "Mantiene las cosas ligeras.", "correct": false, "note": "Mantiene las cosas vacías, que se siente como ligero durante unos veinte minutos." }
      ],
      "explain": "La seguridad es el problema. Nada que no pueda disgustar tampoco puede gustar."
    },
    {
      "prompt": "¿Cuál es lo más pequeño que lo arregla?",
      "options": [
        { "text": "Hacer mejores preguntas.", "correct": false, "note": "Mejores preguntas producen un mejor interrogatorio. Lo que hay que cambiar es el formato." },
        { "text": "Hablar de algo más inusual.", "correct": false, "note": "Apuntar a lo inusual produce la anécdota pulida, que es esforzada y funciona peor que una opinión corriente." },
        { "text": "Ser más gracioso.", "correct": false, "note": "No está disponible a demanda, y no es lo que falta. Lo que falta es que tengas una opinión." },
        { "text": "Decir qué piensas sobre tu propia respuesta.", "correct": true, "note": "Un único añadido convierte cualquier intercambio soso. El dato es la materia prima; la reacción es el contenido." }
      ],
      "explain": "Responde, y luego reacciona a tu propia respuesta. Esa es toda la jugada."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "reacted", "label": "Añadió una reacción", "description": "Dijo qué pensaba sobre su propia respuesta." },
      { "key": "no_mirror", "label": "No devolvió la pregunta como un espejo", "description": "Evitó pasar de vuelta la misma pregunta tal cual." },
      { "key": "specific", "label": "Fue concreto", "description": "Nombró un sentimiento u opinión reales en vez de insinuar que los tiene." },
      { "key": "light", "label": "Lo mantuvo corto", "description": "Una frase, no un relato." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "la persona con la que estás en una cita",
      "mood": "Agradable, aburrido en silencio, sin saber decir por qué.",
      "openness": 4,
      "personality": "Perfectamente simpático y atascado en modo interrogatorio. Sigue haciendo preguntas de datos hasta que alguien dice algo con una opinión dentro, y entonces se anima."
    },
    "setting": "Veinte minutos después. Ha sido amistoso, correcto y completamente plano — trabajos, barrios, cuánto tiempo lleva cada uno aquí.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a una pregunta devuelta con otra pregunta de datos, manteniendo el interrogatorio en marcha.",
      "Anímate y reacciona de verdad en el momento en que la persona ofrezca una opinión o un sentimiento.",
      "Nunca ofrezcas tú una opinión primero."
    ],
    "opening_beat": "«Entonces, ¿a qué te dedicas?»",
    "success_looks_like": "La persona responde y añade una reacción real en vez de devolver la pregunta como un espejo."
  }$j$::jsonb,
  'Hoy, responde una pregunta y luego di lo que de verdad piensas sobre tu propia respuesta. Apunta el dato y la reacción.',
  $j${
    "says": "Entonces, ¿a qué te dedicas?",
    "model": {
      "line": "Llevo las cuentas de una empresa de construcción. Tiene mucho más cotilleo del que te imaginas, que es el único motivo por el que sigo ahí.",
      "why": "El dato, y luego lo que de verdad piensas al respecto. La segunda mitad es la única parte a la que se puede responder, y la única que dice cómo eres."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Mete algo de ti mismo" },
      { "kind": "forbids_any", "words": ["y tú", "y a ti", "qué tal tú", "a qué te dedicas", "tú mismo", "tu turno"], "requirement": "No devuelvas la misma pregunta" },
      { "kind": "min_words", "n": 12, "requirement": "Más que el nombre del puesto" },
      { "kind": "max_words", "n": 40, "requirement": "Una frase, no un relato" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-conversation', 3,
  'Cuánto de ti mismo',
  $md$Hay dos formas de hacer esto mal y una persona callada puede conseguir las dos en una sola noche.

Contar de menos es, con diferencia, lo más habitual, y es peligroso porque va disfrazado de virtud. Haces buenas preguntas, escuchas bien, estás genuinamente interesado — y te vas a casa habiendo dicho casi nada sobre ti mismo. Desde dentro se lee como modestia. Desde el otro lado de la mesa se lee como alguien que no está ahí, y a una persona que no se puede encontrar no se le puede coger cariño. Hacer todas las preguntas no es generosidad; es la forma más socialmente aceptable de esconderse.

Contar de más es la misma persona dos copas después, cuando se rompe el dique y veinte minutos de algo pesado le llegan a un desconocido que no tiene ni idea de qué hacer con ello. Normalmente no es imprudencia. Es la presión de no haber dicho nada durante una hora encontrando la primera salida disponible.

**La jugada:** ofrece algo real pronto, por iniciativa propia.

No una confesión. Una preferencia, algo vergonzoso, algo que te importa más de lo razonable. *Tengo opiniones firmes sobre cómo organiza el menú este sitio.* *Se me da de verdad mal esto y tardo como una hora en ser normal.* Pequeño, verdadero, y ofrecido en vez de extraído — que es lo que fija la profundidad del resto de la noche y le da permiso en silencio para hacer lo mismo.

Luego iguala su profundidad en vez de llevarla tú. Contar cosas es una escalera exactamente igual que el contacto físico: un peldaño, ves qué vuelve, y luego el siguiente. Contar de más es saltarse cuatro peldaños de golpe, y a la otra persona le sienta como si le entregaran algo que no aceptó sostener.

Las cosas pesadas no están prohibidas, son prematuras. Si sale un ex o un mal año de forma honesta, una frase y sigues — el error nunca es mencionarlo, son los veinte minutos.

Si te quedas con una cosa: di algo verdadero sobre ti mismo antes de que nadie te pregunte. Es la forma más barata de dejar de ser un desconocido muy agradable.$md$,
  $j$[
    {
      "situation": "Has hecho seis buenas preguntas y no has dicho nada sobre ti mismo.",
      "line": "(eso no es escuchar, es esconderse)",
      "why": "Se lee como modestia desde dentro y como ausencia desde el otro lado de la mesa. A una persona que no se puede encontrar no se le puede coger cariño."
    },
    {
      "situation": "Diez minutos después, nadie te ha preguntado nada personal.",
      "line": "Se me da de verdad mal esto, por cierto — tardo como una hora en ser normal.",
      "why": "Pequeño, verdadero, y ofrecido en vez de extraído. Fija la profundidad y le da permiso para hacer lo mismo."
    },
    {
      "situation": "El tema ha aterrizado en tu peor año y llevas tres minutos.",
      "line": "(una frase, y sigues)",
      "why": "El error nunca es mencionarlo, son los veinte minutos. Las cosas pesadas no están prohibidas, son prematuras."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué contar de menos es lo más peligroso?",
      "options": [
        { "text": "Va disfrazado de ser un buen oyente.", "correct": true, "note": "Se lee como modestia desde dentro y como ausencia desde el otro lado, así que nada te empuja nunca a corregirlo. Hacer todas las preguntas es la forma más socialmente aceptable de esconderse." },
        { "text": "Pasa más a menudo.", "correct": false, "note": "Pasa, y la frecuencia no es lo que hace difícil detectarlo." },
        { "text": "Hace que la otra persona haga todo el trabajo.", "correct": false, "note": "Cierto y secundario — a mucha gente le gusta hablar. El coste es que tú nunca estuviste ahí para que te cogieran cariño." },
        { "text": "Parece que no estás interesado.", "correct": false, "note": "Normalmente parece justo lo contrario, que es exactamente por lo que nadie lo detecta." }
      ],
      "explain": "Un desconocido muy agradable sigue siendo un desconocido."
    },
    {
      "prompt": "¿Qué causa contar de más?",
      "options": [
        { "text": "El alcohol.", "correct": false, "note": "El momento, no la causa. Dos copas bajan el muro sobre el que una hora de silencio ya había puesto presión." },
        { "text": "Querer parecer interesante.", "correct": false, "note": "Eso produce la anécdota pulida, que es un fallo distinto y más silencioso." },
        { "text": "Confiar demasiado rápido en alguien.", "correct": false, "note": "Cómo se ve después. En el momento casi nunca es una decisión sobre la otra persona en absoluto." },
        { "text": "Una hora de no haber dicho nada, encontrando la primera salida.", "correct": true, "note": "Es la misma persona que contó de menos, más tarde. Ofrecer algo pequeño pronto es lo que impide que se acumule la presión." }
      ],
      "explain": "Los dos fallos tienen un arreglo: algo real, pronto, por iniciativa propia."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "volunteered", "label": "Ofreció algo", "description": "Ofreció algo real sin que se lo pidieran." },
      { "key": "small", "label": "Lo mantuvo pequeño", "description": "Una preferencia o algo vergonzoso en vez de una confesión." },
      { "key": "matched", "label": "Igualó su profundidad", "description": "Subió un peldaño en vez de cuatro." },
      { "key": "moved_on", "label": "Siguió adelante desde lo pesado", "description": "Una frase, no veinte minutos." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "la persona con la que estás en una cita",
      "mood": "Disfrutándolo y algo desconcertado.",
      "openness": 4,
      "personality": "Encantado de responder preguntas indefinidamente y cada vez más consciente de que esto es unilateral. Se anima al momento cuando la persona ofrece algo por iniciativa propia."
    },
    "setting": "Veinticinco minutos después. Has hecho muchas preguntas, las ha respondido todas, y no sabe prácticamente nada de ti.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde cualquier pregunta a fondo y luego devuelve la atención a la persona.",
      "Responde con calidez y corresponde cuando la persona ofrezca algo sobre sí misma.",
      "Nunca le hagas a la persona una pregunta directa sobre su vida."
    ],
    "opening_beat": "«...bueno, seguramente es más de lo que querías saber sobre mi piso. Se te da muy bien hacer preguntas, ¿sabes?»",
    "success_looks_like": "La persona ofrece algo real sobre sí misma sin que se lo pidan."
  }$j$::jsonb,
  'Hoy, ofrece algo verdadero sobre ti mismo antes de que nadie te lo pida. Apunta qué dijiste.',
  $j${
    "says": "...bueno, seguramente es más de lo que querías saber sobre mi piso. Se te da muy bien hacer preguntas, ¿sabes?",
    "model": {
      "line": "A mí también se me da de verdad mal esto — normalmente tardo como una hora en ser una persona normal.",
      "why": "Pequeño, verdadero, y ofrecido en vez de extraído. Fija la profundidad del resto de la noche y le da permiso en silencio para hacer lo mismo."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Di algo sobre ti" },
      { "kind": "no_question", "requirement": "Ofrece, no preguntes — ya has preguntado bastante" },
      { "kind": "forbids_any", "words": ["mi ex", "mi terapeuta", "mi divorcio", "depresión", "murió", "mi enfermedad", "peor año", "crisis nerviosa"], "requirement": "Pequeño y verdadero, no una confesión" },
      { "kind": "min_words", "n": 8, "requirement": "Algo real, no una evasiva" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-conversation', 4,
  'Deja que divague, y deja que pare',
  $md$Dos horas son más de lo que dura cualquier conversación que hayas planeado, lo cual es una suerte, porque las partes que merece la pena tener son las que ninguno de los dos planeó.

**La jugada:** deja que el tema cambie sin permiso, y deja que pasen las pausas.

Divagar primero. Una buena conversación se mueve por asociación, y los mejores veinte minutos de una buena primera cita casi siempre están en algún sitio que ninguno de los dos podría haber predicho al principio — una tangente de una tangente, a la que se llega por accidente. Lo que lo mata es dirigir: notar que os habéis alejado y arrastrar las cosas de vuelta a un tema como es debido, que es lo que hace alguien que cree que una cita tiene una agenda. No la tiene. No hay nada que cubrir.

El error relacionado es la caza del tema interesante, donde vas probando temas buscando uno que funcione. Es agotador de hacer y se nota desde fuera, y trata a la otra persona como una sala que hay que trabajar en vez de como alguien con quien hablar.

Y luego las pausas. Dos horas no pueden ser habla continua y nunca lo iban a ser. Un hueco en el que los dos bebéis algo no es un estado de fallo, es cómo suena de verdad una conversación entre dos personas relajadas — y el instinto de llenar cada una de ellas es lo más agotador que te puedes hacer a ti mismo en toda una noche.

Llenarlas también es contraproducente de una forma concreta: alguien que nunca deja que un silencio se asiente es alguien en quien la otra persona no puede meter baza. Algunas de las mejores cosas que dice la gente llegan en el segundo en el que nadie estaba hablando.

Si una pausa de verdad se alarga demasiado, la sala está ahí mismo. Algo sobre el sitio, la bebida, la gente de la mesa de al lado. Eso no es un fallo de charla trivial, es para lo que se eligió el local.

Si te quedas con una cosa: no hay nada que cubrir, y nadie está cronometrando los huecos. Las dos cosas le quitan más peso a dos horas que cualquier técnica de este bloque.$md$,
  $j$[
    {
      "situation": "Os habéis alejado mucho de donde empezasteis.",
      "line": "(déjalo ir — esa es la parte buena)",
      "why": "Los mejores veinte minutos de una buena primera cita casi siempre están en algún sitio que ninguno de los dos planeó. Dirigir de vuelta es lo que hace alguien que cree que una cita tiene una agenda."
    },
    {
      "situation": "Ha habido un silencio de cuatro segundos.",
      "line": "(así suenan dos personas relajadas)",
      "why": "Llenar cada pausa es lo más agotador que puedes hacer en dos horas, y no le deja a la otra persona ninguna forma de entrar."
    },
    {
      "situation": "La pausa de verdad se ha alargado demasiado.",
      "line": "(usa la sala)",
      "why": "Algo sobre el sitio, la bebida, la gente de la mesa de al lado. Eso es exactamente para lo que se eligió un sitio donde pasa algo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué no dirigir de vuelta a un tema como es debido?",
      "options": [
        { "text": "Hace que parezcas desorganizado.", "correct": false, "note": "Nadie está evaluando la estructura de la noche, y preocuparte de que lo hagan es el problema." },
        { "text": "Puede que no vuelvas a él.", "correct": false, "note": "No vas a volver, y no se pierde nada. No había nada que cubrir." },
        { "text": "No hay agenda, y las tangentes son la parte buena.", "correct": true, "note": "Una buena conversación se mueve por asociación. Dirigir es lo que hace alguien que cree que la cita tiene temas que superar." },
        { "text": "Les interrumpe.", "correct": false, "note": "Un efecto secundario, no el motivo, y dirigir normalmente se hace educadamente en un hueco natural." }
      ],
      "explain": "No hay nada que cubrir. La tangente de la tangente es donde se pone bueno."
    },
    {
      "prompt": "¿Qué cuesta llenar cada silencio?",
      "options": [
        { "text": "Hace que parezcas nervioso.", "correct": false, "note": "Puede, y cómo se ve es la mitad menor del asunto." },
        { "text": "Nada — mantiene las cosas en marcha.", "correct": false, "note": "Te mantiene hablando, que no es lo mismo que vaya bien." },
        { "text": "Te quedas sin cosas que decir.", "correct": false, "note": "Casi nunca pasa. Lo que se agota es tu energía, hacia el minuto noventa." },
        { "text": "Te agota, y no les deja ninguna forma de entrar.", "correct": true, "note": "Algunas de las mejores cosas que dice la gente llegan en el segundo en el que nadie estaba hablando, y quien nunca deja que un hueco se asiente nunca las oye." }
      ],
      "explain": "Una pausa es cómo suenan dos personas relajadas. Nadie la está cronometrando."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "wandered", "label": "Dejó que divagara", "description": "Siguió la tangente en vez de dirigir de vuelta." },
      { "key": "allowed_pauses", "label": "Dejó que pasaran las pausas", "description": "No llenó cada silencio." },
      { "key": "no_auditioning", "label": "No probó temas", "description": "Habló en vez de cazar algo que funcionara." },
      { "key": "used_the_room", "label": "Usó la sala cuando hizo falta", "description": "Recurrió a lo que de verdad había alrededor en vez de forzar un tema." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "la persona con la que estás en una cita",
      "mood": "Relajado, disfrutándolo.",
      "openness": 4,
      "personality": "Cómodo con el silencio y sigue las tangentes encantado. Se vuelve notablemente más formal si le dirigen de vuelta a un tema anterior."
    },
    "setting": "Una hora después. Ha ido bien y acabáis de llegar al final de una larga tangente sobre algo que ninguno de los dos esperaba hablar.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Deja que los silencios duren un momento antes de hablar, y descríbelos con sencillez.",
      "Vuélvete más formal y breve si la persona arrastra el tema de vuelta a algo anterior.",
      "Nunca rescates tú un silencio en los primeros segundos."
    ],
    "opening_beat": "«...de verdad que nunca había dicho nada de eso en voz alta.» Una pausa, y ninguno de los dos la llena.",
    "success_looks_like": "La persona deja que la pausa se asiente y sigue a donde de verdad fue la conversación."
  }$j$::jsonb,
  'Hoy, deja que un silencio se asiente en vez de llenarlo. Apunta cuánto duró y qué vino después.',
  $j${
    "beats": [
      {
        "situation": "Llevas cuarenta minutos y estás a tres tangentes de nada de lo que pensabas hablar.",
        "prompt": "¿Y ahora qué?",
        "options": [
          { "text": "Llévalo de vuelta a lo que decían sobre el trabajo.", "correct": false, "note": "Dirigir. Es lo que hace alguien que cree que una cita tiene temas que superar, y es lo que mata la parte buena." },
          { "text": "Sigue por la tangente.", "correct": true, "note": "Los mejores veinte minutos de una buena primera cita casi siempre están en algún sitio que ninguno de los dos planeó. No hay nada que cubrir." },
          { "text": "Fíjate en dónde estabais, para poder volver luego.", "correct": false, "note": "Sostener un hilo con intención de retomarlo es una agenda de bajo nivel, y le quita atención a lo que se está diciendo ahora." },
          { "text": "Comprueba si sigue interesada en este tema.", "correct": false, "note": "Preguntar lo convierte en una decisión. Está metida en ello contigo, que es por lo que habéis llegado a tres tangentes de profundidad." }
        ]
      },
      {
        "situation": "Una pausa. Cuatro segundos, y ninguno de los dos ha dicho nada.",
        "prompt": "¿Qué es eso?",
        "options": [
          { "text": "Una señal de aviso — llénala antes de que crezca.", "correct": false, "note": "Llenar cada una es lo más agotador que puedes hacer en dos horas, y no les deja ninguna forma de entrar." },
          { "text": "Una invitación para que hable.", "correct": false, "note": "Cerca, y plantearlo como una táctica te mantiene gestionando la conversación en vez de estando en ella." },
          { "text": "Hora de cambiar de tema.", "correct": false, "note": "Una pausa no es el final de un tema. Cambiar en cada hueco es la caza de temas, que se nota y es agotador." },
          { "text": "Cómo suenan dos personas relajadas.", "correct": true, "note": "Dos horas no pueden ser habla continua. Algunas de las mejores cosas que dice la gente llegan en el segundo en el que nadie estaba hablando." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-conversation', 5,
  'Trae algo de vuelta',
  $md$Esta es la calidez más barata que hay en toda esta aplicación, y no cuesta nada salvo haber estado prestando atención.

**La jugada:** trae de vuelta, más tarde, algo que dijeron antes.

*Tenías razón con lo de tu hermana, por cierto.* *¿Es este el café del que te quejabas?* *¿Al final arreglaron el piso?* Nada de eso es ingenioso. Lo que hace es decirle a alguien que lo que dijo hace una hora merecía la pena conservarlo — que es algo que casi nadie hace por nadie, y que llega mucho más fuerte que cualquier cumplido que pudieras construir.

Funciona porque no se puede fingir. Un cumplido está disponible para cualquiera en cualquier momento, así que lleva muy poca información. Una referencia a algo dicho antes demuestra que estabas escuchando hace una hora, y no hay forma de producir una sin haberlo hecho. Es prueba en vez de afirmación, que es el mismo motivo por el que un cumplido concreto gana a uno general en cualquier otro sitio de este programa.

También es, de forma útil, la mejor herramienta que existe para una persona callada, porque no requiere nada de lo que le cuesta a la gente callada. No necesita que seas rápido, gracioso, o que tengas una historia. Necesita que hayas escuchado, que es lo que estabas haciendo de todas formas — a menudo mejor que quien llevaba la mayor parte de la conversación.

En la práctica: las buenas son pequeñas. Un hilo sin terminar, algo que les molestaba, algo que dijeron que igual harían. Reabrir temas enteros de golpe se siente como una agenda; un detalle se siente como cariño.

Y es el puente natural hacia lo que viene después. El plan que propongas al final de la noche casi siempre debería ser una referencia a algo dicho antes — el sitio que mencionaron, lo que dijeron que nunca habían probado. Eso es todo el último bloque, y empieza aquí, con haberlo escuchado.

Si te quedas con una cosa: lo que dijeron hace cuarenta minutos vale más que cualquier cosa que se te pueda ocurrir ahora.$md$,
  $j$[
    {
      "situation": "Mencionaron una discusión constante con su hermana hace una hora.",
      "line": "Entonces, ¿quién ganó, al final? Con tu hermana.",
      "why": "Demuestra que estabas escuchando hace una hora, que es prueba en vez de afirmación — y no hay forma de fingirlo."
    },
    {
      "situation": "Quieres decir algo cálido y no se te ocurre nada.",
      "line": "(usa algo que dijeron antes)",
      "why": "No necesita nada de lo que le cuesta a la gente callada. Ni rápido, ni gracioso, ni una historia — solo haber escuchado, que es lo que estabas haciendo de todas formas."
    },
    {
      "situation": "Estás buscando algo que proponer al final.",
      "line": "(el sitio que mencionaron hace una hora)",
      "why": "El mejor siguiente plan casi siempre es una referencia a algo dicho antes, que es por lo que esta lección es el puente hacia el último bloque."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué una referencia a algo dicho antes gana a un cumplido?",
      "options": [
        { "text": "Es más original.", "correct": false, "note": "Normalmente cierto y no es el mecanismo. Una referencia poco original sigue funcionando." },
        { "text": "Los cumplidos incomodan a la gente.", "correct": false, "note": "La mayoría de la gente recibe un cumplido perfectamente contenta. El problema es lo que demuestra, que es nada." },
        { "text": "No se puede fingir.", "correct": true, "note": "Un cumplido está disponible para cualquiera en cualquier momento. Una referencia a algo dicho antes es prueba de que estabas escuchando hace una hora, y no hay forma de producir una sin haberlo hecho." },
        { "text": "Mantiene la conversación en marcha.", "correct": false, "note": "Lo hace, y también casi cualquier cosa. El valor está en lo que le dice." }
      ],
      "explain": "Prueba en vez de afirmación — el mismo motivo por el que lo concreto gana a lo general en cualquier otro sitio de esta aplicación."
    },
    {
      "prompt": "¿Qué hace que una sea buena?",
      "options": [
        { "text": "Reabrir un tema que claramente disfrutaron.", "correct": false, "note": "Reabrir un tema entero de golpe se siente como una agenda. La versión pequeña funciona mejor." },
        { "text": "Algo que dijeron que estaban deseando.", "correct": false, "note": "Perfectamente bien, y es un ejemplo de la regla general, no la regla." },
        { "text": "Lo más interesante que dijeron.", "correct": false, "note": "Interesante no es la prueba — recuperable y pequeño sí lo es. Las mejores son a menudo triviales." },
        { "text": "Un pequeño detalle sin terminar.", "correct": true, "note": "Un hilo dejado colgando, algo que les molestaba, algo que dijeron que igual harían. Un detalle se siente como cariño; un tema se siente como un plan." }
      ],
      "explain": "Pequeña y sin terminar. Y la que reservas para el final se convierte en la próxima cita."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "brought_back", "label": "Trajo algo de vuelta", "description": "Se refirió a algo dicho antes en la noche." },
      { "key": "small", "label": "Lo mantuvo pequeño", "description": "Un detalle en vez de un tema entero reabierto." },
      { "key": "accurate", "label": "Lo recordó bien", "description": "Lo recordó con precisión suficiente como para demostrar que estaba escuchando." },
      { "key": "saved_one", "label": "Guardó uno para el final", "description": "Se fijó en algo que podía convertirse en un plan." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "la persona con la que estás en una cita",
      "mood": "Cálido, hora y media después.",
      "openness": 4,
      "personality": "Menciona cosas pequeñas de pasada sin detenerse en ellas, y se le nota encantado cada vez que se trae alguna de vuelta. Nunca las repite por iniciativa propia."
    },
    "setting": "Noventa minutos después. Ha ido bien, y ha mencionado varias cosas de pasada — una hermana con la que discute, un sitio cerca de su piso que nunca ha probado, algo del trabajo que le daba pavor el lunes.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Menciona cosas pequeñas de pasada — una hermana, un sitio que nunca has probado, algo que te da pavor — sin detenerte en ninguna de ellas.",
      "Muestra que te alegra y explaya encantado cada vez que se traiga de vuelta algo que dijiste antes.",
      "Nunca traigas tú de vuelta tus propios temas anteriores."
    ],
    "opening_beat": "«Perdona — he perdido completamente el hilo de lo que hablábamos. ¿Por dónde íbamos?»",
    "success_looks_like": "La persona trae de vuelta algo que dijo la otra antes en vez de empezar algo nuevo."
  }$j$::jsonb,
  'Hoy, trae de vuelta algo que alguien dijo antes en una conversación. Apunta qué era y cómo reaccionó.',
  $j${}$j$::jsonb
);
