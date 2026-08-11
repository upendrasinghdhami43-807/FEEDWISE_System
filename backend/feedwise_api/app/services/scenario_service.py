from __future__ import annotations

from app.core.exceptions import NotFoundError
from app.repositories.decision_repository import DecisionRepository
from app.repositories.scenario_repository import ScenarioRepository
from app.repositories.skill_repository import SkillRepository


class ScenarioService:
    def __init__(
        self,
        scenario_repository: ScenarioRepository,
        decision_repository: DecisionRepository,
        skill_repository: SkillRepository,
    ) -> None:
        self.scenario_repository = scenario_repository
        self.decision_repository = decision_repository
        self.skill_repository = skill_repository

    def list_scenarios(self, *, language: str, page: int, limit: int) -> list[dict]:
        return self.scenario_repository.list_published(language, page=page, limit=limit)

    def get_scenario(self, scenario_id: str) -> dict:
        scenario = self.scenario_repository.get_by_id(scenario_id)
        if scenario is None:
            raise NotFoundError("Scenario not found")
        return scenario

    def get_daily(self, *, language: str) -> dict:
        daily = self.scenario_repository.get_daily(language)
        if daily is None:
            raise NotFoundError("No daily challenge found")
        return daily

    def get_feed(self, *, user_id: str, language: str, page: int, limit: int) -> list[dict]:
        rows = self.scenario_repository.list_published(language, page=1, limit=500)
        completed_ids = {
            row["scenario_id"]
            for row in self.decision_repository.list_by_user(user_id, page=1, limit=1000)
        }
        rows = [row for row in rows if row["id"] not in completed_ids]

        scores = self.skill_repository.get_scores(user_id)
        weak_skill = min(scores.keys(), key=lambda key: scores[key])

        def sort_key(row: dict) -> tuple[int, int, int, str]:
            is_target = 1 if row["target_skill"] == weak_skill else 0
            return (
                1 if row["is_daily_challenge"] else 0,
                1 if row["is_trending"] else 0,
                is_target,
                row["created_at"],
            )

        rows.sort(key=sort_key, reverse=True)
        start = (page - 1) * limit
        return rows[start : start + limit]
