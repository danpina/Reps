-- Spanish: Conocer a alguien, track 1 — Acercarse.
--
-- Conventions as the Work migrations: tú for the reader, **La jugada:** for
-- the move marker, **Si te quedas con una cosa:** for the closer, names left
-- alone. New for this topic:
--
-- **The `partner.alt` sex-swap structure is preserved exactly.** These
-- scenarios pick between the base partner and `alt` based on who the reader
-- said they date (see src/lib/roleplay/partner.ts). Both halves are
-- translated in full — mood, personality, everything — so a reader who dates
-- men gets Spanish dialogue from Nadim exactly as complete as a reader who
-- dates women gets from Nadia.
--
-- **No gendered adjectives about the reader**, as in Small talk: the reader's
-- own sex is never assumed, only the partner's, which the app already knows.

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

select pg_temp.es_lesson('walking-up', 1,
  'Lo que te da una sala',
  $md$Toda sala en la que podrías hablarle a alguien te da tres cosas, y son las únicas tres que cambian nunca.

**El permiso** es cuán normal es hablarle a un desconocido ahí. Alto en una cola, un retraso, una clase donde todo el mundo es nuevo. Casi cero en un gimnasio, un vagón silencioso, una biblioteca.

**El tiempo** es cuánto dura la situación sin que ninguno de los dos haga nada. Un ascensor son cuarenta segundos. Una cola son cuatro minutos. Una fiesta no tiene límite.

**El coste de salida** es lo que te cuesta si sale plano, y es el que nadie cuenta. En una cola, os vais los dos. En un gimnasio seguís ahí una hora más, a tres metros el uno del otro.

**La jugada:** lee el permiso, el tiempo y el coste de salida antes de decidir nada más.

Las combinaciones son la parte útil, porque no son obvias. Permiso alto con un reloj duro es la sala más fácil del mundo, y es de la que la gente sale más a menudo sin haber dicho nada. Permiso bajo con un coste de salida alto es la más difícil, y es la que la gente intenta primero, porque es donde ve las mismas caras.$md$,
  $j$[
    {
      "situation": "Un andén con retraso, los dos mirando el mismo panel.",
      "line": "Permiso alto, cuatro minutos, y los dos nos vamos al final.",
      "why": "La sala más fácil que existe. Todo lo que hace dudar a la gente — quedarse atrapado con ello, que te recuerden — está ausente, y el único riesgo real es que llegue el tren primero."
    },
    {
      "situation": "La zona de pesas libres, alguien a quien has visto tres martes seguidos.",
      "line": "Casi ningún permiso, una hora de tiempo, y tengo que volver el jueves.",
      "why": "La combinación más difícil disponible, y la que la gente intenta primero porque la familiaridad se siente como una apertura. El coste de salida es lo que la hace difícil, no el acercamiento."
    },
    {
      "situation": "La fiesta de un amigo, alguien de pie cerca de la comida.",
      "line": "El permiso está bien, no hay reloj, y voy a tener que terminar esto yo.",
      "why": "Las salas sin límite se sienten más difíciles que las que tienen reloj y no lo son. La dificultad es que nada te rescata, que es un problema distinto con un arreglo distinto."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿En cuál es más fácil abrir?",
      "options": [
        { "text": "Una cola de cuatro minutos en la que los dos estáis atrapados.", "correct": true, "note": "Permiso alto, un reloj duro, y ningún coste de salida. Todas las variables están a tu favor, que es exactamente por lo que merece la pena notar cuántas veces no se dice nada en una." },
        { "text": "Una fiesta donde conoces al anfitrión.", "correct": false, "note": "Buen permiso y sin reloj, así que tienes que terminarla tú. Más fácil socialmente y más difícil mecánicamente." },
        { "text": "Una clase donde todo el mundo es nuevo.", "correct": false, "note": "Genuinamente buena: permiso alto, y un motivo compartido para hablar. Solo pierde contra la cola en el coste de salida, ya que los dos volvéis la semana que viene." },
        { "text": "Un gimnasio donde os reconocéis.", "correct": false, "note": "La más difícil de las cuatro, y la que el reconocimiento hace sentir como la más fácil." }
      ],
      "explain": "Permiso, tiempo y coste de salida. Una cola gana en las tres, que es por lo que es la sala donde practicar."
    },
    {
      "prompt": "¿Por qué el coste de salida es la variable que se le pasa a la gente?",
      "options": [
        { "text": "Es difícil de juzgar.", "correct": false, "note": "Suele ser la más fácil de juzgar de las tres. Si lo vas a volver a ver no es una pregunta sutil." },
        { "text": "Es la única que pagas después de que termine la conversación.", "correct": true, "note": "El permiso y el tiempo son visibles mientras decides. El coste de salida llega el jueves, cuando los dos estáis de vuelta y nadie ha dicho nada desde entonces." },
        { "text": "Solo se aplica a unos pocos sitios.", "correct": false, "note": "Se aplica en todas partes. Es casi cero en la mayoría de las salas, que es precisamente por lo que las salas donde es alto pillan a la gente desprevenida." },
        { "text": "Importa menos que el permiso.", "correct": false, "note": "Es la variable que decide a qué velocidad ir, e ir al ritmo de una cola en un gimnasio es el error más común de todo este tema." }
      ],
      "explain": "El permiso y el tiempo son visibles ahora. El coste de salida se paga más tarde, que es por lo que se olvida."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "read_licence", "label": "Leyó el permiso", "description": "Juzgó cuán normal sería hablarle a un desconocido en esta sala." },
      { "key": "read_time", "label": "Leyó el reloj", "description": "Notó cuánto dura la situación sin que ninguno de los dos haga nada." },
      { "key": "read_exit", "label": "Contó el coste de salida", "description": "Consideró qué cuesta si sale plano, incluido volver a verlos." },
      { "key": "acted_on_it", "label": "Actuó según la lectura", "description": "Dejó que las tres variables decidieran el acercamiento en vez de decidir primero y esperar." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Nadim",
        "role": "alguien más esperando en el mismo puesto",
        "mood": "Sin ninguna prisa, disfrutando de una mañana tranquila.",
        "openness": 4,
        "personality": "Relajado y sin prisa. Responde a cualquier cosa corriente con calidez y no la va a empezar él."
      },
      "sex": "female",
      "name": "Nadia",
      "role": "alguien más esperando en el mismo puesto",
      "mood": "Sin ninguna prisa, disfrutando de una mañana tranquila.",
      "openness": 4,
      "personality": "Relajada y sin prisa. Responde a cualquier cosa corriente con calidez y no la va a empezar ella."
    },
    "setting": "Un mercadillo de sábado. Llevas un par de minutos en el mismo puesto, y también otra persona.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Sé cálido y corriente. Esta sala no es la dificultad.",
      "No abras tú la conversación.",
      "No te alargues más de una o dos frases."
    ],
    "opening_beat": "Quien lleva el puesto desaparece por detrás a por algo, y os quedáis los dos esperando.",
    "success_looks_like": "La persona nota que la sala tiene permiso alto con un reloj suave, y abre en consecuencia."
  }$j$::jsonb,
  'Hoy, elige tres salas en las que ya estés de todas formas y puntúa cada una en voz alta: permiso, tiempo, coste de salida. No abras nada. Apunta las tres, y cuál te sorprendió.',
  $j${
    "beats": [
      {
        "situation": "Un desayuno de hotel la segunda mañana de un congreso de tres días. Alguien está esperando la tostadora, y tú también. Ninguno de los dos se va a mover en unos noventa segundos.",
        "prompt": "¿Cuáles son los tres números?",
        "options": [
          { "text": "Permiso alto, sin reloj, sin coste de salida.", "correct": false, "note": "La tostadora es un reloj. Que se te pase es lo que convierte una sala de noventa segundos en dos minutos decidiendo." },
          { "text": "Permiso bajo, un reloj corto, coste de salida alto.", "correct": false, "note": "Los congresos funcionan a base de que los desconocidos se presenten. El permiso aquí es casi tan alto como se pone fuera de una cola." },
          { "text": "Permiso alto, un reloj corto, sin coste de salida.", "correct": true, "note": "Aquí todo el mundo es un desconocido con un motivo para estar hablando, la tostadora lo termina, y los dos vais a estar después en una sala de doscientas personas. Tan libre como se pone un intento." },
          { "text": "Permiso alto, un reloj corto, coste de salida alto.", "correct": false, "note": "La vas a volver a ver en una sala llena de gente que para el jueves se parece toda. Eso no es un coste de salida." }
        ]
      },
      {
        "situation": "El mismo congreso. Alguien está en la cinta de correr de al lado en el gimnasio del hotel a las siete de la mañana, y la has visto ahí los dos días anteriores.",
        "prompt": "¿Qué ha cambiado?",
        "options": [
          { "text": "No mucho: sigue siendo el congreso.", "correct": false, "note": "El congreso es por lo que estáis los dos en el hotel. No es por lo que estáis los dos en una cinta de correr, y la cinta es la sala en la que estás de verdad." },
          { "text": "El permiso es más alto, porque os reconocéis.", "correct": false, "note": "El reconocimiento sube el coste de salida, no el permiso. Este es el intercambio que mete en problemas a la gente en salas que se repiten." },
          { "text": "Ahora no hay reloj, así que es más fácil.", "correct": false, "note": "Sin reloj lo hace más difícil, no más fácil, y es el más pequeño de los tres cambios aquí." },
          { "text": "El permiso ha bajado y el coste de salida ha subido.", "correct": true, "note": "El mismo edificio, la misma gente, la sala contraria. Los gimnasios suspenden el permiso corriente para hablar, y que llevéis los dos tres mañanas aquí significa que un mal acercamiento sigue ahí mañana." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('walking-up', 2,
  'Colas, ascensores y andenes',
  $md$En una sala con reloj, la situación termina esto por ti, y eso lo cambia todo.

No necesitas una salida, porque está llegando una. No necesitas sostenerlo, porque no puede durar. No necesitas preocuparte de que te recuerden, porque los dos os vais a ir dentro de cuatro minutos. Es lo más parecido a un intento gratis que existe.

**La jugada:** abre en los primeros treinta segundos, porque el reloj es toda la ventaja y ya está corriendo.

El error no es una mala frase, son las cuentas. La gente gasta dos minutos de una cola de cuatro decidiendo, y luego se encuentra con que el momento ya pasó y concluye que la sala era difícil. La sala era la más fácil en la que iba a estar en toda la semana.

Corta, además. En una sala con reloj, una apertura larga es una cosa rara de recibir, porque los dos sois audiblemente conscientes de que no queda mucho tiempo. Una frase sobre lo que los dos estáis esperando, y luego deja que sea tan breve como quiera.$md$,
  $j$[
    {
      "situation": "Un andén, el tren retrasado dos veces, los dos mirando el panel.",
      "line": "Este es el segundo esta noche.",
      "why": "Tres palabras sobre lo que os tiene atrapados a los dos. No cuesta nada decirlo, no cuesta nada responderlo, y el tren lo va a terminar de todas formas."
    },
    {
      "situation": "Un ascensor subiendo seis pisos.",
      "line": "Este se lo toma con calma.",
      "why": "Cuarenta segundos no bastan para una conversación y sobran para un intercambio. Tratar un ascensor como una conversación fallida es lo que hace incómodos a los ascensores."
    },
    {
      "situation": "Llevas dos minutos en la cola componiendo algo mejor.",
      "line": "(di la corta ahora)",
      "why": "El reloj que hace segura esta sala es el reloj que has estado gastando. Una frase floja a los noventa segundos gana a una buena a los tres minutos, es decir, nunca."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hace de una cola la mejor sala para practicar?",
      "options": [
        { "text": "La gente en las colas se aburre y quiere hablar.", "correct": false, "note": "A menudo cierto y no es el mecanismo. El aburrimiento sube el permiso; el reloj es lo que quita el riesgo." },
        { "text": "No hay nadie más escuchando.", "correct": false, "note": "Un montón de gente sí, y no importa. Este es el miedo del que trata el primer tema." },
        { "text": "Termina sola, así que nunca tienes que terminarla tú.", "correct": true, "note": "La salida es gratis, automática y visible para los dos. Casi todo lo que la gente teme de abrir va sobre qué pasa después, y aquí no hay después." },
        { "text": "Es fácil pensar en algo que decir.", "correct": false, "note": "Cierto en casi todas las salas. La ventaja de la cola es estructural, no conversacional." }
      ],
      "explain": "El reloj es toda la ventaja. Una salida gratis es lo que hace gratis un intento."
    },
    {
      "prompt": "Llevas dos de los cuatro minutos de una cola y no has dicho nada. ¿Qué salió mal?",
      "options": [
        { "text": "No hubo una apertura natural.", "correct": false, "note": "En una cola, la situación misma es la apertura, permanentemente, mientras los dos sigáis en ella." },
        { "text": "Necesitas una frase mejor para la próxima vez.", "correct": false, "note": "La frase nunca se puso a prueba. Mejorarla no arregla nada de lo que pasó de verdad." },
        { "text": "Ya es demasiado tarde.", "correct": false, "note": "Dos minutos es tarde, no ido. Tarde y dicho gana a a tiempo e imaginado." },
        { "text": "Gastaste la ventaja decidiendo.", "correct": true, "note": "El reloj era lo que hacía fácil esto, y ha estado corriendo todo el tiempo que llevabas eligiendo una frase. Este es el fallo en las salas con reloj, no una mala apertura." }
      ],
      "explain": "En una sala con reloj, el único error real es gastar el tiempo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "went_early", "label": "Abrió pronto", "description": "Habló mientras todavía quedaba tiempo en vez de después de decidir." },
      { "key": "kept_it_short", "label": "Lo mantuvo corto", "description": "Dijo una frase del tamaño de una sala a punto de terminar." },
      { "key": "shared_thing", "label": "Usó lo compartido", "description": "Abrió sobre lo que los dos estáis esperando en vez de sobre ellos." },
      { "key": "let_it_end", "label": "Dejó que terminara", "description": "Permitió que la situación acabara el intercambio en vez de intentar alargarlo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Emlyn",
        "role": "alguien esperando el mismo tren",
        "mood": "Ligeramente harto del ferrocarril, no de ti.",
        "openness": 4,
        "personality": "Seco y fácil. Responde a un comentario corriente con otro corriente y está igual de contento con las dos opciones."
      },
      "sex": "female",
      "name": "Esme",
      "role": "alguien esperando el mismo tren",
      "mood": "Ligeramente harta del ferrocarril, no de ti.",
      "openness": 4,
      "personality": "Seca y fácil. Responde a un comentario corriente con otro corriente y está igual de contenta con las dos opciones."
    },
    "setting": "Un andén un viernes por la tarde. El panel acaba de retrasar el tren por segunda vez y quedan unos seis minutos.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con brevedad, como se hace en un andén.",
      "Nunca abras tú la conversación.",
      "No alargues el intercambio de forma artificial. Esta sala está pensada para ser corta."
    ],
    "opening_beat": "El panel parpadea y el retraso sube otros cuatro minutos. Se oye un suspiro general por el andén.",
    "success_looks_like": "La persona dice algo corto sobre el retraso en cuestión de segundos en vez de deliberar."
  }$j$::jsonb,
  'Hoy, abre una conversación en una sala con reloj: una cola, un ascensor, un andén. Dilo dentro de los treinta segundos de haberlos notado. Apunta cuánto tardaste de verdad.',
  $j${
    "says": "(el panel parpadea, el retraso vuelve a subir, y se oye un suspiro por el andén)",
    "model": {
      "line": "Este es el segundo esta noche.",
      "why": "Tres palabras sobre lo que los dos estáis mirando. Llega antes de que hayas tenido tiempo de convencerte de no decirlo, que es toda la habilidad en una sala con reloj."
    },
    "checks": [
      { "kind": "contains_any", "words": ["retraso", "retrasado", "tren", "panel", "andén", "tarde", "otra vez", "segundo", "esperar"], "requirement": "Abre sobre lo que los dos estáis esperando" },
      { "kind": "max_words", "n": 10, "requirement": "Menos de diez palabras. Los dos tenéis un reloj encima." },
      { "kind": "max_sentences", "n": 1, "requirement": "Una línea, y que sea breve" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('walking-up', 3,
  'Bares y fiestas',
  $md$Una sala sin límite se siente más difícil que una cola y no lo es. La dificultad está en un sitio donde la gente no la busca.

Nada termina esto por ti. Esa es toda la diferencia. En una cola llega el tren; en una fiesta la conversación sigue hasta que uno de los dos hace algo al respecto, y saber en silencio que puede que no puedas es lo que hace que empezar se sienta caro.

**La jugada:** date una salida pronto, en voz alta, antes de necesitarla.

*Dentro de un rato voy a buscar a mi amiga* no cuesta nada, suena a conversación corriente, y convierte una sala sin límite en una con reloj que controlas tú. Normalmente no la vas a usar. Ese no es el punto: tenerla es lo que te deja relajarte, y relajado es casi todo lo que hace que alguien sea buena compañía.

Lo segundo que te da una sala sin límite es repetición. No hay penalización por un intercambio plano en una fiesta, porque hay otras cuarenta personas y nadie está llevando la cuenta. Una sala sin reloj es una sala con muchos intentos dentro.$md$,
  $j$[
    {
      "situation": "Tres minutos hablando con alguien en una fiesta.",
      "line": "He dicho que iba a buscar a Priya en algún momento, pero — ¿cómo es que conoces a todo el mundo aquí?",
      "why": "La salida está plantada y la conversación sigue por encima. Ninguno de los dos tiene que darse cuenta de que ha pasado."
    },
    {
      "situation": "La conversación va bien y no has plantado nada.",
      "line": "(plántala igualmente, ahora)",
      "why": "La salida es más fácil de instalar mientras las cosas van bien, y no vale nada si esperas a quererla. Instalada pronto es invisible; producida tarde es un anuncio."
    },
    {
      "situation": "Un intercambio se ha quedado plano y sigues ahí de pie.",
      "line": "(usa la salida, y ve a tener otro)",
      "why": "El segundo regalo de la sala. Una conversación plana en una fiesta no cuesta nada salvo los cuatro minutos, y hay treinta personas más ahí dentro."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué una sala sin límite se siente más difícil que una cola?",
      "options": [
        { "text": "Nada la termina, así que tienes que hacerlo tú, y puede que no estés seguro de poder.", "correct": true, "note": "La dificultad está en el extremo equivocado. La gente cree que le da miedo empezar y en realidad no está segura de cómo terminar." },
        { "text": "Hay más gente mirando.", "correct": false, "note": "La hay, y casi ninguna lo está haciendo. Que te observen es otro miedo con otra lección." },
        { "text": "La conversación tiene que ser mejor.", "correct": false, "note": "No tiene que serlo, y creer que sí es lo que hace que la gente espere una buena apertura en una fiesta. Lo corriente funciona aquí igual que en cualquier sitio." },
        { "text": "La vas a volver a ver más tarde esa misma noche.", "correct": false, "note": "Un coste real y menor. No es nada comparado con no tener ninguna salida disponible." }
      ],
      "explain": "El problema en una sala sin reloj es el final, no el principio. Arregla el final y el principio se vuelve fácil."
    },
    {
      "prompt": "¿Cuándo es el momento correcto para plantar una salida?",
      "options": [
        { "text": "En cuanto empiece a decaer.", "correct": false, "note": "Que es exactamente cuando deja de ser invisible. El sentido de plantarla pronto es que en ese momento no cuesta nada." },
        { "text": "Pronto, mientras va bien.", "correct": true, "note": "Instalada pronto se lee como conversación corriente. Producida en el momento en que quieres irte, la misma frase se lee como una excusa, porque lo es." },
        { "text": "No hace falta ninguna si va bien.", "correct": false, "note": "Las conversaciones que van bien son las que más quieres terminar con elegancia. Terminar en el punto álgido es todo el tema de Salidas en Conversación ligera." },
        { "text": "Justo al principio, antes de abrir.", "correct": false, "note": "Un poco demasiado pronto. Una salida anunciada antes de que haya empezado una conversación es una primera frase rara." }
      ],
      "explain": "Plántala mientras va bien. Así es contexto y no una excusa."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "opened", "label": "Abrió del todo", "description": "Habló sin esperar una excusa estructural que la sala nunca le iba a dar." },
      { "key": "planted_exit", "label": "Plantó una salida", "description": "Se dio una vía de salida pronto, de pasada, en vez de en el momento en que la quería." },
      { "key": "stayed_relaxed", "label": "Se mantuvo relajado", "description": "Dejó que la conversación fuera corriente en vez de intentar justificar haberla empezado." },
      { "key": "used_the_room", "label": "Usó la sala", "description": "Trató un intercambio plano como uno de muchos en vez de como un veredicto." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Rory",
        "role": "alguien de pie cerca de la misma mesa",
        "mood": "Disfrutando de la noche, sin ninguna agenda en particular.",
        "openness": 4,
        "personality": "Sociable y fácil de hablar con él, e igual de contento si le dejan en paz. Sigue el registro que le den."
      },
      "sex": "female",
      "name": "Rosa",
      "role": "alguien de pie cerca de la misma mesa",
      "mood": "Disfrutando de la noche, sin ninguna agenda en particular.",
      "openness": 4,
      "personality": "Sociable y fácil de hablar con ella, e igual de contenta si la dejan en paz. Sigue el registro que le den."
    },
    "setting": "Las copas de cumpleaños de la amiga de una amiga, en la trastienda de un bar. Unas cuarenta personas, la mayoría desconocidas para ti.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Trata una salida plantada como algo completamente normal. No la comentes nunca.",
      "No abras tú la conversación.",
      "Mantén las respuestas del largo que se usa en una fiesta."
    ],
    "opening_beat": "El grupo al que estabas medio pegado se ha ido disolviendo, y os quedáis los dos de pie cerca de la misma mesa.",
    "success_looks_like": "La persona abre, y se da una vía de salida pronto en vez de en el momento en que la necesita."
  }$j$::jsonb,
  'Hoy, en cualquier reunión sin límite, planta una salida en los tres primeros minutos de una conversación y luego sigue. Fíjate en si la usaste. Apunta la frase y qué pasó.',
  $j${
    "turns": [
      { "instruction": "Abre. Corriente está bien: esta sala no tiene reloj, así que nada en la primera línea es determinante." },
      { "instruction": "Ahora planta tu salida, de pasada, mientras todavía va bien. Y luego sigue directo con la conversación." }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('walking-up', 4,
  'El gimnasio, la clase, el mismo café',
  $md$Las salas a las que vuelves funcionan con reglas completamente distintas, y casi todo el mundo se equivoca en la misma dirección.

El permiso en una sala que se repite no lo da la situación, se gana a lo largo de las sesiones. No eres un desconocido a la cuarta vez y tampoco se te debe una conversación. Y el coste de salida es el más alto que hay en ningún sitio: si sale mal, los dos vais a estar de vuelta el jueves, a tres metros el uno del otro, durante una hora.

**La jugada:** gasta semanas en vez de minutos. Que te reconozcan antes de hablar, y habla antes de conversar.

Son tres etapas y son más lentas de lo que parecen. Reconocer es un saludo con la cabeza, dos veces. Hablar son cuatro palabras sobre lo que los dos estáis haciendo. Convertir eso en una conversación de verdad es una cuarta o quinta ocasión, y si te la saltas en la primera has gastado un permiso que no tenías.

La recompensa por la paciencia es grande. En una sala que se repite, la familiaridad hace el trabajo que en cualquier otro sitio tendría que hacer una apertura: para cuando hablas de verdad no hay nada que explicar, porque los dos ya sois parte del mobiliario.$md$,
  $j$[
    {
      "situation": "La tercera vez que ves a la misma persona en la misma clase.",
      "line": "(saluda con la cabeza, nada más)",
      "why": "Toda la jugada de la semana uno. Un saludo con la cabeza no cuesta nada, es imposible hacerlo mal, y es lo que hace que una frase en la semana tres no sea repentina."
    },
    {
      "situation": "Quinta sesión, estáis esperando el mismo aparato.",
      "line": "¿Has terminado con esto?",
      "why": "Cuatro palabras sobre lo que los dos estáis haciendo. No es tanto una apertura como reconocer que sois dos personas en la misma sala, que es el verdadero hito."
    },
    {
      "situation": "Primera sesión, y parecen simpáticos.",
      "line": "(saluda con la cabeza y déjalo así: tienes semanas)",
      "why": "El error del que trata toda la lección. Ir al ritmo de una cola en la sala con el coste de salida más alto que hay es lo que hace que la gente cambie de gimnasio en silencio."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué un gimnasio es más difícil que una fiesta, incluso cuando reconoces a alguien?",
      "options": [
        { "text": "La gente está ocupada y no quiere hablar.", "correct": false, "note": "A menudo cierto y es solo la mitad del permiso. El motivo para ir despacio es lo que pasa el jueves." },
        { "text": "No hay un tema natural.", "correct": false, "note": "Hay uno obvio, y los dos lo estáis haciendo. El tema no es la limitación aquí." },
        { "text": "Permiso bajo y el coste de salida más alto que hay.", "correct": true, "note": "Las dos variables están en tu contra a la vez, y el reconocimiento, lo que lo hace sentir más fácil, es justo lo que sube el coste de salida." },
        { "text": "No os podéis oír.", "correct": false, "note": "Una molestia práctica más que el problema estructural." }
      ],
      "explain": "El reconocimiento se siente como una apertura y en realidad es lo que hace caro un mal acercamiento."
    },
    {
      "prompt": "Cuarta semana, has saludado con la cabeza unas cuantas veces y nunca has hablado. ¿Y ahora?",
      "options": [
        { "text": "Presentarte como es debido.", "correct": false, "note": "Te saltas una etapa. Una presentación pide una conversación, y saludar con la cabeza todavía no ha establecido que ninguno de los dos quiera una." },
        { "text": "Seguir saludando: está funcionando.", "correct": false, "note": "Estaba funcionando. Reconocer es una etapa y no un destino, y cuatro semanas es pasado el punto en que se convierte solo." },
        { "text": "Esperar a que hable primero.", "correct": false, "note": "Está haciendo el mismo cálculo, y probablemente perdiéndolo también." },
        { "text": "Cuatro palabras sobre lo que los dos estáis haciendo.", "correct": true, "note": "La siguiente etapa y no la última. Pequeña, sobre la actividad compartida, y sin exigir nada, que es lo que han comprado cuatro semanas de saludos." }
      ],
      "explain": "Reconocido, luego hablado, luego en conversación. Tres etapas, y los huecos entre ellas son semanas."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "read_the_room", "label": "Leyó el coste de salida", "description": "Reconoció que esta es una sala a la que va a volver, y frenó en consecuencia." },
      { "key": "right_stage", "label": "Fue a la etapa correcta", "description": "Saludó con la cabeza antes de hablar, y habló antes de intentar conversar." },
      { "key": "small_enough", "label": "Lo mantuvo pequeño", "description": "Dijo algo que no exigía nada de la otra persona." },
      { "key": "patient", "label": "Estuvo dispuesto a esperar", "description": "Aceptó que la recompensa está a semanas de distancia en vez de forzarla en una sesión." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Ivo",
        "role": "alguien que ha estado en la misma clase todo el trimestre",
        "mood": "Cómodo, a media faena, del todo relajado.",
        "openness": 3,
        "personality": "Simpático y algo reservado. Responde con calidez a un comentario pequeño y no lo va a convertir en nada por su cuenta."
      },
      "sex": "female",
      "name": "Ines",
      "role": "alguien que ha estado en la misma clase todo el trimestre",
      "mood": "Cómoda, a media faena, del todo relajada.",
      "openness": 3,
      "personality": "Simpática y algo reservada. Responde con calidez a un comentario pequeño y no lo va a convertir en nada por su cuenta."
    },
    "setting": "Una clase de cerámica los martes por la tarde, la sexta semana de ocho. Has saludado con la cabeza a la misma persona casi todas las semanas y nunca has hablado.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a un comentario pequeño con calidez y no lo amplíes mucho. Seis semanas de saludos compran un intercambio, no una amistad.",
      "Si la persona se presenta formalmente, responde con educación y algo de sorpresa.",
      "Nunca abras tú la conversación."
    ],
    "opening_beat": "Los dos llegáis al fregadero a la vez. Hay una cola de dos para usarlo.",
    "success_looks_like": "La persona dice algo pequeño sobre la actividad compartida en vez de presentarse."
  }$j$::jsonb,
  'Elige una sala a la que vuelvas cada semana. Esta semana, saluda con la cabeza. No hables. Apunta la sala y cuántas veces te han reconocido ya en ella.',
  $j${
    "beats": [
      {
        "situation": "Semana uno de una clase de ocho semanas. Alguien se sienta cerca de ti, parece simpático, y te cruza la mirada dos veces.",
        "prompt": "¿Qué haces?",
        "options": [
          { "text": "Saludar con la cabeza, y nada más, por ahora.", "correct": true, "note": "Tienes siete semanas. Reconocer no cuesta nada y no puede salir mal, y es lo que hace que una frase en la semana tres no sea repentina." },
          { "text": "Presentarte: todo el mundo es nuevo.", "correct": false, "note": "La sala tiene permiso alto en la semana uno y el coste de salida no cambia: los dos estáis aquí hasta marzo. Ser quien se presentó con fuerza es algo que se es durante ocho semanas." },
          { "text": "Decir algo sobre la clase.", "correct": false, "note": "No está mal, y es una etapa temprano. Funciona mejor una vez que sois dos personas que se reconocen que cuando sois dos desconocidos." },
          { "text": "Esperar a ver si habla primero.", "correct": false, "note": "Pasivo en vez de paciente. Saludar con la cabeza es hacer algo; esperar no." }
        ]
      },
      {
        "situation": "Semana cinco. Has saludado casi todas las semanas, has dicho cuatro palabras dos veces, y las dos veces ha sido fácil.",
        "prompt": "¿Cuál es la siguiente etapa?",
        "options": [
          { "text": "Pedirle algo de beber después.", "correct": false, "note": "Dos etapas a la vez. El intercambio va antes que la invitación, y saltártelo gasta un permiso que costó cinco semanas ganar." },
          { "text": "Un intercambio de verdad sobre algo que no sea la clase.", "correct": true, "note": "Cinco semanas de reconocimiento y dos intercambios pequeños es exactamente lo que compra esto. Va a parecer que casi no se ha construido nada, y se ha construido mucho." },
          { "text": "Más de lo mismo: está funcionando.", "correct": false, "note": "Estaba funcionando, y el trimestre termina en tres semanas. Repetir una etapa indefinidamente es la otra forma en que esto sale mal." },
          { "text": "Nada. Si quisiera más lo habría dicho.", "correct": false, "note": "Ha recibido con calidez cada cosa pequeña, dos veces. Esa es la señal, y leerla como indiferencia es cómo la versión paciente se convierte en la versión nunca." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('walking-up', 5,
  'A solas, o en grupo',
  $md$Acercarte a alguien que está de pie con un amigo es un problema distinto, y tratarlo como el otro es la forma más común en que esto sale mal.

El amigo no es un obstáculo, y tampoco es decorado. Llegaron juntos, se van a ir juntos, y con casi total seguridad han hablado de la noche. Hablarle por encima a la persona que te interesa le pide al amigo que se quede ahí ignorado, y va a terminar la conversación por los dos en menos de un minuto, razonablemente.

**La jugada:** dirígete al grupo, no a la persona.

Di algo a los dos. Merece la pena hablar contigo delante del amigo. La persona que de verdad te interesa ahora puede interesarse de vuelta sin tener que actuarlo delante de alguien, que es algo mucho más fácil de pedirle a cualquiera.

La parte contraintuitiva es que una pareja suele ser más fácil que alguien solo, en cuanto dejas de intentar aislar. Dos personas tienen una conversación en marcha a la que te puedes unir, y ninguna de las dos está bajo ningún foco. Alguien de pie a solas no tiene nada que hacer salvo evaluarte.$md$,
  $j$[
    {
      "situation": "Dos personas en la barra, una de las cuales te gustaría conocer.",
      "line": "¿Vosotros también estáis esperando a ver si han dejado de servir comida?",
      "why": "Dirigida a los dos, sobre la situación en la que estáis los tres. Nada en ella señala a nadie en concreto, que es lo que la hace sobrevivible."
    },
    {
      "situation": "Llevas unos minutos hablando con la pareja y va bien.",
      "line": "(sigue incluyendo al amigo)",
      "why": "El momento en que la gente deja de lado al amigo es el momento en que el amigo empieza a buscar la salida. Incluirlo cuesta una frase cada minuto más o menos."
    },
    {
      "situation": "Alguien de pie a solas, sin el móvil, mirando alrededor.",
      "line": "¿Muy lejos de todos los que conoces?",
      "why": "A solas es otro trabajo: sin portero, y tampoco sin cobertura. No tiene nada que hacer salvo evaluar el acercamiento, así que tiene que ser más ligero y más fácil de rechazar."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué hablarle por encima al amigo es el error?",
      "options": [
        { "text": "Le pide que se quede ahí ignorado, y va a terminarlo.", "correct": true, "note": "Llegaron juntos y se van a ir juntos. Un amigo al que han vuelto irrelevante hace lo razonable y rescata a su amigo." },
        { "text": "Es de mala educación.", "correct": false, "note": "Lo es, y la mala educación no es por lo que falla. Falla porque el amigo tiene tanto el motivo como los medios para terminar la conversación." },
        { "text": "Puede que el amigo también esté interesado en ti.", "correct": false, "note": "Una complicación distinta y más rara. El fallo corriente no necesita ninguna subtrama romántica." },
        { "text": "No puedes distinguir cuál es cuál.", "correct": false, "note": "No es el problema. Dirigirte a los dos es correcto incluso cuando estás completamente seguro." }
      ],
      "explain": "Dirígete al grupo. El amigo no es un obstáculo salvo que lo conviertas en uno."
    },
    {
      "prompt": "¿Por qué una pareja suele ser más fácil que alguien de pie a solas?",
      "options": [
        { "text": "Puedes hablar con el amigo si sale mal.", "correct": false, "note": "Un consuelo más que el mecanismo, y un plan un poco raro." },
        { "text": "Hay una conversación a la que unirse, y nadie está bajo un foco.", "correct": true, "note": "Una pareja te da cobertura, un tema y un público compartido. Alguien a solas no tiene nada que hacer salvo evaluar el acercamiento." },
        { "text": "Dos personas tienen más probabilidades de ser simpáticas.", "correct": false, "note": "Ni más ni menos. La ventaja es estructural." },
        { "text": "Es menos obvio lo que quieres.", "correct": false, "note": "En parte verdad, y la ambigüedad es una ganancia más pequeña que la cobertura y el tema." }
      ],
      "explain": "Una pareja te entrega un tema y quita el foco. A solas no te da ninguna de las dos cosas."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "addressed_both", "label": "Se dirigió al grupo", "description": "Habló con todos los que estaban ahí de pie en vez de por encima de ellos." },
      { "key": "kept_including", "label": "Mantuvo incluido al amigo", "description": "Siguió incluyéndolo en vez de dejarlo de lado en cuanto fue bien." },
      { "key": "no_isolation", "label": "No aisló", "description": "Evitó maniobrar para apartar a la persona de con quien había venido." },
      { "key": "right_weight", "label": "Le dio el peso correcto a la sala", "description": "Abrió con la ligereza suficiente como para que cualquiera de ellos pudiera declinar sin que fuera un momento." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Fyfe",
        "role": "uno de dos amigos que han venido juntos",
        "mood": "Pasándolo bien esta noche.",
        "openness": 4,
        "personality": "Abierto y rápido, y observa cómo tratas a su amiga. Se anima rápido si la incluyen y se enfría de inmediato si no."
      },
      "sex": "female",
      "name": "Freya",
      "role": "uno de dos amigos que han venido juntos",
      "mood": "Pasándolo bien esta noche.",
      "openness": 4,
      "personality": "Abierta y rápida, y observa cómo tratas a su amigo. Se anima rápido si lo incluyen y se enfría de inmediato si no."
    },
    "setting": "Un concierto, entre el telonero y el grupo principal. Dos personas están de pie cerca de la barra con una conversación en marcha.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Habla por ti, y menciona lo que dice o hace tu amigo para que se note su presencia.",
      "Enfríate de forma notable si la persona habla por encima de tu amigo o intenta aislarte.",
      "Nunca abras tú la conversación."
    ],
    "opening_beat": "El telonero ha terminado y la sala ha pasado de ruidosa a hablable. Los dos se están riendo de algo.",
    "success_looks_like": "La persona abre a los dos y sigue incluyendo al amigo mientras avanza."
  }$j$::jsonb,
  'Hoy, si te acercas a alguien que está de pie con otra persona, abre a los dos y mantén incluido al amigo durante toda la conversación. Apunta con quién hablaste y si lo conseguiste.',
  $j${
    "says": "(los dos se están riendo de algo, y la sala se acaba de quedar lo bastante tranquila como para hablar)",
    "model": {
      "line": "¿Sois los dos los únicos aquí que también habéis visto al telonero?",
      "why": "Dirigida a los dos, sobre la sala en la que estáis los tres, y no le quita nada a nadie. El amigo queda incluido antes de que haya ninguna duda de si lo estará."
    },
    "checks": [
      { "kind": "contains_any", "words": ["vosotros dos", "los dos", "cualquiera de los dos", "vosotros", "alguno de los dos"], "requirement": "Dirígete a los dos, no a uno" },
      { "kind": "max_words", "n": 20, "requirement": "Menos de veinte palabras: lo bastante ligero como para poder rechazarlo" }
    ]
  }$j$::jsonb
);
