import { getTranslations } from "next-intl/server";

export default async function AuthLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const t = await getTranslations("auth.pitch");

  return (
    <main className="flex min-h-dvh flex-col justify-center px-5 py-12">
      <div className="mx-auto w-full max-w-sm">
        <div className="mb-9">
          <p className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
            Reps
          </p>
          <h1 className="mt-3 text-2xl font-semibold leading-[1.15] tracking-tight text-ink">
            {t("headline")}
          </h1>
          <p className="mt-4 text-[15px] leading-[1.6] text-ink">
            {t("body1")}
          </p>
          <p className="mt-3 text-[15px] leading-[1.6] text-ink-muted">
            {t("body2")}
          </p>
          <p className="mt-3 text-[15px] font-medium leading-[1.6] text-ink">
            {t("closer")}
          </p>
        </div>
        {children}
      </div>
    </main>
  );
}
