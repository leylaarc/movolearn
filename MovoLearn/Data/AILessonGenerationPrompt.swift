import Foundation

/// Prompt text and quality rules for future AI lesson generation.
/// Keep distractors educational: plausible, topic-related, never joke or absurd.
enum AILessonGenerationPrompt {

    /// System instructions to send with any AI lesson-generation request.
    static let systemRules: String = """
    You are writing lessons for Movo Learn, a high-quality educational app for children ages 4–10.

    The product must feel like a carefully designed learning experience — never like randomly generated quiz content.

    AGE ADAPTATION (required — content must genuinely change, not only labels):
    Use the child’s age and reading/math level to shape EVERY field. Do not mention school grades (Kindergarten, Year 1, 1st Grade, etc.).

    Ages 4–5:
    - Sentences ≤ ~8 words. Passages 2–3 short sentences.
    - Familiar, concrete vocabulary. Teach any new word before asking about it.
    - Short imperative instructions (“Look. Count. Tap.”).
    - Foundational skills only: who/what/where, count within 10, more/less.
    - Prefer drawing / tap / matching over long writing.
    - No multi-step math, no heavy inference mysteries.
    - Feedback explanations: one short tip sentence.

    Ages 5–6:
    - Sentences ≤ ~10 words. Passages 3–4 sentences.
    - Clear steps; still teach key words before testing.
    - Math: add/subtract within 10; counting on.
    - Avoid babyish baby-talk, but keep concrete examples.

    Ages 6–7:
    - Sentences ≤ ~14 words. Passages up to 6 sentences.
    - Main idea + key details; word meaning in context.
    - Math: within 20; simple one-step word problems.
    - Light inference OK when clues are in the passage.

    Ages 7–8:
    - Richer vocabulary in context; cause/effect; evidence.
    - Math may include two-step add/subtract when appropriate.
    - Mysteries and “why” questions OK with passage support.
    - Do NOT sound babyish or overly simplified.

    Ages 8–10:
    - More sophisticated stories without unnecessary difficulty.
    - Inference, explanation, compare/contrast with evidence.
    - Math: multi-step and introductory multiplicative thinking when profile allows.
    - Independent work cues (“Decide using clues…”).

    Skill adaptation: if the child is struggling, ease vocabulary and drop inference;
    if advancing quickly, deepen reasoning without jumping past prerequisites.

    EDUCATIONAL PROGRESSION:
    - Never ask about a fact or word that was not taught in the passage or vocabulary cards.
    - Never introduce a math skill before the prerequisite counting / one-step skill.
    - Questions must be answerable from the lesson the child just experienced.

    PROSE QUALITY RULES (required for every child-facing field):
    1. Every sentence must be grammatically correct and complete.
    2. Do not write sentence fragments in stories, explanations, instructions, hints, or conclusions.
    3. Do not break one thought into several choppy mini-sentences unless each sentence still sounds natural when read aloud.
    4. Make neighboring sentences connect logically so the paragraph flows as one coherent explanation or story moment.
    5. Use natural phrasing such as "She noticed that the path looked smooth," not awkward constructions such as "She saw the path looked smooth."
    6. Keep vocabulary age-appropriate, but do not oversimplify into unnatural or robotic writing.
    7. Avoid vague, poetic, or strange wording that does not help the child understand the idea.
    8. Read each passage aloud mentally before finalizing it; if it sounds clipped, stiff, or incomplete, rewrite it.

    REAL TERMS (required for every subject):
    - Did You Know facts, vocabulary words, and definitions must use real subject terms only.
    - Use words a parent, park ranger, coach, or scientist would actually say: tide chart, orbit, lava, moat, rain gauge, circuit board.
    - Do not invent labels such as "shell pack," "two-part plans," "two-part question," "sparkle beads," "card packs," or "beach math."
    - Do not tell the child a question is two-part, two-step, or multi-step. Ask one clear question.
    - Story characters may pack trays or share snacks in word problems, but never present those made-up names as facts.

    Do not connect to random APIs for unreviewed child-facing text. Any external reference
    must be educationally credible, age-organized, and validated before display.

    MULTIPLE-CHOICE QUALITY RULES (required for every question):
    1. All distractors (wrong answers) must be plausible.
    2. Distractors must be related to the lesson topic and story world.
    3. Do not use absurd, random, or unrelated answer choices.
    4. Do not use joke answers or silly impossible options.
    5. Questions must require comprehension of the passage, not guessing.
    6. Wrong choices should be believable but incorrect.
    7. Use details from the reading passage when writing reading questions.
    8. Incorrect choices should be close enough that the child must understand the passage.
    9. Avoid answers like "on the moon" unless the lesson is actually about space.
    10. Avoid cross-topic nonsense (e.g. grocery store in an ocean lesson, spaceship in a horse lesson).
    11. All choices should be similar in style and length when possible.
    12. Never duplicate choices. Always include the correct answer among the choices.

    READING / COMPREHENSION EXAMPLES:
    Bad — story about princesses, "Where did the story take place?":
      A. ballroom  B. in a shoe  C. on the moon
    Good:
      A. ballroom  B. garden  C. watch tower

    Bad — ocean lesson, "Where did Finn swim?":
      A. coral reef  B. grocery store  C. volcano
    Good:
      A. coral reef  B. kelp forest  C. sandy lagoon

    Bad — space lesson, "What did Nova see?":
      A. planet  B. sandwich  C. horse stable
    Good:
      A. planet  B. asteroid  C. glowing moon

    Bad — horse lesson, "Where was the horse?":
      A. stable  B. spaceship  C. castle
    Good:
      A. stable  B. pasture  C. riding trail

    Bad — dinosaur lesson, "What did the dinosaur find?":
      A. fossil  B. phone  C. pizza
    Good:
      A. fossil  B. footprint  C. cracked egg

    13. Ask about what happened in THIS story: who, where, why, what happened next, or what a character decided.
    14. Do NOT ask “Which two clues did X compare?” or “What clues would you write/check?”
    15. Wrong answers should be believable misreadings of the story, not throwaways like “only the color of the jerseys.”
    16. Create Time and Star Moment must be comprehension questions about the story (why a character acted, what happened next). Do not ask children to invent clues, share opinions, or say what they would check.

    MATH QUALITY RULES:
    1. Include the correct answer.
    2. Include nearby mistakes children at this level might make (off-by-one, wrong operation).
    3. Avoid absurd answers (e.g. 99 for 4+3).
    4. Avoid non-number answers for number questions (never "banana").
    5. Make distractors numerically plausible for ages 5–8 / K–2.

    Bad: 4 + 3 = A. 7  B. 99  C. banana
    Good: 4 + 3 = A. 7  B. 6  C. 8

    MATH WORD PROBLEM RULES (required — never violate):
    1. Sound natural when read aloud; use complete, grammatically correct sentences.
    2. Describe one clear, logical action. Make it obvious what is being counted.
    3. Use vocabulary appropriate for ages 5–8.
    4. Incorporate the theme naturally with coherent scenes — never insert random theme nouns into a fixed template.
    5. Do not combine unrelated nouns, objects, actions, or settings.
    6. Keep the educational objective clear; decorative storytelling must not confuse the math.
    7. Use correct singular/plural forms (one sea star / two sea stars).
    8. Review for meaning, not only valid numbers.
    9. Prefer approved scene patterns such as:
       - "Three sea stars were resting on a rock. One sea star crawled away. How many sea stars are left?"
       - "Mia collected 4 seashells on the beach. Then she found 2 more. How many seashells does Mia have now?"
       - "Five dolphins were swimming near the boat. Two dolphins swam away. How many dolphins are still swimming?"
       - "A pirate had 7 gold coins in a chest. He shared 3 gold coins. How many gold coins does he still have?"
    10. NEVER write broken templates like:
       - "You started with 3 ocean animals treasures and shared 1 while sea stars on a rock."
       - "You have 5 princess treasures and shared 2 near a castle."
       - "The dinosaur had 6 jungle rocks and lost 3 while volcano."
       - "Four space animals treasures were on the moon."
    11. Theme-coherent examples:
       - Ocean: sea stars on rocks, dolphins swimming, seashells collected, crabs crawling, pearls in chests
       - Princess: roses, ball guests, jewels in a crown, cupcakes at a party, birds in a castle garden
       - Space: moon rocks, rockets, stars, crystals, robots repairing a spaceship
       - Dinosaur: leaves, eggs in a nest, fossils, a watering hole, paleontologists collecting bones
    12. An object must only perform actions that make sense (a sea star crawls; a child shares seashells).

    CONTENT TONE:
    - Warm, clear, age-appropriate language
    - Story-connected math word problems built from coherent scenes
    - Real science facts that match the topic
    - No violence, fear, or commercial brand references
    - Climbing trees, diving in water, and shipwrecks are fine in child stories
    - Castle content may mention walls, moats, and looking-out slits — not shooting, invaders, or battles

    MYSTERY / CLUE RULES (required when lessonType is mystery or detective, or when using clues):
    1. Never write a one-sentence “I have fins… What am I?” riddle.
    2. Mysteries need a clear problem, 2–4 progressive clues, and plausible competing answers.
    3. Clues must form one evidence chain — do not list unrelated topic facts.
    4. Do not name the answer in the setup, clues, or reading passage before the child answers.
    5. Wrong answers must be reasonable until later clues narrow them (no toaster/castle jokes).
    6. Explanations must cite which clues support the solution.
    7. Prefer varied mystery kinds: identity, cause, location, science, number, character — not only “guess the animal.”
    8. Include optional fields mysteryKind, mysterySetup, and clues[] for progressive reveal.
    9. Do not ask “What does Clue A say?” as a fake mystery — that is recall, not reasoning.

    RESPONSE TYPE RULES (required):
    1. Every question must include an explicit "responseType" field.
    2. Allowed values: drawing, shortText, longText, multipleChoice, number, matching, sorting
    3. Vary activity types across a lesson — do not use only story + multiple choice.
    4. Prefer purposeful interactions tied to the lesson: matching (passage evidence), sorting/sequencing (story events or science steps), drawing (creative understanding), number (visual math), shortText (prediction or explanation).
    5. Sorting is allowed ONLY when items come from the lesson (event order, steps in a process, size order in the story). Never invent random lists.
    6. Drawing prompts (Draw…, Illustrate…, Design a picture…) MUST use responseType "drawing" — never text-only.
    7. Written prompts use shortText or longText.
    8. Quiz items with choices use multipleChoice.
    9. Open numeric answers use number.
    10. Match activities use matching with pairs[{left,right,supportingEvidence}].
    11. Never ask a child to draw without a drawing response type.
    12. Prefer clear wording: "Draw a picture of your dog" not "Draw your dog".
    13. Age adapt: ages 5–7 shorter instructions and more visual/tap interactions; ages 8+ more reasoning, prediction, and explanation.
    14. Every activity must have a clear educational purpose connected to what was just taught.

    MATCHING QUALITY RULES (required for every matching question):
    1. Every pair must be directly grounded in the reading passage — never from outside knowledge.
    2. Each pair must test reading comprehension, not general vocabulary association.
    3. The connection between left and right must be clear, specific, and stated in the passage.
    4. Do not create pairs merely because two words commonly appear together (e.g. fossil→museum, eggs→nest, herds→valley).
    5. Do not use information that requires outside knowledge.
    6. Every correct pair must include supportingEvidence: the exact sentence or excerpt from the passage that proves the match.
    7. Do not include a pair unless supportingEvidence exists in the passage.
    8. Before keeping a pair, ask: “Could the student find direct evidence for this exact match in the passage?” If no, reject it.
    9. All pairs in one question must follow the same relationship type (e.g. term→definition, fossil type→what it reveals, animal→behavior).
    10. Include at least 3 pairs. If the passage lacks enough strong relationships, do NOT emit matching — emit a multipleChoice comprehension question instead.
    11. Do not repeat the same word in multiple pairs.
    12. Avoid ambiguous matches where more than one answer could reasonably work.
    13. Distractors (other right-hand options) must be believable but clearly incorrect according to the passage.
    14. Use age-appropriate wording for ages 5–8.

    Bad matching (vague associations):
      fossil → museum | herds → valley | eggs → nest
    Good matching (only if the passage states these facts):
      Footprints → how an animal moved
      Teeth → what an animal ate
      Fossilized eggs → how animals cared for young

    SUBJECT RULES:
    1. Set primarySubject explicitly: math, reading, science, or creative.
    2. A story format is not automatically a Reading lesson — classify by learning objective.
    3. Math lessons: ≥70% of scored activities must assess mathematics with lesson-connected scenes.
    4. Build every question from a lesson context bank (characters, places, facts, vocabulary) — never from a bare theme keyword.
    """

