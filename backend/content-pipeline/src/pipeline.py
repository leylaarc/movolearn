"""Content generation pipeline orchestration.

Flow:
  1. Pick skill via standards provider (MOCK CASE catalog until licensed)
  2. AI generate structured draft (MOCK until AI_API_KEY wired)
  3. Reading-level check (MOCK readability or licensed Lexile when configured)
  4. Math deterministic validation
  5. Quality gate (fail = not approved)
  6. Retry up to MAX_GENERATION_RETRIES
  7. Write approved JSON to MovoLearn/Data/ApprovedLessons/
     or append an unavailable log entry with reason

Child-facing iOS content must only load from approved output.
"""

from __future__ import annotations

import json
import os
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from src.providers.ai_generator import (
    AILessonGenerator,
    LessonGenerationRequest,
    MockAILessonGenerator,
    build_request_from_skill,
)
from src.providers.lexile import (
    MockReadabilityProvider,
    ReadingLevelMeasurementProvider,
    select_reading_provider,
)
from src.providers.quantile import MathProgressionProvider, select_math_progression_provider
from src.providers.standards import MockCASEStandardsProvider, Skill, StandardsProvider
from src.validators.math_validator import MathValidationResult, validate_math
from src.validators.quality_gate import QualityGateResult, run_quality_gate


def _repo_root() -> Path:
    # backend/content-pipeline/src/pipeline.py → repo root
    return Path(__file__).resolve().parents[3]


def default_approved_dir() -> Path:
    return _repo_root() / "MovoLearn" / "Data" / "ApprovedLessons"


def default_unavailable_log() -> Path:
    return Path(__file__).resolve().parents[1] / "logs" / "unavailable_lessons.jsonl"


def max_retries() -> int:
    raw = os.environ.get("MAX_GENERATION_RETRIES", "3")
    try:
        return max(1, int(raw))
    except ValueError:
        return 3


@dataclass
class PipelineProfile:
    """Anonymous learner profile combination for generation (no PII)."""

    age_range: str
    grade: str
    reading_level: str
    math_level: str
    interests: list[str] = field(default_factory=lambda: ["Ocean"])
    subject: str = "Reading"
    mastered_skills: list[str] = field(default_factory=list)
    practice_skills: list[str] = field(default_factory=list)
    learner_id: str | None = None
    activity_type: str = "story_practice"
    preferred_skill_id: str | None = None


@dataclass
class PipelineResult:
    status: str  # approved | unavailable
    lesson: dict[str, Any] | None
    attempts: int
    reasons: list[str] = field(default_factory=list)
    output_path: Path | None = None
    skill_id: str | None = None

    def to_dict(self) -> dict[str, Any]:
        return {
            "status": self.status,
            "attempts": self.attempts,
            "reasons": list(self.reasons),
            "outputPath": str(self.output_path) if self.output_path else None,
            "skillId": self.skill_id,
            "lessonId": (self.lesson or {}).get("id"),
        }


