-- Spanish: Conversaciones difíciles, track 2 — Abrirla.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Jo" (tracks 1-4) and "Sam" (track 5) carry no `sex` field;
-- masculine agreement used by default, as established throughout this app.

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

select pg_temp.es_lesson('opening-it', 1,
  'Nombra el tema cuando pidas la hora',
  $md$*¿Podemos hablar luego?* es una frase que suena amable y que le entrega a alguien cuatro horas de pavor, y es una de las dos formas habituales en que una conversación difícil se arruina antes de empezar.

Lo que pasa en esas cuatro horas no es neutro. Alguien con una conversación seria sin especificar por delante se va a inventar una, y lo que se inventa es de forma fiable peor que lo que tú tienes — el final de una relación, perder el trabajo, una enfermedad. Para cuando hables, esa persona está preparada para una catástrofe, y cualquier cosa menor sigue sentando mal, porque la adrenalina no sabe que era una falsa alarma.

**La jugada:** pide la hora y nombra el tema en la misma frase.

*¿Podemos hablar esta tarde? Es sobre el tema del dinero.* Dos datos, y necesita los dos: que hay una conversación, y más o menos de qué trata. El asunto no tiene que contener el contenido — no lo estás entregando por adelantado, estás eliminando las conjeturas.

Calibra la tranquilidad con honestidad. Si de verdad es algo pequeño, dilo, porque *no es un dramón* es cierto y útil. Si de verdad no lo es, no lo digas — la falsa tranquilidad te compra una hora más calmada y te cuesta su confianza en el momento en que empieza la conversación, y va a recordar que lo hiciste.

Da el aviso suficiente para ser humano y no tanto como para ser cruel. Más tarde hoy o mañana está más o menos bien. Nombrar algo serio con una semana de antelación significa siete días de alguien cargando con ello, que es su propia versión del mismo error.

Y pregunta en vez de anunciar. *¿Podemos* le deja voz sobre el cuándo, y alguien que eligió la hora llega más capaz de tener la conversación que alguien al que se ha convocado a ella.

Si te quedas con una cosa: el tema va en la misma frase que la petición. No te cuesta nada y es la diferencia entre cuatro horas de pavor y ninguna.$md$,
  $j$[
    {
      "situation": "Necesitas sacar algo serio esta tarde.",
      "line": "¿Podemos hablar esta noche? Es sobre el tema del dinero — no es una crisis, pero quiero solucionarlo.",
      "why": "Una petición, un tema, y una calibración honesta. Elimina las cuatro horas de inventarse algo peor."
    },
    {
      "situation": "Estás a punto de mandar ¿podemos hablar luego?",
      "line": "(eso son cuatro horas de pavor)",
      "why": "Lo que alguien se inventa en ese hueco es de forma fiable peor que lo que tú tienes, y llega preparado para una catástrofe."
    },
    {
      "situation": "Es serio y quieres suavizar la espera.",
      "line": "(no digas que no es nada)",
      "why": "La falsa tranquilidad compra una hora más calmada y cuesta su confianza en el momento en que empieza la conversación. Va a recordar que lo hiciste."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué tiene de malo podemos hablar luego?",
      "options": [
        { "text": "Suena siniestro.", "correct": false, "note": "Suena así, y el tono no es el mecanismo. El daño pasa en las horas siguientes." },
        { "text": "Se va a inventar algo peor que lo que tú tienes.", "correct": true, "note": "El final de una relación, perder el trabajo, una enfermedad. Para cuando hables, está preparado para una catástrofe, y la adrenalina no sabe que era una falsa alarma." },
        { "text": "Le da tiempo para preparar una defensa.", "correct": false, "note": "Que se prepare por su lado está bien y a menudo ayuda. El pavor es el coste, no estar preparado." },
        { "text": "Es pasivo-agresivo.", "correct": false, "note": "Casi siempre se dice con buena intención, que es exactamente por lo que la costumbre sobrevive." }
      ],
      "explain": "El tema va en la misma frase que la petición. No cuesta nada."
    },
    {
      "prompt": "¿Cuánto aviso?",
      "options": [
        { "text": "Todo el que se pueda, para que se prepare.", "correct": false, "note": "Con una semana de antelación son siete días de alguien cargando con ello, que es el mismo error estirado." },
        { "text": "Ninguno — sácalo ahí mismo.", "correct": false, "note": "Eso es la emboscada, y es la otra forma habitual en que esto se estropea." },
        { "text": "Más tarde hoy o mañana.", "correct": true, "note": "Suficiente para ser humano, poco para ser cruel. Suficiente para organizar un sitio y poco para inventarse una catástrofe." },
        { "text": "Cuando te venga bien a ti.", "correct": false, "note": "Su estado al llegar es la mayor parte de lo que estás gestionando aquí, así que no va solo de tu conveniencia." }
      ],
      "explain": "Y pregunta en vez de anunciar — alguien que eligió la hora llega más capaz de tenerla."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named_subject", "label": "Nombró el tema", "description": "Dijo más o menos de qué trataba." },
      { "key": "asked", "label": "Preguntó en vez de convocar", "description": "Le dejó voz sobre el cuándo." },
      { "key": "honest", "label": "Calibró con honestidad", "description": "No dio una falsa tranquilidad." },
      { "key": "short_notice", "label": "Dio un aviso humano", "description": "Hoy o mañana en vez de la semana que viene." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Jo",
      "role": "tu compañero de piso",
      "mood": "Tarde normal.",
      "openness": 4,
      "personality": "Ansioso por defecto. Se espirala visiblemente ante una petición de hablar sin especificar, y se relaja por completo cuando se le dice el tema."
    },
    "setting": "Has decidido sacar el tema del dinero con tu compañero de piso esta tarde. Estás a punto de escribirle.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con ansiedad visible y una conjetura sobre algo peor si no se nombra el tema.",
      "Responde con calma y accede fácilmente cuando se le diga de qué se trata.",
      "Nunca preguntes de qué se trata — eso es lo que se está poniendo a prueba."
    ],
    "opening_beat": "La ventana de mensajes está abierta.",
    "success_looks_like": "La persona pide la hora y nombra el tema en el mismo mensaje."
  }$j$::jsonb,
  'Hoy, pide una conversación y nombra el tema en la misma frase. Apunta lo que enviaste.',
  $j${
    "says": "(la ventana de mensajes está abierta — has decidido sacar el tema del dinero con tu compañero de piso esta tarde)",
    "model": {
      "line": "¿Podemos hablar esta tarde? Es sobre el tema del dinero — no es una crisis, solo quiero solucionarlo.",
      "why": "Una petición en vez de una convocatoria, el tema nombrado, y una calibración honesta. Elimina las cuatro horas en las que alguien se inventa algo mucho peor."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Pregunta, no convoques" },
      { "kind": "contains_any", "words": ["dinero", "alquiler", "facturas", "sobre el", "respecto a"], "requirement": "Nombra de qué se trata" },
      { "kind": "forbids_any", "words": ["tenemos que hablar", "podemos hablar luego", "necesito hablar contigo", "algo que tengo que decirte", "cuando llegues"], "requirement": "Nada de pavor sin especificar" },
      { "kind": "max_words", "n": 35, "requirement": "Dos líneas" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('opening-it', 2,
  'No de pasada',
  $md$El otro fallo habitual es la emboscada, y como la convocatoria-pavor, normalmente la comete alguien que intenta hacerlo más fácil — para sí mismo, que es la parte difícil de ver en el momento.

Sacar algo serio en la puerta, en los últimos dos minutos de una llamada, en un pasillo, o en el coche de camino a algún sitio es tremendamente tentador, porque se acaba antes de que el miedo tenga ocasión de crecer. Lo que produce es una reacción a la emboscada en vez de al contenido. Alguien sin aviso, sin espacio y sin salida se va a defender, y la conversación que consigues es sobre el hecho de que lo hicieras así.

**La jugada:** elige un sitio con tiempo y privacidad, y no lo saques en ningún otro lugar.

Lo que hace que un sitio funcione es poco glamuroso. Tiempo suficiente para que ninguno de los dos esté pendiente del reloj. Privacidad, o al menos que nadie que os conozca esté al alcance del oído. Y que no esté pasando una tercera cosa — no mientras se cocina, no mientras se conduce, no cinco minutos antes de que llegue la madre de alguien.

Lado a lado gana a cara a cara para las difíciles, y merece la pena saberlo. Un paseo, un trayecto en coche, fregar los platos juntos: menos contacto visual, un ritmo natural, y algo que mirar aparte del otro. Le quita una cantidad sorprendente de presión y es mucho más fácil para alguien a quien le cuesta la franqueza.

Dos sitios que descartar específicamente. No a última hora de la noche, cuando todo el mundo está peor para esto y nadie duerme después. Y nunca delante de nadie más — algo difícil dicho con público es un acto público, y la otra persona va a estar gestionando cómo queda mientras intenta escucharte.

Y no lo saques borracho, ni al final de una noche que iba bien. Los dos son el mismo error: alcanzar un momento en el que se siente brevemente fácil de decir, a costa de todas las condiciones que hacen que cale.

Si te quedas con una cosa: tiempo, privacidad, y nada de una tercera cosa. El sitio hace más trabajo que las palabras.$md$,
  $j$[
    {
      "situation": "Estás en la puerta, con el abrigo puesto, y sería fácil decirlo ahora.",
      "line": "(eso se acaba antes de que el miedo crezca, y es una emboscada)",
      "why": "Sin aviso, sin espacio y sin salida produce una reacción a cómo lo hiciste en vez de a lo que dijiste."
    },
    {
      "situation": "Te resulta difícil sentarte enfrente de alguien.",
      "line": "(un paseo, o fregar los platos)",
      "why": "Menos contacto visual, un ritmo natural, algo que mirar. Le quita presión de verdad y es mucho más fácil para cualquiera a quien le cueste la franqueza."
    },
    {
      "situation": "La noche ha ido bien y los dos estáis algo bebidos.",
      "line": "(las dos mal, por el mismo motivo)",
      "why": "Alcanzar un momento en el que se siente brevemente fácil de decir, a costa de todas las condiciones que hacen que cale."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué es tan tentadora la emboscada?",
      "options": [
        { "text": "Se acaba antes de que el miedo tenga tiempo de crecer.", "correct": true, "note": "Resuelve tu problema — la anticipación — eliminando todas las condiciones que hacen que la conversación funcione para ellos." },
        { "text": "Parece menos confrontacional.", "correct": false, "note": "Es más confrontacional en la práctica, porque la otra persona no tiene espacio en el que responder." },
        { "text": "Total, nunca hay un buen momento.", "correct": false, "note": "La creencia que la produce, y claramente hay momentos mejores y peores." },
        { "text": "Lo mantiene pequeño.", "correct": false, "note": "Lo hace más grande. Algo serio sacado en una puerta pasa a ser sobre la puerta en treinta segundos." }
      ],
      "explain": "Tiempo, privacidad, y que no pase una tercera cosa."
    },
    {
      "prompt": "¿Por qué ayuda lado a lado?",
      "options": [
        { "text": "Se siente más como un equipo.", "correct": false, "note": "Un buen enfoque y no lo que hace el trabajo." },
        { "text": "Es más difícil irse.", "correct": false, "note": "Más fácil, si acaso, y hacer que sea difícil irse no es el objetivo." },
        { "text": "Menos contacto visual y algo más que mirar.", "correct": true, "note": "Le quita una cantidad sorprendente de presión, y es considerablemente más fácil para cualquiera a quien le cueste la franqueza." },
        { "text": "Puedes controlar mejor el ritmo.", "correct": false, "note": "Los dos controláis el ritmo. El beneficio va sobre dónde van los ojos." }
      ],
      "explain": "Un paseo, un trayecto, fregar los platos. El sitio hace más trabajo que las palabras."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "time", "label": "Dejó tiempo suficiente", "description": "Ninguno de los dos pendiente del reloj." },
      { "key": "private", "label": "Lo mantuvo privado", "description": "Sin público, y nadie al alcance del oído." },
      { "key": "no_third_thing", "label": "Nada de una tercera cosa", "description": "No mientras se conduce, se cocina, o cinco minutos antes de que llegue alguien." },
      { "key": "not_at_the_door", "label": "No emboscó", "description": "Resistió el momento fácil de pasada." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Jo",
      "role": "tu compañero de piso",
      "mood": "Alegre, con un ojo en el reloj.",
      "openness": 4,
      "personality": "Reacciona al momento en vez de al contenido cuando algo serio llega sin espacio. Se implica de verdad cuando se le da un sitio real."
    },
    "setting": "Estáis los dos en la cocina. Su amigo llega en diez minutos y llevas quince días queriendo sacar un tema.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a cualquier cosa seria que se saque ahora con estrés visible por el tiempo y una respuesta defensiva.",
      "Accede con facilidad y calidez a una conversación como es debido más tarde.",
      "Nunca invites a la persona a sacar algo ahora."
    ],
    "opening_beat": "«Vale, va a llegar en diez minutos. ¿Quieres algo de la tienda?»",
    "success_looks_like": "La persona espera y organiza un momento como es debido en vez de sacarlo ahora."
  }$j$::jsonb,
  'Hoy, fíjate en un momento en el que podrías sacar algo de pasada, y no lo hagas. Organiza un momento real en su lugar. Apunta las dos cosas.',
  $j${
    "beats": [
      {
        "situation": "Estáis los dos en la cocina. Su amigo llega en diez minutos, y llevas quince días queriendo sacar un tema.",
        "prompt": "¿Ahora?",
        "options": [
          { "text": "Sí — es una buena ocasión y se acabará rápido.", "correct": false, "note": "Acabar rápido es lo que hace por ti. Para ellos es sin aviso, sin espacio y sin salida, y la respuesta que consigues es a la emboscada." },
          { "text": "Sí, pero mantenlo ligero para que no descarrile la tarde.", "correct": false, "note": "Algo serio sacado con ligereza con diez minutos en el reloj consigue lo peor de las dos cosas — se oye, y no se puede responder." },
          { "text": "No. Pide un momento como es debido más tarde.", "correct": true, "note": "Tiempo, privacidad y nada de una tercera cosa. El sitio hace más trabajo que las palabras." },
          { "text": "No — y déjalo, ya que el momento ha pasado.", "correct": false, "note": "El momento nunca estuvo. No sacarlo ahora no es lo mismo que no sacarlo." }
        ]
      },
      {
        "situation": "Estás organizando un momento real, y te resulta difícil sentarte enfrente de la gente.",
        "prompt": "¿Qué sitio?",
        "options": [
          { "text": "Sentaros bien, cara a cara, para que se tome en serio.", "correct": false, "note": "La seriedad no la produce cómo os sentéis, y cara a cara es la configuración más difícil para cualquiera a quien le cueste la franqueza." },
          { "text": "Un paseo, o algo lado a lado.", "correct": true, "note": "Menos contacto visual, un ritmo natural, y algo más que mirar. Le quita presión de verdad a la conversación." },
          { "text": "Un café, para que ninguno de los dos monte una escena.", "correct": false, "note": "Que haya público significa que van a estar gestionando cómo quedan mientras intentan escucharte." },
          { "text": "A última hora de la noche, cuando no hay prisa.", "correct": false, "note": "Todo el mundo está peor para esto entonces, y nadie duerme después." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('opening-it', 3,
  'Dilo en los primeros treinta segundos',
  $md$Estás en la sala, tienes el tiempo, y has decidido calentar un poco primero. Este es el último sitio donde la conversación se arruina antes de empezar.

Diez minutos de cháchara amable delante de un tema difícil se siente más suave y es una trampilla. Todo el mundo ha estado en el lado receptor de una conversación que empezó bien y giró, y todo el mundo recuerda el momento en que se dio cuenta de para qué habían sido los primeros diez minutos. Convierte retroactivamente la calidez en técnica, que es peor que no haber tenido ninguna calidez.

**La jugada:** dilo en los primeros treinta segundos, y luego deja que dure lo que necesite.

*Gracias por sacar tiempo. Lo que quería hablar es el tema de las cancelaciones.* Eso es una apertura completa, y todo lo que viene después es la conversación en vez de una pista de despegue hacia ella.

Merece la pena tener claro para quién es el calentamiento. No se lo está poniendo más fácil a ellos — saben que viene algo, porque pediste la hora y nombraste el tema. Eres tú, aplazando el momento, y el coste de ese aplazamiento cae entero sobre ellos: diez minutos esperando el giro es peor que treinta segundos llegando ahí.

Un segundo fallo vive en el mismo sitio: enterrarlo. Empezar por algo adyacente y esperar llegar al tema real de refilón produce una conversación en la que responden a lo adyacente, tú te sientes no escuchado, y os vais habiendo hablado de un problema distinto. Si el tema son las cancelaciones, la primera frase contiene la palabra cancelaciones.

En la práctica, la apertura tiene tres partes y tarda unos quince segundos. Dales las gracias por el tiempo. Nombra la cosa. Di qué quieres de la conversación — *quiero solucionarlo, no discutir* no es un tópico, le dice a alguien cómo escuchar los próximos veinte minutos.

Si te quedas con una cosa: nada de pista de despegue. Dilo pronto, y luego tómate el tiempo que quieras.$md$,
  $j$[
    {
      "situation": "Os habéis sentado y estás a punto de preguntar por su semana.",
      "line": "(eso es una pista de despegue, y saben que viene algo)",
      "why": "Diez minutos esperando el giro es peor para ellos que treinta segundos llegando ahí, y después convierte la calidez en técnica."
    },
    {
      "situation": "Quieres abordar el tema de refilón.",
      "line": "(van a responder a lo de refilón)",
      "why": "Os vais habiendo hablado de un problema distinto y sintiéndote no escuchado. Si el tema son las cancelaciones, la primera frase contiene la palabra cancelaciones."
    },
    {
      "situation": "Lo has nombrado y quieres que sepan qué es esto.",
      "line": "Quiero solucionarlo, no discutir.",
      "why": "No es un tópico. Le dice a alguien cómo escuchar los próximos veinte minutos, que cambia cómo los escucha."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Para quién es de verdad el calentamiento?",
      "options": [
        { "text": "Para ellos — suaviza el golpe.", "correct": false, "note": "Saben que viene algo; pediste tiempo y nombraste el tema. No se está suavizando nada." },
        { "text": "Para los dos, un poco.", "correct": false, "note": "La respuesta cómoda, y es por lo que la costumbre sobrevive siendo obviamente contraproducente." },
        { "text": "Para la relación — os recuerda que os caéis bien.", "correct": false, "note": "Algo real, y pertenece a después, no a antes. Dicho antes, se relee retroactivamente." },
        { "text": "Para ti, y el aplazamiento les cuesta a ellos.", "correct": true, "note": "Diez minutos esperando el giro es peor que treinta segundos llegando ahí, y después hace que la calidez parezca técnica." }
      ],
      "explain": "Nada de pista de despegue. Treinta segundos, y luego tómate el tiempo que quieras."
    },
    {
      "prompt": "¿Qué produce enterrarlo?",
      "options": [
        { "text": "Una versión más suave de la misma conversación.", "correct": false, "note": "Una conversación distinta, que es el problema en vez de una forma más suave de la correcta." },
        { "text": "Responden a lo adyacente y te vas sin sentirte escuchado.", "correct": true, "note": "Habéis hablado de un problema distinto, y el real sigue ahí — normalmente con el sentimiento añadido de que lo intentaste y no funcionó." },
        { "text": "Nada en especial — llegas al final.", "correct": false, "note": "A veces, y para entonces el tono ya lo ha marcado lo que fuera el tema adyacente." },
        { "text": "Averiguan qué quieres decir.", "correct": false, "note": "De vez en cuando, y que te hagan adivinar una acusación es de por sí una experiencia desagradable." }
      ],
      "explain": "Si el tema son las cancelaciones, la primera frase contiene la palabra cancelaciones."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "early", "label": "Lo dijo en los primeros treinta segundos", "description": "Nada de pista de despegue de cháchara amable." },
      { "key": "named", "label": "Nombró el tema real", "description": "No lo abordó de refilón." },
      { "key": "purpose", "label": "Dijo qué quería de ello", "description": "Le dijo cómo escuchar los próximos veinte minutos." },
      { "key": "then_slow", "label": "Luego se tomó su tiempo", "description": "Fue rápido al grano y sin prisa después." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Jo",
      "role": "alguien a quien le has pedido una conversación",
      "mood": "Preparado, dispuesto.",
      "openness": 4,
      "personality": "Se pone notablemente más tenso cuanto más dura la cháchara, y se relaja en la conversación en cuanto se nombra el tema de verdad."
    },
    "setting": "Os habéis sentado los dos. Han sacado tiempo, saben que es sobre las cancelaciones, y están esperando.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Ponte visiblemente más tenso y da respuestas más cortas cuanto más dure la cháchara.",
      "Implícate de verdad y con apertura en cuanto se nombre el tema con claridad.",
      "Nunca saques tú el tema más allá de la línea de apertura."
    ],
    "opening_beat": "«Bueno. Dijiste que era sobre el tema de los planes.»",
    "success_looks_like": "La persona nombra el tema de inmediato en vez de calentar."
  }$j$::jsonb,
  'Hoy, abre algo difícil en los primeros treinta segundos. Sin calentamiento. Apunta tu frase de apertura.',
  $j${
    "says": "Bueno. Dijiste que era sobre el tema de los planes.",
    "model": {
      "line": "Sí — gracias por sacar el tiempo. Es sobre las cancelaciones, y quiero solucionarlo en vez de discutir por ello.",
      "why": "El tema en la primera frase y el propósito en la segunda. Nada de pista de despegue, y nada que tengan que adivinar."
    },
    "checks": [
      { "kind": "contains_any", "words": ["cancela", "cancelaciones", "canceló", "planes", "el tema de"], "requirement": "Nombra el tema de inmediato" },
      { "kind": "forbids_any", "words": ["qué tal tu", "cómo has estado", "antes de entrar en", "bueno", "no sé cómo decir", "esto es difícil", "ten paciencia conmigo"], "requirement": "Nada de pista de despegue ni de rodeos" },
      { "kind": "max_words", "n": 45, "requirement": "Treinta segundos, no tres minutos" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('opening-it', 4,
  'Di qué quieres de ella',
  $md$Una frase al principio cambia más cómo va una conversación difícil que cualquier cantidad de redacción cuidada después, y casi nadie la incluye.

**La jugada:** di qué quieres que produzca la conversación.

*Quiero solucionar esto, no discutir.* *No busco una disculpa, quiero que lo hagamos de otra forma.* *Sobre todo quiero que lo sepas, y luego estoy contento de dejarlo estar.* Cada una de esas es corta, honesta, y hace algo estructural: le dice a la otra persona en qué papel está.

Sin eso, tienen que adivinar, y la conjetura es casi siempre defensiva — porque la suposición más segura cuando alguien te sienta a hablar es que te van a culpar de algo. Una persona que cree que la están procesando se comporta como un acusado, y te vas a pasar la conversación discutiendo con una defensa en vez de hablando con una persona.

También les dice qué contaría como que esto vaya bien, que es información genuinamente útil que no tienen de otra forma. Muchas conversaciones difíciles fracasan porque una persona quería que la escucharan y la otra se pasó cuarenta minutos proponiendo soluciones, o porque una quería un plan y la otra seguía disculpándose.

Sé honesto al respecto en vez de diplomático. Si de verdad quieres una disculpa, decirlo es mucho mejor que fingir lo contrario y luego sentirte estafado por una solución. Si quieres que cambie el comportamiento y no te interesa mucho por qué pasó, también merece la pena decirlo, con amabilidad.

Y mantenlo en una frase. Esto es un marco en vez de un argumento, y un preámbulo largo sobre tus intenciones empieza a sonar como un caso que se está construyendo — que produce la actitud defensiva que intentabas evitar.

Si te quedas con una cosa: dile qué quieres sacar de ello. Es una frase, va al principio, y decide si estás hablando con una persona o con un acusado.$md$,
  $j$[
    {
      "situation": "Has nombrado el tema y están visiblemente preparados.",
      "line": "Quiero solucionar esto, no discutir.",
      "why": "Les dice en qué papel están. Sin eso, la suposición más segura es que los van a culpar, y un acusado se comporta como un acusado."
    },
    {
      "situation": "Quieres que lo escuchen en vez de arreglarlo.",
      "line": "Sobre todo quiero que lo sepas, y luego estoy contento de dejarlo estar.",
      "why": "Muchas conversaciones difíciles fracasan porque una persona quería que la escucharan y la otra se pasó cuarenta minutos proponiendo soluciones."
    },
    {
      "situation": "De verdad quieres una disculpa.",
      "line": "(entonces dilo)",
      "why": "Mejor que fingir lo contrario y sentirte estafado por una solución que dijiste que querías."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué pasa si no lo dices?",
      "options": [
        { "text": "Suponen que los están culpando.", "correct": true, "note": "La suposición más segura cuando alguien te sienta a hablar, y una persona que cree que la están procesando se comporta como un acusado." },
        { "text": "Preguntan qué quieres.", "correct": false, "note": "Casi nadie lo hace. Actúan por una conjetura en su lugar." },
        { "text": "La conversación dura más.", "correct": false, "note": "Normalmente sí, y eso es consecuencia de la mala lectura, no el coste principal." },
        { "text": "Nada — se aclara sobre la marcha.", "correct": false, "note": "Para entonces el tono ya lo han marcado veinte minutos de ellos defendiéndose." }
      ],
      "explain": "Una frase al principio decide si estás hablando con una persona o con un acusado."
    },
    {
      "prompt": "¿Cuánto debería durar?",
      "options": [
        { "text": "Lo bastante larga para dejar claras tus intenciones.", "correct": false, "note": "Un preámbulo sobre tus intenciones empieza a sonar como un caso que se está construyendo, que produce la actitud defensiva que intentabas evitar." },
        { "text": "Lo que haga falta para sonar sincero.", "correct": false, "note": "La sinceridad no la produce la duración, y el esfuerzo por demostrarla se lee como manipulación." },
        { "text": "Dos o tres, para que nada quede ambiguo.", "correct": false, "note": "La ambigüedad no es el riesgo aquí. Una frase clara la elimina." },
        { "text": "Una frase.", "correct": true, "note": "Es un marco en vez de un argumento. Cualquier cosa más larga cambia lo que está haciendo." }
      ],
      "explain": "Y sé honesto en vez de diplomático — di lo que de verdad quieres."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_it", "label": "Dijo qué quería", "description": "Nombró el resultado al principio." },
      { "key": "honest", "label": "Fue honesto al respecto", "description": "Dijo el deseo real en vez de uno diplomático." },
      { "key": "one_sentence", "label": "Lo mantuvo en una frase", "description": "Un marco en vez de un caso." },
      { "key": "early", "label": "Lo puso pronto", "description": "Antes del contenido en vez de después." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Jo",
      "role": "alguien a quien le has pedido una conversación",
      "mood": "Preparado.",
      "openness": 4,
      "personality": "Por defecto se pone a defenderse cuando no sabe qué se le está pidiendo. Se relaja notablemente cuando se le dice para qué es la conversación."
    },
    "setting": "Has nombrado el tema. Se ha quedado callado y algo tenso, y claramente está esperando a averiguar lo mal que está esto.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Empieza a defenderte si el contenido llega sin ningún marco alrededor.",
      "Relájate e implícate de verdad en cuanto se te diga para qué es la conversación.",
      "Nunca preguntes qué quieren de ella."
    ],
    "opening_beat": "«Vale. Adelante, pues.»",
    "success_looks_like": "La persona dice qué quiere que produzca la conversación."
  }$j$::jsonb,
  'Hoy, dile a alguien al principio de una conversación difícil qué quieres sacar de ella. Una frase. Apúntala.',
  $j${
    "says": "Vale. Adelante, pues.",
    "model": {
      "line": "Antes de nada — quiero solucionar esto, no discutir. No busco una disculpa.",
      "why": "Una frase que les dice en qué papel están. Sin eso, la suposición más segura es que los van a culpar, y un acusado se comporta como un acusado."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Di qué quieres sacar de ello" },
      { "kind": "forbids_any", "words": ["llevo pensando", "desde hace tiempo", "seguramente ya sabes", "no quiero disgustarte", "por favor no te lo tomes", "escúchame"], "requirement": "Un marco, no un caso" },
      { "kind": "max_sentences", "n": 2, "requirement": "Una frase — es un marco" },
      { "kind": "max_words", "n": 30, "requirement": "Lo bastante corta para ser un marco" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('opening-it', 5,
  'Por escrito, o en persona',
  $md$Todo el que le cuesta esto se ha planteado escribirlo en su lugar, y el consejo que suele recibir — *nunca lo hagas por mensaje* — es demasiado tajante para ser útil.

**La jugada:** en persona por defecto, por escrito solo cuando compra algo real.

En persona es lo que se hace por defecto por un motivo que no es etiqueta. Obtienes el tono, puedes ver qué está calando, y puedes responder a lo que de verdad pasa en vez de a lo que te imaginaste. Por escrito elimina las tres cosas, y las elimina en una dirección concreta: un mensaje se lee más frío de lo que se quería, siempre, porque la calidez que habría estado en tu cara y tu voz no está en las palabras.

Un mensaje escrito también dura, se puede releer cuando alguien está en su peor momento, y se puede reenviar. Una frase que habrías dicho una vez y suavizado con tu cara se convierte en un documento.

Pero sí compra dos cosas, y merece la pena ser honesto al respecto.

**Consigue que se diga.** Alguien que no va a lograrlo en la sala y sí va a lograrlo por escrito debería escribirlo. Algo difícil dicho de forma imperfecta vale más que algo perfecto que nunca pasa, y ese trueque es real para mucha gente.

**Sobrevive a que te interrumpan.** Si la otra persona te habla por encima, o le da la vuelta a las cosas de forma fiable, escribir saca tu punto entero intacto — que a veces importa más que el tono.

El híbrido es mejor que cualquiera de las dos y casi nadie lo usa: un mensaje corto que nombra el tema y pide hablar, y luego la conversación en sí en persona. Eso es exactamente la primera lección de este bloque, y significa que la parte escrita está haciendo la parte para la que escribir es bueno.

Si tienes que hacerlo todo por escrito: corto, sin acusaciones, sin listas, y termina pidiendo hablar. Las quejas largas por escrito son el peor artefacto que puede producir este tema.

Si te quedas con una cosa: escribe para abrirlo, habla para tenerlo.$md$,
  $j$[
    {
      "situation": "Sabes que no lo vas a lograr en la sala.",
      "line": "(entonces escríbelo)",
      "why": "Algo difícil dicho de forma imperfecta gana a algo perfecto que nunca pasa, y ese trueque es real para mucha gente."
    },
    {
      "situation": "Estás redactando tres párrafos sobre lo que hicieron.",
      "line": "(eso se convierte en un documento)",
      "why": "Dura, se puede releer en el peor momento de alguien, y se puede reenviar. Una queja larga por escrito es el peor artefacto que produce este tema."
    },
    {
      "situation": "Quieres los beneficios de las dos cosas.",
      "line": "Un mensaje corto nombrando el tema, y luego hablar en persona.",
      "why": "La parte escrita hace la parte para la que escribir es bueno, y casi nadie usa esto."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué cuesta de verdad escribirlo?",
      "options": [
        { "text": "Parece cobarde.", "correct": false, "note": "Cómo se ve, y no es el mecanismo — mucha gente valiente escribe las cosas." },
        { "text": "Un mensaje se lee más frío de lo que se quería, siempre.", "correct": true, "note": "La calidez que habría estado en tu cara y tu voz no está en las palabras, y dura, se puede releer en el peor momento de alguien, y se puede reenviar." },
        { "text": "No se lo van a tomar en serio.", "correct": false, "note": "A menudo se lo toman más en serio, que es parte del problema en vez de una tranquilidad." },
        { "text": "No puedes saber si están molestos.", "correct": false, "note": "Cierto y uno de tres costes. La lectura más fría es la que hace el daño por sí sola." }
      ],
      "explain": "En persona por defecto. Escribir elimina el tono, la respuesta, y la capacidad de ver qué está calando."
    },
    {
      "prompt": "¿Cuándo es escribir de verdad la mejor opción?",
      "options": [
        { "text": "Cuando es muy serio.", "correct": false, "note": "La seriedad aboga por en persona, donde puedes ver qué le está haciendo a alguien." },
        { "text": "Cuando quieres que quede constancia.", "correct": false, "note": "A veces necesario en el trabajo, y querer que quede constancia cambia lo que es la conversación." },
        { "text": "Cuando si no, no va a pasar nunca.", "correct": true, "note": "Algo difícil dicho de forma imperfecta vale más que algo perfecto que nunca pasa. Ese trueque es real." },
        { "text": "Cuando estás demasiado enfadado para hablar.", "correct": false, "note": "Entonces espera. Escribir enfadado es la versión con más probabilidades de convertirse en un documento del que te arrepientas." }
      ],
      "explain": "Escribe para abrirlo, habla para tenerlo. El híbrido gana a cualquiera de las dos solas."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "default", "label": "Optó por defecto por en persona", "description": "Eligió la sala a menos que escribir comprara algo real." },
      { "key": "hybrid", "label": "Usó el híbrido", "description": "Escribió para abrirlo y habló para tenerlo." },
      { "key": "short", "label": "Mantuvo corto lo escrito", "description": "Sin listas, sin acusaciones, sin párrafos." },
      { "key": "got_it_said", "label": "Optó por conseguir que se dijera", "description": "Lo escribió en vez de no hacerlo en absoluto." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo al que le has enseñado el borrador",
      "mood": "Cuidadoso.",
      "openness": 5,
      "personality": "Pregunta para qué es el mensaje y si se leería como se pretende. No sugiere nada directamente."
    },
    "setting": "Has redactado un mensaje largo sobre todo el asunto y estás decidiendo si enviarlo.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta cómo se leería en un mal día, y quién más podría verlo.",
      "Tómate en serio la posibilidad de que escribir sea la única forma de que pase.",
      "Nunca le digas a la persona que lo envíe o no lo envíe."
    ],
    "opening_beat": "«Cuatro párrafos. ¿Qué quieres que hagan cuando lo hayan leído?»",
    "success_looks_like": "La persona elige el híbrido o acorta el mensaje drásticamente."
  }$j$::jsonb,
  'Hoy, coge algo que ibas a escribir entero y redúcelo a un mensaje que nombre el tema y pida hablar. Apunta las dos longitudes.',
  $j${
    "beats": [
      {
        "situation": "Has redactado cuatro párrafos sobre todo el asunto y estás decidiendo si enviarlo.",
        "prompt": "¿Qué haces con ello?",
        "options": [
          { "text": "Envíalo — es más claro de lo que lograrías en voz alta.", "correct": false, "note": "Dura, se puede releer en un mal día, y se puede reenviar. Una frase que habrías suavizado con tu cara se convierte en un documento." },
          { "text": "Redúcelo a un mensaje que nombre el tema y pida hablar.", "correct": true, "note": "La parte escrita hace lo que escribir hace bien, y la conversación pasa donde existen el tono y la respuesta. Casi nadie usa el híbrido." },
          { "text": "No envíes nada y dilo en persona en su lugar.", "correct": false, "note": "Mejor que los cuatro párrafos, y desperdicia la parte para la que escribir es de verdad bueno — abrirlo." },
          { "text": "Envíalo y luego dale seguimiento en persona.", "correct": false, "note": "El documento sigue existiendo, y la conversación ahora empieza desde lo que hayan hecho los cuatro párrafos." }
        ]
      },
      {
        "situation": "Sabes, con honestidad, que no vas a lograr decirlo en la sala.",
        "prompt": "¿Qué entonces?",
        "options": [
          { "text": "Hazlo en persona de todas formas — es la forma correcta.", "correct": false, "note": "Etiqueta que no produce nada. Algo no dicho no es una mejor versión de algo dicho de forma imperfecta." },
          { "text": "Escríbelo, y mantenlo corto.", "correct": true, "note": "Conseguir que se diga vale más que conseguir que se diga bien, y ese trueque es real para mucha gente. Corto, sin listas, sin acusaciones, y termina pidiendo hablar." },
          { "text": "Espera hasta que te sientas capaz.", "correct": false, "note": "Eso es pronto, que el bloque anterior estableció que no es una respuesta." },
          { "text": "Consigue que otra persona lo saque.", "correct": false, "note": "Cambia la conversación por completo y hace que sea sobre quién está implicado en vez de qué pasó." }
        ]
      }
    ]
  }$j$::jsonb
);
