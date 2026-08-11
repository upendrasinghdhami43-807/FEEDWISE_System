from __future__ import annotations

from fastapi import APIRouter, Depends

from app.api.v1.deps import get_learning_service, get_progress_service
from app.core.dependencies import get_current_user
from app.core.exceptions import NotFoundError
from app.core.security import AuthUser
from app.models.lesson import (
    AcademyModuleDetail,
    AcademyModuleSummary,
    LessonCompletionResponse,
    LessonDetail,
    QuizSubmissionRequest,
    QuizSubmissionResponse,
)
from app.services.learning_service import LearningService
from app.services.progress_service import ProgressService

router = APIRouter()


@router.get("/modules", response_model=list[AcademyModuleSummary])
async def modules(learning_service: LearningService = Depends(get_learning_service)) -> list[AcademyModuleSummary]:
    return [AcademyModuleSummary(**row) for row in learning_service.list_modules()]


@router.get("/modules/{module_id}", response_model=AcademyModuleDetail)
async def module_detail(
    module_id: str,
    learning_service: LearningService = Depends(get_learning_service),
) -> AcademyModuleDetail:
    module = learning_service.get_module(module_id)
    if module is None:
        raise NotFoundError("Module not found")
    return AcademyModuleDetail(**module)


@router.get("/lessons/{lesson_id}", response_model=LessonDetail)
async def lesson_detail(
    lesson_id: str,
    learning_service: LearningService = Depends(get_learning_service),
) -> LessonDetail:
    lesson = learning_service.get_lesson(lesson_id)
    if lesson is None:
        raise NotFoundError("Lesson not found")
    return LessonDetail(**lesson)


@router.post("/lessons/{lesson_id}/complete", response_model=LessonCompletionResponse)
async def complete_lesson(
    lesson_id: str,
    current_user: AuthUser = Depends(get_current_user),
    learning_service: LearningService = Depends(get_learning_service),
    progress_service: ProgressService = Depends(get_progress_service),
) -> LessonCompletionResponse:
    if learning_service.get_lesson(lesson_id) is None:
        raise NotFoundError("Lesson not found")

    completed = learning_service.complete_lesson(current_user.user_id, lesson_id)
    xp = 40 if completed else 0
    if xp:
        progress_service.add_xp(current_user.user_id, xp)
    return LessonCompletionResponse(lesson_id=lesson_id, completed=completed, xp_gained=xp)


@router.get("/quizzes/{lesson_id}")
async def lesson_quiz(
    lesson_id: str,
    learning_service: LearningService = Depends(get_learning_service),
) -> dict:
    lesson = learning_service.get_lesson(lesson_id)
    if lesson is None:
        raise NotFoundError("Lesson not found")
    return lesson["quiz"]


@router.post("/quizzes/{lesson_id}/submit", response_model=QuizSubmissionResponse)
async def submit_quiz(
    lesson_id: str,
    payload: QuizSubmissionRequest,
    learning_service: LearningService = Depends(get_learning_service),
) -> QuizSubmissionResponse:
    result = learning_service.submit_quiz_answer(lesson_id, payload.answer_index)
    if result is None:
        raise NotFoundError("Lesson not found")
    return QuizSubmissionResponse(**result)
