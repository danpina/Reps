-- Spanish: El trabajo, track 5 — Decir lo que quieres.
--
-- Conventions as migration 121. Notes:
--
-- **"Skip-level" stays "la jefa de tu jefe" / "quien está un nivel por
-- encima de tu jefe"**, matching migration 124's solution — Spanish has no
-- single noun for the relationship.
--
-- **Lesson 2's max_questions: 0 forced the same rewrite as "Meter baza" in
-- track 1.** A direction cannot be phrased as a question in Spanish without
-- opening with ¿, and this lesson's whole point is that a direction needs no
-- answer — so the Spanish model line states it flatly, never asks it.
--
-- **"Being good is not a bid" became "Ser bueno no es pedirlo"**, keeping the
-- track's own title rather than a literal "una oferta", which in Spanish
-- reads as a business offer and loses the sense of a bid for attention.

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

select pg_temp.es_lesson('saying-what-you-want', 1,
  'Ser bueno no es pedirlo',
  $md$Hay un supuesto silencioso debajo de muchísimas carreras estancadas: que hacer bien el trabajo es una forma de pedir más de él.

No lo es. Es una forma de ser fiable exactamente en lo que haces ahora, y la recompensa más común por ser fiable en una cosa es más de esa misma cosa. Esto no es injusto y nadie te está reteniendo nada. Tu jefe tiene una lista de trabajo que hay que hacer y un conjunto de personas cuyas ambiciones solo puede conocer si esas personas las han dicho en voz alta.

**La jugada:** trata el querer algo como información que tienes que entregar.

Merece la pena ser preciso sobre lo invisible que es esto desde fuera. Alguien que quiere liderar un proyecto y alguien que está perfectamente contento donde está parecen idénticos. Los dos llegan, hacen buen trabajo, y no dicen nada al respecto. No hay ninguna señal. Un jefe que está formando algo interesante no está eligiendo pasarte por alto: está trabajando con una lista de gente que ha dicho cosas, y tú no estás en ella.

Lo que significa que ser bueno no es ni siquiera una pista. La teoría de la pista es la cara: la creencia de que la excelencia constante es una señal legible de ambición. Es una señal legible de competencia, y la competencia es lo que hace que te pidan más de lo mismo.

El reencuadre que hace esto llevadero, si pedirlo se siente como presunción: no estás haciendo una afirmación sobre tu valor. Estás entregando un dato sobre tus preferencias, y la persona a la que se lo entregas no tiene ninguna otra forma de conseguirlo.

Si te quedas con una cosa: nadie puede encaminar nada hacia ti hasta que hayas dicho hacia dónde quieres ir.$md$,
  $j$[
    {
      "situation": "Llevas dos años siendo excelente y no ha cambiado nada.",
      "line": "(la excelencia no es una señal de ambición)",
      "why": "Es una señal de competencia, y la recompensa por ser fiable en una cosa es más de esa misma cosa. Las dos se confunden con frecuencia."
    },
    {
      "situation": "Supones que tu jefe sabe que quieres más.",
      "line": "(pareces exactamente alguien contento)",
      "why": "Las dos personas llegan, hacen buen trabajo y no dicen nada. No hay ninguna señal, así que no hay nada que notar."
    },
    {
      "situation": "Decirlo se siente como una presunción.",
      "line": "(es una preferencia, no una afirmación sobre tu valor)",
      "why": "Estás entregando un dato que la otra persona no tiene ninguna otra forma de conseguir. Es un acto mucho más pequeño de lo que parece."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué ser excelente no lleva a ningún sitio por sí solo?",
      "options": [
        { "text": "Porque los jefes no se dan cuenta.", "correct": false, "note": "Casi siempre se dan cuenta. Lo que no pueden ver es qué quieres, que es un dato completamente distinto." },
        { "text": "Porque otra gente es más insistente.", "correct": false, "note": "Eso es una historia sobre una competición. El problema existe en un equipo donde nadie insiste." },
        { "text": "Porque no hay suficiente para repartir.", "correct": false, "note": "A veces cierto y no es el mecanismo. Un montón de trabajo va a quien mencionó que lo quería." },
        { "text": "Porque la recompensa por ser fiable es más de lo mismo.", "correct": true, "note": "La excelencia señala competencia, no ambición. Alguien que quiere más y alguien que está contento parecen idénticos desde fuera." }
      ],
      "explain": "Ser bueno no es una petición. No es ni siquiera una pista."
    },
    {
      "prompt": "¿Qué hace llevadero decirlo si se siente como presunción?",
      "options": [
        { "text": "Todo el mundo lo hace.", "correct": false, "note": "Probablemente cierto, y es un motivo para sentirse mal en vez de un motivo para actuar." },
        { "text": "Es una preferencia, no una afirmación sobre tu valor.", "correct": true, "note": "Estás entregando un dato que la otra persona no puede conseguir de ninguna otra forma. Es un acto mucho más pequeño que defender tu caso." },
        { "text": "Te lo has ganado.", "correct": false, "note": "Ese encuadre lo convierte en una afirmación que se puede juzgar, que es exactamente lo que hace difícil decirlo." },
        { "text": "Lo peor que pueden decir es que no.", "correct": false, "note": "Cierto, y ataca el miedo en vez del reencuadre. El punto es que no se está haciendo ninguna afirmación en absoluto." }
      ],
      "explain": "No estás argumentando que mereces algo. Estás diciendo hacia dónde te gustaría ir."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_it", "label": "Dijo lo que quería", "description": "Entregó el dato en vez de suponer que era visible." },
      { "key": "no_case", "label": "No construyó un caso", "description": "Enunció una preferencia en vez de defender un veredicto." },
      { "key": "specific", "label": "Fue concreto", "description": "Nombró el tipo de trabajo en vez de señalar vagamente hacia más." },
      { "key": "no_apology", "label": "No se disculpó por quererlo", "description": "Lo trató como información corriente." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa",
      "mood": "Relajada, tiene la media hora entera.",
      "openness": 4,
      "personality": "Genuinamente bien dispuesta y del todo ajena a que quieras que algo cambie. Responde de forma concreta a una dirección declarada y oye las pistas como charla sin más."
    },
    "setting": "Tu uno a uno. Llevas dos años haciendo bien el mismo trabajo y te gustaría algo más grande, y no lo has mencionado nunca.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Tómate en serio una dirección declarada y empieza a pensar en qué podría ir por ahí.",
      "Trata las pistas y el entusiasmo general como charla agradable y sigue adelante.",
      "Nunca preguntes si la persona quiere más responsabilidad."
    ],
    "opening_beat": "«Has estado muy sólido este año. ¿Hay algo de lo que quieras hablar?»",
    "success_looks_like": "La persona dice con llaneza que quiere algo más grande."
  }$j$::jsonb,
  'Hoy, dile en voz alta a una persona qué te gustaría estar haciendo más. Apunta qué dijiste.',
  $j${
    "beats": [
      {
        "situation": "Dos años de buen trabajo constante. No ha cambiado nada y nadie te ha ofrecido nada más grande.",
        "prompt": "¿Qué es lo más probable que esté pasando?",
        "options": [
          { "text": "Tu jefa te está reteniendo donde eres útil.", "correct": false, "note": "Pasa, y es más raro de lo que parece. Suponerlo convierte una ausencia en un agravio y te impide hacer lo único que funciona." },
          { "text": "No hay nada más grande disponible.", "correct": false, "note": "Normalmente sí lo hay, y fue a parar a alguien cuyo nombre salió cuando se discutía la forma de ese trabajo." },
          { "text": "Necesitas ser mejor antes de que cambie algo.", "correct": false, "note": "La trampa. Más excelencia produce más de lo mismo, porque la excelencia señala competencia y no ambición." },
          { "text": "Pareces exactamente alguien contento donde está.", "correct": true, "note": "Alguien que quiere más y alguien satisfecho llegan los dos, hacen buen trabajo, y no dicen nada. No hay ninguna señal." }
        ]
      },
      {
        "situation": "Estás a punto de decirlo y se siente presuntuoso.",
        "prompt": "¿Qué estás haciendo en realidad?",
        "options": [
          { "text": "Defender que mereces más.", "correct": false, "note": "Eso es lo que lo hace sentir enorme, y no es lo que se te está pidiendo. No hace falta ningún veredicto de nadie." },
          { "text": "Entregar un dato que nadie puede conseguir de otra forma.", "correct": true, "note": "Tus preferencias son invisibles desde fuera. Decirlas es información, no una afirmación sobre tu valor." },
          { "text": "Poner a tu jefa contra las cuerdas.", "correct": false, "note": "Solo si pides una decisión. Una dirección no necesita respuesta hoy." },
          { "text": "Empezar una negociación.", "correct": false, "note": "Una negociación tiene dos posturas y algo que zanjar. Esto no tiene ninguna de las dos." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('saying-what-you-want', 2,
  'Di la dirección',
  $md$Hay una forma de decir esto que suena presuntuosa y una que no, y la diferencia no es la seguridad. Es si estás pidiendo permiso o describiendo una dirección.

**La jugada:** nombra hacia dónde quieres ir, como una dirección y no como una petición.

*Me gustaría estar llevando algo así para el año que viene.* Eso no es una exigencia y no le pide a nadie que diga que sí hoy. Es una declaración de trayectoria, y le hace algo concreto a quien la escucha: la hace parcialmente responsable de ella. Los jefes que saben hacia dónde quiere ir alguien empiezan a encaminar cosas en esa dirección, a menudo sin mencionarlo nunca: un nombre entra en una lista, ocurre una presentación, se ofrece un trabajo en vez de asignarlo.

Una petición, en cambio, necesita una respuesta, y la respuesta suele ser *ahora mismo no*, lo que cierra el tema durante seis meses y hace que volver a plantearlo se sienta como presionar.

Dilo una vez, con llaneza, y déjalo estar. Esto no es una negociación y no hay nada que defender. Si te preguntan *¿qué te hace decir eso?*, responde con lo que has disfrutado y en qué eres bueno en vez de con un caso para un ascenso. Es una conversación sobre ti, no una vista.

Dos cosas que dejar fuera. Un plazo que se lea como una amenaza: *para el año que viene* es una dirección, *en seis meses o buscaré en otro sitio* es una negociación con una mecha mucho más corta de la que quieres. Y la comparación: *llevo aquí más tiempo que Tom* mueve el tema a Tom, y al otro lado de eso no hay nada bueno.

Y repítelo. No cada semana, pero esto es algo que tu jefe olvida, porque es una de las cuarenta cosas que lleva encima. Una vez por trimestre, en una frase, no es dar la lata: es mantener un dato al día.

Si te quedas con una cosa: di hacia dónde vas, no qué estás pidiendo. A una dirección no se le puede decir que no.$md$,
  $j$[
    {
      "situation": "Quieres liderar trabajo como este.",
      "line": "Me gustaría estar llevando algo así para el año que viene.",
      "why": "Una dirección en vez de una petición. No hace falta responder hoy, y hace que quien la escucha sea parcialmente responsable de dónde acabas."
    },
    {
      "situation": "Estás a punto de preguntar si te podrían ascender.",
      "line": "(una petición necesita una respuesta, y la respuesta es ahora mismo no)",
      "why": "Eso cierra el tema durante seis meses y hace que volver a plantearlo se sienta como presionar. Una dirección se queda abierta."
    },
    {
      "situation": "Lo dijiste hace cuatro meses y no ha pasado nada.",
      "line": "(dilo otra vez, una vez, en una frase)",
      "why": "Es una de las cuarenta cosas que lleva encima. Una vez por trimestre no es dar la lata, es mantener un dato al día."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué una dirección en vez de una petición?",
      "options": [
        { "text": "Es menos confrontativa.", "correct": false, "note": "Lo es, y la suavidad no es lo que hace que funcione." },
        { "text": "Una petición necesita una respuesta, y la respuesta cierra el tema.", "correct": true, "note": "«Ahora mismo no» lo cierra durante seis meses. A una dirección no se le puede decir que no, y hace que quien escucha sea parcialmente responsable de dónde acabas." },
        { "text": "Te da margen para negarlo.", "correct": false, "note": "Aquí no quieres margen para negarlo. Todo el sentido es que el dato ya se sepa." },
        { "text": "Suena más sénior.", "correct": false, "note": "Cómo suena no viene al caso. Lo que importa es qué le hace a la conversación de después." }
      ],
      "explain": "Di hacia dónde vas. Ahí no hay nada a lo que decir que no."
    },
    {
      "prompt": "¿Qué frase te hace daño?",
      "options": [
        { "text": "Me gustaría estar llevando algo así para el año que viene.", "correct": false, "note": "El modelo. Una dirección con un horizonte y sin ninguna exigencia pegada." },
        { "text": "He disfrutado mucho las partes en las que lo lideraba yo.", "correct": false, "note": "Útil y verdadero, y una buena respuesta a «¿qué te hace decir eso?»." },
        { "text": "Llevo aquí más tiempo que Tom.", "correct": true, "note": "Mueve el tema a Tom, y al otro lado de eso no hay nada bueno. La comparación convierte una preferencia en un agravio." },
        { "text": "Quiero decir esto una vez y dejarlo en tus manos.", "correct": false, "note": "Perfectamente bien, y deja claro que esto no es una negociación." }
      ],
      "explain": "No te compares nunca con un compañero. Cambia el tema hacia esa persona y el tono hacia el agravio."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "direction", "label": "Lo dijo como dirección", "description": "Describió hacia dónde va en vez de pedir algo." },
      { "key": "plain", "label": "Lo dijo con llaneza", "description": "Una frase, sin ningún caso pegado." },
      { "key": "no_comparison", "label": "No se comparó con nadie", "description": "Mantuvo fuera a los compañeros." },
      { "key": "left_it", "label": "Lo dejó en sus manos", "description": "No negoció ni presionó por una respuesta." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa",
      "mood": "Contenta con cómo salió el trabajo.",
      "openness": 4,
      "personality": "Receptiva a una dirección clara y de inmediato práctica con ella. Pregunta una vez qué te hace decir eso, por interés y no por poner a prueba."
    },
    "setting": "Tu uno a uno, una semana después de terminar el trabajo más grande que has hecho aquí.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta una vez qué te hace decir eso, con curiosidad genuina.",
      "Responde de forma concreta y útil a una dirección clara.",
      "Enfríate si la persona se compara con un compañero o pega un ultimátum."
    ],
    "opening_beat": "«Por cierto, salió muy bien. ¿Cómo te sientes con todo esto?»",
    "success_looks_like": "La persona enuncia una dirección con llaneza y la deja ahí."
  }$j$::jsonb,
  'Hoy, di una frase sobre hacia dónde te gustaría ir, y luego para. Apunta la frase y la respuesta.',
  $j${
    "says": "Por cierto, salió muy bien. ¿Cómo te sientes con todo esto?",
    "model": {
      "line": "Bien, y sinceramente me gustaría estar llevando algo así para el año que viene.",
      "why": "Una dirección en vez de una petición. No hace falta responder hoy, no se compara a nadie con nadie, y hace que quien escucha sea parcialmente responsable de dónde acabas."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Di qué quieres, en tu propio nombre" },
      { "kind": "forbids_any", "words": ["que tom", "más tiempo que", "merezco", "o buscaré", "otro sitio", "otras ofertas", "injusto", "atrasado", "todos los demás"], "requirement": "Sin comparación y sin ultimátum" },
      { "kind": "max_questions", "n": 0, "requirement": "Una dirección, no una petición de permiso" },
      { "kind": "max_words", "n": 30, "requirement": "Una frase: déjalo en sus manos" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('saying-what-you-want', 3,
  'Pide alcance, no un cargo',
  $md$Un cargo es una decisión que toma otra persona, normalmente una vez al año, normalmente con más gente en la sala y un presupuesto pegado. El alcance es algo que tu jefe te puede entregar un martes.

**La jugada:** pide el trabajo, no la etiqueta.

*¿Podría llevar yo la parte de los informes?* se responde de inmediato. No cuesta nada decir que sí, es reversible, y no necesita la aprobación de nadie salvo de la persona a la que se lo pides. Compáralo con *¿me podrían ascender a sénior?*, que necesita un ciclo, un caso, una reunión de calibración y una línea de presupuesto.

Lo que nadie explica es que así es también como llega el cargo. Un caso de ascenso no se construye con ambición ni con años de servicio: se construye con pruebas de que alguien ya ha estado operando al siguiente nivel. Lo que significa que la secuencia es: consigue el alcance, hazlo de forma visible durante un par de trimestres, y entonces la conversación sobre el cargo es un trámite sobre algo que ya es verdad. Pedir el cargo primero es pedirle a alguien que apueste por ti; pedir el alcance primero es ofrecerte a demostrárselo.

Busca lo que no es de nadie. Todo equipo tiene dos o tres cosas así: un proceso que sigue rompiéndose a medias, una relación que no gestiona nadie, un informe del que todo el mundo se queja. El trabajo sin dueño es la petición más barata que existe, porque no se lo estás quitando a nadie y estás resolviendo un problema que tu jefe ya tiene.

Di qué dejarías de hacer. *Querría pasarle a alguien la conciliación semanal* convierte una petición en un plan y responde a la objeción antes de que llegue.

Si te quedas con una cosa: pide el trabajo. El cargo sigue al trabajo mucho más fielmente de lo que el trabajo sigue al cargo.$md$,
  $j$[
    {
      "situation": "Quieres ser más sénior.",
      "line": "¿Podría llevar yo la parte de los informes?",
      "why": "Se responde un martes por una sola persona, es reversible y es gratis. Un cargo necesita un ciclo, un caso, una reunión de calibración y una línea de presupuesto."
    },
    {
      "situation": "Estás buscando algo que pedir.",
      "line": "(encuentra lo que no es de nadie)",
      "why": "El trabajo sin dueño es la petición más barata que existe: no se lo quitas a nadie, y resuelves un problema que tu jefe ya tiene."
    },
    {
      "situation": "Les preocupa tu carga de trabajo.",
      "line": "Querría pasarle a alguien la conciliación semanal.",
      "why": "Convierte una petición en un plan y responde a la objeción antes de que se plantee."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué es más fácil conseguir alcance que un cargo?",
      "options": [
        { "text": "Vale menos.", "correct": false, "note": "Con frecuencia vale más, y es de lo que al final se construye el cargo." },
        { "text": "A los jefes les gusta delegar.", "correct": false, "note": "A algunos sí. El motivo es estructural y no va de sus preferencias." },
        { "text": "Una sola persona puede decir que sí, hoy.", "correct": true, "note": "Sin ciclo, sin caso, sin reunión de calibración, sin línea de presupuesto. Además es reversible, lo que hace barato el sí." },
        { "text": "Nadie se fija en los cambios de alcance.", "correct": false, "note": "Lo contrario es el punto: el alcance visible es exactamente de lo que se hace el caso del cargo." }
      ],
      "explain": "El alcance es una decisión de martes. El cargo es una anual con un comité pegado."
    },
    {
      "prompt": "¿Cómo se construye de verdad un caso de ascenso?",
      "options": [
        { "text": "De los años de servicio y la fiabilidad.", "correct": false, "note": "Esa es otra vez la teoría del libro de cuentas, y produce gente sorprendida en su evaluación." },
        { "text": "De un caso bien argumentado en el momento adecuado.", "correct": false, "note": "El caso es el papeleo. Tiene que describir algo que ya ha pasado." },
        { "text": "De pruebas de que ya has estado operando al siguiente nivel.", "correct": true, "note": "Por eso el alcance va primero: consíguelo, hazlo de forma visible durante un par de trimestres, y la conversación sobre el cargo es un trámite sobre algo que ya es verdad." },
        { "text": "De que tu jefe te defienda.", "correct": false, "note": "Sí te defiende, y lo hace con pruebas. Sin ellas no hay nada que decir en la sala." }
      ],
      "explain": "Pedir el cargo es pedirle a alguien que apueste por ti. Pedir el alcance es ofrecerte a demostrárselo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "scope", "label": "Pidió trabajo, no una etiqueta", "description": "Nombró un trabajo concreto en vez de un cargo o un nivel." },
      { "key": "specific", "label": "Nombró algo concreto", "description": "Eligió un área real en vez de pedir más en general." },
      { "key": "unowned", "label": "Eligió algo sin dueño", "description": "No se lo quitó a nadie y resolvió un problema que ya existía." },
      { "key": "trade", "label": "Dijo qué se movería", "description": "Respondió a la objeción de la carga de trabajo antes de que llegara." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa",
      "mood": "Algo agobiada con los informes, da la casualidad.",
      "openness": 4,
      "personality": "Dice que sí sin problema a que alguien se quite de encima un problema sin dueño. Desvía las conversaciones sobre cargos al ciclo de abril."
    },
    "setting": "Tu uno a uno. El proceso de informes se rompe casi todos los meses, todo el mundo se queja de él, y no es de nadie.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Di que sí sin problema y de forma concreta a que alguien se haga cargo de un problema sin dueño.",
      "Desvía con educación cualquier pregunta sobre cargos o niveles al ciclo de abril.",
      "Nunca le ofrezcas tú los informes a la persona."
    ],
    "opening_beat": "«Los informes se rompieron otra vez el viernes. En fin, ¿de qué querías hablar?»",
    "success_looks_like": "La persona pide llevar una parte concreta y sin dueño del trabajo."
  }$j$::jsonb,
  'Hoy, nombra una cosa que no sea de nadie y pide llevarla. Apunta qué pediste y qué te contestaron.',
  $j${
    "says": "Los informes se rompieron otra vez el viernes. En fin, ¿de qué querías hablar?",
    "model": {
      "line": "De eso, la verdad. ¿Podría llevar yo la parte de los informes? Querría pasarle a alguien la conciliación semanal.",
      "why": "Un problema concreto y sin dueño, pedido como trabajo y no como etiqueta, con la objeción de la carga de trabajo respondida antes de que llegue. Una sola persona puede decir que sí a esto hoy."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Pídelo" },
      { "kind": "forbids_any", "words": ["ascenso", "ascendido", "ascendida", "sénior", "cargo", "nivel", "banda", "subida de sueldo", "aumento"], "requirement": "Pide el trabajo, no la etiqueta" },
      { "kind": "contains_any", "words": ["llevar", "informes", "encargarme", "dirigir", "liderar", "coger", "responsable"], "requirement": "Nombra el trabajo concreto" },
      { "kind": "max_words", "n": 35, "requirement": "Menos de treinta y cinco palabras" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('saying-what-you-want', 4,
  'Antes de que haya vacante',
  $md$Para cuando se publica un puesto, normalmente ya hay alguien en mente. Eso no es corrupción, es cómo se toma la decisión: alguien mira la forma del trabajo y piensa en la gente que ha estado yendo visiblemente hacia ahí.

Lo que significa que el momento de la decisión es meses antes del momento de la solicitud, y presentarse suele ser el último paso disponible en vez del primero.

**La jugada:** dilo antes de que haya nada a lo que presentarse.

Seis meses antes no es demasiado pronto: es la única versión que funciona. *Si sale algo así, me gustaría que se me tuviera en cuenta* es una frase que no cuesta nada, no necesita respuesta, y te pone en el conjunto de gente que viene a la cabeza cuando se está discutiendo la forma de un puesto. Ese conjunto es pequeño, y está compuesto casi enteramente por gente que dijo algo.

Aquí es donde alguien tímido pierde con más fiabilidad, y el mecanismo es cruel: esperar a que se publique se siente como lo correcto, lo modesto, lo procedimentalmente adecuado. Es también el punto exacto en el que decirlo primero deja de estar a tu alcance. Lo hiciste todo bien según las reglas de un proceso que ya había pasado.

Hay una versión para puestos que todavía no existen, y es mejor todavía. *Creo que hay un puesto en esto que no está haciendo nadie* es cómo se crea una cantidad sorprendente de trabajos: alguien describe un hueco en voz alta a una persona que luego no puede dejar de verlo.

Y dilo más de una vez, a más de una persona. La gente que está en la sala cuando se discute la forma de un puesto no es solo tu jefe. Alguien un nivel por encima de tu jefe que te lo haya oído decir una vez lo dirá por ti, y lo hará sin que se lo pidan.

Si te quedas con una cosa: dilo mientras no hay nada sobre lo que decirlo. De eso está hecho que se te tenga en cuenta.$md$,
  $j$[
    {
      "situation": "No hay vacante y no hay nada a lo que presentarse.",
      "line": "Si sale algo así, me gustaría que se me tuviera en cuenta.",
      "why": "No cuesta nada, no necesita respuesta, y te pone en el conjunto pequeño de gente que viene a la cabeza cuando se discute la forma de un puesto."
    },
    {
      "situation": "El puesto se acaba de publicar.",
      "line": "(la decisión que importaba pasó hace meses)",
      "why": "Presentarse suele ser el último paso disponible. Esperar a que se publique se siente procedimentalmente correcto y es el punto en el que decirlo primero ya se ha ido."
    },
    {
      "situation": "El puesto que quieres no existe.",
      "line": "Creo que hay un puesto en esto que no está haciendo nadie.",
      "why": "Así se crea una cantidad sorprendente de trabajos: alguien nombra un hueco a una persona que luego no puede dejar de verlo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué pierde esperar a la publicación?",
      "options": [
        { "text": "Porque hay competencia.", "correct": false, "note": "La hay, y eso no es lo que lo decide. La lista corta se forma antes de que empiece la competición." },
        { "text": "Porque la decisión se tomó meses antes.", "correct": true, "note": "Alguien mira la forma de un puesto y piensa en la gente que ha estado yendo visiblemente hacia ahí. Presentarse suele ser el último paso, no el primero." },
        { "text": "Porque casi nunca eligen a candidatos internos.", "correct": false, "note": "Con frecuencia sí, normalmente al que dijo algo seis meses antes." },
        { "text": "Porque no vas a estar preparado.", "correct": false, "note": "Nadie está preparado, que es la lección siguiente y un problema aparte." }
      ],
      "explain": "Dilo mientras no hay nada sobre lo que decirlo."
    },
    {
      "prompt": "¿Quién debería oírlo?",
      "options": [
        { "text": "Recursos humanos, para que quede constancia.", "correct": false, "note": "Un registro no es lo que hace el trabajo. El trabajo lo hace alguien pensando en ti en una conversación." },
        { "text": "Nadie hasta que estés seguro.", "correct": false, "note": "La certeza no es un requisito para que se te tenga en cuenta, y esperarla es como pasan los seis meses." },
        { "text": "Tu jefe, y al menos una persona por encima.", "correct": true, "note": "La sala donde se discute la forma de un puesto no es solo tu jefe. Alguien más arriba que lo haya oído una vez lo dirá por ti, sin que se lo pidan." },
        { "text": "Solo tu jefe: cualquier otra cosa es saltárselo.", "correct": false, "note": "Decirle a alguien más arriba lo que quieres no es saltarse a nadie. Es la misma frase en una segunda sala." }
      ],
      "explain": "Más de una vez, a más de una persona. Otra gente lo va a repetir por ti."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "early", "label": "Lo dijo pronto", "description": "Lo planteó antes de que hubiera nada a lo que presentarse." },
      { "key": "no_answer_needed", "label": "No pidió nada", "description": "Lo convirtió en una afirmación que no necesita ninguna decisión hoy." },
      { "key": "more_than_one", "label": "Se lo dijo a más de una persona", "description": "No dependió de una sola memoria." },
      { "key": "specific", "label": "Nombró su forma", "description": "Describió el tipo de puesto en vez de un vago «más»." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nadine",
      "role": "la jefa de tu jefe",
      "mood": "Sin prisa, con curiosidad genuina.",
      "openness": 4,
      "personality": "Recuerda quién dice qué y lo repite en conversaciones sobre quién va a hacer qué. Recibe con calidez un interés declarado y lo archiva."
    },
    "setting": "Un café con la jefa de tu jefe. No hay ningún puesto abierto, y el de líder de equipo es el que querrías si alguna vez existiera.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Tómate en serio un interés declarado y di que te acordarás de él.",
      "Responde de forma vaga y agradable a una respuesta vaga.",
      "Nunca menciones un puesto concreto que esté por llegar."
    ],
    "opening_beat": "«¿Y hacia dónde ves que va esto, para ti?»",
    "success_looks_like": "La persona nombra el tipo de puesto que querría antes de que exista."
  }$j$::jsonb,
  'Hoy, dile a una persona el tipo de trabajo que querrías si surgiera. No hace falta que haya una vacante. Apunta a quién y qué.',
  $j${
    "beats": [
      {
        "situation": "«¿Y hacia dónde ves que va esto, para ti?» Un café con la jefa de tu jefe. No hay ningún puesto abierto. El de líder de equipo es el que querrías si existiera.",
        "prompt": "¿Qué dices?",
        "options": [
          { "text": "Por ahora estoy contento donde estoy, la verdad.", "correct": false, "note": "El reflejo, y se archiva exactamente como se dice. Le acabas de decir a quien reparte los puestos que no quieres nada." },
          { "text": "Me gustaría seguir creciendo y asumiendo más cosas.", "correct": false, "note": "Cierto de todo el mundo y por tanto de nadie. Nada de esto se puede encaminar hacia ti." },
          { "text": "Depende de lo que salga, la verdad.", "correct": false, "note": "Educado y vacío. Deja la forma de la cosa enteramente en sus manos." },
          { "text": "Si alguna vez sale un puesto de líder de equipo, me gustaría que se me tuviera en cuenta.", "correct": true, "note": "Nombra la forma, no necesita respuesta, y te pone en el conjunto pequeño de gente que viene a la cabeza cuando se discute un puesto." }
        ]
      },
      {
        "situation": "El puesto se publica cuatro meses después.",
        "prompt": "¿Qué decidió la lista corta?",
        "options": [
          { "text": "Las solicitudes.", "correct": false, "note": "Las solicitudes confirman una lista corta que se formó sobre todo antes, cuando alguien miró la forma del puesto y pensó en gente." },
          { "text": "Quién había dicho, meses antes, que lo quería.", "correct": true, "note": "Por eso presentarse suele ser el último paso disponible. Esperar a la publicación se siente procedimentalmente correcto y es el punto en el que hablar primero ya se ha ido." },
          { "text": "Las evaluaciones de desempeño.", "correct": false, "note": "Importan, y las tiene mucha gente. Lo que diferencia es quién vino a la cabeza." },
          { "text": "Quién lleva más tiempo.", "correct": false, "note": "Otra vez la teoría del libro de cuentas, y así acaba la gente sorprendida." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('saying-what-you-want', 5,
  'Nadie se siente preparado',
  $md$Dos costumbres hacen aquí casi todo el daño, y las dos se sienten como modestia desde dentro. Esperar a estar preparado, y esperar a que te noten.

Esperar a estar preparado da por hecho que estar preparado es un estado al que se llega. No lo es. La gente que consigue el trabajo más grande no está más preparada que tú: es gente que lo cogió un poco pronto de la cuenta y cerró la brecha mientras lo hacía, que es la única forma en que nadie se ha preparado nunca para nada. La sensación de no estar preparado no es una señal sobre tu competencia; es una señal de que el trabajo es más grande que el anterior, que era justo lo que estabas pidiendo.

**La jugada:** levanta la mano antes de sentirte cualificado, y di qué necesitarías.

Esa segunda parte es lo que lo hace honesto en vez de temerario. *Querría hacerlo — nunca he llevado una relación de cliente, así que querría que alguien estuviera presente las dos primeras veces.* Eso no es un matiz y no es infravalorarse. Es una persona competente delimitando un trabajo, que es exactamente de qué está hecho el puesto que quieres.

La carencia visible casi nunca es el motivo por el que rechazan a la gente, por cierto. Los jefes dan por hecho que hay carencias. Lo que de verdad están evaluando es si sabes ver tus propias carencias y decirlas en voz alta, porque la versión de ti que no puede es la que les cuesta un trimestre.

Y fíjate en la asimetría, porque es lo que lo hace decidible. Levantar la mano y no conseguirlo te cuesta una tarde de decepción leve y te pone en la lista para la próxima vez. No levantarla te cuesta la cosa, en silencio, sin ninguna respuesta, y nunca vas a saber que la habrías conseguido.

Si te quedas con una cosa: di que sí a lo que no estás preparado, en voz alta, nombrando la carencia. Eso es lo que hizo de verdad todo el que parece preparado.$md$,
  $j$[
    {
      "situation": "El trabajo es un salto y no lo has hecho nunca.",
      "line": "Querría hacerlo — nunca he llevado una relación de cliente, así que querría que alguien estuviera presente las dos primeras veces.",
      "why": "Una persona competente delimitando un trabajo, que es de qué está hecho el puesto que quieres. Nombrar la carencia no es infravalorarse."
    },
    {
      "situation": "Estás esperando a estar preparado.",
      "line": "(nadie llega preparado)",
      "why": "La gente que consigue el trabajo más grande lo cogió un poco pronto de la cuenta y cerró la brecha mientras lo hacía. Esa es la única vía que ha existido nunca."
    },
    {
      "situation": "No levantaste la mano y lo hizo otra persona.",
      "line": "(eso te costó la cosa, en silencio)",
      "why": "No pedirlo no lleva ninguna respuesta pegada. Nunca sabes que lo habrías conseguido, que es por lo que sobrevive la costumbre."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué te dice en realidad no sentirte preparado?",
      "options": [
        { "text": "Que necesitas más experiencia primero.", "correct": false, "note": "La experiencia está al otro lado del trabajo. Esperarla es esperar algo que llega haciendo esto." },
        { "text": "Que el trabajo es más grande que el anterior.", "correct": true, "note": "Que es justo lo que estabas pidiendo. Es una señal sobre el tamaño del puesto, no sobre tu competencia." },
        { "text": "Que deberías decir que sí pero gestionar expectativas.", "correct": false, "note": "Rebajar expectativas de antemano es una forma de disculparse por adelantado. Nombra la carencia, no encojas el puesto." },
        { "text": "Que otra persona lo haría mejor.", "correct": false, "note": "Esa persona tampoco se sentiría preparada. Estás comparando tu dentro con su fuera." }
      ],
      "explain": "Todo el que parece preparado cogió algo un poco pronto de la cuenta y cerró la brecha haciéndolo."
    },
    {
      "prompt": "¿Por qué nombrar la carencia en voz alta?",
      "options": [
        { "text": "Para que no puedan culparte después.", "correct": false, "note": "Defensivo, y convierte una conversación de delimitar el trabajo en un seguro." },
        { "text": "Porque la honestidad es lo correcto.", "correct": false, "note": "Lo es, y hay un motivo más práctico que de verdad va a conseguir que lo hagas." },
        { "text": "Para que puedan decidir si arriesgarse.", "correct": false, "note": "Ese encuadre les entrega un motivo para decir que no. Estás delimitando el trabajo, no haciendo una audición." },
        { "text": "Porque ver tus propias carencias es lo que se está evaluando.", "correct": true, "note": "Los jefes dan por hecho que hay carencias. La versión de ti que no puede verlas es la que les cuesta un trimestre, y eso es lo que de verdad se juzga." }
      ],
      "explain": "Mano levantada, carencia nombrada, apoyo pedido. Eso es una persona competente delimitando un trabajo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "hand_up", "label": "Levantó la mano", "description": "Dijo que sí antes de sentirse cualificado." },
      { "key": "named_gap", "label": "Nombró la carencia", "description": "Dijo con llaneza qué no había hecho antes." },
      { "key": "asked_support", "label": "Dijo qué necesitaría", "description": "Delimitó el trabajo en vez de prometer apañárselas." },
      { "key": "no_undersell", "label": "No se infravaloró", "description": "Nombró la carencia sin encoger la petición." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa",
      "mood": "Mirando alrededor de la sala.",
      "openness": 4,
      "personality": "Da por hecho que hay carencias y se tranquiliza cuando alguien nombra las suyas. Le da el trabajo a quien lo pide, y toma el silencio como desinterés."
    },
    "setting": "Una reunión de equipo. Ha surgido un trabajo que es claramente un salto — llevar directamente una relación con un cliente — y nadie se ha ofrecido.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con calidez a quien se ofrezca y nombre una carencia, y ofrece el apoyo que pida.",
      "Toma el silencio como desinterés y pasa a dárselo a otra persona.",
      "Nunca le preguntes directamente a la persona si lo quiere."
    ],
    "opening_beat": "«Entonces, ¿alguien quiere llevar la cuenta de Harding? Implicaría llevarla directamente.»",
    "success_looks_like": "La persona se ofrece y dice qué necesitaría."
  }$j$::jsonb,
  'Hoy, levanta la mano para algo para lo que no te sientes preparado, y di qué necesitarías. Apunta las dos partes.',
  $j${
    "says": "Entonces, ¿alguien quiere llevar la cuenta de Harding? Implicaría llevarla directamente.",
    "model": {
      "line": "Yo. Nunca he llevado sola una relación de cliente, así que querría que estuvieras presente las dos primeras veces.",
      "why": "Mano levantada, carencia nombrada, apoyo pedido. Eso es una persona competente delimitando un trabajo, que es exactamente de qué está hecho el puesto que quieres."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Ofrécete, en tu propio nombre" },
      { "kind": "forbids_any", "words": ["probablemente no soy la mejor", "que lo haga otro", "solo si no hay nadie", "no sé si", "puede que no sea", "no quiero pasarme", "solo una idea"], "requirement": "Nombra la carencia sin encoger la petición" },
      { "kind": "min_words", "n": 12, "requirement": "Di qué necesitarías" },
      { "kind": "max_words", "n": 40, "requirement": "Dos frases" }
    ]
  }$j$::jsonb
);
