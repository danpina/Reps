-- Spanish: Chatear online, track 1 — Deja de disculparte.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Priya" (lessons 1, 2, 4, 5) — established feminine exception
-- name. "Nadine" (lesson 3) is a new, unambiguously feminine name;
-- feminine agreement used, consistent with the Priya precedent.

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

select pg_temp.es_lesson('stop-apologising', 1,
  'Todo antes de la petición',
  $md$*¡Perdona que te moleste! Sé que estás muy liado ahora mismo. Esto probablemente sea una pregunta tonta y no pasa nada si la ignoras, pero me preguntaba si el informe necesita las cifras de marzo.*

El mensaje tiene una línea de longitud. Todo lo demás se escribió para ser educado.

**La jugada:** borra todo lo que va delante de la petición.

*¿El informe necesita las cifras de marzo?* es todo el mensaje. No es brusco, no es maleducado, y no le falta nada que la otra persona necesitara.

Tres costes, en orden ascendente.

**Duración.** Un mensaje de cuatro líneas sobre una pregunta de una línea se deja para después, y después es donde se olvidan los mensajes.

**Formulación.** *Perdona que te moleste* afirma que esto es una molestia. *Probablemente una pregunta tonta* afirma que es tonta. Las dos son casi con toda seguridad falsas, las has aportado sin que nadie te lo pidiera, y el lector no tiene ningún motivo para no tomárselas al pie de la letra.

**El impuesto de la tranquilidad.** Este es el de verdad. Una disculpa pide una respuesta antes de que se pueda responder a la petición — ahora tienen que decir *no, para nada, encantado de ayudar*, que es trabajo, y es trabajo sobre ti. Un mensaje que hay que tranquilizar antes de poder gestionarlo es un mensaje más difícil de gestionar, que es lo contrario de para lo que servía la educación.

La prueba es mecánica y tarda dos segundos: encuentra la frase que contiene la petición real, y comprueba si algo por encima de ella está haciendo un trabajo. Casi siempre la respuesta es no, y casi siempre borrarlo produce un mensaje que se lee como tranquilo en vez de cortante.

Si te quedas con una cosa: encuentra la petición y borra hacia arriba. Lo que queda es el mensaje que querías enviar.$md$,
  $j$[
    {
      "situation": "Has escrito cuatro líneas y la pregunta está en la última.",
      "line": "(borra hacia arriba desde la petición)",
      "why": "Encuentra la frase que tiene la pregunta real y comprueba si algo por encima está haciendo un trabajo. Casi siempre nada lo está."
    },
    {
      "situation": "Estás a punto de escribir perdona que te moleste.",
      "line": "(eso afirma que es una molestia)",
      "why": "Has aportado una formulación sin que nadie te lo pidiera, sobre algo de lo que no tenían ninguna queja, y no hay ningún motivo para que no se la tomen al pie de la letra."
    },
    {
      "situation": "La versión corta se siente maleducada.",
      "line": "(se lee como tranquila)",
      "why": "Cortante es algo distinto, y viene de la frialdad, no de la brevedad. Una pregunta directa con un gracias al final es cálida."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es el coste real de la disculpa?",
      "options": [
        { "text": "Hace el mensaje más largo.", "correct": false, "note": "El menor de los tres, y es el que nota la gente." },
        { "text": "Pide que lo tranquilicen antes de poder responder a la pregunta.", "correct": true, "note": "Ahora tienen que decir no, para nada, encantado de ayudar — que es trabajo, sobre ti, creado por ti. Un mensaje que necesita tranquilidad es más difícil de gestionar." },
        { "text": "Te hace parecer inseguro.", "correct": false, "note": "Cómo te refleja a ti, que es el enfoque menos práctico y no lo que hace peor de recibir el mensaje." },
        { "text": "Entierra la pregunta.", "correct": false, "note": "Real, y son los costes de la formulación y la tranquilidad los que hacen el daño duradero." }
      ],
      "explain": "Encuentra la petición y borra hacia arriba. La educación nunca fue lo que se estaba eliminando."
    },
    {
      "prompt": "¿Cuál es la prueba de dos segundos?",
      "options": [
        { "text": "Vuelve a leerlo como si lo hubieras recibido.", "correct": false, "note": "Útil en general, y tarda más y da una respuesta más vaga que la versión mecánica." },
        { "text": "Córtalo a la mitad de longitud.", "correct": false, "note": "Compresión, no diagnóstico. Podría cortar la mitad equivocada." },
        { "text": "Comprueba si algo por encima de la petición está haciendo un trabajo.", "correct": true, "note": "Encuentra la frase que contiene la pregunta real. Casi siempre nada por encima está haciendo nada, y borrarlo produce el mensaje que querías." },
        { "text": "Quita cada palabra de disculpa.", "correct": false, "note": "Cerca, y cazar palabras se pierde el preámbulo que no contiene ninguna palabra de disculpa y sigue siendo puro carraspeo." }
      ],
      "explain": "Casi siempre la respuesta es no, y lo que queda se lee como tranquilo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "ask_first", "label": "Empezó con la petición", "description": "Nada delante de la pregunta real." },
      { "key": "no_apology", "label": "Sin disculpa", "description": "No afirmó que fuera una molestia." },
      { "key": "short", "label": "Lo mantuvo corto", "description": "Una pregunta de una línea enviada como un mensaje de una línea." },
      { "key": "still_warm", "label": "Se mantuvo cálido", "description": "Directo sin ser cortante." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una compañera de trabajo",
      "mood": "Ocupada, amistosa.",
      "openness": 4,
      "personality": "Responde a preguntas directas en segundos. Responde a un mensaje con disculpas tranquilizando primero a quien lo envía y respondiendo después."
    },
    "setting": "Necesitas saber si un informe incluye las cifras de marzo. Le estás escribiendo a una compañera con la que te llevas bien.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a una pregunta directa de inmediato y con calidez.",
      "Tranquiliza primero y responde después si el mensaje abre con una disculpa.",
      "Nunca comentes cómo se escribió el mensaje."
    ],
    "opening_beat": "La ventana de mensajes está abierta.",
    "success_looks_like": "La persona hace la pregunta sin nada delante."
  }$j$::jsonb,
  'Hoy, escribe un mensaje, y luego borra todo lo que hay por encima de la petición antes de enviarlo. Apunta las dos versiones.',
  $j${
    "says": "(la ventana de mensajes está abierta — necesitas saber si el informe incluye las cifras de marzo)",
    "model": {
      "line": "¿El informe necesita las cifras de marzo? Gracias.",
      "why": "La petición sin nada delante. No es brusca y no le falta nada que necesitaran — y no hay que tranquilizarla antes de poder responderla."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["perdona que te moleste", "perdona por", "sé que estás liado", "probablemente tonta", "no pasa nada si lo ignoras", "espero que no te importe", "una rapidita", "sin prisa", "si tienes ocasión", "cuando tengas un segundo"], "requirement": "Nada delante de la petición" },
      { "kind": "requires_question", "requirement": "Haz la pregunta real" },
      { "kind": "max_words", "n": 25, "requirement": "Una pregunta de una línea en una línea" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('stop-apologising', 2,
  'La palabra solo',
  $md$*Solo me preguntaba.* *Solo comprobando.* *Solo una rapidita.* *Solo un seguimiento.* *Solo quería preguntar.*

Es la palabra más común en los mensajes de la gente preocupada por ocupar espacio, y su única función es hacer más pequeño lo que viene después.

**La jugada:** borra cada *solo* y vuelve a leerlo.

Casi nada cambia excepto el tamaño de la petición. *Solo me preguntaba si tenías un minuto* y *¿tienes un minuto?* piden exactamente lo mismo, y una de las dos se disculpa por preguntar mientras que la otra no.

Merece la pena tener claro qué está haciendo la palabra, porque se siente inofensiva. *Solo* minimiza de forma preventiva — dice *esto es algo pequeño, no estoy pidiendo mucho, por favor no te molestes.* Nadie se iba a molestar. Has introducido la posibilidad y luego te has defendido de ella, en una sílaba, antes de que llegue la petición.

Merece la pena pillar a la misma familia mientras estás en ello. *Rápido* — una pregunta rápida, un favor rápido, una llamada rápida — que promete una duración que no puedes controlar y está haciendo el mismo trabajo de encogimiento. *Perdona* usado como puntuación en vez de como disculpa por algo. *Si tienes tiempo*, *no pasa nada si no*, *cuando te venga bien* — cada una de las cuales es una salida entregada antes de que nadie haya objetado.

La excepción, y es real: *solo* está bien cuando está haciendo un trabajo literal. *Lo acabo de enviar* significa hace un momento. *Solo uno* significa únicamente. Borra los que se podrían quitar sin cambiar el significado, que son casi todos.

Un ejercicio útil, una vez, en vez de como hábito permanente: busca *solo* en tus mensajes enviados. La mayoría de la gente encuentra entre veinte y cien, y el recuento es más persuasivo que cualquier argumento de aquí.

Si te quedas con una cosa: si se puede borrar sin cambiar el significado, estaba encogiendo la petición en vez de suavizarla.$md$,
  $j$[
    {
      "situation": "Has escrito solo me preguntaba si tenías un minuto.",
      "line": "¿Tienes un minuto?",
      "why": "Exactamente la misma petición, y una versión se disculpa por hacerla mientras que la otra no."
    },
    {
      "situation": "Estás a punto de ofrecer una pregunta rápida.",
      "line": "(rápido está haciendo el mismo trabajo)",
      "why": "Promete una duración que no puedes controlar y encoge la petición antes de que llegue."
    },
    {
      "situation": "Has escrito lo acabo de enviar.",
      "line": "(ese está bien)",
      "why": "Está haciendo un trabajo literal. Borra los que se podrían quitar sin cambiar el significado."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué está haciendo de verdad solo?",
      "options": [
        { "text": "Suavizar el tono.", "correct": false, "note": "Se siente como suavizar, y lo que suaviza es el tamaño de tu petición, no la manera." },
        { "text": "Hacer que fluya la frase.", "correct": false, "note": "Quitarlo casi nunca daña la frase, que es la prueba." },
        { "text": "Minimizar la petición de forma preventiva.", "correct": true, "note": "Dice esto es algo pequeño, por favor no te molestes — introduciendo una posibilidad que nadie había planteado y defendiéndose de ella en una sílaba." },
        { "text": "Señalar informalidad.", "correct": false, "note": "La informalidad viene de otro sitio, y muchos mensajes muy informales no contienen ningún solo." }
      ],
      "explain": "Si se puede borrar sin cambiar el significado, estaba encogiendo en vez de suavizando."
    },
    {
      "prompt": "¿Cuál está en la misma familia?",
      "options": [
        { "text": "Gracias, al final.", "correct": false, "note": "Calidez que no cuesta nada y no afirma nada sobre la petición. Consérvala." },
        { "text": "Para el jueves si es posible.", "correct": false, "note": "Información, no disculpa, y es lo que hace que se priorice un mensaje." },
        { "text": "Una pregunta rápida.", "correct": true, "note": "Promete una duración que no puedes controlar y hace el mismo trabajo de encogimiento — junto con no pasa nada si no, cuando te venga bien, y perdona como puntuación." },
        { "text": "Nombrar qué necesitas.", "correct": false, "note": "Lo contrario de esta familia, y lo que la familia suele esconder." }
      ],
      "explain": "Busca solo en tus mensajes enviados, una vez. El recuento es más persuasivo que cualquier argumento."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_just", "label": "Sin solo de encogimiento", "description": "Quitó los que de verdad no servían para nada." },
      { "key": "no_family", "label": "Pilló a la familia", "description": "Nada de rápido, nada de no pasa nada si no, nada de perdona como puntuación." },
      { "key": "same_ask", "label": "La petición sobrevivió", "description": "Quitarlos no cambió qué se estaba pidiendo." },
      { "key": "kept_warmth", "label": "Mantuvo la calidez genuina", "description": "Dejó el gracias." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una compañera de trabajo",
      "mood": "Ocupada.",
      "openness": 4,
      "personality": "Trata una petición encogida como poco prioritaria y le llega con el tiempo; trata una llana como una petición normal y responde con una hora."
    },
    "setting": "Necesitas quince minutos del tiempo de una compañera esta semana. Has redactado un mensaje y contiene tres solos.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con una hora concreta a una petición llana y directa.",
      "Responde de forma vaga y tarde a una petición envuelta en minimizadores.",
      "Nunca menciones la redacción."
    ],
    "opening_beat": "El borrador está en la ventana.",
    "success_looks_like": "La persona lo envía con las palabras de encogimiento quitadas."
  }$j$::jsonb,
  'Hoy, busca la palabra solo en tus mensajes enviados. Apunta cuántos encuentras, y bórrala del próximo que envíes.',
  $j${
    "says": "(tu borrador: «¡Hola! Solo me preguntaba si podrías tener solo quince minutos rápidos esta semana. Solo para repasar el tema de los informes. ¡No pasa nada si no!»)",
    "model": {
      "line": "¿Tienes quince minutos esta semana para repasar los informes? Cualquier día menos el jueves me viene bien.",
      "why": "La misma petición con cada palabra de encogimiento quitada, más algo que la hace más fácil de responder. Nada de la petición cambió excepto su tamaño aparente."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["solo", "rápida", "no pasa nada si no", "si tienes tiempo", "cuando te venga bien", "perdona", "podría ser posible", "si es posible", "un poquito"], "requirement": "Nada de palabras de encogimiento" },
      { "kind": "requires_question", "requirement": "Haz la petición" },
      { "kind": "max_words", "n": 35, "requirement": "Más corto que el borrador" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('stop-apologising', 3,
  'Preguntar no es una imposición',
  $md$Debajo de la disculpa y del *solo* hay una creencia, y a menos que se aborde, las palabras vuelven en quince días.

La creencia es que pedirle algo a alguien es quitarle algo — que su tiempo es real y el tuyo no, que la pregunta es una interrupción, y que la postura correcta para hacer una es un pequeño encogimiento.

**La jugada:** date cuenta de que las peticiones ordinarias son de lo que están hechos el trabajo y la amistad.

Considera el mismo mensaje llegando de otra persona. Un compañero te hace una pregunta directa sobre las cifras de marzo. No lo experimentas como una imposición — lo respondes, porque responderlo es el trabajo y tardó once segundos. Nadie ha sentido nunca rencor en privado por una pregunta clara, y sabes esto desde el lado receptor, donde la evidencia es inequívoca.

La asimetría es todo el asunto: las peticiones entrantes se sienten ordinarias y las salientes se sienten enormes. Eso no es un hecho sobre las peticiones.

También merece la pena fijarse en qué le pide disculparse en exceso *a ellos*, porque normalmente se plantea como consideración. Dice: tranquilízame, dime que está bien, cuida de mi ansiedad por haberte contactado. Eso es una petición más grande que la pregunta, y es la que de verdad llega primero.

El replanteamiento que se sostiene en la práctica: ser fácil de pedirle cosas es una cualidad que la gente valora, y es recíproca. Alguien que te pregunta directamente es alguien a quien puedes preguntarle directamente, y una relación en la que las dos personas se encogen ante cada petición es agotadora de mantener sin que nadie pueda decir por qué.

Dos pequeñas pruebas, si la creencia es tozuda. Fíjate en cómo te sientes sobre la última persona que te preguntó algo con llaneza — casi con toda seguridad nada en absoluto. Y fíjate en que la gente con la que más fácil te resulta trabajar no es la que más se disculpa.

Si te quedas con una cosa: ya sabes esto desde el otro lado. Las preguntas entrantes están bien, y las tuyas son del mismo tamaño que las de todo el mundo.$md$,
  $j$[
    {
      "situation": "Sientes que estás imponiendo al preguntar.",
      "line": "(¿cómo te sentiste con la última persona que te preguntó algo?)",
      "why": "Casi con toda seguridad nada en absoluto. Las peticiones entrantes se sienten ordinarias y las salientes se sienten enormes, y eso no es un hecho sobre las peticiones."
    },
    {
      "situation": "Te disculpas para ser considerado.",
      "line": "(les pide que cuiden de tu ansiedad)",
      "why": "Tranquilízame, dime que está bien — una petición más grande que la pregunta, y la que llega primero."
    },
    {
      "situation": "Te preguntas si ser directo te cuesta algo.",
      "line": "(la gente con la que más fácil te resulta no es la que más se disculpa)",
      "why": "Ser fácil de pedirle cosas es una cualidad que la gente valora, y es recíproca."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la evidencia en contra de la creencia?",
      "options": [
        { "text": "La gente dice que no le importa.", "correct": false, "note": "Sí lo dicen, y es exactamente lo que diría alguien de cualquier forma." },
        { "text": "Tienes el lado receptor, donde la evidencia es inequívoca.", "correct": true, "note": "Llega una pregunta directa y la respondes en once segundos sin experimentarla como una imposición. Ya sabes esto desde el otro lado." },
        { "text": "La mayoría de las peticiones son pequeñas.", "correct": false, "note": "Cierto, y el tamaño nunca fue lo que hacía que las salientes se sintieran enormes." },
        { "text": "Todo el mundo se pregunta cosas constantemente.", "correct": false, "note": "El volumen no es el argumento — sería igual de cierto en un mundo donde a todos les molestara." }
      ],
      "explain": "Lo entrante se siente ordinario, lo saliente se siente enorme, y esa asimetría no es sobre las peticiones."
    },
    {
      "prompt": "¿Qué pide de verdad disculparse en exceso?",
      "options": [
        { "text": "Permiso.", "correct": false, "note": "Cerca, y el permiso ya se había concedido por el hecho de que existiera la relación." },
        { "text": "Nada — es solo el envoltorio.", "correct": false, "note": "No es gratis. Se está pidiendo algo concreto y llega antes que tu pregunta." },
        { "text": "Perdón por la interrupción.", "correct": false, "note": "Esa es la intención detrás. Lo que llega es una petición de algo que requiere más esfuerzo." },
        { "text": "Tranquilidad — que cuiden de tu ansiedad primero.", "correct": true, "note": "Una petición más grande de lo que era la pregunta, planteada como consideración, y hay que gestionarla antes de que nadie pueda responder." }
      ],
      "explain": "Una relación en la que las dos personas se encogen ante cada petición es agotadora sin que nadie pueda decir por qué."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked_plainly", "label": "Preguntó con llaneza", "description": "Hizo la petición sin el encogimiento." },
      { "key": "checked_belief", "label": "Puso a prueba la creencia", "description": "La comparó con recibir la misma petición." },
      { "key": "no_reassurance", "label": "No pidió tranquilidad", "description": "No requirió gestión antes de responder." },
      { "key": "reciprocal", "label": "Se mantuvo fácil de preguntar", "description": "Directo en las dos direcciones." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nadine",
      "role": "alguien sénior con quien no has trabajado antes",
      "mood": "Eficiente, no antipática.",
      "openness": 4,
      "personality": "Responde a peticiones llanas rápido y sin ceremonia. Responde a una disculpa elaborada tranquilizando largo y tendido, que tarda más para las dos."
    },
    "setting": "Necesitas algo de alguien sénior a quien no conoces bien, y has reescrito el mensaje cuatro veces.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a una petición llana de inmediato y ve directa al contenido.",
      "Dedica tu respuesta a tranquilizar si el mensaje es muy disculpatorio, y responde solo al final.",
      "Nunca comentes el tono del mensaje."
    ],
    "opening_beat": "El cuarto borrador está ahí.",
    "success_looks_like": "La persona envía la versión llana."
  }$j$::jsonb,
  'Hoy, pídele algo a alguien sin ningún encogimiento delante. Apunta qué pediste y cómo se recibió.',
  $j${
    "beats": [
      {
        "situation": "Necesitas algo de alguien sénior con quien no has trabajado. Has reescrito el mensaje cuatro veces y sigue alargándose.",
        "prompt": "¿Cuál es la creencia debajo de la reescritura?",
        "options": [
          { "text": "Que necesitas causar una buena primera impresión.", "correct": false, "note": "Presente, y produciría un mensaje cuidadoso en vez de uno disculpatorio." },
          { "text": "Que su tiempo es real y el tuyo no.", "correct": true, "note": "Que la pregunta es una interrupción, y la postura correcta para hacer una es un pequeño encogimiento. Es la creencia que hace que vuelvan a crecer las palabras en quince días si solo se quitan las palabras." },
          { "text": "Que van a decir que no.", "correct": false, "note": "Un miedo distinto, y produce cautela sobre la respuesta en vez de disculpa por preguntar." },
          { "text": "Que deberías poder averiguarlo tú solo.", "correct": false, "note": "Real para algunas personas y es una preocupación de competencia, no de imposición." }
        ]
      },
      {
        "situation": "Estás poniendo a prueba si la creencia se sostiene.",
        "prompt": "¿Dónde está la evidencia?",
        "options": [
          { "text": "Pregúntale a un compañero si le importa que le pregunten cosas.", "correct": false, "note": "Va a decir que no, que es lo que diría alguien de cualquier forma." },
          { "text": "Envíalo y mira qué pasa.", "correct": false, "note": "Útil, y un dato que la ansiedad va a poder explicar de cualquier forma que salga." },
          { "text": "Fíjate en cómo te sientes cuando alguien te pregunta algo con llaneza.", "correct": true, "note": "Casi con toda seguridad nada en absoluto. Ya tienes el lado receptor, donde la evidencia es inequívoca — lo entrante se siente ordinario, lo saliente se siente enorme." },
          { "text": "Cuenta cuántas veces la gente se disculpa contigo.", "correct": false, "note": "Interesante, y mide lo extendido que está el hábito en vez de si está justificado." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('stop-apologising', 4,
  'La educación no es disculpa',
  $md$Quitar la disculpa a veces sobrecorrige, y el resultado se lee como brusco — que es un coste real y merece la pena resolver como es debido en vez de volviendo a poner el *perdona*.

**La jugada:** mantén la calidez y pierde el encogimiento. Son palabras distintas.

La calidez es cualquier cosa que reconoce a la otra persona y no cuesta nada decir: *gracias*, *esto ayuda mucho*, *espero que la semana vaya bien*, *no hay ningún problema* — y, más que ninguna de esas, la evidencia de que leíste lo que escribieron en vez de solo responderlo.

El encogimiento es cualquier cosa que afirma que tu petición es una carga: *perdona que te moleste*, *sé que estás liado*, *no pasa nada si lo ignoras*, *esto probablemente sea una tontería*, *sin ninguna prisa*.

Las dos parecen educación desde dentro y se comportan de forma completamente distinta. Una hace que un mensaje sea agradable de recibir. La otra hace que sea trabajo de recibir.

La colocación importa tanto como el contenido, que es la parte que a la gente se le pasa. La calidez al final se lee como calidez. Las mismas palabras al principio se leen como carraspeo, porque cualquier cosa antes de la petición se experimenta como retraso. *Gracias — esto me ahorra una hora* después de la pregunta es un regalo. La misma frase antes es un rodeo antes de llegar al grano.

Y una cosa que vale más que cualquier cortesía: responder a lo que de verdad dijeron. Una respuesta que se implica con el punto concreto de alguien se lee como cálida sea cual sea su longitud, y un mensaje largo y amistoso que lo ignora no.

Si tu franqueza de verdad cae fría con una persona concreta, el arreglo es una palabra de calidez al final en vez de una disculpa al principio. Cuesta el mismo número de caracteres y hace lo contrario.

Si te quedas con una cosa: calidez después, nada antes. La disculpa y el gracias no son el mismo acto.$md$,
  $j$[
    {
      "situation": "Tu versión directa se lee algo fría.",
      "line": "(añade un gracias al final, no un perdona al principio)",
      "why": "El mismo número de caracteres haciendo lo contrario. La calidez al final se lee como calidez; cualquier cosa antes de la petición se experimenta como retraso."
    },
    {
      "situation": "Quieres ser cálido y no estás seguro de qué palabras cuentan.",
      "line": "(gracias, esto ayuda mucho — no sé que estás liado)",
      "why": "Una los reconoce y no cuesta nada. La otra afirma que tu petición es una carga."
    },
    {
      "situation": "Quieres que el mensaje se sienta personal.",
      "line": "(responde a lo que de verdad dijeron)",
      "why": "Una respuesta que se implica con el punto concreto de alguien se lee como cálida sea cual sea su longitud, y una larga y amistosa que lo ignora no."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué separa la calidez del encogimiento?",
      "options": [
        { "text": "La duración.", "correct": false, "note": "Las dos pueden tener cuatro palabras. La duración no es lo que las distingue." },
        { "text": "Si los reconoce o afirma que eres una carga.", "correct": true, "note": "Gracias, esto ayuda mucho reconoce. Sé que estás liado afirma algo sobre tu propia petición que nadie había alegado." },
        { "text": "El tono de voz.", "correct": false, "note": "No hay tono de voz en un mensaje, que es todo un bloque aparte." },
        { "text": "Si lo dices en serio.", "correct": false, "note": "Las dos suelen decirse con sinceridad, que es por lo que la distinción tiene que ser estructural." }
      ],
      "explain": "Calidez después, nada antes. Son actos distintos con el mismo abrigo."
    },
    {
      "prompt": "¿Qué se lee más cálido que cualquier cortesía?",
      "options": [
        { "text": "Un signo de exclamación.", "correct": false, "note": "Sí suaviza las cosas, y es decoración al lado de lo que de verdad señala atención." },
        { "text": "Preguntar cómo están.", "correct": false, "note": "Agradable, y puede estar delante de un mensaje que ignoró todo lo que dijeron." },
        { "text": "Un mensaje más largo.", "correct": false, "note": "La duración se lee como esfuerzo en el mejor de los casos, y a menudo como trabajo que hay que atravesar." },
        { "text": "Responder a lo que de verdad dijeron.", "correct": true, "note": "Una respuesta que se implica con el punto concreto de alguien se lee como cálida sea cual sea su longitud. Una larga y amistosa que lo ignora no." }
      ],
      "explain": "Si tu franqueza cae fría con alguien, añade una palabra al final en vez de una disculpa al principio."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "warmth_after", "label": "Calidez al final", "description": "Mantuvo el gracias y lo movió después de la petición." },
      { "key": "no_crouch", "label": "Sin encogimiento delante", "description": "Nada que afirmara que la petición era una carga." },
      { "key": "engaged", "label": "Respondió a lo que dijeron", "description": "Respondió a su punto real." },
      { "key": "not_curt", "label": "No se leyó cortante", "description": "Directo sin ser frío." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una compañera que acaba de explicar un problema largo y tendido",
      "mood": "Algo estresada por el plazo.",
      "openness": 4,
      "personality": "Se da cuenta de inmediato de si una respuesta se implica con lo que ella dijo de verdad, y no le importan los mensajes cortos que lo hacen."
    },
    "setting": "Una compañera te ha enviado un mensaje detallado sobre un problema de plazo, y necesitas una cosa de ella en respuesta.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde bien a cualquier respuesta que se implique específicamente con el problema de las impresoras.",
      "Responde con sequedad a una respuesta amistosa que ignore lo que dijiste.",
      "Nunca preguntes si tu mensaje fue demasiado largo."
    ],
    "opening_beat": "«...así que las impresoras no pueden hacerlo antes del 14, que retrasa todo. Perdona, mensaje largo.»",
    "success_looks_like": "La persona responde a su punto, hace su petición, y pone cualquier calidez al final."
  }$j$::jsonb,
  'Hoy, envía un mensaje con la calidez al final y nada delante de la petición. Apunta la frase que moviste.',
  $j${
    "says": "...así que las impresoras no pueden hacerlo antes del 14, que retrasa todo. Perdona, mensaje largo.",
    "model": {
      "line": "El 14 va a ir justo pero es manejable. ¿Me puedes enviar el arte final para el viernes? Y gracias por presionarlos — esa no iba a ser una llamada divertida.",
      "why": "Responde a lo que ella dijo de verdad, hace la única petición, y pone la calidez al final. Cualquier cosa antes de la petición se experimenta como retraso; las mismas palabras después se leen como calidez."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Haz tu única petición" },
      { "kind": "forbids_any", "words": ["perdona por añadir", "sé que tienes mucho encima", "sin prisa", "siéntete libre de", "si tienes un minuto", "odio pedirte", "una cosa más pero"], "requirement": "Nada de encogimiento delante" },
      { "kind": "echoes_any", "words": ["14", "impresoras", "retrasa"], "requirement": "Responde a lo que ella dijo de verdad" },
      { "kind": "max_words", "n": 50, "requirement": "Corto, y cálido al final" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('stop-apologising', 5,
  'Hacer seguimiento',
  $md$Nadie respondió. Han pasado cuatro días, todavía necesitas la cosa, y el seguimiento que estás redactando tiene cuatro disculpas dentro.

**La jugada:** envía la misma petición otra vez, sin ninguna referencia al hueco.

*Vuelvo a esto — ¿todavía necesitas que se incluyan las cifras de marzo?* Ese es todo el mensaje. Nada de *perdona por presionar*, nada de *sé que estás liado*, nada de *disculpas por el segundo mensaje*, ninguno de los cuales hace que el seguimiento sea más bienvenido y todos hacen que sea más largo.

Lo que merece la pena interiorizar es qué es casi siempre una no respuesta. Alguien lo leyó en el móvil, tenía intención de gestionarlo como es debido, y subió por la pantalla. Esa es la inmensa mayoría de los mensajes sin responder — no una decisión, no una señal, y desde luego no molestia por que le hayan preguntado. Hacer seguimiento es hacerles un pequeño favor, porque lo que tenían intención de hacer ahora está de vuelta donde lo pueden ver.

Dos cosas mecánicas. Responde en el mismo hilo en vez de empezar uno nuevo, para que no tengan que encontrar el original. Y repite la petición en vez de solo recuperarla — *¿alguna idea sobre lo de abajo?* requiere desplazarse, que es exactamente el coste que hizo que se dejara la primera vez.

Merece la pena nombrar la ansiedad de presionar, porque es lo que produce las disculpas: el miedo a que un segundo mensaje sea pesado. Una vez no es ser pesado. Una vez, sobre algo a lo que accedieron o que de verdad necesitas, es completamente normal — y la gente con quien mejor se trabaja lo hace todo el tiempo.

Si dos seguimientos no producen nada, el medio ha hecho lo que podía. Muévelo — una llamada, un pasillo, o preguntarle a otra persona — y hazlo sin ninguna conclusión privada sobre qué significó el silencio, porque tampoco tienes información sobre eso.

Si te quedas con una cosa: recupéralo con llaneza. El hueco no necesita explicación, y mencionarlo es lo único que lo hace incómodo.$md$,
  $j$[
    {
      "situation": "Cuatro días, sin respuesta, y todavía lo necesitas.",
      "line": "Vuelvo a esto — ¿todavía necesitas que se incluyan las cifras de marzo?",
      "why": "La misma petición, repetida, sin ninguna referencia al hueco. Nada de disculparse por ello lo hace más bienvenido."
    },
    {
      "situation": "Te preocupa que un segundo mensaje sea pesado.",
      "line": "(una vez no es ser pesado)",
      "why": "Sobre algo a lo que accedieron o que de verdad necesitas, es completamente normal — y la gente con quien mejor se trabaja lo hace todo el tiempo."
    },
    {
      "situation": "Estás a punto de escribir ¿alguna idea sobre lo de abajo?",
      "line": "(eso les hace desplazarse)",
      "why": "Desplazarse es el coste que hizo que se dejara la primera vez. Repite la petición en vez de solo recuperarla."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué es casi siempre una no respuesta?",
      "options": [
        { "text": "Un no suave.", "correct": false, "note": "De vez en cuando, y leerlo así te impide enviar el seguimiento que te habría conseguido una respuesta." },
        { "text": "Alguien que tenía intención de gestionarlo y lo perdió.", "correct": true, "note": "Leído en el móvil, con buena intención, subió por la pantalla. Hacer seguimiento es hacerles un pequeño favor en vez de aplicar presión." },
        { "text": "Una señal de que preguntaste a la persona equivocada.", "correct": false, "note": "A veces cierto después de dos intentos. Después de uno es una conclusión infundada." },
        { "text": "Molestia por que le pregunten.", "correct": false, "note": "Extremadamente raro, y es el miedo que produce las cuatro disculpas del seguimiento." }
      ],
      "explain": "Recupéralo con llaneza. El hueco no necesita explicación."
    },
    {
      "prompt": "¿Qué hace que un seguimiento tenga más probabilidades de funcionar?",
      "options": [
        { "text": "Disculparse por presionar.", "correct": false, "note": "Lo hace más largo y pide tranquilidad, que es el impuesto de la tranquilidad llegando una segunda vez." },
        { "text": "Repetir la petición en el mismo hilo.", "correct": true, "note": "Alguna idea sobre lo de abajo requiere desplazarse, y desplazarse es exactamente el coste que hizo que se dejara la primera vez." },
        { "text": "Enviarlo a una mejor hora del día.", "correct": false, "note": "Marginal, y no es lo que determina si se gestiona." },
        { "text": "Explicar por qué lo necesitas.", "correct": false, "note": "A veces útil, y es más material delante de una petición que ya se había entendido." }
      ],
      "explain": "Dos seguimientos y nada significa cambiar de medio, sin concluir nada sobre el silencio."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "followed_up", "label": "Hizo seguimiento de verdad", "description": "Envió el segundo mensaje." },
      { "key": "no_apology", "label": "No se disculpó por presionar", "description": "Ninguna referencia al hueco." },
      { "key": "restated", "label": "Repitió la petición", "description": "No les hizo desplazarse." },
      { "key": "moved_on", "label": "Cambió de medio después de dos", "description": "No siguió enviando, y no sacó conclusiones." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una compañera que tenía intención de responder y se olvidó",
      "mood": "Desbordada, con buena intención.",
      "openness": 4,
      "personality": "De verdad se olvidó y se alegra de que se lo recuerden. Algo avergonzada por un seguimiento disculpatorio, porque le hace sentir que ha sido un problema."
    },
    "setting": "Hace cuatro días le preguntaste a una compañera si el informe necesita las cifras de marzo. Sin respuesta, y necesitas terminarlo hoy.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a un seguimiento llano de inmediato y con agradecimiento.",
      "Dedica una respuesta a disculparte tú también si el seguimiento se disculpa por presionar.",
      "Nunca respondas al mensaje original sin que te lo pidan."
    ],
    "opening_beat": "El mensaje original sigue ahí, sin responder.",
    "success_looks_like": "La persona lo recupera con llaneza con la petición repetida."
  }$j$::jsonb,
  'Hoy, haz seguimiento de un mensaje sin responder sin ninguna disculpa por el hueco. Apunta qué enviaste.',
  $j${
    "says": "(hace cuatro días preguntaste si el informe necesita las cifras de marzo. Sin respuesta, y necesitas terminarlo hoy.)",
    "model": {
      "line": "Vuelvo a esto — ¿el informe necesita las cifras de marzo?",
      "why": "La misma petición repetida, en el mismo hilo, sin ninguna referencia al hueco. Casi con toda seguridad tenían intención de responder y se les pasó, así que esto es un pequeño favor en vez de presión."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["perdona por presionar", "perdona que moleste", "disculpas por", "sé que estás liada", "odio ser pesado", "perdona por seguir", "no sé si viste", "viste mi"], "requirement": "No te disculpes por el hueco" },
      { "kind": "contains_any", "words": ["marzo", "cifras", "informe"], "requirement": "Repite la petición, no les hagas desplazarse" },
      { "kind": "max_words", "n": 25, "requirement": "Una línea, en el mismo hilo" }
    ]
  }$j$::jsonb
);
