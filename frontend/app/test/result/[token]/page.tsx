"use client";

import { useQuery } from "@tanstack/react-query";
import Link from "next/link";
import { use } from "react";
import { getResult } from "@/lib/api";

const GRADE_LABEL: Record<string, string> = {
  VVIP: "VVIP",
  VIP: "VIP",
  Premium: "Premium",
  Standard: "Standard",
  Basic: "Basic",
};

const GRADE_DESC: Record<string, string> = {
  VVIP: "최상위 매력도를 보유한 예비 배우자입니다. (상위 1%)",
  VIP: "높은 경쟁력을 갖춘 결혼 적합 파트너입니다.",
  Premium: "평균 이상의 조건을 갖추고 있습니다.",
  Standard: "기본적인 결혼 조건을 충족합니다.",
  Basic: "전반적인 개선이 필요한 상태입니다.",
};

const METRIC_NAME: Record<string, string> = {
  appearance: "외모",
  education: "학력",
  job: "직업",
  income: "소득",
  asset: "자산",
  family: "가족배경",
  personality: "성격",
  lifestyle: "라이프스타일",
};

const GRADE_COLOR: Record<string, string> = {
  VVIP: "text-amber-500 dark:text-amber-400",
  VIP: "text-yellow-600 dark:text-yellow-400",
  Premium: "text-purple-600 dark:text-purple-400",
  Standard: "text-blue-600 dark:text-blue-400",
  Basic: "text-zinc-600 dark:text-zinc-400",
};

type PageProps = { params: Promise<{ token: string }> };

export default function TestResultPage({ params }: PageProps) {
  const { token } = use(params);

  const { data, isLoading, error } = useQuery({
    queryKey: ["result", token],
    queryFn: () => getResult(token),
    retry: false,
  });

  function handleShare() {
    const url = window.location.href;
    if (navigator.share) {
      navigator.share({ title: "내 결혼 적합도 결과", url });
    } else {
      navigator.clipboard.writeText(url).then(() => alert("링크가 복사되었습니다."));
    }
  }

  return (
    <div className="min-h-screen bg-zinc-50 text-zinc-900 dark:bg-black dark:text-zinc-50">
      <main className="mx-auto w-full max-w-3xl px-6 py-16">
        <header className="mb-8">
          <p className="text-sm font-medium text-zinc-600 dark:text-zinc-400">
            결과
          </p>
          <h1 className="mt-2 text-3xl font-semibold tracking-tight">
            평가 결과
          </h1>
        </header>

        {isLoading && (
          <p className="text-sm text-zinc-600 dark:text-zinc-400">
            결과를 불러오는 중…
          </p>
        )}

        {error && (
          <div className="rounded-2xl border border-red-200 bg-red-50 p-4 dark:border-red-900 dark:bg-red-950">
            <p className="text-sm text-red-800 dark:text-red-200">
              결과를 불러올 수 없습니다.
            </p>
            <p className="mt-1 text-xs text-red-600 dark:text-red-400">
              {(error as Error).message}
            </p>
          </div>
        )}

        {data && (
          <div className="flex flex-col gap-6">
            <section className="rounded-3xl border border-zinc-200 bg-white p-8 dark:border-zinc-800 dark:bg-zinc-950">
              <div className="flex items-end justify-between gap-4">
                <div>
                  <p className="text-sm text-zinc-600 dark:text-zinc-400">총점</p>
                  <p className="mt-1 text-5xl font-bold tracking-tight">
                    {data.total_score.toFixed(1)}
                  </p>
                </div>
                <div className="text-right">
                  <p className="text-sm text-zinc-600 dark:text-zinc-400">등급</p>
                  <p
                    className={`mt-1 text-3xl font-bold ${
                      GRADE_COLOR[data.grade] ?? "text-zinc-900"
                    }`}
                  >
                    {GRADE_LABEL[data.grade] ?? data.grade}
                  </p>
                  <p className="mt-1 text-xs text-zinc-500 dark:text-zinc-400">
                    {GRADE_DESC[data.grade]}
                  </p>
                </div>
              </div>
            </section>

            {Object.keys(data.metric_scores).length > 0 && (
              <section className="rounded-3xl border border-zinc-200 bg-white p-6 dark:border-zinc-800 dark:bg-zinc-950">
                <p className="mb-4 text-sm font-medium text-zinc-600 dark:text-zinc-400">
                  항목별 점수
                </p>
                <div className="flex flex-col gap-3">
                  {Object.entries(data.metric_scores).map(([metricId, score]) => (
                    <div
                      key={metricId}
                      className="flex items-center justify-between gap-4"
                    >
                      <span className="text-sm text-zinc-700 dark:text-zinc-300">
                        {METRIC_NAME[metricId] ?? metricId}
                      </span>
                      <span className="text-sm font-semibold">
                        {(score as number).toFixed(1)}
                      </span>
                    </div>
                  ))}
                </div>
              </section>
            )}

            <button
              type="button"
              onClick={handleShare}
              className="w-full rounded-2xl border border-zinc-300 py-3 text-sm font-medium hover:bg-zinc-100 dark:border-zinc-700 dark:hover:bg-zinc-900"
            >
              결과 공유하기
            </button>
          </div>
        )}

        <div className="mt-8 flex gap-3">
          <Link
            href="/"
            className="rounded-full bg-zinc-900 px-4 py-2 text-sm text-white hover:bg-zinc-800 dark:bg-white dark:text-black dark:hover:bg-zinc-200"
          >
            홈으로
          </Link>
          <Link
            href="/test/start"
            className="rounded-full border border-zinc-300 px-4 py-2 text-sm hover:bg-zinc-100 dark:border-zinc-700 dark:hover:bg-zinc-900"
          >
            다시 시작
          </Link>
        </div>
      </main>
    </div>
  );
}
