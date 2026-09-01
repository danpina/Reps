-- Spanish: Conocer a alguien, track 3 — Flirtear: las jugadas. Six lessons,
-- the longest track in the topic.
--
-- Conventions as migration 129, including the full `partner.alt` sex-swap
-- translation. One note specific to this track:
--
-- **"Notch" is "escalón" throughout, matching "los rungs" ("los escalones")
-- in lesson 5 on touch.** The English uses two different words for the same
-- idea — "notch" for warmth/attention, "rung" for touch — and Spanish
-- collapses them into one image on purpose: both are steps on the same
-- ladder, which is exactly the point lesson 6 makes explicit ("one notch,
-- offered and released" = "un escalón, ofrecido y soltado").

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

select pg_temp.es_lesson('flirting-moves', 1,
  'Qué hace que sea flirteo',
  $md$La gente trata el flirteo como un talento, y son dos ingredientes que se pueden nombrar.

El primero es **la concreción**. La calidez que está disponible para cualquiera es simpatía. La calidez que solo podría ir dirigida a esta persona es otra cosa, y el cambio entre las dos no es intensidad: es precisión. *Esto es divertido* es simpático. *Me alegro de haber acabado en este extremo de la mesa* no lo es, y la única diferencia es que la segunda no se le podría haber dicho a la sala.

El segundo es **la negabilidad**. Todo lo que funciona aquí se puede recibir como simpatía corriente si eso es todo lo que quieren que sea. Eso no es cobardía, es el mecanismo: deja que dos personas se descubran mutuamente sin que ninguna tenga que ser quien lo dijo primero en voz alta.

**La jugada:** haz que la calidez sea concreta hacia ellos, y déjala negable.

Las dos cosas a la vez. Concreta sin negable es una declaración, y pone a alguien contra las cuerdas con un público de uno. Negable sin concreta es solo ser amable, que es agradable y no lleva a ningún sitio.

Todo lo de este tema es una forma de hacer esas dos cosas: con un chiste, un cumplido, una mirada, o una mano en un brazo. Los ingredientes no cambian.$md$,
  $j$[
    {
      "situation": "Una conversación en una cena que lleva diez minutos yendo bien.",
      "line": "Me alegro de haber acabado en este extremo de la mesa.",
      "why": "Concreto — solo podría ser sobre este asiento y esta persona — y completamente negable. Si quieren que signifique la compañía en general, puede."
    },
    {
      "situation": "Quieres decir que lo estás disfrutando y te sale como «esto es divertido».",
      "line": "(apúntalo: esto está siendo más divertido de lo que esperaba esta noche)",
      "why": "La misma calidez, dirigida. La calidez sin dirigir es simpatía, y la simpatía no es información."
    },
    {
      "situation": "Estás a punto de decir algo que ya no tiene ninguna negabilidad dentro.",
      "line": "(da un paso atrás)",
      "why": "Una declaración les quita la salida y les pide que emitan un veredicto. El escalón de abajo hace la misma pregunta y les deja responder con una mirada."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué separa de verdad lo simpático de lo flirteante?",
      "options": [
        { "text": "Cuánta calidez hay.", "correct": false, "note": "Muy cálido y completamente general es lo que hace un buen anfitrión toda la noche, y nadie lo confunde con flirteo." },
        { "text": "Si les tocas.", "correct": false, "note": "Una jugada entre varias, y va tarde en la escalera. Un montón de flirteo pasa sin ningún contacto." },
        { "text": "Si la calidez solo podría haber ido dirigida a ellos.", "correct": true, "note": "Concreción en vez de intensidad. La misma frase dirigida a una persona en vez de a una sala cambia de categoría sin cambiar de volumen." },
        { "text": "Si lo dices en serio.", "correct": false, "note": "Invisible desde fuera. Solo pueden leer lo que se dijo de verdad." }
      ],
      "explain": "Dirige la calidez. La calidez sin dirigir es simpatía, por mucha que haya."
    },
    {
      "prompt": "¿Por qué importa la negabilidad tanto como la concreción?",
      "options": [
        { "text": "Les deja responder sin tener que declarar nada.", "correct": true, "note": "Es el mecanismo, no una salvaguarda. Los dos podéis averiguar hacia dónde va esto sin que ninguno tenga que ser quien lo dijo primero." },
        { "text": "Te protege del bochorno.", "correct": false, "note": "Un efecto secundario, y la mitad más pequeña. Sobre todo les protege a ellos de tener que emitir un veredicto al momento." },
        { "text": "Es más educado.", "correct": false, "note": "La educación no es lo que hace el trabajo. Una jugada negable es más fácil de responder, que es una propiedad distinta." },
        { "text": "Mantiene abiertas tus opciones.", "correct": false, "note": "Así es como se ve desde fuera y no es el sentido. La opción que importa aquí es la suya." }
      ],
      "explain": "La negabilidad es lo que hace respondible una jugada. Sin ella le has entregado a alguien un veredicto que emitir."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "specific", "label": "Dirigido a ellos", "description": "Dijo algo que no se le podría haber dicho a la sala." },
      { "key": "deniable", "label": "Lo dejó negable", "description": "Lo mantuvo recibible como simpatía corriente." },
      { "key": "not_a_declaration", "label": "No declaró", "description": "Evitó ponerlos contra las cuerdas para un veredicto." },
      { "key": "warm", "label": "Fue cálido de verdad", "description": "Ofreció algo en vez de limitarse a ser cauteloso." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Wren",
        "role": "un amigo de quien cumple años, sentado a tu lado",
        "mood": "Disfrutando de la noche.",
        "openness": 4,
        "personality": "Cálido y rápido, y sigue el registro que le den. Recibe con comodidad una jugada negable y se pone tenso ante una declaración."
      },
      "sex": "female",
      "name": "Wren",
      "role": "una amiga de quien cumple años, sentada a tu lado",
      "mood": "Disfrutando de la noche.",
      "openness": 4,
      "personality": "Cálida y rápida, y sigue el registro que le den. Recibe con comodidad una jugada negable y se pone tensa ante una declaración."
    },
    "setting": "Una mesa larga en la cena de cumpleaños de un amigo. Llevas hablando con la persona de al lado desde los entrantes y ha ido fácil.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Recibe con calidez un comentario concreto y negable, y devuelve un poco.",
      "Ponte educadamente neutral si la persona hace una declaración sin ninguna negabilidad dentro.",
      "Trata la simpatía general como agradable y anodina."
    ],
    "opening_beat": "Se llevan los platos y hay un hueco antes de que se mueva nadie. Se giran un poco hacia ti en vez de hacia el resto de la mesa.",
    "success_looks_like": "La persona dice algo cálido dirigido a esta persona y que se pueda seguir leyendo como simpático."
  }$j$::jsonb,
  'Hoy, coge una cosa cálida que hubieras dicho en general y dirígela a la persona en su lugar. Apunta la versión general y la dirigida.',
  $j${
    "beats": [
      {
        "situation": "Diez minutos dentro de una buena conversación en una cena. Quieres decir que lo estás disfrutando.",
        "prompt": "¿Cuál de estas es flirteo?",
        "options": [
          { "text": "Esto es divertido.", "correct": false, "note": "Cálido y sin dirigir. Se le podría haber dicho a la sala, lo que lo convierte en simpatía y no en información." },
          { "text": "Eres de lejos la persona más interesante de aquí.", "correct": false, "note": "Concreto y sin ninguna negabilidad dentro. Les quita la salida y pide un veredicto." },
          { "text": "Me alegro de haber acabado en este extremo de la mesa.", "correct": true, "note": "Concreto — solo podría ser sobre este asiento y esta persona — y completamente negable. Los dos ingredientes, a bajo volumen." },
          { "text": "Aquí todo el mundo es genial, la verdad.", "correct": false, "note": "Calidez máxima, dirección cero. Esto es lo que hace un buen anfitrión toda la noche." }
        ]
      },
      {
        "situation": "Has dicho la versión negable y han sonreído y han dicho algo cálido de vuelta.",
        "prompt": "¿Qué te ha comprado la negabilidad?",
        "options": [
          { "text": "Evitaste el bochorno.", "correct": false, "note": "Un efecto secundario, y la mitad más pequeña. Sobre todo les protegió a ellos de tener que emitir un veredicto al momento." },
          { "text": "Pudieron responder sin tener que declarar nada.", "correct": true, "note": "Es el mecanismo y no una salvaguarda. Los dos podéis averiguar hacia dónde va esto sin que ninguno tenga que ser quien lo dijo primero." },
          { "text": "Nada: habrían respondido de todas formas.", "correct": false, "note": "Una declaración recibe una decisión. Esto recibió una respuesta, que es algo distinto y mucho más útil." },
          { "text": "Mantuvo abiertas tus opciones.", "correct": false, "note": "Así se ve desde fuera. La opción que importa aquí es la suya." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('flirting-moves', 2,
  'Picar, con filo',
  $md$La conversación ligera te dio una regla: pica primero a la situación, y a la persona solo cuando haya permiso. Esa regla se sostiene también aquí. Lo que cambia es que picar deja de ser un extra y se convierte en la jugada.

Picarle a alguien es una afirmación de cercanía: dice *somos el tipo de gente que puede hacer esto*, y esa afirmación es exactamente lo que lo convierte en flirteo y no en conversación. Es también por lo que sale mal cuando es pronto: una afirmación de cercanía no ganada aterriza como presunción.

**La jugada:** pica algo que ellos eligieron, una vez que te hayan picado a ti.

Su pique es el permiso, y es el más claro que hay. Hasta entonces, apunta a la situación como antes.

Después apunta con cuidado. Algo que eligieron — su compromiso con una broma, su gusto por algo, que tengan opiniones sobre un bocadillo — es terreno justo, porque una elección se puede defender y disfrutar. Algo que son — su aspecto, su cuerpo, su trabajo, cualquier cosa que no eligieron — no lo es, y la diferencia entre las dos es todo el riesgo.

Mantenlo pequeño y deja que ganen una. Un pique que hay que ceder no es juego. Si te devuelven el golpe más fuerte, eso es el juego funcionando.$md$,
  $j$[
    {
      "situation": "Acaban de describir su pedido de café extremadamente concreto, después de haberte picado por el tuyo.",
      "line": "Eso no es un pedido, eso es un conjunto de instrucciones.",
      "why": "Dirigido a una elección, evidentemente cariñoso, y les invita a defenderla. Además llegó después de su pique, que es el permiso."
    },
    {
      "situation": "Te pican por cuánto tiempo tardaste en elegir.",
      "line": "Así que me has estado mirando todo el rato.",
      "why": "Devuelve el pique y señala sin ruido que estaban prestando atención. Cálido, negable, y sube la temperatura un escalón."
    },
    {
      "situation": "Quieres picarles y no te han picado a ti.",
      "line": "(pícale a la situación en su lugar, por ahora)",
      "why": "El permiso no ha llegado. Picarle a la sala es el mismo juego sin ninguna presunción, y suele producir el permiso en menos de un minuto."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuándo te has ganado el derecho a picarle a la persona?",
      "options": [
        { "text": "Después de unos veinte minutos.", "correct": false, "note": "El tiempo ayuda y no da permiso. Un montón de conversaciones de veinte minutos se quedan del todo formales." },
        { "text": "En cuanto te hayan picado a ti.", "correct": true, "note": "El permiso más claro que hay, y no cuesta nada esperarlo. Su pique dice que las bromas entre nosotros son seguras, que es lo que necesitabas saber." },
        { "text": "En cuanto vaya bien.", "correct": false, "note": "Que vaya bien no es lo mismo que cercanía. De ahí suele venir la presunción." },
        { "text": "En cuanto les hayas hecho un cumplido.", "correct": false, "note": "Un cumplido es calidez y no permiso, y emparejarlo con un pique se lee de inmediato como técnica." }
      ],
      "explain": "Que te piquen es el permiso para picar. Hasta entonces el objetivo es la situación."
    },
    {
      "prompt": "¿Cuál es el blanco seguro?",
      "options": [
        { "text": "Algo en lo que son buenos.", "correct": false, "note": "Más cerca de un cumplido disfrazado de broma, y normalmente solo consigue un gracias en vez de una devolución." },
        { "text": "Cómo se ven.", "correct": false, "note": "No lo eligieron, no pueden disfrutar defendiéndolo, y es el blanco que convierte un pique en una evaluación." },
        { "text": "Su trabajo.", "correct": false, "note": "Elegido a medias como mucho, y con frecuencia un tema delicado del que no sabes nada." },
        { "text": "Algo que eligieron.", "correct": true, "note": "Una elección se puede defender y disfrutar, que es lo que convierte picarla en un juego. Su gusto, su compromiso con una broma, sus opiniones sobre un bocadillo." }
      ],
      "explain": "Pica una elección, nunca un atributo. Una elección se puede defender; un atributo solo se puede juzgar."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "had_licence", "label": "Tenía el permiso", "description": "Le picó a la persona solo después de que le picaran, y a la situación antes de eso." },
      { "key": "chose_a_choice", "label": "Apuntó a una elección", "description": "Picó algo que eligieron en vez de algo que son." },
      { "key": "kept_it_small", "label": "Lo mantuvo pequeño", "description": "Lo hizo evidentemente cariñoso y fácil de devolver." },
      { "key": "let_them_win", "label": "Les dejó ganar una", "description": "Permitió que el pique volviera en vez de necesitar tener la última palabra." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Juno",
        "role": "alguien con quien te has puesto a hablar en la cola",
        "mood": "De buen humor y disfrutando de esto.",
        "openness": 4,
        "personality": "Juguetón y rápido. Pica pronto, disfruta que le devuelvan el pique sobre algo que eligió, y se enfría de golpe con cualquier cosa sobre su aspecto."
      },
      "sex": "female",
      "name": "Juno",
      "role": "alguien con quien te has puesto a hablar en la cola",
      "mood": "De buen humor y disfrutando de esto.",
      "openness": 4,
      "personality": "Juguetona y rápida. Pica pronto, disfruta que le devuelvan el pique sobre algo que eligió, y se enfría de golpe con cualquier cosa sobre su aspecto."
    },
    "setting": "Una cafetería con cola. Lleváis unos minutos hablando y acaban de picarte por cuánto tardaste en pedir.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Disfruta y escala cualquier pique dirigido a algo que elegiste.",
      "Enfríate de forma notable ante cualquier cosa sobre el aspecto o algo que no elegiste.",
      "Mantén las respuestas cortas y juguetonas."
    ],
    "opening_beat": "«Te has quedado ahí leyendo el panel un buen rato, eh.»",
    "success_looks_like": "La persona devuelve el pique, dirigido a algo que eligió la otra persona."
  }$j$::jsonb,
  'Hoy, devuelve un pique dirigido a algo que eligió la otra persona. No cómo se ven, no su trabajo. Apunta qué picaste y qué te devolvieron.',
  $j${
    "says": "Te has quedado ahí leyendo el panel un buen rato, eh.",
    "model": {
      "line": "Así que me has estado mirando todo el rato.",
      "why": "Devuelve el pique y señala sin ruido que estaban prestando atención. Apunta a algo que hicieron y no a algo que son, y sube la temperatura exactamente un escalón."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["te ves", "guapo", "guapa", "bueno", "buena", "monada", "precioso", "preciosa", "atractivo", "atractiva"], "requirement": "Apunta a algo que eligieron, nunca a cómo se ven" },
      { "kind": "max_words", "n": 20, "requirement": "Mantenlo lo bastante pequeño como para devolverlo" },
      { "kind": "max_sentences", "n": 1, "requirement": "Una línea. Deja que te lo devuelvan." }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('flirting-moves', 3,
  'Halaga la elección, no la cara',
  $md$Esta es la jugada más útil de todo el tema y casi nadie la usa.

Un cumplido sobre el aspecto de alguien es el contenido de su semana. Se lo han dicho desconocidos, gente que quería algo, y gente que lo decía por fórmula, lo que significa que llega ya devaluado y la única respuesta disponible es gracias. Es además lo único que no decidieron ellos.

**La jugada:** halaga algo que eligieron.

Su gusto. Una decisión que tomaron. Cómo acaban de describir algo. El hecho de que claramente les importa un tema que a nadie más en esta mesa le importa. Todo eso es suyo, nada de eso está en su bandeja de entrada, y todo se puede responder, porque una elección tiene una historia detrás y el aspecto no.

Además halaga muchísimo más, lo cual sorprende a la gente. Que te digan que estás guapo es agradable. Que te digan que lo que decidiste fue una buena decisión es que te *vean*, y la diferencia en cómo aterrizan las dos cosas no es sutil.

La prueba es si la respuesta puede ser algo que no sea gracias. Si no puede, has halagado algo que les dieron en vez de algo que hicieron.$md$,
  $j$[
    {
      "situation": "Acaban de explicar por qué se mudaron de ciudad por un trabajo que nadie entendió.",
      "line": "Eso es una decisión mucho más valiente de lo que suena cuando lo dices tan rápido.",
      "why": "Un cumplido a una decisión. No se puede responder solo con gracias: hay una historia pegada y la van a contar."
    },
    {
      "situation": "Tienen un gusto horrible y del todo comprometido con algo.",
      "line": "Me gusta que no te dé ninguna vergüenza eso.",
      "why": "Halaga el compromiso en vez del gusto, que es a la vez más gracioso y más exacto. Además premia exactamente lo que hace que alguien sea buena compañía."
    },
    {
      "situation": "Estás a punto de decirles que están guapos.",
      "line": "(busca algo que decidieron en su lugar)",
      "why": "No porque esté mal, sino porque es el mensaje que ya tienen. Cualquier cosa que eligieron es más rara y aterriza más fuerte."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la prueba de un buen cumplido?",
      "options": [
        { "text": "Si la respuesta puede ser algo que no sea gracias.", "correct": true, "note": "Un cumplido con una historia detrás abre la conversación. Uno sobre algo que les dieron la cierra, porque no hay nada que decir de vuelta." },
        { "text": "Si es concreto.", "correct": false, "note": "Necesario y no suficiente. Un cumplido muy concreto sobre su cara sigue sin poderse responder." },
        { "text": "Si es verdad.", "correct": false, "note": "Se da por hecho en todo momento. Un cumplido falso tiene otro problema, y más grande." },
        { "text": "Si les hace sonreír.", "correct": false, "note": "Casi cualquier cumplido lo hace. Sonreír y tener algo que decir son resultados distintos." }
      ],
      "explain": "Si gracias es la única respuesta disponible, has halagado algo que no eligieron."
    },
    {
      "prompt": "¿Por qué halagar una elección aterriza más fuerte que halagar el aspecto?",
      "options": [
        { "text": "Es más original.", "correct": false, "note": "Lo es, y la originalidad es la mitad más pequeña. Que te reconozcan una decisión es una categoría distinta de agradable." },
        { "text": "Es menos directo.", "correct": false, "note": "A menudo es más directo, porque dice que estabas prestando atención a lo que dijeron y no a cómo se ven." },
        { "text": "Es que te vean en vez de que te miren.", "correct": true, "note": "Uno dice que has notado algo sobre ellos; el otro dice que has notado algo en lo que no tuvieron ninguna parte. La diferencia en cómo aterrizan no es sutil." },
        { "text": "La gente tiene inseguridades con su aspecto.", "correct": false, "note": "A veces, y no es el mecanismo. Esto funciona con gente del todo cómoda con cómo se ve." }
      ],
      "explain": "El aspecto es lo que les dieron. Una elección es lo que hicieron, y que te la reconozcan es más raro."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "a_choice", "label": "Halagó una elección", "description": "Eligió algo que decidieron en vez de algo que les dieron." },
      { "key": "answerable", "label": "Dejó más que un gracias", "description": "Dijo algo con una historia detrás." },
      { "key": "specific", "label": "Fue concreto", "description": "Nombró la cosa real en vez de una cualidad general." },
      { "key": "not_a_line", "label": "No sonó a frase hecha", "description": "Lo dijo como una observación y no como una jugada." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Kit",
        "role": "un amigo de quien te ha invitado",
        "mood": "Animado, a mitad de una historia.",
        "openness": 4,
        "personality": "Modesto y rápido para esquivar con un gracias seco cualquier cosa sobre su aspecto. Se abre del todo cuando alguien se toma en serio una decisión suya."
      },
      "sex": "female",
      "name": "Cleo",
      "role": "una amiga de quien te ha invitado",
      "mood": "Animada, a mitad de una historia.",
      "openness": 4,
      "personality": "Modesta y rápida para esquivar con un gracias seco cualquier cosa sobre su aspecto. Se abre del todo cuando alguien se toma en serio una decisión suya."
    },
    "setting": "La cocina de una fiesta en casa. Acaban de terminar de explicar, con cierta energía, por qué dejaron un trabajo perfectamente bueno para reciclarse en algo completamente distinto.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a cualquier cumplido sobre el aspecto con un gracias seco y un cambio de tema.",
      "Responde a un cumplido sobre la decisión con calidez genuina y más de la historia.",
      "No te alargues más de unas pocas frases."
    ],
    "opening_beat": "«...bueno, todo el mundo pensó que había perdido la cabeza, y sinceramente durante unos seis meses yo también.»",
    "success_looks_like": "La persona halaga la decisión en vez de a la persona, y recibe una historia en vez de un gracias."
  }$j$::jsonb,
  'Hoy, halaga a una persona por algo que eligió en vez de por algo que le dieron. Apunta qué dijiste y si la respuesta fue más que un gracias.',
  $j${
    "says": "...bueno, todo el mundo pensó que había perdido la cabeza, y sinceramente durante unos seis meses yo también.",
    "model": {
      "line": "Eso es una decisión mucho más valiente de lo que suena cuando lo dices tan rápido.",
      "why": "Un cumplido a la decisión y no a la persona. No se puede responder solo con gracias, que es la prueba: hay una historia detrás y la van a contar."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["te ves", "guapo", "guapa", "precioso", "preciosa", "atractivo", "atractiva", "monada", "tus ojos", "tu sonrisa"], "requirement": "Halaga la elección, no la cara" },
      { "kind": "contains_any", "words": ["decisión", "decidiste", "elección", "elegiste", "hiciste eso", "haciendo eso", "valiente", "dejaste", "reciclarte"], "requirement": "Nombra lo que decidieron de verdad" },
      { "kind": "max_words", "n": 25, "requirement": "Menos de veinticinco palabras" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('flirting-moves', 4,
  'Un segundo más',
  $md$El contacto visual es el escalón más barato que existe y el que la gente falla con más fiabilidad en las dos direcciones.

Demasiado poco se lee como desinterés o incomodidad, y es lo que produce casi toda la gente nerviosa: apartar la vista cada vez que la otra persona levanta la suya. Demasiado se lee como intensidad, y es lo que produce la gente cuando ha decidido arreglar el primer problema a la fuerza.

**La jugada:** sostenla un compás más de lo que normalmente la soltarías, y luego aparta la vista tú primero.

El compás es más o menos un segundo. Lo bastante corto como para ser negable y lo bastante largo como para que se note, que es la definición de una buena jugada aquí.

Apartar la vista primero es la mitad que la gente se salta, y es lo que mantiene todo cálido en vez de pesado. Una mirada que termina cuando la termina la otra persona es una pequeña competición. Una mirada que terminas tú, con una sonrisa, es una oferta que se ha hecho y luego se ha soltado, y soltada es lo que la hace cómoda de aceptar.

Hazlo mientras hablan ellos, no mientras hablas tú. La atención sostenida sobre alguien que está hablando es halagadora; la atención sostenida sobre alguien que te está escuchando a ti es mucho.$md$,
  $j$[
    {
      "situation": "Están a mitad de frase y levantan la vista hacia ti.",
      "line": "(sostenla un segundo más de lo normal, y luego aparta la vista con una sonrisa)",
      "why": "Un segundo basta para que se note y es lo bastante corto como para ser nada. Terminarla tú es lo que la convierte de competición en oferta."
    },
    {
      "situation": "Has estado apartando la vista cada vez que levantan la suya.",
      "line": "(quédate un compás la próxima vez)",
      "why": "La costumbre se lee como incomodidad o desinterés, y es lo más común que hace la gente nerviosa con los ojos. Un compás es toda la corrección."
    },
    {
      "situation": "Estás hablando tú y les sostienes la mirada todo el rato.",
      "line": "(suéltala: es mucho para quien escucha)",
      "why": "La atención sostenida halaga a quien habla y pesa sobre quien escucha. El mismo comportamiento se lee completamente distinto según quién esté hablando."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué apartar la vista primero?",
      "options": [
        { "text": "Hace que no sea intensa.", "correct": false, "note": "La duración controla la intensidad. Quién la termina controla si se sintió como una pregunta o como una exigencia." },
        { "text": "Demuestra que no estás desesperado.", "correct": false, "note": "Gestión de imagen, y no es el mecanismo. Esto va sobre lo que les pide a ellos." },
        { "text": "Les da la ocasión de devolver la mirada.", "correct": false, "note": "Un efecto secundario agradable. Lo principal es quitar la presión de responder." },
        { "text": "Convierte una competición en una oferta que se ha soltado.", "correct": true, "note": "Una mirada que termina cuando la termina la otra persona les pone una pequeña presión para decidir. Terminarla tú, con una sonrisa, la convierte en algo ofrecido y soltado, que es cómodo de aceptar." }
      ],
      "explain": "La duración es la señal. Quién la termina decide si la señal fue una oferta o una exigencia."
    },
    {
      "prompt": "¿Cuándo el contacto visual sostenido halaga en vez de pesar?",
      "options": [
        { "text": "Mientras hablas tú.", "correct": false, "note": "Esta es la versión que incomoda a la gente, y es lo que produce quien se esfuerza demasiado." },
        { "text": "Mientras hablan ellos.", "correct": true, "note": "La atención sobre quien habla es el cumplido más claro que hay y no cuesta nada. La misma cantidad dirigida a quien te escucha es mucho que aguantar." },
        { "text": "Durante una pausa.", "correct": false, "note": "Bien en pequeñas dosis, y es donde una mirada sostenida se convierte en un momento, que es un paso más grande que esta lección." },
        { "text": "Es lo mismo en las dos direcciones.", "correct": false, "note": "No es en absoluto lo mismo, y la diferencia es todo el contenido práctico de la lección." }
      ],
      "explain": "Dala mientras hablan. Toma menos mientras hablas tú."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "held_a_beat", "label": "Sostuvo un compás más", "description": "Se quedó un segundo más allá de la caída normal." },
      { "key": "released_it", "label": "Apartó la vista primero", "description": "Terminó la mirada él mismo en vez de esperar a que terminara." },
      { "key": "while_they_spoke", "label": "La dio mientras hablaban", "description": "Dirigió la atención a quien hablaba y no a quien escuchaba." },
      { "key": "warm", "label": "La mantuvo cálida", "description": "La emparejó con una sonrisa en vez de entregarla plana." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Sasha",
        "role": "alguien que has conocido antes esta noche",
        "mood": "Relajado y disfrutando.",
        "openness": 4,
        "personality": "Cómodo y observador. Nota la atención, la devuelve, y se incomoda fácilmente con demasiada mientras está escuchando."
      },
      "sex": "female",
      "name": "Sasha",
      "role": "alguien que has conocido antes esta noche",
      "mood": "Relajada y disfrutando.",
      "openness": 4,
      "personality": "Cómoda y observadora. Nota la atención, la devuelve, y se incomoda fácilmente con demasiada mientras está escuchando."
    },
    "setting": "Un rincón tranquilo de un bar, una hora dentro de una conversación que va bien.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Anímate de forma notable cuando te den atención mientras hablas.",
      "Ponte algo cohibido si te sostienen la atención mientras escuchas.",
      "Describe tus propias miradas y vistazos con llaneza como parte de tus respuestas."
    ],
    "opening_beat": "Están a mitad de una historia y levantan la vista hacia ti entre frases.",
    "success_looks_like": "La persona da atención mientras habla la otra y la suelta ella misma."
  }$j$::jsonb,
  'Hoy, en una conversación, sostén el contacto visual un compás más de lo normal mientras habla la otra persona, y aparta la vista primero. Apunta qué notaste.',
  $j${
    "beats": [
      {
        "situation": "Están a mitad de una historia y levantan la vista hacia ti entre frases.",
        "prompt": "¿Qué haces con los ojos?",
        "options": [
          { "text": "Apartar la vista de inmediato, como siempre.", "correct": false, "note": "La costumbre que tiene casi toda la gente nerviosa, y se lee como incomodidad o desinterés. Un compás es toda la corrección." },
          { "text": "Sostenerla hasta que aparten ellos la vista.", "correct": false, "note": "Ahora es una competición, y tienen que decidir cómo terminarla. La duración está bien; quién la termina es el problema." },
          { "text": "Sostenerla y dejar de sonreír, para que quede claro.", "correct": false, "note": "Intensidad sin calidez. Esta es la versión que produce la gente cuando ha decidido arreglar la timidez a la fuerza." },
          { "text": "Sostenerla un segundo más de lo normal, y luego apartar la vista primero, con una sonrisa.", "correct": true, "note": "Lo bastante largo como para notarse, lo bastante corto como para ser nada, y soltado por ti, lo que la convierte de una pequeña competición en una oferta." }
        ]
      },
      {
        "situation": "Ahora eres tú quien habla, y bastante rato.",
        "prompt": "¿Cuánto contacto visual?",
        "options": [
          { "text": "Menos. La atención sostenida sobre quien escucha es mucho que aguantar.", "correct": true, "note": "El mismo comportamiento se lee completamente distinto según quién esté hablando. Dala con generosidad mientras hablan ellos y toma menos mientras hablas tú." },
          { "text": "La misma: la consistencia se lee como seguridad.", "correct": false, "note": "La consistencia no es la variable. Lo que les pide cambia por completo según quién de los dos esté hablando." },
          { "text": "Más, para retener su atención.", "correct": false, "note": "Esta es la versión que incomoda a la gente, y es exactamente lo que tiende a producir quien se esfuerza demasiado." },
          { "text": "Ninguna: aparta la vista mientras piensas.", "correct": false, "note": "Sobrecorregir hacia el problema original. Menos no es ninguna." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('flirting-moves', 5,
  'El contacto, y sus escalones',
  $md$El contacto es una escalera, y leer entre escalones no es una precaución atornillada a la habilidad. Es la habilidad.

Los escalones son corrientes y van en orden. Incidental: una mano en el antebrazo para rematar algo, y se retira de inmediato. Social: una mano en el hombro mientras los dos os reís, un segundo como mucho. Deliberado: el mismo contacto, sostenido un compás, que ya no es incidental y los dos lo sabéis.

**La jugada:** un escalón cada vez, y lee el escalón antes de subir al siguiente.

Leerlo es sencillo y la gente se lo salta porque está nerviosa. ¿Se quedaron donde estaban, o la distancia aumentó en silencio? ¿Te tocaron de vuelta en algún momento de los siguientes minutos? ¿La conversación siguió a la misma temperatura? Un sí son las tres cosas. **Ninguna respuesta es un no**, no un quizás, y no una invitación a ser más claro.

Dos cosas prácticas. Público, breve, y por encima del codo cubre casi todo buen primer escalón. Y bajar un escalón siempre está disponible y no cuesta nada: si no recibes respuesta, sigue exactamente igual que antes, y no hay nada que ninguno de los dos tenga que gestionar.

Si nunca subes el primer escalón, eso también tiene un coste real. La calidez sin ningún contacto se lee como simpatía durante muchísimo tiempo.$md$,
  $j$[
    {
      "situation": "Los dos os estáis riendo de algo y están de pie cerca.",
      "line": "(mano en la parte alta del brazo un segundo, rematando el chiste, y se retira)",
      "why": "Incidental, breve, público y completamente negable. Es el primer escalón, y la información que produce vale más que otros diez minutos de conversación."
    },
    {
      "situation": "Has subido el primer escalón y no ha vuelto absolutamente nada.",
      "line": "(sigue exactamente igual que antes)",
      "why": "Ninguna respuesta es un no, y la jugada correcta es ser completamente normal. No ha pasado nada que ninguno de los dos tenga que gestionar."
    },
    {
      "situation": "Te han tocado el brazo dos veces en los últimos cinco minutos.",
      "line": "(ese escalón está respondido: puedes subir al siguiente)",
      "why": "Que te toquen de vuelta es el sí más claro que hay. Es también la señal que más probablemente note alguien nervioso y luego decida que se lo imaginó."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Subes el primer escalón y no hay ninguna reacción en absoluto. ¿Qué es eso?",
      "options": [
        { "text": "Neutro: inténtalo otra vez para estar seguro.", "correct": false, "note": "La lectura que convierte un pequeño no en una noche incómoda. La ambigüedad no es una invitación a ser más claro." },
        { "text": "No lo notaron.", "correct": false, "note": "Lo notaron. La gente siempre lo nota, hagan lo que hagan con ello." },
        { "text": "Un no. Sigue exactamente igual que antes.", "correct": true, "note": "Ninguna respuesta es un no y no un quizás. La jugada correcta es ser completamente corriente, lo que no deja nada que ninguno de los dos tenga que gestionar." },
        { "text": "Son tímidos: ve más despacio.", "correct": false, "note": "Puede que sea verdad, y no cambia nada de la siguiente jugada. Más despacio y nada se ven idénticos desde aquí, y solo una de las dos es tuya para elegir." }
      ],
      "explain": "Ninguna respuesta es un no. Bajar un escalón no cuesta nada y no deja nada que explicar."
    },
    {
      "prompt": "¿Cuál es el sí más claro?",
      "options": [
        { "text": "Te tocan de vuelta dentro de los siguientes minutos.", "correct": true, "note": "La señal más fiable que hay, y la que más probablemente note alguien nervioso y luego se convenza de no haber visto." },
        { "text": "No se apartaron.", "correct": false, "note": "Débil. Un montón de gente se queda exactamente donde está por educación y preferiría no estar ahí." },
        { "text": "Se rieron.", "correct": false, "note": "Ya se estaban riendo. Eso fue lo que hizo posible el momento, no lo que lo respondió." },
        { "text": "Siguieron hablando.", "correct": false, "note": "La ausencia de un problema más que la presencia de un sí." }
      ],
      "explain": "Que te toquen de vuelta es la respuesta. Todo lo demás es la ausencia de una objeción."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "first_rung", "label": "Subió un primer escalón", "description": "Hizo un contacto breve, público e incidental en vez de evitarlo del todo." },
      { "key": "read_it", "label": "Leyó la respuesta", "description": "Comprobó qué volvía antes de considerar nada más." },
      { "key": "took_no_for_no", "label": "Trató la ausencia de respuesta como un no", "description": "Bajó un escalón sin convertirlo en un momento." },
      { "key": "one_at_a_time", "label": "Un escalón cada vez", "description": "No se saltó un paso después de una sola señal positiva." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Milo",
        "role": "alguien con quien has estado hablando casi toda la noche",
        "mood": "Pasando una buena noche.",
        "openness": 4,
        "personality": "Cálido y físicamente expresivo cuando está cómodo. Devuelve el contacto sin problema si el primero es breve y bien calculado, y aumenta la distancia en silencio si no lo es."
      },
      "sex": "female",
      "name": "Mira",
      "role": "alguien con quien has estado hablando casi toda la noche",
      "mood": "Pasando una buena noche.",
      "openness": 4,
      "personality": "Cálida y físicamente expresiva cuando está cómoda. Devuelve el contacto sin problema si el primero es breve y bien calculado, y aumenta la distancia en silencio si no lo es."
    },
    "setting": "De pie en el borde de una fiesta, una hora dentro. Lleváis un rato riéndoos de lo mismo y estáis de pie bastante cerca.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Describe tus propias respuestas físicas con llaneza: quedarte quieto, retroceder, tocarle el brazo.",
      "Responde con calidez a un contacto breve e incidental y aumenta la distancia después de cualquier cosa sostenida o repetida demasiado pronto.",
      "Nunca inicies tú el contacto antes que la persona."
    ],
    "opening_beat": "Los dos acabáis de dejar de reíros de lo mismo, y ninguno ha dicho nada todavía.",
    "success_looks_like": "La persona sube un primer escalón breve y lee qué vuelve antes de hacer nada más."
  }$j$::jsonb,
  'Hoy, sube un primer escalón — breve, público, por encima del codo — y luego lee qué vuelve. Apunta qué hiciste y qué pasó en los minutos siguientes.',
  $j${
    "beats": [
      {
        "situation": "Le has puesto una mano en la parte alta del brazo un segundo mientras los dos os reíais. Han seguido hablando y no ha pasado nada más en absoluto.",
        "prompt": "¿Y ahora?",
        "options": [
          { "text": "Intentarlo otra vez pronto, para estar seguro.", "correct": false, "note": "La lectura que convierte un pequeño no en una noche incómoda. La ambigüedad no es una invitación a ser más claro." },
          { "text": "Preguntar si eso estaba bien.", "correct": false, "note": "Bienintencionado, y convierte algo de dos segundos en una conversación sobre sí mismo. Ser normal es más amable." },
          { "text": "Seguir exactamente igual que antes.", "correct": true, "note": "Ninguna respuesta es un no, y ser completamente corriente después no deja nada que ninguno de los dos tenga que gestionar. Bajar un escalón no cuesta nada." },
          { "text": "Suponer que son tímidos e ir más despacio.", "correct": false, "note": "Puede que sea verdad, y no cambia nada. Más despacio y nada se ven idénticos desde aquí." }
        ]
      },
      {
        "situation": "Otra noche. Te han tocado el brazo dos veces en los últimos cinco minutos, y se han quedado cerca.",
        "prompt": "¿Qué te ha dicho eso?",
        "options": [
          { "text": "Nada: hay gente que es simplemente táctil.", "correct": false, "note": "Alguna lo es, y dos veces en cinco minutos hacia una persona no es eso. Este es el rechazo del que trata la última lección de este tema." },
          { "text": "El escalón está respondido, y el siguiente está disponible.", "correct": true, "note": "Que te toquen de vuelta es el sí más claro que hay, y es la señal que más probablemente se note y luego se descarte hablando." },
          { "text": "Ya puedes saltarte pasos.", "correct": false, "note": "Un escalón cada vez, siempre. Un sí en este escalón es un sí en este escalón." },
          { "text": "Quieren que digas algo claro.", "correct": false, "note": "Leer dos toques como una petición de declaración es un salto mucho mayor del que sostienen las pruebas." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('flirting-moves', 6,
  'Darte cuenta de vuelta',
  $md$La habilidad más útil de este tema no es iniciar. Es darte cuenta de que alguien ya te lo está haciendo a ti.

La gente tímida lee esto por debajo casi de forma universal, y la frase que hace el daño es *probablemente solo estaba siendo simpático*. A veces es verdad. Pero se dice con total seguridad sobre situaciones que contienen tres o cuatro señales claras, y quien la dice nunca lo averigua, porque decidir que no era nada significa no hacer nada.

**La jugada:** cuenta las señales, y da por real la tercera.

Las fiables no son sutiles en cuanto las conoces. Se quedan cuando irse era fácil y evidente. Retoman la conversación después de que termine. Te pican. Te tocan primero. Te preguntan por tu vida en vez de por tus opiniones. Recuerdan algo que dijiste hace veinte minutos y lo traen de vuelta.

Una de esas es nada. Tres no es nada, y la respuesta apropiada a tres no es una declaración: es un escalón, ofrecido y soltado, que es todo lo de las cinco lecciones anteriores.

Merece la pena decir la asimetría con claridad. Leer de más y equivocarte te cuesta un minuto incómodo y una salida cálida. Leer de menos y equivocarte te cuesta lo que querías. Esas no son del mismo tamaño, y casi todo el mundo se comporta como si lo fueran.$md$,
  $j$[
    {
      "situation": "Sus amigos se fueron hace veinte minutos y siguen aquí.",
      "line": "(esa es una señal: cuéntala)",
      "why": "Quedarse cuando irse era fácil y esperado es una de las señales más fuertes que hay, y es la que más se explica como educación."
    },
    {
      "situation": "Te han picado dos veces y han traído de vuelta algo que dijiste antes.",
      "line": "(tres señales: ofrece un escalón)",
      "why": "Tres no es una coincidencia. La respuesta correcta no es una declaración: es un paso pequeño, concreto y negable, que es para lo que estaban todas las lecciones anteriores."
    },
    {
      "situation": "Has decidido que solo estaban siendo simpáticos.",
      "line": "(cuéntalas en voz alta: ¿cuántas hubo?)",
      "why": "La frase es una conclusión y no una observación. Contar la convierte de vuelta en algo en lo que puedes equivocarte en una dirección útil."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué la gente lee de menos en vez de leer de más?",
      "options": [
        { "text": "Las señales son genuinamente ambiguas.", "correct": false, "note": "Algunas lo son. Tres juntas no, y ese es el caso al que suele aplicarse la frase." },
        { "text": "Decidir que no era nada significa no averiguar nunca que te equivocaste.", "correct": true, "note": "Leer de menos se autoconfirma. No haces nada, no pasa nada, y la conclusión parece correcta en retrospectiva para siempre." },
        { "text": "Están siendo modestos.", "correct": false, "note": "Parece modestia y funciona como evitación. El resultado es el mismo de cualquier forma." },
        { "text": "Leer de más da vergüenza.", "correct": false, "note": "Lo da, un poco, durante un minuto, que es la asimetría de la que trata la lección." }
      ],
      "explain": "Leer de menos nunca se corrige, que es exactamente por lo que persiste."
    },
    {
      "prompt": "Tres señales. ¿Cuál es la respuesta correcta?",
      "options": [
        { "text": "Decir la cosa clara.", "correct": false, "note": "Un salto demasiado grande desde tres señales, y les quita la salida. Eso pertenece al final del tema siguiente, una vez que es claramente mutuo." },
        { "text": "Esperar una cuarta.", "correct": false, "note": "Puede que no haya, porque también están esperando ellos. Alguien tiene que moverse y bien puede ser quien contó." },
        { "text": "Preguntarles directamente si están interesados.", "correct": false, "note": "Convierte la conversación en el tema de la conversación, lo que la termina salga como salga la respuesta." },
        { "text": "Un escalón, ofrecido y soltado.", "correct": true, "note": "Pequeño, concreto, negable: todo lo de las cinco lecciones anteriores. Tres señales justifican un paso, no una declaración." }
      ],
      "explain": "Tres señales se ganan un escalón. Un escalón no es una declaración."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "counted", "label": "Contó las señales", "description": "Notó lo que estaba pasando de verdad en vez de concluir que no era nada." },
      { "key": "no_dismissal", "label": "No lo explicó fuera", "description": "Se resistió a decidir que solo estaban siendo simpáticos con tres señales presentes." },
      { "key": "responded", "label": "Ofreció un escalón", "description": "Respondió a las señales con un paso pequeño y negable en vez de con nada o con todo." },
      { "key": "right_size", "label": "Le dio el tamaño correcto", "description": "No saltó a una declaración desde tres señales." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Alex",
        "role": "alguien que has conocido al principio de la noche",
        "mood": "Disfrutando, sin ninguna prisa por irse.",
        "openness": 4,
        "personality": "Te ha estado picando toda la noche, ha traído de vuelta dos cosas que dijiste antes, y se ha quedado mucho más allá de cuando le hacía falta. No va a decir nada de esto en voz alta."
      },
      "sex": "female",
      "name": "Alex",
      "role": "alguien que has conocido al principio de la noche",
      "mood": "Disfrutando, sin ninguna prisa por irse.",
      "openness": 4,
      "personality": "Te ha estado picando toda la noche, ha traído de vuelta dos cosas que dijiste antes, y se ha quedado mucho más allá de cuando le hacía falta. No va a decir nada de esto en voz alta."
    },
    "setting": "El final de una noche. Sus amigos se fueron hace media hora y siguen aquí, hablando contigo.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Sigue produciendo señales — picar, quedarte, traer cosas de vuelta — y no declares nunca tu interés con llaneza.",
      "Responde con calidez a un paso pequeño y ponte algo incómodo ante una declaración completa.",
      "Nunca dejes la conversación."
    ],
    "opening_beat": "«Esa es la tercera vez que mencionas ese grupo, por cierto. Voy llevando la cuenta.»",
    "success_looks_like": "La persona lee las señales como reales y responde con un paso pequeño y negable."
  }$j$::jsonb,
  'Hoy, cuenta las señales en una conversación en vez de concluir. Apunta cuántas hubo, y qué hiciste al respecto.',
  $j${
    "says": "Esa es la tercera vez que mencionas ese grupo, por cierto. Voy llevando la cuenta.",
    "model": {
      "line": "Has estado prestando más atención de la que dejas ver.",
      "why": "Responde a tres señales con un escalón en vez de con una declaración. Concreto a lo que acaban de hacer, cálido, y completamente negable si eso es todo lo que quieren que sea."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["me gustas", "me atraes", "te gusto", "estás interesado", "estás interesada", "salgamos", "sal conmigo"], "requirement": "Un escalón, no una declaración" },
      { "kind": "max_words", "n": 20, "requirement": "Menos de veinte palabras: pequeño y soltado" },
      { "kind": "max_sentences", "n": 1, "requirement": "Una línea, ofrecida y luego dejada en paz" }
    ]
  }$j$::jsonb
);
