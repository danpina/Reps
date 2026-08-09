/**
 * Splitting authored prose into paragraphs.
 *
 * Its own module rather than a closure inside the Prose component, because the
 * bug it exists to prevent is invisible: content pasted with Windows line
 * endings arrives as "\r\n\r\n", a paragraph split written as /\n{2,}/ never
 * matches it, and every theory card in the app silently becomes one
 * five-hundred-word block. Nothing throws, nothing logs, and it reads as bad
 * writing rather than as a bug.
 *
 * So line endings are normalised before anything is split, and the rule is
 * asserted in the test suite — which needs it to be plain TypeScript rather
 * than a component the test runner cannot parse.
 */

/**
 * Paragraphs, in the small subset of markdown the curriculum actually uses:
 * blank lines separate paragraphs, and a single newline inside one is a wrap
 * rather than a break.
 */
export function toParagraphs(markdown: string): string[] {
  return markdown
    .replace(/\r\n?/g, "\n")
    .trim()
    .split(/\n{2,}/)
    .map((paragraph) => paragraph.replace(/\n/g, " ").trim())
    .filter(Boolean);
}

export type Emphasis = "none" | "bold" | "italic";
export type Token = { text: string; emphasis: Emphasis };

/**
 * A paragraph split into runs of plain, bold and italic text.
 *
 * Both markers are used throughout the curriculum — bold for "**The move:**"
 * and italics for quoting a line somebody might say — and only bold was ever
 * rendered. Twenty-five lessons were printing their own asterisks, which is
 * the same class of silent failure as the paragraph splitting: nothing throws,
 * and it reads as sloppy writing rather than as a bug.
 *
 * Bold is matched first, so the two stars of "**x**" are never mistaken for an
 * italic run containing a star.
 */
export function toTokens(paragraph: string): Token[] {
  return paragraph
    .split(/(\*\*[^*]+\*\*|\*[^*\n]+\*)/g)
    .filter(Boolean)
    .map((part) => {
      const bold = /^\*\*([^*]+)\*\*$/.exec(part);
      if (bold) return { text: bold[1], emphasis: "bold" as const };

      const italic = /^\*([^*\n]+)\*$/.exec(part);
      if (italic) return { text: italic[1], emphasis: "italic" as const };

      return { text: part, emphasis: "none" as const };
    });
}
