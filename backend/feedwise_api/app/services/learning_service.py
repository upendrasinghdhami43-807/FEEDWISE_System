from __future__ import annotations

from app.repositories.lesson_repository import LessonRepository


class LearningService:
    def __init__(self, lesson_repository: LessonRepository) -> None:
        self.lesson_repository = lesson_repository

    def list_modules(self) -> list[dict]:
        return self.lesson_repository.list_modules()

    def get_module(self, module_id: str) -> dict | None:
        module = self.lesson_repository.get_module(module_id)
        if not module:
            return None
        lessons = [
            self.lesson_repository.get_lesson(lesson_id)
            for lesson_id in module["lesson_ids"]
            if self.lesson_repository.get_lesson(lesson_id)
        ]
        return {**module, "lessons": lessons}

    def get_lesson(self, lesson_id: str) -> dict | None:
        return self.lesson_repository.get_lesson(lesson_id)

    def get_lesson_for_scenario(self, scenario: dict) -> dict | None:
        return self.get_lesson(scenario["lesson_id"])

    def complete_lesson(self, user_id: str, lesson_id: str) -> bool:
        return self.lesson_repository.complete_lesson(user_id, lesson_id)

    def submit_quiz_answer(self, lesson_id: str, answer_index: int) -> dict | None:
        lesson = self.lesson_repository.get_lesson(lesson_id)
        if lesson is None:
            return None
        expected = int(lesson["quiz"]["answer"])
        return {"correct": answer_index == expected, "expected_index": expected}
