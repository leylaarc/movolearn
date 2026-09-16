import SwiftUI

struct WelcomeView: View {
    let onGetStarted: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            AnimatedGradientBackground()

            SoftBubbleAtmosphere(
                accent: DesignSystem.Colors.skyBlue,
                secondary: DesignSystem.Colors.sunshineYellow,
                tertiary: DesignSystem.Colors.lavenderPurple,
                intensity: 1.2
            )

            VStack(spacing: 0) {
                Spacer(minLength: 12)

                VStack(spacing: DesignSystem.Spacing.xl) {
                    WelcomeHeroIllustration()
                        .scaleEffect(appeared ? 1 : 0.88)
                        .opacity(appeared ? 1 : 0)

                    VStack(spacing: DesignSystem.Spacing.md) {
                        Text("Movo Learn")
                            .font(DesignSystem.Typography.heroTitle)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        DesignSystem.Colors.deepNavy,
                                        DesignSystem.Colors.skyBlue,
                                        DesignSystem.Colors.lavenderPurple
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        Text("Learning built around what your child loves.")
                            .font(DesignSystem.Typography.screenTitle)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(DesignSystem.Colors.deepNavy)
                            .lineSpacing(4)

                        Text("Personalized reading, math, vocabulary, and discovery lessons through their favorite topics.")
                            .font(DesignSystem.Typography.subtitle(16))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(DesignSystem.Colors.mutedText)
                            .lineSpacing(5)
                            .padding(.horizontal, DesignSystem.Spacing.sm)
                    }
                    .entrance(appeared: appeared, delay: 0.12)
                }

                Spacer()

                VStack(spacing: DesignSystem.Spacing.md) {
                    PrimaryGradientButton(
                        title: "Get Started",
                        icon: "arrow.right.circle.fill",
                        action: onGetStarted
                    )

                    Text("Designed for parents. Delightful for kids.")
                        .font(DesignSystem.Typography.captionText)
                        .foregroundStyle(DesignSystem.Colors.textTertiary)
                }
                .padding(.bottom, DesignSystem.Spacing.screenBottom)
                .entrance(appeared: appeared, delay: 0.22)
            }
            .padding(.horizontal, DesignSystem.Spacing.screenPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(DesignSystem.Animation.gentle.delay(0.12)) {
                appeared = true
            }
        }
    }
}

#Preview {
    WelcomeView(onGetStarted: {})
}
