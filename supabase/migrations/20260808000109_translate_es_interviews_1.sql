-- Spanish: Interviews — the topic, its nine tracks, and the first track.
--
-- Conventions inherited from the Small talk migrations: tú for the reader,
-- **La jugada:** for the move marker, no gendered adjectives about the reader,
-- word lists rewritten rather than translated, names left alone.
--
-- Decisions this topic adds:
--
-- **El aterrizaje** for "the landing", keeping the English's own image rather
-- than swapping it for an unrelated Spanish one. "El cierre" is the obvious
-- choice and it is already taken by track 9, which is about closing the
-- interview — a second, distinct problem needed a second, distinct word.
-- "El remate" was tried first: correct dictionary Spanish for "the finishing
-- blow", but its everyday sense is football and auctions, and it reads as
-- borrowed sports jargon inside a room where nobody is playing a match.
-- "Aterrizar" carries the same image the English is making — an answer that
-- sticks the landing — and takes it naturally as a verb: "aterriza en X",
-- "una respuesta que nunca aterrizó".
--
-- **Tres tiempos** for "three beats". "En tres tiempos" already means in three
-- stages in everyday Spanish, so the structure arrives free.
--
-- **Peninsular Spanish for companies.** The reader is tú; a company is
-- vosotros. "Reconstruisteis el proceso" is what somebody in Madrid says to an
-- interviewer, and the alternative — ustedes — reintroduces the distance the
-- rest of the app spends its time removing.
--
-- **British institutions become Spanish ones.** A-levels are el bachillerato,
-- a dissertation is el trabajo de fin de grado, schemes of work are las
-- programaciones didácticas. These are real equivalents, not glosses: a reader
-- in Spain recognises their own school, which is the entire point of the
-- example.

-- ---------------------------------------------------------------------------
-- The topic
-- ---------------------------------------------------------------------------

insert into public.topic_translations (topic_id, locale, name, description, promise)
select id, 'es',
  'Entrevistas',
  $$Ya has hecho el trabajo. Ahora tienes cuarenta minutos para demostrárselo a un desconocido con un cuaderno, y casi todo se decide en seis preguntas.$$,
  $$Responder al puñado de preguntas que deciden la mayoría de las entrevistas sin bloquearte, sin irte por las ramas y sin vender por debajo de su precio un trabajo que sí hiciste — y saber qué decir en los últimos cinco minutos, cuando casi todo el mundo no dice nada.$$
from public.topics where slug = 'interviews'
on conflict (topic_id, locale) do update set
  name = excluded.name,
  description = excluded.description,
  promise = excluded.promise,
  updated_at = now();

-- ---------------------------------------------------------------------------
-- The nine tracks
-- ---------------------------------------------------------------------------

insert into public.skill_translations (skill_id, locale, name, description, core_idea)
select s.id, 'es', v.name, v.description, v.core_idea
from (values
  ('interview-your-story',
   'Tu historia',
   $$*Háblame de ti* — la pregunta que siempre te van a hacer, y la que casi todo el mundo improvisa.$$,
   $$El Arco: dónde empezaste, qué hiciste con ello, por qué estás en esta sala. Noventa segundos, y termina en el puesto al que te presentas.$$),

  ('interview-motivation',
   'Por qué tú, y por qué ahora',
   $$Por qué te vas, dónde te ves dentro de cinco años, por qué deberíamos contratarte: las preguntas que no van de si sabes hacer el trabajo.$$,
   $$Están comprobando dos cosas: que este puesto está en un camino que ya habías empezado, y que no te habrás ido dentro de ocho meses. Apunta todas las respuestas hacia delante.$$),

  ('interview-evidence',
   'Responder con pruebas',
   $$Preguntas de comportamiento: convertir algo que hiciste en algo que puedan creerse.$$,
   $$La situación es decorado: dos frases como mucho. Gasta las palabras en lo que hiciste tú, y termina en lo que cambió porque lo hiciste.$$),

  ('interview-failure',
   'Fracasos, defectos y huecos',
   $$Las preguntas diseñadas para encontrar la grieta: qué salió mal, en qué eres malo, por qué ese hueco de dos años.$$,
   $$Nómbralo con claridad, di qué cambiaste, para. Un defecto que no te ha costado nada no es un defecto, y en la sala se nota la escapatoria.$$),

  ('interview-craft',
   'Hablar de tu trabajo',
   $$Explicar lo que haces de verdad a una sala que va del experto al completamente perdido.$$,
   $$Apunta a la persona menos técnica de la sala y luego ofrece profundidad. Contar por tu cuenta la contrapartida que aceptaste es la señal de veteranía.$$),

  ('interview-rapport',
   'Llamadas de criba y sintonía',
   $$La llamada de selección, los primeros cinco minutos, y ser una persona al otro lado del teléfono.$$,
   $$Una criba filtra por cercanía y encaje, no por brillantez. Ponte al tono de quien llama, responde a la pregunta que te han hecho, y no te pases del largo que aguanta una llamada.$$),

  ('interview-your-questions',
   'Las preguntas que haces tú',
   $$*¿Tienes alguna pregunta?* — los diez minutos que casi todos los candidatos gastan en ser educados.$$,
   $$Pregunta lo que solo esa persona puede contestar. Una pregunta que responde la web de empleo se lee como deberes sin hacer; una pregunta sobre el trabajo se lee como alguien que ya lo está haciendo.$$),

  ('interview-money',
   'Sueldo y ofertas',
   $$Expectativas, bandas, y la conversación que viene después de *nos gustaría hacerte una oferta*.$$,
   $$Quien dice un número primero enmarca la conversación, así que ten preparado uno que puedas justificar. Una banda con un motivo gana a un número con una disculpa.$$),

  ('interview-closing',
   'Cerrar y hacer seguimiento',
   $$Los últimos cinco minutos, el mensaje de después, y qué hacer con un no.$$,
   $$Di claramente que lo quieres, pregunta qué les frenaría, y haz un solo seguimiento con algo útil en vez de algo ansioso.$$)
) as v(slug, name, description, core_idea)
join public.skills s on s.slug = v.slug
on conflict (skill_id, locale) do update set
  name = excluded.name,
  description = excluded.description,
  core_idea = excluded.core_idea,
  updated_at = now();

-- ---------------------------------------------------------------------------
-- Track 1 — Tu historia
-- ---------------------------------------------------------------------------

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

