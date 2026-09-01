-- Spanish: El trabajo, track 3 — Plantear un problema.
--
-- Conventions as migration 121. Notes:
--
-- **"Handover" is "el traspaso", and the thing that arrives late is "el
-- archivo".** English uses "the handover file" for both the process and the
-- artefact; Spanish needs them apart, because "el traspaso llega a las seis"
-- reads as a shift change rather than as a document.
--
-- **The character-judgement ban lost "vago".** It is inside "divagar", which a
-- reader could easily write while describing a meeting that wandered. The list
-- keeps "desorganizado", "descuidado", "poco fiable" and the two absolutes —
-- "siempre" and "nunca" — which are the ones this lesson is actually about.
--
-- **"Weather" appears again here as "un estado de ánimo"**, not as the literal
-- weather: in lesson 1 a complaint with no ask attached is a mood, and Spanish
-- has the same idiom for it.

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

select pg_temp.es_lesson('raising-a-problem', 1,
  'Conducta, coste, cambio',
  $md$A la gente no se la marca como difícil por plantear problemas. Se la marca como difícil por plantearlos con una forma concreta, y esa forma se puede evitar.

**La jugada:** di la conducta, di lo que costó, y pide un cambio concreto.

*Dos veces esta semana el archivo llegó a las seis y me quedé hasta tarde para sacarlo. ¿Podríamos acordar que llegue a las tres?* Cada parte de eso está haciendo un trabajo, y ninguna es una opinión.

**La conducta** es un hecho sobre lo que pasó. *El archivo llegó a las seis* se puede comprobar, aceptar y arreglar. *Es un desastre organizándose* es una afirmación sobre una persona, y una afirmación sobre una persona invita a defender a esa persona — normalmente la propia persona, largo y tendido — y no se decide nada. La regla es sencilla: si no se podría escribir en una entrada de calendario, probablemente sea un juicio de carácter disfrazado de descripción.

**El coste** es lo que lo convierte en un problema y no en una preferencia. Sin él estás describiendo algo que no te gustó, y la respuesta honesta es *¿y?*. Con él, hay una consecuencia que alguien tiene que sopesar.

**El cambio** es la parte que la gente se deja, y dejársela es lo que hace que una queja se archive como actitud. Un agravio sin nada pegado es un estado de ánimo. Una petición concreta, pequeña y respondible lo convierte en una tarea, y además es lo que de verdad hace que pare.

Una petición, no un rediseño. *¿Podríamos acordar que llegue a las tres?* se responde en un segundo. *¿Podríamos replantearnos cómo funciona todo este proceso?* es un proyecto, y los proyectos se agendan y luego se absorben.

Si te quedas con una cosa: sé aburrido con esto. Hechos, un coste y un cambio pequeño es muy difícil de rebatir y muy difícil de tenerte en cuenta.$md$,
  $j$[
    {
      "situation": "El archivo sigue llegando al final del día y tú sigues quedándote hasta tarde.",
      "line": "Dos veces esta semana el archivo llegó a las seis y me quedé hasta tarde para sacarlo. ¿Podríamos acordar que llegue a las tres?",
      "why": "Un hecho, una consecuencia, y una petición pequeña. No hay nada dentro contra lo que defenderse y nada dentro que archivar como actitud."
    },
    {
      "situation": "Estás a punto de decir que es un desastre organizándose.",
      "line": "(eso invita a que le defiendan a él, no a un arreglo)",
      "why": "Una afirmación sobre una persona es una opinión con la que alguien tiene que estar de acuerdo, y no lo van a estar. Una afirmación sobre lo que pasó sencillamente se puede comprobar."
    },
    {
      "situation": "Has descrito el problema y te has parado ahí.",
      "line": "(añade la petición, o es un estado de ánimo)",
      "why": "Una queja sin nada pegado es lo que se archiva como actitud. La petición es además la única parte que hace que pare."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué sale mal «es un desastre organizándose»?",
      "options": [
        { "text": "Es poco amable.", "correct": false, "note": "Puede ser del todo justo. Que sea justo no es lo que determina si funciona." },
        { "text": "Es poco profesional.", "correct": false, "note": "Una etiqueta en vez de un mecanismo, y no te dice qué decir en su lugar." },
        { "text": "Es una afirmación sobre una persona, así que se defiende en vez de arreglarse.", "correct": true, "note": "Una opinión hay que aceptarla, y esa no la acepta nadie. Un hecho sobre lo que pasó se puede comprobar y accionar." },
        { "text": "Es demasiado vago.", "correct": false, "note": "Cerca, y el problema no es la precisión. Incluso un juicio de carácter muy preciso se defiende en vez de arreglarse." }
      ],
      "explain": "Si no cabría en una entrada de calendario, es un juicio disfrazado de descripción."
    },
    {
      "prompt": "¿Qué hace en realidad la petición?",
      "options": [
        { "text": "Convierte un agravio en una tarea.", "correct": true, "note": "Y es la parte que hace que pare. Sin ella has descrito algo que no te gustó, y la respuesta honesta es: ¿y?" },
        { "text": "Hace que suenes constructivo.", "correct": false, "note": "Lo hace, y eso es cómo queda y no lo que hace." },
        { "text": "Demuestra que lo has pensado.", "correct": false, "note": "Cierto y secundario. El valor está en que alguien pueda actuar hoy." },
        { "text": "Evita que suenes emocional.", "correct": false, "note": "Estar molesto está bien y no es el problema. El problema es no tener nada que nadie pueda hacer." }
      ],
      "explain": "Una petición pequeña y respondible. No un rediseño: un rediseño es un proyecto, y los proyectos se absorben."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "behaviour", "label": "Describió la conducta", "description": "Dijo lo que pasó en vez de cómo es alguien." },
      { "key": "cost", "label": "Nombró el coste", "description": "Dejó claro por qué es un problema y no una preferencia." },
      { "key": "ask", "label": "Pidió un cambio", "description": "Pegó algo pequeño y respondible." },
      { "key": "boring", "label": "Lo mantuvo aburrido", "description": "Hechos en vez de sentimiento, y sin ningún juicio de carácter dentro." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un compañero con el que trabajas codo con codo",
      "mood": "Ocupado, sin esperarse esto.",
      "openness": 4,
      "personality": "A la defensiva ante las afirmaciones sobre su carácter y del todo razonable ante los hechos. Acepta rápido un cambio pequeño y concreto."
    },
    "setting": "Un momento tranquilo con un compañero cuyo archivo de traspaso ha llegado a las seis dos veces esta semana, y las dos veces te ha dejado trabajando hasta tarde.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Defiéndete largo y tendido ante cualquier cosa que suene a un juicio sobre ti.",
      "Acepta enseguida y de forma concreta un punto factual con una petición pequeña pegada.",
      "Nunca plantees tú el problema."
    ],
    "opening_beat": "«Ah, hola. ¿Conseguiste ayer todo lo que necesitabas?»",
    "success_looks_like": "La persona enuncia la conducta y el coste y pide un cambio concreto."
  }$j$::jsonb,
  'Hoy, plantea una cosa pequeña como conducta, coste y un cambio. Apunta las tres partes y qué te contestaron.',
  $j${
    "says": "Ah, hola. ¿Conseguiste ayer todo lo que necesitabas?",
    "model": {
      "line": "Casi todo. El archivo llegó a las seis dos veces esta semana y me quedé hasta tarde con él. ¿Podríamos acordar que llegue a las tres?",
      "why": "Un hecho, una consecuencia, y una petición pequeña y respondible. Nada de ello es una afirmación sobre esa persona, así que no hay nada contra lo que defenderse."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Pide un cambio concreto" },
      { "kind": "forbids_any", "words": ["desorganizado", "desorganizada", "descuidado", "poco fiable", "siempre", "nunca", "vosotros", "típico", "chapucero", "caótico", "un desastre"], "requirement": "Conducta, no carácter" },
      { "kind": "min_words", "n": 14, "requirement": "Di lo que costó, no solo lo que pasó" },
      { "kind": "max_words", "n": 40, "requirement": "Aburrido y corto" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('raising-a-problem', 2,
  'Díselo a esa persona primero',
  $md$Casi toda queja que se convierte en un problema se convirtió en uno por saltarse este paso.

Ir primero a la persona no es un requisito moral. Es lo que hace posible todo lo que viene después: la primera pregunta de tu jefe va a ser si lo has planteado directamente, y *no* es una respuesta que cambia de qué va la conversación. Deja de ser el archivo llegando a las seis y pasa a ser por qué te has saltado a alguien.

**La jugada:** una frase, la semana en que pasa, dicha como logística y no como una confrontación.

El tamaño es toda la técnica. Una cosa pequeña dicha en pequeño es un intercambio de trabajo corriente — *oye, ¿podría llegar antes el archivo? Me acabé quedando hasta tarde con él* — y cuesta unos ocho segundos. Lo mismo dicho en el cuarto mes, con cuatro casos pegados, es una confrontación, porque para entonces tiene que justificar los cuatro meses.

Pronto significa además que todavía no estás molesto, y eso vale más que cualquier formulación. Casi nadie sabe decir algo con ligereza una vez que lleva un tiempo cargándolo, y el cargarlo se oye.

Dilo en persona o en una llamada si puedes. Las quejas por escrito se leen más frías de lo que se pretendía, duran para siempre, y se pueden reenviar, lo que convierte una petición de dos líneas en un documento.

Y cuenta con una defensa. Casi todo el mundo se explica antes de aceptar, y la explicación no es una negativa: es lo que hace la gente mientras decide. Déjala correr, no discutas con ella, y vuelve a la petición. *Tiene sentido. ¿Aun así podríamos intentar las tres?*

Si te quedas con una cosa: plantéalo mientras es lo bastante pequeño como para sonar a nada. Eso no es evitar la conversación. Es tenerla lo bastante pronto como para que salga barata.$md$,
  $j$[
    {
      "situation": "Ha pasado dos veces esta semana y es jueves.",
      "line": "Oye, ¿podría llegar antes el archivo? Me acabé quedando hasta tarde con él.",
      "why": "Una frase, dicha como logística, costando unos ocho segundos. El mismo apunte en el cuarto mes tiene cuatro meses que justificar y se convierte en una confrontación."
    },
    {
      "situation": "Se ponen a explicarte por qué no era posible.",
      "line": "Tiene sentido. ¿Aun así podríamos intentar las tres?",
      "why": "Casi todo el mundo se explica antes de aceptar. La explicación no es una negativa, así que déjala correr y vuelve a la petición en vez de discutir con ella."
    },
    {
      "situation": "Lo estás redactando como correo para que quede más claro.",
      "line": "(dilo en voz alta en su lugar)",
      "why": "Las quejas por escrito se leen más frías de lo que se pretendía, duran para siempre, y se pueden reenviar, lo que convierte dos líneas en un documento."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué ir primero a la persona?",
      "options": [
        { "text": "Es lo justo.", "correct": false, "note": "Lo es, y que sea justo no es el argumento que va a conseguir que lo hagas un jueves por la tarde." },
        { "text": "Porque si no, la conversación deja de ir sobre el problema.", "correct": true, "note": "La primera pregunta de tu jefe es si lo has planteado directamente, y un no cambia el tema a por qué te has saltado a alguien." },
        { "text": "Puede que no sepan que lo están haciendo.", "correct": false, "note": "A menudo cierto, y es un motivo por el que funciona más que el motivo para hacerlo primero." },
        { "text": "Lo mantiene en privado.", "correct": false, "note": "Un beneficio. El punto estructural es lo que le pasa a todas las conversaciones posteriores a esta." }
      ],
      "explain": "Directo primero es lo que mantiene la siguiente conversación sobre el archivo en vez de sobre ti."
    },
    {
      "prompt": "¿Por qué importa más plantearlo pronto que formularlo bien?",
      "options": [
        { "text": "Porque todavía no estás molesto.", "correct": true, "note": "Casi nadie dice algo con ligereza una vez que lleva un tiempo cargándolo, y el cargarlo se oye con las palabras que se elijan." },
        { "text": "Porque más tarde ya se les habrá olvidado.", "correct": false, "note": "Una molestia práctica más que el mecanismo, y se arregla con una fecha." },
        { "text": "Porque puede que pare solo.", "correct": false, "note": "Esa es la esperanza que produce el cuarto mes." },
        { "text": "Porque los problemas pequeños son más fáciles de arreglar.", "correct": false, "note": "Cierto del problema y no de la conversación, que es de lo que va esta lección." }
      ],
      "explain": "Dilo mientras es lo bastante pequeño como para sonar a nada."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "direct", "label": "Fue primero a esa persona", "description": "Lo planteó con la persona en vez de por detrás." },
      { "key": "small", "label": "Lo mantuvo pequeño", "description": "Una frase, dicha como logística." },
      { "key": "early", "label": "Lo dijo pronto", "description": "Lo planteó cuando todavía era uno o dos casos." },
      { "key": "held_the_ask", "label": "Volvió a la petición", "description": "Dejó correr la explicación sin discutirla, y luego repitió la petición." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un compañero con el que trabajas codo con codo",
      "mood": "Estirado, con buena intención.",
      "openness": 4,
      "personality": "Se explica largo y tendido antes de aceptar nada, y por debajo es del todo razonable. Se pone a la defensiva si se le discute y acepta si la petición simplemente vuelve."
    },
    "setting": "Jueves por la tarde. El archivo de traspaso ha llegado a las seis dos veces esta semana. Tu compañero está en la mesa de al lado y no se ha dicho nada.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Explica largo y tendido por qué pasó antes de aceptar nada.",
      "Acepta enseguida si la persona deja correr la explicación y repite la petición.",
      "Ponte a la defensiva y deja de aceptar si la persona discute con la explicación."
    ],
    "opening_beat": "«Perdona, semana de locos. ¿Te cuadró al final todo?»",
    "success_looks_like": "La persona lo plantea en una frase ligera y vuelve a la petición después de la explicación."
  }$j$::jsonb,
  'Hoy, dile una cosa pequeña directamente a la persona, la semana en que pasó. Apunta qué dijiste y cuánto tardaste.',
  '{}'::jsonb
);

select pg_temp.es_lesson('raising-a-problem', 3,
  'Llevarlo hacia arriba',
  $md$Lo planteaste directamente, no cambió, y ahora tiene que ir a tu jefe. Este es el punto en el que una persona razonable se convierte, en el registro, en una difícil, y es casi todo cuestión de encuadre.

**La jugada:** llévalo como un problema que resolver, no como un agravio que juzgar.

Esas dos cosas producen frases de apertura distintas. Un agravio abre con la persona: *necesito hablar contigo de Sam.* Un problema abre con el trabajo: *el traspaso está llegando demasiado tarde para que yo pueda sacarlo, y no he conseguido arreglarlo con Sam directamente.* La segunda contiene exactamente la misma información, incluido el nombre, y le pide a tu jefe que haga algo en vez de que tome partido.

Di lo que ya has intentado, sin que te lo pidan. Responde a la primera pregunta antes de que la hagan, demuestra que esto no es un primer recurso, y deja caer sin ruido que no estás pidiendo que hagan algo que tú no estuvieras dispuesto a hacer.

Di qué quieres de esa persona. *¿Podrías marcar tú la expectativa con los horarios?* o *¿me puedes decir si lo estoy leyendo mal?* Quien dirige es mucho mejor haciendo una cosa concreta que recibiendo una situación, y una queja sin petición les deja inventarse una respuesta, que con frecuencia es una reunión que no quería nadie.

Dos cosas que dejar fuera. La opinión de los demás: *varios lo hemos notado* es una coalición, y una coalición sube la temperatura un orden de magnitud. Y el motivo: *creo que lo hace a propósito* no se puede demostrar, no se puede responder, y es la línea que te convierte a ti en el problema.

Si te equivocas, este encuadre no te cuesta nada. *¿Lo estoy leyendo mal?* preguntado con honestidad es una pregunta completamente segura, y es la diferencia entre alguien con una queja y alguien con criterio.

Si te quedas con una cosa: empieza por el trabajo, no por la persona. El nombre puede ir el segundo y quedar igual de claro.$md$,
  $j$[
    {
      "situation": "Necesitas plantearlo con tu jefe después de haberlo intentado directamente.",
      "line": "El traspaso está llegando demasiado tarde para que yo pueda sacarlo, y no he conseguido arreglarlo con Sam directamente.",
      "why": "Abre con el trabajo, incluye el nombre, y responde a la primera pregunta antes de que la hagan. Pide ayuda en vez de pedir un veredicto."
    },
    {
      "situation": "Estás a punto de decir que varios lo habéis notado.",
      "line": "(eso es una coalición, y cambia la temperatura)",
      "why": "Hablar por otra gente convierte un problema resoluble en uno de bandos, y tu jefe ahora tiene un incidente en vez de una petición."
    },
    {
      "situation": "No estás del todo seguro de estar siendo razonable.",
      "line": "¿Lo estoy leyendo mal?",
      "why": "Preguntado con honestidad es completamente seguro, y es la línea que separa a alguien con una queja de alguien con criterio."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cómo debería abrir?",
      "options": [
        { "text": "Necesito hablar contigo de Sam.", "correct": false, "note": "Eso es un agravio, y le pide a tu jefe que tome partido antes de saber sobre qué." },
        { "text": "Con el trabajo, y el nombre el segundo.", "correct": true, "note": "«El traspaso está llegando demasiado tarde» contiene exactamente la misma información y les pide resolver algo en vez de juzgar a alguien." },
        { "text": "Con cuánto tiempo lleva pasando.", "correct": false, "note": "Empieza por la acumulación, que suena a algo que se debería haber planteado antes, e invita justo a esa pregunta la primera." },
        { "text": "Con cómo te está haciendo sentir.", "correct": false, "note": "Honesto, y convierte el tema en ti en vez de en la cosa que quieres que cambie." }
      ],
      "explain": "Empieza por el trabajo. El nombre va el segundo y no queda menos claro por ello."
    },
    {
      "prompt": "¿Qué frase te hace más daño a ti?",
      "options": [
        { "text": "Ya se lo he planteado a él.", "correct": false, "note": "Lo contrario: di esto sin que te lo pidan. Responde a la primera pregunta y demuestra que no es un primer recurso." },
        { "text": "Creo que lo hace a propósito.", "correct": true, "note": "No se puede demostrar, no se puede responder, y mueve el tema de un archivo tardío a tu lectura de los motivos de alguien. Esta es la línea que te convierte en el problema." },
        { "text": "¿Podrías marcar tú la expectativa con los horarios?", "correct": false, "note": "Una petición, que es exactamente sobre lo que puede actuar un jefe." },
        { "text": "¿Lo estoy leyendo mal?", "correct": false, "note": "Segura y útil. Es lo que separa a alguien con una queja de alguien con criterio." }
      ],
      "explain": "No atribuyas nunca un motivo. No lo puedes saber y no se puede hacer nada con ello."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "work_first", "label": "Empezó por el trabajo", "description": "Abrió con el problema en vez de con la persona." },
      { "key": "already_tried", "label": "Dijo qué había intentado", "description": "Respondió sin que se lo pidieran a la pregunta de si fue directo primero." },
      { "key": "an_ask", "label": "Pidió algo concreto", "description": "Le dio a su jefe una acción en vez de una situación." },
      { "key": "no_motive", "label": "No atribuyó motivos", "description": "Dejó fuera la especulación sobre el porqué, y habló solo por sí mismo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa",
      "mood": "Atenta.",
      "openness": 4,
      "personality": "Servicial cuando le entregan un problema y visiblemente recelosa cuando le entregan un agravio. Pregunta de inmediato si se ha planteado directamente."
    },
    "setting": "Tu uno a uno. Planteaste los horarios del traspaso con Sam hace tres semanas, mejoró durante una semana, y ha vuelto a las seis.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta si se ha planteado directamente si la persona no lo dice antes.",
      "Ponte notablemente cauta ante la especulación sobre motivos o ante cualquier cosa dicha en nombre de otra gente.",
      "Actúa sin problema ante una petición concreta."
    ],
    "opening_beat": "«¿Decías que había algo que querías plantear?»",
    "success_looks_like": "La persona lo encuadra como un problema que resolver, dice qué ha intentado, y pide algo concreto."
  }$j$::jsonb,
  'Hoy, describe un problema en voz alta empezando por el trabajo y no por la persona. Apunta la frase con la que abriste.',
  $j${
    "beats": [
      {
        "situation": "Tu uno a uno. Planteaste el traspaso con Sam hace tres semanas y ha vuelto a las seis.",
        "prompt": "¿Cómo abres?",
        "options": [
          { "text": "Necesito hablar contigo de Sam.", "correct": false, "note": "Un agravio. Le pide a tu jefe que tome partido antes de saber sobre qué, y el tema ahora es una persona." },
          { "text": "Varios estamos teniendo problemas con el traspaso.", "correct": false, "note": "Una coalición, y sube la temperatura un orden de magnitud. Habla por ti y sigue siendo resoluble." },
          { "text": "El traspaso está llegando demasiado tarde para que yo lo saque, y no he conseguido arreglarlo con Sam directamente.", "correct": true, "note": "Abre con el trabajo, nombra a la persona en segundo lugar, y responde a la pregunta de si fuiste directo antes de que la hagan." },
          { "text": "Esto lleva meses pasando.", "correct": false, "note": "Empieza por la acumulación, lo que invita a «¿y por qué me entero ahora?» como primera pregunta." }
        ]
      },
      {
        "situation": "Ya lo has descrito. Están esperando.",
        "prompt": "¿Con qué terminas?",
        "options": [
          { "text": "En fin, solo quería que lo supieras.", "correct": false, "note": "Sin petición, así que tienen que inventarse una respuesta, que con frecuencia es una reunión que no quería nadie." },
          { "text": "¿Podrías marcar tú la expectativa con los horarios? Y dime si lo estoy leyendo mal.", "correct": true, "note": "Una acción concreta más una pregunta genuinamente abierta. Quien dirige es mucho mejor haciendo una cosa que recibiendo una situación." },
          { "text": "Creo que lo hace a propósito.", "correct": false, "note": "No se puede demostrar ni responder, y mueve el tema de un archivo tardío a tu lectura de los motivos de alguien." },
          { "text": "No sé qué quieres que haga al respecto.", "correct": false, "note": "Les entrega el problema y la frustración a la vez, y ninguna de las dos es accionable." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('raising-a-problem', 4,
  'No lo acumules',
  $md$Tragar no sale gratis, y el motivo por el que la gente lo hace igualmente es que cada caso concreto es genuinamente demasiado pequeño como para mencionarlo.

Eso es verdad, y así es como se construye el montón. Nada merece la pena plantearlo por sí solo, así que no se plantea nada, y once meses después hay una lista. Y entonces la lista se entrega — normalmente en una evaluación, de vez en cuando en una dimisión — y el efecto es lo contrario de todo lo que hay en ella.

**La jugada:** plantea una cosa en el momento en que pasa, y deja ir las pequeñas.

Una lista pone a alguien en juicio. Por muy verdadero que sea cada elemento, doce a la vez no son doce problemas, son un caso, y un caso invita a una defensa en vez de a un cambio. Además no se puede accionar: nadie puede arreglar doce cosas, así que no arregla ninguna y en su lugar te gestiona a ti.

Es peor que eso, porque la lista socava sus propios elementos. *¿Y por qué me entero ahora?* es una pregunta justa sin ninguna buena respuesta, y la honesta — *cada una parecía demasiado pequeña* — hace que el conjunto suene a rencor en vez de a un conjunto de hechos.

Así que la disciplina está aguas arriba. Plantéalo pequeño, en el momento, o decide que de verdad no pasa nada y déjalo ir, y dilo en serio. Lo que no puedes hacer es guardarlo en el banco. Una cosa que decidiste no plantear no está ahorrada, está gastada.

Si te das cuenta de que ya tienes una lista, no la entregues. Elige la que todavía más importa, plantea esa sola, a tamaño normal, como si hubiera pasado esta semana. Las demás o se repetirán, y entonces se plantean como es debido, o resultarán haber sido el estado de ánimo de un mal trimestre.

Si te quedas con una cosa: no lo guardes nunca. Una cosa en el momento es una conversación de trabajo; cinco a la vez es una campaña, tenga razón quien la tenga.$md$,
  $j$[
    {
      "situation": "Ha pasado algo pequeño y no merece la pena mencionarlo.",
      "line": "(entonces déjalo ir de verdad, o dilo ahora)",
      "why": "Una cosa que decidiste no plantear no está en el banco, está gastada. Decidir a medias es lo que construye el montón."
    },
    {
      "situation": "Tienes una lista de once cosas y una evaluación a la vuelta.",
      "line": "(elige la que todavía importa)",
      "why": "Doce a la vez es un caso y no doce problemas, y un caso invita a una defensa. Una, a tamaño normal, sí se puede arreglar."
    },
    {
      "situation": "«¿Y por qué me entero de esto ahora?»",
      "line": "(una pregunta justa sin ninguna buena respuesta)",
      "why": "«Cada una parecía demasiado pequeña» es honesto y hace que la lista entera suene a rencor. La única defensa es no haber construido una."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué es peor una lista que un solo elemento?",
      "options": [
        { "text": "Se tarda demasiado en pasarla entera.", "correct": false, "note": "La duración no es el fallo. Una lista corta hace lo mismo." },
        { "text": "Algunos elementos son flojos.", "correct": false, "note": "A menudo cierto, e incluso una lista de elementos fuertes produce la misma reacción." },
        { "text": "Nadie puede arreglar doce cosas, así que en su lugar te gestionan a ti.", "correct": true, "note": "Doce a la vez es un caso, no doce problemas. Un caso invita a una defensa, y la respuesta pasa a ser sobre quien lo plantea." },
        { "text": "Suena a amargura.", "correct": false, "note": "Cómo suena viene después de lo que hace. El mecanismo es que no se puede accionar." }
      ],
      "explain": "Una cosa en el momento es una conversación de trabajo. Cinco a la vez es una campaña, tenga razón quien la tenga."
    },
    {
      "prompt": "Pasa algo pequeño y de verdad no merece la pena plantearlo. ¿Qué haces?",
      "options": [
        { "text": "Anotarlo, por si hay un patrón.", "correct": false, "note": "Así es exactamente como se construye un montón, y siempre parece diligencia en el momento." },
        { "text": "Dejarlo ir, y en serio.", "correct": true, "note": "La decisión tiene que ser real. Una cosa que decidiste no plantear no está ahorrada: está gastada." },
        { "text": "Plantearlo igualmente, por si acaso.", "correct": false, "note": "Pasarse de corrección. No todo merece una conversación, y plantearlo todo es su propio problema." },
        { "text": "Mencionarlo de pasada para que quede constancia.", "correct": false, "note": "Un registro sin ninguna petición pegada es un estado de ánimo, y así se va a recordar." }
      ],
      "explain": "Plantéalo pequeño en el momento, o déjalo ir de verdad. Guardarlo es la única opción que no funciona."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one", "label": "Planteó una cosa", "description": "No entregó una lista." },
      { "key": "at_the_time", "label": "Lo planteó cerca del momento", "description": "No esperó a una evaluación ni a un punto de ruptura." },
      { "key": "let_go", "label": "Dejó ir las pequeñas", "description": "Tomó una decisión real en vez de guardarlas." },
      { "key": "normal_size", "label": "Lo mantuvo a tamaño normal", "description": "Lo planteó como si hubiera pasado esta semana." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa, llevando tu evaluación",
      "mood": "Positiva con la evaluación hasta ahora.",
      "openness": 4,
      "personality": "Abierta y constructiva con una cosa clara, y a la defensiva cuando le entregan una acumulación. Pregunta por qué se entera ahora."
    },
    "setting": "Tu evaluación, y llevas once meses llevando la cuenta en silencio. Hay unas nueve cosas en la lista mental.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Métete de verdad y de forma constructiva con un solo elemento claro.",
      "Pregunta por qué te enteras ahora si llegan más de dos cosas juntas, y ponte a la defensiva.",
      "Nunca invites a una lista."
    ],
    "opening_beat": "«¿Algo por tu parte? ¿Algo que no haya estado funcionando?»",
    "success_looks_like": "La persona plantea una cosa a tamaño normal en vez de la lista acumulada."
  }$j$::jsonb,
  'Hoy, coge una cosa de tu lista mental y plantéala sola, a tamaño normal. Apunta cuál fue y qué dejaste ir.',
  $j${
    "beats": [
      {
        "situation": "Tu evaluación. Llevas once meses llevando la cuenta y hay unas nueve cosas.",
        "prompt": "«¿Algo por tu parte?»",
        "options": [
          { "text": "Pasar la lista: todo es verdad.", "correct": false, "note": "Nueve a la vez es un caso y no nueve problemas. Nadie puede arreglar nueve cosas, así que no arregla ninguna y en su lugar te gestiona a ti." },
          { "text": "Nada, la verdad.", "correct": false, "note": "El otro fallo, y es así como la lista llegó a nueve. Tragar es una decisión que se vuelve a tomar cada día." },
          { "text": "Las tres más gordas.", "correct": false, "note": "Mejor y sigue siendo una acumulación. Tres a la vez invita a «¿y por qué me entero ahora?», que no tiene buena respuesta." },
          { "text": "La que todavía más importa, a tamaño normal.", "correct": true, "note": "Una cosa, planteada como si hubiera pasado esta semana, sí se puede arreglar. El resto o se repite y se plantea como es debido, o resulta haber sido un mal trimestre." }
        ]
      },
      {
        "situation": "Pasa algo pequeño y molesto un martes. De verdad no merece una conversación.",
        "prompt": "¿Qué haces con ello?",
        "options": [
          { "text": "Dejarlo ir, de verdad.", "correct": true, "note": "La decisión tiene que ser real. Una cosa que decidiste no plantear no está guardada para más tarde: está gastada." },
          { "text": "Tomar nota, por si se convierte en un patrón.", "correct": false, "note": "Así es precisamente como se construye un montón, y parece diligencia absolutamente siempre." },
          { "text": "Plantearlo igualmente.", "correct": false, "note": "No todo merece una conversación, y plantearlo todo es un problema distinto con el mismo final." },
          { "text": "Mencionarlo con ligereza para que quede constancia.", "correct": false, "note": "Un registro sin ninguna petición pegada es un estado de ánimo, y así se va a recordar." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('raising-a-problem', 5,
  'Cuando no cambia nada',
  $md$Lo planteaste como es debido, mejoró durante quince días, y ahora está exactamente como estaba. Este es el desenlace corriente y a casi nadie le dicen qué hacer con él.

Los dos instintos son malos. Uno es callarse y añadirlo al montón que te dijeron que no construyeras. El otro es volver a plantearlo de la misma forma, que es la definición de dar la lata y es donde la persona razonable por fin empieza a parecer difícil.

**La jugada:** plantéalo una vez más, de otra manera: nombra el patrón en vez del caso, y pregunta qué tendría que ser verdad.

El caso ya se planteó. Volver a plantearlo es una repetición, y las repeticiones se oyen como una personalidad. El patrón es información nueva: *acordamos las tres, y desde entonces han sido las seis dos veces. No creo que las tres sean alcanzables. ¿Qué tendría que cambiar para que lo fueran?* Esa no es la misma conversación. Pone sobre la mesa el acuerdo en sí en vez del archivo, y es mucho más difícil de responder con una disculpa y el propósito de hacerlo mejor.

Preguntar qué tendría que ser verdad es la pregunta útil, y tiene tres respuestas honestas. Algo puede cambiar, y entonces tienes un arreglo. No puede cambiar nada, y entonces esto es el trabajo — y saberlo merece la pena, porque a partir de ahí puedes decidir sobre el trabajo en vez de seguir moliendo con el archivo. O no lo sabe nadie, lo que normalmente significa que hace falta alguien sénior en la sala.

Y luego para. Dos intentos bien hechos es lo que hace una persona razonable; un tercero es una campaña. Después del segundo, la decisión que tienes delante no es cómo volver a plantearlo, es si esto es algo con lo que puedes vivir, y eso es una decisión de verdad con opciones de verdad, incluida irte, que es legítima si se toma a propósito y no por acumulación.

Si te quedas con una cosa: el segundo intento nombra el patrón y pregunta qué tendría que cambiar. No hay un tercero.$md$,
  $j$[
    {
      "situation": "Acordasteis las tres, y desde entonces han sido las seis dos veces.",
      "line": "Acordamos las tres, y desde entonces han sido las seis dos veces. ¿Qué tendría que cambiar para que las tres fueran posibles?",
      "why": "Nombra el patrón en vez del caso, y pone sobre la mesa el acuerdo en lugar del archivo. Mucho más difícil de responder con el propósito de hacerlo mejor."
    },
    {
      "situation": "Estás a punto de plantear lo mismo de la misma forma.",
      "line": "(eso es una repetición, y las repeticiones se oyen como una personalidad)",
      "why": "El caso ya se planteó. Solo la información nueva — el patrón — hace que la segunda conversación sea otra distinta."
    },
    {
      "situation": "Dos intentos como es debido y no se ha movido nada.",
      "line": "(ahora es una decisión sobre el trabajo, no sobre el archivo)",
      "why": "Un tercer intento es una campaña. La pregunta real pasa a ser si esto es vivible, que es una decisión con opciones y no una conversación para seguir teniendo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hace distinta la segunda conversación de la primera?",
      "options": [
        { "text": "Es más firme.", "correct": false, "note": "La firmeza no es información nueva, y subir el volumen es como la persona razonable empieza a parecer difícil." },
        { "text": "Va a alguien más sénior.", "correct": false, "note": "A veces es donde termina, y no es lo que hace funcionar el segundo intento." },
        { "text": "Nombras el patrón en vez del caso.", "correct": true, "note": "El caso ya se planteó; repetirlo es una repetición. El patrón es genuinamente nuevo, y pone sobre la mesa el acuerdo en vez del archivo." },
        { "text": "Lo pones por escrito.", "correct": false, "note": "Eso sube la formalidad sin añadir nada, y las quejas por escrito duran para siempre." }
      ],
      "explain": "Información nueva, no más volumen. Acordamos las tres, y desde entonces han sido las seis dos veces."
    },
    {
      "prompt": "¿Por qué preguntar qué tendría que cambiar?",
      "options": [
        { "text": "Las tres respuestas posibles sirven.", "correct": true, "note": "Algo puede cambiar y tienes un arreglo. No puede nada, y esto es el trabajo, cosa que merece saberse. O no lo sabe nadie, lo que significa que hace falta alguien sénior." },
        { "text": "Suena colaborativo.", "correct": false, "note": "Lo suena, y el tono no es lo que hace que merezca la pena preguntarlo." },
        { "text": "Les devuelve el trabajo a ellos.", "correct": false, "note": "Ese encuadre lo convierte en una maniobra. La pregunta es genuinamente abierta, y por eso recibe una respuesta de verdad." },
        { "text": "Evita que te repitas.", "correct": false, "note": "Un efecto secundario. También podrías evitar repetirte no diciendo nada." }
      ],
      "explain": "Dos intentos, bien hechos. Después de eso la pregunta va sobre el trabajo, no sobre el archivo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "pattern", "label": "Nombró el patrón", "description": "Planteó la repetición en vez del último caso." },
      { "key": "open_question", "label": "Preguntó qué tendría que cambiar", "description": "Puso sobre la mesa el acuerdo en sí." },
      { "key": "no_heat", "label": "No subió el volumen", "description": "Lo convirtió en información nueva en vez de en una repetición más firme." },
      { "key": "stopped", "label": "Sabía que era el segundo y el último", "description": "Lo trató como el intento final y no como uno de muchos." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un compañero con el que trabajas codo con codo",
      "mood": "Genuinamente arrepentido, genuinamente sobrecargado.",
      "openness": 4,
      "personality": "Se disculpa y es sincero con cada caso concreto, y es incapaz de sostener el acuerdo. Se mete en serio cuando se cuestiona el acuerdo en sí."
    },
    "setting": "Seis semanas después de que acordarais un traspaso a las tres. Aguantó quince días y desde entonces han sido las seis dos veces.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Discúlpate y promete hacerlo mejor si la persona plantea el último caso.",
      "Métete con honestidad en el acuerdo en sí si la persona nombra el patrón, y admite que las tres puede que no sean alcanzables.",
      "Nunca propongas tú un cambio."
    ],
    "opening_beat": "«Ya lo sé, ya lo sé, ha vuelto a ser tarde. Lo siento, ha sido una pesadilla.»",
    "success_looks_like": "La persona nombra el patrón y pregunta qué tendría que cambiar."
  }$j$::jsonb,
  'Hoy, coge una cosa que ya hayas planteado una vez y nombra el patrón en vez del caso. Apunta la pregunta que hiciste.',
  $j${
    "says": "Ya lo sé, ya lo sé, ha vuelto a ser tarde. Lo siento, ha sido una pesadilla.",
    "model": {
      "line": "Acordamos las tres, y desde entonces han sido las seis dos veces. ¿Qué tendría que cambiar para que las tres fueran posibles?",
      "why": "Nombra el patrón en vez del caso, que es lo único que hace que una segunda conversación no sea una repetición. Pone sobre la mesa el acuerdo en lugar del archivo."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Pregunta qué tendría que cambiar" },
      { "kind": "contains_any", "words": ["acordamos", "otra vez", "dos veces", "sigue", "cada vez", "patrón", "desde", "las tres"], "requirement": "Nombra el patrón, no el último caso" },
      { "kind": "forbids_any", "words": ["inaceptable", "harto", "harta", "hasta las narices", "ridículo", "en serio", "cuántas veces"], "requirement": "Información nueva, no más volumen" },
      { "kind": "max_words", "n": 35, "requirement": "Dos frases como mucho" }
    ]
  }$j$::jsonb
);
