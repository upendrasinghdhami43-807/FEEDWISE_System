from __future__ import annotations

from pydantic import BaseModel


class ProgressResponse(BaseModel):
    xp: int
    level: int
    streak: int
    last_activity_date: str
    updated_at: str


class LeaderboardEntry(BaseModel):
    user_id: str
    name: str
    xp: int
    level: int
