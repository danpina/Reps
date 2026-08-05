import Link from "next/link";
import { notFound } from "next/navigation";

import { BackLink } from "@/components/back-link";
import { extractTheMove } from "@/lib/curriculum/the-move";
import { requireUser } from "@/lib/auth/dal";
import { createClient } from "@/lib/supabase/server";
import type { Rubric, Scenario } from "@/lib/curriculum/types";
import type { Feedback } from "@/lib/roleplay/feedback";
import type { Turn } from "@/lib/roleplay/partner";
import { isUsingRealModel } from "@/lib/roleplay/engine";
import { Chat } from "./chat";
import { EndScene } from "./end-scene";

export const metadata = { title: "Rehearsal — Reps" };

export default async function RehearsePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  await requireUser();
  const { id } = await params;

  const supabase = await createClient();
  const { data } = await supabase
    .from("roleplays")
    .select(
      "id, status, transcript_json, feedback_json, lesson_id, lessons(title, sort_order, theory_md, rehearsal_note, scenario_json, rubric_json, mission_text, skills(slug, name))",
    )
    .eq("id", id)
    .maybeSingle();

  if (!data) notFound();

  const roleplay = data as unknown as {
    id: string;
    status: string;
    transcript_json: Turn[];
    feedback_json: Feedback | null;
    lessons: {
      title: string;
      sort_order: number;
      theory_md: string;
      rehearsal_note: string | null;
      scenario_json: Scenario;
      rubric_json: Rubric;
      mission_text: string;
      skills: { slug: string; name: string };
    };
  };

  const { lessons: lesson } = roleplay;
  const scenario = lesson.scenario_json;
  const theMove = extractTheMove(lesson.theory_md, lesson.title);
  const complete = roleplay.status === "complete";
  const hasSpoken = roleplay.transcript_json.some((t) => t.role === "user");

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink
          href={`/skills/${lesson.skills.slug}/${lesson.sort_order}`}
          label={lesson.title}
        />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          Rehearsal
        </h1>

        <div className="mt-4 rounded border border-rule bg-[var(--paper-raised)] p-4">
          <p className="text-[13px] leading-relaxed text-ink-muted">
            {scenario.setting}
          </p>
          <p className="mt-2 text-sm leading-relaxed text-ink">
            You are talking to <strong>{scenario.partner.name}</strong>,{" "}
            {scenario.partner.role}.
          </p>
          <p className="tabular mt-2 text-xs text-ink-faint">
            Openness {scenario.partner.openness} of 5
            {scenario.partner.openness <= 2
              ? " — they will make you work, and that is the drill"
              : ""}
          </p>
        </div>

        {/* Without this you enter the scene cold, with no idea which skill is
            being drilled or what the review will look at. The rubric is the
            same list the scoring uses, so the target and the marking agree. */}
        <section
          aria-labelledby="target"
          className="mt-3 rounded border border-[var(--accent)] bg-[var(--accent-soft)] p-4"
        >
          <h2
            id="target"
            className="tabular text-xs uppercase tracking-[0.18em] text-[var(--accent)]"
          >
            What you are practising
          </h2>
          <p className="mt-2 text-sm leading-relaxed text-ink">{theMove}</p>
          {lesson.rehearsal_note ? (
            <p className="mt-3 border-t border-[var(--accent)]/30 pt-3 text-[13px] leading-relaxed text-ink-muted">
              {lesson.rehearsal_note}
            </p>
          ) : null}

          <ul className="mt-3 flex flex-col gap-1">
            {lesson.rubric_json.criteria.map((criterion) => (
              <li
                key={criterion.key}
                className="text-[13px] leading-snug text-ink-muted"
              >
                <span className="text-ink">{criterion.label}</span>
                {" — "}
                {criterion.description}
              </li>
            ))}
          </ul>
        </section>

        {!isUsingRealModel() ? (
          <p className="mt-3 text-[12px] leading-relaxed text-ink-faint">
            Practising against a scripted partner. It honours the openness level
            but will not surprise you — the real one arrives with the AI engine.
          </p>
        ) : null}
      </header>

      {complete ? (
        <CompletedScene roleplay={roleplay} />
      ) : (
        <>
          <Chat
            roleplayId={roleplay.id}
            partnerName={scenario.partner.name}
            transcript={roleplay.transcript_json}
          />
          <EndScene roleplayId={roleplay.id} hasSpoken={hasSpoken} />
        </>
      )}
    </main>
  );
}

