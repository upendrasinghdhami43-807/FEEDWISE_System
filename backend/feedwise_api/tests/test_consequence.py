from app.services.consequence_service import ConsequenceService


def test_consequence_scales_by_difficulty() -> None:
    service = ConsequenceService()
    scenario = {
        "difficulty": "advanced",
        "consequences": {
            "verify": {
                "reach_count": 100,
                "shares_count": 10,
                "credibility_delta": 5,
                "impact_text": "ok",
                "missed_clues": [],
                "recommendation": "ok",
            }
        },
    }

    result = service.get_consequence(scenario, "verify")

    assert result["reach_count"] == 120
    assert result["shares_count"] == 12
    assert result["credibility_delta"] == 5
