-- Spanish: Small talk, track 3 — Ir más adentro.
--
-- The ladder's three rungs are Dato, Emoción, Por qué o Qué viene ahora,
-- matching the core idea written in migration 99. "Peldaño" rather than
-- "escalón" throughout, because a peldaño is a rung you climb and an escalón
-- is a step you trip over.
--
-- One word list needed real care. Lesson 3 forbids the detail questions —
-- how long, how many, what year — so that the reader asks what something was
-- like instead. Translating those to single Spanish words would break the
-- drill, because "cuándo" and "dónde" appear in perfectly good feeling
-- questions ("¿cuándo te diste cuenta de que te gustaba?"). The Spanish list
-- is therefore phrases rather than words, which is what the English list is
-- too once you look at it.

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
    title = excluded.title, theory_md = excluded.theory_md,
    examples_json = excluded.examples_json, checks_json = excluded.checks_json,
    rubric_json = excluded.rubric_json, scenario_json = excluded.scenario_json,
    mission_text = excluded.mission_text, rehearsal_spec = excluded.rehearsal_spec,
    updated_at = now();
$fn$;

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('going-deeper', 1,
  'La escalera de la curiosidad',
  $md$Toda conversación tiene tres peldaños disponibles en todo momento, y casi nadie se baja del primero.

**Dato** es lo que pasó. Dónde trabajas, dónde fuiste, cuánto tardaste. **Emoción** es qué tal fue. **Por qué o qué viene ahora** es qué significa para esa persona, o qué pasa después.

Los datos son fáciles de pedir y fáciles de dar, y por eso las conversaciones se amontonan en ese peldaño y luego mueren de aburrimiento. Nadie se ha ido nunca de una conversación pensando en los datos que intercambió.

**La jugada:** date cuenta de en qué peldaño estás, y sube uno.

No hace falta una pregunta ingeniosa para subir. Un dato más las palabras *y qué tal fue* te ponen en el segundo peldaño todas las veces.$md$,
  $j$[
    {
      "situation": "Mencionan que acaban de volver de tres años fuera.",
      "line": "Tres años dan para tener una vida allí. ¿Qué tal fue volver?",
      "why": "El dato eran los tres años. Subir es preguntar qué tal fue, que es la única parte sobre la que van a tener sentimientos de verdad."
    },
    {
      "situation": "Un compañero dice que los fines de semana lleva su propio negocio.",
      "line": "¿Es lo que harías a jornada completa si pudieras?",
      "why": "Se salta el segundo peldaño y aterriza en el tercero. A veces se puede saltar, y las preguntas de futuro son las que más halagan."
    },
    {
      "situation": "Alguien dice que tiene dos hijos y que uno empieza el colegio.",
      "line": "Eso es gordo. ¿Estás bien con ello o calladamente no tan bien?",
      "why": "Nombra el peldaño de la emoción explícitamente y les da permiso para admitir la respuesta menos presentable, que suele ser la verdadera."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Te dicen que van al trabajo en bici, unos cuarenta minutos por trayecto. ¿Qué respuesta sube la escalera?",
      "options": [
        { "text": "¿Qué ruta haces?", "correct": false, "note": "Otro dato. Ahora sabes la ruta y la conversación está exactamente donde estaba." },
        { "text": "Cuarenta minutos es serio. ¿Lo disfrutas o lo soportas?", "correct": true, "note": "Coge el dato que te han ofrecido y pregunta qué tal es. Ese es el segundo peldaño, y es la subida más corta posible." },
        { "text": "¿Cuánto llevas haciéndolo?", "correct": false, "note": "Un dato sobre un dato. Perfectamente educado y completamente plano." },
        { "text": "Yo no podría.", "correct": false, "note": "Es una confidencia, que no es poco, pero cierra el tema en lugar de abrirlo." }
      ],
      "explain": "La subida más corta es coger su propio dato y preguntar qué tal es. Casi nunca necesitas una pregunta mejor que esa."
    },
    {
      "prompt": "Dicen que llevan once años en la misma empresa. ¿Cuál es la subida más corta?",
      "options": [
        { "text": "Preguntar si se han planteado irse.", "correct": false, "note": "Un salto al tercer peldaño desde parado, y algo cargado. Puede sonar a acusarles de estar estancados." },
        { "text": "Preguntar qué les ha mantenido allí.", "correct": true, "note": "Coge su propio dato y pregunta qué tal es desde dentro. Cálido, fácil de contestar, y te da una respuesta real." },
        { "text": "Preguntar a qué se dedica la empresa.", "correct": false, "note": "Otro dato, y uno que han contestado cien veces." },
        { "text": "Preguntar cómo ha cambiado la empresa.", "correct": false, "note": "Mejor, y sigue siendo sobre la empresa y no sobre ellos." }
      ],
      "explain": "La subida más corta es siempre su dato más qué tal fue. Aquí es qué te ha mantenido, no cuánto llevas."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "noticed_the_rung", "label": "Sabías en qué peldaño estabas", "description": "Seguiste si la conversación intercambiaba datos, emociones o significado." },
      { "key": "climbed", "label": "Subiste un paso", "description": "Pasaste de dato a emoción, o de emoción a por qué, en vez de quedarte al mismo nivel." },
      { "key": "used_their_fact", "label": "Subiste con su material", "description": "Construiste la subida sobre algo que la otra persona ya había dicho." },
      { "key": "did_not_rush", "label": "No forzaste el peldaño de arriba", "description": "Dejaste que la subida fuera al ritmo con el que la otra persona estaba cómoda." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Una mesa larga en la cena de cumpleaños de un amigo de un amigo. Estás sentado al lado de alguien a quien no conoces, entre platos.",
    "partner": {
      "name": "Ellis",
      "role": "una amistad del anfitrión a la que no conoces",
      "personality": "Agradable y colaborador. Contesta exactamente lo que le preguntan y nada más, así que una ráfaga de preguntas de dato produce una ráfaga de respuestas de dato.",
      "mood": "Cómodo, algo aburrido de la charla hasta ahora.",
      "openness": 3
    },
    "opening_beat": "Ellis menciona que hace unas semanas volvió de seis meses en Lisboa, y alcanza el agua.",
    "success_looks_like": "La persona sube del dato de Lisboa a qué tal fue de verdad, y Ellis se abre con algo sobre lo que claramente tiene sentimientos.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Contesta las preguntas de dato solo con el dato, en una frase plana. No ofrezcas emociones si no te las piden.",
      "Cuando te pregunten qué tal fue algo o por qué importó, ponte notablemente más cálido y da una respuesta real y concreta.",
      "Si te hacen tres preguntas de dato seguidas, que tus respuestas se vayan acortando."
    ]
  }$j$::jsonb,
  $md$Lleva hoy una conversación de un dato a una emoción. Usa sus propias palabras como escalón. Anota el dato del que partiste y qué te devolvieron.$md$,
  $j${
  "turns": [
    { "instruction": "Pregunta algo a nivel de dato — qué, dónde, cuál." },
    { "instruction": "Un peldaño arriba: del dato a qué tal fue." },
    { "instruction": "Uno más, si te han dejado sitio. No te saltes un peldaño para llegar." }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('going-deeper', 2,
  'Tres datos seguidos es un interrogatorio',
  $md$Hay una forma concreta en la que mueren las conversaciones, y tiene una silueta que se puede aprender a oír.

Preguntas dónde trabajan. Te lo dicen. Preguntas cuánto llevan. Te lo dicen. Preguntas en qué consiste. Te lo dicen. Nadie ha sido maleducado, nada ha salido mal, y el conjunto tiene el ambiente de un formulario rellenándose.

El problema no son las preguntas. Es que una ráfaga de ellas pone a una persona en la silla y a la otra detrás de la mesa. Quien contesta empieza a sentirse examinado, y la gente examinada da respuestas más cortas, lo que te hace preguntar más, lo que lo empeora.

**La jugada:** después de dos preguntas, mete algo tuyo — una reacción, una opinión, un trozo pequeño de ti.

No estáis turnándoos para hablar. Estás demostrando que aquí hay dos personas.$md$,
  $j$[
    {
      "situation": "Acabas de hacer dos preguntas sobre su trabajo y notas que se aplana.",
      "line": "Yo siempre había dado por hecho que ese trabajo eran reuniones. Está claro que no.",
      "why": "Una reacción en vez de una tercera pregunta. Les da algo con lo que estar de acuerdo o que corregir, y pone un poco de ti sobre la mesa."
    },
    {
      "situation": "Te han dicho dónde viven y cuánto tardan en llegar.",
      "line": "Yo hice ese trayecto un año y me destrozó. Tú pareces llevarlo mejor.",
      "why": "Rompe el interrogatorio con una pequeña confesión. Ahora están hablando con alguien en vez de contestando a alguien."
    },
    {
      "situation": "Han contestado dos preguntas sobre sus planes del fin de semana.",
      "line": "Sinceramente, eso suena a un fin de semana mucho mejor que el mío.",
      "why": "Poco esfuerzo, cálido y completamente suficiente. La interrupción no tiene que ser ingeniosa, solo tiene que no ser otra pregunta."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Has hecho dos preguntas seguidas y las respuestas se van acortando. ¿Cuál es el movimiento más fuerte?",
      "options": [
        { "text": "Decir algo de ti sobre el mismo tema.", "correct": true, "note": "Rompe el patrón y cambia los papeles. Que las respuestas se acorten suele indicar que se sienten entrevistados, no que estén aburridos." },
        { "text": "Hacer una pregunta más interesante.", "correct": false, "note": "Una pregunta mejor sigue siendo una pregunta. La tercera llega como la tercera, sea cual sea su calidad." },
        { "text": "Cambiar de tema por completo.", "correct": false, "note": "Escapa del tema pero no de la dinámica. En un minuto los estarás entrevistando sobre otra cosa." },
        { "text": "Esperar a que te pregunten algo.", "correct": false, "note": "Puede que lo hagan, pero les has entrenado en el papel de contestar. Esperar suele producir silencio e incomodidad mutua." }
      ],
      "explain": "Que las respuestas se acorten suele significar que los papeles han cuajado, no que la persona se aburra. Cambia el papel, no el tema."
    },
    {
      "prompt": "Has hecho dos preguntas. ¿Cuál de estas cuenta como meter algo?",
      "options": [
        { "text": "Qué interesante.", "correct": false, "note": "Una reacción sin contenido. Reconoce sin ofrecer, así que los papeles no cambian." },
        { "text": "¿En serio? Cuéntame más.", "correct": false, "note": "Esta es una tercera pregunta disfrazada de afirmación." },
        { "text": "Yo lo intenté una vez y lo dejé en una semana.", "correct": true, "note": "Una pequeña admisión con contenido dentro. Ahora hay dos personas en la conversación." },
        { "text": "¿Cuánto llevas haciéndolo?", "correct": false, "note": "La tercera pregunta, sin disfraz." }
      ],
      "explain": "Meter algo significa algo tuyo con contenido. Los ruiditos de ánimo te dejan sentado en la silla del entrevistador."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "broke_the_run", "label": "No encadenaste preguntas", "description": "Nunca hiciste tres preguntas seguidas sin meter algo." },
      { "key": "offered_something", "label": "Diste una reacción o algo tuyo", "description": "Interrumpiste el patrón con una opinión, una confesión o una reacción." },
      { "key": "heard_the_flattening", "label": "Notaste que se acortaban", "description": "Reconociste la dinámica de interrogatorio por la longitud de las respuestas." },
      { "key": "stayed_warm", "label": "Lo mantuviste fácil", "description": "Rompiste el patrón sin que el cambio de marcha resultara incómodo." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "La cocina de una fiesta en una casa, veinte minutos después de empezar. Alguien se está rellenando el vaso despacio.",
    "partner": {
      "name": "Rowan",
      "role": "una amistad del anfitrión, en la misma habitación que tú por casualidad",
      "personality": "Simpático pero fácil de convertir en testigo. Contesta las preguntas con diligencia y se encoge bajo una ráfaga de ellas, y se abre rápido cuando la otra persona ofrece algo primero.",
      "mood": "Bien, algo cansado, dispuesto a hablar con alguien interesante.",
      "openness": 3
    },
    "opening_beat": "Rowan dice que solo ha venido porque vive a dos calles y le parecía feo no aparecer.",
    "success_looks_like": "La persona nota que se está formando un interrogatorio y lo rompe ofreciendo algo suyo, tras lo cual Rowan se relaja visiblemente y empieza a ofrecer material.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Contesta cada pregunta más corto que la anterior mientras solo te hagan preguntas. A la tercera, responde en menos de seis palabras.",
      "En cuanto ofrezcan una opinión, una reacción o algo suyo, caliéntate y da una respuesta más larga.",
      "Nunca expliques que estás haciendo esto."
    ]
  }$j$::jsonb,
  $md$Hoy, en cada conversación, cuenta tus preguntas. Después de dos seguidas, mete algo tuyo antes de la tercera. Anota la conversación en la que te pillaste.$md$,
  $j${
  "turns": [
    { "instruction": "Pregúntales algo. Lo que sea que les haga hablar." },
    { "instruction": "Haz una segunda. Dos seguidas todavía está bien — la que convierte esto en un interrogatorio es la tercera." },
    { "instruction": "Ahora mete algo tuyo — una reacción, una opinión, un trozo de ti. Esta vez sin pregunta." }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('going-deeper', 3,
  'Pregunta por la experiencia, no por el dato',
  $md$Cuando alguien te cuenta algo, siempre hay dos direcciones: más adentro en los datos, o de lado hacia qué tal fue.

Las preguntas de dato parecen más seguras porque son concretas y contestables. *¿Qué año? ¿Qué empresa? ¿Cuánta gente?* Pero el dato es la parte que pueden recitar sin estar presentes, y recitar no es hablar.

**La jugada:** cuando te pilles a punto de pedir un dato, pide la experiencia en su lugar.

La señal que hay que escuchar es cualquier frase con una emoción evidente escondida dentro. *Me volví a casa de mis padres una temporada. Al final lo hicimos nosotros. Era la primera vez que dirigía a alguien.* Cada una de esas lleva un año entero de emoción doblado dentro, y una pregunta de dato la esquiva con elegancia.$md$,
  $j$[
    {
      "situation": "Mencionan que se hicieron autónomos hace un año.",
      "line": "¿El primer mes fue aterrador o liberador?",
      "why": "La pregunta de dato sería cuánto cobras. Esta ofrece dos emociones y les deja elegir, que es mucho más fácil de contestar que una pregunta abierta sobre sentimientos."
    },
    {
      "situation": "Alguien dice que organizó entera la boda de su hermana.",
      "line": "¿Disfrutaste algo de aquello o fue solo alivio al final?",
      "why": "Va directo a la experiencia, y el encuadre algo cínico les da permiso para ser sinceros en vez de elegantes."
    },
    {
      "situation": "Dicen que estaban en un grupo que se disolvió.",
      "line": "¿Lo echas de menos o te alegras de que se acabara?",
      "why": "Dos emociones, direcciones opuestas, ninguna respuesta equivocada. Ofrecer a elegir entre dos emociones es mucho más contestable que preguntar qué se sintió."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Te dicen: hice una temporada trabajando en una estación de esquí con veintidós años. ¿Qué respuesta te da la buena versión de esa historia?",
      "options": [
        { "text": "¿En qué estación fue?", "correct": false, "note": "Un dato. Dirán un sitio, tú dirás que te suena, y la historia se queda sin contar." },
        { "text": "¿Y cómo acabaste haciendo eso?", "correct": false, "note": "Mejor, porque pide una historia y no un dato. Pero apunta hacia atrás, a la logística, y no a qué tal fue la temporada." },
        { "text": "¿Fue el mejor año de tu vida o uno que preferirías olvidar?", "correct": true, "note": "Ofrece dos emociones en extremos opuestos y les deja colocarse. Casi nadie contesta a esta con brevedad." },
        { "text": "¿Sigues esquiando?", "correct": false, "note": "Se salta la temporada entera y aterriza en el presente, que es el sitio menos interesante disponible." }
      ],
      "explain": "Ofrecer dos emociones opuestas es más fácil de contestar que pedirle a alguien que describa sus sentimientos desde cero."
    },
    {
      "prompt": "Te dicen: al final cancelamos la boda y lo hicimos en el juzgado. ¿Qué respuesta alcanza la experiencia?",
      "options": [
        { "text": "¿Cuánta gente fue al final?", "correct": false, "note": "Una pregunta de dato sobre la parte menos interesante de una frase que contiene la palabra cancelamos." },
        { "text": "¿Por qué la cancelasteis?", "correct": false, "note": "Apunta al sitio correcto pero formulado como una petición de que se justifiquen." },
        { "text": "Los juzgados pueden ser preciosos.", "correct": false, "note": "Un consuelo que nadie ha pedido, y que cierra el tema calladamente." },
        { "text": "¿Eso fue un alivio o una decepción?", "correct": true, "note": "Dos emociones en extremos opuestos, fácil de contestar, y no da por supuesto cuál de las dos fue." }
      ],
      "explain": "Ofrecer dos emociones opuestas es la entrada más segura, porque no presupone cuál tuvieron."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "chose_feeling", "label": "Preguntaste por la experiencia, no por el dato", "description": "Fuiste a por qué tal fue algo en vez de a por los hechos que lo rodeaban." },
      { "key": "made_it_answerable", "label": "Pusiste la emoción a mano", "description": "Ofreciste a elegir entre dos emociones o un marco concreto en vez de una pregunta abstracta sobre sentimientos." },
      { "key": "heard_the_folded_feeling", "label": "Detectaste la frase cargada", "description": "Notaste una afirmación con una experiencia evidente doblada dentro." },
      { "key": "allowed_the_unflattering", "label": "Dejaste sitio para la respuesta sincera", "description": "Formulaste la pregunta de modo que la respuesta menos presentable estuviera disponible." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Un rincón tranquilo de la cocina de una oficina a las cuatro de la tarde. El hervidor está en marcha.",
    "partner": {
      "name": "Yusuf",
      "role": "alguien de otro equipo con quien has hablado dos veces",
      "personality": "Reservado y algo formal al principio. Tiene una historia genuinamente interesante que no va a ofrecer, y contesta las preguntas de dato con datos y nada más.",
      "mood": "Bajando el ritmo, sin prisa.",
      "openness": 3
    },
    "opening_beat": "Yusuf menciona, casi de pasada, que se reconvirtió a este trabajo a los treinta y cuatro después de dedicarse a algo completamente distinto.",
    "success_looks_like": "La persona apunta a la experiencia y no a la logística, y Yusuf da una respuesta real sobre qué fue de verdad aquel cambio.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Contesta las preguntas de dato con el dato pelado y nada más.",
      "Cuando te pregunten qué tal fue algo, o te ofrezcan elegir entre dos emociones, contesta con sinceridad y extensión.",
      "No ofrezcas la versión emocional si no van a buscarla."
    ]
  }$j$::jsonb,
  $md$Hoy, píllate a punto de pedir un dato y pide la experiencia en su lugar. Ofrece dos emociones si eso les ayuda a contestar. Anota la pregunta que casi hiciste y la que hiciste.$md$,
  $j${
  "says": "La verdad es que me reconvertí a esto a los treinta y cuatro. Antes me dedicaba a algo completamente distinto.",
  "model": {
    "line": "¿El primer mes fue aterrador o liberador?",
    "why": "Pregunta qué tal fue en vez de los hechos que lo rodean, y ofrece dos emociones para que sea fácil coger una."
  },
  "checks": [
    { "kind": "offers_a_choice", "requirement": "Ofrece dos emociones, para que sea fácil de contestar" },
    { "kind": "forbids_any", "requirement": "Pregunta qué tal fue, no los datos de alrededor", "words": ["cuánto tiempo", "cuántos años", "qué año", "cuándo empezaste", "dónde fue", "cuánto cobras", "qué empresa", "en qué consiste"] },
    { "kind": "max_words", "requirement": "Menos de dieciséis palabras", "n": 16 }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('going-deeper', 4,
  'El peldaño de arriba: por qué y qué viene ahora',
  $md$El tercer peldaño es donde la gente se vuelve ella misma. También es el que casi todo el mundo da por prohibido con alguien a quien apenas conoce.

No lo está. Las preguntas de *por qué* y *qué viene ahora* se reciben normalmente como halago y no como intrusión, porque tratan a la otra persona como alguien con intenciones y no como un conjunto de circunstancias.

**La jugada:** pregunta qué quieren sacar de la cosa que ya te están contando.

El truco está en que el peldaño de arriba no va de temas pesados. Va de dirección. *¿Esto es el plan o un escalón hacia otra cosa? ¿Lo volverías a hacer? ¿Qué harías si el dinero fuera el mismo de todas formas?* Ninguna es personal en el sentido que la gente teme, y todas piden que alguien diga lo que de verdad quiere.

Dos condiciones. Sube aquí con material suyo, no tuyo, y solo cuando ya se hayan recorrido los dos primeros peldaños.$md$,
  $j$[
    {
      "situation": "Llevan un par de minutos describiendo su trabajo con cariño.",
      "line": "¿Esto es la cosa, o va camino de otra cosa distinta?",
      "why": "Formulación ligera sobre una pregunta seria. Les deja la opción de una respuesta de una línea o de una de verdad, y casi todo el mundo coge la de verdad."
    },
    {
      "situation": "Alguien menciona que lleva dos años aprendiendo un idioma.",
      "line": "¿Cuál es la versión en la que esto ha valido la pena? ¿Vivir allí, o poder hacerlo?",
      "why": "Pregunta por el futuro que se están imaginando, que es un tema mucho más interesante que su vocabulario."
    },
    {
      "situation": "Han hablado de una afición que claramente adoran.",
      "line": "¿Querrías que fuera tu trabajo, o eso lo estropearía?",
      "why": "Una pregunta de por qué vestida de calle. Además lleva dentro una pequeña intuición, lo que hace que parezca una conversación y no un cuestionario."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Alguien lleva dos minutos describiendo con gusto el huerto que cogió en primavera. ¿Cuál es el movimiento más fuerte hacia el peldaño de arriba?",
      "options": [
        { "text": "¿Cómo de grande es la parcela?", "correct": false, "note": "Primer peldaño. Has bajado la escalera después de que ellos la subieran por ti." },
        { "text": "¿Cómo esperas que sea dentro de unos años?", "correct": true, "note": "Pregunta por el futuro que se están imaginando. Ya han demostrado que les importa, así que esto es una invitación y no un interrogatorio." },
        { "text": "¿Lo disfrutas?", "correct": false, "note": "Segundo peldaño, y ya lo han contestado hablando con gusto durante dos minutos." },
        { "text": "¿Por qué querías un huerto?", "correct": false, "note": "Es una pregunta de por qué de verdad, pero apuntada hacia atrás puede caer como pedirles que se justifiquen. Las preguntas de por qué hacia delante son más cálidas." }
      ],
      "explain": "Apunta el peldaño de arriba hacia delante. Qué quiere alguien a continuación es más fácil y más halagador de contestar que por qué hizo algo."
    },
    {
      "prompt": "¿Cuándo cae mal una pregunta de por qué o de futuro?",
      "options": [
        { "text": "Cuando apunta hacia atrás y les pide que justifiquen una decisión.", "correct": true, "note": "Por qué hiciste eso pone a alguien a la defensiva. Qué esperas de esto no lo hace, y es el mismo peldaño." },
        { "text": "Cuando el tema es su trabajo.", "correct": false, "note": "El trabajo es de los sitios más fáciles para preguntar por la dirección. A la gente suele gustarle que se lo pregunten." },
        { "text": "Cuando acabas de conocer a esa persona.", "correct": false, "note": "A veces, y mucha gente desconocida disfruta una pregunta hacia delante a los pocos minutos." },
        { "text": "Cuando no han mencionado el futuro ellos.", "correct": false, "note": "Rara vez hace falta que lo saquen primero. Lo que importa es hacia dónde apunta la pregunta." }
      ],
      "explain": "El peldaño de arriba es seguro cuando mira hacia delante. Apuntada hacia atrás, la misma pregunta pide que alguien se defienda."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "reached_the_top", "label": "Llegaste al por qué o al futuro", "description": "Preguntaste por el significado o la dirección en vez de quedarte en dato y emoción." },
      { "key": "pointed_forwards", "label": "Apuntaste hacia delante", "description": "Preguntaste qué quieren a continuación en vez de exigir que justifiquen el pasado." },
      { "key": "earned_it", "label": "Subiste en orden", "description": "Llegaste al peldaño de arriba después de los de abajo, no desde parado." },
      { "key": "kept_it_light", "label": "Mantuviste la formulación ligera", "description": "Hiciste una pregunta seria con lenguaje corriente en vez de solemne." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Un domingo tranquilo en la cafetería de un rocódromo. Los dos habéis parado a tomar un café a la vez.",
    "partner": {
      "name": "Bea",
      "role": "alguien a quien has visto varias veces en este gimnasio y con quien has hablado una",
      "personality": "Abierta y fácil, con mucho que decir en cuanto alguien hace una pregunta que merezca respuesta. Da respuestas finas a preguntas finas sin querer.",
      "mood": "Relajada y contenta con su mañana.",
      "openness": 4
    },
    "opening_beat": "Bea menciona que lleva entrenando para un viaje para el que ahorra desde el año pasado, y no explica de inmediato cuál es.",
    "success_looks_like": "La persona recorre los peldaños de abajo y luego pregunta qué quiere sacar de ello de verdad, y Bea dice algo que claramente no ha dicho mucho en voz alta.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Da respuestas breves y factuales a las preguntas de dato, y más cálidas a las de emoción.",
      "Si te hacen una pregunta de por qué o de futuro apuntada hacia delante después de algo de complicidad, contesta con generosidad y revela algo real.",
      "Si saltan a una pregunta de por qué en el primer turno, esquívala con educación y quédate en la superficie."
    ]
  }$j$::jsonb,
  $md$Lleva hoy una conversación al peldaño de arriba. Pregunta qué quiere alguien sacar de lo que ya te está contando. Anota la pregunta y cómo se la tomaron.$md$,
  $j${
  "says": "Llevo entrenando para eso desde enero, más o menos. Casi todas las mañanas antes de trabajar.",
  "model": {
    "line": "¿Es esto lo que quieres, o un paso hacia otra cosa?",
    "why": "Pregunta qué quieren sacar de lo que ya te están contando, y apunta hacia delante en vez de hacia atrás."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Apunta hacia delante — pregunta qué quieren sacar", "words": ["quieres", "esperas", "siguiente", "después", "acabar", "meta", "sueño", "plan", "adónde", "buscas"] },
    { "kind": "max_words", "requirement": "Formulación corriente — menos de veinte palabras", "n": 20 }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('going-deeper', 5,
  'No todo necesita el peldaño de arriba',
  $md$Una habilidad recién aprendida se aplica de más, y la profundidad es la peor delincuente.

No todo intercambio quiere ser significativo. Quien te cobra en el súper, el vecino de la escalera, el compañero con el que te cruzas dos veces al día: son conversaciones cuyo trabajo entero es ser breves y cálidas. Subir la escalera ahí no es profundo, es pesado, y hace que la gente te mire con un poco de recelo.

**La jugada:** lee cuánto tiempo y cuántas ganas hay, e iguala.

Tres señales de que la escalera no se quiere: están a mitad de una tarea, están de pie en vez de sentados, o el intercambio tiene un final natural a menos de un minuto. En esos casos la victoria es la calidez, no la profundidad. Un buen intercambio de treinta segundos que se queda en el primer peldaño es un éxito, no un fracaso.

La profundidad es una herramienta. Saber cuándo no usarla es parte de saber usarla.$md$,
  $j$[
    {
      "situation": "La persona de la tienda de la esquina a la que ves tres veces por semana, en mitad del cobro.",
      "line": "Vaya día llevas. El lunes esto era un caos también.",
      "why": "Primer peldaño, del todo cálido, y del tamaño correcto para un intercambio de cuarenta segundos. Nada de esto necesita ir más hondo para merecer la pena."
    },
    {
      "situation": "Un compañero pasa por tu mesa camino de una reunión a la que ya llega tarde.",
      "line": "Suerte. Cuéntame qué tal luego.",
      "why": "Lee el tiempo disponible, lo mantiene ligero y deja un gancho para después. Profundidad aplazada no es profundidad perdida."
    },
    {
      "situation": "En una fiesta, alguien acaba de empezar a contar una historia a otras tres personas y tú has llegado tarde.",
      "line": "(escucha, ríete, no digas nada todavía)",
      "why": "No todos los momentos son tuyos para dirigirlos. A veces lo hábil es reconocer que la conversación ya lleva una dirección."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Estás detrás de alguien en el mostrador de la farmacia que claramente tiene prisa, y hace un comentario amable sobre la cola. ¿Cuál es la mejor respuesta?",
      "options": [
        { "text": "Darle la razón con calidez y dejarlo ahí.", "correct": true, "note": "Del tamaño correcto. Un intercambio breve y cálido es la victoria entera aquí, e ir a por más les obligaría a gestionarte a ti además de a su recado." },
        { "text": "Preguntarle qué viene a recoger.", "correct": false, "note": "Una pregunta razonable en casi cualquier contexto y algo intrusiva en el mostrador de una farmacia con alguien con prisa." },
        { "text": "Preguntarle si siempre viene a esta.", "correct": false, "note": "Inofensivo, pero abre una conversación que ninguno de los dos tiene tiempo de terminar, que es su propia pequeña incomodidad." },
        { "text": "Preguntarle qué tal le va la semana.", "correct": false, "note": "Una pregunta de segundo peldaño soltada en un intercambio de treinta segundos. Se lee como más intimidad de la que la situación sostiene." }
      ],
      "explain": "Iguala la profundidad al tiempo disponible. Un intercambio cálido que se queda en la superficie es un éxito, no una oportunidad perdida."
    },
    {
      "prompt": "¿Cuál de estas indica con más fiabilidad que la conversación debe quedarse en la superficie?",
      "options": [
        { "text": "Solo hace unos minutos que conoces a esa persona.", "correct": false, "note": "La profundidad y el tiempo de conocerse están menos relacionados de lo que la gente cree. Los desconocidos van hondo rápido a menudo." },
        { "text": "Los dos estáis de pie, y uno de los dos lleva algo en las manos.", "correct": true, "note": "Estar de pie con las manos ocupadas es la postura de una conversación con final ya programado." },
        { "text": "Te están contestando breve.", "correct": false, "note": "Puede ser falta de ganas, o simplemente su forma de hablar. Más débil que la señal física." },
        { "text": "El tema es el trabajo.", "correct": false, "note": "El trabajo es un tema, no una profundidad. Algunas de las mejores conversaciones empiezan ahí." }
      ],
      "explain": "La postura y las manos dicen más sobre el tiempo disponible que el tema o cuánto haga que os conocéis."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "read_the_appetite", "label": "Leíste cuántas ganas había", "description": "Juzgaste el tiempo y las ganas disponibles antes de decidir cuánto profundizar." },
      { "key": "sized_it_right", "label": "Igualaste profundidad y momento", "description": "Te quedaste en la superficie donde la superficie era lo correcto, en vez de subir por costumbre." },
      { "key": "stayed_warm", "label": "Lo mantuviste cálido igual", "description": "Un intercambio breve siguió resultando amable en vez de seco." },
      { "key": "left_a_door", "label": "Dejaste algo para la próxima", "description": "Cuando venía al caso, aplazaste la profundidad en vez de abandonarla." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "El ascensor de tu edificio, subiendo seis plantas, a media mañana.",
    "partner": {
      "name": "Cass",
      "role": "alguien que trabaja en otra planta del mismo edificio",
      "personality": "Perfectamente amable, de verdad con el tiempo justo, y algo incómoda si una conversación de ascensor intenta convertirse en una de verdad.",
      "mood": "Con prisa pero educada, cargando un portátil y un café.",
      "openness": 2
    },
    "opening_beat": "Cass da los buenos días, comenta que el ascensor lleva toda la semana lento, y mira el indicador de planta.",
    "success_looks_like": "La persona lo mantiene breve y cálido, lee que este no es un momento para profundizar, y deja que termine solo sin forzar más.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Responde corto siempre. Te bajas en menos de un minuto.",
      "Si te hacen una pregunta de emoción o de por qué, contesta breve y algo incómoda, y vuelve a mirar el indicador.",
      "Si lo mantienen ligero y cálido, sé genuinamente amable y termina el intercambio con agrado."
    ]
  }$j$::jsonb,
  $md$Hoy, deja a propósito una conversación en la superficie y cálida cuando podrías haberla llevado más hondo. Fíjate en si aun así sentó bien. Anota por qué elegiste quedarte en el primer peldaño.$md$,
  $j${
  "beats": [
    {
      "situation": "Llevas dos minutos en la cola de un sitio de bocadillos. La persona de delante menciona que acaba de mudarse desde Bilbao por trabajo. Le quedan tres personas por delante.",
      "prompt": "¿Adónde lo llevas?",
      "options": [
        { "text": "Preguntar qué le hizo decidirse a irse.", "correct": false, "note": "Eso es una pregunta del peldaño de arriba con noventa segundos en el reloj. O te dan una respuesta fina o se sienten maleducados por no dártela de verdad." },
        { "text": "Decir algo ligero sobre la mudanza y dejarlo ahí.", "correct": true, "note": "Del tamaño justo para el tiempo disponible. Superficial y cálido es una conversación completa, no una profunda fallida." },
        { "text": "Preguntar qué tal lo lleva comparado con Bilbao.", "correct": false, "note": "Más cerca, pero sigue siendo una pregunta que quiere una respuesta meditada de alguien a punto de pedir la comida." }
      ]
    },
    {
      "situation": "Un viaje largo en tren. Lleváis cuarenta minutos hablando a ratos y acaban de mencionar, sin que se lo preguntes, que están entre trabajos.",
      "prompt": "¿Adónde lo llevas?",
      "options": [
        { "text": "Preguntar qué quieren que sea el siguiente.", "correct": true, "note": "Tiempo, calidez y una confidencia que no pediste. Se cumplen las tres condiciones, y la pregunta apunta hacia delante en vez de pedirles que justifiquen el pasado." },
        { "text": "Mantenerlo ligero y cambiar de tema.", "correct": false, "note": "Lo han sacado ellos, con una hora de viaje por delante. Desviarlo ahora se lee como no querer escucharlo." },
        { "text": "Preguntar qué pasó en el último.", "correct": false, "note": "Hacia atrás en vez de hacia delante, y la única versión de esta pregunta que quizá no quieran contestarle a un desconocido." }
      ]
    }
  ]
}$j$::jsonb);
