-- Spanish: Small talk, track 4 — Escuchar y nombrar.
--
-- The technique itself shifts slightly in Spanish and it is worth saying how.
--
-- An English label is a bare word returned flat: "Weird." "Brutal." "A slog."
-- Spanish can do this too, and often with the identical word — brutal is
-- brutal — but the trap is gender. Return somebody's adjective and it has to
-- agree with whatever it described, so a label lifted carelessly out of their
-- sentence can land wrong: "cansada" said back to a man is not a label, it is
-- a mistake. The examples therefore favour words that do not inflect — nouns
-- like paliza and pesadilla, and adjectives that are the same either way like
-- brutal, raro is avoided in favour of extraño only where the referent is
-- clear.
--
-- The tentative framing in lesson 3 translates cleanly and is the part of this
-- track that matters most: "suena a" and "parece que" do exactly what "sounds
-- like" and "seems like" do, which is mark the guess as yours so that being
-- corrected costs nobody anything.
--
-- Lesson 5 is scene mode and has no rehearsal spec in English either, so none
-- is written here.

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

select pg_temp.es_lesson('listening-and-labeling', 1,
  'Devuélvele su palabra',
  $md$Nombrar es la herramienta más barata que hay en una conversación y la que más se cree la gente.

Coges una palabra que han usado — la suya, no tu paráfrasis — y la dices de vuelta como afirmación. *O sea, implacable.* Eso es la jugada entera. Sin interrogación, sin consejo, sin una historia tuya.

Funciona porque ser entendido es más raro que recibir la razón. Cuando alguien oye su propia palabra devuelta, tiene la prueba de que estabas escuchando de verdad y no esperando turno, y la respuesta casi automática es explicarse más.

**La jugada:** coge su palabra más cargada, dila de vuelta en plano, y déjales que se extiendan.

Usa su palabra exacta. Cambiar *implacable* por *estresante* es una rebaja: has sustituido su experiencia por tu resumen de ella, y lo van a notar aunque no sepan decir qué ha pasado.$md$,
  $j$[
    {
      "situation": "Dicen: han sido unos meses raros, la verdad.",
      "line": "Raros.",
      "why": "Una palabra, dicha en plano, sin nada detrás. Raros está trabajando mucho en esa frase y esto se la devuelve entera para que la desdoblen."
    },
    {
      "situation": "Dicen: al final salí de ese trabajo, pero tardé muchísimo más de la cuenta.",
      "line": "Más de la cuenta.",
      "why": "Ignora el tema evidente, el trabajo, y coge la parte que lleva juicio dentro. Ahí es donde está la historia de verdad."
    },
    {
      "situation": "Dicen: mi familia es estupenda, solo que es mucho.",
      "line": "Mucho.",
      "why": "Repite el matiz en vez del cumplido. La gente entierra lo verdadero en la segunda mitad de ese tipo de frase."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Alguien dice: la mudanza al final salió bien, lo que pasa es que llegar hasta ahí fue una pesadilla. ¿Cuál es la mejor forma de nombrarlo?",
      "options": [
        { "text": "Suena muy estresante.", "correct": false, "note": "Es un nombramiento, pero has cambiado su palabra por la tuya. Pesadilla es suya; estresante es tu rebaja." },
        { "text": "Mudarse es lo peor. Cuando me mudé el año pasado la furgoneta llegó vacía.", "correct": false, "note": "Compasión más tu propia historia. Comprensible, pero has llevado la conversación fuera de esa persona justo cuando se estaba abriendo." },
        { "text": "Una pesadilla llegar hasta ahí.", "correct": true, "note": "Sus palabras exactas, devueltas en plano. Casi todo el mundo contesta a esto explicando qué fue la pesadilla exactamente." },
        { "text": "¿Por qué fue una pesadilla?", "correct": false, "note": "Cerca, y funcionará muchas veces, pero una pregunta les pone en el aprieto donde una afirmación les invita. Las afirmaciones consiguen respuestas más largas." }
      ],
      "explain": "Usa su palabra exacta y quita la interrogación. Nombrar es una oferta para seguir, no una petición de explicaciones."
    },
    {
      "prompt": "Dicen: ha sido una paliza, pero lo sacamos. ¿Qué es mejor nombrar?",
      "options": [
        { "text": "Lo sacasteis.", "correct": false, "note": "Sus palabras, y la mitad equivocada. Esto nombra la resolución y cierra el tema." },
        { "text": "Suena agotador.", "correct": false, "note": "Tu palabra en vez de la suya, y sube paliza a algo que no dijeron." },
        { "text": "Una paliza.", "correct": true, "note": "Su palabra, y la cargada. La segunda mitad de esa frase es la versión presentable; la primera es la verdadera." },
        { "text": "Pero al final lo sacasteis.", "correct": false, "note": "Un consuelo, que les pide que confirmen que estuvo bien y dejen de hablar." }
      ],
      "explain": "Cuando una frase tiene dos mitades, la verdadera es casi siempre la primera. La segunda es lo que añadieron por educación."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "used_their_word", "label": "Usaste su palabra exacta", "description": "Repetiste el lenguaje de la otra persona en vez de una paráfrasis o una versión subida de tono." },
      { "key": "picked_the_loaded_one", "label": "Cogiste la palabra cargada", "description": "Elegiste la palabra que llevaba juicio o emoción en vez del tema evidente." },
      { "key": "no_question_mark", "label": "Lo dijiste como afirmación", "description": "Lo dijiste en plano en lugar de convertirlo en pregunta." },
      { "key": "no_hijack", "label": "No te llevaste la conversación", "description": "Te resististe a seguir el nombramiento con tu propia historia o con un consejo." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "La mesa de un bar un miércoles, con dos copas ya, con alguien a quien conoces un poco del trabajo.",
    "partner": {
      "name": "Nic",
      "role": "alguien de otro departamento con quien te llevas bien pero a quien no conoces mucho",
      "personality": "Habla con facilidad pero se queda en la superficie salvo que alguien demuestre que está escuchando de verdad. Tiene unos meses genuinamente difíciles detrás de la charla ligera.",
      "mood": "Cansado y con la guardia algo baja.",
      "openness": 4
    },
    "opening_beat": "Nic dice que el último trimestre estuvo bien, solo que un poco brutal, y se queda mirando su copa.",
    "success_looks_like": "La persona nombra una de las palabras cargadas de Nic y calla, y Nic llena el hueco con algo real.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Deja siempre exactamente una palabra cargada en cada respuesta para que la recojan.",
      "Cuando digan una de tus palabras de vuelta como afirmación, extiéndete con generosidad y baja un nivel.",
      "Si en vez de eso dan un consejo o cuentan su propia historia, vuelve a la superficie y ponte más genérico."
    ]
  }$j$::jsonb,
  $md$Nombra una cosa hoy. Coge una palabra de otra persona, dísela de vuelta como afirmación, y no digas nada más. Anota la palabra que usaste y qué salió.$md$,
  $j${
  "says": "El último trimestre estuvo bien. Un poco brutal, si te soy sincero.",
  "model": {
    "line": "Brutal.",
    "why": "Su palabra, dicha en plano, sin nada detrás. Le devuelve la frase entera para que la desdoble."
  },
  "checks": [
    { "kind": "echoes_any", "requirement": "Usa una de sus propias palabras", "words": ["brutal", "bien", "trimestre", "sincero"] },
    { "kind": "no_question", "requirement": "Dilo en plano. No como pregunta." },
    { "kind": "no_first_person", "requirement": "No lo gires hacia ti" },
    { "kind": "max_words", "requirement": "Menos de seis palabras. Nombrar es corto.", "n": 6 }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('listening-and-labeling', 2,
  'Y luego calla',
  $md$Nombrar es la mitad fácil. La mitad difícil son los dos segundos siguientes.

El silencio en una conversación se le hace mucho más largo a quien lo ha provocado. Dos segundos parecen diez, y el reflejo es rescatarlo: añadir una coletilla, suavizarlo en pregunta, reírse. Cada una de esas cosas le quita la presión a la otra persona, y la presión era justo lo que queríamos.

La gente llena los silencios. Es casi automático. Si dices su palabra de vuelta y esperas, casi siempre seguirán, y lo que digan a continuación suele ser más sincero que lo anterior, porque no estaba planeado.

**La jugada:** después de nombrar, cuenta dos tiempos lentos antes de permitirte hablar.

No estás siendo frío. Les estás dando el suelo y luego dejándolo vacío el tiempo suficiente para que se suban a él.$md$,
  $j$[
    {
      "situation": "Has dicho su palabra de vuelta y se han quedado callados un segundo.",
      "line": "(nada — mantén la mirada, sigue relajado)",
      "why": "La pausa es la técnica. Una cara relajada convierte el silencio de acusación en invitación."
    },
    {
      "situation": "Nombraste, dijeron una frase corta, y volvieron a parar.",
      "line": "(nada todavía — un pequeño asentimiento)",
      "why": "Asentir no es hablar. Mantiene el suelo con ellos y a la vez demuestra que no te has ido."
    },
    {
      "situation": "Has esperado tres segundos de verdad y no han seguido.",
      "line": "Perdona, te he soltado eso de golpe.",
      "why": "Si el silencio de verdad no se va a llenar, cárgate tú la incomodidad en vez de dejarla encima de ellos."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Nombras la palabra de alguien y se hace una pausa. ¿Qué haces?",
      "options": [
        { "text": "Esperar, con la cara relajada.", "correct": true, "note": "La pausa es la herramienta. Casi todo el mundo la llena en un par de segundos, y lo que dice suele ser la versión sincera." },
        { "text": "Añadir una pregunta para echarles una mano.", "correct": false, "note": "Esta es la forma más común de estropear la técnica. Tu pregunta quita la presión y sustituye su respuesta por la tuya." },
        { "text": "Llenarla con algo tuyo.", "correct": false, "note": "Rescata tu propia incomodidad a costa de la suya. El suelo era de ellos y se lo has quitado." },
        { "text": "Reformular por si no lo han entendido.", "correct": false, "note": "Lo han entendido. Reformular indica que el silencio te resultaba insoportable, lo que hace más difícil aguantar el siguiente." }
      ],
      "explain": "El silencio después de nombrar no es un fallo del nombramiento. Es el nombramiento funcionando."
    },
    {
      "prompt": "Nombras, hacen una pausa, y notas que vas a hablar. ¿Qué está pasando de verdad en esa pausa?",
      "options": [
        { "text": "Están decidiendo si fiarse de ti.", "correct": false, "note": "A veces, y sobre todo es leer demasiado en un hueco de dos segundos." },
        { "text": "Esperan a que expliques qué querías decir.", "correct": false, "note": "Casi nunca. Nombrar se entiende al instante; por eso funciona." },
        { "text": "La conversación se ha atascado.", "correct": false, "note": "Este es el miedo que arruina la técnica. El silencio es la técnica funcionando." },
        { "text": "Están calculando cuánto contar.", "correct": true, "note": "Normalmente exactamente esto. La pausa es composición, e interrumpirla te consigue la versión corta." }
      ],
      "explain": "Una pausa después de nombrar es alguien decidiendo cuánto contarte. Si la llenas, has contestado por ellos."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "held_the_pause", "label": "Aguantaste el silencio", "description": "Esperaste después de nombrar en vez de rescatar la pausa." },
      { "key": "stayed_relaxed", "label": "Lo mantuviste cálido mientras esperabas", "description": "El silencio se leyó como invitación y no como exigencia." },
      { "key": "did_not_add", "label": "No apilaste una pregunta encima", "description": "Te resististe a suavizar el nombramiento en pregunta o a añadir una coletilla." },
      { "key": "recovered_well", "label": "Manejaste un silencio que no se llenó", "description": "Cuando la pausa de verdad no se recogió, te cargaste tú la incomodidad." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Un banco junto a la cafetería de un hospital. Esperas la misma franja de cita que alguien a quien acabas de conocer.",
    "partner": {
      "name": "Margo",
      "role": "alguien que espera la misma consulta",
      "personality": "Con la guardia alta al principio, y con mucho que decir si le dan sitio. Responde muy bien a que le den espacio y se cierra si la otra persona habla por encima de los huecos.",
      "mood": "Con ansiedad, aguantando el tipo, agradecida de distraerse.",
      "openness": 3
    },
    "opening_beat": "Margo menciona que viene cada pocas semanas desde primavera, y que se ha convertido en una rutina extraña.",
    "success_looks_like": "La persona nombra y luego espera de verdad, y Margo llena el silencio con algo que no habría dicho si se lo preguntan.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Cuando nombren una de tus palabras y luego no digan nada más, sigue hablando y baja más de lo que tenías previsto.",
      "Si siguen el nombramiento con una pregunta o con su propia historia, da una respuesta corta, plana y de superficie.",
      "Nunca menciones la técnica ni el silencio."
    ]
  }$j$::jsonb,
  $md$Hoy, después de nombrar una vez, cuenta dos tiempos lentos antes de hablar. Fíjate en qué hacen con el hueco. Anota si conseguiste aguantarlo.$md$,
  $j${
  "turns": [
    { "instruction": "Nombra algo que hayan dicho. Su palabra, dicha en plano." },
    { "instruction": "Ya han contestado. No llenes el hueco — di lo más corto que lo mantenga abierto, o termina aquí la escena." }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('listening-and-labeling', 3,
  'Nombra la emoción que hay debajo del dato',
  $md$Repetir una palabra es la versión de principiante. La avanzada es nombrar la emoción que las palabras llevan pero no dicen.

La gente casi nunca anuncia lo que siente. Describe circunstancias y deja la emoción implícita, en parte por costumbre y en parte para ver si te das cuenta. *Al final lo hice yo casi todo* es una frase sobre carga de trabajo con resentimiento doblado dentro.

**La jugada:** nombra la emoción de forma tentativa, como una suposición que puedan corregir.

*Suena a que eso escoció un poco. Parece que estabas bastante orgulloso de aquello.* El marco tentativo es esencial. Un diagnóstico seguro de la vida interior de alguien resulta desagradable incluso cuando acierta. Una suposición ofrecida con ligereza es un regalo, porque dice que prestabas suficiente atención como para intentarlo.

Y equivocarse funciona casi igual de bien que acertar, que es la lección siguiente.$md$,
  $j$[
    {
      "situation": "Dicen: lo organicé yo entero y luego lo presentó otra persona.",
      "line": "Suena a que eso escoció un poco.",
      "why": "Nombra la emoción no dicha en vez de repetir los hechos. Suena a lo mantiene como suposición y no como veredicto."
    },
    {
      "situation": "Dicen: esto todavía no se lo he contado a nadie.",
      "line": "Parece que aún estás decidiendo qué piensas de ello.",
      "why": "Nombra el estado en vez del contenido, lo que les deja hablar sin tener que haber concluido nada primero."
    },
    {
      "situation": "Describen haber terminado un proyecto largo con voz plana y cansada.",
      "line": "No suenas tan contento como yo habría esperado.",
      "why": "Nombra la distancia entre lo que han dicho y cómo lo han dicho. Hecho con suavidad, este es el nombramiento que más impresiona."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Alguien dice: cogí el ascenso, evidentemente. Era más dinero y todo el mundo decía que estaría loco si no. ¿Cuál es el mejor nombramiento?",
      "options": [
        { "text": "Más dinero es más dinero.", "correct": false, "note": "Le da la razón a la superficie y cierra la puerta a todo lo que hay debajo." },
        { "text": "Enhorabuena, qué buena noticia.", "correct": false, "note": "Amable, y se toma su marco completamente al pie de la letra. Evidentemente y todo el mundo decía estaban trabajando, y ahora es poco probable que lo expliquen." },
        { "text": "Suena a que fue más decisión de los demás que tuya.", "correct": true, "note": "Nombra lo que la frase lleva dentro. Evidentemente y todo el mundo decía son la pista, y ofrecerlo como suposición hace que sea seguro darte la razón." },
        { "text": "¿Te arrepientes?", "correct": false, "note": "El objetivo correcto, pero a bocajarro. Una pregunta así de directa suele recibir una negación, mientras que un nombramiento tentativo se acepta." }
      ],
      "explain": "Nombra la emoción que lleva la frase, y enmárcalo como suposición. Suena a y parece que hacen casi todo el trabajo."
    },
    {
      "prompt": "¿Qué formulación hace más fácil corregir un nombramiento de emoción?",
      "options": [
        { "text": "Suena a que fue frustrante.", "correct": true, "note": "Suena a lo enmarca como impresión tuya y no como hecho suyo, así que decir que no es fácil y no cuesta nada." },
        { "text": "Tuviste que ponerte furioso.", "correct": false, "note": "Seguro y concreto, así que discrepar significa contradecirte a ti en vez de ajustarte." },
        { "text": "Seguro que fue molesto.", "correct": false, "note": "Más suave, y seguro que sigue afirmando. Invita más al acuerdo que a la corrección." },
        { "text": "¿Te enfadaste por eso?", "correct": false, "note": "Una pregunta directa sobre una emoción, que la gente niega por reflejo." }
      ],
      "explain": "Suena a y parece que hacen el trabajo. Marcan la suposición como tuya, y eso es lo que hace indoloro corregirla."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named_the_feeling", "label": "Nombraste lo que había debajo", "description": "Nombraste la emoción implícita en vez de repetir las circunstancias." },
      { "key": "stayed_tentative", "label": "Lo ofreciste como suposición", "description": "Usaste suena a, parece que o similar en vez de diagnosticar con seguridad." },
      { "key": "read_the_tell", "label": "Detectaste la pista", "description": "Recogiste un matiz, un tono o una distancia entre el contenido y la forma de decirlo." },
      { "key": "left_room_to_deny", "label": "Fácil de corregir", "description": "Formulaste el nombramiento para que pudieran discrepar sin fricción." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Un tren de vuelta por la noche. Dos asientos enfrentados, y lleváis veinte minutos hablando a ratos.",
    "partner": {
      "name": "Iris",
      "role": "alguien que vuelve del mismo evento",
      "personality": "Serena y articulada, describe situaciones en vez de emociones, y se la ve aliviada cuando alguien nombra lo que lleva rato rodeando.",
      "mood": "Reflexiva, algo gastada.",
      "openness": 4
    },
    "opening_beat": "Iris dice que acaba de cerrar un proyecto que dirigió durante dieciocho meses, y describe el final en términos raramente planos y prácticos.",
    "success_looks_like": "La persona nombra la emoción que hay debajo de esa planitud como una suposición, e Iris lo confirma y se abre bastante.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Describe circunstancias, nunca emociones, salvo que nombren una primero.",
      "Cuando ofrezcan un nombramiento tentativo de tu emoción, confírmalo o corrígelo con suavidad y después di mucho más.",
      "Si solo repiten palabras factuales, quédate en la superficie y sigue describiendo logística."
    ]
  }$j$::jsonb,
  $md$Hoy, nombra la emoción que hay debajo de lo que alguien dice, ofrecida como suposición. Suena a, o parece que. Anota qué supusiste y si acertaste.$md$,
  $j${
  "says": "Pues ya está, ya. Dieciocho meses, firmado, cajas archivadas.",
  "model": {
    "line": "Suena a una forma extraña de terminar algo.",
    "why": "Nombra lo que hay debajo de la planitud y lo ofrece como una suposición que ella puede corregir."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Ofrécelo como suposición — suena a, parece que", "words": ["suena a", "parece que", "suena", "parece", "da la sensación", "no suenas", "diría que"] },
    { "kind": "no_question", "requirement": "Una suposición, no una pregunta" },
    { "kind": "max_words", "requirement": "Menos de catorce palabras", "n": 14 }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('listening-and-labeling', 4,
  'Equivocarse también funciona',
  $md$Lo que frena a la gente a la hora de nombrar emociones es el miedo a fallar. Ese miedo está mal puesto, porque un nombramiento equivocado sirve casi tanto como uno acertado.

Cuando dices *suena a que eso fue frustrante* y no lo era, la respuesta no es ofensa. Es corrección: *no, frustrante no, más bien decepcionante.* Acaban de darte la palabra precisa, que es mejor que la que tenías, y han tenido que pensar para producirla.

**La jugada:** supón igualmente, sostenlo flojo, y trata la corrección como el premio.

Esto solo se sostiene si la suposición se ofreció como suposición. Un veredicto seguro y equivocado sí ofende, porque ahora tienen que discutir en vez de corregir. El marco tentativo es lo que convierte equivocarse de error en método.

La única excepción: no te equivoques dos veces sobre lo mismo. Una vez es atención. Dos es no estar escuchando.$md$,
  $j$[
    {
      "situation": "Dijiste que sonaba frustrante y te han dicho que no exactamente.",
      "line": "¿Qué era entonces, más cerca de aburrido?",
      "why": "Coge la corrección y ofrece otra suposición de inmediato. Ahora estáis buscando juntos en vez de interrogarles tú."
    },
    {
      "situation": "Supusiste que estaban nerviosos y dicen que en realidad estaban ilusionados.",
      "line": "Ilusionados. Ese es un punto de partida mucho mejor.",
      "why": "Acepta la corrección usando su palabra nueva al momento. Demuestra que la suposición se sostenía de verdad con flojera."
    },
    {
      "situation": "Corrigen tu nombramiento y se extienden bastante.",
      "line": "(déjales terminar, y luego calla)",
      "why": "La corrección suele ser lo más detallado que van a decir. Interrumpirla para disculparte por haber fallado la desperdicia."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Dices que suena a que fue decepcionante, y contestan: no, decepcionante exactamente no. ¿Y ahora?",
      "options": [
        { "text": "Perdona, no quería ponerte palabras en la boca.", "correct": false, "note": "Disculparse convierte la suposición en una transgresión. Además les corta la corrección, que era la parte útil." },
        { "text": "Decepcionante no. ¿Qué se acerca más?", "correct": true, "note": "Usa su corrección y pide la palabra mejor. Esto suele producir lo más preciso y revelador que dicen." },
        { "text": "Vale. ¿Y qué pasó después?", "correct": false, "note": "Sigue adelante y tira el momento. Estaban a punto de darte la versión exacta." },
        { "text": "¿En serio? Desde aquí sonaba decepcionante.", "correct": false, "note": "Defender la suposición la convierte en una discusión sobre sus propios sentimientos, que no puedes ganar ni deberías querer." }
      ],
      "explain": "La corrección es el premio. Coge su palabra nueva y úsala en vez de disculparte por no haberla tenido ya."
    },
    {
      "prompt": "Te has equivocado dos veces seguidas sobre lo mismo. ¿Qué significa eso?",
      "options": [
        { "text": "Sigue suponiendo. La tercera acierta.", "correct": false, "note": "Dos fallos en la misma dirección no es mala suerte, es no estar escuchando, y una tercera lo hace evidente." },
        { "text": "Déjalo y sigue lo que han dicho de verdad.", "correct": true, "note": "Dos fallos significan que tu lectura de la situación está torcida. Vuelve a sus palabras, que llevan ahí todo el rato." },
        { "text": "Deja de suponer y pregúntaselo sin rodeos.", "correct": false, "note": "Mejor que una tercera suposición, y les pasa a ellos el trabajo de explicarse después de haberles leído mal dos veces." },
        { "text": "Discúlpate por haberles leído mal.", "correct": false, "note": "Convierte tu imprecisión en un momento que ellos tienen que gestionar." }
      ],
      "explain": "Una vez es atención. Dos significa que trabajas con una imagen equivocada, y la solución son sus palabras, no otra suposición."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "guessed_anyway", "label": "Arriesgaste una suposición", "description": "Ofreciste un nombramiento en vez de quedarte a salvo en los hechos." },
      { "key": "held_it_loosely", "label": "Lo sostuviste flojo", "description": "Formulaste la suposición para que corregirla fuera fácil y no violento para nadie." },
      { "key": "took_the_correction", "label": "Usaste la corrección", "description": "Cogiste la palabra mejor de la otra persona y la usaste en vez de disculparte o defenderte." },
      { "key": "did_not_repeat", "label": "No fallaste dos veces", "description": "Ajustaste tras la corrección en lugar de volver a fallar en la misma dirección." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "La cocina de un piso compartido, ya de noche. El amigo de tu compañero de piso espera a que llegue.",
    "partner": {
      "name": "Tobi",
      "role": "un amigo de tu compañero de piso, esperando",
      "personality": "Preciso con el lenguaje y disfruta cuando le piden encontrar la palabra exacta. Corrige un nombramiento equivocado con extensión en vez de ofenderse, siempre que se lo ofrezcan con suavidad.",
      "mood": "Sin prisa, algo hablador.",
      "openness": 4
    },
    "opening_beat": "Tobi menciona que se bajó de algo importante en el último momento hace unas semanas, y no dice cómo se siente al respecto.",
    "success_looks_like": "La persona supone la emoción, recibe la corrección, la coge y sigue adelante con la palabra mejor de Tobi.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "El primer nombramiento que ofrezcan siempre está un poco equivocado. Corrígelo con calidez y aporta una palabra más precisa.",
      "Si cogen tu palabra corregida y se quedan con ella, ábrete bastante.",
      "Si se disculpan por suponer o defienden la suposición equivocada, ponte más reservado y menos concreto."
    ]
  }$j$::jsonb,
  $md$Hoy, supón a propósito una emoción de la que no estés seguro. Deja que te corrijan y usa su palabra. Anota qué supusiste y por qué lo cambiaron.$md$,
  $j${
  "turns": [
    { "instruction": "Supón la emoción que hay debajo de lo que han dicho, aunque no estés seguro." },
    { "instruction": "Te han corregido. Coge la palabra que han usado y devuélvesela." },
    { "instruction": "Sigue desde su corrección en vez de defender la suposición." }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('listening-and-labeling', 5,
  'Escucha lo que dicen dos veces',
  $md$La gente te dice lo que le importa repitiéndolo, y casi nadie se da cuenta.

A lo largo de diez minutos alguien volverá dos o tres veces al mismo asunto, muchas veces con otra ropa. La casa, luego el barrio, luego el trayecto: tres temas, una preocupación. Aquello a lo que vuelven es lo que tienen vivo, hayan decidido o no hablar de ello directamente.

**La jugada:** sigue lo que se repite, y nombra el patrón en vez del caso concreto.

*No paras de volver a la mudanza.* Esa frase suele caer más fuerte que cualquier nombramiento suelto, porque demuestra que escuchabas la conversación entera y no la frase que tenías delante. Además desarma un poco, de una forma que a la gente normalmente le gusta.

Guárdatela. Una vez en una conversación impresiona. Dos es vigilancia.$md$,
  $j$[
    {
      "situation": "Han mencionado a su hermano tres veces en historias sin relación.",
      "line": "Tu hermano ha salido ya unas cuantas veces.",
      "why": "Nombra el patrón sin interpretarlo. La interpretación la ponen ellos, y suele ser lo más interesante de la conversación."
    },
    {
      "situation": "El trabajo se ha colado otra vez en una conversación que iba de unas vacaciones.",
      "line": "No paramos de volver al trabajo. ¿Es de esos meses?",
      "why": "Se incluye con no paramos, lo que lo suaviza de observación sobre ellos a algo que habéis notado los dos."
    },
    {
      "situation": "Han mencionado dos veces que están cansados, las dos de pasada.",
      "line": "Es la segunda vez que dices que estás cansado.",
      "why": "Llano y concreto. Los incisos son donde la gente pone las cosas que medio quiere que recojas."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "En quince minutos alguien ha mencionado su antiguo piso, su antiguo trayecto y un antiguo compañero, todo con cariño. ¿Cuál es el movimiento más fuerte?",
      "options": [
        { "text": "Preguntar algo sobre el antiguo compañero.", "correct": false, "note": "Razonable, pero trata el tercer caso como un tema en vez de como prueba de un patrón." },
        { "text": "Preguntar si prefería vivir allí.", "correct": false, "note": "Más cerca, porque intuye el tema, pero estrecha una nostalgia amplia a una sola pregunta práctica." },
        { "text": "Decir algo sobre tu propio piso antiguo.", "correct": false, "note": "La reciprocidad vale mucho y en general es un buen movimiento, pero aquí pisa algo que claramente están rodeando." },
        { "text": "Señalar que la vida de antes no para de aparecer.", "correct": true, "note": "Nombra el patrón en vez de un caso suelto. Llevan quince minutos rodeando algo, y esto les da la entrada para decirlo." }
      ],
      "explain": "Sigue lo que se repite a lo largo de una conversación entera. Nombrar el patrón cae más fuerte que responder a cualquiera de sus casos."
    },
    {
      "prompt": "¿Qué hace que nombrar un tema recurrente caiga bien y no mal?",
      "options": [
        { "text": "Decir qué crees que significa sobre ellos.", "correct": false, "note": "Aquí es donde se vuelve desagradable. Nombrar el patrón es un regalo; interpretarlo es un diagnóstico." },
        { "text": "Esperar a que lo mencionen una cuarta vez.", "correct": false, "note": "Para entonces es evidente para los dos y la observación ha perdido el filo." },
        { "text": "Nombrar lo que se ha repetido y parar ahí.", "correct": true, "note": "Te has dado cuenta, que halaga, y el significado lo ponen ellos, que es la parte interesante." },
        { "text": "Preguntar por qué lo sacan tanto.", "correct": false, "note": "La misma observación formulada como una exigencia de explicación." }
      ],
      "explain": "Nombra la repetición, y para. En cuanto la interpretas, has dejado de escuchar y has empezado a evaluar."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "tracked_across", "label": "Escuchaste la conversación entera", "description": "Notaste un tema repitiéndose en vez de responder solo a la última frase." },
      { "key": "named_the_pattern", "label": "Nombraste el patrón", "description": "Señalaste la repetición en sí en vez de preguntar otra cosa sobre un caso." },
      { "key": "no_interpretation", "label": "No interpretaste de más", "description": "Nombraste lo que se repetía sin decirle a la otra persona qué significaba sobre ella." },
      { "key": "used_it_once", "label": "Lo usaste con moderación", "description": "Lo hiciste una vez en lugar de ir narrándole a la otra persona cómo es." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "La fiesta de inauguración de un amigo. Llevas un rato hablando a ratos con la misma persona, saltando de tema en tema.",
    "partner": {
      "name": "Sol",
      "role": "alguien a quien te presentaron antes esta noche",
      "personality": "Habladora y de temas amplios, y rodea un asunto una y otra vez sin darse cuenta. Se sorprende un momento y luego se alegra cuando alguien lo nombra.",
      "mood": "Sociable, con un par de copas.",
      "openness": 4
    },
    "opening_beat": "Sol te está contando una escapada de fin de semana, y menciona de pasada que la organizó entera su hermana, que es lo típico.",
    "success_looks_like": "La persona nota que la hermana se repite en varias historias sin relación y nombra el patrón, y Sol dice aquello que llevaba rato rodeando.",
    "constraints": [
      "Mantente en el personaje. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Mete a tu hermana en al menos tres historias distintas, siempre de pasada y sin detenerte en ello.",
      "Si nombran la repetición, sorpréndete un momento y luego habla de ello con sinceridad.",
      "Si solo preguntan por las historias sueltas, sigue cambiando de tema y deja a la hermana incidental."
    ]
  }$j$::jsonb,
  $md$Hoy, en una conversación más larga, sigue aquello a lo que la otra persona vuelve. Nombra el patrón una vez. Anota qué se repetía y cómo reaccionaron.$md$,
  null);
