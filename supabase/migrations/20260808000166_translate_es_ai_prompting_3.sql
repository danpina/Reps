-- Spanish: Escribir prompts a la IA, track 3 — Edita, no escribas.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Robin" (lessons 1, 2, 3) — unisex/no-sex-field, masculine
-- default. "Marcus" (lesson 4) unambiguously masculine. "Nadia" (lesson
-- 5) — established feminine exception from track 1.

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

select pg_temp.es_lesson('edit-do-not-write', 1,
  'Escríbelo mal primero',
  $md$Pídele que escriba tu mensaje y consigues algo competente: cálido, bien organizado, un poco demasiado largo, con tres cumplidos dentro, cada frase de más o menos la misma longitud que la anterior.

El problema no es la calidad. Es que el mensaje no es tuyo, y la gente que te conoce lo nota sin poder decir por qué.

**La jugada:** escribe tú la versión mala, y luego entrégala.

El borrador malo no es un punto de partida tosco que hay que sustituir. Es la única parte del proceso que te contiene a ti — tu orden, tus prioridades, lo que pensaste que merecía la pena decir primero, la frase brusca que no habrías elegido si hubieras estado intentando sonar amable. Todo lo que viene después es resta, y la resta no puede convertir tu mensaje en el de otra persona.

Escríbelo rápido y mal a propósito. No te pares a arreglar nada. La ortografía no importa, el orden no importa, y la frase demasiado directa es exactamente la que hay que dejar dentro — puedes decidir después si suavizarla, y no puedes recuperarla si nunca se escribió.

Lo que esto también hace, calladamente, es detener el problema del cuadro en blanco. Mucha gente recurre a la ayuda justo en el punto en que no sabe cómo empezar, y ese es el peor momento posible para entregarlo, porque no hay nada tuyo con lo que trabajar. Dos frases malas cambian todo el intercambio de *escríbeme algo* a *arréglame esto*.

Y protege lo que de verdad te preocupa. Si el borrador es tuyo, el peor resultado de la edición es una versión ligeramente más ordenada de ti. Si el borrador no es tuyo, el mejor resultado es un mensaje bien escrito que no viene de nadie.

Si te quedas con una cosa: escribe dos frases malas primero. Son lo que hace que todo lo de después sea tuyo.$md$,
  $j$[
    {
      "situation": "El cuadro está en blanco y no sabes cómo empezar.",
      "line": "(escribe dos frases malas de todos modos)",
      "why": "Entregar un cuadro vacío le pide que escriba. Entregar dos frases malas le pide que arregle."
    },
    {
      "situation": "Sale una frase demasiado directa.",
      "line": "(déjala dentro)",
      "why": "Puedes suavizarla después. No puedes recuperarla si nunca se escribió."
    },
    {
      "situation": "Quieres ordenar el borrador antes de enviarlo.",
      "line": "(no lo hagas — envíalo desordenado)",
      "why": "Ordenar es donde se eliminan tu orden y tu brusquedad, que eran las partes que merecía la pena conservar."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué importa tanto el borrador malo?",
      "options": [
        { "text": "Ahorra tiempo en general.", "correct": false, "note": "A menudo no lo hace, y la velocidad nunca fue el argumento." },
        { "text": "Demuestra que lo intentaste.", "correct": false, "note": "Nadie ve el borrador. Esto no trata de que el esfuerzo sea visible." },
        { "text": "Es la única parte que te contiene a ti.", "correct": true, "note": "Tu orden, tus prioridades, tu frase brusca. Todo lo que viene después es resta, y la resta no puede convertirlo en el de otra persona." },
        { "text": "Le da más contexto.", "correct": false, "note": "Parcialmente cierto y sería igual de cierto de una descripción, que no funciona." }
      ],
      "explain": "Escribe dos frases malas antes de entregar nada."
    },
    {
      "prompt": "¿Cuándo es peor entregarlo?",
      "options": [
        { "text": "Cuando tienes prisa.", "correct": false, "note": "La prisa es un motivo para usarlo, no un motivo por el que falla." },
        { "text": "Cuando el mensaje es importante.", "correct": false, "note": "Los mensajes importantes son exactamente donde una buena edición más ayuda." },
        { "text": "Cuando ya tienes una versión.", "correct": false, "note": "Ese es el mejor momento, no el peor." },
        { "text": "Cuando el cuadro sigue en blanco.", "correct": true, "note": "No hay nada tuyo con lo que trabajar, así que escríbeme algo es la única petición disponible." }
      ],
      "explain": "El peor resultado de editar tu borrador es un tú más ordenado."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "drafted", "label": "Lo escribió primero", "description": "Produjo una versión antes de preguntar." },
      { "key": "fast", "label": "Lo escribió mal", "description": "No se paró a arreglar cosas." },
      { "key": "kept_blunt", "label": "Dejó la frase brusca dentro", "description": "No la suavizó de antemano." },
      { "key": "not_blank", "label": "Nunca entregó un cuadro en blanco", "description": "Pidió un arreglo, no un mensaje." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "un amigo sentado contigo",
      "mood": "Sin prisa.",
      "openness": 5,
      "personality": "Pregunta qué dirías si tuvieras que enviar algo en los próximos treinta segundos."
    },
    "setting": "Llevas diez minutos mirando fijamente un cuadro de mensaje vacío y acabas de abrir un chat en su lugar.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pide la versión de treinta segundos.",
      "Acepta algo torpe como respuesta completa.",
      "Nunca ofrezcas tu propia redacción."
    ],
    "opening_beat": "«Si tuvieras que enviarlo ahora mismo, ¿qué diría?»",
    "success_looks_like": "La persona produce una versión propia y tosca en vez de pedir una."
  }$j$::jsonb,
  'Hoy, escribe tú la versión mala antes de pedir ayuda con ella. Apunta ambas.',
  $j${
    "says": "Si tuvieras que enviarlo ahora mismo, ¿qué diría?",
    "model": {
      "line": "Algo como: no puedo el miércoles, el viernes me va bien, perdona el desorden. Eso es malo pero es lo real.",
      "why": "Dos frases malas cambian la petición de escríbeme algo a arréglame esto, y llevan tu orden y tu brusquedad."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["no sé cómo empezar", "puede escribirlo", "necesito algo", "no tengo ni idea de qué decir", "voy a hacer que"], "requirement": "No pidas que te lo escriban" },
      { "kind": "min_words", "n": 10, "requirement": "Produce una versión tosca real" },
      { "kind": "max_words", "n": 40, "requirement": "Tosco, no pulido" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('edit-do-not-write', 2,
  'Recorta, no mejores',
  $md$*Mejora esto* es la petición que hace casi todo el mundo, y es el verbo equivocado.

Mejorar, para una máquina entrenada con muchísima correspondencia profesional, significa añadir. Consigues una apertura más cálida. Una frase reconociendo lo ocupados que están. Un cierre más suave. Una línea sobre las ganas de saber de ellos. Cada una de esas es una mejora plausible, y juntas producen aquello que Mensajería se pasa cinco lecciones eliminando.

**La jugada:** pide recortes con un número adjunto.

*Recorta esto a la mitad sin perder la petición.* El número es lo que hace que funcione — una instrucción de acortar produce un recorte ligero, y una instrucción de reducir a la mitad obliga a una decisión sobre para qué es realmente el mensaje. Esa decisión es la parte valiosa, y siempre puedes volver a poner algo.

Otras peticiones de la misma familia, todas ellas de resta.

*Elimina cualquier cosa que no sea la petición o su contexto.* Esto es más una prueba que una edición, y es la misma que Storytelling aplica a una historia.

*Quita cada muletilla.* Solo, bastante, quizá, posiblemente, creo, un poco. Luego léelo y vuelve a poner las dos que de verdad servían para algo, porque un pequeño número de ellas son genuinas.

*¿Qué frase se podría eliminar sin que nadie se diera cuenta?* Normalmente hay una, y normalmente es la segunda.

La comprobación después es rápida. Compara las dos versiones y pregúntate qué se perdió. Si la respuesta es *nada*, el recorte fue correcto. Si se fue algo real — un trozo de contexto, la calidez del final, el detalle concreto que lo hacía específico — vuelve a ponerlo a mano en vez de pedir una reescritura, porque una reescritura traerá de vuelta el resto de los muebles.

Si te quedas con una cosa: mejorar añade y recortar quita. Casi todos los mensajes que escribes necesitan lo segundo.$md$,
  $j$[
    {
      "situation": "Tu borrador es demasiado largo.",
      "line": "Recorta esto a la mitad sin perder la petición.",
      "why": "Un número obliga a una decisión sobre para qué es el mensaje. Acortar produce un recorte ligero."
    },
    {
      "situation": "Está lleno de muletillas.",
      "line": "Quita cada muletilla, y luego vuelvo a poner las que de verdad sirven para algo.",
      "why": "La mayoría son el encogimiento del que trata Mensajería, y un pequeño número son genuinas."
    },
    {
      "situation": "Se perdió algo real en el recorte.",
      "line": "(vuelve a ponerlo a mano)",
      "why": "Pedir una reescritura trae de vuelta la apertura cálida y el cierre suave."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué significa realmente mejora esto para ello?",
      "options": [
        { "text": "Hazlo más formal.", "correct": false, "note": "A veces, y la formalidad no es la dirección que hace el daño." },
        { "text": "Añadir — una apertura, un reconocimiento, un cierre suave.", "correct": true, "note": "Cada una es una mejora plausible, y juntas reconstruyen aquello que Mensajería se pasa cinco lecciones eliminando." },
        { "text": "Arreglar la gramática.", "correct": false, "note": "Lo hará, y rara vez era eso lo que estaba mal." },
        { "text": "Reorganizarlo.", "correct": false, "note": "A menudo parte de ello, y reorganizar solo sería inofensivo." }
      ],
      "explain": "Pide recortes, con un número adjunto."
    },
    {
      "prompt": "¿Por qué adjuntar un número al recorte?",
      "options": [
        { "text": "Reducir a la mitad obliga a una decisión sobre el propósito.", "correct": true, "note": "Acortar consigue un recorte ligero. Reducir a la mitad obliga a elegir para qué es el mensaje, y esa decisión es la parte valiosa." },
        { "text": "Hace el resultado predecible.", "correct": false, "note": "Una conveniencia más que el motivo." },
        { "text": "Los mensajes cortos se responden más rápido.", "correct": false, "note": "Cierto, de Mensajería, y es un argumento para recortar más que para el número." },
        { "text": "Evita que discuta contigo.", "correct": false, "note": "No discute mucho de ninguna forma." }
      ],
      "explain": "Luego compara los dos y pregúntate qué se perdió."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "subtractive", "label": "Pidió recortes", "description": "Usó un verbo de eliminar, no mejorar." },
      { "key": "number", "label": "Adjuntó un número", "description": "Mitad, sesenta palabras, dos frases." },
      { "key": "compared", "label": "Comprobó qué se perdió", "description": "Leyó las dos versiones una contra otra." },
      { "key": "by_hand", "label": "Restauró a mano", "description": "No pidió una reescritura." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "un amigo leyéndolo por encima de tu hombro",
      "mood": "Brusco pero amistoso.",
      "openness": 5,
      "personality": "Pregunta para qué es el mensaje y lee en voz alta las frases que no hacen eso."
    },
    "setting": "Tu mensaje ha vuelto más largo y más cálido de lo que entró, y estás bastante contento con él.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Lee en voz alta una frase que no sea la petición ni su contexto.",
      "Pregunta qué se perdería si se fuera.",
      "Nunca reescribas nada tú mismo."
    ],
    "opening_beat": "«¿Para qué es este mensaje? En una frase.»",
    "success_looks_like": "La persona pide un recorte con un número en vez de otra mejora."
  }$j$::jsonb,
  'Hoy, pide que un borrador se reduzca a la mitad en vez de mejorarlo. Apunta qué perdiste y qué volviste a poner.',
  $j${
    "says": "¿Para qué es este mensaje? En una frase.",
    "model": {
      "line": "Para conseguir un sí o un no sobre el viernes. Voy a hacer que lo recorten a la mitad sin perder eso.",
      "why": "Un número obliga a una decisión sobre para qué es el mensaje. Mejorar añade una apertura, un reconocimiento y un cierre suave."
    },
    "checks": [
      { "kind": "contains_any", "words": ["mitad", "recorta", "palabras", "más corto por", "dos frases", "elimina"], "requirement": "Pide un recorte con un tamaño" },
      { "kind": "forbids_any", "words": ["mejora", "hazlo mejor", "pule", "ordénalo", "hazlo más agradable", "suaviza"], "requirement": "No pidas una mejora" },
      { "kind": "max_words", "n": 32, "requirement": "Una frase sobre el propósito, una sobre el recorte" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('edit-do-not-write', 3,
  'Conserva tu propia frase torpe',
  $md$En algún sitio de la versión editada habrá una línea tuya que se ha suavizado, y mirarás la suave y pensarás que es mejor. A menudo no lo es.

**La jugada:** conserva la frase que es tuya y ligeramente torpe.

Una frase torpe de una persona real se lee como sincera. Una bien pulida se lee como escrita. Esto es más obvio precisamente en los mensajes que más importan — *no supe qué decir cuando me enteré* es mejor que cualquier cosa que pudiera sustituirla, y cada sustitución es peor de la misma forma concreta: suena como si hubiera sido fácil de escribir.

La prueba es rápida. Lee las dos versiones y pregúntate cuál podrías decir en voz alta a la cara de la persona sin sentirte raro. La tuya, normalmente. La suave tiene una pequeña formalidad que sería extraña en una sala, y un mensaje está más cerca de una sala que de un documento.

Dónde importa esto más:

**Tu primera línea y tu última.** Estas llevan más voz y son las dos que se sustituyen con más facilidad, porque las aperturas y los cierres son donde viven las frases convencionales.

**Cualquier cosa con sentimiento dentro.** Calidez, disculpa, gratitud, preocupación. La versión editada es más elocuente y menos creíble, y creíble es todo el trabajo.

**Tu vocabulario real.** Si ha aparecido una palabra que tú no dirías, quítala aunque sea una palabra mejor. Alguien que te conoce lo registrará, no como una sospecha sobre de dónde vino, sino como una pequeña sensación de que el mensaje está extrañamente rígido.

Merece la pena decir el corolario, para que esto no se convierta en un argumento para conservarlo todo. Los fallos mecánicos — la petición enterrada en el tercer párrafo, cuatro muletillas en una línea, una frase que se puede leer de dos formas — no son voz. Esos son lo que la lección anterior elimina. La voz es la frase que usarías en voz alta, y la torpeza en ese registro es una virtud.

Si te quedas con una cosa: lee las dos en voz alta y conserva la que podrías decir a la cara de la persona.$md$,
  $j$[
    {
      "situation": "Tu línea es torpe y la editada es suave.",
      "line": "(lee las dos en voz alta)",
      "why": "Conserva la que podrías decir a su cara. La suave normalmente tiene una formalidad que sería extraña en una sala."
    },
    {
      "situation": "Es un mensaje sobre algo difícil.",
      "line": "No supe qué decir cuando me enteré.",
      "why": "Cada sustitución es peor de la misma forma — suena como si hubiera sido fácil de escribir."
    },
    {
      "situation": "Ha aparecido una palabra que tú nunca dirías.",
      "line": "(quítala, aunque sea mejor)",
      "why": "Alguien que te conoce lo registra como rigidez, que es lo contrario de para qué era el mensaje."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué gana a menudo una frase torpe?",
      "options": [
        { "text": "Es más corta.", "correct": false, "note": "No de forma fiable. Las frases torpes son frecuentemente las más largas." },
        { "text": "Muestra más esfuerzo.", "correct": false, "note": "Casi lo contrario — normalmente costó menos. Lo que muestra es que una persona la escribió." },
        { "text": "Se lee como sincera; la suave se lee como escrita.", "correct": true, "note": "Creíble es todo el trabajo en cualquier mensaje con sentimiento dentro, y elocuente no es lo mismo." },
        { "text": "La gente desconfía de la buena escritura.", "correct": false, "note": "Demasiado amplio. No desconfían de ella — simplemente no te oyen en ella." }
      ],
      "explain": "Lee las dos en voz alta y conserva la que podrías decir a su cara."
    },
    {
      "prompt": "¿Cuál de estas no es voz, y aun así debería recortarse?",
      "options": [
        { "text": "Una frase que se apaga de forma extraña.", "correct": false, "note": "Así es como habla la gente, y sobrevive a leerse en voz alta." },
        { "text": "Una palabra que usarías pero que es imprecisa.", "correct": false, "note": "Tuya, y la imprecisión en el registro en el que hablas es normal." },
        { "text": "Una apertura más brusca que la convención.", "correct": false, "note": "Casi siempre merece la pena conservarla, y es lo primero que una edición elimina." },
        { "text": "La petición enterrada en el tercer párrafo.", "correct": true, "note": "Un fallo mecánico, no una voz. Para eso está la lección anterior." }
      ],
      "explain": "La voz es lo que dirías en voz alta. La estructura no es voz."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "kept", "label": "Conservó una línea propia", "description": "Rechazó una sustitución más suave." },
      { "key": "aloud", "label": "Leyó las dos en voz alta", "description": "Usó la prueba de decírselo a la cara." },
      { "key": "vocabulary", "label": "Eliminó palabras que no diría", "description": "Incluso las mejores." },
      { "key": "still_cut", "label": "Igualmente recortó los fallos mecánicos", "description": "No defendió la estructura como voz." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "un amigo que te conoce bien",
      "mood": "Atento.",
      "openness": 5,
      "personality": "Te pide que leas las dos en voz alta y dice cuál suena a ti."
    },
    "setting": "Estás eligiendo entre tu propia versión de una frase difícil y una mucho más suave.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta cuál podrían decir a la cara de la persona.",
      "Di con llaneza cuando una versión no suene a ellos.",
      "Nunca propongas una tercera versión."
    ],
    "opening_beat": "«Léeme las dos. En voz alta.»",
    "success_looks_like": "La persona conserva su propia línea."
  }$j$::jsonb,
  'Hoy, conserva una frase torpe tuya en vez de una sustitución más suave. Apunta ambas versiones.',
  $j${
    "beats": [
      {
        "situation": "Tu línea es no supe qué decir cuando me enteré. La editada es sentí mucho saber tu noticia y quería ponerme en contacto.",
        "prompt": "¿Cuál va dentro?",
        "options": [
          { "text": "La editada — está mejor escrita.", "correct": false, "note": "Lo está, y mejor escrita no es el trabajo. Suena como si hubiera sido fácil de escribir, que es la única cosa que este mensaje no debe ser." },
          { "text": "La tuya.", "correct": true, "note": "Una frase torpe de una persona real se lee como sincera. Lee las dos en voz alta y conserva la que podrías decir a su cara." },
          { "text": "Una mezcla de las dos.", "correct": false, "note": "Mezclar importa la formalidad que intentabas evitar, en cantidades más pequeñas." },
          { "text": "Ninguna — escribe una tercera.", "correct": false, "note": "Volver a redactar es cómo se pierde la frase torpe verdadera." }
        ]
      },
      {
        "situation": "La edición también ha movido tu petición del tercer párrafo a la primera línea.",
        "prompt": "¿Conservas ese cambio?",
        "options": [
          { "text": "No — el orden original era tuyo.", "correct": false, "note": "El orden es estructura, no voz, y esta es la edición individual más valiosa disponible." },
          { "text": "Solo si el mensaje es corto.", "correct": false, "note": "Importa más cuanto más largo se vuelve el mensaje, no menos." },
          { "text": "No, lo hace brusco.", "correct": false, "note": "Lo hace localizable. La calidez vuelve a entrar deliberadamente, debajo." },
          { "text": "Sí — eso es un fallo mecánico, no una voz.", "correct": true, "note": "La estructura no es voz. Conservar tu frase torpe no es un argumento para conservar tu petición enterrada." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('edit-do-not-write', 4,
  'Las señales',
  $md$Merece la pena saber cómo se ve la versión generada, por dos motivos: para que puedas encontrarla en tus propios borradores, y porque más gente puede verla que antes.

**La jugada:** aprende las señales, y luego derrótalas todas con un solo detalle concreto.

Las señales, más o menos en orden de cuán fiablemente delatan.

**Nada específico dentro.** La más fuerte con diferencia. No puede saber que fue la reunión del martes, que ya habían movido la fecha una vez, o que ambos estabais de pie en el pasillo. El texto generado es fluido sobre lo general y silencioso sobre lo particular, y un detalle concreto hace más por hacer tuyo un mensaje que cualquier cantidad de estilo.

**Frases uniformes.** Longitudes similares, ritmo similar, cada párrafo más o menos del mismo tamaño. La escritura real es irregular — una frase larga, luego cuatro palabras.

**Tres de todo.** Tres adjetivos, listas de tres partes, tres razones. Es una forma genuinamente satisfactoria y aparece muchísimo más a menudo de lo que dictaría el azar.

**Matización simétrica.** Ambos lados con el mismo peso, cada afirmación equilibrada por su matiz. La gente que escribe a alguien que conoce es desequilibrada, porque tiene una opinión.

**Calidez sin causa.** Una apertura que espera que estés bien, un reconocimiento de lo ocupados que están, un cierre con ganas de saber de ellos — nada de eso motivado por algo que haya pasado.

El segundo motivo para conocer esto no trata de la detección. Es que leer un mensaje y preguntarse si lo escribió una persona es en sí mismo corrosivo para el mensaje, sea cual sea la respuesta. Esa duda es el riesgo real de apoyarse en ello — no que te pillen, sino escribir cosas que invitan a la pregunta.

Lo cual apunta hacia el arreglo, y no es estilístico. Pon dentro una cosa concreta que solo tú podrías saber. Derrota cada señal de la lista de golpe, y es lo mismo que pide Storytelling: un detalle que cumple una función.

Si te quedas con una cosa: lo que delata es que nada dentro es específico. Un detalle real arregla más que cualquier cantidad de edición.$md$,
  $j$[
    {
      "situation": "El mensaje es fluido y no dice nada concreto.",
      "line": "(esa es la señal más fuerte)",
      "why": "No puede saber que fue la reunión del martes, o que ya habían movido la fecha una vez."
    },
    {
      "situation": "Cada frase tiene más o menos la misma longitud.",
      "line": "(la escritura real es irregular)",
      "why": "Una frase larga, luego cuatro palabras. El ritmo uniforme es ritmo de máquina."
    },
    {
      "situation": "Quieres arreglarlo todo de golpe.",
      "line": "(añade algo que solo tú podrías saber)",
      "why": "Derrota cada señal de la lista, y es el mismo detalle que pide Storytelling."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la señal más fuerte?",
      "options": [
        { "text": "Nada específico dentro.", "correct": true, "note": "No puede saber los detalles. El texto generado es fluido sobre lo general y silencioso sobre lo concreto." },
        { "text": "Calidez sin causa.", "correct": false, "note": "Una buena señal, y mucha gente escribe aperturas esperanzadas sin que nada la motive." },
        { "text": "Listas de tres partes.", "correct": false, "note": "Una forma satisfactoria que los escritores humanos también usan constantemente." },
        { "text": "Palabras largas.", "correct": false, "note": "No fiable en ninguna dirección — a menudo escribe con bastante llaneza." }
      ],
      "explain": "Un detalle real arregla más que cualquier cantidad de edición."
    },
    {
      "prompt": "¿Cuál es el riesgo real de apoyarse en ello?",
      "options": [
        { "text": "Escribir cosas que invitan a la pregunta.", "correct": true, "note": "Preguntarse si lo escribió una persona es corrosivo sea cual sea la respuesta, y la duda cuesta más que cualquier señal." },
        { "text": "Perder la capacidad de escribir.", "correct": false, "note": "Real, y pertenece al último bloque más que a esta lección." },
        { "text": "Sonar menos inteligente.", "correct": false, "note": "Normalmente te hace sonar más pulido, que es parte del problema." },
        { "text": "Que te pillen.", "correct": false, "note": "Rara vez pasa de forma explícita, y no es ahí donde está el daño." }
      ],
      "explain": "Así que el arreglo es la especificidad, no el estilo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "specific", "label": "Añadió algo específico", "description": "Algo que solo tú podrías saber." },
      { "key": "lumpy", "label": "Rompió el ritmo uniforme", "description": "Varió la longitud de las frases." },
      { "key": "unbalanced", "label": "Tomó partido", "description": "Eliminó la matización simétrica." },
      { "key": "no_filler_warmth", "label": "Recortó la calidez sin causa", "description": "Nada de espero-que-estés-bien." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Marcus",
      "role": "un amigo que escribe para ganarse la vida",
      "mood": "Curioso, no acusador.",
      "openness": 5,
      "personality": "Señala lo que falta en vez de lo que está mal, y pregunta qué pasó de verdad."
    },
    "setting": "Un amigo está leyendo un mensaje que enviaste la semana pasada y te ha hecho una pregunta incómoda al respecto.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué pasó de verdad esa semana.",
      "Date por satisfecho con un detalle real.",
      "Nunca acuses a la persona de nada directamente."
    ],
    "opening_beat": "«No hay nada aquí que solo pueda ser sobre nosotros.»",
    "success_looks_like": "La persona añade un detalle concreto que solo ella podría saber."
  }$j$::jsonb,
  'Hoy, pon un detalle que solo tú podrías saber en un mensaje. Apunta el mensaje y el detalle.',
  $j${
    "says": "No hay nada aquí que solo pueda ser sobre nosotros.",
    "model": {
      "line": "Tienes razón — voy a poner lo de que los dos estuvimos de pie en el pasillo después de la reunión del martes.",
      "why": "Un detalle concreto derrota cada señal de golpe, porque es lo que el texto generado no puede aportar."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["reword", "hazlo más cálido", "menos formal", "cambia el tono", "otra redacción", "reescríbelo"], "requirement": "No lo arregles con estilo" },
      { "kind": "min_words", "n": 10, "requirement": "Nombra un detalle real" },
      { "kind": "max_words", "n": 35, "requirement": "Un detalle, no un párrafo" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('edit-do-not-write', 5,
  'En qué es realmente bueno',
  $md$Después de cuatro lecciones sobre contención, la mitad constructiva. Hay una lista concreta de cosas que hace mejor que tú, y negarte a usarlo para esas no es integridad.

Todas comparten una propiedad: son hechos sobre el texto en vez de juicios sobre personas. Esa es la línea, y el bloque cinco sostiene el otro lado de ella.

**La jugada:** entrégale todo lo mecánico del mensaje, y párate donde empieza una persona.

**Mover la petición al frente.** *Pon la petición en la primera línea y el contexto debajo.* Instantáneo, y es la edición individual más valiosa de Mensajería.

**Eliminar muletillas.** Encuentra cada *solo*, *bastante*, *quizá* y *creo* en una pasada, incluidas las que has leído por encima cuatro veces porque las escribiste tú.

**Cortar la disculpa.** *Elimina cualquier cosa que se disculpe por preguntar.* Esto es todo Deja de disculparte, hecho mecánicamente, sobre un borrador que de otra forma habrías enviado.

**Encontrar lo que se podría malinterpretar.** *¿Qué frase de aquí se podría leer de una segunda forma?* Es genuinamente fiable en esto, porque la ambigüedad es una propiedad de la frase y no necesita conocer al lector.

**Comprobar que la petición es localizable.** *Si alguien leyera solo la primera línea, ¿qué pensaría que quiero?* Una prueba rápida para lo que hace que los mensajes se respondan el jueves.

**Convertir un muro en una lista.** Tres peticiones enterradas en un párrafo se convierten en una lista numerada, que es la versión que la gente realmente procesa.

Dos más que son menos obvias. Leer un documento largo que te han dado y decirte qué se te está pidiendo — eso es comprensión de texto, en lo que es bueno, a diferencia de qué quiso decir alguien con ello, en lo que no lo es. Y dividir un mensaje en dos cuando lleva dos temas.

Fíjate en qué no está en esta lista: si enviarlo, qué van a pensar, cómo se va a sentir el tono al llegar, si están molestos. Eso es No conoce la sala.

Si te quedas con una cosa: úsalo para todo lo mecánico de un mensaje, y para nada sobre la persona que lo recibe.$md$,
  $j$[
    {
      "situation": "La petición está enterrada en el tercer párrafo.",
      "line": "Pon la petición en la primera línea y el contexto debajo.",
      "why": "Instantáneo, y es la edición individual más valiosa de Mensajería."
    },
    {
      "situation": "Ya no puedes ver tus propias muletillas.",
      "line": "Elimina cada solo, bastante, quizá y creo.",
      "why": "Encuentra las que has leído por encima cuatro veces porque las escribiste tú."
    },
    {
      "situation": "No estás seguro de cómo cala una frase.",
      "line": "¿Qué frase de aquí se podría leer de una segunda forma?",
      "why": "La ambigüedad es una propiedad de la frase, así que no necesita conocer al lector."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué tienen en común los trabajos fiables?",
      "options": [
        { "text": "Son rápidos.", "correct": false, "note": "Lo son, y también lo son muchas de las cosas en las que se equivoca." },
        { "text": "Son sobre texto, no sobre personas.", "correct": true, "note": "Los hechos sobre la frase no necesitan conocer al lector. Esa es la línea, y No conoce la sala sostiene el otro lado de ella." },
        { "text": "Son objetivos.", "correct": false, "note": "Cerca, y la objetividad no es exactamente eso — lo que se podría malinterpretar es un juicio, solo que sobre el lenguaje." },
        { "text": "Son cosas que podrías hacer tú mismo.", "correct": false, "note": "Podrías, y demostrablemente no lo haces, especialmente con tus propias muletillas." }
      ],
      "explain": "Todo lo mecánico del mensaje, nada sobre la persona que lo recibe."
    },
    {
      "prompt": "¿Cuál de estas no está en la lista?",
      "options": [
        { "text": "Convertir tres peticiones enterradas en una lista.", "correct": false, "note": "En la lista. Una lista numerada es la versión que la gente realmente procesa." },
        { "text": "Decirte qué te pide un documento largo.", "correct": false, "note": "En la lista. Comprensión de texto, a diferencia de qué quiso decir alguien con ello." },
        { "text": "Dividir un mensaje que lleva dos temas.", "correct": false, "note": "En la lista, y es una petición por mensaje, de Mensajería." },
        { "text": "Decirte cómo va a caer el tono.", "correct": true, "note": "Eso es sobre el lector más que sobre el texto, y es todo No conoce la sala." }
      ],
      "explain": "Negarte a usarlo para el trabajo mecánico no es integridad."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "mechanical", "label": "Lo usó mecánicamente", "description": "Petición primero, muletillas fuera, disculpa cortada." },
      { "key": "ambiguity", "label": "Comprobó malinterpretaciones", "description": "Preguntó qué se podía leer dos veces." },
      { "key": "first_line", "label": "Probó la primera línea", "description": "Comprobó que la petición es localizable." },
      { "key": "stopped_there", "label": "Se detuvo en el texto", "description": "No preguntó sobre la persona." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nadia",
      "role": "una compañera en el escritorio de al lado",
      "mood": "Práctica.",
      "openness": 5,
      "personality": "Lee solo la primera línea y dice qué cree que se le está pidiendo."
    },
    "setting": "Un mensaje que has escrito está bien pero no consigue respuesta, y estás a punto de preguntar qué falla con tu tono.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde solo desde la primera línea.",
      "Niégate a especular sobre cómo se siente alguien respecto al mensaje.",
      "Nunca reescribas el mensaje."
    ],
    "opening_beat": "«He leído la primera línea. ¿Qué quieres que haga?»",
    "success_looks_like": "La persona trabaja en el texto en vez de especular sobre el lector."
  }$j$::jsonb,
  'Hoy, pasa un mensaje por la lista mecánica antes de enviarlo. Apunta qué cambió.',
  $j${
    "beats": [
      {
        "situation": "Tu mensaje no consigue respuesta y has empezado a preguntarte qué está haciendo tu tono.",
        "prompt": "¿Qué merece la pena preguntarle?",
        "options": [
          { "text": "¿Esto suena frío?", "correct": false, "note": "Sobre cómo se va a sentir un lector, que es lo que menos puede saber y más dispuesto está a responder." },
          { "text": "¿Están molestos conmigo?", "correct": false, "note": "Nunca los ha conocido. Va a producir una teoría de todos modos, que es la lección de apertura de No conoce la sala." },
          { "text": "Si alguien leyera solo la primera línea, ¿qué pensaría que quiero?", "correct": true, "note": "Un hecho sobre el texto, y una prueba rápida para lo que hace que los mensajes se respondan el jueves." },
          { "text": "¿Debería siquiera enviar esto?", "correct": false, "note": "Te ayudará a enviarlo. Esa pregunta es tuya." }
        ]
      },
      {
        "situation": "Tienes tres peticiones separadas enterradas en un párrafo.",
        "prompt": "¿Cuál es el trabajo correcto para ello?",
        "options": [
          { "text": "Convertirlo en una lista numerada, o dividirlo.", "correct": true, "note": "Mecánico y fiable — y una lista numerada es la versión que la gente realmente procesa." },
          { "text": "Adivinar a cuál dirán que sí.", "correct": false, "note": "Sobre la persona, no sobre el texto. No puede saberlo y responderá con confianza." },
          { "text": "Suavizar las dos más pequeñas.", "correct": false, "note": "Suavizar es añadir, que es toda la advertencia de la lección anterior." },
          { "text": "Elegir qué petición importa más.", "correct": false, "note": "Eso es un juicio sobre tu situación, y tú estás mejor posicionado que ello." }
        ]
      }
    ]
  }$j$::jsonb
);
