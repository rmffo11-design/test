type NextButtonProps = {
  disabled?: boolean;
  isLast?: boolean;
  onClick: () => void;
};

export function NextButton({ disabled, isLast, onClick }: NextButtonProps) {
  return (
    <button
      type="button"
      onClick={onClick}
      disabled={disabled}
      className={[
        "inline-flex items-center justify-center rounded-full px-5 py-2 text-sm font-medium transition",
        "bg-zinc-900 text-white hover:bg-zinc-800 dark:bg-white dark:text-black dark:hover:bg-zinc-200",
        "disabled:cursor-not-allowed disabled:opacity-50 disabled:hover:bg-zinc-900 dark:disabled:hover:bg-white",
      ].join(" ")}
    >
      {isLast ? "Finish" : "Next"}
    </button>
  );
}

