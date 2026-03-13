import Link from "next/link";

type PageProps = {
  params: Promise<{ token: string }>;
};

export default async function TestResultPage({ params }: PageProps) {
  const { token } = await params;

  return (
    <div className="min-h-screen bg-zinc-50 text-zinc-900 dark:bg-black dark:text-zinc-50">
      <main className="mx-auto w-full max-w-3xl px-6 py-16">
        <header className="mb-8">
          <p className="text-sm font-medium text-zinc-600 dark:text-zinc-400">
            /test/result/[token]
          </p>
          <h1 className="mt-2 text-3xl font-semibold tracking-tight">Result</h1>
          <p className="mt-3 text-sm leading-6 text-zinc-600 dark:text-zinc-400">
            Placeholder UI. Token:{" "}
            <code className="rounded bg-zinc-200 px-1 py-0.5 text-zinc-900 dark:bg-zinc-800 dark:text-zinc-100">
              {token}
            </code>
          </p>
        </header>

        <section className="rounded-2xl border border-zinc-200 bg-white p-5 dark:border-zinc-800 dark:bg-zinc-950">
          <div className="text-sm font-medium">API call</div>
          <p className="mt-2 text-sm text-zinc-700 dark:text-zinc-300">
            Fetch result via{" "}
            <code>GET /results/{`{result_token}`}</code> and render:
          </p>
          <ul className="mt-3 list-disc space-y-2 pl-5 text-sm text-zinc-700 dark:text-zinc-300">
            <li>
              <code>total_score</code>
            </li>
            <li>
              <code>grade</code>
            </li>
            <li>
              <code>metric_scores</code>
            </li>
          </ul>
        </section>

        <div className="mt-8 flex gap-3">
          <Link
            href="/test/questions"
            className="rounded-full border border-zinc-300 px-4 py-2 text-sm hover:bg-zinc-100 dark:border-zinc-700 dark:hover:bg-zinc-900"
          >
            Back
          </Link>
          <Link
            href="/"
            className="rounded-full bg-zinc-900 px-4 py-2 text-sm text-white hover:bg-zinc-800 dark:bg-white dark:text-black dark:hover:bg-zinc-200"
          >
            Home
          </Link>
        </div>
      </main>
    </div>
  );
}

