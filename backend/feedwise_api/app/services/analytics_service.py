from __future__ import annotations

from app.repositories.data_store import InMemoryStore
from app.repositories.decision_repository import DecisionRepository


class AnalyticsService:
    def __init__(self, store: InMemoryStore, decision_repository: DecisionRepository) -> None:
        self.store = store
        self.decision_repository = decision_repository

    def get_platform_stats(self) -> dict:
        total_users = len(self.store.users)
        total_decisions = len(self.store.decisions)
        correct = sum(1 for row in self.store.decisions if row.get("is_correct"))
        accuracy = (correct / total_decisions) if total_decisions else 0.0
        average_process_score = (
            int(sum(row.get("process_score", 0) for row in self.store.decisions) / total_decisions)
            if total_decisions
            else 0
        )
        return {
            "total_users": total_users,
            "active_users_7d": total_users,
            "total_decisions": total_decisions,
            "accuracy": accuracy,
            "average_process_score": average_process_score,
        }

    def get_class_stats(self, class_id: str) -> dict:
        user_ids = self.store.class_rosters.get(class_id, [])
        if not user_ids:
            return {
                "class_id": class_id,
                "students": 0,
                "average_xp": 0.0,
                "average_accuracy": 0.0,
            }

        xp_total = 0
        accuracy_total = 0.0
        for user_id in user_ids:
            xp_total += self.store.progress[user_id]["xp"]
            accuracy_total += self.decision_repository.stats_for_user(user_id)["accuracy"]

        return {
            "class_id": class_id,
            "students": len(user_ids),
            "average_xp": xp_total / len(user_ids),
            "average_accuracy": accuracy_total / len(user_ids),
        }
