from __future__ import annotations

from pydantic import BaseModel


class ConsequenceResponse(BaseModel):
    reach_count: int
    shares_count: int
    credibility_delta: int
    impact_text: str
    missed_clues: list[str]
    recommendation: str
