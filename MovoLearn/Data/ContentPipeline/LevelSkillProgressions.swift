import Foundation

/// Reading and math skill progressions used when selecting standards-aligned objectives.
/// Reading and math are independent — age alone does not pick academic skills.
enum LevelSkillProgressions {

    static func readingFocus(for level: ReadingLevel) -> String {
        switch level {
        case .beginner: return "Letter and sound recognition"
        case .earlyReader: return "Who, what, and where in short stories"
        case .growingReader: return "Main idea and sequencing"
        case .confidentReader: return "Inference and character motivation"
        }
    }

    static func readingSkills(for level: ReadingLevel) -> [String] {
        switch level {
        case .beginner:
            return ["Letter and sound recognition", "Listen for key words", "Simple words"]
        case .earlyReader:
            return ["Letter sounds in story words", "Who, what, and where", "Short sentences"]
        case .growingReader:
            return ["Sequencing", "Main idea", "Key details"]
        case .confidentReader:
            return ["Character motivation", "Inference", "Comparing information"]
        }
    }

    static func mathFocus(for level: MathLevel) -> String {
        switch level {
        case .emerging: return "Number recognition and counting"
        case .developing: return "Addition and subtraction"
        case .secure: return "Place value and multi-digit operations"
        case .advancing: return "Word problems"
        }
    }

    static func mathSkills(for level: MathLevel) -> [String] {
        switch level {
        case .emerging:
            return ["Number recognition", "Counting", "Comparing quantities"]
        case .developing:
            return ["Addition and subtraction", "Comparing quantities"]
        case .secure:
            return ["Place value", "Multi-digit operations", "Multiplication and division", "Measurement"]
        case .advancing:
            return ["Fractions", "Decimals", "Word problems", "Geometry", "Age-appropriate advanced reasoning"]
        }
    }

    /// Number ranges allowed for generated / validated math problems.
    /// Pass `age` at session time so ages 5–6 stay within 10 even if a parent raised the math chip.
    static func mathNumberRange(for level: MathLevel, age: Int? = nil) -> ClosedRange<Int> {
        let base: ClosedRange<Int>
        switch level {
        case .emerging: base = 0...10
        case .developing: base = 0...20
        case .secure: base = 0...100
        case .advancing: base = 0...1000
        }
        guard let age else { return base }
        let cap = AgeGradeLearningStandards.mathOperandUpperBound(forAge: age)
        return base.lowerBound...min(base.upperBound, cap)
    }

    static func allowsMultiStepMath(for level: MathLevel) -> Bool {
        switch level {
        case .emerging, .developing: return false
        case .secure, .advancing: return true
        }
    }

    static func passageSentenceTarget(for level: ReadingLevel) -> ClosedRange<Int> {
        switch level {
        case .beginner: return 2...4
        case .earlyReader: return 4...6
        case .growingReader: return 6...10
        case .confidentReader: return 8...14
        }
    }

    static func fallbackCASESkills() -> [EducationalSkill] {
        let reading: [(String, String, String, [String], [String])] = [
            ("mock.ela.letter-sounds", "Identify letters and common sounds", "ELA.K.RF.1", ["K"], []),
            ("mock.ela.phonics", "Blend simple phonics patterns in CVC words", "ELA.K.RF.2", ["K", "1"], ["mock.ela.letter-sounds"]),
            ("mock.ela.simple-words", "Read high-frequency simple words", "ELA.1.RF.3", ["K", "1"], ["mock.ela.phonics"]),
            ("mock.ela.short-sentences", "Read and understand short sentences", "ELA.1.RL.1", ["1"], ["mock.ela.simple-words"]),
            ("mock.ela.sequencing", "Sequence events in a short story", "ELA.1.RL.3", ["1", "2"], ["mock.ela.short-sentences"]),
            ("mock.ela.main-idea", "Identify the main idea of a passage", "ELA.2.RI.2", ["2"], ["mock.ela.sequencing"]),
            ("mock.ela.vocab-context", "Use context to explain vocabulary", "ELA.2.L.4", ["2", "3"], ["mock.ela.main-idea"]),
            ("mock.ela.inference", "Make inferences about characters and events", "ELA.3.RL.1", ["3"], ["mock.ela.vocab-context"]),
            ("mock.ela.motivation", "Explain character motivation using evidence", "ELA.3.RL.3", ["3"], ["mock.ela.inference"]),
            ("mock.ela.compare", "Compare information across details", "ELA.3.RI.9", ["3"], ["mock.ela.inference"])
        ]
        let math: [(String, String, String, [String], [String])] = [
            ("mock.math.number-recognition", "Recognize written numbers", "MATH.K.CC.1", ["K"], []),
            ("mock.math.counting", "Count objects and say how many", "MATH.K.CC.4", ["K"], ["mock.math.number-recognition"]),
            ("mock.math.comparing", "Compare quantities using more/less/same", "MATH.K.CC.6", ["K", "1"], ["mock.math.counting"]),
            ("mock.math.add-sub", "Add and subtract within 20", "MATH.1.OA.6", ["1"], ["mock.math.comparing"]),
            ("mock.math.place-value", "Understand tens and ones", "MATH.1.NBT.2", ["1", "2"], ["mock.math.add-sub"]),
            ("mock.math.multi-digit", "Add and subtract multi-digit numbers", "MATH.2.NBT.5", ["2"], ["mock.math.place-value"]),
            ("mock.math.mult-div", "Multiply and divide with equal groups", "MATH.3.OA.1", ["3"], ["mock.math.multi-digit"]),
            ("mock.math.fractions", "Understand simple unit fractions", "MATH.3.NF.1", ["3"], ["mock.math.mult-div"]),
            ("mock.math.measurement", "Measure length using standard units", "MATH.2.MD.1", ["2", "3"], ["mock.math.add-sub"]),
            ("mock.math.geometry", "Identify shapes and their attributes", "MATH.K.G.4", ["K", "1", "2"], ["mock.math.number-recognition"]),
            ("mock.math.multistep", "Solve multi-step word problems", "MATH.3.OA.8", ["3"], ["mock.math.mult-div", "mock.math.add-sub"])
        ]

        func map(
            _ rows: [(String, String, String, [String], [String])],
            subject: String
        ) -> [EducationalSkill] {
            rows.map {
                EducationalSkill(
                    id: $0.0,
                    fullStatement: $0.1,
                    humanCodingScheme: $0.2,
                    subject: subject,
                    educationLevels: $0.3,
                    skillType: "Learning Objective",
                    prerequisiteIds: $0.4,
                    relatedIds: []
                )
            }
        }
        return map(reading, subject: "Reading") + map(math, subject: "Math")
    }
}
