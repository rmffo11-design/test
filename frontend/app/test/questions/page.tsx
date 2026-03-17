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
  QuestionOption,
  saveAnswers,
  SESSION_STORAGE_KEY,
} from "@/lib/api";
import { NextButton } from "./components/NextButton";
import { ProgressBar } from "./components/ProgressBar";
import { QuestionCard } from "./components/QuestionCard";

/* ── 스테이지 라벨 ──────────────────────────────── */
const STAGE_LABEL: Record<string, string> = {
  Q_BASIC: "기본 프로필",
  Q_APP:   "외모 및 생활 정보",
  Q_EDU:   "학력",
  Q_JOB:   "직업",
  Q_INC:   "경제력",
  Q_ASSET: "경제력",
  Q_FAM:   "가족 배경",
  Q_PER:   "성격 평가",
  Q_LST:   "라이프스타일",
};

function getStageLabel(code: string | undefined): string {
  if (!code) return "";
  const prefix = Object.keys(STAGE_LABEL).find((k) => code.startsWith(k));
  return prefix ? STAGE_LABEL[prefix] : "";
}

/* ── code → display_order 폴백 매핑 ── */
const CODE_TO_ORDER: Record<string, number> = {
  Q_BASIC_03: 3,
  Q_BASIC_04: 4,
  Q_EDU_01:   14,
  Q_EDU_02:   15,
  Q_EDU_03:   16,
};

/* ── 선택된 option_code 반환 (텍스트 비교보다 안정적) ── */
function getSelectedCode(
  questions: Question[],
  questionCode: string,
  answers: Record<number, number>
): string | null {
  const order = CODE_TO_ORDER[questionCode];
  const q = questions.find(
    (q) => q.code === questionCode || (order !== undefined && q.display_order === order)
  );
  if (!q) return null;
  const optionId = (answers as Record<string, number>)[String(q.question_id)];
  if (optionId === undefined) return null;
  const opt = q.options.find((o) => o.option_id === optionId);
  return opt?.option_code ?? opt?.option_text ?? null;
}

/* ── Q_EDU_03 국내/해외 필터링용 option_code 세트 ── */
const DOMESTIC_CODES = new Set([
  "O_EDU_03_A", // 서울대(S군)
  "O_EDU_03_C", // 연세대/고려대(A군)
  "O_EDU_03_D", // 서강대/성균관대/한양대(B군)
  "O_EDU_03_F", // 중앙대/경희대/…(C군)
  "O_EDU_03_G", // 건국대/동국대/홍익대(D군)
  "O_EDU_03_H", // 지방 국립대
  "O_EDU_03_I", // 지방 사립대
  "O_EDU_03_P", // 기타
]);
const FOREIGN_CODES = new Set([
  "O_EDU_03_B", // 해외 최상위
  "O_EDU_03_E", // 해외 상위권
  "O_EDU_03_J", // 해외 일반
  "O_EDU_03_P", // 기타
]);

/* ── 질문 건너뛰기 규칙 ──────────────────────────── */
function matchesCode(q: Question, code: string): boolean {
  const order = CODE_TO_ORDER[code];
  return q.code === code || (order !== undefined && q.display_order === order);
}

function shouldSkip(
  questions: Question[],
  idx: number,
  answers: Record<number, number>
): boolean {
  const q = questions[idx];
  if (!q) return false;

  // Q_BASIC_04 (서울 구): Q_BASIC_03 = O_BASIC_03_A(서울)일 때만 표시
  if (matchesCode(q, "Q_BASIC_04")) {
    const selected = getSelectedCode(questions, "Q_BASIC_03", answers);
    if (!selected) return true;
    return selected !== "O_BASIC_03_A" && selected !== "서울";
  }

  // Q_EDU_02 (학교 구분): Q_EDU_01 = 학사/석사/박사일 때만 표시
  if (matchesCode(q, "Q_EDU_02")) {
    const code = getSelectedCode(questions, "Q_EDU_01", answers);
    if (!code) return true;
    return !["O_EDU_01_C", "O_EDU_01_D", "O_EDU_01_E",
             "대학교(학사)", "석사", "박사"].includes(code);
  }

  // Q_EDU_03 (학교 등급): Q_EDU_02 = 국내/해외일 때만 표시
  if (matchesCode(q, "Q_EDU_03")) {
    const edu01 = getSelectedCode(questions, "Q_EDU_01", answers);
    if (!edu01) return true;
    if (!["O_EDU_01_C", "O_EDU_01_D", "O_EDU_01_E",
          "대학교(학사)", "석사", "박사"].includes(edu01)) return true;
    const edu02 = getSelectedCode(questions, "Q_EDU_02", answers);
    if (!edu02) return true;
    return !["O_EDU_02_A", "O_EDU_02_B", "국내 대학", "해외 대학"].includes(edu02);
  }

  return false;
}

