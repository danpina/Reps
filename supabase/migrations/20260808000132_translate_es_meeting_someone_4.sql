-- Spanish: Conocer a alguien, track 4 — Flirtear: calibrar.
--
-- Conventions as migration 129, including the full `partner.alt` sex-swap
-- translation. Lesson 2's alt and base partners have deliberately different
-- personality text in English (Tam vs. Talia are not mirror images), and that
-- asymmetry is preserved in the Spanish rather than flattened to match.
--
-- Lessons 1, 2 and 4 are [scene] mode and carry `rehearsal_spec: null` in
-- English; kept null here for the same reason as elsewhere — a scene has no
-- single checkable model line.

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

select pg_temp.es_lesson('flirting-calibration', 1,
  'La calidez es un dial, no un interruptor',
  $md$Casi toda la ansiedad sobre flirtear viene de tratarlo como un único acto irreversible. Vas subiendo hacia un momento, declaras una intención, y descubres si lo has estropeado todo.

Planteado así da miedo, y el miedo es razonable. Pero no es así como funciona entre gente que se le da mínimamente bien. La calidez se mueve por grados, y cada grado se puede comprobar antes del siguiente.

**La jugada:** piensa en escalones, no en declaraciones.

Un escalón es pequeño. Sostener el contacto visual un poco más. Usar su nombre. Ser un poco más directo sobre que estás disfrutando la conversación. Cada uno es negable, cada uno es reversible, y cada uno produce información sobre si moverte otra vez.

El motivo para trabajar así no es táctico. Es que a alguien que escala en escalones se le puede decir que no sin que ninguno de los dos tenga que reconocer que pasó algo, que es el arreglo más amable disponible para los dos.$md$,
  $j$[
    {
      "situation": "La conversación lleva diez minutos yendo bien y te gustaría que fuera más cálida.",
      "line": "Me alegro de haber acabado en este extremo de la mesa.",
      "why": "Un escalón. Dice que lo estás disfrutando en concreto y no en general, y se puede recibir como simpatía corriente si eso es todo lo que quieren que sea."
    },
    {
      "situation": "Habéis estado hablando fácil y acaban de hacerte reír.",
      "line": "Eres muchísimo más gracioso de lo que dejabas ver al principio.",
      "why": "Más cálido que un comentario neutro, dirigido a ellos y no a la situación, y completamente sobrevivible si no se corresponde."
    },
    {
      "situation": "Mencionan algo que van a hacer el fin de semana.",
      "line": "Suena a buen fin de semana. Tengo un poco de envidia.",
      "why": "Un escalón muy pequeño. Poca información, poco riesgo, y del tipo que puedes decir cuatro veces en una conversación mientras lees las respuestas."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué subir la calidez un escalón cada vez gana a una única declaración clara?",
      "options": [
        { "text": "Porque te da más ocasiones de convencerles.", "correct": false, "note": "Esto malinterpreta todo el enfoque. Calibrar va sobre averiguar qué es mutuo, no sobre desgastar un no." },
        { "text": "Porque cada escalón es lo bastante pequeño como para que cualquiera de los dos pueda declinarlo sin que haya que decir nada.", "correct": true, "note": "Este es el sentido. Protege a las dos personas. Ellos nunca tienen que rechazarte en voz alta, y tú nunca tienes que ser rechazado en voz alta." },
        { "text": "Porque esconde tus intenciones durante más tiempo.", "correct": false, "note": "Esconder no es el objetivo, y suele sentirse evasivo. Cada escalón está pensado para ser legible, solo que pequeño." },
        { "text": "Porque la franqueza incomoda a la gente.", "correct": false, "note": "La franqueza a menudo es excelente, y es donde acaba este tema. Funciona mejor una vez que la calidez ya se ha establecido y devuelto." }
      ],
      "explain": "Los pasos pequeños significan que se puede dar y recibir un no sin que ninguno de los dos pierda la cara. Eso es lo que lo hace amable además de eficaz."
    },
    {
      "prompt": "¿Cuál de estas es un escalón y no tres?",
      "options": [
        { "text": "Decirles que son la persona más interesante de aquí.", "correct": false, "note": "Una afirmación grande que exige respuesta. Es una declaración vestida de cumplido." },
        { "text": "Decir que te alegras de haber acabado en este extremo de la mesa.", "correct": true, "note": "Cálido, dirigido a ellos, y completamente sobrevivible como simpatía corriente si eso es todo lo que quieren que sea." },
        { "text": "Preguntar si están saliendo con alguien.", "correct": false, "note": "No es un escalón en absoluto. Hace explícito el marco y les pide responder dentro de él." },
        { "text": "Buscar un motivo para tocarles el brazo.", "correct": false, "note": "La escalada física son varios escalones a la vez, y mucho más difícil de deshacer." }
      ],
      "explain": "Un escalón es negable. Si no se puede recibir como simpatía corriente, es una declaración."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "moved_in_notches", "label": "Escaló por grados", "description": "Subió la calidez en pasos pequeños en vez de con una única declaración." },
      { "key": "stayed_deniable", "label": "Mantuvo cada paso sobrevivible", "description": "Cada paso se podía recibir como simpatía corriente si eso era todo lo que quería la otra persona." },
      { "key": "aimed_at_them", "label": "Lo dirigió a ellos", "description": "La calidez iba sobre esta persona y no sobre amabilidad general." },
      { "key": "paused_to_read", "label": "Dejó espacio para leer la respuesta", "description": "Paró después de cada paso en vez de apilar varios a la vez." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Wren",
        "role": "un amigo de quien cumple años, a quien acabas de conocer",
        "mood": "Disfrutando de la noche, genuinamente interesado en la conversación.",
        "openness": 4,
        "personality": "Cálido y metido, y sigue el registro que le den en vez de marcarlo él. Responde bien a los pasos pequeños y se tensa con los grandes."
      },
      "sex": "female",
      "name": "Wren",
      "role": "una amiga de quien cumple años, a quien acabas de conocer",
      "mood": "Disfrutando de la noche, genuinamente interesada en la conversación.",
      "openness": 4,
      "personality": "Cálida y metida, y sigue el registro que le den en vez de marcarlo ella. Responde bien a los pasos pequeños y se tensa con los grandes."
    },
    "setting": "Las copas de cumpleaños de un amigo. Llevas unos diez minutos hablando con alguien y va bien.",
    "constraints": [
      "Mantente en el personaje. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Refleja el nivel de calidez de la persona, un escalón por detrás. No marques tú el ritmo.",
      "Si la persona escala con un paso pequeño, devuélvelo con calidez.",
      "Si la persona da un salto grande o varios pasos a la vez, ponte educada y notablemente más formal durante un turno."
    ],
    "opening_beat": "Wren se ríe de algo que has dicho, y comenta que es lo más divertido que se lo ha pasado en una de estas en bastante tiempo.",
    "success_looks_like": "La persona sube la calidez un escalón pequeño, para, y lee cómo se recibe antes de hacer nada más."
  }$j$::jsonb,
  'Hoy, en una conversación que estés disfrutando, sube la calidez un escalón pequeño y luego para y lee qué vuelve. Apunta el escalón y la respuesta.',
  NULL
);

