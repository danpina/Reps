-- Spanish: Interviews, track 6 — Llamadas de criba y sintonía.
--
-- Conventions as migration 109. Notes:
--
-- **"Notice period" is "el preaviso".** A Spanish contract has one and the
-- reader knows the word, so the logistics example lands as the same ordinary
-- fact it is in English.
--
-- **Backchannelling has no Spanish noun,** so the theory describes it instead
-- of naming it: the small "ya", "claro", "vale" you make while somebody else
-- is talking. Inventing a term for it would have made a cheap habit sound
-- like a technique.
--
-- **Lesson 5 has no rehearsal_spec in English and none here.** It is a scene.

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

select pg_temp.es_lesson('interview-rapport', 1,
  'La criba es una entrevista de verdad',
  $md$Se pierden más buenos candidatos en la llamada de criba de veinte minutos que en ninguna otra fase, y casi todos se pierden por el mismo motivo: la trataron como un trámite.

Entiende qué está haciendo de verdad la persona que llama. Normalmente no está en condiciones de juzgar tu oficio, lo sabe, y no lo está intentando. Está decidiendo tres cosas.

**Si esta persona sabe mantener una conversación.** Te va a poner delante de alguien cuyo tiempo es caro, y su propia credibilidad se gasta en esa presentación.

**Si quiere este puesto en concreto.** No un puesto. Este. Un candidato que no sabe decir por qué es un candidato que se caerá en la fase de oferta, que es el peor resultado posible para quien criba.

**Si hay algo alarmante.** Rencor hacia una empresa anterior, evasivas con las fechas, una expectativa de sueldo que dobla la banda, una disponibilidad que no cuadra.

Nada de esa lista va de lo bueno que eres. Así que una respuesta construida para demostrar pericia está apuntada a una diana que no está ahí, y encima suele llegar como evasiva, porque quien escucha no puede saber si respondiste.

**La jugada:** responde a las tres preguntas que de verdad te están haciendo — si sabes hablar, si quieres esto, si hay algo raro.

Dos consecuencias prácticas. Ten una respuesta de una línea a *por qué nosotros* que no pudiera decirse de nadie más. Y trata a quien criba como a alguien que va a ser tu aliado el resto del proceso, porque normalmente lo es: informa al panel, te cuenta qué le importa a quien contrata, y te defiende en la puesta en común. Quien despacha rápido a la persona de selección pierde a un defensor que nunca supo que tenía.$md$,
  $j$[
    {
      "situation": "Responder a la pregunta de apertura de quien criba a la altura correcta.",
      "line": "A grandes rasgos, llevo seis años en operaciones de negocios de comercio electrónico, los tres últimos llevando un equipo de cinco. Vuestra oferta es casi exactamente eso, una talla más grande, y esa es la parte que quiero.",
      "why": "Encaja con lo que piden en sus propios términos y responde a «¿quiere este puesto?» en el mismo aliento. Quien criba puede apuntar esto y usarlo literalmente, que es justo lo que quieres que haga."
    },
    {
      "situation": "Tratar a quien criba como a un aliado y no como a una puerta.",
      "line": "Antes de terminar: ¿hay algo sobre cómo ve este puesto la persona que contrata que no se deduzca de la oferta?",
      "why": "Quien hace selección sabe cosas que nadie escribe, y normalmente le encanta que se las pregunten. Además señala que te lo estás preparando en serio, que es lo que informa después."
    },
    {
      "situation": "Tratar un dato que suena alarmante antes de que se vuelva alarmante.",
      "line": "Una cosa que vale la pena avisar ahora para que no sea una sorpresa luego: tengo tres meses de preaviso. Es negociable hasta unos dos, y prefiero decírtelo al principio y no en la oferta.",
      "why": "A quien criba le horrorizan más las sorpresas tardías que las malas noticias. Sacar pronto la logística incómoda se lee como profesionalidad y quita de en medio lo que más descarrila las ofertas."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué filtra sobre todo una llamada de criba?",
      "options": [
        { "text": "La profundidad técnica, que resumirá para quien contrata.", "correct": false, "note": "Normalmente no puede evaluarla y sabe que no puede. La profundidad apuntada aquí no queda registrada casi nunca." },
        { "text": "Si entrevistas bien, si quieres este puesto, y si algo va a explotar más adelante.", "correct": true, "note": "Esas tres, en ese orden. Todo lo demás sobre cómo llevar una criba se deduce de ellas." },
        { "text": "Las expectativas de sueldo, que es por lo que la pregunta sale siempre.", "correct": false, "note": "Está en la lista de cosas que podrían explotar más adelante, pero es un elemento y no el propósito de la llamada." },
        { "text": "En cuántos procesos más estás, para calibrar la urgencia.", "correct": false, "note": "Lo preguntan a menudo, y les informa el calendario. Rara vez decide si pasas o no." }
      ],
      "explain": "Ninguna de las tres va de lo bueno que eres en el trabajo. Las respuestas construidas para demostrar pericia apuntan a una diana que no está en la sala."
    },
    {
      "prompt": "¿Por qué merece la pena ser generoso con el tiempo de quien criba?",
      "options": [
        { "text": "Porque decide si avanzas.", "correct": false, "note": "Verdad y el motivo superficial. Es también el motivo por el que la gente es amable de forma transaccional, que se nota exactamente como lo que es." },
        { "text": "Porque informará al panel, te dirá qué le importa a quien contrata, y hablará por ti en la puesta en común.", "correct": true, "note": "Es la única persona del proceso que está de tu lado por defecto. Quien la trata como un obstáculo pierde un defensor." },
        { "text": "Porque puede tener otros puestos si este no sale.", "correct": false, "note": "Real, pero lento e incierto. El valor en este proceso es mucho más inmediato que el valor en el siguiente." }
      ],
      "explain": "Quien criba es la única persona de la sala que quiere que salgas bien antes de que hayas demostrado nada."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "right_altitude", "label": "Apuntó a quien llamaba", "description": "Respondió a un nivel que quien criba podía evaluar y repetir." },
      { "key": "wanted_this_job", "label": "Demostró que quería este", "description": "Dio un motivo para este puesto en concreto y no entusiasmo general." },
      { "key": "no_red_flags", "label": "Nada alarmante", "description": "Ni rencor, ni evasivas, ni logística que aparece tarde." },
      { "key": "treated_as_ally", "label": "La trató como a una persona", "description": "Se relacionó con quien cribaba como con un aliado y no como con una puerta que hay que cruzar." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Jess Whitcombe",
      "role": "una reclutadora de agencia haciendo una primera criba",
      "mood": "Animada y algo acelerada. Hoy tiene cinco de estas y recuerda como dos.",
      "openness": 4,
      "personality": "Habladora, eficiente, y astuta con las personas más que con el trabajo. Pregunta por la motivación dos veces, con otras palabras. Se enciende de forma perceptible con los candidatos que le preguntan algo."
    },
    "setting": "Una llamada de criba de veinte minutos, agendada con poca antelación, al móvil.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta por la motivación dos veces, formulado de otra forma, en momentos distintos de la llamada.",
      "Pregunta en algún momento por el preaviso y la disponibilidad.",
      "Si una respuesta se pone técnica, di algo como «eso se me escapa un poco, pero lo paso» y salta a lo siguiente.",
      "Enciéndete de forma perceptible si la persona te hace una pregunta sobre el puesto o sobre quien contrata.",
      "Nunca evalúes a la persona ni expliques qué estás buscando."
    ],
    "opening_beat": "«Hola, gracias por cogerlo. Tengo tu CV delante y el puesto del cliente. Antes de entrar en los detalles, cuéntame un poco qué estás buscando.»",
    "success_looks_like": "La persona da una respuesta breve y ajustada, da un motivo concreto para querer este puesto, saca pronto cualquier logística incómoda, y le hace a Jess al menos una pregunta."
  }$j$::jsonb,
  'Llama o escribe a alguien que contrate gente — de selección, un jefe, un amigo que entrevista — y pregúntale qué le hace descartar a alguien en la fase de criba. Apunta la respuesta.',
  $j${
    "beats": [
      {
        "situation": "Alguien de selección llama para una criba de veinte minutos. Estás entre reuniones y no es la entrevista de verdad.",
        "prompt": "¿Cómo la tratas?",
        "options": [
          { "text": "Como la entrevista de verdad, porque la lista corta se decide aquí.", "correct": true, "note": "La criba es la única ronda que es puramente eliminatoria. A nadie lo contratan en ella y a casi todo el mundo lo quitan en ella." },
          { "text": "Como una llamada administrativa para confirmar lo básico.", "correct": false, "note": "Así se presenta y no lo es. Quien criba está decidiendo qué tres CV llegan a quien contrata con una frase pegada." },
          { "text": "Con educación, pero guárdate tu material para quien contrata.", "correct": false, "note": "Si esto sale plano, no hay ronda con quien contrata para la que guardarlo." },
          { "text": "Como una oportunidad de averiguar si el puesto merece la pena.", "correct": false, "note": "Merece la pena hacerlo, y no en lugar de lo anterior. Los dos estáis cribando; solo a uno lo pueden quitar hoy." }
        ]
      },
      {
        "situation": "Quien criba no es técnico y no puede evaluar si eres bueno.",
        "prompt": "¿Qué está decidiendo en realidad?",
        "options": [
          { "text": "Si sabes hablar, si lo quieres, y si el dinero cuadra.", "correct": true, "note": "Las tres cosas para las que existe una criba. Las tres las puede responder alguien que no puede juzgar tu trabajo, que es exactamente por eso que son esas tres." },
          { "text": "Si tu CV es exacto.", "correct": false, "note": "Una parte pequeña, y no es lo que te hace pasar. La exactitud se da por supuesta hasta que deja de estarlo." },
          { "text": "Cómo encaja tu experiencia con los requisitos.", "correct": false, "note": "Ese es el trabajo de quien contrata. Quien criba comprueba que sabes describirlo, no si es suficiente." },
          { "text": "Si le caes bien.", "correct": false, "note": "Más cerca de lo que suena y demasiado vago para actuar. Responde a las tres de arriba y lo de caer bien viene solo." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-rapport', 2,
  'Ponte a su registro',
  $md$La sintonía en una llamada no es calidez. Es encaje: la sensación de que hablar contigo no le cuesta nada a la otra persona. Y en una llamada de teléfono, sin una cara que leer, el encaje lo llevan casi por entero tres cosas: cuánto duran tus frases, cuán formales son, y a qué velocidad vas.

La gente es extremadamente sensible al desajuste aquí y casi nunca consciente de él. Quien llama con prisa y recibe respuestas de noventa segundos te vive como algo pesado. Quien llama con ganas de charla y recibe respuestas secas te vive como alguien frío, y así te describirá después sin saber decir por qué.

Así que lee los primeros treinta segundos y ponte a la par.

**La longitud.** Si sus preguntas son de una frase, responde en tres o cuatro, no en quince. Si te está contando su fin de semana, tienes sitio.

**La formalidad.** Toma prestado su vocabulario. Si dice *los chicos del equipo*, tú también puedes. Si dice *el área de entrega*, quédate en ese registro.

**El ritmo.** Quien habla rápido vive las pausas como duda; quien habla despacio vive la velocidad como presión.

**La jugada:** ponte a la longitud y a la formalidad de sus frases en los dos primeros intercambios.

Esto no es ser camaleón y no es insinceridad. Es el mismo ajuste que haces entre hablar con un compañero y hablar con tu abuela, hecho a propósito durante veinte minutos.

Hay una asimetría que conviene saber: es más fácil aflojar que apretar. Empieza algo más formal de lo que esperas terminar, y ve bajando detrás. Empezar demasiado informal con alguien que resulta ser formal es un agujero del que se tarda la llamada entera en salir.

Y cuando se rían, ríete. Los candidatos tan preparados para que los evalúen que se pierden un chiste se leen como tensos, y tenso es el adjetivo que termina una llamada de criba.$md$,
  $j$[
    {
      "situation": "Alguien de selección con prisa, con el registro ajustado.",
      "line": "Selección: «¿Preaviso?» — «Dos meses, negociables a seis semanas.»",
      "why": "Cuatro palabras a una pregunta de dos. La tentación es explicar la negociación, al jefe, el traspaso. Nada de eso se ha pedido y todo eso frenaría la llamada."
    },
    {
      "situation": "Alguien de selección con ganas de charla, con el registro ajustado.",
      "line": "Selección: «Perdona, mi perro ha decidido que es el momento.» — «Te digo que el mío hizo lo mismo la semana pasada en una llamada con un cliente. A media frase, directo por delante de la cámara.»",
      "why": "Coger el compás social que te ofrecen en vez de ignorarlo con educación. Treinta segundos aquí compran más calidez que cualquier respuesta de la llamada, y rechazarlo se registra como rigidez."
    },
    {
      "situation": "Empezar formal e ir bajando detrás de la otra persona.",
      "line": "«Buenos días, gracias por sacar el rato.» … cuatro minutos después … «Sí, esa es justo la parte que a mí también me sacaría de quicio.»",
      "why": "La dirección correcta del viaje. Aflojar según se calienta la llamada es natural; el viaje al revés, de demasiado informal a apropiadamente profesional, siempre parece una corrección."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Quien llama hace preguntas cortas y secas. Tú das respuestas minuciosas de dos minutos. ¿Cómo te describirá después?",
      "options": [
        { "text": "Minucioso y con atención al detalle.", "correct": false, "note": "De vez en cuando, si el detalle hacía falta. Mucho más a menudo la nota dice algo menos halagador sobre la longitud." },
        { "text": "Trabajoso.", "correct": true, "note": "Esa es la palabra, o alguna versión de ella. El desajuste se vive como esfuerzo, y el esfuerzo en una llamada de veinte minutos se recuerda." },
        { "text": "Seguro de sí mismo.", "correct": false, "note": "La longitud no se lee como seguridad. Si acaso, responder de más a una pregunta corta se lee como ansiedad." },
        { "text": "Técnicamente fuerte.", "correct": false, "note": "Quien criba no está en condiciones de concluir eso, y una respuesta larga no le ayuda a concluir nada." }
      ],
      "explain": "El encaje se siente como esfuerzo. Sea cual sea el contenido, una respuesta con la longitud equivocada le cuesta algo a quien escucha."
    },
    {
      "prompt": "No sabes cuán formal es quien llama. ¿Por dónde deberías empezar?",
      "options": [
        { "text": "Algo más formal de lo que esperas, e ir bajando detrás.", "correct": true, "note": "Aflojar es fácil y natural; apretar después de haber sido demasiado informal siempre parece una corrección, y van a recordar la primera impresión." },
        { "text": "Informal: construye sintonía más rápido y la calidez es el objetivo.", "correct": false, "note": "Construye sintonía rápido con la mitad de quienes llaman, que son informales, y crea con la otra mitad un problema que dura la llamada entera." },
        { "text": "En tu registro natural, y que se ajusten ellos.", "correct": false, "note": "No se van a ajustar. Tú eres quien está siendo evaluado, y la carga del encaje recae en quien está siendo entrevistado." }
      ],
      "explain": "La formalidad es fácil de quitarse y difícil de ponerse. Empieza medio escalón por encima."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "length_match", "label": "Ajustó la longitud", "description": "Las respuestas eran proporcionadas a las preguntas que le hicieron." },
      { "key": "register_match", "label": "Ajustó el registro", "description": "La formalidad y el vocabulario seguían a los de la otra persona." },
      { "key": "took_the_social_beat", "label": "Cogió los compases sociales", "description": "Entró en los momentos humanos en vez de tratarlo todo como evaluación." },
      { "key": "direction", "label": "Aflojó en vez de apretar", "description": "Empezó profesional y se fue calentando, en vez de empezar informal y corregir." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Baz Nolan",
      "role": "un reclutador interno que lleva las llamadas como una charla",
      "mood": "Relajado y cercano. Última llamada del día.",
      "openness": 5,
      "personality": "Muy informal. Suelta algún taco suave, se interrumpe a sí mismo, te cuenta cosas de la empresa que probablemente no debería. Lee la formalidad como frialdad y se lo dirá a sus compañeros sin querer ser injusto."
    },
    "setting": "Una llamada de criba con alguien notablemente más informal que la media.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Sé informal de forma constante. Interrúmpete al menos una vez, y suelta un pequeño cotilleo sobre el equipo.",
      "Haz preguntas cortas. Si recibes una respuesta larga y formal, contesta con algo corto y ligeramente desinflador.",
      "Suelta al menos un chiste o un comentario al margen y mira si la persona lo coge.",
      "Nunca comentes su tono ni le digas que se relaje."
    ],
    "opening_beat": "«Vale, perdona, tengo como cuatro pestañas abiertas y ninguna es la tuya. Dame dos segundos. Ya está. ¿Y bien, cuál es la historia, por qué estás buscando?»",
    "success_looks_like": "La persona afloja hasta el registro de Baz sin dejar de ser profesional, mantiene las respuestas proporcionadas, y coge los compases sociales que le ofrece."
  }$j$::jsonb,
  'En tu próxima llamada de teléfono con quien sea, ponte a propósito a la longitud de sus frases durante los dos primeros minutos. Apunta qué notaste en cómo fue la llamada.',
  $j${
    "beats": [
      {
        "situation": "Quien criba abre con: «Vale, perdona, tengo como cuatro pestañas abiertas y ninguna es la tuya. Dame dos segundos. Ya está. ¿Y bien, cuál es la historia, por qué estás buscando?»",
        "prompt": "¿Cómo respondes?",
        "options": [
          { "text": "Suelto y breve, en el registro que ha marcado.", "correct": true, "note": "Te ha dicho cómo va esta llamada. Una respuesta formal en tres partes a «cuál es la historia» aterriza como alguien que no estaba escuchando." },
          { "text": "Con tu arco preparado de noventa segundos entero.", "correct": false, "note": "La respuesta correcta a otra pregunta. Ajustar la longitud es casi todo ajustar el registro, y su pregunta tenía once palabras." },
          { "text": "Formalmente, para marcar un tono profesional.", "correct": false, "note": "Corregirle el registro a alguien es una cosa rara que hacer en el primer minuto de una llamada donde deciden tu semana." },
          { "text": "Ponerte a su informalidad y añadir un chiste.", "correct": false, "note": "Ajustarse no es subir. Pasarse un punto de alguien en los dos primeros intercambios es la versión que falla." }
        ]
      },
      {
        "situation": "Otra llamada. Quien contrata habla en frases cuidadas y completas, y hace una pausa antes de cada una.",
        "prompt": "¿Qué haces?",
        "options": [
          { "text": "Bajar el ritmo y dejar que tus frases terminen.", "correct": true, "note": "El registro es longitud y formalidad, y funciona en las dos direcciones. La velocidad frente a alguien pausado se lee como nervios, estés nervioso o no." },
          { "text": "Mantener tu ritmo natural para sonar auténtico.", "correct": false, "note": "La autenticidad no es un ritmo. Ponerse a la par de alguien es la forma más barata de resultar fácil de escuchar." },
          { "text": "Rellenar sus pausas para que la llamada no se pare.", "correct": false, "note": "Esas pausas son él pensando. Rellenarlas le quita lo que está haciendo." },
          { "text": "Imitar las pausas exactamente.", "correct": false, "note": "Ajustarse, no imitar. Copiar el ritmo de alguien compás a compás se nota y resulta raro." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-rapport', 3,
  'Por qué esta empresa, en una línea',
  $md$Esta es la pregunta que más candidatos suspenden, y el listón está vergonzosamente bajo. Casi todas las respuestas son un cumplido, una descripción de la empresa devuelta a la empresa, o una afirmación sobre la propia carrera. Ninguna de esas responde.

Una respuesta de verdad tiene una propiedad: no podría decirse de la empresa de enfrente.

Llegar ahí cuesta unos quince minutos de preparación, y esos quince minutos no se gastan en la página de «quiénes somos».

**Mira qué han sacado o cambiado hace poco.** Una decisión de producto, un artículo, una reorganización, un cambio de precios.

**Mira la descripción del puesto como prueba.** Cómo está escrito un puesto te dice qué ha estado saliendo mal. Una descripción que menciona cuatro veces la gestión de las partes implicadas es la descripción de un trabajo donde nadie conseguía que se acordara nada.

**Encuentra a una persona.** Alguien que trabaje ahí, que haya escrito o hablado de ello, y que dijera algo que te contó cómo es por dentro.

Y luego construye la línea: una cosa concreta, más qué te dice, más por qué eso te importa a ti.

**La jugada:** nombra una cosa concreta sobre ellos, di qué te dice, y di por qué eso es lo que quieres.

La longitud es una trampa aquí. Pasados unos treinta segundos deja de sonar a un motivo y empieza a sonar a un discurso comercial. Dilo, y para.

Dos advertencias. No uses la respuesta de «me encanta vuestro producto» salvo que sea verdad y concreta: *lo uso todos los días* invita a *¿y qué cambiarías?*, y de no tener nada no se sale. Y evita el elogio por completo: decirle a una empresa que es líder del mercado es información que ya tiene, entregada por alguien sin autoridad para calificarla.$md$,
  $j$[
    {
      "situation": "Una cosa concreta, qué te dice, por qué la quieres.",
      "line": "Publicasteis el informe de la caída de marzo con los tiempos reales dentro. Casi ninguna empresa lo haría, y eso me dice que aquí la cultura de ingeniería no castiga a la gente por ser visible. Eso es justo lo que no tengo donde estoy.",
      "why": "Imposible de decir sobre nadie más, apoyado en algo público, y termina en un motivo personal y no en un halago. La última frase explica sin ruido por qué se va, sin una palabra de queja."
    },
    {
      "situation": "Leer la descripción del puesto como prueba.",
      "line": "La oferta dice «cómodo con la ambigüedad» dos veces y menciona tres equipos por su nombre. Mi lectura es que el puesto existe porque esos tres equipos todavía no se ponen de acuerdo, y ese es sinceramente el trabajo que más me gusta.",
      "why": "Demuestra que el candidato lee con atención y piensa en qué revela un documento. Además le da a quien entrevista la oportunidad de confirmar el diagnóstico, lo que casi siempre produce una conversación genuinamente útil."
    },
    {
      "situation": "Usar a una persona como el detalle concreto.",
      "line": "Escuché a vuestra jefa de diseño en un pódcast en primavera, y dijo aquello de sacar primero la versión fea. Llevo años defendiendo eso y perdiendo. Un sitio que ya se lo cree vale mucho para mí.",
      "why": "Concreto, comprobable, y dice algo sobre los valores del candidato al mismo tiempo. «Llevo años defendiendo eso y perdiendo» es el tipo de admisión pequeña que hace que la respuesta entera suene verdadera."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué respuesta a «por qué nosotros» está haciendo trabajo de verdad?",
      "options": [
        { "text": "Sois claramente los líderes del sector y quiero aprender de los mejores.", "correct": false, "note": "Elogio, e información que ya tienen. Además insinúa que cogerías el mismo puesto en quien liderara el año que viene." },
        { "text": "El puesto encaja muy bien con mis capacidades y es el siguiente paso lógico para mí.", "correct": false, "note": "Esto responde a «por qué este trabajo para ti», que es otra pregunta. Podría ser cierto de cuarenta empresas." },
        { "text": "El año pasado pasasteis a publicar cada dos semanas y escribisteis por qué. Llevo dos años intentando que se apruebe eso donde estoy.", "correct": true, "note": "Un dato concreto y comprobable, y un motivo personal pegado. Nadie más podría recibir esta respuesta." },
        { "text": "Llevo años siguiendo a la empresa y siempre he admirado su cultura.", "correct": false, "note": "No se puede verificar y es vaga. «Cultura» sin un ejemplo pegado es la palabra menos informativa que hay en una entrevista." }
      ],
      "explain": "La prueba es si la respuesta seguiría teniendo sentido dirigida a su competidor más cercano. Si la tuviera, no es una respuesta."
    },
    {
      "prompt": "¿Dónde está el mejor sitio para encontrar el detalle concreto que necesitas?",
      "options": [
        { "text": "La página de «quiénes somos» y los valores de la empresa.", "correct": false, "note": "Escritos para todo el mundo, lo que significa que no distinguen nada. Devolverles sus valores es la respuesta floja más común que existe." },
        { "text": "Las noticias recientes en prensa.", "correct": false, "note": "Mejor, pero suelen ir de financiación o de crecimiento, y es lo que habrán leído todos los demás candidatos." },
        { "text": "Algo que hayan sacado, escrito o cambiado, o lo que revela la descripción del puesto.", "correct": true, "note": "Restos de lo que de verdad hicieron, y un documento escrito por quien te va a contratar. Los dos son concretos y los dos están infrautilizados." }
      ],
      "explain": "Busca pruebas de decisiones y no declaraciones de intenciones. Las decisiones distinguen; las intenciones no."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "specific", "label": "Nombró algo concreto", "description": "Señaló un resto real, una decisión o un detalle, en vez de una impresión general." },
      { "key": "not_transferable", "label": "No podría decirse en otro sitio", "description": "La respuesta no tendría sentido dirigida a un competidor." },
      { "key": "personal_reason", "label": "Lo conectó consigo", "description": "Explicó por qué ese detalle le importa, en vez de solo elogiarlo." },
      { "key": "brevity", "label": "No pasó de treinta segundos", "description": "Lo dijo y paró, en vez de convertirlo en un discurso comercial." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Elliot Ward",
      "role": "un responsable de contratación cansado de respuestas genéricas",
      "mood": "Justo pero poco impresionado por defecto. Esta semana ya ha oído la palabra «innovador» seis veces.",
      "openness": 3,
      "personality": "Educado y un poco fatigado. Ante una respuesta genérica pregunta «¿qué te hace decir eso?» y espera, que es donde casi todos los candidatos descubren que no tenían nada."
    },
    "setting": "Una entrevista de primera ronda, a los diez minutos. La pregunta llega antes de lo esperado.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si la respuesta es genérica o halagadora, pregunta «¿qué te hace decir eso?» y espera.",
      "Si la persona nombra algo concreto y real, engánchate: confírmalo, complícalo, o cuéntale la versión de dentro.",
      "No aceptes el entusiasmo como respuesta, y no des señales de estar poco impresionado.",
      "No te alargues por turno."
    ],
    "opening_beat": "«Déjame saltar a algo que me importa más que el CV. ¿Por qué nosotros? Y prefiero una respuesta corta y honesta a una buena.»",
    "success_looks_like": "La persona nombra una cosa concreta y comprobable sobre la empresa, dice qué le dice, y la conecta con algo que quiere personalmente."
  }$j$::jsonb,
  'Coge una empresa real y dedica quince minutos a encontrar una cosa sobre ella que no podría decirse de un competidor. Di tu respuesta de una línea en voz alta a alguien y pregúntale si sonó a investigada o a educada. Apúntalo.',
  $j${
    "says": "¿Por qué nosotros? Y prefiero una respuesta corta y honesta a una buena.",
    "model": {
      "line": "Sois los únicos que he encontrado que publican los informes de las caídas. Leí tres y eran honestos de una forma que me dijo cómo es trabajar aquí de verdad. Eso es justo lo que me falta donde estoy.",
      "why": "Una cosa concreta sobre ellos, qué te dijo, y por qué eso es lo que quieres. Nada de ello podría decirse de otra empresa, que es toda la prueba."
    },
    "checks": [
      { "kind": "max_sentences", "n": 3, "requirement": "Tres frases como mucho" },
      { "kind": "min_words", "n": 15, "requirement": "Di qué te dijo el detalle, no solo que te gustó" },
      { "kind": "forbids_any", "words": ["oportunidad apasionante", "me apasiona", "líder del mercado", "líderes del mercado", "líder del sector", "líderes del sector", "muy buen ambiente", "vanguardia", "ritmo rápido", "sinergia"], "requirement": "Nada de palabras de folleto" }
    ],
    "maxChars": 500
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-rapport', 4,
  'Los primeros cinco minutos',
  $md$La entrevista empieza antes de la primera pregunta, y una cantidad sorprendente del veredicto queda fijada en la parte que todo el mundo trata como preámbulo.

No es porque quien entrevista sea superficial. Es porque el intercambio de apertura es el único dato sin estructura que consigue: todo lo que viene después está ensayado, y lo sabe. Así que los dos minutos sobre tu viaje, el tiempo o el edificio son la muestra tuya en la que más confía.

Tres cosas que hay que hacer bien.

**Ten algo que decir cuando te pregunten qué tal.** No *bien*. Una frase concreta, ligera y verdadera. *Bien, moderadamente sorprendido de haber encontrado vuestro edificio a la primera.* No cuesta nada y es la primera prueba que tienen de que hablar contigo es fácil.

**Mete una pregunta tuya en la apertura.** No una preparada. Algo sobre la sala, la oficina, el día. Convierte a dos personas interpretando papeles en dos personas hablando.

**Aterriza la transición a propósito.** Cuando digan *bueno, ¿empezamos?* — enderézate un poco y cierra la charla limpiamente. A los candidatos que siguen charlando pasada la transición se les lee como alguien que no capta señales.

**La jugada:** responde al saludo con algo concreto y verdadero, y luego sigue su transición hacia la entrevista limpiamente.

En vídeo, tres cosas más, todas mecánicas y todas valen más de lo que deberían. Estate dos minutos antes y ya con el micro abierto. Mira a la cámara en la primera frase y en la última, hagas lo que hagas en medio. Y ten un plan para cuando falle la tecnología, dicho en voz alta y sin apuro — *¿os llamo por teléfono?* — porque hoy le va a pasar a alguien y ser quien lo resuelve con calma es crédito gratis.

No inviertas de más. La apertura no es donde se gana el puesto. Es donde se hace, en silencio, más fácil o más difícil.$md$,
  $j$[
    {
      "situation": "Responder al saludo con algo real.",
      "line": "«¿Qué tal?» — «Bien, gracias. Un poco acelerado: me he tomado dos cafés esperando abajo y me arrepiento de uno.»",
      "why": "Ligero, concreto, con algo de autoironía, y admite los nervios sin quedarse hundido en ellos. Quien entrevista ya tiene algo a lo que responder, que es el sentido entero del intercambio."
    },
    {
      "situation": "Meter una pregunta en la apertura.",
      "line": "«¿El equipo entero está en esta planta, o es solo cosa de las salas de reuniones?»",
      "why": "Sin preparar, fácil de responder, y sobre el sitio en vez de sobre el proceso. Las preguntas así convierten una entrevista en una conversación unos dos minutos antes de lo habitual."
    },
    {
      "situation": "Gestionar un fallo de vídeo sin apuro.",
      "line": "«Te estás cortando, ¿queréis probar a quitar el vídeo, o os llamo por teléfono? Cualquiera me vale.»",
      "why": "Se hace cargo de un problema que no es culpa de nadie y ofrece dos opciones. Es una demostración minúscula de exactamente el aplomo para el que están contratando, entregada antes de que empiece la entrevista."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué la charla del principio pesa más de lo que merece?",
      "options": [
        { "text": "Porque las primeras impresiones son difíciles de mover después.", "correct": false, "note": "Verdad pero genérico. Explica que la impresión persista, no por qué quien entrevista le da tanto peso a ese intercambio en concreto." },
        { "text": "Porque es la única muestra tuya sin ensayar que van a conseguir.", "correct": true, "note": "Todo lo que viene después está preparado, y lo saben. La apertura es la única parte que leen sin filtro." },
        { "text": "Porque pone a prueba las habilidades sociales, que son parte del trabajo.", "correct": false, "note": "A veces sí se evalúa explícitamente, pero el peso viene de estar sin ensayar y no de ser social." }
      ],
      "explain": "Se confía en ella precisamente porque no estaba preparada. Lo cual es un motivo para haberla pensado, ligeramente, de antemano."
    },
    {
      "prompt": "Quien entrevista dice «bueno, ¿empezamos?». ¿Cuál es la respuesta correcta?",
      "options": [
        { "text": "Terminar la idea que estabas contando para que no se quede colgada.", "correct": false, "note": "La charla no necesita resolverse. Seguir pasada una transición es la forma más común de que un candidato señale que no lee una sala." },
        { "text": "Cerrar la charla limpiamente y seguirle dentro.", "correct": true, "note": "Coger la transición es en sí mismo una señal social, y se está notando. Media frase para aterrizarla, y ya estás listo." },
        { "text": "Hacer una pregunta más sobre la oficina para crear sintonía.", "correct": false, "note": "La ventana de sintonía la acaba de cerrar quien la abrió. Reabrirla te cuesta el crédito que ganaron los dos primeros minutos." },
        { "text": "Decir que estás listo y preguntar cuál será la estructura de la sesión.", "correct": false, "note": "Razonable y algo burocrático. Casi todo el mundo te lo dice igualmente, y preguntarlo hace que el arranque se sienta como un trámite." }
      ],
      "explain": "Sigue sus señales. Quien abrió la charla es quien tiene derecho a cerrarla."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "real_greeting", "label": "Respondió bien al saludo", "description": "Dijo algo concreto y verdadero en vez de «bien, gracias»." },
      { "key": "asked_something", "label": "Aportó algo suyo", "description": "Contribuyó con una pregunta o una observación en vez de solo responder." },
      { "key": "transition", "label": "Siguió la transición", "description": "Cerró la charla limpiamente cuando quien entrevistaba pasó a otra cosa." },
      { "key": "composure", "label": "Con aplomo en lo mecánico", "description": "Gestionó cualquier contratiempo técnico o logístico sin apuro." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Anne-Marie Osei",
      "role": "una responsable de contratación que se une a una videollamada entre otras dos reuniones",
      "mood": "Con prisa pero cercana. Se asentará en dos minutos si la apertura va bien.",
      "openness": 4,
      "personality": "Cálida y algo agobiada. Se disculpa por llegar tarde, hace charla mientras abre documentos, y hace la transición de golpe cuando está lista."
    },
    "setting": "Los primeros dos minutos de una entrevista por vídeo. El candidato se ha conectado pronto y quien entrevista llega algo tarde, con una conexión que no está del todo estable.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Dedica dos intercambios a la charla, y luego haz la transición de golpe con «bueno, ¿empezamos?».",
      "Ten un problema más de conexión durante la charla y mira cómo lo lleva la persona.",
      "Si sigue charlando después de tu transición, responde brevemente y luego haz tu primera pregunta de entrevista por encima.",
      "Nunca comentes cómo está quedando la persona."
    ],
    "opening_beat": "Su vídeo se congela y se descongela a media frase. «—perdona, ¡hola! ¿Me oyes? Llevo reuniones encadenadas desde las ocho. ¿Qué tal estás?»",
    "success_looks_like": "La persona responde al saludo con algo concreto, lleva la conexión inestable sin aspavientos, aporta algo suyo, y sigue la transición limpiamente cuando llega."
  }$j$::jsonb,
  'La próxima vez que alguien te pregunte qué tal, responde con algo concreto y verdadero en vez de «bien». Apunta qué le pasó después a la conversación.',
  $j${
    "turns": [
      { "instruction": "Te ha preguntado qué tal, a media disculpa, entre reuniones. Responde con algo concreto y verdadero en vez de «bien, gracias»." },
      { "instruction": "Ahora sigue su transición hacia la entrevista. No alargues la charla más allá de donde ella la dejó." }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-rapport', 5,
  'Sin cara que leer',
  $md$Una entrevista por teléfono le quita más o menos la mitad de la información a las dos personas, y casi todos los problemas específicos de una criba telefónica vienen de una de dos cosas: silencio que se malinterpreta, o turnos de palabra que salen mal.

**El silencio se alarga.** En persona, una pausa de dos segundos la rellena una cara: un asentimiento, un gesto de estar pensando. En una llamada son dos segundos de nada, y la nada es incómoda, así que los dos empiezan a hablar para terminarla. El candidato explica de más; quien entrevista interrumpe. Ninguno quería.

El arreglo es ser algo más explícito de lo que resulta natural. Señala en voz alta el final de una respuesta: *…y ahí es donde quedó.* Señala en voz alta que estás pensando: *Déjame pensarlo un segundo.* Las dos cosas sobran en persona y sostienen la conversación en una llamada.

**Los turnos de palabra no tienen señal visual.** Ese pequeño inclinarse hacia delante que dice *quiero hablar* es invisible. Así que cuando choques con la otra persona, para de inmediato y cédele el turno — *no, no, sigue* — y hazlo rápido. Dos personas disculpándose a la vez durante diez segundos es la vergüenza más común de una entrevista telefónica.

**La jugada:** di en voz alta cuándo has terminado una respuesta y cuándo estás pensando.

Dos más, las dos baratas. Los ruiditos: el *ya*, *claro*, *vale* mientras hablan. En persona asientes; por teléfono, asentir es silencio, y el silencio se lee como ausencia. Y ponte de pie. Cambia la voz más de lo que nadie espera, y la voz es el canal entero.

Por último: nada de tu entorno es invisible. Una llamada cogida andando, en el coche, o en una habitación con eco se lee como una llamada que no priorizaste, y ese juicio se hace en los primeros diez segundos.$md$,
  $j$[
    {
      "situation": "Señalar el final de una respuesta.",
      "line": "…así que lo sacamos en marzo, y desde entonces ha estado tranquilo. Esa es toda la historia, en realidad.",
      "why": "La última frase es un punto final que la otra persona puede oír. Sin él, quien entrevista por teléfono no puede saber si has terminado o estás cogiendo aire, y o interrumpe o espera de forma incómoda."
    },
    {
      "situation": "Comprar tiempo para pensar de forma explícita.",
      "line": "Es una buena pregunta y quiero darte una respuesta de verdad y no la primera que se me ocurra. Dame un segundo.",
      "why": "Convierte el silencio de un problema en una intención declarada. Quien entrevista responde bien a esto casi siempre, y evita la respuesta a medio formar que suele producir el silencio."
    },
    {
      "situation": "Recuperarse de haber hablado a la vez.",
      "line": "«—perdona, sigue.» [y entonces callarse de verdad]",
      "why": "Tres palabras y luego silencio. El modo de fallo es que los dos digan «no, tú» dos veces; quien cede limpio y de inmediato lo termina, y ser esa persona no cuesta nada."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué las entrevistas telefónicas producen tanto explicar de más?",
      "options": [
        { "text": "Los candidatos están más nerviosos sin contacto visual.", "correct": false, "note": "A menudo cierto, y no es el mecanismo. Un montón de candidatos relajados explican de más por teléfono por el mismo motivo estructural." },
        { "text": "El silencio es incómodo y no hay ninguna cara que lo rellene.", "correct": true, "note": "La pausa que en persona cubriría un asentimiento se convierte en aire vacío, y el candidato lo rellena. Nombrar el final de tu respuesta quita el vacío." },
        { "text": "Por teléfono se hacen preguntas más amplias.", "correct": false, "note": "Las preguntas de criba suelen ser más estrechas, no más amplias. La longitud viene del medio, no de la pregunta." },
        { "text": "En una llamada hay más tiempo disponible.", "correct": false, "note": "Normalmente hay menos: las cribas son cortas, lo que hace explicar de más más caro y no más asequible." }
      ],
      "explain": "El medio quita el punto final visual. Ponlo tú con palabras."
    },
    {
      "prompt": "¿Qué costumbre importa más en una llamada solo de voz?",
      "options": [
        { "text": "Hacer pequeños ruiditos mientras hablan.", "correct": true, "note": "Es lo que hace asentir en persona. Sin ello quien escucha suena ausente, y quien habla empieza a preguntarse si se ha caído la línea." },
        { "text": "Hablar más despacio todo el rato.", "correct": false, "note": "Útil en una línea mala, y sobre todo es una medida de comodidad. No resuelve ni los turnos ni el silencio." },
        { "text": "Tomar notas para poder volver a sus preguntas.", "correct": false, "note": "Genuinamente útil, y además crea pausas. Merece la pena hacerlo, pero no es lo que hace que una llamada se sienta fácil." }
      ],
      "explain": "En una llamada, escuchar tiene que ser audible. El silencio de quien escucha no se distingue de la ausencia."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "signalled_endings", "label": "Señaló el final de las respuestas", "description": "Hizo audible cuándo había terminado una respuesta." },
      { "key": "named_thinking", "label": "Dijo cuándo estaba pensando", "description": "Rellenó las pausas deliberadas con una intención declarada en vez de con palabras." },
      { "key": "turn_taking", "label": "Gestionó los choques limpiamente", "description": "Cedió de inmediato cuando hablaron los dos a la vez, sin un largo intercambio de disculpas." },
      { "key": "audible_listening", "label": "Escuchó de forma audible", "description": "Hizo ruiditos mientras la otra persona hablaba, para que la línea no se quedara muerta." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Frank Ostrowski",
      "role": "un responsable de contratación haciendo una entrevista telefónica",
      "mood": "Paciente. El silencio le parece bien de verdad y no lo vive como incómodo.",
      "openness": 3,
      "personality": "Reflexivo y lento al hablar. Deja pausas largas. De vez en cuando empieza a hablar en el mismo momento que el candidato por el retardo de la línea."
    },
    "setting": "Una entrevista solo de voz en una línea con un retardo mínimo, lo que hace más probables los choques.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Deja pausas largas después de que la persona termine de hablar. No corras a rellenarlas.",
      "Al menos dos veces, empieza a hablar en el mismo momento que la persona: escríbelo como un solapamiento interrumpido.",
      "Si no señala el final de una respuesta, espera en vez de dar por hecho que ha terminado.",
      "Nunca menciones la mecánica de las conversaciones telefónicas ni comentes cómo la está llevando."
    ],
    "opening_beat": "«Vale, te oigo perfectamente. Hay algo de retardo por mi lado, así que perdóname si te piso. Arráncame: ¿qué estás haciendo ahora mismo?»",
    "success_looks_like": "La persona señala los finales de sus respuestas, nombra sus pausas de pensar, y gestiona al menos un choque cediendo limpia e inmediatamente."
  }$j$::jsonb,
  'Coge hoy una llamada de teléfono de pie, y di en voz alta cuándo has terminado una idea. Apunta si la llamada fue distinta.',
  NULL
);
