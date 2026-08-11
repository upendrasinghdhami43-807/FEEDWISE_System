from __future__ import annotations

from app.repositories.base import BaseRepository


class DecisionRepository(BaseRepository):
    def find_by_user_and_scenario(self, user_id: str, scenario_id: str) -> dict | None:
        for row in self.store.decisions:
            if row["user_id"] == user_id and row["scenario_id"] == scenario_id:
                return row
        return None

    def create(self, payload: dict) -> dict:
        self.store.decisions.append(payload)
        return payload

    def list_by_user(self, user_id: str, *, page: int, limit: int) -> list[dict]:
        rows = [row for row in self.store.decisions if row["user_id"] == user_id]
        rows.sort(key=lambda row: row["created_at"], reverse=True)
        start = (page - 1) * limit
        return rows[start : start + limit]

    def count_by_user(self, user_id: str) -> int:
        return sum(1 for row in self.store.decisions if row["user_id"] == user_id)

    def stats_for_user(self, user_id: str) -> dict:
        rows = [row for row in self.store.decisions if row["user_id"] == user_id]
        total = len(rows)
        correct = sum(1 for row in rows if row["is_correct"])
        verify_count = sum(1 for row in rows if row["decision"] == "verify")
        average_score = int(sum(row["process_score"] for row in rows) / total) if total else 0
        return {
            "total_decisions": total,
            "correct_decisions": correct,
            "accuracy": (correct / total) if total else 0.0,
            "verify_count": verify_count,
            "average_process_score": average_score,
        }
