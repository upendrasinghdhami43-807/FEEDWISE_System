import os

import pytest
from fastapi.testclient import TestClient

from app.main import create_app


@pytest.fixture(scope="session", autouse=True)
def force_dev_env() -> None:
    os.environ.setdefault("ENV", "development")
    os.environ.setdefault("DEBUG", "true")


@pytest.fixture()
def client() -> TestClient:
    app = create_app()
    with TestClient(app) as tc:
        yield tc


@pytest.fixture()
def auth_headers() -> dict[str, str]:
    return {"Authorization": "Bearer dev-student"}


@pytest.fixture()
def admin_headers() -> dict[str, str]:
    return {"Authorization": "Bearer dev-admin"}
