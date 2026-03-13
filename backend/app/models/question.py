from datetime import datetime

from sqlalchemy import Boolean, ForeignKey, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.db import Base


class Question(Base):
    __tablename__ = "questions"

    question_id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    questionnaire_id: Mapped[int] = mapped_column(
        ForeignKey("questionnaires.questionnaire_id"), index=True
    )
    metric_id: Mapped[int | None] = mapped_column(
        ForeignKey("metrics.metric_id"), index=True
    )
    code: Mapped[str] = mapped_column(String(50), index=True)
    question_text: Mapped[str] = mapped_column(Text)
    question_type: Mapped[str] = mapped_column(String(50))
    display_order: Mapped[int] = mapped_column(Integer)
    is_required: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[datetime] = mapped_column(default=datetime.utcnow)

    questionnaire = relationship("Questionnaire", back_populates="questions")
    metric = relationship("Metric", back_populates="questions")
    options = relationship(
        "QuestionOption",
        back_populates="question",
        cascade="all, delete-orphan",
    )

