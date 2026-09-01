import { getTranslations } from "next-intl/server";

import { getLocale } from "@/lib/auth/dal";
import type { HeatmapDay } from "@/lib/progress/queries";

/**
 * Active days as a calendar grid.
 *
 * The first version was an unlabelled block of squares: no idea which column
 * was which week, which row was which day, or what a filled square meant. It
 * now carries month markers along the top, weekday initials down the side, and
 * a legend, so it can be read rather than decoded.
 *
 * Still deliberately quiet. It is a record of what happened, not a scoreboard,
 * so an empty day is a faint outline rather than a reproach.
 */

const DAY_INITIAL_KEYS = ["0", "1", "2", "3", "4", "5", "6"];

export async function Heatmap({ days }: { days: HeatmapDay[] }) {
  if (days.length === 0) return null;

  const t = await getTranslations("heatmap");
  const locale = await getLocale();

  function monthLabel(iso: string): string {
    return new Date(`${iso}T00:00:00`).toLocaleDateString(locale, {
      month: "short",
    });
  }

  // Chunk into weeks. The first day is always a Monday.
  const weeks: HeatmapDay[][] = [];
  for (let i = 0; i < days.length; i += 7) {
    weeks.push(days.slice(i, i + 7));
  }

  const active = days.filter((d) => d.count > 0).length;
  const total = days.reduce((sum, d) => sum + d.count, 0);
  const best = Math.max(...days.map((d) => d.count));

  // A month label sits above the first week that starts a new month.
  const monthMarkers = weeks.map((week, i) => {
    const label = monthLabel(week[0].date);
    if (i === 0) return label;
    return label === monthLabel(weeks[i - 1][0].date) ? "" : label;
  });

  return (
    <div>
      <div className="flex items-baseline justify-between gap-3">
        <h2 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
          {t("activeDays")}
        </h2>
        <p className="tabular text-xs text-ink-faint">
          {t("daysCount", { count: active })} · {t("repsCount", { count: total })}
        </p>
      </div>

      <div className="mt-3 overflow-x-auto pb-1">
        <div className="inline-flex flex-col gap-1">
          {/* Month markers, aligned to the week columns below. */}
          <div className="flex gap-[3px] pl-5">
            {monthMarkers.map((label, i) => (
              <div key={i} className="w-3">
                <span className="tabular block text-[10px] leading-none text-ink-faint">
                  {label}
                </span>
              </div>
            ))}
          </div>

          <div className="flex gap-[3px]">
            {/* Weekday initials. Only alternate rows are labelled, or the
                column becomes noisier than the grid it explains. */}
            <div
              aria-hidden
              className="flex w-4 flex-col gap-[3px] pr-1 text-right"
            >
              {DAY_INITIAL_KEYS.map((key, i) => (
                <span
                  key={i}
                  className="tabular block h-3 text-[9px] leading-3 text-ink-faint"
                >
                  {i % 2 === 0 ? t(`weekdayInitial.${key}`) : ""}
                </span>
              ))}
            </div>

            <div
              className="flex gap-[3px]"
              role="img"
              aria-label={t("summaryAriaLabel", {
                active,
                reps: total,
                weeks: weeks.length,
              })}
            >
              {weeks.map((week, i) => (
                <div key={i} className="flex flex-col gap-[3px]">
                  {week.map((day) => (
                    <div
                      key={day.date}
                      title={`${new Date(`${day.date}T00:00:00`).toLocaleDateString(
                        locale,
                        { weekday: "short", day: "numeric", month: "short" },
                      )} — ${
                        day.count === 0
                          ? t("nothingLogged")
                          : t("repsCount", { count: day.count })
                      }`}
                      className={[
                        "h-3 w-3 rounded-[2px] border",
                        day.count === 0
                          ? "border-rule bg-transparent"
                          : day.count === 1
                            ? "border-[var(--accent)] bg-[var(--accent-soft)]"
                            : "border-[var(--accent)] bg-[var(--accent)]",
                      ].join(" ")}
                    />
                  ))}
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Without this the shading is guesswork. */}
      <div className="mt-2.5 flex items-center gap-3">
        <span className="flex items-center gap-1.5">
          <span aria-hidden className="h-3 w-3 rounded-[2px] border border-rule" />
          <span className="text-[11px] text-ink-faint">{t("legendNone")}</span>
        </span>
        <span className="flex items-center gap-1.5">
          <span
            aria-hidden
            className="h-3 w-3 rounded-[2px] border border-[var(--accent)] bg-[var(--accent-soft)]"
          />
          <span className="text-[11px] text-ink-faint">{t("legendOne")}</span>
        </span>
        <span className="flex items-center gap-1.5">
          <span
            aria-hidden
            className="h-3 w-3 rounded-[2px] border border-[var(--accent)] bg-[var(--accent)]"
          />
          <span className="text-[11px] text-ink-faint">
            {best > 2 ? t("legendTwoOrMore") : t("legendTwoPlus")}
          </span>
        </span>
      </div>
    </div>
  );
}
