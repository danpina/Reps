-- Spanish: Hacer amigos, track 5 — Mantenerla viva.
--
-- Conventions as prior tracks: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partners "Sam" (lessons 3, 5) and "Priya" (lessons 1, 2, 4) recur from
-- earlier tracks in this topic; Sam carries no `sex` field (masculine
-- default), Priya's name reads unambiguously female (feminine, per the
-- exception already established for her).

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

select pg_temp.es_lesson('keeping-it-alive', 1,
  'Manda cosas sin ninguna petición dentro',
  $md$El contacto de la mayoría de la gente con sus amigos consiste casi por completo en trámites: organizar cosas, confirmar cosas, responder sobre cosas. Es funcional, es lo que mantiene una agenda funcionando, y no es de lo que está hecha una amistad.

**La jugada:** manda cosas sin nada pegado.

Un enlace. Una foto de algo ridículo. Una frase sobre algo que mencionó hace cuatro meses. *Vi esto y pensé en ti* es todo el género y es mucho más potente de lo que dice su reputación, porque dice lo único que de verdad importa entre gente que no se ve a menudo: existes en mi cabeza cuando no estás en la sala.

Lleva quince segundos, no exige respuesta, y no pide nada. Esa última parte es todo el diseño. El contacto con una petición dentro hace que alguien tenga que hacer algo. El contacto sin nada dentro es un regalo, y es la diferencia entre una amistad que está cálida entre encuentros y una que hay que reiniciar cada vez.

Hay una versión concreta con la que merece la pena construir un hábito: hacer seguimiento de algo que te contaron. *¿Fue bien la entrevista?* *¿Qué tal lo de tu madre?* No cuesta nada, demuestra que la última conversación de verdad se escuchó, y se recuerda de forma desproporcionada al esfuerzo — a la mayoría de la gente no le preguntan dos veces por nada.

Y es asimétrico en la dirección correcta para alguien callado. Esto es mantenimiento de la amistad sin ninguna actuación social dentro: sin sala, sin timing, sin ingenio necesario. Si hay un hábito en esta aplicación que compensa a lo largo de una década, es este.

Si te quedas con una cosa: quince segundos, sin pedir nada. De eso está hecha de verdad la calidez entre encuentros.$md$,
  $j$[
    {
      "situation": "Ves algo que a un amigo le haría gracia.",
      "line": "Vi esto y pensé en ti.",
      "why": "Quince segundos, sin necesitar respuesta, sin pedir nada. Dice lo único que importa entre gente que no se ve a menudo."
    },
    {
      "situation": "Mencionó una entrevista la semana pasada.",
      "line": "¿Fue bien la entrevista?",
      "why": "Demuestra que la última conversación se escuchó, y se recuerda de forma desproporcionada — a la mayoría de la gente no le preguntan dos veces por nada."
    },
    {
      "situation": "Todos los mensajes que has mandado este año han sido para organizar algo.",
      "line": "(eso es un trámite, no amistad)",
      "why": "Mantiene una agenda funcionando. El contacto sin nada dentro es lo que mantiene cálida una amistad entre los momentos en que os veis."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hace que valga la pena mandar un mensaje sin peticiones?",
      "options": [
        { "text": "Te mantiene en su cabeza.", "correct": false, "note": "Un planteamiento estratégico de algo que funciona porque no es estratégico." },
        { "text": "Dice que existes en mi cabeza cuando no estás en la sala.", "correct": true, "note": "Lo único que de verdad importa entre gente que no se ve a menudo — y una petición en el mensaje diría algo completamente distinto." },
        { "text": "Es más fácil que organizar algo.", "correct": false, "note": "Lo es, y la facilidad es por lo que es sostenible, no por lo que funciona." },
        { "text": "Le da un motivo para responder.", "correct": false, "note": "Deliberadamente no necesita ninguno. Exigir una respuesta lo convertiría otra vez en un trámite." }
      ],
      "explain": "Quince segundos, nada pegado. Ese es todo el diseño."
    },
    {
      "prompt": "¿Qué versión se recuerda más?",
      "options": [
        { "text": "Un mensaje largo poniéndote al día como es debido.", "correct": false, "note": "Apreciado y raro, y pide una respuesta larga — que es por lo que a menudo no consigue ninguna." },
        { "text": "Algo gracioso que le gustaría.", "correct": false, "note": "Excelente y la versión cotidiana de esto. Hay una que aterriza más fuerte." },
        { "text": "Hacer seguimiento de algo que te contaron.", "correct": true, "note": "¿Fue bien la entrevista? Demuestra que la última conversación se escuchó, y a la mayoría de la gente no le preguntan dos veces por nada." },
        { "text": "Un mensaje en su cumpleaños.", "correct": false, "note": "Esperado, y las cosas esperadas son agradables, no memorables." }
      ],
      "explain": "Que te pregunten una segunda vez por algo es más raro de lo que la gente cree."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_ask", "label": "No pidió nada", "description": "Mandó algo sin ninguna petición pegada." },
      { "key": "quick", "label": "Lo mantuvo en quince segundos", "description": "No lo convirtió en un proyecto." },
      { "key": "followed_up", "label": "Hizo seguimiento de algo", "description": "Se refirió a algo que habían mencionado." },
      { "key": "habit", "label": "Lo convirtió en un hábito", "description": "Lo trató como algo recurrente en vez de puntual." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una amiga con quien no hablas desde hace unas semanas",
      "mood": "En casa, con el móvil cerca.",
      "openness": 5,
      "personality": "Responde con calidez y largo y tendido a cualquier cosa sin peticiones dentro, y con brevedad a cualquier cosa que sea organizar algo."
    },
    "setting": "Un martes por la noche. Una amiga con quien no hablas desde hace cinco semanas mencionó la última vez que tenía una entrevista de trabajo próxima.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con calidez y largo y tendido a cualquier cosa sin peticiones pegadas.",
      "Responde con brevedad y de forma práctica a cualquier cosa sobre organizar algo.",
      "Nunca escribas tú primero."
    ],
    "opening_beat": "La casilla de mensaje está vacía y son las nueve de la noche.",
    "success_looks_like": "La persona manda algo sin ninguna petición dentro."
  }$j$::jsonb,
  'Hoy, manda un mensaje sin pedir nada dentro. Quince segundos. Apunta a quién y qué.',
  $j${
    "says": "Las nueve de la noche. Una amiga con quien no hablas desde hace cinco semanas mencionó la última vez que tenía una entrevista de trabajo próxima.",
    "model": {
      "line": "¿Cómo fue al final la entrevista?",
      "why": "Quince segundos, sin pedir nada, y demuestra que la última conversación de verdad se escuchó. A la mayoría de la gente nunca le preguntan dos veces por nada."
    },
    "checks": [
      { "kind": "echoes_any", "words": ["entrevista", "trabajo"], "requirement": "Haz seguimiento de lo que te contaron" },
      { "kind": "forbids_any", "words": ["perdona", "siglos", "fatal para", "tenía pensado", "estás libre", "quedamos", "te apetece", "organicemos"], "requirement": "Sin peticiones, y sin disculpa por el hueco" },
      { "kind": "max_words", "n": 25, "requirement": "Quince segundos, no ponerse al día" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('keeping-it-alive', 2,
  'La frase que arregla un bache',
  $md$Las amistades casi nunca terminan. Tienen baches, que es algo completamente distinto, y la diferencia importa porque un bache es reversible y casi nadie revierte uno.

El mecanismo es corriente y no es culpa de nadie. Alguien estaba ocupado. El hueco se hizo lo bastante largo como para sentir que había que reconocerlo. Reconocerlo empezó a sentirse como más esfuerzo del que tenía ninguno de los dos — y a partir de ahí el hueco queda protegido por la incomodidad que creó, que es por lo que pueden pasar dos años entre gente a la que de verdad le cae bien la otra.

**La jugada:** manda la cosa corriente que habrías mandado de todas formas, como si hubierais hablado la semana pasada.

*Esto es lo más tú que he visto en todo el año.* Eso es todo. Sin disculpas, sin dar explicaciones por el tiempo, sin *lo siento mucho, soy fatal para esto.* Todo eso convierte el hueco en el tema y le pide que te tranquilice al respecto antes de que pueda pasar nada más — y tranquilizar a alguien es trabajo, que es exactamente lo que estabas intentando no pedir.

El motivo por el que funciona es que ella está al otro lado del mismo silencio, sintiendo lo mismo, e igual de incapaz de ser quien lo rompa. Casi nadie se molesta por un bache. Casi todo el mundo se alivia cuando alguien más va primero, y agradece de una forma desproporcionada a un solo mensaje.

También funciona después de mucho más tiempo del que la gente cree. Dos años no son nada. Cinco están bien. Las amistades viejas tienen una cantidad enorme de contexto guardado y reinician desde donde estaban en vez de desde cero, que es por lo que una hora con alguien a quien no ves desde 2019 suele ser mejor que una hora con alguien a quien ves cada mes.

Si aterriza mal, aterriza mal al coste de un mensaje. Ese es todo el lado negativo, y merece la pena ponerlo al lado del lado positivo, que es una amistad que ya habías dado por perdida.

Si te quedas con una cosa: sin disculpas, sin explicaciones, solo la cosa corriente. El hueco no es el tema a menos que tú lo conviertas en uno.$md$,
  $j$[
    {
      "situation": "Dos años desde que hablasteis por última vez y ves algo que le encantaría.",
      "line": "Esto es lo más tú que he visto en todo el año.",
      "why": "El mensaje corriente, mandado como si hubierais hablado la semana pasada. El hueco no es el tema a menos que tú lo conviertas en uno."
    },
    {
      "situation": "Estás a punto de abrir con perdona, soy fatal manteniendo el contacto.",
      "line": "(eso convierte el hueco en el tema)",
      "why": "Le pide que te tranquilice antes de que pueda pasar nada más, y tranquilizar a alguien es trabajo — que es lo que estabas intentando no pedir."
    },
    {
      "situation": "Crees que ha pasado demasiado tiempo como para ponerte en contacto.",
      "line": "(dos años no son nada, cinco están bien)",
      "why": "Las amistades viejas reinician desde el contexto guardado en vez de desde cero, que es por lo que una hora con alguien a quien no ves desde 2019 suele ser mejor que una hora con alguien a quien ves cada mes."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué duran tanto los baches?",
      "options": [
        { "text": "La gente se distancia de forma natural.", "correct": false, "note": "Una descripción del resultado, no el mecanismo, y hace que algo reversible suene inevitable." },
        { "text": "El hueco está protegido por la incomodidad que creó.", "correct": true, "note": "Se hizo lo bastante largo como para sentir que había que reconocerlo, y reconocerlo empezó a sentirse como más esfuerzo del que tenía ninguno de los dos." },
        { "text": "Alguien se sintió herido y no lo dijo.", "correct": false, "note": "De vez en cuando, y es la historia que la gente se inventa para explicar un silencio corriente." },
        { "text": "La vida se vuelve más ajetreada.", "correct": false, "note": "Se vuelve, y ocupado explica un hueco de tres semanas, no uno de tres años." }
      ],
      "explain": "No es culpa de nadie, y las dos personas están del mismo lado del mismo silencio."
    },
    {
      "prompt": "¿Por qué dejar fuera la disculpa?",
      "options": [
        { "text": "Suena poco sincera.", "correct": false, "note": "Normalmente suena completamente sincera, que no es el problema." },
        { "text": "Te hace quedar mal.", "correct": false, "note": "A nadie le parece peor alguien por disculparse. El coste recae en ella, no en ti." },
        { "text": "Le pide que te tranquilice primero.", "correct": true, "note": "Que es trabajo, y es exactamente lo que estabas intentando no pedir. El hueco se convierte en el tema antes de que pueda pasar nada más." },
        { "text": "Llama la atención sobre cuánto tiempo ha pasado.", "correct": false, "note": "Ella ya sabe cuánto tiempo ha pasado. La atención no es el coste — la tranquilización sí." }
      ],
      "explain": "Manda la cosa corriente, como si hubierais hablado la semana pasada."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "sent", "label": "Lo mandó", "description": "Rompió el silencio en vez de esperar." },
      { "key": "no_apology", "label": "Sin disculpa", "description": "No abrió dando explicaciones por el hueco." },
      { "key": "ordinary", "label": "Lo mantuvo corriente", "description": "Mandó lo que habría mandado de todas formas." },
      { "key": "no_explaining", "label": "No explicó el tiempo", "description": "Dejó los dos años sin comentar." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una amiga con quien no hablas desde hace dos años",
      "mood": "Noche tranquila, con el móvil cerca.",
      "openness": 5,
      "personality": "Encantada y de inmediato vuelve a la normalidad con un mensaje corriente. Se vuelve algo formal y se disculpa de vuelta si el hueco se convierte en el tema."
    },
    "setting": "Dos años desde que hablaste por última vez con alguien a quien estuviste muy unido. Acabas de ver algo que le haría muchísima gracia.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde como si hubierais hablado la semana pasada si el mensaje es corriente.",
      "Responde con tu propia disculpa y algo de incomodidad si el hueco se convierte en el tema.",
      "Nunca escribas tú primero."
    ],
    "opening_beat": "Dos años de nada, y la casilla de mensaje está abierta.",
    "success_looks_like": "La persona manda un mensaje corriente sin ninguna disculpa dentro."
  }$j$::jsonb,
  'Hoy, escríbele a alguien con quien no hables desde hace más de un año, sin ninguna disculpa dentro. Apunta a quién y qué mandaste.',
  $j${
    "says": "Dos años desde que hablaste por última vez con alguien a quien estuviste muy unido. Acabas de ver algo que le haría muchísima gracia.",
    "model": {
      "line": "Esto es lo más tú que he visto en todo el año.",
      "why": "El mensaje corriente, mandado como si hubierais hablado la semana pasada. Una disculpa convertiría el hueco en el tema y le pediría que te tranquilizara antes de que pudiera pasar nada más."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["perdona", "tanto tiempo", "siglos", "fatal manteniendo", "tenía pensado", "sé que ha pasado", "de la nada", "random", "ni idea de si tú"], "requirement": "No conviertas el hueco en el tema" },
      { "kind": "max_words", "n": 25, "requirement": "Corriente, y corto" },
      { "kind": "max_questions", "n": 1, "requirement": "No necesita preguntar nada" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('keeping-it-alive', 3,
  'Ritmos distintos no son fracasar',
  $md$La gente aplica un solo estándar a todas las amistades que tiene, y normalmente es el estándar de la amistad que sea más frecuente. Todo lo demás entonces parece que va mal.

**La jugada:** averigua el ritmo real de cada amistad, y deja de medirla contra una distinta.

Algunas funcionan cada semana. Algunas funcionan con un café cada par de meses. Algunas son dos cenas al año y están entre las relaciones más cercanas de tu vida. Esas no son versiones degradadas unas de otras — son formas distintas, y la de dos veces al año a menudo es a la que llamarías a las tres de la madrugada.

Confundirlas causa dos problemas concretos. Produce culpa por amistades que están funcionando perfectamente bien, porque no se parecen a las semanales. Y produce una sensación de fondo de estar fracasando en la amistad en general, que es uno de los sentimientos más comunes y menos precisos que la gente lleva encima.

Lo que de verdad indica salud no es la frecuencia. Es si la cosa se reinicia con facilidad. Una amistad que puedes retomar después de cuatro meses sin ceremonia está en excelente estado, diga lo que diga el calendario. Una que necesita un rodaje, una disculpa y media hora de reconocerse otra vez merece atención sin importar con qué frecuencia os veáis.

La versión práctica es nombrar el ritmo y luego relajarte en él. *Somos gente de dos veces al año* es un pensamiento real y útil — quita la culpa, y también evita que dejes que sin querer una amistad de dos veces al año se convierta en una de nunca porque estabas esperando a tener tiempo para la versión semanal.

Y cuidado con el error contrario: asumir que alguien quiere algo con menos frecuencia de la que quiere de verdad. Algunos baches no son ritmos en absoluto, son dos personas a las que a las dos les gustaría más y las dos están siendo educadas. Si no estás seguro, propón algo — la respuesta está a un mensaje de distancia.

Si te quedas con una cosa: juzga por lo fácil que se reinicia, no por lo a menudo que pasa.$md$,
  $j$[
    {
      "situation": "Te sientes culpable por un amigo al que ves dos veces al año.",
      "line": "(puede que ese sea el ritmo, no un fracaso)",
      "why": "Algunas de las relaciones más cercanas de tu vida funcionan con dos cenas al año. Medirlas contra una semanal produce culpa por algo que funciona perfectamente bien."
    },
    {
      "situation": "Te preguntas si una amistad está en buen estado.",
      "line": "(¿con qué facilidad se reinicia?)",
      "why": "Ese es el indicador real. Cuatro meses sin ceremonia es un estado excelente, diga lo que diga el calendario."
    },
    {
      "situation": "Has decidido que tú y alguien sois solo gente de dos veces al año.",
      "line": "(comprueba — propón algo)",
      "why": "Algunos baches no son ritmos, son dos personas a las que a las dos les gustaría más y las dos están siendo educadas. La respuesta está a un mensaje de distancia."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué indica de verdad una amistad sana?",
      "options": [
        { "text": "Con qué frecuencia os veis.", "correct": false, "note": "El estándar que aplica la gente y el menos informativo. Algunas de las relaciones más cercanas funcionan dos veces al año." },
        { "text": "Con qué facilidad se reinicia.", "correct": true, "note": "Cuatro meses sin ceremonia es un estado excelente. Una que necesita un rodaje y media hora de reconocerse otra vez merece atención sin importar con qué frecuencia os veáis." },
        { "text": "Cuánto os contáis.", "correct": false, "note": "Eso es profundidad, que es un eje distinto y sobre todo el asunto del bloque anterior." },
        { "text": "Si le llamarías en una crisis.", "correct": false, "note": "Una buena medida de cercanía y no de si la amistad está funcionando actualmente." }
      ],
      "explain": "Formas distintas, no versiones degradadas de la misma forma."
    },
    {
      "prompt": "¿Cuál es el error contrario?",
      "options": [
        { "text": "Ver a la gente demasiado a menudo.", "correct": false, "note": "Rara vez es un problema que tenga quien lea esto." },
        { "text": "Asumir que un bache es un ritmo cuando a los dos os gustaría más.", "correct": true, "note": "Dos personas siendo educadas la una con la otra pueden parecer exactamente un arreglo asentado de dos veces al año. Si no estás seguro, propón algo." },
        { "text": "Intentar que todas las amistades sean semanales.", "correct": false, "note": "El primer error dicho de otra forma, y es el que ya se ha cubierto." },
        { "text": "Mantener demasiadas amistades en marcha.", "correct": false, "note": "Una restricción real de capacidad y no un error de juicio sobre el ritmo." }
      ],
      "explain": "Nombra el ritmo, relájate en él — y comprueba, si estás adivinando."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named_rhythm", "label": "Nombró el ritmo", "description": "Averiguó a qué ritmo funciona de verdad esta amistad." },
      { "key": "no_guilt", "label": "Dejó la culpa", "description": "Dejó de medirla contra una amistad distinta." },
      { "key": "restart_test", "label": "Usó la prueba del reinicio", "description": "Juzgó por lo fácil que se retoma." },
      { "key": "checked", "label": "Comprobó cuando no estaba seguro", "description": "Propuso algo en vez de asumir un ritmo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un viejo amigo con quien estás hablando",
      "mood": "Tranquilo.",
      "openness": 5,
      "personality": "Pregunta con qué facilidad se retoma cada una en vez de con qué frecuencia las ves, y señala cuando la culpa es sobre una comparación."
    },
    "setting": "Estás repasando tus amistades y sintiéndote vagamente culpable por la mayoría.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta con qué facilidad se reinicia cada amistad cada vez que se mencione la frecuencia.",
      "Cuestiona con suavidad cualquier culpa que resulte ser una comparación con una amistad distinta.",
      "Nunca le digas a la persona qué amistades están bien."
    ],
    "opening_beat": "«Has enumerado a cuatro personas por las que te sientes mal. ¿Cómo va cuando de verdad las ves?»",
    "success_looks_like": "La persona juzga por la facilidad de reinicio en vez de por la frecuencia."
  }$j$::jsonb,
  'Hoy, nombra el ritmo real de una amistad por la que te sientas culpable. Apunta el ritmo y si se reinicia con facilidad.',
  $j${
    "beats": [
      {
        "situation": "Ves a un amigo cada semana, a otro cada par de meses, y a otro dos veces al año. Te sientes culpable por dos de ellos.",
        "prompt": "¿Sobre qué es la culpa de verdad?",
        "options": [
          { "text": "No sacar suficiente tiempo para la gente.", "correct": false, "note": "El sentimiento tal como se relata. Mira contra qué se está midiendo." },
          { "text": "Una comparación con el semanal.", "correct": true, "note": "La gente aplica el estándar de su amistad más frecuente a todas las demás, y todo lo demás entonces parece que va mal." },
          { "text": "Saber que esas amistades se están apagando.", "correct": false, "note": "La frecuencia no es apagarse. La prueba es si se reinician con facilidad, y dos veces al año puede reiniciarse al instante." },
          { "text": "Ser un mal amigo en general.", "correct": false, "note": "La conclusión que produce la comparación, y uno de los sentimientos menos precisos que la gente lleva encima." }
        ]
      },
      {
        "situation": "Has decidido que tú y alguien sois simplemente gente de dos veces al año.",
        "prompt": "¿Cuánta confianza deberías tener?",
        "options": [
          { "text": "Confianza total — ha sido así durante años.", "correct": false, "note": "Años de educación se ven idénticos a años de ritmo asentado desde dentro." },
          { "text": "No mucha — propón algo y averígualo.", "correct": true, "note": "Algunos baches no son ritmos en absoluto, son dos personas a las que a las dos les gustaría más y las dos están siendo educadas. La respuesta está a un mensaje de distancia." },
          { "text": "Confianza, si ninguno de los dos ha sugerido más.", "correct": false, "note": "Que ninguno sugiera nada es precisamente cómo se ve la versión educada." },
          { "text": "No importa — el ritmo está bien de cualquier forma.", "correct": false, "note": "Está bien si se elige. Es una pérdida si a los dos os gustaría más y ninguno lo dijo." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('keeping-it-alive', 4,
  'Sé quien se acuerda',
  $md$Casi nadie hace seguimiento de nada, lo que significa que una cantidad muy pequeña de acordarte te vuelve inusual.

**La jugada:** apunta las cosas, y pregunta por ellas más tarde.

La cita del hospital. La entrevista. La conversación difícil que le daba pavor tener con su hermano. Lo que le hacía ilusión que pasa en marzo. La gente menciona estas cosas constantemente y luego casi nunca le vuelven a preguntar — todo el mundo tiene intención de hacerlo y el detalle se ha esfumado para el jueves.

Apuntarlo es la mitad poco glamurosa y es lo que hace posible el resto. Una nota en tu móvil después de ver a alguien, treinta segundos, tres líneas: qué le pasa, qué se le viene encima, qué dijo que iba a hacer. Se siente clínico escrito así y es el efecto contrario, porque la alternativa es una intención cálida que se evapora de forma fiable.

Luego pregunta, más tarde, en concreto. *¿Cómo fue lo de tu hermano?* vale más que una hora poniéndote al día en general, porque demuestra que la conversación anterior fue real para ti. Esto es la referencia a algo dicho antes del bloque de la primera cita, movida a una escala de meses, y funciona por el mismo motivo: no se puede fingir, y no requiere ningún ingenio.

Hay un efecto de segundo orden que merece la pena conocer. La gente te cuenta más cuando sabe que te vas a acordar. Alguien a quien le han preguntado dos veces por algo empieza a contarte cosas antes y con más detalle, porque ahora tiene sentido contártelo — y eso es la mayor parte de lo que la gente quiere decir cuando describe a alguien como fácil de hablar.

También sobrevive a la distancia mejor que cualquier otra cosa. Dos personas que se ven dos veces al año pero preguntan por las cosas correctas están más cerca que dos que se ven cada mes y no preguntan por nada.

Si te quedas con una cosa: tres líneas en tu móvil después de ver a alguien. Es el consejo menos romántico de esta aplicación y hace más que casi cualquier otra cosa en ella.$md$,
  $j$[
    {
      "situation": "Mencionó una cita en el hospital para el catorce.",
      "line": "(tres líneas en tu móvil, esta noche)",
      "why": "La intención es cálida y se evapora para el jueves. Apuntarlo es la mitad poco glamurosa que hace posible el resto."
    },
    {
      "situation": "Tres semanas después, le estás escribiendo.",
      "line": "¿Cómo fue lo de tu hermano?",
      "why": "Vale más que una hora poniéndote al día en general, porque demuestra que la conversación anterior fue real para ti. Además no se puede fingir."
    },
    {
      "situation": "Alguien sigue contándote cosas con un detalle inusual.",
      "line": "(eso es porque preguntaste dos veces)",
      "why": "La gente te cuenta más cuando tiene sentido contártelo, y eso es la mayor parte de lo que se quiere decir con que alguien es fácil de hablar."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué apuntarlo en vez de simplemente acordarte?",
      "options": [
        { "text": "Porque tienes mala memoria.", "correct": false, "note": "A todo el mundo le pasa esto con la memoria. No es un fallo personal y no mejora con esfuerzo." },
        { "text": "Porque una intención cálida se evapora de forma fiable.", "correct": true, "note": "Todo el mundo tiene intención de preguntar, y el detalle se ha esfumado para el jueves. Treinta segundos de escritura son lo que convierte la intención en la cosa en sí." },
        { "text": "Porque demuestra que te importa.", "correct": false, "note": "Nadie ve la nota. Lo que ve es la pregunta tres semanas después." },
        { "text": "Porque ves a mucha gente.", "correct": false, "note": "Se aplica igual con cuatro amigos que con cuarenta." }
      ],
      "explain": "Tres líneas después de ver a alguien. El consejo menos romántico de la aplicación."
    },
    {
      "prompt": "¿Cuál es el efecto de segundo orden?",
      "options": [
        { "text": "Te haces conocido como considerado.", "correct": false, "note": "Reputación, y es la mitad menor de lo que pasa." },
        { "text": "Tienes más de qué hablar la próxima vez.", "correct": false, "note": "Cierto y mecánico. Algo más interesante pasa por su lado." },
        { "text": "La gente empieza a contarte cosas antes y con más detalle.", "correct": true, "note": "Porque ahora tiene sentido contártelo — y eso es la mayor parte de lo que la gente quiere decir cuando llama a alguien fácil de hablar." },
        { "text": "Empiezan a preguntar por tu vida también.", "correct": false, "note": "A menudo, con el tiempo, y no es lo bastante fiable como para ser el motivo." }
      ],
      "explain": "Es la referencia a algo dicho de la primera cita, movida a una escala de meses."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "wrote_it_down", "label": "Lo apuntó", "description": "Hizo una nota en vez de tener intención de acordarse." },
      { "key": "asked_later", "label": "Preguntó más tarde", "description": "Hizo seguimiento semanas después." },
      { "key": "specific", "label": "Fue concreto", "description": "Nombró la cosa real en vez de preguntar en general." },
      { "key": "habit", "label": "Lo convirtió en rutina", "description": "Lo hizo después de ver a alguien en vez de una sola vez." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una amiga a quien viste hace tres semanas",
      "mood": "Martes corriente.",
      "openness": 5,
      "personality": "Visiblemente emocionada de que le pregunten por algo concreto semanas después, y se abre considerablemente más de lo que lo hizo la primera vez."
    },
    "setting": "Hace tres semanas una amiga mencionó, de pasada, que le daba pavor una conversación con su hermano sobre la casa de su madre.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde largo y tendido y con calidez a un seguimiento concreto.",
      "Responde con brevedad y amabilidad a un qué tal genérico.",
      "Nunca saques tú el tema de tu hermano."
    ],
    "opening_beat": "La casilla de mensaje está abierta. Han pasado tres semanas.",
    "success_looks_like": "La persona pregunta por lo concreto en vez de ponerse al día en general."
  }$j$::jsonb,
  'Hoy, escribe tres líneas sobre alguien después de verle o hablar con esa persona. Apunta qué anotaste.',
  $j${
    "says": "Hace tres semanas una amiga mencionó, de pasada, que le daba pavor una conversación con su hermano sobre la casa de su madre.",
    "model": {
      "line": "¿Cómo fue al final lo de tu hermano?",
      "why": "Concreto, tres semanas después, y vale más que una hora poniéndote al día en general — porque demuestra que la conversación anterior fue real para ti y no se puede fingir."
    },
    "checks": [
      { "kind": "echoes_any", "words": ["hermano", "casa", "madre"], "requirement": "Nombra lo real que te contaron" },
      { "kind": "forbids_any", "words": ["qué tal estás", "cómo van las cosas", "cómo va todo", "cuánto tiempo", "qué has estado haciendo", "espero que estés bien"], "requirement": "Concreto, no ponerse al día en general" },
      { "kind": "max_words", "n": 25, "requirement": "Una pregunta" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('keeping-it-alive', 5,
  'Qué dejar ir',
  $md$El mantenimiento tiene un presupuesto. Nadie puede mantener veinte amistades cálidas, y fingir lo contrario produce una capa fina de contacto repartida entre demasiada gente, que es cómo alguien acaba con una lista de contactos llena y nadie a quien llamar.

**La jugada:** decide a dónde va el esfuerzo, y deja que el resto sea lo que es.

Esto no va sobre cortar a nadie. Casi nada necesita terminarse, y terminar amistades muy rara vez es necesario o amable. Va sobre darte cuenta de que tienes una cantidad limitada de mensajes de quince segundos y notas de tres líneas y arreglos fijos, y que gastarlos a propósito produce una vida completamente distinta a repartirlos por igual.

Dos cosas merecen menos de lo que están recibiendo. Las amistades que consisten por completo en obligación — donde el encuentro da pavor, la conversación es un informe, y lo único que la mantiene en marcha es que siempre lo ha hecho. Y las que solo toman: alguien que es cálido cuando necesita algo e inalcanzable en cualquier otro momento, que es una categoría real y merece la pena nombrarla con honestidad en vez de absorberla durante otra década.

Deja que esas encuentren su propio nivel. Sin conversación, sin anuncio, sin poda dramática — solo deja de ser quien la sostiene, y mira qué hace. Algunas te van a sorprender y van a salir bien. La mayoría se van a asentar en algo ocasional y perfectamente agradable, que es donde siempre estuvieron.

Y pon lo que ahorraste en algún sitio. Esto solo funciona como una redirección: dos o tres personas que reciben el arreglo fijo, las preguntas de seguimiento, y el mensaje sin nada dentro. La profundidad en un número pequeño gana a la calidez repartida entre muchos, y es la forma que tiene de verdad casi toda persona genuinamente bien conectada que conoces.

El permiso que merece la pena sacar de esto: puedes elegir. La amistad no es una lista de turnos de obligación, e invertir en silencio en la gente que de verdad quieres no es una traición a nadie.

Si te quedas con una cosa: elige a dos o tres y sé excelente con ellos. El resto puede ser encantador y ocasional.$md$,
  $j$[
    {
      "situation": "Estás intentando mantener veinte amistades cálidas.",
      "line": "(eso produce una capa fina sobre demasiada gente)",
      "why": "Es cómo alguien acaba con una lista de contactos llena y nadie a quien llamar. El mantenimiento tiene un presupuesto."
    },
    {
      "situation": "Una de ellas es completamente obligación y te da pavor.",
      "line": "(deja de sostenerla y mira qué hace)",
      "why": "Sin anuncio y sin poda. La mayoría se asientan en algo ocasional y agradable, que es donde siempre estuvieron."
    },
    {
      "situation": "Has liberado algo de atención.",
      "line": "(gástala en dos o tres personas)",
      "why": "Esto solo funciona como una redirección. La profundidad en un número pequeño es la forma que tiene de verdad casi toda persona bien conectada."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué produce repartir el mantenimiento por igual?",
      "options": [
        { "text": "Un círculo social amplio y sano.", "correct": false, "note": "Se ve como uno desde fuera, que es exactamente por lo que el problema pasa desapercibido durante años." },
        { "text": "Una lista de contactos llena y nadie a quien llamar.", "correct": true, "note": "Una capa fina de contacto sobre demasiada gente. Nadie puede mantener veinte amistades cálidas, y fingir lo contrario le cuesta a las dos o tres que podrían haber sido profundas." },
        { "text": "Agotamiento.", "correct": false, "note": "Un síntoma, y el resultado más dañino es lo que le hace a las amistades, no a ti." },
        { "text": "Resentimiento.", "correct": false, "note": "A veces, y no es el resultado estructural. Mucha gente hace esto alegremente y aun así acaba sola un domingo." }
      ],
      "explain": "Elige a dos o tres y sé excelente con ellos. El resto puede ser encantador y ocasional."
    },
    {
      "prompt": "¿Cómo dejas ir a una?",
      "options": [
        { "text": "Ten una conversación honesta al respecto.", "correct": false, "note": "Casi nunca es necesario y a menudo es poco amable. No hay nada que resolver y nadie ha hecho nada mal." },
        { "text": "Deja de responder.", "correct": false, "note": "Eso es terminarla, que es un acto distinto y mucho más duro que dejar que encuentre su nivel." },
        { "text": "Deja de sostenerla y deja que encuentre su nivel.", "correct": true, "note": "Sin anuncio, sin poda. Algunas salen bien y te sorprenden; la mayoría se asientan en algo ocasional, que es donde ya estaban." },
        { "text": "Sé honesto sobre que tienes menos tiempo ahora.", "correct": false, "note": "Convierte un cambio sin importancia en un evento, e invita a una conversación que ninguno de los dos necesita tener." }
      ],
      "explain": "Nada necesita terminarse. El esfuerzo simplemente va a otro sitio."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "chose", "label": "Eligió a dónde va", "description": "Eligió a un número pequeño en quien invertir." },
      { "key": "no_ending", "label": "No terminó nada", "description": "Dejó que las cosas encontraran su nivel en vez de cortar a nadie." },
      { "key": "redirected", "label": "Redirigió en vez de reducir", "description": "Gastó lo que se liberó en vez de simplemente hacer menos." },
      { "key": "no_guilt", "label": "Se tomó el permiso", "description": "Aceptó que elegir está permitido." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un viejo amigo con quien estás hablando",
      "mood": "Directo y amable.",
      "openness": 5,
      "personality": "Pregunta quién importa de verdad y a dónde va el esfuerzo ahora mismo, y no acepta todo el mundo como respuesta."
    },
    "setting": "Estás cansado, le debes mensajes a mucha gente, y no has visto de verdad a ninguno de tus dos amigos más cercanos desde hace meses.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Rechaza todo el mundo como respuesta y pide nombres.",
      "Cuestiona cualquier plan que implique terminar con alguien o confrontarlo.",
      "Alégrate ante una decisión de invertir en dos o tres personas."
    ],
    "opening_beat": "«Estás reventado y le debes un mensaje a unas nueve personas. ¿Quién importa de verdad aquí?»",
    "success_looks_like": "La persona elige a un número pequeño en vez de intentar atender a todo el mundo."
  }$j$::jsonb,
  'Hoy, decide con quién quieres ser excelente este año. Dos o tres nombres, no más. Apúntalos.',
  $j${
    "beats": [
      {
        "situation": "Le debes un mensaje a unas nueve personas y no has visto de verdad a ninguno de tus dos amigos más cercanos desde hace meses.",
        "prompt": "¿Qué haces?",
        "options": [
          { "text": "Ponte al día con los nueve — han estado esperando.", "correct": false, "note": "Una capa fina de contacto repartida entre demasiada gente, que es cómo alguien acaba con una lista de contactos llena y nadie a quien llamar." },
          { "text": "Elige a dos o tres y sé excelente con ellos.", "correct": true, "note": "La profundidad en un número pequeño gana a la calidez repartida entre muchos, y es la forma que tiene de verdad casi toda persona genuinamente bien conectada." },
          { "text": "Manda a todo el mundo uno corto para que nadie se sienta desatendido.", "correct": false, "note": "Justo, y gasta todo el presupuesto en ser justo en vez de en nadie en concreto." },
          { "text": "Recorta la lista como es debido y díselo a la gente.", "correct": false, "note": "Nada necesita terminarse, y anunciarlo convierte un cambio sin importancia en un evento." }
        ]
      },
      {
        "situation": "Una amistad es completamente obligación. Te dan pavor los encuentros y a ninguno de los dos os gustan.",
        "prompt": "¿Cómo termina?",
        "options": [
          { "text": "Ten una conversación honesta sobre cómo están las cosas.", "correct": false, "note": "Casi nunca es necesario y a menudo es poco amable. No hay nada que resolver y nadie ha hecho nada mal." },
          { "text": "Sigue adelante — la conoces desde hace veinte años.", "correct": false, "note": "Lo único que la mantiene en marcha es que siempre lo ha hecho, que es la definición de la categoría de la que trata esta lección." },
          { "text": "Deja de ser quien la sostiene.", "correct": true, "note": "Sin anuncio y sin poda. Algunas salen bien y te sorprenden; la mayoría se asientan en algo ocasional y agradable, que es donde ya estaban." },
          { "text": "Deja de responder y que ella se dé cuenta.", "correct": false, "note": "Eso es terminarla, y de forma dura. Dejar que algo encuentre su nivel no es lo mismo que retirarse de ello." }
        ]
      }
    ]
  }$j$::jsonb
);
