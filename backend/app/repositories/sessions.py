from typing import Optional

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models import TestSession


class SessionRepository:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def create_session(self, questionnaire_id: int) -> TestSession:
        session = TestSession(questionnaire_id=questionnaire_id)
        self.db.add(session)
        await self.db.commit()
        await self.db.refresh(session)
        return session

    async def get_session(self, session_id: str) -> Optional[TestSession]:
        res = await self.db.execute(
            select(TestSession).where(TestSession.session_id == session_id)
        )
        return res.scalars().first()

    async def complete_session(self, session_id: str) -> Optional[TestSession]:
        session = await self.get_session(session_id)
        if not session:
            return None
        from datetime import datetime

        session.is_completed = True
        session.completed_at = datetime.utcnow()
        await self.db.commit()
        await self.db.refresh(session)
        return session

