import Link from "next/link";

export default function Home() {
  return (
    <div className="min-h-screen bg-zinc-50 text-zinc-900 dark:bg-black dark:text-zinc-50">
      <main className="mx-auto flex w-full max-w-5xl flex-col gap-10 px-6 py-16">
        <header className="flex flex-col gap-4">
          <p className="text-sm font-medium text-zinc-600 dark:text-zinc-400">
            Questionnaire Test
          </p>
          <h1 className="text-balance text-4xl font-semibold leading-tight tracking-tight sm:text-5xl">
            Start a test session and get your result token.
          </h1>
          <p className="max-w-2xl text-pretty text-lg leading-7 text-zinc-600 dark:text-zinc-400">
            This is a simple landing page. You can start a test session, answer
            questions, then complete the session to generate a scored result.
          </p>
        </header>

        <section className="grid gap-4 sm:grid-cols-3">
          <Link
            href="/test/start"
            className="rounded-2xl border border-zinc-200 bg-white p-5 transition hover:bg-zinc-50 dark:border-zinc-800 dark:bg-zinc-950 dark:hover:bg-zinc-900"
          >
            <div className="text-sm font-medium text-zinc-600 dark:text-zinc-400">
              Step 1
            </div>
            <div className="mt-2 text-lg font-semibold">Start</div>
            <div className="mt-1 text-sm text-zinc-600 dark:text-zinc-400">
              Create a new test session.
            </div>
          </Link>

          <Link
            href="/test/questions"
            className="rounded-2xl border border-zinc-200 bg-white p-5 transition hover:bg-zinc-50 dark:border-zinc-800 dark:bg-zinc-950 dark:hover:bg-zinc-900"
          >
            <div className="text-sm font-medium text-zinc-600 dark:text-zinc-400">
              Step 2
            </div>
            <div className="mt-2 text-lg font-semibold">Questions</div>
            <div className="mt-1 text-sm text-zinc-600 dark:text-zinc-400">
              Answer questions in your session.
            </div>
          </Link>

          <Link
            href="/test/result/demo-token"
            className="rounded-2xl border border-zinc-200 bg-white p-5 transition hover:bg-zinc-50 dark:border-zinc-800 dark:bg-zinc-950 dark:hover:bg-zinc-900"
          >
            <div className="text-sm font-medium text-zinc-600 dark:text-zinc-400">
              Step 3
            </div>
            <div className="mt-2 text-lg font-semibold">Result</div>
            <div className="mt-1 text-sm text-zinc-600 dark:text-zinc-400">
              View result by token.
            </div>
          </Link>
        </section>

        <footer className="text-xs text-zinc-500">
          Routes: <code>/</code>, <code>/test/start</code>,{" "}
          <code>/test/questions</code>, <code>/test/result/[token]</code>
        </footer>
      </main>
    </div>
  );
}
