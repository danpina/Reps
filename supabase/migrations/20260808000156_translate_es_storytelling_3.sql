-- Spanish: Storytelling, track 3 — Contarla.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Priya" throughout — established feminine exception name.

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

select pg_temp.es_lesson('telling-it', 1,
  'Presente',
  $md$Dos personas cuentan la misma historia con la misma forma y una de ellas está en la sala mientras la otra está presentando un informe. A menudo toda la diferencia es un tiempo verbal.

*Bueno, estaba en la puerta y se giró y dijo que no tenía ni idea de quién era yo.*
*Bueno, estoy en la puerta, y se gira, y no tiene ni idea de quién soy.*

**La jugada:** cambia a presente en el momento en que la historia empieza a pasar.

Suena a truco por escrito y es casi invisible al hablarlo — la gente no nota el tiempo verbal, nota que está siguiendo algo que está pasando en vez de que le estén contando algo que pasó. Ese es todo el efecto, y no cuesta nada.

No lo necesitas para todo. El patrón natural es pasado para el marco y el planteamiento — *bueno, fui a casa de mi hermana la semana pasada* — y presente para la parte que importa, que es exactamente donde debería estar la atención. La mayoría de los buenos narradores hacen esto sin saber que lo hacen.

También le hace algo a tu propia narración, que es la mitad infravalorada. Contar algo en presente hace que sea mucho más difícil resumir, porque resumir es una operación en pasado. Acabas suministrando de forma natural el momento en vez del relato, y el ritmo aumenta sin ninguna decisión de acelerarlo.

Dos cosas que evitar. No cambies de un lado a otro repetidamente — un cambio, en el punto en que las cosas empiezan, y quédate ahí. Y no lo uses para algo que estás informando en vez de contando: noticias sobre la vida de otra persona en presente se leen como dramatizadas, que es el único contexto en el que es notable e incorrecto.

Si te quedas con una cosa: cambia en el momento en que empieza a pasar, y quédate en él hasta el final.$md$,
  $j$[
    {
      "situation": "Estás describiendo el momento en que salió mal.",
      "line": "Bueno, estoy en la puerta, y se gira.",
      "why": "La gente no nota el tiempo verbal — nota que está siguiendo algo que está pasando en vez de que le estén contando algo que pasó."
    },
    {
      "situation": "Todavía estás planteando dónde estabas.",
      "line": "(el pasado es lo correcto aquí)",
      "why": "El patrón natural es pasado para el marco y presente para la parte que importa, que pone el cambio exactamente donde debería estar la atención."
    },
    {
      "situation": "Estás transmitiendo noticias sobre otra persona.",
      "line": "(nada de presente)",
      "why": "Informar en presente se lee como dramatizado, y es el único contexto en el que el recurso es notable e incorrecto."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hace de verdad el presente?",
      "options": [
        { "text": "Te hace sonar más animado.", "correct": false, "note": "Puede que sí, y la animación es un subproducto, no el mecanismo." },
        { "text": "Pone al oyente en la sala en vez de en un informe.", "correct": true, "note": "Nadie nota el tiempo verbal. Notan que están siguiendo algo que está pasando en vez de que les estén contando algo que pasó." },
        { "text": "Hace la historia más corta.", "correct": false, "note": "Tiende a hacerlo, como efecto secundario de dificultar el resumen — que es el beneficio de segundo orden, no el primero." },
        { "text": "Señala que viene la parte buena.", "correct": false, "note": "El cambio sí marca un cambio de marcha, y eso no es lo que le está haciendo a la experiencia del oyente." }
      ],
      "explain": "Cambia una vez, en el momento en que empieza a pasar, y quédate ahí."
    },
    {
      "prompt": "¿Cuál es el efecto infravalorado sobre ti?",
      "options": [
        { "text": "Te ralentiza.", "correct": false, "note": "Normalmente acelera las cosas, porque suministrar momentos es más rápido que montar un relato." },
        { "text": "Te ayuda a recordar el orden.", "correct": false, "note": "Ningún efecto en particular en el recuerdo. El efecto está en qué tipo de frase produces." },
        { "text": "Hace que resumir sea más difícil.", "correct": true, "note": "Resumir es una operación en pasado. En presente suministras de forma natural el momento en vez del relato, y el ritmo aumenta sin decidirlo." },
        { "text": "Te hace más seguro.", "correct": false, "note": "Posiblemente, como consecuencia, y la confianza no es para lo que sirve el recurso." }
      ],
      "explain": "Y no cambies de un lado a otro — un cambio, y luego quédate en él."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "switched", "label": "Cambió a presente", "description": "En el momento en que las cosas empezaron a pasar." },
      { "key": "once", "label": "Cambió una vez", "description": "No se movió de un lado a otro." },
      { "key": "setup_past", "label": "Mantuvo el planteamiento en pasado", "description": "Marco en pasado, acción en presente." },
      { "key": "not_reporting", "label": "No dramatizó noticias", "description": "Mantuvo los hechos informados en pasado." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa",
      "mood": "Interesada.",
      "openness": 4,
      "personality": "Sigue de cerca un relato en presente y pregunta qué pasó después; recibe un relato en pasado con educación y sin mucha reacción."
    },
    "setting": "Estás contando la historia de llegar a la casa equivocada. El momento en que empieza a pasar es cuando se abre la puerta.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Reacciona y pregunta qué pasa después durante un relato en presente.",
      "Responde con educación y sin preguntas de seguimiento a un resumen en pasado.",
      "Nunca comentes cómo se está contando."
    ],
    "opening_beat": "«¿La casa equivocada? ¿Cómo pasó eso siquiera?»",
    "success_looks_like": "La persona cambia a presente cuando empieza la acción."
  }$j$::jsonb,
  'Hoy, cuenta una historia cambiando a presente cuando empiece la acción. Apunta dónde cambiaste.',
  $j${
    "says": "¿La casa equivocada? ¿Cómo pasó eso siquiera?",
    "model": {
      "line": "Bueno, llamo, y se abre la puerta, y hay un hombre en bata que muy obviamente no tiene ni idea de quién soy.",
      "why": "Presente desde el momento en que empieza la acción. Nadie nota el tiempo verbal — notan que están siguiendo algo que está pasando en vez de que les estén contando algo que pasó."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["llamé", "se abrió la puerta", "estaba de pie", "dijo", "fui", "había llegado", "resultó que", "me preguntó"], "requirement": "Presente en cuanto empieza la acción" },
      { "kind": "min_words", "n": 12, "requirement": "Llega al momento en que empieza a pasar" },
      { "kind": "max_words", "n": 45, "requirement": "Una o dos frases" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('telling-it', 2,
  'Palabras reales',
  $md$Esta es la mayor mejora individual disponible para la mayoría de la gente, y no requiere ningún ingenio en absoluto, porque estás citando en vez de inventando.

*Dijo que no estaba interesado.*
*Dice, sin levantar la vista: no me interesa.*

La primera es información sobre una conversación. La segunda es una conversación. Mismo contenido, y la segunda tiene una persona dentro.

**La jugada:** cita a la gente en vez de resumirla.

El diálogo hace tres cosas a la vez. Convierte a alguien en un personaje en vez de en un hecho — cómo dice algo una persona es la mayor parte de lo que la hace vívida. Suministra ritmo, porque el habla tiene una forma que el discurso indirecto aplana. Y te regala el final, ya que las últimas líneas más fuertes en historias de conversación casi siempre son algo que alguien dijo.

No necesitas exactitud. A nadie lo han pillado nunca por la redacción exacta de un comentario, y *dice algo como* está disponible si te importa. Acierta la forma y el registro y es cierto de la forma en que las historias son ciertas.

Dos cosas mecánicas. No etiquetes el tono — *dijo, con mucho sarcasmo* es tú explicando una interpretación que podrías simplemente dar, y darla tarda menos tiempo. Y mantén las atribuciones cortas: *dice*, *va y dice*, o nada en absoluto donde es obvio. Las atribuciones largas matan el ritmo que suministraba el diálogo.

Tus propias líneas también cuentan, y la gente las infrautiliza. *Y digo, no tengo ni idea* es mejor que *y no supe qué decir* — la segunda resume el momento exacto en el que el oyente quería estar.

Si te quedas con una cosa: cita, no resumas. No cuesta nada inventarlo y es de donde viene la mayor parte de la vida de una historia.$md$,
  $j$[
    {
      "situation": "Estás a punto de decir que te dijo que no estaba interesado.",
      "line": "Dice, sin levantar la vista: no me interesa.",
      "why": "Mismo contenido, y la segunda versión tiene una persona dentro. Cómo dice algo alguien es la mayor parte de lo que lo hace vívido."
    },
    {
      "situation": "Quieres transmitir que fue sarcástico.",
      "line": "(da la línea en vez de la etiqueta)",
      "why": "Dijo, con mucho sarcasmo es tú explicando una interpretación que podrías simplemente hacer, y hacerla tarda menos tiempo."
    },
    {
      "situation": "Estás a punto de decir que no sabías qué decir.",
      "line": "Y digo: no tengo ni idea.",
      "why": "El resumen se salta el momento exacto en el que el oyente quería estar, y tus propias líneas son las que la gente infrautiliza más."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué es el diálogo la mayor mejora para la mayoría de la gente?",
      "options": [
        { "text": "Es más entretenido.", "correct": false, "note": "Cierto y inútilmente general — di qué está haciendo que un resumen no hace." },
        { "text": "No requiere ningún ingenio, porque estás citando.", "correct": true, "note": "No hay que inventar nada. Convierte a alguien en un personaje en vez de en un hecho, suministra ritmo, y te regala un final — todo de material que ya tienes." },
        { "text": "Llena tiempo.", "correct": false, "note": "Normalmente es más corto que el resumen, que tiende a explicar lo que la línea habría mostrado." },
        { "text": "A la gente le gusta que la citen.", "correct": false, "note": "Normalmente no están presentes, y no importaría si lo estuvieran." }
      ],
      "explain": "Cita, no resumas. La vida de una historia viene sobre todo de esto."
    },
    {
      "prompt": "¿Qué no deberías hacer con el diálogo?",
      "options": [
        { "text": "Inventar la redacción.", "correct": false, "note": "A nadie lo han pillado nunca por las palabras exactas. Acierta la forma y el registro y es cierto de la forma en que las historias son ciertas." },
        { "text": "Citarte a ti mismo.", "correct": false, "note": "Tus propias líneas son las que la gente infrautiliza más, y son donde el oyente más quiere estar." },
        { "text": "Usarlo para más de dos personas.", "correct": false, "note": "El tamaño del reparto es una restricción real y una lección distinta. Dos personas hablando es el caso normal." },
        { "text": "Etiquetar el tono.", "correct": true, "note": "Dijo, con mucho sarcasmo explica una interpretación que podrías simplemente dar — y darla tarda menos tiempo y funciona mejor." }
      ],
      "explain": "Mantén las atribuciones cortas también. Dice, va y dice, o nada donde es obvio."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "quoted", "label": "Citó en vez de resumir", "description": "Dio líneas reales." },
      { "key": "own_lines", "label": "Se citó también a sí mismo", "description": "Incluyó sus propias palabras en el momento clave." },
      { "key": "no_labels", "label": "No etiquetó el tono", "description": "Lo interpretó en vez de describirlo." },
      { "key": "short_attributions", "label": "Mantuvo las atribuciones cortas", "description": "Dice, va y dice, o nada." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa",
      "mood": "Disfrutándolo.",
      "openness": 4,
      "personality": "Se ríe con las líneas citadas y asiente con educación ante las resumidas. Nunca pregunta qué dijo alguien."
    },
    "setting": "Estás contando una historia cuyo mejor momento es un intercambio entre tú y un hombre en un mostrador.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Reacciona con claridad al diálogo citado.",
      "Responde con un pequeño asentimiento y nada más a un resumen de lo que se dijo.",
      "Nunca pidas las palabras exactas una segunda vez."
    ],
    "opening_beat": "«¿Y qué dijo?»",
    "success_looks_like": "La persona cita el intercambio en vez de describirlo."
  }$j$::jsonb,
  'Hoy, cita dos líneas de diálogo en una historia en vez de resumirlas. Apunta las dos.',
  $j${
    "says": "¿Y qué dijo?",
    "model": {
      "line": "Me mira unos cuatro segundos y va y dice: ¿y quién te ha dicho eso?",
      "why": "Citado en vez de resumido, con una atribución corta y sin etiqueta sobre el tono. No hubo que inventar nada — la línea ya existía."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["dijo eso", "me dijo eso", "básicamente", "estaba muy", "con sarcasmo", "con enfado", "dejó claro", "la idea era"], "requirement": "Cítalo, no lo resumas ni etiquetes el tono" },
      { "kind": "min_words", "n": 8, "requirement": "Da la línea real" },
      { "kind": "max_words", "n": 35, "requirement": "Atribución corta, y luego las palabras" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('telling-it', 3,
  'Un detalle que se gane su sitio',
  $md$El detalle es donde la gente cuidadosa invierte de más, y merece la pena saber exactamente cuánto puede llevar una historia.

La respuesta es más o menos uno por historia. Una cosa concreta que la hace real y que no se podría haber inventado de forma plausible: el hecho de que sujetaba un sándwich todo el rato, la música de espera, el enorme perro dormido atravesado en la puerta.

**La jugada:** elige el único detalle que se gane su sitio, y corta el resto de la descripción.

Lo que hace un buen detalle no es decoración. Certifica la historia — un oyente que oye algo extrañamente específico concluye, sin decidirlo, que esto pasó. Ese efecto viene de un detalle y no aumenta con más; el segundo y el tercero no producen nada, y para el cuarto estás describiendo una habitación mientras la historia espera.

Elegir es la habilidad. Un detalle que funciona es específico, algo raro, y conectado al momento que importa. *Un hombre de unos cuarenta años* no es un detalle, es una categoría. *El sándwich* es un detalle, porque es extraño, porque es preciso, y porque que él lo sujetara mientras pasaba todo esto es lo que de verdad recuerdas.

Hay una trampa relacionada en la descripción física. Describir qué aspecto tenía alguien casi nunca se gana su sitio a menos que el aspecto sea estructural — cómo se comportaron es lo que los convierte en un personaje, y *no soltó el sándwich ni una sola vez* hace más que un párrafo sobre su cara.

Y fíjate en que los buenos ya suelen estar en tu memoria. No los construyes; estás recordando algo extrañamente vívido, y esa extraña viveza es precisamente la señal de que es el correcto.

Si te quedas con una cosa: un detalle, elegido por su rareza, y nada más descrito. El oyente hace el resto.$md$,
  $j$[
    {
      "situation": "Quieres que la escena se sienta real.",
      "line": "Sujetaba un sándwich todo el rato.",
      "why": "Específico, algo raro, y conectado al momento que importa. Un oyente que oye algo extrañamente específico concluye sin decidirlo que esto pasó."
    },
    {
      "situation": "Tienes tres o cuatro buenos detalles.",
      "line": "(el segundo no produce nada)",
      "why": "La certificación viene de un detalle y no aumenta con más. Para el cuarto estás describiendo una habitación mientras la historia espera."
    },
    {
      "situation": "Estás a punto de describir qué aspecto tenía.",
      "line": "(cómo se comportó lo convierte en un personaje)",
      "why": "El aspecto rara vez se gana su sitio. No soltó el sándwich ni una sola vez hace más que un párrafo sobre su cara."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hace de verdad un buen detalle?",
      "options": [
        { "text": "Ayuda a la gente a imaginárselo.", "correct": false, "note": "En parte, y imaginárselo no es lo que cambia cómo se recibe una historia." },
        { "text": "Lo hace más entretenido.", "correct": false, "note": "Vago. El efecto es específico y algo extraño." },
        { "text": "Certifica que pasó.", "correct": true, "note": "Un oyente que oye algo extrañamente específico concluye, sin decidirlo, que esto es real — y ese efecto viene de un detalle y no aumenta con más." },
        { "text": "Ralentiza el ritmo donde lo quieres lento.", "correct": false, "note": "El detalle sí ralentiza las cosas, que es un coste que gestionar, no el objetivo." }
      ],
      "explain": "Uno por historia. El segundo y el tercero no producen nada."
    },
    {
      "prompt": "¿Cuál de estas es un detalle?",
      "options": [
        { "text": "Un hombre de unos cuarenta años.", "correct": false, "note": "Una categoría, no un detalle. Podría ser casi cualquiera y no certifica nada." },
        { "text": "Iba bastante bien vestido.", "correct": false, "note": "Una impresión, y de impresiones están hechas las descripciones. No se puede imaginar con precisión." },
        { "text": "Parecía molesto.", "correct": false, "note": "Una interpretación, y una a la que el oyente preferiría llegar solo a partir de algo que él hizo." },
        { "text": "Sujetaba un sándwich todo el rato.", "correct": true, "note": "Específico, raro, y conectado al momento que importa — que es toda la especificación." }
      ],
      "explain": "Los buenos ya suelen estar en tu memoria, y la extraña viveza es la señal."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one", "label": "Usó un detalle", "description": "No apiló varios." },
      { "key": "odd", "label": "Eligió uno raro", "description": "Específico y algo extraño en vez de una categoría." },
      { "key": "connected", "label": "Conectado al momento", "description": "Pegado a la parte que importaba." },
      { "key": "no_description", "label": "Cortó la descripción", "description": "Sin párrafo sobre qué aspecto tenía nadie." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa",
      "mood": "Escuchando.",
      "openness": 4,
      "personality": "Reacciona a un detalle concreto extraño y se le va la mirada durante la descripción acumulada."
    },
    "setting": "Estás contando una historia sobre una larga discusión en un mostrador. El hombre sujetó un sándwich todo el rato, había una música de espera horrible, y llovía.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Reacciona con interés a un único detalle extraño.",
      "Que se te vaya visiblemente la mirada durante dos o más piezas de descripción.",
      "Nunca vuelvas a preguntar qué aspecto tenía alguien."
    ],
    "opening_beat": "«¿Cómo era?»",
    "success_looks_like": "La persona da un detalle raro concreto en vez de una descripción."
  }$j$::jsonb,
  'Hoy, cuenta una historia con exactamente un detalle. Apunta el detalle que mantuviste y uno que cortaste.',
  $j${
    "beats": [
      {
        "situation": "«¿Cómo era?» Tenía unos cuarenta años, iba bien vestido, claramente molesto, y sujetó un sándwich durante toda la discusión.",
        "prompt": "¿Qué dices?",
        "options": [
          { "text": "Todo — construye la imagen.", "correct": false, "note": "Para la tercera pieza estás describiendo una habitación mientras la historia espera. La certificación viene de un detalle y no aumenta con más." },
          { "text": "Tenía unos cuarenta años e iba bastante bien vestido.", "correct": false, "note": "Una categoría y una impresión. Ninguna de las dos podría ser cierta solo de este hombre, así que ninguna certifica nada." },
          { "text": "Sujetaba un sándwich todo el rato.", "correct": true, "note": "Específico, raro, y pegado al momento que importa. Un oyente que oye algo tan extraño concluye sin decidirlo que pasó." },
          { "text": "Estaba claramente molesto.", "correct": false, "note": "Una interpretación, y una a la que el oyente preferiría llegar solo a partir de algo que él hizo." }
        ]
      },
      {
        "situation": "Quieres que el hombre se sienta como una persona en vez de como un hecho.",
        "prompt": "¿Qué hace eso?",
        "options": [
          { "text": "Describir qué aspecto tenía.", "correct": false, "note": "El aspecto rara vez se gana su sitio. Casi nadie se convierte en un personaje a través de la descripción." },
          { "text": "Algo que hizo que no podrías haber inventado.", "correct": true, "note": "No soltó el sándwich ni una sola vez hace más que un párrafo sobre su cara — el comportamiento convierte a alguien en un personaje." },
          { "text": "Decir qué tipo de persona parecía ser.", "correct": false, "note": "Eso entrega tu conclusión y se salta la evidencia, que es la parte que habría sido vívida." },
          { "text": "Darle un nombre.", "correct": false, "note": "Los nombres ayudan a seguir a la gente y no hacen nada por hacerla real." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('telling-it', 4,
  'Conoce tu última línea',
  $md$Esta es la única cosa que separa a la gente que hace aterrizar sus historias de la que se va apagando, y se decide antes de abrir la boca.

**La jugada:** conoce la frase final antes de empezar, y dirígete hacia ella.

Si sabes adónde vas, tres cosas se siguen automáticamente. Puedes cortar por el camino, porque puedes ver qué no está en la ruta. Puedes ritmarla, porque sabes cuán lejos está el final. Y puedes parar con limpieza, porque llegar a algún sitio al que pretendías llegar se siente completamente distinto de quedarte sin nada.

Si no lo sabes, vas a acercarte al final, vas a sentir que el material se adelgaza, y vas a producir *bueno, sí — en fin*, que es el sonido de una historia siendo abandonada en vez de terminada. Todo el mundo lo reconoce, incluida la persona que lo dice, y retroactivamente hace que una historia decente se sienta como un error.

La última línea casi siempre es algo que alguien dijo, que es un atajo útil cuando estás eligiendo una. La mejor línea de una historia de conversación normalmente es una pieza de diálogo — suya o tuya — y muy a menudo es lo primero que le contarías a alguien si tuvieras una sola frase.

Hay una pequeña disciplina asociada: en cuanto la sepas, no la digas pronto. La gente a menudo revela su mejor línea en el planteamiento, la usa como marco, y luego no tiene nada con qué terminar. Si es el final, no es la apertura.

Y donde una historia no tiene una última línea obvia, merece la pena saberlo antes de comprometerte a contarla. Normalmente significa que falta el giro en vez del final, que es el problema del bloque anterior llegando disfrazado de otra cosa.

Si te quedas con una cosa: decide la última línea primero. Todo lo de contarla es dirigirte hacia un punto que ya conoces.$md$,
  $j$[
    {
      "situation": "Estás a punto de empezar y no sabes cómo termina.",
      "line": "(decide la última línea primero)",
      "why": "Saber adónde vas te permite cortar por el camino, ritmarla, y parar con limpieza en vez de quedarte sin nada."
    },
    {
      "situation": "Has llegado cerca del final sin nada que quede.",
      "line": "(bueno, sí — en fin)",
      "why": "El sonido de una historia siendo abandonada en vez de terminada, y todo el mundo lo reconoce, tú incluido."
    },
    {
      "situation": "La mejor línea es la que ibas a usar para abrir.",
      "line": "(entonces no es la apertura)",
      "why": "La gente revela su mejor línea en el planteamiento y luego no tiene nada con qué terminar. Si es el final, se queda al final."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué se sigue de conocer la última línea?",
      "options": [
        { "text": "Puedes cortar, ritmar, y parar con limpieza.", "correct": true, "note": "Las tres se siguen automáticamente de saber adónde vas — puedes ver qué se sale de la ruta, cuán lejos está el final, y dónde parar." },
        { "text": "Suenas más seguro.", "correct": false, "note": "Sí, y eso es consecuencia de no estar perdido, no un beneficio aparte." },
        { "text": "Te impide divagar.", "correct": false, "note": "Una de las tres, planteada sola. Cortar es la parte que nombra." },
        { "text": "Puedes ensayarla.", "correct": false, "note": "El ensayo no es lo que esto compra, y una historia memorizada tiende a sonar recitada." }
      ],
      "explain": "Llegar a algún sitio al que pretendías llegar se siente completamente distinto de quedarte sin nada."
    },
    {
      "prompt": "La historia no tiene una última línea obvia. ¿Qué significa eso?",
      "options": [
        { "text": "Necesitas un final mejor.", "correct": false, "note": "No se le pueden añadir finales a algo que no tiene nada que terminar. El problema está más arriba." },
        { "text": "Necesita más detalle hacia el que construir.", "correct": false, "note": "El detalle no puede suministrar una resolución, y añadirlo produce una historia más larga con la misma ausencia." },
        { "text": "No merece la pena contarla.", "correct": false, "note": "Demasiado rápido — puede ser una buena historia con un giro sin encontrar en vez de una mala." },
        { "text": "Probablemente falte el giro.", "correct": true, "note": "Es el problema del bloque anterior disfrazado de otra cosa: una historia sin nada que dé la vuelta no tiene nada que asentar." }
      ],
      "explain": "La última línea casi siempre es algo que alguien dijo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "knew_it", "label": "Sabía la última línea", "description": "La decidió antes de empezar." },
      { "key": "steered", "label": "Se dirigió hacia ella", "description": "Cortó lo que se salía de la ruta." },
      { "key": "stopped_there", "label": "Paró en ella", "description": "Terminó donde pretendía." },
      { "key": "saved_it", "label": "No la usó pronto", "description": "Guardó la mejor línea para el final." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa",
      "mood": "Preparada.",
      "openness": 4,
      "personality": "Reacciona con fuerza a un aterrizaje limpio y no reacciona en absoluto a una historia que se va apagando."
    },
    "setting": "Estás a punto de contar una historia cuyo mejor momento es algo que dijo la otra persona justo al final.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Reacciona por completo a una historia que termina en una línea clara.",
      "No digas gran cosa después de una historia que se va apagando, y cambia de tema.",
      "Nunca rescates un final con una pregunta."
    ],
    "opening_beat": "«Venga, cuenta.»",
    "success_looks_like": "La persona termina en una línea hacia la que claramente se dirigía."
  }$j$::jsonb,
  'Hoy, decide la última línea de una historia antes de contarla. Apunta la línea y si aterrizaste en ella.',
  $j${
    "says": "Venga, cuenta. (El mejor momento de esta historia es lo que dijo la otra persona justo al final.)",
    "model": {
      "line": "(la última línea, decidida antes de empezar — y no usada como apertura)",
      "why": "Saber adónde vas te permite cortar por el camino, ritmarla, y parar con limpieza. Sin eso llegas cerca del final, sientes que el material se adelgaza, y produces bueno, sí — en fin."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["bueno sí", "en fin", "o lo que sea", "no sé", "tenías que haber estado allí", "fue más gracioso", "eso fue todo la verdad", "y ya está"], "requirement": "No te vayas apagando" },
      { "kind": "min_words", "n": 6, "requirement": "Aterriza en una línea real" },
      { "kind": "max_words", "n": 30, "requirement": "Para en ella" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('telling-it', 5,
  'Ve más despacio y para de moverte',
  $md$Todo lo demás de este bloque son palabras. Esta es la pequeña cantidad de interpretación que de verdad importa, y hay mucha menos de la que la gente teme.

**La jugada:** ve más despacio antes del giro, y deja que se asiente un silencio.

Ir más despacio antes del giro vale más que cualquier redacción. Señala, sin anunciar nada, que viene algo — y el oyente se ajusta. Luego di el giro a velocidad normal y para. Lo más común que la gente le hace a su mejor momento es precipitarlo, porque están nerviosos por tener la palabra y el giro es el punto de máxima exposición.

Dejar que se asiente un silencio después del giro es la otra mitad, y es la misma instrucción que terminar en la línea: un compás es donde pasa la reacción.

Eso es de verdad la mayor parte, que merece la pena decir con claridad porque el consejo de interpretación suele ser una lista de veinte cosas sobre postura y gesto que nadie puede tener en la cabeza mientras también cuenta una historia. No necesitas actuar. Tu cara ya está haciendo más de lo que crees, y la historia está cargando con la mayor parte del peso.

Dos cosas que merece la pena quitar en vez de añadir. Acelerar cuando sientes que estás perdiendo a alguien — se lee como ansiedad y hace la historia más difícil de seguir, y el arreglo para perder gente es llegar al final en vez de llegar más rápido. Y la risa de disculpa en medio, que le dice a todo el mundo que tienes dudas sobre el material.

El volumen importa más que cualquier otra cosa de la lista, y es lo menos comentado. Una buena historia contada un poco demasiado bajo es una historia que la mitad de la mesa está esforzándose por oír, y esforzarse es indistinguible de desconectar. Si eres callado por naturaleza, esta es la única cosa física que merece la pena practicar.

Si te quedas con una cosa: ve más despacio antes del giro, y luego para. Eso es toda la interpretación, y todo lo demás es la forma haciendo su trabajo.$md$,
  $j$[
    {
      "situation": "Estás a dos frases del giro.",
      "line": "(ve más despacio)",
      "why": "Señala que viene algo sin anunciarlo, y el oyente se ajusta. Luego di el giro a velocidad normal."
    },
    {
      "situation": "Sientes que estás perdiendo a alguien.",
      "line": "(llega al final, no aceleres)",
      "why": "Acelerar se lee como ansiedad y hace más difícil seguirla. El arreglo para perder gente es llegar antes en vez de hablar más rápido."
    },
    {
      "situation": "Eres callado por naturaleza.",
      "line": "(el volumen es la única cosa física que merece la pena practicar)",
      "why": "Media mesa esforzándose por oír es indistinguible de una mesa que ha desconectado."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué vale más que cualquier redacción?",
      "options": [
        { "text": "Contacto visual por la mesa.", "correct": false, "note": "Útil y está en la larga lista de consejos de interpretación que nadie puede tener en la cabeza mientras cuenta una historia." },
        { "text": "Ir más despacio antes del giro.", "correct": true, "note": "Señala que viene algo sin anunciarlo, y el oyente se ajusta. Luego el giro a velocidad normal, y para." },
        { "text": "Variar tu tono.", "correct": false, "note": "Pasa de forma natural cuando de verdad estás contando algo, y gestionarlo de forma consciente es lo que produce una actuación." },
        { "text": "Usar las manos.", "correct": false, "note": "Completamente opcional, y preocuparte por ello le quita atención a la historia." }
      ],
      "explain": "Hay mucha menos interpretación que acertar de la que la gente teme."
    },
    {
      "prompt": "¿Qué cosa física es la más infravalorada?",
      "options": [
        { "text": "Postura.", "correct": false, "note": "Casi irrelevante en una mesa, y es lo primero que menciona la mayoría de los consejos." },
        { "text": "Expresión facial.", "correct": false, "note": "Ya está haciendo más de lo que crees, sin gestión." },
        { "text": "Gesto.", "correct": false, "note": "Opcional, y un gesto cohibido es peor que ninguno." },
        { "text": "Volumen.", "correct": true, "note": "Una buena historia contada un poco demasiado bajo tiene a media mesa esforzándose, y esforzarse es indistinguible de desconectar." }
      ],
      "explain": "Ve más despacio antes del giro, y luego para. La forma hace el resto."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "slowed", "label": "Fue más despacio antes del giro", "description": "Le dio un compás de acercamiento." },
      { "key": "stopped", "label": "Dejó que se asentara un silencio", "description": "No habló durante la reacción." },
      { "key": "no_rushing", "label": "No aceleró", "description": "Llegó al final en vez de ir más rápido." },
      { "key": "audible", "label": "Se le oía", "description": "Lo bastante alto como para que nadie se esforzara." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "alguien en la mesa",
      "mood": "Contigo.",
      "openness": 4,
      "personality": "Responde al ritmo — se inclina hacia delante cuando el narrador va más despacio, y desconecta un poco cuando acelera o baja el volumen."
    },
    "setting": "Estás a tres frases del mejor momento de la historia y la mesa está contigo.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Inclínate hacia delante y quédate callada cuando el narrador vaya más despacio antes de algo.",
      "Desconecta un poco si el narrador acelera o baja la voz.",
      "Nunca comentes sobre el ritmo."
    ],
    "opening_beat": "«¿Y qué hizo?»",
    "success_looks_like": "La persona va más despacio hacia el giro y deja que se asiente el compás posterior."
  }$j$::jsonb,
  'Hoy, ve más despacio en las dos frases antes de la mejor parte de una historia. Apunta qué notaste en la sala.',
  $j${
    "beats": [
      {
        "situation": "A tres frases del mejor momento, y la mesa está contigo.",
        "prompt": "¿Qué haces con el ritmo?",
        "options": [
          { "text": "Acelera — viene la parte buena.", "correct": false, "note": "Precipitar tu propio mejor momento es lo más común que la gente le hace, normalmente porque el giro es el punto de máxima exposición." },
          { "text": "Anúncialo — esto os va a encantar.", "correct": false, "note": "Establece un estándar que la línea luego tiene que superar, y es una coletilla con abrigo de confianza." },
          { "text": "Ve un poco más despacio, y luego di el giro a velocidad normal.", "correct": true, "note": "Ir más despacio señala que viene algo sin anunciarlo, y el oyente se ajusta. Vale más que cualquier redacción." },
          { "text": "Nada — el ritmo se cuida solo.", "correct": false, "note": "No se cuida solo con nervios leves, que producen de forma fiable aceleración justo en este punto." }
        ]
      },
      {
        "situation": "Sientes que alguien al otro extremo de la mesa ha dejado de seguirte.",
        "prompt": "¿Y ahora?",
        "options": [
          { "text": "Acelera para llegar antes de perderlos.", "correct": false, "note": "Se lee como ansiedad y hace la historia más difícil de seguir, que los pierde más rápido." },
          { "text": "Añade un detalle para revivirla.", "correct": false, "note": "Más material es lo contrario de lo que necesita una historia que se apaga." },
          { "text": "Comprueba si te están siguiendo.", "correct": false, "note": "Convierte la atención de la sala en el tema y pone a alguien en un aprieto por haberse distraído." },
          { "text": "Llega al final — y comprueba que se te oye.", "correct": true, "note": "El arreglo es llegar antes en vez de hablar más rápido. Y media mesa esforzándose por oír es indistinguible de una mesa que ha desconectado." }
        ]
      }
    ]
  }$j$::jsonb
);
