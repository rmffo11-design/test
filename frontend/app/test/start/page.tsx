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
    mutationFn: (locale: string) =>
      createSession({
        questionnaire_id: questionnaire!.questionnaire_id,
        locale,
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
      <main className="mx-auto w-full max-w-3xl px-6 py-16">
        <header className="mb-8">
          <p className="text-sm font-medium text-zinc-600 dark:text-zinc-400">
            /test/start
          </p>
          <h1 className="mt-2 text-3xl font-semibold tracking-tight">
            Start a test session
          </h1>
          <p className="mt-3 text-sm leading-6 text-zinc-600 dark:text-zinc-400">
            Start a session for the current questionnaire. You will be taken to
            the questions page.
          </p>
        </header>

        {isLoading && (
          <p className="text-sm text-zinc-600 dark:text-zinc-400">
            Loading questionnaire…
          </p>
        )}
        {error && (
          <div className="rounded-2xl border border-red-200 bg-red-50 p-4 dark:border-red-900 dark:bg-red-950">
            <p className="text-sm text-red-800 dark:text-red-200">
              Failed to load questionnaire. Is the API running?
            </p>
            <p className="mt-1 text-xs text-red-600 dark:text-red-400">
              {(error as Error).message}
            </p>
          </div>
        )}
        {questionnaire && !error && (
          <section className="rounded-2xl border border-zinc-200 bg-white p-5 dark:border-zinc-800 dark:bg-zinc-950">
            <div className="text-sm font-medium text-zinc-600 dark:text-zinc-400">
              Questionnaire v{questionnaire.version_no} (ID:{" "}
              {questionnaire.questionnaire_id})
            </div>
            <p className="mt-2 text-sm text-zinc-700 dark:text-zinc-300">
              {questionnaire.questions.length} questions
            </p>
            <div className="mt-4 flex flex-wrap gap-3">
              <button
                type="button"
                onClick={() => startMutation.mutate("en")}
                disabled={startMutation.isPending}
                className="rounded-full bg-zinc-900 px-4 py-2 text-sm font-medium text-white hover:bg-zinc-800 disabled:opacity-50 dark:bg-white dark:text-black dark:hover:bg-zinc-200"
              >
                {startMutation.isPending ? "Starting…" : "Start (English)"}
              </button>
              <button
                type="button"
                onClick={() => startMutation.mutate("ko-KR")}
                disabled={startMutation.isPending}
                className="rounded-full border border-zinc-300 px-4 py-2 text-sm font-medium hover:bg-zinc-100 dark:border-zinc-700 dark:hover:bg-zinc-900"
              >
                {startMutation.isPending ? "Starting…" : "Start (한국어)"}
              </button>
            </div>
            {startMutation.isError && (
              <p className="mt-3 text-sm text-red-600 dark:text-red-400">
                {(startMutation.error as Error).message}
              </p>
            )}
          </section>
        )}

        <div className="mt-8 flex gap-3">
          <Link
            href="/"
            className="rounded-full border border-zinc-300 px-4 py-2 text-sm hover:bg-zinc-100 dark:border-zinc-700 dark:hover:bg-zinc-900"
          >
            Back
          </Link>
        </div>
      </main>
    </div>
  );
}

