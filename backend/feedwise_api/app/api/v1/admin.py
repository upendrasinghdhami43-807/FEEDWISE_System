from __future__ import annotations

import uuid
from datetime import datetime, timezone

from fastapi import APIRouter, Depends
from pydantic import BaseModel

from app.api.v1.deps import get_community_repository, get_scenario_repository, get_user_repository
from app.core.dependencies import get_current_user, require_admin, require_moderator_or_admin, require_reviewer_or_admin
from app.core.exceptions import NotFoundError
from app.core.security import AuthUser
from app.repositories.community_repository import CommunityRepository
from app.repositories.scenario_repository import ScenarioRepository
from app.repositories.user_repository import UserRepository

router = APIRouter()


class ScenarioCreateRequest(BaseModel):
    title: str
    headline: str
    body: str
    claim: str
    category: str
    difficulty: str = "beginner"
    language: str = "en"
    target_skill: str = "source_verification"


class ScenarioStatusUpdate(BaseModel):
    status: str


class CommunityReviewRequest(BaseModel):
    status: str


@router.get("/scenarios")
async def all_scenarios(
    _: AuthUser = Depends(require_reviewer_or_admin),
    scenario_repository: ScenarioRepository = Depends(get_scenario_repository),
) -> list[dict]:
    return scenario_repository.list_all()


@router.post("/scenarios")
async def create_scenario(
    payload: ScenarioCreateRequest,
    current_user: AuthUser = Depends(require_admin),
    scenario_repository: ScenarioRepository = Depends(get_scenario_repository),
) -> dict:
    scenario_id = f"scn-{uuid.uuid4().hex[:6]}"
    row = {
        "id": scenario_id,
        "title": payload.title,
        "headline": payload.headline,
        "body": payload.body,
        "claim": payload.claim,
        "category": payload.category,
        "difficulty": payload.difficulty,
        "language": payload.language,
        "status": "draft",
        "is_trending": False,
        "is_daily_challenge": False,
        "target_skill": payload.target_skill,
        "created_at": datetime.now(timezone.utc).isoformat(),
        "correct_decision": "verify",
        "source_signals": {"transparency": "UNKNOWN", "author_known": False, "contact_available": False},
        "date_signals": {"status": "VERIFIABLE", "notes": "Draft scenario."},
        "evidence": [],
        "consequences": {
            "share": {"reach_count": 100, "shares_count": 20, "credibility_delta": -8, "impact_text": "Draft impact.", "missed_clues": [], "recommendation": "Review before publishing."},
            "verify": {"reach_count": 20, "shares_count": 2, "credibility_delta": 5, "impact_text": "Draft impact.", "missed_clues": [], "recommendation": "Review before publishing."},
            "report": {"reach_count": 10, "shares_count": 1, "credibility_delta": 4, "impact_text": "Draft impact.", "missed_clues": [], "recommendation": "Review before publishing."},
            "ignore": {"reach_count": 60, "shares_count": 10, "credibility_delta": -3, "impact_text": "Draft impact.", "missed_clues": [], "recommendation": "Review before publishing."},
        },
        "lesson_id": "lesson-source-1",
        "created_by": current_user.user_id,
    }
    return scenario_repository.create(row)


@router.put("/scenarios/{scenario_id}")
async def update_scenario(
    scenario_id: str,
    payload: ScenarioCreateRequest,
    _: AuthUser = Depends(require_admin),
    scenario_repository: ScenarioRepository = Depends(get_scenario_repository),
) -> dict:
    updated = scenario_repository.update(scenario_id, payload.model_dump())
    if updated is None:
        raise NotFoundError("Scenario not found")
    return updated


@router.patch("/scenarios/{scenario_id}/status")
async def update_scenario_status(
    scenario_id: str,
    payload: ScenarioStatusUpdate,
    _: AuthUser = Depends(require_reviewer_or_admin),
    scenario_repository: ScenarioRepository = Depends(get_scenario_repository),
) -> dict:
    updated = scenario_repository.update(scenario_id, {"status": payload.status})
    if updated is None:
        raise NotFoundError("Scenario not found")
    return updated


@router.get("/users")
async def all_users(
    _: AuthUser = Depends(require_admin),
    user_repository: UserRepository = Depends(get_user_repository),
) -> list[dict]:
    return user_repository.list_users()


@router.get("/community/queue")
async def community_queue(
    _: AuthUser = Depends(require_moderator_or_admin),
    community_repository: CommunityRepository = Depends(get_community_repository),
) -> list[dict]:
    return community_repository.list_queue()


@router.patch("/community/{submission_id}/review")
async def review_submission(
    submission_id: str,
    payload: CommunityReviewRequest,
    current_user: AuthUser = Depends(require_moderator_or_admin),
    community_repository: CommunityRepository = Depends(get_community_repository),
) -> dict:
    reviewed = community_repository.review(submission_id, payload.status, current_user.user_id)
    if reviewed is None:
        raise NotFoundError("Submission not found")
    return reviewed
