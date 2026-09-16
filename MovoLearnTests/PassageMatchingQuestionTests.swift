import XCTest
@testable import MovoLearn

final class PassageMatchingQuestionTests: XCTestCase {

    private let fossilPassage = """
    Brush by brush, dust rises from the dig site. A curved fossil looks like a giant rib. \
    Notes say the bones are hard as stone and layered in mud from an ancient river. \
    Fossils are nature's time capsules — they keep secrets from millions of years ago.
    """

    func testFossilPassageProducesPassageGroundedMatching() {
        let result = PassageMatchingQuestionGenerator.generate(
            passage: fossilPassage,
            topic: .dinosaurs,
            vocabulary: [
                VocabularyWord(
                    word: "Fossil",
                    definition: "remains of a plant or animal from long ago, preserved in rock",
                    exampleSentence: "Scientists study fossils.",
                    storyConnection: "The dig uncovers a fossil."
                )
            ],
            knowledgeFacts: [
                KnowledgeFact(fact: "Fossils help scientists learn about animals that lived long ago.")
            ]
        )

        XCTAssertTrue(result.usedMatching, "Expected matching question for fossil passage; got: \(result.question.prompt)")
        XCTAssertEqual(result.question.responseType, .matching)
        XCTAssertGreaterThanOrEqual(result.acceptedPairs.count, 3)

        let issues = PassageMatchingQuestionGenerator.validationIssues(
            for: result.acceptedPairs,
            passage: fossilPassage
        )
        XCTAssertTrue(issues.isEmpty, issues.joined(separator: "\n"))

        for pair in result.acceptedPairs {
            XCTAssertFalse(
                PassageMatchingQuestionGenerator.isLooseAssociation(left: pair.left, right: pair.right),
                "Loose pair slipped through: \(pair.left) → \(pair.right)"
            )
            XCTAssertNotNil(pair.supportingEvidence)
            XCTAssertFalse((pair.supportingEvidence ?? "").isEmpty)
            XCTAssertFalse(pair.right.lowercased().contains("museum"))
            XCTAssertFalse(pair.right.lowercased() == "nest")
            XCTAssertFalse(pair.right.lowercased() == "valley")
        }
    }

    func testLooseAssociationsAreRejected() {
        let badPairs = [
            MatchingPair(left: "Fossil", right: "Museum", supportingEvidence: "Fossils are nature's time capsules."),
            MatchingPair(left: "Herds", right: "Valley", supportingEvidence: "Dinosaurs roamed valleys."),
            MatchingPair(left: "Eggs", right: "Nest", supportingEvidence: "Dust rises from the dig site.")
        ]
        let issues = PassageMatchingQuestionGenerator.validationIssues(for: badPairs, passage: fossilPassage)
        XCTAssertFalse(issues.isEmpty)
        XCTAssertTrue(issues.contains { $0.lowercased().contains("loose") || $0.lowercased().contains("supporting") })
    }

    func testFossilDetectiveBundledLessonHasGroundedMatching() {
        let lesson = BundledLessons.fossilDetective
        let matching = lesson.questions.filter { $0.responseType == .matching }
        XCTAssertFalse(matching.isEmpty, "Fossil Detective should include a matching question")
        for question in matching {
            let issues = PassageMatchingQuestionGenerator.validationIssues(
                for: question.pairs,
                passage: lesson.readingPassage
            )
            XCTAssertTrue(issues.isEmpty, "\(question.prompt)\n\(issues.joined(separator: "\n"))")
            for pair in question.pairs {
                XCTAssertFalse(PassageMatchingQuestionGenerator.isLooseAssociation(left: pair.left, right: pair.right))
                XCTAssertNotNil(pair.supportingEvidence)
            }
        }
    }

    func testThemeInteractionNoLongerEmitsMuseumNestValley() {
        let questions = ThemeInteractionQuestions.forPassage(
            fossilPassage,
            topic: .dinosaurs
        )
        let matching = questions.filter { $0.responseType == .matching }
        for question in matching {
            for pair in question.pairs {
                let key = "\(pair.left.lowercased())|\(pair.right.lowercased())"
                XCTAssertFalse(key.contains("museum"))
                XCTAssertFalse(key.contains("nest"))
                XCTAssertFalse(pair.right.lowercased() == "valley")
            }
        }
    }
}
