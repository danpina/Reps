-- Spanish: El trabajo, track 1 — Hablar en reuniones.
--
-- Conventions as the Small talk and Interviews migrations: tú for the reader,
-- **La jugada:** for the move marker, **Si te quedas con una cosa:** for the
-- closer, no gendered adjectives about the reader, names left alone.
--
-- Two things this track forced:
--
-- **The runway cannot be a question in Spanish.** The English model line is
-- "Dana, can I — one thing on the timeline", and the drill enforces
-- max_questions: 0 on it, because asking permission to speak is the habit the
-- lesson exists to break. English gets away with "can I —" as an unpunctuated
-- fragment; Spanish would have to open it with ¿ and the same line would fail
-- its own check. So the Spanish runway is "Dana, una cosa —", which is what a
-- person in that room actually says and is a statement rather than a request.
-- That is the lesson's own point, arrived at by a different route.
--
-- **"Half-formed thought" is "idea a medio hacer".** Short enough to work as
-- a spoken flag, which is the whole function — "pensamiento a medio formar" is
-- accurate and nobody would say it out loud at speed.
--
-- **"Timeline" is "el calendario" throughout**, not "la línea temporal": in a
-- Spanish meeting the thing that slips is the calendar.

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

select pg_temp.es_lesson('speaking-in-meetings', 1,
  'Dilo sin terminar',
  $md$No estás callado en las reuniones porque no tengas nada que decir. Estás callado porque lo que tienes todavía no está listo, y para cuando lo está, el tema ya se ha movido.

Merece la pena quedarse un momento en eso, porque cambia cuál es el problema. Estás aplicando un listón — *no hables hasta tenerlo terminado* — que no aplica nadie más en la sala y del que nadie en ella es siquiera consciente. Escucha lo que dice de verdad la gente segura y casi nunca es una idea terminada. Es *creo que el riesgo está más por el lado del calendario, pero no lo he pensado del todo*: media idea, entregada, y la sala la termina con ellos.

**La jugada:** dilo antes de tenerlo terminado, y di que no está terminado.

La segunda mitad es lo que hace segura a la primera. *Idea a medio hacer:* o *igual me equivoco, pero* no te cuesta nada y te compra el derecho a ser provisional en voz alta. Nadie te tiene en cuenta una media idea marcada como tal, y todo el mundo te tiene en cuenta el silencio en nada en absoluto, lo cual suena a un motivo para seguir callado hasta que te das cuenta de que el silencio tampoco te da nada.

Debajo de todo esto hay un error de contabilidad. El coste de decir algo imperfecto se siente concreto e inmediato; el coste de no decir nada se siente como cero porque ocurre de forma invisible y más tarde. No es cero. Es la decisión tomada sin lo que tú sabías.

Si te quedas con una cosa: sin terminar y a tiempo gana a terminado y después.$md$,
  $j$[
    {
      "situation": "Tienes media objeción y la conversación está a punto de pasar a otra cosa.",
      "line": "Idea a medio hacer: creo que el riesgo está en el calendario y no en el presupuesto.",
      "why": "Marcada como provisional, lo que la hace gratis de equivocarse, y dicha mientras todavía puede afectar a algo. La sala la va a terminar contigo."
    },
    {
      "situation": "Estás esperando a poder expresarlo bien.",
      "line": "(la ventana dura unos treinta segundos)",
      "why": "«Bien» llega después de que el tema se haya movido, y entonces decirlo significa arrastrar a todo el mundo hacia atrás, que cuesta muchísimo más que haber sido provisional."
    },
    {
      "situation": "No dijiste nada y la decisión salió como pensabas que saldría.",
      "line": "(ese es el coste, y no es cero)",
      "why": "Quedarse callado se siente gratis porque el coste es invisible y llega más tarde. Es una decisión tomada sin lo que tú sabías."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué habla antes la gente segura de la sala?",
      "options": [
        { "text": "Están más seguros de sí mismos.", "correct": false, "note": "Escucha lo que dicen de verdad. Con frecuencia va con matices, es provisional y está visiblemente a medio construir." },
        { "text": "No están esperando a tenerlo terminado.", "correct": true, "note": "Entregan media idea y dejan que la sala la complete. Tú estás aplicando un listón que no aplica nadie más en la reunión." },
        { "text": "Se lo han pensado antes.", "correct": false, "note": "A veces, y no es la diferencia. Prepararse ayuda a todo el mundo y no explica hablar a mitad de una discusión." },
        { "text": "Les importa menos equivocarse.", "correct": false, "note": "Más cerca, y describe una personalidad en vez de una jugada. Marcar una idea como a medio hacer te da el mismo permiso." }
      ],
      "explain": "«Sin terminar» es el registro normal de una reunión. Te has estado aplicando un listón de texto escrito en una sala hablada."
    },
    {
      "prompt": "¿Qué te compra en realidad decir «idea a medio hacer»?",
      "options": [
        { "text": "Tiempo para pensar mientras hablas.", "correct": false, "note": "Un beneficio secundario pequeño. El valor está en lo que le hace a cómo lo escucha la sala." },
        { "text": "Hace que suenes humilde.", "correct": false, "note": "La humildad no es el objetivo y puede leerse como disculpa. Esto es un permiso, no una reverencia." },
        { "text": "El derecho a ser provisional en voz alta.", "correct": true, "note": "Nadie te tiene en cuenta una media idea marcada como tal. Convierte equivocarse de un error en una aportación." },
        { "text": "Baja las expectativas antes de que hables.", "correct": false, "note": "Ese encuadre lo convierte en un matiz sobre ti. Es una etiqueta sobre la idea, no sobre ti mismo." }
      ],
      "explain": "Márcala como sin terminar y equivocarse deja de costar nada."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "in_time", "label": "Lo dijo dentro de la ventana", "description": "Habló mientras todavía podía afectar a la discusión." },
      { "key": "unfinished", "label": "No esperó a tenerlo terminado", "description": "Entregó una idea a medio hacer en vez de una pulida." },
      { "key": "flagged", "label": "La marcó como provisional", "description": "La hizo gratis de equivocarse en vez de disculparse por ella." },
      { "key": "short", "label": "Fue breve", "description": "Un punto, no un párrafo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Dana",
      "role": "quien dirige la reunión",
      "mood": "Intentando llegar a una decisión antes de que se acabe la hora.",
      "openness": 4,
      "personality": "Rápida y receptiva de verdad. Coge un argumento a medio hacer y construye sobre él, y sigue adelante enseguida cuando nadie dice nada."
    },
    "setting": "Una reunión de proyecto, siete personas. El equipo está convergiendo en una fecha de lanzamiento y tú crees que el calendario es la parte débil, aunque todavía no has averiguado por qué.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Tómate en serio un argumento a medio hacer y construye sobre él en voz alta.",
      "Si la persona no dice nada, o mete matices sin ningún argumento, haz avanzar la reunión con rapidez.",
      "Nunca invites a la persona a hablar: tiene que coger la ventana ella."
    ],
    "opening_beat": "«Así que, salvo que alguien tenga dudas, creo que decimos el catorce. A la de una.»",
    "success_looks_like": "La persona dice la idea sin terminar mientras la ventana sigue abierta."
  }$j$::jsonb,
  'Hoy, di una idea sin terminar en voz alta en una reunión, marcándola como sin terminar. Apunta qué dijiste y qué hizo la sala con ello.',
  $j${
    "beats": [
      {
        "situation": "«Así que, salvo que alguien tenga dudas, creo que decimos el catorce. A la de una.» Crees que el calendario está mal pero no has averiguado por qué.",
        "prompt": "¿Qué haces?",
        "options": [
          { "text": "Esperar a poder decirlo bien, y sacarlo después.", "correct": false, "note": "«Después» significa arrastrar a todo el mundo hacia atrás, que cuesta muchísimo más esfuerzo social del que habría costado ser provisional. La ventana dura unos treinta segundos." },
          { "text": "Decir la media idea ahora, marcada como media idea.", "correct": true, "note": "Entregada mientras todavía puede cambiar algo, y etiquetada para que equivocarse no cueste nada. La sala la va a terminar contigo." },
          { "text": "No decir nada: puede que te equivoques.", "correct": false, "note": "El coste de eso se siente como cero porque llega de forma invisible y más tarde. Es una decisión tomada sin lo que tú sabías." },
          { "text": "Escribir a alguien después para comprobarlo antes de plantearlo.", "correct": false, "note": "Cuidadoso, y para entonces la fecha está acordada y reabrirla es un acto mucho mayor de lo que habría sido una frase." }
        ]
      },
      {
        "situation": "Has decidido decirlo. Estás a punto de abrir.",
        "prompt": "¿Con cuál abres?",
        "options": [
          { "text": "Perdona, esto igual es una tontería, pero…", "correct": false, "note": "Una disculpa en vez de una marca. Te etiqueta a ti en vez de a la idea, y le pide a la sala que te tranquilice primero." },
          { "text": "No sé si esto está bien, no lo he pensado del todo, igual no es nada, pero…", "correct": false, "note": "El instinto correcto tres veces seguidas. Para el cuarto matiz la sala ha dejado de esperar el argumento." },
          { "text": "Idea a medio hacer: el riesgo igual está en el calendario y no en el presupuesto.", "correct": true, "note": "Una marca, y directo a ello. Esa es toda la técnica: provisional sobre la idea, no sobre ti." },
          { "text": "El calendario está mal.", "correct": false, "note": "Nada de malo en ser tajante, y te compromete con una postura que todavía no has resuelto, que es justo lo que te hizo dudar al principio." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('speaking-in-meetings', 2,
  'Meter baza',
  $md$Saber qué decir y no saber cómo empezar a decirlo son problemas distintos, y el segundo es mecánico.

Casi todo el mundo espera un hueco. En una buena reunión no llegan huecos: la pausa que estás esperando es la pausa de después de la decisión. Lo que pasa de verdad es que la gente entra encima del último medio segundo de la frase de otro, y la sala lo trata como algo completamente normal, porque lo es.

**La jugada:** dos palabras de pista de despegue, y luego el argumento.

*Una cosa* — *Un apunte* — *Rápido*: cualquiera vale. No son relleno. Una pista corta le da a la sala medio segundo para girarse hacia ti, que es exactamente lo que estabas esperando que te diera un hueco, y funciona a un volumen que ya tienes.

Mejor todavía, usa un nombre. *Dana, una cosa —* te da la palabra casi siempre, porque una persona nombrada se para, y cuando una se para las demás la siguen. Es la entrada más fiable que existe y parece muchísimo más maleducada de lo que es.

Por dónde entrar: por una coma, no por un punto. Las frases en las reuniones no terminan, se van deshilachando hacia la siguiente, y quien espera un final limpio está esperando algo que no va a llegar. Una respiración es un punto de entrada.

Una cosa que dejar. *Perdona, una cosa —* es la misma pista con una disculpa pequeña soldada delante, y la disculpa no está haciendo nada salvo decirle a la sala que crees que no deberías estar hablando. Quítale el «perdona» y la frase es idéntica.

Si te quedas con una cosa: di un nombre y empieza. El permiso no te lo iban a ofrecer nunca.$md$,
  $j$[
    {
      "situation": "Dos personas están yendo y viniendo y no hay ningún hueco.",
      "line": "Dana, una cosa — un apunte sobre el calendario.",
      "why": "Un nombre para a una persona, y cuando una se para las demás la siguen. Parece muchísimo más maleducado de lo que es y funciona casi siempre."
    },
    {
      "situation": "Estás esperando a que alguien termine su frase.",
      "line": "(entra por la coma)",
      "why": "Las frases en las reuniones se deshilachan hacia la siguiente en vez de terminar. Esperar un final limpio es esperar algo que no va a llegar."
    },
    {
      "situation": "Estás a punto de abrir con «perdona, una cosa».",
      "line": "(quítale el «perdona»; el resto está bien)",
      "why": "La disculpa no hace nada salvo decirle a la sala que crees que no deberías estar hablando. La frase idéntica sin ella es una entrada normal."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Estás esperando un hueco. ¿Qué tiene de malo ese plan?",
      "options": [
        { "text": "En una buena reunión los huecos llegan después de la decisión.", "correct": true, "note": "La pausa que estás esperando es aquella en la que ya es tarde. La gente entra encima del último medio segundo de la frase de alguien, y a la sala le parece completamente normal." },
        { "text": "Siempre lo va a coger otro.", "correct": false, "note": "A menudo cierto y es el síntoma. El plan falla porque el hueco no llega, no porque esté disputado." },
        { "text": "Hace que parezcas pasivo.", "correct": false, "note": "Cómo parece no es el problema. Lo que te cuesta es el momento en el que hablar todavía servía de algo." },
        { "text": "Nada: esperar es de buena educación.", "correct": false, "note": "Es educado, y una educación que te impide de forma fiable aportar algo es un coste, no una virtud." }
      ],
      "explain": "Entra por la coma. Una respiración es un punto de entrada; un punto y seguido es una fantasía."
    },
    {
      "prompt": "¿Cuál es la forma más fiable de entrar?",
      "options": [
        { "text": "Levantar la mano o una ceja.", "correct": false, "note": "Funciona en algunas salas y depende enteramente de que alguien te esté mirando en el momento justo." },
        { "text": "Hablar más alto que la última persona.", "correct": false, "note": "Eficaz y caro. El volumen es una competición, y es justo la que peor posicionada está la gente callada para ganar." },
        { "text": "Esperar a que quien dirige te invite.", "correct": false, "note": "Alguna gente lo hace y casi ninguna. Un plan que depende de que otra persona se acuerde de ti no es un plan." },
        { "text": "Decir el nombre de alguien.", "correct": true, "note": "Una persona nombrada se para, y cuando una se para las demás la siguen. Parece mucho más maleducado de lo que es y funciona casi siempre." }
      ],
      "explain": "Un nombre, luego dos palabras de pista, y luego el argumento. Sin disculpa por delante."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "entered", "label": "Entró de verdad", "description": "Se puso a hablar en vez de esperar un hueco." },
      { "key": "runway", "label": "Usó una pista o un nombre", "description": "Le dio a la sala medio segundo para girarse." },
      { "key": "no_apology", "label": "No se disculpó por hablar", "description": "Dejó el «perdona» fuera." },
      { "key": "straight_in", "label": "Fue al grano", "description": "Siguió la pista con la cosa de verdad." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Dana",
      "role": "quien dirige la reunión",
      "mood": "Metida de lleno en una discusión sobre recursos.",
      "openness": 4,
      "personality": "Habla rápido y no deja huecos, pero se para de inmediato y cede la palabra cuando se usa su nombre."
    },
    "setting": "Una revisión semanal. Dos compañeros llevan cuatro minutos yendo y viniendo sobre los recursos y ninguno se para.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Sigue hablando sin pausas salvo que la persona interrumpa de verdad.",
      "Párate y cede la palabra con calidez en el momento en que use tu nombre.",
      "Nunca invites a la persona a hablar."
    ],
    "opening_beat": "«—no, pero es el mismo problema, porque si movemos a Priya a eso entonces lo otro se retrasa y volvemos a donde—»",
    "success_looks_like": "La persona entra sin esperar un hueco y sin disculparse."
  }$j$::jsonb,
  'Hoy, entra en una conversación usando el nombre de alguien en vez de esperar un hueco. Apunta qué pasó en el segundo siguiente a decirlo.',
  $j${
    "says": "—no, pero es el mismo problema, porque si movemos a Priya a eso entonces lo otro se retrasa y volvemos a donde—",
    "model": {
      "line": "Dana, una cosa — un apunte sobre el calendario.",
      "why": "Un nombre para a una persona y las demás la siguen, y luego dos palabras de pista le dan a la sala medio segundo para girarse. Sin disculpa delante y con el tema nombrado de inmediato."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["perdona", "perdón", "disculpa", "si pudiera", "os importa", "te importa", "puedo interrumpir"], "requirement": "Sin disculpa por delante" },
      { "kind": "max_words", "n": 15, "requirement": "Una pista, no un preámbulo" },
      { "kind": "max_questions", "n": 0, "requirement": "No pidas permiso para hablar" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('speaking-in-meetings', 3,
  'Apoyar a alguien',
  $md$Lo más barato que vas a decir jamás en una reunión es que estás de acuerdo con alguien, en voz alta, con una frase pegada.

Es imposible hacerlo mal. No se puede objetar. No requiere ninguna idea original ni ningún valor, y te convierte en alguien que habla en esta reunión, que es casi todo lo que necesitas, porque la segunda vez que hablas nunca cuesta tanto como la primera.

**La jugada:** nombra con quién estás de acuerdo, y luego añade una cosa.

Las dos mitades importan. *Estoy de acuerdo* a secas es ruido y lo sabe todo el mundo. *Creo que Priya tiene razón con el calendario, y lo que yo añadiría es que la firma del cliente cae esa misma semana* es una aportación: le da el mérito a alguien, toma una postura, y pone un dato nuevo sobre la mesa.

Además vale muchísimo más de lo que te cuesta para la persona a la que apoyas. Las ideas en las reuniones no ganan por sus méritos, ganan según si una segunda voz las recoge: un argumento sin apoyo se trata normalmente como la opinión de una persona, y el mismo argumento apoyado por otra se convierte en la dirección de la conversación. La gente callada es a menudo la que se dio cuenta de cuál era la buena idea y la dejó morir en silencio.

Eso convierte esto en el acto político más infravalorado que tiene disponible alguien a quien no le gusta la política. Apoya a la gente y la gente te apoyará, y nada de eso exige que seas quien tiene la ocurrencia brillante.

Una advertencia: no lo uses como forma de no tener nunca una postura propia. Estar de acuerdo más un dato es una aportación; estar de acuerdo más nada, repetidamente, es una forma de hablar sin decir nada, y la sala aprende a oírlo como si fuera el tiempo que hace.

Si te quedas con una cosa: di de quién es el argumento, y luego añade un dato. Eso es una aportación entera y no te cuesta ningún riesgo.$md$,
  $j$[
    {
      "situation": "Priya ha hecho un buen apunte sobre el calendario y no lo ha recogido nadie.",
      "line": "Creo que Priya tiene razón con el calendario: la firma del cliente cae esa misma semana.",
      "why": "Le da el mérito a ella, toma una postura, y añade un dato. Un argumento sin apoyo se queda en la opinión de una persona; uno apoyado se convierte en la dirección de la conversación."
    },
    {
      "situation": "Quieres hablar pero no tienes ningún argumento propio.",
      "line": "(no te hace falta ninguno)",
      "why": "Apoyar a alguien no se puede hacer mal ni se puede objetar, y te convierte en alguien que habla en esta reunión. La segunda vez nunca cuesta tanto como la primera."
    },
    {
      "situation": "Llevas tres «estoy de acuerdo» en esta reunión y nada más.",
      "line": "(añade el dato, o es el tiempo que hace)",
      "why": "Estar de acuerdo más un dato es una aportación. Estar de acuerdo más nada, repetidamente, le enseña a la sala a dejar de oírte."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué apoyar a alguien vale más de lo que te cuesta?",
      "options": [
        { "text": "Hace que le caigas bien a la gente.", "correct": false, "note": "Lo hace, y eso es el subproducto y no el mecanismo." },
        { "text": "Una segunda voz es lo que convierte una idea en la dirección.", "correct": true, "note": "Un argumento sin apoyo se queda en la opinión de una persona. El mismo argumento recogido por otra se convierte en lo que la reunión está haciendo ahora." },
        { "text": "Es una forma segura de que te vean hablar.", "correct": false, "note": "Cierto, y se queda corto. Esto no es una forma de aparentar que aportas: cambia el resultado." },
        { "text": "Te construye aliados para más adelante.", "correct": false, "note": "Lo hace, y plantearlo así convierte una aportación real en una maniobra. El valor es inmediato y honesto." }
      ],
      "explain": "Las ideas no ganan por sus méritos. Ganan por que alguien las recoja."
    },
    {
      "prompt": "¿Qué tiene que ir pegado al acuerdo?",
      "options": [
        { "text": "Un motivo por el que estás de acuerdo.", "correct": false, "note": "Mejor que nada y sigue siendo sobre el argumento de esa persona. Una cosa nueva es lo que lo mueve hacia delante." },
        { "text": "Nada: estar de acuerdo es toda la jugada.", "correct": false, "note": "El acuerdo pelado es ruido, y repetido le enseña a la sala a dejar de oírte." },
        { "text": "Una cosa que esa persona no haya dicho.", "correct": true, "note": "Nombra de quién es el argumento, y luego añade un dato. Eso le da el mérito a alguien, toma una postura y pone algo nuevo sobre la mesa, todo en una frase." },
        { "text": "Un matiz, para que no sea puro acuerdo.", "correct": false, "note": "Esa es otra jugada y más cara. No hace falta que discrepes un poco para merecer que te escuchen." }
      ],
      "explain": "Su nombre, su argumento, un dato nuevo. Una aportación entera sin ningún riesgo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named", "label": "Nombró a la persona", "description": "Dio el mérito de quién era el argumento." },
      { "key": "added", "label": "Añadió una cosa", "description": "Puso algo nuevo sobre la mesa en vez de estar de acuerdo a secas." },
      { "key": "short", "label": "Lo dejó en una frase", "description": "No convirtió una jugada barata en un discurso." },
      { "key": "took_a_position", "label": "Tomó una postura", "description": "Estuvo de acuerdo con claridad en vez de matizar el apoyo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Dana",
      "role": "quien dirige la reunión",
      "mood": "Sacando adelante un orden del día.",
      "openness": 4,
      "personality": "Se mueve rápido y sigue lo que recoja la sala. Trata un argumento que nadie apoya como la opinión de una persona, y uno apoyado como la dirección."
    },
    "setting": "Una reunión de planificación. Priya acaba de hacer un buen apunte sobre el calendario y ha pasado de largo: la siguiente persona ya ha empezado con otra cosa.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pasa rápido de cualquier argumento que no apoye nadie.",
      "Gírate y tómatelo en serio cuando la persona apoye a alguien añadiendo algo.",
      "Nunca invites a la persona a hablar."
    ],
    "opening_beat": "«Vale, anotado. Entonces, del segundo punto, íbamos a mirar lo de los informes—»",
    "success_looks_like": "La persona nombra el argumento de Priya y le añade una cosa."
  }$j$::jsonb,
  'Hoy, apoya a una persona en voz alta y añádele una cosa a su argumento. Apunta de quién era el argumento y qué añadiste.',
  $j${
    "says": "Priya: «A mí la parte que me preocupa sí es el calendario, más que el dinero.» Dana: «Vale, anotado. Entonces, del segundo punto, íbamos a mirar lo de los informes—»",
    "model": {
      "line": "Antes de pasar: Priya tiene razón con el calendario, y la firma del cliente cae esa misma semana.",
      "why": "Nombra de quién es el argumento, está de acuerdo con claridad, y añade un dato que no había dicho nadie. Un argumento apoyado se convierte en la dirección; uno sin apoyo se queda en la opinión de alguien."
    },
    "checks": [
      { "kind": "echoes_any", "words": ["priya"], "requirement": "Nombra de quién es el argumento" },
      { "kind": "contains_any", "words": ["razón", "de acuerdo", "coincido", "con priya", "buen apunte", "yo también lo creo"], "requirement": "Toma una postura en vez de insinuarla" },
      { "kind": "min_words", "n": 12, "requirement": "Añade una cosa que esa persona no haya dicho" },
      { "kind": "max_words", "n": 30, "requirement": "Una frase: es una jugada barata, mantenla barata" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('speaking-in-meetings', 4,
  'Cuando te pisan',
  $md$Empiezas, empieza otra persona, y te callas. Y luego vuelve a pasar, y para la tercera vez ya te has reclasificado en silencio como alguien que no llega a terminar frases en esta sala.

Casi nada de ello es hostil. Casi todo pisar es dos personas leyendo mal el mismo medio segundo, y quien se calla es sencillamente la que más miedo tiene al choque. Esa es la parte que merece la pena saber: callarse no es que se castigue la educación, es un reflejo, y se puede cambiar por otro.

**La jugada:** termina la frase que empezaste, al mismo volumen.

Más alto no. Más alto es una competición, y es justo la competición para la que peor equipado estás. El mismo volumen, siguiendo, es notablemente eficaz: la otra persona casi siempre se para, porque *ella* también está intentando no chocar.

Si ya te has callado, recupéralo de forma explícita. *No había terminado* — cuatro palabras, sin filo, sin disculpa — o *déjame terminar esta idea y luego quiero oír la tuya*. Las dos suenan muchísimo más confrontativas en tu cabeza que en la sala, donde aterrizan como algo corriente.

Si sigue pasando con la misma persona, hazlo fuera de la reunión en vez de escalarlo dentro. Una frase, en privado, sin ninguna acusación dentro. Dentro de la reunión le estás pidiendo a una sala que arbitre; fuera, le estás contando a alguien un dato del que muy probablemente no se ha dado cuenta.

Y hay una versión en la que te pisan y luego otra persona hace tu argumento y se le da el mérito a ella. Dilo, con llaneza y sin calor: *eso es lo que estaba diciendo yo hace un minuto, y estoy de acuerdo.* Sin enfurruñarse, sin llevar la cuenta. Dicho con llaneza no tiene respuesta.

Si te quedas con una cosa: sigue al mismo volumen. Quien interrumpe también está intentando no chocar, y uno de los dos tiene que no callarse.$md$,
  $j$[
    {
      "situation": "Llevas tres palabras y alguien se pone a hablar.",
      "line": "(sigue, al mismo volumen)",
      "why": "La otra persona también está intentando no chocar, y casi siempre se para. Más alto es una competición; seguir no lo es."
    },
    {
      "situation": "Ya te has callado, y esa persona sigue.",
      "line": "No había terminado.",
      "why": "Cuatro palabras, sin filo y sin disculpa. Suena muchísimo más confrontativo en tu cabeza que en la sala, donde aterriza como algo corriente."
    },
    {
      "situation": "Alguien acaba de hacer tu argumento y le han dado las gracias.",
      "line": "Eso es lo que estaba diciendo yo hace un minuto, y estoy de acuerdo.",
      "why": "Llano, sin respuesta posible, y sin enfurruñarse. Llevar la cuenta es lo que hace que esto parezca pequeño; decirlo con llaneza no."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Alguien se pone a hablar cuando llevas tres palabras de tu frase. ¿Qué funciona?",
      "options": [
        { "text": "Seguir al mismo volumen.", "correct": true, "note": "También está intentando no chocar, así que casi siempre se para. Uno de los dos tiene que no callarse, y es un reflejo y no una personalidad." },
        { "text": "Subir más el volumen que esa persona.", "correct": false, "note": "Una competición, y la que peor equipada está para ganar alguien callado. Además cambia la temperatura de la reunión." },
        { "text": "Callarte, y volver a ello más tarde.", "correct": false, "note": "«Más tarde» es después de que el tema se haya movido. Hazlo tres veces y la sala habrá aprendido algo sobre ti que no es verdad." },
        { "text": "Dejar que termine y luego repetirte.", "correct": false, "note": "A veces es la única opción, y te cuesta la ventana del argumento y hace más difícil el segundo intento." }
      ],
      "explain": "Mismo volumen, sigue. Callarse es un reflejo, no educación."
    },
    {
      "prompt": "Sigue pasando con una persona en concreto. ¿Y ahora?",
      "options": [
        { "text": "Decir algo en la siguiente reunión, para que lo vea la sala.", "correct": false, "note": "Eso le pide a una sala que arbitre, lo que sube lo que hay en juego para todo el mundo y lo convierte en algo entre vosotros dos." },
        { "text": "Nada: no merece la pena el follón.", "correct": false, "note": "Vale más o menos una frase de follón, y si se deja pasar se acumula." },
        { "text": "Una frase en privado, sin ninguna acusación dentro.", "correct": true, "note": "Casi nadie sabe que hace esto. Fuera de la reunión le estás contando a alguien un hecho; dentro, estás construyendo un caso." },
        { "text": "Plantearlo con tu jefe.", "correct": false, "note": "Un instrumento grande para algo que normalmente se resuelve en una frase en privado." }
      ],
      "explain": "Dentro de la reunión, sigue. Fuera de ella, una frase y ninguna acusación."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "kept_going", "label": "Siguió", "description": "Terminó la frase en vez de ceder." },
      { "key": "same_volume", "label": "Se mantuvo al mismo volumen", "description": "No lo convirtió en una competición." },
      { "key": "reclaimed", "label": "Lo recuperó cuando ya se había callado", "description": "Dijo que no había terminado, sin disculpa y sin filo." },
      { "key": "no_heat", "label": "Mantuvo baja la temperatura", "description": "Sin enfurruñarse, sin llevar la cuenta, sin acusar." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rob",
      "role": "un compañero que pisa a la gente sin darse cuenta",
      "mood": "Con energía, algo pasado de cafeína, nada hostil.",
      "openness": 4,
      "personality": "Entusiasta y con toda la buena intención. Empieza a hablar por encima de la persona dos veces, y se para de inmediato y se disculpa si simplemente sigue o si dice que no había terminado."
    },
    "setting": "Una reunión de seguimiento. Tienes un apunte sobre la fecha de los informes, y un compañero está teniendo una mañana rápida y entusiasta.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Ponte a hablar por encima de la persona al menos dos veces, a media frase y sin mala intención.",
      "Párate de inmediato y con calidez si sigue hablando o si dice que no había terminado.",
      "Recupera la palabra para siempre si cede, y sigue tan contento."
    ],
    "opening_beat": "«Vale, los informes: yo creo que lo movemos una semana y no se va a dar ni cuenta nadie, en serio, no pasa nada—»",
    "success_looks_like": "La persona termina su argumento en vez de ceder, sin subir la temperatura."
  }$j$::jsonb,
  'Hoy, cuando alguien se ponga a hablar mientras hablas tú, sigue al mismo volumen. Apunta qué pasó.',
  '{}'::jsonb
);

select pg_temp.es_lesson('speaking-in-meetings', 5,
  'Te preguntan de golpe y no tienes nada',
  $md$*¿Tú qué opinas?* — y se giran todos, y en tu cabeza no hay absolutamente nada.

Este es el momento que más se teme, y el temor es desproporcionado por un motivo concreto: se siente como una prueba de si perteneces aquí, y es una petición de una frase.

**La jugada:** di la verdad sobre dónde estás, y luego la mitad honesta de lo que tienes.

*Todavía no tengo una opinión sobre el conjunto, pero la parte en la que me sigo enganchando es el calendario.* Eso es una respuesta completa. No es un fallo al responder, no es una escapatoria, y le sirve más a la sala de lo que le serviría una invención dicha con seguridad.

Lo que hace la gente en su lugar es fabricar. Producen algo plausible, y largo, para llenar el silencio, y es peor en todas las direcciones: tarda más, no representa lo que piensan de verdad, y si cuela ahora tienen que defender una postura que se inventaron bajo presión.

Otras dos respuestas completas. *Necesitaría saber X antes de poder decirte* no es una no-respuesta: nombra lo que a la sala se le puede haber pasado que falta. Y *quiero pensarlo, ¿te digo algo esta tarde?* es completamente normal, siempre que luego digas algo, que es lo que lo convierte en una promesa y no en una huida.

Hay una cosa que dejar de hacer, y es el reflejo: *perdona, no estaba siguiendo el hilo.* Normalmente falso, y cambia una pausa de dos segundos por una impresión duradera. La pausa de la que intentas escapar dura un segundo y medio, y se lee como alguien pensando y no como alguien pillado.

Si te quedas con una cosa: di dónde estás de verdad. Cuesta una frase, y es la respuesta.$md$,
  $j$[
    {
      "situation": "«¿Tú qué opinas?» — y no tienes nada formado.",
      "line": "Todavía no tengo una opinión sobre el conjunto, pero la parte en la que me sigo enganchando es el calendario.",
      "why": "Una respuesta completa. Dice dónde estás de verdad y le entrega a la sala la única cosa real que tienes, que gana a una invención dicha con seguridad."
    },
    {
      "situation": "Estás a punto de producir algo plausible para llenar el silencio.",
      "line": "(y luego te toca defenderlo)",
      "why": "Fabricar tarda más, no representa lo que piensas, y te deja sosteniendo una postura que te inventaste bajo presión."
    },
    {
      "situation": "De verdad necesitas pensarlo.",
      "line": "Quiero pensarlo, ¿te digo algo esta tarde?",
      "why": "Completamente normal, y es una promesa en vez de una huida solo si luego dices algo. Poner la hora es lo que la convierte en una."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Te preguntan de golpe y no tienes nada. ¿Qué dices?",
      "options": [
        { "text": "Algo plausible, para llenar el silencio.", "correct": false, "note": "Más largo, menos verdadero, y si cuela ahora tienes que defender una postura que te inventaste bajo presión." },
        { "text": "Dónde estás de verdad, más la única cosa real que tienes.", "correct": true, "note": "Todavía no hay opinión sobre el conjunto, y esta es la parte en la que me sigo enganchando. Eso es una respuesta completa y sirve más que una invención." },
        { "text": "Perdona, no estaba siguiendo el hilo.", "correct": false, "note": "Normalmente falso, y cambia un segundo y medio de silencio por una impresión duradera." },
        { "text": "Pasarle la palabra a otra persona de la sala.", "correct": false, "note": "Se lee como no tener nada, que es justo lo que intentabas evitar, y regala un turno que te habían dado." }
      ],
      "explain": "La mitad honesta de lo que tienes es una respuesta. La pausa de antes dura menos de lo que parece."
    },
    {
      "prompt": "¿Por qué «necesitaría saber X» es una respuesta de verdad?",
      "options": [
        { "text": "Te compra tiempo.", "correct": false, "note": "Te lo compra, y no es por eso por lo que funciona. Comprar tiempo es para lo que sirve una escapatoria." },
        { "text": "Suena riguroso.", "correct": false, "note": "Cómo suena no viene al caso, y tratarlo como una jugada para parecer riguroso es justo cómo se convierte en una." },
        { "text": "Le devuelve la pregunta a quien te la hizo.", "correct": false, "note": "Eso describe una finta. Esto no busca quitarte la atención de encima." },
        { "text": "Nombra algo que falta y de lo que la sala puede no haberse dado cuenta.", "correct": true, "note": "Una aportación de verdad. La mitad de las veces lo que necesitarías saber es justo lo que nadie ha establecido, y decirlo es el acto útil." }
      ],
      "explain": "Nombrar lo que falta es una aportación, no una excusa por no tener ninguna."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "honest", "label": "Dijo dónde estaba de verdad", "description": "Contó el estado real de su pensamiento." },
      { "key": "gave_something", "label": "Entregó la mitad real", "description": "Ofreció la única cosa que sí tenía." },
      { "key": "no_invention", "label": "No fabricó nada", "description": "Se resistió a producir una postura plausible para llenar el silencio." },
      { "key": "no_apology", "label": "No se disculpó", "description": "Se saltó el reflejo del «perdona, no estaba siguiendo»." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Dana",
      "role": "quien dirige la reunión",
      "mood": "Quiere una opinión, no una actuación.",
      "openness": 4,
      "personality": "Directa y genuinamente interesada en la respuesta. Acepta sin comentarios una respuesta parcial y honesta, y sigue con lo real que se le ofrezca."
    },
    "setting": "Una reunión sobre una propuesta que solo te has leído a medias. La discusión lleva diez minutos y tú no has hablado.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Acepta una respuesta parcial y honesta como algo completamente normal, y construye sobre ella.",
      "Hurga con suavidad en cualquier cosa que suene fabricada, preguntando qué le hace decir eso.",
      "Nunca tranquilices a la persona ni le digas que su respuesta ha estado bien."
    ],
    "opening_beat": "«Has estado callado. ¿Tú qué opinas?»",
    "success_looks_like": "La persona responde con honestidad y ofrece la única cosa real que tiene."
  }$j$::jsonb,
  'Hoy, cuando te pregunten algo para lo que no tienes respuesta preparada, di dónde estás de verdad en vez de fabricar. Apunta qué dijiste.',
  $j${
    "says": "Has estado callado. ¿Tú qué opinas?",
    "model": {
      "line": "Todavía no tengo una opinión sobre el conjunto, pero la parte en la que me sigo enganchando es el calendario.",
      "why": "Dice dónde estás de verdad, y luego entrega la única cosa real que tienes. Una respuesta completa, y más útil para la sala que una invención dicha con seguridad."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Di dónde estás de verdad" },
      { "kind": "forbids_any", "words": ["perdona", "perdón", "no estaba siguiendo", "no estaba atento", "no prestaba atención", "se me ha escapado", "ni idea"], "requirement": "No te disculpes ni digas que no estabas siguiendo" },
      { "kind": "min_words", "n": 10, "requirement": "Entrega la mitad real, no solo el matiz" },
      { "kind": "max_words", "n": 35, "requirement": "Una frase, no un párrafo fabricado" }
    ]
  }$j$::jsonb
);
