from __future__ import annotations

from typing import Literal

from pydantic import BaseModel

from app.models.consequence import ConsequenceResponse


DecisionType = Literal["share", "verify", "report", "ignore"]
DifficultyLevel = Literal["beginner", "easy", "intermediate", "advanced", "expert"]


class SourceSignals(BaseModel):
    transparency: Literal["LIMITED", "UNKNOWN", "CLEAR"]
    author_known: bool
    contact_available: bool


class DateSignals(BaseModel):
    status: Literal["VERIFIABLE", "UNVERIFIABLE", "OLD_CONTENT"]
    notes: str


class EvidenceItem(BaseModel):
    id: str
    category: str
    status: str
    label: str
    value: str
    explanation: str


class ScenarioSummary(BaseModel):
    id: str
    title: str
    headline: str
    category: str
    difficulty: DifficultyLevel
    is_trending: bool
    is_daily_challenge: bool
    target_skill: str
    created_at: str


class ScenarioDetail(ScenarioSummary):
    body: str
    claim: str
    language: str
    status: str
    source_signals: SourceSignals
    date_signals: DateSignals
    evidence: list[EvidenceItem]
    correct_decision: DecisionType
    consequences: dict[DecisionType, ConsequenceResponse]
    lesson_id: str
