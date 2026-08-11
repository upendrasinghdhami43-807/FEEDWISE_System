from __future__ import annotations

from fastapi import Depends, Request
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from app.core.exceptions import AuthenticationError, AuthorizationError
from app.core.security import AuthUser, verify_access_token
from app.repositories.data_store import InMemoryStore
from app.repositories.user_repository import UserRepository

bearer_scheme = HTTPBearer(auto_error=False)


async def get_store(request: Request) -> InMemoryStore:
    return request.app.state.store


async def get_current_user(
    credentials: HTTPAuthorizationCredentials | None = Depends(bearer_scheme),
    store: InMemoryStore = Depends(get_store),
) -> AuthUser:
    if credentials is None:
        raise AuthenticationError("Missing bearer token")

    user = verify_access_token(credentials.credentials)
    user_repo = UserRepository(store)
    user_repo.ensure_user_exists(user.user_id, user.email, user.role)
    return user


def require_roles(*allowed_roles: str):
    async def dependency(current_user: AuthUser = Depends(get_current_user)) -> AuthUser:
        if current_user.role not in allowed_roles:
            raise AuthorizationError("You do not have permission for this action")
        return current_user

    return dependency


async def require_admin(user: AuthUser = Depends(require_roles("admin"))) -> AuthUser:
    return user


async def require_teacher_or_admin(
    user: AuthUser = Depends(require_roles("teacher", "admin")),
) -> AuthUser:
    return user


async def require_reviewer_or_admin(
    user: AuthUser = Depends(require_roles("reviewer", "admin")),
) -> AuthUser:
    return user


async def require_moderator_or_admin(
    user: AuthUser = Depends(require_roles("moderator", "admin")),
) -> AuthUser:
    return user
