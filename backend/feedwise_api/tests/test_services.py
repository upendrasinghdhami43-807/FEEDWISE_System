from app.repositories.badge_repository import BadgeRepository
from app.repositories.community_repository import CommunityRepository
from app.repositories.data_store import InMemoryStore
from app.repositories.decision_repository import DecisionRepository
from app.repositories.lesson_repository import LessonRepository
from app.repositories.progress_repository import ProgressRepository
from app.repositories.scenario_repository import ScenarioRepository
from app.repositories.skill_repository import SkillRepository
from app.services.ai_service import AIService
from app.services.badge_service import BadgeService
from app.services.consequence_service import ConsequenceService
from app.services.decision_service import DecisionService
from app.services.learning_service import LearningService
from app.services.progress_service import ProgressService
from app.services.skill_service import SkillService


def _build_decision_service(store: InMemoryStore) -> DecisionService:
    scenario_repo = ScenarioRepository(store)
    decision_repo = DecisionRepository(store)
    community_repo = CommunityRepository(store)
    skill_service = SkillService(SkillRepository(store))
    progress_service = ProgressService(ProgressRepository(store))
    learning_service = LearningService(LessonRepository(store))
    badge_service = BadgeService(BadgeRepository(store), decision_repo, LessonRepository(store))

    return DecisionService(
        scenario_repository=scenario_repo,
        decision_repository=decision_repo,
        community_repository=community_repo,
        consequence_service=ConsequenceService(),
        skill_service=skill_service,
        progress_service=progress_service,
        badge_service=badge_service,
        learning_service=learning_service,
        ai_service=AIService(),
    )


def test_submit_decision_idempotent() -> None:
    store = InMemoryStore.with_seed_data()
    service = _build_decision_service(store)

    first = service.submit_decision(
        user_id="user-student",
        scenario_id="scn-001",
        decision="verify",
        investigation_steps=["opened_investigation", "checked_source", "checked_evidence"],
        time_spent_seconds=90,
    )
    second = service.submit_decision(
        user_id="user-student",
        scenario_id="scn-001",
        decision="verify",
        investigation_steps=["opened_investigation"],
        time_spent_seconds=12,
    )

    assert first.scenario_id == second.scenario_id
    assert len(store.decisions) == 1


def test_skill_updates_after_decision() -> None:
    store = InMemoryStore.with_seed_data()
    before = store.skills["user-student"]["evidence_evaluation"]
    service = _build_decision_service(store)

    _ = service.submit_decision(
        user_id="user-student",
        scenario_id="scn-001",
        decision="verify",
        investigation_steps=["opened_investigation", "checked_source", "checked_evidence", "checked_cross_sources"],
        time_spent_seconds=80,
    )

    after = store.skills["user-student"]["evidence_evaluation"]
    assert after > before
