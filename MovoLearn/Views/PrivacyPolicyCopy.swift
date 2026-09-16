import Foundation

/// Canonical Launch privacy policy copy. Keep in lockstep with
/// `docs/legal/PRIVACY_POLICY.md`, `docs/legal/privacy.html`, and
/// `website/privacy/index.html`.
///
/// If you turn on `FamilyCloudSync`, rewrite those documents and this file
/// *before* shipping. The App Store policy URL must match the running build.
enum PrivacyPolicyCopy {
    static let title = "Privacy Policy"
    static let productName = "Movo Learn"
    static let effectiveDate = "September 16, 2026"
    static let lastUpdated = "September 16, 2026"
    static let contactEmail = "privacy@movolearn.app"
    static let publicURLString = "https://movolearn.com/privacy"
    static let bundleID = "com.movolearn.app"

    /// Must stay `false` while `FamilyCloudSync.isEnabled` is `false`.
    static let cloudSyncEnabledInThisVersion = false

    static let headline = "Learning stays on this iPhone or iPad."

    static let summary = """
    This version of Movo Learn does not create an account and does not send a child’s name, age, lesson scores, or anything else about your family to Movo Learn servers. A parent or guardian sets up the app. Children never sign in.
    """

    struct Section: Identifiable {
        let id: String
        let title: String
        let body: String
    }

    static let snapshotCards: [(title: String, body: String)] = [
        (
            "What stays on this device",
            "A first name or nickname for greetings, an age used only to match lesson difficulty, reading and math levels, favorite topics, and learning progress such as lessons finished, scores, streaks, and treasures."
        ),
        (
            "What we do not collect",
            "No last name, full birthday, child email, photos, location, or advertising ID. There are no ads, no tracking, and no analytics SDKs. We do not receive this information on a Movo Learn server."
        ),
        (
            "How to erase it",
            "Open Profile and choose Reset Profile & Progress. Deleting the app also removes this data from the device. This version does not keep a Movo Learn cloud copy."
        ),
        (
            "Children’s privacy",
            "Movo Learn is made for children. Because this version does not send child information to us, we do not collect personal information from children under COPPA. If that ever changes, we will update this policy and ask for parental consent first."
        )
    ]

