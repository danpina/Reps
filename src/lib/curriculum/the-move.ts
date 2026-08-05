/**
 * Pulls the one-line instruction out of a theory card.
 *
 * Every lesson states its technique as "**The move:** …". The rehearsal shows
 * it so you know which skill the scene is drilling instead of entering cold.
 *
 * Falls back to the lesson title rather than throwing, because a lesson
 * written later without the marker should degrade to something usable rather
 * than break the rehearsal.
 */
export function extractTheMove(theoryMd: string, fallback: string): string {
  const match = /\*\*The move:\*\*\s*([^\n]+)/.exec(theoryMd);
  if (!match) return fallback;

  const line = match[1].trim().replace(/\*\*/g, "");
  if (!line) return fallback;

  // Capitalised, since it reads as a sentence on its own away from the card.
  return line.charAt(0).toUpperCase() + line.slice(1);
}
