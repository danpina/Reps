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
 */

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
