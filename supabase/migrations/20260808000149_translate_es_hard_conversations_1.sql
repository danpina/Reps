-- Spanish: Conversaciones difíciles, track 1 — Si merece la pena tenerla.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Sam" carries no `sex` field; masculine agreement used by
-- default, as established throughout this app.

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

select pg_temp.es_lesson('worth-having', 1,
  'Ensayar no es prepararse',
  $md$Cuatro semanas repasándolo en la ducha, en el coche, a las tres de la madrugada. Cada versión un poco más afilada. Cada una terminando con que se dan cuenta de que tenías razón.

Eso no es preparación y merece la pena ser directo al respecto: es evitación con una sensación productiva pegada.

**La jugada:** date cuenta de que el ensayo es la evitación, y deja de contarlo como trabajo.

Está haciendo tres cosas, ninguna buena. Te está haciendo invertir más en un guion que la otra persona nunca ha leído — así que cuando diga algo fuera de él, que lo va a hacer, vas a estar improvisando en una conversación que de alguna forma ya has tenido cuarenta veces. Te está haciendo estar más seguro de su respuesta, y esa seguridad está completamente fabricada, porque has estado interpretando los dos papeles. Y está descargando justo lo suficiente del sentimiento como para impedirte actuar, que es por lo que puede pasar un mes sin que la presión llegue nunca lo bastante alta como para forzarlo.

Hay una señal concreta que separa la preparación del ensayo. La preparación pregunta *¿qué quiero decir y qué quiero que pase?* El ensayo pregunta *¿y luego qué dice, y luego qué digo yo?* La primera tarda unos cuatro minutos y es genuinamente útil. La segunda no tiene final, y su función real es aplazar.

También hay un coste que solo aparece el día. Un guion de hace un mes no sobrevive al contacto, y alguien que ha ensayado en exceso a menudo lo actúa — entregando frases con una cualidad ligeramente rara y preparada que se lee como frialdad, porque no se le está diciendo a la persona que tiene delante. Se le está recitando a una persona que lleva semanas en su cabeza.

Si te quedas con una cosa: cuatro minutos de preparación ganan a cuatro semanas de ensayo, y todo lo que va más allá de los cuatro minutos es lo que estás haciendo en vez de tener la conversación.$md$,
  $j$[
    {
      "situation": "Lo has repasado en la ducha cada mañana durante tres semanas.",
      "line": "(eso es la evitación, no la preparación)",
      "why": "Descarga justo lo suficiente del sentimiento como para impedir que la presión llegue nunca lo bastante alta como para forzar la conversación."
    },
    {
      "situation": "Sabes exactamente qué te va a responder.",
      "line": "(has estado interpretando los dos papeles)",
      "why": "La seguridad está fabricada. Has ensayado contra una versión de esa persona que te has inventado, y la real va a decir algo fuera del guion."
    },
    {
      "situation": "Quieres prepararte de verdad.",
      "line": "(qué quiero decir, y qué quiero que pase)",
      "why": "Cuatro minutos, y genuinamente útil. Y luego qué dice no tiene final, que es lo que lo convierte en la versión que aplaza."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué separa la preparación del ensayo?",
      "options": [
        { "text": "Cuánto tiempo le dedicas.", "correct": false, "note": "La duración es el síntoma. El ensayo tarda más porque no tiene un final natural, que es consecuencia de su forma." },
        { "text": "Si lo apuntas.", "correct": false, "note": "Escribirlo ayuda y las dos cosas se pueden escribir. Mucha gente guioniza un ensayo en una app de notas." },
        { "text": "Si estás simulando sus respuestas.", "correct": true, "note": "Qué quiero decir y qué quiero que pase tarda cuatro minutos. Y luego qué dice no tiene final, y su función es aplazar." },
        { "text": "Si te sientes más tranquilo después.", "correct": false, "note": "El ensayo hace de forma fiable que la gente se sienta más tranquila, que es exactamente el problema — descarga la presión que si no forzaría la conversación." }
      ],
      "explain": "Cuatro minutos en tu mitad. La otra mitad no se puede saber y no es tuya para escribirla."
    },
    {
      "prompt": "¿Qué cuesta un mes de eso el día?",
      "options": [
        { "text": "Se te habrán olvidado los detalles.", "correct": false, "note": "Justo lo contrario — los detalles están extremadamente afilados, y eso es parte del problema." },
        { "text": "Vas a estar demasiado enfadado.", "correct": false, "note": "A veces, y el ensayo aplana el sentimiento más a menudo de lo que lo sube." },
        { "text": "Nada — vas a estar bien preparado.", "correct": false, "note": "Así es como se siente desde dentro de la cuarta semana, y es por lo que pasa el mes." },
        { "text": "Lo actúas, y que te reciten se lee como frialdad.", "correct": true, "note": "Un guion de hace un mes no sobrevive al contacto, y no se le está diciendo a la persona que tienes delante — se le está diciendo a la que ha estado en tu cabeza." }
      ],
      "explain": "La versión en tu cabeza ha tenido cuarenta conversaciones. La persona no ha tenido ninguna."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "noticed", "label": "Notó el ensayo", "description": "Lo reconoció como evitación en vez de trabajo." },
      { "key": "four_minutes", "label": "Preparó solo su mitad", "description": "Decidió qué decir y qué quiere, y paró." },
      { "key": "no_simulation", "label": "Dejó de simular sus respuestas", "description": "No le escribió el guion a la otra persona." },
      { "key": "moved", "label": "Se movió hacia tenerla", "description": "Convirtió el tiempo en una decisión en vez de en otra vuelta." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo con quien llevas semanas hablando de esto",
      "mood": "Cariñoso, directo.",
      "openness": 5,
      "personality": "Amable y algo exasperado. Pregunta cuántas veces lo has repasado, y qué estás esperando a sentir."
    },
    "setting": "Un amigo te ha preguntado por lo que llevas un mes dándole vueltas, y se ha dado cuenta de que todavía no le has dicho nada a la persona implicada.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué está esperando a sentir antes de estar listo.",
      "Tómate en serio cualquier decisión de tenerla esta semana.",
      "Nunca le digas a la persona qué decir en la conversación en sí."
    ],
    "opening_beat": "«¿Cuánto tiempo llevas ya dándole vueltas a cómo decir esto?»",
    "success_looks_like": "La persona reconoce el ensayo como evitación en vez de preparación."
  }$j$::jsonb,
  'Hoy, cuenta cuántas veces has ensayado una conversación. Luego dedica cuatro minutos solo a tu mitad. Apunta los dos números.',
  $j${
    "beats": [
      {
        "situation": "Tres semanas repasando la conversación en la ducha. Cada versión un poco más afilada, y cada una terminando con que se dan cuenta de que tenías razón.",
        "prompt": "¿Qué han sido esas tres semanas?",
        "options": [
          { "text": "Preparación — vas a estar mucho más claro cuando pase.", "correct": false, "note": "Claro sobre un guion que la otra persona no ha leído. Cuando diga algo fuera de él vas a estar improvisando en una conversación que ya has tenido cuarenta veces." },
          { "text": "Evitación con una sensación productiva pegada.", "correct": true, "note": "Descarga justo lo suficiente del sentimiento como para impedir que la presión llegue nunca lo bastante alta como para forzarlo, que es cómo pasa un mes." },
          { "text": "Procesar — necesitabas averiguar cómo te sentías.", "correct": false, "note": "Eso lleva una tarde. Tres semanas de afilar es una actividad distinta con una función distinta." },
          { "text": "Esperar el momento adecuado.", "correct": false, "note": "También cierto y también no es una explicación. No va a llegar ningún momento, que es la última lección de este bloque." }
        ]
      },
      {
        "situation": "Quieres prepararte de verdad en vez de ensayar.",
        "prompt": "¿En qué consiste la preparación?",
        "options": [
          { "text": "Averiguar qué es probable que diga, y tus respuestas.", "correct": false, "note": "Eso es el ensayo, y no tiene final. Estás interpretando los dos papeles, así que la seguridad que produce está fabricada." },
          { "text": "Escribirlo palabra por palabra para no perderlo.", "correct": false, "note": "Un guion se actúa, y que te reciten se lee como frialdad — no se le está diciendo a la persona que tienes delante." },
          { "text": "Qué quiero decir, y qué quiero que pase.", "correct": true, "note": "Cuatro minutos, y genuinamente útil. Tu mitad es la única mitad que puedes preparar." },
          { "text": "Decidir cómo vas a reaccionar si se disgusta.", "correct": false, "note": "Merece la pena saberlo en principio — es el bloque cuatro — y simularlo de antemano es el bucle otra vez." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('worth-having', 2,
  '¿Qué cambio quieres?',
  $md$Antes que nada, una pregunta, y es más útil que cualquier cantidad de redacción: ¿qué te gustaría que fuera distinto después?

**La jugada:** nombra el cambio concreto, o admite que no hay ninguno.

Si puedes nombrarlo — *me gustaría saberlo antes de que canceles, en vez de una hora después de cuando quedamos en vernos* — tienes una conversación con forma, y todo lo demás de este tema va a funcionar sobre ella.

Si no puedes, eso no es un fracaso y es información importante. Normalmente significa una de tres cosas, y necesitan un manejo completamente distinto.

**Quieres que sienta algo.** Que entienda cómo fue, que lo sienta, que se quede con ello. Eso es humano y no es una petición, porque a nadie se le puede hacer sentir algo por encargo. Una conversación apuntada a eso produce una discusión sobre si lo siente lo suficiente.

**Quieres decirlo, y ya está.** También legítimo, y va mucho mejor cuando sabes que es eso lo que es. *No te estoy pidiendo que hagas nada, solo no quería seguir cargando con esto en silencio* es una apertura honesta y le quita a la otra persona la presión de tener que producir una solución para algo que no es un problema.

**Quieres que la relación sea distinta.** Más vago y más pesado, y normalmente se descompone en dos o tres cambios concretos en cuanto te quedas con ello diez minutos. Hacer esa descomposición antes de la conversación es la mayor parte del trabajo.

El motivo por el que esto importa más de lo que parece: una conversación sin ninguna petición no tiene forma de terminar. Corre hasta que alguien se cansa, y las dos personas se van sin saber si ha pasado algo — que es cómo una conversación difícil se convierte en cuatro.

Si te quedas con una cosa: nombra lo que podrían hacer distinto el jueves. Si no hay nada, di qué es en su lugar.$md$,
  $j$[
    {
      "situation": "Estás enfadado y sabes de qué, pero no sabes qué quieres.",
      "line": "(entonces averigua eso primero)",
      "why": "Una conversación sin ninguna petición no tiene forma de terminar. Corre hasta que alguien se cansa y los dos se van sin saber si ha pasado algo."
    },
    {
      "situation": "Lo que quieres es que se sienta mal por ello.",
      "line": "(eso no es una petición, y no se puede entregar)",
      "why": "A nadie se le puede hacer sentir algo por encargo. Apuntada a eso, la conversación se convierte en una discusión sobre si lo siente lo suficiente."
    },
    {
      "situation": "Solo quieres decirlo.",
      "line": "No te estoy pidiendo que hagas nada, solo no quería seguir cargando con esto en silencio.",
      "why": "Honesto, y le quita la presión de tener que producir una solución para algo que no es un problema que resolver."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué va mal una conversación sin ninguna petición?",
      "options": [
        { "text": "No tiene forma de terminar.", "correct": true, "note": "Corre hasta que alguien se cansa, y las dos personas se van sin saber si ha pasado algo — que es cómo una conversación difícil se convierte en cuatro." },
        { "text": "Suena a queja.", "correct": false, "note": "Puede sonar, y muchas conversaciones bien recibidas son quejas con una petición pegada." },
        { "text": "No se lo va a tomar en serio.", "correct": false, "note": "A menudo se lo toman muy en serio y no tienen nada que ver con ello, que es un problema distinto y más frustrante." },
        { "text": "No te vas a sentir mejor.", "correct": false, "note": "A veces sí te vas a sentir mejor. El problema estructural es qué pasa en la sala, no después." }
      ],
      "explain": "Nombra lo que podrían hacer distinto el jueves."
    },
    {
      "prompt": "Quieres que entienda cómo se sintió. ¿Qué es eso?",
      "options": [
        { "text": "Un objetivo perfectamente bueno para la conversación.", "correct": false, "note": "Humano e inalcanzable como petición, porque a nadie se le puede hacer sentir algo por encargo." },
        { "text": "Una señal de que no deberías tenerla.", "correct": false, "note": "En absoluto — es una señal de que deberías saber qué estás haciendo, que es una conversación distinta con una apertura distinta." },
        { "text": "Algo que decir en voz alta tal como es.", "correct": true, "note": "No te estoy pidiendo que hagas nada, solo no quería seguir cargando con esto. Eso es honesto y le quita la presión de resolver algo irresoluble." },
        { "text": "Un cambio que quieres, formulado vagamente.", "correct": false, "note": "Suena a uno y no lo es — no hay ninguna acción al otro lado." }
      ],
      "explain": "Querer decirlo es legítimo. Solo va mucho mejor cuando sabes que es eso lo que es."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named", "label": "Nombró el cambio", "description": "Dijo qué podría ser distinto después." },
      { "key": "specific", "label": "Lo hizo accionable", "description": "Algo que pudieran hacer distinto en vez de sentir distinto." },
      { "key": "honest", "label": "Fue honesto cuando no había ninguno", "description": "Dijo que era sobre que le escucharan en vez de inventarse una petición." },
      { "key": "decomposed", "label": "Descompuso la versión vaga", "description": "Convirtió un deseo a nivel de relación en cambios concretos." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo ayudándote a pensarlo bien",
      "mood": "Paciente.",
      "openness": 5,
      "personality": "Sigue preguntando qué sería distinto después, y no acepta sentimientos sobre la otra persona como respuesta a eso."
    },
    "setting": "Un amigo te está ayudando a averiguar qué quieres de verdad de una conversación que sigues sin tener sobre alguien que cancela planes.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué sería distinto después cada vez que la respuesta sea sobre cómo se siente.",
      "Acepta solo quiero decirlo como una buena respuesta si se llega ahí con honestidad.",
      "Nunca sugieras tú una petición."
    ],
    "opening_beat": "«Vale. Digamos que sale perfecto. ¿Qué es distinto de verdad el lunes?»",
    "success_looks_like": "La persona nombra un cambio concreto o admite honestamente que no hay ninguno."
  }$j$::jsonb,
  'Hoy, escribe una frase nombrando qué quieres que sea distinto después de una conversación que has estado evitando. Apunta la frase.',
  $j${
    "says": "Vale. Digamos que sale perfecto. ¿Qué es distinto de verdad el lunes?",
    "model": {
      "line": "Me avisa cuando va a cancelar, en vez de una hora después de cuando quedamos en vernos.",
      "why": "Algo que alguien pudiera hacer distinto el jueves. Sin eso, la conversación no tiene forma de terminar — corre hasta que alguien se cansa y ninguno de los dos sabe si ha pasado algo."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["se dé cuenta", "entienda cómo", "se sienta mal", "lo sienta", "aprecie", "sepa cuánto", "me tome en serio", "me respete"], "requirement": "Algo que pudieran hacer, no algo que pudieran sentir" },
      { "kind": "min_words", "n": 8, "requirement": "Nombra el cambio real" },
      { "kind": "max_words", "n": 30, "requirement": "Una frase" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('worth-having', 3,
  'Lo que cuesta el silencio',
  $md$La decisión de no tenerla se siente gratis, y por eso se sigue tomando.

No es gratis. Sencillamente se paga en un plazo lo bastante largo como para que nadie le atribuya el coste a la decisión. Seis meses después hay una amistad que se ha adelgazado, un compañero al que has dejado de recurrir en silencio, o una pareja que no tiene ni idea de por qué has estado un poco más lejos desde la primavera — y ninguna de esas cosas se archiva como consecuencia de una conversación que nadie tuvo.

**La jugada:** ponle precio al silencio antes de compararlo con la conversación.

La comparación que la gente hace de verdad es entre media hora incómoda y nada. Bajo esa comparación, nada gana siempre, y va a seguir ganando cada vez que se ofrezca — que es por lo que la conversación se aplaza indefinidamente en vez de rechazarse una vez.

La comparación real es entre media hora incómoda y lo que hace tragárselo durante un año. Y hace tres cosas de forma fiable.

**Se convierte.** La irritación no dicha no se queda en su tamaño ni en su forma original. Se convierte en un sentimiento general sobre la persona, luego en una ligera reticencia a hacer planes, luego en una explicación que has construido sobre cómo es.

**Se filtra.** La gente no se le da bien cargar con algo sin que se le note. Sale como brusquedad, como un chiste con filo, como un distanciamiento que la otra persona puede sentir y no puede nombrar — y estar en el lado receptor de eso es peor que que te digan la cosa real.

**Le quita su oportunidad.** Esta es la parte con la que merece la pena ser justo. Alguien a quien no se le ha dicho no puede arreglarlo, no puede disculparse, y no puede decidir que le importa. El silencio parece protegerle y está más cerca de sentenciarle.

Si te quedas con una cosa: el silencio no es neutro. Es un pago más lento de la misma deuda, hecho en una moneda que te gusta menos.$md$,
  $j$[
    {
      "situation": "Se siente más fácil no decir nada.",
      "line": "(¿comparado con qué?)",
      "why": "La comparación que hace la gente es media hora mala contra nada, y nada gana cada vez que se ofrece — que es por lo que se aplaza en vez de rechazarse."
    },
    {
      "situation": "Has empezado a hacer menos planes con esa persona.",
      "line": "(esa es la conversión, seis meses después)",
      "why": "La irritación no dicha no se queda en su tamaño original. Se convierte en un sentimiento general, luego en una reticencia, luego en una teoría sobre cómo es."
    },
    {
      "situation": "La estás protegiendo al no decirlo.",
      "line": "(no pueden arreglar algo que no les han dicho)",
      "why": "El silencio parece protección y está más cerca de una sentencia. No pueden disculparse, no pueden cambiarlo, y no pueden decidir si les importa."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué sigue ganando quedarse callado?",
      "options": [
        { "text": "Porque la gente evita el conflicto.", "correct": false, "note": "Una descripción de quién lo hace, no de por qué la decisión sale así cada vez." },
        { "text": "Porque la comparación que se hace es media hora mala contra nada.", "correct": true, "note": "Bajo esa comparación nada gana cada vez que se ofrece, que es por lo que se aplaza indefinidamente en vez de rechazarse una vez." },
        { "text": "Porque el problema suele resolverse solo.", "correct": false, "note": "Normalmente se convierte en vez de resolverse — en distancia, que no es lo mismo que arreglarse." },
        { "text": "Porque decirlo podría empeorar las cosas.", "correct": false, "note": "El miedo declarado, y no es lo que hace automática la decisión." }
      ],
      "explain": "Ponle precio al silencio, y luego compara. Es un pago más lento de la misma deuda."
    },
    {
      "prompt": "¿Qué es lo que a la gente se le pasa sobre quedarse callado?",
      "options": [
        { "text": "Va a salir de todas formas tarde o temprano.", "correct": false, "note": "A menudo cierto, y plantea el coste como una explosión aplazada en vez de como lo que pasa mientras tanto." },
        { "text": "Te vuelve resentido.", "correct": false, "note": "Cierto, y es el coste para ti. Hay uno para ella que es más fácil pasar por alto." },
        { "text": "Se filtra como brusquedad que pueden sentir y no pueden nombrar.", "correct": false, "note": "Real, y es el segundo de tres. El que a la gente se le pasa por completo es sobre sus opciones." },
        { "text": "Le quita su oportunidad de arreglarlo.", "correct": true, "note": "Alguien a quien no se le ha dicho no puede disculparse, no puede cambiarlo, y no puede decidir si le importa. Eso parece protección y está más cerca de una sentencia." }
      ],
      "explain": "No decirle algo a alguien es una decisión tomada en su nombre sobre algo que es suyo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "priced", "label": "Le puso precio al silencio", "description": "Comparó la conversación con un año de no tenerla." },
      { "key": "noticed_conversion", "label": "Notó la conversión", "description": "Vio cómo el sentimiento ya había cambiado de forma." },
      { "key": "noticed_leak", "label": "Notó la fuga", "description": "Reconoció lo que se notaba sin decirse." },
      { "key": "their_chance", "label": "Consideró su lado", "description": "Vio que el silencio le quita la capacidad de arreglarlo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo que se ha dado cuenta del distanciamiento",
      "mood": "Directo.",
      "openness": 5,
      "personality": "Observador y sin sentimentalismo. Señala lo que de verdad ha cambiado en tu comportamiento en vez de en tus sentimientos."
    },
    "setting": "Seis meses sin decir algo, y un amigo acaba de observar que parece que ves a esa persona mucho menos que antes.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Nombra cambios de comportamiento en vez de interpretar sentimientos.",
      "Pregunta qué sabe la otra persona de todo esto.",
      "Nunca le digas a la persona que tenga la conversación."
    ],
    "opening_beat": "«Antes la veías cada par de semanas. ¿Cuándo dejó de ser así?»",
    "success_looks_like": "La persona conecta el distanciamiento con la conversación que no ha tenido."
  }$j$::jsonb,
  'Hoy, nombra algo que te hayas tragado y qué ha cambiado ya en cómo te comportas con esa persona. Apunta las dos cosas.',
  $j${
    "beats": [
      {
        "situation": "Seis meses sin decir nada. Ahora la ves más o menos un tercio de lo que la veías y has dejado de proponer planes.",
        "prompt": "¿Qué es eso?",
        "options": [
          { "text": "Sencillamente te has puesto más ocupado.", "correct": false, "note": "La explicación que tienes a mano, y merece la pena notar que llegó al mismo tiempo que lo que no dijiste." },
          { "text": "La amistad siguiendo su curso natural.", "correct": false, "note": "Nada de natural en ello. Algo concreto no dicho se convirtió en una reticencia general, en un plazo lo bastante lento como para esconder la causa." },
          { "text": "El silencio siendo pagado, a plazos.", "correct": true, "note": "La irritación no dicha no se queda en su tamaño original. Se convierte en un sentimiento sobre la persona, luego en una reticencia, luego en una teoría sobre cómo es." },
          { "text": "Prueba de que tenías razón sobre ella.", "correct": false, "note": "La teoría llegando puntual. La construiste a partir de seis meses de algo de lo que nunca se le habló." }
        ]
      },
      {
        "situation": "Has estado callado en parte para protegerla de una conversación incómoda.",
        "prompt": "¿Qué le hace eso de verdad?",
        "options": [
          { "text": "Le ahorra algo desagradable.", "correct": false, "note": "Le ahorra treinta minutos y le cuesta que la relación cambie de forma sin que ella lo sepa." },
          { "text": "Nada — no le afecta.", "correct": false, "note": "Está en el lado receptor de alguien que se ha retirado en silencio, que se siente y no se puede nombrar." },
          { "text": "Le quita su oportunidad de hacer algo al respecto.", "correct": true, "note": "No puede disculparse, no puede cambiarlo, y no puede decidir si le importa. Eso parece protección y está más cerca de una sentencia." },
          { "text": "Mantiene la paz para los dos.", "correct": false, "note": "Mantiene una superficie. Debajo, una persona se está distanciando y la otra no sabe por qué." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('worth-having', 4,
  'Dejarlo ir, de verdad',
  $md$No todo merece una conversación, y decidir eso es un resultado legítimo de este bloque y no un fracaso de él.

Pero hay dos versiones de dejar ir y solo una de ellas funciona.

**La jugada:** decide que está abandonado, y luego compórtate como si lo estuviera.

La versión real es una decisión. Lo has mirado, has concluido que el cambio que querrías no merece la conversación, y ahora vas a tratar el asunto como cerrado — lo que significa no sacarlo, no aludir a ello, y no guardarlo de reserva.

La otra versión es lo que hace la mayoría de la gente: decidir no sacarlo mientras se sigue cargando con ello. Eso no es dejar ir, es almacenar, y las cosas almacenadas se comportan mal. Se acumulan, se pegan a nuevos casos, y con el tiempo llegan a una conversación que era sobre otra cosa — normalmente en la forma *y otra cosa*, que es el sonido de once meses de almacenamiento descargándose sobre alguien que creía que estaba hablando de fregar los platos.

La prueba de cuál de las dos has hecho es sencilla y algo incómoda. Si volviera a pasar la semana que viene, ¿estarías a cero o estarías a tres? Dejar ir de verdad te reinicia. Almacenar significa que el siguiente caso llega encima de una pila, y vas a reaccionar a la pila mientras pareces reaccionar al caso.

Hay una segunda prueba que merece la pena aplicar un mes después: ¿sigues pensando en ello? Algunas cosas no se pueden dejar ir con solo decidirlo, y averiguar eso es útil — significa que la respuesta a la primera pregunta de este bloque era de verdad sí, y prefieres saberlo a un mes que a un año.

Y sé honesto sobre el tamaño del asunto. Las cosas pequeñas que se repiten suelen ser mejores sacándolas que dejándolas caer, precisamente porque son pequeñas: una conversación de dos minutos sobre un problema de dos minutos es fácil, y la misma conversación después de un año es sobre el año y no sobre el problema.

Si te quedas con una cosa: abandonado significa que estarías a cero la próxima vez. Si estarías a tres, no lo dejaste ir — lo archivaste.$md$,
  $j$[
    {
      "situation": "Has decidido no sacar algo.",
      "line": "(¿estarías a cero si pasara la semana que viene?)",
      "why": "Dejar ir de verdad te reinicia. Si la respuesta es tres, no lo dejaste ir — lo archivaste, y va a llegar más tarde pegado a otra cosa."
    },
    {
      "situation": "Ha pasado un mes y todavía piensas en ello.",
      "line": "(entonces no se podía dejar ir)",
      "why": "Información útil en vez de un fracaso. Significa que la respuesta honesta a si importaba era sí, y un mes es un momento mucho mejor para aprender eso que un año."
    },
    {
      "situation": "Es algo pequeño que sigue pasando.",
      "line": "(pequeño es el argumento para sacarlo, no en contra)",
      "why": "Una conversación de dos minutos sobre un problema de dos minutos es fácil. La misma conversación un año después es sobre el año."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la prueba de si de verdad lo dejaste ir?",
      "options": [
        { "text": "Si todavía te sientes molesto.", "correct": false, "note": "Los sentimientos se desvanecen a su propio ritmo y pueden desvanecerse mientras la cosa sigue almacenada." },
        { "text": "Si estarías a cero si volviera a pasar la semana que viene.", "correct": true, "note": "Dejar ir de verdad te reinicia. Almacenar significa que el siguiente caso cae en una pila, y reaccionas a la pila mientras pareces reaccionar al caso." },
        { "text": "Si has dejado de hablar de ello con otra gente.", "correct": false, "note": "Una señal decente y fácil de conseguir mientras se sigue cargando con ello." },
        { "text": "Si podrías sacarlo con calma ahora.", "correct": false, "note": "Poder sacarlo con calma es un buen estado y no es lo mismo que haberlo dejado ir." }
      ],
      "explain": "Abandonado significa que el contador está a cero. Archivado significa que está esperando."
    },
    {
      "prompt": "Algo pequeño sigue pasando. ¿A favor de qué argumenta lo pequeño?",
      "options": [
        { "text": "Dejarlo ir — no merece una conversación.", "correct": false, "note": "No merece una grande, que es el argumento para tener una pequeña ahora en vez de una grande más tarde." },
        { "text": "Esperar a ver si hay un patrón.", "correct": false, "note": "Vigilar un patrón es almacenar con presupuesto de investigación, y la conversación que acabas teniendo es sobre el patrón, no sobre la cosa." },
        { "text": "Sacarlo, porque es pequeño.", "correct": true, "note": "Una conversación de dos minutos sobre un problema de dos minutos es fácil. La misma conversación después de un año es sobre el año, no sobre el problema." },
        { "text": "Mencionarlo de pasada, con ligereza.", "correct": false, "note": "Cerca, y de pasada suele significar sin ninguna petición, que es la versión que se oye como un estado de ánimo." }
      ],
      "explain": "El tamaño es el argumento para la rapidez. Las cosas pequeñas se vuelven caras al almacenarse."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "decided", "label": "Decidió de verdad", "description": "Tomó una decisión real en vez de un aplazamiento." },
      { "key": "at_zero", "label": "Se reinició a cero", "description": "Empezaría de cero si se repitiera." },
      { "key": "no_storage", "label": "No lo archivó", "description": "No guardó nada de reserva para una conversación futura." },
      { "key": "checked_later", "label": "Comprobó un mes después", "description": "Se fijó en si seguía ahí." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo comprobando si de verdad lo has dejado ir",
      "mood": "Curioso.",
      "openness": 5,
      "personality": "Pregunta qué pasa si vuelve a ocurrir la semana que viene, y nota la diferencia entre abandonado y almacenado."
    },
    "setting": "Has decidido dejar ir algo, y un amigo te está preguntando qué significa eso en la práctica.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta cuál sería la reacción a que se repita.",
      "Señala con suavidad cuando una respuesta describe almacenamiento en vez de liberación.",
      "Nunca le digas a la persona cuál hacer."
    ],
    "opening_beat": "«Vale — lo estás dejando ir. ¿Qué pasa si lo vuelve a hacer el viernes?»",
    "success_looks_like": "La persona establece si lo ha dejado ir o lo ha archivado."
  }$j$::jsonb,
  'Hoy, coge algo que decidiste dejar ir y comprueba si estarías a cero la próxima vez. Apunta la respuesta honesta.',
  $j${
    "says": "Vale — lo estás dejando ir. ¿Qué pasa si lo vuelve a hacer el viernes?",
    "model": {
      "line": "La verdad, estaría furioso. Así que no lo he dejado ir, solo he decidido no mencionarlo.",
      "why": "La prueba, respondida con honestidad. Dejar ir de verdad te reinicia a cero; almacenar significa que el siguiente caso cae en una pila y reaccionas a la pila mientras pareces reaccionar al caso."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Di qué sentirías de verdad" },
      { "kind": "forbids_any", "words": ["estaría bien", "sin problema", "no me molestaría", "superado", "agua pasada", "pasado página", "no importa"], "requirement": "No reclames una paz que no tienes" },
      { "kind": "min_words", "n": 10, "requirement": "Responde a la prueba, no a la pregunta" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('worth-having', 5,
  'Ponle una fecha',
  $md$Todo en este bloque se resuelve en una de dos respuestas, y las dos son decisiones. Lo que no es una decisión es el estado en el que está de verdad casi todo el mundo, que es *pronto*.

**La jugada:** nombra el día en que la vas a tener, o di en voz alta que no la vas a tener.

*Pronto* es donde van a vivir indefinidamente las conversaciones difíciles. No es un plan y nunca se convierte en uno, porque no hay ningún momento en el que llegue pronto — cada día en concreto es un mal día para ello, y cada uno de esos juicios es correcto en sus propios términos.

Una fecha resuelve eso de una forma que ninguna cantidad de determinación logra. *El jueves por la tarde* es algo que o hiciste o no hiciste, y convierte un sentimiento en una cita. También le pone un suelo al ensayo: el bucle solo corre hasta el jueves, y saber eso hace que la semana anterior sea considerablemente más fácil que una sin fin.

Antes es mejor y no va solo de valentía. La cercanía en el tiempo está haciendo un trabajo real — una conversación sobre algo que pasó la semana pasada es sobre esa cosa, mientras que la misma conversación cuatro meses después es sobre cuatro meses, y la otra persona va a preguntar con toda razón por qué solo se entera ahora. Esa pregunta no tiene una buena respuesta y cambia el tema hacia tu silencio.

Si la respuesta honesta es que no la vas a tener, di eso en voz alta también, a ti mismo o a alguien más, y luego aplica la lección anterior como es debido. Lo que no puedes hacer es dejarlo en *pronto*, porque esa es la opción que más cuesta: consigues toda la incomodidad de cargar con ello y nada de lo que la conversación podría haber producido.

Y ponlo en el calendario en vez de en tu cabeza. Suena excesivo para algo que podrías organizar en un mensaje, y el exceso es el punto — algo con una fecha pegada se hace, y algo con una intención pegada es lo que ya has tenido durante cuatro semanas.

Si te quedas con una cosa: un día, o una decisión de no tenerla. Pronto es la única respuesta que no es una respuesta.$md$,
  $j$[
    {
      "situation": "Has decidido tenerla, pronto.",
      "line": "(pronto no es un plan)",
      "why": "No hay ningún momento en el que llegue pronto. Cada día en concreto es un mal día para ello, y cada uno de esos juicios es correcto en sus propios términos."
    },
    {
      "situation": "Estás esperando un buen momento.",
      "line": "(nombra el jueves)",
      "why": "Una fecha convierte un sentimiento en una cita, y le pone un suelo al ensayo — el bucle solo tiene que correr hasta el jueves."
    },
    {
      "situation": "Pasó hace cuatro meses.",
      "line": "(ahora es sobre los cuatro meses)",
      "why": "Va a preguntar por qué solo se entera ahora, y esa pregunta no tiene una buena respuesta. Cambia el tema hacia tu silencio."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué nunca llega pronto?",
      "options": [
        { "text": "Porque sigues perdiendo el valor.", "correct": false, "note": "El valor es la historia. El mecanismo es que ningún día en concreto es nunca el correcto." },
        { "text": "Porque cada día en concreto es un mal día para ello.", "correct": true, "note": "Y cada uno de esos juicios es correcto en sus propios términos, que es por lo que la secuencia de decisiones correctas produce cuatro meses de nada." },
        { "text": "Porque no estás lo bastante enfadado.", "correct": false, "note": "Esperar a estar lo bastante enfadado es un plan para tener la conversación en tu peor momento." },
        { "text": "Porque el momento tiene que sentirse correcto.", "correct": false, "note": "Esa creencia es parte de la trampa, no una explicación de ella." }
      ],
      "explain": "Una fecha es algo que o hiciste o no hiciste. Pronto no se puede comprobar."
    },
    {
      "prompt": "¿Por qué cambia el retraso de qué trata la conversación?",
      "options": [
        { "text": "Los recuerdos se vuelven menos fiables.", "correct": false, "note": "Cierto y secundario. Los dos vais a recordar lo esencial lo bastante bien." },
        { "text": "El sentimiento se hace más grande.", "correct": false, "note": "Se convierte en vez de crecer, y eso es el asunto de la lección anterior." },
        { "text": "Va a preguntar por qué solo se entera ahora.", "correct": true, "note": "Una pregunta sin buena respuesta, y responderla mueve el tema de la cosa a tu silencio sobre la cosa." },
        { "text": "Se le habrá olvidado.", "correct": false, "note": "De vez en cuando, y que se lo recuerden es un pequeño obstáculo, no un cambio de tema." }
      ],
      "explain": "La conversación de la semana pasada es sobre la cosa. Cuatro meses después es sobre cuatro meses."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "a_date", "label": "Nombró un día", "description": "Se comprometió a cuándo en vez de a pronto." },
      { "key": "in_calendar", "label": "Lo apuntó", "description": "Lo puso en algún sitio que no fuera su cabeza." },
      { "key": "soon", "label": "Rechazó pronto", "description": "No lo dejó en el estado indefinido." },
      { "key": "or_dropped", "label": "O dijo que no en voz alta", "description": "Tomó la otra decisión explícitamente en vez de por defecto." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo con quien lo has estado hablando",
      "mood": "Cálido e inamovible en este único punto.",
      "openness": 5,
      "personality": "Pide un día y no acepta pronto, esta semana, o cuando llegue el momento."
    },
    "setting": "Has averiguado qué quieres decir y qué quieres cambiar. Es domingo.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Vuelve a pedir un día concreto si te dan pronto, esta semana, o cuando salga el tema.",
      "Acepta una decisión clara de no tenerla como una respuesta real.",
      "Nunca sugieras tú un día."
    ],
    "opening_beat": "«Bien. ¿Cuándo?»",
    "success_looks_like": "La persona nombra un día real o dice claramente que no lo va a hacer."
  }$j$::jsonb,
  'Hoy, pon una fecha en tu calendario para una conversación que has estado posponiendo — o apunta que no la vas a tener. Apunta cuál.',
  $j${
    "says": "Bien. ¿Cuándo?",
    "model": {
      "line": "El jueves por la tarde, después del trabajo. Le escribo mañana para proponerlo.",
      "why": "Un día en vez de una intención, que convierte un sentimiento en una cita — y le pone un suelo al ensayo, porque el bucle solo tiene que correr hasta el jueves."
    },
    "checks": [
      { "kind": "contains_any", "words": ["lunes", "martes", "miércoles", "jueves", "viernes", "sábado", "domingo", "mañana", "esta noche", "fin de semana"], "requirement": "Nombra un día real" },
      { "kind": "forbids_any", "words": ["pronto", "esta semana en algún momento", "en algún momento", "cuando la vea", "la próxima vez", "cuando llegue el momento", "cuando salga el tema", "cuando me sienta preparado"], "requirement": "Pronto es la única respuesta que no es una respuesta" },
      { "kind": "max_words", "n": 25, "requirement": "Una fecha, no un plan para un plan" }
    ]
  }$j$::jsonb
);
