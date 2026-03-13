from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from sqlalchemy.orm import Session

from .database import SessionLocal
from .repositories import AnswerRepository, TestSessionRepository
from .scoring_service import ScoringService
from .models import TestResult


router = APIRouter(prefix="/test-sessions", tags=["test-sessions"])


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


class TestSessionCreateRequest(BaseModel):
    questionnaire_id: int
    locale: str


class TestSessionCreateResponse(BaseModel):
    session_id: str


@router.post("", response_model=TestSessionCreateResponse)
def create_test_session(
    payload: TestSessionCreateRequest,
    db: Session = Depends(get_db),
):
    repo = TestSessionRepository(db)
    session = repo.create_session(
        questionnaire_id=payload.questionnaire_id,
        locale=payload.locale,
    )
    return TestSessionCreateResponse(session_id=session.session_id)


class AnswerIn(BaseModel):
    question_id: int
    option_id: int | None = None


class SaveAnswersRequest(BaseModel):
    answers: list[AnswerIn]


@router.put("/{session_id}/answers")
def save_test_answers(
    session_id: str,
    payload: SaveAnswersRequest,
    db: Session = Depends(get_db),
):
    session_repo = TestSessionRepository(db)
    session = session_repo.get_session(session_id)
    if not session:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Session not found.",
        )

    answer_repo = AnswerRepository(db)
    from .models import TestAnswer  # local import to avoid circulars if any

    answers = [
        TestAnswer(
            session_id=session_id,
            question_id=a.question_id,
            option_id=a.option_id,
        )
        for a in payload.answers
    ]

    answer_repo.save_answers(answers)
    return {"saved": len(answers)}


class CompleteSessionResponse(BaseModel):
    total_score: float
    grade: str
    metric_scores: dict[int, float]
    result_token: str


@router.post("/{session_id}/complete", response_model=CompleteSessionResponse)
def complete_test_session(
    session_id: str,
    db: Session = Depends(get_db),
):
    session_repo = TestSessionRepository(db)
    session = session_repo.get_session(session_id)
    if not session:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Session not found.",
        )

    scoring = ScoringService(db)
    result_data = scoring.calculate_score(session_id)

    # Mark session as completed
    session_repo.complete_session(session_id)

    # Fetch result to get token
    test_result = (
        db.query(TestResult)
        .filter(TestResult.session_id == session_id)
        .one()
    )

    return CompleteSessionResponse(
        total_score=result_data["total_score"],
        grade=result_data["grade"],
        metric_scores=result_data["metric_scores"],
        result_token=test_result.result_token,
    )

