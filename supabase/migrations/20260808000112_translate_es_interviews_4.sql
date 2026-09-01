-- Spanish: Interviews, track 4 — Fracasos, defectos y huecos.
--
-- Conventions as migration 109. Notes specific to this track:
--
-- **"Perfeccionista" is the whole ban.** The English forbids eight varieties
-- of fake weakness; in Spanish almost all of them arrive as "perfeccionista"
-- or as "demasiado" plus a virtue, so the list bans the noun, the -ismo, and
-- the four "demasiado" constructions people actually say. Longer would be
-- theatre.
--
-- **Redundancy is un despido colectivo.** Not "un ERE" — the acronym is
-- Spanish law rather than the situation, and half the readers of this lesson
-- were let go somewhere that never filed one.
--
-- **"Managed out" becomes "me sacaron de la empresa".** Spanish has no polite
-- euphemism here that is not also a lie, and the lesson is specifically about
-- saying the hard fact plainly, so it says it plainly.

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

select pg_temp.es_lesson('interview-failure', 1,
  'Nómbralo, ponle precio, cámbialo, para',
  $md$*Cuéntame alguna vez que fracasaras* no pregunta si has fracasado. Todo el mundo lo ha hecho. Pregunta si puedes mirarlo sin encogerte y sin actuar.

Hay una forma que funciona, y tiene cuatro movimientos.

**Nómbralo.** Una frase, con claridad, en voz activa, y contigo dentro. *Saqué un cambio de precios que cobró de menos a unos seiscientos clientes durante un mes.*

**Ponle precio.** Lo que costó de verdad: dinero, tiempo, la confianza de alguien, tu propia credibilidad. Este es el movimiento que la gente se salta, y saltárselo es lo que hace que una respuesta sobre un fracaso suene a presumir con disimulo. Un fracaso sin consecuencia no fue un fracaso.

**Cámbialo.** Qué hiciste distinto después, lo bastante concreto como para comprobarlo. No *aprendí a ser más cuidadoso*. *Ahora escribo la vuelta atrás antes de la entrega, no después.*

**Para.** El más difícil. El silencio después de una historia de fracaso parece enorme desde dentro y normal desde fuera, y el instinto de rellenarlo es lo que produce la segunda confesión, la que no hacía falta.

**La jugada:** nómbralo, di qué costó, di qué cambió, y luego deja de hablar.

Dos formas de fallar que hay que evitar. El éxito disfrazado — *fui demasiado ambicioso con los plazos* — que todo el mundo reconoce y nadie premia. Y la catástrofe: la historia tan mala que quien entrevista empieza a pensar en responsabilidades legales. El punto dulce es un fracaso real con un coste acotado, contado sin drama.

Elige algo sobre lo que de verdad hayas terminado de pensar. Un fracaso sobre el que sigas a la defensiva se va a notar, y lo que se puntúa es lo defensivo, no el fracaso.$md$,
  $j$[
    {
      "situation": "Una respuesta de fracaso con los cuatro movimientos, contada de frente.",
      "line": "Di el visto bueno a un proveedor sin comprobar su seguro, y cuando se perdió una entrega no teníamos cobertura. Costó unos cuatro mil euros y me costó la confianza de la compradora durante seis buenos meses, que fue lo peor. Monté la lista de comprobación que seguíamos usando cuando me fui, y desde entonces no he firmado nada de palabra.",
      "why": "Los cuatro movimientos en tres frases. Que la confianza costara más que el dinero es la línea que lo hace aterrizar: demuestra que quien responde entiende cuál era la moneda real del error."
    },
    {
      "situation": "Alguien parando limpio después del cuarto movimiento.",
      "line": "…así que ese es el cambio que hice. [silencio]",
      "why": "La respuesta está terminada. Casi todos los candidatos siguen aquí y añaden un segundo ejemplo, una disculpa o una observación filosófica sobre aprender, y las tres cosas debilitan lo anterior. Parar es una técnica."
    },
    {
      "situation": "Rechazar la versión del éxito disfrazado.",
      "line": "Podría contarte una vez que asumí demasiado, pero con sinceridad eso no es un fracaso, es una fanfarronada con cojera. El de verdad es que ignoré a dos personas que me decían que el diseño estaba mal, porque ya le había dicho al cliente que funcionaría.",
      "why": "Nombrar el escaqueo y rechazarlo compra una credibilidad enorme, y hace que la respuesta real pegue más fuerte. Hazlo solo si la respuesta real está de verdad preparada."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál de estas no es una respuesta de fracaso?",
      "options": [
        { "text": "Me importa demasiado que las cosas salgan bien, y eso a veces me ralentiza.", "correct": true, "note": "Una virtud disfrazada. Todo el mundo que entrevista la ha oído, y lo que se puntúa es el intento de escaquearse, no el contenido." },
        { "text": "Subestimé un proyecto en unas seis semanas y por eso incumplimos un compromiso con un cliente.", "correct": false, "note": "Un fracaso real con una consecuencia real, dicho con claridad. Esta es la forma." },
        { "text": "Mantuve a una persona de mi equipo en un proyecto tres meses después de saber que no era el sitio para ella.", "correct": false, "note": "Incómodo, honesto, y sobre el coste para otra persona. Material muy fuerte." }
      ],
      "explain": "Si el fracaso quedaría bien en una evaluación de desempeño, no es un fracaso, y en la sala lo sabe todo el mundo."
    },
    {
      "prompt": "Ya has nombrado el fracaso y lo que cambió. Quien te entrevista no dice nada durante cuatro segundos. ¿Y ahora?",
      "options": [
        { "text": "Añadir un segundo ejemplo, más pequeño, para enseñar que el patrón no se repite.", "correct": false, "note": "Dos fracasos donde se pedía uno. El silencio no era una petición de más pruebas." },
        { "text": "Nada. Esperar.", "correct": true, "note": "La pausa es que están escribiendo, o pensando, o comprobando si vas a seguir hablando. Cada palabra que añadas aquí se resta de la fuerza de la respuesta." },
        { "text": "Resumir lo que aprendiste, para terminar con una nota positiva.", "correct": false, "note": "El cambio que nombraste ya era la nota positiva. Repetirlo como lección convierte una respuesta concreta en un lugar común." },
        { "text": "Preguntar si eso respondía a la pregunta.", "correct": false, "note": "Les invita a decir que no. Si no respondía, volverán a preguntar, y ese es su trabajo y no el tuyo." }
      ],
      "explain": "Parar es parte de la respuesta. La incomodidad del silencio es solo tuya: desde el otro lado de la mesa son dos segundos de tomar notas."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "real_failure", "label": "Eligió uno real", "description": "La historia era un fracaso de verdad y no un éxito disfrazado." },
      { "key": "named_the_cost", "label": "Dijo qué costó", "description": "Nombró una consecuencia real: dinero, tiempo, confianza o credibilidad." },
      { "key": "specific_change", "label": "El cambio era concreto", "description": "Lo que hace distinto ahora era lo bastante concreto como para comprobarlo, y no una lección general." },
      { "key": "stopped", "label": "Dejó de hablar", "description": "Terminó la respuesta limpia en vez de rellenar el silencio de después." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Nadia Farouk",
      "role": "una entrevistadora que evalúa autoconocimiento y honestidad",
      "mood": "Cálida de verdad. No está intentando pillar a nadie y no le hace falta.",
      "openness": 4,
      "personality": "Amable, tranquila, y completamente cómoda con el silencio. Deja cuatro o cinco segundos después de cada respuesta antes de contestar, que es donde casi todos los candidatos se deshacen solos."
    },
    "setting": "Una ronda de entrevista sobre valores. Quien entrevista es cálida; las preguntas no.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Cuando la persona termine una respuesta, haz una pausa visible: contesta con un compás corto como «…» o un reconocimiento breve antes de la siguiente pregunta.",
      "Si te ofrecen un éxito disfrazado, pregunta «¿y qué costó eso?» sin comentar el escaqueo.",
      "Si la persona sigue hablando para rellenar el silencio, no la pares y no la animes.",
      "Nunca la tranquilices diciéndole que el fracaso no fue culpa suya."
    ],
    "opening_beat": "«Me gustaría hablar de algo que salió mal. No de una situación difícil que gestionaras bien: de algo en lo que te equivocaste.»",
    "success_looks_like": "La persona nombra un fracaso real, dice qué costó, dice qué cambió, y luego para y deja que el silencio se quede."
  }$j$::jsonb,
  'Cuéntale hoy a alguien un fracaso real usando los cuatro movimientos, y para cuando llegues al final. Cuenta el silencio antes de que hable. Apunta cuánto conseguiste aguantar callado.',
  $j${
    "says": "Me gustaría hablar de algo que salió mal. No de una situación difícil que gestionaras bien: de algo en lo que te equivocaste.",
    "model": {
      "line": "Mantuve un proyecto en marcha cuatro meses después de que estuviera claro que no iba a funcionar, porque yo lo había defendido y no quería ser quien lo dijera. Les costó a las dos personas que estaban en él medio año que podrían haber dedicado a algo real. Ahora escribo al principio qué me haría pararlo, y se lo enseño a otra persona.",
      "why": "Nombrado, con precio, cambiado, y parado. El último compás es un mecanismo y no una lección aprendida, que es la diferencia entre algo que hiciste y algo que dices."
    },
    "checks": [
      { "kind": "min_words", "n": 30, "requirement": "Uno de verdad, con lo suficiente dentro como para creerlo" },
      { "kind": "max_words", "n": 90, "requirement": "Menos de noventa palabras. Parar es la lección." },
      { "kind": "contains_any", "words": ["costó", "costaron", "supuso", "perdí", "perdimos", "tarde", "tuve que", "tuvimos que", "acabó", "acabaron"], "requirement": "Di qué costó" }
    ],
    "maxChars": 800
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-failure', 2,
  'Un defecto que te cuesta algo',
  $md$La pregunta del defecto sobrevive, aunque todo el mundo esté de acuerdo en que es una mala pregunta, porque las respuestas revelan muchísimo. No sobre el defecto: sobre si el candidato está dispuesto a ser una persona real durante treinta segundos.

Una respuesta utilizable necesita tres propiedades.

**Es verdad.** Te van a repreguntar. Los defectos inventados no tienen segunda capa.

**Cuesta algo visible.** *Soy impaciente* es un comienzo; *soy impaciente, y eso ha hecho que dos veces sacara adelante una decisión antes de que un compañero más callado hubiera dicho lo suyo* es una respuesta. El coste es lo que demuestra que lo has mirado.

**No es el puesto.** No ofrezcas un defecto que sea el requisito central del trabajo. Decir que te cuesta priorizar, en una entrevista para un puesto que es entero priorizar, es honestidad apuntada a tu propio pie.

**La jugada:** nombra un defecto verdadero, nombra lo que le ha costado a otra persona, y luego nombra la barrera concreta que usas contra él.

Esa última parte importa y no es lo mismo que arreglarlo. Casi ningún defecto real se arregla: se gestiona, y decirlo es más creíble que reclamar una cura. *No he dejado de ser impaciente. He empezado a preguntarle a la persona más callada de la reunión qué opina, antes de decir yo lo que opino.*

Una nota sobre el extremo demasiado honesto. Quien entrevista tiene un umbral aproximado: un defecto que te hace más difícil de tratar está bien, y uno que te hace peligroso de contratar no. *Me cuesta pedir ayuda* está dentro de la raya. *Pierdo los nervios con la gente* no lo está, por bien que lo gestiones.

Y que sea uno. Un candidato que ofrece tres defectos ha dejado de responder a una pregunta y ha empezado a desahogarse.$md$,
  $j$[
    {
      "situation": "Un defecto con su coste dicho y con una barrera.",
      "line": "Tardo en escalar las cosas. Prefiero resolverlo yo, y eso ya ha hecho dos veces que un problema llegara a mi jefa más tarde de lo debido, una de ellas unas dos semanas tarde. Lo que hago ahora es un punto fijo en mi reunión individual que se llama «cosas que todavía no te he contado», que es un nombre estúpido y funciona.",
      "why": "Verdad, con coste, y gestionado en vez de curado. El detalle autoirónico sobre el nombre lo hace evidentemente real: eso no lo inventa nadie."
    },
    {
      "situation": "Responder a una repregunta sobre el defecto sin deshilacharse.",
      "line": "La última vez fue en marzo. Pasé tres días intentando arreglar un problema de datos yo solo y el cliente se enteró antes que mi director. Le molestó más el orden que el problema, y me pareció justo.",
      "why": "La repregunta es la prueba de verdad, y esta respuesta tiene una fecha, una consecuencia concreta y ninguna actitud defensiva. Quien se inventa un defecto no puede producir esta segunda capa."
    },
    {
      "situation": "Negarse a dar un defecto que es el núcleo del puesto.",
      "line": "El que normalmente te daría es que no soy organizado por naturaleza, pero eso es casi todo este puesto, así que déjame darte el que hay debajo: asumo demasiado antes de comprobar qué desplaza.",
      "why": "Demuestra criterio sobre la relevancia sin parecer un escaqueo, y la segunda respuesta es más interesante de lo que habría sido la primera. Decir el razonamiento en voz alta es lo que impide que parezca evasivo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué respuesta sobre un defecto tiene más probabilidades de que se la crean?",
      "options": [
        { "text": "Soy perfeccionista y a veces dedico a las cosas más tiempo del que debería.", "correct": false, "note": "La respuesta más dada que existe. Se escucha como una falta de ganas de entrar en la pregunta y no como información." },
        { "text": "Diría que hablar en público, aunque lo he estado trabajando.", "correct": false, "note": "Cierto para mucha gente y seguro, pero el coste no se enuncia y suele elegirse por inofensivo. Rara vez hace daño y no ayuda nunca." },
        { "text": "Puedo ser demasiado directo, y a alguna gente eso le cuesta.", "correct": false, "note": "Una fanfarronada con forma de confesión. Ese «a alguna gente le cuesta» pone el coste en ellos y no en ti." },
        { "text": "Me cuesta delegar, y el año pasado eso hizo que una persona júnior de mi equipo pasara seis meses haciendo trabajo demasiado fácil para ella.", "correct": true, "note": "Concreto, con fecha, y el coste cae sobre otra persona. Esa tercera propiedad es lo que hace que una respuesta suene examinada y no compuesta." }
      ],
      "explain": "El coste es toda la respuesta. Sin él, un defecto es solo una palabra."
    },
    {
      "prompt": "¿Cuál es la forma más segura de tratar un defecto que de verdad has mejorado?",
      "options": [
        { "text": "Decir que lo tenías y ya no.", "correct": false, "note": "Una cura invita a la incredulidad, y hace incómoda la repregunta: te van a preguntar cuándo fue la última vez." },
        { "text": "Elegir otro defecto que siga vivo, por si acaso.", "correct": false, "note": "Innecesario. Un defecto mejorado contado con honestidad es de las mejores respuestas disponibles; no te hace falta una herida fresca." },
        { "text": "Decir cuál es, y describir la barrera que sigues usando.", "correct": true, "note": "Gestionado gana a curado en credibilidad. Además le da a la repregunta un sitio útil al que ir, lo que te mantiene al mando de la respuesta." }
      ],
      "explain": "Quien entrevista se fía más de la gestión que de la cura, porque la gestión es lo que ve en sus compañeros reales."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "true_weakness", "label": "Dio uno de verdad", "description": "El defecto era genuino y no una virtud disfrazada." },
      { "key": "cost_to_others", "label": "Nombró el coste", "description": "Dijo qué ha costado de verdad, idealmente a alguien que no fuera él mismo." },
      { "key": "guard", "label": "Describió la barrera", "description": "Explicó cómo lo gestiona ahora, en concreto, en vez de afirmar haberlo arreglado." },
      { "key": "survived_follow_up", "label": "Aguantó la repregunta", "description": "Pudo dar un caso reciente y concreto cuando se lo pidieron." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Peter Lund",
      "role": "un responsable de contratación que siempre repregunta",
      "mood": "Agradable y sin prisa. Ha decidido contratar a alguien esta semana y está buscando un motivo para decir que sí.",
      "openness": 3,
      "personality": "De humor estable y ligeramente escéptico. Le den el defecto que le den, pide el ejemplo más reciente. Nada hostil en cómo lo dice; simplemente siempre lo pregunta."
    },
    "setting": "Una entrevista de primera ronda que está yendo bien. El tono cambia un poco cuando llega esta pregunta.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta siempre por la última vez que apareció el defecto. Pregúntalo con claridad, una vez.",
      "Si la respuesta es una virtud disfrazada, pregunta qué ha costado, y luego pide un ejemplo igualmente.",
      "Si la persona ofrece más de un defecto, engánchate solo al primero.",
      "No le digas si su respuesta ha sido buena ni la tranquilices sobre el defecto."
    ],
    "opening_beat": "«Vale, la aburrida, pero quiero una respuesta de verdad. ¿En qué dirían las personas que han trabajado contigo que eres peor?»",
    "success_looks_like": "La persona da un defecto genuino con un coste pegado, y puede producir un ejemplo reciente y concreto cuando Peter se lo pide."
  }$j$::jsonb,
  'Pregúntale a alguien que haya trabajado contigo en qué eres peor, y no te defiendas mientras responde. Apunta lo que te dijo, con sus palabras y no con las tuyas.',
  $j${
    "says": "Vale, la aburrida, pero quiero una respuesta de verdad. ¿En qué dirían las personas que han trabajado contigo que eres peor?",
    "model": {
      "line": "Tardo en dar malas noticias. Una vez me senté encima de una fecha que se iba dos semanas, y mi homóloga planificó contra una fecha que yo ya sabía que era falsa, lo que le costó quince días. Ahora digo la fecha en voz alta el día en que dejo de creérmela.",
      "why": "Un defecto con una víctima nombrada y una barrera concreta. Un defecto que no le costó nada a nadie es una fanfarronada con sombrero, y en la sala lo oye todo el mundo."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["perfeccionista", "perfeccionismo", "trabajo demasiado", "demasiado honesto", "me importa demasiado", "demasiado apasionado", "demasiado exigente conmigo"], "requirement": "Ninguno de los falsos" },
      { "kind": "contains_any", "words": ["costó", "supuso", "perdió", "perdí", "más lento", "más lenta", "tuvo que", "tuve que", "equivocada", "esperó", "esperé"], "requirement": "Nombra lo que le ha costado a otra persona" },
      { "kind": "max_words", "n": 70, "requirement": "Menos de setenta palabras" }
    ],
    "maxChars": 600
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-failure', 3,
  'Huecos, estancias cortas y que te echen',
  $md$Un hueco en un CV es un dato con fechas a los dos lados. Se convierte en un problema en exactamente una circunstancia: cuando el tono de la explicación dice que lo es.

