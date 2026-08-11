from __future__ import annotations

from typing import Any

from supabase import Client, create_client

from app.config.settings import get_settings


def get_supabase_client() -> Client | None:
    settings = get_settings()
    if not settings.supabase_url or not settings.supabase_service_key:
        return None
    return create_client(settings.supabase_url, settings.supabase_service_key)


def is_supabase_available() -> bool:
    return get_supabase_client() is not None


def maybe_execute(_query: str) -> dict[str, Any]:
    """Placeholder hook to switch repository reads/writes to Supabase later."""
    return {"status": "in_memory_fallback"}
