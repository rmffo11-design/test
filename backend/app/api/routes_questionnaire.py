from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_db
from app.repositories.questionnaire import QuestionnaireRepository
from app.schemas.questionnaire import QuestionnaireResponseSchema


router = APIRouter(prefix="/questionnaires", tags=["questionnaires"])


@router.get("/current", response_model=QuestionnaireResponseSchema)
async def get_current_questionnaire(db: AsyncSession = Depends(get_db)):
    repo = QuestionnaireRepository(db)
    questionnaire = await repo.get_current_questionnaire()
    if not questionnaire:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No published questionnaire found.",
        )
    return questionnaire


@router.get("/{questionnaire_id}", response_model=QuestionnaireResponseSchema)
async def get_questionnaire_by_id(
    questionnaire_id: int,
    db: AsyncSession = Depends(get_db),
):
    repo = QuestionnaireRepository(db)
    questionnaire = await repo.get_questionnaire_with_questions(questionnaire_id)
    if not questionnaire:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Questionnaire not found.",
        )
    return questionnaire