Quien entrevista no está puntuando el suceso. Está puntuando tres cosas que hay debajo: si el relato es coherente, si hay rencor, y si esto pasaría aquí. Responde a esas y el dato en sí casi nunca importa.

**Coherente.** El motivo que des debería ser el mismo que le diste a quien te cribó y el mismo que pusiste en el formulario. La variación es lo que convierte una pregunta en un interrogatorio.

**Sin rencor.** Esta es la que hunde a la gente. Un despido colectivo o una salida forzada tienen un villano dentro, y el villano es real, y nombrarlo te cuesta el puesto. No porque quien entrevista se ponga del lado de la empresa anterior, sino porque un candidato que sigue enfadado es un candidato que algún día se enfadará con ellos.

**Improbable que se repita.** Di qué tenía de específico la situación. No una promesa, un dato: *Cerró la oficina.* *Era un contrato de nueve meses y terminó a los nueve meses.*

**La jugada:** enuncia el dato con sus fechas, da una frase de motivo sin rencor, y sigue al mismo ritmo que el resto de la conversación.

Que te echen por rendimiento es la versión más difícil, y tiene una sola estructura honesta: no estaba funcionando, esta es mi parte del porqué, esto es lo que haría distinto. Tu parte tiene que ser real. *No encajaba* sin nada tuyo dentro se escucha como una negativa a mirar.

