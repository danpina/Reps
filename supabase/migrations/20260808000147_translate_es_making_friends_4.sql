-- Spanish: Hacer amigos, track 4 — Ir más allá de lo agradable.
--
-- Conventions as prior tracks: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Sam" (lessons 1, 5) carries no `sex` field; masculine
-- agreement used by default, as established elsewhere in this topic.
-- "Alex" (lessons 2-4) is feminine throughout. Lesson 3 is [scene] mode,
-- so its rehearsal_spec stays an empty object, matching the English
-- source.

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

select pg_temp.es_lesson('getting-past-pleasant', 1,
  'Cuatro años, ningún avance',
  $md$Hay un tipo de relación que puede durar años sin convertirse en nada, y no es una amistad fallida — es un arreglo estable que ninguna de las dos personas ha intentado nunca cambiar.

La ves con regularidad. Te cae bien, de verdad. Habláis del trabajo, del fútbol, del tiempo, de lo que sale en las noticias, del tráfico para llegar hasta aquí. Los dos describiríais al otro como alguien con quien os lleváis bien. Ninguno de los dos podría decir qué le preocupa de verdad al otro, qué le alegra, o con qué está lidiando.

**La jugada:** date cuenta de que la barrera no es el tiempo ni el que os caigáis bien.

Merece la pena decirlo porque las dos son las explicaciones habituales y las dos están equivocadas. Has tenido el tiempo — cuatro años de él. Tienes el que os caigáis bien. Lo que nunca ha pasado es que alguien pase de hablar de *cosas* a hablar de *sí mismo*, y no hay ningún mecanismo por el que eso pase solo.

La superficie agradable es genuinamente cómoda, que es por lo que persiste. Nadie se aburre. Cada conversación individual está bien. Solo se hace visible como problema cuando te das cuenta de que no sabrías si esta persona estuviera teniendo el peor año de su vida, y de que ella tampoco lo sabría de ti.

Y es simétrico, que es la parte útil. No te está ocultando nada. Está haciendo exactamente lo que haces tú — ser agradable, esperar un momento natural, y no conseguirlo nunca, porque el registro agradable no tiene ninguna salida natural. Se sostiene a sí mismo a la perfección.

Lo último que merece la pena decir: aquí es donde está de verdad la vida social de la mayoría de la gente. No solo en el sentido de no tener a nadie, sino rodeado de gente que no la conoce, que es un tipo de soledad concreto y mucho menos obvio y que no se arregla conociendo a nadie nuevo.

Si te quedas con una cosa: no pasa nada malo y nada lo va a cambiar. Alguien tiene que moverse primero, y la siguiente lección es cómo.$md$,
  $j$[
    {
      "situation": "Cuatro años de conversación semanal con alguien que te cae bien.",
      "line": "(¿qué le preocupa?)",
      "why": "Si no lo sabes, y ella tampoco lo sabe de ti, la relación ha estado estable en vez de desarrollándose."
    },
    {
      "situation": "Asumes que se hará más profunda con más tiempo.",
      "line": "(has tenido cuatro años)",
      "why": "El tiempo y que os caigáis bien son las explicaciones habituales y las dos ya están presentes. Lo que nunca ha pasado es que ninguno de los dos pase de las cosas a vosotros mismos."
    },
    {
      "situation": "Te sientes rodeado de gente y aun así desconocido.",
      "line": "(esto es eso, y conocer gente nueva no lo arregla)",
      "why": "Es un tipo de soledad distinto al de no tener a nadie, y es mucho menos obvio — que es por lo que la gente intenta resolverlo añadiendo más de lo mismo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué persiste la superficie agradable?",
      "options": [
        { "text": "Porque ninguno de los dos está tan interesado.", "correct": false, "note": "Os caéis bien, que es lo que hace que merezca la pena arreglar esto en vez de abandonarlo." },
        { "text": "Porque es cómoda y no tiene ninguna salida natural.", "correct": true, "note": "Nadie se aburre, cada conversación individual está bien, y el registro se sostiene a sí mismo a la perfección. No hay ningún momento en el que termine por sí solo." },
        { "text": "Porque no os veis lo suficiente.", "correct": false, "note": "Semanal durante cuatro años es de sobra contacto. La frecuencia no es el ingrediente que falta aquí — era el ingrediente que faltaba hace dos bloques." },
        { "text": "Porque uno de los dos es reservado.", "correct": false, "note": "Normalmente ninguno lo es. Es simétrico, y las dos personas están esperando el mismo momento." }
      ],
      "explain": "Es un arreglo estable en vez de uno fallido, que es por lo que necesita que alguien se mueva."
    },
    {
      "prompt": "¿Por qué es difícil detectar este tipo de soledad?",
      "options": [
        { "text": "Solo se nota en una crisis.", "correct": false, "note": "Ese es el momento en que se vuelve innegable, no el momento en que empieza." },
        { "text": "La gente no lo admite.", "correct": false, "note": "En parte, y pasa desapercibido más a menudo de lo que se oculta." },
        { "text": "Estás rodeado de gente, así que nada parece ir mal.", "correct": true, "note": "No solo en el sentido de no tener a nadie — rodeado de gente que no te conoce, que es por lo que conocer a más gente no lo arregla." },
        { "text": "Llega despacio.", "correct": false, "note": "Cierto de muchas cosas y no lo bastante específico como para ser útil." }
      ],
      "explain": "El arreglo es profundidad con la gente que ya ves, no más gente."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "noticed", "label": "Notó el arreglo", "description": "Lo vio como estable en vez de como desarrollándose." },
      { "key": "symmetry", "label": "Vio la simetría", "description": "Reconoció que la otra persona está haciendo lo mismo." },
      { "key": "not_time", "label": "Dejó de esperar al tiempo", "description": "Aceptó que más de lo mismo no cambia nada." },
      { "key": "named_someone", "label": "Nombró a alguien", "description": "Identificó a una persona real a quien describe esto." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un viejo amigo con quien estás hablando",
      "mood": "Curioso, sin querer demostrar nada.",
      "openness": 5,
      "personality": "Hace preguntas sencillas sobre la persona — qué le preocupa, cómo le ha ido el año — y deja que el silencio se asiente."
    },
    "setting": "Un amigo te ha preguntado por alguien a quien mencionas a menudo y ves cada semana, y te has dado cuenta de que no puedes responder preguntas básicas sobre esa persona.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Haz preguntas corrientes sobre la vida de la otra persona y espera.",
      "No llenes el silencio cuando la persona no pueda responder.",
      "Nunca nombres tú el patrón."
    ],
    "opening_beat": "«La ves cada semana. ¿Qué le pasa por la vida ahora mismo?»",
    "success_looks_like": "La persona se da cuenta de que la relación ha estado estable en vez de haciéndose más profunda."
  }$j$::jsonb,
  'Hoy, elige a alguien a quien veas a menudo e intenta decir qué le preocupa ahora mismo. Apunta si pudiste.',
  $j${
    "beats": [
      {
        "situation": "Has hablado con alguien cada semana durante cuatro años. No podrías decir qué le preocupa ahora mismo, y ella tampoco podría decirlo de ti.",
        "prompt": "¿Qué es eso?",
        "options": [
          { "text": "Una amistad que no ha tenido suficiente tiempo.", "correct": false, "note": "Cuatro años es el tiempo. Nada de esperar más cambia lo que ya se ha demostrado." },
          { "text": "Un arreglo estable que ninguno de los dos ha intentado cambiar.", "correct": true, "note": "Nadie se aburre, cada conversación está bien, y el registro agradable no tiene ninguna salida natural. Se sostiene a sí mismo a la perfección." },
          { "text": "Prueba de que es una persona reservada.", "correct": false, "note": "Normalmente ninguno de los dos lo es. Es simétrico — está haciendo exactamente lo que haces tú." },
          { "text": "Normal para las amistades adultas.", "correct": false, "note": "Habitual, que no es lo mismo que inevitable, y ahí es donde está la vida social de la mayoría de la gente en silencio." }
        ]
      },
      {
        "situation": "Te sientes rodeado de gente y aun así ninguna te conoce.",
        "prompt": "¿Qué pide eso?",
        "options": [
          { "text": "Conocer a más gente.", "correct": false, "note": "Añade más de la misma relación. Este es un tipo de soledad distinto al de no tener a nadie y no se resuelve con volumen." },
          { "text": "Aceptar que la amistad adulta es más superficial.", "correct": false, "note": "Una resignación disfrazada de realismo, y la contradice cualquiera que tenga un amigo cercano." },
          { "text": "Profundidad con la gente que ya ves.", "correct": true, "note": "La infraestructura ya está ahí — contacto semanal, que os caigáis bien mutuamente. Lo que nunca ha pasado es que ninguno de los dos pase de las cosas a vosotros mismos." },
          { "text": "Reconectar con viejos amigos que ya te conocen.", "correct": false, "note": "Merece la pena hacerlo, y es el bloque cinco. No aborda a las cuatro personas que ves cada semana." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('getting-past-pleasant', 2,
  'Ofrece, no preguntes',
  $md$El instinto, una vez que has notado la superficie, es hacer una pregunta más grande. No funciona, y merece la pena saber por qué antes de gastar una buena relación averiguándolo.

*¿Cómo estás, de verdad?* pone a alguien entre la espada y la pared. Le pide que vaya primero, en un registro que ninguno de los dos ha usado, sin previo aviso y sin cobertura — y la respuesta casi universal es una evasiva, entregada con calidez, seguida de que los dos volváis al tiempo un poco avergonzados.

**La jugada:** di algo verdadero sobre ti mismo en su lugar, y hazlo pequeño.

*Este año se me está haciendo bastante difícil, la verdad.* *Le tengo pavor a la Navidad.* *Ahora mismo no tengo ni idea de qué hago en el trabajo.* Cada una de esas lleva cuatro segundos, no exige nada de la otra persona, y hace lo único que una pregunta no puede: baja el nivel sin pedirle permiso a nadie.

La diferencia está en dónde se sitúa la exposición. Una pregunta le pide a la otra persona que asuma el riesgo. Una oferta lo asume uno mismo, y en cuanto lo has hecho, el registro ha cambiado para los dos y ella puede corresponderte o no.

Lo que suele volver es alivio, y a menudo más de lo que diste. La mayoría de la gente está manteniendo la misma superficie agradable, la dejaría encantada, y ha estado esperando a que alguien más lo hiciera posible — que es por lo que el cambio a menudo pasa dentro de una sola conversación y se queda.

Mantenlo pequeño y mantenlo verdadero. Esto no es una confesión y no es un intento de conseguir compasión; el objetivo es algo real a bajo volumen, no algo pesado a alto volumen. Y dilo con sencillez en vez de como una broma, porque la versión autocrítica es una forma de decir algo mientras se mantiene la salida abierta, y normalmente provoca risas en vez de correspondencia.

Si te quedas con una cosa: ofrece, no preguntes. Ir primero es toda la jugada, y cuesta unos cuatro segundos.$md$,
  $j$[
    {
      "situation": "Quieres ir más allá del tiempo con alguien que te cae bien.",
      "line": "Este año se me está haciendo bastante difícil, la verdad.",
      "why": "Cuatro segundos, no exige nada de ella, y baja el nivel sin pedir permiso. Una oferta asume el riesgo uno mismo."
    },
    {
      "situation": "Estás a punto de preguntar cómo está de verdad.",
      "line": "(eso le pide que vaya primero)",
      "why": "En un registro que ninguno de los dos ha usado, sin previo aviso. La respuesta casi universal es una evasiva cálida y una vuelta al tiempo."
    },
    {
      "situation": "Estás a punto de decirlo como una broma para que sea negable.",
      "line": "(dilo con sencillez)",
      "why": "La versión autocrítica mantiene la salida abierta, y provoca risas en vez de correspondencia."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué falla hacer una pregunta más grande?",
      "options": [
        { "text": "Es demasiado entrometida.", "correct": false, "note": "Rara vez se experimenta como entrometida. Se experimenta como difícil de responder." },
        { "text": "Le pide a ella que asuma el riesgo primero.", "correct": true, "note": "En un registro que ninguno de los dos ha usado, sin cobertura. La respuesta casi universal es una evasiva cálida seguida del tiempo." },
        { "text": "La gente no sabe cómo está de verdad.", "correct": false, "note": "Normalmente sí lo sabe. Lo que le falta es un motivo para decirlo en esta conversación en concreto." },
        { "text": "Suena ensayada.", "correct": false, "note": "Puede sonarlo, e incluso preguntada de forma completamente natural produce la misma evasiva." }
      ],
      "explain": "Una oferta asume el riesgo uno mismo, y en cuanto se asume, el registro ha cambiado para los dos."
    },
    {
      "prompt": "¿Qué hace que una primera oferta sea buena?",
      "options": [
        { "text": "Algo significativo, para que sea claramente genuino.", "correct": false, "note": "El peso no es lo que lo demuestra. Algo pesado a alto volumen es contar de más, y le llega como algo que tiene que sostener." },
        { "text": "Algo pequeño, verdadero, y dicho con sencillez.", "correct": true, "note": "Cuatro segundos, sin necesitar permiso, sin dejar la salida abierta. Algo real a bajo volumen en vez de algo pesado a alto volumen." },
        { "text": "Algo de lo que te puedas reír.", "correct": false, "note": "La versión autocrítica mantiene la salida abierta, y provoca risas en vez de correspondencia." },
        { "text": "Algo que tengas en común con ella.", "correct": false, "note": "Todavía no puedes saber qué es eso — para eso sirve todo el ejercicio." }
      ],
      "explain": "Pequeña, verdadera, con sencillez. Esa es toda la especificación."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "offered", "label": "Ofreció en vez de preguntar", "description": "Dijo algo sobre sí mismo en vez de hacer una pregunta grande." },
      { "key": "small", "label": "Lo mantuvo pequeño", "description": "Algo real a bajo volumen." },
      { "key": "plain", "label": "Lo dijo con sencillez", "description": "No lo escondió en una broma." },
      { "key": "true", "label": "Fue verdad", "description": "Dijo algo que de verdad era el caso en vez de algo seguro." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Alex",
      "role": "alguien a quien ves cada semana y de quien no sabes casi nada",
      "mood": "Cómoda, sin prisa.",
      "openness": 4,
      "personality": "Agradable y superficial por defecto, y notablemente aliviada cuando se dice algo real — normalmente devolviendo algo más grande."
    },
    "setting": "La conversación semanal de siempre con alguien a quien conoces desde hace años. Ha ido sobre el tiempo y el aparcamiento durante unos seis minutos.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Desvía con calidez y vuelve a la superficie si te preguntan una pregunta grande.",
      "Corresponde a cualquier oferta genuina con algo real propio, y alivio visible.",
      "Nunca digas nada real primero."
    ],
    "opening_beat": "«Está fatal ahí fuera otra vez. Todavía no han arreglado ese desagüe.»",
    "success_looks_like": "La persona ofrece algo verdadero sobre sí misma en vez de hacer una pregunta."
  }$j$::jsonb,
  'Hoy, di algo pequeño y verdadero sobre ti mismo a alguien que no lo sepa. Apunta qué dijiste y qué volvió.',
  $j${
    "says": "Está fatal ahí fuera otra vez. Todavía no han arreglado ese desagüe.",
    "model": {
      "line": "Es horrible. Voy a ser sincero, en general han sido unos meses bastante difíciles, así que el desagüe no ayuda.",
      "why": "Pequeño, verdadero, dicho con sencillez y ofrecido en vez de extraído. Baja el nivel sin pedirle permiso a nadie, y lleva cuatro segundos."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Di algo sobre ti" },
      { "kind": "no_question", "requirement": "Ofrece, no preguntes — una pregunta la pone entre la espada y la pared" },
      { "kind": "forbids_any", "words": ["jaja", "ja ja", "ignórame", "no me hagas caso", "siendo dramático", "primer mundo", "perdona por ser", "cursi", "demasiado profundo"], "requirement": "No lo escondas en una broma o una evasiva" },
      { "kind": "min_words", "n": 10, "requirement": "Algo real, no un gesto vacío" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('getting-past-pleasant', 3,
  'Un peldaño cada vez',
  $md$Contar cosas es una escalera exactamente igual que el contacto físico, y se aplican las mismas reglas: un peldaño, lee qué vuelve, y luego decide sobre el siguiente.

**La jugada:** da un paso más allá de donde estás, y luego para y mira.

Los peldaños se reconocen en cuanto se nombran. Datos sobre tu vida — dónde vives, qué hiciste el fin de semana. Opiniones y preferencias — qué piensas sobre algo que importa un poco. Dificultades actuales a bajo volumen — el año ha sido duro, el trabajo está raro ahora mismo. Y las cosas con las que de verdad estás lidiando, que es donde está una amistad.

Casi toda relación estancada está estancada entre el primer y el segundo peldaño, y se mueve uno cada vez desde ahí.

Lo que estás leyendo es si te corresponde. Alguien que recibe algo real y te devuelve algo ha tomado el peldaño — eso es un sí, y el siguiente paso está disponible, normalmente dentro de la misma conversación. Alguien que lo recibe con calidez y no da nada no lo ha tomado, y la respuesta correcta es quedarse en ese nivel en vez de subir solo.

Subir solo es el fallo que merece la pena nombrar, porque es lo que produce contar de más. Nadie planea decir demasiado. Lo que pasa es que una persona sigue subiendo peldaños sin comprobar, el hueco entre los dos se ensancha, y para la cuarta confidencia no correspondida se ha convertido en algo que quien escucha tiene que gestionar en vez de algo que se comparte.

Y no lo exijas en una sola conversación. La superficie se reafirma — vas a tener un intercambio real en octubre y vas a volver al tiempo en noviembre, que es normal y no es un retroceso. Hacen falta unas cuantas veces antes de que el registro se asiente en el nuevo nivel, y se asienta por repetición y no porque nadie lo decida.

Si te quedas con una cosa: un peldaño, y luego lee. Toda la diferencia entre la profundidad y contar de más es si comprobaste.$md$,
  $j$[
    {
      "situation": "Dijiste algo real y ella te devolvió algo.",
      "line": "(peldaño tomado — el siguiente está disponible)",
      "why": "Que te correspondan es el sí. Normalmente está disponible dentro de la misma conversación, y así es cómo cambia una relación en una tarde."
    },
    {
      "situation": "Dijiste algo real y conseguiste calidez y nada más.",
      "line": "(quédate en este nivel por ahora)",
      "why": "No ha tomado el peldaño. Subir solo es precisamente lo que produce contar de más, y nadie planea hacerlo."
    },
    {
      "situation": "Tuvisteis una conversación real en octubre y en noviembre habéis vuelto al tiempo.",
      "line": "(eso es normal, no un retroceso)",
      "why": "La superficie se reafirma. El registro se asienta en un nuevo nivel por repetición y no porque nadie lo decida."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué estás leyendo después de contar algo?",
      "options": [
        { "text": "Si parecía cómoda.", "correct": false, "note": "La mayoría de la gente parece cómoda, porque la mayoría de la gente es educada. La comodidad no es la señal." },
        { "text": "Si te correspondió con algo propio.", "correct": true, "note": "Que te correspondan es el sí. Calidez sin nada detrás significa que el peldaño no se tomó, y el nivel debería quedarse donde está." },
        { "text": "Si hizo una pregunta de seguimiento.", "correct": false, "note": "Una buena señal y puede ser pura educación. Devolver algo cuesta más y significa más." },
        { "text": "Si cambió de tema.", "correct": false, "note": "Útil cuando pasa y una prueba demasiado tosca. Mucha gente recibe algo bien y luego sigue adelante de forma natural." }
      ],
      "explain": "Un peldaño, y luego lee. Que te correspondan es lo que hace disponible el siguiente."
    },
    {
      "prompt": "¿Qué produce de verdad contar de más?",
      "options": [
        { "text": "Decir algo demasiado pesado.", "correct": false, "note": "El peso importa menos que la posición. Algo pesado dicho en el peldaño correcto está bien." },
        { "text": "El alcohol.", "correct": false, "note": "La ocasión, no la causa, y mucho contar de más pasa tomando café." },
        { "text": "Confiar demasiado rápido en alguien.", "correct": false, "note": "Cómo se describe después. En el momento casi nunca es un juicio sobre la otra persona en absoluto." },
        { "text": "Subir sin comprobar si te seguían.", "correct": true, "note": "El hueco se ensancha, y para la cuarta confidencia no correspondida es algo que quien escucha tiene que gestionar en vez de algo compartido." }
      ],
      "explain": "Nadie planea decir demasiado. Simplemente nunca miraron atrás para ver quién seguía con ellos."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_rung", "label": "Subió un peldaño", "description": "Se movió un solo paso en vez de varios." },
      { "key": "read", "label": "Leyó qué volvía", "description": "Comprobó si le correspondían antes de continuar." },
      { "key": "stayed", "label": "Se quedó en el nivel cuando no le correspondieron", "description": "No subió solo." },
      { "key": "patient", "label": "Permitió que llevara varios intentos", "description": "No trató una vuelta a la superficie como un retroceso." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Alex",
      "role": "alguien a quien ves cada semana y a quien estás empezando a conocer de verdad",
      "mood": "Atento.",
      "openness": 4,
      "personality": "Corresponde a un primer comentario honesto con algo real propio, y luego sigue a donde vaya el nivel — incluido incomodarse si sube varios peldaños de golpe."
    },
    "setting": "Dijiste algo honesto sobre tu año hace un momento. Lo que pase después depende por completo de qué haga ella con eso.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Iguala el nivel de la persona y da algo propio cada vez que te corresponda.",
      "Ponte visiblemente incómoda y quédate más callada si la persona salta varios peldaños de golpe.",
      "Nunca lleves tú el nivel."
    ],
    "opening_beat": "«...la verdad, lo mismo. Ha sido un año raro por aquí también, si te digo la verdad.»",
    "success_looks_like": "La persona sube un peldaño más en vez de varios, y sigue leyendo."
  }$j$::jsonb,
  'Hoy, sube un peldaño más con alguien de lo que harías normalmente, y luego para y fíjate en si te siguió. Apunta las dos cosas.',
  $j${}$j$::jsonb
);

select pg_temp.es_lesson('getting-past-pleasant', 4,
  'Di la cosa cálida en voz alta',
  $md$Hay una categoría de frase que casi nadie le dice a sus amigos, y decirla es una de las cosas con más retorno de toda esta aplicación.

*Me alegro mucho de que empezáramos a hacer esto.* *Eres una de las pocas personas a quien le puedo decir eso.* *Siempre me siento mejor después de estas quedadas.* Todo verdadero, todo fácil de pensar, y todo de alguna forma indecible — por un motivo que merece la pena nombrar, que es que decir algo cálido sin ninguna broma pegada se siente enormemente expuesto, y el acto reflejo es desviarlo hacia el humor antes de que aterrice.

**La jugada:** di la cosa cálida con sencillez, una vez, y no la socaves.

Socavarla es la parte a vigilar. *Me alegro mucho de que hagamos esto — Dios, qué cursi ha sonado eso* borra la frase que acabas de decir, y a quien escucha le queda la retractación en vez de la cosa en sí. Todo el valor está en los cuatro segundos en los que se le deja quedarse en pie.

Lo que hace es desproporcionado. Casi nadie oye esto. La mayoría de la gente no tiene ni idea de si sus amigos la valoran específicamente, porque todo el mundo mantiene la misma reticencia — así que una frase sencilla aterriza como algo inusual y se recuerda durante años, que es un retorno raro para once palabras.

También es lo que convierte a un buen conocido en un amigo más rápido que cualquier cantidad de tiempo compartido. La profundidad no va solo sobre dificultades; decir que alguien importa es su propio peldaño, y a menudo uno más fácil que decir que lo estás pasando mal.

Dos notas prácticas. Lo concreto gana a lo general — *estos martes son lo mejor de mi semana* es mejor que *eres un gran amigo*, porque nombra algo real en vez de otorgar un título. Y espera torpeza en la respuesta: la gente en particular la va a absorber mal y va a decir algo torpe, y eso no es un fracaso. Lo ha oído, y lo va a recordar mucho después de la respuesta torpe.

Si te quedas con una cosa: dilo y déjalo estar. Socavarlo es la única forma de hacerlo mal.$md$,
  $j$[
    {
      "situation": "Lleváis un año quedando cada mes y se ha convertido en la mejor parte del mes.",
      "line": "Estos martes son de verdad lo mejor de mi mes.",
      "why": "Concreto en vez de un título otorgado. Casi nadie oye esto, que es por lo que once palabras se recuerdan durante años."
    },
    {
      "situation": "Lo has dicho y el silencio se siente enorme.",
      "line": "(no añadas nada)",
      "why": "Socavarlo borra la frase y le deja con la retractación. El valor está en los cuatro segundos en los que se queda en pie."
    },
    {
      "situation": "Responde con algo torpe y cambia de tema.",
      "line": "(lo ha oído)",
      "why": "Una respuesta torpe no es un fracaso. Va a recordar la frase mucho después de haber olvidado cómo la respondió."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la única forma de hacer esto mal?",
      "options": [
        { "text": "Decirlo demasiado pronto en una amistad.", "correct": false, "note": "Pronto está bien, siempre que sea verdadero y concreto. A nadie le ha importado que le digan que es buena compañía." },
        { "text": "Socavarlo de inmediato.", "correct": true, "note": "Dios, qué cursi ha sonado eso borra la frase y le deja con la retractación. Todo el valor está en los segundos en los que se le deja quedarse en pie." },
        { "text": "Hacerlo demasiado concreto.", "correct": false, "note": "Concreto es la mejor versión. General es un título otorgado en vez de algo notado." },
        { "text": "Decirlo en público.", "correct": false, "note": "El entorno apenas importa. Lo que importa es si sobrevive a los siguientes cuatro segundos." }
      ],
      "explain": "Dilo y déjalo estar. El silencio torpe de después está haciendo el trabajo."
    },
    {
      "prompt": "¿Por qué aterriza con tanta fuerza?",
      "options": [
        { "text": "La gente es insegura y necesita que la tranquilicen.", "correct": false, "note": "Una lectura un poco desoladora, y funciona también con gente completamente segura de sí misma." },
        { "text": "Es inesperado en el momento.", "correct": false, "note": "La sorpresa es parte de ello y se desvanecería. Esto se recuerda durante años, que necesita una explicación mejor." },
        { "text": "Casi nadie sabe si sus amigos la valoran específicamente.", "correct": true, "note": "Todo el mundo mantiene la misma reticencia, así que a la mayoría de la gente sencillamente nunca se lo han dicho. Por eso se recuerdan once palabras corrientes." },
        { "text": "Le da permiso para decirlo de vuelta.", "correct": false, "note": "A menudo pasa y no es por lo que importa. Aterrizaría igual aunque no dijera nada." }
      ],
      "explain": "Decir que alguien importa es su propio peldaño, y a menudo uno más fácil que decir que lo estás pasando mal."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_it", "label": "Lo dijo con sencillez", "description": "Nombró la cosa cálida sin ninguna broma delante." },
      { "key": "no_undercut", "label": "No lo socavó", "description": "Lo dejó en pie en vez de retractarse." },
      { "key": "specific", "label": "Fue concreto", "description": "Nombró algo real en vez de otorgar un título." },
      { "key": "allowed_awkward", "label": "Permitió la respuesta torpe", "description": "No trató una respuesta torpe como un fracaso." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Alex",
      "role": "una amiga con quien llevas un año quedando cada mes",
      "mood": "Cómoda, a punto de irse.",
      "openness": 4,
      "personality": "Recibe la calidez mal y con gratitud a la vez — dice algo torpe, se pone un poco colorada, y claramente lo dice en serio. Sigue cualquier broma de vuelta hacia la seguridad."
    },
    "setting": "El final de un café mensual que lleváis teniendo un año. Se ha convertido en la mejor hora de tu mes y nunca lo has dicho.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con torpeza y calidez a cualquier cosa sincera, y no lo suavices.",
      "Toma cualquier broma como una salida y vuelve a la logística de inmediato.",
      "Nunca digas nada cálido primero."
    ],
    "opening_beat": "«Vale — a la misma hora el mes que viene, entonces.»",
    "success_looks_like": "La persona dice la cosa cálida con sencillez y no la socava."
  }$j$::jsonb,
  'Hoy, dile a alguien una cosa concreta que valoras de esa persona, y no la socaves. Apunta la frase.',
  $j${
    "says": "Vale — a la misma hora el mes que viene, entonces.",
    "model": {
      "line": "Sí. Y la verdad, estos martes son lo mejor de mi mes.",
      "why": "Concreto en vez de un título otorgado, dicho con sencillez, y nada después. Casi nadie oye esto, que es por lo que once palabras se recuerdan durante años."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["cursi", "sensiblero", "perdona", "ignora eso", "demasiado", "bueno", "Dios", "qué raro", "no hagas que sea", "incómodo"], "requirement": "No lo socaves" },
      { "kind": "max_sentences", "n": 2, "requirement": "Dilo y déjalo estar" },
      { "kind": "min_words", "n": 8, "requirement": "Nombra la cosa concreta" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('getting-past-pleasant', 5,
  'Cuando no vuelve nada',
  $md$A veces subes un peldaño y no viene nada contigo. Merece la pena saber qué es eso y qué no es, porque las dos lecturas llevan a sitios muy distintos.

**La jugada:** trata un peldaño no correspondido como información sobre capacidad, no sobre ti.

Las explicaciones más comunes no tienen nada que ver con tu valía como amigo. Alguna gente ya tiene todos los amigos cercanos que puede mantener y no está buscando otro — una postura completamente razonable que nadie anuncia nunca. Alguna está en un periodo en el que no le sobra nada. Alguna no hace esto a ninguna profundidad con nadie, incluida gente que conoce desde hace treinta años, y es perfectamente feliz.

Nada de eso es visible desde fuera, y nada de ello es un veredicto.

Lo que sí significa es que esta relación es lo que es, y eso puede estar perfectamente bien. Una conversación semanal agradable con alguien que te cae bien es algo bueno de tener. El error no es que se quedara agradable — es pasarte tres años más asumiendo que está a punto de convertirse en algo, y decepcionarte en silencio de una relación que nunca estuvo fallando.

Así que calibra en vez de retirarte. No te enfríes, no dejes de ser cálido, y no decidas que es un amigo de menos categoría. Sencillamente deja de invertir en un nivel que no te corresponden, y pon ese esfuerzo donde sí te corresponden — que es una redirección y no un castigo, y es invisible para la otra persona.

Y déjalo abierto. La gente cambia. Alguien a quien no le sobraba nada en un mal año es una persona distinta dieciocho meses después, y un peldaño que no se tomó en marzo puede tomarse el marzo siguiente exactamente por las mismas dos personas.

Si te quedas con una cosa: es mucho mejor averiguarlo en un peldaño que en cuatro años. Ese es todo el sentido de ir primero.$md$,
  $j$[
    {
      "situation": "Ofreciste algo real y conseguiste calidez y nada de vuelta.",
      "line": "(información sobre capacidad, no sobre ti)",
      "why": "Alguna gente ya tiene todos los amigos cercanos que puede mantener, a alguna no le sobra nada este año, y alguna no hace esto con nadie. Nada de eso es visible desde fuera."
    },
    {
      "situation": "Tienes la tentación de ser un poco más frío con ella ahora.",
      "line": "(calibra, no te retires)",
      "why": "Deja de invertir en un nivel que no te corresponden y ponlo donde sí. Eso es una redirección y no un castigo, y es invisible para ella."
    },
    {
      "situation": "Se ha quedado agradable durante otro año.",
      "line": "(eso puede ser perfectamente algo bueno)",
      "why": "El error no es que se quedara agradable. Son tres años asumiendo que está a punto de convertirse en otra cosa."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué suele significar un peldaño no correspondido?",
      "options": [
        { "text": "No le gustas tanto como pensabas.", "correct": false, "note": "La lectura que produce la retirada, y la contradice el hecho de que siga apareciendo." },
        { "text": "Calculaste mal el momento.", "correct": false, "note": "De vez en cuando, e implica que existe un momento correcto que podrías haber encontrado. Normalmente no va sobre el momento en absoluto." },
        { "text": "Algo sobre su capacidad, que es invisible desde fuera.", "correct": true, "note": "Todos los amigos cercanos que puede mantener, un año en el que no le sobra nada, o alguien que no hace esto con nadie. Nada de eso es un veredicto." },
        { "text": "Fuiste demasiado lejos demasiado rápido.", "correct": false, "note": "Posible y comprobable — un pequeño peldaño rara vez es demasiado rápido. Si lo fue, la lección anterior lo cubre." }
      ],
      "explain": "Mejor averiguarlo en un peldaño que en cuatro años. Eso es lo que te compra ir primero."
    },
    {
      "prompt": "¿Cuál es la respuesta correcta?",
      "options": [
        { "text": "Inténtalo otra vez con algo más grande.", "correct": false, "note": "Subir solo, que es lo que produce contar de más. Un peldaño no correspondido no se responde con uno más grande." },
        { "text": "Acepta la amistad tal como es y deja de invertir por encima de ese nivel.", "correct": true, "note": "Calibración en vez de retirada. Mantente exactamente igual de cálido, pon el esfuerzo donde sí te corresponden, y deja la puerta abierta — la gente cambia." },
        { "text": "Sé un poco más frío, para que esté equilibrado.", "correct": false, "note": "Un castigo por algo que nunca fue un desaire, y es visible de una forma en que la calibración no lo es." },
        { "text": "Pregúntale directamente si quiere estar más cerca.", "correct": false, "note": "Convierte la relación en el tema de la relación, y pone a alguien entre la espada y la pared sobre algo para lo que puede que no tenga palabras." }
      ],
      "explain": "Redirige el esfuerzo, conserva la calidez, y déjalo abierto."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "not_personal", "label": "No se lo tomó personalmente", "description": "Lo leyó como capacidad en vez de como veredicto." },
      { "key": "no_withdrawal", "label": "No se enfrió", "description": "Se mantuvo exactamente igual de cálido que antes." },
      { "key": "redirected", "label": "Redirigió el esfuerzo", "description": "Puso la inversión donde sí le correspondían." },
      { "key": "left_open", "label": "Lo dejó abierto", "description": "No cerró la puerta a un intento posterior." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un viejo amigo con quien lo estás hablando",
      "mood": "Sereno.",
      "openness": 5,
      "personality": "Pregunta cómo es de verdad la relación ahora, y cuestiona cualquier plan que implique ser más frío."
    },
    "setting": "Subiste un peldaño con alguien hace dos semanas. Fue amable al respecto, no dio nada de vuelta, y todo desde entonces ha sido exactamente igual de agradable que antes.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Cuestiona cualquier plan de enfriarte o de intentarlo otra vez con algo más grande.",
      "Acepta un plan de dejarlo tal como está e invertir en otro sitio.",
      "Nunca ofrezcas una explicación para el comportamiento de la otra persona."
    ],
    "opening_beat": "«Entonces no picó. ¿Qué vas a hacer al respecto?»",
    "success_looks_like": "La persona calibra sin retirar la calidez ni tomárselo personalmente."
  }$j$::jsonb,
  'Hoy, fíjate en una relación que es agradable y no se hace más profunda. Decide disfrutarla tal como es. Apunta cuál.',
  $j${
    "says": "Entonces no picó. ¿Qué vas a hacer al respecto?",
    "model": {
      "line": "Nada, la verdad — dejarlo tal como está. Es una buena conversación semanal y no tiene que ser más que eso.",
      "why": "Calibración en vez de retirada. La relación nunca estuvo fallando, y el error sería tres años más asumiendo que está a punto de convertirse en otra cosa."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["retirarme", "enfriarme", "distancia", "no vale la pena", "desperdicio", "culpa mía", "dije demasiado", "avergonzado", "no debería haber"], "requirement": "No te retires, y no te lo tomes personalmente" },
      { "kind": "min_words", "n": 10, "requirement": "Di qué vas a hacer de verdad" },
      { "kind": "max_words", "n": 40, "requirement": "Una decisión, no una autopsia" }
    ]
  }$j$::jsonb
);
