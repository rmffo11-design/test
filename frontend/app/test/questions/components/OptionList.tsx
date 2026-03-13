type Option = {
  option_id: number;
  option_text: string;
};

type OptionListProps = {
  options: Option[];
  selectedOptionId: number | null;
  onSelect: (optionId: number) => void;
};

export function OptionList({ options, selectedOptionId, onSelect }: OptionListProps) {
  return (
    <div className="mt-5 grid gap-3">
      {options.map((opt) => {
        const selected = opt.option_id === selectedOptionId;
        return (
          <button
            key={opt.option_id}
            type="button"
            onClick={() => onSelect(opt.option_id)}
            className={[
              "w-full rounded-2xl border p-4 text-left transition",
              selected
                ? "border-zinc-900 bg-zinc-50 dark:border-white dark:bg-zinc-900"
                : "border-zinc-200 bg-white hover:bg-zinc-50 dark:border-zinc-800 dark:bg-zinc-950 dark:hover:bg-zinc-900",
            ].join(" ")}
          >
            <div className="flex items-start justify-between gap-4">
              <div className="text-sm leading-6">{opt.option_text}</div>
              <div
                className={[
                  "mt-0.5 h-4 w-4 shrink-0 rounded-full border",
                  selected
                    ? "border-zinc-900 bg-zinc-900 dark:border-white dark:bg-white"
                    : "border-zinc-300 dark:border-zinc-700",
                ].join(" ")}
              />
            </div>
          </button>
        );
      })}
    </div>
  );
}

