-- Spanish: Interviews, track 2 — Por qué tú, y por qué ahora.
--
-- Conventions as migration 109. Two things this track forced:
--
-- **"Run out of" becomes "se me ha acabado".** The English leans on a phrase
-- that is honest, unarguable and blames nobody, and Spanish has the same one.
-- The drill accepts both "se me ha acabado" and "se me han acabado", because
-- the number agrees with whatever ran out and a reader should not fail a check
-- on a plural.
--
-- **The banned-title list is shorter than the English one.** "Responsable de"
-- had to come out: it is how a Spanish speaker names a job title and also how
-- they describe scope — "quiero ser responsable de más cosas" is exactly the
-- answer this lesson is asking for. A word list that fails the right answer is
-- worse than one that misses a wrong one.
--
-- **Pounds become euros.** The reader is in Spain.

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

select pg_temp.es_lesson('interview-motivation', 1,
  'Por qué te vas',
  $md$Esta la hacen siempre, y es la respuesta que con más probabilidad se le repite después a otra persona.

El instinto es explicar, y explicar significa enumerar lo que está mal donde estás. Ahí está la trampa. Todo lo que digas de tu empresa actual se escucha como un adelanto de lo que dirás de esta dentro de dos años, y quien te entrevista no necesita pensarlo conscientemente para que te cueste dinero.

**La jugada:** di qué se te ha acabado, y luego hacia dónde vas. Nada más.

*Se me ha acabado* es la expresión que hace el trabajo. Es honesta, no se puede discutir, y no contiene ninguna acusación. Se te ha acabado el alcance, o se te han acabado los problemas nuevos, o la gente de la que aprender — todo verdad, todo mirando hacia delante, y nada de ello es culpa de nadie.

La regla no es ser positivo sobre un mal trabajo. Es ser breve sobre él. Una oración sobre el pasado, una frase sobre el futuro, y sigue.$md$,
  $j$[
    {
      "situation": "Te vas porque el trabajo dejó de ser interesante.",
      "line": "Ya he hecho la misma forma de problema tres veces allí, y se me han acabado los nuevos.",
      "why": "Nombra el límite sin nombrar a un villano. Además se puede contrastar con el CV, y eso hace que aterrice como un motivo y no como una frase hecha."
    },
    {
      "situation": "Te vas porque tu jefe es difícil.",
      "line": "Quiero estar en un sitio con más gente por delante de mí que por detrás. Donde estoy eso ya no es así.",
      "why": "El motivo verdadero, dicho a la altura de la situación y no de la persona. Cada palabra sobrevive a que se la repitan a tu jefe actual."
    },
    {
      "situation": "Hubo una reestructuración y el trabajo que aceptaste no es el que tienes.",
      "line": "En marzo reorganizaron el equipo y el puesto que salió de ahí no es el que yo quería estar haciendo.",
      "why": "Un dato con una fecha, y sin queja pegada. Las reestructuraciones son de lo más normal y quien entrevista las oye toda la semana."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué respuesta te sale más cara, aunque las cuatro sean verdad?",
      "options": [
        { "text": "La dirección es un caos y no se decide nada.", "correct": true, "note": "La frase verdadera más cara que existe. Les dice lo que dirás de ellos, y convierte todas las respuestas siguientes en algo sobre tu criterio en vez de sobre tu trabajo." },
        { "text": "Se me han acabado las cosas que aprender allí.", "correct": false, "note": "Mira hacia delante y no se puede discutir. Dice algo sobre el techo y no sobre la gente que hay debajo." },
        { "text": "Reestructuraron el equipo y mi puesto cambió.", "correct": false, "note": "Un dato con fecha. Quien entrevista oye esto varias veces por semana y no lleva ninguna carga." },
        { "text": "Quiero una versión más grande del problema en el que he estado trabajando.", "correct": false, "note": "La más fuerte de las cuatro, porque va entera sobre hacia dónde vas y se puede contrastar con tu CV." }
      ],
      "explain": "Cualquier frase sobre tu empresa actual se escucha como un adelanto. Di qué se te ha acabado en su lugar."
    },
    {
      "prompt": "Quien te entrevista insiste: «Me parece justo, pero ¿no había nada que te retuviera?». ¿Para qué es esa repregunta?",
      "options": [
        { "text": "Para ver si la primera respuesta era la respuesta entera.", "correct": false, "note": "En parte, y no es lo que está midiendo. Le interesa más si te vas a poner a quejarte ahora que se ha abierto una puerta." },
        { "text": "Para averiguar si te empujaron a salir.", "correct": false, "note": "A veces, y que te hayan despedido es otra conversación con su propia forma. Casi ninguna repregunta de aquí es esa." },
        { "text": "Para ver si aceptas la invitación a quejarte.", "correct": true, "note": "Es una puerta abierta, y cruzarla es el error. Responde con calidez, nombra una cosa que de verdad vayas a echar de menos, y para." },
        { "text": "Para rellenar tiempo antes de la siguiente pregunta.", "correct": false, "note": "Nada a estas alturas de una entrevista es relleno, y una segunda pregunta sobre el mismo asunto nunca es ociosa." }
      ],
      "explain": "Una repregunta sobre por qué te vas suele ser una invitación a decir más de lo que deberías. Nombra una cosa que echarás de menos, y para."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "pointed_forwards", "label": "Apuntó hacia delante", "description": "Dijo hacia dónde va en vez de de qué se escapa." },
      { "key": "no_blame", "label": "No nombró a ningún villano", "description": "Mantuvo la respuesta a la altura de la situación y no de una persona." },
      { "key": "brief", "label": "Fue breve", "description": "Una oración sobre el pasado, una frase sobre el futuro, y paró." },
      { "key": "honest", "label": "Era verdad", "description": "Dio el motivo real, con el nivel de detalle que eligió, en vez de uno fabricado." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Ceri Hughes",
      "role": "la responsable de contratación, que ha hecho esto muchas veces",
      "mood": "Con curiosidad de verdad, sin ninguna prisa.",
      "openness": 4,
      "personality": "Cercana y tranquila, y repregunta ante cualquier cosa que suene ensayada."
    },
    "setting": "Una primera entrevista, a los ocho minutos. Tu historia ya está contada y quien contrata ha pasado a la siguiente pregunta obvia.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si la persona critica a su empresa actual, repregunta con suavidad abriéndole la puerta en vez de objetar.",
      "No aceptes una respuesta que suene ensayada sin una repregunta.",
      "No te alargues más de una o dos frases, al ritmo de una primera entrevista real."
    ],
    "opening_beat": "«Buen resumen, gracias. Entonces, ¿por qué estás buscando?»",
    "success_looks_like": "La persona responde hacia delante, con brevedad, y sin una sola frase que le importara que le repitieran."
  }$j$::jsonb,
  'Escribe la frase que usarías para explicar por qué te vas, y luego léela en voz alta imaginando que tu jefe actual está en la sala. Si alguna parte te hace encogerte, esa es la parte que hay que cortar. Apunta la versión con la que te quedaste.',
  $j${
    "says": "Buen resumen, gracias. Entonces, ¿por qué estás buscando?",
    "model": {
      "line": "Ya he hecho la misma forma de problema tres veces allí y se me han acabado los nuevos. Quiero la versión que es demasiado grande para que la sostenga una sola persona.",
      "why": "Una oración sobre el pasado, una frase sobre el futuro, y ni una palabra que te importara que le repitieran a tu jefe actual."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["tóxico", "tóxica", "microgestiona", "pesadilla", "incompetente", "politiqueo", "mi jefe", "mi jefa", "horrible", "nefasto", "odiaba", "no tiene ni idea"], "requirement": "Nada sobre una persona, y nada que no dirías delante de ella" },
      { "kind": "contains_any", "words": ["quiero", "busco", "hacia", "siguiente", "se me ha acabado", "se me han acabado", "aprender", "crecer", "más grande"], "requirement": "Apúntalo a aquello hacia lo que vas" },
      { "kind": "max_sentences", "n": 2, "requirement": "Dos frases. La brevedad es toda la técnica." }
    ],
    "maxChars": 500
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-motivation', 2,
  'Dentro de cinco años',
  $md$Nadie que haga esta pregunta cree que tengas un plan, y nadie quiere oír uno.

