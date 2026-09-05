-- Spanish: the surface of the whole app — every remaining topic and track.
--
-- Nine topics, forty-nine tracks. Names, descriptions and the one-line promise
-- or core idea for each. No theory, no drills, no scenarios.
--
-- **Why this shape.** Translating a topic in full costs about fifty-four
-- thousand words, so translating the remaining nine in depth is most of a
-- million. Until that lands, a Spanish reader navigates an English app: every
-- topic name, every track name, every lesson title on the home screen and the
-- index is in a language they did not choose, even for the topics they will
-- never open.
--
-- This migration and the two after it fix the navigation in one pass. The
-- per-field fallback in `localise` then does exactly what it was built for —
-- Spanish where Spanish exists, English underneath, field by field — so a
-- reader browses in Spanish and drops into English only when they open a
-- lesson that has not been translated yet. Depth follows, topic by topic.
--
-- Conventions as the Small talk and Interviews migrations: tú for the reader,
-- no gendered adjectives about them, names left alone, British institutions
-- and currencies replaced by their Spanish equivalents where they appear.

-- ---------------------------------------------------------------------------
-- The topics
-- ---------------------------------------------------------------------------

insert into public.topic_translations (topic_id, locale, name, description, promise)
select t.id, 'es', v.name, v.description, v.promise
from (values
  ('work',
   'El trabajo',
   $$La reunión en la que tenías la respuesta correcta y no dijiste nada. La subida que sigues sin pedir. La presentación que leíste de tus propias diapositivas.$$,
   $$Decir lo que piensas en la reunión mientras todavía cuenta, pedir el dinero sin disculparte por pedirlo, y dominar una sala en la que no esperabas estar de pie.$$),

  ('meeting-someone',
   'Conocer a alguien',
   $$Los dos segundos antes de decirle nada a alguien que te atrae: en un bar, un gimnasio, una librería, una cola.$$,
   $$Acercarte y empezar, y saber, mientras todavía está pasando, si está funcionando.$$),

  ('dating-apps',
   'Apps de citas',
   $$Un match, un chat en blanco, y una conversación que tiene que sobrevivir sin tono, sin tiempos y sin cara.$$,
   $$Mandar el primer mensaje, mantenerlo vivo más allá de la tercera respuesta, y salir de la app para entrar en una sala.$$),

  ('first-date',
   'La primera cita',
   $$Dos horas, una persona, y ninguna cola por la que escaparte. La parte que ninguna app puede hacer por ti.$$,
   $$Llenar dos horas sin pavor, averiguar si de verdad te gusta esa persona, y terminarla de forma que los dos sepáis dónde estáis.$$),

  ('making-friends',
   'Hacer amigos',
   $$Os caéis bien. Los dos habéis dicho «tenemos que quedar». Ninguno lo ha hecho. Este es el tema sobre el siguiente paso.$$,
   $$Convertir a alguien que te cae bien en alguien a quien de verdad ves, a propósito, en unas semanas en vez de en unos años.$$),

  ('hard-conversations',
   'Conversaciones difíciles',
   $$Esa que llevas un mes ensayando en la ducha y que todavía no has tenido.$$,
   $$Decir eso que llevas tragándote, de una forma que conserve a la persona, y quedarte en la sala mientras resulta incómodo.$$),

  ('storytelling',
   'Contar historias y hablar en público',
   $$Terminas la historia. Hay una pausa pequeña. Alguien dice «ah, ya». Era una buena historia.$$,
   $$Contar bien la historia que siempre cuentas mal, y poder levantarte sin previo aviso y merecer que te escuchen.$$),

  ('online-chatting',
   'Mensajes',
   $$Slack, WhatsApp, el grupo, y el mensaje a un compañero con el que en realidad no has hablado nunca.$$,
   $$Pedir lo que necesitas sin tres párrafos de disculpa por delante, y ser la persona a la que resulta fácil contestar.$$),

  ('ai-prompting',
   'Hablar con la IA',
   $$Ya la tienes abierta en otra pestaña. Este es el tema sobre para qué sirve de verdad, y sobre el punto en el que empieza a inventarse cosas sobre las personas.$$,
   $$Prepararte para la conversación que te da pavor, hacer la pregunta que llevas seis meses sin atreverte a hacer, y saber exactamente dónde deja de saber nada sobre las personas.$$)
) as v(slug, name, description, promise)
join public.topics t on t.slug = v.slug
on conflict (topic_id, locale) do update set
  name = excluded.name,
  description = excluded.description,
  promise = excluded.promise,
  updated_at = now();

