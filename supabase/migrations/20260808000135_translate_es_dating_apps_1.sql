-- Spanish: Apps de citas, track 1 — Tu perfil.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, names left alone (Robin, kept masculine here as in the
-- Small talk migrations, since this topic gives it no `sex` field to
-- branch on). New for this topic:
--
-- **The "persona" trick for gender-neutral address.** This topic addresses
-- the reader's own temperament a lot ("if you are quiet", "louder than you
-- are"). Where a literal translation would force a gendered adjective onto
-- "tú", the adjective is attached to a feminine noun instead ("una persona
-- callada") or converted to an abstract noun ("más ruido del que tienes")
-- so no gender is asserted about the reader.
--
-- **Buzzword lists** (lesson 1's "adventurous, laid-back, love to laugh")
-- are rendered as generic masculine-singular dictionary entries, the
-- normal Spanish convention for listing example adjectives detached from
-- any specific person, not as claims about the reader's gender.

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

select pg_temp.es_lesson('your-profile', 1,
  'Que te escriban gana a impresionar',
  $md$Todo el mundo escribe su perfil como si fuera un anuncio, y un anuncio es el documento equivocado.

La pregunta que tiene que responder no es *¿soy impresionante?*. Es *¿qué me diría alguien?* — y esas dos preguntas producen páginas completamente distintas.

Impresionar produce adjetivos. Aventurero. Tranquilo. Que le encanta reír. Sarcástico. Abierto a todo. Ninguno se puede responder: no hay respuesta a *tranquilo*, así que el desconocido que lo lee no tiene nada de qué agarrarse y tiene que inventar una apertura de la nada. No lo va a hacer. Tiene otros once perfiles abiertos.

**La jugada:** escribe cosas a las que se pueda responder.

Objetos, lugares, opiniones. No *me encanta viajar* sino *he estado en Lisboa cuatro veces y todavía no he ido a ningún otro sitio de Portugal*. No *foodie* sino *conduzco una hora por una buena panadería*. La misma información, salvo que la segunda versión de cada una tiene un asidero, y el asidero es todo el sentido.

Prueba cualquier frase preguntándote qué podría escribirte un desconocido sobre ella. Si la respuesta es nada, la frase es decoración. Con tres o cuatro ganchos es de sobra — un perfil no tiene que estar completo, tiene que ser abrible.

Y fíjate en lo que esto hace por alguien callado. No puedes controlar quién se te acerca en un bar. Aquí puedes decidir, de antemano y con tantos borradores como quieras, de qué te va a hablar la gente.$md$,
  $j$[
    {
      "situation": "Tu perfil dice: aventurero, tranquilo, le encanta reír.",
      "line": "(¿qué podría escribirte alguien sobre eso?)",
      "why": "Nada. Los adjetivos son irrespondibles, lo que significa que el perfil le ha pedido al desconocido que invente una apertura de la nada, y no se va a molestar."
    },
    {
      "situation": "Quieres decir que te gusta viajar.",
      "line": "He estado en Lisboa cuatro veces y nunca en ningún otro sitio de Portugal.",
      "why": "La misma información con un asidero. Hay tres respuestas obvias a esa frase y ninguna a me encanta viajar."
    },
    {
      "situation": "Te preguntas si el perfil está terminado.",
      "line": "(cuenta los ganchos — tres o cuatro es de sobra)",
      "why": "Un perfil no tiene que estar completo, tiene que ser abrible. Ser completo es lo que hace que se lea como un formulario."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué fallan los adjetivos en un perfil?",
      "options": [
        { "text": "Normalmente no son ciertos.", "correct": false, "note": "A menudo son del todo ciertos. Lo que falta no es verdad — es un asidero." },
        { "text": "No hay respuesta a tranquilo.", "correct": true, "note": "Una frase irrespondible le pide al desconocido que invente una apertura de la nada, y tiene otros once perfiles abiertos." },
        { "text": "Los usa todo el mundo.", "correct": false, "note": "Es cierto, y no ser original es el problema menor. No poder responderse es lo que te cuesta mensajes." },
        { "text": "Son aburridos.", "correct": false, "note": "Un juicio, no un mecanismo. Una frase sosa pero concreta sigue recibiendo respuestas." }
      ],
      "explain": "Cada frase debería ser algo sobre lo que alguien pudiera escribirte."
    },
    {
      "prompt": "Entonces, ¿para qué sirve de verdad un perfil?",
      "options": [
        { "text": "Ser lo bastante impresionante para conseguir un like.", "correct": false, "note": "Esta es la versión anuncio, y produce una página que nadie puede abrir." },
        { "text": "Describirte con precisión.", "correct": false, "note": "Preciso e inabrible es un perfil muy habitual. Ser completo no es el objetivo." },
        { "text": "Gustarle al mayor número de gente posible.", "correct": false, "note": "Ser ampliamente aceptable es lo mismo que ser olvidable, que es de lo que trata la tercera lección de este bloque." },
        { "text": "Darle a alguien algo que decirte.", "correct": true, "note": "Ese es todo el trabajo. Un perfil no tiene que estar completo, tiene que ser abrible." }
      ],
      "explain": "Que te puedan escribir, no que impresione. Juzga cada frase por lo que se te podría responder."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "hooks", "label": "Dejó ganchos", "description": "Escribió frases a las que un desconocido podría responder." },
      { "key": "concrete", "label": "Objetos, no adjetivos", "description": "Nombró lugares, cosas y opiniones en vez de cualidades." },
      { "key": "not_selling", "label": "No hizo publicidad", "description": "Se resistió a escribir la versión impresionante." },
      { "key": "enough", "label": "Supo cuándo parar", "description": "Tres o cuatro ganchos en vez de un relato completo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "un amigo repasando tu perfil contigo",
      "mood": "Divertido, completamente de tu parte.",
      "openness": 5,
      "personality": "Directo y constructivo. Pregunta qué podría responder un desconocido a cada frase, y no acepta un adjetivo como respuesta."
    },
    "setting": "Un amigo que es absurdamente bueno en esto tiene tu perfil abierto en el móvil y se ha ofrecido a ser sincero al respecto.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué podría responder un desconocido, línea a línea.",
      "Acepta objetos, lugares y opiniones concretos; cuestiona las cualidades y los adjetivos.",
      "Mantén las respuestas cortas y cercanas."
    ],
    "opening_beat": "«Vale. Primera línea: aventurero, tranquilo, le encanta reír. ¿Qué se supone que te tengo que escribir sobre eso?»",
    "success_looks_like": "La persona convierte un adjetivo en algo concreto con lo que un desconocido podría abrir."
  }$j$::jsonb,
  'Hoy, coge una línea de tu perfil y reescríbela como algo a lo que un desconocido pudiera responder. Apunta el antes y el después.',
  $j${
    "beats": [
      {
        "situation": "Tu perfil empieza así: aventurero, tranquilo, le encanta reír.",
        "prompt": "Un desconocido lee eso. ¿Qué te puede escribir?",
        "options": [
          { "text": "Algo sobre lo de aventurero, supongo.", "correct": false, "note": "Prueba a escribirlo. Todo lo que se te ocurra es una pregunta que tendrían que inventar de la nada, que es justo por lo que nadie la manda." },
          { "text": "Nada — no hay ningún asidero en nada de eso.", "correct": true, "note": "Los adjetivos son irrespondibles. El perfil le ha pedido al desconocido que haga todo el trabajo, y tiene otros once perfiles abiertos." },
          { "text": "Un chiste, si tiene ingenio.", "correct": false, "note": "Pone toda la carga sobre su ingenio. La concreción es lo que le permite a una persona corriente abrir una conversación." },
          { "text": "Hola.", "correct": false, "note": "Cierto en la práctica, y merece la pena ver que hola es el mensaje que tu propio perfil ha estado pidiendo." }
        ]
      },
      {
        "situation": "Quieres que el perfil diga que te gusta viajar.",
        "prompt": "¿Qué frase hace el trabajo?",
        "options": [
          { "text": "Siempre planeando el próximo viaje.", "correct": false, "note": "Sigue siendo un adjetivo disfrazado de verbo. No hay nada de lo que se pueda tirar." },
          { "text": "Me encanta viajar — dime a dónde debería ir después.", "correct": false, "note": "Contiene una pregunta, que parece un gancho, y es una pregunta sobre que hagan tu trabajo por ti." },
          { "text": "He estado en Lisboa cuatro veces y nunca en ningún otro sitio de Portugal.", "correct": true, "note": "Tres respuestas obvias, todas fáciles. La misma información que me encanta viajar, con un asidero." },
          { "text": "Veintitrés países y sigo contando.", "correct": false, "note": "Impresionante y cerrado. Un número es una afirmación, no algo con lo que un desconocido pueda abrir." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('your-profile', 2,
  'Las fotos tienen un trabajo',
  $md$La mayoría de la gente sube seis fotos haciendo un solo trabajo, y el trabajo es *en esta salgo bien*.

Quien está deslizando no está juzgando tu cara. Está intentando averiguar si puede imaginarse una hora sentado enfrente de ti, y lo está haciendo en unos dos segundos. Todo lo que viene después sale de ahí.

**La jugada:** dale a cada foto un trabajo distinto.

**Una cara clara, sola, primero.** Sin gafas de sol, sin gente alrededor, sin distancia. Si tu primera foto es de grupo, tienen que resolver un puzle antes de poder interesarse, y no lo van a hacer.

**Una persona entera.** No es vanidad — es legibilidad. Un perfil sin ninguna foto de cuerpo entero se lee como un perfil que esconde algo, lo esconda o no.

**Una haciendo lo que de verdad haces.** En el rocódromo, en la bici, en la cocina, en el escritorio con la planta horrible. Esta es la foto que genera mensajes, porque es la única que tiene algo sobre lo que preguntar.

**Una con más gente.** Dos o tres, no la comitiva de una boda entera. Muestra que tienes vida sin pedirle a nadie que te identifique en una rueda de reconocimiento.

Después, recorta. Gafas de sol en todas las fotos, fotos de grupo en las que no se te encuentra, cualquier cosa de hace cuatro años y un corte de pelo, y el selfie del espejo en el gimnasio — que es la única foto que dice, de forma fiable, algo que no querías decir.

Aquí está la parte que importa si eres una persona callada: no tienes que parecer una persona extrovertida. No hay ninguna foto tuya en lo alto de una mesa con un micrófono que valga lo que una de ti haciendo algo que de verdad haces. Legible gana a animado, siempre.$md$,
  $j$[
    {
      "situation": "Tu primera foto eres tú con cuatro amigos en una boda.",
      "line": "(cámbiala de sitio — la primera foto es una cara clara, sola)",
      "why": "Una foto de grupo la primera les pide resolver un puzle antes de poder interesarse, en una decisión de dos segundos. No van a hacer ese trabajo."
    },
    {
      "situation": "Tienes seis fotos y todas son de los hombros para arriba.",
      "line": "(añade una de cuerpo entero)",
      "why": "No es vanidad, es legibilidad. Un perfil sin nada de cuerpo entero se lee como si escondiera algo, lo esconda o no, y esa lectura se evita gratis."
    },
    {
      "situation": "Estás eligiendo entre tú en una fiesta y tú en el rocódromo.",
      "line": "(el rocódromo — es la que tiene algo sobre lo que preguntar)",
      "why": "La foto de haciendo algo es la que genera los mensajes. Y no necesitas parecer una persona extrovertida; necesitas parecer alguien con quien se podría pasar una hora."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es el trabajo de la primera foto?",
      "options": [
        { "text": "Una cara clara, sola.", "correct": true, "note": "La decisión tarda unos dos segundos. Cualquier cosa que haya que descifrar primero — gente alrededor, gafas de sol, distancia — gasta ese tiempo y no recibe nada a cambio." },
        { "text": "La más favorecedora que tengas.", "correct": false, "note": "Favorecedora e ilegible es el error habitual. En el primer puesto, clara gana a favorecedora." },
        { "text": "Una que muestre tu personalidad.", "correct": false, "note": "Ese es el trabajo de la tercera foto, y funciona mucho mejor una vez que saben qué aspecto tienes." },
        { "text": "Una de grupo, para que parezca que tienes amigos.", "correct": false, "note": "El peor comienzo posible. Convierte el identificarte en el precio de entrada." }
      ],
      "explain": "Cara, sola, clara, primero. Todo lo demás tiene un hueco más adelante."
    },
    {
      "prompt": "Seis fotos. ¿Cuál es el error más habitual?",
      "options": [
        { "text": "Tener demasiado pocas.", "correct": false, "note": "Cuatro buenas ganan a seis de cualquier cosa. La cantidad no es el fallo aquí." },
        { "text": "Que parezcan demasiado posadas.", "correct": false, "note": "Posada está bien, y a menudo es más clara. El problema no es posar." },
        { "text": "Seis versiones de un solo trabajo.", "correct": true, "note": "Seis fotos que dicen todas en esta salgo bien. Cada hueco debería estar haciendo algo distinto — cara, persona entera, lo que haces, gente." },
        { "text": "No tener ninguna foto con más gente.", "correct": false, "note": "Uno de los cuatro trabajos, y solo uno. Que falte es un hueco, no el patrón." }
      ],
      "explain": "Cuatro trabajos: una cara, una persona entera, lo que de verdad haces, y pruebas de que tienes vida."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "face_first", "label": "Empezó con una cara clara", "description": "Puso una foto en solitario y legible en el primer puesto." },
      { "key": "jobs", "label": "Le dio un trabajo a cada foto", "description": "Cubrió cara, persona entera, haciendo algo, y gente." },
      { "key": "cut", "label": "Recortó las que sobraban", "description": "Quitó las de solo gafas de sol, las de grupo en las que no se le encuentra, y cualquier cosa de hace años." },
      { "key": "true", "label": "Se quedó en legible en vez de animado", "description": "Eligió fotos de lo que de verdad hace en vez de sociabilidad actuada." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "un amigo repasando tus fotos contigo",
      "mood": "Disfrutando esto más que tú.",
      "openness": 5,
      "personality": "Directo y práctico. Dice qué está haciendo cada foto y señala cuando dos están haciendo lo mismo."
    },
    "setting": "El mismo amigo, todavía con tu perfil abierto, ahora pasando las fotos.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta para qué sirve cada foto, y señala las que se repiten.",
      "Aprueba una foto del usuario haciendo algo de verdad antes que una social y actuada.",
      "Mantén las respuestas cortas."
    ],
    "opening_beat": "«Vale, la foto uno eres tú con otras cuatro personas en una boda. ¿Cuál eres tú?»",
    "success_looks_like": "La persona le da a cada hueco un trabajo distinto y empieza con una cara clara en solitario."
  }$j$::jsonb,
  'Hoy, abre tus fotos y di en voz alta el trabajo de cada una. Apunta qué hueco no tiene trabajo y qué pondrías ahí.',
  $j${
    "beats": [
      {
        "situation": "Tus seis fotos: una de grupo en una boda, dos selfies con gafas de sol, una a distancia en una playa, una de hace cuatro años, y una en el rocódromo.",
        "prompt": "¿Cuál va primero?",
        "options": [
          { "text": "El rocódromo — dice algo sobre ti.", "correct": true, "note": "No es el hueco de manual para el primer puesto, y es la única foto de las seis que a la vez se te ve con claridad y tiene algo sobre lo que preguntar. Todo lo demás necesita descifrarse." },
          { "text": "La de grupo en la boda — sales feliz.", "correct": false, "note": "El peor comienzo posible. Convierte el encontrarte en el precio de entrada, en una decisión de dos segundos." },
          { "text": "Un selfie con gafas de sol.", "correct": false, "note": "Media cara. El primer puesto existe para responder qué aspecto tienes, y esta se niega a hacerlo." },
          { "text": "La de hace cuatro años, si es la mejor foto.", "correct": false, "note": "Todo lo bueno que hace se deshace en los primeros treinta segundos de conocerte." }
        ]
      },
      {
        "situation": "Te has quedado con cuatro fotos y todas son primeros planos claros y recientes de tu cara.",
        "prompt": "¿Qué falta?",
        "options": [
          { "text": "Nada — fotos claras es todo el sentido.", "correct": false, "note": "Claro era el trabajo del primer puesto. Cuatro fotos haciendo un solo trabajo es el error habitual." },
          { "text": "Algo más favorecedor.", "correct": false, "note": "Favorecedor no es un trabajo. Es el instinto que produjo seis versiones de la misma foto para empezar." },
          { "text": "Una persona entera, algo que de verdad haces, y alguna prueba de que tienes vida.", "correct": true, "note": "Cuatro huecos, cuatro trabajos. La de haciendo algo es de donde vienen los mensajes; la de cuerpo entero quita una lectura que no quieres." },
          { "text": "Más fotos — seis gana a cuatro.", "correct": false, "note": "Cuatro buenas ganan a seis de cualquier cosa. La cantidad nunca fue la variable." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('your-profile', 3,
  'Filtra a propósito',
  $md$Un perfil que le gusta a todo el mundo es un perfil al que nadie escribe, y los dos hechos son el mismo hecho.

Lo universalmente aceptable se construye quitando cualquier cosa a la que alguien pudiera objetar, y lo que se quita es precisamente el material que merece la pena para reaccionar. Lo que sobrevive es suave, agradable y del todo inerte — una página que no ofende a nadie y no le interesa a nadie, que a un desconocido le suena a alguien sin aristas en vez de a alguien que va con cuidado.

**La jugada:** mete algo que te va a hacer perder a alguna gente.

Una opinión real. Una afición un poco vergonzosa. Una preferencia que defenderías. El listón está bajo: no un manifiesto, no una lista de líneas rojas, solo una frase en la que se te vea, con claridad, como una persona concreta en vez de como una ausencia agradable.

Te cuesta matches, y esta es la parte con la que merece la pena quedarse en vez de asentir sin más. Los matches que cuesta son los que se habrían apagado educadamente hacia el mensaje cuatro, porque no había nada entre vosotros. Los que conserva son los que leyeron la frase y pensaron *ay, esa persona*.

Esto es incómodo para cualquiera que lleve años siendo complaciente, y merece la pena nombrar que la incomodidad no es prueba de un error. Gustarle a todo el mundo es una estrategia para no ser rechazado, y funciona — también tiene un efecto secundario, que es no ser elegido.

Las líneas rojas son la excepción. Una lista de lo que no quieres se lee como alguien que se ha llevado una decepción y se está preparando para otra, y filtra la mitad equivocada de la sala. Filtra con lo que *eres*, no con lo que no vas a tolerar.$md$,
  $j$[
    {
      "situation": "Tu perfil es agradable y no hay nada en él que pudiera molestar a nadie.",
      "line": "(añade una frase con la que alguien pudiera estar en desacuerdo)",
      "why": "Lo suave se construye borrando todo lo reaccionable. Lo que queda no le interesa a nadie, y suena a sin aristas en vez de a cuidadoso."
    },
    {
      "situation": "Te preocupa que una opinión te cueste matches.",
      "line": "(te los va a costar — los que se apagan en el mensaje cuatro)",
      "why": "Esos son los matches sin nada entre vosotros. La frase no te cuesta la gente a la que le habrías gustado; la identifica."
    },
    {
      "situation": "Estás a punto de escribir una lista de cosas que no quieres.",
      "line": "(filtra con lo que eres, en vez de eso)",
      "why": "Las líneas rojas suenan a alguien que se prepara para una decepción, y filtran la mitad equivocada de la sala."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué un perfil que le gusta a todo el mundo no recibe mensajes?",
      "options": [
        { "text": "La gente asume que alguien tan bueno ya tiene pareja.", "correct": false, "note": "Un cuento reconfortante. La página no es demasiado buena, es demasiado suave." },
        { "text": "Se lee como falso.", "correct": false, "note": "Normalmente se lee como correcto sin más, que es peor. Lo correcto sin más no produce ninguna reacción." },
        { "text": "Es demasiado corto.", "correct": false, "note": "La longitud no es la variable. Un perfil corto con una opinión real supera a uno largo y complaciente." },
        { "text": "No hay nada a lo que reaccionar.", "correct": true, "note": "Lo universalmente aceptable se construye quitando todo aquello a lo que alguien pudiera objetar, y eso es exactamente el material que merece la pena responder." }
      ],
      "explain": "Suave e inerte son la misma página. Mete algo sobre lo que un desconocido pudiera tener una opinión."
    },
    {
      "prompt": "Añades una opinión que va a repeler a alguna gente. ¿Qué te ha costado eso?",
      "options": [
        { "text": "Matches que habrías disfrutado.", "correct": false, "note": "El miedo, y no lo que pasa de verdad. A alguien a quien le habrías gustado no lo repele saber lo que piensas." },
        { "text": "Los matches que se habrían apagado hacia el mensaje cuatro.", "correct": true, "note": "Cuesta algo real — solo que no algo que quisieras. Esas conversaciones terminan educadamente porque nunca hubo nada entre vosotros." },
        { "text": "Nada en absoluto.", "correct": false, "note": "Demasiado fácil, y esquiva lo que merece la pena pararse a pensar. Sí cuesta matches; la pregunta es cuáles." },
        { "text": "A cualquiera que esté en desacuerdo contigo.", "correct": false, "note": "La gente está en desacuerdo constantemente con cosas que le parecen interesantes. El desacuerdo es una respuesta, que es más de lo que lo suave consigue nunca." }
      ],
      "explain": "Gustarle a todo el mundo te protege del rechazo. También te protege de ser elegido."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "an_opinion", "label": "Metió algo reaccionable", "description": "Escribió al menos una frase con la que alguien pudiera estar en desacuerdo." },
      { "key": "specific", "label": "Fue concreto al respecto", "description": "Nombró una opinión de verdad en vez de insinuar que tiene opiniones." },
      { "key": "no_dealbreakers", "label": "Filtró por lo que es", "description": "Evitó una lista de lo que no va a tolerar." },
      { "key": "light", "label": "Lo mantuvo ligero", "description": "Una frase, no un manifiesto." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "un amigo mirando cómo rellenas el prompt",
      "mood": "Decidido a que escribas algo de verdad.",
      "openness": 5,
      "personality": "Se niega a aceptar nada seguro. Pregunta quién exactamente estaría en desacuerdo con cada respuesta, y señala cuando la respuesta es nadie."
    },
    "setting": "La casilla del prompt está abierta y el prompt en la pantalla dice: una colina en la que morir.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Rechaza las respuestas seguras o en broma preguntando quién estaría de verdad en desacuerdo.",
      "Acepta y disfruta una respuesta que de verdad dividiera a la gente.",
      "Mantén las respuestas en una frase o dos."
    ],
    "opening_beat": "«Una colina en la que morir. Y antes de que pongas piña en la pizza — ¿quién te lo iba a discutir de verdad?»",
    "success_looks_like": "La persona escribe una opinión real que repelería a algo de gente."
  }$j$::jsonb,
  'Hoy, escribe una frase para tu perfil con la que alguna gente estaría en desacuerdo. No hace falta que la publiques. Apunta qué escribiste y a quién perderías.',
  $j${
    "says": "Una colina en la que morir:",
    "model": {
      "line": "Toda película sería mejor veinte minutos más corta, incluidas las que más te gustan.",
      "why": "Una opinión real, sostenida con alegría, con la que un buen número de gente discutiría — y discutir es una respuesta, que es más de lo que un perfil suave consigue nunca. Es una frase, no un manifiesto."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["supongo", "quizá", "quizás", "tal vez", "un poco", "más o menos", "probablemente", "cada uno con lo suyo", "sin juzgar", "es solo mi opinión", "todo el mundo"], "requirement": "Una opinión, no una cobertura" },
      { "kind": "min_words", "n": 5, "requirement": "Suficiente afirmación como para discrepar" },
      { "kind": "max_words", "n": 20, "requirement": "Una frase, no un manifiesto" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('your-profile', 4,
  'Promete a la persona que se va a presentar',
  $md$Hay una versión del consejo típico de perfiles que te dice que te vendas, y tomada al pie de la letra produce el error más caro de todos en estas aplicaciones.

Exagerar funciona. *Siempre a por la aventura, nunca digo que no a una noche de fiesta* te va a conseguir matches, y la factura llega en una cafetería tres semanas después, enfrente de alguien que vino a conocer a una persona que no eres. Después te pasas dos horas interpretándola, que es agotador, y no lleva a ningún sitio, que es peor — porque el fracaso se archiva como *se me dan mal las citas* cuando lo que ha pasado en realidad es que se reservó la cita equivocada.

**La jugada:** promete a la persona que de verdad se va a presentar.

Eso significa escribir la versión verdadera y hacerla concreta en vez de hacerla grande. *Soy capaz de pedalear una distancia absurda por una buena panadería, y a las once ya estoy en la cama* es una persona real con una noche real dentro. No es impresionante y no lo intenta. Quien lo lea o quiere esa noche o no la quiere, y las dos respuestas te son útiles.

Incluye la mitad poco impresionante a propósito. Es la forma más rápida de que te crean, y que te crean vale más que admirarte — un perfil admirado consigue likes, uno creído consigue a alguien que se alegra cuando llegas.

Para alguien callado, todo el cálculo va en la misma dirección. Cada match ganado por aparentar más ruido del que tienes es una cita en la que vas a tener que fingir ese ruido. No quieres más matches. Quieres los que leyeron la versión verdadera y la eligieron.$md$,
  $j$[
    {
      "situation": "Tu perfil dice siempre a por la aventura, nunca digo que no a una noche de fiesta.",
      "line": "Soy capaz de pedalear una distancia absurda por una buena panadería, y a las once ya estoy en la cama.",
      "why": "Una persona real con una noche real dentro. O alguien quiere eso o no lo quiere, y las dos respuestas son útiles — a diferencia de un match ganado con una afirmación que tienes que seguir interpretando."
    },
    {
      "situation": "Tienes la tentación de dejar la versión impresionante.",
      "line": "(la factura llega en la primera cita)",
      "why": "Te pasas dos horas siendo otra persona, no lleva a ningún sitio, y el fracaso se archiva como que se te dan mal las citas en vez de como que reservaste la cita equivocada."
    },
    {
      "situation": "Te preguntas si admitir la mitad aburrida.",
      "line": "(inclúyela — es lo que hace creíble el resto)",
      "why": "Que te crean vale más que admirarte. Admirado consigue likes; creído consigue a alguien que se alegra cuando de verdad llegas."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué debería prometer un perfil?",
      "options": [
        { "text": "La persona que de verdad se va a presentar.", "correct": true, "note": "Cada match ganado por aparentar más ruido del que tienes es una cita en la que después vas a tener que fingir ese ruido. No quieres más matches; quieres los de quienes eligieron la versión verdadera." },
        { "text": "La mejor versión de ti.", "correct": false, "note": "La mejor versión sigue siendo tú, y no es quien se presenta un martes cualquiera. La aspiración es lo que convierte la primera cita en una actuación." },
        { "text": "Lo que sea que consiga más matches.", "correct": false, "note": "Los matches no son el resultado. Optimizar para conseguirlos es exactamente cómo la gente acaba con la agenda llena de citas equivocadas." },
        { "text": "Lo mínimo posible, para no generar expectativas.", "correct": false, "note": "Sobrecorregir hacia una página en blanco. Concreto y verdadero, no vago y seguro." }
      ],
      "explain": "Escribe la versión que siga siendo verdad en una cafetería dentro de tres semanas."
    },
    {
      "prompt": "¿Por qué exagerar sale caro y no solo es una deshonestidad?",
      "options": [
        { "text": "La gente se da cuenta enseguida.", "correct": false, "note": "Muchas veces no se dan cuenta, que es el problema. Si nunca funcionara no sería tentador." },
        { "text": "No es justo para la otra persona.", "correct": false, "note": "Cierto, y no es el argumento que de verdad te va a cambiar el comportamiento aquí." },
        { "text": "Compra matches con la factura vencida en la primera cita.", "correct": true, "note": "Te pasas dos horas interpretando a otra persona, no lleva a ningún sitio, y lo archivas como que se te dan mal las citas en vez de como que reservaste la cita equivocada." },
        { "text": "Te vas a quedar sin cosas que decir.", "correct": false, "note": "Un síntoma y no el mecanismo, y normalmente es justo lo contrario — interpretar es hablador y agotador." }
      ],
      "explain": "El coste no es moral. Es una agenda llena de citas con gente que vino a conocer a otra persona."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "true", "label": "Escribió la versión verdadera", "description": "Describió a la persona que de verdad va a llegar." },
      { "key": "specific", "label": "Lo hizo concreto, no grande", "description": "Buscó el detalle en vez de la escala." },
      { "key": "unimpressive_half", "label": "Incluyó la mitad poco impresionante", "description": "Conservó la parte que hace creíble el resto." },
      { "key": "no_performance", "label": "No prometió una personalidad", "description": "Evitó prometer una energía que tendría que interpretar." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "un amigo leyéndote de vuelta la última frase",
      "mood": "Muy entretenido.",
      "openness": 5,
      "personality": "Te conoce lo bastante bien como para reírse de ello. Pregunta qué pasa en la primera cita si la frase es verdad, y espera."
    },
    "setting": "El perfil está casi terminado. Queda una frase de un borrador anterior: siempre a por la aventura, nunca digo que no a una noche de fiesta, pregúntame lo que quieras.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Cuestiona con buen humor cualquier cosa que el usuario no pudiera sostener en una cita real.",
      "Anímate al momento con cualquier cosa concreta y verdadera, incluidas las partes aburridas.",
      "Mantén las respuestas en una frase o dos."
    ],
    "opening_beat": "«Nunca digo que no a una noche de fiesta. Me cancelaste dos veces el mes pasado porque estabas cansado.»",
    "success_looks_like": "La persona reescribe la frase como algo verdadero y concreto, con la mitad poco impresionante incluida."
  }$j$::jsonb,
  'Hoy, reescribe una frase de tu perfil como la versión que siga siendo verdad un martes cualquiera. Apunta la afirmación que quitaste.',
  $j${
    "says": "La frase que sigue en tu perfil: siempre a por la aventura, nunca digo que no a una noche de fiesta, pregúntame lo que quieras.",
    "model": {
      "line": "Soy capaz de pedalear una distancia absurda por una buena panadería, y a las once ya estoy en la cama.",
      "why": "Una persona real con una noche real dentro, mitad poco impresionante incluida — que es lo que hace creíble el resto. O alguien quiere esa noche o no la quiere, y las dos respuestas son útiles."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["aventura", "siempre", "nunca digo que no", "lo que quieras", "a por lo que sea", "espontáneo", "espontánea", "me encanta reír", "tranquilo", "tranquila", "extrovertido", "extrovertida"], "requirement": "Quita las afirmaciones que tendrías que interpretar" },
      { "kind": "min_words", "n": 8, "requirement": "Lo bastante concreto como para imaginárselo" },
      { "kind": "max_words", "n": 25, "requirement": "Menos de veinticinco palabras" }
    ]
  }$j$::jsonb
);
