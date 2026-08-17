/**
 * The marker each language states its technique with.
 *
 * A translated card cannot keep "**The move:**" in English, and this function
 * is the only thing that reads it — so the marker is per language and the
 * extraction is not. Getting this wrong is silent: the regex simply misses,
 * the rehearsal falls back to the lesson title, and nothing throws.
 *
 * Any locale added later needs a line here, and the test that walks every
 * authored card will fail until it has one.
 */
export const MOVE_MARKERS = [
  "The move:",
  "La jugada:",
  "Der Zug:",
] as const;

const MOVE_PATTERN = new RegExp(
  `\\*\\*(?:${MOVE_MARKERS.join("|")})\\*\\*\\s*([^\\n]+)`,
);

/**
 * Pulls the one-line instruction out of a theory card.
 *
 * Every lesson states its technique as "**The move:** …", or the equivalent
 * marker in the language it was written in. The rehearsal shows it so you know
 * which skill the scene is drilling instead of entering cold.
 *
 * Falls back to the lesson title rather than throwing, because a lesson
 * written later without the marker should degrade to something usable rather
 * than break the rehearsal.
 */
export function extractTheMove(theoryMd: string, fallback: string): string {
  const match = MOVE_PATTERN.exec(theoryMd);
  if (!match) return fallback;

  const line = match[1].trim().replace(/\*\*/g, "");
  if (!line) return fallback;

  // Capitalised, since it reads as a sentence on its own away from the card.
  return line.charAt(0).toUpperCase() + line.slice(1);
}
