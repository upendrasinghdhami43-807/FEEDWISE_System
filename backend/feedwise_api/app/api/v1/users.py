from __future__ import annotations

from fastapi import APIRouter, Depends

from app.api.v1.deps import get_user_repository
from app.core.dependencies import get_current_user
from app.core.security import AuthUser
from app.models.user import BaselineAssessmentRequest, UserProfile, UserUpdateRequest
from app.repositories.user_repository import UserRepository

router = APIRouter()


@router.get("/me", response_model=UserProfile)
async def get_me(
    current_user: AuthUser = Depends(get_current_user),
    user_repository: UserRepository = Depends(get_user_repository),
) -> UserProfile:
    return UserProfile(**user_repository.get_me(current_user.user_id))


@router.patch("/me", response_model=UserProfile)
async def update_me(
    payload: UserUpdateRequest,
    current_user: AuthUser = Depends(get_current_user),
    user_repository: UserRepository = Depends(get_user_repository),
) -> UserProfile:
    updated = user_repository.update_me(
        current_user.user_id,
        {key: value for key, value in payload.model_dump().items() if value is not None},
    )
    return UserProfile(**updated)


@router.post("/me/baseline")
async def submit_baseline(
    payload: BaselineAssessmentRequest,
    current_user: AuthUser = Depends(get_current_user),
    user_repository: UserRepository = Depends(get_user_repository),
) -> dict:
    user_repository.update_me(current_user.user_id, {"baseline": payload.answers})
    return {"status": "ok"}
