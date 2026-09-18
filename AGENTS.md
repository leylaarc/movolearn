# Movo Learn — Agent Guide

This is the **Movo Learn** iOS app. Always treat `/Users/leylaarcasoy/MovoLearn` as the project root.

## What this is

SwiftUI children’s learning app (ages 5–8). Local-first, with a parent-owned family API for profiles and progress.

- **Platform:** iOS 17+, SwiftUI, Xcode
- **Bundle ID:** `com.movolearn.app`
- **Open in Xcode:** `MovoLearn.xcodeproj`

## Project layout

```
MovoLearn/
├── MovoLearn.xcodeproj
├── MovoLearn/
│   ├── MovoLearnApp.swift      # @main entry
│   ├── ContentView.swift        # Navigation / routing
│   ├── Models/                  # Codable data models
│   ├── ViewModels/              # AppViewModel, LessonViewModel
│   ├── Views/                   # SwiftUI screens
│   ├── Data/                    # LessonLoader, ProgressStore, JSON lessons
│   ├── Theme/                   # DesignSystem.swift, SparkComponents.swift
│   └── Assets.xcassets
├── website/                    # movolearn.com (home, /privacy, /terms)
├── .cursor/rules/               # Cursor AI rules
└── README.md
```

## App flow (do not reorder without asking)

Launch (cloud save off): Welcome → Child Profile Setup → Interest Selection → Home → Lesson → Completion → Home (or another lesson)

When `FamilyCloudSync` is enabled: Welcome → Parent Account → Child Profile Setup → …

Parents open the **Learning Report** from Profile (“For Parents”), not after each lesson.

A **parent account** can own child profiles and lesson progress, but **Launch ships with cloud save off** (`FamilyCloudSync.isEnabled = false`). Children never log in. Local UserDefaults is the Launch store. Do not enable the family API in a store build until `docs/legal/PRIVACY_POLICY.md` is rewritten. Hosted policy: `https://movolearn.com/privacy` (`website/privacy/index.html`).

Parents can reopen Interest Selection in **edit mode** from Home (“Edit Interests”) or the Learning Report (“Update Interests”) to change `favoriteTopics` without resetting progress.

## Key systems

| System | Location | Notes |
|--------|----------|-------|
| Lessons | `Data/LessonLoader.swift` | Browse catalog = approved library; legacy Bundled/JSON by ID only |
| Progress | `Data/ProgressStore.swift` | Local Launch store; family API sync only if `FamilyCloudSync` is on |
| Family accounts | `backend/family-api/`, `Data/FamilyAPIClient.swift` | Disabled for Launch; children never authenticate |
| Design | `Theme/DesignSystem.swift`, `Theme/SparkComponents.swift` | Use these — don’t scatter colors/styles |
| Routing | `ViewModels/AppViewModel.swift` | `AppRoute` enum |
| Question quality | `Data/QuestionQualityValidator.swift`, `Data/AILessonGenerationPrompt.swift` | Plausible distractors only; no joke/absurd choices |
| Real terms | `LessonContentCoherenceValidator.inventedKnowledgeTerms` | Did You Know/vocab use real subject words only (tide chart, orbit, lava)—never invented labels |
| Content pipeline | `Data/ContentPipeline/`, `backend/content-pipeline/` | CASE/Lexile/Quantile/AI providers (mock until licensed); approved library only for children |
| Level content | `ApprovedContentLibrary`, `LevelSpecificContentFactory`, `CuratedTopicLessonBank*` | **MVP source of truth** for child lessons (pipeline JSON = sparse exemplars) |

## Build & run

```bash
cd /Users/leylaarcasoy/MovoLearn
xcodebuild -scheme MovoLearn -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.5' build
```

In Xcode: open project → pick simulator → ⌘R.

Backend approved-lesson generation (mock providers by default):

```bash
cd backend/content-pipeline && python3 scripts/generate_approved_lessons.py
```

Family API (parent accounts + child profile sync):

```bash
cd backend/family-api && python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --host 127.0.0.1 --port 8088
```

See `docs/CONTENT_PIPELINE.md` and `backend/content-pipeline/README.md`.

## Conventions

- SwiftUI only for UI
- Reuse `DesignSystem` and `SparkComponents` for styling
- Keep changes minimal; don’t refactor unrelated code
- Don’t add payments unless explicitly requested
- Add new Swift files to `MovoLearn.xcodeproj/project.pbxproj`
- Add JSON/resources to the Xcode target Resources build phase

## Mascots (original, not copyrighted)

- Finn the Shark — sharks
- Willa the Whale — ocean
- Nova the Star — space
- Dottie the Dino — dinosaurs
- Sunny the Horse — horses

Defined in `Theme/SparkComponents.swift` (`MascotView`).
