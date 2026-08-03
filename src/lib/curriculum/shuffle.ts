/**
 * Fisher-Yates, returning a new array.
 *
 * Comprehension beats shuffle their options per render so the correct answer
 * cannot be found by position. Writing a card tends to produce a predictable
 * layout — a plausible wrong answer first, the right one second — and a reader
 * picks that pattern up long before they learn the material.
 *
 * This runs on the server and the result is passed to the client as props, so
 * the order the browser hydrates with is the order the server rendered. Do not
 * move it into the client component: shuffling during render there would
 * produce a hydration mismatch.
 */
export function shuffle<T>(
  items: readonly T[],
  random: () => number = Math.random,
): T[] {
  const out = [...items];
  for (let i = out.length - 1; i > 0; i--) {
    const j = Math.floor(random() * (i + 1));
    [out[i], out[j]] = [out[j], out[i]];
  }
  return out;
}
