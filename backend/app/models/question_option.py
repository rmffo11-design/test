from datetime import datetime

from sqlalchemy import ForeignKey, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.db import Base


class QuestionOption(Base):
    __tablename__ = "question_options"

    option_id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    question_id: Mapped[int] = mapped_column(
        ForeignKey("questions.question_id"), index=True
    )
    option_code: Mapped[str] = mapped_column(String(50))
    option_text: Mapped[str] = mapped_column(String(255))
    display_order: Mapped[int] = mapped_column(Integer)
    created_at: Mapped[datetime] = mapped_column(default=datetime.utcnow)

    question = relationship("Question", back_populates="options")

