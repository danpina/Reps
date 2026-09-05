-- Correction migration for the full topic-by-topic Spanish quality review.
-- Applies every confirmed fix (forced English calques, wrong-register jargon,
-- invented words, gender-consistency slips, a couple of outright grammar
-- errors, and one mistranslated title) found across small-talk, interviews,
-- work, meeting-someone, dating-apps, first-date, making-friends,
-- hard-conversations, storytelling, online-chatting, and ai-prompting.
--
-- Each fix was matched directly against the live database by content before
-- being included here (not hand-written WHERE clauses), so every
-- substitution below is verified to hit real, current text. Every block is
-- scoped to the one lesson/topic/skill it was found in - never a blanket
-- replace across the whole locale - since some fix phrases are short enough
-- that a wider scope could coincidentally touch unrelated content.

-- topic_translations topic_id=ba45bb02-d4cd-4d71-b8b4-e48baede6960
create or replace function pg_temp.fix_1(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Conversación ligera', 'Charla trivial');
$fn$;
update public.topic_translations t set
  name = pg_temp.fix_1(t.name),
  updated_at = now()
where t.locale = 'es' and t.topic_id = 'ba45bb02-d4cd-4d71-b8b4-e48baede6960';

-- lesson_translations lesson_id=69e9e775-9258-4e97-a574-cea562424a82
create or replace function pg_temp.fix_2(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(replace(replace(input, 'Buscas aterrizar en el mismo estante, no ganar.', 'Buscas quedarte a su misma altura, no ganar.'), 'Mismo estante. Una queja pequeña respondida con una queja pequeña, más un detalle concreto para que no sea solo darles la razón.', 'Misma altura. Una queja pequeña respondida con una queja pequeña, más un detalle concreto para que no sea solo darles la razón.'), 'Mismo estante, y lo bastante concreto como para ser una confidencia de verdad y no un ruido educado. Ahora saben que no son raros.', 'Misma altura, y lo bastante concreto como para ser una confidencia de verdad y no un ruido educado. Ahora saben que no son raros.'), 'Aterriza en el mismo estante. Contestar profundidad con logística rechaza la oferta, y contestarla con más profundidad se apropia de la conversación.', 'Quédate a su misma altura. Contestar profundidad con logística rechaza la oferta, y contestarla con más profundidad se apropia de la conversación.'), 'Aterrizaste en el mismo estante', 'Te quedaste a su altura');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_2(t.theory_md),
  examples_json = pg_temp.fix_2(t.examples_json::text)::jsonb,
  checks_json = pg_temp.fix_2(t.checks_json::text)::jsonb,
  rubric_json = pg_temp.fix_2(t.rubric_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '69e9e775-9258-4e97-a574-cea562424a82';

-- lesson_translations lesson_id=274d9905-de72-4edd-b355-b638742160c5
create or replace function pg_temp.fix_3(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(replace(replace(input, 'Esa cláusula de más es la técnica entera.', 'Esa frase de más es la técnica entera.'), 'Iguala la confidencia y añade una admisión que no hacía falta. La cláusula de más es el paso.', 'Iguala la confidencia y añade una admisión que no hacía falta. La frase de más es el paso.'), 'Responde a lo que te han dado, y luego añade una cláusula que no tenías que decir. Esa cláusula de más es lo que deja que la conversación baje.', 'Responde a lo que te han dado, y luego añade una frase que no tenías que decir. Esa frase de más es lo que deja que la conversación baje.'), 'Hoy, iguala una confidencia y luego añade una cláusula que no tenías que decir. Anota qué te dieron, qué igualaste y qué añadiste.', 'Hoy, iguala una confidencia y luego añade una frase que no tenías que decir. Anota qué te dieron, qué igualaste y qué añadiste.'), 'Ahora añade una cláusula que no tenías que decir, y devuélvesela.', 'Ahora añade una frase que no tenías que decir, y devuélvesela.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_3(t.theory_md),
  examples_json = pg_temp.fix_3(t.examples_json::text)::jsonb,
  checks_json = pg_temp.fix_3(t.checks_json::text)::jsonb,
  mission_text = pg_temp.fix_3(t.mission_text),
  rehearsal_spec = pg_temp.fix_3(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '274d9905-de72-4edd-b355-b638742160c5';

-- lesson_translations lesson_id=57285176-62c4-4616-a112-f6fa8ab508b7
create or replace function pg_temp.fix_4(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(replace(replace(input, 'La parte cálida es donde casi todo el mundo invierte de menos. *Encantado de conocerte* no es calidez, es mobiliario. Un detalle concreto convierte un final genérico en la cosa que recuerdan de ti.', 'La parte cálida es donde casi todo el mundo invierte de menos. *Encantado de conocerte* no es calidez, es relleno. Un detalle concreto convierte un final genérico en la cosa que recuerdan de ti.'), 'Casi todo el mundo la sustituye por mobiliario tipo encantado de conocerte. Un detalle concreto de la conversación real es lo que se recuerda.', 'Casi todo el mundo la sustituye por relleno tipo encantado de conocerte. Un detalle concreto de la conversación real es lo que se recuerda.'), 'Motivo, calidez, fuera. La calidez necesita un detalle concreto o es solo mobiliario.', 'Motivo, calidez, fuera. La calidez necesita un detalle concreto o es solo relleno.'), '¿Cuál es algo cálido concreto en vez de mobiliario?', '¿Cuál es algo cálido concreto en vez de relleno?'), 'La definición de mobiliario. Agradable, automático, olvidado al instante.', 'La definición de relleno. Agradable, automático, olvidado al instante.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_4(t.theory_md),
  checks_json = pg_temp.fix_4(t.checks_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '57285176-62c4-4616-a112-f6fa8ab508b7';

-- lesson_translations lesson_id=4ff0cd4e-0669-4246-8851-1d77940f977f
create or replace function pg_temp.fix_5(input text) returns text
language sql immutable as $fn$
  select replace(replace(input, 'El malo es a mitad de hilo, cuando alguien está construyendo hacia un remate. Hablar ahí te convierte en quien lo descarriló, digas lo que digas.', 'El malo es a mitad de hilo, cuando alguien está construyendo hacia un aterrizaje. Hablar ahí te convierte en quien lo descarriló, digas lo que digas.'), 'Evitaste hablar mientras alguien construía hacia un remate.', 'Evitaste hablar mientras alguien construía hacia un aterrizaje.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_5(t.theory_md),
  rubric_json = pg_temp.fix_5(t.rubric_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '4ff0cd4e-0669-4246-8851-1d77940f977f';

-- topic_translations topic_id=1131b08a-1196-41c1-810f-fd1033cb67f3
create or replace function pg_temp.fix_6(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Ya has hecho el trabajo. Ahora tienes cuarenta minutos para demostrárselo a un desconocido con un cuaderno, y casi todo se decide en seis preguntas.', 'Ya has hecho el trabajo duro. Ahora tienes cuarenta minutos para demostrárselo a un desconocido con una libreta, y casi todo se decide en seis preguntas.');
$fn$;
update public.topic_translations t set
  description = pg_temp.fix_6(t.description),
  updated_at = now()
where t.locale = 'es' and t.topic_id = '1131b08a-1196-41c1-810f-fd1033cb67f3';

-- lesson_translations lesson_id=df2615a6-954d-4819-9255-f50d9e65f3d6
create or replace function pg_temp.fix_7(input text) returns text
language sql immutable as $fn$
  select replace(input, 'El punto dulce es un fracaso real con un coste acotado, contado sin drama.', 'El término medio es un fracaso real con un coste acotado, contado sin drama.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_7(t.theory_md),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'df2615a6-954d-4819-9255-f50d9e65f3d6';

-- lesson_translations lesson_id=73a9e2e1-d7b1-4c78-b00a-0d273e0687ef
create or replace function pg_temp.fix_8(input text) returns text
language sql immutable as $fn$
  select replace(input, 'era conseguir que los dos jefes se pusieran de acuerdo en de quién era.', 'era conseguir que los dos jefes se pusieran de acuerdo en de quién era la decisión final.');
$fn$;
update public.lesson_translations t set
  examples_json = pg_temp.fix_8(t.examples_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '73a9e2e1-d7b1-4c78-b00a-0d273e0687ef';

-- topic_translations topic_id=b96e4290-da07-4803-91bb-89262161d4c7
create or replace function pg_temp.fix_9(input text) returns text
language sql immutable as $fn$
  select replace(input, 'y sostener una sala en la que no esperabas estar de pie.', 'y dominar una sala en la que no esperabas estar de pie.');
$fn$;
update public.topic_translations t set
  promise = pg_temp.fix_9(t.promise),
  updated_at = now()
where t.locale = 'es' and t.topic_id = 'b96e4290-da07-4803-91bb-89262161d4c7';

-- topic_translations topic_id=8b1ec772-54c4-4e5c-b5de-81c00c2d5a5d
create or replace function pg_temp.fix_10(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Un match, una caja de mensaje en blanco, y una conversación que tiene que sobrevivir sin tono, sin tiempos y sin cara.', 'Un match, un chat en blanco, y una conversación que tiene que sobrevivir sin tono, sin tiempos y sin cara.');
$fn$;
update public.topic_translations t set
  description = pg_temp.fix_10(t.description),
  updated_at = now()
where t.locale = 'es' and t.topic_id = '8b1ec772-54c4-4e5c-b5de-81c00c2d5a5d';

-- skill_translations skill_id=01667e82-29b5-4737-ac81-c8d1ff8b5614
create or replace function pg_temp.fix_11(input text) returns text
language sql immutable as $fn$
  select replace(input, 'La charla en el trabajo tiene un trabajo que la charla normal no tiene: que te reconozcan la próxima vez. Ese es todo el objetivo.', 'La charla en el trabajo cumple una función que la charla normal no cumple: que te reconozcan la próxima vez. Ese es todo el objetivo.');
$fn$;
update public.skill_translations t set
  core_idea = pg_temp.fix_11(t.core_idea),
  updated_at = now()
where t.locale = 'es' and t.skill_id = '01667e82-29b5-4737-ac81-c8d1ff8b5614';

-- skill_translations skill_id=3bb31218-4d52-4a20-858d-988f881f3552
create or replace function pg_temp.fix_12(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Respuestas cortas, postura cerrada, ninguna pregunta de vuelta: baja un registro, sin enfurruñarte. Ser bueno en esto es lo que hace que flirtear se pueda practicar sin riesgo.', 'Respuestas cortas, postura cerrada, ninguna pregunta de vuelta: baja un escalón, sin enfurruñarte. Ser bueno en esto es lo que hace que flirtear se pueda practicar sin riesgo.');
$fn$;
update public.skill_translations t set
  core_idea = pg_temp.fix_12(t.core_idea),
  updated_at = now()
where t.locale = 'es' and t.skill_id = '3bb31218-4d52-4a20-858d-988f881f3552';

-- skill_translations skill_id=2aa81bd6-ec64-4a15-be2f-37317f6ef8c2
create or replace function pg_temp.fix_13(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Un match, una caja en blanco, y como un día antes de que deje de ser un match.', 'Un match, un chat sin empezar, y como un día antes de que deje de ser un match.');
$fn$;
update public.skill_translations t set
  description = pg_temp.fix_13(t.description),
  updated_at = now()
where t.locale = 'es' and t.skill_id = '2aa81bd6-ec64-4a15-be2f-37317f6ef8c2';

-- skill_translations skill_id=712f2fc4-1f2c-4d56-83f9-4316220f8ffc
create or replace function pg_temp.fix_14(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Llevarla tú a ella', 'La llevas tú');
$fn$;
update public.skill_translations t set
  name = pg_temp.fix_14(t.name),
  updated_at = now()
where t.locale = 'es' and t.skill_id = '712f2fc4-1f2c-4d56-83f9-4316220f8ffc';

-- skill_translations skill_id=28b2fe07-8a9f-41ce-8990-f792565e55ee
create or replace function pg_temp.fix_15(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Se ponen a la defensiva, se disgustan, o te lo dan la vuelta, y tienes treinta segundos para decidir qué clase de persona vas a ser.', 'Se ponen a la defensiva, se disgustan, o te dan la vuelta a la tortilla, y tienes treinta segundos para decidir qué clase de persona vas a ser.');
$fn$;
update public.skill_translations t set
  description = pg_temp.fix_15(t.description),
  updated_at = now()
where t.locale = 'es' and t.skill_id = '28b2fe07-8a9f-41ce-8990-f792565e55ee';

-- skill_translations skill_id=070c32d8-2e75-4a8f-989a-6a9826657552
create or replace function pg_temp.fix_16(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Presente, palabras textuales, un detalle que trabaje, y saber tu última frase antes de empezar.', 'Presente, palabras textuales, un detalle que funcione, y saber tu última frase antes de empezar.');
$fn$;
update public.skill_translations t set
  description = pg_temp.fix_16(t.description),
  updated_at = now()
where t.locale = 'es' and t.skill_id = '070c32d8-2e75-4a8f-989a-6a9826657552';

-- skill_translations skill_id=18b8d6f4-65d5-49d0-b85d-35efa1b734d5
create or replace function pg_temp.fix_17(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Mándalo igual. Nadie audita un grupo, la tasa de reacción es baja para todo el mundo, y estar callado suena más fuerte que cualquier cosa que hubieras dicho.', 'Mándalo igual. Nadie lleva la cuenta de un grupo, la tasa de reacción es baja para todo el mundo, y estar callado suena más fuerte que cualquier cosa que hubieras dicho.');
$fn$;
update public.skill_translations t set
  core_idea = pg_temp.fix_17(t.core_idea),
  updated_at = now()
where t.locale = 'es' and t.skill_id = '18b8d6f4-65d5-49d0-b85d-35efa1b734d5';

-- lesson_translations lesson_id=c634a360-7ff6-4b1a-9be6-10ce6a82056c
create or replace function pg_temp.fix_18(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Llevarlo hacia arriba', 'Llevarlo más arriba');
$fn$;
update public.lesson_translations t set
  title = pg_temp.fix_18(t.title),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'c634a360-7ff6-4b1a-9be6-10ce6a82056c';

-- lesson_translations lesson_id=e50e7383-5b8b-427b-8709-174794c6efdc
create or replace function pg_temp.fix_19(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Darte cuenta de vuelta', 'Notar cuando va por ti');
$fn$;
update public.lesson_translations t set
  title = pg_temp.fix_19(t.title),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'e50e7383-5b8b-427b-8709-174794c6efdc';

-- lesson_translations lesson_id=5a021950-1c33-4c4e-9f31-5289f1285260
create or replace function pg_temp.fix_20(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Deja que hagan parte del trabajo', 'Deja que pongan de su parte');
$fn$;
update public.lesson_translations t set
  title = pg_temp.fix_20(t.title),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '5a021950-1c33-4c4e-9f31-5289f1285260';

-- lesson_translations lesson_id=2197746e-7b2b-42a3-9ecd-7662c52f5609
create or replace function pg_temp.fix_21(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(input, 'Baja un registro', 'Baja un escalón'), 'Cuando lees desinterés, la respuesta no es irte de inmediato y no es esforzarte más. Es bajar un registro.', 'Cuando lees desinterés, la respuesta no es irte de inmediato y no es esforzarte más. Es bajar un escalón.'), 'Bajar un registro significa devolver la conversación al nivel de calidez que claramente es bienvenido. De personal a simpático. De simpático a educado. No te estás retirando ni castigando, simplemente estás igualando lo que se ofrece.', 'Bajar un escalón significa devolver la conversación al nivel de calidez que claramente es bienvenido. De personal a simpático. De simpático a educado. No te estás retirando ni castigando, simplemente estás igualando lo que se ofrece.'), 'Has bajado un registro y la conversación se ha relajado de forma notable.', 'Has bajado un escalón y la conversación se ha relajado de forma notable.'), 'Has bajado un registro y siguen dando respuestas cerradas.', 'Has bajado un escalón y siguen dando respuestas cerradas.'), 'Bajas un registro y de inmediato se relajan y se ponen más graciosos. ¿Qué ha pasado?', 'Bajas un escalón y de inmediato se relajan y se ponen más graciosos. ¿Qué ha pasado?'), 'Bajó un registro', 'Bajó un escalón'), 'Se vuelve notablemente más cálida y graciosa en cuanto el registro baja a simpático.', 'Se vuelve notablemente más cálida y graciosa en cuanto bajas al escalón simpático.'), 'La persona baja un registro sin anunciarlo, y la conversación se vuelve genuinamente disfrutable al nivel simpático.', 'La persona baja un escalón sin anunciarlo, y la conversación se vuelve genuinamente disfrutable al nivel simpático.'), 'Hoy, baja un registro en una conversación donde la calidez no se correspondió. Mantente simpático. Apunta qué cambió después de hacerlo.', 'Hoy, baja un escalón en una conversación donde la calidez no se correspondió. Mantente simpático. Apunta qué cambió después de hacerlo.');
$fn$;
update public.lesson_translations t set
  title = pg_temp.fix_21(t.title),
  theory_md = pg_temp.fix_21(t.theory_md),
  examples_json = pg_temp.fix_21(t.examples_json::text)::jsonb,
  checks_json = pg_temp.fix_21(t.checks_json::text)::jsonb,
  rubric_json = pg_temp.fix_21(t.rubric_json::text)::jsonb,
  scenario_json = pg_temp.fix_21(t.scenario_json::text)::jsonb,
  mission_text = pg_temp.fix_21(t.mission_text),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '2197746e-7b2b-42a3-9ecd-7662c52f5609';

-- lesson_translations lesson_id=0128391e-d4bc-46bd-92a4-cbe71adba917
create or replace function pg_temp.fix_22(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Las fotos tienen un trabajo', 'Cada foto tiene un trabajo');
$fn$;
update public.lesson_translations t set
  title = pg_temp.fix_22(t.title),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '0128391e-d4bc-46bd-92a4-cbe71adba917';

-- lesson_translations lesson_id=1cd1ce7b-eca0-4989-911e-d2d7a35c2a76
create or replace function pg_temp.fix_23(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Cuando le dan la vuelta', 'Cuando te dan la vuelta a la tortilla');
$fn$;
update public.lesson_translations t set
  title = pg_temp.fix_23(t.title),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '1cd1ce7b-eca0-4989-911e-d2d7a35c2a76';

-- lesson_translations lesson_id=d9de8e15-1f7e-468c-ae10-9f1761979b26
create or replace function pg_temp.fix_24(input text) returns text
language sql immutable as $fn$
  select replace(input, '**La jugada:** dos palabras de pista de despegue, y luego el argumento.', '**La jugada:** dos palabras de pista, y luego el argumento.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_24(t.theory_md),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'd9de8e15-1f7e-468c-ae10-9f1761979b26';

-- lesson_translations lesson_id=e21ca609-1699-4c04-8c92-5857b96652be
create or replace function pg_temp.fix_25(input text) returns text
language sql immutable as $fn$
  select replace(input, 'La señal son respuestas sin ningún asa, nada que te ofrezcan para agarrarte.', 'La señal son respuestas sin ningún asidero, nada que te ofrezcan para agarrarte.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_25(t.theory_md),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'e21ca609-1699-4c04-8c92-5857b96652be';

-- lesson_translations lesson_id=3a396bc5-a600-4d0e-9acc-4ace0068b82e
create or replace function pg_temp.fix_26(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Bajaste un registro y se volvieron notablemente más cálidos.', 'Bajaste un escalón y se volvieron notablemente más cálidos.');
$fn$;
update public.lesson_translations t set
  examples_json = pg_temp.fix_26(t.examples_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '3a396bc5-a600-4d0e-9acc-4ace0068b82e';

-- lesson_translations lesson_id=286799e9-eb3f-47a5-8cef-3c9b16ba6e25
create or replace function pg_temp.fix_27(input text) returns text
language sql immutable as $fn$
  select replace(input, 'creepy', 'mal rollo');
$fn$;
update public.lesson_translations t set
  rehearsal_spec = pg_temp.fix_27(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '286799e9-eb3f-47a5-8cef-3c9b16ba6e25';

-- lesson_translations lesson_id=bca2713a-84e1-466b-a550-3400d816b7cb
create or replace function pg_temp.fix_28(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(input, 'La casilla del prompt está abierta y el prompt en la pantalla dice: una colina en la que morir.', 'La casilla del prompt está abierta y el prompt en la pantalla dice: Una opinión que defendería hasta el final.'), '«Una colina en la que morir. Y antes de que pongas piña en la pizza — ¿quién te lo iba a discutir de verdad?»', '«Una opinión que defendería hasta el final. Y antes de que pongas piña en la pizza — ¿quién te lo iba a discutir de verdad?»'), 'Una colina en la que morir:', 'Una opinión que defendería hasta el final:');
$fn$;
update public.lesson_translations t set
  scenario_json = pg_temp.fix_28(t.scenario_json::text)::jsonb,
  rehearsal_spec = pg_temp.fix_28(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'bca2713a-84e1-466b-a550-3400d816b7cb';

-- lesson_translations lesson_id=3e1ce87d-a5ab-474b-ac65-e368e49d264b
create or replace function pg_temp.fix_29(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Dejó algo que decir de vuelta en vez de cerrar con un remate.', 'Dejó algo que decir de vuelta en vez de cerrar la conversación con una ocurrencia sin respuesta posible.');
$fn$;
update public.lesson_translations t set
  rubric_json = pg_temp.fix_29(t.rubric_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '3e1ce87d-a5ab-474b-ac65-e368e49d264b';

-- lesson_translations lesson_id=1689740d-2991-4834-94bb-735c1b9d84e3
create or replace function pg_temp.fix_30(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(replace(input, 'Luego mándalo. Todo esto es un solo mensaje y no debería ir precedido de tres mensajes de carraspeo, que es lo que produce el pavor.', 'Luego mándalo. Todo esto es un solo mensaje y no debería ir precedido de tres mensajes de preámbulo, que es lo que produce el pavor.'), 'Concreto, pequeño, dos momentos. Luego mándalo sin tres mensajes de carraspeo.', 'Concreto, pequeño, dos momentos. Luego mándalo sin tres mensajes de preámbulo.'), 'Un mensaje, sin carraspeo delante.', 'Un mensaje, sin preámbulo delante.'), 'Un mensaje, sin carraspeo', 'Un mensaje, sin preámbulo');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_30(t.theory_md),
  checks_json = pg_temp.fix_30(t.checks_json::text)::jsonb,
  rubric_json = pg_temp.fix_30(t.rubric_json::text)::jsonb,
  rehearsal_spec = pg_temp.fix_30(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '1689740d-2991-4834-94bb-735c1b9d84e3';

-- lesson_translations lesson_id=fcfdfb07-edd9-41da-8e44-0993d778cc2f
create or replace function pg_temp.fix_31(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(replace(replace(input, 'Este es el argumento práctico para el ritmo que ya recomendaba el bloque anterior, y es la mitad más importante. Unos días de mensajes producen curiosidad, que viaja bien hasta una sala. Tres semanas producen una relación con un constructo, y luego llega una persona real a competir con él — cosa que no puede hacer, porque ella es una persona y él no.', 'Este es el argumento práctico para el ritmo que ya recomendaba el bloque anterior, y es la mitad más importante. Unos días de mensajes producen curiosidad, que viaja bien hasta una sala. Tres semanas producen una relación con una versión inventada de esa persona, y luego llega una persona real a competir con ella — cosa que no puede hacer, porque una es persona y la otra no.'), 'Unos días producen curiosidad, que viaja hasta una sala. Tres semanas producen un constructo con el que luego tiene que competir una persona real.', 'Unos días producen curiosidad, que viaja hasta una sala. Tres semanas producen una versión inventada de esa persona, con la que luego tiene que competir la persona real.'), 'Cerca, y se deja fuera tu propia contribución — que es la mitad que hace tan atractivo al constructo.', 'Cerca, y se deja fuera tu propia contribución — que es la mitad que hace tan atractiva a esa versión inventada.'), 'Queda pronto, antes de que haya un constructo contra el que la persona real tenga que perder.', 'Queda pronto, antes de que haya una versión inventada de esa persona contra la que la persona real tenga que perder.'), 'La persona reconoce el constructo y se mueve hacia quedar.', 'La persona reconoce la versión inventada y se mueve hacia quedar.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_31(t.theory_md),
  examples_json = pg_temp.fix_31(t.examples_json::text)::jsonb,
  checks_json = pg_temp.fix_31(t.checks_json::text)::jsonb,
  scenario_json = pg_temp.fix_31(t.scenario_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'fcfdfb07-edd9-41da-8e44-0993d778cc2f';

-- lesson_translations lesson_id=1b796031-6a50-4651-9635-e54ebc4e2e99
create or replace function pg_temp.fix_32(input text) returns text
language sql immutable as $fn$
  select replace(replace(input, 'es sencillamente la versión más difícil de la sala, elegida por gente que creía estar siendo generosa.', 'es sencillamente la opción más difícil, elegida por gente que creía estar siendo generosa.'), 'La versión más difícil de la sala.', 'La opción más difícil.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_32(t.theory_md),
  rehearsal_spec = pg_temp.fix_32(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '1b796031-6a50-4651-9635-e54ebc4e2e99';

-- lesson_translations lesson_id=3cf09386-fd38-4e9d-811f-83005a8bb1aa
create or replace function pg_temp.fix_33(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Eso es un objeto completamente distinto de una lista de preguntas, y se comporta de forma distinta en la conversación.', 'Eso es algo completamente distinto de una lista de preguntas, y se comporta de forma distinta en la conversación.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_33(t.theory_md),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '3cf09386-fd38-4e9d-811f-83005a8bb1aa';

-- lesson_translations lesson_id=b81dcd54-3b55-4292-b54b-73cb08559d70
create or replace function pg_temp.fix_34(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(input, 'Lo estás, y ella también, y seguiría siendo incómodo aunque ninguno de los dos lo estuviera.', 'Lo estás, y él también, y seguiría siendo incómodo aunque ninguno de los dos lo estuviera.'), 'Dejas de intentarlo, ella lo nota, y la noche se convierte obedientemente en lo que decidiste en el minuto seis.', 'Dejas de intentarlo, él lo nota, y la noche se convierte obedientemente en lo que decidiste en el minuto seis.'), 'Está forzado, ella parece nerviosa, y estás bastante seguro de que aquí no hay nada.', 'Está forzado, él parece nervioso, y estás bastante seguro de que aquí no hay nada.');
$fn$;
update public.lesson_translations t set
  checks_json = pg_temp.fix_34(t.checks_json::text)::jsonb,
  rehearsal_spec = pg_temp.fix_34(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'b81dcd54-3b55-4292-b54b-73cb08559d70';

-- lesson_translations lesson_id=740b3126-f1cd-4a3f-994c-e30ffad505e0
create or replace function pg_temp.fix_35(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(input, 'Si una pausa de verdad se alarga demasiado, la sala está ahí mismo. Algo sobre el sitio, la bebida, la gente de la mesa de al lado.', 'Si una pausa de verdad se alarga demasiado, tienes el sitio ahí mismo, para eso. Algo sobre el sitio, la bebida, la gente de la mesa de al lado.'), '(usa la sala)', '(recurre a lo que hay alrededor)'), 'Usó la sala cuando hizo falta', 'Recurrió a lo que había alrededor');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_35(t.theory_md),
  examples_json = pg_temp.fix_35(t.examples_json::text)::jsonb,
  rubric_json = pg_temp.fix_35(t.rubric_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '740b3126-f1cd-4a3f-994c-e30ffad505e0';

-- lesson_translations lesson_id=ee4573b4-fd7d-4965-9c7d-944dbe538e4e
create or replace function pg_temp.fix_36(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(replace(replace(replace(replace(input, 'Los bloques de flirteo enseñaron la negabilidad. Un peldaño, ofrecido y soltado. Nada declarado, todo recibible como simple amabilidad. Eso estaba bien, y estaba bien por un motivo concreto: estabas tratando con desconocidos cuyo interés era desconocido, y la negabilidad es lo que hace que un movimiento sea seguro de ofrecer y fácil de rechazar.', 'Los bloques de flirteo enseñaron a dejarlo todo negable. Un peldaño, ofrecido y soltado. Nada declarado, todo recibible como simple amabilidad. Eso estaba bien, y estaba bien por un motivo concreto: estabas tratando con desconocidos cuyo interés era desconocido, y poder negarlo es lo que hace que un movimiento sea seguro de ofrecer.'), 'La respuesta correcta es sí, claro que sí, que también es un sentimiento, y luego no pasa nada. La negabilidad era para desconocidos.', 'La respuesta correcta es sí, claro que sí, que también es un sentimiento, y luego no pasa nada. Ser negable era para desconocidos.'), '¿Por qué dejar la negabilidad ahora?', '¿Por qué dejar de ser negable ahora?'), 'Porque la conoces mejor.', 'Porque lo conoces mejor.'), 'La negabilidad es lo que hace que un movimiento sea seguro de ofrecer a un desconocido cuyo interés es desconocido. Aquí se lee como indiferencia en vez de tacto.', 'Que algo sea negable es lo que hace que un movimiento sea seguro de ofrecer a un desconocido cuyo interés es desconocido. Aquí se lee como indiferencia en vez de tacto.'), 'Porque ella lo hará si tú no lo haces.', 'Porque él lo hará si tú no lo haces.'), 'Una afirmación sobre ti en vez de una pregunta sobre la otra persona, sin nada apilado después. La negabilidad era para desconocidos cuyo interés era desconocido, y ya se ha ganado desde entonces.', 'Una afirmación sobre ti en vez de una pregunta sobre la otra persona, sin nada apilado después. Ser negable era para desconocidos cuyo interés era desconocido, y ya se ha ganado desde entonces.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_36(t.theory_md),
  examples_json = pg_temp.fix_36(t.examples_json::text)::jsonb,
  checks_json = pg_temp.fix_36(t.checks_json::text)::jsonb,
  rehearsal_spec = pg_temp.fix_36(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'ee4573b4-fd7d-4965-9c7d-944dbe538e4e';

-- lesson_translations lesson_id=21931c94-50b8-4ee6-8936-9dd55ef6a006
create or replace function pg_temp.fix_37(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Fuera. Has dicho que te gustaría repetirlo y ella ha dicho que a ella también.', 'Fuera. Has dicho que te gustaría repetirlo y él ha dicho que a él también.');
$fn$;
update public.lesson_translations t set
  scenario_json = pg_temp.fix_37(t.scenario_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '21931c94-50b8-4ee6-8936-9dd55ef6a006';

-- lesson_translations lesson_id=bc19260b-4b5d-452b-8dc9-2e707b9992a5
create or replace function pg_temp.fix_38(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(replace(replace(replace(replace(replace(input, 'y sobre todo no ofrezcas tú la alternativa que ella decidió no ofrecer.', 'y sobre todo no ofrezcas tú la alternativa que él decidió no ofrecer.'), 'Tómatelo por lo que significa y no ofrezcas tú la alternativa que ella decidió no ofrecer.', 'Tómatelo por lo que significa y no ofrezcas tú la alternativa que él decidió no ofrecer.'), 'Cálida y evita el conflicto. Rechaza con un motivo en vez de con una negativa, y se incomoda si le ofrecen una semana alternativa.', 'Cálido y evita el conflicto. Rechaza con un motivo en vez de con una negativa, y se incomoda si le ofrecen una semana alternativa.'), 'La acera. Propusiste el jueves o el sábado y ella está respondiendo.', 'La acera. Propusiste el jueves o el sábado y él está respondiendo.'), '«Ah — ando bastante liada ahora mismo, la verdad.»', '«Ah — ando bastante liado ahora mismo, la verdad.»'), 'Propusiste el jueves o el sábado. «Ah — ando bastante liada ahora mismo, la verdad.»', 'Propusiste el jueves o el sábado. «Ah — ando bastante liado ahora mismo, la verdad.»'), 'Ofrecer tú la alternativa que ella decidió no ofrecer, lo que le pide rechazar una segunda vez y más directamente.', 'Ofrecer tú la alternativa que él decidió no ofrecer, lo que le pide rechazar una segunda vez y más directamente.'), 'Convierte treinta segundos en una autopsia, y le pide que dé explicaciones de una noche que ella también estaba simplemente viviendo.', 'Convierte treinta segundos en una autopsia, y le pide que dé explicaciones de una noche que él también estaba simplemente viviendo.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_38(t.theory_md),
  examples_json = pg_temp.fix_38(t.examples_json::text)::jsonb,
  scenario_json = pg_temp.fix_38(t.scenario_json::text)::jsonb,
  rehearsal_spec = pg_temp.fix_38(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'bc19260b-4b5d-452b-8dc9-2e707b9992a5';

-- lesson_translations lesson_id=c3b9db9b-7997-493e-a7ba-dbbc83513ebf
create or replace function pg_temp.fix_39(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(input, 'acabe concluyendo algo peor sobre sí misma que la verdad.', 'acabe concluyendo algo peor sobre sí mismo que la verdad.'), 'Lo va a averiguar, después de una semana revisando su móvil, y va a concluir algo peor sobre sí misma que la verdad.', 'Lo va a averiguar, después de una semana revisando su móvil, y va a concluir algo peor sobre sí mismo que la verdad.'), 'Os pasasteis veinte minutos discrepando alegremente sobre aeropuertos, y ella mencionó un sitio cerca de su piso que nunca ha probado.', 'Os pasasteis veinte minutos discrepando alegremente sobre aeropuertos, y él mencionó un sitio cerca de su piso que nunca ha probado.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_39(t.theory_md),
  checks_json = pg_temp.fix_39(t.checks_json::text)::jsonb,
  scenario_json = pg_temp.fix_39(t.scenario_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'c3b9db9b-7997-493e-a7ba-dbbc83513ebf';

-- lesson_translations lesson_id=640258df-a9fc-4bde-a1dc-87ce36d93d50
create or replace function pg_temp.fix_40(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(replace(input, 'El demasiado interesado no existe', 'El pesado no existe'), 'El miedo es ser *el demasiado interesado* — la persona que está un poco demasiado disponible, que siempre sugiere cosas, que lo quiere más.', 'El miedo es quedar como *un pesado* — la persona que está un poco demasiado disponible, que siempre sugiere cosas, que lo quiere más.'), 'Te preocupa ser el demasiado interesado.', 'Te preocupa quedar como un pesado.'), 'lo que lo convierte en el peor de los dos peores casos.', 'lo que lo convierte en el peor de los dos.');
$fn$;
update public.lesson_translations t set
  title = pg_temp.fix_40(t.title),
  theory_md = pg_temp.fix_40(t.theory_md),
  examples_json = pg_temp.fix_40(t.examples_json::text)::jsonb,
  checks_json = pg_temp.fix_40(t.checks_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '640258df-a9fc-4bde-a1dc-87ce36d93d50';

-- lesson_translations lesson_id=3c1e6487-3420-46ad-a9c8-173c89039734
create or replace function pg_temp.fix_41(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Cuatro años y ningún sitio', 'Cuatro años, ningún avance');
$fn$;
update public.lesson_translations t set
  title = pg_temp.fix_41(t.title),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '3c1e6487-3420-46ad-a9c8-173c89039734';

-- lesson_translations lesson_id=331b0d26-d3e7-4d72-8627-3bd4123dad76
create or replace function pg_temp.fix_42(input text) returns text
language sql immutable as $fn$
  select replace(replace(input, 'Cómodo, sin prisa.', 'Cómoda, sin prisa.'), 'Agradable y superficial por defecto, y notablemente aliviado cuando se dice algo real — normalmente devolviendo algo más grande.', 'Agradable y superficial por defecto, y notablemente aliviada cuando se dice algo real — normalmente devolviendo algo más grande.');
$fn$;
update public.lesson_translations t set
  scenario_json = pg_temp.fix_42(t.scenario_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '331b0d26-d3e7-4d72-8627-3bd4123dad76';

-- lesson_translations lesson_id=ace9eb7d-fc4e-46f3-a396-63315c35ccaa
create or replace function pg_temp.fix_43(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Ritmos distintos no son fracasar', 'Ritmos distintos no son fracaso');
$fn$;
update public.lesson_translations t set
  title = pg_temp.fix_43(t.title),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'ace9eb7d-fc4e-46f3-a396-63315c35ccaa';

-- lesson_translations lesson_id=d756278b-a458-4a99-aa9a-6b21339ed52d
create or replace function pg_temp.fix_44(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Y sé honesto sobre la escala.', 'Y sé honesto sobre el tamaño del asunto.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_44(t.theory_md),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'd756278b-a458-4a99-aa9a-6b21339ed52d';

-- lesson_translations lesson_id=15813e1a-a7b5-46cb-a522-93475de18321
create or replace function pg_temp.fix_45(input text) returns text
language sql immutable as $fn$
  select replace(input, 'El otro fallo habitual es la emboscada, y como la convocatoria-pavor, normalmente la comete alguien que intenta hacerlo más fácil', 'El otro fallo habitual es la emboscada, y al igual que las cuatro horas de pavor, normalmente la comete alguien que intenta hacerlo más fácil');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_45(t.theory_md),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '15813e1a-a7b5-46cb-a522-93475de18321';

-- lesson_translations lesson_id=f076a5d3-e62b-4609-ae1e-bd04861bacf6
create or replace function pg_temp.fix_46(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(replace(replace(replace(replace(input, 'todo lo que viene después es la conversación en vez de una pista de despegue hacia ella.', 'todo lo que viene después es la conversación en vez de un rodeo hasta llegar a ella.'), 'Si te quedas con una cosa: nada de pista de despegue. Dilo pronto, y luego tómate el tiempo que quieras.', 'Si te quedas con una cosa: nada de rodeos. Dilo pronto, y luego tómate el tiempo que quieras.'), '(eso es una pista de despegue, y saben que viene algo)', '(eso es un rodeo, y saben que viene algo)'), 'Nada de pista de despegue. Treinta segundos, y luego tómate el tiempo que quieras.', 'Nada de rodeos. Treinta segundos, y luego tómate el tiempo que quieras.'), 'Nada de pista de despegue de cháchara amable.', 'Nada de rodeos de cháchara amable.'), 'El tema en la primera frase y el propósito en la segunda. Nada de pista de despegue, y nada que tengan que adivinar.', 'El tema en la primera frase y el propósito en la segunda. Nada de rodeos, y nada que tengan que adivinar.'), 'Nada de pista de despegue ni de rodeos', 'Nada de rodeos');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_46(t.theory_md),
  examples_json = pg_temp.fix_46(t.examples_json::text)::jsonb,
  checks_json = pg_temp.fix_46(t.checks_json::text)::jsonb,
  rubric_json = pg_temp.fix_46(t.rubric_json::text)::jsonb,
  rehearsal_spec = pg_temp.fix_46(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'f076a5d3-e62b-4609-ae1e-bd04861bacf6';

-- lesson_translations lesson_id=16e3b761-4eb9-455e-857e-026434410e62
create or replace function pg_temp.fix_47(input text) returns text
language sql immutable as $fn$
  select replace(input, 'e intentarlo es el problema de la pista de despegue del bloque anterior.', 'e intentarlo es el problema de los rodeos del bloque anterior.');
$fn$;
update public.lesson_translations t set
  checks_json = pg_temp.fix_47(t.checks_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '16e3b761-4eb9-455e-857e-026434410e62';

-- lesson_translations lesson_id=bcecd4ed-76ba-44bd-a1a1-a23239744bea
create or replace function pg_temp.fix_48(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(input, 'Nada de sándwich de disculpa', 'Nada de sándwich de cumplidos'), 'Medio sándwich sigue siendo una pista de despegue, y la calidez se sigue releyendo como técnica en cuanto llega el giro.', 'Medio sándwich sigue siendo un rodeo, y la calidez se sigue releyendo como técnica en cuanto llega el giro.'), 'La tranquilidad que está haciendo un trabajo se oye como tranquilidad que está haciendo un trabajo. La calidez funciona cuando ha dejado de desplegarse.', 'La tranquilidad que cumple una función se oye como tranquilidad que cumple una función. La calidez funciona cuando ha dejado de desplegarse.');
$fn$;
update public.lesson_translations t set
  title = pg_temp.fix_48(t.title),
  rehearsal_spec = pg_temp.fix_48(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'bcecd4ed-76ba-44bd-a1a1-a23239744bea';

-- lesson_translations lesson_id=1d9f8bce-8e68-4557-b84b-ea2a639e2281
create or replace function pg_temp.fix_49(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(replace(input, 'Preguntado para litigar — *¿cuándo? dame un caso* — es un desafío', 'Preguntado para interrogar — *¿cuándo? dame un caso* — es un desafío'), 'Merece la pena conocer las señales de la versión litigante porque se escapan con facilidad', 'Merece la pena conocer las señales de la versión fiscal porque se escapan con facilidad'), 'son todo litigar en vez de entender.', 'son todo interrogar en vez de entender.'), '¿Cuál es la señal de que estás litigando?', '¿Cuál es la señal de que estás interrogando?');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_49(t.theory_md),
  examples_json = pg_temp.fix_49(t.examples_json::text)::jsonb,
  checks_json = pg_temp.fix_49(t.checks_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '1d9f8bce-8e68-4557-b84b-ea2a639e2281';

-- lesson_translations lesson_id=e167b332-2b5a-42b6-8871-b9a7c86eac06
create or replace function pg_temp.fix_50(input text) returns text
language sql immutable as $fn$
  select replace(replace(input, 'Un remate.', 'Un aterrizaje.'), 'Un final necesita algo que terminar. Sin incertidumbre en el medio no hay nada que un remate pueda resolver.', 'Un final necesita algo que terminar. Sin incertidumbre en el medio no hay nada que un aterrizaje pueda resolver.');
$fn$;
update public.lesson_translations t set
  rehearsal_spec = pg_temp.fix_50(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'e167b332-2b5a-42b6-8871-b9a7c86eac06';

-- lesson_translations lesson_id=495b9d20-12c9-4bf1-991e-deb2148662d6
create or replace function pg_temp.fix_51(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(input, 'corta el descargo por completo y empieza la historia.', 'corta la coletilla por completo y empieza la historia.'), 'Lo que hace un descargo es decirle a la gente cómo escuchar.', 'Lo que hace una coletilla es decirle a la gente cómo escuchar.'), 'También produce el resultado concreto que intentaba evitar. El descargo existe para protegerte del final plano', 'También produce el resultado concreto que intentaba evitar. La coletilla existe para protegerte del final plano'), 'El descargo existe para protegerte del final plano y es lo que lo causa.', 'La coletilla existe para protegerte del final plano y es lo que lo causa.'), '¿Qué hace de verdad un descargo?', '¿Qué hace de verdad una coletilla?'), '¿Qué son las tres cosas por debajo del descargo?', '¿Qué son las tres cosas por debajo de la coletilla?'), 'Sin descargo', 'Sin coletilla'), 'Escucha a medias y responde con suavidad a cualquier cosa precedida por un descargo.', 'Escucha a medias y responde con suavidad a cualquier cosa precedida por una coletilla.'), 'La persona empieza la historia sin ningún descargo.', 'La persona empieza la historia sin ninguna coletilla.'), 'Hoy, cuenta una historia sin ningún descargo delante. Apunta el descargo que no dijiste.', 'Hoy, cuenta una historia sin ninguna coletilla delante. Apunta la coletilla que no dijiste.'), 'Sin descargo, sin permiso pedido, y a la mesa se le ha dicho cómo escuchar por el contenido en vez de por un aviso.', 'Sin coletilla, sin permiso pedido, y a la mesa se le ha dicho cómo escuchar por el contenido en vez de por un aviso.'), '"Nada de descargo, de disculpa, de permiso"', '"Nada de coletilla, de disculpa, de permiso"');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_51(t.theory_md),
  examples_json = pg_temp.fix_51(t.examples_json::text)::jsonb,
  checks_json = pg_temp.fix_51(t.checks_json::text)::jsonb,
  rubric_json = pg_temp.fix_51(t.rubric_json::text)::jsonb,
  scenario_json = pg_temp.fix_51(t.scenario_json::text)::jsonb,
  mission_text = pg_temp.fix_51(t.mission_text),
  rehearsal_spec = pg_temp.fix_51(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '495b9d20-12c9-4bf1-991e-deb2148662d6';

-- lesson_translations lesson_id=6be900ce-3136-4579-a530-70faed694ee2
create or replace function pg_temp.fix_52(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(input, 'todo lo que piensas decir o lo está preparando o lo está pagando, y corta lo que no haga ninguna de las dos cosas.', 'todo lo que piensas decir o lo está preparando o lo está cobrando, y corta lo que no haga ninguna de las dos cosas.'), 'comprueba que cada frase o lo está preparando o lo está pagando.', 'comprueba que cada frase o lo está preparando o lo está cobrando.'), 'Ese es el giro. Luego corta cualquier cosa que no lo esté preparando ni pagando, que elimina la mayor parte de lo que hace largas las historias.', 'Ese es el giro. Luego corta cualquier cosa que no lo esté preparando ni cobrando, que elimina la mayor parte de lo que hace largas las historias.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_52(t.theory_md),
  examples_json = pg_temp.fix_52(t.examples_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '6be900ce-3136-4579-a530-70faed694ee2';

-- lesson_translations lesson_id=267a88ef-4a6d-45fe-abf9-9c5a2a858c3e
create or replace function pg_temp.fix_53(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Elegir no contarla ahí no es un fracaso, es casting.', 'Elegir no contarla ahí no es un fracaso, es elegir bien a quién se la cuentas.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_53(t.theory_md),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '267a88ef-4a6d-45fe-abf9-9c5a2a858c3e';

-- lesson_translations lesson_id=621476d9-7a6c-46b1-8beb-68526cc1991c
create or replace function pg_temp.fix_54(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(input, 'La cosa que da la vuelta — y la comprobación de que cada frase o lo prepara o lo paga.', 'La cosa que da la vuelta — y la comprobación de que cada frase o lo prepara o lo cobra.'), 'Dos de las cuatro decisiones visibles en un aliento, y nada de planteamiento, de descargo o de día de la semana.', 'Dos de las cuatro decisiones visibles en un aliento, y nada de planteamiento, de coletilla o de día de la semana.'), '"Nada de descargo, planteamiento, u orientación"', '"Nada de coletilla, planteamiento, u orientación"');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_54(t.theory_md),
  rehearsal_spec = pg_temp.fix_54(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '621476d9-7a6c-46b1-8beb-68526cc1991c';

-- lesson_translations lesson_id=22e1f05b-9812-4efa-a722-f68a43633c5c
create or replace function pg_temp.fix_55(input text) returns text
language sql immutable as $fn$
  select replace(replace(input, 'Un detalle que haga trabajo', 'Un detalle que se gane su sitio'), 'elige el único detalle que haga trabajo, y corta el resto de la descripción.', 'elige el único detalle que se gane su sitio, y corta el resto de la descripción.');
$fn$;
update public.lesson_translations t set
  title = pg_temp.fix_55(t.title),
  theory_md = pg_temp.fix_55(t.theory_md),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '22e1f05b-9812-4efa-a722-f68a43633c5c';

-- lesson_translations lesson_id=ae4b70fb-bad3-4713-a24d-6044c53535e8
create or replace function pg_temp.fix_56(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Establece un estándar que la línea luego tiene que superar, y es un descargo con abrigo de confianza.', 'Establece un estándar que la línea luego tiene que superar, y es una coletilla con abrigo de confianza.');
$fn$;
update public.lesson_translations t set
  rehearsal_spec = pg_temp.fix_56(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'ae4b70fb-bad3-4713-a24d-6044c53535e8';

-- lesson_translations lesson_id=065b05f3-3727-4bf2-826f-15cf96678be1
create or replace function pg_temp.fix_57(input text) returns text
language sql immutable as $fn$
  select replace(input, 'todo el mundo en ella puede sentir la planitud sin poder nombrarla', 'todo el mundo en ella puede notar que se ha quedado así sin poder explicarlo');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_57(t.theory_md),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '065b05f3-3727-4bf2-826f-15cf96678be1';

-- lesson_translations lesson_id=135f4f0d-4dd1-48f7-90bd-ba579d63c92f
create or replace function pg_temp.fix_58(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Una causa de la planitud, no lo que hace que se quede.', 'Una causa de que la historia se quede plana, no lo que hace que perdure.');
$fn$;
update public.lesson_translations t set
  checks_json = pg_temp.fix_58(t.checks_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '135f4f0d-4dd1-48f7-90bd-ba579d63c92f';

-- lesson_translations lesson_id=119344e6-05d1-460a-903a-734f2e736d06
create or replace function pg_temp.fix_59(input text) returns text
language sql immutable as $fn$
  select replace(input, 'La misma frase antes es una pista de despegue.', 'La misma frase antes es un rodeo antes de llegar al grano.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_59(t.theory_md),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '119344e6-05d1-460a-903a-734f2e736d06';

-- lesson_translations lesson_id=253ae9b1-9266-4685-b4f7-000b1bd96d72
create or replace function pg_temp.fix_60(input text) returns text
language sql immutable as $fn$
  select replace(replace(input, 'Recupero este — ¿todavía necesitas que se incluyan las cifras de marzo?', 'Vuelvo a esto — ¿todavía necesitas que se incluyan las cifras de marzo?'), 'Recupero este — ¿el informe necesita las cifras de marzo?', 'Vuelvo a esto — ¿el informe necesita las cifras de marzo?');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_60(t.theory_md),
  rehearsal_spec = pg_temp.fix_60(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '253ae9b1-9266-4685-b4f7-000b1bd96d72';

-- lesson_translations lesson_id=17468b43-23c5-45e1-b709-0123dea4c4ad
create or replace function pg_temp.fix_61(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Quitó los que no hacían trabajo literal.', 'Quitó los que de verdad no servían para nada.');
$fn$;
update public.lesson_translations t set
  rubric_json = pg_temp.fix_61(t.rubric_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '17468b43-23c5-45e1-b709-0123dea4c4ad';

-- lesson_translations lesson_id=dece45a7-de10-412f-ad46-2b91345ab006
create or replace function pg_temp.fix_62(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(input, 'porque la comparación es en lo peor que es el texto.', 'porque comparar es lo que peor se le da al texto.'), '(llama — la comparación es en lo peor que es el texto)', '(llama — comparar es lo que peor se le da al texto)'), 'La comparación es en lo peor que es el texto, y redactar con cuidado es una señal de que el contenido es más delicado de lo que soporta el canal.', 'Comparar es lo que peor se le da al texto, y redactar con cuidado es una señal de que el contenido es más delicado de lo que soporta el canal.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_62(t.theory_md),
  examples_json = pg_temp.fix_62(t.examples_json::text)::jsonb,
  checks_json = pg_temp.fix_62(t.checks_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'dece45a7-de10-412f-ad46-2b91345ab006';

-- lesson_translations lesson_id=9c82eefe-bf60-4045-8294-37a5760967b2
create or replace function pg_temp.fix_63(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(replace(replace(replace(replace(input, 'El error más común, con diferencia, es describir el problema en vez de suministrarlo.', 'El error más común, con diferencia, es describir el problema en vez de pegarlo.'), 'pegar una línea de una conversación te consigue consejo sobre una línea.', 'si pegas una línea de una conversación, consigues consejo sobre una línea.'), 'Tu lectura del tono es precisamente lo que está en cuestión, así que suministrarlo como hecho elimina la pregunta.', 'Tu lectura del tono es precisamente lo que está en cuestión, así que presentarlo como hecho elimina la pregunta.'), 'Eso te consigue consejo general, que podrías haber tenido sin preguntar.', 'Así consigues consejo general, que podrías haber tenido sin preguntar.'), 'Suministró el material', 'Pegó el material real'), 'La persona suministra el material real en vez de una descripción de él.', 'La persona pega el material real en vez de una descripción de él.'), 'Di que vas a suministrar el material', 'Di que vas a pegar el material');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_63(t.theory_md),
  checks_json = pg_temp.fix_63(t.checks_json::text)::jsonb,
  rubric_json = pg_temp.fix_63(t.rubric_json::text)::jsonb,
  scenario_json = pg_temp.fix_63(t.scenario_json::text)::jsonb,
  rehearsal_spec = pg_temp.fix_63(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '9c82eefe-bf60-4045-8294-37a5760967b2';

-- lesson_translations lesson_id=67f0ef0f-1a98-4870-9f4a-8e08b55cb75e
create or replace function pg_temp.fix_64(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Corrige una cosa a la vez; una lista de seis cambios te consigue una reescritura en vez de una edición.', 'Corrige una cosa a la vez; con una lista de seis cambios consigues una reescritura en vez de una edición.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_64(t.theory_md),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '67f0ef0f-1a98-4870-9f4a-8e08b55cb75e';

-- lesson_translations lesson_id=ac00f026-9897-4ed4-bef3-21b0f28d90ae
create or replace function pg_temp.fix_65(input text) returns text
language sql immutable as $fn$
  select replace(input, 'Ese párrafo es mobiliario.', 'Ese párrafo es relleno.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_65(t.theory_md),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'ac00f026-9897-4ed4-bef3-21b0f28d90ae';

-- lesson_translations lesson_id=f9922557-c5ce-4460-a851-6117762da011
create or replace function pg_temp.fix_66(input text) returns text
language sql immutable as $fn$
  select replace(replace(replace(input, 'La insatisfacción vaga te consigue una reformulación; un fallo localizado te consigue una explicación distinta.', 'Con una insatisfacción vaga solo consigues una reformulación; con un fallo localizado, consigues una explicación distinta.'), 'Un fallo localizado consigue una explicación distinta. La insatisfacción vaga consigue la misma reformulada.', 'Con un fallo localizado consigues una explicación distinta. Con una insatisfacción vaga, consigues la misma reformulada.'), 'Un fallo localizado consigue una explicación distinta en vez de una más alta.', 'Con un fallo localizado consigues una explicación distinta en vez de una más alta.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_66(t.theory_md),
  examples_json = pg_temp.fix_66(t.examples_json::text)::jsonb,
  rehearsal_spec = pg_temp.fix_66(t.rehearsal_spec::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'f9922557-c5ce-4460-a851-6117762da011';

-- lesson_translations lesson_id=0b4a9d2d-89d7-4e4e-9171-3b6e4f796124
create or replace function pg_temp.fix_67(input text) returns text
language sql immutable as $fn$
  select replace(replace(input, 'Este es el modo de fallo de todo este bloque.', 'Este es el error típico de todo este bloque.'), '¿es correcto que solo aplica por encima de cierta cantidad?', '¿es correcto que solo entra en vigor por encima de cierta cantidad?');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_67(t.theory_md),
  examples_json = pg_temp.fix_67(t.examples_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '0b4a9d2d-89d7-4e4e-9171-3b6e4f796124';

-- lesson_translations lesson_id=1bc695b8-29f5-43d1-965a-44b2358697fe
create or replace function pg_temp.fix_68(input text) returns text
language sql immutable as $fn$
  select replace(replace(input, 'vuelve a poner las dos que hacían trabajo real, porque un pequeño número de ellas son genuinas.', 'vuelve a poner las dos que de verdad servían para algo, porque un pequeño número de ellas son genuinas.'), 'Quita cada muletilla, y luego vuelvo a poner las que hacen trabajo.', 'Quita cada muletilla, y luego vuelvo a poner las que de verdad sirven para algo.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_68(t.theory_md),
  examples_json = pg_temp.fix_68(t.examples_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = '1bc695b8-29f5-43d1-965a-44b2358697fe';

-- lesson_translations lesson_id=fd11ddbb-ebb4-4f0c-b159-8faa3914eda5
create or replace function pg_temp.fix_69(input text) returns text
language sql immutable as $fn$
  select replace(input, 'es lo mismo que pide Storytelling: un detalle que hace trabajo.', 'es lo mismo que pide Storytelling: un detalle que cumple una función.');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_69(t.theory_md),
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'fd11ddbb-ebb4-4f0c-b159-8faa3914eda5';

-- lesson_translations lesson_id=fa9c5cc0-e6f2-4712-a5c2-71e295d687e5
create or replace function pg_temp.fix_70(input text) returns text
language sql immutable as $fn$
  select replace(replace(input, 'Hay un modo de fallo que esta app debería nombrar porque es el que más probablemente atrape a sus propios lectores', 'Hay un error típico que esta app debería nombrar porque es el que más probablemente atrape a sus propios lectores'), '¿Cuál es el modo de fallo que nombra esta lección?', '¿Cuál es la trampa habitual que nombra esta lección?');
$fn$;
update public.lesson_translations t set
  theory_md = pg_temp.fix_70(t.theory_md),
  checks_json = pg_temp.fix_70(t.checks_json::text)::jsonb,
  updated_at = now()
where t.locale = 'es' and t.lesson_id = 'fa9c5cc0-e6f2-4712-a5c2-71e295d687e5';