La longitud es la señal. Dos frases se leen como un dato. Noventa segundos se leen como una herida, con las palabras que sean.$md$,
  $j$[
    {
      "situation": "Un despido colectivo, explicado sin villano.",
      "line": "La empresa perdió a su cliente más grande en marzo y recortó como un tercio de la plantilla, yo incluido. Fue un mal año para ellos y yo estaba en un equipo atado a esa cuenta.",
      "why": "Dos frases, sin culpar a nadie, y da el motivo estructural con tanta claridad que quien entrevista no tiene dónde escarbar. No hay ningún comentario sobre cómo se gestionó, que es la trampa."
    },
    {
      "situation": "Un puesto de nueve meses, explicado sin drama.",
      "line": "Ese fueron nueve meses y fue un error. Cogí un trabajo que resultó ser mucho más estrecho que la descripción, y en vez de quedarme dos años para que el CV quedara ordenado, me fui. La siguiente vez pregunté mucho mejor.",
      "why": "Asume el error de cálculo, da el motivo, y se adelanta a la pregunta real: si el candidato salta de trabajo en trabajo. La última frase responde a «¿pasaría esto aquí?»."
    },
    {
      "situation": "Que te echen por rendimiento.",
      "line": "Me sacaron de la empresa, y fue justo. Me contrataron para hacer algo más comercial de lo que había hecho antes, y no llegué a ser lo bastante bueno lo bastante rápido. Lo que debería haber hecho es decirlo a los tres meses en vez de seguir esperando a los nueve.",
      "why": "El dato más difícil posible, tratado en tres frases sin rencor y con una parte de responsabilidad real. La última línea lo convierte en prueba de autoconocimiento, que vale más de lo que cuesta el suceso."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué escucha sobre todo quien entrevista cuando explicas un despido colectivo?",
      "options": [
        { "text": "Si fue culpa tuya.", "correct": false, "note": "Un despido colectivo suele ser estructural y quien entrevista lo sabe. Rara vez es esa la preocupación." },
        { "text": "Si has estado mucho tiempo sin trabajo.", "correct": false, "note": "Está en el CV y lo ven. La duración importa muchísimo menos que cómo hablas de ello." },
        { "text": "Si sigues enfadado por ello.", "correct": true, "note": "El rencor es lo que se contagia. A un candidato que carga un agravio con una empresa anterior se le oye como un futuro agravio con esta." },
        { "text": "Si vas a aceptar un sueldo más bajo por ello.", "correct": false, "note": "Alguno lo pensará. Casi nadie lo está escuchando en esta respuesta, y dar por hecho que sí pone a la gente a la defensiva de una forma que cuesta más." }
      ],
      "explain": "El dato es neutro. El tono es el mensaje, y el tono es lo que seguirán recordando mañana."
    },
    {
      "prompt": "¿Cuánto debería durar la explicación de un hueco de dos años?",
      "options": [
        { "text": "Lo bastante como para ser completa: si no, se lo preguntarán.", "correct": false, "note": "Ser completo no es el objetivo. Una explicación exhaustiva de un suceso vital normal es justo lo que hace que suene a que necesita explicación." },
        { "text": "Lo más corta posible: una oración y de largo.", "correct": false, "note": "Ir demasiado rápido es su propia señal. Pasar de puntillas se lee como querer que no se examine, lo que invita justo al examen que estabas evitando." },
        { "text": "Más o menos lo que cualquier otro dato de tu recorrido.", "correct": true, "note": "Dos o tres frases al mismo ritmo que todo lo demás. La señal es la proporción, y un hueco al que se le da el mismo peso que a un cambio de trabajo se lee como un cambio de trabajo." }
      ],
      "explain": "Ponte al ritmo del resto de la conversación. Detenerse y correr dicen lo mismo: esta es distinta."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "plain_fact", "label": "Lo enunció como un dato", "description": "Dio las fechas y el motivo sin disculpas y sin adornos." },
      { "key": "no_bitterness", "label": "Sin villano", "description": "Lo explicó sin culpar a una persona, incluso donde la culpa sería justa." },
      { "key": "ownership", "label": "Asumió una parte real", "description": "Cuando venía a cuento, nombró su propia parte sin confesar de más." },
      { "key": "proportion", "label": "Lo mantuvo en proporción", "description": "Le dedicó más o menos lo mismo que a cualquier otra parte de la historia." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Claire Doherty",
      "role": "una responsable de contratación que hace la pregunta incómoda de frente y luego la suelta",
      "mood": "Neutral y práctica. Todavía no tiene ninguna opinión sobre el hueco.",
      "openness": 3,
      "personality": "Directa y no antipática. Pregunta por el hueco con claridad, escucha la respuesta entera, y sigue adelante sin quedarse ahí, a no ser que la respuesta invite a quedarse."
    },
    "setting": "Una primera entrevista después de un periodo sin trabajar. Quien entrevista tiene el CV y se ha fijado en las fechas.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta por el hueco una vez, con claridad, y luego suéltalo salvo que la propia respuesta abra un hilo.",
      "Si la persona culpa a alguien o a una empresa, haz una repregunta neutra sobre eso y anota la respuesta sin comentarla.",
      "Si la persona explica de más, espera a que termine y luego cambia de tema por completo.",
      "Nunca la tranquilices diciéndole que el hueco no importa."
    ],
    "opening_beat": "Claire pasa la página. «Antes de seguir: aquí hay un tramo sin nada. Cuéntamelo.»",
    "success_looks_like": "La persona enuncia el dato y el motivo en un par de frases, sin rencor y sin explicar de más, y la conversación sigue con naturalidad."
  }$j$::jsonb,
  'Di en voz alta el dato más difícil de tu CV, en dos frases, a alguien de confianza. Pregúntale si sonaste molesto. Apunta la respuesta.',
  $j${
    "says": "Antes de seguir: aquí hay un tramo sin nada. Cuéntamelo.",
    "model": {
      "line": "Son catorce meses desde marzo de 2023. Mi padre estaba enfermo y yo era quien podía ir. Volví a mirar en mayo, y este es el primer puesto que he querido lo bastante como para presentarme.",
      "why": "Las fechas, una frase de motivo sin rencor, y luego sigue a la misma velocidad que todo lo demás. Disculparse es lo que hace que suene a algo por lo que disculparse."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["lo siento", "perdona", "por desgracia", "avergonzado", "avergonzada", "me da vergüenza", "me temo", "me arrepiento", "sé que queda mal", "disculpa"], "requirement": "Nada de disculparse. Es un dato, no un cargo." },
      { "kind": "max_sentences", "n": 3, "requirement": "Enúncialo, una frase de motivo, y sigue" },
      { "kind": "max_words", "n": 60, "requirement": "Menos de sesenta palabras" }
    ],
    "maxChars": 500
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-failure', 4,
  'Que te digan que te equivocaste',
  $md$*Cuéntame alguna vez que recibieras una crítica difícil* es una pregunta sobre qué te pasa cuando alguien te cuestiona, y no hay forma de responderla en abstracto. La historia tiene que tener dentro un momento en el que te equivocaste y alguien lo dijo.

