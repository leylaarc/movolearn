"""Automated content quality gate for generated lessons.

Fail = not approved. Callers must retry up to MAX_GENERATION_RETRIES, then mark
the profile/skill combination unavailable and log the reason.

Mirrors the educator-style checklist used by the iOS pre-display gate, adapted
for backend structured drafts (before any child-facing delivery).
"""

from __future__ import annotations

import re
from dataclasses import dataclass, field
from typing import Any

from src.validators.math_validator import validate_math


@dataclass
class QualityCheck:
    number: int
    question: str
    passed: bool
    detail: str


@dataclass
class QualityGateResult:
    passed: bool
    checks: list[QualityCheck] = field(default_factory=list)
    reasons: list[str] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "passed": self.passed,
            "checks": [
                {
                    "number": c.number,
                    "question": c.question,
                    "passed": c.passed,
                    "detail": c.detail,
                }
                for c in self.checks
            ],
            "reasons": list(self.reasons),
        }


def _sentences(text: str) -> list[str]:
    parts = re.split(r"[.!?]+", (text or "").strip())
    return [p.strip() for p in parts if p.strip()]


def _words(text: str) -> list[str]:
    return re.findall(r"[A-Za-z']+", text or "")


def _avg_words_per_sentence(text: str) -> float:
    sents = _sentences(text)
    words = _words(text)
    if not sents or not words:
        return 0.0
    return len(words) / len(sents)


def _passage(lesson: dict[str, Any]) -> str:
    story = lesson.get("story_content") or {}
    if isinstance(story, dict) and story.get("passage"):
        return str(story["passage"])
    return str(lesson.get("reading_passage") or "")


def _reading_limits(reading_level: str) -> tuple[float, int]:
    """max avg words/sentence, max sentences."""
    band = reading_level.lower()
    if "beginner" in band:
        return 8.0, 4
    if "early" in band:
        return 12.0, 6
    if "growing" in band:
        return 18.0, 8
    return 24.0, 12


_JOKE_MARKERS = (
    "banana",
    "grocery store",
    "toaster",
    "pizza",
    "telephone",
    "sandwich",
)

_INFERENCE_MARKERS = (
    "why do you think",
    "what can you infer",
    "most likely",
    "best conclusion",
    "based on all the clues",
    "what best explains",
    "reasonably infer",
)

_IMPERATIVE_STARTERS = {
    "read", "look", "listen", "tap", "count", "draw", "write", "show", "find",
    "circle", "match", "sort", "choose", "use", "think", "compare", "point",
    "tell", "design", "create", "mark", "answer", "pick", "name", "trace",
    "check", "share", "say", "explain", "remember", "notice",
}

_COMMON_FINITE_VERBS = {
    "stand", "stands", "stood", "swish", "swishes", "swished",
    "speak", "speaks", "spoke", "say", "says", "said",
    "walk", "walks", "walked", "lead", "leads", "led",
    "guide", "guides", "guided", "watch", "watches", "watched",
    "look", "looks", "looked", "notice", "notices", "noticed",
    "explain", "explains", "explained", "compare", "compares", "compared",
    "choose", "chooses", "chose", "help", "helps", "helped",
    "rest", "rests", "rested", "move", "moves", "moved",
    "glide", "glides", "glided", "point", "points", "pointed",
    "mark", "marks", "marked", "practice", "practices", "practiced",
    "read", "reads", "share", "shares", "shared", "keep", "keeps", "kept",
    "learn", "learns", "learned", "solve", "solves", "solved",
    "swim", "swims", "swam", "find", "finds", "found",
    "munch", "munches", "munched", "wave", "waves", "waved",
    "record", "records", "recorded", "glow", "glows", "glowed",
    "begin", "begins", "began", "matter", "matters", "tap", "taps",
}


