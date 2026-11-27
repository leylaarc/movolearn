import SwiftUI

struct WelcomeView: View {
    let onGetStarted: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            OnboardingBackdrop()

            VStack(spacing: 0) {
                Spacer(minLength: 12)

                VStack(spacing: DesignSystem.Spacing.xl) {
                    WelcomeHeroIllustration()
                        .scaleEffect(appeared ? 1 : 0.88)
                        .opacity(appeared ? 1 : 0)

                    VStack(spacing: DesignSystem.Spacing.md) {
                        Image("BrandLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: DesignSystem.Metrics.scaled(280), maxHeight: DesignSystem.Metrics.scaled(120))
                            .accessibilityLabel("Movo Learn")

                        Text("Short lessons, shaped around your child.")
                            .font(DesignSystem.Typography.screenTitle)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(DesignSystem.Colors.deepNavy)
                            .lineSpacing(4)
                    }
                    .entrance(appeared: appeared, delay: 0.12)
                }

                Spacer()

                OnboardingActionButton(title: "Get Started", action: onGetStarted)
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
