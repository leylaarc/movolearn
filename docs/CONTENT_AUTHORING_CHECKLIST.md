# Content Authoring Checklist

Use this to track **accurate, age- and level-appropriate** lesson content for Movo Learn.

**How content is keyed today:** Age sets the curriculum ceiling. Catalog packs are still Reading level × Math level × Topic × Section, with age-based defaults.

| Age | Typical grade (label only) | Suggested reading | Suggested math | Curriculum |
|-----|----------------------------|-------------------|----------------|------------|
| ≤5 | Pre-K | Beginner | Emerging | Letter sounds, count to 10, add within 5 |
| 6 | Kindergarten | Early Reader | Developing | Who/what/where, letter sounds, add/subtract within 10 |
| 7 | 1st Grade | Growing Reader | Secure | Main idea, add/subtract within 20 |
| 8 | 2nd Grade | Confident Reader | Advancing | Evidence, add/subtract within 100, equal groups |
| 9–10 | 3rd Grade | Confident Reader | Advancing | Inference, multiplication intro |

Grade in the profile is for parents. Lessons follow **age**, even if grade is set higher.

**Legend:** `[x]` done · `[ ]` needs authoring · `[=]` exists but shared/reused (not unique)

---

## Priority 0 — Product-critical gaps

Do these first. Child-facing catalog already shows these sections, but they are not truly authored.

### Discovery (Science) — dedicated packs

`CuratedTopicLessonBank.discoveryPack` returns authored packs for all 30 topics (Wave A in `CuratedTopicLessonBank+Discovery.swift`; Wave D in `CuratedTopicLessonBank+DiscoveryWaveD.swift` via `waveDDiscoveryPack`).

For **each topic** below, author **4 Discovery packs** (one per reading level): Beginner / Early / Growing / Confident.

- [x] Horses
- [x] Jungle Animals
- [x] Sharks *(unique science focus — not ocean story clone)*
- [x] Ocean Animals *(Wave D — tide pools / dolphin mammals / octopus camouflage / reef jobs)*
- [x] Dinosaurs
- [x] Space
- [x] Planets *(Wave D — Earth home / rocky vs gas / Venus reflection / orbits)*
- [x] Rockets *(Wave D — countdown / thrust / stages / checklists)*
- [x] Soccer
- [x] Basketball
- [x] Dogs
- [x] Cats
- [x] Princesses
- [x] Castles
- [x] Fairies
- [x] Airplanes
- [x] Trains
- [x] Cars
- [x] Robots
- [x] Superheroes
- [x] Art
- [x] Music
- [x] Cooking
- [x] Nature
- [x] Bugs
- [x] Volcanoes
- [x] Weather
- [x] Farm Animals
- [x] Zoo Animals
- [x] Pirates

**Per Discovery pack, include:** title, opening, mission, science notes passage, 2–3 evidence questions, vocabulary, 1–2 real facts, creative/draw prompt, ending, reflection, hints, success criteria. Must teach a real concept (not a story retell).

**Count:** 30 topics × 4 reading levels = **120 Discovery packs** — **complete** (Wave A 32 + Wave D 88)

---

### Creative — dedicated packs

Creative lessons use dedicated packs when available (Wave C + Wave E complete).

Author **4 Creative packs per topic** (Beginner / Early / Growing / Confident).

Same topic list as Discovery above:

- [x] Horses · Jungle · Sharks · Dinosaurs · Space · Dogs · Robots · Volcanoes *(Wave C)*
- [x] Ocean Animals · Planets · Rockets
- [x] Soccer · Basketball · Cats · Princesses · Castles · Fairies
- [x] Airplanes · Trains · Cars · Superheroes · Art · Music · Cooking
- [x] Nature · Bugs · Weather · Farm Animals · Zoo Animals · Pirates

**Per Creative pack:** short inspiration (not full story quiz), create prompt (drawing for Beginner/Early; write/design for Growing/Confident), reflection tied to the creation, 1 vocab word optional.

**Count:** 30 × 4 = **120 Creative packs** — **complete** (Wave C 32 + Wave E 88)

---

### Unique content for aliased topics

These interest chips currently share packs. Author **unique Story + Math** so each world feels distinct.

| Topic | Currently shares | Story (4 reading levels) | Math (4 math levels) |
|-------|------------------|--------------------------|----------------------|
| Ocean Animals | ~~Sharks~~ unique | [x] [x] [x] [x] | [x] [x] [x] [x] |
| Planets | ~~Space~~ unique | [x] [x] [x] [x] | [x] [x] [x] [x] |
| Rockets | ~~Space~~ unique | [x] [x] [x] [x] | [x] [x] [x] [x] |

