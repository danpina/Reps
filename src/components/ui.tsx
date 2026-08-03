import type { ComponentProps } from "react";

function cx(...parts: (string | false | undefined)[]) {
  return parts.filter(Boolean).join(" ");
}

export function Button({
  className,
  variant = "primary",
  ...props
}: ComponentProps<"button"> & { variant?: "primary" | "quiet" }) {
  return (
    <button
      className={cx(
        "inline-flex items-center justify-center rounded px-4 py-2.5 text-sm font-medium",
        "transition-colors disabled:opacity-50 disabled:cursor-not-allowed",
        variant === "primary" &&
          "bg-[var(--accent)] text-[var(--accent-ink)] hover:opacity-90",
        variant === "quiet" &&
          "border border-[var(--rule-strong)] text-ink hover:bg-[var(--paper-raised)]",
        className,
      )}
      {...props}
    />
  );
}

export function Field({
  label,
  hint,
  id,
  ...props
}: ComponentProps<"input"> & { label: string; hint?: string; id: string }) {
  return (
    <div className="flex flex-col gap-1.5">
      <label htmlFor={id} className="text-sm font-medium text-ink">
        {label}
      </label>
      <input
        id={id}
        className={cx(
          "w-full rounded border border-[var(--rule-strong)] bg-[var(--paper-raised)]",
          "px-3 py-2.5 text-[16px] text-ink placeholder:text-[var(--ink-faint)]",
          "focus:border-[var(--focus)]",
        )}
        {...props}
      />
      {hint ? (
        <p className="text-xs text-ink-muted">{hint}</p>
      ) : null}
    </div>
  );
}

export function Notice({
  tone = "danger",
  children,
}: {
  tone?: "danger" | "accent" | "flag";
  children: React.ReactNode;
}) {
  const toneClass = {
    danger: "bg-[var(--danger-soft)] text-[var(--danger)]",
    accent: "bg-[var(--accent-soft)] text-[var(--accent)]",
    flag: "bg-[var(--flag-soft)] text-[var(--flag)]",
  }[tone];

  return (
    <p
      role={tone === "danger" ? "alert" : "status"}
      className={cx("rounded px-3 py-2.5 text-sm", toneClass)}
    >
      {children}
    </p>
  );
}
