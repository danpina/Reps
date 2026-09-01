-- Spanish: El trabajo, track 6 — Pedir dinero.
--
-- Conventions as migration 121. Salary figures rescaled to Spain, as in the
-- Interviews money track: the English uses fifty-four moving to sixty-two
-- thousand pounds; the Spanish uses cuarenta y dos moving to cuarenta y ocho
-- mil euros, keeping a comparable proportional rise for a reader in Spain
-- rather than a number that reads as fantasy or as a literal currency
-- conversion.
--
-- Lesson 2 has no rehearsal_spec in English and none here — it is a scene,
-- and the point of the lesson (two seconds of silence) is not something a
-- text check can grade.

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

select pg_temp.es_lesson('asking-for-money', 1,
  'Pide un número, no una conversación',
  $md$Casi nadie deja de conseguir una subida. Deja de pedirla, y luego lee el resultado como una respuesta.

La forma más común es pedir una charla en vez de dinero. *Quería hablar de mi progresión.* *Esperaba que pudiéramos mirar en algún momento mi retribución.* Las dos se sienten como la entrada responsable y profesional, y las dos le entregan a tu jefe un tema en vez de una decisión, y los temas se agendan, se aplazan y acaban absorbidos.

**La jugada:** nombra la cifra.

*Me gustaría pasar a cuarenta y ocho.* Eso es algo a lo que alguien puede decir que sí, que no, o contraofertar. Convierte un asunto abierto en una decisión con forma, y una decisión con forma se toma.

Nombrarla además le hace algo a la conversación que no puedes conseguir de ninguna otra manera: fija el ancla. Si no dices nada, el ancla es lo que ya estuvieran pensando ofrecer, y todo lo que sigue es una discusión sobre la distancia entre su número y su número. El tuyo tiene que existir antes de que se le pueda salir al paso.

El miedo obvio es equivocarse: pedir demasiado y quedar en ridículo, o pedir poco y conseguirlo. Pedir demasiado casi nunca es un problema: a los jefes no les baja el concepto que tienen de alguien por querer dinero, contraofertan. Pedir poco es el riesgo real, y es en el que se mete de cabeza la gente callada, porque el número que se siente seguro lo elige la parte de ti que está intentando evitar la conversación.

Así que haz primero el trabajo aburrido: averigua qué paga el puesto en otros sitios, pregúntale a gente que te lo vaya a decir, y elige un número que puedas decir en voz alta sin que te cambie la voz. Y luego di ese, no al que te retiras mientras lo estás diciendo.

Si te quedas con una cosa: di un número. Todo lo demás en este tema es lo que pasa después de que haya uno sobre la mesa.$md$,
  $j$[
    {
      "situation": "Quieres más dinero y has reservado la reunión.",
      "line": "Me gustaría pasar a cuarenta y ocho.",
      "why": "Algo a lo que se puede responder que sí, que no, o contraofertar. Un tema se agenda y se absorbe; un número se decide."
    },
    {
      "situation": "Estás a punto de decir que querías hablar de tu retribución.",
      "line": "(eso es un tema, no una decisión)",
      "why": "Les entrega un asunto y quita el ancla de la mesa. Todo lo que sigue es una discusión sobre la distancia entre su número y su número."
    },
    {
      "situation": "Estás eligiendo entre el número que quieres y uno más seguro.",
      "line": "(el seguro lo eligió la parte de ti que está evitando esto)",
      "why": "Pedir demasiado casi nunca es el problema: los jefes contraofertan. Pedir poco es el riesgo en el que se mete de verdad la gente callada."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué un número gana a una conversación?",
      "options": [
        { "text": "Suena más seguro de ti mismo.", "correct": false, "note": "Lo suena, y la seguridad no es el mecanismo." },
        { "text": "Es una decisión que alguien puede tomar.", "correct": true, "note": "Sí, no, o contraoferta. Un tema se agenda y luego se absorbe, que es por lo que tantas conversaciones de progresión no llevan a ningún sitio." },
        { "text": "Se termina antes.", "correct": false, "note": "La velocidad no es el punto, y esta conversación a menudo lleva varias rondas de todos modos." },
        { "text": "Demuestra que te lo has investigado.", "correct": false, "note": "La investigación es lo que hace defendible el número. Nombrarlo es lo que hace que exista." }
      ],
      "explain": "Un tema se absorbe. Un número se responde."
    },
    {
      "prompt": "¿Qué error le sale caro de verdad a la gente?",
      "options": [
        { "text": "Pedir demasiado.", "correct": false, "note": "Eso se contraoferta, no se pierde. A nadie le baja el concepto por querer dinero, y sigues por delante de donde te habría dejado el silencio." },
        { "text": "Pedirlo en el momento equivocado.", "correct": false, "note": "El momento importa y es la lección siguiente. No es lo que hace que el número esté mal." },
        { "text": "Pedir poco.", "correct": true, "note": "El número seguro lo elige la parte de ti que intenta evitar la conversación, y si dicen que sí de inmediato nunca vas a saber qué había disponible." },
        { "text": "Pedirlo sin pruebas.", "correct": false, "note": "Las pruebas importan y llegan después. Un número sin pruebas sigue ganando a ningún número." }
      ],
      "explain": "Elige el número que puedes decir en voz alta sin que te cambie la voz, y di ese."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "a_number", "label": "Nombró una cifra", "description": "Pidió una cantidad en vez de una charla." },
      { "key": "not_low", "label": "No se quedó corto", "description": "Dijo el número real en vez del seguro." },
      { "key": "plain", "label": "Lo dijo con llaneza", "description": "Sin preámbulo, sin disculpa, sin matices alrededor de la cifra." },
      { "key": "prepared", "label": "Sabía de dónde salía", "description": "Tenía un motivo para ese número si se lo preguntaban." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa",
      "mood": "Preparada para tener la conversación.",
      "openness": 4,
      "personality": "Práctica y en absoluto ofendida de que se lo pidan. Actúa sobre un número y archiva un tema para más tarde."
    },
    "setting": "Una reunión que pediste tú, sobre el sueldo. Estás en cuarenta y dos y quieres cuarenta y ocho.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Métete en serio y de forma concreta en cuanto se nombre un número.",
      "Responde a una petición vaga aceptando mirarlo en algún momento, y sigue adelante.",
      "Nunca nombres tú un número primero."
    ],
    "opening_beat": "«Dijiste que querías veinte minutos. Adelante.»",
    "success_looks_like": "La persona nombra una cifra concreta pronto."
  }$j$::jsonb,
  'Hoy, escribe el número que pedirías y dilo en voz alta una vez, a ti mismo o a alguien de confianza. Apunta el número.',
  $j${
    "says": "Dijiste que querías veinte minutos. Adelante.",
    "model": {
      "line": "Me gustaría pasar a cuarenta y ocho.",
      "why": "Una cifra a la que alguien puede decir que sí, que no, o contraofertar. Además fija el ancla: sin un número tuyo, todo lo que sigue es una discusión sobre la distancia entre su número y su número."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["hablar de", "charlar", "en algún momento", "progresión", "revisión salarial", "me preguntaba si", "esperaba que"], "requirement": "Un número, no un tema" },
      { "kind": "max_sentences", "n": 2, "requirement": "Dilo y para" },
      { "kind": "max_words", "n": 25, "requirement": "Sin preámbulo delante de la cifra" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('asking-for-money', 2,
  'Dilo, y luego cállate',
  $md$Esta es la técnica entera, cuesta dos segundos, y casi nadie lo consigue.

**La jugada:** di el número, y luego deja de hablar.

El silencio después de una cifra se siente enorme. Dura unos dos segundos. Lo que lo rellena, si lo rellenas, es siempre alguna versión de un descuento: *…pero claro, ya sé que las cosas están difíciles.* *…o lo que te parezca razonable.* *…vamos, por ahí.* Cada una de esas eres tú negociando contra ti mismo antes de que nadie más haya dicho una palabra, y la otra persona ni siquiera ha tenido ocasión de estar de acuerdo.

Merece la pena decirlo con claridad, porque es la forma más común de que esto salga mal: la gente no pierde la negociación, la cede sin que nadie se lo pida, en la pausa, por incomodidad. La retirada se ofrece antes de que llegue la objeción.

La pausa no es hostilidad y no es una mala señal. A quien acaban de pedirle dinero está haciendo cuentas: cuál es el presupuesto, qué permite la banda, qué haría falta. Eso lleva un momento, y el momento es suyo. Déjalo estar.

En la práctica: di la frase, cierra la boca, y cuenta. Es mucho más fácil si has decidido de antemano que lo vas a hacer, porque en el momento el impulso de hablar es una incomodidad física genuina y no un pensamiento con el que se pueda discutir.

Y si no dicen nada durante más de lo que se siente soportable, la siguiente frase correcta no es una concesión. *Encantado de repasar de dónde sale el número* es neutra y no da nada. Lo que no puedes hacer es mover tu propia cifra antes de que nadie la haya cuestionado.

Si te quedas con una cosa: dos segundos. La primera persona que habla después de un número está negociando contra sí misma, y no tiene por qué ser esa persona tú.$md$,
  $j$[
    {
      "situation": "Has dicho cuarenta y ocho y hay una pausa.",
      "line": "(nada; cuenta)",
      "why": "La pausa son cuentas, no hostilidad. Dura unos dos segundos y es suya."
    },
    {
      "situation": "Estás a punto de añadir «pero ya sé que las cosas están difíciles».",
      "line": "(eso es un descuento que no ha pedido nadie)",
      "why": "Ceder en la pausa es la forma más común de perder esto. La retirada llega antes que la objeción."
    },
    {
      "situation": "El silencio se ha alargado y tienes que decir algo.",
      "line": "Encantado de repasar de dónde sale el número.",
      "why": "Neutra, añade información, y no mueve nada. Lo que no puedes hacer es mover tu propia cifra antes de que la hayan cuestionado."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué es el silencio después de un número?",
      "options": [
        { "text": "Una táctica de negociación.", "correct": false, "note": "A veces, y darlo por hecho hace que respondas a una hostilidad que normalmente no está ahí." },
        { "text": "Alguien haciendo cuentas.", "correct": true, "note": "Presupuesto, banda, qué haría falta. Lleva un momento, el momento es suyo, y dura unos dos segundos." },
        { "text": "Desaprobación.", "correct": false, "note": "Así es como se siente desde dentro, y actuar sobre esa sensación es lo que produce el descuento no pedido." },
        { "text": "Una invitación a justificarlo.", "correct": false, "note": "Si quieren el razonamiento, lo van a pedir. Ofrecerlo dentro de la pausa suele llegar como ponerse a la defensiva." }
      ],
      "explain": "Di el número, cierra la boca, cuenta. La pausa es suya."
    },
    {
      "prompt": "¿Cómo suele perder esto la gente?",
      "options": [
        { "text": "Piden demasiado.", "correct": false, "note": "Eso se contraoferta, no se pierde. No se les tiene en cuenta a las personas querer dinero." },
        { "text": "No pueden justificar la cifra.", "correct": false, "note": "Recuperable, y sale después del número y no en su lugar." },
        { "text": "Les gana la negociación.", "correct": false, "note": "Casi nunca hay negociación. Casi todo esto se decide antes de que discuta nadie." },
        { "text": "Ceden en la pausa, antes de que nadie objete.", "correct": true, "note": "«O lo que te parezca razonable», dicho dentro de dos segundos de incomodidad. La retirada se ofrece sin que nadie la pida." }
      ],
      "explain": "La primera persona que habla después de un número está negociando contra sí misma."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "stopped", "label": "Paró después del número", "description": "No dijo nada dentro de la pausa." },
      { "key": "no_discount", "label": "No ofreció ningún descuento", "description": "No suavizó la cifra sin que se lo pidieran." },
      { "key": "held", "label": "Sostuvo la cifra", "description": "No la movió antes de que se la cuestionaran." },
      { "key": "neutral_fill", "label": "Rellenó un silencio largo con neutralidad", "description": "Si llegó a hablar, añadió información en vez de conceder." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa",
      "mood": "Calculando qué es posible.",
      "openness": 4,
      "personality": "Piensa antes de hablar y se toma unos segundos de verdad. Acepta de inmediato y con gratitud cualquier cifra que la persona baje por su cuenta."
    },
    "setting": "Acabas de decir cuarenta y ocho. Tu jefa todavía no ha respondido.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Haz una pausa antes de tu primera respuesta sustancial, y describe la pausa con llaneza.",
      "Agárrate de inmediato a cualquier suavizado o cifra rebajada y quédate ahí con gratitud.",
      "Responde en serio y de forma concreta si la persona sostiene el número."
    ],
    "opening_beat": "(una pausa; está haciendo las cuentas)",
    "success_looks_like": "La persona no dice nada hasta que responde la jefa."
  }$j$::jsonb,
  'Hoy, pide una cosa y luego no digas nada hasta que te respondan. Cualquier cosa cuenta. Apunta cuánto se sintió la pausa.',
  NULL
);

select pg_temp.es_lesson('asking-for-money', 3,
  'Pídelo antes de que se cierre el presupuesto',
  $md$El momento decide más de esto que la formulación, y casi todo el mundo elige el peor disponible: la evaluación.

Para la evaluación, los números ya están repartidos. Tu jefe no está decidiendo nada en esa sala: está entregando una decisión tomada semanas antes, en una reunión en la que tú no estabas, donde alguien pasó una lista y repartió una cantidad fija. Pedirlo entonces le pone en la posición de defender un resultado que puede que ni siquiera eligiera, y la única respuesta honesta disponible es *esto ya está cerrado para este año*.

**La jugada:** pídelo dos o tres meses antes del ciclo, mientras el número todavía se está formando.

Esa es la ventana en la que un jefe puede hacer algo de verdad: defenderte en la sala, pedir una excepción antes de que se agoten las excepciones, o decirte con claridad qué es posible para que puedas decidir qué hacer con ello. Dos meses antes no es agobiar. Es el único punto en el que pedirlo cambia algo.

Tienes que saber cuándo es el ciclo, y casi nadie lo sabe. Es una pregunta del todo corriente y se puede hacer en cualquier momento: *¿cuándo se toman de verdad las decisiones de sueldo?* A nadie se le ha tenido nunca en menos por preguntarlo, y saberlo convierte esto de una conversación esperanzada en una agendada.

El otro momento que funciona es uno de valor demostrado: justo después de que algo saliera bien, cuando lo que hiciste todavía está fresco en la cabeza de todo el mundo. No como palanca, y sin ninguna amenaza implícita, sino porque la prueba está fresca y tu jefe se lo va a estar repitiendo a otra persona.

Y si te has saltado la ventana del todo, no gastes la petición en un ciclo muerto. Pregunta en su lugar qué tendría que ser verdad para el siguiente y cuándo volver, que es la lección siguiente, y vale muchísimo más que un no que ya sabías que ibas a conseguir.

Si te quedas con una cosa: averigua cuándo se toma la decisión, y adelántate tres meses.$md$,
  $j$[
    {
      "situation": "Tu evaluación es la semana que viene y planeas plantear el sueldo ahí.",
      "line": "(los números se repartieron hace semanas)",
      "why": "Tu jefe está entregando una decisión tomada en una sala en la que tú no estabas. La única respuesta honesta disponible es que esto ya está cerrado para este año."
    },
    {
      "situation": "No sabes cuándo se deciden los sueldos.",
      "line": "¿Cuándo se toman de verdad aquí las decisiones de sueldo?",
      "why": "Una pregunta del todo corriente que se puede hacer en cualquier momento, y convierte una conversación esperanzada en una agendada."
    },
    {
      "situation": "Algo que construiste acaba de salir bien.",
      "line": "(buen momento: la prueba está fresca)",
      "why": "No es palanca. Tu jefe se va a estar repitiendo esta semana lo que pasó a otra persona, y ayuda que tu número esté en la misma conversación."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué la evaluación es el momento equivocado?",
      "options": [
        { "text": "Va de rendimiento, no de dinero.", "correct": false, "note": "Suelen ser la misma reunión. El problema no es el tema." },
        { "text": "Tu jefe está entregando una decisión, no tomándola.", "correct": true, "note": "Los números se repartieron semanas antes en una sala en la que tú no estabas. Pedirlo entonces le obliga a defender un resultado que puede que ni eligiera." },
        { "text": "Hay demasiadas otras cosas que cubrir.", "correct": false, "note": "Un fastidio de calendario más que el motivo por el que falla." },
        { "text": "Parece transaccional.", "correct": false, "note": "No especialmente, y cómo parece no es lo que cierra la puerta." }
      ],
      "explain": "Sé lo bastante pronto como para que tu jefe todavía pueda hacer algo."
    },
    {
      "prompt": "No tienes ni idea de cuándo es el ciclo. ¿Qué haces?",
      "options": [
        { "text": "Calcularlo por cuándo hubo subidas antes.", "correct": false, "note": "Una suposición razonable y sigue siendo suponer. Te lo pueden decir sin más." },
        { "text": "Esperar a que se anuncie.", "correct": false, "note": "Para cuando se anuncia, los números ya están fijados. Así es como acaba la gente preguntando el mes equivocado todos los años." },
        { "text": "Preguntar cuándo se toman las decisiones de sueldo.", "correct": true, "note": "Una pregunta corriente, que se puede hacer en cualquier momento, y a nadie se le ha tenido nunca en menos por hacerla. Convierte una conversación esperanzada en una agendada." },
        { "text": "Preguntarle a un compañero en vez de a tu jefe.", "correct": false, "note": "Bien como segunda fuente, y tu jefe conoce la respuesta real y puede decírtela." }
      ],
      "explain": "Averigua cuándo se toma la decisión, y luego adelántate tres meses."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "early", "label": "Lo pidió antes del ciclo", "description": "Lo planteó mientras el número todavía se estaba formando." },
      { "key": "knew_when", "label": "Sabía cuándo se decide", "description": "Lo averiguó en vez de suponerlo." },
      { "key": "evidence_fresh", "label": "Usó un momento de valor demostrado", "description": "Lo pidió mientras el trabajo todavía estaba fresco." },
      { "key": "no_threat", "label": "No hizo ninguna amenaza", "description": "Usó el momento en vez de la palanca." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa",
      "mood": "Semana normal.",
      "openness": 4,
      "personality": "Responde a las preguntas de proceso con franqueza y se alivia un poco cuando alguien pregunta pronto en vez de en abril."
    },
    "setting": "Un uno a uno normal en un mes sin nada especial. No tienes ni idea de cuándo se decide el sueldo aquí.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con honestidad a las preguntas sobre el ciclo: las decisiones se toman en febrero para abril.",
      "Di con llaneza que no se puede cambiar nada si la persona lo pregunta en abril.",
      "Nunca plantees tú el sueldo."
    ],
    "opening_beat": "«¿Algo más? Tenemos diez minutos.»",
    "success_looks_like": "La persona averigua cuándo se deciden los sueldos y coloca la petición antes."
  }$j$::jsonb,
  'Hoy, averigua cuándo se toman de verdad las decisiones de sueldo donde trabajas. Pregúntale a alguien. Apunta la respuesta.',
  $j${
    "beats": [
      {
        "situation": "Es enero. Las evaluaciones son en abril y quieres más dinero.",
        "prompt": "¿Cuándo lo planteas?",
        "options": [
          { "text": "En la evaluación, que es para lo que está.", "correct": false, "note": "Para abril los números ya están repartidos y tu jefa está entregando una decisión tomada semanas antes en una sala en la que tú no estabas." },
          { "text": "Ahora: pregunta cuándo se deciden y adelántate.", "correct": true, "note": "La ventana en la que un jefe todavía puede defenderte, pedir una excepción antes de que se agoten, o decirte con claridad qué es posible." },
          { "text": "Justo después de la evaluación, para el año que viene.", "correct": false, "note": "Once meses antes no es pronto, es olvido. Dos o tres meses antes del ciclo es la ventana." },
          { "text": "La próxima vez que algo salga bien.", "correct": false, "note": "Un buen momento para la prueba, y todavía tiene que llegar antes de que se fijen los números." }
        ]
      },
      {
        "situation": "Se te ha pasado. Es abril y las decisiones ya están tomadas.",
        "prompt": "¿Qué haces con la reunión?",
        "options": [
          { "text": "Pedirlo igualmente: no cuesta nada.", "correct": false, "note": "Te cuesta la petición. Gastas la conversación difícil en un ciclo que no puede responderla, y consigues un no que ya sabías que llegaba." },
          { "text": "No decir nada y esperar al año que viene.", "correct": false, "note": "Entonces llegas al abril siguiente en esta misma posición, sin haber hecho nada entre medias." },
          { "text": "Preguntar qué tendría que ser verdad para el siguiente y cuándo volver.", "correct": true, "note": "Vale muchísimo más que un no previsible. Te vas con criterios en sus propias palabras y una fecha en la agenda." },
          { "text": "Plantearlo con alguien más sénior.", "correct": false, "note": "Saltarse a tu jefa con el dinero gasta algo grande para no cambiar nada de este ciclo." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('asking-for-money', 4,
  'Tres cosas que hiciste',
  $md$Preguntada por qué debería pagársele más, casi toda la gente echa mano del material equivocado, y es el material que se siente más merecedor: lo mucho que trabaja, cuánto tiempo lleva, lo fiable que es, cuánto le importa.

Nada de eso sirve. No porque no sea verdad — suele ser lo más verdadero que hay sobre alguien — sino porque nada de eso se puede llevar a otra sala. Tu jefe tiene que repetir tu caso ante alguien que no te ha conocido nunca, y *trabaja muchísimo* es una frase que muere por el camino. Todo el mundo trabaja muchísimo.

**La jugada:** tres cosas que pasaron, con lo que cambió por su culpa.

*Cogí los informes en marzo y no se han roto desde entonces. Llevé la cuenta de Harding desde junio, que era nueva. Y la migración salió en octubre sin caída de servicio.* Eso es un caso. Es comprobable, es repetible por otra persona, y describe a alguien operando por encima del nivel al que se le paga, que es el único argumento que mueve un número.

Tres es el número correcto. Una es una anécdota, y cinco deja de ser un caso y empieza a ser una súplica.

No discutas los precios de mercado como una acusación. Saber qué paga el puesto en otros sitios es esencial y pertenece a tu cabeza a la hora de elegir la cifra, no desplegado como prueba de injusticia: en el momento en que se convierte en *me pagan por debajo del mercado*, le estás pidiendo a alguien que admita un error en vez de tomar una decisión.

Y deja fuera lo que no puedes controlar. El coste de la vida, tu alquiler, lo que gana un amigo. Todo real, y nada de eso va del valor del trabajo, que es la única moneda con la que funciona esta conversación.

Si te quedas con una cosa: dale a tu jefe tres frases que pueda repetir cuando tú no estés. Eso es lo que es un caso.$md$,
  $j$[
    {
      "situation": "Te preguntan por qué debería moverse el número.",
      "line": "Cogí los informes en marzo y no se han roto desde entonces; llevé Harding desde junio; la migración salió en octubre sin caída de servicio.",
      "why": "Tres cosas comprobables con resultados pegados. Describe a alguien ya operando por encima de su nivel, que es el único argumento que mueve un número."
    },
    {
      "situation": "Estás a punto de decir lo mucho que has trabajado.",
      "line": "(muere por el camino)",
      "why": "Tu jefe tiene que repetir esto ante alguien que no te ha conocido nunca, y todo el mundo trabaja muchísimo."
    },
    {
      "situation": "Sabes que el puesto paga más en otros sitios.",
      "line": "(eso elige tu número, no defiende tu caso)",
      "why": "Desplegado como prueba de injusticia, le pide a alguien que admita un error en vez de tomar una decisión."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué no sirve lo mucho que trabajas?",
      "options": [
        { "text": "Suena a queja.", "correct": false, "note": "Puede sonar así, e incluso dicho con alegría no hace nada." },
        { "text": "No es verdad de ti en concreto.", "correct": false, "note": "Suele ser lo más verdadero que hay sobre quien lo dice, que es lo que hace que esto se sienta tan injusto." },
        { "text": "No se puede repetir en una sala en la que tú no estás.", "correct": true, "note": "Tu jefe tiene que defender el caso ante alguien que no te ha conocido nunca, y «trabaja muchísimo» muere por el camino. Todo el mundo trabaja muchísimo." },
        { "text": "A los jefes no les importa el esfuerzo.", "correct": false, "note": "A muchos sí, en lo personal. Sencillamente no lo pueden gastar en tu nombre." }
      ],
      "explain": "Dale tres frases que pueda repetir cuando tú no estés."
    },
    {
      "prompt": "¿Dónde pertenece saber el precio de mercado?",
      "options": [
        { "text": "A la hora de elegir tu número.", "correct": true, "note": "Esencial, y pertenece a tu cabeza. Dicho en voz alta como prueba de injusticia, le pide a alguien que admita un error en vez de tomar una decisión." },
        { "text": "Como argumento principal.", "correct": false, "note": "Convierte la conversación en una disputa sobre justicia, que es mucho más difícil de ganar que una decisión sobre valor." },
        { "text": "En ningún sitio: no viene al caso.", "correct": false, "note": "Es muy relevante para lo que pides. La pregunta es si se dice en voz alta." },
        { "text": "Como cierre, si dicen que no.", "correct": false, "note": "Meterlo al final se lee como una amenaza a la que le han quitado la palabra amenaza." }
      ],
      "explain": "El precio de mercado elige tu número. Lo que hiciste defiende tu caso."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "three", "label": "Dio tres cosas", "description": "No una, y no una lista de cinco." },
      { "key": "outcomes", "label": "Pegó lo que cambió", "description": "Dijo qué produjo cada cosa en vez de nombrar la tarea." },
      { "key": "repeatable", "label": "Lo hizo repetible", "description": "Hechos que alguien podría llevarse a otra sala." },
      { "key": "no_grievance", "label": "Sin argumento de injusticia", "description": "Mantuvo fuera el precio de mercado, la antigüedad y los costes personales." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa",
      "mood": "De tu lado, necesitando material.",
      "openness": 4,
      "personality": "Va a tener que defender esto hacia arriba y está escuchando cosas que pueda repetir. Apunta visiblemente lo concreto y no apunta el esfuerzo."
    },
    "setting": "Has dicho cuarenta y ocho. Tu jefa te ha pedido que defiendas el caso.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Apunta y repite en voz alta cualquier cosa concreta y comprobable.",
      "Responde al esfuerzo, la lealtad o la antigüedad con un asentimiento comprensivo y nada apuntado.",
      "Nunca le des tú un ejemplo a la persona."
    ],
    "opening_beat": "«Vale. Ayúdame a defender el argumento: ¿qué tienes?»",
    "success_looks_like": "La persona da tres cosas comprobables con resultados pegados."
  }$j$::jsonb,
  'Hoy, escribe las tres cosas que dirías, cada una con lo que cambió por su culpa. Apunta las tres.',
  $j${
    "says": "Vale. Ayúdame a defender el argumento: ¿qué tienes?",
    "model": {
      "line": "Cogí los informes en marzo y no se han roto desde entonces, llevé la cuenta de Harding desde junio, y la migración salió en octubre sin caída de servicio.",
      "why": "Tres cosas comprobables con resultados pegados, en una forma que tu jefa puede repetir ante alguien que no te ha conocido nunca. Eso es lo que es un caso."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["mucho trabajo", "trabajo duro", "leal", "lealtad", "siempre aquí", "dedicado", "fiable", "años", "merezco", "coste de vida", "precio de mercado", "por debajo del mercado"], "requirement": "Cosas que pasaron, no cualidades que tienes" },
      { "kind": "min_words", "n": 20, "requirement": "Tres cosas, cada una con lo que cambió" },
      { "kind": "max_words", "n": 60, "requirement": "Tres, no cinco: un caso, no una súplica" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('asking-for-money', 5,
  'Qué hacer con un no',
  $md$Un no rara vez es un veredicto sobre ti. Suele ser un ciclo de presupuesto, un techo de banda, o una decisión ya firmada, y lo que determina qué valió depende enteramente de lo que hagas en los sesenta segundos siguientes.

El reflejo es aceptarlo con calidez e irte, lo que se siente elegante y no te da nada. Has gastado la parte difícil de la conversación y te vas sin recoger nada por ella.

**La jugada:** pregunta qué tendría que ser verdad, y cuándo volver. Y luego vuelve en esa fecha.

*¿Qué tendría que ser verdad para que fuera un sí?* es la pregunta, y no es un desafío: es una petición de los criterios, y casi todos los jefes la responden con honestidad porque es más fácil que decir que no dos veces. Todas las respuestas son útiles. Algo concreto, en cuyo caso tienes un plan escrito con las palabras de otra persona. Nada, en cuyo caso el techo es real y ahora sabes algo importante sobre quedarte. O *no lo sé*, que te dice que la decisión está por encima de esa persona y la conversación que necesitas es otra.

Y luego clava la fecha. *¿Te vuelvo a ver en marzo?* convierte un resultado en algo agendado, y algo agendado es mucho más difícil de absorber que algo esperanzado. Consíguelo por escrito después, en una línea amable que resuma lo acordado, no como una trampa, sino porque dentro de seis meses ninguno de los dos lo va a recordar igual.

Y luego vuelve de verdad, en la fecha, haya cambiado algo o no. Casi nadie hace esto, que es precisamente por lo que funciona: la segunda conversación abre con *dijiste marzo*, y todo lo que te dijeron es ahora un compromiso y no una amabilidad.

Si te quedas con una cosa: no dejes nunca un no sin un criterio y una fecha. Eso es lo que convierte un rechazo en la primera mitad de un sí.$md$,
  $j$[
    {
      "situation": "«No va a ser posible este año.»",
      "line": "¿Qué tendría que ser verdad para que fuera un sí?",
      "why": "Una petición de criterios en vez de un desafío, y casi todos los jefes la responden con honestidad porque es más fácil que decir que no dos veces. Toda respuesta posible es útil."
    },
    {
      "situation": "Te han dado una respuesta y la reunión está terminando.",
      "line": "¿Te vuelvo a ver en marzo?",
      "why": "Convierte un resultado en algo agendado. Algo agendado es mucho más difícil de absorber que algo esperanzado."
    },
    {
      "situation": "Llega marzo y no ha cambiado nada visiblemente.",
      "line": "(vuelve igualmente: dijiste marzo)",
      "why": "Casi nadie lo hace, que es por lo que funciona. La segunda conversación abre con sus propias palabras como un compromiso y no como una amabilidad."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hace buena la pregunta «qué tendría que ser verdad»?",
      "options": [
        { "text": "Les pone contra las cuerdas.", "correct": false, "note": "No lo hace, y tratarla como presión es lo que hace que salga mal." },
        { "text": "Demuestra que no te rindes.", "correct": false, "note": "Una señal sobre ti en vez de algo que obtienes. El valor está en la respuesta." },
        { "text": "Toda respuesta posible te sirve.", "correct": true, "note": "Los criterios te dan un plan con sus palabras. Nada significa que el techo es real y sabes algo sobre quedarte. No lo sé significa que la decisión está por encima de ellos." },
        { "text": "Es más difícil de rechazar que una petición directa.", "correct": false, "note": "No es una segunda petición en absoluto, y tratarla como tal es como se convierte en presionar." }
      ],
      "explain": "Ya has gastado la parte difícil de la conversación. Recoge algo por ella."
    },
    {
      "prompt": "¿Por qué importa la fecha tanto como los criterios?",
      "options": [
        { "text": "Demuestra compromiso.", "correct": false, "note": "Cómo se lee, no lo que hace. El mecanismo va sobre qué pasa dentro de seis meses." },
        { "text": "Evita que tengas que volver a plantearlo.", "correct": false, "note": "Lo contrario: es exactamente el acuerdo para volver a plantearlo, con el permiso ya dado." },
        { "text": "Te da un plazo para mejorar.", "correct": false, "note": "Un beneficio secundario. La fecha funciona incluso si no ha cambiado nada sobre ti." },
        { "text": "Convierte una amabilidad en un compromiso.", "correct": true, "note": "Un resultado esperanzado se absorbe; uno agendado no. Y la segunda conversación abre con sus propias palabras y no con tu petición." }
      ],
      "explain": "Un criterio y una fecha. Y luego vuelve de verdad en la fecha."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked_criteria", "label": "Preguntó qué tendría que ser verdad", "description": "Recogió los criterios en vez de irse con elegancia." },
      { "key": "date", "label": "Clavó una fecha", "description": "Convirtió el resultado en algo agendado." },
      { "key": "in_writing", "label": "Lo confirmó después", "description": "Resumió lo acordado en una línea amable." },
      { "key": "no_pressing", "label": "No presionó", "description": "Aceptó el no sin volver a pedir." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rae",
      "role": "tu jefa",
      "mood": "Lo siente, y no se mueve en el número.",
      "openness": 3,
      "personality": "Genuinamente limitada e incómoda con ello. Responde con honestidad y largo y tendido a una pregunta sobre criterios; se cierra si le vuelven a pedir el dinero."
    },
    "setting": "Pediste cuarenta y ocho, defendiste el caso, y te acaban de decir que no es posible este año.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Nunca te muevas en el número, sea como sea que pregunte la persona.",
      "Responde con honestidad y de forma concreta a una pregunta sobre criterios, y acepta sin problema una fecha.",
      "Ciérrate y sé breve si la persona insiste otra vez con el dinero."
    ],
    "opening_beat": "«Voy a ser sincera contigo: no va a ser posible este año.»",
    "success_looks_like": "La persona recoge criterios y una fecha en vez de aceptar e irse."
  }$j$::jsonb,
  'Hoy, coge un no y pregunta qué tendría que ser verdad, más cuándo volver. Apunta los criterios y la fecha.',
  $j${
    "says": "Voy a ser sincera contigo: no va a ser posible este año.",
    "model": {
      "line": "Entendido. ¿Qué tendría que ser verdad para que fuera un sí, y te vuelvo a ver en marzo?",
      "why": "Criterios y una fecha, recogidos en los sesenta segundos que casi todo el mundo gasta yéndose con elegancia. Toda respuesta posible a la primera pregunta es útil, y la segunda convierte una amabilidad en un compromiso."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Recoge algo antes de irte" },
      { "kind": "contains_any", "words": ["tendría que ser", "haría falta", "qué tendría", "criterios", "para que", "llegar a eso", "cambiar"], "requirement": "Pregunta qué tendría que cambiar" },
      { "kind": "contains_any", "words": ["marzo", "vuelvo a ver", "retomarlo", "otra vez en", "tres meses", "seis meses", "próximo trimestre", "cuándo"], "requirement": "Clava una fecha" },
      { "kind": "forbids_any", "words": ["estás segura", "ni siquiera un poco", "qué tal si", "hay alguna forma", "decepcionado", "decepcionada", "no es justo"], "requirement": "Acepta el no: no insistas" }
    ]
  }$j$::jsonb
);
