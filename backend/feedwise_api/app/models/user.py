from __future__ import annotations

from typing import Literal

from pydantic import BaseModel, EmailStr


UserRole = Literal["student", "teacher", "admin", "reviewer", "moderator"]


class UserProfile(BaseModel):
    id: str
    email: EmailStr
    role: UserRole
    name: str = ""
    locale: str = "en"
    age_group: str = ""


class UserUpdateRequest(BaseModel):
    name: str | None = None
    locale: str | None = None
    age_group: str | None = None


class BaselineAssessmentRequest(BaseModel):
    answers: dict[str, int]
