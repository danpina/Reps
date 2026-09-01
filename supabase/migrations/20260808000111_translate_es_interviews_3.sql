-- Spanish: Interviews, track 3 — Responder con pruebas.
--
-- Conventions as migration 109. One lesson in this track could not be
-- translated, only rewritten, and it is worth saying why.
--
-- **Lesson 2 is about "we", and Spanish has no "we".** The English drill bans
-- four words — we, our, us, ours — and that is the whole mechanism. Spanish
-- drops the subject pronoun, so the collective voice hides inside the verb
-- ending: "reescribimos" is exactly the sentence the lesson is trying to
-- catch, and there is no pronoun in it to ban. Banning the ending itself is
-- not available either: "mos" as a substring also matches mostrar, mosca and
-- mostrador.
--
-- So the check bans what can honestly be enumerated — nosotros, nuestro, and
-- the dozen plural verbs people actually reach for when describing work — and
-- the theory carries the rest. That is not a loss. The Spanish version of this
-- lesson is genuinely sharper than the English one, because in Spanish the
-- word that makes you invisible is invisible itself, and saying so is a better
-- lesson than the one that was translated away.
--
-- **Numbers.** The English "from X to Y" becomes "pasó de X a Y", so the check
-- looks for the multi-word forms. Bare "de" and "a" would match every sentence
-- in the language.

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

