-- Spanish: Interviews, track 8 — Sueldo y ofertas.
--
-- Conventions as migration 109. Money needed decisions:
--
-- **"Base" becomes "el fijo".** It is what a Spanish employee calls the part
-- of the package that is not bonus, and it keeps the ask short — "¿hay algo de
-- flexibilidad en el fijo?" is the same eight-word sentence the English has.
-- The theory glosses it once as "el salario base" and then uses "el fijo".
--
-- **The concrete figures are rescaled to Spain.** Sixty-five to seventy-five
-- thousand pounds is not a number a reader in Madrid recognises for a
-- mid-level role, and an example that reads as fantasy teaches nothing. The
-- abstract arithmetic in lesson 1 keeps the English numbers, because it is
-- stated without a currency there too and is a sum rather than a salary.
--
-- **No gendered adjectives in the offer call.** "Estoy contento" would tell
-- the reader what they are, so the model line uses "me alegro mucho".

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

select pg_temp.es_lesson('interview-money', 1,
  'Ten dos números antes de hablar',
  $md$Casi todas las malas conversaciones de sueldo se pierden antes de empezar, por alguien que no ha decidido qué piensa.

Dos números, calculados de antemano, en una habitación tranquila, cuando no hay nada en juego.

**El número de mercado.** Lo que paga este trabajo, en este sitio, a este nivel, ahora mismo. Fuentes: gente que hace el trabajo, gente de selección que lo coloca, estudios salariales de tu sector, ofertas que publican banda. Triangula: todas y cada una de las fuentes están sesgadas, y tres fuentes sesgadas suelen bastar para encontrar el centro.

**El número de retirada.** La cifra por debajo de la cual dirías que no. Este es privado, no se dice nunca en voz alta a nadie del proceso, y es el más importante de los dos. Existe para una sola cosa: impedir que negocies contra ti mismo a las nueve de la noche, cuando llega una oferta y te sientes agradecido.

**La jugada:** decide el número de mercado y el número de retirada antes de que nadie te pregunte nada.

Hacen falta los dos porque hacen trabajos distintos. El número de mercado es lo que dices. El número de retirada es con lo que decides.

Dos errores comunes. Poner el número de retirada en lo que ganas ahora, que importa la valoración que hizo de ti tu último empleador a la decisión de una empresa nueva. Y sacar el número de mercado de lo que gana un amigo, que es una muestra de uno y normalmente el amigo que estaba lo bastante contento como para mencionarlo.

Apunta los dos en algún sitio donde puedas verlos durante una llamada. Suena excesivo hasta la primera vez que oyes un número más bajo del que esperabas y notas la velocidad a la que una postura bien razonada se disuelve en querer que la conversación termine.$md$,
  $j$[
    {
      "situation": "Triangular un número de mercado a partir de tres fuentes imperfectas.",
      "line": "Dos ofertas con el mismo título publican banda, una reclutadora me ha dicho a cuánto ha colocado gente este trimestre, y sé más o menos lo que gana un amigo en la competencia. Las tres coinciden dentro de un diez por ciento, así que voy a usar el centro de eso.",
      "why": "No se fía de ninguna fuente por separado, que es lo correcto, porque todas están sesgadas en una dirección conocida. Que tres coincidan es una prueba mucho más fuerte que la seguridad de una."
    },
    {
      "situation": "Fijar un número de retirada que no sea el sueldo actual.",
      "line": "Ahora gano X, y no voy a usar eso como suelo. El suelo es el número por debajo del cual preferiría quedarme donde estoy, y con el desplazamiento que hay, resulta que está algo por encima de lo que habría supuesto.",
      "why": "Separa lo que te pagan de lo que aceptarías, que son hechos sin relación. Meter el desplazamiento en la cuenta es el tipo de pensamiento correcto: el número de retirada va del trato entero, no solo del sueldo."
    },
    {
      "situation": "Tener los números a la vista durante la llamada.",
      "line": "[un pósit en la pantalla, fuera de plano: la banda de mercado, y una cifra subrayada]",
      "why": "Trivial, y es lo más eficaz de toda esta lección. Un número que puedes ver es un número que no tienes que recordar con el pulso acelerado."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué el número de retirada no debería decirse nunca en voz alta?",
      "options": [
        { "text": "Porque es más bajo que el número de mercado, y nombrarlo te deja ahí.", "correct": true, "note": "En el momento en que se dice un suelo, se convierte en el techo. Existe para informar tus decisiones, no su oferta." },
        { "text": "Porque parecería inflexible.", "correct": false, "note": "Enunciar un mínimo no es ser inflexible, es sencillamente poco inteligente. El problema es lo que le hace al número con el que acabas." },
        { "text": "Porque puede cambiar durante el proceso.", "correct": false, "note": "A veces cambia, según vas conociendo el puesto. Eso es un motivo para revisarlo en privado, no para callarlo." }
      ],
      "explain": "Un número es para decirlo. El otro es para decidir. Confundirlos es el error más caro de todo este tema."
    },
    {
      "prompt": "¿Qué tiene de malo basar tus expectativas en tu sueldo actual?",
      "options": [
        { "text": "Nada: es el dato más concreto que tienes.", "correct": false, "note": "Es concreto y es la medición de otra cosa: lo que un empleador pagó por un puesto que ya tenías." },
        { "text": "Suele estar desactualizado.", "correct": false, "note": "A menudo cierto y no es el fondo del asunto. Incluso un sueldo actual acordado el mes pasado refleja la decisión equivocada." },
        { "text": "Importa la valoración de tu último empleador a la decisión de una empresa nueva.", "correct": true, "note": "El puesto nuevo tiene su propio precio de mercado, fijado por lo que vale este trabajo aquí. Tu historia no es una prueba sobre eso." },
        { "text": "Es confidencial y no debería compartirse.", "correct": false, "note": "Un punto aparte y legítimo sobre qué revelar. No explica por qué el número es una mala base para tu propio razonamiento." }
      ],
      "explain": "Pon precio al puesto, no a tu historia. Lo que te pagaban es un dato sobre un sitio del que te vas."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "market_number", "label": "Tenía un número de mercado", "description": "Supo enunciar una banda investigada para el puesto, con más de una fuente." },
      { "key": "walk_away", "label": "Tenía un suelo privado", "description": "Había decidido una cifra de retirada y no la reveló." },
      { "key": "not_anchored_on_history", "label": "Puso precio al puesto", "description": "Las expectativas se basaban en el precio de mercado del puesto y no en su sueldo actual." },
      { "key": "composure", "label": "Sostuvo la postura", "description": "No revisó el número a la baja sobre la marcha solo para que la cosa resultara cómoda." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Lena Hoffmann",
      "role": "una reclutadora interna que saca el tema del sueldo en los primeros diez minutos",
      "mood": "Eficiente y cercana. Quiere que esto sea sencillo.",
      "openness": 3,
      "personality": "Agradable y práctica. Pregunta pronto por las expectativas porque se ha quemado con desajustes tardíos. Acepta una banda investigada sin discutir; hurga en una vaga."
    },
    "setting": "Una llamada temprana en la que el dinero sale antes de lo esperado, antes de que el candidato haya decidido qué decir.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si la persona da una respuesta vaga, vuelve a preguntar con más precisión, una vez.",
      "Si nombra una banda con un motivo, acéptala y sigue adelante sin confirmar si está dentro de la vuestra.",
      "Si menciona su sueldo actual, haz una repregunta neutra sobre él y anótalo.",
      "Nunca le digas si su número era alto o bajo."
    ],
    "opening_beat": "«Antes de seguir, quiero comprobar que estamos en el mismo orden de magnitud para que ninguno de los dos pierda una tarde. ¿Qué estás buscando?»",
    "success_looks_like": "La persona da una banda investigada con un motivo detrás, no se ancla en su sueldo actual, y no se habla a sí misma hacia abajo."
  }$j$::jsonb,
  'Averigua lo que paga de verdad tu trabajo, en dos fuentes que no sean la una la otra. Luego di la banda en voz alta a alguien y apunta si pudiste decirla sin encogerte y sin disculparte.',
  $j${
    "beats": [
      {
        "situation": "Tienes una llamada de criba dentro de una hora y va a salir el dinero.",
        "prompt": "¿Qué necesitas tener decidido antes de descolgar?",
        "options": [
          { "text": "El número de mercado y el número por debajo del cual dirías que no.", "correct": true, "note": "Dos números, los dos decididos estando tranquilo. Todo lo que sale mal en esta conversación sale mal porque alguien está haciendo cuentas en directo." },
          { "text": "Lo que ganas ahora, más un aumento razonable.", "correct": false, "note": "Ancla toda la negociación a un número que no tiene nada que ver con este puesto, y si estás mal pagado lo arrastra hacia delante." },
          { "text": "El número más alto que podrías decir sin reírte.", "correct": false, "note": "Un número que no puedes justificar es uno que vas a abandonar a la primera pregunta, que es peor que no decir ninguno." },
          { "text": "Nada: primero mira qué ofrecen.", "correct": false, "note": "Vale como táctica e inútil como preparación. Pueden preguntar ellos primero, y entonces estás decidiendo en tiempo real." }
        ]
      },
      {
        "situation": "El número de mercado es ochenta. Tu número de retirada es sesenta y ocho. Ofrecen setenta y dos.",
        "prompt": "¿Para qué sirve el número de retirada?",
        "options": [
          { "text": "Para saber que setenta y dos es una decisión y no un rescate.", "correct": true, "note": "Existe para que distingas una oferta aceptable de una soportable mientras alguien espera al teléfono. Setenta y dos está por encima del suelo, así que puedes negociar desde la calma." },
          { "text": "Para decirles el mínimo que vas a aceptar.", "correct": false, "note": "No se dice nunca en voz alta. En el momento en que lo oyen, es la oferta." },
          { "text": "Para decidir automáticamente: por encima, aceptar.", "correct": false, "note": "Es un suelo, no una regla. Setenta y dos pasa el suelo y sigue estando ocho por debajo del número de mercado." },
          { "text": "Para calcular cuánto pedir.", "correct": false, "note": "Ese es el trabajo del número de mercado. El de retirada existe para el otro extremo." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-money', 2,
  'Cuando preguntan ellos primero',
  $md$*¿Cuáles son tus expectativas salariales?* llega pronto, a menudo en la primera llamada, y el instinto es o decir un número bajo para ir sobre seguro o negarse a responder. Hay tres jugadas honestas y cada una es la correcta en circunstancias distintas.

**Da una banda investigada, con el motivo.** *Estoy mirando entre cuarenta y dos y cuarenta y ocho mil para este nivel de puesto en esta ciudad, por lo que he visto anunciado y por dos conversaciones con gente de selección.* El motivo es lo que convierte un número en una postura. Un número solo se puede discutir a la baja; un número con pruebas detrás hay que discutírselo.

**Pregunta cuál es la banda.** *¿Tenéis banda para el puesto?* Perfectamente normal, se responde con frecuencia, y no cuesta nada. Muchas empresas publican bandas por dentro y simplemente te lo dicen.

**Esquiva, una vez.** *Preferiría entender bien el puesto primero, ¿podemos volver a ello?* Esto funciona exactamente una vez. Una segunda esquiva se lee como juego y empieza a irritar.

**La jugada:** di una banda investigada con su motivo, o pide la suya, y no esquives nunca dos veces.

El consejo de que quien habla primero pierde es casi siempre falso para un candidato. Es cierto en una negociación entre iguales con información simétrica. En una contratación, la empresa conoce la banda y tú no, así que negarte a entrar normalmente solo retrasa una conversación que vas a tener igualmente, con menos buena voluntad.

Dos concreciones. Si das una banda, prepárate para que te ofrezcan su suelo, así que el suelo de la banda que digas debería ser un número que aceptarías de verdad. Y no des nunca una banda cuyo techo no puedas justificar; la pregunta *¿por qué esa cifra?* va a llegar, y tener una respuesta es casi toda la batalla.

Si no te dicen la banda y te aprietan para que des un número, da la banda. La asimetría de información no se va a resolver sola, y ponerse difícil cuesta más de lo que gana.$md$,
  $j$[
    {
      "situation": "Una banda con su razonamiento pegado.",
      "line": "Estoy trabajando con una banda de entre cuarenta y dos y cuarenta y ocho mil. Sale de tres ofertas con el mismo título en la misma ciudad y de una conversación con una reclutadora que coloca este puesto, así que es un número de mercado y no un deseo.",
      "why": "El motivo es lo que hace el trabajo. Ese «número de mercado y no un deseo» se adelanta a la suposición de que la cifra es aspiracional, y una banda investigada es muy difícil de discutir a la baja."
    },
    {
      "situation": "Pedir la banda primero, con ligereza.",
      "line": "Encantado de darte un número. ¿Hay banda para el puesto? Igual nos ahorra un paso a los dos.",
      "why": "Acepta responder antes de preguntar, lo que quita cualquier sensación de evasiva. Como la mitad de las veces te dan la banda, y entonces estás respondiendo con mucha mejor información."
    },
    {
      "situation": "Esquivar exactamente una vez, y cumplirlo.",
      "line": "¿Puedo volver a eso cuando entienda el alcance? … [más tarde] … Antes me has preguntado por el dinero. Por lo que has descrito, estaría mirando la mitad alta de la banda que te dije.",
      "why": "La esquiva se cumple sin que haga falta volver a preguntar, y eso es lo que hace que aterrice como genuina y no como táctica. Volver a ello por tu cuenta te deja además fijar un número informado por lo que has aprendido."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Alguien de selección te pregunta por tus expectativas en los primeros cinco minutos. ¿Cuál suele ser la mejor respuesta?",
      "options": [
        { "text": "Negarte hasta saber más: quien habla primero pierde.", "correct": false, "note": "Esa regla viene de negociaciones con información simétrica. En una contratación ellos conocen la banda y tú no, así que negarse sobre todo retrasa e irrita." },
        { "text": "Preguntar si hay banda, y dar una banda investigada si no la hay.", "correct": true, "note": "No cuesta nada, a menudo te dan el número, y si no, has respondido con honestidad y con pruebas pegadas." },
        { "text": "Decir que eres flexible para la oportunidad adecuada.", "correct": false, "note": "Se lee como no tener criterio, y lo van a poner a prueba: la siguiente oferta que veas estará en el suelo de la banda." },
        { "text": "Dar tu sueldo actual como referencia.", "correct": false, "note": "Ancla toda la conversación en lo que otra persona decidió que valías, para otro trabajo." }
      ],
      "explain": "Entra, con pruebas. Negarse a responder es una estrategia prestada de otro tipo de negociación."
    },
    {
      "prompt": "Dices una banda. ¿Qué deberías dar por hecho que va a pasar?",
      "options": [
        { "text": "Que ofrecerán algo por el medio.", "correct": false, "note": "Optimista. Casi todas las ofertas caen en el suelo de la banda dicha o cerca, porque es lo que la banda permitía." },
        { "text": "Que ofrecerán el suelo.", "correct": true, "note": "Dalo por hecho, y pon el suelo de tu banda en un número que aceptarías de verdad. El suelo de una banda es un compromiso, con la intención que fuera." },
        { "text": "Que la ignorarán y ofrecerán el punto medio de su banda.", "correct": false, "note": "Pasa donde las bandas son rígidas, y no es algo con lo que contar al decidir qué decir." }
      ],
      "explain": "El suelo de tu banda es el número que has aceptado. Elígelo como si fuera la única cifra que dijiste."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "engaged", "label": "Entró en la pregunta", "description": "Respondió o pidió la banda en vez de bloquear." },
      { "key": "reasoned_range", "label": "Dio un motivo", "description": "Cualquier cifra vino con pruebas detrás." },
      { "key": "acceptable_floor", "label": "El suelo era real", "description": "El suelo de la banda que dijo era un número que aceptaría de verdad." },
      { "key": "one_deflection", "label": "Esquivó como mucho una vez", "description": "No evitó la pregunta repetidamente." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Ryan Tulloch",
      "role": "un reclutador de agencia que necesita una cifra para sus notas",
      "mood": "Con algo de presión de su cliente para cualificar bien a los candidatos.",
      "openness": 3,
      "personality": "Cercano e insistente. No va a dar la banda si no se la piden directamente. Vuelve a la pregunta del dinero una segunda vez si la primera respuesta fue vaga."
    },
    "setting": "Una llamada de criba en la que quien criba tiene instrucciones de conseguir una cifra antes de agendar la siguiente fase.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si te preguntan directamente si hay banda, da una: un rango plausible para el puesto.",
      "Si la persona es vaga o esquiva, vuelve a la pregunta del dinero una vez más, con más franqueza.",
      "Si nombra un sueldo actual, repítelo en voz alta como si lo estuvieras apuntando.",
      "Nunca digas si su número está dentro o fuera de la banda."
    ],
    "opening_beat": "«Una cosa que tengo que preguntar antes de poder presentarte: ¿qué tipo de paquete estás buscando?»",
    "success_looks_like": "La persona o pide la banda o da una banda investigada con un motivo, y no nombra su sueldo actual ni una cifra con la que estaría descontenta."
  }$j$::jsonb,
  'Di tu banda y el motivo que hay detrás en voz alta a alguien, como si te lo acabaran de preguntar. Apunta si le añadiste al final una disculpa o un matiz sin querer.',
  $j${
    "says": "Una cosa que tengo que preguntar antes de poder presentarte: ¿qué tipo de paquete estás buscando?",
    "model": {
      "line": "Estoy mirando entre cuarenta y cinco y cincuenta y cinco mil, basándome en lo que se ha anunciado este año para puestos comparables. Si el resto del paquete es poco habitual, encantado de mirarlo en conjunto.",
      "why": "Una banda con el motivo pegado, lo que la convierte en una postura y no en una esperanza. La segunda frase deja la puerta abierta sin mover el número."
    },
    "checks": [
      { "kind": "contains_any", "words": ["basándome en", "porque", "mercado", "comparable", "comparables", "anunciado", "he mirado", "puestos similares"], "requirement": "Da el motivo junto con el número" },
      { "kind": "max_sentences", "n": 3, "requirement": "Tres frases como mucho" },
      { "kind": "min_words", "n": 15, "requirement": "Lo suficiente como para que se lea como una postura" }
    ],
    "maxChars": 500
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-money', 3,
  'La petición después de la oferta',
  $md$El momento en que se hace una oferta es el único momento de todo el proceso en el que tu palanca es real, y dura como un día.

Todo lo anterior eras tú compitiendo. Ahora han elegido, le han dicho que no a otros candidatos, y la persona que hizo la oferta tiene muchísimas ganas de dejar de buscar. Eso no es un arma y no hace falta que lo sea. Simplemente significa que una petición razonable probablemente se conceda, y que pedir es normal.

Toda la técnica es una frase y un silencio.

*Gracias, me alegro mucho. ¿Hay algo de flexibilidad en el fijo?*

Y luego deja de hablar.

Es una pregunta, no una exigencia, así que nadie tiene que defender nada. Y el silencio de después es de donde sale la respuesta. Casi todos los candidatos que pierden dinero aquí lo pierden rellenando esa pausa: explicando, justificándose, diciendo por adelantado que no pasa nada si no.

**La jugada:** pregunta si hay flexibilidad, y luego no digas nada hasta que respondan.

Tres costumbres que lo sostienen.

**Da las gracias primero y en serio.** El entusiasmo y la negociación no son opuestos, y la versión de esto que sale mal es la que suena a decepción.

**Pídelo por escrito, y tómate una noche.** Nada de lo que ganas aceptando por teléfono compensa lo que pierdes por no pensar. *¿Me lo puedes mandar? Me gustaría leerlo con calma y contestarte mañana* es completamente estándar y a nadie le han retirado una oferta por eso.

**Una petición, no tres rondas.** Pide, escucha la respuesta, decide. Una negociación que va y viene cuatro veces gasta buena voluntad que vas a necesitar tu primer día.

Si la respuesta es no, no pasa nada. No has perdido nada: la oferta no se evapora por haber preguntado, y una empresa que la retiraría por eso te ha contado algo útil muy barato.$md$,
  $j$[
    {
      "situation": "La petición, entera.",
      "line": "Es una noticia estupenda, gracias, me alegro mucho de verdad. ¿Te puedo preguntar si hay algo de flexibilidad en el fijo? [silencio]",
      "why": "Cálido, breve, y termina en una pregunta sin nada detrás. El silencio es la técnica; todo lo que un candidato añada aquí es una concesión hecha antes de que nadie la pidiera."
    },
    {
      "situation": "Comprar una noche sin sonar dubitativo.",
      "line": "¿Me lo puedes mandar por escrito? Me gustaría leerlo con calma y contestarte mañana por la mañana. No lo estoy paseando por ahí, es que no quiero decir que sí a algo que solo he oído una vez.",
      "why": "Quita el miedo a que los estés usando de palanca, que es lo que pone nerviosas a las empresas con un retraso. El motivo que da es honesto y del todo razonable."
    },
    {
      "situation": "Aceptar un no con elegancia y cerrar.",
      "line": "Entendido, gracias por mirarlo. Entonces sí: me gustaría aceptar.",
      "why": "Una petición, una respuesta limpia, una decisión inmediata. Esto es lo que hace que pedir no cueste nada, y por eso a quien pregunta una vez se le recuerda como resolutivo y no como difícil."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Preguntas si hay flexibilidad en el fijo. Se hace una pausa. ¿Qué deberías hacer?",
      "options": [
        { "text": "Decir que lo entiendes si no la hay.", "correct": false, "note": "Es la frase más cara de la conversación. Has respondido a tu propia pregunta, a su favor, antes de que dijeran nada." },
        { "text": "Explicar tu razonamiento para preguntarlo.", "correct": false, "note": "La pregunta no necesitaba justificación. Rellenar la pausa con motivos les invita a evaluar los motivos en vez de responder." },
        { "text": "Nada. Esperar a que hablen.", "correct": true, "note": "La pausa es donde ocurre el movimiento. Quien hable después concede, y no tienes por qué ser tú." },
        { "text": "Decir una cifra concreta para hacerlo tangible.", "correct": false, "note": "A veces es una repregunta razonable si te preguntan qué tenías en mente. Ofrecerla dentro de un silencio descarta la posibilidad de que su número sea mejor que el tuyo." }
      ],
      "explain": "Pregunta, y para. Casi todo el dinero que se pierde en esta fase se pierde en los cuatro segundos posteriores a la pregunta."
    },
    {
      "prompt": "¿Es arriesgado pedir tiempo para pensarse una oferta por escrito?",
      "options": [
        { "text": "Sí: la duda puede hacerles dudar de tu entusiasmo.", "correct": false, "note": "Un miedo casi universal y no pasa casi nunca, sobre todo si has dicho con claridad que te alegras." },
        { "text": "Sí, si tienen otros candidatos esperando.", "correct": false, "note": "Normalmente acaban de decirles que no. Una noche de espera no reabre eso." },
        { "text": "No: es lo estándar, y es la única forma de leer lo que estás aceptando.", "correct": true, "note": "Las ofertas son documentos con detalles dentro. Leer uno antes de firmarlo es lo que se espera, no una señal." }
      ],
      "explain": "Una noche no cuesta nada y te compra la única hora con la cabeza fría de todo el proceso."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "thanked_first", "label": "Empezó con calidez", "description": "Expresó alegría genuina antes de plantear nada." },
      { "key": "asked_the_question", "label": "Preguntó por la flexibilidad", "description": "Hizo la petición, con claridad, como pregunta y no como exigencia." },
      { "key": "held_the_silence", "label": "Sostuvo el silencio", "description": "No rellenó la pausa posterior a la pregunta." },
      { "key": "took_the_time", "label": "Se lo llevó para leerlo", "description": "Pidió la oferta por escrito y tiempo para pensarla." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Alison Kerr",
      "role": "la responsable de contratación, haciendo ella misma la oferta",
      "mood": "Cálida y esperanzada. Acaba de dedicar dos semanas a este proceso y le gustaría que terminara.",
      "openness": 4,
      "personality": "Contenta y algo nerviosa: quiere que esto sea un sí. Tiene un margen pequeño en el fijo y lo usará si se lo piden, pero no lo ofrece nunca por su cuenta."
    },
    "setting": "Una llamada de teléfono a primera hora de la tarde. Quien contrata llama personalmente con buenas noticias.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si te preguntan por la flexibilidad, haz una pausa antes de responder — escribe la vacilación dentro — y luego ofrece una mejora modesta.",
      "Si la persona rellena el silencio con tranquilizaciones o justificaciones, cógelo: di que el número está cerrado y sigue adelante.",
      "Acepta sin problema mandarlo por escrito y darle la noche para decidir.",
      "Nunca le aconsejes cómo negociar."
    ],
    "opening_beat": "«Tengo buenas noticias: nos gustaría ofrecerte el puesto. El equipo fue unánime, que no pasa a menudo. El fijo estaría en la cifra de la que hablamos.»",
    "success_looks_like": "La persona da las gracias con calidez, pregunta una vez por la flexibilidad, sostiene el silencio de después, y pide la oferta por escrito antes de decidir."
  }$j$::jsonb,
  'Practica la frase en voz alta con alguien: da las gracias, pregunta si hay flexibilidad, y luego quédate en silencio hasta que responda. Apunta cuánto aguantaste antes de hablar.',
  $j${
    "says": "El fijo estaría en la cifra de la que hablamos.",
    "model": {
      "line": "Gracias, me alegro mucho de verdad. ¿Hay algo de flexibilidad en el fijo?",
      "why": "Calidez, luego la petición, luego nada. Toda la técnica es el silencio de después, y el motivo para que sea corta es que una pregunta larga te da sitio para seguir hablando."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Pregunta, y para" },
      { "kind": "max_words", "n": 25, "requirement": "Menos de veinticinco palabras. La herramienta es el silencio de después." },
      { "kind": "forbids_any", "words": ["lo entiendo si", "no pasa nada", "solo por saber", "perdona", "lo siento", "espero que no", "sin problema si"], "requirement": "No te disculpes por preguntar" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-money', 4,
  'Todo lo que no es el fijo',
  $md$El fijo es el número que todo el mundo negocia y a menudo el que menos margen tiene, porque va dentro de una banda que aprobó otra persona. El resto del paquete suele ser más flexible y casi nadie lo pide.

Lo que suele estar disponible.

**La fecha de incorporación.** Lo más barato de mover y vale dinero de verdad si te quedan vacaciones por coger o querías un hueco.

**Las vacaciones.** A veces las fija una política, a veces no, y a menudo son posibles como días sin sueldo adicionales incluso donde los pagados son rígidos.

**Una prima de entrada.** Común donde la banda es de verdad inflexible, porque sale de otro presupuesto y no sienta precedente para el sueldo de nadie más.

**La forma de trabajar.** Días en la oficina, horario, semana comprimida. Es la petición que más ha cambiado en los últimos años y se concede con frecuencia.

**Cuándo se revisa el sueldo.** Una revisión a los seis meses en vez de a los doce, por escrito. Esta es la silenciosa: hoy no le cuesta nada a la empresa, así que se acepta a menudo, y cambia lo que pasa el año que viene.

**El cargo.** Gratis, y afecta más a tu siguiente trabajo que a este.

**La jugada:** si el fijo no se mueve, pregunta qué sí puede moverse.

Dilo exactamente en esos términos. *Entiendo que el fijo está cerrado. ¿Hay flexibilidad en alguna otra cosa?* Es una pregunta cooperativa: has aceptado su restricción y les has invitado a resolver el problema contigo, y a la gente le gusta que le pidan ayuda.

Dos advertencias. Pide una o dos cosas, no una lista; una lista convierte una conversación en una negociación y cambia la temperatura. Y consigue que cualquier cosa acordada quede escrita en la carta de oferta, con amabilidad y sin suspicacia: *¿te importaría poner la fecha de revisión en la carta, solo para que no se pierda cuando en noviembre se nos haya olvidado a los dos?* Los acuerdos verbales sobreviven al jefe que los hizo aproximadamente nunca.$md$,
  $j$[
    {
      "situation": "Redirigir tras un no rotundo en el fijo.",
      "line": "Perfecto, entiendo que la banda es la banda. ¿Hay flexibilidad en alguna otra cosa, la fecha de incorporación, o cuándo se revisa?",
      "why": "Acepta su restricción en voz alta, lo que baja la temperatura, y luego nombra dos cosas concretas en vez de hacer una pregunta abierta. Las peticiones concretas se responden; las abiertas reciben una respuesta vaga."
    },
    {
      "situation": "Pedir la fecha de revisión en vez de más dinero ahora.",
      "line": "¿Podríamos acordar una revisión a los seis meses en vez de a los doce, y ponerlo en la carta? Si para entonces valgo más, es una conversación fácil, y si no, no se ha prometido nada.",
      "why": "Hoy no le cuesta nada a la empresa, y por eso se concede tan a menudo, y cómo está planteado lo hace fácil de aceptar. La segunda frase quita cualquier sensación de estar acorralando a nadie."
    },
    {
      "situation": "Conseguir que un acuerdo verbal quede escrito sin insinuar desconfianza.",
      "line": "¿Te importaría ponerlo en la carta de oferta? Puramente porque en primavera esta conversación se nos habrá olvidado a los dos.",
      "why": "El motivo que da es la memoria y no la desconfianza, lo cual es verdad y además deja a todo el mundo con su dignidad. Los jefes se mueven, y un acuerdo que solo existe en una llamada se mueve con ellos."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "El fijo está cerrado de verdad. ¿Qué petición tiene más probabilidades de concederse?",
      "options": [
        { "text": "Un cargo más sénior.", "correct": false, "note": "Gratis en dinero y con frecuencia limitado por los niveles internos, lo que lo hace más difícil de lo que parece." },
        { "text": "Una revisión salarial más temprana, escrita en la carta.", "correct": true, "note": "Este año no cuesta nada, que es el presupuesto que alguien está defendiendo de verdad. Es una de las peticiones que más fiablemente se conceden." },
        { "text": "Más días de vacaciones pagadas.", "correct": false, "note": "A menudo fijados por una política para toda la empresa, porque concederlo una vez le crea un problema con todos los demás." },
        { "text": "Una semana de cuatro días.", "correct": false, "note": "Cada vez más posible y sigue siendo una petición mucho mayor de lo que suena: cambia el sueldo y la cobertura del equipo a la vez." }
      ],
      "explain": "Pide lo que no cuesta nada del presupuesto de este año. Ahí es donde vive la flexibilidad."
    },
    {
      "prompt": "¿Cómo debería plantearse una petición que no sea de sueldo?",
      "options": [
        { "text": "Como una lista, para que elijan lo más fácil.", "correct": false, "note": "Una lista se lee como la apertura de una negociación y no como una petición, y les invita a conceder lo más pequeño y dar el asunto por cerrado." },
        { "text": "Como una o dos peticiones concretas, después de aceptar su restricción en voz alta.", "correct": true, "note": "Reconocer la restricción lo vuelve colaborativo, y las peticiones concretas reciben respuestas concretas donde las preguntas abiertas reciben vaguedades." },
        { "text": "Como una pregunta abierta sobre qué más sería posible.", "correct": false, "note": "Educado y normalmente respondido con «no mucho». Nombrar lo que quieres se lo pone muchísimo más fácil para decir que sí." }
      ],
      "explain": "Acepta el muro, y luego pregunta por la puerta. Y nombra la puerta."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "accepted_the_constraint", "label": "Aceptó la restricción", "description": "Reconoció en voz alta que el fijo estaba cerrado antes de pedir nada más." },
      { "key": "specific_asks", "label": "Nombró cosas concretas", "description": "Pidió una o dos cosas concretas en vez de abrir una negociación general." },
      { "key": "chose_well", "label": "Pidió lo que era conseguible", "description": "Priorizó peticiones que le cuestan poco a la empresa en el año en curso." },
      { "key": "in_writing", "label": "Lo consiguió por escrito", "description": "Pidió que lo acordado apareciera en la carta de oferta, sin insinuar desconfianza." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Femi Adebayo",
      "role": "un responsable de contratación cuyas bandas salariales se fijan de forma central y de verdad no se pueden mover",
      "mood": "Algo frustrado por el candidato. Pagaría más si pudiera.",
      "openness": 4,
      "personality": "Directo y un poco disculpándose por la restricción. Tiene margen real sobre la fecha de incorporación, la forma de trabajar y cuándo se revisa, y lo usará si se lo piden en concreto."
    },
    "setting": "Una llamada de seguimiento al día siguiente de una oferta, donde el fijo ya se ha confirmado como no negociable.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Aguanta firme en el fijo ante cualquier presión. De verdad no se puede mover.",
      "Si te preguntan por una alternativa concreta — fecha de incorporación, forma de trabajar, cuándo se revisa — acéptala o negóciala con calidez.",
      "Si te hacen una pregunta abierta sobre qué más es posible, responde con vaguedad: «no estoy seguro, ¿qué tenías en mente?».",
      "Nunca sugieras alternativas por tu cuenta si la persona no ha preguntado antes por alguna."
    ],
    "opening_beat": "«Lo he preguntado, y me temo que la respuesta es no: las bandas se fijan de forma central y no puedo hacer nada con el fijo. Espero que eso no cambie las cosas.»",
    "success_looks_like": "La persona acepta la restricción con elegancia, nombra una o dos alternativas concretas, y pide que lo acordado quede escrito en la oferta."
  }$j$::jsonb,
  'Pregúntale a alguien qué negoció aparte del sueldo en su último trabajo, y qué le habría gustado pedir. Apunta lo único que no se te había ocurrido.',
  $j${
    "beats": [
      {
        "situation": "«Las bandas se fijan de forma central y no puedo hacer nada con el fijo.»",
        "prompt": "¿Qué pides?",
        "options": [
          { "text": "Qué más se puede mover: fecha de incorporación, días, presupuesto, cargo, cuándo se revisa.", "correct": true, "note": "Que el fijo esté cerrado suele ser verdad y casi nunca es todo el paquete. La pregunta que viene detrás es qué más, y muy rara vez se rechaza de plano." },
          { "text": "Nada. Un no en el fijo es un no.", "correct": false, "note": "Tratar un componente cerrado como una oferta cerrada. El fijo es lo menos flexible de casi cualquier paquete." },
          { "text": "Insistir una vez más en el fijo para tantearlo.", "correct": false, "note": "Has tenido una respuesta clara con un motivo. Insistir gasta buena voluntad en el único componente que te han dicho que está bloqueado." },
          { "text": "Pedir una prima de entrada en concreto.", "correct": false, "note": "Una sola buena idea en vez de una pregunta abierta. Preguntar qué se puede mover les deja ofrecer lo que de verdad tienen." }
        ]
      },
      {
        "situation": "Te ofrecen una semana más de vacaciones y una revisión temprana a los seis meses.",
        "prompt": "¿Qué merece la pena dejar atado?",
        "options": [
          { "text": "La revisión, por escrito, y contra qué se revisa.", "correct": true, "note": "Las vacaciones son reales el día que empiezas. Una revisión es una promesa sobre una conversación, y vale lo que valgan sus criterios." },
          { "text": "Nada: ya tienes lo que pediste.", "correct": false, "note": "Tienes una cosa que es real y otra que depende enteramente de quién siga ahí dentro de seis meses." },
          { "text": "Pedir las dos más la subida original del fijo.", "correct": false, "note": "Reabrir un componente después de que se hayan movido en otros dos es como una buena negociación se vuelve memorable, en el mal sentido." },
          { "text": "La semana extra, porque las políticas de vacaciones cambian.", "correct": false, "note": "Razonable y de poco valor. Las vacaciones concedidas en la oferta son contractuales; es la revisión la que es humo hasta que se concreta." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-money', 5,
  'Sí, no, y la otra oferta',
  $md$Cómo termina un proceso se recuerda más tiempo que cómo fue, porque el final es la parte en la que la gente descubre cómo eres cuando ya no tienes nada que ganar.

**Decir que sí.** Hazlo con claridad y con calidez, por escrito, y deja de negociar. Quien acepta y luego reabre algo se ha gastado su primer capital político antes del día uno. Y luego díselo a todo el que te ayudó, sobre todo a quien te cribó, que ha estado defendiéndote en silencio en salas en las que tú no estabas.

**Decir que no.** Pronto, con calidez, y sin un motivo fabricado. *He aceptado otra cosa* es una frase completa y no requiere ampliación. No te inventes un problema con su oferta para que la negativa parezca justificada: les invita a arreglarlo, y ahora estás teniendo una conversación que no querías. El sector es pequeño, quien contrata cambia de empresa, y la persona a la que rechazas este año te entrevista dentro de cuatro con una frecuencia sorprendente.

**La oferta competidora.** Si de verdad la tienes, decirlo es legítimo y debería enunciarse como un dato con una fecha, no como una amenaza. *Tengo otra oferta y tengo que responder el jueves. Vosotros sois mi primera opción, y quería decíroslo en vez de dejar correr el reloj.* Eso es honesto, les es útil, y les da un motivo para moverse rápido.

**La jugada:** termínalo como te gustaría que te lo dijeran a ti — pronto, con calidez, y sin inventar nada.

No te marques nunca un farol con una oferta competidora que no tienes. La forma de fallar no es que te pillen. Es que digan *lo entendemos, mucha suerte*, y no haya adónde ir.

Y si estás rechazando una oferta que casi aceptas, di qué te gustó de ellos. Cuesta una frase, suele ser verdad, y es lo que se recuerda cuando tu nombre vuelva a salir.$md$,
  $j$[
    {
      "situation": "Aceptar con claridad y cerrar la negociación.",
      "line": "Me gustaría aceptar, gracias. Todo lo que hablamos está en la carta por lo que veo, así que encantado de firmar hoy. Y gracias por preguntar por la fecha de revisión, eso importaba.",
      "why": "Inequívoco, cálido, y cierra la negociación explícitamente. Nombrar la concesión que hicieron asegura que quien la defendió sepa que aterrizó."
    },
    {
      "situation": "Rechazar sin inventarse un motivo.",
      "line": "Voy a decir que no, y quería decírtelo hoy en vez de dejarlo reposar. He aceptado otra cosa. Estuve genuinamente dividido: la conversación con tu equipo sobre el problema de los informes fue la mejor hora de toda mi búsqueda.",
      "why": "Pronto, honesto, sin un defecto fabricado en su oferta. El cumplido concreto del final es lo que hace que esto se recuerde bien y no que sea solo educado."
    },
    {
      "situation": "Nombrar una oferta competidora real como información.",
      "line": "Debería deciros que tengo otra oferta con fecha límite el jueves. Sois mi primera opción y no quería desaparecer sin más. ¿Hay alguna posibilidad de una decisión antes de entonces?",
      "why": "Un dato y una petición, sin ninguna amenaza implícita. Ese «sois mi primera opción» quita del todo la lectura adversarial, y es la frase que hace que las empresas se muevan rápido."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Estás rechazando una oferta. ¿Deberías explicar por qué?",
      "options": [
        { "text": "Sí, en detalle: se merecen una opinión honesta sobre su proceso.", "correct": false, "note": "Dala si te la piden. Ofrecer una crítica de una empresa que estás dejando es una conversación sin ninguna ventaja para ti." },
        { "text": "Solo si el motivo es verdadero y simple, como haber aceptado en otro sitio.", "correct": true, "note": "Una frase limpia. Cualquier cosa más invita a una contraoferta o a una negociación que ya has decidido no tener." },
        { "text": "No: no digas nada más allá del rechazo.", "correct": false, "note": "Un no pelado es más frío de lo que hace falta, y esta es una persona a la que puedes volver a encontrarte. Una frase cálida no cuesta nada." },
        { "text": "Sí, y nombra algo de la oferta que podría haberte hecho cambiar de opinión.", "correct": false, "note": "Entonces lo cambiarán, y estarás de vuelta en una negociación que no querías. No abras una puerta por la que piensas irte." }
      ],
      "explain": "Pronto, cálido, verdadero y corto. La ampliación es lo que convierte una decisión en un debate."
    },
    {
      "prompt": "¿Merece la pena mencionar una oferta competidora que en realidad no tienes?",
      "options": [
        { "text": "No, porque el riesgo es que sencillamente te deseen suerte.", "correct": true, "note": "Esa es la forma real de fallar, no que te pillen. Un farol aceptado con educación te deja sin jugada y sin oferta." },
        { "text": "No, porque lo van a comprobar con la otra empresa.", "correct": false, "note": "No lo van a hacer, e imaginar que podrían es el motivo equivocado para evitarlo." },
        { "text": "Sí, si acelera un proceso lento.", "correct": false, "note": "A veces lo acelera, y el inconveniente es que la aceleración puede ir hacia un no." }
      ],
      "explain": "Una palanca que no tienes no se puede gastar. Una fecha límite anunciada que no puedes sostener termina la conversación en sus términos."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "prompt", "label": "Respondió pronto", "description": "Dio una decisión clara rápido en vez de dejarla a la deriva." },
      { "key": "warm", "label": "Terminó con calidez", "description": "Dejó la relación en buen estado, también al rechazar." },
      { "key": "no_invention", "label": "Sin inventar nada", "description": "Ni motivos fabricados, ni palancas alegadas que no existían." },
      { "key": "closed_cleanly", "label": "Lo cerró", "description": "No reabrió una negociación que ya estaba zanjada." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rachel Oyelaran",
      "role": "una responsable de contratación que llevaba esperando esta respuesta",
      "mood": "Esperanzada al empezar la llamada, y enseguida profesional.",
      "openness": 4,
      "personality": "Elegante, y decepcionada. Preguntará una vez si algo podría cambiar la decisión, y aceptará un no claro sin insistir más."
    },
    "setting": "Una llamada para rechazar una oferta de una empresa que le gustaba al candidato, tras haber aceptado en otro sitio.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta una vez si algo podría hacerle cambiar de opinión. Acepta un no claro sin volver a insistir.",
      "Si la persona insinúa un problema arreglable con la oferta, ofrécete de inmediato a arreglarlo.",
      "Si es vaga sobre su decisión, pregúntale directamente si es un no.",
      "Mantente elegante todo el rato, y nunca le digas cómo lo ha llevado."
    ],
    "opening_beat": "«Hola, gracias por llamar. Te digo ya que espero que sean buenas noticias, el equipo lleva toda la semana preguntándome.»",
    "success_looks_like": "La persona rechaza con claridad y pronto en la llamada, da un motivo verdadero y simple, dice algo genuino sobre lo que le gustó, y no reabre la negociación."
  }$j$::jsonb,
  'Rechaza hoy algo — una invitación, una petición, una reunión — pronto, con calidez, y sin inventarte un motivo. Apunta qué se sintió al dar una respuesta corta en vez de una justificada.',
  $j${
    "says": "Hola, gracias por llamar. Te digo ya que espero que sean buenas noticias, el equipo lleva toda la semana preguntándome.",
    "model": {
      "line": "Gracias, de verdad, y siento ser quien dice esto. He aceptado otro puesto. Fue sobre todo por el desplazamiento, y habría trabajado contigo encantado.",
      "why": "Pronto, cálido y verdadero. Decir el motivo real ahora no te cuesta nada y es la única versión que deja la puerta abierta, que vale más que el puesto que has rechazado."
    },
    "checks": [
      { "kind": "contains_any", "words": ["gracias", "agradezco", "te lo agradezco"], "requirement": "Dales las gracias, y en serio" },
      { "kind": "max_sentences", "n": 4, "requirement": "Cuatro frases. La amabilidad es la prontitud." },
      { "kind": "forbids_any", "words": ["pensármelo", "te digo algo", "necesito más tiempo", "te cuento la semana", "consultarlo con la almohada"], "requirement": "No los dejes colgados" }
    ],
    "maxChars": 500
  }$j$::jsonb
);
