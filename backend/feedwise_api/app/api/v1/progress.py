from __future__ import annotations

from fastapi import APIRouter, Depends

from app.api.v1.deps import get_progress_repository, get_progress_service
from app.core.dependencies import get_current_user, require_teacher_or_admin
from app.core.security import AuthUser
from app.models.progress import LeaderboardEntry, ProgressResponse
from app.repositories.progress_repository import ProgressRepository
from app.services.progress_service import ProgressService

router = APIRouter()


@router.get("", response_model=ProgressResponse)
async def get_progress(
    current_user: AuthUser = Depends(get_current_user),
    progress_service: ProgressService = Depends(get_progress_service),
) -> ProgressResponse:
    return ProgressResponse(**progress_service.get_progress(current_user.user_id))


@router.get("/leaderboard", response_model=list[LeaderboardEntry])
async def leaderboard(
    class_id: str = "class-1",
    _: AuthUser = Depends(require_teacher_or_admin),
    progress_repository: ProgressRepository = Depends(get_progress_repository),
) -> list[LeaderboardEntry]:
    rows = progress_repository.leaderboard(progress_repository.store.class_rosters.get(class_id, []))
    return [LeaderboardEntry(**row) for row in rows]
