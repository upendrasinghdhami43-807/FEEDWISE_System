from app.services.decision_service import DecisionService


def test_process_score_calculation() -> None:
    steps = [
        "opened_investigation",
        "checked_source",
        "checked_evidence",
        "checked_cross_sources",
        "checked_author",
    ]
    score = DecisionService.calculate_process_score(steps)
    assert score == 55


def test_calculate_xp() -> None:
    assert DecisionService.calculate_xp(is_correct=True, process_score=80) == 110
    assert DecisionService.calculate_xp(is_correct=False, process_score=20) == 50
    assert DecisionService.calculate_xp(is_correct=True, process_score=30) == 80
