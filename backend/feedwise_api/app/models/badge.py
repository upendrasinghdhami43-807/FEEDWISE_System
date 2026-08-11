from __future__ import annotations

from pydantic import BaseModel


class Badge(BaseModel):
    id: str
    name: str
    description: str
    icon: str


class BadgeAvailability(BaseModel):
    badge: Badge
    unlocked: bool
