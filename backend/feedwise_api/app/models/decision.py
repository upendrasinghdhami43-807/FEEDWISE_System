from __future__ import annotations

from pydantic import BaseModel, Field

from app.models.badge import Badge
from app.models.consequence import ConsequenceResponse
from app.models.scenario import DecisionType
from app.models.skill import SkillUpdate


class DecisionSubmission(BaseModel):
    scenario_id: str
    decision: DecisionType
    investigation_steps: list[str] = Field(default_factory=list)
    time_spent_seconds: int = Field(default=0, ge=0)


class DecisionResult(BaseModel):
    scenario_id: str
    decision: DecisionType
    is_correct: bool
    process_score: int
    xp_gained: int
    new_level: int
    consequence: ConsequenceResponse
    skill_updates: list[SkillUpdate]
    new_badges: list[Badge]
    lesson_id: str
    feedback_message: str


class DecisionHistoryItem(BaseModel):
    decision_id: str
    scenario_id: str
    decision: DecisionType
    is_correct: bool
    process_score: int
    xp_gained: int
    created_at: str


class DecisionStats(BaseModel):
    total_decisions: int
    correct_decisions: int
    accuracy: float
    verify_count: int
    average_process_score: int
