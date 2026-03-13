from typing import List

from pydantic import BaseModel


class AnswerInputSchema(BaseModel):
    question_id: int
    option_id: int | None = None


class TestSessionCreateSchema(BaseModel):
    questionnaire_id: int
    # user_id, locale 등을 필요시 확장 가능


class TestResultSchema(BaseModel):
    total_score: float
    grade: str
    metric_scores: dict[str, float]
    result_token: str

