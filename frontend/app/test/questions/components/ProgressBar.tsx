type ProgressBarProps = {
  current: number; // 1-based
  total: number;
};

export function ProgressBar({ current, total }: ProgressBarProps) {
  const safeTotal = Math.max(1, total);
  const clampedCurrent = Math.min(Math.max(1, current), safeTotal);
  const percent = Math.round((clampedCurrent / safeTotal) * 100);

  return (
    <div className="flex items-center gap-3">
      <div className="h-2 w-full overflow-hidden rounded-full bg-zinc-200 dark:bg-zinc-800">
        <div
          className="h-full rounded-full bg-zinc-900 transition-[width] duration-300 dark:bg-white"
          style={{ width: `${percent}%` }}
        />
      </div>
      <div className="shrink-0 text-xs text-zinc-600 dark:text-zinc-400">
        {clampedCurrent}/{safeTotal}
      </div>
    </div>
  );
}

