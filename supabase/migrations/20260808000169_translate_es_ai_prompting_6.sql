-- Spanish: Escribir prompts a la IA, track 6 — No externalices las repeticiones.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partners: "Marcus" (lesson 1) masculine. "Robin" (lessons 2, 3) —
-- unisex/no-sex-field, masculine default. "Nadia" (lesson 4) —
-- established feminine exception. "Sam" (lesson 5) — unisex, masculine
-- default. Completes the AI Prompting topic (all 6 tracks).

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

select pg_temp.es_lesson('do-not-outsource-the-reps', 1,
  'Nunca en el momento',
  $md$Todo lo útil de este tema pasa antes de una conversación o después de ella. Nada útil pasa durante una.

**La jugada:** prepara antes, revisa después, nada en directo.

La objeción práctica primero, porque resuelve la mayoría de los casos por sí sola: no funciona. Leer una pantalla a mitad de conversación te cuesta aquello de lo que estaba hecha la conversación. Dejas de escuchar, tu ritmo se va, y respondes a la frase de hace diez segundos. La gente puede ver que pasa, y lo que ve es a alguien que se ha ido.

Luego la que importa más. Una conversación que superaste con ayuda no te enseña nada sobre la siguiente, y la siguiente no va a tener ninguna. La incomodidad que esquivaste era donde estaba la mejora — eso no es una afirmación moralista, es cómo funciona cualquier habilidad. Una repetición que no hiciste es una repetición que no hiciste.

Aquí también está en juego toda la promesa de la app. Reps existe para hacerte mejor en esto, y mejor significa que la cosa pasa en ti en vez de en un dispositivo. La asistencia en directo produce una persona que rinde bien con un teléfono y no mejor sin uno, que es un resultado peor que nunca haberlo usado, porque se siente como progreso.

La línea no siempre es obvia, así que unos cuantos casos.

**Buscar algo a mitad de conversación que habrías buscado de todos modos** — una fecha, una ortografía, el nombre del sitio — está bien y siempre lo estuvo. Eso es un hecho, no una réplica.

**Redactar una respuesta en un chat mientras le escribes a alguien** es asistencia en directo, se sienta como se sienta. Se aplican las reglas de Mensajería y la herramienta no es una de ellas.

**Salir de una reunión para pensar** es legítimo y no es esto. Pensar está permitido.

**Una conversación escrita que pasa en tiempo real** es el caso genuinamente difícil. Si no lo usarías en una sala, no lo uses aquí.

Si te quedas con una cosa: antes y después, nunca durante. Una repetición que no hiciste es una repetición que no hiciste.$md$,
  $j$[
    {
      "situation": "Quieres ayuda mientras la conversación está pasando.",
      "line": "(antes o después — no ahora)",
      "why": "Dejas de escuchar y respondes a la frase de hace diez segundos. Lo que ve la gente es a alguien que se ha ido."
    },
    {
      "situation": "Necesitas una fecha o una ortografía a mitad de conversación.",
      "line": "(eso está bien — es un hecho)",
      "why": "Buscar algo que habrías buscado de todos modos nunca fue el problema."
    },
    {
      "situation": "Es una conversación escrita que pasa en tiempo real.",
      "line": "(si no lo harías en una sala, no lo hagas aquí)",
      "why": "El caso difícil, y la prueba es la misma."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la objeción más fuerte a la ayuda en directo?",
      "options": [
        { "text": "Es deshonesto.", "correct": false, "note": "Discutible y no es el motivo estructural. Prepararse tampoco es deshonesto." },
        { "text": "Te pillan mirando el teléfono.", "correct": false, "note": "La práctica, y que no te vieran no haría que funcionara." },
        { "text": "Es lento.", "correct": false, "note": "Lo es, y la velocidad es un síntoma del coste real." },
        { "text": "No aprendes nada, y la siguiente no tiene ayuda.", "correct": true, "note": "La incomodidad que esquivaste era donde estaba la mejora. Una repetición que no hiciste es una repetición que no hiciste." }
      ],
      "explain": "Antes y después. Nada en directo."
    },
    {
      "prompt": "¿Cuál de estas no es asistencia en directo?",
      "options": [
        { "text": "Redactar una respuesta mientras le escribes a alguien.", "correct": false, "note": "En directo, se sienta como se sienta. Se aplican las reglas de Mensajería y esta no es una de ellas." },
        { "text": "Salir de una reunión para pensar.", "correct": true, "note": "Pensar está permitido, y siempre lo estuvo. Esto no es lo que se está descartando." },
        { "text": "Comprobar qué decir a continuación a mitad de llamada.", "correct": false, "note": "El caso central." },
        { "text": "Hacer que escuche y sugiera frases.", "correct": false, "note": "La versión más en directo que hay." }
      ],
      "explain": "Buscar un hecho que habrías buscado de todos modos también está bien."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "not_during", "label": "Nada en directo", "description": "Sin ayuda a mitad de conversación." },
      { "key": "prepared", "label": "Preparó antes", "description": "Hizo el trabajo con antelación en su lugar." },
      { "key": "reviewed", "label": "Revisó después", "description": "Se llevó el aprendizaje después." },
      { "key": "present", "label": "Se quedó en la sala", "description": "Escuchó en vez de gestionar una pantalla." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Marcus",
      "role": "un amigo a mitad de conversación contigo",
      "mood": "Paciente.",
      "openness": 5,
      "personality": "Nota la pausa y espera, sin llenar el silencio."
    },
    "setting": "Estás en una conversación que se ha vuelto difícil y tu mano ha ido hacia el teléfono.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Espera durante la pausa sin ayudar.",
      "Acepta una respuesta torpe con calidez.",
      "Nunca menciones el teléfono directamente."
    ],
    "opening_beat": "«...te has ido a otro sitio.»",
    "success_looks_like": "La persona se queda en la conversación y responde mal en vez de bien."
  }$j$::jsonb,
  'Hoy, supera un momento difícil sin comprobar nada. Apunta qué dijiste en su lugar.',
  $j${
    "beats": [
      {
        "situation": "Una conversación se ha vuelto difícil y tu mano ha ido hacia el teléfono.",
        "prompt": "¿Cuál es el motivo más fuerte para no hacerlo?",
        "options": [
          { "text": "Te van a ver haciéndolo.", "correct": false, "note": "Te van a ver, y que no te vieran no haría que funcionara." },
          { "text": "Es demasiado lento para ser útil.", "correct": false, "note": "Lo es, y la lentitud es un síntoma del coste real más que el coste en sí." },
          { "text": "Una repetición que no hiciste es una repetición que no hiciste.", "correct": true, "note": "La incomodidad que esquivaste era donde estaba la mejora, y la próxima conversación tampoco va a tener ayuda." },
          { "text": "Sería deshonesto.", "correct": false, "note": "Discutible, y prepararse no es deshonesto, así que la honestidad no es lo que separa las dos cosas." }
        ]
      },
      {
        "situation": "Necesitas una fecha que no puedes recordar, en mitad de la conversación.",
        "prompt": "¿Es eso lo mismo?",
        "options": [
          { "text": "No — es un hecho, y lo habrías buscado de todos modos.", "correct": true, "note": "Buscar algo nunca fue el problema. La línea trata de qué decir, no de qué es verdad." },
          { "text": "Sí, cualquier uso del teléfono rompe la regla.", "correct": false, "note": "Demasiado amplio, y haría que la regla fuera inútil en la práctica." },
          { "text": "Solo si lo haces abiertamente.", "correct": false, "note": "La apertura es cortesía más que la distinción." },
          { "text": "Sí, porque interrumpe la conversación.", "correct": false, "note": "Brevemente, y la interrupción no es lo que protege la regla." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('do-not-outsource-the-reps', 2,
  'Cuando el esfuerzo es el mensaje',
  $md$El segundo bloque argumentó que prepararse no es fingir, y no lo es. Hay una línea real, sin embargo, y es esta.

Para un conjunto concreto de mensajes, el contenido es casi lo de menos. El pésame. La disculpa. El agradecimiento que de verdad se siente. La felicitación a alguien que va a recordar quién dijo algo. Lo que esos mensajes comunican no son sus frases. Es que alguien se paró, pensó en ti, y lo hizo.

**La jugada:** cuando el esfuerzo es el mensaje, escríbelo tú mismo, mal.

Externalizada, una frase mejor vale menos que nada. Si alguna vez se nota — y la cuarta lección de Edita, no escribas es una lista de cómo se nota — el daño no es que la escritura fuera asistida. Es el descubrimiento retrospectivo de que el pensamiento no estaba ahí, que es precisamente lo que el mensaje existía para transmitir. Una nota torpe es cálida. Una nota pulida que resulta haber sido generada es más fría que el silencio.

*No supe qué decir cuando me enteré* es un mensaje de pésame completo. También es verdad, que es por lo que funciona. Nada que se pudiera escribir por ti va a mejorarlo, y cada mejora lo empeora en la misma dirección: va a sonar como si hubiera sido fácil de escribir, y no se suponía que fuera fácil de escribir.

Lo mismo vale para una disculpa, con un filo adicional. Una disculpa es una demostración de que has pensado en lo que hiciste. Una generada es una demostración de que no lo has hecho, digan lo que digan sus palabras.

La prueba es una pregunta: **¿es el esfuerzo parte de lo que esto comunica?** Si la respuesta es sí, es tuyo. Casi todo lo demás — la petición, el arreglo, la actualización, la respuesta a un casero, la nota de presentación — no lo es, y ahí la herramienta está bien y toda esta objeción no se aplica.

Un caso más suave que merece la pena permitir. Si no puedes empezar en absoluto, y la alternativa es que el mensaje no se envíe en tres semanas, entonces dos frases malas tuyas ganan al silencio y el tercer bloque ya te dice cómo producirlas. Lo que no debes hacer es entregar el sentimiento.

Si te quedas con una cosa: si el esfuerzo es el mensaje, tu frase peor es la mejor.$md$,
  $j$[
    {
      "situation": "Alguien ha tenido malas noticias.",
      "line": "No supe qué decir cuando me enteré.",
      "why": "Un mensaje completo, y es verdad. Cada mejora hace que suene como si hubiera sido fácil de escribir."
    },
    {
      "situation": "Le debes una disculpa a alguien.",
      "line": "(esta es tuya)",
      "why": "Una disculpa demuestra que pensaste en lo que hiciste. Una generada demuestra lo contrario, digan lo que digan sus palabras."
    },
    {
      "situation": "No puedes empezar en absoluto.",
      "line": "(dos frases malas tuyas ganan a tres semanas de silencio)",
      "why": "Que se envíe importa. Lo que no debes entregar es el sentimiento."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la prueba?",
      "options": [
        { "text": "Si el mensaje es personal.", "correct": false, "note": "Cerca, y muchos mensajes personales son pura logística." },
        { "text": "Si les molestaría saberlo.", "correct": false, "note": "Una consecuencia de la respuesta más que la prueba en sí." },
        { "text": "¿Es el esfuerzo parte de lo que esto comunica?", "correct": true, "note": "Si la respuesta es sí, es tuyo. Casi todo lo demás no lo es, y ahí la objeción no se aplica en absoluto." },
        { "text": "Si trata de sentimientos.", "correct": false, "note": "Se solapa, y una actualización cálida sobre un proyecto no está en esta categoría." }
      ],
      "explain": "Tu frase peor es la mejor."
    },
    {
      "prompt": "¿Por qué un pésame pulido es peor que uno torpe?",
      "options": [
        { "text": "La escritura torpe conmueve más.", "correct": false, "note": "No en general — esto trata de un tipo concreto de mensaje." },
        { "text": "La escritura pulida suena insincera.", "correct": false, "note": "No inherentemente. Mucha gente sincera escribe bien." },
        { "text": "Es más larga, y la longitud está mal aquí.", "correct": false, "note": "A menudo cierto y no es el mecanismo." },
        { "text": "Suena como si hubiera sido fácil de escribir.", "correct": true, "note": "Y no se suponía que fuera fácil. El esfuerzo era el contenido." }
      ],
      "explain": "Más frío que el silencio, si alguna vez se nota."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "own_words", "label": "Lo escribió él mismo", "description": "Sin ayuda con el sentimiento." },
      { "key": "test", "label": "Aplicó la prueba", "description": "Preguntó si el esfuerzo era el contenido." },
      { "key": "sent_it", "label": "Lo envió", "description": "No dejó que la regla se convirtiera en silencio." },
      { "key": "tool_elsewhere", "label": "Igualmente lo usó en otros sitios", "description": "Logística y peticiones sin afectar." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "un amigo sentado contigo",
      "mood": "Suave.",
      "openness": 5,
      "personality": "Pregunta qué dirías si estuvieran en la sala, y trata la respuesta como suficiente."
    },
    "setting": "Un amigo ha tenido malas noticias y llevas día y medio mirando fijamente el cuadro de mensaje.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué dirían en voz alta.",
      "Trata una respuesta corta e incómoda como completa.",
      "Nunca sugieras ninguna redacción."
    ],
    "opening_beat": "«Si estuvieran aquí, ¿qué dirías?»",
    "success_looks_like": "La persona escribe algo llano y verdadero con sus propias palabras."
  }$j$::jsonb,
  'Hoy, escribe un mensaje donde el esfuerzo sea el punto, con tus propias palabras. Apunta qué enviaste.',
  $j${
    "says": "Si estuvieran aquí, ¿qué dirías?",
    "model": {
      "line": "Simplemente diría que no supe qué decir cuando me enteré, y que estoy disponible si quieren compañía.",
      "why": "Un mensaje completo, y es verdad. Cada mejora hace que suene como si hubiera sido fácil de escribir, y no se suponía que lo fuera."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["mi más sentido pésame", "mis pensamientos están contigo", "durante este momento difícil", "lo siento mucho por tu pérdida", "si hay algo que pueda hacer"], "requirement": "No recurras a un registro escrito" },
      { "kind": "min_words", "n": 8, "requirement": "Di la cosa llana y verdadera" },
      { "kind": "max_words", "n": 32, "requirement": "Corto es correcto aquí" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('do-not-outsource-the-reps', 3,
  'Envía la sexta en frío',
  $md$Usada bien, esta es una herramienta que enseña. Usada siempre, es una herramienta que sustituye — y las dos se ven idénticas desde dentro, porque ambas producen buenos mensajes.

**La jugada:** pasa cinco por ella, y luego envía la sexta sin.

La distinción que importa es dónde acaba viviendo la habilidad. Si los hábitos se están transfiriendo, vas a notar que escribes la petición en la primera línea antes de que nadie lo sugiera, que borras *solo* mientras lo escribes, que cortas la disculpa antes de terminarla. Si no se están transfiriendo, vas a seguir produciendo el mismo primer borrador de siempre, corregido cada vez por otra cosa, indefinidamente.

Solo hay una forma de descubrir cuál de las dos está pasando, y es enviar algo sin comprobarlo.

Hazlo deliberadamente en vez de por accidente. Elige un mensaje que importe un poco — ni el difícil ni una respuesta de una palabra — escríbelo, aplica lo que sabes, y envíalo. Luego, después, pásalo por la herramienta y mira qué habría cambiado. Ese orden es todo el ejercicio: la respuesta llega después de que el mensaje se haya ido, así que es información en vez de una red de seguridad.

La mayoría de la gente descubre que la sexta está bien, y que está bien de las formas concretas que ha estado practicando: más corta, la petición primero, sin encogimiento al principio. Las correcciones que vuelven son más pequeñas de lo esperado, y a menudo son estilísticas en vez de estructurales.

Alguna gente descubre lo contrario, y eso es más útil que un mensaje que está bien. Te dice qué hábitos no se han transferido, y ahora sabes qué dos cosas vigilar a mano.

Mantén la proporción en movimiento. Cinco y uno se convierte en tres y uno se convierte en la comprobación ocasional de algo que importa. El estado final no es nunca usarla — es usarla para las cosas de la lista del tercer bloque, sobre un borrador al que no le hacía falta mucho.

Si te quedas con una cosa: envía algo sin comprobar a propósito. Es la única forma de descubrir dónde vive la habilidad.$md$,
  $j$[
    {
      "situation": "Todo lo que envías lleva un mes comprobado.",
      "line": "(envía la próxima en frío)",
      "why": "Es la única forma de descubrir si los hábitos están en ti o en la herramienta."
    },
    {
      "situation": "De todos modos quieres aprender de ello.",
      "line": "(pásalo por la herramienta después de enviar)",
      "why": "La respuesta llega después de que el mensaje se haya ido, lo cual la convierte en información en vez de una red de seguridad."
    },
    {
      "situation": "La fría volvió necesitando cambios reales.",
      "line": "(ahora sabes cuáles dos vigilar)",
      "why": "Más útil que un mensaje que estaba bien, porque nombra los hábitos que no se han transferido."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué enviarlo antes de comprobar en vez de después?",
      "options": [
        { "text": "Ahorra tiempo.", "correct": false, "note": "El mismo trabajo de cualquier forma, en otro orden." },
        { "text": "Comprobar después lo convierte en información, no en una red.", "correct": true, "note": "El mensaje se ha ido, así que la respuesta enseña en vez de rescatar. Ese orden es todo el ejercicio." },
        { "text": "Vas a ser más honesto al respecto.", "correct": false, "note": "Posiblemente, y la honestidad no es lo que protege el orden." },
        { "text": "El mensaje va a ser mejor.", "correct": false, "note": "Muy probablemente va a ser un poco peor. Ese es el precio de descubrirlo." }
      ],
      "explain": "Cinco por la herramienta, y luego la sexta en frío."
    },
    {
      "prompt": "¿Qué te dice un mensaje en frío que necesita cambios reales?",
      "options": [
        { "text": "Deberías seguir comprobándolo todo.", "correct": false, "note": "La conclusión contraria. Significa que la transferencia todavía no ha pasado, así que hace falta que empiece." },
        { "text": "Los hábitos nunca iban a transferirse.", "correct": false, "note": "Demasiado fatalista. Se transfieren con práctica, que es lo que es esto." },
        { "text": "Elegiste un mensaje demasiado difícil.", "correct": false, "note": "Posible, y el arreglo es seguir adelante en vez de retirarse a otros más fáciles." },
        { "text": "Qué dos hábitos vigilar a mano.", "correct": true, "note": "Más útil que un mensaje que estaba bien, porque nombra qué todavía no ha calado." }
      ],
      "explain": "Luego mantén la proporción en movimiento: cinco y uno, tres y uno, ocasional."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "cold", "label": "Envió uno sin comprobar", "description": "Deliberadamente, no por accidente." },
      { "key": "after", "label": "Comprobó después", "description": "Aprendió sin que lo rescataran." },
      { "key": "named", "label": "Nombró qué no se había transferido", "description": "Sabe qué hábitos vigilar." },
      { "key": "ratio", "label": "Movió la proporción", "description": "Comprobando menos que el mes pasado." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "un amigo sentado contigo",
      "mood": "Interesado.",
      "openness": 5,
      "personality": "Pregunta cuándo fue la última vez que enviaste algo sin pasarlo por nada."
    },
    "setting": "Llevas más o menos un mes sin enviar un mensaje sin comprobar y eres consciente de ello.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué pasaría si se enviara sin comprobar.",
      "Date por satisfecho con el compromiso de un mensaje.",
      "Nunca comentes la escritura en sí."
    ],
    "opening_beat": "«¿Cuándo fue la última vez que enviaste uno sin más?»",
    "success_looks_like": "La persona se compromete a enviar la próxima en frío."
  }$j$::jsonb,
  'Hoy, envía un mensaje sin comprobarlo, y luego míralo después. Apunta la diferencia.',
  $j${
    "says": "¿Cuándo fue la última vez que enviaste uno sin más?",
    "model": {
      "line": "Llevo como un mes sin hacerlo. La próxima va en frío, y voy a mirarla después para ver qué se me escapó.",
      "why": "Enviar primero convierte la respuesta en información en vez de en una red de seguridad, y es la única forma de descubrir dónde vive la habilidad."
    },
    "checks": [
      { "kind": "contains_any", "words": ["frío", "sin", "sin comprobar", "envía sin más", "directo", "la próxima"], "requirement": "Comprométete a enviar uno sin comprobar" },
      { "kind": "forbids_any", "words": ["compruébalo primero", "pásalo por", "solo por seguridad", "échale un vistazo rápido", "si es importante voy a"], "requirement": "No mantengas la red de seguridad" },
      { "kind": "max_words", "n": 35, "requirement": "Un compromiso, no un plan" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('do-not-outsource-the-reps', 4,
  'Pulir es evitación',
  $md$Cuarenta minutos en un mensaje de dos líneas no es cuidado. Es la misma evitación que no enviarlo, disfrazada de trabajo.

**La jugada:** date cuenta de la tercera versión, y envíala.

La señal es que se siente productivo. La evitación genuina — cerrar el portátil, salir a caminar, decidir hacerlo mañana — se anuncia a sí misma, y sabes qué estás haciendo mientras lo haces. Pulir no. Estás trabajando en el mensaje. Llevas una hora trabajando en él. Cada pasada hace una pequeña mejora, y el mensaje no se ha enviado, que era lo único que iba a importar de verdad.

La herramienta hace que esto sea mucho más fácil de hacer, porque siempre va a producir otra versión. No hay ningún punto de parada natural, ninguna fricción, y ningún momento en el que algo diga *ya es suficiente*. Una persona editando por su cuenta eventualmente se aburre. Esto no.

Tres señales, en el orden en que suelen aparecer.

**Has empezado a revertir cambios anteriores.** Volver a poner una frase que cortaste dos versiones atrás es la señal más clara posible de que has dejado de mejorar y has empezado a dar vueltas.

**Los cambios se están haciendo más pequeños.** Elección de palabras en vez de estructura. La estructura merecía varias pasadas y la elección de palabras no merece ninguna.

**Estás comprobando cómo suena en vez de qué dice.** Ese es el territorio del bloque anterior, y no tiene respuesta, que es exactamente por lo que puede absorber una hora.

La regla que lo acaba: **dos pasadas.** Una para la estructura, una para los recortes. Luego envía. Si de verdad hace falta una tercera pasada, el mensaje es más difícil de lo que parecía y probablemente pertenece al último bloque de Mensajería, donde la respuesta es una llamada.

Y date cuenta de qué te está protegiendo la hora. No es un mensaje malo. Es el momento después de enviar, cuando está fuera de tus manos. Ese momento va a llegar de todos modos, y cada versión lo retrasa exactamente la duración de la versión.

Si te quedas con una cosa: dos pasadas, y envía. Si estás volviendo a poner lo que cortaste, terminaste hace rato.$md$,
  $j$[
    {
      "situation": "Estás volviendo a poner una frase que cortaste dos versiones atrás.",
      "line": "(terminaste hace rato)",
      "why": "La señal más clara posible de que has dejado de mejorar y has empezado a dar vueltas."
    },
    {
      "situation": "Los cambios se han convertido en elección de palabras.",
      "line": "(la estructura merecía pasadas — esto no)",
      "why": "Dos pasadas: una para la estructura, una para los recortes. Luego envía."
    },
    {
      "situation": "Estás preguntando cómo va a sonar.",
      "line": "(sin respuesta, que es por lo que se lleva una hora)",
      "why": "Es el territorio del bloque anterior, y no hay ninguna versión de ello que se resuelva."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hace que pulir sea más difícil de detectar que la evitación ordinaria?",
      "options": [
        { "text": "Produce un mensaje mejor.", "correct": false, "note": "Marginalmente, durante las dos primeras pasadas, y luego nada en absoluto." },
        { "text": "Es más rápido.", "correct": false, "note": "Es mucho más lento, que es parte del coste." },
        { "text": "Se siente productivo.", "correct": true, "note": "Cerrar el portátil se anuncia a sí mismo. Trabajar en el mensaje no, y cada pasada hace una pequeña mejora." },
        { "text": "Otra gente lo anima.", "correct": false, "note": "Nadie sabe que lo estás haciendo." }
      ],
      "explain": "Dos pasadas, y envía."
    },
    {
      "prompt": "¿De qué te está protegiendo la hora en realidad?",
      "options": [
        { "text": "Enviar algo mal escrito.", "correct": false, "note": "Ese riesgo terminó después de la segunda pasada." },
        { "text": "Que te malinterpreten.", "correct": false, "note": "Una preocupación real y no lo que abordan las versiones adicionales." },
        { "text": "Tener que decidir qué quieres.", "correct": false, "note": "A veces cierto y pertenece a antes, antes de que empiece la redacción." },
        { "text": "El momento después de enviar.", "correct": true, "note": "Cuando está fuera de tus manos. Ese momento va a llegar de todos modos, retrasado exactamente la duración de cada versión." }
      ],
      "explain": "Y la herramienta siempre va a producir otra. Nunca se aburre."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "two_passes", "label": "Dos pasadas", "description": "Estructura, recortes, envío." },
      { "key": "noticed", "label": "Notó las vueltas", "description": "Detectó un cambio revertido." },
      { "key": "sent", "label": "Lo envió", "description": "No produjo una cuarta versión." },
      { "key": "escalated", "label": "Escaló si hacía falta una tercera", "description": "Reconoció cuándo pedía una llamada." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nadia",
      "role": "una compañera en el escritorio de al lado",
      "mood": "Seca.",
      "openness": 5,
      "personality": "Pregunta cuánto ha llevado esto y qué dice realmente el mensaje."
    },
    "setting": "Vas por la quinta versión de un mensaje de dos líneas y acabas de restaurar una frase que cortaste antes.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué ha cambiado desde la versión dos.",
      "No te impresiones con mejoras en la elección de palabras.",
      "Nunca leas ni juzgues el mensaje en sí."
    ],
    "opening_beat": "«¿Cuánto tiempo llevas con eso?»",
    "success_looks_like": "La persona envía la versión que tiene."
  }$j$::jsonb,
  'Hoy, envía un mensaje después de dos pasadas en vez de cinco. Apunta cuánto tardó.',
  $j${
    "says": "¿Cuánto tiempo llevas con eso? Son dos líneas.",
    "model": {
      "line": "Una hora. Acabo de volver a poner una frase que corté antes, lo cual significa que terminé hace rato. Lo estoy enviando ahora.",
      "why": "Restaurar un corte es la señal más clara de que dejaste de mejorar y empezaste a dar vueltas. Dos pasadas, y envía."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["una más", "casi está", "solo la última parte", "quiero que quede bien", "casi terminado", "otra versión"], "requirement": "No defiendas otra pasada" },
      { "kind": "contains_any", "words": ["envía", "enviando", "se fue", "enviado", "va ahora"], "requirement": "Di que lo estás enviando" },
      { "kind": "max_words", "n": 32, "requirement": "Para, no narres" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('do-not-outsource-the-reps', 5,
  'Las repeticiones son con personas',
  $md$Esta es la última lección del último tema, así que merece la pena decir la verdad con llaneza.

Nadie se ha vuelto nunca menos tímido enviando mejores mensajes.

Todo en este tema es real. Prepararse bien funciona. Hacer la pregunta que te daba vergüenza hacer cierra huecos que llevaban años cerrados. Ensayar en voz alta contra una versión difícil cambia genuinamente cómo va el martes. Cortar la disculpa de un borrador te hace más fácil de responder, y ser fácil de responder cambia cómo te trata la gente. Nada de eso es un premio de consolación.

Pero cada una de esas es una forma de llegar mejor preparado a un momento que todavía tiene que pasar. El momento en sí — el presentarte, el decirlo, los primeros treinta segundos donde nadie te ha ayudado, la pausa donde no sabes qué están pensando — es la parte que te cambia, y no tiene ninguna versión que se pueda hacer desde un escritorio.

**La jugada:** convierte toda preparación en una conversación real, esta semana.

Esa es toda la disciplina. La preparación que no se convierte en una conversación no es preparación, es un pasatiempo. Una apertura ensayada que nunca se dice es un párrafo. Un hueco de conocimiento cerrado que nunca se menciona es trivia. La herramienta produce potencial, que no vale absolutamente nada hasta que se gasta.

Hay un modo de fallo que esta app debería nombrar porque es el que más probablemente atrape a sus propios lectores: volverse muy bueno en la preparación. Leer las lecciones, hacer los ejercicios, hacer los ensayos, y descubrir que la semana no contenía conversaciones. Se siente como progreso. Se reporta como progreso. Es la misma evitación de la cuarta lección, a la escala de una vida en vez de una tarde.

La medida nunca fue lo bien que puedes prepararte. Era si dijiste la cosa.

Si te quedas con una cosa: puede ayudarte a prepararte. No puede ir en tu lugar, y el ir es la parte que cuenta.$md$,
  $j$[
    {
      "situation": "Te has preparado a fondo y no has tenido conversaciones.",
      "line": "(eso es un pasatiempo, no preparación)",
      "why": "La preparación produce potencial, que no vale nada hasta que se gasta."
    },
    {
      "situation": "Una apertura ensayada sigue sin decirse el viernes.",
      "line": "(es un párrafo hasta que lo dices)",
      "why": "El momento en sí es la parte que te cambia, y no tiene ninguna versión que se pueda hacer desde un escritorio."
    },
    {
      "situation": "La semana se sintió productiva.",
      "line": "(cuenta las conversaciones)",
      "why": "Se reporta como progreso. La medida nunca fue lo bien que puedes prepararte."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es el modo de fallo que nombra esta lección?",
      "options": [
        { "text": "Depender de ello para que escriba por ti.", "correct": false, "note": "El problema del tercer bloque, y trata del mensaje más que de ti." },
        { "text": "Volverse muy bueno en prepararse.", "correct": true, "note": "Se siente como progreso y se reporta como progreso. Es la evitación de la cuarta lección a la escala de una vida." },
        { "text": "Confiar en ello sobre las personas.", "correct": false, "note": "El bloque anterior, y es un problema de calibración distinto de este." },
        { "text": "Usarlo durante las conversaciones.", "correct": false, "note": "La primera lección de este bloque." }
      ],
      "explain": "La preparación que no se convierte en una conversación es un pasatiempo."
    },
    {
      "prompt": "¿Qué solo puede pasar en la conversación misma?",
      "options": [
        { "text": "Encontrar las palabras correctas.", "correct": false, "note": "Muy a menudo se encuentran de antemano, y para eso está el cuarto bloque." },
        { "text": "Descubrir qué piensan.", "correct": false, "note": "Pasa ahí, y es información más que la cosa que te cambia." },
        { "text": "Descubrir que tu argumento es débil.", "correct": false, "note": "Un buen ensayo lo descubre el domingo, que es el propósito de pedirle que no ceda." },
        { "text": "La parte sin ninguna ayuda dentro.", "correct": true, "note": "El presentarte, los primeros treinta segundos, la pausa donde no sabes qué están pensando. Esa es la parte que te cambia." }
      ],
      "explain": "Puede ayudarte a prepararte. No puede ir en tu lugar."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "converted", "label": "Convirtió la preparación en una conversación", "description": "Dijo la cosa esta semana." },
      { "key": "counted", "label": "Contó conversaciones, no sesiones", "description": "Midió lo correcto." },
      { "key": "unprepared", "label": "Tuvo una que no preparó", "description": "Se presentó sin plan." },
      { "key": "no_hobby", "label": "Ninguna preparación se quedó sin gastar", "description": "Nada ensayado y sin decir." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo que sabe en qué has estado trabajando",
      "mood": "Cálido y directo.",
      "openness": 5,
      "personality": "Pregunta cuántas conversaciones reales hubo, y no le interesa la preparación."
    },
    "setting": "Un amigo te ha preguntado cómo ha ido el último mes de mejorar en esto.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pide un número de conversaciones.",
      "No muestres ningún interés en lo exhaustiva que fue la preparación.",
      "Nunca le digas a la persona qué hacer a continuación."
    ],
    "opening_beat": "«¿Pero cuántas conversaciones reales?»",
    "success_looks_like": "La persona responde con conversaciones en vez de con preparación, y nombra la próxima."
  }$j$::jsonb,
  'Hoy, convierte algo que preparaste en una conversación real. Apunta qué dijiste.',
  $j${
    "beats": [
      {
        "situation": "Un mes de prepararse a fondo, y un amigo pregunta cómo ha ido.",
        "prompt": "¿Cuál es la medida honesta?",
        "options": [
          { "text": "Cuánto has aprendido.", "correct": false, "note": "Real, y se reporta como progreso mientras que todavía no ha pasado nada." },
          { "text": "Cuánto han mejorado tus mensajes.", "correct": false, "note": "Una ganancia genuina y aun así no para lo que era la app." },
          { "text": "Lo preparado que te sientes.", "correct": false, "note": "La menos fiable de todas, y la más fácil de aumentar sin moverte." },
          { "text": "Cuántas conversaciones tuviste de verdad.", "correct": true, "note": "La medida nunca fue lo bien que puedes prepararte. La preparación que no se convierte en una conversación es un pasatiempo." }
        ]
      },
      {
        "situation": "Tienes una apertura ensayada que está lista desde el domingo. Es viernes.",
        "prompt": "¿Qué vale?",
        "options": [
          { "text": "Nada todavía — es un párrafo.", "correct": true, "note": "La herramienta produce potencial, y el potencial no vale absolutamente nada hasta que se gasta." },
          { "text": "La mayor parte del valor, ya que la parte difícil es saber qué decir.", "correct": false, "note": "Saber qué decir es la mitad fácil. El ir es la parte que cuenta." },
          { "text": "Se va a mantener hasta que te sientas listo.", "correct": false, "note": "Listo no llega esperando, y esto es la evitación a la escala de una vida." },
          { "text": "La mitad — has hecho la preparación como es debido.", "correct": false, "note": "Hecha como es debido y sin gastar. No hay crédito parcial para una conversación que no pasó." }
        ]
      }
    ]
  }$j$::jsonb
);
