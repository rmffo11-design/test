from sqlalchemy import Float, ForeignKey, Integer
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class ScoringRule(Base):
    __tablename__ = "scoring_rules"

    scoring_rule_id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    questionnaire_id: Mapped[int] = mapped_column(
        ForeignKey("questionnaires.questionnaire_id"), index=True
    )
    metric_id: Mapped[int] = mapped_column(
        ForeignKey("metrics.metric_id"), index=True
    )
    question_id: Mapped[int | None] = mapped_column(
        ForeignKey("questions.question_id"), index=True
    )
    option_id: Mapped[int | None] = mapped_column(
        ForeignKey("question_options.option_id"), index=True
    )
    score: Mapped[float] = mapped_column(Float)
    weight: Mapped[float] = mapped_column(Float)

