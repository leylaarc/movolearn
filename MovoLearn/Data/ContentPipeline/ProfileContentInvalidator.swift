import Foundation

/// Clears recommendation caches when age, grade, reading level, or math level change.
enum ProfileContentInvalidator {

    struct AcademicSnapshot: Equatable {
        let age: Int
        let grade: String
        let readingLevel: ReadingLevel
        let mathLevel: MathLevel
    }

    private static let defaultsKey = "com.movolearn.academicSnapshot."

    static func snapshot(from profile: ChildProfile) -> AcademicSnapshot {
        AcademicSnapshot(
            age: profile.currentAge,
            grade: profile.grade,
            readingLevel: profile.readingLevel,
            mathLevel: profile.mathLevel
        )
    }

    /// Call after persisting profile edits. Returns true if academic targeting changed.
    @discardableResult
    static func invalidateIfAcademicSettingsChanged(
        from previous: ChildProfile?,
        to updated: ChildProfile
    ) -> Bool {
        let newSnap = snapshot(from: updated)
        let oldSnap = previous.map(snapshot(from:))
        let changed = oldSnap != newSnap

        if changed {
            clearCaches(for: updated.id)
            #if DEBUG
            print("Academic profile changed — cleared recommendation caches. reading=\(updated.readingLevel.rawValue) math=\(updated.mathLevel.rawValue)")
            #endif
        }

        persist(snapshot: newSnap, childId: updated.id)
        return changed
    }

    static func clearCaches(for childId: UUID) {
        // The approved library already contains every reading/math band — do not rebuild
        // ~1,800 lessons when the child changes level. Selection filters at query time.
        var activity = HomeActivityStore.shared.load(for: childId)
        activity.inProgressLessonID = nil
        activity.inProgressPercent = 0
        activity.inProgressOpenedAt = nil
        activity.dismissedLessonIDs = []
        _ = HomeActivityStore.shared.save(activity, for: childId)
    }

    private static func persist(snapshot: AcademicSnapshot, childId: UUID) {
        let payload = [
            "age": String(snapshot.age),
            "grade": snapshot.grade,
            "reading": snapshot.readingLevel.rawValue,
            "math": snapshot.mathLevel.rawValue
        ]
        UserDefaults.standard.set(payload, forKey: defaultsKey + childId.uuidString)
    }
}