select pg_temp.es_lesson('flirting-calibration', 2,
  'Señala, y luego lee',
  $md$El escalón es solo la mitad de la jugada. La mitad que importa es qué haces en los cuatro segundos posteriores.

Casi todo el mundo escala y luego sigue hablando, lo que destruye la información que acaba de comprar. Si ofreces calidez y llenas el espacio de inmediato, nunca averiguas si te la devolvieron, así que vas a ciegas el resto de la conversación.

**La jugada:** después de cualquier paso hacia arriba, para y observa qué vuelve.

Estás buscando una cosa: ¿lo igualaron, lo superaron, o lo esquivaron? Igualarlo es luz verde para otro escalón más tarde. Superarlo significa que van por delante de ti. Esquivarlo (responder al contenido e ignorar la calidez) es un no, entregado en la forma más suave que hay.

Esa tercera opción no es un fallo de tu entrega. Es que están usando el mismo sistema que tú, en la dirección que quieren. Leerlo correctamente es lo que hace que todo esto sea seguro de practicar.$md$,
  $j$[
    {
      "situation": "Dijiste que te alegrabas de haber acabado hablando con ellos, y sonrieron y dijeron lo mismo.",
      "why": "Una señal igualada es luz verde para quedarse en esta calidez. Todavía no es permiso para el siguiente escalón, solo para este.",
      "line": "(lo igualaron: sigue en el nuevo nivel)"
    },
    {
      "situation": "Les hiciste un pequeño cumplido y dijeron gracias y cambiaron de tema.",
      "line": "(lo esquivaron: baja un escalón)",
      "why": "Responder al contenido e ignorar la calidez es un no suave. La respuesta correcta es volver a lo simpático sin ninguna reacción visible."
    },
    {
      "situation": "Dijiste algo cálido y fueron más lejos que tú.",
      "line": "(van por delante: puedes encontrarte ahí con ellos)",
      "why": "Superar tu señal es la luz verde más clara que hay. Es también el momento que más se le pasa a la gente, porque están preparados para el rechazo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Dices algo cálido y responden a la parte factual ignorando por completo la calidez. ¿Qué significa eso y qué deberías hacer?",
      "options": [
        { "text": "No lo notaron. Dilo otra vez más claro.", "correct": false, "note": "Lo notaron. Esquivar la calidez es una maniobra deliberada y educada, y repetirlo más claro les obliga a decir que no en voz alta." },
        { "text": "Son tímidos. Sigue escalando con suavidad para ayudarles.", "correct": false, "note": "Esto replantea un no como un obstáculo que sortear, que es exactamente el error que este enfoque existe para evitar." },
        { "text": "Es un no suave. Vuelve a lo simpático sin hacer nada de ello.", "correct": true, "note": "Esquivar la calidez es la forma más suave de declinar. Leerlo correctamente significa que ninguno de los dos tiene que reconocer que pasó." },
        { "text": "Es neutro. Espera e inténtalo otra vez más tarde en la noche.", "correct": false, "note": "No es neutro, es una señal. Esperar e intentarlo de nuevo trata una respuesta meditada como un problema de momento." }
      ],
      "explain": "Responder al contenido e ignorar la calidez es un no. Leerlo bien es lo que deja que las dos personas se vayan con la dignidad intacta."
    },
    {
      "prompt": "Dices algo cálido y se ríen y cambian de tema. ¿Qué es eso?",
      "options": [
        { "text": "Timidez. Inténtalo otra vez más claro.", "correct": false, "note": "Replantea un no como un obstáculo, que es exactamente lo que este enfoque existe para evitar." },
        { "text": "Ánimo, ya que se rieron.", "correct": false, "note": "La risa es la señal más barata que hay. Lo que hicieron con la calidez es la respuesta de verdad." },
        { "text": "Un no suave. Vuelve a lo simpático.", "correct": true, "note": "La risa es educación y el cambio de tema es la respuesta. Las dos juntas son un rechazo, hecho con suavidad." },
        { "text": "Neutro. No es suficiente para leerlo en ningún sentido.", "correct": false, "note": "Es una señal clara. Tratarla como neutra es cómo la gente acaba insistiendo." }
      ],
      "explain": "Una risa más un cambio de tema es un rechazo. La risa lo suaviza; el cambio de tema es el contenido."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "stopped_to_read", "label": "Paró después de señalar", "description": "Dejó una pausa después de escalar en vez de hablar por encima de la respuesta." },
      { "key": "read_correctly", "label": "Leyó qué volvía", "description": "Identificó correctamente si la señal se igualó, se superó o se esquivó." },
      { "key": "acted_on_the_read", "label": "Actuó según lo leído", "description": "Escaló, se mantuvo, o retrocedió según la respuesta y no según su propio plan." },
      { "key": "no_pressure", "label": "No aplicó presión", "description": "Nunca repitió ni amplificó una señal que había sido esquivada." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Tam",
        "role": "alguien que ha venido solo al mismo evento",
        "mood": "Disfrutando de la charla, del todo sin nada romántico en ello.",
        "openness": 4,
        "personality": "Simpático y bastante difícil de leer. Da respuestas cálidas a casi cualquier cosa, que es el problema del que trata la lección."
      },
      "sex": "female",
      "name": "Talia",
      "role": "alguien que ha venido sola al mismo evento",
      "mood": "Disfrutando de la charla, del todo sin nada romántico en ello.",
      "openness": 4,
      "personality": "Simpática e interesada en la conversación en sí, y no en nada más allá. Declina la calidez respondiendo al contenido y siguiendo adelante, nunca diciéndolo."
    },
    "setting": "La presentación de un libro con copas después. Lleváis un cuarto de hora hablando cerca de la ventana.",
    "constraints": [
      "Mantente en el personaje. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Sé genuinamente cálida y estés metida en el tema en todo momento.",
      "Cada vez que la persona ofrezca calidez personal, responde a la parte factual y deja pasar la parte cálida sin comentarla.",
      "Si la persona vuelve a la conversación simpática, muéstrate encantada y sigue con entusiasmo. Si insiste, ponte fría brevemente."
    ],
    "opening_beat": "Talia está animada hablando del libro y pregunta qué te pareció el último capítulo.",
    "success_looks_like": "La persona ofrece una pequeña señal cálida, nota que Talia la esquiva, y vuelve a lo simpático sin insistir ni enfurruñarse."
  }$j$::jsonb,
  'Hoy, después de cualquier comentario cálido que hagas, para y observa qué vuelve. Apunta un caso y si se igualó, se superó o se esquivó.',
  NULL
);

