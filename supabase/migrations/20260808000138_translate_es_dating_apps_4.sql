-- Spanish: Apps de citas, track 4 — Llevar la aplicación sin que ella te lleve a ti.
--
-- Conventions as prior tracks: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer (used
-- throughout this track's theory, new to this topic). The scenario
-- partner "Sam" carries no `sex` field in the English source, so — as
-- with "Robin" in the small-talk migrations — masculine agreement is
-- used by default for any adjective describing them.

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

select pg_temp.es_lesson('running-the-app', 1,
  'El volumen no es un veredicto',
  $md$Cuarenta deslizamientos, dos matches. Ocho mensajes, tres respuestas. Dos conversaciones que se apagan y una copa que nunca se confirma.

Cada uno de esos números es una tasa base corriente. Cada uno llega sintiéndose como un pequeño juicio personal, entregado varias veces al día, a alguien que ya estaba predispuesto a leer el silencio como información sobre sí mismo.

**La jugada:** aprende las proporciones reales, para que dejes de medirte contra una imaginaria.

Nadie las publica, que es la raíz del problema — así que la gente inventa las suyas a partir de la esperanza. La versión inventada es, más o menos: si soy razonablemente normal, la mayoría de la gente que me gusta debería hacer match, la mayoría de los matches deberían hablar, y la mayoría de las conversaciones deberían llevar a algo. Medida contra eso, una semana media parece un fracaso personal catastrófico.

La forma real es un embudo que pierde la mayor parte de su contenido en cada etapa, para todo el mundo. Unas tasas de match de un solo dígito bajo son de lo más corriente. La mayoría de los matches nunca intercambian ni una palabra. La mayoría de las conversaciones no se convierten en citas. Esto no es una descripción de que a ti te vaya mal, es una descripción del producto funcionando con normalidad, y a quienes parece irles bien les están saliendo las mismas proporciones con un numerador más grande.

Lo que produce la única conclusión de comportamiento genuinamente útil: el arreglo para una semana floja casi siempre son más intentos, no un intento mejor. Suena desolador y es justo lo contrario — significa que la palanca es el volumen, que está por completo bajo tu control, en vez de ser más atractivo o más interesante, que no lo está.

Y merece la pena fijarse en lo que los números no te pueden decir. Un no-match no es un rechazo por parte de una persona; es alguien moviendo un pulgar mientras ve la tele a medias. Nada de eso se pensó, lo que significa que nada de eso es información.

Si te quedas con una cosa: estás leyendo una tasa base, no un veredicto. Los números de todo el mundo tienen este aspecto.$md$,
  $j$[
    {
      "situation": "Cuarenta deslizamientos esta semana, dos matches.",
      "line": "(esa es la tasa base)",
      "why": "Unas tasas de match de un solo dígito bajo son de lo más corriente. El estándar inventado — la mayoría de la gente que me gusta debería hacer match — es lo que hace que una semana normal parezca un fracaso."
    },
    {
      "situation": "Quieres arreglar una semana floja.",
      "line": "(más intentos, no mejores)",
      "why": "La palanca es el volumen, que está bajo tu control, en vez de ser más atractivo, que no lo está. Es una mejor posición de lo que suena."
    },
    {
      "situation": "Alguien no te devolvió el match.",
      "line": "(un pulgar, viendo la tele a medias)",
      "why": "Nada de eso se pensó, lo que significa que nada de eso es información sobre ti."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué una semana media se siente como un fracaso?",
      "options": [
        { "text": "Porque las aplicaciones están diseñadas para hacerte sentir mal.", "correct": false, "note": "Sus incentivos no están alineados con los tuyos, y este efecto en concreto es más sencillo que una conspiración." },
        { "text": "Porque te estás midiendo contra una tasa que te has inventado.", "correct": true, "note": "Nadie publica las reales, así que la gente llena el hueco con esperanza — la mayoría de la gente que me gusta debería hacer match — y una semana normal pierde por goleada contra eso." },
        { "text": "Porque el rechazo se acumula.", "correct": false, "note": "Se acumula, y llamarlo rechazo es la mala lectura. La mayor parte de eso nunca fue una decisión sobre ti." },
        { "text": "Porque a todos los demás les va mejor.", "correct": false, "note": "Les están saliendo las mismas proporciones con un numerador más grande, que parece éxito y es aritmética." }
      ],
      "explain": "Aprende la forma real y la misma semana deja de ser un boletín de notas."
    },
    {
      "prompt": "¿Qué se deduce de las tasas base?",
      "options": [
        { "text": "Baja tus estándares.", "correct": false, "note": "Nada de esto dice a quién querer. Dice cuántos intentos hace falta para un resultado normal." },
        { "text": "No merece la pena usar las aplicaciones.", "correct": false, "note": "Una conclusión a la que llega honestamente alguna gente, y no se deduce solo de las proporciones." },
        { "text": "La palanca es el volumen, y el volumen está bajo tu control.", "correct": true, "note": "El arreglo para una semana floja son más intentos, no un intento mejor — que es una posición mucho mejor que necesitar ser más atractivo." },
        { "text": "Es sobre todo suerte.", "correct": false, "note": "La suerte juega un papel, y este planteamiento vuelve todo pasivo, que es lo contrario de la conclusión útil." }
      ],
      "explain": "Un no-match es un pulgar moviéndose mientras alguien ve la tele a medias."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "base_rate", "label": "Lo leyó como una tasa base", "description": "Dejó de tratar los números como un juicio." },
      { "key": "no_invented", "label": "Abandonó el estándar inventado", "description": "Dejó de medirse contra una tasa que nadie alcanza." },
      { "key": "volume", "label": "Recurrió al volumen", "description": "Respondió a una semana floja con más intentos en vez de con automejora." },
      { "key": "no_meaning", "label": "No le buscó significado a un no-match", "description": "Trató un acto no pensado como algo sin información." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo que lleva años usando estas aplicaciones",
      "mood": "Práctico, sin rodeos.",
      "openness": 5,
      "personality": "Pregunta por los números reales y luego cuenta los suyos, que son casi idénticos y que a él le parecen de lo más corriente."
    },
    "setting": "Un amigo te ha preguntado qué tal van las aplicaciones y acabas de describir una semana que se sintió humillante.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Cuenta tus propios números comparables sin rodeos cada vez que la persona diga que los suyos son malos.",
      "Pregunta qué tasa esperaba, y de dónde salió esa expectativa.",
      "Nunca tranquilices a la persona directamente."
    ],
    "opening_beat": "«Venga, dime — ¿cuántos matches, en realidad? ¿De cuántos?»",
    "success_looks_like": "La persona lee sus números como una tasa base en vez de como un veredicto."
  }$j$::jsonb,
  'Hoy, cuenta los números reales de una semana — deslizamientos, matches, respuestas. Apúntalos, y apunta qué habías asumido que deberían ser.',
  $j${
    "beats": [
      {
        "situation": "Esta semana: cuarenta deslizamientos, dos matches, ocho mensajes mandados, tres respuestas, ninguna cita.",
        "prompt": "¿Qué es eso?",
        "options": [
          { "text": "Una mala semana — algo va mal.", "correct": false, "note": "Es una semana de lo más corriente. Leerla como mala requiere un estándar que nadie alcanza de verdad." },
          { "text": "Prueba de que necesitas mejores fotos.", "correct": false, "note": "Puede ser, y no lo puedes saber por una semana, y desde luego no lo puedes saber por sentirte mal. Ese es el siguiente bloque." },
          { "text": "La tasa base, funcionando con normalidad.", "correct": true, "note": "Unas tasas de match de un solo dígito bajo son corrientes, la mayoría de los matches nunca hablan, la mayoría de las conversaciones no se convierten en citas. A quienes parece irles bien les salen las mismas proporciones con un numerador más grande." },
          { "text": "Prueba de que las aplicaciones no funcionan para ti.", "correct": false, "note": "Seis meses podrían decirte eso. Una semana de números completamente normales no puede." }
        ]
      },
      {
        "situation": "Quieres que la semana que viene vaya mejor.",
        "prompt": "¿Cuál es la palanca?",
        "options": [
          { "text": "Sé más interesante en tus mensajes.", "correct": false, "note": "Merece la pena hacerlo, y es el bloque dos. No es lo que da la vuelta a una semana floja, y no está de forma fiable bajo tu control." },
          { "text": "Más intentos.", "correct": true, "note": "El arreglo para una semana floja es casi siempre el volumen, no un intento mejor — que es una posición mucho mejor que necesitar ser más atractivo." },
          { "text": "Sé más selectivo, para que los matches cuenten.", "correct": false, "note": "Menos intentos contra la misma tasa base produce menos de todo." },
          { "text": "Espera — se equilibra solo.", "correct": false, "note": "No se equilibra solo. El numerador es la parte que controlas." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('running-the-app', 2,
  'El ghosting es un hábito, no un mensaje',
  $md$Alguien fue cálido, respondió rápido, quedó en tomar algo, y luego dejó de responder. No va a llegar ninguna explicación, y esa ausencia es lo que hace que se te quede clavado — porque una mente sin información va a fabricar alguna, y lo que fabrica siempre es sobre ti.

**La jugada:** trata una desaparición como un hecho sobre el medio, no como un mensaje sobre ti.

El relato sincero de por qué pasa no deja mal a nadie en concreto. Estas aplicaciones hacen que dejar de responder no cueste nada, porque quien desaparece nunca tiene que decir nada, nunca ve tu reacción, y no se te va a cruzar por la calle. Quita toda esa fricción y un buen número de personas corrientes y decentes simplemente van a parar — no por crueldad, sino porque terminar las cosas educadamente exige un esfuerzo que nadie les ha pedido hacer.

Las causas reales más habituales son sosas. Volvieron con alguien. Hicieron match con otra persona esa misma noche. La conversación se estancó y retomarla se sintió incómodo. En realidad no usan la aplicación. Se liaron el martes y para el viernes ya se había convertido en algo que tendrían que explicar.

Nunca vas a saber cuál, y esa es la parte que merece la pena aceptar a propósito en vez de pelear contra ella. El error no es sentirse mal — es ir a buscar el motivo, lo que significa releer el intercambio, encontrar el mensaje donde "cambió todo", y darle un significado que casi con toda seguridad nunca estuvo ahí.

Dos cosas prácticas. No mandes el segundo mensaje de seguimiento: uno ligero está bien y no añade nada a tu exposición, y es el siguiente el que te va a quedar en la cabeza. Y no ajustes tu comportamiento a partir de una sola desaparición — la gente concluye que fue demasiado insistente, demasiado sosa, demasiado directa, apoyándose en algo que no tenía ningún contenido.

Si te quedas con una cosa: no va a llegar ninguna explicación, e inventarte una te cuesta mucho más de lo que te costó la persona.$md$,
  $j$[
    {
      "situation": "Calidez, respuestas rápidas, una copa acordada, y luego nada.",
      "line": "(no va a llegar ninguna explicación)",
      "why": "La ausencia es lo que hace que se te quede clavado, porque una mente sin información fabrica alguna — y lo que fabrica siempre es sobre ti."
    },
    {
      "situation": "Estás releyendo el intercambio para encontrar dónde cambió todo.",
      "line": "(no hay ningún cambio que encontrar)",
      "why": "Las causas más habituales son sosas y externas. Darle un significado a un mensaje es inventar contenido que nunca estuvo ahí."
    },
    {
      "situation": "Mandaste un seguimiento ligero y no supiste nada.",
      "line": "(ese es el último)",
      "why": "El primero no cuesta nada. El segundo es el que te va a quedar en la cabeza, y no añade ninguna información."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué el ghosting pasa tanto específicamente en las aplicaciones?",
      "options": [
        { "text": "La gente en las aplicaciones es menos considerada.", "correct": false, "note": "Sobre todo la misma gente que se comporta bien en otros sitios. Lo que cambió fue el entorno, no la población." },
        { "text": "No hay fricción, así que terminar las cosas educadamente exige un esfuerzo que nadie les pide hacer.", "correct": true, "note": "Nunca tienen que decir nada, nunca ven tu reacción, y no se te van a cruzar por la calle. Quita todo eso y la gente decente simplemente para." },
        { "text": "Hay demasiada elección.", "correct": false, "note": "Un factor que contribuye y no el mecanismo. Un montón de ghosting pasa entre gente sin ninguna otra conversación en marcha." },
        { "text": "Es una forma de decir que no.", "correct": false, "note": "Casi nunca se pretende como un mensaje, que es precisamente por lo que leer uno en ello sale mal." }
      ],
      "explain": "Un hecho sobre el medio, no un mensaje sobre ti."
    },
    {
      "prompt": "¿Cuál es el error de verdad después de que te hagan ghosting?",
      "options": [
        { "text": "Sentirte mal por ello.", "correct": false, "note": "Completamente razonable, y no es un error. Sí pasó algo, y fue decepcionante." },
        { "text": "Mandar un seguimiento.", "correct": false, "note": "Uno ligero es gratis. Es el segundo el que se convierte en lo que te queda en la cabeza." },
        { "text": "Ir a buscar el motivo.", "correct": true, "note": "Releer, encontrar el mensaje donde cambió todo, darle un significado que casi con toda seguridad nunca estuvo ahí — y luego cambiar tu comportamiento basándote en eso." },
        { "text": "Asumir que no estaba interesado.", "correct": false, "note": "Probablemente cierto e inofensivo. Es la versión con una causa pegada la que hace el daño." }
      ],
      "explain": "Un seguimiento, y luego lo dejas. Inventarte un motivo cuesta más de lo que costó la persona."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_reason", "label": "No fabricó un motivo", "description": "Aceptó que no había ninguna explicación disponible." },
      { "key": "one_follow_up", "label": "Mandó como mucho un seguimiento", "description": "No mandó el segundo." },
      { "key": "no_reread", "label": "No lo releyó", "description": "Se resistió a buscar el mensaje donde cambió todo." },
      { "key": "no_adjustment", "label": "No cambió nada por un solo dato", "description": "No reescribió su enfoque a partir de la evidencia de un silencio." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo con quien lo estás hablando",
      "mood": "Amable, sin sentimentalismo.",
      "openness": 5,
      "personality": "Pregunta qué cree la persona que pasó, y señala con suavidad cada vez que la respuesta es una teoría sobre sí misma."
    },
    "setting": "Nueve días de buena conversación, una copa acordada para el jueves, y luego cuatro días de nada. Ahora es viernes.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Señala, con suavidad, cada vez que una teoría sea sobre la persona en vez de sobre las circunstancias.",
      "Acepta no lo sé como una buena respuesta y dilo.",
      "Nunca ofrezcas una teoría propia."
    ],
    "opening_beat": "«Entonces, ¿qué crees que pasó?»",
    "success_looks_like": "La persona deja de construir una explicación y lo deja como algo desconocido."
  }$j$::jsonb,
  'Hoy, date cuenta de un silencio que te has estado explicando a ti mismo, y deja de explicarlo. Apunta la explicación que abandonaste.',
  $j${
    "says": "Entonces, ¿qué crees que pasó? Nueve días de buena conversación, una copa acordada para el jueves, y luego nada.",
    "model": {
      "line": "La verdad, no tengo ni idea, y no creo que vaya a poder averiguarlo.",
      "why": "No va a llegar ninguna explicación, y el error no es sentirse decepcionado — es ir a buscar un motivo, lo que significa inventarse uno, y el inventado siempre es sobre ti."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["demasiado insistente", "demasiado", "dije algo", "aburrido", "los eché para atrás", "culpa mía", "no debería haber", "no soy suficiente", "está claro que no"], "requirement": "No te fabriques un motivo sobre ti mismo" },
      { "kind": "min_words", "n": 8, "requirement": "Di dónde has acabado de verdad" },
      { "kind": "max_words", "n": 35, "requirement": "No necesita una teoría" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('running-the-app', 3,
  'No te enamores de la versión de texto',
  $md$Tres semanas de muy buenos mensajes con alguien a quien nunca has conocido es una experiencia real, y no es una experiencia de esa persona.

Con lo que has estado hablando es con una versión montada a partir de sus mejores fotos, sus frases editadas, y las partes de tu propia imaginación que rellenan cada hueco que dejaron. Resulta extraordinariamente atractiva, porque se le ha quitado todo lo incómodo — las pausas, el gesto que tú no habrías elegido, la cara haciendo algo corriente mientras piensan.

**La jugada:** queda pronto, antes de haber construido a alguien.

Este es el argumento práctico para el ritmo que ya recomendaba el bloque anterior, y es la mitad más importante. Unos días de mensajes producen curiosidad, que viaja bien hasta una sala. Tres semanas producen una relación con una versión inventada de esa persona, y luego llega una persona real a competir con ella — cosa que no puede hacer, porque una es persona y la otra no.

La decepción que sigue se archiva mal, y esa es la parte cara. La gente concluye que no había química, cuando lo que en realidad pasó es que ya habían tenido la buena versión y la real simplemente era distinta, no peor. Alguien perfectamente prometedor acaba descartado por no ser el personaje de tu teléfono.

También pasa en el otro sentido, y merece la pena ser justo con eso: ellos también están conociendo a alguien que no es del todo la persona que habían estado leyendo. Nadie ha sido deshonesto. El texto quita casi todo lo que es una persona y deja solo la parte que se le da bien componer por escrito.

Y explica algo que a la gente le desconcierta — una charla brillante, una cita plana. Ser bueno escribiendo es una habilidad que apenas se solapa con ser bueno en una sala, y tratar la primera como una predicción de la segunda es cómo la gente llega esperando a una persona que nunca estuvo disponible.

Si te quedas con una cosa: tres días de curiosidad ganan a tres semanas de correspondencia. Estás intentando conocer a alguien, no construir a alguien.$md$,
  $j$[
    {
      "situation": "Tres semanas de mensajes excelentes y nunca os habéis visto.",
      "line": "(has construido a alguien)",
      "why": "Sus mejores fotos, sus frases editadas, y tu propia imaginación rellenando cada hueco. Es extraordinariamente atractivo porque se le ha quitado todo lo incómodo."
    },
    {
      "situation": "La cita fue plana después de una charla brillante.",
      "line": "(distinta, no peor)",
      "why": "Ser bueno escribiendo apenas se solapa con ser bueno en una sala, y la decepción se archiva mal como que no hubo química."
    },
    {
      "situation": "Estás disfrutando de los mensajes y no tienes ninguna prisa por quedar.",
      "line": "(esa es la trampa, y es una trampa agradable)",
      "why": "Unos días producen curiosidad, que viaja hasta una sala. Tres semanas producen una versión inventada de esa persona, con la que luego tiene que competir la persona real."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Con qué has estado hablando de verdad?",
      "options": [
        { "text": "Una versión deshonesta de esa persona.", "correct": false, "note": "Nadie ha sido deshonesto. El texto simplemente quita casi todo lo que es una persona y conserva la parte que se le da bien componer." },
        { "text": "Su mejor versión.", "correct": false, "note": "Cerca, y se deja fuera tu propia contribución — que es la mitad que hace tan atractiva a esa versión inventada." },
        { "text": "Su versión editada, más tu imaginación rellenando los huecos.", "correct": true, "note": "Todo lo incómodo quitado, y cada hueco rellenado por ti. Por eso es más atractivo de lo que podría ser cualquier persona real." },
        { "text": "Alguien con quien tienes química de verdad.", "correct": false, "note": "Puede que sí. No lo puedes saber a partir de texto, que es el quid de la cuestión." }
      ],
      "explain": "Queda pronto, antes de que haya una versión inventada de esa persona contra la que la persona real tenga que perder."
    },
    {
      "prompt": "¿Por qué una charla brillante produce tan a menudo una cita plana?",
      "options": [
        { "text": "Uno de los dos estaba fingiendo.", "correct": false, "note": "Casi nunca. Los dos estaban siendo ellos mismos en un medio que muestra muy poco de cualquiera." },
        { "text": "Escribir bien y ser bueno en una sala apenas se solapan.", "correct": true, "note": "Tratar lo primero como una predicción de lo segundo es cómo la gente llega esperando a alguien que nunca estuvo disponible." },
        { "text": "Las expectativas eran demasiado altas.", "correct": false, "note": "Cierto y general. La versión concreta es más útil: son habilidades distintas." },
        { "text": "Los nervios lo arruinaron.", "correct": false, "note": "A veces, y no explica el patrón — muchas citas relajadas son planas después de una mensajería excelente." }
      ],
      "explain": "Distinta, no peor. Archivarlo como que no hubo química descarta a gente que estaba bien."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "met_early", "label": "Se movió hacia quedar pronto", "description": "No dejó que la mensajería se alargara semanas." },
      { "key": "no_construct", "label": "No construyó a nadie", "description": "Sostuvo la versión de texto con ligereza." },
      { "key": "different", "label": "Leyó una cita plana como distinta", "description": "No la archivó de inmediato como que no hubo química." },
      { "key": "fair", "label": "Se aplicó lo mismo a sí mismo", "description": "Reconoció que la otra persona también estaba conociendo a alguien nuevo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo al que se lo estás contando",
      "mood": "Divertido.",
      "openness": 5,
      "personality": "Pregunta cuánto tiempo lleva esto, y qué sabes de verdad de esa persona frente a lo que sabes de sus mensajes."
    },
    "setting": "Dos semanas y media de muy buenos mensajes con alguien a quien nunca has conocido. Ninguno de los dos ha sugerido quedar.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué sabe de la persona en vez de sobre la conversación.",
      "Alégrate ante una decisión de organizar algo esta semana.",
      "Nunca adviertas a la persona de nada directamente."
    ],
    "opening_beat": "«Dos semanas y media. ¿Los has llegado a conocer en persona?»",
    "success_looks_like": "La persona reconoce la versión inventada y se mueve hacia quedar."
  }$j$::jsonb,
  'Hoy, mira una conversación que lleve un tiempo en marcha sin ningún plan. Propón quedar. Apunta cuánto tiempo llevaba.',
  $j${
    "beats": [
      {
        "situation": "Dos semanas y media de mensajes excelentes con alguien a quien nunca has conocido.",
        "prompt": "¿Qué tienes de verdad?",
        "options": [
          { "text": "Una conexión real que merece la pena proteger.", "correct": false, "note": "Se siente exactamente como una, que es la dificultad. Está hecha de frases editadas y de tu propia imaginación rellenando cada hueco." },
          { "text": "Prueba de que os vais a llevar bien en persona.", "correct": false, "note": "Escribir bien y ser bueno en una sala apenas se solapan. Tratar uno como una predicción del otro es cómo la gente llega esperando a alguien que nunca estuvo disponible." },
          { "text": "Una versión de alguien con la que ahora va a tener que competir una persona real.", "correct": true, "note": "Todo lo incómodo quitado, todo lo que faltaba suministrado por ti. Ninguna persona real puede ganarle a eso, que es por lo que acaban descartadas como que no hubo química." },
          { "text": "Nada en absoluto hasta que os veáis.", "correct": false, "note": "Demasiado desdeñoso — tienes curiosidad, que es real y viaja bien hasta una sala. El problema son las tres semanas de eso." }
        ]
      },
      {
        "situation": "Os veis, y está bien en vez de ser electrizante.",
        "prompt": "¿Cuál es la explicación más probable?",
        "options": [
          { "text": "No hubo química.", "correct": false, "note": "El archivo estándar, y descarta a gente que era perfectamente prometedora. Además es infalsable después de una sola hora plana." },
          { "text": "No estaba siendo él mismo en línea.", "correct": false, "note": "Nadie estaba siendo deshonesto. El texto conserva la parte de una persona que se le da bien componer y pierde casi todo lo demás." },
          { "text": "Es distinto de la versión que construiste.", "correct": true, "note": "Distinto, no peor. Ya habías tenido la buena versión, y la real nunca estuvo compitiendo en igualdad de condiciones." },
          { "text": "Estabas nervioso y no fue bien.", "correct": false, "note": "A veces, y no explica el patrón — muchas citas relajadas son planas después de una mensajería excelente." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('running-the-app', 4,
  'Dale una forma',
  $md$Una aplicación sin ninguna regla pegada se va a abrir a las once de la noche, se va a deslizar durante cuarenta minutos, y se va a cerrar sintiéndote un poco peor. Eso no es un fallo de fuerza de voluntad — es para lo que está hecho el producto, y la única defensa fiable es decidir las condiciones de antemano.

**La jugada:** decide cuándo la abres, cuánto tiempo, y qué haces mientras está abierta.

**Cuándo.** Un hueco fijo, con luz de día si es posible, cuando no estás cansado. El uso nocturno es donde pasa la peor lectura: todo lo ambiguo se vuelve negativo, cada silencio se vuelve un veredicto, y la misma bandeja de entrada que a las nueve de la mañana parecería corriente a medianoche parece una prueba.

**Cuánto tiempo.** Veinte minutos, dos veces por semana, bastan para llevar esto bien. Va a sonar poco a cualquiera que ahora mismo pase cinco horas semanales en ello, que es el quid de la cuestión — la mayoría de esas cinco horas son picoteo, y el picoteo es la parte que cuesta ánimo y no produce nada.

**Qué haces.** Ten una tarea mientras estás ahí dentro en vez de curiosear: desliza a propósito durante diez minutos, luego responde a todo lo pendiente, y luego ciérrala. Curiosear sin ninguna tarea es el modo que produce la sensación de las once de la noche.

El resultado contraintuitivo, y se cumple para la mayoría: una forma produce *más*, no menos. Veinte minutos a propósito ganan a dos horas deslizando, porque la versión a propósito manda mensajes y propone días, y la versión de deslizar sobre todo mira a la gente.

Una regla más que merece la pena tener: no leer la aplicación cuando te sientes mal. El instinto es revisarla precisamente entonces, y es el único momento en que solo puede empeorar las cosas, porque un ánimo bajo lee cada ambigüedad como confirmación.

Si te quedas con una cosa: ponle un principio y un final. El producto no tiene ninguno, y nunca te lo iba a dar él.$md$,
  $j$[
    {
      "situation": "Son las once de la noche y llevas cuarenta minutos deslizando.",
      "line": "(para esto está hecho)",
      "why": "No es un fallo de fuerza de voluntad. El uso nocturno es donde todo lo ambiguo se vuelve negativo y la misma bandeja de entrada parece una prueba."
    },
    {
      "situation": "Estás pasando cinco horas semanales en ella.",
      "line": "(veinte minutos dos veces por semana, con una tarea)",
      "why": "La mayoría de esas cinco horas son picoteo, que cuesta ánimo y no produce nada. La versión a propósito manda mensajes y propone días."
    },
    {
      "situation": "Te sientes bajo de ánimo y vas a por la aplicación.",
      "line": "(el único momento en que solo puede empeorarlo)",
      "why": "Un ánimo bajo lee cada ambigüedad como confirmación. Lo que sea que haya ahí dentro va a parecer una prueba de algo que no es."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué el uso nocturno es la peor versión?",
      "options": [
        { "text": "Es más probable que mandes algo de lo que te arrepientas.", "correct": false, "note": "Pasa, y es raro. El daño está sobre todo en la lectura, no en la escritura." },
        { "text": "Todo lo ambiguo se lee como negativo.", "correct": true, "note": "La misma bandeja de entrada parece corriente a las nueve de la mañana y parece una prueba a medianoche. Nada en ella cambió." },
        { "text": "Afecta a tu sueño.", "correct": false, "note": "Cierto, y un problema distinto del que trata esta lección." },
        { "text": "Hay menos gente conectada.", "correct": false, "note": "Si acaso, hay más. El momento aquí va sobre tu estado, no sobre el suyo." }
      ],
      "explain": "Un hueco fijo, con luz de día, cuando no estás cansado."
    },
    {
      "prompt": "¿Por qué una sesión más corta y con forma produce más?",
      "options": [
        { "text": "Porque te distraes menos.", "correct": false, "note": "La atención ayuda y no es el mecanismo. Va sobre lo que haces, no sobre lo bien que lo haces." },
        { "text": "Porque la escasez te vuelve decidido.", "correct": false, "note": "Una teoría bien empaquetada. La diferencia real es más prosaica." },
        { "text": "Porque solo puedes sostenerlo veinte minutos.", "correct": false, "note": "La gente lo sostiene durante horas. Ese es el problema, no un límite." },
        { "text": "Porque el picoteo mira a la gente y una tarea manda mensajes.", "correct": true, "note": "Veinte minutos a propósito deslizan, responden y proponen días. Dos horas curioseando sobre todo miran, que cuesta ánimo y no produce nada." }
      ],
      "explain": "Ten una tarea mientras estás ahí dentro, y luego ciérrala."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "when", "label": "Fijó el cuándo", "description": "Eligió un hueco en vez de abrirla en cualquier momento." },
      { "key": "how_long", "label": "Fijó la duración", "description": "Le puso un final." },
      { "key": "a_job", "label": "Tuvo una tarea", "description": "Deslizó, respondió y propuso en vez de curiosear." },
      { "key": "not_low", "label": "No la abrió estando bajo de ánimo", "description": "La mantuvo lejos de las peores condiciones de lectura." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo con quien lo estás hablando",
      "mood": "Servicial.",
      "openness": 5,
      "personality": "Práctico con las reglas y escéptico ante los planes que no tienen ningún final. Pregunta qué haría de verdad en el tiempo dado."
    },
    "setting": "Has calculado que pasas unas cinco horas semanales en la aplicación, la mayoría después de las diez de la noche, y estás decidiendo qué hacer al respecto.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué haría de verdad en ese tiempo, si solo le dan una duración.",
      "Presiona sobre cualquier plan que no tenga ningún punto final.",
      "Nunca propongas tú un horario."
    ],
    "opening_beat": "«Cinco horas. ¿Cuál es el plan, entonces?»",
    "success_looks_like": "La persona fija un cuándo, una duración y una tarea."
  }$j$::jsonb,
  'Hoy, decide cuándo abres la aplicación, durante cuánto tiempo, y qué haces ahí dentro. Apunta las tres cosas.',
  $j${
    "says": "Cinco horas a la semana, la mayoría después de las diez de la noche. ¿Cuál es el plan, entonces?",
    "model": {
      "line": "Veinte minutos los martes y domingos por la mañana — deslizar, responder a todo, proponer algo, cerrarla.",
      "why": "Un cuándo, una duración y una tarea. La versión a propósito manda mensajes y propone días; la versión de cinco horas sobre todo mira a la gente, que cuesta ánimo y no produce nada."
    },
    "checks": [
      { "kind": "contains_any", "words": ["lunes", "martes", "miércoles", "jueves", "viernes", "sábado", "domingo", "mañana", "comida", "dos veces por semana", "fin de semana"], "requirement": "Di qué días la abres" },
      { "kind": "contains_any", "words": ["minutos", "veinte", "quince", "media hora", "diez"], "requirement": "Di cuánto tiempo" },
      { "kind": "forbids_any", "words": ["cuando sea", "cuando me apetezca", "mientras", "a ver cómo va", "reducir", "menos", "intentar"], "requirement": "Sin curioseo abierto" },
      { "kind": "min_words", "n": 10, "requirement": "Di qué haces mientras estás ahí dentro" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('running-the-app', 5,
  'Bórrala durante un mes',
  $md$Esto es permiso, no técnica, y para mucha gente es lo más útil de todo el bloque.

**La jugada:** tómate un mes libre, a propósito, sin decidir qué significa.

La versión que no funciona es dejarlo asqueado después de una mala semana, que es un estado de ánimo y no una decisión, y normalmente termina con la aplicación reinstalada un miércoles. La versión que funciona es decidir de antemano que te vas a tomar un mes libre y poner en el calendario la fecha en la que lo reconsiderarás. La misma ausencia, una experiencia completamente distinta, porque una es una elección y la otra es una derrota.

Para qué sirve: estas aplicaciones producen un zumbido bajo y continuo de evaluación, y mantener eso durante meses sin un descanso tiene un coste invisible mientras lo estás pagando y obvio en el momento en que paras. Casi todo el mundo que se toma un mes libre cuenta lo mismo, que no se había dado cuenta de cuánto de eso estaba cargando.

Además hace algo práctico. Un mes fuera redirige el esfuerzo hacia los canales en los que se centran la mayoría de los otros temas de esta aplicación — salas que se repiten, gente a la que ya conoces, el amigo de un amigo en el plan del sábado. Esos son más lentos y no están sujetos a tasas base que se sienten como un juicio.

Y merece la pena decir sin rodeos que para algunas personas estas aplicaciones son sencillamente un mal camino, y eso no es un fallo de nervio ni de cómo escribes tu perfil. Si seis meses haciendo esto bien han producido muy poco y han costado mucho, la conclusión honesta no es *esfuérzate más* — es que este canal en concreto te sienta mal, que es corriente y cierto para mucha gente que se le da perfectamente bien conocer a alguien en una sala.

Vuelve si quieres, y vuelve con la forma de la última lección ya puesta en marcha, en vez de con acceso sin límites.

Si te quedas con una cosa: un descanso que elegiste no es lo mismo que rendirse, y es la única forma fiable de averiguar lo que te estaba costando la aplicación.$md$,
  $j$[
    {
      "situation": "Has tenido una mala semana y estás a punto de borrarla asqueado.",
      "line": "(decide un mes, y ponle fecha)",
      "why": "La misma ausencia, una experiencia distinta. Una es una elección y la otra es una derrota que termina con la aplicación reinstalada un miércoles."
    },
    {
      "situation": "Llevas un mes y no te habías dado cuenta de lo mucho más ligero que se siente.",
      "line": "(eso es lo que estaba costando)",
      "why": "El zumbido de la evaluación continua es invisible mientras lo estás pagando y obvio en el momento en que paras."
    },
    {
      "situation": "Seis meses haciéndolo bien han producido muy poco.",
      "line": "(puede que este canal te siente mal)",
      "why": "No es un fallo de nervio ni de cómo escribes tu perfil. Es cierto para mucha gente a la que se le da perfectamente bien conocer a alguien en una sala."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué separa un descanso de rendirse?",
      "options": [
        { "text": "Cuánto dura.", "correct": false, "note": "No es eso. Dos semanas decididas a propósito ganan a seis meses enfadado." },
        { "text": "Si borraste la cuenta o solo la aplicación.", "correct": false, "note": "Un detalle mecánico. La diferencia está en la decisión, no en el dato." },
        { "text": "Decidirlo de antemano, con una fecha para reconsiderarlo.", "correct": true, "note": "La misma ausencia, una experiencia completamente distinta — una es una elección y la otra es una derrota que tiende a terminar con la reinstalación un miércoles." },
        { "text": "Si se lo cuentas a alguien.", "correct": false, "note": "No cambia nada de lo que hace por ti." }
      ],
      "explain": "Un descanso que elegiste es la única forma fiable de averiguar lo que te estaba costando."
    },
    {
      "prompt": "Seis meses haciéndolo bien han producido casi nada. ¿Cuál es la conclusión honesta?",
      "options": [
        { "text": "Tu perfil todavía necesita trabajo.", "correct": false, "note": "Posible, y el siguiente bloque es cómo averiguarlo. Si el embudo dice lo contrario, esta no es la respuesta." },
        { "text": "Necesitas esforzarte más.", "correct": false, "note": "La conclusión a la que llega la gente y la que más cuesta. El esfuerzo no era el ingrediente que faltaba." },
        { "text": "Puede que este canal te siente mal.", "correct": true, "note": "Corriente, y cierto para mucha gente a la que se le da perfectamente bien conocer a alguien en una sala. No es un fallo de nervio." },
        { "text": "Nadie está interesado en ti.", "correct": false, "note": "Una conclusión sobre tu valía sacada de un canal con una forma muy particular, que es la mala lectura que existe todo este bloque para evitar." }
      ],
      "explain": "Un camino entre varios, y esta aplicación dedica la mayoría de sus otros temas al resto."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "chose_it", "label": "Eligió el descanso", "description": "Lo decidió de antemano en vez de dejarlo por un estado de ánimo." },
      { "key": "a_date", "label": "Le puso una fecha", "description": "Nombró cuándo lo reconsideraría." },
      { "key": "redirected", "label": "Redirigió el esfuerzo", "description": "Lo puso en salas y gente en vez de en nada." },
      { "key": "honest", "label": "Se permitió la conclusión honesta", "description": "Aceptó que puede que este canal no sea el suyo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo con quien estás hablando",
      "mood": "Sereno.",
      "openness": 5,
      "personality": "Distingue entre dejarlo por un estado de ánimo y tomarse un descanso decidido, y pregunta qué harías con el tiempo."
    },
    "setting": "Dos semanas malas. Has abierto y cerrado la aplicación unas treinta veces y estás pensando en borrarla.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta para qué es el descanso y cuándo lo reconsiderarían.",
      "Tómate en serio la posibilidad de que la aplicación les siente mal.",
      "Nunca le digas a la persona que se quede en ella o que la deje."
    ],
    "opening_beat": "«¿La estás borrando porque lo has decidido, o por esta semana?»",
    "success_looks_like": "La persona se toma un descanso decidido con fecha en vez de dejarlo por un estado de ánimo."
  }$j$::jsonb,
  'Hoy, decide si te vas a tomar un mes libre y pon la fecha de reconsideración en tu calendario. Apunta la decisión, sea cual sea.',
  $j${
    "says": "¿La estás borrando porque lo has decidido, o por esta semana?",
    "model": {
      "line": "Porque lo he decidido. Un mes libre, y lo voy a reconsiderar el uno del mes que viene.",
      "why": "Una decisión con fecha en vez de un estado de ánimo con un botón de borrar. La misma ausencia, una experiencia completamente distinta — y la versión con fecha no termina con reinstalarla un miércoles."
    },
    "checks": [
      { "kind": "contains_any", "words": ["mes", "semanas", "el uno de", "hasta", "enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre", "reconsiderar"], "requirement": "Ponle una fecha o una duración" },
      { "kind": "forbids_any", "words": ["harto", "hasta las narices", "pérdida de tiempo", "la odio", "nunca más", "se acabó"], "requirement": "Una decisión, no un estado de ánimo" },
      { "kind": "min_words", "n": 8, "requirement": "Di qué has decidido" }
    ]
  }$j$::jsonb
);
