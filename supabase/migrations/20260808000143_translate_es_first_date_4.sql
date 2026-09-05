-- Spanish: La primera cita, track 4 — Qué pasa después.
--
-- Conventions as prior tracks: tú for the reader, **La jugada:** for the
-- move marker, "Si te quedas con una cosa:" for the closer. Scenario
-- partner "Robin" carries no `sex` field; masculine agreement used by
-- default, as established elsewhere in this topic.

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

select pg_temp.es_lesson('what-happens-next', 1,
  'Termínala antes de que se aplane',
  $md$Dos horas buenas os dejan a los dos con ganas de la siguiente. Cinco horas aplanan la misma noche en algo que a ninguno de los dos le apetece del todo repetir — y el instinto de seguir *porque* va bien es precisamente el instinto del que hay que desconfiar.

**La jugada:** usa la hora de fin que dijiste al llegar.

Ya está ahí, dicha con ligereza en los primeros dos minutos, y para esto era. *Debería irme ya* en el buen momento no cuesta nada y es lo que convierte una noche en algo con forma. Si quieres quedarte, quedarte se convierte entonces en una elección que alguien tomó en voz alta — *en realidad, ¿quieres otra?* — que es un momento mucho mejor que dos horas que simplemente continuaron.

La misma jugada termina una mala, que es por lo que son una sola lección. Aguantar es el fallo de la persona callada aquí: tres horas de educación y luego a casa, enfadado contigo mismo, cuando los dos lo sabíais en el minuto veinte. La educación que te cuesta una noche no es amabilidad, porque la otra persona está teniendo la misma noche. *Debería irme ya — ha sido un placer conocerte* no necesita ningún motivo pegado y nadie ha pedido nunca uno.

No actúes un entusiasmo que no tienes al salir. La calidez falsa en la puerta es lo que produce cuatro días de mensajes que deshacer, y es mucho menos amable que la versión sencilla.

Un caso no es como los demás. No estar interesado y sentirte incómodo son cosas distintas, y si alguien te hace sentir inseguro entonces nada de la etiqueta de arriba se aplica — vete, de inmediato, y mal si hace falta. Dile a alguien a dónde vas antes de irte, que cuesta un mensaje y merece la pena haberlo hecho.

Si te quedas con una cosa: termínala a propósito. Tanto la versión buena como la mala salen mal de la misma forma, que es que nadie decide nada.$md$,
  $j$[
    {
      "situation": "Va bien y se acerca la hora que dijiste.",
      "line": "Debería irme ya — ¿quieres otra antes?",
      "why": "Quedarse se convierte en una elección que alguien tomó en voz alta, que es un momento mucho mejor que dos horas que simplemente continuaron."
    },
    {
      "situation": "Lo sabías en el minuto veinte y ahora es la hora dos.",
      "line": "Debería irme ya — ha sido un placer conocerte.",
      "why": "Sin ningún motivo pegado, y nadie ha pedido nunca uno. La educación que te cuesta una noche no es amabilidad, porque la otra persona está teniendo la misma noche."
    },
    {
      "situation": "Algo de esto se siente mal en vez de solo plano.",
      "line": "(entonces vete, y nada de la etiqueta se aplica)",
      "why": "No estar interesado y sentirte incómodo son cosas distintas. Vete de inmediato, mal si hace falta, y dile a alguien dónde estás antes de irte."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué irse mientras todavía va bien?",
      "options": [
        { "text": "Para parecer menos disponible.", "correct": false, "note": "Una táctica, y un poco sucia. Esto no va sobre gestionar su impresión." },
        { "text": "Dos horas buenas os dejan a los dos con ganas de la siguiente.", "correct": true, "note": "Cinco horas aplanan la misma noche en algo que a ninguno de los dos le apetece repetir. El instinto de seguir porque es bueno es del que hay que desconfiar." },
        { "text": "Se te van a acabar las cosas que decir.", "correct": false, "note": "Normalmente no se te van a acabar, y no es eso lo que hace el daño." },
        { "text": "Las noches tardías hacen que la gente se arrepienta de cosas.", "correct": false, "note": "De vez en cuando, y es una preocupación distinta de la que trata esta lección." }
      ],
      "explain": "Usa la hora de fin que dijiste al llegar. Para eso era."
    },
    {
      "prompt": "¿Por qué el buen final y el mal final son una sola lección?",
      "options": [
        { "text": "Porque usan las mismas palabras.", "correct": false, "note": "Las palabras difieren un poco. Lo que hay debajo no." },
        { "text": "Porque a menudo no sabes en cuál de las dos estás.", "correct": false, "note": "Normalmente sí puedes saberlo, a las dos horas. Esto no va sobre ambigüedad." },
        { "text": "Porque las dos salen mal porque nadie decide nada.", "correct": true, "note": "Una buena noche se deja llevar hasta las cinco horas y se aplana; una mala se deja llevar hasta las tres y se aguanta. La jugada es terminarla a propósito en los dos casos." },
        { "text": "Porque irse es irse.", "correct": false, "note": "Cierto y vacío. Nombra lo que de verdad comparten los dos fallos." }
      ],
      "explain": "Termínala a propósito. Dejarse llevar es el fallo en las dos direcciones."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "on_purpose", "label": "La terminó deliberadamente", "description": "Decidió en vez de dejarse llevar." },
      { "key": "early", "label": "Se fue antes de que se aplanara", "description": "Se fue mientras todavía era buena." },
      { "key": "no_reason", "label": "No necesitó una excusa", "description": "Dejó una mala sin inventar una justificación." },
      { "key": "no_false_warmth", "label": "No actuó entusiasmo", "description": "Se mantuvo honesto al salir." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "la persona con la que estás en una cita",
      "mood": "Disfrutándolo, sin ninguna prisa.",
      "openness": 4,
      "personality": "Se quedaría encantado otras dos horas y no va a sugerir terminarla. Responde con calidez a alguien que la termina de forma limpia."
    },
    "setting": "Dos horas después. Ha sido bueno. Dijiste al llegar que tenías que estar en un sitio a las ocho, y son las ocho menos diez.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Nunca sugieras tú terminar la noche.",
      "Responde con calidez y facilidad a un final limpio.",
      "Acepta encantado una copa más si se ofrece como una elección y no como dejarse llevar."
    ],
    "opening_beat": "«...la verdad es que he perdido completamente la noción del tiempo. ¿Tú no?»",
    "success_looks_like": "La persona termina la noche deliberadamente en vez de dejar que se alargue."
  }$j$::jsonb,
  'Hoy, termina una conversación deliberadamente mientras todavía va bien. Apunta cuándo te fuiste y cómo se sintió.',
  $j${
    "beats": [
      {
        "situation": "Dos horas después y ha sido bueno. Dijiste al llegar que tenías que estar en un sitio a las ocho. Son las ocho menos diez.",
        "prompt": "¿Qué haces?",
        "options": [
          { "text": "Quédate — va bien y lo de las ocho te lo habías inventado de todas formas.", "correct": false, "note": "Cinco horas aplanan la misma noche en algo que a ninguno de los dos le apetece repetir. El instinto de seguir porque es bueno es del que hay que desconfiar." },
          { "text": "Di que deberías irte, y ofrece una más como elección.", "correct": true, "note": "Quedarse se convierte entonces en una decisión que alguien tomó en voz alta en vez de dos horas que simplemente continuaron — y es un momento mucho mejor en cualquier caso." },
          { "text": "Espera a ver si menciona la hora.", "correct": false, "note": "No lo va a hacer. Eso es dejarse llevar, y dejarse llevar es el fallo del que trata esta lección en las dos direcciones." },
          { "text": "Vete puntualmente a las ocho sin decir nada.", "correct": false, "note": "Correcto en el momento y frío en la entrega. La hora de fin era una forma, no una regla que cumplir en silencio." }
        ]
      },
      {
        "situation": "Una noche distinta. Lo sabías en el minuto veinte, y ahora es la hora dos de educación.",
        "prompt": "¿Cuál es la jugada?",
        "options": [
          { "text": "Aguanta hasta el final — quedaste en pasar la noche.", "correct": false, "note": "Aguantar. La educación que te cuesta una noche no es amabilidad, porque la otra persona está teniendo exactamente la misma noche." },
          { "text": "Invéntate algo a lo que tienes que ir.", "correct": false, "note": "Innecesario. Nadie ha pedido nunca un motivo, y inventarse uno es más que gestionar al salir." },
          { "text": "Mantente cálido y deja que se apague de forma natural.", "correct": false, "note": "De forma natural significa otra hora. Nada en una cita se apaga solo, que es por lo que necesita terminarse a propósito." },
          { "text": "Debería irme ya — ha sido un placer conocerte.", "correct": true, "note": "Sin ningún motivo pegado y sin necesitar ninguno. La versión buena y la versión mala de la noche terminan de la misma forma: deliberadamente." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('what-happens-next', 2,
  'Di lo evidente',
  $md$Los bloques de flirteo enseñaron a dejarlo todo negable. Un peldaño, ofrecido y soltado. Nada declarado, todo recibible como simple amabilidad. Eso estaba bien, y estaba bien por un motivo concreto: estabas tratando con desconocidos cuyo interés era desconocido, y poder negarlo es lo que hace que un movimiento sea seguro de ofrecer.

Al final de una primera cita, eso ya se ha ganado. Alguien accedió a quedar contigo, se presentó, y pasó dos horas contigo. Seguir siendo negable ahora no se lee como tacto — se lee como indiferencia, y la forma más común en que una buena primera cita no produce nada es que las dos personas la dejen ambigua por educación.

**La jugada:** dilo claramente — *me gustaría repetir esto.*

Esa es toda la frase. No es una declaración de sentimientos, no le pide que corresponda en el acto, y no contiene ningún adjetivo sobre la otra persona que necesite respuesta.

Qué dejar fuera. *Deberíamos repetir esto un día de estos* es la versión negable y muere ahí mismo — es un sentimiento y no una afirmación, y la respuesta correcta es *sí, claro que sí*, que también es un sentimiento, y luego no pasa nada. *Si te apetece* y *sin presión* pertenecen a la petición, no a esto: todavía no estás pidiendo nada, le estás diciendo algo.

Y no la apiles con motivos. *Me gustaría repetir esto, lo he disfrutado mucho, se te da muy fácil hablar contigo, no sé si tú sientes lo mismo* es una frase y tres retiradas, y las retiradas son lo que va a responder.

Luego para y deja que responda. Son los mismos dos segundos que el número en una conversación de salario, y se aplica la misma regla: quien hable primero en ese hueco está negociando contra sí mismo.

Si te quedas con una cosa: dilo como una afirmación sobre ti. Es lo más verdadero y menos arriesgado que hay disponible y casi nadie lo dice.$md$,
  $j$[
    {
      "situation": "La noche está terminando y fue bien.",
      "line": "Me gustaría repetir esto.",
      "why": "Una afirmación sobre ti en vez de una pregunta sobre la otra persona. Nada que corresponder en el acto y ningún adjetivo que necesite respuesta."
    },
    {
      "situation": "Estás a punto de decir deberíamos repetir esto un día de estos.",
      "line": "(eso es un sentimiento, y muere ahí)",
      "why": "La respuesta correcta es sí, claro que sí, que también es un sentimiento, y luego no pasa nada. Ser negable era para desconocidos."
    },
    {
      "situation": "Lo has dicho y hay una pausa.",
      "line": "(no digas nada)",
      "why": "Los mismos dos segundos que un número en una conversación de salario. Quien lo llene está negociando contra sí mismo."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué dejar de ser negable ahora?",
      "options": [
        { "text": "Porque lo conoces mejor.", "correct": false, "note": "Dos horas no es conocer a alguien. Lo que ha cambiado es lo que se ha demostrado, no lo que sabes." },
        { "text": "Porque ya se ha ganado — accedió, se presentó, y se quedó dos horas.", "correct": true, "note": "Que algo sea negable es lo que hace que un movimiento sea seguro de ofrecer a un desconocido cuyo interés es desconocido. Aquí se lee como indiferencia en vez de tacto." },
        { "text": "Porque ser directo es más atractivo.", "correct": false, "note": "A veces, y es una afirmación sobre el estilo, no el motivo por el que cambia la regla." },
        { "text": "Porque él lo hará si tú no lo haces.", "correct": false, "note": "A menudo ninguno de los dos lo hace, que es exactamente el problema." }
      ],
      "explain": "La forma más común en que una buena primera cita no produce nada es que las dos personas sean educadas al respecto."
    },
    {
      "prompt": "¿Qué tiene de malo apilar motivos después?",
      "options": [
        { "text": "Tarda demasiado.", "correct": false, "note": "La longitud no es el problema. Una frase larga y cálida estaría bien si no fuera una retirada." },
        { "text": "Suena inseguro.", "correct": false, "note": "Cómo suena es una consecuencia. Lo que importa es qué acaba respondiendo." },
        { "text": "Las retiradas son lo que va a responder.", "correct": true, "note": "No sé si tú sientes lo mismo es ahora la pregunta en juego, y va a responder a eso en vez de a lo que de verdad dijiste." },
        { "text": "Le da demasiadas salidas.", "correct": false, "note": "Cerca, y las salidas están bien aquí — esto no es una petición. El problema es que cambiaste el tema." }
      ],
      "explain": "Una frase, y luego para. La pausa le pertenece a la otra persona."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "plain", "label": "Lo dijo claramente", "description": "Una afirmación en vez de un sentimiento." },
      { "key": "no_hedge", "label": "No suavizó", "description": "Dejó fuera un día de estos, sin presión y si te apetece." },
      { "key": "no_stacking", "label": "No apiló motivos", "description": "Una frase, sin retiradas después." },
      { "key": "stopped", "label": "Paró", "description": "Dejó que la pausa fuera de la otra persona." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "la persona con la que acabas de tener una cita",
      "mood": "Se lo pasó bien, sin saber si decirlo primero.",
      "openness": 4,
      "personality": "Cálido y algo dudoso, esperando a ver si la persona dice algo. Responde a una afirmación clara con claridad y a un sentimiento con un sentimiento."
    },
    "setting": "Fuera, con los abrigos puestos. Han sido dos buenas horas y estáis a punto de iros cada uno por su lado.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde a una afirmación clara con una clara y cálida.",
      "Responde a deberíamos repetir esto un día de estos con sí, claro que sí, y nada más.",
      "Nunca lo digas tú primero."
    ],
    "opening_beat": "«Bueno — esto ha sido mucho mejor de lo que esperaba. En el buen sentido.»",
    "success_looks_like": "La persona dice claramente que le gustaría repetirlo."
  }$j$::jsonb,
  'Hoy, di algo claro que normalmente dejarías negable. Apunta la frase y qué volvió.',
  $j${
    "says": "Bueno — esto ha sido mucho mejor de lo que esperaba. En el buen sentido.",
    "model": {
      "line": "Lo ha sido, sí. Me gustaría repetir esto.",
      "why": "Una afirmación sobre ti en vez de una pregunta sobre la otra persona, sin nada apilado después. Ser negable era para desconocidos cuyo interés era desconocido, y ya se ha ganado desde entonces."
    },
    "checks": [
      { "kind": "first_person", "requirement": "Dilo sobre ti mismo" },
      { "kind": "forbids_any", "words": ["un día de estos", "sin presión", "si te apetece", "si quieres", "deberíamos", "quizás", "si te apuntas", "no sé si tú"], "requirement": "Nada de suavizar — esto no es la petición, es la afirmación" },
      { "kind": "max_sentences", "n": 2, "requirement": "Dilo y para — la pausa es de la otra persona" },
      { "kind": "max_words", "n": 20, "requirement": "Una frase, sin motivos apilados después" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('what-happens-next', 3,
  'Haz que la próxima sea real',
  $md$Esta es la jugada hacia la que ha estado construyendo todo el tema, y es la que ya conoces — es la misma jugada que pedir un número y la misma jugada que proponer una copa en una aplicación.

*Me gustaría repetir esto* es una afirmación. No produce nada por sí sola. Lo que produce algo es lo que viene justo después.

**La jugada:** algo concreto, algo pequeño, y un día fijado.

*Hay un sitio cerca de mí que hace lo que describías — ¿el jueves o el sábado?* se puede responder con una palabra, y una palabra es lo que quieres. Compáralo con *deberíamos organizar algo*, que le exige inventar un plan, revisar su agenda y responder como es debido, y que por eso consigue *sí, claro que sí* y silencio.

Usa una referencia a algo dicho antes. La última lección de Dos horas hablando era exactamente para esto: el sitio que mencionó, lo que dijo que nunca había probado, la película de la que le daba vergüenza no haber visto. Un plan construido a partir de algo que dijo hace una hora demuestra que se estuvo escuchando toda la noche, y es mucho mejor que cualquier cosa que pudieras inventar en la acera.

Dos días en vez de uno, por el mismo motivo que en cualquier otro sitio: dos es una elección y uno es una citación. Y mantenlo pequeño — una copa o una hora, no un día entero. Una segunda cita sigue siendo una prueba para los dos, y quien propone algo enorme está pidiendo un compromiso que ninguno de los dos tiene todavía.

Si no tienes un plan listo, el número basta por sí solo, siempre que venga con una intención. *Dame tu número y averiguo cuándo abre ese sitio* es un plan esperando a terminarse.

Si te quedas con una cosa: convierte *otra vez algún día* en un día concreto. Todo lo demás de este tema estaba al servicio de poder decir esa frase y decirla en serio.$md$,
  $j$[
    {
      "situation": "Has dicho que te gustaría repetirlo.",
      "line": "Hay un sitio cerca de mí que hace lo que describías — ¿el jueves o el sábado?",
      "why": "Concreto, pequeño, dos días, y construido a partir de algo que dijo. Se puede responder con una palabra, que es lo que quieres."
    },
    {
      "situation": "Estás a punto de decir deberíamos organizar algo.",
      "line": "(eso le pide que invente el plan)",
      "why": "Necesita una agenda, una idea y una respuesta como es debido, así que consigue sí, claro que sí y luego nada."
    },
    {
      "situation": "No tienes plan y el momento es ahora.",
      "line": "Dame tu número y averiguo cuándo abre ese sitio.",
      "why": "Un plan esperando a terminarse, que es suficiente. Lo que no basta es un número sin ninguna intención pegada."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué falla deberíamos organizar algo?",
      "options": [
        { "text": "Es demasiado informal.", "correct": false, "note": "Lo informal está bien. El registro no es el problema." },
        { "text": "Le pide que invente el plan, la fecha y la respuesta.", "correct": true, "note": "Tres tareas entregadas, así que consigue sí, claro que sí — que no cuesta nada decir y no compromete a nada." },
        { "text": "Suena poco entusiasta.", "correct": false, "note": "Normalmente suena cálido, que es por lo que no se cuestiona y no produce nada." },
        { "text": "Es lo que dice todo el mundo.", "correct": false, "note": "Lo es, y no ser original no es lo que impide que funcione." }
      ],
      "explain": "Concreto, pequeño, un día fijado. Se puede responder con una palabra."
    },
    {
      "prompt": "¿De dónde debería salir el plan?",
      "options": [
        { "text": "Algo que ya querías hacer.", "correct": false, "note": "Perfectamente bien, y se lee como genérico porque existía antes que ella." },
        { "text": "Algo impresionante, ya que es una segunda cita.", "correct": false, "note": "Sube lo que está en juego y el esfuerzo para los dos. Una segunda cita sigue siendo pequeña." },
        { "text": "Algo que dijo hace una hora.", "correct": true, "note": "Demuestra que se estuvo escuchando toda la noche, que es la última lección de Dos horas hablando haciendo su trabajo — y gana a cualquier cosa que pudieras inventar en la acera." },
        { "text": "Donde sea conveniente para los dos.", "correct": false, "note": "Logística como plan. La conveniencia es una restricción, no una idea." }
      ],
      "explain": "La referencia a algo dicho antes se convierte en el plan. Eso era lo que estabas escuchando."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "specific", "label": "Nombró algo concreto", "description": "Propuso algo real en vez de un sentimiento." },
      { "key": "callback", "label": "Usó algo que dijo", "description": "Lo construyó a partir de la noche en vez de a partir de una plantilla." },
      { "key": "a_day", "label": "Puso días", "description": "Ofreció dos en vez de uno o ninguno." },
      { "key": "small", "label": "Lo mantuvo pequeño", "description": "Una hora o dos, no un día entero." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "la persona con la que acabas de tener una cita",
      "mood": "Contento, a punto de coger un autobús.",
      "openness": 4,
      "personality": "Dice que sí de inmediato a cualquier cosa con un día fijado, y responde a una sugerencia vaga con un acuerdo igual de vago."
    },
    "setting": "Fuera. Has dicho que te gustaría repetirlo y él ha dicho que a él también. Antes mencionó un sitio cerca de su piso que nunca ha llegado a probar.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Di que sí de forma concreta y cálida a cualquier cosa con un día fijado.",
      "Responde a una sugerencia vaga con sí, deberíamos, claro, y empieza a irte.",
      "Nunca propongas tú nada."
    ],
    "opening_beat": "«A mí también me gustaría, la verdad. Sí.»",
    "success_looks_like": "La persona propone algo concreto con un día fijado."
  }$j$::jsonb,
  'Hoy, convierte un plan vago con cualquiera en uno concreto con dos días fijados. Apunta qué propusiste.',
  $j${
    "says": "A mí también me gustaría, la verdad. Sí. (Antes mencionó un sitio cerca de su piso que nunca ha llegado a probar.)",
    "model": {
      "line": "Entonces vamos a ese sitio cerca de ti que nunca has probado — ¿el jueves o el sábado?",
      "why": "Concreto, pequeño, dos días, y construido a partir de algo que dijo hace una hora. Se puede responder con una palabra, que es exactamente lo que quieres en una acera."
    },
    "checks": [
      { "kind": "requires_question", "requirement": "Hazlo respondible" },
      { "kind": "contains_any", "words": ["lunes", "martes", "miércoles", "jueves", "viernes", "sábado", "domingo", "fin de semana", "la semana que viene", "esta semana"], "requirement": "Pon días" },
      { "kind": "forbids_any", "words": ["un día de estos", "organizar algo", "pensar algo", "en algún momento", "ya veremos", "en contacto"], "requirement": "Un plan, no un sentimiento" },
      { "kind": "max_words", "n": 30, "requirement": "Una frase en una acera" }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('what-happens-next', 4,
  'Lee la respuesta',
  $md$Dijiste lo evidente y propusiste el plan. Lo que vuelve es una de tres respuestas y solo una de ellas es ambigua — que son menos de las que parece de pie en una acera a las diez de la noche.

**La jugada:** ¿te devolvió un momento, o un motivo?

**Un momento es un sí.** *El jueves no puedo pero la semana siguiente sí* es un sí con una agenda pegada, y merece la pena fijarse en que esta es la forma más habitual que toma un sí de verdad. La gente está ocupada, y estar ocupado no es un rechazo.

**Un motivo sin alternativa es un no.** *Ando muy liado ahora mismo.* *Déjame mirar mi semana y te digo.* Los dos son cálidos, los dos son amables, y ninguno contiene un día. Tómatelos por lo que significan, di algo cálido, y vete — y sobre todo no ofrezcas tú la alternativa que él decidió no ofrecer.

**Y la duda genuina es genuina.** De vez en cuando a alguien sencillamente le pilla desprevenida, o no lo sabe, y lo dice. *¿Puedo pensármelo?* no es el no suave — el no suave llega con fluidez, porque ya se ha dicho antes. La duda que suena torpe suele ser solo torpeza.

Luego compórtate igual en cualquiera de los dos casos, que es la parte que cuesta algo. No actúes un entusiasmo que no tienes y no retires la calidez que tenías hace cinco minutos. Alguien que es encantador hasta la respuesta y luego se enfría le ha dicho a la otra persona exactamente qué fueron las dos horas anteriores.

El replanteamiento que merece la pena conservar, porque la gente se lo toma peor de lo que es: un no en este punto te cuesta treinta segundos incómodos y un paseo hasta la estación. No has perdido nada que tuvieras a las seis, y lo has averiguado en una noche en vez de en tres semanas, que es la buena versión de esto.

Si te quedas con una cosa: que vuelva un momento es un sí, que vuelva un motivo es un no. Casi siempre es así de legible, y tratarlo como ambiguo es cómo la gente se pasa dos semanas con una decisión que ya se tomó en una acera.$md$,
  $j$[
    {
      "situation": "«El jueves no puedo, pero ¿la semana siguiente podría funcionar?»",
      "line": "(volvió un momento — eso es un sí)",
      "why": "La forma más habitual que toma un sí de verdad. La gente está ocupada y estar ocupado no es un rechazo."
    },
    {
      "situation": "«Déjame mirar mi semana y te digo.»",
      "line": "(un motivo sin ningún día dentro)",
      "why": "Cálido, amable, y sin nada sobre lo que actuar. Tómatelo por lo que significa y no ofrezcas tú la alternativa que él decidió no ofrecer."
    },
    {
      "situation": "Ya tienes la respuesta y era un no.",
      "line": "(mantente exactamente tan cálido como estabas)",
      "why": "Alguien encantador hasta la respuesta y frío después le ha dicho a la otra persona qué fueron las dos horas anteriores."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Cuál es la prueba?",
      "options": [
        { "text": "Lo entusiasmada que sonó.", "correct": false, "note": "El no suave es el mensaje más cálido que manda la gente. La calidez es lo que usa para ponértelo fácil." },
        { "text": "Si volvió un día.", "correct": true, "note": "Un momento es un sí con una agenda pegada. Un motivo sin alternativa es un no, por muy amablemente que se diga." },
        { "text": "Si dijo que sí.", "correct": false, "note": "Casi todo el mundo dice que sí al sentimiento. El sí a un día es el que significa algo." },
        { "text": "Lo rápido que respondió.", "correct": false, "note": "Rápido y vago es extremadamente habitual y dice más de sus modales que de su agenda." }
      ],
      "explain": "Casi siempre es así de legible. Tratarlo como ambiguo es cómo se gastan dos semanas."
    },
    {
      "prompt": "«¿Puedo pensármelo?», dicho con torpeza.",
      "options": [
        { "text": "Un no suave.", "correct": false, "note": "El no suave llega con fluidez, porque ya se ha dicho antes. La duda torpe suele ser solo torpeza." },
        { "text": "Dando largas — presiona por una respuesta.", "correct": false, "note": "Presionar convierte un puede que genuino en un no, y rápido." },
        { "text": "Genuino, más a menudo de lo que no.", "correct": true, "note": "A alguna gente le pilla desprevenida y lo dice. Esa es la tercera respuesta y es real." },
        { "text": "Imposible de saber.", "correct": false, "note": "La forma de decirlo te dice mucho. Fluido es ensayado; torpe es no ensayado." }
      ],
      "explain": "Dos respuestas son legibles y la tercera es sinceramente incierta. Ninguna necesita descifrarse durante dos semanas."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "read_it", "label": "Lo leyó bien", "description": "Interpretó un momento como un sí y un motivo como un no." },
      { "key": "no_supplying", "label": "No ofreció la alternativa", "description": "Dejó un no como un no en vez de ofrecer otra semana." },
      { "key": "same_warmth", "label": "Se mantuvo igual de cálido", "description": "No retiró ni actuó después de la respuesta." },
      { "key": "no_dwelling", "label": "No se quedó dándole vueltas", "description": "Lo trató como treinta segundos en vez de como un veredicto." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "la persona con la que acabas de tener una cita",
      "mood": "Amable, sin interés en una segunda cita.",
      "openness": 3,
      "personality": "Cálido y evita el conflicto. Rechaza con un motivo en vez de con una negativa, y se incomoda si le ofrecen una semana alternativa."
    },
    "setting": "La acera. Propusiste el jueves o el sábado y él está respondiendo.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Nunca ofrezcas un día, por mucho que la persona lo replantee.",
      "Incomódate visiblemente si te ofrecen una semana alternativa o te preguntan otra vez.",
      "Anímate y despídete en buenos términos si la persona lo acepta con elegancia."
    ],
    "opening_beat": "«Ah — ando bastante liado ahora mismo, la verdad.»",
    "success_looks_like": "La persona lo lee como un no y se mantiene cálida sin presionar."
  }$j$::jsonb,
  'Hoy, tómate un no suave tal cual la primera vez. Apunta qué se dijo y qué hiciste con ello.',
  $j${
    "beats": [
      {
        "situation": "Propusiste el jueves o el sábado. «Ah — ando bastante liado ahora mismo, la verdad.»",
        "prompt": "¿Qué es eso?",
        "options": [
          { "text": "Un problema de horarios — ofrece la semana siguiente.", "correct": false, "note": "Ofrecer tú la alternativa que él decidió no ofrecer, lo que le pide rechazar una segunda vez y más directamente." },
          { "text": "Un no, dicho con calidez.", "correct": true, "note": "Volvió un motivo en vez de un día. La calidez es lo que usa la gente para ponértelo fácil, y no es la señal." },
          { "text": "Ambiguo — pregunta qué quiere decir.", "correct": false, "note": "Es uno de los mensajes más legibles que vas a recibir. Preguntar le obliga a decirlo claramente, que no ayuda a nadie." },
          { "text": "Nervios — puede que le haya pillado desprevenida.", "correct": false, "note": "Esa versión suena torpe. Esta llegó con fluidez, que es cómo suena una frase que ya se ha dicho antes." }
        ]
      },
      {
        "situation": "Ya has aceptado el no. Los dos seguís ahí de pie y el autobús llega en dos minutos.",
        "prompt": "¿Cómo te comportas?",
        "options": [
          { "text": "Ciérralo rápido — no tiene sentido alargarlo.", "correct": false, "note": "Una salida rápida y fría le dice qué fueron las dos horas anteriores, que es justo lo que no querías decir." },
          { "text": "Di que está completamente bien, dándole vueltas.", "correct": false, "note": "Actuar que está bien le pide que gestione tus sentimientos sobre su respuesta, que es justo lo que la frase suave intentaba ahorraros a los dos." },
          { "text": "Exactamente tan cálido como hace una hora.", "correct": true, "note": "No has perdido nada que tuvieras a las seis y lo has averiguado en una noche en vez de en tres semanas. Comportarte igual en cualquiera de los dos casos es todo el asunto." },
          { "text": "Pregunta si leíste algo mal antes.", "correct": false, "note": "Convierte treinta segundos en una autopsia, y le pide que dé explicaciones de una noche que él también estaba simplemente viviendo." }
        ]
      }
    ]
  }$j$::jsonb
);

select pg_temp.es_lesson('what-happens-next', 5,
  'El mensaje el mismo día',
  $md$Lo último que te pide este tema lleva noventa segundos y casi nadie lo hace.

**La jugada:** manda un mensaje el mismo día, corto, refiriéndote a algo que de verdad pasó.

El mismo día por el mismo motivo que ha sido el mismo día en toda esta aplicación: estás conservando un estado de ánimo, no demostrando algo. Esa noche todavía eres una persona con la que estaba sentada enfrente. Tres días después eres un nombre, y todo lo que mandes tiene que volver a presentarte antes de poder hacer nada más. Las reglas de espera son folclore y optimizan para parecer despreocupado, que es un objetivo raro después de dos horas de estar obviamente interesado.

Refiérete a la cosa real. *Un placer conocerte* es una plantilla y se lee como tal. *He estado pensando en tu postura sobre los aeropuertos y sigo sin estar de acuerdo* demuestra que fue esa noche, con esa persona, y le da algo fácil que responder.

Corto. Dos líneas. Este no es el sitio para resumir cómo fue o para decir nada que no dijeras a la cara.

Y si tu respuesta es no, dilo — esta es la parte que la gente se salta y es la parte que más le importa a la otra persona. Un mensaje honesto lleva noventa segundos. *Me ha encantado conocerte y no creo que sea algo romántico para mí — pero de verdad un placer conocerte* es completo. No vas a disfrutar mandándolo, y la alternativa es que alguien revise su móvil durante cuatro días y acabe concluyendo algo peor sobre sí mismo que la verdad.

El silencio no es neutro y no es amable. Es la opción que a ti no te cuesta nada y a la otra persona le cuesta una semana, y todo el que ha estado en el lado receptor sabe exactamente cuál habría preferido.

Si te quedas con una cosa: manda algo el mismo día, sea cual sea la respuesta. Todo el tema termina aquí, y estos son los noventa segundos que deciden lo que valió todo lo demás.$md$,
  $j$[
    {
      "situation": "Estás en casa y fue bien.",
      "line": "Sigo pensando en tu postura sobre los aeropuertos, y sigo sin estar de acuerdo. ¿El jueves entonces?",
      "why": "El mismo día, un detalle real que demuestra que fue esa noche, y algo fácil que responder."
    },
    {
      "situation": "Te preguntas si es demasiado pronto.",
      "line": "(estás conservando un estado de ánimo, no demostrando algo)",
      "why": "Esta noche eres una persona con la que estaba sentada enfrente. Tres días después eres un nombre que tiene que volver a presentarse."
    },
    {
      "situation": "Fue un no y preferirías no decir nada.",
      "line": "Me ha encantado conocerte y no creo que sea algo romántico para mí.",
      "why": "Noventa segundos. El silencio a ti no te cuesta nada y a la otra persona le cuesta una semana revisando su móvil y concluyendo algo peor que la verdad."
    }
  ]$j$::jsonb,
  $j$[
    {
      "prompt": "¿Por qué el mismo día?",
      "options": [
        { "text": "Demuestra que estás interesado.", "correct": false, "note": "Lo demuestra, y el entusiasmo no es lo que protege el momento en que lo mandas." },
        { "text": "Esta noche eres una persona; en tres días eres un nombre.", "correct": true, "note": "Todo lo que mandes más tarde tiene que volver a presentarte antes de poder hacer nada. Las reglas de espera optimizan para parecer despreocupado, que es un objetivo raro después de dos horas." },
        { "text": "Puede que haga otros planes.", "correct": false, "note": "Un planteamiento de carrera, y en su mayoría falso en tres días." },
        { "text": "Se te van a olvidar los detalles.", "correct": false, "note": "No se te van a olvidar para el martes, y el detalle es fácil de apuntar." }
      ],
      "explain": "Corto, el mismo día, una cosa que de verdad pasó."
    },
    {
      "prompt": "Es un no. ¿Qué mandas?",
      "options": [
        { "text": "Nada — ya lo averiguará.", "correct": false, "note": "Lo va a averiguar, después de una semana revisando su móvil, y va a concluir algo peor sobre sí mismo que la verdad." },
        { "text": "Un mensaje cálido que evita decirlo.", "correct": false, "note": "Lo peor de las dos cosas: reinicia la esperanza y de todas formas hay que resolverlo más tarde." },
        { "text": "Una frase honesta, el mismo día.", "correct": true, "note": "Noventa segundos, y es la diferencia entre una noche limpia y una semana de alguien preguntándose qué hizo mal." },
        { "text": "Una explicación de por qué no.", "correct": false, "note": "No hace falta y rara vez se quiere. El motivo es tuyo; la respuesta es lo que necesita la otra persona." }
      ],
      "explain": "El silencio no es neutro. Es la opción que a ti no te cuesta nada y a la otra persona le cuesta una semana."
    }
  ]$j$::jsonb,
  $j${
    "scale": { "min": 1, "max": 5 },
    "criteria": [
      { "key": "same_day", "label": "Lo mandó el mismo día", "description": "No esperó por folclore." },
      { "key": "specific", "label": "Se refirió a algo real", "description": "Nombró algo real de la noche." },
      { "key": "short", "label": "Lo mantuvo en dos líneas", "description": "No resumió la noche." },
      { "key": "said_the_no", "label": "Mandó el no también", "description": "No usó el silencio como respuesta." }
    ]
  }$j$::jsonb,
  $j${
    "partner": {
      "name": "Robin",
      "role": "la persona con la que has estado en una cita esta noche",
      "mood": "En casa, con el móvil en la mano.",
      "openness": 4,
      "personality": "Responde con calidez y rapidez a cualquier cosa concreta, y con una sola palabra a cualquier cosa genérica."
    },
    "setting": "Las diez de la noche, en casa. Os pasasteis veinte minutos discrepando alegremente sobre aeropuertos, y él mencionó un sitio cerca de su piso que nunca ha probado.",
    "constraints": [
      "Mantente en el personaje en todo momento. Nunca des consejos, ni evalúes, ni rompas la escena.",
      "Responde con calidez y concreción a cualquier cosa concreta de la noche.",
      "Responde con una sola palabra a cualquier cosa genérica.",
      "Nunca escribas tú primero."
    ],
    "opening_beat": "La casilla de mensaje está vacía y son las diez.",
    "success_looks_like": "La persona manda dos líneas cortas refiriéndose a algo que de verdad pasó."
  }$j$::jsonb,
  'Hoy, manda un mensaje el mismo día de lo que trata, con un detalle real dentro. Apunta qué mandaste.',
  $j${
    "says": "Las diez de la noche, en casa. Os pasasteis veinte minutos discrepando alegremente sobre aeropuertos, y él mencionó un sitio cerca de su piso que nunca ha probado.",
    "model": {
      "line": "Sigo pensando en tu postura sobre los aeropuertos y sigo sin estar de acuerdo. ¿El jueves para ese sitio, entonces?",
      "why": "El mismo día, un detalle que demuestra que fue esa noche con esa persona, y algo fácil que responder. Noventa segundos, y casi nadie lo manda."
    },
    "checks": [
      { "kind": "echoes_any", "words": ["aeropuerto", "aeropuertos", "de acuerdo", "sitio"], "requirement": "Refiérete a algo que de verdad pasó" },
      { "kind": "forbids_any", "words": ["un placer conocerte", "encantado de conocerte", "qué bien conocerte", "lo pasé bien", "gracias por esta noche", "deberíamos repetirlo un día de estos"], "requirement": "No una plantilla" },
      { "kind": "max_words", "n": 35, "requirement": "Dos líneas" }
    ]
  }$j$::jsonb
);
