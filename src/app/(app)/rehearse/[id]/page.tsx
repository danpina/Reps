import Link from "next/link";
import { notFound } from "next/navigation";
import { getTranslations } from "next-intl/server";

import { BackLink } from "@/components/back-link";
import type { Translate } from "@/lib/i18n";
import { extractTheMove } from "@/lib/curriculum/the-move";
import { getProfile, requireUser } from "@/lib/auth/dal";
import { createClient } from "@/lib/supabase/server";
import type { Rubric, Scenario, WorkedExample } from "@/lib/curriculum/types";
import type { LessonVariant } from "@/lib/curriculum/variants";
import { shuffle } from "@/lib/curriculum/shuffle";
import { pickVariant, scenarioFor } from "@/lib/curriculum/variants";
import { checkLine } from "@/lib/roleplay/checks";
import type { Feedback } from "@/lib/roleplay/feedback";
import type { Turn } from "@/lib/roleplay/partner";
import { isUsingRealModel } from "@/lib/roleplay/engine";
import { turnCap, turnsLeftInScene } from "@/lib/roleplay/limits";
import {
  asBeatSpec,
  asChoiceSpec,
  asLineSpec,
  isDrillResult,
  isRehearsalMode,
  costsMoney,
  type DrillResult,
  type RehearsalMode,
} from "@/lib/roleplay/modes";
import { Chat } from "./chat";
import { ChoiceDrill, type AnsweredBeat } from "./choice-drill";
import { EndScene } from "./end-scene";
import { LineDrill, type Attempt } from "./line-drill";

export async function generateMetadata() {
  const t = await getTranslations("rehearseScreen");
  return { title: t("pageTitle") };
}

type Roleplay = {
  id: string;
  status: string;
  mode: string;
  transcript_json: Turn[];
  feedback_json: Feedback | DrillResult | null;
  lesson_id: string;
  lessons: {
    title: string;
    sort_order: number;
    theory_md: string;
    rehearsal_note: string | null;
    rehearsal_spec: unknown;
    examples_json: WorkedExample[];
    variants_json: LessonVariant[];
    scenario_json: Scenario;
    rubric_json: Rubric;
    mission_text: string;
    skills: { slug: string; name: string };
  };
};

