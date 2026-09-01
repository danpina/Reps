-- Spanish: La primera cita, track 3 — Averiguar si te gusta.
--
-- Conventions as prior tracks: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Sam" carries no `sex` field; masculine agreement used by
-- default, as established in Running the app and elsewhere.

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

select pg_temp.es_lesson('do-you-like-them', 1,
  'Llegaste como un candidato',
  $md$Fíjate en la postura con la que te presentas, porque hace más daño que cualquier cosa que digas.

El comportamiento por defecto es evaluar: ¿lo estoy haciendo bien?, ¿tuvo gracia eso?, ¿aterrizó bien?, ¿le gusto? Corre de forma continua durante dos horas, por debajo de la conversación, y es a lo que casi toda persona callada se refiere cuando dice que una cita fue agotadora. Hablar no cansaba. Vigilar sí.

**La jugada:** date cuenta de que estás haciendo una prueba de casting, y para.

Te cuesta tres cosas, y se acumulan. Es agotador, lo que significa que eres peor compañía en el minuto noventa de lo que eras en el minuto diez. Se nota — comprobar cómo aterriza cada cosa es exactamente lo que la gente detecta cuando dice que alguien se esforzaba demasiado, y lo detecta sin poder nombrarlo. Y desplaza a la única pregunta que de verdad te tocaba responder a ti, que es si quieres volver a hacer esto.

Esa última produce el resultado con el que merece la pena quedarse un momento: la gente acepta segundas citas con personas con las que no disfrutó, porque nadie les preguntó nunca si lo hicieron. La noche se puntuó por completo según cómo fue, y *cómo fue* era una suposición sobre el estado interior de otra persona.

El motivo por el que cuesta tanto dejarlo es que se siente como esfuerzo en la dirección correcta. Intentar gustar parece que te importa, y parar se siente como rendirse con el resultado. No lo es — es redirigir la atención de algo que no puedes controlar a algo que sí puedes, y el redireccionamiento es toda la técnica.

Una señal: si recuerdas mejor lo que dijiste tú que lo que dijo la otra persona, estabas haciendo una prueba de casting.

Si te quedas con una cosa: el agotamiento es la vigilancia, no la conversación. Dos horas hablando no cansan. Dos horas siendo evaluado sí.$md$,
  $j$[
    {
      "situation": "Le estás dando vueltas a algo que dijiste hace cuatro minutos.",
      "line": "(eso es la vigilancia, y te está costando los siguientes diez minutos)",
      "why": "Comprobar cómo aterriza cada cosa es lo que la gente detecta como esforzarse demasiado, y desplaza a la única pregunta que te tocaba responder a ti."
    },
    {
      "situation": "Llegas a casa destrozado después de dos horas de conversación agradable.",
      "line": "(no fue hablar lo que te cansó)",
      "why": "Dos horas de conversación no son agotadoras. Dos horas siendo evaluado sí, y por eso eras peor compañía al final que al principio."
    },
    {
      "situation": "Recuerdas todo lo que dijiste tú y muy poco de lo que dijo la otra persona.",
      "line": "(esa es la señal)",
      "why": "La atención estuvo apuntando hacia dentro toda la noche. Pasara lo que pasara, no llegaste a saber mucho de la otra persona."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué es lo que de verdad agota en una primera cita?",
      "options": [
        { "text": "Hablar con alguien nuevo durante dos horas.", "correct": false, "note": "Eso lo haces en el trabajo sin necesitar tumbarte después." },
        { "text": "La vigilancia corriendo por debajo.", "correct": true, "note": "¿Lo estoy haciendo bien?, ¿aterrizó eso?, ¿le gusto? — de forma continua, durante dos horas. La conversación nunca fue la parte cansada." },
        { "text": "Lo que está en juego.", "correct": false, "note": "Lo que está en juego explica por qué vigilas. La vigilancia es lo que cuesta la energía." },
        { "text": "Tener que ser interesante.", "correct": false, "note": "Un síntoma de la misma postura, y una parte menor de la factura que la comprobación." }
      ],
      "explain": "Dos horas hablando no cansan. Dos horas siendo evaluado sí."
    },
    {
      "prompt": "¿Cuál es el coste más raro de hacer una prueba de casting?",
      "options": [
        { "text": "Pareces menos seguro de ti mismo.", "correct": false, "note": "Lo pareces, y ese es el coste que la gente espera y el menos interesante." },
        { "text": "Se te olvida lo que te contaron.", "correct": false, "note": "Real, y es un síntoma en vez del resultado que importa." },
        { "text": "Eres peor compañía al final.", "correct": false, "note": "Cierto, y es el efecto de segundo orden. Hay uno más raro." },
        { "text": "Segundas citas con gente con la que no disfrutaste.", "correct": true, "note": "La noche se puntuó según cómo fue en vez de según si te gustó, y nadie hizo nunca la segunda pregunta." }
      ],
      "explain": "La pregunta que no hiciste es la que decide qué pasa después."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "noticed", "label": "Notó la postura", "description": "Se pilló vigilando en vez de participando." },
      { "key": "redirected", "label": "Redirigió la atención", "description": "La movió de cómo lo estaba haciendo a qué estaba pasando." },
      { "key": "less_tired", "label": "Dejó de evaluar", "description": "Dejó que las cosas aterrizaran sin puntuarlas." },
      { "key": "remembered_them", "label": "Se acordó de ella", "description": "Salió de ahí sabiendo qué dijo la otra persona." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo preguntando por la cita",
      "mood": "Curioso, cariñoso.",
      "openness": 5,
      "personality": "Pregunta por la otra persona, una y otra vez, y nota cuando cada respuesta vuelve a cómo lo hizo la persona."
    },
    "setting": "A la mañana siguiente. Un amigo te pregunta qué tal fue, y te das cuenta de que puedes recitar todo lo que dijiste tú y casi nada de lo que dijo la otra persona.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Sigue preguntando por la otra persona cada vez que la respuesta sea sobre el desempeño de la persona.",
      "Alégrate con calidez cuando la persona la describa de verdad.",
      "Nunca nombres tú el patrón."
    ],
    "opening_beat": "«Entonces, ¿cómo es de verdad?»",
    "success_looks_like": "La persona se da cuenta de que la atención estuvo apuntando hacia dentro toda la noche."
  }$j$::jsonb,
  'Hoy, pillate a ti mismo comprobando cómo lo estás haciendo en una conversación. Apunta qué estabas comprobando y qué te perdiste mientras lo hacías.',
  $j${
    "beats": [
      {
        "situation": "Llegas a casa después de dos horas de conversación perfectamente agradable y estás completamente agotado.",
        "prompt": "¿Qué te cansó?",
        "options": [
          { "text": "Hablar con alguien nuevo durante dos horas.", "correct": false, "note": "Eso lo haces en el trabajo con regularidad sin necesitar tumbarte después." },
          { "text": "La vigilancia corriendo por debajo.", "correct": true, "note": "¿Lo estoy haciendo bien?, ¿aterrizó eso?, ¿le gusto? — de forma continua, durante dos horas. La conversación nunca fue la parte cara." },
          { "text": "Los nervios de antes.", "correct": false, "note": "Esos cayeron a los diez minutos. Esta es una factura distinta y corrió toda la noche." },
          { "text": "Tener que ser interesante durante tanto tiempo.", "correct": false, "note": "Un síntoma de la misma postura, y una parte menor del total." }
        ]
      },
      {
        "situation": "Un amigo te pregunta cómo es de verdad. Te das cuenta de que puedes recitar todo lo que dijiste tú y muy poco de lo que dijo la otra persona.",
        "prompt": "¿Qué te dice eso?",
        "options": [
          { "text": "No dijo mucho.", "correct": false, "note": "Seguramente dijo bastante. La atención estuvo apuntando a otro sitio la mayor parte del tiempo." },
          { "text": "Fue una mala cita.", "correct": false, "note": "Puede que fuera una buena cita. Lo que sabes es a dónde fue tu atención, no qué pasó." },
          { "text": "Estabas nervioso.", "correct": false, "note": "Cierto y no lo bastante concreto como para actuar. Los nervios por sí solos no te impiden oír a la gente." },
          { "text": "Te pasaste la noche haciendo una prueba de casting.", "correct": true, "note": "La señal. Pasara lo que pasara, no saliste de ahí habiendo averiguado mucho de ella — que era lo único que te tocaba averiguar a ti." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('do-you-like-them', 2,
  '¿Estoy disfrutando esto?',
  $md$Hay dos preguntas disponibles en una primera cita y solo una de las dos se puede responder.

*¿Va bien esto?* te exige adivinar el estado interior de otra persona desde el otro lado de una mesa, usando señales que no puedes verificar, mientras estás nervioso. Nadie se le da bien, y equivocarse en cualquiera de las dos direcciones es habitual — la gente sale de citas segura de que fue mal y recibe un mensaje esa misma noche, y al revés.

*¿Estoy disfrutando esto?* lo puedes responder al instante y con precisión en cualquier segundo de la noche.

**La jugada:** haz la segunda, a propósito, hacia los veinte minutos.

Es un acto deliberado y no un estado de ánimo, y lleva unos tres segundos. En algún momento de la primera media hora, para y comprueba: *ahora mismo, ¿me lo estoy pasando bien?* La respuesta llega de inmediato y casi nunca es ambigua.

Lo que hace es más grande que la respuesta. Preguntarlo mueve tu atención de una suposición a una observación, y la atención que ha dejado de suponer está disponible para la conversación — que, en una de las ironías más útiles de esta aplicación, es exactamente lo que hace que la primera pregunta también vaya bien. Alguien genuinamente absorto en una conversación es mucho mejor compañía que alguien vigilándola.

La respuesta también es útil en sí misma. Si es sí, sabes qué hacer al final y puedes dejar de darle vueltas. Si es no, tienes noventa minutos para averiguar si es la situación o la persona — y esas dos cosas son de verdad distintas, porque los primeros diez minutos de cualquier cosa pueden ser planos.

Y merece la pena tener una respuesta concreta en vez de una sensación general. *Sí, sobre todo cuando hablaba mal de su propio trabajo* es información. *Está bien* es la vigilancia disfrazada, porque *bien* es una puntuación.

Si te quedas con una cosa: haz una pregunta que puedas responder. La otra es una suposición que vas a estar haciendo durante dos horas y que no puedes verificar.$md$,
  $j$[
    {
      "situation": "Veinte minutos después y estás intentando averiguar cómo va.",
      "line": "(pregúntate en su lugar si lo estás disfrutando)",
      "why": "Una es una suposición sobre el estado interior de otra persona hecha mientras estás nervioso. La otra la puedes responder al instante y con precisión."
    },
    {
      "situation": "Lo compruebas, y la respuesta es sí — sobre todo cuando hablaba mal de su propio trabajo.",
      "line": "(esa es una respuesta de verdad)",
      "why": "Lo concreto gana a lo general. Está bien es la vigilancia disfrazada, porque bien es una puntuación y no una observación."
    },
    {
      "situation": "Lo compruebas y la respuesta es no, a los diez minutos.",
      "line": "(noventa minutos para averiguar si es ella o la situación)",
      "why": "Los primeros diez minutos de cualquier cosa pueden ser planos. Un no en el minuto diez es información sobre el principio, todavía no sobre la persona."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué preguntar si va bien es la pregunta equivocada?",
      "options": [
        { "text": "Es pesimista.", "correct": false, "note": "Es neutra de tono. El problema es que no se puede responder, no cómo se siente." },
        { "text": "Te hace cohibirte.", "correct": false, "note": "Lo hace, y eso es consecuencia del problema más profundo." },
        { "text": "No la puedes responder.", "correct": true, "note": "Exige adivinar el estado interior de alguien desde el otro lado de una mesa, mientras estás nervioso. La gente sale segura de que fue mal y recibe un mensaje esa misma noche." },
        { "text": "Le pone presión a la noche.", "correct": false, "note": "Vago. Nombra el mecanismo: no hay forma de verificar tu respuesta." }
      ],
      "explain": "Haz una pregunta que puedas responder. La otra es una suposición que no puedes verificar."
    },
    {
      "prompt": "¿Qué cambia de verdad hacer la pregunta mejor?",
      "options": [
        { "text": "Baja lo que está en juego.", "correct": false, "note": "Lo que está en juego es lo que es. Lo que cambia es a dónde va tu atención." },
        { "text": "Te da un motivo para irte antes.", "correct": false, "note": "Puede, y eso es un resultado, no el mecanismo." },
        { "text": "Deja de importarte lo que piense.", "correct": false, "note": "Puedes importarte. Esto va sobre qué pregunta estás trabajando." },
        { "text": "La atención que ha dejado de suponer está disponible para la conversación.", "correct": true, "note": "Que es por lo que también hace que la primera pregunta vaya bien — alguien absorto en una conversación es mucho mejor compañía que alguien vigilándola." }
      ],
      "explain": "Es una comprobación deliberada, hacia los veinte minutos, y lleva tres segundos."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked", "label": "Comprobó de verdad", "description": "Paró y se hizo la pregunta a propósito." },
      { "key": "answerable", "label": "Hizo la respondible", "description": "Sobre su propio disfrute en vez de sobre cómo estaba aterrizando." },
      { "key": "specific", "label": "Consiguió una respuesta concreta", "description": "Nombró qué estaba disfrutando en vez de conformarse con bien." },
      { "key": "acted", "label": "Usó la respuesta", "description": "Dejó que informara el resto de la noche." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo escribiéndote a mitad de la cita",
      "mood": "Cotilla, cariñoso.",
      "openness": 5,
      "personality": "Hace la pregunta directa y no le impresionan las respuestas sobre cómo está aterrizando."
    },
    "setting": "Veinticinco minutos después. Te has apartado un momento y tu móvil tiene un mensaje.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta otra vez, más directamente, si la respuesta es sobre lo que parece pensar la otra persona.",
      "Acepta y alégrate con cualquier respuesta concreta sobre la experiencia de la persona.",
      "Nunca digas tú el replanteamiento."
    ],
    "opening_beat": "«¿Y bien? ¿Qué tal va?»",
    "success_looks_like": "La persona responde sobre su propio disfrute en vez de sobre cómo parece que va."
  }$j$::jsonb,
  'Hoy, para una vez en una conversación y pregúntate si la estás disfrutando. Apunta la respuesta y lo concreto que pudiste ser.',
  $j${
    "says": "¿Y bien? ¿Qué tal va?",
    "model": {
      "line": "Lo estoy disfrutando, la verdad — sobre todo cuando habla mal de su propio trabajo.",
      "why": "Una respuesta sobre tu propia experiencia, que puedes dar al instante y con precisión, en vez de una suposición sobre la de ella. Y concreta, porque bien es una puntuación disfrazada."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Responde sobre ti, no sobre cómo está aterrizando" },
      { "kind": "forbids_any", "words": ["parece que", "creo que ella", "difícil de decir", "espero que", "puede que ella", "va bien", "va mal", "ni idea de si"], "requirement": "No una suposición sobre su estado interior" },
      { "kind": "min_words", "n": 8, "requirement": "Di qué en concreto" },
      { "kind": "max_words", "n": 30, "requirement": "Una línea — estás en un baño" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('do-you-like-them', 3,
  'Qué fijarte de verdad',
  $md$*¿Estoy disfrutando esto?* es fácil de preguntar y sorprendentemente fácil de maquillar, porque dos horas de educación producen un resplandor general que no es lo mismo que apreciar a alguien. Así que ayuda tener cosas concretas en las que fijarse.

**La jugada:** revisa cuatro cosas, todas sobre ti.

**¿Estás hablando, o actuando?** Actuar tiene una sensación particular: estás seleccionando, editando, eligiendo la mejor versión. Hablar no. Si notas que llevas diez minutos sin editar nada, esa es una señal fuerte, y es la más fiable de la lista.

**¿Quieres contarle cosas?** No responder cosas — contarle. Las ganas de decir *ah, esto es como lo que decía antes* son interés genuino haciéndose notar, y su ausencia merece la pena registrarla. Dos horas de buenas respuestas y ninguna gana de ofrecer nada es un no silencioso.

**¿Te reíste, o produjiste una risa?** Todo el mundo produce risas en una primera cita y no valen nada como prueba. Una risa real vale como información lo que toda la noche.

**¿Te aliviaría o te decepcionaría que tuviera que irse en diez minutos?** Esta es la pregunta más brutalmente precisa de todo el tema. La respuesta llega antes de que puedas arreglarla y casi nunca se equivoca.

Dos cosas que merece la pena descartar mientras tanto. Los nervios no son que te caiga mal, y se sienten parecidos desde dentro — no leas tu propia adrenalina como un veredicto sobre la otra persona. Y la atracción en una primera cita a menudo todavía no ha llegado aunque todo lo demás sí; su ausencia en la hora dos no es la respuesta que la gente cree que es.

Si te quedas con una cosa: la pregunta de los diez minutos. Hazla una vez, quédate con la primera respuesta, y no la negocies.$md$,
  $j$[
    {
      "situation": "Te das cuenta de que llevas diez minutos sin editar nada de lo que dices.",
      "line": "(esa es la señal más fuerte que hay)",
      "why": "Actuar tiene una sensación particular — seleccionar, elegir la mejor versión. Su ausencia es lo más fiable de la lista."
    },
    {
      "situation": "Has respondido todo bien y no has ofrecido nada.",
      "line": "(eso es un no silencioso)",
      "why": "Las ganas de contarle algo a alguien son interés genuino haciéndose notar. Dos horas sin ellas merece la pena registrarlas."
    },
    {
      "situation": "Dice que igual tiene que irse en diez minutos.",
      "line": "(¿aliviado o decepcionado?)",
      "why": "La pregunta más precisa del tema. La respuesta llega antes de que puedas arreglarla y casi nunca se equivoca."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué señal es la más fiable?",
      "options": [
        { "text": "Si la conversación fluyó.", "correct": false, "note": "Que fluya tiene sobre todo que ver con que los dos seáis educados y razonablemente buenos hablando. Muchas conversaciones que fluyen no llevan a ningún sitio." },
        { "text": "Si te reíste mucho.", "correct": false, "note": "Todo el mundo produce risas en una primera cita. Una real es información; muchas son buenos modales." },
        { "text": "Si dejaste de editar lo que decías.", "correct": true, "note": "Actuar tiene una sensación distinta — seleccionar, elegir la mejor versión. Diez minutos sin ella es la señal más fuerte que hay." },
        { "text": "Si te pareció atractiva.", "correct": false, "note": "A menudo todavía no ha llegado en una primera cita aunque todo lo demás sí, y su ausencia en la hora dos no es el veredicto que la gente cree que es." }
      ],
      "explain": "Las cuatro comprobaciones son sobre ti, porque eres la única persona cuyo estado interior puedes leer de verdad."
    },
    {
      "prompt": "Dice que igual tiene que irse en diez minutos. ¿Para qué sirve eso?",
      "options": [
        { "text": "Averiguar si está interesada.", "correct": false, "note": "Te dice algo sobre su noche y nada fiable sobre su interés." },
        { "text": "Decidir si decir lo evidente.", "correct": false, "note": "Eso viene después y se deriva de la respuesta en vez de ser la respuesta." },
        { "text": "Nada — es solo logística.", "correct": false, "note": "La logística es irrelevante. Lo que importa es el medio segundo antes de decidir cómo sentirte al respecto." },
        { "text": "Tu primera reacción, que llega antes de que puedas arreglarla.", "correct": true, "note": "Aliviado o decepcionado. Es la pregunta más brutalmente precisa del tema, y casi nunca se equivoca." }
      ],
      "explain": "Quédate con la primera respuesta y no la negocies."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "editing", "label": "Se fijó en si estaba editando", "description": "Comprobó si actuaba en vez de hablar." },
      { "key": "volunteering", "label": "Se fijó en las ganas de contarle cosas", "description": "Registró si algo quería ofrecerse por iniciativa propia." },
      { "key": "first_reaction", "label": "Se quedó con la primera reacción", "description": "Usó la respuesta de aliviado o decepcionado sin negociarla." },
      { "key": "ruled_out", "label": "No confundió los nervios con que le cayera mal", "description": "Leyó su propia adrenalina como adrenalina." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo con quien te estás escribiendo después",
      "mood": "Paciente, directo.",
      "openness": 5,
      "personality": "Hace las cuatro preguntas una a una y no acepta fue agradable como respuesta a ninguna."
    },
    "setting": "Hora y media después. Ha sido agradable todo el rato y de verdad no sabes qué piensas.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Haz una comprobación concreta cada vez y rechaza las impresiones generales.",
      "Acepta con calidez una observación concreta, apunte a sí o a no.",
      "Nunca le digas a la persona qué significa su respuesta."
    ],
    "opening_beat": "«Vale, olvida si fue bien. ¿En algún momento dejaste de editarte?»",
    "success_looks_like": "La persona responde con observaciones concretas en vez de con una impresión general."
  }$j$::jsonb,
  'Hoy, aplica las cuatro comprobaciones a una conversación. Apunta cuál te dio la respuesta más clara.',
  $j${
    "beats": [
      {
        "situation": "Noventa minutos después. Ha fluido, los dos os habéis reído mucho, y de verdad no sabes qué piensas.",
        "prompt": "¿Cuál de estas vale algo como prueba?",
        "options": [
          { "text": "La conversación fluyó todo el rato.", "correct": false, "note": "Que fluya sobre todo significa dos personas educadas y razonablemente buenas hablando. Muchas conversaciones que fluyen no llevan a ningún sitio en absoluto." },
          { "text": "Los dos os habéis reído mucho.", "correct": false, "note": "Todo el mundo produce risas en una primera cita. Una real es información; muchas son buenos modales." },
          { "text": "Llevas diez minutos sin editar nada de lo que dices.", "correct": true, "note": "Actuar tiene una sensación distinta — seleccionar, elegir la mejor versión. Su ausencia es la señal más fuerte que hay." },
          { "text": "Te ha hecho muchas preguntas.", "correct": false, "note": "Información sobre ella, puede, y todo este bloque va sobre leerte a ti." }
        ]
      },
      {
        "situation": "Menciona que igual tiene que irse en diez minutos.",
        "prompt": "¿Qué haces con eso?",
        "options": [
          { "text": "Averigua si significa que quiere irse.", "correct": false, "note": "Vuelta a adivinar el estado interior de otra persona, que es justo lo que este bloque existe para evitar." },
          { "text": "Fíjate en si tu primera reacción fue alivio o decepción.", "correct": true, "note": "La pregunta más brutalmente precisa del tema. La respuesta llega antes de que puedas arreglarla, y casi nunca se equivoca." },
          { "text": "Propón una copa más para ver qué dice.", "correct": false, "note": "Una prueba para ella en vez de una lectura de ti, y convierte la noche en una negociación." },
          { "text": "Nada — es solo logística.", "correct": false, "note": "La logística es irrelevante. Lo útil es el medio segundo antes de decidir cómo sentirte al respecto." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('do-you-like-them', 4,
  'Está permitido que sea un no',
  $md$Todo este bloque se viene abajo a menos que el no esté de verdad disponible, y para mucha gente no lo está — no en principio, sino en la práctica, que es una cosa distinta y más terca.

Los motivos suelen quedarse sin decir. Se sintió como que fue bien, y rechazar algo que fue bien parece desagradecido. Fue simpática, y *simpática* se ha convertido en silencio en un motivo. No ha aparecido nadie más. Ha pasado un tiempo. No estás seguro de poder permitirte ser exigente.

**La jugada:** date cuenta de que no sentirte atraído por alguien es un motivo completo, y no necesita ningún defecto pegado.

Esa es la trampa concreta. La gente va a buscar algo malo en la otra persona, porque un defecto justificaría la decisión — y si no encuentra ninguno, concluye que debería darle otra oportunidad. Pero *no lo disfruté* no necesita ninguna prueba de apoyo. No es una acusación sobre la otra persona, no necesita ser defendible, y no es algo que tengas que poder explicarle a un amigo.

Las segundas citas organizadas por educación son la pérdida de tiempo más común en las citas, y no son amables con nadie. La otra persona se está pasando una noche con alguien que ya ha decidido. Eso no le sirve a nadie, incluida la versión de ti que preferiría no haber ido.

Hay una versión de esto específica para la gente que no tiene muchas citas, y merece la pena nombrarla: la escasez hace que el no se sienta caro. No lo es. Decir sí a algo que no disfrutaste no aumenta tus probabilidades de nada, solo llena un jueves y refuerza la idea de que las citas son un suplicio que hay que aguantar.

Y el replanteamiento que lo hace llevadero: una noche que produjo un no claro fue una noche exitosa. Esa era la pregunta. La respondiste en dos horas, que es rápido.

Si te quedas con una cosa: no necesitas ningún motivo más allá de no querer. Buscar un defecto para justificarlo es cómo la gente se convence a sí misma de aceptar una segunda cita.$md$,
  $j$[
    {
      "situation": "Fue bien y no lo disfrutaste, y las dos cosas son ciertas.",
      "line": "(eso está permitido, y es suficiente)",
      "why": "Rechazar algo que fue bien se siente desagradecido. No lo es — que fuera bien nunca fue la pregunta que estabas ahí para responder."
    },
    {
      "situation": "Estás buscando algo malo en ella para justificar la decisión.",
      "line": "(no necesitas un defecto)",
      "why": "Un defecto lo haría defendible, y si no encuentras ninguno te convences a ti mismo de darle otra oportunidad. No lo disfruté no necesita ninguna prueba de apoyo."
    },
    {
      "situation": "Ha pasado mucho tiempo desde la última cita.",
      "line": "(la escasez no hace que el no sea caro)",
      "why": "Decir sí a algo que no disfrutaste no aumenta tus probabilidades de nada. Llena un jueves y confirma que las citas son un suplicio."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué la gente va a buscar un defecto?",
      "options": [
        { "text": "Porque están siendo justos.", "correct": false, "note": "Parece justicia y funciona como un requisito para darse permiso." },
        { "text": "Porque un defecto justificaría la decisión.", "correct": true, "note": "Y si no encuentran ninguno, concluyen que deberían darle otra oportunidad. No querer ya es un motivo completo." },
        { "text": "Porque si no, se arrepentirán.", "correct": false, "note": "Ese es un miedo distinto, y no es para eso para lo que sirve la caza de defectos." },
        { "text": "Porque los amigos van a preguntar por qué.", "correct": false, "note": "A veces, y la respuesta honesta a un amigo es la misma que la respuesta honesta a ti mismo." }
      ],
      "explain": "No lo disfruté no es una acusación y no tiene que ser defendible."
    },
    {
      "prompt": "¿A quién sirve una segunda cita por educación?",
      "options": [
        { "text": "A ella — es más amable que un no.", "correct": false, "note": "Se está pasando una noche con alguien que ya ha decidido. Esa no es la versión amable." },
        { "text": "A nadie.", "correct": true, "note": "Incluida la versión de ti que preferiría no haber ido, y que ahora tiene una noche libre menos y un poco más de prueba de que las citas son un suplicio." },
        { "text": "A ti — puede que cambies de opinión.", "correct": false, "note": "Pasa de vez en cuando. No es un plan, e ir para comprobar es distinto de ir porque quieres." },
        { "text": "A los dos, un poco.", "correct": false, "note": "La respuesta cómoda, y es cómo se organizan dos semanas de educación." }
      ],
      "explain": "Una noche que produjo un no claro fue una noche exitosa. Esa era la pregunta."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "allowed", "label": "Permitió el no", "description": "Trató no querer como un motivo completo." },
      { "key": "no_fault", "label": "No cazó defectos", "description": "Evitó necesitar algo malo en la otra persona para justificarlo." },
      { "key": "no_scarcity", "label": "Ignoró la escasez", "description": "No trató una mala racha como un motivo para decir sí." },
      { "key": "clean", "label": "Lo llamó un éxito", "description": "Trató una respuesta clara como el sentido de la noche." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo preguntando qué tal fue",
      "mood": "Cálido y sin prisa.",
      "openness": 5,
      "personality": "Pregunta si la persona quiere volver a verla, y sigue volviendo a eso cuando la respuesta se convierte en una valoración de la otra persona."
    },
    "setting": "La mañana después. Fue perfectamente agradable, ella fue perfectamente simpática, y no quieres volver a verla — y te cuesta decirlo en voz alta.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Vuelve a la pregunta cada vez que la respuesta se convierta en cómo era la otra persona.",
      "Acepta un no claro de inmediato y sin preguntar por qué.",
      "Nunca le sugieras un motivo a la persona."
    ],
    "opening_beat": "«Vale, pero ¿quieres volver a verla?»",
    "success_looks_like": "La persona dice que no sin necesitar un defecto para justificarlo."
  }$j$::jsonb,
  'Hoy, rechaza algo pequeño sin dar un motivo. Apunta qué rechazaste y si añadiste una justificación de todas formas.',
  $j${
    "says": "Vale, pero ¿quieres volver a verla?",
    "model": {
      "line": "No. Fue perfectamente simpática y no lo disfruté, y creo que con eso basta.",
      "why": "Sin ningún defecto pegado y sin necesitar ninguno. Buscar algo malo en la otra persona es cómo la gente se convence de aceptar una segunda cita que no quería."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["un poco aburrida", "demasiado insistente", "molesta", "algo raro", "no me atrajo", "la forma en que", "no paraba de hablar de", "maleducada"], "requirement": "No necesitas un defecto para justificarlo" },
      { "kind": "min_words", "n": 6, "requirement": "Dilo, no lo dejes en el aire" },
      { "kind": "max_words", "n": 35, "requirement": "No necesita un argumento" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('do-you-like-them', 5,
  'No tienes que saberlo',
  $md$Entre sí y no hay una tercera respuesta, y es la más habitual después de una primera cita de verdad: todavía no lo sabes.

Eso no es indecisión y no es un no suave. La mayoría de la gente no puede saber en dos horas si le gusta alguien, porque dos horas no es mucho tiempo y los dos estabais actuando un poco durante los primeros treinta minutos. Esperar certeza es el error, y produce dos malos resultados: la gente se convence a sí misma de un sí que no siente, o trata la ausencia de un sí claro como un no y borra en silencio algo que iba a ser bueno.

**La jugada:** trata *me gustaría averiguarlo* como una postura completa.

Es una respuesta real y basta para actuar sobre ella. Una segunda cita no es un compromiso, es el resto de la pregunta — y es un instrumento mucho mejor para responderla que otra hora pensando en la primera.

Hay una prueba concreta que ayuda aquí, y es distinta de las de las lecciones anteriores porque mira hacia adelante en vez de hacia atrás. No *¿me gusta?*, sino *¿me alegraría ver su nombre en mi móvil el jueves?* La incertidumbre sobre la persona a menudo se resuelve al instante en una respuesta clara sobre la perspectiva.

Lo único que no hay que hacer es quedarse en el medio durante dos semanas. La incertidumbre está bien como postura y sale cara como hábito: el mensaje se queda sin responder, el momento se enfría, y un puede que genuino se convierte en un no por defecto — que es el mismo resultado que decidir, sin el beneficio de haber decidido.

Y se aplica a las lentas. Muchas cosas buenas empezaron con dos personas que pensaron que la primera cita estuvo bien. Bien no es un estado de fallo, es un punto de partida corriente, y la gente que insiste en tener certeza desde un primer encuentro suele acabar con una lista más corta.

Si te quedas con una cosa: *todavía no lo sé, y me gustaría averiguarlo* es una respuesta. Dítelo a ti mismo, y luego actúa según eso.$md$,
  $j$[
    {
      "situation": "Llegas a casa genuinamente inseguro.",
      "line": "Todavía no lo sé, y me gustaría averiguarlo.",
      "why": "Una postura completa y suficiente para actuar. Una segunda cita no es un compromiso, es el resto de la pregunta."
    },
    {
      "situation": "No sabes si te gusta.",
      "line": "(¿te alegraría ver su nombre el jueves?)",
      "why": "Mira hacia adelante en vez de hacia atrás, y la incertidumbre sobre una persona a menudo se resuelve al instante en una respuesta clara sobre la perspectiva."
    },
    {
      "situation": "Han pasado cinco días y todavía estás decidiendo.",
      "line": "(eso es un no llegando por defecto)",
      "why": "La incertidumbre está bien como postura y sale cara como hábito. El momento se enfría y consigues el mismo resultado sin haber decidido nada."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué esperar certeza es un error?",
      "options": [
        { "text": "Porque la atracción lleva tiempo.", "correct": false, "note": "A menudo cierto y es un caso concreto, no el punto general." },
        { "text": "Porque dos horas no es mucho tiempo, y los dos estabais actuando parte del rato.", "correct": true, "note": "La mayoría de la gente no puede saberlo en una primera cita, que es lo normal. Exigir certeza produce o un sí fabricado o un no por defecto." },
        { "text": "Porque siempre vas a encontrar dudas.", "correct": false, "note": "Un problema distinto, y que también se aplica a la gente que está segura." },
        { "text": "Porque le pone presión a la segunda cita.", "correct": false, "note": "No especialmente. El coste recae en si llega a haber una siquiera." }
      ],
      "explain": "Me gustaría averiguarlo es una respuesta real, no la falta de una."
    },
    {
      "prompt": "¿Cuál es la pregunta útil cuando no lo sabes?",
      "options": [
        { "text": "¿Qué lamentaría más?", "correct": false, "note": "Minimizar el arrepentimiento te pide modelar dos futuros, que es más difícil que aquello con lo que ya tenías problemas." },
        { "text": "¿Me atrae?", "correct": false, "note": "A menudo no se resuelve en una primera cita aunque todo lo demás sí, así que no desempata nada." },
        { "text": "¿Me alegraría ver su nombre en mi móvil el jueves?", "correct": true, "note": "Mira hacia adelante en vez de hacia atrás, y la incertidumbre sobre una persona a menudo se resuelve al instante en una respuesta clara sobre la perspectiva." },
        { "text": "¿Qué pensaron mis amigos de ella?", "correct": false, "note": "No la han conocido. Y le pasa a otra persona una pregunta que es tuya." }
      ],
      "explain": "Pregunta sobre el jueves, no sobre ella."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "allowed_maybe", "label": "Permitió no saber", "description": "Trató la incertidumbre como una postura en vez de un fallo." },
      { "key": "acted", "label": "Actuó según eso", "description": "No esperó a tener certeza antes de hacer nada." },
      { "key": "forward_test", "label": "Hizo la pregunta hacia adelante", "description": "Comprobó cómo se sentía sobre la perspectiva en vez de sobre la noche." },
      { "key": "no_drift", "label": "No se dejó llevar", "description": "Evitó que un puede que se convirtiera en un no por defecto." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo preguntando al respecto",
      "mood": "Práctico.",
      "openness": 5,
      "personality": "Cómodo con no saber e impaciente con dejarse llevar. Pregunta qué va a hacer la persona al respecto."
    },
    "setting": "Al día siguiente. Fue bueno en partes, plano en otras, y de verdad no sabes qué piensas.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Acepta no lo sé como una respuesta real sin presionar por un veredicto.",
      "Presiona con firmeza sobre cualquier plan que implique esperar a ver cómo se siente.",
      "Nunca le digas a la persona qué decidir."
    ],
    "opening_beat": "«Entonces es un puede que. ¿Qué vas a hacer al respecto?»",
    "success_looks_like": "La persona trata no saber como una postura y actúa según eso de todas formas."
  }$j$::jsonb,
  'Hoy, actúa sobre algo de lo que solo estás medio seguro en vez de esperar a tener certeza. Apunta qué hiciste.',
  $j${
    "says": "Entonces es un puede que. ¿Qué vas a hacer al respecto?",
    "model": {
      "line": "Volver a pedirle una cita. Todavía no lo sé y me alegraría ver su nombre el jueves, que es suficiente para seguir adelante.",
      "why": "No saber es una postura y no la falta de una, y una segunda cita es el resto de la pregunta y no un compromiso. La prueba hacia adelante desempató."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["ver cómo me siento", "esperar a ver", "dejarlo unos días", "si me escribe", "consultarlo con la almohada", "darle una semana", "ver si ella"], "requirement": "No esperes a tener certeza" },
      { "kind": "min_words", "n": 10, "requirement": "Di qué vas a hacer de verdad" },
      { "kind": "max_words", "n": 40, "requirement": "Una decisión, no una deliberación" }
    ]
  }$j$::jsonb
);
