-- Spanish: Hacer amigos, track 3 — La segunda vez, y la tercera.
--
-- Conventions as prior tracks: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partners "Sam" (lessons 1, 4, 5) and "Alex" (lessons 2, 3) carry no
-- `sex` field; masculine agreement used by default, as established
-- elsewhere in this topic.

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

select pg_temp.es_lesson('the-second-time', 1,
  'Alguien tiene que ir dos veces',
  $md$Esta es la forma que termina la mayoría de las amistades adultas antes de que empiecen, y no pasa nada malo en ningún momento.

Pasa un café. Las dos personas lo disfrutan. Las dos se van a casa pensando *qué bien, deberíamos repetir.* Y luego nada, durante ocho meses, hasta que os encontráis y decís *tenemos que repetir eso* con exactamente la misma sinceridad que la primera vez.

Lo que pasó es que los dos estabais esperando pruebas de que se os quería ahí. Tú propusiste una vez, la otra persona dijo que sí y lo pasó bien, y ahora le toca a ella — porque proponer dos veces seguidas se siente como ser el demasiado interesado, y ser el demasiado interesado se siente como un riesgo.

**La jugada:** propón otra vez de todas formas, y deja de tratar a quién le toca como información.

Turnarse es una regla importada de otro sitio. Nadie la acordó, nadie la está contando, y produce un punto muerto invisible para las dos partes: cada uno tiene pruebas de que al otro le gustó y ninguna prueba de que quiera más, porque lo único que produciría esa prueba es justo lo que los dos estáis esperando.

Merece la pena comprobar esto contra tus amistades ya existentes, porque la comprobación es rápida y zanja el asunto. Piensa en quién organizaba las cosas en los primeros meses de las amistades que más valoras. En varias de ellas no fuiste tú. Ahora pregúntate si alguna vez, ni una sola, has pensado peor de esa persona por ello.

No lo has hecho. Nadie lo ha hecho. Ese miedo es completamente unidireccional — es vívido desde dentro y no existe desde fuera, que es la definición de algo que no merece la pena tener en cuenta.

Si te quedas con una cosa: a quién le toca no es información. Es una regla que heredaste y te está costando gente que te gustaba.$md$,
  $j$[
    {
      "situation": "Pasó un café, fue bueno, y eso fue hace tres meses.",
      "line": "(los dos estáis esperando a que os quieran ahí)",
      "why": "Cada uno tiene pruebas de que al otro le gustó y ninguna de que quiera más — porque lo único que produce esa prueba es justo lo que los dos estáis esperando."
    },
    {
      "situation": "Se siente como que le toca a ella.",
      "line": "(nadie acordó turnos)",
      "why": "Es una regla importada de otro sitio que nadie está contando, y produce un punto muerto invisible para las dos personas."
    },
    {
      "situation": "Te preocupa parecer demasiado interesado.",
      "line": "(nombra a una persona de quien pensaras peor por organizar cosas)",
      "why": "No hay ninguna. El miedo es vívido desde dentro y no existe desde fuera."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué termina de verdad la mayoría de las amistades adultas antes de que empiecen?",
      "options": [
        { "text": "Uno de los dos no estaba tan interesado.", "correct": false, "note": "A los dos les gustó, que es lo que hace esto tan desperdiciado. El desinterés al menos sería un motivo." },
        { "text": "Las dos personas esperando a que las quieran ahí.", "correct": true, "note": "Cada uno tiene pruebas de que al otro le fue bien y ninguna de que quiera más, porque producir esa prueba requiere el movimiento que ninguno de los dos hace." },
        { "text": "La vida se puso ajetreada.", "correct": false, "note": "Lo que se dice después. Ocho meses contienen muchos jueves para los dos." },
        { "text": "Ya tiene suficientes amigos.", "correct": false, "note": "La explicación a la que recurre la gente, y rara vez es cierta — la mayoría de los adultos aceptarían otro buen amigo." }
      ],
      "explain": "A quién le toca no es información. Es una regla heredada que nadie está contando."
    },
    {
      "prompt": "¿Cómo zanjas la cuestión de parecer demasiado interesado?",
      "options": [
        { "text": "Acepta que algo de riesgo es inevitable.", "correct": false, "note": "Suena valiente y deja el miedo intacto. Hay una comprobación que lo disuelve en su lugar." },
        { "text": "Alterna estrictamente, para que nunca sea unilateral.", "correct": false, "note": "Esa es la regla que causa el problema, formalizada." },
        { "text": "Pregúntate quién organizaba las cosas al principio en las amistades que valoras.", "correct": true, "note": "En varias no fuiste tú — y nunca has pensado peor de ellos por ello. El miedo solo existe desde dentro." },
        { "text": "Espera un intervalo decente antes de volver a preguntar.", "correct": false, "note": "Los intervalos son cómo pasan los ocho meses. Nadie te está cronometrando." }
      ],
      "explain": "Es unidireccional: vívido desde dentro, inexistente desde fuera."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "went_again", "label": "Propuso otra vez", "description": "No esperó a que le tocara a la otra persona." },
      { "key": "no_scorekeeping", "label": "Dejó de contar turnos", "description": "Trató a quién le tocaba como irrelevante." },
      { "key": "checked", "label": "Comprobó el miedo", "description": "Puso a prueba la preocupación de parecer demasiado interesado contra amistades reales." },
      { "key": "soon", "label": "Lo hizo pronto", "description": "No dejó pasar un intervalo decente." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un viejo amigo con quien lo estás hablando",
      "mood": "Sin prisa.",
      "openness": 5,
      "personality": "Pregunta quién organizaba las cosas al principio de tus amistades ya existentes, y espera a que te des cuenta de la respuesta."
    },
    "setting": "Tomaste un café muy bueno con alguien hace once semanas. Ninguno de los dos ha hecho nada desde entonces.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta por los primeros días de las amistades ya existentes de la persona si sale el tema de los turnos.",
      "Alégrate con naturalidad ante una decisión de simplemente preguntarle.",
      "Nunca digas que los turnos no importan — deja que la persona llegue sola a esa conclusión."
    ],
    "opening_beat": "«Once semanas. ¿A quién crees que le toca?»",
    "success_looks_like": "La persona deja de tratar los turnos como significativos y decide proponer."
  }$j$::jsonb,
  'Hoy, escríbele a alguien a quien técnicamente no te toca a ti. Apunta a quién y cuánto tiempo llevaba.',
  $j${
    "beats": [
      {
        "situation": "Un café muy bueno, hace once semanas. Ninguno de los dos ha hecho nada desde entonces.",
        "prompt": "¿Qué pasó?",
        "options": [
          { "text": "No lo disfrutó tanto como tú.", "correct": false, "note": "Contradicho por la propia tarde, y es la lectura que termina las cosas para siempre." },
          { "text": "Los dos estabais esperando a que os quisieran ahí.", "correct": true, "note": "Cada uno tiene pruebas de que al otro le fue bien y ninguna de que quiera más — porque producir esa prueba necesita el movimiento que ninguno de los dos hace." },
          { "text": "Fue algo puntual y está bien.", "correct": false, "note": "Se convirtió en eso porque nadie se movió. Nada en ello era inherentemente puntual." },
          { "text": "Lo dejaste pasar demasiado como para poder ahora.", "correct": false, "note": "Once semanas no son nada, y nadie está contando. Un mensaje hoy sería del todo normal." }
        ]
      },
      {
        "situation": "Se siente como que le toca a ella, y volver a proponer te convertiría en el demasiado interesado.",
        "prompt": "¿Cómo zanjas eso?",
        "options": [
          { "text": "Espera un poco más y ve si se pone en contacto.", "correct": false, "note": "Eso es el punto muerto continuando, y es cómo once semanas se convirtieron en once semanas." },
          { "text": "Pregunta, pero deja claro que te da igual una cosa u otra.", "correct": false, "note": "Suavizar la petición para que cueste menos. Sobre todo hace que sea más fácil rechazarla y más difícil aceptarla." },
          { "text": "Acepta algo de riesgo y hazlo de todas formas.", "correct": false, "note": "Valiente, y deja el miedo intacto para la próxima vez. Hay una comprobación que lo disuelve." },
          { "text": "Nombra a alguien de quien hayas pensado peor por organizar cosas.", "correct": true, "note": "No puedes. Nadie puede. El miedo es vívido desde dentro y no existe desde fuera, lo que hace que no merezca la pena tenerlo en cuenta." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-second-time', 2,
  'El pesado no existe',
  $md$Lo que impide la segunda invitación merece que se le mire directamente, porque es inusualmente fácil de desmentir.

El miedo es quedar como *un pesado* — la persona que está un poco demasiado disponible, que siempre sugiere cosas, que lo quiere más. Es un personaje social concreto y vívido, y casi todo el mundo puede imaginárselo.

**La jugada:** intenta nombrar uno real.

Repasa a la gente que conoces y encuentra a alguien de quien hayas pensado peor en privado por organizar cosas, responder rápido, o alegrarse de verte. La mayoría de la gente no puede dar ni un solo nombre. Lo que produce en su lugar es un pavor general, que es un objeto completamente distinto y que nunca se ha pegado a una persona real.

Hay una versión real, y merece la pena separarla para que el miedo no pueda tomar prestada su ropa. Lo que le molesta a la gente no es el entusiasmo — es la presión. Alguien que pide más de lo que has ofrecido, que te hace responsable de su noche, que se toma un rechazo como algo personal y te lo hace saber. Nada de eso es proponer un café dos veces.

La diferencia está completamente en lo que pasa después de un no. Cálido sin presión significa proponer, aceptar lo que vuelva sin comentarios, y seguir igual de amistoso. Haz eso y puedes invitar a alguien tan a menudo como quieras, porque nada de eso le cuesta nada.

Y la asimetría merece la pena tenerla delante. Invitar de más tiene un peor caso, que es estar un poco demasiado disponible para alguien a quien no le importaba. Invitar de menos también tiene un peor caso, y es el que ya estás viviendo: cada amistad que no empezó, en silencio, sin que nadie supiera nunca que estaba disponible.

Si te quedas con una cosa: el entusiasmo no es lo que le molesta a la gente. La presión sí, y es fácil no aplicarla.$md$,
  $j$[
    {
      "situation": "Te preocupa quedar como un pesado.",
      "line": "(nombra uno real)",
      "why": "La mayoría de la gente no puede dar ni un solo nombre. Lo que tienen es un pavor general, que nunca se ha pegado a una persona real."
    },
    {
      "situation": "Quieres saber dónde está la línea de verdad.",
      "line": "(es la presión, no el entusiasmo)",
      "why": "Lo que le molesta a la gente es que le hagan responsable de tu noche, o que se tome un rechazo como algo personal. Proponer un café dos veces no es ninguna de las dos cosas."
    },
    {
      "situation": "Ha dicho que no al jueves.",
      "line": "No pasa nada — otra vez será.",
      "why": "Toda la diferencia está en lo que pasa después de un no. Acéptalo sin comentarios, sigue igual de cálido, y puedes invitar tan a menudo como quieras."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué le molesta de verdad a la gente?",
      "options": [
        { "text": "El entusiasmo.", "correct": false, "note": "El entusiasmo es agradable de recibir, y casi nadie se ha quejado nunca de él." },
        { "text": "La presión.", "correct": true, "note": "Que te hagan responsable de la noche de alguien, o que se tome un rechazo como algo personal. Proponer un café dos veces no es ninguna de esas dos cosas." },
        { "text": "Que te pregunten demasiado a menudo.", "correct": false, "note": "La frecuencia está bien si cada petición se puede rechazar libremente. Lo que pasa después del no es lo que lo decide todo." },
        { "text": "La gente que necesita amigos.", "correct": false, "note": "Una historia cruel que la gente se cuenta a sí misma sobre su propia posición, y no algo que los demás estén buscando de verdad." }
      ],
      "explain": "Cálido sin presión no le cuesta nada a la otra persona, y se puede repetir indefinidamente."
    },
    {
      "prompt": "¿Cuál es el peor caso de invitar de menos?",
      "options": [
        { "text": "Menos amigos de los que te gustaría.", "correct": false, "note": "Cierto y dicho de forma tan general que no hace mella. Di qué pasa de verdad." },
        { "text": "Pareces distante.", "correct": false, "note": "Un coste para tu reputación, y la mitad menor. El coste real no va sobre cómo quedas." },
        { "text": "No mucho — conservas tu dignidad.", "correct": false, "note": "La dignidad nunca estuvo en juego. Ese planteamiento es el miedo defendiéndose." },
        { "text": "Amistades que nunca empezaron, sin que nadie supiera que estaban disponibles.", "correct": true, "note": "Silencioso, acumulativo, y el estado en el que ya está la mayoría de quienes leen esto — lo que lo convierte en el peor de los dos." }
      ],
      "explain": "Invitar de más arriesga estar un poco demasiado disponible para alguien a quien no le importaba."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "tested", "label": "Puso a prueba el miedo", "description": "Intentó nombrar a una persona real de quien pensara peor." },
      { "key": "separated", "label": "Separó la presión del entusiasmo", "description": "Localizó dónde está de verdad la línea." },
      { "key": "clean_no", "label": "Aceptó un no con limpieza", "description": "Aceptó un rechazo sin comentarios y se mantuvo cálido." },
      { "key": "asked_anyway", "label": "Preguntó de todas formas", "description": "No dejó que el miedo decidiera." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Alex",
      "role": "alguien con quien tomaste un café una vez",
      "mood": "Con prisa, amistoso.",
      "openness": 4,
      "personality": "Genuinamente ocupado y genuinamente interesado. Se anima considerablemente cuando un rechazo se toma a la ligera, y se incomoda si se le da vueltas."
    },
    "setting": "Sugeriste el jueves. No puede el jueves y no ha ofrecido nada más.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Anímate y ofrece tú un día si el rechazo se toma a la ligera y sin comentarios.",
      "Ponte incómodo y vago si la persona se disculpa, se explica de más o presiona.",
      "Nunca ofrezcas un día alternativo sin que te lo pidan en tu primera respuesta."
    ],
    "opening_beat": "«Ah, no puedo el jueves — perdona.»",
    "success_looks_like": "La persona se lo toma a la ligera y deja la puerta abierta sin presionar."
  }$j$::jsonb,
  'Hoy, acepta un pequeño rechazo con una sola frase ligera y sin ninguna explicación de seguimiento. Apunta qué dijiste.',
  $j${
    "says": "Ah, no puedo el jueves — perdona.",
    "model": {
      "line": "No pasa nada — otra vez será.",
      "why": "Toda la diferencia entre cálido y presionar está en lo que pasa después de un no. Tomado a la ligera y sin comentarios, no le cuesta nada, que es lo que te permite volver a preguntar."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["perdona", "no pasa nada si", "solo estaba", "si prefieres no", "seguramente", "lo entiendo si", "hice algo", "demasiado"], "requirement": "Sin presión, sin disculpa, sin darle vueltas" },
      { "kind": "max_words", "n": 18, "requirement": "Una frase ligera" },
      { "kind": "max_questions", "n": 0, "requirement": "No vuelvas a preguntar de inmediato" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-second-time', 3,
  'Conviértelo en algo fijo',
  $md$Cada invitación es una pequeña decisión, y las pequeñas decisiones son lo que impide que las cosas pasen. La forma de evitarlo es tomar la decisión una sola vez.

**La jugada:** convierte el segundo o tercer encuentro en algo regular, en voz alta.

*¿Y si sencillamente lo hacemos algo mensual?* es una frase, se pregunta una vez, y elimina todo el problema de organizar durante un año. También elimina la pregunta de los turnos, la pregunta de a quién le toca moverse, y el hueco de ocho meses — nada de lo cual hay que resolver individualmente una vez que hay un arreglo fijo.

La gente rara vez lo dice porque suena a un gran compromiso. Es justo lo contrario: algo fijo es la versión de *menor* esfuerzo de una amistad, y es cómo funcionan de verdad la mayoría de las amistades largas entre adultos ocupados. El primer martes del mes. Café después de la clase, cada semana. El mismo bar de camino a casa siempre que los dos estéis por ahí.

Engánchalo a algo que ya esté pasando si puedes, porque eso elimina hasta el paso de la agenda. *¿Te quedas a tomar una después?* preguntado cada semana se convierte en algo fijo sin que nadie proponga nunca uno, y no cuesta absolutamente nada.

Mantenlo pequeño y frecuente en vez de grande y raro. Una hora al mes gana a toda una noche dos veces al año, porque lo que estás construyendo necesita repetición y no intensidad — que es el mismo principio del que trataba el primer bloque de este tema, aplicado a una persona en vez de a una sala.

Y sobrevive a que os lo saltéis. Esa es la parte infravalorada: con un arreglo fijo, un mes que os saltéis los dos es un mes saltado y no el final del contacto, porque el siguiente ya existe. Una amistad sin ritmo tiene que reiniciarse desde cero cada vez.

Si te quedas con una cosa: pregunta una vez y no organices nada más durante un año.$md$,
  $j$[
    {
      "situation": "Habéis tomado dos buenos cafés y estás a punto de organizar un tercero.",
      "line": "¿Y si sencillamente lo hacemos algo mensual?",
      "why": "Una frase, preguntada una vez, que elimina el problema de organizar, el problema de los turnos y el hueco de ocho meses de golpe."
    },
    {
      "situation": "Ya la ves cada semana en una clase.",
      "line": "¿Te quedas a tomar una después?",
      "why": "Preguntado cada semana se convierte en algo fijo sin que nadie proponga nunca uno, y se salta la agenda por completo."
    },
    {
      "situation": "Estás considerando en su lugar una gran cena cada pocos meses.",
      "line": "(una hora al mes gana a una noche dos veces al año)",
      "why": "Lo que estás construyendo necesita repetición y no intensidad. Ese es el primer bloque de este tema, aplicado a una persona."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué funciona tan bien un arreglo fijo?",
      "options": [
        { "text": "Demuestra compromiso.", "correct": false, "note": "Cómo se lee, y es el motivo por el que la gente duda, no el motivo por el que funciona." },
        { "text": "La decisión se toma una vez en vez de cada vez.", "correct": true, "note": "Elimina el organizar, los turnos y la pregunta de a quién le toca en una sola frase — ninguna de las cuales necesita resolverse individualmente después." },
        { "text": "Lo mete en la agenda.", "correct": false, "note": "Un mecanismo de ello, y el beneficio es mayor que la entrada en el calendario." },
        { "text": "Hace que sea más difícil cancelar.", "correct": false, "note": "Debería ser fácil de cancelar. Su resiliencia viene de que el siguiente ya existe, no de la obligación." }
      ],
      "explain": "Pregunta una vez, no organices nada durante un año."
    },
    {
      "prompt": "¿Cuál es el beneficio infravalorado?",
      "options": [
        { "text": "La ves más.", "correct": false, "note": "Cierto y obvio. Hay un beneficio de segundo orden que importa más con los años." },
        { "text": "Se convierte en parte de tu rutina.", "correct": false, "note": "Cerca, y describe la sensación en vez de la propiedad que protege la amistad." },
        { "text": "Uno saltado es solo uno saltado.", "correct": true, "note": "El siguiente ya existe, así que no hay que reiniciar nada. Una amistad sin ritmo tiene que reconstruirse desde cero cada vez." },
        { "text": "Ninguno de los dos tiene que seguir sugiriendo cosas.", "correct": false, "note": "Ese es el beneficio principal, no el infravalorado." }
      ],
      "explain": "El ritmo es lo que hace que una amistad sobreviva a un mal mes."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "proposed_rhythm", "label": "Propuso un ritmo", "description": "Sugirió hacerlo regular en vez de organizar uno más." },
      { "key": "small_frequent", "label": "Pequeño y frecuente", "description": "Una hora a menudo en vez de una noche rara vez." },
      { "key": "attached", "label": "Lo enganchó a algo", "description": "Lo colgó de algo ya existente cuando fue posible." },
      { "key": "easy_to_miss", "label": "Lo hizo fácil de saltarse", "description": "Lo dejó con poca obligación para que saltárselo no cueste nada." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Alex",
      "role": "alguien con quien ya has tomado café dos veces",
      "mood": "Cálida, a punto de irse.",
      "openness": 4,
      "personality": "Entusiasta con cualquier cosa que elimine trámites. Dice que sí con rapidez a un ritmo y de forma vaga a otro encuentro puntual."
    },
    "setting": "El final de vuestro segundo café. Ha ido bien otra vez y los dos os estáis poniendo los abrigos.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Di que sí con entusiasmo real a cualquier propuesta de ritmo.",
      "Responde a otra sugerencia puntual con un sí vago y empieza a irte.",
      "Nunca propongas tú un ritmo."
    ],
    "opening_beat": "«Se ha pasado rápido. ¿Lo mismo en algún momento?»",
    "success_looks_like": "La persona propone hacerlo regular en vez de organizar uno más."
  }$j$::jsonb,
  'Hoy, propón hacer algo regular en vez de organizarlo otra vez. Apunta qué sugeriste.',
  $j${
    "says": "Se ha pasado rápido. ¿Lo mismo en algún momento?",
    "model": {
      "line": "¿Y si sencillamente lo hacemos el primer martes del mes y dejamos de organizarlo?",
      "why": "Una frase, preguntada una vez, que elimina el organizar, los turnos y el hueco de ocho meses de golpe. Algo fijo es la versión de menor esfuerzo de una amistad, no el mayor compromiso."
    },
    "checks": [
      { "kind": "contains_any", "words": ["cada", "mensual", "semanal", "primer martes", "misma hora", "regular", "fijo", "cada mes", "quincenal"], "requirement": "Propón un ritmo, no otro encuentro puntual" },
      { "kind": "forbids_any", "words": ["un día de estos", "en algún momento", "pronto", "dentro de unas semanas", "deberíamos"], "requirement": "No otro día de estos" },
      { "kind": "max_words", "n": 25, "requirement": "Una frase" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-second-time', 4,
  'Tres o cuatro veces es el umbral',
  $md$Ayuda enormemente saber cuánto tiempo lleva esto, porque la alternativa es juzgarlo cada semana contra un estándar que nada podría cumplir todavía.

Hacia la tercera o cuarta vez que ves a alguien fuera del contexto en el que lo conociste, deja de ser una serie de citas organizadas y se convierte en una amistad. Antes de eso, cada encuentro es un pequeño evento que alguien organizó. Después, sois dos personas que se ven, y organizarlo se vuelve casual, mutuo y en su mayoría sin comentar.

**La jugada:** espera hacer la mayor parte del trabajo durante los primeros meses, y no lo leas como la respuesta.

Esa es toda la calibración, y no cuesta nada salvo paciencia. Durante el arranque, proponer no es prueba de desequilibrio — es lo que es el arranque. Leerlo como desequilibrio es lo que hace que la gente lo deje en dos, que garantiza que el desequilibrio nunca se resuelva porque nunca se alcanza el umbral.

También se equilibra solo, que merece la pena saber de antemano porque no se va a sentir así en el momento. Nadie se sienta y acuerda empezar a corresponder. Sencillamente cambia de carácter en cuanto estáis establecidos, normalmente sin que ninguno de los dos se dé cuenta de que ha cambiado.

El corolario poco glamuroso es que las amistades, al principio, las construye de forma desproporcionada quien más tiempo tolera la incertidumbre. No el más gracioso ni el más interesante — quien siguió proponiendo cosas mientras todavía era ambiguo. Esa es una cualidad mucho más disponible que el encanto, y es completamente una decisión.

Y significa que la pregunta útil en la semana seis no es *¿está funcionando esto?* sino *¿cuántas veces nos hemos visto de verdad?* Si la respuesta es dos, no hay nada que evaluar. Llega a cuatro, y entonces mira.

Si te quedas con una cosa: tres o cuatro, y luego juzga. Antes de eso estás evaluando algo que todavía no ha pasado.$md$,
  $j$[
    {
      "situation": "Has organizado las dos veces que os habéis visto.",
      "line": "(eso es lo que es el arranque)",
      "why": "Proponer durante los primeros meses no es prueba de desequilibrio. Leerlo como desequilibrio es lo que hace que la gente lo deje en dos."
    },
    {
      "situation": "Semana seis y te preguntas si esto está funcionando.",
      "line": "(¿cuántas veces os habéis visto de verdad?)",
      "why": "Si la respuesta es dos, no hay nada que evaluar todavía. Llega a cuatro y entonces mira."
    },
    {
      "situation": "Estás esperando a ver si va a corresponder.",
      "line": "(cambia solo, después del umbral)",
      "why": "Nadie se sienta y acuerda empezar a corresponder. Cambia en cuanto estáis establecidos, normalmente sin que ninguno de los dos se dé cuenta."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué cambia a las tres o cuatro veces?",
      "options": [
        { "text": "Os conocéis lo bastante bien como para relajaros.", "correct": false, "note": "Eso también pasa y es una sensación. El cambio es estructural." },
        { "text": "Deja de ser una serie de citas organizadas y se convierte en una amistad.", "correct": true, "note": "Después del umbral sois dos personas que se ven, y organizarlo se vuelve casual y mutuo sin que nadie decida que deba serlo." },
        { "text": "Se os acaban las cosas de las que hablar.", "correct": false, "note": "Justo lo contrario — la cuarta conversación suele ser la primera de verdad buena." },
        { "text": "Decide si le gustas.", "correct": false, "note": "Eso lo decidió en el primer café. Lo que estaba por decidir es si esto se convierte en algo." }
      ],
      "explain": "Antes del umbral estás evaluando algo que todavía no ha pasado."
    },
    {
      "prompt": "¿Qué cualidad construye de verdad las amistades al principio?",
      "options": [
        { "text": "Ser buena compañía.", "correct": false, "note": "Hace mejor cada encuentro y no produce por sí solo un cuarto encuentro." },
        { "text": "Tener cosas en común.", "correct": false, "note": "Se descubre durante el arranque más a menudo de lo que lo causa." },
        { "text": "Tolerar la incertidumbre más tiempo.", "correct": true, "note": "Quien sigue proponiendo cosas mientras todavía es ambiguo. Mucho más disponible que el encanto, y completamente una decisión." },
        { "text": "Ser fácil de localizar.", "correct": false, "note": "Ayuda, y es pasivo. Alguien todavía tiene que proponer." }
      ],
      "explain": "No el más gracioso. El que siguió adelante mientras todavía era ambiguo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "counted", "label": "Contó los encuentros", "description": "Juzgó por número en vez de por sensación." },
      { "key": "did_the_work", "label": "Hizo el trabajo temprano", "description": "Siguió proponiendo durante la fase ambigua." },
      { "key": "no_verdict", "label": "Se guardó el veredicto", "description": "No evaluó antes del umbral." },
      { "key": "patient", "label": "Toleró la incertidumbre", "description": "Siguió con ello mientras todavía no estaba claro." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un viejo amigo con quien estás hablando",
      "mood": "Directo.",
      "openness": 5,
      "personality": "Pregunta cuántas veces, y señala lo pequeño que es el número cada vez que la persona empieza a sacar conclusiones."
    },
    "setting": "Has quedado con alguien dos veces ya, las dos por sugerencia tuya, y te preguntas si sugerir una tercera.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pide el número real cada vez que la persona ofrezca una interpretación.",
      "Alégrate con brevedad ante una decisión de organizar una tercera.",
      "Nunca menciones tú un umbral."
    ],
    "opening_beat": "«Las dos veces preguntaste tú. ¿Cuántas veces es eso en total, entonces?»",
    "success_looks_like": "La persona reconoce que dos son muy pocas como para concluir nada y sigue adelante."
  }$j$::jsonb,
  'Hoy, cuenta cuántas veces te has visto de verdad con una persona nueva fuera de donde la conociste. Apunta el número.',
  $j${
    "beats": [
      {
        "situation": "Has quedado con alguien dos veces, las dos por sugerencia tuya. Te preguntas si merece la pena una tercera.",
        "prompt": "¿Cuál es la pregunta útil?",
        "options": [
          { "text": "¿Está funcionando esto?", "correct": false, "note": "No se puede responder con dos encuentros. Estarías evaluando algo que todavía no ha pasado." },
          { "text": "¿De verdad le gusto?", "correct": false, "note": "Vino dos veces. Esa pregunta se zanjó en el primer café." },
          { "text": "¿Cuántas veces nos hemos visto?", "correct": true, "note": "Dos. No hay nada que evaluar. Llega a cuatro y entonces mira — tres o cuatro es donde deja de ser citas organizadas y se convierte en amistad." },
          { "text": "¿Debería esperarla esta vez?", "correct": false, "note": "La regla de los turnos otra vez, y aplicarla antes del umbral es lo que garantiza que nunca se alcance el umbral." }
        ]
      },
      {
        "situation": "Hacia el cuarto o quinto encuentro, algo cambia.",
        "prompt": "¿Qué ha cambiado?",
        "options": [
          { "text": "Se os han acabado las cosas nuevas de las que hablar.", "correct": false, "note": "Justo lo contrario — la cuarta conversación suele ser la primera de verdad buena." },
          { "text": "Empieza a corresponder porque ahora se siente obligada.", "correct": false, "note": "La obligación no es lo que lo hace, y una amistad que funciona por obligación sería un resultado peor que ninguno." },
          { "text": "Te has vuelto mejor compañía.", "correct": false, "note": "Sigues siendo el mismo. La relación cruzó un umbral en vez de mejorar tú." },
          { "text": "Dejó de ser una serie de citas organizadas.", "correct": true, "note": "Ahora sois dos personas que se ven, y organizarlo se vuelve casual y mutuo sin que ninguno de los dos decida que deba serlo." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('the-second-time', 5,
  'Cuando nunca proponen ellos',
  $md$A veces el umbral se pasa, la amistad es real, y aun así siempre eres tú quien lo organiza todo. Esto es habitual, no es lo que la gente asume que es, y merece la pena manejarlo de forma deliberada en vez de dejar que se acumule en silencio.

**La jugada:** separa *no propone* de *no quiere esto*, usando lo que pasa cuando propones tú.

Son completamente distintas y se ven idénticas si solo cuentas las invitaciones. La prueba está en la respuesta: alguien que dice sí con facilidad, se presenta, se le nota contento de estar ahí y retoma la conversación donde la dejasteis es un amigo que no organiza. Alguien que rechaza más de lo que acepta, está distraído, y nunca pregunta nada de tu vida te está diciendo otra cosa.

Hay muchos motivos por los que una persona no propone y casi ninguno tiene que ver contigo. Alguna gente nunca ha organizado nada en su vida y tiene amistades de hace décadas. Alguna está crónicamente desbordada. Alguna asume que quien empezó algo lo lleva, de la misma forma que quien no reservó el restaurante no comprueba la reserva.

Así que la pregunta que hacerte no es quién organiza, sino qué consigues cuando lo haces tú. Si la respuesta es una buena tarde con alguien que se alegra de que existas, organizar es un pequeño impuesto sobre algo valioso, y pagarlo es un intercambio razonable y no una humillación.

Si te molesta, dilo una vez, con ligereza, y sin ninguna acusación dentro. *Me encantaría que a veces eligieras tú el día* es toda la frase — a mucha gente sencillamente no se le ha ocurrido, y un número sorprendente de ellos cambia. Lo que no funciona es llevar la cuenta en silencio, que con el tiempo convierte el cariño en resentimiento por algo que la otra persona nunca supo que estaba pasando.

Y una respuesta real está permitida. Algunas amistades de verdad funcionan con el esfuerzo de una sola persona y no valen lo que cuestan. Darse cuenta de eso no es amargura, es el mismo permiso que el tema anterior te dio sobre una segunda cita.

Si te quedas con una cosa: juzga por lo que pasa cuando preguntas, no por quién preguntó.$md$,
  $j$[
    {
      "situation": "Has organizado cada una de las últimas seis veces.",
      "line": "(¿qué pasa cuando lo haces?)",
      "why": "Alguien que dice sí con facilidad, se presenta y se le nota contento de estar ahí es un amigo que no organiza. Eso es distinto de alguien que no está interesado."
    },
    {
      "situation": "Ha empezado a molestarte.",
      "line": "Me encantaría que a veces eligieras tú el día.",
      "why": "Una frase ligera sin ninguna acusación dentro. A mucha gente nunca se le ha ocurrido, y un número sorprendente cambia."
    },
    {
      "situation": "Llevas un año llevando la cuenta en silencio.",
      "line": "(eso convierte el cariño en resentimiento)",
      "why": "Sobre algo que la otra persona nunca supo que estaba pasando. Dilo una vez o déjalo estar — la opción del medio es la cara."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cómo distingues las dos cosas?",
      "options": [
        { "text": "Por lo a menudo que dice que sí.", "correct": false, "note": "Parte de ello, y las agendas de verdad están llenas. Mira toda la respuesta, no solo la tasa de aceptación." },
        { "text": "Por si alguna vez sugiere algo.", "correct": false, "note": "Eso es lo que estás intentando interpretar. No puede ser también la prueba." },
        { "text": "Por lo que consigues cuando organizas tú.", "correct": true, "note": "Contento de estar ahí, retomando donde lo dejasteis, preguntando por tu vida — eso es un amigo que no organiza. Distraído y rechazando es otra cosa." },
        { "text": "Preguntándole directamente.", "correct": false, "note": "Merece la pena hacerlo sobre lo de organizar, y no te va a dar una respuesta honesta sobre si valora la amistad." }
      ],
      "explain": "Juzga por la respuesta, no por quién mandó el mensaje."
    },
    {
      "prompt": "Te molesta. ¿Cuál es la jugada?",
      "options": [
        { "text": "Deja de organizar cosas y mira qué pasa.", "correct": false, "note": "Una prueba realizada en silencio, que normalmente termina la amistad sin que ninguno de los dos decida hacerlo." },
        { "text": "Dilo una vez, con ligereza, sin ninguna acusación.", "correct": true, "note": "A mucha gente sencillamente nunca se le ha ocurrido, y un número sorprendente cambia. El silencio es la opción que convierte el cariño en resentimiento." },
        { "text": "Acéptalo — así es ella.", "correct": false, "note": "Una conclusión buena después de decir algo y una mala en vez de decirlo." },
        { "text": "Iguala su esfuerzo exactamente.", "correct": false, "note": "Llevar la cuenta formalizado, y te cuesta la amistad para hacer un punto que ella nunca recibió." }
      ],
      "explain": "Dilo una vez o déjalo estar. La opción del medio es donde pasa el daño."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "right_evidence", "label": "Juzgó por la respuesta", "description": "Miró qué pasa cuando pregunta, no quién pregunta." },
      { "key": "said_once", "label": "Lo dijo una vez si importaba", "description": "Lo planteó con ligereza en vez de llevar la cuenta." },
      { "key": "no_test", "label": "No hizo una prueba silenciosa", "description": "No dejó de organizar para ver qué pasaba." },
      { "key": "allowed_answer", "label": "Permitió una respuesta real", "description": "Aceptó que algunas amistades no valen lo que cuestan." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un viejo amigo con quien lo estás hablando",
      "mood": "Interesado.",
      "openness": 5,
      "personality": "Pregunta cómo es de verdad la otra persona cuando quedáis, en vez de preguntar por lo de organizar."
    },
    "setting": "Has organizado los seis últimos encuentros con alguien que te gusta de verdad, y ha empezado a molestarte un poco.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Sigue volviendo a cómo son los encuentros en sí.",
      "Tómate en serio cualquier decisión de decir algo una vez, con ligereza.",
      "Nunca le digas a la persona qué significa lo de organizar."
    ],
    "opening_beat": "«Seis veces, todas tú. ¿Cómo es cuando llegas de verdad?»",
    "success_looks_like": "La persona juzga por la respuesta en vez de por quién propone."
  }$j$::jsonb,
  'Hoy, mira una amistad que siempre organizas tú y júzgala por lo que pasa cuando lo haces. Apunta el veredicto.',
  $j${
    "says": "Seis veces, todas tú. ¿Cómo es cuando llegas de verdad?",
    "model": {
      "line": "Genuinamente contenta de estar ahí, y siempre retoma lo que estuviéramos hablando la última vez.",
      "why": "Esa es la prueba que importa. Alguien que nunca organiza pero se alegra de que existas es un amigo que no organiza — que es distinto de alguien que no está interesado."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["nunca pregunta", "siempre yo", "no se molesta", "no le importa", "unilateral", "aprovechándose de mí", "dándome por sentado"], "requirement": "Juzga por la respuesta, no por las invitaciones" },
      { "kind": "min_words", "n": 10, "requirement": "Describe qué pasa de verdad cuando quedáis" },
      { "kind": "max_words", "n": 40, "requirement": "Una observación, no un argumento" }
    ]
  }$j$::jsonb
);