select pg_temp.es_lesson('interview-your-story', 1,
  'Tres tiempos, no una biografía',
  $md$*Háblame de ti* no es una pregunta. Es un hueco, y tú decides qué metes dentro.

Casi todo el mundo lo responde en orden cronológico, porque una vida llega en ese orden. La cronología es una trampa: gasta los primeros treinta segundos en una carrera que terminaste hace once años, y la atención de quien te entrevista está en su punto más alto exactamente en esos treinta segundos.

Usa tres tiempos en su lugar.

**Primer tiempo — de dónde vienes.** Una frase. La versión más corta posible de cómo acabaste dedicándote a esto. No dónde naciste. No el bachillerato.

**Segundo tiempo — qué hiciste con ello.** El medio, y la única parte que debería ocupar más de una frase o dos. Una o dos cosas concretas que hayas hecho de verdad, elegidas porque se parecen al puesto que hay encima de la mesa.

**Tercer tiempo — por qué estás aquí.** El aterrizaje. Por qué este puesto, en este sitio, ahora.

**La jugada:** responde en tres tiempos — de dónde vienes, qué hiciste con ello, por qué estás en esta sala.

Esto no funciona porque quede ordenado. Funciona porque quien te entrevista está construyendo un modelo tuyo mientras hablas, y tres tiempos es un modelo que le cabe en la cabeza. Una cronología le da una lista, y una lista no tiene forma, así que recuerda lo último que dijiste y nada más.

Un aviso. El segundo tiempo es donde vive el buen material, así que quiere crecer, y va a seguir creciendo hasta que la respuesta dure cuatro minutos y el tercer tiempo no llegue nunca. El tercero es el que hace el trabajo. Protégelo.$md$,
  $j$[
    {
      "situation": "Alguien de desarrollo, con seis años de experiencia, en una entrevista en una empresa de pagos.",
      "line": "Llegué a esto por una carrera de física y un montón de scripts que se me fueron de las manos. Desde entonces he pasado casi todo el tiempo en sistemas donde equivocarse sale caro — los últimos cuatro años en facturación en un marketplace, que fue mucha conciliación y mucho aprender cómo se mueve el dinero de verdad. Por eso me llamó la atención este puesto: es el mismo problema, pero es toda la empresa en vez del rincón de un equipo.",
      "why": "Tres tiempos, y cada uno hace un solo trabajo. El medio nombra el terreno en vez de enumerar empresas, y el aterrizaje dice por qué esta empresa en concreto — que es justo la parte que casi todos los candidatos dejan a la deducción."
    },
    {
      "situation": "Alguien que cambia de profesión, de dar clase a diseñar formación.",
      "line": "Pasé nueve años dando matemáticas en secundaria, que en realidad son nueve años descubriendo que explicar algo una vez no es nunca el trabajo. Los dos últimos estuve montando las programaciones didácticas del departamento, y esa parte me gustaba más que el aula. Así que desde entonces lo he ido buscando a propósito — un título de diseño de formación y dos proyectos como autónomo para equipos de formación. Este puesto es esa misma versión con presupuesto de verdad y un equipo.",
      "why": "El cambio de profesión no se pide perdón; se cuenta como una línea que llega hasta aquí. Fíjate en que el dato incómodo — nueve años en otra profesión — es lo primero que se dice, en vez de algo que quien entrevista tenga que desenterrar."
    },
    {
      "situation": "Alguien recién licenciado, sin experiencia a jornada completa, en una entrevista para analista júnior.",
      "line": "Llegué a esto por una asignatura de estadística que cogí casi por accidente y de la que luego no supe callarme. Casi todo lo que he hecho de verdad es pequeño — un trabajo de fin de grado sobre datos de transporte, un verano en una empresa de estudios de mercado limpiando encuestas que nadie quería tocar, y una cosa de estadísticas de fútbol que llevo por gusto y que leen unas cuatrocientas personas. Este puesto es el primero que veo en el que esas tres cosas son la misma habilidad.",
      "why": "Poca experiencia resuelta siendo concreto en vez de inflándola. Tres cosas concretas, todas pequeñas, todas verdad, todas apuntando al mismo sitio — que se lee muchísimo más fuerte que una declaración vaga de que te apasionan los datos."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál de estos es el primer tiempo más flojo?",
      "options": [
        { "text": "Estudié Economía en Valencia, luego hice un máster en Barcelona y me licencié en 2016.", "correct": true, "note": "Esto es una cronología, y gasta los segundos más valiosos de la respuesta en datos que ya están impresos en el CV que tienen delante." },
        { "text": "Entré en esto por un trabajo de verano que cogí solo por el dinero, y que resultó ser el primer sitio donde se me daba bien algo.", "correct": false, "note": "Una frase, algo humana, y explica un comienzo en vez de enumerarlo. Compra atención para el medio." },
        { "text": "Llevo unos siete años en la parte de operaciones de la logística, que no era el plan.", "correct": false, "note": "Comprime todo el comienzo en una oración y avisa de que hay una historia sin contarla todavía. Eficiente." }
      ],
      "explain": "El primer tiempo es el sitio más barato para perderlos. Es una frase, y su único trabajo es llevarte hasta el medio con su atención intacta."
    },
    {
      "prompt": "Llevas noventa segundos y no has llegado al tercer tiempo. ¿Cuál es el arreglo?",
      "options": [
        { "text": "Acelerar para que todavía te quepa todo.", "correct": false, "note": "Correr no comprime una respuesta, solo la hace más difícil de seguir. Quien te entrevista deja de escuchar y se pone a esperar." },
        { "text": "Dejar el resto del medio e ir directo a por qué estás aquí.", "correct": true, "note": "El aterrizaje es el tiempo que cambia algo. Una respuesta que llega ahí con dos ejemplos en vez de cuatro no ha perdido nada que importe." },
        { "text": "Terminar el medio como es debido: el detalle es lo que lo hace creíble.", "correct": false, "note": "Ya es creíble. El segundo mejor ejemplo no ha ganado nunca una entrevista, y suele ser justo lo que se come el aterrizaje." },
        { "text": "Preguntar si quieren que sigas.", "correct": false, "note": "Educado, y les entrega una respuesta que nunca aterrizó. Dirán que sí y recordarán que te enrollaste." }
      ],
      "explain": "Todas las respuestas largas a esta pregunta mueren igual: el medio se come el final. Cuando vas sobrado de tiempo, corta del medio, nunca del aterrizaje."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "three_beats", "label": "Tenía forma", "description": "La respuesta tuvo un comienzo, un medio y un aterrizaje en vez de ser una cronología." },
      { "key": "landed_on_them", "label": "Aterrizó en este puesto", "description": "Terminó conectando la historia con este puesto en concreto, en vez de parar en la última empresa." },
      { "key": "chosen_middle", "label": "Eligió el medio", "description": "Los ejemplos que dio se parecían al puesto que había sobre la mesa, en vez de ser lo primero que le vino a la cabeza." },
      { "key": "length", "label": "Fue breve", "description": "Unos noventa segundos. Suficiente para tener sustancia, corto como para que quisieran preguntar más." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Dan Whitfield",
      "role": "el responsable de contratación, que será tu jefe si esto sale bien",
      "mood": "Interesado. Ha leído el CV una vez, esta mañana, y recuerda más o menos la mitad.",
      "openness": 3,
      "personality": "Cercano pero eficiente. Hace preguntas cortas y deja que el silencio trabaje. Toma notas mientras hablas, lo cual descoloca si te fijas."
    },
    "setting": "Una videollamada, a los doce minutos de una primera entrevista para un puesto intermedio. La charla inicial ha terminado y quien entrevista acaba de abrir un documento.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde como responde quien entrevista: reconocimientos cortos, y luego una pregunta de seguimiento sobre algo concreto que haya dicho la persona.",
      "Si la respuesta se alarga o se convierte en una cronología, no lo digas. Haz una pregunta que estreche el foco, como haría una entrevistadora de verdad.",
      "Si la respuesta nunca explica por qué este puesto, pregunta por otra cosa completamente distinta y deja ese hueco sin rellenar.",
      "No des ánimos ni comentarios sobre cómo lo ha contado. Estás evaluando, no enseñando."
    ],
    "opening_beat": "Dan echa un vistazo a sus notas y vuelve a la cámara. «Vale — antes de entrar en ningún detalle, háblame de ti.»",
    "success_looks_like": "La persona da una respuesta con forma: comienzo, medio y un aterrizaje que nombra este puesto, en unos noventa segundos. Dan pregunta por algo del medio, lo que significa que fue lo bastante concreto como para agarrarse a ello."
  }$j$::jsonb,
  'Di tus tres tiempos en voz alta hoy a una persona real: un amigo, tu pareja, un compañero de confianza. No le avises antes de que estás practicando. Luego hazle una sola pregunta: ¿a qué puesto sonaba que me estaba presentando? Apunta lo que te diga, aunque se equivoque. Sobre todo si se equivoca.',
  $j${
    "says": "Vale — antes de entrar en ningún detalle, háblame de ti.",
    "model": {
      "line": "Empecé en operaciones en una empresa de logística, sobre todo porque fue el primer trabajo que me quiso, y descubrí que se me daba bien desenredar cosas que nadie más quería mirar. El medio son cinco años haciendo exactamente eso con problemas cada vez más grandes, los dos últimos llevando un equipo de seis y rehaciendo cómo gestionábamos las incidencias. Ahí he llegado más o menos hasta donde puedo, y este puesto es el primero que veo que es el mismo problema diez veces más grande, y por eso estoy aquí.",
      "why": "Tres tiempos y nada más: una frase de dónde empezó, el medio donde está el trabajo, y un aterrizaje que nombra el puesto. Menos de ciento diez palabras, que son unos noventa segundos en voz alta."
    },
    "checks": [
      { "kind": "min_words", "n": 60, "requirement": "Lo bastante largo para ser una respuesta y no un encogimiento de hombros" },
      { "kind": "max_words", "n": 170, "requirement": "Noventa segundos — ciento setenta palabras como mucho" },
      { "kind": "contains_any", "words": ["este puesto", "este trabajo", "por eso", "esa es la razón", "me ha traído", "estoy aquí"], "requirement": "Aterrízalo en por qué estás en esta sala" }
    ],
    "maxChars": 1100
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-your-story', 2,
  'El aterrizaje es toda la respuesta',
  $md$Dos candidatos dan el mismo medio. Uno termina en lo último que hizo. El otro termina en el puesto que hay en la sala. Al segundo se le recuerda como mejor candidato, y ninguno de los dos llega a saber por qué.

El aterrizaje hace algo que ninguna otra parte de la respuesta puede hacer. Todo lo anterior son pruebas, y las pruebas no se interpretan solas. Quien te entrevista está ahí sentado preguntando en silencio *¿y qué?*, y el aterrizaje es donde respondes a eso en voz alta en vez de confiar en que se entienda.

Un aterrizaje tiene dos mitades, y saltarse cualquiera de las dos es lo que hace que suene flojo.

**Por qué este trabajo.** Qué estás buscando de verdad, en palabras llanas. No un cumplido a la empresa: una dirección. *Quiero hacer esto sobre una superficie más grande* es una dirección. *Sois los líderes del mercado* es halago, y el halago es gratis, así que no cuenta.

**Por qué aquí.** Una cosa concreta de este sitio que no podrías decirle a su competidor más cercano. No hace falta que sea profunda. Una decisión de producto en la que te fijaste, cómo está escrita la oferta, algo que construyó la persona que te está entrevistando.

**La jugada:** termina en por qué este trabajo y por qué aquí, con un detalle que solo pueda ser sobre ellos.

El detalle concreto es la parte que la gente se salta, y es la parte que se recuerda. Quien entrevista se pasa el día oyendo que su empresa es apasionante. Que alguien se haya fijado en lo que de verdad hicieron es raro hasta el punto de merecer una nota al margen.

Una advertencia: el aterrizaje tiene que ser verdad. Un motivo inventado para querer el puesto es lo más fácil de pillar que existe, porque la pregunta que viene después siempre es *cuéntame más de eso*, y no hay más.$md$,
  $j$[
    {
      "situation": "Aterrizar la historia al presentarte a una empresa más pequeña después de años en una grande.",
      "line": "Lo que quiero ahora es estar más cerca de las decisiones. En el sitio anterior estaba a tres capas de cualquiera que pudiera cambiar la hoja de ruta, y me cansé de escribir el informe en vez de estar en la sala. Sois cuarenta personas y el puesto reporta a quien es dueño del producto, que es justo por lo que me presenté en vez de renovar.",
      "why": "Una dirección en vez de un cumplido, y el detalle concreto es estructural: a quién reporta el puesto. Eso solo se sabe si te has leído la oferta en serio, y lo dice sin decirlo."
    },
    {
      "situation": "Aterrizar una respuesta en una entrevista para un puesto que es un movimiento lateral y no un ascenso.",
      "line": "La versión honesta es que no busco subir de nivel, busco moverme de lado. Lo que se me da bien es llevar una cosa de hecha un lío a funcionando, y a mi puesto actual se le ha acabado el lío. Vuestro artículo de ingeniería sobre rehacer el sistema de planificación decía en voz alta lo que casi nadie dice: que sigue migrado a medias. Ese es el trabajo que quiero.",
      "why": "Nombra lo incómodo antes de que puedan preguntárselo, y luego hace que el detalle concreto trabaje por partida doble: demuestra que investigó, y demuestra que la motivación es real porque señala el lío exacto que quiere."
    },
    {
      "situation": "Alguien cuyo motivo real para irse es un mal jefe, aterrizando la respuesta sin decirlo.",
      "line": "He aprendido mucho en el puesto actual y he dejado de aprender en él, que es el resumen útil. Lo que busco es un sitio donde el listón lo ponga alguien de quien pueda aprender — y la razón por la que estoy aquí es que dos personas en las que confío me han dicho, por separado, que este es el equipo donde eso pasa.",
      "why": "Verdad, completo, y no da nada. El rencor hacia un jefe es la forma más común de que esta respuesta salga mal; el arreglo no es mentir, sino responder a una altura donde el detalle feo sencillamente no viene a cuento."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué aterrizaje está haciendo más trabajo?",
      "options": [
        { "text": "Y por eso me hace muchísima ilusión esta oportunidad: estáis haciendo cosas increíbles en este sector.", "correct": false, "note": "Se le podría decir a cualquier empresa del planeta, lo que significa que no dice nada. La palabra ilusión está cargando con todo y no puede." },
        { "text": "Y eso nos trae hasta hoy, básicamente. Ese soy yo.", "correct": false, "note": "No es un aterrizaje en absoluto. Detiene la respuesta sin interpretarla, y deja el «¿y qué?» en manos de quien entrevista." },
        { "text": "Lo que quiero es ser dueño de un producto y no de una funcionalidad, y este es uno de los tres sitios más o menos que contratan para eso donde el producto es algo que yo usaría.", "correct": true, "note": "Una dirección, y luego un motivo concreto y comprobable. Ese «de los tres sitios más o menos» señala sin ruido una búsqueda pensada y no un envío masivo." },
        { "text": "Y llevo mucho tiempo siguiendo a vuestra empresa, así que esto me parece el paso natural.", "correct": false, "note": "No se puede comprobar y vale para cualquiera. «El paso natural» es la frase a la que se agarra quien no ha averiguado cuál es el paso." }
      ],
      "explain": "Un aterrizaje necesita una dirección y un detalle. El entusiasmo sin ninguna de las dos cosas es el final más común que hay, y es por lo que tantas buenas respuestas se olvidan."
    },
    {
      "prompt": "Quieres el puesto sobre todo porque paga bastante más. ¿Qué pones en el aterrizaje?",
      "options": [
        { "text": "Dilo. La honestidad desarma y ya saben que el dinero cuenta.", "correct": false, "note": "Es honesto, y también responde a una pregunta que nadie ha hecho en el momento menos útil para ti. El dinero tiene su propia conversación más tarde, en mejores condiciones." },
        { "text": "Busca el motivo verdadero que hay debajo y aterriza en ese.", "correct": true, "note": "Casi siempre hay uno: más alcance, problemas más difíciles, un nivel que se te ha quedado pequeño. El sueldo suele ser el síntoma de lo que de verdad quieres, y lo que de verdad quieres es lo que hace que un aterrizaje aterrice." },
        { "text": "Invéntate un motivo sobre su misión y sostenlo.", "correct": false, "note": "La pregunta que viene después siempre es «cuéntame más de eso», y no hay más. Un aterrizaje que no sobrevive a una sola pregunta es peor que uno soso." }
      ],
      "explain": "No estás obligado a dar todos tus motivos. Estás obligado a que el que des sea verdad, porque la siguiente pregunta lo va a poner a prueba."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "direction", "label": "Nombró una dirección", "description": "Dijo qué está buscando, en vez de hacerle un cumplido a la empresa." },
      { "key": "specific_detail", "label": "Un detalle solo sobre ellos", "description": "Incluyó algo que no se le podría haber dicho a un competidor." },
      { "key": "truthfulness", "label": "Sobreviviría a una repregunta", "description": "El motivo que dio era lo bastante real como para ampliarlo si se lo piden." },
      { "key": "clean_finish", "label": "Terminó limpio", "description": "Acabó en el aterrizaje y paró, en vez de irse apagando o volver a empezar." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priya Raghunathan",
      "role": "una directora dos niveles por encima del puesto, que asiste a la segunda ronda",
      "mood": "Con curiosidad de verdad. Hoy tiene tres de estas y esta es para la que tiene tiempo.",
      "openness": 4,
      "personality": "Cercana, y mucho más afilada de lo que sugiere la cercanía. Cualquier cosa vaga la sigue con «cuéntame más de eso», y espera."
    },
    "setting": "Una entrevista presencial de segunda ronda, en una sala de reuniones con una pizarra que alguien no ha borrado. Los primeros quince minutos han ido bien.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Cada vez que la persona diga algo genérico o halagador, responde solo con alguna versión de «cuéntame más de eso» y luego espera.",
      "Si nombra un detalle concreto y que suene verdadero sobre la empresa, engánchate a él como haría una persona: dale la razón, complícalo o añade contexto.",
      "No aceptes el entusiasmo como respuesta. Calidez en el tono, ninguna suavización de la pregunta.",
      "No te alargues más de dos o tres frases por turno. Estás aquí para escuchar."
    ],
    "opening_beat": "Priya tapa el bolígrafo. «He leído tu CV y Dan me ha dado el resumen, así que no me hace falta toda la historia. Lo que quiero saber es por qué estás sentado aquí y no en otro sitio.»",
    "success_looks_like": "La persona da una dirección y un detalle que es específicamente sobre esta empresa, y aguanta cuando Priya le pide que cuente más."
  }$j$::jsonb,
  'Coge hoy una oferta de empleo real, una a la que te presentarías de verdad. Encuentra un detalle en ella, o en la empresa, que no se le podría decir a sus competidores. Luego di tu aterrizaje en voz alta a alguien y pregúntale si sonó a que te lo habías mirado o a que estabas siendo educado. Apúntalo.',
  $j${
    "says": "No me hace falta toda la historia. Lo que quiero saber es por qué estás sentado aquí y no en otro sitio.",
    "model": {
      "line": "Lo que me llamó la atención fue que reconstruisteis el proceso de incidencias en vez de contratar gente para esquivarlo. Ese es el argumento que llevo dos años defendiendo y perdiendo. Quiero trabajar en un sitio donde esa discusión ya se ha tenido.",
      "why": "Un detalle que solo puede ser sobre ellos, qué te dijo, y qué quieres sacar de ello. Ni un solo adjetivo sobre la empresa."
    },
    "checks": [
      { "kind": "max_sentences", "n": 3, "requirement": "Tres frases. Esto es el aterrizaje, no la historia." },
      { "kind": "first_person", "requirement": "Di qué quieres tú, no lo que suena impresionante" },
      { "kind": "forbids_any", "words": ["oportunidad apasionante", "me apasiona", "líderes del mercado", "líder del mercado", "líderes del sector", "referente del sector", "vanguardia", "muy buen ambiente"], "requirement": "Nada de palabras de folleto" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-your-story', 3,
  'Recórtalo a noventa segundos',
  $md$A nadie lo han rechazado nunca por una historia demasiado corta.

La razón por la que noventa segundos es el objetivo no es que la atención dure poco. Es que una entrevista es una conversación con un presupuesto, y cada segundo que gastas es un segundo que no gastas en una pregunta donde podrías haber estado mejor. Una respuesta de cuatro minutos a la pregunta de apertura no solo aburre: se come la parte de la hora en la que habrías brillado.

El instinto al recortar es recortar a partes iguales: quitar un poco de cada trozo, hablar algo más rápido, soltar algún adjetivo. Eso produce una versión comprimida de la misma respuesta, que es peor, porque ahora además de larga es densa.

Corta cosas enteras.

**Quita el segundo mejor ejemplo.** Dos ejemplos que demuestran lo mismo son un ejemplo y un rehén. Quédate con el que más se parece al puesto.

**Quita todos los trabajos que no sostengan nada.** No estás obligado a mencionarlos todos. *Un par de agencias antes de eso* cubre cuatro años y nadie te va a parar.

**Quita los motivos.** Por qué te fuiste de cada sitio, por qué cogiste el siguiente: eso es otra respuesta, a una pregunta que igual ni te hacen. Explicar los cambios sin que te lo pidan es el mayor coste oculto de casi todas las historias.

**La jugada:** corta cosas enteras, nunca palabras — el segundo mejor ejemplo se va el primero.

La prueba de si funcionó no es el reloj. Es si quien te entrevista pregunta algo más. Una historia que termina con alguien queriendo que amplíes una cosa concreta es una historia que hizo su trabajo: puedes hablar de tu mejor material como respuesta a su pregunta, y eso pega el doble de fuerte que ofrecerlo tú.$md$,
  $j$[
    {
      "situation": "Alguien con once años y seis empresas, comprimiendo el medio.",
      "line": "La primera mitad de mi carrera fueron agencias — cuatro, todas bastante parecidas, todas útiles. La parte que merece la pena contar empezó cuando pasé a interno en una cadena de tiendas en 2019 y heredé un equipo que había perdido tres personas en un mes.",
      "why": "Cuatro trabajos despachados en una oración, con un juicio pegado para que no suene a evasiva. Ahora quien entrevista sabe dónde preguntar, y la respuesta llega a su mejor material en quince segundos."
    },
    {
      "situation": "Alguien que no para de explicar por qué se fue de cada puesto.",
      "line": "Me cambié al segundo sitio por un equipo más grande, y luego— [para]. Me cambié al segundo sitio, y ahí es donde empieza lo interesante.",
      "why": "Los cambios son una pregunta, no una obligación. Ofrecer el motivo de cada movimiento invita a la sospecha donde no la había, y suele ser donde una respuesta de noventa segundos se convierte en una de tres minutos."
    },
    {
      "situation": "Alguien decidiendo entre dos ejemplos fuertes para el medio.",
      "line": "Podría contar la migración o la reconstrucción del sistema de informes. La descripción del puesto menciona la calidad del dato dos veces, así que: la reconstrucción de los informes.",
      "why": "La elección se hace contra la oferta, no contra el orgullo. La migración puede ser la mejor historia y los informes la mejor respuesta, y eso son cosas distintas."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Tu historia dura dos minutos y medio. ¿Qué recorte te compra más tiempo?",
      "options": [
        { "text": "Quitar los adjetivos y apretar la redacción en toda la respuesta.", "correct": false, "note": "Ahorra unos diez segundos y hace la respuesta más difícil de escuchar. Densidad no es brevedad." },
        { "text": "Resumir tus tres primeros trabajos en una sola oración.", "correct": true, "note": "Compra treinta o cuarenta segundos de un solo golpe, y no cuesta nada: los puestos de los primeros años casi nunca sostienen el argumento de por qué contratarte ahora." },
        { "text": "Cortar el aterrizaje y dejar que el CV explique por qué te presentaste.", "correct": false, "note": "El CV no puede explicar eso. Esta es la única parte de la respuesta que nada más en el proceso sustituye." },
        { "text": "Hablar más rápido.", "correct": false, "note": "La respuesta dura lo mismo. Solo que ahora suena nerviosa." }
      ],
      "explain": "Los recortes deben quitar elementos, no sílabas. Un trabajo entero o un ejemplo entero valen más que una página de apretar frases."
    },
    {
      "prompt": "¿Cuál es la mejor señal de que tu historia tenía la longitud correcta?",
      "options": [
        { "text": "Terminaste dentro de los noventa segundos.", "correct": false, "note": "Es un objetivo útil, pero el reloj es solo un indicador indirecto. Ochenta segundos apretados que no aterrizan en nada siguen siendo una mala respuesta." },
        { "text": "Fueron asintiendo todo el rato.", "correct": false, "note": "La gente asiente. Es la señal más barata de una entrevista y solo significa que no estás resultando desagradable." },
        { "text": "Te pidieron que ampliaras una cosa concreta que mencionaste.", "correct": true, "note": "Eso es la respuesta funcionando exactamente como se pretendía: dejó un anzuelo, lo cogieron, y ahora tu mejor material es una contestación en vez de un monólogo." }
      ],
      "explain": "El objetivo no es decirlo todo. Es conseguir que pregunten."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "length", "label": "Por debajo de dos minutos", "description": "Terminó la respuesta sin que le cortaran y sin quedarse sin carretera." },
      { "key": "whole_cuts", "label": "Cortó elementos, no palabras", "description": "Comprimió dejando cosas fuera del todo, en vez de pasando por ellas a toda prisa." },
      { "key": "no_unprompted_reasons", "label": "Dejó los cambios en paz", "description": "No explicó por qué se fue de cada puesto sin que se lo preguntaran." },
      { "key": "left_a_hook", "label": "Dejó algo por lo que preguntar", "description": "Mencionó algo lo bastante concreto como para que quien entrevista quisiera que lo ampliara." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Marcus Aiyegbeni",
      "role": "un reclutador interno haciendo una primera criba",
      "mood": "Algo retrasado y tratando de que no se le note.",
      "openness": 3,
      "personality": "Rápido y agradable. Habla en frases cortas y espera lo mismo. Interrumpe con educación si una respuesta se alarga, porque tiene el día encadenado."
    },
    "setting": "Una llamada de criba que ha empezado cuatro minutos tarde. El reclutador tiene otra llamada y media y lo ha dicho.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si una respuesta pasa de lo que serían unos dos minutos de texto, interrumpe con educación y haz una pregunta que estreche el foco. No expliques por qué.",
      "Habla en frases cortas. Esto es una llamada de teléfono y estás mirando el reloj.",
      "Menciona una vez el tiempo que queda, con naturalidad, a mitad de la conversación.",
      "No comentes en ningún momento la longitud ni cómo lo está contando."
    ],
    "opening_beat": "«Gracias por sacar el hueco. Tenemos hasta y media, así que voy rápido: cuéntame la versión resumida de tu trayectoria y qué estás buscando.»",
    "success_looks_like": "La persona cuenta una historia que cabe holgadamente en dos minutos, se salta los primeros puestos, y aun así aterriza en por qué este trabajo. Marcus pregunta algo más en vez de pasar a otra cosa."
  }$j$::jsonb,
  'Grábate contando tu historia una vez, con el móvil, de una sola toma. Escúchala y apunta la única cosa que cortarías. Luego cuéntale la versión recortada a una persona real y apunta si te hizo alguna pregunta después.',
  $j${
    "beats": [
      {
        "situation": "Tu respuesta dura tres minutos. Contiene: la carrera que estudiaste, tu primer trabajo, un contrato de dos años, tu trabajo actual, un proyecto personal que te encanta, y el aterrizaje.",
        "prompt": "El reclutador te ha dado noventa segundos. ¿Qué se va?",
        "options": [
          { "text": "La carrera y el primer trabajo, comprimidos en una sola oración.", "correct": true, "note": "Corta cosas enteras, y las más antiguas primero. Nadie te contrata por la carrera, y el primer trabajo se gana su sitio solo como aquello que arrancó la dirección." },
          { "text": "Recortar unas cuantas palabras de cada frase en toda la respuesta.", "correct": false, "note": "Así es como una respuesta de tres minutos se convierte en una de dos cincuenta que además ahora es difícil de seguir. Las palabras no son donde está el tiempo." },
          { "text": "El proyecto personal: no es lo que han preguntado.", "correct": false, "note": "Puede que sea lo más memorable de toda la respuesta. Corta por antigüedad, no por una relevancia que no has comprobado." },
          { "text": "El aterrizaje, que ya volverás a él más tarde.", "correct": false, "note": "El aterrizaje es la única parte que está haciendo trabajo. Cortarlo deja un resumen de tu CV, que ya tienen." }
        ]
      },
      {
        "situation": "Lo has recortado a noventa segundos y ahora a ti te parece que se queda corto.",
        "prompt": "¿Qué suele significar esa sensación?",
        "options": [
          { "text": "Nada. Es tu tercera vez contándolo y la primera de ellos.", "correct": true, "note": "Quedarse corto es lo que se siente por dentro cuando una respuesta está bien recortada, porque tú oyes todo lo que dejaste fuera. Ellos no." },
          { "text": "Has cortado demasiado y deberías devolver un elemento.", "correct": false, "note": "Ese es el instinto que en una semana de práctica lo devuelve a los tres minutos. Si está completo y aterriza, está terminado." },
          { "text": "Te hace falta más detalle en el medio para demostrarlo.", "correct": false, "note": "Para el detalle del medio están las veinte preguntas siguientes. Esta respuesta solo tiene que ganárselas." },
          { "text": "El orden está mal, y por eso suena plano.", "correct": false, "note": "Reordenar una respuesta que ya está completa es una forma de seguir trabajándola. El orden está fijado: comienzo, medio, aterrizaje." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-your-story', 4,
  'Otra sala, otra versión',
  $md$La misma historia contada a un reclutador, a un responsable de contratación y a un panel no debería ser la misma historia. No porque estés siendo escurridizo, sino porque están haciendo preguntas distintas con las mismas palabras.

**Un reclutador** está preguntando: ¿encaja esta persona con lo que me han pedido, y es normal? No está en condiciones de evaluar tu oficio y suele estar cribando a mucha gente. Apunta alto, usa las palabras de la oferta, sé breve. Aquí el detalle es un coste, no una virtud.

**Un responsable de contratación** está preguntando: ¿cómo será trabajar con esta persona en lo que ahora mismo me está costando? Quiere el segundo tiempo, lo quiere concreto, y quiere la versión sucia: qué fue difícil de verdad.

**Un panel, o alguien dos niveles por encima,** está preguntando: ¿esta persona ve el cuadro completo, y podría crecer? Apunta al alcance. El segundo tiempo pasa a ser sobre el tamaño de lo que llevabas, en vez del detalle de cómo lo hiciste.

**La jugada:** mantén los tres tiempos y cambia solo el medio según quién pregunta.

Lo que no puede cambiar es el aterrizaje. Tu motivo para querer este puesto debería ser idéntico en todas las salas, y si se va moviendo entre conversaciones te van a pillar, porque comparan notas: para eso está la puesta en común.

Una última, barata y efectiva: usa su vocabulario. Si la oferta dice *socios* y no *clientes*, di socios. No es hacer la pelota, es la prueba de que se te puede entender dentro de su edificio.$md$,
  $j$[
    {
      "situation": "El mismo segundo tiempo, contado a un reclutador.",
      "line": "Los últimos cuatro años han sido trabajo de plataforma — sobre todo fiabilidad y coste, en un equipo de unas ocho personas. Eso es el grueso de lo que describe vuestra oferta, y por eso os escribí.",
      "why": "Apuntado a lo que piden, con sus propias palabras, en dos frases. El trabajo de un reclutador es emparejar, así que ponle el emparejamiento fácil de ver y no le des nada que tenga que interpretar."
    },
    {
      "situation": "El mismo segundo tiempo, contado al responsable de contratación.",
      "line": "La versión sucia es que estábamos pagando un cuarenta por ciento más de lo necesario y nadie sabía decirme por qué, porque el etiquetado llevaba dos años siendo opcional. Así que los tres primeros meses no fueron de ingeniería en absoluto: fueron ir servicio por servicio discutiendo con gente sobre de quién era cada cosa.",
      "why": "Concreto, honesto sobre lo que de verdad fue difícil, y describe la parte humana del trabajo. Quien contrata te está imaginando dentro de su propio lío; esta es la respuesta que se lo permite."
    },
    {
      "situation": "El mismo segundo tiempo, contado a una directora en una ronda final.",
      "line": "Yo llevaba la línea de coste de la plataforma, que era como un quinto del gasto de infraestructura, y lo que haría distinto es que lo arreglé antes de arreglar el motivo por el que pasaba. Bajamos el número y luego volvió a subir, porque yo no había cambiado cómo entregaban los equipos.",
      "why": "Primero el alcance, y luego una reflexión de verdad sobre sistemas en vez de sobre tareas. La gente sénior escucha para ver si ves el problema de segundo orden, y contarlo por tu cuenta es mucho más fuerte que que te lo pregunten."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Un reclutador te pide tu trayectoria. Le das el medio detallado y técnico. ¿Qué ha salido mal?",
      "options": [
        { "text": "Nada: el detalle demuestra competencia y lo pasará adelante.", "correct": false, "note": "Lo que pasará adelante son sus notas, y sus notas son un resumen que no estaba preparado para hacer. El detalle dado al público equivocado llega distorsionado o no llega." },
        { "text": "Le has hecho trabajar para ver el encaje, y el encaje es todo su trabajo.", "correct": true, "note": "Un reclutador te está comparando con un encargo. Cada frase que tenga que traducir es una oportunidad de que la traducción te pierda." },
        { "text": "Te has alargado demasiado, y la longitud es el riesgo principal en una criba.", "correct": false, "note": "La longitud es un coste real, pero el problema de fondo es la altura. Una respuesta corta apuntada a la pregunta equivocada también falla." }
      ],
      "explain": "Ajusta la altura de la respuesta a lo que quien pregunta puede evaluar de verdad. La profundidad ante alguien que no puede valorarla no impresiona: es ruido."
    },
    {
      "prompt": "¿Qué parte de la historia tiene que ser idéntica en todas las salas?",
      "options": [
        { "text": "El primer tiempo, para que la historia empiece siempre igual.", "correct": false, "note": "Puede comprimirse o ampliarse, y a menudo debe hacerlo. Nadie compara comienzos." },
        { "text": "Los ejemplos del medio, para que tu relato de tu trabajo sea coherente.", "correct": false, "note": "Elegir ejemplos distintos para públicos distintos no es incoherencia: los hechos no cambian, solo cuáles vienen a cuento." },
        { "text": "El aterrizaje: por qué este trabajo y por qué aquí.", "correct": true, "note": "Este es el que comparan en la puesta en común, y una motivación que se mueve de una sala a otra se lee como alguien diciéndole a cada persona lo que quiere oír." },
        { "text": "La longitud, para que nadie se sienta menos atendido.", "correct": false, "note": "Una criba telefónica y una ronda final tienen presupuestos completamente distintos. Mantener la longitud fija desperdiciaría una y reventaría la otra." }
      ],
      "explain": "Adapta las pruebas, nunca el motivo. La puesta en común es justo donde se contrastan esas dos cosas."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "pitched_right", "label": "Apuntó a quien preguntaba", "description": "El nivel de detalle correspondía a lo que esa persona en concreto podía evaluar." },
      { "key": "consistent_landing", "label": "El mismo motivo en cada sala", "description": "La motivación que dio coincidiría con lo que le habría dicho a cualquier otra persona del proceso." },
      { "key": "their_words", "label": "Usó su vocabulario", "description": "Tomó prestado el lenguaje de la oferta o de la empresa en vez de traducirlo todo al suyo." },
      { "key": "concrete", "label": "Concreto donde tocaba", "description": "Le dio a quien contrata algo real y específico en vez de un resumen." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Ruth Okonjo",
      "role": "una jefa de departamento que asiste a la ronda final",
      "mood": "Neutral y atenta. La metieron en esto hace veinte minutos y está decidiendo si mereció la pena.",
      "openness": 3,
      "personality": "Directa, sin prisa, e interesada en el alcance más que en la técnica. Pregunta mucho «¿y de qué tamaño era eso?». No le impresiona el detalle por el detalle."
    },
    "setting": "Una conversación de ronda final con alguien sénior a quien añadieron a la agenda con poca antelación y que no ha leído nada.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Cuando una respuesta se meta en detalle técnico, pregunta por el tamaño, por de quién era la responsabilidad o por las consecuencias, en vez de seguir el detalle.",
      "No finjas haber leído nada. Si la persona menciona algo de rondas anteriores, pídele que te lo explique.",
      "Pregunta «¿y qué pasó después?» al menos una vez.",
      "Nunca le digas qué registro usar. Si hay un desajuste, déjalo estar."
    ],
    "opening_beat": "«Te seré sincera, no me he leído tu CV: me metieron en esto ayer. Así que empieza por el principio y cuéntame de qué has sido responsable en realidad.»",
    "success_looks_like": "La persona da una versión apuntada al alcance y a la responsabilidad en vez de a la técnica, mantiene el mismo aterrizaje que le daría a cualquiera, y no la ahoga en detalle."
  }$j$::jsonb,
  'Cuenta tu historia hoy dos veces a dos personas distintas: una que conozca tu sector y otra que no. Cambia solo el medio. Apunta cuál de las dos versiones te costó más, porque esa es la sala para la que menos preparado estás.',
  $j${
    "beats": [
      {
        "situation": "El mismo puesto, los mismos tres tiempos. Quien pregunta es una jefa de departamento que no se ha leído tu CV y a la que añadieron al panel ayer.",
        "prompt": "¿En qué se convierte el medio?",
        "options": [
          { "text": "De qué has sido responsable, en alcance y en resultados.", "correct": true, "note": "No puede situarte, así que el medio tiene que decir de qué tamaño era lo que llevabas y qué le pasó. El detalle para el que no tiene marco es ruido." },
          { "text": "Las decisiones técnicas de las que estás más orgulloso.", "correct": false, "note": "El medio correcto para un igual y el equivocado aquí. Ella no tiene forma de distinguir una decisión difícil de una fácil en tu campo." },
          { "text": "El mismo medio que le darías a cualquiera. La coherencia importa.", "correct": false, "note": "La coherencia de los tres tiempos sí importa. Un medio que ignora quién pregunta no es coherente: es sin adaptar." },
          { "text": "Una versión más corta, ya que tiene menos contexto.", "correct": false, "note": "Menos contexto pide más orientación, no menos. Acortar es el eje equivocado." }
        ]
      },
      {
        "situation": "La siguiente entrevista es con alguien que hará el mismo trabajo que tú, un escalón por encima.",
        "prompt": "¿En qué se convierte el medio ahora?",
        "options": [
          { "text": "El trabajo concreto, incluidas las partes que fueron difíciles.", "correct": true, "note": "Él sí nota la diferencia, y ahí está toda la oportunidad. El alcance y los resultados ante un igual se leen como alguien esquivando el detalle." },
          { "text": "Alcance y resultados, para que vea a qué nivel te mueves.", "correct": false, "note": "Lo va a leer como una respuesta de jefe dada por alguien que quizá no ha hecho el trabajo. Con un igual, baja una capa." },
          { "text": "Lo que él acabe de estar contando.", "correct": false, "note": "Seguir su interés es buen instinto y no es el medio de tu historia. Cambia el medio, mantén los tiempos." },
          { "text": "El mismo que le diste a la jefa de departamento.", "correct": false, "note": "El único público con el que está garantizado que rinda por debajo." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-your-story', 5,
  'Cuéntame tu CV',
  $md$Esta es otra pregunta con el mismo abrigo puesto, y responderla con tu historia preparada es una de las formas más comunes de que un buen candidato tropiece.

*Háblame de ti* quiere una forma. *Cuéntame tu CV* quiere una cronología: tienen el documento delante y van siguiendo, y si saltas de sitio pierden el hilo. Dales la cronología. Pero dásela con una espina dorsal.

La espina es una frase, dicha antes de empezar: qué suma el arco entero. *La versión corta es que siempre acabo siendo la persona que arregla los informes.* Después recorre los puestos, brevemente, y cada puesto lleva una línea sobre por qué se produjo el cambio. Ahora la cronología es la prueba de una afirmación, y no una lista.

**La jugada:** di qué suma el arco, después recórrelo, y dale a cada cambio un motivo.

Dos cosas concretas que preparar, porque es en esta pregunta donde salen.

**Los saltos.** Estancias cortas, movimientos laterales, una reestructuración, un hueco. Dilos con claridad y en el mismo tono que todo lo demás. Lo que se lee es el tono, no el dato: nueve meses contados con calma son nueve meses, y contados con disculpa son un problema.

**Lo más antiguo.** Cualquier cosa de hace más de ocho años se lleva una oración, no un párrafo. Si lo quieren, te pararán, y que te paren está bien.

La pregunta de verdad, debajo de todo esto, es: ¿tiene sentido la carrera de esta persona, y me está diciendo la verdad sobre ella? Las dos se responden tanto con el tono como con el contenido.$md$,
  $j$[
    {
      "situation": "Abrir el recorrido con una espina dorsal.",
      "line": "Antes de empezar: el hilo es que siempre he sido el puente entre el equipo técnico y quien lo paga. Eso es verdad en los cuatro trabajos, aunque los títulos no lo parezcan. Así que, empezando en 2017…",
      "why": "Una frase que convierte una lista en un argumento. Todo lo que viene después se escucha como prueba de esa afirmación, incluidos los puestos que sobre el papel parecen no venir a cuento."
    },
    {
      "situation": "Explicar un puesto de nueve meses que acabó mal.",
      "line": "Luego hubo nueve meses en una startup que no salió: no se cerró la ronda de financiación y el equipo pasó de veinte a seis. Estuve en los seis un tiempo, y luego decidí que no quería estar. Ese fue el año en que aprendí a preguntar cuánto dinero les queda antes de firmar nada.",
      "why": "Llano, sin prisa, y termina en un juicio en vez de en una herida. La última frase convierte con discreción el puesto más corto del CV en aquel donde aprendieron algo."
    },
    {
      "situation": "Gestionar un hueco de dos años por cuidar de alguien.",
      "line": "Hay un hueco de 2021 a 2023: mi padre estuvo enfermo y yo era quien vivía cerca, así que dejé de trabajar. Hacia el final mantuve algo de mano con algún encargo suelto. Y a jornada completa otra vez desde marzo.",
      "why": "Tres frases, sin disculpas y sin explicar de más. Un hueco se convierte en problema cuando se presenta como tal; dicho como un dato con una fecha a cada lado, casi siempre pasa sin comentarios."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Te piden que les cuentes el CV. ¿Cuál debería ser la primera frase?",
      "options": [
        { "text": "La afirmación que suma tu CV entero.", "correct": true, "note": "Convierte el recorrido en pruebas. Sin ella estás leyendo en voz alta una lista que ya ven, y son ellos quienes tienen la lista en la mano." },
        { "text": "Tu puesto actual, ya que es el más relevante.", "correct": false, "note": "Eso responde a otra pregunta. Han pedido el recorrido porque quieren la secuencia, y empezar por el final les obliga a ir hacia atrás." },
        { "text": "Tu primer trabajo, ya que ahí empieza la cronología.", "correct": false, "note": "Ahí empieza la cronología y es lo menos útil de la página. Llega, pero ni el primero ni por mucho tiempo." }
      ],
      "explain": "Una cronología sin espina dorsal es una lista. La espina cuesta una frase y cambia cómo se escucha todo lo que viene detrás."
    },
    {
      "prompt": "Hay un hueco de dieciocho meses en tu CV. ¿Cuándo deberías mencionarlo?",
      "options": [
        { "text": "Solo si preguntan. Sacarlo llama la atención sobre ello.", "correct": false, "note": "Tienen el documento delante. Pasar por delante de un hueco visible en silencio es justo lo que llama la atención, y se lee como confiar en que no lo hayan visto." },
        { "text": "Cuando llegues a él, en el mismo tono que todo lo demás.", "correct": true, "note": "Es una fecha en una página. Dicho con la misma voz que el resto, es un dato; guardado para luego o pasado a toda prisa, se convierte en un tema." },
        { "text": "Al principio, para quitártelo de encima.", "correct": false, "note": "Ponerlo delante le da un peso que no tiene. No es el titular de tu carrera a menos que tú lo conviertas en uno." },
        { "text": "Al final, cuando ya hayas construido credibilidad suficiente para absorberlo.", "correct": false, "note": "Esto lo trata como una deuda que hay que cubrir. Para entonces llevan diez minutos esperándolo, que es peor que el hueco." }
      ],
      "explain": "Esta pregunta la decide el tono, no el contenido. Los mismos dieciocho meses son un dato o un problema dependiendo enteramente de cómo se digan."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "spine", "label": "Le dio una espina dorsal", "description": "Abrió diciendo qué suma el arco entero, antes de recorrer los puestos." },
      { "key": "reasons_for_moves", "label": "Explicó los cambios", "description": "Cada cambio llevaba un motivo corto, así que la secuencia se leyó como decisiones y no como deriva." },
      { "key": "awkward_facts", "label": "Trató lo incómodo con llaneza", "description": "Huecos, estancias cortas y movimientos laterales dichos en el mismo tono que todo lo demás." },
      { "key": "proportion", "label": "Repartió bien el peso", "description": "Los puestos recientes y relevantes se llevaron el tiempo; los más antiguos, una oración." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Ian Beattie",
      "role": "un responsable de contratación que lee los CV con atención y los subraya",
      "mood": "Concentrado. Ya ha visto las dos cosas por las que piensa preguntar.",
      "openness": 3,
      "personality": "Metódico y discretamente cercano. Sigue la página con un bolígrafo y te para en todo lo que ha rodeado con un círculo. No es hostil: siente curiosidad de verdad por las costuras."
    },
    "setting": "Una sala de entrevistas con un CV impreso sobre la mesa entre los dos, visiblemente anotado en dos colores.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Inventa un detalle incómodo plausible a partir de lo que cuente la persona — una estancia corta, un movimiento lateral, un hueco — y pregunta por él una vez, con neutralidad.",
      "Si la persona acelera o se disculpa por algo, no la tranquilices. Haz una pregunta llana de seguimiento y sigue adelante.",
      "Interrumpe con suavidad si se alarga en los puestos más antiguos: «vamos a lo reciente».",
      "Nunca comentes cómo se está presentando."
    ],
    "opening_beat": "Ian gira el CV para que lo veáis los dos y da un golpecito con el bolígrafo en lo alto de la página. «Cuéntamelo. Empieza por donde quieras, pero me gustaría entender las costuras.»",
    "success_looks_like": "La persona abre con un hilo conductor, recorre los puestos en orden con un motivo para cada cambio, y trata cualquier estancia corta o hueco en el mismo tono que el resto."
  }$j$::jsonb,
  'Imprime o abre tu CV y recórreselo a alguien en voz alta, de arriba abajo, dando un motivo para cada cambio. Pregúntale después qué costura sonó más floja. Apunta lo que te diga: esa es por la que te van a preguntar.',
  $j${
    "turns": [
      { "instruction": "Antes de recorrer nada, di qué suma el arco entero. Una frase." },
      { "instruction": "Ahora recórrelo, y dale a cada cambio un motivo: por qué te fuiste, no solo adónde." },
      { "instruction": "Aterrízalo en el presente. Para qué fue el último cambio, y por qué esta sala." }
    ]
  }$j$::jsonb
);
