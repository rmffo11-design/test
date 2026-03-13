from collections import defaultdict
from typing import Any, Dict, List

from sqlalchemy.orm import Session

from .models import Metric, ScoringRule, TestAnswer, TestResult, TestSession
from .repositories import AnswerRepository, TestSessionRepository


class ScoringService:
    def __init__(self, db: Session):
        self.db = db
        self.session_repo = TestSessionRepository(db)
        self.answer_repo = AnswerRepository(db)

    def calculate_score(self, session_id: str) -> Dict[str, Any]:
        """
        Calculate scores for a test session.

        Returns a structured result:
        {
            "total_score": float,
            "grade": str,
            "metric_scores": {metric_id: float}
        }
        """
        session: TestSession | None = self.session_repo.get_session(session_id)
        if session is None:
            raise ValueError("Session not found")

        answers: List[TestAnswer] = self.answer_repo.get_answers_by_session(session_id)
        if not answers:
            total_score = 0.0
            metric_scores: Dict[int, float] = {}
            result = self._store_result(session_id, total_score)
            return {
                "total_score": total_score,
                "grade": result.grade_code,
                "metric_scores": metric_scores,
            }

        # Load all scoring rules for this questionnaire
        rules: List[ScoringRule] = (
            self.db.query(ScoringRule)
            .filter(ScoringRule.questionnaire_id == session.questionnaire_id)
            .all()
        )

        metric_scores: Dict[int, float] = defaultdict(float)

        for answer in answers:
            applicable_rules = [
                rule
                for rule in rules
                if rule.question_id == answer.question_id
                and (rule.option_id is None or rule.option_id == answer.option_id)
            ]

            for rule in applicable_rules:
                metric_scores[rule.metric_id] += rule.score * rule.weight

        total_score = float(sum(metric_scores.values()))

        # Persist result
        result = self._store_result(session_id, total_score)

        return {
            "total_score": total_score,
            "grade": result.grade_code,
            "metric_scores": dict(metric_scores),
        }

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

    def _store_result(self, session_id: str, total_score: float) -> TestResult:
        existing = (
            self.db.query(TestResult)
            .filter(TestResult.session_id == session_id)
            .one_or_none()
        )

        grade_code = self._classify_grade(total_score)

        if existing:
            existing.total_score = total_score
            existing.grade_code = grade_code
            self.db.commit()
            self.db.refresh(existing)
            return existing

        result = TestResult(
            session_id=session_id,
            total_score=total_score,
            grade_code=grade_code,
        )
        self.db.add(result)
        self.db.commit()
        self.db.refresh(result)
        return result

