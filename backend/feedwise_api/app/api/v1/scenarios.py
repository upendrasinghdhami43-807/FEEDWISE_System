from __future__ import annotations

from fastapi import APIRouter, Depends, Query

from app.api.v1.deps import get_scenario_service
from app.core.dependencies import get_current_user
from app.core.security import AuthUser
from app.models.scenario import ScenarioDetail, ScenarioSummary
from app.services.scenario_service import ScenarioService

router = APIRouter()


@router.get("", response_model=list[ScenarioSummary])
async def list_scenarios(
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    language: str = Query("en"),
    scenario_service: ScenarioService = Depends(get_scenario_service),
) -> list[ScenarioSummary]:
    rows = scenario_service.list_scenarios(language=language, page=page, limit=limit)
    return [ScenarioSummary(**row) for row in rows]


@router.get("/feed", response_model=list[ScenarioSummary])
async def feed(
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    language: str = Query("en"),
    current_user: AuthUser = Depends(get_current_user),
    scenario_service: ScenarioService = Depends(get_scenario_service),
) -> list[ScenarioSummary]:
    rows = scenario_service.get_feed(
        user_id=current_user.user_id,
        language=language,
        page=page,
        limit=limit,
    )
    return [ScenarioSummary(**row) for row in rows]


@router.get("/daily", response_model=ScenarioSummary)
async def daily(
    language: str = Query("en"),
    scenario_service: ScenarioService = Depends(get_scenario_service),
) -> ScenarioSummary:
    return ScenarioSummary(**scenario_service.get_daily(language=language))


@router.get("/{scenario_id}", response_model=ScenarioDetail)
async def scenario_detail(
    scenario_id: str,
    scenario_service: ScenarioService = Depends(get_scenario_service),
) -> ScenarioDetail:
    row = scenario_service.get_scenario(scenario_id)
    return ScenarioDetail(**row)
