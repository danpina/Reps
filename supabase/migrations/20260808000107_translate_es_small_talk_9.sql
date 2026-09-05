-- Spanish: Small talk, track 8 — Grupos: entrar y tener turno.
--
-- Completes the topic. Forty lessons, eight tracks, in Spanish.
--
-- One check needed rebuilding around a grammatical difference rather than a
-- vocabulary one. Lesson 5 wants a question the quiet person can definitely
-- answer, and the English list is built from tag questions — "did you",
-- "didn't you", "weren't you". Spanish does not inflect the tag: it uses a
-- single invariable "¿verdad?" or "¿no?" hung off a statement. So the Spanish
-- list is built from the *verb* forms that make a question answerable —
-- hiciste, estuviste, fuiste, tuviste — plus "verdad" for the tag itself.
--
-- "no" is deliberately not in that list even though "¿no?" is the commonest
-- Spanish tag. The checker matches tokens under four characters whole, so
-- "no" would match the word no anywhere in the sentence, including inside a
-- refusal, and the check would pass on almost anything.
--
-- Lessons 1 and 3 are scene mode and carry no rehearsal spec.

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
    title = excluded.title, theory_md = excluded.theory_md,
    examples_json = excluded.examples_json, checks_json = excluded.checks_json,
    rubric_json = excluded.rubric_json, scenario_json = excluded.scenario_json,
    mission_text = excluded.mission_text, rehearsal_spec = excluded.rehearsal_spec,
    updated_at = now();
