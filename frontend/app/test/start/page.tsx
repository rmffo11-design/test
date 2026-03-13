"use client";

import { useMutation, useQuery } from "@tanstack/react-query";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createSession, getCurrentQuestionnaire, SESSION_STORAGE_KEY } from "@/lib/api";

export default function TestStartPage() {
  const router = useRouter();
  const { data: questionnaire, isLoading, error } = useQuery({
    queryKey: ["questionnaire", "current"],
    queryFn: getCurrentQuestionnaire,
  });

  const startMutation = useMutation({
    mutationFn: () =>
      createSession({
        questionnaire_id: questionnaire!.questionnaire_id,
        locale: "ko-KR",
      }),
    onSuccess: (data) => {
      if (typeof window !== "undefined") {
        window.sessionStorage.setItem(SESSION_STORAGE_KEY, data.session_id);
      }
      router.push("/test/questions");
    },
  });

  return (
    <div className="min-h-screen bg-zinc-50 text-zinc-900 dark:bg-black dark:text-zinc-50">
      <main className="mx-auto w-full max-w-lg px-6 py-16">

        <Link
          href="/"
          className="mb-8 inline-flex items-center gap-1.5 text-sm text-zinc-500 hover:text-zinc-900 dark:hover:text-zinc-100"
        >
          ← 홈으로
        </Link>

        <h1 className="mt-4 text-3xl font-bold tracking-tight">테스트 시작</h1>
        <p className="mt-3 text-sm leading-7 text-zinc-500 dark:text-zinc-400">
          아래 버튼을 누르면 바로 시작됩니다.<br />
          총 6문항이며 약 3분이 소요됩니다.
        </p>

        <div className="mt-8">
          {isLoading && (
            <p className="text-sm text-zinc-500">설문 불러오는 중…</p>
          )}

          {error && (
            <div className="rounded-2xl border border-red-200 bg-red-50 p-4 dark:border-red-900 dark:bg-red-950">
              <p className="text-sm font-medium text-red-800 dark:text-red-200">설문을 불러올 수 없습니다.</p>
              <p className="mt-1 text-xs text-red-600 dark:text-red-400">{(error as Error).message}</p>
            </div>
          )}

          {questionnaire && !error && (
            <div className="flex flex-col gap-4">
              <div className="rounded-2xl border border-zinc-200 bg-white p-5 dark:border-zinc-800 dark:bg-zinc-950">
                <p className="text-xs font-medium text-zinc-400">현재 설문</p>
                <p className="mt-1 text-base font-semibold">결혼 적합도 평가</p>
                <p className="mt-1 text-sm text-zinc-500 dark:text-zinc-400">총 {questionnaire.questions.length}문항</p>
              </div>

              <button
                type="button"
                onClick={() => startMutation.mutate()}
                disabled={startMutation.isPending}
                className="w-full rounded-full bg-zinc-900 py-4 text-base font-semibold text-white shadow-md transition hover:bg-zinc-700 disabled:opacity-50 active:scale-95 dark:bg-white dark:text-black dark:hover:bg-zinc-200"
              >
                {startMutation.isPending ? "시작 중…" : "테스트 시작하기 →"}
              </button>

              {startMutation.isError && (
                <p className="text-center text-sm text-red-600 dark:text-red-400">
                  {(startMutation.error as Error).message}
                </p>
              )}
            </div>
          )}
        </div>

      </main>
    </div>
  );
}
