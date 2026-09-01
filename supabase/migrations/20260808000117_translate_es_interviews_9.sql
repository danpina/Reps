-- Spanish: Interviews, track 9 — Cerrar y hacer seguimiento. Last of the
-- topic.
--
-- Conventions as migration 109. Notes:
--
-- **"Give you pause" becomes "generar dudas".** Spanish has no single verb for
-- the hesitation the English names, and "reparos" — the closest — is a shade
-- too formal for a sentence somebody has to say out loud at the end of an
-- interview. The check accepts both, plus "preocupa" and "te frenaría", because
-- all four are ways a Spanish speaker actually asks this.
--
-- **The thank-you note keeps its English-shaped bans.** "Gracias por tu
-- tiempo", "quedo a la espera" and "no dudes en" are the exact Spanish
-- formulas that make a follow-up note identical to everybody else's — they are
-- not translations of the English phrases, they are their equivalents in the
-- same slot.

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

select pg_temp.es_lesson('interview-closing', 1,
  'Di que lo quieres',
  $md$Quien te entrevista no lee la mente, y el entusiasmo no es lo mismo que la intención. Un candidato puede ser cercano, estar metido y resultar interesante durante cincuenta minutos y salir de la sala sin que nadie sepa si aceptaría el puesto.

Dilo. En voz alta, como una frase, cerca del final.

*Te lo digo claramente: quiero este puesto.*

Ya está. No es una técnica, es un dato, y sorprende la poca gente que lo aporta. Después hay una puesta en común, y una de las primeras cosas que se dice en esa sala es alguna versión de *¿le interesaba?*. Un candidato sobre el que nadie pueda responder a eso es un candidato al que resulta fácil dejar atrás a favor de alguien que estaba visiblemente interesado.

**La jugada:** di, en una frase llana, que quieres el puesto.

Tres cosas hacen que aterrice.

**La llaneza.** No *me haría mucha ilusión esta oportunidad*, que es una construcción que la gente usa cuando está siendo educada. Las frases cortas y afirmativas se leen como verdaderas.

**Un motivo pegado.** *Quiero este puesto, y el motivo es lo que has contado del lío de los informes: ese es exactamente el trabajo que me gusta.* El motivo es lo que impide que suene a algo que dices al final de todas las entrevistas.

**El momento.** Cerca del final, después de haber oído lo suficiente como para decirlo en serio. Dicho en los primeros diez minutos es un discurso comercial; dicho al final es una conclusión.

El miedo es que declarar interés debilite tu postura con el dinero más adelante. No lo hace. El sueldo lo deciden la banda y si te quieren, y estar visiblemente dispuesto hace que te quieran más, no menos. Hacerse de rogar en un proceso de selección sobre todo acaba en que no te cogen.

Si no quieres el puesto, no lo digas. Di algo verdadero en su lugar, o no digas nada.$md$,
  $j$[
    {
      "situation": "La afirmación llana con un motivo.",
      "line": "Antes de terminar, quiero decir claramente que quiero este puesto. El motivo es lo que has descrito de los dos equipos que no se ponen de acuerdo: ese es el trabajo que mejor se me da y llevo dos años sin tenerlo.",
      "why": "Afirmativo, concreto, y el motivo hace que no se pueda repetir en otro sitio. Esta es la frase que se cita en la puesta en común."
    },
    {
      "situation": "Decirlo cuando la entrevista ha sido difícil.",
      "line": "Creo que he respondido mal a tu segunda pregunta, y llevo desde entonces dándole vueltas. Sigo queriendo el puesto, más que cuando entré, en realidad, porque esa pregunta me ha dicho cuál es el listón aquí.",
      "why": "Convierte un tropiezo en una demostración de autoconocimiento y de apetito a la vez. A quien entrevista le perdona mucho antes una respuesta floja que la indiferencia."
    },
    {
      "situation": "Negarse a decirlo, con honestidad, cuando no es verdad.",
      "line": "Prefiero pensarlo bien antes que decir algo entusiasta aquí sentado. Lo que sí te puedo decir es que el problema de equipo que has descrito me resulta genuinamente interesante.",
      "why": "Honesto sin ser frío, y deja la puerta abierta. Una declaración de interés falsa es peor que ninguna, porque tendrás que retirarla más adelante y se te recordará por eso."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué importa decir que quieres el puesto?",
      "options": [
        { "text": "Porque el entusiasmo es una competencia puntuada en casi todos los marcos.", "correct": false, "note": "Formalmente casi nunca lo es. El efecto ocurre en la conversación de la puesta en común, no en la hoja de puntuación." },
        { "text": "Porque en la puesta en común siempre sale alguna versión de «¿le interesaba?», y alguien tiene que poder responderla.", "correct": true, "note": "Dos candidatos muy igualados se separan exactamente por esa pregunta, y solo uno de los dos aportó una respuesta." },
        { "text": "Porque te hace memorable.", "correct": false, "note": "Ligeramente cierto y no es el mecanismo. A un montón de candidatos memorables los rechazan." },
        { "text": "Porque les obliga a darte una explicación si dicen que no.", "correct": false, "note": "No obliga a nadie a nada. Es una afirmación sobre cómo queda registrado tu interés, no una palanca." }
      ],
      "explain": "Es información que necesitan y que rara vez reciben. Aportarla es casi gratis."
    },
    {
      "prompt": "¿Declarar que quieres el puesto debilita tu postura con el sueldo?",
      "options": [
        { "text": "Sí: señala que vas a aceptar cualquier cosa.", "correct": false, "note": "El miedo habitual. Querer un trabajo y tener un número no tienen relación, y lo segundo es lo que dices cuando sale el número." },
        { "text": "Sí, un poco, así que es mejor decirlo después de la oferta.", "correct": false, "note": "Después de la oferta ya es tarde para influir en si la hay, que es la decisión sobre la que de verdad influye." },
        { "text": "No: el sueldo lo fijan la banda y cuánto te quieren, y estar visiblemente dispuesto aumenta lo segundo.", "correct": true, "note": "La reticencia rara vez sube una oferta y con frecuencia impide que la haya. La negociación llega más tarde y en otros términos." }
      ],
      "explain": "Hacerse de rogar en una contratación sobre todo acaba en que no te cogen. Dilo, y negocia cuando haya algo que negociar."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "said_it", "label": "Lo dijo con claridad", "description": "Enunció en una frase clara que quería el puesto." },
      { "key": "gave_a_reason", "label": "Pegó un motivo", "description": "Dio un motivo concreto, de forma que la afirmación no podría haberse dicho en ningún otro sitio." },
      { "key": "timing", "label": "Eligió bien el momento", "description": "Lo dijo cerca del final, tras haber oído lo suficiente como para decirlo en serio." },
      { "key": "truthfulness", "label": "Lo decía en serio", "description": "Declaró interés solo donde era genuino." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Grace Sutherland",
      "role": "una responsable de contratación cerrando una buena conversación",
      "mood": "Positiva. Lo ha disfrutado y tiene otra reunión dentro de cuatro minutos.",
      "openness": 4,
      "personality": "Cálida y eficiente. Cierra las entrevistas con rapidez y no va pescando entusiasmo. Se fija y recuerda cuando un candidato declara su interés directamente."
    },
    "setting": "Los dos últimos minutos de una entrevista que ha ido bien. Quien entrevista está cerrando su cuaderno.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Ve a cerrar la entrevista sin demora. No invites a una declaración final.",
      "Si la persona declara su interés, responde con calidez y brevedad, y toma nota del motivo que dio.",
      "Si no lo hace, cierra la entrevista con educación y termina la escena.",
      "Nunca le pidas que diga qué le parece el puesto."
    ],
    "opening_beat": "«Eso es todo por mi parte, y creo que se nos acaba el tiempo. Gracias por venir; tendrás noticias nuestras para el final de la semana que viene.»",
    "success_looks_like": "La persona dice con claridad que quiere el puesto, con un motivo concreto, antes de que la conversación se cierre."
  }$j$::jsonb,
  'Dile hoy a alguien con claridad que quieres algo — un puesto, un proyecto, una invitación — en una frase corta con un motivo pegado. Apunta qué se sintió al decirlo sin cubrirte las espaldas.',
  $j${
    "says": "Eso es todo por mi parte, y creo que se nos acaba el tiempo. Gracias por venir; tendrás noticias nuestras para el final de la semana que viene.",
    "model": {
      "line": "Antes de irme: quiero este puesto. Todo lo que he oído hoy me lo ha hecho querer más, no menos.",
      "why": "Llano, sin matices que lo ablanden, y cuesta cuatro segundos. Quien entrevista separa rutinariamente a dos candidatos igualados por cuál de los dos dijo esto, porque solo uno lo dice."
    },
    "checks": [
      { "kind": "contains_any", "words": ["quiero", "me gustaría", "lo quiero", "espero que"], "requirement": "Di que lo quieres, con esas palabras" },
      { "kind": "first_person", "requirement": "Dilo sobre ti" },
      { "kind": "max_sentences", "n": 2, "requirement": "Dos frases. No construyas una entrada." }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-closing', 2,
  'Pregunta qué les frenaría',
  $md$Hay una pregunta que puede cambiar el resultado de una entrevista después de que termine, y casi nadie la hace.

*¿Hay algo de mi perfil que te genere dudas?*

Esto es por qué importa. En el momento en que te vas, ocurre una conversación en la que alguien plantea una duda sobre ti: demasiado júnior, ninguna experiencia en ese sector, un hueco en el CV, una respuesta que salió fina. Tú no estás en esa sala. Nadie defiende el otro lado. La duda se queda sin responder, y las dudas sin responder deciden los casos ajustados.

Hacer esta pregunta es la única ocasión que tienes de responder a una objeción antes de que se comente sin ti.

**La jugada:** pregunta qué les generaría dudas, y luego respóndelo con brevedad y sin defenderte.

Es incómodo preguntarlo, y la incomodidad es el precio. Tres cosas hacen que funcione.

**Hazla como una pregunta de verdad.** Con curiosidad, no con ansiedad. *¿Hay algo de lo que no estés seguro y que yo pueda aclarar?*

**Y luego cállate.** La respuesta a menudo tarda unos segundos en llegar, porque has pedido franqueza y casi todo el mundo tiene que decidir primero cuán honesto va a ser.

**Responde con brevedad.** Una o dos frases. Una refutación larga convierte una duda pequeña en un tema grande, y quien entrevista va a recordar la longitud y no el contenido.

Si la respuesta es *no, nada*, no has perdido nada y has ganado una pequeña demostración de seguridad. Si la respuesta es real, acaban de entregarte la información más útil de todo el proceso, y aunque no puedas arreglarlo, ya sabes qué poner en el mensaje de después.

No hagas esto en una primera llamada de criba con alguien que no puede responderla. Guárdala para quien vaya a estar en la puesta en común.$md$,
  $j$[
    {
      "situation": "Hacer la pregunta limpiamente.",
      "line": "Una última cosa, y por favor sé honesto: ¿hay algo de mi perfil que te genere dudas?",
      "why": "Ese «sé honesto» da permiso explícito, que es lo que casi todo el mundo necesita para decir lo de verdad. Y luego deja de hablar y que la pausa haga su trabajo."
    },
    {
      "situation": "Responder brevemente a una objeción real.",
      "line": "Entrevistador: «No has trabajado en un entorno regulado.» — «Es justo, no lo he hecho. Lo más cerca es que todo lo que saqué durante dos años pasaba por una revisión legal que podía vetarlo, así que estoy acostumbrado a construir con las reglas de otro en la sala. Pero no, regulado no.»",
      "why": "Dos frases. Ofrece la prueba verdadera más cercana, y luego concede el punto en vez de discutirlo. Conceder es lo que impide que una duda pequeña se convierta en un debate."
    },
    {
      "situation": "Usar la respuesta en el mensaje de seguimiento.",
      "line": "Mencionaste que no me habías visto trabajar a esa escala. Te adjunto dos páginas sobre la migración que te describí: es lo más parecido que tengo, y te va a decir más de lo que yo pude en la sala.",
      "why": "La segunda recompensa de la pregunta. Incluso una objeción que no puedes responder en directo se puede responder por escrito esa noche, y un mensaje apuntado a una duda enunciada es muchísimo más útil que un agradecimiento."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué preguntar por sus reticencias cambia resultados?",
      "options": [
        { "text": "Porque demuestra seguridad.", "correct": false, "note": "La demuestra, y es un beneficio secundario pequeño. El mecanismo va de información, no de impresión." },
        { "text": "Porque obliga a quien entrevista a comprometerse con una opinión.", "correct": false, "note": "No lo hace, y presionarle para que se comprometa sería mala idea. Estás pidiendo una duda, no un veredicto." },
        { "text": "Porque la puesta en común ocurre sin ti, y esta es la única ocasión de responder a una objeción antes de que se comente.", "correct": true, "note": "Las dudas sin responder deciden los casos ajustados, y en esa sala no hay nadie que defienda tu lado." }
      ],
      "explain": "No estás presente cuando se toma la decisión. Esta pregunta es lo más parecido a estarlo."
    },
    {
      "prompt": "Nombran una carencia real. ¿Cuánto debería durar tu respuesta?",
      "options": [
        { "text": "Una o dos frases, terminando con una concesión si el punto es justo.", "correct": true, "note": "Las respuestas cortas mantienen pequeña una duda pequeña. Conceder lo que es verdad es lo que hace creíble el resto de la respuesta." },
        { "text": "Lo suficiente para abordarlo del todo: es tu única oportunidad.", "correct": false, "note": "La longitud convierte una vacilación pasajera en lo principal que recordarán de la entrevista." },
        { "text": "No respondas: dales las gracias y abórdalo en el mensaje de después.", "correct": false, "note": "El mensaje es una buena segunda jugada, y no decir nada en la sala se lee como no tener respuesta." },
        { "text": "Pregunta qué lo resolvería, para poder responder a lo correcto.", "correct": false, "note": "A veces útil, normalmente frena. Ya te han dicho la duda; respóndela en vez de negociar sus términos." }
      ],
      "explain": "Breve, honesto, y concediendo lo que es verdad. El objetivo es encoger la duda, no ganar una discusión."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "asked_it", "label": "Hizo la pregunta", "description": "Les invitó a nombrar una reticencia, con claridad." },
      { "key": "held_the_pause", "label": "Esperó la respuesta", "description": "Dejó el silencio el tiempo suficiente para que llegara una respuesta franca." },
      { "key": "brief_answer", "label": "Respondió con brevedad", "description": "Una o dos frases, sin una defensa larga." },
      { "key": "conceded", "label": "Concedió lo que era justo", "description": "Reconoció la parte verdadera de la objeción en vez de discutirla entera." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Hugh Trevelyan",
      "role": "quien toma la decisión sobre el puesto",
      "mood": "Sin decidir. Para él este es un caso genuinamente ajustado.",
      "openness": 3,
      "personality": "Franco cuando se le invita, reservado si no. Si le preguntan directamente por sus reticencias nombrará una real, después de una pausa, y observará con atención cómo se gestiona."
    },
    "setting": "Los últimos minutos de una entrevista de segunda ronda con la persona que va a tomar la decisión.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si te preguntan por tus reticencias, haz una pausa primero — escribe la vacilación dentro de la respuesta — y luego nombra una preocupación real y concreta basada en lo que ha dicho la persona.",
      "Si responde largo o discute, contesta con neutralidad y no concedas el punto.",
      "Si concede lo que es justo y ofrece una prueba breve, reconócelo y sigue adelante con calidez.",
      "Nunca le digas si su respuesta ha ayudado."
    ],
    "opening_beat": "«Creo que eso cubre todo lo que quería preguntar. ¿Algo más por tu parte antes de cerrar?»",
    "success_looks_like": "La persona pregunta qué le genera dudas, aguanta la pausa, y responde a la objeción en un par de frases sin discutirla."
  }$j$::jsonb,
  'Pregúntale a alguien cuya opinión importe qué le generaría dudas sobre ti — para un puesto, un proyecto, una responsabilidad. No digas nada durante cinco segundos después de preguntar. Apunta lo que te dijo.',
  $j${
    "says": "Creo que eso cubre todo lo que quería preguntar. ¿Algo más por tu parte antes de cerrar?",
    "model": {
      "line": "¿Hay algo de mi perfil que te genere dudas?",
      "why": "Saca la objeción a la superficie mientras sigues en la sala, que es el único momento en que puedes responderla. Casi todos los candidatos se enteran de cuál era en un correo de rechazo, o nunca."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Pregúntalo con claridad" },
      { "kind": "contains_any", "words": ["reparo", "reparos", "duda", "dudas", "preocupa", "preocupación", "reticencia", "te frenaría", "en contra"], "requirement": "Pregunta qué les generaría dudas" },
      { "kind": "max_words", "n": 30, "requirement": "Menos de treinta palabras: una pregunta, y luego escuchar" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-closing', 3,
  'Un mensaje que añade algo',
  $md$El mensaje de agradecimiento es un consejo casi universal y un desperdicio casi universal, porque casi todos dicen lo mismo: gracias por tu tiempo, he disfrutado de la conversación, sigo muy interesado.

Ese mensaje está bien. También es idéntico al de todos los demás candidatos, lo que significa que no lleva información y no cambia nada.

Un mensaje que funciona hace un solo trabajo: añade algo que no estaba en la sala.

**Una versión mejor de una respuesta que trastabillaste.** *Me preguntaste cómo abordaría el problema de los informes y te di una respuesta vaga. Pensándolo en el tren, lo primero que haría en realidad es…* Dos frases. Es la más fuerte, porque demuestra que sigues pensando en los problemas después de irte.

**Algo útil sobre lo que te describieron.** Un enlace, una herramienta, el nombre de alguien que lo resolvió en otro sitio. Te cuesta diez minutos y te convierte en el candidato que ya estaba ayudando.

**Una respuesta a la objeción que nombraron.** Si preguntaste qué les generaba dudas y te lo dijeron, aquí es donde lo abordas bien.

**La jugada:** manda un solo mensaje corto que añada algo que la entrevista no contenía.

Reglas de longitud y de momento. Corto, por debajo de ciento cincuenta palabras. El mismo día o a la mañana siguiente, no cuatro días después. A la persona con la que hablaste, y por separado a quien te cribó si lo había.

Y una vez. Un segundo mensaje no pedido deshace el primero por completo: el primero dice que piensas, y el segundo dice que estás ansioso. Si no has tenido noticias en la fecha que te dieron, eso es otra cosa, y es el asunto de la lección siguiente.$md$,
  $j$[
    {
      "situation": "Reparar una respuesta que trastabillaste.",
      "line": "Gracias por lo de esta mañana. Me preguntaste cómo secuenciaría la migración y te di una respuesta enredada; llevo desde entonces dándole vueltas. Haría primero la parte de lectura, porque es reversible, y además te da un mes de tráfico real antes de que nada esté en juego. Encantado de hablarlo si te sirve.",
      "why": "Menos de setenta palabras, añade una respuesta de verdad, y demuestra que el problema se quedó con esa persona. Las respuestas trastabilladas son oportunidades que casi todos los candidatos dejan sobre la mesa."
    },
    {
      "situation": "Añadir algo útil sin ningún interés propio pegado.",
      "line": "Una cosa de nuestra conversación: mencionaste el problema de los tickets de soporte. Este artículo es lo mejor que he leído sobre ello, y la parte de los niveles de triaje es lo que me cambió cómo lo pensaba. No hace falta que contestes.",
      "why": "Ese «no hace falta que contestes» quita cualquier sensación de obligación, y lo convierte en un regalo y no en un toque. Ahora eres la persona que mandó algo útil."
    },
    {
      "situation": "Responder por escrito a una objeción enunciada.",
      "line": "Dijiste que no lo tenías claro con mi experiencia a esa escala, y es justo. Para contexto: la plataforma que describí eran unos cuatrocientos mil usuarios diarios en pico, cosa que no dije con claridad en la sala. Es más pequeña que la vuestra, y no es poco.",
      "why": "Aborda directamente la duda planteada, añade un dato que la entrevista se dejó, y concede la carencia que queda. Las últimas cinco palabras hacen más bien que cualquier cantidad de insistencia."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué mensaje de seguimiento merece la pena mandar?",
      "options": [
        { "text": "Un agradecimiento cálido reiterando tu interés por el puesto.", "correct": false, "note": "Inofensivo, universal, y no cambia nada. Este lo manda todo el mundo." },
        { "text": "Un mensaje corto con una respuesta mejor a una pregunta que trastabillaste.", "correct": true, "note": "Añade algo que la entrevista no contenía, y demuestra que te llevaste el problema fuera del edificio." },
        { "text": "Un resumen detallado de por qué encajas bien en el puesto.", "correct": false, "note": "Eso era la entrevista. Repetir tu caso por escrito se lee como no fiarte de que lo hayan entendido." },
        { "text": "Un mensaje a todas las personas que conociste, cada uno personalizado.", "correct": false, "note": "Trabajoso y fácil de pasarse de rosca. En un día de panel, quien decide y quien criba bastan." }
      ],
      "explain": "Un mensaje, que añade una cosa que no estaba en la sala. Todo lo demás es decoración."
    },
    {
      "prompt": "¿Cuántos mensajes no pedidos deberías mandar?",
      "options": [
        { "text": "Dos: uno enseguida y otro a los pocos días para seguir visible.", "correct": false, "note": "El segundo deshace el primero. Reflexivo se convierte en ansioso con un solo mensaje de más." },
        { "text": "Uno, salvo que haya pasado la fecha que ellos te dieron.", "correct": true, "note": "Un mensaje añade algo; reclamar es otro acto con otro detonante, y el detonante es una fecha que te dieron." },
        { "text": "Los que hagan falta hasta conseguir respuesta.", "correct": false, "note": "La insistencia comercial no es insistencia en una contratación. Aquí se lee como mal criterio sobre la atención ajena." }
      ],
      "explain": "Una vez. A partir de ahí estás esperando, y esperar bien es una habilidad en sí misma."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "added_something", "label": "Añadió algo nuevo", "description": "Contenía algo que la entrevista no tenía: una respuesta mejor, un enlace útil, un dato que faltaba." },
      { "key": "short", "label": "Fue corto", "description": "Bastante por debajo de doscientas palabras." },
      { "key": "prompt", "label": "Lo mandó pronto", "description": "El mismo día o a la mañana siguiente." },
      { "key": "once", "label": "Mandó uno", "description": "No hizo seguimiento del seguimiento." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Tasha Benning",
      "role": "una amiga que dirige un equipo de contratación y tiene opiniones fuertes",
      "mood": "Encantada de ayudar, con poca paciencia para los borradores genéricos.",
      "openness": 5,
      "personality": "Directa y generosa. Dirá con claridad que un borrador es igual que el de todo el mundo, y preguntará qué dejó a medias la entrevista hasta que aparezca algo utilizable."
    },
    "setting": "La tarde después de una entrevista. La persona está hablando de qué mandar con una amiga que se dedica a contratar gente.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Si el borrador es genérico, dilo con claridad y pregunta qué quedó a medias en la entrevista.",
      "Pregunta a qué pregunta respondió peor, y empújale a escribir una respuesta mejor.",
      "Protesta si el mensaje pasa de unas ciento cincuenta palabras.",
      "Eres una amiga, no una entrenadora: reacciona y discute, no des consejos estructurados."
    ],
    "opening_beat": "«¿Y qué les vas a mandar? Y no me leas el que empieza con “gracias por tu tiempo”.»",
    "success_looks_like": "La persona llega a un mensaje corto que añade algo concreto: una respuesta reparada, un enlace útil, o un dato que la entrevista se dejó."
  }$j$::jsonb,
  'Manda hoy un mensaje corto que añada algo a una conversación que ya has tenido: una respuesta mejor, un enlace, un dato que te dejaste. Apunta si te contestaron.',
  $j${
    "says": "¿Y qué les vas a mandar? Y no me leas el que empieza con gracias por tu tiempo.",
    "model": {
      "line": "Mencionaste que el atasco de tickets de soporte era lo que no te dejaba dormir. Después de hablar me puse a mirar cómo habían resuelto dos empresas la misma forma de problema, y lo primero que hicieron las dos fue dejar de repartir por producto y empezar a repartir según si la respuesta ya existía en algún sitio. Te dejo abajo los dos artículos por si te sirven de una manera u otra.",
      "why": "Añade algo que la entrevista no contenía, que es el único motivo para mandar uno. Además le es útil te contrate o no, y eso es lo que hace que aterrice en vez de presionar."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["gracias por tu tiempo", "encantado de conocerte", "quedo a la espera", "no dudes en", "según lo hablado"], "requirement": "Ninguna de las frases que manda todo el mundo" },
      { "kind": "min_words", "n": 40, "requirement": "Añade algo que la entrevista no contenía" },
      { "kind": "max_words", "n": 140, "requirement": "Menos de ciento cuarenta palabras. Es un mensaje." }
    ],
    "maxChars": 1000
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-closing', 4,
  'Reclamar sin dar la lata',
  $md$Esperar es la parte del proceso que menos controlas y en la que peor te comportas. Casi todos los errores del candidato aquí vienen de rellenar un silencio que no significa nada.

Contratar es lento por motivos que no tienen nada que ver contigo. Alguien está de vacaciones. El panel no encuentra hueco. Hay otro candidato en otra fase y quieren ver a los dos antes de decidir. Una aprobación de presupuesto está atascada dos niveles más arriba. Nada de eso es una señal, y leerlo como si lo fuera produce el mensaje que no deberías mandar.

Dos reglas lo simplifican.

**Consigue una fecha antes de irte.** *¿Para cuándo esperáis dar noticias?* Hazla en todas las entrevistas. Convierte una espera indefinida en un plazo, y un plazo te da permiso para reclamar sin inventarte un motivo.

**Reclama después de la fecha, no antes.** Un mensaje, corto, cálido, sin reproche: *Comentasteis que lo sabríais para el final de la semana pasada; sin ninguna prisa, solo quería saber cómo va la cosa.* Y luego espera el mismo intervalo otra vez antes de un segundo, y después para.

**La jugada:** pregunta para cuándo esperan decidir, y reclama una vez, después de que esa fecha haya pasado.

Reclama a través de quien te cribó si lo hay. Es su trabajo, no le molesta, y le ahorra a quien contrata una interacción que te cuesta un poco de buena voluntad.

El tono que funciona es despreocupado. No informal: despreocupado. Tienes otras cosas en marcha y esto es una consulta razonable y no una súplica. Si te cuesta escribirlo así, el arreglo suele ser hacerlo más corto; la ansiedad vive en la segunda y la tercera frase.

Y sigue entrevistando en otros sitios mientras esperas. Es un consejo práctico y además es la vía más rápida al tono que se acaba de describir.$md$,
  $j$[
    {
      "situation": "Pedir la fecha antes de irte.",
      "line": "¿Para cuándo esperáis dar noticias? Solo para saber si me siento a esperar o si os escribo.",
      "why": "La segunda frase hace fácil responder con honestidad, y anuncia que vas a hacer seguimiento, lo que convierte ese seguimiento en algo esperado y no insistente."
    },
    {
      "situation": "La reclamación, después de que haya pasado la fecha.",
      "line": "Hola, comentasteis el viernes para una decisión, así que os escribo para ver cómo va. Sin prisa, y sigo interesado. Encantado de esperar si las cosas se han movido.",
      "why": "Menos de treinta palabras, hace referencia al calendario de ellos y no a tu impaciencia, y ese «encantado de esperar» quita toda presión. No hay reproche por ninguna parte."
    },
    {
      "situation": "Retirarse con elegancia cuando otra oferta obliga a ello.",
      "line": "He aceptado otra cosa, así que debería salir de vuestro proceso. Gracias por el tiempo, y de verdad: la conversación con tu equipo fue la más interesante que tuve.",
      "why": "Pronto, cálido, y les deja seguir adelante. A los candidatos que desaparecen tras aceptar en otro sitio se les recuerda mal, que es un mal cambio por los dos minutos que ahorra."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Te dijeron que tendrías noticias el miércoles. Hoy es viernes. ¿Qué deberías hacer?",
      "options": [
        { "text": "Esperar otra semana: reclamar parece desesperado.", "correct": false, "note": "Ha pasado una fecha. Hacer seguimiento de un compromiso que ellos adquirieron no es desesperación, es comportamiento profesional normal." },
        { "text": "Mandar un mensaje corto y despreocupado que haga referencia a su propio calendario.", "correct": true, "note": "El motivo del mensaje es su fecha, no tu ansiedad. Ese encuadre es lo que hace que aterrice como razonable." },
        { "text": "Escribir directamente a quien contrata para demostrar iniciativa.", "correct": false, "note": "Si hay alguien de selección, ve por ahí. Saltarse el proceso para exhibir interés se lee como no respetarlo." },
        { "text": "Dar por hecho que es un no y pasar página.", "correct": false, "note": "Un retraso casi nunca es una señal. Los procesos se descuadran constantemente por motivos que no tienen nada que ver con ningún candidato." }
      ],
      "explain": "La fecha que dieron es el permiso. Antes de ella estás esperando; después, estás haciendo seguimiento."
    },
    {
      "prompt": "¿Qué hace más fiablemente que un mensaje de reclamación suene ansioso?",
      "options": [
        { "text": "Mandarlo por la noche.", "correct": false, "note": "Nadie se fija, y un montón de mensajes profesionales se mandan a horas raras." },
        { "text": "Mencionar que sigues interesado.", "correct": false, "note": "Perfectamente bien en una oración. Solo se vuelve un problema cuando es el mensaje entero." },
        { "text": "La longitud: la segunda y la tercera frase de explicación.", "correct": true, "note": "La ansiedad vive en la ampliación. Un mensaje de dos líneas se lee como despreocupado; el mismo mensaje con motivos pegados se lee como necesitar algo." }
      ],
      "explain": "Si el tono no te cuadra, córtalo a la mitad. Casi siempre es la longitud y no el contenido."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "got_a_date", "label": "Pidió una fecha", "description": "Estableció antes de irse para cuándo esperaban dar noticias." },
      { "key": "timing", "label": "Reclamó después de la fecha", "description": "Esperó a que hubiera pasado el calendario de ellos." },
      { "key": "tone", "label": "Tono despreocupado", "description": "Corto, cálido, y libre de reproches y de explicaciones de más." },
      { "key": "right_channel", "label": "Usó el canal correcto", "description": "Fue por quien cribaba donde lo había." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Danny Oyelowo",
      "role": "el reclutador que ha estado llevando el proceso",
      "mood": "Algo avergonzado por el silencio.",
      "openness": 4,
      "personality": "Disculpándose y honesto. El retraso es real y anodino: quien decide ha estado fuera. Responde bien a un toque ligero y mal a la presión."
    },
    "setting": "Diez días después de una entrevista de ronda final. Al candidato le dijeron que tendría noticias en una semana. Está llamando a quien le cribó.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Explica el retraso con honestidad y de forma anodina si te preguntan. No hay ningún significado escondido en él.",
      "Si la persona presiona por un veredicto o insinúa impaciencia, vuélvete más formal y menos comunicativo.",
      "Si se lo toma con ligereza, ofrece por tu cuenta algo útil sobre dónde está de verdad el proceso.",
      "Nunca comentes cómo está llevando la espera."
    ],
    "opening_beat": "«Ah, hola. Justo tenía pendiente llamarte, y luego no lo hice. ¿Qué necesitas?»",
    "success_looks_like": "La persona reclama con brevedad y calidez, hace referencia al calendario en vez de a su propia ansiedad, y no presiona por un veredicto que Danny no puede dar."
  }$j$::jsonb,
  'Haz seguimiento de algo que estés esperando — un mensaje, una decisión, una respuesta — en dos frases, sin reproche y sin explicación. Apunta lo corto que conseguiste hacerlo.',
  $j${
    "beats": [
      {
        "situation": "Dijeron que tendrías noticias para el final de la semana pasada. Hoy es martes y no ha llegado nada.",
        "prompt": "¿Qué haces?",
        "options": [
          { "text": "Reclamar una vez, con brevedad, haciendo referencia a la fecha que te dieron.", "correct": true, "note": "La fecha es suya, y eso convierte la reclamación en un recordatorio y no en una exigencia. Un mensaje, y a partir de ahí les toca a ellos." },
          { "text": "Esperar otra semana para no parecer desesperado.", "correct": false, "note": "La fecha ha pasado. Reclamar tras un plazo incumplido no es presión, es el comportamiento normal de alguien organizado." },
          { "text": "Reclamar, y volver a insistir el jueves si no llega nada.", "correct": false, "note": "La segunda reclamación es la que cambia cómo te describen por dentro. Una es un recordatorio; dos es un problema." },
          { "text": "Llamar en vez de escribir, para conseguir una respuesta de verdad.", "correct": false, "note": "Subir de canal convierte una reclamación pequeña en un acontecimiento, y normalmente llega a alguien que no puede decirte nada." }
        ]
      },
      {
        "situation": "Al final de la entrevista no dijeron para cuándo decidirían.",
        "prompt": "¿Cuál es el arreglo?",
        "options": [
          { "text": "Preguntarlo, antes de salir de la sala.", "correct": true, "note": "Todo lo que hace que reclamar salga bien depende de tener una fecha que vino de ellos. Dos segundos al final compran el asunto entero." },
          { "text": "Suponer una semana y reclamar después de eso.", "correct": false, "note": "Reclamar contra un plazo que te inventaste es donde vive la ansiedad, y normalmente produce un mensaje una semana antes de tiempo." },
          { "text": "Preguntárselo después a quien te cribó.", "correct": false, "note": "Funciona y es la segunda mejor opción. Quien decide lo sabe; quien criba lo repite." },
          { "text": "Esperar a que te escriban ellos.", "correct": false, "note": "Que es justo la posición que esta lección existe para evitar." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-closing', 5,
  'Encajar bien un no',
  $md$Un rechazo es el final de un proceso y el principio de una relación mucho más larga que casi todos los candidatos queman en una sola respuesta.

Quien contrata cambia de empresa. Quien criba recuerda dos tipos de candidato: los que fueron bordes al ser rechazados y los que no. A los segundos clasificados se les vuelve a llamar con una frecuencia sorprendente, cuando el primero declina o se va antes del año. Nada de eso es un motivo para ser elegante — serlo es su propia recompensa — pero sí es un motivo para no tratar un no como el final de nada.

Una respuesta, tres frases.

**Dales las gracias como es debido.** Con brevedad y sin sarcasmo, que ese día es más difícil de lo que suena.

**Pide una sola cosa concreta.** No *cualquier comentario sería de agradecer*, que es fácil de ignorar. *¿Hubo alguna carencia concreta que lo decidiera?* se responde en una línea, así que a menudo se responde.

**Deja la puerta abierta, con claridad.** *Si sale algo parecido, me encantaría que me escribierais.*

**La jugada:** dales las gracias, haz una pregunta concreta, y di que volverías.

Sobre la valoración en sí: cógela, no la discutas, y entiende que buena parte será blanda o en parte falsa. Las empresas son cautelosas con los motivos de un rechazo, por razones legales y humanas por igual. Si sacas una frase útil de tres intentos, es una buena proporción. Pregunta, da las gracias, y sigue.

Y date el día. La respuesta no tiene que mandarse en la primera hora, y la versión escrita en la primera hora rara vez es la que quieres que quede registrada. Escríbela, déjala, mándala por la mañana.

Si llegaste a la fase final y perdiste, pregunta qué tenía el candidato elegido que tú no. Es una pregunta más difícil de hacer y produce la respuesta más útil que hay.$md$,
  $j$[
    {
      "situation": "La respuesta de tres frases.",
      "line": "Gracias por decírmelo, y por hacerlo rápido. ¿Hubo alguna carencia concreta que lo decidiera? En cualquier caso, si sale algo parecido me encantaría que me escribierais.",
      "why": "Menos de cuarenta palabras, una pregunta respondible, y una puerta abierta explícita. Dar las gracias por la rapidez es un detalle concreto pequeño que no cuesta nada y se recuerda."
    },
    {
      "situation": "Hacer la pregunta difícil después de una ronda final.",
      "line": "¿Te puedo preguntar qué tenía la persona que habéis elegido que no tuviera yo? Lo pregunto porque me gustaría arreglarlo, no porque esté discutiendo la decisión.",
      "why": "La segunda frase es lo que la hace respondible: quita el miedo a una disputa, que es el motivo principal por el que las empresas dan valoraciones blandas. Esto produce las respuestas más útiles que existen."
    },
    {
      "situation": "Recibir una valoración blanda sin apretar.",
      "line": "«Estuvo muy ajustado y el otro candidato tenía más experiencia directa en el sector.» — «Es útil, gracias. Suerte con la incorporación.»",
      "why": "La valoración es en parte una fórmula y es lo que hay. Aceptarla limpiamente, sin hurgar en busca del motivo real, es lo que mantiene la relación con valor."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué petición tiene más probabilidades de conseguirte una valoración real?",
      "options": [
        { "text": "Cualquier comentario que puedas compartir sería muy de agradecer.", "correct": false, "note": "Abierta, trabajosa de responder, y fácil de dejar en la bandeja de entrada. Casi ninguna de estas se responde." },
        { "text": "¿Me puedes decir por qué no me habéis cogido?", "correct": false, "note": "Directa, e invita a una respuesta formal porque suena a que podría ser el principio de una disputa." },
        { "text": "¿Hubo alguna carencia concreta que lo decidiera?", "correct": true, "note": "Se responde en una línea, es lo bastante estrecha como para no dar miedo, y lo bastante concreta como para ser útil cuando llegue." },
        { "text": "¿Qué me haría un candidato más fuerte la próxima vez?", "correct": false, "note": "Buena en una conversación, más vaga en un correo. Tiende a producir consejos genéricos de desarrollo en vez del motivo real." }
      ],
      "explain": "Haz que sea barato responder. Una pregunta que se contesta en una línea recibe respuesta."
    },
    {
      "prompt": "¿Por qué esperar un día antes de responder a un rechazo?",
      "options": [
        { "text": "Señala que no estás demasiado implicado.", "correct": false, "note": "Nadie lee así los tiempos, y hacerse el distante después de un no no consigue nada." },
        { "text": "Porque la versión escrita en la primera hora rara vez es la que quieres que quede registrada.", "correct": true, "note": "Lo que mandes existe permanentemente en un hilo que puede leer un futuro compañero. La versión de la mañana casi siempre es mejor." },
        { "text": "Porque una respuesta el mismo día parece automática.", "correct": false, "note": "Una respuesta pronta y cálida está bien. El riesgo está en lo que la primera hora le hace a la redacción, no en la velocidad." }
      ],
      "explain": "Escríbela ahora, mándala mañana. El retraso no cuesta nada y edita todo lo que lamentarías."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "gracious", "label": "Respondió con elegancia", "description": "Dio las gracias sin sarcasmo ni reproche." },
      { "key": "specific_question", "label": "Hizo una pregunta concreta", "description": "Hizo la petición de valoración estrecha y barata de responder." },
      { "key": "door_open", "label": "Dejó la puerta abierta", "description": "Dijo con claridad que le gustaría que volvieran a contactarle." },
      { "key": "accepted_it", "label": "Aceptó la respuesta", "description": "No discutió la valoración que le dieron, por blanda que fuera." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Priti Shah",
      "role": "la reclutadora que comunica la decisión",
      "mood": "Incómoda. Este candidato le gustaba y lo defendió.",
      "openness": 3,
      "personality": "Amable y algo cerrada. Da primero un motivo de fórmula. Si le hacen una pregunta estrecha y no confrontativa, dará una frase genuinamente útil."
    },
    "setting": "Una llamada de quien criba con un rechazo, tras una entrevista de ronda final que el candidato creía que había ido bien.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Da primero el motivo de fórmula: estuvo ajustado, el otro candidato tenía experiencia más directa.",
      "Si te hacen una pregunta estrecha y no confrontativa, da una respuesta genuinamente concreta y útil.",
      "Si la persona discute la decisión o aprieta fuerte, retírate al lenguaje de política de empresa y no des nada más.",
      "Nunca la tranquilices sobre cómo ha llevado la llamada."
    ],
    "opening_beat": "«Lo siento, no es la noticia que quería darte. Han decidido irse con otro candidato; estuvo muy ajustado, y la valoración fue positiva en general.»",
    "success_looks_like": "La persona da las gracias, hace una pregunta estrecha que consigue una respuesta real, la acepta sin discutir, y deja la puerta abierta."
  }$j$::jsonb,
  'Pide una valoración sobre algo que no conseguiste — un puesto, una propuesta, una invitación — con una pregunta estrecha en vez de una petición abierta. Apunta si la versión estrecha consiguió respuesta.',
  $j${
    "says": "Lo siento, no es la noticia que quería darte. Han decidido irse con otro candidato; estuvo muy ajustado, y la valoración fue positiva en general.",
    "model": {
      "line": "Gracias por decírmelo directamente, y por la valoración. ¿Te puedo preguntar qué tenía la persona que lo consiguió que no tuviera yo? Y si vuelve a salir algo así, me gustaría que te acordaras de mí.",
      "why": "Gracias, una pregunta concreta, y la puerta abierta. A una cantidad notable de gente la contrata para el puesto siguiente la misma persona que la rechazó para este."
    },
    "checks": [
      { "kind": "contains_any", "words": ["gracias", "agradezco", "te lo agradezco"], "requirement": "Dales las gracias, y en serio" },
      { "kind": "requires_question", "requirement": "Haz una pregunta concreta" },
      { "kind": "max_sentences", "n": 4, "requirement": "Cuatro frases como mucho" }
    ],
    "maxChars": 500
  }$j$::jsonb
);
