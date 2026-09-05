-- Spanish: Storytelling, track 4 — Mantener la palabra.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Priya" (lessons 1-4) — established feminine exception name.
-- "Rob" (lesson 5) is a new, unambiguously masculine name; masculine
-- agreement used. Lesson 3 is [scene] mode with an empty rehearsal_spec
-- (`{}`), matching the English source.

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

select pg_temp.es_lesson('holding-the-floor', 1,
  'A nadie le molesta una buena historia',
  $md$Antes de que cualquiera de las técnicas sirva de algo, hay que abordar la creencia de debajo, y es esta: que coger noventa segundos de la atención de una mesa es algo que le estás quitando a la gente.

**La jugada:** date cuenta de que la imposición es la calidad, no la duración.

Una historia de noventa segundos bien contada es un regalo, y está cerca de lo que la gente ha salido a buscar. Nadie se ha ido nunca a casa molesto por alguien que contó una buena. Lo que sí molesta a la gente — y merece la pena ser exacto, porque el miedo no es infundado — es una de seis minutos mal contada, y la diferencia entre las dos no es la confianza ni el derecho a hablar. Son los dos bloques que acabas de leer.

Hay una segunda cosa que merece la pena ver, que es cómo es de verdad una sala en la que nadie está dispuesto a contar una. No está relajada. Está plana, y todo el mundo en ella puede notar que se ha quedado así sin poder explicarlo — y la gente con más probabilidades de tener esta creencia a menudo es la que más mejoraría la velada con sus historias.

El miedo tiene una forma concreta que hace que merezca la pena responderlo en vez de descartarlo. Dice: todo el mundo está siendo educado, nadie quiere esto, y les estoy haciendo esperar. Así es como se siente desde dentro de una historia de la que no estás seguro. Desde fuera, una mesa escuchando una historia parece una mesa disfrutando, y el esfuerzo que estás detectando casi siempre es el tuyo propio.

La excepción honesta: hay momentos en los que una historia es de verdad inadecuada, y eso es una cuestión de momento, no de permiso. Alguien acaba de decir algo serio, o está llegando la comida, o dos personas están en mitad de una conversación. Leer eso es la cuarta lección de este bloque y es una habilidad real — pero es algo completamente distinto de creer que no tienes nada que merezca noventa segundos.

Si te quedas con una cosa: lo que te preocupa imponer es lo que la gente vino a buscar.$md$,
  $j$[
    {
      "situation": "Tienes una historia y decides no molestar a la mesa con ella.",
      "line": "(la imposición es la calidad, no la duración)",
      "why": "Nadie se ha ido nunca a casa molesto por alguien que contó una buena historia de noventa segundos. Lo que molesta a la gente es una de seis minutos mal contada."
    },
    {
      "situation": "La mesa se ha quedado callada y nadie dice mucho.",
      "line": "(eso no está relajado, está plano)",
      "why": "Todo el mundo puede sentirlo sin nombrarlo, y la gente con más probabilidades de guardarse una historia es la que la arreglaría."
    },
    {
      "situation": "Sientes que la sala se esfuerza mientras hablas.",
      "line": "(ese normalmente es el tuyo propio)",
      "why": "Desde fuera, una mesa escuchando una historia parece una mesa disfrutando. El esfuerzo se está detectando desde dentro."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué molesta de verdad a la gente?",
      "options": [
        { "text": "Alguien que habla mucho.", "correct": false, "note": "La gente que habla mucho y cuenta buenas historias es la que todo el mundo quiere en una cena." },
        { "text": "Una larga mal contada.", "correct": true, "note": "La imposición es la calidad, no la duración, y la diferencia entre las dos es la estructura — que se puede aprender y son los dos bloques anteriores." },
        { "text": "Que le hagan escuchar en absoluto.", "correct": false, "note": "Escuchar algo bueno es lo contrario de un coste, y está cerca de por qué la gente sale." },
        { "text": "Alguien que domina la velada.", "correct": false, "note": "Algo real sobre la proporción, y no lo que impide hablar al lector de esta app." }
      ],
      "explain": "Nadie se ha ido a casa molesto por una buena historia de noventa segundos."
    },
    {
      "prompt": "¿Cómo es una sala donde nadie cuenta historias?",
      "options": [
        { "text": "Relajada.", "correct": false, "note": "Se siente así desde dentro de la decisión de no hablar, y no es lo que está experimentando la sala." },
        { "text": "Equilibrada — todo el mundo tiene su turno.", "correct": false, "note": "Los turnos no son la moneda, y una velada de intercambios cortos no es más igualitaria, solo más pobre." },
        { "text": "Educada.", "correct": false, "note": "La educación está presente y no es lo que caracteriza la velada." },
        { "text": "Plana, y todo el mundo puede sentirlo.", "correct": true, "note": "Sin poder nombrarlo — y la gente con más probabilidades de guardarse una historia a menudo es la que la arreglaría." }
      ],
      "explain": "El esfuerzo que detectas mientras cuentas una casi siempre es el tuyo propio."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "told_it", "label": "Contó la historia", "description": "No se la guardó." },
      { "key": "no_permission", "label": "No buscó permiso", "description": "Cogió los noventa segundos en vez de pedirlos." },
      { "key": "quality_not_length", "label": "Apuntó a la calidad", "description": "Trabajó en cómo la contaba en vez de acortarla por culpa." },
      { "key": "read_strain", "label": "Leyó bien el esfuerzo", "description": "No confundió sus propios nervios con la paciencia de la sala." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa",
      "mood": "Cómoda, algo aburrida.",
      "openness": 4,
      "personality": "Visiblemente encantada cuando alguien empieza una historia, y la velada mejora notablemente. Nunca le pide a nadie que cuente una."
    },
    "setting": "Una mesa de cinco, un bache en la conversación, y tienes una buena historia que has decidido no contar.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con placer y atención evidentes a cualquiera que empiece una historia.",
      "Deja que continúe el bache si nadie dice nada, y describe cómo la mesa se queda más callada.",
      "Nunca invites a la persona a hablar."
    ],
    "opening_beat": "(un bache — alguien mira su móvil)",
    "success_looks_like": "La persona cuenta la historia en vez de guardársela."
  }$j$::jsonb,
  'Hoy, cuenta una historia que normalmente te habrías guardado. Apunta qué te frenó la última vez.',
  $j${
    "beats": [
      {
        "situation": "Un bache en una mesa de cinco. Tienes una buena historia y has decidido no contarla, porque tardaría unos noventa segundos de la atención de todos.",
        "prompt": "¿Qué son esos noventa segundos?",
        "options": [
          { "text": "Algo que les estarías quitando.", "correct": false, "note": "La creencia que existe para responder todo el bloque. Nadie se ha ido nunca a casa molesto por alguien que contó una buena historia." },
          { "text": "Razonable, si la historia es lo bastante buena como para justificarlo.", "correct": false, "note": "La justificación es el marco equivocado — mantiene el permiso en el centro, y es por lo que la historia nunca se cuenta." },
          { "text": "Cerca de lo que la gente ha salido a buscar.", "correct": true, "note": "La imposición es la calidad, no la duración, y la calidad son los dos bloques que ya has leído." },
          { "text": "Un riesgo que merece la pena correr de vez en cuando.", "correct": false, "note": "No es un riesgo que se esté gestionando. Una sala en la que nadie está dispuesto a contar una está plana, y todo el mundo puede sentirlo." }
        ]
      },
      {
        "situation": "La estás contando, y sientes que la mesa se esfuerza.",
        "prompt": "¿Qué es esa sensación?",
        "options": [
          { "text": "Precisa — ya han tenido suficiente.", "correct": false, "note": "Posible, y es lo que se siente desde dentro con una historia de la que no estás seguro, independientemente de lo que esté haciendo la sala." },
          { "text": "Una señal para acelerar.", "correct": false, "note": "Acelerar se lee como ansiedad y hace más difícil seguirla. Llegar al final es el arreglo." },
          { "text": "Un motivo para acortarla y disculparte.", "correct": false, "note": "Acortarla es correcto y la disculpa es lo que convierte un momento ordinario en uno memorable." },
          { "text": "Casi siempre el tuyo propio.", "correct": true, "note": "Desde fuera, una mesa escuchando una historia parece una mesa disfrutando. El esfuerzo se está detectando desde dentro." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('holding-the-floor', 2,
  'Cuánto tiempo tienes',
  $md$La duración no es una regla, es una lectura, y la lectura no es difícil una vez que sabes qué estás mirando.

**La jugada:** ajusta la duración al entorno en vez de a la historia.

**En grupo, sesenta a noventa segundos.** Eso es mucho más corto de lo que la gente cree, y son más o menos un marco, cuatro o cinco frases de construcción, el giro, y la última línea. Casi todas las historias de conversación que funcionan caben ahí.

**Uno a uno, más largo está bien.** Dos o tres minutos son cómodos, porque no hay una tercera persona esperando un hueco y el oyente puede interrumpir libremente, que cambia todo el contrato.

**De pie, o con la comida llegando, mucho más corto.** Treinta segundos. La gente de pie en una fiesta está gestionando su bebida, la sala y sus pies, y una historia de dos minutos pide un tipo de atención que la postura no suministra.

La lectura en sí es sencilla: fíjate en el momento en que alguien deja de escuchar y empieza a esperar. Es visible — un asentimiento que llega algo pronto, una mirada hacia otra persona, una sonrisa sostenida un compás de más. Eso no es mala educación y no es un veredicto sobre la historia; es una señal sobre el tiempo, y la respuesta es llegar al final en vez de acelerar.

Dos cosas que merece la pena saber sobre la duración. Una historia demasiado larga no es una historia con demasiado buen material, es una historia con demasiado material que ni prepara el giro ni lo paga — lo que significa que el arreglo es la prueba de cortar, no la compresión. Y la segunda mejor versión de una historia, contada en noventa segundos, gana a la mejor versión contada en cuatro minutos, siempre, en todos los entornos.

Si te quedas con una cosa: noventa segundos en grupo. Si no cabe, el problema es qué hay dentro, no lo rápido que lo estás diciendo.$md$,
  $j$[
    {
      "situation": "Estás en una mesa de seis.",
      "line": "(sesenta a noventa segundos)",
      "why": "Un marco, cuatro o cinco frases de construcción, el giro, y la última línea. Casi todas las historias de conversación que funcionan caben ahí."
    },
    {
      "situation": "Alguien asiente algo pronto y mira al otro lado de la mesa.",
      "line": "(esa es una señal sobre el tiempo)",
      "why": "Han dejado de escuchar y han empezado a esperar. No es un veredicto sobre la historia, y la respuesta es llegar al final en vez de acelerar."
    },
    {
      "situation": "No cabe en noventa segundos.",
      "line": "(entonces algo dentro no está sirviendo al giro)",
      "why": "Una historia demasiado larga no es una con demasiado buen material. El arreglo es la prueba de cortar, no hablar más rápido."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuánto dura una historia en grupo?",
      "options": [
        { "text": "Lo que haga falta para mantenerlos enganchados.", "correct": false, "note": "Cierto en principio e inútil en el momento, porque mantenerlos enganchados es exactamente lo que no puedes juzgar desde dentro." },
        { "text": "Sesenta a noventa segundos.", "correct": true, "note": "Un marco, cuatro o cinco frases de construcción, el giro, la última línea. Mucho más corto de lo que la gente cree, y casi todas las que funcionan caben ahí." },
        { "text": "Dos a tres minutos.", "correct": false, "note": "Esa es la duración uno a uno, donde no hay una tercera persona esperando un hueco." },
        { "text": "Depende por completo de la historia.", "correct": false, "note": "Depende mucho más del entorno, que es la mitad útil de la respuesta." }
      ],
      "explain": "La segunda mejor versión en noventa segundos gana a la mejor versión en cuatro minutos."
    },
    {
      "prompt": "Ves a alguien esperando en vez de escuchando. ¿Qué haces?",
      "options": [
        { "text": "Acelera.", "correct": false, "note": "Se lee como ansiedad y hace el resto más difícil de seguir, que los pierde más rápido." },
        { "text": "Para y discúlpate.", "correct": false, "note": "Convierte su atención en el tema y pone a todos en una posición incómoda por un momento ordinario." },
        { "text": "Llega al final.", "correct": true, "note": "Salta al giro y entrega la última línea. Llegar antes es el arreglo; hablar más rápido no lo es." },
        { "text": "Añade algo para recuperarlos.", "correct": false, "note": "Más material es lo contrario de lo que necesita una historia que está perdiendo a la sala." }
      ],
      "explain": "Es una señal sobre el tiempo, no un veredicto sobre la historia."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "right_length", "label": "Ajustó al entorno", "description": "Noventa segundos en grupo, más corto de pie." },
      { "key": "read_it", "label": "Leyó la señal", "description": "Notó que escuchar se convertía en esperar." },
      { "key": "arrived", "label": "Llegó al final", "description": "Saltó hacia delante en vez de acelerar." },
      { "key": "cut_not_compressed", "label": "Cortó en vez de comprimir", "description": "Quitó material en vez de hablar más rápido." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa",
      "mood": "Atenta, vigilando la sala.",
      "openness": 4,
      "personality": "Informa con sencillez de la atención de la mesa — quién escucha, quién ha empezado a esperar — sin comentar la historia."
    },
    "setting": "Una mesa de seis. Llevas unos noventa segundos de historia y alguien acaba de mirar a otra persona.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Describe con sencillez la atención de la mesa según cambia.",
      "Informa de que la atención vuelve si el narrador se dirige hacia el final.",
      "Informa de que se drena más si el narrador añade material o acelera."
    ],
    "opening_beat": "(alguien al otro extremo asiente algo pronto y mira al otro lado de la mesa)",
    "success_looks_like": "La persona llega al giro y termina en vez de acelerar o añadir."
  }$j$::jsonb,
  'Hoy, cronometra una historia que cuentes. Apunta cuánto duró y cuánto creías que había durado.',
  $j${
    "beats": [
      {
        "situation": "Llevas unos noventa segundos de historia en una mesa de seis, con más o menos un minuto de material que queda.",
        "prompt": "¿Dónde estás?",
        "options": [
          { "text": "Bien — es una buena historia y aguanta.", "correct": false, "note": "La calidad no amplía el presupuesto. Casi todas las historias de conversación que funcionan caben en noventa segundos." },
          { "text": "Al final del presupuesto, con demasiado que queda.", "correct": true, "note": "Sesenta a noventa segundos en grupo. Un minuto de material restante significa que algo dentro ni prepara el giro ni lo paga." },
          { "text": "Más o menos a la mitad, que es normal.", "correct": false, "note": "Tres minutos es la duración uno a uno. En una mesa de seis es más o menos el doble de lo que soporta el entorno." },
          { "text": "Imposible de decir sin conocer la sala.", "correct": false, "note": "La sala importa y el entorno te da la mayor parte de la respuesta antes de empezar." }
        ]
      },
      {
        "situation": "Alguien asiente algo pronto y mira a la persona de al lado.",
        "prompt": "¿Qué es eso?",
        "options": [
          { "text": "Mala educación.", "correct": false, "note": "Es involuntario, y leerlo como mala educación produce una respuesta defensiva ante una señal ordinaria." },
          { "text": "Un veredicto sobre la historia.", "correct": false, "note": "Va sobre el tiempo, no la calidad — la misma persona habría adorado la misma historia en noventa segundos." },
          { "text": "Nada — la gente mira alrededor constantemente.", "correct": false, "note": "El asentimiento temprano es la señal delatora. Juntos son la señal más fiable disponible en una mesa." },
          { "text": "Escuchar convirtiéndose en esperar.", "correct": true, "note": "Visible, ordinario, y una señal para llegar al final — que significa saltar hacia delante en vez de hablar más rápido." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('holding-the-floor', 3,
  'Aterrizar una que se está muriendo',
  $md$Va mal. Lo sientes, la mesa lo siente, y todavía quedan cuarenta segundos de material. Lo que hagas ahora es una habilidad real y a casi nadie se la han enseñado.

**La jugada:** salta al giro, entrega la última línea, y para.

Esa es toda la maniobra. Abandona todo lo que hay entre aquí y el final, di la línea más fuerte que tengas, y termina. Es invisible desde fuera — nadie sabe qué cortaste, y una historia que llega a su final antes de lo esperado sencillamente se lee como una historia corta.

Lo que hace que se sienta imposible es la sensación de que le debes a la mesa la versión que planeaste. No es así. Nadie tiene el itinerario más que tú, y la única persona que va a saber alguna vez que se acortó eres tú.

Luego no hagas las tres cosas que convierten un momento plano ordinario en uno memorable.

**No te disculpes.** *Perdona, esto fue más gracioso en el momento* es la frase que la gente recuerda, y convierte una historia levemente plana en una incomodidad que ahora todos tienen que gestionar.

**No expliques.** Añadir contexto para rescatarla es más material para una historia que ya tenía demasiado, y prolonga precisamente lo que quieres terminar.

**No repitas el final con otras palabras** con la esperanza de una mejor reacción. La reacción es la que es, y volver a pedirla es la versión más incómoda de esto disponible.

Una historia plana es un acontecimiento completamente ordinario que le pasa a todo el mundo varias veces a la semana y se olvida en unos noventa segundos. Lo que no se olvida es a alguien visiblemente herido por una, y la diferencia entre esos dos resultados es enteramente lo que haces en los diez segundos posteriores.

La mejor recuperación es ninguna recuperación: termina, y luego dile algo a otra persona. Seguir adelante con normalidad es lo que hace que no sea nada, y está disponible de inmediato.

Si te quedas con una cosa: salta a la última línea y para. Nadie sabe qué se cortó, y a nadie le importa una historia corta.$md$,
  $j$[
    {
      "situation": "Cuarenta segundos de material que quedan y la mesa se ha ido.",
      "line": "(salta al giro, di la línea, para)",
      "why": "Invisible desde fuera. Nadie tiene el itinerario más que tú, y una historia que llega pronto sencillamente se lee como una historia corta."
    },
    {
      "situation": "No funcionó y quieres decir que fue más gracioso en el momento.",
      "line": "(esa es la frase que la gente recuerda)",
      "why": "Convierte una historia levemente plana en una incomodidad que ahora todos tienen que gestionar."
    },
    {
      "situation": "Ha terminado y el momento está algo flojo.",
      "line": "(dile algo a otra persona)",
      "why": "Seguir adelante con normalidad es lo que hace que no sea nada, y está disponible de inmediato. La mejor recuperación es ninguna recuperación."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué es invisible acortar?",
      "options": [
        { "text": "La gente no está prestando mucha atención.", "correct": false, "note": "Puede que estén prestando toda su atención y aun así no tener ni idea, que es la versión más fuerte del argumento." },
        { "text": "Nadie tiene el itinerario más que tú.", "correct": true, "note": "Una historia que llega a su final antes de lo planeado sencillamente se lee como una historia corta, y la única persona que sabe que se cortó eres tú." },
        { "text": "Las historias son flexibles de todas formas.", "correct": false, "note": "Vago. El motivo es concreto: el plan solo existía en tu cabeza." },
        { "text": "Siempre puedes contar el resto después.", "correct": false, "note": "Puedes y en la mayoría de los casos no lo harás, y eso no es lo que hace que acortar sea seguro." }
      ],
      "explain": "Salta al giro, entrega la última línea, para."
    },
    {
      "prompt": "¿Qué hace de verdad memorable una historia plana?",
      "options": [
        { "text": "Que era larga.", "correct": false, "note": "La duración la empeora en el momento y se olvida tan rápido como el resto." },
        { "text": "Que nadie se rió.", "correct": false, "note": "Le pasa constantemente a todo el mundo y se olvida en unos noventa segundos." },
        { "text": "La disculpa posterior.", "correct": true, "note": "Perdona, esto fue más gracioso en el momento es la parte que la gente recuerda, y convierte un momento ordinario en una incomodidad que la mesa tiene que gestionar." },
        { "text": "Contársela a la gente equivocada.", "correct": false, "note": "Una causa de que la historia se quede plana, no lo que hace que perdure." }
      ],
      "explain": "La mejor recuperación es ninguna recuperación. Termina, y dile algo a otra persona."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "skipped", "label": "Saltó al final", "description": "Cortó el material restante." },
      { "key": "no_apology", "label": "No se disculpó", "description": "Nada de fue más gracioso en el momento." },
      { "key": "no_rescue", "label": "No intentó rescatarla", "description": "Sin contexto extra, sin final repetido." },
      { "key": "moved_on", "label": "Siguió adelante con normalidad", "description": "Le dijo algo a otra persona inmediatamente después." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa",
      "mood": "Educadamente atenta.",
      "openness": 4,
      "personality": "Informa de la sala con honestidad. Cálida ante una historia que sencillamente termina, y visiblemente incómoda si el narrador se disculpa por ella o intenta rescatarla."
    },
    "setting": "Estás a dos tercios de una historia y no está funcionando. Dos personas están mirando a otro lado y queda una buena cantidad.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con normalidad y haz avanzar la conversación si la historia sencillamente termina.",
      "Ponte visiblemente incómoda si el narrador se disculpa, explica o repite el final.",
      "Nunca tranquilices al narrador diciéndole que estuvo bien."
    ],
    "opening_beat": "(una persona se ha girado un poco; otra alguien coge su copa)",
    "success_looks_like": "La persona la aterriza pronto y sigue adelante sin disculparse."
  }$j$::jsonb,
  'Hoy, termina algo pronto en vez de acabarlo como lo planeaste, y no te disculpes. Apunta qué cortaste.',
  $j${}$j$::jsonb
);

select pg_temp.es_lesson('holding-the-floor', 4,
  'Cuándo no contar una',
  $md$Hay momentos en los que una historia es de verdad inadecuada, y poder leerlos es lo que separa a alguien con criterio de alguien con material.

**La jugada:** comprueba qué está haciendo la sala antes de empezar, no después.

Cuatro situaciones en las que la respuesta es no, o todavía no.

**Alguien acaba de decir algo serio.** El reflejo de seguir una confesión difícil con una historia relacionada tiene buena intención — dice *lo entiendo, esto pasa* — y a menudo se lee como cambiar de tema y alejarse de ellos. Pregunta algo en su lugar; la historia puede esperar.

**Dos personas están en mitad de una conversación.** Una historia a toda la mesa corta lo que esas dos estaban construyendo, y van a ser educadas al respecto. Espera al punto de unión.

**La gente se está yendo, está de pie, o está comiendo.** La atención está comprometida en otro sitio y una historia de noventa segundos pide algo que la postura no tiene.

**Alguien acaba de contar una muy buena.** Seguirla de inmediato con la tuya se lee como competir aunque no sea esa la intención, y la reacción a la tuya se va a medir contra la suya. Un compás y un tema distinto lo resuelve por completo.

La disciplina relacionada es no tratar las historias como una moneda. Si alguien cuenta una y tú la superas, y luego ellos superan esa, la mesa está en una competición en vez de en una conversación — y la persona que más a menudo acaba excluida de esa competición es la que necesitaba un momento para pensar en la suya, que probablemente seas tú.

Nada de esto es un motivo para no contar historias. Es la diferencia entre una historia que llega y una que interrumpe, y la comprobación tarda un segundo: ¿en qué está en medio la sala?

Si te quedas con una cosa: pregúntate primero qué está haciendo la sala. La historia se conserva.$md$,
  $j$[
    {
      "situation": "Alguien acaba de decir algo difícil sobre su año.",
      "line": "(pregúntales algo — la historia se conserva)",
      "why": "Seguir una confesión difícil con una historia relacionada dice lo entiendo y se lee como cambiar de tema y alejarse de ellos."
    },
    {
      "situation": "Alguien acaba de contar una historia muy buena.",
      "line": "(un compás, y un tema distinto)",
      "why": "Seguirla de inmediato se lee como competir aunque no lo sea, y la tuya se va a medir contra la suya."
    },
    {
      "situation": "Dos personas están inmersas en algo al otro extremo.",
      "line": "(espera al punto de unión)",
      "why": "Una historia a toda la mesa corta lo que estaban construyendo, y van a ser educadas al respecto."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Alguien acaba de decir algo serio. ¿Qué reflejo hay que resistir?",
      "options": [
        { "text": "Cambiar de tema por completo.", "correct": false, "note": "Obviamente equivocado y no el tentador. La versión tentadora parece empatía." },
        { "text": "Contar una historia relacionada tuya propia.", "correct": true, "note": "Se pretende como lo entiendo, esto pasa — y se lee como quitarles la atención. Pregunta algo en su lugar." },
        { "text": "No decir nada en absoluto.", "correct": false, "note": "El silencio a menudo es correcto aquí, y no es el error del que trata esta lección." },
        { "text": "Ofrecer consejo.", "correct": false, "note": "Un peligro real y distinto, y pertenece a otro tema." }
      ],
      "explain": "La historia se conserva. Casi todas se conservan."
    },
    {
      "prompt": "¿Por qué no seguir una historia muy buena con la tuya?",
      "options": [
        { "text": "La tuya no va a ser tan buena.", "correct": false, "note": "Podría ser mejor, y aun así se mediría contra la suya en vez de escucharse por sí sola." },
        { "text": "Se lee como competir, sea cual sea tu intención.", "correct": true, "note": "Y empieza la competición — que de forma más fiable excluye a la persona que necesitaba un momento para pensar en la suya." },
        { "text": "La mesa ya ha tenido suficiente.", "correct": false, "note": "Una mesa que acaba de disfrutar una historia es la audiencia más receptiva que hay. El momento es la cuestión, no el apetito." },
        { "text": "Es de mala educación con quien la contó.", "correct": false, "note": "Nadie lo experimenta como mala educación. Lo experimentan como el comienzo de una competición." }
      ],
      "explain": "Un compás y un tema distinto lo resuelve por completo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "checked", "label": "Comprobó la sala primero", "description": "Preguntó en qué estaba en medio." },
      { "key": "held_it", "label": "Guardó la historia", "description": "Esperó en vez de insertarla." },
      { "key": "asked_instead", "label": "Preguntó en su lugar", "description": "Siguió algo serio con una pregunta en vez de con una historia." },
      { "key": "no_contest", "label": "No compitió", "description": "Dejó un compás después de la de otra persona." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "la persona que acaba de decir algo difícil",
      "mood": "Expuesta, tras haber dicho más de lo que pretendía.",
      "openness": 4,
      "personality": "Se abre considerablemente si se le pregunta algo, y se queda callada y educada si el tema se mueve a la experiencia de otra persona."
    },
    "setting": "Alguien en la mesa acaba de decir, con bastante cuidado, que su padre no ha estado bien. Tienes una historia sobre tu propio padre que es genuinamente relevante.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Ábrete y di más si se te pregunta algo sobre tu situación.",
      "Quédate callada y educada si la conversación se mueve a la experiencia de otra persona.",
      "Nunca le preguntes a la persona por su propio padre."
    ],
    "opening_beat": "«...bueno. Perdona. Han sido unos meses raros.»",
    "success_looks_like": "La persona pregunta algo en vez de contar su historia."
  }$j$::jsonb,
  'Hoy, guárdate una historia porque la sala estaba haciendo otra cosa. Apunta el momento y qué hiciste en su lugar.',
  $j${
    "says": "...bueno. Perdona. Han sido unos meses raros. (Tienes una historia genuinamente relevante sobre tu propio padre.)",
    "model": {
      "line": "Suena a mucho con lo que cargar. ¿Cómo está ahora?",
      "why": "La historia se conserva. Seguir una confesión difícil con una relacionada tuya propia se pretende como lo entiendo, y se lee como quitarles la atención."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Pregúntales algo" },
      { "kind": "no_first_person", "requirement": "Manténte fuera de esto por ahora" },
      { "kind": "forbids_any", "words": ["mi padre", "lo mismo pasó", "cuando mi", "yo pasé por", "sé exactamente", "nosotros tuvimos eso", "me recuerda a"], "requirement": "No tu historia, por muy relevante que sea" },
      { "kind": "max_words", "n": 25, "requirement": "Corta — la palabra es suya" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('holding-the-floor', 5,
  'Que te interrumpan',
  $md$Llevas veinte segundos y alguien empieza a hablar. Esto pasa constantemente, rara vez es hostil, y lo que hagas con ello decide si vuelves a contar historias en ese grupo.

**La jugada:** termina la frase en la que estás, y luego decide si continuar.

La mayoría de las interrupciones no son tomas de control. Son alguien reaccionando — una interjección, una pregunta, una risa con palabras pegadas — y se espera que la conversación vuelva a ti. Parar en seco en ese punto es lo que hace la gente callada, y convierte una reacción ordinaria en un final, porque la sala lee tu parada como que has terminado.

Así que termina tu frase. Luego, si de verdad han cogido la palabra, tienes una elección, y las dos opciones son legítimas.

**Vuelve a entrar.** *Bueno, abre la puerta* — sin comentar la interrupción, sin reclamar, solo el hilo retomado. Una historia retomada como si nada hubiera pasado no es incómoda, y nadie va a recordar que hubo un hueco.

**Déjala pasar.** Si la conversación de verdad se ha movido y no hay espacio, la historia se conserva. Dejar pasar una no es una derrota y la versión de la que la gente se arrepiente es la que se entrega en un tema que ya ha cambiado.

Lo que no funciona es la versión a medias — irse apagando, esperar a que te inviten a volver, y luego contar el resto con energía reducida. Eso produce exactamente el final plano que temías, y lo causa el ceder, no la interrupción.

Si pasa repetidamente con la misma persona, el arreglo no está en el momento: sigue al mismo volumen, que es la jugada del bloque de reuniones de Trabajo y funciona igual aquí. Mismo principio, sala distinta.

Si te quedas con una cosa: termina tu frase. Es la diferencia entre que te interrumpan y que te terminen.$md$,
  $j$[
    {
      "situation": "Alguien empieza a hablar a los veinte segundos.",
      "line": "(termina la frase en la que estás)",
      "why": "Parar en seco convierte una reacción ordinaria en un final, porque la sala lee tu parada como que has terminado."
    },
    {
      "situation": "Han cogido la palabra de verdad y llevan dos frases.",
      "line": "Bueno — abre la puerta.",
      "why": "El hilo retomado sin comentar la interrupción. Una historia retomada como si nada hubiera pasado no es incómoda."
    },
    {
      "situation": "La conversación se ha movido de verdad.",
      "line": "(la historia se conserva)",
      "why": "Dejar pasar una no es una derrota. La versión de la que la gente se arrepiente es la que se entrega en un tema que ya ha cambiado."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué cuesta tanto parar en seco?",
      "options": [
        { "text": "Muestra que te desanimas con facilidad.", "correct": false, "note": "Una impresión sobre ti, y el coste mecánico es más inmediato que eso." },
        { "text": "La sala lo lee como que has terminado.", "correct": true, "note": "La mayoría de las interrupciones son reacciones, no tomas de control, y parar convierte una interjección ordinaria en un final." },
        { "text": "Pierdes el hilo.", "correct": false, "note": "Normalmente sabes exactamente dónde estabas, que es lo que hace que la parada sea tan frustrante después." },
        { "text": "Los anima a volver a hacerlo.", "correct": false, "note": "Posiblemente con el tiempo, y el coste cae en esta historia, no en la siguiente." }
      ],
      "explain": "Termina tu frase. Esa es la diferencia entre interrumpido y terminado."
    },
    {
      "prompt": "¿Cuál es la versión que no funciona?",
      "options": [
        { "text": "Continuar de inmediato.", "correct": false, "note": "Una de las dos opciones legítimas, y nadie recuerda el hueco." },
        { "text": "Dejar pasar la historia.", "correct": false, "note": "También legítimo. La historia se conserva, y una historia entregada en un tema que ha cambiado es de la que la gente se arrepiente." },
        { "text": "Irse apagando y esperar a que te inviten a volver.", "correct": true, "note": "Y luego contar el resto con energía reducida, que produce exactamente el final plano que temías — causado por el ceder, no por la interrupción." },
        { "text": "Decir que no habías terminado.", "correct": false, "note": "Directo y perfectamente correcto, y es una jugada más fuerte que la que busca esta pregunta." }
      ],
      "explain": "Sigue al mismo volumen — la misma jugada que el bloque de reuniones en Trabajo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "finished_sentence", "label": "Terminó la frase", "description": "No paró en seco." },
      { "key": "decided", "label": "Tomó una decisión", "description": "Volvió a entrar o la dejó pasar, deliberadamente." },
      { "key": "no_trailing", "label": "No se apagó", "description": "Evitó la versión a medias." },
      { "key": "same_volume", "label": "Mismo volumen", "description": "No se volvió más callado ni más alto." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rob",
      "role": "alguien en la mesa que interrumpe sin darse cuenta",
      "mood": "Alegre.",
      "openness": 4,
      "personality": "Entusiasta y con muy buena intención. Para y cede la palabra en el momento en que el narrador sigue, y toma el control por completo si para."
    },
    "setting": "Llevas veinte segundos de historia. Alguien acaba de empezar a hablar por encima de ti con una reacción a la primera parte.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Para y cede la palabra con calidez si el narrador sigue.",
      "Toma el control de la conversación por completo si el narrador para o se apaga.",
      "Nunca los invites a continuar una vez que tienes la palabra."
    ],
    "opening_beat": "«Ah, ese sitio es horrible, fuimos en — perdona, sigue, no, es que es de verdad horrible—»",
    "success_looks_like": "La persona termina la frase y retoma el hilo."
  }$j$::jsonb,
  'Hoy, termina tu frase cuando alguien hable por encima de ti. Apunta qué pasó después.',
  $j${
    "says": "Ah, ese sitio es horrible, fuimos en — perdona, sigue, no, es que es de verdad horrible—",
    "model": {
      "line": "Sí que lo es. Bueno — abre la puerta, y ya está sujetando la caja.",
      "why": "El hilo retomado sin comentar la interrupción y sin reclamar. Una historia retomada como si nada hubiera pasado no es incómoda, y nadie recuerda que hubo un hueco."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["como estaba diciendo", "si me dejas terminar", "me has interrumpido", "por dónde iba", "da igual", "no importa", "olvídalo", "sigue tú"], "requirement": "No comentes la interrupción ni te apagues" },
      { "kind": "min_words", "n": 10, "requirement": "Retoma el hilo" },
      { "kind": "max_words", "n": 35, "requirement": "Directo de vuelta" }
    ]
  }$j$::jsonb
);