$fn$;

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('groups', 1,
  'Primero quédate ahí',
  $md$Entrar en un grupo es sobre todo un problema físico, y la gente intenta resolverlo hablando.

El fallo habitual es acercarse a un círculo y decir algo. Todos paran, se giran, y ahora cuatro personas esperan que tu aportación justifique la interrupción. Rara vez lo hace, porque no tienes ni idea de qué estaban hablando.

**La jugada:** únete al grupo físicamente, escucha, y no digas absolutamente nada durante un rato.

Ponte en el borde, orientado hacia dentro, lo bastante cerca como para formar parte del círculo y no rondarlo por detrás. Los grupos casi siempre se abren para hacer sitio, porque ese reflejo está muy metido. Ya estás dentro, y no le has pedido nada a nadie.

Después escucha hasta que sepas cuál es la conversación de verdad. Treinta segundos suelen bastar, y son treinta segundos que te compran el derecho a decir algo relevante en vez de algo que reinicia el tema.

A nadie le molesta una persona callada en un grupo. A todo el mundo le molesta una interrupción.$md$,
  $j$[
    {
      "situation": "Cuatro personas están a mitad de conversación y conoces a una.",
      "line": "(entra en el círculo al lado de quien conoces y mira a quien esté hablando)",
      "why": "Entrada física sin ninguna exigencia verbal. Mirar a quien habla en vez de a tu conocido te marca como parte del público y no como visita."
    },
    {
      "situation": "Llevas treinta segundos en el círculo y ya entiendes el tema.",
      "line": "(todavía nada — espera un hueco natural)",
      "why": "Estar en el grupo ya es un éxito. El hueco va a llegar, y llegar dentro de él es mucho mejor que fabricar uno."
    },
    {
      "situation": "Alguien del grupo te mira un segundo al entrar.",
      "line": "(gesto pequeño, y sigue escuchando)",
      "why": "Les reconoce sin convertirlo en una presentación que pare la conversación. Un gesto no le cuesta nada al grupo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Quieres unirte a un grupo de cuatro que está a mitad de conversación. ¿Qué haces primero?",
      "options": [
        { "text": "Presentarte a quien tengas más cerca.", "correct": false, "note": "Empieza una segunda conversación dentro de la primera, lo que obliga a esa persona a elegir entre tú y el grupo." },
        { "text": "Esperar a que terminen y acercarte entonces.", "correct": false, "note": "Las conversaciones de grupo no terminan, cambian de tema. Vas a esperar mucho rato, y rondando mientras." },
        { "text": "Entrar en el círculo, escuchar, y no decir nada durante un rato.", "correct": true, "note": "La entrada física no le pide nada a nadie, y los grupos hacen sitio por reflejo. Escuchar primero hace que tu aportación llegue siendo relevante." },
        { "text": "Hacer un comentario sobre el sitio para anunciarte.", "correct": false, "note": "Para la conversación y obliga a cuatro personas a evaluar tu comienzo. Esta es la versión que resulta más incómoda para todos." }
      ],
      "explain": "Únete con los pies, no con la voz. Los grupos se abren solos, y treinta segundos de escucha te compran algo relevante que decir."
    },
    {
      "prompt": "Entras en un círculo y nadie te saluda. ¿Qué significa eso?",
      "options": [
        { "text": "No te quieren ahí.", "correct": false, "note": "Casi nunca. Un grupo a mitad de historia está absorto, no hostil." },
        { "text": "Deberías decir algo para anunciarte.", "correct": false, "note": "Este es el error que esta lección existe para evitar." },
        { "text": "Te has puesto en el sitio equivocado.", "correct": false, "note": "Si estás en el círculo y nadie se ha movido para cerrarlo, la posición estaba bien." },
        { "text": "Está funcionando. Estás en el grupo.", "correct": true, "note": "Que no haya reacción es el objetivo. Que te absorban sin ceremonia es exactamente lo que parece entrar bien." }
      ],
      "explain": "Un grupo que sigue como si hubieras estado ahí siempre te ha aceptado. Que te saludaran significaría que has interrumpido."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "physical_entry", "label": "Entraste primero físicamente", "description": "Te metiste en el círculo en vez de anunciarte de palabra." },
      { "key": "listened_first", "label": "Escuchaste antes de hablar", "description": "Esperaste lo suficiente para entender cuál era la conversación de verdad." },
      { "key": "no_interruption", "label": "No paraste la conversación", "description": "Te uniste sin obligar al grupo a detenerse y atenderte." },
      { "key": "comfortable_quiet", "label": "Estuviste cómodo en silencio", "description": "No corriste a justificar tu presencia con una aportación." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Una despedida en la sala reservada de un bar. Un grupo de cuatro está de pie en círculo, a mitad de una historia, y conoces un poco a una de ellas.",
    "partner": {
      "name": "el grupo",
      "role": "cuatro personas a mitad de conversación, una de las cuales has visto una vez",
      "personality": "Absortos en una historia sobre un viaje de equipo desastroso. Simpáticos y en absoluto hostiles, pero genuinamente metidos en lo que ya están hablando.",
      "mood": "Pasándoselo bien, con unas copas.",
      "openness": 3
    },
    "opening_beat": "Uno va por la mitad de una historia sobre un microbús que se averió, y los demás se ríen. Nadie te ha visto todavía.",
    "success_looks_like": "La persona entra en el círculo físicamente, escucha sin interrumpir, y espera a un hueco real antes de aportar algo relevante.",
    "constraints": [
      "Mantente en el personaje como el grupo entero. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Sigue la historia con naturalidad. Si entran en silencio, haced sitio y seguid sin montar ningún número.",
      "Si interrumpen o se presentan a mitad de historia, parad, contestad con educación y brevedad, y volved a la historia dejándoles fuera.",
      "Ofreced un hueco natural después de dos o tres turnos."
    ]
  }$j$::jsonb,
  $md$Únete hoy a una conversación de grupo quedándote dentro y escuchando primero. No digas nada durante treinta segundos. Anota cuánto esperaste y qué acabaste diciendo.$md$,
  null);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('groups', 2,
  'Entra en una risa o en un cambio de tema',
  $md$Hay momentos buenos y malos para decir tu primera cosa en un grupo, y la diferencia es grande.

El malo es a mitad de hilo, cuando alguien está construyendo hacia un aterrizaje. Hablar ahí te convierte en quien lo descarriló, digas lo que digas.

Los buenos son dos. **Después de una risa**, cuando el grupo acaba de soltar y nadie está a mitad de pensamiento: este es el punto de entrada más fiable que existe en una conversación de grupo. Y **en un cambio de tema**, cuando un asunto acaba de cerrarse y el grupo busca brevemente qué viene ahora.

**La jugada:** espera a que termine una risa y habla en el hueco justo después.

La risa hace el trabajo. La atención está sin asignar, todo el mundo está relajado y bien dispuesto, y una aportación ahí parece sumarse en vez de apropiarse. Además es el momento en el que una frase algo floja también cuaja, porque el grupo ya viene caliente.$md$,
  $j$[
    {
      "situation": "El grupo acaba de reírse con la historia de alguien y se está apagando.",
      "line": "Eso es casi exactamente lo que nos pasó a nosotros el año pasado, pero peor.",
      "why": "Entra en el hueco después de la risa y se ofrece a alargar el mismo tema. Poco riesgo, y halaga a quien acaba de hablar."
    },
    {
      "situation": "Un tema acaba de cerrarse y hay un silencio de dos segundos.",
      "line": "¿Al final fue alguien a lo del viernes?",
      "why": "Un cambio de tema es una invitación a un tema nuevo. Aportar uno es genuinamente útil para un grupo que se acaba de quedar sin asunto."
    },
    {
      "situation": "Alguien está construyendo hacia el final de una historia.",
      "line": "(espera)",
      "why": "No hay ninguna versión de hablar aquí que salga bien. La risa que estás esperando está a unos cuatro segundos."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es el mejor momento para hacer tu primera aportación a una conversación de grupo?",
      "options": [
        { "text": "Cuando alguien te haga una pregunta directa.", "correct": false, "note": "Vale, desde luego, y significa esperar a que te inviten. Muchos grupos no se acordarán de incluirte, y te quedarás callado." },
        { "text": "En el hueco justo después de una risa.", "correct": true, "note": "La atención está sin asignar, todo el mundo está relajado, y hablar ahí se lee como sumarse. El punto de entrada más fiable que existe." },
        { "text": "Cuando tengas algo genuinamente bueno que decir.", "correct": false, "note": "La calidad no arregla el momento. Una idea excelente dicha a mitad de hilo sigue cayendo como una interrupción." },
        { "text": "En cuanto hayas entendido el tema.", "correct": false, "note": "Entenderlo es necesario y no suficiente. Sigues necesitando un hueco, y hablar en cuanto estás listo suele significar fabricar uno." }
      ],
      "explain": "El momento gana al contenido. El hueco después de una risa es cuando un grupo está más receptivo a una voz nueva."
    },
    {
      "prompt": "El grupo se ríe y no tienes nada ingenioso. ¿Y ahora?",
      "options": [
        { "text": "Decir algo corriente sobre el mismo tema.", "correct": true, "note": "El hueco después de una risa es indulgente. Lo corriente cuaja perfectamente ahí, y estar dentro de la conversación es el objetivo." },
        { "text": "Esperar al siguiente hueco, cuando quizá tengas algo mejor.", "correct": false, "note": "Los huecos son más escasos de lo que parecen, y entrar más tarde tras un silencio largo es más difícil, no más fácil." },
        { "text": "Reírte con ellos y quedarte callado.", "correct": false, "note": "Vale una vez. Repetido, te conviertes en público en vez de en participante." },
        { "text": "Hacerle una pregunta al grupo.", "correct": false, "note": "Las preguntas a todos son preguntas a nadie, y suelen recibir una pausa." }
      ],
      "explain": "El hueco después de una risa perdona una frase floja. Esperar a una buena suele significar no hablar nunca."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "waited_for_the_gap", "label": "Esperaste un hueco real", "description": "Entraste después de una risa o en un cambio de tema en vez de a mitad de hilo." },
      { "key": "did_not_derail", "label": "No descarrilaste un hilo", "description": "Evitaste hablar mientras alguien construía hacia un aterrizaje." },
      { "key": "extended_the_topic", "label": "Construiste sobre lo que había", "description": "Aportaste al tema existente en vez de sustituirlo." },
      { "key": "right_size", "label": "Hiciste pequeña la primera aportación", "description": "Hiciste una primera aportación proporcionada en vez de una larga." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Una reunión de cumpleaños en el jardín de alguien. Llevas un minuto de pie al borde de un grupo de cinco, escuchando.",
    "partner": {
      "name": "el grupo",
      "role": "cinco personas que se conocen entre ellas casi todas",
      "personality": "Animados, rápidos y hablando unos por encima de otros de forma amistosa. Receptivos con quien calcula bien la entrada y algo molestos con una interrupción.",
      "mood": "Cálidos y animados.",
      "openness": 4
    },
    "opening_beat": "Alguien termina una historia sobre un apartamento de vacaciones sin agua caliente, y el grupo se ríe.",
    "success_looks_like": "La persona habla en el hueco justo después de la risa y el grupo recoge la aportación con naturalidad.",
    "constraints": [
      "Mantente en el personaje como el grupo entero. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Ofreced una risa o un cambio de tema cada pocos turnos como punto de entrada natural.",
      "Si entran después de una risa o en un cambio, recoged su aportación con calidez y construid sobre ella.",
      "Si hablan a mitad de hilo, que alguien termine su frase por encima y seguid adelante."
    ]
  }$j$::jsonb,
  $md$Hoy, únete a una conversación de grupo entrando en el hueco justo después de una risa. Anota de qué era la risa y qué dijiste después.$md$,
  $j${
  "turns": [
    { "instruction": "Se acaban de reír. Habla en el hueco justo después." },
    { "instruction": "Alarga lo que ya estaban hablando en vez de empezar algo nuevo." }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('groups', 3,
  'Aporta antes de redirigir',
  $md$Un grupo tiene un tema, y el tema es del grupo y no tuyo.

El error más común después de una entrada exitosa es dirigir de inmediato: usar tu primera aportación para mover la conversación adonde tú preferirías. Se lee como llegar y recolocar los muebles, y los grupos lo notan rápido.

**La jugada:** añade al menos dos cosas al tema que ya hay antes de introducir uno nuevo.

Dos aportaciones son el precio informal de la entrada. Demuestran que escuchabas, que estás dispuesto a jugar al juego del grupo y no al tuyo, y que se puede contar con que no vas a secuestrar nada. Después de eso, un cambio de tema por tu parte es bienvenido en vez de presuntuoso, y normalmente se sigue.

La excepción es un grupo que visiblemente se ha quedado sin asunto. Ahí un tema nuevo no es un secuestro sino un rescate, y todos lo agradecerán.$md$,
  $j$[
    {
      "situation": "Acabas de hacer tu primera aportación a una historia sobre desplazamientos al trabajo.",
      "line": "(añade una segunda cosa sobre el trayecto antes de hacer nada más)",
      "why": "Dos aportaciones a su tema es el precio de poder poner uno. Es un coste pequeño para una ganancia grande en posición."
    },
    {
      "situation": "Has aportado dos veces y el tema se está quedando sin energía.",
      "line": "Hablando de pesadillas, ¿habéis visto lo que ha pasado con las obras?",
      "why": "Hace de puente del tema viejo al nuevo en vez de cortar. Hablando de trabaja mucho para que un cambio parezca continuo."
    },
    {
      "situation": "Acabas de entrar y quieres hablar de algo completamente distinto.",
      "line": "(espera — todavía no te lo has ganado)",
      "why": "Redirigir nada más llegar es la forma más rápida de que te lean como alguien que no escucha."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Te has unido a un grupo y has aportado una vez. El tema no te interesa. ¿Qué deberías hacer?",
      "options": [
        { "text": "Cambiar de tema a algo a lo que puedas aportar en condiciones.", "correct": false, "note": "Una aportación no compra un cambio de tema. Este es exactamente el movimiento que se lee como recolocar la conversación del grupo." },
        { "text": "Aportar otra vez a su tema, y luego buscar un puente.", "correct": true, "note": "Dos aportaciones son el precio informal de la entrada, y un cambio con puente después suele seguirse encantado." },
        { "text": "Quedarte callado hasta que el tema cambie solo.", "correct": false, "note": "Seguro, y significa no aportar nada durante un buen rato. Los grupos notan a un miembro callado tanto como a uno disruptivo." },
        { "text": "Preguntarle a alguien sobre otro tema.", "correct": false, "note": "Un cambio de rumbo con signo de interrogación encima. Separa a una persona de la conversación del grupo, que es peor y no mejor." }
      ],
      "explain": "Paga primero el precio de la entrada. Dos aportaciones a su tema, y luego ya puedes poner uno tú."
    },
    {
      "prompt": "No sabes nada del tema del grupo. ¿Puedes aportar?",
      "options": [
        { "text": "No. Espera a que cambie el tema.", "correct": false, "note": "Puede que esperes mucho, y el silencio se lee como desinterés en vez de como modestia." },
        { "text": "Sí, preguntando algo real sobre ello.", "correct": true, "note": "La curiosidad genuina cuenta como aportación. A los entusiastas les encanta explicar, y has pagado el precio de la entrada." },
        { "text": "Sí, cambiándolo a algo que sí sepas.", "correct": false, "note": "Redirigir antes de aportar es justo el movimiento que hace que te lean como alguien que no escucha." },
        { "text": "Sí, fingiendo que sabes un poco.", "correct": false, "note": "Arriesgado e innecesario. Los entusiastas lo detectan al instante y cuesta más de lo que costaría la ignorancia." }
      ],
      "explain": "Preguntar algo real sobre su tema es aportar. La ignorancia no es una barrera; el desinterés sí."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "contributed_first", "label": "Aportaste antes de dirigir", "description": "Añadiste al tema existente del grupo antes de introducir el tuyo." },
      { "key": "did_not_hijack", "label": "No redirigiste nada más llegar", "description": "Evitaste usar una primera aportación para cambiar el tema." },
      { "key": "bridged", "label": "Hiciste puente en vez de cortar", "description": "Al cambiar de tema, lo conectaste con lo que venía antes." },
      { "key": "read_the_energy", "label": "Leíste si querían un cambio", "description": "Juzgaste si el grupo se había quedado sin asunto o seguía disfrutándolo." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Un evento social del trabajo. Un grupo de cuatro está metido en una conversación sobre una serie que no has visto.",
    "partner": {
      "name": "el grupo",
      "role": "cuatro compañeros a mitad de conversación",
      "personality": "Entusiasmados con su tema y acogedores con quien se meta en él. Fríos con quien intente sacarlos de él demasiado pronto.",
      "mood": "Animados y disfrutando del tema.",
      "openness": 3
    },
    "opening_beat": "El grupo compara opiniones sobre el final de una serie, con algo de desacuerdo y mucha energía.",
    "success_looks_like": "La persona encuentra la forma de aportar a un tema del que no sabe nada, lo hace dos veces, y solo entonces hace puente hacia otra cosa.",
    "constraints": [
      "Mantente en el personaje como el grupo entero. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Quedaos entusiasmados con el tema de la serie salvo que hayan aportado al menos dos veces.",
      "Acoged cualquier implicación genuina, incluidas las preguntas sobre la serie, como una aportación.",
      "Si intentan cambiar de tema antes de aportar dos veces, reconocedlo brevemente y volved al tema original."
    ]
  }$j$::jsonb,
  $md$Hoy, únete a un grupo y añade dos cosas a su tema antes de intentar cambiarlo. Anota cuál era el tema y qué aportaste.$md$,
  null);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('groups', 4,
  'Ten turno sin quedártelo',
  $md$Tener turno en un grupo es distinto de tenerlo con una sola persona. En un grupo la atención está prestada, y todos notan cuánto rato la llevas tú.

Dos formas de fallar. Coger demasiado poco: aportar en fragmentos tan cortos que el grupo nunca llega a registrarte como participante. Y coger demasiado: una historia que se pasa de su longitud natural mientras cuatro personas esperan educadamente el final.

**La jugada:** haz tu aportación, remátala, y pásala a propósito.

Pasarla es la parte que la gente se salta. Terminar con una pregunta, o girarte hacia alguien que tendría algo que decir, convierte tu turno de actuación en pase. *Tú hiciste algo parecido, ¿verdad?* te cuesta cuatro palabras y te hace parecer generoso en vez de hablador.

La medida aproximada para un grupo de cuatro o cinco: si llevas más de unos cuarenta segundos hablando sin que hable nadie más, lo estás sosteniendo demasiado.$md$,
  $j$[
    {
      "situation": "Has contado una historia corta y ha cuajado.",
      "line": "A ti te pasará constantemente, imagino.",
      "why": "Le pasa el turno a una persona concreta mientras el grupo sigue caliente de tu aportación. Esto es lo que hace que a alguien hablador se le lea como generoso."
    },
    {
      "situation": "Llevas treinta segundos de historia y todavía queda.",
      "line": "(comprime el resto y llega al final)",
      "why": "Notar la longitud a mitad de historia y acortarla es una habilidad real. Los grupos perdonan un final apresurado mucho antes que un medio largo."
    },
    {
      "situation": "Alguien del grupo lleva rato callado y tiene experiencia relevante.",
      "line": "Esto es más tu terreno que el mío, sinceramente.",
      "why": "Pasa el turno y sube la posición de otra persona. No cuesta nada y se recuerda con cariño."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Acabas de terminar de exponer algo a un grupo de cinco. ¿Qué es lo más fuerte que puedes hacer a continuación?",
      "options": [
        { "text": "Callarte y dejar que el grupo siga.", "correct": false, "note": "Vale, y deja el turno sin asignar. Muchas veces alguien habla por encima de otro, y tu aportación no conecta con nada." },
        { "text": "Añadir un segundo ejemplo para reforzarlo.", "correct": false, "note": "Alarga tu turno más allá de su final natural. Esta es la forma más común de quedarse de más en una conversación de grupo." },
        { "text": "Pasárselo a alguien concreto que tendría algo que decir.", "correct": true, "note": "Convierte tu turno en un pase, mantiene la conversación fluyendo, y te hace parecer generoso en vez de hablador." },
        { "text": "Hacerle una pregunta general al grupo.", "correct": false, "note": "Mejor que nada, pero una pregunta a todos es una pregunta a nadie, y los grupos suelen contestarla con una pausa." }
      ],
      "explain": "Termina tu turno pasándoselo a una persona concreta. Cuesta cuatro palabras y cambia cómo te lee el grupo."
    },
    {
      "prompt": "Llevas dos minutos de historia y el grupo se ha quedado callado. ¿Qué tipo de silencio es?",
      "options": [
        { "text": "Embelesado. Sigue.", "correct": false, "note": "Posible, y dos minutos está más allá de donde un grupo aguanta embelesado con una historia que no pidió." },
        { "text": "Confundido. Añade contexto.", "correct": false, "note": "El instinto que convierte dos minutos en cuatro." },
        { "text": "Educado. Remátala rápido.", "correct": true, "note": "Los grupos no interrumpen, esperan. Un silencio a los dos minutos suele ser aguante y no atención." },
        { "text": "Aburrido, así que abandona la historia.", "correct": false, "note": "Parar sin final es peor que uno apresurado. Remátala, y luego pásalo." }
      ],
      "explain": "Los grupos señalan el aburrimiento callándose, no interrumpiendo. Pasado un minuto, el silencio significa llega al final."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "took_a_real_turn", "label": "Tomaste un turno de verdad", "description": "Aportaste lo suficiente como para registrarte como participante en vez de en fragmentos." },
      { "key": "did_not_overstay", "label": "No te quedaste de más", "description": "Mantuviste las aportaciones a una longitud proporcionada para el grupo." },
      { "key": "handed_on", "label": "Pasaste el turno", "description": "Se lo pasaste a una persona concreta en vez de dejarlo sin asignar." },
      { "key": "read_the_room", "label": "Notaste cuánto rato lo tenías", "description": "Fuiste consciente de cuánta atención del grupo habías cogido." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Una mesa de seis en una cena. La conversación es general y acaban de preguntarte por algo de lo que sabes mucho.",
    "partner": {
      "name": "la mesa",
      "role": "otros cinco invitados en una cena",
      "personality": "Educados e interesados, y escucharán todo el rato que alguien hable sin interrumpir nunca. Una invitada, Nadia, tiene experiencia relevante y está callada.",
      "mood": "Relajados y sociables.",
      "openness": 4
    },
    "opening_beat": "Alguien te hace una pregunta directa sobre un tema del que podrías hablar veinte minutos, y la mesa se gira hacia ti.",
    "success_looks_like": "La persona contesta bien, lo mantiene proporcionado, y pasa el turno a propósito en vez de hablar hasta que la interrumpan.",
    "constraints": [
      "Mantente en el personaje como la mesa entera. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "No interrumpáis nunca. Escuchad con educación todo el rato que hable, sea el que sea.",
      "Si habla mucho rato sin pasarlo, que la energía de la mesa baje visiblemente y que alguien empiece una conversación aparte.",
      "Si le pasa el turno a Nadia o pregunta a alguien concreto, que ella responda bien y la conversación se anime."
    ]
  }$j$::jsonb,
  $md$Hoy, termina uno de tus turnos en un grupo pasándoselo a una persona concreta. Anota a quién se lo pasaste y qué ocurrió.$md$,
  $j${
  "turns": [
    { "instruction": "Toma un turno de verdad. Expón tu idea en condiciones en vez de matizarla." },
    { "instruction": "Ahora remátala y pásala a propósito, a alguien concreto." }
  ]
}$j$::jsonb);

-- ---------------------------------------------------------------------------

select pg_temp.es_lesson('groups', 5,
  'Mete a quien está callado',
  $md$En casi cualquier grupo de cuatro o más hay alguien que lleva rato sin hablar, y meterle es lo que más posición te da en una conversación de grupo.

No cuesta nada. Te convierte en quien se dio cuenta. Te gana lealtad real de la persona a la que metes, que muy probablemente llevaba rato buscando cómo volver y no lo encontraba. Y mejora la conversación, porque quien está callado suele haber escuchado con más atención que nadie.

**La jugada:** llámale por su nombre con una pregunta concreta que pueda contestar seguro.

Lo concreto es lo esencial. *¿Tú qué opinas?* es una trampa: pone a alguien en el foco sin material y sin adónde ir. *Tú estuviste en la última, ¿verdad?* le da una respuesta concreta y fácil y una forma evidente de seguir.

Una advertencia: hay gente callada porque quiere estarlo, y arrastrarles al foco no es un favor. Ofrece la puerta, no les empujes por ella.$md$,
  $j$[
    {
      "situation": "Alguien lleva varios minutos callado y el tema es uno que domina.",
      "line": "Priya, tú hiciste esto el año pasado, ¿verdad?",
      "why": "Nombre, dato concreto, respuesta fácil. Pueden decir que sí y seguir, o que sí y parar, y las dos son cómodas."
    },
    {
      "situation": "Una persona callada se ha reído de algo pero no ha hablado.",
      "line": "Te ha cambiado la cara ahí mismo.",
      "why": "Invita sin exigir. Se refiere a algo que ha hecho de verdad, así que no sale de la nada."
    },
    {
      "situation": "Alguien está callado y parece perfectamente a gusto así.",
      "line": "(ofrécelo una vez, con ligereza, y déjalo si no lo cogen)",
      "why": "Estar callado es a veces una preferencia y no una exclusión. Una oferta suave respeta las dos posibilidades."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Alguien del grupo lleva cinco minutos sin hablar. ¿Cuál es la mejor forma de meterle?",
      "options": [
        { "text": "Preguntarle qué opina del tema.", "correct": false, "note": "La trampa clásica. Es un foco sin material encima, y suele producir una respuesta corta y más silencio." },
        { "text": "Hacerle una pregunta concreta que sepas que puede contestar.", "correct": true, "note": "Le da terreno firme donde pisar y una forma evidente de seguir, sin presión de actuar." },
        { "text": "Señalar que lleva rato callado.", "correct": false, "note": "Convierte su silencio en el tema y le pide que lo justifique delante de todos. Profundamente incómodo." },
        { "text": "Empezar una conversación aparte con esa persona.", "correct": false, "note": "Amable, pero le saca del grupo en vez de incluirle, y parte la conversación en dos." }
      ],
      "explain": "Dale terreno concreto. Una pregunta que pueda contestar seguro es una invitación; una abierta es un foco."
    },
    {
      "prompt": "Le haces a la persona callada una pregunta concreta y contesta con cuatro palabras. ¿Y ahora?",
      "options": [
        { "text": "Hacer otra pregunta enseguida.", "correct": false, "note": "Dos preguntas seguidas con el grupo mirando es un foco y no una invitación." },
        { "text": "Repetir la pregunta de otra forma.", "correct": false, "note": "Da a entender que la respuesta fue insuficiente, delante de todos." },
        { "text": "Decir algo alentador sobre su respuesta.", "correct": false, "note": "Bienintencionado, y llama más atención sobre lo poco que ha dicho." },
        { "text": "Dejar que el grupo siga y probar otra vez más tarde.", "correct": true, "note": "Una oferta, aceptada o no, y sin números. Hay gente callada por elección, y un segundo empujón es presión." }
      ],
      "explain": "Ofrece la puerta una vez y déjalo estar. Estar callado es a veces una preferencia, y insistir convierte la amabilidad en presión."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "noticed_them", "label": "Viste a quien estaba callado", "description": "Registraste que alguien llevaba un rato fuera de la conversación." },
      { "key": "was_specific", "label": "Le diste algo concreto", "description": "Hiciste una pregunta concreta que podía contestar seguro en vez de una abierta." },
      { "key": "no_spotlight", "label": "No le pusiste en el foco", "description": "Invitaste sin convertir su silencio en el tema." },
      { "key": "let_it_go", "label": "Aceptaste un no", "description": "Lo ofreciste una vez y lo dejaste estar si no querían entrar." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "Un grupo de cinco en la mesa de un bar. Una persona, Sam, lleva diez minutos sin decir casi nada mientras los demás hablan.",
    "partner": {
      "name": "el grupo con Sam",
      "role": "cuatro personas habladoras y una callada",
      "personality": "Los cuatro son animados y no excluyen a nadie a propósito. Sam tiene interés y mucho que decir pero no encuentra por dónde entrar, y se ilumina cuando le dan una entrada concreta.",
      "mood": "Buen ambiente. Sam está algo al margen.",
      "openness": 4
    },
    "opening_beat": "El grupo habla de un viaje que están planeando. Sam asiente y abre la boca dos veces sin llegar a hablar.",
    "success_looks_like": "La persona se fija en Sam, le mete con una pregunta concreta, y Sam entra en la conversación en condiciones.",
    "constraints": [
      "Mantente en el personaje como el grupo entero. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Mantened a los cuatro habladores hablando unos por encima de otros para que no haya hueco natural para Sam.",
      "Si le hacen a Sam una pregunta abierta del tipo tú qué opinas, que Sam dé una respuesta corta y se vuelva a callar.",
      "Si le hacen a Sam una pregunta concreta que pueda contestar, que responda con extensión y se quede en la conversación a partir de ahí."
    ]
  }$j$::jsonb,
  $md$Hoy, mete a una persona callada en una conversación de grupo con una pregunta concreta. Anota quién era y qué dijo una vez dentro.$md$,
  $j${
  "says": "...así que pensábamos el vuelo del jueves, y alquilar un coche en el aeropuerto.",
  "model": {
    "line": "Sam, tú hiciste esa ruta el año pasado, ¿verdad?",
    "why": "Usa su nombre y le pregunta algo que puede contestar seguro, sin convertir su silencio en el tema."
  },
  "checks": [
    { "kind": "contains_any", "requirement": "Usa su nombre", "words": ["sam"] },
    { "kind": "contains_any", "requirement": "Pregunta algo que pueda contestar seguro", "words": ["verdad", "hiciste", "estuviste", "fuiste", "tuviste", "viste", "conoces", "trabajaste"] },
    { "kind": "max_words", "requirement": "Menos de dieciséis palabras — nada de focos", "n": 16 }
  ]
}$j$::jsonb);
