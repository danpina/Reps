"use client";

import { useState } from "react";

import { WENT_LABELS } from "@/lib/progress/rules";

/**
 * The fields a rep is made of, shared by logging one and correcting one.
 *
 * Extracted rather than duplicated because the two forms have to stay
 * identical in what they capture — an edit screen that offered a different set
 * of fields would quietly make some mistakes uncorrectable.
 *
 * Grouped by topic rather than listed flat. At nine skills a flat list was
 * fine. Across every topic it is fifty entries with three different things
 * called "Openers" in it, and the topic is the only thing that tells them
 * apart.
 */
export type SkillGroup = { topic: string; skills: { id: string; name: string }[] };

export type RepValues = {
  skillId?: string;
  went?: number;
  contextNote?: string;
  reflection?: string;
};

const WENT_HINTS: Record<number, string> = {
  1: "Fell flat, or you bailed",
  2: "Some of it worked",
  3: "That went somewhere",
};

export function RepFields({
  groups,
  values = {},
}: {
  groups: SkillGroup[];
  values?: RepValues;
}) {
  const [went, setWent] = useState<number | null>(values.went ?? null);

  return (
    <>
      <div className="flex flex-col gap-2">
        <label htmlFor="skill_id" className="text-sm font-medium text-ink">
          Which skill
        </label>
        <select
          id="skill_id"
          name="skill_id"
          defaultValue={values.skillId ?? ""}
          required
          className="rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2.5 text-sm text-ink focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        >
          <option value="" disabled>
            Pick one
          </option>
          {groups.map((group) => (
            <optgroup key={group.topic} label={group.topic}>
              {group.skills.map((skill) => (
                <option key={skill.id} value={skill.id}>
                  {skill.name}
                </option>
              ))}
            </optgroup>
          ))}
        </select>
      </div>

      <fieldset className="flex flex-col gap-2">
        <legend className="text-sm font-medium text-ink">How did it go?</legend>
        <p className="text-[13px] leading-relaxed text-ink-muted">
          You get credit for doing it, not for it going well. A bad rep is worth
          the same as a good one.
        </p>
        <div className="mt-1 grid grid-cols-3 gap-2">
          {[1, 2, 3].map((value) => {
            const selected = went === value;
            return (
              <label
                key={value}
                className={[
                  "cursor-pointer rounded border px-3 py-3 text-center transition-colors",
                  // The input itself is sr-only, so the focus ring has to be
                  // drawn on the label or keyboard users see nothing.
                  "has-[:focus-visible]:outline has-[:focus-visible]:outline-2 has-[:focus-visible]:outline-offset-2 has-[:focus-visible]:outline-[var(--focus)]",
                  selected
                    ? "border-[var(--accent)] bg-[var(--accent-soft)]"
                    : "border-[var(--rule-strong)] hover:bg-[var(--paper-raised)]",
                ].join(" ")}
              >
                <input
                  type="radio"
                  name="went"
                  value={value}
                  checked={selected}
                  onChange={() => setWent(value)}
                  required
                  className="sr-only"
                />
                <span className="block text-sm font-medium text-ink">
                  {WENT_LABELS[value]}
                </span>
                <span className="mt-1 block text-[12px] leading-snug text-ink-muted">
                  {WENT_HINTS[value]}
                </span>
              </label>
            );
          })}
        </div>
      </fieldset>

      <div className="flex flex-col gap-2">
        <label htmlFor="context_note" className="text-sm font-medium text-ink">
          Who or where{" "}
          <span className="font-normal text-ink-faint">— optional</span>
        </label>
        <input
          id="context_note"
          name="context_note"
          type="text"
          maxLength={140}
          defaultValue={values.contextNote ?? ""}
          placeholder="Barista, the 8:40 train, someone at the gym"
          className="rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2.5 text-sm text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        />
        <p className="text-[12px] text-ink-faint">Your words. No names needed.</p>
      </div>

      <div className="flex flex-col gap-2">
        <label htmlFor="reflection" className="text-sm font-medium text-ink">
          One note <span className="font-normal text-ink-faint">— optional</span>
        </label>
        <textarea
          id="reflection"
          name="reflection"
          rows={3}
          maxLength={500}
          defaultValue={values.reflection ?? ""}
          placeholder="What you tried, what happened, what you noticed."
          className="resize-none rounded border border-[var(--rule-strong)] bg-[var(--paper)] px-3 py-2.5 text-sm leading-relaxed text-ink placeholder:text-ink-faint focus:outline-none focus:ring-2 focus:ring-[var(--accent)]"
        />
      </div>
    </>
  );
}
