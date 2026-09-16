"""CASE / 1EdTech standards provider — MOCK until real CASE Network credentials exist.

Do not invent CASE Network API endpoints or auth schemes here.
When licensed, replace MockCASEStandardsProvider with a real client using
CASE_API_KEY / CASE_API_BASE_URL from official 1EdTech documentation.
"""

from __future__ import annotations

import json
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any


@dataclass(frozen=True)
class Skill:
    """CASE-aligned skill with CFItem-like fields."""

    identifier: str
    full_statement: str
    human_coding_scheme: str
    education_level: list[str]
    subject: str
    cf_item_type: str
    prerequisite_ids: list[str] = field(default_factory=list)
    related_ids: list[str] = field(default_factory=list)

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> Skill:
        return cls(
            identifier=data["identifier"],
            full_statement=data["fullStatement"],
            human_coding_scheme=data["humanCodingScheme"],
            education_level=list(data.get("educationLevel") or []),
            subject=data["subject"],
            cf_item_type=data.get("CFItemType", "Skill"),
            prerequisite_ids=list(data.get("prerequisiteIds") or []),
            related_ids=list(data.get("relatedIds") or []),
        )

    def to_dict(self) -> dict[str, Any]:
        return {
            "identifier": self.identifier,
            "fullStatement": self.full_statement,
            "humanCodingScheme": self.human_coding_scheme,
            "educationLevel": self.education_level,
            "subject": self.subject,
            "CFItemType": self.cf_item_type,
            "prerequisiteIds": self.prerequisite_ids,
            "relatedIds": self.related_ids,
        }


class StandardsProvider(ABC):
    """Abstract educational standards provider (CASE Network when licensed)."""

    @property
    @abstractmethod
    def provider_name(self) -> str: ...

    @property
    @abstractmethod
    def is_live_case_integration(self) -> bool: ...

    @abstractmethod
    def list_skills(self, subject: str | None = None, grade: str | None = None) -> list[Skill]: ...

    @abstractmethod
    def get_skill(self, skill_id: str) -> Skill | None: ...

    @abstractmethod
    def prerequisites(self, skill_id: str) -> list[Skill]: ...

    @abstractmethod
    def related_skills(self, skill_id: str) -> list[Skill]: ...


def _normalize_grade(grade: str | None) -> str | None:
    if not grade:
        return None
    g = grade.strip().upper().replace("GRADE ", "").replace("PREK", "PRE-K")
    if g in {"PRE-K", "PREK", "PK"}:
        return "Pre-K"
    if g in {"KINDERGARTEN", "KINDER", "K"}:
        return "K"
    if g.startswith("1"):
        return "1"
    if g.startswith("2"):
        return "2"
    if g.startswith("3"):
        return "3"
    return g


class MockCASEStandardsProvider(StandardsProvider):
    """Temporary local CASE-shaped catalog until real CASE Network credentials are available.

    Loads CFItem-like records from ``src/skills/case_mock_skills.json``.
    This is NOT a live CASE Network client.
    """

    def __init__(self, skills_path: Path | None = None) -> None:
        default = Path(__file__).resolve().parent.parent / "skills" / "case_mock_skills.json"
        self._path = skills_path or default
        self._skills: dict[str, Skill] = {}
        self._load()

    @property
    def provider_name(self) -> str:
        return "MockCASEStandardsProvider"

    @property
    def is_live_case_integration(self) -> bool:
        return False

    def _load(self) -> None:
        raw = json.loads(self._path.read_text(encoding="utf-8"))
        for item in raw.get("skills", []):
            skill = Skill.from_dict(item)
            self._skills[skill.identifier] = skill

    def list_skills(self, subject: str | None = None, grade: str | None = None) -> list[Skill]:
        grade_norm = _normalize_grade(grade)
        results: list[Skill] = []
        for skill in self._skills.values():
            if subject and skill.subject.lower() != subject.lower():
                continue
            if grade_norm and grade_norm not in skill.education_level:
                # Allow Pre-K to match K band loosely
                if not (grade_norm == "Pre-K" and "K" in skill.education_level):
                    continue
            results.append(skill)
        return sorted(results, key=lambda s: s.identifier)

    def get_skill(self, skill_id: str) -> Skill | None:
        return self._skills.get(skill_id)

    def prerequisites(self, skill_id: str) -> list[Skill]:
        skill = self.get_skill(skill_id)
        if not skill:
            return []
        return [s for sid in skill.prerequisite_ids if (s := self.get_skill(sid))]

    def related_skills(self, skill_id: str) -> list[Skill]:
        skill = self.get_skill(skill_id)
        if not skill:
            return []
        return [s for sid in skill.related_ids if (s := self.get_skill(sid))]

    def recommend_skill(
        self,
        subject: str,
        grade: str,
        mastered_ids: list[str] | None = None,
        practice_ids: list[str] | None = None,
    ) -> Skill | None:
        """Pick a skill that needs practice, else the next unmastered skill in band."""
        mastered = set(mastered_ids or [])
        practice = list(practice_ids or [])
        for pid in practice:
            skill = self.get_skill(pid)
            if skill and skill.subject.lower() == subject.lower():
                return skill
        candidates = self.list_skills(subject=subject, grade=grade)
        for skill in candidates:
            if skill.identifier in mastered:
                continue
            prereqs = skill.prerequisite_ids
            if all(p in mastered for p in prereqs) or not prereqs:
                return skill
        return candidates[0] if candidates else None
