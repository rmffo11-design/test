from datetime import datetime

from sqlalchemy import Boolean, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.db import Base


class Questionnaire(Base):
    __tablename__ = "questionnaires"

    questionnaire_id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    version_no: Mapped[int] = mapped_column(Integer, nullable=False)
    name: Mapped[str] = mapped_column(String(255))
    target_gender: Mapped[str | None] = mapped_column(String(20))
    is_published: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[datetime] = mapped_column(default=datetime.utcnow)

    questions = relationship(
        "Question",
        back_populates="questionnaire",
        cascade="all, delete-orphan",
    )

