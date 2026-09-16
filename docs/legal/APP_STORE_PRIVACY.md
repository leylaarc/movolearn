# App Store privacy — Launch checklist

This is an internal operator guide. Do not put it in the App Store listing. It must match the running build (`FamilyCloudSync.isEnabled = false`) and [PRIVACY_POLICY.md](PRIVACY_POLICY.md).

**This is not legal advice.** Have counsel review the hosted policy, COPPA posture, and Kids Category listing before you submit.

## Before you submit

1. Host the site in `website/` at **https://movolearn.com**. The App Store privacy URL is **https://movolearn.com/privacy**. Paste that exact URL into App Store Connect → App Privacy and App Information.
2. Terms live at `https://movolearn.com/terms` (optional for a free Kids app; useful next to the privacy URL).
3. Create and monitor **privacy@movolearn.app**. The policy promises parents can write there.
4. Confirm the mailbox, URL, and in-app Privacy screen all describe **on-device Launch** — not parent accounts.
5. Do **not** turn on `FamilyCloudSync` in a build that still uses this policy.

## App Privacy (nutrition labels)

Apple treats data as “collected” when it leaves the device in a way you can associate with the user. Launch does not send child or parent data to Movo Learn.

Answer:

| Question | Answer |
| --- | --- |
| Do you or your third-party partners collect data from this app? | **No, this app does not collect data** |
| Privacy Policy URL | https://movolearn.com/privacy |
| Tracking | **No** (no ATT prompt, no IDFA, `NSPrivacyTracking` is false) |

Do **not** declare Contact Info, Name, or User Content as collected. Those fields stay on device.

`PrivacyInfo.xcprivacy` already matches: tracking false, collected data types empty, UserDefaults accessed for app functionality (`CA92.1`).

## Kids Category

If you list in the Kids Category (recommended for ages 5–8):

- Privacy policy URL is required and must stay accurate.
- No third-party ads or tracking.
- No links out of the app, storefronts, or chat unless they sit behind a parental gate. The in-app Privacy screen is self-contained on purpose — it does not open Safari.
- Age rating must match: typically 4+ if there is no upsetting content.

## COPPA posture (Launch)

The app is **child-directed**. Launch does **not** collect personal information from children onto Movo Learn servers (no name, email, persistent identifier, or lesson data is transmitted to you).

That is why this version uses a notice-and-on-device-control model instead of verifiable parental consent for cloud storage. A checkbox-only consent flow is **not** enough if you later upload child profiles.

If you enable family cloud save later, you typically need all of:

- An updated privacy policy that lists every child data element on the server
- Verifiable parental consent (not only an in-app checkbox)
- Parent email as the account, children still never log in
- Access, correction, and deletion that actually wipe server copies
- A lawyer review before that build ships

## What must stay true in the binary

- `FamilyCloudSync.isEnabled == false`
- No analytics / ads / crash SDKs
- No live AI calls from child sessions
- Birthday stripped on save (`ProfileRepository.stripSensitiveFields`)
- Parent account UI hidden (`ContentView` already gates on the flag)

The unit test `testLaunchPrivacyPolicyMatchesDisabledCloudSync` fails if the flag and the policy copy drift.

## Support and review notes

In App Store Connect review notes you can say:

> Launch is on-device only. The app does not create accounts or send child profile or progress data off the device. Privacy policy: https://movolearn.com/privacy. Open Profile → Privacy in the app for the same text.
