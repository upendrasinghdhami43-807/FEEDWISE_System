from __future__ import annotations

from datetime import datetime, timezone

from app.repositories.progress_repository import ProgressRepository


class ProgressService:
    level_thresholds = [0, 100, 250, 500, 900, 1500, 2500, 9999]

    def __init__(self, progress_repository: ProgressRepository) -> None:
        self.progress_repository = progress_repository

    def _level_for_xp(self, xp: int) -> int:
        level = 1
        for index, threshold in enumerate(self.level_thresholds, start=1):
            if xp >= threshold:
                level = index
        return level

    def get_progress(self, user_id: str) -> dict:
        return self.progress_repository.get(user_id)

    def add_xp(self, user_id: str, xp_amount: int) -> dict:
        progress = self.progress_repository.get(user_id).copy()
        now = datetime.now(timezone.utc)
        today = now.date()

        progress["xp"] = int(progress.get("xp", 0)) + xp_amount
        progress["level"] = self._level_for_xp(progress["xp"])

        last_activity_date = progress.get("last_activity_date")
        if last_activity_date:
            previous_date = datetime.fromisoformat(last_activity_date).date()
            if previous_date == today:
                pass
            elif (today - previous_date).days == 1:
                progress["streak"] = int(progress.get("streak", 0)) + 1
            else:
                progress["streak"] = 1
        else:
            progress["streak"] = 1

        progress["last_activity_date"] = today.isoformat()
        progress["updated_at"] = now.isoformat()
        return self.progress_repository.update(user_id, progress)
