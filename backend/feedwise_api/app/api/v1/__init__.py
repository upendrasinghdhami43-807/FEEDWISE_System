from fastapi import APIRouter

from app.api.v1 import academy, admin, analytics, auth, badges, community, decisions, newsroom, progress, scenarios, skills, users

router = APIRouter()
router.include_router(auth.router, prefix="/auth", tags=["auth"])
router.include_router(users.router, prefix="/users", tags=["users"])
router.include_router(scenarios.router, prefix="/scenarios", tags=["scenarios"])
router.include_router(decisions.router, prefix="/decisions", tags=["decisions"])
router.include_router(skills.router, prefix="/skills", tags=["skills"])
router.include_router(progress.router, prefix="/progress", tags=["progress"])
router.include_router(badges.router, prefix="/badges", tags=["badges"])
router.include_router(academy.router, prefix="/academy", tags=["academy"])
router.include_router(newsroom.router, prefix="/newsroom", tags=["newsroom"])
router.include_router(community.router, prefix="/community", tags=["community"])
router.include_router(analytics.router, prefix="/analytics", tags=["analytics"])
router.include_router(admin.router, prefix="/admin", tags=["admin"])
