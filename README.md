# Movo Learn

A local SwiftUI MVP for personalized children's daily learning, with a parent-owned family API for profiles and progress.

## Open in Cursor

**Important:** Open this folder as your workspace — not your home directory.

1. **File → Open Folder…** → select `/Users/leylaarcasoy/MovoLearn`
2. Or double-click `MovoLearn.code-workspace`

New agents will then see the correct project, rules in `.cursor/rules/`, and context in `AGENTS.md`.

## Run in Simulator

1. Open `MovoLearn.xcodeproj` in Xcode
2. Select an iPhone simulator (iOS 17+)
3. Press **Run** (⌘R)

Or from Terminal:

```bash
cd /Users/leylaarcasoy/MovoLearn
xcodebuild -scheme MovoLearn -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build
```

## App Flow

1. **Welcome** — one-line value prop + Get Started
2. **Parent Account** — parent creates or signs in (required to keep profiles across devices)
3. **Parent Setup** — child profile (nickname, age, grade, reading level, goal)
3. **Interest Selection** — pick topics the child loves
4. **Home** — daily lesson card themed to selected interests
5. **Lesson** — reading, comprehension, math, vocabulary, science, creative prompt (one section at a time)
6. **Completion** — celebration, then Home or another lesson (kids never go through the parent report)
7. **Parent Learning Report** — in Profile → For Parents; short scores and recent lessons (fuller review later)

## Sample Lessons

Bundled JSON lessons for **Sharks**, **Horses**, **Space**, and **Dinosaurs** in `MovoLearn/Data/Lessons/`. Loaded via `LessonLoader`.

Multiple-choice questions use **plausible, topic-related distractors** (no joke or absurd choices). See `QuestionQualityValidator` and `AILessonGenerationPrompt`.

## Level-specific learning content

Changing age, reading level, or math level changes **actual lesson content** (vocabulary, passage complexity, math concepts, hints), not only labels. Reading and math levels are independent.

- **Approved library:** `ApprovedContentLibrary` + `LevelSpecificContentFactory` (offline seed) and `MovoLearn/Data/ApprovedLessons/` (backend pipeline output)
- **Backend AI / standards pipeline:** `backend/content-pipeline/` — CASE (mock), AI generation (mock), Lexile (mock), Quantile progression (mock), math validator, quality gate
- **iOS never calls live AI** for child sessions; see `BackendOnlyAILessonGenerator`
- **Docs:** [docs/CONTENT_PIPELINE.md](docs/CONTENT_PIPELINE.md)

## Privacy (Launch)

Launch is **on-device only**. Child profiles and lesson progress stay on the iPhone or iPad. Family cloud save exists in code (`backend/family-api/`) but is disabled (`FamilyCloudSync.isEnabled = false`) until the privacy policy is updated and parental-consent review is done.

- Parent-facing policy: [docs/legal/PRIVACY_POLICY.md](docs/legal/PRIVACY_POLICY.md)
- Public site (home, App Store link, `/privacy`, `/terms`): [website/](website/)
- App Store Privacy Policy URL: `https://movolearn.com/privacy`
- App Store nutrition-label answers: [docs/legal/APP_STORE_PRIVACY.md](docs/legal/APP_STORE_PRIVACY.md)

Preview locally:

```bash
cd website && python3 -m http.server 8765
```

Then open http://127.0.0.1:8765/ and http://127.0.0.1:8765/privacy/. Point `movolearn.com` at this folder with Netlify (`netlify.toml`) or GitHub Pages (workflow in `.github/workflows/deploy-website.yml`). After the App Store listing is live, paste the store URL into `website/assets/site.js`.

Children never have passwords. See `backend/family-api/README.md` for the future parent-owned API.

## Next Phase

- Wire licensed CASE Network, MetaMetrics Lexile, and Quantile credentials into the backend pipeline
- Live AI generation on the backend using the same structured schema
- Optional educator review dashboard (content model already supports approval status)