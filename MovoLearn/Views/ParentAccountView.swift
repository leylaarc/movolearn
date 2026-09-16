import SwiftUI

struct ParentAccountView: View {
    var onSignedIn: (FamilyAuthResponse) -> Void
    var onContinueLocally: () -> Void

    @State private var isCreatingAccount = true
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var parentalConsent = false
    @State private var errorMessage: String?
    @State private var isWorking = false

    private var canSubmit: Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.contains("@"), password.count >= 10, !isWorking else { return false }
        if isCreatingAccount {
            return parentalConsent && password == confirmPassword
        }
        return true
    }

    var body: some View {
        ZStack {
            DesignSystem.Colors.backgroundCream
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        Text("PARENT ACCOUNT")
                            .font(DesignSystem.Typography.label())
                            .foregroundStyle(DesignSystem.Colors.skyBlue)
                            .tracking(0.5)
                        Text(isCreatingAccount ? "Keep their progress safe" : "Welcome back")
                            .font(DesignSystem.Typography.headline(28))
                            .foregroundStyle(DesignSystem.Colors.deepNavy)
                        Text("A parent signs in. Learning profiles and lesson history are saved to that account so they follow your family across devices.")
                            .font(DesignSystem.Typography.subtitle(15))
                            .foregroundStyle(DesignSystem.Colors.mutedText)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(spacing: DesignSystem.Spacing.md) {
                        SparkInputCard(icon: "envelope.fill", title: "Parent email", accent: DesignSystem.Colors.skyBlue) {
                            TextField("you@email.com", text: $email)
                                .textFieldStyle(SparkTextFieldStyle())
                                .textContentType(.username)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }

                        SparkInputCard(icon: "lock.fill", title: "Password", accent: DesignSystem.Colors.lavenderPurple) {
                            SecureField("At least 10 characters", text: $password)
                                .textFieldStyle(SparkTextFieldStyle())
                                .textContentType(isCreatingAccount ? .newPassword : .password)
                        }

                        if isCreatingAccount {
                            SparkInputCard(icon: "lock.rotation", title: "Confirm password", accent: DesignSystem.Colors.lavenderPurple) {
                                SecureField("Type it again", text: $confirmPassword)
                                    .textFieldStyle(SparkTextFieldStyle())
                                    .textContentType(.newPassword)
                            }

                            Button {
                                parentalConsent.toggle()
                            } label: {
                                HStack(alignment: .top, spacing: DesignSystem.Spacing.sm) {
                                    Image(systemName: parentalConsent ? "checkmark.square.fill" : "square")
                                        .font(.title3)
                                        .foregroundStyle(DesignSystem.Colors.skyBlue)
                                    Text("I am a parent or guardian, and I consent to Movo Learn storing this child’s first name, age, and learning progress for the family account.")
                                        .font(DesignSystem.Typography.subtitle(14))
                                        .foregroundStyle(DesignSystem.Colors.deepNavy)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            .buttonStyle(.plain)
                            .accessibilityHint("Required before creating an account")
                        }
                    }
                    .sparkCard(accent: DesignSystem.Colors.skyBlue)

                    if let errorMessage {
                        Text(errorMessage)
                            .font(DesignSystem.Typography.subtitle(14))
                            .foregroundStyle(DesignSystem.Colors.coralPink)
                    }

                    PrimaryGradientButton(
                        title: isWorking ? "Please wait…" : (isCreatingAccount ? "Create parent account" : "Sign in"),
                        icon: "person.crop.circle.badge.checkmark",
                        action: submit
                    )
                    .disabled(!canSubmit)
                    .opacity(canSubmit ? 1 : 0.55)

                    Button {
                        isCreatingAccount.toggle()
                        errorMessage = nil
                    } label: {
                        Text(isCreatingAccount ? "I already have a parent account" : "Create a new parent account")
                            .font(DesignSystem.Typography.sectionHeader(15))
                            .foregroundStyle(DesignSystem.Colors.skyBlue)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)

                    Button(action: onContinueLocally) {
                        Text("Continue on this device only")
                            .font(DesignSystem.Typography.captionText)
                            .foregroundStyle(DesignSystem.Colors.textTertiary)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, DesignSystem.Spacing.screenBottom)
                }
                .padding(.horizontal, DesignSystem.Spacing.screenPadding)
                .padding(.top, DesignSystem.Spacing.xl)
            }
        }
    }

    private func submit() {
        guard canSubmit else { return }
        if isCreatingAccount, password != confirmPassword {
            errorMessage = "Passwords need to match."
            return
        }
        isWorking = true
        errorMessage = nil
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = password
        let consent = parentalConsent
        let creating = isCreatingAccount
        Task {
            do {
                let response: FamilyAuthResponse
                if creating {
                    response = try await FamilyAPIClient.shared.register(
                        email: email,
                        password: password,
                        parentalConsent: consent
                    )
                } else {
                    response = try await FamilyAPIClient.shared.login(email: email, password: password)
                }
                await MainActor.run {
                    isWorking = false
                    onSignedIn(response)
                }
            } catch {
                await MainActor.run {
                    isWorking = false
                    errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    ParentAccountView(onSignedIn: { _ in }, onContinueLocally: {})
}
