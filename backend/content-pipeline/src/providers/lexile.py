"""Reading-level measurement providers.

MOCK readability heuristics are for pipeline scaffolding only.
They are NOT licensed MetaMetrics Lexile Framework measures.
Do not invent Lexile API endpoints or auth schemes.

When licensed, implement LicensedLexileProvider using LEXILE_API_KEY /
LEXILE_API_BASE_URL from official MetaMetrics documentation.
"""

from __future__ import annotations

import os
import re
from abc import ABC, abstractmethod
from dataclasses import dataclass, field

from src.errors import NotConfiguredError


READING_BAND_ORDER = [
    "Beginner",
    "Early Reader",
    "Growing Reader",
    "Confident Reader",
]


@dataclass(frozen=True)
class ReadingLevelMeasurement:
    provider_name: str
    is_licensed_lexile: bool
    intended_band: str
    measured_estimate: int | None
    measured_band: str
    passes_intended_range: bool
    notes: list[str] = field(default_factory=list)

    def to_dict(self) -> dict:
        return {
            "providerName": self.provider_name,
            "isLicensedLexile": self.is_licensed_lexile,
            "intendedBand": self.intended_band,
            "measuredEstimate": self.measured_estimate,
            "measuredBand": self.measured_band,
            "passesIntendedRange": self.passes_intended_range,
            "notes": list(self.notes),
        }


class ReadingLevelMeasurementProvider(ABC):
    @property
    @abstractmethod
    def provider_name(self) -> str: ...

    @property
    @abstractmethod
    def is_licensed_lexile(self) -> bool: ...

    @abstractmethod
    def measure(self, passage: str, intended_reading_level: str) -> ReadingLevelMeasurement: ...


def _sentences(text: str) -> list[str]:
    parts = re.split(r"[.!?]+", text.strip())
    return [p.strip() for p in parts if p.strip()]


def _words(text: str) -> list[str]:
    return re.findall(r"[A-Za-z']+", text)


def _heuristic_metrics(passage: str) -> tuple[float, float, int, int]:
    """Return (avg sentence length, avg word length, word_count, sentence_count)."""
    sents = _sentences(passage)
    words = _words(passage)
    if not sents or not words:
        return 0.0, 0.0, 0, 0
    avg_sent = len(words) / len(sents)
    avg_word = sum(len(w) for w in words) / len(words)
    return avg_sent, avg_word, len(words), len(sents)


def _band_from_metrics(avg_sent: float, word_count: int, sent_count: int) -> str:
    """MOCK band from surface metrics — NOT a Lexile measure.

    Tuned so short decodable passages land Beginner/Early, and longer
    evidence-heavy passages land Growing/Confident.
    """
    if avg_sent <= 6.5 and sent_count <= 5 and word_count <= 45:
        return "Beginner"
    if avg_sent <= 11 and sent_count <= 7 and word_count <= 90:
        return "Early Reader"
    if avg_sent <= 18 and sent_count <= 10 and word_count <= 160:
        return "Growing Reader"
    return "Confident Reader"


def _band_index(band: str) -> int:
    try:
        return READING_BAND_ORDER.index(band)
    except ValueError:
        # Fuzzy match
        lower = band.lower()
        for i, name in enumerate(READING_BAND_ORDER):
            if name.lower() in lower or lower in name.lower():
                return i
        return 1


class MockReadabilityProvider(ReadingLevelMeasurementProvider):
    """MOCK readability estimator using sentence/word length heuristics.

    Clearly labeled MOCK — not licensed Lexile. Pass/fail allows ±1 band.
    """

    @property
    def provider_name(self) -> str:
        return "MockReadabilityProvider (NOT Lexile)"

    @property
    def is_licensed_lexile(self) -> bool:
        return False

    def measure(self, passage: str, intended_reading_level: str) -> ReadingLevelMeasurement:
        avg_sent, avg_word, word_count, sent_count = _heuristic_metrics(passage)
        measured_band = _band_from_metrics(avg_sent, word_count, sent_count)
        intended_idx = _band_index(intended_reading_level)
        measured_idx = _band_index(measured_band)
        passes = abs(measured_idx - intended_idx) <= 1
        # Arbitrary log-only estimate (not Lexile)
        estimate = int(round(avg_sent * 50 + word_count))
        notes = [
            "MOCK heuristic — not a licensed MetaMetrics Lexile measure.",
            f"avg_words_per_sentence={avg_sent:.1f}",
            f"avg_word_length={avg_word:.1f}",
            f"word_count={word_count}",
            f"sentence_count={sent_count}",
        ]
        if not passes:
            notes.append(
                f"Measured band '{measured_band}' is more than 1 step from intended '{intended_reading_level}'."
            )
        return ReadingLevelMeasurement(
            provider_name=self.provider_name,
            is_licensed_lexile=False,
            intended_band=intended_reading_level,
            measured_estimate=estimate,
            measured_band=measured_band,
            passes_intended_range=passes,
            notes=notes,
        )

class LicensedLexileProvider(ReadingLevelMeasurementProvider):
    """Stub for licensed MetaMetrics Lexile integration.

    Raises NotConfiguredError until LEXILE_API_KEY and LEXILE_API_BASE_URL
    are set from official MetaMetrics documentation. No fake endpoints.
    """

    def __init__(self, api_key: str | None = None, base_url: str | None = None) -> None:
        self._api_key = api_key if api_key is not None else os.environ.get("LEXILE_API_KEY", "")
        self._base_url = (
            base_url if base_url is not None else os.environ.get("LEXILE_API_BASE_URL", "")
        )

    @property
    def provider_name(self) -> str:
        return "LicensedLexileProvider"

    @property
    def is_licensed_lexile(self) -> bool:
        return True

    def measure(self, passage: str, intended_reading_level: str) -> ReadingLevelMeasurement:
        if not self._api_key or not self._base_url:
            raise NotConfiguredError(
                "LicensedLexileProvider requires LEXILE_API_KEY and LEXILE_API_BASE_URL "
                "from official MetaMetrics documentation. No mock Lexile endpoints are used."
            )
        # Intentionally unimplemented — fill from official docs when licensed.
        raise NotConfiguredError(
            "LicensedLexileProvider credentials are present but the MetaMetrics client "
            "is not implemented yet. Wire the official Lexile API here when licensed."
        )


def select_reading_provider() -> ReadingLevelMeasurementProvider:
    """Prefer licensed Lexile when both env vars are set; otherwise use MOCK."""
    key = os.environ.get("LEXILE_API_KEY", "").strip()
    url = os.environ.get("LEXILE_API_BASE_URL", "").strip()
    if key and url:
        return LicensedLexileProvider(api_key=key, base_url=url)
    return MockReadabilityProvider()
