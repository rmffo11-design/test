from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_db
from app.models import TestResult
from app.schemas.test_sessions import TestResultSchema
from app.services.scoring_service import ScoringService


router = APIRouter(prefix="/results", tags=["results"])


@router.get("/{result_token}", response_model=TestResultSchema)
async def get_result_by_token(
    result_token: str,
    db: AsyncSession = Depends(get_db),
):
    res = await db.execute(
        select(TestResult).where(TestResult.result_token == result_token)
    )
    test_result = res.scalars().first()
    if not test_result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Result not found.",
        )

    scoring = ScoringService(db)
    data = await scoring.calculate_score(str(test_result.session_id))

    return TestResultSchema(
        total_score=data["total_score"],
        grade=data["grade"],
        metric_scores=data["metric_scores"],
        result_token=str(test_result.result_token),
    )

