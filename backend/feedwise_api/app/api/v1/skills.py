from __future__ import annotations

from fastapi import APIRouter, Depends

from app.api.v1.deps import get_scenario_repository, get_skill_service
from app.core.dependencies import get_current_user
from app.core.security import AuthUser
from app.models.skill import SkillHistoryPoint, SkillRecommendation, SkillScores
from app.repositories.scenario_repository import ScenarioRepository
from app.services.skill_service import SkillService

router = APIRouter()


@router.get("", response_model=SkillScores)
async def get_skills(
    current_user: AuthUser = Depends(get_current_user),
    skill_service: SkillService = Depends(get_skill_service),
) -> SkillScores:
    return SkillScores(**skill_service.get_scores(current_user.user_id))


@router.get("/history", response_model=list[SkillHistoryPoint])
async def skill_history(
    current_user: AuthUser = Depends(get_current_user),
    skill_service: SkillService = Depends(get_skill_service),
) -> list[SkillHistoryPoint]:
    rows = skill_service.get_history(current_user.user_id)
    return [SkillHistoryPoint(**row) for row in rows]


@router.get("/recommendation", response_model=SkillRecommendation)
async def recommendation(
    current_user: AuthUser = Depends(get_current_user),
    skill_service: SkillService = Depends(get_skill_service),
    scenario_repository: ScenarioRepository = Depends(get_scenario_repository),
) -> SkillRecommendation:
    scenarios = [item for item in scenario_repository.list_all() if item["status"] == "published"]
    rec = skill_service.get_recommendation(current_user.user_id, scenarios)
    return SkillRecommendation(**rec)
