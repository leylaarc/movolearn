import SwiftUI

@main
struct MovoLearnApp: App {
    init() {
        LessonLoader.warmCache()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .font(DesignSystem.Typography.bodyText)
                .padLayout()
        }
    }
}
