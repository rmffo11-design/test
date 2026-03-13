from typing import List

from pydantic import BaseModel, ConfigDict


class QuestionOptionSchema(BaseModel):
    option_id: int
    option_code: str | None = None
    option_text: str

    model_config = ConfigDict(from_attributes=True)


class QuestionSchema(BaseModel):
    question_id: int
    code: str
    question_text: str
    question_type: str | None = None
    display_order: int
    options: List[QuestionOptionSchema]

    model_config = ConfigDict(from_attributes=True)


class QuestionnaireResponseSchema(BaseModel):
    questionnaire_id: int
    version_no: int
    name: str
    questions: List[QuestionSchema]

    model_config = ConfigDict(from_attributes=True)

