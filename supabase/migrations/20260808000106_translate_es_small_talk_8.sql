-- Spanish: Small talk, track 7 — Broma y humor.
--
-- The only track so far where the examples are authored rather than
-- translated, and the reason is worth stating plainly: a joke that has been
-- carried across word by word usually is not funny any more, and a lesson that
-- teaches a comic mechanism and then demonstrates it with something flat has
-- disproved itself in its own examples.
--
-- So the mechanisms are translated and the jokes are new. Playful mislabelling
-- keeps the gap between the size of the thing and the size of the word;
-- "básicamente una atleta olímpica" for having run one marathon is the same
-- move as the English, built in Spanish. Mock stakes keep the fake-gravity
-- mismatch, and the pineapple-on-pizza argument survives intact because it is
-- as reliably trivial in Spanish as in English.
--
-- One example changed subject entirely. The English mock-stakes lesson warns
-- against football teams because the fake rivalry is real for some people —
-- which is more true in Spanish, not less, so it stays as the warning and the
-- worked examples stay well away from it.
--
-- Lesson 4 is scene mode and carries no rehearsal spec.

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

select pg_temp.es_lesson('banter', 1,
  'Bromea primero sobre la situación',
  $md$Bromear es una afirmación sobre la cercanía. Meterse con alguien dice *somos de los que pueden hacer esto*, y si eso todavía no es verdad, el chiste cae como una pequeña invasión.

La versión segura es apuntar a la situación en la que estáis los dos y no a la persona. La cola, el local, el tiempo, la dinámica de grupo obligatoria. Nadie tiene que defender la situación, así que nadie puede salir herido del chiste, y los dos os lleváis el gusto de estar del mismo lado de algo.

**La jugada:** bromea sobre la cosa en la que estáis los dos metidos antes de bromear sobre ellos.

Una vez que alguien se ha reído contigo de una circunstancia compartida, has establecido que los chistes entre vosotros son seguros. Esa es la licencia. Meterse con la persona viene después, nunca en lugar de eso.

Quien se equivoca en esto no es antipático. Simplemente va pronto.$md$,
  $j$[
    {
      "situation": "Estáis los dos en una jornada de formación de día entero con una agenda agresiva.",
      "line": "Hay una franja aquí que se llama Dinamización. A las cinco menos diez.",
      "why": "Apunta a la agenda, no a nadie de la sala. Invita a darte la razón y reírse no cuesta nada."
    },
    {
      "situation": "El local de una fiesta es demasiado pequeño para la gente invitada.",
      "line": "Creo que acabamos de inventar sin querer un baile nuevo en el que nadie se mueve.",
      "why": "El chiste va del sitio. Todos los presentes son víctimas iguales, que es la forma más rápida de sentirse aliado de un desconocido."
    },
    {
      "situation": "Los dos esperáis un autobús célebre por su impuntualidad.",
      "line": "He empezado a entender el horario más como una declaración de intenciones.",
      "why": "Suave, concreto y sobre una cosa y no sobre una persona. Los chistes pequeños sobre una molestia compartida son el humor de apertura más seguro que existe."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Llevas dos minutos hablando con alguien en un evento de trabajo. ¿Qué chiste es más seguro y tiene más probabilidades de cuajar?",
      "options": [
        { "text": "Un chiste sobre lo malo que es el vino del sitio.", "correct": true, "note": "Apunta a la situación en la que estáis los dos. Nadie tiene que defender el vino, y darte la razón no les cuesta nada." },
        { "text": "Un chiste suave sobre su cargo.", "correct": false, "note": "Meterse con la persona a los dos minutos reclama una cercanía que no has construido. Suele conseguir una risa educada y un pequeño paso atrás." },
        { "text": "Un chiste sobre algo que acaban de decir.", "correct": false, "note": "Esto es buen humor más adelante. A los dos minutos puede leerse como estar siendo observado en vez de disfrutado." },
        { "text": "Un chiste sobre tu propio aspecto.", "correct": false, "note": "Seguro para ellos, pero te pone ligeramente por debajo de la conversación. La autoburla funciona en dosis pequeñas, no como apertura." }
      ],
      "explain": "Apunta a la circunstancia en la que estáis los dos. Es el único blanco donde nadie puede ser el perdedor."
    },
    {
      "prompt": "Llevas media hora hablando con alguien y ha ido bien. ¿Puedes meterte ya con esa persona?",
      "options": [
        { "text": "Sí, si se han metido antes contigo.", "correct": true, "note": "Su broma es la licencia, y la más clara disponible. Dice que los chistes entre nosotros son seguros." },
        { "text": "Sí, media hora es de sobra.", "correct": false, "note": "El tiempo ayuda y no concede permiso. Muchas conversaciones de media hora siguen siendo formales de principio a fin." },
        { "text": "No, espera a conocerles en condiciones.", "correct": false, "note": "Demasiado prudente. Esperar a la certeza es no ser nunca juguetón con nadie nuevo." },
        { "text": "Sí, mientras se note claramente que es con cariño.", "correct": false, "note": "El cariño ayuda y no lo resuelve. Una broma cálida de quien no se la ha ganado sigue cayendo como presunción." }
      ],
      "explain": "Que se metan contigo es la licencia para meterte tú. Hasta entonces, apunta a la situación."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "aimed_at_situation", "label": "Apuntaste a la situación", "description": "Bromeaste sobre una circunstancia compartida en vez de sobre la persona." },
      { "key": "read_the_licence", "label": "Calculaste la cercanía disponible", "description": "No te metiste con la persona antes de que hubiera ninguna complicidad." },
      { "key": "invited_agreement", "label": "Os puso del mismo lado", "description": "El chiste hacía fácil darte la razón en vez de exigir una defensa." },
      { "key": "kept_it_small", "label": "Lo mantuviste proporcionado", "description": "Hiciste una observación pequeña en vez de una actuación." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Un congreso de trabajo obligatorio de dos días, la pausa del café después de una sesión que se ha alargado. Detrás de vosotros hay un panel de lemas motivacionales.",
    "partner": {
      "name": "Danno",
      "role": "alguien de otra empresa en el mismo congreso",
      "personality": "Seco y rápido para sumarse a un chiste compartido, pero se enfría visiblemente si un desconocido se mete con él en persona.",
      "mood": "Algo agotado, con ganas de que le hagan gracia.",
      "openness": 3
    },
    "opening_beat": "Danno lee uno de los lemas en voz alta con un tono deliberadamente plano y te levanta una ceja.",
    "success_looks_like": "La persona se suma sobre la situación en vez de girar el chiste hacia Danno, y los dos establecen un registro compartido.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Responde con calidez y construye sobre cualquier chiste dirigido al congreso, al local o a los lemas.",
      "Si se meten contigo en persona así de pronto, ríete con educación pero brevemente y cambia de tema.",
      "Nunca expliques por qué uno ha cuajado mejor que el otro."
    ]
  }$j$::jsonb,
  $md$Hoy, haz un chiste sobre una situación en la que estéis metidos otra persona y tú. No sobre ella. Anota qué dijiste y si cuajó.$md$,
  $j${
  "turns": [
    { "instruction": "Bromea sobre la cosa en la que estáis metidos los dos. No sobre esa persona." },
    { "instruction": "Ya han contestado. Quédate en la situación — este tampoco lo apuntes hacia ellos." }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('banter', 2,
  'Etiquetar mal a propósito',
  $md$El humor más fiable que existe es llamar a algo deliberadamente lo contrario de lo que es, o una talla más grande.

Alguien menciona que organiza un partido de fútbol sala y tú lo llamas su imperio. Alguien admite que ordena las especias por orden alfabético y le dices que no sabías que estabas en presencia de una radical peligrosa. El chiste es la distancia entre el tamaño de la cosa y el tamaño de la palabra.

**La jugada:** coge lo que acaban de contarte y descríbelo a la escala equivocada.

Funciona porque es obviamente cariñoso. No se puede confundir con una acusación real, ya que nadie cree de verdad que un partido de fútbol sala sea un imperio, así que se lee como atención y no como crítica. Y les entrega una réplica fácil: pueden seguirte el juego y subir la apuesta, que es donde está la gracia.

Sube la escala para algo pequeño, bájala para algo de lo que estén orgullosos — pero lo segundo solo cuando ya os conozcáis.$md$,
  $j$[
    {
      "situation": "Mencionan que llevan una hoja de cálculo con todo lo que han leído este año.",
      "line": "O sea que lo que me estás describiendo es una operación de vigilancia sobre ti mismo.",
      "why": "Coge una costumbre suave y la nombra a una escala absurda. Cariñoso, obviamente falso, y fácil de seguir el juego."
    },
    {
      "situation": "Dicen que el bizcocho lo han hecho ellos pero que no es gran cosa.",
      "line": "Eso lo juzgaré yo. Tengo un paladar sofisticadísimo y ningún tipo de modales.",
      "why": "Se etiqueta mal a uno mismo en vez de a la otra persona, que es una forma segura de hacer esto pronto, y monta un chiste recurrente."
    },
    {
      "situation": "Mencionan que una vez ganaron un concurso de preguntas en un bar.",
      "line": "No sabía que estaba bebiendo con una profesional.",
      "why": "Una talla más grande, dicho en plano. Las etiquetas cortas cuajan mejor que las elaboradas porque dejan sitio para la réplica."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Alguien te dice que es bastante especial con cómo le preparan el café. ¿Cuál es la mejor etiqueta mal puesta?",
      "options": [
        { "text": "O sea que eres un esnob del café.", "correct": false, "note": "Esnob es una acusación real a escala normal, así que se puede tomar en serio. Etiquetar mal funciona cuando la palabra es obviamente demasiado grande." },
        { "text": "Ah, o sea que eres imposible para un desayuno en casa.", "correct": false, "note": "Tiene gracia, pero les etiqueta como una carga en vez de exagerar su pericia. Apunta la exageración hacia arriba." },
        { "text": "Vale, o sea que estoy hablando con una científica.", "correct": true, "note": "Absurdamente demasiado grande, obviamente cariñoso, imposible de tomar como crítica, y les entrega una réplica fácil." },
        { "text": "Eso lo dice todo el mundo de sí mismo.", "correct": false, "note": "No es etiquetar mal en absoluto. Le quita valor a lo que han dicho, que es lo contrario del efecto que quieres." }
      ],
      "explain": "El chiste es la distancia entre la cosa y la palabra. Si la palabra pudiera decirse en serio, no es una etiqueta mal puesta, es un juicio."
    },
    {
      "prompt": "Alguien dice que una vez corrió un maratón. ¿Qué etiqueta funciona?",
      "options": [
        { "text": "O sea que eres de esas personas.", "correct": false, "note": "Una categoría en vez de una exageración, y con filo real. Se puede oír como un juicio de verdad." },
        { "text": "O sea, básicamente una atleta olímpica.", "correct": true, "note": "Absurdamente demasiado grande, obviamente falso, y les entrega una respuesta modesta y fácil." },
        { "text": "Debes de tener muchísima disciplina.", "correct": false, "note": "Un cumplido directo. Cálido, y no es un chiste, así que no hay con qué jugar." },
        { "text": "Yo nunca me molestaría en hacer eso.", "correct": false, "note": "Va sobre ti y no sobre ellos, y le quita valor a algo de lo que están orgullosos." }
      ],
      "explain": "El chiste es el tamaño de la distancia. Si la palabra pudiera decirse en serio, es un juicio y no una etiqueta mal puesta."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "wrong_scale", "label": "Usaste la escala equivocada", "description": "Describiste algo a un tamaño obviamente distinto de la realidad." },
      { "key": "obviously_affectionate", "label": "No se podía tomar en serio", "description": "La exageración era lo bastante grande como para no confundirse con un juicio real." },
      { "key": "used_their_material", "label": "Construiste sobre lo que dijeron", "description": "Etiquetaste algo que la otra persona acababa de ofrecer en vez de importar un chiste." },
      { "key": "left_a_reply", "label": "Les dejaste una réplica", "description": "Lo mantuviste corto como para que pudieran seguir el juego y subir la apuesta." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "El jardín de un amigo en verano. Estás hablando con alguien que acaba de describirte su huerto con un detalle considerable.",
    "partner": {
      "name": "Pav",
      "role": "el amigo de un amigo, de buen humor",
      "personality": "Disfruta que se metan suavemente con él y sigue el juego con entusiasmo, subiendo la apuesta de cualquier chiste que se empiece.",
      "mood": "Alegre y con un par de copas.",
      "openness": 5
    },
    "opening_beat": "Pav termina de explicar su sistema de compostaje y admite, sin ninguna vergüenza, que le mide la temperatura.",
    "success_looks_like": "La persona etiqueta la afición a una escala absurda, Pav sigue el juego, y se monta un chiste recurrente entre los dos.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Si etiquetan tu afición a una escala obviamente exagerada, sigue el juego y sube más la apuesta.",
      "Si hacen un chiste que pudiera tomarse como una crítica real, responde un poco a la defensiva antes de recuperarte.",
      "Sigue dándoles material nuevo que exagerar."
    ]
  }$j$::jsonb,
  $md$Hoy, coge algo que alguien te cuente y descríbelo a una escala obviamente equivocada. Anota la cosa y la palabra que usaste para ella.$md$,
  $j${
  "says": "Le compruebo la temperatura al montón de compost. Dos veces por semana. Esto es normal, por cierto.",
  "model": {
    "line": "O sea que no es un montón de compost, es más bien una mascota pequeña.",
    "why": "Coge su propio material y lo describe a una escala obviamente equivocada, con calidez suficiente como para que no se pueda tomar en serio."
  },
  "checks": [
    { "kind": "echoes_any", "requirement": "Construye sobre lo que han dicho en vez de importar un chiste", "words": ["temperatura", "compost", "dos veces", "semana", "normal", "montón", "compruebo"] },
    { "kind": "max_words", "requirement": "Corto como para que puedan seguir el juego", "n": 18 }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('banter', 3,
  'Drama de mentira',
  $md$La segunda forma fiable es tratar algo trivial como si fuera enormemente importante, y comprometerse con ello.

*Esta es la decisión más importante que vas a tomar hoy. Necesito que sepas que me lo estoy tomando muy en serio. Vamos a tener un problema si dices piña.* El humor está entero en el desajuste entre la gravedad de la entrega y la trivialidad del asunto.

**La jugada:** coge algo que no importa nada y finge que es una crisis.

El drama de mentira sirve porque crea un conflicto pequeño y seguro. Discrepar de verdad es arriesgado con alguien a quien apenas conoces; discrepar de mentira sobre cuál es la galleta correcta es intimidad con el riesgo quitado. Te llevas la sensación de haber tomado partido sin ninguna posibilidad de que nadie salga herido.

La regla es que tiene que ser obviamente trivial. Aplicarle drama de mentira a algo que de verdad les importa no es broma, es burla.$md$,
  $j$[
    {
      "situation": "Te preguntan si quieres té o café.",
      "line": "Esto parece una prueba. Voy a contestar con cuidado.",
      "why": "Drama de mentira instantáneo sobre una pregunta que no es nada. Señala que hay ganas de jugar en los primeros treinta segundos de una conversación."
    },
    {
      "situation": "Admiten que echan la leche primero.",
      "line": "Vale. Voy a necesitar un momento para decidir cómo me siento respecto a esta amistad.",
      "why": "Una crisis falsa por algo que no podría importar menos. La palabra amistad es la pista de que es un juego."
    },
    {
      "situation": "Estáis los dos eligiendo dónde sentaros en una sala casi vacía.",
      "line": "Con cuidado. Todo lo que pase a partir de ahora depende de esto.",
      "why": "Convierte una no-decisión en un momento. El drama de mentira funciona mejor aplicado a cosas sin ningún contenido."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué asunto es el mejor candidato para drama de mentira con alguien a quien acabas de conocer?",
      "options": [
        { "text": "Con qué se hace el bocadillo.", "correct": true, "note": "Perfectamente trivial, entendido por todo el mundo, e imposible ofender a nadie de verdad. El campo de batalla falso ideal." },
        { "text": "Su gusto musical.", "correct": false, "note": "Más arriesgado de lo que parece. Mucha gente está genuinamente implicada con su gusto, así que un veredicto de mentira puede caer como uno real." },
        { "text": "Su elección de carrera.", "correct": false, "note": "No es trivial. Aplicarle gravedad falsa a algo que sí les pesa se lee como burla." },
        { "text": "Su equipo de fútbol.", "correct": false, "note": "El error clásico. Parece una rivalidad falsa segura y es, para bastante gente, una completamente real." }
      ],
      "explain": "El drama de mentira necesita un asunto sin ningún peso real. Si pudiera importarles de verdad, elige otra cosa."
    },
    {
      "prompt": "Tu chiste de drama de mentira recibe una respuesta real y algo defensiva. ¿Qué ha pasado?",
      "options": [
        { "text": "No tienen sentido del humor.", "correct": false, "note": "La conclusión que impide aprender nada. Casi siempre es el asunto y no la persona." },
        { "text": "No te comprometiste lo suficiente.", "correct": false, "note": "Insistir más en un chiste sobre algo que les importa lo empeora." },
        { "text": "Elegiste algo que sí les importa.", "correct": true, "note": "El drama de mentira solo funciona sobre asuntos sin peso real. Una respuesta defensiva significa que has encontrado uno que sí lo tenía." },
        { "text": "Era demasiado pronto en la conversación.", "correct": false, "note": "El drama de mentira sobre trivialidades funciona en segundos. El momento rara vez es el problema aquí." }
      ],
      "explain": "Una respuesta defensiva es información: ese asunto sí tenía peso. Déjalo y coge algo más vacío."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "chose_trivial", "label": "Elegiste algo genuinamente trivial", "description": "Le aplicaste gravedad falsa a un asunto sin peso real para la otra persona." },
      { "key": "committed", "label": "Te comprometiste con el juego", "description": "Lo entregaste con convicción suficiente como para que el desajuste fuera el chiste." },
      { "key": "safe_conflict", "label": "Creaste un desacuerdo seguro", "description": "Produjiste el gusto de tomar partido sin ningún riesgo real." },
      { "key": "let_them_play", "label": "Les dejaste jugar", "description": "Dejaste sitio para que tomaran el bando contrario y subieran la apuesta." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "La mesa de picar de una fiesta tranquila en una casa. Hay una variedad irrazonable de patatas fritas.",
    "partner": {
      "name": "Immy",
      "role": "alguien a quien te acaban de presentar",
      "personality": "Rápida y competitiva, encantada con una discusión falsa y completamente indiferente a perderla.",
      "mood": "Relajada y con ganas.",
      "openness": 5
    },
    "opening_beat": "Immy está examinando la selección de patatas y dice, medio para sí misma, que esta es una decisión genuinamente difícil.",
    "success_looks_like": "La persona coge la decisión trivial y la infla hasta convertirla en una crisis falsa, e Immy se suma y sube la apuesta.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Si le aplican drama de mentira a algo trivial, coge el bando contrario con convicción total y sube la apuesta.",
      "Si le aplican gravedad falsa a algo que sí podría importarle a alguien, responde plana y cambia de tema.",
      "Mantén la discusión falsa viva tanto tiempo como la mantengan ellos."
    ]
  }$j$::jsonb,
  $md$Hoy, convierte una cosa completamente trivial en una crisis falsa y comprométete con ella. Anota cuál era la crisis y si se sumaron.$md$,
  $j${
  "turns": [
    { "instruction": "Coge algo completamente trivial y trátalo como una crisis." },
    { "instruction": "Comprométete. No guiñes el ojo y no expliques el chiste." },
    { "instruction": "Déjales ganar, o deja que se derrumbe. Cualquiera de las dos es un buen final." }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('banter', 4,
  'Retomar un chiste',
  $md$Retomar algo es lo más valioso que puedes hacer en una conversación, y no cuesta más que atención.

Quince minutos después de que alguien haga un chiste de pasada sobre su pésimo sentido de la orientación, lo retomas mientras habláis de algo completamente distinto. Eso es todo. La risa es desproporcionada respecto al esfuerzo, porque retomar algo demuestra dos cosas a la vez: que estabas escuchando, y que ahora los dos tenéis una referencia compartida que nadie más en la sala tiene.

**La jugada:** guárdate en el bolsillo una cosa graciosa que hayan dicho, y sácala más tarde.

Eso es genuinamente todo. La parte difícil no es el ingenio, es acordarse. Casi todo el mundo está componiendo su frase siguiente en vez de guardar el material.

Retomar algo en el último minuto de una conversación es lo que más vale, porque es lo que van a recordar de haber hablado contigo.$md$,
  $j$[
    {
      "situation": "Antes bromearon con que son incapaces de seguir una receta.",
      "line": "Tú traes el vino. A la comida no te dejo acercarte.",
      "why": "Usa su propio chiste veinte minutos después en un contexto nuevo. Señala que todo lo que dijeron merecía la pena guardarse."
    },
    {
      "situation": "Hicieron un chiste sobre la obsesión de su compañero de piso con las plantas.",
      "line": "Salúdame a las plantas.",
      "why": "Un chiste retomado usado como frase de salida. Esta es la colocación más valiosa, porque es lo último que oyen."
    },
    {
      "situation": "Mencionaron que siempre les acaban convenciendo de cosas.",
      "line": "Vas a decir que sí a esto y luego te vas a arrepentir, ¿verdad?",
      "why": "Usa un patrón que te contaron sobre ellos mismos en vez de un chiste concreto. Algo más avanzado, y cae más fuerte."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuándo vale más retomar un chiste?",
      "options": [
        { "text": "Inmediatamente, mientras sigue fresco.", "correct": false, "note": "Demasiado pronto es solo repetición. Retomar funciona porque ha pasado tiempo y aun así te lo guardaste." },
        { "text": "Cuando la conversación se está acabando.", "correct": true, "note": "Es lo último que oyen, demuestra que aguantaste algo a lo largo de toda la conversación, y hace cálida la salida." },
        { "text": "Cuando haya un silencio incómodo.", "correct": false, "note": "Mejor que nada, pero usarlo como rescate hace que parezca desplegado en vez de recordado." },
        { "text": "La próxima vez que les veas.", "correct": false, "note": "Es excelente cuando funciona, pero es otra jugada. Dentro de la misma conversación el efecto es más fiable." }
      ],
      "explain": "Retomar funciona por la distancia. Guárdate uno para la salida, donde además es lo que van a recordar de ti."
    },
    {
      "prompt": "¿Qué hace que retomar un chiste funcione?",
      "options": [
        { "text": "Que tuviera gracia la primera vez.", "correct": false, "note": "Ayuda y no es el mecanismo. Se retoman cosas que apenas eran chistes." },
        { "text": "Que lo entregues bien.", "correct": false, "note": "La entrega es lo que menos importa aquí. Retomado en plano también cuaja." },
        { "text": "Que el grupo entero oyera el original.", "correct": false, "note": "Un chiste que solo entendéis vosotros dos es más fuerte, no más débil." },
        { "text": "Que haya pasado tiempo suficiente como para contar como memoria.", "correct": true, "note": "La distancia es lo esencial. Demuestra que te guardaste algo, que es a lo que responde la gente de verdad." }
      ],
      "explain": "Retomar algo es prueba de atención. Sin distancia es solo repetición."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "stored_it", "label": "Te guardaste algo en el bolsillo", "description": "Aguantaste una frase o un detalle concreto de antes en la conversación." },
      { "key": "brought_it_back", "label": "Retomaste algo", "description": "Te referiste a material anterior en un contexto nuevo." },
      { "key": "let_time_pass", "label": "Esperaste lo suficiente", "description": "Dejaste distancia suficiente como para que se leyera como memoria y no como repetición." },
      { "key": "placement", "label": "Lo colocaste bien", "description": "Lo usaste en un momento en el que añadía calidez, idealmente cerca del final." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Una espera larga por un vuelo retrasado. Llevas un rato hablando con la persona de al lado en la puerta de embarque.",
    "partner": {
      "name": "Ren",
      "role": "otro pasajero varado",
      "personality": "Gracioso de forma despreocupada y suelta pequeños chistes a su costa sin detenerse en ellos. Visiblemente encantado cuando alguien recuerda uno.",
      "mood": "Resignado al retraso y disfrutando de la compañía.",
      "openness": 4
    },
    "opening_beat": "Ren menciona, completamente de pasada, que ya ha ido dos veces a la puerta equivocada y todavía no es la hora de comer.",
    "success_looks_like": "La persona guarda un chiste temprano y lo retoma más tarde en un contexto nuevo, y Ren reacciona con placer real por ser recordado.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Suelta un chiste pequeño y memorable a tu costa en tus dos primeras respuestas, y luego sigue y no vuelvas a mencionarlo.",
      "Si lo retoman más tarde, reacciona con verdadero placer y construye sobre ello.",
      "Sigue ofreciendo detalles pequeños nuevos, pero no repitas nunca tus propios chistes anteriores."
    ]
  }$j$::jsonb,
  $md$Retoma un chiste hoy. Guárdate algo gracioso del principio de una conversación y sácalo cerca del final. Anota qué guardaste y dónde lo usaste.$md$,
  null);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('banter', 5,
  'Cuando un chiste no cuaja',
  $md$Cada cierto tiempo un chiste se muere. La recuperación es una habilidad, y vale más que los chistes.

El instinto es explicarlo, repetirlo un poco más alto, o disculparse. Las tres cosas alargan el momento. Explicar un chiste es lo único más incómodo que un chiste fallido, y disculparse les pide que te tranquilicen, que ahora es una tarea que les has puesto encima.

**La jugada:** reconócelo en tres palabras o menos y sigue adelante.

*Nada. En fin.* *Sonaba mejor en mi cabeza.* Y luego continúa como si no hubiera pasado nada, porque casi nada ha pasado. Un chiste que no cuaja solo es incómodo el rato que tú lo mantengas vivo, y eso lo controlas entero.

El punto de fondo: la gente está mucho más relajada con alguien a quien visiblemente no le importa que un chiste falle. Les dice que tu tranquilidad no depende de su aprobación, lo que les vuelve más tranquilos a ellos.$md$,
  $j$[
    {
      "situation": "Hiciste un chiste y recibiste media sonrisa educada.",
      "line": "Sonaba mejor en mi cabeza. En fin, ¿me decías?",
      "why": "Seis palabras de reconocimiento y vuelta inmediata a su tema. El momento se cierra antes de poder cuajar."
    },
    {
      "situation": "Un chiste cae completamente plano con alguien a quien acabas de conocer.",
      "line": "(un pequeño encogimiento de hombros, y sigue como si nada)",
      "why": "No todo necesita palabras. Que se vea que no te importa hace el trabajo entero y no gasta ni un segundo más de la conversación."
    },
    {
      "situation": "Te das cuenta a mitad de frase de que el chiste no va a funcionar.",
      "line": "He perdido la fe en esta frase.",
      "why": "Abandonar un chiste con alegría suele tener más gracia que el chiste. Narrar tu propio fracaso es seguro porque el blanco eres tú."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Tu chiste recibe una mirada en blanco. ¿Cuál es la mejor recuperación?",
      "options": [
        { "text": "Explicar qué querías decir.", "correct": false, "note": "La peor opción de todas. Explicarlo alarga el fracaso y convierte un momento de dos segundos en uno de treinta." },
        { "text": "Disculparte por el chiste.", "correct": false, "note": "Les entrega el trabajo de tranquilizarte, que es más esfuerzo del que el chiste les costó nunca." },
        { "text": "No decir nada y cambiar de tema de golpe.", "correct": false, "note": "Sirve, pero la brusquedad indica que te has puesto nervioso. Un reconocimiento breve queda más suave que fingir que no ha pasado." },
        { "text": "Reconocerlo en unas palabras y seguir de largo.", "correct": true, "note": "Cierra el momento, demuestra que no te cuesta nada, y devuelve la conversación. Que se vea que no te importa es la recuperación entera." }
      ],
      "explain": "Un chiste fallido dura exactamente lo que tú lo mantengas vivo. Tres palabras y adelante."
    },
    {
      "prompt": "¿Qué recuperación de un chiste muerto se lee como la más cómoda?",
      "options": [
        { "text": "Un encogimiento de hombros y de vuelta a lo que estaban diciendo.", "correct": true, "note": "No te cuesta nada visiblemente, que es lo que les dice que tu tranquilidad no depende de su risa." },
        { "text": "Reírte de tu propio chiste para taparlo.", "correct": false, "note": "El rescate más visible que hay, y agranda el fracaso." },
        { "text": "Probar otro mejor inmediatamente.", "correct": false, "note": "Ahora estás actuando, y el segundo carga con el peso del primero." },
        { "text": "Decir que eso ha salido mal.", "correct": false, "note": "Autocorrección suave que aun así gasta otro tiempo en el chiste." }
      ],
      "explain": "La recuperación va de que se vea que no te importa. Cualquier cosa que gaste más tiempo en el chiste lo agranda."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "did_not_explain", "label": "No explicaste el chiste", "description": "Te resististe a aclarar qué querías decir." },
      { "key": "did_not_apologise", "label": "No te disculpaste", "description": "Evitaste entregarle a la otra persona el trabajo de tranquilizarte." },
      { "key": "moved_on", "label": "Seguiste de largo", "description": "Volviste a la conversación rápido en vez de quedarte ahí." },
      { "key": "stayed_easy", "label": "Se te vio tranquilo", "description": "Mantuviste la calma, lo que dejó a la otra persona tranquila también." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Un bar tranquilo entre semana. Estás hablando con alguien de humor mucho más seco que el tuyo.",
    "partner": {
      "name": "Halvard",
      "role": "el amigo de un amigo al que has visto una vez",
      "personality": "Muy seco y difícil de leer. No se ríe con facilidad de nada, lo que hace que los chistes parezcan haber fallado incluso cuando no.",
      "mood": "A gusto, contenido, disfrutando de verdad la conversación sin demostrarlo mucho.",
      "openness": 3
    },
    "opening_beat": "Halvard responde a tu primer intento de chiste con un pequeño asentimiento y ninguna risa, y espera.",
    "success_looks_like": "El chiste de la persona parece fallar, y se recupera en unas palabras sin explicar ni disculparse, tras lo cual Halvard se calienta bastante.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "No te rías nunca en voz alta. Responde a los chistes con un reconocimiento seco y contenido como mucho.",
      "Si explican o se disculpan por un chiste, ponte más reservado.",
      "Si lo dejan pasar en unas palabras y siguen, caliéntate notablemente y ofrece un chiste seco tuyo."
    ]
  }$j$::jsonb,
  $md$Hoy, deja que un chiste falle, a propósito o por accidente, y recupérate en tres palabras. Fíjate en que no pasa nada malo. Anota el chiste y la recuperación.$md$,
  $j${
  "turns": [
    { "instruction": "Haz un chiste. Cualquiera." },
    { "instruction": "No ha cuajado. Recupérate en tres palabras o menos y vuelve a lo que estaban diciendo." }
  ]
}$j$::jsonb);
