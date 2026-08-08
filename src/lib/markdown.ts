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