export default async function RehearsePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  await requireUser();
  const { id } = await params;
  const t = await getTranslations("rehearseScreen");

  const profile = await getProfile();
  const supabase = await createClient();
  const { data } = await supabase
    .from("roleplays")
    .select(
      "id, status, mode, transcript_json, feedback_json, lesson_id, lessons(title, sort_order, theory_md, rehearsal_note, rehearsal_spec, examples_json, variants_json, scenario_json, rubric_json, mission_text, skills(slug, name))",
    )
    .eq("id", id)
    .maybeSingle();

  if (!data) notFound();

  const roleplay = data as unknown as Roleplay;
  const { lessons: lesson } = roleplay;

  // Who the reader is practising with, where the lesson cares. Everywhere else
  // this returns the scene exactly as written.
  const audience = {
    sex: profile?.sex ?? null,
    ageGroup: profile?.age_group ?? null,
    datingInterest: profile?.dating_interest ?? null,
  };
  const scenario = scenarioFor(
    lesson.scenario_json,
    audience,
    pickVariant(lesson.variants_json, audience),
  );
  const theMove = extractTheMove(lesson.theory_md, lesson.title);
  const complete = roleplay.status === "complete";

  // The mode is read off the rehearsal rather than off the lesson, so
  // re-authoring a lesson cannot change what an old transcript claims to be.
  const mode: RehearsalMode = isRehearsalMode(roleplay.mode)
    ? roleplay.mode
    : "scene";

  const said = roleplay.transcript_json.filter((t) => t.role === "user").length;
  const beatSpec = mode === "beat" ? asBeatSpec(lesson.rehearsal_spec) : null;
  const cap = turnCap(mode, beatSpec?.turns.length);

  return (
    <main className="mx-auto w-full max-w-2xl px-5 py-12">
      <header className="border-b border-rule pb-5">
        <BackLink
          href={`/skills/${lesson.skills.slug}/${lesson.sort_order}`}
          label={lesson.title}
        />
        <h1 className="mt-3 text-xl font-semibold tracking-tight text-ink">
          {t(`titles.${mode}`)}
        </h1>

        {/* A drill is not a conversation, so it does not get a partner card
            describing how open somebody is going to be. The read-and-decide
            one is not even a scene — it is a set of situations. */}
        {mode === "choice" ? null : (
          <div className="mt-4 rounded border border-rule bg-[var(--paper-raised)] p-4">
            <p className="text-[13px] leading-relaxed text-ink-muted">
              {scenario.setting}
            </p>
            <p className="mt-2 text-sm leading-relaxed text-ink">
              {t.rich("talkingTo", {
                name: scenario.partner.name,
                role: scenario.partner.role,
                strong: (chunks) => <strong>{chunks}</strong>,
              })}
            </p>
            {costsMoney(mode) ? (
              <p className="tabular mt-2 text-xs text-ink-faint">
                {t("opennessOfFive", { openness: scenario.partner.openness })}
                {scenario.partner.openness <= 2 ? t("opennessHardWork") : ""}
              </p>
            ) : null}
          </div>
        )}

        <section
          aria-labelledby="target"
          className="mt-3 rounded border border-[var(--accent)] bg-[var(--accent-soft)] p-4"
        >
          <h2
            id="target"
            className="tabular text-xs uppercase tracking-[0.18em] text-[var(--accent)]"
          >
            {t("whatYouArePractising")}
          </h2>
          <p className="mt-2 text-sm leading-relaxed text-ink">{theMove}</p>
          {lesson.rehearsal_note ? (
            <p className="mt-3 border-t border-[var(--accent)]/30 pt-3 text-[13px] leading-relaxed text-ink-muted">
              {lesson.rehearsal_note}
            </p>
          ) : null}

          {/* The rubric is what the AI review marks against, so it belongs on
              the scenes it marks. A drill states its own requirements next to
              the box, in the words they will be reported back in. */}
          {costsMoney(mode) ? (
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
          ) : null}
        </section>

        {costsMoney(mode) && !isUsingRealModel() ? (
          <p className="mt-3 text-[12px] leading-relaxed text-ink-faint">
            {t("scriptedPartnerNote")}
          </p>
        ) : null}
      </header>

      {complete ? (
        <CompletedRehearsal roleplay={roleplay} mode={mode} t={t} />
      ) : mode === "line" ? (
        <LineRehearsal roleplay={roleplay} t={t} />
      ) : mode === "choice" ? (
        <ChoiceRehearsal roleplay={roleplay} t={t} />
      ) : (
        <>
          <Chat
            roleplayId={roleplay.id}
            partnerName={scenario.partner.name}
            transcript={roleplay.transcript_json}
            turnsLeft={turnsLeftInScene(said, cap)}
            instruction={beatSpec?.turns[said]?.instruction}
          />
          <EndScene roleplayId={roleplay.id} hasSpoken={said > 0} />
        </>
      )}
    </main>
  );
}

/**
 * Verdicts are recomputed from the stored attempts rather than saved beside
 * them. The checks are pure and the authored rules are the source of truth, so
 * a line re-read after the rules were corrected is marked by the corrected
 * rules — which is the answer a learner would expect, and the alternative is a
 * page showing a tick next to something that no longer passes.
 */
