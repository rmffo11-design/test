from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from .database import SessionLocal
from .repositories import QuestionnaireRepository
from .schemas import QuestionnaireResponse


router = APIRouter(prefix="/questionnaires", tags=["questionnaires"])


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.get("/current", response_model=QuestionnaireResponse)
def get_current_questionnaire(db: Session = Depends(get_db)):
    repo = QuestionnaireRepository(db)
    current = repo.get_current_questionnaire()
    if not current:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No published questionnaire found.",
        )
    questionnaire = repo.get_questionnaire_with_questions(current.questionnaire_id)
    return questionnaire


@router.get("/{questionnaire_id}", response_model=QuestionnaireResponse)
def get_questionnaire_by_id(
    questionnaire_id: int,
    db: Session = Depends(get_db),
):
    repo = QuestionnaireRepository(db)
    questionnaire = repo.get_questionnaire_with_questions(questionnaire_id)
    if not questionnaire:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Questionnaire not found.",
        )
    return questionnaire

