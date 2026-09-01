/**
 * Reasons this is worth practising.
 *
 * Shown on the sign-in page and the dashboard. Kept in code rather than in the
 * database on purpose: the sign-in page is unauthenticated, and every table in
 * this app requires a session, so a fact from the database would need a
 * publicly readable table for no benefit.
 *
 * Written to the same rule as the curriculum — plain, concrete, no invented
 * statistics. Where a claim leans on research (social connection and health,
 * how much people underestimate talking to strangers) it is stated
 * qualitatively, because a precise number nobody can check is worse than an
 * honest sentence.
 *
 * Translated by hand rather than through next-intl's message catalogs, since
 * these are prose-quality sentences that read the same as curriculum content,
 * not app chrome — the Spanish array below follows the same faithful, tú-form
 * conventions as the lesson translations. `factForLocale` takes the reader's
 * locale as a plain argument rather than resolving it itself, so this file
 * stays free of `@/`-aliased runtime imports and the existing tests (which
 * `node --test` resolves by relative path only) keep working untouched.
 */

import type { Locale } from "@/lib/curriculum/locale";

export type Fact = { text: string; area: FactArea };

export type FactArea =
  | "work"
  | "friendship"
  | "dating"
  | "health"
  | "luck"
  | "confidence";

export const FACTS: Fact[] = [
  // Work
  { area: "work", text: "Most jobs are filled before they are advertised. The people who hear first are the ones who talk to everyone, not the ones with the best CV." },
  { area: "work", text: "Being easy to talk to is routinely mistaken for being good at your job. That is not fair, and it is still worth knowing." },
  { area: "work", text: "The colleague who chats for two minutes before a meeting starts is the one people bring problems to first." },
  { area: "work", text: "Promotions get decided in rooms you are not in, by people describing you in one sentence. Small talk is how they get a sentence." },
  { area: "work", text: "Clients rarely leave because the work was bad. They leave because nobody spoke to them." },
  { area: "work", text: "Five minutes with someone from another team beats an hour reading their documentation." },
  { area: "work", text: "Negotiations go better between people who have talked about something other than the negotiation." },
  { area: "work", text: "Most useful introductions come from people you know only slightly. Small talk is how you come to know someone slightly." },
  { area: "work", text: "The quiet person who never speaks in the kitchen is not remembered as mysterious. They are simply not remembered." },

  // Friendship
  { area: "friendship", text: "Adult friendships almost never start with a deep conversation. They start with a trivial one that happened twice." },
  { area: "friendship", text: "Most people you would get on with are within speaking distance several times a week. The gap is not opportunity, it is the opening line." },
  { area: "friendship", text: "Loneliness is usually not a shortage of people. It is a shortage of unremarkable conversations." },
  { area: "friendship", text: "Friendships form through repeated low-stakes contact, not through intensity." },
  { area: "friendship", text: "The person you have sat near for a year without speaking to could have been a friend for a year." },
  { area: "friendship", text: "Nobody remembers what you said in a first conversation. They remember whether it felt easy." },
  { area: "friendship", text: "You do not need to be interesting. You need to be interested, and then say one thing back about yourself." },
  { area: "friendship", text: "Moving somewhere new is not what makes people lonely. Not talking to anyone there is." },

  // Dating
  { area: "dating", text: "Attraction is built far more often through repeated easy conversation than through one impressive performance." },
  { area: "dating", text: "Most people are relieved when someone else starts the conversation. You are doing them a favour." },
  { area: "dating", text: "Reading disinterest accurately is what makes flirting safe to practise, for them and for you." },
  { area: "dating", text: "Being able to end a conversation warmly makes starting one much less frightening." },
  { area: "dating", text: "Confidence in dating is mostly the accumulated memory of conversations that did not go badly." },
  { area: "dating", text: "The people who seem effortless at this are not braver than you. They have had more goes." },

  // Health
  { area: "health", text: "Social connection predicts how long people live about as strongly as anything else within their control." },
  { area: "health", text: "Brief friendly exchanges with strangers reliably lift mood, including for people who were sure they would hate it." },
  { area: "health", text: "People consistently underestimate how much they will enjoy talking to a stranger, and how much the stranger will enjoy it too." },
  { area: "health", text: "Isolation and low mood feed each other. A two-minute conversation interrupts the loop." },
  { area: "health", text: "A day with three small conversations in it feels materially different from a day with none." },

  // Luck and opportunity
  { area: "luck", text: "Lucky people are usually just people who talk to more people." },
  { area: "luck", text: "Opportunities travel through conversation long before they travel through email." },
  { area: "luck", text: "You cannot tell in advance which conversation will matter. That is the whole argument for having more of them." },
  { area: "luck", text: "Almost everything good that happens to most people arrives through another person." },
  { area: "luck", text: "The conversation you did not start is the only one guaranteed to lead nowhere." },

  // Confidence
  { area: "confidence", text: "The fear of small talk is mostly the fear of a silence you do not know how to end. That is a skill, not a personality." },
  { area: "confidence", text: "Awkwardness fades with volume. There is no other reliable route through it." },
  { area: "confidence", text: "Most people are not judging your opener. They are relieved they did not have to think of one." },
  { area: "confidence", text: "Being bad at this is not a fixed trait. It is an untrained one." },
  { area: "confidence", text: "You have several hundred low-stakes openings a week and use almost none of them." },
  { area: "confidence", text: "Nobody is born good at this. The ones who look natural have simply had more repetitions." },
];

