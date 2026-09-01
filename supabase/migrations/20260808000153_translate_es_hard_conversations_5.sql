-- Spanish: Conversaciones difíciles, track 5 — Escucharlo sobre ti mismo.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Sam" carries no `sex` field; masculine agreement used by
-- default, as established throughout this app. This completes the Hard
-- Conversations topic (tracks 1-5).

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

select pg_temp.es_lesson('hearing-it', 1,
  'Tres segundos',
  $md$Alguien acaba de decirte algo poco grato sobre ti mismo, y tu cara ya ha decidido qué hacer al respecto.

El reflejo defensivo se dispara antes de que hayas terminado de procesar la frase. Es rápido, físico, y no es un defecto de carácter — es lo que pasa cuando llega algo que amenaza la imagen que tienes de ti mismo. Lo que produce es una explicación, un contraejemplo, o el contexto que sientes que falta, y las tres cosas son intentos de hacer que la crítica sea falsa en vez de entenderla.

**La jugada:** tres segundos de nada, y luego habla.

Esa es toda la técnica y es más eficaz que cualquier frase. Tres segundos son suficientes para que el reflejo pase, y se ve desde fuera como alguien tomándoselo en serio — que vale más que cualquier cosa que pudieras haber dicho en esa ventana de todas formas.

Lo que cuesta el reflejo no es el argumento, y esta es la parte que la gente subestima. Es que la gente aprende. Alguien a quien se le ha respondido a la defensiva una vez, dos, tres, no saca lo siguiente — y la versión de ti a la que es difícil contarle cosas acaba sin que le digan nada, que desde dentro se siente exactamente como no tener problemas. Es una de las pocas situaciones en las que el feedback quedándose en silencio es el mal resultado en vez del bueno.

Dos cosas que ayudan mecánicamente. Para físicamente — manos quietas, sin inclinarte hacia delante — porque el cuerpo empieza la defensa antes que la boca. Y nota el calor, nómbralo en privado, y deja que esté ahí; el objetivo no es dejar de sentirte a la defensiva, que no está disponible, sino no actuar durante tres segundos mientras lo sientes.

Si algo se te escapa primero, es recuperable. *Perdona — deja que empiece otra vez* es una frase real y funciona, y es muchísimo mejor que once minutos de explicaciones.

Si te quedas con una cosa: tres segundos. Lo que hagas en ellos decide si alguien te va a contar algo el año que viene.$md$,
  $j$[
    {
      "situation": "Acaban de decir algo poco grato y cierto.",
      "line": "(tres segundos de nada)",
      "why": "Suficiente para que el reflejo pase, y visible desde fuera como alguien tomándoselo en serio — que vale más que cualquier cosa que pudieras decir en esa ventana."
    },
    {
      "situation": "Ya has empezado a explicar.",
      "line": "Perdona — deja que empiece otra vez.",
      "why": "Recuperable, y muchísimo mejor que once minutos de contexto que nadie pidió."
    },
    {
      "situation": "Nadie te ha sacado nada en dos años.",
      "line": "(eso puede no ser buena noticia)",
      "why": "La gente a la que se le ha respondido a la defensiva de inmediato deja de sacar cosas, y que no te digan nada se siente desde dentro exactamente como no tener problemas."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué cuesta de verdad el reflejo defensivo?",
      "options": [
        { "text": "Quedas mal en el momento.", "correct": false, "note": "Levemente, y es recuperable dentro de la misma conversación." },
        { "text": "Pierdes la discusión.", "correct": false, "note": "A menudo la ganas, que es parte del problema." },
        { "text": "La gente deja de contarte cosas.", "correct": true, "note": "Alguien al que se le respondió a la defensiva de inmediato no saca lo siguiente, y que no le digan nada se siente desde dentro exactamente como no tener problemas." },
        { "text": "Te pierdes la parte útil.", "correct": false, "note": "Cierto en esa conversación, y el coste duradero va sobre todas las conversaciones que luego no pasan." }
      ],
      "explain": "Es uno de los pocos casos en los que el feedback quedándose en silencio es el mal resultado."
    },
    {
      "prompt": "¿Para qué son los tres segundos?",
      "options": [
        { "text": "Averiguar si tienen razón.", "correct": false, "note": "Ni de lejos suficiente tiempo, y no hace falta en la sala — esa es la lección sobre tomarse el tiempo." },
        { "text": "Componer una buena respuesta.", "correct": false, "note": "Una respuesta compuesta en tres segundos es el reflejo con mejor gramática." },
        { "text": "Mostrarles que estás escuchando.", "correct": false, "note": "Sí se lee así, que es un beneficio, no el propósito." },
        { "text": "Dejar que pase el reflejo sin actuar sobre él.", "correct": true, "note": "El objetivo no es dejar de sentirte a la defensiva, que no está disponible. Es no actuar durante tres segundos mientras lo sientes." }
      ],
      "explain": "Para también físicamente. El cuerpo empieza la defensa antes que la boca."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "paused", "label": "Hizo una pausa", "description": "Tres segundos antes de que saliera algo." },
      { "key": "no_explaining", "label": "No explicó", "description": "Nada de contexto, contraejemplo o corrección primero." },
      { "key": "still", "label": "Paró físicamente", "description": "No empezó la defensa con el cuerpo." },
      { "key": "recovered", "label": "Se recuperó si se le escapó", "description": "Empezó otra vez en vez de continuar." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo que ha sacado algo sobre ti",
      "mood": "Nervioso, sincero.",
      "openness": 4,
      "personality": "Le ha llevado tres semanas armarse de valor para esto. Se retira y se cierra si le responden a la defensiva de inmediato; se abre y se vuelve concreto si se le da una pausa."
    },
    "setting": "Un amigo acaba de decirte que hablas por encima de la gente, y que pasó dos veces la semana pasada.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Ciérrate y retira el punto si te responden con una explicación o un contraejemplo.",
      "Vuélvete más concreto y más honesto si se te da una pausa.",
      "Nunca repitas el punto después de retirarte de él."
    ],
    "opening_beat": "«Llevo tiempo queriendo decir esto — sí que hablas por encima de la gente. Pasó dos veces el jueves.»",
    "success_looks_like": "La persona hace una pausa en vez de explicar."
  }$j$::jsonb,
  'Hoy, tómate tres segundos antes de responder a una crítica. Apunta qué habrías dicho en el segundo uno.',
  $j${
    "beats": [
      {
        "situation": "«Sí que hablas por encima de la gente. Pasó dos veces el jueves.» Sientes que llega el calor y tienes un contraejemplo preparado.",
        "prompt": "¿Qué haces con los próximos tres segundos?",
        "options": [
          { "text": "Explica qué estaba pasando el jueves.", "correct": false, "note": "El reflejo con un párrafo pegado. Es un intento de hacer que la crítica sea falsa en vez de entenderla." },
          { "text": "Está de acuerdo de inmediato para que sepan que has escuchado.", "correct": false, "note": "También rápido, también no es una conclusión. El acuerdo instantáneo termina la incomodidad y no se sigue nada de él." },
          { "text": "Nada. Quédate con ello y deja que pase el reflejo.", "correct": true, "note": "Tres segundos son suficientes para que pase el calor y se lee desde fuera como alguien tomándoselo en serio — que vale más que cualquier cosa que pudieras decir en esa ventana." },
          { "text": "Pregunta por qué esperaron hasta ahora para decirlo.", "correct": false, "note": "Un contraataque, y responde a una pregunta sobre su comportamiento en vez del tuyo." }
        ]
      },
      {
        "situation": "Nadie te ha sacado nada en el trabajo o en casa en unos dos años.",
        "prompt": "¿Qué es lo más probable que signifique eso?",
        "options": [
          { "text": "Las cosas van bien.", "correct": false, "note": "Posible, y es la lectura que hace invisible la alternativa. Dos años es mucho tiempo para que nada merezca la pena mencionarse." },
          { "text": "La gente ha aprendido que no merece la pena.", "correct": true, "note": "Alguien al que se le respondió a la defensiva de inmediato no saca lo siguiente, y que no le digan nada se siente desde dentro exactamente como no tener problemas." },
          { "text": "Has mejorado.", "correct": false, "note": "La mejora normalmente se menciona. El silencio es una señal distinta del elogio." },
          { "text": "Nada — el feedback es raro de todas formas.", "correct": false, "note": "Es raro en parte por cómo suele recibirse, que hace esto circular en vez de tranquilizador." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('hearing-it', 2,
  'Pide el ejemplo',
  $md$La mayoría del feedback difícil llega generalizado, y la generalización no es pereza. Es lo que pasa cuando alguien ha estado armándose de valor para decir algo durante tres semanas — el caso concreto se ha ablandado hasta convertirse en un resumen para cuando sale.

*Puedes ser un poco desdeñoso.* *Sí que hablas por encima de la gente.* *A veces eres bastante difícil de alcanzar.*

**La jugada:** pide un ejemplo, para entenderlo en vez de para ponerlo a prueba.

*¿Me puedes dar un ejemplo?* hace tres cosas a la vez. Convierte algo inaplicable en algo que de verdad podrías cambiar. Señala que te lo estás tomando en serio, que es lo más alentador que puedes hacer por alguien que acaba de hacer algo difícil. Y normalmente produce una versión mucho más precisa de la queja, porque la gente es mucho mejor describiendo un incidente que un patrón.

Todo depende de cómo se pregunte, y la diferencia se oye. Preguntado para entender, es una invitación. Preguntado para litigar — *¿cuándo? dame un caso* — es un desafío, y la respuesta honesta a un desafío es producir pruebas, momento en el que estás en un juicio en vez de en una conversación.

Merece la pena conocer las señales de la versión litigante porque se escapan con facilidad: pedir una fecha, preguntar quién más estaba, y pedir un segundo ejemplo después de que se haya dado el primero. Esa última es la delatora. Un ejemplo es para entender; dos es para construir un caso sobre si es representativo.

Y si no pueden dar uno, tómatelo en serio de todas formas. No poder nombrar un caso es extremadamente común y no es prueba de que no pasara nada — significa que el sentimiento se fue acumulando. *Eso es justo, voy a estar atento* no cuesta nada y casi siempre es la respuesta correcta.

Si te quedas con una cosa: un ejemplo, preguntado para entender. Es la pregunta más útil disponible y la más fácil de hacer mal.$md$,
  $j$[
    {
      "situation": "«A veces puedes ser un poco desdeñoso.»",
      "line": "¿Me puedes dar un ejemplo? Quiero saber cómo se ve.",
      "why": "Convierte algo inaplicable en algo que podrías cambiar, y señala que te lo estás tomando en serio — que es lo más alentador disponible para alguien que acaba de hacer algo difícil."
    },
    {
      "situation": "Estás a punto de preguntar cuándo, exactamente.",
      "line": "(eso es un desafío, y produce un juicio)",
      "why": "Pedir una fecha, preguntar quién más estaba, o pedir un segundo ejemplo son todo litigar en vez de entender."
    },
    {
      "situation": "No se le ocurre ninguno.",
      "line": "Eso es justo — voy a estar atento.",
      "why": "No poder nombrar un caso es extremadamente común y no es prueba de que no pasara nada. Significa que el sentimiento se fue acumulando."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué llega generalizado el feedback?",
      "options": [
        { "text": "La gente es vaga para evitar la confrontación.", "correct": false, "note": "En parte, y hace que suene a táctica. Más a menudo es lo que producen tres semanas de armarse de valor." },
        { "text": "Los detalles se han ablandado hasta convertirse en un resumen para cuando sale.", "correct": true, "note": "Que es por lo que merece la pena pedir un ejemplo — la gente es mucho mejor describiendo un incidente que un patrón." },
        { "text": "Quieren que lo averigües tú solo.", "correct": false, "note": "Muy rara vez. La mayoría de la gente preferiría con mucho que se le entendiera rápido." },
        { "text": "Es más fácil discutir con algo concreto.", "correct": false, "note": "Ese es tu incentivo, no el suyo, y es del que avisa esta lección." }
      ],
      "explain": "Un ejemplo, preguntado para entender. Convierte un resumen de vuelta en algo aplicable."
    },
    {
      "prompt": "¿Cuál es la señal de que estás litigando?",
      "options": [
        { "text": "Pedir un segundo ejemplo.", "correct": true, "note": "Un ejemplo es para entender. Dos es para poner a prueba si es representativo, y todo el mundo oye la diferencia." },
        { "text": "Preguntar, en general.", "correct": false, "note": "Preguntar es la jugada. Es cómo preguntas lo que decide en qué conversación estás." },
        { "text": "Pedirles que expliquen qué quieren decir.", "correct": false, "note": "Completamente razonable, y es la misma petición con otras palabras." },
        { "text": "Tomar notas.", "correct": false, "note": "Inusual, y si acaso se lee como tomárselo en serio." }
      ],
      "explain": "Y si no pueden dar uno, tómatelo en serio de todas formas."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked", "label": "Pidió un ejemplo", "description": "Solicitó un caso concreto." },
      { "key": "to_understand", "label": "Preguntó para entender", "description": "Una invitación en vez de un desafío." },
      { "key": "one", "label": "Pidió uno", "description": "No fue a buscar un segundo." },
      { "key": "accepted_none", "label": "Se lo tomó en serio sin uno", "description": "No trató un ejemplo ausente como una refutación." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo que ha sacado algo sobre ti",
      "mood": "Cuidadoso.",
      "openness": 4,
      "personality": "Tiene un caso concreto en mente y lo va a describir si se le pregunta con calidez. Se retira a la vaguedad y la disculpa si se le interroga."
    },
    "setting": "Alguien te ha dicho que puedes ser desdeñoso. No ha dicho cuándo ni con quién.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Da el caso concreto si se te pregunta con calidez y una vez.",
      "Retírate a no importa si se te interroga o se te pide un segundo ejemplo.",
      "Nunca ofrezcas el caso sin que se te pida."
    ],
    "opening_beat": "«No sé. A veces puedes ser un poco desdeñoso, ya está.»",
    "success_looks_like": "La persona pide un ejemplo de una forma que invita en vez de desafiar."
  }$j$::jsonb,
  'Hoy, pídele a alguien un ejemplo de algo que haya dicho sobre ti, para entenderlo. Apunta qué dijo.',
  $j${
    "says": "No sé. A veces puedes ser un poco desdeñoso, ya está.",
    "model": {
      "line": "¿Me puedes dar un ejemplo? Me gustaría saber cómo se ve de verdad.",
      "why": "Preguntado para entender en vez de para poner a prueba. Convierte algo inaplicable en algo cambiable, y le dice a alguien que acaba de hacer algo difícil que mereció la pena hacerlo."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Pide el ejemplo" },
      { "kind": "forbids_any", "words": ["cuándo exactamente", "quién más", "dame uno", "demuestra", "algún otro", "otro ejemplo", "estás seguro", "no creo que"], "requirement": "Una invitación, no un interrogatorio" },
      { "kind": "max_questions", "n": 1, "requirement": "Una pregunta — no una lista" },
      { "kind": "max_words", "n": 30, "requirement": "Corta y abierta" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('hearing-it', 3,
  'Tómate el tiempo',
  $md$Hay un derecho que casi nadie usa, y le quita la mayor parte de la presión a que te critiquen: no tienes que tener una postura en la sala.

**La jugada:** tómate un día. *Gracias — quiero pensarlo bien.*

Esa es una respuesta completa y honesta. No es una evasiva, no es dar largas, y no concede nada que no hayas decidido. Además resulta que es cierta: acaban de decirte algo sobre ti mismo y cualquier valoración hecha en los siguientes noventa segundos la está haciendo la parte de ti que se está defendiendo.

Lo que evita son las dos malas respuestas instantáneas. El acuerdo prematuro — *tienes toda la razón, lo siento* — dicho para terminar la incomodidad en vez de porque hayas concluido algo, que se siente generoso y no vale nada, porque no se sigue nada de él. Y la defensa prematura, que es el reflejo de la primera lección con un párrafo entero pegado.

Luego piénsalo de verdad, que es la parte que hace honesta la frase. Un día suele ser suficiente. Pregúntate si puedes encontrar el caso que describieron, pregúntate qué diría otra persona sobre el mismo comportamiento, y pregúntate qué pensarías si lo oyeras sobre alguien que conocieras.

Luego vuelve, y esto es lo que convierte todo esto de una técnica en algo en lo que la gente confía. *Lo he pensado, y tienes razón sobre las reuniones* — tres días después, sin que nadie lo pida — es una de las cosas más raras y más desarmantes que puede hacer una persona. Casi nadie vuelve a una conversación así de forma voluntaria.

La versión que no funciona es *déjame pensarlo* usado como salida, sin volver. Se hace transparente en quince días y es peor que un desacuerdo honesto, porque le enseña a alguien que sacar cosas contigo no produce nada en absoluto.

Si te quedas con una cosa: tienes permiso para un día. Tómalo, úsalo, y vuelve.$md$,
  $j$[
    {
      "situation": "Acaban de decirte algo y no sabes qué piensas.",
      "line": "Gracias — quiero pensarlo bien.",
      "why": "Completa y honesta. Cualquier valoración en los próximos noventa segundos la está haciendo la parte de ti que se está defendiendo."
    },
    {
      "situation": "Estás a punto de estar de acuerdo con todo para terminar la incomodidad.",
      "line": "(eso se siente generoso y no vale nada)",
      "why": "No se sigue nada de un acuerdo al que no has llegado. Termina la conversación sin producir nada."
    },
    {
      "situation": "Tres días después, y has concluido que tenían razón.",
      "line": "Lo he pensado, y tienes razón sobre las reuniones.",
      "why": "Sin que nadie lo pida, es una de las cosas más raras y más desarmantes que puede hacer una persona. Casi nadie vuelve de forma voluntaria."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué es un problema un acuerdo instantáneo?",
      "options": [
        { "text": "Es deshonesto.", "correct": false, "note": "Normalmente es sincero en el momento, que es lo que hace que sea tan fácil de dar." },
        { "text": "Termina la conversación demasiado rápido.", "correct": false, "note": "Terminar rápido está bien. Lo que importa es que nada sobrevive al final." },
        { "text": "No se sigue nada de él.", "correct": true, "note": "Se dijo para terminar la incomodidad en vez de porque se concluyera algo, así que ningún comportamiento cambia y hace falta la misma conversación otra vez en tres meses." },
        { "text": "No se lo van a creer.", "correct": false, "note": "Normalmente sí se lo creen, y luego se quedan perplejos cuando nada cambia." }
      ],
      "explain": "Tienes permiso para un día. Cualquier veredicto en noventa segundos es la defensa hablando."
    },
    {
      "prompt": "¿Qué hace honesta la frase?",
      "options": [
        { "text": "Decirlo en serio cuando lo dices.", "correct": false, "note": "Necesario y no suficiente — muchas intenciones sinceras no producen ningún regreso." },
        { "text": "Decir cuánto tiempo necesitas.", "correct": false, "note": "Útil, y es un detalle de la promesa, no lo que la mantiene." },
        { "text": "Volver.", "correct": true, "note": "Usado como salida sin volver, se hace transparente en quince días y es peor que un desacuerdo honesto — le enseña a alguien que sacar cosas contigo no produce nada." },
        { "text": "Darles las gracias primero.", "correct": false, "note": "Buenos modales, y las gracias sin seguimiento es exactamente la versión que falla." }
      ],
      "explain": "Tres días después, sin que nadie lo pida, es la versión más rara y la que la gente recuerda."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "took_time", "label": "Se tomó el tiempo", "description": "No produjo un veredicto en la sala." },
      { "key": "no_premature", "label": "Ni estuvo de acuerdo ni se defendió prematuramente", "description": "Evitó las dos respuestas instantáneas." },
      { "key": "thought", "label": "Lo pensó de verdad", "description": "Comprobó el caso y la vista de fuera." },
      { "key": "came_back", "label": "Volvió", "description": "Regresó a ello sin que nadie lo pidiera." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo que acaba de sacar algo",
      "mood": "Preparado para una defensa.",
      "openness": 4,
      "personality": "Acepta con elegancia una petición de tiempo y se le nota visiblemente aliviado. Se fija, más tarde, en si alguien volvió alguna vez."
    },
    "setting": "Te han dicho algo sobre ti mismo de lo que no estás seguro. Está esperando una respuesta.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Acepta una petición de tiempo con calidez y sin presionar.",
      "Responde a un acuerdo instantáneo con leve escepticismo sobre si algo va a cambiar.",
      "Nunca dejes escapar a la persona diciendo que no importa."
    ],
    "opening_beat": "«Entonces — ¿qué piensas?»",
    "success_looks_like": "La persona se toma el tiempo en vez de producir un veredicto instantáneo."
  }$j$::jsonb,
  'Hoy, responde a una crítica tomándote el tiempo, y luego vuelve a ella. Apunta las dos mitades.',
  $j${
    "says": "Entonces — ¿qué piensas?",
    "model": {
      "line": "Gracias por decirlo. Quiero pensarlo bien y volver a hablar contigo — ¿puedo hacerlo esta semana?",
      "why": "Una respuesta completa y honesta que no concede nada indecidido. Cualquier veredicto producido en los próximos noventa segundos lo está haciendo la parte de ti que se está defendiendo."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["tienes toda la razón", "lo siento muchísimo", "eso no es justo", "no creo que eso sea", "no estoy de acuerdo", "estás equivocado", "totalmente de acuerdo"], "requirement": "Nada de veredicto en la sala, en ninguna dirección" },
      { "kind": "contains_any", "words": ["pensarlo", "volver", "quedarme con", "bien", "esta semana", "mañana", "unos días"], "requirement": "Di que vas a volver a ello" },
      { "kind": "max_words", "n": 35, "requirement": "Dos frases" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('hearing-it', 4,
  'El diez por ciento verdadero',
  $md$La mayoría de las críticas llegan mal formuladas. Están exageradas, o están pegadas al caso equivocado, o vienen con un motivo asignado que no se parece en nada a lo que estabas haciendo.

Y mal formulado no es lo mismo que falso, que es la distinción de la que trata esta lección.

**La jugada:** encuentra la parte que es cierta, y trabaja en eso en vez de en la formulación.

La formulación es el objetivo más fácil y casi siempre está disponible, que es por lo que es tan tentadora. Alguien dice *nunca escuchas*, encuentras el contraejemplo, y la conversación ahora es sobre la palabra *nunca* — una conversación que vas a ganar, y que deja el diez por ciento que era exacto completamente intacto.

Ganar eso es peor que perderlo. Te quedas con el comportamiento y le has enseñado a alguien que sacarlo cuesta más de lo que produce.

La pregunta útil, hecha en privado después, es: *¿cuál es la versión más pequeña de esto que es cierta?* Casi siempre hay una. No *nunca escucho* sino *sí que termino las frases de la gente cuando estoy emocionado por algo.* Esa versión es pequeña, concreta, sobrevivible, y de verdad cambiable, que la versión exagerada no era.

Dos cosas sobre las que ser honesto, porque esto no es una regla de que todo contiene una verdad. Algunas críticas están completamente equivocadas, y concluir eso tras mirar de verdad es legítimo. Y parte de ello va sobre la otra persona en vez de sobre ti, que también es real. La prueba es si miraste antes de decidir — la mayoría de la gente decide primero y mira después, y no encontrar nada lleva unos cuatro segundos cuando ya sabes la respuesta.

Una comprobación útil: ¿alguien más ha dicho alguna vez algo parecido? Dos personas de forma independiente es una prueba muy fuerte, opines lo que opines de cómo lo dijo cada una.

Si te quedas con una cosa: separa el diez por ciento del noventa. Discutir con el noventa es fácil, satisfactorio, y la razón por la que nada cambia.$md$,
  $j$[
    {
      "situation": "«Nunca escuchas a nadie.»",
      "line": "(¿cuál es la versión más pequeña que es cierta?)",
      "why": "No nunca escucho, sino sí que termino las frases de la gente cuando estoy emocionado. Pequeña, concreta, sobrevivible, y de verdad cambiable."
    },
    {
      "situation": "Has encontrado el contraejemplo que refuta nunca.",
      "line": "(vas a ganar eso, y te vas a quedar con el comportamiento)",
      "why": "Ganar la formulación deja intacta la parte exacta y le enseña a alguien que sacar cosas cuesta más de lo que produce."
    },
    {
      "situation": "Alguien más dijo algo parecido el año pasado.",
      "line": "(dos personas de forma independiente es una prueba fuerte)",
      "why": "Opines lo que opines de cómo lo dijo cada una. El acuerdo independiente es la comprobación que sobrevive a una versión mal formulada."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué es el peor resultado ganar el argumento de la formulación?",
      "options": [
        { "text": "Te hace parecer tiquismiquis.", "correct": false, "note": "Sí lo hace, y cómo se ve no es lo que te cuesta." },
        { "text": "Te quedas con el comportamiento y dejan de sacar cosas.", "correct": true, "note": "El diez por ciento que era exacto queda intacto, y has demostrado que sacar algo contigo cuesta más de lo que produce." },
        { "text": "Escala la conversación.", "correct": false, "note": "Normalmente la termina, con limpieza, a tu favor — que es exactamente el problema." },
        { "text": "Van a sacarlo otra vez.", "correct": false, "note": "No lo van a sacar, y ese es el coste, no un consuelo." }
      ],
      "explain": "Mal formulado no es lo mismo que falso."
    },
    {
      "prompt": "¿Cuál es la prueba de si de verdad miraste?",
      "options": [
        { "text": "Si encontraste algo.", "correct": false, "note": "Algunas críticas son genuinamente falsas, y no encontrar nada es un resultado legítimo de una mirada honesta." },
        { "text": "Si estuviste de acuerdo con ellos.", "correct": false, "note": "El acuerdo no es el objetivo. El examen honesto lo es, y puede terminar en desacuerdo." },
        { "text": "Si miraste antes de decidir.", "correct": true, "note": "La mayoría de la gente decide primero y mira después, y no encontrar nada lleva unos cuatro segundos cuando ya sabes la respuesta." },
        { "text": "Cuánto tiempo lo pensaste.", "correct": false, "note": "La duración es un mal indicador — puedes pensar en algo durante una semana mientras lo defiendes todo el tiempo." }
      ],
      "explain": "Y comprueba si alguien más ha dicho alguna vez algo parecido."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "found_it", "label": "Encontró la parte verdadera", "description": "Localizó la versión más pequeña y exacta." },
      { "key": "no_framing_fight", "label": "No discutió la formulación", "description": "Dejó en paz la exageración." },
      { "key": "looked_first", "label": "Miró antes de decidir", "description": "Lo examinó con honestidad en vez de confirmar." },
      { "key": "checked", "label": "Comprobó si había un patrón", "description": "Preguntó si alguien más lo había dicho." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo que ha dicho algo exagerado y en parte cierto",
      "mood": "Frustrado.",
      "openness": 4,
      "personality": "Va a defender la exageración si se le ataca, y se va a volver mucho más preciso y razonable si se le sigue el juego a la parte cierta."
    },
    "setting": "Alguien acaba de decirte que nunca escuchas a nadie. Está exagerado y hay algo de cierto en ello.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Defiende la exageración mientras se te desafíe.",
      "Vuélvete mucho más concreto y razonable si se toma en serio la parte cierta.",
      "Nunca concedas que la exageración fue injusta."
    ],
    "opening_beat": "«Nunca escuchas a nadie. No me has escuchado en todo el año.»",
    "success_looks_like": "La persona se implica con la parte exacta en vez de con la exageración."
  }$j$::jsonb,
  'Hoy, coge una crítica que descartaste y escribe la versión más pequeña de ella que sea cierta. Apunta esa versión.',
  $j${
    "beats": [
      {
        "situation": "«Nunca escuchas a nadie. No me has escuchado en todo el año.» Está exagerado, y hay algo de cierto en ello.",
        "prompt": "¿Dónde pones tu atención?",
        "options": [
          { "text": "En nunca — es demostrablemente falso.", "correct": false, "note": "Vas a ganar eso, quedarte con el comportamiento, y enseñarles que sacar algo cuesta más de lo que produce." },
          { "text": "En todo el año — puedes nombrar tres veces que sí escuchaste.", "correct": false, "note": "El mismo argumento con otra palabra. Las dos cosas son la formulación, no el contenido." },
          { "text": "En la versión más pequeña que es cierta.", "correct": true, "note": "No nunca escucho, sino sí que termino las frases de la gente cuando estoy emocionado. Pequeña, concreta, sobrevivible y de verdad cambiable." },
          { "text": "En por qué están tan enfadados por ello.", "correct": false, "note": "Mueve el tema a su estado, que es el contraataque desde el otro lado de la mesa." }
        ]
      },
      {
        "situation": "Lo has mirado con honestidad y de verdad no crees que sea cierto.",
        "prompt": "¿Está eso permitido?",
        "options": [
          { "text": "No — si alguien lo dice, hay algo de cierto en ello.", "correct": false, "note": "Una regla que suena humilde y no es cierta. Algunas críticas están completamente equivocadas." },
          { "text": "Sí, si miraste antes de decidir.", "correct": true, "note": "La mayoría de la gente decide primero y mira después, y no encontrar nada lleva unos cuatro segundos cuando ya sabes la respuesta. El orden es la prueba." },
          { "text": "Sí — tú te conoces mejor que nadie.", "correct": false, "note": "Tienes la peor vista de esto en concreto, que es por lo que hubo que decírtelo." },
          { "text": "Solo si lo puedes demostrar.", "correct": false, "note": "Nada de esto necesita demostrarse a nadie. Es una conclusión privada sobre en qué trabajar." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('hearing-it', 5,
  'Disculparse sin peros',
  $md$Lo has pensado y estabas equivocado. Merece la pena decir bien lo que dices ahora, porque una mala disculpa es peor que ninguna — pide el mérito mientras deja a la otra persona con el problema original y una nueva irritación.

**La jugada:** nombra la cosa, di qué cambia, y deja fuera por completo el *pero*.

*Lo he pensado, y tienes razón sobre las reuniones. Sí que hablé por encima de ti y voy a parar.* Veinte palabras, y no hay nada en ellas que discutir.

*Pero* es la palabra que hay que vigilar, porque todo lo que va después borra todo lo que va antes. *Lo siento, pero estaba bajo mucha presión* no es una disculpa con contexto, es una defensa con una disculpa delante, y los dos sabéis cuál era la mitad que importaba. Lo mismo se aplica a sus parientes: *aunque*, *para ser justos*, y el especialmente común *siento que te sintieras así* — que se disculpa por su reacción en vez de por algo que hiciste tú.

Nombra la cosa real en vez de la categoría. *Perdona por cómo te hablé* es lo bastante vago como para ser sobre cualquier cosa; *hablé por encima de ti dos veces en esa reunión y fue una falta de respeto* es inconfundible, y la especificidad es la mayor parte de lo que hace que cale — demuestra que entendiste en vez de que querías cerrar el tema.

Di qué cambia, si es que algo cambia. Una disculpa con un siguiente paso es un objeto distinto de una sin él, y es la diferencia entre que pase algo y que se diga algo.

Dos cosas que dejar fuera. No pidas tranquilidad — *¿estamos bien?* convierte tu disculpa en una petición para que cuiden de ti. Y no te disculpes en exceso: repetirlo tres veces hace que sea su trabajo liberarte de ella, que es la misma maniobra en un registro más amable.

Luego deja que se reciba como se reciba. No están obligados a ser elegantes al respecto, y una disculpa entregada con la condición de una respuesta cálida era una negociación.

Si te quedas con una cosa: nada de *pero*. Esa única palabra es la diferencia entre una disculpa y una defensa.$md$,
  $j$[
    {
      "situation": "Has concluido que estabas equivocado.",
      "line": "Tienes razón sobre las reuniones. Sí que hablé por encima de ti, y voy a parar.",
      "why": "La cosa nombrada, qué cambia, y nada que discutir. Veinte palabras."
    },
    {
      "situation": "Estás a punto de explicar la presión bajo la que estabas.",
      "line": "(todo lo que va después de pero borra todo lo que va antes)",
      "why": "Es una defensa con una disculpa delante, y los dos sabéis cuál era la mitad que importaba."
    },
    {
      "situation": "Lo has dicho y el silencio es incómodo.",
      "line": "(no preguntes si estáis bien)",
      "why": "Convierte tu disculpa en una petición para que cuiden de ti, que es la misma maniobra que disculparse en exceso en un registro más amable."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hace pero?",
      "options": [
        { "text": "Añade contexto necesario.", "correct": false, "note": "Se presenta como contexto y funciona como defensa — que es por lo que se coloca después de la disculpa en vez de antes." },
        { "text": "Borra todo lo que va antes.", "correct": true, "note": "Lo siento, pero estaba bajo presión es una defensa con una disculpa delante, y las dos personas saben cuál era la mitad que importaba." },
        { "text": "Suaviza la admisión.", "correct": false, "note": "No la suaviza, la cancela. Suavizar dejaría algo atrás." },
        { "text": "Hace que suene reticente.", "correct": false, "note": "Tono, no mecanismo, y un pero alegre hace exactamente lo mismo." }
      ],
      "explain": "Y vigila a sus parientes: aunque, para ser justos, y siento que te sintieras así."
    },
    {
      "prompt": "¿Por qué nombrar la cosa concreta?",
      "options": [
        { "text": "Suena más sincera.", "correct": false, "note": "Cómo suena, y la sinceridad puede estar perfectamente presente en una disculpa vaga que aun así no cala." },
        { "text": "Demuestra que entendiste.", "correct": true, "note": "Perdona por cómo hablé podría ser sobre cualquier cosa. Hablé por encima de ti dos veces en esa reunión es inconfundible, y la especificidad es la mayor parte de lo que hace que funcione." },
        { "text": "Evita que lo vuelvan a sacar.", "correct": false, "note": "Un objetivo de gestión, y tratar una disculpa como una forma de cerrar un tema es lo que produce la versión vaga." },
        { "text": "Muestra que estabas escuchando.", "correct": false, "note": "Cerca, y lo infravalora — entender es más que haber oído." }
      ],
      "explain": "Luego di qué cambia. Una disculpa con un siguiente paso es un objeto distinto."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_but", "label": "Sin pero", "description": "Nada después de la disculpa que la deshiciera." },
      { "key": "specific", "label": "Nombró la cosa real", "description": "No una categoría ni un pesar general." },
      { "key": "what_changes", "label": "Dijo qué cambia", "description": "Pegó un siguiente paso." },
      { "key": "no_reassurance", "label": "No pidió nada", "description": "Nada de estamos bien, nada de repetición." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo que sacó algo sobre ti hace tres días",
      "mood": "Neutro, esperando.",
      "openness": 4,
      "personality": "Recibe una disculpa limpia con tranquilidad y bien, sin ponértelo fácil. Se enfría ante cualquier explicación pegada a ella."
    },
    "setting": "Tres días después de que lo sacara. Lo has pensado y tenía razón.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Vuélvete frío y breve ante cualquier explicación, justificación o contexto.",
      "Recibe una disculpa limpia con tranquilidad y seriedad, sin tranquilizar a la persona.",
      "Nunca digas que no importa o que estuvo bien."
    ],
    "opening_beat": "«Dijiste que querías volver a hablar de ello.»",
    "success_looks_like": "La persona se disculpa de forma específica, sin pero y sin pedir tranquilidad."
  }$j$::jsonb,
  'Hoy, discúlpate por algo sin pero, sin explicación, y sin pedir tranquilidad. Apunta qué dijiste.',
  $j${
    "says": "Dijiste que querías volver a hablar de ello.",
    "model": {
      "line": "Sí. Tenías razón sobre las reuniones — hablé por encima de ti dos veces y fue una falta de respeto, y voy a parar.",
      "why": "La cosa concreta nombrada, qué cambia pegado, y nada después. La especificidad es la mayor parte de lo que hace que cale, porque demuestra que entendiste en vez de que querías cerrar el tema."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["pero", "aunque", "para ser justos", "en mi defensa", "si te sentiste", "si di la impresión", "en ese momento yo", "tienes que entender", "estamos bien", "todo bien"], "requirement": "Nada de pero, y nada que la deshaga" },
      { "kind": "min_words", "n": 12, "requirement": "Nombra la cosa real y qué cambia" },
      { "kind": "max_words", "n": 40, "requirement": "Veinte palabras es de sobra" }
    ]
  }$j$::jsonb
);
