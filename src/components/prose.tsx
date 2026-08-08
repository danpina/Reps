import { Fragment } from "react";

import { toParagraphs } from "@/lib/markdown";

/**
 * Renders the small subset of markdown the theory cards actually use:
 * blank-line paragraphs and **bold**. Built out of React elements rather than
 * injected HTML, so it stays safe by construction.
 *
 * The splitting lives in lib/markdown so it can be tested. It used to be a
 * regex here that did not survive Windows line endings, which is how every
 * theory card in the app came to be one unbroken block.
 */
export function Prose({ markdown }: { markdown: string }) {
  return (
    <div className="flex flex-col gap-4">
      {toParagraphs(markdown).map((paragraph, i) => (
        <p key={i} className="text-[15px] leading-[1.65] text-ink">
          {renderBold(paragraph)}
        </p>
      ))}
    </div>
  );
}

function renderBold(text: string) {
  return text.split(/(\*\*[^*]+\*\*)/g).map((part, i) => {
    const match = /^\*\*([^*]+)\*\*$/.exec(part);
    return match ? (
      <strong key={i} className="font-semibold">
        {match[1]}
      </strong>
    ) : (
      <Fragment key={i}>{part}</Fragment>
    );
  });
}
