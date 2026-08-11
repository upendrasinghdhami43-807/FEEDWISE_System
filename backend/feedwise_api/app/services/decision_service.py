from __future__ import annotations

from datetime import datetime, timezone

from app.core.exceptions import ConflictError, NotFoundError
from app.models.decision import DecisionResult
from app.repositories.community_repository import CommunityRepository
from app.repositories.decision_repository import DecisionRepository
from app.repositories.scenario_repository import ScenarioRepository
from app.services.ai_service import AIService
from app.services.badge_service import BadgeService
from app.services.consequence_service import ConsequenceService
from app.services.learning_service import LearningService
from app.services.progress_service import ProgressService
from app.services.skill_service import SkillService


class DecisionService:
    step_weights = {
        "opened_investigation": 20,
        "checked_source": 10,
        "checked_evidence": 10,
        "checked_cross_sources": 10,
        "checked_author": 5,
        "checked_date": 5,
        "checked_image": 5,
        "used_evidence_detail": 5,
    }

    def __init__(
        self,
        scenario_repository: ScenarioRepository,
        decision_repository: DecisionRepository,
        community_repository: CommunityRepository,
        consequence_service: ConsequenceService,
        skill_service: SkillService,
        progress_service: ProgressService,
        badge_service: BadgeService,
        learning_service: LearningService,
        ai_service: AIService,
    ) -> None:
        self.scenario_repository = scenario_repository
        self.decision_repository = decision_repository
        self.community_repository = community_repository
        self.consequence_service = consequence_service
        self.skill_service = skill_service
        self.progress_service = progress_service
        self.badge_service = badge_service
        self.learning_service = learning_service
        self.ai_service = ai_service

    @classmethod
    def calculate_process_score(cls, investigation_steps: list[str]) -> int:
        score = sum(cls.step_weights.get(step, 0) for step in investigation_steps)
        return max(0, min(score, 100))

    @staticmethod
    def calculate_xp(is_correct: bool, process_score: int) -> int:
        xp = 50
        if is_correct:
            xp += 30
        if process_score >= 60:
            xp += 20
        if process_score >= 80:
            xp += 10
        return xp

    def _to_result(self, record: dict) -> DecisionResult:
        return DecisionResult(
            scenario_id=record["scenario_id"],
            decision=record["decision"],
            is_correct=record["is_correct"],
            process_score=record["process_score"],
            xp_gained=record["xp_gained"],
            new_level=record["new_level"],
            consequence=record["consequence"],
            skill_updates=record["skill_updates"],
            new_badges=record["new_badges"],
            lesson_id=record["lesson_id"],
            feedback_message=record["feedback_message"],
        )

    def submit_decision(
        self,
        *,
        user_id: str,
        scenario_id: str,
        decision: str,
        investigation_steps: list[str],
        time_spent_seconds: int,
    ) -> DecisionResult:
        scenario = self.scenario_repository.get_by_id(scenario_id)
        if scenario is None:
            raise NotFoundError("Scenario not found")
        if scenario["status"] != "published":
            raise ConflictError("Scenario is not available for decisions")

        existing = self.decision_repository.find_by_user_and_scenario(user_id, scenario_id)
        if existing is not None:
            return self._to_result(existing)

        process_score = self.calculate_process_score(investigation_steps)
        is_correct = decision == scenario["correct_decision"]
        xp = self.calculate_xp(is_correct, process_score)

        consequence = self.consequence_service.get_consequence(scenario, decision)
        skill_updates = self.skill_service.update_after_decision(
            user_id=user_id,
            target_skill=scenario["target_skill"],
            is_correct=is_correct,
            process_score=process_score,
            difficulty=scenario["difficulty"],
        )
        progress = self.progress_service.add_xp(user_id, xp)

        community_count = sum(
            1 for row in self.community_repository.store.community_submissions if row.get("user_id") == user_id
        )
        new_badges = self.badge_service.check_unlocks(user_id, progress, community_count)

        lesson = self.learning_service.get_lesson_for_scenario(scenario)
        lesson_id = lesson["id"] if lesson else ""

        record = {
            "decision_id": f"dec-{self.decision_repository.count_by_user(user_id) + 1:05d}",
            "user_id": user_id,
            "scenario_id": scenario_id,
            "decision": decision,
            "investigation_steps": investigation_steps,
            "time_spent_seconds": time_spent_seconds,
            "is_correct": is_correct,
            "process_score": process_score,
            "xp_gained": xp,
            "new_level": progress["level"],
            "consequence": consequence,
            "skill_updates": [item.model_dump() for item in skill_updates],
            "new_badges": new_badges,
            "lesson_id": lesson_id,
            "feedback_message": self.ai_service.generate_feedback(
                is_correct=is_correct,
                process_score=process_score,
            ),
            "created_at": datetime.now(timezone.utc).isoformat(),
        }

        self.decision_repository.create(record)
        return self._to_result(record)
