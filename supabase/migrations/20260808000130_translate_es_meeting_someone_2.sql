-- Spanish: Conocer a alguien, track 2 — Los dos primeros minutos.
--
-- Conventions as migration 129, including the full `partner.alt` sex-swap
-- translation.

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

select pg_temp.es_lesson('first-two-minutes', 1,
  'No te disculpes por estar ahí',
  $md$La disculpa casi nunca está en las palabras. Está en el medio paso hacia atrás, en la entrega apresurada, y en la frase que llega ya explicándose a sí misma.

*Perdona que te moleste. Ya te dejo. Esto probablemente es raro.* Cada una de esas le dice que el acercamiento fue un abuso, y la gente es complaciente: si se lo planteas como un abuso, van a aceptar el planteamiento. Nada de lo que digas después lo deshace, porque les has dicho cómo leer todo esto en las primeras cuatro palabras.

**La jugada:** quédate quieto, habla a tu ritmo normal, y deja que la apertura llegue sin preámbulo.

La velocidad es la señal que nadie nota que está produciendo. Una frase apresurada dice que esperas que te interrumpan, y el arreglo no es la seguridad, es el tempo: puedes decidir decir algo a tu ritmo normal sin importar cómo te sientas al decirlo.

La otra mitad es quedarte donde estás. Soltar una frase mientras ya te estás girando es una disculpa en lenguaje corporal, y se lee con la misma claridad que si la dijeras.

Nada de esto va de parecer atrevido. Va de no añadir una capa de incomodidad que no estaba en la situación.$md$,
  $j$[
    {
      "situation": "Has decidido decirle algo a alguien en un bar.",
      "line": "Vaya nochecita de gente aquí.",
      "why": "Sin preámbulo. El comentario llega solo y se le permite ser lo que es: una cosa corriente que se dice una persona a otra."
    },
    {
      "situation": "Te pillas a punto de abrir con «perdona».",
      "line": "(corta la primera frase y empieza en la segunda)",
      "why": "La disculpa es casi siempre la primera oración. Quitarla suele dejar una apertura perfectamente buena que estaba escondida detrás."
    },
    {
      "situation": "Has dicho tu frase y de inmediato has dado medio paso atrás.",
      "line": "(quédate donde estás)",
      "why": "Retirarte después de hablar les pide que decidan si te llaman de vuelta. Quedarte quieto deja que el comentario sea lo que era."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué cuesta tanto abrir con «perdona que te moleste»?",
      "options": [
        { "text": "Les dice cómo leer el acercamiento, y van a estar de acuerdo.", "correct": true, "note": "Has entregado el planteamiento antes de que se formaran uno propio. La gente es complaciente, y abuso es como lo has llamado tú." },
        { "text": "Suena poco seguro de ti mismo.", "correct": false, "note": "Suena así, y la impresión importa menos que el planteamiento. Alguien perfectamente seguro diciéndolo conseguiría el mismo resultado." },
        { "text": "Hace perder el tiempo.", "correct": false, "note": "Cuatro palabras. El coste está en lo que hacen las palabras, no en lo que quitan." },
        { "text": "Es un tópico.", "correct": false, "note": "Lo es, y una disculpa nueva falla igual." }
      ],
      "explain": "No hay forma de recuperarte de decirle a alguien que la conversación es un abuso. No le ofrezcas el planteamiento."
    },
    {
      "prompt": "¿Qué disculpa es más difícil de notar que estás haciendo?",
      "options": [
        { "text": "Decir «perdona».", "correct": false, "note": "La más obvia, y por tanto la más fácil de pillar y quitar." },
        { "text": "Hablar más rápido de lo normal.", "correct": true, "note": "Es invisible desde dentro y completamente audible desde fuera. Una frase apresurada dice que esperas que te corten, lo que invita a que te corten." },
        { "text": "Quedarte demasiado lejos.", "correct": false, "note": "Visible en cuanto lo buscas, y más fácil de corregir que el tempo." },
        { "text": "Explicar por qué les estás hablando.", "correct": false, "note": "También común, también audible para ti mientras lo haces. La velocidad es la que corre por debajo de todo lo demás." }
      ],
      "explain": "El tempo es la disculpa que no te oyes hacer a ti mismo. La puedes decidir de antemano."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_preface", "label": "Sin preámbulo", "description": "Abrió sin disculpa, sin explicación y sin aviso." },
      { "key": "tempo", "label": "Ritmo normal", "description": "Lo dijo a la velocidad a la que diría cualquier otra cosa." },
      { "key": "stayed_put", "label": "Se quedó donde estaba", "description": "No se retiró físicamente después de hablar." },
      { "key": "let_it_stand", "label": "Lo dejó estar", "description": "Permitió una pausa en vez de rellenarla con justificación." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Tavish",
        "role": "alguien esperando en el mismo bar",
        "mood": "De salida con amigos, ahora mismo solo en la barra.",
        "openness": 4,
        "personality": "Simpático y rápido para seguir el tono. Trata un acercamiento con disculpa como una interrupción y uno corriente como algo corriente."
      },
      "sex": "female",
      "name": "Talise",
      "role": "alguien esperando en el mismo bar",
      "mood": "De salida con amigos, ahora mismo sola en la barra.",
      "openness": 4,
      "personality": "Simpática y rápida para seguir el tono. Trata un acercamiento con disculpa como una interrupción y uno corriente como algo corriente."
    },
    "setting": "Un bar concurrido un viernes. Has acabado al lado de alguien en la barra, los dos esperando a que os atiendan.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si la persona se disculpa o explica por qué te está hablando, responde con educación y brevedad y gírate un poco de vuelta a la barra.",
      "Si abre con llaneza, responde con calidez y normalidad.",
      "Nunca abras tú la conversación."
    ],
    "opening_beat": "El camarero atiende a otra persona primero. Os quedáis los dos esperando.",
    "success_looks_like": "La persona abre sin ningún preámbulo y no se explica después."
  }$j$::jsonb,
  'Hoy, abre una conversación sin ningún preámbulo. Sin perdón, sin explicación, sin aviso. Apunta qué cortaste y si te notaste acelerando.',
  $j${
    "says": "(el camarero atiende a otra persona primero, y os quedáis los dos esperando)",
    "model": {
      "line": "Vaya nochecita de gente aquí.",
      "why": "Seis palabras sin nada delante. Sin perdón, sin explicación, sin aviso: se le permite ser una cosa corriente que se dice una persona a otra."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["perdona", "perdón", "disculpa", "esto es raro", "ya te dejo", "no quiero", "espero que no te importe", "pregunta random", "una pregunta rápida"], "requirement": "Sin preámbulo, sin disculpa, sin aviso" },
      { "kind": "max_words", "n": 15, "requirement": "Lo bastante corto como para llegar a ritmo normal" },
      { "kind": "max_sentences", "n": 1, "requirement": "Una línea. Déjala estar." }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('first-two-minutes', 2,
  'Los nombres, pronto',
  $md$Intercambiar nombres es el cambio estructural más barato que hay en los dos primeros minutos, y casi todo el mundo lo deja para cuando ya resulta incómodo.

Antes de los nombres, eres un desconocido hablando con alguien. Después de ellos, dos personas están teniendo una conversación. No ha cambiado nada más y la categoría sí. Además le da algo que hacer con el intercambio después: una conversación con un nombre pegado es una a la que se puede hacer referencia, y una que se puede retomar si os volvéis a ver.

**La jugada:** da tu nombre sobre la marca de los dos minutos, y luego pregunta el suyo.

Darlo primero es lo que lo hace fácil. *Soy Sam, por cierto* es una oferta pequeña que no le cuesta nada aceptar, donde *¿cómo te llamas?* a secas es una petición de alguien que todavía no ha dado nada.

Déjalo mucho más tiempo y se convierte en un momento. A los diez minutos, presentarte es un pequeño acontecimiento que interrumpe de lo que sea que estuvierais hablando; a los dos, es puntuación. Ese es todo el motivo del momento.

Si lo consigues y lo pierdes, que pasa, pregunta otra vez de inmediato. Preguntarlo en el minuto tres no es nada. Preguntarlo en el minuto veinte es una confesión.$md$,
  $j$[
    {
      "situation": "Dos minutos dentro de una conversación que va bien.",
      "line": "Soy Ravi, por cierto.",
      "why": "Dado en vez de pedido, dejado caer en vez de anunciado. Casi nadie deja de devolver el suyo."
    },
    {
      "situation": "Lleváis diez minutos hablando y nunca habéis intercambiado nombres.",
      "line": "Hemos hecho esto de forma completamente anónima. Soy Ravi.",
      "why": "Nombrar el retraso con ligereza es mejor que fingir que no es tarde. Convierte el arreglo en algo gracioso en vez de incómodo."
    },
    {
      "situation": "Han dicho su nombre y ya se te ha ido.",
      "line": "Perdona, ¿me lo repites?",
      "why": "De inmediato, y no cuesta nada. La alternativa son veinte minutos construyendo frases que evitan necesitarlo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué dar tu nombre en vez de pedir el suyo?",
      "options": [
        { "text": "Es más educado.", "correct": false, "note": "Las dos cosas lo son. La diferencia es lo que le pide a la otra persona." },
        { "text": "Evita que se te olvide el suyo.", "correct": false, "note": "Si acaso hace más probable que se te olvide, ya que estás pensando en tu propia frase." },
        { "text": "Una oferta es más fácil de aceptar que una petición de responder.", "correct": true, "note": "Dar primero hace que devolverlo sea automático y opcional a la vez. Preguntar en frío es una pequeña exigencia de alguien que no ha ofrecido nada." },
        { "text": "Suena más seguro.", "correct": false, "note": "Un efecto secundario. El mecanismo es que no tienen que hacer nada con ello." }
      ],
      "explain": "Da primero. Convierte una petición en una oferta, y las ofertas son fáciles."
    },
    {
      "prompt": "¿Por qué se vuelve más difícil cuanto más lo dejas?",
      "options": [
        { "text": "Habrán decidido que no estás interesado.", "correct": false, "note": "Casi nadie lo está rastreando de forma consciente. El coste es lo incómodo del arreglo y no una señal que hayas mandado." },
        { "text": "Se te habrá olvidado.", "correct": false, "note": "Cierto, y es la causa y no el coste." },
        { "text": "Parece que lo estabas evitando.", "correct": false, "note": "Rara vez se lee así. Se lee como dos personas a las que sencillamente no les dio tiempo, que es por lo que nombrarlo con ligereza funciona." },
        { "text": "A los dos minutos es puntuación; a los veinte, es un acontecimiento.", "correct": true, "note": "Las presentaciones tardías interrumpen de lo que estuvierais hablando y llaman la atención sobre el hecho de que habéis llegado tan lejos sin una." }
      ],
      "explain": "Dos minutos es puntuación. Veinte minutos es un momento que ahora tienes que gestionar."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "gave_first", "label": "Dio su nombre primero", "description": "Ofreció en vez de pedir." },
      { "key": "timing", "label": "Lo hizo pronto", "description": "Sobre los dos minutos, antes de que se convirtiera en un acontecimiento." },
      { "key": "lightly", "label": "Lo dejó caer", "description": "Lo hizo puntuación en vez de un anuncio." },
      { "key": "recovered", "label": "Volvió a preguntar si se le perdió", "description": "Donde el nombre se le fue, preguntó de inmediato en vez de esquivarlo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Otto",
        "role": "alguien con quien llevas dos minutos hablando",
        "mood": "Disfrutando de la noche.",
        "openness": 4,
        "personality": "Cálido y fácil. Devuelve un nombre de inmediato si se lo ofrecen y no lo ofrece él primero."
      },
      "sex": "female",
      "name": "Odette",
      "role": "alguien con quien llevas dos minutos hablando",
      "mood": "Disfrutando de la noche.",
      "openness": 4,
      "personality": "Cálida y fácil. Devuelve un nombre de inmediato si se lo ofrecen y no lo ofrece ella primero."
    },
    "setting": "La inauguración de una galería. Llevas un par de minutos hablando con alguien sobre la sala y va bien.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Devuelve tu nombre de inmediato y con calidez si te ofrecen el suyo.",
      "Nunca te presentes tú primero.",
      "Mantén las respuestas cortas."
    ],
    "opening_beat": "Hay un hueco natural después de que terminen una idea sobre la sala.",
    "success_looks_like": "La persona da su nombre de pasada y recibe uno de vuelta."
  }$j$::jsonb,
  'Hoy, en una conversación, da tu nombre sobre la marca de los dos minutos sin que te lo pidan. Apunta si te dieron uno de vuelta y qué pasó con la conversación después.',
  $j${
    "says": "(terminan una idea sobre la sala, y hay un hueco natural)",
    "model": {
      "line": "Soy Ravi, por cierto.",
      "why": "Dado en vez de pedido, y dejado caer en vez de anunciado. El «por cierto» hace todo el trabajo de convertirlo en puntuación."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Da el tuyo primero" },
      { "kind": "no_question", "requirement": "Ofrécelo, no pidas el suyo" },
      { "kind": "max_words", "n": 12, "requirement": "Menos de doce palabras: puntuación, no un anuncio" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('first-two-minutes', 3,
  'Dos minutos, no diez',
  $md$La gente intenta ser interesante, y ser interesante es esforzado, se nota, y no es lo que se está evaluando.

En los dos primeros minutos, la otra persona está respondiendo a una pregunta, y no es si eres impresionante. Es si esto es agradable. Agradable es un listón mucho más bajo, es muchísimo más fácil de superar, y es lo único que decide si hay un tercer minuto.

**La jugada:** apunta a ser agradable durante dos minutos en vez de interesante durante diez.

La diferencia práctica está en a qué echas mano. Intentar ser interesante produce historias, opiniones y material: cosas que exigen que la otra persona se siente a recibirlas. Intentar ser agradable produce intercambios cortos, preguntas fáciles y espacio, que es de lo que están hechos de verdad los dos primeros minutos.

Además elimina lo que hace que acercarse dé miedo. Ser interesante a demanda es genuinamente difícil y puede que no lo consigas. Ser agradable durante ciento veinte segundos es algo que has hecho miles de veces, incluida esta misma mañana, con un compañero, sobre nada.

Apuntar bajo no es conformarse. Es elegir el objetivo que se está puntuando.$md$,
  $j$[
    {
      "situation": "Has abierto y notas que echas mano de algo impresionante.",
      "line": "(pregúntales algo pequeño en su lugar)",
      "why": "El impulso hacia el material es el instinto que hay que anular. Una pregunta pequeña hace el trabajo que intentaba hacer la historia, con una fracción del riesgo."
    },
    {
      "situation": "Noventa segundos dentro y ha sido del todo anodino.",
      "line": "(esto va bien)",
      "why": "Anodino y cálido es el objetivo. Dos minutos de algo corriente son un éxito y se sienten como nada desde dentro, que es por lo que la gente lo abandona demasiado pronto."
    },
    {
      "situation": "Acabas de contar una historia de dos minutos y han dicho cuatro palabras.",
      "line": "(devuélveselo, y que el siguiente sea corto)",
      "why": "Un turno largo pronto los convierte en público. El público es educado y no se convierte en una conversación."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué está decidiendo de verdad la otra persona en los dos primeros minutos?",
      "options": [
        { "text": "Si esto es agradable.", "correct": true, "note": "Un listón muchísimo más bajo que interesante, y el único que decide si hay un tercer minuto. Nadie ha terminado nunca un buen intercambio porque no fuera impresionante." },
        { "text": "Si eres interesante.", "correct": false, "note": "Esto es lo que cree quien se acerca que se está evaluando, y apuntar a ello produce una conversación esforzada." },
        { "text": "Si les resultas atractivo.", "correct": false, "note": "En buena parte ya está decidido antes de que hables, y es mucho menos decisivo para los siguientes dos minutos que si hablar contigo es fácil." },
        { "text": "Si eres seguro.", "correct": false, "note": "Una lectura real y casi instantánea, y se responde por cómo te colocas, no por lo que dices." }
      ],
      "explain": "Agradable es el listón. Es más bajo, es lo que se puntúa, y ya lo superaste esta mañana con un compañero."
    },
    {
      "prompt": "¿Qué produce de verdad apuntar a interesante?",
      "options": [
        { "text": "Una impresión mejor.", "correct": false, "note": "A veces, y a un coste que lo supera tan pronto. Ser impresionante se nota como esfuerzo." },
        { "text": "Turnos largos que los convierten en público.", "correct": true, "note": "Historias, opiniones y material exigen todos que alguien se siente a recibirlos. El público es educado, y educado es donde van a morir las conversaciones." },
        { "text": "Nada: funciona bien.", "correct": false, "note": "Funciona para la gente que es naturalmente muy buena en ello, que no es para quien es esta lección." },
        { "text": "Nerviosismo.", "correct": false, "note": "Lo produce, y eso viene después. El problema estructural es lo que le hace a la forma de la conversación." }
      ],
      "explain": "Interesante produce monólogo. Agradable produce intercambio, y de eso está hecha una conversación."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "aimed_low", "label": "Apuntó a agradable", "description": "Fue por la facilidad en vez de por el impacto." },
      { "key": "short_turns", "label": "Mantuvo cortos los turnos", "description": "Evitó las historias largas en los dos primeros minutos." },
      { "key": "asked_small", "label": "Preguntó algo pequeño", "description": "Usó preguntas fáciles en vez de material." },
      { "key": "let_it_be_ordinary", "label": "Dejó que fuera corriente", "description": "No abandonó un intercambio por ser anodino." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Sunil",
        "role": "alguien en la misma mesa comunal",
        "mood": "Trabajando, sin ninguna urgencia.",
        "openness": 4,
        "personality": "Agradable y sin prisa. Recibe con calidez los intercambios cortos y se convierte en público si le hablan sin parar."
      },
      "sex": "female",
      "name": "Sunniva",
      "role": "alguien en la misma mesa comunal",
      "mood": "Trabajando, sin ninguna urgencia.",
      "openness": 4,
      "personality": "Agradable y sin prisa. Recibe con calidez los intercambios cortos y se convierte en público si le hablan sin parar."
    },
    "setting": "Una cafetería con mesas comunales. Has intercambiado un comentario con alguien de la misma mesa y ha caído bien.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Ponte callado y educado si te hablan sin parar durante más de unas pocas frases.",
      "Métete con calidez en los intercambios cortos y las preguntas pequeñas.",
      "No te alargues más de una o dos frases."
    ],
    "opening_beat": "Se ríen del comentario y vuelven al portátil, pero no de inmediato.",
    "success_looks_like": "La persona lo mantiene pequeño y cálido durante dos minutos en vez de echar mano de material."
  }$j$::jsonb,
  'Hoy, mantén una conversación en dos minutos deliberadamente corrientes. Sin historias, sin opiniones que merezcan la pena. Apunta cómo se sintió y cómo fue.',
  $j${
    "beats": [
      {
        "situation": "Noventa segundos dentro. Ha sido del todo anodino: el café, la mesa, la lluvia. Nadie ha dicho nada memorable.",
        "prompt": "¿Cómo va?",
        "options": [
          { "text": "Mal: no ha pasado nada.", "correct": false, "note": "La lectura que hace que alguien eche mano de material. Que no pase nada es el plan." },
          { "text": "Bien, pero pronto necesita una historia.", "correct": false, "note": "El impulso, retrasado un minuto. Una historia ahora los convierte en público." },
          { "text": "Bien. Anodino y cálido es el objetivo.", "correct": true, "note": "A esto se parecen desde dentro los primeros dos minutos con éxito, que es a casi nada. La gente lo abandona aquí porque esperaba que se sintiera como más." },
          { "text": "Imposible de saber.", "correct": false, "note": "Bastante fácil de saber: siguen ahí de pie y siguen respondiendo." }
        ]
      },
      {
        "situation": "Acabas de contar una buena historia. Ha llevado unos dos minutos y han dicho cuatro palabras al final.",
        "prompt": "¿Qué ha pasado?",
        "options": [
          { "text": "La historia no era lo bastante buena.", "correct": false, "note": "La longitud es el problema y no la calidad. Una historia mejor de dos minutos tiene el mismo efecto." },
          { "text": "Son tímidos.", "correct": false, "note": "Posiblemente, y no han tenido ninguna apertura. Cuatro palabras es lo disponible al final del turno de otra persona." },
          { "text": "No están interesados.", "correct": false, "note": "Demasiado pronto para leerlo, y les atribuye algo que causaste tú." },
          { "text": "Los has convertido en público, y el público es educado.", "correct": true, "note": "Un turno largo tan pronto convierte una conversación en una actuación. Las cuatro palabras no son desinterés, son el papel que les diste." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('first-two-minutes', 4,
  'Cuando se para a los noventa segundos',
  $md$Se va a parar. Eso no es una señal de nada, y lo que hagas en los tres segundos siguientes decide si se recupera.

El instinto es escarbar: hacer otra pregunta sobre el tema que se acaba de agotar. Es la dirección equivocada, porque que el tema se agote es exactamente la información que te acaban de dar. Una segunda pregunta sobre él convierte el vacío en algo de los dos.

**La jugada:** vuelve hacia la sala en vez de profundizar en el tema.

La sala es lo que todavía tenéis en común. La cola, el grupo, el tiempo que os ha metido a los dos aquí, que el café esté tardando muchísimo. Es donde empezó la conversación y siempre está disponible, que es lo que la convierte en un suelo y no en un tema.

Lo otro es dejar que la pausa dure dos segundos en vez de rellenarla al instante. Un hueco que se rellena a toda velocidad se lee como pánico, y el pánico se nota muchísimo más que el silencio. Dos segundos no son nada para ellos y se sienten como un minuto para ti, y aprender ese hueco es trabajo de verdad.

Si se para dos veces también con la sala, esa es otra señal, y se trata en el tema siguiente.$md$,
  $j$[
    {
      "situation": "El tema que abriste se acaba de agotar.",
      "line": "Tampoco han llamado todavía a los taxis.",
      "why": "Hacia fuera, a la sala. No es ingenioso y no hace falta que lo sea: es un suelo en el que siempre puedes apoyarte."
    },
    {
      "situation": "Hay un hueco de dos segundos y estás a punto de rellenarlo.",
      "line": "(deja que sean dos segundos)",
      "why": "El hueco es muchísimo más corto para ellos que para ti. Rellenarlo a toda velocidad es la señal, no el silencio."
    },
    {
      "situation": "Has hecho una segunda pregunta sobre un tema que claramente había terminado.",
      "line": "(eso es escarbar; ve hacia fuera la próxima vez)",
      "why": "Un tema muerto preguntado dos veces está muerto dos veces. El agotamiento era la información."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "El tema se agota a los noventa segundos. ¿Cuál es la recuperación?",
      "options": [
        { "text": "Otra pregunta sobre el mismo tema.", "correct": false, "note": "Escarbar. Que el tema terminara era la información, y volver a preguntar convierte el vacío en un proyecto conjunto." },
        { "text": "Una historia propia para llenar el espacio.", "correct": false, "note": "Los convierte en público justo en el momento en que la conversación necesita un intercambio." },
        { "text": "Algo sobre la sala en la que estáis los dos.", "correct": true, "note": "La sala es lo único que sigue compartido, no necesita preparación, y es donde empezó la conversación. Un suelo en vez de un tema." },
        { "text": "Preguntar a qué se dedican.", "correct": false, "note": "Disponible, y es un salto desde frío. Funciona, y cuesta más que la sala." }
      ],
      "explain": "Hacia fuera, a la sala, no hacia abajo, dentro del tema."
    },
    {
      "prompt": "¿Cuánto tiene que durar una pausa antes de que sea incómoda de verdad?",
      "options": [
        { "text": "Un segundo más o menos.", "correct": false, "note": "Esta es la duración sentida y no la real, y actuar sobre ella produce las prisas que son el problema de verdad." },
        { "text": "Depende de cómo vaya.", "correct": false, "note": "Cierto en los márgenes, y no cambia la respuesta práctica, que es que te puedes permitir dos segundos en cualquier sitio." },
        { "text": "Cualquier pausa está mal.", "correct": false, "note": "Las pausas son corrientes en toda conversación que tienes con gente que conoces. Solo se sienten peligrosas con desconocidos." },
        { "text": "Más de lo que crees: dos segundos no son nada.", "correct": true, "note": "El silencio va a otra velocidad para quien se preocupa por él. Rellenar un hueco de dos segundos a toda velocidad se nota muchísimo más que el hueco." }
      ],
      "explain": "El silencio corre a otra velocidad para quien se preocupa por él."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "went_outward", "label": "Fue hacia fuera", "description": "Se recuperó con la sala en vez de escarbar en el tema muerto." },
      { "key": "let_the_gap", "label": "Dejó estar el hueco", "description": "Permitió dos segundos en vez de rellenarlos al instante." },
      { "key": "no_panic", "label": "No aceleró", "description": "Mantuvo el ritmo cuando se paró." },
      { "key": "read_the_second", "label": "Leyó una segunda parada", "description": "Reconoció que pararse dos veces es información y no un fracaso personal." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Bertie",
        "role": "otro invitado, de la otra rama de la familia",
        "mood": "Disfrutándolo, algo suelto.",
        "openness": 3,
        "personality": "Perfectamente simpático y no un iniciador natural de conversaciones. Recoge cualquier cosa que le ofrezcan y no aporta un tema nuevo."
      },
      "sex": "female",
      "name": "Bettina",
      "role": "otra invitada, de la otra rama de la familia",
      "mood": "Disfrutándolo, algo suelta.",
      "openness": 3,
      "personality": "Perfectamente simpática y no una iniciadora natural de conversaciones. Recoge cualquier cosa que le ofrezcan y no aporta un tema nuevo."
    },
    "setting": "El convite de una boda, en el hueco entre la comida y el baile. Llevas unos noventa segundos hablando con alguien y el tema se acaba de agotar.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a una segunda pregunta sobre el tema muerto con brevedad y sin gracia.",
      "Recoge con calidez cualquier cosa sobre la sala y añade algo.",
      "Nunca introduzcas tú un tema nuevo."
    ],
    "opening_beat": "Terminan una frase sobre la comida, y ninguno de los dos dice nada durante un momento.",
    "success_looks_like": "La persona se recupera con la sala en vez de hacer una segunda pregunta sobre la comida."
  }$j$::jsonb,
  'Hoy, deja que una conversación se pare y recupérala con la sala en vez de con el tema. Cuenta la pausa antes de hablar. Apunta cuánto duró de verdad.',
  $j${
    "says": "(terminan una frase sobre la comida, y ninguno de los dos dice nada durante un momento)",
    "model": {
      "line": "Tampoco han llamado todavía a los taxis.",
      "why": "Hacia fuera, a la sala, en vez de otra vez dentro de la comida. No es ingenioso, y no hace falta que lo sea: la sala es un suelo en el que siempre puedes apoyarte."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["comida", "cena", "primero", "postre", "plato", "comer"], "requirement": "No escarbes en el tema que acaba de terminar" },
      { "kind": "max_words", "n": 16, "requirement": "Menos de dieciséis palabras" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('first-two-minutes', 5,
  'Llegar al segundo tema',
  $md$Un intercambio se convierte en una conversación en el momento en que sobrevive a su primer cambio de tema, y esa transición es la que merece la pena hacer a propósito.

Todo hasta ahí ha sido sobre la sala: la cola, el grupo, el tiempo. Eso es un suelo, y los suelos no van a ningún sitio. El segundo tema es el primero que va sobre una persona, y llegar ahí es lo que separa noventa segundos agradables de algo que continúa.

**La jugada:** coge algo que dijeron y pregunta por la persona que hay detrás, una vez.

Mencionaron que venían directos del trabajo. Dijeron que nunca vienen a estas cosas. Dijeron que el grupo es de un amigo. Cada una de esas es una puerta, y se abre porque ellos la pusieron ahí: un detalle ofrecido es un detalle del que alguien estaba dispuesto a hablar.

Una vez, eso sí. El segundo tema es un escalón, no una escalera entera, y el error en la otra dirección es tratar una transición conseguida como permiso para interrogar. Una pregunta sobre ellos, y luego algo tuyo, y ahora hay dos personas dentro.

Si no han ofrecido nada, pregunta por la sala de una forma que solo ellos puedan responder: cómo han acabado aquí en vez de qué opinan de ella.$md$,
  $j$[
    {
      "situation": "Mencionan de pasada que vienen directos del trabajo.",
      "line": "Venir directo del trabajo es una forma dura de llegar a un concierto.",
      "why": "No es una pregunta, y abre la puerta igualmente. Recoge el detalle ofrecido y les invita a decir más sin exigirlo."
    },
    {
      "situation": "Dijeron que normalmente no vienen a estas cosas.",
      "line": "¿Y qué te ha sacado esta noche, entonces?",
      "why": "Sus propias palabras, convertidas en la única pregunta que solo ellos pueden responder. Es la transición más limpia disponible y te la han entregado."
    },
    {
      "situation": "No han ofrecido nada y la sala ya se ha agotado.",
      "line": "¿Cómo conoces a la gente de aquí?",
      "why": "Sobre ellos y no sobre la sala, y no la puede responder nadie más. Donde no se ha ofrecido nada, esta es la puerta que construyes."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hace de un detalle ofrecido la mejor puerta?",
      "options": [
        { "text": "Eligieron decirlo, así que están dispuestos a hablar de ello.", "correct": true, "note": "Nadie ofrece un detalle que quiere que se deje en paz. Recogerlo es aceptar una oferta y no hacer una petición." },
        { "text": "Demuestra que estabas escuchando.", "correct": false, "note": "Lo demuestra, y ese es el beneficio menor. El mayor es que el tema ya está preaprobado." },
        { "text": "Es más fácil que pensar en algo.", "correct": false, "note": "Cierto y no viene al caso. La facilidad es por lo que la gente lo usa; el consentimiento es por lo que funciona." },
        { "text": "Mantiene la conversación en sus intereses.", "correct": false, "note": "No necesariamente sus intereses, solo algo que estaban contentos de mencionar." }
      ],
      "explain": "Un detalle ofrecido es un tema con el que ya han estado de acuerdo. Cógelo."
    },
    {
      "prompt": "Has hecho la transición y han respondido con calidez. ¿Y ahora?",
      "options": [
        { "text": "Hacer una repregunta mientras va bien.", "correct": false, "note": "El instinto, y es la tercera pregunta seguida de alguien que no ha ofrecido nada de vuelta." },
        { "text": "Poner algo tuyo antes de volver a preguntar.", "correct": true, "note": "Dos personas o un interrogatorio, y esta es la bifurcación. Una transición conseguida no es permiso para seguir preguntando." },
        { "text": "Volver a la sala, para mantenerlo ligero.", "correct": false, "note": "Retirarse de una transición conseguida. La sala era el suelo que acabas de dejar." },
        { "text": "Cambiar a un tercer tema.", "correct": false, "note": "Nada se ha agotado. Cambiar de tema con uno todavía vivo es inquietud y no habilidad." }
      ],
      "explain": "Cruza la transición, y luego da algo. Si no, has entrado en la conversación a base de interrogar."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "used_theirs", "label": "Usó algo que ofrecieron", "description": "Construyó la transición sobre un detalle que dieron en vez de sobre un tema nuevo." },
      { "key": "about_them", "label": "Preguntó por la persona", "description": "Pasó de la sala a algo que solo ellos podían responder." },
      { "key": "once", "label": "Preguntó una vez", "description": "No convirtió una transición conseguida en una ronda de preguntas." },
      { "key": "gave_back", "label": "Puso algo suyo", "description": "Ofreció algo propio después de que aterrizara la transición." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Mariano",
        "role": "alguien de pie cerca de ti entre actuaciones",
        "mood": "Cansado y contento de haber salido.",
        "openness": 4,
        "personality": "Se abre con facilidad cuando le preguntan por algo que él mismo planteó, y se mantiene educado y breve si le interrogan."
      },
      "sex": "female",
      "name": "Marisol",
      "role": "alguien de pie cerca de ti entre actuaciones",
      "mood": "Cansada y contenta de haber salido.",
      "openness": 4,
      "personality": "Se abre con facilidad cuando le preguntan por algo que ella misma planteó, y se mantiene educada y breve si la interrogan."
    },
    "setting": "Un concierto pequeño, entre actuaciones. Lleváis un par de minutos hablando del telonero y acaban de mencionar que vinieron directos del trabajo.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Ábrete con calidez si te preguntan por algo que tú mismo planteaste.",
      "Ponte breve y educado si te hacen tres preguntas sin ofrecer nada de vuelta.",
      "Nunca cambies tú de tema."
    ],
    "opening_beat": "«Perdona, vengo directo del trabajo, todavía no estoy del todo aquí.»",
    "success_looks_like": "La persona recoge el detalle ofrecido y luego pone algo suyo."
  }$j$::jsonb,
  'Hoy, lleva una conversación a través de su primer cambio de tema usando algo que te ofrecieron. Luego pon algo tuyo antes de preguntar nada más. Apunta el detalle que usaste.',
  $j${
    "says": "Perdona, vengo directo del trabajo, todavía no estoy del todo aquí.",
    "model": {
      "line": "Venir directo del trabajo es una forma dura de llegar a un concierto.",
      "why": "Recoge el detalle que ofrecieron y lo abre sin exigir nada. Un detalle que alguien ofrece es un tema con el que ya han estado de acuerdo."
    },
    "checks": [
      { "kind": "echoes_any", "words": ["trabajo", "directo", "aquí"], "requirement": "Usa lo que acaban de ofrecer" },
      { "kind": "max_questions", "n": 1, "requirement": "Una vez. Esto es un escalón, no una escalera." },
      { "kind": "max_words", "n": 20, "requirement": "Menos de veinte palabras" }
    ]
  }$j$::jsonb
);
