def test_health_endpoint(client) -> None:
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_protected_route_requires_auth(client) -> None:
    response = client.get("/api/v1/auth/me")
    assert response.status_code == 401


def test_auth_me_with_dev_token(client, auth_headers) -> None:
    response = client.get("/api/v1/auth/me", headers=auth_headers)
    assert response.status_code == 200
    assert response.json()["role"] == "student"


def test_feed_and_decision_flow(client, auth_headers) -> None:
    feed = client.get("/api/v1/scenarios/feed", headers=auth_headers)
    assert feed.status_code == 200
    rows = feed.json()
    assert len(rows) >= 1

    scenario_id = rows[0]["id"]
    payload = {
        "scenario_id": scenario_id,
        "decision": "verify",
        "investigation_steps": ["opened_investigation", "checked_source", "checked_evidence"],
        "time_spent_seconds": 120,
    }
    decision = client.post("/api/v1/decisions", headers=auth_headers, json=payload)
    assert decision.status_code == 200
    assert "xp_gained" in decision.json()


def test_admin_create_scenario(client, admin_headers) -> None:
    payload = {
        "title": "Draft test scenario",
        "headline": "Headline",
        "body": "Body",
        "claim": "Claim",
        "category": "education",
        "difficulty": "easy",
        "language": "en",
        "target_skill": "source_verification",
    }
    response = client.post("/api/v1/admin/scenarios", headers=admin_headers, json=payload)
    assert response.status_code == 200
    assert response.json()["status"] == "draft"