select pg_temp.es_lesson('flirting-calibration', 3,
  'La atención es la señal que cuenta',
  $md$La gente delata el interés por lo que hace con su atención, y es muchísimo más fiable que cualquier cosa que diga.

La educación es una fuerza fuerte. Alguien puede producir palabras cálidas de la nada, solo por buenos modales, que es por lo que las palabras son la prueba más débil disponible. La atención es mucho más difícil de fingir y muchísimo menos obligatoria socialmente.

**La jugada:** observa qué hacen con las ocasiones de irse.

Toda conversación tiene puntos de salida naturales: una bebida terminada, un amigo que pasa, un bache. Lo que hace alguien en esos momentos es la respuesta de verdad. Quedarse es una elección. Retomar la conversación después de que haya terminado de forma natural es una elección más grande. Preguntarte algo cuando podrían haber dejado morir el intercambio es todavía más grande.

La señal negativa correspondiente es lo mismo invertido: tomar cada salida disponible, por muy cálidas que sean las palabras entre medias. Si alguien es simpático durante tres minutos y desaparece en cada hueco, los huecos te están diciendo la verdad.$md$,
  $j$[
    {
      "situation": "Llega una pausa natural y su amigo saluda desde el otro lado de la sala.",
      "line": "(le devuelve el saludo y se queda donde está)",
      "why": "La señal más fuerte disponible. Tenían una salida socialmente libre y eligieron no tomarla, algo que ninguna cantidad de palabras educadas puede igualar."
    },
    {
      "situation": "La conversación llega a una conclusión natural y ninguno de los dos ha dicho nada durante un momento.",
      "line": "(empiezan un tema nuevo)",
      "why": "Reiniciar una conversación que había terminado es un acto deliberado. Nadie lo hace por educación."
    },
    {
      "situation": "Lleváis diez minutos hablando y no te han preguntado nada.",
      "line": "(respuestas cálidas, ninguna pregunta de vuelta: léelo con cuidado)",
      "why": "Alguien interesado casi siempre se vuelve curioso. La ausencia constante de curiosidad es información real, sea cual sea el tono de voz."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la prueba más fuerte de que a alguien le gusta hablar contigo en concreto?",
      "options": [
        { "text": "Se quedan cuando aparece una salida natural.", "correct": true, "note": "La atención en los puntos de salida es la señal más difícil de fingir y la menos obligada por la educación. Quedarse es una elección que no tenían por qué hacer." },
        { "text": "Se ríen de tus chistes.", "correct": false, "note": "La risa muy a menudo es educación. Un montón de gente se ríe generosamente con desconocidos como lubricante social." },
        { "text": "Dan respuestas largas y detalladas.", "correct": false, "note": "Buena prueba de que están cómodos, y puede significar igualmente que son concienzudos. Más débil que lo que hacen con una salida." },
        { "text": "Te hacen un cumplido.", "correct": false, "note": "Las palabras cálidas son la señal más barata disponible y la más accesible a los buenos modales." }
      ],
      "explain": "Las palabras están obligadas por la educación. La atención no. Observa qué hacen en los momentos en que podrían haberse ido."
    },
    {
      "prompt": "¿Qué conducta es la prueba más fuerte de interés real?",
      "options": [
        { "text": "Te dicen que están disfrutando hablar contigo.", "correct": false, "note": "Palabras cálidas, y la señal más barata disponible. La educación las produce gratis." },
        { "text": "Se ponen más cerca de lo necesario.", "correct": false, "note": "Sugerente, y muy confundido por el ruido, las aglomeraciones y lo táctil que es alguien sin más." },
        { "text": "Te hacen muchas preguntas.", "correct": false, "note": "Buena prueba de implicación, y alguna gente siente curiosidad por todo el mundo." },
        { "text": "Vuelven después de que la conversación ya haya terminado.", "correct": true, "note": "Reiniciar algo que había terminado es del todo voluntario. Nadie lo hace por educación." }
      ],
      "explain": "Observa lo que les cuesta algo. Volver después de una salida es la señal menos negable que hay."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "watched_attention", "label": "Observó la atención en vez de las palabras", "description": "Leyó el interés a partir de la conducta en los puntos de salida en vez del tono o los cumplidos." },
      { "key": "noticed_exits", "label": "Notó las salidas naturales", "description": "Registró los momentos en que la otra persona podría haber terminado la conversación." },
      { "key": "no_wishful_reading", "label": "Leyó con honestidad", "description": "No convirtió la educación en interés." },
      { "key": "responded_proportionately", "label": "Igualó su implicación", "description": "Ajustó su propia calidez al nivel de atención que de verdad recibía." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Juno",
        "role": "alguien que conoce a mucha gente en esta inauguración",
        "mood": "Sociable y con la atención repartida en varias direcciones.",
        "openness": 4,
        "personality": "Sociable y generoso con su atención, lo que hace que su atención sea una prueba débil. Lo que hace con una ocasión de irse es la señal."
      },
      "sex": "female",
      "name": "Juno",
      "role": "alguien que conoce a mucha gente en esta inauguración",
      "mood": "Sociable y con la atención repartida en varias direcciones.",
      "openness": 4,
      "personality": "Cálida y con cumplidos para todo el mundo, lo que hace que las palabras sean una mala guía. Muestra interés real solo por lo que hace con las ocasiones de irse."
    },
    "setting": "La inauguración concurrida de una galería. Estás hablando con alguien cerca de las bebidas, y la sala está llena de gente que parece conocer.",
    "constraints": [
      "Mantente en el personaje. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Sé cálida y con cumplidos en el tono todo el rato, sin importar tu interés real.",
      "Presenta una ocasión de salida natural cada pocos turnos: un amigo que pasa, una bebida terminada, un bache.",
      "Toma esas salidas o recházalas según si la persona ha sido genuinamente interesante, no según si ha sido halagadora."
    ],
    "opening_beat": "Juno está a mitad de frase contigo cuando alguien que conoce le saluda desde el otro lado de la sala.",
    "success_looks_like": "La persona lee la conducta de Juno en los puntos de salida en vez de sus palabras cálidas, y calibra su propia calidez a lo que muestra de verdad la atención."
  }$j$::jsonb,
  'Hoy, en una conversación, fíjate en los puntos de salida naturales y observa qué hace la otra persona con ellos. Apunta qué te dijeron las salidas.',
  $j${
    "beats": [
      {
        "situation": "Sus amigos se están yendo y lo han dicho dos veces. Han estado diciendo cosas cálidas y con cumplidos toda la noche. Cogen su abrigo.",
        "prompt": "¿Qué te dice eso?",
        "options": [
          { "text": "Los cumplidos eran reales, así que lo del abrigo no significa nada.", "correct": false, "note": "Leer las palabras por encima de las acciones, que es exactamente el error. Leer con esperanza siempre suena a generosidad desde dentro." },
          { "text": "Se van. Era educación desde el principio.", "correct": false, "note": "Demasiado rápido. Han cogido un abrigo, no han salido, y que se vayan sus amigos es un dato sobre sus amigos." },
          { "text": "Observa qué hacen a continuación. El abrigo no es la respuesta; si se van, sí lo es.", "correct": true, "note": "Esta es toda la lección. Las palabras cálidas son baratas y la gente agradable las produce con libertad. Lo que alguien hace con una ocasión de irse no es barato." }
        ]
      },
      {
        "situation": "Se ponen el abrigo sobre el brazo, se despiden de sus amigos, y vuelven a sentarse.",
        "prompt": "¿Qué te dice eso?",
        "options": [
          { "text": "Más que todo lo que dijeron en toda la noche.", "correct": true, "note": "Tenían una salida limpia, con cobertura, y no la tomaron. Esa es la señal que cuenta." },
          { "text": "Más o menos lo mismo que los cumplidos.", "correct": false, "note": "No es lo mismo en absoluto. Uno no les costaba nada y el otro les costaba su transporte a casa." },
          { "text": "Nada todavía: di la cosa clara y averígualo.", "correct": false, "note": "Sí te dice algo, y esta lectura es lo que se gana la cosa clara más tarde en vez de sustituirla." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('flirting-calibration', 4,
  'Deja que hagan parte del trabajo',
  $md$Una conversación en la que una sola persona hace todo el calentamiento no va bien, por muy cálida que esté siendo esa persona.

El instinto cuando te gusta alguien es esforzarte más: más preguntas, más cumplidos, más esfuerzo por mantenerla viva. Se siente como generosidad y se lee como presión, porque elimina cualquier necesidad de que ellos aporten y hace visible el desequilibrio para los dos.

**La jugada:** haz deliberadamente un poco menos, y mira si lo recogen.

Deja una pausa que normalmente rellenarías. Responde sin preguntar algo de vuelta de inmediato. Deja que un tema se agote. Si están interesados, van a empezar a cargar parte del peso, y ahora tienes información real en vez de un monólogo con respuestas.

Hay un segundo beneficio. Alguien que ha invertido esfuerzo tiende a valorar más la conversación, y eso no es manipulación: es sencillamente lo que hace la participación. No estás reteniendo para crear anhelo. Estás negándote a hacer su mitad.$md$,
  $j$[
    {
      "situation": "Has hecho las últimas tres preguntas y estás a punto de hacer una cuarta.",
      "line": "(no digas nada, deja que la pausa se quede)",
      "why": "La pausa es la prueba. Si están interesados la van a rellenar, y si no, has aprendido algo sin que te cueste nada."
    },
    {
      "situation": "Un tema se ha agotado de forma natural y estás buscando uno nuevo.",
      "line": "(déjalo agotarse)",
      "why": "Rescatar cada silencio señala que mantener viva la conversación es responsabilidad tuya. Dejar que una termine les invita a empezar la siguiente."
    },
    {
      "situation": "Te preguntan algo y respondes.",
      "line": "(responde del todo, y luego para: no la devuelvas de inmediato)",
      "why": "Devolver automáticamente cada pregunta te mantiene en el papel de servicio. Responder y parar les deja elegir continuar."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Has estado haciendo casi todo el trabajo en una conversación con alguien que te gusta. ¿Cuál es la mejor jugada?",
      "options": [
        { "text": "Esforzarte más: mejores preguntas, más energía.", "correct": false, "note": "El instinto más común y el equivocado. Más esfuerzo amplía el desequilibrio y empieza a leerse como presión." },
        { "text": "Deja una pausa que normalmente rellenarías y mira qué hacen.", "correct": true, "note": "Crea espacio para que aporten y te da información real sobre su interés. No cuesta nada si lo recogen." },
        { "text": "Comenta el hecho de que estás llevando toda la conversación.", "correct": false, "note": "Nombrarlo puede funcionar entre amigos, y aquí les pide que se justifiquen, que es más pesado de lo que exige la situación." },
        { "text": "Termina la conversación de inmediato.", "correct": false, "note": "Un salto demasiado grande desde un desequilibrio. Una pausa pone a prueba lo mismo con una fracción del coste." }
      ],
      "explain": "Esforzarte más esconde la respuesta. Hacer un poco menos la revela, y no te cuesta nada si dan un paso adelante."
    },
    {
      "prompt": "Dejas una pausa y la rellenan con algo sobre sí mismos. ¿Qué te dice eso?",
      "options": [
        { "text": "Están dispuestos a llevar la mitad de esto.", "correct": true, "note": "Rellenar un silencio que dejaste con algo suyo es implicación, que es lo que estabas poniendo a prueba." },
        { "text": "Poca cosa. A la gente le disgusta el silencio.", "correct": false, "note": "Cierto en general, y aquí eligieron rellenarlo con confidencia y no con un comentario sobre la sala." },
        { "text": "Estaban esperando a que dejaras de hablar.", "correct": false, "note": "Una lectura que encaja con una interrupción, no con una pausa que dejaste deliberadamente." },
        { "text": "Están incómodos y lo disimulan.", "correct": false, "note": "Posible, y poco probable cuando lo que rellena el hueco es personal y no relleno." }
      ],
      "explain": "Lo que alguien pone en un silencio que dejaste tú es la medida más clara de cuánto está implicado."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "did_less", "label": "Hizo un poco menos", "description": "Dejó espacio deliberadamente en vez de esforzarse más por mantenerlo vivo." },
      { "key": "held_the_pause", "label": "Dejó estar un silencio", "description": "No rescató cada hueco de la conversación." },
      { "key": "read_the_result", "label": "Leyó si daban un paso adelante", "description": "Usó el espacio como información sobre la implicación de la otra persona." },
      { "key": "stayed_warm", "label": "Se mantuvo cálido haciéndolo", "description": "Hizo menos sin volverse frío, distante o punitivo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Sasha",
        "role": "un habitual de esta noche de juegos",
        "mood": "Cómodo y sin ninguna prisa.",
        "openness": 4,
        "personality": "Cómodo y sin prisa. Deja un silencio estar sin problema, que es exactamente lo que le hace un compañero útil para esto."
      },
      "sex": "female",
      "name": "Sasha",
      "role": "una habitual de esta noche de juegos",
      "mood": "Cómoda y sin ninguna prisa.",
      "openness": 4,
      "personality": "Genuinamente interesada y conforme con dejar que la otra persona conduzca si insiste en conducir. Da un paso adelante en cuanto aparece espacio."
    },
    "setting": "Una noche tranquila de juegos de mesa. Estáis sentados fuera de una ronda con alguien con quien llevas un rato hablando.",
    "constraints": [
      "Mantente en el personaje. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si la persona sigue haciendo preguntas, sigue respondiéndolas y nunca aportes tú un tema nuevo.",
      "Si la persona deja una pausa de cualquier duración, rellénala con algo tuyo y empieza a hacer la mitad del trabajo.",
      "Nunca señales el cambio."
    ],
    "opening_beat": "Sasha responde a tu última pregunta, y luego espera, bastante cómoda con el silencio.",
    "success_looks_like": "La persona deja de esforzarse tanto, deja una pausa, y Sasha la rellena y empieza a aportar al menos la mitad de la conversación."
  }$j$::jsonb,
  'Hoy, en una conversación, haz deliberadamente menos. Deja una pausa que normalmente rellenarías. Apunta qué pasó en el hueco.',
  NULL
);

select pg_temp.es_lesson('flirting-calibration', 5,
  'Di la cosa llana',
  $md$Todo hasta aquí ha ido sobre leer. Esta lección va sobre el momento en que leer deja de ser lo útil.

Cuando la calidez se ha ofrecido y devuelto varias veces, y las señales de atención son inequívocas, la jugada calibrada es ser directo. Seguir insinuando en ese punto no es sutileza, es negarse a correr el pequeño riesgo de ser claro, y le carga a la otra persona el trabajo de interpretar indefinidamente.

**La jugada:** en cuanto sea claramente mutuo, di la cosa llana.

*Lo he disfrutado muchísimo. Me gustaría repetirlo.* Sin ingenio, sin ambigüedad, sin ninguna construcción elaborada que se pudiera retirar después. La llaneza es el respeto: les deja dar una respuesta directa en vez de descifrarte.

Dos condiciones, y las dos importan. Dilo solo cuando las señales hayan sido mutuas, no como forma de forzar una decisión. Y dilo de una forma que sea genuinamente fácil de declinar, porque una oferta clara con una salida fácil es la única versión que es justa de hacer.$md$,
  $j$[
    {
      "situation": "Una hora de conversación fácil, calidez devuelta repetidamente, y la noche se está apagando.",
      "line": "Lo he disfrutado muchísimo hablando contigo. Me gustaría repetirlo, si a ti también te apetece.",
      "why": "Llano, cálido, y termina con una puerta explícita hacia fuera. Ese «si a ti también te apetece» hace todo el trabajo de que un no sea fácil de dar."
    },
    {
      "situation": "Lleváis toda la noche hablando y han retomado la conversación dos veces después de que terminara.",
      "line": "Esto ha sido lo mejor de mi semana. ¿Me das tu número?",
      "why": "Directo y concreto sobre el motivo, lo que lo convierte en un cumplido y no en una transacción. La petición es pequeña y está enunciada con claridad."
    },
    {
      "situation": "Las señales han sido simpáticas y nunca se han devuelto como calidez.",
      "line": "(no digas nada: esto es una buena conversación, no una mutua)",
      "why": "La condición eran señales mutuas. Hacer la jugada llana sin ellas convierte una conversación agradable en un momento que tienen que gestionar."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuándo es correcto ser directo en vez de seguir señalando?",
      "options": [
        { "text": "Cuando lleváis hablando lo suficiente como para que sería raro no serlo.", "correct": false, "note": "La duración no es prueba. Una conversación simpática larga sigue siendo una conversación simpática." },
        { "text": "Cuando no sabes cómo se sienten y quieres una respuesta.", "correct": false, "note": "Usar la franqueza para resolver tu propia incertidumbre les carga a ellos la incomodidad. Si no lo sabes, la respuesta suele ser que no." },
        { "text": "Cuando la calidez se ha ofrecido y devuelto varias veces y las señales de atención son claras.", "correct": true, "note": "La franqueza es el final natural de una secuencia calibrada. En cuanto es mutuo, seguir insinuando solo les obliga a seguir interpretando." },
        { "text": "Cuando la noche está terminando y es ahora o nunca.", "correct": false, "note": "La presión del tiempo es un motivo por el que la gente hace mal esta jugada. Que termine la noche no cambia nada sobre si es mutuo." }
      ],
      "explain": "Sé directo en cuanto sea mutuo, y formúlalo para que un no sea fácil. La franqueza sin señales mutuas es solo presión con mejor gramática."
    },
    {
      "prompt": "¿Qué versión hace más fácil dar un no?",
      "options": [
        { "text": "Deberíamos repetir esto algún día.", "correct": false, "note": "Tan vago que declinar significa leer entre líneas. La ambigüedad aquí no es amabilidad." },
        { "text": "Me gustaría volver a verte, si a ti también te apetece.", "correct": true, "note": "Clara sobre lo que quieres y termina con una puerta explícita. «Si a ti también te apetece» hace todo el trabajo." },
        { "text": "¿Estás libre el jueves?", "correct": false, "note": "Concreta, y obliga a una excusa en vez de a una respuesta." },
        { "text": "No sé si te apetecería tomar algo.", "correct": false, "note": "Disculpándose por adelantado, lo que hace incómodo aceptar y hace que declinar se sienta poco amable." }
      ],
      "explain": "Sé claro sobre la petición y explícito en que el no está disponible. La vaguedad no es educación aquí."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "earned_it", "label": "Tuvo señales mutuas primero", "description": "Fue directo solo después de que la calidez se hubiera devuelto repetidamente." },
      { "key": "was_plain", "label": "Lo dijo con llaneza", "description": "Hizo una afirmación clara en vez de una insinuación ambigua que había que descifrar." },
      { "key": "easy_to_decline", "label": "Hizo fácil un no", "description": "Formuló la oferta de forma que se pudiera rechazar sin incomodidad." },
      { "key": "no_pressure", "label": "No aplicó presión", "description": "No usó el momento, la insistencia ni la incomodidad para forzar una respuesta." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "alt": {
        "sex": "male",
        "name": "Kit",
        "role": "un amigo de quien te ha invitado, a quien has conocido esta noche",
        "mood": "Disfrutando de verdad, consciente de que la noche está terminando.",
        "openness": 5,
        "personality": "Cálido y directo, y ha ido más cálido de forma constante toda la noche. Recibiría una cosa llana con llaneza."
      },
      "sex": "female",
      "name": "Cleo",
      "role": "una amiga de quien te ha invitado, a quien has conocido esta noche",
      "mood": "Disfrutando de verdad, consciente de que la noche está terminando.",
      "openness": 5,
      "personality": "Cálida y directa ella misma. Ha devuelto calidez toda la noche y ha retomado la conversación dos veces. Responde muy bien a la llaneza y mal a las insinuaciones elaboradas."
    },
    "setting": "El final de una cena larga en casa de un amigo. La gente empieza a irse y llevas casi toda la noche hablando con la misma persona.",
    "constraints": [
      "Mantente en el personaje. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Has disfrutado de la noche y has devuelto calidez todo el rato. Sigue haciéndolo.",
      "Si la persona dice algo llano y fácil de declinar, responde con calidez y directamente en la misma línea.",
      "Si la persona insinúa de forma elaborada en su lugar, ponte algo perpleja y responde solo al significado superficial."
    ],
    "opening_beat": "Cleo dice que probablemente debería pensar en irse pronto, y luego no se mueve.",
    "success_looks_like": "La persona lee las señales mutuas acumuladas y dice la cosa llana, formulada para que sea fácil de declinar."
  }$j$::jsonb,
  'Esta solo cuenta cuando se cumplen las condiciones. Si una conversación ha sido cálida en los dos sentidos, di la cosa llana y hazla fácil de declinar. Si no lo ha sido, apunta que lo leíste correctamente y no dijiste nada.',
  $j${
    "beats": [
      {
        "situation": "Una buena conversación, de una hora. La has disfrutado enormemente. Han sido simpáticos y graciosos, no han dado ni un paso hacia ti, y han mencionado dos veces a alguien con quien están saliendo el fin de semana.",
        "prompt": "¿Dices la cosa llana?",
        "options": [
          { "text": "No. No se cumplen las condiciones, y una buena conversación ya es el premio entero.", "correct": true, "note": "Esta lección solo cuenta cuando se ha ganado en los dos sentidos. Dicho aquí, convierte una hora que disfrutaron en un momento que tienen que gestionar." },
          { "text": "Sí, con amabilidad, para que no haya ambigüedad.", "correct": false, "note": "No había ambigüedad. Quitarla es un favor para ti, no para ellos." },
          { "text": "Insinúalo y mira qué pasa.", "correct": false, "note": "Una insinuación contra dos señales claras es la cosa llana con negabilidad atornillada, que es la versión que peor envejece." }
        ]
      },
      {
        "situation": "Otra noche distinta. Ha sido cálido en los dos sentidos durante una hora, han dado un paso hacia ti dos veces, y se quedaron cuando se fueron sus amigos.",
        "prompt": "¿Dices la cosa llana?",
        "options": [
          { "text": "Sí, con llaneza, y formulada para que declinar no les cueste nada.", "correct": true, "note": "Ganada, mutua, y fácil de declinar. La vía de escape es lo que la convierte en una pregunta y no en una exigencia." },
          { "text": "Sí, y deja claro cuánto ha significado la noche.", "correct": false, "note": "El peso es lo que hay que evitar. Cuanto más pesa, más difícil es decir que no, y un sí difícil de rechazar no es un sí." },
          { "text": "No: déjalo y espera a que lo saquen ellos.", "correct": false, "note": "Se cumple cada condición. Exigirles que hagan la parte expuesta no es contención, es endosar el riesgo." }
        ]
      }
    ]
  }$j$::jsonb
);
