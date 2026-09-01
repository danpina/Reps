-- Spanish: El trabajo, track 2 — Tu jefe.
--
-- Conventions as migration 121. Notes:
--
-- **"One-to-one" is "el uno a uno".** It is what the meeting is called in a
-- Spanish office, and the track description already uses it.
--
-- **The hedge list is rewritten, not translated.** English stacks its exits as
-- "if you have a moment", "no rush", "not urgent", "at some point"; Spanish
-- stacks the same four as "si tienes un momento", "sin prisa", "no es urgente",
-- "en algún momento". Same function, and each had to be found rather than
-- converted — "whenever suits" has no word-for-word Spanish, it is "cuando te
-- venga bien".
--
-- **"Weather" stays weather.** The metaphor for a warning nobody registers —
-- "that is weather, and it will be heard as weather" — works identically in
-- Spanish as "el tiempo que hace", and it is the whole hinge of lesson 5.

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

select pg_temp.es_lesson('your-manager', 1,
  'Pide la media hora',
  $md$Muchísima gente no tiene ningún rato fijo con su jefe y no lo ha pedido nunca, y el motivo casi siempre es el mismo: pedirlo parece que necesita una justificación, y no pasa nada malo.

No la necesita. *¿Podríamos hacer media hora fija, cada dos semanas?* es una petición a la que quien dirige dice que sí casi sin excepción, y probablemente sea la frase con más rentabilidad de todo este tema. Un jefe la oye como alguien que quiere que le dirijan bien, que es un regalo pequeño en una semana que sobre todo contiene problemas.

**La jugada:** pide el rato, nombra el ritmo, y no construyas un caso para que te dejen hablar.

El ritmo es la parte que la gente se deja, y es la que importa. Una charla suelta hay que justificarla cada vez que ocurre; un hueco fijo se justifica una vez y a partir de ahí sencillamente existe, lo que significa que eso que te daría pavor plantear dentro de tres meses ya tiene un sitio al que ir.

Si es algo suelto — quieres una conversación concreta — funciona la misma forma. Nombra el tema, nombra la duración, y para. *¿Me das veinte minutos esta semana para lo de los informes?* está completo. Lo que lo convierte en un problema es el disfraz: *si tienes un momento en algún momento, sin prisa, no es urgente* invita a un no aportando cuatro maneras de darlo.

Y el miedo que merece la pena nombrar, porque es el que frena a la gente: *van a pensar que pasa algo*. Lo van a preguntar, una vez, y *no pasa nada, es que prefiero no ir acumulando cosas* es la respuesta entera. A nadie se le ha tenido nunca en menos por querer media hora fija.

Si te quedas con una cosa: pide un ritmo, no un favor. Pedido una vez, no hay que volver a pedirlo nunca.$md$,
  $j$[
    {
      "situation": "No tienes ningún uno a uno fijo y no lo has pedido nunca.",
      "line": "¿Podríamos hacer media hora fija, cada dos semanas?",
      "why": "Nombra la cosa y el ritmo, y no pide nada más. Quien dirige dice que sí a esto casi sin excepción, y oye a alguien que quiere que le dirijan bien."
    },
    {
      "situation": "Quieres una conversación concreta sobre el trabajo de los informes.",
      "line": "¿Me das veinte minutos esta semana para lo de los informes?",
      "why": "Tema, duración, parar. Es una petición completa y no hay nada dentro que negociar."
    },
    {
      "situation": "Estás a punto de escribir «si tienes un momento en algún momento, sin prisa».",
      "line": "(eso son cuatro maneras de decir que no, ofrecidas por adelantado)",
      "why": "El disfraz es lo que convierte un sí fácil en algo que tienen que sacar tiempo para hacer. Pídelo con llaneza y se responde con llaneza."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué pedir un ritmo en vez de una charla?",
      "options": [
        { "text": "Demuestra compromiso.", "correct": false, "note": "Gestión de la imagen. El valor es estructural y no va de cómo te deja a ti." },
        { "text": "Un hueco fijo se justifica una vez y luego sencillamente existe.", "correct": true, "note": "Una charla suelta hay que justificarla cada vez. Un ritmo significa que eso que te dará pavor plantear dentro de tres meses ya tiene sitio al que ir." },
        { "text": "Quien dirige prefiere las reuniones regulares.", "correct": false, "note": "Unos sí y otros no. El beneficio aquí es tuyo, y se sostiene en cualquier caso." },
        { "text": "Consigues más tiempo suyo en total.", "correct": false, "note": "Normalmente cierto y no viene al caso. Previsible gana a abundante." }
      ],
      "explain": "Pide un ritmo una vez y no hay que volver a pedirlo."
    },
    {
      "prompt": "¿Qué tiene de malo «si tienes un momento en algún momento, sin prisa»?",
      "options": [
        { "text": "Es demasiado informal.", "correct": false, "note": "Lo informal está bien y a menudo es lo correcto. El registro no es el problema." },
        { "text": "No dice de qué quieres hablar.", "correct": false, "note": "Una carencia real, y menor. Puedes ser vago sobre el tema y conseguir la reunión igual." },
        { "text": "Suena a que no estás seguro de ti.", "correct": false, "note": "Cómo suena es lo de menos. Lo que hace es más concreto que eso." },
        { "text": "Aporta cuatro maneras distintas de decir que no.", "correct": true, "note": "Cada matiz es una salida que has entregado tú. Un sí fácil se convierte en algo que ya harán, y luego no hacen." }
      ],
      "explain": "Nómbralo, nombra la duración, y para. Los matices están haciendo lo contrario de lo que parece."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked", "label": "Lo pidió de verdad", "description": "Hizo la petición en vez de insinuarla." },
      { "key": "rhythm", "label": "Nombró un ritmo o una duración", "description": "Pidió algo concreto en vez de tiempo en general." },
      { "key": "no_justification", "label": "No lo justificó", "description": "Se saltó construir un caso para que le dejaran hablar." },
      { "key": "no_exits", "label": "No dejó salidas fáciles", "description": "Evitó apilar matices que invitan a un no." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa",
      "mood": "Entre reuniones, sin prisa durante los próximos treinta segundos.",
      "openness": 4,
      "personality": "Ocupada y perfectamente accesible. Dice que sí de inmediato a una petición clara y que sí de forma vaga a una llena de matices, y luego se le olvida."
    },
    "setting": "La cocina del trabajo. Tu jefa se está haciendo un café y llevas unos cuatro meses queriendo pedirle un rato fijo.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Di que sí con calidez y de forma concreta a cualquier petición clara que lleve dentro un ritmo o una duración.",
      "Responde a una petición llena de matices o disfrazada con un sí vago, y sigue a lo tuyo.",
      "Nunca ofrezcas tú una reunión."
    ],
    "opening_beat": "«Ah, hola. ¿Todo bien con el proyecto?»",
    "success_looks_like": "La persona pide un hueco fijo con llaneza, sin justificarlo."
  }$j$::jsonb,
  'Hoy, pídele a una persona un hueco fijo o una duración concreta de su tiempo, sin ninguna justificación pegada. Apunta qué pediste.',
  $j${
    "says": "Ah, hola. ¿Todo bien con el proyecto?",
    "model": {
      "line": "Todo bien. ¿Podríamos hacer media hora fija cada dos semanas? No pasa nada, es que prefiero no ir acumulando cosas.",
      "why": "Nombra la cosa y el ritmo, responde a la única pregunta que plantea antes de que se la hagan, y no justifica nada más. Esta es la frase a la que quien dirige dice que sí casi sin excepción."
    },
    "checks": [
      { "kind": "contains_any", "words": ["media hora", "treinta minutos", "veinte minutos", "20 minutos", "semanal", "quincenal", "fija", "fijo", "cada semana", "cada dos semanas", "cada quince días", "mensual"], "requirement": "Pide un ritmo o una duración, no tiempo en general" },
      { "kind": "forbids_any", "words": ["perdona", "perdón", "si tienes tiempo", "cuando te venga bien", "sin prisa", "si puedes sacar", "no es urgente", "en algún momento", "si te parece bien", "si es posible"], "requirement": "Sin matices: cada uno es una salida que has entregado" },
      { "kind": "max_words", "n": 40, "requirement": "Pide, no construyas un caso" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('your-manager', 2,
  'Lleva una cosa que quieras',
  $md$La forma más común de desperdiciar un uno a uno es gastarlo en dar el estado, y mientras está pasando no se siente como un desperdicio. Se siente productivo. Llegas, informas, asienten, todo el mundo se va satisfecho, y no ha pasado nada.

El estado es para lo que sirve escribir. Se lee en noventa segundos a la hora que le convenga, y no necesita la cara de nadie. Gastar media hora agendada recitándolo quema el único hueco de la semana en el que tienes la atención entera de una persona, que es algo genuinamente escaso y la única razón por la que la reunión merece la pena.

**La jugada:** llega con una cosa que quieras de verdad de esa persona.

Una decisión que necesitas que se tome. Una presentación a alguien. Una opinión sobre algo entre lo que estás atascado. Cobertura para una llamada que vas a hacer. Permiso para dejar de hacer algo. Cualquiera de esas usa lo que tiene un jefe y tú no, que es el sentido entero de la relación.

Una, no cuatro. Cuatro cosas significa que la primera se lleva veinticinco minutos y el resto se llevan un *eso lo cogemos la próxima vez*, y la próxima vez tiene sus propias cuatro. Llevar una cosa parece que infrautiliza la reunión y es lo contrario: es la única forma de que salga algo de ella de manera fiable.

Dilo al principio. El instinto es ir subiendo hacia la petición a través del estado, lo que significa que la petición aterriza en el minuto veintiocho con alguien que ya está mirando su siguiente reunión. Ponla la primera y la media hora restante se puede gastar en ella.

Si de verdad no quieres nada, eso merece la pena notarlo en vez de rellenarlo. Lleva en su lugar una pregunta sobre la dirección — hacia dónde creen que va el trabajo — porque media hora gastada en eso sigue estando mejor gastada que media hora gastada en demostrar que has estado ocupado.

Si te quedas con una cosa: manda el estado, y usa la reunión para lo que escribir no puede hacer.$md$,
  $j$[
    {
      "situation": "Tienes un uno a uno mañana y una lista de seis novedades.",
      "line": "(manda las seis, lleva una cosa que quieras)",
      "why": "El estado se lee en noventa segundos a la hora que le convenga. La reunión es el único hueco con su atención entera, y las novedades no necesitan atención."
    },
    {
      "situation": "Tienes cuatro cosas que te gustaría conseguir de esa persona.",
      "line": "(elige la una)",
      "why": "Cuatro significa que la primera se lleva veinticinco minutos y el resto se los lleva la próxima vez. La próxima vez tendrá sus propias cuatro."
    },
    {
      "situation": "Estás pensando ir subiendo hacia la petición a través de las novedades.",
      "line": "(ponla la primera)",
      "why": "Si subes hacia ella, llega en el minuto veintiocho con alguien ya pensando en su siguiente reunión. Puesta la primera, se lleva la media hora."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué se desperdicia un uno a uno gastado en dar el estado?",
      "options": [
        { "text": "Tu jefe ya sabe casi todo.", "correct": false, "note": "A menudo no lo sabe, y por eso parece necesario. El problema es el medio y no el contenido." },
        { "text": "Usa su atención entera en algo que no la necesitaba.", "correct": true, "note": "La atención es lo escaso de la sala y la única razón por la que la reunión gana a un mensaje. El estado se lee en noventa segundos a la hora que le convenga." },
        { "text": "Hace que parezcas alguien que necesita supervisión.", "correct": false, "note": "No lo hace, y preocuparse por eso es lo que produce el informe pulido en primer lugar." },
        { "text": "Se tarda demasiado.", "correct": false, "note": "La duración no es el asunto. Un estado de cinco minutos en una reunión sigue siendo la cosa equivocada en el recipiente equivocado." }
      ],
      "explain": "Manda el estado. Usa la reunión para lo que escribir no puede hacer."
    },
    {
      "prompt": "Tienes cuatro cosas que quieres de esa persona. ¿Qué llevas?",
      "options": [
        { "text": "Las cuatro, rápido, para que no se pierda ninguna.", "correct": false, "note": "La primera se lleva veinticinco minutos y las otras tres se las lleva la próxima vez, que tiene sus propias cuatro." },
        { "text": "Las dos más importantes.", "correct": false, "note": "Mejor, y sigue partiendo la media hora. Dos peticiones son una petición con una cola detrás." },
        { "text": "Una.", "correct": true, "note": "Parece que infrautiliza la reunión y es la única forma de que salga algo de ella de manera fiable." },
        { "text": "Aquella a la que sea más probable que digan que sí.", "correct": false, "note": "Eso optimiza para un sí en vez de para lo que necesitas, y el sí fácil rara vez es el que merecía su atención." }
      ],
      "explain": "Una cosa, dicha al principio. Todo lo demás es un mensaje."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_thing", "label": "Llevó una cosa", "description": "Llegó con una sola petición en vez de con una lista." },
      { "key": "a_want", "label": "Era algo que quería", "description": "Una decisión, una presentación, una opinión o cobertura, no una novedad." },
      { "key": "first", "label": "Lo dijo pronto", "description": "Empezó por la petición en vez de ir subiendo hacia ella." },
      { "key": "status_elsewhere", "label": "Puso el estado por escrito", "description": "No gastó la atención en lo que se podía leer." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa",
      "mood": "Presente, con una reunión después de esta.",
      "openness": 4,
      "personality": "Atenta al principio y cada vez más distraída según avanza la media hora. Toma decisiones sin problema cuando de verdad se le pide una."
    },
    "setting": "Tu media hora quincenal. Estás bloqueado en una decisión sobre el trabajo de los informes que solo puede tomar tu jefa, y además tienes seis novedades.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Escucha con educación un repaso de novedades y ponte visiblemente más seca según avanza.",
      "Métete del todo y decide cuando te pidan una decisión directamente.",
      "Nunca le preguntes a la persona si necesita algo."
    ],
    "opening_beat": "«Vale, media hora. ¿Qué tienes?»",
    "success_looks_like": "La persona empieza por la cosa que quiere en vez de por las novedades."
  }$j$::jsonb,
  'Hoy, entra en una reunión con una sola cosa que quieras de ella, y dila la primera. Apunta qué pediste y qué pasó.',
  $j${
    "beats": [
      {
        "situation": "Tu media hora quincenal empieza dentro de una hora. Tienes seis novedades y una decisión en la que estás bloqueado.",
        "prompt": "¿Cuál es el plan para la reunión?",
        "options": [
          { "text": "Pasar las novedades, y plantear la decisión al final.", "correct": false, "note": "La petición aterriza en el minuto veintiocho con alguien ya pensando en su siguiente reunión. Este es el plan por defecto y es por lo que sale tan poco de estas." },
          { "text": "Mandar las novedades antes y abrir con la decisión.", "correct": true, "note": "El estado se lee en noventa segundos a la hora que le convenga. La reunión es el único hueco con su atención entera, y las novedades no necesitan atención." },
          { "text": "Llevar las dos cosas: deberían oír las novedades en persona.", "correct": false, "note": "¿Deberían? Casi nada de un repaso de novedades mejora por decirse en voz alta, y cuesta lo único escaso que hay en la sala." },
          { "text": "Saltarse la reunión y mandarlo todo por escrito.", "correct": false, "note": "Pasarse de corrección. La decisión es justo aquello para lo que escribir es malo, que es para lo que sirve la media hora." }
        ]
      },
      {
        "situation": "Estás en la reunión y tienes cuatro cosas que de verdad te gustaría conseguir.",
        "prompt": "¿Cuántas planteas?",
        "options": [
          { "text": "Las cuatro, rápido: ninguna es grande.", "correct": false, "note": "La primera se lleva veinticinco minutos y el resto se los lleva la próxima vez, que llegará con sus propias cuatro." },
          { "text": "Dos, y el resto por mensaje.", "correct": false, "note": "Mejor, y dos peticiones siguen siendo una petición con una cola detrás. La media hora se parte y no se decide ninguna." },
          { "text": "Ninguna: preguntar en qué creen que deberías centrarte.", "correct": false, "note": "Una buena pregunta que tener y un mal sustituto de lo que de verdad necesitabas. La dirección es el recurso para cuando no tienes nada." },
          { "text": "Una.", "correct": true, "note": "Parece que infrautiliza la reunión y es la única forma de que salga algo de ella de manera fiable." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('your-manager', 3,
  'Discrepa una vez, en privado',
  $md$Tu jefe ha decidido algo y a ti te parece que está mal. La elección parece ser objetar delante de todo el mundo o no decir nada, y la gente callada elige lo segundo casi siempre y luego carga la decisión durante semanas.

Hay una tercera opción, y es la que usa de verdad la gente sénior.

**La jugada:** discrepa una vez, en privado, con llaneza, y luego comprométete en público salga como salga.

Cada parte de eso está haciendo trabajo. *Una vez*, porque la segunda ya no es discrepar, es una campaña, y convierte un argumento razonable en un problema contigo. *En privado*, porque discrepar en la sala le pide a los demás que tomen partido, lo que sube el coste para tu jefe y lo convierte en una cuestión de estatus en vez de una cuestión sobre la decisión. *Con llaneza*, porque un desacuerdo envuelto en suficiente suavizado como para poder negarlo se va a recibir como una preocupación leve y se va a archivar como nada.

La última parte es la que hace segura a todo el resto, y es la que la gente se deja: di por adelantado que lo vas a apoyar salga como salga. *Creo que nos equivocamos en esto, y te digo por qué; y si aun así quieres ir por ahí, me pongo detrás en serio.* Esa frase no te cuesta nada, porque ibas a tener que vivir con la decisión de todas formas, y te compra el derecho a decir la primera mitad sin que se lea como una amenaza de no colaborar.

Discute la decisión, no a la persona y no el proceso. *Creo que el riesgo es el calendario* es una postura. *No creo que nadie se lo haya pensado de verdad* es una acusación con una postura escondida dentro, y solo una de las dos recibe respuesta.

Y no te convierte en alguien difícil. A quien discute en privado y apoya en público se le pide su opinión más, no menos, porque su opinión es segura de pedir.

Si te quedas con una cosa: di el desacuerdo y el compromiso en el mismo aliento. La segunda mitad es lo que te deja decir la primera.$md$,
  $j$[
    {
      "situation": "Han decidido recortar la semana de pruebas y tú crees que es un error.",
      "line": "Creo que nos equivocamos en esto, y si aun así quieres ir por ahí, me pongo detrás en serio.",
      "why": "El compromiso es lo que hace seguro decir el desacuerdo. No cuesta nada — ibas a vivir con la decisión de todos modos — e impide que la objeción se lea como una amenaza de no colaborar."
    },
    {
      "situation": "Estás a punto de decirlo en la reunión de equipo.",
      "line": "(en privado; la sala lo convierte en una cuestión de estatus)",
      "why": "Discrepar delante de gente le pide a todo el mundo que tome partido y sube el coste para tu jefe. El mismo argumento, en una sala mucho más cara."
    },
    {
      "situation": "Ya has hecho el argumento y han decidido igualmente.",
      "line": "(esa era la vez)",
      "why": "Un segundo intento es una campaña, no un desacuerdo, y convierte un argumento razonable en un problema contigo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué te compra en realidad decir «lo apoyo salga como salga»?",
      "options": [
        { "text": "El derecho a decir el desacuerdo con llaneza.", "correct": true, "note": "Sin ello, una objeción fuerte se lee como una amenaza de no colaborar. Con ello, puedes ser todo lo directo que quieras, y no te cuesta nada que no fueras a hacer igualmente." },
        { "text": "Suaviza el desacuerdo.", "correct": false, "note": "No lo suaviza en absoluto: te deja afilarlo. Suavizar es lo que hace que una objeción se archive como una preocupación leve." },
        { "text": "Demuestra que eres alguien de equipo.", "correct": false, "note": "Un subproducto. Plantearlo así convierte una jugada práctica en una actuación." },
        { "text": "Te deja margen para decir «te lo dije».", "correct": false, "note": "Eso es lo contrario de comprometerse, y es lo que hace que discrepar contigo salga caro." }
      ],
      "explain": "Desacuerdo y compromiso en un mismo aliento. La segunda mitad es lo que autoriza la primera."
    },
    {
      "prompt": "¿Por qué una vez, y solo una?",
      "options": [
        { "text": "Porque ya te han oído.", "correct": false, "note": "Cierto y no es el motivo. Que te hayan oído no descartaría por sí solo volver a decirlo." },
        { "text": "Porque repetirlo es de mala educación.", "correct": false, "note": "La educación no es el mecanismo. Hay mucha repetición educada y aun así cara." },
        { "text": "Porque puede que te equivoques.", "correct": false, "note": "Puede, y eso es un argumento para decirlo una vez, no para no decirlo nunca." },
        { "text": "Porque la segunda vez es una campaña, no un desacuerdo.", "correct": true, "note": "Convierte un argumento razonable en un problema contigo, y lo que se juzga deja de ser la decisión." }
      ],
      "explain": "Una vez, en privado, con llaneza. Y a partir de ahí es su decisión y tú estás detrás."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_it", "label": "Discrepó de verdad", "description": "Enunció la postura en vez de señalar vagamente una preocupación." },
      { "key": "plainly", "label": "Lo dijo con llaneza", "description": "No lo suavizó hasta volverlo negable." },
      { "key": "committed", "label": "Se comprometió salga como salga", "description": "Dejó claro que apoyaría la decisión fuera cual fuera." },
      { "key": "the_decision", "label": "Discutió la decisión", "description": "La mantuvo lejos de la persona y lejos del proceso." },
      { "key": "once", "label": "Lo dijo una vez", "description": "No lo reabrió cuando la decisión se mantuvo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa, que acaba de tomar una decisión con la que no estás de acuerdo",
      "mood": "Comprometida con la fecha, consciente de que va justa.",
      "openness": 4,
      "personality": "Razonable y con presión desde arriba. Defiende la decisión una vez, escucha de verdad un argumento llano, y se pone a la defensiva si el argumento se repite después de haberse zanjado."
    },
    "setting": "Una llamada privada con tu jefa, al día siguiente de anunciar que se recorta la semana de pruebas para llegar a la fecha de lanzamiento. Tú crees que es la decisión equivocada.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Defiende la decisión al menos una vez antes de conceder nada.",
      "Tómate en serio un desacuerdo llano y comprometido, y piénsalo en voz alta.",
      "Ponte visiblemente a la defensiva si la persona lo reabre después de que lo hayas zanjado.",
      "Nunca cambies de opinión del todo: como mucho, acepta mirar una parte."
    ],
    "opening_beat": "«¿Querías unos minutos? Si es por la semana de pruebas, ya lo sé, pero la fecha no se mueve.»",
    "success_looks_like": "La persona discrepa con llaneza, una vez, y deja claro que apoyará la decisión salga como salga."
  }$j$::jsonb,
  'Hoy, discrepa de una decisión en privado, y di en el mismo aliento que la vas a apoyar salga como salga. Apunta qué dijiste.',
  '{}'::jsonb
);

select pg_temp.es_lesson('your-manager', 4,
  'Di que no con un intercambio',
  $md$Casi toda carga de trabajo desmedida sobrevive porque nadie hizo visible el intercambio.

El trabajo llega de pieza en pieza, cada pieza es razonable por separado, y cada sí es más fácil que la conversación que exigiría un no. Y entonces en algún momento el total es imposible, y para entonces parece un problema personal de capacidad en vez de una serie de decisiones que tomó alguien.

**La jugada:** no rechaces. Haz explícito el intercambio.

*Puedo, si se mueve algo: la migración o los informes. ¿Cuál prefieres que deje?* Eso no es un no. Es un sí con la aritmética pegada, y cambia la conversación desde tu disposición — donde vas a perder siempre, porque estás dispuesto — hacia sus prioridades, que es a donde pertenecía y donde están mucho mejor equipados para decidir que tú.

Además quita eso que te daba pavor. Un rechazo invita a una negociación sobre ti: si estás estirado, si deberías estarlo, si otra gente se apaña. Un intercambio invita a una decisión sobre trabajo, y casi todos los jefes la toman en unos cuatro segundos y no piensan peor de nadie.

Tres cosas que dejar fuera. *Perdona*: no hay nada de lo que disculparse en un dato de calendario. *Lo intento*, que es un sí con un matiz puesto, y el matiz no se va a recordar cuando llegue tarde. Y la versión silenciosa, en la que lo coges, lo absorbes, y dejas que el coste aparezca más tarde como una fecha incumplida de la que se entera otra persona.

Si dicen que todo tiene que pasar, eso es información y no una derrota, y merece la pena tenerlo por escrito. *Entendido, entonces los hago en este orden, así que los informes caen el jueves y no el martes* no es rebeldía. Es un plan, y pone la consecuencia donde se tomó la decisión.

Si te quedas con una cosa: no digas nunca que no, y no digas nunca que sí a secas. Di lo que cuesta y deja que elijan.$md$,
  $j$[
    {
      "situation": "«¿Puedes coger también el informe Henderson?»",
      "line": "Puedo, si se mueve algo: la migración o los informes. ¿Cuál prefieres que deje?",
      "why": "Un sí con la aritmética pegada. Mueve la pregunta desde tu disposición, donde pierdes siempre, hacia sus prioridades, donde están mejor situados para decidir."
    },
    {
      "situation": "Estás a punto de decir que intentarás encajarlo.",
      "line": "(eso es un sí con un matiz puesto)",
      "why": "El matiz no se va a recordar cuando llegue tarde. Solo se va a recordar el sí."
    },
    {
      "situation": "Dicen que todo tiene que pasar.",
      "line": "Entendido, entonces los informes caen el jueves y no el martes.",
      "why": "No es rebeldía, es un plan. Devuelve la consecuencia al sitio donde se tomó la decisión, y merece la pena tenerlo por escrito."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué un intercambio es más fácil que un rechazo?",
      "options": [
        { "text": "Es más educado.", "correct": false, "note": "La educación no es lo que hace el trabajo, y un no llano puede ser perfectamente educado." },
        { "text": "Toma una decisión sobre trabajo en vez de sobre ti.", "correct": true, "note": "Un rechazo invita a una negociación sobre si estás estirado y si deberías estarlo. Un intercambio se responde en unos cuatro segundos." },
        { "text": "Es más difícil de rebatir.", "correct": false, "note": "Lo es, y eso es una consecuencia del cambio de encuadre y no el motivo por el que funciona." },
        { "text": "Suena más dispuesto.", "correct": false, "note": "Estás dispuesto: eso nunca estuvo en duda, y es justo por lo que la conversación sobre la disposición te sale mal." }
      ],
      "explain": "Vas a perder una discusión sobre tu disposición. No vas a perder una sobre aritmética."
    },
    {
      "prompt": "Dicen que todo tiene que pasar igualmente. ¿Y ahora?",
      "options": [
        { "text": "Cogerlo y absorber el coste.", "correct": false, "note": "El coste aparece más tarde como una fecha incumplida que descubre otra persona, que es la peor versión posible." },
        { "text": "Insistir una segunda vez.", "correct": false, "note": "Hiciste visible el intercambio y eligieron. El segundo intento vuelve a ser sobre ti." },
        { "text": "Escalarlo a su jefe.", "correct": false, "note": "Un instrumento enorme para una decisión de prioridades corriente, y gasta algo que vas a querer más adelante." },
        { "text": "Nombrar el orden y la consecuencia, por escrito.", "correct": true, "note": "No es rebeldía, es un plan. Devuelve la consecuencia al sitio donde se tomó la decisión de verdad." }
      ],
      "explain": "Si todo tiene que pasar, di en qué orden pasa y qué cuesta eso."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "trade", "label": "Hizo visible el intercambio", "description": "Nombró qué tendría que moverse." },
      { "key": "no_apology", "label": "No se disculpó", "description": "Lo trató como un dato de calendario y no como un fallo personal." },
      { "key": "no_hedge", "label": "No dijo que lo intentaría", "description": "Evitó un sí con un matiz puesto." },
      { "key": "let_them_choose", "label": "Les dejó decidir", "description": "Entregó la decisión de prioridad a quien le corresponde." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa",
      "mood": "Apagando fuegos, sin mala intención.",
      "openness": 4,
      "personality": "Razonable y algo sobrecargada. Acepta un intercambio de inmediato y toma la decisión; oye un sí con matices como un sí a secas y sigue adelante."
    },
    "setting": "Un mensaje de tu jefa un martes. Ya llevas la migración y el trabajo de los informes, los dos con fecha.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Toma la decisión de prioridad sin problema y sin quejarte cuando te den un intercambio.",
      "Trata un «lo intento» o un «veré qué puedo hacer» como un sí sin más, y sigue adelante.",
      "Nunca te ofrezcas a quitarle nada de encima."
    ],
    "opening_beat": "«¿Puedes coger también el informe Henderson? No debería ser mucho encima de lo que tienes.»",
    "success_looks_like": "La persona dice que sí con el intercambio pegado en vez de rechazar o poner matices."
  }$j$::jsonb,
  'Hoy, di que sí a una cosa con el intercambio pegado: nombra qué se mueve. Apunta qué dijiste y qué eligieron.',
  $j${
    "says": "¿Puedes coger también el informe Henderson? No debería ser mucho encima de lo que tienes.",
    "model": {
      "line": "Puedo, si se mueve algo: la migración o los informes. ¿Cuál prefieres que deje?",
      "why": "Un sí con la aritmética pegada. Saca la pregunta de tu disposición, donde vas a perder siempre, y la lleva a sus prioridades, donde la decisión les corresponde y les cuesta cuatro segundos."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Devuélveles la decisión de prioridad" },
      { "kind": "contains_any", "words": ["mueve", "mover", "deje", "dejar", "en vez", "sale", "se retrasa", "aplazar", "pausar", "más tarde", "cuál"], "requirement": "Nombra qué tendría que moverse" },
      { "kind": "forbids_any", "words": ["perdona", "perdón", "lo intento", "intentaré", "veré qué puedo hacer", "sin problema", "por supuesto", "encajarlo", "como sea"], "requirement": "Ni una disculpa, ni un sí con un matiz puesto" },
      { "kind": "max_words", "n": 30, "requirement": "Una frase y una pregunta" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('your-manager', 5,
  'Malas noticias, pronto y claras',
  $md$Las malas noticias viajan mal hacia arriba. Llegan tarde, suavizadas, y normalmente justo después del último momento en que alguien podría haber hecho algo, y esa combinación, y no la noticia en sí, es lo que le hace daño a la gente.

El motivo de que lleguen tarde no es la deshonestidad. Es la esperanza. Crees que todavía hay una posibilidad de que salga bien, y contárselo a alguien ahora significa admitir algo que todavía no has terminado de admitirte a ti mismo. Así que esperas a la certeza, y la certeza llega el día de la fecha límite.

**La jugada:** dilo el día que lo sabes, con las palabras más llanas disponibles, y con lo que harías al respecto.

Lo llano es la parte que requiere práctica. *Hay algo de riesgo con el viernes* no es un aviso, es el tiempo que hace, y se va a oír como tal; y luego, cuando el viernes se caiga, la persona a la que se lo dijiste no va a recordar genuinamente que se lo dijeras, y va a tener razón, porque no se lo dijiste. *La fecha del viernes no va a salir* es un aviso.

Lleva una opción con ello. No un problema resuelto: no hace falta que lo hayas arreglado, y esperar a haberlo hecho es como se hace tarde. *Lo más pronto es el miércoles, y esto es lo que recortaría si eso no vale* te convierte de alguien que entrega un problema en alguien que carga uno, y cuesta unos diez segundos de pensar.

Lo que sacas de esto es contraintuitivo y fiable: contárselo pronto a alguien lo convierte también en su problema, que es de lo que se trata. Un jefe tiene palancas que tú no — puede mover una fecha, comprar tiempo hacia arriba, quitarte algo de encima — y todas ellas funcionan mejor con tres semanas que con tres días.

Y merece la pena nombrar el miedo. Nadie piensa menos de ti por una fecha que se retrasa, cosa que pasa constantemente. Piensan menos de quien les deja entrar en una reunión sin estar preparados para algo que ya se sabía.

Si te quedas con una cosa: dilo el día que lo sabes, con palabras que no se puedan confundir con el tiempo que hace.$md$,
  $j$[
    {
      "situation": "El martes te das cuenta de que el viernes se ha ido.",
      "line": "La fecha del viernes no va a salir; lo más pronto es el miércoles.",
      "why": "Dicho el día que se supo, con palabras que no se pueden oír como el tiempo que hace. Tres días de aviso valen más que cualquier cantidad de suavizado."
    },
    {
      "situation": "Estás a punto de decir que hay algo de riesgo con el viernes.",
      "line": "(eso es el tiempo que hace, y se va a oír como el tiempo que hace)",
      "why": "Cuando el viernes se caiga, no van a recordar genuinamente que se les avisara, y van a tener razón, porque no se les avisó."
    },
    {
      "situation": "Quieres esperar a tener un arreglo.",
      "line": "(lleva una opción, no una solución)",
      "why": "Esperar al arreglo es como se convierte en una noticia tardía. «Esto es lo que recortaría» cuesta diez segundos y basta."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué llegan tarde las malas noticias?",
      "options": [
        { "text": "La gente está evitando la conversación.", "correct": false, "note": "Desde fuera parece evitación. Debajo suele haber algo más concreto." },
        { "text": "Esperanza: estás esperando a estar seguro.", "correct": true, "note": "Contárselo a alguien ahora significa admitir algo que todavía no has terminado de admitirte, así que esperas a la certeza. La certeza llega el día de la fecha límite." },
        { "text": "Nadie quiere parecer incompetente.", "correct": false, "note": "Real, y es el miedo y no el mecanismo. Un montón de gente segura de sí misma también hace esto." },
        { "text": "Nunca hay un buen momento.", "correct": false, "note": "Sí lo hay: el día que lo sabes. La ausencia de un buen momento es a lo que se parece esperar desde dentro." }
      ],
      "explain": "No lo estás escondiendo. Estás esperando a estar seguro, y seguro es demasiado tarde."
    },
    {
      "prompt": "¿Qué tiene de malo «hay algo de riesgo con el viernes»?",
      "options": [
        { "text": "Es demasiado vago para actuar.", "correct": false, "note": "Cerca, y se queda corto. El problema no es que sea difícil de accionar, sino que no se registra como noticia." },
        { "text": "Suena a que no lo tienes controlado.", "correct": false, "note": "Suena bien, que es precisamente el problema." },
        { "text": "No ofrece una solución.", "correct": false, "note": "Un asunto aparte, y no hace falta una solución. Una afirmación llana sin ninguna opción sigue siendo un aviso." },
        { "text": "Es el tiempo que hace, y se va a oír como el tiempo que hace.", "correct": true, "note": "Cuando el viernes se caiga, no van a recordar que se les avisara, y van a tener razón, porque no se les avisó." }
      ],
      "explain": "Lo bastante llano como para que no se pueda confundir con un estado de ánimo. La fecha del viernes no va a salir."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "early", "label": "Lo dijo el día que lo supo", "description": "No esperó a la certeza." },
      { "key": "plain", "label": "Lo dijo con llaneza", "description": "Usó palabras que no se pueden oír como el tiempo que hace." },
      { "key": "an_option", "label": "Llevó una opción", "description": "Ofreció un siguiente paso sin esperar a haberlo arreglado." },
      { "key": "no_burying", "label": "No lo enterró", "description": "Empezó por la noticia en vez de ponerla después de lo bueno." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa",
      "mood": "Ocupada, contando con que el viernes salga.",
      "openness": 4,
      "personality": "Tranquila con las fechas que se retrasan y extremadamente descontenta con las sorpresas. Oye un aviso suavizado como una novedad corriente y no hace nada con él."
    },
    "setting": "Martes por la mañana. Acabas de averiguar que la fecha del viernes no es alcanzable, y tu jefa presenta el plan hacia arriba el jueves.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Recibe con calma un aviso llano y ponte a trabajar el problema de inmediato.",
      "Trata cualquier aviso suavizado o con matices como una novedad normal y sigue contando con el viernes.",
      "Nunca preguntes si hay algún problema."
    ],
    "opening_beat": "«Buenas. ¿Sigue todo en pie para el viernes? El jueves subo el plan.»",
    "success_looks_like": "La persona dice con llaneza que el viernes se ha ido y lleva una opción."
  }$j$::jsonb,
  'Hoy, di una noticia inconveniente el día que la sepas, con palabras que no se puedan confundir con el tiempo que hace. Apunta qué dijiste.',
  $j${
    "says": "Buenas. ¿Sigue todo en pie para el viernes? El jueves subo el plan.",
    "model": {
      "line": "No, la fecha del viernes no va a salir. Lo más pronto es el miércoles, y te puedo decir qué recortaría si eso no vale.",
      "why": "Dicho el día que se supo, con palabras que no se pueden oír como el tiempo que hace, y con una opción pegada. Tres días de aviso valen más que cualquier cantidad de suavizado."
    },
    "checks": [
      { "kind": "contains_any", "words": ["no va a", "no llega", "no llegamos", "no", "no puedo", "se ha ido", "se cae", "incumplir"], "requirement": "Palabras que no se puedan confundir con el tiempo que hace" },
      { "kind": "forbids_any", "words": ["algo de riesgo", "un poco de riesgo", "puede que vaya justo", "va a ir justo", "ojalá", "debería llegar", "seguramente bien", "en el filo", "cruzando los dedos"], "requirement": "Sin suavizar: un riesgo no es un aviso" },
      { "kind": "min_words", "n": 14, "requirement": "Lleva una opción con ello" },
      { "kind": "max_words", "n": 45, "requirement": "Llano y corto" }
    ]
  }$j$::jsonb
);
