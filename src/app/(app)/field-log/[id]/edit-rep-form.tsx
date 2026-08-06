"use client";

import { useActionState, useState } from "react";
import { useFormStatus } from "react-dom";

import { RepFields, type RepValues, type SkillGroup } from "../../log/rep-fields";
import { deleteRep, updateRep, type EditRepState } from "../actions";

export function EditRepForm({
  id,
  groups,
  values,
}: {
  id: string;
  groups: SkillGroup[];
  values: RepValues;
}) {
  const [state, formAction] = useActionState<EditRepState, FormData>(
    updateRep,
    {},
  );

  return (
    <>
      <form action={formAction} className="mt-7 flex flex-col gap-7">
        <input type="hidden" name="id" value={id} />

        <RepFields groups={groups} values={values} />

        {state.error ? (
          <p
            role="alert"
            className="rounded border border-[var(--flag)] bg-[var(--flag-soft)] px-4 py-3 text-sm text-ink"
          >
            {state.error}
          </p>
        ) : null}

        <Save />
      </form>

      <DeleteRep id={id} />
    </>
  );
}

function Save() {
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={pending}
      className="self-start rounded bg-[var(--accent)] px-4 py-3 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90 disabled:opacity-60"
    >
      {pending ? "Saving…" : "Save changes"}
    </button>
  );
}

/**
 * Behind a second click.
 *
 * Not because deleting one rep is catastrophic, but because this sits at the
 * bottom of a form people arrive at to fix a typo, and a delete button next to
 * a save button gets hit eventually.
 */
function DeleteRep({ id }: { id: string }) {
  const [armed, setArmed] = useState(false);

  return (
    <section className="mt-10 border-t border-rule pt-6">
      <h2 className="text-xs uppercase tracking-[0.14em] text-ink-faint">
        Delete this rep
      </h2>
      <p className="mt-2 text-[13px] leading-relaxed text-ink-muted">
        It comes off the log, and the XP and streak it earned go back to what
        they were. Badges you have already earned stay earned.
      </p>

      {armed ? (
        <form action={deleteRep} className="mt-4 flex items-center gap-3">
          <input type="hidden" name="id" value={id} />
          <DeleteButton />
          <button
            type="button"
            onClick={() => setArmed(false)}
            className="text-sm text-ink-muted underline-offset-4 hover:text-ink hover:underline"
          >
            Keep it
          </button>
        </form>
      ) : (
        <button
          type="button"
          onClick={() => setArmed(true)}
          className="mt-4 rounded border border-[var(--rule-strong)] px-4 py-2.5 text-sm font-medium text-ink transition-colors hover:bg-[var(--paper-raised)]"
        >
          Delete this rep
        </button>
      )}
    </section>
  );
}

function DeleteButton() {
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={pending}
      className="rounded bg-[var(--flag)] px-4 py-2.5 text-sm font-medium text-[var(--paper)] transition-opacity hover:opacity-90 disabled:opacity-60"
    >
      {pending ? "Deleting…" : "Yes, delete it"}
    </button>
  );
}
