-- Spanish: Escribir prompts a la IA, track 4 — Ensáyalo primero.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Elena" throughout — unambiguously feminine name, feminine
-- agreement (consistent with Priya/Nadine/Nadia exception).

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

select pg_temp.es_lesson('rehearse-it-first', 1,
  'Describe a la persona real',
  $md$Ensayar en tu cabeza no funciona, y el motivo es concreto: ensayas la versión en la que responden bien. Dices tu línea, se lo toman con razonabilidad, y has practicado una conversación que no es la que te preocupa.

Entregárselo no arregla eso por sí solo. *¿Cómo le pido a mi jefa más responsabilidad?* te consigue consejos sobre jefes, que es una categoría, y no vas a tener una conversación con una categoría el martes.

**La jugada:** describe a la persona, no el puesto.

Qué les importa. Bajo qué presión están en este momento. Cómo se resisten — se quedan callados, piden números, están de acuerdo y luego no actúan, se enfrían un poco. Qué dijeron la última vez que salió esto. Qué han rechazado ya. Si les caes bien, hasta donde puedas saber.

Cuatro o cinco frases de eso cambian el resultado por completo, porque lo útil no es el consejo general — es la frase que de verdad van a decir, para que puedas oírla antes del martes en vez de durante.

Incluye las partes incómodas, y esta es la parte que la gente omite. Si ya lo has planteado dos veces, dilo. Si lo manejaste mal la última vez, di cómo. Si parte de su objeción es justa, ponla también. Una versión de la situación editada para que quedes razonable produce un ensayo contra alguien que no existe, y de todos modos te vas a encontrar con el real.

Di también qué quieres, y sé específico al respecto. *Quiero salir de esto con un sí para liderar el proyecto de migración, o un motivo claro de por qué no.* Un ensayo sin objetivo es una conversación sobre el tema, y esas dan vueltas en círculos aquí exactamente igual que en la vida real.

Una advertencia que el bloque de después del siguiente amplía: la descripción que das es la descripción con la que trabaja, y no va a cuestionar tu versión. Si los describes como irrazonables, estás ensayando contra alguien irrazonable. Merece la pena comprobarlo escribiendo el mismo resumen desde su lado.

Si te quedas con una cosa: describe a la persona, incluyendo las partes que no te favorecen. Un puesto te consigue consejos sobre un puesto.$md$,
  $j$[
    {
      "situation": "Estás a punto de preguntar sobre tu jefa.",
      "line": "Se queda callada cuando no está de acuerdo y pide números un día después.",
      "why": "Cómo se resiste alguien es la parte útil. Un puesto te consigue consejos sobre un puesto."
    },
    {
      "situation": "Ya lo has planteado dos veces antes y salió mal.",
      "line": "Lo he preguntado dos veces. La segunda vez me puse a la defensiva.",
      "why": "Una versión editada produce un ensayo contra alguien que no existe, y de todos modos te encuentras con el real."
    },
    {
      "situation": "No has dicho qué quieres sacar de esto.",
      "line": "Un sí para liderar la migración, o un motivo claro de por qué no.",
      "why": "Un ensayo sin objetivo da vueltas en círculos, aquí exactamente igual que en la vida."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué falla ensayar en tu cabeza?",
      "options": [
        { "text": "Se te olvidan las líneas bajo presión.", "correct": false, "note": "Pasa, y sería igual de cierto de un buen ensayo." },
        { "text": "Ensayas la versión en la que responden bien.", "correct": true, "note": "Dices tu línea, se lo toman con razonabilidad, y has practicado la conversación que no te preocupaba." },
        { "text": "No es lo bastante detallado.", "correct": false, "note": "Los ensayos mentales suelen ser extremadamente detallados — sobre la conversación equivocada." },
        { "text": "Lo haces demasiadas veces.", "correct": false, "note": "La repetición no es el fallo. Lo que se repite sí lo es." }
      ],
      "explain": "Describe a la persona, no el puesto."
    },
    {
      "prompt": "¿Qué detalle se omite con más frecuencia?",
      "options": [
        { "text": "Qué les importa.", "correct": false, "note": "La gente normalmente aporta esto — es la parte que se siente como el resumen." },
        { "text": "Cuánto tiempo lleváis trabajando juntos.", "correct": false, "note": "Fácil de decir y es lo que menos cambia el consejo." },
        { "text": "La parte donde lo manejaste mal.", "correct": true, "note": "Una situación editada para que quedes razonable produce un ensayo contra alguien que no existe." },
        { "text": "Qué quieres sacar de esto.", "correct": false, "note": "Frecuentemente ausente y merece la pena nombrarlo — y se omite por descuido más que por incomodidad." }
      ],
      "explain": "Y compruébalo escribiendo el mismo resumen desde su lado."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "person", "label": "Describió a una persona", "description": "No un puesto o un cargo." },
      { "key": "pushback", "label": "Dijo cómo se resisten", "description": "Callados, números, frialdad, aceptan y se paralizan." },
      { "key": "unflattering", "label": "Incluyó las partes incómodas", "description": "Intentos previos, errores propios." },
      { "key": "target", "label": "Nombró qué quiere", "description": "Un resultado específico, no un tema." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Elena",
      "role": "una amiga que conoce un poco tu trabajo",
      "mood": "Directa.",
      "openness": 5,
      "personality": "Pregunta cómo es la persona de verdad y nota cuándo el relato te favorece."
    },
    "setting": "Una conversación que has estado evitando va a pasar el martes, y esta noche has empezado a prepararte.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta cómo se resiste la persona.",
      "Pregunta qué pasó las veces anteriores.",
      "Nunca ofrezcas consejos sobre la conversación."
    ],
    "opening_beat": "«¿Cómo es ella de verdad cuando no está de acuerdo contigo?»",
    "success_looks_like": "La persona describe al individuo de forma concreta, incluyendo lo que no fue bien antes."
  }$j$::jsonb,
  'Hoy, escribe cuatro frases describiendo a la persona antes de la conversación. Apunta las que no te favorecen.',
  $j${
    "says": "¿Cómo es ella de verdad cuando no está de acuerdo contigo?",
    "model": {
      "line": "Se queda callada, y luego pide números al día siguiente. He planteado esto dos veces y me puse a la defensiva la segunda.",
      "why": "Cómo se resiste alguien es la parte útil, y el relato que no te favorece es el que produce un ensayo contra la persona real."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["jefa típica", "los jefes normalmente", "es una jefa", "en general", "la mayoría de los jefes", "gente como ella"], "requirement": "No describas un puesto" },
      { "kind": "min_words", "n": 12, "requirement": "Describe cómo se resisten" },
      { "kind": "max_words", "n": 45, "requirement": "Cuatro frases como máximo" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('rehearse-it-first', 2,
  'Pide la versión difícil',
  $md$Dejado a su aire, interpreta a alguien razonable. Te escuchan, ceden en tus buenos puntos, y llegan a un compromiso viable hacia el cuarto intercambio.

La gente razonable nunca fue el problema. No perdiste el sueño por la versión en la que dicen *ese es un buen punto, déjame pensarlo*.

**La jugada:** pídele que haga el ensayo más difícil que el día real.

*Interprétalos escépticos y con poco tiempo. No me lo pongas fácil. No cedas nada a menos que haya respondido de verdad a la objeción.*

Esa última cláusula es la que más importa, porque el modo de fallo es sutil: va a aceptar una respuesta débil con educación, y un ensayo donde tus respuestas débiles cuelan es peor que ninguno — sales habiendo confirmado algo falso.

Tres dificultades que merece la pena pedir por separado, ya que fallan de forma distinta.

**El que interrumpe.** Te corta en la tercera frase. Esto comprueba si el punto sobrevive a ser comprimido, que es lo que realmente pasa en las salas.

**El que está de acuerdo y no hace nada.** *Sí, claro, vamos a mirar eso.* Mucho más difícil que el desacuerdo abierto, porque no hay nada contra lo que empujar, y así es como mueren la mayoría de las peticiones laborales.

**El que lo hace personal.** *Me sorprende que pienses que estás listo para eso.* Poco frecuente, y lo que la gente más teme, y aquel en el que haberlo oído una vez antes vale más.

Después, pregunta cuál fue tu respuesta más débil y dónde habrían presionado si hubieran querido. Esa es la misma pregunta de la frase-más-débil del bloque uno, aplicada a una conversación, y funciona por el mismo motivo.

Una cosa que hay que retener: el compañero de ensayo no es evidencia sobre la persona. Es una forma de encontrar los agujeros en lo que vas a decir. Qué van a hacer de verdad el martes es incognoscible, y el próximo bloque trata de no confundir las dos cosas.

Si te quedas con una cosa: pídele que no ceda a menos que hayas respondido de verdad. Un ensayo que superas sin esfuerzo no te ha enseñado nada.$md$,
  $j$[
    {
      "situation": "El ensayo va bien.",
      "line": "No cedas a menos que haya respondido de verdad a la objeción.",
      "why": "Un ensayo donde cuelan respuestas débiles es peor que ninguno — sales habiendo confirmado algo falso."
    },
    {
      "situation": "Quieres comprobar si el punto sobrevive a la presión.",
      "line": "Interrúmpeme en mi tercera frase.",
      "why": "La compresión es lo que realmente pasa en las salas, y es donde se desmoronan los puntos preparados."
    },
    {
      "situation": "Terminaste y salió bien.",
      "line": "¿Cuál fue mi respuesta más débil, y dónde habrías presionado?",
      "why": "La pregunta de la frase-más-débil del bloque uno, aplicada a una conversación."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué dificultad es más difícil de manejar?",
      "options": [
        { "text": "El desacuerdo abierto.", "correct": false, "note": "Incómodo y manejable — hay algo concreto que responder." },
        { "text": "Estar de acuerdo y luego no hacer nada.", "correct": true, "note": "No hay nada contra lo que empujar, y así es como mueren calladamente la mayoría de las peticiones laborales." },
        { "text": "Que te interrumpan.", "correct": false, "note": "Comprueba si el punto sobrevive a la compresión, que es un problema distinto y más solucionable." },
        { "text": "Que te pidan números.", "correct": false, "note": "La más preparable de todas." }
      ],
      "explain": "Pide cada dificultad por separado — fallan de forma distinta."
    },
    {
      "prompt": "¿Qué no es el compañero de ensayo?",
      "options": [
        { "text": "Una forma de encontrar agujeros en tu argumento.", "correct": false, "note": "Eso es exactamente para lo que sirve." },
        { "text": "Una prueba de si tus respuestas aguantan.", "correct": false, "note": "También para eso sirve, siempre que se le diga que no ceda con demasiada facilidad." },
        { "text": "Un sitio donde oír la frase en voz alta.", "correct": false, "note": "Uno de los motivos principales para hacerlo, como argumenta la lección cinco." },
        { "text": "Evidencia sobre qué van a hacer.", "correct": true, "note": "Incognoscible, y confundir el ensayo con una predicción es todo el tema del próximo bloque." }
      ],
      "explain": "Un ensayo que superas sin esfuerzo no te ha enseñado nada."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "harder", "label": "Pidió la versión difícil", "description": "Escéptica, con poco tiempo." },
      { "key": "no_concede", "label": "Bloqueó las concesiones fáciles", "description": "Sin acuerdo sin una respuesta real." },
      { "key": "varied", "label": "Probó más de una dificultad", "description": "El que interrumpe, el que paraliza, o el personal." },
      { "key": "debrief", "label": "Preguntó qué fue lo más débil", "description": "Encontró el agujero después." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Elena",
      "role": "una amiga que conoce un poco tu trabajo",
      "mood": "Escéptica.",
      "openness": 5,
      "personality": "Pregunta si la versión de práctica alguna vez dijo que no, y qué pasa si lo hace."
    },
    "setting": "Has ensayado la conversación dos veces y las dos veces fue bien, lo cual te ha puesto más nervioso en vez de menos.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué pasó cuando la versión de práctica se resistió.",
      "No te impresiones con un ensayo que salió sin problemas.",
      "Nunca interpretes tú misma a la otra persona."
    ],
    "opening_beat": "«¿Alguna vez te dijo de verdad que no?»",
    "success_looks_like": "La persona pide un ensayo más difícil en vez de tomar el fácil como evidencia."
  }$j$::jsonb,
  'Hoy, ensaya una conversación contra una versión a la que se le ha dicho que no ceda. Apunta dónde te pilló.',
  $j${
    "says": "¿Alguna vez te dijo de verdad que no?",
    "model": {
      "line": "No, estuvo de acuerdo todas las veces. Voy a repetirlo y decirle que no ceda a menos que haya respondido.",
      "why": "Un ensayo donde cuelan respuestas débiles es peor que ninguno, porque sales habiendo confirmado algo falso."
    },
    "checks": [
      { "kind": "contains_any", "words": ["ceda", "más difícil", "escéptica", "resista", "diga que no", "difícil"], "requirement": "Pide una versión más difícil" },
      { "kind": "forbids_any", "words": ["así que debería ir bien", "salió bien", "creo que va a estar bien", "esa es una buena señal", "parece que estoy listo"], "requirement": "No trates la ronda fácil como evidencia" },
      { "kind": "max_words", "n": 35, "requirement": "Una decisión, no un resumen" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('rehearse-it-first', 3,
  '¿Qué no estoy diciendo?',
  $md$La mayoría de las conversaciones que la gente teme tienen una frase dentro que es la conversación de verdad, y se dedica muchísima preparación a acercarse a ella sin llegar nunca.

Preparas el contexto. Preparas el enfoque razonable. Preparas la parte donde dices que entiendes su postura. Y la frase — el número, la fecha, lo que hicieron, la palabra *no* — sigue sin estar en el plan cuando entras.

**La jugada:** pregunta qué estás evitando, antes de ensayar cualquier otra cosa.

*Esto es lo que planeo decir. ¿Qué no estoy diciendo?* Es la pregunta individual más útil de este tema, y funciona porque la evasión deja una forma en un borrador que se ve desde fuera. Un plan que rodea algo tiene un agujero dentro, y el agujero tiene bordes.

Las respuestas suelen ser una de cuatro cosas.

**El número.** Has preparado todo sobre la petición excepto cuánto.

**La consecuencia.** Qué vas a hacer si la respuesta es no. Con frecuencia todo el motivo por el que la conversación tiene algún peso, y se queda sin decir porque decirla se siente como una amenaza. Normalmente es simplemente información.

**Lo que hicieron.** El comportamiento específico, en un día específico. Conversaciones difíciles está construido sobre conseguir decir eso con llaneza, y la preparación es donde más a menudo se lija hasta convertirse en una preocupación general sobre la comunicación.

**La negativa.** A veces la frase que falta es simplemente *no*, y todo lo que la rodea es andamiaje para no tener que decirla.

Luego pide la frase en sí. *Dame una frase que lo diga con llaneza.* Tómala como punto de partida en vez de como guion — la redacción debería ser tuya, según Edita, no escribas — pero verla escrita elimina la sensación de que es indecible.

Y una advertencia de la experiencia: a veces vas a leer la respuesta y pensar, no, no voy a decir eso. Ese es un resultado legítimo. Decidir no decir algo es completamente distinto de nunca haber notado que faltaba.

Si te quedas con una cosa: pregunta qué no estás diciendo. El plan que lo rodea tiene un agujero con bordes.$md$,
  $j$[
    {
      "situation": "Tienes un plan y se siente completo.",
      "line": "Esto es lo que planeo decir. ¿Qué no estoy diciendo?",
      "why": "La evasión deja una forma en un borrador. Un plan que rodea algo tiene un agujero con bordes."
    },
    {
      "situation": "La pieza que falta es qué pasa si dicen que no.",
      "line": "(dilo — es información, no una amenaza)",
      "why": "Normalmente se queda sin decir porque se siente como una amenaza, y a menudo es todo el peso de la conversación."
    },
    {
      "situation": "Lees la frase que faltaba y no quieres decirla.",
      "line": "(decidir no hacerlo es un resultado legítimo)",
      "why": "Elegir no decir algo es completamente distinto de nunca notar que faltaba."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué funciona la pregunta?",
      "options": [
        { "text": "La evasión deja una forma visible en el plan.", "correct": true, "note": "Un plan que rodea algo tiene un agujero, y el agujero tiene bordes que son obvios desde fuera." },
        { "text": "Sabe lo que suelen contener estas conversaciones.", "correct": false, "note": "Parte de ello es patrón, y las respuestas útiles son específicas de tu plan más que del género." },
        { "text": "Es mejor en confrontación que tú.", "correct": false, "note": "Nunca ha tenido una conversación. Esto trata de leer un borrador." },
        { "text": "Elimina tu emoción de la situación.", "correct": false, "note": "Tu emoción es en gran parte el motivo por el que falta la frase, y no se elimina al notarlo." }
      ],
      "explain": "Pregúntala antes de ensayar cualquier otra cosa."
    },
    {
      "prompt": "¿Qué pieza que falta se omite con más frecuencia porque se siente como una amenaza?",
      "options": [
        { "text": "El número.", "correct": false, "note": "Se omite por incomodidad más que por miedo a cómo suena." },
        { "text": "Lo que hicieron.", "correct": false, "note": "Se omite porque es incómodo, y Conversaciones difíciles cubre cómo llegar a decirlo." },
        { "text": "Qué vas a hacer si dicen que no.", "correct": true, "note": "Se queda sin decir porque afirmarlo se siente como una amenaza, y normalmente es solo información — a menudo todo el peso de la conversación." },
        { "text": "La propia palabra no.", "correct": false, "note": "Una real, y se evita por ser brusca más que por sonar como una amenaza." }
      ],
      "explain": "Luego pídela en una frase con llaneza, y haz que la redacción sea tuya."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked", "label": "Preguntó qué faltaba", "description": "Antes de ensayar nada." },
      { "key": "found", "label": "Encontró la frase", "description": "Nombró lo que se estaba rodeando." },
      { "key": "plain", "label": "La consiguió en una frase con llaneza", "description": "No un párrafo de enfoque." },
      { "key": "own_words", "label": "Hizo la redacción suya", "description": "La usó como punto de partida, no como guion." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Elena",
      "role": "una amiga que conoce un poco tu trabajo",
      "mood": "Tranquila.",
      "openness": 5,
      "personality": "Escucha el plan y pregunta qué pasa si la respuesta es no."
    },
    "setting": "Tienes un plan completo para el martes y te sientes preparado, y algo al respecto sigue molestándote.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué pasa si la respuesta es no.",
      "Nota en voz alta cuando el plan rodea algo.",
      "Nunca aportes la frase que falta."
    ],
    "opening_beat": "«¿Y qué haces si te dice que no?»",
    "success_looks_like": "La persona nombra la frase que había estado omitiendo."
  }$j$::jsonb,
  'Hoy, pregunta qué no estás diciendo sobre una conversación próxima. Apunta la frase que encontró.',
  $j${
    "beats": [
      {
        "situation": "Tienes un plan completo: el contexto, el enfoque, la parte donde reconoces su postura.",
        "prompt": "¿Qué preguntas antes de ensayar cualquier parte de esto?",
        "options": [
          { "text": "¿Es esta una petición razonable?", "correct": false, "note": "Una pregunta de veredicto, y te va a decir que es muy razonable." },
          { "text": "¿Cómo debería abrir?", "correct": false, "note": "La próxima lección, y es prematuro mientras el plan todavía tenga un agujero dentro." },
          { "text": "¿Qué no estoy diciendo?", "correct": true, "note": "La evasión deja una forma. Un plan que rodea algo tiene un agujero con bordes, visible desde fuera." },
          { "text": "¿Qué va a decir ella?", "correct": false, "note": "Incognoscible, y respondido con confianza. Eso es dentro de dos bloques." }
        ]
      },
      {
        "situation": "Te dice que la pieza que falta es qué vas a hacer si la respuesta es no. No quieres decirla.",
        "prompt": "¿Cuál es la postura?",
        "options": [
          { "text": "Decidir no decirlo es legítimo.", "correct": true, "note": "Elegir no decir algo es completamente distinto de nunca haber notado que faltaba." },
          { "text": "Tienes que decirlo o la conversación no tiene sentido.", "correct": false, "note": "Demasiado fuerte. Muchas de estas conversaciones funcionan sin ello." },
          { "text": "Dilo, pero suavízalo mucho.", "correct": false, "note": "Suavizar una consecuencia hasta la vaguedad es cómo deja de ser información y empieza a sonar como algo peor." },
          { "text": "Déjalo y espera que no salga.", "correct": false, "note": "Distinto de decidir. Esta es la versión donde no has elegido en absoluto." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('rehearse-it-first', 4,
  'Los primeros quince segundos',
  $md$Hay una tentación, una vez que tienes un compañero de ensayo que nunca se cansa, de guionizar todo. No funciona, y merece la pena saber por qué antes de dedicarle una tarde entera.

Una conversación guionizada sobrevive hasta que la otra persona dice algo que no planeaste, que normalmente es su primera frase. Después de eso, o estás recitando en una conversación que ya ha avanzado, o has abandonado el guion y has perdido la preparación con él.

**La jugada:** ensaya la apertura y nada más.

Los primeros quince segundos son donde realmente falla. Ahí es donde la adrenalina está más alta, donde una persona callada tiene más probabilidades de enterrar el punto en preámbulo, y — porque es la única parte cuyo contexto puedes predecir — la única parte que se puede preparar con alguna confianza.

Storytelling hace el mismo argumento sobre la primera y última línea de una historia, y por el mismo motivo: una apertura conocida te compra el tramo donde los nervios están peor, y para cuando termina ya estás dentro de una conversación en vez de al principio de una.

Qué va en la apertura:

**El tema, nombrado.** *Quiero hablar sobre el proyecto de migración.* Ni un calentamiento, ni el tiempo, ni una pregunta sobre si ahora es un buen momento — eso entrega la decisión que viniste a tomar.

**La petición o la preocupación, en una frase.** Lo que sea que encontró la tercera lección. Va al frente, por exactamente el mismo motivo por el que Mensajería pone la petición en la primera línea.

**Y luego para.** El instinto es seguir hablando a través del silencio, y el silencio es suyo.

Eso son quince segundos. Ensáyalo hasta que salga sin ensamblaje, y no prepares nada más excepto las respuestas a las dos objeciones que ya sabes que van a llegar — que la segunda lección encontró, y que son respuestas más que guiones.

Si te quedas con una cosa: conoce los primeros quince segundos de memoria e improvisa el resto. El medio no se puede guionizar y no hace falta que se pueda.$md$,
  $j$[
    {
      "situation": "Sientes la tentación de guionizar toda la conversación.",
      "line": "(el guion muere en su primera frase)",
      "why": "Después de eso estás recitando en una conversación que ya ha avanzado, y la preparación se va con ella."
    },
    {
      "situation": "Estás escribiendo la apertura.",
      "line": "Quiero hablar sobre el proyecto de migración.",
      "why": "El tema nombrado, ni un calentamiento ni preguntar si ahora es un buen momento."
    },
    {
      "situation": "Has dicho la petición y hay silencio.",
      "line": "(para — es suyo)",
      "why": "Hablar a través de él es el instinto, y es cómo una apertura clara se entierra justo después de darse."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué no guionizarlo todo?",
      "options": [
        { "text": "Suena ensayado.", "correct": false, "note": "Menos problema de lo que la gente teme — nadie puede oír que te preparaste." },
        { "text": "Tarda demasiado en prepararse.", "correct": false, "note": "El tiempo no es la objeción, y una tarde merecería la pena dedicarla si funcionara." },
        { "text": "Muere en su primera frase no planeada.", "correct": true, "note": "Entonces o estás recitando en una conversación que ya ha avanzado, o has soltado el guion y la preparación con él." },
        { "text": "Lo vas a olvidar bajo presión.", "correct": false, "note": "Parte de él, y la apertura es lo bastante corta para sobrevivir, que es por lo que es la parte que hay que conservar." }
      ],
      "explain": "Conoce los primeros quince segundos e improvisa el resto."
    },
    {
      "prompt": "¿Qué no pertenece a la apertura?",
      "options": [
        { "text": "El tema, nombrado con llaneza.", "correct": false, "note": "Lo primero que hay en ella." },
        { "text": "Preguntar si ahora es un buen momento.", "correct": true, "note": "Entrega la decisión que viniste a tomar, y la respuesta a menudo es no." },
        { "text": "La petición, en una frase.", "correct": false, "note": "Pertenece al frente, por el mismo motivo por el que Mensajería la pone en la primera línea." },
        { "text": "Un silencio después de terminar.", "correct": false, "note": "Parte de la apertura, y la parte más difícil de dejar en paz." }
      ],
      "explain": "Luego prepara respuestas a las dos objeciones que ya sabes que van a llegar."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "opening_only", "label": "Ensayó la apertura", "description": "No guionizó todo." },
      { "key": "named", "label": "Nombró el tema", "description": "Sin calentamiento, sin pedir permiso." },
      { "key": "ask_first", "label": "Puso la petición en una frase", "description": "Al frente, no después del contexto." },
      { "key": "stopped", "label": "Dejó de hablar", "description": "Dejó el silencio en paz." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Elena",
      "role": "una amiga que conoce un poco tu trabajo",
      "mood": "Práctica.",
      "openness": 5,
      "personality": "Pregunta qué pasa con la página dos cuando la otra persona abre con algo inesperado."
    },
    "setting": "Has escrito dos páginas de lo que planeas decir el martes.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta cuáles son los primeros quince segundos.",
      "Date por satisfecha con una apertura corta y nombrada.",
      "Nunca escribas la apertura por ellos."
    ],
    "opening_beat": "«¿Qué pasa con todo esto si ella abre con otra cosa?»",
    "success_looks_like": "La persona lo recorta a una apertura preparada."
  }$j$::jsonb,
  'Hoy, prepara solo los primeros quince segundos de una conversación. Apunta la apertura.',
  $j${
    "says": "¿Qué pasa con todo esto si ella abre con otra cosa?",
    "model": {
      "line": "Justo. Voy a conservar los primeros quince segundos — quiero hablar sobre el proyecto de migración, y me gustaría liderarlo — e improvisar el resto.",
      "why": "Un guion muere en su primera frase no planeada. La apertura es la única parte cuyo contexto puedes predecir."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["es ahora un buen momento", "si tienes un minuto", "perdona por", "tienes tiempo", "espero que esté bien", "no estoy seguro de si"], "requirement": "No pidas permiso para empezar" },
      { "kind": "min_words", "n": 12, "requirement": "Da una apertura real" },
      { "kind": "max_words", "n": 45, "requirement": "Quince segundos de habla" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('rehearse-it-first', 5,
  'Dilo en voz alta',
  $md$Todo lo de hasta ahora se puede hacer escribiendo, y escribir no es ensayar.

Una frase que solo has leído es una frase que nunca has dicho. El día de verdad va a ser la primera vez que salga de tu boca, y la primera vez siempre es peor — más lenta, más aguda, con más muletillas, y como un tercio más larga de lo que parecía.

**La jugada:** di la apertura en voz alta antes del día.

A una sala vacía es suficiente. A la pantalla en una conversación de voz es mejor, porque algo responde y tienes que seguir. De cualquier forma, lo que estás comprobando no es la redacción, que ya tienes. Es si puedes producirla.

Lo que descubres, de forma fiable, en el primer intento:

**Es más larga de lo que parecía.** Las aperturas escritas se extienden a cuatro cláusulas y te quedas sin aliento a mitad de la tercera.

**Hay una palabra dentro que no es una que tú dirías.** Parecía bien y sale mal, y aplica el consejo de Storytelling — cámbiala por la que realmente usarías.

**El final se apaga.** Escrito, se detiene. Hablado, se convierte en *bueno, sí, solo quería plantearlo, la verdad* — el mismo desvanecimiento al que Storytelling dedica una lección, y aparece aquí por el mismo motivo: has llegado al final sin haber decidido parar.

**Te disculpas al entrar.** La apertura escrita no contiene *perdona que te suelte esto así*, y la hablada muy a menudo sí. Eso es el encogimiento de Mensajería, llegando por tu boca en vez de por tus pulgares, y oírlo una vez normalmente basta para eliminarlo.

Nada de eso es visible en una pantalla, y todo se puede arreglar en unos cuatro minutos.

Tres veces es suficiente. No la estás memorizando — la estás convirtiendo en una frase que ya has dicho antes, para que el martes sea la segunda vez en vez de la primera.

Si te quedas con una cosa: dila en voz alta tres veces. Todo lo que está mal en ella es audible e invisible.$md$,
  $j$[
    {
      "situation": "Tienes la apertura escrita y te sientes preparado.",
      "line": "(dila en voz alta — esa es la primera prueba)",
      "why": "Una frase que solo has leído es una frase que nunca has dicho, y la primera vez siempre es peor."
    },
    {
      "situation": "Te quedas sin aliento a mitad de camino.",
      "line": "(es demasiado larga — corta una cláusula)",
      "why": "Las aperturas escritas se extienden a cuatro cláusulas. Las habladas no pueden."
    },
    {
      "situation": "Salió con un perdona al principio.",
      "line": "(eso solo aparece en voz alta)",
      "why": "El encogimiento llega por tu boca en vez de por tus pulgares, y oírlo una vez normalmente basta para eliminarlo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué comprueba realmente la prueba en voz alta?",
      "options": [
        { "text": "Si la redacción es correcta.", "correct": false, "note": "Ya fijaste la redacción. Esto es una etapa posterior." },
        { "text": "Si la has memorizado.", "correct": false, "note": "Tres veces no es memorizar, y memorizar es la advertencia de la lección anterior." },
        { "text": "Si puedes producirla.", "correct": true, "note": "Longitud, aliento, la palabra que en realidad no dices, la disculpa que aparece de la nada. Nada de eso es visible en una pantalla." },
        { "text": "Si suena segura.", "correct": false, "note": "Sonar segura no es el objetivo, y de todos modos nadie puede oír tus nervios." }
      ],
      "explain": "Todo lo que está mal en ella es audible e invisible."
    },
    {
      "prompt": "¿Qué fallo aparece solo al hablar?",
      "options": [
        { "text": "La petición está enterrada.", "correct": false, "note": "Visible en la página, y las lecciones anteriores lo tratan." },
        { "text": "Es ambigua.", "correct": false, "note": "Una propiedad del texto, encontrable leyendo — la lista del bloque tres." },
        { "text": "Es demasiado formal.", "correct": false, "note": "Detectable por escrito si te fijas, aunque decirla en voz alta lo hace obvio." },
        { "text": "Una disculpa al principio.", "correct": true, "note": "La apertura escrita no contiene perdona que te suelte esto así. La hablada muy a menudo sí." }
      ],
      "explain": "Tres veces, para que el martes sea la segunda vez y no la primera."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "aloud", "label": "Lo dijo en voz alta", "description": "No leído, hablado." },
      { "key": "repeated", "label": "Tres veces", "description": "Suficiente para convertirla en una repetición." },
      { "key": "shortened", "label": "Cortó lo que no podía decir", "description": "Arregló la longitud y el aliento." },
      { "key": "no_apology", "label": "Eliminó la disculpa hablada", "description": "Cazó el encogimiento que apareció." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Elena",
      "role": "una amiga que conoce un poco tu trabajo",
      "mood": "Alentadora pero inmune a las excusas.",
      "openness": 5,
      "personality": "Pide oírla, y luego pide oírla otra vez."
    },
    "setting": "La conversación es mañana. Tu apertura está escrita y nunca la has dicho.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pide oírla una segunda vez.",
      "Nota si apareció una disculpa que no estaba escrita.",
      "Nunca sugieras otra redacción."
    ],
    "opening_beat": "«Dímelo. En voz alta, como lo dirías.»",
    "success_looks_like": "La persona dice la apertura en voz alta y nota qué cambió."
  }$j$::jsonb,
  'Hoy, di una apertura preparada en voz alta tres veces. Apunta qué cambió entre la primera y la tercera.',
  $j${
    "beats": [
      {
        "situation": "Dices tu apertura escrita en voz alta por primera vez y te quedas sin aliento en la tercera cláusula.",
        "prompt": "¿Qué te dice eso?",
        "options": [
          { "text": "Estás más nervioso de lo que pensabas.", "correct": false, "note": "Posiblemente, y la frase sería demasiado larga dicha con calma también." },
          { "text": "Necesitas practicarla más.", "correct": false, "note": "Practicar más una apertura de cuatro cláusulas te hace mejor en una frase que debería ser más corta." },
          { "text": "Corta una cláusula — es una frase escrita.", "correct": true, "note": "Las aperturas escritas se extienden a cuatro cláusulas y las habladas no pueden. Este es el fallo que la página no te puede mostrar." },
          { "text": "Habla más despacio el día real.", "correct": false, "note": "Más despacio empeora el problema del aliento, no lo mejora." }
        ]
      },
      {
        "situation": "Dicho en voz alta, aparece un perdona que te suelte esto así al principio, que nunca estuvo en la versión escrita.",
        "prompt": "¿Qué es eso?",
        "options": [
          { "text": "Una cortesía razonable en voz alta.", "correct": false, "note": "Se lee como cortesía y funciona como una disculpa por la petición, que es lo que Deja de disculparte elimina." },
          { "text": "Nervios, y va a pasar el día real.", "correct": false, "note": "El día real va a ser peor, no mejor — para eso existe el ensayo." },
          { "text": "Una señal de que no deberías tener la conversación.", "correct": false, "note": "Es una señal sobre la frase, no sobre la decisión." },
          { "text": "El encogimiento, llegando por tu boca.", "correct": true, "note": "La disculpa de Mensajería, en habla en vez de en pulgares. Oírla una vez normalmente basta para eliminarla." }
        ]
      }
    ]
  }$j$::jsonb
);
