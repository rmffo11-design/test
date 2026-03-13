from typing import Iterable, List

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models import TestAnswer


class AnswerRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def save_answers(self, answers: Iterable[TestAnswer]) -> List[TestAnswer]:
        answers = list(answers)
        if not answers:
            return []
        self.db.add_all(answers)
        await self.db.commit()
        for a in answers:
            await self.db.refresh(a)
        return answers

    async def get_answers_by_session(self, session_id: str) -> List[TestAnswer]:
        res = await self.db.execute(
            select(TestAnswer)
            .where(TestAnswer.session_id == session_id)
            .order_by(TestAnswer.created_at.asc(), TestAnswer.answer_id.asc())
        )
        return list(res.scalars())

