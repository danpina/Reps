-- Spanish: Apps de citas, track 3 — Del match a la cita.
--
-- Conventions as prior tracks: tú for the reader, **La jugada:** for the
-- move marker, partner.alt sex-swap structures preserved and both halves
-- fully translated, character names left alone (Senan/Sena, Marek/Marta).
--
-- "Pen pals" (the app conversation that never becomes a date) is rendered
-- as "amigos por correspondencia", the standard Spanish idiom.

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

select pg_temp.es_lesson('match-to-date', 1,
  'Responde, y luego pregunta',
  $md$Las conversaciones en las aplicaciones mueren pronto o no mueren nunca. Si sigue viva después de tres intercambios de cada uno, normalmente va a seguir — lo que significa que los tres primeros cargan con todo el peso, y son los que la gente improvisa.

Hay un mecanismo debajo, y es lo bastante pequeño como para retenerlo.

**La jugada:** responde lo que te preguntaron, y luego pásales algo de vuelta.

Las dos mitades. Responder sin nada al final es un callejón sin salida con buenos modales — ahora tienen que inventar el siguiente tema solos, y después de dos veces así dejan de molestarse. Preguntar sin responder es un interrogatorio, y suena a alguien que te está procesando en vez de hablando contigo.

Lo que le pasas de vuelta no tiene que ser una pregunta, y esa es la parte que merece la pena saber. Una afirmación con un hueco obvio funciona igual de bien y es mucho menos formal. *Tengo opiniones sobre eso que probablemente no son defendibles* no es una pregunta y solo tiene una respuesta posible.

Iguala su longitud. Lo que hayan escrito es el registro que han elegido; una respuesta de tres líneas a un mensaje de una línea suena a esfuerzo, y el esfuerzo tan pronto es una señal sobre ti, no sobre ellos. Corto, cálido, respondido, devuelto.

Si eres una persona callada, esta es la buena noticia: todo esto es una forma de dos partes que puedes aplicar sin ser rápido. No hay ningún ritmo que acertar ni ninguna sala que leer. Solo no dejes la pelota en su lado de la red dos veces seguidas.$md$,
  $j$[
    {
      "situation": "Te preguntaron por qué elegiste esa foto, y respondiste.",
      "line": "(ahora pásales algo de vuelta)",
      "why": "Una respuesta sin nada al final es un callejón sin salida con buenos modales. Tienen que inventar el siguiente tema solos, y después de dos veces así lo dejan."
    },
    {
      "situation": "Estás a punto de hacer una segunda pregunta sin haber respondido a la suya.",
      "line": "(responde primero — si no, es un interrogatorio)",
      "why": "Las preguntas sin respuestas suenan a alguien que te está procesando. Dos personas pueden intercambiar preguntas todo un día y no aprender nada la una de la otra."
    },
    {
      "situation": "Quieres pasar algo de vuelta sin preguntar nada.",
      "line": "Tengo opiniones sobre eso que probablemente no son defendibles.",
      "why": "No es una pregunta, y tiene exactamente una respuesta posible. Una afirmación con un hueco hace el mismo trabajo, mucho menos formal."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué una respuesta perfectamente buena sin ninguna pregunta al final lo mata?",
      "options": [
        { "text": "Parece que no te interesa.", "correct": false, "note": "A veces se lee así, y el problema de verdad es mecánico, no emocional." },
        { "text": "Es demasiado corto.", "correct": false, "note": "Corto está bien aquí. La longitud no es lo que convierte un mensaje en un callejón sin salida." },
        { "text": "Tienen que inventar el siguiente tema solos.", "correct": true, "note": "Les has pasado todo el trabajo. Después de dos veces así, la mayoría lo deja en silencio — no por desinterés, sino porque se convirtió en trabajo." },
        { "text": "Rompe el ritmo.", "correct": false, "note": "Vago. Nombra el coste real: alguien ahora tiene que pensar algo de la nada." }
      ],
      "explain": "Responde, y luego pásales algo de vuelta. Nunca dejes la pelota en su lado dos veces seguidas."
    },
    {
      "prompt": "¿Qué puedes pasar de vuelta aparte de una pregunta?",
      "options": [
        { "text": "Una afirmación con un hueco obvio.", "correct": true, "note": "Tengo opiniones sobre eso que probablemente no son defendibles tiene exactamente una respuesta, y es mucho menos formal que una interrogativa." },
        { "text": "Un cumplido.", "correct": false, "note": "Agradable y cerrado. La única respuesta disponible es gracias, que es el mismo callejón sin salida con ropa más elegante." },
        { "text": "Un chiste.", "correct": false, "note": "Bien si tienes uno, y depende por completo de su ingenio para continuar. Un hueco no." },
        { "text": "Nada — una pregunta es la única forma.", "correct": false, "note": "Esto es lo que convierte las conversaciones de las aplicaciones en cuestionarios. Hay otras formas." }
      ],
      "explain": "Un hueco funciona igual de bien que un signo de interrogación y cuesta menos formalidad."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "answered", "label": "Respondió lo que le preguntaron", "description": "Se ocupó de su mensaje antes de añadir nada." },
      { "key": "handed_back", "label": "Pasó algo de vuelta", "description": "Dejó una pregunta o un hueco obvio en vez de un callejón sin salida." },
      { "key": "length", "label": "Igualó su longitud", "description": "Escribió con el registro que habían elegido." },
      { "key": "warm", "label": "Sonó como una persona", "description": "Lo mantuvo cálido en vez de eficiente." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "mood": "En la aplicación por las noches, sin desesperación.",
        "name": "Senan",
        "role": "un match, dos mensajes después",
        "openness": 4,
        "personality": "Seco y rápido. Sigue mientras haya algo que responder, y se hace más breve cada vez que llega un mensaje sin nada al final."
      },
      "sex": "female",
      "mood": "En la aplicación por las noches, sin desesperación.",
      "name": "Sena",
      "role": "un match, dos mensajes después",
      "openness": 4,
      "personality": "Seca y rápida. Sigue mientras haya algo que responder, y se hace más breve cada vez que llega un mensaje sin nada al final."
    },
    "setting": "Dos mensajes después. Su perfil tenía una bici cargada de alforjas y una hogaza de masa madre bastante aplastada, y preguntaste por el pan.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Escribe como se escribe en las aplicaciones: corto, casi todo en minúsculas, sin párrafos.",
      "Responde del todo a cualquier cosa que tenga una pregunta o un hueco, y hazte notablemente más breve después de un callejón sin salida.",
      "Nunca rescates un callejón sin salida inventando un tema nuevo."
    ],
    "opening_beat": "«jaja, era literalmente incomible. ¿por qué preguntaste por el pan y no por la bici?»",
    "success_looks_like": "La persona responde la pregunta y deja algo que contestar."
  }$j$::jsonb,
  'Hoy, responde a un mensaje contestándolo y dejando algo al final. Apunta qué le pasaste de vuelta.',
  $j${
    "says": "jaja, era literalmente incomible. ¿por qué preguntaste por el pan y no por la bici?",
    "model": {
      "line": "La bici dice que eres impresionante. La hogaza dice que eres una persona. ¿Alguna vez conseguiste que subiera una?",
      "why": "Responde lo que le preguntaron, dice algo con un poco de ti dentro, y devuelve una pregunta fácil y concreta. Nadie tiene que inventar un tema."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Pasa algo de vuelta, no dejes un callejón sin salida" },
      { "kind": "max_questions", "n": 1, "requirement": "Una pregunta. Tres consiguen que se responda una." },
      { "kind": "min_words", "n": 12, "requirement": "Respóndeles antes de preguntar nada" },
      { "kind": "max_words", "n": 45, "requirement": "Iguala su longitud — un mensaje, no un párrafo" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('match-to-date', 2,
  'Sal del interrogatorio',
  $md$Dos personas intercambian datos. A qué te dedicas, de dónde eres, cuánto tiempo llevas aquí, si te gusta tu trabajo. Todo el mundo es educado, nadie es maleducado, y después de veinte mensajes tienes el perfil completo de alguien por quien no sientes absolutamente nada.

Es la forma más habitual en que muere un match, y no parece un fracaso mientras está pasando. Eso es lo que lo hace peligroso — un interrogatorio se siente como una conversación que va bien.

El motivo por el que muere es que los datos no son información sobre una persona. *Trabajo en logística* no te dice nada; *trabajo en logística y tengo opiniones firmes sobre lo mal que esta ciudad hace las rotondas* te dice cómo es alguien. Lo primero es un dato y lo segundo es una persona, y solo una de las dos cosas se puede llegar a apreciar.

**La jugada:** deja de aportar datos y empieza a aportar reacciones.

Una opinión, una pequeña historia, algo que te hizo gracia, algo que te molesta. Responde la pregunta y luego di lo que de verdad piensas sobre lo que acabas de responder. Ese único añadido convierte cualquier intercambio soso de la lista de arriba.

No devuelvas el interrogatorio como un espejo. *¿Y tú?* es el acto reflejo, y mantiene el formato en marcha — los dos os quedáis en el cuestionario, siendo agradables, sin aprender nada. Rompe el formato en su lugar: reacciona, y deja que reaccionen a tu reacción.

Para alguien callado hay una trampa concreta aquí. Los interrogatorios se sienten seguros porque los datos no se pueden juzgar, y esa seguridad es lo que está matando la conversación. A nadie le has caído mal nunca por decir que tienes opiniones sobre las rotondas.$md$,
  $j$[
    {
      "situation": "«Entonces, ¿a qué te dedicas?»",
      "line": "Hojas de cálculo, técnicamente. Sobre todo discuto con gente que quiere que la hoja de cálculo diga otra cosa.",
      "why": "El dato, y luego la reacción. La segunda mitad es la única parte que les dice cómo eres, y es la única parte a la que pueden responder."
    },
    {
      "situation": "Has respondido y estás a punto de escribir y tú qué.",
      "line": "(eso mantiene el cuestionario en marcha)",
      "why": "Devolver el interrogatorio como un espejo es el acto reflejo que os mantiene a los dos educados y sin aprender nada. Reacciona en su lugar, y deja que reaccionen a eso."
    },
    {
      "situation": "El intercambio lleva ocho mensajes siendo agradable y completamente plano.",
      "line": "(di algo que de verdad piensas)",
      "why": "No pasa nada malo y no pasa nada. Los datos son seguros, que es precisamente lo que lo está matando — a una persona no se le puede llegar a apreciar hasta que se ha dejado ver."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué es tan peligroso el interrogatorio?",
      "options": [
        { "text": "Es de mala educación.", "correct": false, "note": "Es impecablemente educado. Ese es el problema." },
        { "text": "Tarda demasiado.", "correct": false, "note": "La velocidad no es el problema. Un interrogatorio rápido muere exactamente igual." },
        { "text": "A la gente se le acaban las preguntas.", "correct": false, "note": "Casi nunca. Hay datos infinitos, que es por lo que esto puede durar veinte mensajes." },
        { "text": "Se siente como una conversación que va bien.", "correct": true, "note": "Nada señala el fracaso mientras está pasando, así que nadie cambia de rumbo. Acabas con el perfil completo de alguien por quien no sientes nada." }
      ],
      "explain": "Educado, interminable e inerte. Un interrogatorio es el aspecto que tiene un match muriendo desde dentro."
    },
    {
      "prompt": "Te preguntan a qué te dedicas. ¿Qué convierte la respuesta en una persona?",
      "options": [
        { "text": "Hacer que el trabajo suene más interesante.", "correct": false, "note": "Sigue siendo un dato, ahora con mejor envoltorio. Nada en ello se puede apreciar ni discutir." },
        { "text": "Añadir lo que de verdad piensas sobre ello.", "correct": true, "note": "El dato es un dato; la reacción es una persona. Unas opiniones firmes sobre las rotondas les dicen más que el nombre del puesto en toda su vida." },
        { "text": "Preguntarles a qué se dedican ellos.", "correct": false, "note": "El acto reflejo, y mantiene el cuestionario en marcha. Los dos seguís siendo agradables y no aprendéis nada." },
        { "text": "Quitarle importancia a costa de ti mismo.", "correct": false, "note": "Una reacción disponible entre muchas, y se convierte en un tic rápido. Cualquier reacción de verdad gana a una modesta." }
      ],
      "explain": "Responde, y luego di lo que piensas sobre tu propia respuesta."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "reaction", "label": "Aportó una reacción", "description": "Añadió una opinión, una historia o un sentimiento al dato." },
      { "key": "no_mirror", "label": "No devolvió la pregunta como un espejo", "description": "Evitó pasar de vuelta la misma pregunta del interrogatorio tal cual." },
      { "key": "specific", "label": "Fue concreto", "description": "Nombró la cosa real en vez de insinuar que tiene opiniones." },
      { "key": "light", "label": "Lo mantuvo ligero", "description": "Reaccionó en una frase, no en un párrafo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "mood": "Agradable, un poco aburrido, sin saber decir por qué.",
        "name": "Marek",
        "role": "un match, varios mensajes educados después",
        "openness": 4,
        "personality": "Perfectamente simpático y atascado en modo interrogatorio. Sigue haciendo preguntas de datos hasta que alguien dice algo con una opinión dentro, y entonces se anima."
      },
      "sex": "female",
      "mood": "Agradable, un poco aburrida, sin saber decir por qué.",
      "name": "Marta",
      "role": "un match, varios mensajes educados después",
      "openness": 4,
      "personality": "Perfectamente simpática y atascada en modo interrogatorio. Sigue haciendo preguntas de datos hasta que alguien dice algo con una opinión dentro, y entonces se anima."
    },
    "setting": "Seis mensajes después. Ha sido amistoso, correcto y completamente plano — trabajos, barrios, cuánto tiempo lleva cada uno aquí.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Escribe como se escribe en las aplicaciones: corto, casi todo en minúsculas, sin párrafos.",
      "Responde a una pregunta devuelta con otra pregunta de datos, manteniendo el interrogatorio en marcha.",
      "Anímate y reacciona de verdad en el momento en que la persona diga algo con una opinión dentro."
    ],
    "opening_beat": "«entonces, ¿a qué te dedicas?»",
    "success_looks_like": "La persona responde y añade una reacción real en vez de devolver la pregunta como un espejo."
  }$j$::jsonb,
  'Hoy, responde una pregunta y luego di lo que de verdad piensas sobre tu propia respuesta. Apunta el dato y la reacción.',
  $j${
    "says": "entonces, ¿a qué te dedicas?",
    "model": {
      "line": "Hojas de cálculo, técnicamente. Sobre todo discuto con gente que quiere que la hoja de cálculo diga otra cosa. ¿Cuál ha sido el peor trabajo que has tenido?",
      "why": "El dato, luego la reacción, luego una pregunta que no es la misma pregunta devuelta. La frase del medio es la única parte que les dice cómo eres."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Mete algo de ti mismo" },
      { "kind": "forbids_any", "words": ["y tú", "y a ti", "qué tal tú", "a qué te dedicas", "de dónde eres", "tú mismo", "tú misma"], "requirement": "No devuelvas el interrogatorio como un espejo" },
      { "kind": "max_questions", "n": 1, "requirement": "Como mucho una pregunta" },
      { "kind": "min_words", "n": 12, "requirement": "Más que un nombre de puesto" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('match-to-date', 3,
  'Muévete antes de que se apague',
  $md$En la aplicación no pasa nada. Eso no es un eslogan, es la aritmética: cada mensaje gasta un poco del interés que os juntó, y ninguno lo repone.

Un match llega con una cantidad fija de curiosidad dentro. Los buenos intercambios convierten parte de eso en ganas de quedar. Los malos la queman. Pero incluso los buenos la queman despacio, porque la familiaridad sin presencia se aplana — para el mensaje sesenta ya no sois dos personas a punto de quedar, sois amigos por correspondencia, y los amigos por correspondencia no se convierten en citas. Se apagan, educadamente, normalmente sin que ninguno de los dos lo decida.

**La jugada:** propón quedar a los pocos días de que vaya bien, no a las dos semanas.

La señal que hay que buscar no es una sensación de certeza. Es simplemente que la conversación funciona — los dos habéis escrito más de una línea, algo ha tenido gracia, y ninguno de los dos es el único que pregunta. Ese es el momento. No va a mejorar esperando, y esperar no hace nada por ganarse el derecho.

La espera es casi siempre sobre ti y no sobre estar preparado: unos días más se sienten más seguros porque todavía no se ha arriesgado nada. Pero el riesgo no se reduce, solo se vuelve más caro — el mensaje que te da pavor es más fácil de mandar hoy de lo que será el viernes, porque el viernes también vas a tener que explicar el hueco.

Vale la pena nombrar dos excepciones. Alguien que nunca sale de la aplicación después de varios días de buena conversación puede que no tenga intención de hacerlo, y merece la pena saberlo pronto y no dentro de tres semanas. Y si proponen ellos primero, di que sí y deja de negociar.$md$,
  $j$[
    {
      "situation": "Tres días de buenos intercambios. Estás esperando un momento mejor.",
      "line": "(esto es todo — que la conversación funcione es la señal)",
      "why": "No va a llegar ninguna sensación de certeza. Esperar no gana el derecho ni mejora las probabilidades; solo gasta lo que trajo el match."
    },
    {
      "situation": "Llevan dos semanas y os habláis todos los días.",
      "line": "(sois amigos por correspondencia — propón quedar hoy)",
      "why": "La familiaridad sin presencia se aplana. Nadie decide parar; simplemente se convierte en silencio en algo que nunca iba a pasar."
    },
    {
      "situation": "Han sugerido quedar.",
      "line": "(di que sí, y deja de negociar)",
      "why": "La parte difícil ya te la han hecho. Mejorar su plan es cómo un sí se convierte otra vez en una conversación sobre horarios."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué te dice que es hora de proponer algo?",
      "options": [
        { "text": "La conversación sencillamente funciona.", "correct": true, "note": "Los dos escribiendo más de una línea, algo ha tenido gracia, ninguno de los dos preguntando todo el rato. No va a llegar una señal más fuerte, y esperarla gasta el match." },
        { "text": "Sientes certeza sobre ellos.", "correct": false, "note": "La certeza sobre un desconocido no se consigue a través de texto, y esperarla es cómo pasan dos semanas." },
        { "text": "Lo han insinuado.", "correct": false, "note": "Precioso cuando pasa. Construir el plan alrededor de eso significa que solo llegas a quedar con quien se mueve primero." },
        { "text": "Se te han acabado las cosas que decir.", "correct": false, "note": "Para entonces el interés ya se ha gastado. Esa es la versión tardía de esto, no la señal." }
      ],
      "explain": "Que funcione es la señal. No mejora por dejarla reposar."
    },
    {
      "prompt": "¿Por qué una charla de dos semanas rara vez se convierte en una cita?",
      "options": [
        { "text": "Alguien más se adelantó.", "correct": false, "note": "A veces cierto, y sobre todo un cuento que te ahorra el mecanismo real." },
        { "text": "Nunca estuvo interesado.", "correct": false, "note": "Normalmente sí lo estaba, hace dos semanas. El interés no es una cantidad fija que se revela; se gasta." },
        { "text": "La familiaridad sin presencia se aplana en amigos por correspondencia.", "correct": true, "note": "Cada mensaje gasta un poco de lo que trajo el match, y ninguno lo repone. Nadie decide parar — simplemente deja de ser algo que iba a pasar." },
        { "text": "La aplicación entierra las conversaciones viejas.", "correct": false, "note": "Un mecanismo, no el motivo. El mismo apagón pasa en un hilo que sigue arriba del todo en la lista." }
      ],
      "explain": "El match llega con una cantidad fija de curiosidad. Los mensajes la gastan."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "timing", "label": "Se movió mientras funcionaba", "description": "Propuso quedar en días, no en semanas." },
      { "key": "no_waiting", "label": "No esperó a tener certeza", "description": "Trató que la conversación funcionara como la señal." },
      { "key": "took_yes", "label": "Aceptó una propuesta sin complicarla", "description": "Dijo que sí sin renegociar cuando se movieron ellos primero." },
      { "key": "read_a_stall", "label": "Detectó a quien no se mueve", "description": "Se dio cuenta de alguien que nunca sale de la aplicación en vez de esperar a que pase." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "mood": "Disfrutando esto, sin ninguna prisa.",
        "name": "Senan",
        "role": "un match con quien llevas hablando cuatro días",
        "openness": 4,
        "personality": "Cálido e implicado, y seguiría charlando encantado de forma indefinida sin sugerir nunca quedar. Dice que sí enseguida a cualquier cosa concreta."
      },
      "sex": "female",
      "mood": "Disfrutando esto, sin ninguna prisa.",
      "name": "Sena",
      "role": "un match con quien llevas hablando cuatro días",
      "openness": 4,
      "personality": "Cálida e implicada, y seguiría charlando encantada de forma indefinida sin sugerir nunca quedar. Dice que sí enseguida a cualquier cosa concreta."
    },
    "setting": "Día cuatro. La conversación ha sido de verdad buena — respuestas largas, dos bromas recurrentes, los dos preguntando cosas.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Escribe como se escribe en las aplicaciones: corto, casi todo en minúsculas, sin párrafos.",
      "No sugieras tú nunca quedar, por muy larga que se alargue la conversación.",
      "Di que sí con calidez a cualquier cosa concreta que lleve un momento fijado."
    ],
    "opening_beat": "«vale pero ya has mencionado esa panadería tres veces distintas»",
    "success_looks_like": "La persona mueve la conversación hacia quedar en vez de seguir alargándola."
  }$j$::jsonb,
  'Hoy, mira una conversación que lleve un tiempo en marcha y decide si está funcionando o apagándose. Apunta cuál de las dos y qué hiciste al respecto.',
  $j${
    "beats": [
      {
        "situation": "Cuatro días de buenos intercambios. Respuestas largas, dos bromas recurrentes, los dos preguntando cosas. No has sugerido quedar.",
        "prompt": "¿Y ahora qué?",
        "options": [
          { "text": "Propón algo. Así es como se ve que funciona.", "correct": true, "note": "No va a llegar una señal más fuerte. Esperar no gana el derecho ni mejora las probabilidades — solo gasta lo que trajo el match." },
          { "text": "Dale unos días más para estar seguro.", "correct": false, "note": "¿Seguro de qué? La certeza sobre un desconocido no se consigue a través de texto, y así es cómo pasan dos semanas." },
          { "text": "Espera a que lo sugieran ellos.", "correct": false, "note": "Entonces solo llegas a quedar con quien se mueve primero, y muchos matches cálidos no se mueven nunca." },
          { "text": "Suelta una indirecta y mira si la pilla.", "correct": false, "note": "Una indirecta es una propuesta a la que le han quitado la parte respondible. Si merece la pena insinuarla, merece la pena preguntarla." }
        ]
      },
      {
        "situation": "Un match distinto. Dieciséis días, mensajes todos los días, sin quedar.",
        "prompt": "¿Qué ha pasado aquí?",
        "options": [
          { "text": "Nunca estuvo realmente interesado.", "correct": false, "note": "Normalmente sí lo estaba, hace dos semanas. El interés no es una cantidad fija esperando a revelarse — se gasta." },
          { "text": "Nada todavía. Dieciséis días de buena charla es una buena señal.", "correct": false, "note": "Es la lectura más cómoda y la equivocada. Nada de esto apunta hacia una cita." },
          { "text": "Se convirtió en amigos por correspondencia, y los amigos por correspondencia no se convierten en citas.", "correct": true, "note": "La familiaridad sin presencia se aplana. Nadie decide parar; simplemente deja de ser, en silencio, algo que iba a pasar." },
          { "text": "Uno de los dos se está haciendo el interesante.", "correct": false, "note": "Puede, y no cambia la jugada. Alguien tiene que proponer, y no hay ninguna ventaja en que no seas tú." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('match-to-date', 4,
  'Pregunta para que el sí sea fácil',
  $md$*Deberíamos tomar algo un día de estos* no es un plan. Es un deseo sin ningún momento fijado, y la única respuesta disponible es *sí, claro que sí* — que es por lo que tantas de esas conversaciones terminan ahí, con calidez, para siempre.

**La jugada:** algo concreto, algo pequeño, y un momento fijado.

**Concreto** significa un lugar o una actividad, idealmente uno que ya haya salido en la conversación. Llevan tres días hablando de la panadería; el plan se escribe solo, y usarlo demuestra que el plan salió de los dos y no de una plantilla.

**Pequeño** importa más que ingenioso. Una copa es una hora y una cena es una tarde entera — una hora es lo que un desconocido puede aceptar cómodamente, y también es lo que un desconocido puede *dejar* cómodamente. Proponer algo corto es una amabilidad para los dos, y quita la objeción que nadie dice en voz alta.

**Un momento** es la parte que convierte un deseo en una pregunta. Dos opciones en vez de una — *el jueves o el sábado* — porque dos es una elección y una es una citación, y *cuándo tienes libre* le pasa a él la gestión.

Luego mándalo. Todo esto es un solo mensaje y no debería ir precedido de tres mensajes de preámbulo, que es lo que produce el pavor.

Para quien lea esto con timidez, el replanteamiento que merece la pena: no le estás pidiendo a alguien que decida sobre ti. Le estás preguntando si le viene bien una hora el jueves. Se sienten como la misma pregunta y no lo son, y la segunda es la que de verdad estás mandando.$md$,
  $j$[
    {
      "situation": "Estás a punto de mandar: deberíamos tomar algo un día de estos.",
      "line": "(sin ningún momento fijado — la única respuesta es sí, claro que sí)",
      "why": "Un deseo, no una pregunta. Cálido, agradable, y la conversación termina ahí, que es por lo que es el mensaje final más habitual de cualquier aplicación."
    },
    {
      "situation": "Llevan tres días hablando de una panadería.",
      "line": "El jueves o el sábado, y me dices si todo el mundo tiene razón con lo de esa panadería.",
      "why": "Concreto, pequeño, dos opciones, y sacado de la conversación — que demuestra que el plan salió de los dos y no de un guion."
    },
    {
      "situation": "Quieres proponer cenar para que sea una cita de verdad.",
      "line": "(que sea una hora)",
      "why": "Una hora es lo que un desconocido puede aceptar cómodamente y dejar cómodamente. Pequeño quita la objeción que nadie dice en voz alta."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué tiene de malo deberíamos tomar algo un día de estos?",
      "options": [
        { "text": "Es demasiado informal.", "correct": false, "note": "Lo informal está bien para un primer encuentro. El registro no es el problema." },
        { "text": "No lleva ningún momento fijado, así que no hay nada que responder.", "correct": true, "note": "Es un deseo, no una pregunta. La única respuesta disponible es sí, claro que sí — que es por lo que tantas conversaciones terminan ahí, con calidez, para siempre." },
        { "text": "Tomar algo es una mala primera cita.", "correct": false, "note": "Tomar algo está cerca de lo ideal: corto, barato, fácil de dejar. La palabra que hace el daño es un día de estos." },
        { "text": "Les pone entre la espada y la pared.", "correct": false, "note": "Justo lo contrario. No pone a nadie entre la espada y la pared, que es exactamente por lo que no pasa nada." }
      ],
      "explain": "Un plan lleva un momento fijado. Sin él has mandado un sentimiento."
    },
    {
      "prompt": "¿Por qué dos opciones en vez de una?",
      "options": [
        { "text": "Duplica tus probabilidades.", "correct": false, "note": "Una aritmética que se salta el mecanismo. Esto va de lo que el mensaje le pide que haga." },
        { "text": "Demuestra que eres flexible.", "correct": false, "note": "La flexibilidad llevada al extremo es cuándo tienes libre, que le pasa a él la gestión y normalmente se estanca." },
        { "text": "Parece menos interesado.", "correct": false, "note": "Gestión de la imagen, y fuera de lugar. Estar interesado está bien." },
        { "text": "Dos es una elección; una es una citación.", "correct": true, "note": "Elegir entre el jueves y el sábado es fácil y agradable. Aceptar o rechazar una única fecha fija es un acto mucho más grande." }
      ],
      "explain": "Concreto, pequeño, dos momentos. Luego mándalo sin tres mensajes de preámbulo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "specific", "label": "Nombró algo concreto", "description": "Propuso un lugar o una actividad real, idealmente de la conversación." },
      { "key": "small", "label": "Lo mantuvo pequeño", "description": "Una hora en vez de una tarde entera." },
      { "key": "a_time", "label": "Puso un momento fijado", "description": "Ofreció días en vez de un día de estos o cuándo tienes libre." },
      { "key": "sent_it", "label": "Lo mandó limpio", "description": "Un mensaje, sin preámbulo delante." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "mood": "Disfrutando esto.",
        "name": "Senan",
        "role": "un match con quien llevas hablando cuatro días",
        "openness": 4,
        "personality": "Cálido y decidido. Dice que sí de inmediato a cualquier cosa que lleve un momento fijado, y responde a una sugerencia vaga con un sí igual de vago."
      },
      "sex": "female",
      "mood": "Disfrutando esto.",
      "name": "Sena",
      "role": "un match con quien llevas hablando cuatro días",
      "openness": 4,
      "personality": "Cálida y decidida. Dice que sí de inmediato a cualquier cosa que lleve un momento fijado, y responde a una sugerencia vaga con un sí igual de vago."
    },
    "setting": "Día cuatro, y la panadería cerca de la estación ha salido en la conversación tres veces.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Escribe como se escribe en las aplicaciones: corto, casi todo en minúsculas, sin párrafos.",
      "Responde con entusiasmo y concreción a cualquier cosa que lleve un día fijado.",
      "Responde a un día de estos o cuándo tienes libre con un sí, claro que sí cálido y vago, y nada más."
    ],
    "opening_beat": "«la verdad es que nunca he ido. aunque todo el mundo dice que está bien»",
    "success_looks_like": "La persona propone algo concreto y pequeño con un momento fijado."
  }$j$::jsonb,
  'Hoy, convierte un plan vago con cualquiera en uno concreto con dos momentos fijados. Apunta qué mandaste.',
  $j${
    "says": "la verdad es que nunca he ido. aunque todo el mundo dice que está bien",
    "model": {
      "line": "Pues arreglemos eso — el jueves o el sábado, una copa, ¿y me dices si todo el mundo tiene razón?",
      "why": "Concreto, pequeño, dos momentos, y construido a partir de lo que ya estabais hablando. Elegir entre dos días es fácil; aquí no hay nada que negociar."
    },
    "checks": [
      { "kind": "contains_any", "words": ["lunes", "martes", "miércoles", "jueves", "viernes", "sábado", "domingo", "mañana", "esta semana", "la semana que viene", "esta noche", "fin de semana"], "requirement": "Pon un momento fijado" },
      { "kind": "contains_any", "words": ["copa", "algo", "café", "hora", "paseo", "rápido", "una"], "requirement": "Mantenlo pequeño — una hora, no una tarde entera" },
      { "kind": "forbids_any", "words": ["un día de estos", "en algún momento", "cuando tengas libre", "cuándo tienes libre", "deberíamos"], "requirement": "Un plan, no un deseo" },
      { "kind": "max_words", "n": 30, "requirement": "Un mensaje, sin preámbulo" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('match-to-date', 5,
  'Un empujoncito, y el no suave',
  $md$Propusiste algo y no llegó nada de vuelta. O llegó algo que no era ni un sí ni un no.

Las dos cosas son normales, las dos se sienten mucho peor de lo que son, y las dos tienen una jugada correcta más pequeña que la que el pavor va a sugerir.

**La jugada:** un empujoncito, nunca dos — y lee la contraoferta.

**El silencio.** Espera un par de días, y manda un mensaje ligero que no dé nada por hecho. Ni una disculpa, ni una nueva explicación, y sobre todo no *has visto mi mensaje*. Algo normal sobre lo que ya estabais hablando, que les deja reaparecer sin tener que dar explicaciones por el hueco. Si eso no consigue nada, se acabó, y el segundo empujoncito es el que convierte un no-responder normal en algo que preferirías que no le contaran a sus amigos.

**La contraoferta.** Esta es la que la gente malinterpreta en las dos direcciones. *No puedo el jueves, ¿qué tal la semana que viene?* es un sí con una agenda pegada. *Ando muy liado ahora mismo* sin ninguna alternativa ofrecida es un no, por muy cálido que sea el envoltorio. La prueba es completamente mecánica: ¿te devolvieron un momento, o te devolvieron un motivo? Un momento es un sí. Un motivo es un no.

Y el replanteamiento que merece la pena conservar, porque es cierto y la gente no se lo cree: que un match no se convierta en una cita es el resultado estándar, no una prueba sobre ti. A quienes les va bien en estas aplicaciones no les llegan más síes. Les llegan más noes, antes, y les importan menos.$md$,
  $j$[
    {
      "situation": "Dos días de silencio después de que propusieras el jueves o el sábado.",
      "line": "(un mensaje ligero sobre lo que ya estabais hablando)",
      "why": "Les deja reaparecer sin dar explicaciones por el hueco. Ni una disculpa, ni has visto mi mensaje, y nunca un segundo después de este."
    },
    {
      "situation": "«No puedo el jueves — ¿qué tal la semana siguiente?»",
      "line": "(volvió un momento — eso es un sí)",
      "why": "La prueba es mecánica. Te devolvieron una agenda en vez de un motivo, que es el aspecto que tiene un sí cuando el calendario no cuadra."
    },
    {
      "situation": "«Ando fatal de tiempo ahora mismo, ¡perdona!»",
      "line": "(volvió un motivo — eso es un no, con calidez)",
      "why": "No se ofreció ninguna alternativa. Tómatelo tal cual, sé amable al respecto, y no ofrezcas tú la semana más conveniente que no te pidieron."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Silencio durante dos días después de proponer. ¿Qué mandas?",
      "options": [
        { "text": "¿Has visto mi mensaje?", "correct": false, "note": "Convierte el silencio en el tema y les pide que lo expliquen. Ahora tienen que gestionar tus sentimientos antes de poder responder." },
        { "text": "Nada, nunca — ya lo han visto.", "correct": false, "note": "Es verdad, y a la gente se le pasan cosas, se lía y tiene intención de responder. Un empujoncito es gratis; es el segundo el que cuesta." },
        { "text": "Un mensaje ligero sobre lo que ya estabais hablando.", "correct": true, "note": "No da nada por hecho y les deja reaparecer sin dar explicaciones por el hueco. Si eso no consigue nada de vuelta, se acabó." },
        { "text": "Una segunda propuesta más fácil, para ponérselo más sencillo.", "correct": false, "note": "Dos peticiones apiladas sobre un silencio. Suena a presión por muy ligero que esté escrito." }
      ],
      "explain": "Un empujoncito, y nunca debería mencionar el silencio."
    },
    {
      "prompt": "¿Cómo distingues un reajuste de verdad de un no suave?",
      "options": [
        { "text": "¿Te devolvieron un momento o un motivo?", "correct": true, "note": "Completamente mecánico, que es lo que lo hace usable cuando estás ansioso. Un momento es un sí con una agenda pegada; un motivo sin alternativa es un no." },
        { "text": "Lo cálido que fue el mensaje.", "correct": false, "note": "Los noes suaves son los mensajes más cálidos que manda la gente. La calidez es lo que usan para ponértelo fácil." },
        { "text": "Si se disculparon.", "correct": false, "note": "Disculparse suele apuntar más bien en la otra dirección, si acaso. Es un envoltorio, no una señal." },
        { "text": "Lo rápido que respondieron.", "correct": false, "note": "Rápido y vago es muy habitual. La velocidad dice algo de sus hábitos con el móvil y nada de su agenda." }
      ],
      "explain": "Que vuelva un momento es un sí. Que vuelva un motivo es un no. Tómatelo con calidez y sigue adelante."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_nudge", "label": "Empujó una vez", "description": "Mandó un único mensaje ligero y ninguno segundo." },
      { "key": "no_audit", "label": "No mencionó el silencio", "description": "No dio nada por hecho en vez de pedirles explicaciones por el hueco." },
      { "key": "read_it", "label": "Leyó bien la contraoferta", "description": "Interpretó un momento como un sí y un motivo como un no." },
      { "key": "warm_exit", "label": "Se tomó el no con calidez", "description": "Lo aceptó sin insistir ni actuar la decepción." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "mood": "Liado, un poco culpable por el hueco.",
        "name": "Senan",
        "role": "un match que no ha respondido a tu propuesta",
        "openness": 3,
        "personality": "Estaba disfrutando de verdad la conversación y se vio desbordado en el trabajo. Reaparece encantado ante un mensaje ligero que no da nada por hecho, y se calla otra vez ante cualquier cosa que pregunte por el silencio."
      },
      "sex": "female",
      "mood": "Liada, un poco culpable por el hueco.",
      "name": "Sena",
      "role": "un match que no ha respondido a tu propuesta",
      "openness": 3,
      "personality": "Estaba disfrutando de verdad la conversación y se vio desbordada en el trabajo. Reaparece encantada ante un mensaje ligero que no da nada por hecho, y se calla otra vez ante cualquier cosa que pregunte por el silencio."
    },
    "setting": "Propusiste el jueves o el sábado hace dos días. No ha vuelto nada, y el hilo sigue arriba del todo en la aplicación.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Escribe como se escribe en las aplicaciones: corto, casi todo en minúsculas, sin párrafos.",
      "Reaparece con calidez, ofreciendo un día real, ante un mensaje ligero que no da nada por hecho.",
      "Cállate ante cualquier cosa que pregunte por el hueco o apile una segunda propuesta encima."
    ],
    "opening_beat": "El hilo está abierto en tu último mensaje. Dos días, sin respuesta.",
    "success_looks_like": "La persona manda un mensaje ligero que no menciona el silencio."
  }$j$::jsonb,
  'Hoy, cuando algo se quede sin responder, manda un empujoncito y déjalo ahí. Apunta qué mandaste y qué volvió.',
  $j${
    "beats": [
      {
        "situation": "Propusiste el jueves o el sábado. Dos días, nada de vuelta.",
        "prompt": "¿Qué mandas?",
        "options": [
          { "text": "¿Has visto mi mensaje?", "correct": false, "note": "Convierte el silencio en el tema y les pide explicaciones antes de poder responder nada." },
          { "text": "Una segunda propuesta más fácil, para ponérselo más sencillo.", "correct": false, "note": "Dos peticiones apiladas sobre un silencio suenan a presión por muy ligero que esté escrito." },
          { "text": "Un mensaje ligero sobre lo que ya estabais hablando.", "correct": true, "note": "No da nada por hecho y les deja reaparecer sin explicar el hueco. Si no consigue nada de vuelta, se acabó." },
          { "text": "Nada — está claro que lo han visto.", "correct": false, "note": "Es verdad, y a la gente se le desborda todo y tiene intención de responder. Un empujoncito es gratis; es el segundo el que cuesta." }
        ]
      },
      {
        "situation": "«Ah, no puedo el jueves, ando fatal de tiempo ahora mismo — ¡perdona!»",
        "prompt": "¿Sí o no?",
        "options": [
          { "text": "Un no. Volvió un motivo, no un momento.", "correct": true, "note": "Mecánico, que es lo que lo hace usable cuando estás ansioso. La calidez y la disculpa son el envoltorio; la ausencia de una alternativa es el mensaje." },
          { "text": "Un sí con un problema de horarios.", "correct": false, "note": "Esa versión te devuelve un día. Esta te devuelve una explicación, y la diferencia es toda la prueba." },
          { "text": "Ambiguo — ofrece la semana siguiente.", "correct": false, "note": "Ofrecer tú la alternativa que ellos decidieron no ofrecer es pedirles que rechacen dos veces." },
          { "text": "Imposible de saber por un mensaje de texto.", "correct": false, "note": "Es uno de los mensajes más legibles que vas a recibir. Vuelve un momento, o vuelve un motivo." }
        ]
      }
    ]
  }$j$::jsonb
);