Están comprobando dos cosas. Que el camino por el que ya vas pasa por este puesto, y que no te vas a ir dentro de ocho meses. Las dos se pueden responder, y ninguna necesita un cargo.

**La jugada:** describe la dirección en la que ya viajas, no el destino.

Los cargos son la trampa. Nombrar el puesto de quien te entrevista es una amenaza, nombrar uno por encima es una cosa rara que decirle a quien sería tu jefe, y nombrar uno por debajo hace que se pregunten por qué te presentaste. Una dirección no tiene ninguno de esos problemas, y tiene una ventaja grande: se puede contrastar con tu CV, que es lo que la hace creíble.

*Más de esto y menos de aquello* es una respuesta completa. También lo es *el mismo trabajo, en problemas donde todavía nadie sabe la respuesta*. Las dos dicen algo real de ti y ninguna te compromete a nada que tuvieras que recordar.

Si de verdad no lo sabes, dilo y da la dirección igualmente. No saber el destino es normal. No saber la dirección se lee como ir a la deriva.$md$,
  $j$[
    {
      "situation": "Quieres más responsabilidad pero no te interesa dirigir personas.",
      "line": "Más adentro del trabajo, no más por encima de él. Me gustaría ser la persona a quien le dan la versión difícil de esto.",
      "why": "Una dirección con una forma clara, y de paso responde sin ruido a una pregunta que igual no habían hecho: si quieres su puesto."
    },
    {
      "situation": "De verdad no te lo has planteado.",
      "line": "Nunca he tenido un plan a cinco años y las dos veces que hice uno lo ignoré. Lo que sí te puedo decir es la dirección.",
      "why": "Honesto, con algo de autoironía, y no les deja sin nada. Rechazar la premisa está bien mientras respondas a la pregunta real que hay debajo."
    },
    {
      "situation": "Con el tiempo te gustaría estar haciendo el trabajo de quien te entrevista.",
      "line": "Llevando algo de este tamaño, probablemente. Que ya sé que es lo que haces tú, así que déjame decir que es la forma y no la silla.",
      "why": "Nombra la ambición y la desactiva en el mismo aliento. Fingir que no eres ambicioso delante de alguien ambicioso rara vez funciona."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué nombrar un cargo suele ser la respuesta más floja?",
      "options": [
        { "text": "O es halago, o es una amenaza, o es una pregunta sobre por qué te presentaste.", "correct": true, "note": "Los tres modos de fallo salen del mismo movimiento. Un cargo es una posición en su jerarquía, y toda posición tiene una lectura incómoda." },
        { "text": "Suena arrogante.", "correct": false, "note": "Solo una de las tres lecturas, y la menos frecuente. La ambición no es el problema; ser concreto sobre su organigrama sí." },
        { "text": "Cinco años queda demasiado lejos para predecirlo.", "correct": false, "note": "Cierto y no viene al caso. Ya saben que es imprevisible, y por eso no están preguntando de verdad por el destino." },
        { "text": "Te compromete a algo que puede que no quieras.", "correct": false, "note": "Un riesgo menor. Nadie te va a exigir tres años después una respuesta de entrevista." }
      ],
      "explain": "Una dirección se puede contrastar con tu CV. Un cargo solo se puede contrastar con su jerarquía."
    },
    {
      "prompt": "¿Qué hace que una dirección sea creíble en vez de una frase bonita?",
      "options": [
        { "text": "Decirla con convicción.", "correct": false, "note": "La convicción también la tiene una respuesta increíble. No es una prueba." },
        { "text": "Nombrar una habilidad concreta que quieres desarrollar.", "correct": false, "note": "Mejor, y sigue mirando solo hacia delante. Es la parte de la respuesta que no pueden comprobar." },
        { "text": "Que tus tres últimos movimientos ya apunten hacia ahí.", "correct": true, "note": "El CV es la prueba, y lo tienen delante. Una dirección que tu propia historia ya sostiene es la única versión que no se puede poner en duda." },
        { "text": "Atarla a los planes de la propia empresa.", "correct": false, "note": "Halagador, y responde a una pregunta sobre ellos en vez de sobre ti. Además caduca en cuanto sus planes cambien." }
      ],
      "explain": "La versión creíble de esta respuesta es la que tu CV ya estaba defendiendo antes de que la dijeras."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "gave_direction", "label": "Dio una dirección", "description": "Describió hacia dónde va en vez de un cargo." },
      { "key": "checkable", "label": "Encajaba con su historia", "description": "Nombró una dirección que sus últimos movimientos ya sostienen." },
      { "key": "no_title", "label": "Esquivó el organigrama", "description": "No nombró el puesto de quien entrevista, ni uno por encima ni uno por debajo." },
      { "key": "stayed_short", "label": "No planificó de más", "description": "Respondió sin producir una estrategia a cinco años que nadie había pedido." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Lorna Bassey",
      "role": "una responsable de selección que ha hecho esta pregunta varios miles de veces",
      "mood": "Eficiente, tercera entrevista del día.",
      "openness": 3,
      "personality": "Rápida y agradable. Ha oído todas las versiones de esta respuesta y está escuchando para ver si encaja con el CV que tiene delante."
    },
    "setting": "Una entrevista de segunda ronda con una responsable de selección que pasa la misma tanda de preguntas a todos los candidatos.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si la persona nombra un cargo, pregunta con neutralidad qué le atrae de eso en concreto.",
      "No reacciones con calidez ante un plan. Reacciona con calidez ante una dirección que encaje con el CV.",
      "No te alargues. Tiene otra entrevista a en punto."
    ],
    "opening_beat": "«La típica, y luego te dejo en paz. ¿Dónde te ves dentro de cinco años?»",
    "success_looks_like": "La persona da una dirección en vez de un cargo, y es una que su historia ya sostiene."
  }$j$::jsonb,
  'Escribe tu respuesta de los cinco años como una dirección, sin ningún cargo dentro. Luego contrástala con tus tres últimos movimientos: si no apuntan ya hacia ahí, es una aspiración y no una dirección. Apunta la versión que sobreviva.',
  $j${
    "says": "La típica, y luego te dejo en paz. ¿Dónde te ves dentro de cinco años?",
    "model": {
      "line": "Más adentro del trabajo, no más por encima de él. Ya me he movido de lado dos veces para seguir en el mismo tipo de problema, y la dirección es más de eso.",
      "why": "Una dirección en vez de un destino, y la segunda frase es la prueba: es una dirección que su CV ya estaba defendiendo antes de que la dijera."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["tu puesto", "tu trabajo", "tu silla", "jefe de", "jefa de", "director de", "directora de", "consejero delegado", "director general", "al mando de", "llevar el departamento"], "requirement": "Ningún cargo, y desde luego no el suyo" },
      { "kind": "contains_any", "words": ["hacia", "dirección", "más adentro", "más a fondo", "más de", "tipo de", "seguir", "sigo", "mejor en"], "requirement": "Di la dirección, no el destino" },
      { "kind": "max_sentences", "n": 3, "requirement": "Tres frases como mucho" }
    ],
    "maxChars": 500
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-motivation', 3,
  'Por qué deberíamos contratarte',
  $md$Esta es la única pregunta de todo el proceso que te invita a defender tu propio caso, y casi todo el mundo declina la invitación por educación.