-- ---------------------------------------------------------------------------
-- The tracks
-- ---------------------------------------------------------------------------

insert into public.skill_translations (skill_id, locale, name, description, core_idea)
select s.id, 'es', v.name, v.description, v.core_idea
from (values

  -- El trabajo -------------------------------------------------------------
  ('speaking-in-meetings',
   'Hablar en reuniones',
   $$La reunión en la que tenías la respuesta correcta y no dijiste nada, y los noventa segundos en los que todavía merecía la pena decirla.$$,
   $$Dilo mientras la ventana está abierta y antes de tenerlo terminado. Un argumento a medio formar dicho a tiempo gana a uno perfecto dicho después de la decisión.$$),

  ('your-manager',
   'Tu jefe',
   $$La media hora que nunca has pedido, el uno a uno que gastas en dar el estado, y la decisión con la que no estabas de acuerdo en silencio.$$,
   $$Pide el rato, lleva una cosa que de verdad quieras, discrepa una vez y en privado, y di que no con un intercambio en vez de con una disculpa.$$),

  ('raising-a-problem',
   'Plantear un problema',
   $$Quejarte de una situación, o de una persona: a ella, o a tu jefe, sin convertirte en el difícil.$$,
   $$Di la conducta y lo que costó, no el carácter. Pide un cambio concreto. Y dilo la semana en que pasa, no en una lista seis meses después.$$),

  ('being-seen',
   'Que se te vea',
   $$Buen trabajo que nadie sabe nombrar, y cómo arreglar eso sin convertirte en quien habla de sí mismo.$$,
   $$Nombra el trabajo, no a ti. Una frase, a quien decide, antes de que no se lo cuente nadie.$$),

  ('saying-what-you-want',
   'Decir lo que quieres',
   $$Más responsabilidad, el proyecto que siempre ves que le dan a otro, y el puesto que te gustaría tener después.$$,
   $$Ser bueno en tu trabajo no es una candidatura a nada. Di lo que quieres, a quien decide, antes de que haya una vacante.$$),

  ('asking-for-money',
   'Pedir dinero',
   $$La subida que sigues sin pedir, el número que no has dicho en voz alta, y qué hacer con un no.$$,
   $$Pide un número, no una conversación. Dilo, deja de hablar, y trata un no como una pregunta sobre cuándo.$$),

  ('presenting',
   'Presentar',
   $$Diez minutos de pie, unas diapositivas que escribiste tú, y unas ganas enormes de leerlas en voz alta.$$,
   $$Las diapositivas no son tus notas. Di la conclusión primero, habla con una persona cada vez, y responde a la pregunta que te han hecho de verdad.$$),

  ('the-corridor',
   'El pasillo',
   $$Congresos, ascensores, cocinas, y la persona sénior con la que tienes treinta segundos.$$,
   $$La charla en el trabajo cumple una función que la charla normal no cumple: que te reconozcan la próxima vez. Ese es todo el objetivo.$$),

  -- Conocer a alguien ------------------------------------------------------
  ('walking-up',
   'Acercarse',
   $$El bar, la cola, el gimnasio, la librería, y los veinte segundos antes de decidir si esta es una sala donde puedes.$$,
   $$Toda sala te da tres cosas: permiso para hablar, tiempo antes de que se acabe sola, y lo que cuesta si sale plano. Lee esas tres y el arranque se resuelve solo.$$),

  ('first-two-minutes',
   'Los dos primeros minutos',
   $$El hueco entre un arranque que funcionó y una conversación de verdad, que es donde mueren en silencio casi todos los acercamientos.$$,
   $$No te disculpes por estar ahí, intercambia nombres pronto, y aspira a ser agradable dos minutos en vez de interesante durante diez.$$),

  ('flirting-moves',
   'Flirtear: las jugadas',
   $$De qué está hecha la calidez en realidad: el pique, el cumplido correcto, la mirada, el contacto, y darte cuenta cuando va dirigido a ti.$$,
   $$Flirtear es calidez que solo podría ir dirigida a esa persona, más la ambigüedad justa para que cualquiera de los dos pudiera llamarlo simpatía.$$),

  ('flirting-calibration',
   'Flirtear: calibrar',
   $$Cuánta calidez, y cuándo: ofrecida de escalón en escalón y comprobada cada vez.$$,
   $$Señal, lectura, ajuste. Sube la calidez un escalón y comprueba si te la devuelven.$$),

  ('reading-disinterest',
   'Leer el desinterés y retirarse',
   $$Darte cuenta de que el interés no es mutuo, e irte con calidez.$$,
   $$Respuestas cortas, postura cerrada, ninguna pregunta de vuelta: baja un escalón, sin enfurruñarte. Ser bueno en esto es lo que hace que flirtear se pueda practicar sin riesgo.$$),

  ('asking-for-the-number',
   'Pedir el número',
   $$El cierre: cuándo pedirlo, cómo pedirlo para que un no no les cueste nada, y qué hacer con la respuesta sea cual sea.$$,
   $$Pídelo mientras todavía va bien, no al irte. Di qué te apetece hacer, y haz que decir que no salga gratis. Y luego escribe el mismo día.$$),

  -- Apps de citas ----------------------------------------------------------
  ('your-profile',
   'Tu perfil',
   $$Seis fotos y cuarenta palabras, haciendo el único trabajo que probablemente no les estabas pidiendo.$$,
   $$Un perfil no es un anuncio, es un conjunto de ganchos. Cada línea debería ser algo a lo que alguien pudiera responder.$$),

  ('first-message',
   'El primer mensaje',
   $$Un match, un chat sin empezar, y como un día antes de que deje de ser un match.$$,
   $$Una cosa concreta de su perfil, una pregunta, menos de treinta palabras. «Hola» no es un mensaje, y tres preguntas son una pregunta.$$),

  ('match-to-date',
   'Del match a una cita',
   $$El medio que no enseña nadie: los tres primeros intercambios, la trampa del interrogatorio, y proponer de forma que decir que sí sea fácil.$$,
   $$Responde y pregunta, sal pronto del intercambio de datos, y propón algo concreto en unos pocos días. La app no es el objetivo.$$),

  ('running-the-app',
   'La llevas tú',
   $$Cuarenta deslizamientos, dos matches, una respuesta, ninguna respuesta. Lo que eso le hace a alguien en seis meses, y cómo pararlo.$$,
   $$El volumen es aritmética, no una nota. Dale una forma a la app — cuándo la abres, cuánto rato, cuándo paras — y toma el silencio como ruido.$$),

  ('where-it-is-breaking',
   'Dónde se está rompiendo',
   $$No está funcionando, y llevas cuatro meses arreglando la parte equivocada.$$,
   $$Cuatro costuras: matches, respuestas, citas, segundas citas. Cada fallo apunta a un sitio distinto, y solo uno se arregla editando tu perfil.$$),

  -- La primera cita --------------------------------------------------------
  ('before-you-go',
   'Antes de ir',
   $$Adónde ir, cuánto quedarse, y las cuatro horas de pavor de antes.$$,
   $$Elige un sitio corto y fácil de dejar, decide la duración de antemano, y ve a averiguar si quieres una segunda, no a caer bien.$$),

  ('the-conversation',
   'Dos horas de conversación',
   $$El comienzo incómodo, la trampa del interrogatorio, y cuánto de ti poner ahí dentro.$$,
   $$Dale veinte minutos antes de decidir nada, reacciona en vez de informar, y cuenta de ti más de lo que resulta cómodo.$$),

  ('do-you-like-them',
   'Averiguar si te gusta',
   $$La pregunta que se te olvida hacer, porque estás muy ocupado siendo quien está bajo evaluación.$$,
   $$Tú también estás eligiendo. Pregúntate si lo estás disfrutando, no si está yendo bien: son preguntas distintas y solo una sirve.$$),

  ('what-happens-next',
   'Qué pasa después',
   $$Los últimos veinte minutos, si dices la cosa o no, y cómo se acuerda de verdad una segunda cita.$$,
   $$Termínala mientras todavía está bien, di claramente que te gustaría otra, y hazla lo bastante concreta como para poder decir que sí.$$),

  -- Hacer amigos -----------------------------------------------------------
  ('why-it-got-hard',
   'Por qué se puso difícil',
   $$Por qué hacer amigos no costaba nada a los diecinueve y ahora sí, y qué te dice eso en realidad.$$,
   $$La amistad se hace con contacto repetido, no planeado y de bajo riesgo. El colegio y la universidad lo suministraban y la vida adulta no. Elige una sala que se repita.$$),

  ('first-invitation',
   'De conocido a algo',
   $$La persona que te cae bien y a la que no has visto ni una sola vez fuera de la sala donde la conociste.$$,
   $$Invítala a algo que tenga un día dentro. Pequeño, concreto y de bajo riesgo, y di eso que a todo el mundo le da vergüenza decir.$$),

  ('the-second-time',
   'La segunda vez, y la tercera',
   $$Un café ocurrió, los dos lo disfrutasteis, y eso fue hace ocho meses.$$,
   $$Las amistades las hace quien toma la iniciativa dos veces. Casi todo el mundo llega a una, y luego espera pruebas de que se le quiere.$$),

  ('getting-past-pleasant',
   'Pasar de lo agradable',
   $$Puedes conocer a alguien cuatro años, apreciarlo enormemente, y no estar en ninguna parte.$$,
   $$La amistad empieza cuando dejáis de hablar de cosas y empezáis a hablar de vosotros. Alguien tiene que ir primero, en pasos pequeños.$$),

  ('keeping-it-alive',
   'Mantenerlo vivo',
   $$El amigo al que no escribes desde hace dos años, y los noventa segundos que lo arreglan.$$,
   $$Manda cosas que no pidan nada. Y cuando se ha caído, retómalo en una línea, sin disculpa y sin explicación.$$),

  -- Conversaciones difíciles -----------------------------------------------
  ('worth-having',
   'Si tenerla siquiera',
   $$Un mes ensayándola en la ducha, y ninguna conversación. Qué es ese mes en realidad, y cómo decidir.$$,
   $$Ensayar no es prepararse. Tenla si hay un cambio que quieres, o si de lo contrario vas a seguir cargándola. Y si no es ninguna de las dos, suéltala bien.$$),

  ('opening-it',
   'Abrirla',
   $$Los primeros treinta segundos, y las dos formas en que la gente los destroza antes de que nadie haya dicho nada.$$,
   $$Pide el rato y nombra el tema en la misma frase. Y luego di la cosa en los primeros treinta segundos, no después de diez minutos de calentamiento.$$),

  ('saying-the-thing',
   'Decir la cosa',
   $$Qué dices exactamente, y las cuatro costumbres que convierten un problema resoluble en una discusión sobre tu carácter o el suyo.$$,
   $$Qué pasó, qué provocó, qué quieres. Dilo una vez, hazte cargo de lo que sentiste en vez de afirmar sus intenciones, y deja «siempre» y «nunca» fuera.$$),

  ('staying-in-the-room',
   'Quedarte en la sala',
   $$Se ponen a la defensiva, se disgustan, o te dan la vuelta a la tortilla, y tienes treinta segundos para decidir qué clase de persona vas a ser.$$,
   $$Su reacción no es un veredicto sobre si tenías razón. No rellenes el silencio, no retires lo que dijiste, y no subas el tono para igualarles.$$),

  ('hearing-it',
   'Oírlo sobre ti',
   $$Alguien acaba de decirte algo verdadero y poco grato, y tu cara ya ha decidido qué hacer al respecto.$$,
   $$No digas nada durante tres segundos, pide el ejemplo concreto, y tómate el derecho a pensarlo. Y luego pide perdón sin la palabra «pero».$$),

  -- Contar historias -------------------------------------------------------
  ('why-stories-die',
   'Por qué mueren tus historias',
   $$Terminas, hay una pausa pequeña, y alguien dice «ah, ya». El material estaba bien. Falló otra cosa.$$,
   $$Casi nadie tiene un problema de historias. Tiene tres problemas de estructura: ningún motivo para contarla, demasiado principio, y nada en juego.$$),

  ('the-shape',
   'La forma',
   $$Por dónde empezar, qué cortar, y cómo parar, que es todo lo que separa una historia de una serie de sucesos.$$,
   $$Enmárcala en una línea, empieza tarde, asegúrate de que algo gira, y termina en la frase y no en la explicación.$$),

  ('telling-it',
   'Contarla',
   $$Presente, palabras textuales, un detalle que funcione, y saber tu última frase antes de empezar.$$,
   $$Mete a la gente en el momento en vez de informar de él después. Y decide dónde termina antes de empezar.$$),

  ('holding-the-floor',
   'Tener la palabra',
   $$La creencia de que noventa segundos de la atención de una mesa son un abuso, y qué hacer con ella.$$,
   $$Una historia bien contada es un regalo y una mal contada es un impuesto. Ten claro cuánto tiempo tienes, y ten claro cómo aterrizar una que se está muriendo.$$),

  ('no-warning',
   'Levantarte sin previo aviso',
   $$«Di unas palabras.» Treinta caras se giran, y tienes unos cuatro segundos.$$,
   $$Tres frases son un discurso: una cosa que quieres decir, un ejemplo concreto, y un cierre. Más corto siempre es mejor.$$),

  -- Mensajes ---------------------------------------------------------------
  ('stop-apologising',
   'Deja de disculparte',
   $$Perdona que te moleste, sé que estás liado, esto es probablemente una tontería, pero… y luego, por fin, la cosa.$$,
   $$Pon la petición en la primera línea y borra todo lo que va delante. La disculpa es lo que hace que una petición normal parezca un abuso.$$),

  ('easy-to-reply-to',
   'Fácil de contestar',
   $$Por qué a unos les contestan en cuatro minutos y a otros el jueves, que casi nunca tiene que ver con lo importantes que son.$$,
   $$Una petición, la petición primero, y que contestar salga barato. Todo lo que le dejes deducir a quien lee es un motivo para contestar más tarde.$$),

  ('tone-with-no-tone',
   'Tono sin tono',
   $$Todo lo que escribes se lee un poco más frío de lo que querías, y todo lo que recibes se está leyendo igual.$$,
   $$La calidez no está en las palabras que habrías usado en voz alta: hay que añadirla a propósito. Y una respuesta seca casi nunca es lo que parece.$$),

  ('group-chats',
   'Grupos',
   $$Seis personas, ningún turno de palabra, y un mensaje que has escrito y borrado tres veces mientras la conversación seguía.$$,
   $$Mándalo igual. Nadie lleva la cuenta de un grupo, la tasa de reacción es baja para todo el mundo, y estar callado suena más fuerte que cualquier cosa que hubieras dicho.$$),

  ('not-everything-is-a-message',
   'No todo es un mensaje',
   $$Eso que ya has explicado tres veces por escrito, y las cuatro horas que llevas mirando un tic gris.$$,
   $$Algunas cosas son una llamada. Y un silencio casi nunca es un mensaje: el significado que le estás leyendo a un hueco no está dentro.$$),

  -- Hablar con la IA -------------------------------------------------------
  ('an-answer-worth-having',
   'Una respuesta que valga',
   $$Casi todo lo que vuelve es genérico porque casi todo lo que entra es una descripción del problema en vez del problema.$$,
   $$Dale el material de verdad, di para qué es la respuesta, y discute con lo que vuelve en vez de empezar otra vez.$$),

  ('the-free-question',
   'La pregunta gratis',
   $$Eso que todo el mundo da por hecho que ya sabes, y a lo que llevas seis meses asintiendo.$$,
   $$Es el único sitio donde una pregunta no cuesta nada. Haz la que te da vergüenza, hazla hasta que la entiendas, y luego llévate lo aprendido a la sala.$$),

  ('edit-do-not-write',
   'Edita, no escribas',
   $$Te va a escribir algo fluido, cálido y un poco demasiado largo, y cualquiera que te conozca va a notar que no eras tú.$$,
   $$Escríbelo mal tú primero, y luego pide recortes en vez de mejoras. El mal borrador es lo que hace que el resultado sea tuyo.$$),

  ('rehearse-it-first',
   'Ensáyalo antes',
   $$La conversación del martes que ya has tenido cuarenta veces en tu cabeza, ninguna de ellas en voz alta.$$,
   $$Describe a la persona real, pídele que la interprete mal dispuesta, y encuentra la frase que estás evitando. Y luego di el arranque en voz alta.$$),

  ('it-does-not-know-the-room',
   'No conoce la sala',
   $$No ha conocido a esta gente, no tiene ni idea de cómo se habla de verdad en tu oficina, y va a responder con total seguridad igualmente.$$,
   $$Es fiable con el texto y poco fiable con las personas. No le preguntes nunca qué significa un mensaje, y comprueba si solo te está dando la razón.$$),

  ('do-not-outsource-the-reps',
   'No delegues las repeticiones',
   $$La herramienta que quita la incomodidad quita también la práctica, y la práctica era todo el objetivo.$$,
   $$Antes y después, nunca durante. Cuando el esfuerzo es el mensaje, tu frase peor es la mejor, y las repeticiones son con personas.$$)

) as v(slug, name, description, core_idea)
join public.skills s on s.slug = v.slug
on conflict (skill_id, locale) do update set
  name = excluded.name,
  description = excluded.description,
  core_idea = excluded.core_idea,
  updated_at = now();
