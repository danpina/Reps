-- Spanish: Small talk — the topic, its eight tracks, and the first track in
-- full.
--
-- The first translation in the app, so the decisions it fixes are worth
-- stating once here rather than repeating in every migration that follows.
--
-- **Tú, never usted.** This is a training diary somebody keeps about their own
-- week. Usted would put the app at a distance the English does not have.
--
-- **La jugada:** for "The move:". It has to be a marker the extractor knows,
-- because the rehearsal reads it out of the card — see MOVE_MARKERS. "El
-- movimiento" is the literal translation and reads like a chess manual;
-- "la jugada" is what a person would say about a thing you actually do.
--
-- **Si te quedas con una cosa:** for the closer, which is the same promise the
-- English makes and the same length.
--
-- **No gendered adjectives about the reader.** Nobody has told the app whether
-- they are nervioso or nerviosa, so the prose goes around it: "los nervios",
-- "te pones nervioso" becomes "te entran los nervios". This costs a little
-- fluency in about a dozen places across the topic and is worth it.
--
-- **Word lists are rewritten, not translated.** A drill that forbids "clay"
-- and "kiln" has to forbid "barro" and "horno"; one that wants the reader to
-- name the lift has to accept "ascensor" and "planta". These are authoring
-- decisions about Spanish, and translating them literally would produce checks
-- that no Spanish sentence could ever satisfy.
--
-- **Names are left alone.** Erin, Ruth, Malik. They are people, not text, and
-- renaming them buys nothing while creating a second thing to keep consistent.
--
-- Everything not written here stays English, per field, until it is written.

-- ---------------------------------------------------------------------------
-- The topic
-- ---------------------------------------------------------------------------

insert into public.topic_translations (topic_id, locale, name, description, promise)
select id, 'es',
  'Conversación ligera',
  $$Los dos sabéis que alguien debería decir algo. Ninguno lo hace. Este es el tema sobre decirlo.$$,
  $$Entra en una sala donde no conoces a nadie y sal de ella habiendo tenido tres conversaciones que repetirías encantado.$$
from public.topics where slug = 'small-talk'
on conflict (topic_id, locale) do update set
  name = excluded.name,
  description = excluded.description,
  promise = excluded.promise,
  updated_at = now();

-- ---------------------------------------------------------------------------
-- The eight tracks
-- ---------------------------------------------------------------------------

insert into public.skill_translations (skill_id, locale, name, description, core_idea)
select s.id, 'es', v.name, v.description, v.core_idea
from (values
  ('before-you-speak',
   'Antes de decir nada',
   $$Los veinte segundos anteriores a la primera palabra, y el pasar de largo que echa a perder una buena semana.$$,
   $$Un mal comienzo cuesta unos cuatro segundos. Decide la frase antes de necesitarla, ve en menos de veinte segundos, y que pasar de largo no sea nunca lo último que hiciste.$$),

  ('openers',
   'Cómo empezar',
   $$Arrancar una conversación desde cero, sin necesidad de ser ingenioso.$$,
   $$FORD+ — Familia, Ocupación, Ocio, Sueños, más el Entorno. Empezar por el entorno no arriesga nada y siempre está disponible.$$),

  ('going-deeper',
   'Ir más adentro',
   $$Llevar una conversación más allá del intercambio de datos.$$,
   $$La escalera de la curiosidad: dato, después emoción, después por qué o qué viene ahora. Nunca tres datos seguidos: eso es un interrogatorio.$$),

  ('listening-and-labeling',
   'Escuchar y nombrar',
   $$Hacer que alguien se sienta escuchado lo bastante como para seguir hablando.$$,
   $$Devuélvele su propia palabra en forma de afirmación, y luego calla. La gente llena los silencios.$$),

  ('reciprocity',
   'Reciprocidad: hablar de ti',
   $$Dar lo suficiente de ti para que la otra persona pueda encontrarte.$$,
   $$Preguntar y solo preguntar es su propio fracaso: se lee como evasión. Iguala la profundidad que te ofrecen y luego da un paso más.$$),

  ('exits',
   'Cómo salir',
   $$Terminar una conversación a propósito en lugar de dejar que se deshaga sola.$$,
   $$Cierre cálido y, si acaso, un gancho hacia el futuro. Salir mal deshace una buena conversación.$$),

  ('banter',
   'Broma y humor',
   $$Jugar sin pisar a nadie.$$,
   $$Exagerar la escala, retomar un chiste anterior, dramatizar lo trivial. Bromea sobre la situación antes que sobre la persona.$$),

  ('groups',
   'Grupos: entrar y tener turno',
   $$Meterse en una conversación que ya está en marcha, y ganarse un turno dentro de ella.$$,
   $$Entra en una risa o en un cambio de tema, nunca a mitad de frase. Aporta algo antes de redirigir.$$)
) as v(slug, name, description, core_idea)
join public.skills s on s.slug = v.slug
on conflict (skill_id, locale) do update set
  name = excluded.name,
  description = excluded.description,
  core_idea = excluded.core_idea,
  updated_at = now();

