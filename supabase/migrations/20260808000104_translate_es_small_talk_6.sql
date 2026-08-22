-- Spanish: Small talk, track 5 — Reciprocidad: hablar de ti.
--
-- One word list needed rewriting rather than translating, and for a reason
-- specific to Spanish. Lesson 4 forbids biography so the reader is pushed into
-- an opinion instead, and the English list bans "i work at", "years now", "my
-- team". The obvious Spanish equivalent of "years now" is "llevo" — and
-- "llevo" is also how a Spanish speaker opens a genuine disclosure: "llevo
-- años queriendo hacerlo y sigo sin empezar" is exactly the confession the
-- lesson is asking for. Banning it would fail the reader for doing the thing
-- right. The list is therefore built from phrases that can only be biography:
-- trabajo en, me dedico a, mi equipo, años en la empresa.
--
-- Lesson 5 is scene mode with no rehearsal spec in English, so none here.

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
    title = excluded.title, theory_md = excluded.theory_md,
    examples_json = excluded.examples_json, checks_json = excluded.checks_json,
    rubric_json = excluded.rubric_json, scenario_json = excluded.scenario_json,
    mission_text = excluded.mission_text, rehearsal_spec = excluded.rehearsal_spec,
    updated_at = now();
$fn$;

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('reciprocity', 1,
  'Solo preguntar es su propio fracaso',
  $md$Existe un tipo de conversador que hace preguntas excelentes, escucha con atención, no interrumpe nunca, y deja a la otra persona con una ligera sensación de incomodidad.

La razón es que las preguntas sin nada a cambio son asimétricas. Una persona ha entregado su historia, sus opiniones y sus planes del fin de semana. La otra no ha entregado nada. Por muy cálidas que fueran las preguntas, quien contesta se marcha habiendo sido leído sin leer, y la sensación se parece más a una entrevista que a un encuentro.

**La jugada:** lleva la cuenta de cuánto has dado, no solo de cuánto has preguntado.

Si no puedes nombrar una cosa no trivial que la otra persona sepa ahora de ti, no has tenido una conversación. Has dirigido una.

Este es el fallo más común en quien se ha trabajado a propósito la conversación ligera, porque las preguntas son la parte que enseña todo el mundo.$md$,
  $j$[
    {
      "situation": "Has hecho varias preguntas buenas y te das cuenta de que no has dicho nada de ti.",
      "line": "Te pregunto porque estoy pensando en hacer lo mismo, por cierto.",
      "why": "Explica el interés y revela un plan tuyo. Convierte retroactivamente una ráfaga de preguntas en una conversación."
    },
    {
      "situation": "Acaban de contestar algo largo y hay un hueco natural.",
      "line": "No está lejos de cómo lo viví yo, la verdad.",
      "why": "Señala que no eres neutral. Hasta una pequeña afirmación de parecido cambia la forma de interrogatorio a intercambio."
    },
    {
      "situation": "Notas que han empezado a dar respuestas más cortas.",
      "line": "Llevo un rato disparándote preguntas. Pregúntame algo, que es lo justo.",
      "why": "Nombra el desequilibrio con ligereza y les da el suelo. A casi todo el mundo la honestidad le desarma en vez de incomodarle."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "A los veinte minutos te das cuenta de que sabes mucho de esa persona y ella no sabe casi nada de ti. ¿Qué es lo más probable que sienta desde su lado?",
      "options": [
        { "text": "Halago, porque estabas claramente interesado.", "correct": false, "note": "Puede sentirse así unos minutos. Pasados veinte suele volcarse hacia sentirse examinado en vez de admirado." },
        { "text": "Algo expuesta, y sin saber cómo eres tú.", "correct": true, "note": "El resultado habitual. Han sido generosos y no han recibido nada, así que la calidez tiene un aire de sentido único que quizá no sepan nombrar." },
        { "text": "Neutral, porque a casi todo el mundo le gusta hablar de sí mismo.", "correct": false, "note": "A la gente le gusta hablar de sí misma, pero no indefinidamente y no contra un vacío. Esa preferencia tiene límites." },
        { "text": "Impresionada por lo bien que escuchas.", "correct": false, "note": "Posible, pero escuchar bien sin dar nada se lee como estar en guardia, y en guardia no era la impresión que buscabas." }
      ],
      "explain": "Preguntar en un solo sentido durante mucho rato se lee como evasión, por cálido que sea. El equilibrio es parte de la habilidad, no un adorno."
    },
    {
      "prompt": "Has preguntado mucho y no has dado nada, y te das cuenta. ¿Cuál es la reparación menos incómoda?",
      "options": [
        { "text": "Disculparte por haberles interrogado.", "correct": false, "note": "Lo nombra como falta y les pide que digan que no pasa nada. Más incómodo que el desequilibrio." },
        { "text": "Dejar de hacer preguntas del todo.", "correct": false, "note": "Arregla la cuenta y les deja sosteniendo una conversación en la que te has quedado callado." },
        { "text": "Pedirles que te pregunten algo.", "correct": false, "note": "Les da una tarea. La reciprocidad que has solicitado no es reciprocidad." },
        { "text": "Contestar tú la pregunta que acabas de hacerles.", "correct": true, "note": "Limpio y casi invisible. Has enseñado tu propia respuesta, lo que equilibra la cosa sin que nadie tenga que nombrarlo." }
      ],
      "explain": "La reparación más limpia es contestar tu propia pregunta. Da algo sin anunciar que te has dado cuenta de que no habías dado nada."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "gave_something", "label": "Metiste algo", "description": "Contaste algo no trivial en vez de solo preguntar." },
      { "key": "tracked_balance", "label": "Notaste la asimetría", "description": "Fuiste consciente de lo desequilibrado que se había puesto el intercambio." },
      { "key": "not_a_hijack", "label": "Diste sin acaparar", "description": "Contaste algo sin convertir la conversación en tu monólogo." },
      { "key": "timed_it", "label": "Lo metiste en un punto natural", "description": "Lo pusiste en un hueco en vez de interrumpir su respuesta." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Una cola larga para el ropero al final de un evento. Quince minutos de estar parado con alguien a quien conociste dentro.",
    "partner": {
      "name": "Ade",
      "role": "alguien a quien te presentaron brevemente durante la noche",
      "personality": "Generoso y dispuesto, contesta todo con amplitud, y poco a poco se pone en guardia si no vuelve nada en la otra dirección.",
      "mood": "Relajado y hablador, con ganas de irse a casa.",
      "openness": 4
    },
    "opening_beat": "Ade contesta con extensión tu pregunta sobre el evento y luego espera, dejando un hueco bastante evidente para ti.",
    "success_looks_like": "La persona nota el hueco y mete algo real suyo, tras lo cual Ade se pone más cálido y la conversación se equilibra.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Contesta con generosidad los dos primeros intercambios, y después deja una pausa evidente tras cada respuesta.",
      "Si hacen una tercera pregunta sin contar nada, da una respuesta notablemente más corta y deja caer la energía.",
      "Cuando cuenten algo suyo, caliéntate de inmediato y hazles una pregunta de vuelta."
    ]
  }$j$::jsonb,
  $md$En una conversación de hoy, asegúrate de que la otra persona se va sabiendo una cosa real de ti. Anota qué le contaste y cuándo elegiste decirlo.$md$,
  $j${
  "turns": [
    { "instruction": "Pregúntales algo que invite a más que un sí." },
    { "instruction": "Haz una más, y date cuenta de que sigues sin darles nada." },
    { "instruction": "Antes de hacer una tercera, dales algo real sobre ti." }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('reciprocity', 2,
  'Iguala la profundidad que te ofrecen',
  $md$Lo que se cuenta tiene una profundidad, y la regla es igualar el nivel que te han dado antes de pasarte de él.

Si alguien menciona que ha tenido un fin de semana ajetreado, contestar con el estado de tu matrimonio no es generosidad, es un choque. Si alguien te cuenta algo genuinamente difícil y respondes con un comentario sobre el tiempo, has rechazado una oferta sin querer.

**La jugada:** fíjate en la profundidad de lo que te han puesto delante, y pon algo al lado, más o menos al mismo nivel.

La profundidad se lee más fácil de lo que parece. Los datos sobre su semana son superficiales. Las opiniones son un paso más adentro. Lo que hicieron mal, lo que les preocupa o lo que aún no han decidido está más adentro todavía. Buscas aterrizar en el mismo estante, no ganar.

Pasarse hacia arriba es el error más común, y es el que hace que la gente dé un pequeño paso atrás.$md$,
  $j$[
    {
      "situation": "Mencionan que el trayecto al trabajo ha sido penoso esta semana.",
      "line": "El mío también. He empezado a salir veinte minutos antes solo para sentarme, que ya me parece una derrota.",
      "why": "Mismo estante. Una queja pequeña respondida con una queja pequeña, más un detalle concreto para que no sea solo darles la razón."
    },
    {
      "situation": "Dicen que en febrero estuvieron a punto de dejar el trabajo y no lo hicieron.",
      "line": "Yo sí dejé el mío, hace un par de años, y pasé seis meses preguntándome si me había equivocado.",
      "why": "Han ofrecido algo con duda real dentro, así que esto lo iguala con duda real en vez de con una anécdota."
    },
    {
      "situation": "Mencionan de pasada que están teniendo un año difícil.",
      "line": "Eso es mucho que llevar encima mientras haces charla ligera en una fiesta.",
      "why": "Igualar la profundidad no siempre significa igualarla con una historia tuya. Reconocer el peso es a veces la respuesta del tamaño correcto."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Alguien dice: sinceramente, este año se me ha hecho bastante solitario desde la mudanza. ¿Qué respuesta iguala la profundidad?",
      "options": [
        { "text": "Mudarse es estresante. ¿Al final encontrasteis un buen sitio?", "correct": false, "note": "Coge una confidencia genuina y contesta a la logística. Han ofrecido algo real y han recibido una pregunta práctica." },
        { "text": "Yo me sentí exactamente igual como un año después de mudarme. Tardó mucho más de lo que esperaba.", "correct": true, "note": "Mismo estante, y lo bastante concreto como para ser una confidencia de verdad y no un ruido educado. Ahora saben que no son raros." },
        { "text": "Eso tiene que ser durísimo.", "correct": false, "note": "Comprensivo pero con las manos vacías. Reconoce sin ofrecer, lo que les deja solos en la confidencia que acaban de hacer." },
        { "text": "Mi familia entera se mudó cuando yo tenía nueve años y nunca me he sentido del todo asentado en ningún sitio.", "correct": false, "note": "Se pasa. Su confesión iba de este año; esto contesta con una tesis vital y mueve calladamente el tema hacia ti." }
      ],
      "explain": "Aterriza en el mismo estante. Contestar profundidad con logística rechaza la oferta, y contestarla con más profundidad se apropia de la conversación."
    },
    {
      "prompt": "Alguien te cuenta que su perro murió el mes pasado. ¿Qué aspecto tiene igualar la profundidad?",
      "options": [
        { "text": "Reconocer el peso y dejárselo a ellos.", "correct": true, "note": "Igualar la profundidad no siempre significa igualarla con una historia. A veces la respuesta del tamaño correcto es reconocer lo que acaban de ponerte delante." },
        { "text": "Contarles una mascota que perdiste tú.", "correct": false, "note": "El instinto, y mueve el tema hacia ti justo en el momento en el que menos lo quieren." },
        { "text": "Preguntar de qué raza era.", "correct": false, "note": "Una pregunta de dato contestando a una confidencia. Rechaza la oferta con educación." },
        { "text": "Decir que lo sientes y cambiar de tema.", "correct": false, "note": "Compasión más salida. Se lee como no querer oírlo." }
      ],
      "explain": "Encontrarse con la profundidad a veces significa igualarla con la tuya, y a veces significa solo no apartarte de la suya."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "read_the_depth", "label": "Leíste el nivel ofrecido", "description": "Juzgaste cuánto había puesto de verdad la otra persona sobre la mesa." },
      { "key": "matched_it", "label": "Aterrizaste en el mismo estante", "description": "Ofreciste algo de peso comparable en vez de mucho más ligero o mucho más pesado." },
      { "key": "was_specific", "label": "Fuiste concreto", "description": "Diste un detalle real en vez de un acuerdo genérico." },
      { "key": "did_not_take_over", "label": "No te apropiaste del tema", "description": "Igualaste la confidencia y devolviste la conversación." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Los últimos veinte minutos de un viaje largo en autobús. Lleváis hablando a ratos desde el área de servicio.",
    "partner": {
      "name": "Frances",
      "role": "la persona del asiento de al lado",
      "personality": "Se va abriendo por etapas y prueba cada etapa. Ofrece algo un poco más personal cada vez que se lo corresponden bien, y retrocede un nivel si no.",
      "mood": "Cansada, sin prisa, con ganas de hablar.",
      "openness": 4
    },
    "opening_beat": "Frances menciona que vuelve de ver a la familia, y que estas visitas siempre son un poco más complicadas de lo que espera.",
    "success_looks_like": "La persona responde a cada confidencia a su propio nivel, y Frances va bajando de forma sostenida a lo largo de la conversación.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Empieza con confidencias suaves. Baja un nivel cada vez que te correspondan bien.",
      "Si contestan con logística o con compasión vacía, retrocede a un nivel más superficial y quédate ahí un turno.",
      "Si se pasan con algo mucho más pesado de lo que ofreciste, ponte formal un momento y cambia de tema."
    ]
  }$j$::jsonb,
  $md$Hoy, fíjate en la profundidad de una cosa que te cuenten, y contesta al mismo nivel. Anota qué te ofrecieron y qué pusiste al lado.$md$,
  $j${
  "turns": [
    { "instruction": "Pregunta algo que invite a más que un dato." },
    { "instruction": "Lee cuánta profundidad tenía lo que te han puesto delante, y pon algo tuyo al mismo nivel." }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('reciprocity', 3,
  'Y luego da un paso más',
  $md$Igualar mantiene una conversación nivelada. Dar un paso más allá de lo que te han dado es lo que la hace bajar.

Después de responder a su confidencia, añade un poco más de lo que te dieron. No un salto: un paso. Mencionan un trabajo que no disfrutaban; tú mencionas un trabajo que no disfrutabas y por qué te quedaste demasiado tiempo de todas formas. Esa cláusula de más es la técnica entera.

**La jugada:** ponte a su altura, y luego añade una cosa que no tenías que decir.

Así es como las conversaciones ganan intimidad sin que ninguno lo decida. Cada ronda alguien da un paso de más, y la otra persona queda libre para hacer lo mismo. Nadie tiene que ser valiente, porque nadie está nunca a más de un paso de distancia.

El riesgo es dar dos pasos en vez de uno, lo que convierte una conversación en una confesión y pone a la otra persona en la posición de tener que responder con amabilidad en lugar de con sinceridad.$md$,
  $j$[
    {
      "situation": "Han mencionado que les cuesta leer a su equipo nuevo.",
      "line": "Igual cuando empecé. Me pasé unos tres meses dando por hecho que le caía mal a todo el mundo, y resultó ser completamente inventado.",
      "why": "Iguala la confidencia y añade una admisión que no hacía falta. La cláusula de más es el paso."
    },
    {
      "situation": "Han dicho que casi no salen esta noche.",
      "line": "Yo tampoco iba a venir. Se me da bastante bien convencerme de no hacer cosas y estoy intentando dejarlo.",
      "why": "Responde a la pequeña confesión y añade una un poco mayor sobre un patrón, no sobre una noche."
    },
    {
      "situation": "Mencionan que no mantienen el contacto con nadie del colegio.",
      "line": "Yo tampoco. Antes pensaba que eso significaba que algo iba mal conmigo, y ahora creo que es simplemente lo que pasa.",
      "why": "Añade la interpretación en vez de más datos. Decir qué pensabas que significaba sobre ti suele ser el paso."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Dicen: me tomé un año sabático entre trabajos, que suena mejor de lo que fue. ¿Cuál es la respuesta más fuerte?",
      "options": [
        { "text": "Yo hice lo mismo. La mejor decisión de mi vida, de verdad.", "correct": false, "note": "Iguala el dato y contradice la emoción. Han dicho que fue peor de lo que suena y les has llevado alegremente la contraria." },
        { "text": "¿Qué hizo que no fuera tan bueno como suena?", "correct": false, "note": "Una pregunta decente, y te deja con las manos vacías. Ellos se han abierto; una pregunta de vuelta les deja igual de expuestos." },
        { "text": "Yo estuve seis meses entre trabajos y le dije a todo el mundo que era a propósito. No lo era.", "correct": true, "note": "Iguala la confidencia y añade la admisión que hay debajo. La segunda frase es el paso de más." },
        { "text": "El tiempo libre está infravalorado. La gente no se coge suficiente.", "correct": false, "note": "Una opinión general en vez de una confidencia personal. Suena conforme sin dar nada de ti." }
      ],
      "explain": "Responde a lo que te han dado, y luego añade una cláusula que no tenías que decir. Esa cláusula de más es lo que deja que la conversación baje."
    },
    {
      "prompt": "¿Qué añadido convierte una igualada en un paso más?",
      "options": [
        { "text": "Un segundo ejemplo de lo mismo.", "correct": false, "note": "Más volumen a la misma profundidad. La conversación se queda exactamente al mismo nivel." },
        { "text": "Qué pensabas entonces que decía eso de ti.", "correct": true, "note": "La interpretación es el paso. Los datos se quedan al mismo nivel; lo que concluiste sobre ti baja un piso." },
        { "text": "Una versión más precisa del mismo dato.", "correct": false, "note": "El detalle no es profundidad. Ser concreto sobre algo seguro lo mantiene seguro." },
        { "text": "Una pregunta sobre su experiencia.", "correct": false, "note": "Se lo devuelve a ellos sin que tú hayas ido a ninguna parte." }
      ],
      "explain": "El paso de más es casi siempre la interpretación: no lo que pasó, sino lo que entendiste que decía sobre ti."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "met_then_added", "label": "Igualaste, y luego fuiste más allá", "description": "Respondiste a la confidencia y añadiste algo de más en vez de solo igualar." },
      { "key": "one_step_only", "label": "Un paso, no tres", "description": "Subiste un solo escalón en lugar de convertirlo en una confesión." },
      { "key": "said_the_unflattering", "label": "Diste algo real", "description": "La parte de más costaba algo, en vez de ser un detalle halagador." },
      { "key": "handed_it_back", "label": "Dejaste sitio para ellos", "description": "Terminaste de forma que la otra persona pudiera dar el siguiente paso." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Una cocina al final de una cena. Los demás se han pasado a la otra habitación y los dos estáis apilando platos.",
    "partner": {
      "name": "Joel",
      "role": "un amigo de los anfitriones al que has visto dos veces",
      "personality": "Corresponde con precisión. Llega exactamente hasta donde llegue la otra persona y ni un paso más, así que la conversación solo baja si la otra persona baja primero.",
      "mood": "Cómodo, algo reflexivo, sin prisa.",
      "openness": 4
    },
    "opening_beat": "Joel dice que lleva pensando en irse de la ciudad, y que lleva pensándolo unos tres años ya.",
    "success_looks_like": "La persona iguala la confidencia de Joel y añade un paso más allá, y Joel hace lo mismo de vuelta, de modo que la conversación baja por grados.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Refleja su profundidad exactamente. Si dan un paso más, haz lo mismo en tu turno siguiente.",
      "Si solo hacen preguntas, quédate al mismo nivel superficial indefinidamente y no ofrezcas más.",
      "Si saltan varios pasos de golpe, ponte algo formal y retrocede un nivel."
    ]
  }$j$::jsonb,
  $md$Hoy, iguala una confidencia y luego añade una cláusula que no tenías que decir. Anota qué te dieron, qué igualaste y qué añadiste.$md$,
  $j${
  "turns": [
    { "instruction": "Responde a lo que acaban de ofrecerte, al mismo nivel." },
    { "instruction": "Ahora añade una cláusula que no tenías que decir, y devuélvesela." }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('reciprocity', 4,
  'Qué cuenta como algo no trivial',
  $md$A la gente a la que se le pide contar algo de sí misma produce datos con toda fiabilidad, y los datos no son contar nada.

*Tengo dos hermanos. Estudié historia. Vivo en la zona norte.* Todo cierto, todo irrelevante. Cualquiera podría sacarlo de un formulario. Nada de eso dice cómo es esa persona, que es para lo que sirve contar algo.

**La jugada:** di algo con lo que se pueda discrepar, o que preferirías un poco que no supieran.

Tres categorías fiables. Opiniones que de verdad tienes, incluidas las levemente impopulares. Cosas que te resultaron más difíciles de lo que esperabas. Cosas que quieres y no tienes. Cualquiera de las tres dice más de ti que una hora de biografía.

La prueba es sencilla: si la frase podría aparecer en un pasaporte o en un currículum, no es contar nada. Si decirla te deja muy levemente expuesto, sí lo es.$md$,
  $j$[
    {
      "situation": "La conversación está en dónde os criasteis los dos.",
      "line": "A mí me gustaba, que tengo entendido que es la respuesta equivocada. Casi todo el mundo que conozco parece haber escapado de algún sitio.",
      "why": "Un dato sería el nombre del pueblo. Esto es una opinión levemente a contracorriente, así que invita a una respuesta de verdad en vez de a un asentimiento."
    },
    {
      "situation": "Te preguntan a qué te dedicas y acabas de contestar.",
      "line": "Se me da razonablemente bien y no tengo nada claro que quiera seguir haciéndolo dentro de cinco años.",
      "why": "Añade duda al puesto. La incertidumbre sobre el futuro es lo no trivial más disponible que casi todo el mundo lleva encima."
    },
    {
      "situation": "Mencionan que están aprendiendo algo nuevo.",
      "line": "Llevo años queriendo hacer eso y sigo sin empezar. Creo que espero a ser menos malo antes de empezar, cosa que no funciona.",
      "why": "Un deseo sobre el que no has actuado, más el motivo. Dos categorías a la vez, y resulta cálido en vez de pesado."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál de estas es contar algo de verdad y no biografía?",
      "options": [
        { "text": "Llevo aquí unos seis años.", "correct": false, "note": "Un dato sin ninguna opinión encima. Podría estar impreso en un formulario." },
        { "text": "Trabajo en logística, sobre todo en la parte de software.", "correct": false, "note": "Un dato más preciso. La precisión no es lo mismo que revelar nada sobre cómo eres." },
        { "text": "Me mudé aquí por un trabajo que acabé odiando, y me quedé porque la ciudad me gustó más de lo que esperaba.", "correct": true, "note": "Contiene un error, una emoción y un cambio de opinión. Las tres cosas preferirías un poco no ofrecerlas, y eso es lo que las convierte en contar algo." },
        { "text": "Estudié ingeniería pero nunca la he usado de verdad.", "correct": false, "note": "La más cercana de las incorrectas, porque nunca la he usado insinúa algo. Pero se para justo antes de decir cómo te sientes al respecto." }
      ],
      "explain": "Si podría ir en un currículum, es biografía. Si decirlo te cuesta algo pequeño, es contar algo."
    },
    {
      "prompt": "¿Cuál de estas se acerca más a contar algo de verdad?",
      "options": [
        { "text": "Soy bastante ansioso.", "correct": false, "note": "Suena revelador y es una etiqueta, puesta por ti, sin nada detrás. Las etiquetas salen más baratas que los ejemplos." },
        { "text": "Tengo tres hermanas.", "correct": false, "note": "Biografía. Podría estar impreso en un formulario." },
        { "text": "El año pasado rechacé un trabajo y todavía pienso en ello.", "correct": true, "note": "Una decisión, una duda, y la admisión de que sigue sin resolverse. Las tres cosas cuestan algo de decir." },
        { "text": "Mi trabajo me gusta casi todos los días.", "correct": false, "note": "Una opinión, y la más segura posible. Nadie podría discrepar ni encontrarla interesante." }
      ],
      "explain": "Una descripción de uno mismo no es contar algo. Una cosa concreta que hiciste y sobre la que sigues teniendo sentimientos sí lo es."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "not_biography", "label": "Pasaste de la biografía", "description": "Ofreciste una opinión, una dificultad o un deseo en vez de un dato sobre ti." },
      { "key": "slightly_exposing", "label": "Costó algo pequeño", "description": "Lo que contaste llevaba algo de riesgo en vez de ser completamente seguro." },
      { "key": "kept_it_light", "label": "Siguió siendo fácil de recibir", "description": "Revelaste algo real sin ponerlo pesado de contestar." },
      { "key": "invited_response", "label": "Les dejaste adónde ir", "description": "Lo que contaste les dio algo con lo que estar de acuerdo, discrepar o igualar." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Una jornada de convivencia del trabajo, la hora incómoda antes de la cena. Te han puesto en la misma mesa que alguien de otra oficina.",
    "partner": {
      "name": "Rhian",
      "role": "una compañera de otra oficina a la que no conoces",
      "personality": "Intercambia biografía con soltura y se pasaría la noche entera cambiando datos tan contenta. Se convierte en una conversadora completamente distinta y mucho mejor en cuanto alguien dice algo con un punto de vista dentro.",
      "mood": "Profesionalmente agradable, privadamente aburrida.",
      "openness": 3
    },
    "opening_beat": "Rhian te dice de qué oficina es, cuánto lleva allí y de qué se encarga su equipo. Las tres cosas son datos.",
    "success_looks_like": "La persona rompe el intercambio de biografías con una opinión o una admisión, y Rhian suelta el registro profesional y se convierte en una persona real.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Intercambia datos todo el tiempo que lo hagan, igualando su registro exactamente.",
      "Cuando ofrezcan una opinión, una dificultad o algo que quieren, responde igual y ponte notablemente más relajada y concreta.",
      "No seas nunca la primera en pasar de la biografía."
    ]
  }$j$::jsonb,
  $md$Hoy, cuéntale a alguien una cosa de ti que no podría ir en un currículum. Una opinión, algo que te resultó difícil, o algo que quieres. Anota qué dijiste.$md$,
  $j${
  "says": "Soy de la oficina de Zaragoza, seis años ya. Nos encargamos de la acogida de clientes.",
  "model": {
    "line": "Se me da razonablemente bien el mío y no tengo nada claro que quiera seguir con él dentro de cinco años.",
    "why": "Una opinión y una duda en vez de un dato. Se puede discrepar de ella, que es lo que hace que merezca la pena decirla."
  },
  "checks": [
    { "kind": "first_person", "requirement": "Que vaya de ti" },
    { "kind": "forbids_any", "requirement": "Más biografía no — una opinión, una dificultad o un deseo", "words": ["trabajo en", "trabajo para", "me dedico a", "mi equipo", "mi puesto", "años en la empresa"] },
    { "kind": "min_words", "requirement": "Di lo suficiente como para que se pueda discrepar", "n": 8 }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('reciprocity', 5,
  'Cuando te has pasado',
  $md$De vez en cuando te pasarás. Algo que cuentas cae más pesado de lo que pretendías, el registro baja, y hay un pequeño silencio con una textura distinta a los otros.

El instinto es disculparse o explicarse, y los dos lo empeoran. Disculparse le pide a la otra persona que te tranquilice, lo que convierte tu exceso en tarea suya. Explicarse alarga justo aquello de lo que ya desearías haber dicho menos.

**La jugada:** nómbralo con ligereza, ponle un suelo, y devuélveles la conversación.

*En fin, eso ha sido más de lo que preguntabas.* Dicho con algo de humor y sin vergüenza, eso repara el momento casi por completo, porque demuestra que te has dado cuenta. Lo que a la gente le resulta incómodo no es el exceso en sí. Es la sensación de que la otra persona no se ha enterado.

Y a veces no ha sido un exceso en absoluto. A veces cayó bien y simplemente te has asustado tú, cosa que merece la pena aprender a distinguir.$md$,
  $j$[
    {
      "situation": "Acabas de decir bastante más sobre una época difícil de lo que el momento pedía.",
      "line": "En fin. Eso ha sido mucho para un martes. ¿Qué me decías del viaje?",
      "why": "Lo nombra, no se disculpa, y les devuelve el hilo en el que estaban. La reparación entera dura cuatro segundos."
    },
    {
      "situation": "Notas que se quedan callados después de algo que has dicho.",
      "line": "Lo he hecho sonar más sombrío de lo que es, la verdad.",
      "why": "Le pone un suelo sin retirarlo. Eso les da permiso para dejar de tener cuidado contigo."
    },
    {
      "situation": "Dijiste algo bastante personal y respondieron con calidez.",
      "line": "(nada — sigue como si nada)",
      "why": "Cayó bien. Disculparse retroactivamente por algo que se recibió bien es la forma de volverlo incómodo después."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Acabas de pasarte un poco y hay una pausa rara. ¿Cuál es la mejor reparación?",
      "options": [
        { "text": "Perdona, ha sido demasiado, no sé por qué he dicho eso.", "correct": false, "note": "Ahora tienen que tranquilizarte. Tu incomodidad se ha convertido en responsabilidad suya, que es una imposición mayor que el exceso." },
        { "text": "Nombrarlo con ligereza y devolverles la conversación.", "correct": true, "note": "Demuestra que te has dado cuenta, se niega a convertirlo en crisis, y devuelve el suelo. Esto repara casi cualquier exceso." },
        { "text": "Explicar el contexto para que tenga más sentido.", "correct": false, "note": "Más detalle sobre aquello de lo que ya has dicho de más. La pausa se alarga, no se acorta." },
        { "text": "No decir nada y esperar que pase.", "correct": false, "note": "A veces vale, pero si la pausa era real, el silencio la deja cuajar. Lo incómodo viene de parecer no haberte enterado." }
      ],
      "explain": "La gente perdona un exceso con facilidad. Lo que le resulta incómodo es la sensación de que no te diste cuenta de que estaba pasando."
    },
    {
      "prompt": "¿Cómo distingues un exceso real de haberte asustado tú solo?",
      "options": [
        { "text": "Por lo expuesto que te sientas después.", "correct": false, "note": "La señal menos fiable que existe. Tu incomodidad no dice nada de la suya." },
        { "text": "Por lo personal que fuera el tema.", "correct": false, "note": "Las cosas muy personales caen bien constantemente. Lo que importa es la proporción con el momento, no el asunto." },
        { "text": "Por si contestaron con extensión.", "correct": false, "note": "Ambiguo. Una respuesta larga y cuidadosa puede ser exactamente lo que produce un exceso." },
        { "text": "Por si les cambió el registro.", "correct": true, "note": "Míralos a ellos y no a ti. Si siguieron con la misma calidez, no ha pasado nada." }
      ],
      "explain": "Lee a la otra persona, no tu propio pulso. Casi todo el exceso se lo imagina quien lo comete."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "noticed_the_shift", "label": "Notaste el cambio de registro", "description": "Registraste que lo que contaste había caído más pesado de lo que pretendías." },
      { "key": "did_not_apologise", "label": "Reparaste sin disculparte", "description": "Lo nombraste con ligereza en vez de pedirle a la otra persona que te tranquilizara." },
      { "key": "handed_back", "label": "Devolviste el suelo", "description": "Le devolviste la conversación a la otra persona en vez de seguir explicando." },
      { "key": "did_not_overcorrect", "label": "No te pasaste corrigiendo", "description": "Cuando lo que contaste había caído bien, seguiste adelante en vez de disculparte a posteriori." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Un rincón tranquilo en la despedida de un compañero. Llevas un rato hablando con alguien que te cae bien pero a quien no conoces mucho.",
    "partner": {
      "name": "Kit",
      "role": "alguien de tu equipo ampliado",
      "personality": "Amable y algo torpe. Se queda callado cuando una conversación se pone más pesada de lo esperado, y se recupera al instante si la otra persona lo lleva con ligereza.",
      "mood": "Sociable pero algo agotado por la semana.",
      "openness": 3
    },
    "opening_beat": "Kit pregunta, con toda naturalidad, qué tal te ha ido el año.",
    "success_looks_like": "La persona dice más de lo que la pregunta invitaba, nota el cambio, y lo repara con ligereza sin disculparse, tras lo cual la conversación se recupera.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Si cuentan algo pesado, quédate callado un momento y responde con cuidado en vez de con calidez.",
      "Si después lo reparan con ligereza y te devuelven la conversación, relájate de inmediato y retoma el hilo.",
      "Si se disculpan largo o siguen explicando, ponte más cuidadoso y formal."
    ]
  }$j$::jsonb,
  $md$Hoy, fíjate en un momento en el que dijeras más de lo que la pregunta invitaba. Repáralo con ligereza en vez de disculparte, o déjalo si cayó bien. Anota cuál de las dos cosas fue.$md$,
  null);
