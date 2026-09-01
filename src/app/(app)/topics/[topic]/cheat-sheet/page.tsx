import { notFound, redirect } from "next/navigation";
import { getTranslations } from "next-intl/server";

import { BackLink } from "@/components/back-link";
import { requireUser } from "@/lib/auth/dal";
import { isPro } from "@/lib/billing/entitlement";
import { layOut } from "@/lib/curriculum/cheat-sheet";
import { getCheatSheet, getTopicBySlug } from "@/lib/curriculum/queries";

import { PrintButton } from "./print-button";

export async function generateMetadata() {
  const t = await getTranslations("cheatSheet");
  return { title: t("pageTitle") };
}

export default async function CheatSheetPage({
  params,
}: {
  params: Promise<{ topic: string }>;
}) {
  await requireUser();
  const { topic: slug } = await params;

  const [topic, sheet, pro] = await Promise.all([
    getTopicBySlug(slug),
    getCheatSheet(slug),
    isPro(),
  ]);
  const t = await getTranslations("cheatSheet");

  if (!topic) notFound();

  // The sheet is the whole topic on one page, which is most of what a
  // subscription buys. A free account has read two lessons of it.
  if (!pro) redirect("/pro");

  if (!sheet) notFound();

  const groups = layOut(sheet, topic.skills);

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <div data-print="hide">
        <BackLink href={`/topics/${topic.slug}`} label={topic.name} />
      </div>

      <header className="mt-3 border-b border-rule pb-5" data-print="keep">
        <p className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
          {t("topicCheatSheet", { name: topic.name })}
        </p>
        <h1 className="mt-2 text-2xl font-semibold tracking-tight text-ink">
          {topic.promise}
        </h1>
        <p className="mt-4 text-[15px] leading-[1.6] text-ink-muted">
          {sheet.idea}
        </p>
      </header>

      {/* Two columns on paper — see [data-print="columns"] in globals.css. A
          cheat sheet that runs to three pages is a document, and the point of
          this one is that it fits in a pocket. */}
      <div data-print="columns" className="mt-8 flex flex-col gap-8">
        {groups.map((group) => (
          <section key={group.heading} data-print="keep">
            <h2 className="border-b border-[var(--rule-strong)] pb-1 text-sm font-semibold text-ink">
              {group.heading}
            </h2>
            <dl className="mt-3 flex flex-col gap-3">
              {group.concepts.map((concept) => (
                <div key={concept.name} data-print="keep">
                  <dt className="text-[14px] font-medium text-ink">
                    {concept.name}
                  </dt>
                  <dd className="mt-0.5 text-[13px] leading-[1.5] text-ink-muted">
                    {concept.body}
                  </dd>
                </div>
              ))}
            </dl>
          </section>
        ))}
      </div>

      <footer className="mt-10 flex flex-wrap items-center gap-4 border-t border-rule pt-6">
        <PrintButton />
        {/* Kept on the printed page as well. Somebody reading this on a train
            is about to walk into a room, and the ratio is the whole argument. */}
        <p className="text-[13px] leading-relaxed text-ink-muted">
          {t("noneOfThisCountsUntilUsed")}
        </p>
      </footer>
    </main>
  );
}