-- ---------------------------------------------------------------------------
-- Track 1: Antes de decir nada
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

select pg_temp.es_lesson('before-you-speak', 1,
  'Lo que cuesta de verdad un mal comienzo',
  $md$Pregúntale a alguien qué le da miedo y te dirá que el rechazo. Pregúntale qué aspecto tendría ese rechazo y te describirá una respuesta corta y a alguien que vuelve a mirar el móvil.

Ese es el suceso. Dura unos cuatro segundos y lo han olvidado antes de llegar a la caja. Tú vas a pensar en ello una hora. Ellos no van a pensar en ello en absoluto.

**La jugada:** dite el peor caso real, en voz baja y con palabras llanas, antes de hablar.

Esto no es pensamiento positivo, que no funciona. Es precisión, que sí. Tu cuerpo trata un riesgo social como trata uno físico, y en esta pregunta concreta se equivoca por un margen enorme.

Lo que importa de esa diferencia no es que te haga sentir incómodo. Es que convierte un suceso de cuatro segundos en algo que parece requerir valor — y entonces necesitas encontrar valor, en una parada de autobús, antes de las nueve de la mañana.$md$,
  $j$[
    {
      "situation": "Estás a punto de decirle algo a la persona que tienes al lado en la parada.",
      "line": "En el peor caso dice ya y vuelve a mirar el móvil.",
      "why": "Dicho para ti, no en voz alta. Nombrar el resultado real pone el número verdadero al lado del número sentido, y el sentido nunca sobrevive a la comparación."
    },
    {
      "situation": "Una conversación quedó en nada hace veinte minutos y sigues dándole vueltas.",
      "line": "Esto ya lo han olvidado. Soy el único que lo sigue sosteniendo.",
      "why": "Casi siempre cierto. La gente recuerda lo que hizo ella en un intercambio, no lo que hiciste tú, porque estaba ocupada gestionándose."
    },
    {
      "situation": "Acaba de pasar algo genuinamente incómodo y quieres irte.",
      "line": "Ha sido incómodo y ha costado cuatro segundos.",
      "why": "Lo incómodo es real. No se trata de fingir que estuvo bien, sino de ponerle el precio correcto en vez del que cotizó tu cuerpo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Dices algo, te contestan con tres palabras y se giran. ¿Cuánto tiempo lo recuerdan?",
      "options": [
        { "text": "Lo que tardan en recoger su café.", "correct": true, "note": "La respuesta honesta. Fue un intercambio anodino en un día lleno de ellos, y no sobrevivió al camino de vuelta a su mesa." },
        { "text": "El resto del día, por lo menos.", "correct": false, "note": "Ese es el tiempo que lo vas a recordar tú, y ahí está el error. Eres la única persona de la sala para quien aquello fue un acontecimiento." },
        { "text": "Te reconocerán y te evitarán la próxima vez.", "correct": false, "note": "Eso exige que te hayan clasificado. Una respuesta corta no es una clasificación: suele ser la misma respuesta corta que le dan a todo el mundo." },
        { "text": "Depende de lo malo que fuera el comienzo.", "correct": false, "note": "No depende. La diferencia entre un comienzo flojo y uno bueno aparece en si la conversación ocurre, no en lo que pasa después." }
      ],
      "explain": "El coste de un mal comienzo lo pagas casi entero tú, y casi entero en la hora siguiente, no en el momento."
    },
    {
      "prompt": "Dices algo un poco raro en una fiesta. ¿Cuánta gente se ha dado cuenta?",
      "options": [
        { "text": "Casi todos los que estaban cerca.", "correct": false, "note": "Esta es justo la creencia de la que trata la lección. La gente sobreestima cuánto de su conducta fue observado, y por muchísimo." },
        { "text": "La persona a la que se lo dijiste, y nadie más.", "correct": true, "note": "Los demás estaban a mitad de su propia conversación, gestionando su propia noche. Sentirse observado es la sensación; no estarlo es el hecho." },
        { "text": "Nadie. La gente no escucha de verdad.", "correct": false, "note": "Te has pasado de frenada. La persona con la que hablabas te oyó perfectamente, y aun así dio igual." },
        { "text": "Imposible saberlo, y por eso incomoda.", "correct": false, "note": "No es imposible. Pídele a cualquiera que te cuente algo raro que dijo otro en una fiesta el mes pasado y mira cómo no consigue dar un ejemplo." }
      ],
      "explain": "Eres la única persona de la fiesta para quien tú eres el protagonista. Los demás están protagonizando su propia noche."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "priced_it", "label": "Le pusiste precio honesto", "description": "Nombraste lo que iba a pasar de verdad, no lo que parecía." },
      { "key": "went_anyway", "label": "Hablaste después de nombrarlo", "description": "Usaste la lectura como motivo para ir, no como una cosa más que considerar." },
      { "key": "no_catastrophe", "label": "No lo inflaste", "description": "No trataste una respuesta sosa como prueba de nada." },
      { "key": "let_it_go", "label": "Dejaste de cargarlo", "description": "No pasaste la hora siguiente repasando cuatro segundos." }
    ]
  }$j$::jsonb,
  $j${
    "setting": "La zona de cajas automáticas de un supermercado a las seis de la tarde. Una máquina está estropeada y tres personas esperan para las dos que funcionan.",
    "partner": {
      "name": "Erin",
      "role": "alguien que espera delante de ti",
      "personality": "Normal y algo cansada. Ni cálida ni fría, exactamente tan implicada como una desconocida en una cola.",
      "mood": "Quiere llegar a casa.",
      "openness": 3
    },
    "opening_beat": "Erin se cambia la cesta de brazo y mira la máquina estropeada, luego la cola.",
    "success_looks_like": "La persona dice algo y descubre que el resultado, en cualquier caso, es pequeño.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca hagas de entrenador, no evalúes ni rompas la escena.",
      "Responde como respondería una desconocida cansada en una cola: breve, amable, sin hostilidad.",
      "Nunca castigues un comienzo flojo. Una respuesta sosa es lo peor que ocurre aquí.",
      "No te conviertas en su amiga en tres líneas. Esta escena trata de que el coste es pequeño, no de que salga fenomenal."
    ]
  }$j$::jsonb,
  $md$Hoy, antes de una conversación, dite el peor caso real con palabras llanas. Después ten la conversación y anota lo que pasó de verdad, al lado de lo que predijiste.$md$,
  $j${
  "beats": [
    {
      "situation": "Le dices algo a la persona que tienes al lado en una cola. Dice ya, sonríe un segundo y vuelve al móvil.",
      "prompt": "¿Qué acaba de pasar?",
      "options": [
        { "text": "No quería que le hablaran.", "correct": false, "note": "Posible, imposible de saber con una respuesta, y en cualquier caso da igual. Leer una respuesta corta como un rechazo es como un suceso de cuatro segundos se convierte en una regla." },
        { "text": "El comienzo era demasiado flojo para merecer una respuesta.", "correct": false, "note": "El comienzo rara vez es la variable. Muchísimos comienzos excelentes reciben exactamente esta respuesta de alguien que ya casi está en la caja." },
        { "text": "Nada. Así es una respuesta sosa normal.", "correct": true, "note": "Es el resultado más común y no es un veredicto sobre ti. Estaba en una cola, no haciendo una selección de conversaciones." },
        { "text": "Tendrías que haber añadido algo más.", "correct": false, "note": "Llenar el hueco después de una respuesta sosa es lo único que sí habría hecho que resultara incómodo." }
      ]
    },
    {
      "situation": "Son las nueve de la noche y sigues pensando en ello.",
      "prompt": "¿Dónde está la otra persona ahora mismo?",
      "options": [
        { "text": "Probablemente pensando que fue algo raro.", "correct": false, "note": "La gente recuerda su propia conducta en un intercambio, no la tuya. Si recuerda algo, es lo que dijo ella." },
        { "text": "Contándoselo a alguien.", "correct": false, "note": "No pasó nada. No hay historia en que un desconocido diga algo normal en una cola." },
        { "text": "Imposible de saber.", "correct": false, "note": "Técnicamente cierto y prácticamente inútil. Pídele a cualquiera que describa a un desconocido que le habló de forma rara el mes pasado y mira cómo falla." },
        { "text": "No pensando en ello, y no lo ha hecho desde la cola.", "correct": true, "note": "Es casi seguro que sea así y es el único dato que importa. Para esa persona el intercambio duró cuatro segundos; para ti lleva cinco horas." }
      ]
    }
  ]
}$j$::jsonb);
