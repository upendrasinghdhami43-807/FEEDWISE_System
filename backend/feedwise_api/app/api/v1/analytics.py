from __future__ import annotations

from fastapi import APIRouter, Depends

from app.api.v1.deps import get_analytics_service
from app.core.dependencies import require_teacher_or_admin
from app.models.analytics import ClassStats, PlatformStats
from app.services.analytics_service import AnalyticsService

router = APIRouter()


@router.get("/platform", response_model=PlatformStats)
async def platform_stats(
    _: dict = Depends(require_teacher_or_admin),
    analytics_service: AnalyticsService = Depends(get_analytics_service),
) -> PlatformStats:
    return PlatformStats(**analytics_service.get_platform_stats())


@router.get("/class/{class_id}", response_model=ClassStats)
async def class_stats(
    class_id: str,
    _: dict = Depends(require_teacher_or_admin),
    analytics_service: AnalyticsService = Depends(get_analytics_service),
) -> ClassStats:
    return ClassStats(**analytics_service.get_class_stats(class_id))
