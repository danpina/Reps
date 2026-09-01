-- Spanish: Interviews, track 7 — Las preguntas que haces tú.
--
-- Conventions as migration 109. One note:
--
-- **The word lists lost their short tokens.** The English drills look for "I"
-- and "me" to prove a question is about the reader in the seat; the Spanish
-- equivalents "yo" and "me" are inside mayo, ensayo, mesa and comer, and a
-- substring match cannot tell the difference. The checks look for the time
-- words instead — primer, primera, semana, empezar — which is what actually
-- carries the present tense in a Spanish question about the job.

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

select pg_temp.es_lesson('interview-your-questions', 1,
  'Pregunta lo que solo ellos pueden responder',
  $md$*¿Tienes alguna pregunta?* es la única parte de la hora en la que eliges tú el tema, y casi todos los candidatos la devuelven sin abrir.

La prueba para saber si una pregunta merece la pena cabe en una línea: ¿puede responderla esta persona, y no puede responderla la web?

Eso descarta casi todo lo que se pregunta. La cultura: la web dice que es colaborativa. Los planes de crecimiento: la nota de prensa dice lo que dice una nota de prensa. El presupuesto de formación: es una política, y preguntar por ella en una primera entrevista señala que estás pensando en irte antes de haber llegado.

Y deja dentro cualquier cosa que requiera la experiencia de esta persona. Qué le resulta difícil. En qué se equivocó. Qué cambió después de la última reorganización. Qué hacía bien quien estaba antes que tú.

**La jugada:** pregunta algo que esta persona en concreto sepa y que no contenga ningún documento.

Hay una segunda función, más silenciosa. Las preguntas que haces son lo último que se dice en la sala, y se leen como prueba de a qué prestas atención. Quien pregunta por el turno de guardias, por cómo se desatascan las decisiones, y qué pasó con la persona anterior ha demostrado tres cosas sobre cómo piensa el trabajo, sin hacer ni una sola afirmación sobre sí mismo.

Prepara cinco y cuenta con usar tres. Dos las habrán respondido durante la entrevista, y decirlo está bien: *tenía una sobre cómo se fija la hoja de ruta, pero ya la has cubierto* demuestra que escuchabas y que lo habías preparado, en once palabras.

Una cosa que evitar: la pregunta diseñada para exhibir lo que sabes. Se le oye a todo el mundo, no es una pregunta, y quien entrevista tiene que aguantarla con educación.$md$,
  $j$[
    {
      "situation": "Una pregunta que solo esta persona puede responder.",
      "line": "¿Qué es eso que este equipo tiene que rehacer una y otra vez?",
      "why": "Ningún documento contiene la respuesta, todo el que trabaja ahí la sabe, y lo que contesten casi siempre es genuinamente informativo. Además señala que piensas en sistemas y no en tareas."
    },
    {
      "situation": "Retirar una pregunta preparada que ya han respondido.",
      "line": "Tenía una sobre cómo se fijan las prioridades entre los dos equipos, pero eso lo has respondido al hablar de la sesión de los jueves. Así que en su lugar: ¿qué ha cambiado aquí en el último año a lo que no querrías volver?",
      "why": "Demuestra preparación y escucha a la vez, y luego gasta el hueco en algo mejor. Retirar una pregunta en voz alta es mucho más fuerte que hacerla igualmente."
    },
    {
      "situation": "Rechazar la pregunta que exhibe lo que sabes.",
      "line": "Iba a preguntar algo listo sobre vuestra arquitectura y la verdad es que solo estaría luciéndome. La pregunta de verdad es: ¿qué te habría gustado que alguien te contara antes de entrar?",
      "why": "Nombrar la tentación y rechazarla desarma, y la pregunta que la sustituye es de las que la gente responde con honestidad. Además reencuadra la conversación como dos compañeros hablando."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué pregunta merece uno de tus tres huecos?",
      "options": [
        { "text": "¿Cómo es la cultura aquí?", "correct": false, "note": "La respuesta es una palabra — colaborativa, dinámica, cercana — y no lleva ninguna información. Es la pregunta más hecha y menos útil de una entrevista." },
        { "text": "¿Qué aspecto tiene el éxito en este puesto a los seis meses?", "correct": false, "note": "Razonable y común. Consigue una respuesta de verdad, aunque normalmente ensayada, y no requiere a esta persona en concreto." },
        { "text": "¿Qué es lo último que este equipo hizo muy mal, y qué pasó después?", "correct": true, "note": "Solo puede responderla alguien de dentro, la respuesta siempre revela algo, y cómo lleven la pregunta te dice tanto como el contenido." },
        { "text": "¿Qué oportunidades de promoción hay?", "correct": false, "note": "Una pregunta de política que se lee como si fuera sobre tu próximo trabajo y no sobre este. Bien en la fase de oferta, floja en una entrevista." }
      ],
      "explain": "¿Puede responderla esta persona, y no puede la web? Dos condiciones, y casi todas las preguntas fallan la segunda."
    },
    {
      "prompt": "Dos de tus tres preguntas preparadas ya se han respondido durante la entrevista. ¿Y ahora?",
      "options": [
        { "text": "Decirlo, y hacer la que queda más algo que haya salido en la conversación.", "correct": true, "note": "Retirarlas en voz alta demuestra preparación y atención a la vez, y una pregunta sacada de la conversación es casi siempre mejor que una preparada." },
        { "text": "Hacerlas igualmente: demuestra que te lo preparaste.", "correct": false, "note": "Demuestra que te lo preparaste y que no estabas escuchando, que es una combinación peor que no prepararse." },
        { "text": "Decir que no tienes preguntas, ya que lo han cubierto todo.", "correct": false, "note": "No tener nada que preguntar se lee como indiferencia, por exhaustivos que hayan sido. Siempre hay algo que solo saben ellos." }
      ],
      "explain": "Prepara cinco, usa tres, y deja que la conversación sustituya a las que respondió."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "insider_only", "label": "Solo ellos podían responderla", "description": "Preguntó algo que ningún documento ni ninguna web contendría." },
      { "key": "not_a_display", "label": "Una pregunta, no una exhibición", "description": "No usó el hueco para demostrar lo que sabe." },
      { "key": "listened", "label": "Tiró de la conversación", "description": "Al menos una pregunta salió de algo dicho durante la entrevista." },
      { "key": "prepared_enough", "label": "Tenía más de una", "description": "No se quedó sin preguntas, y no hizo una que ya se había respondido." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Steph Aldridge",
      "role": "una responsable de equipo que responde con honestidad, incluidas las incómodas",
      "mood": "Relajada. La parte formal ha terminado y tiene diez minutos.",
      "openness": 4,
      "personality": "Franca. Da respuestas de verdad a preguntas de verdad, y respuestas visiblemente ensayadas a las genéricas, sin señalar nunca la diferencia."
    },
    "setting": "Los últimos diez minutos de una entrevista de primera ronda. Quien entrevista acaba de mirar la hora y ha cedido la conversación.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a las preguntas genéricas con la versión pulida y sin información: una sola palabra positiva y un ejemplo de manual.",
      "Responde a las preguntas concretas de dentro con honestidad y con detalle, incluidas cosas que no dejan bien a la empresa.",
      "Nunca señales qué tipo de pregunta te acaban de hacer.",
      "Si la persona dice que no tiene más preguntas, cierra la entrevista con educación y sin demora."
    ],
    "opening_beat": "«Eso es todo por mi parte, y nos quedan unos diez minutos. ¿Qué tienes para mí?»",
    "success_looks_like": "La persona hace preguntas que requieren la experiencia propia de Steph, y repregunta sobre al menos una respuesta en vez de pasar directamente a la siguiente."
  }$j$::jsonb,
  'Pregúntale hoy a alguien por su trabajo con una pregunta que ninguna web podría responder: qué se rehace una y otra vez, qué le habría gustado que le contaran. Apunta qué aprendiste que no habrías podido buscar.',
  $j${
    "says": "Eso es todo por mi parte, y nos quedan unos diez minutos. ¿Qué tienes para mí?",
    "model": {
      "line": "¿Qué es lo que no te habrías creído sobre trabajar aquí antes de entrar?",
      "why": "Ningún documento contiene la respuesta y ningún otro candidato la ha hecho. Además le da permiso para decir algo verdadero, que es lo que hace que la respuesta merezca oírse."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Pregúntalo, no lo afirmes" },
      { "kind": "forbids_any", "words": ["qué hace la empresa", "cuánta gente trabaja", "cuál es el sueldo", "beneficios sociales", "vacaciones", "cuántos empleados", "a qué os dedicáis"], "requirement": "Nada que pudiera haber respondido una web" },
      { "kind": "max_words", "n": 35, "requirement": "Menos de treinta y cinco palabras: una pregunta, no tres" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-your-questions', 2,
  'Haz que te vean en la silla',
  $md$Hay un tipo de pregunta que hace algo más que recoger información: te mete en el puesto dentro de la cabeza de quien entrevista, mientras dura la respuesta.

Son preguntas hechas en presente, sobre el trabajo, como si la decisión ya estuviera tomada.

*¿Qué te gustaría que la persona de esta silla hubiera arreglado para Navidad?*
*Si empezara el lunes, ¿qué es lo primero que me caería encima?*
*¿Con quién discutiría más el primer mes?*

Quien entrevista tiene que imaginarte ahí para poder responder. Esa imaginación vale más que cualquier cosa que hayas dicho sobre ti en los cuarenta minutos anteriores, porque es suya y no tuya: la gente se cree las imágenes que construye.

**La jugada:** pregunta por el trabajo en presente, como si ya tuvieras el puesto.

Dos calibraciones.

**No te pases.** Una o dos de estas. Quien hace cinco preguntas presuntuosas es alguien que ha decidido el resultado, y se nota.

**Que se puedan responder.** *¿Cómo serían mis primeros noventa días?* suele ser demasiado vago para producir una respuesta real: casi ningún jefe lo ha pensado en esa forma. *¿Qué es lo primero que me caería encima?* es concreto y consigue una respuesta concreta.

La mejor versión de este tipo de pregunta pregunta por la dificultad y no por la oportunidad. *¿Cuál es la parte de este trabajo que la gente subestima?* invita a la honestidad, consigue una respuesta que merece tenerse, y les dice sin ruido que eres de los que preguntan qué es difícil antes de preguntar qué es agradable.

Si la respuesta suena alarmante, es información que ibas a recibir el día treinta de todos modos, a un precio mucho más alto.$md$,
  $j$[
    {
      "situation": "Presente, concreta, respondible.",
      "line": "Si empezara dentro de tres semanas, ¿qué es lo primero que me caería en la mesa?",
      "why": "Fuerza una respuesta concreta y fuerza a quien entrevista a imaginarse la mesa contigo delante. Mucho mejor que «¿cómo serían mis primeros noventa días?», que casi todos los jefes responden vagamente porque no lo han pensado en esos términos."
    },
    {
      "situation": "Preguntar por la dificultad y no por la oportunidad.",
      "line": "¿Cuál es la parte de este trabajo que la gente subestima antes de aceptarlo?",
      "why": "Consigue honestidad, porque da permiso para ella. A quien pregunta qué es difícil se le lee como realista, y la respuesta suele ser lo más útil que aprendes en todo el día."
    },
    {
      "situation": "Preguntar con quién está la fricción.",
      "line": "¿Con quién acabaría discrepando más en los primeros meses? No en mal plan: solo quiero saber dónde están las costuras.",
      "why": "Dibuja el mapa político en una pregunta, y la aclaración impide que suene a una búsqueda de conflicto. La respuesta te dice dónde está el trabajo de verdad."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué funciona preguntar en presente?",
      "options": [
        { "text": "Demuestra seguridad, que resulta atractiva en un candidato.", "correct": false, "note": "La seguridad es un efecto secundario. La presunción por sí sola no convence y puede irse fácilmente por el otro lado." },
        { "text": "Obliga a quien entrevista a imaginarte haciendo el trabajo para poder responder.", "correct": true, "note": "Y la gente confía muchísimo más en las imágenes que construye que en las afirmaciones que le entregan." },
        { "text": "Consigue respuestas más detalladas que si se formula como hipótesis.", "correct": false, "note": "A menudo cierto y secundario. El detalle te ayuda a ti; la imaginación ayuda a tu candidatura." },
        { "text": "Señala que tienes otras ofertas.", "correct": false, "note": "No señala nada de eso, y una pregunta diseñada para insinuar una palanca que puede que no tengas es un mal cambio." }
      ],
      "explain": "Le estás tomando prestada la imaginación durante treinta segundos. Ese es el mecanismo, y por eso una o dos de estas valen más que cinco buenas preguntas sobre políticas de empresa."
    },
    {
      "prompt": "¿Cuál es la versión más fuerte de este tipo de pregunta?",
      "options": [
        { "text": "¿Cómo serían mis primeros noventa días?", "correct": false, "note": "Lo bastante común como para estar ensayada, y lo bastante vaga como para que muchos jefes la respondan con un plan inventado sobre la marcha." },
        { "text": "¿Cómo es el candidato ideal para este puesto?", "correct": false, "note": "Invita a una descripción que no puedes igualar y te pone en la posición de que te comparen con una persona inventada." },
        { "text": "¿Cuál es la parte de este trabajo que la gente subestima?", "correct": true, "note": "Concreta, invita a la honestidad, y preguntar por la dificultad en vez de por la recompensa te distingue. La respuesta a menudo vale la entrevista entera." }
      ],
      "explain": "Lo concreto gana a lo amplio, y preguntar qué es difícil gana a preguntar qué es bueno."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "present_tense", "label": "Preguntó en presente", "description": "Formuló al menos una pregunta como si ya estuviera en el puesto." },
      { "key": "concrete", "label": "Respondible y concreta", "description": "Las preguntas produjeron respuestas reales y no generalidades improvisadas." },
      { "key": "asked_about_hard", "label": "Preguntó qué es difícil", "description": "Preguntó por las partes duras, no solo por las oportunidades." },
      { "key": "calibration", "label": "No se pasó", "description": "Una o dos preguntas presuntuosas, no una tanda entera." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Callum Reid",
      "role": "el responsable de contratación del puesto",
      "mood": "Enganchado y algo cansado. Es su cuarta entrevista esta semana para el mismo puesto.",
      "openness": 4,
      "personality": "Reflexivo y honesto, a veces más honesto de lo que sería prudente. Responde a las preguntas concretas con detalle real y a las vagas con generalidades agradables."
    },
    "setting": "El hueco de preguntas en una entrevista de segunda ronda con quien sería tu jefe.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a las preguntas concretas y en presente con detalles genuinos, incluido algo ligeramente poco favorecedor sobre el equipo.",
      "Responde a las preguntas vagas o genéricas con generalidades agradables y sin información.",
      "Si te preguntan por la dificultad, sé honesto: nombra un problema real que tenga el equipo.",
      "No evalúes las preguntas ni le digas a la persona que ha hecho una buena."
    ],
    "opening_beat": "«Nos queda un rato. Prefiero usarlo en tus preguntas que en más de las mías: ¿qué quieres saber?»",
    "success_looks_like": "La persona hace al menos una pregunta en presente sobre el trabajo real y al menos una sobre qué es difícil, y repregunta sobre las respuestas."
  }$j$::jsonb,
  'Pregúntale a alguien por su propio trabajo en presente: qué me caería en la mesa, qué subestima la gente. Apunta la respuesta, y apunta si la conversación cambió de forma.',
  $j${
    "says": "Nos queda un rato. Prefiero usarlo en tus preguntas que en más de las mías: ¿qué quieres saber?",
    "model": {
      "line": "¿Qué te gustaría que hubiera sacado adelante al final de los tres primeros meses?",
      "why": "Preguntado en presente sobre el puesto como si ya fuera tuyo. Es muy difícil de responder sin imaginarte haciéndolo, que es de lo que se trata."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Pregúntalo, no lo afirmes" },
      { "kind": "contains_any", "words": ["primer", "primera", "primeros", "semana", "día a día", "empezar", "empezara", "llegar", "los tres primeros"], "requirement": "Pregunta por el trabajo como si ya lo tuvieras" },
      { "kind": "max_words", "n": 35, "requirement": "Menos de treinta y cinco palabras" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-your-questions', 3,
  'Pregunta por la persona, una vez',
  $md$Las entrevistas son asimétricas por diseño, y durante cincuenta minutos quien entrevista es una función y no una persona. Una pregunta que la trate como persona vale más que tres sobre el puesto.

*¿Qué te ha hecho quedarte?*

Esa es toda la técnica. Variantes: qué te hizo entrar, qué estuvo a punto de hacerte irte, qué le dirías a un amigo que se presentara. Todas hacen lo mismo: piden una opinión en vez de información, y las opiniones son lo único que a la gente le gusta de verdad que le pidan.

De ahí salen dos efectos, y los dos importan.

**Cambia el registro.** Dejan de informar y se ponen a hablar. Casi todo el mundo da una respuesta más honesta a esto que a cualquier otra cosa de la hora, y aprendes más del sitio en treinta segundos de eso que en toda la web de empleo.

**Disfrutan de la entrevista.** Suena blando y no lo es. Quien entrevista escribe sus notas poco después, y las escribe una persona con una sensación sobre cómo fue la conversación. Ser el candidato con el que un entrevistador cansado disfrutó hablando es una ventaja real, y está disponible para cualquiera.

**La jugada:** haz una pregunta que pida su opinión en vez de información.

Dos reglas la mantienen honesta. Una vez, no dos: una segunda pregunta personal empieza a parecer una técnica, que lo es, y todo el valor estaba en que no lo pareciera. Y escucha la respuesta de verdad, incluida la pausa que la precede; la vacilación antes de que alguien diga por qué se quedó es con frecuencia más informativa que la frase que viene después.

Si la respuesta es fina o evasiva, eso es un dato. Alguien que no sabe decir por qué lleva cuatro años ahí te ha dicho algo que conviene saber.$md$,
  $j$[
    {
      "situation": "La pregunta central, hecha con claridad.",
      "line": "Llevas cinco años aquí, que es mucho tiempo en este sector. ¿Qué te ha hecho quedarte?",
      "why": "Nota algo concreto de esa persona, y luego pide una opinión. La observación es lo que la hace aterrizar: se ve que va sobre esta persona y no que viene de una lista."
    },
    {
      "situation": "Una versión para alguien que acaba de entrar.",
      "line": "Entraste hace seis meses: ¿qué es lo que más te ha sorprendido desde que llegaste?",
      "why": "La gente recién llegada es la más útil a la que preguntar, porque todavía ve el sitio desde fuera. Sus respuestas suelen ser concretas y casi nunca están ensayadas."
    },
    {
      "situation": "Escuchar una vacilación.",
      "line": "Entrevistadora: «…buena pregunta, la verdad. Supongo que la gente, sobre todo. Y tardó un tiempo.» — «¿Por qué tardó un tiempo?»",
      "why": "La pausa y el matiz eran la respuesta de verdad. Seguir la vacilación en vez de la frase es donde empieza la conversación útil, y demuestra que estabas escuchando de verdad."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué funciona «¿qué te ha hecho quedarte?»?",
      "options": [
        { "text": "Halaga a quien entrevista.", "correct": false, "note": "No es un halago, y si aterriza como halago es que se ha preguntado mal. El halago es la forma de fallar de esta pregunta." },
        { "text": "Pide una opinión en vez de información, lo que cambia el registro.", "correct": true, "note": "La gente sale del modo informe y se pone a hablar. Las respuestas son más honestas y las dos partes disfrutan más del intercambio." },
        { "text": "Revela si la empresa tiene problemas para retener gente.", "correct": false, "note": "Un efecto secundario útil. El efecto principal está en la conversación que estás teniendo ahora mismo." }
      ],
      "explain": "Las opiniones son lo único que a la gente le agrada que le pidan. Todo lo demás es una petición de trabajo."
    },
    {
      "prompt": "Quien entrevista da una respuesta fina y evasiva a por qué se ha quedado. ¿Qué has aprendido?",
      "options": [
        { "text": "Nada: hay gente que sencillamente es reservada con el trabajo.", "correct": false, "note": "Posible, y sigue siendo información. Una respuesta reservada a una pregunta amable merece anotarse aunque sea inocente." },
        { "text": "Que le has pillado desprevenida, lo que no dice nada de la empresa.", "correct": false, "note": "Que la pillen desprevenida es justo lo que hace informativa la respuesta. La versión sin preparar es la honesta." },
        { "text": "Algo que merece pesar cuando decidas si aceptas.", "correct": true, "note": "Alguien que no sabe decir por qué lleva cuatro años ahí te ha dicho algo. No es decisivo, y va en el cuadro." },
        { "text": "Que deberías hacerle la misma pregunta a otra persona.", "correct": false, "note": "Siguiente paso razonable, y no cambia el hecho de que de esta ya tienes una respuesta." }
      ],
      "explain": "Esta pregunta recoge información en las dos direcciones. Una entrevista es también donde decides tú sobre ellos."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked_for_opinion", "label": "Pidió una opinión", "description": "Preguntó algo personal sobre su experiencia en vez de sobre el puesto." },
      { "key": "specific_observation", "label": "La ancló en algo concreto", "description": "Se fijó en algo de esta persona antes de preguntar." },
      { "key": "listened_to_the_pause", "label": "Siguió la vacilación", "description": "Cogió lo que había de incómodo o matizado en la respuesta, y no solo las palabras." },
      { "key": "once", "label": "La hizo una vez", "description": "No convirtió una pregunta genuina en una técnica repetida." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Marianne Fisk",
      "role": "una persona sénior del equipo que lleva siete años en la empresa",
      "mood": "Cansada y cumpliendo el trámite hasta que algo le interese.",
      "openness": 3,
      "personality": "Profesional y algo cerrada hasta que le preguntan algo personal, momento en el que se abre notablemente y cuenta cosas que las otras tres personas que entrevistaron no contaron."
    },
    "setting": "El final de un día largo de entrevistas. Es la cuarta conversación, y las dos personas están algo gastadas.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a las preguntas sobre el puesto con brevedad y algo de sequedad.",
      "Si te preguntan algo personal sobre tu propia experiencia, haz una pausa primero — escribe la vacilación dentro de la respuesta — y luego responde con honestidad y más extensión.",
      "Si la persona sigue la vacilación, ábrete más y comparte algo genuinamente franco.",
      "Nunca le digas que ha hecho una buena pregunta."
    ],
    "opening_beat": "«Vale. Creo que por mi parte ya está. ¿Quieres preguntarme algo antes de terminar?»",
    "success_looks_like": "La persona hace una pregunta sobre la experiencia propia de Marianne, escucha la vacilación en la respuesta, y la sigue en vez de pasar a la siguiente pregunta."
  }$j$::jsonb,
  'Pregúntale hoy a alguien por qué se ha quedado en su trabajo, y luego no digas nada durante cinco segundos después de que termine. Apunta qué salió en la pausa.',
  $j${
    "says": "Vale. Creo que por mi parte ya está. ¿Quieres preguntarme algo antes de terminar?",
    "model": {
      "line": "¿Qué te ha mantenido aquí siete años, cuando me imagino que los dos últimos no habrán sido fáciles?",
      "why": "Pide su opinión en vez de información, y va sobre ella y no sobre la empresa. Una de estas por entrevista; dos la convierten en una entrevista a ellos."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Pregúntalo, no lo afirmes" },
      { "kind": "contains_any", "words": ["qué te parece", "en tu opinión", "qué es lo que", "te resulta", "qué te sorprendió", "qué te ha", "qué te mantiene", "por qué entraste", "qué te hizo"], "requirement": "Pregunta qué piensa, no qué es verdad" },
      { "kind": "max_words", "n": 35, "requirement": "Menos de treinta y cinco palabras" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-your-questions', 4,
  'La pregunta que encuentra el problema',
  $md$Todo puesto abierto existe porque algo no está funcionando. Alguien se fue, algo creció, algo se rompió, o se prometió algo que ahora mismo nadie puede entregar. El puesto para el que te entrevistas es una respuesta a un problema, y nadie te va a decir cuál a menos que preguntes.

Hay una familia de preguntas que llegan hasta ahí.

*¿Qué hizo necesario este puesto?*
*¿En qué era mejor la persona anterior, y qué le resultaba más difícil?*
*Si no se contrata a nadie para esto, ¿qué es lo que no pasa?*
*¿Cuánto lleva abierto el puesto?*

Esta última es la más barata y la más reveladora. Dos semanas significa crecimiento. Siete meses significa o que el listón está alto o que algo de la descripción está mal, y saber cuál de las dos te dirá muchísimo sobre dónde te estarías metiendo.

**La jugada:** pregunta qué problema existe este puesto para resolver, y escucha lo que se dejan fuera.

Dos recompensas. La obvia es que averiguas qué te están contratando para arreglar, lo que te deja apuntar el resto de tus respuestas hacia ahí, y si la respuesta llega lo bastante pronto, puedes reencuadrar tu mejor historia alrededor de ello.

La sutil es que hacer esta pregunta es en sí misma una señal. A quien quiere saber qué está roto se le lee como alguien que arregla cosas. A quien pregunta solo por las partes buenas se le lee como alguien que quiere un trabajo agradable.

Hazla con neutralidad. Hay una versión de esto que suena a auditoría, y pone a quien entrevista a la defensiva. El tono que quieres es de curiosidad genuina, y la formulación que mejor lo lleva suele ser la más corta: *¿qué hizo necesario el puesto?*

Y luego escucha la pausa. Esta es una pregunta que la gente responde con cuidado, y el cuidado es la información.$md$,
  $j$[
    {
      "situation": "Preguntar con neutralidad y pronto.",
      "line": "¿Te puedo preguntar qué hizo necesario este puesto? Siempre me dice más que la descripción.",
      "why": "La segunda frase la desarma: explica el motivo para que la pregunta no pueda oírse como una auditoría. Hecha pronto, la respuesta se puede usar el resto de la entrevista."
    },
    {
      "situation": "Preguntar por la persona anterior sin preguntar por qué se fue.",
      "line": "¿En qué era mejor la persona que estaba antes que yo? ¿Y qué le resultaba más difícil?",
      "why": "Llega a la forma del puesto sin la incomodidad de preguntar por qué se fue alguien. La segunda mitad es la mitad útil, y emparejarla con la primera la hace fácil de responder."
    },
    {
      "situation": "Usar la respuesta de inmediato.",
      "line": "Eso es útil, porque lo que acabas de describir es casi exactamente la situación con la que me encontré en 2022, y la parte que importaba no era el proceso: era conseguir que los dos jefes se pusieran de acuerdo en de quién era.",
      "why": "Convierte su respuesta en un puente hacia tu mejor material. Es lo de más valor que puede pasar en el hueco de preguntas, y solo se vuelve posible si preguntaste lo bastante pronto."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué es lo más probable que te diga «el puesto lleva siete meses abierto»?",
      "options": [
        { "text": "Que la empresa no se lo toma en serio.", "correct": false, "note": "A veces cierto y casi nunca la historia principal. Los puestos siguen abiertos por motivos que suelen ser más concretos que la indiferencia." },
        { "text": "O que el listón está inusualmente alto, o que algo de la descripción no coincide con la realidad.", "correct": true, "note": "Las dos cosas merecen saberse, y las dos son repreguntas posibles. Este solo dato reencuadra todo lo demás que te han contado." },
        { "text": "Que tienes palanca en la negociación.", "correct": false, "note": "A veces, y tratarlo como palanca en vez de como información es como los candidatos leen mal un proceso de selección." },
        { "text": "Que el sueldo está por debajo del mercado.", "correct": false, "note": "Una causa posible entre varias. Darla por hecha estrecha lo que aprendes de la repregunta." }
      ],
      "explain": "Cuánto lleva abierto un puesto es la pregunta más barata de la entrevista y una de las más informativas."
    },
    {
      "prompt": "¿Por qué preguntar qué está roto ayuda a tu candidatura, y no solo a tu información?",
      "options": [
        { "text": "Demuestra que no eres ingenuo sobre el trabajo.", "correct": false, "note": "En parte, y «no ingenuo» es un listón bajo. El efecto es más concreto que eso." },
        { "text": "Halaga la honestidad de quien entrevista.", "correct": false, "note": "Sí invita a la honestidad, y el halago no es el mecanismo. Hecha como halago deja de funcionar." },
        { "text": "A quien pregunta qué está roto se le lee como alguien que arregla cosas.", "correct": true, "note": "La pregunta se oye como una afirmación sobre cómo enfocas el trabajo, y por eso aterriza como prueba y no como curiosidad." }
      ],
      "explain": "Lo que eliges preguntar se lee como aquello a lo que prestas atención. Pregunta por la parte difícil."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked_the_problem", "label": "Preguntó para qué es el puesto", "description": "Averiguó qué problema existe la vacante para resolver." },
      { "key": "neutral_tone", "label": "Lo preguntó con neutralidad", "description": "Con curiosidad y no auditando, así que quien entrevistaba respondió en vez de defenderse." },
      { "key": "listened_for_omission", "label": "Notó lo que se dejaron fuera", "description": "Prestó atención al cuidado y a la vacilación de la respuesta, no solo a su contenido." },
      { "key": "used_it", "label": "Usó la respuesta", "description": "Conectó lo que aprendió con su propia experiencia relevante." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Derek Ashworth",
      "role": "un jefe de departamento honesto si le preguntan directo y evasivo si le preguntan vago",
      "mood": "Comedido. Hace poco se quemó con una mala contratación y está siendo cuidadoso en las dos direcciones.",
      "openness": 3,
      "personality": "Cuidadoso. Responde exactamente a lo que le preguntan. Si una pregunta es neutra y directa dice la verdad, incluido que el puesto lleva mucho abierto y por qué."
    },
    "setting": "Una segunda entrevista en la que el candidato tiene un hueco de preguntas en medio y no al final.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si te preguntan directa y neutralmente por qué existe el puesto, responde con honestidad: la persona anterior se fue, y debajo hay un desacuerdo sin resolver entre dos equipos.",
      "Si la pregunta suena a auditoría, vuélvete breve y algo defensivo.",
      "Haz una pausa antes de responder cualquier cosa sobre la persona anterior.",
      "Nunca le digas cómo ha aterrizado su pregunta."
    ],
    "opening_beat": "«Antes de meterme en el resto de mis preguntas, ¿hay algo que quieras preguntar a estas alturas? Hay gente que prefiere hacerlo al principio.»",
    "success_looks_like": "La persona pregunta qué problema existe el puesto para resolver, obtiene una respuesta real, y la conecta con su propia experiencia más adelante en la conversación."
  }$j$::jsonb,
  'Pregúntale a alguien que haya contratado hace poco qué problema existía el puesto para resolver. Apunta lo distinta que fue su respuesta de lo que decía el anuncio.',
  $j${
    "beats": [
      {
        "situation": "Preguntas qué problema existe el puesto para resolver. Dice: «La verdad es que simplemente estamos creciendo y necesitamos más manos».",
        "prompt": "¿Qué te ha dicho eso?",
        "options": [
          { "text": "Que todavía nadie ha decidido para qué es este puesto.", "correct": true, "note": "La respuesta más útil que vas a conseguir en todo el día, y está en lo que se dejó fuera. Un puesto con un problema definido consigue una respuesta concreta sin que haga falta insistir." },
          { "text": "Que a la empresa le va bien, que es buena señal.", "correct": false, "note": "Leer la superficie. El crecimiento es por lo que existe la plaza; no es lo que es el trabajo." },
          { "text": "Que está siendo evasivo.", "correct": false, "note": "Normalmente no. La vaguedad aquí es mucho más a menudo ausencia de respuesta que ocultación de una." },
          { "text": "Poca cosa: es una respuesta normal.", "correct": false, "note": "Es una respuesta normal, y las respuestas normales a esta pregunta son el hallazgo. Casi todos los puestos están mal definidos y casi ningún candidato lo comprueba." }
        ]
      },
      {
        "situation": "Le haces la misma pregunta a la responsable de contratación. Dice: «Soporte se está ahogando y ya hemos intentado dos veces arreglarlo con procesos. Hace falta alguien que sepa construir».",
        "prompt": "¿Qué te ha dicho eso?",
        "options": [
          { "text": "Que el problema es real, y que dos personas ya han fracasado con él.", "correct": true, "note": "Todo lo que necesitas. Sabes el problema, sabes que es difícil, y sabes cuáles fueron los dos intentos anteriores, que es la pregunta siguiente." },
          { "text": "Que el puesto está bien definido, así que es un buen trabajo.", "correct": false, "note": "La mitad. Un problema bien definido que ha derrotado a dos intentos anteriores es información sobre la dificultad tanto como sobre la claridad." },
          { "text": "Que están desesperados, así que tienes palanca.", "correct": false, "note": "Una conclusión sobre la negociación sacada de una frase sobre el trabajo, y normalmente equivocada." },
          { "text": "Que deberías preguntar por los intentos con procesos.", "correct": false, "note": "Deberías, y esa es la jugada siguiente y no la lectura. Lo que te ha dicho es que el problema es real." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-your-questions', 5,
  'Salas distintas, preguntas distintas',
  $md$Hacerles las mismas tres preguntas a todas las personas que conoces en un proceso desperdicia casi todas, y en un día de panel se nota: comparan notas, y *nos preguntó lo mismo a todos* es una nota real.

Ajusta la pregunta a lo que esa persona puede contarte de verdad.

**Quien criba** sabe el proceso, los candidatos que compiten, el calendario, y qué dice quien contrata cuando la puerta está cerrada. Pregúntale por el proceso y por quien contrata. No le preguntes por el trabajo.

**Quien contrata** sabe el puesto, el problema, las debilidades del equipo y qué necesita de esta contratación. Pregúntale por el trabajo, por la dificultad, por los primeros noventa días.

**Quien sería tu igual** sabe cómo es de verdad: las reuniones, la frustración, si las herramientas sirven de algo, si la gente se queda hasta tarde. Pregúntale cómo es una mala semana. Es la sala más honesta en la que vas a estar y casi todos los candidatos la desperdician en preguntas sobre estrategia.

**Quien está dos niveles por encima** sabe hacia dónde va todo esto y qué haría que fracasara. Pregúntale por la dirección, por qué tendría que ser verdad dentro de dos años, por la limitación que le preocupa.

**La jugada:** pregúntale a cada persona por la parte del trabajo que solo ella ve.

Dos cosas prácticas. Guarda una pregunta en la recámara para el final de la última conversación, porque los procesos se alargan y el hueco de preguntas es lo que se recorta. Y apunta las respuestas entre conversaciones: te van a contar cosas contradictorias, y las contradicciones son el dato más valioso de todo el día. Un equipo que no se pone de acuerdo en para qué es el puesto te está diciendo algo que ninguna respuesta podría.

Si te quedas corto de preguntas en la cuarta entrevista, haz la misma pregunta sobre otra cosa: cuál es la parte más difícil de *tu* semana, en vez de la parte más difícil del puesto.$md$,
  $j$[
    {
      "situation": "Hacerle a un igual la pregunta que no le harías a un jefe.",
      "line": "¿Cómo es una mala semana aquí? No un desastre: una mala semana normal.",
      "why": "Los iguales responden a esto con honestidad y los jefes rara vez pueden. Ese «no un desastre» es lo que la hace respondible, porque pregunta por lo corriente y no por lo excepcional."
    },
    {
      "situation": "Preguntarle a alguien de dirección por el rumbo y no por el detalle.",
      "line": "¿Qué tendría que ser verdad dentro de dos años para que dijeras que este equipo funcionó?",
      "why": "Apuntada a la altura a la que esa persona opera de verdad. Preguntarle a un director por las herramientas desperdicia la única conversación en la que podrías averiguar hacia dónde va todo esto."
    },
    {
      "situation": "Notar una contradicción a lo largo del día.",
      "line": "Tu compañero describió el reto principal como la velocidad, y tú lo has descrito como la calidad. ¿Es una tensión viva, o estoy leyendo de más?",
      "why": "La pregunta de más valor disponible en un día de panel, y solo se puede hacer porque se tomaron notas. No es una trampa; hecha en este tono, suele producir la respuesta más franca del día."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Tienes veinte minutos con alguien que se sentaría a tu lado. ¿Cuál es el mejor uso?",
      "options": [
        { "text": "Preguntar por la estrategia de la empresa, para demostrar que piensas a lo grande.", "correct": false, "note": "Probablemente sepa menos de eso que las tres últimas personas que has visto, y habrás desperdiciado la única sala honesta del edificio." },
        { "text": "Preguntar cómo es una mala semana normal.", "correct": true, "note": "Los iguales responden a esto con la verdad y nadie más puede. Son los veinte minutos más útiles del día si los gastas aquí." },
        { "text": "Preguntar por la promoción y por cómo funcionan los ascensos.", "correct": false, "note": "Vas a conseguir la anécdota de una persona, y habrás gastado la sala honesta en una pregunta de política de empresa." },
        { "text": "Preguntar qué cree que busca quien contrata.", "correct": false, "note": "Tentador y sobre todo especulación. Quien criba lo sabe de verdad; tu igual está adivinando." }
      ],
      "explain": "Cada sala puede contarte una cosa mejor que ninguna otra. Gástala en eso."
    },
    {
      "prompt": "Dos personas que entrevistan describen el reto principal del puesto de forma distinta. ¿Qué deberías hacer?",
      "options": [
        { "text": "Dar por hecho que quien es más sénior tiene razón.", "correct": false, "note": "La jerarquía no lo resuelve, y descarta el hecho más interesante que has aprendido en todo el día." },
        { "text": "No decir nada: señalarlo parecería confrontativo.", "correct": false, "note": "Depende enteramente del tono. Hecha con curiosidad es una de las preguntas más fuertes disponibles, y callarse te deja sin una respuesta que necesitas." },
        { "text": "Preguntar por ello, con curiosidad, y tratar la respuesta como información importante sobre el trabajo.", "correct": true, "note": "Un equipo que no se pone de acuerdo en para qué es un puesto está describiendo tus primeros seis meses. Eso quieres saberlo antes de aceptar, no después." }
      ],
      "explain": "Las contradicciones a lo largo de un día de panel son lo más valioso que aprendes, y solo existen si estabas tomando notas."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "matched_the_room", "label": "Ajustó la pregunta a la persona", "description": "Le preguntó a cada persona por lo que solo ella podía ver." },
      { "key": "no_repeats", "label": "No repitió", "description": "Evitó hacerle la misma pregunta a varias personas." },
      { "key": "noticed_contradictions", "label": "Notó los desacuerdos", "description": "Cogió las diferencias entre lo que dijeron personas distintas." },
      { "key": "held_one_back", "label": "Guardó algo en la recámara", "description": "Le quedaba una pregunta para el final, cuando la agenda ya se había comido los huecos anteriores." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Yusuf Demir",
      "role": "un director, la última conversación del día",
      "mood": "Curioso pero con el tiempo justo. Quince minutos, y los usará todos si las preguntas son buenas.",
      "openness": 3,
      "personality": "Estratégico y directo. Las preguntas de detalle no le interesan, y se engancha visiblemente con las preguntas sobre rumbo, riesgo y qué haría fracasar al equipo."
    },
    "setting": "La última conversación de un día de panel con cuatro entrevistas. El candidato ya ha hablado con selección, con quien contrata y con un igual, y ha oído versiones algo distintas del puesto.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a las preguntas estratégicas con sustancia y detalle reales, y a las de detalle con una redirección breve hacia otra persona.",
      "Si la persona saca una contradicción entre entrevistadores, éntrale con honestidad y explica la tensión.",
      "Menciona una vez el tiempo que queda.",
      "Nunca comentes la calidad de las preguntas."
    ],
    "opening_beat": "«Hoy ya has visto a casi todo el equipo, así que probablemente sepas más del puesto que yo. Quince minutos: ¿qué quieres preguntarme?»",
    "success_looks_like": "La persona hace preguntas apuntadas al rumbo y al riesgo en vez de al detalle, y saca la contradicción entre lo que dijeron distintas personas."
  }$j$::jsonb,
  'Hazles a dos personas la misma pregunta sobre su lugar de trabajo común y apunta las dos respuestas. Apunta dónde discreparon las dos versiones.',
  $j${
    "beats": [
      {
        "situation": "Tienes quince minutos con la persona que dependería de ti.",
        "prompt": "¿Qué le preguntas?",
        "options": [
          { "text": "Qué le gustaría que fuera distinto en cómo se lleva el equipo.", "correct": true, "note": "La única persona del edificio que puede responderlo, y la respuesta te dice dónde te estarías metiendo el primer día." },
          { "text": "Cuál es la estrategia de la empresa para los próximos dos años.", "correct": false, "note": "Preguntarle a alguien por una sala en la que no está. Además se lee como no saber qué hace." },
          { "text": "Si le gusta trabajar ahí.", "correct": false, "note": "Va a decir que sí. Las preguntas con una sola respuesta socialmente disponible no compran nada." },
          { "text": "Cómo es trabajar para quien contrata.", "correct": false, "note": "La pregunta correcta para alguien que no está a punto de depender de ti. Aquí le pides que sea indiscreta con un desconocido que puede acabar siendo su jefe." }
        ]
      },
      {
        "situation": "Veinte minutos con un director dos niveles por encima, que no será tu jefe.",
        "prompt": "¿Qué le preguntas?",
        "options": [
          { "text": "Qué tendría que ser verdad dentro de dos años para que esta contratación hubiera merecido la pena.", "correct": true, "note": "Apuntada a lo que él ve y nadie por debajo puede ver. Además te dice contra qué se mide el puesto, que rara vez coincide con la descripción." },
          { "text": "Cómo es una semana normal en el puesto.", "correct": false, "note": "No lo sabe, y preguntarlo se lo deja claro a los dos." },
          { "text": "La misma pregunta que le hiciste a quien contrata.", "correct": false, "note": "Comparar respuestas es genuinamente útil y este no es el sitio donde gastar una de tres preguntas con alguien que ve algo que nadie más ve." },
          { "text": "Cómo está estructurado el equipo.", "correct": false, "note": "Una pregunta de documento, y él es la persona más cara del proceso en la que gastar una." }
        ]
      }
    ]
  }$j$::jsonb
);
