"use client";

import { useActionState } from "react";
import { useFormStatus } from "react-dom";
import { useTranslations } from "next-intl";

import { AboutYouFields } from "@/components/about-you-fields";
import type { DatingInterest } from "@/lib/curriculum/variants";
import type { AgeGroup, Sex } from "@/lib/profile/demographics";
import { updateAboutYou, type SettingsState } from "./actions";

export function AboutYouForm({
  sex,
  ageGroup,
  datingInterest,
}: {
  sex: Sex | null;
  ageGroup: AgeGroup | null;
  datingInterest: DatingInterest | null;
}) {
  const t = useTranslations("settings.aboutYou");
  const [state, formAction] = useActionState<SettingsState, FormData>(
    updateAboutYou,
    {},
  );

  return (
    <form action={formAction} className="flex flex-col gap-4">
      <AboutYouFields
        sex={sex}
        ageGroup={ageGroup}
        datingInterest={datingInterest}
        idPrefix="settings-"
      />

      {state.error ? (
        <p role="alert" className="text-sm text-[var(--danger)]">
          {state.error}
        </p>
      ) : null}
      {state.done ? (
        <p role="status" className="text-sm text-[var(--accent)]">
          {state.done}
        </p>
      ) : null}

      <Submit label={t("save")} />
    </form>
  );
}

function Submit({ label }: { label: string }) {
  const t = useTranslations("common");
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={pending}
      className="self-start rounded bg-[var(--accent)] px-4 py-2.5 text-sm font-medium text-[var(--accent-ink)] transition-opacity hover:opacity-90 disabled:opacity-60"
    >
      {pending ? t("saving") : label}
    </button>
  );
}
