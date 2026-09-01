-- Spanish: Storytelling, track 1 — Por qué mueren tus historias.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Sam" (lesson 1) carries no `sex` field; masculine agreement
-- used by default. "Priya" (lessons 2-5) is the established feminine
-- exception (unambiguously female name), consistent with her prior use
-- in Dating apps and Making friends.

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

select pg_temp.es_lesson('why-stories-die', 1,
  'El material estaba bien',
  $md$Terminas. Hay una pequeña pausa. Alguien dice *ah, vale*, y la conversación sigue.

La conclusión que casi todo el mundo saca de eso es la equivocada, y es el motivo por el que la gente lo deja: *no me pasan cosas interesantes.* Es falso, es irresoluble, y lo contradice una prueba fácil — los mismos hechos, contados por otra persona, habrían funcionado.

**La jugada:** trata una historia que no funciona como un fallo estructural en vez de como una prueba sobre tu vida.

Esto importa porque los dos diagnósticos llevan a sitios completamente distintos. Si el problema es tu material, el único arreglo es una vida más interesante, que no está disponible esta semana. Si el problema es cómo la cuentas, hay unas seis cosas que cambiar y todas son decisiones.

Merece la pena ser concreto sobre qué significa de verdad *ah, vale*, porque no es mala educación y no es que a la gente no le impresione. Es la respuesta honesta a que le cuenten una serie de hechos sin ninguna razón declarada para escucharlos. El oyente ha estado esperando la cosa que hace que merezca la pena su atención, no la ha recibido, y ahora está rellenando un silencio con educación.

Dos pruebas que ya tienes. Todo el mundo conoce a alguien que puede hacer que una cola en correos sea genuinamente graciosa — los hechos no eran nada y cómo se contaba lo era todo. Y todo el mundo ha oído una historia genuinamente dramática contada tan mal que nadie reaccionó, que es el mismo hallazgo desde la otra dirección.

Así que la buena noticia es real: el techo de esto es mucho más alto de lo que la gente cree, y el techo no lo pone lo que te pasa.

Si te quedas con una cosa: tu material está bien. Algo en cómo lo cuentas está fallando, y las próximas cuatro lecciones son qué es.$md$,
  $j$[
    {
      "situation": "Terminas y consigues una pequeña pausa y un ah, vale.",
      "line": "(eso es un fallo estructural, no un veredicto sobre tu vida)",
      "why": "Los mismos hechos contados por otra persona habrían funcionado. Culpar al material lleva a un arreglo que no está disponible esta semana."
    },
    {
      "situation": "Has concluido que no te pasan cosas interesantes.",
      "line": "(alguien que conoces puede hacer que una cola en correos sea graciosa)",
      "why": "Los hechos no eran nada y cómo se contaba lo era todo, que es todo el hallazgo en un ejemplo."
    },
    {
      "situation": "Estás intentando recordar una historia mejor que contar en su lugar.",
      "line": "(esa es la búsqueda equivocada)",
      "why": "Un material mejor no arregla un problema estructural — una historia dramática contada mal consigue exactamente la misma pausa."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué significa de verdad ah, vale?",
      "options": [
        { "text": "No les impresionó.", "correct": false, "note": "Normalmente no tiene nada que ver con impresionar. Muchos hechos poco impresionantes se cuentan de maravilla y funcionan." },
        { "text": "No estaban escuchando.", "correct": false, "note": "Sí estaban escuchando — eso es lo que hace que la pausa sea tan notable para todos los que están en ella." },
        { "text": "Estaban esperando la cosa que hacía que mereciera la pena escucharlo, y no llegó.", "correct": true, "note": "No es mala educación. Es la respuesta honesta a una serie de hechos sin ninguna razón declarada, y la pausa es alguien siendo educado al respecto." },
        { "text": "La historia era demasiado larga.", "correct": false, "note": "A menudo cierto y es un síntoma de la misma causa en vez de la causa." }
      ],
      "explain": "Al oyente nunca se le dijo por qué estaba escuchando."
    },
    {
      "prompt": "¿Por qué importa culpar al material?",
      "options": [
        { "text": "Es injusto contigo mismo.", "correct": false, "note": "Lo es, y ser injusto contigo mismo no es la objeción práctica." },
        { "text": "Lleva a un arreglo que no existe.", "correct": true, "note": "Si el problema es tu vida, la respuesta es una más interesante, que no está disponible esta semana. Si es cómo la cuentas, hay seis decisiones que cambiar." },
        { "text": "Otra gente tiene el mismo material.", "correct": false, "note": "Cierto y es la prueba, no la razón por la que importa." },
        { "text": "Te hace sentir cohibido.", "correct": false, "note": "Sí lo hace, y el coste mayor es que señala un problema en el que no puedes trabajar." }
      ],
      "explain": "Una historia dramática contada mal consigue la misma pausa. Ese es el hallazgo desde la otra dirección."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "structural", "label": "Lo leyó como estructural", "description": "Trató el final plano como un problema de cómo se cuenta." },
      { "key": "no_material_hunt", "label": "No fue a buscar mejor material", "description": "Dejó de buscar una historia más impresionante." },
      { "key": "specific", "label": "Nombró qué salió mal", "description": "Identificó algo en cómo se contaba en vez de un fallo general." },
      { "key": "kept_telling", "label": "Siguió contando historias", "description": "No concluyó que debía parar." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo que estaba en la mesa",
      "mood": "Cariñoso, honesto.",
      "openness": 5,
      "personality": "Pensó que los hechos eran genuinamente buenos y puede decir exactamente dónde perdió a la gente cómo se contó. No deja que el material cargue con la culpa."
    },
    "setting": "Acabas de contar una historia en una mesa y ha conseguido una pequeña pausa y un cambio de tema. Un amigo se ha quedado contigo.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Discrepa con firmeza cada vez que la persona culpe al material.",
      "Señala hacia dónde se fue la mesa, si te preguntan, sin prescribir un arreglo.",
      "Nunca nombres tú los tres fallos."
    ],
    "opening_beat": "«Esa historia es genial de verdad, ¿sabes? Es que la has contado mal.»",
    "success_looks_like": "La persona mira a cómo la cuenta en vez de concluir que su vida es aburrida."
  }$j$::jsonb,
  'Hoy, coge una historia que nunca ha funcionado y decide que es un problema de cómo se cuenta. Apunta la historia y tu mejor suposición sobre qué falla.',
  $j${
    "beats": [
      {
        "situation": "Terminas una historia. Pequeña pausa. Alguien dice «ah, vale» y la conversación sigue.",
        "prompt": "¿Qué acaba de pasar?",
        "options": [
          { "text": "No les interesaba tanto el tema.", "correct": false, "note": "Alguien que conoces podría hacer que una cola en correos fuera graciosa. El tema no es lo que decide esto." },
          { "text": "Algo en cómo se contó salió mal.", "correct": true, "note": "Los mismos hechos en boca de otra persona habrían funcionado, que es todo el hallazgo — y señala hacia seis decisiones en vez de hacia tu vida." },
          { "text": "No te pasa gran cosa, y se notó.", "correct": false, "note": "La conclusión que saca la mayoría de la gente, y es falsa e irresoluble a la vez — que es por lo que la gente deja de contar historias del todo." },
          { "text": "La contaste demasiado larga.", "correct": false, "note": "A menudo cierto y es un síntoma de una causa, no el diagnóstico." }
        ]
      },
      {
        "situation": "Quieres que la próxima vez vaya mejor.",
        "prompt": "¿En qué trabajas?",
        "options": [
          { "text": "Encontrar mejores historias que contar.", "correct": false, "note": "Un arreglo que requiere una vida más interesante, que no está disponible esta semana. Mientras tanto, la historia que tienes está bien." },
          { "text": "Ser más gracioso.", "correct": false, "note": "No está disponible por encargo, y no es lo que separa una historia que funciona de una que no." },
          { "text": "Confianza — contarla como si te la creyeras.", "correct": false, "note": "Ayuda en los márgenes, y una historia contada con confianza pero sin nada en juego sigue consiguiendo la pausa." },
          { "text": "Estructura — la razón, el principio, y lo que está en juego.", "correct": true, "note": "Tres fallos concretos, todos ellos decisiones que puedes tomar de otra forma antes de abrir la boca." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('why-stories-die', 2,
  'Sin razón para contarla',
  $md$Sabes por qué merece la pena decir esto. El oyente no lo sabe, y no lo va a averiguar sobre la marcha.

Ese hueco es el primero de los tres fallos y probablemente el más grande. Estás contando una historia porque algo de ella te llamó la atención — era absurda, o salió mal de una forma particular, o dice algo sobre alguien que conocéis los dos. Todo eso está en tu cabeza. Lo que llega a la mesa es una secuencia de hechos a la que le falta la razón.

**La jugada:** di por qué la estás contando, en la primera frase.

*Me ha pasado la cosa más ridícula en el taller.* *He descubierto algo extraordinario sobre Michael.* *Casi no vengo esta noche, y aquí está el porqué.* Cada una de esas está haciendo un trabajo: decirle a alguien qué tipo de cosa viene y por qué merece la pena treinta segundos de su atención.

Suena como si fuera a estropear el final. Hace justo lo contrario — es la diferencia entre alguien siguiendo una historia y alguien esperando a que termine. Lo que estropea un final es contar el final, y ninguna de esas frases lo hace.

Hay una versión de este fallo que merece la pena atrapar por separado, porque es común en grupo: contar una historia porque hay un hueco en la conversación en vez de porque tienes una razón. Si no puedes decir en una línea por qué merece la pena escucharla, eso es información útil antes de empezar en vez de después — y está perfectamente bien no contarla.

La razón también da forma a todo lo demás. Una historia contada porque era absurda necesita un detalle distinto de la misma historia contada porque alguien se comportó mal, y saber cuál de las dos estás haciendo es lo que te dice qué cortar.

Si te quedas con una cosa: la primera frase dice por qué están escuchando. Nadie puede suplir eso por sí mismo.$md$,
  $j$[
    {
      "situation": "Estás a punto de lanzarte a contar lo que pasó en el taller.",
      "line": "Me ha pasado la cosa más ridícula en el taller.",
      "why": "Una frase que dice qué tipo de cosa viene y por qué merece la pena treinta segundos. No puede suplirla el oyente."
    },
    {
      "situation": "Te preocupa que el marco estropee el final.",
      "line": "(el final sería lo que estropea el final)",
      "why": "Un marco dice qué tipo de historia es esta, no qué pasa. Es la diferencia entre seguir una y esperar a que termine."
    },
    {
      "situation": "Hay un hueco en la conversación y recurres a una historia.",
      "line": "(¿puedes decir en una línea por qué merece la pena escucharla?)",
      "why": "Si no puedes, merece la pena saberlo antes de empezar en vez de después, y no contarla está perfectamente bien."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué no puede el oyente averiguar la razón por sí mismo?",
      "options": [
        { "text": "No están prestando suficiente atención.", "correct": false, "note": "Sí están prestando atención. Lo que les falta es la cosa que solo existe en tu cabeza." },
        { "text": "La razón está en tu cabeza y en ningún otro sitio.", "correct": true, "note": "La estás contando porque algo te llamó la atención. Lo que llega a la mesa es una secuencia de hechos a la que le falta esa parte." },
        { "text": "Las historias son ambiguas por naturaleza.", "correct": false, "note": "Grandioso, y no es cierto de una historia con un marco delante." },
        { "text": "No conocen a la gente implicada.", "correct": false, "note": "A veces es un factor, y el mismo fallo pasa con historias sobre gente que todos conocen." }
      ],
      "explain": "La primera frase dice por qué están escuchando."
    },
    {
      "prompt": "¿Estropea el final ponerle un marco?",
      "options": [
        { "text": "Sí, un poco — es un trueque que merece la pena hacer.", "correct": false, "note": "No hay trueque. Un marco dice qué tipo de historia es esta, no qué pasa en ella." },
        { "text": "No — es la diferencia entre seguir y esperar.", "correct": true, "note": "Lo que estropea un final es contar el final. Me ha pasado la cosa más ridícula en el taller no revela nada en absoluto." },
        { "text": "Solo si dices demasiado.", "correct": false, "note": "Casi correcto, y hace que suene delicado. Una línea es muy difícil de pasarse haciéndola." },
        { "text": "Sí, que es por lo que construyes hacia ello en su lugar.", "correct": false, "note": "Construir hacia ello es exactamente lo que produce el problema del planteamiento de la siguiente lección." }
      ],
      "explain": "Y si no puedes decir la línea, eso es útil antes de empezar."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "framed", "label": "Dijo por qué merecía la pena escucharla", "description": "Dio la razón en la primera frase." },
      { "key": "no_spoiler", "label": "No reveló el final", "description": "Enmarcó el tipo de historia en vez de su contenido." },
      { "key": "knew_the_reason", "label": "Sabía la razón él mismo", "description": "Podía decir en una línea qué hacía que mereciera la pena contarla." },
      { "key": "declined", "label": "No contó una sin razón", "description": "Estuvo dispuesto a no contarla." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa",
      "mood": "Relajada, interesada.",
      "openness": 4,
      "personality": "Sigue con atención una historia enmarcada y se distrae visiblemente en una sin enmarcar, rellenando la pausa con educación al final."
    },
    "setting": "Una mesa de cuatro. Alguien acaba de preguntar cómo ha ido tu semana, y tienes una historia genuinamente absurda sobre un taller.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Sigue con atención y reacciona cuando una historia se enmarca al principio.",
      "Distráete y responde con un educado ah, vale si una historia llega sin marco.",
      "Nunca preguntes cuál es el punto."
    ],
    "opening_beat": "«Por cierto, ¿qué tal tu semana?»",
    "success_looks_like": "La persona abre con una línea diciendo por qué merece la pena escuchar la historia."
  }$j$::jsonb,
  'Hoy, empieza una historia con una línea que diga por qué merece la pena escucharla. Apunta la línea.',
  $j${
    "says": "Por cierto, ¿qué tal tu semana?",
    "model": {
      "line": "Me ha pasado la cosa más ridícula en el taller el jueves.",
      "why": "Una línea que dice qué tipo de cosa viene y por qué merece la pena treinta segundos. No revela nada — lo que estropea un final es contar el final."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["no es muy interesante", "tenías que haber estado", "perdona", "esto puede llevar", "aburrido", "ten paciencia", "te importa si", "no sé si"], "requirement": "Nada de descargo ni de petición de permiso" },
      { "kind": "max_sentences", "n": 1, "requirement": "Una línea, y luego la historia" },
      { "kind": "max_words", "n": 20, "requirement": "Un marco, no un resumen" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('why-stories-die', 3,
  'Demasiado planteamiento',
  $md$Esta es la forma más común en que muere una buena historia, y pasa antes de que haya pasado nada.

*Bueno, era martes — no, miércoles, porque tenía la cosa esa — e iba conduciendo hacia casa de mi hermana, se acaba de mudar, y el tráfico en la circunvalación estaba...*

Todavía no ha pasado nada. La mesa lleva treinta segundos y todavía se está orientando, y es en este punto en vez de al final donde la gente deja de seguir en silencio.

**La jugada:** empieza en el momento en que las cosas empiezan a salir mal, y pon cualquier cosa genuinamente necesaria en cuatro palabras al pasar.

Vas a sentir que no se puede entender sin el planteamiento. Casi siempre se puede. Casi todos los hechos que la gente establece de antemano se pueden meter en pleno vuelo — *casa de mi hermana, donde me estaba quedando* — costando cuatro palabras en vez de cuarenta, y llegando en el momento en que de verdad hace falta en vez de un minuto antes.

Merece la pena entender por qué el planteamiento se siente necesario, porque explica por qué la gente inteligente lo sigue haciendo. En tu memoria, los hechos llegaron en orden y el contexto llegó primero, así que estás recontando la secuencia tal como la viviste. Pero el oyente no necesita tu experiencia del día. Necesita la historia, y una historia empieza más tarde que un día.

Una prueba útil antes de hablar: ¿cuál es el primer momento que le resultaría interesante a alguien? Empieza una frase antes de eso.

El hábito relacionado es corregirte a ti mismo. *No, espera, era jueves* cuesta una pausa, rompe el ritmo, y no compra nada — nadie está comprobando, y si el día importara no estarías inseguro al respecto. Di martes, equivócate, y sigue.

Si te quedas con una cosa: empieza tarde. Corta el trayecto hasta allí, el día de la semana, y quién lo propuso — y si resulta que necesitabas algo, cuatro palabras en medio bastarán.$md$,
  $j$[
    {
      "situation": "Estás a punto de explicar adónde ibas y por qué.",
      "line": "(empieza en el momento en que sale mal)",
      "why": "La mesa se orienta durante treinta segundos y todavía no ha pasado nada. Ahí es donde la gente deja de seguir en silencio."
    },
    {
      "situation": "De verdad no va a tener sentido sin saber de quién era la casa.",
      "line": "Casa de mi hermana, donde me estaba quedando.",
      "why": "Cuatro palabras al pasar, llegando cuando hace falta en vez de un minuto antes. Casi todo el planteamiento se puede hacer así."
    },
    {
      "situation": "No estás seguro de si era martes o miércoles.",
      "line": "(di martes y sigue)",
      "why": "Nadie está comprobando, y si importara lo sabrías. Corregirte a ti mismo cuesta una pausa y no compra nada."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué la gente inteligente sigue haciendo el planteamiento largo?",
      "options": [
        { "text": "Quieren ser exactos.", "correct": false, "note": "En parte, y la exactitud es un síntoma del hábito más profundo, no su causa." },
        { "text": "Están nerviosos y llenando el tiempo.", "correct": false, "note": "A veces, y esto pasa igual de a menudo con gente que está completamente relajada." },
        { "text": "Están recontando el día en el orden en que lo vivieron.", "correct": true, "note": "El contexto llegó primero en la memoria, así que llega primero en el relato. Pero el oyente no necesita tu experiencia del día — una historia empieza más tarde que un día." },
        { "text": "Creen que la audiencia lo necesita.", "correct": false, "note": "Sí lo creen, y es la creencia que corrige esta lección, no la razón por la que se forma." }
      ],
      "explain": "¿Cuál es el primer momento que le resultaría interesante a alguien? Empieza una frase antes de eso."
    },
    {
      "prompt": "Necesitas de verdad un dato de contexto. ¿Qué haces con él?",
      "options": [
        { "text": "Establécelo al principio, brevemente.", "correct": false, "note": "Brevemente al principio sigue siendo el principio, y es por donde se cuela otra vez el planteamiento." },
        { "text": "Déjalo fuera y deja que pregunten.", "correct": false, "note": "No van a preguntar en mitad de la historia, y un oyente confundido en silencio es un oyente que ha parado." },
        { "text": "Mételo en pleno vuelo en cuatro palabras.", "correct": true, "note": "Casa de mi hermana, donde me estaba quedando. Cuesta cuatro palabras en vez de cuarenta y llega en el momento en que hace falta." },
        { "text": "Reformula la historia para que no haga falta.", "correct": false, "note": "Elaborado, e innecesario — la versión de cuatro palabras lo resuelve." }
      ],
      "explain": "Empieza tarde. Corta el trayecto, el día, y quién lo propuso."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "started_late", "label": "Empezó tarde", "description": "Abrió cerca del momento en que las cosas salieron mal." },
      { "key": "no_setup", "label": "Cortó el planteamiento", "description": "Nada de día, de trayecto, de quién lo propuso." },
      { "key": "mid_flight", "label": "Metió el contexto en pleno vuelo", "description": "Cuatro palabras donde hacía falta." },
      { "key": "no_correcting", "label": "No se corrigió a sí mismo", "description": "Dejó pasar una pequeña inexactitud." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa",
      "mood": "Interesada al principio.",
      "openness": 4,
      "personality": "Visiblemente presente para una historia que empieza tarde y visiblemente distraída durante la orientación. Nunca interrumpe."
    },
    "setting": "Estás contando la historia del taller. De verdad empieza cuando el mecánico dice algo extraordinario, unos cuatro minutos después de una visita que empezó con aparcar.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Reacciona e inclínate hacia delante cuando una historia empieza con algo pasando.",
      "Distráete, mira a otro lado y quédate callada durante cualquier planteamiento más largo que una frase.",
      "Nunca pidas contexto."
    ],
    "opening_beat": "«Venga, cuenta — ¿qué pasó en el taller?»",
    "success_looks_like": "La persona empieza en el momento en que las cosas salen mal en vez de al principio del día."
  }$j$::jsonb,
  'Hoy, cuenta una historia empezando en el momento en que sale mal. Apunta qué cortaste del principio.',
  $j${
    "says": "Venga, cuenta — ¿qué pasó en el taller? (De verdad empieza cuando el mecánico dice algo extraordinario, unos cuatro minutos después de una visita que empezó con aparcar.)",
    "model": {
      "line": "Bueno, sale el mecánico, mira el coche unos cuatro segundos, y dice: ¿de quién es esto?",
      "why": "Empieza en el momento en que pasa algo. Aparcar, el trayecto y el día de la semana están todos cortados, y cualquier cosa genuinamente necesaria se puede meter más tarde en cuatro palabras."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["era martes", "era miércoles", "bueno, básicamente", "iba conduciendo", "tenía que ir", "antecedentes", "antes de nada", "no espera", "o era"], "requirement": "Corta el planteamiento — sin día, sin trayecto, sin orientación" },
      { "kind": "max_words", "n": 40, "requirement": "Empieza tarde — a una frase de empezar ya ha pasado algo" },
      { "kind": "max_sentences", "n": 2, "requirement": "Dos frases como mucho antes de que pase algo" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('why-stories-die', 4,
  'Nada en juego',
  $md$Algunas historias están bien enmarcadas, empiezan tarde, y aun así no producen nada. Normalmente el tercer fallo: nunca hubo nada en riesgo en ellas.

Lo que hay en juego es lo que hace que alguien siga escuchando en vez de esperar con educación. No significa drama — lo que hay en juego en la mayoría de las buenas historias de conversación es minúsculo. Si vas a conseguir el paquete. Si el hombre se da cuenta. Si vas a tener que decir algo. El tamaño no importa; que exista sí.

**La jugada:** deja claro, pronto, qué podría salir mal.

A menudo lo que está en juego ya está en los hechos y sencillamente no se ha dicho en voz alta. Sabías, en su momento, que esto podía salir mal — y como lo sabías, no se te ha ocurrido mencionarlo. Meterlo en una cláusula suele ser el arreglo entero: *y ahora estoy bastante seguro de que me he equivocado de casa.*

Una historia sin nada en juego es lo que la gente llama *algo que pasó*, y merece la pena poder reconocer una antes de empezar a contarla. Si nada podría haber ido de otra forma, y nada era incierto para nadie en ella, no hay nada que seguir — y la pausa educada al final no es un fallo de cómo se contó, es una respuesta exacta.

Dos formas de encontrar lo que hay en juego en algo que parece no tener nada. Pregúntate qué esperabas que pasara, que suministra un deseo y por tanto algo que se le puede negar. O pregúntate qué te daba miedo, que suele ser más vívido y es la versión que la mayoría de la gente infrautiliza.

Y lo que está en juego tiene que estar presente, no resumido. *Fue bastante estresante* afirma lo que está en juego. *Tenía unos cuatro minutos y la puerta estaba cerrada* lo crea, y la diferencia es todo el asunto.

Si te quedas con una cosa: di qué podría salir mal, pronto. Sin eso tienes una secuencia, y nadie se ha inclinado hacia delante nunca por una secuencia.$md$,
  $j$[
    {
      "situation": "La historia está bien enmarcada y aun así no funciona.",
      "line": "(nunca hubo nada en riesgo en ella)",
      "why": "Lo que hay en juego es lo que hace que alguien siga escuchando en vez de esperar con educación. El tamaño no importa — que exista sí."
    },
    {
      "situation": "Sabías en su momento que podía salir mal.",
      "line": "Y ahora estoy bastante seguro de que me he equivocado de casa.",
      "why": "Lo que estaba en juego ya estaba en los hechos y nunca se dijo en voz alta, que suele ser el arreglo entero en una cláusula."
    },
    {
      "situation": "Estás a punto de decir que fue bastante estresante.",
      "line": "Tenía unos cuatro minutos y la puerta estaba cerrada.",
      "why": "La primera afirma lo que está en juego y la segunda lo crea, y esa diferencia es todo el mecanismo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cómo de grande tiene que ser lo que está en juego?",
      "options": [
        { "text": "Lo bastante grande como para que el resultado importara.", "correct": false, "note": "Suena bien y descarta la mayoría de las buenas historias de conversación, donde no había gran cosa en juego en absoluto." },
        { "text": "Minúsculo está bien — lo que cuenta es que exista.", "correct": true, "note": "Si vas a conseguir el paquete. Si el hombre se da cuenta. El tamaño no importa; si algo era incierto sí." },
        { "text": "Proporcional a lo larga que es la historia.", "correct": false, "note": "Una regla limpia sin nada detrás. Una historia de treinta segundos necesita algo en juego tanto como una de dos minutos." },
        { "text": "Lo bastante grande como para merecer el tiempo de la mesa.", "correct": false, "note": "Esta es la creencia que hace que la gente crea que no tiene historias. La atención la retiene la incertidumbre, no la importancia." }
      ],
      "explain": "Di qué podría salir mal, pronto. Sin eso tienes una secuencia."
    },
    {
      "prompt": "¿Cómo encuentras lo que está en juego en algo que parece no tener nada?",
      "options": [
        { "text": "Exagera un poco.", "correct": false, "note": "Funciona una vez y es el hábito que con el tiempo hace que la gente desconfíe de tus historias." },
        { "text": "Pregúntate qué te daba miedo.", "correct": true, "note": "Normalmente más vívido que lo que esperabas, y la versión que la mayoría de la gente infrautiliza. Las dos suministran algo que se puede negar." },
        { "text": "Añade un giro al final.", "correct": false, "note": "Lo que está en juego se establece pronto y un giro llega tarde. No puede adaptar retroactivamente la atención al medio." },
        { "text": "Explica por qué te importaba.", "correct": false, "note": "Eso afirma importancia en vez de crear incertidumbre, y es la versión resumida de la que avisa esta lección." }
      ],
      "explain": "Fue bastante estresante afirma lo que está en juego. La puerta estaba cerrada lo crea."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "stakes", "label": "Estableció lo que estaba en juego", "description": "Dejó claro qué podría salir mal." },
      { "key": "early", "label": "Lo hizo pronto", "description": "Antes de la mitad en vez de al final." },
      { "key": "created", "label": "Lo creó en vez de afirmarlo", "description": "Mostró el riesgo en vez de describirlo como estresante." },
      { "key": "small_ok", "label": "Dejó que fuera pequeño", "description": "No lo infló para justificar contarlo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa",
      "mood": "Dispuesta.",
      "openness": 4,
      "personality": "Se inclina hacia delante en el momento en que algo es incierto y se distrae con cualquier cosa sin riesgo en ella, por muy bien contada que esté."
    },
    "setting": "Estás contando una historia sobre recoger un paquete. No pasa nada dramático, y en su momento estabas genuinamente preocupado por perderlo.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Inclínate hacia delante y pregunta qué pasó después cuando algo es incierto.",
      "Distráete con educación durante cualquier relato sin nada en riesgo en él.",
      "Nunca preguntes qué había en juego."
    ],
    "opening_beat": "«¿Dijiste que pasó algo con el paquete?»",
    "success_looks_like": "La persona establece pronto qué podría haber salido mal."
  }$j$::jsonb,
  'Hoy, coge una historia que no funciona y encuentra qué te daba miedo en su momento. Apunta la frase que lo mete.',
  $j${
    "beats": [
      {
        "situation": "Una historia sobre recoger un paquete. Bien enmarcada, empieza tarde, y aun así no funciona.",
        "prompt": "¿Qué falta?",
        "options": [
          { "text": "Un remate.", "correct": false, "note": "Un final necesita algo que terminar. Sin incertidumbre en el medio no hay nada que un remate pueda resolver." },
          { "text": "Algo en riesgo.", "correct": true, "note": "Lo que hay en juego es lo que hace que alguien siga escuchando en vez de esperar con educación — y puede ser minúsculo. Si vas a conseguir el paquete es suficiente." },
          { "text": "Mejor detalle.", "correct": false, "note": "El detalle hace vívida una historia y no puede hacerla trepidante. Vívido sin nada en juego es una secuencia bien descrita." },
          { "text": "Sencillamente no es una historia.", "correct": false, "note": "Puede llegar a serlo. La mayoría de las historias planas tienen algo en juego en los hechos que nunca se dijo en voz alta." }
        ]
      },
      {
        "situation": "Sabías en su momento que podías perder la recogida. No lo has mencionado.",
        "prompt": "¿Cómo lo metes?",
        "options": [
          { "text": "La verdad es que fue bastante estresante.", "correct": false, "note": "Eso afirma lo que está en juego en vez de crearlo, y afirmarlo es lo que hace la gente cuando no encuentra la versión concreta." },
          { "text": "Explica al final por qué importaba.", "correct": false, "note": "Lo que está en juego funciona estableciéndose pronto. Explicado al final es una nota a pie de página de una historia que nadie siguió." },
          { "text": "Cerraban a las doce y eran las once y veinte.", "correct": true, "note": "Concreto, pronto, y crea la incertidumbre en vez de describirla. Normalmente una cláusula es el arreglo entero." },
          { "text": "Ve construyendo hacia ello, para que el riesgo quede claro sobre la marcha.", "correct": false, "note": "Para cuando queda claro, la parte que necesitaba la atención ya se ha escuchado sin ninguna." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('why-stories-die', 5,
  'No la rebajes antes de empezar',
  $md$*Esto no es muy interesante, pero.* *Perdona, esto va a llevar un rato.* *Probablemente tenías que haber estado allí.*

Cada una se dice para rebajar las expectativas, y cada una está cerca de ser fatal — por un motivo más mecánico de lo que parece.

**La jugada:** corta el descargo por completo y empieza la historia.

Lo que hace un descargo es decirle a la gente cómo escuchar. Dado *esto no es muy interesante*, la mesa se ajusta: la atención baja, la historia se escucha como una menor, y el final se recibe exactamente como se anunció. Has suministrado el veredicto de antemano, y la gente rara vez revoca un veredicto que el narrador ya ha dictado.

También produce el resultado concreto que intentaba evitar. El descargo existe para protegerte del final plano — si nadie se ríe, dijiste que no era muy gracioso. Pero es lo que causa el final plano, así que el seguro se paga a sí mismo organizando el accidente.

*Tenías que haber estado allí* es la peor de todas, porque dice que la historia no funciona antes de que hayas intentado hacer que funcione, y te da una excusa que te impide aprender qué salió mal.

Por debajo, las tres son la misma jugada: una petición de permiso. La gente callada lo pide antes de coger algo de la atención de una sala, y la petición es invisible para ellos y audible para todos los demás. Nadie necesita conceder permiso para noventa segundos de una historia. Empezar es el permiso.

El reemplazo no es confianza y no es una afirmación sobre lo buena que va a ser. Es sencillamente la primera línea de la historia en vez de una línea sobre la historia — el marco de la lección dos, dicho con sencillez, y luego los hechos.

Si te quedas con una cosa: a nadie hay que avisarlo. Empiézala, cuéntala, y deja que el final sea lo que sea.$md$,
  $j$[
    {
      "situation": "Estás a punto de decir esto no es muy interesante, pero.",
      "line": "(córtalo — empieza la historia)",
      "why": "Has suministrado el veredicto de antemano, y la gente rara vez revoca un veredicto que el narrador ya ha dictado."
    },
    {
      "situation": "Quieres un seguro por si nadie se ríe.",
      "line": "(el seguro organiza el accidente)",
      "why": "El descargo existe para protegerte del final plano y es lo que lo causa."
    },
    {
      "situation": "Te tienta decir que tenías que haber estado allí.",
      "line": "(eso te impide aprender qué salió mal)",
      "why": "Declara que la historia no funciona antes de que hayas intentado hacer que funcione, y te da una excusa permanente."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hace de verdad un descargo?",
      "options": [
        { "text": "Te hace parecer modesto.", "correct": false, "note": "Se lee como modestia, y lo que hace es más mecánico que una impresión." },
        { "text": "Le dice a la gente cómo escuchar.", "correct": true, "note": "La atención baja, la historia se escucha como una menor, y el final se recibe exactamente como se anunció. Suministraste el veredicto de antemano." },
        { "text": "Te compra tiempo para recordarla.", "correct": false, "note": "Dos segundos, a un coste que dura toda la historia." },
        { "text": "Baja lo que está en juego para que no pueda fallar.", "correct": false, "note": "Tampoco puede tener éxito, que es el trueque que nadie haría de forma deliberada." }
      ],
      "explain": "La gente rara vez revoca un veredicto que el narrador ya ha dictado."
    },
    {
      "prompt": "¿Qué son las tres cosas por debajo del descargo?",
      "options": [
        { "text": "Baja autoestima.", "correct": false, "note": "Una etiqueta grande que no te dice qué hacer distinto en los próximos cuatro segundos." },
        { "text": "Un hábito adquirido por que le interrumpieran a uno.", "correct": false, "note": "Plausible como historia de origen y no lo que está haciendo la frase en el momento." },
        { "text": "Una petición de permiso.", "correct": true, "note": "Pedir antes de coger algo de la atención de una sala — invisible para quien lo hace y audible para todos los demás. Empezar es el permiso." },
        { "text": "Educación.", "correct": false, "note": "Se pretende como educación, y le cuesta a la mesa la historia que estaba a punto de conseguir." }
      ],
      "explain": "A nadie hay que avisarlo. Empiézala, cuéntala, y deja que el final sea lo que sea."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_disclaimer", "label": "Sin descargo", "description": "Empezó sin avisar a nadie." },
      { "key": "no_permission", "label": "No pidió permiso", "description": "Cogió los noventa segundos en vez de pedirlos." },
      { "key": "no_excuse", "label": "Sin tenías que haber estado allí", "description": "No declaró de antemano que no funcionaba." },
      { "key": "started", "label": "Empezó con la historia", "description": "La primera línea fue la historia en vez de sobre ella." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa",
      "mood": "Tranquila.",
      "openness": 4,
      "personality": "Se calibra por completo a cómo se presenta una historia — atenta a una que empieza, educadamente a medias con una por la que se pide disculpas."
    },
    "setting": "Una pausa en la mesa, y tienes una historia de la que no estás seguro.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Escucha de verdad y reacciona a una historia que sencillamente empieza.",
      "Escucha a medias y responde con suavidad a cualquier cosa precedida por un descargo.",
      "Nunca animes a la persona a contar una historia."
    ],
    "opening_beat": "(un silencio — nadie está hablando)",
    "success_looks_like": "La persona empieza la historia sin ningún descargo."
  }$j$::jsonb,
  'Hoy, cuenta una historia sin ningún descargo delante. Apunta el descargo que no dijiste.',
  $j${
    "says": "(un silencio en la mesa — nadie está hablando, y tienes una historia de la que no estás seguro)",
    "model": {
      "line": "He descubierto algo extraordinario sobre mi vecino de arriba esta semana.",
      "why": "La primera línea es la historia en vez de una línea sobre la historia. Sin descargo, sin permiso pedido, y a la mesa se le ha dicho cómo escuchar por el contenido en vez de por un aviso."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["no es muy interesante", "tenías que haber estado allí", "perdona", "esto puede llevar un rato", "aburrido", "no sé si", "te importa", "una rapidita", "sin venir a cuento pero", "probablemente no tenga gracia"], "requirement": "Nada de descargo, de disculpa, de permiso" },
      { "kind": "min_words", "n": 6, "requirement": "Empiézala de verdad" },
      { "kind": "max_words", "n": 25, "requirement": "Una línea, y luego los hechos" }
    ]
  }$j$::jsonb
);
