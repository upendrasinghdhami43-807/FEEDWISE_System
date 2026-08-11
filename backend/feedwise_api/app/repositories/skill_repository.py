from __future__ import annotations

from datetime import datetime, timezone

from app.repositories.base import BaseRepository


class SkillRepository(BaseRepository):
    def get_scores(self, user_id: str) -> dict:
        return self.store.skills[user_id]

    def update_scores(self, user_id: str, new_scores: dict) -> dict:
        self.store.skills[user_id] = new_scores
        self.store.skill_history[user_id].append(
            {
                "timestamp": datetime.now(timezone.utc).isoformat(),
                "scores": new_scores.copy(),
            }
        )
        return new_scores

    def get_history(self, user_id: str) -> list[dict]:
        return self.store.skill_history[user_id]