**Count:** 3 topics × (4 Story + 4 Math) = **24 unique packs** — **done** in `CuratedTopicLessonBank+UniqueWorlds.swift`

---

## Priority 1 — Fill Discovery/Creative math-band seeding

Discovery/Creative are seeded for **all** math bands (Emerging, Developing, Secure, Advancing) × all reading levels × all topics in `ApprovedContentLibrary.seedLevelMatrix()`.

- [x] Seed Discovery for Emerging + Advancing (all topics × 4 reading levels)
- [x] Seed Creative for Emerging + Advancing (all topics × 4 reading levels)

Packs remain reading-keyed; math level tags the profile band so every math profile can see Discovery/Creative.

---

## Priority 2 — Story + Math status (already authored)

These are **done** in `CuratedTopicLessonBank` (+ Extended). Keep as regression checklist; only reopen if QA fails age/level accuracy.

### Story (Reading) — 4/4 levels per topic

| Topic | Beginner | Early | Growing | Confident |
|-------|:--------:|:-----:|:-------:|:---------:|
| Horses | [x] | [x] | [x] | [x] |
| Jungle Animals | [x] | [x] | [x] | [x] |
| Sharks | [x] | [x] | [x] | [x] |
| Ocean Animals | [x] | [x] | [x] | [x] |
| Dinosaurs | [x] | [x] | [x] | [x] |
| Space | [x] | [x] | [x] | [x] |
| Planets | [x] | [x] | [x] | [x] |
| Rockets | [x] | [x] | [x] | [x] |
| Soccer | [x] | [x] | [x] | [x] |
| Basketball | [x] | [x] | [x] | [x] |
| Dogs | [x] | [x] | [x] | [x] |
| Cats | [x] | [x] | [x] | [x] |
| Princesses | [x] | [x] | [x] | [x] |
| Castles | [x] | [x] | [x] | [x] |
| Fairies | [x] | [x] | [x] | [x] |
| Airplanes | [x] | [x] | [x] | [x] |
| Trains | [x] | [x] | [x] | [x] |
| Cars | [x] | [x] | [x] | [x] |
| Robots | [x] | [x] | [x] | [x] |
| Superheroes | [x] | [x] | [x] | [x] |
| Art | [x] | [x] | [x] | [x] |
| Music | [x] | [x] | [x] | [x] |
| Cooking | [x] | [x] | [x] | [x] |
| Nature | [x] | [x] | [x] | [x] |
| Bugs | [x] | [x] | [x] | [x] |
| Volcanoes | [x] | [x] | [x] | [x] |
| Weather | [x] | [x] | [x] | [x] |
| Farm Animals | [x] | [x] | [x] | [x] |
| Zoo Animals | [x] | [x] | [x] | [x] |
| Pirates | [x] | [x] | [x] | [x] |

### Math — 4/4 levels per topic

| Topic | Emerging | Developing | Secure | Advancing |
|-------|:--------:|:----------:|:------:|:---------:|
| Horses | [x] | [x] | [x] | [x] |
| Jungle Animals | [x] | [x] | [x] | [x] |
| Sharks | [x] | [x] | [x] | [x] |
| Ocean Animals | [x] | [x] | [x] | [x] |
| Dinosaurs | [x] | [x] | [x] | [x] |
| Space | [x] | [x] | [x] | [x] |
| Planets | [x] | [x] | [x] | [x] |
| Rockets | [x] | [x] | [x] | [x] |
| Soccer | [x] | [x] | [x] | [x] |
| Basketball | [x] | [x] | [x] | [x] |
| Dogs | [x] | [x] | [x] | [x] |
| Cats | [x] | [x] | [x] | [x] |
| Princesses | [x] | [x] | [x] | [x] |
| Castles | [x] | [x] | [x] | [x] |
| Fairies | [x] | [x] | [x] | [x] |
| Airplanes | [x] | [x] | [x] | [x] |
| Trains | [x] | [x] | [x] | [x] |
| Cars | [x] | [x] | [x] | [x] |
| Robots | [x] | [x] | [x] | [x] |
| Superheroes | [x] | [x] | [x] | [x] |
| Art | [x] | [x] | [x] | [x] |
| Music | [x] | [x] | [x] | [x] |
| Cooking | [x] | [x] | [x] | [x] |
| Nature | [x] | [x] | [x] | [x] |
| Bugs | [x] | [x] | [x] | [x] |
| Volcanoes | [x] | [x] | [x] | [x] |
| Weather | [x] | [x] | [x] | [x] |
| Farm Animals | [x] | [x] | [x] | [x] |
| Zoo Animals | [x] | [x] | [x] | [x] |
| Pirates | [x] | [x] | [x] | [x] |

