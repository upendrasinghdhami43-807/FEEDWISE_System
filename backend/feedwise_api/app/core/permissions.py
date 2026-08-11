from app.core.dependencies import (
    require_admin,
    require_moderator_or_admin,
    require_reviewer_or_admin,
    require_teacher_or_admin,
)

__all__ = [
    "require_admin",
    "require_teacher_or_admin",
    "require_reviewer_or_admin",
    "require_moderator_or_admin",
]