*Creo que encajaría bien* es la respuesta estándar y apenas es una respuesta. Se cubre las espaldas, usa una expresión que no significa nada, y devuelve una oportunidad que no va a volver. Te lo han preguntado. Responder con claridad no es arrogancia, es hacer lo que te han pedido.

**La jugada:** nombra en qué se decide el puesto, reclámalo, y pégale la prueba que hace la afirmación comprobable.

La primera parte es la que la gente se salta. Casi todos los candidatos responden con su mejor cualidad en vez de con el mayor problema del puesto, y una virtud que no apunta a nada es solo una cosa bonita sobre ti. Averigua para qué existe este puesto de verdad — normalmente alguien lo ha dicho antes en la entrevista — y responde sobre eso.

Después una sola prueba, y para. La tentación es enumerar tres, y la lista es más débil que la cosa concreta, porque una lista suena a estar buscando algo que pegue.$md$,
  $j$[
    {
      "situation": "El puesto existe porque un proceso del que nadie es dueño se rompe una y otra vez.",
      "line": "Esto se decide en desenredar algo de lo que son dueños tres equipos y que no controla ninguno. Es exactamente lo que hice en mi sitio anterior, y es la parte que cogería aunque el resto fuera aburrido.",
      "why": "Apunta al problema en vez de a una cualidad, y la prueba es una cosa en vez de una lista."
    },
    {
      "situation": "Tienes menos experiencia de la que pide la descripción del puesto.",
      "line": "Sobre el papel me faltan dos años. Lo que sí he hecho es la mitad difícil: llevé la migración que no quería nadie, y por eso apostaría por mí aquí.",
      "why": "Nombra primero la carencia, y eso le compra credibilidad a la afirmación. Defender tu caso rodeando un punto débil evidente, en vez de atravesándolo, es lo que hace que suene flojo."
    },
    {
      "situation": "No tienes ni idea de en qué se decide el puesto porque nadie lo ha dicho.",
      "line": "Respondería mejor a eso si supiera qué tienen que arreglar los primeros seis meses. ¿Puedo preguntarlo y luego responder bien?",
      "why": "Un movimiento legítimo y fuerte. Preguntar para qué es el puesto, al final, impresiona más que adivinarlo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Casi todos los candidatos responden a esto con su mejor cualidad. ¿Qué tiene de malo?",
      "options": [
        { "text": "No apunta a nada, así que es solo una cosa bonita sobre ti.", "correct": true, "note": "Una virtud solo se convierte en argumento cuando apunta al problema para el que existe el puesto. Sin apuntar, es un cumplido que te has hecho tú." },
        { "text": "Las cualidades son difíciles de demostrar.", "correct": false, "note": "Lo son, y el arreglo para eso son pruebas, no otro tema. Esta respuesta falla antes de que llegue la cuestión de las pruebas." },
        { "text": "Suena a fanfarronada.", "correct": false, "note": "El problema contrario, normalmente. Estas respuestas casi siempre pecan de modestas y no de atrevidas." },
        { "text": "Todo el mundo da las mismas cualidades.", "correct": false, "note": "Cierto y secundario. Una cualidad común apuntada con precisión al puesto sigue funcionando." }
      ],
      "explain": "Responde sobre el mayor problema del puesto, no sobre tu mejor rasgo."
    },
    {
      "prompt": "Ya has hecho tu afirmación. ¿Cuántas pruebas?",
      "options": [
        { "text": "Tres ejemplos, para que no dependa de una sola cosa.", "correct": false, "note": "Una lista se lee como una búsqueda de algo que pegue. Tres ejemplos que suenan flojos son peores que uno que aterriza." },
        { "text": "Una cosa concreta, y luego parar.", "correct": true, "note": "Una sola prueba, lo bastante concreta como para comprobarla, es la forma más fuerte disponible. Parar es parte de ella." },
        { "text": "Ninguna: la afirmación debería sostenerse sola.", "correct": false, "note": "Entonces vuelve a ser el escaqueo, solo que con una voz más segura. Una afirmación sin prueba es lo que también está ofreciendo todo el mundo en el proceso." },
        { "text": "Tantas como parezca que les interesan.", "correct": false, "note": "Leer la sala es buen instinto, y este es el momento equivocado. Aterriza una cosa y deja que pregunten." }
      ],
      "explain": "Una afirmación, una prueba, y parar. La lista es lo que la debilita."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named_the_problem", "label": "Apuntó al problema real", "description": "Respondió sobre en qué se decide el puesto en vez de sobre una virtud general." },
      { "key": "claimed_it", "label": "Hizo la afirmación con claridad", "description": "La dijo sin cubrirse las espaldas y sin relleno." },
      { "key": "evidence", "label": "Pegó una prueba", "description": "Dio una cosa concreta y comprobable en vez de una lista." },
      { "key": "stopped", "label": "Paró", "description": "Se resistió a añadir un segundo y un tercer ejemplo cuando el primero ya había aterrizado." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Marcus Delaney",
      "role": "el responsable de contratación, que ve a tres personas esta semana",
      "mood": "Ya lo tiene casi decidido, y usa esta pregunta para deshacer un empate.",
      "openness": 3,
      "personality": "Directo y algo impaciente con la modestia. No te va a rellenar un silencio."
    },
    "setting": "Los últimos minutos de una entrevista de ronda final. Todo lo demás ya se ha cubierto.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "No rescates una respuesta que se cubre las espaldas. Deja que el silencio se instale y mira qué hace con él.",
      "Si te preguntan qué tienen que arreglar los primeros seis meses, respóndelo con honestidad: es una buena pregunta.",
      "No te alargues. Esto es el final de una entrevista larga."
    ],
    "opening_beat": "«La última por mi parte. ¿Por qué debería contratarte a ti y no a las otras dos personas que veo esta semana?»",
    "success_looks_like": "La persona hace una afirmación clara apuntada al problema real del puesto, con una sola prueba concreta."
  }$j$::jsonb,
  'Averigua en qué se decide de verdad el puesto que quieres, en una frase. Luego escribe la afirmación y la única prueba. Apunta las dos, y fíjate en si tu primer instinto fue enumerar tres cosas.',
  $j${
    "says": "La última por mi parte. ¿Por qué debería contratarte a ti y no a las otras dos personas que veo esta semana?",
    "model": {
      "line": "Este puesto se decide en desenredar un proceso del que son dueños tres equipos y que no controla ninguno. Eso es exactamente lo que hice en mi sitio anterior, la reconstrucción del sistema de incidencias, y es la parte del trabajo que cogería aunque el resto fuera aburrido.",
      "why": "Apuntado al problema en vez de a una cualidad, una prueba en lugar de tres, y luego para."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["creo que sería", "creo que encajo", "creo que encajaría", "siento que", "ojalá", "buen encaje", "trabajador nato", "trabajo bien en equipo", "aprendo rápido", "se me da bien la gente"], "requirement": "Nada de cubrirse las espaldas y nada de relleno" },
      { "kind": "contains_any", "words": ["hice", "construí", "monté", "llevé", "reescribí", "he hecho", "cuando yo", "en mi sitio anterior", "en mi último"], "requirement": "Pega la prueba, no solo la afirmación" },
      { "kind": "max_words", "n": 70, "requirement": "Menos de setenta palabras. Una afirmación, una prueba, parar." }
    ],
    "maxChars": 600
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-motivation', 4,
  'Qué te motiva de verdad',
  $md$Las respuestas genéricas fallan por un motivo concreto: no pueden ser falsas.

