"""Deterministic math content validation.

Quantile (when licensed) does not auto-verify answers — this module does.
Reject on failure; do not soft-pass incorrect math.
"""

from __future__ import annotations

import re
from dataclasses import dataclass, field
from fractions import Fraction
from typing import Any


@dataclass
class MathValidationIssue:
    code: str
    message: str
    question_id: str | None = None


@dataclass
class MathValidationResult:
    passed: bool
    issues: list[MathValidationIssue] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return {
            "passed": self.passed,
            "issues": [
                {"code": i.code, "message": i.message, "questionId": i.question_id}
                for i in self.issues
            ],
        }


_NUMBER_RE = re.compile(
    r"^-?\d+(?:\.\d+)?(?:/\d+)?$|^-?\d+/\d+$"
)


def _parse_number(text: str) -> float | Fraction | None:
    raw = text.strip().replace(",", "")
    if not raw:
        return None
    if "/" in raw and not raw.startswith("http"):
        try:
            return Fraction(raw)
        except (ValueError, ZeroDivisionError):
            return None
    try:
        if "." in raw:
            return float(raw)
        return int(raw)
    except ValueError:
        return None


def _numbers_equal(a: float | Fraction | int, b: float | Fraction | int) -> bool:
    try:
        return abs(float(a) - float(b)) < 1e-9
    except (TypeError, ValueError):
        return False


def _expected_from_operation(operation: str, operands: list[Any]) -> float | Fraction | None:
    if not operands:
        return None
    nums = []
    for o in operands:
        if isinstance(o, (int, float)):
            nums.append(o)
        else:
            parsed = _parse_number(str(o))
            if parsed is None:
                return None
            nums.append(parsed)

    op = (operation or "").lower()
    try:
        if op == "count" and len(nums) >= 1:
            return nums[0]
        if op == "compare":
            return None  # non-numeric correct answer expected
        if op == "add" and len(nums) >= 2:
            return nums[0] + nums[1]
        if op == "subtract" and len(nums) >= 2:
            return nums[0] - nums[1]
        if op in {"multiply", "mult"} and len(nums) >= 2:
            return nums[0] * nums[1]
        if op == "divide" and len(nums) >= 2:
            if nums[1] == 0:
                return None
            return nums[0] / nums[1]
        if op == "place_value" and len(nums) >= 2:
            return nums[1]
        if op == "multi_step" and len(nums) >= 3:
            # Convention used by mock generator: a - b + c
            return nums[0] - nums[1] + nums[2]
        if op == "fraction" and len(nums) >= 2:
            return Fraction(int(nums[0]), int(nums[1]))
    except (TypeError, ValueError, ZeroDivisionError):
        return None
    return None


def _level_range(math_level: str) -> tuple[int, int]:
    lower = math_level.lower()
    if "emerg" in lower:
        return 0, 10
    if "develop" in lower:
        return 0, 10
    if "secur" in lower:
        return 0, 20
    if "advanc" in lower:
        return 0, 100
    return 0, 20


def _fraction_or_decimal_valid(text: str) -> bool:
    parsed = _parse_number(text)
    if parsed is None:
        return False
    if isinstance(parsed, Fraction):
        return parsed.denominator != 0
    return True


class MathValidator:
    """Deterministic checks for math questions in a lesson draft."""

    def validate(self, lesson: dict[str, Any]) -> MathValidationResult:
        issues: list[MathValidationIssue] = []
        math_level = str(lesson.get("intended_math_level") or "Developing")
        lo, hi = _level_range(math_level)
        questions = [
            q
            for q in (lesson.get("questions") or [])
            if str(q.get("subject", "")).lower() == "math"
        ]

        for q in questions:
            qid = q.get("id")
            choices = list(q.get("choices") or [])
            correct_answers = list(q.get("correct_answers") or [])
            if not correct_answers and q.get("correctAnswer"):
                correct_answers = [q["correctAnswer"]]

            if len(choices) != len(set(choices)):
                issues.append(
                    MathValidationIssue(
                        "duplicate_choices",
                        "Choices must be unique.",
                        qid,
                    )
                )

            if not correct_answers:
                issues.append(
                    MathValidationIssue(
                        "missing_correct_answer",
                        "Math question must declare correct_answers.",
                        qid,
                    )
                )
                continue

            if len(correct_answers) != 1:
                issues.append(
                    MathValidationIssue(
                        "multiple_correct_answers",
                        "Exactly one correct answer is required.",
                        qid,
                    )
                )

            correct = str(correct_answers[0])
            if choices and correct not in choices:
                issues.append(
                    MathValidationIssue(
                        "correct_not_in_choices",
                        f"Correct answer '{correct}' is not among choices.",
                        qid,
                    )
                )

            operation = str(q.get("operation") or "")
            operands = list(q.get("operands") or [])

            # Non-numeric compare answers are allowed when operation is compare
            if operation.lower() == "compare":
                continue

            if not _fraction_or_decimal_valid(correct) and operation.lower() != "compare":
                # Allow labeled compare-style already handled; otherwise require number/fraction
                if not any(c.isalpha() for c in correct):
                    issues.append(
                        MathValidationIssue(
                            "invalid_number_format",
                            f"Correct answer '{correct}' is not a valid number/fraction.",
                            qid,
                        )
                    )

            expected = _expected_from_operation(operation, operands)
            if expected is not None:
                parsed_correct = _parse_number(correct)
                if parsed_correct is None or not _numbers_equal(parsed_correct, expected):
                    issues.append(
                        MathValidationIssue(
                            "answer_not_computable",
                            f"Correct answer '{correct}' does not match operation "
                            f"{operation} with operands {operands} (expected {expected}).",
                            qid,
                        )
                    )
            elif operation and operation.lower() not in {"compare", ""}:
                # Operation declared but could not compute — reject
                if operands:
                    issues.append(
                        MathValidationIssue(
                            "operation_mismatch",
                            f"Could not compute expected value for operation '{operation}'.",
                            qid,
                        )
                    )

            # Number range check for numeric choices
            for choice in choices:
                parsed = _parse_number(str(choice))
                if parsed is None:
                    continue
                val = float(parsed)
                # Allow unit fractions like 1/4 even when numerator/denom outside "answer" range
                if isinstance(parsed, Fraction) and parsed.numerator <= hi and parsed.denominator <= max(hi, 10):
                    continue
                if val < lo or val > hi * 2:
                    # Allow distractors slightly outside band but not absurdly far
                    if abs(val) > hi * 5 and hi > 0:
                        issues.append(
                            MathValidationIssue(
                                "number_out_of_range",
                                f"Choice '{choice}' is far outside level range {lo}–{hi}.",
                                qid,
                            )
                        )

            # Fractions/decimals validity on all numeric-looking choices
            for choice in choices:
                text = str(choice).strip()
                if "/" in text or "." in text:
                    if not _fraction_or_decimal_valid(text):
                        issues.append(
                            MathValidationIssue(
                                "invalid_fraction_or_decimal",
                                f"Invalid fraction/decimal choice: '{choice}'.",
                                qid,
                            )
                        )

        return MathValidationResult(passed=not issues, issues=issues)


def validate_math(lesson: dict[str, Any]) -> MathValidationResult:
    return MathValidator().validate(lesson)
