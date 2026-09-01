-- Spanish: Chatear online, track 3 — Tono sin tono.
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

select pg_temp.es_lesson('tone-with-no-tone', 1,
  'Todo se lee más frío',
  $md$En una sala, la mayor parte de lo que quieres decir lo llevan tu cara y tu voz. En un mensaje nada de eso está, y las palabras que habrías dicho en voz alta llegan despojadas de todo lo que las hacía cálidas.

El resultado es un sesgo constante. Un mensaje se lee algo más frío de lo que se escribió — no dramáticamente, pero de forma fiable, en cada mensaje, en las dos direcciones.

**La jugada:** trata eso como una propiedad conocida del canal y corrígela.

Merece la pena ser concreto sobre qué falta, porque explica por qué frases perfectamente normales caen raro. Tu cara suministra el *me alegra saber de ti* que corre por debajo de todo lo que le dices a alguien que te cae bien. Tu voz suministra la diferencia entre una pregunta hecha por interés y una hecha para comprobar. Nada de eso sobrevive, así que una frase neutra no llega neutra — llega en más o menos menos diez.

Esto produce dos errores y todo el mundo comete los dos. Enviar algo que querías decir con calidez y que no funciona. Y leer algo que se escribió con calidez y encontrarle un filo que nadie puso ahí.

La corrección no es escribir de una forma completamente distinta. Es una adición deliberada al enviar y una sustracción deliberada al leer, y las dos tardan un segundo.

Hay un efecto de segundo orden que merece la pena saber. Como todo el mundo está leyendo todo algo frío, una pequeña cantidad de calidez añadida llega muy lejos — no estás compitiendo con mensajes cálidos, estás compitiendo con mensajes neutros que llegaron fríos. Una sola frase de reconocimiento hace que un mensaje sea notablemente agradable de una forma que no lo sería hablado.

Si te quedas con una cosa: nada de lo que escribes llega como sonaba en tu cabeza. Asume menos diez en las dos direcciones, y corrige.$md$,
  $j$[
    {
      "situation": "Enviaste algo que querías decir con calidez y no funcionó.",
      "line": "(el canal le quitó la calidez)",
      "why": "Tu cara suministra el me alegra saber de ti que corre por debajo de todo lo que dices en voz alta, y nada de eso sobrevive."
    },
    {
      "situation": "Una respuesta que has recibido tiene un filo.",
      "line": "(asume menos diez y añádelo de vuelta)",
      "why": "Todo llega algo frío. Encontrar un filo es lo que pasa cuando lees una frase neutra al pie de la letra."
    },
    {
      "situation": "Quieres que un mensaje se sienta agradable.",
      "line": "(una frase llega lejos)",
      "why": "No estás compitiendo con mensajes cálidos, estás compitiendo con mensajes neutros que llegaron fríos."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué falta de verdad en un mensaje?",
      "options": [
        { "text": "Matiz.", "correct": false, "note": "Cierto y vago. Nombra qué llevaba el matiz." },
        { "text": "La cara y la voz que llevaban la mayor parte de la calidez.", "correct": true, "note": "Tu cara suministra el me alegra saber de ti debajo de todo, y tu voz separa el interés de comprobar. Ninguna de las dos sobrevive." },
        { "text": "Contexto.", "correct": false, "note": "El contexto se puede escribir. Lo que no se puede escribir es lo que nunca estuvo en las palabras." },
        { "text": "El lenguaje corporal.", "correct": false, "note": "Tampoco está presente en una llamada telefónica, y las llamadas telefónicas no tienen este problema en el mismo grado." }
      ],
      "explain": "Una frase neutra no llega neutra. Llega en más o menos menos diez."
    },
    {
      "prompt": "¿Por qué llega tan lejos un poco de calidez añadida?",
      "options": [
        { "text": "La gente está hambrienta de amabilidad.", "correct": false, "note": "Una afirmación grandiosa, y el mecanismo es más mundano que eso." },
        { "text": "Es inesperado.", "correct": false, "note": "En parte, y la novedad se desgastaría. Este efecto no." },
        { "text": "Estás compitiendo con mensajes neutros que llegaron fríos.", "correct": true, "note": "Una frase de reconocimiento hace que un mensaje sea notablemente agradable de una forma que la misma frase no sería hablada." },
        { "text": "Señala esfuerzo.", "correct": false, "note": "El esfuerzo se lee en la duración, no en la calidez, y la duración es un coste." }
      ],
      "explain": "Una adición deliberada al enviar, una sustracción deliberada al leer."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "corrected_sending", "label": "Añadió calidez a propósito", "description": "No se apoyó solo en las palabras." },
      { "key": "corrected_reading", "label": "Descontó la frialdad", "description": "Asumió menos diez a la entrada." },
      { "key": "no_edge", "label": "No encontró un filo", "description": "Leyó un mensaje neutro como neutro." },
      { "key": "small", "label": "Mantuvo la corrección pequeña", "description": "Una frase en vez de una reescritura." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una compañera con quien te llevas bien",
      "mood": "Bien, algo insegura de cómo están las cosas.",
      "openness": 4,
      "personality": "Lee los mensajes exactos pero escuetos como algo raros, y responde notablemente mejor a una línea de reconocimiento."
    },
    "setting": "Has escrito una respuesta de tres líneas factualmente perfecta a alguien con quien te gusta trabajar, y algo en ella parece frío.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con brevedad y algo de sequedad a una respuesta exacta pero escueta.",
      "Cálidate notablemente ante cualquier reconocimiento de ti o de tu trabajo.",
      "Nunca preguntes si algo va mal."
    ],
    "opening_beat": "«¿Has podido mirar la presentación?»",
    "success_looks_like": "La persona añade calidez de forma deliberada en vez de enviar la versión escueta."
  }$j$::jsonb,
  'Hoy, relee un mensaje que enviaste y uno que recibiste, asumiendo menos diez en los dos. Apunta qué cambió.',
  $j${
    "beats": [
      {
        "situation": "Enviaste un mensaje cálido y útil. La respuesta es exacta, completa, y de alguna forma se lee fría.",
        "prompt": "¿Qué ha pasado?",
        "options": [
          { "text": "Está molesta por algo.", "correct": false, "note": "La lectura que fabrica un problema. También es la explicación menos probable de la lista." },
          { "text": "El canal le quita unos diez a todo.", "correct": true, "note": "Tu cara suministra el me alegra saber de ti debajo de todo lo dicho en voz alta, y nada de eso sobrevive. Una frase neutra no llega neutra." },
          { "text": "Calibraste mal el registro.", "correct": false, "note": "Posible, y no explicaría por qué respuestas perfectamente normales y exactas se leen frías viniendo de cualquiera." },
          { "text": "No es una persona cálida.", "correct": false, "note": "Una conclusión sobre alguien sacada de un medio que le hace esto a cada persona en él." }
        ]
      },
      {
        "situation": "Quieres que tus propios mensajes se lean tan cálidos como los quieres decir.",
        "prompt": "¿Cuánto necesitas añadir?",
        "options": [
          { "text": "Bastante — empiezas desde frío.", "correct": false, "note": "Sobrecorregir produce el mensaje con cuatro signos de exclamación y ninguna implicación, que se lee como dirigido a nadie en particular." },
          { "text": "Nada, si las palabras son amistosas.", "correct": false, "note": "Las palabras amistosas igualmente llegan en menos diez. Esa es toda la propiedad que se está describiendo." },
          { "text": "Reescribe en un estilo más cálido en general.", "correct": false, "note": "Un cambio grande para resolver algo que arregla una sola frase." },
          { "text": "Una frase — estás compitiendo con neutros fríos.", "correct": true, "note": "Una pequeña cantidad llega lejos, porque los mensajes neutros de todos los demás también están llegando fríos." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('tone-with-no-tone', 2,
  'Añade la calidez a propósito',
  $md$Si el canal quita la calidez, hay que devolverla de forma deliberada, y merece la pena saber qué palabras lo hacen de verdad.

**La jugada:** reconócelos, y luego responde.

Lo más eficaz de todo no es en absoluto una cortesía: es la evidencia de que leíste lo que escribieron en vez de solo extraer la pregunta de ello. *Eso suena a una pesadilla con las impresoras — sí, el jueves va bien* es cálido porque se implica, y tarda cuatro palabras más.

Ese es todo el principio. La calidez en la escritura es sobre todo atención, hecha visible. Un mensaje largo y amistoso que ignora lo que alguien dijo se lee peor que uno corto que no lo hace.

Las adiciones fiables, más o menos en orden de cuánto hacen:

**Referirte a su cosa concreta.** Como arriba.
**Gracias, donde de verdad se hizo algo.** *Gracias por presionarlos* en vez de una despedida genérica.
**Una palabra sobre ellos.** *Espero que la semana se haya calmado.* Una línea, al final.
**Un signo de exclamación o un emoji.** Genuinamente funcional en vez de decorativo — son marcadores de tono, y normalmente uno es suficiente.

Dos cosas que evitar. La calidez al principio, que es carraspeo por muy amistosa que sea, porque cualquier cosa antes de la petición se experimenta como retraso. Y el volumen como sustituto de la atención: tres signos de exclamación y ninguna implicación con lo que dijeron se lee como entusiasmo dirigido a nadie en particular.

La pregunta de registro que preocupa a la gente — ¿es esto demasiado para el trabajo — se responde sobre todo mirando qué hace la otra persona. Iguala su nivel y sube un escalón, y vas a acertar casi siempre sin tener que volver a pensarlo.

Si te quedas con una cosa: la calidez es atención hecha visible. Cuatro palabras sobre su cosa ganan a un párrafo sobre nada.$md$,
  $j$[
    {
      "situation": "Han explicado un problema y han hecho una pregunta.",
      "line": "Eso suena a una pesadilla con las impresoras — sí, el jueves va bien.",
      "why": "Cuatro palabras más, y se implica con lo que dijeron. La calidez en la escritura es sobre todo atención hecha visible."
    },
    {
      "situation": "Quieres abrir con calidez.",
      "line": "(la calidez al principio es carraspeo)",
      "why": "Cualquier cosa antes de la petición se experimenta como retraso, por muy amistosa que sea. Las mismas palabras al final se leen como calidez."
    },
    {
      "situation": "No estás seguro de cuánta calidez es apropiada en el trabajo.",
      "line": "(iguala su nivel, y luego un escalón más)",
      "why": "Responde a la pregunta de registro casi siempre sin tener que volver a pensarlo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hace más trabajo?",
      "options": [
        { "text": "Un signo de exclamación.", "correct": false, "note": "Funcional como marcador de tono y es la más pequeña de las adiciones." },
        { "text": "Una línea de apertura amistosa.", "correct": false, "note": "Al principio es carraspeo, por muy cálidas que sean las palabras." },
        { "text": "Referirte a su cosa concreta.", "correct": true, "note": "La calidez en la escritura es sobre todo atención hecha visible, y cuatro palabras sobre su problema real ganan a un párrafo sobre nada." },
        { "text": "Decir gracias.", "correct": false, "note": "Bueno donde de verdad se hizo algo, y un gracias genérico hace muy poco." }
      ],
      "explain": "Un mensaje largo y amistoso que ignora lo que alguien dijo se lee peor que uno corto que no lo hace."
    },
    {
      "prompt": "¿Cómo resuelves la pregunta de registro en el trabajo?",
      "options": [
        { "text": "Mantenlo formal hasta que conozcas a alguien.", "correct": false, "note": "Seguro, y lo formal se lee lo más frío de todo a través de un canal que ya está quitando diez." },
        { "text": "Iguala su nivel, y luego un escalón más cálido.", "correct": true, "note": "Responde a la pregunta casi siempre y la elimina como algo en lo que tengas que volver a pensar." },
        { "text": "Sigue la cultura del equipo.", "correct": false, "note": "Útil y lenta de leer, y varía más dentro de un equipo que entre equipos." },
        { "text": "Peca de cálido — a nadie le importa.", "correct": false, "note": "Mayormente cierto, y produce el ocasional mensaje mal calibrado con alguien muy formal." }
      ],
      "explain": "Y el volumen no es atención. Tres signos de exclamación sin implicación se leen como entusiasmo dirigido a nadie."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "engaged", "label": "Se refirió a su cosa", "description": "Mostró que se había leído el mensaje." },
      { "key": "at_the_end", "label": "Calidez al final", "description": "Nada cálido delante de la petición." },
      { "key": "matched", "label": "Igualó su registro", "description": "Su nivel, un escalón más." },
      { "key": "not_volume", "label": "Atención, no volumen", "description": "No sustituyó la implicación por entusiasmo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una compañera de trabajo",
      "mood": "Agobiada.",
      "openness": 4,
      "personality": "Se da cuenta de inmediato de si una respuesta se implica con el problema del proveedor, y no le importan en absoluto las respuestas cortas que lo hacen."
    },
    "setting": "Una compañera te ha enviado un mensaje largo sobre un problema con un proveedor, terminando con una pregunta sobre el jueves.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Cálidate notablemente ante cualquier respuesta que mencione el problema del proveedor.",
      "Responde con sequedad a una respuesta amistosa que solo responda la pregunta del jueves.",
      "Nunca menciones que querías reconocimiento."
    ],
    "opening_beat": "«...bueno, ya se han saltado dos plazos. ¿Sigue yendo bien el jueves?»",
    "success_looks_like": "La persona reconoce el problema del proveedor y responde."
  }$j$::jsonb,
  'Hoy, añade cuatro palabras sobre su cosa a una respuesta antes de contestarla. Apunta las cuatro palabras.',
  $j${
    "says": "...bueno, ya se han saltado dos plazos y he tenido que rehacer el calendario dos veces. ¿Sigue yendo bien el jueves?",
    "model": {
      "line": "Dos plazos es duro, y rehacer ese calendario dos veces suena a pesadilla. Sí, el jueves va bien.",
      "why": "La calidez en la escritura es sobre todo atención hecha visible. Cuatro palabras sobre su problema real hacen más que cualquier cortesía, y no cuesta casi nada."
    },
    "checks": [
      { "kind": "echoes_any", "words": ["plazos", "calendario", "dos veces", "rehacer"], "requirement": "Refiérete a su problema real" },
      { "kind": "forbids_any", "words": ["espero que estés bien", "espero que estés teniendo", "siento oír eso pero", "bueno", "solo rápido"], "requirement": "Calidez al final, no al principio" },
      { "kind": "min_words", "n": 10, "requirement": "Reconoce, y luego responde" },
      { "kind": "max_words", "n": 40, "requirement": "Corto está bien si se implica" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('tone-with-no-tone', 3,
  'Puntos, vale, y emojis',
  $md$Las cosas pequeñas parecen absurdas por escrito y hacen un trabajo real, así que merece la pena ser directo al respecto en vez de fingir lo contrario.

**La jugada:** trata la puntuación y los emojis como marcadores de tono, porque en eso se han convertido.

**El punto en una respuesta de una palabra.** *Vale.* se lee como cortante para una gran proporción de gente, y *Vale* o *¡Vale!* no. Esto no es una regla que nadie acordara, es una convención que surgió, y ahora es lo bastante fuerte como para que ignorarla produzca un efecto que no pretendías. No hace falta que te guste para tenerla en cuenta.

**Las respuestas de una palabra en general.** *Bien*, *Claro*, *Anotado* son eficientes y se leen frías. Si te cae bien la persona, dos palabras lo arregla: *Claro, sin problema.*

**Emojis como marcadores en vez de decoración.** Uno solo al final de una frase le dice a alguien cómo leerla, que es exactamente el trabajo que quitó el canal. Uno es un marcador de tono; cuatro es un estado de ánimo, y uno distinto.

**Mayúsculas y signos de exclamación.** Un signo de exclamación es calidez. Tres es o alegría o pánico y el lector tiene que averiguar cuál.

Dos calibraciones. Las convenciones varían según la edad y el lugar de trabajo, y la jugada segura es la de la lección anterior: mira qué hace la otra persona. Y la formalidad no es lo mismo que la frialdad — un mensaje muy correcto puede ser cálido, y *Estimada Priya, Gracias por tu correo* no es más cálido que *Hola Priya, gracias por esto*, sencillamente está más lejos.

Nada de esto importa mucho por sí solo. Importa porque es gratis: son decisiones de un carácter que cambian cómo cae un mensaje, y equivocarse un poco con ellas es el motivo más común de que alguien perfectamente amistoso parezca cortante.

Si te quedas con una cosa: tu puntuación está haciendo tono, lo pretendieras o no.$md$,
  $j$[
    {
      "situation": "Estás respondiendo con una sola palabra.",
      "line": "Claro, sin problema.",
      "why": "Dos palabras arreglan la frialdad de una respuesta de una palabra. Bien, Claro y Anotado son eficientes y se leen frías."
    },
    {
      "situation": "Has escrito Vale.",
      "line": "(el punto está haciendo algo)",
      "why": "Se lee como cortante para una gran proporción de gente. No es una regla que nadie acordara, y es lo bastante fuerte como para que ignorarla produzca un efecto que no pretendías."
    },
    {
      "situation": "No estás seguro de si los emojis son apropiados aquí.",
      "line": "(mira qué hacen ellos)",
      "why": "Las convenciones varían según la edad y el lugar de trabajo. Igualar, y luego un escalón más cálido, lo resuelve sin tener que decidir en abstracto."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué está haciendo de verdad un solo emoji?",
      "options": [
        { "text": "Hacerlo informal.", "correct": false, "note": "La informalidad es un efecto secundario, y un mensaje formal puede llevar uno perfectamente bien." },
        { "text": "Suavizar una petición.", "correct": false, "note": "A veces, y suavizar la petición no es la función general." },
        { "text": "Decirle a alguien cómo leer la frase.", "correct": true, "note": "Que es exactamente el trabajo que quitó el canal. Uno es un marcador de tono; cuatro es un estado de ánimo, y uno distinto." },
        { "text": "Mostrar que eres amistoso.", "correct": false, "note": "Vago, y la amistosidad la lleva implicarte con lo que dijeron." }
      ],
      "explain": "Tu puntuación está haciendo tono, lo pretendieras o no."
    },
    {
      "prompt": "¿Es un mensaje formal uno frío?",
      "options": [
        { "text": "Sí — la formalidad se lee como distancia.", "correct": false, "note": "Distancia y frialdad no son lo mismo. Un mensaje muy correcto puede ser completamente cálido." },
        { "text": "No — son ejes distintos.", "correct": true, "note": "Estimada Priya, gracias por tu correo no es más cálido ni más frío que Hola Priya, gracias por esto. Está más lejos." },
        { "text": "Sí, en la mayoría de los trabajos ahora.", "correct": false, "note": "Las convenciones han cambiado y eso va sobre la expectativa, no sobre la calidez." },
        { "text": "Solo si no hay saludo.", "correct": false, "note": "Los saludos hacen muy poco de cualquier forma comparado con si el mensaje se implica." }
      ],
      "explain": "Son decisiones de un carácter que cambian cómo cae un mensaje, que es por lo que merece la pena acertarlas."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "markers", "label": "Usó marcadores de tono", "description": "Puntuación y emojis haciendo un trabajo deliberado." },
      { "key": "not_one_word", "label": "Evitó la respuesta escueta de una palabra", "description": "Dos palabras donde importaba la calidez." },
      { "key": "matched", "label": "Igualó sus convenciones", "description": "Miró qué hace la otra persona." },
      { "key": "restrained", "label": "Uno, no cuatro", "description": "No sustituyó el tono por volumen." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una compañera con quien te llevas bien",
      "mood": "Alegre.",
      "openness": 4,
      "personality": "Lee una respuesta escueta de una palabra como algo rara y se queda un momento preguntándose; lee dos palabras como completamente normal."
    },
    "setting": "Alguien que te cae bien te ha enviado algo para que lo mires y estás de acuerdo con todo. Tu instinto es responder con una palabra.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con normalidad y calidez a dos o más palabras.",
      "Ponte algo callada e insegura después de una respuesta escueta de una palabra.",
      "Nunca digas que la respuesta pareció corta."
    ],
    "opening_beat": "«Échale un ojo cuando tengas un segundo — creo que básicamente ya está.»",
    "success_looks_like": "La persona envía algo más cálido que una respuesta escueta de una palabra."
  }$j$::jsonb,
  'Hoy, convierte una respuesta de una palabra en una de dos palabras. Apunta las dos.',
  $j${
    "beats": [
      {
        "situation": "Alguien que te cae bien te ha enviado algo y estás de acuerdo con todo. Tu instinto es una respuesta de una palabra.",
        "prompt": "¿Qué respuesta?",
        "options": [
          { "text": "Vale.", "correct": false, "note": "El punto en una respuesta de una palabra se lee como cortante para una gran proporción de gente. No es una regla que nadie acordara, y es lo bastante fuerte como para importar." },
          { "text": "Anotado.", "correct": false, "note": "Eficiente, y se lee fría — toda la familia de respuestas de una palabra lo hace." },
          { "text": "Claro, sin problema.", "correct": true, "note": "Dos palabras lo arreglan por completo, y no cuesta nada. Las respuestas de una palabra son eficientes y llegan más frías de lo que se pretendía." },
          { "text": "¡¡¡Vale!!!", "correct": false, "note": "Volumen sustituyendo a la calidez. Un marcador es tono; tres es un estado de ánimo, y el lector tiene que averiguar cuál." }
        ]
      },
      {
        "situation": "Te preguntas si un mensaje formal se lee frío.",
        "prompt": "¿Se lee así?",
        "options": [
          { "text": "Sí — la formalidad es distancia y la distancia es frialdad.", "correct": false, "note": "Distancia y frialdad son ejes distintos, que es la distinción útil aquí." },
          { "text": "Solo sin saludo.", "correct": false, "note": "Los saludos hacen muy poco de cualquier forma al lado de si el mensaje se implica con algo." },
          { "text": "No necesariamente — un mensaje muy correcto puede ser cálido.", "correct": true, "note": "Estimada Priya, gracias por tu correo no es más frío que Hola Priya, gracias por esto. Está más lejos." },
          { "text": "Sí, en la mayoría de los trabajos ahora.", "correct": false, "note": "Sobre expectativas cambiadas, no sobre calidez, y varía más dentro de un equipo que entre equipos." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('tone-with-no-tone', 4,
  'Una respuesta corta no es enfado',
  $md$Esta es la mitad que le cuesta más a una persona callada, y toda la lección es una frase: una respuesta cortante casi nunca es lo que parece.

*Vale.* *Bien.* *Hecho.* *Sí.*

Cada una de esas llega con una temperatura aparente, y cada una casi con toda seguridad se escribió con un pulgar por alguien entrando en una reunión. La frialdad es una propiedad del canal y las circunstancias, no de sus sentimientos hacia ti.

**La jugada:** atribuye las respuestas cortas a la situación antes de atribuirlas a la relación.

La lista de explicaciones ordinarias es larga y aburrida: en un tren, entre reuniones, conduciendo, sujetando a un niño, batería baja, en un móvil en el que odian escribir, respondiendo mientras hacen otra cosa. Cada una de esas produce exactamente la respuesta que se lee como molestia, y todas son más probables que la molestia.

Lo mismo se aplica a los huecos. Un silencio de cuatro horas no es un mensaje. Una respuesta que se salta una de tus preguntas no es un desaire — es alguien que respondió a lo primero y le interrumpieron.

Lo que hace esto costoso no es la mala lectura individual, es la respuesta. Leer frialdad produce frialdad de vuelta, o un seguimiento ansioso preguntando si todo va bien, y ahora la otra persona está lidiando con algo que no existía. Haz eso unas cuantas veces y una relación perfectamente normal adquiere un ambiente que se fabricó por completo a partir de la puntuación.

La comprobación que funciona: ¿cómo se vería este mensaje si lo hubiera enviado alguien con prisa a quien le caigo bien? Casi siempre idéntico. Si las dos lecturas producen el mismo texto, el texto no es evidencia.

Y si de verdad importa — una relación en la que la temperatura ha cambiado de verdad — pregunta con llaneza, más tarde, en vez de leer más a fondo. Nadie ha resuelto nunca esto releyendo.

Si te quedas con una cosa: está en un tren. Esa explicación acierta casi siempre y no te cuesta nada cuando no lo hace.$md$,
  $j$[
    {
      "situation": "Te devuelven un mensaje que dice Bien.",
      "line": "(está en un tren)",
      "why": "Un pulgar, entrando en una reunión. Cada circunstancia ordinaria produce exactamente la respuesta que se lee como molestia."
    },
    {
      "situation": "Te preguntas si está molesta.",
      "line": "(¿cómo se vería esto viniendo de alguien con prisa a quien le caes bien?)",
      "why": "Casi siempre idéntico. Si las dos lecturas producen el mismo texto, el texto no es evidencia."
    },
    {
      "situation": "Estás redactando un mensaje preguntando si todo va bien.",
      "line": "(eso le entrega algo que no existía)",
      "why": "Leer frialdad produce frialdad de vuelta, y una relación normal adquiere un ambiente fabricado por completo a partir de la puntuación."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la comprobación?",
      "options": [
        { "text": "Pregúntale a otra persona cómo se lee.", "correct": false, "note": "Ella también lo va a leer frío, porque el canal le hace eso a todo el mundo." },
        { "text": "Vuelve a leerlo con cuidado.", "correct": false, "note": "Releer fabrica significado. Nadie ha resuelto nunca esto mirando más a fondo." },
        { "text": "¿Se vería esto distinto viniendo de alguien con prisa a quien le caes bien?", "correct": true, "note": "Casi siempre idéntico — y si las dos lecturas producen el mismo texto, el texto no es evidencia de nada." },
        { "text": "Espera a ver cómo es el próximo mensaje.", "correct": false, "note": "Razonable, y te deja cargando con ello mientras tanto, que es el coste." }
      ],
      "explain": "Atribúyelo a la situación antes de atribuirlo a la relación."
    },
    {
      "prompt": "¿Qué hace costosa la mala lectura?",
      "options": [
        { "text": "Te sientes mal durante una tarde.", "correct": false, "note": "Real y recuperable. Pasa algo peor después." },
        { "text": "La respuesta fabrica el problema.", "correct": true, "note": "Frialdad de vuelta, o un seguimiento ansioso — y ahora están lidiando con algo que no existía. Hazlo unas cuantas veces y el ambiente se vuelve real." },
        { "text": "Calibras mal la relación.", "correct": false, "note": "Momentáneamente, y un juicio erróneo privado se corrige solo. La respuesta es lo que lo hace duradero." },
        { "text": "Dejas de escribirle.", "correct": false, "note": "Un resultado posible entre varios, y se sigue del mismo mecanismo." }
      ],
      "explain": "Si de verdad importa, pregunta con llaneza más tarde en vez de leer más a fondo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "situational", "label": "Culpó a la situación", "description": "Atribuyó lo corto a las circunstancias." },
      { "key": "no_follow_up", "label": "No envió seguimiento ansioso", "description": "No preguntó si todo iba bien." },
      { "key": "no_mirroring", "label": "No se puso fría de vuelta", "description": "Respondió con su calidez habitual." },
      { "key": "asked_if_needed", "label": "Preguntó con llaneza si importaba", "description": "Lo sacó más tarde en vez de releer." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una compañera que ha estado en reuniones toda la tarde",
      "mood": "Agotada, entre cosas.",
      "openness": 4,
      "personality": "Completamente contenta contigo y completamente inconsciente de que la respuesta se leyera como nada. Responde con calidez y extensión cuando tiene tiempo."
    },
    "setting": "Enviaste un mensaje largo y meditado. La respuesta, cuatro horas después, es: Vale, gracias.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con calidez y extensión a cualquier cosa ordinaria, en cuanto tengas un momento.",
      "Ponte confundida y algo preocupada si te preguntan si todo va bien.",
      "Nunca expliques que estabas ocupada a menos que te lo pregunten."
    ],
    "opening_beat": "«Vale, gracias.»",
    "success_looks_like": "La persona responde con normalidad en vez de leer algo en ello."
  }$j$::jsonb,
  'Hoy, coge un mensaje que se leyó frío y vuelve a leerlo como alguien con prisa a quien le caes bien. Apunta la diferencia.',
  $j${
    "says": "Vale, gracias. (Cuatro horas después de tu mensaje largo y meditado.)",
    "model": {
      "line": "Sin problema — avísame si quieres repasar algo de ello.",
      "why": "Responde con la calidez habitual y no lee nada en ello. Cada circunstancia ordinaria — un tren, una reunión, un pulgar — produce exactamente el mensaje que parece molestia."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["va todo bien", "estás molesta", "he hecho algo", "perdona si", "pareces", "pasa algo", "dije algo", "espero no haber"], "requirement": "No leas nada en ello" },
      { "kind": "max_words", "n": 30, "requirement": "Responde con normalidad" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('tone-with-no-tone', 5,
  'Deja de decodificar',
  $md$Hay una actividad concreta que se come horas y no produce nada, y casi todo el mundo a quien le cuesta escribir mensajes la hace: releer un mensaje para averiguar qué significa de verdad.

**La jugada:** tómate los mensajes al pie de la letra, y cuando no puedas, pregunta en vez de decodificar.

Decodificar se siente como diligencia. Estás siendo cuidadoso, leyendo de cerca, tomándote a alguien en serio. Lo que hace de verdad es fabricar contenido — lee cualquier cosa cuatro veces y vas a encontrar algo, porque el lenguaje es lo bastante ambiguo como para sostener casi cualquier lectura, y la que elijas va a ser la que coincida con lo que ya temías.

La señal delatora es que el significado empeora con cada pasada. La comprensión genuina converge; decodificar diverge, y para la quinta lectura tienes una teoría que involucra algo que dijeron en marzo.

Tres cosas que merece la pena saber sobre los mensajes que más se decodifican.

**La brevedad no es código.** Es un móvil, un pulgar, y una reunión.
**La elección de palabras rara vez es deliberada.** La gente escribe rápido y no elige entre sinónimos por sus implicaciones, por mucho que la elegida parezca significar algo.
**No había nada escondido que encontrar.** La inmensa mayoría de los mensajes son exactamente lo que dicen, enviados por alguien que estaba pensando en otra cosa.

Cuando de verdad no puedas saberlo — y esto pasa, sobre todo donde algo real está en juego — hay dos jugadas y las dos son llanas. Pregunta: *es difícil saberlo por mensaje, ¿estás molesta conmigo?* es una frase completamente normal que termina todo el asunto en un intercambio. O asume la explicación aburrida y sigue adelante, que acierta la mayoría de las veces.

Lo que no puedes hacer es la opción del medio, que es seguir leyendo y responder a tu reconstrucción. Ahí es donde la gente responde a un mensaje que nunca se envió, y la otra persona, con toda razón, no tiene ni idea de qué está pasando.

Si te quedas con una cosa: si necesita decodificación, pregunta. Releer nunca ha producido información ni una sola vez.$md$,
  $j$[
    {
      "situation": "Has leído el mensaje cuatro veces.",
      "line": "(el significado está empeorando con cada pasada)",
      "why": "La comprensión genuina converge. Decodificar diverge, y para la quinta lectura hay una teoría que involucra algo que dijeron en marzo."
    },
    {
      "situation": "Usaron una palabra que parece significativa.",
      "line": "(la gente no elige sinónimos por sus implicaciones)",
      "why": "Escribieron rápido mientras pensaban en otra cosa. Casi nada de la elección de palabras en un mensaje es deliberado."
    },
    {
      "situation": "De verdad no puedes saberlo.",
      "line": "Es difícil saberlo por mensaje — ¿estás molesta conmigo?",
      "why": "Una frase completamente normal que termina todo el asunto en un intercambio, que releer nunca va a hacer."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cómo distingues decodificar de comprender?",
      "options": [
        { "text": "Comprender es más rápido.", "correct": false, "note": "A veces, y un mensaje genuinamente complicado puede tardar un rato en entenderse bien." },
        { "text": "Decodificar se siente ansioso.", "correct": false, "note": "Cierto y difícil de usar como prueba en el momento, cuando todo se siente ansioso." },
        { "text": "Comprender converge; decodificar empeora con cada pasada.", "correct": true, "note": "Para la quinta lectura hay una teoría que involucra algo de marzo, que es la señal delatora. Entender no hace eso." },
        { "text": "Decodificar involucra las opiniones de otra gente.", "correct": false, "note": "A menudo un síntoma, y mucho de ello pasa completamente a solas." }
      ],
      "explain": "Lee cualquier cosa cuatro veces y vas a encontrar algo, porque el lenguaje sostiene casi cualquier lectura."
    },
    {
      "prompt": "¿Cuál es la opción que no está disponible?",
      "options": [
        { "text": "Preguntar con llaneza.", "correct": false, "note": "Una de las dos buenas jugadas, y termina todo el asunto en un intercambio." },
        { "text": "Asumir la explicación aburrida.", "correct": false, "note": "La otra buena jugada, y acierta la mayoría de las veces." },
        { "text": "Esperar al próximo mensaje.", "correct": false, "note": "Una versión de asumir la explicación aburrida, y está bien." },
        { "text": "Responder a tu reconstrucción.", "correct": true, "note": "Ahí es donde la gente responde a un mensaje que nunca se envió, y la otra persona con toda razón no tiene ni idea de qué está pasando." }
      ],
      "explain": "Si necesita decodificación, pregunta. Releer nunca ha producido información ni una sola vez."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "face_value", "label": "Se lo tomó al pie de la letra", "description": "Lo leyó una vez y se lo creyó." },
      { "key": "no_rereading", "label": "No releyó", "description": "Paró antes de que se formara la teoría." },
      { "key": "asked", "label": "Preguntó cuando de verdad no estaba segura", "description": "Una pregunta llana en vez de más lectura." },
      { "key": "no_reconstruction", "label": "No respondió a una reconstrucción", "description": "Respondió a lo que se envió." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una compañera de trabajo",
      "mood": "Neutra, ocupada.",
      "openness": 4,
      "personality": "Lo dijo completamente en directo y estaba escribiendo entre reuniones. Responde con honestidad a una pregunta llana y se queda perpleja ante una respuesta a algo que no dijo."
    },
    "setting": "Un mensaje de alguien con quien trabajas de cerca: «Bien, podemos hacerlo a tu manera.» Ya lo has leído varias veces.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Confirma con llaneza y calidez que lo decías en serio, si te preguntan.",
      "Quédate genuinamente perpleja ante una respuesta que responde a un desaire implícito.",
      "Nunca hayas estado molesta."
    ],
    "opening_beat": "«Bien, podemos hacerlo a tu manera.»",
    "success_looks_like": "La persona se lo toma al pie de la letra o pregunta con llaneza."
  }$j$::jsonb,
  'Hoy, fíjate en un mensaje que hayas releído más de dos veces. Para, y pregunta o asume la versión aburrida. Apunta cuál.',
  $j${
    "says": "Bien, podemos hacerlo a tu manera. (Ya has leído esto varias veces.)",
    "model": {
      "line": "Genial — lo voy a dejar montado esta tarde.",
      "why": "Tomado al pie de la letra, que es casi con toda seguridad lo que es. Releer fabrica significado, y la lectura que elijas va a ser la que coincida con lo que ya temías."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["si prefieres", "no tenemos que", "se nota que no", "claramente tú", "perdona, podemos hacerlo a tu", "no, olvídalo", "parece que tú"], "requirement": "No respondas a una reconstrucción" },
      { "kind": "min_words", "n": 5, "requirement": "Responde a lo que de verdad se envió" },
      { "kind": "max_words", "n": 30, "requirement": "Al pie de la letra, y sigue adelante" }
    ]
  }$j$::jsonb
);
