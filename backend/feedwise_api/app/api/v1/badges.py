from __future__ import annotations

from fastapi import APIRouter, Depends

from app.api.v1.deps import get_badge_repository
from app.core.dependencies import get_current_user
from app.core.security import AuthUser
from app.models.badge import Badge, BadgeAvailability
from app.repositories.badge_repository import BadgeRepository

router = APIRouter()


@router.get("", response_model=list[Badge])
async def my_badges(
    current_user: AuthUser = Depends(get_current_user),
    badge_repository: BadgeRepository = Depends(get_badge_repository),
) -> list[Badge]:
    return [Badge(**row) for row in badge_repository.list_user_badges(current_user.user_id)]


@router.get("/available", response_model=list[BadgeAvailability])
async def available_badges(
    current_user: AuthUser = Depends(get_current_user),
    badge_repository: BadgeRepository = Depends(get_badge_repository),
) -> list[BadgeAvailability]:
    unlocked = {item["id"] for item in badge_repository.list_user_badges(current_user.user_id)}
    out = []
    for badge in badge_repository.list_available():
        out.append(BadgeAvailability(badge=Badge(**badge), unlocked=badge["id"] in unlocked))
    return out
