-- Spanish: El trabajo, track 8 — El pasillo. Last of the topic.
--
-- Conventions as migration 121. Notes:
--
-- **"Meeting someone" is referenced in lesson 3's theory** as the topic where
-- the reader first met the clock mechanism — translated as "Conocer a
-- alguien", matching that topic's Spanish name from the surface migration.
--
-- **The jargon ban in lesson 2 lost "vertical" and "stakeholder" as literal
-- loanwords** and gained their Spanish equivalents instead: "parte
-- interesada", "área vertical", "de principio a fin" — the actual corporate
-- jargon a Spanish speaker reaches for, not a transliteration of the English
-- list.
--
-- **check kind "no_question" (lesson 3) has no Spanish-specific issue** — it
-- bans the model line from being a question, which the Spanish "Este
-- ascensor está teniendo un día" satisfies the same way the English does.

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

select pg_temp.es_lesson('the-corridor', 1,
  'El objetivo es que te reconozcan',
  $md$La charla del trabajo se parece exactamente a la charla corriente y está jugando a algo distinto, que es por lo que gente perfectamente hábil en fiestas puede ser desdichada en congresos.

La charla corriente ha triunfado si los dos minutos fueron agradables. Eso es todo, y por eso se puede disfrutar por sí misma.

Esta ha triunfado si te reconocen la próxima vez.

**La jugada:** apunta a ser una persona con un nombre y un dato memorable. Nada más.

Ese objetivo es muchísimo más bajo del que se pone la gente, y ponerlo bien cambia todo lo que se siente en la conversación. No estás intentando impresionar a nadie. No estás intentando encontrar una oportunidad, sacar un contacto, o resultar interesante. Estás intentando que la *segunda* conversación empiece con calidez, y una segunda conversación que empieza con calidez es donde ocurre de verdad todo lo útil.

Casi todo el consejo sobre hacer contactos falla con la gente callada porque optimiza para la primera conversación: sé memorable, ten un discurso, trabaja la sala. Todo eso es agotador, visiblemente esforzado, y apuntado a lo que menos importa. Dos minutos corrientes con alguien que te reconocerá en junio ganan a veinte impresionantes con alguien que no lo hará.

Además significa que a casi todas estas conversaciones se les permite ser olvidables, lo cual es un alivio. No necesitas tener una buena con todo el mundo. Necesitas tres o cuatro personas en un día que te saluden con la cabeza la próxima vez, y saludar con la cabeza es un listón muy bajo que se acumula enormemente a lo largo de unos años.

Si te quedas con una cosa: reconocible, no impresionante. Impresionante es un objetivo mucho más difícil que nadie te estaba pidiendo alcanzar.$md$,
  $j$[
    {
      "situation": "Estás en un congreso y le tienes pavor a la pausa del café.",
      "line": "(el objetivo es reconocible, no impresionante)",
      "why": "Estás intentando ser una persona con un nombre y un dato memorable, para que la segunda conversación empiece con calidez. Ese es el objetivo entero."
    },
    {
      "situation": "La conversación fue agradable y del todo anodina.",
      "line": "(eso ha funcionado)",
      "why": "A casi todas estas se les permite ser olvidables. Tres o cuatro personas en un día que te saluden la próxima vez es un buen día."
    },
    {
      "situation": "Estás planeando qué decir para sonar impresionante.",
      "line": "(nadie te ha pedido que seas impresionante)",
      "why": "Es agotador, visiblemente esforzado, y apuntado a la primera conversación, que no es donde pasa nada útil."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿En qué se diferencia la charla del trabajo de la charla corriente?",
      "options": [
        { "text": "Es más formal.", "correct": false, "note": "Con frecuencia es menos. El registro no es la diferencia." },
        { "text": "Triunfa si te reconocen la próxima vez.", "correct": true, "note": "La charla corriente triunfa si los dos minutos fueron agradables. Esta apunta a la segunda conversación, que es donde pasa lo útil." },
        { "text": "Necesitas algo que decir sobre tu trabajo.", "correct": false, "note": "Lo necesitas, y eso es una consecuencia del objetivo y no el objetivo." },
        { "text": "Lo que está en juego es más alto.", "correct": false, "note": "Es más bajo por conversación de lo que cree la gente, que es el sentido de nombrar bien el objetivo." }
      ],
      "explain": "Reconocible, no impresionante. Un listón mucho más bajo y mucho mejor."
    },
    {
      "prompt": "¿Por qué falla casi todo el consejo sobre hacer contactos con alguien callado?",
      "options": [
        { "text": "Da por hecho que lo disfrutas.", "correct": false, "note": "Alguno sí, y disfrutarlo no es lo que determina si el método funciona." },
        { "text": "Está pensado para extrovertidos.", "correct": false, "note": "Una etiqueta más que un mecanismo, y no te dice qué hacer en su lugar." },
        { "text": "Optimiza para la primera conversación.", "correct": true, "note": "Sé memorable, ten un discurso, trabaja la sala. Todo agotador, todo visiblemente esforzado, y todo apuntado a la conversación que menos importa." },
        { "text": "Exige demasiadas conversaciones.", "correct": false, "note": "El volumen es un coste real y viene después. Tres o cuatro al día sobran cuando el objetivo es el correcto." }
      ],
      "explain": "Dos minutos corrientes con alguien que te reconoce en junio ganan a veinte impresionantes con alguien que no."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "target", "label": "Apuntó a ser reconocible", "description": "Fue por un nombre y un dato en vez de por impacto." },
      { "key": "ordinary", "label": "Dejó que fuera corriente", "description": "Permitió que una conversación olvidable estuviera bien." },
      { "key": "no_pitch", "label": "No actuó", "description": "Evitó el esfuerzo visible por impresionar." },
      { "key": "enough", "label": "Supo cuándo había funcionado", "description": "Lo juzgó por si una segunda conversación empezaría con calidez." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Theo",
      "role": "alguien más de pie cerca del café",
      "mood": "También le resulta esto un poco incómodo.",
      "openness": 4,
      "personality": "Corriente, algo aliviado de estar hablando con alguien. Responde con calidez a la charla corriente y se tensa ante cualquier cosa que suene a discurso."
    },
    "setting": "La primera pausa de café en un congreso de dos días. No conoces a nadie y hay unas ochenta personas en la sala.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con calidez a la charla corriente sobre la sala, el día o las ponencias.",
      "Enfríate de forma perceptible ante cualquier cosa que suene a discurso o a jugada de hacer contactos.",
      "Nunca preguntes primero a qué se dedica la persona."
    ],
    "opening_beat": "«¿Este es el café bueno o el otro? Ya no sé distinguirlo.»",
    "success_looks_like": "La persona tiene una conversación corriente de dos minutos e intercambia nombres."
  }$j$::jsonb,
  'Hoy, ten una conversación deliberadamente corriente con alguien del trabajo con quien no sueles hablar. Apunta con quién.',
  $j${
    "beats": [
      {
        "situation": "Primera pausa de café en un congreso de dos días. Ochenta personas, no conoces a ninguna.",
        "prompt": "¿Qué estás intentando conseguir hoy de verdad?",
        "options": [
          { "text": "Conocer a la mayor cantidad de gente posible.", "correct": false, "note": "Volumen por el volumen, y produce cuarenta conversaciones que nadie recuerda, tú incluido." },
          { "text": "Ser una persona a la que tres o cuatro reconocerían la próxima vez.", "correct": true, "note": "La segunda conversación es donde pasa lo útil, y solo existe si la primera te hizo reconocible." },
          { "text": "Encontrar un contacto genuinamente útil.", "correct": false, "note": "Apuntar a la utilidad es lo que hace que las conversaciones se sientan transaccionales, y se nota al instante." },
          { "text": "Tener al menos una conversación muy buena.", "correct": false, "note": "Agradable si pasa. Ponerlo como objetivo hace que cada intercambio corriente se sienta un fracaso." }
        ]
      },
      {
        "situation": "Acabas de tener dos minutos sobre el café y el sitio con alguien. No se ha dicho nada memorable.",
        "prompt": "¿Qué tal ha ido eso?",
        "options": [
          { "text": "Mal: no tenías nada interesante que decir.", "correct": false, "note": "Interesante no era el objetivo, y esta lectura es lo que hace que la gente le tema a la siguiente pausa." },
          { "text": "Neutro: no ha pasado nada.", "correct": false, "note": "Algo sí pasó: intercambiasteis nombres y fuisteis agradables, que es de lo que se hace lo reconocible." },
          { "text": "Bien: a casi todas estas se les permite ser olvidables.", "correct": true, "note": "Tres o cuatro personas en un día que te saluden la próxima vez es un buen día, y saludar se acumula enormemente en unos años." },
          { "text": "Desperdiciado: deberías haber hablado de trabajo.", "correct": false, "note": "El trabajo sale solo. Dirigirlo ahí para justificar la conversación es lo que la hace sentir a hacer contactos." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-corridor', 2,
  'La versión de treinta segundos',
  $md$*Y tú, ¿a qué te dedicas?* es la pregunta más predecible de la vida profesional, y casi todo el mundo la responde con un cargo, lo que produce un asentimiento y luego un silencio que los dos tenéis que sobrevivir.

Un cargo es una categoría, no un gancho. *Soy analista de datos* le dice a alguien dónde archivarte y no le da nada que preguntar, así que la conversación pasa a depender de la inventiva de esa persona en vez de de algo que le hayas dado tú.

**La jugada:** di eso en lo que trabajas de verdad, en una frase a la que un desconocido le pueda hacer una pregunta.

*Averiguo por qué la gente deja de usar las cosas a medias* es el mismo trabajo descrito de forma que tenga un asa. Cualquiera puede agarrarse a eso. *Cuido de los sistemas que nos dicen si estamos a punto de quedarnos sin existencias* igual.

Ya te has encontrado este principio si has hecho el tema de las apps de citas: escribe cosas a las que se pueda contestar. Es exactamente el mismo mecanismo de pie en un pasillo, y merece la pena notar que es un problema de escritura y no uno social: puedes decidir esta frase de antemano, en tu mesa, sin que te mire nadie, y usarla durante un año.

Dos notas prácticas. Deja fuera la jerga, incluidas las palabras que a ti te suenan neutras: todo sector tiene un centenar y convierten un gancho de vuelta en una categoría. Y no empieces por la empresa a menos que la empresa sea la parte interesante; *trabajo en Meridian* invita a un *ah, vale* y nada más.

Y luego para. Treinta segundos es todo. El fallo más común después de por fin decir algo interesante es seguir dos minutos más, lo que convierte un gancho en un monólogo y le enseña a alguien a no preguntar.

Si te quedas con una cosa: escribe la frase antes de necesitarla. Es la preparación menos social que existe y hace más que ninguna otra cosa de este tema.$md$,
  $j$[
    {
      "situation": "«Y tú, ¿a qué te dedicas?»",
      "line": "Averiguo por qué la gente deja de usar las cosas a medias.",
      "why": "El mismo trabajo que analista de datos, descrito de forma que cualquiera pueda agarrarse. Un cargo es una categoría; esto tiene un asa."
    },
    {
      "situation": "Estás a punto de decir tu cargo.",
      "line": "(eso consigue un asentimiento y un silencio)",
      "why": "Le dice a alguien dónde archivarte y no le da nada que preguntar, así que la conversación pasa a depender de su inventiva."
    },
    {
      "situation": "Has dicho la buena frase y parecían interesados.",
      "line": "(ahora para)",
      "why": "Treinta segundos es todo. Seguir convierte un gancho en un monólogo y le enseña a alguien a no preguntar."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué tiene de malo un cargo?",
      "options": [
        { "text": "Es aburrido.", "correct": false, "note": "Un montón de respuestas aburridas funcionan. El problema es estructural, no estético." },
        { "text": "La gente no lo entiende.", "correct": false, "note": "A veces, y un cargo perfectamente entendido produce el mismo asentimiento y el mismo silencio." },
        { "text": "Es una categoría, así que no hay nada que preguntar.", "correct": true, "note": "Le dice a alguien dónde archivarte. La conversación pasa a depender de su inventiva en vez de de algo que le diste tú." },
        { "text": "Suena a que estás fanfarroneando.", "correct": false, "note": "Rara vez. Los cargos son lo más seguro y menos interesante que dice nadie." }
      ],
      "explain": "Di eso en lo que trabajas, en una frase a la que un desconocido le pueda hacer una pregunta."
    },
    {
      "prompt": "¿Dónde se hace esta frase?",
      "options": [
        { "text": "En el momento: debería sonar natural.", "correct": false, "note": "En el momento vas a decir tu cargo, porque es lo que sale bajo una presión leve." },
        { "text": "En tu mesa, de antemano, una vez.", "correct": true, "note": "Es un problema de escritura y no uno social. Decídela sin que te mire nadie, y úsala durante un año." },
        { "text": "Debería cambiar según quién pregunte.", "correct": false, "note": "Bonito en la teoría, y por eso casi nadie se decide por una. Ten primero una buena frase." },
        { "text": "De cómo describe tu empresa el puesto.", "correct": false, "note": "Eso es la categoría con más jerga encima, y la jerga convierte un gancho de vuelta en una etiqueta de archivo." }
      ],
      "explain": "La preparación menos social que existe, y hace más que ninguna otra cosa de este tema."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "not_a_title", "label": "No empezó por un cargo", "description": "Describió el trabajo en vez de la categoría." },
      { "key": "askable", "label": "Dejó algo que preguntar", "description": "Lo dijo de forma que un desconocido pudiera agarrarse." },
      { "key": "plain", "label": "Sin jerga", "description": "Usó palabras que cualquiera entendería." },
      { "key": "stopped", "label": "Paró a los treinta segundos", "description": "No convirtió el gancho en un monólogo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Theo",
      "role": "alguien con quien has estado hablando en el congreso",
      "mood": "Interesado, sin agenda.",
      "openness": 4,
      "personality": "Curioso y fácil de enganchar con cualquier cosa concreta. Responde a un cargo con un asentimiento y un cambio de tema."
    },
    "setting": "Dos minutos dentro de una conversación de pasillo en el congreso. Acaban de preguntarte a qué te dedicas.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a un cargo con un asentimiento y un cambio de tema.",
      "Haz una repregunta de verdad sobre cualquier cosa concreta y sin jerga.",
      "Nunca vuelvas a preguntar a qué se dedica la persona."
    ],
    "opening_beat": "«¿Y a qué te dedicas exactamente?»",
    "success_looks_like": "La persona describe el trabajo en una frase que se puede preguntar."
  }$j$::jsonb,
  'Hoy, escribe tu versión de treinta segundos y dísela a una persona en vez de tu cargo. Apunta la frase.',
  $j${
    "says": "¿Y a qué te dedicas exactamente?",
    "model": {
      "line": "Averiguo por qué la gente deja de usar las cosas a medias.",
      "why": "El mismo trabajo que el cargo, descrito para que un desconocido pueda agarrarse. Un cargo le dice a alguien dónde archivarte; esto le da algo que preguntar."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Describe el trabajo que haces de verdad" },
      { "kind": "forbids_any", "words": ["soy", "sénior", "gerente de", "analista", "consultor", "consultora", "ingeniero en", "ingeniera en", "parte interesada", "área vertical", "de principio a fin", "flujo de trabajo"], "requirement": "No un cargo, y sin jerga" },
      { "kind": "max_words", "n": 25, "requirement": "Una frase: treinta segundos, y para" },
      { "kind": "max_sentences", "n": 2, "requirement": "No conviertas el gancho en un monólogo" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-corridor', 3,
  'Ascensores, colas y cocinas',
  $md$Estos son los intentos gratis y casi nadie los usa, lo cual es un desperdicio de las salas más fáciles de la vida profesional.

Ya te encontraste el mecanismo en Conocer a alguien: una situación que tiene un reloj dentro termina la conversación por ti. Llega un ascensor. Se mueve la cola. Hierve el agua. No hay salida que negociar, ningún riesgo de quedarte atrapado, y ningún después que temer, lo que elimina el motivo más grande de que la gente no diga nada.

**La jugada:** di lo obvio sobre la situación en la que estáis los dos, y deja que el reloj la termine.

*Este ascensor está teniendo un día.* *¿Esa es la máquina que se come tazas?* *Nunca en mi vida he abierto esta puerta a la primera.* Nada de esto es ingenioso y no pretende serlo. Es una oferta de treinta segundos, y treinta segundos son genuinamente suficientes: reconocible es el objetivo, y ser la persona que dice algo corriente en el ascensor es exactamente de lo que se hace lo reconocible.

La versión con alguien sénior merece su propia nota, porque es donde está el mayor valor por el menor esfuerzo. Casi todo lo que oye una persona sénior en un pasillo es una petición. Dos minutos de conversación corriente sin nada que pedir dentro es lo bastante inusual como para recordarse, y no te cuesta nada salvo el valor de hablar del café.

Lo que significa que la única regla para el ascensor con el jefe dentro es: no hagas ningún discurso. Ni de tu proyecto, ni de tu caso, ni un «ya que te tengo aquí, una cosa rápida». Convierte una interacción gratis en una transacción, y es lo que hace todo el mundo.

Y deja que termine cuando termine la situación. No la sigas fuera, no la alargues en la puerta. Que el reloj la termine limpiamente es lo que hace que no cueste nada, y es lo que hace fácil la siguiente.

Si te quedas con una cosa: di lo obvio. El reloj hará el resto, y habrás sido una persona en vez de una compañera a la que no consiguen ubicar.$md$,
  $j$[
    {
      "situation": "Estás en el ascensor con alguien dos niveles por encima de ti.",
      "line": "Este ascensor está teniendo un día.",
      "why": "Corriente, sin ingenio, y sin nada que pedir dentro, lo bastante inusual en un pasillo como para recordarse. El reloj lo termina por ti."
    },
    {
      "situation": "Tienes treinta segundos con alguien sénior y un proyecto para el que quieres apoyo.",
      "line": "(no hagas ningún discurso)",
      "why": "Convierte una interacción gratis en una transacción, y es lo que hace todo el mundo. El valor aquí está en no hacerlo."
    },
    {
      "situation": "Llega el ascensor y estás a mitad de frase.",
      "line": "(déjalo terminar)",
      "why": "Que el reloj lo termine limpiamente es lo que hace que no cueste nada y lo que hace fácil el siguiente."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué los ascensores y las colas son las salas más fáciles?",
      "options": [
        { "text": "La gente está aburrida y quiere hablar.", "correct": false, "note": "Algunas veces sí, otras no, y la ventaja se sostiene de todos modos." },
        { "text": "La situación la termina por ti.", "correct": true, "note": "Ninguna salida que negociar, ningún riesgo de quedar atrapado, ningún después que temer, lo que elimina el motivo más grande de que la gente no diga nada." },
        { "text": "Nadie recuerda lo que se dijo.", "correct": false, "note": "Te recuerdan a ti, que es todo el sentido de hacerlo." },
        { "text": "Son lo bastante cortas como para no importar.", "correct": false, "note": "Importan mucho, acumulativamente. La brevedad es lo que las hace baratas, no lo que las hace poco importantes." }
      ],
      "explain": "Di lo obvio. El reloj hace el resto."
    },
    {
      "prompt": "Treinta segundos en un ascensor con alguien sénior. ¿Cuál es la regla?",
      "options": [
        { "text": "Ten algo interesante preparado.", "correct": false, "note": "Lo interesante preparado se nota, y convierte un momento corriente en una actuación." },
        { "text": "Preséntate como es debido.", "correct": false, "note": "Bien, y no es lo que determina si esto funciona." },
        { "text": "Aprovéchalo: puede que no tengas otra ocasión.", "correct": false, "note": "Este es el instinto que produce el discurso, y gasta la interacción en su uso menos valioso." },
        { "text": "No hagas ningún discurso.", "correct": true, "note": "Casi todo lo que oye en un pasillo es una petición. Dos minutos corrientes sin nada que pedir es lo bastante inusual como para recordarse." }
      ],
      "explain": "El valor está en ser una persona en vez de una agenda."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_something", "label": "Dijo lo obvio", "description": "Abrió en vez de esperar a que pasara." },
      { "key": "no_pitch", "label": "No hizo ningún discurso", "description": "Mantuvo cualquier petición completamente fuera." },
      { "key": "ordinary", "label": "Lo mantuvo corriente", "description": "No buscó algo impresionante." },
      { "key": "let_it_end", "label": "Dejó que el reloj la terminara", "description": "No la alargó más allá de la situación." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nadine",
      "role": "la jefa de tu jefe",
      "mood": "Entre reuniones.",
      "openness": 4,
      "personality": "Cálida con la charla corriente y visiblemente en guardia cada vez que alguien empieza una frase con «ya que te tengo». Se acuerda de la gente que no quería nada."
    },
    "setting": "El ascensor, subiendo. La jefa de tu jefe entra después de ti. Seis pisos.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con calidez y sin esfuerzo a la charla corriente.",
      "Ponte educada y cerrada ante cualquier cosa que se convierta en una petición o una actualización de proyecto.",
      "Sal en el sexto piso independientemente de dónde haya llegado la conversación."
    ],
    "opening_beat": "Se cierran las puertas. Seis pisos. Ella levanta la vista y sonríe a medias.",
    "success_looks_like": "La persona dice algo corriente y no pide nada."
  }$j$::jsonb,
  'Hoy, di lo obvio en un ascensor, una cola o una cocina. Apunta qué dijiste y a quién.',
  $j${
    "says": "Se cierran las puertas del ascensor. Seis pisos. La jefa de tu jefe levanta la vista y sonríe a medias.",
    "model": {
      "line": "Este ascensor está teniendo un día.",
      "why": "Corriente, sin ingenio, y sin nada que pedir dentro, lo bastante inusual en un pasillo como para recordarse. El reloj lo termina por ti, así que no cuesta nada."
    },
    "checks": [
      { "kind": "no_question", "requirement": "Una oferta, no un interrogatorio" },
      { "kind": "forbids_any", "words": ["ya que te tengo", "una cosa rápida", "quería preguntarte", "aprovecho para", "proyecto", "ponerte al día", "qué opinas de", "oportunidad", "retomarlo"], "requirement": "Sin discurso: ni petición, ni actualización" },
      { "kind": "max_words", "n": 20, "requirement": "Treinta segundos de algo corriente" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-corridor', 4,
  'La sala sin reloj',
  $md$Un pasillo de congreso es la versión difícil, y es difícil por exactamente un motivo: nada la termina. No llega ningún ascensor, no se mueve ninguna cola, y no se acaba ninguna tarea compartida. Dos personas que ya han terminado lo que tenían que decirse están ahí de pie, las dos esperando a que la otra lo resuelva.

Eso es lo que la gente teme de verdad cuando dice que odia hacer contactos. No el empezar: el no poder parar.

**La jugada:** planta la salida pronto, de pasada, antes de necesitarla.

*Voy a coger el de las once y media, pero* — dicho en el primer minuto, como contexto corriente — cambia todo lo que viene después. A los dos os han dicho que esto tiene una forma, así que ninguno está atrapado, y puedes relajarte en vez de vigilar un hueco.

La vas a usar más o menos un tercio de las veces. Tenerla es lo que hace el trabajo, porque elimina aquello contra lo que te estabas preparando, y la gente nota cuándo alguien no se está preparando.

Y luego vete limpio y con calidez. *Voy a ir a buscar esa ponencia; encantado de conocerte, Theo.* Usa su nombre, dilo en serio, y vete. Sin recado inventado, sin irte a la deriva a mitad de tema, y sobre todo sin disculpa: irse de una conversación no es algo que necesite perdón, y tratarlo como si lo necesitara hace que los últimos treinta segundos sean incómodos para los dos.

Que te dejen a ti también está bien, y merece la pena decirlo porque la gente callada se lo toma como algo personal. Alguien que se va con calidez después de cuatro minutos tuvo cuatro buenos minutos contigo. De eso están hechos estos.

Y una puerta de vuelta, para cuando la quieras: *¿andas por aquí mañana?* no cuesta nada, no necesita respuesta, y convierte una primera conversación en una probable segunda, que era el objetivo entero.

Si te quedas con una cosa: planta la salida en el primer minuto. Casi nunca la vas a usar, y es lo que te deja disfrutar la conversación.$md$,
  $j$[
    {
      "situation": "Acabas de empezar a hablar con alguien en un congreso.",
      "line": "Voy a coger el de las once y media, pero — ¿qué tal lo estás encontrando?",
      "why": "Plantada en el primer minuto como contexto corriente. Los dos sabéis ya que esto tiene una forma, así que ninguno está atrapado, y la gente nota cuándo alguien no se está preparando."
    },
    {
      "situation": "La conversación se ha quedado sin más y los dos estáis ahí de pie.",
      "line": "Voy a ir a buscar esa ponencia; encantado de conocerte, Theo.",
      "why": "Cálido, con nombre, limpio. Sin recado inventado y sin disculpa, porque irse de una conversación no necesita perdón."
    },
    {
      "situation": "Se han ido después de cuatro minutos y te preguntas qué salió mal.",
      "line": "(tuvieron cuatro buenos minutos contigo)",
      "why": "De eso están hechos estos. Que te dejen con calidez no es un veredicto sobre la conversación."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hace difícil de verdad un pasillo de congreso?",
      "options": [
        { "text": "No conoces a nadie.", "correct": false, "note": "Nadie conoce a nadie, y es igual para todos en la sala, lo que hace más fácil empezar y no más difícil." },
        { "text": "Nada termina la conversación.", "correct": true, "note": "Ningún ascensor, ninguna cola, ninguna tarea compartida acabándose. Dos personas que ya han terminado están ahí esperando a que la otra lo resuelva: eso es lo que se teme." },
        { "text": "Todo el mundo es más sénior que tú.", "correct": false, "note": "Casi nunca es cierto, y no es contra lo que se está preparando la gente de verdad." },
        { "text": "Tienes que sonar impresionante.", "correct": false, "note": "No tienes que hacerlo, y creer que sí es otro problema que trata la primera lección." }
      ],
      "explain": "No es el empezar. Es el no poder parar."
    },
    {
      "prompt": "¿Cómo te vas?",
      "options": [
        { "text": "Con calidez, con su nombre, y sin disculpa.", "correct": true, "note": "Irse de una conversación no necesita perdón, y tratarlo como si lo necesitara hace incómodos los últimos treinta segundos para los dos." },
        { "text": "Con un motivo, para que no parezca brusco.", "correct": false, "note": "Una salida plantada ya dio uno. Un recado inventado al final se nota." },
        { "text": "Presentándole a otra persona primero.", "correct": false, "note": "Generoso cuando pasa de forma natural, y una maniobra elaborada para evitar una despedida sencilla." },
        { "text": "Dejando que se vaya apagando.", "correct": false, "note": "El apagarse es la versión que peor se siente para quien queda atrás." }
      ],
      "explain": "Planta la salida pronto, úsala con calidez, y no te disculpes por ello."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "planted", "label": "Plantó una salida pronto", "description": "Mencionó una forma en el primer minuto." },
      { "key": "warm_exit", "label": "Se fue con calidez", "description": "Usó su nombre y lo dijo en serio." },
      { "key": "no_apology", "label": "No se disculpó por irse", "description": "Lo trató como algo corriente." },
      { "key": "door_back", "label": "Dejó una puerta abierta", "description": "Hizo probable una segunda conversación si merecía la pena." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Theo",
      "role": "alguien que conociste esta mañana en el congreso",
      "mood": "Lo ha disfrutado, sin temas.",
      "openness": 4,
      "personality": "Agradable e igual de incapaz de terminar una conversación. Se queda ahí indefinidamente y se alivia visiblemente cuando alguien la cierra con calidez."
    },
    "setting": "El descanso largo de la tarde en el congreso. Llevas unos seis minutos hablando con Theo y se ha quedado sin sitios adonde ir.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Nunca termines tú la conversación: quédate ahí indefinidamente.",
      "Responde con calidez y con alivio a un cierre limpio y amable.",
      "Ponte algo incómodo si la persona se disculpa por irse o se inventa un recado."
    ],
    "opening_beat": "«...sí. No, exacto.» Una pausa. A ninguno de los dos os queda nada.",
    "success_looks_like": "La persona cierra la conversación con calidez y limpieza."
  }$j$::jsonb,
  'Hoy, planta una salida en el primer minuto de una conversación, y luego vete con calidez cuando se acabe. Apunta las dos cosas.',
  NULL
);

select pg_temp.es_lesson('the-corridor', 5,
  'Las dos líneas de después',
  $md$Casi nadie hace esto, que es exactamente por lo que funciona.

**La jugada:** manda dos líneas el mismo día, haciendo referencia a lo que hablasteis de verdad.

*Encantado de conocerte en lo del café — tenías razón con la sesión de precios, fue la mejor. Si alguna vez pasas por la oficina de Madrid, saluda.* Ese es el mensaje entero. Cuesta noventa segundos y convierte a alguien que te recuerda a medias en alguien que sabe quién eres.

Lo del mismo día importa por el mismo motivo que en todas partes: estás conservando algo. Ese día, eres una persona con la que estaban hablando. Diez días después eres un nombre y una empresa, y el mensaje ahora tiene que volver a presentarte antes de poder hacer nada.

Haz referencia a la cosa concreta. *Un placer conectar* es una plantilla y se lee como una: podría habérsele mandado a cuarenta personas porque se lo mandaron. Un detalle de la conversación real demuestra que fue esa conversación, y es toda la diferencia entre un mensaje que recibe respuesta y uno que recibe una nada educada.

No pidas nada. Esta es la parte que la gente no puede resistir y es lo que lo arruina: un mensaje de seguimiento que lleva una petición convierte dos minutos agradables en el movimiento de apertura de una transacción, y todo el mundo lo nota. El mensaje ya ha hecho su trabajo con existir.

Deja una puerta abierta y que no cueste nada. *Si alguna vez pasas por la oficina de Madrid* no necesita respuesta y se puede coger dentro de un año.

Y luego no hagas nada más. No hay secuencia, no hay seguimiento del seguimiento, ningún empujoncito educado dentro de tres semanas. Te has hecho reconocible, que era el objetivo, y ser reconocible rinde en una escala de años y no de semanas.

Si te quedas con una cosa: el mismo día, un detalle concreto, ninguna petición. Noventa segundos, y es todo lo que la gente quiere decir cuando dice hacer contactos.$md$,
  $j$[
    {
      "situation": "Conociste a alguien en un congreso esta mañana.",
      "line": "Encantado de conocerte en lo del café — tenías razón con la sesión de precios. Si alguna vez pasas por la oficina de Madrid, saluda.",
      "why": "El mismo día, un detalle real, ninguna petición, y una puerta que no cuesta nada. Noventa segundos, y convierte un recuerdo a medias en alguien que sabe quién eres."
    },
    {
      "situation": "Estás a punto de escribir «un placer conectar».",
      "line": "(eso es una plantilla y se lee como una)",
      "why": "Se le podría haber mandado a cuarenta personas, porque se le mandó. Un detalle de la conversación real es toda la diferencia."
    },
    {
      "situation": "Te gustaría bastante preguntarles algo.",
      "line": "(no en este mensaje)",
      "why": "Un seguimiento que lleva una petición convierte dos minutos agradables en el movimiento de apertura de una transacción, y todo el mundo lo nota."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué el mismo día?",
      "options": [
        { "text": "Demuestra que tienes ganas.", "correct": false, "note": "Las ganas no son la moneda aquí, y no es lo que protege el momento." },
        { "text": "Se les habrá olvidado para la semana que viene.", "correct": false, "note": "Versión seca del motivo real. Recuerdan la conversación; lo que se difumina es que tú fueras una persona y no un nombre." },
        { "text": "Hoy eres una persona con la que estaban hablando.", "correct": true, "note": "Diez días después eres un nombre y una empresa, y el mensaje tiene que volver a presentarte antes de poder hacer nada más." },
        { "text": "Es más fácil escribirlo mientras está fresco.", "correct": false, "note": "Cierto y va sobre ti en vez de sobre ellos." }
      ],
      "explain": "Estás conservando el hecho de que fuiste una persona, no un contacto."
    },
    {
      "prompt": "¿Qué no debe llevar el mensaje?",
      "options": [
        { "text": "Un detalle concreto: eso es demasiado familiar.", "correct": false, "note": "Lo contrario: el detalle es todo el sentido y lo que demuestra que fue esa conversación." },
        { "text": "Nada sobre ti.", "correct": false, "note": "Una línea sobre ti está bien. Es la petición la que hace el daño." },
        { "text": "Una puerta abierta: eso es presuntuoso.", "correct": false, "note": "Una puerta que no cuesta nada y no necesita respuesta es exactamente correcta, y se puede coger dentro de un año." },
        { "text": "Una petición.", "correct": true, "note": "Convierte dos minutos agradables en el movimiento de apertura de una transacción. El mensaje ha hecho su trabajo con existir." }
      ],
      "explain": "El mismo día, un detalle real, ninguna petición, una puerta que no cuesta nada. Y luego nada más."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "same_day", "label": "Lo mandó el mismo día", "description": "Escribió mientras seguía siendo una persona y no un nombre." },
      { "key": "specific", "label": "Nombró un detalle real", "description": "Hizo referencia a algo de la conversación real." },
      { "key": "no_ask", "label": "No pidió nada", "description": "Mantuvo fuera cualquier petición." },
      { "key": "short", "label": "Dos líneas", "description": "No escribió una carta." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Theo",
      "role": "alguien que conociste esta mañana en el congreso",
      "mood": "En el tren de vuelta a casa.",
      "openness": 4,
      "personality": "Responde con calidez a cualquier cosa concreta y con brevedad a cualquier cosa genérica. Se enfría ante un mensaje que lleve una petición."
    },
    "setting": "La tarde después del congreso. Conociste a Theo en la pausa de café de la mañana y hablasteis de la sesión de precios, que él recomendó y sobre la que tenía razón.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con calidez y de forma concreta a cualquier cosa que haga referencia a la conversación real.",
      "Responde con un reconocimiento de una palabra a cualquier cosa genérica.",
      "Ponte educado y breve si el mensaje lleva una petición."
    ],
    "opening_beat": "La caja de mensaje está vacía y son las siete de la tarde.",
    "success_looks_like": "La persona manda dos líneas cortas con un detalle real y ninguna petición."
  }$j$::jsonb,
  'Hoy, manda dos líneas a alguien que hayas conocido hace poco, con un detalle real y ninguna petición. Apunta qué mandaste.',
  $j${
    "says": "Son las siete de la tarde, el día del congreso. Conociste a Theo en la pausa de café de la mañana y tenía razón en que la sesión de precios era la mejor.",
    "model": {
      "line": "Encantado de conocerte esta mañana — tenías razón con la sesión de precios, fue la mejor. Si alguna vez pasas por la oficina de Madrid, saluda.",
      "why": "El mismo día, un detalle real que demuestra que fue esa conversación, ninguna petición, y una puerta que no necesita respuesta. Noventa segundos, y casi nadie lo manda."
    },
    "checks": [
      { "kind": "echoes_any", "words": ["precios", "sesión", "café", "mañana"], "requirement": "Haz referencia a la conversación real" },
      { "kind": "forbids_any", "words": ["podrías", "sería posible", "me preguntaba si podrías", "hay alguna posibilidad", "ponerme en contacto", "hacer una llamada", "aprovechar tu experiencia", "un placer conectar", "conectemos"], "requirement": "No pidas nada" },
      { "kind": "max_words", "n": 45, "requirement": "Dos líneas" }
    ]
  }$j$::jsonb
);
