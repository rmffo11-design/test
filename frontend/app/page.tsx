import Link from "next/link";

const GRADE_EXAMPLES = [
  {
    grade: "VVIP",
    score: "90+",
    color: "border-amber-300 bg-amber-50 dark:border-amber-800 dark:bg-amber-950",
    badge: "bg-amber-400 text-amber-900",
    desc: "최상위 매력도를 보유한 예비 배우자입니다. (상위 1%)",
  },
  {
    grade: "VIP",
    score: "75+",
    color: "border-yellow-300 bg-yellow-50 dark:border-yellow-800 dark:bg-yellow-950",
    badge: "bg-yellow-400 text-yellow-900",
    desc: "높은 경쟁력을 갖춘 결혼 적합 파트너입니다.",
  },
  {
    grade: "Premium",
    score: "60+",
    color: "border-purple-300 bg-purple-50 dark:border-purple-800 dark:bg-purple-950",
    badge: "bg-purple-500 text-white",
    desc: "평균 이상의 조건을 갖추고 있습니다.",
  },
  {
    grade: "Standard",
    score: "45+",
    color: "border-blue-200 bg-blue-50 dark:border-blue-900 dark:bg-blue-950",
    badge: "bg-blue-500 text-white",
    desc: "기본적인 결혼 조건을 충족합니다.",
  },
  {
    grade: "Basic",
    score: "~44",
    color: "border-zinc-300 bg-zinc-50 dark:border-zinc-700 dark:bg-zinc-900",
    badge: "bg-zinc-500 text-white",
    desc: "전반적인 개선이 필요한 상태입니다.",
  },
];

const METRICS = [
  { label: "외모", icon: "✨" },
  { label: "학력", icon: "🎓" },
  { label: "직업", icon: "💼" },
  { label: "소득", icon: "💰" },
  { label: "자산", icon: "🏠" },
  { label: "가족배경", icon: "👨‍👩‍👧" },
  { label: "성격", icon: "💛" },
  { label: "라이프스타일", icon: "🌿" },
];

