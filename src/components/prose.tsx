import { Fragment } from "react";

/**
 * Renders the small subset of markdown the theory cards actually use:
 * blank-line paragraphs and **bold**. Built out of React elements rather than
 * injected HTML, so it stays safe by construction.
 */
export function Prose({ markdown }: { markdown: string }) {
  const paragraphs = markdown.trim().split(/\n{2,}/);

  return (
    <div className="flex flex-col gap-4">
      {paragraphs.map((paragraph, i) => (
        <p key={i} className="text-[15px] leading-[1.65] text-ink">
          {renderBold(paragraph.replace(/\n/g, " "))}
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
