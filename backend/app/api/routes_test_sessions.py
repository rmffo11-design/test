from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_db
from app.models import TestAnswer
from app.repositories.answers import AnswerRepository
from app.repositories.sessions import SessionRepository
from app.schemas.test_sessions import (
    AnswerInputSchema,
    TestResultSchema,
    TestSessionCreateSchema,
)
from app.services.scoring_service import ScoringService


router = APIRouter(prefix="/test-sessions", tags=["test-sessions"])


@router.post("", response_model=dict)
async def create_test_session(
    payload: TestSessionCreateSchema,
    db: AsyncSession = Depends(get_db),
):
    repo = SessionRepository(db)
    session = await repo.create_session(questionnaire_id=payload.questionnaire_id)
    return {"session_id": str(session.session_id)}


@router.put("/{session_id}/answers")
async def save_test_answers(
    session_id: str,
    answers: list[AnswerInputSchema],
    db: AsyncSession = Depends(get_db),
):
    session_repo = SessionRepository(db)
    session = await session_repo.get_session(session_id)
    if not session:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Session not found.",
        )

    answer_repo = AnswerRepository(db)
    models = [
        TestAnswer(
            session_id=session_id,
            question_id=a.question_id,
            option_id=a.option_id,
        )
        for a in answers
    ]
    await answer_repo.save_answers(models)
    return {"saved": len(models)}


@router.post("/{session_id}/complete", response_model=TestResultSchema)
async def complete_test_session(
    session_id: str,
    db: AsyncSession = Depends(get_db),
):
    session_repo = SessionRepository(db)
    session = await session_repo.get_session(session_id)
    if not session:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Session not found.",
        )

    scoring = ScoringService(db)
    result_data = await scoring.calculate_score(session_id)

    await session_repo.complete_session(session_id)

    return TestResultSchema(
        total_score=result_data["total_score"],
        grade=result_data["grade"],
        metric_scores=result_data["metric_scores"],
        result_token="",  # routes_results에서 실제 토큰 제공
    )

