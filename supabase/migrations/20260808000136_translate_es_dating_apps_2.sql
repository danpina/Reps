-- Spanish: Apps de citas, track 2 — El primer mensaje.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, partner.alt sex-swap structures preserved and both halves
-- fully translated, character names left alone (Senan/Sena, Marek/
-- Marguerite, Ioan/Iona, Ruaridh/Robyn, Vasil/Vesna).
--
-- "Hey" (the too-lazy opener) is rendered as "hola", the natural Spanish
-- equivalent of a zero-effort dating-app opener.

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

select pg_temp.es_lesson('first-message', 1,
  'Hola no es un mensaje',
  $md$No es de mala educación y no es vago. Simplemente no contiene nada.

Un mensaje tiene que poder responderse. *Hola* le pide a la otra persona que invente una conversación de la nada, decida qué te podría interesar, y lleve ella sola los tres primeros intercambios. Tiene otras once personas pidiéndole eso mismo esta semana, y a quienes responde son a quienes se lo pusieron fácil.

**La jugada:** mete algo concreto que puedan responder en una frase.

Concreto es la palabra que hace el trabajo, no ingenioso. Una pregunta sobre lo que de verdad hay en su tercera foto es mejor que cualquier cosa que pudieras componer, porque demuestra que has mirado y porque tiene una respuesta obvia. Nadie ha dejado nunca de responder porque un mensaje no fuera lo bastante ingenioso.

El otro motivo por el que funciona es lo que dice de ti. Un mensaje que podría habérsele mandado a cualquiera le dice que probablemente se lo mandaste a cualquiera, y cada perfil ya se ha topado con una docena de esos este mes.$md$,
  $j$[
    {
      "situation": "Su perfil menciona un mes pedaleando por Perú.",
      "line": "¿Perú fue de esos viajes que repetirías, o de esos que te alegras de haber hecho una vez?",
      "why": "Una cosa sacada del perfil, una pregunta, y las dos respuestas posibles son fáciles. Además resulta ser una pregunta que a la mayoría le gusta responder."
    },
    {
      "situation": "Tres fotos, una de ellas con un pez enorme en las manos.",
      "line": "Tengo preguntas sobre el pez.",
      "why": "Técnicamente no es una pregunta y aun así se puede responder del todo. Es concreta, es cálida, y le da a la otra persona una siguiente frase obvia."
    },
    {
      "situation": "Has escrito hola y estás a punto de mandarlo.",
      "line": "(abre el perfil otra vez y encuentra algo)",
      "why": "El arreglo tarda quince segundos. Casi todos los perfiles tienen una rareza concreta, y esa rareza es el mensaje entero."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué hola recibe tan pocas respuestas?",
      "options": [
        { "text": "No contiene nada que responder, así que contestar es un esfuerzo.", "correct": true, "note": "Es estructural, no de mala educación. Quien lo lee tiene que inventar la conversación, decidir qué podrías querer, y llevarla — a partir de un mensaje que no le dio nada de eso." },
        { "text": "Parece vago.", "correct": false, "note": "Lo parece, y un montón de mensajes que parecen vagos reciben respuesta cuando se pueden contestar. Lo que se mide no es el esfuerzo." },
        { "text": "Lo manda todo el mundo.", "correct": false, "note": "Cierto y secundario. Seguiría siendo difícil de responder aunque fueras la única persona que lo mandara jamás." },
        { "text": "Es demasiado corto.", "correct": false, "note": "Corto está bien. Tres palabras sobre su foto de verdad superan a tres frases sobre nada." }
      ],
      "explain": "Un mensaje tiene que poder responderse. Todo lo demás importa menos."
    },
    {
      "prompt": "Su perfil casi no dice nada y las fotos son del montón. ¿Y ahora?",
      "options": [
        { "text": "Manda algo general y espera suerte.", "correct": false, "note": "Que es de donde partías. Un perfil del montón es un motivo para mirar más, no para dejar de mirar." },
        { "text": "Pregunta por lo más concreto que haya en cualquiera de ellas, por pequeño que sea.", "correct": true, "note": "Siempre hay algo. Una chaqueta, un lugar, un perro, un fondo — que sea pequeño da igual, porque lo que hace el trabajo es la concreción, no el tema." },
        { "text": "Pregunta qué está buscando aquí.", "correct": false, "note": "Se puede responder, y es la pregunta que hace todo el mundo, y le obliga a hacer el trabajo de describirse ante un desconocido." },
        { "text": "Pasa de ese match.", "correct": false, "note": "Un filtro razonable para algunas personas, y no una lección sobre cómo escribir mensajes. Los perfiles escuetos responden tanto como los completos." }
      ],
      "explain": "Todos los perfiles tienen algo concreto. Encuéntralo y el mensaje se escribe solo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "specific", "label": "Usó algo que solo su perfil podía dar", "description": "Se refirió a un detalle concreto en vez de a algo que podría haberse mandado a cualquiera." },
      { "key": "answerable", "label": "Se podía responder en una frase", "description": "Dejó una respuesta obvia en vez de pedirle que inventara una." },
      { "key": "short", "label": "Lo mantuvo corto", "description": "Escribió un mensaje, no un párrafo." },
      { "key": "not_clever", "label": "Eligió lo concreto antes que lo ingenioso", "description": "No gastó el mensaje intentando impresionar." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "mood": "En la aplicación por las noches, sin desesperación.",
        "name": "Senan",
        "role": "alguien con quien acabas de hacer match",
        "openness": 4,
        "personality": "Seco y rápido para responder a cualquier cosa concreta. Ignora cualquier cosa que podría habérsele mandado a cualquiera."
      },
      "sex": "female",
      "mood": "En la aplicación por las noches, sin desesperación.",
      "name": "Sena",
      "role": "alguien con quien acabas de hacer match",
      "openness": 4,
      "personality": "Seca y rápida para responder a cualquier cosa concreta. Ignora cualquier cosa que podría habérsele mandado a cualquiera."
    },
    "setting": "Un match nuevo. Su perfil: cuatro fotos — una en una bici cargada de alforjas, una en una cocina con una hogaza de masa madre bastante aplastada, dos con un border collie. El texto dice solo: fui a Perú en bici, mal. Pregúntame por el pan.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con calidez y rapidez a cualquier cosa concreta, y brevemente a cualquier cosa genérica.",
      "Escribe como se escribe en las aplicaciones: corto, casi todo en minúsculas, sin párrafos.",
      "Nunca mandes tú el primer mensaje."
    ],
    "opening_beat": "Aparece la notificación del match. La casilla de mensaje está vacía y te toca a ti.",
    "success_looks_like": "La persona manda algo concreto y respondible en vez de algo general."
  }$j$::jsonb,
  'Abre tu aplicación y reescribe un mensaje que estabas a punto de mandar como hola. Una cosa concreta, una pregunta, menos de treinta palabras. Apunta en qué lo convertiste.',
  $j${
    "says": "(su perfil: fui a Perú en bici, mal. Pregúntame por el pan. Fotos — una bici cargada, una masa madre bastante aplastada, dos de un border collie.)",
    "model": {
      "line": "¿Perú fue de esos viajes que repetirías, o de esos que te alegras de haber hecho una vez?",
      "why": "Una cosa sacada del perfil, una pregunta, y las dos respuestas posibles son fáciles. Nada de esto podría habérsele mandado a nadie más, que es toda la prueba."
    },
    "checks": [
      { "kind": "contains_any", "words": ["perú", "pan", "masa madre", "bici", "pedale", "perro", "collie", "hogaza"], "requirement": "Usa algo que solo su perfil te pudiera haber dado" },
      { "kind": "requires_question", "requirement": "Dale algo que responder" },
      { "kind": "max_words", "n": 30, "requirement": "Menos de treinta palabras. Es un mensaje, no una carta." }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('first-message', 2,
  'Lee buscando la rareza, no el resumen',
  $md$La gente lee un perfil como si fuera un currículum, y es el documento equivocado.

El resumen es lo que alguien quiere que sepas: el trabajo, la altura, la lista ordenada de intereses. También es lo que escribió para todo el mundo, así que un mensaje sobre eso es un mensaje sobre la versión pública de esa persona.

**La jugada:** encuentra lo más raro y concreto que haya en la página y pregunta por eso.

La hogaza aplastada. El pez. El perro con algo puesto. La frase que no encaja con las demás. Las rarezas son buenos objetivos por tres motivos distintos: se eligieron a propósito, así que llevan una historia detrás; casi nadie pregunta por ellas, así que no eres la cuarta persona de hoy; y son fáciles de responder sin tener que devolver algo impresionante.

La jugada contraria — preguntar por lo más impresionante — es la que falla. A alguien cuyo perfil menciona una maratón se lo ha preguntado ya todo el mundo, y la versión sincera de su respuesta se le hizo aburrida allá por marzo.$md$,
  $j$[
    {
      "situation": "Su perfil menciona una maratón, un ascenso, y una foto de un corte de pelo horrible de 2009.",
      "line": "2009 fue un año difícil para muchos de nosotros.",
      "why": "El corte de pelo es lo elegido a propósito — nadie conserva esa foto por accidente. Por la maratón ya le han preguntado cuarenta veces."
    },
    {
      "situation": "Seis fotos normales y una con un trofeo por algo que no se lee.",
      "line": "¿Ese trofeo de qué es? He decidido que es por algo extremadamente específico.",
      "why": "Una rareza concreta, una respuesta fácil, y un pequeño chiste que no necesita tono para funcionar porque está anclado a un objeto real."
    },
    {
      "situation": "Estás redactando un mensaje sobre lo impresionante.",
      "line": "(encuentra en su lugar lo segundo más interesante)",
      "why": "Lo impresionante es lo que elige todo el mundo. Ser quien se fijó en otra cosa es casi toda la ventaja disponible en un primer mensaje."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué lo más impresionante de un perfil es un objetivo flojo?",
      "options": [
        { "text": "Puede sonar a halago.", "correct": false, "note": "Un riesgo menor. El problema de verdad es que la respuesta está ensayada, no que la pregunta sea zalamera." },
        { "text": "Puede que no lo entiendas.", "correct": false, "note": "No entenderlo está bien, y a menudo es una buena apertura. No es por eso por lo que falla lo impresionante." },
        { "text": "Todo el mundo pregunta por ello, y responderlo ya es una tarea pesada.", "correct": true, "note": "Ha dado esa respuesta muchas veces y ha dejado de disfrutarla. Llegas como la cuarta persona esta semana que pregunta lo mismo." },
        { "text": "Normalmente está exagerado.", "correct": false, "note": "A veces, y da igual. La pregunta seguiría estando gastada aunque cada palabra fuera cierta." }
      ],
      "explain": "Lo impresionante es lo concurrido. Lo raro es lo que nadie más eligió."
    },
    {
      "prompt": "¿Qué hace que una rareza sea un buen objetivo?",
      "options": [
        { "text": "Tiene gracia.", "correct": false, "note": "A menudo, y eso es un efecto secundario. Muchos buenos objetivos son simplemente raros, no graciosos." },
        { "text": "Demuestra que leíste con atención.", "correct": false, "note": "Lo demuestra, y esa es la mitad menor. El esfuerzo vale menos que el hecho de que quería hablar de ello." },
        { "text": "Es más fácil de escribir.", "correct": false, "note": "Normalmente cierto, y no es por eso por lo que funciona. Funciona por lo que le hace sentir a la otra persona." },
        { "text": "Se eligió a propósito, así que hay una historia detrás.", "correct": true, "note": "Nadie conserva una foto rara por accidente. Está en la página porque quería que alguien preguntara, lo que te convierte en quien lo hizo." }
      ],
      "explain": "Una rareza está en la página a propósito. Preguntar por ella es aceptar una invitación."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "found_oddity", "label": "Encontró lo raro", "description": "Eligió un detalle concreto y deliberado en vez del titular." },
      { "key": "avoided_crowd", "label": "Evitó el objetivo concurrido", "description": "No preguntó por lo que pregunta todo el mundo." },
      { "key": "easy_answer", "label": "Dejó una respuesta fácil", "description": "Preguntó algo que se podía responder sin tener que actuar." },
      { "key": "read_it", "label": "Demostró que lo había leído", "description": "Se refirió a algo que solo podía venir de ese perfil." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "mood": "Deslizando a medias, con pocas expectativas.",
        "name": "Marek",
        "role": "alguien con quien acabas de hacer match",
        "openness": 3,
        "personality": "Educado y algo cansado de la aplicación. Se anima al momento en cuanto alguien pregunta por el gnomo."
      },
      "sex": "female",
      "mood": "Deslizando a medias, con pocas expectativas.",
      "name": "Marguerite",
      "role": "alguien con quien acabas de hacer match",
      "openness": 3,
      "personality": "Educada y algo cansada de la aplicación. Se anima al momento en cuanto alguien pregunta por el gnomo."
    },
    "setting": "Un perfil: acabó una media maratón, trabaja en seguros, le gusta viajar y comer bien. Cinco fotos cuidadas, y una sexta de un gnomo de jardín descascarillado en el alféizar de una ventana, sin ninguna explicación.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a una pregunta sobre la media maratón con educación y brevedad, sin ninguna energía.",
      "Responde a una pregunta sobre el gnomo largo y tendido y con evidente ilusión.",
      "Escribe como se escribe en las aplicaciones: corto, informal, sin párrafos."
    ],
    "opening_beat": "Habéis hecho match. Tienes el perfil abierto delante y la casilla está vacía.",
    "success_looks_like": "La persona pregunta por el gnomo en vez de por la media maratón."
  }$j$::jsonb,
  'Abre tres perfiles con los que hayas hecho match y encuentra en cada uno lo más raro y concreto que haya. No mandes nada todavía. Apunta las tres rarezas y si las habrías visto antes.',
  $j${
    "beats": [
      {
        "situation": "El perfil: acabó una media maratón, trabaja en seguros, le gusta viajar y comer bien. Cinco fotos cuidadas, y una sexta de un gnomo de jardín descascarillado en el alféizar de una ventana, sin ninguna explicación.",
        "prompt": "¿Sobre qué preguntas?",
        "options": [
          { "text": "La media maratón.", "correct": false, "note": "El objetivo concurrido. Lo ha respondido muchas veces y la versión sincera dejó de interesarle hace meses." },
          { "text": "Viajar, porque es lo más fácil de comentar.", "correct": false, "note": "Está en todos los perfiles de la aplicación, lo que lo convierte en lo menos revelador de este." },
          { "text": "El gnomo.", "correct": true, "note": "Deliberado, concreto, y casi seguro que nadie ha preguntado por él. Nadie conserva la foto de un gnomo descascarillado por accidente — está en la página porque quiere que alguien pregunte." },
          { "text": "Seguros, porque nadie más lo va a hacer.", "correct": false, "note": "Cierto, y no es una rareza, es un trabajo. Hay una diferencia entre lo inusual y lo que nadie pregunta por un motivo." }
        ]
      },
      {
        "situation": "Preguntaste por el gnomo y te llegaron tres párrafos de vuelta.",
        "prompt": "¿Qué te dijo eso?",
        "options": [
          { "text": "Es muy hablador.", "correct": false, "note": "Puede, y esa misma persona le mandó una línea a todo el que preguntó por la media maratón." },
          { "text": "Tiene interés.", "correct": false, "note": "Leer interés en ello demasiado pronto. La longitud tiene que ver con el tema, no contigo." },
          { "text": "No mucho — hay gente que escribe mucho.", "correct": false, "note": "Infravalorar la señal más fuerte que vas a recibir en todo este tema." },
          { "text": "Elegiste lo que estaba esperando que le preguntaran.", "correct": true, "note": "Una respuesta más larga que tu mensaje es la señal más clara que hay en una aplicación. Y además es repetible — todos los perfiles tienen algo así." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('first-message', 3,
  'Una pregunta, no tres',
  $md$Un mensaje con tres preguntas consigue que se responda una, y nunca es la que te importaba.

Pasa por un buen motivo: intentas darle opciones, para que si una cae plana haya otra a la que recurrir. Lo que le llega de verdad al otro lado es un formulario. Elige la que sea más rápida, las otras dos se evaporan, y la respuesta es más corta de lo que habría sido si no hubieras preguntado nada.

**La jugada:** pregunta una sola cosa, y deja que el resto del mensaje sea corto.

Menos de treinta palabras es un buen techo, y la mayoría de los buenos primeros mensajes se quedan bastante por debajo. La longitud también es una señal que no controlas: un párrafo le dice, antes de empezar, que esta conversación va a costar esfuerzo, y ajustarte a la longitud a la que escribe vale más que cualquier cosa que pudieras añadir.

El otro motivo para quedarte en una pregunta es que te obliga a decidir por qué tienes curiosidad de verdad. Tres preguntas suele ser alguien que no se ha decidido, y eso se nota.$md$,
  $j$[
    {
      "situation": "Has redactado: ¿qué tal Perú? ¿todavía vas en bici? ¿a qué te dedicas?",
      "line": "¿Perú fue de esos viajes que repetirías?",
      "why": "Una pregunta, la más interesante de las tres, y ahora la respuesta tiene sitio para ser larga. Las otras dos siguen disponibles más adelante, que es para lo que sirve una conversación."
    },
    {
      "situation": "Quieres preguntar por el pan y por el perro.",
      "line": "El pan primero, por supuesto.",
      "why": "Nombrar la elección es más cálido que hacerla en silencio, y le pasa el segundo tema sin gastar una pregunta en él."
    },
    {
      "situation": "Tu mensaje ya lleva cuatro líneas y todavía no has preguntado nada.",
      "line": "(corta todo lo que va antes de la pregunta)",
      "why": "El preámbulo es casi siempre la parte que escribiste mientras decidías. Casi nunca sobrevive a que lo lean y nunca sobrevive a que lo corten."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Preguntas tres cosas. ¿Qué te llega de vuelta?",
      "options": [
        { "text": "Una respuesta a la más fácil, y las otras dos desaparecen.", "correct": true, "note": "La gente responde a la pregunta más barata de un mensaje y sigue adelante. No has triplicado tus opciones, has elegido por ella la menos interesante." },
        { "text": "Tres respuestas cortas.", "correct": false, "note": "De vez en cuando, y lo corto es el problema. Tres frases que responden cada una a un tercio de un formulario son una respuesta peor que una de verdad." },
        { "text": "Una respuesta más larga, porque hay más a lo que responder.", "correct": false, "note": "Justo lo contrario. Más preguntas producen, de forma fiable, respuestas más cortas, porque un mensaje que parece un formulario se responde como tal." },
        { "text": "Nada, normalmente.", "correct": false, "note": "Demasiado pesimista. Tres preguntas es un mensaje más flojo, no uno fatal." }
      ],
      "explain": "Una pregunta consigue una respuesta de verdad. Tres consiguen la más barata."
    },
    {
      "prompt": "¿Qué debería ser el resto del mensaje?",
      "options": [
        { "text": "Algo sobre ti, para que no sea unilateral.", "correct": false, "note": "Eso pertenece al tercer o cuarto mensaje. En el primero es un párrafo sobre un desconocido, sin que nadie lo pidiera." },
        { "text": "Corto — lo ideal es que casi no haya nada más.", "correct": true, "note": "Casi todos los buenos primeros mensajes son la pregunta más muy poco más. El preámbulo es la parte escrita mientras decidías, y no sobrevive a que la lean." },
        { "text": "Un cumplido, para suavizar la pregunta.", "correct": false, "note": "La pregunta no necesita suavizarse, y un cumplido en un primer mensaje es lo más habitual que hay en su bandeja de entrada." },
        { "text": "Contexto de por qué preguntas.", "correct": false, "note": "La pregunta lleva su propio contexto. Explicarla dobla la longitud y no añade nada que responder." }
      ],
      "explain": "La pregunta es el mensaje. Todo lo demás es lo que escribiste mientras averiguabas cuál era."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_question", "label": "Preguntó una cosa", "description": "Se quedó en una sola pregunta en vez de ofrecer un menú." },
      { "key": "chose_well", "label": "Eligió la interesante", "description": "Se quedó con la pregunta que merecía la pena responder, no con la más segura." },
      { "key": "short", "label": "Cortó el preámbulo", "description": "No gastó el mensaje en llegar hasta la pregunta." },
      { "key": "left_room", "label": "Dejó espacio para una respuesta de verdad", "description": "Preguntó algo que se podía responder largo y tendido si se quería." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "mood": "Contento de estar escribiéndose, sin ninguna prisa.",
        "name": "Ioan",
        "role": "alguien con quien acabas de hacer match",
        "openness": 4,
        "personality": "Hablador cuando le preguntan una sola cosa, seco cuando le dan una lista. Responde con la longitud con la que le escriben."
      },
      "sex": "female",
      "mood": "Contento de estar escribiéndose, sin ninguna prisa.",
      "name": "Iona",
      "role": "alguien con quien acabas de hacer match",
      "openness": 4,
      "personality": "Habladora cuando le preguntan una sola cosa, seca cuando le dan una lista. Responde con la longitud con la que le escriben."
    },
    "setting": "Un match con mucho en el perfil: una furgoneta camperizada a medias, una foto de un mercado de comida en Palermo, y una frase sobre haber empezado hace poco a tocar el chelo, mal.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si te preguntan más de una cosa, responde solo a la más corta, y con brevedad.",
      "Si te preguntan una sola cosa, respóndela bien y añade algo por tu cuenta.",
      "Escribe como se escribe en las aplicaciones."
    ],
    "opening_beat": "Tres cosas obvias sobre las que preguntar y una casilla vacía.",
    "success_looks_like": "La persona elige una y deja que el mensaje sea corto."
  }$j$::jsonb,
  'Coge un mensaje que hayas redactado con más de una pregunta y recórtalo a una. Manda eso. Apunta qué pregunta conservaste y cuánto duró la respuesta.',
  $j${
    "says": "(su perfil: una furgoneta camperizada a medias, un mercado de comida en Palermo, y una frase sobre haber empezado hace poco a tocar el chelo, mal)",
    "model": {
      "line": "¿Qué tan mal estamos hablando, con lo del chelo?",
      "why": "Una pregunta, ocho palabras, y ningún preámbulo. La furgoneta y Palermo siguen ahí para el tercer mensaje, que es para lo que sirve una conversación."
    },
    "checks": [
      { "kind": "max_questions", "n": 1, "requirement": "Una pregunta. Tres te consiguen la respuesta más barata." },
      { "kind": "requires_question", "requirement": "Pregunta algo" },
      { "kind": "max_words", "n": 25, "requirement": "Menos de veinticinco palabras — corta el preámbulo" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('first-message', 4,
  'Cuando el perfil no dice nada',
  $md$Tres fotos, sin texto, y un match. Es el caso que la gente dice que es imposible, y es el que tiene menos competencia.

Un perfil vacío recibe menos mensajes, y los que recibe son peores — porque todo el que lo abre concluye que no hay nada con lo que trabajar y manda hola. El listón está por los suelos.

**La jugada:** pregunta por lo que eligió que estuviera en la foto, no por la foto.

Alguien eligió esas tres imágenes de entre mil. El fondo es un sitio al que fue, la chaqueta es una que tiene, el perro es suyo o de alguien que le gusta lo bastante como para dejarse fotografiar con él. Cualquiera de esas cosas es una pregunta, y cada una lleva la misma prueba de atención que un perfil con texto te habría dado gratis.

Lo único que hay que evitar es comentar su físico. Es todo el contenido de su bandeja de entrada, no se puede responder salvo con gracias, y en un perfil vacío confirma lo único que puede asumir de ti por ahora.$md$,
  $j$[
    {
      "situation": "Tres fotos, sin texto. Una está claramente tomada en un ferry.",
      "line": "Eso parece un ferry con mal tiempo de verdad. ¿A dónde ibas?",
      "why": "Un detalle concreto de la imagen y una respuesta fácil. Además demuestra que hiciste algo más que deslizar, que en un perfil vacío es lo bastante inusual como para ser el mensaje entero."
    },
    {
      "situation": "Las tres fotos son de interior y no dan casi ninguna pista.",
      "line": "Tu cocina tiene más plantas de las que a la mía le caben. ¿Cuántas siguen vivas?",
      "why": "Un detalle del fondo sigue siendo un detalle. Lo pequeño es lo que importa — nadie más miró con tanta atención."
    },
    {
      "situation": "Estás a punto de decir que tiene buen aspecto.",
      "line": "(encuentra en su lugar algo en la foto)",
      "why": "Es el único mensaje que un perfil vacío seguro que ya tiene, y la única respuesta disponible es gracias."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué un perfil vacío es más fácil de lo que parece?",
      "options": [
        { "text": "Es más probable que responda por aburrimiento.", "correct": false, "note": "No hay pruebas de ello, y no es el mecanismo. La ventaja está en lo que mandó todo el mundo más." },
        { "text": "Hay menos con lo que equivocarse.", "correct": false, "note": "Hay menos con lo que trabajar, que es otra cosa. La ventaja es comparativa, no absoluta." },
        { "text": "Todos los demás se rindieron y mandaron hola.", "correct": true, "note": "La competencia aquí es peor que en ningún sitio. Una pregunta sobre algo que de verdad hay en una foto te pone por delante de toda la bandeja de entrada." },
        { "text": "Significa que es nuevo en la aplicación.", "correct": false, "note": "A veces, y no cambia nada de lo que hay que escribir." }
      ],
      "explain": "Un perfil vacío tiene una bandeja de entrada peor que uno completo. Esa es la oportunidad."
    },
    {
      "prompt": "¿Por qué no abrir con un cumplido sobre su físico?",
      "options": [
        { "text": "Es inapropiado.", "correct": false, "note": "Normalmente no lo es, en una aplicación construida exactamente para esto. El problema es mecánico, no moral." },
        { "text": "Va a asumir que no leíste el perfil.", "correct": false, "note": "No hay perfil que leer. Esa es la premisa." },
        { "text": "Marca el tono equivocado para después.", "correct": false, "note": "Un efecto pequeño, y es consecuencia del problema de verdad, que es que no hay nada que se pueda decir de vuelta." },
        { "text": "No se puede responder — la única respuesta es gracias.", "correct": true, "note": "Y es la mayoría de lo que ya tiene ahí. Un mensaje sin respuesta posible es el mismo fallo que hola, con algo más elegante puesto." }
      ],
      "explain": "Cualquier cosa cuya única respuesta posible sea gracias no es un mensaje."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "used_a_photo", "label": "Usó algo de una foto", "description": "Encontró un detalle concreto en vez de concluir que no había nada." },
      { "key": "about_the_choice", "label": "Preguntó por la elección, no por la imagen", "description": "Preguntó por un lugar, un objeto o una decisión en vez de describir la imagen." },
      { "key": "no_looks", "label": "No comentó su físico", "description": "Evitó el mensaje sin respuesta posible." },
      { "key": "answerable", "label": "Dejó una respuesta fácil", "description": "Preguntó algo que se podía responder en una frase." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "mood": "Escéptico, sigue en la aplicación.",
        "name": "Ruaridh",
        "role": "alguien con quien acabas de hacer match",
        "openness": 3,
        "personality": "Cauto al principio, después de recibir muchísimos mensajes sobre su físico. Se abre de inmediato con cualquier cosa sobre las fotos en sí."
      },
      "sex": "female",
      "mood": "Escéptico, sigue en la aplicación.",
      "name": "Robyn",
      "role": "alguien con quien acabas de hacer match",
      "openness": 3,
      "personality": "Cauta al principio, después de recibir muchísimos mensajes sobre su físico. Se abre de inmediato con cualquier cosa sobre las fotos en sí."
    },
    "setting": "Un match sin nada de texto. Tres fotos: una en la cubierta de un ferry con mal tiempo, una en una mesa con un plato enorme de algo frito, una en un portal con una bicicleta claramente repintada a mano.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde de forma plana y breve a cualquier cosa sobre el físico.",
      "Responde con calidez y largo y tendido a cualquier cosa sobre el ferry, la comida o la bicicleta.",
      "Escribe como se escribe en las aplicaciones."
    ],
    "opening_beat": "Sin biografía, tres fotos, y te toca a ti.",
    "success_looks_like": "La persona encuentra algo concreto en una foto y pregunta por la elección que hay detrás."
  }$j$::jsonb,
  'Encuentra un match con un perfil vacío y manda una pregunta sobre algo de una foto. No sobre su físico. Apunta el detalle que usaste.',
  $j${
    "says": "(sin biografía. Tres fotos: la cubierta de un ferry con mal tiempo, un plato enorme de algo frito, una bicicleta repintada a mano en un portal.)",
    "model": {
      "line": "Ese ferry tenía pinta de moverse de verdad. ¿A dónde ibas?",
      "why": "Algo concreto que eligió incluir, y una respuesta que puede dar en una frase. En un perfil sin texto, esto te pone por delante de toda la bandeja de entrada."
    },
    "checks": [
      { "kind": "contains_any", "words": ["ferry", "barco", "mar", "tiempo", "comida", "frito", "plato", "bici", "bicicleta", "pint", "portal"], "requirement": "Usa algo de una de las fotos" },
      { "kind": "forbids_any", "words": ["precioso", "preciosa", "guapo", "guapa", "bonito", "bonita", "atractivo", "atractiva", "impresionante", "estás muy bien", "cuerpazo"], "requirement": "Nada sobre su físico" },
      { "kind": "max_words", "n": 25, "requirement": "Menos de veinticinco palabras" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('first-message', 5,
  'Gracioso sin tono',
  $md$El texto no tiene tono, y casi todo lo que a la gente le hace gracia en persona depende de él.

La ironía es la principal víctima. Dicho en voz alta, un comentario seco es obviamente una broma, porque tu cara y tu voz hacen la mitad del trabajo. Escrito, es una frase que significa lo que dice, y quien la lee tiene que decidir si estás de broma sin ninguna prueba en ningún sentido. La mayoría decide que no, y responde educadamente a algo que no querías decir.

**La jugada:** sé concreto en vez de irónico, porque lo concreto sobrevive sin tono.

*He decidido que el trofeo es por algo extremadamente específico* tiene gracia y no se puede malinterpretar — la broma es la invención, y la invención está anclada a un objeto real de su página. Esa es la forma que funciona: una idea pequeña, obviamente falsa, pegada a algo concreto que puede ver.

Lo que casi nunca funciona es una broma sobre ellos, en un primer mensaje, de un desconocido. En persona eso necesita una confianza que no tienes, y en texto tampoco tienes tono con el que suavizarla. Apunta a la situación, al objeto o a ti.$md$,
  $j$[
    {
      "situation": "Su perfil menciona que lleva una hoja de cálculo muy seria de todas las películas que ve.",
      "line": "Necesito saber si la hoja de cálculo tiene formato condicional.",
      "why": "Una pequeña invención anclada a algo real. No se puede leer como sincera ni como una crítica, que es exactamente lo que una broma tiene que conseguir sin tono."
    },
    {
      "situation": "Su foto muestra una tarta visiblemente hundida.",
      "line": "A nivel estructural tengo preguntas, pero aun así me la comería.",
      "why": "Apuntada al objeto, no a la persona. Es cálida, es evidentemente juguetona, y la respuesta se escribe sola."
    },
    {
      "situation": "Has escrito algo seco que podría leerse como una crítica.",
      "line": "(reescríbelo como una invención en vez de como una observación)",
      "why": "Las observaciones necesitan tono para ser seguras. Las invenciones llevan su propia señal, porque nadie dice algo obviamente falso por accidente."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué falla la ironía en un primer mensaje?",
      "options": [
        { "text": "No hay tono, así que la frase significa justo lo que dice.", "correct": true, "note": "Tu cara y tu voz normalmente hacen la mitad del trabajo. En texto, quien lee no tiene ninguna prueba de que estés de broma, y con un desconocido lo prudente es asumir que no." },
        { "text": "La gente de las aplicaciones no tiene sentido del humor.", "correct": false, "note": "La conclusión que te impide mejorar. Esa misma persona se habría reído con la misma frase dicha en voz alta." },
        { "text": "Es demasiado arriesgado con alguien a quien no conoces.", "correct": false, "note": "Cerca, y describe las pullas más que la ironía. La ironía falla por legibilidad, no por permiso." },
        { "text": "Necesita demasiadas palabras.", "correct": false, "note": "La ironía suele ser más corta que la alternativa. La longitud no es el problema." }
      ],
      "explain": "Sin tono, una frase irónica es solo una frase sincera que no querías decir."
    },
    {
      "prompt": "¿Qué broma es más segura en un primer mensaje?",
      "options": [
        { "text": "Una pulla suave sobre algo que dijo.", "correct": false, "note": "Eso necesita confianza, y un primer mensaje no tiene ninguna. Tampoco tiene tono con el que suavizarla, que es el segundo problema." },
        { "text": "Una idea obviamente falsa pegada a algo de su perfil.", "correct": true, "note": "No se puede leer como sincera, porque nadie dice algo obviamente falso por accidente, y está anclada a algo real, así que demuestra que miraste." },
        { "text": "Reírse de uno mismo.", "correct": false, "note": "Seguro para ellos, y te coloca por debajo de la conversación antes de que empiece. Bien en dosis pequeñas más adelante." },
        { "text": "Una broma sobre la propia aplicación.", "correct": false, "note": "Se puede responder y es extremadamente habitual. Es la conversación trivial de las aplicaciones de citas y no dice nada de ninguno de los dos." }
      ],
      "explain": "La invención gana a la observación, y cualquier cosa anclada a su página gana a cualquier cosa general."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "legible", "label": "No se podía malinterpretar", "description": "Escribió algo cuyo tono juguetón sobrevive sin tono." },
      { "key": "anchored", "label": "Anclado a su página", "description": "Pegó la broma a un detalle real en vez de hacer una general." },
      { "key": "not_at_them", "label": "No apuntó hacia ellos", "description": "Apuntó al objeto, a la situación o a sí mismo en vez de a un desconocido." },
      { "key": "still_answerable", "label": "Siguió dejando una respuesta", "description": "Dejó algo que decir de vuelta en vez de cerrar la conversación con una ocurrencia sin respuesta posible." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "mood": "De buen humor, en la aplicación mientras ve algo.",
        "name": "Vasil",
        "role": "alguien con quien acabas de hacer match",
        "openness": 4,
        "personality": "Juguetón y rápido, y la primera vez se toma cualquier cosa irónica completamente al pie de la letra. Encantado con una invención obvia."
      },
      "sex": "female",
      "mood": "De buen humor, en la aplicación mientras ve algo.",
      "name": "Vesna",
      "role": "alguien con quien acabas de hacer match",
      "openness": 4,
      "personality": "Juguetona y rápida, y la primera vez se toma cualquier cosa irónica completamente al pie de la letra. Encantada con una invención obvia."
    },
    "setting": "Un match cuyo perfil incluye una foto de una tarta de tres pisos, muy ambiciosa y con pinta de ser estructuralmente insegura, con el único pie de foto: aguantó.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Tómate cualquier cosa irónica completamente al pie de la letra la primera vez, con educación.",
      "Responde con evidente ilusión a una invención o una exageración sobre la tarta.",
      "Escribe como se escribe en las aplicaciones."
    ],
    "opening_beat": "La foto de la tarta, el pie de foto de dos palabras, y una casilla vacía.",
    "success_looks_like": "La persona escribe algo juguetón que no se puede malinterpretar ni como sincero ni como una crítica."
  }$j$::jsonb,
  'Hoy, manda un mensaje juguetón que no se pueda leer como sincero — una invención obvia sobre algo de su perfil. Apunta qué escribiste y cómo se tomó.',
  $j${
    "beats": [
      {
        "situation": "Su perfil tiene una foto de una tarta de tres pisos muy ambiciosa, con el único pie de foto: aguantó.",
        "prompt": "¿Qué mensaje funciona?",
        "options": [
          { "text": "A nivel estructural tengo preguntas, pero aun así me la comería.", "correct": true, "note": "Apuntado a la tarta, evidentemente juguetón, e imposible de leer como sincero o como poco amable. La respuesta se escribe sola." },
          { "text": "Bonita tarta.", "correct": false, "note": "Sincero, sin respuesta posible, y desperdicia lo más gracioso de la página." },
          { "text": "Ya veo que somos reposteros, entonces.", "correct": false, "note": "Seco, y lo seco necesita tono. Sin él, esto es una afirmación plana que podría ser una crítica, y así la va a leer." },
          { "text": "¿La hiciste tú?", "correct": false, "note": "Perfectamente correcto, y el pie de foto ya lo respondía, lo que le dice que lo leíste por encima." }
        ]
      },
      {
        "situation": "Mandaste algo irónico y te llegó una respuesta educada y literal.",
        "prompt": "¿Qué pasó?",
        "options": [
          { "text": "No tiene sentido del humor.", "correct": false, "note": "La conclusión que corta el aprendizaje. Esa misma persona se habría reído si lo hubiera oído en voz alta." },
          { "text": "No tenía forma de saber que era una broma.", "correct": true, "note": "El texto no lleva tono, así que una frase irónica es solo una frase sincera que no querías decir. Con un desconocido, la lectura prudente siempre es la literal." },
          { "text": "La broma no era lo bastante buena.", "correct": false, "note": "La calidad no es la variable. Una frase irónica mejor tiene exactamente el mismo problema." },
          { "text": "No deberías bromear en un primer mensaje.", "correct": false, "note": "Sobrecorregir. La invención funciona bien en un primer mensaje — lo que no sobrevive es específicamente la ironía." }
        ]
      }
    ]
  }$j$::jsonb
);
