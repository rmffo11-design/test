from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Integer
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class TestAnswer(Base):
    __tablename__ = "test_answers"

    answer_id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    session_id: Mapped[str] = mapped_column(ForeignKey("test_sessions.session_id"), index=True)
    question_id: Mapped[int] = mapped_column(ForeignKey("questions.question_id"), index=True)
    option_id: Mapped[int | None] = mapped_column(ForeignKey("question_options.option_id"), index=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)