    static let fullSections: [Section] = [
        Section(
            id: "who",
            title: "1. Who we are",
            body: """
            This Privacy Policy describes how Movo Learn (“Movo Learn,” “we,” “us,” or “our”) handles information in the Movo Learn iOS app (bundle ID \(bundleID)). Movo Learn is a learning game for children, intended for use with a parent or guardian.

            This is the policy for the Launch version of the app, in which family cloud save is turned off. The in-app Privacy screen and the policy we publish at \(publicURLString) are the same document.
            """
        ),
        Section(
            id: "children",
            title: "2. This app is for children",
            body: """
            Movo Learn is directed to children about ages 5–8. Nearby ages may be entered only so the app can match lesson difficulty. Children do not create accounts, do not have passwords, and do not sign in.

            A parent or guardian should set up the profile. We design this version so that we do not collect personal information from children as that term is used in the Children’s Online Privacy Protection Act (COPPA): child profile details stay on the iPhone or iPad and are not sent to Movo Learn.
            """
        ),
        Section(
            id: "on-device",
            title: "3. Information stored on the device (not sent to us)",
            body: """
            A parent or guardian may enter, and the app may keep locally:

            Child profile: a first name or nickname used in greetings; age in years (this version does not keep a full date of birth); reading level, math level, and a learning goal; favorite topics and activity preferences; and a random identifier created on the device so progress can stay attached to that profile on that device only.

            Learning and play progress: lessons started or finished, scores, skills practiced, and times; streaks, rewards, and in-app treasures; home recommendations such as recently opened lessons or topics; and drawings made during a lesson, only while that activity is on the device.

            This information is stored in the app’s sandbox using Apple on-device storage. It is not transmitted to Movo Learn.
            """
        ),
        Section(
            id: "not-collected",
            title: "4. Information we do not collect",
            body: """
            This version does not collect, and is not designed to send us: last name; date of birth or full birthday; a child’s email, phone number, or mailing address; a parent email or password (no Movo Learn account is created); photos, camera, microphone, or contacts; precise or coarse location; advertising identifiers (IDFA) or other tracking IDs; school name, student ID, or government ID; health, fitness, or biometric data; or payment card numbers (this version has no in-app purchases).

            We do not show ads. We do not use Apple’s App Tracking Transparency prompt because we do not track users across other companies’ apps or websites.
            """
        ),
        Section(
            id: "use",
            title: "5. How on-device information is used",
            body: """
            The device uses the stored profile only to greet the child by the name a parent entered; choose lesson difficulty and topics; remember progress, streaks, and rewards; and show a parent-facing learning report on the same device.

            We do not use this information for advertising, to market to children, or to sell data. Lesson answers and drawings are used to check understanding and celebrate progress on the device. They are not posted publicly and are not sent to Movo Learn or used to train public AI models in this version.
            """
        ),
        Section(
            id: "sharing",
            title: "6. We do not sell or share personal information",
            body: """
            We do not sell personal information. We do not share child or parent data with third parties for advertising or analytics, because we do not receive that data from the app.

            Live child sessions do not call Movo Learn or third-party AI services. Lessons are bundled in the app.
            """
        ),
        Section(
            id: "third-parties",
            title: "7. Third-party services, Apple, and the internet",
            body: """
            This version does not include analytics, crash-reporting, advertising, social-network, or login software development kits (SDKs).

            iOS and the App Store are operated by Apple. Apple may process information under Apple’s policies when you download the app, back up a device, or if you have chosen in iOS settings to share analytics or crash data with app developers. That sharing is controlled by Apple and your device settings, not by a Movo Learn SDK. We do not place a crash reporter in the app.
            """
        ),
        Section(
            id: "cloud",
            title: "8. Accounts and future cloud save",
            body: """
            This Policy covers the Launch version. Family cloud save is off. The app does not create a parent account and does not contact Movo Learn servers to store a child profile.

            If we later offer an optional parent account so progress can follow a family across devices, we will update this Policy first, describe exactly what would be stored (for example a parent email and the child’s first name, age, and learning progress), and obtain any required parental consent before that collection begins. We will not enable that feature under this Launch Policy.
            """
        ),
        Section(
            id: "deletion",
            title: "9. Retention and deletion",
            body: """
            On-device data remains until a parent chooses Reset Profile & Progress in Profile, or until the app is deleted from the device. Resetting or deleting the app removes Movo Learn’s stored profile and progress from that device. We cannot erase data we do not have. This version does not keep a Movo Learn cloud copy.

            Device backups (for example a computer backup or an iCloud backup, if a parent has enabled them) are controlled by Apple and the parent’s Apple ID settings. Those backups may include app data until the parent deletes the backup or the app data.
            """
        ),
        Section(
            id: "security",
            title: "10. Security",
            body: """
            We limit what this version stores: no full birthday, no child contact information, and no cloud account. Data stays in the app’s sandbox on the device. No method of storage is perfectly secure — for example if someone unlocks the device. Parents should use a device passcode and share the device only with people they trust.
            """
        ),
        Section(
            id: "coppa",
            title: "11. Parental choices and COPPA",
            body: """
            Parents can enter a nickname instead of a legal name; change age, levels, and interests; review progress in the Learning Report; and erase the profile and progress on the device.

            Because this version does not collect personal information from children on our servers, there is no Movo Learn cloud profile for us to access or delete. If you believe a child has sent personal information to us by some other means (for example in an email you send us), contact us and we will delete it.

            If US law would otherwise require verifiable parental consent for collection, we do not collect that information in this version.
            """
        ),
        Section(
            id: "international",
            title: "12. People outside the United States",
            body: """
            The app stores information on the device where it is used. We do not transfer child learning data to Movo Learn servers in this version. If you contact us by email, that message is processed where we read it.

            If you are in the EEA, UK, or a similar jurisdiction: we are not using the app to collect personal data onto our systems. Device-level storage is under the parent’s control. You may still contact us with questions.
            """
        ),
        Section(
            id: "state-laws",
            title: "13. US state privacy laws (including California)",
            body: """
            We do not sell or share personal information as those terms are used in the California Consumer Privacy Act (CCPA/CPRA) or similar US state laws, because this version does not send us consumer personal information from the app. We do not use or disclose sensitive personal information for purposes other than the on-device app.

            If those laws apply to a request about information you emailed to us, you may request access or deletion of that correspondence at \(contactEmail). We will not discriminate against you for exercising privacy rights.

            The app does not track users across third-party apps or websites. We do not respond to browser Do Not Track signals because the app is not a website and does not track.
            """
        ),
        Section(
            id: "changes",
            title: "14. Changes to this policy",
            body: """
            If we change how Movo Learn handles information — including if we turn on parent accounts or send any child data off the device — we will update this Policy and the in-app Privacy screen, change the “Last updated” date, and, where required by law, obtain parental consent before the new collection begins.
            """
        ),
        Section(
            id: "contact",
            title: "15. Contact",
            body: """
            Questions, parental requests, or privacy complaints: \(contactEmail). You can also read this policy in the app under Profile → Privacy.

            Please do not include a child’s last name, school, or other extra personal details in your email unless they are needed to fulfill your request.
            """
        )
    ]

    static var fullText: String {
        ([summary] + fullSections.map { $0.title + "\n" + $0.body }).joined(separator: "\n\n")
    }
}
