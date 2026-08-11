from __future__ import annotations

from datetime import datetime, timezone

from app.repositories.base import BaseRepository


class CommunityRepository(BaseRepository):
    def create_submission(self, payload: dict) -> dict:
        payload["created_at"] = datetime.now(timezone.utc).isoformat()
        payload["status"] = "pending"
        self.store.community_submissions.append(payload)
        return payload

    def list_approved_challenges(self) -> list[dict]:
        rows = [row for row in self.store.community_submissions if row["status"] == "approved"]
        rows.sort(key=lambda row: row["created_at"], reverse=True)
        return rows

    def list_queue(self) -> list[dict]:
        rows = [row for row in self.store.community_submissions if row["status"] == "pending"]
        rows.sort(key=lambda row: row["created_at"], reverse=True)
        return rows

    def review(self, submission_id: str, status: str, reviewer_id: str) -> dict | None:
        for item in self.store.community_submissions:
            if item["id"] == submission_id:
                item["status"] = status
                item["reviewed_by"] = reviewer_id
                return item
        return None
