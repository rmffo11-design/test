from typing import Optional

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import joinedload

from app.models import Questionnaire, Question


class QuestionnaireRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_current_questionnaire(self) -> Optional[Questionnaire]:
        # 단일 쿼리로 questions + options 함께 로드 (2번 → 1번)
        stmt = (
            select(Questionnaire)
            .options(
                joinedload(Questionnaire.questions)
                .joinedload(Question.options)
            )
            .where(Questionnaire.is_published.is_(True))
            .order_by(Questionnaire.version_no.desc())
            .limit(1)
        )
        res = await self.db.execute(stmt)
        return res.unique().scalars().first()

    async def get_questionnaire_with_questions(
        self, questionnaire_id: int
    ) -> Optional[Questionnaire]:
        stmt = (
            select(Questionnaire)
            .options(
                joinedload(Questionnaire.questions)
                .joinedload(Question.options)
            )
            .where(Questionnaire.questionnaire_id == questionnaire_id)
        )
        res = await self.db.execute(stmt)
        return res.unique().scalars().first()
