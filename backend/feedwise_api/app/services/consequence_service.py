from __future__ import annotations

from copy import deepcopy

from app.models.scenario import DecisionType


class ConsequenceService:
    _difficulty_multiplier = {
        "beginner": 0.8,
        "easy": 0.9,
        "intermediate": 1.0,
        "advanced": 1.2,
        "expert": 1.35,
    }

    def get_consequence(self, scenario: dict, decision: DecisionType) -> dict:
        base = deepcopy(scenario["consequences"][decision])
        multiplier = self._difficulty_multiplier.get(scenario["difficulty"], 1.0)
        base["reach_count"] = int(base["reach_count"] * multiplier)
        base["shares_count"] = int(base["shares_count"] * multiplier)
        return base
