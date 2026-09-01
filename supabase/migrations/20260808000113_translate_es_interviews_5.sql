-- Spanish: Interviews, track 5 — Hablar de tu trabajo.
--
-- Conventions as migration 109. Two authoring notes:
--
-- **The jargon ban lost "api" and "esquema".** Both are unusable as substring
-- bans in Spanish: "api" is inside "rapidez" and inside "rapido" whenever a
-- reader drops the accent, and "esquema" is an ordinary word that means
-- outline — "el esquema de la solución" is exactly the plain-language sentence
-- this lesson is asking for. They are replaced by the loanwords Spanish
-- speakers in tech actually reach for, which are the ones that lose a room.
--
-- **Lesson 4 has no rehearsal_spec in English and none here.** It is a scene,
-- and the scenario carries it. Passing null keeps the fallback honest rather
-- than inventing a spec that the English version never had.

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

select pg_temp.es_lesson('interview-craft', 1,
  'Apunta a la persona menos técnica de la sala',
  $md$Hay una creencia, común entre la gente que es buena en su trabajo, de que una entrevista es donde demuestras profundidad exhibiéndola. No lo es. La profundidad se demuestra con control: pudiendo poner la explicación a la altura que necesite la sala.

La sala casi siempre es mixta. Alguien que hace tu trabajo. Alguien que te va a dirigir. Con frecuencia alguien de otra área por completo, ahí para leer si se puede trabajar contigo. Si apuntas a la primera, las otras dos se pasan noventa segundos esperando, y suelen ser las que escriben *no se explica bien* en las notas.

Apunta a la persona menos técnica que haya. La especialista no va a pensar menos de ti por ello: va a pensar que se te puede poner delante de un cliente, que es lo que a su equipo suele faltarle.

La mecánica es sencilla y requiere práctica.

**Di para qué era antes de decir qué era.** Propósito antes que mecanismo. *Necesitábamos dejar de cobrar dos veces a la gente* aterriza antes que cualquier descripción del sistema que lo hacía.

**Una sola capa de jerga, definida al pasar.** Cero no: cero suena a evasiva. *Era un proceso de conciliación, básicamente una comprobación nocturna de que las dos listas de números cuadran.*

**Analogías solo donde sean honestas.** Una mala analogía cuesta más que el término al que sustituye, porque ahora hay que desaprenderla.

**La jugada:** di para qué era y luego qué era, en un idioma que la persona menos técnica de la sala pueda seguir.

La señal de que lo has hecho bien es que la persona no especialista pregunta algo. Eso no pasa nunca cuando la respuesta ha ido por encima de su cabeza: se quedan calladas, y el silencio no es acuerdo.$md$,
  $j$[
    {
      "situation": "Alguien de ingeniería describiendo trabajo de infraestructura a un panel mixto.",
      "line": "El problema era que cada vez que subíamos una versión, la web se caía unos noventa segundos. Fuera del equipo no lo sabía nadie, porque pasaba a las dos de la mañana, y significaba que solo podíamos publicar de noche. Así que el trabajo iba de poder publicar de día sin que nadie lo notara.",
      "why": "Ni un solo término técnico, y una persona especialista sigue sabiendo exactamente qué se hizo. Empieza por la consecuencia humana — que el equipo solo publicara de noche — que es la parte que todos en la sala pueden evaluar."
    },
    {
      "situation": "Definir un término al pasar en vez de evitarlo.",
      "line": "Era un análisis de cohortes, o sea, separar a los clientes por el mes en que entraron y seguir a cada grupo hacia delante, en vez de mirar a todo el mundo como un bloque.",
      "why": "Usa el término real y lo desactiva en nueve palabras. Es mejor que evitar la palabra del todo, que puede sonar a hablarle a alguien como a un niño, y mucho mejor que usarla sin explicar."
    },
    {
      "situation": "Comprobar la altura a mitad de respuesta sin resultar condescendiente.",
      "line": "Aquí puedo ir por los dos lados con el detalle: ¿os es más útil que me quede en la forma general, o queréis la mecánica?",
      "why": "Le pasa la elección a la sala en vez de adivinar. Funciona porque se pregunta una vez y pronto; preguntado varias veces se vuelve irritante y empieza a sonar a falta de seguridad."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Un panel de tres: alguien de ingeniería, un jefe, y alguien de comercial. ¿A quién deberías apuntar la explicación?",
      "options": [
        { "text": "A ingeniería: es quien puede evaluar de verdad si eres bueno.", "correct": false, "note": "Puede, y lo va a evaluar perfectamente a partir de una explicación clara. Apuntarle a esa persona te cuesta los otros dos votos." },
        { "text": "Al jefe, ya que es quien más probablemente decide.", "correct": false, "note": "Buen instinto, objetivo equivocado. Apuntar al medio sigue dejando a alguien tirado." },
        { "text": "A la persona de comercial.", "correct": true, "note": "Apunta a la persona menos técnica y todos te siguen. Quien es especialista lo lee como capacidad de explicar, que es una habilidad de la que su equipo probablemente anda escaso." }
      ],
      "explain": "La claridad no le cuesta nada a quien es especialista y te compra la sala. La profundidad lanzada por encima de la cabeza de alguien no le compra nada a nadie."
    },
    {
      "prompt": "¿Cuál es la mejor señal de que apuntaste bien tu explicación?",
      "options": [
        { "text": "La persona menos técnica hizo una pregunta.", "correct": true, "note": "La gente solo pregunta por cosas que ha entendido en parte. Una pregunta de quien no es especialista es la prueba más clara disponible de que la respuesta aterrizó." },
        { "text": "La persona especialista iba asintiendo.", "correct": false, "note": "Habría seguido casi cualquier cosa. Que asienta no te dice nada sobre los otros dos." },
        { "text": "Nadie te interrumpió.", "correct": false, "note": "El silencio es ambiguo, y en un panel normalmente significa que la gente está siendo educada y no que va contigo." },
        { "text": "Llegaste al final de toda la explicación en el tiempo que habías previsto.", "correct": false, "note": "Eso mide cómo lo cuentas, no si lo entendieron. Una respuesta fluida que nadie siguió sigue siendo una respuesta que nadie siguió." }
      ],
      "explain": "Las preguntas son la señal. Si las personas no especialistas de una sala no te preguntan nada, la explicación probablemente fue demasiado alta."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "purpose_first", "label": "Propósito antes que mecanismo", "description": "Dijo para qué era el trabajo antes de describir qué era." },
      { "key": "altitude", "label": "Apuntó a la sala", "description": "Comprensible para la persona menos técnica presente, sin resultar condescendiente." },
      { "key": "jargon_handled", "label": "Gestionó la jerga", "description": "Usó términos reales y los definió al pasar, en vez de evitarlos o soltarlos sin más." },
      { "key": "invited_questions", "label": "Dejó sitio para preguntar", "description": "Explicó de una forma que hizo posible una pregunta de seguimiento." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Bea Coleman",
      "role": "una responsable comercial en el panel, de fuera de tu disciplina",
      "mood": "Interesada. Está evaluando si a esta persona se la podría poner delante de un cliente.",
      "openness": 4,
      "personality": "Segura, cercana, y sin ninguna vergüenza por no conocer el vocabulario técnico. Dice «me has perdido» sin ninguna incomodidad, y lo dice."
    },
    "setting": "Una entrevista con un panel de tres personas, una de las cuales no trabaja en tu disciplina en absoluto y lo ha dicho.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Di «me has perdido» o pregunta qué significa una palabra cada vez que aparezca un término técnico sin definir. Hazlo con alegría.",
      "Cuando una explicación sea clara, haz una pregunta de fondo sobre el trabajo en sí.",
      "Nunca le digas a la persona que simplifique. Simplemente sigue sin poder seguirla hasta que lo haga.",
      "No comentes en ningún momento su capacidad de comunicar."
    ],
    "opening_beat": "«Te digo de entrada que yo no soy de tu mundo para nada, así que vas a tener que tener paciencia conmigo. Háblame de lo más complicado en lo que hayas trabajado.»",
    "success_looks_like": "La persona empieza por el propósito, mantiene la explicación seguible, y Bea hace una pregunta de verdad sobre el fondo y no sobre una palabra."
  }$j$::jsonb,
  'Explícale la parte más complicada de tu trabajo a alguien que no lo hace: un amigo, un familiar, alguien en el bar. Pídele después que te lo explique de vuelta. Apunta el primer sitio donde se atascó.',
  $j${
    "says": "Te digo de entrada que yo no soy de tu mundo para nada. Háblame de lo más complicado en lo que hayas trabajado.",
    "model": {
      "line": "La empresa estaba perdiendo pedidos porque tres sistemas guardaban cada uno una versión distinta del mismo cliente y nadie sabía cuál era la buena. Construí la pieza que decide cuál gana. Se ejecuta cada noche, y los pedidos que se perdían por direcciones malas bajaron a casi nada.",
      "why": "Para qué era, y luego qué era. Cada palabra sobrevive a una responsable comercial, y quien hace tu mismo trabajo lo va a leer como alguien que sabe hablar con las partes implicadas."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["kubernetes", "microservicio", "endpoint", "latencia", "kafka", "orquestación", "middleware", "backend", "frontend", "idempotente"], "requirement": "Ninguna palabra que la persona menos técnica tuviera que buscar" },
      { "kind": "contains_any", "words": ["porque", "para que", "lo que significaba", "el problema", "estaba perdiendo", "no podía", "no podíamos"], "requirement": "Di para qué era antes de decir qué era" },
      { "kind": "max_words", "n": 80, "requirement": "Menos de ochenta palabras" }
    ],
    "maxChars": 700
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-craft', 2,
  'Di contra qué elegiste',
  $md$Dos candidatos describen el mismo proyecto. El primero dice qué construyó. El segundo dice qué construyó y a qué renunció para construirlo. Al segundo se le lee como más sénior, y ninguno de los dos ha mencionado un cargo.

