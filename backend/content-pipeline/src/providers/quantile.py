"""Math progression providers (Quantile-aligned when licensed).

MOCK progression uses local skill order only.
It does NOT invent Quantile measures from age, and Quantile does NOT
auto-verify math answers — answer checking stays in math_validator.

Do not invent Quantile API endpoints or auth schemes.
When licensed, implement LicensedQuantileProvider using QUANTILE_API_KEY /
QUANTILE_API_BASE_URL from official MetaMetrics documentation.
"""

from __future__ import annotations

import os
from abc import ABC, abstractmethod

from src.errors import NotConfiguredError
from src.providers.standards import MockCASEStandardsProvider, Skill, StandardsProvider


MATH_LEVEL_ORDER = ["Emerging", "Developing", "Secure", "Advancing"]

# Local progression order for MOCK Quantile-aligned sequencing (skill ids).
MOCK_MATH_PROGRESSION: list[str] = [
    "movo.math.counting.k",
    "movo.math.comparing.k",
    "movo.math.add-sub-10.1",
    "movo.math.add-sub-20.1",
    "movo.math.place-value.1",
    "movo.math.measurement.2",
    "movo.math.geometry.2",
    "movo.math.multi-step.2",
    "movo.math.mult-div.3",
    "movo.math.fractions.3",
]

# Which progression indices are appropriate per math level band.
MATH_LEVEL_INDEX_RANGE: dict[str, tuple[int, int]] = {
    "Emerging": (0, 2),
    "Developing": (1, 4),
    "Secure": (3, 7),
    "Advancing": (6, 9),
}


class MathProgressionProvider(ABC):
    """Skill ordering / next skill / prerequisites for math progression.

    Note: Quantile Framework (when licensed) supports measure-based progression
    planning. It does **not** automatically verify whether a child's math answer
    is correct — that remains a deterministic validator concern.
    """

    @property
    @abstractmethod
    def provider_name(self) -> str: ...

    @property
    @abstractmethod
    def is_licensed_quantile(self) -> bool: ...

    @abstractmethod
    def ordered_skills(self, math_level: str, grade: str) -> list[Skill]: ...

    @abstractmethod
    def next_skill(
        self,
        after_skill_id: str | None,
        math_level: str,
        grade: str,
        mastered_ids: list[str],
    ) -> Skill | None: ...

    @abstractmethod
    def prerequisites_ready(self, skill_id: str, mastered_ids: list[str]) -> bool: ...


class MockQuantileAlignedProgression(MathProgressionProvider):
    """MOCK local skill order — does NOT invent Quantile scores from age.

    Uses the CASE mock math skill catalog for statements/prerequisites.
    Clearly labeled MOCK — not licensed MetaMetrics Quantile.
    """

    def __init__(self, standards: StandardsProvider | None = None) -> None:
        self._standards = standards or MockCASEStandardsProvider()

    @property
    def provider_name(self) -> str:
        return "MockQuantileAlignedProgression (NOT Quantile)"

    @property
    def is_licensed_quantile(self) -> bool:
        return False

    def _normalize_level(self, math_level: str) -> str:
        for name in MATH_LEVEL_ORDER:
            if name.lower() == math_level.lower():
                return name
        return "Developing"

    def ordered_skills(self, math_level: str, grade: str) -> list[Skill]:
        level = self._normalize_level(math_level)
        lo, hi = MATH_LEVEL_INDEX_RANGE.get(level, (0, len(MOCK_MATH_PROGRESSION) - 1))
        skills: list[Skill] = []
        for sid in MOCK_MATH_PROGRESSION[lo : hi + 1]:
            skill = self._standards.get_skill(sid)
            if skill:
                skills.append(skill)
        _ = grade  # grade filtering remains standards-side when licensed
        return skills

    def next_skill(
        self,
        after_skill_id: str | None,
        math_level: str,
        grade: str,
        mastered_ids: list[str],
    ) -> Skill | None:
        mastered = set(mastered_ids)
        ordered = self.ordered_skills(math_level, grade)
        if after_skill_id:
            ids = [s.identifier for s in ordered]
            if after_skill_id in ids:
                start = ids.index(after_skill_id) + 1
                ordered = ordered[start:]
        for skill in ordered:
            if skill.identifier in mastered:
                continue
            if self.prerequisites_ready(skill.identifier, list(mastered)):
                return skill
        return None

    def prerequisites_ready(self, skill_id: str, mastered_ids: list[str]) -> bool:
        skill = self._standards.get_skill(skill_id)
        if not skill:
            return False
        mastered = set(mastered_ids)
        return all(p in mastered for p in skill.prerequisite_ids)


class LicensedQuantileProvider(MathProgressionProvider):
    """Stub for licensed MetaMetrics Quantile Framework integration.

    Raises NotConfiguredError until QUANTILE_API_KEY and QUANTILE_API_BASE_URL
    are set from official MetaMetrics documentation. No fake endpoints.

    Quantile measures support progression planning; they do not auto-verify
    math answers.
    """

    def __init__(self, api_key: str | None = None, base_url: str | None = None) -> None:
        self._api_key = api_key if api_key is not None else os.environ.get("QUANTILE_API_KEY", "")
        self._base_url = (
            base_url if base_url is not None else os.environ.get("QUANTILE_API_BASE_URL", "")
        )
        self._fallback = MockQuantileAlignedProgression()

    @property
    def provider_name(self) -> str:
        return "LicensedQuantileProvider"

    @property
    def is_licensed_quantile(self) -> bool:
        return True

    def _ensure_configured(self) -> None:
        if not self._api_key or not self._base_url:
            raise NotConfiguredError(
                "LicensedQuantileProvider requires QUANTILE_API_KEY and QUANTILE_API_BASE_URL "
                "from official MetaMetrics documentation. No mock Quantile endpoints are used. "
                "Note: Quantile does not auto-verify math answers."
            )
        raise NotConfiguredError(
            "LicensedQuantileProvider credentials are present but the MetaMetrics client "
            "is not implemented yet. Wire the official Quantile API here when licensed."
        )

    def ordered_skills(self, math_level: str, grade: str) -> list[Skill]:
        self._ensure_configured()
        return []  # pragma: no cover

    def next_skill(
        self,
        after_skill_id: str | None,
        math_level: str,
        grade: str,
        mastered_ids: list[str],
    ) -> Skill | None:
        self._ensure_configured()
        return None  # pragma: no cover

    def prerequisites_ready(self, skill_id: str, mastered_ids: list[str]) -> bool:
        self._ensure_configured()
        return False  # pragma: no cover


def select_math_progression_provider(
    standards: StandardsProvider | None = None,
) -> MathProgressionProvider:
    key = os.environ.get("QUANTILE_API_KEY", "").strip()
    url = os.environ.get("QUANTILE_API_BASE_URL", "").strip()
    if key and url:
        return LicensedQuantileProvider(api_key=key, base_url=url)
    return MockQuantileAlignedProgression(standards=standards)