class ContentPipeline:
    def __init__(
        self,
        *,
        standards: StandardsProvider | None = None,
        generator: AILessonGenerator | None = None,
        reading_provider: ReadingLevelMeasurementProvider | None = None,
        math_progression: MathProgressionProvider | None = None,
        approved_dir: Path | None = None,
        unavailable_log: Path | None = None,
    ) -> None:
        self.standards = standards or MockCASEStandardsProvider()
        self.generator = generator or MockAILessonGenerator()
        self.reading_provider = reading_provider or select_reading_provider()
        self.math_progression = math_progression or select_math_progression_provider(
            self.standards
        )
        self.approved_dir = approved_dir or default_approved_dir()
        self.unavailable_log = unavailable_log or default_unavailable_log()
        self.approved_dir.mkdir(parents=True, exist_ok=True)
        self.unavailable_log.parent.mkdir(parents=True, exist_ok=True)

    def pick_skill(self, profile: PipelineProfile) -> Skill | None:
        if profile.preferred_skill_id:
            skill = self.standards.get_skill(profile.preferred_skill_id)
            if skill:
                return skill

        if profile.subject.lower() == "math":
            nxt = self.math_progression.next_skill(
                after_skill_id=None,
                math_level=profile.math_level,
                grade=profile.grade,
                mastered_ids=profile.mastered_skills,
            )
            if nxt:
                return nxt

        if hasattr(self.standards, "recommend_skill"):
            return self.standards.recommend_skill(  # type: ignore[attr-defined]
                subject=profile.subject,
                grade=profile.grade,
                mastered_ids=profile.mastered_skills,
                practice_ids=profile.practice_skills,
            )

        skills = self.standards.list_skills(subject=profile.subject, grade=profile.grade)
        return skills[0] if skills else None

    def run(self, profile: PipelineProfile) -> PipelineResult:
        skill = self.pick_skill(profile)
        if not skill:
            reason = f"No skill found for subject={profile.subject} grade={profile.grade}"
            self._log_unavailable(profile, None, [reason], attempts=0)
            return PipelineResult(
                status="unavailable",
                lesson=None,
                attempts=0,
                reasons=[reason],
                skill_id=None,
            )

        retries = max_retries()
        last_reasons: list[str] = []
        last_lesson: dict[str, Any] | None = None

        for attempt in range(1, retries + 1):
            request = build_request_from_skill(
                skill,
                age_range=profile.age_range,
                grade=profile.grade,
                reading_level=profile.reading_level,
                math_level=profile.math_level,
                interests=profile.interests,
                mastered_skills=profile.mastered_skills,
                practice_skills=profile.practice_skills,
                learner_id=profile.learner_id or f"anon_{profile.grade}_{attempt:02d}_x9k2",
                activity_type=profile.activity_type,
            )
            # Slight interest rotation on retry to vary mock content theme
            if attempt > 1 and profile.interests:
                rotated = profile.interests[attempt % len(profile.interests) :] + profile.interests[
                    : attempt % len(profile.interests)
                ]
                request.interests = rotated or profile.interests

            draft = self.generator.generate(request)
            last_lesson = draft

            passage = ""
            story = draft.get("story_content") or {}
            if isinstance(story, dict):
                passage = str(story.get("passage") or "")
            passage = passage or str(draft.get("reading_passage") or "")

            reading_measure = self.reading_provider.measure(
                passage, draft.get("intended_reading_level") or profile.reading_level
            )
            draft["reading_measurement"] = reading_measure.to_dict()

            reasons: list[str] = []
            if not reading_measure.passes_intended_range:
                reasons.append(
                    "Reading level check failed: "
                    + "; ".join(reading_measure.notes)
                )

            math_result: MathValidationResult = validate_math(draft)
            draft["math_validation"] = math_result.to_dict()
            if not math_result.passed:
                reasons.extend(
                    f"Math: {i.message}" for i in math_result.issues
                )

            gate: QualityGateResult = run_quality_gate(draft)
            draft["quality_gate"] = gate.to_dict()
            if not gate.passed:
                reasons.extend(gate.reasons)

            if not reasons:
                draft["approval_status"] = "approved"
                draft["approved_at"] = datetime.now(timezone.utc).isoformat()
                path = self._write_approved(draft, profile, skill)
                return PipelineResult(
                    status="approved",
                    lesson=draft,
                    attempts=attempt,
                    reasons=[],
                    output_path=path,
                    skill_id=skill.identifier,
                )

            last_reasons = reasons
            draft["approval_status"] = "pendingValidation"

        # Exhausted retries
        self._log_unavailable(profile, skill, last_reasons, attempts=retries, lesson=last_lesson)
        return PipelineResult(
            status="unavailable",
            lesson=last_lesson,
            attempts=retries,
            reasons=last_reasons,
            skill_id=skill.identifier,
        )

    def _write_approved(
        self, lesson: dict[str, Any], profile: PipelineProfile, skill: Skill
    ) -> Path:
        safe_theme = str(lesson.get("theme") or "lesson").lower().replace(" ", "-")
        safe_skill = skill.identifier.replace(".", "-")
        reading = str(lesson.get("intended_reading_level") or "reading").lower().replace(" ", "-")
        math = str(lesson.get("intended_math_level") or "math").lower().replace(" ", "-")
        filename = f"{safe_theme}_{safe_skill}_{reading}_{math}.json"
        path = self.approved_dir / filename
        payload = {
            **lesson,
            "contentSource": "backend_content_pipeline",
            "providers": {
                "standards": self.standards.provider_name,
                "ai": self.generator.provider_name,
                "reading": self.reading_provider.provider_name,
                "mathProgression": self.math_progression.provider_name,
            },
            "profile": {
                "ageRange": profile.age_range,
                "grade": profile.grade,
                "readingLevel": profile.reading_level,
                "mathLevel": profile.math_level,
                "interests": profile.interests,
                "learnerId": profile.learner_id,
            },
        }
        path.write_text(json.dumps(payload, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        return path

    def _log_unavailable(
        self,
        profile: PipelineProfile,
        skill: Skill | None,
        reasons: list[str],
        *,
        attempts: int,
        lesson: dict[str, Any] | None = None,
    ) -> None:
        entry = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "status": "unavailable",
            "attempts": attempts,
            "skillId": skill.identifier if skill else None,
            "profile": {
                "ageRange": profile.age_range,
                "grade": profile.grade,
                "readingLevel": profile.reading_level,
                "mathLevel": profile.math_level,
                "subject": profile.subject,
                "interests": profile.interests,
                "learnerId": profile.learner_id,
            },
            "reasons": reasons,
            "lessonId": (lesson or {}).get("id"),
        }
        with self.unavailable_log.open("a", encoding="utf-8") as fh:
            fh.write(json.dumps(entry, ensure_ascii=False) + "\n")
