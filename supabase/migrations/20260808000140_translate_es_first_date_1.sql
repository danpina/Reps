-- Spanish: La primera cita, track 1 — Antes de ir.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partners "Robin" (lessons 1-2) and "Sam" (lessons 3-5) carry no `sex`
-- field; masculine agreement used by default, as established with Robin
-- in the small-talk migrations and Sam in the Running the app track.

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

select pg_temp.es_lesson('before-you-go', 1,
  'Un sitio del que puedas irte',
  $md$El local decide más sobre una primera cita que cualquier cosa que digáis los dos, y la mayoría de la gente lo elige por el motivo equivocado — lo bonito que es, en vez de lo fácil que es.

**La jugada:** una copa, en algún sitio con algo de ruido, durante una hora o dos.

Cada parte de eso está haciendo un trabajo. Una copa no tiene una duración natural, así que puede ser cuarenta minutos o tres horas sin que ninguna de las dos sea una declaración. El ruido te da algo a lo que reaccionar y le quita presión al silencio. Y un bar o una cafetería tienen otras cosas que mirar, que suena trivial y no lo es — dos personas sin nada en la sala que señalar tienen que generar absolutamente todo entre ellas.

Cenar es el error habitual, y merece la pena ser concreto sobre por qué. Te comprometes a la duración de tres platos, sentado justo enfrente de alguien sin nada que mirar salvo a esa persona, con el horario de la cocina en vez del tuyo. Además es lo bastante caro como para sentirse como una ocasión, lo que sube lo que se supone que tiene que ser la noche. Nada de eso es fatal — la gente tiene buenas cenas en primeras citas constantemente — es sencillamente la opción más difícil, elegida por gente que creía estar siendo generosa.

Cualquier cosa con una pantalla es peor, porque has organizado una noche en la que no podéis hablar el uno con el otro y luego tenéis veinte minutos después para averiguar si podéis.

Caminar y hablar funciona sorprendentemente bien si el tiempo acompaña: no hay que negociar ninguna posición para sentarse, no hay obligación de contacto visual, un suministro constante de cosas que comentar, y termina de forma natural en una esquina. Es el secreto mejor guardado de este tema para cualquiera al que le cueste sentarse enfrente de alguien.

Si te quedas con una cosa: elige por la facilidad de salida, no por lo impresionante. Una copa en algún sitio corriente es la sala en la que de verdad han pasado la mayoría de las buenas primeras citas.$md$,
  $j$[
    {
      "situation": "Estás eligiendo entre un restaurante bonito y un bar al final de la calle.",
      "line": "(el bar)",
      "why": "Una copa no tiene una duración natural, así que cuarenta minutos y tres horas están las dos bien. Cenar te compromete a tres platos con el horario de la cocina."
    },
    {
      "situation": "Quieres algún sitio tranquilo para poder oíros bien.",
      "line": "(un poco de ruido es tu amigo)",
      "why": "El silencio en una sala silenciosa es ruidoso. El ruido de fondo le quita presión a las pausas y os da a los dos algo a lo que reaccionar."
    },
    {
      "situation": "Te cuesta sentarte justo enfrente de alguien.",
      "line": "(sugiere un paseo)",
      "why": "No hay que negociar dónde sentarse, no hay obligación de contacto visual, un suministro constante de cosas que comentar, y termina de forma natural en una esquina."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué una copa es mejor que cenar?",
      "options": [
        { "text": "Es más barato, así que hay menos presión.", "correct": false, "note": "El coste contribuye y es la parte menor. Muchas copas caras van perfectamente bien." },
        { "text": "No tiene una duración natural.", "correct": true, "note": "Cuarenta minutos y tres horas están las dos bien y ninguna es una declaración. Cenar te compromete a tres platos con el horario de otra persona." },
        { "text": "Beber lo hace más fácil.", "correct": false, "note": "Un mal motivo y un plan peor. El local es el que hace el trabajo, no el alcohol." },
        { "text": "Es más informal.", "correct": false, "note": "Cierto y vago. Nombra la propiedad real: puedes irte cuando sea el momento adecuado." }
      ],
      "explain": "Elige por la facilidad de salida. Esa es la propiedad que hace más fácil la noche."
    },
    {
      "prompt": "¿Para qué sirve un poco de ruido de fondo?",
      "options": [
        { "text": "Hace que se sienta más animado.", "correct": false, "note": "El ambiente es agradable y no es para eso para lo que sirve el ruido." },
        { "text": "Esconde los nervios en tu voz.", "correct": false, "note": "No especialmente, y nadie está escuchando eso." },
        { "text": "Significa que podéis acercaros para oíros.", "correct": false, "note": "Eso es una teoría de la acústica sacada de una frase de ligoteo, y una sala demasiado ruidosa como para oír es de verdad mala." },
        { "text": "El silencio en una sala silenciosa es ruidoso.", "correct": true, "note": "Dos horas tienen pausas dentro. El ruido les quita presión y os da a los dos algo a lo que reaccionar." }
      ],
      "explain": "Algún sitio donde pase algo. Dos personas sin nada que señalar tienen que generarlo todo ellas solas."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "leavable", "label": "Eligió un sitio del que se puede salir", "description": "Escogió un local sin duración fija." },
      { "key": "not_dinner", "label": "Evitó la sala más difícil", "description": "No recurrió por defecto a cenar o a una pantalla." },
      { "key": "easy", "label": "Eligió fácil antes que impresionante", "description": "Optimizó para la conversación en vez de para la ocasión." },
      { "key": "decided", "label": "Propuso algo de verdad", "description": "Nombró un lugar en vez de preguntar a dónde le gustaría ir." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "alguien con quien has quedado el jueves",
      "mood": "Con ganas, sin opiniones firmes.",
      "openness": 4,
      "personality": "Tranquilo y encantado de seguir una sugerencia concreta. Responde a una pregunta vaga con otra igual de vaga."
    },
    "setting": "Mensajes, dos días antes. Habéis quedado en veros el jueves y ninguno de los dos ha dicho dónde.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Acepta con rapidez y calidez cualquier sugerencia concreta.",
      "Responde a dónde te gustaría ir con no me importa, elige tú.",
      "Nunca sugieras tú un local."
    ],
    "opening_beat": "«Entonces — ¿a dónde vamos?»",
    "success_looks_like": "La persona propone un lugar concreto del que se puede salir en vez de preguntar qué le gustaría a la otra persona."
  }$j$::jsonb,
  'Hoy, elige tú el local para un plan en vez de pedirle a la otra persona que lo haga. Apunta dónde elegiste y por qué.',
  $j${
    "beats": [
      {
        "situation": "«Entonces — ¿a dónde vamos?» Tienes el jueves por la tarde y ningún plan.",
        "prompt": "¿Qué propones?",
        "options": [
          { "text": "El italiano que todo el mundo dice que está bien.", "correct": false, "note": "Tres platos, justo enfrente el uno del otro, con el horario de la cocina, y lo bastante caro como para convertirlo en una ocasión. La opción más difícil." },
          { "text": "Un bar de vinos tranquilo donde podáis oíros bien.", "correct": false, "note": "Cerca, y lo tranquilo es la parte a reconsiderar. El silencio en una sala silenciosa es ruidoso, y dos horas tienen pausas dentro." },
          { "text": "Lo que te apetezca — a mí me da igual.", "correct": false, "note": "Le pasa a la otra persona la gestión, y normalmente vuelve como a mí también me da igual, que es cómo la gente acaba cenando por defecto." },
          { "text": "Un bar cerca de la estación, a partir de las seis.", "correct": true, "note": "Sin duración fija, algo de ruido de fondo, cosas que mirar, y fácil de dejar o alargar. Corriente, y donde de verdad han pasado la mayoría de las buenas primeras citas." }
        ]
      },
      {
        "situation": "Te cuesta de verdad sentarte justo enfrente de alguien durante dos horas.",
        "prompt": "¿Hay una opción mejor?",
        "options": [
          { "text": "Un paseo por algún sitio, si el tiempo aguanta.", "correct": true, "note": "No hay que negociar dónde sentarse, no hay obligación de contacto visual, un suministro constante de cosas que comentar, y termina de forma natural en una esquina." },
          { "text": "Sentaos en la barra en vez de en una mesa.", "correct": false, "note": "De verdad mejor — lado a lado gana a enfrente — y es una versión más pequeña de la misma idea." },
          { "text": "Algo con una actividad, para que se hable menos.", "correct": false, "note": "Hablar menos no es el objetivo. Una actividad durante la que no podéis hablar os deja veinte minutos después para averiguar si podéis." },
          { "text": "Aguanta — la forma de sentarse no es el problema.", "correct": false, "note": "Para ti sí es parte del problema, y elegir teniéndolo en cuenta es gratis." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('before-you-go', 2,
  'Di la hora a la que te vas',
  $md$Ya conoces esta jugada. Es la salida que plantas en el pasillo de un congreso, y hace más trabajo en una primera cita que en ningún otro sitio de esta aplicación.

**La jugada:** decide cuánto tiempo te vas a quedar antes de ir, y dilo cuando llegues.

*Tengo que estar en un sitio a las ocho, pero* — dicho con ligereza, en los primeros dos minutos, como logística corriente — cambia toda la forma de la noche. Los dos sabéis ya que esto tiene un final, lo que significa que ninguno de los dos está calculando en silencio cómo va a terminar. Ese cálculo corre de fondo en casi todas las primeras citas y cuesta más atención de la que la gente cree.

También es un regalo para la otra persona, y esa es la parte que merece la pena entender, porque se siente como lo contrario. Alguien que no sabe cuánto se supone que dura esto está atrapado: no puede irse antes sin que sea un veredicto, y tampoco puede relajarse del todo. Un final declarado quita los dos problemas de golpe.

Con frecuencia te vas a quedar más tiempo, y esa es la buena versión. *Debería irme ya — en realidad, ¿quieres otra?* es un momento mucho mejor que las mismas dos horas sin ningún hito dentro, porque quedarse se convirtió en una elección que alguien tomó en vez de en algo que simplemente continuó.

Dos horas es el valor por defecto correcto. Lo bastante largo como para pasar de los primeros diez minutos y tener una conversación de verdad; lo bastante corto como para que nadie se canse. Si va genial, alargas, y si no, ya te han dado la salida.

Y sé honesto en vez de elaborado. Lo mejor es algo real que vayas a hacer después, un madrugón mañana está bien, y una emergencia inventada es innecesaria — nadie ha cuestionado nunca una hora de fin.

Si te quedas con una cosa: dilo en los primeros dos minutos, no en los últimos veinte. Dicho pronto es logística. Dicho tarde es una huida.$md$,
  $j$[
    {
      "situation": "Acabáis de sentaros con vuestras copas.",
      "line": "Tengo que estar en un sitio a las ocho, pero esto va bien para un par de horas.",
      "why": "Logística corriente, dicha en los primeros dos minutos. Los dos sabéis ya que esto tiene un final, así que ninguno está calculando en silencio cómo va a terminar."
    },
    {
      "situation": "Va bien y se acercan las ocho.",
      "line": "Debería irme ya — ¿quieres otra antes?",
      "why": "Quedarse se convierte en una elección que alguien tomó en vez de en algo que simplemente continuó, que es un momento mejor que dos horas sin ningún hito dentro."
    },
    {
      "situation": "Estás inventando un motivo para tener que estar en algún sitio.",
      "line": "(un madrugón basta)",
      "why": "Nadie ha cuestionado nunca una hora de fin. Una emergencia inventada es más esfuerzo y más que recordar."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué decirlo al principio en vez de cuando quieras irte?",
      "options": [
        { "text": "Dicho tarde es una huida; dicho pronto es logística.", "correct": true, "note": "La misma frase significa cosas completamente distintas según cuándo llegue. Al principio es información; al final es un veredicto con abrigo puesto." },
        { "text": "Puede que se te olvide.", "correct": false, "note": "No se te va a olvidar, y no es lo que te compra el momento en que lo dices." },
        { "text": "Baja las expectativas.", "correct": false, "note": "No baja nada. Quita una incógnita, que es distinto." },
        { "text": "Demuestra que tienes vida propia.", "correct": false, "note": "Gestión de la imagen, y un instinto ligeramente equivocado — esto no va sobre cómo quedas." }
      ],
      "explain": "Los primeros dos minutos. Es un dato, y deja de serlo más tarde."
    },
    {
      "prompt": "¿Cómo ayuda a la otra persona?",
      "options": [
        { "text": "Le dice cuánto esfuerzo hacer.", "correct": false, "note": "Nadie calibra el esfuerzo así, y es una lectura un poco desoladora de un gesto amable." },
        { "text": "Significa que puede planear su noche.", "correct": false, "note": "Prácticamente cierto y trivial al lado de lo que hace de verdad." },
        { "text": "Sin eso, no puede irse antes sin que sea un veredicto.", "correct": true, "note": "Está atrapado: ninguna salida que no diga algo, y tampoco ninguna forma de relajarse del todo. Un final declarado quita las dos cosas de golpe." },
        { "text": "Deja de preocuparle que no estés interesado.", "correct": false, "note": "Si acaso, una hora de fin podría sugerir lo contrario, y no lo hace, porque llegó como logística." }
      ],
      "explain": "Es un regalo disfrazado de límite. Los dos podéis dejar de calcular."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_it", "label": "Dijo una hora de fin", "description": "Nombró cuándo tendría que irse." },
      { "key": "early", "label": "Lo dijo pronto", "description": "En los primeros dos minutos en vez de al final." },
      { "key": "light", "label": "Lo mantuvo ligero", "description": "Lo entregó como logística, no como una advertencia." },
      { "key": "honest", "label": "Lo mantuvo honesto", "description": "Usó un motivo real en vez de una invención elaborada." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "la persona con la que estás en una cita",
      "mood": "Un poco nervioso, contento de estar aquí.",
      "openness": 4,
      "personality": "Se relaja visiblemente cuando la noche tiene una forma, y se mantiene inseguro sobre el tiempo si nadie lo fija."
    },
    "setting": "Acabáis de llegar, pedir las copas, y sentaros. Son las seis.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Relájate de forma notable cuando se mencione una hora de fin, y responde con algo fácil.",
      "Mantente algo inseguro y demasiado educado si no se le da ninguna forma a la noche.",
      "Nunca digas tú una hora de fin."
    ],
    "opening_beat": "«Vale. Bueno — hola. Esta es la parte en la que ninguno de los dos sabe qué decir.»",
    "success_looks_like": "La persona le da a la noche una hora de fin, con ligereza, en los primeros minutos."
  }$j$::jsonb,
  'Hoy, dile a alguien cuánto tiempo tienes al principio de algo en vez de al final. Apunta qué dijiste.',
  $j${
    "says": "Vale. Bueno — hola. Esta es la parte en la que ninguno de los dos sabe qué decir.",
    "model": {
      "line": "Sí que lo es. Tengo que estar en un sitio a las ocho, pero esto va bien hasta entonces.",
      "why": "Logística corriente en los primeros dos minutos. Los dos sabéis ya que la noche tiene una forma, así que ninguno está calculando en silencio cómo va a terminar."
    },
    "checks": [
      { "kind": "contains_any", "words": ["ocho", "siete", "nueve", "media", "un par de horas", "una hora", "dos horas", "hasta", "más tarde", "sobre las ocho"], "requirement": "Dale a la noche una hora de fin" },
      { "kind": "forbids_any", "words": ["perdona", "que sepas que", "debería decir", "por desgracia", "tengo que avisarte", "emergencia", "puede que tenga que"], "requirement": "Logística, no una advertencia o una excusa" },
      { "kind": "max_words", "n": 30, "requirement": "Ligero, y de pasada" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('before-you-go', 3,
  'Las cuatro horas antes',
  $md$La peor parte de una primera cita suele ser la tarde de esa misma cita, y a casi nadie se lo dicen de antemano.

El pavor vive en la anticipación. Se acumula a lo largo del día, alcanza su punto máximo hacia el momento de arreglarte, y luego cae en picado unos diez minutos después de llegar — un patrón tan fiable que merece la pena tratarlo como un hecho sobre cómo funciona esto en vez de como un hecho sobre ti.

**La jugada:** trata las horas previas a la cita como el tiempo que hace, y no tomes decisiones en ellas.

Las decisiones que la gente toma en esa ventana son todas malas y son todas la misma decisión: cancelar. Llega disfrazada de algo razonable — estás cansado, tienes demasiado encima, serías mala compañía esta noche, seguramente lo preferirían. Nada de eso es análisis. Es el sentimiento buscando una justificación, y está en su punto más persuasivo unos noventa minutos antes.

Dos cosas ayudan y ninguna es una actitud mental. Ten la tarde ocupada — de verdad ocupada, con algo que exija atención — porque el tiempo sin estructura antes de una cita son cuatro horas de ensayo para una conversación que no va a ir como la ensayaste. Y llega un poco antes en vez de llegar agobiado, porque llegar tarde convierte los nervios en algo mucho más físico del que luego tardas veinte minutos en bajar.

Lo que no ayuda es prepararse. No hay nada que preparar. Planear qué vas a decir produce material hacia el que luego tienes que dirigir la conversación, y dirigir es la forma más visible de esfuerzo que existe.

Lo único que merece la pena saber sobre los nervios en sí: no son una señal sobre la persona o la noche. Son una señal de que esto te importa, que es la respuesta correcta ante algo que importa, y es el mismo sentimiento que has tenido antes de cada cosa buena que has hecho en tu vida.

Si te quedas con una cosa: no canceles en las cuatro horas anteriores. Lo que sea que sientas entonces no es información.$md$,
  $j$[
    {
      "situation": "Son las cuatro y estás buscando un motivo para cancelar.",
      "line": "(eso es el sentimiento, no un motivo)",
      "why": "Llega disfrazado de algo sensato — cansado, demasiado encima, mala compañía esta noche — y está en su punto más persuasivo unos noventa minutos antes."
    },
    {
      "situation": "Tienes una tarde libre antes de la cita.",
      "line": "(llénala con algo que exija atención)",
      "why": "El tiempo sin estructura son cuatro horas de ensayo para una conversación que no va a ir como la ensayaste."
    },
    {
      "situation": "Estás planeando qué vas a decir.",
      "line": "(no hay nada que preparar)",
      "why": "Hacia el material planeado hay que dirigir la conversación, y dirigir es la forma más visible de esfuerzo que existe."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la forma fiable de los nervios?",
      "options": [
        { "text": "Se acumulan toda la noche y alcanzan su máximo al final.", "correct": false, "note": "Lo contrario de lo que pasa de verdad, y por eso tanta gente cancela antes de averiguarlo." },
        { "text": "Alcanzan su máximo mientras te arreglas y caen a los diez minutos de empezar.", "correct": true, "note": "Lo bastante fiable como para planear alrededor de ello. Es un hecho sobre la anticipación, no un hecho sobre ti." },
        { "text": "Dependen de cuánto te guste la persona.", "correct": false, "note": "Solo un poco, y no cambia qué hacer en las cuatro horas anteriores." },
        { "text": "Se van en cuanto la conversación empieza a fluir.", "correct": false, "note": "Cerca, y pone el alivio más tarde de cuando llega. La caída es al llegar, no en el primer buen intercambio." }
      ],
      "explain": "La tarde es la peor parte. Saberlo de antemano le quita algo de peso."
    },
    {
      "prompt": "¿Qué hace peligrosas las horas antes de la cita?",
      "options": [
        { "text": "Le vas a dar demasiadas vueltas a qué ponerte.", "correct": false, "note": "Ligeramente molesto y sin consecuencias." },
        { "text": "Vas a beber demasiado antes.", "correct": false, "note": "Un riesgo real para alguna gente, y no la decisión que hace perder la mayoría de las primeras citas." },
        { "text": "Te vas a imaginar a la persona a lo grande en tu cabeza.", "correct": false, "note": "Habitual, y sobre todo se resuelve solo a los diez minutos de conocerla." },
        { "text": "Cancelar se siente como una decisión razonable.", "correct": true, "note": "Llega con justificaciones pegadas — cansado, ocupado, lo preferirían. Eso es el sentimiento buscando un motivo, no un análisis." }
      ],
      "explain": "No decidas nada en esa ventana. Lo que sea que sientas ahí no es información."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "went", "label": "Fue", "description": "No canceló en la ventana." },
      { "key": "occupied", "label": "Llenó el tiempo", "description": "Mantuvo la tarde ocupada en vez de abierta." },
      { "key": "no_rehearsal", "label": "No ensayó", "description": "No preparó nada hacia lo que dirigir la conversación." },
      { "key": "early", "label": "Llegó sin agobios", "description": "Llegó a tiempo de bajar del trayecto." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo con quien te estás escribiendo",
      "mood": "Divertido, de tu parte.",
      "openness": 5,
      "personality": "Amable y del todo perspicaz. Se toma cada justificación en serio durante un segundo y luego la nombra."
    },
    "setting": "Las cuatro de la tarde del día de la cita. Quedan dos horas, nada que hacer, y un argumento que suena muy razonable para cancelar se está montando solo.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Trata cada justificación práctica como el sentimiento disfrazado, con calidez.",
      "Nunca le digas a la persona qué hacer — pregúntale qué pensaría mañana.",
      "Alégrate con naturalidad si decide ir."
    ],
    "opening_beat": "«Me vas a decir que estás pensando en cancelar, ¿verdad?»",
    "success_looks_like": "La persona reconoce el impulso de cancelar como el sentimiento y no como un motivo."
  }$j$::jsonb,
  'Hoy, date cuenta de algo que te da pavor y nombra la hora en la que el pavor alcanza su máximo. Hazlo de todas formas. Apunta las dos cosas.',
  $j${
    "beats": [
      {
        "situation": "Las cuatro. Quedan dos horas. Estás cansado, tienes mucho encima esta semana, y estás bastante seguro de que serías mala compañía esta noche.",
        "prompt": "¿Qué es eso?",
        "options": [
          { "text": "Una valoración justa — ir cuando estás apagado no ayuda a nadie.", "correct": false, "note": "Suena a juicio y llegó puntual. El mismo argumento se monta solo antes de cada cita y se disuelve a los diez minutos de llegar." },
          { "text": "El sentimiento, buscando una justificación.", "correct": true, "note": "El pavor alcanza su máximo unos noventa minutos antes y no se presenta como pavor — se presenta como tres motivos sensatos." },
          { "text": "Una señal de que no estás tan interesado.", "correct": false, "note": "Los nervios escalan con lo importante que sea algo. Si acaso, esto apunta en la otra dirección, y de cualquier forma no se puede decidir desde un sillón a las cuatro." },
          { "text": "Cansancio normal, sin relación con la cita.", "correct": false, "note": "Posible, y fíjate en que solo se volvió decisivo hoy." }
        ]
      },
      {
        "situation": "Has decidido ir. Tienes dos horas de tarde vacía por delante.",
        "prompt": "¿Cómo las pasas?",
        "options": [
          { "text": "Piensa en algunas cosas de las que hablar.", "correct": false, "note": "Hacia el material preparado hay que dirigir la conversación, y dirigir es la forma más visible de esfuerzo que existe." },
          { "text": "Descansa, para llegar fresco.", "correct": false, "note": "Dos horas sin estructura no son descanso antes de una cita. Son ensayo para una conversación que no va a ir como la ensayas." },
          { "text": "Algo que exija atención de verdad.", "correct": true, "note": "El tiempo ocupado es la intervención práctica. No es una actitud mental y funciona porque la alternativa son cuatro horas a solas contigo mismo." },
          { "text": "Arréglate despacio y sal con tiempo de sobra.", "correct": false, "note": "Llegar sin agobios de verdad merece la pena, y lleva veinte minutos, no dos horas." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('before-you-go', 4,
  'Dos o tres cosas sobre las que sientes curiosidad',
  $md$Hay una diferencia entre tener preguntas preparadas y sentir curiosidad, y se nota a los cuatro minutos.

Tener preguntas preparadas produce un interrogatorio. Preguntas, responden, sacas la siguiente, y todo el asunto tiene el ritmo de un formulario rellenándose — que es exactamente a lo que recurre alguien nervioso, porque una lista es algo a lo que agarrarse cuando temes los huecos.

**La jugada:** llega con dos o tres cosas que de verdad quieras saber, y deja que sean concretas.

No *a qué se dedica* — eso lo averiguas en treinta segundos y no lleva a ningún sitio. Algo sobre lo que de verdad te preguntes. Mencionaron que se mudaron aquí desde un sitio mucho más pequeño; quieres saber cómo fue eso. Su perfil decía que tienen opiniones sobre algo en lo que nunca has pensado; quieres oírlas. Dijeron algo en un mensaje que no acabaste de entender.

Eso es algo completamente distinto de una lista de preguntas, y se comporta de forma distinta en la conversación. La curiosidad produce preguntas de seguimiento por sí sola, porque de verdad quieres la respuesta — y las preguntas de seguimiento son lo que hace que alguien se sienta escuchado en vez de encuestado. Una pregunta preparada produce una respuesta y luego un silencio mientras vas a por la siguiente.

Dos o tres es el número. Más y vuelve a ser una lista. Y son una reserva, no un plan: si la conversación va a parar a otro sitio completamente distinto, ese es el mejor resultado y deberías dejar que pase, cosa que es mucho más fácil de hacer cuando sabes que tienes algo en el bolsillo por si se estanca.

También merece la pena tener algo que te gustaría contarles, por el mismo motivo. No una anécdota pulida — algo que te pasó esta semana y te hizo gracia o te molestó. Te da algo que ofrecer por iniciativa propia en el punto donde alguien callado, si no, solo respondería y pararía.

Si te quedas con una cosa: curiosidad, no preguntas. Una es algo que tienes; la otra es algo que despliegas, y la gente nota la diferencia de inmediato.$md$,
  $j$[
    {
      "situation": "Estás pensando qué preguntarles.",
      "line": "(piensa en su lugar qué es lo que de verdad quieres saber)",
      "why": "La curiosidad produce preguntas de seguimiento por sí sola, porque quieres la respuesta. Una pregunta preparada produce una respuesta y luego un silencio mientras vas a por la siguiente."
    },
    {
      "situation": "Mencionaron que se mudaron aquí desde un sitio mucho más pequeño.",
      "line": "(eso — cómo fue eso de verdad)",
      "why": "Concreto y de verdad abierto. Es la diferencia entre querer saber algo y tener algo que decir después."
    },
    {
      "situation": "La conversación ha ido a un sitio que no esperabas.",
      "line": "(déjala — la reserva es para cuando se estanque)",
      "why": "Tener dos o tres cosas en el bolsillo es lo que hace fácil abandonarlas. Un plan es algo al que tienes que volver."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué tiene de malo tener preguntas preparadas?",
      "options": [
        { "text": "Es un poco calculador.", "correct": false, "note": "Prepararse está bien y estar preparado no es el problema. El problema es qué preparaste." },
        { "text": "Se te van a olvidar.", "correct": false, "note": "Normalmente las recuerdas demasiado bien, que es lo que produce el ritmo de ir a buscarlas." },
        { "text": "Produce una respuesta y luego un silencio.", "correct": true, "note": "Una pregunta preparada no lleva ningún seguimiento pegado, así que vas a por la siguiente — y todo el asunto tiene el ritmo de un formulario rellenándose." },
        { "text": "Ya las habrán oído antes.", "correct": false, "note": "Las habrán oído, y una pregunta poco original cuya respuesta de verdad te importa sigue funcionando." }
      ],
      "explain": "La curiosidad produce preguntas de seguimiento por sí sola. Eso es lo que hace que alguien se sienta escuchado en vez de encuestado."
    },
    {
      "prompt": "¿Por qué también tener algo que quieras contarles?",
      "options": [
        { "text": "Para parecer interesante.", "correct": false, "note": "Apuntar a interesante es lo que produce la anécdota pulida, que es la versión que no funciona." },
        { "text": "Para equilibrar la conversación.", "correct": false, "note": "Cierto en el resultado y vago como motivo. Lo que importa es el momento concreto que rescata." },
        { "text": "Para llenar un silencio.", "correct": false, "note": "Los silencios están permitidos y no necesitan llenarse. Esto es para un hueco distinto." },
        { "text": "Porque si no, una persona callada responde y para.", "correct": true, "note": "Te da algo que ofrecer por iniciativa propia en vez de solo responder siempre, que es la forma que hace que alguien sienta que nunca llegó a conocerte." }
      ],
      "explain": "Algo que te pasó esta semana y te hizo gracia o te molestó. Sin pulir."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "curious", "label": "Trajo curiosidad", "description": "Quiso saber cosas en vez de tener cosas que preguntar." },
      { "key": "specific", "label": "Fue concreto", "description": "Eligió preguntas de verdad en vez de preguntas estándar." },
      { "key": "few", "label": "Se quedó en dos o tres", "description": "Una reserva, no una lista." },
      { "key": "something_to_tell", "label": "Tuvo algo que ofrecer", "description": "Trajo algo propio, sin pulir." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo con quien te estás escribiendo",
      "mood": "Ayudando, algo entretenido.",
      "openness": 5,
      "personality": "Cuestiona cualquier cosa que suene a lista de preguntas y pregunta qué es lo que de verdad quieres saber."
    },
    "setting": "La noche anterior. Sabes tres cosas de esa persona: se mudó aquí desde un pueblo, está desmesuradamente comprometida con un deporte que nadie ve, y dijo algo en un mensaje que no acabaste de entender.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Rechaza las preguntas genéricas preguntando si de verdad le importa la respuesta.",
      "Anímate ante cualquier cosa concreta y con curiosidad genuina.",
      "Nunca sugieras tú una pregunta."
    ],
    "opening_beat": "«Venga, dime. ¿Qué le vas a preguntar?»",
    "success_looks_like": "La persona nombra algo que de verdad quiere saber en vez de una pregunta para desplegar."
  }$j$::jsonb,
  'Hoy, antes de una conversación, decide una cosa que de verdad quieras saber sobre la otra persona. Apúntala y si la preguntaste.',
  $j${
    "says": "Venga, dime. ¿Qué le vas a preguntar? Lo único que sabes es que se mudó aquí desde un pueblo, está desmesuradamente metida en un deporte que nadie ve, y dijo algo en un mensaje que no seguiste.",
    "model": {
      "line": "Quiero saber cómo fue de verdad mudarse aquí desde un sitio tan pequeño — si fue un alivio o un choque.",
      "why": "Algo sobre lo que de verdad te preguntas en vez de una pregunta para desplegar. La curiosidad produce sus propias preguntas de seguimiento, porque quieres la respuesta."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Di qué quieres saber, no qué vas a preguntar" },
      { "kind": "forbids_any", "words": ["a qué te dedicas", "de dónde eres", "tienes hermanos", "aficiones", "qué te gusta", "háblame de ti", "qué estás buscando"], "requirement": "Nada del repertorio estándar" },
      { "kind": "min_words", "n": 10, "requirement": "Lo bastante concreto como para ser una duda real" },
      { "kind": "max_words", "n": 35, "requirement": "Una cosa, no una lista" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('before-you-go', 5,
  'Ve a averiguar, no a gustar',
  $md$Lo que crees que vas buscando decide cómo se siente toda la noche, y casi todo el mundo llega con el objetivo equivocado.

El objetivo por defecto es *espero que le guste*. Es comprensible y es un objetivo terrible, por dos motivos. No está bajo tu control — no puedes hacer que le gustes a alguien, e intentarlo se nota. Y te pone en una postura durante dos horas: vigilando, ajustando, comprobando cómo aterrizó cada cosa. Esa postura es agotadora, te hace visiblemente esforzado, y el esfuerzo es lo que la gente detecta de verdad cuando dice que alguien se esforzaba demasiado.

**La jugada:** ve a averiguar si querrías una segunda cita.

Esa es una pregunta que puedes responder. Se puede responder en cualquier momento de la noche, no exige que adivines el estado interior de nadie, y es de verdad útil sea cual sea la respuesta. Si la respuesta es sí, sabes qué hacer al final. Si es no, te has pasado dos horas y has aprendido algo real.

También cambia lo que haces mientras estás ahí. Alguien que intenta gustar actúa. Alguien que está averiguando pregunta cosas, escucha de verdad, y dice lo que de verdad piensa — que, en una de las ironías más útiles que hay, resulta considerablemente más agradable que la actuación.

La parte más difícil es que esto solo funciona si el no está de verdad permitido. Si alguna parte de ti necesita que vaya bien, has vuelto a esperar, y esperar produce la misma postura. Merece la pena decidirlo de antemano, en palabras: *puede que esto no sea para mí, y ese sería un resultado perfectamente bueno.*

Y hay una versión de esto para cualquiera que haya tenido una racha de citas que no llevaron a nada, porque es entonces cuando el objetivo se desliza en silencio de vuelta hacia gustar. Una cita que termina en un no claro no es un fracaso de la cita. Es el sistema funcionando — todo el sentido de conocer a alguien es averiguarlo, y averiguarlo rápido es la buena versión.

Si te quedas con una cosa: estás ahí para responder una pregunta, no para aprobar un examen. La pregunta es tuya y puedes responderla en cualquiera de los dos sentidos.$md$,
  $j$[
    {
      "situation": "Vas de camino esperando gustarle.",
      "line": "(cámbiala — ¿te va a gustar a ti?)",
      "why": "Una no se puede responder y te pone en una postura de vigilancia durante dos horas. La otra la puedes responder en cualquier momento de la noche."
    },
    {
      "situation": "Algo que dijiste no aterrizó bien y le estás dando vueltas.",
      "line": "(eso es la vigilancia, y te cuesta los siguientes diez minutos)",
      "why": "Comprobar cómo aterrizó cada cosa es lo que la gente detecta como esforzarse demasiado. Es también lo que te impide notar si te lo estás pasando bien."
    },
    {
      "situation": "Te das cuenta a mitad de la cita de que no es para ti.",
      "line": "(entonces funcionó)",
      "why": "Todo el sentido de conocer a alguien es averiguarlo, y averiguarlo rápido es la buena versión, no una noche desperdiciada."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué tiene de malo esperar gustarle?",
      "options": [
        { "text": "Es necesitado.", "correct": false, "note": "Un juicio, no un mecanismo, y no es algo útil que decirle a alguien nervioso." },
        { "text": "No está bajo tu control, e intentarlo se nota.", "correct": true, "note": "Te pone en una postura de vigilancia durante dos horas — ajustando, comprobando cómo aterrizó cada cosa — y el esfuerzo es precisamente lo que la gente detecta como esforzarse demasiado." },
        { "text": "Seguramente les gustarás igualmente.", "correct": false, "note": "Consuelo, no un arreglo, y deja el mismo objetivo en su sitio." },
        { "text": "Te hace complaciente en vez de honesto.", "correct": false, "note": "Un síntoma real, y consecuencia de que el objetivo no se pueda responder desde el principio." }
      ],
      "explain": "Ve a responder una pregunta que de verdad puedas responder."
    },
    {
      "prompt": "¿Qué hace que el cambio funcione de verdad?",
      "options": [
        { "text": "Decidir de antemano que un no estaría bien.", "correct": true, "note": "Si alguna parte de ti necesita que vaya bien, has vuelto a esperar, y esperar produce la misma postura. Merece la pena decirlo en palabras." },
        { "text": "Mantener tus expectativas bajas.", "correct": false, "note": "Las expectativas bajas son una forma de gestionar la decepción de antemano, que sigue siendo el objetivo viejo con sombrero puesto." },
        { "text": "Recordarte que tienes otras opciones.", "correct": false, "note": "Una estrategia para sentirte seguro que no tiene nada que ver con averiguar si te gustan." },
        { "text": "No importarte el resultado.", "correct": false, "note": "Puedes importarte. El punto es qué pregunta estás intentando responder, no cuánto te importa." }
      ],
      "explain": "Puede que esto no sea para mí, y ese sería un resultado perfectamente bueno. Dilo antes de ir."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "right_question", "label": "Fue a averiguar", "description": "Apuntó a si querría una segunda cita." },
      { "key": "no_monitoring", "label": "No vigiló", "description": "Dejó de comprobar cómo aterrizaba cada cosa." },
      { "key": "no_allowed", "label": "Permitió el no", "description": "Decidió de antemano que no gustarle era un resultado perfectamente bueno." },
      { "key": "honest", "label": "Dijo lo que pensaba", "description": "Fue un participante en vez de un candidato." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo con quien te estás escribiendo",
      "mood": "Interesado, sin prisa.",
      "openness": 5,
      "personality": "Pregunta qué esperas y sigue preguntando hasta que la respuesta es sobre ti en vez de sobre la otra persona."
    },
    "setting": "De camino. Tu amigo te escribe para preguntarte cómo te sientes al respecto.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Sigue preguntando qué quiere, si la respuesta va sobre lo que pensará la otra persona.",
      "Acepta y alégrate con una respuesta sobre averiguarlo.",
      "Nunca digas tú el replanteamiento."
    ],
    "opening_beat": "«¿Nervioso? ¿Qué esperas que pase esta noche?»",
    "success_looks_like": "La persona plantea la noche como averiguar en vez de como gustar."
  }$j$::jsonb,
  'Hoy, entra en algo preguntándote si te gusta en vez de si lo estás haciendo bien. Apunta qué pregunta te pillaste haciéndote.',
  $j${
    "says": "¿Nervioso? ¿Qué esperas que pase esta noche?",
    "model": {
      "line": "Quiero salir de ahí sabiendo si me gustaría volver a verla. Puede que no, y está bien así.",
      "why": "Una pregunta que de verdad puedes responder, y la segunda frase es lo que hace verdad la primera. Si alguna parte de ti necesita que vaya bien, has vuelto a esperar."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Hazlo sobre lo que quieres averiguar" },
      { "kind": "forbids_any", "words": ["le guste", "vaya bien", "no meter la pata", "no arruinar", "impresionar", "espero que", "vaya mal", "dar buena impresión"], "requirement": "No sobre si les gustas" },
      { "kind": "min_words", "n": 12, "requirement": "Permite el no en voz alta" },
      { "kind": "max_words", "n": 40, "requirement": "Dos frases" }
    ]
  }$j$::jsonb
);
