-- Spanish: Hacer amigos, track 1 — Por qué se volvió difícil.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Sam" carries no `sex` field; masculine agreement used by
-- default, as established in Running the app and First date.

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

select pg_temp.es_lesson('why-it-got-hard', 1,
  'Fue el edificio, no tú',
  $md$Antes era fácil. Ahora no lo es. Nada en ti ha cambiado de forma evidente, y la conclusión a la que llega casi todo el mundo a partir de eso es la equivocada.

Esto es lo que cambió de verdad. En el colegio y en la universidad te colocaron, sin que lo decidieras, en un edificio lleno de la misma gente, todos los días, durante años, con largos tramos de tiempo sin estructura y nada en juego. Nadie de ese edificio se le daba bien hacer amigos. Era el edificio el que lo hacía.

**La jugada:** deja de leer la dificultad como un hecho sobre ti, y empieza a leerla como un hecho sobre tu semana.

La vida adulta quita ese ingrediente y lo quita rápido. Ves a tus compañeros de trabajo constantemente, siempre con un propósito y normalmente con una tarea de por medio. Ves a tus amigos de siempre de vez en cuando, siempre quedando, y cada vez menos. Lo que ha desaparecido es el medio: tiempo no planeado, con las mismas caras, repetidamente, sin ningún motivo.

Eso es un problema de suministro, y explica algo que si no no tendría sentido — que gente que objetivamente es buena compañía, graciosa, amable y bien vista en el trabajo, acabe sin nadie a quien llamar un domingo. Que se te dé bien la gente nunca fue lo que producía amistades. La cercanía sí.

Merece la pena quedarse con la versión de esto que no favorece la historia que puede que te estés contando: probablemente no has empeorado. Estás usando la misma habilidad social en un entorno que dejó de suministrar el único ingrediente del que dependía, y el resultado cayó en consecuencia.

Y el motivo por el que esto importa de forma práctica y no solo como consuelo: si el problema fueras tú, el arreglo sería convertirte en una persona distinta, que es lento y casi nunca funciona. Si el problema es la semana, el arreglo es cambiar la semana, que es un acto mucho más pequeño y disponible.

Si te quedas con una cosa: no tienes un problema de amistad, tienes un problema de infraestructura.$md$,
  $j$[
    {
      "situation": "Has concluido que has empeorado en esto desde la universidad.",
      "line": "(era el edificio el que lo hacía)",
      "why": "A nadie de ese edificio se le daba bien hacer amigos. Suministraba la misma gente, a diario, durante años, sin nada en juego — y dejó de hacerlo."
    },
    {
      "situation": "Eres bien visto en el trabajo y no tienes a nadie a quien llamar un domingo.",
      "line": "(eso es un problema de suministro, no de simpatía)",
      "why": "Ser buena compañía nunca fue lo que producía amistades. La cercanía sí, y los compañeros de trabajo son cercanía con una tarea de por medio."
    },
    {
      "situation": "Estás intentando volverte más extrovertido.",
      "line": "(cambia la semana en su lugar)",
      "why": "Si el problema fueras tú, el arreglo sería convertirte en una persona distinta, que es lento y casi nunca funciona. Cambiar tu semana está disponible este mes."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué cambió de verdad después de la universidad?",
      "options": [
        { "text": "Te ocupaste más y tuviste menos tiempo.", "correct": false, "note": "El tiempo es parte de esto y no el mecanismo. Mucha gente muy ocupada en la universidad hacía amigos constantemente." },
        { "text": "La gente se volvió menos abierta a nuevos amigos.", "correct": false, "note": "Mayormente falso, y es la historia que hace que el problema parezca cerrado. A la mayoría de los adultos les gustaría tener otro buen amigo." },
        { "text": "El contacto repetido sin planear se detuvo.", "correct": true, "note": "La misma gente, todos los días, durante años, sin nada en juego. A nadie de ese edificio se le daba bien hacer amigos — era el edificio el que lo hacía." },
        { "text": "Dejaste de esforzarte.", "correct": false, "note": "Normalmente es justo lo contrario: la gente se esfuerza mucho más ahora y consigue mucho menos, que es exactamente lo que les hace concluir que la culpa es suya." }
      ],
      "explain": "Era infraestructura, y se quitó sin que nadie lo anunciara."
    },
    {
      "prompt": "¿Por qué importa de forma práctica el replanteamiento?",
      "options": [
        { "text": "Porque es más amable contigo mismo.", "correct": false, "note": "Lo es, y el consuelo no es por lo que está en el tema." },
        { "text": "Porque cambia cuál es el arreglo.", "correct": true, "note": "Si el problema eres tú, el arreglo es convertirte en una persona distinta — lento y casi siempre ineficaz. Si es tu semana, el arreglo es cambiar tu semana, que está disponible este mes." },
        { "text": "Porque significa que no pasa nada malo.", "correct": false, "note": "Sí pasa algo malo: no tienes infraestructura. Simplemente no es un defecto." },
        { "text": "Porque la confianza sigue a la comprensión.", "correct": false, "note": "A veces, y esto no es una intervención sobre la confianza. Es un diagnóstico que apunta a una acción distinta." }
      ],
      "explain": "Un diagnóstico distinto produce una tarea distinta y mucho más pequeña."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "reframed", "label": "Lo leyó como infraestructura", "description": "Dejó de tratar la dificultad como un defecto personal." },
      { "key": "specific", "label": "Nombró qué falta", "description": "Identificó el ingrediente ausente en vez de una carencia vaga." },
      { "key": "no_self_improvement", "label": "No recurrió a convertirse en otro", "description": "Apuntó a la semana en vez de a la personalidad." },
      { "key": "honest", "label": "Fue honesto sobre el hueco", "description": "Reconoció el estado real de las cosas sin suavizarlo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un viejo amigo con quien estás hablando",
      "mood": "Cálido, sin prisa.",
      "openness": 5,
      "personality": "Amable e interesado en el mecanismo real. Cuestiona con suavidad la autoculpabilización y pregunta de qué está hecha tu semana."
    },
    "setting": "Un amigo al que ves un par de veces al año te ha preguntado qué tal van las cosas, y has admitido que en realidad no ves a nadie.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué contiene su semana de verdad cada vez que la respuesta sea sobre su personalidad.",
      "Está de acuerdo con rapidez y calidez con cualquier cosa sobre las circunstancias o la infraestructura.",
      "Nunca digas tú el replanteamiento."
    ],
    "opening_beat": "«Creo que sencillamente he empeorado con la gente, la verdad.»",
    "success_looks_like": "La persona nombra el ingrediente ausente en vez de un defecto en sí misma."
  }$j$::jsonb,
  'Hoy, descríbete tu semana a ti mismo y encuentra las horas que tienen dentro a la misma gente y nada en juego. Apunta cuántas hay.',
  $j${
    "beats": [
      {
        "situation": "Eres bien visto en el trabajo, gracioso con la gente que conoces, y no tienes a nadie a quien llamar un domingo.",
        "prompt": "¿Qué te dice esa combinación?",
        "options": [
          { "text": "No te estás exponiendo lo suficiente.", "correct": false, "note": "El diagnóstico estándar, y apunta al esfuerzo. La gente en esta posición normalmente se está esforzando más que nunca." },
          { "text": "Debes de estar haciendo algo mal socialmente.", "correct": false, "note": "Contradicho por la primera mitad de la frase. Alguien bien visto en el trabajo no está fallando con la gente." },
          { "text": "Ser buena compañía nunca fue lo que producía amistades.", "correct": true, "note": "La cercanía sí, y los compañeros de trabajo son cercanía con una tarea de por medio. Eso es un problema de suministro, no de simpatía." },
          { "text": "Los adultos sencillamente son más difíciles de tener como amigos.", "correct": false, "note": "Cómodo y mayormente falso. La mayoría de los adultos aceptarían encantados otro buen amigo y están exactamente en tu posición." }
        ]
      },
      {
        "situation": "Decides arreglarlo. Se presentan dos planes.",
        "prompt": "¿Cuál es más pequeño?",
        "options": [
          { "text": "Conviértete en alguien a quien esto le resulte más fácil — más extrovertido, mejor en las salas.", "correct": false, "note": "Convertirte en una persona distinta es lento y casi nunca funciona, y es el plan que produce el diagnóstico equivocado." },
          { "text": "Cambia lo que contiene tu semana.", "correct": true, "note": "Si el problema es infraestructura, el arreglo es infraestructura. Está disponible este mes y no requiere ningún cambio de personalidad." },
          { "text": "Di que sí a todo durante seis meses.", "correct": false, "note": "Agotador y sin foco, y maximiza la novedad — muchos primeros encuentros, que es el ingrediente del que ya tienes de sobra." },
          { "text": "Reconecta con todos con los que has perdido el contacto.", "correct": false, "note": "Merece la pena hacerlo, y es el bloque cinco. No construye el contacto repetido que falta ahora." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('why-it-got-hard', 2,
  'De qué está hecha de verdad la amistad',
  $md$Si el edificio hacía el trabajo, merece la pena saber exactamente qué hacía, porque se puede reconstruir a propósito.

Tres ingredientes, y ninguno es el encanto.

**Repetición.** La misma gente, más de una vez, con algún tipo de horario. Este es el grande y hace la mayor parte del trabajo. La familiaridad la produce la exposición y no el esfuerzo, y se acumula pase o no pase algo interesante.

**Poco en juego.** Nada dependiendo de ello, ningún resultado, ninguna tarea de por medio. Por esto los compañeros de trabajo tan a menudo no se hacen amigos a pesar de una cantidad enorme de contacto — siempre hay algo que hacer, y esa cosa ocupa el espacio donde habría ido la otra conversación.

**Tiempo sin estructura.** El rato de antes, el rato de después, el paseo hasta la estación. Casi todas las amistades que tienes se formaron en los márgenes de otra cosa y no en esa otra cosa.

**La jugada:** diseña la repetición, y deja que pase el resto.

La consecuencia merece la pena decirla claramente porque suena demasiado fácil: la sexta o séptima vez que ves a alguien, pasa una conversación que ninguno de los dos diseñó, y es de una clase distinta a las cinco anteriores. Eso no es una metáfora de la amistad — es el mecanismo real, y está disponible para alguien sin ninguna habilidad social, siempre que siga apareciendo.

También explica lo que más frustra a la gente: una conversación brillante con un desconocido no produce nada, y seis anodinas con la misma persona producen un amigo. La intensidad no es el ingrediente. La frecuencia sí.

Si te quedas con una cosa: la frecuencia gana a la calidad, por mucha distancia. No estás buscando una buena conversación, estás buscando una sexta.$md$,
  $j$[
    {
      "situation": "Tuviste una conversación brillante de dos horas con alguien en una boda.",
      "line": "(eso no produce nada por sí solo)",
      "why": "La intensidad no es el ingrediente. Seis conversaciones anodinas con la misma persona van a producir más que una excelente con un desconocido."
    },
    {
      "situation": "Ves a seis compañeros de trabajo todos los días y ninguno es amigo.",
      "line": "(siempre hay una tarea de por medio)",
      "why": "Poco en juego es uno de los tres ingredientes, y el trabajo lo elimina. La tarea ocupa el espacio donde habría ido la otra conversación."
    },
    {
      "situation": "Te preguntas cuándo empieza a sentirse distinto.",
      "line": "(hacia la sexta o séptima vez)",
      "why": "Pasa una conversación que ninguno de los dos diseñó. Ese es el mecanismo real, no una metáfora de uno."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué ingrediente hace la mayor parte del trabajo?",
      "options": [
        { "text": "La repetición.", "correct": true, "note": "La familiaridad la produce la exposición y no el esfuerzo, y se acumula pase o no pase algo interesante." },
        { "text": "Tener cosas en común.", "correct": false, "note": "Ayuda y está tremendamente sobrevalorado. La gente se hace amiga de quien ve repetidamente, y descubre las cosas en común después." },
        { "text": "Ser buena compañía.", "correct": false, "note": "Hace que cada encuentro sea más agradable y no produce por sí solo un segundo encuentro." },
        { "text": "Las experiencias compartidas.", "correct": false, "note": "Una descripción de lo que se acumula, no el ingrediente que lo produce." }
      ],
      "explain": "La frecuencia gana a la calidad por mucha distancia. No estás buscando una buena conversación, estás buscando una sexta."
    },
    {
      "prompt": "¿Por qué los compañeros de trabajo tan a menudo no se hacen amigos?",
      "options": [
        { "text": "La gente mantiene el trabajo y la vida separados a propósito.", "correct": false, "note": "Alguna gente sí. Mucha no, y aun así acaba sin amigos del trabajo." },
        { "text": "No los eliges tú.", "correct": false, "note": "Tampoco elegiste a nadie en el colegio, y ahí es donde la mayoría de la gente hizo sus amistades más cercanas." },
        { "text": "Siempre hay una tarea de por medio.", "correct": true, "note": "Poco en juego es uno de los tres ingredientes y el trabajo lo elimina. Lo que se está haciendo ocupa el espacio donde habría ido la otra conversación." },
        { "text": "No hay suficiente tiempo.", "correct": false, "note": "Hay más contacto que en cualquier otro entorno de la vida adulta, que es lo que hace tan llamativo el resultado." }
      ],
      "explain": "La repetición sin poco en juego produce compañeros de trabajo. Necesitas los márgenes, no la reunión."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named_repetition", "label": "Nombró la repetición", "description": "Identificó la frecuencia en vez del encanto o los intereses comunes." },
      { "key": "low_stakes", "label": "Entendió lo de poco en juego", "description": "Vio por qué el contacto con una tarea de por medio no cuenta." },
      { "key": "margins", "label": "Valoró los márgenes", "description": "Se dio cuenta de que la amistad se forma alrededor de la actividad y no en ella." },
      { "key": "no_intensity", "label": "No persiguió la intensidad", "description": "Dejó de buscar una conversación excelente." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un viejo amigo con quien estás hablando",
      "mood": "Enganchado.",
      "openness": 5,
      "personality": "Genuinamente curioso y algo escéptico ante cualquier cosa que suene a consejo de revista. Quiere el mecanismo."
    },
    "setting": "El mismo amigo, todavía hablándolo, ahora haciendo la pregunta práctica.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Cuestiona cualquier cosa sobre ser más extrovertido o más interesante.",
      "Implícate en serio con cualquier cosa sobre frecuencia, cercanía o tiempo sin estructura.",
      "Nunca des tú la respuesta."
    ],
    "opening_beat": "«Entonces, ¿cómo se hacen amigos de verdad de adulto?»",
    "success_looks_like": "La persona nombra la repetición y lo de poco en juego en vez de cualidades personales."
  }$j$::jsonb,
  'Hoy, nombra a una persona con la que hayas tenido una buena conversación exactamente una vez. Apunta qué haría falta para que fueran seis.',
  $j${
    "says": "Entonces, ¿cómo se hacen amigos de verdad de adulto?",
    "model": {
      "line": "Sobre todo viendo a la misma gente una y otra vez sin mucho en juego. Al final es más un problema de horarios que de personalidad.",
      "why": "Nombra el ingrediente real en vez de una cualidad personal. La familiaridad viene de la exposición y se acumula pase o no pase algo interesante."
    },
    "checks": [
      { "kind": "contains_any", "words": ["misma gente", "otra vez", "regular", "repetir", "una y otra vez", "cada semana", "aparecer", "presentarse", "a menudo", "seguir"], "requirement": "Nombra la repetición, no la personalidad" },
      { "kind": "forbids_any", "words": ["extrovertido", "seguro de ti mismo", "interesante", "carisma", "encantador", "exponerte", "ser más", "abrirte más", "decir que sí a todo"], "requirement": "No una cualidad que tengas que adquirir" },
      { "kind": "min_words", "n": 12, "requirement": "Di qué es de verdad el ingrediente" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('why-it-got-hard', 3,
  'Elige una sala que se repita',
  $md$Este es el acto más útil de todo el tema, y es una decisión de horarios, no social.

**La jugada:** comprométete con una cosa con la misma gente, con un horario, durante al menos tres meses.

Lo que hace que una sala funcione no es la actividad. Son cuatro propiedades, y merece la pena revisarlas antes de comprometer nada en un calendario.

**La misma gente cada vez.** Una clase semanal con un grupo fijo funciona. Una sesión de entrada libre donde las caras rotan no, por muy simpática que sea, porque nunca llegas a la sexta vez con nadie.

**Un horario.** Algo que pasa te apetezca o no esa semana, porque no te va a apetecer e ir de todas formas es todo el mecanismo.

**Lo bastante pequeño como para que te reconozcan.** De ocho a veinte personas es lo ideal. Doscientas es una multitud y eres anónimo en ella.

**Tiempo alrededor de los bordes.** Algo con un bar después, un café antes, un paseo hasta la estación. Esto importa mucho más de lo que suena — la amistad no se forma en la actividad, se forma en los márgenes.

Esta última merece la pena revisarla en concreto, porque muchas salas que por lo demás son buenas fallan en esto. Una clase de gimnasio donde todo el mundo se va de inmediato suministra repetición y ningún margen, y puede funcionar durante dos años sin producir ni una sola conversación.

Lo que no funciona, a pesar de ser a lo que la gente recurre primero: eventos puntuales, grandes eventos de networking, cualquier cosa cuyo único sentido es conocer gente. Eso maximiza la novedad, que es lo contrario del ingrediente que necesitas, y es agotador exactamente para quien está leyendo esto.

Si te quedas con una cosa: elige por la forma, no por el tema. No estás eligiendo una afición, estás comprando una sexta conversación con la misma persona.$md$,
  $j$[
    {
      "situation": "Estás eligiendo entre una clase semanal y una quedada mensual.",
      "line": "(semanal, siempre)",
      "why": "La repetición es el ingrediente. Mensual significa que la sexta vez está a seis meses, momento en el que nadie se acuerda de nadie."
    },
    {
      "situation": "La clase es buena y todo el mundo se va en cuanto termina.",
      "line": "(sin márgenes — no va a producir nada)",
      "why": "Las amistades se forman en el rato de antes y en el rato de después. Una sala sin bordes puede funcionar dos años y no producir nada."
    },
    {
      "situation": "Estás considerando un gran evento de networking.",
      "line": "(eso maximiza la novedad, que es lo contrario de lo que necesitas)",
      "why": "Conocer a mucha gente una vez es el ingrediente del que ya tienes de sobra. Y es agotador exactamente para quien está leyendo esto."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué propiedad importa más al elegir?",
      "options": [
        { "text": "Que disfrutes de la actividad.", "correct": false, "note": "Tiene que ser tolerable para que sigas yendo. Más allá de eso, el tema es casi irrelevante." },
        { "text": "Que la gente parezca de tu estilo.", "correct": false, "note": "Casi imposible de juzgar de antemano, y la repetición suele producir esa sensación en vez de necesitarla." },
        { "text": "Que tenga la misma gente cada vez.", "correct": true, "note": "Un sitio de entrada libre con caras rotando suministra contacto y nunca llega a una sexta vez con nadie, por muy simpático que sea." },
        { "text": "Que sea fácil de llegar.", "correct": false, "note": "De verdad importante para seguir yendo, y una restricción en vez de la propiedad que hace que una sala funcione." }
      ],
      "explain": "Elige por la forma, no por el tema. Estás comprando una sexta conversación con la misma persona."
    },
    {
      "prompt": "¿Cuál es la propiedad que más se pasa por alto?",
      "options": [
        { "text": "Un horario.", "correct": false, "note": "La gente suele acertar en esto — una clase o un equipo ya lo lleva incorporado." },
        { "text": "Ser lo bastante pequeño como para que te reconozcan.", "correct": false, "note": "A menudo acierta por accidente, ya que la mayoría de clases y equipos tienen de todas formas el tamaño correcto." },
        { "text": "Tiempo alrededor de los bordes.", "correct": true, "note": "Una clase de gimnasio donde todo el mundo se va en cuanto termina suministra repetición y ningún margen, y puede funcionar dos años sin producir una conversación." },
        { "text": "Algo que se te dé bien.", "correct": false, "note": "No es una propiedad que importe en absoluto, y que se te note que se te da mal algo es un lubricante social perfectamente bueno." }
      ],
      "explain": "La amistad no se forma en la actividad. Se forma en el rato de antes y en el de después."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "same_people", "label": "Misma gente cada vez", "description": "Eligió un grupo fijo en vez de uno rotativo." },
      { "key": "schedule", "label": "Con un horario", "description": "Eligió algo que pasa le apetezca o no." },
      { "key": "margins", "label": "Tiene márgenes", "description": "Revisó que hubiera tiempo alrededor de los bordes." },
      { "key": "committed", "label": "Se comprometió a una racha", "description": "Se apuntó para meses en vez de probarlo una vez." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un viejo amigo ayudándote a elegir",
      "mood": "Práctico.",
      "openness": 5,
      "personality": "Pregunta por la forma de cada opción en vez de por la actividad — quién, con qué frecuencia, y si alguien se queda después."
    },
    "setting": "Has decidido hacer algo al respecto y estás mirando opciones: un club de lectura mensual, un fútbol sala semanal, una clase de gimnasio de entrada libre, y un gran encuentro del sector el mes que viene.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta quién está ahí, con qué frecuencia, y si la gente se queda después.",
      "Aprueba una elección hecha por la forma y cuestiona una hecha por el tema.",
      "Nunca recomiendes tú una."
    ],
    "opening_beat": "«Vale, ¿cuál vas a hacer de verdad?»",
    "success_looks_like": "La persona elige por la repetición y los márgenes en vez de por la actividad."
  }$j$::jsonb,
  'Hoy, encuentra algo con la misma gente, con horario, con tiempo alrededor de los bordes. Apunta qué es y cuándo pasa.',
  $j${
    "beats": [
      {
        "situation": "Cuatro opciones: un club de lectura mensual, un fútbol sala semanal con equipo fijo, una clase de gimnasio de entrada libre con caras distintas cada vez, y un gran encuentro del sector el mes que viene.",
        "prompt": "¿Cuál?",
        "options": [
          { "text": "El club de lectura mensual — misma gente, y lo disfrutarías.", "correct": false, "note": "Acierta en la gente y falla en la frecuencia. Mensual pone el sexto encuentro a seis meses, momento en el que nadie se acuerda de nadie." },
          { "text": "El fútbol sala semanal.", "correct": true, "note": "Misma gente, con horario, lo bastante pequeño como para que te reconozcan, y casi siempre hay un bar después. La actividad es casi irrelevante." },
          { "text": "La clase de entrada libre — más contacto por semana.", "correct": false, "note": "Caras rotando. Suministra contacto y nunca llega a una sexta vez con nadie, por muy simpático que sea." },
          { "text": "El encuentro — todo el sentido es conocer gente.", "correct": false, "note": "Maximiza la novedad, que es lo contrario del ingrediente que necesitas, y es agotador exactamente para quien está leyendo esto." }
        ]
      },
      {
        "situation": "Encontraste una clase semanal con un grupo fijo. Todo el mundo se va en cuanto termina.",
        "prompt": "¿Funciona?",
        "options": [
          { "text": "Sí — la repetición es el ingrediente principal y lo tiene.", "correct": false, "note": "Tiene dos de las cuatro propiedades y le falta la que produce conversaciones. Esta sala puede funcionar dos años y no producir nada." },
          { "text": "Sí, si te esfuerzas por hablar durante ella.", "correct": false, "note": "Durante es la actividad. Las amistades se forman en los márgenes, que es precisamente lo que no tiene esta sala." },
          { "text": "No — y merece la pena encontrar una con bordes, o crearlos.", "correct": true, "note": "El tiempo antes o después es la propiedad que la gente más pasa por alto. Sugerir una copa después puede crearlo, y si nadie se queda nunca, la sala tiene la forma equivocada." },
          { "text": "No — déjalo y busca otra cosa de inmediato.", "correct": false, "note": "Demasiado rápido. A veces se pueden crear márgenes, y merece la pena un intento antes de descartar una sala que tiene las otras tres propiedades." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('why-it-got-hard', 4,
  'La cuarta vez es la difícil',
  $md$Elegiste la sala, fuiste tres veces, y no ha pasado nada. Este es el punto en el que casi todo el mundo lo deja, y es exactamente el punto en el que dejarlo garantiza el resultado que temían.

Tres visitas producen más o menos nada, y se supone que tiene que ser así. Sigues siendo una cara nueva. La gente ha sido educada. Nadie se ha aprendido tu nombre bien. Si lo dejaras ahora, nada de la experiencia habría sido inusual y nada habría sido un veredicto.

**La jugada:** sigue yendo mientras todavía no produzca nada.

Esa es toda la habilidad, y es de horarios, no social. La cuarta, quinta y sexta vez son las que hacen el trabajo, y se sienten idénticas a las tres primeras desde dentro — que es por lo que la bajada pilla a la gente. No se siente como estar a tres cuartas partes de algo. Se siente como una prueba.

Hay dos cosas que merece la pena decidir de antemano, porque decidirlas en el momento sale mal. Comprométete a un número en vez de a un sentimiento: ocho sesiones, por ejemplo, antes de permitirte tener una opinión sobre si está funcionando. Y ve las semanas que no te apetece, porque esas son las que cargan con todo el peso — todo el mundo va cuando le apetece, y eso no es suficiente repetición como para llegar a nadie.

El pensamiento concreto al que hay que vigilar es *esta gente ya se conoce toda*. Normalmente cierto, normalmente irrelevante, y es la interpretación estándar de la semana tres. Los grupos incorporan a gente nueva constantemente. Lo que no hacen es anunciarlo.

Y baja el listón de lo que cuenta como progreso. Que te reconozcan es progreso. Que alguien recuerde tu nombre es progreso significativo. Una conversación sobre algo distinto de la actividad es casi todo el camino. Si mides según si ya has hecho un amigo, vas a concluir que ha fallado cada semana hasta la semana en que obviamente haya funcionado.

Si te quedas con una cosa: ve la cuarta vez. Es toda la diferencia, y no cuesta nada más que una noche que ya tenías reservada.$md$,
  $j$[
    {
      "situation": "Tres sesiones después y nadie te ha hablado como es debido.",
      "line": "(eso es lo que parece la tercera)",
      "why": "Sigues siendo una cara nueva y nadie se ha aprendido tu nombre. Nada de eso es inusual y nada es un veredicto."
    },
    {
      "situation": "Es martes y no te apetece ir.",
      "line": "(esas son las que cuentan)",
      "why": "Todo el mundo va cuando le apetece, y eso no es suficiente repetición como para llegar a nadie. Las semanas que no te apetece son las que cargan con el peso."
    },
    {
      "situation": "«Ya se conocen todos entre ellos.»",
      "line": "(cierto, e irrelevante)",
      "why": "Los grupos incorporan a gente nueva constantemente. Lo que no hacen es anunciarlo, que es por lo que la semana tres siempre parece cerrada."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué la cuarta vez es la difícil?",
      "options": [
        { "text": "Se ha pasado la novedad.", "correct": false, "note": "Algo de eso, y no es lo que hace que la gente lo deje." },
        { "text": "Se siente idéntica a las tres primeras, así que la bajada se lee como prueba.", "correct": true, "note": "No se siente como estar a tres cuartas partes de algo. Se siente como un resultado, que es exactamente cuando la gente lo deja." },
        { "text": "Se te han acabado las cosas que decir.", "correct": false, "note": "La conversación no es la restricción aquí. Aparecer sí lo es." },
        { "text": "La gente ya ha decidido sobre ti para entonces.", "correct": false, "note": "Apenas te han registrado para entonces, que es el estado real de las cosas en la semana tres." }
      ],
      "explain": "La cuarta, quinta y sexta son las que hacen el trabajo, y se sienten como las tres primeras."
    },
    {
      "prompt": "¿Qué deberías medir?",
      "options": [
        { "text": "Si ya has hecho un amigo.", "correct": false, "note": "Con esa medida ha fallado cada semana hasta la semana en que obviamente haya funcionado, que es una garantía de que lo dejarás." },
        { "text": "Si lo disfrutaste.", "correct": false, "note": "Merece la pena saberlo y no es el punto. Muchas salas agradables no producen a nadie, y viceversa." },
        { "text": "Si hablaste con alguien.", "correct": false, "note": "Más cerca, y convierte cada semana en un aprobado o suspenso sobre tu desempeño en vez de sobre tu asistencia." },
        { "text": "Que te reconozcan, luego que te nombren, luego que te hablen de algo distinto.", "correct": true, "note": "Tres hitos reales, todos los cuales llegan antes que una amistad, y todos visibles desde la semana cuatro en adelante." }
      ],
      "explain": "Comprométete a un número de sesiones, no a un sentimiento, y baja el listón de lo que cuenta como progreso."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "went_back", "label": "Volvió", "description": "Regresó mientras todavía no producía nada." },
      { "key": "number_not_feeling", "label": "Se comprometió a un número", "description": "Fijó un número de sesiones en vez de juzgar semana a semana." },
      { "key": "hard_weeks", "label": "Fue en las semanas planas", "description": "Apareció cuando no le apetecía." },
      { "key": "measured_right", "label": "Midió lo correcto", "description": "Contó el reconocimiento y los nombres en vez de las amistades." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un viejo amigo con quien te estás escribiendo",
      "mood": "Directo y cálido.",
      "openness": 5,
      "personality": "Pregunta qué esperabas que pareciera la semana tres, y no acepta no está funcionando como respuesta tan pronto."
    },
    "setting": "Tres semanas después de lo que te comprometiste a hacer. No ha pasado nada, nadie sabe tu nombre, y vuelve a tocar mañana.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué esperaba que produjeran tres semanas, si la respuesta es que no está funcionando.",
      "Alégrate con naturalidad ante una decisión de seguir yendo.",
      "Nunca le digas a la persona que lleva más tiempo — deja que llegue sola a esa conclusión."
    ],
    "opening_beat": "«Tres veces ya. ¿Alguna buena?»",
    "success_looks_like": "La persona trata la semana tres como demasiado pronto para juzgar y se compromete a volver."
  }$j$::jsonb,
  'Hoy, vuelve a algo por cuarta vez, o comprométete por escrito a un número de sesiones. Apunta el número.',
  $j${
    "says": "Tres veces ya. ¿Alguna buena?",
    "model": {
      "line": "Nada todavía, pero tres es nada. Me he puesto ocho antes de decidir nada, así que voy otra vez mañana.",
      "why": "Un número en vez de un sentimiento, y el informe honesto de que la semana tres no produjo nada — que es lo que se supone que tiene que producir la semana tres."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["no está funcionando", "no es para mí", "pérdida de tiempo", "rendirse", "inútil", "ya se conocen todos", "no tiene sentido", "dejarlo"], "requirement": "Tres semanas no es un veredicto" },
      { "kind": "contains_any", "words": ["otra vez", "volver", "la semana que viene", "mañana", "seguir yendo", "continuar", "ocho", "unas cuantas más", "aguantar"], "requirement": "Comprométete a volver" },
      { "kind": "min_words", "n": 10, "requirement": "Di el número o la próxima fecha" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('why-it-got-hard', 5,
  'Ya tienes candidatos',
  $md$Antes de construir nada nuevo, merece la pena fijarse en que la mayoría de la gente ya tiene tres o cuatro personas que están casi todo el camino recorrido y a las que sencillamente nunca se ha movido.

**La jugada:** haz una lista de la gente que ya ves repetidamente, y elige a dos.

Los criterios son mecánicos y no emocionales, que es el punto — no estás preguntando quién te gusta más, estás preguntando dónde ya existe la infraestructura. Alguien a quien ves con regularidad sin quedar. Alguien con quien siempre acabas hablando. Alguien con quien te ha alegrado encontrarte más de una vez. Alguien a quien le has dicho *deberíamos quedar*.

Esa última es la señal más fuerte de la lista y casi nadie actúa según ella. Dos personas que han dicho las dos lo mismo son dos personas que las dos, de forma independiente, han querido esto — y las dos están esperando a que la otra haga algo al respecto, que es exactamente el punto muerto que el siguiente bloque existe para romper.

Busca en los sitios donde ya pasa el contacto: la puerta del colegio, el mismo tren, el gimnasio, la gente en los bordes de un grupo de amigos ya existente, el compañero de otro equipo, el vecino. El paseo del perro. Alguien con quien estuviste cerca hace cinco años y con quien no has hablado desde entonces, que es un caso distinto y mucho más fácil de lo que se siente.

Y el contraintuitivo: los amigos de amigos son la fuente de mayor rendimiento que hay. Tienes un contexto compartido, un entorno fácil, y alguien que en la práctica ha respondido por los dos. También es socialmente gratis — ir a algo a lo que va tu amigo no requiere ninguna explicación.

Lo que este ejercicio suele producir es una sorpresa leve. La gente llega a este tema convencida de que no conoce a nadie y sale de la lista con cuatro nombres, y el problema cambia de forma por completo: no es que no haya nadie, es que nunca se ha propuesto nada.

Si te quedas con una cosa: escribe la lista. Casi siempre es más larga que el sentimiento que te mandó a buscarla.$md$,
  $j$[
    {
      "situation": "Sientes que no conoces a nadie.",
      "line": "(escribe la lista de todas formas)",
      "why": "La gente llega aquí convencida de que no hay nadie y sale con cuatro nombres. El problema suele ser que no se ha propuesto nada, no que no exista nadie."
    },
    {
      "situation": "Tú y alguien habéis dicho los dos deberíamos quedar.",
      "line": "(esa es la señal más fuerte de la lista)",
      "why": "Dos personas han querido esto de forma independiente y las dos están esperando a la otra. Es un punto muerto, no una ausencia."
    },
    {
      "situation": "Tu amigo tiene un amigo con quien siempre te llevas bien en las fiestas.",
      "line": "(el mayor rendimiento que hay)",
      "why": "Contexto compartido, entorno fácil, y alguien que en la práctica ha respondido por los dos. Ir a algo a lo que va tu amigo no necesita ninguna explicación."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué estás buscando en la lista?",
      "options": [
        { "text": "Donde ya pasa el contacto sin quedar.", "correct": true, "note": "Mecánico, no emocional. No estás preguntando quién te gusta más — estás preguntando dónde ya existe la infraestructura." },
        { "text": "La gente que más te gusta.", "correct": false, "note": "A menudo gente a la que nunca ves, lo que significa empezar de cero. Que te gusten no es el ingrediente escaso." },
        { "text": "Gente que parece necesitar amigos.", "correct": false, "note": "Imposible de saber desde fuera, y convierte todo el asunto en un acto de caridad en vez de algo que quieres." },
        { "text": "Gente con cosas en común contigo.", "correct": false, "note": "Sobrevalorado. La repetición suele producir la sensación de tener cosas en común en vez de necesitarla." }
      ],
      "explain": "Pregunta dónde ya está el contacto. Eso es lo que convierte a alguien en candidato."
    },
    {
      "prompt": "¿Por qué los amigos de amigos son la fuente de mayor rendimiento?",
      "options": [
        { "text": "Ya están preseleccionados por compatibilidad.", "correct": false, "note": "Vagamente, y el gusto en amigos varía enormemente. No es eso lo que lo hace fácil." },
        { "text": "Los vas a ver de todas formas.", "correct": false, "note": "A veces, y no de forma lo bastante fiable como para ser el mecanismo." },
        { "text": "Contexto compartido, un entorno fácil, y ninguna explicación necesaria.", "correct": true, "note": "Ir a algo a lo que va tu amigo es socialmente gratis, lo que elimina la parte incómoda antes de que llegue." },
        { "text": "Tu amigo puede presentaros como es debido.", "correct": false, "note": "Ayuda cuando pasa y no hace falta. El entorno hace el trabajo, no la presentación." }
      ],
      "explain": "El camino con menos fricción casi siempre pasa por alguien a quien ya conoces."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "listed", "label": "Escribió la lista de verdad", "description": "Nombró personas concretas en vez de pensarlo en general." },
      { "key": "mechanical", "label": "Usó la prueba mecánica", "description": "Buscó el contacto existente en vez de a quién le gusta más." },
      { "key": "we_should", "label": "Incluyó a la gente del deberíamos quedar", "description": "Se dio cuenta de los puntos muertos ya en juego." },
      { "key": "picked", "label": "Eligió a dos", "description": "Lo redujo en vez de dejar una lista." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un viejo amigo con quien estás hablando",
      "mood": "Insistente con cariño.",
      "openness": 5,
      "personality": "Se niega a aceptar nadie como respuesta y pregunta por entornos concretos — el trabajo, el gimnasio, la puerta del colegio, sus propios amigos."
    },
    "setting": "La misma conversación. Tu amigo ha hecho la pregunta obvia y has dicho que en realidad no conoces a nadie.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta por un entorno cada vez que la persona diga que no hay nadie.",
      "Alégrate y sé concreto cuando salga un nombre o grupo real.",
      "Nunca sugieras tú una persona."
    ],
    "opening_beat": "«Vale, pero ¿a quién ves ya de verdad? Cualquiera.»",
    "success_looks_like": "La persona nombra personas concretas con las que ya tiene contacto repetido."
  }$j$::jsonb,
  'Hoy, apunta a todas las personas que ya ves repetidamente sin quedar. Elige a dos. Apunta los nombres.',
  $j${
    "says": "Vale, pero ¿a quién ves ya de verdad? Cualquiera.",
    "model": {
      "line": "Los dos con los que siempre acabo hablando en el rocódromo, y Priya del otro equipo a quien le he dicho deberíamos comer juntas unas cuatro veces.",
      "why": "Personas concretas encontradas con una prueba mecánica — dónde ya pasa el contacto — en vez de por quién te gusta más. La del deberíamos quedar es la señal más fuerte de la lista."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["nadie", "a nadie", "en realidad a nadie", "literalmente ninguno", "no hay", "no veo a nadie", "nadie de verdad"], "requirement": "Hay alguien — la lista es más larga que el sentimiento" },
      { "kind": "min_words", "n": 10, "requirement": "Nombra personas o lugares reales" },
      { "kind": "max_words", "n": 45, "requirement": "Dos o tres, no todo el mundo que conoces" }
    ]
  }$j$::jsonb
);