export default function Home() {
  return (
    <div className="min-h-screen bg-zinc-50 text-zinc-900 dark:bg-black dark:text-zinc-50">

      {/* ── HERO ── */}
      <section className="mx-auto flex w-full max-w-4xl flex-col items-center gap-6 px-6 pb-12 pt-20 text-center">
        <span className="inline-block rounded-full border border-zinc-300 bg-white px-4 py-1 text-xs font-medium tracking-widest text-zinc-500 dark:border-zinc-700 dark:bg-zinc-950 dark:text-zinc-400">
          결혼 적합도 평가 플랫폼
        </span>

        <h1 className="text-balance text-4xl font-bold leading-tight tracking-tight sm:text-5xl lg:text-6xl">
          나는 결혼 상대로<br className="hidden sm:block" /> 얼마나 매력적일까?
        </h1>

        <p className="max-w-xl text-pretty text-lg leading-8 text-zinc-500 dark:text-zinc-400">
          외모·학력·직업·소득·자산·가족배경·성격·라이프스타일
          8가지 핵심 지표를 기반으로 당신의 결혼 시장 경쟁력을 객관적으로 평가합니다.
          <br />
          34개 문항 · 약 5분 소요
        </p>

        {/* CTA */}
        <div className="mt-2 flex flex-col items-center gap-3 sm:flex-row">
          <Link
            href="/test/start"
            className="rounded-full bg-zinc-900 px-8 py-3.5 text-base font-semibold text-white shadow-md transition hover:bg-zinc-700 active:scale-95 dark:bg-white dark:text-black dark:hover:bg-zinc-200"
          >
            지금 무료로 시작하기 →
          </Link>
          <span className="text-sm text-zinc-400">로그인 없이 즉시 이용 가능</span>
        </div>
      </section>

      {/* ── 평가 항목 ── */}
      <section className="mx-auto w-full max-w-4xl px-6 pb-16">
        <p className="mb-5 text-center text-sm font-medium text-zinc-500 dark:text-zinc-400">
          6가지 평가 항목
        </p>
        <div className="grid grid-cols-4 gap-3 sm:grid-cols-8">
          {METRICS.map((m) => (
            <div
              key={m.label}
              className="flex flex-col items-center gap-2 rounded-2xl border border-zinc-200 bg-white py-4 dark:border-zinc-800 dark:bg-zinc-950"
            >
              <span className="text-2xl">{m.icon}</span>
              <span className="text-xs font-medium">{m.label}</span>
            </div>
          ))}
        </div>
      </section>

      {/* ── HOW IT WORKS ── */}
      <section className="border-y border-zinc-200 bg-white py-16 dark:border-zinc-800 dark:bg-zinc-950">
        <div className="mx-auto flex w-full max-w-4xl flex-col gap-8 px-6">
          <p className="text-center text-sm font-medium text-zinc-500 dark:text-zinc-400">
            이용 방법
          </p>
          <div className="grid gap-6 sm:grid-cols-3">
            {[
              { step: "01", title: "테스트 시작", desc: "버튼 하나로 즉시 세션을 생성합니다. 회원가입 불필요." },
              { step: "02", title: "6문항 답변", desc: "각 항목별 1문항씩, 솔직하게 선택해 주세요." },
              { step: "03", title: "결과 확인", desc: "총점·등급·항목별 점수를 즉시 확인하고 링크로 공유하세요." },
            ].map((item) => (
              <div key={item.step} className="flex flex-col gap-3">
                <span className="text-3xl font-bold text-zinc-200 dark:text-zinc-700">
                  {item.step}
                </span>
                <h3 className="text-base font-semibold">{item.title}</h3>
                <p className="text-sm leading-6 text-zinc-500 dark:text-zinc-400">{item.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── 결과 예시 ── */}
      <section className="mx-auto w-full max-w-4xl px-6 py-16">
        <div className="mb-8 text-center">
          <p className="text-sm font-medium text-zinc-500 dark:text-zinc-400">결과 예시</p>
          <h2 className="mt-2 text-2xl font-bold tracking-tight">
            어떤 결과를 받을 수 있나요?
          </h2>
          <p className="mt-2 text-sm text-zinc-500 dark:text-zinc-400">
            총점에 따라 5단계 등급으로 평가됩니다
          </p>
        </div>

        <div className="flex flex-col gap-3">
          {GRADE_EXAMPLES.map((g) => (
            <div
              key={g.grade}
              className={`flex items-center gap-4 rounded-2xl border p-4 ${g.color}`}
            >
              <span
                className={`shrink-0 rounded-xl px-3 py-1.5 text-sm font-bold ${g.badge}`}
              >
                {g.grade}
              </span>
              <div className="flex min-w-0 flex-1 items-center justify-between gap-4">
                <p className="truncate text-sm">{g.desc}</p>
                <span className="shrink-0 text-lg font-bold">{g.score}점</span>
              </div>
            </div>
          ))}
        </div>

        <div className="mt-6 text-center text-xs text-zinc-400">
          ※ 예시 점수이며 실제 결과는 답변에 따라 달라집니다.
        </div>
      </section>

      {/* ── BOTTOM CTA ── */}
      <section className="border-t border-zinc-200 bg-zinc-900 py-16 text-center dark:border-zinc-800 dark:bg-zinc-950">
        <p className="text-sm text-zinc-400">지금 바로 확인해보세요</p>
        <h2 className="mt-3 text-2xl font-bold text-white">
          나의 결혼 적합도 점수는?
        </h2>
        <Link
          href="/test/start"
          className="mt-6 inline-block rounded-full bg-white px-8 py-3.5 text-base font-semibold text-zinc-900 shadow transition hover:bg-zinc-100 active:scale-95"
        >
          무료 테스트 시작하기
        </Link>
      </section>

    </div>
  );
}
