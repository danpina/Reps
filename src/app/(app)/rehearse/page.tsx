import Link from "next/link";

import { BackLink } from "@/components/back-link";
import { requireUser } from "@/lib/auth/dal";
import { createClient } from "@/lib/supabase/server";
import { averageScore, type Feedback } from "@/lib/roleplay/feedback";
import { MAX_SCENES_PER_DAY } from "@/lib/roleplay/limits";

export const metadata = { title: "Rehearsals — Reps" };

type Row = {
  id: string;
  status: string;
  started_at: string;
  transcript_json: { role: string }[];
  feedback_json: Feedback | null;
  scores_json: Record<string, number> | null;
  lessons: { title: string; sort_order: number; skills: { slug: string; name: string } };
};

export default async function RehearsalsPage({
  searchParams,
}: {
  searchParams: Promise<{ limit?: string }>;
}) {
  await requireUser();
  const supabase = await createClient();
  const atLimit = (await searchParams).limit === "1";

  const { data } = await supabase
    .from("roleplays")
    .select(
      "id, status, started_at, transcript_json, feedback_json, scores_json, lessons(title, sort_order, skills(slug, name))",
    )
    .order("started_at", { ascending: false });

  const rows = (data ?? []) as unknown as Row[];

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink href="/today" label="Today" />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          Rehearsals
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-ink-muted">
          Practice scenes and what they were scored on. Useful, and worth less
          than one real conversation.
        </p>
      </header>

      {/* Reached by redirect from the start action, so the message has to
          explain a thing that just happened rather than warn about one. */}
      {atLimit ? (
        <p
          role="status"
          className="mt-6 rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm leading-relaxed text-ink"
        >
          That is {MAX_SCENES_PER_DAY} scenes today, which is the daily cap.
          Unfinished ones above are still open. The real reps do not have a
          limit — go and have one.
        </p>
      ) : null}

      {rows.length === 0 ? (
        <div className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6">
          <h2 className="text-sm font-semibold text-ink">Nothing rehearsed yet</h2>
          <p className="mt-2 text-sm leading-relaxed text-ink-muted">
            Open a lesson and start a scene. The first one in each track is
            available straight away.
          </p>
          <Link
            href="/topics"
            className="mt-4 inline-block rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
          >
            Browse skills
          </Link>
        </div>
      ) : (
        <ol className="mt-2">
          {rows.map((row) => {
            const turns = row.transcript_json.filter((t) => t.role === "user").length;
            const average = row.scores_json ? averageScore(row.scores_json) : null;

            return (
              <li key={row.id} className="border-b border-rule">
                <Link
                  href={`/rehearse/${row.id}`}
                  className="block py-5 transition-colors hover:bg-[var(--paper-raised)]"
                >
                  <div className="flex flex-wrap items-baseline gap-x-3 gap-y-1">
                    <span className="text-sm font-medium text-ink">
                      {row.lessons.skills.name}
                    </span>
                    {row.status === "open" ? (
                      <span className="tabular rounded border border-[var(--flag)] px-1.5 py-0.5 text-[11px] text-[var(--flag)]">
                        Unfinished
                      </span>
                    ) : average !== null ? (
                      <span className="tabular rounded border border-[var(--accent)] px-1.5 py-0.5 text-[11px] text-[var(--accent)]">
                        {average.toFixed(1)} avg
                      </span>
                    ) : null}
                    <span className="tabular ml-auto text-xs text-ink-faint">
                      {new Date(row.started_at).toLocaleDateString(undefined, {
                        day: "numeric",
                        month: "short",
                      })}
                    </span>
                  </div>

                  <p className="mt-1 text-[13px] text-ink-muted">
                    {row.lessons.title}
                  </p>

                  {row.feedback_json ? (
                    <p className="mt-2 text-[13px] leading-relaxed text-ink">
                      {row.feedback_json.fix}
                    </p>
                  ) : (
                    <p className="tabular mt-2 text-xs text-ink-faint">
                      {turns} {turns === 1 ? "line" : "lines"} said
                    </p>
                  )}
                </Link>
              </li>
            );
          })}
        </ol>
      )}
    </main>
  );
}
