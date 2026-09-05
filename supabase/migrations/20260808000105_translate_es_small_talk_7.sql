-- Spanish: Small talk, track 6 — Cómo salir.
--
-- Two rehearsals in this track use echoes_any, which is the check most easily
-- broken by translation: the words listed have to appear in the Spanish says
-- beat, not in the English one. A list carried across unchanged would be
-- asking the reader to echo a word nobody in the scene has said, and the drill
-- would be unpassable rather than merely wrong. Both lists are rebuilt from
-- the Spanish beat and verified against it.
--
-- Lesson 2's opening-a-departure list is also rewritten rather than
-- translated. English signals leaving with "I am going", "I should", "I had
-- better" — Spanish does it with "me voy", "tengo que", "voy a", and with
-- "debería", which has no natural single-word English equivalent in this use.
--
-- Lessons 1 and 5 are scene mode and carry no rehearsal spec in English.

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

select pg_temp.es_lesson('exits', 1,
  'Vete antes de que muera',
  $md$Casi todo el mundo se va de las conversaciones demasiado tarde, y es el error más fácil de corregir de todo este temario.

La razón es que irse parece un rechazo, así que la gente espera un final natural. Pero las conversaciones no tienen finales naturales. Tienen un pico y luego una larga bajada, y cuanto más esperas, más es la bajada lo que recordáis los dos.

**La jugada:** vete mientras sigue siendo buena, no cuando se haya agotado.

Esto es contraintuitivo y es correcto. Si te vas en el pico, lo último que sentisteis los dos fue que aquello era agradable, y el intercambio entero se archiva como un éxito. Si esperas a quedarte sin cosas que decir, lo último que sentisteis los dos fue incomodidad, y eso lo tiñe todo.

La señal para irte es un pequeño silencio de dos o tres segundos que llega después de un buen rato. Ese es el momento. Ni el tercer silencio, ni ese en el que los dos estáis buscando visiblemente.$md$,
  $j$[
    {
      "situation": "Habéis tenido diez minutos buenos y hay una pequeña pausa cómoda.",
      "line": "Voy a buscar a los otros. Esto ha estado muy bien.",
      "why": "Irse en el pico. Lo último que sentisteis los dos fue que iba bien, y eso es lo que se recuerda."
    },
    {
      "situation": "Los dos habéis dicho algo dos veces y las pausas se van alargando.",
      "line": "(se te ha hecho un poco tarde — vete ya, con calidez)",
      "why": "No es fatal, pero cada silencio más hace el final más difícil de hacer con elegancia. Vete en el actual en vez de esperar."
    },
    {
      "situation": "La conversación va realmente volando y no hay ningún silencio.",
      "line": "(quédate)",
      "why": "Vete en el primer silencio pequeño después de un buen rato, no por reloj. Si no hay silencio, no hay motivo para irse."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuándo deberías irte de una conversación que va bien?",
      "options": [
        { "text": "En el primer silencio pequeño después de un buen rato.", "correct": true, "note": "El pico es el punto de salida correcto. Los dos archiváis la conversación como agradable, que es lo que vais a recordar la próxima vez." },
        { "text": "Cuando te quedes sin cosas que decir.", "correct": false, "note": "Aquí es donde se va casi todo el mundo, y para entonces los últimos minutos han sido una búsqueda de material. Eso es lo que se recuerda." },
        { "text": "Cuando den señales de querer irse.", "correct": false, "note": "Esperar a que te suelten hace que el trabajo lo haga la otra persona, y normalmente llegarás algo tarde." },
        { "text": "Después de un tiempo fijo, por seguridad.", "correct": false, "note": "Los relojes ignoran cómo va de verdad la conversación. Irse de una que vuela porque han pasado diez minutos es su propio error." }
      ],
      "explain": "Las conversaciones hacen pico y luego bajan. Vete en el pico y el conjunto se recuerda como bueno."
    },
    {
      "prompt": "La conversación va volando y tienes que estar en otro sitio. ¿Te vas o te quedas?",
      "options": [
        { "text": "Vete, y di llanamente que te da pena.", "correct": true, "note": "La mejor salida disponible. Irse en pleno pico con reticencia genuina es lo más halagador que puedes hacer." },
        { "text": "Quédate. Nunca te vayas de una conversación buena.", "correct": false, "note": "Malinterpreta la lección. Irse en el pico es el consejo; no hay ninguna regla contra irse bien." },
        { "text": "Quédate hasta que decaiga y entonces vete.", "correct": false, "note": "Esperar a propósito a la bajada tira el pico que ya tenías." },
        { "text": "Vete de golpe para evitar una despedida larga.", "correct": false, "note": "La brusquedad después de una buena conversación se lee como que algo ha ido mal." }
      ],
      "explain": "Irte de una conversación de la que no querías irte, y decirlo, es la salida más fuerte que existe."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "left_at_the_peak", "label": "Te fuiste mientras seguía bien", "description": "Saliste en un silencio después de un buen rato y no cuando ya se había agotado." },
      { "key": "read_the_lull", "label": "Reconociste el silencio correcto", "description": "Distinguiste una pausa cómoda tras un buen rato de un silencio de búsqueda." },
      { "key": "did_not_wait", "label": "No esperaste a que te soltaran", "description": "Te hiciste cargo de terminar en vez de esperar a la otra persona." },
      { "key": "no_false_starts", "label": "Te fuiste limpio", "description": "No anunciaste que te ibas y luego te quedaste varios minutos más." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "La inauguración privada de una galería. Llevas unos diez minutos hablando con alguien y ha ido bien.",
    "partner": {
      "name": "Lena",
      "role": "alguien a quien conociste junto a la mesa de las bebidas",
      "personality": "Buena compañía y con interés, con una cantidad finita de cosas que decir del tema actual. Mantendrá la conversación por educación mucho más allá de su pico natural si la otra persona no la termina.",
      "mood": "Disfrutando de la noche.",
      "openness": 4
    },
    "opening_beat": "Lena termina una historia buena, os reís los dos, y hay una pausa cómoda de dos segundos.",
    "success_looks_like": "La persona reconoce la pausa como el pico y se va con calidez en vez de abrir un tema nuevo para llenarla.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Si abren un tema nuevo en vez de irse, participa con educación pero con cada vez menos energía y pausas más largas.",
      "Si se van en el pico, responde con calidez real y di que lo has disfrutado.",
      "No termines nunca tú la conversación."
    ]
  }$j$::jsonb,
  $md$Termina hoy una conversación mientras todavía va bien. Anota qué se sintió al irte pronto y qué te dijeron al marcharte.$md$,
  null);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('exits', 2,
  'El cierre cálido',
  $md$Una salida tiene una forma, y son tres partes cortas que juntas duran unos cuatro segundos.

**Un motivo.** Cualquiera. No tiene que ser cierto en un sentido profundo y no debe ir sobre ellos: ir a por una copa, ir a buscar a alguien, tener que pillar a alguien antes de que se vaya.

**Algo cálido.** No una cortesía. Algo concreto de la conversación que habéis tenido de verdad. *Lo del microbús me ha alegrado la noche.*

**Un corte limpio.** Dilo y vete. El fallo más común con diferencia es anunciar la salida y luego quedarse otros cuatro minutos, lo que vuelve el anuncio retroactivamente raro.

**La jugada:** motivo, calidez, fuera.

La parte cálida es donde casi todo el mundo invierte de menos. *Encantado de conocerte* no es calidez, es relleno. Un detalle concreto convierte un final genérico en la cosa que recuerdan de ti.$md$,
  $j$[
    {
      "situation": "Una buena conversación de diez minutos con alguien nuevo.",
      "line": "Voy a buscar a mi amiga. De verdad, la mejor conversación que he tenido en toda la semana.",
      "why": "Motivo, después calidez concreta, después irse. Hace de verdad el trabajo de que un cumplido suene sentido y no automático."
    },
    {
      "situation": "Una conversación agradable pero sin nada especial.",
      "line": "Debería moverme antes de que me llamen la atención. Me ha gustado conocerte en condiciones.",
      "why": "Calidez del tamaño correcto. Exagerar en una conversación normal se lee como falso, y esto reconoce bien que ya os habíais visto."
    },
    {
      "situation": "Dijiste que te ibas y luego seguiste hablando.",
      "line": "(este es el fallo común — dilo y vete)",
      "why": "Una salida anunciada que no ocurre hace más difícil la siguiente, porque a partir de ahí descuentan lo que dices."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué parte de la salida hace mal casi todo el mundo?",
      "options": [
        { "text": "El motivo para irse.", "correct": false, "note": "Suele estar bien. Esta parte se le da fácil a la gente, y casi cualquier motivo neutro funciona." },
        { "text": "La parte cálida.", "correct": true, "note": "Casi todo el mundo la sustituye por relleno tipo encantado de conocerte. Un detalle concreto de la conversación real es lo que se recuerda." },
        { "text": "El momento.", "correct": false, "note": "También suele estar mal, y es el asunto de la lección anterior y no una parte de la forma de la salida." },
        { "text": "Mirar a los ojos al irse.", "correct": false, "note": "Merece la pena hacerlo, y es un detalle y no una parte estructural de la salida." }
      ],
      "explain": "Motivo, calidez, fuera. La calidez necesita un detalle concreto o es solo relleno."
    },
    {
      "prompt": "¿Cuál es algo cálido concreto en vez de relleno?",
      "options": [
        { "text": "Ha sido un placer conocerte.", "correct": false, "note": "La definición de relleno. Agradable, automático, olvidado al instante." },
        { "text": "Me voy a quedar con eso que has dicho del microbús.", "correct": true, "note": "Se refiere a algo que solo contenía esta conversación, que es lo que hace que caiga." },
        { "text": "Deberíamos hablar otro día con calma.", "correct": false, "note": "Mira hacia delante y es genérico. No dice nada de la conversación que habéis tenido." },
        { "text": "Se habla muy a gusto contigo.", "correct": false, "note": "Genuinamente agradable, y se le podría decir a cualquiera. Calidez sin concreción." }
      ],
      "explain": "Concreto significa que solo podría decirse de esta conversación. Todo lo demás es una cortesía."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "gave_a_reason", "label": "Diste un motivo neutro", "description": "Ofreciste un motivo para irte que no iba sobre la otra persona." },
      { "key": "specific_warmth", "label": "Fuiste cálido en concreto", "description": "Te referiste a algo real de la conversación en vez de a una cortesía genérica." },
      { "key": "clean_break", "label": "Te fuiste de verdad", "description": "Anunciaste la salida y luego te fuiste, en lugar de quedarte." },
      { "key": "right_size", "label": "Ajustaste el tamaño de la calidez", "description": "Igualaste la calidez a cómo había ido la conversación de verdad." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "La fiesta de inauguración del piso de un amigo. Llevas un rato hablando con alguien en el pasillo y ha sido genuinamente agradable.",
    "partner": {
      "name": "Tam",
      "role": "una amistad del anfitrión",
      "personality": "Detecta la sinceridad con facilidad. Responde con fuerza a un cumplido concreto y con planitud a uno genérico.",
      "mood": "Contento, disfrutando de la fiesta.",
      "openness": 4
    },
    "opening_beat": "Tam termina de contarte un intento desastroso de hacerse él mismo unos muebles, y os reís los dos.",
    "success_looks_like": "La persona sale con un motivo, con una calidez concreta que remite a la conversación, y luego se va de verdad.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Si te sueltan una cortesía genérica al irse, responde con educación y sin brillo.",
      "Si se refieren a algo concreto de la conversación, responde con calidez y gusto reales.",
      "Si anuncian que se van y luego siguen hablando, quédate algo confundido y comprueba si se quedan."
    ]
  }$j$::jsonb,
  $md$Hoy, termina una conversación con un motivo, una cosa cálida concreta y una marcha de verdad. Anota qué cosa concreta dijiste.$md$,
  $j${
  "says": "...y la segunda balda sigue, a día de hoy, sujeta con un libro de bolsillo.",
  "model": {
    "line": "Me voy a buscar a mi amiga. Esa balda con el libro de bolsillo me ha alegrado la noche.",
    "why": "Un motivo que no va sobre ellos, una cosa concreta de la conversación, y luego te vas de verdad."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Da un motivo que no vaya sobre ellos", "words": ["me voy", "voy a", "tengo que", "debería", "me tengo que", "he de", "deja que"] },
    { "kind": "echoes_any", "requirement": "Di una cosa cálida concreta de esta conversación", "words": ["balda", "libro de bolsillo", "segunda balda", "sujeta"] },
    { "kind": "max_sentences", "requirement": "Motivo, calidez, fuera. Tres frases como mucho.", "n": 3 }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('exits', 3,
  'El gancho hacia el futuro',
  $md$Algunas salidas merecen una cuarta parte: un pequeño impulso hacia delante.

Un gancho es una referencia de bajo compromiso a una próxima vez. *Cuéntame qué tal la mudanza. Quiero saber cómo acaba eso. Deberíamos hacer esto en condiciones alguna vez.* No cuesta nada, no requiere organizar nada, y convierte un final en una pausa.

**La jugada:** si de verdad te gustaría volver a hablar con esa persona, di una frase que apunte hacia delante.

Dos reglas. Tiene que ser concreto de algo de la conversación, o es una fórmula y se nota. Y tiene que ser de compromiso genuinamente bajo: un gancho no es una invitación, y convertirlo en una les pone en un aprieto justo cuando intentan irse.

Y no lo uses todas las veces. Un gancho en cada salida es una muletilla. Guárdalo para las conversaciones que de verdad quieres continuar, y significará algo cuando lo uses.$md$,
  $j$[
    {
      "situation": "Han mencionado una entrevista de trabajo la semana que viene.",
      "line": "Cuéntame qué tal el jueves. Ya me he implicado.",
      "why": "Concreto de su material, mira hacia delante, y no pide nada. Les da un motivo fácil para volver a hablarte si quieren uno."
    },
    {
      "situation": "Habéis descubierto que los dos escaláis.",
      "line": "Deberíamos ir a un muro en algún momento. Necesito a alguien mejor que yo que me obligue a esforzarme.",
      "why": "Una propuesta real sostenida flojo. En algún momento evita que sea un plan que tengan que contestar ahora."
    },
    {
      "situation": "Una conversación agradable pero sin nada especial con un compañero.",
      "line": "(no hace falta gancho — un cierre cálido está completo solo)",
      "why": "Los ganchos en cada salida dejan de significar nada. Reservarlo casi siempre es lo que le da peso cuando lo usas."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hace que un gancho funcione en vez de caer raro?",
      "options": [
        { "text": "Ser concreto con la hora y el sitio.", "correct": false, "note": "Eso es una invitación, no un gancho. Los detalles en el momento de irse obligan a una respuesta que quizá no estén listos para dar." },
        { "text": "Usarlo en todas las conversaciones para que salga natural.", "correct": false, "note": "La repetición lo convierte en fórmula. La gente distingue una costumbre de algo sentido." },
        { "text": "Referirse a algo concreto de la conversación, sin compromiso encima.", "correct": true, "note": "Concreto como para ser genuino, flojo como para que nadie tenga que responder. Esa combinación es la técnica entera." },
        { "text": "Preguntar directamente si les gustaría volver a quedar.", "correct": false, "note": "Un buen movimiento en el contexto correcto, y es una petición directa y no un gancho. Exige una respuesta ahí mismo." }
      ],
      "explain": "Concreto de ellos, flojo en compromiso. Un gancho abre una puerta sin pedirle a nadie que la cruce ahora."
    },
    {
      "prompt": "¿Cuándo no deberías usar un gancho?",
      "options": [
        { "text": "Cuando acabas de conocer a esa persona.", "correct": false, "note": "Los ganchos funcionan bien con desconocidos. La novedad no es la restricción." },
        { "text": "Cuando parecían ocupados.", "correct": false, "note": "Un gancho de bajo compromiso no pide nada, así que estar ocupado no es motivo para saltárselo." },
        { "text": "Cuando la conversación estuvo bien pero sin nada especial.", "correct": true, "note": "Un gancho en cada salida se convierte en muletilla. Reservarlo casi siempre es lo que le da peso." },
        { "text": "Cuando no tienes ningún plan concreto en mente.", "correct": false, "note": "Un gancho deliberadamente no es un plan. Los detalles lo convierten en invitación." }
      ],
      "explain": "Guárdalo para las conversaciones que de verdad quieres continuar. Usado siempre, deja de significar nada."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "used_their_material", "label": "Construiste sobre algo concreto", "description": "El gancho remitía a algo de la conversación real." },
      { "key": "low_commitment", "label": "No pediste nada", "description": "Lo mantuviste flojo como para que no hiciera falta respuesta en el momento." },
      { "key": "used_it_selectively", "label": "Lo guardaste para la conversación adecuada", "description": "No pegaste un gancho a cada salida por costumbre." },
      { "key": "still_a_clean_exit", "label": "Seguiste saliendo limpio", "description": "El gancho no se convirtió en una segunda conversación." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "El final de una clase por la tarde. Te ha tocado con alguien en la parte práctica y os habéis llevado bien.",
    "partner": {
      "name": "Owen",
      "role": "alguien de la misma clase",
      "personality": "Simpático y algo reservado. Responde con calidez a un gancho de bajo compromiso y se pone incómodo si le presionan para concretar.",
      "mood": "Contento de cómo ha ido la sesión, recogiendo.",
      "openness": 4
    },
    "opening_beat": "Owen menciona que va a intentar en casa lo que estabais practicando antes de la semana que viene, y empieza a ponerse el abrigo.",
    "success_looks_like": "La persona cierra con calidez y añade un gancho concreto de lo que Owen acaba de decir, sin convertirlo en una cita.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Si ofrecen un gancho de bajo compromiso atado a algo concreto, responde con calidez y en positivo.",
      "Si presionan para cerrar algo definido, ponte vago y algo incómodo.",
      "Si solo sueltan un adiós genérico, responde con educación y márchate."
    ]
  }$j$::jsonb,
  $md$Hoy, termina una conversación con un gancho atado a algo que dijeran de verdad. Solo donde te gustaría genuinamente volver a hablar. Anota el gancho.$md$,
  $j${
  "says": "Voy a intentarlo en serio en casa antes del jueves.",
  "model": {
    "line": "Cuéntame qué tal el jueves. Ya me he implicado.",
    "why": "Atado a algo que ha dicho de verdad, y no pide nada en el momento."
  },
  "checks": [
    { "kind": "echoes_any", "requirement": "Átalo a algo que hayan dicho de verdad", "words": ["jueves", "casa", "en serio", "intentarlo"] },
    { "kind": "forbids_any", "requirement": "No pidas nada en el momento", "words": ["tu número", "dame tu", "estás libre", "quedamos", "cuál es tu", "nos vemos el"] },
    { "kind": "max_sentences", "requirement": "Sigue siendo una salida limpia — tres frases como mucho", "n": 3 }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('exits', 4,
  'Salir de un grupo',
  $md$Salir de un grupo es más fácil que salir de una conversación de dos, y casi todo el mundo lo complica más de lo necesario.

El error es dirigirse al círculo entero: esperar un hueco, anunciar que te vas a todos, y parar la conversación para que cinco personas se despidan. Es una pequeña ceremonia que nadie quería, y convierte el irse en un acontecimiento.

**La jugada:** sal de lado, no por delante.

Un gesto a quien tengas más cerca, un *hasta luego* bajito a una persona, y das un paso atrás fuera del círculo. La conversación sigue, nadie tiene que interpretar una despedida, y no has convertido tu salida en un momento. Esto es comportamiento de grupo completamente normal y se lee como estar del todo cómodo.

La excepción es un grupo de tres, donde escabullirse es imposible sin que se note. Ahí una frase clara para los dos es lo correcto: es un círculo lo bastante pequeño como para que irse bien no cueste nada.$md$,
  $j$[
    {
      "situation": "Estás en un círculo de seis y quieres irte.",
      "line": "(un gesto a quien tienes al lado, y un paso atrás)",
      "why": "Sin anuncio, sin ceremonia, sin pausa en la conversación. Así es como sale de los grupos la gente cómoda."
    },
    {
      "situation": "Estás en un grupo de tres y no puedes irte sin que se note.",
      "line": "Os dejo a los dos. Me ha alegrado veros.",
      "why": "En un grupo pequeño una frase limpia es lo correcto. Escabullirse de tres personas se nota en vez de quedar suave."
    },
    {
      "situation": "Estás a mitad de conversación con una persona dentro de un grupo más grande.",
      "line": "Te dejo seguir. Un placer hablar contigo.",
      "why": "Cierra con la persona con la que hablabas de verdad y deja el grupo sin molestar."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Quieres irte de un círculo de seis personas a mitad de conversación. ¿Cuál es la forma más suave?",
      "options": [
        { "text": "Esperar un hueco y decirle al grupo que te vas.", "correct": false, "note": "Crea una pequeña ceremonia. Seis personas paran, se despiden, y luego la conversación tiene que arrancar otra vez." },
        { "text": "Un gesto a quien tienes más cerca y un paso atrás fuera del círculo.", "correct": true, "note": "La conversación sigue sin molestias y nadie tiene que interpretar una despedida. Esto es comportamiento de grupo normal y cómodo." },
        { "text": "Despedirte de cada persona por separado.", "correct": false, "note": "Convierte el irse en una procesión de cinco minutos y hace de tu marcha el acontecimiento principal del grupo." },
        { "text": "Irte sin reconocer a nadie.", "correct": false, "note": "Casi correcto, pero desaparecer del todo puede leerse como brusco. Un pequeño reconocimiento no cuesta nada." }
      ],
      "explain": "Sal de lado de un grupo grande con un pequeño reconocimiento. Guarda el anuncio claro para grupos de tres o menos."
    },
    {
      "prompt": "Estás en un grupo de tres y quieres irte. ¿Cuál es la forma más suave?",
      "options": [
        { "text": "Escabullirte mientras los otros dos hablan.", "correct": false, "note": "Funciona con seis, se nota con tres. Desaparecer de un círculo pequeño se ve al instante." },
        { "text": "Esperar a que se una alguien más y entonces irte.", "correct": false, "note": "Buena táctica, y puede que esperes un buen rato." },
        { "text": "Despedirte de cada uno por separado.", "correct": false, "note": "Convierte una salida de tres segundos en una pequeña procesión." },
        { "text": "Una frase clara para los dos, y fuera.", "correct": true, "note": "En un grupo pequeño una frase limpia no cuesta nada e irse sin que se note es imposible." }
      ],
      "explain": "Ajusta la salida al tamaño del grupo. Escúrrete de uno grande; cierra limpio con uno pequeño."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_ceremony", "label": "No lo convertiste en un acontecimiento", "description": "Te fuiste sin parar la conversación del grupo para una despedida." },
      { "key": "acknowledged_someone", "label": "Reconociste al menos a una persona", "description": "Diste un gesto o una palabra baja en vez de desaparecer del todo." },
      { "key": "sized_to_the_group", "label": "Ajustaste el método al tamaño", "description": "Te escurriste de un grupo grande y cerraste claro con uno pequeño." },
      { "key": "left_cleanly", "label": "Te fuiste pronto", "description": "No anunciaste y luego te quedaste." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Una fiesta abarrotada en una casa. Estás en un círculo de seis, la conversación está animada, y quieres ir a buscar a otra persona.",
    "partner": {
      "name": "el grupo",
      "role": "seis personas a mitad de conversación",
      "personality": "Absortos en su propia conversación y completamente relajados. Encantados de que la gente entre y salga sin ceremonias.",
      "mood": "Ruidosos y pasándoselo bien.",
      "openness": 4
    },
    "opening_beat": "El grupo va por la tercera capa de una discusión sobre la mejor forma de cruzar la ciudad, y nadie te está mirando.",
    "success_looks_like": "La persona sale de lado con un pequeño reconocimiento, y la conversación sigue sin una pausa.",
    "constraints": [
      "Mantente en el personaje como el grupo entero. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Mantén la conversación en marcha con energía todo el rato.",
      "Si salen con un gesto o una palabra baja, sigue sin costuras y con calidez.",
      "Si anuncian su marcha al grupo entero, para la conversación, que todos se despidan largamente, y deja que se convierta en una pequeña ceremonia incómoda."
    ]
  }$j$::jsonb,
  $md$Hoy, sal de lado de una conversación de grupo. Un gesto, una palabra baja a una persona, y fuera. Anota qué tal fue comparado con anunciarlo.$md$,
  $j${
  "turns": [
    { "instruction": "Dile una cosa baja a una sola persona." },
    { "instruction": "Ahora vete. Sin anuncio al grupo." }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('exits', 5,
  'Escapar sin ofender',
  $md$A veces necesitas salir de una conversación que genuinamente no funciona, y la dificultad es hacerlo sin que la otra persona lo note.

La tentación es una salida dura: ponerte plano y cortante para que el mensaje sea inconfundible. Funciona y le cuesta a alguien su noche, porque lo va a repasar.

**La jugada:** sube un poco la calidez al irte, no la bajes.

Esto suena al revés y es la técnica entera. Una salida cálida de una conversación mala es ambigua de la forma más amable posible: no pueden saber si te fuiste porque no funcionaba o porque tenías que estar en otro sitio. Esa ambigüedad es un regalo, y no te cuesta más que cuatro segundos.

Si alguien te está acaparando, la estructura fiable es nombrar una obligación concreta e irte de inmediato. *Tengo que pillar a Rob antes de que se vaya.* A los motivos concretos es más difícil seguirte que a los vagos.

Tienes permiso para irte de las conversaciones. Hacerlo con calidez es lo que vuelve inofensivo ese hecho.$md$,
  $j$[
    {
      "situation": "Alguien lleva quince minutos hablándote sin parar.",
      "line": "Tengo que pillar a Rob antes de que se vaya. Que disfrutes de la noche.",
      "why": "Una obligación concreta y un cierre cálido. A los motivos concretos no se les puede acompañar; a los vagos sí."
    },
    {
      "situation": "Una conversación se ha vuelto sutilmente incómoda.",
      "line": "Voy a por otra copa. Un placer hablar.",
      "why": "Neutro, cálido, inmediato. No hace falta explicación y ofrecer una solo alargaría la incomodidad."
    },
    {
      "situation": "Te vas de una conversación que ha ido mal y te dicen algo amable.",
      "line": "(contéstalo con calidez, y luego vete)",
      "why": "El último intercambio es el que van a recordar. Contestar con calidez te cuesta dos segundos y cambia lo que fue el encuentro."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Necesitas irte de una conversación que no funciona. ¿Por qué subir la calidez al salir?",
      "options": [
        { "text": "Porque hace más probable que te vuelvan a hablar.", "correct": false, "note": "Ese no es el objetivo aquí, y tratar la calidez como una inversión suele hacer que se note como tal." },
        { "text": "Porque deja ambiguo el motivo, que es más amable.", "correct": true, "note": "No pueden saber si te fuiste porque no funcionaba o porque tenías que estar en otro sitio. Esa ambigüedad les ahorra el repaso." },
        { "text": "Porque es más honesto.", "correct": false, "note": "Podría decirse que es algo menos honesto. El argumento a favor es la amabilidad, no la exactitud." },
        { "text": "Porque una salida fría podría provocar una discusión.", "correct": false, "note": "Rara vez provoca conflicto. Lo que provoca es que alguien se sienta mal calladamente después, que es lo que hay que evitar de verdad." }
      ],
      "explain": "Una salida cálida deja ambiguo el motivo. Esa ambigüedad es lo más amable que puedes ofrecerle a alguien de quien te vas."
    },
    {
      "prompt": "¿Por qué funciona mejor un motivo concreto que uno vago al escapar?",
      "options": [
        { "text": "A un motivo vago se le puede acompañar.", "correct": true, "note": "Debería moverme invita a que te acompañen. Tengo que pillar a Rob antes de que se vaya no se puede acompañar." },
        { "text": "Es más honesto.", "correct": false, "note": "Muchas veces es menos honesto. El argumento a favor es práctico, no moral." },
        { "text": "Suena más urgente.", "correct": false, "note": "La urgencia no es el mecanismo, y exagerarla hace la salida más llamativa." },
        { "text": "Les da información que pueden usar.", "correct": false, "note": "No necesitan la información. Va de si el motivo se puede seguir." }
      ],
      "explain": "A los motivos vagos se les puede acompañar. A una persona o una obligación con nombre no, que es justo el objetivo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "raised_warmth", "label": "Saliste más cálido, no más frío", "description": "Subiste la calidez al irte en vez de ponerte plano para señalar el problema." },
      { "key": "specific_reason", "label": "Diste un motivo concreto", "description": "Nombraste una obligación concreta y no una vaga a la que se pudiera seguir." },
      { "key": "left_promptly", "label": "Te fuiste justo después de decirlo", "description": "No anunciaste y luego te quedaste, que socava el motivo." },
      { "key": "no_message_sent", "label": "No mandaste ningún mensaje", "description": "La otra persona no se quedó con la sensación de que habían escapado de ella." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Una fiesta de trabajo. Alguien lleva doce minutos contándote con detalle considerable la reforma de su buhardilla.",
    "partner": {
      "name": "Gordon",
      "role": "un compañero de otro departamento",
      "personality": "Bienintencionado y completamente ajeno a cuánto lleva hablando. Sigue las salidas vagas sin darse cuenta, y acepta las concretas sin problema.",
      "mood": "Entusiasmado y bien instalado.",
      "openness": 5
    },
    "opening_beat": "Gordon coge aire un momento y luego empieza a explicar el proceso del permiso de obra.",
    "success_looks_like": "La persona sale con una obligación concreta y con la calidez subida, y Gordon se queda sintiéndose perfectamente bien con el intercambio.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Sigue hablando de la reforma con extensión salvo que se vayan.",
      "Si dan un motivo vago del tipo tengo que moverme, ofrécete a acompañarles y sigue con la historia.",
      "Si nombran a una persona o una obligación concreta, acéptalo con alegría y déjales ir."
    ]
  }$j$::jsonb,
  $md$Hoy, sal de una conversación que no funcionaba y sé más cálido al irte de lo que fuiste en medio. Anota el motivo que diste.$md$,
  null);
