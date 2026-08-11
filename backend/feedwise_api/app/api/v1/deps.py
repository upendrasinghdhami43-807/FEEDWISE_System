from __future__ import annotations

from fastapi import Depends

from app.core.dependencies import get_store
from app.repositories.badge_repository import BadgeRepository
from app.repositories.community_repository import CommunityRepository
from app.repositories.data_store import InMemoryStore
from app.repositories.decision_repository import DecisionRepository
from app.repositories.lesson_repository import LessonRepository
from app.repositories.progress_repository import ProgressRepository
from app.repositories.scenario_repository import ScenarioRepository
from app.repositories.skill_repository import SkillRepository
from app.repositories.user_repository import UserRepository
from app.services.ai_service import AIService
from app.services.analytics_service import AnalyticsService
from app.services.badge_service import BadgeService
from app.services.consequence_service import ConsequenceService
from app.services.decision_service import DecisionService
from app.services.learning_service import LearningService
from app.services.progress_service import ProgressService
from app.services.scenario_service import ScenarioService
from app.services.skill_service import SkillService


def get_user_repository(store: InMemoryStore = Depends(get_store)) -> UserRepository:
    return UserRepository(store)


def get_scenario_repository(store: InMemoryStore = Depends(get_store)) -> ScenarioRepository:
    return ScenarioRepository(store)


def get_decision_repository(store: InMemoryStore = Depends(get_store)) -> DecisionRepository:
    return DecisionRepository(store)


def get_skill_repository(store: InMemoryStore = Depends(get_store)) -> SkillRepository:
    return SkillRepository(store)


def get_progress_repository(store: InMemoryStore = Depends(get_store)) -> ProgressRepository:
    return ProgressRepository(store)


def get_badge_repository(store: InMemoryStore = Depends(get_store)) -> BadgeRepository:
    return BadgeRepository(store)


def get_lesson_repository(store: InMemoryStore = Depends(get_store)) -> LessonRepository:
    return LessonRepository(store)


def get_community_repository(store: InMemoryStore = Depends(get_store)) -> CommunityRepository:
    return CommunityRepository(store)


def get_scenario_service(
    scenario_repository: ScenarioRepository = Depends(get_scenario_repository),
    decision_repository: DecisionRepository = Depends(get_decision_repository),
    skill_repository: SkillRepository = Depends(get_skill_repository),
) -> ScenarioService:
    return ScenarioService(scenario_repository, decision_repository, skill_repository)


def get_skill_service(skill_repository: SkillRepository = Depends(get_skill_repository)) -> SkillService:
    return SkillService(skill_repository)


def get_progress_service(
    progress_repository: ProgressRepository = Depends(get_progress_repository),
) -> ProgressService:
    return ProgressService(progress_repository)


def get_learning_service(
    lesson_repository: LessonRepository = Depends(get_lesson_repository),
) -> LearningService:
    return LearningService(lesson_repository)


def get_badge_service(
    badge_repository: BadgeRepository = Depends(get_badge_repository),
    decision_repository: DecisionRepository = Depends(get_decision_repository),
    lesson_repository: LessonRepository = Depends(get_lesson_repository),
) -> BadgeService:
    return BadgeService(badge_repository, decision_repository, lesson_repository)


def get_decision_service(
    scenario_repository: ScenarioRepository = Depends(get_scenario_repository),
    decision_repository: DecisionRepository = Depends(get_decision_repository),
    community_repository: CommunityRepository = Depends(get_community_repository),
    skill_service: SkillService = Depends(get_skill_service),
    progress_service: ProgressService = Depends(get_progress_service),
    badge_service: BadgeService = Depends(get_badge_service),
    learning_service: LearningService = Depends(get_learning_service),
) -> DecisionService:
    return DecisionService(
        scenario_repository=scenario_repository,
        decision_repository=decision_repository,
        community_repository=community_repository,
        consequence_service=ConsequenceService(),
        skill_service=skill_service,
        progress_service=progress_service,
        badge_service=badge_service,
        learning_service=learning_service,
        ai_service=AIService(),
    )


def get_analytics_service(
    store: InMemoryStore = Depends(get_store),
    decision_repository: DecisionRepository = Depends(get_decision_repository),
) -> AnalyticsService:
    return AnalyticsService(store, decision_repository)
