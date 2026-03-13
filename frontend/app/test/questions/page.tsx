"use client";

import {
  useMutation,
  useQuery,
} from "@tanstack/react-query";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import {
  completeSession,
  CompleteSessionResponse,
  getCurrentQuestionnaire,
  Question,
  saveAnswers,
  SESSION_STORAGE_KEY,
} from "@/lib/api";
import { NextButton } from "./components/NextButton";
import { ProgressBar } from "./components/ProgressBar";
import { QuestionCard } from "./components/QuestionCard";

const STAGE_LABEL: Record<string, string> = {
  Q_BASIC: "기본 프로필",
  Q_APP: "외모 및 생활 정보",
  Q_EDU: "학력",
  Q_JOB: "직업",
  Q_INC: "경제력",
  Q_ASSET: "경제력",
  Q_FAM: "가족 배경",
  Q_PER: "성격 평가",
  Q_LST: "라이프스타일",
};

function getStageLabel(code: string): string {
  const prefix = Object.keys(STAGE_LABEL).find((k) => code.startsWith(k));
  return prefix ? STAGE_LABEL[prefix] : "";
}

function getSelectedOptionText(
  questions: Question[],
  code: string,
  answers: Record<number, number>
): string | null {
  const q = questions.find((q) => q.code === code);
  if (!q) return null;
  const opt = q.options.find((o) => o.option_id === answers[q.question_id]);
  return opt?.option_text ?? null;
}

function shouldSkip(questions: Question[], idx: number, answers: Record<number, number>): boolean {
  const q = questions[idx];
  if (!q) return false;
  if (q.code === "Q_BASIC_04") {
    return getSelectedOptionText(questions, "Q_BASIC_03", answers) !== "서울";
  }
  return false;
}

function nextIdx(questions: Question[], from: number, answers: Record<number, number>): number {
  let next = from + 1;
  while (next < questions.length && shouldSkip(questions, next, answers)) next++;
  return next;
}

function prevIdx(questions: Question[], from: number, answers: Record<number, number>): number {
  let prev = from - 1;
  while (prev > 0 && shouldSkip(questions, prev, answers)) prev--;
  return prev;
}