*Me gusta resolver problemas. Me mueve el impacto. Disfruto con los retos.* Nadie en la historia de las entrevistas ha dicho lo contrario, lo que significa que estas frases no llevan información, y quien te entrevista, que hoy ya ha hecho esta pregunta cuatro veces, lo nota al instante.

**La jugada:** nombra aquello que ya explica tu CV.

Una motivación real se puede comprobar, y el sitio donde se comprueba es la página que tienen delante. Debería dar cuenta de algo que si no parecería raro: por qué te quedaste en un sitio dos años más de lo que tenía sentido, por qué hiciste un movimiento lateral, por qué acabas siempre en el mismo tipo de lío. Si tu respuesta no explica nada de tu CV, es una declaración de valores y no una motivación.

Esta es además la pregunta más útil de la entrevista para ti, porque averiguar la respuesta verdadera te dice si quieres el puesto. Una motivación que sabes nombrar es una con la que puedes contrastar el trabajo.

Concreta y un poco rara gana a admirable. *Me gusta averiguar por qué está pasando algo de verdad* es mejor respuesta que *el impacto*, y en parte es mejor porque no la va a dar nadie más.$md$,
  $j$[
    {
      "situation": "Sigues cogiendo trabajos donde hay algo roto.",
      "line": "Me gusta ser la persona que averigua por qué está pasando algo de verdad. Por eso he acabado en la parte sucia de tres trabajos y por eso sigo rechazando los ordenados.",
      "why": "Concreto, algo inusual, y explica un patrón visible en el CV. Esa última parte es lo que lo convierte de un valor en una motivación."
    },
    {
      "situation": "Te quedaste en una empresa mucho más tiempo que tus compañeros.",
      "line": "Tardo en irme de las cosas de las que sigo aprendiendo, y por eso estuve seis años allí mientras que todos los que empezamos juntos se fueron a los dos.",
      "why": "Coge lo más raro de la página y lo convierte en prueba. Responder a la pregunta que no han hecho vale más que responder a la que sí."
    },
    {
      "situation": "Tu respuesta honesta es que te gusta ser bueno en algo.",
      "line": "Ser bueno de verdad en una cosa en vez de apañado en cuatro. Me he movido de lado dos veces para seguir en el mismo problema.",
      "why": "Poco de moda, verdad, y comprobable de inmediato. Quien entrevista recuerda las respuestas que no estaban diseñadas para gustar."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué falla «me mueve el impacto»?",
      "options": [
        { "text": "Nadie dice lo contrario, así que no lleva información.", "correct": true, "note": "Una respuesta que no se puede contradecir no les ha dicho nada. Es la propiedad que define a todas las respuestas genéricas a esta pregunta." },
        { "text": "Es demasiado vaga para recordarla.", "correct": false, "note": "Un síntoma, no la causa. La vaguedad es a lo que suenan las respuestas que no se pueden refutar." },
        { "text": "A quien entrevista le disgustan las palabras de moda.", "correct": false, "note": "Le dan igual las palabras. Lo que falta es algo comprobable detrás de ellas." },
        { "text": "No menciona a la empresa.", "correct": false, "note": "Esta pregunta no va sobre ellos. Torcerla hacia la empresa es un error distinto." }
      ],
      "explain": "Si lo contrario de tu respuesta es algo que nadie diría jamás, tu respuesta no es información."
    },
    {
      "prompt": "¿Cómo sabes que tu respuesta es la verdadera?",
      "options": [
        { "text": "Es la que le darías a un amigo.", "correct": false, "note": "Una prueba decente y no suficiente. Un montón de cosas ciertas sobre ti no explican nada de tu carrera." },
        { "text": "Es algo que harías sin que te pagaran.", "correct": false, "note": "Una idea bonita que descarta sin ruido casi todas las motivaciones honestas, incluidos el dinero y el dominio del oficio." },
        { "text": "Explica algo de tu CV que si no parecería raro.", "correct": true, "note": "La única prueba que lleva evidencias pegadas. Si da cuenta de una decisión que está en la página, sobrevive a cualquier repregunta que puedan hacer." },
        { "text": "Puedes decirla sin titubear.", "correct": false, "note": "La soltura también la tiene una respuesta genérica bien ensayada." }
      ],
      "explain": "La verdadera da cuenta de una decisión que ya tomaste. Cualquier otra cosa es una declaración de valores."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "not_generic", "label": "Esquivó las respuestas de siempre", "description": "No echó mano del impacto, de los retos ni de resolver problemas." },
      { "key": "explains_cv", "label": "Explicó el CV", "description": "Nombró algo que da cuenta de una decisión real que está en la página." },
      { "key": "specific", "label": "Concreta hasta resultar rara", "description": "Dio una respuesta que no daría nadie más en el proceso." },
      { "key": "honest", "label": "Era verdad", "description": "Nombró la motivación real en vez de la admirable." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Yohannes Girma",
      "role": "un director que ha entrevistado a cuatro personas hoy",
      "mood": "Cansado de oír la misma frase.",
      "openness": 3,
      "personality": "Seco, atento, y abiertamente aburrido de las respuestas estándar. Se enciende de inmediato con cualquier cosa concreta."
    },
    "setting": "Una conversación con un director que se incorporó tarde al proceso y no va con guion.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si la persona da una respuesta genérica, dilo con claridad pero sin crueldad, y vuelve a preguntar.",
      "Enciéndete de forma perceptible cuando una respuesta sea concreta o algo inusual.",
      "No te alargues más de una o dos frases."
    ],
    "opening_beat": "«¿Qué te motiva de verdad? Y te aviso de que hoy ya he oído “resolver problemas” tres veces.»",
    "success_looks_like": "La persona nombra algo concreto que da cuenta de una decisión real de su CV."
  }$j$::jsonb,
  'Mira tu propio CV y busca la decisión que desde fuera parece más extraña. Escribe la motivación que la explica. Apunta las dos: la decisión rara y la frase que da cuenta de ella.',
  $j${
    "says": "¿Qué te motiva de verdad? Y te aviso de que hoy ya he oído resolver problemas tres veces.",
    "model": {
      "line": "Me gusta ser la persona que averigua por qué está pasando algo de verdad. Por eso he acabado en la parte sucia de tres trabajos distintos y por eso sigo rechazando los ordenados.",
      "why": "Concreta hasta resultar algo rara, y la segunda frase señala un patrón del CV, que es lo único que convierte un valor en una motivación."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["resolver problemas", "me mueve el impacto", "generar impacto", "ponerme a prueba", "me apasiona", "nuevos retos", "ritmo rápido", "marcar la diferencia", "ayudar a la gente"], "requirement": "Ninguna de las que dice todo el mundo" },
      { "kind": "contains_any", "words": ["por eso", "esa es la razón", "por lo que", "he acabado", "sigo", "cada vez", "dos veces", "tres veces"], "requirement": "Átalo a algo que ya está en tu CV" },
      { "kind": "max_words", "n": 70, "requirement": "Menos de setenta palabras" }
    ],
    "maxChars": 500
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-motivation', 5,
  'Dónde más estás entrevistando',
  $md$Esta pregunta está haciendo dos trabajos y los dos son razonables.

