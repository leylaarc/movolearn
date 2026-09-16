# ApprovedLessons (pipeline exemplars)

These JSON files are **samples** from `backend/content-pipeline`, not the full child catalog.

## Source of truth (MVP)

| Role | Location |
|------|----------|
| **Primary child content** | Swift: `CuratedTopicLessonBank*`, `LevelSpecificContentFactory`, `ApprovedContentLibrary.seedLevelMatrix()` |
| **Pipeline samples** | This folder + `approved-manifest.json` |
| **Retired browse catalog** | `BundledLessons` / `Data/Lessons/*.json` (resume / previews / tests only) |

Child Home and daily options load via `ContentLibrarySelector` → `ApprovedContentLibrary` (seeded packs + any manifest-listed approved JSON).

## Manifest sync

When adding or removing an approved JSON file:

1. Update `approved-manifest.json` → `approvedFiles`
2. Ensure the file is in the Xcode target Resources build phase
3. Re-run / regenerate via `backend/content-pipeline/scripts/generate_approved_lessons.py` when using the pipeline

Current `approvedFiles` count must match the `*.json` lesson files in this directory (excluding this README and the manifest itself).
