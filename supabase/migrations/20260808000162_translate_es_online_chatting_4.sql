-- Spanish: Chatear online, track 4 — Chats de grupo.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Rob" throughout — carries no `sex` field; masculine agreement
-- used by default.

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

select pg_temp.es_lesson('group-chats', 1,
  'Publícalo tarde, sin disculparte',
  $md$Escribes algo. Llegan dos mensajes más mientras escribes. Ahora el tuyo es una respuesta a algo de tres mensajes atrás, así que lo editas, y para cuando está bien la conversación ha seguido adelante y lo borras.

Eso le pasa semanalmente a una cantidad enorme de gente, y el resultado acumulado es alguien que está en once chats de grupo y no aparece en ninguno.

**La jugada:** publícalo de todas formas, tarde, sin nada delante.

Un mensaje que llega tres respuestas después de su tema es completamente normal. Los chats de grupo no son conversaciones lineales — todo el que lee lo sabe, todo el mundo lo hace, y nadie está siguiendo la secuencia. Los hilos existen en la mayoría de las apps y normalmente son innecesarios; la gente sencillamente entiende a qué estás respondiendo.

Lo que sí llama la atención es la disculpa delante. *Perdona, voy un poco atrás* y *tarde a esto pero* anuncian las dos que está pasando algo irregular, y son lo único que lo hace irregular. Sin ellas, un mensaje tardío es solo un mensaje.

El hábito de borrar merece la pena mirarlo directamente, porque es el costoso. Algo escrito y borrado te ha costado el mismo esfuerzo que algo publicado, no ha producido nada, y ha reforzado un poco la creencia de que no tienes nada que aportar. Hacer eso semanalmente durante un año es cómo alguien se queda callado en una sala llena de gente que le cae bien.

El listón es mucho más bajo de lo que se siente. La mayoría de los mensajes en un chat de grupo no son memorables — una reacción, media opinión, algo que se le ocurrió a alguien. El tuyo no tiene que ser mejor que el último, y nadie está comparando.

Si te quedas con una cosa: publícalo tarde y no digas nada sobre llegar tarde. La disculpa es la única parte que alguien notaría.$md$,
  $j$[
    {
      "situation": "Llegaron tres mensajes mientras escribías.",
      "line": "(publícalo de todas formas)",
      "why": "Un mensaje que llega tres respuestas después de su tema es completamente normal. Nadie está siguiendo la secuencia."
    },
    {
      "situation": "Estás a punto de escribir perdona, voy un poco atrás.",
      "line": "(esa es la única parte irregular)",
      "why": "Anuncia que está pasando algo inusual. Sin ella, un mensaje tardío es solo un mensaje."
    },
    {
      "situation": "Has escrito y borrado tres veces esta semana.",
      "line": "(eso cuesta lo mismo que publicar y no produce nada)",
      "why": "También refuerza la creencia de que no tienes nada que aportar, que es cómo alguien se queda callado en una sala llena de gente que le cae bien."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué llama de verdad la atención sobre un mensaje tardío?",
      "options": [
        { "text": "La disculpa delante.", "correct": true, "note": "Perdona, voy un poco atrás anuncia que está pasando algo irregular — y es lo único que lo hace irregular." },
        { "text": "Estar fuera de secuencia.", "correct": false, "note": "Completamente normal. Los chats de grupo no son lineales y todo el que lee lo sabe." },
        { "text": "La duración.", "correct": false, "note": "Una consideración aparte, y los mensajes largos se leen tarde en vez de notarse como tardíos." },
        { "text": "Nada — nadie nota nada.", "correct": false, "note": "Algo demasiado fuerte. La disculpa sí se nota de verdad, que es el punto." }
      ],
      "explain": "Nadie audita un chat de grupo."
    },
    {
      "prompt": "¿Qué cuesta el hábito de borrar?",
      "options": [
        { "text": "Nada — nadie lo vio.", "correct": false, "note": "Tú sí. El coste está enteramente de tu lado y se acumula." },
        { "text": "Unos segundos.", "correct": false, "note": "El esfuerzo es el mismo que publicar. Lo que cambia es qué obtienes por él." },
        { "text": "El mismo esfuerzo que publicar, más la creencia de que no tienes nada que aportar.", "correct": true, "note": "Semanalmente durante un año, así es cómo alguien acaba callado en una sala llena de gente que le cae bien." },
        { "text": "El momento para ese punto en concreto.", "correct": false, "note": "Real y la parte más pequeña — ese punto rara vez era esencial." }
      ],
      "explain": "El listón es mucho más bajo de lo que se siente. La mayoría de los mensajes en un chat de grupo no son memorables."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "posted", "label": "Lo publicó", "description": "No lo borró." },
      { "key": "no_apology", "label": "Sin disculpa por llegar tarde", "description": "Nada delante." },
      { "key": "no_editing", "label": "No lo reescribió tres veces", "description": "Envió más o menos lo que había escrito." },
      { "key": "low_bar", "label": "Dejó que no fuera memorable", "description": "No le exigió ser mejor que el último mensaje." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rob",
      "role": "alguien en el chat de grupo",
      "mood": "Prestando media atención, móvil en mano.",
      "openness": 4,
      "personality": "Lee todo y reacciona a lo que llegue, en cualquier orden, sin notar nunca el momento."
    },
    "setting": "Un chat de seis personas. Escribiste una respuesta a algo hace dos minutos, llegaron cuatro mensajes más, y tu borrador sigue ahí.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Reacciona con normalidad a cualquier cosa publicada, sin importar a qué responda.",
      "Nunca comentes el momento o la secuencia.",
      "Continúa la conversación si no se publica nada."
    ],
    "opening_beat": "(cuatro mensajes nuevos, y tu borrador todavía sin enviar)",
    "success_looks_like": "La persona publica el borrador sin disculparse por el retraso."
  }$j$::jsonb,
  'Hoy, publica en un chat de grupo un mensaje que habrías borrado. Apunta cuál era.',
  $j${
    "says": "(tu borrador lleva ahí dos minutos y han llegado cuatro mensajes más desde entonces)",
    "model": {
      "line": "El sitio de la esquina es genuinamente bueno, por si sirve de algo.",
      "why": "Publicado tarde sin nada delante. Un mensaje que llega tres respuestas después de su tema es completamente normal — la disculpa es la única parte que alguien notaría."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["perdona", "voy un poco atrás", "tarde a esto", "algo atrasado", "volviendo a", "ignórame", "perdona por rebobinar", "ya que todos han seguido"], "requirement": "Sin disculpa por llegar tarde" },
      { "kind": "min_words", "n": 5, "requirement": "Publica algo de verdad" },
      { "kind": "max_words", "n": 35, "requirement": "Ordinario, no meditado" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('group-chats', 2,
  'El chiste que muere',
  $md$Publicas algo que creías que era gracioso. Nada. La conversación sigue a su alrededor como si no hubiera llegado.

**La jugada:** no hagas nada en absoluto, y sigue publicando.

Esto merece la pena entenderlo en vez de aguantarlo, porque la tasa de reacción en un chat de grupo es genuinamente baja y es baja para todo el mundo. La mayoría de los mensajes no consiguen nada. Desplázate hacia atrás en cualquier chat activo y cuenta cuántos tienen respuestas — va a ser una minoría, incluyendo los buenos, incluyendo los de la gente a la que consideras la graciosa.

Cuatro personas lo leyeron en trenes. Una sonrió. Nadie respondió. Eso no es rechazo; es cómo es un chat de grupo.

Lo que convierte un no-evento en algo visible es el seguimiento. *Jaja ignoradme.* *Perdón, mal chiste.* *Sonaba más gracioso en mi cabeza.* Antes de eso, no había pasado nada y nadie había pensado en ello. Después, hay una pequeña cosa incómoda en el chat a la que la gente ahora siente que debería responder — y la respuesta, sea la que sea, va a ser compasión, que es el resultado que intentabas evitar.

El otro hábito que merece la pena perder es borrarlo. En la mayoría de las apps eso deja un rastro visible, que es más ruidoso de lo que era el mensaje, y le dice a todo el mundo que pasó algo que importaba lo bastante como para eliminarlo.

El replanteamiento que hace esto soportable: en un chat de grupo no estás actuando, estás contribuyendo a un flujo. Los flujos tienen calidad variable por diseño, y nadie lleva un registro de tu tasa de acierto. La gente que parece que se le dan bien los chats de grupo sin esfuerzo publica más cosas que no consiguen nada, no menos.

Si te quedas con una cosa: ninguna reacción es el caso normal. Añadir una frase al respecto es la única forma en que se convierte en un momento.$md$,
  $j$[
    {
      "situation": "Publicaste algo gracioso y no conseguiste nada.",
      "line": "(no hagas nada)",
      "why": "Cuatro personas lo leyeron en trenes y una sonrió. Así es cómo es un chat de grupo, no un rechazo."
    },
    {
      "situation": "Estás a punto de escribir jaja ignoradme.",
      "line": "(eso crea la cosa incómoda)",
      "why": "Antes de eso, no había pasado nada. Después hay algo a lo que la gente siente que debería responder, y la respuesta va a ser compasión."
    },
    {
      "situation": "Quieres borrarlo.",
      "line": "(el rastro es más ruidoso que el mensaje)",
      "why": "Le dice a todo el mundo que pasó algo que importaba lo bastante como para eliminarlo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la tasa de reacción en un chat de grupo activo?",
      "options": [
        { "text": "Alta — eso es lo que los hace activos.", "correct": false, "note": "El volumen viene de que mucha gente publica, no de que la mayoría de los mensajes consigan respuestas." },
        { "text": "Baja, para todo el mundo, incluyendo los graciosos.", "correct": true, "note": "Desplázate hacia atrás y cuenta cuántos mensajes tienen respuestas. Es una minoría, y así es cómo es la sala, no un veredicto sobre el tuyo." },
        { "text": "Depende del mensaje.", "correct": false, "note": "Menos de lo que la gente cree. Muchos buenos no consiguen nada por el momento en que cayeron." },
        { "text": "Baja para los nuevos, más alta una vez que estás establecido.", "correct": false, "note": "No hay ningún nivel establecido. La gente que parece que lo hace sin esfuerzo publica más cosas que no consiguen nada." }
      ],
      "explain": "Cuatro personas lo leyeron en trenes. Una sonrió. Nadie respondió."
    },
    {
      "prompt": "¿Qué lo convierte en un momento?",
      "options": [
        { "text": "Decir algo al respecto.", "correct": true, "note": "Jaja ignoradme crea una pequeña cosa incómoda a la que la gente ahora siente que debería responder, y la respuesta va a ser compasión." },
        { "text": "Nada — sigue siendo un no-evento de cualquier forma.", "correct": false, "note": "Casi correcto, y hay una cosa que lo cambia de forma fiable." },
        { "text": "Borrarlo.", "correct": false, "note": "Sí deja un rastro visible en la mayoría de las apps, y es la segunda peor opción, no la primera." },
        { "text": "Publicar otra vez justo después.", "correct": false, "note": "Perfectamente bien, y lo correcto que hacer — sigue publicando." }
      ],
      "explain": "Estás contribuyendo a un flujo en vez de actuando. Nadie lleva un registro de tu tasa de acierto."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "nothing", "label": "No hizo nada", "description": "Ningún seguimiento al respecto." },
      { "key": "no_delete", "label": "No lo borró", "description": "Lo dejó ahí." },
      { "key": "kept_posting", "label": "Siguió publicando", "description": "No se quedó callado después." },
      { "key": "no_ledger", "label": "No llevó registro", "description": "No lo trató como evidencia." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rob",
      "role": "alguien en el chat de grupo",
      "mood": "Distraído.",
      "openness": 4,
      "personality": "Lo vio, sonrió a medias, y no respondió porque estaba haciendo otra cosa. Responde con compasión si alguien llama la atención sobre un mensaje muerto."
    },
    "setting": "Publicaste algo que creías que era gracioso hace cuatro minutos. El chat ha seguido a su alrededor y nadie ha respondido.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Continúa con el tema actual si no se dice nada sobre el mensaje muerto.",
      "Responde con compasión incómoda si la persona llama la atención sobre ello.",
      "Nunca reacciones al mensaje original de forma retroactiva."
    ],
    "opening_beat": "(el chat ha pasado a otra cosa)",
    "success_looks_like": "La persona no dice nada al respecto y continúa con normalidad."
  }$j$::jsonb,
  'Hoy, deja que un mensaje no consiga ninguna reacción y no añadas nada después. Apunta cuál era.',
  $j${
    "beats": [
      {
        "situation": "Publicaste algo que creías que era gracioso. Cuatro minutos, ninguna reacción, y el chat ha pasado a otra cosa.",
        "prompt": "¿Qué haces?",
        "options": [
          { "text": "Añade jaja ignoradme.", "correct": false, "note": "Antes de eso, no había pasado nada. Después hay una pequeña cosa incómoda a la que la gente siente que debería responder — y la respuesta va a ser compasión." },
          { "text": "Bórralo.", "correct": false, "note": "En la mayoría de las apps eso deja un rastro visible, que es más ruidoso que el mensaje y dice que algo importaba lo bastante como para eliminarlo." },
          { "text": "Nada, y publica otra vez más tarde.", "correct": true, "note": "La mayoría de los mensajes en un chat activo no consiguen nada, incluyendo los buenos. Cuatro personas lo leyeron en trenes y una sonrió." },
          { "text": "Explica el chiste.", "correct": false, "note": "Convierte un no-evento en un tema, y nadie ha disfrutado nunca la versión explicada." }
        ]
      },
      {
        "situation": "Te preguntas si tu tasa de acierto en este chat es inusualmente mala.",
        "prompt": "¿Cómo lo comprobarías?",
        "options": [
          { "text": "Cuenta cuántos de tus mensajes consiguieron respuestas.", "correct": false, "note": "Solo la mitad de los datos, y la mitad que produce la conclusión equivocada por sí sola." },
          { "text": "Desplázate hacia atrás y cuenta los de todos.", "correct": true, "note": "Va a ser una minoría para todos, incluyendo la gente a la que consideras la graciosa. La tasa es una propiedad de la sala." },
          { "text": "Pregúntale a alguien del chat.", "correct": false, "note": "Van a decir algo amable, que es infalsable y no lo resuelve." },
          { "text": "Publica más y mira si mejora.", "correct": false, "note": "Publicar más es el comportamiento correcto, y no es una medición." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('group-chats', 3,
  'Reacciona a otra gente',
  $md$Las reacciones son el acto social más barato disponible en cualquier sitio, y son la mayor parte de lo que de verdad está hecha la calidez de un chat de grupo.

**La jugada:** reacciona a los mensajes de otra gente, a menudo, sin necesitar nada que decir.

Esto le viene inusualmente bien a alguien a quien le cuesta mantener la palabra. Una reacción no requiere ingenio, ni sincronización, ni riesgo de un chiste muerto ni una frase que componer. Te hace estar presente en una sala sin nunca tomarla — que es precisamente la forma de participación que le viene bien a una persona callada y que nadie le sugiere nunca.

También hace más de lo que parece. Desde el otro lado, un mensaje con tres reacciones y un mensaje sin ninguna se sienten completamente distintos para la persona que lo envió, y la diferencia es todo el tejido social de un grupo. Alguien que reacciona es alguien a quien la sala registra como presente, sin ni una sola contribución original.

Lo mismo se aplica a las respuestas de dos palabras. *Eso es genial.* *Pobre de ti.* *Suerte mañana.* Ninguna de ellas es contenido, todas son presencia, y son de lo que consiste la mayor parte del volumen en un chat sano.

Hay una versión concreta que merece la pena hacer de forma deliberada: reacciona al mensaje que no consiguió nada. Todo el mundo sabe cómo se siente un mensaje sin respuesta, y ser la persona que lo recoge te cuesta un solo toque y se recuerda con calidez desproporcionadamente.

La única cosa que evitar es usar las reacciones como sustituto de una respuesta que alguien de verdad estaba esperando. Una pregunta directa con un pulgar arriba no está respondida, y ese es el único contexto en el que una reacción se lee como evasión en vez de como presencia.

Si te quedas con una cosa: reacciona a las cosas. Es participación sin ninguna de las partes que te resultan difíciles.$md$,
  $j$[
    {
      "situation": "No tienes nada que aportar pero lo has leído todo.",
      "line": "(reacciona a las cosas)",
      "why": "Sin ingenio, sin sincronización, sin chiste muerto, nada que componer. Presencia en una sala sin nunca tomarla."
    },
    {
      "situation": "El mensaje de alguien no consiguió ninguna respuesta.",
      "line": "(recoge ese)",
      "why": "Todo el mundo sabe cómo se siente eso, y ser la persona que lo hace cuesta un toque y se recuerda desproporcionadamente."
    },
    {
      "situation": "Alguien te ha hecho una pregunta directa.",
      "line": "(un pulgar arriba no es una respuesta)",
      "why": "El único contexto en el que una reacción se lee como evasión en vez de como presencia."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué le vienen bien las reacciones especialmente a una persona callada?",
      "options": [
        { "text": "Son rápidas.", "correct": false, "note": "La rapidez es un beneficio y no lo que las hace la forma correcta." },
        { "text": "Nadie nota quién reaccionó.", "correct": false, "note": "Sí lo notan, y eso es una ventaja, no un problema." },
        { "text": "Son participación sin ninguna de las partes difíciles.", "correct": true, "note": "Sin ingenio, sin sincronización, sin riesgo de chiste muerto, ninguna frase que componer — presencia en una sala sin nunca tenerla." },
        { "text": "No se pueden malinterpretar.", "correct": false, "note": "Mayormente cierto, y no es por lo que le vienen bien a alguien a quien le cuesta la palabra." }
      ],
      "explain": "Alguien que reacciona se registra como presente, sin ninguna contribución original en absoluto."
    },
    {
      "prompt": "¿Cuándo se lee mal una reacción?",
      "options": [
        { "text": "Cuando es lo único que haces nunca.", "correct": false, "note": "Esa es una forma perfectamente buena de estar en un chat de grupo, y mejor que estar ausente de él." },
        { "text": "Cuando alguien estaba esperando una respuesta.", "correct": true, "note": "Una pregunta directa con un pulgar arriba no está respondida, y ese es el único contexto en el que se lee como evasión." },
        { "text": "Cuando usas una poco habitual.", "correct": false, "note": "Las reacciones idiosincrásicas son parte de lo que la gente disfruta de ellas." },
        { "text": "Cuando llega tarde.", "correct": false, "note": "Nadie audita un chat de grupo, ni siquiera el momento de las reacciones." }
      ],
      "explain": "Las respuestas de dos palabras hacen el mismo trabajo. Eso es genial. Pobre de ti. Suerte mañana."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "reacted", "label": "Reaccionó a cosas", "description": "Usó el acto más barato disponible." },
      { "key": "picked_up", "label": "Recogió un mensaje ignorado", "description": "Reaccionó a algo que no había conseguido nada." },
      { "key": "two_words", "label": "Usó respuestas de dos palabras", "description": "Presencia en vez de contenido." },
      { "key": "answered_questions", "label": "Aun así respondió a preguntas directas", "description": "No reaccionó en vez de responder." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rob",
      "role": "alguien en el chat de grupo cuyo mensaje se quedó sin responder",
      "mood": "Bien, algo desinflado.",
      "openness": 4,
      "personality": "Se había dado cuenta de que nadie respondió y había decidido no darle importancia. Se cálida considerablemente ante cualquier reconocimiento, por pequeño que sea."
    },
    "setting": "El chat está activo. Alguien publicó algo sobre una cita en el hospital hace veinte minutos y nadie respondió, y la conversación ha seguido adelante.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con calidez y apertura a cualquier reconocimiento del mensaje de la cita.",
      "No digas nada más al respecto si se queda sin reconocer.",
      "Nunca lo saques tú de nuevo."
    ],
    "opening_beat": "(el chat está hablando de algo completamente distinto)",
    "success_looks_like": "La persona recoge el mensaje ignorado."
  }$j$::jsonb,
  'Hoy, reacciona a tres cosas en un chat de grupo, incluyendo una a la que nadie respondió. Apunta cuál recogiste.',
  $j${
    "beats": [
      {
        "situation": "El chat está activo. Alguien mencionó una cita en el hospital hace veinte minutos y no consiguió ninguna respuesta.",
        "prompt": "¿Cuál es la cosa útil más barata que puedes hacer?",
        "options": [
          { "text": "Nada — el momento ha pasado.", "correct": false, "note": "Nadie audita un chat de grupo, ni siquiera el momento. Veinte minutos después está bien." },
          { "text": "Escríbeles en privado al respecto.", "correct": false, "note": "Genuinamente bueno y un acto más grande de lo que pedía la pregunta — esta va sobre lo más barato disponible." },
          { "text": "Reacciona a ello.", "correct": true, "note": "Un toque, sin ingenio requerido, y todo el mundo sabe cómo se siente un mensaje sin respuesta." },
          { "text": "Cambia el tema de vuelta a ello y haz una pregunta.", "correct": false, "note": "Amable, y pone a alguien en un aprieto en público sobre una cita en el hospital." }
        ]
      },
      {
        "situation": "Alguien te ha hecho una pregunta directa en el chat y estás ocupado.",
        "prompt": "¿Es suficiente un pulgar arriba?",
        "options": [
          { "text": "Sí — lo reconoce.", "correct": false, "note": "Lo reconoce y no lo responde, y se hizo una pregunta." },
          { "text": "Sí, si respondes más tarde.", "correct": false, "note": "Entonces es una promesa, y este es el único contexto en el que la reacción se lee como evasión." },
          { "text": "No — ese es el único sitio donde una reacción se lee como evasión.", "correct": true, "note": "Las reacciones son presencia en todos los demás sitios. Una pregunta directa con un pulgar arriba no ha sido respondida." },
          { "text": "No, pero una reacción más un emoji sí lo sería.", "correct": false, "note": "Dos reacciones tampoco es una respuesta. Dos palabras sí lo serían." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('group-chats', 4,
  'Volver después de meses',
  $md$No has dicho nada en ese chat desde marzo. Todo el mundo más sí. Cuanto más dura, más se siente que el primer mensaje tiene que merecer el silencio.

**La jugada:** publica algo ordinario, sin ningún anuncio de reentrada.

*¿Ha ido alguien de verdad al sitio nuevo de la esquina?* Eso es un regreso completo. Nadie va a notar que has estado callado, porque nadie estaba llevando la cuenta — los chats de grupo no tienen registro de asistencia, y la sensación de que se ha notado tu ausencia se fabrica enteramente de tu lado.

El anuncio es lo que crea el problema que intentaba resolver. *Perdón, se me dan fatal los chats de grupo* y *hola, de vuelta de entre los muertos* le dicen las dos a todo el mundo que está pasando un regreso, que convierte un mensaje ordinario en un pequeño evento al que la gente ahora tiene que responder. Y las respuestas — *ja, pensábamos que nos habías dejado* — son exactamente lo que temías y no habrían existido de otra forma.

La presión de hacer que merezca la pena el silencio es la otra cosa que dejar caer. Produce un mensaje demasiado meditado para la sala, que se lee raro y es más difícil de responder que algo dicho al pasar. Lo mundano es mejor. Los chats funcionan a base de cosas mundanas.

Tampoco requiere leer el historial. No hace falta ponerse al día con cuatrocientos mensajes, y nadie lo espera — publica sobre ahora, no sobre lo que te perdiste.

Y si el chat de verdad se ha quedado en silencio para todos, un mensaje tuyo lo reinicia. Eso pasa constantemente, y la persona que rompe un silencio de tres semanas le está haciendo un favor a todo el mundo en vez de entrometerse en uno.

Si te quedas con una cosa: nada de anuncio. El silencio era invisible hasta que lo mencionaste.$md$,
  $j$[
    {
      "situation": "No has publicado desde marzo.",
      "line": "¿Ha ido alguien de verdad al sitio nuevo de la esquina?",
      "why": "Un regreso completo. Nadie estaba llevando la cuenta, y la sensación de que se notó tu ausencia se fabrica de tu lado."
    },
    {
      "situation": "Estás a punto de decir perdón, se me dan fatal los chats de grupo.",
      "line": "(eso crea el evento)",
      "why": "Convierte un mensaje ordinario en algo a lo que la gente tiene que responder, y las respuestas son exactamente lo que temías."
    },
    {
      "situation": "Sientes que el primer mensaje debería merecer el silencio.",
      "line": "(lo mundano es mejor)",
      "why": "Un mensaje demasiado meditado se lee raro y es más difícil de responder. Los chats funcionan a base de cosas mundanas."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué sale mal el anuncio?",
      "options": [
        { "text": "Suena insincero.", "correct": false, "note": "Es completamente sincero, que es por lo que persiste el hábito." },
        { "text": "A la gente le parece necesitado.", "correct": false, "note": "Nadie piensa eso, y plantearlo como un juicio sobre ti se pierde lo que de verdad pasa." },
        { "text": "Les recuerda que te fuiste.", "correct": false, "note": "Cerca, y el coste no es el recordatorio — es que ahora se requiere una respuesta." },
        { "text": "Crea el evento por el que se estaba disculpando.", "correct": true, "note": "Un mensaje ordinario se convierte en un regreso al que la gente ahora tiene que responder — y ja, pensábamos que nos habías dejado no habría existido de otra forma." }
      ],
      "explain": "El silencio era invisible hasta que lo mencionaste."
    },
    {
      "prompt": "¿Cómo debería ser el primer mensaje?",
      "options": [
        { "text": "Algo que merezca la espera.", "correct": false, "note": "Produce un mensaje demasiado meditado para la sala, que se lee raro y es más difícil de responder que algo dicho al pasar." },
        { "text": "Una respuesta a algo del historial.", "correct": false, "note": "No hace falta ponerse al día con cuatrocientos mensajes, y nadie lo espera." },
        { "text": "Algo mundano, sobre ahora.", "correct": true, "note": "Los chats funcionan a base de cosas mundanas, y un mensaje ordinario es la versión que la gente puede responder de verdad." },
        { "text": "Una pregunta, para que alguien tenga que responder.", "correct": false, "note": "Una pregunta es una forma buena y exigir una respuesta no es lo que hace que funcione el regreso." }
      ],
      "explain": "Y si el chat se ha quedado en silencio para todos, que tú lo reinicies es un favor."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "posted", "label": "Publicó", "description": "Rompió el silencio." },
      { "key": "no_announcement", "label": "Sin anuncio de reentrada", "description": "No mencionó haber estado ausente." },
      { "key": "mundane", "label": "Lo mantuvo ordinario", "description": "No lo hizo merecer el silencio." },
      { "key": "about_now", "label": "Sobre ahora", "description": "No intentó el historial." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rob",
      "role": "alguien en el chat",
      "mood": "Tarde normal.",
      "openness": 4,
      "personality": "No ha notado la ausencia en absoluto. Responde con normalidad a un mensaje ordinario, y hace una broma al respecto si se anuncia un regreso."
    },
    "setting": "Un chat con viejos amigos. No has publicado desde marzo. Hay cuatrocientos mensajes sin leer.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con normalidad a un mensaje ordinario, como si no hubiera pasado nada.",
      "Haz una broma cálida sobre su ausencia si se anuncia un regreso.",
      "Nunca menciones tú el hueco."
    ],
    "opening_beat": "(el chat está en mitad de una conversación sobre algo de la semana pasada)",
    "success_looks_like": "La persona publica algo ordinario sin ningún anuncio."
  }$j$::jsonb,
  'Hoy, publica en un chat en el que has estado callado, sin mencionar el silencio. Apunta qué dijiste.',
  $j${
    "says": "(un chat con viejos amigos. No has publicado desde marzo, y hay cuatrocientos mensajes sin leer.)",
    "model": {
      "line": "¿Ha ido alguien de verdad al sitio nuevo de la esquina?",
      "why": "Un regreso completo. Nadie estaba llevando la cuenta, no hace falta leer el historial, y un anuncio convertiría un mensaje ordinario en un evento al que la gente tiene que responder."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["perdón", "se me dan fatal los chats de grupo", "de vuelta de entre los muertos", "mucho tiempo", "he estado callado", "poniéndome al día con", "acabo de ver todos", "hola desconocidos", "siglos desde"], "requirement": "Sin anuncio de reentrada" },
      { "kind": "min_words", "n": 5, "requirement": "Publica algo ordinario" },
      { "kind": "max_words", "n": 30, "requirement": "Mundano, no que merezca el silencio" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('group-chats', 5,
  'Cuándo debería ser un mensaje privado',
  $md$No todo pertenece al grupo, y saber qué cosas no es la mayor parte de lo que hace que alguien sea bueno para tener en uno.

**La jugada:** si concierne a una persona, envíaselo a esa persona.

Cuatro casos en los que el grupo es la sala equivocada.

**Cualquier cosa sobre la situación de una persona.** Hacer seguimiento de la entrevista de trabajo de alguien delante de nueve personas le pide que dé una actualización a un público. Escríbele directamente; pregunta en el grupo solo si lo sacó ahí.

**Logística entre dos personas.** Cuarenta mensajes sobre si el martes os va bien a los dos, delante de todo el mundo, es la forma más común en que un chat se convierte en algo que la gente silencia.

**Cualquier cosa crítica.** Por leve que sea. Una corrección delante de un grupo es una corrección con testigos, y cae unas cuatro veces más fuerte que las mismas palabras en privado.

**Cualquier cosa que necesite una respuesta real.** Una pregunta con peso pone a alguien en un aprieto en público, y la respuesta que consigas va a ser la que es cómoda de dar delante de otros.

La otra dirección también importa: cosas que pertenecen al grupo y se envían en privado. Los arreglos que todo el mundo necesita, las decisiones que afectan a todos, la cosa graciosa. Dividir una conversación de grupo en hilos privados es cómo la mitad del chat acaba desactualizada, y es el motivo por el que alguien siempre dice *perdona, ¿eso se decidió en otro sitio?*

La prueba es sencilla: ¿quién necesita esto, y a quién le resultaría incómodo recibirlo en público? Si la primera lista es una persona, o la segunda lista contiene a alguien, es un mensaje privado.

Si te quedas con una cosa: una persona, un mensaje. El grupo es para las cosas que todo el mundo necesita.$md$,
  $j$[
    {
      "situation": "Quieres preguntar cómo fue la entrevista de alguien.",
      "line": "(escríbele directamente)",
      "why": "Preguntar delante de nueve personas le exige dar una actualización a un público. Pregunta en el grupo solo si lo sacó ahí."
    },
    {
      "situation": "Tú y otra persona estáis averiguando si el martes va bien.",
      "line": "(llévalo a un mensaje privado)",
      "why": "Cuarenta mensajes de logística entre dos personas delante de todo el mundo es la forma más común en que un chat se convierte en algo que la gente silencia."
    },
    {
      "situation": "Estás a punto de corregir a alguien, levemente.",
      "line": "(en privado — cae cuatro veces más fuerte en público)",
      "why": "Una corrección delante de un grupo es una corrección con testigos, sean cuales sean las palabras."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la prueba?",
      "options": [
        { "text": "Quién lo necesita, y a quién le resultaría incómodo en público.", "correct": true, "note": "Si la primera lista es una persona, o la segunda contiene a alguien, es un mensaje directo." },
        { "text": "Si le interesa a todo el mundo.", "correct": false, "note": "La mayor parte de lo que pertenece a un chat de grupo no le interesa a todo el mundo. El interés no es el criterio." },
        { "text": "Si es información privada.", "correct": false, "note": "Cubre un caso y se pierde la logística entre dos personas y las correcciones leves, que no son ni privadas ni asunto del grupo." },
        { "text": "Cuánta gente hay en el chat.", "correct": false, "note": "El tamaño cambia el volumen del problema, no qué pertenece dónde." }
      ],
      "explain": "Una persona, un mensaje. El grupo es para las cosas que todo el mundo necesita."
    },
    {
      "prompt": "¿Cuál es el fallo en la otra dirección?",
      "options": [
        { "text": "Publicar demasiado en el grupo.", "correct": false, "note": "El volumen rara vez es el problema, y un chat activo normalmente es uno sano." },
        { "text": "Decidir cosas en hilos privados.", "correct": true, "note": "Es cómo la mitad de un chat acaba desactualizada, y es por lo que alguien siempre pregunta si eso se decidió en otro sitio." },
        { "text": "Escribirle a la gente individualmente demasiado a menudo.", "correct": false, "note": "Los mensajes individuales casi siempre son bienvenidos. La frecuencia no es el problema." },
        { "text": "Repetir cosas que la gente ya ha visto.", "correct": false, "note": "Levemente molesto y mucho más barato que la alternativa." }
      ],
      "explain": "Los arreglos que todo el mundo necesita, las decisiones que afectan a todos, y la cosa graciosa pertenecen todos al grupo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "dm", "label": "Usó un mensaje privado donde pertenecía", "description": "Una persona, un mensaje." },
      { "key": "no_public_correction", "label": "Corrigió en privado", "description": "No lo hizo delante del grupo." },
      { "key": "logistics_out", "label": "Sacó la logística entre dos", "description": "No la pasó por el grupo." },
      { "key": "decisions_in", "label": "Mantuvo las decisiones en el grupo", "description": "No dividió lo que todos necesitaban." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rob",
      "role": "alguien en el chat que acaba de publicar la fecha equivocada",
      "mood": "Alegre, algo agobiado.",
      "openness": 4,
      "personality": "Acepta una corrección privada con agradecimiento y se pone nervioso con una pública. Habla abiertamente de la entrevista uno a uno."
    },
    "setting": "En el chat de grupo, alguien acaba de publicar un plan con una fecha equivocada. También quieres saber cómo fue su entrevista, y tú y otra persona necesitáis organizar que os lleven en coche.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Acepta una corrección privada con agradecimiento y arréglalo tú mismo en el grupo.",
      "Ponte nervioso y discúlpate en exceso si te corrigen delante de todos.",
      "Habla abiertamente de la entrevista solo en un mensaje directo."
    ],
    "opening_beat": "«Vale — ¿todos bien para el 14 entonces?» (Es el 15.)",
    "success_looks_like": "La persona gestiona la corrección, la entrevista y el coche en los sitios correctos."
  }$j$::jsonb,
  'Hoy, saca algo de un chat de grupo a un mensaje directo. Apunta qué era.',
  $j${
    "beats": [
      {
        "situation": "Alguien acaba de publicar «¿todos bien para el 14 entonces?» en el grupo. Es el 15, y también ha mencionado una entrevista de trabajo antes en la semana.",
        "prompt": "¿Adónde va la corrección?",
        "options": [
          { "text": "En el grupo — todos necesitan la fecha correcta.", "correct": false, "note": "Todos necesitan la fecha y no necesitan la corrección. Una corrección delante de un grupo cae unas cuatro veces más fuerte que las mismas palabras en privado." },
          { "text": "En privado, y deja que lo arreglen ellos en el grupo.", "correct": true, "note": "La información llega a todos y nadie es corregido en público. Mismo resultado, ninguno del coste." },
          { "text": "En ningún sitio — se darán cuenta.", "correct": false, "note": "No se van a dar cuenta, y ahora seis personas van a llegar el día equivocado." },
          { "text": "En el grupo, formulado con suavidad.", "correct": false, "note": "La formulación no cambia a los testigos, que es lo que hace que caiga fuerte." }
        ]
      },
      {
        "situation": "Quieres preguntar cómo fue su entrevista, y tú y otra persona necesitáis organizar que os lleven en coche.",
        "prompt": "¿Adónde van esas cosas?",
        "options": [
          { "text": "Las dos en el grupo — todo es bastante ordinario.", "correct": false, "note": "La entrevista le pide a alguien que dé una actualización a un público, y la logística entre dos personas es la forma más común en que se silencia un chat." },
          { "text": "Entrevista en el grupo, coche en privado.", "correct": false, "note": "Al revés. El coche es logística y la entrevista es la situación de alguien." },
          { "text": "Las dos en privado.", "correct": true, "note": "Una concierne a la situación de una persona, la otra concierne a dos personas. Ninguna es algo que todos necesiten." },
          { "text": "Entrevista en privado, coche en el grupo para que la gente se pueda apuntar.", "correct": false, "note": "Un pensamiento razonable, y cuarenta mensajes de organización es exactamente lo que hace insoportable un chat." }
        ]
      }
    ]
  }$j$::jsonb
);
