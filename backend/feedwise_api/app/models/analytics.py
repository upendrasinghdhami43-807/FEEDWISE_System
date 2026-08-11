from __future__ import annotations

from pydantic import BaseModel


class PlatformStats(BaseModel):
    total_users: int
    active_users_7d: int
    total_decisions: int
    accuracy: float
    average_process_score: int


class ClassStats(BaseModel):
    class_id: str
    students: int
    average_xp: float
    average_accuracy: float