function LineRehearsal({ roleplay, t }: { roleplay: Roleplay; t: Translate }) {
  const spec = asLineSpec(roleplay.lessons.rehearsal_spec);

  if (!spec) return <Unavailable lessonId={roleplay.lesson_id} t={t} />;

  const attempts: Attempt[] = roleplay.transcript_json
    .filter((turn) => turn.role === "user")
    .map((turn) => {
      const verdict = checkLine(turn.content, spec.checks);
      return { line: turn.content, landed: verdict.landed, results: verdict.results };
    });

  return (
    <LineDrill
      roleplayId={roleplay.id}
      says={spec.says}
      requirements={spec.checks.map((check) => check.requirement)}
      attempts={attempts}
      examples={roleplay.lessons.examples_json ?? []}
      model={spec.model}
      maxChars={spec.maxChars}
    />
  );
}

function ChoiceRehearsal({ roleplay, t }: { roleplay: Roleplay; t: Translate }) {
  const spec = asChoiceSpec(roleplay.lessons.rehearsal_spec);

  if (!spec) return <Unavailable lessonId={roleplay.lesson_id} t={t} />;

  const picks = roleplay.transcript_json.filter((turn) => turn.role === "user");

  const answered: AnsweredBeat[] = picks.map((turn, i) => ({
    beat: spec.beats[i],
    chosen: turn.content,
    correct: turn.correct === true,
  }));

  const current = spec.beats[picks.length] ?? null;

  // Shuffled for the same reason the comprehension beats are: a card tends to
  // get written with the right answer in a habitual slot, and a reader picks
  // that pattern up long before they learn anything. Each option carries the
  // index it was authored at, so the answer the server checks is the one they
  // actually chose rather than the position they clicked.
  const options = current
    ? shuffle(current.options.map((option, index) => ({ option, index })))
    : [];

  return (
    <ChoiceDrill
      roleplayId={roleplay.id}
      answered={answered.filter((a) => a.beat)}
      current={current}
      options={options}
      total={spec.beats.length}
    />
  );
}

function Unavailable({ lessonId, t }: { lessonId: string; t: Translate }) {
  return (
    <div className="mt-8 rounded border border-rule bg-[var(--paper-raised)] p-6">
      <h2 className="text-sm font-semibold text-ink">
        {t("drillNotReady")}
      </h2>
      <p className="mt-2 text-sm leading-relaxed text-ink-muted">
        {t("drillNotReadyBody")}
      </p>
      <Link
        href={`/log?lesson=${lessonId}`}
        className="mt-4 inline-flex rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
      >
        {t("logARealRep")}
      </Link>
    </div>
  );
}

function CompletedRehearsal({
  roleplay,
  mode,
  t,
}: {
  roleplay: Roleplay;
  mode: RehearsalMode;
  t: Translate;
}) {
  const result = roleplay.feedback_json;

  return (
    <div className="mt-7 flex flex-col gap-9">
      {isDrillResult(result) ? (
        <DrillOutcome
          result={result}
          examples={roleplay.lessons.examples_json ?? []}
          t={t}
        />
      ) : result ? (
        <SceneReview feedback={result} rubric={roleplay.lessons.rubric_json} t={t} />
      ) : (
        <section className="rounded border border-rule bg-[var(--paper-raised)] p-5">
          <h2 className="text-sm font-semibold text-ink">{t("sceneEnded")}</h2>
          <p className="mt-2 text-sm leading-relaxed text-ink-muted">
            {t("sceneEndedBody")}
          </p>
        </section>
      )}

      {/* Rehearsal is worth less than the real thing, and the app should keep
          saying so at the moment it would be easiest to forget. */}
      <section className="rounded border border-[var(--accent)] bg-[var(--accent-soft)] p-5">
        <h2 className="tabular text-xs uppercase tracking-[0.18em] text-[var(--accent)]">
          {t("nowTheRealOne")}
        </h2>
        <p className="mt-3 text-[15px] leading-[1.6] text-ink">
          {roleplay.lessons.mission_text}
        </p>
        <Link
          href={`/log?lesson=${roleplay.lesson_id}`}
          className="mt-4 inline-flex rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90"
        >
          {t("logARealRep")}
        </Link>
      </section>

      <details className="border-t border-rule pt-5">
        <summary className="cursor-pointer text-xs text-ink-faint underline-offset-4 hover:underline">
          {mode === "choice" ? t("whatYouChose") : t("readTheTranscript")}
        </summary>
        <ol className="mt-4 flex flex-col gap-3">
          {roleplay.transcript_json.map((turn, i) => (
            <li key={i} className="text-sm leading-relaxed">
              <span className="tabular text-[11px] uppercase tracking-[0.14em] text-ink-faint">
                {turn.role === "user" ? t("you") : t("them")}
              </span>
              <p className="mt-0.5 text-ink">{turn.content}</p>
            </li>
          ))}
        </ol>
      </details>
    </div>
  );
}

