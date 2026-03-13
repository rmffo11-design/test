import { OptionList } from "./OptionList";

type Option = {
  option_id: number;
  option_text: string;
};

type Question = {
  question_id: number;
  question_text: string;
  options: Option[];
};

type QuestionCardProps = {
  question: Question;
  selectedOptionId: number | null;
  onSelectOption: (optionId: number) => void;
};

export function QuestionCard({
  question,
  selectedOptionId,
  onSelectOption,
}: QuestionCardProps) {
  return (
    <section className="rounded-3xl border border-zinc-200 bg-white p-6 dark:border-zinc-800 dark:bg-zinc-950">
      <div className="text-sm font-medium text-zinc-600 dark:text-zinc-400">
        Question
      </div>
      <h2 className="mt-2 text-xl font-semibold leading-7 tracking-tight">
        {question.question_text}
      </h2>

      <OptionList
        options={question.options}
        selectedOptionId={selectedOptionId}
        onSelect={onSelectOption}
      />
    </section>
  );
}