/* ── 이전/다음 인덱스 계산 ───────────────────────── */
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

/* ── Q_EDU_03 옵션 필터링 ────────────────────────── */
function getDisplayOptions(
  question: Question,
  questions: Question[],
  answers: Record<number, number>
): QuestionOption[] {
  if (!matchesCode(question, "Q_EDU_03")) return question.options;
  const edu02 = getSelectedCode(questions, "Q_EDU_02", answers);
  if (edu02 === "O_EDU_02_A" || edu02 === "국내 대학") {
    const filtered = question.options.filter(
      (o) => o.option_code ? DOMESTIC_CODES.has(o.option_code) : true
    );
    return filtered.length > 0 ? filtered : question.options;
  }
  if (edu02 === "O_EDU_02_B" || edu02 === "해외 대학") {
    const filtered = question.options.filter(
      (o) => o.option_code ? FOREIGN_CODES.has(o.option_code) : true
    );
    return filtered.length > 0 ? filtered : question.options;
  }
  return question.options;
}

/* ── 페이지 ─────────────────────────────────────── */
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

  const questions = [...(questionnaire?.questions ?? [])].sort(
    (a, b) => (a.display_order ?? 0) - (b.display_order ?? 0)
  );
  const total = questions.length;
  const currentQuestion = total ? questions[index] : null;
  const selectedOptionId = currentQuestion
    ? answers[currentQuestion.question_id] ?? null
    : null;
  const canGoNext = selectedOptionId !== null;
  const isLast = total > 0 && nextIdx(questions, index, answers) >= total;
  const isFinishing = saveAnswersMutation.isPending || completeMutation.isPending;

  const displayOptions = currentQuestion
    ? getDisplayOptions(currentQuestion, questions, answers)
    : [];

  function handleSelect(optionId: number) {
    if (!currentQuestion) return;
    const newAnswers = { ...answers, [currentQuestion.question_id]: optionId };

    // 분기 기준 질문 변경 시 → 이후 종속 답변 초기화
    const DEPENDENT_CODES: Record<string, string[]> = {
      Q_BASIC_03: ["Q_BASIC_04"],
      Q_EDU_01:   ["Q_EDU_02", "Q_EDU_03"],
      Q_EDU_02:   ["Q_EDU_03"],
    };
    const deps = DEPENDENT_CODES[currentQuestion.code] ?? [];
    deps.forEach((code) => {
      const dep = questions.find((q) => q.code === code);
      if (dep) delete newAnswers[dep.question_id];
    });

    setAnswers(newAnswers);
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
          <p className="text-sm text-zinc-600 dark:text-zinc-400">세션이 없습니다. 이동 중…</p>
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
            <p className="text-sm text-red-800 dark:text-red-200">문항을 불러올 수 없습니다.</p>
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
          <p className="text-sm text-zinc-600 dark:text-zinc-400">등록된 문항이 없습니다.</p>
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
      <main className="mx-auto w-full max-w-3xl px-6 py-16 pb-32">
        <header className="mb-8 flex flex-col gap-4">
          <div className="flex items-center justify-between">
            <p className="text-sm font-medium text-zinc-600 dark:text-zinc-400">
              {currentQuestion ? getStageLabel(currentQuestion.code) : "결혼 적합도 평가"}
            </p>
            <Link
              href="/"
              className="text-sm text-zinc-400 hover:text-zinc-900 dark:hover:text-zinc-100"
            >
              ← 홈으로
            </Link>
          </div>
          <div className="flex items-end justify-between gap-4">
            <div>
              <h1 className="text-3xl font-semibold tracking-tight">평가 문항</h1>
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
          question={{ ...currentQuestion!, options: displayOptions }}
          selectedOptionId={selectedOptionId}
          onSelectOption={handleSelect}
        />
      </main>

      {/* 하단 고정 네비게이션 */}
      <div className="fixed bottom-0 left-0 right-0 border-t border-zinc-200 bg-zinc-50/90 backdrop-blur-sm dark:border-zinc-800 dark:bg-black/90">
        <div className="mx-auto w-full max-w-3xl px-6 py-4">
          {(saveAnswersMutation.isError || completeMutation.isError) && (
            <p className="mb-2 text-center text-sm text-red-600 dark:text-red-400">
              {(saveAnswersMutation.error ?? completeMutation.error) instanceof Error
                ? ((saveAnswersMutation.error ?? completeMutation.error) as Error).message
                : "오류가 발생했습니다."}
            </p>
          )}
          <div className="flex items-center justify-between gap-4">
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
        </div>
      </div>
    </div>
  );
}
