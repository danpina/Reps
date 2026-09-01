-- Spanish: Conversaciones difíciles, track 4 — Mantenerse en la sala.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Jo" carries no `sex` field; masculine agreement used by
-- default, as established throughout this app. Lesson 3 is [scene] mode
-- with an empty rehearsal_spec (`{}`), matching the English source.

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

select pg_temp.es_lesson('staying-in-the-room', 1,
  'Su reacción no es un veredicto',
  $md$Lo has dicho. Pasa algo. Y sea lo que sea que pase se va a sentir como prueba de si tenías razón al decirlo.

No lo es, y sostener esa distinción es la mayor parte de este bloque.

Hay unas cinco reacciones y las vas a reconocer todas. Actitud defensiva. Un contraataque sobre algo que hiciste en 2019. Lágrimas. Silencio plano. Y *estás exagerando*, que es la que golpea más fuerte porque va contra la legitimidad de toda la conversación en vez de contra su contenido.

**La jugada:** trata la reacción como una reacción, y mantén tu valoración de si tenías razón completamente separada de ella.

El motivo por el que hace falta decir esto es que la ecuación es casi automática, y corre en una dirección concreta para cualquiera que sea callado: reacción fuerte, por lo tanto he sido injusto, por lo tanto debería retirarlo. Esa inferencia no tiene base. Una persona puede estar completamente equivocada y extremadamente disgustada porque se lo digan, y esos dos hechos no tienen nada que ver entre sí.

Merece la pena saber qué indican de verdad las reacciones, que es sobre todo que algo caló. La actitud defensiva es lo que hace la gente cuando cree que está a punto de perder algo. Los contraataques son a lo que la gente recurre cuando no tiene nada disponible sobre el tema real. Ninguna de las dos cosas es un comentario sobre tu exactitud.

Hay una versión que merece la pena tomarse en serio, y separarla es lo que evita que esto se convierta en una licencia. Si dicen algo concreto que no habías considerado — un hecho que no tenías, un contexto que cambia el panorama — eso es información en vez de reacción, y la respuesta honesta es aceptarla. La prueba es si aborda el contenido o la legitimidad de sacarlo.

Si te quedas con una cosa: disgustado no es lo mismo que agraviado. Alguien puede estar completamente disgustado y completamente equivocado a la vez, y tienes permiso para sostener las dos cosas.$md$,
  $j$[
    {
      "situation": "Está visiblemente disgustado y te sientes fatal.",
      "line": "(disgustado no es lo mismo que agraviado)",
      "why": "Una persona puede estar completamente equivocada y extremadamente disgustada porque se lo digan. Los dos hechos no tienen nada que ver entre sí."
    },
    {
      "situation": "Ha sacado algo que hiciste hace dos años.",
      "line": "(a eso recurre la gente cuando no tiene nada sobre el tema)",
      "why": "Un contraataque no es un comentario sobre tu exactitud. Es lo que pasa cuando el tema real no tiene ninguna defensa disponible."
    },
    {
      "situation": "Te ha dicho un hecho que no tenías.",
      "line": "(eso es información, y deberías aceptarla)",
      "why": "La prueba es si aborda el contenido o la legitimidad de sacarlo. El contenido merece la pena escucharlo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué te dice una reacción fuerte?",
      "options": [
        { "text": "Que caló.", "correct": true, "note": "La actitud defensiva es lo que hace la gente cuando cree que está a punto de perder algo. Es un comentario sobre lo que está en juego, no sobre tu exactitud." },
        { "text": "Que fuiste injusto.", "correct": false, "note": "La inferencia automática, y no tiene base. La gente reacciona con fuerza a que le digan cosas ciertas." },
        { "text": "Que deberías haberlo dicho de otra forma.", "correct": false, "note": "A veces cierto y no se puede deducir de la reacción, porque la misma reacción sigue a una versión perfectamente formulada." },
        { "text": "Nada en absoluto.", "correct": false, "note": "Demasiado limpio — sí te dice algo sobre lo que significa para ellos, solo que nada sobre si tenías razón." }
      ],
      "explain": "Disgustado y agraviado son cosas distintas, y solo una de ellas te corresponde a ti valorar."
    },
    {
      "prompt": "¿Cómo distingues una reacción de la información?",
      "options": [
        { "text": "Por lo tranquilo que suena.", "correct": false, "note": "La información real a menudo llega con enfado, y un contraataque muy tranquilo sigue siendo un contraataque." },
        { "text": "Por si aborda el contenido o tu derecho a sacarlo.", "correct": true, "note": "Un hecho que no tenías cambia el panorama y hay que aceptarlo. Estás exagerando va contra la legitimidad de la conversación en su lugar." },
        { "text": "Por si te resulta convincente.", "correct": false, "note": "Eres el juez menos fiable de eso treinta segundos después de decir algo difícil." },
        { "text": "Por si viene con una disculpa.", "correct": false, "note": "Las disculpas y la información llegan de forma independiente entre sí." }
      ],
      "explain": "El contenido merece la pena escucharlo. La legitimidad es en lo que hay que mantenerse firme."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "separated", "label": "Mantuvo las dos cosas separadas", "description": "No leyó la reacción como un veredicto." },
      { "key": "no_retreat", "label": "No se retiró ante el disgusto", "description": "Mantuvo el punto a través de una reacción fuerte." },
      { "key": "took_information", "label": "Aceptó información real", "description": "Aceptó un hecho que cambiaba el panorama." },
      { "key": "steady", "label": "Se mantuvo firme", "description": "Ni escaló ni se derrumbó." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Jo",
      "role": "alguien con quien acabas de sacar un tema",
      "mood": "Herido.",
      "openness": 4,
      "personality": "Recurre a material viejo cuando no tiene nada disponible sobre el tema real, y vuelve al tema si el intercambio se rechaza con calidez."
    },
    "setting": "Has dicho la cosa. Ha ido directo a algo que hiciste hace dieciocho meses.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Saca viejos agravios si la persona se implica con ellos.",
      "Vuelve al tema real si la persona rechaza el intercambio sin hostilidad.",
      "Nunca concedas el punto original sin que te lo pidan."
    ],
    "opening_beat": "«Vale, bueno — me hiciste exactamente lo mismo en Navidad, así que.»",
    "success_looks_like": "La persona lee el contraataque como una reacción en vez de como un veredicto."
  }$j$::jsonb,
  'Hoy, fíjate en un momento en el que la reacción de alguien te hizo dudar de si tenías razón. Apunta la reacción y qué piensas de verdad.',
  $j${
    "beats": [
      {
        "situation": "Has dicho la cosa. Está visiblemente disgustado y se ha quedado muy callado.",
        "prompt": "¿Qué te dice eso sobre si tenías razón?",
        "options": [
          { "text": "Que te pasaste.", "correct": false, "note": "La inferencia automática, y no tiene base. La gente reacciona con fuerza a que le digan cosas ciertas." },
          { "text": "Nada de eso en absoluto.", "correct": true, "note": "Disgustado y agraviado son distintos. Alguien puede estar completamente equivocado y completamente angustiado porque se lo digan, y los dos hechos no están relacionados." },
          { "text": "Que deberías haberlo formulado mejor.", "correct": false, "note": "Puede que sí, y no se puede deducir de la reacción — la misma reacción sigue a una versión perfectamente formulada." },
          { "text": "Que no merecía la pena sacarlo.", "correct": false, "note": "Una reacción fuerte normalmente significa lo contrario: algo caló, y importaba." }
        ]
      },
      {
        "situation": "En vez de eso, dice: «La verdad es que cancelé en marzo porque mi madre estaba en el hospital y no quería entrar en detalles.»",
        "prompt": "¿Qué es eso?",
        "options": [
          { "text": "Un contraataque con ropa más suave.", "correct": false, "note": "Nada en ello va dirigido a ti. Aborda el contenido directamente." },
          { "text": "Una excusa para un caso.", "correct": false, "note": "Puede que solo cubra un caso, y cubrir un caso con honestidad es exactamente lo que hace la información." },
          { "text": "Información, y deberías aceptarla.", "correct": true, "note": "Aborda el contenido en vez de tu derecho a sacarlo, y es un hecho que no tenías. La respuesta honesta es aceptarlo." },
          { "text": "Un motivo para dejar todo el asunto.", "correct": false, "note": "Cambia un caso, no el patrón. Acéptalo, ajusta, y sigue con el resto." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('staying-in-the-room', 2,
  'No llenes el silencio',
  $md$La retractación casi nunca pasa a propósito. Pasa en un hueco.

Dices la cosa. Se queda callado. Pasan cuatro segundos, que se sienten como cuarenta, y de tu boca sale *bueno, no es gran cosa, olvida que dije algo* — y veinte minutos de preparación y un mes de pavor se deshacen en una sola frase que no decidiste decir.

**La jugada:** deja de hablar, y deja que el silencio sea suyo.

El silencio está haciendo exactamente lo que querías que hiciera la conversación. Alguien acaba de recibir algo difícil y está decidiendo si es cierto, recordando los casos, pensando si está de acuerdo, y eligiendo qué decir. Ese es todo el propósito de haberlo sacado, y lleva unos segundos. Interrumpirlo no lo acelera — lo reemplaza.

Tres cosas se dicen en ese hueco y todas te cuestan.

*No es gran cosa* — que no es cierto, y ahora no hace falta que pase nada.
*Perdona, sé que es mucho* — que se disculpa por haber dicho algo que tenías razón en decir.
*Bueno, obviamente no eres solo tú* — que reparte la responsabilidad hasta que nadie tiene ninguna.

Cada una es un pequeño acto de amabilidad dirigido a tu propia incomodidad, y cada una retira lo que venías a decir.

En la práctica: decide de antemano que vas a estar callado, porque no vas a poder decidirlo en el momento — el impulso es físico, no razonado. Cuenta si ayuda. Mira algo que no sea su cara si eso te lo facilita.

Y si el silencio de verdad se alarga más de lo que nadie podría aguantar, pregunta en vez de repetir. *¿Qué estás pensando?* le cede la palabra sin debilitar nada, y es la única frase segura para poner en ese hueco.

Si te quedas con una cosa: los cuatro segundos después de decirlo son toda la conversación. No te los gastes.$md$,
  $j$[
    {
      "situation": "Lo has dicho y se ha quedado callado.",
      "line": "(el silencio está haciendo lo que querías que hiciera la conversación)",
      "why": "Está decidiendo si es cierto y recordando los casos. Interrumpir no lo acelera, lo reemplaza."
    },
    {
      "situation": "De tu boca sale no es gran cosa.",
      "line": "(esa es la retractación)",
      "why": "Un mes de pavor y veinte minutos de preparación deshechos en una frase, dirigida a tu incomodidad en vez de a nada de lo que hicieron ellos."
    },
    {
      "situation": "De verdad se ha alargado demasiado.",
      "line": "¿Qué estás pensando?",
      "why": "La única frase segura en ese hueco. Le cede la palabra sin debilitar nada."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué pasa la retractación?",
      "options": [
        { "text": "Te das cuenta de que estabas equivocado.", "correct": false, "note": "Casi nunca — el punto no cambia en cuatro segundos. Lo que cambia es lo incómodo que estás." },
        { "text": "Quieres que se sienta mejor.", "correct": false, "note": "Esa es la historia que se cuenta a sí misma. Va dirigida a tu propia incomodidad y les cuesta a ellos la conversación." },
        { "text": "Te presionan para hacerlo.", "correct": false, "note": "Normalmente no han dicho nada en absoluto. El silencio lo hace sin que nadie ejerza presión." },
        { "text": "Sale del hueco, antes de que decidas nada.", "correct": true, "note": "El impulso es físico, no razonado, que es por lo que hay que decidirlo de antemano en vez de resistirlo en el momento." }
      ],
      "explain": "Decide de antemano que vas a estar callado. No lo puedes decidir en el momento."
    },
    {
      "prompt": "¿Qué es seguro decir en el hueco?",
      "options": [
        { "text": "Nada — espera del todo.", "correct": false, "note": "Casi correcto, y en algún momento se convierte en un enfrentamiento en vez de en una pausa." },
        { "text": "Una versión más suave del punto.", "correct": false, "note": "Esa es la dilución con la que termina el bloque anterior. Más suave no es más seguro." },
        { "text": "¿Qué estás pensando?", "correct": true, "note": "Una pregunta en vez de una repetición. Le cede la palabra y no debilita nada." },
        { "text": "Un reconocimiento de que es duro de escuchar.", "correct": false, "note": "Razonable en sí mismo, y a un paso de disculparse por haberlo dicho." }
      ],
      "explain": "Los cuatro segundos después de decirlo son toda la conversación. No te los gastes."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "silent", "label": "Se mantuvo callado", "description": "Dejó correr el hueco." },
      { "key": "no_retraction", "label": "No se retractó", "description": "No se retiró nada." },
      { "key": "no_apology", "label": "No se disculpó por decirlo", "description": "Nada de perdón en el silencio." },
      { "key": "question", "label": "Preguntó, si acaso", "description": "Usó una pregunta en vez de una repetición." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Jo",
      "role": "alguien con quien acabas de sacar un tema",
      "mood": "Asimilándolo.",
      "openness": 4,
      "personality": "Se toma diez o quince segundos de verdad para responder, y responde con reflexión si se le dan. Se agarra con alivio a cualquier suavizado que se le ofrezca."
    },
    "setting": "Acabas de decirlo. Está mirando al suelo y no ha hablado. Han pasado unos cuatro segundos.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Tómate una pausa larga antes de tu primera respuesta sustancial, y descríbela con sencillez.",
      "Acepta cualquier suavizado de inmediato y trata el asunto como cerrado.",
      "Responde en serio y con honestidad si la persona mantiene el silencio."
    ],
    "opening_beat": "(silencio)",
    "success_looks_like": "La persona no dice nada, o hace una pregunta, en vez de suavizar."
  }$j$::jsonb,
  'Hoy, di algo difícil y luego guarda silencio hasta que la otra persona hable. Apunta cuánto tardó.',
  $j${
    "says": "(silencio — está mirando al suelo y no ha hablado en unos diez segundos)",
    "model": {
      "line": "¿Qué estás pensando?",
      "why": "La única frase segura en ese hueco: una pregunta en vez de una repetición, que le cede la palabra y no debilita nada. Todo lo demás que se ofrece en un silencio es una retirada."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["no es gran cosa", "olvídalo", "perdona", "no importa", "sé que es mucho", "quizás estoy", "probablemente exagerando", "ignora", "no eres solo tú"], "requirement": "Nada que lo retire" },
      { "kind": "max_words", "n": 15, "requirement": "No lo llenes de palabras" },
      { "kind": "max_sentences", "n": 1, "requirement": "Una frase como mucho" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('staying-in-the-room', 3,
  'Cuando se disgustan',
  $md$Está llorando, o a punto. Estos son los treinta segundos más difíciles del tema y es donde la mayoría de la gente callada lo echa todo por la borda.

El instinto es abrumador y se siente como decencia: consolar, y retirarlo. *Lo siento muchísimo, no debería haberlo sacado, no importa.* Y en ese momento es genuinamente difícil distinguir entre amabilidad y rescate — porque se ven idénticos desde dentro y solo una de las dos cosas trata sobre ellos.

**La jugada:** sé cálido e inamovible al mismo tiempo.

*Sé que esto es duro de escuchar, y sigo pensándolo.* Las dos mitades en una frase. La primera es compasión real y no cuesta nada. La segunda es lo que venías a decir, todavía en pie.

Esa combinación es lo bastante inusual como para que a la gente le cueste imaginarla, y es toda la habilidad: puedes ser completamente amable con la angustia de alguien sin tratar esa angustia como un argumento. El consuelo es gratis. La retractación no lo es.

Merece la pena tener claro qué hace de verdad retractarse, porque después no se lee como amabilidad. Les dice que el disgusto funciona — que angustiarse hace que las cosas difíciles desaparezcan — que es algo malo que enseñarle a alguien que te importa, y significa que el próximo intento será más difícil para los dos. Y les deja sin nada que arreglar, que no es una amabilidad, es un callejón sin salida con compasión encima.

Cosas prácticas que ayudan. Ve más despacio en vez de más rápido. Ofrece la pausa — *¿quieres un minuto?* — que es cuidado genuino y no concede nada. Y no lo toques con más palabras: la gente llena este silencio al triple del ritmo habitual y cada frase ahí dentro es una retirada.

Si no pueden continuar, parar está permitido. *¿Volvemos a esto mañana?* mantiene la conversación viva en vez de disolverla, y es completamente distinto de *olvida que dije algo.* Una cosa es una pausa y la otra es una retirada.

Si te quedas con una cosa: cálido e inamovible. Consuela todo lo que quieras, y no lo retires.$md$,
  $j$[
    {
      "situation": "Ha empezado a llorar.",
      "line": "Sé que esto es duro de escuchar, y sigo pensándolo.",
      "why": "Las dos mitades en una frase. Compasión real, y lo que venías a decir todavía en pie — que es toda la habilidad."
    },
    {
      "situation": "Quieres darle un momento.",
      "line": "¿Quieres un minuto?",
      "why": "Cuidado genuino que no concede nada. Ir más despacio está disponible; retirar el punto es un acto completamente distinto."
    },
    {
      "situation": "Estás a punto de decir que no deberías haberlo sacado.",
      "line": "(eso le enseña que el disgusto funciona)",
      "why": "Hace que el próximo intento sea más difícil para los dos, y les deja sin nada que arreglar — un callejón sin salida con compasión encima."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la diferencia entre consolar y retractarse?",
      "options": [
        { "text": "No hay mucha — el consuelo tiende a convertirse en retractación.", "correct": false, "note": "Tiende a hacerlo, que es una advertencia, no una identidad. Se pueden separar de forma deliberada." },
        { "text": "El consuelo es gratis; el punto se queda donde estaba.", "correct": true, "note": "Sé que esto es duro de escuchar, y sigo pensándolo. Puedes ser completamente amable con la angustia sin tratarla como un argumento." },
        { "text": "El consuelo es físico y la retractación es verbal.", "correct": false, "note": "Las dos suelen ser verbales. La distinción está en qué le pasa al contenido." },
        { "text": "La retractación es lo que haces si estabas equivocado.", "correct": false, "note": "Si estabas equivocado, decirlo no es retractación — es una corrección, y no pasa porque alguien esté disgustado." }
      ],
      "explain": "Cálido e inamovible. La combinación es lo bastante inusual como para que a la gente le cueste imaginarla."
    },
    {
      "prompt": "¿Qué hace de verdad retirarlo?",
      "options": [
        { "text": "Les ahorra la dificultad.", "correct": false, "note": "Les ahorra la dificultad y les deja el problema, que no es un trueque que nadie elegiría." },
        { "text": "Termina la conversación con amabilidad.", "correct": false, "note": "La termina. Con amabilidad es cómo se siente en el momento, no lo que hace después." },
        { "text": "Les enseña que el disgusto hace que las cosas desaparezcan.", "correct": true, "note": "Que es algo malo que enseñarle a alguien que te importa, y hace que el próximo intento sea más difícil para los dos." },
        { "text": "Nada en especial — puedes sacarlo otra vez más tarde.", "correct": false, "note": "Puedes, y va a ser más difícil, porque ahora hay un precedente de cómo termina esta conversación." }
      ],
      "explain": "Una pausa está bien. ¿Volvemos a esto mañana? no es olvida que dije algo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "warm", "label": "Fue genuinamente cálido", "description": "Reconoció la angustia como es debido." },
      { "key": "unmoved", "label": "No movió el punto", "description": "El contenido sobrevivió a la reacción." },
      { "key": "no_apology", "label": "No se disculpó por sacarlo", "description": "Nada de no debería haber dicho nada." },
      { "key": "paused_not_withdrew", "label": "Pausó en vez de retirarse", "description": "Si paró, paró como una pausa." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Jo",
      "role": "alguien con quien acabas de sacar un tema",
      "mood": "Desbordado.",
      "openness": 4,
      "personality": "Genuinamente disgustado en vez de fingiéndolo. Se agarra a cualquier retirada con alivio visible y trata el asunto como cerrado; se estabiliza y se implica con honestidad si se le consuela sin que el punto se mueva."
    },
    "setting": "Has dicho la cosa. Ha calado fuerte, y está muy cerca de las lágrimas.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Trata cualquier no importa o no debería haberlo dicho como el fin del tema, con alivio.",
      "Estabilízate e implícate con honestidad si te consuelan mientras el punto sigue en pie.",
      "Nunca vuelvas tú al tema una vez que se ha retirado."
    ],
    "opening_beat": "«Perdona. Perdona — dame un segundo.»",
    "success_looks_like": "La persona es cálida y no retira el punto."
  }$j$::jsonb,
  'Hoy, consuela a alguien sin retirar lo que dijiste. Apunta la frase que usaste para hacer las dos cosas.',
  $j${}$j$::jsonb
);

select pg_temp.es_lesson('staying-in-the-room', 4,
  'Cuando le dan la vuelta',
  $md$*Bueno, tú haces exactamente lo mismo.* *¿Y cómo me hablaste en marzo?*

El contraataque llega rápido, a menudo es al menos parcialmente cierto, y te presenta una elección que tienes más o menos un segundo para tomar.

Las dos opciones obvias son malas. Defenderte acepta el intercambio, y treinta segundos después estáis hablando de marzo — lo que significa que tu asunto ha sido intercambiado con éxito por el suyo y no te lo van a devolver. Ignorarlo por completo se lee como arrogancia y produce un segundo agravio genuino, porque lo que sacaron bien podría ser real.

**La jugada:** reconócelo, rechaza el intercambio, y vuelve.

*Eso es justo, y sí quiero hablar de ello. ¿Podemos terminar con esto primero?* Tres partes, unos ocho segundos, y es la única respuesta que mantiene vivos los dos temas.

El reconocimiento tiene que ser genuino, no táctico, y la gente distingue la diferencia al instante. Si lo que han dicho es cierto, dilo con claridad — conceder un punto justo no te cuesta nada y le quita el combustible al contraataque, porque un contraataque funciona siendo irrefutable y tú acabas de refutarlo.

Luego mantén el orden. Una conversación a la vez no es una evasiva, es la única forma en que cualquiera de los dos temas se trata; dos agravios discutidos a la vez producen una competición de puntos en la que nadie concede nada, porque cada concesión se convierte en munición.

Y vuelve al suyo. Si dices que vas a hablar de marzo, habla de marzo — esa tarde o esa semana. Alguien que usó el intercambio y luego nunca tuvo que enfrentarse a su propio punto aprende que la maniobra funciona, y la próxima vez va a llegar antes.

La versión que hay que vigilar: cuando el contraataque sigue llegando, y cada intento de terminar el primer tema produce uno nuevo. Eso ya no es una reacción, es una estrategia, y la respuesta honesta es nombrarla en vez de seguir parando golpes — *no vamos a ningún lado mientras los dos hagamos esto* es justo y cierto.

Si te quedas con una cosa: *eso es justo, y podemos terminar con esto primero.* Concede todo lo que merece la pena conceder y no regala nada.$md$,
  $j$[
    {
      "situation": "«Tú haces exactamente lo mismo.»",
      "line": "Eso es justo, y sí quiero hablar de ello. ¿Podemos terminar con esto primero?",
      "why": "Concede lo que es cierto, rechaza el intercambio, y mantiene vivos los dos temas. Unos ocho segundos."
    },
    {
      "situation": "Estás a punto de defenderte sobre marzo.",
      "line": "(eso acepta el intercambio)",
      "why": "Treinta segundos después estáis hablando de marzo, y tu tema ha sido intercambiado por el suyo y no te lo van a devolver."
    },
    {
      "situation": "Cada intento de terminar produce un nuevo contraataque.",
      "line": "No vamos a ningún lado mientras los dos hagamos esto.",
      "why": "En ese punto es una estrategia, no una reacción, y nombrarla es más justo que seguir parando golpes."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué no ignorar sin más el contraataque?",
      "options": [
        { "text": "Se lee como arrogancia y crea un segundo agravio real.", "correct": true, "note": "Lo que sacaron a menudo es al menos parcialmente cierto, y negarse a reconocerlo les da algo nuevo y legítimo de lo que sentirse agraviados." },
        { "text": "Es de mala educación.", "correct": false, "note": "Los modales son el problema menor. También suele ser injusto, porque el punto puede ser real." },
        { "text": "Van a seguir repitiéndolo.", "correct": false, "note": "Puede que sí, y eso es un síntoma del punto no reconocido, no un motivo aparte." },
        { "text": "Escala las cosas.", "correct": false, "note": "General. El coste concreto es que has fabricado un segundo problema." }
      ],
      "explain": "Reconócelo, rechaza el intercambio, vuelve a ello más tarde — y de verdad vuelve."
    },
    {
      "prompt": "¿Por qué tiene que ser genuino el reconocimiento?",
      "options": [
        { "text": "Porque mentir está mal.", "correct": false, "note": "Cierto y no es lo que hace que esto funcione o falle en la sala." },
        { "text": "Porque te lo van a exigir.", "correct": false, "note": "Deberían exigírtelo, y eso va sobre volver más tarde, no sobre la sinceridad ahora." },
        { "text": "Porque te hace parecer razonable.", "correct": false, "note": "Apariencia, no mecanismo, y apuntar a eso es lo que produce la versión táctica." },
        { "text": "Porque le quita el combustible.", "correct": true, "note": "Un contraataque funciona siendo irrefutable, y conceder un punto justo lo refuta — una concesión táctica no lo hace, y la gente detecta la diferencia al instante." }
      ],
      "explain": "Una conversación a la vez no es una evasiva. Dos a la vez es una competición de puntos."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "acknowledged", "label": "Lo reconoció", "description": "Concedió lo que era justo, de forma genuina." },
      { "key": "refused_trade", "label": "Rechazó el intercambio", "description": "No empezó a hablar del otro tema." },
      { "key": "returned", "label": "Volvió al primero", "description": "Terminó de lo que se estaba hablando." },
      { "key": "kept_promise", "label": "Cumplió la promesa", "description": "Tenía intención de tener de verdad la otra conversación." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Jo",
      "role": "alguien con quien acabas de sacar un tema",
      "mood": "A la defensiva, rápido.",
      "openness": 4,
      "personality": "Sigue sacando material viejo mientras se le siga siguiendo el juego. Se calma y vuelve al tema cuando se le concede un punto de forma genuina y se rechaza el intercambio."
    },
    "setting": "Has sacado la cosa. Ha sacado de inmediato algo que hiciste en Navidad, que es en parte justo.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Saca otro agravio viejo cada vez que la persona se implique con el último.",
      "Cálmate y vuelve al tema original cuando se conceda un punto de forma genuina y se rechace el intercambio.",
      "Nunca abandones el contraataque si se ignora por completo."
    ],
    "opening_beat": "«Vale, bueno — ¿y qué me dices de Navidad? Me hiciste exactamente esto.»",
    "success_looks_like": "La persona concede lo que es justo y vuelve al tema original."
  }$j$::jsonb,
  'Hoy, concede un punto justo en una discusión sin dejar que cambie de tema. Apunta qué concediste.',
  $j${
    "says": "Vale, bueno — ¿y qué me dices de Navidad? Me hiciste exactamente esto.",
    "model": {
      "line": "Eso es justo, y sí quiero hablar de ello. ¿Podemos terminar con esto primero?",
      "why": "Concede lo que es cierto, que le quita el combustible a un contraataque, y rechaza el intercambio sin ignorarlo. Tres partes, unos ocho segundos, y los dos temas siguen vivos."
    },
    "checks": [
      { "kind": "contains_any", "words": ["justo", "cierto", "tienes razón", "lo hice", "culpable", "lo admito", "sí"], "requirement": "Reconoce lo que es justo en ello" },
      { "kind": "forbids_any", "words": ["eso fue distinto", "no es lo mismo", "porque tú", "solo porque", "si no hubieras", "eso no fue lo que pasó"], "requirement": "No te defiendas al respecto" },
      { "kind": "requires_question", "requirement": "Pide volver a ello" },
      { "kind": "max_words", "n": 30, "requirement": "Ocho segundos, no una negociación" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('staying-in-the-room', 5,
  'Terminar sin acuerdo',
  $md$La mayoría de las conversaciones difíciles no terminan con alguien diciendo *tienes razón, voy a cambiar eso.* La gente rara vez concede en la sala, y esperar a eso es cómo una conversación de veinte minutos se convierte en noventa.

**La jugada:** termínala cuando se haya dicho y escuchado, no cuando hayas ganado.

Dicho y escuchado es el objetivo real. Saben el hecho, saben el efecto, y saben qué estás pidiendo. Eso es todo lo que la conversación podía entregar, y se ha entregado, estén de acuerdo o no.

Lo que pasa después normalmente es invisible para ti. Un patrón muy común es que alguien se defienda durante veinte minutos y luego cambie el comportamiento de todas formas, una semana después, tras haberlo pensado — y nunca mencione que lo hizo. Si estás buscando la concesión, vas a leer esa conversación como un fracaso y te vas a equivocar al respecto.

Así que cómo terminar. Di qué entiendes que es la postura, incluyendo el desacuerdo. *Así que lo vemos de forma distinta, y ya sabes dónde estoy yo.* Eso cierra el círculo sin fingir un acuerdo que no está ahí — y fingir es la versión que deja a las dos personas sabiendo que está sin terminar.

Si hay un acuerdo, hazlo concreto antes de iros: qué cambia, y para cuándo. Los sentimientos cálidos al final de una conversación difícil son agradables y se evaporan para el jueves.

Y luego para de verdad. Las ganas de añadir un punto más una vez que ha bajado la temperatura son fuertes y siempre es un error — reabre algo que acababa de cerrarse, y convierte una conversación terminada en una que hay que terminar dos veces.

Después, sé normal. No falsamente alegre, que se lee como alivio y algo insultante, sino corriente. Lo más tranquilizador de una conversación difícil es descubrir que no cambió nada más, y eso se demuestra en la hora siguiente en vez de prometerse en la última frase.

Si te quedas con una cosa: dicho y escuchado es la línea de meta. El acuerdo es un extra, y normalmente llega más tarde y en privado.$md$,
  $j$[
    {
      "situation": "Veinte minutos después y no ha concedido nada.",
      "line": "(dicho y escuchado es la línea de meta)",
      "why": "Saben el hecho, el efecto y la petición. Eso es todo lo que la conversación podía entregar, estén de acuerdo o no."
    },
    {
      "situation": "Estás cerrando y todavía estáis en desacuerdo.",
      "line": "Así que lo vemos de forma distinta, y ya sabes dónde estoy yo.",
      "why": "Cierra el círculo sin fingir un acuerdo que no está ahí — y fingir deja a las dos personas sabiendo que está sin terminar."
    },
    {
      "situation": "Ha bajado la temperatura y se te ocurre una cosa más.",
      "line": "(no lo hagas)",
      "why": "Reabre algo que acababa de cerrarse, y convierte una conversación terminada en una que hay que terminar dos veces."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es el objetivo?",
      "options": [
        { "text": "El acuerdo.", "correct": false, "note": "La gente rara vez concede en la sala, y esperar a eso convierte veinte minutos en noventa." },
        { "text": "Dicho y escuchado.", "correct": true, "note": "Saben el hecho, el efecto y la petición. Eso es todo lo que la conversación en sí puede entregar." },
        { "text": "Un plan.", "correct": false, "note": "Excelente cuando existe y no siempre está disponible, y aferrarse a él te mantiene en la sala más allá del punto de utilidad." },
        { "text": "Que los dos os sintáis mejor.", "correct": false, "note": "A menudo ninguno de los dos lo hace, de inmediato, y eso no es prueba de que fuera mal." }
      ],
      "explain": "Un patrón muy común es defenderse durante veinte minutos y cambiar el comportamiento una semana después, sin mencionarlo."
    },
    {
      "prompt": "¿Cómo debería ser la siguiente hora?",
      "options": [
        { "text": "Daos espacio el uno al otro.", "correct": false, "note": "A veces necesario, y por defecto se lee como que la relación ha cambiado." },
        { "text": "Cálida, para mostrar que no hay rencor.", "correct": false, "note": "Falsamente alegre se lee como alivio, que es algo insultante después de haberle pedido a alguien que se tome algo en serio." },
        { "text": "Corriente.", "correct": true, "note": "Lo más tranquilizador de una conversación difícil es descubrir que no cambió nada más, y eso se demuestra en vez de prometerse." },
        { "text": "Una conversación de seguimiento para comprobar que está bien.", "correct": false, "note": "Lo reabre, y les pide que te tranquilicen sobre cómo se lo tomaron." }
      ],
      "explain": "Y no añadas un punto más una vez que se ha cerrado."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "ended", "label": "Lo terminó deliberadamente", "description": "Paró cuando se había dicho y escuchado." },
      { "key": "named_position", "label": "Nombró dónde estaban los dos", "description": "Cerró el círculo incluyendo el desacuerdo." },
      { "key": "concrete", "label": "Hizo concreto cualquier acuerdo", "description": "Qué cambia y para cuándo." },
      { "key": "normal_after", "label": "Fue corriente después", "description": "Ni distante ni falsamente alegre." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Jo",
      "role": "alguien con quien has estado teniendo una conversación difícil",
      "mood": "Cansado, no hostil.",
      "openness": 4,
      "personality": "Va a seguir indefinidamente sin conceder, y se toma bien un cierre limpio. Lo piensa bien después, algo que la persona no va a ver."
    },
    "setting": "Veinticinco minutos después. Se ha dicho, lo ha escuchado, y no ha estado de acuerdo con nada de ello.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Nunca concedas el punto, por mucho que se alargue la conversación.",
      "Responde bien y con calidez a un cierre limpio que nombre el desacuerdo.",
      "Nunca termines tú la conversación."
    ],
    "opening_beat": "«Sigo sin pensar que sea tan importante como lo estás haciendo parecer.»",
    "success_looks_like": "La persona cierra la conversación sin exigir un acuerdo."
  }$j$::jsonb,
  'Hoy, termina deliberadamente una conversación sin resolver, nombrando dónde estáis los dos. Apunta cómo la cerraste.',
  $j${
    "says": "Sigo sin pensar que sea tan importante como lo estás haciendo parecer.",
    "model": {
      "line": "Vale — lo vemos de forma distinta, y ya sabes dónde estoy yo. Dejémoslo ahí.",
      "why": "Cierra el círculo incluyendo el desacuerdo, que es honesto, en vez de fabricar un acuerdo que dejaría a los dos sabiendo que estaba sin terminar. Dicho y escuchado era la línea de meta."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["probablemente tengas razón", "quizás estoy exagerando", "olvídalo", "una cosa más", "y otra cosa", "no importa", "me retracto"], "requirement": "No fabriques un acuerdo y no lo reabras" },
      { "kind": "min_words", "n": 10, "requirement": "Nombra dónde estáis los dos" },
      { "kind": "max_words", "n": 35, "requirement": "Ciérralo, no lo repitas" }
    ]
  }$j$::jsonb
);
