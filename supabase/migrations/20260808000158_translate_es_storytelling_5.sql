-- Spanish: Storytelling, track 5 — Levantarte sin avisar.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Rob" (lessons 1, 2, 3, 5) and "Sam" (lesson 4) carry no `sex`
-- field; masculine agreement used by default. This completes the
-- Storytelling topic (tracks 1-5).

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

select pg_temp.es_lesson('no-warning', 1,
  'Una cosa, un ejemplo, un cierre',
  $md$Alguien dice *di unas palabras*. Treinta caras se giran. Tienes unos cuatro segundos y ninguna preparación, y esta es la versión más aterradora de hablar en público que hay.

También tiene la estructura más sencilla de toda la app.

**La jugada:** una cosa, un ejemplo, un cierre. Tres frases son un discurso.

**Una cosa.** Un único punto, elegido en los tres segundos mientras te levantas. *Sarah ha mantenido unido a este equipo durante cuatro años.* Sea lo que sea lo demás que sea cierto, esta es la frase que estás aquí para decir — y la disciplina es no añadir una segunda, porque dos puntos en un discurso improvisado es donde la gente se pierde y empieza a dar vueltas.

**Un ejemplo.** El detalle concreto que lo hace real. *Cuando todo se vino abajo en marzo, ella fue la que seguía aquí a las nueve de la noche.* Esta es la parte que la gente recuerda y por eso treinta segundos sobre una cosa real ganan a cuatro minutos sobre las cualidades de alguien. También es la parte más fácil de encontrar, porque estás recordando en vez de componiendo.

**Un cierre.** Una frase que cala y para. *Todos nos habríamos ido sin ella.* Corto, definitivo, y — esto importa — decidido antes de decir el ejemplo, para que sepas adónde vas.

Esa es toda la estructura y sobrevive a los nervios, que es su verdadera ventaja. Bajo adrenalina no vas a ejecutar nada complicado, y tres huecos son pocos suficientes para retenerlos mientras el corazón se te acelera.

Si solo puedes con dos de las tres, deja caer el cierre y para después del ejemplo. Un discurso que termina algo abruptamente en algo concreto es mucho mejor que uno que sigue mientras alguien busca un final.

Si te quedas con una cosa: una cosa, un ejemplo, un cierre. Luego para, y siéntate.$md$,
  $j$[
    {
      "situation": "«Di unas palabras.» Treinta caras.",
      "line": "(una cosa, un ejemplo, un cierre)",
      "why": "Tres huecos son pocos suficientes para retener bajo adrenalina, que es la única estructura que merece la pena tener en un momento así."
    },
    {
      "situation": "Tienes dos buenos puntos y no tienes tiempo de elegir.",
      "line": "(uno — dos es donde la gente da vueltas)",
      "why": "Dos puntos en un discurso improvisado es donde la gente se pierde, y el segundo casi nunca es tan bueno como el primero."
    },
    {
      "situation": "Has dicho la cosa y el ejemplo y no encuentras un cierre.",
      "line": "(entonces para ahí)",
      "why": "Terminar algo abruptamente en algo concreto es mucho mejor que seguir mientras buscas un final."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué un punto en vez de dos?",
      "options": [
        { "text": "Dos tarda demasiado.", "correct": false, "note": "La duración es un síntoma. Dos puntos pueden ser cortos y aun así causar el problema." },
        { "text": "Dos es donde la gente se pierde y empieza a dar vueltas.", "correct": true, "note": "En un discurso improvisado, el segundo punto es donde la estructura cede — y casi nunca es tan bueno como el primero de todas formas." },
        { "text": "Uno suena más decisivo.", "correct": false, "note": "Cómo suena, no qué te pasa a ti mientras lo entregas." },
        { "text": "La gente solo recuerda una cosa de todas formas.", "correct": false, "note": "Cierto y es sobre ellos. El motivo mayor es qué te hace a ti dos en el momento." }
      ],
      "explain": "Tres huecos son pocos suficientes para retener mientras el corazón se te acelera."
    },
    {
      "prompt": "¿Qué parte recuerda la gente?",
      "options": [
        { "text": "El punto.", "correct": false, "note": "El punto los orienta y rara vez es lo que se repite después." },
        { "text": "El cierre.", "correct": false, "note": "El cierre hace que cale y normalmente es la frase menos concreta de todas." },
        { "text": "El ejemplo.", "correct": true, "note": "El detalle concreto que lo hace real, que es por lo que treinta segundos sobre una cosa real ganan a cuatro minutos sobre las cualidades de alguien." },
        { "text": "Lo nervioso que parecías.", "correct": false, "note": "Considerablemente menos visible de lo que se siente, y olvidado de inmediato de todas formas." }
      ],
      "explain": "Y el ejemplo es la parte más fácil, porque estás recordando en vez de componiendo."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_thing", "label": "Un punto", "description": "No añadió un segundo." },
      { "key": "example", "label": "Un ejemplo concreto", "description": "Algo real en vez de una cualidad." },
      { "key": "close", "label": "Un cierre que para", "description": "Corto y definitivo." },
      { "key": "stopped", "label": "Se sentó", "description": "No siguió después del final." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rob",
      "role": "el compañero que acaba de cederte la palabra",
      "mood": "Alegre, algo bebido.",
      "openness": 4,
      "personality": "Informa de la sala con sencillez — atención, calidez, el momento en que la gente empieza a mirar sus copas."
    },
    "setting": "Una fiesta de despedida. Alguien acaba de cederte la palabra sin avisar, por Sarah, que lleva aquí cuatro años.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Describe con sencillez la atención de la sala según cambia.",
      "Informa de calidez y aplausos ante cualquier cosa corta y concreta.",
      "Informa de que la atención se distrae después de unos cuarenta y cinco segundos."
    ],
    "opening_beat": "«— y creo que alguien más quería decir algo. Venga, adelante.»",
    "success_looks_like": "La persona dice una cosa, un ejemplo y un cierre, y luego para."
  }$j$::jsonb,
  'Hoy, planea los tres huecos para alguien sobre quien podrías tener que hablar. Apunta los tres.',
  $j${
    "says": "— y creo que alguien más quería decir algo. Venga, adelante. (Una fiesta de despedida, por Sarah, que lleva aquí cuatro años.)",
    "model": {
      "line": "Sarah ha mantenido unido a este equipo durante cuatro años. Cuando todo se vino abajo en marzo, ella fue la que seguía aquí a las nueve de la noche. Todos nos habríamos ido sin ella.",
      "why": "Una cosa, un ejemplo, un cierre — tres huecos, que son pocos suficientes para retener bajo adrenalina. El ejemplo es la parte que la gente va a repetir."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["no se me da bien", "no me había preparado", "perdón", "no acostumbro", "me ha pillado por sorpresa", "voy a ser breve", "por dónde empiezo", "no sé qué decir"], "requirement": "Nada de preámbulo ni de disculpa" },
      { "kind": "min_words", "n": 18, "requirement": "Una cosa, un ejemplo, un cierre" },
      { "kind": "max_words", "n": 60, "requirement": "Tres frases son un discurso" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('no-warning', 2,
  'El brindis',
  $md$El brindis es la forma más fácil de hablar improvisado que hay, y merece la pena saber por qué: el final es una acción física, así que no puedes fallar en aterrizarlo.

**La jugada:** nombra a la persona, una cosa concreta, una línea sobre qué significa, y levanta la copa.

*Por Michael. Que condujo cuatro horas para ayudarme a mover un sofá que nunca había visto, a un piso en el que nunca había estado. No hay nadie más a quien habría llamado. Por Michael.*

Cuatro partes, unos quince segundos, y la copa hace el final. Esa última propiedad está haciendo más trabajo de lo que parece — la parte más difícil de un discurso corto es parar con limpieza, y aquí la sala lo termina por ti al beber.

**Nómbrala al principio.** Le dice a todo el mundo qué es esto y apunta la atención de la sala en una dirección antes de que digas nada que importe.

**Una cosa concreta.** La misma regla que la lección anterior, y el mismo motivo. *Michael es increíblemente generoso* es una afirmación sobre alguien; el sofá es evidencia, y la evidencia es lo que la gente recuerda y repite.

**Una línea sobre qué significa.** Corta, y este es el único sitio de la estructura donde una afirmación general se gana su sitio — el detalle concreto te acaba de comprar el derecho a ella.

**Luego la copa.** Repite el nombre para que la gente sepa que tiene que unirse.

Dos cosas que evitar. No hagas una lista — tres cosas sobre alguien es un discurso, y un brindis que se convierte en un discurso ha perdido lo que lo hacía fácil. Y no te alargues: la diferencia entre un brindis que la gente disfruta y uno que aguanta es casi por completo si se quedó por debajo de unos veinte segundos.

Si le tienes pavor a una boda o a una fiesta de despedida, esta es la forma que hay que tener lista. Funciona para cualquiera, se puede montar en el tiempo que tarda en levantarse, y nunca falla en terminar.

Si te quedas con una cosa: nombre, detalle concreto, significado, copa. La copa es por lo que este es el fácil.$md$,
  $j$[
    {
      "situation": "Te han pedido que digas algo sobre Michael.",
      "line": "Por Michael. Que condujo cuatro horas para ayudarme a mover un sofá que nunca había visto. No hay nadie más a quien habría llamado. Por Michael.",
      "why": "Nombre, detalle concreto, significado, copa. Quince segundos, y la sala lo termina por ti al beber."
    },
    {
      "situation": "Tienes tres buenas cosas que podrías decir.",
      "line": "(una — tres es un discurso)",
      "why": "Un brindis que se convierte en un discurso ha perdido la propiedad que lo hacía fácil, que es el final garantizado."
    },
    {
      "situation": "Quieres decir que es increíblemente generoso.",
      "line": "(el sofá es la evidencia)",
      "why": "Una afirmación sobre alguien es una afirmación. La evidencia es lo que la gente recuerda, y te compra el derecho a la línea general después."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué es el brindis la forma más fácil?",
      "options": [
        { "text": "Todo el mundo está bebiendo, así que los estándares son bajos.", "correct": false, "note": "Los estándares no son la variable, y un mal brindis se nota a cualquier hora." },
        { "text": "Es corto.", "correct": false, "note": "Corto ayuda y no resuelve la parte más difícil, que es parar." },
        { "text": "La copa lo termina por ti.", "correct": true, "note": "La parte más difícil de un discurso corto es parar con limpieza, y aquí la sala lo hace al beber. No puedes fallar en aterrizarlo." },
        { "text": "Es un formato familiar.", "correct": false, "note": "Familiar de escuchar y no de dar, que es por lo que a la mayoría de la gente le da pavor que se lo pidan." }
      ],
      "explain": "Nombre, detalle concreto, significado, copa — unos quince segundos."
    },
    {
      "prompt": "¿Qué tiene permiso para hacer la línea general aquí?",
      "options": [
        { "text": "Nada — mantenlo completamente concreto.", "correct": false, "note": "Demasiado estricto. Este es el único sitio donde una afirmación general se gana su sitio." },
        { "text": "Llegar después de que lo concreto haya comprado el derecho a ella.", "correct": true, "note": "El sofá es la evidencia, y no hay nadie más a quien habría llamado es a lo que te da derecho a decir." },
        { "text": "Abrir el brindis, para que la gente sepa el tono.", "correct": false, "note": "Abrir con una afirmación general gasta la atención antes de que llegue la evidencia." },
        { "text": "Reemplazar lo concreto si no se te ocurre nada.", "correct": false, "note": "Entonces es una afirmación sobre alguien sin nada detrás, que es la versión que la gente olvida educadamente." }
      ],
      "explain": "Y no hagas una lista. Tres cosas sobre alguien es un discurso."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named", "label": "Lo nombró primero", "description": "Apuntó la sala antes de decir nada que importara." },
      { "key": "specific", "label": "Una cosa concreta", "description": "Evidencia en vez de una afirmación." },
      { "key": "one_line", "label": "Una línea de significado", "description": "Corta, y después de lo concreto." },
      { "key": "glass", "label": "Levantó la copa", "description": "Dejó que la acción lo terminara." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rob",
      "role": "alguien más en la cena",
      "mood": "Cálido, expectante.",
      "openness": 4,
      "personality": "Informa de la mesa con sencillez y se une al brindis con calidez cuando se levanta una copa."
    },
    "setting": "Una cena de cumpleaños para Michael. Alguien ha golpeado una copa y te ha mirado.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Únete con calidez en el momento en que se levante una copa.",
      "Informa de que la atención de la mesa se distrae si un brindis pasa de unos treinta segundos.",
      "Nunca propongas tú el brindis."
    ],
    "opening_beat": "«Venga — eres quien lo conoce desde hace más tiempo.»",
    "success_looks_like": "La persona da un brindis corto con un detalle concreto y levanta la copa."
  }$j$::jsonb,
  'Hoy, escribe un brindis de quince segundos para alguien que conozcas. Nombre, detalle concreto, significado, copa. Apúntalo.',
  $j${
    "says": "Venga — eres quien lo conoce desde hace más tiempo. (Una cena de cumpleaños para Michael. Alguien ha golpeado una copa.)",
    "model": {
      "line": "Por Michael. Que condujo cuatro horas para ayudarme a mover un sofá que nunca había visto, a un piso en el que nunca había estado. No hay nadie más a quien habría llamado. Por Michael.",
      "why": "Nombre, detalle concreto, significado, copa. Unos quince segundos, y la sala lo termina por ti al beber — que es por lo que el brindis es la forma más fácil de hablar improvisado que hay."
    },
    "checks": [
      { "kind": "echoes_any", "words": ["michael"], "requirement": "Nómbralo al principio" },
      { "kind": "forbids_any", "words": ["amable, gracioso", "generoso, leal", "uno de los mejores", "todo para mí", "las palabras no pueden", "por dónde empiezo", "tantas cosas"], "requirement": "Un detalle concreto, no una lista de cualidades" },
      { "kind": "min_words", "n": 18, "requirement": "Incluye la cosa concreta" },
      { "kind": "max_words", "n": 55, "requirement": "Quince segundos, y luego la copa" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('no-warning', 3,
  'Más corto siempre es mejor',
  $md$Nadie en la historia de las fiestas de despedida se ha quejado de que un discurso fuera demasiado corto. Todo el mundo ha aguantado uno que era demasiado largo, y la diferencia entre esas dos experiencias es casi por completo si alguien supo cuándo parar.

**La jugada:** apunta a la mitad de la duración que crees que se espera.

La presión corre en la otra dirección, que es por lo que hace falta decir esto. De pie, un discurso corto se siente como quedarse corto — te dieron un momento y usaste treinta segundos de él, y parece como si se debiera más. Ese instinto está equivocado en todas las salas, y merece la pena simplemente anularlo en vez de negociar con él.

Merece la pena entender qué pasa de verdad cuando un discurso se alarga, porque no es que la gente se aburra. Es que el final deja de creerse. Un discurso que casi ha terminado tres veces le ha enseñado a la sala a no relajarse al sonido de una frase de cierre — y una vez que pasa eso, el final real consigue alivio en vez de calidez, que es un resultado triste para algo con buena intención.

Dos mecanismos hacen largos los discursos y ninguno es tener demasiado que decir. **Dar vueltas**, donde repites el punto de una forma algo distinta porque no encuentras la salida.

**El segundo pensamiento**, donde has terminado y luego recuerdas algo más — el «ah, y también debería decir» que añade noventa segundos después de que todo el mundo ya haya alcanzado su copa.

El arreglo para las dos cosas es decidir el cierre de antemano. Si sabes tu última frase, tienes una salida visible en todo momento, y puedes tomarla en cuanto se acabe el material.

Y en caso de duda, para pronto. Un discurso que termina algo antes de lo que la gente esperaba es encantador y se lee como confianza. No hay ningún encanto equivalente disponible en el otro extremo.

Si te quedas con una cosa: treinta buenos segundos ganan a cuatro minutos, y nadie ha deseado nunca que un discurso fuera más largo.$md$,
  $j$[
    {
      "situation": "Has dicho tu cosa y se siente demasiado corto.",
      "line": "(ese instinto está equivocado en todas las salas)",
      "why": "De pie, treinta segundos se siente como quedarse corto. Nadie se ha quejado nunca de que un discurso fuera demasiado corto."
    },
    {
      "situation": "Estás repitiendo el punto con palabras algo distintas.",
      "line": "(eso es dar vueltas — has perdido la salida)",
      "why": "Dar vueltas pasa porque no encuentras el final, que es por lo que decidir el cierre de antemano lo arregla."
    },
    {
      "situation": "Has terminado y has recordado algo más.",
      "line": "(no lo añadas)",
      "why": "El ah, y también debería decir llega después de que todo el mundo haya alcanzado su copa, y le enseña a la sala a no creerse tus finales."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué sale mal de verdad cuando un discurso se alarga?",
      "options": [
        { "text": "La gente se aburre.", "correct": false, "note": "Algunos sí, y el aburrimiento es recuperable. Algo peor le pasa a la estructura." },
        { "text": "El final deja de creerse.", "correct": true, "note": "Un discurso que casi ha terminado tres veces le enseña a la sala a no relajarse ante una frase de cierre — así que el final real consigue alivio en vez de calidez." },
        { "text": "Pierdes el hilo.", "correct": false, "note": "Una causa de la duración, no su consecuencia." },
        { "text": "Se convierte en algo sobre ti.", "correct": false, "note": "A veces cierto de los discursos largos y no el mecanismo que describe esto." }
      ],
      "explain": "Apunta a la mitad de la duración que crees que se espera."
    },
    {
      "prompt": "¿Qué hace largos los discursos?",
      "options": [
        { "text": "Tener demasiado que decir.", "correct": false, "note": "Casi nunca. La gente con muchísimo que decir da discursos cortos todo el tiempo." },
        { "text": "Los nervios.", "correct": false, "note": "Los nervios contribuyen específicamente a dar vueltas, y no son el mecanismo por sí solos." },
        { "text": "No conocer al público.", "correct": false, "note": "Afecta al contenido, no a la duración." },
        { "text": "Dar vueltas, y el segundo pensamiento.", "correct": true, "note": "Repetir el punto porque no encuentras la salida, y el ah, y también debería decir después de que todo el mundo haya alcanzado su copa." }
      ],
      "explain": "Las dos se arreglan decidiendo el cierre de antemano — una salida visible en todo momento."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "short", "label": "Lo mantuvo corto", "description": "Apuntó por debajo de lo que se sentía esperado." },
      { "key": "no_looping", "label": "No dio vueltas", "description": "Dijo el punto una vez." },
      { "key": "no_second_thought", "label": "No añadió nada después del final", "description": "Nada de ah, y también debería decir." },
      { "key": "knew_close", "label": "Sabía el cierre", "description": "Tenía una salida visible todo el rato." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rob",
      "role": "alguien en la sala",
      "mood": "Atento.",
      "openness": 4,
      "personality": "Informa de la sala con precisión: calidez y aplausos ante un final limpio, y un aplanamiento claro si el discurso se reinicia."
    },
    "setting": "Acabas de entregar tu cierre en una fiesta de despedida, y has recordado algo más que podrías haber dicho.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Informa de calidez y aplausos si el discurso termina con limpieza.",
      "Informa de que la sala se aplana y las copas vuelven a bajarse si se reinicia.",
      "Nunca pidas más."
    ],
    "opening_beat": "(has dicho tu última línea, y hay la pequeña pausa antes del aplauso)",
    "success_looks_like": "La persona para en vez de añadir la cosa extra."
  }$j$::jsonb,
  'Hoy, termina algo que digas en público antes de lo que planeabas. Apunta qué dejaste fuera.',
  $j${
    "beats": [
      {
        "situation": "Has entregado tu cierre. Hay la pequeña pausa antes del aplauso — y acabas de recordar algo más bueno.",
        "prompt": "¿Qué haces?",
        "options": [
          { "text": "Añádelo — es genuinamente lo mejor que tenías.", "correct": false, "note": "El ah, y también debería decir llega después de que todo el mundo haya alcanzado su copa, y le enseña a la sala a no creerse tus finales." },
          { "text": "Dilo rápido para que no interrumpa el flujo.", "correct": false, "note": "La velocidad no ayuda. El problema es que el discurso había terminado y ahora se ha reiniciado." },
          { "text": "Nada. Se acabó.", "correct": true, "note": "Un discurso que casi ha terminado dos veces consigue alivio en vez de calidez en el final real, que es un resultado triste para algo con buena intención." },
          { "text": "Métela en un segundo cierre.", "correct": false, "note": "Dos cierres es el mecanismo de dar vueltas con mejores modales, y la sala lo puede oír de todas formas." }
        ]
      },
      {
        "situation": "Llevas treinta segundos, has dicho tu cosa, y se siente muchísimo demasiado corto para la ocasión.",
        "prompt": "¿Lo es?",
        "options": [
          { "text": "Sí — treinta segundos se queda corto para un momento así.", "correct": false, "note": "Ese instinto llega en todas las salas y está equivocado en todas ellas. Nadie se ha quejado nunca de que un discurso fuera demasiado corto." },
          { "text": "Sí, a menos que fuera excepcionalmente bueno.", "correct": false, "note": "La calidad no cambia el cálculo de duración — un discurso corto bueno y uno corto normal son los dos mejores que las versiones largas." },
          { "text": "No. Terminar pronto se lee como confianza.", "correct": true, "note": "Un discurso que termina algo antes de lo que la gente esperaba es encantador, y no hay ningún encanto equivalente disponible en el otro extremo." },
          { "text": "No, pero añade un ejemplo más por si acaso.", "correct": false, "note": "Un ejemplo más es cómo treinta segundos se convierten en dos minutos, y el segundo nunca es tan bueno como el primero." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('no-warning', 4,
  'Primera línea y última línea de memoria',
  $md$Para las que ves venir — la boda, la fiesta de despedida, los agradecimientos al final de algo — hay un método de preparación que gana tanto a la memorización completa como a improvisarlo sobre la marcha.

**La jugada:** aprende la primera frase y la última frase con exactitud, e improvisa todo entre ellas.

La primera frase importa porque la apertura es donde los nervios están peor. Levantarte con lo primero ya decidido significa que empiezas con fluidez, y empezar con fluidez te calma más rápido que cualquier otra cosa — la mayoría de los nervios al hablar se desvanecen a los quince segundos, y una apertura conocida te compra esos quince segundos directamente.

La última frase importa porque ahí es donde fallan los discursos. Saber exactamente adónde vas te da una salida visible desde cualquier sitio, así que puedes parar en cuanto se acabe el material en vez de dar vueltas buscando aterrizar.

El medio se improvisa mejor, que sorprende a la gente. El habla improvisada tiene ritmo natural, contacto visual y respuesta a la sala, y suena a alguien hablando. Un medio memorizado suena recitado — audiblemente — y tiene un modo de fallo sin adónde ir: pierde el hilo en un párrafo memorizado y no hay hilo que retomar, porque el hilo era la memoria, no el significado.

Las notas están perfectamente bien y a nadie le importa. Una tarjeta con tres o cuatro palabras — la estructura, no las frases — es lo mejor de las dos cosas, y echarle un vistazo parece alguien siendo cuidadoso con algo que importa. Lo que se lee mal no es consultar una tarjeta, es leer una página.

Y ensaya en voz alta en vez de en tu cabeza. En silencio, todo funciona. En voz alta encuentras la frase que no va a salir bien, que es exactamente la que se habría venido abajo la noche del evento.

Si te quedas con una cosa: primera y última de memoria, medio improvisado. Inicio fluido, aterrizaje garantizado, y la parte del medio suena a una persona.$md$,
  $j$[
    {
      "situation": "Tienes un discurso de boda en quince días.",
      "line": "(primera frase y última frase, con exactitud)",
      "why": "Una apertura conocida te calma en los quince segundos donde los nervios están peor, y un final conocido te da una salida visible desde cualquier sitio."
    },
    {
      "situation": "Te tienta memorizarlo todo.",
      "line": "(un medio memorizado suena recitado, y no tiene adónde ir)",
      "why": "Pierde el hilo en un párrafo memorizado y no hay hilo que retomar, porque el hilo era la memoria, no el significado."
    },
    {
      "situation": "Lo has practicado en tu cabeza y está bien.",
      "line": "(dilo en voz alta)",
      "why": "En silencio, todo funciona. En voz alta encuentras la frase que no va a salir bien — que es la que se habría venido abajo la noche del evento."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué aprender la primera frase?",
      "options": [
        { "text": "Marca el tono.", "correct": false, "note": "Sí lo hace, y el tono no es lo que te compra la memorización." },
        { "text": "Los nervios están peor al principio, y una apertura conocida compra los primeros quince segundos.", "correct": true, "note": "La mayoría de los nervios al hablar se desvanecen a los quince segundos. Empezar con fluidez te calma más rápido que cualquier otra cosa disponible." },
        { "text": "La gente te juzga por la apertura.", "correct": false, "note": "Son mucho más indulgentes que eso, y preocuparse por ello es lo que empeora las aperturas." },
        { "text": "Te impide divagar pronto.", "correct": false, "note": "Divagar es un problema de final, que es para lo que sirve la última frase." }
      ],
      "explain": "Primera y última de memoria. El medio suena mejor improvisado."
    },
    {
      "prompt": "¿Qué tiene de malo memorizar el medio?",
      "options": [
        { "text": "Tarda demasiado en aprenderse.", "correct": false, "note": "El esfuerzo no es la objeción. Mucha gente haría el trabajo encantada." },
        { "text": "Suena recitado y no tiene adónde ir si lo pierdes.", "correct": true, "note": "Audiblemente recitado, y un hilo perdido en un texto memorizado no deja nada que retomar — porque el hilo era la memoria, no el significado." },
        { "text": "No puedes adaptarte a la sala.", "correct": false, "note": "Cierto, y una de varias consecuencias, no el fallo principal." },
        { "text": "Te hace sonar sobrepreparado.", "correct": false, "note": "La sobrepreparación no es un coste social real. Sonar recitado es un problema distinto y más concreto." }
      ],
      "explain": "Y ensaya en voz alta — en silencio, todo funciona."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "first", "label": "Aprendió la primera frase", "description": "Sabía exactamente cómo empieza." },
      { "key": "last", "label": "Aprendió la última frase", "description": "Sabía exactamente dónde termina." },
      { "key": "improvised_middle", "label": "Improvisó el medio", "description": "No memorizó el cuerpo." },
      { "key": "out_loud", "label": "Ensayó en voz alta", "description": "Lo dijo en vez de pensarlo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo ayudándote a prepararte",
      "mood": "Práctico.",
      "openness": 5,
      "personality": "Pregunta qué pasa si pierdes el hilo, y pregunta si has dicho algo de esto en voz alta todavía."
    },
    "setting": "Diez días antes de un discurso de boda. Lo has escrito todo entero y lo estás aprendiendo palabra por palabra.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué pasa si pierden el hilo en el medio.",
      "Pídeles que digan la apertura en voz alta, ahora.",
      "Nunca sugieras tú el método de primera y última."
    ],
    "opening_beat": "«¿De verdad has dicho algo de esto en voz alta ya?»",
    "success_looks_like": "La persona aprende la primera y la última línea y deja el medio improvisado."
  }$j$::jsonb,
  'Hoy, coge algo que podrías tener que decir y decide su primera y última frase con exactitud. Di las dos en voz alta. Apúntalas.',
  $j${
    "says": "¿De verdad has dicho algo de esto en voz alta ya?",
    "model": {
      "line": "No — lo he estado aprendiendo palabra por palabra. Probablemente debería fijar solo la primera línea y la última y decir el resto.",
      "why": "Una apertura conocida compra los quince segundos donde los nervios están peor y un cierre conocido te da una salida visible desde cualquier sitio. El medio suena a una persona solo si no está recitado."
    },
    "checks": [
      { "kind": "contains_any", "words": ["primera línea", "última línea", "primera frase", "última frase", "apertura", "final", "principio y", "comienzo y"], "requirement": "Primera y última, no todo" },
      { "kind": "forbids_any", "words": ["palabra por palabra todo", "aprendérmelo todo", "memorizármelo todo", "leerlo", "de un guion", "cada palabra"], "requirement": "No memorices el medio" },
      { "kind": "min_words", "n": 12, "requirement": "Di qué vas a hacer" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('no-warning', 5,
  'Nadie puede verlo',
  $md$El hecho más útil sobre hablar ante una sala es que casi nada de lo que estás experimentando es visible.

Tu ritmo cardíaco es invisible. La boca seca es invisible. Las manos temblorosas son visibles para ti de cerca y para nadie a metro y medio, y el temblor en tu voz que suena enorme desde dentro es, para la sala, una variación muy leve que la mayoría de la gente no registra en absoluto.

**La jugada:** deja de gestionar algo que nadie puede ver, y pon la atención en lo que estás diciendo.

El hueco entre el dentro y el fuera de esto es más grande que en casi cualquier otra dificultad social, y merece la pena tomárselo en serio como un hecho en vez de como una tranquilidad. La gente que se graba a sí misma hablando se sorprende habitualmente — la grabación muestra a alguien algo tieso, y ellos recuerdan un suplicio.

La consecuencia práctica no es *ten más confianza*, que no está disponible por encargo. Es que una parte sustancial de lo que hace difícil hablar es el esfuerzo de ocultarlo, y ocultarlo es innecesario, así que ese esfuerzo se puede gastar en el discurso en su lugar.

Dos cosas que ayudan de verdad y son físicas en vez de mentales. Ve más despacio — los nervios comprimen el habla y la corrección no es hablar despacio sino parar como es debido en los puntos. Y espira antes de empezar; la primera frase sale mal más a menudo porque alguien la empezó con el pecho vacío.

La sala también está de tu lado por defecto, que a la gente le cuesta creer y que es sencillamente cierto. Todo el mundo ahí está aliviado de que no sea ellos, todo el mundo quiere que vaya bien, y nadie espera ver a alguien luchando. Un público es el grupo más comprensivo delante del que vas a estar toda la semana.

Y si algo sale mal, la sala toma su señal de ti. Pausa, sigue, y es una pausa. Discúlpate por ello, y es un incidente.

Si te quedas con una cosa: nadie puede verlo. Sea lo que sea lo que esté pasando en tu pecho no está en tu cara, y el esfuerzo de esconderlo es la parte que puedes soltar.$md$,
  $j$[
    {
      "situation": "El corazón se te acelera y te tiemblan las manos.",
      "line": "(nada de eso llega a la cuarta fila)",
      "why": "La gente que se graba a sí misma se sorprende habitualmente — la grabación muestra a alguien algo tieso y ellos recuerdan un suplicio."
    },
    {
      "situation": "Estás trabajando duro para esconder los nervios.",
      "line": "(ese esfuerzo es la parte que puedes soltar)",
      "why": "Ocultarlo es innecesario, y una parte sustancial de lo que hace difícil hablar es el esfuerzo de ello."
    },
    {
      "situation": "Pierdes el hilo durante dos segundos.",
      "line": "(pausa, sigue)",
      "why": "La sala toma su señal de ti. Pausada y continuada es una pausa; disculpada es un incidente."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la consecuencia práctica de que nadie lo vea?",
      "options": [
        { "text": "Puedes relajarte.", "correct": false, "note": "Relajarse no está disponible por encargo, e instruir a alguien a hacerlo es por lo que falla la mayoría del consejo aquí." },
        { "text": "El esfuerzo de ocultarlo se puede soltar.", "correct": true, "note": "Una parte sustancial de lo que hace difícil hablar es esconderlo. Si no hay nada que esconder, ese esfuerzo va al discurso en su lugar." },
        { "text": "Los errores no importan.", "correct": false, "note": "Importan un poco, y cómo los manejas importa más — que es la última parte de esta lección." },
        { "text": "Se te da mejor esto de lo que crees.", "correct": false, "note": "Alentador e infalsable. La versión útil va sobre adónde va tu atención." }
      ],
      "explain": "Ve más despacio, espira antes de empezar, y para en los puntos."
    },
    {
      "prompt": "Algo sale mal en mitad del discurso. ¿Qué decide cómo cae?",
      "options": [
        { "text": "Lo grande que fue el error.", "correct": false, "note": "Casi irrelevante. Las salas absorben tropiezos considerables sin darse cuenta." },
        { "text": "Si el público es amistoso.", "correct": false, "note": "Lo es, por defecto — todo el mundo ahí está aliviado de que no sea ellos." },
        { "text": "Lo rápido que te recuperas.", "correct": false, "note": "Cerca, y la velocidad no es eso. Una pausa larga manejada con calma está bien." },
        { "text": "Si te disculpas por ello.", "correct": true, "note": "La sala toma su señal de ti. Pausada y continuada es una pausa; disculpada es un incidente." }
      ],
      "explain": "Un público es el grupo más comprensivo delante del que vas a estar toda la semana."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "stopped_hiding", "label": "Dejó de ocultarlo", "description": "Puso el esfuerzo en el discurso en vez de en el disfraz." },
      { "key": "slowed", "label": "Fue más despacio", "description": "Paró como es debido en los puntos." },
      { "key": "breathed", "label": "Espiró primero", "description": "No empezó la primera frase con el pecho vacío." },
      { "key": "no_apology", "label": "No se disculpó por un tropiezo", "description": "Pausó y siguió." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Rob",
      "role": "alguien sentado a tu lado",
      "mood": "Relajado.",
      "openness": 4,
      "personality": "No tiene ni idea de que está pasando algo. Informa de cómo se ve la sala desde donde está sentado, que es una sala normal esperando agradablemente."
    },
    "setting": "Estás a punto de levantarte. El corazón se te acelera, tienes la boca seca, y estás seguro de que todo el mundo lo va a notar.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "No notes nada sobre el estado de la persona a menos que lo anuncie.",
      "Describe la sala como normal y bien dispuesta si te preguntan.",
      "Nunca tranquilices a la persona sobre sus nervios."
    ],
    "opening_beat": "«Creo que eres el siguiente.»",
    "success_looks_like": "La persona deja de gestionar los nervios y sigue adelante."
  }$j$::jsonb,
  'Hoy, habla delante de alguien sin gestionar cómo se ven los nervios. Apunta qué notaste después.',
  $j${
    "beats": [
      {
        "situation": "Estás a punto de levantarte. El corazón se acelera, la boca seca, las manos no del todo firmes.",
        "prompt": "¿Cuánto de eso llega a la sala?",
        "options": [
          { "text": "La mayor parte — la gente siempre se da cuenta.", "correct": false, "note": "La gente que se graba a sí misma hablando se sorprende habitualmente: la grabación muestra a alguien algo tieso y ellos recuerdan un suplicio." },
          { "text": "La voz, sobre todo.", "correct": false, "note": "El temblor que suena enorme desde dentro es una variación muy leve a metro y medio, y la mayoría de la gente no lo registra." },
          { "text": "Casi nada.", "correct": true, "note": "El ritmo cardíaco y la boca seca son invisibles, las manos son visibles solo de cerca — y la consecuencia práctica es que el esfuerzo de ocultarlo se puede soltar." },
          { "text": "Depende de lo cerca que esté la primera fila.", "correct": false, "note": "Metro y medio es suficiente. La distancia no está haciendo el trabajo aquí." }
        ]
      },
      {
        "situation": "A mitad, pierdes el hilo durante unos tres segundos.",
        "prompt": "¿Qué decide cómo cae eso?",
        "options": [
          { "text": "Lo rápido que lo recuperas.", "correct": false, "note": "Una pausa larga manejada con calma está perfectamente bien. La velocidad no es la variable." },
          { "text": "Si alguien se dio cuenta.", "correct": false, "note": "Alguien se habrá dado cuenta. Aun así cae como nada a menos que algo lo convierta en algo." },
          { "text": "Lo bien que ha ido el resto.", "correct": false, "note": "Las salas no llevan un total acumulado. Este momento se juzga por sí solo." },
          { "text": "Si te disculpas por ello.", "correct": true, "note": "La sala toma su señal de ti. Pausada y continuada es una pausa; disculpada es un incidente." }
        ]
      }
    ]
  }$j$::jsonb
);
