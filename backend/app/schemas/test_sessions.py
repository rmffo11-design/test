from typing import List

from pydantic import BaseModel


class AnswerInputSchema(BaseModel):
    question_id: int
    option_id: int | None = None


class AnswerBatchSchema(BaseModel):
    answers: List[AnswerInputSchema]


class TestSessionCreateSchema(BaseModel):
    questionnaire_id: int
    locale: str = "ko-KR"


class TestResultSchema(BaseModel):
    total_score: float
    grade: str
    metric_scores: dict[str, float]
    result_token: str

