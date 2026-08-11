from __future__ import annotations

from app.repositories.base import BaseRepository


class BadgeRepository(BaseRepository):
    def list_available(self) -> list[dict]:
        return list(self.store.badges.values())

    def list_user_badges(self, user_id: str) -> list[dict]:
        badge_ids = self.store.user_badges.get(user_id, set())
        return [self.store.badges[badge_id] for badge_id in badge_ids]

    def award(self, user_id: str, badge_id: str) -> dict | None:
        if badge_id not in self.store.badges:
            return None
        self.store.user_badges.setdefault(user_id, set()).add(badge_id)
        return self.store.badges[badge_id]