---

## Priority 3 — Level accuracy QA (Story + Math already present)

Even where packs exist, verify each band matches the skill intent:

### Reading skill targets

- [x] **Beginner:** letter/sound, concrete details, ≤~8 words/sentence, 2–4 sentences *(regression: LevelContentDifferentiation + horse/jungle exemplars)*
- [x] **Early Reader:** phonics/short sentences, 4–6 sentences *(spot-checked via factory differentiation)*
- [x] **Growing Reader:** main idea + details, light prediction/cause *(coherence + differentiation suites)*
- [x] **Confident Reader:** inference + evidence, denser but still child-appropriate *(differentiation + review exemplars)*

### Math skill targets

- [x] **Emerging:** count / recognize numbers 0–10
- [x] **Developing:** add/subtract within ~20
- [x] **Secure:** place value / multi-digit within ~100
- [x] **Advancing:** multi-step / intro multiplicative thinking within level rules *(incl. `in each` pack math fix)*

### Prose quality (all new + existing)

- [x] Complete sentences only (no fragments) *(validator: finite verbs, definition phrases, short praise, Mr./Dr. titles)*
- [x] Natural read-aloud flow
- [x] Age-appropriate vocabulary
- [x] Passes `ChildFacingProseQualityValidator` + `AutomatedContentQualityGate` *(Wave F suites green)*

Suggested QA order (highest traffic first): Horses, Jungle, Sharks/Ocean, Space, Dinosaurs, Dogs, Robots, then remaining topics — **core path covered by automated Wave F suites**. Residual factory-approval gaps cleaned in follow-up QC: joke-detector false positives tightened; curated content fixes; `testAllFactoryCombosApprove` green (full Topic×Category×Reading×Math matrix).

### Wave I — Story read-aloud pass (text quality only — not audio)

- [x] **I1** — Horses, Jungle, Sharks (`oceanReading`), Ocean Animals, Space, Dinosaurs, Dogs, Robots × all 4 reading levels *(warmer openings/missions; beginner passages smoothed for spoken flow; growing/confident inference clarity; MCQ answers unchanged)*
- [x] **I2** — Remaining 22 Story topics × 4 reading levels *(planets → pirates; openings/missions de-stamped; beginner flow; QC fixes for fragments + Nature theme keywords; factory + prose green)*

---

## Priority 4 — Backend approved JSON (sparse today)

Only **7** sample approved pipeline files exist. **Decision:** keep the Swift curated bank as MVP source of truth; pipeline JSON stays as exemplars (documented in `docs/CONTENT_PIPELINE.md` + `ApprovedLessons/README.md`).

- [x] Expand approved JSON for pipeline path **or** keep Swift bank as source of truth and document that clearly
- [x] Replace/retire weak legacy bundled lessons once approved replacements cover the same themes *(retired from `LessonLoader.allLessons()` browse catalog; resume-by-ID + approved replacement remain)*
- [x] Keep `approved-manifest.json` in sync with any new approved files *(7 files ↔ 7 entries; providerNote updated)*

Current samples (do not treat as full coverage):

| File | Rough band |
|------|------------|
| ocean … letter-sound-k | Beginner / Emerging |
| ocean … add-sub-10 | Early / Developing |
| horses … short-sentences | Early / Developing |
| space … main-idea-2 | Growing / Secure |
| space … add-sub-20 | Growing / Secure |
| sharks … multi-step | Confident / Advancing |
| dinosaurs … inference | Confident / Advancing |

---

## Suggested authoring waves

Work in waves so every age band gets something strong before expanding sideways.

### Wave A — Discovery for core themes (16 packs)

Topics: Horses `[x]`, Jungle `[x]`, Sharks `[x]`, Dinosaurs `[x]`, Space `[x]`, Dogs `[x]`, Robots `[x]`, Volcanoes `[x]`  
Levels: all 4 reading levels each — **Wave A complete (16 packs)**

### Wave B — Unique aliases (24 packs)

Ocean Animals, Planets, Rockets — full Story + Math uniqueness — **`[x]` done**

### Wave C — Creative for core themes (32 packs)

Same 8 topics as Wave A × 4 reading levels — **`[x]` done** in `CuratedTopicLessonBank+Creative.swift`

### Wave D — Remaining Discovery (88 packs)

Other 22 topics × 4 reading levels — **`[x]` complete** in `CuratedTopicLessonBank+DiscoveryWaveD.swift`

