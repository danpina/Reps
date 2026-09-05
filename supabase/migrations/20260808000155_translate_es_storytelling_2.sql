-- Spanish: Storytelling, track 2 — La forma.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Priya" throughout — established feminine exception name.

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

select pg_temp.es_lesson('the-shape', 1,
  'Algo tiene que girar',
  $md$Este es el motor, y es lo que separa una historia de un relato de un día.

Una historia no es una secuencia de hechos. Es un cambio: se esperaba algo y pasó otra cosa, o un plan se topó con la realidad, o algo que era de una forma se volvió de otra. El giro es el momento que da la vuelta, y todo lo anterior existe para prepararlo mientras que todo lo posterior existe para asentarlo.

**La jugada:** encuentra el giro, y construye el relato alrededor de él.

La mayoría de las historias planas tienen uno y no lo han localizado. Pregúntate cuál fue la parte sorprendente — el momento del que le contarías a alguien si solo tuvieras una frase — y ese es el giro. Luego comprueba que todo lo que piensas decir o lo está preparando o lo está cobrando, y corta lo que no haga ninguna de las dos cosas. Esa única prueba elimina la mayor parte de lo que hace largas las historias.

El giro también te dice cómo ritmarlo. Ve más despacio ligeramente al acercarte — un compás antes vale más que cualquier redacción — y no te precipites en la frase en sí, que es lo más común que la gente le hace a su mejor momento.

Dos formas de fallo que merece la pena reconocer. Una historia sin ningún giro, que es la descripción de una tarde, y se cuenta mejor en una frase: *todo fue un caos de principio a fin.* Y una historia con el giro en el sitio equivocado, normalmente demasiado pronto, así que los dos minutos que quedan son anticlímax — si lo sorprendente pasa en la segunda frase, la historia terminó ahí y tú sigues hablando.

Si te quedas con una cosa: nombra el giro antes de empezar, y comprueba que cada frase o lo está preparando o lo está cobrando.$md$,
  $j$[
    {
      "situation": "Estás a punto de contar una historia larga y no sabes por qué se hace pesada.",
      "line": "(¿cuál es el momento que da la vuelta?)",
      "why": "Ese es el giro. Luego corta cualquier cosa que no lo esté preparando ni cobrando, que elimina la mayor parte de lo que hace largas las historias."
    },
    {
      "situation": "La parte sorprendente pasa en tu segunda frase.",
      "line": "(entonces la historia terminó ahí)",
      "why": "Los dos minutos que quedan son anticlímax. El giro en el sitio equivocado es tan malo como no tener ningún giro."
    },
    {
      "situation": "De verdad no hay ningún giro.",
      "line": "Todo fue un caos de principio a fin.",
      "why": "Una frase es la forma honesta de una descripción de una tarde. Contarla como una historia promete un cambio que nunca llega."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué es una historia, estructuralmente?",
      "options": [
        { "text": "Un cambio — se esperaba algo, y pasó otra cosa.", "correct": true, "note": "El giro es el momento en que da la vuelta. Todo lo anterior lo prepara, todo lo posterior lo asienta, y lo que no hace ninguna de las dos cosas puede irse." },
        { "text": "Una secuencia de hechos con un buen final.", "correct": false, "note": "Una secuencia con un final sigue siendo una secuencia, y los finales no pueden rescatar un medio que nadie siguió." },
        { "text": "Algo interesante que te pasó.", "correct": false, "note": "Lo interesante no es estructural. Muchos hechos interesantes no tienen ningún giro y no se pueden contar como historias." },
        { "text": "Un problema y una resolución.", "correct": false, "note": "Cerca, y más estrecho que la cosa real — muchas buenas historias no resuelven nada en absoluto." }
      ],
      "explain": "Nombra el giro antes de empezar. También es la prueba de qué cortar."
    },
    {
      "prompt": "La parte sorprendente llega en la segunda frase. ¿Qué está mal?",
      "options": [
        { "text": "Has revelado el final.", "correct": false, "note": "Un problema distinto. La cuestión no es que lo sepan, es que no queda nada." },
        { "text": "Nada — ponerlo todo delante está bien.", "correct": false, "note": "El marco va delante. El giro es un objeto distinto y no puede vivir también ahí." },
        { "text": "La historia terminó ahí y tú sigues hablando.", "correct": true, "note": "Todo lo posterior a un giro existe para asentarlo, y dos minutos de asentarlo es anticlímax." },
        { "text": "Necesitaba más planteamiento antes.", "correct": false, "note": "Más planteamiento es el problema del principio del bloque anterior. El arreglo es la colocación, no el relleno." }
      ],
      "explain": "Ve más despacio antes del giro, y no te precipites en la frase en sí."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "found_turn", "label": "Encontró el giro", "description": "Nombró el momento en que algo dio la vuelta." },
      { "key": "built_round_it", "label": "Construyó alrededor de él", "description": "Todo lo preparaba o lo pagaba." },
      { "key": "placed", "label": "Lo colocó bien", "description": "Ni en la segunda frase, ni ausente." },
      { "key": "paced", "label": "Lo ritmó", "description": "Fue más despacio antes en vez de precipitarse." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa",
      "mood": "Atenta.",
      "openness": 4,
      "personality": "Reacciona con fuerza ante un giro al que se le da espacio, y con educación ante uno que llega enterrado en mitad de una frase."
    },
    "setting": "Estás a punto de contar una historia sobre una entrevista de trabajo que fue rara. El momento en que gira es cuando el entrevistador pregunta algo sobre tu colegio.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Reacciona como es debido a un giro que está preparado y ritmado.",
      "Responde con suavidad si el momento sorprendente está enterrado o llega de inmediato.",
      "Nunca preguntes cuál era el punto."
    ],
    "opening_beat": "«¿Dijiste que pasó algo raro en la entrevista?»",
    "success_looks_like": "La persona construye hacia el giro y le da espacio."
  }$j$::jsonb,
  'Hoy, coge una historia y nombra su giro en una frase. Apunta el giro y una cosa que cortarías por no servirlo.',
  $j${
    "beats": [
      {
        "situation": "Una historia de dos minutos sobre una entrevista de trabajo. El momento raro — el entrevistador preguntando por tu colegio — llega unos quince segundos después de empezar.",
        "prompt": "¿Qué está mal en eso?",
        "options": [
          { "text": "Nada — llega rápido a la parte buena.", "correct": false, "note": "El marco va delante. El giro es un objeto distinto, y ponerlo ahí deja un minuto y medio de anticlímax." },
          { "text": "La historia terminó a los quince segundos y tú sigues hablando.", "correct": true, "note": "Todo lo posterior a un giro existe para asentarlo. Noventa segundos de asentarlo es una historia que terminó y siguió." },
          { "text": "Necesitabas más planteamiento antes.", "correct": false, "note": "Más planteamiento es el problema del principio del bloque anterior. Esto va sobre la colocación, no sobre el relleno." },
          { "text": "Revela el final.", "correct": false, "note": "Un fallo distinto. La cuestión aquí es qué queda por escuchar, no qué saben." }
        ]
      },
      {
        "situation": "Estás intentando averiguar qué cortar de una historia que se hace pesada.",
        "prompt": "¿Cuál es la prueba?",
        "options": [
          { "text": "Corta cualquier cosa que puedas decir más rápido.", "correct": false, "note": "Compresión, no estructura. Una historia pesada comprimida es una historia pesada más corta." },
          { "text": "Corta cualquier cosa que el oyente pueda inferir.", "correct": false, "note": "Razonable y es una regla sobre el detalle, no una regla sobre la forma." },
          { "text": "Corta cualquier cosa que ni prepare el giro ni lo pague.", "correct": true, "note": "Esa única prueba elimina la mayor parte de lo que hace largas las historias, y se puede aplicar antes de hablar." },
          { "text": "Corta cualquier cosa sobre otra gente.", "correct": false, "note": "El tamaño del reparto importa y es una lección aparte. Mucho material esencial es sobre otra gente." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-shape', 2,
  'Termina en la línea',
  $md$La mayoría de las historias se cuentan lo bastante bien y luego se sigue hablando más allá del final, y los últimos veinte segundos deshacen una cantidad sorprendente de los primeros noventa.

**La jugada:** para en el momento más fuerte, que casi siempre es antes de lo que dice el instinto.

Lo que la gente añade después de la última buena línea siempre es una de tres cosas.

**La explicación.** *Bueno, básicamente había pensado que era otra persona todo el rato.* Si la historia funcionó, ya lo habían pillado. Decirlo convierte algo que disfrutaron averiguando en algo que se les contó.

**La evaluación.** *Fue graciosísimo en el momento.* Esta es la peor de las tres, porque le pide a la mesa un veredicto al que acabas de decirles que llegaran, y se lee como alguien comprobando si funcionó.

**La coda.** *Bueno, por eso llegué tarde.* Un regreso ordenado a donde empezó la historia, que se siente como oficio y es desinflar — la energía está en el giro, y cada frase después de él es cuesta abajo.

El mecanismo debajo de las tres es el mismo: el silencio después de una historia se siente como un juicio, así que la gente lo llena. No lo es. Es un compás, y el compás es donde una historia aterriza — una sala necesita un segundo para reaccionar, y hablar durante ese segundo le quita la reacción.

En la práctica, esta es la misma instrucción que *conoce tu última línea* de la siguiente lección: conoce la última línea antes de empezar. Si sabes adónde vas, puedes parar ahí. Si no lo sabes, la vas a pasar, vas a sentir que la pasas, y vas a empezar a añadir.

Si alguien quiere más, va a preguntar, y que te hagan una pregunta es un final mucho mejor que cualquier frase que pudieras haber añadido.

Si te quedas con una cosa: la línea más fuerte es la última línea. Dila y deja que el silencio sea un compás en vez de un problema.$md$,
  $j$[
    {
      "situation": "Has entregado la mejor línea y hay un compás.",
      "line": "(ese compás es el aterrizaje)",
      "why": "Una sala necesita un segundo para reaccionar, y hablar durante ese segundo le quita la reacción."
    },
    {
      "situation": "Estás a punto de explicar qué había estado pasando de verdad.",
      "line": "(si funcionó, ya lo habían pillado)",
      "why": "Convierte algo que disfrutaron averiguando en algo que se les contó."
    },
    {
      "situation": "Quieres decir que fue más gracioso en el momento.",
      "line": "(eso pide un veredicto)",
      "why": "Se lee como alguien comprobando si funcionó, y es la versión que hace que un buen final se sienta incierto."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué la gente sigue hablando más allá del final?",
      "options": [
        { "text": "No saben que la historia ha terminado.", "correct": false, "note": "Normalmente sí sienten que la pasan, que es lo que hace que las adiciones sean tan notables para el narrador después." },
        { "text": "Quieren que se les entienda por completo.", "correct": false, "note": "Eso produce específicamente la explicación, que es una de las tres en vez de la causa de todas ellas." },
        { "text": "Tienen más que decir.", "correct": false, "note": "Casi nunca — es la misma historia repetida, evaluada, u ordenada." },
        { "text": "El silencio se siente como un juicio.", "correct": true, "note": "Así que lo llenan. Es un compás en vez de un veredicto, y el compás es donde una historia aterriza." }
      ],
      "explain": "Conoce la última línea antes de empezar, y podrás parar ahí."
    },
    {
      "prompt": "¿Qué adición cuesta más?",
      "options": [
        { "text": "La explicación.", "correct": false, "note": "Costosa, y sobre todo hace que una buena historia sea algo más plana en vez de incierta." },
        { "text": "La coda que vuelve al principio.", "correct": false, "note": "Desinfla, y se siente como oficio, que es por lo que sobrevive — pero no deshace el aterrizaje." },
        { "text": "La evaluación.", "correct": true, "note": "Fue graciosísimo en el momento le pide a la mesa un veredicto al que acabas de decirles que llegaran, y se lee como comprobar si funcionó." },
        { "text": "Cualquiera de las tres por igual.", "correct": false, "note": "No son iguales. Una de ellas cambia cómo se recibe toda la historia." }
      ],
      "explain": "Y si alguien quiere más, que te pregunten es un final mejor que cualquier cosa que pudieras añadir."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "stopped", "label": "Paró en la línea", "description": "Terminó en el momento más fuerte." },
      { "key": "no_explanation", "label": "No lo explicó", "description": "Los dejó con haberlo pillado." },
      { "key": "no_evaluation", "label": "No lo evaluó", "description": "Nada de fue más gracioso en el momento." },
      { "key": "let_it_land", "label": "Dejó que el compás se asentara", "description": "No habló durante el segundo posterior." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa",
      "mood": "Disfrutándolo.",
      "openness": 4,
      "personality": "Reacciona un compás después de una buena línea si se le da el compás, y no reacciona en absoluto si el narrador habla durante él."
    },
    "setting": "Acabas de entregar la mejor línea de la historia. Nadie ha dicho nada todavía — ha pasado un segundo y medio.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Reacciona con calidez un compás después de una línea si se deja el silencio en paz.",
      "Da una respuesta pequeña y plana si el narrador explica, evalúa o añade una coda.",
      "Nunca llenes tú el silencio de inmediato."
    ],
    "opening_beat": "(un compás — nadie ha hablado todavía)",
    "success_looks_like": "La persona no dice nada y deja que el final aterrice."
  }$j$::jsonb,
  'Hoy, termina una historia en su línea más fuerte y no digas nada después. Apunta qué no añadiste.',
  $j${
    "says": "(acabas de entregar la mejor línea de la historia — un compás, y nadie ha hablado todavía)",
    "model": {
      "line": "(nada)",
      "why": "El compás es donde una historia aterriza. Una sala necesita un segundo para reaccionar, y cada frase añadida en ese segundo — la explicación, la evaluación, el regreso ordenado al principio — le quita la reacción."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["bueno, básicamente", "fue graciosísimo", "tenías que haber estado allí", "bueno, por eso", "por eso", "lo que había pasado era", "supongo", "tiene sentido"], "requirement": "Nada de explicar, evaluar u ordenar" },
      { "kind": "max_words", "n": 6, "requirement": "No digas nada, o casi nada" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-shape', 3,
  'Corta la exactitud',
  $md$*Era martes — no, espera, miércoles, porque tenía el dentista el martes.*

A nadie en la mesa le importa qué día era, nadie está comprobando, y acabas de gastar cuatro segundos y todo tu impulso en un hecho que no hace ningún trabajo.

**La jugada:** sé aproximadamente exacto y rápido en vez de exactamente exacto y lento.

Esta es la instrucción más difícil del tema para cierto tipo de persona cuidadosa y honesta, y merece una respuesta como es debido en vez de una instrucción de relajarse. El impulso no es pedantería, es integridad — no quieres decir algo falso. Pero la precisión tiene un coste que paga el oyente, y las dos cosas están genuinamente en tensión, así que merece la pena saber qué detalles son estructurales.

Un detalle es estructural si la historia cambia cuando él cambia. Si era su hermano y no su amigo y por eso importaba, di hermano. Si el momento exacto es la gracia, el momento exacto es exacto. Todo lo demás — días, edades exactas, la carretera por la que ibas, si eran cuatro o cinco — puede ser aproximado, y aproximarlo no es una mentira, es una historia contada a velocidad de conversación.

La autocorrección es el hábito concreto que hay que perder. Cuesta una pausa, rompe el ritmo, llama la atención sobre algo irrelevante, y señala que no estás seguro del material. Di martes, equivócate, sigue. Si alguien que estaba allí te corrige, eso es una interrupción agradable en vez de una vergüenza.

Lo mismo se aplica a las coletillas: *creo*, *más o menos*, *como que*, *quizás alrededor de*. Una o dos son habla natural. Una historia densa de ellas se lee como insegura y, peor aún, como incierta de sus propios hechos — y un oyente que sospecha que el narrador no se lo cree del todo deja de invertir en ella.

Si te quedas con una cosa: solo los detalles estructurales necesitan ser exactos. Todo lo demás tiene permiso para ser aproximadamente cierto a velocidad.$md$,
  $j$[
    {
      "situation": "No te acuerdas de si era martes o miércoles.",
      "line": "(di martes y sigue)",
      "why": "Nadie está comprobando, y la corrección cuesta una pausa, el ritmo, y la impresión de que estás seguro de tu propia historia."
    },
    {
      "situation": "El detalle es la razón por la que importaba.",
      "line": "(entonces sé exacto)",
      "why": "Un detalle es estructural si la historia cambia cuando él cambia. Esos merecen la precisión."
    },
    {
      "situation": "Tu historia tiene seis creo y cuatro más o menos en ella.",
      "line": "(eso se lee como que ni tú mismo te lo crees)",
      "why": "Un oyente que sospecha que el narrador no está seguro de los hechos deja de invertir en ellos."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hace que merezca la pena ser exacto sobre un detalle?",
      "options": [
        { "text": "Si puedes recordarlo con claridad.", "correct": false, "note": "Tu confianza sobre un hecho no tiene relación con si la historia lo necesita." },
        { "text": "Si la historia cambia cuando él cambia.", "correct": true, "note": "Si hermano en vez de amigo es por lo que importaba, di hermano. Si el momento exacto es la gracia, el momento exacto es exacto. Todo lo demás puede ser aproximado." },
        { "text": "Si alguien presente podría saberlo.", "correct": false, "note": "Que te corrija alguien que estaba allí es una interrupción agradable, no un peligro que hay que evitar diseñando." },
        { "text": "Si es un hecho sobre una persona.", "correct": false, "note": "Muchos hechos sobre personas son irrelevantes, y muchos detalles estructurales son sobre objetos o momentos." }
      ],
      "explain": "Aproximadamente exacto y rápido gana a exactamente exacto y lento."
    },
    {
      "prompt": "¿Qué cuesta de verdad la autocorrección?",
      "options": [
        { "text": "Muy poco — es un segundo.", "correct": false, "note": "Cuesta la pausa, el ritmo, la atención de la mesa, y la impresión de que estás seguro de tu material." },
        { "text": "Te hace parecer honesto.", "correct": false, "note": "La honestidad nunca estuvo en cuestión, y nadie ha sospechado nunca que una historia fuera falsa porque un día estuviera equivocado." },
        { "text": "Señala que no estás seguro del material.", "correct": true, "note": "Y llama la atención sobre un hecho irrelevante justo en el momento en que la atención estaba haciendo algo útil en otro sitio." },
        { "text": "Confunde a la gente.", "correct": false, "note": "Rara vez confunde a nadie. El daño es al ritmo, no a la comprensión." }
      ],
      "explain": "Esto es lo más difícil para la gente cuidadosa y honesta, y la tensión es real — de ahí lo estructural como prueba."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "approximate", "label": "Fue aproximadamente exacto", "description": "No paró por una precisión irrelevante." },
      { "key": "load_bearing", "label": "Fue exacto donde importaba", "description": "Mantuvo los detalles de los que depende la historia." },
      { "key": "no_correcting", "label": "No se corrigió a sí mismo", "description": "Dejó pasar un pequeño error." },
      { "key": "few_hedges", "label": "Pocas coletillas", "description": "No denso de creo y más o menos." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa",
      "mood": "Disfrutando la historia.",
      "openness": 4,
      "personality": "Completamente desinteresada en fechas y edades, y pierde visiblemente el hilo cada vez que el narrador para a corregir una."
    },
    "setting": "Estás contando una historia y de verdad no te acuerdas de si era martes o miércoles, o si el hombre tenía cincuenta o sesenta y tantos años.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Acepta cualquier respuesta aproximada sin comentarios y quédate en la historia.",
      "Pierde el hilo visiblemente si el narrador para a corregir una fecha o una edad.",
      "Nunca pidas un detalle preciso."
    ],
    "opening_beat": "«¿Y esto fue en el fin de semana?»",
    "success_looks_like": "La persona responde de forma aproximada y sigue adelante."
  }$j$::jsonb,
  'Hoy, cuenta una historia sin corregir ni un solo detalle. Apunta la corrección que no hiciste.',
  $j${
    "says": "¿Y esto fue en el fin de semana?",
    "model": {
      "line": "El sábado, creo — bueno, abre la puerta y ya está sujetando la caja.",
      "why": "Aproximadamente exacto y rápido. El día no es estructural, nadie está comprobando, y parar a establecerlo costaría la pausa, el ritmo y la impresión de que estás seguro de tu propia historia."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["no espera", "espera", "en realidad era", "o era", "déjame pensar", "no perdona", "miento", "pensándolo bien"], "requirement": "No pares para que quede exacto" },
      { "kind": "min_words", "n": 10, "requirement": "Responde y sigue adelante" },
      { "kind": "max_words", "n": 35, "requirement": "No pares por ello" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-shape', 4,
  'Una historia, no tres',
  $md$Empiezas a contar una historia. A mitad, te recuerda a otra, que empiezas a explicar porque hace más graciosa esta. Esa necesita algo de contexto sobre una persona que la mesa no ha conocido. Cuatro minutos después, nadie, ni tú incluido, podría decir de qué trataba la historia original.

**La jugada:** una historia a la vez, y nada de anidar.

Ramificarse no es un problema de disciplina. Pasa porque todo está de verdad conectado en tu memoria: la segunda historia de verdad es relevante, y a la persona de verdad hace falta presentarla para que funcione el chiste. Lo que falta es que el oyente no tiene ninguna de esas conexiones y está sosteniendo una historia sin resolver mientras tú construyes una segunda encima.

Dos reglas cubren casi todo.

**Nada de anidar.** Si una historia necesita otra historia para tener sentido, cuenta la otra primero, por separado, o corta la parte que la necesita. Cualquier cosa que empiece con *y esto es lo de Michael* es una segunda historia llegando antes de que haya terminado la primera.

**Nada de personajes nuevos en pleno vuelo.** Cada persona presentada le cuesta algo al oyente. Dos es cómodo, tres es trabajo, y un cuarto llegando en el minuto dos es donde la gente deja de seguir quién es quién — momento en el que ya no están siguiendo una historia, están gestionando una lista de reparto.

Cuando te des cuenta de que te has ramificado, no des marcha atrás con una disculpa. *Bueno* es una reparación completa — dilo, y vuelve al hilo principal. A nadie le importa una digresión que termina; lo que le importa a la gente es una digresión que en silencio se convierte en la historia mientras la primera se queda abierta.

Y la versión que merece la pena atrapar antes de empezar: si necesita tres personajes y un poco de historia para funcionar, es una buena historia para gente que ya los conoce y no para esta mesa. Elegir no contarla ahí no es un fracaso, es elegir bien a quién se la cuentas.

Si te quedas con una cosa: termina la historia que empezaste. Una segunda que llega en pleno vuelo es donde se pierden las dos.$md$,
  $j$[
    {
      "situation": "A mitad, te recuerda a una historia mejor.",
      "line": "(termina esta primero)",
      "why": "Están sosteniendo una historia sin resolver mientras construyes una segunda encima. Las dos se pierden."
    },
    {
      "situation": "Estás a punto de decir y esto es lo de Michael.",
      "line": "(esa es una segunda historia llegando pronto)",
      "why": "Cualquier cosa que necesite otra historia para tener sentido debería contarse primero, por separado, o cortarse."
    },
    {
      "situation": "Te has ramificado y te has dado cuenta.",
      "line": "Bueno.",
      "why": "A nadie le importa una digresión que termina — le importa una que en silencio se convierte en la historia."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué le pasa la ramificación a la gente cuidadosa?",
      "options": [
        { "text": "Todo está de verdad conectado en su memoria.", "correct": true, "note": "La segunda historia de verdad es relevante y a la persona de verdad hace falta presentarla. El oyente no tiene ninguna de esas conexiones y mientras tanto está sosteniendo una historia abierta." },
        { "text": "Pierden su hilo.", "correct": false, "note": "Normalmente lo sostienen perfectamente. El problema está del lado del oyente, no del narrador." },
        { "text": "Están intentando hacerla más graciosa.", "correct": false, "note": "A menudo es la intención, y el motivo por el que se siente necesaria es la memoria, no la ambición." },
        { "text": "Hablan demasiado.", "correct": false, "note": "Pasa igual de a menudo con gente que dice muy poco, en su única historia de la noche." }
      ],
      "explain": "Una historia a la vez, y nada de anidar."
    },
    {
      "prompt": "¿Cuánta gente puede llevar una historia de conversación?",
      "options": [
        { "text": "Todos los que necesite, si los describes bien.", "correct": false, "note": "Describirlos cuesta más que presentarlos, y la descripción es el problema del principio en otra forma." },
        { "text": "Una — cualquier otra cosa es una historia distinta.", "correct": false, "note": "Demasiado estricto. La mayoría de las buenas historias tienen al menos dos personas." },
        { "text": "Depende de si los conocen.", "correct": false, "note": "Ayuda, y hasta con gente conocida un cuarto nombre en pleno vuelo cuesta seguimiento." },
        { "text": "Dos cómodamente; tres es trabajo.", "correct": true, "note": "Un cuarto llegando en el minuto dos es donde la gente deja de seguir quién es quién, y empieza a gestionar una lista de reparto en vez de seguir una historia." }
      ],
      "explain": "Si necesita tres personajes y una historia, es una historia para gente que ya los conoce."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_story", "label": "Contó una historia", "description": "No empezó una segunda dentro de ella." },
      { "key": "few_people", "label": "Mantuvo el reparto pequeño", "description": "Dos o tres personas como mucho." },
      { "key": "repaired", "label": "Reparó con limpieza", "description": "Dijo bueno y volvió al hilo." },
      { "key": "cast_it", "label": "Eligió la historia correcta para la sala", "description": "No contó una que necesitara historia que no tenían." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa que no conoce a ninguna de estas personas",
      "mood": "Dispuesta.",
      "openness": 4,
      "personality": "Sigue un hilo con facilidad y pierde visiblemente el rastro en el momento en que una segunda persona o historia se presenta en pleno vuelo."
    },
    "setting": "Estás contando una historia sobre una entrega. De verdad se conecta a una historia mucho mejor sobre tu vecino, que necesita saber sobre el hermano del vecino.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Sigue con facilidad mientras haya un hilo y dos personas.",
      "Piérdete visiblemente y pregunta quién es alguien cuando llegue una segunda historia o un tercer nombre.",
      "Nunca preguntes por el vecino."
    ],
    "opening_beat": "«¿Qué pasó con la entrega?»",
    "success_looks_like": "La persona termina la historia de la entrega sin anidar la del vecino dentro."
  }$j$::jsonb,
  'Hoy, cuenta una historia sin dejar entrar una segunda. Apunta la que no contaste.',
  $j${
    "beats": [
      {
        "situation": "A mitad de la historia de la entrega, te recuerda a una mucho mejor sobre tu vecino — que necesita que expliques primero el hermano del vecino.",
        "prompt": "¿Qué haces?",
        "options": [
          { "text": "Cuenta la del vecino — es mejor.", "correct": false, "note": "Están sosteniendo una historia sin resolver mientras construyes una segunda encima, y al final nadie podría decir de qué trataba la primera." },
          { "text": "Explica rápido lo del hermano, y luego sigue.", "correct": false, "note": "Un tercer nombre llegando en pleno vuelo es donde la gente deja de seguir quién es quién y empieza a gestionar una lista de reparto." },
          { "text": "Termina la historia de la entrega.", "correct": true, "note": "Una historia a la vez. Si la otra necesita contarse, se puede contar después, por su cuenta, con su propio marco." },
          { "text": "Menciónala brevemente para que sepan que hay más.", "correct": false, "note": "Un avance de una segunda historia sigue siendo una segunda historia, y abre un bucle que la primera ahora tiene que cerrar." }
        ]
      },
      {
        "situation": "Ya te has ramificado y llevas dos frases con lo del vecino.",
        "prompt": "¿Cómo lo reparas?",
        "options": [
          { "text": "Perdona — me he ido por las ramas, ignora todo eso.", "correct": false, "note": "Una disculpa convierte la digresión en un acontecimiento. A nadie le importaba hasta que se anunció." },
          { "text": "Bueno. Abre la puerta —", "correct": true, "note": "Una reparación completa en una palabra. A la gente no le importa una digresión que termina; le importa una que en silencio se convierte en la historia." },
          { "text": "Termina la historia del vecino, y luego vuelve.", "correct": false, "note": "Ahora hay dos historias abiertas y una promesa de volver, que es más seguimiento del que hará una mesa." },
          { "text": "Pregunta si prefieren oír sobre el vecino en su lugar.", "correct": false, "note": "Le entrega a la mesa una decisión para la que no tiene base, y abandona la historia que ya estaban siguiendo." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-shape', 5,
  'Cuatro decisiones antes de hablar',
  $md$Todo en estos dos bloques se reduce a cuatro decisiones, todas tomadas antes de abrir la boca y todas juntas tardan unos diez segundos.

**La jugada:** marco, inicio, giro, final. Decide esas cosas, y luego cuéntala.

**El marco.** Una línea que dice por qué merece la pena escuchar esto. *Me ha pasado la cosa más ridícula en el taller.*

**Dónde empezar.** El momento en que las cosas empiezan a salir mal, no el principio del día.

**El giro.** La cosa que da la vuelta — y la comprobación de que cada frase o lo prepara o lo cobra.

**La última línea.** Conócela antes de empezar, para poder dirigirte hacia ella y parar ahí.

Diez segundos es de verdad todo lo que hace falta una vez que las cuatro son familiares, y son la diferencia entre una historia que funciona y los mismos hechos consiguiendo un *ah, vale*. Merece la pena notar que ninguna de las cuatro va sobre actuación. No hay nada ahí sobre ser gracioso, tener confianza, o tener una buena voz — que es por lo que esto se puede aprender precisamente por la persona que supone que no.

Dos cosas que se siguen de haberlo hecho. La historia se hace mucho más corta, porque el planteamiento ha desaparecido y las digresiones no tienen dónde engancharse. Y se hace más fácil de contar, porque te diriges hacia un punto conocido en vez de improvisar hacia uno desconocido — la mayor parte de la ansiedad al contar una historia es no saber dónde termina.

Aplícalo a las historias que ya cuentas. Todo el mundo tiene cuatro o cinco a las que vuelve, y son las que merece la pena moldear, porque la mejora es permanente y la vas a usar docenas de veces. Coge una, haz las cuatro decisiones sobre ella de forma deliberada, y va a ser una historia distinta el resto de tu vida.

Si te quedas con una cosa: marco, inicio, giro, final. Diez segundos de decidir, y nada de ello es actuación.$md$,
  $j$[
    {
      "situation": "Estás a punto de contar una de tus historias habituales.",
      "line": "(marco, inicio, giro, final — diez segundos)",
      "why": "Cuatro decisiones, todas tomadas antes de hablar, y ninguna de ellas sobre ser gracioso o tener confianza."
    },
    {
      "situation": "Tienes cuatro historias que cuentas habitualmente.",
      "line": "(moldea esas — la mejora es permanente)",
      "why": "La vas a usar docenas de veces. Un pase deliberado la convierte en una historia distinta el resto de tu vida."
    },
    {
      "situation": "Te sientes ansioso por contar una.",
      "line": "(la mayor parte de eso es no saber dónde termina)",
      "why": "Dirigirse hacia una última línea conocida es considerablemente más fácil que improvisar hacia una desconocida."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué tiene de notable las cuatro decisiones?",
      "options": [
        { "text": "Son rápidas.", "correct": false, "note": "Cierto, y la rapidez no es la propiedad interesante." },
        { "text": "Ninguna de ellas es actuación.", "correct": true, "note": "Nada sobre ser gracioso, tener confianza, o tener una buena voz — que es por lo que se puede aprender precisamente por la persona que supone que no." },
        { "text": "Funcionan para cualquier historia.", "correct": false, "note": "En general cierto, y no es lo que hace que merezca la pena aprenderlas." },
        { "text": "Es lo que hacen de forma natural los buenos narradores.", "correct": false, "note": "Muchos lo hacen, y describirlas como naturales es lo que hace que la gente crea que no se puede adquirir." }
      ],
      "explain": "Marco, inicio, giro, final. Diez segundos de decidir."
    },
    {
      "prompt": "¿Qué historias merece la pena moldear de forma deliberada?",
      "options": [
        { "text": "Las cuatro o cinco que ya cuentas habitualmente.", "correct": true, "note": "La mejora es permanente y la vas a usar docenas de veces, que hace que un pase deliberado sea un valor inusualmente bueno." },
        { "text": "Las nuevas, según pasan.", "correct": false, "note": "Útil, y cada una se cuenta una o dos veces. El retorno es mucho menor." },
        { "text": "Las más impresionantes.", "correct": false, "note": "Lo impresionante no es la variable, y las historias mejor moldeadas a menudo son sobre hechos muy pequeños." },
        { "text": "Las que han ido mal.", "correct": false, "note": "Merece la pena diagnosticarlas y es un conjunto más pequeño que las que repites." }
      ],
      "explain": "También las hace más cortas y más fáciles de contar, porque te diriges hacia un punto conocido."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "framed", "label": "Decidió el marco", "description": "Sabía la primera línea." },
      { "key": "start", "label": "Decidió dónde empezar", "description": "Eligió el momento en que sale mal." },
      { "key": "turn", "label": "Nombró el giro", "description": "Sabía qué da la vuelta." },
      { "key": "last_line", "label": "Sabía la última línea", "description": "Decidió dónde termina antes de empezar." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa",
      "mood": "Atenta.",
      "openness": 4,
      "personality": "Responde notablemente mejor a un relato moldeado y es honesta sobre adónde se fue la atención en uno sin moldear."
    },
    "setting": "Una de tus historias habituales, a punto de contarse otra vez — esta vez con las cuatro decisiones tomadas primero.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Reacciona por completo a una historia que está enmarcada, empieza tarde, y termina en su línea.",
      "Responde con suavidad donde falte alguna de las cuatro decisiones.",
      "Nunca nombres tú las cuatro decisiones."
    ],
    "opening_beat": "«Cuéntales la del taller.»",
    "success_looks_like": "La persona la enmarca, empieza tarde, construye hacia el giro y para en la línea."
  }$j$::jsonb,
  'Hoy, coge una historia que cuentas habitualmente y toma las cuatro decisiones sobre ella. Apunta las cuatro.',
  $j${
    "says": "Cuéntales la del taller.",
    "model": {
      "line": "Vale — me ha pasado la cosa más ridícula en el taller. Bueno, sale el mecánico, mira el coche cuatro segundos, y dice: ¿de quién es esto?",
      "why": "Marco, y luego directo al momento en que pasa algo. Dos de las cuatro decisiones visibles en un aliento, y nada de planteamiento, de coletilla o de día de la semana."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["no es muy interesante", "tenías que haber estado allí", "perdona", "bueno, básicamente", "era martes", "había ido a", "déjame pensar", "por dónde empiezo"], "requirement": "Nada de coletilla, planteamiento, u orientación" },
      { "kind": "min_words", "n": 15, "requirement": "Enmárcala y empiézala" },
      { "kind": "max_words", "n": 45, "requirement": "A dos frases de empezar ya ha pasado algo" }
    ]
  }$j$::jsonb
);