/** Same facts, same order, in Spanish. */
export const FACTS_ES: Fact[] = [
  // Work
  { area: "work", text: "La mayoría de los puestos se cubren antes de anunciarse. Los primeros en enterarse son los que hablan con todo el mundo, no los del mejor currículum." },
  { area: "work", text: "Que se te dé bien hablar se confunde a menudo con que se te dé bien tu trabajo. No es justo, y aun así conviene saberlo." },
  { area: "work", text: "El compañero que charla dos minutos antes de que empiece una reunión es al que la gente le cuenta los problemas primero." },
  { area: "work", text: "Los ascensos se deciden en salas donde tú no estás, por gente que te describe en una frase. La charla informal es cómo consiguen esa frase." },
  { area: "work", text: "Los clientes rara vez se van porque el trabajo fuera malo. Se van porque nadie les habló." },
  { area: "work", text: "Cinco minutos con alguien de otro equipo valen más que una hora leyendo su documentación." },
  { area: "work", text: "Las negociaciones van mejor entre personas que han hablado de algo distinto a la negociación." },
  { area: "work", text: "Las presentaciones más útiles vienen de gente que conoces solo un poco. La charla informal es cómo llegas a conocer a alguien un poco." },
  { area: "work", text: "A la persona callada que nunca habla en la cocina no la recuerdan como misteriosa. Sencillamente no la recuerdan." },

  // Friendship
  { area: "friendship", text: "Las amistades adultas casi nunca empiezan con una conversación profunda. Empiezan con una trivial que pasó dos veces." },
  { area: "friendship", text: "La mayoría de la gente con la que congeniarías está a tu alcance varias veces por semana. La brecha no es la oportunidad, es la frase para empezar." },
  { area: "friendship", text: "La soledad no suele ser falta de gente. Es falta de conversaciones sin importancia." },
  { area: "friendship", text: "Las amistades se forman por contacto repetido y de bajo riesgo, no por intensidad." },
  { area: "friendship", text: "La persona junto a la que te has sentado un año sin hablarle podría haber sido tu amiga durante un año." },
  { area: "friendship", text: "Nadie recuerda lo que dijiste en una primera conversación. Recuerdan si resultó fácil." },
  { area: "friendship", text: "No necesitas ser interesante. Necesitas estar interesado, y luego decir algo de ti a cambio." },
  { area: "friendship", text: "Mudarte a un sitio nuevo no es lo que hace que la gente se sienta sola. No hablar con nadie allí, sí." },

  // Dating
  { area: "dating", text: "La atracción se construye mucho más a menudo con conversación fácil y repetida que con una actuación impresionante." },
  { area: "dating", text: "A la mayoría de la gente le alivia que sea otro quien empiece la conversación. Les estás haciendo un favor." },
  { area: "dating", text: "Leer el desinterés con precisión es lo que hace que coquetear sea seguro de practicar, para ellos y para ti." },
  { area: "dating", text: "Saber terminar una conversación con calidez hace que empezar una dé mucho menos miedo." },
  { area: "dating", text: "La confianza al ligar es sobre todo el recuerdo acumulado de conversaciones que no salieron mal." },
  { area: "dating", text: "Quienes parecen tener esto sin esfuerzo no son más valientes que tú. Han tenido más intentos." },

  // Health
  { area: "health", text: "La conexión social predice cuánto vive la gente casi tan bien como cualquier otra cosa dentro de su control." },
  { area: "health", text: "Los intercambios breves y amistosos con desconocidos mejoran el ánimo de forma fiable, incluso en quien estaba seguro de que le disgustaría." },
  { area: "health", text: "La gente subestima sistemáticamente cuánto va a disfrutar hablando con un desconocido, y cuánto lo va a disfrutar el desconocido también." },
  { area: "health", text: "El aislamiento y el ánimo bajo se alimentan mutuamente. Una conversación de dos minutos interrumpe el ciclo." },
  { area: "health", text: "Un día con tres conversaciones pequeñas se siente materialmente distinto a uno sin ninguna." },

  // Luck and opportunity
  { area: "luck", text: "La gente con suerte suele ser, sencillamente, gente que habla con más gente." },
  { area: "luck", text: "Las oportunidades viajan por conversación mucho antes de viajar por correo electrónico." },
  { area: "luck", text: "No puedes saber de antemano qué conversación va a importar. Ese es todo el argumento para tener más." },
  { area: "luck", text: "Casi todo lo bueno que le pasa a la mayoría de la gente llega a través de otra persona." },
  { area: "luck", text: "La conversación que no empezaste es la única que tiene garantizado no llevar a ningún sitio." },

  // Confidence
  { area: "confidence", text: "El miedo a la charla informal es sobre todo el miedo a un silencio que no sabes cómo terminar. Eso es una habilidad, no un rasgo de personalidad." },
  { area: "confidence", text: "La torpeza se desvanece con la práctica. No hay otra ruta fiable para superarla." },
  { area: "confidence", text: "La mayoría de la gente no está juzgando tu frase de apertura. Les alivia no haber tenido que pensar una ellos." },
  { area: "confidence", text: "Que se te dé mal esto no es un rasgo fijo. Es uno sin entrenar." },
  { area: "confidence", text: "Tienes varios cientos de aperturas de bajo riesgo cada semana y no usas casi ninguna." },
  { area: "confidence", text: "Nadie nace con esto. A quienes les parece natural, sencillamente, han tenido más repeticiones." },
];

/**
 * Picks a fact.
 *
 * Called on the server and passed down as a prop, so the browser hydrates with
 * whatever the server chose. Picking inside a client component would produce a
 * hydration mismatch.
 */
export function randomFact(random: () => number = Math.random): Fact {
  return FACTS[Math.floor(random() * FACTS.length)];
}

/**
 * Same as `randomFact`, in the reader's own language.
 *
 * Falls back to English for a locale without a translated set (German is not
 * covered yet) rather than throwing, matching the fallback rule the rest of
 * the app uses for untranslated content.
 */
export function factForLocale(
  locale: Locale,
  random: () => number = Math.random,
): Fact {
  const pool = locale === "es" ? FACTS_ES : FACTS;
  return pool[Math.floor(random() * pool.length)];
}
