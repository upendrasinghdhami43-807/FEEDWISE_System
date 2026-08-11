from __future__ import annotations

from fastapi import APIRouter, Depends

from app.api.v1.deps import get_user_repository
from app.core.dependencies import get_current_user
from app.core.security import AuthUser
from app.models.user import UserProfile
from app.repositories.user_repository import UserRepository

router = APIRouter()


@router.get("/me", response_model=UserProfile)
async def me(
    current_user: AuthUser = Depends(get_current_user),
    user_repository: UserRepository = Depends(get_user_repository),
) -> UserProfile:
    user = user_repository.get_me(current_user.user_id)
    return UserProfile(**user)


@router.post("/callback")
async def auth_callback() -> dict:
    return {"status": "ok", "message": "Use Supabase SDK on client for auth callbacks."}
