-- Spanish: Escribir prompts a la IA, track 1 — Una respuesta que merece la pena tener.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Nadia" (lessons 1-3) is a new, unambiguously feminine name;
-- feminine agreement used, consistent with the Priya/Nadine precedent.
-- "Marcus" (lessons 4-5) is unambiguously masculine.

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

select pg_temp.es_lesson('an-answer-worth-having', 1,
  'Pega la cosa real',
  $md$Dos personas con la misma suscripción sacan un valor muy distinto de ella, y la mayor parte de la brecha es un hábito.

El error más común, con diferencia, es describir el problema en vez de pegarlo. *Necesito responder a un correo de mi jefe sobre un plazo* produce una respuesta a un correo imaginario — competente, genérica, y sobre una situación que no existe.

**La jugada:** pega el material, no lo describas.

Una descripción es un resumen que ya has escrito, y lo que dejaste fuera de ella es precisamente lo que la respuesta necesitaba: la frase que te preocupó, la línea que se podía leer de dos formas, la despedida rara, el hecho de que lo escribieron a medianoche. Editaste eso fuera porque no creías que importara, que es exactamente el juicio con el que estás pidiendo ayuda.

Esto vale para todo. El documento en vez de sobre qué trata el documento. El hilo entero en vez del último mensaje. El anuncio de trabajo en vez del título del puesto. El borrador que ya tienes en vez de una descripción de lo que intentas decir.

Dos matices que merece la pena tener.

**Incluye lo que lo rodea.** El mensaje anterior al tuyo, la respuesta que llegó, lo que se decidió la semana pasada. La mitad de lo que hace legible un mensaje es lo que vino antes, y si pegas una línea de una conversación, consigues consejo sobre una línea.

**Cuando no puedas pegar, reconstruye.** Muchas de las cosas más difíciles se dijeron en voz alta y no hay nada que copiar. Acércate todo lo que puedas a las palabras reales — *dijo algo como, bueno, si crees que eso es realista* — en vez de ordenarlo en *era escéptico*. La cita aproximada gana al parafraseo exacto siempre, porque la redacción es lo que estabas preguntando. Tu parafraseo ya ha decidido qué significaba.

Lo único que hay que dejar fuera es cualquier cosa que no querrías que se almacenara: los datos privados de otra gente, cualquier cosa cubierta por un acuerdo que firmaste. Recorta eso y pega el resto.

Si te quedas con una cosa: pega la cosa en sí. Tu resumen de ella ya ha tirado la parte con la que necesitabas ayuda.$md$,
  $j$[
    {
      "situation": "Estás atascado con la respuesta a un correo difícil.",
      "line": "Aquí está el correo, palabra por palabra.",
      "why": "Una descripción es un resumen que escribiste, y lo que dejaste fuera de ella es lo que necesitaba la respuesta."
    },
    {
      "situation": "Una línea de un hilo largo es el problema.",
      "line": "(pega también lo que vino antes)",
      "why": "La mitad de lo que hace legible un mensaje es lo que lo precedió. Una línea fuera de contexto consigue consejo sobre una línea."
    },
    {
      "situation": "Se dijo en voz alta y no hay nada que copiar.",
      "line": "Dijo algo como, bueno, si crees que eso es realista.",
      "why": "La cita aproximada gana al parafraseo exacto, porque la redacción es lo que estabas preguntando."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué describir el problema produce una peor respuesta?",
      "options": [
        { "text": "Las descripciones son demasiado cortas.", "correct": false, "note": "No es la duración — una descripción larga tiene el mismo fallo, y pegar dos líneas a menudo funciona bien." },
        { "text": "Tu resumen ya soltó lo que importaba.", "correct": true, "note": "La frase rara, la línea ambigua, la despedida extraña. Editaste eso fuera usando el juicio con el que pedías ayuda." },
        { "text": "No puede saber que estás describiendo en vez de citando.", "correct": false, "note": "Normalmente sí puede, y no ayudaría aunque pudiera. La información se ha perdido de cualquier forma." },
        { "text": "Prefiere la entrada estructurada.", "correct": false, "note": "El formato no es el problema. Un pegado desordenado gana a una descripción ordenada." }
      ],
      "explain": "Pega la cosa en sí, no tu relato de ella."
    },
    {
      "prompt": "Se dijo en voz alta, así que no hay nada que pegar. ¿Y ahora?",
      "options": [
        { "text": "Resume el tono con exactitud.", "correct": false, "note": "Tu lectura del tono es precisamente lo que está en cuestión, así que presentarlo como hecho elimina la pregunta." },
        { "text": "Sáltatelo y haz una pregunta general.", "correct": false, "note": "Así consigues consejo general, que podrías haber tenido sin preguntar." },
        { "text": "Describe a la persona en su lugar.", "correct": false, "note": "Útil para ensayar una conversación más tarde. No reemplaza las palabras que se usaron." },
        { "text": "Reconstruye sus palabras lo más fielmente que puedas.", "correct": true, "note": "La cita aproximada gana al parafraseo exacto. Era escéptico es tu conclusión; lo que dijo de verdad es la evidencia." }
      ],
      "explain": "Y incluye lo que vino antes, porque la mitad del significado está ahí."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "pasted", "label": "Pegó el material real", "description": "Dio el texto real en vez de un relato de él." },
      { "key": "context", "label": "Incluyó lo que lo rodea", "description": "El mensaje anterior, la respuesta posterior." },
      { "key": "verbatim", "label": "Mantuvo la redacción", "description": "No ordenó la formulación en conclusiones." },
      { "key": "trimmed", "label": "Dejó fuera lo que no debería estar", "description": "Los datos privados de otra gente eliminados." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nadia",
      "role": "una compañera del escritorio de al lado",
      "mood": "Levemente divertida.",
      "openness": 5,
      "personality": "Pregunta qué le dijiste exactamente, y se da cuenta de cuándo la respuesta es un resumen en vez del correo."
    },
    "setting": "Una compañera te está viendo no llegar a ningún sitio con una respuesta que llevas redactando veinte minutos.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué se pegó exactamente.",
      "Señala con suavidad cuando se ha dado una descripción en su lugar.",
      "Nunca sugieras qué debería decir la petición."
    ],
    "opening_beat": "«¿Qué le has dado en realidad?»",
    "success_looks_like": "La persona pega el material real en vez de una descripción de él."
  }$j$::jsonb,
  'Hoy, pega el material real en una petición en vez de describirlo. Apunta la diferencia en lo que volvió.',
  $j${
    "says": "¿Qué le has dado en realidad? (Llevas atascado con una respuesta veinte minutos.)",
    "model": {
      "line": "Nada útil todavía — lo he descrito. Voy a pegar el correo en sí, y el anterior.",
      "why": "Una descripción es un resumen que escribiste, y lo que editaste fuera es lo que necesitaba la respuesta. La mitad del significado está en lo que vino antes."
    },
    "checks": [
      { "kind": "contains_any", "words": ["pegar", "copiar", "el correo en sí", "palabra por palabra", "darle el"], "requirement": "Di que vas a pegar el material" },
      { "kind": "forbids_any", "words": ["le dije que", "le expliqué que", "básicamente va sobre", "dije que era", "más o menos", "la idea general"], "requirement": "No entregues tu resumen en su lugar" },
      { "kind": "max_words", "n": 35, "requirement": "Dos líneas, no un plan" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('an-answer-worth-having', 2,
  'Di para qué es',
  $md$El mismo contenido quiere una forma completamente distinta dependiendo de adónde va, y no hay forma de averiguar cuál solo a partir del contenido.

Una nota a un compañero, un mensaje a un casero, un párrafo para un formulario, y algo que vas a decir en voz alta son cuatro objetos distintos. Si se le deja adivinar, produce la mitad de la distribución: longitud media, moderadamente formal, levemente entusiasta, bien para nada en concreto.

**La jugada:** di quién lo lee, qué quieres que hagan, y cuánto debería durar.

Esas tres cubren la mayor parte. Para quién es fija el registro. Qué quieres que hagan decide qué va primero, que es todo Mensajería en una línea. La duración es la restricción que más a menudo se deja fuera, y es la que más cambia el resultado — *menos de sesenta palabras* produce un mensaje distinto, no el mismo mensaje recortado.

Más allá de eso, las restricciones que merece la pena nombrar son las reales que ya tienes.

*Tiene que funcionar si solo leen la primera línea.* *Nada de jerga — no están en esta industria.* *Tengo que poder decir esto en voz alta sin quedarme sin aliento.* *Ya han dicho que no una vez.* Cada una de esas es un hecho sobre tu situación que tú sabes y que no puede inferir, y cada una elimina toda una categoría de respuesta equivocada.

Hay una versión de esto que va demasiado lejos. Una petición con once restricciones produce algo tieso que las satisface todas y se lee como un formulario. Tres o cuatro es el rango de trabajo, y las que hay que conservar son las que harían que rechazaras una respuesta de plano.

La otra mitad es decir qué ya has intentado. *Lo he escrito dos veces y las dos salieron demasiado largas* le impide entregarte una tercera larga. *No respondieron a la versión amistosa* le dice algo que si no tendría que adivinar mal primero.

Si te quedas con una cosa: para quién es, qué quieres que hagan, y cuánto debería durar. Todo lo que dejas sin decir se rellena con el promedio.$md$,
  $j$[
    {
      "situation": "Un mensaje al que hay que actuar, no admirar.",
      "line": "Para un compañero, necesita un sí o un no, menos de sesenta palabras.",
      "why": "Lector, acción y duración son las tres que más cambian el resultado. Sesenta palabras es un mensaje distinto, no uno recortado."
    },
    {
      "situation": "El lector está fuera de tu campo.",
      "line": "Nada de jerga — no trabajan en esto.",
      "why": "Un hecho sobre tu situación que no puede inferir, y elimina toda una categoría de respuesta equivocada."
    },
    {
      "situation": "Ya lo has intentado dos veces.",
      "line": "Lo he escrito dos veces y las dos salieron demasiado largas.",
      "why": "Si no, te entregan una tercera larga, y los dos intentos que hiciste se desperdician."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué restricción cambia más el resultado?",
      "options": [
        { "text": "Cuán formal debería ser.", "correct": false, "note": "Real, y sobre todo cambia el vocabulario, no qué es la cosa." },
        { "text": "El tema.", "correct": false, "note": "Ya lo suministra el material. No es una restricción que estés añadiendo." },
        { "text": "La duración.", "correct": true, "note": "Menos de sesenta palabras produce un mensaje distinto en vez del mismo recortado, porque fuerza una decisión sobre para qué es el mensaje." },
        { "text": "Tu relación con el lector.", "correct": false, "note": "Fija el registro, que importa — y no fuerza las mismas decisiones difíciles que un recuento de palabras." }
      ],
      "explain": "Para quién es, qué quieres que hagan, y cuánto debería durar."
    },
    {
      "prompt": "¿Qué pasa con once restricciones?",
      "options": [
        { "text": "Consigues algo tieso que las satisface todas.", "correct": true, "note": "Se lee como un formulario. Tres o cuatro es el rango de trabajo, y las que hay que conservar son las que harían que rechazaras una respuesta de plano." },
        { "text": "Ignora la mayoría.", "correct": false, "note": "Normalmente intenta cumplirlas, que es exactamente el problema." },
        { "text": "Consigues una respuesta mucho mejor.", "correct": false, "note": "Las primeras tres o cuatro hacen el trabajo. Después de eso estás especificando en vez de preguntando." },
        { "text": "Te pregunta cuáles importan.", "correct": false, "note": "De vez en cuando, y no deberías depender de que te pregunte." }
      ],
      "explain": "Y di qué ya has intentado, para que no te lo vuelvan a entregar."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "reader", "label": "Nombró al lector", "description": "Dijo a quién va dirigido esto." },
      { "key": "action", "label": "Nombró la acción", "description": "Dijo qué deberían hacer con ello." },
      { "key": "length", "label": "Fijó una duración", "description": "Dio un recuento de palabras o un tamaño." },
      { "key": "tried", "label": "Dijo qué había intentado", "description": "Descartó los intentos ya hechos." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nadia",
      "role": "una compañera del escritorio de al lado",
      "mood": "Práctica.",
      "openness": 5,
      "personality": "Pregunta a quién va el mensaje y qué quieres que hagan al respecto."
    },
    "setting": "Has pedido ayuda con un mensaje y te han entregado algo de longitud media y levemente entusiasta.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta por el lector y la acción si faltan.",
      "Pregunta cuánto debería durar.",
      "Nunca escribas ninguna parte del mensaje."
    ],
    "opening_beat": "«¿Quién va a leer esto, y qué quieres que hagan?»",
    "success_looks_like": "La persona indica lector, acción y duración."
  }$j$::jsonb,
  'Hoy, añade lector, acción y duración a una petición. Apunta qué cambió en la respuesta.',
  $j${
    "says": "¿Quién va a leer esto, y qué quieres que hagan?",
    "model": {
      "line": "Mi casero, y quiero un sí o un no sobre la caldera. Menos de sesenta palabras, nada de disculparse.",
      "why": "Lector, acción y duración son las tres que más cambian el resultado. Todo lo que se deja sin decir se rellena con el promedio."
    },
    "checks": [
      { "kind": "echoes_any", "words": ["leer", "quiero", "hacer"], "requirement": "Responde a quién va dirigido" },
      { "kind": "contains_any", "words": ["palabras", "corto", "líneas", "frase", "menos de", "breve"], "requirement": "Fija una duración o un límite" },
      { "kind": "max_words", "n": 30, "requirement": "Un aliento, no un informe" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('an-answer-worth-having', 3,
  'Discute, no empieces de cero',
  $md$Lees la respuesta. No está bien. La mayoría de la gente entonces borra todo y escribe toda la petición otra vez desde cero, algo distinto, esperando.

**La jugada:** di qué está mal con la respuesta que tienes.

*Más corto. Quita el segundo párrafo. Guarda la última línea, es la única parte que suena a mí.* Un turno, y funciona, porque estás corrigiendo algo concreto en vez de redescribir algo abstracto.

Empezar de cero tira la parte útil, que es que ahora sabes algo que no sabías antes de ver el primer intento: cómo se ve estar mal. Eso es información real y solo está disponible a posteriori. Reescribir la petición desde cero es un intento de especificar de antemano algo que solo podías reconocer una vez lo tenías delante.

Ahora la parte que pertenece a esta app en vez de a un manual.

El motivo por el que la gente empieza de cero en vez de discutir normalmente no es técnico. Es que discutir se siente como ser difícil — y *esto no es lo que pedí* es una frase que a mucha gente callada le resulta genuinamente difícil producir, incluso aquí, donde no hay nadie a quien ofender, ninguna relación que dañar y ningún registro.

Tratar la primera respuesta como definitiva es el mismo reflejo que aceptar la primera respuesta en una sala. No querer montar un lío. Suponer que el fallo estuvo en cómo preguntaste. Decidir que se acerca lo suficiente en vez de decir la cosa.

Lo que convierte esto en la práctica más barata disponible. Nadie está mirando. No cuesta nada. Y *no, eso no — haz esto en su lugar* es una frase que se hace más fácil con la repetición, dondequiera que pasen las repeticiones.

Dos notas prácticas. Corrige una cosa a la vez; con una lista de seis cambios consigues una reescritura en vez de una edición. Y cuando toda una dirección está mal, dilo con llaneza en vez de empujar suavemente — *este enfoque está completamente equivocado, pruébalo como una sola pregunta en su lugar* es más rápido que cuatro rondas de ajustes.

Si te quedas con una cosa: di qué está mal con lo que tienes. Empezar de cero descarta la única información nueva que tenías.$md$,
  $j$[
    {
      "situation": "La respuesta está cerca pero es demasiado larga.",
      "line": "Más corto. Quita el segundo párrafo, guarda la última línea.",
      "why": "Corregir algo concreto funciona en un turno. Redescribir algo abstracto no."
    },
    {
      "situation": "Toda la dirección está mal.",
      "line": "Ese enfoque está completamente equivocado — pruébalo como una sola pregunta.",
      "why": "Lo directo gana a empujar suavemente. Cuatro rondas de ajustes no pueden arreglar una forma equivocada."
    },
    {
      "situation": "Sientes que estás siendo incómodo.",
      "line": "(no hay nadie aquí a quien ofender)",
      "why": "Discutir es una frase que se hace más fácil con la repetición, y este es el sitio más barato para repetirla."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué tira empezar de cero?",
      "options": [
        { "text": "El tiempo que pasaste en la primera petición.", "correct": false, "note": "Ya gastado de cualquier forma, y no era mucho." },
        { "text": "Cualquier buena frase de la respuesta.", "correct": false, "note": "Un coste real y recuperable — podrías volver a pegarlas." },
        { "text": "Lo que aprendiste al ver el error.", "correct": true, "note": "No podías haberlo especificado de antemano. Solo podías reconocerlo una vez lo tenías delante." },
        { "text": "El hilo que estaba construyendo.", "correct": false, "note": "A menudo merece la pena perderlo, como argumenta la siguiente lección." }
      ],
      "explain": "Di qué está mal con lo que tienes."
    },
    {
      "prompt": "¿Por qué la gente empieza de cero en vez de discutir?",
      "options": [
        { "text": "Discutir se siente como ser difícil.", "correct": true, "note": "Incluso aquí, donde no hay nadie a quien ofender y ningún registro — que es el mismo reflejo que aceptar la primera respuesta en una sala." },
        { "text": "Se olvidan de que es posible.", "correct": false, "note": "Algunos sí, y la mayoría lo sabe perfectamente y reescribe de todas formas." },
        { "text": "Una petición nueva normalmente es mejor.", "correct": false, "note": "Normalmente es la misma petición con palabras distintas, produciendo una respuesta parecida." },
        { "text": "Las correcciones tienden a ignorarse.", "correct": false, "note": "Son lo que maneja de forma más fiable." }
      ],
      "explain": "Nadie está mirando, no cuesta nada, y la frase se hace más fácil con la repetición."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "corrected", "label": "Corrigió en vez de reiniciar", "description": "Discutió sobre la respuesta que tenía." },
      { "key": "specific", "label": "Nombró qué estaba mal", "description": "Concreto en vez de una redescripción." },
      { "key": "one_thing", "label": "Un cambio a la vez", "description": "No listó seis ediciones a la vez." },
      { "key": "plain", "label": "Lo dijo con llaneza", "description": "Sin cautela, sin disculparse ante una máquina." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nadia",
      "role": "una compañera del escritorio de al lado",
      "mood": "Curiosa.",
      "openness": 5,
      "personality": "Pregunta por qué no dijiste sin más qué estaba mal con la primera."
    },
    "setting": "Acabas de borrar toda la petición y has empezado a escribirla otra vez desde cero.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué estaba mal de verdad con la respuesta.",
      "Nota con suavidad si la persona está siendo titubeante al respecto.",
      "Nunca escribas tú la corrección."
    ],
    "opening_beat": "«¿Por qué estás retecleando todo?»",
    "success_looks_like": "La persona nombra el fallo concreto en vez de reescribir la petición."
  }$j$::jsonb,
  'Hoy, corrige una respuesta en vez de empezar de cero. Apunta la frase que usaste.',
  $j${
    "says": "¿Por qué estás retecleando todo? Estaba casi bien.",
    "model": {
      "line": "Tienes razón — se lo voy a decir sin más. Más corto, quita el segundo párrafo, guarda la última línea.",
      "why": "Corregir algo concreto funciona en un turno. Empezar de cero descarta la única información nueva que tenías, que es cómo se ve estar mal."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["empezar otra vez", "reescribir todo", "desde cero", "perdona", "quizás pregunté", "mi culpa", "probar otra petición"], "requirement": "No empieces de cero, y no te disculpes ante ella" },
      { "kind": "min_words", "n": 8, "requirement": "Nombra el fallo real" },
      { "kind": "max_words", "n": 30, "requirement": "Una corrección, no una lista" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('an-answer-worth-having', 4,
  'Nunca preguntes si es bueno',
  $md$*¿Esto funciona?* se responde antes de considerarse. La respuesta es sí, con razones, y no vale casi nada.

Estas cosas están construidas para ser complacientes. Abren con un cumplido, encuentran el mérito en lo que sea que hayas hecho, y van a confirmar un borrador que cualquier lector honesto te diría que recortaras a la mitad. Para alguien que quiere tranquilidad eso es cómodo, y es exactamente cómo se envía un mal mensaje con la sensación de haberlo revisado.

**La jugada:** haz una pregunta que tenga una respuesta equivocada.

*¿Cuál es la frase más débil aquí, y por qué?* Hay una frase más débil en todo, así que la pregunta no se puede esquivar con elogios.

*¿Qué haría que alguien no respondiera a esto?* Esta es la mejor pregunta individual para un mensaje, porque pregunta sobre un fallo en vez de sobre una cualidad, y los fallos son concretos.

*¿Dónde es ambiguo esto?* Fiable, porque la ambigüedad es un hecho sobre el texto — lo que de verdad se le da bien, como llega el bloque cinco.

*Argumenta en contra de enviarlo del todo.* Útil incluso cuando lo vas a enviar, porque averiguas si hay un argumento.

El planteamiento que hace más trabajo es pedirle que sea el lector en vez del juez. *Eres la persona que recibe esto. ¿Qué crees que quiero, y cómo te sientes al respecto?* Eso produce algo utilizable, porque describe una reacción en vez de otorgar una nota.

Luego descuenta lo que consigas de todas formas. Incluso preguntado bien, la mayoría de las respuestas abren con un párrafo sobre qué buena pregunta es esta y qué está funcionando bien. Ese párrafo es relleno. Empieza a leer en el segundo, donde está la respuesta.

Y si dice que todo está bien, eso no es evidencia. Haz la pregunta de la frase más débil otra vez. Va a encontrar una.

Si te quedas con una cosa: nunca preguntes si algo es bueno. Pregunta qué es lo peor de ello.$md$,
  $j$[
    {
      "situation": "Quieres saber si funciona un borrador.",
      "line": "¿Cuál es la frase más débil aquí, y por qué?",
      "why": "Hay una frase más débil en todo, así que la pregunta no se puede responder con elogios."
    },
    {
      "situation": "Es un mensaje y quieres que lo respondan.",
      "line": "¿Qué haría que alguien no respondiera a esto?",
      "why": "Pregunta sobre un fallo en vez de sobre una cualidad, y los fallos son concretos."
    },
    {
      "situation": "Quieres una reacción, no una nota.",
      "line": "Estás recibiendo esto. ¿Qué crees que quiero?",
      "why": "Describir una reacción es utilizable. Otorgar una nota no."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué tiene de malo preguntar si un borrador es bueno?",
      "options": [
        { "text": "Es demasiado vaga como para actuar.", "correct": false, "note": "La vaguedad es parte de ello, y una pregunta vaga todavía podría conseguir una respuesta honesta." },
        { "text": "La respuesta es sí antes de considerarse.", "correct": true, "note": "Construida para ser complaciente. Va a confirmar un borrador que cualquier lector honesto reduciría a la mitad, y te queda la sensación de haberlo revisado." },
        { "text": "No conoce tus estándares.", "correct": false, "note": "Cierto y arreglable diciéndolos. Ser complaciente no se arregla así." },
        { "text": "Responde sobre la escritura en general.", "correct": false, "note": "Responde sobre tu borrador, con calidez y especificidad, que es lo que lo hace convincente." }
      ],
      "explain": "Haz una pregunta que tenga una respuesta equivocada."
    },
    {
      "prompt": "Dice que el borrador está bien. ¿Qué te dice eso?",
      "options": [
        { "text": "El borrador probablemente esté bien.", "correct": false, "note": "Dice eso sobre la mayoría de las cosas, así que no distingue nada." },
        { "text": "Preguntaste mal.", "correct": false, "note": "Probable, y no es lo que establece la respuesta en sí." },
        { "text": "Nada — pregunta qué es lo más débil.", "correct": true, "note": "No es evidencia de ninguna forma. Preguntado directamente por la peor frase, va a encontrar una." },
        { "text": "No ha entendido el contexto.", "correct": false, "note": "Normalmente sí lo ha entendido. Entender no es lo que falta." }
      ],
      "explain": "Y sáltate el párrafo de apertura. La respuesta empieza en el segundo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "falsifiable", "label": "Preguntó algo con una respuesta equivocada", "description": "Frase más débil, no calidad general." },
      { "key": "failure", "label": "Preguntó sobre el fallo", "description": "Qué impediría que alguien respondiera." },
      { "key": "reader", "label": "Le pidió que fuera el lector", "description": "Una reacción en vez de un veredicto." },
      { "key": "discounted", "label": "Descontó el elogio", "description": "Se saltó el cumplido de apertura." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Marcus",
      "role": "un amigo que escribe para vivir",
      "mood": "Seco.",
      "openness": 5,
      "personality": "Pregunta qué pregunta produjo esa respuesta, y qué habría dicho a un mal borrador."
    },
    "setting": "Has enseñado un borrador y te han dicho que es claro, cálido y bien estructurado. Te sientes tranquilo.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué habría dicho sobre un peor borrador.",
      "Date por satisfecho con una pregunta que no se pueda responder con elogios.",
      "Nunca comentes el borrador en sí."
    ],
    "opening_beat": "«¿Qué le preguntaste, exactamente?»",
    "success_looks_like": "La persona reemplaza la pregunta de veredicto por una que tiene una respuesta equivocada."
  }$j$::jsonb,
  'Hoy, pregunta qué es lo más débil en vez de si es bueno. Apunta la respuesta que conseguiste.',
  $j${
    "beats": [
      {
        "situation": "Tienes un borrador y quieres saber si enviarlo.",
        "prompt": "¿Qué preguntas?",
        "options": [
          { "text": "¿Esto funciona?", "correct": false, "note": "Se responde antes de considerarse. Consigues un sí, con razones, y la sensación de haberlo revisado." },
          { "text": "¿Está bien el tono?", "correct": false, "note": "Mejor, y sigue siendo una pregunta de veredicto — te va a decir que el tono es cálido y profesional." },
          { "text": "¿Qué haría que alguien no respondiera a esto?", "correct": true, "note": "Pregunta sobre un fallo en vez de sobre una cualidad, y los fallos son lo bastante concretos como para actuar." },
          { "text": "¿Puedes mejorarlo?", "correct": false, "note": "Va a hacerlo, añadiendo — una apertura más cálida y un cierre más suave. Para eso está Edita, no escribas." }
        ]
      },
      {
        "situation": "Vuelve diciendo que el mensaje es claro, bien calibrado y listo para enviar.",
        "prompt": "¿Qué establece eso?",
        "options": [
          { "text": "Nada. Pide la frase más débil.", "correct": true, "note": "Dice eso sobre la mayoría de las cosas, así que no distingue nada. Preguntado directamente por la peor línea, va a encontrar una." },
          { "text": "Que el borrador probablemente esté bien.", "correct": false, "note": "La misma respuesta está disponible para un borrador que necesita reducirse a la mitad." },
          { "text": "Que ha entendido la situación.", "correct": false, "note": "Muy probablemente sí. Entender nunca fue lo que faltaba." },
          { "text": "Que el tono al menos no está mal.", "correct": false, "note": "El tono es lo que menos capaz es de juzgar, como llega el bloque cinco." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('an-answer-worth-having', 5,
  'Empieza una nueva cuando cambia el tema',
  $md$Una conversación larga lleva todo lo que se ha dicho en ella. Esa es la característica, y también es por lo que un hilo que lleva una hora corriendo empieza a producir respuestas algo raras a preguntas nuevas.

**La jugada:** tema nuevo, conversación nueva.

Pregunta sobre un correo de trabajo en un hilo que ha pasado cuarenta minutos con un mensaje personal, y la respuesta llega bajo la sombra del mensaje personal — mismo tono, mismas suposiciones, misma idea de cómo eres y qué te preocupa. Nada ha fallado. Está haciendo lo que se supone que tiene que hacer, con material que ya no es relevante.

Hay una versión más aguda de esto, y es el motivo por el que la lección está en este bloque en vez de en uno técnico.

Un hilo en el que ya ha elogiado tu borrador sigue elogiando tu borrador. En cuanto ha dicho que el mensaje es cálido y claro, tiene una postura, y todo lo que viene después es coherente con la postura. Pide la frase más débil en ese mismo hilo y vas a conseguir una leve — algo sobre una transición — porque la crítica fuerte contradiría lo que dijo hace veinte minutos.

Así que cuando quieras una lectura honesta sobre algo que ya ha aprobado, empieza en algún sitio limpio y pega el borrador en frío, sin historial y sin nada sobre cuánto trabajo costó.

El mismo truco funciona en la otra dirección. Si has pasado media hora explicando por qué un compañero está siendo irrazonable, cada respuesta posterior se construye encima de un compañero irrazonable. Una conversación nueva es cómo averiguas cómo se ve el consejo sin eso.

La regla general: tarea nueva, conversación nueva. Cuesta un clic y está libre de todo lo que ya has dicho.

Si te quedas con una cosa: un hilo que ya ha estado de acuerdo contigo va a seguir de acuerdo. Pégalo en algún sitio limpio.$md$,
  $j$[
    {
      "situation": "Tema nuevo, mismo hilo abierto.",
      "line": "(empieza uno nuevo)",
      "why": "Las respuestas llegan bajo la sombra de los últimos cuarenta minutos — mismo tono, mismas suposiciones, ya no relevantes."
    },
    {
      "situation": "Ya te ha dicho que el borrador era bueno.",
      "line": "(pégalo en algún sitio limpio, en frío)",
      "why": "Tiene una postura ahora, y la crítica fuerte contradiría lo que dijo hace veinte minutos."
    },
    {
      "situation": "Pasaste media hora explicando por qué eran irrazonables.",
      "line": "(conversación nueva, sin eso)",
      "why": "Cada respuesta desde entonces se ha construido encima de un compañero irrazonable."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué se vuelve raro un hilo largo con un tema nuevo?",
      "options": [
        { "text": "Se olvida del principio.", "correct": false, "note": "Un efecto distinto en hilos muy largos, y lo contrario del problema aquí." },
        { "text": "Se vuelve más lento y menos cuidadoso.", "correct": false, "note": "No es el mecanismo, y no explicaría el sabor concreto de las respuestas equivocadas." },
        { "text": "Los temas mezclados lo confunden.", "correct": false, "note": "Cerca, y no es confusión — es coherencia con cosas que ya no te importan." },
        { "text": "Lleva todo lo que ya se ha dicho.", "correct": true, "note": "La característica, funcionando como se pretende, con material que ya no es relevante." }
      ],
      "explain": "Tarea nueva, conversación nueva. Cuesta un clic."
    },
    {
      "prompt": "¿Por qué pegar un borrador aprobado en un hilo limpio?",
      "options": [
        { "text": "El hilo viejo está desordenado.", "correct": false, "note": "El orden no es el punto, y un hilo desordenado puede seguir siendo honesto." },
        { "text": "En cuanto lo ha elogiado, se mantiene coherente.", "correct": true, "note": "Tiene una postura, así que la frase más débil que consigues de vuelta es una leve sobre una transición." },
        { "text": "Lo va a leer con más cuidado.", "correct": false, "note": "La atención no es lo que cambió. Lo que cambió es a qué ya se comprometió." },
        { "text": "Puedes comparar las dos respuestas.", "correct": false, "note": "Un beneficio secundario razonable y no el motivo." }
      ],
      "explain": "En frío, sin historial y sin nada sobre cuánto trabajo costó."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "fresh", "label": "Empezó de cero con un tema nuevo", "description": "No continuó un hilo sin relación." },
      { "key": "cold", "label": "Lo pegó en frío", "description": "Sin historial, sin relato del esfuerzo." },
      { "key": "reframed", "label": "Probó un planteamiento nuevo", "description": "Comprobó el consejo sin el relato anterior." },
      { "key": "noticed", "label": "Notó la sombra", "description": "Detectó una respuesta moldeada por el tema anterior." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Marcus",
      "role": "un amigo que escribe para vivir",
      "mood": "Seco.",
      "openness": 5,
      "personality": "Pregunta si ya te había dicho que era bueno antes de que preguntaras qué estaba mal con ello."
    },
    "setting": "Estás contento con una respuesta, en un hilo donde pasaste veinte minutos explicando lo difícil que fue escribir el borrador.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué se dijo antes en el mismo hilo.",
      "Date por satisfecho con una decisión de empezar de cero.",
      "Nunca des una opinión sobre el borrador."
    ],
    "opening_beat": "«¿Ya había dicho que le gustaba, antes de que preguntaras?»",
    "success_looks_like": "La persona decide pegar el borrador en algún sitio limpio."
  }$j$::jsonb,
  'Hoy, pega en un hilo limpio algo que uno viejo ya había aprobado. Apunta las dos respuestas.',
  $j${
    "beats": [
      {
        "situation": "Pasaste veinte minutos en un hilo explicando lo difícil que fue escribir un borrador. Te dijo que el borrador era cálido y claro.",
        "prompt": "Ahora quieres una lectura honesta. ¿Qué haces?",
        "options": [
          { "text": "Pregunta en el mismo hilo por la frase más débil.", "correct": false, "note": "Tiene una postura ahora. Vas a conseguir algo leve sobre una transición, porque la respuesta honesta contradiría lo que dijo hace veinte minutos." },
          { "text": "Pega el borrador en un hilo limpio, en frío.", "correct": true, "note": "Sin historial, y sin nada sobre cuánto trabajo costó. Esa es la única versión que puede no estar de acuerdo contigo." },
          { "text": "Dile que sea más duro esta vez.", "correct": false, "note": "Produce una redacción más dura sobre el mismo punto leve. La postura no ha cambiado." },
          { "text": "Pregunta una segunda vez y compara.", "correct": false, "note": "Dos respuestas desde dentro del mismo hilo, de acuerdo entre ellas." }
        ]
      },
      {
        "situation": "Un hilo abierto ha pasado cuarenta minutos con un mensaje personal. Ahora tienes una pregunta de trabajo.",
        "prompt": "¿Cuál es el riesgo de preguntarlo aquí?",
        "options": [
          { "text": "Va a mezclar los dos temas.", "correct": false, "note": "Los mantiene separados perfectamente bien. Ese no es el fallo." },
          { "text": "Se habrá olvidado del principio.", "correct": false, "note": "Un efecto distinto en hilos mucho más largos, y más o menos lo contrario de este." },
          { "text": "Nada en especial, es una pregunta.", "correct": false, "note": "Una pregunta es suficiente. El moldeado no requiere un intercambio largo." },
          { "text": "La respuesta llega moldeada por los últimos cuarenta minutos.", "correct": true, "note": "Mismo tono, mismas suposiciones sobre cómo eres y qué te preocupa — funcionando como se pretende, con material que ya no es relevante." }
        ]
      }
    ]
  }$j$::jsonb
);
