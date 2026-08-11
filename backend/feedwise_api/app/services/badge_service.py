from __future__ import annotations

from app.repositories.badge_repository import BadgeRepository
from app.repositories.decision_repository import DecisionRepository
from app.repositories.lesson_repository import LessonRepository


class BadgeService:
    def __init__(
        self,
        badge_repository: BadgeRepository,
        decision_repository: DecisionRepository,
        lesson_repository: LessonRepository,
    ) -> None:
        self.badge_repository = badge_repository
        self.decision_repository = decision_repository
        self.lesson_repository = lesson_repository

    def check_unlocks(self, user_id: str, progress: dict, community_count: int) -> list[dict]:
        unlocked = {item["id"] for item in self.badge_repository.list_user_badges(user_id)}
        stats = self.decision_repository.stats_for_user(user_id)
        decisions = self.decision_repository.list_by_user(user_id, page=1, limit=1000)

        source_checks = sum(1 for row in decisions if "checked_source" in row.get("investigation_steps", []))
        full_evidence_checks = sum(
            1
            for row in decisions
            if {"checked_evidence", "checked_cross_sources"}.issubset(set(row.get("investigation_steps", [])))
        )

        completed_ai_lesson = any(
            self.lesson_repository.is_lesson_completed(user_id, lesson_id)
            and self.lesson_repository.get_lesson(lesson_id).get("skill") == "ai_literacy"
            for lesson_id in self.lesson_repository.store.lessons.keys()
        )

        to_award: list[str] = []
        if source_checks >= 5 and "source_detective" not in unlocked:
            to_award.append("source_detective")
        if full_evidence_checks >= 3 and "evidence_hunter" not in unlocked:
            to_award.append("evidence_hunter")
        if progress["streak"] >= 3 and "streak_starter" not in unlocked:
            to_award.append("streak_starter")
        if progress["streak"] >= 7 and "streak_champion" not in unlocked:
            to_award.append("streak_champion")
        if progress["level"] >= 5 and "mil_scholar" not in unlocked:
            to_award.append("mil_scholar")
        if community_count >= 1 and "community_contributor" not in unlocked:
            to_award.append("community_contributor")
        if stats["verify_count"] >= 10 and "quick_verifier" not in unlocked:
            to_award.append("quick_verifier")
        if completed_ai_lesson and "ai_aware" not in unlocked:
            to_award.append("ai_aware")

        awarded = []
        for badge_id in to_award:
            badge = self.badge_repository.award(user_id, badge_id)
            if badge:
                awarded.append(badge)
        return awarded