### Wave E — Remaining Creative (88 packs)

Other 22 topics × 4 reading levels — **`[x]` complete** in `CuratedTopicLessonBank+CreativeWaveE.swift`

### Wave F — QA pass

Priority 3 level-accuracy + prose gates on Story/Math + new Discovery/Creative — **`[x]` complete**

Automated suites green: `ChildFacingProseQualityTests`, `ContentQualityCoherenceTests`, `LevelContentDifferentiationTests`, `QuestionQualityTests`, `ReflectionPromptQualityTests`.

Validator hardening: finite-verb coverage for present tense, dictionary definitions, short praise, Mr./Dr. abbreviations, broader imperatives. Content fixes for Wave D Farm/Zoo/Pirates discovery + advancing math `in each` parsing.

### Wave G — Experiential quality (beyond validators)

- [x] **G1** — Replace soup/music filler distractors + teach-why explanations on high-traffic Discovery (Wave A 8 topics + Ocean/Planets/Rockets)
- [x] **G2** — Break Creative helper boilerplate (unique missions/hints/vocab examples) *(shared `creative` builder varies mission openers, “Science note” inspiration, vocab examples, fact explanations, hints by fingerprint)*
- [x] **G3** — Rewrite Beginner Discovery openings/passages (wonder + one concrete wow fact) *(30 beginner packs: Wave A 8 + Wave D 22; notebook stamp removed)*
- [x] **G4** — Retheme math situations (keep numbers, change story shape) *(ExtendedTopics + core bank; validator-safe cues preserved)*
- [x] **G5** — Voice/mascot continuity on top interests *(Discovery openings: Sunny/Willa/Nova/Dottie/Movo/Scout/Max on Wave A 8 topics × 4 levels + Ocean/Planets/Rockets)*

### Wave H — Finish experiential quality for every Discovery topic

- [x] **H1** — Extend G1 to remaining Wave D Discovery (19 topics): soccer → pirates; soup/music/joke distractors → science near-misses + teach-why explanations
- [x] **H2** — Kill remaining “Open your field notebook…” stamps on Early/Growing Wave D Discovery (38 openings → wonder hooks + varied missions)
- [x] **H3** — Extend G5 mascot/guide voice across remaining Wave D Discovery openings *(76 packs: Movo default; Sunny on Farm; Willa on Pirates — aligned with `MascotKind.forTopic`)*

### Wave I — Story read-aloud (text quality only — not audio)

- [x] **I1** — 8 high-traffic Story topics × 4 reading levels (see Priority 3)
- [x] **I2** — Remaining 22 Story topics × 4 reading levels

---

## Totals to author (new)

| Workstream | Packs |
|------------|------:|
| Discovery (all topics × 4 reading) | 120 |
| Creative (all topics × 4 reading) | 120 |
| Unique Story+Math for 3 aliases | 24 |
| **Total new authored packs** | **264** |

Story + Math for the other 27 distinct topics: **already done** (108 Story + 108 Math reading/math scene variants in the curated banks).

---

## Implementation notes

- Wire Discovery into `CuratedTopicLessonBank.discoveryPack` (stop returning `nil` for remaining topics).
- Point `LevelSpecificContentFactory.makeDiscoveryLesson` / `makeCreativeLesson` at dedicated packs, not Story reuse (both prefer dedicated packs when present).
- Split shared lookups so Ocean Animals / Planets / Rockets no longer alias to Sharks / Space (`CuratedTopicLessonBank+UniqueWorlds.swift`).
- Run `ChildFacingProseQualityTests` + quality gates before marking any pack `[x]`.

File homes:

- Core: `MovoLearn/Data/ContentPipeline/CuratedTopicLessonBank.swift`
- Extended topics: `MovoLearn/Data/ContentPipeline/CuratedTopicLessonBank+ExtendedTopics.swift`
- Discovery packs: `MovoLearn/Data/ContentPipeline/CuratedTopicLessonBank+Discovery.swift` (Wave A) + `CuratedTopicLessonBank+DiscoveryWaveD.swift` (Wave D)
- Creative packs: `MovoLearn/Data/ContentPipeline/CuratedTopicLessonBank+Creative.swift` (Wave C) + `CuratedTopicLessonBank+CreativeWaveE.swift` (Wave E)
- Unique alias worlds: `MovoLearn/Data/ContentPipeline/CuratedTopicLessonBank+UniqueWorlds.swift`
- Factory: `MovoLearn/Data/ContentPipeline/LevelSpecificContentFactory.swift`
