import type { HeatmapDay } from "@/lib/progress/queries";

/**
 * Active days as a calendar grid, one column per week. Deliberately quiet: it
 * is a record of what happened, not a scoreboard, so an empty day is a faint
 * outline rather than a reproach.
 */
export function Heatmap({ days }: { days: HeatmapDay[] }) {
  if (days.length === 0) return null;

  // Chunk into weeks. The first day is always a Monday.
  const weeks: HeatmapDay[][] = [];
  for (let i = 0; i < days.length; i += 7) {
    weeks.push(days.slice(i, i + 7));
  }

  const active = days.filter((d) => d.count > 0).length;

  return (
    <div>
      <div className="flex items-baseline justify-between">
        <h2 className="tabular text-xs uppercase tracking-[0.18em] text-ink-faint">
          Active days
        </h2>
        <p className="tabular text-xs text-ink-faint">
          {active} in {weeks.length} weeks
        </p>
      </div>

      <div className="mt-3 overflow-x-auto">
        <div className="flex gap-[3px]" role="img" aria-label={`${active} active days in the last ${weeks.length} weeks`}>
          {weeks.map((week, i) => (
            <div key={i} className="flex flex-col gap-[3px]">
              {week.map((day) => (
                <div
                  key={day.date}
                  title={`${day.date}: ${day.count === 0 ? "nothing logged" : `${day.count} rep${day.count === 1 ? "" : "s"}`}`}
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
  );
}
