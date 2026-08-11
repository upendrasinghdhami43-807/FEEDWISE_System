from __future__ import annotations

from pydantic import BaseModel


class NewsroomScenarioSummary(BaseModel):
    id: str
    title: str
    headline: str
    difficulty: str


class NewsroomScenarioDetail(NewsroomScenarioSummary):
    body: str
    claim: str
    evidence: list[dict]


class NewsroomDecisionSubmission(BaseModel):
    scenario_id: str
    action: str
    notes: str = ""


class NewsroomDecisionResult(BaseModel):
    scenario_id: str
    action: str
    recommendation: str
    impact_text: str
