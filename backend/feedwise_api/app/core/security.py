from __future__ import annotations

from dataclasses import dataclass

from jose import JWTError, jwt

from app.config.settings import get_settings
from app.core.exceptions import AuthenticationError


@dataclass(slots=True)
class AuthUser:
    user_id: str
    email: str
    role: str


_DEV_TOKEN_MAP: dict[str, AuthUser] = {
    "dev-student": AuthUser(user_id="user-student", email="student@feedwise.dev", role="student"),
    "dev-teacher": AuthUser(user_id="user-teacher", email="teacher@feedwise.dev", role="teacher"),
    "dev-admin": AuthUser(user_id="user-admin", email="admin@feedwise.dev", role="admin"),
    "dev-reviewer": AuthUser(user_id="user-reviewer", email="reviewer@feedwise.dev", role="reviewer"),
    "dev-moderator": AuthUser(user_id="user-moderator", email="moderator@feedwise.dev", role="moderator"),
}


def _from_payload(payload: dict) -> AuthUser:
    user_id = payload.get("sub")
    if not user_id:
        raise AuthenticationError("Token missing 'sub' claim")

    role = payload.get("role") or payload.get("app_metadata", {}).get("role") or "student"
    email = payload.get("email") or f"{user_id}@feedwise.local"
    return AuthUser(user_id=user_id, email=email, role=role)


def verify_access_token(token: str) -> AuthUser:
    settings = get_settings()

    if settings.is_development and token in _DEV_TOKEN_MAP:
        return _DEV_TOKEN_MAP[token]

    if not settings.supabase_jwt_secret:
        raise AuthenticationError("SUPABASE_JWT_SECRET is not configured")

    try:
        payload = jwt.decode(token, settings.supabase_jwt_secret, algorithms=["HS256"])
    except JWTError as exc:
        raise AuthenticationError("Invalid or expired token") from exc

    return _from_payload(payload)
