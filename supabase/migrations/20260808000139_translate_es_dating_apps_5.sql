-- Spanish: Apps de citas, track 5 — Dónde se está rompiendo.
--
-- Conventions as prior tracks: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Sam" again carries no `sex` field; masculine agreement used by
-- default, as in track 4.

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

select pg_temp.es_lesson('where-it-is-breaking', 1,
  'Cuenta antes de concluir',
  $md$Cuatro meses de esfuerzo, ni idea de qué falla, y un perfil reescrito seis veces. Este es el estado estándar, y lo causa una sola cosa: nadie está midiendo.

**La jugada:** apunta cuatro semanas de números reales antes de cambiar nada.

Deslizamientos, matches, conversaciones que pasaron de dos intercambios, citas organizadas, citas que pasaron de verdad. Cinco números, guardados en una nota del móvil, que llevan unos diez segundos a la semana.

Suena aburrido y es justo lo contrario, porque la alternativa es peor. Sin números estás trabajando a partir de una sensación, y la sensación la genera sobre todo lo último que pasó — una buena semana se lee como *esto ya está funcionando* y un silencio se lee como *necesito fotos nuevas*. Ninguna de las dos es cierta y las dos producen acción.

Lo que hacen los números es localizar la rotura. Hay cuatro uniones en esto — match, respuesta, quedada organizada, cita que pasa — y que falle cada una significa algo completamente distinto y necesita un arreglo distinto. Adivinar cuál está rota tiene más o menos una posibilidad entre cuatro de acertar, y la gente no adivina al azar: adivina el perfil, siempre, porque es la parte que se puede trabajar sin hablar con nadie.

El valor concreto para alguien callado es que medir sustituye a rumiar. Diez segundos contando es un uso mucho mejor de un domingo por la noche que una hora releyendo una conversación, y produce algo sobre lo que puedes actuar en vez de un estado de ánimo.

Cuatro semanas es el mínimo que significa algo. Una semana es ruido — los números aquí son lo bastante pequeños como para que un solo match distorsione todo, que es exactamente por lo que una semana que se sintió terrible no es prueba de un problema y una semana que se sintió genial no es prueba de un arreglo.

Si te quedas con una cosa: cinco números, cuatro semanas, y entonces decides. Has estado arreglando la parte a la que podías llegar en vez de la parte que estaba rota.$md$,
  $j$[
    {
      "situation": "Cuatro meses después y el perfil se ha reescrito seis veces.",
      "line": "(nadie está midiendo)",
      "why": "Sin números estás trabajando a partir de una sensación, y la sensación la genera lo último que pasó. Señala de forma fiable al perfil porque es la parte a la que puedes llegar."
    },
    {
      "situation": "Has tenido una semana terrible.",
      "line": "(una semana es ruido)",
      "why": "Los números son lo bastante pequeños como para que un solo match distorsione todo. Una mala semana no es prueba de un problema y una buena no es prueba de un arreglo."
    },
    {
      "situation": "Estás a punto de pasarte el domingo por la noche releyendo una conversación.",
      "line": "(cuenta en su lugar — diez segundos)",
      "why": "Medir sustituye a rumiar, y produce algo sobre lo que puedes actuar en vez de un estado de ánimo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué todo el mundo optimiza su perfil?",
      "options": [
        { "text": "Porque suele ser el problema.", "correct": false, "note": "A menudo está bien. Tiene más o menos una posibilidad entre cuatro de ser la unión rota." },
        { "text": "Porque es la parte que puedes trabajar sin hablar con nadie.", "correct": true, "note": "La gente no adivina al azar. Adivina lo que puede editar desde el sofá, que es por lo que las mismas fotos se cambian seis veces en cuatro meses." },
        { "text": "Porque es lo primero que ve cualquiera.", "correct": false, "note": "Cierto, y explica por qué importa, no por qué se lleva toda la atención." },
        { "text": "Porque todo el mundo dice que las fotos lo son todo.", "correct": false, "note": "Muy repetido, y se repite porque es accionable, no porque siempre sea la culpa." }
      ],
      "explain": "Cuatro uniones, cuatro arreglos distintos. Adivinar acierta una de cada cuatro, y la gente no adivina de forma equilibrada."
    },
    {
      "prompt": "¿Por qué cuatro semanas y no una?",
      "options": [
        { "text": "Porque necesitas una muestra grande.", "correct": false, "note": "Cuatro semanas tampoco es una muestra grande. El motivo es más estrecho que la estadística." },
        { "text": "Porque el comportamiento cambia cuando empiezas a medir.", "correct": false, "note": "A veces pasa, y eso es motivo para seguir midiendo, no para medir más tiempo antes de empezar." },
        { "text": "Porque los números son lo bastante pequeños como para que un match distorsione todo.", "correct": true, "note": "Que es exactamente por lo que una semana que se sintió terrible no es prueba de un problema, y una que se sintió genial no es prueba de un arreglo." },
        { "text": "Porque tarda eso en cambiar cualquier cosa.", "correct": false, "note": "Algunos arreglos tardan una tarde. La espera es sobre la lectura, no sobre hacerlo." }
      ],
      "explain": "Cinco números, cuatro semanas, y entonces decides."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "counted", "label": "Contó de verdad", "description": "Apuntó números en vez de trabajar a partir de una sensación." },
      { "key": "all_joins", "label": "Contó cada unión", "description": "Matches, respuestas, quedadas organizadas y citas que pasaron — no solo matches." },
      { "key": "waited", "label": "Esperó cuatro semanas", "description": "No actuó a partir de una semana de ruido." },
      { "key": "no_guessing", "label": "No adivinó el perfil", "description": "Se contuvo de reescribir nada hasta tener una lectura." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo que lleva años usando estas aplicaciones",
      "mood": "Práctico.",
      "openness": 5,
      "personality": "Pide números en cada etapa y no acepta impresiones. Señala cuando una respuesta es una sensación y no un recuento."
    },
    "setting": "Un amigo te ha preguntado qué tal va y has dicho que no funciona y que no sabes por qué.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pide un número en cada etapa y señala cuando te dan una impresión en su lugar.",
      "Alégrate ante una decisión de contar durante un mes.",
      "Nunca sugieras cuál podría ser el problema."
    ],
    "opening_beat": "«Vale — ¿cuántos matches el mes pasado? ¿Y cuántos de esos dijeron algo?»",
    "success_looks_like": "La persona reconoce que no tiene números y decide contar."
  }$j$::jsonb,
  'Hoy, empieza una nota con cinco números dentro: deslizamientos, matches, conversaciones reales, citas organizadas, citas que pasaron. Apunta las de esta semana.',
  $j${
    "beats": [
      {
        "situation": "Cuatro meses después. No funciona, no sabes por qué, y has reescrito el perfil seis veces.",
        "prompt": "¿Qué falta?",
        "options": [
          { "text": "Mejores fotos.", "correct": false, "note": "Puede. Tienes una posibilidad entre cuatro de que esa sea la unión rota, y la gente no adivina de forma equilibrada — adivina la parte que puede editar desde el sofá." },
          { "text": "Números.", "correct": true, "note": "Sin ellos estás trabajando a partir de una sensación generada por lo último que pasó, y esa sensación señala de forma fiable al perfil." },
          { "text": "Paciencia.", "correct": false, "note": "Cuatro meses no es impaciencia. Son cuatro meses actuando a partir de impresiones." },
          { "text": "Más deslizamientos.", "correct": false, "note": "Puede ser la respuesta, y todavía no lo puedes saber, que es el quid de la cuestión." }
        ]
      },
      {
        "situation": "Has tenido una semana terrible y estás a punto de cambiar tu foto principal.",
        "prompt": "¿Es eso suficiente para actuar?",
        "options": [
          { "text": "Sí — una mala semana es un dato.", "correct": false, "note": "Los números son lo bastante pequeños como para que un solo match distorsione todo. Una semana es ruido en las dos direcciones." },
          { "text": "Sí, si se sintió notablemente peor de lo normal.", "correct": false, "note": "Sentirse peor de lo normal es exactamente la señal que no es fiable aquí." },
          { "text": "No — pero cámbialo igualmente, no cuesta nada.", "correct": false, "note": "Cuesta la lectura. Cambia algo ahora y no vas a saber qué produjo lo que pase después." },
          { "text": "No. Cuatro semanas, y entonces decides.", "correct": true, "note": "Una semana que se sintió terrible no es prueba de un problema, y una que se sintió genial no es prueba de un arreglo." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('where-it-is-breaking', 2,
  'Sin matches',
  $md$Si los números dicen que casi nadie hace match, esta es la única vez en que la respuesta de verdad es el perfil — y en concreto, dos partes de él.

**La jugada:** cambia la primera foto y la primera línea, y no cambies nada más.

La primera foto hace casi todo el trabajo, porque la decisión se toma en unos dos segundos y la mayoría se toman solo con esa imagen. Si es una foto de grupo, una a distancia, con gafas de sol, o cualquier cosa que requiera identificación, cámbiala por una foto en solitario, clara y reciente de tu cara, y no cambies nada más durante dos semanas.

La primera línea es lo segundo, e importa más que el prompt ingenioso del final, al que un buen porcentaje de la gente nunca llega a desplazarse. Tiene un solo trabajo — poder responderse — y eso es el primer bloque de este tema resumido en una frase.

Luego cambia una cosa cada vez. El instinto universal en un mes malo es reescribirlo todo, lo que garantiza que no aprendas nada: algo mejora, no tienes ni idea de qué, y vuelves a adivinar el mes que viene. Un cambio, dos semanas, mira el número.

Dos cosas merece la pena descartar primero, porque son aburridas y a menudo son la respuesta entera. Revisa tus ajustes — distancia, rango de edad, y si la aplicación te ha limitado en silencio a quién le apareces. Y revisa tu volumen: alguna gente con un problema real de matches está deslizando veinte veces a la semana, que no son suficientes intentos como para que ningún perfil demuestre nada.

Y si las fotos son de verdad buenas, la posibilidad honesta es que esta sea la aplicación equivocada para ti, o la ciudad equivocada, o un mercado local muy escaso. Eso no es un fallo oculto que se vaya a descubrir reescribiendo la biografía por séptima vez.

Si te quedas con una cosa: la primera foto, y luego espera dos semanas. Un cambio cada vez es la única forma de saber alguna vez qué funcionó.$md$,
  $j$[
    {
      "situation": "Casi nadie está haciendo match.",
      "line": "(primera foto, primera línea, nada más)",
      "why": "La decisión se toma en unos dos segundos y sobre todo con la imagen. No se llega al prompt ingenioso del final."
    },
    {
      "situation": "Estás a punto de reescribir todo el perfil.",
      "line": "(un cambio, dos semanas)",
      "why": "Reescribirlo todo garantiza que no aprendas nada — algo mejora, no tienes ni idea de qué, y vuelves a adivinar el mes que viene."
    },
    {
      "situation": "Las fotos son de verdad buenas y sigue estando plano.",
      "line": "(revisa primero los ajustes y el volumen)",
      "why": "La distancia, el rango de edad y veinte deslizamientos a la semana son explicaciones aburridas y a menudo son la respuesta entera."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué parte del perfil decide esto de verdad?",
      "options": [
        { "text": "Los prompts del final.", "correct": false, "note": "Un buen porcentaje de la gente nunca llega a desplazarse hasta ellos. Importan después de un match, no antes." },
        { "text": "Todo el conjunto junto.", "correct": false, "note": "La respuesta cómoda, y es lo que produce reescrituras totales que no te enseñan nada." },
        { "text": "La primera foto, y luego la primera línea.", "correct": true, "note": "Unos dos segundos, sobre todo con la imagen. Todo lo demás se decide después de eso." },
        { "text": "Cuántas fotos tienes.", "correct": false, "note": "Cuatro buenas ganan a seis de cualquier cosa, y la cantidad no es lo que falla aquí." }
      ],
      "explain": "Cambia una cosa y dale dos semanas."
    },
    {
      "prompt": "¿Qué merece la pena descartar antes de tocar nada?",
      "options": [
        { "text": "Tus ajustes y tu volumen.", "correct": true, "note": "Distancia, rango de edad, si la aplicación te ha limitado el alcance en silencio — y si veinte deslizamientos a la semana son sencillamente demasiado pocos intentos como para que ningún perfil demuestre nada." },
        { "text": "Si merece la pena usar la aplicación.", "correct": false, "note": "Una pregunta para dentro de seis meses, no para un mes plano con los ajustes sin revisar." },
        { "text": "Si tus expectativas son realistas.", "correct": false, "note": "Eso era el bloque anterior. Aquí ya tienes números que dicen que algo está genuinamente bajo." },
        { "text": "Nada — empieza por las fotos.", "correct": false, "note": "Revisar los ajustes tarda un minuto y a menudo es la respuesta entera, lo que hace que merezca la pena hacerlo primero." }
      ],
      "explain": "Explicaciones aburridas primero. Son baratas de revisar y a menudo son todo el asunto."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "one_change", "label": "Cambió una cosa", "description": "No lo reescribió todo de golpe." },
      { "key": "right_part", "label": "Cambió la parte que importa", "description": "La primera foto y la primera línea en vez del final del perfil." },
      { "key": "waited", "label": "Le dio dos semanas", "description": "Dejó que el cambio produjera una lectura." },
      { "key": "ruled_out", "label": "Revisó las causas aburridas", "description": "Ajustes y volumen antes que el contenido." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo repasando los números contigo",
      "mood": "Concentrado.",
      "openness": 5,
      "personality": "Lee el embudo de arriba abajo y se para en la primera unión que parece rota, y luego pregunta qué va a cambiar en concreto."
    },
    "setting": "Cuatro semanas de números: unos seiscientos deslizamientos, once matches. Las conversaciones que sí empezaron fueron bien.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pregunta qué es esa única cosa que va a cambiar, si la respuesta es todo.",
      "Pregunta por los ajustes y el volumen de deslizamientos antes que por el contenido.",
      "Nunca sugieras una foto o una línea concretas."
    ],
    "opening_beat": "«Once de seiscientos. ¿Y las que sí hicieron match fueron bien, dijiste?»",
    "success_looks_like": "La persona identifica el principio del embudo y elige un cambio concreto."
  }$j$::jsonb,
  'Hoy, cambia una cosa al principio de tu perfil y apunta la fecha. Apunta qué cambiaste y cuándo lo vas a mirar.',
  $j${
    "beats": [
      {
        "situation": "Cuatro semanas de números: seiscientos deslizamientos, once matches. Las conversaciones que sí empezaron fueron bien.",
        "prompt": "¿Qué unión está rota?",
        "options": [
          { "text": "La primera — el match.", "correct": true, "note": "Todo lo que va después está funcionando. Once de seiscientos es la unión que hay que mirar, y es la única vez en que la respuesta de verdad es el perfil." },
          { "text": "Las aperturas — once matches deberían producir más.", "correct": false, "note": "Has dicho que las conversaciones fueron bien. Esa unión está funcionando." },
          { "text": "El volumen — seiscientos no son muchos.", "correct": false, "note": "Merece la pena revisarlo, y seiscientos es un mes razonable. Si fueran sesenta, esta sería la respuesta." },
          { "text": "Imposible de saber con estos números.", "correct": false, "note": "Esto es exactamente para lo que sirven los números. Una unión está visiblemente fuera de línea respecto al resto." }
        ]
      },
      {
        "situation": "Has decidido que el problema es el perfil.",
        "prompt": "¿Qué cambias?",
        "options": [
          { "text": "Todo — empieza de cero como es debido.", "correct": false, "note": "Entonces algo mejora y no tienes ni idea de qué. Vuelves a adivinar el mes que viene." },
          { "text": "Los prompts, para que haya más a lo que responder.", "correct": false, "note": "Importan después de un match. Un buen porcentaje de la gente nunca llega tan lejos." },
          { "text": "La primera foto. Nada más, durante dos semanas.", "correct": true, "note": "La decisión se toma en unos dos segundos y sobre todo con esa imagen. Un cambio cada vez es la única forma de saber qué funcionó." },
          { "text": "Añade más fotos.", "correct": false, "note": "Cuatro buenas ganan a seis de cualquier cosa, y la cantidad no es lo que falla aquí." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('where-it-is-breaking', 3,
  'Hay matches, pero nadie habla',
  $md$Llegan matches y no pasa nada. Este es fácil de malinterpretar, porque se siente como el mismo fracaso que no tener matches y no lo es — tu perfil está funcionando. Algo posterior no.

**La jugada:** averigua si de verdad les estás escribiendo, y qué pinta tiene lo que escribes.

Dos preguntas, en orden.

**¿Estás mandando algo de verdad?** Un número sorprendente de gente con esta misma queja tiene una lista de matches y ha abierto tres de ellos. Eso no es un problema de estrategia, es el pavor haciendo su trabajo — y merece la pena ser honesto al respecto, porque el arreglo no es un mensaje mejor, es mandar uno siquiera.

**Si estás mandando, ¿qué son?** Lee los últimos diez. Si se le podrían haber mandado a cualquiera, esa es toda la respuesta, y el segundo bloque de este tema es el arreglo. *Hola*, *qué tal la semana*, y cualquier cosa sobre el tiempo caen todas en esta categoría, por muy cálidamente que estén escritas.

El otro lado merece la pena revisarlo también. Los matches donde ellos abrieron y tú nunca respondiste son el mismo fracaso con ropa distinta, y son fáciles de perder de vista cuando la aplicación entierra una conversación al cabo de dos días.

Y hay un elemento de tiempo que a la gente se le pasa: el primer día importa desproporcionadamente. Un match respondido en un día es una conversación viva; un match respondido una semana después es un desconocido escribiéndole a alguien que ya se ha olvidado de haber deslizado a la derecha. Si tu hueco fijo del bloque anterior es una vez por semana, esta es la unión que te cuesta, y merece la pena añadir un saludo corto específicamente para matches nuevos.

Si te quedas con una cosa: lee tus últimas diez aperturas. Si alguna se le podría haber mandado a cualquiera, ya lo has encontrado.$md$,
  $j$[
    {
      "situation": "Muchos matches y ninguna conversación.",
      "line": "(¿estás mandando algo?)",
      "why": "Un número sorprendente de gente con esta misma queja ha abierto tres de sus matches. Eso es pavor, no estrategia, y el arreglo es mandar uno siquiera."
    },
    {
      "situation": "Estás mandando, y no vuelve nada.",
      "line": "(lee los últimos diez)",
      "why": "Si se le podrían haber mandado a cualquiera, esa es toda la respuesta — por muy cálidamente que estén escritas."
    },
    {
      "situation": "Revisas la aplicación una vez por semana.",
      "line": "(eso te está costando esta unión)",
      "why": "Un match respondido en un día es una conversación viva. Una semana después eres un desconocido escribiéndole a alguien que se ha olvidado de haber deslizado a la derecha."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Qué hay que revisar primero?",
      "options": [
        { "text": "Si tus aperturas son lo bastante interesantes.", "correct": false, "note": "Segundo. Mucha gente con esta queja no ha mandado nada cuya calidad revisar." },
        { "text": "Si estás mandando algo siquiera.", "correct": true, "note": "Un número sorprendente tiene una lista de matches y ha abierto tres. Eso es el pavor haciendo su trabajo, y ninguna apertura lo arregla." },
        { "text": "Si son cuentas reales.", "correct": false, "note": "La explicación que te quita a ti la responsabilidad, y rara vez es la causa principal." },
        { "text": "Si hiciste match con la gente correcta.", "correct": false, "note": "Te gustaron lo bastante como para deslizar. Volver a juzgar eso es una forma de no mandar nada." }
      ],
      "explain": "No mandar nada y mandar mal se ven idénticos en los números y necesitan arreglos opuestos."
    },
    {
      "prompt": "¿Por qué importa tanto el primer día aquí?",
      "options": [
        { "text": "Van a hacer match con otra persona.", "correct": false, "note": "Puede, y lo plantea como una carrera. El motivo real es sobre la memoria, no sobre la competencia." },
        { "text": "La aplicación despriorizador los matches viejos.", "correct": false, "note": "Los mecanismos varían y no son algo con lo que puedas contar." },
        { "text": "Una semana después eres un desconocido escribiéndole a alguien que se ha olvidado de ti.", "correct": true, "note": "Un match respondido en un día es una conversación viva. El mismo mensaje una semana después tiene que presentarse de nuevo antes de poder hacer nada." },
        { "text": "Vas a perder los nervios.", "correct": false, "note": "A menudo cierto, y es un problema distinto, que se soluciona teniendo un hueco fijo siquiera." }
      ],
      "explain": "Si tu hueco es semanal, añade un saludo corto específicamente para matches nuevos."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "checked_sending", "label": "Revisó si estaba mandando", "description": "Estableció primero la base honesta." },
      { "key": "read_ten", "label": "Leyó los últimos diez", "description": "Miró lo que de verdad se mandó en vez de recordarlo." },
      { "key": "specific", "label": "Encontró los genéricos", "description": "Identificó aperturas que se le podrían haber mandado a cualquiera." },
      { "key": "timing", "label": "Arregló el tiempo", "description": "Respondió a los matches nuevos en menos de un día." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo repasando los números contigo",
      "mood": "Concentrado.",
      "openness": 5,
      "personality": "Pide ver los mensajes reales en vez de una descripción de ellos, y pregunta cuántos matches se llegaron a abrir siquiera."
    },
    "setting": "Cuatro semanas de números: sesenta matches, cuatro conversaciones que pasaron de dos intercambios.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pide el número de mensajes realmente mandados antes de hablar de su calidad.",
      "Pregunta qué decían los últimos, en concreto.",
      "Nunca escribas una apertura por la persona."
    ],
    "opening_beat": "«Sesenta matches, cuatro conversaciones. ¿A cuántos de los sesenta les escribiste?»",
    "success_looks_like": "La persona establece si el problema es mandar o lo que se manda."
  }$j$::jsonb,
  'Hoy, lee los últimos diez mensajes de apertura que mandaste. Apunta cuántos se le podrían haber mandado a cualquiera.',
  $j${
    "says": "Sesenta matches, cuatro conversaciones. ¿A cuántos de los sesenta les escribiste de verdad?",
    "model": {
      "line": "A nueve, creo. Así que en realidad no son las aperturas, ¿no? — es que no las estoy mandando.",
      "why": "La base honesta primero. No mandar nada y mandar mal se ven idénticos en los números y necesitan arreglos opuestos, y ninguna mejora a una apertura ayuda si no hay ninguna."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["la mayoría", "bastantes", "un buen número", "un montón", "no muchos la verdad", "difícil de decir", "creo que la mayoría"], "requirement": "Responde con un número, no con una impresión" },
      { "kind": "min_words", "n": 8, "requirement": "Di el número y qué significa" },
      { "kind": "max_words", "n": 40, "requirement": "Una lectura, no un ensayo" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('where-it-is-breaking', 4,
  'Conversaciones que se apagan',
  $md$Aquí es donde se rompe todo con más frecuencia, y es la unión más difícil de ver, porque una conversación apagándose no se siente como un fracaso — se siente como el tiempo que hace.

No pasa nada malo. Las respuestas se hacen más lentas. Un mensaje se queda sin responder un miércoles y a ninguno de los dos le importa. Dos semanas después se acabó, y de verdad es difícil señalar un momento en el que alguien decidiera algo.

**La jugada:** revisa si alguna vez propusiste algo de verdad, con un día fijado.

Esa es casi siempre la respuesta, y casi siempre es incómodo descubrirlo, porque significa que el apagón no fue algo que te pasó a ti. Repasa tus últimas cinco conversaciones y cuenta en cuántas nombraste un lugar y un día. Si el número es cero o uno, has encontrado la unión, y ninguna mejora a tu forma de escribir la va a tocar.

La segunda versión es proponer sin un día — *deberíamos tomar algo un día de estos* — que produce *sí, claro que sí* y nada más. Eso no es una propuesta, y las dos personas salen del intercambio creyendo que se ha organizado algo, que es por lo que puede pasar cuatro veces seguidas sin que nadie se dé cuenta.

El momento importa tanto como el hecho de preguntar. Unos días de buenos intercambios es el momento; dos semanas de ellos es el apagón ya en marcha. Cada mensaje gasta un poco del interés que os juntó y ninguno lo repone, que es por lo que una conversación que ha sido excelente durante tres semanas suele estar más acabada que una que ha estado bien durante tres días.

Y la nota honesta para alguien callado: esta es la unión donde el pavor hace más daño en todo el tema. Escribir mensajes es cómodo, proponer no lo es, y es del todo posible pasarse seis meses siendo muy bueno en la parte cómoda sin hacer ni una vez lo que produce una cita.

Si te quedas con una cosa: cuenta tus últimas cinco conversaciones buscando un día nombrado. Ese número es tu verdadero problema de conversión.$md$,
  $j$[
    {
      "situation": "Cinco conversaciones, todas apagadas, ninguna mal.",
      "line": "(cuenta en cuántas nombraste un día)",
      "why": "Casi siempre es la respuesta, e incómodo de encontrar, porque significa que el apagón no fue algo que te pasó a ti."
    },
    {
      "situation": "Dijiste deberíamos tomar algo un día de estos.",
      "line": "(eso no es una propuesta)",
      "why": "Produce sí, claro que sí y nada más, y las dos personas salen creyendo que se organizó algo — que es por lo que puede pasar cuatro veces seguidas."
    },
    {
      "situation": "Tres semanas excelentes de mensajes.",
      "line": "(más acabada que tres días buenos)",
      "why": "Cada mensaje gasta un poco del interés que os juntó, y ninguno lo repone."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué esta unión es la más difícil de ver?",
      "options": [
        { "text": "Porque las aplicaciones esconden las conversaciones viejas.", "correct": false, "note": "Una molestia, y de todas formas tampoco podrías señalar el momento en que terminó." },
        { "text": "Porque un apagón se siente como el tiempo que hace, no como un fracaso.", "correct": true, "note": "No pasa nada malo, las respuestas se hacen más lentas, y de verdad es difícil señalar un momento en el que alguien decidiera algo." },
        { "text": "Porque las dos personas son igual de responsables.", "correct": false, "note": "Un planteamiento cómodo, y es el que impide que la gente revise su propio recuento." },
        { "text": "Porque pasa despacio.", "correct": false, "note": "La velocidad no es el problema. Es la ausencia de cualquier decisión identificable." }
      ],
      "explain": "Cuenta las conversaciones en las que nombraste un día. Ese número es el problema de conversión."
    },
    {
      "prompt": "¿Por qué una conversación de tres semanas convierte peor a menudo que una de tres días?",
      "options": [
        { "text": "Sabéis demasiado el uno del otro.", "correct": false, "note": "Rara vez es el problema, y conocerse suele ayudar." },
        { "text": "Uno de los dos ha perdido el interés para entonces.", "correct": false, "note": "Circular — eso es lo que se está explicando, no la explicación." },
        { "text": "Cada mensaje gasta interés y ninguno lo repone.", "correct": true, "note": "Que es por lo que una conversación excelente durante tres semanas suele estar más acabada que una que ha estado bien durante tres días." },
        { "text": "Se pasa la novedad.", "correct": false, "note": "La misma observación con menos precisión, y no te dice cuándo actuar." }
      ],
      "explain": "Unos días buenos es el momento. Dos semanas de ellos es el apagón ya en marcha."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "counted", "label": "Contó las propuestas", "description": "Revisó cuántas conversaciones contenían un día nombrado." },
      { "key": "honest", "label": "Fue honesto al respecto", "description": "Aceptó que el apagón no fue algo que le pasó." },
      { "key": "a_day", "label": "Propuso con un día", "description": "Dejó de tratar un día de estos como una petición." },
      { "key": "timing", "label": "Se movió antes", "description": "Propuso en días en vez de en semanas." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo repasando los números contigo",
      "mood": "Directo.",
      "openness": 5,
      "personality": "Pregunta en cuántas de las catorce hubo una propuesta real con un día fijado, y espera un recuento de verdad."
    },
    "setting": "Cuatro semanas de números: catorce conversaciones reales, ninguna cita organizada. Todas se apagaron de forma agradable.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Pide un número y no aceptes una descripción de cómo se sintieron las conversaciones.",
      "Trata deberíamos hacer algo como que no cuenta, y dilo si sale el tema.",
      "Nunca le digas a la persona qué mandar."
    ],
    "opening_beat": "«Catorce conversaciones, ninguna cita. ¿En cuántas nombraste un día de verdad?»",
    "success_looks_like": "La persona cuenta con honestidad e identifica la propuesta que falta."
  }$j$::jsonb,
  'Hoy, mira las últimas cinco que tuviste y cuenta cuántas contenían un día real nombrado. Apunta el número.',
  $j${
    "says": "Catorce conversaciones, ninguna cita. ¿En cuántas nombraste un día de verdad?",
    "model": {
      "line": "Una. Y hasta esa fue un a lo mejor deberíamos un día de estos, así que en realidad, ninguna.",
      "why": "El recuento que menos ganas da de hacer, y casi siempre es la respuesta. También significa que el apagón no fue algo que le pasó a la persona."
    },
    "checks": [
      { "kind": "forbids_any", "words": ["algunas", "unas cuantas", "la mayoría", "varias", "difícil de decir", "depende", "se apagaron sin más", "perdieron el interés"], "requirement": "Cuenta, no describas" },
      { "kind": "min_words", "n": 6, "requirement": "Di el número" },
      { "kind": "max_words", "n": 35, "requirement": "Corto y honesto" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('where-it-is-breaking', 5,
  'Hay citas, pero no segundas citas',
  $md$Si los números dicen que haces match, hablas y quedas con gente, y nada de eso se convierte en una segunda cita, entonces este tema ya no tiene nada más que ofrecerte — y decirlo es más útil que otra lección sobre fotografías.

**La jugada:** deja de trabajar en la aplicación, y vete a trabajar en las dos horas.

Merece la pena ser firme con esto, porque la tentación va en la otra dirección. La aplicación es la parte que tiene ajustes, números y un botón de editar, así que es donde la gente lleva un problema que vive en un sitio completamente distinto — y reescribir un perfil que ha producido citas de forma demostrable es una de las formas más comunes de perder un año.

El diagnóstico es limpio. Hacer match significa que el perfil funciona. Las conversaciones significan que la mensajería funciona. Las citas organizadas significan que pedir funciona. Tres uniones seguidas funcionando no es un sitio donde buscar un fallo. Lo que sea que esté pasando está pasando en una sala, en persona, durante unas dos horas — que es una habilidad completamente distinta de todo lo de este tema, y es el asunto de La primera cita.

Merece la pena separar dos posibilidades antes de irte, porque necesitan cosas distintas. Si no se convierten en segundas citas porque *tú* no querías una, la aplicación está funcionando perfectamente y te está presentando a gente que no encaja — que es un problema más lento sobre a quién eliges, no un problema de habilidad en absoluto. Si no se convierten en segundas citas porque *ellos* no querían una, eso son las dos horas, y se puede aprender de una forma que la gente asume que no.

Las revisiones poco glamurosas van primero de todas formas: ¿estás proponiendo la segunda?, ¿y lo estás haciendo mientras la primera sigue fresca? Un número sorprendente de gente que cree que sus citas van mal sencillamente no está preguntando después, que es el mismo apagón una etapa más adelante.

Si te quedas con una cosa: tres uniones funcionando significa que el problema no está aquí. Ve a leer el otro tema.$md$,
  $j$[
    {
      "situation": "Match, conversación, quedada — y ninguna segunda cita.",
      "line": "(tres uniones funcionando significa que no es la aplicación)",
      "why": "Hacer match significa que el perfil funciona, las conversaciones que la mensajería funciona, las citas que pedir funciona. No es un sitio donde buscar un fallo."
    },
    {
      "situation": "Estás a punto de reescribir el perfil otra vez.",
      "line": "(ha producido citas de forma demostrable)",
      "why": "La aplicación tiene ajustes y un botón de editar, así que la gente le lleva problemas que viven en otro sitio. Es una de las formas más comunes de perder un año."
    },
    {
      "situation": "No le has pedido una segunda cita a ninguno de ellos.",
      "line": "(eso es el apagón, una etapa después)",
      "why": "Un número sorprendente de gente que cree que sus citas van mal sencillamente no está preguntando después."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "Tres uniones funcionando y la cuarta fallando. ¿Dónde está el problema?",
      "options": [
        { "text": "En algún sitio del perfil, todavía.", "correct": false, "note": "Ha producido matches, conversaciones y citas. Eso es un perfil que funciona por cualquier medida disponible." },
        { "text": "En las dos horas, que es otro tema.", "correct": true, "note": "Lo que sea que esté pasando está pasando en una sala, en persona — una habilidad completamente distinta de todo lo de aquí, y el asunto de La primera cita." },
        { "text": "En con quién estás haciendo match.", "correct": false, "note": "Una de las dos posibilidades, y solo si eres tú quien no quiere una segunda cita. Merece la pena separarlas en vez de asumir." },
        { "text": "En ningún sitio — así son las cosas.", "correct": false, "note": "Se puede aprender, y tratarlo como suerte es cómo la gente se queda atascada en esta unión durante años." }
      ],
      "explain": "La aplicación es la parte que tiene un botón de editar, que es por lo que se le llevan problemas de otro sitio."
    },
    {
      "prompt": "¿Qué merece la pena revisar antes de irte?",
      "options": [
        { "text": "Si te lo pasaste bien en las citas.", "correct": false, "note": "Un número sorprendente de gente que cree que sus citas van mal sencillamente no está preguntando después — el mismo apagón, una etapa más adelante." },
        { "text": "Si tus fotos se parecen a ti en persona.", "correct": false, "note": "Merece la pena en general, y no explica un patrón que sobrevive a tres uniones funcionando." },
        { "text": "Si estás proponiendo la segunda cita siquiera.", "correct": true, "note": "Un número sorprendente de gente que cree que sus citas van mal sencillamente no está preguntando después." },
        { "text": "Si estás eligiendo los sitios equivocados.", "correct": false, "note": "De verdad importa, y es una pregunta de primera cita, que es a donde te está mandando esta lección de todas formas." }
      ],
      "explain": "Pregunta, y pregunta mientras la noche todavía está fresca. Luego ve a leer el otro tema."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "diagnosed", "label": "Diagnosticó correctamente", "description": "Reconoció tres uniones funcionando y dejó de buscar aquí." },
      { "key": "stopped_editing", "label": "Dejó de editar el perfil", "description": "No le llevó a la aplicación un problema en persona." },
      { "key": "separated", "label": "Separó los dos casos", "description": "Distinguió no querer una de no que se la ofrecieran." },
      { "key": "asked", "label": "Revisó si estaba preguntando", "description": "Se aseguró de que la segunda cita se propusiera de verdad." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Sam",
      "role": "un amigo repasando los números contigo",
      "mood": "Divertido cuando la respuesta es el perfil.",
      "openness": 5,
      "personality": "Lee el embudo de arriba abajo, nota que todo funciona hasta la última unión, y pregunta qué piensa cambiar la persona."
    },
    "setting": "Cuatro semanas de números: muchos matches, buenas conversaciones, cinco primeras citas organizadas, cuatro de ellas pasaron, ninguna llevó a una segunda.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Señala qué uniones están funcionando cada vez que la persona proponga un arreglo del lado de la aplicación.",
      "Pregunta si propuso una segunda cita siquiera.",
      "Nunca diagnostiques tú el problema en persona."
    ],
    "opening_beat": "«Cuatro citas en un mes. Entonces, ¿qué exactamente piensas arreglar en la aplicación?»",
    "success_looks_like": "La persona reconoce que el problema no está en este tema."
  }$j$::jsonb,
  'Hoy, averigua cuál de tus cuatro uniones está fallando de verdad. Apunta la unión, y qué vas a hacer al respecto.',
  $j${
    "beats": [
      {
        "situation": "Un mes de números: muchos matches, buenas conversaciones, cinco citas organizadas, cuatro pasaron, ninguna llevó a una segunda.",
        "prompt": "¿Qué arreglas?",
        "options": [
          { "text": "El perfil — claramente algo falla.", "correct": false, "note": "Ha producido matches, conversaciones y cuatro citas en un mes. Eso es un perfil que funciona por cualquier medida disponible." },
          { "text": "Nada de aquí. El problema está en las dos horas.", "correct": true, "note": "Tres uniones seguidas funcionando no es un sitio donde buscar un fallo. Lo que sea que esté pasando está pasando en una sala, que es otro tema por completo." },
          { "text": "Con quién estás haciendo match.", "correct": false, "note": "Una de las dos posibilidades, y solo si eres tú quien no quiere una segunda. Merece la pena separarlas en vez de asumir." },
          { "text": "Queda con ellos antes, antes de que la mensajería se enfríe.", "correct": false, "note": "Ya estás quedando con ellos. Esa unión funciona." }
        ]
      },
      {
        "situation": "Antes de ir a trabajar en la parte en persona.",
        "prompt": "¿Qué merece la pena revisar primero?",
        "options": [
          { "text": "Si disfrutaron de las citas.", "correct": false, "note": "Inconocible, y preguntar después de los hechos suele producir educación en vez de información." },
          { "text": "Si tus fotos se parecen a ti en persona.", "correct": false, "note": "Merece la pena en general, y no explica un patrón que sobrevive a tres uniones funcionando." },
          { "text": "Si propusiste una segunda cita siquiera.", "correct": true, "note": "Un número sorprendente de gente que cree que sus citas van mal sencillamente no está preguntando después — el mismo apagón, una etapa más adelante." },
          { "text": "Si estás quedando con el tipo de persona correcto.", "correct": false, "note": "La otra de las dos posibilidades, y solo se aplica si tú tampoco querías una segunda cita." }
        ]
      }
    ]
  }$j$::jsonb
);
