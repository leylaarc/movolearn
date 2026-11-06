import SwiftUI

enum MainTab: Hashable {
    case home
    case adventures
    case rewards
    case profile

    var title: String {
        switch self {
        case .home: return "Home"
        case .adventures: return "Adventures"
        case .rewards: return "Rewards"
        case .profile: return "Profile"
        }
    }

    var systemImage: String {
        switch self {
        case .home: return "house.fill"
        case .adventures: return "map.fill"
        case .rewards: return "trophy.fill"
        case .profile: return "person.crop.circle.fill"
        }
    }
}

struct MainTabShell<Home: View, Adventures: View, Rewards: View, Profile: View>: View {
    @Binding var selectedTab: MainTab
    @ViewBuilder var home: () -> Home
    @ViewBuilder var adventures: () -> Adventures
    @ViewBuilder var rewards: () -> Rewards
    @ViewBuilder var profile: () -> Profile

    var body: some View {
        TabView(selection: $selectedTab) {
            home()
                .tabItem {
                    Label(MainTab.home.title, systemImage: MainTab.home.systemImage)
                }
                .tag(MainTab.home)

            adventures()
                .tabItem {
                    Label(MainTab.adventures.title, systemImage: MainTab.adventures.systemImage)
                }
                .tag(MainTab.adventures)

            rewards()
                .tabItem {
                    Label(MainTab.rewards.title, systemImage: MainTab.rewards.systemImage)
                }
                .tag(MainTab.rewards)

            profile()
                .tabItem {
                    Label(MainTab.profile.title, systemImage: MainTab.profile.systemImage)
                }
                .tag(MainTab.profile)
        }
        .tint(DesignSystem.Colors.coralPink)
        .symbolEffect(.bounce, value: selectedTab)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 1.0, green: 0.95, blue: 0.86, alpha: 1)
            let selected = UIColor(red: 1.0, green: 0.28, blue: 0.48, alpha: 1)
            let normal = UIColor(red: 0.42, green: 0.48, blue: 0.78, alpha: 1)
            appearance.stackedLayoutAppearance.selected.iconColor = selected
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selected]
            appearance.stackedLayoutAppearance.normal.iconColor = normal
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normal]
            if DesignSystem.Metrics.isPad {
                let titleSize = DesignSystem.Metrics.scaled(13)
                let titleFont = UIFont(name: "AvenirNext-DemiBold", size: titleSize)
                    ?? UIFont.systemFont(ofSize: titleSize, weight: .semibold)
                let layouts = [
                    appearance.stackedLayoutAppearance,
                    appearance.inlineLayoutAppearance,
                    appearance.compactInlineLayoutAppearance
                ]
                for layout in layouts {
                    layout.selected.iconColor = selected
                    layout.normal.iconColor = normal
                    layout.selected.titleTextAttributes = [
                        .foregroundColor: selected,
                        .font: titleFont
                    ]
                    layout.normal.titleTextAttributes = [
                        .foregroundColor: normal,
                        .font: titleFont
                    ]
                }
            }
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
