from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime, timezone


def _now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


@dataclass
class InMemoryStore:
    users: dict[str, dict] = field(default_factory=dict)
    scenarios: dict[str, dict] = field(default_factory=dict)
    decisions: list[dict] = field(default_factory=list)
    skills: dict[str, dict] = field(default_factory=dict)
    skill_history: dict[str, list[dict]] = field(default_factory=dict)
    progress: dict[str, dict] = field(default_factory=dict)
    badges: dict[str, dict] = field(default_factory=dict)
    user_badges: dict[str, set[str]] = field(default_factory=dict)
    academy_modules: dict[str, dict] = field(default_factory=dict)
    lessons: dict[str, dict] = field(default_factory=dict)
    lesson_completions: set[tuple[str, str]] = field(default_factory=set)
    community_submissions: list[dict] = field(default_factory=list)
    class_rosters: dict[str, list[str]] = field(default_factory=dict)

    @classmethod
    def with_seed_data(cls) -> "InMemoryStore":
        store = cls()

        store.users = {
            "user-student": {
                "id": "user-student",
                "email": "student@feedwise.dev",
                "role": "student",
                "name": "Student One",
                "locale": "en",
                "age_group": "13-15",
                "created_at": _now_iso(),
            },
            "user-teacher": {
                "id": "user-teacher",
                "email": "teacher@feedwise.dev",
                "role": "teacher",
                "name": "Teacher One",
                "locale": "en",
                "age_group": "adult",
                "created_at": _now_iso(),
            },
            "user-admin": {
                "id": "user-admin",
                "email": "admin@feedwise.dev",
                "role": "admin",
                "name": "Admin One",
                "locale": "en",
                "age_group": "adult",
                "created_at": _now_iso(),
            },
            "user-reviewer": {
                "id": "user-reviewer",
                "email": "reviewer@feedwise.dev",
                "role": "reviewer",
                "name": "Reviewer One",
                "locale": "en",
                "age_group": "adult",
                "created_at": _now_iso(),
            },
            "user-moderator": {
                "id": "user-moderator",
                "email": "moderator@feedwise.dev",
                "role": "moderator",
                "name": "Moderator One",
                "locale": "en",
                "age_group": "adult",
                "created_at": _now_iso(),
            },
        }

        base_skill = {
            "source_verification": 52,
            "evidence_evaluation": 48,
            "ai_literacy": 44,
            "bias_detection": 46,
            "digital_safety": 50,
        }
        for user_id in store.users:
            store.skills[user_id] = base_skill.copy()
            store.skill_history[user_id] = [
                {
                    "timestamp": _now_iso(),
                    "scores": base_skill.copy(),
                }
            ]
            store.progress[user_id] = {
                "xp": 120,
                "level": 2,
                "streak": 1,
                "last_activity_date": datetime.now(timezone.utc).date().isoformat(),
                "updated_at": _now_iso(),
            }
            store.user_badges[user_id] = set()

        store.badges = {
            "source_detective": {
                "id": "source_detective",
                "name": "Source Detective",
                "description": "Checked source details in 5 decisions.",
                "icon": "magnifier",
            },
            "evidence_hunter": {
                "id": "evidence_hunter",
                "name": "Evidence Hunter",
                "description": "Used all major evidence checks in 3 scenarios.",
                "icon": "evidence",
            },
            "streak_starter": {
                "id": "streak_starter",
                "name": "Streak Starter",
                "description": "Maintained a 3-day learning streak.",
                "icon": "flame",
            },
            "streak_champion": {
                "id": "streak_champion",
                "name": "Streak Champion",
                "description": "Maintained a 7-day learning streak.",
                "icon": "fireworks",
            },
            "mil_scholar": {
                "id": "mil_scholar",
                "name": "MIL Scholar",
                "description": "Reached level 5.",
                "icon": "graduation_cap",
            },
            "community_contributor": {
                "id": "community_contributor",
                "name": "Community Contributor",
                "description": "Submitted one community challenge.",
                "icon": "community",
            },
            "quick_verifier": {
                "id": "quick_verifier",
                "name": "Quick Verifier",
                "description": "Submitted 10 VERIFY decisions.",
                "icon": "check_shield",
            },
            "ai_aware": {
                "id": "ai_aware",
                "name": "AI Aware",
                "description": "Completed an AI literacy lesson.",
                "icon": "cpu",
            },
        }

        store.academy_modules = {
            "mod-source": {
                "id": "mod-source",
                "title": "Source Verification Basics",
                "description": "How to validate source credibility quickly.",
                "icon": "magnifier",
                "skill_dimension": "source_verification",
                "lesson_ids": ["lesson-source-1", "lesson-source-2"],
            },
            "mod-ai": {
                "id": "mod-ai",
                "title": "AI Literacy Essentials",
                "description": "Recognize generated media and synthetic claims.",
                "icon": "cpu",
                "skill_dimension": "ai_literacy",
                "lesson_ids": ["lesson-ai-1"],
            },
        }

        store.lessons = {
            "lesson-source-1": {
                "id": "lesson-source-1",
                "module_id": "mod-source",
                "title": "Who published this?",
                "content": "Always inspect author profile and about page before sharing.",
                "tips": [
                    "Check source transparency",
                    "Check if contact info exists",
                    "Cross-check domain reputation",
                ],
                "skill": "source_verification",
                "order": 1,
                "quiz": {
                    "question": "What should you check first?",
                    "options": ["Headline only", "Source and author", "Comments section"],
                    "answer": 1,
                },
            },
            "lesson-source-2": {
                "id": "lesson-source-2",
                "module_id": "mod-source",
                "title": "Date and context checks",
                "content": "Old stories often resurface without context.",
                "tips": ["Read publication date", "Compare timeline", "Check updates"],
                "skill": "source_verification",
                "order": 2,
                "quiz": {
                    "question": "Why does date matter?",
                    "options": ["It does not", "It helps verify relevance", "It boosts likes"],
                    "answer": 1,
                },
            },
            "lesson-ai-1": {
                "id": "lesson-ai-1",
                "module_id": "mod-ai",
                "title": "Spotting synthetic media",
                "content": "AI images often reveal artifacts in shadows, hands, or text.",
                "tips": ["Zoom image details", "Look for repeated textures", "Use reverse image search"],
                "skill": "ai_literacy",
                "order": 1,
                "quiz": {
                    "question": "A clue for synthetic media is:",
                    "options": ["Consistent metadata", "Visual artifacts", "Verified source chain"],
                    "answer": 1,
                },
            },
        }

        scenarios = [
            {
                "id": "scn-001",
                "title": "Breaking: Miracle cure goes viral",
                "headline": "Miracle herb cures all flu strains overnight",
                "body": "A post claims a local herb can cure all flu strains instantly.",
                "claim": "Miracle herb cures all flu strains overnight",
                "category": "health",
                "difficulty": "beginner",
                "language": "en",
                "status": "published",
                "is_trending": True,
                "is_daily_challenge": True,
                "target_skill": "evidence_evaluation",
                "created_at": "2026-07-29T08:00:00+00:00",
                "correct_decision": "verify",
                "source_signals": {"transparency": "LIMITED", "author_known": False, "contact_available": False},
                "date_signals": {"status": "VERIFIABLE", "notes": "No scientific publication date provided."},
                "evidence": [
                    {"id": "ev-001-1", "category": "primary_source", "status": "MISSING", "label": "Clinical trial link", "value": "None", "explanation": "No valid study link included."},
                    {"id": "ev-001-2", "category": "cross_source", "status": "WEAK", "label": "Independent reports", "value": "One low-trust blog", "explanation": "No trusted publication corroboration."},
                ],
                "consequences": {
                    "share": {"reach_count": 1200, "shares_count": 260, "credibility_delta": -20, "impact_text": "Misinformation spread increased.", "missed_clues": ["No source", "No evidence"], "recommendation": "Verify health claims with medical authorities."},
                    "verify": {"reach_count": 150, "shares_count": 20, "credibility_delta": 14, "impact_text": "Harmful spread was prevented.", "missed_clues": [], "recommendation": "Good verification process."},
                    "report": {"reach_count": 90, "shares_count": 8, "credibility_delta": 10, "impact_text": "Platform moderation reduced impact.", "missed_clues": [], "recommendation": "Useful when evidence is missing."},
                    "ignore": {"reach_count": 700, "shares_count": 140, "credibility_delta": -6, "impact_text": "Claim continued to circulate.", "missed_clues": ["No corrective action"], "recommendation": "Verify and report high-risk claims."},
                },
                "lesson_id": "lesson-source-1",
            },
            {
                "id": "scn-002",
                "title": "Election quote out of context",
                "headline": "Candidate admits vote tampering in leaked clip",
                "body": "A clipped video appears to show a candidate admitting fraud.",
                "claim": "Candidate admitted vote tampering",
                "category": "politics",
                "difficulty": "intermediate",
                "language": "en",
                "status": "published",
                "is_trending": True,
                "is_daily_challenge": False,
                "target_skill": "bias_detection",
                "created_at": "2026-07-28T10:20:00+00:00",
                "correct_decision": "verify",
                "source_signals": {"transparency": "UNKNOWN", "author_known": True, "contact_available": False},
                "date_signals": {"status": "VERIFIABLE", "notes": "Original stream available from 2019 archive."},
                "evidence": [
                    {"id": "ev-002-1", "category": "cross_source", "status": "CONTRADICTS", "label": "Full speech context", "value": "Archive full video", "explanation": "Clip omits clarifying sentence."},
                    {"id": "ev-002-2", "category": "language", "status": "WEAK", "label": "Loaded framing", "value": "Emotionally charged caption", "explanation": "Caption uses certainty language."},
                ],
                "consequences": {
                    "share": {"reach_count": 1600, "shares_count": 310, "credibility_delta": -18, "impact_text": "Polarization increased across groups.", "missed_clues": ["Out-of-context clip"], "recommendation": "Compare with full-length source."},
                    "verify": {"reach_count": 180, "shares_count": 25, "credibility_delta": 16, "impact_text": "False framing was corrected.", "missed_clues": [], "recommendation": "Context check worked well."},
                    "report": {"reach_count": 120, "shares_count": 16, "credibility_delta": 12, "impact_text": "Misleading clip was flagged.", "missed_clues": [], "recommendation": "Reporting plus correction is strong."},
                    "ignore": {"reach_count": 980, "shares_count": 212, "credibility_delta": -8, "impact_text": "Rumor remained active.", "missed_clues": ["No intervention"], "recommendation": "Engage with evidence next time."},
                },
                "lesson_id": "lesson-source-2",
            },
            {
                "id": "scn-003",
                "title": "Deepfake celebrity endorsement",
                "headline": "Celebrity endorses fake investment app",
                "body": "A viral video shows a celebrity promising quick wealth.",
                "claim": "Celebrity endorses investment app",
                "category": "ai",
                "difficulty": "advanced",
                "language": "en",
                "status": "published",
                "is_trending": False,
                "is_daily_challenge": False,
                "target_skill": "ai_literacy",
                "created_at": "2026-07-27T13:40:00+00:00",
                "correct_decision": "report",
                "source_signals": {"transparency": "UNKNOWN", "author_known": False, "contact_available": False},
                "date_signals": {"status": "UNVERIFIABLE", "notes": "No trusted source posted original clip."},
                "evidence": [
                    {"id": "ev-003-1", "category": "primary_source", "status": "MISSING", "label": "Official statement", "value": "None", "explanation": "No official confirmation available."},
                    {"id": "ev-003-2", "category": "language", "status": "WEAK", "label": "Urgency trigger", "value": "Act now before midnight", "explanation": "Classic scam pressure language."},
                ],
                "consequences": {
                    "share": {"reach_count": 2200, "shares_count": 480, "credibility_delta": -25, "impact_text": "Financial scam exposure increased.", "missed_clues": ["Deepfake artifacts", "Urgency scam cues"], "recommendation": "Report synthetic scam content immediately."},
                    "verify": {"reach_count": 230, "shares_count": 31, "credibility_delta": 8, "impact_text": "Spread slowed but scam listing remained.", "missed_clues": ["Should also report"], "recommendation": "Verification is good, combine with report."},
                    "report": {"reach_count": 140, "shares_count": 10, "credibility_delta": 18, "impact_text": "Scam post removal was accelerated.", "missed_clues": [], "recommendation": "Best response for harmful deepfake scams."},
                    "ignore": {"reach_count": 1500, "shares_count": 320, "credibility_delta": -10, "impact_text": "Scam remained visible and persuasive.", "missed_clues": ["No protective action"], "recommendation": "Report and warn peers about scams."},
                },
                "lesson_id": "lesson-ai-1",
            },
            {
                "id": "scn-004",
                "title": "Flood footage reused",
                "headline": "Current city flood video actually from 2018",
                "body": "Old disaster footage is presented as current breaking news.",
                "claim": "Video shows current city flood",
                "category": "disaster",
                "difficulty": "easy",
                "language": "en",
                "status": "published",
                "is_trending": False,
                "is_daily_challenge": False,
                "target_skill": "source_verification",
                "created_at": "2026-07-26T09:10:00+00:00",
                "correct_decision": "verify",
                "source_signals": {"transparency": "LIMITED", "author_known": False, "contact_available": False},
                "date_signals": {"status": "OLD_CONTENT", "notes": "Reverse image search links to 2018 post."},
                "evidence": [
                    {"id": "ev-004-1", "category": "cross_source", "status": "CONTRADICTS", "label": "Archive match", "value": "2018 footage", "explanation": "Metadata and source mismatch current event."},
                ],
                "consequences": {
                    "share": {"reach_count": 980, "shares_count": 200, "credibility_delta": -14, "impact_text": "Panic increased due to false timeline.", "missed_clues": ["Ignored date mismatch"], "recommendation": "Check original upload date."},
                    "verify": {"reach_count": 110, "shares_count": 12, "credibility_delta": 12, "impact_text": "Timeline correction reduced panic.", "missed_clues": [], "recommendation": "Good time-context verification."},
                    "report": {"reach_count": 85, "shares_count": 9, "credibility_delta": 9, "impact_text": "Misleading post was flagged.", "missed_clues": [], "recommendation": "Useful for repeated misinformation."},
                    "ignore": {"reach_count": 500, "shares_count": 100, "credibility_delta": -5, "impact_text": "Confusion persisted among peers.", "missed_clues": ["No correction"], "recommendation": "Verify and share correction."},
                },
                "lesson_id": "lesson-source-2",
            },
            {
                "id": "scn-005",
                "title": "Data privacy app rumor",
                "headline": "Messaging app leaks all private chats",
                "body": "A post claims a major messaging app now publicly leaks chats.",
                "claim": "Messaging app leaks all chats",
                "category": "technology",
                "difficulty": "intermediate",
                "language": "en",
                "status": "published",
                "is_trending": True,
                "is_daily_challenge": False,
                "target_skill": "digital_safety",
                "created_at": "2026-07-25T16:45:00+00:00",
                "correct_decision": "verify",
                "source_signals": {"transparency": "CLEAR", "author_known": True, "contact_available": True},
                "date_signals": {"status": "VERIFIABLE", "notes": "Company issued formal incident update."},
                "evidence": [
                    {"id": "ev-005-1", "category": "primary_source", "status": "SUPPORTS", "label": "Official security advisory", "value": "Limited bug disclosure", "explanation": "Issue affected backups, not all chats."},
                ],
                "consequences": {
                    "share": {"reach_count": 1400, "shares_count": 260, "credibility_delta": -12, "impact_text": "Overstated panic reduced trust.", "missed_clues": ["Misread advisory scope"], "recommendation": "Read official disclosure fully."},
                    "verify": {"reach_count": 170, "shares_count": 20, "credibility_delta": 15, "impact_text": "Accurate context helped users respond safely.", "missed_clues": [], "recommendation": "Strong digital safety behavior."},
                    "report": {"reach_count": 95, "shares_count": 11, "credibility_delta": 6, "impact_text": "Report processed but content not removed.", "missed_clues": ["Claim partly true"], "recommendation": "Prefer nuanced verification for mixed claims."},
                    "ignore": {"reach_count": 600, "shares_count": 120, "credibility_delta": -4, "impact_text": "Friends remained confused.", "missed_clues": ["Missed chance to clarify"], "recommendation": "Share evidence-based context."},
                },
                "lesson_id": "lesson-source-1",
            },
        ]

        store.scenarios = {item["id"]: item for item in scenarios}

        store.class_rosters = {
            "class-1": ["user-student"],
        }

        return store
