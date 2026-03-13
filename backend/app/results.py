from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from sqlalchemy.orm import Session

from .database import SessionLocal
from .models import TestResult
from .scoring_service import ScoringService


router = APIRouter(prefix="/results", tags=["results"])


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


class ResultResponse(BaseModel):
    total_score: float
    grade: str
    metric_scores: dict[int, float]
    result_token: str


@router.get("/{result_token}", response_model=ResultResponse)
def get_result_by_token(result_token: str, db: Session = Depends(get_db)):
    test_result = (
        db.query(TestResult)
        .filter(TestResult.result_token == result_token)
        .one_or_none()
    )
    if not test_result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Result not found.",
        )

    scoring = ScoringService(db)
    result_data = scoring.calculate_score(test_result.session_id)

    return ResultResponse(
        total_score=result_data["total_score"],
        grade=result_data["grade"],
        metric_scores=result_data["metric_scores"],
        result_token=test_result.result_token,
    )

