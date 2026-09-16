import Foundation

/// iOS-side stub: live AI generation runs only in `backend/content-pipeline`.
/// The app never ships API keys or calls commercial AI providers for child-facing text.
enum BackendOnlyAILessonGenerator: AILessonGenerationProvider {
    var providerName: String { "BackendOnlyAILessonGenerator" }
    var runsOnBackendOnly: Bool { true }

    func generateDraft(request: LessonGenerationRequest) throws -> Lesson {
        throw GenerationError.mustRunOnBackend
    }

    enum GenerationError: LocalizedError {
        case mustRunOnBackend

        var errorDescription: String? {
            "AI lesson generation must run in backend/content-pipeline with server-side credentials. The iOS app only loads pre-validated approved lessons."
        }
    }
}
