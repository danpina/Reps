-- Spanish: El trabajo, track 7 — Presentar.
--
-- Conventions as migration 121. Two lessons have no rehearsal_spec in English
-- (lessons 4's mission and lesson 5's scene) and keep it that way here:
-- lesson 5 is a scene and lesson 4's model line was written straight from
-- the scenario as an mid-recovery restart, which is preserved as-is.
--
-- **"Slide" is "la diapositiva" throughout, not "la lámina" or "el slide".**
-- Standard in Spanish office usage and keeps the drills readable.

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

select pg_temp.es_lesson('presenting', 1,
  'Las diapositivas no son notas',
  $md$La gente no lee sus diapositivas en voz alta por pereza. Lo hace porque una diapositiva llena de palabras es lo único de la sala que no puede olvidar qué viene después, y ponerte de pie delante de compañeros te hace querer algo a lo que agarrarte.

Lo que significa que el problema se resuelve el día antes, no en el momento. Esta es la rara dificultad de presentar que no tiene nada que ver con el valor: una diapositiva que lleva tus notas te obliga a leer, y una diapositiva que lleva un solo punto te deja hablar. No puedes leer en voz alta una diapositiva que no tiene nada que leer.

**La jugada:** un punto por diapositiva, y las frases en tu boca.

Una diapositiva es un titular y, como mucho, la prueba que lo respalda. Seis palabras y un número es una buena diapositiva. Si una frase que hay en ella es una frase que piensas decir, bórrala, porque vas a acabar diciéndola peor mientras todo el mundo la lee más rápido de lo que puedes hablar.

Lo que de verdad quieres tener en la mano no es la diapositiva. Son notas: una página impresa, una tarjeta, la vista de presentador, con tus puntos en el orden que quieras. A nadie le importan las notas. A todo el mundo le importa que le lean.

Hay un segundo motivo por el que esto importa más de lo que parece. Leer en voz alta te hace sonar como otra persona: más plano, más rápido, y raramente formal, y la sala lo oye de inmediato sin saber por qué. Hablar desde un punto que tienes en la cabeza suena a ti, y sonar a ti es casi todo lo que la gente quiere decir cuando dice que alguien presenta bien.

Y la diapositiva casi vacía tiene un efecto inesperado sobre los nervios: sin nada que leer, levantas la vista, y levantar la vista te consigue las reacciones que te dicen cómo va la cosa.

Si te quedas con una cosa: si está escrito en la diapositiva, no lo digas. Pon el punto ahí arriba y quédate con las frases.$md$,
  $j$[
    {
      "situation": "Tu diapositiva tiene cuatro frases completas.",
      "line": "(córtala al titular y un número)",
      "why": "Una frase que piensas decir no debería estar en la diapositiva: todo el mundo la lee más rápido de lo que puedes hablar, y acabas diciéndola peor."
    },
    {
      "situation": "Quieres algo a lo que agarrarte.",
      "line": "(lleva notas, no la diapositiva)",
      "why": "A nadie le importan las notas. A todo el mundo le importa que le lean, y la diapositiva es el peor teleprompter posible."
    },
    {
      "situation": "Estás leyendo y suena plano incluso para ti.",
      "line": "(eso es leer, no los nervios)",
      "why": "Leer en voz alta hace que cualquiera suene más plano, más rápido y raramente formal, y una sala lo oye al instante sin saber por qué."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué lee la gente sus diapositivas?",
      "options": [
        { "text": "Pereza: no se prepararon.", "correct": false, "note": "Con frecuencia se sobreprepararon, que es cómo acabaron todas esas palabras en la diapositiva de entrada." },
        { "text": "La diapositiva es lo único que no puede olvidar qué viene después.", "correct": true, "note": "Ponerte de pie delante de compañeros te hace querer algo a lo que agarrarte, y la diapositiva está ahí mismo. Por eso el arreglo es el día antes." },
        { "text": "Creen que el público quiere el detalle.", "correct": false, "note": "A veces es por eso que el detalle está ahí, y no es el motivo por el que se acaba leyendo en voz alta." },
        { "text": "Los nervios.", "correct": false, "note": "Los nervios son por qué quieres algo a lo que agarrarte. Que la diapositiva sirva como notas es lo que lo hace posible." }
      ],
      "explain": "No puedes leer en voz alta una diapositiva que no tiene nada que leer. Arréglalo el día antes."
    },
    {
      "prompt": "¿Qué debería llevar la diapositiva?",
      "options": [
        { "text": "Lo suficiente para que tenga sentido sola después.", "correct": false, "note": "Una necesidad real, y quiere un documento aparte. Construir un solo objeto para dos trabajos es lo que produce el muro de texto." },
        { "text": "Lo que te costaría recordar.", "correct": false, "note": "Eso son exactamente las notas, y poner las notas en la pared es todo el problema." },
        { "text": "El titular, y como mucho la prueba que lo respalda.", "correct": true, "note": "Seis palabras y un número es una buena diapositiva. Si una frase que hay en ella es una que piensas decir, bórrala." },
        { "text": "Lo mínimo posible: idealmente una imagen.", "correct": false, "note": "Pasarse de corrección hacia una charla de escenario. Un punto que la gente puede leer en dos segundos está haciendo trabajo útil." }
      ],
      "explain": "El punto en la diapositiva, las frases en tu boca, el detalle en un documento."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_point", "label": "Un punto por diapositiva", "description": "Puso el titular en vez del guion." },
      { "key": "notes", "label": "Llevó notas, no el mazo", "description": "Mantuvo algo que mirar que no estuviera en la pared." },
      { "key": "not_reading", "label": "No lo leyó en voz alta", "description": "Dijo las frases en vez de la diapositiva." },
      { "key": "looked_up", "label": "Levantó la vista", "description": "Gastó el tiempo en la sala y no en la pantalla." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una compañera a la que le has pedido que mire el mazo de diapositivas",
      "mood": "Encantada de ayudar, con diez minutos libres.",
      "openness": 5,
      "personality": "Directa y útil. Te lee cada diapositiva en voz alta de vuelta para demostrar el punto, y te pregunta qué pensabas decir encima."
    },
    "setting": "La tarde antes de una actualización de diez minutos para el equipo más amplio. Tu mazo tiene once diapositivas y la mayoría son párrafos.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Lee en voz alta cualquier frase completa de una diapositiva, sin entonación, para demostrar el problema.",
      "Aprueba una diapositiva reducida a un titular y una prueba.",
      "Nunca reescribas tú una diapositiva para la persona."
    ],
    "opening_beat": "«Vale, diapositiva uno. ¿La leo yo, o la vas a decir tú? Porque no pueden ser las dos cosas.»",
    "success_looks_like": "La persona corta la diapositiva a un punto y se queda con las frases para sí misma."
  }$j$::jsonb,
  'Hoy, coge una diapositiva y córtala a un titular. Apunta qué tenía antes y qué tiene después.',
  $j${
    "beats": [
      {
        "situation": "La diapositiva cuatro dice: «Tras la revisión del segundo trimestre identificamos tres áreas de bajo rendimiento en el proceso de informes, que hemos abordado mediante una combinación de automatización y cambio de proceso».",
        "prompt": "¿Qué haces con ella?",
        "options": [
          { "text": "Dejarla: es exacta y tiene sentido sola más tarde.", "correct": false, "note": "Dos trabajos, un solo objeto. Algo que se lee bien después quiere ser un documento; esta garantiza que la leas en voz alta." },
          { "text": "Cortarla a «Informes: tres arreglos» y decir el resto.", "correct": true, "note": "Seis palabras y el punto. No puedes leer en voz alta una diapositiva que no tiene nada que leer, y ahora las frases son tuyas." },
          { "text": "Repartirla en tres diapositivas.", "correct": false, "note": "Tres diapositivas de párrafo en vez de una. La longitud era el síntoma; las frases son el problema." },
          { "text": "Encoger el texto para que quepa mejor.", "correct": false, "note": "Ahora es ilegible y sigue estando ahí, que es lo peor de las dos cosas." }
        ]
      },
      {
        "situation": "Quieres algo a lo que agarrarte mientras hablas.",
        "prompt": "¿Qué llevas?",
        "options": [
          { "text": "Las diapositivas: para eso están.", "correct": false, "note": "Es lo que hace que la gente las lea. La diapositiva es el peor teleprompter posible porque todos los demás también la pueden ver." },
          { "text": "Nada: las notas parecen falta de preparación.", "correct": false, "note": "A nadie le importan las notas. A todo el mundo le importa que le lean, e ir sin nada produce la entrega plana y rápida que intentabas evitar." },
          { "text": "Un guion completo, para que no pueda salir nada mal.", "correct": false, "note": "Un guion se lee, y leer en voz alta hace que cualquiera suene más plano y raramente formal." },
          { "text": "Una tarjeta o página impresa con tus puntos en orden.", "correct": true, "note": "Lo que de verdad quieres tener en la mano no está en la pared. Puntos, en orden, en tu mano." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('presenting', 2,
  'Di la conclusión primero',
  $md$Todo lo que has absorbido sobre construir hacia una conclusión es correcto para una historia y equivocado para una reunión de trabajo.

Un público de negocios está decidiendo si sigue escuchando en unos quince segundos, y no lo decide por interés: decide si esto le es relevante. Si no puede saber hacia dónde va, el medio se gasta adivinando en vez de siguiendo, y la gente que más necesitabas ha abierto en silencio otra cosa.

**La jugada:** responde primero, y luego enseña por qué.

*Deberíamos mover el lanzamiento a marzo. Tres motivos.* Todo lo que viene después de esa frase es más fácil de seguir, porque todo el mundo sabe ya qué está escuchando. Además sobrevive a lo que de verdad les pasa a las presentaciones: que las corten. Si te dan ocho minutos en vez de diez, una charla que responde primero ya ha aterrizado y una que construye no.

Se siente mal la primera vez. Regalar la conclusión parece quitar el motivo para escuchar, y hace justo lo contrario, porque la gente no se queda por una revelación, se queda para averiguar si está de acuerdo.

Además te protege del fallo más común: quedarte sin tiempo antes de llegar al punto. Todos hemos visto a alguien entregar nueve minutos de contexto cuidadoso y luego decir *así que, rápido, la recomendación es*, con las prisas encima.

Dilo en una frase con un número pegado si puedes. *Deberíamos pasar a marzo. Tres motivos* le da a la gente una forma que sostener, y una forma es lo que hace que el medio se sienta corto.

Si la noticia es mala, esto se sostiene más. Una mala noticia enterrada al final se lee como un intento de esconderla, y todo el mundo en la sala ha visto ya esa estructura.

Si te quedas con una cosa: la primera frase es la conclusión. Todo lo demás es el argumento para ella.$md$,
  $j$[
    {
      "situation": "Estás a diez minutos de presentar una recomendación.",
      "line": "Deberíamos mover el lanzamiento a marzo. Tres motivos.",
      "why": "Todo el mundo sabe ya qué está escuchando, y si te cortan a ocho minutos el punto ya ha aterrizado."
    },
    {
      "situation": "Quieres construir hacia ello para que la lógica aterrice.",
      "line": "(no se quedan por una revelación)",
      "why": "La gente se queda para averiguar si está de acuerdo. Sin la conclusión, el medio se gasta adivinando hacia dónde va esto."
    },
    {
      "situation": "La noticia es mala.",
      "line": "(entonces dila primero, con más fuerza)",
      "why": "Una mala noticia al final se lee como un intento de esconderla, y todo el mundo en la sala ha visto ya esa estructura."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué falla en el trabajo construir hacia una conclusión?",
      "options": [
        { "text": "Los públicos de negocios son impacientes.", "correct": false, "note": "Están atentos a la relevancia más que impacientes, y esa es una descripción más útil." },
        { "text": "Es una técnica narrativa, no una de trabajo.", "correct": false, "note": "Cierto como etiqueta, y no dice qué es lo que sale mal en realidad." },
        { "text": "Sin la conclusión, el medio se gasta adivinando.", "correct": true, "note": "La gente decide en quince segundos si esto le es relevante. Si no sabe hacia dónde va, la que más necesitabas ha abierto otra cosa." },
        { "text": "La gente deja de escuchar después de un minuto.", "correct": false, "note": "Escuchan mucho tiempo algo que pueden seguir. Es el seguir lo que está en juego." }
      ],
      "explain": "Responde primero, y luego enseña por qué. Así todo el mundo sabe qué está escuchando."
    },
    {
      "prompt": "¿De qué te protege responder primero?",
      "options": [
        { "text": "De que te interrumpan.", "correct": false, "note": "Puede que te interrumpan más, y ahora las interrupciones son sobre el punto y no sobre hacia dónde va esto." },
        { "text": "De equivocarte en el argumento.", "correct": false, "note": "No arregla un argumento débil. Hace que uno bueno sea más fácil de seguir." },
        { "text": "De sonar nervioso.", "correct": false, "note": "Un efecto secundario. La estructura ayuda y no es lo que esto te compra." },
        { "text": "De quedarte sin tiempo antes del punto.", "correct": true, "note": "Nueve minutos de contexto cuidadoso y luego «así que, rápido, la recomendación es», con las prisas encima. Todo el mundo lo ha visto pasar." }
      ],
      "explain": "Las presentaciones se cortan. Una que responde primero ya ha aterrizado."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "point_first", "label": "Empezó por la conclusión", "description": "Dijo la respuesta en la primera frase." },
      { "key": "shape", "label": "Le dio una forma", "description": "Señaló cuántos motivos o qué viene después." },
      { "key": "short", "label": "Mantuvo corta la apertura", "description": "Una frase, no un párrafo de encuadre." },
      { "key": "no_burying", "label": "No enterró la mala noticia", "description": "Puso la parte difícil por delante." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nadine",
      "role": "la persona más sénior de la sala",
      "mood": "Con tres reuniones de retraso.",
      "openness": 4,
      "personality": "Decide en unos quince segundos si sigue escuchando, y lo dice. Se mete en serio en cuanto sabe la recomendación."
    },
    "setting": "Una reunión con partes implicadas. Tienes diez minutos para recomendar mover el lanzamiento a marzo, y la sala espera enero.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta hacia dónde va esto si los primeros treinta segundos son contexto.",
      "Métete en serio con el razonamiento en cuanto se haya enunciado la recomendación.",
      "Corta la reunión a los ocho minutos, hayas llegado a donde hayas llegado."
    ],
    "opening_beat": "«Tienes diez minutos, aunque en la práctica ocho. Adelante.»",
    "success_looks_like": "La persona abre con la recomendación en vez de con el contexto."
  }$j$::jsonb,
  'Hoy, abre una actualización o un mensaje con la conclusión en vez de con el contexto. Apunta tu primera frase.',
  $j${
    "says": "Tienes diez minutos, aunque en la práctica ocho. Adelante.",
    "model": {
      "line": "Deberíamos mover el lanzamiento a marzo. Tres motivos, y el tercero es el caro.",
      "why": "La conclusión en la primera frase con una forma pegada, así que todo el mundo sabe qué está escuchando. Si te cortan a ocho minutos, el punto ya ha aterrizado."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["gracias por", "antes de empezar", "un poco de contexto", "para situarnos", "como sabéis", "un repaso rápido", "déjame empezar", "primero quiero"], "requirement": "Sin calentamiento: la primera frase es la conclusión" },
      { "kind": "max_sentences", "n": 2, "requirement": "Dos frases como mucho" },
      { "kind": "max_words", "n": 30, "requirement": "Lo bastante corto como para ser el titular" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('presenting', 3,
  'Una persona cada vez',
  $md$El consejo de *barrer la sala con la mirada* produce ese repaso vacío que todo el mundo reconoce como nervios. Parece alguien buscando una salida, porque es más o menos lo que es.

**La jugada:** quédate en una persona durante una frase entera, y luego pasa a otra.

Desde el lado del público, esto es la diferencia entre que te presenten algo y que te hablen. Alguien que se lleva una frase contigo ha tenido un momento de conversación, y una sala donde seis personas han tenido ese momento se siente completamente distinta para todo el mundo dentro, incluidos los que no lo tuvieron.

Desde tu lado es mucho más fácil, que es la parte que nadie menciona. Decirle una frase a una persona es algo que has hecho diez mil veces. Dirigirte a cuarenta personas no es algo que haya hecho nadie, y intentarlo es lo que hace que tu voz se vuelva rara.

Elige a gente que ya te esté dando algo. En cualquier sala unas cuantas personas asienten, y volver a ellas no es hacer trampa: es usar la retroalimentación que se te está ofreciendo. Eso sí, evita aparcarte en una sola cara amable durante toda la charla, que se convierte en una conversación privada con público.

La persona sénior de la tercera fila merece una nota aparte, porque ahí es donde apuntan casi todos los nervios. Dale una frase, igual que a todos los demás. Lo que no debes hacer es entregarle la charla entera: el resto de la sala lo nota de inmediato, y le dice a todos a quién crees que le importa esto de verdad.

Y si mirar caras es genuinamente demasiado, mira frentes, o el espacio justo al lado de alguien. Desde metro y medio es indistinguible, y es muchísimo mejor que el suelo o la pantalla.

Si te quedas con una cosa: una frase, una persona. Es más pequeño que presentar y es de lo que está hecho presentar.$md$,
  $j$[
    {
      "situation": "Estás a punto de barrer la sala con la mirada mientras hablas.",
      "line": "(ese es el repaso vacío que todo el mundo lee como nervios)",
      "why": "Parece alguien buscando una salida. Quedarte en una persona durante una frase es a lo que se parece que te hablen."
    },
    {
      "situation": "Tres personas están asintiendo.",
      "line": "(vuelve a ellas: es retroalimentación que se te está ofreciendo)",
      "why": "Usar a la gente que te está dando algo no es hacer trampa. Solo que no te aparques en una sola cara durante toda la charla."
    },
    {
      "situation": "Las caras son demasiado hoy.",
      "line": "(frentes, o justo al lado de alguien)",
      "why": "Desde metro y medio es indistinguible, y es muchísimo mejor que el suelo o la pantalla."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué es más fácil una frase a una persona?",
      "options": [
        { "text": "Porque es algo que has hecho diez mil veces.", "correct": true, "note": "Dirigirte a cuarenta personas no es algo que haya hecho nadie nunca, e intentarlo es lo que hace que tu voz se vuelva rara." },
        { "text": "Porque puedes ignorar al resto de la sala.", "correct": false, "note": "No los estás ignorando: los estás alcanzando de uno en uno, y todos lo notan." },
        { "text": "Porque te frena.", "correct": false, "note": "Lo hace, útilmente, y eso es un subproducto y no el motivo por el que es más fácil." },
        { "text": "Porque se espera contacto visual.", "correct": false, "note": "La expectativa no es lo que lo hace manejable. Lo es la familiaridad del acto." }
      ],
      "explain": "Presentar no es una habilidad aparte. Es una frase a una persona, repetida."
    },
    {
      "prompt": "La persona sénior está en la tercera fila. ¿Qué le toca?",
      "options": [
        { "text": "Casi toda tu atención: es la decisión.", "correct": false, "note": "La sala lo nota de inmediato, y le dice a todos los demás a quién crees que le importa esto aquí." },
        { "text": "Ninguna, para no descolocarte.", "correct": false, "note": "Llamativo, y se lee como evitación en vez de como aplomo." },
        { "text": "Una frase, igual que a todos los demás.", "correct": true, "note": "Es una persona más de la sala. Tratarla como la sala es lo que cambia cómo sonabas." },
        { "text": "La apertura y el cierre.", "correct": false, "note": "Una regla que la mantiene como el público y a todos los demás como mobiliario." }
      ],
      "explain": "Una frase cada uno. Nadie es la sala."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_at_a_time", "label": "Una persona por frase", "description": "Se quedó en vez de barrer." },
      { "key": "spread", "label": "Se movió", "description": "No se aparcó en una sola cara amable." },
      { "key": "senior_normal", "label": "Trató a la persona sénior con normalidad", "description": "Le dio una frase en vez de la charla entera." },
      { "key": "up", "label": "Se mantuvo fuera de la pantalla", "description": "Miró a la gente en vez de a las diapositivas o al suelo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una compañera en la segunda fila",
      "mood": "Metida y de tu lado.",
      "openness": 5,
      "personality": "Da retroalimentación visible: asiente, frunce el ceño, levanta la vista, y describe con llaneza las reacciones de la sala cuando no se le pregunta nada."
    },
    "setting": "Diez minutos delante de unos veinte compañeros. La jefa de tu jefe está en la tercera fila y eres consciente de ello.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Describe las reacciones visibles de la sala como parte de tus respuestas.",
      "Responde con calidez cuando se le hable directamente durante una frase entera.",
      "Informa de que la sala se apaga si la persona solo habla con quien es sénior o solo con la pantalla."
    ],
    "opening_beat": "La sala se asienta. Unas veinte caras, y todavía no has empezado.",
    "success_looks_like": "La persona lo lleva de una en una en vez de barrer o fijarse en alguien."
  }$j$::jsonb,
  'Hoy, en una reunión, dale una frase entera a una persona antes de pasar a la siguiente. Apunta qué notaste.',
  $j${
    "beats": [
      {
        "situation": "Llevas dos minutos, delante de veinte personas. La jefa de tu jefe está en la tercera fila.",
        "prompt": "¿Dónde tienes los ojos?",
        "options": [
          { "text": "Barriendo la sala para que todos se sientan incluidos.", "correct": false, "note": "El repaso vacío, y se lee como alguien buscando una salida. Nadie se siente incluido por que le barran." },
          { "text": "En una persona durante una frase entera, y luego en otra.", "correct": true, "note": "A eso se parece que te hablen, y decirle una frase a una persona es algo que has hecho diez mil veces." },
          { "text": "Sobre todo en la persona sénior, ya que decide ella.", "correct": false, "note": "La sala lo nota de inmediato, y le dice a todos los demás a quién crees que le importa esto aquí." },
          { "text": "En la pantalla, para comprobar que vas bien.", "correct": false, "note": "Ahora estás leyendo, y la sala ha perdido a quien le estaba hablando." }
        ]
      },
      {
        "situation": "Mirar caras es genuinamente demasiado hoy.",
        "prompt": "¿Qué haces en su lugar?",
        "options": [
          { "text": "El suelo, entre miradas hacia arriba.", "correct": false, "note": "La única dirección que se lee sin lugar a dudas como angustia, y se lleva la voz con ella." },
          { "text": "La pared del fondo, por encima de las cabezas de todos.", "correct": false, "note": "Visible desde las dos primeras filas como hablar con nadie, y aplana todo." },
          { "text": "Las frentes, o el espacio justo al lado de alguien.", "correct": true, "note": "Indistinguible desde metro y medio, y muchísimo mejor que el suelo o la pantalla. Úsalo y sigue." },
          { "text": "Las diapositivas, ya que es ahí donde están mirando.", "correct": false, "note": "Están mirando ahí porque dejaste de darles algo mejor que mirar." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('presenting', 4,
  'La pausa dura menos de lo que parece',
  $md$Van a pasar dos silencios y los dos se sienten desde dentro como si la cosa se hubiera venido abajo. Ninguno de los dos se ve desde fuera como otra cosa que aplomo.

El primero es perder el hilo. Paras, miras tus notas, y el tiempo parece pararse contigo. Desde la sala son unos dos segundos y se lee como alguien comprobando algo, que es exactamente lo que es. Lo que lo convierte en un problema es el comentario: *perdón, ¿por dónde iba, un momento.* Nadie había notado ningún problema, y tú acabas de anunciar uno.

**La jugada:** encuentra tu sitio, y arranca de nuevo desde una palabra en vez de desde una disculpa.

El segundo silencio es el deliberado, después de terminar una sección o aterrizar la frase importante. Este tienes que crearlo a propósito, porque todos los instintos dicen que lo rellenes. Déjalo y el punto se queda ahí un segundo, que es como funciona el énfasis de verdad. Rellénalo y has tapado tu mejor frase con un *bueno, sí, eso es lo principal en realidad*.

Correr es la versión general del mismo problema, y merece la pena saber que siempre vas a ir más rápido de lo que crees. Los nervios comprimen el habla, y la corrección no es hablar despacio, que produce algo raro y forzado, sino parar en los puntos. Los puntos son donde la sala te alcanza.

Y luego está el desplome que no es ningún desplome: dices algo mal, o en el orden equivocado, y te corriges. *Perdón, al revés* es completamente normal y todo el mundo lo hace en una conversación corriente sin darse ni cuenta. Lo que no es normal es tratarlo como una herida y disculparse dos veces.

Si te quedas con una cosa: una pausa es alguien pensando. Nadie de la sala la está cronometrando, y siempre dura menos que la versión de tu cabeza.$md$,
  $j$[
    {
      "situation": "Has perdido el hilo y estás mirando tus notas.",
      "line": "(encuéntralo, y arranca desde una palabra)",
      "why": "Desde la sala son unos dos segundos y se lee como alguien comprobando algo. El comentario es lo que lo convierte en un problema."
    },
    {
      "situation": "Acabas de aterrizar la frase importante.",
      "line": "(deja el hueco a propósito)",
      "why": "El punto se queda ahí un segundo, que es como funciona el énfasis. Rellenarlo tapa tu propia mejor frase."
    },
    {
      "situation": "Has dicho dos cosas en el orden equivocado.",
      "line": "Perdón, al revés.",
      "why": "Completamente normal, y todo el mundo lo hace en una conversación corriente sin darse cuenta. Lo que no es normal es disculparse por ello dos veces."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Pierdes el hilo. ¿Cuál es el error?",
      "options": [
        { "text": "Mirar tus notas.", "correct": false, "note": "Ese es el arreglo. Las notas existen precisamente para esto y a nadie le importa." },
        { "text": "Anunciarlo.", "correct": true, "note": "Perdón, ¿por dónde iba, un momento. Nadie había notado ningún problema hasta que nombraste uno; la pausa en sí se lee como alguien comprobando algo." },
        { "text": "Pausar en absoluto.", "correct": false, "note": "La pausa dura unos dos segundos y se lee como aplomo. No es lo que te cuesta nada." },
        { "text": "Seguir sin el punto que perdiste.", "correct": false, "note": "A menudo la decisión correcta, y la sala nunca va a saber que faltaba." }
      ],
      "explain": "Encuéntralo, arranca desde una palabra, y no digas nada al respecto."
    },
    {
      "prompt": "¿Por qué dejar un silencio después de tu mejor frase?",
      "options": [
        { "text": "Le da tiempo a la gente para apuntarlo.", "correct": false, "note": "Un beneficio menor, y pasa hagas o no la pausa." },
        { "text": "Te hace parecer seguro.", "correct": false, "note": "Cómo parece en vez de lo que hace. El mecanismo va sobre la frase, no sobre ti." },
        { "text": "Es como funciona el énfasis.", "correct": true, "note": "El punto se queda ahí un segundo. Rellénalo y has tapado tu propia mejor frase con «bueno, sí, eso es lo principal en realidad»." },
        { "text": "Invita a preguntas.", "correct": false, "note": "Una pausa corta no lo hace, y si lo hiciera sería un motivo para que alguna gente la evitara." }
      ],
      "explain": "Para en los puntos. Ahí es donde te alcanza la sala."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_commentary", "label": "No narró el tropiezo", "description": "Encontró el sitio y siguió sin anunciarlo." },
      { "key": "deliberate_pause", "label": "Dejó una pausa a propósito", "description": "Dejó que la frase importante se quedara ahí." },
      { "key": "full_stops", "label": "Paró en los puntos", "description": "Dejó que la sala le alcanzara en vez de seguir corriendo." },
      { "key": "one_correction", "label": "Corrigió una vez", "description": "Arregló un desliz con llaneza sin disculparse dos veces." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una compañera en la segunda fila",
      "mood": "Del todo tranquila con la pausa.",
      "openness": 5,
      "personality": "Informa de lo que la sala está haciendo de verdad, que sobre todo es esperar con paciencia y mirar sus propias notas."
    },
    "setting": "Cuatro minutos de tus diez. Acabas de perder el hilo por completo y estás mirando hacia abajo, a tus notas.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Describe la sala como tranquila y no molesta por las pausas.",
      "Informa de un pequeño revuelo de atención solo cuando la persona anuncie o se disculpe por el tropiezo.",
      "Nunca tranquilices a la persona directamente."
    ],
    "opening_beat": "Silencio. Nadie se ha movido. Han pasado unos dos segundos.",
    "success_looks_like": "La persona retoma sin disculparse ni narrar el tropiezo."
  }$j$::jsonb,
  'Hoy, deja un silencio deliberado después de algo que hayas dicho, y no lo rellenes. Apunta dónde lo dejaste.',
  $j${
    "says": "(has perdido el hilo por completo. Cuatro minutos dentro, veinte personas, unos dos segundos de silencio hasta ahora)",
    "model": {
      "line": "La segunda cosa es el coste del retraso.",
      "why": "Arranca desde una palabra en vez de desde una disculpa. Nadie había notado ningún problema: la pausa se leyó como alguien comprobando algo, que es exactamente lo que era."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["perdón", "perdona", "por dónde iba", "he perdido", "un momento", "dadme un segundo", "disculpas", "me he adelantado", "nervioso"], "requirement": "No anuncies el tropiezo" },
      { "kind": "min_words", "n": 5, "requirement": "Arranca desde una palabra, no desde un ruido" },
      { "kind": "max_words", "n": 25, "requirement": "Simplemente retómalo" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('presenting', 5,
  'La pregunta que no sabes responder',
  $md$Va a pasar y no es un fracaso, y saber qué decir hace que el resto de la charla dé menos miedo, porque casi todos los nervios de presentar son en realidad nervios sobre este momento.

**La jugada:** di que no lo sabes, di cuándo vas a volver, y vuelve.

*No lo sé; lo averiguo y te lo digo hoy.* Esa es una respuesta completa y profesional. Es lo que dice la gente sénior, de forma rutinaria, sin ningún drama, y el motivo por el que funciona es que se puede comprobar: o vuelves o no vuelves, y volver es fácil.

Improvisar es la única versión de este momento que de verdad te hace daño. Una invención que suena plausible se apunta, se actúa sobre ella, y se descubre después, y lo que todo el mundo recuerda no es que no lo supieras, es que dijiste algo que no era verdad. A nadie de la sala le importa un hueco. A todo el mundo le importa que le engañen, aunque sea sin querer.

Otras tres respuestas completas. *No tengo ese número delante, pero está en el orden de X* es honesto y útil, siempre que el orden sea real. *Buena pregunta, y esa en realidad es para Priya* está bien cuando es verdad y no cuando es un pase lateral. Y *cuéntame más de qué estás buscando* es una aclaración genuina, no una manera de ganar tiempo, cuando de verdad no sabes qué te están preguntando.

Y luego está la pregunta que no es una pregunta. A veces alguien te está haciendo un argumento en vez de preguntarte, y la respuesta no es información: *es justo, ¿lo vemos después?* lo saca de la sala sin conceder nada y sin una discusión pública para la que no estabas preparado.

Si te quedas con una cosa: no lo sé, lo averiguo, vuelvo hoy. Y luego hazlo, porque volver es lo que hace que la frase valga algo.$md$,
  $j$[
    {
      "situation": "Te piden un número que no tienes.",
      "line": "No lo sé; lo averiguo y te lo digo hoy.",
      "why": "Completa, profesional y comprobable. Es lo que dice la gente sénior de forma rutinaria y sin ningún drama."
    },
    {
      "situation": "Probablemente podrías adivinarlo con suficiente aproximación.",
      "line": "(una suposición se apunta y se actúa sobre ella)",
      "why": "Lo que se recuerda no es que no lo supieras, es que dijiste algo que no era verdad. A nadie le importa un hueco; a todo el mundo le importa que le engañen."
    },
    {
      "situation": "Alguien te está haciendo un argumento en vez de preguntarte.",
      "line": "Es justo, ¿lo vemos después?",
      "why": "Lo saca de la sala sin conceder nada, y evita una discusión pública para la que no tuviste tiempo de prepararte."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué improvisar es la opción que hace daño?",
      "options": [
        { "text": "La gente nota que estás adivinando.", "correct": false, "note": "A menudo no lo nota, que es exactamente lo que lo hace peligroso." },
        { "text": "Hace que parezcas poco preparado.", "correct": false, "note": "Decir que no lo sabes parece menos preparado en el momento y cuesta menos el viernes." },
        { "text": "Una invención plausible se apunta y se actúa sobre ella.", "correct": true, "note": "Y se descubre después, y lo que se recuerda no es el hueco sino lo que no era verdad. A nadie le importa un hueco." },
        { "text": "Te van a hacer una repregunta.", "correct": false, "note": "Un riesgo práctico más que el motivo por el que te cuesta." }
      ],
      "explain": "No lo sé, lo averiguo, vuelvo hoy. Y luego vuelve."
    },
    {
      "prompt": "Alguien te está haciendo un argumento en vez de una pregunta.",
      "options": [
        { "text": "Responderlo como si fuera una pregunta.", "correct": false, "note": "No tiene respuesta, así que esto se convierte en un debate delante de un público y sin preparación por tu parte." },
        { "text": "Reconocerlo y sacarlo de la sala.", "correct": true, "note": "«Es justo, ¿lo vemos después?» no concede nada y rechaza una discusión pública que no elegiste." },
        { "text": "Discrepar con claridad, para que la sala sepa dónde estás.", "correct": false, "note": "A veces necesario y normalmente caro. La sala no vino para esto." },
        { "text": "No decir nada y seguir adelante.", "correct": false, "note": "Se lee como no poder con ello, y deja el argumento en pie sin respuesta." }
      ],
      "explain": "No toda pregunta es una pregunta. Algunas son una postura, y las posturas van fuera de la sala."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_dont_know", "label": "Dijo que no lo sabía", "description": "No improvisó una respuesta." },
      { "key": "committed", "label": "Nombró cuándo volvería", "description": "Le pegó una hora." },
      { "key": "no_bluffing", "label": "No dio ningún detalle inventado", "description": "Mantuvo honestos los números y las concreciones." },
      { "key": "handled_the_point", "label": "Trató un argumento como un argumento", "description": "Sacó una postura de la sala en vez de debatirla." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nadine",
      "role": "la persona más sénior de la sala",
      "mood": "Interesada, directa.",
      "openness": 4,
      "personality": "Queda del todo satisfecha con «te lo digo hoy» y repregunta con fuerza ante cualquier cosa que suene improvisada. Tiene además un argumento que quiere hacer más que una pregunta."
    },
    "setting": "El final de tus diez minutos. Preguntas. Alguien sénior te pide una cifra que genuinamente no tienes.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Acepta sin comentarios un «no lo sé, te lo digo hoy» y sigue adelante.",
      "Repregunta con fuerza ante cualquier cifra que suene improvisada, preguntando de dónde salió.",
      "Después de la primera pregunta, haz un argumento en vez de preguntar, sobre que el calendario es optimista."
    ],
    "opening_beat": "«¿Cuál es el coste real del retraso? A grandes rasgos.»",
    "success_looks_like": "La persona se niega a adivinar y se compromete a volver."
  }$j$::jsonb,
  'Hoy, di «no lo sé» y nombra cuándo vas a volver. Luego vuelve. Apunta la pregunta y si lo hiciste.',
  NULL
);
