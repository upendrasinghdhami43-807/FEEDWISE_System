from __future__ import annotations

from app.repositories.base import BaseRepository


class LessonRepository(BaseRepository):
    def list_modules(self) -> list[dict]:
        return list(self.store.academy_modules.values())

    def get_module(self, module_id: str) -> dict | None:
        return self.store.academy_modules.get(module_id)

    def get_lesson(self, lesson_id: str) -> dict | None:
        return self.store.lessons.get(lesson_id)

    def complete_lesson(self, user_id: str, lesson_id: str) -> bool:
        key = (user_id, lesson_id)
        if key in self.store.lesson_completions:
            return False
        self.store.lesson_completions.add(key)
        return True

    def is_lesson_completed(self, user_id: str, lesson_id: str) -> bool:
        return (user_id, lesson_id) in self.store.lesson_completions
