-- Spanish: Chatear online, track 5 — No todo es un mensaje.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Priya" (lesson 1) — established feminine exception name.
-- "Sam" (lessons 2-5) carries no `sex` field; masculine agreement used
-- by default. This completes the Online chatting topic (tracks 1-5).

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

select pg_temp.es_lesson('not-everything-is-a-message', 1,
  'Tres mensajes significa llamar',
  $md$El texto es muy bueno para hechos, arreglos y pequeñas peticiones, y bastante malo para cualquier cosa con matiz. Pasada cierta complejidad, cada mensaje adicional añade ambigüedad en vez de quitarla.

El patrón es familiar. Explicas. Malinterpretan una parte. Aclaras. Malinterpretan la aclaración, de otra forma. Cuarenta minutos después tenéis un entendimiento compartido peor del que teníais al empezar, y los dos estáis levemente irritados por algo que ninguno de los dos dijo.

**La jugada:** si un tema ha llevado tres mensajes, deja de escribir y llama.

Tres es una regla general y es más o menos acertada. Una vez es una pregunta. Dos veces es una aclaración. Tres veces significa que el medio no lo está llevando, y ninguna cantidad de mejor redacción va a arreglar eso — el fallo es de ancho de banda, no de composición, y reescribir el cuarto mensaje es la forma más común en que desaparece una hora.

*Más fácil explicarlo — ¿tienes cinco minutos?* es toda la escalada. A nadie le ha importado nunca que se lo pregunten, y se recibe como alguien resolviendo un problema en vez de como alguien montando un lío.

Dos cosas que predicen una llamada de antemano, para que puedas saltarte los tres mensajes. Cualquier cosa que implique una decisión con más de dos opciones, porque comparar es lo que peor se le da al texto. Y cualquier cosa en la que sientas que estás redactando con cuidado — redactar con cuidado es una señal de que el contenido es más delicado de lo que soporta el canal.

El contraargumento que merece la pena tomarse en serio es que una llamada interrumpe y un mensaje no, que es cierto y es por lo que los mensajes son el estándar. Pero tres mensajes a lo largo de una tarde interrumpen tres veces, cuestan más atención en total, y producen menos. La llamada normalmente es la imposición menor.

Si te quedas con una cosa: tres intentos y toca llamar. Reescribir el cuarto es adonde se va la tarde.$md$,
  $j$[
    {
      "situation": "Estás redactando tu cuarto mensaje sobre el mismo tema.",
      "line": "Más fácil explicarlo — ¿tienes cinco minutos?",
      "why": "El fallo es de ancho de banda, no de composición, así que un cuarto mensaje mejor no existe. A nadie le ha importado nunca que se lo pregunten."
    },
    {
      "situation": "La decisión tiene cuatro opciones.",
      "line": "(llama — comparar es lo que peor se le da al texto)",
      "why": "Te puedes saltar los tres mensajes por completo si puedes ver la forma de antemano."
    },
    {
      "situation": "Notas que estás redactando con mucho cuidado.",
      "line": "(esa es la señal)",
      "why": "Redactar con cuidado significa que el contenido es más delicado de lo que soporta el canal."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué no funciona el cuarto mensaje?",
      "options": [
        { "text": "Han dejado de leer como es debido.", "correct": false, "note": "Están leyendo de cerca, que es parte de por qué las malinterpretaciones son tan específicas." },
        { "text": "El fallo es de ancho de banda, no de composición.", "correct": true, "note": "Pasada cierta complejidad cada mensaje añade ambigüedad en vez de quitarla, así que un cuarto mejor redactado no existe." },
        { "text": "Los dos estáis molestos para entonces.", "correct": false, "note": "A menudo cierto, y es una consecuencia del bucle, no lo que lo hace irresoluble." },
        { "text": "Se ha dicho demasiado para resumir.", "correct": false, "note": "Una llamada lo resume en treinta segundos, que es precisamente el punto." }
      ],
      "explain": "Tres intentos y toca llamar. Reescribir el cuarto es adonde se va la tarde."
    },
    {
      "prompt": "¿Qué predice una llamada antes de los tres mensajes?",
      "options": [
        { "text": "Lo importante que es el tema.", "correct": false, "note": "Muchas cosas importantes son una línea. La importancia no es con lo que le cuesta al texto." },
        { "text": "Lo bien que conoces a la persona.", "correct": false, "note": "Afecta al tono, no a si el contenido encaja en el canal." },
        { "text": "Lo larga que es la mensaje.", "correct": false, "note": "Largo es un síntoma, y un mensaje largo puede ser perfectamente claro." },
        { "text": "Más de dos opciones, o redactar con cuidado.", "correct": true, "note": "Comparar es lo que peor se le da al texto, y redactar con cuidado es una señal de que el contenido es más delicado de lo que soporta el canal." }
      ],
      "explain": "Una llamada interrumpe una vez. Tres mensajes a lo largo de una tarde interrumpen tres veces y producen menos."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "escalated", "label": "Pasó a una llamada", "description": "Dejó de escribir en el tercer intento." },
      { "key": "predicted", "label": "Lo predijo cuando pudo", "description": "Llamó primero en decisiones con varias opciones." },
      { "key": "no_fourth", "label": "No escribió el cuarto", "description": "Resistió reformularlo otra vez." },
      { "key": "framed_well", "label": "Preguntó con llaneza", "description": "Más fácil explicarlo en vez de tenemos que hablar." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una compañera de trabajo",
      "mood": "Intentándolo, algo confundida.",
      "openness": 4,
      "personality": "Malinterpreta las explicaciones escritas de esto en concreto cada vez, y lo entiende de inmediato en una llamada. Dice que sí a cinco minutos al instante."
    },
    "setting": "Tercer mensaje sobre el mismo tema y todavía no cala. Estás redactando un cuarto.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Malinterpreta cualquier explicación escrita adicional, de forma distinta cada vez.",
      "Accede a una llamada de inmediato y con calidez.",
      "Nunca sugieras tú una llamada."
    ],
    "opening_beat": "«Perdona — ¿te refieres a la versión de marzo o a la que rehicimos?»",
    "success_looks_like": "La persona sugiere una llamada en vez de escribir un cuarto mensaje."
  }$j$::jsonb,
  'Hoy, pasa una conversación a una llamada en el tercer mensaje. Apunta de qué trataba.',
  $j${
    "says": "Perdona — ¿te refieres a la versión de marzo o a la que rehicimos? (Tercer mensaje sobre el mismo tema.)",
    "model": {
      "line": "Más fácil explicarlo en voz alta — ¿tienes cinco minutos?",
      "why": "El fallo es de ancho de banda, no de composición, así que un cuarto mensaje mejor no existe. A nadie le ha importado nunca que se lo pregunten, y se lee como alguien resolviendo un problema."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Pide la llamada" },
      { "kind": "forbids_any", "words": ["lo que quiero decir es", "para aclarar", "déjame intentarlo otra vez", "básicamente lo que pasó", "la de marzo es", "como dije"], "requirement": "No lo expliques una cuarta vez" },
      { "kind": "max_words", "n": 25, "requirement": "Una línea — no vendas la llamada" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('not-everything-is-a-message', 2,
  'Las cosas difíciles no son texto',
  $md$Cualquier cosa con sentimiento dentro es la misma llamada, por un motivo más fuerte.

**La jugada:** usa un mensaje para organizar la conversación, no para tenerla.

Qué decir cuando algo es difícil pertenece a Conversaciones difíciles. La decisión de aquí viene antes que esa y es más estrecha: si un mensaje es siquiera el contenedor correcto. No lo es, y hay cuatro razones concretas en vez de una preferencia general.

**Falta el tono.** El canal le quita diez a todo, y un mensaje difícil es el peor sitio posible para gastar eso. Algo que habrías dicho con suavidad llega sin la suavidad.

**Dura.** Una conversación termina cuando termina. Un mensaje está en el móvil de alguien, y se va a releer — a las dos de la madrugada, de peor humor del que tenían cuando llegó.

**Se puede reenviar.** Lo que escribas puede que lo lea alguien para quien no lo escribiste, que cambia qué es.

**No puedes ver qué está haciendo.** En una sala te ajustas constantemente, y nada de eso está disponible. Vas a terminar de decirlo todo sin saber nunca si la primera frase cayó mal.

La excepción es real y merece la pena plantearla bien: si de verdad no puedes decirlo en voz alta, escribirlo es mejor que no decirlo. Ese es el trueque que hace también Conversaciones difíciles, y es el correcto. Mantenlo corto, deja fuera las acusaciones, y termina pidiendo hablar.

Y el híbrido es mejor que cualquiera de las dos. Un mensaje corto que nombra el tema y pide una hora, y luego la conversación en sí en persona, que es exactamente la jugada de apertura que enseña ese tema.

Si te quedas con una cosa: escribe para organizarla, habla para tenerla. Un mensaje difícil se convierte en un documento, y un documento es un objeto distinto de una conversación.$md$,
  $j$[
    {
      "situation": "Estás redactando cuatro párrafos sobre algo que te molestó.",
      "line": "(eso se convierte en un documento)",
      "why": "Dura, se relee a las dos de la madrugada de peor humor, y se puede reenviar a alguien para quien no lo escribiste."
    },
    {
      "situation": "Quieres los beneficios de escribir y hablar.",
      "line": "Un mensaje corto que nombra el tema y pide una hora.",
      "why": "La parte escrita hace lo que escribir hace bien, y la conversación pasa donde existen el tono y la respuesta."
    },
    {
      "situation": "De verdad no puedes decirlo en voz alta.",
      "line": "(entonces escríbelo, corto, y pide hablar al final)",
      "why": "Conseguir decirlo de forma imperfecta gana a no decirlo. Deja fuera las acusaciones y mantenlo breve."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué coste es específico de escribir en vez de de la dificultad?",
      "options": [
        { "text": "Es incómodo.", "correct": false, "note": "Igual de cierto de la conversación, que es por lo que la gente recurre al mensaje." },
        { "text": "Se relee a las dos de la madrugada.", "correct": true, "note": "Una conversación termina cuando termina. Un mensaje está en el móvil de alguien de peor humor del que tenían cuando llegó." },
        { "text": "Podrían no estar de acuerdo.", "correct": false, "note": "Podrían no estarlo en cualquiera de los dos medios, y el desacuerdo no es lo que añade el canal." },
        { "text": "Tarda más en componerse.", "correct": false, "note": "Un coste para ti, y el más pequeño de la lista." }
      ],
      "explain": "Escribe para organizarla, habla para tenerla."
    },
    {
      "prompt": "¿Cuándo es escribirlo la decisión correcta?",
      "options": [
        { "text": "Cuando quieres que quede constancia.", "correct": false, "note": "A veces necesario en el trabajo, y querer que quede constancia cambia lo que es la conversación." },
        { "text": "Cuando es demasiado serio para una llamada.", "correct": false, "note": "La seriedad aboga por la sala, donde puedes ver qué está haciendo." },
        { "text": "Cuando si no, no lo vas a decir en absoluto.", "correct": true, "note": "Conseguir decirlo de forma imperfecta gana a no decirlo — el mismo trueque que hace Conversaciones difíciles, y es el correcto." },
        { "text": "Cuando son difíciles de contactar.", "correct": false, "note": "Un problema de organización, y aboga por organizar una hora en vez de por escribir el contenido." }
      ],
      "explain": "Y luego: corto, sin acusaciones, y termina pidiendo hablar."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "arranged", "label": "Escribió para organizar", "description": "Usó el mensaje para conseguir una hora." },
      { "key": "not_the_substance", "label": "No envió el contenido", "description": "Mantuvo el contenido difícil fuera de lo escrito." },
      { "key": "short", "label": "Mantuvo corto lo escrito", "description": "Sin párrafos, sin listas, sin acusaciones." },
      { "key": "got_it_said", "label": "Lo dijo de alguna forma", "description": "No usó la regla como excusa para no hacer nada." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo al que le has enseñado el borrador",
      "mood": "Cuidadoso.",
      "openness": 5,
      "personality": "Pregunta cómo se leería en un mal día y quién más podría verlo. No sugiere nada directamente."
    },
    "setting": "Has redactado un mensaje largo sobre algo que hizo un amigo que te molestó.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta cómo se leería a las dos de la madrugada.",
      "Tómate en serio la posibilidad de que escribir sea la única forma de que pase.",
      "Nunca le digas a la persona que lo envíe o no lo envíe."
    ],
    "opening_beat": "«Cuatro párrafos. ¿Cuándo crees que van a leer esto?»",
    "success_looks_like": "La persona lo reduce a un mensaje que organiza una conversación."
  }$j$::jsonb,
  'Hoy, coge algo difícil que ibas a escribir y envía en su lugar un mensaje que organice una conversación. Apunta las dos cosas.',
  $j${
    "says": "(has redactado cuatro párrafos sobre algo que hizo un amigo que te molestó)",
    "model": {
      "line": "¿Estás libre para tomar algo esta semana? Hay algo de lo que quiero hablar contigo — nada dramático.",
      "why": "Escrito para organizarla en vez de para tenerla. Un mensaje de cuatro párrafos se convierte en un documento que dura, se relee a las dos de la madrugada, y se puede reenviar."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Pide una hora" },
      { "kind": "forbids_any", "words": ["me hiciste sentir", "me dolió mucho", "siempre", "nunca", "la forma en que", "no fue justo", "no puedo creer", "deberías haber"], "requirement": "No envíes el contenido por escrito" },
      { "kind": "max_words", "n": 35, "requirement": "Dos líneas" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('not-everything-is-a-message', 3,
  'Un silencio no es un mensaje',
  $md$Dos ticks grises, cuatro horas, y nada. Aquí es donde una persona callada pasa más tiempo que en cualquier otra cosa de este tema, y casi no hay ninguna información dentro.

**La jugada:** trata un hueco como un hecho sobre su día.

Alguien lo abrió en un ascensor. Alguien tenía intención de responder como es debido y le llamaron a algo. Alguien lo leyó mientras sujetaba un café y se le perdió pantalla arriba. Cada una de esas produce el mismo silencio que ser ignorado, y cada una es más probable.

Cuatro horas no son una señal. Un día rara vez es una señal. Incluso tres días normalmente es una semana ocupada en vez de una decisión, y el número de veces que un silencio ha significado de verdad lo que alguien temía es muy pequeño comparado con el número de veces que se ha examinado.

Lo que hace esto costoso no es la espera, es la construcción. En el hueco, se construye una historia — sobre qué dijiste, cómo debió de leerse, qué está pensando — y se ensambla sin ninguna evidencia en absoluto, que es precisamente por lo que puede crecer. Nada dentro es comprobable, así que nada dentro tiene límite.

La señal delatora de que estás construyendo en vez de esperando: la historia empeora con el tiempo. La información real no hace eso.

Se siguen dos reglas. No mandes un segundo mensaje a un silencio — un segundo mensaje antes de que se responda al primero añade presión y ninguna información, y se lee como ansiedad en vez de como recordatorio. Espera un día, y luego haz seguimiento con llaneza, que ya cubrió el primer bloque.

Y fíjate en qué te está costando el silencio en vez de qué significa. Una tarde pasada comprobando un móvil es un coste real, pagado por algo que se va a resolver solo para el jueves con una disculpa sobre una semana ocupada.

Si te quedas con una cosa: el hueco no contiene nada. Lo que sea que hayas encontrado dentro, lo pusiste tú.$md$,
  $j$[
    {
      "situation": "Cuatro horas, dos ticks grises, nada.",
      "line": "(un hecho sobre su día)",
      "why": "Abierto en un ascensor, con intención de responder como es debido, perdido pantalla arriba. Cada caso ordinario produce el mismo silencio que ser ignorado."
    },
    {
      "situation": "Has averiguado qué debe de estar pensando.",
      "line": "(has construido eso desde la nada)",
      "why": "Nada dentro es comprobable, que es exactamente por lo que puede crecer. La señal delatora es que empeora con el tiempo."
    },
    {
      "situation": "Estás a punto de enviar un segundo mensaje.",
      "line": "(eso añade presión y ninguna información)",
      "why": "Se lee como ansiedad en vez de como recordatorio. Espera un día, y luego haz seguimiento con llaneza."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cómo distingues construir de esperar?",
      "options": [
        { "text": "Construir se siente ansioso.", "correct": false, "note": "Las dos cosas se sienten así, que lo hace inútil como prueba en el momento." },
        { "text": "La historia empeora con el tiempo.", "correct": true, "note": "La información real no hace eso. Cualquier cosa ensamblada sin evidencia no tiene nada que la limite." },
        { "text": "Construir implica releer tu mensaje.", "correct": false, "note": "Un síntoma común, y mucho de ello pasa sin releer nada." },
        { "text": "Empiezas a redactar un seguimiento.", "correct": false, "note": "Un seguimiento es algo razonable que redactar. La señal delatora es qué le pasa a la historia, no a tu bandeja de salida." }
      ],
      "explain": "El hueco no contiene nada. Lo que sea que hayas encontrado dentro, lo pusiste tú."
    },
    {
      "prompt": "¿Por qué no mandar un segundo mensaje?",
      "options": [
        { "text": "Parece necesitado.", "correct": false, "note": "Cómo se ve, y la objeción mecánica es más fuerte." },
        { "text": "Se van a sentir culpables.", "correct": false, "note": "Algunos sí, levemente, y la culpa no es el coste que se describe." },
        { "text": "Podría molestarles.", "correct": false, "note": "Rara vez lo hace. El problema es qué añade, no qué provoca." },
        { "text": "Añade presión y ninguna información.", "correct": true, "note": "Se lee como ansiedad en vez de como recordatorio — y el original sigue ahí, sin responder, por los mismos motivos que antes." }
      ],
      "explain": "Espera un día, y luego haz seguimiento con llaneza, sin ninguna referencia al hueco."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_meaning", "label": "No leyó nada en ello", "description": "Trató el hueco como un hecho sobre su día." },
      { "key": "no_construction", "label": "No construyó una historia", "description": "Notó que la historia empeoraba y paró." },
      { "key": "no_double", "label": "No mandó un segundo mensaje", "description": "Esperó antes de hacer seguimiento." },
      { "key": "cost", "label": "Notó el coste", "description": "Vio cuánto valía la tarde de comprobar." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo con quien lo estás hablando",
      "mood": "Sereno.",
      "openness": 5,
      "personality": "Pregunta cuál es la historia ahora comparada con hace dos horas, y nota en qué dirección se ha movido."
    },
    "setting": "Enviaste algo hace seis horas. Se ha leído. No ha vuelto nada y lo has comprobado once veces.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta cuál era la teoría hace dos horas y si ha empeorado.",
      "Acepta no lo sé como una buena respuesta.",
      "Nunca ofrezcas una explicación para el silencio."
    ],
    "opening_beat": "«¿Qué crees que significa, entonces?»",
    "success_looks_like": "La persona nota que la historia está fabricada y para."
  }$j$::jsonb,
  'Hoy, fíjate en un silencio que hayas estado interpretando. Escribe la teoría, y luego escribe la versión aburrida. Apunta las dos.',
  $j${
    "beats": [
      {
        "situation": "Seis horas, leído, nada de vuelta. Lo has comprobado once veces y ahora tienes una teoría bastante detallada.",
        "prompt": "¿Cuál es la señal delatora de que la teoría está fabricada?",
        "options": [
          { "text": "Involucra algo que dijeron hace semanas.", "correct": false, "note": "Un síntoma de una bien desarrollada, y llega tarde en vez de ser la señal delatora." },
          { "text": "Ha empeorado durante las seis horas.", "correct": true, "note": "La información real no hace eso. Cualquier cosa ensamblada sin evidencia no tiene nada que la limite, que es por lo que solo puede crecer." },
          { "text": "No puedes dejar de pensar en ello.", "correct": false, "note": "Cierto también de los problemas reales, así que no distingue las dos cosas." },
          { "text": "Nadie más está de acuerdo con ella.", "correct": false, "note": "Probablemente no lo hayas preguntado, y preguntar conseguiría una respuesta amable en vez de una útil." }
        ]
      },
      {
        "situation": "Estás redactando un segundo mensaje hacia el silencio.",
        "prompt": "¿Qué añade?",
        "options": [
          { "text": "Un recordatorio, que es útil.", "correct": false, "note": "El original sigue ahí y sigue visible. Nada de un segundo mensaje hace que el primero sea más fácil de responder." },
          { "text": "Claridad, si lo reformulas.", "correct": false, "note": "No había nada poco claro. El hueco es sobre su día, no sobre tu redacción." },
          { "text": "Presión, y ninguna información.", "correct": true, "note": "Se lee como ansiedad en vez de como recordatorio — y el primer mensaje sigue sin responder por exactamente los mismos motivos que antes." },
          { "text": "Nada de cualquier forma.", "correct": false, "note": "No es neutro. Se lee, y lo que comunica no es lo que pretendías." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('not-everything-is-a-message', 4,
  'El tiempo de respuesta no es un marcador',
  $md$La otra mitad de la misma ansiedad, y corre en las dos direcciones: lo rápido que respondes tú, y lo rápido que te responden a ti.

**La jugada:** deja de tratar la velocidad de respuesta como una medida de nada.

Del lado receptor, la aritmética que hace la gente es notablemente concreta — respondieron en doce minutos ayer y cuatro horas hoy, así que algo ha cambiado. Nada ha cambiado. El tiempo de respuesta es una función de dónde estaba alguien, qué estaba haciendo y cómo tenía configurado el móvil, y eso varía enormemente de un día a otro por motivos que no tienen nada que ver contigo.

Del lado del envío hay una trampa relacionada: igualar. Esperar deliberadamente porque ellos esperaron, para no parecer demasiado disponible. Es la misma regla de turnos que estanca las amistades en Hacer amigos, y produce el mismo resultado — dos personas gestionando una competición imaginaria en vez de organizar algo.

Responde cuando lo veas y puedas. Si eso es al instante, al instante está bien. Nadie ha pensado nunca peor de alguien por responder rápido, y la creencia de que podría hacerlo es una de las piezas de folclore más duraderas de toda esta área.

El único sitio donde la velocidad importa de verdad es que una respuesta rápida es una pequeña amabilidad cuando alguien está esperando algo — una decisión, un plan, una respuesta que les desbloquea. Eso va sobre su situación, no sobre la relación, y merece la pena ser rápido por ese motivo.

Y un retraso que no puedes evitar merece la pena nombrarlo, porque no cuesta nada y elimina una incógnita. *Solo puedo responder a esto bien mañana* tarda cuatro segundos y convierte un silencio en un plan.

Si te quedas con una cosa: responde cuando puedas, y no leas nada en cuándo respondan ellos. No hay ningún marcador, y la única persona que lleva uno eres tú.$md$,
  $j$[
    {
      "situation": "Respondieron en doce minutos ayer y cuatro horas hoy.",
      "line": "(eso es dónde estaban, no qué cambió)",
      "why": "El tiempo de respuesta varía enormemente de un día a otro por motivos que no tienen nada que ver contigo."
    },
    {
      "situation": "Estás esperando antes de responder para no parecer demasiado disponible.",
      "line": "(esa es la regla de turnos otra vez)",
      "why": "Produce dos personas gestionando una competición imaginaria en vez de organizar algo."
    },
    {
      "situation": "No puedes responder bien hasta mañana.",
      "line": "Solo puedo responder a esto bien mañana.",
      "why": "Cuatro segundos, y convierte un silencio en un plan."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué mide de verdad el tiempo de respuesta?",
      "options": [
        { "text": "Dónde estaba alguien y qué estaba haciendo.", "correct": true, "note": "Varía enormemente de un día a otro por motivos que no tienen nada que ver contigo, que es por lo que la aritmética de doce minutos contra cuatro horas encuentra patrones que no existen." },
        { "text": "Cuánto quieren hablar contigo.", "correct": false, "note": "La lectura que produce la ansiedad, y la contradice lo mucho que varía para la misma persona en la misma semana." },
        { "text": "Lo ocupados que están en general.", "correct": false, "note": "Incluso eso es demasiado estable. Va sobre una hora concreta, no sobre un estado general." },
        { "text": "Lo importante que era tu mensaje.", "correct": false, "note": "Lo barato de responder lo afecta — el segundo bloque — y eso va sobre el mensaje, no sobre ti." }
      ],
      "explain": "No hay ningún marcador, y la única persona que lleva uno eres tú."
    },
    {
      "prompt": "¿Cuándo importa de verdad la velocidad?",
      "options": [
        { "text": "Cuando quieres parecer entusiasta.", "correct": false, "note": "Gestión de la impresión, y nadie ha pensado nunca peor de alguien por responder rápido." },
        { "text": "Cuando te respondieron rápido a ti.", "correct": false, "note": "Igualar es la regla de turnos, y produce una competición a la que ninguno de los dos accedió." },
        { "text": "Cuando alguien está bloqueado esperando tu respuesta.", "correct": true, "note": "Una decisión, un plan, algo sin lo que no pueden seguir adelante. Eso va sobre su situación, no sobre la relación." },
        { "text": "En el trabajo, siempre.", "correct": false, "note": "Demasiado amplio, y es cómo la gente acaba respondiendo todo al instante y nada bien." }
      ],
      "explain": "Y nombra un retraso inevitable — cuatro segundos convierten un silencio en un plan."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_arithmetic", "label": "No hizo aritmética", "description": "No comparó tiempos de respuesta." },
      { "key": "no_matching", "label": "No igualó", "description": "Respondió cuando pudo en vez de cuando estaba igualado." },
      { "key": "quick_where_needed", "label": "Rápido donde alguien estaba bloqueado", "description": "Priorizó según su situación." },
      { "key": "named_delay", "label": "Nombró un retraso inevitable", "description": "Convirtió un silencio en un plan." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo con quien lo estás hablando",
      "mood": "Práctico.",
      "openness": 5,
      "personality": "Pregunta cuál es el plan y señala cuándo implica llevar la cuenta."
    },
    "setting": "Alguien que normalmente responde en menos de una hora ha tardado casi un día entero. Estás decidiendo cómo responder, y si esperar tú también un rato.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Nómbralo con llaneza cuando un plan implique llevar la cuenta.",
      "Alégrate con una decisión de simplemente responder.",
      "Nunca expliques por qué la otra persona podría haber sido lenta."
    ],
    "opening_beat": "«¿Así que ahora vas a hacerlos esperar a ellos?»",
    "success_looks_like": "La persona responde cuando puede, sin igualar ni medir."
  }$j$::jsonb,
  'Hoy, responde a algo en el momento en que lo veas, sin esperar a estar igualado. Apunta cuánto habrías esperado.',
  $j${
    "says": "¿Así que ahora vas a hacerlos esperar a ellos?",
    "model": {
      "line": "No — simplemente voy a responder cuando lo vea. Eso de emparejar los tiempos es un juego al que ninguno de los dos accedió a jugar.",
      "why": "Igualar es la regla de turnos que estanca las amistades en Hacer amigos, y produce el mismo resultado: dos personas gestionando una competición imaginaria en vez de organizar algo."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["hacerlos esperar", "dejarlo un rato", "igualar", "demasiado disponible", "demasiado entusiasta", "ellos esperaron", "darle unas horas", "emparejarlo"], "requirement": "No lleves la cuenta" },
      { "kind": "min_words", "n": 8, "requirement": "Di qué vas a hacer de verdad" },
      { "kind": "max_words", "n": 35, "requirement": "Una decisión, no una estrategia" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('not-everything-is-a-message', 5,
  'El envío de las once',
  $md$Los mensajes escritos tarde por la noche son mensajes distintos, y de forma fiable son peores en una dirección concreta.

Tarde, cansado y solo, una cosa pequeña parece grande, una respuesta ambigua parece fría, y la frase que normalmente cortarías parece necesaria. Lo que escribas entonces se va a leer mañana por alguien a la luz del día, y va a caer más pesado de lo que pretendías — que es un trueque raro, porque la versión que habrías escrito a las nueve de la mañana era la que de verdad querías enviar.

**La jugada:** escríbelo a las once, envíalo a las nueve.

Redáctalo si redactar ayuda, y normalmente ayuda. Lo que estás quitando es el envío, no la redacción. Casi todas las apps de mensajería ahora programan el envío, y si no, la app de notas y un copia-pega por la mañana hace el mismo trabajo.

La prueba de la mañana es todo el mecanismo, y casi nunca se equivoca: léelo a la luz del día y o lo envías tal cual, o notas que has editado un tercio. El tercio que cortas es la parte que añadió la hora.

Se aplica a más que a mensajes difíciles. Las explicaciones largas se hacen más largas por la noche. Los seguimientos se vuelven más disculpatorios. Cualquier cosa con sentimiento dentro consigue más de él. Y el bucle de tres mensajes de la primera lección corre más rápido a medianoche, cuando las dos personas están menos capacitadas para sostener un tema con claridad.

También hay una mitad de cortesía. Un mensaje que llega a las once le pone una pequeña decisión a alguien que ha dejado de trabajar o se va a dormir — responder ahora, o dejarlo y recordarlo. Programarlo es una amabilidad que cuesta un toque.

La excepción es obvia y merece la pena conservarla: si de verdad es urgente, envíalo. Esto va sobre los mensajes que se sienten urgentes a las once y no lo son.

Si te quedas con una cosa: escríbelo ahora, envíalo a las nueve. La versión que borras por la mañana es la versión que escribió la hora.$md$,
  $j$[
    {
      "situation": "Son las once y has escrito algo sobre lo que sientes fuerte.",
      "line": "(prográmalo para las nueve)",
      "why": "Estás quitando el envío, no la redacción. La versión que habrías escrito por la mañana es la que de verdad querías enviar."
    },
    {
      "situation": "Lo relees por la mañana y cortas un tercio.",
      "line": "(ese tercio era la hora)",
      "why": "La prueba de la mañana casi nunca se equivoca. Lo que quitas es lo que añadió la hora de la noche."
    },
    {
      "situation": "Es tarde y un tema ha llevado tres mensajes.",
      "line": "(ese bucle corre más rápido a medianoche)",
      "why": "Las dos personas están menos capacitadas para sostener un tema con claridad, que es la peor condición posible para la tarea más débil del medio."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué cambia de verdad la hora tardía?",
      "options": [
        { "text": "Tu juicio sobre qué es importante.", "correct": true, "note": "Una cosa pequeña parece grande, una respuesta ambigua parece fría, y la frase que normalmente cortarías parece necesaria." },
        { "text": "Tu gramática.", "correct": false, "note": "Normalmente bien. El problema es qué se incluye, no cómo se escribe." },
        { "text": "Lo honesto que eres.", "correct": false, "note": "La honestidad no es la variable. La proporción sí." },
        { "text": "Si te apetece molestarte.", "correct": false, "note": "Lo contrario — la gente escribe más por la noche, no menos." }
      ],
      "explain": "Escríbelo a las once, envíalo a las nueve."
    },
    {
      "prompt": "¿Cuál es la prueba de la mañana?",
      "options": [
        { "text": "Si todavía quieres enviarlo.", "correct": false, "note": "Cerca, y normalmente sigues queriendo. Lo que importa es qué cambias por el camino." },
        { "text": "Si se lee como enfadado.", "correct": false, "note": "Una cosa que añade la hora. Hay una versión más general." },
        { "text": "Si editas un tercio.", "correct": true, "note": "Léelo a la luz del día y o lo envías tal cual o notas qué cortas — y el tercio que cortas es lo que añadió la hora." },
        { "text": "Si lo dirías en voz alta.", "correct": false, "note": "Una buena prueba general para mensajes y no la que suministra esta lección." }
      ],
      "explain": "Y se aplica también a explicaciones largas y seguimientos disculpatorios, no solo a mensajes difíciles."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "scheduled", "label": "Lo retuvo hasta la mañana", "description": "Lo escribió y no lo envió." },
      { "key": "morning_test", "label": "Aplicó la prueba de la mañana", "description": "Lo releyó a la luz del día y notó la edición." },
      { "key": "courtesy", "label": "No lo hizo caer a las once", "description": "Dejó en paz la tarde de alguien." },
      { "key": "urgent_exception", "label": "Envió cosas genuinamente urgentes", "description": "No usó la regla para evitar enviar nada." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo al que le estás escribiendo en su lugar",
      "mood": "También despierto hasta muy tarde.",
      "openness": 5,
      "personality": "Pregunta qué cambiaría si se enviara a las nueve, y si hay algo dentro que sea de verdad urgente."
    },
    "setting": "Las once y cuarto de la noche. Has escrito algo sobre lo que sientes fuerte y tienes el pulgar sobre el botón de enviar.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué se perdería específicamente esperando nueve horas.",
      "Acepta la urgencia genuina como una respuesta real si se argumenta.",
      "Nunca le digas a la persona qué hacer con el mensaje."
    ],
    "opening_beat": "«¿Qué pasa si lo envías a las nueve de mañana en su lugar?»",
    "success_looks_like": "La persona lo retiene hasta la mañana."
  }$j$::jsonb,
  'Hoy, escribe un mensaje tarde y prográmalo para la mañana. Apunta qué cambiaste cuando lo releíste.',
  $j${
    "beats": [
      {
        "situation": "Las once y cuarto. Has escrito algo sobre lo que sientes fuerte y tienes el pulgar sobre enviar.",
        "prompt": "¿Qué haces?",
        "options": [
          { "text": "Envíalo — lo has escrito ahora y es honesto.", "correct": false, "note": "Es honesto a las once y cuarto. Se va a leer a la luz del día y va a caer más pesado de lo que pretendías, que no es el mensaje que querías enviar." },
          { "text": "Bórralo y olvídalo.", "correct": false, "note": "Sobrecorregir. Escribirlo es útil — es el envío lo que hay que retener." },
          { "text": "Córtalo por la mitad y envía eso.", "correct": false, "note": "El instinto correcto a la hora equivocada. No puedes saber qué mitad a las once y cuarto." },
          { "text": "Guárdalo y envíalo a las nueve.", "correct": true, "note": "Escríbelo ahora, envíalo por la mañana. Lo que editas a la luz del día es lo que añadió la hora." }
        ]
      },
      {
        "situation": "Son las nueve de la mañana y lo estás releyendo.",
        "prompt": "¿Qué estás buscando?",
        "options": [
          { "text": "Si todavía quieres enviarlo.", "correct": false, "note": "Normalmente sí. Lo que importa es qué cambias entre ahora y el envío." },
          { "text": "Cuánto cortas.", "correct": true, "note": "El tercio que quitas a la luz del día es la parte que escribió la hora, y notarlo es todo el mecanismo." },
          { "text": "Si se lee como enfadado.", "correct": false, "note": "Una cosa que añade la hora entre varias — la versión general cubre también explicaciones largas y seguimientos disculpatorios." },
          { "text": "Si el tono es correcto.", "correct": false, "note": "El tono es todo un bloque aparte, y esta prueba va sobre proporción, no sobre calidez." }
        ]
      }
    ]
  }$j$::jsonb
);
