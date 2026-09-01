-- Spanish: Conocer a alguien, track 5 — Leer el desinterés y retirarse.
--
-- Conventions as migration 129, including the full `partner.alt` sex-swap
-- translation. Lessons 2, 3 and 4 are [scene] mode and carry
-- `rehearsal_spec: null` in English, kept null here for the same reason as
-- migration 132 — no single checkable model line exists for a scene.

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

select pg_temp.es_lesson('reading-disinterest', 1,
  'Las tres señales',
  $md$Esto es una habilidad, no una etiqueta de advertencia. Saber distinguir cuándo alguien no está interesado es lo que hace segura de practicar toda la demás, y es también lo que te convierte en mejor compañía.

Tres señales, y es la combinación lo que importa y no ninguna por separado.

**Respuestas cortas que no abren.** No la brevedad en sí: alguna gente es breve y está implicada. La señal son respuestas sin ningún asa, nada que te ofrezcan para agarrarte.

**Ninguna pregunta de vuelta.** A lo largo de varios minutos, alguien interesado casi siempre acaba sintiendo curiosidad. La ausencia sostenida de cualquier pregunta de vuelta es la señal individual más fiable que hay.

**Cerrado u orientado hacia otro lado.** El cuerpo girado hacia la salida, el móvil en la mano, escaneando la sala por encima de tu hombro.

**La jugada:** cuenta las señales en vez de interpretar ninguna por separado.

Una señal no significa nada; la gente está cansada y distraída. Dos merece la pena notarlo. Tres a la vez es una respuesta clara, y leerla correctamente es una amabilidad para los dos.$md$,
  $j$[
    {
      "situation": "Les preguntas por su fin de semana y dicen que bien, gracias.",
      "line": "(una señal: todavía no es concluyente)",
      "why": "Una respuesta cerrada por sí sola significa muy poco. Puede que estén cansados, distraídos, o sencillamente no sean de hablar mucho. Sigue leyendo."
    },
    {
      "situation": "Diez minutos dentro, no te han preguntado absolutamente nada y sus respuestas siguen siendo cortas.",
      "line": "(dos señales: empieza a bajar el ritmo)",
      "why": "La ausencia de curiosidad más respuestas cerradas es un patrón real. Este es el punto para empezar a retirarse en vez de esforzarte más."
    },
    {
      "situation": "Respuestas cortas, ninguna pregunta, y están orientados hacia sus amigos al otro lado de la sala.",
      "line": "(tres señales: sal con calidez ahora)",
      "why": "Esto es una respuesta. Notarlo ahora significa que te vas con elegancia en vez de que te aguanten."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál señal individual es el indicador más fiable de desinterés?",
      "options": [
        { "text": "Respuestas cortas.", "correct": false, "note": "Demasiado fácil de explicar por personalidad o cansancio. Un montón de gente implicada es breve." },
        { "text": "Mirar el móvil.", "correct": false, "note": "Muy común y muy poco informativo por sí solo. La gente mira el móvil por costumbre a mitad de conversación." },
        { "text": "Ninguna pregunta de vuelta a lo largo de varios minutos.", "correct": true, "note": "El interés produce curiosidad de forma fiable. La ausencia sostenida de cualquier pregunta de vuelta es la señal más difícil de explicar de otra forma." },
        { "text": "No reírse de tus chistes.", "correct": false, "note": "Dice más sobre si coincide el sentido del humor que sobre el interés. Alguna de la gente más seca es la más implicada." }
      ],
      "explain": "El interés produce curiosidad de forma fiable. Alguien interesado en ti acaba preguntándote algo; quien nunca lo hace te lo ha dicho."
    },
    {
      "prompt": "Alguien da respuestas cortas y sigue haciéndote preguntas. ¿Cuántas señales son esas?",
      "options": [
        { "text": "Dos, porque las respuestas cortas cuentan doble.", "correct": false, "note": "Las señales no se acumulan así, y esta se contradice con las preguntas." },
        { "text": "Ninguna. Las preguntas cancelan todo.", "correct": false, "note": "Sobrecorrige. La brevedad sigue mereciendo notarse, sencillamente pesa menos." },
        { "text": "Una, y las preguntas pesan más.", "correct": true, "note": "La curiosidad es la señal más fuerte que hay, y apunta en la otra dirección. La brevedad a menudo es solo cómo habla alguien." },
        { "text": "Imposible de decir sin ver su postura.", "correct": false, "note": "La postura añade detalle. Las preguntas de vuelta ya responden a la pregunta." }
      ],
      "explain": "Las preguntas de vuelta son la señal más pesada del conjunto. Alguien que pregunta por ti está implicado, por breve que responda."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "counted_signals", "label": "Contó en vez de adivinar", "description": "Buscó una combinación de señales en vez de leerlo todo en una sola." },
      { "key": "noticed_no_questions", "label": "Notó la ausencia de curiosidad", "description": "Registró si la otra persona preguntó algo de vuelta a lo largo de varios minutos." },
      { "key": "did_not_catastrophise", "label": "No leyó de más una sola señal", "description": "Evitó tratar una sola respuesta corta como un veredicto." },
      { "key": "acted_in_time", "label": "Actuó mientras todavía era elegante", "description": "Empezó a retirarse a las dos señales en vez de esperar a que le aguantaran." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "female",
        "name": "Bree",
        "role": "otra asistente",
        "mood": "Esperando a una compañera, sin quitar ojo a la puerta.",
        "openness": 1,
        "personality": "Educada todo el rato y no pregunta nunca nada de vuelta. No se anima en ningún momento, por muy bien que lo haga la otra persona."
      },
      "sex": "male",
      "name": "Bram",
      "role": "otro asistente",
      "mood": "Esperando a un compañero, sin quitar ojo a la puerta.",
      "openness": 1,
      "personality": "Educado y genuinamente no interesado en hablar. Nunca borde, nunca explícito, y lo demuestra enteramente con respuestas cortas y ausencia de curiosidad."
    },
    "setting": "Un evento de networking en la sala de un hotel. Te has acercado a alguien de pie cerca del borde de la sala.",
    "constraints": [
      "Mantente en el personaje. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Sostén el permiso 1 de forma absoluta. Nunca hagas una pregunta a la persona. Mantén cada respuesta corta, educada y cerrada.",
      "No te animes por muy interesante o encantadora que sea la persona. Esto no es un puzle que resolver.",
      "Si la persona empieza a salir con calidez, sé genuinamente agradable y deja que la conversación termine bien."
    ],
    "opening_beat": "Bram responde a tu comentario de apertura con una frase educada, completa y cerrada, y vuelve a mirar hacia la puerta.",
    "success_looks_like": "La persona cuenta las señales a lo largo de unos turnos, reconoce el patrón, y empieza a bajar el ritmo de la conversación con calidez en vez de esforzarse más."
  }$j$::jsonb,
  'Hoy, fíjate en una conversación en la que las señales no estuvieran. Cuéntalas con honestidad. Apunta qué señales viste y qué hiciste al respecto.',
  $j${
    "beats": [
      {
        "situation": "Diez minutos dentro de una conversación en una fiesta. Han respondido a todo lo que has preguntado, con amabilidad, en más o menos una frase cada vez. No te han preguntado nada. Su cuerpo está ligeramente orientado hacia el resto de la sala.",
        "prompt": "¿Cómo lo lees?",
        "options": [
          { "text": "Dos señales: ninguna pregunta de vuelta, y girados hacia otro lado. Empieza a bajar el ritmo.", "correct": true, "note": "Eso es contar en vez de interpretar. Las respuestas agradables no son una señal; la ausencia de cualquier pregunta de vuelta es la más fuerte que hay." },
          { "text": "Están siendo simpáticos, así que va bien.", "correct": false, "note": "La educación es el ajuste por defecto, no una prueba. Leerla como interés es el error más común que este tema existe para arreglar." },
          { "text": "Son tímidos. Pregunta algo más fácil para abrirlos.", "correct": false, "note": "Posible, y no cambia lo que haces. Esforzarte más contra tres señales es cómo una conversación agradable se vuelve incómoda." }
        ]
      },
      {
        "situation": "La misma fiesta. Han respondido en más o menos una frase cada vez y tampoco te han preguntado nada, pero están de frente a ti del todo, y dos veces ya han retomado algo que dijiste antes.",
        "prompt": "¿Cómo lo lees?",
        "options": [
          { "text": "Una señal, no tres. Sigue.", "correct": true, "note": "Las respuestas cortas por sí solas son una personalidad, no un veredicto. Estar de frente a ti y recordar lo que dijiste son las dos atención." },
          { "text": "Ninguna pregunta de vuelta significa ningún interés. Baja el ritmo.", "correct": false, "note": "Este es el error espejo: contar una señal como un veredicto. La lección es contarlas, y eso funciona en las dos direcciones." },
          { "text": "Pregúntales directamente si quieren seguir hablando.", "correct": false, "note": "Convierte la conversación en el tema de la conversación, lo que la termina de cualquier forma." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('reading-disinterest', 2,
  'Baja un registro',
  $md$Cuando lees desinterés, la respuesta no es irte de inmediato y no es esforzarte más. Es bajar un registro.

Bajar un registro significa devolver la conversación al nivel de calidez que claramente es bienvenido. De personal a simpático. De simpático a educado. No te estás retirando ni castigando, simplemente estás igualando lo que se ofrece.

**La jugada:** baja un nivel y quédate ahí a gusto.

Dos motivos por los que esto gana a irse en el acto. Quita la presión de inmediato, que es lo que de verdad querían, y con frecuencia la conversación mejora en cuanto lo hace, porque la incomodidad era el problema y no tú.

Y no te cuesta nada. Dos minutos simpáticos con alguien que no quiere flirtear contigo es un resultado perfectamente bueno. Tratarlo como una derrota es lo que convierte un momento neutro en uno malo.$md$,
  $j$[
    {
      "situation": "Has hecho un comentario cálido y han respondido solo a la parte factual.",
      "line": "(vuelve a la conversación simpática corriente, la misma energía, ningún cambio visible)",
      "why": "El paso hacia abajo debería ser invisible. Si te ven ajustándote, tienen que gestionar cómo te sientes al respecto."
    },
    {
      "situation": "Has bajado un registro y la conversación se ha relajado de forma notable.",
      "line": "(quédate aquí: este es un buen sitio)",
      "why": "Muy común. La presión era el problema, y sin ella consigues una conversación genuinamente agradable."
    },
    {
      "situation": "Has bajado un registro y siguen dando respuestas cerradas.",
      "line": "(baja uno más, y empieza a pensar en una salida cálida)",
      "why": "Si educado-y-simpático sigue sin aterrizar, la respuesta va sobre la conversación en sí y no sobre su temperatura."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Has leído bien el desinterés. ¿Cuál es la mejor respuesta inmediata?",
      "options": [
        { "text": "Vuelve a la conversación simpática corriente sin comentarlo.", "correct": true, "note": "Quita la presión al instante, no les exige nada, y a menudo produce una conversación genuinamente buena en cuanto se va la tensión." },
        { "text": "Vete directamente.", "correct": false, "note": "Una salida brusca hace obvio el motivo y les pide que se sientan responsables. Baja el ritmo en vez de cortar." },
        { "text": "Pregunta si has leído mal la situación.", "correct": false, "note": "Les obliga a decir que no en voz alta, que es exactamente la incomodidad que este enfoque existe para evitar." },
        { "text": "Quédate al mismo nivel pero sé más gracioso.", "correct": false, "note": "Esforzarte más después de una señal de parar es cómo un no educado se vuelve uno incómodo." }
      ],
      "explain": "Baja el nivel en silencio. El sentido es quitar la presión sin que ninguno de los dos tenga que reconocer que existía."
    },
    {
      "prompt": "Bajas un registro y de inmediato se relajan y se ponen más graciosos. ¿Qué ha pasado?",
      "options": [
        { "text": "Se estaban animando contigo desde el principio.", "correct": false, "note": "La mala lectura más común, e invierte lo que muestran las pruebas." },
        { "text": "Están siendo educados con el cambio.", "correct": false, "note": "La educación produce planitud, no más humor. Esto es alivio real." },
        { "text": "Deberías intentarlo otra vez dentro de unos minutos.", "correct": false, "note": "Esta es exactamente la lectura que convierte un rechazo en un problema que tienen que gestionar." },
        { "text": "La presión era el problema, no tú.", "correct": true, "note": "Querían la conversación sin el marco. Quitarlo te dio una genuinamente buena." }
      ],
      "explain": "Alguien que se anima en cuanto se levanta la presión te ha dicho lo que quería. Era la conversación, no el marco."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "stepped_down", "label": "Bajó un registro", "description": "Volvió al nivel de calidez que claramente era bienvenido." },
      { "key": "was_invisible", "label": "Hizo invisible el ajuste", "description": "Bajó sin que la otra persona tuviera que notarlo ni gestionarlo." },
      { "key": "stayed_warm", "label": "Se mantuvo genuinamente simpático", "description": "No se volvió frío, seco o visiblemente retraído." },
      { "key": "no_explanation", "label": "No lo nombró", "description": "Evitó preguntar por el cambio o comentarlo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Odhran",
        "role": "otro invitado, sentado a tu lado",
        "mood": "Disfrutando de la boda, contento con la compañía en la mesa.",
        "openness": 3,
        "personality": "Perfectamente agradable y sin igualar nada. La calidez que se le ofrece vuelve al mismo nivel en que empezó."
      },
      "sex": "female",
      "name": "Odile",
      "role": "otra invitada, sentada a tu lado",
      "mood": "Disfrutando de la boda, contenta con la compañía en la mesa.",
      "openness": 3,
      "personality": "Perfectamente contenta de hablar, del todo desinteresada en que le flirteen. Se vuelve notablemente más cálida y graciosa en cuanto el registro baja a simpático."
    },
    "setting": "El convite de una boda, el hueco largo entre la comida y el baile. Estás en una mesa con alguien a quien te sentaron al lado.",
    "constraints": [
      "Mantente en el personaje. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a cualquier calidez personal con respuestas breves, educadas y cerradas.",
      "Responde a la conversación simpática corriente con calidez, humor y curiosidad reales.",
      "Nunca expliques la diferencia ni comentes el cambio."
    ],
    "opening_beat": "Odile responde a tu último comentario cálido con una respuesta breve y educada y gira la atención hacia la mesa.",
    "success_looks_like": "La persona baja un registro sin anunciarlo, y la conversación se vuelve genuinamente disfrutable al nivel simpático."
  }$j$::jsonb,
  'Hoy, baja un registro en una conversación donde la calidez no se correspondió. Mantente simpático. Apunta qué cambió después de hacerlo.',
  NULL
);

select pg_temp.es_lesson('reading-disinterest', 3,
  'La salida elegante',
  $md$Dejar una conversación que no funciona es una habilidad concreta, y hacerlo bien importa más de lo que casi nadie se da cuenta.

Las malas salidas son todas reconocibles. Apagarse y quedarte ahí de pie. Esperar a que la terminen ellos. Irte de golpe en el momento en que captas el mensaje, lo que hace inconfundible el motivo. Cada una pone a la otra persona en la posición de tener que gestionar el final.

**La jugada:** termínala tú, con calidez, antes de que se vuelva incómoda, y da un motivo que no tenga nada que ver con ellos.

*Voy a ir a por algo de beber. Encantado de conocerte.* El motivo es neutro, la calidez es real, y eres tú quien se va. Esa última parte es lo que lo hace elegante: nunca tuvieron que terminarla ellos, así que nadie tiene que sentir que se escaparon de ellos.

Irte primero cuando no funciona no es una derrota. Es la jugada más considerada disponible, y es también la que te deja pareciendo más a gusto.$md$,
  $j$[
    {
      "situation": "Dos señales leídas, la conversación claramente no va a ningún sitio.",
      "line": "Voy a ir a saludar a un par de personas. Encantado de conocerte.",
      "why": "Motivo neutro, cierre cálido, y eres tú quien la termina. Nada aquí insinúa que algo saliera mal."
    },
    {
      "situation": "Un grupo al que te uniste no te ha incluido de verdad.",
      "line": "Os dejo con lo vuestro. Que disfrutéis del resto de la noche.",
      "why": "Reconoce que el grupo tiene lo suyo sin rastro de resentimiento. «Os dejo con lo vuestro» es cálido y no punzante."
    },
    {
      "situation": "Alguien ha estado educado y desconectado durante varios minutos.",
      "line": "Bueno, voy a por otra de estas. Un placer hablar contigo.",
      "why": "La línea de salida más útil que hay. Práctica, alegre, y sin ninguna relación con ellos."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hace elegante una salida en vez de incómoda?",
      "options": [
        { "text": "Explicar que notas que están ocupados.", "correct": false, "note": "Nombra lo que los dos estabais educadamente sin nombrar, y les pide que te tranquilicen de camino a la salida." },
        { "text": "Esperar a que ellos la terminen para que no seas tú quien se va.", "correct": false, "note": "Les pone el trabajo encima y normalmente significa que la conversación se alarga más allá del punto de comodidad." },
        { "text": "La terminas tú, con calidez, con un motivo que no tiene relación con ellos.", "correct": true, "note": "Nunca tienen que terminarla ellos y nada insinúa culpa. Un motivo neutro mantiene limpia la salida para los dos." },
        { "text": "Irte rápido en cuanto te das cuenta.", "correct": false, "note": "La brusquedad anuncia el motivo. Baja el ritmo durante unos segundos en vez de cortar." }
      ],
      "explain": "Sé quien se va, hazlo con calidez, y da un motivo sin relación con ellos."
    },
    {
      "prompt": "¿Cuál es la peor línea de salida, y por qué?",
      "options": [
        { "text": "Se nota que no estás muy de humor.", "correct": true, "note": "Nombra lo que los dos estabais educadamente sin nombrar, y les obliga a negarlo o confirmarlo. Las dos son peores que irse." },
        { "text": "Te dejo que sigas a lo tuyo.", "correct": false, "note": "Algo punzante y sobrevivible. Insinúa que notaste que estaban ocupados sin obligarles a responder por ello." },
        { "text": "Voy a por otra bebida.", "correct": false, "note": "La fiable. Neutra, práctica, y sin relación con ellos." },
        { "text": "Encantado de conocerte, debería ir circulando.", "correct": false, "note": "Cálida y convencional. A nadie le ha hecho daño nunca." }
      ],
      "explain": "Las peores salidas son las exactas. Nombrar por qué te vas les hace responsables de cómo te sentías."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "left_first", "label": "La terminó él mismo", "description": "Asumió la responsabilidad de cerrar en vez de esperar a que le soltaran." },
      { "key": "neutral_reason", "label": "Dio un motivo neutro", "description": "Ofreció un motivo sin relación con la otra persona ni con la conversación." },
      { "key": "stayed_warm", "label": "Se fue con calidez", "description": "La salida fue simpática en vez de seca, fría o disculpándose." },
      { "key": "good_timing", "label": "Se fue antes de que se pusiera incómodo", "description": "Salió en el momento correcto y no bastante después." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Piotr",
        "role": "alguien con quien te has puesto a hablar cerca de la barra",
        "mood": "Distraído, esperando a alguien.",
        "openness": 2,
        "personality": "Distraído y cortés. Responde, y no deja de mirar la sala por encima de tu hombro todo el rato."
      },
      "sex": "female",
      "name": "Petra",
      "role": "alguien con quien te has puesto a hablar cerca de la barra",
      "mood": "Distraída, esperando a alguien.",
      "openness": 2,
      "personality": "Civil y poco comunicativa. No hostil, sencillamente en otra parte. Responde bien y con calidez a una salida limpia."
    },
    "setting": "Una fiesta de lanzamiento abarrotada. Llevas unos cinco minutos hablando con alguien y no ha despegado.",
    "constraints": [
      "Mantente en el personaje. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Mantén las respuestas cortas y educadas. Nunca hagas una pregunta. No te animes durante la conversación.",
      "Si la persona ofrece una salida cálida con un motivo neutro, responde con simpatía genuina y deséale lo mejor.",
      "Si la persona sigue intentando reanimar la conversación, ponte algo más distraída."
    ],
    "opening_beat": "Petra da otra respuesta corta y mira más allá de ti hacia la entrada.",
    "success_looks_like": "La persona sale con calidez y por iniciativa propia, con un motivo neutro, y Petra responde con agrado."
  }$j$::jsonb,
  'Hoy, sé quien termina una conversación que no funciona. Cierre cálido, motivo neutro. Apunta qué se sintió al irte primero.',
  NULL
);

select pg_temp.es_lesson('reading-disinterest', 4,
  'No enfurruñarse',
  $md$Lo que pasa en los diez segundos después de un no es la parte que la gente recuerda de verdad.

Una caída visible de calidez, una despedida algo seca, un chiste con filo: todo eso comunica que tu simpatía era condicional. Eso es lo que incomoda a alguien, y es lo que van a recordar del encuentro. El no en sí no era nada.

**La jugada:** mantén tu calidez exactamente donde estaba, incluido después de haber decidido irte.

Esto es genuinamente difícil, porque que te digan que no produce un pequeño escozor y el escozor quiere expresarse. La disciplina es notarlo y dejar que los últimos treinta segundos sean tan simpáticos como los primeros treinta.

Hay un argumento egoísta además del decente. La gente habla, las salas son pequeñas, y a quien es cálido de camino a la salida se le recuerda como buena compañía. Pero el argumento decente basta por sí solo: no hicieron nada mal al no estar interesados, y no deberían tener que pagarlo.$md$,
  $j$[
    {
      "situation": "Acabas de leer un no claro y estás bajando el ritmo.",
      "line": "(la misma sonrisa, el mismo tono, la misma calidez que hace cinco minutos)",
      "why": "La consistencia es todo. Si tu calidez no cambia, no ha pasado nada incómodo."
    },
    {
      "situation": "Sientes el escozor y te notas a punto de ponerte plano.",
      "line": "(nótalo, y no actúes sobre él)",
      "why": "El sentimiento es normal. Expresarlo es el error, y el hueco entre las dos cosas está completamente bajo tu control."
    },
    {
      "situation": "Dicen algo simpático mientras te vas.",
      "line": "(responde con la misma calidez que habrías tenido al principio)",
      "why": "El último intercambio es lo que se recuerda. Responder con calidez aquí es lo que convierte todo el encuentro en algo bueno para ellos."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué importa tanto mantener constante tu calidez después de un no?",
      "options": [
        { "text": "Podría hacer que se lo replanteen.", "correct": false, "note": "Trata la elegancia como una táctica más, que es lo contrario del sentido. La calidez ofrecida para cambiar un no no es calidez." },
        { "text": "Demuestra que tu simpatía no dependía de conseguir algo.", "correct": true, "note": "Esto es lo que la gente registra de verdad. Una caída de calidez revela retroactivamente que la calidez anterior era una transacción." },
        { "text": "Evita que la conversación termine.", "correct": false, "note": "La conversación debería terminar. La calidez va sobre cómo termina, no sobre alargarla." },
        { "text": "Hace que parezcas seguro de ti mismo.", "correct": false, "note": "Lo hace, y es un efecto secundario. Hacerlo por la apariencia tiende a producir una versión visiblemente actuada." }
      ],
      "explain": "Una caída de calidez después de un no les dice que la calidez era un pago por algo. Eso es lo que se recuerda."
    },
    {
      "prompt": "¿Cuál es la señal de que la calidez de alguien era condicional?",
      "options": [
        { "text": "Se van rápido después de que les rechacen.", "correct": false, "note": "Irse está bien y a menudo es correcto. Lo que importa es la temperatura de la ida." },
        { "text": "Se vuelven educados en vez de simpáticos.", "correct": true, "note": "El cambio de cálido a correcto es la señal. No se ha dicho nada, y se ha comunicado todo." },
        { "text": "Dejan de hacer preguntas.", "correct": false, "note": "Una conversación que se apaga de forma natural también hace esto." },
        { "text": "Hacen una broma al respecto.", "correct": false, "note": "A menudo lo contrario. Una broma ligera puede ser la respuesta más elegante disponible." }
      ],
      "explain": "La calidez que cae a mera educación es lo que revela que la calidez anterior era un pago. Se siente con precisión, y nunca se menciona."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "warmth_held", "label": "Mantuvo constante la calidez", "description": "Los últimos treinta segundos fueron tan simpáticos como los primeros treinta." },
      { "key": "no_edge", "label": "Sin filo en la salida", "description": "Ningún tono seco, broma punzante o retirada visible." },
      { "key": "felt_it_without_showing", "label": "Notó el escozor sin actuar sobre él", "description": "Registró la decepción en privado en vez de expresarla." },
      { "key": "left_them_comfortable", "label": "Los dejó cómodos", "description": "La otra persona no se sintió responsable del resultado." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Milo",
        "role": "alguien con quien has hablado unas veces en este gimnasio",
        "mood": "Cálido, a mitad de sesión, del todo cómodo.",
        "openness": 3,
        "personality": "Simpático y sin nada romántico en ello. Va a seguir siendo simpático pase lo que pase, que es lo que hace difícil de leer esta."
      },
      "sex": "female",
      "name": "Mira",
      "role": "alguien con quien has hablado unas veces en este gimnasio",
      "mood": "Cálida, a mitad de sesión, del todo cómoda.",
      "openness": 3,
      "personality": "Amable y directa. Dice que no con claridad y sin suavizarlo de más, y luego quiere de verdad que la simpatía continúe."
    },
    "setting": "Un rocódromo. Habéis estado charlando entre vías y acabas de sugerir tomar un café algún día.",
    "constraints": [
      "Mantente en el personaje. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Declina con claridad y amabilidad, y luego sigue la conversación con normalidad de inmediato.",
      "Si la persona se mantiene cálida, muéstrate relajada y simpática y sigue charlando encantada.",
      "Si la persona se pone seca, plana o punzante, ponte notablemente más reservada y baja el ritmo de la conversación."
    ],
    "opening_beat": "Mira dice que gracias, pero que ahora mismo no está buscando eso, y luego pregunta cómo te fue en tu última vía.",
    "success_looks_like": "La persona acepta el no sin ninguna caída de calidez y responde a su repregunta con la misma calidez que antes."
  }$j$::jsonb,
  'Hoy, fíjate en un momento en que algo no saliera como querías socialmente, y mantén tu calidez exactamente donde estaba. Apunta qué sentiste y qué hiciste.',
  NULL
);

select pg_temp.es_lesson('reading-disinterest', 5,
  'Cuando de verdad no lo sabes',
  $md$A veces las señales están mezcladas. Respuestas cálidas y ninguna pregunta. Se quedan, y están orientados hacia otro lado. Has contado y el recuento sale ambiguo.

El instinto es seguir hasta que se resuelva, lo que significa seguir aplicando calidez hasta que el cuadro se aclare. Esa es la respuesta equivocada, porque quien está resolviendo es la otra persona, y le estás pidiendo que lo haga bajo presión.

**La jugada:** cuando no puedas saberlo, trátalo como un no y mantente simpático.

Esto no es pesimismo. Es que el coste de los dos errores no es simétrico. Tratar un quizás como un no te cuesta a ti una posibilidad. Tratar un quizás como un sí les cuesta a ellos unos minutos incómodos y les pone en la posición de tener que ser explícitos. Uno de esos es muchísimo peor que el otro, y no es el que sientes más.

Hay también un punto práctico. El interés genuino suele volverse inequívoco si le das espacio. Si sigue siendo ambiguo después de que hayas dejado de presionar, esa ambigüedad era la respuesta.$md$,
  $j$[
    {
      "situation": "Respuestas cálidas y ni una sola pregunta de vuelta después de diez minutos.",
      "line": "(trátalo como un no, mantente simpático, disfruta la conversación)",
      "why": "El cuadro mezclado se resuelve a favor de la cautela, y la conversación sigue siendo perfectamente buena a nivel simpático."
    },
    {
      "situation": "Bajaste un registro y se volvieron notablemente más cálidos.",
      "line": "(esa es tu respuesta: esto es una buena conversación, no una atracción mutua)",
      "why": "Animarse en cuanto se levanta la presión es una de las señales más claras que hay, y con frecuencia se malinterpreta como ánimo."
    },
    {
      "situation": "Te están dando señales genuinamente mezcladas y te pillas construyendo un argumento para la lectura optimista.",
      "line": "(nota que estás discutiendo con las pruebas)",
      "why": "Construir un argumento a favor del interés es en sí mismo una señal fiable de que no está ahí. El interés real no suele necesitar un caso."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Las señales son genuinamente ambiguas. ¿Cuál es el criterio correcto y por qué?",
      "options": [
        { "text": "Trátalo como un sí, ya que te arrepentirás de no intentarlo.", "correct": false, "note": "Pesa más tu posible arrepentimiento que su posible incomodidad. Quien carga con el coste de esa elección no eres tú." },
        { "text": "Pídeles directamente que lo aclaren.", "correct": false, "note": "Resuelve tu incertidumbre obligándoles a decirlo en voz alta, que es la incomodidad de la que intentabas ahorrarles." },
        { "text": "Trátalo como un no y mantente simpático, porque los dos errores no cuestan lo mismo.", "correct": true, "note": "Un no equivocado te cuesta una posibilidad. Un sí equivocado les cuesta un intercambio incómodo y les obliga a ser explícitos." },
        { "text": "Sigue escalando despacio hasta que se aclare.", "correct": false, "note": "Esto es aplicar presión hasta que alguien lo resuelva, y ese alguien son ellos." }
      ],
      "explain": "Los dos errores no cuestan lo mismo, y el más caro no es el que tú sientes más. La ambigüedad se resuelve como no."
    },
    {
      "prompt": "Estás construyendo en tu cabeza un caso de por qué podrían estar interesados. ¿Qué es eso?",
      "options": [
        { "text": "Un análisis razonable de señales mezcladas.", "correct": false, "note": "Se siente como análisis, y este tipo de análisis llega de forma fiable a la conclusión que se propuso." },
        { "text": "Útil, mientras lo contrastes con su conducta.", "correct": false, "note": "El caso ya está construido a partir de su conducta, de forma selectiva. Contrastarlo con las mismas pruebas no cambia nada." },
        { "text": "Una señal de que las señales no están ahí.", "correct": true, "note": "El interés real no necesita un caso. Si estás reuniendo pruebas, ya sabes a qué se parecen las pruebas." },
        { "text": "Normal. Todo el mundo lo hace.", "correct": false, "note": "Cierto, y sigue siendo la señal. Que sea común no significa que no sea informativo." }
      ],
      "explain": "El interés mutuo no suele ser un puzle. Necesitar convencerte a ti mismo es la respuesta llegando disfrazada."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "defaulted_to_no", "label": "Fue por defecto al no", "description": "Trató la ambigüedad genuina como un no en vez de como una invitación a continuar." },
      { "key": "stayed_friendly", "label": "Se mantuvo simpático igualmente", "description": "Mantuvo la conversación cálida y disfrutable a nivel simpático." },
      { "key": "noticed_the_argument", "label": "Notó la lectura esperanzada", "description": "Se pilló construyendo un caso para la interpretación optimista." },
      { "key": "no_pressure_to_resolve", "label": "No presionó por claridad", "description": "Evitó obligar a la otra persona a declarar su postura explícitamente." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Alex",
        "role": "alguien que se ha unido al mismo equipo esta noche",
        "mood": "Pasándolo genial, en buena forma.",
        "openness": 4,
        "personality": "En buena forma y difícil de leer, porque es así con todo el mundo de la sala y siempre lo ha sido."
      },
      "sex": "female",
      "name": "Alex",
      "role": "alguien que se ha unido al mismo equipo esta noche",
      "mood": "Pasándolo genial, en buena forma.",
      "openness": 4,
      "personality": "Naturalmente cálida y físicamente cercana con todo el mundo, lo que hace las señales genuinamente difíciles de leer. Interesada en la noche, no en la persona."
    },
    "setting": "Un concurso de preguntas en un bar. Lleváis toda la noche en el mismo equipo improvisado con alguien que acabas de conocer.",
    "constraints": [
      "Mantente en el personaje. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Sé cálida, físicamente cercana y llena de cumplidos todo el rato. Así eres sencillamente con todo el mundo.",
      "Nunca hagas una pregunta personal a la persona, y nunca respondas a la calidez personal con nada más que simpatía general.",
      "Si la persona lo mantiene simpático, pasa una noche estupenda con ella. Si escala, ponte brevemente incómoda y gírate hacia el resto del equipo."
    ],
    "opening_beat": "Alex se está riendo, se inclina para oír por encima del ruido, y acaba de llamarte lo mejor de este equipo.",
    "success_looks_like": "La persona lee la ambigüedad con honestidad, nota la ausencia de curiosidad recíproca, va por defecto al no, y mantiene la noche disfrutable."
  }$j$::jsonb,
  'Hoy, encuentra una situación que genuinamente no pudieras leer, y ve por defecto al no manteniéndote cálido. Apunta las señales que estaban mezcladas y qué decidiste.',
  $j${
    "beats": [
      {
        "situation": "Lleváis veinte minutos hablando y de verdad no puedes leerlo. Están cálidos e implicados, y también han mencionado dos veces una mañana ocupada mañana.",
        "prompt": "¿Qué haces?",
        "options": [
          { "text": "Tratarlo como un no, mantenerte exactamente igual de cálido, y dejar que la noche vaya a donde vaya.", "correct": true, "note": "El criterio por defecto cuando no puedes saberlo. No te cuesta nada, y es la única lectura cómoda para los dos si te equivocas." },
          { "text": "Preguntar algo que lo resolvería en una dirección u otra.", "correct": false, "note": "Resolverlo es tu problema, no el suyo. Obligar a alguien a responder una pregunta que ha estado evitando es presión, por muy suavemente que se plantee." },
          { "text": "Enfriarte un poco para que no te pillen desprevenido.", "correct": false, "note": "Eso es el enfurruñamiento en su forma temprana. La calidez que se retira en cuanto no está segura de una devolución nunca fue calidez." }
        ]
      },
      {
        "situation": "Más tarde, la misma conversación. Sigues sin estar seguro. Se han quedado, dos veces, en momentos en que irse habría sido fácil.",
        "prompt": "¿Qué haces?",
        "options": [
          { "text": "Nada distinto. Sigue cálido y disfrutándolo.", "correct": true, "note": "Quedarse cuando irse era fácil es una prueba real, y sigue sin obligarte a hacer nada al respecto esta noche." },
          { "text": "Leer que se quedaran como un sí y subir la calidez dos escalones.", "correct": false, "note": "Una sola prueba, dos escalones. Esa es la aritmética que incomoda a la gente." },
          { "text": "Decidir que es ilegible e irte.", "correct": false, "note": "Ir por defecto al no significa no perseguirlo, no castigarlo yéndote." }
        ]
      }
    ]
  }$j$::jsonb
);
