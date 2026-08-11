from __future__ import annotations

import uuid

from fastapi import APIRouter, Depends

from app.api.v1.deps import get_community_repository
from app.core.dependencies import get_current_user
from app.core.security import AuthUser
from app.models.community import CommunityChallenge, CommunitySubmissionRequest, CommunitySubmissionResponse
from app.repositories.community_repository import CommunityRepository

router = APIRouter()


@router.post("/submissions", response_model=CommunitySubmissionResponse)
async def create_submission(
    payload: CommunitySubmissionRequest,
    current_user: AuthUser = Depends(get_current_user),
    community_repository: CommunityRepository = Depends(get_community_repository),
) -> CommunitySubmissionResponse:
    row = community_repository.create_submission(
        {
            "id": f"sub-{uuid.uuid4().hex[:8]}",
            "user_id": current_user.user_id,
            **payload.model_dump(),
        }
    )
    return CommunitySubmissionResponse(id=row["id"], status=row["status"])


@router.get("/challenges", response_model=list[CommunityChallenge])
async def list_challenges(
    community_repository: CommunityRepository = Depends(get_community_repository),
) -> list[CommunityChallenge]:
    rows = community_repository.list_approved_challenges()
    return [CommunityChallenge(**row) for row in rows]
