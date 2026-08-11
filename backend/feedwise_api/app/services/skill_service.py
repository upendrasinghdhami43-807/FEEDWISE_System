from __future__ import annotations

from app.models.skill import SkillUpdate
from app.repositories.skill_repository import SkillRepository


class SkillService:
    _difficulty_weight = {
        "beginner": 0.5,
        "easy": 0.75,
        "intermediate": 1.0,
        "advanced": 1.5,
        "expert": 1.8,
    }

    def __init__(self, skill_repository: SkillRepository) -> None:
        self.skill_repository = skill_repository

    @staticmethod
    def _clamp(value: int) -> int:
        return max(0, min(100, value))

    def _base_delta(self, is_correct: bool, process_score: int) -> int:
        if is_correct and process_score >= 60:
            return 5
        if is_correct:
            return 3
        if process_score >= 60:
            return 1
        return -1

    def get_scores(self, user_id: str) -> dict:
        return self.skill_repository.get_scores(user_id)

    def get_history(self, user_id: str) -> list[dict]:
        return self.skill_repository.get_history(user_id)

    def update_after_decision(
        self,
        *,
        user_id: str,
        target_skill: str,
        is_correct: bool,
        process_score: int,
        difficulty: str,
    ) -> list[SkillUpdate]:
        current_scores = self.skill_repository.get_scores(user_id).copy()
        weight = self._difficulty_weight.get(difficulty, 1.0)
        delta = int(round(self._base_delta(is_correct, process_score) * weight))

        if target_skill not in current_scores:
            return []

        previous = int(current_scores[target_skill])
        current_scores[target_skill] = self._clamp(previous + delta)
        self.skill_repository.update_scores(user_id, current_scores)

        return [
            SkillUpdate(
                skill=target_skill,
                previous=previous,
                current=int(current_scores[target_skill]),
                delta=int(current_scores[target_skill]) - previous,
            )
        ]

    def get_recommendation(self, user_id: str, scenarios: list[dict]) -> dict:
        scores = self.get_scores(user_id)
        weak_skill = min(scores.keys(), key=lambda key: scores[key])
        recommended = [item["id"] for item in scenarios if item["target_skill"] == weak_skill][:3]
        return {
            "weak_skill": weak_skill,
            "recommended_scenario_ids": recommended,
            "tip": f"Practice {weak_skill.replace('_', ' ')} with focused challenges.",
        }
