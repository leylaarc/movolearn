import SwiftUI

/// Lightweight search sheet for adventures (used if Home presents search without changing tabs).
struct CatalogSearchSheet: View {
    let lessons: [Lesson]
    let onStartLesson: (Lesson) -> Void
    let onClose: () -> Void

    @State private var searchText = ""

    private var results: CatalogSearchResults {
        CatalogSearch.search(query: searchText, lessons: lessons)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                DesignSystem.Gradients.homeGradient
                    .ignoresSafeArea()
                SoftBubbleAtmosphere(intensity: 0.7)

                List {
                    if searchText.trimmingCharacters(in: .whitespacesAndNewlines).count < 2 {
                        Text("Type at least 2 letters to search.")
                            .foregroundStyle(DesignSystem.Colors.mutedText)
                            .listRowBackground(Color.clear)
                    } else if results.isEmpty {
                        Text("No matches yet.")
                            .foregroundStyle(DesignSystem.Colors.mutedText)
                            .listRowBackground(Color.clear)
                    } else {
                        if !results.lessons.isEmpty {
                            Section("Adventures") {
                                ForEach(results.lessons) { lesson in
                                    Button {
                                        onStartLesson(lesson)
                                        onClose()
                                    } label: {
                                        HStack(spacing: 12) {
                                            TopicIllustrationView(topic: lesson.theme, size: 36, animate: false)
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(lesson.title)
                                                    .foregroundStyle(DesignSystem.Colors.deepNavy)
                                                Text(TopicPalette.displayTitle(for: lesson.theme))
                                                    .font(.caption)
                                                    .foregroundStyle(DesignSystem.Colors.mutedText)
                                            }
                                        }
                                    }
                                    .listRowBackground(DesignSystem.Colors.cardWhite.opacity(0.85))
                                }
                            }
                        }
                        if !results.topics.isEmpty {
                            Section("Worlds") {
                                ForEach(results.topics) { topic in
                                    Text(TopicPalette.displayTitle(for: topic))
                                        .listRowBackground(DesignSystem.Colors.cardWhite.opacity(0.85))
                                }
                            }
                        }
                        if !results.subjects.isEmpty {
                            Section("Subjects") {
                                ForEach(results.subjects) { subject in
                                    Text(subject.worldTitle)
                                        .listRowBackground(DesignSystem.Colors.cardWhite.opacity(0.85))
                                }
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Adventures & worlds")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", action: onClose)
                }
            }
        }
    }
}