function CompletedScene({
  roleplay,
}: {
  roleplay: {
    id: string;
    transcript_json: Turn[];
    feedback_json: Feedback | null;
    lessons: {
      mission_text: string;
      rubric_json: Rubric;
      skills: { slug: string; name: string };
    };
  };
}) {
  const feedback = roleplay.feedback_json;
  const { rubric_json: rubric } = roleplay.lessons;

  return (
    <div className="mt-7 flex flex-col gap-9">
      {feedback ? (
        <>
          <section aria-labelledby="scores">
            <h2
              id="scores"
              className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint"
            >
              How it went
            </h2>
            <dl className="mt-4 flex flex-col gap-3">
              {rubric.criteria.map((criterion) => {
                const score = feedback.scores[criterion.key] ?? 0;
                const fraction = score / rubric.scale.max;
                return (
                  <div key={criterion.key}>
                    <div className="flex items-baseline justify-between gap-3">
                      <dt className="text-sm text-ink">{criterion.label}</dt>
                      <dd className="tabular text-xs text-ink-faint">
                        {score} / {rubric.scale.max}
                      </dd>
                    </div>
                    <div
                      className="mt-1.5 h-1 w-full overflow-hidden rounded-full bg-[var(--rule)]"
                      role="progressbar"
                      aria-valuenow={score}
                      aria-valuemin={rubric.scale.min}
                      aria-valuemax={rubric.scale.max}
                      aria-label={criterion.label}
                    >
                      <div
                        className="h-full bg-[var(--accent)]"
                        style={{ width: `${fraction * 100}%` }}
                      />
                    </div>
                  </div>
                );
              })}
            </dl>
          </section>

          <section aria-labelledby="worked">
            <h2
              id="worked"
              className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint"
            >
              What worked
            </h2>
            <ul className="mt-3 flex flex-col gap-2">
              {feedback.worked.map((item, i) => (
                <li
                  key={i}
                  className="border-l-2 border-[var(--accent)] pl-4 text-[15px] leading-[1.55] text-ink"
                >
                  {item}
                </li>
              ))}
            </ul>
          </section>

          {/* One fix, never a list. People can only act on one thing. */}
          <section
            aria-labelledby="fix"
            className="rounded border border-[var(--flag)] bg-[var(--flag-soft)] p-5"
          >
            <h2
              id="fix"
              className="tabular text-xs uppercase tracking-[0.18em] text-[var(--flag)]"
            >
              The one thing to change
            </h2>
            <p className="mt-3 text-[15px] leading-[1.6] text-ink">
              {feedback.fix}
            </p>
          </section>

          {/* Shown only when there is a real improvement to show. A mangled
              suggestion is worse than none, so the stand-in omits it rather
              than inventing one. */}
          {feedback.rewrite ? (
            <section aria-labelledby="rewrite">
              <h2
                id="rewrite"
                className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint"
              >
                One line, rewritten
              </h2>
              <div className="mt-4 border-l-2 border-rule-strong pl-4">
                <p className="text-[13px] text-ink-muted">You said</p>
                <p className="mt-1 text-[15px] leading-[1.55] text-ink">
                  &ldquo;{feedback.rewrite.original}&rdquo;
                </p>
                <p className="mt-3 text-[13px] text-ink-muted">Try</p>
                <p className="mt-1 text-[15px] leading-[1.55] text-ink">
                  &ldquo;{feedback.rewrite.better}&rdquo;
                </p>
                {feedback.rewrite.why ? (
                  <p className="mt-2 text-[13px] leading-relaxed text-ink-muted">
                    {feedback.rewrite.why}
                  </p>
                ) : null}
              </div>
            </section>
          ) : (
            <section className="border-l-2 border-rule pl-4">
              <p className="text-[13px] leading-relaxed text-ink-muted">
                No line-level rewrite for this one. Rewriting a specific
                sentence well means understanding it, which arrives with the AI
                partner.
              </p>
            </section>
          )}
        </>
      ) : (
        <section className="rounded border border-rule bg-[var(--paper-raised)] p-5">
          <h2 className="text-sm font-semibold text-ink">Scene ended</h2>
          <p className="mt-2 text-sm leading-relaxed text-ink-muted">
            The review could not be produced for this one, but the transcript is
            saved below.
          </p>
        </section>
      )}

      {/* Rehearsal is worth less than the real thing, and the app should keep
          saying so at the moment it would be easiest to forget. */}
      <section className="rounded border border-[var(--accent)] bg-[var(--accent-soft)] p-5">
        <h2 className="tabular text-xs uppercase tracking-[0.18em] text-[var(--accent)]">
          Now the real one
        </h2>
        <p className="mt-3 text-[15px] leading-[1.6] text-ink">
          {roleplay.lessons.mission_text}
        </p>
        <Link
          href="/log"
          className="mt-4 inline-flex rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
        >
          Log a real rep
        </Link>
      </section>

      <details className="border-t border-rule pt-5">
        <summary className="cursor-pointer text-xs text-ink-faint underline-offset-4 hover:underline">
          Read the transcript
        </summary>
        <ol className="mt-4 flex flex-col gap-3">
          {roleplay.transcript_json.map((turn, i) => (
            <li key={i} className="text-sm leading-relaxed">
              <span className="tabular text-[11px] uppercase tracking-[0.14em] text-ink-faint">
                {turn.role === "user" ? "You" : "Them"}
              </span>
              <p className="mt-0.5 text-ink">{turn.content}</p>
            </li>
          ))}
        </ol>
      </details>
    </div>
  );
}
