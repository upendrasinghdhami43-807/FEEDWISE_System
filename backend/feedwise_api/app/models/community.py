from __future__ import annotations

from pydantic import BaseModel


class CommunitySubmissionRequest(BaseModel):
    claim: str
    category: str
    source_platform: str
    reason: str
    screenshot_url: str | None = None
    language: str = "en"


class CommunitySubmissionResponse(BaseModel):
    id: str
    status: str


class CommunityChallenge(BaseModel):
    id: str
    claim: str
    category: str
    source_platform: str
    language: str
    created_at: str
