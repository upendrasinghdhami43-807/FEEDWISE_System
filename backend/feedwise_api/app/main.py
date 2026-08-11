from __future__ import annotations

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.router import router as api_router
from app.config.logging import configure_logging
from app.config.settings import get_settings
from app.core.exceptions import register_exception_handlers
from app.core.middleware import RateLimitMiddleware, RequestIdMiddleware
from app.models.common import HealthResponse
from app.repositories.data_store import InMemoryStore


def create_app() -> FastAPI:
    settings = get_settings()
    configure_logging()

    app = FastAPI(title=settings.app_name, version="0.1.0")
    register_exception_handlers(app)

    app.add_middleware(RequestIdMiddleware)
    app.add_middleware(RateLimitMiddleware)
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    @app.on_event("startup")
    async def startup_event() -> None:
        app.state.store = InMemoryStore.with_seed_data()

    @app.get("/health", response_model=HealthResponse)
    async def health() -> HealthResponse:
        return HealthResponse(status="ok", service="feedwise_api")

    app.include_router(api_router, prefix="/api")
    return app


app = create_app()