export default function TestQuestionsPage() {
  const router = useRouter();
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [index, setIndex] = useState(0);
  const [answers, setAnswers] = useState<Record<number, number>>({});

  useEffect(() => {
    const id =
      typeof window !== "undefined"
        ? window.sessionStorage.getItem(SESSION_STORAGE_KEY)
        : null;
    setSessionId(id);
    if (typeof window !== "undefined" && !id) {
      router.replace("/test/start");
    }
  }, [router]);

  const {
    data: questionnaire,
    isLoading: questionnaireLoading,
    error: questionnaireError,
  } = useQuery({
    queryKey: ["questionnaire", "current"],
    queryFn: getCurrentQuestionnaire,
    enabled: !!sessionId,
  });

  const saveAnswersMutation = useMutation({
    mutationFn: ({
      sessionId: sid,
      answers: list,
    }: {
      sessionId: string;
      answers: { question_id: number; option_id: number | null }[];
    }) =>
      saveAnswers(sid, {
        answers: list.map((a) => ({ question_id: a.question_id, option_id: a.option_id })),
      }),
  });

  const completeMutation = useMutation({
    mutationFn: completeSession,
    onSuccess: (data: CompleteSessionResponse) => {
      if (typeof window !== "undefined") {
        window.sessionStorage.removeItem(SESSION_STORAGE_KEY);
      }
      router.push(`/test/result/${data.result_token}`);
    },
  });

  const questions = questionnaire?.questions ?? [];
  const total = questions.length;
  const currentQuestion = total ? questions[index] : null;
  const selectedOptionId = currentQuestion
    ? answers[currentQuestion.question_id] ?? null
    : null;
  const canGoNext = selectedOptionId !== null;
  const isLast = total > 0 && nextIdx(questions, index, answers) >= total;
  const isFinishing =
    saveAnswersMutation.isPending || completeMutation.isPending;

  function handleSelect(optionId: number) {
    if (!currentQuestion) return;
    setAnswers((prev) => ({ ...prev, [currentQuestion.question_id]: optionId }));
  }

  function handleNext() {
    if (!canGoNext || !sessionId) return;
    const updatedAnswers = currentQuestion
      ? { ...answers, [currentQuestion.question_id]: selectedOptionId! }
      : answers;
    if (isLast) {
      const answerList = questions.map((q: Question) => ({
        question_id: q.question_id,
        option_id: updatedAnswers[q.question_id] ?? null,
      }));
      saveAnswersMutation.mutate(
        { sessionId, answers: answerList },
        { onSuccess: () => completeMutation.mutate(sessionId) }
      );
    } else {
      setAnswers(updatedAnswers);
      setIndex(nextIdx(questions, index, updatedAnswers));
    }
  }

  function handleBack() {
    if (index === 0) {
      router.push("/test/start");
    } else {
      setIndex(prevIdx(questions, index, answers));
    }
  }

  if (!sessionId) {
    return (
      <div className="min-h-screen bg-zinc-50 text-zinc-900 dark:bg-black dark:text-zinc-50">
        <main className="mx-auto w-full max-w-3xl px-6 py-16">
          <p className="text-sm text-zinc-600 dark:text-zinc-400">
            세션이 없습니다. 이동 중…
          </p>
        </main>
      </div>
    );
  }

  if (questionnaireLoading || !questionnaire) {
    return (
      <div className="min-h-screen bg-zinc-50 text-zinc-900 dark:bg-black dark:text-zinc-50">
        <main className="mx-auto w-full max-w-3xl px-6 py-16">
          <p className="text-sm text-zinc-600 dark:text-zinc-400">
            {questionnaireLoading ? "문항을 불러오는 중…" : "문항이 없습니다."}
          </p>
        </main>
      </div>
    );
  }

  if (questionnaireError) {
    return (
      <div className="min-h-screen bg-zinc-50 text-zinc-900 dark:bg-black dark:text-zinc-50">
        <main className="mx-auto w-full max-w-3xl px-6 py-16">
          <div className="rounded-2xl border border-red-200 bg-red-50 p-4 dark:border-red-900 dark:bg-red-950">
            <p className="text-sm text-red-800 dark:text-red-200">
              문항을 불러올 수 없습니다.
            </p>
            <p className="mt-1 text-xs text-red-600 dark:text-red-400">
              {(questionnaireError as Error).message}
            </p>
          </div>
          <Link
            href="/test/start"
            className="mt-4 inline-block rounded-full border border-zinc-300 px-4 py-2 text-sm hover:bg-zinc-100 dark:border-zinc-700 dark:hover:bg-zinc-900"
          >
            처음으로 돌아가기
          </Link>
        </main>
      </div>
    );
  }

  if (total === 0) {
    return (
      <div className="min-h-screen bg-zinc-50 text-zinc-900 dark:bg-black dark:text-zinc-50">
        <main className="mx-auto w-full max-w-3xl px-6 py-16">
          <p className="text-sm text-zinc-600 dark:text-zinc-400">
            등록된 문항이 없습니다.
          </p>
          <Link
            href="/test/start"
            className="mt-4 inline-block rounded-full border border-zinc-300 px-4 py-2 text-sm hover:bg-zinc-100 dark:border-zinc-700 dark:hover:bg-zinc-900"
          >
            처음으로 돌아가기
          </Link>
        </main>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-zinc-50 text-zinc-900 dark:bg-black dark:text-zinc-50">
      <main className="mx-auto w-full max-w-3xl px-6 py-16">
        <header className="mb-8 flex flex-col gap-4">
          <p className="text-sm font-medium text-zinc-600 dark:text-zinc-400">
            {currentQuestion ? getStageLabel(currentQuestion.code) : "결혼 적합도 평가"}
          </p>
          <div className="flex items-end justify-between gap-4">
            <div>
              <h1 className="text-3xl font-semibold tracking-tight">
                평가 문항
              </h1>
              <p className="mt-2 text-sm leading-6 text-zinc-600 dark:text-zinc-400">
                각 문항에 솔직하게 답해주세요.
              </p>
            </div>
            <div className="text-right text-xs text-zinc-600 dark:text-zinc-400">
              {index + 1} / {total}
            </div>
          </div>

          <ProgressBar current={index + 1} total={total} />
        </header>

        <QuestionCard
          question={currentQuestion!}
          selectedOptionId={selectedOptionId}
          onSelectOption={handleSelect}
        />

        <div className="mt-6 flex items-center justify-between gap-4">
          <button
            type="button"
            onClick={handleBack}
            className="rounded-full border border-zinc-300 px-4 py-2 text-sm hover:bg-zinc-100 dark:border-zinc-700 dark:hover:bg-zinc-900"
          >
            이전
          </button>

          <div className="flex items-center gap-3">
            <div className="hidden text-xs text-zinc-600 dark:text-zinc-400 sm:block">
              {canGoNext ? "선택 완료" : "항목을 선택해주세요"}
            </div>
            <NextButton
              disabled={!canGoNext || isFinishing}
              isLast={isLast}
              onClick={handleNext}
            />
          </div>
        </div>

        {(saveAnswersMutation.isError || completeMutation.isError) && (
          <p className="mt-4 text-sm text-red-600 dark:text-red-400">
            {(saveAnswersMutation.error ?? completeMutation.error) instanceof Error
              ? ((saveAnswersMutation.error ?? completeMutation.error) as Error).message
              : "오류가 발생했습니다."}
          </p>
        )}
      </main>
    </div>
  );
}
