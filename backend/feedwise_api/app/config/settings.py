from functools import lru_cache
from typing import Literal

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    env: Literal["development", "production"] = "development"
    debug: bool = False
    app_name: str = "FeedWise API"
    api_v1_prefix: str = "/api/v1"

    supabase_url: str = ""
    supabase_service_key: str = ""
    supabase_jwt_secret: str = ""

    ai_enabled: bool = False
    ai_model: str = "gpt-4o-mini"
    ai_api_key: str = ""

    cors_origins: list[str] = Field(default_factory=lambda: ["http://localhost:3000"])
    rate_limit_per_minute: int = 60

    @classmethod
    def _normalize_origins(cls, value: str | list[str]) -> list[str]:
        if isinstance(value, list):
            return value
        return [item.strip() for item in value.split(",") if item.strip()]

    @property
    def is_development(self) -> bool:
        return self.env == "development"


@lru_cache
def get_settings() -> Settings:
    settings = Settings()
    settings.cors_origins = Settings._normalize_origins(settings.cors_origins)  # type: ignore[arg-type]
    return settings
