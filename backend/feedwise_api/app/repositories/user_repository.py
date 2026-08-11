from __future__ import annotations

from datetime import datetime, timezone

from app.repositories.base import BaseRepository


class UserRepository(BaseRepository):
    def ensure_user_exists(self, user_id: str, email: str, role: str) -> dict:
        user = self.store.users.get(user_id)
        if user:
            return user
        user = {
            "id": user_id,
            "email": email,
            "role": role,
            "name": "",
            "locale": "en",
            "age_group": "",
            "created_at": datetime.now(timezone.utc).isoformat(),
        }
        self.store.users[user_id] = user
        return user

    def get_me(self, user_id: str) -> dict | None:
        return self.store.users.get(user_id)

    def update_me(self, user_id: str, changes: dict) -> dict | None:
        user = self.store.users.get(user_id)
        if user is None:
            return None
        user.update(changes)
        return user

    def list_users(self) -> list[dict]:
        return sorted(self.store.users.values(), key=lambda row: row["created_at"], reverse=True)