class QualityGate:
    """Automated checks — all must pass for approval."""

    def evaluate(self, lesson: dict[str, Any]) -> QualityGateResult:
        checks: list[QualityCheck] = []
        passage = _passage(lesson)
        reading = str(lesson.get("intended_reading_level") or "")
        math_level = str(lesson.get("intended_math_level") or "")
        age = str(lesson.get("intended_age") or "")
        questions = list(lesson.get("questions") or [])
        activities = list(lesson.get("activities") or [])
        instructions = str(lesson.get("instructions") or "")
        objective = str(lesson.get("learning_objective") or "")
        skill_id = str(lesson.get("standard_skill_id") or "")

        avg = _avg_words_per_sentence(passage)
        sent_count = len(_sentences(passage))
        max_avg, max_sents = _reading_limits(reading)

        # 1. Age / grade / band match (wording vs intended reading band)
        age_ok = avg <= max_avg + 4 and sent_count <= max_sents + 2 and bool(age)
        checks.append(
            QualityCheck(
                1,
                "Does this match the child’s age and grade band?",
                age_ok,
                f"avg_wps={avg:.1f} (limit~{max_avg}), sentences={sent_count}, age={age or 'missing'}",
            )
        )

        # 2. Skill level match
        level_ok = bool(reading) and bool(math_level) and bool(skill_id)
        checks.append(
            QualityCheck(
                2,
                "Does it match the intended skill level?",
                level_ok,
                f"reading={reading}, math={math_level}, skill={skill_id or 'missing'}",
            )
        )

        # 3. Accuracy / question integrity
        accuracy_ok = True
        accuracy_detail = "No structural accuracy issues"
        for q in questions:
            choices = list(q.get("choices") or [])
            corrects = list(q.get("correct_answers") or [])
            if not corrects and q.get("correctAnswer"):
                corrects = [q["correctAnswer"]]
            if choices and len(choices) != len(set(choices)):
                accuracy_ok = False
                accuracy_detail = "Duplicate choices found"
                break
            if choices and corrects and corrects[0] not in choices:
                accuracy_ok = False
                accuracy_detail = "Correct answer missing from choices"
                break
            if not corrects:
                accuracy_ok = False
                accuracy_detail = "Missing correct answer"
                break
            prompt = str(q.get("prompt") or "").strip()
            if len(prompt) < 8:
                accuracy_ok = False
                accuracy_detail = "Unclear or empty prompt"
                break
        checks.append(
            QualityCheck(3, "Is the information accurate / well-formed?", accuracy_ok, accuracy_detail)
        )

        # 4. Wording understandable
        wording_ok = avg <= max_avg + 6 and sent_count <= max_sents + 3 and bool(passage)
        checks.append(
            QualityCheck(
                4,
                "Is the wording understandable for the band?",
                wording_ok,
                f"passage_len={len(_words(passage))} words",
            )
        )

        # 5. Activity teaches intended skill
        teaches = bool(objective) and (bool(activities) or bool(questions))
        checks.append(
            QualityCheck(
                5,
                "Does the activity teach the intended skill?",
                teaches,
                objective[:120] if objective else "missing learning_objective",
            )
        )

        # 6. Questions match what was taught (passage-grounded for reading)
        reading_qs = [q for q in questions if str(q.get("subject", "")).lower() != "math"]
        hay = passage.lower()
        grounded = 0
        for q in reading_qs:
            corrects = list(q.get("correct_answers") or [])
            if not corrects and q.get("correctAnswer"):
                corrects = [q["correctAnswer"]]
            if not corrects:
                continue
            ans = str(corrects[0]).lower()
            if ans and (ans in hay or any(w in hay for w in ans.split() if len(w) > 3)):
                grounded += 1
            else:
                # Beginner sound-word answers may appear only as final token
                if ans in hay or any(tok.lower() in hay for tok in ans.split()):
                    grounded += 1
        ratio = 1.0 if not reading_qs else grounded / len(reading_qs)
        match_taught = ratio >= 0.4 or not reading_qs
        checks.append(
            QualityCheck(
                6,
                "Do the questions match what was taught?",
                match_taught,
                f"passage-grounded reading ratio={ratio:.0%}",
            )
        )

        # 7. Difficulty appropriate
        beginner = "beginner" in reading.lower()
        inference_ok = True
        if beginner:
            for q in questions:
                pl = str(q.get("prompt") or "").lower()
                if any(m in pl for m in _INFERENCE_MARKERS):
                    inference_ok = False
                    break
        choice_ok = all(
            len(q.get("choices") or []) <= (2 if beginner else 4)
            or not q.get("choices")
            for q in questions
        )
        # Beginner mock uses exactly 2 choices — enforce not too many
        if beginner:
            choice_ok = all(len(q.get("choices") or []) <= 2 for q in reading_qs) if reading_qs else True
        difficulty_ok = inference_ok and choice_ok and bool(questions)
        checks.append(
            QualityCheck(
                7,
                "Is the difficulty appropriate?",
                difficulty_ok,
                "inference/choice limits checked for band",
            )
        )

        # 8. Engaging without sacrificing education
        opening = ""
        story = lesson.get("story_content") or {}
        if isinstance(story, dict):
            opening = str(story.get("opening") or "")
        opening = opening or str(lesson.get("story_opening") or "")
        engaging = bool(opening) and bool(passage) and bool(questions)
        checks.append(
            QualityCheck(
                8,
                "Is the content engaging without sacrificing educational value?",
                engaging,
                "story + passage + practice present" if engaging else "missing story or practice",
            )
        )

        # 9. No confusing / unrelated / joke elements
        unrelated = False
        for q in questions:
            blob = " ".join(
                [str(q.get("prompt") or "")]
                + [str(c) for c in (q.get("choices") or [])]
            ).lower()
            if any(marker in blob for marker in _JOKE_MARKERS):
                unrelated = True
                break
        checks.append(
            QualityCheck(
                9,
                "Are there confusing, misleading, random, or unrelated elements?",
                not unrelated,
                "joke/unrelated markers scanned",
            )
        )

        # 10. Educator meaningfulness
        educator_ok = teaches and engaging and accuracy_ok and match_taught and wording_ok
        checks.append(
            QualityCheck(
                10,
                "Would an educator consider this a meaningful learning activity?",
                educator_ok,
                "skill + story + accurate practice aligned" if educator_ok else "needs stronger alignment",
            )
        )

        # 11. Child-facing prose quality across all lesson text
        prose_ok, prose_detail = _lesson_prose_quality_ok(lesson, opening=opening, passage=passage, instructions=instructions)
        checks.append(
            QualityCheck(
                11,
                "Is child-facing prose grammatically clean (no malformed splits)?",
                prose_ok,
                prose_detail,
            )
        )

        # 12. Instructions present
        checks.append(
            QualityCheck(
                12,
                "Are child instructions present and non-empty?",
                bool(instructions.strip()),
                instructions[:80] if instructions else "missing",
            )
        )

        # 13. Success criteria + common mistakes documented
        sc = lesson.get("success_criteria") or []
        cm = lesson.get("common_mistakes") or []
        checks.append(
            QualityCheck(
                13,
                "Are success criteria and common mistakes documented?",
                bool(sc) and bool(cm),
                f"criteria={len(sc)}, mistakes={len(cm)}",
            )
        )

        # 14. Math deterministic validation (when math questions exist)
        math_result = validate_math(lesson)
        math_qs = [q for q in questions if str(q.get("subject", "")).lower() == "math"]
        math_ok = math_result.passed if math_qs else True
        checks.append(
            QualityCheck(
                14,
                "Do math items pass deterministic validation?",
                math_ok,
                "ok" if math_ok else "; ".join(i.message for i in math_result.issues[:3]),
            )
        )

        # 15. Privacy — no PII fields leaked into lesson payload
        privacy_ok = True
        forbidden = {"child_name", "dob", "date_of_birth", "email", "phone", "parent_email"}
        flat_keys = {k.lower() for k in lesson.keys()}
        if flat_keys & forbidden:
            privacy_ok = False
        checks.append(
            QualityCheck(
                15,
                "Does the payload stay privacy-safe (no child name/DOB/contact)?",
                privacy_ok,
                "anonymous fields only" if privacy_ok else "PII keys detected",
            )
        )

        reasons = [f"{c.number}. {c.question} — {c.detail}" for c in checks if not c.passed]
        return QualityGateResult(
            passed=all(c.passed for c in checks),
            checks=checks,
            reasons=reasons,
        )


