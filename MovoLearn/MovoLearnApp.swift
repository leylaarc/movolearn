import SwiftUI

@main
struct MovoLearnApp: App {
    init() {
        LessonLoader.warmCache()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
