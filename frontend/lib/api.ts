export const SESSION_STORAGE_KEY = "questionnaire_session_id";

const getBaseUrl = () =>
  typeof window !== "undefined"
    ? process.env.NEXT_PUBLIC_API_URL || ""
    : process.env.NEXT_PUBLIC_API_URL || "http://127.0.0.1:8000";

export async function fetchApi<T>(
  path: string,
  init?: RequestInit
): Promise<T> {
  const base = getBaseUrl().replace(/\/$/, "");
  const url = path.startsWith("http") ? path : `${base}${path.startsWith("/") ? path : `/${path}`}`;
  const res = await fetch(url, {
    ...init,
    headers: {
      "Content-Type": "application/json",
      ...init?.headers,
    },
  });
  if (!res.ok) {
    const text = await res.text();
    throw new Error(text || `HTTP ${res.status}`);
  }
  return res.json() as Promise<T>;
}

export type QuestionOption = { option_id: number; option_text: string };
export type Question = {
  question_id: number;
  question_text: string;
  options: QuestionOption[];
};
export type QuestionnaireResponse = {
  questionnaire_id: number;
  version_no: number;
  questions: Question[];
};

export type CreateSessionRequest = { questionnaire_id: number; locale: string };
export type CreateSessionResponse = { session_id: string };

export type AnswerIn = { question_id: number; option_id: number | null };
export type SaveAnswersRequest = { answers: AnswerIn[] };

export type CompleteSessionResponse = {
  total_score: number;
  grade: string;
  metric_scores: Record<string, number>;
  result_token: string;
};

export type TestResult = {
  total_score: number;
  grade: string;
  metric_scores: Record<string, number>;
  result_token: string;
};

export function getCurrentQuestionnaire() {
  return fetchApi<QuestionnaireResponse>("/questionnaires/current");
}

export function getQuestionnaire(id: number) {
  return fetchApi<QuestionnaireResponse>(`/questionnaires/${id}`);
}

export function createSession(body: CreateSessionRequest) {
  return fetchApi<CreateSessionResponse>("/test-sessions", {
    method: "POST",
    body: JSON.stringify(body),
  });
}

export function saveAnswers(sessionId: string, body: SaveAnswersRequest) {
  return fetchApi<{ saved: number }>(`/test-sessions/${sessionId}/answers`, {
    method: "PUT",
    body: JSON.stringify(body),
  });
}

export function completeSession(sessionId: string) {
  return fetchApi<CompleteSessionResponse>(
    `/test-sessions/${sessionId}/complete`,
    { method: "POST" }
  );
}

export function getResult(token: string) {
  return fetchApi<TestResult>(`/results/${token}`);
}
