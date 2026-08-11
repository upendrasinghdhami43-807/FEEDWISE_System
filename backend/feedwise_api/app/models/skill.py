from __future__ import annotations

from pydantic import BaseModel


class SkillScores(BaseModel):
    source_verification: int
    evidence_evaluation: int
    ai_literacy: int
    bias_detection: int
    digital_safety: int


class SkillUpdate(BaseModel):
    skill: str
    previous: int
    current: int
    delta: int


class SkillHistoryPoint(BaseModel):
    timestamp: str
    scores: SkillScores


class SkillRecommendation(BaseModel):
    weak_skill: str
    recommended_scenario_ids: list[str]
    tip: str