select pg_temp.es_lesson('interview-evidence', 1,
  'Dos frases de decorado',
  $md$*Cuéntame alguna vez que…* es una invitación a demostrar algo, y casi todo el mundo se gasta la invitación en montar el escenario.

Mira lo que le pasa a una respuesta sin entrenar. Treinta segundos estableciendo la empresa, la estructura del equipo, el trimestre en que ocurrió, quién reportaba a quién. Y entonces la repregunta llega antes de la parte buena, o el candidato se da cuenta de la hora y corre el final. El material estaba ahí. Nunca llegó a salir.

La escena existe solo para que lo demás tenga sentido. Dos frases: cuál era la situación, y por qué era difícil. Esa segunda mitad es la que la gente se salta, y es la que hace que cuente todo lo que viene después: a nadie le puede impresionar la solución a un problema que no sabía que era difícil.

**La jugada:** dos frases de escena, una de las cuales dice por qué era difícil, y luego directo a lo que hiciste.

Las proporciones a las que apuntar, dentro de unos dos minutos: quince segundos de escena, sesenta de acción, quince de resultado, y el resto es respirar.

Si te encuentras explicando el organigrama, te has equivocado. A nadie lo contratan por las líneas de reporte de su antigua empresa.$md$,
  $j$[
    {
      "situation": "Responder a una pregunta sobre gestionar a alguien difícil con quien tienes que trabajar.",
      "line": "Estábamos a tres semanas del lanzamiento y el director comercial quería una funcionalidad que habría llevado seis. Lo difícil es que no se equivocaba en que hacía falta: se equivocaba en cuándo.",
      "why": "Dos frases, y la segunda enuncia la dificultad con precisión. Además deja al comercial como alguien razonable, lo que señala sin ruido que quien responde no piensa en sus compañeros como obstáculos."
    },
    {
      "situation": "Una pregunta sobre un proyecto que fracasó.",
      "line": "Pasé unos cinco meses construyendo un portal de autoservicio que no usó prácticamente nadie. Lo que lo hacía difícil de detectar es que cada señal por separado era buena: las pruebas de usabilidad iban bien, a los clientes piloto les gustaba. Simplemente nunca preguntamos si alguien quería hacer esa tarea siquiera.",
      "why": "Un poco más de dos frases, y se lo gana: la oración de más es el diagnóstico, no el decorado. Fíjate en que no hay organigrama, ni fechas, ni nombres."
    },
    {
      "situation": "Una pregunta sobre trabajar bajo presión, respondida por alguien que no trabaja en una oficina.",
      "line": "Una de nuestras dos furgonetas se salió de la carretera el viernes de un puente. Todo lo de los cuatro días siguientes ya estaba cargado dentro.",
      "why": "Lo que está en juego se entiende al instante y sin una sola palabra técnica. Montar bien una escena no va del sector: va de hacerle sentir a un desconocido el tamaño del problema en un solo aliento."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué apertura hace más trabajo con menos palabras?",
      "options": [
        { "text": "Bueno, esto fue en mi empresa anterior, una empresa mediana, de unas doscientas personas, y yo estaba en el equipo de operaciones, que en aquel momento dependía del director de operaciones.", "correct": false, "note": "Treinta palabras, y ninguna de ellas es el problema. Todo esto es contexto que quien entrevista no va a usar jamás." },
        { "text": "Un proveedor quebró sin avisar, justo la semana en que teníamos que enviar el pedido más grande del año.", "correct": true, "note": "Situación y dificultad en una sola frase. Quien escucha ya sabe exactamente lo malo que es y puede juzgar todo lo que venga después." },
        { "text": "Este es un buen ejemplo, la verdad: probablemente fue lo más difícil que he hecho, y me enseñó mucho sobre la resiliencia.", "correct": false, "note": "Anuncia que la historia va a impresionar en lugar de impresionar. Quien entrevista decidirá si fue difícil; decírselo por adelantado gasta credibilidad en vez de construirla." }
      ],
      "explain": "La escena tiene un solo trabajo: hacer legible la dificultad. Todo lo que no haga eso es decoración."
    },
    {
      "prompt": "¿Cómo debería repartirse más o menos una respuesta de comportamiento de dos minutos?",
      "options": [
        { "text": "Mitad escena, mitad acción: el contexto es lo que hace comprensible la acción.", "correct": false, "note": "Este es el reparto por defecto y es la razón de que casi todas las respuestas rindan por debajo. El contexto es barato de dar cuando lo pidan; la acción no." },
        { "text": "Una escena corta, el grueso en lo que hiciste, y un final claro sobre lo que cambió.", "correct": true, "note": "Quince segundos, un minuto, quince segundos. Quien entrevista está evaluando tus acciones, así que ahí es donde va el tiempo." },
        { "text": "Sobre todo el resultado, ya que lo que consigue que contraten a alguien son los resultados.", "correct": false, "note": "Un resultado sin ninguna acción visible detrás suena a algo que ocurrió cerca de ti y no a algo que hiciste tú." }
      ],
      "explain": "Están puntuando el verbo. Presupuesta la respuesta en consecuencia."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "short_scene", "label": "Mantuvo corta la escena", "description": "Montó la historia en unas dos frases y no en un párrafo." },
      { "key": "named_difficulty", "label": "Dijo por qué era difícil", "description": "Hizo explícita la dificultad, para que el resto de la respuesta tuviera contra qué medirse." },
      { "key": "no_org_chart", "label": "Dejó fuera los muebles", "description": "Ni estructuras, ni fechas, ni tamaños de equipo, ni líneas de reporte innecesarias." },
      { "key": "reached_the_action", "label": "Llegó a la acción", "description": "Gastó el grueso de la respuesta en lo que hizo personalmente." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Helen Marsh",
      "role": "una entrevistadora llevando una ronda estructurada de competencias",
      "mood": "Neutral. Es su cuarta entrevista de hoy y está siendo escrupulosamente justa con todas.",
      "openness": 2,
      "personality": "Metódica y agradable. Hace la pregunta, espera, escribe. No te va a ayudar a encontrar la respuesta, y no va a rescatar un silencio."
    },
    "setting": "Una entrevista de comportamiento estructurada. Quien entrevista tiene una lista impresa de preguntas y está puntuando contra una rúbrica, que se ve encima de la mesa.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si el montaje de la escena se alarga, aguántalo en silencio y luego pregunta «¿y qué hiciste?». No des señales de impaciencia.",
      "Nunca digas si una respuesta ha sido buena. Escribe una nota, reconoce brevemente, pasa a lo siguiente.",
      "Si la persona da una respuesta sin ninguna acción visible, pregunta una vez «¿cuál fue tu parte en eso?».",
      "No te alargues más de una o dos frases por turno."
    ],
    "opening_beat": "Helen lee de la hoja sin levantar la vista. «Cuéntame alguna vez que tuvieras que entregar algo con menos tiempo del que pedía el trabajo.» Después levanta la vista y espera.",
    "success_looks_like": "La persona monta la escena en unas dos frases, incluida por qué era difícil, y luego gasta la respuesta en sus propias acciones."
  }$j$::jsonb,
  'Pídele hoy a alguien que te suelte una pregunta del tipo «cuéntame alguna vez que», en frío, sin avisarte de cuál. Respóndela en voz alta. Apunta cuánto tiempo pasó antes de que dijeras lo que hiciste tú.',
  $j${
    "turns": [
      { "instruction": "Dos frases de escena, y una de ellas tiene que decir por qué era difícil. No más de dos." },
      { "instruction": "Ahora lo que hiciste. Aquí es donde vive la respuesta, así que dale el sitio que no tuvo la escena." },
      { "instruction": "Termina en qué fue distinto después." }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-evidence', 2,
  'La palabra que te vuelve invisible',
  $md$En inglés hay una palabra cara en una entrevista: *we*. En español es peor, porque no hay palabra. El plural se esconde dentro del verbo.

*Reescribimos el sistema de triaje.* Ahí no hay ningún pronombre que tachar, y por eso este error es más difícil de oír en español que en cualquier otro idioma: no dijiste *nosotros*, así que no te oyes decirlo. Pero quien te entrevista no puede contratar al equipo. Cada logro que llega en primera persona del plural cae en un cubo que no le sirve, y quien habla así toda la entrevista sale de la sala habiendo descrito una buena empresa en vez de un buen candidato.

El arreglo no es reclamar más. Es ser preciso con la frontera.

Di lo que hizo el equipo una vez, en la escena: *el equipo estaba reconstruyendo el proceso de pago.* Y a partir de ahí cambia al singular y quédate ahí. *Yo cogí la mitad de los pagos. Encontré que la lógica de reintentos estaba cobrando dos veces a uno de cada cuatrocientos. Escribí el arreglo y me senté una semana con soporte para cazar los que ya habíamos mandado.*

Eso es honesto. No le has robado nada a nadie. Y ahora quien entrevista tiene algo que evaluar.

**La jugada:** el equipo se lleva una frase en la escena; todo lo que viene después va en singular.

Hay una versión de segundo orden que merece la pena conocer. Si dirigiste el trabajo, el singular no basta: liderar se ve en verbos que actúan sobre otras personas. *Conseguí que los dos equipos acordaran un único responsable. Convencí al jefe de soporte de dejar el proceso manual.* Son frases en singular que van visiblemente sobre un grupo, y son la prueba de veteranía más fuerte que existe.

Vigila también la pasiva refleja, que es el plural disfrazado. *Se decidió aplazarlo* es una frase sin nadie dentro.$md$,
  $j$[
    {
      "situation": "Describir un logro de equipo sin desaparecer dentro de él.",
      "line": "El equipo bajó las incidencias de unas nueve al mes a dos. Mi parte fueron las alertas: reescribí los umbrales para dejar de avisar por cosas sobre las que nadie actuaba, que eran como dos tercios.",
      "why": "El mérito se le da al equipo en la primera frase, y luego viene una afirmación precisa sobre una aportación concreta. Convence más que «bajamos las incidencias» y que «bajé las incidencias», porque es evidentemente verdad."
    },
    {
      "situation": "Alguien que dirigió el trabajo, demostrándolo sin decir «yo lideraba».",
      "line": "Metí a los tres responsables de equipo en una sala y les hice elegir una sola definición de usuario activo. Costó dos horas y no fueron dos horas divertidas, pero todos los informes que salieron después coincidían entre sí.",
      "why": "No usa nunca la palabra liderazgo y lo demuestra entero. Los verbos van sobre mover a otras personas, y se admite el coste, lo que lo hace real."
    },
    {
      "situation": "Rescatar una respuesta a mitad al notar la deriva hacia el plural.",
      "line": "…y entonces decidimos — perdona, eso no es del todo exacto. Dos queríamos revertirlo y yo era uno de los dos. Defendí mi postura en el canal de la incidencia y salió al revés, y creo que fue la decisión equivocada.",
      "why": "Corregirte en voz alta no cuesta nada y compra mucho. Se lee como precisión y no como trastabillarse, y aquí produce una respuesta mucho más interesante de lo que habría sido la versión ordenada."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Quien te entrevista pregunta cuál fue tu papel en un proyecto que acabas de describir en plural de principio a fin. ¿Qué es esa pregunta?",
      "options": [
        { "text": "Curiosidad normal sobre la estructura del equipo.", "correct": false, "note": "Rara vez va de la estructura. Esto lo preguntan cuando no consiguen encontrar al candidato dentro de la historia." },
        { "text": "Un intento de rescate: te están dando una segunda oportunidad de ser visible.", "correct": true, "note": "Es la pregunta de salvamento más común que hay en una entrevista, y significa que la primera respuesta no aterrizó. Cógela y sé concreto." },
        { "text": "Una trampa, para ver si te atribuyes más de la cuenta.", "correct": false, "note": "Alguna gente sí lo comprueba, pero suele sonar distinto: «¿quién más participó en eso?». Ser vago aquí para parecer humilde se lee como no haber tenido ningún papel." }
      ],
      "explain": "Si te preguntan cuál fue tu papel, la respuesta hasta ahora ha sido una historia sobre una empresa. Respóndela con precisión, y no vuelvas al plural después."
    },
    {
      "prompt": "¿Qué frase demuestra más veteranía?",
      "options": [
        { "text": "Yo era responsable de la entrega del programa entero.", "correct": false, "note": "Una afirmación con forma de cargo. Enuncia el alcance sin pruebas, y quien entrevista no tiene manera de comprobarlo, así que aterriza como una aseveración." },
        { "text": "Lo entregamos dos semanas antes a pesar de perder a un desarrollador.", "correct": false, "note": "Buen resultado, candidato invisible. Aquí no hay nada que se pueda atribuir a la persona que está en la sala." },
        { "text": "Se decidió recortar el módulo de informes y lanzar sin él.", "correct": false, "note": "Pasiva refleja, sin nadie dentro. Esta es la forma más común de esconderse de las propias buenas decisiones." },
        { "text": "Convencí al patrocinador de que nos dejara recortar el módulo de informes, y por eso llegamos a lanzar.", "correct": true, "note": "Una frase en singular cuyo verbo actúa sobre otra persona, con la consecuencia pegada. El liderazgo se ve en lo que moviste, no en cómo te llamaban." }
      ],
      "explain": "La veteranía se ve en verbos sobre personas y en consecuencias que puedes nombrar. Los cargos y las pasivas la esconden por igual."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "visible_i", "label": "Era visible en su propia historia", "description": "Habló en singular de sus propias acciones en vez de irse por defecto al plural." },
      { "key": "fair_credit", "label": "Le dio al equipo su frase", "description": "Reconoció al equipo una vez, en la escena, en vez de borrarlo o de esconderse detrás." },
      { "key": "no_passive", "label": "Esquivó el escaqueo de la pasiva", "description": "Ninguna frase donde una decisión ocurre sin que nadie la tome." },
      { "key": "boundary", "label": "Marcó la frontera con precisión", "description": "Quedó claro dónde acababa el trabajo del equipo y dónde empezaba el suyo." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Tom Bridger",
      "role": "un jefe de ingeniería que hurga buscando concreción",
      "mood": "Positivo. Quiere que esto salga bien y necesita algo concreto con lo que defenderlo en la puesta en común.",
      "openness": 4,
      "personality": "Simpático e incansable. Cada vez que una respuesta es colectiva, hace una pregunta que estrecha el foco. Sin agresividad: simplemente sigue hasta que encuentra a la persona."
    },
    "setting": "Una entrevista de segunda ronda en la que quien entrevistó antes ha avisado de que no consiguió saber qué hizo el candidato en realidad.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Cada vez que la persona hable en plural de algo que suene a logro, haz una pregunta que estreche el foco: «¿quién hizo esa parte?» o «¿cuál fue la tuya?».",
      "No expliques por qué sigues preguntando. Mantente cercano.",
      "Si la persona se atribuye algo poco plausible, pregunta con neutralidad quién más participó.",
      "Nunca elogies ni corrijas cómo lo dice."
    ],
    "opening_beat": "«Lo que quiero sacar hoy es qué aportas tú en concreto. Elige cualquier trabajo del que estés orgulloso y llévame por él.»",
    "success_looks_like": "La persona reconoce al equipo una vez y luego habla en primera persona del singular de sus propias decisiones y acciones, incluido al menos un verbo que actúa sobre otras personas."
  }$j$::jsonb,
  'Descríbele a alguien, en voz alta y durante dos minutos, un trabajo del que estés orgulloso. Pídele después que te cuente qué hiciste tú personalmente. Apunta la distancia entre lo que querías decir y lo que oyó.',
  $j${
    "says": "Lo que quiero sacar es qué aportaste tú en concreto. ¿Qué hiciste exactamente?",
    "model": {
      "line": "Reescribí las reglas de triaje a lo largo de unas tres semanas, me senté con dos de los responsables de soporte para contrastar cada regla con tickets reales, y luego formé al turno de guardia en la versión nueva antes de que entrara en producción.",
      "why": "Cuatro verbos, todos tuyos, y ni un solo plural. El equipo puede ir en la escena; esta parte de la respuesta es la parte que están contratando."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Habla en singular, y sigue haciéndolo" },
      { "kind": "forbids_any", "words": ["nosotros", "nuestro", "nuestra", "nuestros", "nuestras", "hicimos", "conseguimos", "logramos", "decidimos", "construimos", "montamos", "arreglamos", "reducimos", "lanzamos", "empezamos", "se decidió"], "requirement": "Ni un plural, y ninguna frase sin nadie dentro" },
      { "kind": "min_words", "n": 25, "requirement": "Suficiente detalle como para que solo pudieras ser tú" }
    ],
    "maxChars": 500
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-evidence', 3,
  'Termina en qué cambió',
  $md$Una respuesta que para en la acción suena a esfuerzo. Una respuesta que termina en el cambio suena a impacto. Las palabras de en medio pueden ser idénticas.

Casi todo el mundo termina sus historias donde terminó el trabajo, porque ahí es donde termina su recuerdo. Pero quien entrevista no está puntuando el trabajo. Está puntuando qué pasó por su culpa, y si no se lo cuentas, asumirá que estuvo bien y olvidará la historia.

El final más fuerte es un número, y el número no tiene por qué impresionar. *Pasó de un día a unos diez minutos* es un buen número. También lo es *dejamos de perder más o menos un pedido a la semana*. La precisión gana a la magnitud: un número pequeño y honesto convence más que uno grande y vago, porque un número grande y vago suena al número al que echa mano quien no tiene ninguno.

Si no hay un número honesto, termina en un cambio de estado. Qué era verdad después que no lo era antes. *Desde entonces nadie ha tenido que hacer eso a mano.* *Los dos equipos siguen usando la misma definición tres años después.* Ese último tipo — lo que te sobrevivió — es el mejor final disponible, porque demuestra que el arreglo fue real y no heroico.

**La jugada:** termina en qué fue distinto después, con un número si honestamente lo tienes.

No te inventes nunca el número. Preguntan cómo se midió con una frecuencia sorprendente, y no se sobrevive a no saber de dónde salió tu propia cifra. *Nunca llegué a tener una medición limpia, pero…* es una frase perfectamente aceptable y no te cuesta casi nada.$md$,
  $j$[
    {
      "situation": "Terminar una respuesta con un número modesto y exacto.",
      "line": "Al final estábamos cerrando el mes en unos tres días en vez de nueve. No es una transformación, pero el equipo de finanzas dejó de trabajar los fines de semana en enero, que es lo que de verdad les importaba.",
      "why": "El número es pequeño y exacto, y se traduce enseguida a lo que significó para una persona. Quien entrevista recuerda el detalle del fin de semana mucho después de haber olvidado la cifra."
    },
    {
      "situation": "Terminar cuando no existe ninguna medición.",
      "line": "Nunca tuve un antes y un después limpio. Lo que sí te puedo decir es que en el canal de escalados solía haber cuatro o cinco hilos al día y ahora está tan tranquilo que la gente pregunta si sigue vigilado.",
      "why": "Admite la ausencia de datos y luego pone en su lugar un cambio observable. Es mucho más fuerte que un porcentaje fabricado, y la propia admisión es la prueba de alguien cuidadoso con los números."
    },
    {
      "situation": "Terminar en lo que te sobrevivió.",
      "line": "La plantilla sigue siendo la que usan. Me fui hace dos años y el mes pasado alguien me mandó una captura con unas cuarenta filas más añadidas, lo cual me emocionó de una forma un poco rara.",
      "why": "Que algo dure es el resultado más difícil de fingir y el más convincente de oír. Además demuestra que construyó algo para otras personas y no para su propia evaluación."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué final es el más fuerte?",
      "options": [
        { "text": "Fue un éxito enorme y a la dirección le gustó mucho.", "correct": false, "note": "La opinión de otra persona, sin cuantificar. Le dice a quien entrevista cómo se recibió por dentro, que es algo que no tiene manera de sopesar." },
        { "text": "Así que así lo enfoqué, y creo que salió bastante bien.", "correct": false, "note": "Para en la acción y luego se cubre las espaldas. «Bastante bien» es el sonido de una respuesta sin final preparado." },
        { "text": "Los tickets sobre esa pantalla pasaron de unos treinta a la semana a dos o tres, y ahí se quedaron.", "correct": true, "note": "Concreto, modesto, comprobable, y ese «ahí se quedaron» demuestra sin ruido que fue un arreglo real y no un empujón temporal." },
        { "text": "Mejoró la eficiencia en más de un doscientos por ciento.", "correct": false, "note": "Un número grande sin unidad y sin punto de partida. ¿Eficiencia medida cómo? Una cifra así invita a una pregunta que probablemente no puedas responder." }
      ],
      "explain": "Pequeño y exacto gana a grande y vago siempre, y «y ahí se quedó» vale más que el número en sí."
    },
    {
      "prompt": "De verdad no sabes los números de tu mejor historia. ¿Qué haces?",
      "options": [
        { "text": "Estimar uno, señalándolo claramente como estimación.", "correct": false, "note": "Mejor que inventar, pero una estimación invita a «¿cómo has llegado a eso?», y ahora estás defendiendo aritmética en vez de describir tu trabajo." },
        { "text": "Elegir otra historia en la que sí tengas números.", "correct": false, "note": "A veces correcto, a menudo un error: la mejor historia suele serlo por otros motivos. No dejes que una cifra ausente descalifique buen material." },
        { "text": "Terminar en un cambio observable, y decir con claridad que nunca se midió.", "correct": true, "note": "Honesto, y mantiene la forma de la respuesta. Nombrar la ausencia de medición hace más creíble cualquier número que cites en otro sitio." }
      ],
      "explain": "Lo que hace falta es un final, no una estadística. Qué era verdad después que no lo era antes sirve perfectamente."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "had_an_ending", "label": "Terminó en el cambio", "description": "Acabó en qué fue distinto después y no en lo que hizo." },
      { "key": "honest_numbers", "label": "Los números eran honestos", "description": "Cualquier cifra citada era concreta y defendible, o se dijo con claridad que no existía." },
      { "key": "human_translation", "label": "Dijo qué significaba", "description": "Tradujo el resultado a algo que le importaría a una persona de fuera del trabajo." },
      { "key": "durability", "label": "Demostró que duró", "description": "Dio alguna señal de que el cambio se sostuvo en vez de ser un empujón puntual." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sofia Lindqvist",
      "role": "una controller financiera que asiste al panel de contratación",
      "mood": "Enganchada. Le gustan los candidatos cuidadosos con los números y está midiendo exactamente eso.",
      "openness": 3,
      "personality": "Precisa y calladamente divertida. Pregunta «¿y eso cómo lo mediste?» cada vez que aparece una cifra, sin ninguna aspereza. Respeta enormemente un «no lo medimos» y nunca lo dice."
    },
    "setting": "Una entrevista tipo panel en la que una de las dos personas que entrevistan es una financiera con cabeza para los datos que pregunta de dónde salen los números.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta «¿y eso cómo lo mediste?» ante cualquier cifra que cite la persona, exactamente una vez por cifra.",
      "Si admite que algo no se midió nunca, acéptalo con calidez y sigue adelante sin comentarlo.",
      "Si un número suena inflado, pregunta cuál era el punto de partida.",
      "No le digas a la persona si su respuesta ha sido fuerte."
    ],
    "opening_beat": "«Llévame por algo que cambiaras y que marcara una diferencia medible. Y te aviso ya de que voy a preguntarte cómo lo mediste.»",
    "success_looks_like": "La persona termina en un cambio concreto, cita solo números que puede sostener, y aguanta la pregunta de la medición sin encogerse y sin inventar."
  }$j$::jsonb,
  'Coge una historia que cuentes sobre tu trabajo y encuéntrale el final: el número, o la cosa que era distinta después. Cuéntala con ese final pegado. Apunta si reaccionaron de otra manera a la versión que sí tenía final.',
  $j${
    "says": "Y te aviso ya: voy a preguntarte cómo lo mediste.",
    "model": {
      "line": "Los tickets sobre esas seis preguntas pasaron de unos doscientos a la semana a menos de cuarenta. El equipo dejó de trabajar los sábados.",
      "why": "Un número donde existe uno honesto, y luego el cambio que significaba ese número. Una respuesta que termina en la acción suena a esfuerzo; esta termina en impacto."
    },
    "checks": [
      { "kind": "max_sentences", "n": 2, "requirement": "Dos frases. Esto es el final, no la historia." },
      { "kind": "contains_any", "words": ["pasó de", "pasaron de", "pasamos de", "por ciento", "la mitad", "el doble", "redujo", "menos", "más rápido", "bajó", "subió", "dejó de", "dejaron de", "dejamos de"], "requirement": "Di qué era verdad después que no lo era antes" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-evidence', 4,
  'Seis historias lo cubren casi todo',
  $md$Habrá unas cuarenta preguntas de comportamiento en circulación y están preguntando por seis cosas. Prepara historias, no respuestas.

Seis trabajos, elegidos de forma que entre todos cubran: algo que entregaste con una restricción encima, algo roto que arreglaste, un conflicto con otra persona, un fracaso, algo que dirigiste o influiste sin tener autoridad, y algo que aprendiste o sobre lo que cambiaste de opinión.

Casi todas las buenas historias sirven para tres o cuatro de esas. La historia del conflicto suele ser también la de la influencia. El fracaso suele ser también el aprendizaje. Eso no es hacer trampa: quien entrevista pregunta por una faceta tuya, y el mismo trabajo puede enseñar varias.

**La jugada:** ten seis historias en la cabeza, y elige la faceta por la que han preguntado.

La habilidad que se ejerce en la sala no es la memoria, es la puntería. La misma historia sobre un lanzamiento retrasado es una historia de entrega si cuentas la parte de recortar el alcance, una historia de conflicto si cuentas la parte de la discusión con comercial, y una historia de fracaso si cuentas la parte en la que lanzasteis igual y se rompió. Los mismos hechos, tres respuestas, y la puntería ocurre en la primera frase: *La parte de esto que va sobre desacuerdos es…*.

Dos reglas que mantienen esto honesto. No uses la misma historia dos veces en una entrevista: hace que una carrera parezca fina aunque no lo sea. Y no metas a la fuerza una historia en una pregunta donde no cabe; un candidato respondiendo a la pregunta que preparó en vez de a la que le han hecho es el fallo más visible que existe, y se puntúa con dureza.

Y que sean recientes. Una historia brillante de hace nueve años plantea la pregunta de qué has hecho desde entonces.$md$,
  $j$[
    {
      "situation": "Apuntar una historia a una pregunta sobre conflictos.",
      "line": "Voy a usar el retraso del lanzamiento para esto, pero la parte que va sobre desacuerdos es lo que pasó con nuestro director comercial. Había prometido la fecha a dos clientes antes de que la hubiéramos acordado por dentro.",
      "why": "Nombra la historia y acto seguido la apunta. Quien entrevista ya sabe qué faceta viene, así que montar la escena hace además de promesa sobre de qué va a ir la respuesta."
    },
    {
      "situation": "Negarse a meter con calzador una historia preparada en la pregunta equivocada.",
      "line": "Con sinceridad, el ejemplo más fuerte que tengo de eso no es del trabajo: es de llevar una liga de fútbol sala durante seis años. ¿Te vale, o prefieres que busque algo de un empleo?",
      "why": "Preguntar es mejor que forzar. Casi siempre dicen que sí, y estar dispuesto a decir «mi mejor ejemplo está en otro sitio» se lee como seguridad y no como una carencia."
    },
    {
      "situation": "Darte cuenta a mitad de entrevista de que una historia ya la has usado.",
      "line": "La migración ya la he usado, así que déjame coger otra: el año pasado hubo una cosa más pequeña que en realidad encaja mejor con esto de todos modos.",
      "why": "Dicho en voz alta, esto demuestra amplitud y conciencia de uno mismo en nueve palabras. Pensado en silencio, la misma constatación suele producir una respuesta peor y apresurada."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Tienes preparada una historia fuerte sobre influir sin autoridad. La pregunta va sobre una vez que fracasaste. ¿Cuál es el riesgo?",
      "options": [
        { "text": "Te quedarás sin material más adelante en la entrevista.", "correct": false, "note": "Un coste real, pero secundario. Seis historias suelen bastar para sobrevivir a alguna redistribución." },
        { "text": "Se darán cuenta de que respondiste a otra pregunta, y te puntuarán por eso.", "correct": true, "note": "Es la conducta más penalizada en una entrevista estructurada. Una rúbrica tiene una línea para «respondió a lo que se le preguntó», y una historia fuerte pero ajena saca un cero en ella." },
        { "text": "La historia impresionará menos fuera del contexto para el que estaba pensada.", "correct": false, "note": "Puede, pero lo de impresionar no es el asunto. El asunto es que se hizo una pregunta y no se respondió." }
      ],
      "explain": "Apuntar una historia a una pregunta está bien. Sustituir una pregunta por una historia no, y desde el otro lado de la mesa se ve mucho más de lo que parece desde este."
    },
    {
      "prompt": "¿Qué conjunto de seis historias está mejor preparado?",
      "options": [
        { "text": "Seis historias del puesto actual, todas recientes, todas cubriendo competencias distintas.", "correct": false, "note": "Lo de recientes está bien y la cobertura está bien, pero sacarlo todo de un solo trabajo hace que el resto del CV parezca inerte, y limita lo que puedes enseñar." },
        { "text": "Seis de los últimos cinco o seis años, elegidas de forma que entre todas cubran entrega, conflicto, fracaso, influencia, arreglar algo y aprender.", "correct": true, "note": "Amplitud en el tiempo y en la faceta. Este es el conjunto que te deja responder a casi cualquier cosa sin estirar nada." },
        { "text": "Tus tres mejores logros, contados extremadamente bien.", "correct": false, "note": "Tres se agotan dentro de los primeros cuarenta minutos, y «mejores logros» se escora entero hacia la entrega. La mitad de una entrevista de comportamiento va sobre cosas que salieron mal." },
        { "text": "Una historia por pregunta probable, con guion preparado.", "correct": false, "note": "Los guiones se rompen en cuanto la pregunta viene formulada de forma inesperada, que es lo que va a pasar. Las historias son flexibles; los guiones son quebradizos." }
      ],
      "explain": "Prepara material, no respuestas. La pregunta decide qué cara del material enseñas."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "answered_the_question", "label": "Respondió a lo que se preguntó", "description": "La historia sirvió a la pregunta y no la pregunta a la historia." },
      { "key": "aimed_it", "label": "La apuntó explícitamente", "description": "Señaló pronto qué parte de la historia venía a cuento en esta pregunta." },
      { "key": "range", "label": "Enseñó amplitud", "description": "No se apoyó en un solo trabajo para todas las respuestas." },
      { "key": "recency", "label": "Bastante reciente como para contar", "description": "Los ejemplos eran lo bastante actuales como para decir algo sobre quién es ahora." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Adaeze Nwosu",
      "role": "una entrevistadora sénior recorriendo un marco de competencias",
      "mood": "Práctica. Cuatro áreas que cubrir y cuarenta minutos para hacerlo.",
      "openness": 3,
      "personality": "Eficiente y justa. Se mueve rápido entre áreas y nota al instante cuando una historia se reutiliza o se dobla para que encaje."
    },
    "setting": "Una entrevista de competencias de cuarenta minutos que cubre cuatro áreas distintas una detrás de otra.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta por cuatro competencias distintas en orden: desacuerdo, fracaso, entregar con una restricción encima, e influir sobre alguien sobre quien no tenías autoridad.",
      "Si la persona reutiliza una historia, di una vez y con neutralidad: «esa ya la has mencionado, ¿hay otra?».",
      "Si una respuesta no aborda la competencia por la que se preguntaba, vuelve a hacer la pregunta con otras palabras en vez de aceptarla.",
      "Pasa a lo siguiente enseguida después de cada respuesta. No evalúes."
    ],
    "opening_beat": "«Tenemos cuatro áreas que cubrir, así que voy a llevarnos rápido. La primera: cuéntame alguna vez que estuvieras en desacuerdo con alguien por encima de ti.»",
    "success_looks_like": "La persona responde a cada pregunta con un trabajo distinto, apunta cada historia a la faceta por la que se pregunta, y no mete a la fuerza una respuesta preparada en la pregunta equivocada."
  }$j$::jsonb,
  'Apunta seis trabajos de los últimos cinco años, una línea cada uno. Luego pídele a alguien que elija uno al azar y te haga sobre él una pregunta que no hayas elegido tú. Respóndela en voz alta y apunta sobre cuál de los seis no tenías nada que decir.',
  $j${
    "beats": [
      {
        "situation": "Tienes seis historias. Una es la reconstrucción del triaje: no estabas de acuerdo con tu jefe sobre el enfoque, lo defendiste durante un mes, ganaste, y funcionó.",
        "prompt": "La pregunta es: cuéntame alguna vez que estuvieras en desacuerdo con alguien por encima de ti.",
        "options": [
          { "text": "Contar la historia del triaje, con la cara del desacuerdo por delante.", "correct": true, "note": "La misma historia, otra faceta. Gastas las palabras en el mes de discusión y el resultado se lleva una frase, porque el resultado no es lo que han preguntado." },
          { "text": "Buscar una historia que vaya solo sobre un desacuerdo.", "correct": false, "note": "Así es como uno acaba con veinte historias y ninguna lista. Seis historias bien conocidas tienen más facetas de las que te van a preguntar nunca." },
          { "text": "Contar la historia del triaje como la cuentas normalmente.", "correct": false, "note": "Entonces es una respuesta sobre un proyecto con un desacuerdo mencionado dentro, y quien entrevista tiene que hacer el trabajo de encontrar lo que pidió." },
          { "text": "Decir que sueles estar de acuerdo con la gente sénior.", "correct": false, "note": "Lo cual responde a otra pregunta sobre ti, y mucho peor." }
        ]
      },
      {
        "situation": "Siguiente pregunta: cuéntame alguna vez que tuvieras que convencer a alguien.",
        "prompt": "¿Y ahora qué?",
        "options": [
          { "text": "Otra vez la historia del triaje, con la cara de la persuasión por delante.", "correct": true, "note": "Reutilizar una historia en dos preguntas está bien y rara vez lo notan, porque les estás contando cosas distintas. Seis historias están pensadas para reutilizarse." },
          { "text": "Cualquier cosa menos la del triaje: la acabas de usar.", "correct": false, "note": "La regla que la gente se inventa, al precio de contar mal una historia peor. Están escuchando la faceta, no auditando tu catálogo." },
          { "text": "La historia del triaje, contada igual que antes.", "correct": false, "note": "Ahora sí es repetición en vez de reutilización, y esta es la versión que sí notan." },
          { "text": "Una historia nueva, para enseñar amplitud.", "correct": false, "note": "La amplitud la enseñan las seis, no negarse a reutilizar una. Una historia nueva y floja cuesta más que una fuerte repetida." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-evidence', 5,
  'Cuando no lo has hecho nunca',
  $md$Antes o después te piden un ejemplo de algo que no has hecho. El instinto es estirar algo cercano hasta que cubra, y el estiramiento se oye siempre.

Hay tres salidas honestas, y elegir la correcta es casi toda la habilidad.

**El ejemplo cercano, etiquetado.** *No he dirigido a personas directamente. Lo más parecido es que llevé a un equipo de cuatro autónomos durante ocho meses, que tenía casi todos los mismos problemas y ninguna de las atribuciones.* La etiqueta es lo que hace que esto funcione. Un ejemplo cercano ofrecido como si fuera lo auténtico se pilla; el mismo ejemplo ofrecido con sus límites enunciados se recibe a menudo mejor que uno de verdad, porque demuestra que sabes la diferencia.

**El no honesto, más la forma de cómo lo abordarías.** *No, nunca he llevado una migración de ese tamaño. Si lo hiciera, lo primero que querría saber es si se puede hacer por trozos.* Un no limpio seguido de una respuesta de verdad a la pregunta de fondo. Lo que están midiendo suele ser el razonamiento, no el título.

**Lo transferible, de fuera del trabajo.** Voluntariado, deporte, un proyecto personal, la familia. Más flojo para afirmaciones técnicas, a menudo fuerte para preguntas sobre conflictos, organización o persuasión.

**La jugada:** di qué no has hecho, y luego responde a la pregunta que hay debajo.

Lo que hunde a los candidatos aquí no es la carencia. Es la paja: la respuesta que no es ni sí ni no, que da vueltas noventa segundos esperando que la confundan con un sí. Quien entrevista está extremadamente bien calibrado para esto. Se lee como evasiva, y convierte una carencia pequeña en una pregunta sobre tu honestidad, que es un problema mucho mayor.

Una frase que merece la pena tener a mano: *Todavía no.* Es una respuesta completa, es segura, e invita a la repregunta que quieres.$md$,
  $j$[
    {
      "situation": "Te preguntan por la experiencia con una herramienta que no has usado nunca.",
      "line": "No la he usado nunca. He hecho el mismo trabajo con otras dos, así que esperaría que los conceptos me sirvan y que las dos primeras semanas sean molestas.",
      "why": "Dos frases, sin ponerse a la defensiva, y una estimación realista de la rampa. «Las dos primeras semanas serán molestas» es creíble de una manera en que «aprendo rápido» no lo es."
    },
    {
      "situation": "Te piden un ejemplo de gestionar a alguien que rinde mal, sin haber dirigido nunca a nadie.",
      "line": "No he tenido que hacerlo como jefe. Sí he tenido que hacerlo como la persona de la que dependía un proyecto: el año pasado hubo un autónomo que no entregaba, y me tocó a mí sacarlo. Lo que no podía hacer era arreglarlo, y eso fue frustrante de una forma que sospecho que gestionándolo no lo sería.",
      "why": "Etiqueta la carencia, ofrece lo más parecido que es verdad, y luego nombra la diferencia con precisión. Esa observación final demuestra que ha pensado en qué implicaría el trabajo real en vez de fingir haberlo hecho."
    },
    {
      "situation": "Te preguntan por una escala de trabajo muy por encima de nada que hayas hecho.",
      "line": "No, lo más grande que he llevado es como la décima parte de eso. Lo que más me preocuparía es la coordinación más que el trabajo en sí: a ese tamaño supondría que lo difícil es que nadie puede tenerlo todo en la cabeza.",
      "why": "El no honesto seguido de una respuesta genuinamente pensada a la pregunta real. Nombrar qué te preocuparía convence más que afirmar que no te preocuparía nada."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "No has hecho nunca aquello por lo que preguntan. ¿Qué respuesta es la más peligrosa?",
      "options": [
        { "text": "Describir una experiencia parecida y dejar que asuman que cuenta.", "correct": true, "note": "Esto es la paja. Es la respuesta más común y la que mejor detecta quien entrevista, y que te pillen convierte una carencia en una duda sobre tu honestidad." },
        { "text": "Decir que no y luego explicar cómo lo abordarías.", "correct": false, "note": "Normalmente la respuesta más fuerte disponible. La pregunta casi siempre mide el razonamiento y no el título." },
        { "text": "Ofrecer un ejemplo de fuera del trabajo.", "correct": false, "note": "A veces más flojo, a veces lo mejor de la entrevista. En cualquier caso es honesto, lo que mantiene el riesgo pequeño." },
        { "text": "Describir una experiencia parecida y nombrar explícitamente lo que le falta.", "correct": false, "note": "Fuerte. Etiquetar los límites de tus propias pruebas es en sí mismo una prueba de criterio." }
      ],
      "explain": "A la carencia se sobrevive. Lo que hace el daño es fingir que la carencia no está."
    },
    {
      "prompt": "¿Qué se suele medir con una pregunta sobre algo fuera de tu experiencia?",
      "options": [
        { "text": "Si cumples el requisito, que para eso está en la descripción del puesto.", "correct": false, "note": "Si fuera un requisito duro rara vez estarías en la sala. La pregunta normalmente está explorando los bordes de lo que puedes hacer." },
        { "text": "Cómo piensas el problema, y si eres claro sobre lo que sabes.", "correct": true, "note": "Las dos cosas a la vez. Un no claro con buen razonamiento puntúa mejor que un sí acolchado, porque responde a la pregunta y pasa la prueba de honestidad en el mismo aliento." },
        { "text": "Si vas a admitir una debilidad bajo presión.", "correct": false, "note": "Más cerca, pero plantea una carencia de experiencia como una debilidad. Normalmente es solo un dato sobre lo que te han dado que hacer hasta ahora." }
      ],
      "explain": "Responde a la pregunta que hay debajo. Casi siempre va del razonamiento, y casi nunca de la credencial."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named_the_gap", "label": "Dijo qué no había hecho", "description": "Enunció la carencia con claridad en vez de dar vueltas alrededor." },
      { "key": "answered_underneath", "label": "Respondió a la pregunta real", "description": "Siguió el no con cómo lo abordaría, o con la prueba honesta más cercana." },
      { "key": "labelled_adjacency", "label": "Etiquetó el ejemplo cercano", "description": "Cuando ofreció una experiencia parecida, enunció sus límites en vez de dejarlos por supuestos." },
      { "key": "no_flannel", "label": "Sin relleno", "description": "No usó la longitud ni la vaguedad para tapar la respuesta." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Greg Mulvaney",
      "role": "un responsable de contratación que ha entrevistado a mucha gente",
      "mood": "Ecuánime. Contrata encantado a alguien que no lo haya hecho todo, y de mala gana a alguien que dice que sí lo ha hecho.",
      "openness": 3,
      "personality": "Seco y con oficio. Se queda en silencio cuando una respuesta empieza a rellenar, y simplemente vuelve a hacer la misma pregunta. Se relaja visiblemente cuando alguien dice un «no» limpio."
    },
    "setting": "Una entrevista para un puesto que es un salto de verdad, donde al menos un requisito está por encima de lo que ha hecho el candidato.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Haz al menos dos preguntas que vayan más allá de la experiencia que ha declarado la persona.",
      "Si una respuesta rellena o insinúa experiencia sin afirmarla, vuelve a hacer la pregunta con más precisión. No expliques por qué.",
      "Reacciona con neutralidad y calidez ante un honesto «eso no lo he hecho». Sigue con «¿y cómo lo abordarías?».",
      "Nunca tranquilices a la persona diciéndole que una carencia no pasa nada."
    ],
    "opening_beat": "«El puesto lleva un equipo de unas quince personas en dos sedes. Háblame de lo más grande de lo que has sido responsable.»",
    "success_looks_like": "La persona nombra con claridad la distancia entre su experiencia y el puesto, y luego da una respuesta de verdad sobre cómo abordaría esa diferencia."
  }$j$::jsonb,
  'Busca en una oferta de empleo real el requisito que no puedes reclamar honestamente. Dile a alguien en voz alta qué no has hecho y cómo lo abordarías. Apunta si conseguiste llegar al final sin rellenar.',
  $j${
    "turns": [
      { "instruction": "Di con claridad qué no has hecho. Una frase, sin cubrirte las espaldas y sin ningún «casi»." },
      { "instruction": "Ahora responde a la pregunta que hay debajo: lo más parecido que sí has hecho, y qué se transfiere." }
    ]
  }$j$::jsonb
);
