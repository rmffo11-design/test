"""
Seed script — inserts sample metrics, questionnaire, questions, options, and scoring rules.

Usage (from backend/):
    python seed.py
"""
import asyncio
import os

from dotenv import load_dotenv
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

load_dotenv()

DATABASE_URL = os.environ["DATABASE_URL"]

_connect_args: dict = {}
if "supabase" in DATABASE_URL:
    _connect_args["ssl"] = "require"
if ":6543" in DATABASE_URL:  # Transaction Pooler: disable prepared statement cache
    _connect_args["statement_cache_size"] = 0

engine = create_async_engine(DATABASE_URL, echo=False, connect_args=_connect_args)
AsyncSessionLocal = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

# Import models after engine is ready
import app.models  # noqa: F401, E402
from app.models import (  # noqa: E402
    Metric,
    Questionnaire,
    Question,
    QuestionOption,
    ScoringRule,
)
from app.core.db import Base  # noqa: E402


METRICS = [
    {"code": "appearance", "name": "외모", "description": "외모 및 자기관리"},
    {"code": "education", "name": "학력", "description": "학력 및 지적 수준"},
    {"code": "income", "name": "소득", "description": "경제력 및 재정 상태"},
    {"code": "family", "name": "가족", "description": "가족 관계 및 배경"},
    {"code": "personality", "name": "성격", "description": "성격 및 가치관"},
    {"code": "lifestyle", "name": "라이프스타일", "description": "생활 패턴 및 취미"},
]

QUESTIONS = [
    {
        "metric_code": "appearance",
        "code": "Q_APP_01",
        "text": "상대방의 외모 관리에 대해 어떻게 생각하시나요?",
        "type": "single_choice",
        "order": 1,
        "options": [
            {"code": "O_APP_01_A", "text": "매우 중요하다", "score": 10},
            {"code": "O_APP_01_B", "text": "중요하다", "score": 7},
            {"code": "O_APP_01_C", "text": "보통이다", "score": 5},
            {"code": "O_APP_01_D", "text": "중요하지 않다", "score": 2},
        ],
    },
    {
        "metric_code": "education",
        "code": "Q_EDU_01",
        "text": "상대방의 학력 수준에 대한 선호는?",
        "type": "single_choice",
        "order": 2,
        "options": [
            {"code": "O_EDU_01_A", "text": "대학원 이상", "score": 10},
            {"code": "O_EDU_01_B", "text": "대졸", "score": 8},
            {"code": "O_EDU_01_C", "text": "전문대졸", "score": 5},
            {"code": "O_EDU_01_D", "text": "무관", "score": 3},
        ],
    },
    {
        "metric_code": "income",
        "code": "Q_INC_01",
        "text": "상대방의 연 소득 범위에 대한 기대치는?",
        "type": "single_choice",
        "order": 3,
        "options": [
            {"code": "O_INC_01_A", "text": "1억 이상", "score": 10},
            {"code": "O_INC_01_B", "text": "5천~1억", "score": 8},
            {"code": "O_INC_01_C", "text": "3천~5천", "score": 5},
            {"code": "O_INC_01_D", "text": "3천 미만도 괜찮다", "score": 2},
        ],
    },
    {
        "metric_code": "family",
        "code": "Q_FAM_01",
        "text": "가족 관계의 중요성은?",
        "type": "single_choice",
        "order": 4,
        "options": [
            {"code": "O_FAM_01_A", "text": "매우 중요하다", "score": 10},
            {"code": "O_FAM_01_B", "text": "중요하다", "score": 7},
            {"code": "O_FAM_01_C", "text": "보통이다", "score": 4},
            {"code": "O_FAM_01_D", "text": "별로 중요하지 않다", "score": 1},
        ],
    },
    {
        "metric_code": "personality",
        "code": "Q_PER_01",
        "text": "상대방에게 가장 중요한 성격은?",
        "type": "single_choice",
        "order": 5,
        "options": [
            {"code": "O_PER_01_A", "text": "배려심", "score": 10},
            {"code": "O_PER_01_B", "text": "유머 감각", "score": 8},
            {"code": "O_PER_01_C", "text": "책임감", "score": 9},
            {"code": "O_PER_01_D", "text": "긍정적 마인드", "score": 7},
        ],
    },
    {
        "metric_code": "lifestyle",
        "code": "Q_LST_01",
        "text": "주말 생활 패턴의 일치도는 얼마나 중요한가요?",
        "type": "single_choice",
        "order": 6,
        "options": [
            {"code": "O_LST_01_A", "text": "매우 중요하다", "score": 10},
            {"code": "O_LST_01_B", "text": "중요하다", "score": 7},
            {"code": "O_LST_01_C", "text": "보통이다", "score": 4},
            {"code": "O_LST_01_D", "text": "중요하지 않다", "score": 1},
        ],
    },
]


async def seed():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    async with AsyncSessionLocal() as db:
        # Check if already seeded
        existing = (await db.execute(select(Questionnaire))).scalars().first()
        if existing:
            print("DB already seeded — skipping.")
            return

        # Insert metrics
        metric_map: dict[str, Metric] = {}
        for m in METRICS:
            metric = Metric(
                code=m["code"],
                name=m["name"],
                description=m["description"],
                is_active=True,
            )
            db.add(metric)
            await db.flush()
            metric_map[m["code"]] = metric

        # Insert questionnaire
        questionnaire = Questionnaire(
            version_no=1,
            name="결혼 적합도 평가 v1",
            target_gender=None,
            is_published=True,
        )
        db.add(questionnaire)
        await db.flush()

        # Insert questions, options, scoring rules
        for q_data in QUESTIONS:
            metric = metric_map[q_data["metric_code"]]
            question = Question(
                questionnaire_id=questionnaire.questionnaire_id,
                metric_id=metric.metric_id,
                code=q_data["code"],
                question_text=q_data["text"],
                question_type=q_data["type"],
                display_order=q_data["order"],
                is_required=True,
            )
            db.add(question)
            await db.flush()

            for opt_data in q_data["options"]:
                option = QuestionOption(
                    question_id=question.question_id,
                    option_code=opt_data["code"],
                    option_text=opt_data["text"],
                    display_order=q_data["options"].index(opt_data) + 1,
                )
                db.add(option)
                await db.flush()

                rule = ScoringRule(
                    questionnaire_id=questionnaire.questionnaire_id,
                    metric_id=metric.metric_id,
                    question_id=question.question_id,
                    option_id=option.option_id,
                    score=float(opt_data["score"]),
                    weight=1.0,
                )
                db.add(rule)

        await db.commit()
        print(f"Seeded: {len(METRICS)} metrics, 1 questionnaire, {len(QUESTIONS)} questions.")


if __name__ == "__main__":
    asyncio.run(seed())