El primero es el calendario: cuánto tiempo tienen antes de que te hayas ido. El segundo es la calibración: qué más consideras comparable, lo cual les dice cómo ves el puesto y a veces les dice que su banda salarial está mal.

**La jugada:** responde con honestidad, con el nivel de detalle que elijas tú, y no te inventes nunca una oferta.

Nombrar empresas es opcional y rara vez hace falta. Lo útil para los dos es nombrar la forma: dos más en un punto parecido, o una más avanzada, o nada todavía porque acabas de empezar a mirar. Cualquiera de esas es una respuesta completa, y *nada todavía* no es una debilidad por mucho que lo parezca.

La oferta competidora inventada es el único movimiento de verdad peligroso de todo este tema. En un sector pequeño se puede comprobar, fija una fecha límite que te has inventado y dentro de la cual luego tienes que vivir, y si alguien la levanta — *estupendo, ¿para cuándo tienes que decidir?* — no tienes nada. La ganancia son unos cuantos miles de euros. La pérdida es la oferta.

Contarles una fecha límite real es otra cosa, y merece la pena hacerlo pronto y no como palanca.$md$,
  $j$[
    {
      "situation": "Tienes otros dos procesos más o menos en el mismo punto.",
      "line": "Otros dos, los dos por aquí más o menos. Nada decidido en ninguna parte, aquí tampoco.",
      "why": "Honesto, útil, y no nombra ninguna empresa. La última oración es cercana y señala sin ruido que ellos tampoco han decidido."
    },
    {
      "situation": "Este es el único proceso en el que estás.",
      "line": "Solo este, de momento. Estoy siendo bastante selectivo con lo que envío.",
      "why": "Convierte la respuesta que suena floja en una afirmación sobre el listón, que es verdad y es mejor que un segundo proceso inventado."
    },
    {
      "situation": "Tienes una oferta real con una fecha límite el viernes que viene.",
      "line": "Tengo una oferta que hay que decidir para el viernes. Prefería decirlo ahora y no soltároslo de golpe más adelante.",
      "why": "Una fecha límite real dicha pronto es información. La misma frase sacada en la negociación se lee como una palanca, aunque sea del todo cierta."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "No estás entrevistando en ningún otro sitio. ¿Cuál es la mejor respuesta?",
      "options": [
        { "text": "Decirlo, y decir por qué estás siendo selectivo.", "correct": true, "note": "La versión honesta con un motivo pegado. Estar en un solo proceso solo es flojo si lo presentas como un accidente." },
        { "text": "Decir que estás en conversaciones iniciales con un par de sitios.", "correct": false, "note": "Un invento pequeño que no compra nada y que una repregunta convierte en una retirada incómoda." },
        { "text": "Decir que prefieres no hablar de otros procesos.", "correct": false, "note": "Negarse a una pregunta razonable la vuelve interesante. Además insinúa una respuesta peor que la verdadera." },
        { "text": "Esquivarla y preguntar por sus plazos.", "correct": false, "note": "Un escaqueo que se ve, y sus plazos merecen una pregunta de todos modos, una vez has respondido." }
      ],
      "explain": "«Nada todavía» es una respuesta completa. Dilo con un motivo y deja de sonar a hueco."
    },
    {
      "prompt": "¿Por qué inventarse una oferta competidora es el peor movimiento disponible?",
      "options": [
        { "text": "Fija una fecha límite dentro de la cual luego tienes que vivir.", "correct": false, "note": "Uno de los tres motivos, y el menos grave. A una fecha límite se sobrevive; los otros son más difíciles." },
        { "text": "Es deshonesto.", "correct": false, "note": "Cierto, y por sí solo no es lo que lo hace peligroso. Muchos candidatos aceptarían ese cambio si funcionara." },
        { "text": "Se puede comprobar, crea una fecha límite y se derrumba si la ponen a prueba.", "correct": true, "note": "Las tres cosas a la vez, y la tercera es mortal. «¿Para cuándo tienes que decidir?» es la pregunta normal que viene después, y no tiene ninguna buena respuesta." },
        { "text": "Hace que parezcas mercenario.", "correct": false, "note": "A quien entrevista le parece perfectamente normal que un candidato tenga opciones. El problema es el invento, no la ambición." }
      ],
      "explain": "La ganancia son unos cuantos miles de euros y la pérdida es la oferta. Solo fechas límite reales, y dichas pronto."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "honest", "label": "Dijo la verdad", "description": "Respondió con exactitud, con el nivel de detalle que eligió." },
      { "key": "no_invention", "label": "No inventó nada", "description": "No fabricó un proceso ni una oferta competidora." },
      { "key": "right_detail", "label": "Dio la forma, no los nombres", "description": "Describió cómo está la cosa sin nombrar empresas innecesariamente." },
      { "key": "timing", "label": "Sacó pronto una fecha real", "description": "Cuando existía, la mencionó como información y no como palanca." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nula Brennan",
      "role": "la reclutadora interna que lleva el proceso",
      "mood": "Organizada, pensando en huecos de agenda.",
      "openness": 4,
      "personality": "Cercana y práctica. Hace la pregunta porque tiene que planificar a partir de la respuesta."
    },
    "setting": "El final de una segunda entrevista. La reclutadora ha vuelto a la llamada para hablar de los siguientes pasos.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si la persona menciona una oferta o una fecha límite, pregúntale para cuándo tiene que decidir.",
      "Muéstrate completamente tranquila con que el candidato tenga otras opciones.",
      "No te alargues, y sé práctica. Estás cuadrando una agenda, no poniendo a nadie a prueba."
    ],
    "opening_beat": "«Antes de dejarte ir: ¿estás hablando con alguien más ahora mismo? Me ayuda a saber cuánto tengo que empujar esto.»",
    "success_looks_like": "La persona responde con honestidad, con el nivel de detalle que elige, y no se inventa nada."
  }$j$::jsonb,
  'Escribe tu respuesta honesta a esta, incluida la versión en la que la respuesta es «nada todavía». Luego comprueba que no contiene ninguna empresa con la que no hayas hablado de verdad. Apúntala antes de necesitarla.',
  $j${
    "beats": [
      {
        "situation": "La reclutadora te pregunta si estás hablando con alguien más. No lo estás: este es el único proceso en el que estás.",
        "prompt": "¿Qué dices?",
        "options": [
          { "text": "Decir que estás en conversaciones iniciales con un par de sitios más.", "correct": false, "note": "Un invento pequeño que no compra nada. Una repregunta sobre dónde, y ya estás retrocediendo de una frase que no hacía falta decir." },
          { "text": "Decirlo, y decir que estás siendo selectivo con lo que envías.", "correct": true, "note": "La respuesta honesta con un motivo pegado. Estar en un solo proceso solo parece flojo si lo presentas como un accidente." },
          { "text": "Decir que prefieres no entrar en otros procesos.", "correct": false, "note": "Negarse a una pregunta razonable la vuelve interesante, e insinúa una respuesta peor que la verdadera." },
          { "text": "Preguntar por sus plazos en su lugar.", "correct": false, "note": "Un escaqueo que se ve. Sus plazos merecen una pregunta, y después de haber respondido." }
        ]
      },
      {
        "situation": "Sí tienes una oferta real, con una decisión que hay que dar para el viernes.",
        "prompt": "¿Cuándo lo mencionas?",
        "options": [
          { "text": "Ahora, como información, antes de que nadie esté negociando.", "correct": true, "note": "Una fecha límite real dicha pronto es algo que pueden planificar. La misma frase sacada durante una conversación de sueldo se lee como una palanca, aunque sea del todo cierta." },
          { "text": "En la fase de oferta, que es donde más palanca tiene.", "correct": false, "note": "Donde además más daño hace a cómo te leen, y donde es más probable que la pongan a prueba." },
          { "text": "En ningún momento: es asunto tuyo.", "correct": false, "note": "Lo es, y guardártelo te cuesta justo aquello para lo que sirve, que es hacer que se muevan más rápido." },
          { "text": "Solo si preguntan directamente.", "correct": false, "note": "Acaban de hacerlo. Esta es la pregunta, y responderla a medias es una decisión que tendrás que explicar más adelante." }
        ]
      }
    ]
  }$j$::jsonb
);