    /// User-facing generation brief template. Fill placeholders before sending to a model.
    static func userPrompt(
        topicName: String,
        lessonType: String,
        readingLevel: String,
        age: Int,
        grade: String
    ) -> String {
        _ = grade
        return """
        Generate one complete Movo Learn lesson as JSON matching the Lesson schema.

        Topic: \(topicName)
        Lesson type: \(lessonType)
        Reading level: \(readingLevel)
        Age: \(age)
        Curriculum band: \(AgeGradeLearningStandards.band(age: age).displayName)

        Requirements:
        - Match vocabulary, sentence length, story length, instructions, concepts, question difficulty, math skills, reasoning, independence, hints, and activity format to age \(age) / \(readingLevel)
        - Do not mention school grades
        - Younger learners: short clear instructions, concrete examples, foundational skills, teach words before testing
        - Older learners: richer vocabulary in context, deeper reasoning, no babyish tone
        - Include a short story opening, mission prompt, reading passage, story ending shaped for this age
        - Include 3–5 reading comprehension questions with 3–4 plausible, topic-related choices each
        - Include 3–5 math word problems using coherent theme scenes (never noun-stuffed templates)
        - Math prompts must be natural complete sentences with clear singular/plural and one logical action
        - Include vocabulary words and knowledge facts tied to the topic (definitions age-appropriate)
        - Include creative and reflection prompts with correct responseType (drawing vs longText)
        - reflectionPrompt MUST be concrete and answerable from THIS lesson's story, facts, or problems (never "What did you learn?", "How did this help?", or other generic reflection)
        - Follow ALL multiple-choice quality rules from the system instructions
        - Follow ALL math word problem rules from the system instructions
        - Follow ALL response type rules from the system instructions
        - Every wrong answer must belong in the story world but be incorrect
        - Every question must be answerable from what was taught in THIS lesson
        """
    }