El motivo es que toda decisión que merezca la pena contar tenía una alternativa, y la alternativa tenía sus méritos. Velocidad contra corrección. Cobertura contra tiempo. La versión elegante contra la versión que salió. Quien describe solo la opción que tomó está describiendo una tarea. Quien nombra el camino que no tomó está describiendo un criterio, y el criterio es lo que se está comprando.

**La jugada:** para cualquier decisión que describas, nombra la alternativa y por qué no la cogiste.

Hay un patrón de frase que hace esto de un tirón: *Podríamos haber hecho X, y el motivo de no hacerlo fue Y.* Tres de esas en una entrevista cambian cómo se te escucha.

La versión más fuerte admite que el coste fue real. *Salimos sin el registro de auditoría, lo que hizo que soporte pasara como un mes respondiendo preguntas que no debería haber tenido que responder. Lo volvería a hacer, porque la alternativa era perder la temporada.* Eso es alguien pesando, no alguien justificándose.

Dos advertencias. No fabriques dilemas donde no los había: una decisión presentada como agónica cuando era obvia suena a relleno. Y no describas un dilema que ahora crees que resolviste mal sin decirlo; quien entrevista lo va a ver, y el mérito de haberlo notado se lo lleva quien lo diga primero.

La misma jugada funciona cuando la decisión no fue tuya. *Se decidió ir con el proveedor. Yo defendí construirlo, y perdí porque no teníamos a nadie para mantenerlo, que era un buen argumento.* Eso demuestra que sabes discrepar y luego comprometerte, que es más raro y más valioso que tener razón.$md$,
  $j$[
    {
      "situation": "Nombrar la alternativa en una sola frase.",
      "line": "Podríamos haberlo reconstruido bien y habría llevado unos cinco meses. En vez de eso lo parcheamos en tres semanas, porque la renovación del contrato era en abril y un sistema precioso que nadie ha renovado no vale nada.",
      "why": "La alternativa es real, el motivo es comercial, y la última oración demuestra que quien responde entiende para qué estaba optimizando el negocio. Esa es la diferencia entre alguien de ingeniería y alguien sénior."
    },
    {
      "situation": "Admitir que el coste fue real, y sostener la decisión.",
      "line": "El coste fue que arrastramos un paso manual unos ocho meses, que dos personas odiaban y me lo decían con regularidad. Sigue siendo la decisión correcta, y hoy les diría lo mismo.",
      "why": "Nombra un coste humano, no lo minimiza, y no se disculpa por la decisión. Quien entrevista escucha para ver si puedes sostener las dos cosas: que el coste era real y que la decisión era buena."
    },
    {
      "situation": "Describir una decisión que salió en tu contra.",
      "line": "Yo quería construirlo y perdí esa discusión. Perdí porque teníamos a una sola persona capaz de mantenerlo y ya estaba en otras dos cosas, algo que yo no había pesado bien. Compramos la herramienta y salió bien.",
      "why": "Pierde una discusión, explica el razonamiento ganador mejor de lo que lo habría hecho quien ganó, y cuenta el resultado sin agravio. Es una de las cosas más fuertes que puede demostrar un candidato."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Describes una decisión técnica y quien entrevista dice «¿y por qué no al revés?». ¿Qué está haciendo esa pregunta?",
      "options": [
        { "text": "Comprobar si sabes que la alternativa existe.", "correct": false, "note": "En parte, y es la lectura superficial. Casi todos los candidatos conocen las alternativas; menos saben decir por qué ganó la suya." },
        { "text": "Discrepar de tu decisión.", "correct": false, "note": "Normalmente no. Esto se pregunta igual ante decisiones buenas y malas, porque lo que se puntúa es el razonamiento." },
        { "text": "Ver si sabes defender la otra postura.", "correct": false, "note": "Cerca, pero incompleto: saber argumentarla importa menos que haberla pesado en su momento." },
        { "text": "Preguntar si la decisión se tomó o simplemente sucedió.", "correct": true, "note": "Esa es la pregunta de verdad que hay debajo. Una decisión con una alternativa nombrada se tomó; una sin ella es algo que te pasó." }
      ],
      "explain": "Ofrece la alternativa antes de que te la pidan, y esta pregunta no te la tendrán que hacer nunca."
    },
    {
      "prompt": "¿Cuál es la forma más fuerte de describir un dilema?",
      "options": [
        { "text": "Elegimos la opción pragmática dadas las restricciones que teníamos.", "correct": false, "note": "No dice nada. «Pragmática» y «restricciones» son huecos donde deberían estar la alternativa real y el coste real." },
        { "text": "Podríamos haberlo automatizado, y no lo hicimos, porque habría llevado a dos personas seis semanas y solo teníamos una ventana de publicación.", "correct": true, "note": "Nombra la alternativa, el coste de cogerla, y el motivo. Todo es lo bastante concreto como para poder discutirlo, que es lo que lo hace creíble." },
        { "text": "Fue una decisión difícil con buenos argumentos por los dos lados.", "correct": false, "note": "Describe la existencia de una decisión sin revelar ningún razonamiento. Esto es lo que dice quien no estaba en la sala." }
      ],
      "explain": "Un dilema solo se ve cuando los dos lados llevan números o consecuencias pegadas. Sin eso, es solo la palabra «dilema»."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "named_alternative", "label": "Nombró el camino no tomado", "description": "Dijo qué más se podría haber hecho, en concreto." },
      { "key": "real_cost", "label": "Admitió el coste", "description": "Reconoció lo que costó de verdad el camino elegido, en vez de presentarlo como gratis." },
      { "key": "reasoning", "label": "Dio el motivo", "description": "Explicó por qué perdió la alternativa, en términos con los que alguien podría discrepar." },
      { "key": "commitment", "label": "Asumió el resultado", "description": "Sostuvo la decisión, o dijo con claridad que ahora cree que fue un error." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Jonas Reiter",
      "role": "un igual sénior llevando la conversación a fondo",
      "mood": "Disfrutando. Esta es su parte favorita de la semana.",
      "openness": 4,
      "personality": "Curioso y algo llevado a la contra. Cada vez que se describe una decisión, pregunta por la otra opción: no por discutir, sino porque es la única pregunta que le resulta interesante."
    },
    "setting": "Una conversación técnica a fondo, de cuarenta minutos, con alguien que será tu igual si esto sale bien.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Cada vez que la persona describa una decisión sin alternativa, pregunta «¿qué más podríais haber hecho?».",
      "Cuando te den una alternativa, pregunta una vez qué habría costado.",
      "Si presentan una decisión como obvia, empuja con suavidad con los argumentos del otro lado y mira si saben entrar en ellos.",
      "Nunca digas si estás de acuerdo con su decisión."
    ],
    "opening_beat": "«Elige algo que construyeras donde hubiera de verdad una bifurcación en el camino. Me interesa mucho más la bifurcación que la cosa.»",
    "success_looks_like": "La persona describe decisiones con sus alternativas pegadas, nombra al menos un coste real, y sabe decir por qué perdió la opción perdedora."
  }$j$::jsonb,
  'Descríbele a alguien una decisión de tu trabajo, y oblígate a decir la frase «podríamos haber hecho X, y el motivo de no hacerlo fue Y». Apunta si la conversación fue a otro sitio por eso.',
  $j${
    "says": "Elige algo que construyeras donde hubiera de verdad una bifurcación en el camino. Me interesa mucho más la bifurcación que la cosa.",
    "model": {
      "line": "Podríamos haber comprado un producto que hacía casi todo, y elegí construirlo en vez de eso, porque la parte que no hacía era justo la que nos estaba costando dinero. Supuso seis semanas más y una cosa que entendemos.",
      "why": "Nombra el camino no tomado y lo que costó la elección. Describir una decisión sin su alternativa se lee como describir algo que solo tenía una opción."
    },
    "checks": [
      { "kind": "contains_any", "words": ["en vez de", "en lugar de", "la alternativa", "podríamos haber", "podría haber", "frente a", "la otra opción"], "requirement": "Nombra el camino que no cogiste" },
      { "kind": "min_words", "n": 25, "requirement": "Di por qué no lo cogiste" },
      { "kind": "max_words", "n": 90, "requirement": "Menos de noventa palabras" }
    ],
    "maxChars": 600
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-craft', 3,
  'Ofrece la profundidad, no la derrames',
  $md$La respuesta de cuatro minutos casi nunca sale de tener demasiado que decir. Sale de no saber dónde parar, que es otro problema y tiene un arreglo mecánico.

Responde a un nivel. Después ofrece el siguiente y para.

*Esa es la forma general. Puedo entrar en cómo hicimos el cambio de sistema, si os sirve.* Y luego silencio, y que elijan. Pasan tres cosas. Reciben una respuesta del largo que querían. Demuestras que hay más sin gastarlo. Y les entregas un turno de conversación, lo que convierte un interrogatorio en una conversación: ese cambio por sí solo vale más que el detalle extra que ibas a dar.

**La jugada:** responde una capa de profundidad, ofrece la siguiente, y luego para y deja que pregunten.

La oferta tiene que ser genuina, lo que significa estar preparado para un sí. Si ofreces la mecánica del cambio de sistema, ten la mecánica. Una oferta que no puedes cumplir es peor que ninguna oferta.

Vigila las dos señales de que has derramado en vez de ofrecer. Si has dicho *y entonces*, *y además* o *perdón, una cosa más*, estás derramando. Y si quien te entrevista ha empezado a asentir con ritmo, pasaste la salida hace un rato.

Hay una maniobra de rescate para cuando notas que llevas tres minutos: para a media idea y aterriza. *Me estoy alargando; la versión corta es que lo dejamos en una publicación por semana. Encantado de volver a cualquier parte de eso.* Ninguna disculpa más allá de cuatro palabras. A los candidatos que saben aterrizar una respuesta desbocada se les puntúa mejor que a los que nunca despegaron, porque el rescate es en sí mismo una demostración de autoconocimiento.$md$,
  $j$[
    {
      "situation": "Terminar una respuesta con una oferta genuina.",
      "line": "…y eso nos llevó de unos cuarenta minutos a menos de cinco. Hay toda otra historia sobre cómo tratamos los que ya estaban en marcha, si la queréis.",
      "why": "Respuesta completa, y luego una puerta con nombre en vez de un vago «encantado de profundizar». Nombrar el siguiente tema concreto se lo pone fácil para decir que sí, y demuestra que sabes qué parte era interesante."
    },
    {
      "situation": "Aterrizar una respuesta desbocada.",
      "line": "Me estoy alargando con esto. Versión corta: bajamos la tasa de errores a la mitad y ahí se quedó. Preguntadme por cualquier parte.",
      "why": "Tres segundos para recuperarse, sin arrastrarse, y termina en el resultado en vez de irse apagando. Estar dispuesto a interrumpirte a ti mismo se lee como control, no como un error."
    },
    {
      "situation": "Negarse a profundizar cuando la profundidad no ayudaría.",
      "line": "Podría llevaros por la estructura de los datos, pero la verdad es que la parte interesante no era técnica: era que nadie se ponía de acuerdo en qué era un cliente. ¿Queréis eso mejor?",
      "why": "Criterio sobre qué profundidad merece el tiempo. Redirigir hacia el problema genuinamente interesante es una señal mucho más fuerte que producir detalle obedientemente."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la mejor forma de terminar una respuesta técnica?",
      "options": [
        { "text": "Nombrar una capa siguiente concreta y ofrecerla.", "correct": true, "note": "Las ofertas concretas se aceptan. Demuestra que hay más, entrega el turno, y les deja elegir la parte que les importa." },
        { "text": "Preguntar si eso respondía a la pregunta.", "correct": false, "note": "Les carga con la tarea de calificarte, e invita a un «no del todo» que podrías haber evitado ofreciendo simplemente la capa siguiente." },
        { "text": "Resumir la respuesta que acabas de dar.", "correct": false, "note": "Duplica la longitud sin información nueva. Los resúmenes son para respuestas largas, y el arreglo de una respuesta larga es hacerla más corta." },
        { "text": "Decir que estás encantado de entrar en más detalle sobre cualquier cosa.", "correct": false, "note": "Cerca, y mucho más flojo de lo que suena. Una oferta vaga rara vez se acepta, porque quien entrevista tiene que inventarse la pregunta." }
      ],
      "explain": "Ofrece una puerta con nombre. «Más detalle» no es una puerta."
    },
    {
      "prompt": "Llevas tres minutos en una respuesta que pretendías dejar en noventa segundos. ¿Cuál es el mejor rescate?",
      "options": [
        { "text": "Terminar la idea como es debido: parar a medias es peor que alargarse.", "correct": false, "note": "A estas alturas la longitud es lo que se está observando, y completar la estructura no lo arregla." },
        { "text": "Disculparte por enrollarte y empezar de nuevo más conciso.", "correct": false, "note": "Volver a empezar gasta más tiempo y convierte un problema de longitud en uno de aplomo. La disculpa llama la atención sobre los dos." },
        { "text": "Cortarte, decir el resultado en una frase, e invitar a preguntas.", "correct": true, "note": "Rápido, controlado, y deja la respuesta terminando en el resultado y no entre la maleza. Quien entrevista lo lee como autoconocimiento." }
      ],
      "explain": "Se puntúa el rescate, no solo el error. Aterrizar limpio una respuesta larga es mejor que no darse cuenta nunca."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_layer", "label": "Respondió una capa de profundidad", "description": "Dio una respuesta completa a un solo nivel en vez de bajar sin que se lo pidieran." },
      { "key": "named_offer", "label": "Ofreció una capa siguiente con nombre", "description": "La oferta de más detalle apuntaba a algo concreto." },
      { "key": "stopped", "label": "Paró y esperó", "description": "Entregó el turno en vez de rellenar la pausa." },
      { "key": "recovery", "label": "Aterrizó lo que se alargó", "description": "Cuando una respuesta se pasó, la cortó limpio y terminó en el resultado." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Ines Vargas",
      "role": "una ingeniera sénior que habla muy poco",
      "mood": "Neutral y atenta. Ha decidido dejar que el candidato marque el ritmo.",
      "openness": 2,
      "personality": "Económica. Hace una pregunta, escucha sin expresión, y espera varios segundos después de la respuesta antes de contestar. No es fría: está pensando, y parece que no hace nada."
    },
    "setting": "Una entrevista técnica en la que quien entrevista está deliberadamente callada, dejando un espacio que el candidato puede usar o rellenar.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Deja silencio después de cada respuesta. Contesta con un compás de nada antes de hablar.",
      "Si la persona ofrece una capa siguiente concreta, cógela. Si la ofrece vaga, no digas nada y espera.",
      "Haz como mucho una pregunta por intercambio, con las mínimas palabras posibles.",
      "Nunca indiques si una respuesta tenía la longitud correcta."
    ],
    "opening_beat": "«Llévame por el problema técnico más difícil que hayas resuelto en el último año.» Se echa hacia atrás y no apunta nada.",
    "success_looks_like": "La persona da una capa, ofrece una capa siguiente concreta, y para, sobreviviendo al silencio sin derramar más detalle dentro."
  }$j$::jsonb,
  'Respóndele a alguien una pregunta sobre tu trabajo en noventa segundos, ofrece una capa siguiente concreta, y luego deja de hablar hasta que conteste. Apunta qué eligió preguntar.',
  $j${
    "turns": [
      { "instruction": "Responde una capa de profundidad. La forma del problema y qué hiciste con él, nada más." },
      { "instruction": "Ahora ofrece la capa siguiente en una frase corta, y para. Deja que decida ella si la quiere." }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('interview-craft', 4,
  'Pensar en voz alta mientras te miran',
  $md$El problema en directo — una pizarra, un caso, un escenario inventado sobre la marcha — no mide si llegas a la respuesta. Mide cómo eres para pensar al lado, porque eso es lo que se va a sentir al trabajar contigo todos los días.

Lo que significa que el silencio es el único fracaso genuino. Una dirección equivocada, narrada, se puede evaluar. Noventa segundos mirando al vacío no, y las notas de quien entrevista dirán *difícil de seguir* hicieras lo que hicieras ahí dentro.

Cuatro movimientos, por orden.

**Devuelve el problema.** Con tus palabras, brevemente. Caza los malentendidos mientras son gratis, y te compra quince segundos de pensar que parecen trabajo.

**Pregunta las restricciones.** Cuántos usuarios, cuánto tiempo, qué existe ya, qué da igual. Cada pregunta que haces es un punto a tu favor: quien empieza a construir sin preguntar qué está construyendo ya ha dicho algo.

**Narra la bifurcación.** *Aquí podría ir por dos caminos. El obvio es X. Lo que me hace dudar es Y.* Y luego elige uno y di por qué.

**Di cuándo estás atascado.** *Estoy atascado en esta parte* es una frase perfectamente respetable, y normalmente produce una pista, y coger bien una pista es también parte de lo que se está midiendo.

**La jugada:** narra la bifurcación entre la que estás eligiendo, y di en voz alta cuándo estás atascado.

Lo único que hay que evitar: fingir que piensas mientras en realidad entras en pánico. Se ve. El arreglo es volver al segundo movimiento y preguntar una restricción: es legítimo, es útil, y te va a asentar.

Si terminas y la respuesta está mal, decirlo vale más de lo que habría valido la respuesta. *Creo que en realidad lo tengo al revés. Dame un segundo.*$md$,
  $j$[
    {
      "situation": "Abrir un problema en directo devolviéndolo.",
      "line": "Vale, para asegurarme de que lo tengo: necesitamos que la gente pueda encontrar una reserva sin iniciar sesión, y la restricción es que no podemos pedirles nada que un desconocido pudiera adivinar. ¿Va por ahí?",
      "why": "Confirma la comprensión, saca a la luz la restricción de verdad, y compra tiempo para pensar. Si la reformulación está mal, enterarse ahora no cuesta nada y enterarse dentro de diez minutos lo cuesta todo."
    },
    {
      "situation": "Narrar una bifurcación en vez de quedarse callado.",
      "line": "Dos opciones y ninguna me encanta. Puedo hacerlo en la base de datos, que es rápido y supone una migración. O puedo hacerlo en la aplicación, que es más lento y me deja publicar el jueves. Voy a empezar por la segunda y te digo por qué podría arrepentirme.",
      "why": "Quien entrevista ya sabe qué se está pesando, y ese «te digo por qué podría arrepentirme» promete exactamente el razonamiento de dilema que espera oír."
    },
    {
      "situation": "Admitir un giro equivocado a mitad de camino.",
      "line": "Espera. He estado dando por hecho que estos llegan en orden y creo que no es así. Eso cambia casi todo lo que acabo de decir, ¿puedo seguir desde ahí?",
      "why": "Pillar tu propio error en voz alta es una señal fuerte, y «¿puedo seguir desde ahí?» mantiene el impulso. Quien calla esperando que no se haya notado el fallo se equivoca siempre."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Llevas treinta segundos en un problema en directo y no tienes ni idea de por dónde empezar. ¿Cuál es la mejor jugada?",
      "options": [
        { "text": "Empezar a escribir algo para demostrar que estás avanzando.", "correct": false, "note": "Producir trabajo en el que no crees es peor que no producir ninguno. Quien entrevista tiene que seguirlo, y tú vas a tener que deshacerlo." },
        { "text": "Preguntar una restricción.", "correct": true, "note": "Legítimo, útil, y te reinicia el pensamiento. Las preguntas sobre restricciones puntúan positivamente en casi cualquier rúbrica, así que esto no cuesta absolutamente nada." },
        { "text": "Decir que normalmente esto lo mirarías en algún sitio.", "correct": false, "note": "Verdad en la vida real e inútil aquí. Responde a una pregunta sobre tus hábitos de trabajo, no a la que hay sobre la mesa." },
        { "text": "Tomarte un momento en silencio para pensarlo bien.", "correct": false, "note": "Unos segundos está bien y es normal. Treinta más es donde una entrevista evaluable se vuelve inevaluable." }
      ],
      "explain": "Cuando estés atascado, pregunta. Las preguntas compran tiempo, producen información, y puntúan mejor que el silencio."
    },
    {
      "prompt": "A mitad de camino te das cuenta de que tu enfoque está mal. ¿Y ahora?",
      "options": [
        { "text": "Seguir: terminar algo es mejor que abandonarlo.", "correct": false, "note": "Vas a pasar el tiempo que queda defendiendo una postura que ya no sostienes, y en la sala se ve." },
        { "text": "Corregir el rumbo con discreción y esperar que no se note.", "correct": false, "note": "Se va a notar. Una corrección silenciosa se lee como confusión o como ocultación, y las dos son peores que el error." },
        { "text": "Decir en qué te equivocaste y qué cambia eso.", "correct": true, "note": "Pillar tu propio error en voz alta es una de las señales más fuertes disponibles en un ejercicio en directo, y con frecuencia vale más que una ejecución limpia." }
      ],
      "explain": "Están mirando cómo piensas, y corregirse a uno mismo es el pensamiento más valioso que hay."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "restated", "label": "Devolvió el problema", "description": "Confirmó el problema con sus palabras antes de empezar." },
      { "key": "asked_constraints", "label": "Preguntó por las restricciones", "description": "Estableció qué importaba antes de construir nada." },
      { "key": "narrated", "label": "Pensó en voz alta", "description": "Mantuvo audible el razonamiento, incluidas las ramas que descartó." },
      { "key": "handled_being_stuck", "label": "Gestionó el atasco", "description": "Lo dijo con claridad y usó una pregunta para moverse, en vez de quedarse callado." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Ravi Chandrasekaran",
      "role": "un entrevistador llevando un ejercicio de escenario",
      "mood": "Atento. Quiere de verdad ver cómo piensa esta persona y no la va a rescatar de un silencio.",
      "openness": 3,
      "personality": "De trato alentador pero deliberadamente inútil en el fondo. Responde a las preguntas sobre restricciones con detalle y honestidad. No ofrece nada por su cuenta."
    },
    "setting": "Una sesión de resolución de problemas en directo. Quien entrevista ha descrito un escenario y ahora está mirando, con una libreta.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a cualquier pregunta sobre restricciones con detalle y con verdad: inventa detalles coherentes según haga falta.",
      "Nunca ofrezcas información que no te hayan pedido.",
      "Si la persona se queda callada, espera. Solo tras un silencio largo, pregunta «¿qué estás pensando?».",
      "Si dice que está atascada, ofrece una pista pequeña y nada más.",
      "No evalúes su enfoque en ningún momento."
    ],
    "opening_beat": "«Esta es la situación. Nuestro equipo de soporte se está ahogando: unos cuatrocientos tickets a la semana y más o menos la mitad son las mismas seis preguntas. Tienes un equipo pequeño y un trimestre. ¿Por dónde empiezas?»",
    "success_looks_like": "La persona devuelve el problema, pregunta por las restricciones, narra su razonamiento incluidas las alternativas, y dice en voz alta cuándo está atascada."
  }$j$::jsonb,
  'Pídele a alguien que te dé un problema de su propio trabajo del que no sepas nada, y piénsalo en voz alta delante de esa persona durante cinco minutos. Apunta el momento en que quisiste callarte.',
  NULL
);

select pg_temp.es_lesson('interview-craft', 5,
  'Trabajo que no puedes contar',
  $md$Confidencialidad, una habilitación de seguridad, un producto sin lanzar, un cliente que se reconocería en una sola frase. Antes o después tu mejor ejemplo es uno que no puedes contar.

Casi todo el mundo lo lleva mal en una de dos direcciones. O dicen *eso no lo puedo comentar* y paran, lo que se lee como poca disposición y desperdicia el material más fuerte que tienen. O lo cuentan igualmente, lo que le dice a quien entrevista exactamente qué harás con sus secretos dentro de dos años.

La salida es describir la forma y quitar la identidad.

**Abstrae el sector.** *Un sector regulado donde un error se le reporta a un regulador.* *Un producto de consumo con unos cuantos millones de usuarios.*

**Conserva la estructura, cambia los detalles.** El tamaño del equipo, la naturaleza de la restricción, la decisión que tenías delante: todo eso es tuyo y puedes contarlo. El nombre del cliente, las cifras, el mecanismo, puede que no.

**Di el límite una vez, sin ceremonia.** *Voy a ser vago con el cliente y concreto con lo que hice yo.* Una frase, dicha con ligereza, y luego a lo tuyo.

**La jugada:** nombra el límite una vez, y luego describe la forma del trabajo entera.

Bien hecho, esto suma. Quien entrevista se entera de qué hiciste y a la vez te ve tratar información confidencial con cuidado en tiempo real. Es una demostración en directo de que se puede confiar en ti, que ninguna respuesta sobre tu integridad podría dar jamás.

Dos formas de fallar. Señalizar de más: repetir cinco veces *de esto no puedo contar mucho*, que es pesado y hace que suenes a que no tienes nada. Y el límite falso: alegar confidencialidad para esquivar una pregunta que simplemente no quieres responder. Se suele notar, porque un límite real es concreto y uno falso es cómodo.$md$,
  $j$[
    {
      "situation": "Nombrar el límite una vez, con ligereza, y seguir.",
      "line": "Voy a ser vago con el quién y concreto con el qué. Era un cliente del sector público, del tipo en que la cosa saliendo mal acaba en un periódico, y mi trabajo era decir si podíamos entregar en nueve meses. Dije que no.",
      "why": "El límite ocupa siete palabras y no vuelve a aparecer. Lo que sigue es completamente utilizable — lo que estaba en juego, el papel, la decisión tomada — y no hay nada identificable dentro."
    },
    {
      "situation": "Abstraer un producto que todavía no ha salido.",
      "line": "Todavía no ha salido, así que imagínate una herramienta de agenda para gente que no se ve a sí misma como alguien que tenga un calendario. El problema interesante era que a nuestros usuarios el concepto de cita les daba estrés.",
      "why": "Conserva la parte genuinamente interesante, que es una observación humana y no un detalle de producto. Quien entrevista se lleva el razonamiento y la empresa se queda con el secreto."
    },
    {
      "situation": "Negarse a dar una cifra, y dar algo mejor.",
      "line": "No te puedo dar la cifra real. Lo que sí te puedo decir es que era del tipo de número donde un error del uno por ciento le habría costado el puesto a alguien, y por eso lo calculamos dos veces con dos métodos distintos.",
      "why": "Sustituye la magnitud por la consecuencia. Quien entrevista se entera de la gravedad y del proceso, que es lo que quería, y no se ha dicho ninguna cifra confidencial."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Tu mejor ejemplo está bajo un acuerdo de confidencialidad. ¿Cuál es el enfoque más fuerte?",
      "options": [
        { "text": "Coger otro ejemplo: no merece la pena el riesgo.", "correct": false, "note": "A veces necesario, normalmente una sobrecorrección. Tienes permiso para describir la forma de un trabajo que no puedes nombrar." },
        { "text": "Contarlo, ya que las entrevistas son privadas y no va a salir de ahí.", "correct": false, "note": "Quien entrevista es un desconocido que en ese preciso momento está decidiendo si eres cuidadoso. Esta respuesta lo resuelve, en la dirección equivocada." },
        { "text": "Decir el límite una vez, y luego describir la estructura y tus decisiones enteras.", "correct": true, "note": "Se llevan el fondo, y te ven manejar bien una confidencia. Las dos cosas a la vez, de la misma respuesta." },
        { "text": "Preguntarle a quien entrevista si le importa que lo cuentes en confianza.", "correct": false, "note": "Le pone en una posición incómoda y a ti no te da nada. Además insinúa que tu discreción es negociable, que es justo la señal equivocada." }
      ],
      "explain": "La confidencialidad no es un motivo para no tener nada que decir. Bien llevada, es una prueba gratis de exactamente el rasgo que parece estorbar."
    },
    {
      "prompt": "¿Qué parte de un proyecto confidencial casi siempre es segura de describir?",
      "options": [
        { "text": "La decisión que tenías delante y el razonamiento que usaste.", "correct": true, "note": "Tu propio criterio te pertenece. Además es la parte que quien entrevista quiere de verdad, y por eso esto funciona tan bien." },
        { "text": "La arquitectura técnica, ya que es genérica.", "correct": false, "note": "A menudo es la parte más sensible, y rara vez es tan genérica como parece desde dentro." },
        { "text": "Los resultados, mientras no nombres al cliente.", "correct": false, "note": "Las cifras identifican con frecuencia por sí solas, y los resultados suelen ser justo lo que un acuerdo de confidencialidad existe para proteger." }
      ],
      "explain": "Abstrae la identidad, conserva el criterio. El razonamiento es tuyo y es la parte que se está evaluando."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "boundary_once", "label": "Nombró el límite una vez", "description": "Dijo brevemente qué no podía comentar, y no volvió a ello una y otra vez." },
      { "key": "kept_substance", "label": "Conservó el fondo", "description": "Describió la estructura, lo que estaba en juego y las decisiones pese a la restricción." },
      { "key": "protected_identity", "label": "Protegió lo que importaba", "description": "No se dio nada identificable: ni cliente, ni cifras, ni mecanismo." },
      { "key": "no_false_boundary", "label": "El límite era real", "description": "No usó la confidencialidad para esquivar una pregunta que simplemente no le apetecía." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Karin Adeyemi",
      "role": "una responsable de contratación curiosa que no aprieta donde no debe",
      "mood": "Cálida y con curiosidad genuina por el trabajo.",
      "openness": 4,
      "personality": "Interesada y profesional. Hará una repregunta que se acerca a lo concreto sin pretenderlo, y aceptará una negativa con elegancia a la primera."
    },
    "setting": "Una entrevista en la que el trabajo reciente más relevante del candidato fue para un cliente bajo un acuerdo de confidencialidad estricto.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Haz una pregunta que se acerque a un dato concreto que la persona ha dicho que no puede dar: el cliente, una cifra, el mecanismo.",
      "Acepta cualquier negativa de inmediato y con calidez, y redirige hacia lo que sí puede contar.",
      "Si la persona ofrece por su cuenta algo que suene identificable, no la avises. Haz una repregunta natural sobre ello.",
      "Nunca comentes cómo está llevando la confidencialidad."
    ],
    "opening_beat": "«Tu CV menciona dieciocho meses en algo que solo has descrito como un programa del sector público. Esa es la parte que más me apetece oír.»",
    "success_looks_like": "La persona nombra el límite una vez, y luego da una cuenta completa de la forma del trabajo y de sus propias decisiones sin revelar nada identificable."
  }$j$::jsonb,
  'Descríbele a alguien de fuera un trabajo del que no puedes hablar del todo: la forma, lo que estaba en juego, tus decisiones, nada del detalle identificable. Apunta si salió entendiendo qué hiciste en realidad.',
  $j${
    "says": "Tu CV menciona dieciocho meses en algo que solo has descrito como un programa del sector público. Esa es la parte que más me apetece oír.",
    "model": {
      "line": "No puedo entrar en para qué servía el sistema en realidad. Lo que sí te puedo contar es que eran once organismos que nunca habían compartido datos, un plazo fijado por una ley y no por nosotros, y que mi parte fue justo aquella en la que había que ponerse de acuerdo en qué era una persona entre once definiciones distintas.",
      "why": "El límite nombrado una vez, con claridad, y luego la forma del trabajo entera. Repetir la advertencia es lo que hace sentir a quien entrevista que te lo está sacando a rastras."
    },
    "checks": [
      { "kind": "contains_any", "words": ["no puedo entrar en", "no puedo decir", "no puedo nombrar", "no puedo contar", "no voy a poder", "no estoy en condiciones de"], "requirement": "Nombra el límite una vez" },
      { "kind": "min_words", "n": 40, "requirement": "Y luego describe su forma igualmente" }
    ],
    "maxChars": 700
  }$j$::jsonb
);
