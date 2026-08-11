from __future__ import annotations

from pydantic import BaseModel


class AcademyModuleSummary(BaseModel):
    id: str
    title: str
    description: str
    icon: str
    skill_dimension: str


class AcademyModuleDetail(AcademyModuleSummary):
    lessons: list["LessonSummary"]


class LessonSummary(BaseModel):
    id: str
    title: str
    order: int
    skill: str


class LessonDetail(LessonSummary):
    module_id: str
    content: str
    tips: list[str]
    quiz: dict


class LessonCompletionResponse(BaseModel):
    lesson_id: str
    completed: bool
    xp_gained: int


class QuizSubmissionRequest(BaseModel):
    answer_index: int


class QuizSubmissionResponse(BaseModel):
    correct: bool
    expected_index: int
