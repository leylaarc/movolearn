#!/usr/bin/env python3
"""CLI: generate approved lessons for several anonymous profile combinations.

Usage (from backend/content-pipeline):

    python scripts/generate_approved_lessons.py

Writes:
  - ../../MovoLearn/Data/ApprovedLessons/*.json  (approved only)
  - logs/unavailable_lessons.jsonl               (failures after retries)
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

# Allow running as `python scripts/generate_approved_lessons.py`
ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from src.pipeline import ContentPipeline, PipelineProfile  # noqa: E402


DEFAULT_PROFILES: list[PipelineProfile] = [
    PipelineProfile(
        age_range="4-5",
        grade="K",
        reading_level="Beginner",
        math_level="Emerging",
        interests=["Ocean", "Sharks"],
        subject="Reading",
        learner_id="anon_profile_beginner_01",
        preferred_skill_id="movo.ela.letter-sound.k",
    ),
    PipelineProfile(
        age_range="5-6",
        grade="1",
        reading_level="Early Reader",
        math_level="Developing",
        interests=["Horses"],
        subject="Reading",
        learner_id="anon_profile_early_01",
        preferred_skill_id="movo.ela.short-sentences.1",
        mastered_skills=["movo.ela.letter-sound.k", "movo.ela.phonics.blend.k", "movo.ela.simple-words.1"],
    ),
    PipelineProfile(
        age_range="6-7",
        grade="2",
        reading_level="Growing Reader",
        math_level="Secure",
        interests=["Space"],
        subject="Reading",
        learner_id="anon_profile_growing_01",
        preferred_skill_id="movo.ela.main-idea.2",
        mastered_skills=[
            "movo.ela.key-details.1",
            "movo.ela.sequencing.1",
            "movo.ela.short-sentences.1",
        ],
    ),
    PipelineProfile(
        age_range="8-10",
        grade="3",
        reading_level="Confident Reader",
        math_level="Advancing",
        interests=["Dinosaurs"],
        subject="Reading",
        learner_id="anon_profile_confident_01",
        preferred_skill_id="movo.ela.inference.2",
        mastered_skills=["movo.ela.main-idea.2", "movo.ela.key-details.1"],
    ),
    PipelineProfile(
        age_range="5-6",
        grade="1",
        reading_level="Early Reader",
        math_level="Developing",
        interests=["Ocean"],
        subject="Math",
        learner_id="anon_profile_math_dev_01",
        preferred_skill_id="movo.math.add-sub-10.1",
        mastered_skills=["movo.math.counting.k", "movo.math.comparing.k"],
    ),
    PipelineProfile(
        age_range="7-8",
        grade="2",
        reading_level="Growing Reader",
        math_level="Secure",
        interests=["Space"],
        subject="Math",
        learner_id="anon_profile_math_secure_01",
        preferred_skill_id="movo.math.add-sub-20.1",
        mastered_skills=["movo.math.add-sub-10.1", "movo.math.counting.k"],
    ),
    PipelineProfile(
        age_range="8-10",
        grade="3",
        reading_level="Confident Reader",
        math_level="Advancing",
        interests=["Sharks"],
        subject="Math",
        learner_id="anon_profile_math_adv_01",
        preferred_skill_id="movo.math.multi-step.2",
        mastered_skills=[
            "movo.math.add-sub-20.1",
            "movo.math.place-value.1",
            "movo.math.counting.k",
        ],
    ),
]


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate approved Movo Learn lessons via mock pipeline")
    parser.add_argument(
        "--approved-dir",
        type=Path,
        default=None,
        help="Override ApprovedLessons output directory",
    )
    parser.add_argument(
        "--unavailable-log",
        type=Path,
        default=None,
        help="Override unavailable JSONL log path",
    )
    args = parser.parse_args()

    pipeline = ContentPipeline(
        approved_dir=args.approved_dir,
        unavailable_log=args.unavailable_log,
    )

    summary = []
    approved = 0
    unavailable = 0

    print(f"Standards: {pipeline.standards.provider_name}")
    print(f"AI:        {pipeline.generator.provider_name}")
    print(f"Reading:   {pipeline.reading_provider.provider_name}")
    print(f"Math prog: {pipeline.math_progression.provider_name}")
    print(f"Output:    {pipeline.approved_dir}")
    print()

    for profile in DEFAULT_PROFILES:
        result = pipeline.run(profile)
        summary.append(result.to_dict())
        if result.status == "approved":
            approved += 1
            print(f"✓ approved  {result.skill_id} → {result.output_path.name} (attempts={result.attempts})")
        else:
            unavailable += 1
            print(f"✗ unavailable {result.skill_id} reasons={result.reasons[:2]}")

    print()
    print(json.dumps({"approved": approved, "unavailable": unavailable, "results": summary}, indent=2))
    return 0 if unavailable == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
