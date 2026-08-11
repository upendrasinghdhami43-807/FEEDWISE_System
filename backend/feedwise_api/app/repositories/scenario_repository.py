from __future__ import annotations

from app.repositories.base import BaseRepository


class ScenarioRepository(BaseRepository):
    def list_published(self, language: str, *, page: int, limit: int) -> list[dict]:
        rows = [
            scenario
            for scenario in self.store.scenarios.values()
            if scenario["status"] == "published" and scenario["language"] == language
        ]
        rows.sort(key=lambda row: row["created_at"], reverse=True)
        start = (page - 1) * limit
        return rows[start : start + limit]

    def list_all(self) -> list[dict]:
        rows = list(self.store.scenarios.values())
        rows.sort(key=lambda row: row["created_at"], reverse=True)
        return rows

    def get_by_id(self, scenario_id: str) -> dict | None:
        return self.store.scenarios.get(scenario_id)

    def get_daily(self, language: str) -> dict | None:
        for scenario in self.store.scenarios.values():
            if scenario["status"] == "published" and scenario["language"] == language and scenario["is_daily_challenge"]:
                return scenario
        return None

    def create(self, payload: dict) -> dict:
        self.store.scenarios[payload["id"]] = payload
        return payload

    def update(self, scenario_id: str, changes: dict) -> dict | None:
        existing = self.store.scenarios.get(scenario_id)
        if existing is None:
            return None
        existing.update(changes)
        return existing
