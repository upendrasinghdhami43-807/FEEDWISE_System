from __future__ import annotations

from app.config.settings import get_settings


class AIService:
    def generate_feedback(self, *, is_correct: bool, process_score: int) -> str:
        settings = get_settings()
        if not settings.ai_enabled:
            if is_correct:
                return "Good judgment. Keep applying structured verification steps."
            return "Your conclusion needs improvement. Review source and evidence checks."

        if is_correct and process_score >= 80:
            return "Excellent work. You verified evidence thoroughly before deciding."
        if is_correct:
            return "Correct decision. Next time, add more verification steps for stronger confidence."
        if process_score >= 60:
            return "Strong process, but the final action was off. Recheck conflicting evidence."
        return "Try opening the investigation panel and checking source + cross-source evidence first."
