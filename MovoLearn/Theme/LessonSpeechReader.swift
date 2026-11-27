import AVFoundation
import SwiftUI

/// Speaks lesson text with the system voice. Nothing is recorded or sent off the device.
@MainActor
final class LessonSpeechReader: NSObject, ObservableObject {
    static let shared = LessonSpeechReader()
    static let enabledDefaultsKey = "movo.readAloudEnabled"

    /// Premium and enhanced voices are recorded at the system rate.
    /// Slowing them down flattens the melody, which is what sounds robotic.
    nonisolated static func naturalRate(for voice: AVSpeechSynthesisVoice?) -> Float {
        if voice?.quality == .premium || voice?.quality == .enhanced {
            return AVSpeechUtteranceDefaultSpeechRate
        }
        return min(
            AVSpeechUtteranceMaximumSpeechRate,
            max(AVSpeechUtteranceMinimumSpeechRate, AVSpeechUtteranceDefaultSpeechRate * 0.97)
        )
    }

    @Published private(set) var isSpeaking = false

    private let synthesizer = AVSpeechSynthesizer()
    private var generation = 0
    private var utteranceGeneration: [ObjectIdentifier: Int] = [:]

    /// Missing key means read-aloud is on, so a first lesson is spoken.
    static var isEnabled: Bool {
        let defaults = UserDefaults.standard
        guard defaults.object(forKey: enabledDefaultsKey) != nil else { return true }
        return defaults.bool(forKey: enabledDefaultsKey)
    }

    private override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ lines: [String], rate: Float? = nil) {
        let passages = Self.spokenPassages(from: lines)
        guard !passages.isEmpty else { return }

        generation += 1
        let token = generation
        utteranceGeneration = [:]
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        configureSession()

        let voice = Self.friendlyVoice()
        let speechRate = rate ?? Self.naturalRate(for: voice)
        for (index, passage) in passages.enumerated() {
            let utterance = AVSpeechUtterance(string: passage)
            utterance.voice = voice
            utterance.rate = speechRate
            utterance.pitchMultiplier = 1
            utterance.preUtteranceDelay = index == 0 ? 0.04 : 0.14
            utteranceGeneration[ObjectIdentifier(utterance)] = token
            synthesizer.speak(utterance)
        }
        isSpeaking = true
    }

    func stop() {
        generation += 1
        utteranceGeneration = [:]
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        isSpeaking = false
        deactivateSessionIfIdle()
    }

    private func configureSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try session.setActive(true)
        } catch {
            return
        }
    }

    private func deactivateSessionIfIdle() {
        guard !synthesizer.isSpeaking else { return }
        try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
    }

    /// Ava is the warm spoken-content voice. Premium is preferred, then Enhanced.
    /// Until one of those is installed, reading uses the phone’s built-in English voice.
    nonisolated static func friendlyVoice() -> AVSpeechSynthesisVoice? {
        let ava = AVSpeechSynthesisVoice.speechVoices().filter { $0.name == "Ava" }
        if let premium = ava.first(where: { $0.quality == .premium }) {
            return premium
        }
        if let enhanced = ava.first(where: { $0.quality == .enhanced }) {
            return enhanced
        }
        return AVSpeechSynthesisVoice(language: "en-US")
    }

    nonisolated static var needsAvaDownload: Bool {
        !AVSpeechSynthesisVoice.speechVoices().contains {
            $0.name == "Ava" && ($0.quality == .premium || $0.quality == .enhanced)
        }
    }

    /// Joins sentences into one breath so the voice can use a natural rise and fall.
    /// A new passage starts at a list, a clue, or the answer choices.
    nonisolated static func spokenPassages(from lines: [String]) -> [String] {
        var passages: [String] = []
        var current = ""

        func flush() {
            let trimmed = current.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty {
                passages.append(trimmed)
            }
            current = ""
        }

        for line in lines {
            let cleaned = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !cleaned.isEmpty else { continue }
            if isSpokenBeat(cleaned), !current.isEmpty {
                flush()
            }
            if !current.isEmpty {
                current += " "
            }
            current += cleaned
        }
        flush()
        return passages
    }

    private nonisolated static func isSpokenBeat(_ line: String) -> Bool {
        let key = line.lowercased()
        if key.hasPrefix("clue ") { return true }
        let beats: Set<String> = [
            "the choices are.",
            "on the left.",
            "on the right.",
            "try to add each part.",
            "put these in order.",
            "tap the right answer.",
            "tap a word on the left, then tap its match on the right.",
            "use every clue to choose the best answer.",
            "reveal the first clue when you are ready.",
            "you can make an early guess."
        ]
        return beats.contains(key)
    }

    private func noteUtteranceEnded(_ utterance: AVSpeechUtterance) {
        let token = utteranceGeneration.removeValue(forKey: ObjectIdentifier(utterance))
        guard token == generation else { return }
        guard !utteranceGeneration.values.contains(generation) else { return }
        isSpeaking = false
        deactivateSessionIfIdle()
    }
}

extension LessonSpeechReader: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        let ended = utterance
        Task { @MainActor in
            self.noteUtteranceEnded(ended)
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        let ended = utterance
        Task { @MainActor in
            self.noteUtteranceEnded(ended)
        }
    }
}

/// Speaker control for the page that is on screen.
struct ReadAloudButton: View {
    let isSpeaking: Bool
    var accent: Color = DesignSystem.Colors.skyBlue
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: isSpeaking ? "stop.fill" : "speaker.wave.2.fill")
                    .symbolEffect(.pulse, isActive: isSpeaking)
                Text(isSpeaking ? "Stop" : "Read")
            }
            .font(.padScaled(size: 15, weight: .bold))
            .foregroundStyle(isSpeaking ? Color.white : accent)
            .padding(.horizontal, 12)
            .frame(minHeight: DesignSystem.Metrics.scaled(44))
            .background(isSpeaking ? accent : Color.white.opacity(0.94))
            .clipShape(Capsule())
            .shadow(color: DesignSystem.Colors.softCardShadow, radius: 8, y: 3)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isSpeaking ? "Stop reading" : "Read to me")
        .accessibilityHint(isSpeaking ? "Stops the voice" : "Reads this page out loud")
    }
}
