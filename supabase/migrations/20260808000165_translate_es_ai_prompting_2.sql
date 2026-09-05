-- Spanish: Escribir prompts a la IA, track 2 — La pregunta gratis.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Priya" (lessons 1, 2, 5) — established feminine exception
-- name. "Tom" (lessons 3, 4) is unambiguously masculine.

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

select pg_temp.es_lesson('the-free-question', 1,
  'Lo que llevas asintiendo',
  $md$Hay un tipo particular de no-saber que la gente callada acumula.

Se usa una palabra en cada reunión. No preguntaste en la primera semana, porque parecía algo que se suponía que ya deberías saber. Para la cuarta semana preguntar habría significado admitir tres semanas asintiendo, y ahora es la semana noventa y la pregunta se ha vuelto genuinamente impreguntable.

El hueco en sí rara vez es el problema. El problema es que no puedes hacer *ninguna* pregunta sobre algo que no has admitido que no entiendes — así que las preguntas de seguimiento tampoco pasan nunca, y te quedas callado exactamente en las reuniones donde de otra forma habrías tenido algo que decir. Desde fuera eso parece no tener nada que decir.

**La jugada:** pregúntalo con llaneza, hoy, en el sitio donde no cuesta nada.

*Explícame X como si nunca hubiera oído hablar de ello.* Sin preámbulo. Sin explicar por qué no lo sabes ya. Sin disculparte ante un programa.

Se están eliminando tres cosas aquí, y merece la pena tener claro cuáles. La vergüenza, obviamente. Pero también el registro — no hay ningún compañero que ahora lo sepa, ningún momento que se recuerde, nada que salga después. Y la impaciencia: la persona a la que le habrías preguntado estaba ocupada, y ese hecho ha estado haciendo más trabajo en tu decisión del que probablemente te das cuenta.

Empieza con el más antiguo. Todo el mundo tiene una lista, y los elementos de ella normalmente no son oscuros — un acrónimo usado a diario, un proceso al que todos se refieren, una parte del producto, aquello de lo que trata el nombre de tu propio equipo. Se sienten enormes por lo mucho que se han cargado, no por lo difíciles que son.

La lista entera normalmente es una tarde. Ese es el tamaño real de algo que llevas dos años esquivando.

Si te quedas con una cosa: la pregunta que no puedes hacerle a una persona tiene una respuesta gratis, y eres el único que sabrá alguna vez que la hiciste.$md$,
  $j$[
    {
      "situation": "Una palabra usada en cada reunión desde tu primera semana.",
      "line": "Explícame X como si nunca hubiera oído hablar de ello.",
      "why": "Sin preámbulo y sin explicar por qué no lo sabes ya. No hay nadie aquí delante de quien avergonzarte."
    },
    {
      "situation": "Estás a punto de justificar la pregunta.",
      "line": "(sin preámbulo — pregunta sin más)",
      "why": "Disculparse ante un programa es el mismo encogimiento del que trata Mensajería, con todavía menos motivo."
    },
    {
      "situation": "Tienes toda una lista de estas.",
      "line": "(empieza con la más antigua)",
      "why": "Se sienten enormes por lo mucho que se han cargado, no porque sean difíciles. La lista normalmente es una tarde."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué te cuesta de verdad el hueco?",
      "options": [
        { "text": "Confusión ocasional en reuniones.", "correct": false, "note": "Sobrevivible, y la mayoría de la gente sigue el contenido bien sin el término." },
        { "text": "Tampoco puedes preguntar nada más sobre ello.", "correct": true, "note": "No hay ninguna pregunta de seguimiento disponible sobre algo que no has admitido que no entiendes, así que te quedas callado exactamente en las reuniones donde tenías algo que decir." },
        { "text": "La gente piensa que no te interesa.", "correct": false, "note": "Una consecuencia del silencio, no del hueco." },
        { "text": "Cometes errores al respecto.", "correct": false, "note": "A veces, y la gente normalmente navega alrededor de un término que no ha definido." }
      ],
      "explain": "Y desde fuera, ese silencio parece no tener nada que decir."
    },
    {
      "prompt": "¿Cuál deberías preguntar primero?",
      "options": [
        { "text": "La más relevante para esta semana.", "correct": false, "note": "Sensato y deja a la más antigua donde está, siguiendo haciendo daño." },
        { "text": "La más complicada.", "correct": false, "note": "La dificultad no es lo que las hace pegarse. La antigüedad sí." },
        { "text": "La que menos vergüenza te daría.", "correct": false, "note": "La selección contraria. La vergüenza es el error de clasificación, no la guía." },
        { "text": "La más antigua.", "correct": true, "note": "Se siente enorme por lo mucho que se ha cargado. La lista entera normalmente es una tarde." }
      ],
      "explain": "No hay ningún registro, y nada sale después."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked", "label": "La preguntó", "description": "Puso la pregunta real." },
      { "key": "no_preamble", "label": "Sin preámbulo", "description": "No explicó por qué no lo sabía." },
      { "key": "oldest", "label": "Empezó con una antigua", "description": "Cogió algo cargado durante mucho tiempo." },
      { "key": "plain", "label": "Preguntó con llaneza", "description": "Como si nunca hubiera oído hablar de ello." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una amiga fuera de tu campo",
      "mood": "Interesada.",
      "openness": 5,
      "personality": "Hace preguntas directas y no le importa en absoluto no saber cosas."
    },
    "setting": "Una amiga fuera de tu industria te ha preguntado a qué te dedicas de verdad, y te has topado con una palabra que nunca te han definido.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué significa, sin juzgar.",
      "Trata no saber como completamente normal.",
      "Nunca definas tú el término."
    ],
    "opening_beat": "«¿Qué significa esa palabra, por cierto? La sigues usando.»",
    "success_looks_like": "La persona admite el hueco con llaneza y decide buscarlo en vez de dar rodeos."
  }$j$::jsonb,
  'Hoy, haz la pregunta más antigua de tu lista, sin preámbulo. Apunta cuál era.',
  $j${
    "says": "¿Qué significa esa palabra, por cierto? La sigues usando.",
    "model": {
      "line": "Sinceramente, nunca me lo han explicado. Llevo asintiendo unos dos años.",
      "why": "El hueco es normal y la admisión no cuesta nada aquí. Lo que ha sido costoso son los dos años de no poder preguntar nada más al respecto."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["algo como", "básicamente es cuando", "difícil de explicar", "ya sabes cómo", "una especie de", "depende"], "requirement": "No des rodeos" },
      { "kind": "min_words", "n": 8, "requirement": "Admite el hueco en una frase" },
      { "kind": "max_words", "n": 32, "requirement": "Una admisión, no una confesión" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-free-question', 2,
  'Pregúntalo una tercera vez',
  $md$La primera explicación casi nunca cala. Eso no es un fallo de la explicación — es cómo funciona entender algo genuinamente nuevo, y es igual para todo el mundo.

Lo que es distinto de una persona es qué pasa después. Dices *ah, vale, lo tengo*, porque la alternativa es decir *todavía no lo sigo* a alguien que ya lo ha explicado una vez y está siendo amable al respecto. El segundo intento es incómodo. El tercero no está socialmente disponible en absoluto, para casi nadie.

Así que la mayoría de la gente se queda con la primera explicación, que fue la que no funcionó.

**La jugada:** di *todavía no lo entiendo*, tantas veces como haga falta.

Aquí esa frase no cuesta nada, y es la mayor ventaja individual que tiene esto sobre preguntarle a un compañero. No la velocidad y no la disponibilidad — la capacidad de fallar en entender repetidamente, delante de nada.

Di con precisión qué parte te perdió, porque eso es lo que hace que el próximo intento sea distinto en vez de más alto. *Lo seguí hasta la parte de las dos cuentas.* *Usaste la palabra liquidación y no sé a qué se refiere.* Con una insatisfacción vaga solo consigues una reformulación; con un fallo localizado, consigues una explicación distinta.

Dos peticiones que merece la pena conocer, porque cambian la forma en vez de la redacción. *Dame una analogía* lo mueve a terreno que ya tienes. *Dame un ejemplo concreto con números reales* quita la abstracción, y la abstracción es en lo que fallan la mayoría de las primeras explicaciones.

Y cuando cale, repítelo. *Así que básicamente es X, y la razón por la que importa es Y — ¿es correcto?* Ese es el paso que la gente se salta, y es el que averigua si lo has entendido o simplemente lo has seguido. Esas dos cosas se sienten idénticas desde dentro y son completamente distintas en una reunión.

Si te quedas con una cosa: la tercera explicación normalmente es la que funciona, y solo puedes llegar a ella aquí.$md$,
  $j$[
    {
      "situation": "La explicación no caló.",
      "line": "Todavía no lo entiendo. Lo seguí hasta la parte de las dos cuentas.",
      "why": "Con un fallo localizado consigues una explicación distinta. Con una insatisfacción vaga, consigues la misma reformulada."
    },
    {
      "situation": "Se queda abstracto.",
      "line": "Dame un ejemplo concreto, con números reales.",
      "why": "La abstracción es en lo que fallan la mayoría de las primeras explicaciones, y los números la quitan."
    },
    {
      "situation": "Crees que ha calado.",
      "line": "Así que básicamente es X, y importa porque Y — ¿es correcto?",
      "why": "Repetirlo es lo que separa haberlo entendido de haberlo seguido. Esas dos cosas se sienten idénticas desde dentro."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la ventaja real sobre preguntarle a un compañero?",
      "options": [
        { "text": "Está disponible a medianoche.", "correct": false, "note": "Conveniente, y podrías haberle preguntado al compañero el lunes." },
        { "text": "Explica las cosas mejor.", "correct": false, "note": "A menudo no lo hace. Un compañero conoce tu sistema real." },
        { "text": "Puedes fallar en entender repetidamente.", "correct": true, "note": "El tercer intento no está socialmente disponible con una persona, y el tercer intento normalmente es el que funciona." },
        { "text": "Es más paciente.", "correct": false, "note": "Cerca, y el punto no es su paciencia — es que no hay público que sea paciente contigo." }
      ],
      "explain": "Di qué parte te perdió, para que el próximo intento sea distinto en vez de más alto."
    },
    {
      "prompt": "¿Por qué repetirlo con tus propias palabras?",
      "options": [
        { "text": "Es educado confirmar.", "correct": false, "note": "No hay nadie con quien ser educado. Esto es para ti." },
        { "text": "Te ayuda a recordarlo.", "correct": false, "note": "Un efecto secundario genuino, y no el motivo." },
        { "text": "Hace la explicación más corta la próxima vez.", "correct": false, "note": "No es realmente el mecanismo, y la duración nunca fue el problema." },
        { "text": "Seguirlo y entenderlo se sienten igual.", "correct": true, "note": "Idénticos desde dentro y completamente distintos en una reunión. Repetirlo es lo que los distingue." }
      ],
      "explain": "Y pide una analogía o números reales cuando se quede abstracto."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked_again", "label": "Preguntó otra vez", "description": "No aceptó la primera explicación." },
      { "key": "located", "label": "Dijo qué parte lo perdió", "description": "Nombró el punto del fallo." },
      { "key": "concrete", "label": "Pidió una versión concreta", "description": "Ejemplo, números o analogía." },
      { "key": "said_back", "label": "Lo repitió", "description": "Comprobó el entendimiento contra el seguimiento." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una amiga fuera de tu campo",
      "mood": "Cálida.",
      "openness": 5,
      "personality": "Nota el lo tengo que llega algo demasiado rápido, y pregunta qué parte explicarías de vuelta."
    },
    "setting": "Alguien te ha explicado algo una vez. No seguiste la parte de en medio y acabas de decir que sí.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pídele que lo repita con sus propias palabras.",
      "Trata un hueco como completamente normal cuando se admite.",
      "Nunca vuelvas a explicar tú la cosa."
    ],
    "opening_beat": "«Venga, entonces — repítemelo.»",
    "success_looks_like": "La persona admite qué parte no caló en vez de disimularlo."
  }$j$::jsonb,
  'Hoy, di todavía no lo entiendo al menos dos veces sobre algo. Apunta dónde caló finalmente.',
  $j${
    "says": "Venga, entonces — repítemelo.",
    "model": {
      "line": "No puedo. Seguí la primera parte y la perdí por lo de las dos cuentas, así que voy a preguntar otra vez.",
      "why": "Con un fallo localizado consigues una explicación distinta en vez de una más alta. El tercer intento es el que normalmente funciona, y solo existe donde no cuesta nada."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["lo tengo", "tiene sentido", "creo que entiendo", "sí, claro", "no, lo sigo", "todo bien"], "requirement": "No afirmes haberlo entendido" },
      { "kind": "min_words", "n": 10, "requirement": "Di qué parte te perdió" },
      { "kind": "max_words", "n": 35, "requirement": "Localízalo, no lo narres" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-free-question', 3,
  'Pregunta qué asume todo el mundo',
  $md$Las preguntas de tu lista son las que sabes que no puedes responder. Los huecos más costosos son los que no sabes que tienes — cosas que todo el mundo a tu alrededor absorbió en algún sitio, que nunca se dicen en voz alta precisamente porque todos las tienen.

No puedes buscar esas, porque buscar algo requiere saber que existe.

**La jugada:** pregunta qué se supone que ya sabe alguien en tu posición.

*¿Qué daría por sentado alguien que trabaja en esto que un recién llegado no daría?* *¿Qué nunca se explica la gente de esta industria entre sí?* *Llevo un año en este trabajo — ¿qué suele aprenderse en el primer mes que podría habérseme escapado?*

Esas preguntas funcionan porque invierten la búsqueda. En vez de preguntar sobre una cosa, estás pidiendo la lista de cosas, y la lista es lo que te faltaba.

Las respuestas llegan en tres tipos, y los tres son útiles. Vocabulario que has estado adivinando a medias. Estructura — quién decide de verdad qué, cuáles son las fases de un proceso, a qué se refieren los números que cita la gente. Y convención: qué cuenta como mucho, qué es normal cuestionar, qué es inusual pedir. Ese tercer tipo es el que más vale y casi nunca está escrito en ningún sitio.

Esto funciona fuera del trabajo también, y merece la pena llevarlo a algún sitio donde no se sienta como deberes. Cuáles son las reglas no escritas del club al que te acabas de unir. Qué sabe todo el mundo en este tipo de cena. Qué asume la gente sobre cómo funciona una visita, o una primera cita, o una boda a la que nunca has ido antes.

Una advertencia, que es el bloque cinco llegando pronto: va a responder a esto con confianza incluso donde esté adivinando, especialmente sobre tu oficina en concreto. Trata las respuestas como una lista de candidatos que comprobar en vez de como hechos sobre tu edificio. El valor está en aprender que existe una pregunta, y luego puedes hacerle a una persona la versión pequeña.

Si te quedas con una cosa: pide la lista, no el elemento. No puedes buscar algo que no sabes que está ahí.$md$,
  $j$[
    {
      "situation": "Sospechas que hay huecos que no puedes nombrar.",
      "line": "¿Qué daría por sentado alguien en este trabajo que un recién llegado no daría?",
      "why": "Invierte la búsqueda. Estás pidiendo la lista de cosas en vez de preguntar sobre una cosa."
    },
    {
      "situation": "Quieres la parte que nadie escribe.",
      "line": "¿Qué cuenta como mucho aquí, y qué es normal cuestionar?",
      "why": "La convención es el tipo de respuesta más valioso y casi nunca se registra en ningún sitio."
    },
    {
      "situation": "La respuesta es confiada y sobre tu oficina en concreto.",
      "line": "(candidatos que comprobar, no hechos)",
      "why": "No puede conocer tu edificio. Lo que has ganado es saber que existe la pregunta."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué no puedes simplemente buscar estas?",
      "options": [
        { "text": "Buscarlo requiere saber que existe.", "correct": true, "note": "Estos son los huecos que no sabes que tienes, así que no hay ningún término de búsqueda disponible." },
        { "text": "No están escritas en ningún sitio.", "correct": false, "note": "A menudo cierto de la convención, y muchas están documentadas y aun así nunca se encuentran." },
        { "text": "Son específicas de tu empresa.", "correct": false, "note": "Algunas sí. Muchas son de toda la industria e igual de invisibles." },
        { "text": "Son demasiado básicas para publicarse.", "correct": false, "note": "Las cosas básicas se publican constantemente. Encontrarlas es el problema." }
      ],
      "explain": "Pide la lista, no el elemento."
    },
    {
      "prompt": "¿Qué tipo de respuesta vale más?",
      "options": [
        { "text": "Vocabulario que has estado adivinando a medias.", "correct": false, "note": "Útil, y el que podrías haber conseguido preguntando sobre una palabra concreta." },
        { "text": "Estructura — quién decide qué.", "correct": false, "note": "Valioso y normalmente descubrible observando durante unos meses." },
        { "text": "Convención — qué es normal pedir.", "correct": true, "note": "Qué cuenta como mucho, qué es normal cuestionar. Casi nunca escrito y lo más difícil de adquirir por observación." },
        { "text": "Historia — cómo llegaron así las cosas.", "correct": false, "note": "Interesante, y rara vez cambia qué haces el lunes." }
      ],
      "explain": "Y trata las respuestas confiadas sobre tu oficina en concreto como candidatos que comprobar."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "inverted", "label": "Pidió la lista", "description": "Preguntó qué se asume, no sobre un elemento." },
      { "key": "convention", "label": "Recurrió a la convención", "description": "Qué es normal, no solo qué significan las cosas." },
      { "key": "checked", "label": "Trató las respuestas como candidatos", "description": "No tomó las afirmaciones específicas de la oficina como hechos." },
      { "key": "outside_work", "label": "Lo usó más allá del trabajo", "description": "Lo aplicó a una situación desconocida." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Tom",
      "role": "alguien que lleva allí años",
      "mood": "Amistoso, algo apurado.",
      "openness": 4,
      "personality": "Encantado de explicar cualquier cosa que se le pregunte, y nunca ofrece lo que le resulta obvio a él."
    },
    "setting": "Te has unido a algo nuevo y notas que todos los demás comparten un conjunto de suposiciones que tú no tienes.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a preguntas concretas con utilidad y brevedad.",
      "Nunca ofrezcas contexto que no se te haya pedido.",
      "Nunca sugieras qué debería preguntar la persona."
    ],
    "opening_beat": "«Lo vas a pillar. Todo el mundo lo hace.»",
    "success_looks_like": "La persona pregunta qué suele aprenderse pronto en vez de asentir sin más."
  }$j$::jsonb,
  'Hoy, pregunta qué se supone que sabe la gente en tu posición. Apunta una cosa de la lista que no tenías.',
  $j${
    "beats": [
      {
        "situation": "Te has unido a algo nuevo y notas que hay un conjunto de suposiciones compartidas que no tienes.",
        "prompt": "¿Qué preguntas?",
        "options": [
          { "text": "¿Qué significa este acrónimo en concreto?", "correct": false, "note": "Merece la pena preguntarlo y solo cierra los huecos que ya sabes que tienes." },
          { "text": "¿Puedes explicar cómo funciona todo esto?", "correct": false, "note": "Demasiado grande para responder. Consigues una visión general que podrías haber leído en cualquier sitio." },
          { "text": "¿Qué da por sentado la gente aquí que un recién llegado no daría?", "correct": true, "note": "Invierte la búsqueda — estás pidiendo la lista en vez de preguntar sobre un elemento, y la lista es la parte que te faltaba." },
          { "text": "¿Qué debería leer primero?", "correct": false, "note": "Razonable, y las listas de lectura tienden a cubrir las cosas documentadas en vez de las asumidas." }
        ]
      },
      {
        "situation": "Responde con confianza sobre cómo se toman las decisiones en tu empresa en concreto.",
        "prompt": "¿Qué vale esa respuesta?",
        "options": [
          { "text": "Nada — no puede conocer tu empresa.", "correct": false, "note": "Demasiado fuerte. Te ha dicho qué preguntas existen, que es la mayor parte del valor." },
          { "text": "Una lista de candidatos que comprobar con una persona.", "correct": true, "note": "No puede conocer tu edificio. Lo que has ganado es saber que la pregunta está ahí, y la versión pequeña ahora se puede preguntar." },
          { "text": "Tanto como cualquier otra cosa que diga.", "correct": false, "note": "No — es menos fiable precisamente aquí, y su confianza no cambia entre las dos cosas." },
          { "text": "Suficiente para actuar si suena plausible.", "correct": false, "note": "La plausibilidad es lo que produce de forma más fiable, que es el problema, no la tranquilidad." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-free-question', 4,
  'Dilo en la sala',
  $md$Entender algo en privado es la mitad del valor, y es la mitad que no cambia nada que nadie pueda ver.

Este es el error típico de todo este bloque. Cierras los huecos, sigues la reunión como es debido por primera vez en meses, y dices exactamente lo mismo que antes. Desde fuera, no ha pasado nada.

**La jugada:** convierte lo que buscaste en algo que dices en voz alta.

La forma que funciona es una pregunta que contiene lo que encontraste. *He estado leyendo sobre el proceso de liquidación — ¿es correcto que solo entra en vigor por encima de cierta cantidad?* Tres cosas son ciertas de esa frase a la vez. Muestra preparación, que es el tipo de credibilidad más barato que hay. Es una pregunta, así que no necesita confianza y no puede estar mal. Y es genuinamente útil, porque la mitad de las veces la respuesta es *no exactamente*, y esa es la parte que no podrías haber buscado.

Fíjate en que esta es la misma jugada que en todos los demás sitios de la app. Trabajo dice ven a una reunión con una cosa preparada. Small talk dice que el material es lo que ya tienes. Aquí es de donde viene el material.

**No anuncies la fuente.** Nada de *le pregunté a una IA sobre esto* ni de *estuve leyendo sobre esto anoche*. Nadie dice de dónde lo sacó. La información es la contribución.

**Úsalo en un día o dos.** Un hueco que cerraste el martes y del que no dijiste nada para el viernes se ha vuelto a absorber. Decirlo en voz alta es lo que lo hace tuyo — el mismo motivo por el que el cuarto bloque quiere las cosas ensayadas en voz alta en vez de en tu cabeza.

**Empieza con la versión pequeña.** No estás obligado a construir un argumento. *¿Es eso lo mismo que X?* o *¿Entonces eso significa que Y está incluido?* es suficiente, y es una contribución completa.

Si te quedas con una cosa: una respuesta que nadie te oye usar no ha cambiado nada. Di la versión pequeña en dos días.$md$,
  $j$[
    {
      "situation": "Acabas de cerrar un hueco que tenías desde hace un año.",
      "line": "He estado leyendo sobre esto — ¿es correcto que solo entra en vigor por encima de cierta cantidad?",
      "why": "Muestra preparación, no necesita confianza porque es una pregunta, y la mitad de las veces la respuesta es no exactamente."
    },
    {
      "situation": "Estás a punto de decir de dónde lo sacaste.",
      "line": "(no lo hagas — nadie lo dice nunca)",
      "why": "La información es la contribución. La fuente no es parte de ella."
    },
    {
      "situation": "Se siente demasiado pequeño como para merecer la pena decirlo.",
      "line": "¿Entonces eso significa que Y está incluido?",
      "why": "Una pregunta pequeña es una contribución completa, y es de donde empieza cada una más grande."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué ponerlo en forma de pregunta?",
      "options": [
        { "text": "Las preguntas son más educadas.", "correct": false, "note": "La educación no es el mecanismo, y una afirmación sería perfectamente educada." },
        { "text": "No puede estar mal, y muestra preparación.", "correct": true, "note": "No necesita confianza, y la mitad de las veces la respuesta es no exactamente — que es la parte que no podrías haber buscado." },
        { "text": "A la gente le gusta más que le pregunten cosas.", "correct": false, "note": "Generalmente cierto y no es por lo que funciona esto." },
        { "text": "Evita sonar como si estuvieras alardeando.", "correct": false, "note": "Un beneficio secundario. La parte estructural es que una pregunta equivocada igualmente cala." }
      ],
      "explain": "Aquí es de donde viene la cosa preparada de Trabajo."
    },
    {
      "prompt": "¿Cuánto tiempo lo puedes dejar?",
      "options": [
        { "text": "Hasta que salga de forma natural.", "correct": false, "note": "Puede que no salga, y esperar el momento natural es cómo mueren la mayoría de estas." },
        { "text": "Hasta que tengas confianza al respecto.", "correct": false, "note": "La confianza llega de haberlo dicho, no antes." },
        { "text": "Un día o dos.", "correct": true, "note": "Un hueco cerrado el martes sin nada dicho para el viernes se ha vuelto a absorber. Decirlo en voz alta es lo que lo hace tuyo." },
        { "text": "No importa cuándo.", "correct": false, "note": "Sí importa — el mismo motivo por el que el bloque cuatro quiere las cosas ensayadas en voz alta en vez de en tu cabeza." }
      ],
      "explain": "Y nunca anuncies la fuente. Nadie dice de dónde lo sacó."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_it", "label": "Lo dijo en voz alta", "description": "Lo usó en una sala real." },
      { "key": "as_question", "label": "Lo puso como pregunta", "description": "No necesitó confianza para decirlo." },
      { "key": "no_source", "label": "No nombró la fuente", "description": "La información era la contribución." },
      { "key": "quickly", "label": "En un día o dos", "description": "No esperó a un momento natural." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Tom",
      "role": "un compañero dirigiendo la reunión",
      "mood": "Eficiente.",
      "openness": 4,
      "personality": "Responde a las preguntas como es debido y avanza rápido si nadie dice nada."
    },
    "setting": "Una reunión donde acaba de salir lo que finalmente buscaste anoche.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a una pregunta con franqueza, corrigiéndola levemente si no está del todo bien.",
      "Avanza la reunión si no se dice nada.",
      "Nunca invites a la persona a hablar."
    ],
    "opening_beat": "«Vale — ¿algo sobre el tema de la liquidación antes de seguir?»",
    "success_looks_like": "La persona pregunta la versión pequeña de lo que buscó."
  }$j$::jsonb,
  'Hoy, di en voz alta algo que buscaste esta semana. Apunta la frase y qué volvió.',
  $j${
    "says": "Vale — ¿algo sobre el tema de la liquidación antes de seguir?",
    "model": {
      "line": "Una cosa — he estado leyendo sobre esto. ¿Es correcto que solo entra en vigor por encima de cierta cantidad?",
      "why": "La preparación es la credibilidad más barata que hay, una pregunta no puede estar mal, y la mitad de las veces la respuesta es no exactamente, que es la parte que no podrías haber buscado."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Ponlo como pregunta" },
      { "kind": "forbids_any", "words": ["chatgpt", "claude", "una ia", "le pregunté a un bot", "perdona", "esto puede ser una tontería", "probablemente mal", "puede que me equivoque"], "requirement": "No nombres la fuente ni te disculpes" },
      { "kind": "max_words", "n": 30, "requirement": "La versión pequeña" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-free-question', 5,
  'Buscarlo no es hacer trampa',
  $md$Hay una preocupación debajo de todo este bloque que merece la pena sacar y mirar, porque la gente rara vez la dice en voz alta: que usarlo así es una especie de fraude. Que llegas a la reunión capaz de hablar de algo que no sabías de verdad, y que eso es una forma de fingir.

Merece la pena responderla como es debido en vez de descartarla sin más.

**La jugada:** date cuenta de que la alternativa a prepararte no era la honestidad. Era el silencio.

Nadie ha pensado nunca peor de un compañero por haber leído algo de antemano. Eso no es una excepción a regañadientes — es la definición de estar preparado, y es una cualidad que la gente admira abiertamente en todo el mundo excepto en sí misma. La persona que buscó algo antes de una reunión no está haciendo pasar conocimiento prestado por propio; es alguien que hizo la lectura.

Tres versiones concretas de la preocupación, y de qué trata cada una en realidad.

*No lo averigüé yo mismo.* Casi nadie averigua nada por sí mismo. Se lo dijo un compañero, o lo leyó, o lo aprendió en un proyecto. La ruta por la que llegaste a saber algo no es una propiedad del conocimiento.

*No podría defenderlo.* Entonces di la versión pequeña, como plantea la lección anterior. Una pregunta no necesita defenderse, y *creo que sí, pero acabo de leer sobre esto* es una frase completamente normal.

*Se siente como una ventaja injusta.* Es una ventaja, y todo el mundo tiene la misma. No estar dispuesto a usar una herramienta que todo el mundo más está usando no es integridad, es una desventaja que has elegido y que nadie ha notado.

Hay una línea real, y está en el último bloque: cuando el esfuerzo es el mensaje, externalizarlo es un problema genuino. Entender algo no es eso. Nadie quería que estuvieras confundido como gesto de sinceridad.

Si te quedas con una cosa: prepararse no es fingir. La alternativa no era ser honestamente ignorante, era volver a estar callado.$md$,
  $j$[
    {
      "situation": "Se siente como llegar con conocimiento prestado.",
      "line": "(eso se llama estar preparado)",
      "why": "Una cualidad que la gente admira abiertamente en todo el mundo excepto en sí misma."
    },
    {
      "situation": "Te preocupa no poder defenderlo.",
      "line": "Creo que sí, pero acabo de leer sobre esto.",
      "why": "Una frase completamente normal, y una pregunta nunca necesitó defenderse de entrada."
    },
    {
      "situation": "Se siente como una ventaja injusta.",
      "line": "(todo el mundo tiene la misma)",
      "why": "Rechazar una herramienta que todo el mundo más usa no es integridad. Es una desventaja que nadie ha notado que has tomado."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál era la alternativa real a prepararse?",
      "options": [
        { "text": "Preguntarle a un compañero en su lugar.", "correct": false, "note": "A veces disponible, y es lo que este bloque existe porque no hiciste." },
        { "text": "Volver a estar callado.", "correct": true, "note": "No ignorancia honesta — silencio. Nadie quería que estuvieras confundido como gesto de sinceridad." },
        { "text": "Averiguarlo tú mismo con el tiempo.", "correct": false, "note": "La ruta hacia saber algo no es una propiedad del conocimiento, y esta ruta lleva años." },
        { "text": "Admitir que no sabías en la reunión.", "correct": false, "note": "Una jugada buena y mucho más difícil, que es por lo que seguía sin pasar." }
      ],
      "explain": "Prepararse no es fingir."
    },
    {
      "prompt": "¿Dónde está la línea real?",
      "options": [
        { "text": "Cuando no podías explicarlo después.", "correct": false, "note": "Entonces di la versión pequeña. Eso es un motivo para escalar la afirmación, no para quedarte callado." },
        { "text": "Cuando es el campo de otra persona.", "correct": false, "note": "Leer sobre el campo de otra persona es cómo funciona la colaboración." },
        { "text": "Cuando no lo verificaste.", "correct": false, "note": "Un motivo para comprobar, y el bloque cinco trata exactamente de eso." },
        { "text": "Cuando el esfuerzo era el mensaje.", "correct": true, "note": "La disculpa, el pésame, el agradecimiento. Entender algo no es eso." }
      ],
      "explain": "El último bloque traza esa línea como es debido."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "used_it", "label": "Usó lo que preparó", "description": "No lo retuvo por escrúpulo." },
      { "key": "scaled", "label": "Escaló la afirmación con honestidad", "description": "Dijo cuán recientemente lo aprendió, si se le preguntó." },
      { "key": "no_apology", "label": "No se disculpó por prepararse", "description": "Lo trató como normal." },
      { "key": "line", "label": "Mantuvo la línea real", "description": "Sabía dónde importaría externalizar." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya",
      "role": "una amiga fuera de tu campo",
      "mood": "Ligera.",
      "openness": 5,
      "personality": "Genuinamente curiosa, sin que le importe en absoluto la respuesta, y desconcertada por la culpa."
    },
    "setting": "Una amiga te ha preguntado cómo sabías algo que dijiste en una reunión, y te sientes extrañamente pillado.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "No te impresiones en absoluto con la idea de que prepararse es hacer trampa.",
      "Pregunta cuál habría sido la alternativa.",
      "Nunca tranquilices a la persona como si le dieras consejo."
    ],
    "opening_beat": "«¿Cómo sabías todo eso, por cierto?»",
    "success_looks_like": "La persona dice que lo leyó, sin disculparse por ello."
  }$j$::jsonb,
  'Hoy, usa algo que preparaste sin dar rodeos sobre de dónde vino. Apunta cómo fue.',
  $j${
    "beats": [
      {
        "situation": "Usaste algo en una reunión que habías leído la noche anterior, y te sientes algo fraudulento.",
        "prompt": "¿Qué está entendiendo mal esa sensación?",
        "options": [
          { "text": "Nadie se dio cuenta, así que no importa.", "correct": false, "note": "Si alguien se dio cuenta no es la pregunta. La preocupación sobreviviría a que se dieran cuenta." },
          { "text": "Todo el mundo lo hace, así que está bien.", "correct": false, "note": "Cierto y no resuelve nada por sí solo — muchas cosas comunes siguen estando mal." },
          { "text": "Sí lo entendiste para cuando lo dijiste.", "correct": false, "note": "Bien, y la preocupación va sobre la ruta, no sobre el entendimiento." },
          { "text": "La alternativa era el silencio, no la honestidad.", "correct": true, "note": "Nadie quería que estuvieras confundido como gesto de sinceridad. Leer de antemano es la definición de estar preparado." }
        ]
      },
      {
        "situation": "Alguien hace una pregunta de seguimiento que no puedes responder.",
        "prompt": "¿Qué dices?",
        "options": [
          { "text": "Acabo de leer sobre esto, así que no estoy seguro.", "correct": true, "note": "Una frase completamente normal. Escalar la afirmación con honestidad es la respuesta a no-podría-defenderlo, y no cuesta nada." },
          { "text": "Adivina, y espera que sea más o menos correcto.", "correct": false, "note": "Esta es la versión que de verdad merecería el sentimiento de culpa." },
          { "text": "Di que lo vas a comprobar y volverás.", "correct": false, "note": "Bien hasta cierto punto y esquiva decir la verdad, que estaba disponible." },
          { "text": "Admite que lo buscaste anoche.", "correct": false, "note": "Honesto, y convierte la fuente en el tema cuando la información era la contribución." }
        ]
      }
    ]
  }$j$::jsonb
);
