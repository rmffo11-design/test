from datetime import datetime
from uuid import uuid4

from sqlalchemy import DateTime, Float, String
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class TestResult(Base):
    __tablename__ = "test_results"

    result_id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    session_id: Mapped[UUID] = mapped_column(UUID(as_uuid=True), index=True)
    total_score: Mapped[float] = mapped_column(Float, nullable=False)
    grade_code: Mapped[str | None] = mapped_column(String(50))
    metric_scores: Mapped[dict] = mapped_column(JSONB, default=dict)
    result_token: Mapped[UUID] = mapped_column(
        UUID(as_uuid=True), unique=True, index=True, default=uuid4
    )
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)

