-- Spanish: Hacer amigos, track 2 — De conocido a algo más.
--
-- Conventions as prior tracks: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partners "Alex" (lessons 1-3) and "Sam" (lesson 5) carry no `sex`
-- field; masculine agreement used by default, as established elsewhere.
-- "Priya" (lesson 4) is a name that reads unambiguously female in
-- English, unlike Robin/Sam/Alex, so feminine agreement is used for her
-- instead of the usual default — a deliberate exception, not an
-- inconsistency.

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

select pg_temp.es_lesson('first-invitation', 1,
  'Deberíamos quedar nunca ha producido nada',
  $md$Casi todo el mundo tiene tres o cuatro de estos: alguien con quien de verdad se lleva bien, a quien conoce desde hace un año o dos, y a quien nunca ha visto fuera de la sala en la que lo conoció.

No ha pasado nada malo. Os caéis bien. Los dos habéis dicho *deberíamos quedar* y lo habéis dicho en serio cada vez. Y no ha pasado, porque esa frase es un sentimiento y no un plan, y los sentimientos no meten nada en una agenda.

**La jugada:** conviértelo en algo concreto con un día fijado, o acepta que no va a pasar.

Esa es una frase más difícil de lo que parece, porque la creencia cómoda es que estas cosas se desarrollan solas con suficiente tiempo. No lo hacen. Dos años de contacto agradable en un contexto producen dos años de contacto agradable en un contexto — eso es lo que ya ha demostrado. Dejado a su aire, este arreglo es estable para siempre, y la mayoría de la gente tiene varios funcionando al mismo tiempo.

El motivo por el que se siente como que debería resolverse solo es que los dos seguís enviando señales. *Deberíamos quedar* es una señal real y se dice en serio, y como se intercambia repetidamente, los dos tenéis pruebas de que el otro está dispuesto. Lo que ninguno de los dos tiene es un jueves.

Así que lo que hay que notar es que la disposición nunca fue el ingrediente que faltaba. Nadie está esperando a que le convenzan. Alguien está esperando a que le pregunten, con una fecha, por algo concreto — y preguntar es un trámite que se ha confundido con un riesgo social.

Si te quedas con una cosa: no se va a desarrollar solo. Dos años ya son el experimento, y tienes el resultado.$md$,
  $j$[
    {
      "situation": "Os habéis dicho el uno al otro deberíamos quedar cuatro veces en dos años.",
      "line": "(ese es el experimento, y tienes el resultado)",
      "why": "Dos años de contacto agradable en un contexto han producido exactamente eso. Dejado a su aire, el arreglo es estable indefinidamente."
    },
    {
      "situation": "Estás esperando un momento natural.",
      "line": "(no va a llegar ninguno)",
      "why": "La disposición nunca faltó — los dos seguís enviando esa señal. Lo que falta es un jueves."
    },
    {
      "situation": "Se siente como un gran riesgo social preguntar.",
      "line": "(es un trámite)",
      "why": "Nadie está esperando a que le convenzan. Alguien está esperando a que le pregunten por algo concreto en un día concreto."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué deberíamos quedar nunca funciona?",
      "options": [
        { "text": "Ninguno de los dos lo dice en serio.", "correct": false, "note": "Los dos lo decís en serio, que es exactamente lo que hace que la situación sea tan estable y tan frustrante." },
        { "text": "Es un sentimiento, y los sentimientos no meten nada en una agenda.", "correct": true, "note": "La única respuesta disponible es el acuerdo, que los dos dais con sinceridad, y luego no se ha organizado nada." },
        { "text": "Los dos estáis demasiado ocupados.", "correct": false, "note": "Los dos tenéis jueves. Ocupado es lo que se dice después, no lo que lo impidió." },
        { "text": "Ninguno de los dos quiere parecer demasiado interesado.", "correct": false, "note": "Ese es el problema del siguiente bloque. Este falla antes, en la frase misma." }
      ],
      "explain": "La disposición nunca fue el ingrediente que faltaba. Un día sí lo era."
    },
    {
      "prompt": "¿Cuál es la lectura honesta de dos años de esto?",
      "options": [
        { "text": "Se está desarrollando despacio.", "correct": false, "note": "Se ha desarrollado hasta donde se desarrolla. Dos años de contacto en un contexto han producido dos años de contacto en un contexto." },
        { "text": "No está tan interesado.", "correct": false, "note": "También sigue diciéndolo él. Leerlo como desinterés es la salida cómoda y está contradicha por la evidencia." },
        { "text": "El momento no ha sido el adecuado.", "correct": false, "note": "Ha habido más o menos cien jueves. El momento no ha sido la restricción." },
        { "text": "Dejado a su aire, es estable para siempre.", "correct": true, "note": "El arreglo no va camino de ningún sitio. La mayoría de la gente tiene varios de estos funcionando a la vez, indefinidamente." }
      ],
      "explain": "No pasa nada malo, y nada va a cambiar a menos que alguien proponga un día."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "saw_it", "label": "Vio el punto muerto", "description": "Reconoció que no se va a resolver solo." },
      { "key": "no_waiting", "label": "Dejó de esperar un momento", "description": "Aceptó que no va a llegar ninguna apertura natural." },
      { "key": "admin", "label": "Lo trató como un trámite", "description": "Dejó de leer la petición como un gran riesgo social." },
      { "key": "picked", "label": "Eligió a alguien", "description": "Nombró a una persona real en vez de a la categoría." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Alex",
      "role": "alguien con quien te llevas bien desde hace dos años y a quien nunca has visto fuera de esta sala",
      "mood": "Contento de verte, como siempre.",
      "openness": 4,
      "personality": "Cálido y genuinamente dispuesto, y nunca va a proponer nada. Dice deberíamos quedar al menos una vez por conversación y lo dice en serio cada vez."
    },
    "setting": "El gimnasio, la puerta del colegio, o el pasillo — donde sea que lleves dos años viendo a esta persona. Acaba de decirlo otra vez.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Está de acuerdo con entusiasmo con cualquier sugerencia vaga y no propongas nada.",
      "Di que sí con rapidez y concreción a cualquier cosa con un día fijado.",
      "Nunca sugieras tú un plan concreto."
    ],
    "opening_beat": "«Ja — decimos esto cada semana. Deberíamos quedar de verdad en algún momento.»",
    "success_looks_like": "La persona se da cuenta de que esto no se va a resolver solo y se mueve hacia una petición concreta."
  }$j$::jsonb,
  'Hoy, nombra a una persona a la que le hayas dicho deberíamos quedar más de dos veces. Apunta quién, y cuánto tiempo lleváis así.',
  $j${
    "beats": [
      {
        "situation": "Dos años llevándote bien con alguien en el gimnasio. Los dos habéis dicho deberíamos quedar al menos cuatro veces.",
        "prompt": "¿Cuál es la lectura honesta?",
        "options": [
          { "text": "Va a algún sitio despacio.", "correct": false, "note": "Ha llegado a donde va. Dos años de contacto en un contexto han producido dos años de contacto en un contexto." },
          { "text": "Dejado a su aire, esto es estable para siempre.", "correct": true, "note": "El arreglo no va camino de ningún sitio. La mayoría de la gente tiene varios funcionando a la vez, indefinidamente." },
          { "text": "Habría sugerido algo si quisiera.", "correct": false, "note": "Sigue sugiriendo algo — eso es lo que es deberíamos quedar. Lo que ninguno de los dos ha producido es un jueves." },
          { "text": "El momento no ha cuadrado.", "correct": false, "note": "Ha habido unos cien jueves. El momento nunca fue la restricción." }
        ]
      },
      {
        "situation": "Decides hacer algo al respecto, y de inmediato se siente como un gran movimiento.",
        "prompt": "¿Qué estás a punto de hacer de verdad?",
        "options": [
          { "text": "Correr un riesgo social de verdad.", "correct": false, "note": "El planteamiento que detiene a la gente. A nadie se le está pidiendo que decida si le gustas — llevan dos años diciéndolo." },
          { "text": "Cambiar la naturaleza de la relación.", "correct": false, "note": "Estás proponiendo una hora. La naturaleza cambia después y por sí sola, si es que cambia." },
          { "text": "Averiguar si de verdad le gustas.", "correct": false, "note": "Ya sabes que sí. La disposición nunca fue el ingrediente que faltaba aquí." },
          { "text": "Un trámite.", "correct": true, "note": "Alguien está esperando a que le pregunten por algo concreto en un día concreto. Eso es todo, y se ha confundido con un riesgo." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('first-invitation', 2,
  'Nombra lo raro',
  $md$Pedirle a alguien que sea tu amigo se siente más expuesto que pedirle una cita, y merece la pena entender por qué en vez de fingir que no es cierto.

Una cita tiene un nombre, una forma y un guion. Todos los implicados saben qué se propone, qué significa, y a qué respondería la respuesta. Esto no tiene nada de eso. No hay ninguna forma de decir *¿quieres ser mi amigo?* que un adulto pueda decir sin sonar a niño, que es por lo que casi nadie dice nada y toda esta categoría sencillamente no pasa.

**La jugada:** di que es un poco raro, y luego dilo de todas formas.

*Esto es un poco raro de decir, pero siempre acabamos hablando y me encantaría hacerlo en algún sitio que no sea un pasillo.* Esa frase funciona, de forma fiable, y funciona por la primera parte, no a pesar de ella. Nombrar lo incómodo lo quita — la misma jugada que los primeros diez minutos de una cita, aplicada a un miedo distinto.

Lo que hace por la otra persona es más importante que lo que hace por ti. Casi todo el mundo está en la misma posición, con su propia lista de gente con la que se lleva bien y nunca ve, y nadie lo dice primero. Ser quien lo dice en voz alta es casi un regalo, y la reacción habitual no es incomodidad sino alivio.

Dos cosas que dejar fuera. No te expliques de más — una parte de reconocimiento, luego la propuesta, y ningún párrafo sobre lo raro que sabes que es esto. Y no hagas que se trate de la soledad, la tuya o la suya; *no tengo muchos amigos* es algo verdadero que le pone peso a la otra persona y cambia lo que se está ofreciendo.

El registro que funciona es ligero y sin rodeos, porque eso es lo que es de verdad: una sugerencia corriente con una parte honesta delante.

Si te quedas con una cosa: di que es raro, y luego dilo. El reconocimiento es lo que hace que el resto sea corriente.$md$,
  $j$[
    {
      "situation": "Quieres proponer algo y no hay ninguna palabra para ello.",
      "line": "Esto es un poco raro de decir, pero siempre hablamos y me encantaría hacerlo en algún sitio que no sea un pasillo.",
      "why": "La primera parte es lo que hace corriente a la segunda. Nombrar lo incómodo lo quita, que es la misma jugada que el principio de una cita."
    },
    {
      "situation": "Estás a punto de explicar largo y tendido por qué esto no es raro.",
      "line": "(una parte, y luego la propuesta)",
      "why": "Un párrafo de reconocimiento convierte lo raro en el tema. Dilo una vez, con ligereza, y sigue."
    },
    {
      "situation": "Tienes la tentación de explicar que no tienes muchos amigos.",
      "line": "(deja eso fuera)",
      "why": "Algo verdadero que le pone peso a la otra persona y cambia lo que se está ofreciendo, de una invitación a una necesidad."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué esto es más difícil que pedirle una cita a alguien?",
      "options": [
        { "text": "No hay ningún guion para ello.", "correct": true, "note": "Una cita tiene un nombre, una forma y una respuesta conocida. No hay ninguna frase de adulto para ¿quieres ser mi amigo?, que es por lo que casi nadie dice nada." },
        { "text": "El rechazo sería más personal.", "correct": false, "note": "Discutiblemente sería menos — un no romántico va sobre ti en concreto de una forma que esto no." },
        { "text": "Los ves con regularidad, así que sería incómodo después.", "correct": false, "note": "Una consideración real y mucho más pequeña en la práctica de lo que se siente, porque a casi nadie le importa que le pregunten." },
        { "text": "Suena necesitado.", "correct": false, "note": "Solo si lo conviertes en que necesitas amigos, que es una de las dos cosas que hay que dejar fuera." }
      ],
      "explain": "No tener guion es toda la dificultad. Que es por lo que suministrar uno — nombrarlo — hace la mayor parte del trabajo."
    },
    {
      "prompt": "¿Qué hace de verdad por la otra persona nombrar lo incómodo?",
      "options": [
        { "text": "Demuestra autoconciencia.", "correct": false, "note": "Cómo te hace quedar a ti, que no es la mitad útil." },
        { "text": "Le da una forma fácil de rechazarlo.", "correct": false, "note": "No especialmente, y esta no es una jugada sobre salidas." },
        { "text": "Hace que todo sea más ligero.", "correct": false, "note": "Cierto y vago. Di qué pasa en concreto por su lado." },
        { "text": "Casi seguro que está en la misma posición, y nadie va primero.", "correct": true, "note": "La mayoría de la gente tiene su propia lista de gente con la que se lleva bien y nunca ve. La reacción habitual es alivio en vez de incomodidad." }
      ],
      "explain": "Ser quien lo dice es casi un regalo, porque casi nadie lo hace."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named", "label": "Nombró lo raro", "description": "Lo reconoció en una parte." },
      { "key": "then_asked", "label": "Y aun así preguntó", "description": "Siguió el reconocimiento con una propuesta real." },
      { "key": "light", "label": "Lo mantuvo ligero", "description": "Una parte, no un párrafo." },
      { "key": "no_need", "label": "Dejó fuera la soledad", "description": "Ofreció algo en vez de describir una carencia." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Alex",
      "role": "alguien de la clase con quien siempre hablas",
      "mood": "Recogiendo, sin prisa.",
      "openness": 4,
      "personality": "Cálido y algo aliviado cuando se dice algo real. Responde bien a un reconocimiento ligero y se pone tenso ante una explicación larga."
    },
    "setting": "El final de una clase a la que vais los dos. Lleváis un año hablando cada semana y nunca os habéis visto en ningún otro sitio.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con calidez y facilidad a un reconocimiento ligero seguido de una propuesta.",
      "Ponte algo incómodo si la persona explica largo y tendido o menciona no tener amigos.",
      "Nunca propongas tú nada."
    ],
    "opening_beat": "«A la misma hora la semana que viene, entonces. Que vaya bien.»",
    "success_looks_like": "La persona nombra lo raro con ligereza y propone algo."
  }$j$::jsonb,
  'Hoy, di en voz alta algo verdadero y un poco incómodo, precedido de admitir que es un poco incómodo. Apunta qué pasó.',
  $j${
    "says": "A la misma hora la semana que viene, entonces. Que vaya bien.",
    "model": {
      "line": "Esto es un poco raro de decir, pero siempre acabamos hablando y me encantaría hacerlo en algún sitio que no sea un aparcamiento.",
      "why": "Una parte de reconocimiento, luego la cosa real. Nombrar lo incómodo es lo que hace corriente el resto, y a la mayoría de la gente le alivia que alguien lo dijera primero."
    },
    "checks": [
      { "kind": "contains_any", "words": ["raro", "extraño", "rarísimo", "random", "de la nada", "incómodo"], "requirement": "Nombra que es un poco raro de decir" },
      { "kind": "forbids_any", "words": ["sin amigos", "no muchos amigos", "solo", "nadie con quien", "mucho tiempo solo", "triste", "patético"], "requirement": "No hagas que se trate de necesitar amigos" },
      { "kind": "max_words", "n": 40, "requirement": "Una parte, y luego el punto" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('first-invitation', 3,
  'Pequeño, concreto, con un día',
  $md$Ya conoces esta jugada. Es la cuarta vez que esta aplicación te la pide, y tiene la misma forma cada vez porque es la única forma que produce algo.

**La jugada:** algo pequeño, algo concreto, con un día fijado.

*Hay un sitio decente de café a dos calles de aquí — ¿el jueves?* Una hora, una cosa, una pregunta, que se responde con una palabra. Compáralo con *deberíamos tomar un café un día de estos*, que le exige proponer un día, revisar su agenda y responder como es debido, y por eso recibe *sí, claro que sí* y nada más durante ocho meses.

Lo pequeño importa más aquí que en ningún otro sitio de la aplicación, y por un motivo específico de la amistad. No hay ningún nivel de intimidad establecido entre vosotros, así que una propuesta grande — toda una noche, cenar, un día entero — pide un paso que ninguno de los dos ha dado y hace que el sí sea caro. Una hora no es nada. Nadie se ha angustiado nunca por si aceptar un café.

Elige algo con un final natural, por el mismo motivo que una primera cita es una copa y no una cena. Un café, un descanso para comer, un paseo, una cerveza después de lo que ya hacéis juntos. Todo eso termina solo, lo que significa que ninguno de los dos tiene que averiguar cómo irse — y eso quita el miedo que de verdad detiene a la gente, que no es ser rechazado sino quedarse atrapado.

Usa lo que ya compartís. Lo que hacéis juntos es el puente más fácil que hay: *¿te quedas a tomar una después?* apenas es una invitación siquiera, y convierte una sala que ya compartís en la primera vez que os veis fuera de ella.

Si te quedas con una cosa: una hora, un sitio, un día. Es la misma frase que ya has aprendido, y funciona aquí exactamente por el mismo motivo.$md$,
  $j$[
    {
      "situation": "Quieres proponer algo.",
      "line": "Hay un sitio decente de café a dos calles — ¿el jueves?",
      "why": "Una hora, una cosa, una pregunta, que se responde con una palabra. Nadie se ha angustiado nunca por si aceptar un café."
    },
    {
      "situation": "Estás pensando en sugerir cenar, para que sea algo formal.",
      "line": "(eso pide un paso que ninguno de los dos ha dado)",
      "why": "Todavía no hay ningún nivel establecido entre vosotros, así que una propuesta grande hace que el sí sea caro. Una hora no es nada."
    },
    {
      "situation": "Ya hacéis algo juntos cada semana.",
      "line": "¿Te quedas a tomar una después?",
      "why": "Apenas es una invitación siquiera, y convierte una sala que ya compartís en la primera vez que os veis fuera de ella."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué importa más lo pequeño aquí que en una cita?",
      "options": [
        { "text": "La amistad tiene menos en juego.", "correct": false, "note": "No se siente con menos en juego para quien pregunta, que es por lo que existe todo este bloque." },
        { "text": "No hay ningún nivel establecido entre vosotros, así que una petición grande es cara.", "correct": true, "note": "Toda una noche pide un paso que ninguno de los dos ha dado. Una hora no pide nada en lo que nadie tenga que pensar." },
        { "text": "La gente está más ocupada con amigos que con citas.", "correct": false, "note": "Las agendas son agendas. El tamaño de la propuesta es lo que hace que el sí sea barato o caro." },
        { "text": "Es menos incómodo si sale mal.", "correct": false, "note": "Un beneficio y no el mecanismo. El mecanismo va sobre a qué se está accediendo." }
      ],
      "explain": "Una hora, un sitio, un día. Nadie se angustia por un café."
    },
    {
      "prompt": "¿Por qué elegir algo con un final natural?",
      "options": [
        { "text": "Para que no te ocupe toda la noche.", "correct": false, "note": "Conveniente y no el motivo. Mucha gente daría una noche encantada." },
        { "text": "Para poder irte si es incómodo.", "correct": false, "note": "Cerca, y lo plantea como una huida. El beneficio llega antes de que pase nada." },
        { "text": "Porque el miedo es quedarse atrapado, no ser rechazado.", "correct": true, "note": "Un café termina solo, así que ninguno de los dos tiene que averiguar cómo irse — lo que quita lo que de verdad detiene a la gente a la hora de proponer." },
        { "text": "Porque las cosas cortas son más fáciles de organizar.", "correct": false, "note": "Ligeramente, y va sobre la agenda, no sobre el miedo." }
      ],
      "explain": "El mismo motivo que una primera cita es una copa. La situación lo termina por ti."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "specific", "label": "Nombró algo concreto", "description": "Un lugar o una actividad en vez de una categoría." },
      { "key": "a_day", "label": "Puso un día", "description": "Ofreció un día real en vez de un día de estos." },
      { "key": "small", "label": "Lo mantuvo en una hora", "description": "Propuso algo en lo que nadie tiene que pensar." },
      { "key": "natural_end", "label": "Eligió algo que termina solo", "description": "Escogió algo con un final incorporado." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Alex",
      "role": "alguien de la clase con quien siempre hablas",
      "mood": "Cálido, recogiendo.",
      "openness": 4,
      "personality": "Dice que sí de inmediato a cualquier cosa con un día fijado. Responde a una sugerencia vaga con un acuerdo igual de vago y empieza a irse."
    },
    "setting": "El final de la clase otra vez. Acabas de decir lo un poco incómodo y ha respondido con calidez.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Di que sí de forma concreta y cálida a cualquier cosa con un día fijado.",
      "Responde a una sugerencia vaga con sí, deberíamos, claro, y empieza a irte.",
      "Nunca propongas tú nada."
    ],
    "opening_beat": "«Ja — sí, la verdad, me gustaría. Somos malísimos para esto.»",
    "success_looks_like": "La persona propone algo pequeño y concreto con un día fijado."
  }$j$::jsonb,
  'Hoy, invita a alguien a quien ya ves a algo con una hora, un sitio y un día fijados. Apunta qué propusiste.',
  $j${
    "says": "Ja — sí, la verdad, me gustaría. Somos malísimos para esto.",
    "model": {
      "line": "Entonces hay un sitio decente de café a dos calles de aquí — ¿el jueves, después de esto?",
      "why": "Una hora, un sitio, un día, que se responde con una palabra. Lo bastante pequeño como para que nadie tenga que sopesarlo, y termina solo."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Hazlo respondible" },
      { "kind": "contains_any", "words": ["lunes", "martes", "miércoles", "jueves", "viernes", "sábado", "domingo", "mañana", "la semana que viene", "fin de semana", "después de esto"], "requirement": "Pon un día" },
      { "kind": "forbids_any", "words": ["un día de estos", "en algún momento", "deberíamos", "organizar algo", "en la agenda"], "requirement": "Un plan, no un sentimiento" },
      { "kind": "max_words", "n": 30, "requirement": "Una frase" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('first-invitation', 4,
  'Ve a través del grupo',
  $md$Si la invitación directa es la versión difícil, aquí está la versión que casi no cuesta nada, y es la que la mayoría de la gente pasa por alto porque no se siente como hacer nada.

**La jugada:** ve a algo a lo que ya va otra gente.

Unirse a algo que ya está pasando es la invitación con menos en juego que hay, porque nadie tiene que decidir nada sobre ti. No hay propuesta, no hay sí, ningún riesgo de que una persona en concreto tenga que sopesar si quiere una hora a solas contigo. Simplemente estás ahí, que es todo el mecanismo, y produce exactamente el contacto repetido y con poco en juego sobre el que está construido todo este tema.

Di que sí a cosas que normalmente rechazarías. Las copas de cumpleaños de un compañero, la despedida, el fútbol sala que necesita a alguien, el plan de un amigo donde solo vas a conocer a una persona. Cada una de esas cosas es una hora en una sala con gente con la que de otra forma nunca acumularías tiempo — y acumular tiempo es el ingrediente.

Pide que te lleven. *¿Puedo ir a eso?* es una frase completamente corriente que la gente callada casi nunca dice, y la respuesta es casi siempre sí dicho con algo de entusiasmo, porque a la persona a la que se lo preguntas le están diciendo que su plan suena bien.

Y aquí es donde viven los amigos de amigos, que es la fuente de mayor rendimiento del tema. Contexto compartido, un entorno fácil, y alguien que en la práctica ha respondido por los dos — más ninguna explicación necesaria de por qué estás ahí, que es la parte incómoda quitada antes de que llegue.

Lo único que impide que funcione: irse pronto y hablar sobre todo con la persona con la que llegaste. Eso convierte toda la noche en una conversación privada mantenida en una sala llena de gente, y no produce nada. Llega con esa persona y luego no te quedes pegado a ella.

Si te quedas con una cosa: di que sí, y pide que te lleven. Es lo más barato de este tema y casi nadie lo hace.$md$,
  $j$[
    {
      "situation": "Un compañero menciona sus copas de cumpleaños el viernes.",
      "line": "¿Puedo ir a eso?",
      "why": "Una frase completamente corriente que la gente callada casi nunca dice, y la respuesta es casi siempre un sí entusiasta."
    },
    {
      "situation": "Solo conocerías a una persona ahí.",
      "line": "(ese es el punto — ve)",
      "why": "Una hora en una sala con gente con la que de otra forma nunca acumularías tiempo. Acumular tiempo es el ingrediente."
    },
    {
      "situation": "Estás en el plan, de pie con la persona con la que llegaste.",
      "line": "(no te quedes pegado)",
      "why": "Convierte la noche en una conversación privada mantenida en una sala llena de gente, que no produce absolutamente nada."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué unirse a un grupo es más fácil que una invitación directa?",
      "options": [
        { "text": "Hay más gente con quien hablar.", "correct": false, "note": "Más gente no es el beneficio — a menudo es la parte que intimida. El beneficio es estructural." },
        { "text": "Nadie tiene que decidir nada sobre ti.", "correct": true, "note": "Ninguna propuesta, ningún sí, y ninguna persona en concreto sopesando si quiere una hora a solas contigo. Simplemente estás ahí." },
        { "text": "Puedes irte cuando quieras.", "correct": false, "note": "Cierto y disponible en la mayoría de entornos. No es lo que hace que esto sea barato." },
        { "text": "Es menos obvio qué estás haciendo.", "correct": false, "note": "Plantearlo como ocultación. No hay nada que ocultar — ir a algo es solo ir a algo." }
      ],
      "explain": "Di que sí, y pide que te lleven. La jugada más barata del tema."
    },
    {
      "prompt": "¿Qué impide que funcione?",
      "options": [
        { "text": "No conocer a suficiente gente ahí.", "correct": false, "note": "No conocer a nadie está bien y es normal — para eso está el contexto compartido." },
        { "text": "No tener nada que decir.", "correct": false, "note": "La conversación trivial cubre esto, y en un grupo siempre hay algo en la sala que comentar." },
        { "text": "Quedarte pegado a quien llegaste con quien fuera.", "correct": true, "note": "Convierte la noche en una conversación privada mantenida en una sala llena de gente, y no produce nada." },
        { "text": "Ser el que sobra.", "correct": false, "note": "Eres nuevo, no raro, y nuevo es un estado temporal y del todo corriente en cualquier reunión." }
      ],
      "explain": "Llega con ellos, y luego no te quedes con ellos."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_yes", "label": "Dijo que sí a algo", "description": "Aceptó algo que normalmente rechazaría." },
      { "key": "asked_along", "label": "Pidió que le llevaran", "description": "Dijo puedo ir a eso." },
      { "key": "detached", "label": "No se quedó pegado", "description": "Habló con gente más allá de con quien llegó." },
      { "key": "stayed", "label": "Se quedó lo suficiente", "description": "No se fue antes de que se acumulara nada." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una compañera de trabajo hablando de su fin de semana",
      "mood": "Alegre, a mitad de una anécdota.",
      "openness": 4,
      "personality": "Encantada cuando alguien le pide ir, y no se le ocurre invitar a nadie que no lo haya pedido."
    },
    "setting": "Una compañera que te cae bien pero no conoces mucho está hablando de sus copas de cumpleaños el viernes, a las que no te han invitado y que no son exclusivas.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con alegría genuina a cualquiera que pida ir.",
      "Nunca invites tú a la persona — no se te ocurre.",
      "Sigue con la conversación si no te preguntan nada."
    ],
    "opening_beat": "«...así que somos solo unos pocos en el sitio junto a la estación el viernes. Debería estar bien.»",
    "success_looks_like": "La persona pide ir."
  }$j$::jsonb,
  'Hoy, pide ir a algo a lo que no te invitaron específicamente, o di que sí a algo que normalmente rechazarías. Apunta cuál.',
  $j${
    "beats": [
      {
        "situation": "«...así que somos solo unos pocos en el sitio junto a la estación el viernes.» No te han invitado y no es exclusivo.",
        "prompt": "¿Qué dices?",
        "options": [
          { "text": "Nada — estarías colándote.", "correct": false, "note": "No es exclusivo y te lo ha mencionado. No preguntar es cómo la gente callada se pierde lo más barato de este tema." },
          { "text": "Suena bien — espero que vaya genial.", "correct": false, "note": "Cálido, y cierra el tema. Has respondido a lo que tenía forma de invitación sin aceptarla." },
          { "text": "¿Puedo ir a eso?", "correct": true, "note": "Una frase completamente corriente que la gente callada casi nunca dice. La respuesta es casi siempre un sí entusiasta, porque le acabas de decir a alguien que su plan suena bien." },
          { "text": "Espera a ver si te invita.", "correct": false, "note": "No se le va a ocurrir. La mayoría de la gente invita a quien pregunta y nunca piensa en quién no lo hizo." }
        ]
      },
      {
        "situation": "Estás en el plan. Conoces a una persona y llevas cuarenta minutos de pie con ella.",
        "prompt": "¿Cuál es el problema?",
        "options": [
          { "text": "Nada — viniste y te quedaste, que era el objetivo.", "correct": false, "note": "Estar ahí es necesario y no suficiente. Cuarenta minutos en una conversación privada son cuarenta minutos con la sala, no en ella." },
          { "text": "Deberías haber hablado con más gente ya.", "correct": false, "note": "Instinto correcto, planteado como un objetivo de rendimiento. El problema concreto es qué está haciendo estar ahí de pie." },
          { "text": "Estás teniendo una conversación privada en una sala llena de gente.", "correct": true, "note": "No produce nada, y es la forma más común de desperdiciar una invitación de grupo. Llega con ellos, y luego no te quedes pegado." },
          { "text": "Va a pensar que dependes de ella.", "correct": false, "note": "Casi seguro que no le importa. El coste es para ti, no para ella." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('first-invitation', 5,
  'Cuando no vuelve nada',
  $md$Preguntaste, y conseguiste un sí vago y ningún seguimiento, o nada en absoluto. Este es el punto en el que la mayoría de la gente lo deja para siempre, y la lectura que sacan de ello suele ser la equivocada.

**La jugada:** pregunta una vez más, de otra forma, y luego déjalo ir sin un veredicto.

El segundo intento importa porque la causa más común de una no-respuesta no es el desinterés. Es un mensaje leído en una parada de autobús, con intención de responderlo bien más tarde, y luego enterrado. Eso pasa constantemente, a todo el mundo, y produce exactamente el mismo silencio que produce el desinterés — que es por lo que un intento no es suficiente prueba como para concluir nada.

De otra forma significa con un día concreto pegado, si el primero no lo tenía. Un número sorprendente de primeros intentos son la versión sentimiento, y el seguimiento es la primera propuesta real que has hecho. *¿Estás libre el jueves o el viernes?* es un mensaje distinto de *deberíamos tomar ese café.*

Luego déjalo ir. Sin un diagnóstico sobre ti mismo y sin un diagnóstico sobre la otra persona — alguna gente tiene una vida muy llena, alguna está en un mal año, alguna sencillamente no es organizada, y nada de eso está a tu alcance desde fuera. Dos propuestas sin responder son un no por ahora, entregado por las circunstancias y no por nadie.

Y mantente exactamente tan cálido como estabas. Esta es la parte con un coste real: vas a volver a ver a esta persona, y enfriarte con alguien porque no aceptó una invitación es visible e injusto a la vez. No se debía nada. Propusiste algo, que es algo bueno que hacer sea cual sea el resultado.

El replanteamiento que merece la pena conservar: una invitación sin responder te costó un mensaje. Invitar de menos te cuesta cada amistad que no empezaste, en silencio, durante años — y a nadie que invita de más se le ha pensado nunca mal por ello.

Si te quedas con una cosa: dos intentos, y luego déjalo estar, y no te enfríes. El coste de preguntar fue un mensaje.$md$,
  $j$[
    {
      "situation": "Propusiste algo y conseguiste un sí vago y luego nada.",
      "line": "(pregunta una vez más, con un día fijado)",
      "why": "La causa más común es un mensaje leído en una parada de autobús y enterrado, no el desinterés — y de todas formas el primer intento a menudo no tenía ningún día fijado."
    },
    {
      "situation": "Dos intentos, nada de vuelta.",
      "line": "(eso es un no por ahora, y no es culpa de nadie)",
      "why": "Alguna gente tiene una vida muy llena, alguna está en un mal año, alguna no es organizada. Nada de eso está a tu alcance desde fuera."
    },
    {
      "situation": "Los ves la semana que viene y te sientes un poco frío con ellos.",
      "line": "(no se debía nada)",
      "why": "Enfriarte con alguien por no aceptar una invitación es visible e injusto. Propusiste algo, que fue algo bueno que hacer."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué una no-respuesta no es prueba?",
      "options": [
        { "text": "La gente es educada y no le gusta rechazar.", "correct": false, "note": "A veces, y un no suave normalmente sigue teniendo palabras. Este silencio a menudo no tiene absolutamente nada." },
        { "text": "Porque un mensaje enterrado produce el mismo silencio que el desinterés.", "correct": true, "note": "Leído en una parada de autobús, con intención de responderlo bien más tarde, y luego olvidado. Le pasa a todo el mundo constantemente y se ve idéntico desde fuera." },
        { "text": "Porque puede que no lo haya visto.", "correct": false, "note": "Más raro de lo que la gente espera. Visto y enterrado es el caso habitual, y no es lo mismo que no estar interesado." },
        { "text": "Porque nunca deberías tomarte en serio un primer no.", "correct": false, "note": "Lo contrario de lo que enseña esta aplicación en cualquier otro sitio. Un no declarado es un no — esta lección va sobre la ausencia de uno." }
      ],
      "explain": "Dos intentos, el segundo con un día fijado. Luego déjalo estar."
    },
    {
      "prompt": "¿Cuál es la asimetría que merece la pena recordar?",
      "options": [
        { "text": "Ella perdió más que tú.", "correct": false, "note": "Llevar la cuenta, y es una forma de sentirse herido con pasos extra." },
        { "text": "Preguntar cuesta un mensaje; no preguntar cuesta amistades que nunca empezaste.", "correct": true, "note": "Y a nadie que invita de más se le ha pensado nunca mal por ello, mientras que invitar de menos es invisible y acumulativo." },
        { "text": "Siempre puedes volver a preguntar dentro de un año.", "correct": false, "note": "Puedes, y eso está bien hacerlo, pero no es lo que hace que esto se pueda decidir." },
        { "text": "Hay mucha otra gente.", "correct": false, "note": "Cierto y fuera de lugar, y se le escapa un poco que esta persona todavía puede resultar bien más adelante." }
      ],
      "explain": "Un mensaje. Esa fue toda la exposición."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked_twice", "label": "Preguntó una segunda vez", "description": "No trató un silencio como una respuesta." },
      { "key": "with_a_day", "label": "Hizo concreto el segundo", "description": "Le puso un día si el primero no lo tenía." },
      { "key": "let_go", "label": "Lo dejó ir después de dos", "description": "Paró sin diagnosticar a nadie." },
      { "key": "stayed_warm", "label": "Se mantuvo igual de cálido", "description": "No se enfrió con ellos después." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un viejo amigo con quien te estás escribiendo al respecto",
      "mood": "Práctico.",
      "openness": 5,
      "personality": "Pregunta qué decía de verdad el primer mensaje, y si tenía un día fijado. Sin sentimentalismo y amable."
    },
    "setting": "Hace diez días sugeriste un café. Conseguiste un sí cálido y ningún seguimiento, y los ves mañana en el plan de siempre.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta si el primer mensaje tenía un día real fijado.",
      "Cuestiona con suavidad cualquier conclusión sacada de un único silencio.",
      "Nunca le digas a la persona qué mandar."
    ],
    "opening_beat": "«Entonces nunca respondió como es debido. ¿Qué mandaste de verdad?»",
    "success_looks_like": "La persona planea un segundo intento más concreto en vez de concluir nada."
  }$j$::jsonb,
  'Hoy, manda una segunda invitación a alguien que nunca respondió a la primera. Ponle un día fijado. Apunta qué mandaste.',
  $j${
    "says": "Entonces nunca respondió como es debido. ¿Qué mandaste de verdad?",
    "model": {
      "line": "Solo que deberíamos tomar ese café. Así que voy a mandar uno como es debido — ¿estás libre el jueves o el viernes?",
      "why": "Se da cuenta de que el primer intento fue la versión sentimiento, lo que significa que el segundo es de verdad la primera propuesta. Un silencio no es prueba de nada."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["no está interesado", "claramente no", "captar la indirecta", "déjalo estar", "culpa mía", "no debería haber", "vergonzoso", "he aprendido la lección"], "requirement": "Un silencio no es un veredicto" },
      { "kind": "contains_any", "words": ["lunes", "martes", "miércoles", "jueves", "viernes", "sábado", "domingo", "la semana que viene", "fin de semana", "libre"], "requirement": "Haz concreto el segundo intento" },
      { "kind": "min_words", "n": 10, "requirement": "Di qué vas a mandar" }
    ]
  }$j$::jsonb
);
