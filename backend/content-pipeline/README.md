# Movo Learn — Content Generation Pipeline

Python backend for **approved** lesson generation. AI and licensed measurement
providers live here — **not** in the iOS app.

Path: `backend/content-pipeline/`

## Implemented vs mock

| Component | Status | Notes |
|-----------|--------|--------|
| Pipeline orchestration | **Implemented** | `src/pipeline.py` — skill → generate → lexile check → math validate → quality gate → approve / unavailable |
| CASE / 1EdTech standards | **MOCK** | `MockCASEStandardsProvider` loads `src/skills/case_mock_skills.json` (CFItem-like). Temporary until CASE Network credentials. |
| AI lesson generation | **MOCK** | `MockAILessonGenerator` builds structured drafts locally. Does **not** call any API. |
| Lexile / reading measure | **MOCK** (+ licensed stub) | `MockReadabilityProvider` uses sentence/word heuristics. `LicensedLexileProvider` raises `NotConfiguredError` until real MetaMetrics credentials — **no invented endpoints**. |
| Quantile / math progression | **MOCK** (+ licensed stub) | `MockQuantileAlignedProgression` uses local skill order. Does **not** invent Quantile scores from age. Quantile does **not** auto-verify math answers. |
| Math validator | **Implemented** | Deterministic checks; reject on failure. |
| Quality gate | **Implemented** | Automated educator-style checks; fail = not approved. |
| CLI batch generate | **Implemented** | `scripts/generate_approved_lessons.py` |

## Credentials still needed (placeholders only)

Copy `.env.example` when you are ready. Do **not** put secrets in the iOS app.

- `AI_API_KEY` — live AI provider
- `CASE_API_KEY` / `CASE_API_BASE_URL` — from official **1EdTech / CASE Network** docs when licensed
- `LEXILE_API_KEY` / `LEXILE_API_BASE_URL` — from official **MetaMetrics Lexile** docs when licensed
- `QUANTILE_API_KEY` / `QUANTILE_API_BASE_URL` — from official **MetaMetrics Quantile** docs when licensed
- `MAX_GENERATION_RETRIES` — default `3`

We deliberately do **not** invent Lexile/CASE/Quantile API URLs or auth schemes.

## How the pipeline works

```
Standards (pick skill)
    → AI generate structured draft
    → Reading-level measurement (pass/fail vs intended band)
    → Math validator (deterministic)
    → Quality gate (all checks must pass)
    → success: write JSON to ../../MovoLearn/Data/ApprovedLessons/
    → failure: retry up to MAX_GENERATION_RETRIES, then mark unavailable + log reason
```

Child-facing content in the app comes from the **Swift curated approved library**
(primary) plus any **manifest-listed** files under `ApprovedLessons/`. Pipeline
output here is exemplar/sparse unless you expand generation. Failed generations
never ship to children.

### Run

```bash
cd /Users/leylaarcasoy/MovoLearn/backend/content-pipeline
python3 scripts/generate_approved_lessons.py
```

Requires Python 3.11+. `requirements.txt` is stdlib-only for the mock path.

## Privacy rules

- Accept only an anonymous `learner_id` (UUID-like token).
- **Never** send or store child names, DOB, emails, phones, or parent contact in generation requests.
- Interests and levels are fine; PII keys are rejected (`PrivacyViolationError`).

## Retry limits & failure handling

1. Each profile/skill run may attempt generation up to `MAX_GENERATION_RETRIES` (default 3).
2. Any failed reading check, math validation, or quality-gate item blocks approval for that attempt.
3. After retries are exhausted, the combination is marked **unavailable**:
   - Appended to `logs/unavailable_lessons.jsonl` with reasons
   - No file is written under `ApprovedLessons/`
4. The iOS app must treat unavailable skills as not showable / not generated — never display pending drafts.

## Mock AI content levels

`MockAILessonGenerator` uses **separate content banks** per `reading_level` and `math_level`
(different passages, vocabulary, question types, and number ranges) — not one template
with swapped numbers.

## Layout

```
backend/content-pipeline/
├── README.md
├── requirements.txt
├── .env.example
├── scripts/generate_approved_lessons.py
├── logs/                          # unavailable JSONL
└── src/
    ├── pipeline.py
    ├── errors.py
    ├── providers/
    │   ├── standards.py
    │   ├── ai_generator.py
    │   ├── lexile.py
    │   └── quantile.py
    ├── validators/
    │   ├── math_validator.py
    │   └── quality_gate.py
    └── skills/
        └── case_mock_skills.json
```

See also: [`docs/CONTENT_PIPELINE.md`](../../docs/CONTENT_PIPELINE.md) for the iOS team summary.