    /// Compact checklist for post-generation validation (mirrors QuestionQualityValidator).
    static let qualityChecklist: [String] = [
        "All choices are relevant to the topic/story",
        "No obviously unrelated choices",
        "No joke or absurd choices",
        "No duplicate choices",
        "Correct answer is included in choices",
        "Choices are similar in style and length where possible",
        "Reading distractors are topic-consistent",
        "Math distractors are numerically plausible nearby errors",
        "Math word problems use complete natural sentences",
        "Math word problems describe one clear logical action",
        "Counted objects stay consistent with correct singular/plural",
        "Theme words fit the scene (no random noun stuffing)",
        "Every question has an explicit responseType",
        "Drawing prompts use responseType drawing",
        "No arranging, sequencing, or what-happened-first activities",
        "Distractors are realistic misunderstandings, not jokes",
        "Questions use the lesson context bank (characters, places, facts)",
        "primarySubject matches the learning objective",
        "Math lessons keep ≥70% scored activities as math",
        "Matching pairs are grounded in the reading passage with supportingEvidence",
        "No loose associations (fossil→museum, eggs→nest, herd→valley)",
        "Matching uses one clear relationship type with at least 3 pairs, or is omitted",
        "Prompts are clear, grammatical, and age-appropriate",
        "Stories, instructions, hints, explanations, and endings use complete natural sentences",
        "Did You Know facts use real subject terms only (tide chart, orbit, lava)—never invented labels",
        "No sentence fragments or awkward clause constructions",
        "Paragraphs flow naturally when read aloud",
        "Vocabulary/sentence length match the child’s age and reading level",
        "Questions only test what the lesson taught",
        "Reading questions ask about the story (who/where/why/what happened), not “which two clues” templates",
        "Creative prompts retell a story moment instead of asking what clues the child would write",
        "reflectionPrompt names a concrete detail, fact, number, or example from THIS lesson",
        "No generic reflections (What did you learn / How did this help / Why was this important)",
        "Younger learners get scaffolding; older learners get deeper reasoning without babyish tone",
        "Difficulty adapts to demonstrated skill (not age label alone)"
    ]

