-- Spanish: Conocer a alguien, track 6 — Pedir el número. Last track of the
-- topic.
--
-- Conventions as migration 129, including the full `partner.alt` sex-swap
-- translation.

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

select pg_temp.es_lesson('asking-for-the-number', 1,
  'Pídelo antes del pico',
  $md$Casi todo el mundo lo pide demasiado tarde, y no es el nervio lo que lo causa. Es esperar a un momento que no llega.

No hay un punto perfecto. Lo que hay es un tramo en el que claramente va bien: los dos os reís, ninguno ha mirado la hora, la conversación sigue encontrando sitios nuevos adonde ir, y luego un declive lento a medida que la noche, la cola, o el café se agotan. La petición pertenece al primero de esos tramos, mientras todavía está subiendo.

**La jugada:** pídelo mientras todavía va bien, no cuando te vas.

Irse es el peor momento disponible y es al que la gente recurre por defecto, porque se siente como el final natural de una conversación. Pero para entonces la cosa ya se ha enfriado, los dos estáis medio girados hacia la puerta, y la petición llega sin nada detrás: hay que justificarla desde cero en vez de que se derive de lo que acaba de pasar.

Pedirlo pronto tiene una segunda ventaja que nadie menciona. Si dicen que sí, el resto de la conversación se relaja para los dos, porque la pregunta que los dos estabais sosteniendo en silencio queda respondida. Si dicen que no, puedes ser cálido al respecto y seguir en vez de irte con eso encima.

El coste de pedirlo unos minutos antes es nada. El coste de pedirlo unos minutos tarde es todo.$md$,
  $j$[
    {
      "situation": "Quince buenos minutos dentro. Ninguno de los dos ha mirado el móvil.",
      "line": "(pídelo ahora, mientras todavía está subiendo)",
      "why": "La petición se deriva de lo que acaba de pasar en vez de tener que justificarse a sí misma. No va a llegar un momento mejor, solo uno más silencioso."
    },
    {
      "situation": "Han empezado a mirar hacia sus amigos y la energía ha bajado.",
      "line": "(pídelo igualmente, de inmediato, en vez de esperar a la puerta)",
      "why": "Tarde es peor que pronto y la puerta es lo más tarde que hay. Una petición algo apagada sigue ganando a una entregada en el perchero."
    },
    {
      "situation": "Has preguntado, han dicho que sí, y quedan diez minutos.",
      "line": "(sigue: ahora es más fácil)",
      "why": "La pregunta que los dos estabais sosteniendo en silencio queda respondida, y el resto se relaja para los dos. Ese es el beneficio oculto de preguntar pronto."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué preguntar al irte es el peor momento?",
      "options": [
        { "text": "Es educado y parece el final natural.", "correct": false, "note": "Parece natural, que es exactamente por lo que la gente recurre a ello por defecto. Parecer natural y funcionar son propiedades distintas." },
        { "text": "El momento se ha enfriado, así que la petición tiene que justificarse desde cero.", "correct": true, "note": "Pedida mientras va bien, la petición se deriva de lo que acaba de pasar. Pedida en la puerta, llega sin nada detrás y los dos ya estáis medio girados hacia otro lado." },
        { "text": "No vais a tener tiempo de hablar después.", "correct": false, "note": "Cierto y secundario. El problema es lo que tiene que cargar la petición, no lo que viene después." },
        { "text": "Se van a sentir emboscados.", "correct": false, "note": "Rara vez aterriza así. Sobre todo aterriza plano, que es un fallo distinto." }
      ],
      "explain": "Pregunta mientras está subiendo. En la puerta la petición tiene que hacer todo el trabajo ella sola."
    },
    {
      "prompt": "Preguntas pronto y dicen que sí. ¿Qué te ha comprado eso?",
      "options": [
        { "text": "Poca cosa: el sí es el sí.", "correct": false, "note": "El sí es el sí, y el tiempo que queda cambia por completo de carácter en cuanto se da." },
        { "text": "Puedes irte cuando quieras.", "correct": false, "note": "Una forma de describir el beneficio que convierte sin ruido la conversación en una transacción." },
        { "text": "El resto de la conversación se relaja, porque la pregunta sostenida queda respondida.", "correct": true, "note": "Los dos la estabais cargando. Responderla pronto es por lo que las peticiones tempranas suelen producir mejores últimos diez minutos que las tardías." },
        { "text": "Demuestra que tenías seguridad.", "correct": false, "note": "Gestión de imagen. Algo que pasa y no el motivo para hacerlo." }
      ],
      "explain": "Un sí temprano mejora el tiempo que os queda. Uno tardío solo lo termina."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "timing", "label": "Preguntó mientras iba bien", "description": "Preguntó durante la subida en vez de en la salida." },
      { "key": "did_ask", "label": "Preguntó de verdad", "description": "Hizo la petición en vez de esperar un momento mejor." },
      { "key": "warm", "label": "Lo mantuvo cálido", "description": "Preguntó en el registro de la conversación en vez de cambiar a uno formal." },
      { "key": "carried_on", "label": "Siguió después", "description": "No trató la petición como el final de la conversación." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Nadim",
        "role": "alguien con quien te has puesto a hablar en la barra",
        "mood": "Relajado, buena noche hasta ahora.",
        "openness": 4,
        "personality": "Compañía fácil y claramente disfrutando de esto. Sigue hablando encantado mientras la persona lo haga, y empezará a irse hacia sus amigos si la conversación se queda sin sitios adonde ir."
      },
      "sex": "female",
      "name": "Nadia",
      "role": "alguien con quien te has puesto a hablar en la barra",
      "mood": "Relajada, buena noche hasta ahora.",
      "openness": 4,
      "personality": "Compañía fácil y claramente disfrutando de esto. Sigue hablando encantada mientras la persona lo haga, y empezará a irse hacia sus amigas si la conversación se queda sin sitios adonde ir."
    },
    "setting": "Un bar. Lleváis unos quince minutos hablando y ha sido fácil todo el rato. Sus amigos están al otro lado de la sala y nadie tiene prisa.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con calidez a una petición hecha mientras la conversación sigue animada.",
      "Enfríate poco a poco si la conversación se alarga sin ir a ningún sitio, y menciona finalmente a tus amigos.",
      "Nunca pidas tú el número de la persona."
    ],
    "opening_beat": "«Vale, así que ahora tengo que ir de verdad a probar ese sitio, o vas a saber que mentía.»",
    "success_looks_like": "La persona pregunta mientras la conversación todavía va bien en vez de esperar una salida."
  }$j$::jsonb,
  'Hoy, fíjate en una conversación mientras todavía está subiendo y nombra el momento para ti mismo. Apunta cuándo estuvo el pico y si te habrías esperado a pasarlo.',
  $j${
    "beats": [
      {
        "situation": "Quince buenos minutos dentro. Os estáis riendo los dos, nadie ha mirado la hora, y sus amigos están al otro lado de la sala.",
        "prompt": "¿Cuándo preguntas?",
        "options": [
          { "text": "Esperar a un bache natural, para no interrumpir nada.", "correct": false, "note": "Un bache es el principio del declive, no una puerta. La buena versión de este momento es en la que ya estás." },
          { "text": "Ahora, mientras todavía está subiendo.", "correct": true, "note": "La petición se deriva de lo que acaba de pasar en vez de tener que justificarse. No va a llegar un momento mejor, solo uno más silencioso." },
          { "text": "Al irte, para que no haya incomodidad después.", "correct": false, "note": "Lo por defecto, y el peor momento disponible. En la puerta los dos estáis medio girados y la petición llega sin nada detrás." },
          { "text": "En cuanto mencionen que se van, para saber que la noche está terminando.", "correct": false, "note": "Eso es la puerta con pasos extra. Estarías preguntándole a una conversación que ya ha terminado." }
        ]
      },
      {
        "situation": "Preguntaste pronto, dijeron que sí, y quedan diez minutos de la noche.",
        "prompt": "¿Qué haces con los diez minutos?",
        "options": [
          { "text": "Terminar pronto, mientras está en un pico alto.", "correct": false, "note": "Irte justo con el sí convierte el sí en el punto de la conversación. No lo era." },
          { "text": "Empezar a planificar los detalles.", "correct": false, "note": "Convierte una noche cálida en logística. Los detalles son para lo que está el primer mensaje." },
          { "text": "Seguir exactamente como estabas.", "correct": true, "note": "La pregunta que los dos estabais sosteniendo en silencio queda respondida, y el resto se relaja para los dos. Ese es el beneficio oculto de preguntar pronto." },
          { "text": "Subir un escalón, ahora que está confirmado.", "correct": false, "note": "Un sí a un café no es licencia para cambiar de registro. Misma conversación, una cosa menos que cargar." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('asking-for-the-number', 2,
  'Di qué te apetece hacer',
  $md$Un número pedido a secas es una petición de permiso para contactar a alguien. Es vago, es abierto, y no está claro a qué se les está pidiendo que accedan, que es por lo que la respuesta honesta suele ser una vacilación.

**La jugada:** pega la petición a una cosa concreta que te gustaría hacer.

Ese sitio que los dos dijisteis que sonaba bien. El concierto que mencionaron. El mercadillo del sábado que salió hace veinte minutos. Algo de esta conversación, no una propuesta genérica, porque algo de esta conversación demuestra que estabas escuchando y convierte la petición en una continuación en vez de en un giro.

*¿Me das tu número?* pide acceso. *Hay un sitio cerca de aquí que hace lo que describías: dame tu número y averiguo si es bueno* pide un plan. El segundo es más fácil de aceptar, porque saben a qué están accediendo. También es más fácil de rechazar, lo cual no es una desventaja: una petición difícil de declinar no es de verdad una petición, y todo en las dos lecciones siguientes depende de que esta se pueda responder en los dos sentidos.

Mantenlo pequeño. Un café, una copa, una hora. Un fin de semana fuera no es una primera propuesta, ni tampoco nada que exija que reorganicen un día por alguien que conocieron hace cuarenta minutos.$md$,
  $j$[
    {
      "situation": "Han pasado cinco minutos hablando de una comida que no encuentran en ningún sitio de esta ciudad.",
      "line": "Hay un sitio a dos calles de aquí que hace eso. Dame tu número y vamos a averiguar si es bueno.",
      "why": "Concreto, pequeño, y sacado de la conversación, lo que demuestra que estabas escuchando. Saben exactamente a qué están diciendo que sí."
    },
    {
      "situation": "Estás a punto de decir «¿me das tu número?».",
      "line": "(encuentra primero la cosa de los últimos veinte minutos)",
      "why": "Por sí sola, la petición pide acceso en vez de proponer algo, y la vaguedad es lo que produce la vacilación. Algo de la conversación la convierte en una continuación."
    },
    {
      "situation": "El plan que estás a punto de proponer ocupa casi todo un día.",
      "line": "(que sea una hora)",
      "why": "Las propuestas pequeñas son fáciles de aceptar de alguien a quien acabas de conocer hace cuarenta minutos. Las grandes les piden comprometer un día con un desconocido."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué pegar la petición a algo concreto?",
      "options": [
        { "text": "Es más romántico.", "correct": false, "note": "No va tanto de eso. Es más concreto, que es algo distinto y más útil." },
        { "text": "Saben a qué están accediendo.", "correct": true, "note": "Una petición de número a secas pide acceso sin decir para qué, y la vaguedad es lo que produce la vacilación. Un plan simplemente se puede aceptar." },
        { "text": "Hace más difícil rechazarlo.", "correct": false, "note": "Lo contrario, y a propósito. También es más fácil rechazarlo, que es lo que hace que el sí merezca la pena." },
        { "text": "Demuestra que lo has pensado.", "correct": false, "note": "Demuestra que estabas escuchando, que está cerca y no es el mecanismo. El mecanismo es la claridad sobre qué se está pidiendo." }
      ],
      "explain": "Pide un plan, no acceso. A un plan simplemente se puede responder."
    },
    {
      "prompt": "¿De dónde debería salir la cosa concreta?",
      "options": [
        { "text": "De algún sitio al que ya querías llevar a alguien.", "correct": false, "note": "Perfectamente válido y se lee como genérico, porque lo es: existía antes de que existieran ellos." },
        { "text": "De lo que sea más cercano.", "correct": false, "note": "Conveniente y arbitrario. La cercanía no es un motivo que puedan sentir." },
        { "text": "De algo seguro que sabes que impresiona.", "correct": false, "note": "Lo impresionante sube lo que está en juego y el esfuerzo de los dos lados. Pequeño y concreto gana a impresionante aquí." },
        { "text": "De esta conversación.", "correct": true, "note": "Demuestra que estabas escuchando y convierte la petición en la continuación de lo que ya estabais haciendo en vez de un giro hacia otro modo." }
      ],
      "explain": "Saca el plan de los últimos veinte minutos. Eso es lo que hace que sea suyo y no un guion."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "specific", "label": "Nombró algo concreto", "description": "Propuso un plan real en vez de pedir acceso." },
      { "key": "from_the_talk", "label": "Lo sacó de la conversación", "description": "Usó algo que habían dicho en vez de una salida genérica." },
      { "key": "small", "label": "Lo mantuvo pequeño", "description": "Una hora o dos, no un día." },
      { "key": "clear", "label": "Hizo la petición con claridad", "description": "Pidió de verdad el número en vez de insinuarlo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Dev",
        "role": "alguien que comparte contigo la mesa larga",
        "mood": "Sin prisa, disfrutando del desvío.",
        "openness": 4,
        "personality": "Hablador y concreto. Se ilumina cuando vuelve algo que dijo antes, y se pone educadamente vago ante cualquier cosa genérica."
      },
      "sex": "female",
      "name": "Priya",
      "role": "alguien que comparte contigo la mesa larga",
      "mood": "Sin prisa, disfrutando del desvío.",
      "openness": 4,
      "personality": "Habladora y concreta. Se ilumina cuando vuelve algo que dijo antes, y se pone educadamente vaga ante cualquier cosa genérica."
    },
    "setting": "Una cafetería, veinte minutos dentro de una conversación que empezó por accidente. Han pasado un buen rato describiendo un tipo de comida que no han encontrado desde que se mudaron aquí.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con calidez y de forma concreta a un plan sacado de algo que dijiste.",
      "Responde con educación y vaguedad a una petición de número a secas.",
      "No te alargues más de unas pocas frases."
    ],
    "opening_beat": "«...y la verdad es que lo he buscado. En toda esta ciudad no lo hacen bien en ningún sitio.»",
    "success_looks_like": "La persona pide el número pegado a un plan pequeño y concreto sacado de lo que dijo la otra persona."
  }$j$::jsonb,
  'Hoy, convierte en voz alta algo que diga alguien en un plan pequeño y concreto, pidas algo o no. Apunta qué dijeron y qué propusiste.',
  $j${
    "says": "...y la verdad es que lo he buscado. En toda esta ciudad no lo hacen bien en ningún sitio.",
    "model": {
      "line": "Hay un sitio a dos calles que lo hace. Dame tu número y averiguamos si es bueno.",
      "why": "El plan sale directamente de lo que acaban de decir, es pequeño, y dice exactamente qué se propone. Saben a qué están diciendo que sí, que es lo que hace fácil responder en cualquiera de los dos sentidos."
    },
    "checks": [
      { "kind": "contains_any", "words": ["número", "teléfono", "dame el tuyo"], "requirement": "Pide de verdad, no lo insinúes" },
      { "kind": "contains_any", "words": ["sitio", "vamos", "probar", "averiguar", "te llevo", "te enseño", "comer", "comida", "allí"], "requirement": "Nombra el plan, no solo el número" },
      { "kind": "max_words", "n": 35, "requirement": "Menos de treinta y cinco palabras: un plan, no un discurso" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('asking-for-the-number', 3,
  'Que decir que no salga gratis',
  $md$Esta es la lección que decide cómo se siente la petición para los dos, y es la que la gente tímida está mejor situada para hacer bien, porque el instinto que hay detrás ya está ahí.

Alguien que no puede declinar con comodidad no ha sido preguntado de verdad. Si la formulación hace caro un no (si exigiera una excusa, una disculpa, o una pequeña actuación de pesar), entonces lo que están respondiendo no es tu pregunta sino el coste de rechazarla. Y un sí dado bajo esa presión no es información.

**La jugada:** construye la salida dentro de la frase.

*Si te apetece.* *Sin ninguna presión.* *Solo si te va.* Media oración, al final, dicha con ligereza. No es un matiz y no es una disculpa: es lo que hace que un sí signifique sí.

Y luego dilo y para. El fallo más común aquí no es la formulación, es rellenar el silencio de después: añadir una segunda versión de la pregunta, reírte, o seguir hablando por encima. Eso retira la salida, porque ahora tienen que interrumpirte para responder. Pregunta, luego calla, y deja que la pausa sea suya.

Hay una línea entre una salida y una disculpa, y merece la pena verla con claridad. *Si te apetece* les da espacio. *Perdona, esto probablemente es raro, pero* ocupa el espacio y lo llena con tu incomodidad: les pide que te tranquilicen, que es un favor más grande que el número.$md$,
  $j$[
    {
      "situation": "Acabas de proponer el plan y has pedido el número.",
      "line": "...si te apetece.",
      "why": "Media oración, al final, dicha con ligereza. No cuesta nada y es lo que hace que un sí signifique sí en vez de significar educación."
    },
    {
      "situation": "Has preguntado y hay un silencio de dos segundos.",
      "line": "(no digas nada)",
      "why": "La pausa es suya. Rellenarla retira la salida, porque ahora tienen que interrumpirte para poder responder."
    },
    {
      "situation": "Estás a punto de abrir con «perdona, esto probablemente es raro».",
      "line": "(córtalo: eso es una disculpa, no una salida)",
      "why": "Una salida les da espacio. Una disculpa llena ese espacio con tu incomodidad y les pide que te tranquilicen, que es un favor más grande que el número."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la diferencia entre una salida y una disculpa?",
      "options": [
        { "text": "Una salida les da espacio; una disculpa les pide que te tranquilicen.", "correct": true, "note": "«Si te apetece» no les cuesta nada. «Perdona, esto probablemente es raro» les entrega tu incomodidad para gestionar, que es una petición más grande que la que traías." },
        { "text": "No hay diferencia real: las dos lo suavizan.", "correct": false, "note": "Suavizan cosas distintas. Una suaviza la petición, la otra te suaviza a ti, y solo una de las dos les ayuda a responder." },
        { "text": "Una disculpa es más honesta.", "correct": false, "note": "Honesta sobre tus nervios, y no hace más respondible la petición, que es el trabajo aquí." },
        { "text": "Una salida es lo que usa la gente segura.", "correct": false, "note": "Estilo más que mecanismo. Una salida funciona por lo que les cuesta a ellos, no por quién la dice." }
      ],
      "explain": "Dales espacio. No les des tus nervios para que los sostengan."
    },
    {
      "prompt": "Has preguntado, y hay un silencio. ¿Qué haces?",
      "options": [
        { "text": "Preguntar otra vez con más ligereza, por si no quedó claro.", "correct": false, "note": "Dos versiones de una pregunta son más difíciles de responder que una, y señala que la primera no iba en serio." },
        { "text": "Reírte y cambiar de tema.", "correct": false, "note": "Retira la petición del todo y les deja sin nada a lo que decir que sí." },
        { "text": "Nada. Deja que la pausa sea suya.", "correct": true, "note": "El fallo más común no es la formulación, es rellenar el silencio. Hablar por encima de tu propia pregunta significa que tienen que interrumpirte para aceptarla." },
        { "text": "Añadir que está bien de cualquiera de las dos formas.", "correct": false, "note": "Ya construiste la salida dentro. Repetirla empieza a sonar a que esperas un no." }
      ],
      "explain": "Pregunta, y luego para. Un silencio después de una pregunta pertenece a quien la responde."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "exit", "label": "Construyó una salida", "description": "Hizo que declinar no les costara nada." },
      { "key": "not_apology", "label": "No se disculpó", "description": "Dio espacio en vez de entregar su propia incomodidad." },
      { "key": "stopped", "label": "Dejó de hablar", "description": "Dejó que el silencio después de la pregunta fuera suyo." },
      { "key": "still_asked", "label": "Aun así hizo una petición real", "description": "Suavizó el coste del no sin difuminar la pregunta." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Idris",
        "role": "alguien que has conocido esta noche en la fiesta",
        "mood": "Cálido, algo cansado, buena noche.",
        "openness": 4,
        "personality": "Amable y fácil de hacer responsable de los sentimientos de los demás. Responde con sencillez a una petición limpia y empieza a tranquilizar a la persona si la petición llega envuelta en disculpas."
      },
      "sex": "female",
      "name": "Iris",
      "role": "alguien que has conocido esta noche en la fiesta",
      "mood": "Cálida, algo cansada, buena noche.",
      "openness": 4,
      "personality": "Amable y fácil de hacer responsable de los sentimientos de los demás. Responde con sencillez a una petición limpia y empieza a tranquilizar a la persona si la petición llega envuelta en disculpas."
    },
    "setting": "El final de una conversación larga en la fiesta de un amigo. Ha ido bien y acabas de decidir preguntar.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Haz una pausa breve antes de responder a cualquier petición, para que el silencio sea real.",
      "Responde con calidez y sin dudarlo a una petición limpia y sin disculpas.",
      "Empieza a tranquilizar a la persona si la petición llega envuelta en disculpas, y deja que eso se convierta en el tema."
    ],
    "opening_beat": "«Debería ir buscando mi abrigo en algún momento. Ha sido una conversación mucho mejor de lo que esperaba tener esta noche.»",
    "success_looks_like": "La persona pregunta con la salida construida dentro, y luego deja de hablar."
  }$j$::jsonb,
  'Hoy, pide una cosa corriente con la salida construida dentro, y luego no digas nada hasta que respondan. Apunta qué pediste y cuánto duró la pausa.',
  $j${
    "says": "Debería ir buscando mi abrigo en algún momento. Ha sido una conversación mucho mejor de lo que esperaba tener esta noche.",
    "model": {
      "line": "Entonces dame tu número y lo hacemos bien en algún sitio, si te apetece.",
      "why": "Una petición clara con la salida construida en la última parte. Les da espacio sin entregarles ninguna incomodidad que gestionar, y luego para."
    },
    "checks": [
      { "kind": "contains_any", "words": ["número", "teléfono"], "requirement": "Haz una petición real, no una insinuación" },
      { "kind": "contains_any", "words": ["si te apetece", "si te va", "si quieres", "si te gustaría", "sin presión", "solo si", "como quieras", "de cualquier forma"], "requirement": "Construye la salida dentro de la frase" },
      { "kind": "forbids_any", "words": ["perdona", "raro", "mal rollo", "sé que esto es", "espero que esté bien", "espero que no te importe"], "requirement": "Una salida, no una disculpa" },
      { "kind": "max_words", "n": 25, "requirement": "Menos de veinticinco palabras, y luego deja de hablar" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('asking-for-the-number', 4,
  'El no suave',
  $md$Casi todos los noes son suaves, y ese es el problema. Casi nadie dice que no. Dicen que están bastante liados ahora mismo, o que no miran mucho el móvil, o dicen que sí y te dan un número con una nota en la voz que decides no oír.

**La jugada:** trata el primer no como definitivo, y sé cálido al respecto.

Coge la lectura más suave disponible como un rechazo. Esto es exactamente lo contrario de cómo se siente: se siente como si la ambigüedad fuera una invitación a ser más claro, a explicar mejor el plan, a darles una segunda oportunidad de oírlo bien. No lo es. Un no suave es un no formulado con amabilidad por alguien que está intentando que esto te resulte fácil, y responderlo con una segunda petición convierte su amabilidad en un problema que ahora tienen que resolver con más esfuerzo.

Cómo se ve la calidez aquí es pequeño y concreto: acéptalo en una frase, no actúes estar bien, y quédate en la conversación un minuto más si hay uno en el que quedarse. *No pasa nada, ha sido un placer hablar contigo de todas formas* no te cuesta nada y deja la noche intacta para los dos.

Dos cosas que no se te exigen: una explicación, y una salida inmediata. Huir les dice que los cuarenta minutos anteriores fueron un medio para un fin, que es poco amable con algo que fue genuinamente agradable.

Y el reencuadre que merece la pena guardar. No has perdido nada que tuvieras. Has averiguado algo que no sabías, en unos cuatro segundos, al coste de un momento algo incómodo, que es un tipo de cambio genuinamente bueno, y es todo el motivo por el que preguntar pronto sale barato.$md$,
  $j$[
    {
      "situation": "«La verdad es que no miro mucho el móvil ahora mismo, sinceramente.»",
      "line": "No pasa nada. Ha sido un placer hablar contigo de todas formas.",
      "why": "Coge el no suave como un no, en una frase, sin actuar decepción ni exigir una explicación. La noche se queda intacta para los dos."
    },
    {
      "situation": "Estás a punto de explicar el plan otra vez, más claro.",
      "line": "(lo han oído)",
      "why": "La ambigüedad no es una invitación a ser más claro. Una segunda petición convierte su no formulado con amabilidad en un problema que ahora tienen que resolver más directamente."
    },
    {
      "situation": "Has aceptado el no y todavía hay una conversación pasando.",
      "line": "(quédate un minuto)",
      "why": "Irte al instante dice que los cuarenta minutos anteriores fueron un medio para un fin. Quedarte dice que no lo fueron, que es tanto más amable como verdad."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "«Estoy bastante liado ahora mismo.» ¿Qué es eso?",
      "options": [
        { "text": "Genuinamente sobre su agenda.", "correct": false, "note": "A veces literalmente cierto, y no cambia la jugada. «Liado» es el envoltorio más común que hay." },
        { "text": "Ambiguo: merece una aclaración.", "correct": false, "note": "La lectura que convierte un rechazo amable en unos minutos incómodos. La ambigüedad aquí es una cortesía, no una apertura." },
        { "text": "Un no, formulado con amabilidad.", "correct": true, "note": "Casi nadie dice la palabra. Coge la lectura más suave disponible como un rechazo y casi siempre tendrás razón, y serás cálido cuando no la tengas." },
        { "text": "Una prueba de cuánto lo quieres.", "correct": false, "note": "Una historia que justifica preguntar dos veces. La gente normalmente no te está poniendo a prueba; está intentando que esto sea fácil." }
      ],
      "explain": "Coge el primer no como definitivo. La suavidad es alguien siendo amable, no alguien siendo poco claro."
    },
    {
      "prompt": "Has aceptado el no con calidez. ¿Y ahora?",
      "options": [
        { "text": "Irte rápido para que no sea incómodo.", "correct": false, "note": "Dice que los últimos cuarenta minutos fueron un medio para un fin, que es poco amable con algo que fue genuinamente agradable." },
        { "text": "Explicar que no pasa nada, largo y tendido.", "correct": false, "note": "Actuar que estás bien les pide que gestionen tus sentimientos sobre su respuesta, que es justo lo que estaban intentando evitar." },
        { "text": "Preguntar cuál fue el motivo.", "correct": false, "note": "Les exige producir una justificación para una decisión que no necesitaba ninguna." },
        { "text": "Quedarte en la conversación otro minuto si hay uno.", "correct": true, "note": "No perdiste nada que tuvieras. Quedarte dice que la conversación merecía la pena por sí sola, y deja la noche intacta para los dos." }
      ],
      "explain": "Una frase, sin actuación, y quédate si hay algo para lo que quedarse."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "read_it", "label": "Leyó el no suave", "description": "Cogió un rechazo formulado con amabilidad como un rechazo." },
      { "key": "once", "label": "No preguntó dos veces", "description": "Se resistió a aclarar, replantear o explicar el plan otra vez." },
      { "key": "warm", "label": "Se mantuvo cálido", "description": "Lo aceptó en una frase sin actuar decepción." },
      { "key": "stayed", "label": "No huyó", "description": "Dejó la conversación intacta en vez de salir con la respuesta." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Fabien",
        "role": "alguien con quien has estado hablando entre actuaciones",
        "mood": "Disfrutando de la noche, sin interés en una cita.",
        "openness": 3,
        "personality": "Simpático y evita el conflicto. Declina con suavidad en vez de directamente, y se pone visiblemente incómodo si le preguntan una segunda vez. Encantado de seguir hablando si la persona lo deja estar."
      },
      "sex": "female",
      "name": "Faye",
      "role": "alguien con quien has estado hablando entre actuaciones",
      "mood": "Disfrutando de la noche, sin interés en una cita.",
      "openness": 3,
      "personality": "Simpática y evita el conflicto. Declina con suavidad en vez de directamente, y se pone visiblemente incómoda si le preguntan una segunda vez. Encantada de seguir hablando si la persona lo deja estar."
    },
    "setting": "La sala de un concierto entre actuaciones. Lleváis media hora hablando, acabas de preguntar, y la respuesta no fue un sí.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Nunca des el número, por muy que la persona reformule la petición.",
      "Ponte visiblemente incómoda si te preguntan otra vez o te explican el plan.",
      "Relájate y sigue hablando del concierto si la persona lo acepta con calidez."
    ],
    "opening_beat": "«Ay, qué amable. La verdad es que no miro mucho el móvil ahora mismo, sinceramente.»",
    "success_looks_like": "La persona coge el no suave como definitivo, con calidez, y no huye."
  }$j$::jsonb,
  'Hoy, coge un pequeño no al pie de la letra la primera vez, sin aclarar ni volver a intentarlo. Apunta qué se rechazó y qué hiciste después.',
  $j${
    "beats": [
      {
        "situation": "Has preguntado. «Ay, qué amable. La verdad es que no miro mucho el móvil ahora mismo, sinceramente.»",
        "prompt": "¿Cuál es tu lectura?",
        "options": [
          { "text": "Un no, formulado con amabilidad. Tómalo como definitivo.", "correct": true, "note": "Casi nadie dice la palabra. Leer la versión más suave disponible como un rechazo significa que sueles tener razón, y ser cálido las veces que no." },
          { "text": "Un problema real de agenda: ofrece otra semana.", "correct": false, "note": "Se toma el envoltorio al pie de la letra y repite la misma pregunta, lo que les hace declinar una segunda vez y más directamente." },
          { "text": "Ambiguo. Pregunta otra vez, con ligereza.", "correct": false, "note": "La lectura que convierte un rechazo amable en unos minutos incómodos. La ambigüedad aquí es una cortesía, no una apertura." },
          { "text": "Nervios. Tranquilízales y vuelve a preguntar.", "correct": false, "note": "Una historia que existe para justificar preguntar dos veces. Toma a la gente por el sentido de lo que dijo." }
        ]
      },
      {
        "situation": "Lo has aceptado en una frase. El concierto todavía no ha vuelto a empezar y seguís los dos ahí de pie.",
        "prompt": "¿Y ahora?",
        "options": [
          { "text": "Poner una excusa e irte, para que no sea incómodo.", "correct": false, "note": "Les dice que la última media hora fue un medio para un fin, que es poco amable con algo que fue genuinamente agradable." },
          { "text": "Decirles que no pasa nada, con detalle.", "correct": false, "note": "Actuar que estás bien les pide que gestionen tus sentimientos sobre su propia respuesta, justo lo que la formulación suave intentaba ahorraros a los dos." },
          { "text": "Seguir hablando del concierto.", "correct": true, "note": "No perdiste nada que tuvieras y averiguaste algo en cuatro segundos. Quedarte dice que la conversación merecía la pena por sí sola, que es verdad." },
          { "text": "Preguntar cuál fue el motivo, para aprender algo.", "correct": false, "note": "Les exige justificar una decisión que no necesitaba justificación, y de todas formas no vas a obtener una respuesta honesta." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('asking-for-the-number', 5,
  'El primer mensaje',
  $md$Tienes el número, y ahora llegan las reglas de espera: tres días, dos días, nunca escribas primero, espera lo mismo que esperaron ellos. Todo es folclore, y todo optimiza para parecer que no te importa, que es un objetivo raro dado que acabas de pedirle el número a alguien precisamente porque te importaba.

**La jugada:** escribe el mismo día, y haz referencia al plan que ya nombraste.

El mismo día es correcto por un motivo práctico más que entusiasta. Lo que estás intentando conservar es el ánimo de una conversación que empezó a enfriarse en el momento en que te fuiste. Esa noche o la mañana siguiente, sigues siendo una persona con la que estaban disfrutando hablar. Tres días después eres un nombre y un número, y todo lo que mandes tiene que volver a presentarte primero.

Haz referencia al plan. Ya hiciste el trabajo difícil en la lección dos: hay una cosa concreta, y salió de la conversación. Eso le da al primer mensaje algo sobre lo que ir que no sea *hola*, y significa que el mensaje continúa algo en vez de empezar desde nada.

**Di quién eres, nombra la cosa, haz una pregunta, para.** Cuatro partes cortas, un mensaje. No tres mensajes, no un párrafo, y no otra versión de la pregunta si tardan unas horas en responder. La gente tiene trabajo.

*Hola, soy Sam del bar. Busqué ese sitio con la cosa que no encontrabas. Abren los jueves. ¿Te va bien?* Esa es toda la forma, y funciona porque no hay nada dentro que descifrar.$md$,
  $j$[
    {
      "situation": "La noche terminó hace dos horas y tienes el número.",
      "line": "Hola, soy Sam del bar. Busqué ese sitio con la cosa que no encontrabas. Abren los jueves. ¿Te va bien?",
      "why": "Quién eres, el plan que ya nombraste, una pregunta, y luego para. No hay nada dentro que haya que descifrar."
    },
    {
      "situation": "Te preguntas si es demasiado pronto.",
      "line": "(el mismo día: estás conservando un ánimo, no demostrando algo)",
      "why": "Las reglas de espera optimizan para parecer que no te importa, que es un objetivo raro después de pedir el número de alguien. Tres días después eres un nombre que hay que volver a presentar."
    },
    {
      "situation": "Han pasado cuatro horas y ninguna respuesta.",
      "line": "(nada: la gente tiene trabajo)",
      "why": "Un segundo mensaje antes de que respondan el primero convierte un pequeño silencio en algo que ahora tienen que gestionar. Un mensaje, y espera."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué escribir el mismo día?",
      "options": [
        { "text": "Demuestra que tienes ganas.", "correct": false, "note": "Lo demuestra, y las ganas no son el argumento. El argumento va sobre lo que tiene que cargar el mensaje." },
        { "text": "Esperar te hace parecer estratégico en vez de interesado.", "correct": false, "note": "Cierto y un punto secundario. Cómo pareces no es lo que se está protegiendo." },
        { "text": "Puede que se olviden de ti.", "correct": false, "note": "Versión seca del motivo real. Se van a acordar; la pregunta es si todavía sienten algo al respecto." },
        { "text": "Estás conservando el ánimo de una conversación que ya se está enfriando.", "correct": true, "note": "Esa noche sigues siendo alguien con quien disfrutaban. Tres días después eres un nombre y un número, y el mensaje tiene que volver a presentarte antes de poder hacer nada más." }
      ],
      "explain": "El ánimo es el activo. Cada día que pasa, el primer mensaje tiene más trabajo que hacer."
    },
    {
      "prompt": "¿Qué forma debería tener el primer mensaje?",
      "options": [
        { "text": "Quién eres, el plan, una pregunta, para.", "correct": true, "note": "Cuatro partes cortas en un mensaje. No hay nada dentro que descifrar, que es lo que lo hace fácil de responder." },
        { "text": "Algo gracioso, para marcar el tono.", "correct": false, "note": "Puede ser cálido y sigue necesitando el plan dentro. Un chiste solo no les deja nada que responder." },
        { "text": "Solo «hola», para abrir el canal.", "correct": false, "note": "Les pide que hagan todo el trabajo de empezar, y descarta el plan concreto que ya habíais acordado." },
        { "text": "Lo que sea que retome donde paró la conversación.", "correct": false, "note": "Más cálido que «hola» y sigue sin dar en el clavo. El plan es lo que lo hace respondible." }
      ],
      "explain": "Nómbrate, nombra el plan, haz una pregunta, y para."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "same_day", "label": "Lo mandó el mismo día", "description": "No esperó al folclore." },
      { "key": "identified", "label": "Dijo quién era", "description": "Quitó la incertidumbre al principio." },
      { "key": "named_the_plan", "label": "Nombró el plan", "description": "Hizo referencia a la cosa concreta de la conversación." },
      { "key": "one_question", "label": "Una pregunta, y paró", "description": "Lo dejó en un solo mensaje respondible." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Nadim",
        "role": "la persona del bar de antes",
        "mood": "En casa, móvil en la mano.",
        "openness": 4,
        "personality": "Contento de saber de ti y rápido para responder a cualquier cosa concreta. Responde a un «hola» pelado con un «hola» pelado."
      },
      "sex": "female",
      "name": "Nadia",
      "role": "la persona del bar de antes",
      "mood": "En casa, móvil en la mano.",
      "openness": 4,
      "personality": "Contenta de saber de ti y rápida para responder a cualquier cosa concreta. Responde a un «hola» pelado con un «hola» pelado."
    },
    "setting": "Dos horas después del bar. Tienes el número y el plan que nombraste era un sitio que hace la comida que no encontraban en ningún lado.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde solo con mensajes de texto, cortos.",
      "Responde a cualquier cosa concreta con calidez y una respuesta real.",
      "Responde a un saludo pelado con uno igual de pelado."
    ],
    "opening_beat": "Tienes el móvil en la mano y la caja de mensaje está vacía.",
    "success_looks_like": "La persona manda un mensaje que se identifica, nombra el plan y hace una pregunta."
  }$j$::jsonb,
  'Hoy, manda un mensaje que se nombre a sí mismo, nombre la cosa, haga una pregunta y pare. Cualquier mensaje a cualquiera cuenta. Apunta qué mandaste.',
  $j${
    "says": "(dos horas después del bar: la caja de mensaje está vacía, y el plan que nombraste era un sitio que hace la comida que no encontraban en ningún lado)",
    "model": {
      "line": "Hola, soy yo del bar. Encontré ese sitio con la cosa que no conseguías en ningún lado. Abren los jueves. ¿Te va bien?",
      "why": "Dice quién es, nombra el plan que ya habíais acordado, hace una pregunta y para. No hay nada dentro que descifrar, que es exactamente lo que lo hace fácil de responder."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Pregunta una cosa" },
      { "kind": "max_questions", "n": 1, "requirement": "Una pregunta, no tres" },
      { "kind": "contains_any", "words": ["sitio", "jueves", "comida", "encontré", "abren", "vamos", "probar", "allí"], "requirement": "Haz referencia al plan que nombraste" },
      { "kind": "max_words", "n": 30, "requirement": "Menos de treinta palabras: un mensaje" }
    ]
  }$j$::jsonb
);
