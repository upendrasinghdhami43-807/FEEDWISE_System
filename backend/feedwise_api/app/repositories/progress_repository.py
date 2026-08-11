from __future__ import annotations

from app.repositories.base import BaseRepository


class ProgressRepository(BaseRepository):
    def get(self, user_id: str) -> dict:
        return self.store.progress[user_id]

    def update(self, user_id: str, payload: dict) -> dict:
        self.store.progress[user_id] = payload
        return payload

    def leaderboard(self, class_user_ids: list[str]) -> list[dict]:
        rows = []
        for user_id in class_user_ids:
            progress = self.store.progress.get(user_id)
            user = self.store.users.get(user_id)
            if progress and user:
                rows.append(
                    {
                        "user_id": user_id,
                        "name": user.get("name") or user.get("email"),
                        "xp": progress["xp"],
                        "level": progress["level"],
                    }
                )
        rows.sort(key=lambda row: row["xp"], reverse=True)
        return rows