La forma en tres partes.

**Qué te dijeron, con sus palabras.** Citar la crítica es lo que hace esto real. *Mi jefa me dijo que yo era la razón de que dos personas hubieran dejado de sacar problemas en la reunión diaria.* Parafrasearlo hacia arriba — *recibí una crítica sobre mi estilo de comunicación* — es el sonido de una respuesta que ha pasado por la lija.

**Qué hiciste con ella al principio.** Incluida la parte en la que no te gustó. Nadie recibe una crítica dura con elegancia en la primera hora, y afirmar que sí lo hiciste es la parte que no se cree nadie. *Me pareció injusta durante un día* es una frase que hace creíble todo lo demás.

**Qué cambió de verdad.** Conducta, no actitud. Algo que un observador habría podido notar.

**La jugada:** cita la crítica con sus palabras, admite la primera reacción, y luego di qué habría visto cambiar un observador.

La versión de esta pregunta que pilla a la gente es cuando la crítica era errónea. Pasa. La respuesta no es fingir que la aceptaste: es demostrar que te la tomaste lo bastante en serio como para comprobarla. *Pregunté a otras dos personas si veían lo mismo. Una sí y otra no, y la que sí fue más concreta, así que me quedé con eso.*

Evita la historia en la que la crítica era trivialmente fácil de aceptar. Si la crítica no escoció, no es una respuesta a esta pregunta, y elegir una indolora es en sí mismo una señal.$md$,
  $j$[
    {
      "situation": "Citar la crítica en vez de resumirla.",
      "line": "Me dijo, y lo recuerdo exacto: «Respondes a preguntas que iban dirigidas a otras personas». Que yo no creía que fuera verdad hasta que lo conté, en las dos reuniones siguientes.",
      "why": "La cita es lo bastante concreta como para resultar incómoda, y eso es lo que la hace creíble. «Hasta que lo conté» es el detalle que demuestra que la crítica se puso a prueba de verdad y no solo se absorbió."
    },
    {
      "situation": "Admitir la primera reacción con honestidad.",
      "line": "Mi primera reacción fue que solo había visto una mala semana. Lo dejé reposar el fin de semana y para el lunes había pasado de eso a darme cuenta de que llevaba unos cuatro meses.",
      "why": "Un día a la defensiva seguido de un cambio de opinión es lo que de verdad le pasa a la gente. Quien afirma haberla aceptado de inmediato y con gratitud o es raro o está editando."
    },
    {
      "situation": "Gestionar una crítica que era en parte errónea.",
      "line": "Como la mitad me pareció justa y la otra mitad no. Cogí la mitad con la que estaba de acuerdo, y tres semanas después volví a él con el resto y dos ejemplos. Él se movió un poco, yo me moví un poco, y la relación de trabajo quedó mejor que antes.",
      "why": "Enseña a alguien que ni se traga la crítica entera ni la rechaza, y que está dispuesto a reabrir una conversación difícil. Esa última parte es una señal fuerte de cómo se comportará como compañero."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué detalle hace más creíble una historia sobre una crítica?",
      "options": [
        { "text": "Citar lo que te dijeron de verdad.", "correct": true, "note": "Las palabras exactas llevan el escozor, y el escozor es lo que demuestra que la historia es real y no reconstruida para la ocasión." },
        { "text": "Explicar cómo le diste las gracias a la persona por la crítica.", "correct": false, "note": "Esto lo dice todo el mundo y es la parte menos informativa. La gratitud es fácil de contar e imposible de verificar." },
        { "text": "Describir la mejora en tu siguiente evaluación de desempeño.", "correct": false, "note": "Útil como final, pero es el resultado y no la prueba. Quien entrevista está escuchando qué pasó dentro de ti." },
        { "text": "Decir que siempre has valorado las críticas honestas.", "correct": false, "note": "Una afirmación sobre ti mismo en una pregunta que pedía pruebas. Suele preceder a una historia sin nada difícil dentro." }
      ],
      "explain": "Cítala. Lo concreto de las palabras es lo que separa una historia real de una pulida."
    },
    {
      "prompt": "La crítica más dura que has recibido era, mirándola bien, bastante injusta. ¿La usas?",
      "options": [
        { "text": "No: una respuesta donde no estabas de acuerdo se lee como estar a la defensiva.", "correct": false, "note": "Solo si la cuentas a la defensiva. Un desacuerdo bien llevado es más interesante que un acuerdo, porque enseña criterio además de apertura." },
        { "text": "Sí, si puedes demostrar que la comprobaste antes de decidir que era injusta.", "correct": true, "note": "La comprobación es toda la respuesta. Buscar una segunda opinión, contar, pedir ejemplos: eso es lo que quien entrevista quiere saber que haces." },
        { "text": "Sí, y empieza por por qué era injusta, para que el contexto quede claro.", "correct": false, "note": "Empezar por la defensa pone a quien entrevista en la posición de juzgar la vieja disputa. El orden importa: qué se dijo, qué hiciste, qué concluiste." }
      ],
      "explain": "La pregunta va sobre tu proceso, no sobre quién tenía razón. Una historia donde pusiste la crítica a prueba responde mejor que una donde simplemente la aceptaste."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "quoted_it", "label": "Citó la crítica", "description": "Dio las palabras que se usaron de verdad y no un resumen pasado por la lija." },
      { "key": "honest_reaction", "label": "Admitió la primera reacción", "description": "No afirmó haber aceptado al instante y con elegancia una crítica dura." },
      { "key": "observable_change", "label": "Nombró un cambio visible", "description": "Describió algo que un observador habría podido notar, no un cambio de actitud." },
      { "key": "chose_something_real", "label": "Eligió algo que escoció", "description": "La crítica era genuinamente difícil y no cómoda de contar." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Owen Ferris",
      "role": "un compañero que entrevista para evaluar cómo trabaja la gente en equipo",
      "mood": "Enganchado. Hoy ya le han dado dos respuestas vagas a esta pregunta.",
      "openness": 3,
      "personality": "Directo y curioso. Pide las palabras exactas cada vez que un candidato parafrasea. Le interesa qué pasó en las primeras veinticuatro horas, y lo dice."
    },
    "setting": "Una ronda centrada en cómo trabaja el candidato con otras personas. Dos entrevistadores: uno pregunta y el otro toma notas.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si la persona parafrasea la crítica, pregunta qué se dijo exactamente, palabra por palabra.",
      "Pregunta cuál fue su primera reacción, si no la ha ofrecido.",
      "Si la historia no tiene escozor dentro, pide otra, una vez, sin explicar por qué.",
      "No elogies la honestidad ni tranquilices a la persona en ningún momento."
    ],
    "opening_beat": "«Cuéntame la crítica más dura que te hayan hecho. Y digo la más dura, no la más útil.»",
    "success_looks_like": "La persona cuenta una historia con escozor de verdad, cita la crítica, admite su primera reacción con honestidad, y nombra un cambio que un observador habría visto."
  }$j$::jsonb,
  'Pídele a un compañero o a un amigo una crítica que nunca te haya hecho, y no digas nada durante diez segundos después de que responda. Apunta lo que dijo y cuál fue tu primera reacción.',
  $j${
    "turns": [
      { "instruction": "Cita la crítica con sus palabras, no con tu versión suavizada." },
      { "instruction": "Admite tu primera reacción con honestidad. Nadie encaja bien una crítica dura en la primera hora." },
      { "instruction": "Ahora di qué habría visto cambiar un observador después. Conducta, no actitud." }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-failure', 5,
  'Qué harías distinto',
  $md$Esta pregunta suena a una versión suave de la del fracaso. No lo es: es la prueba de veteranía escondida en la formulación más amable posible.

El motivo es que hay dos niveles de respuesta, y la diferencia entre ellos es exactamente la diferencia entre hacer un trabajo y que te confíen dirigir uno.

**Primer orden:** qué habrías hecho distinto en la tarea. *Lo habría probado en más dispositivos.* Verdad, bien, olvidable. Dice que sabes detectar un error después de que te lo señalen.

**Segundo orden:** qué habrías hecho distinto con las condiciones que produjeron el error. *No habría aceptado una fecha antes de que hubiéramos visto los datos. El hueco de pruebas era un síntoma; el error de verdad fue aceptar un plazo en una reunión donde yo era el único que sabía que estaba apretado.*

La segunda respuesta no es más lista, está más atrás. Mira el proceso, la decisión, el momento del acuerdo, en vez de la ejecución.

**La jugada:** responde sobre las condiciones que hicieron probable el error, no sobre el error.

Dos cosas que la refuerzan todavía más. Nombrar el coste de la alternativa: el arreglo de segundo orden suele tener uno, y admitirlo (*habríamos lanzado tres semanas más tarde, y creo que era el cambio correcto*) demuestra que estás pesando en vez de deseando. Y decir qué has hecho desde entonces, porque una reflexión sin consecuencia es una opinión.

La forma de fallar aquí es la respuesta que lo haría todo distinto. Un candidato que reescribe el proyecto entero suena a alguien sin criterio sobre qué decisión importaba. Elige una.$md$,
  $j$[
    {
      "situation": "Pasar de una respuesta de primer orden a una de segundo orden.",
      "line": "La respuesta fácil es que habría hecho un piloto. La más verdadera es que no habría dejado que la fecha se fijara en una reunión en la que yo no estaba. El piloto era obvio a posteriori; que no tuviéramos tiempo para uno se decidió seis semanas antes.",
      "why": "Nombra la respuesta superficial y luego la deja atrás. La frase final es el sentido de toda la técnica: el error visible estaba aguas abajo del de verdad."
    },
    {
      "situation": "Admitir el coste de la mejor decisión.",
      "line": "Habría supuesto decirle al cliente que estábamos a cuatro semanas y no a dos, que habría sido una conversación genuinamente mala y podría habernos costado la prórroga. Sigo pensando que era lo correcto y que en aquel momento no tuve el valor.",
      "why": "Pesa la alternativa con honestidad en vez de presentarla como gratis, y admite una falta de valor y no una falta de conocimiento. Esa distinción convence muchísimo a quien entrevista."
    },
    {
      "situation": "Elegir exactamente una cosa.",
      "line": "Hay como seis cosas que cambiaría y cinco de ellas dan igual. La que no da igual es que debería haber preguntado la primera semana quién tomaba la decisión. Todo lo demás vino de pasar dos meses convenciendo a la persona equivocada.",
      "why": "Discriminar entre lo que importaba y lo que no es la señal real que se está midiendo. Un candidato que enumera las seis suena a alguien que no sabe distinguirlas."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué respuesta demuestra más veteranía?",
      "options": [
        { "text": "Habría comunicado con más claridad a las partes implicadas durante todo el proyecto.", "correct": false, "note": "Vago y universal: se podría decir de cualquier proyecto que se haya hecho jamás. No contiene ninguna prueba de haber examinado este." },
        { "text": "Habría escrito las pruebas primero, que lo habrían pillado.", "correct": false, "note": "De primer orden y verdad. Demuestra que sabes qué salió mal a nivel de la tarea, que es el mínimo." },
        { "text": "Me habría opuesto a coger el trabajo con la gente que teníamos, y habría dado esa discusión la primera semana y no la sexta.", "correct": true, "note": "Vuelve a la decisión que hizo probable el fracaso, y nombra cuándo debería haber ocurrido. Eso es criterio y no visión retrospectiva." }
      ],
      "explain": "La pregunta mide hasta qué punto sabes mirar hacia atrás. Las respuestas al nivel de la ejecución son correctas y baratas; la respuesta al nivel de la decisión es la que se recuerda."
    },
    {
      "prompt": "¿Qué hace que una respuesta de reflexión suene hueca?",
      "options": [
        { "text": "Nombrar demasiadas cosas que cambiarías.", "correct": false, "note": "Debilita la respuesta, sí, pero se lee como mala priorización y no como vacío." },
        { "text": "Admitir que todavía no has tenido ocasión de aplicar la lección.", "correct": false, "note": "Honesto, y está bien. No todas las lecciones tienen una segunda salida, y fingir lo contrario es peor." },
        { "text": "Elegir un proyecto antiguo.", "correct": false, "note": "El material antiguo es más flojo en general, pero un proyecto viejo bien examinado gana a uno reciente y superficial." },
        { "text": "Describir el camino mejor como si no costara nada.", "correct": true, "note": "Toda alternativa real cuesta algo. Un escenario alternativo sin fricción es el sonido de alguien que no lo ha pensado de verdad, solo lo ha lamentado." }
      ],
      "explain": "Si la alternativa era evidentemente mejor y gratis, la única pregunta que queda es por qué no la hiciste. Nombra el coste, y la reflexión se convierte en criterio."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "second_order", "label": "Volvió a la decisión", "description": "Respondió sobre las condiciones que hicieron probable el error, no solo sobre el error." },
      { "key": "one_thing", "label": "Eligió una", "description": "Eligió el cambio que importaba en vez de enumerarlo todo." },
      { "key": "named_the_cost", "label": "Le puso precio a la alternativa", "description": "Reconoció lo que habría costado el camino mejor." },
      { "key": "applied_since", "label": "Dijo qué ha cambiado desde entonces", "description": "Conectó la reflexión con algo que de verdad ha hecho distinto." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Miriam Balint",
      "role": "una directora que evalúa criterio y no habilidad",
      "mood": "Tranquila y atenta. Para esta tiene todo el tiempo del mundo.",
      "openness": 4,
      "personality": "Callada, sin prisa, e interesada en decisiones y no en tareas. Cuando le dan una respuesta al nivel de la ejecución pregunta «¿y por qué eso fue posible?», una y otra vez, con suavidad, hasta que la conversación llega a una decisión."
    },
    "setting": "Una conversación de ronda final con alguien sénior, a los veinte minutos, después de que el candidato haya descrito un proyecto en detalle.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Cuando te den una respuesta al nivel de la ejecución, pregunta por qué eso fue posible, o qué permitió que ocurriera. Repítelo hasta dos veces.",
      "Si la persona enumera varios cambios, pregunta cuál importó más y espera.",
      "Si la persona describe una alternativa sin coste, pregunta qué habría costado.",
      "Nunca le digas que está cerca, y nunca le resumas su respuesta de vuelta con aprobación."
    ],
    "opening_beat": "«Gracias, es una buena descripción de lo que pasó. Ahora, con todo lo que sabes hoy, ¿qué harías distinto?»",
    "success_looks_like": "La persona pasa del arreglo de primer orden a la decisión o la condición que había debajo, elige una sola cosa, y reconoce lo que habría costado esa alternativa."
  }$j$::jsonb,
  'Coge un proyecto que no fuera bien y cuéntale a alguien la versión de segundo orden: no qué habrías hecho distinto en el trabajo, sino qué decisión anterior hizo probable el problema. Apunta si conseguiste llegar hasta ahí sin que te lo preguntaran dos veces.',
  $j${
    "beats": [
      {
        "situation": "Has descrito un lanzamiento que falló porque nadie había comprobado si los datos estaban limpios. Quien entrevista pregunta qué harías distinto.",
        "prompt": "¿Qué respuesta demuestra criterio?",
        "options": [
          { "text": "Nombrar la condición: nadie era dueño de la calidad del dato, así que nadie lo comprobó.", "correct": true, "note": "Responder sobre las condiciones y no sobre el error. Dice que sabes ver el sistema que produjo el fallo, que es lo que están evaluando de verdad." },
          { "text": "Decir que habrías comprobado los datos.", "correct": false, "note": "Verdad y no vale nada. Es el error dicho del revés, e insinúa que lo único que hay entre tú y una repetición es acordarte más fuerte." },
          { "text": "Decir que te habrías opuesto al plazo.", "correct": false, "note": "Más cerca, y sigue siendo sobre una decisión en un día concreto en vez de sobre por qué era fácil equivocarse en esa decisión." },
          { "text": "Decir que el equipo debería haberlo avisado.", "correct": false, "note": "La respuesta que termina la entrevista. Incluso siendo verdad, responde a una pregunta sobre ti con una frase sobre ellos." }
        ]
      },
      {
        "situation": "La misma pregunta, y con sinceridad lo harías exactamente igual. Fue una decisión razonable que salió mal.",
        "prompt": "¿Qué dices?",
        "options": [
          { "text": "Decirlo, y nombrar qué vigilarías antes.", "correct": true, "note": "Sostener una decisión razonable es una señal de veteranía, siempre que puedas decir qué haría que ahora lo notaras antes." },
          { "text": "Inventarte algo que cambiarías, ya que quieren una.", "correct": false, "note": "Se les nota. Un arrepentimiento fabricado es peor que una decisión defendida, porque les dice qué haces bajo una presión suave." },
          { "text": "Decir que no había nada que pudieras haber hecho.", "correct": false, "note": "Sostener la decisión sin ofrecer la señal temprana se lee como no ser capaz de aprender de un resultado." },
          { "text": "Cambiar el ejemplo por uno en el que sí te equivocaste.", "correct": false, "note": "Esquivar la pregunta. Han preguntado por esta." }
        ]
      }
    ]
  }$j$::jsonb
);
