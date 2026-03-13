from collections import defaultdict
from typing import Any, Dict, List

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models import ScoringRule, TestAnswer, TestResult, TestSession


class ScoringService:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def calculate_score(self, session_id: str) -> Dict[str, Any]:
        session = await self._get_session(session_id)
        if session is None:
            raise ValueError("Session not found")

        answers = await self._get_answers(session_id)
        if not answers:
            result = await self._store_result(session_id, 0.0, {})
            return {
                "total_score": 0.0,
                "grade": result.grade_code,
                "metric_scores": {},
            }

        rules = await self._get_rules(session.questionnaire_id)

        metric_scores: Dict[int, float] = defaultdict(float)
        for a in answers:
            for r in rules:
                if r.question_id == a.question_id and (
                    r.option_id is None or r.option_id == a.option_id
                ):
                    metric_scores[r.metric_id] += r.score * r.weight

        total_score = float(sum(metric_scores.values()))
        result = await self._store_result(session_id, total_score, dict(metric_scores))

        return {
            "total_score": total_score,
            "grade": result.grade_code,
            "metric_scores": dict(metric_scores),
        }

    async def _get_session(self, session_id: str) -> TestSession | None:
        res = await self.db.execute(
            select(TestSession).where(TestSession.session_id == session_id)
        )
        return res.scalars().first()

    async def _get_answers(self, session_id: str) -> List[TestAnswer]:
        res = await self.db.execute(
            select(TestAnswer).where(TestAnswer.session_id == session_id)
        )
        return list(res.scalars())

    async def _get_rules(self, questionnaire_id: int) -> List[ScoringRule]:
        res = await self.db.execute(
            select(ScoringRule).where(
                ScoringRule.questionnaire_id == questionnaire_id
            )
        )
        return list(res.scalars())

    def _classify_grade(self, total_score: float) -> str:
        if total_score >= 90:
            return "VIP"
        if total_score >= 80:
            return "PREMIUM"
        if total_score >= 70:
            return "UPPER"
        if total_score >= 60:
            return "NORMAL"
        return "LOW"

    async def _store_result(
        self, session_id: str, total_score: float, metric_scores: dict[int, float]
    ) -> TestResult:
        res = await self.db.execute(
            select(TestResult).where(TestResult.session_id == session_id)
        )
        existing = res.scalars().first()

        grade_code = self._classify_grade(total_score)

        if existing:
            existing.total_score = total_score
            existing.grade_code = grade_code
            existing.metric_scores = metric_scores
            await self.db.commit()
            await self.db.refresh(existing)
            return existing

        result = TestResult(
            session_id=session_id,
            total_score=total_score,
            grade_code=grade_code,
            metric_scores=metric_scores,
        )
        self.db.add(result)
        await self.db.commit()
        await self.db.refresh(result)
        return result