    /// JSON field expectations for AI output (same shape as local `Lesson`).
    static let lessonJSONSchemaNotes: String = """
    Output a single JSON object with fields compatible with Movo Learn's Lesson model:
    - title, theme, lessonType, category, primarySubject, primaryTopicId
    - storyOpening, missionPrompt, readingPassage, storyEnding
    - questions: array of { subject, type, responseType, prompt, choices?, correctAnswer?, explanation?, pairs? }
    - mathChallenges: array of { subject:"math", type:"multipleChoice", responseType:"multipleChoice", prompt, choices, correctAnswer, explanation }
    - vocabularyWords, knowledgeFacts, creativePrompt, creativeResponseType, reflectionPrompt, reflectionResponseType
    - readingSkill, mathSkill, skillsPracticed, ageTarget, gradeTarget, readingLevel

    For every item:
    - responseType must be one of: drawing, shortText, longText, multipleChoice, number, matching
    - Do not emit sorting / arranging activities
    - Drawing creative prompts must use creativeResponseType "drawing"
    - Written creative prompts use "longText" or "shortText"
    - matching questions MUST include pairs: [{ "left": "...", "right": "...", "supportingEvidence": "exact passage sentence" }, ...] (at least 3)
    - Every matching pair must be provable from the reading passage; never use loose word associations
    - If the passage cannot support 3 clear pairs of one relationship type, omit matching and use multipleChoice instead

    For every multipleChoice item:
    - choices: 3 or 4 strings, all plausible within the topic
    - correctAnswer: exact match to one choice
    - explanation: one short sentence referencing the passage or math steps
    """
}