function DrillOutcome({
  result,
  examples,
  t,
}: {
  result: DrillResult;
  examples: WorkedExample[];
  t: Translate;
}) {
  return (
    <>
      <section
        aria-labelledby="outcome"
        className={[
          "rounded border p-5",
          result.landed
            ? "border-[var(--accent)] bg-[var(--accent-soft)]"
            : "border-rule bg-[var(--paper-raised)]",
        ].join(" ")}
      >
        <h2
          id="outcome"
          className={[
            "tabular text-xs uppercase tracking-[0.18em]",
            result.landed ? "text-[var(--accent)]" : "text-ink-faint",
          ].join(" ")}
        >
          {result.landed ? t("landedIt") : t("notQuite")}
        </h2>
        <p className="mt-3 text-[15px] leading-[1.6] text-ink">
          {result.landed
            ? t("everyRequirementMet", {
                attemptClause:
                  result.attempts > 1
                    ? t("onAttempt", { n: result.attempts })
                    : t("firstTime"),
              })
            : t("settledOnOneThatMissed")}
        </p>

        {result.missed.length > 0 ? (
          <ul className="mt-3 flex flex-col gap-1.5 border-t border-rule pt-3">
            {result.missed.map((requirement) => (
              <li key={requirement} className="text-[13px] leading-snug text-ink-muted">
                {requirement}
              </li>
            ))}
          </ul>
        ) : null}
      </section>

      {examples.length > 0 ? (
        <section aria-labelledby="worked-examples">
          <h2
            id="worked-examples"
            className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint"
          >
            {t("threeThatWork")}
          </h2>
          <ol className="mt-4 flex flex-col gap-5">
            {examples.map((example, i) => (
              <li key={i}>
                <p className="text-[12px] leading-relaxed text-ink-faint">
                  {example.situation}
                </p>
                <p className="mt-1.5 border-l-2 border-[var(--accent)] pl-4 text-[15px] leading-[1.55] text-ink">
                  {example.line}
                </p>
                <p className="mt-1.5 text-[13px] leading-relaxed text-ink-muted">
                  {example.why}
                </p>
              </li>
            ))}
          </ol>
        </section>
      ) : null}
    </>
  );
}

function SceneReview({
  feedback,
  rubric,
  t,
}: {
  feedback: Feedback;
  rubric: Rubric;
  t: Translate;
}) {
  return (
    <>
      <section aria-labelledby="scores">
        <h2
          id="scores"
          className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint"
        >
          {t("howItWent")}
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
          {t("whatWorked")}
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
          {t("theOneThingToChange")}
        </h2>
        <p className="mt-3 text-[15px] leading-[1.6] text-ink">{feedback.fix}</p>
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
            {t("oneLineRewritten")}
          </h2>
          <div className="mt-4 border-l-2 border-rule-strong pl-4">
            <p className="text-[13px] text-ink-muted">{t("youSaid")}</p>
            <p className="mt-1 text-[15px] leading-[1.55] text-ink">
              &ldquo;{feedback.rewrite.original}&rdquo;
            </p>
            <p className="mt-3 text-[13px] text-ink-muted">{t("try")}</p>
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
            {t("noLineLevelRewrite")}
          </p>
        </section>
      )}
    </>
  );
}
