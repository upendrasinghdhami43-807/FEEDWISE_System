from __future__ import annotations

from fastapi import APIRouter, Depends

from app.api.v1.deps import get_scenario_repository
from app.core.dependencies import get_current_user
from app.core.exceptions import NotFoundError
from app.models.newsroom import (
    NewsroomDecisionResult,
    NewsroomDecisionSubmission,
    NewsroomScenarioDetail,
    NewsroomScenarioSummary,
)
from app.repositories.scenario_repository import ScenarioRepository
from app.services.consequence_service import ConsequenceService

router = APIRouter()

_action_to_decision = {
    "publish": "share",
    "verify": "verify",
    "hold": "ignore",
    "reject": "report",
}


@router.get("/scenarios", response_model=list[NewsroomScenarioSummary])
async def list_newsroom_scenarios(
    scenario_repository: ScenarioRepository = Depends(get_scenario_repository),
) -> list[NewsroomScenarioSummary]:
    rows = [row for row in scenario_repository.list_all() if row["status"] == "published"]
    return [NewsroomScenarioSummary(**row) for row in rows]


@router.get("/scenarios/{scenario_id}", response_model=NewsroomScenarioDetail)
async def newsroom_scenario_detail(
    scenario_id: str,
    scenario_repository: ScenarioRepository = Depends(get_scenario_repository),
) -> NewsroomScenarioDetail:
    row = scenario_repository.get_by_id(scenario_id)
    if row is None:
        raise NotFoundError("Scenario not found")
    return NewsroomScenarioDetail(**row)


@router.post("/decisions", response_model=NewsroomDecisionResult)
async def newsroom_decision(
    payload: NewsroomDecisionSubmission,
    _: dict = Depends(get_current_user),
    scenario_repository: ScenarioRepository = Depends(get_scenario_repository),
) -> NewsroomDecisionResult:
    row = scenario_repository.get_by_id(payload.scenario_id)
    if row is None:
        raise NotFoundError("Scenario not found")

    mapped = _action_to_decision.get(payload.action, "verify")
    consequence = ConsequenceService().get_consequence(row, mapped)

    return NewsroomDecisionResult(
        scenario_id=payload.scenario_id,
        action=payload.action,
        recommendation=consequence["recommendation"],
        impact_text=consequence["impact_text"],
    )
