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

  const total = questionnaire?.questions?.length ?? 0;
  const currentQuestion = total
    ? questionnaire!.questions[index]
    : null;
  const selectedOptionId = currentQuestion
    ? answers[currentQuestion.question_id] ?? null
    : null;
  const canGoNext = selectedOptionId !== null;
  const isLast = total > 0 && index === total - 1;
  const isFinishing =
    saveAnswersMutation.isPending || completeMutation.isPending;

  function handleSelect(optionId: number) {
    if (!currentQuestion) return;
    setAnswers((prev) => ({ ...prev, [currentQuestion.question_id]: optionId }));
  }

  function handleNext() {
    if (!canGoNext || !sessionId) return;
    if (isLast) {
      const answerList = questionnaire!.questions.map((q: Question) => ({
        question_id: q.question_id,
        option_id:
          q.question_id === currentQuestion!.question_id
            ? selectedOptionId
            : answers[q.question_id] ?? null,
      }));
      saveAnswersMutation.mutate(
        { sessionId, answers: answerList },
        {
          onSuccess: () => {
            completeMutation.mutate(sessionId);
          },
        }
      );
    } else {
      setIndex((i) => Math.min(i + 1, total - 1));
    }
  }

  if (!sessionId) {
    return (
      <div className="min-h-screen bg-zinc-50 text-zinc-900 dark:bg-black dark:text-zinc-50">
        <main className="mx-auto w-full max-w-3xl px-6 py-16">
          <p className="text-sm text-zinc-600 dark:text-zinc-400">
            No session. Redirecting…
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
            {questionnaireLoading ? "Loading questionnaire…" : "No questionnaire."}
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
              Failed to load questionnaire.
            </p>
            <p className="mt-1 text-xs text-red-600 dark:text-red-400">
              {(questionnaireError as Error).message}
            </p>
          </div>
          <Link
            href="/test/start"
            className="mt-4 inline-block rounded-full border border-zinc-300 px-4 py-2 text-sm hover:bg-zinc-100 dark:border-zinc-700 dark:hover:bg-zinc-900"
          >
            Back to start
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
            This questionnaire has no questions.
          </p>
          <Link
            href="/test/start"
            className="mt-4 inline-block rounded-full border border-zinc-300 px-4 py-2 text-sm hover:bg-zinc-100 dark:border-zinc-700 dark:hover:bg-zinc-900"
          >
            Back to start
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
            /test/questions
          </p>
          <div className="flex items-end justify-between gap-4">
            <div>
              <h1 className="text-3xl font-semibold tracking-tight">
                Questionnaire
              </h1>
              <p className="mt-2 text-sm leading-6 text-zinc-600 dark:text-zinc-400">
                Answer the questions below.
              </p>
            </div>
            <div className="text-right text-xs text-zinc-600 dark:text-zinc-400">
              ID <span className="font-medium">{questionnaire.questionnaire_id}</span>
              <br />
              v{questionnaire.version_no}
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
          <Link
            href="/test/start"
            className="rounded-full border border-zinc-300 px-4 py-2 text-sm hover:bg-zinc-100 dark:border-zinc-700 dark:hover:bg-zinc-900"
          >
            Back
          </Link>

          <div className="flex items-center gap-3">
            <div className="hidden text-xs text-zinc-600 dark:text-zinc-400 sm:block">
              {canGoNext ? "Ready" : "Select an option to continue"}
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
              : "Something went wrong."}
          </p>
        )}
      </main>
    </div>
  );
}
