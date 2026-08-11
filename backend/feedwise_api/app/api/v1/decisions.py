from __future__ import annotations

from fastapi import APIRouter, Depends, Query

from app.api.v1.deps import get_decision_repository, get_decision_service
from app.core.dependencies import get_current_user
from app.core.security import AuthUser
from app.models.decision import DecisionHistoryItem, DecisionResult, DecisionStats, DecisionSubmission
from app.repositories.decision_repository import DecisionRepository
from app.services.decision_service import DecisionService

router = APIRouter()


@router.post("", response_model=DecisionResult)
async def submit_decision(
    payload: DecisionSubmission,
    current_user: AuthUser = Depends(get_current_user),
    decision_service: DecisionService = Depends(get_decision_service),
) -> DecisionResult:
    return decision_service.submit_decision(
        user_id=current_user.user_id,
        scenario_id=payload.scenario_id,
        decision=payload.decision,
        investigation_steps=payload.investigation_steps,
        time_spent_seconds=payload.time_spent_seconds,
    )


@router.get("/history", response_model=list[DecisionHistoryItem])
async def history(
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    current_user: AuthUser = Depends(get_current_user),
    decision_repository: DecisionRepository = Depends(get_decision_repository),
) -> list[DecisionHistoryItem]:
    rows = decision_repository.list_by_user(current_user.user_id, page=page, limit=limit)
    return [DecisionHistoryItem(**row) for row in rows]


@router.get("/stats", response_model=DecisionStats)
async def stats(
    current_user: AuthUser = Depends(get_current_user),
    decision_repository: DecisionRepository = Depends(get_decision_repository),
) -> DecisionStats:
    return DecisionStats(**decision_repository.stats_for_user(current_user.user_id))
