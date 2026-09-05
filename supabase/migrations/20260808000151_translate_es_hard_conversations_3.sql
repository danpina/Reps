-- Spanish: Conversaciones difíciles, track 3 — Decir la cosa.
--
-- Conventions as prior topics: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Jo" carries no `sex` field; masculine agreement used by
-- default, as established throughout this app.

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

select pg_temp.es_lesson('saying-the-thing', 1,
  'Qué pasó, qué hizo, qué quieres',
  $md$El contenido de una conversación difícil es más pequeño de lo que nadie espera. Tres partes, de unas dos frases cada una, y todo lo que va más allá de eso es decoración o daño.

**Qué pasó.** Un hecho, no un resumen. *Las últimas tres veces que hicimos planes, cancelaste el día antes.* Comprobable, aceptable, e imposible de discutir como cuestión de registro — que importa enormemente, porque lo primero a lo que recurre alguien incómodo es a una disputa de hechos, y quieres que no haya ninguna disponible.

**Qué hizo.** La consecuencia, incluyendo la que está dentro de ti. *He dejado de proponer cosas que de verdad quiero hacer, porque doy por hecho que no van a pasar.* Esta es la parte que se deja fuera, y sin ella has descrito algo que no disfrutaste — a lo que la respuesta honesta es *¿y?* El efecto es lo que lo convierte en un problema en vez de en una preferencia.

**Qué quieres.** Un cambio concreto, lo bastante pequeño como para pasar el jueves. *Si lo sabes por la mañana, dímelo entonces en vez de a las seis.*

**La jugada:** di esas tres, en ese orden, y para.

El orden importa más de lo que parece. El hecho primero es indiscutible, así que la conversación empieza en terreno sólido. El efecto segundo le da peso sin acusar a nadie de nada — estás informando sobre ti mismo. La petición al final significa que la conversación tiene adónde ir, y les da algo que hacer aparte de defenderse.

Dos frases cada una es de sobra. El instinto de elaborar más viene del silencio y de querer que te entiendan por completo, y cada frase adicional diluye las tres que estaban haciendo el trabajo.

Y fíjate en lo que no está: por qué lo hicieron, qué dice eso de ellos, cómo se compara con lo que tú habrías hecho, y cuánto tiempo llevas sintiéndote así. Todo eso está disponible y nada de eso ayuda.

Si te quedas con una cosa: hecho, efecto, petición. Si puedes decir esas tres cosas y parar, has hecho la parte difícil.$md$,
  $j$[
    {
      "situation": "Quieres sacar el tema de las cancelaciones.",
      "line": "Las últimas tres veces que hicimos planes cancelaste el día antes. He dejado de proponer cosas que quiero hacer, porque doy por hecho que no van a pasar. Si lo sabes por la mañana, ¿podrías decírmelo entonces?",
      "why": "Hecho, efecto, petición. Nada de ello se puede discutir, tiene peso sin acusar a nadie, y les da algo que hacer."
    },
    {
      "situation": "Has dicho qué pasó y has parado ahí.",
      "line": "(la respuesta honesta a eso es: ¿y?)",
      "why": "Sin el efecto has descrito algo que no disfrutaste. La consecuencia es lo que lo convierte en un problema en vez de en una preferencia."
    },
    {
      "situation": "Quieres que entiendan cuánto tiempo lleva pasando esto.",
      "line": "(eso no está en las tres)",
      "why": "Por qué lo hicieron, qué dice eso de ellos, y cuánto tiempo llevas sintiéndote así están todos disponibles y ninguno ayuda."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué va primero el hecho?",
      "options": [
        { "text": "Es la parte menos emocional.", "correct": false, "note": "La temperatura emocional no es lo que gestiona el orden." },
        { "text": "No les da nada que discutir.", "correct": true, "note": "Lo primero a lo que recurre alguien incómodo es a un argumento de hechos, y empezar con algo comprobable significa que no hay ninguno disponible." },
        { "text": "Es la parte más importante.", "correct": false, "note": "La petición es discutiblemente la más importante. El hecho va primero por una razón estructural, no por una jerarquía de importancia." },
        { "text": "Los va metiendo poco a poco.", "correct": false, "note": "Nada de esto va metiendo a nadie en nada poco a poco, e intentarlo es el problema de los rodeos del bloque anterior." }
      ],
      "explain": "Hecho, efecto, petición. Terreno sólido, luego peso, luego adónde ir."
    },
    {
      "prompt": "¿Qué te cuesta dejar fuera el efecto?",
      "options": [
        { "text": "Suena a que no te importa mucho.", "correct": false, "note": "Puede sonar así, y el problema estructural es peor que la impresión." },
        { "text": "No van a saber cómo te sientes.", "correct": false, "note": "Cerca, y planteado como si el objetivo fuera expresarte. El efecto está haciendo un trabajo dentro del argumento." },
        { "text": "Se convierte en una preferencia en vez de en un problema.", "correct": true, "note": "Has descrito algo que no disfrutaste, y la respuesta honesta es: ¿y? La consecuencia es lo que hace que merezca la pena una conversación." },
        { "text": "La conversación se hace más corta.", "correct": false, "note": "Normalmente se alarga, porque nadie sabe qué se está pidiendo." }
      ],
      "explain": "Dos frases cada una es de sobra. Elaborar más diluye las tres que estaban funcionando."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "fact", "label": "Empezó con el hecho", "description": "Algo comprobable en vez de un resumen." },
      { "key": "effect", "label": "Nombró el efecto", "description": "Dijo qué hizo de verdad, incluyendo a él mismo." },
      { "key": "ask", "label": "Terminó con la petición", "description": "Un cambio concreto." },
      { "key": "stopped", "label": "Paró", "description": "No elaboró más allá de las tres partes." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Jo",
      "role": "un amigo que sigue cancelando",
      "mood": "Dispuesto, algo receloso.",
      "openness": 4,
      "personality": "Recurre de inmediato a una disputa de hechos si hay alguna disponible, y se implica en serio con algo comprobable."
    },
    "setting": "Estás sentado con un amigo que ha cancelado las últimas tres cosas que organizasteis, cada vez el día antes.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Discute cualquier cosa vaga o generalizada, con un contraejemplo.",
      "Acepta un hecho comprobable sin discutir y responde a lo que sigue.",
      "Nunca propongas tú la petición."
    ],
    "opening_beat": "«Venga, dime — ¿qué pasa con los planes?»",
    "success_looks_like": "La persona da el hecho, el efecto y la petición, y luego para."
  }$j$::jsonb,
  'Hoy, escribe algo que necesitas decir como hecho, efecto y petición. Dos frases cada una. Apunta las tres.',
  $j${
    "says": "Venga, dime — ¿qué pasa con los planes?",
    "model": {
      "line": "Las últimas tres veces que quedamos en algo, cancelaste el día antes. He dejado de proponer cosas que de verdad quiero hacer, porque doy por hecho que no van a pasar. ¿Podrías decírmelo por la mañana si lo sabes entonces?",
      "why": "Hecho, efecto, petición. Nada de ello se puede discutir, tiene peso sin acusar a nadie de nada, y termina en un sitio donde pueden actuar."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Di qué te hizo a ti" },
      { "kind": "forbids_any", "words": ["siempre", "nunca", "constantemente", "cada vez", "claramente", "obviamente", "no te importa", "egoísta", "a propósito"], "requirement": "Nada de generalizar ni de motivos" },
      { "kind": "min_words", "n": 25, "requirement": "Las tres partes" },
      { "kind": "max_words", "n": 70, "requirement": "Dos frases cada una es de sobra" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('saying-the-thing', 2,
  'Siempre y nunca',
  $md$Dos palabras arruinan más conversaciones difíciles que ninguna otra, y se usan precisamente cuando alguien intenta transmitir que esto no es un caso aislado.

*Siempre cancelas.* *Nunca preguntas por mi semana.*

**La jugada:** cuenta en vez de generalizar.

*Las últimas tres veces* es indiscutible. *Siempre* es una afirmación sobre cada caso, lo que significa que es falsa — hay una vez que no lo hicieron, los dos lo sabéis, y ahora está disponible como refutación. Y se va a usar, porque cuando alguien está incómodo, una salida basada en hechos es irresistible.

Lo que sigue es la conversación que no querías. Sacan el contraejemplo, dices que no lo decías literalmente, responden entonces por qué lo dijiste, y se han ido ocho minutos en la exactitud de una palabra mientras el asunto real queda intacto. Peor aún, ahora pareces haber estado exagerando, que discretamente desacredita todo lo demás que dices.

Hay algo real debajo de la palabra, y merece la pena conservarlo. Lo que quieres decir es que es un patrón, y un patrón se expresa mejor contando: *tres de las últimas cuatro veces.* Eso tiene el mismo peso que *siempre* y ninguna de la exposición — y contar suena reflexivo en vez de acalorado, que es su propia ventaja.

Dos parientes que merecen el mismo trato. *Estás constantemente* es *siempre* con otro abrigo puesto. Y *cada vez que*, dicho en mitad de una discusión, es la misma exageración llegando a toda velocidad.

Si de verdad no sabes el número, di la versión más vaga y honesta: *esto ha pasado ya varias veces, y he dejado de contar* está bien y no se puede refutar, porque no pretende ser precisa.

Si te quedas con una cosa: cuenta. Los números son indiscutibles y siempre es la palabra que le entrega a alguien la salida.$md$,
  $j$[
    {
      "situation": "Quieres transmitir que esto es un patrón.",
      "line": "Tres de las últimas cuatro veces.",
      "why": "El mismo peso que siempre y ninguna de la exposición. Los números son indiscutibles y contar suena reflexivo en vez de acalorado."
    },
    {
      "situation": "Dijiste que siempre cancelan y nombraron la vez que no lo hicieron.",
      "line": "(esa fue la salida que les entregaste)",
      "why": "Ahora se van ocho minutos en la exactitud de una palabra, y pareces haber estado exagerando — que desacredita todo lo demás."
    },
    {
      "situation": "No has estado contando.",
      "line": "Esto ha pasado ya varias veces y he dejado de contar.",
      "why": "Honesto, vago de una forma que no se puede refutar, y no pretende una precisión que no tienes."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué es tan costoso siempre?",
      "options": [
        { "text": "Es agresivo.", "correct": false, "note": "Normalmente se dice con frustración, no con agresividad, y el tono no es lo que hace el daño." },
        { "text": "Es una afirmación sobre cada caso, así que es falsa.", "correct": true, "note": "Hay una vez que no lo hicieron, los dos lo sabéis, y ahora está disponible como refutación — a la que alguien incómodo va a recurrir." },
        { "text": "Suena infantil.", "correct": false, "note": "Estilo, no mecanismo, y seguiría siendo costoso dicho con toda calma." },
        { "text": "Generaliza sobre su carácter.", "correct": false, "note": "Eso es la siguiente lección, y es un error distinto. Este es sobre una exageración de hechos." }
      ],
      "explain": "Cuenta en su lugar. Tres de las últimas cuatro es indiscutible y tiene el mismo peso."
    },
    {
      "prompt": "¿Cuál es el segundo coste, después de la discusión sobre la palabra?",
      "options": [
        { "text": "Pierdes los nervios.", "correct": false, "note": "A veces, y no es lo que hace que la exageración sea estructuralmente costosa." },
        { "text": "Dejan de escuchar.", "correct": false, "note": "Escuchan muy de cerca — a la espera de lo siguiente que puedan discutir." },
        { "text": "La conversación se alarga.", "correct": false, "note": "Así es, y ese es el coste visible, no el duradero." },
        { "text": "Pareces haber estado exagerando.", "correct": true, "note": "Que discretamente desacredita todo lo demás que dices, incluidas las partes que eran exactamente precisas." }
      ],
      "explain": "Si no sabes el número, dilo con honestidad en vez de recurrir a siempre."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "counted", "label": "Contó", "description": "Dio un número en vez de una generalización." },
      { "key": "no_always", "label": "Dejó fuera siempre y nunca", "description": "Incluyendo constantemente y cada vez." },
      { "key": "honest_vague", "label": "Fue honestamente vago cuando no estaba seguro", "description": "No reclamó una precisión que no tenía." },
      { "key": "kept_weight", "label": "Mantuvo el peso", "description": "Transmitió el patrón sin la exageración." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Jo",
      "role": "un amigo que sigue cancelando",
      "mood": "A la defensiva, alerta.",
      "openness": 4,
      "personality": "Se lanza sobre cualquier exageración con un contraejemplo preciso, y se calma de inmediato cuando se le da un número que no puede discutir."
    },
    "setting": "En mitad de la conversación. Acabas de decir que siempre cancela, y se ha quedado muy quieto.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Discute la exactitud de cualquier generalización mientras la persona la defienda.",
      "Cede de inmediato e implícate con el contenido en cuanto se te dé un recuento concreto.",
      "Nunca hagas avanzar tú la conversación."
    ],
    "opening_beat": "«¿Siempre? Fui a lo de marzo. Y a tu cumpleaños.»",
    "success_looks_like": "La persona reemplaza la exageración con un recuento en vez de defender la palabra."
  }$j$::jsonb,
  'Hoy, reemplaza un siempre o un nunca con un número real antes de decirlo. Apunta la frase que habrías dicho y la que dijiste.',
  $j${
    "says": "¿Siempre? Fui a lo de marzo. Y a tu cumpleaños.",
    "model": {
      "line": "Justo — tres de las últimas cuatro, entonces. Eso es lo que quería hablar.",
      "why": "Cede la exageración al instante en vez de defender la palabra, y la reemplaza con un número que no pueden discutir. Contar tiene el mismo peso que siempre sin ninguna de la exposición."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["siempre", "nunca", "constantemente", "cada vez", "sabes lo que quería decir", "no literalmente", "básicamente", "prácticamente"], "requirement": "No defiendas la palabra" },
      { "kind": "contains_any", "words": ["tres", "cuatro", "dos veces", "dos", "cinco", "de las últimas", "varias veces", "tercera vez"], "requirement": "Da un número en su lugar" },
      { "kind": "max_words", "n": 30, "requirement": "Cede y avanza" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('saying-the-thing', 3,
  'Efecto, no intención',
  $md$Hay una frase a la que la gente recurre cuando quiere decir qué significó algo, y es la que garantiza una discusión.

*Hiciste eso para dejar clara tu postura.* *Estabas intentando hacerme sentir estúpido.* *Claramente no te importa.*

Cada una de esas es una afirmación sobre la vida interior de alguien, que no puedes ver y que nunca van a conceder. Lo que sigue es un debate sobre sus intenciones — un tema en el que tienen acceso privilegiado, legitimidad infinita, y todos los motivos para defenderse — y lo que de verdad te molestaba desaparece por completo.

**La jugada:** informa del efecto, que es tuyo y no se puede discutir.

*Me llegó como si estuvieras dejando clara tu postura.* *Acabé sintiéndome estúpido.* *Se sintió como si no importara mucho.*

Esas dicen casi lo mismo y se comportan de forma completamente distinta, porque son informes en vez de acusaciones. Nadie puede decirte que no sentiste algo. No hay contraevidencia, no hay defensa disponible, y — crucialmente — no hace falta ninguna, porque no los has acusado de nada que tengan que negar.

También te acerca a lo que de verdad sabes. No sabes por qué lo hicieron. Sabes qué pasó y qué te hizo, y esas son las dos cosas que venías a decir.

Dos cosas que no es. No es más suave — *me sentí humillado* es una frase pesada y está pensada para serlo. Y no es una fórmula: *siento que estás siendo egoísta* es una afirmación sobre la intención con tres palabras pegadas delante, y todo el mundo la reconoce al instante.

La prueba es si la frase se puede discutir. Si pudieran decir razonablemente *no, no era así*, has descrito su intención. Si la única respuesta disponible es *no quería decir eso*, has descrito el efecto — y *no quería decir eso* no es una refutación, es el comienzo de la conversación que querías.

Si te quedas con una cosa: sabes qué te hizo. No sabes por qué lo hicieron, y lo segundo no merece la discusión.$md$,
  $j$[
    {
      "situation": "Crees que lo dijeron para dejar clara su postura.",
      "line": "Me llegó como si estuvieras dejando clara tu postura.",
      "why": "Un informe en vez de una acusación. No hay contraevidencia disponible ni hace falta ninguna defensa, porque no se ha alegado nada."
    },
    {
      "situation": "Estás a punto de decir que claramente no les importa.",
      "line": "(van a defender eso durante veinte minutos)",
      "why": "Sus intenciones son un tema en el que tienen acceso privilegiado y legitimidad infinita, y lo que venías a tratar desaparece."
    },
    {
      "situation": "Quieres comprobar la frase antes de decirla.",
      "line": "(¿podrían decir razonablemente no, no era así?)",
      "why": "Si sí, es una afirmación sobre la intención. Si la única respuesta es no quería decir eso, es un efecto — y esa respuesta es el comienzo de la conversación que querías."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué sale mal nombrar su intención?",
      "options": [
        { "text": "Es presuntuoso.", "correct": false, "note": "Lo es, y ser presuntuoso no es lo que hace que la conversación sea imposible de ganar." },
        { "text": "Probablemente te equivoques.", "correct": false, "note": "Bien podrías tener razón. El problema persiste incluso cuando la tienes." },
        { "text": "Tienen acceso privilegiado a ello y lo van a defender.", "correct": true, "note": "Un debate sobre sus intenciones es uno que ellos no pueden perder y tú no puedes ganar, y lo que de verdad venías a tratar desaparece dentro de él." },
        { "text": "Escala la discusión.", "correct": false, "note": "Describe qué pasa en vez de por qué. El mecanismo va sobre qué es discutible." }
      ],
      "explain": "Sabes qué te hizo. No sabes por qué lo hicieron."
    },
    {
      "prompt": "¿Cuál es la prueba para una frase?",
      "options": [
        { "text": "Si empieza con siento que.", "correct": false, "note": "Siento que estás siendo egoísta es una afirmación sobre la intención con tres palabras pegadas delante, y todo el mundo la reconoce al instante." },
        { "text": "Si podrían decir razonablemente no, no era así.", "correct": true, "note": "Si sí, describiste su intención. Si la única respuesta disponible es no quería decir eso, describiste el efecto." },
        { "text": "Si suena tranquilo.", "correct": false, "note": "Las afirmaciones sobre la intención dichas con calma empiezan exactamente la misma discusión." },
        { "text": "Si es amable.", "correct": false, "note": "Las afirmaciones de efecto a menudo no son amables — me sentí humillado es pesado y está pensado para serlo." }
      ],
      "explain": "No quería decir eso no es una refutación. Es el comienzo de la conversación que querías."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "effect", "label": "Informó del efecto", "description": "Dijo qué hizo en vez de qué quisieron decir." },
      { "key": "no_intent", "label": "No hizo ninguna afirmación sobre la intención", "description": "Dejó fuera sus motivos." },
      { "key": "not_formula", "label": "No usó siento que como envoltorio", "description": "Evitó una afirmación sobre la intención con tres palabras delante." },
      { "key": "kept_weight", "label": "No lo suavizó", "description": "Dijo lo pesado cuando era cierto." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Jo",
      "role": "alguien que hizo un comentario a tu costa",
      "mood": "Abierto, algo preparado.",
      "openness": 4,
      "personality": "Defiende sus intenciones largo y tendido cada vez que se las describen, y se implica con honestidad cuando se le dice qué hizo el comentario."
    },
    "setting": "Hizo un comentario delante de otra gente la semana pasada y has decidido decir algo al respecto.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Defiéndete largo y tendido ante cualquier afirmación sobre qué querías decir o pretendías.",
      "Responde con no quería decir eso, y luego implícate en serio, cuando se te diga el efecto.",
      "Nunca concedas una intención de la que se te acuse."
    ],
    "opening_beat": "«Dime. ¿Qué pasa con eso?»",
    "success_looks_like": "La persona describe el efecto en vez de la intención."
  }$j$::jsonb,
  'Hoy, pilla una frase sobre los motivos de alguien y conviértela en qué te hizo a ti. Apunta las dos versiones.',
  $j${
    "says": "Dime. ¿Qué pasa con eso?",
    "model": {
      "line": "Cuando lo dijiste delante de todos, acabé sintiéndome minúsculo el resto de la noche.",
      "why": "Un informe sobre ti en vez de una afirmación sobre ellos. No hay contraevidencia disponible ni hace falta ninguna defensa, así que la única respuesta es no quería decir eso — que es el comienzo de la conversación que querías."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Informa del efecto, que es tuyo" },
      { "kind": "forbids_any", "words": ["querías decir", "estabas intentando", "querías", "a propósito", "deliberadamente", "claramente", "obviamente", "para hacerme", "no te importa"], "requirement": "Nada de afirmaciones sobre qué quisieron decir" },
      { "kind": "min_words", "n": 12, "requirement": "Di qué hizo de verdad" },
      { "kind": "max_words", "n": 40, "requirement": "Una frase" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('saying-the-thing', 4,
  'Nada de sándwich de cumplidos',
  $md$A todo el mundo le han enseñado esta: algo agradable, la crítica, algo agradable. Es la técnica más recomendada de toda esta área y es peor que no decir nada primero.

**La jugada:** di la cosa sola, y pon la parte cálida en algún sitio donde se crea.

Lo que hace de verdad el sándwich depende de quién se lo coma, y los dos resultados son malos.

Alguien optimista oye el pan. Sale de la conversación habiéndole dicho que le va bien, con una sensación vaga de que había algo en medio, y nada cambia — que es peor que no haber hablado, porque ahora crees que se dijo.

Alguien ansioso oye el relleno y descarta el pan como relleno de más. Peor aún, aprende que tus cumplidos son envoltorio, y a partir de entonces cada cosa agradable genuina que digas produce un respingo mientras espera el centro.

Ese es el coste duradero y es el que a la gente se le pasa. El sándwich no solo falla en el momento; devalúa tus elogios de forma permanente, en una relación en la que se supone que quieres poder decir cosas cálidas y que te crean.

Hay una versión real del impulso que merece la pena conservar. Sí quieres que la persona sepa que esto no es un referéndum sobre ella, y sí quieres que salga intacta. Las dos cosas se consiguen diciendo lo que de verdad quieres decir, con claridad, en vez de con relleno estructural: *esto es una cosa, y no es un problema de fondo* hace el trabajo en una frase.

La calidez después funciona cuando no está haciendo un trabajo. Una vez dicho, tratado y acordado el contenido, la amabilidad normal es amabilidad normal — la diferencia es que no se está desplegando.

Si te quedas con una cosa: di la cosa sola. El elogio usado como envoltorio deja de ser elogio.$md$,
  $j$[
    {
      "situation": "Estás planeando abrir con algo positivo.",
      "line": "(di la cosa sola)",
      "why": "Un optimista oye el pan y nada cambia. Una persona ansiosa oye el relleno y aprende que tus cumplidos son envoltorio."
    },
    {
      "situation": "Quieres que sepan que esto no es un referéndum sobre ellos.",
      "line": "Esto es una cosa, y no es un problema de fondo.",
      "why": "Dice lo que de verdad quieres decir en una frase, en vez de hacerlo con estructura — que era lo que el sándwich intentaba conseguir."
    },
    {
      "situation": "El contenido se ha dicho y tratado.",
      "line": "(ahora la calidez es solo calidez)",
      "why": "Una vez que no está haciendo un trabajo, la amabilidad normal se lee como amabilidad normal en vez de como despliegue."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué le pasa a una persona optimista?",
      "options": [
        { "text": "Oye el pan y nada cambia.", "correct": true, "note": "Sale habiéndole dicho que le va bien, con una sensación vaga de que había algo en medio — que es peor que el silencio, porque tú crees que se dijo." },
        { "text": "Se pone a la defensiva sobre el medio.", "correct": false, "note": "Eso está más cerca de la lectura ansiosa. El optimista apenas lo registra." },
        { "text": "Aprecian el equilibrio.", "correct": false, "note": "Lo aprecian, y apreciarlo es exactamente cómo se pierde el contenido." },
        { "text": "Preguntan qué querías decir de verdad.", "correct": false, "note": "Casi nadie lo hace. Se quedan con la impresión general y se van." }
      ],
      "explain": "Dos públicos, dos fracasos, y ninguno de los dos es el que querías."
    },
    {
      "prompt": "¿Cuál es el coste duradero?",
      "options": [
        { "text": "El punto no cala.", "correct": false, "note": "El coste inmediato, y se puede recuperar diciéndolo otra vez." },
        { "text": "Piensan que estás siendo manipulador.", "correct": false, "note": "Cerca de eso, y planteado como una impresión puntual en vez de como el efecto duradero." },
        { "text": "Tarda más de lo necesario.", "correct": false, "note": "Trivial comparado con lo que le hace a todo lo que digas después." },
        { "text": "Tu elogio deja de creerse.", "correct": true, "note": "A partir de entonces cada cosa agradable genuina produce un respingo mientras esperan el centro — en una relación en la que se supone que quieres decir cosas cálidas y que te tomen al pie de la letra." }
      ],
      "explain": "El elogio usado como envoltorio deja de ser elogio."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "no_sandwich", "label": "No lo hizo sándwich", "description": "Dijo la cosa sola." },
      { "key": "said_the_frame", "label": "Lo enmarcó con palabras", "description": "Dijo con claridad que era una cosa y no un veredicto." },
      { "key": "warmth_after", "label": "Guardó la calidez para después", "description": "Dejó que la amabilidad fuera amabilidad una vez terminado el contenido." },
      { "key": "clear", "label": "Fue inconfundible", "description": "No dejó dudas sobre qué se estaba sacando." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Jo",
      "role": "un compañero de trabajo con quien te llevas bien y trabajas bien",
      "mood": "Alegre.",
      "openness": 4,
      "personality": "Optimista. Oye el elogio con claridad y la crítica vaga nada en absoluto, y sale de una conversación ambigua alegremente sin que nada haya cambiado."
    },
    "setting": "Tienes que sacar algo concreto con alguien con quien trabajas bien y valoras de verdad.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Tómate cualquier elogio al pie de la letra y trata la crítica alrededor como un detalle menor.",
      "Implícate en serio y con especificidad con cualquier cosa dicha con claridad y sola.",
      "Nunca preguntes si hay un problema."
    ],
    "opening_beat": "«¿Querías hablar un momento?»",
    "success_looks_like": "La persona saca la cosa sola, de forma inconfundible."
  }$j$::jsonb,
  'Hoy, di un comentario difícil sin un cumplido a ningún lado. Apunta lo que dijiste.',
  $j${
    "beats": [
      {
        "situation": "Tienes que sacar algo concreto con un compañero que valoras de verdad. Te enseñaron a abrir con algo positivo.",
        "prompt": "¿Qué haces?",
        "options": [
          { "text": "Un cumplido, luego la cosa, luego un cumplido.", "correct": false, "note": "Un optimista oye el pan y nada cambia. Una persona ansiosa oye el relleno y aprende que tu elogio es envoltorio." },
          { "text": "Abre con calidez, luego sácalo, y déjalo ahí.", "correct": false, "note": "Medio sándwich sigue siendo un rodeo, y la calidez se sigue releyendo como técnica en cuanto llega el giro." },
          { "text": "Di la cosa sola, y di con claridad que es una cosa.", "correct": true, "note": "Consigue lo que el sándwich intentaba alcanzar — que esto no es un referéndum sobre ellos — diciéndolo en vez de con estructura." },
          { "text": "Sácalo y luego tranquilízalos largo y tendido después.", "correct": false, "note": "La tranquilidad que cumple una función se oye como tranquilidad que cumple una función. La calidez funciona cuando ha dejado de desplegarse." }
        ]
      },
      {
        "situation": "Has usado el sándwich con esta persona varias veces antes.",
        "prompt": "¿Qué ha costado eso, más allá de las conversaciones individuales?",
        "options": [
          { "text": "Nada duradero — cada una queda aislada.", "correct": false, "note": "La gente aprende patrones rápido, especialmente los que preceden a una crítica." },
          { "text": "Piensan peor de ti.", "correct": false, "note": "Normalmente no. El coste es sobre algo concreto, no sobre su opinión general." },
          { "text": "Tu elogio ahora produce un respingo.", "correct": true, "note": "Esperan el centro. En una relación en la que quieres decir cosas cálidas y que te crean, eso es algo caro de haber gastado." },
          { "text": "Han dejado de tomarse en serio el feedback.", "correct": false, "note": "Cerca, y es la mitad de la crítica. El daño duradero está en el otro lado." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('saying-the-thing', 5,
  'Dilo una vez',
  $md$Lo has dicho. Hay un silencio. Y las ganas de decirlo otra vez, de forma distinta, son enormes.

**La jugada:** dilo una vez y deja que el silencio sea suyo.

Lo que produce la repetición no es la creencia de que no te oyeron bien. Es la incomodidad del hueco, y el miedo a que la versión que diste no fuera del todo correcta — así que ofreces una segunda, y una tercera, cada una un poco más suave que la anterior porque cada una se entrega en un silencio que se siente como desaprobación.

El coste es concreto. Tres versiones de un punto son más débiles que una, porque la segunda implica que la primera era inadecuada y la tercera sugiere que estás negociando contigo mismo. Y el suavizado es real: casi nadie repite algo difícil con más firmeza, así que para la tercera pasada te has convencido a ti mismo de algo con lo que pueden estar de acuerdo fácilmente y no actuar en absoluto.

El silencio tampoco es lo que parece. Alguien a quien acaban de decirle algo difícil está haciendo un trabajo — decidiendo si es cierto, recordando los casos, pensando qué decir. Eso lleva unos segundos y esos segundos son suyos. Llenarlos te devuelve la conversación, y ahora tienen dos cosas a las que responder.

En la práctica: di las tres partes, y luego para y cuenta hasta cinco. Son cinco segundos muy largos y es toda la técnica.

Si no dicen nada en absoluto después de eso, un empujón está bien — *¿qué piensas?* — y es una pregunta en vez de una repetición, que es la diferencia que importa.

Y si de verdad no fuiste claro, di lo mismo otra vez con las mismas palabras en vez de una formulación nueva. Repetir está bien; escalar y diluir no lo están, y una versión nueva casi siempre es una de las dos cosas.

Si te quedas con una cosa: deja de hablar. El silencio después de una frase difícil es alguien pensando, y está haciendo más trabajo que cualquier cosa que pudieras añadir.$md$,
  $j$[
    {
      "situation": "Lo has dicho y hay un silencio.",
      "line": "(cuenta hasta cinco)",
      "why": "Alguien a quien acaban de decirle algo difícil está decidiendo si es cierto. Esos segundos son suyos y llenarlos te devuelve la conversación."
    },
    {
      "situation": "Estás a punto de decirlo otra vez, algo distinto.",
      "line": "(la segunda versión implica que la primera era inadecuada)",
      "why": "Y casi nadie repite algo difícil con más firmeza — para la tercera pasada te has convencido a ti mismo de algo fácil de aceptar e imposible de llevar a la práctica."
    },
    {
      "situation": "El silencio de verdad se ha alargado.",
      "line": "¿Qué piensas?",
      "why": "Una pregunta en vez de una repetición, que es la diferencia que importa."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué la gente lo dice tres veces?",
      "options": [
        { "text": "Creen que no se oyó.", "correct": false, "note": "El motivo que la gente da después. En el momento va sobre el hueco, no sobre su comprensión." },
        { "text": "El silencio es incómodo.", "correct": true, "note": "Y el miedo a que la versión dada no fuera del todo correcta, así que se ofrece una segunda en un silencio que se siente como desaprobación." },
        { "text": "Quieren ser justos.", "correct": false, "note": "La equidad produce el suavizado, no la repetición, y el suavizado es el problema de segundo orden." },
        { "text": "Tienen más que decir.", "correct": false, "note": "Rara vez — es el mismo punto con palabras nuevas, que es lo que lo convierte en dilución en vez de en algo añadido." }
      ],
      "explain": "Di las tres partes, para, y cuenta hasta cinco. Son cinco segundos muy largos."
    },
    {
      "prompt": "¿Qué cuesta la tercera versión?",
      "options": [
        { "text": "Tiempo.", "correct": false, "note": "Lo de menos. Una conversación larga está bien si el punto sobrevive." },
        { "text": "Hace que suenes inseguro.", "correct": false, "note": "Así es, y esa es la impresión, no el mecanismo." },
        { "text": "Te has negociado a ti mismo hasta algo inaplicable.", "correct": true, "note": "Casi nadie repite algo difícil con más firmeza, así que cada pasada es más suave — y para la tercera pueden estar de acuerdo fácilmente y no hacer nada." },
        { "text": "Dejan de escuchar.", "correct": false, "note": "Escuchan las tres y actúan sobre la más débil, que es peor." }
      ],
      "explain": "Si tienes que repetir, usa las mismas palabras. Una versión nueva casi siempre es escalada o dilución."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "once", "label": "Lo dijo una vez", "description": "No ofreció una segunda versión." },
      { "key": "counted", "label": "Dejó correr el silencio", "description": "Esperó en vez de llenarlo." },
      { "key": "no_softening", "label": "No lo suavizó", "description": "El punto terminó donde empezó." },
      { "key": "question", "label": "Dio pie con una pregunta", "description": "Si acaso, preguntó en vez de repetir." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Jo",
      "role": "alguien con quien acabas de sacar un tema",
      "mood": "Asimilándolo.",
      "openness": 4,
      "personality": "Se toma unos segundos de verdad para pensar, y responde bien si se le dan. Se agarra a la versión más suave si se le ofrecen varias."
    },
    "setting": "Acabas de decir el hecho, el efecto y la petición. Todavía no ha dicho nada.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Tómate varios segundos antes de tu primera respuesta sustancial, y describe la pausa.",
      "Responde a la versión más débil ofrecida si la persona repite el punto.",
      "Implícate en serio con la versión original si la persona espera."
    ],
    "opening_beat": "(silencio — está mirando la mesa)",
    "success_looks_like": "La persona no dice nada hasta que el otro habla."
  }$j$::jsonb,
  'Hoy, di algo difícil una vez y luego deja de hablar hasta que respondan. Apunta cuánto duró el silencio.',
  $j${
    "beats": [
      {
        "situation": "Has dicho el hecho, el efecto y la petición. Está mirando la mesa y no ha hablado. Han pasado unos cuatro segundos.",
        "prompt": "¿Qué haces?",
        "options": [
          { "text": "Dilo otra vez, más claro.", "correct": false, "note": "La segunda versión implica que la primera era inadecuada, y casi nadie repite algo difícil con más firmeza." },
          { "text": "Suavízalo — asegúrate de que sepan que no es gran cosa.", "correct": false, "note": "Esto es la retractación. Cuatro segundos de incomodidad te acaban de costar todo el punto." },
          { "text": "Nada. Cuenta hasta cinco.", "correct": true, "note": "Está decidiendo si es cierto y recordando los casos. Esos segundos son suyos, y llenarlos le devuelve la conversación." },
          { "text": "Pregunta si está bien.", "correct": false, "note": "Amable, y convierte tu incomodidad en su problema a gestionar — treinta segundos después de haberle pedido que gestionara otra cosa." }
        ]
      },
      {
        "situation": "Has esperado, y todavía no ha dicho nada.",
        "prompt": "¿Ahora?",
        "options": [
          { "text": "Dilo de otra forma, por si el problema era cómo lo dijiste.", "correct": false, "note": "Una formulación nueva casi siempre es dilución o escalada. Si tienes que repetir, usa las mismas palabras." },
          { "text": "Deja que el silencio continúe indefinidamente.", "correct": false, "note": "En algún momento se convierte en un enfrentamiento, que es algo distinto y menos útil que una pausa." },
          { "text": "Discúlpate por lo incómodo.", "correct": false, "note": "Convierte la dificultad de la conversación en el tema, y está a un paso de retirar el punto." },
          { "text": "Pregunta qué piensa.", "correct": true, "note": "Una pregunta en vez de una repetición, que es la diferencia que importa. Le cede la palabra sin debilitar nada." }
        ]
      }
    ]
  }$j$::jsonb
);
