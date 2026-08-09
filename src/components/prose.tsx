import { Fragment } from "react";

import { toParagraphs, toTokens } from "@/lib/markdown";

/**
 * Renders the small subset of markdown the theory cards actually use:
 * blank-line paragraphs, **bold** and *italics*. Built out of React elements
 * rather than injected HTML, so it stays safe by construction.
 *
 * The parsing lives in lib/markdown so it can be tested. It used to be two
 * regexes here, and both had the same silent failure: content the app could
 * not parse rendered as-is rather than erroring, so a card that had lost its
 * paragraph breaks or was printing its own asterisks read as bad writing.
 */
export function Prose({ markdown }: { markdown: string }) {
  return (
    <div className="flex flex-col gap-4">
      {toParagraphs(markdown).map((paragraph, i) => (
        <p key={i} className="text-[15px] leading-[1.65] text-ink">
          {toTokens(paragraph).map((token, j) => {
            if (token.emphasis === "bold") {
              return (
                <strong key={j} className="font-semibold">
                  {token.text}
                </strong>
              );
            }
            if (token.emphasis === "italic") {
              return <em key={j}>{token.text}</em>;
            }
            return <Fragment key={j}>{token.text}</Fragment>;
          })}
        </p>
      ))}
    </div>
  );
}