def _lesson_prose_quality_ok(
    lesson: dict[str, Any], *, opening: str, passage: str, instructions: str
) -> tuple[bool, str]:
    story = lesson.get("story_content") or {}
    ending = str(story.get("ending") or lesson.get("story_ending") or "")
    fields: list[tuple[str, str, bool]] = [
        ("instructions", instructions, True),
        ("opening", opening, False),
        ("passage", passage, False),
        ("ending", ending, False),
    ]
    for question in lesson.get("questions") or []:
        fields.append(("question", str(question.get("prompt") or ""), True))
        fields.append(("explanation", str(question.get("explanation") or ""), True))
    for label, text, allow_short_imperative in fields:
        ok, detail = _prose_quality_ok(text, allow_short_imperative=allow_short_imperative)
        if not ok:
            return False, f"{label}: {detail}"
    return True, "prose clean"


def _prose_quality_ok(text: str, *, allow_short_imperative: bool = False) -> tuple[bool, str]:
    """Reject malformed child-facing prose such as fragments and awkward clauses."""
    t = (text or "").strip()
    if not t:
        return True, "empty skipped"
    if re.search(r"\b([A-Za-z]{2,})\.\s+([a-z]{2,})\b", t):
        return False, "mid-phrase period detected (e.g. 'horse. yard')"
    if re.search(r"[.!?]\s+[a-z]", t):
        return False, "sentence begins with lowercase after punctuation"
    if re.search(r"[.!?]{2,}", t):
        return False, "repeated punctuation"
    if re.search(r"[.!?,:;][A-Za-z]", t):
        return False, "missing space after punctuation"
    if re.search(r"\b(?:saw|noticed|realized|found)\s+the\s+[A-Za-z][^.?!]{0,60}\s+looked\b", t, re.IGNORECASE):
        return False, "awkward clause construction detected"
    # One-word dangling fragments that look like hard-split leftovers
    for sent in _sentences(t):
        words = _words(sent)
        if len(words) == 1 and words[0].lower() in {
            "yard",
            "eater",
            "eaters",
            "explorers",
            "holes",
            "helpers",
            "material",
            "sound",
        }:
            return False, f"dangling fragment: {words[0]}"
        normalized = sent.strip().strip("\"'()[]{}")
        if not normalized:
            continue
        if _looks_like_question(normalized) or _looks_like_imperative(normalized, allow_short_imperative):
            continue
        if not _contains_finite_verb(normalized):
            return False, f"sentence fragment: {normalized}"
    return True, "prose clean"


def _looks_like_question(sentence: str) -> bool:
    lower = sentence.lower()
    starters = (
        "what", "why", "how", "when", "where", "who", "which",
        "is", "are", "do", "does", "did", "can", "could", "would", "should", "will",
    )
    return any(lower.startswith(f"{starter} ") or lower == starter for starter in starters)


def _looks_like_imperative(sentence: str, allow_short_imperative: bool) -> bool:
    if not allow_short_imperative:
        return False
    words = _words(sentence.lower())
    return bool(words) and words[0] in _IMPERATIVE_STARTERS


def _contains_finite_verb(sentence: str) -> bool:
    lower = sentence.lower()
    if re.search(r"\b(am|is|are|was|were|be|being|been|has|have|had|do|does|did|can|could|will|would|shall|should|may|might|must)\b", lower):
        return True
    words = _words(lower)
    if any(word in _COMMON_FINITE_VERBS for word in words):
        return True
    return bool(re.search(r"\b[A-Za-z]+'?[A-Za-z]*(ed|es)\b", lower))


def run_quality_gate(lesson: dict[str, Any]) -> QualityGateResult:
    return QualityGate().evaluate(lesson)
