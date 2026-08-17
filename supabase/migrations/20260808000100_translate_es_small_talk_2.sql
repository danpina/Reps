-- Spanish: Small talk, track 1 — the remaining four lessons.
--
-- Migration 99 carried the topic, the eight track headings and lesson one.
-- This finishes the track.
--
-- Two word lists are rewritten rather than translated, which is the first
-- place in the curriculum where that distinction bites:
--
--   Lesson 2 wants the reader to point at the thing they are both inside, and
--   the English list is lift/floor/button/stairs/doors. In Spanish that is
--   ascensor, planta, botón, escaleras, puertas — and "piso" has to be in
--   there too, because half of Spain says piso where the other half says
--   planta. Accents are safe to author now: the checker folds them, so botón
--   and boton both match.
--
--   Lesson 3 forbids anything specific to the ceramics class, so that the
--   prepared line is portable. Translating clay and kiln gives barro and
--   horno, but the Spanish list also needs "torno" — the wheel — which is the
--   first word a Spanish speaker reaches for in that room and has no
--   equivalent in the English list.
--
-- Word counts are the other thing to watch: Spanish runs longer than English
-- for the same thought, so the max_words ceilings were checked against the
-- model answers rather than copied across.

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

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('before-you-speak', 2,
  'No hace falta que seas interesante',
  $md$La creencia que corta más conversaciones antes de empezar es que necesitas algo que merezca la pena decir.

No lo necesitas. El listón no es ser interesante. El listón es que sea verdad y fácil de contestar. Casi todas las conversaciones que has disfrutado empezaron con un comentario tan corriente que ninguno de los dos sabría repetirlo ahora.

**La jugada:** di la cosa corriente y verdadera en lugar de esperar a la buena.

Esperar tiene un coste que nadie contabiliza. Mientras compones, el momento se cierra: la cola avanza, los auriculares vuelven a su sitio, habla otro. La frase corriente dicha ahora gana a la frase buena dicha nunca, y gana con holgura a la frase buena dicha treinta segundos tarde, que llega con un peso extraño encima.

Hay una segunda razón y es la mejor. Un comienzo ingenioso pide ser admirado. Uno corriente pide ser contestado. Solo uno de los dos es una invitación.$md$,
  $j$[
    {
      "situation": "Una reunión empieza tarde y estás sentado al lado de alguien que no conoces.",
      "line": "Van con retraso.",
      "why": "Tres palabras, completamente obvias, y casi imposibles de no contestar. Nadie ha pensado nunca menos de alguien por decir lo evidente en voz alta."
    },
    {
      "situation": "Los dos esperáis el mismo ascensor.",
      "line": "Este va lento.",
      "why": "No hay nada que admirar ni nada con lo que discrepar, y por eso funciona. Pide una respuesta, no un veredicto."
    },
    {
      "situation": "Se te ha ocurrido algo mucho mejor y el momento lleva quince segundos abierto.",
      "line": "(di la corriente, ya)",
      "why": "La frase mejor vale menos que los segundos que estás gastando en ella. Este es el cambio que casi todo el mundo hace al revés."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Estás en la barra esperando a que te atiendan, al lado de alguien. ¿Qué frase te sirve más?",
      "options": [
        { "text": "Empiezo a sospechar que este bar es un experimento sobre la paciencia.", "correct": false, "note": "Buena frase, y llega pidiendo que la aprecien. Ahora esa persona tiene que producir algo igual de bueno o sentir que ha dejado caer el intercambio." },
        { "text": "Nada, hasta que se te ocurra algo mejor.", "correct": false, "note": "La opción más habitual y la única que garantiza que no pase nada. El momento se cierra mientras trabajas." },
        { "text": "Está petado hoy.", "correct": true, "note": "Corriente, verdadera y contestable al instante. No les pide nada salvo que estén de acuerdo, y estar de acuerdo ya es un turno." },
        { "text": "¿Vienes mucho por aquí?", "correct": false, "note": "Sirve, y es pedirle información a un desconocido en vez de un comentario sobre algo en lo que estáis los dos." }
      ],
      "explain": "Verdadero y fácil de contestar gana a ingenioso siempre. Una frase ingeniosa pide admiración; una corriente pide respuesta."
    },
    {
      "prompt": "¿Por qué esperar a una frase mejor suele empeorar las cosas?",
      "options": [
        { "text": "Las frases mejores no suelen ser mejores de verdad.", "correct": false, "note": "A veces cierto y no es el asunto. Incluso una frase genuinamente mejor pierde contra la corriente que se dijo a tiempo." },
        { "text": "Pareces indeciso.", "correct": false, "note": "Nadie te está mirando decidir. El coste es la apertura perdida, no la impresión." },
        { "text": "Se te olvidará la frase antes de decirla.", "correct": false, "note": "Un problema práctico menor al lado del de verdad, que es que la apertura ya no está." },
        { "text": "El momento se cierra, y una frase tardía pesa más que una temprana.", "correct": true, "note": "Las dos mitades son ciertas. Las aperturas caducan, y un comentario que llega tras una pausa visible tiene que justificar la pausa además de a sí mismo." }
      ],
      "explain": "El cambio no es ingenioso contra corriente. Es corriente ahora contra ingenioso probablemente nunca."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_the_plain_one", "label": "Dijiste lo corriente", "description": "Elegiste un comentario verdadero y anodino en vez de una frase que había que trabajar." },
      { "key": "went_early", "label": "Fuiste pronto", "description": "Hablaste mientras la apertura seguía ahí, no después de componer." },
      { "key": "answerable", "label": "Fácil de contestar", "description": "Dejaste algo con lo que la otra persona podía estar de acuerdo en cuatro palabras." },
      { "key": "no_performance", "label": "No actuaste", "description": "Evitaste una frase que pedía admiración en vez de respuesta." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "El ascensor de un edificio de oficinas, subiendo seis plantas, a media mañana. Ha entrado otra persona contigo.",
    "partner": {
      "name": "Ruth",
      "role": "alguien que trabaja en otra planta",
      "personality": "Agradable y sin prisa. Responderá a un comentario corriente con una respuesta corriente, que es todo lo que hace falta.",
      "mood": "Bien. Con un café y un portátil.",
      "openness": 3
    },
    "opening_beat": "Las puertas se cierran. Ruth mira el indicador de planta y después, un segundo, a ti.",
    "success_looks_like": "La persona dice algo llano en los primeros segundos y le responden con normalidad.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Recibe un comentario corriente con calidez y normalidad. No exijas ingenio para implicarte.",
      "El trayecto es corto. Responde con una frase.",
      "Si no dice nada, no digas nada. El silencio forma parte de lo que enseña la lección."
    ]
  }$j$::jsonb,
  $md$Hoy, empieza una conversación con la cosa verdadera más corriente que se te ocurra. No la mejores a propósito. Anota qué dijiste y qué te contestaron.$md$,
  $j${
  "says": "Las puertas se cierran. Ruth mira el indicador de planta y después, un segundo, a ti.",
  "model": {
    "line": "Este ascensor no tiene prisa hoy.",
    "why": "Seis palabras corrientes sobre la cosa en la que estáis los dos. No hay nada que admirar, y justo por eso es fácil de contestar."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Señala la cosa en la que estáis los dos", "words": ["ascensor", "lento", "planta", "piso", "botón", "escaleras", "puertas", "sube"] },
    { "kind": "no_question", "requirement": "Dilo, no lo preguntes" },
    { "kind": "max_words", "requirement": "Diez palabras como mucho — lo corriente es el objetivo", "n": 10 }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('before-you-speak', 3,
  'Decide la frase antes de necesitarla',
  $md$Nadie compone bien bajo presión, y el momento en el que intentas abrir es el peor momento disponible para inventar.

La gente que parece natural en esto no está improvisando. Tiene tres o cuatro frases que ha usado cien veces, y no está pensando en las palabras en absoluto — que es precisamente por lo que puede prestar atención a la persona.

**La jugada:** decide con qué vas a abrir antes de estar en la sala, no mientras estás de pie dentro de ella.

Con dos o tres basta, y tienen que ser portátiles: sobre la situación y no sobre la persona, para que funcionen en cualquier sitio. *Vaya cola. Otra vez van con retraso. Es mi primera vez aquí.* No estás memorizando un guion. Estás quitando de en medio la única tarea que compite con escuchar.

Este es el consejo menos romántico de la aplicación y el más fiable. La preparación es lo que parece el valor visto desde fuera.$md$,
  $j$[
    {
      "situation": "El jueves vas a un evento donde no conocerás casi a nadie.",
      "line": "Es mi primera vez en uno de estos.",
      "why": "Funciona en cualquier sala, invita a la misma confesión de vuelta, y se puede decir sin pensar. Decidida el martes, no cuesta nada el jueves."
    },
    {
      "situation": "La semana que viene empiezas una clase o un curso.",
      "line": "¿Has hecho esto antes o somos nuevos los dos?",
      "why": "Portátil en cualquier curso al que haya asistido nadie. Una frase preparada no es menos sincera por estar preparada; simplemente está disponible."
    },
    {
      "situation": "Tienes una frase lista y se te ocurre algo mejor al abrir la boca.",
      "line": "(usa la que tenías)",
      "why": "La frase preparada ya está fuera. Cambiarla en el último segundo te devuelve al estado de componer que la preparación existía para evitar."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál de estas es la frase más útil que tener preparada?",
      "options": [
        { "text": "Otra vez van con retraso.", "correct": true, "note": "Portátil. Sirve en una reunión, una clase, un concierto y la sala de espera del médico, así que puedes llevarla a todas partes y no tener que elegir nunca." },
        { "text": "Qué chaqueta más interesante.", "correct": false, "note": "Depende de la chaqueta, así que no se puede preparar. Todo lo que sea sobre la persona hay que inventarlo en el momento, que es justo lo que estás evitando." },
        { "text": "¿Y a ti qué te trae por aquí?", "correct": false, "note": "Portátil, y es una pregunta de entrevista en frío. Preparada no tiene por qué significar que suene genérica." },
        { "text": "Llevo toda la semana esperando esto.", "correct": false, "note": "Solo es verdad a veces, y una frase preparada que tienes que comprobar si es cierta no está haciendo su trabajo." }
      ],
      "explain": "Una frase preparada tiene que ser portátil y verdadera casi en cualquier sitio, o vuelves a estar eligiendo bajo presión."
    },
    {
      "prompt": "¿Cuál es la ventaja real de tener el comienzo decidido de antemano?",
      "options": [
        { "text": "Tu comienzo será mejor que uno improvisado.", "correct": false, "note": "Normalmente no lo será, y da igual. La ganancia está en lo que puedes hacer después, no en la frase." },
        { "text": "Te queda atención libre para la persona que tienes delante.", "correct": true, "note": "El premio de verdad. Componer y escuchar usan la misma capacidad, y gastes en la que gastes, la otra se resiente." },
        { "text": "Es menos probable que digas algo embarazoso.", "correct": false, "note": "Una ventaja menor. Casi nadie dice nada embarazoso; simplemente no dice nada." },
        { "text": "Hace que suenes con más seguridad.", "correct": false, "note": "Cómo suenas es un efecto secundario. El mecanismo es que no estás haciendo dos trabajos a la vez." }
      ],
      "explain": "Componer y escuchar compiten por la misma atención. Preparar la frase es como la liberas para la persona."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "was_ready", "label": "Tenías una frase lista", "description": "Abriste con algo decidido de antemano, no montado sobre la marcha." },
      { "key": "portable", "label": "Portátil", "description": "Elegiste una frase que valdría en casi cualquier sala, no atada a esta." },
      { "key": "used_it", "label": "La usaste de verdad", "description": "No cambiaste la frase preparada por algo inventado en el último segundo." },
      { "key": "attention_free", "label": "Escuchaste después", "description": "Gastaste la atención liberada en su respuesta y no en la frase siguiente." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Una clase de cerámica por la tarde a la que no has ido nunca. La gente va buscando sitio en un banco largo compartido y empieza en cinco minutos.",
    "partner": {
      "name": "Malik",
      "role": "alguien que se está colocando dos sitios más allá",
      "personality": "Simpático y algo tímido también. Recibirá encantado un comienzo corriente y no va a empezar él.",
      "mood": "Contento de estar ahí y sin saber dónde se guarda nada.",
      "openness": 4
    },
    "opening_beat": "Malik se sienta, busca dónde dejar la bolsa y acaba dejándola en el suelo.",
    "success_looks_like": "La persona abre con una frase que habría funcionado en cualquier sala, no con una que había que inventar aquí.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Responde con calidez a cualquier comienzo corriente. Se alegra de que alguien haya hablado.",
      "No lleves tú la conversación. Él no habría abierto primero, y por eso sirve como pareja aquí.",
      "Responde con una o dos frases, a la longitud con la que se charla antes de una clase."
    ]
  }$j$::jsonb,
  $md$Elige esta noche dos frases que funcionarían en casi cualquier sala. Usa una mañana sin cambiarla. Anota cuál, dónde, y si te tentó mejorarla.$md$,
  $j${
  "says": "Malik se sienta, busca dónde dejar la bolsa y acaba dejándola en el suelo.",
  "model": {
    "line": "Otra vez van con retraso.",
    "why": "Cinco palabras que valdrían en una clase, una reunión, un concierto o una sala de espera. Que sea portátil es lo que hace que merezca la pena prepararla."
  },
  "checks": [
    { "kind": "forbids_any", "requirement": "Tiene que valer en cualquier sala, no solo en esta", "words": ["barro", "horno", "esmalte", "cerámica", "torno", "delantal", "arcilla", "banco"] },
    { "kind": "max_words", "requirement": "Corta como para decirla sin pensar", "n": 9 }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('before-you-speak', 4,
  'Veinte segundos, y se acabó',
  $md$La disponibilidad caduca. Ves que alguien está libre, pasas treinta segundos decidiendo, y para cuando has decidido está con el móvil, en la caja, o hablando con otra persona.

Esperar no ayuda, y esta es la parte que la gente entiende al revés. El miedo no baja mientras estás ahí parado. Sube. Estar cerca de alguien ensayando un comienzo es lo más incómodo de todo este asunto, y es en lo que casi todo el mundo pasa casi todo su tiempo.

**La jugada:** en cuanto veas una apertura, ve antes de veinte segundos.

Veinte no tiene nada de mágico. Es poco como para no darte tiempo a quitártelo de la cabeza y bastante como para decir una frase que ya tenías. Por eso la lección anterior va primero: con la frase decidida, veinte segundos son generosos. Sin ella, veinte segundos son un ataque de nervios.

Lo que estás entrenando no es la valentía. Es el hueco entre darte cuenta y actuar, que es la única parte de esto que controlas de verdad.$md$,
  $j$[
    {
      "situation": "Alguien de la mesa de al lado deja el móvil boca abajo y levanta la vista.",
      "line": "(ve ya, con la frase que ya tienes)",
      "why": "Móvil abajo y ojos arriba es la apertura más clara que existe, y también la más corta. Treinta segundos después han encontrado otra cosa que hacer."
    },
    {
      "situation": "Llevas un minuto decidiendo y la sensación va a peor, no a mejor.",
      "line": "(esto es la señal, no un motivo para esperar más)",
      "why": "Que la incomodidad suba mientras esperas es la forma normal que tiene esto. La gente lo lee como una advertencia y es simplemente el precio de quedarse quieto."
    },
    {
      "situation": "Contaste hasta veinte y el momento se ha cerrado de verdad.",
      "line": "(déjalo y coge el siguiente)",
      "why": "Una apertura cerrada no es un fracaso, es información sobre lo que tardaste. La siguiente suele estar a cuatro minutos."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Ves una apertura y dudas. ¿Qué le pasa al miedo mientras esperas?",
      "options": [
        { "text": "Se calma en cuanto lo has pensado bien.", "correct": false, "note": "Esta es la creencia que produce el pasar de largo. Pensarlo no tiene final natural, así que esa calma no llega nunca." },
        { "text": "Se queda más o menos igual.", "correct": false, "note": "No se queda. La anticipación es donde vive casi toda la incomodidad de esto, y por eso ir pronto cuesta menos que ir tarde." },
        { "text": "Sube, y la apertura se cierra a la vez.", "correct": true, "note": "Las dos cosas, y por eso esperar es la peor opción disponible. Pagas más y compras menos cuanto más rato sigues ahí." },
        { "text": "Depende de lo bueno que sea tu comienzo.", "correct": false, "note": "El comienzo apenas participa. La incomodidad es por la espera, no por las palabras." }
      ],
      "explain": "Esperar cuesta más y compra menos. La anticipación es la parte cara, y es la única que puedes acortar."
    },
    {
      "prompt": "¿Por qué funcionan los veinte segundos si tienes una frase preparada?",
      "options": [
        { "text": "Una frase preparada se dice más rápido.", "correct": false, "note": "Decirla lleva los mismos tres segundos en cualquier caso. El ahorro está entero en lo que pasa antes." },
        { "text": "Hace menos probable que dudes.", "correct": false, "note": "Vas a dudar igual. La regla hace que la duda sea corta, no que desaparezca." },
        { "text": "Evita que elijas el comienzo equivocado.", "correct": false, "note": "Aquí apenas existe el comienzo equivocado. Solo existe el que dijiste y el que no." },
        { "text": "Los veinte segundos son para ir, no para escribir.", "correct": true, "note": "Con la frase decidida, veinte segundos sobran para moverte y hablar. Sin ella son veinte segundos componiendo contra un reloj, que es peor que no tener regla." }
      ],
      "explain": "La regla y la frase preparada son una sola herramienta en dos partes. Cualquiera de las dos sola es mucho más débil."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "noticed", "label": "Viste la apertura", "description": "Registraste que había disponibilidad en vez de esperar a que te hablaran." },
      { "key": "went_fast", "label": "Fuiste rápido", "description": "Te moviste en unos veinte segundos en lugar de deliberar." },
      { "key": "used_the_line", "label": "Llevabas algo que decir", "description": "Llegaste con una frase en vez de componer por el camino." },
      { "key": "no_rehearsal", "label": "No ensayaste", "description": "Evitaste quedarte cerca trabajándotelo, que es donde vive la incomodidad." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "La terraza de un bar en una tarde templada. Alguien está de pie al final de un banco con una copa, solo, y acaba de guardar el móvil.",
    "partner": {
      "name": "Jonty",
      "role": "alguien que espera a unos amigos que llegan tarde",
      "personality": "Fácil de tratar y algo aburrido. Encantado de que le hablen y no va a empezar él.",
      "mood": "Matando el rato.",
      "openness": 4
    },
    "opening_beat": "Jonty se guarda el móvil, mira alrededor de la terraza y da un sorbo.",
    "success_looks_like": "La persona abre pronto en vez de dar vueltas, y se encuentra con alguien que siempre iba a estar receptivo.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Está receptivo desde la primera frase. Esta escena no va de una pareja difícil.",
      "No abras tú la conversación bajo ningún concepto.",
      "Responde corto y fácil, a la longitud de quien charla mientras espera."
    ]
  }$j$::jsonb,
  $md$Hoy, cuando veas que alguien está disponible, cuenta hasta veinte y ve antes de llegar. Anota cuánto tardaste de verdad, con honestidad.$md$,
  $j${
  "beats": [
    {
      "situation": "Alguien de la mesa de al lado deja el móvil boca abajo y levanta la vista. Tienes una frase lista. Eso fue hace unos cuarenta segundos y sigues sentado.",
      "prompt": "¿Qué haces?",
      "options": [
        { "text": "Ir ya, con la frase que ya tenías.", "correct": true, "note": "Tarde no es perdido. A los cuarenta segundos la apertura es más estrecha y sigue abierta, y cada segundo más se gasta en empeorarla, no en hacerla más segura." },
        { "text": "Esperar a un momento más limpio.", "correct": false, "note": "No viene ningún momento más limpio, y la espera es la parte cara. Esta es la decisión que se convierte en pasar de largo." },
        { "text": "Pensar algo mejor, ya que has tardado tanto.", "correct": false, "note": "Ahora estás componiendo contra un reloj, que es peor que cualquiera de las dos cosas por separado." },
        { "text": "Dejarlo. Se te ha pasado.", "correct": false, "note": "Cuarenta segundos es tarde, no perdido. Tratarlo como perdido es una decisión, y es la que te enseña a ser más lento la próxima vez." }
      ]
    },
    {
      "situation": "Viste una apertura, dudaste, y esa persona ha empezado ahora una conversación con otra.",
      "prompt": "¿Cuál es la lectura útil?",
      "options": [
        { "text": "No iba a tener interés de todas formas.", "correct": false, "note": "Cómodo y falso. Estaba disponible, y estaba disponible para quien hablara primero." },
        { "text": "Fuiste lento, y lo que hay que arreglar es el hueco, no el valor.", "correct": true, "note": "La lectura correcta y la menos castigadora. La variable que controlas es cuánto tardas entre ver y moverte, y eso sí se entrena." },
        { "text": "Todavía no eres lo bastante valiente para esto.", "correct": false, "note": "La valentía no es la variable. Alguien con los mismos nervios y un hueco más corto habría tenido esa conversación." },
        { "text": "Necesitas un comienzo mejor para la próxima.", "correct": false, "note": "El comienzo no llegó a probarse. Mejorarlo no arregla nada de lo que pasó de verdad." }
      ]
    }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('before-you-speak', 5,
  'La que dejaste pasar',
  $md$Todo el que trabaja esto tiene el mismo suceso recurrente. Una apertura clara, vista, no cogida, dejada pasar — y luego una pequeña bronca privada durante el resto de la tarde.

La bronca no es el problema. El problema es lo que enseña el pasar de largo. Cada vez que decides no hacerlo, te entregas la prueba de que la situación era realmente peligrosa y de que evitarla fue lo correcto. Lo que se acumula es la evitación. Una conversación sosa no te enseña casi nada; un pasar de largo te enseña algo falso, y lo enseña muy bien.

**La jugada:** cuando dejes pasar una, coge la siguiente que se te ponga por delante, por pequeña que sea.

Ni la misma persona, ni una versión mejor del mismo momento. Cualquiera: quien te cobra, alguien en el ascensor, quien acabe sentándose a tu lado. La conversación no es el objetivo. El objetivo es que lo último que hiciste fue ir y no dejarlo, porque ese es el dato que te quedas.

Vas a dejar pasar muchas. Eso está bien y no es lo que hay que arreglar. Lo que hay que arreglar es que un pasar de largo sea lo último del día.$md$,
  $j$[
    {
      "situation": "Viste una apertura evidente en la comida y no la cogiste.",
      "line": "(dile algo a la siguiente persona que te atienda)",
      "why": "Pequeño, sin riesgo y completamente suficiente. La reparación no va de dificultad, va de que la evitación no se quede como última entrada del día."
    },
    {
      "situation": "Has dejado pasar tres seguidas y sientes que el día está perdido.",
      "line": "(coge la cuarta — la cuenta da igual)",
      "why": "Tres pasadas y un intento es un buen día. Tres pasadas y nada es el día que hace más difícil el de mañana."
    },
    {
      "situation": "Dejaste pasar una y ahora estás montando la explicación de por qué fue sensato.",
      "line": "(puede que lo fuera. Coge la siguiente igualmente.)",
      "why": "A veces la lectura era correcta y el momento sí era malo. No cambia nada de lo que toca hacer ahora, y por eso no merece la pena juzgarlo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué dejar pasar una apertura es peor para ti que un comienzo que se queda en nada?",
      "options": [
        { "text": "Te enseña que la situación era peligrosa; un comienzo sosa te enseña que no lo era.", "correct": true, "note": "Esta es la lección entera. La evitación es lo único aquí que hace más difícil el intento siguiente, y lo hace en silencio." },
        { "text": "Es una oportunidad desperdiciada de conocer a alguien.", "correct": false, "note": "Cierto y mucho menos importante. Las aperturas son comunes; lo que aprendiste al saltarte esta es lo que te llevas a la semana que viene." },
        { "text": "Hace que te sientas mal contigo.", "correct": false, "note": "Sí, y sentirse mal no es el mecanismo. El daño es la lección que se llevó tu cuerpo, no el humor." },
        { "text": "La gente nota que dudas.", "correct": false, "note": "No lo nota, y daría igual si lo notara. Esto es enteramente entre tú y la siguiente apertura." }
      ],
      "explain": "Un comienzo sosa es una corrección pequeña. Un pasar de largo es una lección, y es la lección equivocada bien aprendida."
    },
    {
      "prompt": "Dejaste pasar una apertura hace una hora. ¿Cuál es la reparación más útil?",
      "options": [
        { "text": "Volver y coger la apertura original.", "correct": false, "note": "Normalmente ya no está, y volver a ella una hora después es mucho más difícil que lo que evitaste. Así una reparación pequeña se vuelve imposible." },
        { "text": "Decirle algo a la siguiente persona que puedas, por trivial que sea.", "correct": true, "note": "Cualquiera, cualquier cosa. La reparación va de lo que hiciste al final, no de igualar la dificultad de lo que te saltaste." },
        { "text": "Averiguar por qué no lo hiciste.", "correct": false, "note": "Ya sabes por qué. Analizarlo aquí es una forma cómoda de pasar la tarde sin hacer la cosa." },
        { "text": "Nada. Anótalo y empieza limpio mañana.", "correct": false, "note": "Mañana empieza donde acabó hoy. Terminar en el pasar de largo es justo lo que hace más pesado el mañana." }
      ],
      "explain": "Coge la siguiente, no la que perdiste. Lo que importa es en qué terminó el día."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "noticed_the_pass", "label": "Viste el pasar de largo", "description": "Registraste la apertura evitada en vez de dejarla pasar sin mirarla." },
      { "key": "took_the_next", "label": "Cogiste la siguiente", "description": "Hablaste con alguien, quien fuera, en vez de esperar un momento equivalente." },
      { "key": "kept_it_small", "label": "Mantuviste pequeña la reparación", "description": "Elegiste una apertura sin riesgo en lugar de igualar lo que te saltaste." },
      { "key": "no_self_audit", "label": "Te saltaste el análisis", "description": "No gastaste el tiempo de la reparación averiguando por qué no ocurrió la primera." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "La barra de una cafetería, diez minutos después de que dejaras pasar una apertura evidente en la mesa de la ventana.",
    "partner": {
      "name": "Robin",
      "role": "quien te atiende",
      "personality": "Ocupado y perfectamente agradable. Tiene treinta segundos y los va a usar.",
      "mood": "A mitad de turno y bien.",
      "openness": 3
    },
    "opening_beat": "Robin deja tu café en la barra y se gira a limpiar el vaporizador.",
    "success_looks_like": "La persona le dice algo pequeño a alguien fácil, y el día deja de terminar en la evitación.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Sé breve. Esto es un intercambio de treinta segundos sobre una barra, no una conversación.",
      "Sé cálido y algo apurado. La idea es que esto no le cueste casi nada.",
      "No alargues el intercambio más allá de unas pocas líneas."
    ]
  }$j$::jsonb,
  $md$Hoy, cuando dejes pasar una apertura — y lo harás — coge la siguiente en diez minutos, con quien sea. Anota las dos: la que te saltaste y la que cogiste.$md$,
  $j${
  "beats": [
    {
      "situation": "Viste una apertura evidente en la comida, decidiste que no, y llevas desde entonces algo molesto contigo.",
      "prompt": "¿Qué merece la pena hacer?",
      "options": [
        { "text": "Averiguar qué te frenó.", "correct": false, "note": "Ya sabes qué te frenó. Analizarlo es una forma cómoda de pasar la tarde sin hacer la cosa." },
        { "text": "Ponerte un objetivo más difícil mañana para compensar.", "correct": false, "note": "Subir el precio después de un fallo hace el intento siguiente menos probable, no más. La reparación tiene que ser más fácil que lo que evitaste." },
        { "text": "Decirle algo a la siguiente persona que puedas, por pequeño que sea.", "correct": true, "note": "La reparación va de lo que haces ahora, no de igualar lo que te saltaste. Una palabra a quien te cobra cuenta entera." },
        { "text": "Nada. Una apertura saltada no es importante.", "correct": false, "note": "Una no lo es, y la lección que enseña sí. Terminar el día en la evitación es lo que hace más pesado el mañana." }
      ]
    },
    {
      "situation": "Es el final del día. Dejaste pasar tres aperturas y cogiste una, con el hombre que te vendió el billete de tren.",
      "prompt": "¿Qué tal ha ido el día?",
      "options": [
        { "text": "Mal. Evitaste tres y sacaste un intercambio trivial.", "correct": false, "note": "Esta es la aritmética que hace que la gente lo deje. Nadie ha mejorado en esto puntuándose el día sobre cuatro." },
        { "text": "Neutro. Una taquilla no cuenta del todo.", "correct": false, "note": "Cuenta enteramente. El sistema nervioso no puntúa el sitio, registra si fuiste." },
        { "text": "Imposible decirlo sin saber qué tal fue la conversación.", "correct": false, "note": "Qué tal fue es la parte menos importante. Lo que se entrena es ir." },
        { "text": "Bien. Lo último que hiciste fue ir.", "correct": true, "note": "Tres pasadas y un intento es un buen día. La cuenta no es la medida; lo es en qué terminó el día." }
      ]
    }
  ]
}$j$::jsonb);
